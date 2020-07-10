#include "types.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "x86.h"
#include "proc.h"
#include "spinlock.h"

extern int stride1;

struct spinlock sched_tickslock;
uint schedticks;

extern struct {
  struct spinlock lock;
  struct proc proc[NPROC];
} ptable;

// hw1
// stride scheduling
// you must get ptable.lock for access to s_table
extern struct stride s_table[NPROC];

// hw1
// MLFQ scheduling
// you must get ptable.lock for access to m_table too
extern struct fq m_table[3];

// ptable을 순회하면서
// 해당 pid에 runnable이 있는지 반환
int
isRunnable(int pid)
{
    struct proc* p;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; ++p)
    {
        if(p->pid == pid && p->state == RUNNABLE)
        {
            return 1;
        }
    }
    return 0;
}

// numLWP의 그룹에서 실행 할 수 있는 프로세스 반환.
struct proc*
pick_lwp(int pid)
{
    struct proc* master_thread = find_master(pid);

    int recent = master_thread->cur;
    do
    {   
        recent = (recent+1)%NPROC;
        if(ptable.proc[recent].state == RUNNABLE && ptable.proc[recent].pid == pid)
        {
            master_thread->cur = recent;
            return &ptable.proc[recent];
        }
    }
    while(master_thread->cur != recent);

    if(ptable.proc[recent].state == RUNNABLE)
    {
        master_thread->cur = recent;
        return &ptable.proc[recent];
    }
    return 0;
}

// Loop over MLFQ in priority order.
struct proc*
pick_mlfq(void)
{
  // Loop over MLFQ in priority order
  for(int prior = 0; prior < 3; ++prior){
      if(m_table[prior].count == 0)
        continue;    

      int recent = m_table[prior].recent_index;
      do
      {   
          recent = (recent+1)%NPROC;

          if(m_table[prior].table[recent].state == USED && isRunnable(m_table[prior].table[recent].pid))
          {
              m_table[prior].recent_index = recent;
              return pick_lwp(m_table[prior].table[recent].pid);
          }
      }
      while(m_table[prior].recent_index != recent);
  }

  return 0;
}

// Find mlfq node pointing numLWP
// And pop from queue all of lwps
int
pop_mlfq(int pid)
{
    // Deconnect the link with mlfq_node
    struct mlfq_node* m;
    for(int prior = 0; prior < 3; ++prior){
        for(m = m_table[prior].table; m < &m_table[prior].table[NPROC]; ++m){
            if(m->pid == pid)
            {
                for(int i = 0; i < NPROC; ++i)
                {
                    if(ptable.proc[i].pid == pid)
                    {
                        ptable.proc[i].schedstate = UNUSED;
                        ptable.proc[i].pmlfq_node = 0;
                    }
                }

                // Deconnect the link with proc
                // Delete info
                m->state = EMPTY;
                m->pid = 0;
                m->eticks = 0;

                m_table[m->prior].count -= 1;
                return 0;
            }
        }
    }

    return -1;
}

// Push this parameter proc to mlfq in highest priority
int
push_mlfq(int pid, int prior)
{
    if(prior < 0 || prior > 2)
    {
        return -1;
    }

    struct proc* p;
    struct mlfq_node* m;

    for(m = m_table[prior].table; m < &m_table[prior].table[NPROC]; ++m)
    {
        if(m->state != EMPTY)
            continue;

        for(p = ptable.proc; p < &ptable.proc[NPROC]; ++p)
        {
            if(p->pid != pid)
                continue;

            // 프로세스 세팅
            p->schedstate = MLFQ;
            p->pmlfq_node = m;
        }

        m_table[prior].count += 1;
        m->pid = pid;
        m->state = USED;
        m->eticks = 0;

        break;
    }

    return 0;
}

// Downgrade selected node's priority
int
move_prior(int pid, int prior) 
{
    // Pop an push for immigration
    if(pop_mlfq(pid) == -1)
    {
        return -1;
    }
    return push_mlfq(pid, prior);
}

// Add tick
// Controll time quantum and time allotment
// Time quantum
//  - The highest priority : 1 tick
//  - Middle priority : 2 ticks
//  - The lowest priority : 4 ticks
// Time allotment
//  - The highest priority : 5 ticks
//  - The middle priority : 10 ticks
// Return 1 if this has to yield
// Return 0 if this doesn't need to yield
int
add_tick(void)
{
    // Calculate pass of current stride

    struct proc* p = myproc();
    struct mlfq_node* m;


    acquire(&ptable.lock);
    add_pass_stride();
    if(p->state != RUNNING)
    {
        release(&ptable.lock);
        return 1;
    }

    acquire(&sched_tickslock);
    int cur_tick = schedticks++;
    release(&sched_tickslock);

    // Stride is not object
    if(p->schedstate != MLFQ)
    {
        if(cur_tick % 5 == 0)
        {
            release(&ptable.lock);
            return 1;
        }
        release(&ptable.lock);
        return 0;
    }

    m = p->pmlfq_node;

    // Calculate Elapsed time tick
    m->eticks += 1;
    int elapsed_ticks = m->eticks;

    switch (m->prior)
    {
    case 0:
        // Check time allotment
        if(elapsed_ticks >= 20){
            move_prior(p->pid, 1);
        }

        if((elapsed_ticks % 5) == 0){
            if(cur_tick >= 200){
                prior_boost();
            }
            release(&ptable.lock);
            return 1;
        }
        else
        {
            release(&ptable.lock);
            return 0;
        }
        break;
    case 1:
        // Check time allotment
        if(elapsed_ticks >= 40){
            move_prior(p->pid, 2);
        }

        if((elapsed_ticks % 10) == 0){
            if(cur_tick >= 200){
                prior_boost();
            }
            release(&ptable.lock);
            return 1;
        }
        else{
            release(&ptable.lock);
            return 0;
        }

        break;
    case 2:

        if((elapsed_ticks % 20) == 0){
            if(cur_tick >= 200){
                prior_boost();
                schedticks = 0;
            }
            release(&ptable.lock);
            return 1;
        }
        else{
            release(&ptable.lock);
            return 0;
        }
        break;
    default:
        release(&ptable.lock);
        return 1;
        break;
    }
    panic("err");
}


