#include "types.h"
#include "defs.h"

int
printk_str(char * str)
{
	cprintf("%sn", str);
	return 0xABCDABCD;
}

int
sys_myfunction(void)
{
	char * str;

	if(argstr(0, &str) < 0)
	{	
		return -1;
	}
	return printk_str(str);
}
