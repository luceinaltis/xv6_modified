#include "types.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "x86.h"
#include "proc.h"
#include "spinlock.h"

struct {
  struct spinlock lock;
  struct proc proc[NPROC];
} ptable;

// hw1
// stride scheduling
// you must get ptable.lock for access to s_table
struct stride s_table[NPROC];

// hw1
// MLFQ scheduling
// you must get ptable.lock for access to m_table too
struct fq m_table[3];

int stride1 = (1 << 20);

static struct proc *initproc;

int nextpid = 1;
extern void forkret(void);
extern void trapret(void);

static void wakeup1(void *chan);

void
exec_delete_thread(struct proc* cur)
{
  struct proc* p;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
  {
    if(cur->master == p->master&& p != cur)
    {
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
        p->state = RUNNABLE;
    }
  }

  cur->schedstate = UNUSED;
  cur->pmlfq_node = 0;
  cur->pstride = 0;
  
  cur->pid = nextpid++;
  cur->tid = 1;
  cur->parent = initproc;
  cur->master = cur;

  push_mlfq(cur->pid, 0);

  release(&ptable.lock);
}

// Delete thread part process
// Returne 0 , if finish normally
void
delete_thread(struct proc* p)
{
  struct proc* master_thread = find_master(p->pid);

  // 만약 지울 쓰레드가 master_thread라면
  if(p->tid == 1)
  {
    p->stack_size = 0;

    if(p->schedstate == MLFQ)
    {
      p->pmlfq_node->state = EMPTY;
      p->pmlfq_node->pid = 0;
    }
    else if(p->schedstate == STRIDE)
    {
      s_table->tickets += p->pstride->tickets;
      s_table->stride = stride1/(s_table->tickets);

      p->pstride->state = EMPTY;
      p->pstride->tickets = 0;
      p->pstride->pass = 0;
      p->pstride->stride = 0;
      p->pstride->pid = 0;
    }



    p->schedstate = MLFQ;
    p->pstride = 0;
    p->pmlfq_node = 0;

    p->stack_size = 0;

    freevm(p->pgdir);
  }

  kfree(p->kstack);
  p->kstack = 0;
  p->master = 0;
  p->pid = 0;
  p->tid = 0;
  p->parent = 0;
  p->name[0] = 0;
  p->killed = 0;
  p->state = UNUSED;

  master_thread->stack[master_thread->stack_size++] = p->base;
  deallocuvm(p->pgdir, p->sz, p->base);

  p->sz = 0;
  p->base = 0;

}



// Return master thread of parameter pid process
struct proc*
find_master(int pid)
{
  struct proc* p;
  
  for(p = ptable.proc; p < &ptable.proc[NPROC]; ++p)
  {
    if(p->pid == pid && p->tid == 1)
    {
      return p;
    }
  }

  return 0;
}

void
pinit(void)
{
  initlock(&ptable.lock, "ptable");
}

// Must be called with interrupts disabled
int
cpuid() {
  return mycpu()-cpus;
}

// Must be called with interrupts disabled to avoid the caller being
// rescheduled between reading lapicid and running through the loop.
struct cpu*
mycpu(void)
{
  int apicid, i;
  
  if(readeflags()&FL_IF)
    panic("mycpu called with interrupts enabled\n");
  
  apicid = lapicid();
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
    if (cpus[i].apicid == apicid)
      return &cpus[i];
  }
  panic("unknown apicid\n");
}

// Disable interrupts so that we are not rescheduled
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
  c = mycpu();
  p = c->proc;
  popcli();
  return p;
}

//PAGEBREAK: 32
// Look in the process table for an UNUSED proc.
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
  struct proc *p;
  char *sp;


  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == UNUSED)
      goto found;

  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;

  // my code
  p->tid = 1;
  p->parent = p;
  p->master = p;
  p->stack_size = 0;
  p->cur = 0;
  p->base = p->sz;
  p->pgdir = 0;

  release(&ptable.lock);

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
    p->state = UNUSED;
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
  p->tf = (struct trapframe*)sp;

  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
  p->context->eip = (uint)forkret;

  push_mlfq(p->pid, 0);  // When process is allocated, it pushed into MLFQ
  
  p->pstride = s_table;
  p->schedstate = MLFQ;
  return p;
}