// PAGEBREAK: 42
// Per-CPU process scheduler.
// Each CPU calls scheduler() after setting itself up.
// Scheduler never returns.  It loops, doing:
//  - choose a process to run
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
{
  struct proc *p = 0;
  struct proc *cand;
  struct cpu *c = mycpu();
  c->proc = 0;

  for(;;){
    // Enable interrupts on this processor.
    sti();

    acquire(&ptable.lock);
    for(cand = ptable.proc; cand < &ptable.proc[NPROC]; cand++){
        if(cand->state != RUNNABLE)
        {
            continue;
        }
        
        // // Find minimum pass in stride candidates
        p = pick_stride();

        if(p < 0 || p > &ptable.proc[NPROC])
        {
            p = cand;
        }

        
        // Switch to chosen process.  It is the process's job
        // to release ptable.lock and then reacquire it
        // before jumping back to us.
        c->proc = p;
        switchuvm(p);
        p->state = RUNNING;

        swtch(&(c->scheduler), p->context);
        switchkvm();

        // Process is done running for now.
        // It should have changed its p->state before coming back.
        c->proc = 0;
        
    }
    release(&ptable.lock);
  }
}

// Find min pass in s_table
// There is no need to take ptable.lock
struct proc*
pick_stride(void)
{
    struct stride* s;
    struct stride* ret = &s_table[0];
    for(s = s_table; s < &s_table[NPROC]; ++s){
        if(s->state != USED){
            continue;
        }

        if(isRunnable(s->pid) == 0)
            continue;


        if(ret->pass > s->pass){
            ret = s;
        }
    }

    if(ret == s_table){
        struct proc* p = pick_mlfq();

        if(p == 0){
            int minimum = 1000000000;
            for(s = s_table; s < &s_table[NPROC]; ++s){
                if(s->state == EMPTY)
                    continue;

                if(!isRunnable(s->pid))
                {
                    continue;
                }

                if(minimum > s->pass){
                    minimum = s->pass;
                    ret = s;
                }
            }

            return pick_lwp(ret->pid);
        }
        return p;
    }

    
    return pick_lwp(ret->pid);
}

// Add pass to this stride
void
add_pass_stride(void)
{
    struct stride* s = myproc()->pstride;

    s->pass += s->stride;

    // Check whether it is overflow or not
    if(s->pass > 100000000){
        for(s = s_table; s < &s_table[NPROC]; ++s){
            if(s->state != USED)
                continue;
            
            s->pass = 0;
        }
    }
}


// Set for CPU share
int
set_cpu_share(int inquire)
{
    int min_pass = 1000000000;
    struct stride* s;
    struct proc* p;
    struct proc* curproc = myproc();
    struct proc* master_thread = find_master(curproc->pid);

    if(inquire <= 0 || inquire > 80)
        return -1;

    if(myproc()->schedstate == STRIDE){
        return -1;
    }

    // Calculate already assigned value's sum
    int sum = inquire;
    for(int i = 1; i < NPROC; ++i){
        if(s_table[i].state == USED)
        {
            sum += s_table[i].tickets;

            if(min_pass > s_table[i].pass)
            {
                min_pass = s_table[i].pass;
            }
        }
    }

    if(min_pass > s_table[0].pass)
    {
        min_pass = s_table[0].pass;
    }

    if(sum > 80)
      return -1;


    acquire(&ptable.lock);
    
    pop_mlfq(master_thread->pid);
    for(s = &s_table[1];s < &s_table[NPROC]; s++)
    {
        if(s->state == EMPTY)
            break;
    }

    // New stride is assigned into s
    s->tickets = inquire;
    s->stride = stride1/(s->tickets);
    s->pass = min_pass;
    s->state = USED;
    s->pid = master_thread->pid;
    
    // MLFQ stride
    s_table->tickets -= inquire;
    s_table->stride = stride1/(s_table->tickets);

    // Link processes with stride
    for(p = ptable.proc; p < &ptable.proc[NPROC]; ++p)
    {
        if(p->pid != master_thread->pid)
            continue;

        p->schedstate = STRIDE;
        p->pstride = s;
    }
    release(&ptable.lock);

    return 0;
}

int
getlev(void)
{
    struct proc* p = myproc();

    if(p->schedstate == STRIDE)
        return -1;

    return p->pmlfq_node->prior;
}

// Priority boost evry 200 ticks
void
prior_boost(void)
{  
    struct mlfq_node* m;

    for(int prior = 0; prior < 3; ++prior)
    {
        if(m_table[prior].count == 0)
            continue;

        for(m = m_table[prior].table; m < &m_table[prior].table[NPROC]; ++m){
            if(m->state != USED)
                continue;
            move_prior(m->pid, 0);
        }
    }

    acquire(&sched_tickslock);
    schedticks = 0;
    release(&sched_tickslock);
}

