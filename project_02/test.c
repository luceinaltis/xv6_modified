#include "types.h"
#include "stat.h"
#include "user.h"

#define THREAD_NUMBER 10

int global_counter = 0;

void* start_routine(void* arg)
{
	int local_max = (int)arg;
	int local_counter = 0;
	int i = 0;

	for(i = 0; i < local_max; ++i)
	{
		global_counter++;
		local_counter++;
	}
	thread_exit((void*)local_counter);
}

int main(void)
{
	int i = 0;
	int thread_max = 100011;

	thread_t pid[THREAD_NUMBER];
	int ret_vals[THREAD_NUMBER];

	for(int j = 0; j < 10000; j++)
	{
		for(i = 0; i < THREAD_NUMBER; ++i)
		{
			thread_create(&pid[i], start_routine, (void*)thread_max);
		}


		for(i = 0; i < THREAD_NUMBER; ++i)
		{
			thread_join(pid[i], (void*)&ret_vals[i]);
		}	

		if(j %1000 == 0)
		{
			printf(1, "j : %d\n", j);
		}
	}

	exit();
}