//PAGEBREAK: 32
// Set up first user process.
void
userinit(void)
{
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];
  struct stride* s;
  
  // Set s_table
  for(s = s_table; s < &s_table[NPROC]; s++){
    s->isMLFQ = 0;
    s->state = EMPTY;
    s->pass = 0;
    s->stride = 0;
    s->pid = 0;
  }

  // Set m_table
  for(int prior = 0; prior < 3; ++prior){
    m_table[prior].count = 0;
    m_table[prior].recent_index = 0;
    for(int i = 0; i < NPROC; ++i){
      m_table[prior].table[i].eticks = 0;
      m_table[prior].table[i].prior = prior;
      m_table[prior].table[i].state = EMPTY;
      m_table[prior].table[i].pid = 0;
    }
  }

  p = allocproc();

  // Set first stride as scheduler
  s_table[0].isMLFQ = 1;
  s_table[0].state = USED;
  s_table[0].tickets = 100;
  s_table[0].stride = stride1/(s_table[0].tickets);
  
  initproc = p;
  if((p->pgdir = setupkvm()) == 0)
    panic("userinit: out of memory?");
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
  p->sz = PGSIZE;
  memset(p->tf, 0, sizeof(*p->tf));
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
  p->tf->es = p->tf->ds;
  p->tf->ss = p->tf->ds;
  p->tf->eflags = FL_IF;
  p->tf->esp = PGSIZE;
  p->tf->eip = 0;  // beginning of initcode.S

  safestrcpy(p->name, "initcode", sizeof(p->name));
  p->cwd = namei("/");

  // this assignment to p->state lets other cores
  // run this process. the acquire forces the above
  // writes to be visible, and the lock is also needed
  // because the assignment might not be atomic.

  acquire(&ptable.lock);

  p->state = RUNNABLE;

  release(&ptable.lock);

}

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
  uint sz;
  struct proc *curproc = myproc();
  struct proc *master_thread = curproc->master;

  sz = master_thread->sz;
  if(n > 0){
    if((sz = allocuvm(master_thread->pgdir, sz, sz + n)) == 0)
      return -1;
  } else if(n < 0){
    if((sz = deallocuvm(master_thread->pgdir, sz, sz + n)) == 0)
      return -1;
  }
  master_thread->sz = sz;
  switchuvm(curproc);
  return 0;
}

// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
  int i, pid;
  struct proc *np;
  struct proc *curproc = myproc();
  struct proc *master_thread = curproc->master;


  // Allocate process.
  if((np = allocproc()) == 0){
    return -1;
  }

  // Copy process state from proc.
  if((np->pgdir = copyuvm(master_thread->pgdir, master_thread->sz)) == 0){
    kfree(np->kstack);
    np->kstack = 0;
    np->state = UNUSED;
    return -1;
  }

  np->sz = curproc->sz;
  np->parent = curproc;
  *np->tf = *curproc->tf;

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
    if(curproc->ofile[i])
      np->ofile[i] = filedup(curproc->ofile[i]);
  np->cwd = idup(curproc->cwd);

  safestrcpy(np->name, curproc->name, sizeof(curproc->name));

  pid = np->pid;

  acquire(&ptable.lock);

  np->state = RUNNABLE;

  release(&ptable.lock);

  return pid;
}

// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
  struct proc *curproc = myproc();
  struct proc *p;

  int fd;

  if(curproc == initproc)
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd]){
      fileclose(curproc->ofile[fd]);
      curproc->ofile[fd] = 0;
    }
  }

  begin_op();
  iput(curproc->cwd);
  end_op();
  curproc->cwd = 0;

  //---------------------//
  acquire(&ptable.lock);


  if (curproc->tid != 1){
    curproc->master->killed = 1;
    wakeup1(curproc->master);
  }

  // Set child LWP group as child of initproc
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid != curproc->pid && p->parent == curproc->master){
      p->parent = initproc;
      if(p->state == ZOMBIE)
        wakeup1(initproc);
    }
  }
      
  if(curproc->tid == 1)
  {
    for(;;)
    {
      int kids = 0;
      for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
        if(p->master != curproc->master)
          continue;
        
        if(p == curproc)
          continue;

        if(p->state == ZOMBIE){
          // Found one.
          delete_thread(p);
        }
        else if(p->state != UNUSED)
        {
          kids++;
          p->killed = 1;
          wakeup1(p);
        }
      }

      if(kids != 0)
      {
        sleep(curproc, &ptable.lock);
      }
      else
      {
        break;
      }
    }
  }

  curproc->state = ZOMBIE;
  wakeup1(curproc->parent);
  wakeup1(curproc->master);
  sched();
  panic("zombie exit");
}

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
  struct proc *p;
  int havekids, pid;
  struct proc *curproc = myproc();
  
  acquire(&ptable.lock);
  for(;;){
    // cprintf("%d %d wait\n", curproc->pid, curproc->tid);
    // Scan through table looking for exited children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if(p->parent != curproc)
        continue;

      havekids = 1;
      if(p->state == ZOMBIE){
        pid = p->pid;

        delete_thread(p);

        release(&ptable.lock);
        return pid;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || curproc->killed){
      release(&ptable.lock);
      return -1;
    }

    wakeup1(curproc->parent);
    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
  }
}


