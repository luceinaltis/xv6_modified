#include "types.h"
#include "x86.h"
#include "defs.h"
#include "date.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"

/* hw1 - yield_wrapper */
int
sys_yield(void)
{
	yield();
	return 0; // not reached
}

int
sys_fork(void)
{
  return fork();
}

int
sys_exit(void)
{
  exit();
  return 0;  // not reached
}

int
sys_wait(void)
{
  return wait();
}

int
sys_kill(void)
{
  int pid;

  if(argint(0, &pid) < 0)
    return -1;
  return kill(pid);
}

int
sys_getppid(void)
{
	return getppid();
}

int
sys_getpid(void)
{
  return myproc()->pid;
}

int
sys_sbrk(void)
{
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
  addr = myproc()->master->sz;
  if(growproc(n) < 0)
    return -1;
  return addr;
}

int
sys_sleep(void)
{
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
  uint xticks;

  acquire(&tickslock);
  xticks = ticks;
  release(&tickslock);
  return xticks;
}

int
sys_getlev(void)
{
	return getlev();
}

int
sys_set_cpu_share(void)
{
	int n;
	if(argint(0, &n) < 0)
	{
		return -1;
	}
	return set_cpu_share(n);
}

int
sys_thread_create(void)
{
	thread_t* thread;
	void* start_routine;
	void* arg;

	if(argint(0, (int*)&thread)<0)
  {
    return -1;
  }

	if(argint(1, (int*)&start_routine))
  {
    return -1;
  }
	if(argint(2, (int*)&arg))
  {
    return -1;
  }
	return thread_create(thread, start_routine, arg);
}

void
sys_thread_exit(void)
{
	void* retval;
	argint(0, (int*)&retval);
	thread_exit(retval);
}

int
sys_thread_join(void)
{
	thread_t thread;
	void** retval;
	if(argint(0, (int*)&thread) < 0)
  {
    return -1;
  }
  
	if(argint(1, (int*)&retval))
  {
    return -1;
  }
	return thread_join(thread, retval);
}
