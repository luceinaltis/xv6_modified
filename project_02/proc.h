// Per-CPU state
struct cpu {
  uchar apicid;                // Local APIC ID
  struct context *scheduler;   // swtch() here to enter scheduler
  struct taskstate ts;         // Used by x86 to find stack for interrupt
  struct segdesc gdt[NSEGS];   // x86 global descriptor table
  volatile uint started;       // Has the CPU started?
  int ncli;                    // Depth of pushcli nesting.
  int intena;                  // Were interrupts enabled before pushcli?
  struct proc *proc;           // The process running on this cpu or null
};

extern struct cpu cpus[NCPU];
extern int ncpu;

//PAGEBREAK: 17
// Saved registers for kernel context switches.
// Don't need to save all the segment registers (%cs, etc),
// because they are constant across kernel contexts.
// Don't need to save %eax, %ecx, %edx, because the
// x86 convention is that the caller has saved them.
// Contexts are stored at the bottom of the stack they
// describe; the stack pointer is the address of the context.
// The layout of the context matches the layout of the stack in swtch.S
// at the "Switch stacks" comment. Switch doesn't save eip explicitly,
// but it is on the stack and allocproc() manipulates it.
struct context {
  uint edi;
  uint esi;
  uint ebx;
  uint ebp;
  uint eip;
};

enum procstate { UNUSED, EMBRYO, SLEEPING, RUNNABLE, RUNNING, ZOMBIE };

/* hw1 */
enum stridestate { USED, EMPTY, MLFQ, STRIDE };



// Per-stride state
struct stride {
  int tickets;               // If stride, proportion of cpu sharing
  int stride;                // If stride, stride1/tickets
  int pass;                  // If stride
  int pid;
  int isMLFQ;                // It is 1, if it is stride for MLFQ
  enum stridestate state;    // Check whether this node can run
};

// Per-mlfq_node state
// Vertex of linked list for MLFQ
struct mlfq_node {
  enum stridestate state;     // Check whether this node can run
  int eticks;                 // Elapsed ticks
  int pid;
  int prior;                  // For checking priority in mlfq_node
};


// Per-feedback queue state
struct fq {
  struct mlfq_node table[NPROC];     // First of linked list
  int count;                         // Number of running processes in this queue
  int recent_index;                  // Save recently implemented node index
};

// Per-process state
struct proc {
  uint sz;                     // Size of process memory (bytes)
  pde_t* pgdir;                // Page table
  char *kstack;                // Bottom of kernel stack for this process
  enum procstate state;        // Process state
  int pid;                     // Process ID
  struct proc *parent;         // Parent process
  struct trapframe *tf;        // Trap frame for current syscall
  struct context *context;     // swtch() here to run process
  void *chan;                  // If non-zero, sleeping on chan
  int killed;                  // If non-zero, have been killed
  struct file *ofile[NOFILE];  // Open files
  struct inode *cwd;           // Current directory
  char name[16];               // Process name (debugging)

  /* project1 */
  enum stridestate schedstate;
  struct stride* pstride;
  struct mlfq_node* pmlfq_node;

  /* project2 */
  void *retVal;                // Save return value
  int tid;                     // Thread id
  struct proc *master;         // Save thread's master
  int base;
  int cur;           // Save recent excuted process, for fairness
  int stack_size;            // Create stack for reuse the user stack
  uint stack[NPROC];
};

// Process memory is laid out contiguously, low addresses first:
//   text
//   original data and bss
//   fixed-size stack
//   expandable heap
