#include "types.h"
#include "stat.h"
#include "user.h"
#define O_CREATE 0x200
#define NBUF 13

int
main(int argc, char * argv[])
{
    int fd = open("fs.txt",O_CREATE);

    char buf[NBUF] = "hello, world";
    
    write(fd, buf, NBUF);
    write(fd, buf, NBUF);
    write(fd, buf, NBUF);
    write(fd, buf, NBUF);
    write(fd, buf, NBUF);

    close(fd);

    return 0;
}