// Enter scheduler.  Must hold only ptable.lock
// and have changed proc->state. Saves and restores
// intena because intena is a property of this
// kernel thread, not this CPU. It should
// be proc->intena and proc->ncli, but that would
// break in the few places where a lock is held but
// there's no process.
void
sched(void)
{
  int intena;
  struct proc *p = myproc();

  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
  if(mycpu()->ncli != 1)
    panic("sched locks");
  if(p->state == RUNNING)
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");
  intena = mycpu()->intena;
  swtch(&p->context, mycpu()->scheduler);
  mycpu()->intena = intena;
}

void
sched_thread(void)
{
  int intena;
  struct cpu *c = mycpu();
  struct proc *p = myproc();
  struct proc *next;

  if(!holding(&ptable.lock))
    panic("sched_thread ptable.lock");
  if(mycpu()->ncli != 1)
    panic("sched_thread locks");
  if(p->state == RUNNING)
    panic("sched_thread running");
  if(readeflags()&FL_IF)
    panic("sched_thread interruptible");
  intena = mycpu()->intena;

  next = pick_lwp(p->pid);
  c->proc = next;
  next->state = RUNNING;

  if(next != p)
  {
    switchuvm1(next);
    swtch(&(p->context), next->context);
  }
  mycpu()->intena = intena;
}

// Give up the CPU for one scheduling round.
void
yield(void)
{
  acquire(&ptable.lock);  //DOC: yieldlock
  myproc()->state = RUNNABLE;
  sched();
  release(&ptable.lock);
}

// Yield for thread changing
void
yield_thread(void)
{
  acquire(&ptable.lock);  //DOC: yieldlock
  myproc()->state = RUNNABLE;
  sched_thread();
  release(&ptable.lock);
}

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);

  if (first) {
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot
    // be run from main().
    first = 0;
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
  struct proc *p = myproc();
  
  if(p == 0)
    panic("sleep");

  if(lk == 0)
    panic("sleep without lk");

  // Must acquire ptable.lock in order to
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){  //DOC: sleeplock0
    acquire(&ptable.lock);  //DOC: sleeplock1
    release(lk);
  }
  // Go to sleep.
  p->chan = chan;
  p->state = SLEEPING;

  sched();

  // Tidy up.
  p->chan = 0;

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
    acquire(lk);
  }
}

//PAGEBREAK!
// Wake up all processes sleeping on chan.
// The ptable lock must be held.
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == SLEEPING && p->chan == chan)
      p->state = RUNNABLE;
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
  acquire(&ptable.lock);
  wakeup1(chan);
  release(&ptable.lock);
}

// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
  struct proc *p;
  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == pid){
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
        p->state = RUNNABLE;
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}

//PAGEBREAK: 36
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
  static char *states[] = {
  [UNUSED]    "unused",
  [EMBRYO]    "embryo",
  [SLEEPING]  "sleep ",
  [RUNNABLE]  "runble",
  [RUNNING]   "run   ",
  [ZOMBIE]    "zombie"
  };
  int i;
  struct proc *p;
  struct stride *s;
  struct mlfq_node *m;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
      state = states[p->state];
    else
      state = "???";
    cprintf("pid:%d tid:%d     %s  %s  killed : %d ::parent pid:%d %d\n", p->pid, p->tid, state, p->name,p->killed ,p->parent->pid, p->parent->tid);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
  }
  cprintf("-----\n");
  for(s = s_table; s < &s_table[NPROC]; ++s)
  {
    if(s->state == EMPTY)
      continue;
    cprintf("s->pid:%d  s->pass:%d\n", s->pid, s->pass);
  }
  cprintf("-----\n");
  for(int prior = 0 ;prior<3; ++prior)
  {
    for(m = m_table[prior].table; m < &m_table[prior].table[NPROC]; ++m)
    {
      if(m->state == EMPTY)
        continue;
      cprintf("m->pid:%d  m->eticks:%d\n", m->pid, m->eticks);
    }
  }
  cprintf("-----\n");
}

int
getppid(void)
{
	return myproc()->parent->pid;
}

