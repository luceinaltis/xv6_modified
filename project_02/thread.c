#include "types.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "x86.h"
#include "proc.h"
#include "spinlock.h"

// process just sharing same page table
typedef unsigned long thread_t;

extern struct {
  struct spinlock lock;
  struct proc proc[NPROC];
} ptable;

// project 01
// stride scheduling
// you must get ptable.lock for access to s_table
extern struct stride s_table[NPROC];

// project 01
// MLFQ scheduling
// you must get ptable.lock for access to m_table too
extern struct fq m_table[3];