// Create new thread
int 
thread_create(thread_t * thread, void *(*start_routine)(void *), void *arg)
{
  int next_tid = 1;
  uint sp, sz, base;
  struct proc *np; 
  struct proc *curproc = myproc(); 
  struct proc *master_thread = curproc->master;
  struct proc *p;
  uint ustack[2];

  acquire (&ptable.lock);
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
  {
    if (p->pid == curproc->pid)
    {
      if (p->tid > next_tid)
      {
	      next_tid = p->tid;
      }
    }
  }
  next_tid++;
  release(&ptable.lock);

  // allocate thread
  if((np = allocproc()) == 0){
    panic("alloc 실패\n");
    return -1;
  }
  np->pmlfq_node->pid = 0;
  np->pmlfq_node->state = EMPTY;
  np->pmlfq_node->eticks = 0;

  // If there is empty space, reallocate the space into new user stack
  if(master_thread->stack_size > 0)
  {
    base = master_thread->stack[--(master_thread->stack_size)];
  }
  else
  {
    base = master_thread->sz;
    master_thread->sz += 2*PGSIZE;
  }

  if((sz = allocuvm(master_thread->pgdir, base, base + 2*PGSIZE)) == 0)
  {
    np->state = UNUSED;
    return -1;
  }
  clearpteu(master_thread->pgdir, (char*)(sz - 2*PGSIZE));
  // Make new stack
  sp = sz;

  ustack[0] = 0xffffffff;  // fake return PC
  ustack[1] = (uint)arg;

  sp -= 8;
  if(copyout(master_thread->pgdir, sp, ustack, 8) < 0)
  {
    deallocuvm(master_thread->pgdir, base+2*PGSIZE, base);
    master_thread->stack[(master_thread->stack_size)++] = base;
    np->state = UNUSED;
    return -1;
  }

  for(int i = 0; i < NOFILE; i++)
    if(master_thread->ofile[i])
      np->ofile[i] = filedup(master_thread->ofile[i]);
  np->cwd = idup(master_thread->cwd);

  safestrcpy(np->name, master_thread->name, sizeof(master_thread->name)); // copy process name


  np->tid = next_tid; // set tid
  np->pid = curproc->pid; // set pid as same with master

  np->base = base;
  np->pgdir = master_thread->pgdir; // share page table with master thread
  np->sz = sz; // same memory size with master thread
  np->parent = curproc; // parent is current thread
  np->master = master_thread; // but master thread is same pid, tid == 1
  *np->tf = *master_thread->tf; // same trap frame for current syscall

  np->schedstate = master_thread->schedstate;
  np->pstride = master_thread->pstride;
  np->pmlfq_node = master_thread->pmlfq_node;

  // moving arg to function
  np->tf->eip = (uint)start_routine;
  np->tf->esp = (uint)sp; // top of stack
  np->tf->eax = 0;
 
  *thread = np->tid;

  // change state
  acquire(&ptable.lock);
  np->state = RUNNABLE;
  release(&ptable.lock);

  return 0;
}

// Exit thread
void
thread_exit(void *retval)
{
  struct proc *p;
  struct proc *curproc = myproc();
  int fd;

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd]){
      fileclose(curproc->ofile[fd]);
      curproc->ofile[fd] = 0;
    }
  }

  begin_op();
  iput(curproc->cwd);
  end_op();
  curproc->cwd = 0;

  acquire(&ptable.lock);
  
  // Save retval temporarily
  curproc->retVal = retval;

  // Master process might be sleeping in wait().
  wakeup1(curproc->master);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->parent == curproc || p->master == curproc){
      p->parent = initproc;
      if(p->state == ZOMBIE)
        wakeup1(initproc);
    }
  }

  // Jump into the scheduler, never to return.
  curproc->state = ZOMBIE;
  sched();
  panic("zombie exit");
  // never reach
}

// Wait until the thread is finished
int
thread_join(thread_t thread, void **retval)
{
  struct proc *p;
  struct proc *curproc = myproc();
  int kids;

  if(curproc->tid != 1){
    return -1;
  }

  acquire(&ptable.lock);
  for(;;){
    kids = 0;
    // Scan through table looking for exited slave threads.
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if(p->pid != curproc->pid|| p->tid != thread)
        continue;

      kids = 1;

      if(p->state == ZOMBIE){
        *retval = p->retVal;
        delete_thread(p);
        release(&ptable.lock);
        return 0;
      }
      
    }

    if(!kids || curproc->killed){

      release(&ptable.lock);
      return -1;
    }
    sleep(curproc->master, &ptable.lock);
  }
}
