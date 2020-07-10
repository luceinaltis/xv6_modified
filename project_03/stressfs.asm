
_stressfs:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "fs.h"
#include "fcntl.h"

int
main(int argc, char *argv[])
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	57                   	push   %edi
   e:	56                   	push   %esi
   f:	53                   	push   %ebx
  10:	51                   	push   %ecx
  int fd, i;
  char path[] = "stressfs0";
  char data[512];
  char pdata[6] = "hello";
  11:	bb 6f 00 00 00       	mov    $0x6f,%ebx
  char path[] = "stressfs0";
  16:	b9 30 00 00 00       	mov    $0x30,%ecx
{
  1b:	81 ec 20 02 00 00    	sub    $0x220,%esp
  char pdata[6] = "hello";
  21:	66 89 9d dc fd ff ff 	mov    %bx,-0x224(%ebp)

  printf(1, "stressfs starting\n");
  memset(data, 'a', sizeof(data));
  28:	8d 9d e8 fd ff ff    	lea    -0x218(%ebp),%ebx
  printf(1, "stressfs starting\n");
  2e:	68 08 09 00 00       	push   $0x908
  33:	6a 01                	push   $0x1
  char path[] = "stressfs0";
  35:	66 89 8d e6 fd ff ff 	mov    %cx,-0x21a(%ebp)
  3c:	c7 85 de fd ff ff 73 	movl   $0x65727473,-0x222(%ebp)
  43:	74 72 65 
  46:	c7 85 e2 fd ff ff 73 	movl   $0x73667373,-0x21e(%ebp)
  4d:	73 66 73 
  char pdata[6] = "hello";
  50:	c7 85 d8 fd ff ff 68 	movl   $0x6c6c6568,-0x228(%ebp)
  57:	65 6c 6c 
  printf(1, "stressfs starting\n");
  5a:	e8 51 05 00 00       	call   5b0 <printf>
  memset(data, 'a', sizeof(data));
  5f:	83 c4 0c             	add    $0xc,%esp
  62:	68 00 02 00 00       	push   $0x200
  67:	6a 61                	push   $0x61
  69:	53                   	push   %ebx
  6a:	e8 f1 01 00 00       	call   260 <memset>
  //     break;

  // printf(1, "write %d\n", i);

  // path[8] += i;
  fd = open(path, O_CREATE | O_RDWR);
  6f:	5e                   	pop    %esi
  70:	8d 85 de fd ff ff    	lea    -0x222(%ebp),%eax
  76:	be 2c 01 00 00       	mov    $0x12c,%esi
  7b:	5f                   	pop    %edi
  7c:	68 02 02 00 00       	push   $0x202
  81:	50                   	push   %eax
  82:	e8 bb 03 00 00       	call   442 <open>
  87:	83 c4 10             	add    $0x10,%esp
  8a:	89 c7                	mov    %eax,%edi
  8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(i = 0; i < 300; i++)
    write(fd, data, sizeof(data));
  90:	83 ec 04             	sub    $0x4,%esp
  93:	68 00 02 00 00       	push   $0x200
  98:	53                   	push   %ebx
  99:	57                   	push   %edi
  9a:	e8 83 03 00 00       	call   422 <write>
  for(i = 0; i < 300; i++)
  9f:	83 c4 10             	add    $0x10,%esp
  a2:	83 ee 01             	sub    $0x1,%esi
  a5:	75 e9                	jne    90 <main+0x90>
//    printf(fd, "%d\n", i);
  close(fd);
  a7:	83 ec 0c             	sub    $0xc,%esp

  printf(1, "read\n");

  fd = open(path, O_RDONLY);
  aa:	be 64 00 00 00       	mov    $0x64,%esi
  close(fd);
  af:	57                   	push   %edi
  b0:	e8 75 03 00 00       	call   42a <close>
  printf(1, "read\n");
  b5:	5f                   	pop    %edi
  b6:	58                   	pop    %eax
  b7:	68 1b 09 00 00       	push   $0x91b
  bc:	6a 01                	push   $0x1
  be:	e8 ed 04 00 00       	call   5b0 <printf>
  fd = open(path, O_RDONLY);
  c3:	58                   	pop    %eax
  c4:	8d 85 de fd ff ff    	lea    -0x222(%ebp),%eax
  ca:	5a                   	pop    %edx
  cb:	6a 00                	push   $0x0
  cd:	50                   	push   %eax
  ce:	e8 6f 03 00 00       	call   442 <open>
  d3:	83 c4 10             	add    $0x10,%esp
  d6:	89 c7                	mov    %eax,%edi
  d8:	90                   	nop
  d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for (i = 0; i < 100; i++)
    read(fd, data, sizeof(data));
  e0:	83 ec 04             	sub    $0x4,%esp
  e3:	68 00 02 00 00       	push   $0x200
  e8:	53                   	push   %ebx
  e9:	57                   	push   %edi
  ea:	e8 2b 03 00 00       	call   41a <read>
  for (i = 0; i < 100; i++)
  ef:	83 c4 10             	add    $0x10,%esp
  f2:	83 ee 01             	sub    $0x1,%esi
  f5:	75 e9                	jne    e0 <main+0xe0>
  close(fd);
  f7:	83 ec 0c             	sub    $0xc,%esp
  fa:	57                   	push   %edi
  fb:	e8 2a 03 00 00       	call   42a <close>

  /* ------------------------------------------------------- */
  printf(1, "pwrite\n", i);
 100:	83 c4 0c             	add    $0xc,%esp
 103:	6a 64                	push   $0x64
 105:	68 21 09 00 00       	push   $0x921
 10a:	6a 01                	push   $0x1
 10c:	e8 9f 04 00 00       	call   5b0 <printf>

  fd = open(path, O_RDWR);
 111:	59                   	pop    %ecx
 112:	8d 85 de fd ff ff    	lea    -0x222(%ebp),%eax
 118:	5e                   	pop    %esi
 119:	6a 02                	push   $0x2
 11b:	50                   	push   %eax
 11c:	be 14 00 00 00       	mov    $0x14,%esi
 121:	e8 1c 03 00 00       	call   442 <open>
 126:	83 c4 10             	add    $0x10,%esp
 129:	89 c7                	mov    %eax,%edi
 12b:	90                   	nop
 12c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(i = 0; i < 20; i++)
    pwrite(fd, pdata, sizeof(pdata), 3);
 130:	8d 85 d8 fd ff ff    	lea    -0x228(%ebp),%eax
 136:	6a 03                	push   $0x3
 138:	6a 06                	push   $0x6
 13a:	50                   	push   %eax
 13b:	57                   	push   %edi
 13c:	e8 a9 03 00 00       	call   4ea <pwrite>
  for(i = 0; i < 20; i++)
 141:	83 c4 10             	add    $0x10,%esp
 144:	83 ee 01             	sub    $0x1,%esi
 147:	75 e7                	jne    130 <main+0x130>
  close(fd);
 149:	83 ec 0c             	sub    $0xc,%esp

  fd = open(path, O_RDONLY);
 14c:	be 14 00 00 00       	mov    $0x14,%esi
  close(fd);
 151:	57                   	push   %edi
 152:	e8 d3 02 00 00       	call   42a <close>
  fd = open(path, O_RDONLY);
 157:	58                   	pop    %eax
 158:	8d 85 de fd ff ff    	lea    -0x222(%ebp),%eax
 15e:	5a                   	pop    %edx
 15f:	6a 00                	push   $0x0
 161:	50                   	push   %eax
 162:	e8 db 02 00 00       	call   442 <open>
 167:	83 c4 10             	add    $0x10,%esp
 16a:	89 c7                	mov    %eax,%edi
 16c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for (i = 0; i < 20; i++)
    pread(fd, data, sizeof(data), 0);
 170:	6a 00                	push   $0x0
 172:	68 00 02 00 00       	push   $0x200
 177:	53                   	push   %ebx
 178:	57                   	push   %edi
 179:	e8 64 03 00 00       	call   4e2 <pread>
  for (i = 0; i < 20; i++)
 17e:	83 c4 10             	add    $0x10,%esp
 181:	83 ee 01             	sub    $0x1,%esi
 184:	75 ea                	jne    170 <main+0x170>
  printf(1, "pread %s\n", data);
 186:	83 ec 04             	sub    $0x4,%esp
 189:	53                   	push   %ebx
 18a:	68 29 09 00 00       	push   $0x929
 18f:	6a 01                	push   $0x1
 191:	e8 1a 04 00 00       	call   5b0 <printf>
  close(fd);
 196:	89 3c 24             	mov    %edi,(%esp)
 199:	e8 8c 02 00 00       	call   42a <close>
  // wait();

  
  

  exit();
 19e:	e8 5f 02 00 00       	call   402 <exit>
 1a3:	66 90                	xchg   %ax,%ax
 1a5:	66 90                	xchg   %ax,%ax
 1a7:	66 90                	xchg   %ax,%ax
 1a9:	66 90                	xchg   %ax,%ax
 1ab:	66 90                	xchg   %ax,%ax
 1ad:	66 90                	xchg   %ax,%ax
 1af:	90                   	nop

000001b0 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 1b0:	55                   	push   %ebp
 1b1:	89 e5                	mov    %esp,%ebp
 1b3:	53                   	push   %ebx
 1b4:	8b 45 08             	mov    0x8(%ebp),%eax
 1b7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 1ba:	89 c2                	mov    %eax,%edx
 1bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 1c0:	83 c1 01             	add    $0x1,%ecx
 1c3:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
 1c7:	83 c2 01             	add    $0x1,%edx
 1ca:	84 db                	test   %bl,%bl
 1cc:	88 5a ff             	mov    %bl,-0x1(%edx)
 1cf:	75 ef                	jne    1c0 <strcpy+0x10>
    ;
  return os;
}
 1d1:	5b                   	pop    %ebx
 1d2:	5d                   	pop    %ebp
 1d3:	c3                   	ret    
 1d4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 1da:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

000001e0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 1e0:	55                   	push   %ebp
 1e1:	89 e5                	mov    %esp,%ebp
 1e3:	53                   	push   %ebx
 1e4:	8b 55 08             	mov    0x8(%ebp),%edx
 1e7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
 1ea:	0f b6 02             	movzbl (%edx),%eax
 1ed:	0f b6 19             	movzbl (%ecx),%ebx
 1f0:	84 c0                	test   %al,%al
 1f2:	75 1c                	jne    210 <strcmp+0x30>
 1f4:	eb 2a                	jmp    220 <strcmp+0x40>
 1f6:	8d 76 00             	lea    0x0(%esi),%esi
 1f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    p++, q++;
 200:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
 203:	0f b6 02             	movzbl (%edx),%eax
    p++, q++;
 206:	83 c1 01             	add    $0x1,%ecx
 209:	0f b6 19             	movzbl (%ecx),%ebx
  while(*p && *p == *q)
 20c:	84 c0                	test   %al,%al
 20e:	74 10                	je     220 <strcmp+0x40>
 210:	38 d8                	cmp    %bl,%al
 212:	74 ec                	je     200 <strcmp+0x20>
  return (uchar)*p - (uchar)*q;
 214:	29 d8                	sub    %ebx,%eax
}
 216:	5b                   	pop    %ebx
 217:	5d                   	pop    %ebp
 218:	c3                   	ret    
 219:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 220:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
 222:	29 d8                	sub    %ebx,%eax
}
 224:	5b                   	pop    %ebx
 225:	5d                   	pop    %ebp
 226:	c3                   	ret    
 227:	89 f6                	mov    %esi,%esi
 229:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000230 <strlen>:

uint
strlen(const char *s)
{
 230:	55                   	push   %ebp
 231:	89 e5                	mov    %esp,%ebp
 233:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 236:	80 39 00             	cmpb   $0x0,(%ecx)
 239:	74 15                	je     250 <strlen+0x20>
 23b:	31 d2                	xor    %edx,%edx
 23d:	8d 76 00             	lea    0x0(%esi),%esi
 240:	83 c2 01             	add    $0x1,%edx
 243:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
 247:	89 d0                	mov    %edx,%eax
 249:	75 f5                	jne    240 <strlen+0x10>
    ;
  return n;
}
 24b:	5d                   	pop    %ebp
 24c:	c3                   	ret    
 24d:	8d 76 00             	lea    0x0(%esi),%esi
  for(n = 0; s[n]; n++)
 250:	31 c0                	xor    %eax,%eax
}
 252:	5d                   	pop    %ebp
 253:	c3                   	ret    
 254:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 25a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000260 <memset>:

void*
memset(void *dst, int c, uint n)
{
 260:	55                   	push   %ebp
 261:	89 e5                	mov    %esp,%ebp
 263:	57                   	push   %edi
 264:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 267:	8b 4d 10             	mov    0x10(%ebp),%ecx
 26a:	8b 45 0c             	mov    0xc(%ebp),%eax
 26d:	89 d7                	mov    %edx,%edi
 26f:	fc                   	cld    
 270:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 272:	89 d0                	mov    %edx,%eax
 274:	5f                   	pop    %edi
 275:	5d                   	pop    %ebp
 276:	c3                   	ret    
 277:	89 f6                	mov    %esi,%esi
 279:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000280 <strchr>:

char*
strchr(const char *s, char c)
{
 280:	55                   	push   %ebp
 281:	89 e5                	mov    %esp,%ebp
 283:	53                   	push   %ebx
 284:	8b 45 08             	mov    0x8(%ebp),%eax
 287:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  for(; *s; s++)
 28a:	0f b6 10             	movzbl (%eax),%edx
 28d:	84 d2                	test   %dl,%dl
 28f:	74 1d                	je     2ae <strchr+0x2e>
    if(*s == c)
 291:	38 d3                	cmp    %dl,%bl
 293:	89 d9                	mov    %ebx,%ecx
 295:	75 0d                	jne    2a4 <strchr+0x24>
 297:	eb 17                	jmp    2b0 <strchr+0x30>
 299:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 2a0:	38 ca                	cmp    %cl,%dl
 2a2:	74 0c                	je     2b0 <strchr+0x30>
  for(; *s; s++)
 2a4:	83 c0 01             	add    $0x1,%eax
 2a7:	0f b6 10             	movzbl (%eax),%edx
 2aa:	84 d2                	test   %dl,%dl
 2ac:	75 f2                	jne    2a0 <strchr+0x20>
      return (char*)s;
  return 0;
 2ae:	31 c0                	xor    %eax,%eax
}
 2b0:	5b                   	pop    %ebx
 2b1:	5d                   	pop    %ebp
 2b2:	c3                   	ret    
 2b3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 2b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000002c0 <gets>:

char*
gets(char *buf, int max)
{
 2c0:	55                   	push   %ebp
 2c1:	89 e5                	mov    %esp,%ebp
 2c3:	57                   	push   %edi
 2c4:	56                   	push   %esi
 2c5:	53                   	push   %ebx
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2c6:	31 f6                	xor    %esi,%esi
 2c8:	89 f3                	mov    %esi,%ebx
{
 2ca:	83 ec 1c             	sub    $0x1c,%esp
 2cd:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i=0; i+1 < max; ){
 2d0:	eb 2f                	jmp    301 <gets+0x41>
 2d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cc = read(0, &c, 1);
 2d8:	8d 45 e7             	lea    -0x19(%ebp),%eax
 2db:	83 ec 04             	sub    $0x4,%esp
 2de:	6a 01                	push   $0x1
 2e0:	50                   	push   %eax
 2e1:	6a 00                	push   $0x0
 2e3:	e8 32 01 00 00       	call   41a <read>
    if(cc < 1)
 2e8:	83 c4 10             	add    $0x10,%esp
 2eb:	85 c0                	test   %eax,%eax
 2ed:	7e 1c                	jle    30b <gets+0x4b>
      break;
    buf[i++] = c;
 2ef:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 2f3:	83 c7 01             	add    $0x1,%edi
 2f6:	88 47 ff             	mov    %al,-0x1(%edi)
    if(c == '\n' || c == '\r')
 2f9:	3c 0a                	cmp    $0xa,%al
 2fb:	74 23                	je     320 <gets+0x60>
 2fd:	3c 0d                	cmp    $0xd,%al
 2ff:	74 1f                	je     320 <gets+0x60>
  for(i=0; i+1 < max; ){
 301:	83 c3 01             	add    $0x1,%ebx
 304:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 307:	89 fe                	mov    %edi,%esi
 309:	7c cd                	jl     2d8 <gets+0x18>
 30b:	89 f3                	mov    %esi,%ebx
      break;
  }
  buf[i] = '\0';
  return buf;
}
 30d:	8b 45 08             	mov    0x8(%ebp),%eax
  buf[i] = '\0';
 310:	c6 03 00             	movb   $0x0,(%ebx)
}
 313:	8d 65 f4             	lea    -0xc(%ebp),%esp
 316:	5b                   	pop    %ebx
 317:	5e                   	pop    %esi
 318:	5f                   	pop    %edi
 319:	5d                   	pop    %ebp
 31a:	c3                   	ret    
 31b:	90                   	nop
 31c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 320:	8b 75 08             	mov    0x8(%ebp),%esi
 323:	8b 45 08             	mov    0x8(%ebp),%eax
 326:	01 de                	add    %ebx,%esi
 328:	89 f3                	mov    %esi,%ebx
  buf[i] = '\0';
 32a:	c6 03 00             	movb   $0x0,(%ebx)
}
 32d:	8d 65 f4             	lea    -0xc(%ebp),%esp
 330:	5b                   	pop    %ebx
 331:	5e                   	pop    %esi
 332:	5f                   	pop    %edi
 333:	5d                   	pop    %ebp
 334:	c3                   	ret    
 335:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 339:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000340 <stat>:

int
stat(const char *n, struct stat *st)
{
 340:	55                   	push   %ebp
 341:	89 e5                	mov    %esp,%ebp
 343:	56                   	push   %esi
 344:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 345:	83 ec 08             	sub    $0x8,%esp
 348:	6a 00                	push   $0x0
 34a:	ff 75 08             	pushl  0x8(%ebp)
 34d:	e8 f0 00 00 00       	call   442 <open>
  if(fd < 0)
 352:	83 c4 10             	add    $0x10,%esp
 355:	85 c0                	test   %eax,%eax
 357:	78 27                	js     380 <stat+0x40>
    return -1;
  r = fstat(fd, st);
 359:	83 ec 08             	sub    $0x8,%esp
 35c:	ff 75 0c             	pushl  0xc(%ebp)
 35f:	89 c3                	mov    %eax,%ebx
 361:	50                   	push   %eax
 362:	e8 f3 00 00 00       	call   45a <fstat>
  close(fd);
 367:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 36a:	89 c6                	mov    %eax,%esi
  close(fd);
 36c:	e8 b9 00 00 00       	call   42a <close>
  return r;
 371:	83 c4 10             	add    $0x10,%esp
}
 374:	8d 65 f8             	lea    -0x8(%ebp),%esp
 377:	89 f0                	mov    %esi,%eax
 379:	5b                   	pop    %ebx
 37a:	5e                   	pop    %esi
 37b:	5d                   	pop    %ebp
 37c:	c3                   	ret    
 37d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 380:	be ff ff ff ff       	mov    $0xffffffff,%esi
 385:	eb ed                	jmp    374 <stat+0x34>
 387:	89 f6                	mov    %esi,%esi
 389:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000390 <atoi>:

int
atoi(const char *s)
{
 390:	55                   	push   %ebp
 391:	89 e5                	mov    %esp,%ebp
 393:	53                   	push   %ebx
 394:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 397:	0f be 11             	movsbl (%ecx),%edx
 39a:	8d 42 d0             	lea    -0x30(%edx),%eax
 39d:	3c 09                	cmp    $0x9,%al
  n = 0;
 39f:	b8 00 00 00 00       	mov    $0x0,%eax
  while('0' <= *s && *s <= '9')
 3a4:	77 1f                	ja     3c5 <atoi+0x35>
 3a6:	8d 76 00             	lea    0x0(%esi),%esi
 3a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    n = n*10 + *s++ - '0';
 3b0:	8d 04 80             	lea    (%eax,%eax,4),%eax
 3b3:	83 c1 01             	add    $0x1,%ecx
 3b6:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
  while('0' <= *s && *s <= '9')
 3ba:	0f be 11             	movsbl (%ecx),%edx
 3bd:	8d 5a d0             	lea    -0x30(%edx),%ebx
 3c0:	80 fb 09             	cmp    $0x9,%bl
 3c3:	76 eb                	jbe    3b0 <atoi+0x20>
  return n;
}
 3c5:	5b                   	pop    %ebx
 3c6:	5d                   	pop    %ebp
 3c7:	c3                   	ret    
 3c8:	90                   	nop
 3c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

000003d0 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 3d0:	55                   	push   %ebp
 3d1:	89 e5                	mov    %esp,%ebp
 3d3:	56                   	push   %esi
 3d4:	53                   	push   %ebx
 3d5:	8b 5d 10             	mov    0x10(%ebp),%ebx
 3d8:	8b 45 08             	mov    0x8(%ebp),%eax
 3db:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 3de:	85 db                	test   %ebx,%ebx
 3e0:	7e 14                	jle    3f6 <memmove+0x26>
 3e2:	31 d2                	xor    %edx,%edx
 3e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *dst++ = *src++;
 3e8:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
 3ec:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 3ef:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0)
 3f2:	39 d3                	cmp    %edx,%ebx
 3f4:	75 f2                	jne    3e8 <memmove+0x18>
  return vdst;
}
 3f6:	5b                   	pop    %ebx
 3f7:	5e                   	pop    %esi
 3f8:	5d                   	pop    %ebp
 3f9:	c3                   	ret    

000003fa <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 3fa:	b8 01 00 00 00       	mov    $0x1,%eax
 3ff:	cd 40                	int    $0x40
 401:	c3                   	ret    

00000402 <exit>:
SYSCALL(exit)
 402:	b8 02 00 00 00       	mov    $0x2,%eax
 407:	cd 40                	int    $0x40
 409:	c3                   	ret    

0000040a <wait>:
SYSCALL(wait)
 40a:	b8 03 00 00 00       	mov    $0x3,%eax
 40f:	cd 40                	int    $0x40
 411:	c3                   	ret    

00000412 <pipe>:
SYSCALL(pipe)
 412:	b8 04 00 00 00       	mov    $0x4,%eax
 417:	cd 40                	int    $0x40
 419:	c3                   	ret    

0000041a <read>:
SYSCALL(read)
 41a:	b8 05 00 00 00       	mov    $0x5,%eax
 41f:	cd 40                	int    $0x40
 421:	c3                   	ret    

00000422 <write>:
SYSCALL(write)
 422:	b8 10 00 00 00       	mov    $0x10,%eax
 427:	cd 40                	int    $0x40
 429:	c3                   	ret    

0000042a <close>:
SYSCALL(close)
 42a:	b8 15 00 00 00       	mov    $0x15,%eax
 42f:	cd 40                	int    $0x40
 431:	c3                   	ret    

00000432 <kill>:
SYSCALL(kill)
 432:	b8 06 00 00 00       	mov    $0x6,%eax
 437:	cd 40                	int    $0x40
 439:	c3                   	ret    

0000043a <exec>:
SYSCALL(exec)
 43a:	b8 07 00 00 00       	mov    $0x7,%eax
 43f:	cd 40                	int    $0x40
 441:	c3                   	ret    

00000442 <open>:
SYSCALL(open)
 442:	b8 0f 00 00 00       	mov    $0xf,%eax
 447:	cd 40                	int    $0x40
 449:	c3                   	ret    

0000044a <mknod>:
SYSCALL(mknod)
 44a:	b8 11 00 00 00       	mov    $0x11,%eax
 44f:	cd 40                	int    $0x40
 451:	c3                   	ret    

00000452 <unlink>:
SYSCALL(unlink)
 452:	b8 12 00 00 00       	mov    $0x12,%eax
 457:	cd 40                	int    $0x40
 459:	c3                   	ret    

0000045a <fstat>:
SYSCALL(fstat)
 45a:	b8 08 00 00 00       	mov    $0x8,%eax
 45f:	cd 40                	int    $0x40
 461:	c3                   	ret    

00000462 <link>:
SYSCALL(link)
 462:	b8 13 00 00 00       	mov    $0x13,%eax
 467:	cd 40                	int    $0x40
 469:	c3                   	ret    

0000046a <mkdir>:
SYSCALL(mkdir)
 46a:	b8 14 00 00 00       	mov    $0x14,%eax
 46f:	cd 40                	int    $0x40
 471:	c3                   	ret    

00000472 <chdir>:
SYSCALL(chdir)
 472:	b8 09 00 00 00       	mov    $0x9,%eax
 477:	cd 40                	int    $0x40
 479:	c3                   	ret    

0000047a <dup>:
SYSCALL(dup)
 47a:	b8 0a 00 00 00       	mov    $0xa,%eax
 47f:	cd 40                	int    $0x40
 481:	c3                   	ret    

00000482 <getpid>:
SYSCALL(getpid)
 482:	b8 0b 00 00 00       	mov    $0xb,%eax
 487:	cd 40                	int    $0x40
 489:	c3                   	ret    

0000048a <sbrk>:
SYSCALL(sbrk)
 48a:	b8 0c 00 00 00       	mov    $0xc,%eax
 48f:	cd 40                	int    $0x40
 491:	c3                   	ret    

00000492 <sleep>:
SYSCALL(sleep)
 492:	b8 0d 00 00 00       	mov    $0xd,%eax
 497:	cd 40                	int    $0x40
 499:	c3                   	ret    

0000049a <uptime>:
SYSCALL(uptime)
 49a:	b8 0e 00 00 00       	mov    $0xe,%eax
 49f:	cd 40                	int    $0x40
 4a1:	c3                   	ret    

000004a2 <myfunction>:
SYSCALL(myfunction)
 4a2:	b8 16 00 00 00       	mov    $0x16,%eax
 4a7:	cd 40                	int    $0x40
 4a9:	c3                   	ret    

000004aa <getppid>:
SYSCALL(getppid)
 4aa:	b8 17 00 00 00       	mov    $0x17,%eax
 4af:	cd 40                	int    $0x40
 4b1:	c3                   	ret    

000004b2 <yield>:
SYSCALL(yield)
 4b2:	b8 18 00 00 00       	mov    $0x18,%eax
 4b7:	cd 40                	int    $0x40
 4b9:	c3                   	ret    

000004ba <getlev>:
SYSCALL(getlev)
 4ba:	b8 19 00 00 00       	mov    $0x19,%eax
 4bf:	cd 40                	int    $0x40
 4c1:	c3                   	ret    

000004c2 <set_cpu_share>:
SYSCALL(set_cpu_share)
 4c2:	b8 1a 00 00 00       	mov    $0x1a,%eax
 4c7:	cd 40                	int    $0x40
 4c9:	c3                   	ret    

000004ca <thread_exit>:
SYSCALL(thread_exit)
 4ca:	b8 1d 00 00 00       	mov    $0x1d,%eax
 4cf:	cd 40                	int    $0x40
 4d1:	c3                   	ret    

000004d2 <thread_create>:
SYSCALL(thread_create)
 4d2:	b8 1b 00 00 00       	mov    $0x1b,%eax
 4d7:	cd 40                	int    $0x40
 4d9:	c3                   	ret    

000004da <thread_join>:
SYSCALL(thread_join)
 4da:	b8 1c 00 00 00       	mov    $0x1c,%eax
 4df:	cd 40                	int    $0x40
 4e1:	c3                   	ret    

000004e2 <pread>:
SYSCALL(pread)
 4e2:	b8 1e 00 00 00       	mov    $0x1e,%eax
 4e7:	cd 40                	int    $0x40
 4e9:	c3                   	ret    

000004ea <pwrite>:
SYSCALL(pwrite)
 4ea:	b8 1f 00 00 00       	mov    $0x1f,%eax
 4ef:	cd 40                	int    $0x40
 4f1:	c3                   	ret    

000004f2 <sync>:
SYSCALL(sync)
 4f2:	b8 20 00 00 00       	mov    $0x20,%eax
 4f7:	cd 40                	int    $0x40
 4f9:	c3                   	ret    

000004fa <get_log_num>:
SYSCALL(get_log_num)
 4fa:	b8 21 00 00 00       	mov    $0x21,%eax
 4ff:	cd 40                	int    $0x40
 501:	c3                   	ret    
 502:	66 90                	xchg   %ax,%ax
 504:	66 90                	xchg   %ax,%ax
 506:	66 90                	xchg   %ax,%ax
 508:	66 90                	xchg   %ax,%ax
 50a:	66 90                	xchg   %ax,%ax
 50c:	66 90                	xchg   %ax,%ax
 50e:	66 90                	xchg   %ax,%ax

00000510 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 510:	55                   	push   %ebp
 511:	89 e5                	mov    %esp,%ebp
 513:	57                   	push   %edi
 514:	56                   	push   %esi
 515:	53                   	push   %ebx
 516:	83 ec 3c             	sub    $0x3c,%esp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 519:	85 d2                	test   %edx,%edx
{
 51b:	89 45 c0             	mov    %eax,-0x40(%ebp)
    neg = 1;
    x = -xx;
 51e:	89 d0                	mov    %edx,%eax
  if(sgn && xx < 0){
 520:	79 76                	jns    598 <printint+0x88>
 522:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 526:	74 70                	je     598 <printint+0x88>
    x = -xx;
 528:	f7 d8                	neg    %eax
    neg = 1;
 52a:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 531:	31 f6                	xor    %esi,%esi
 533:	8d 5d d7             	lea    -0x29(%ebp),%ebx
 536:	eb 0a                	jmp    542 <printint+0x32>
 538:	90                   	nop
 539:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  do{
    buf[i++] = digits[x % base];
 540:	89 fe                	mov    %edi,%esi
 542:	31 d2                	xor    %edx,%edx
 544:	8d 7e 01             	lea    0x1(%esi),%edi
 547:	f7 f1                	div    %ecx
 549:	0f b6 92 3c 09 00 00 	movzbl 0x93c(%edx),%edx
  }while((x /= base) != 0);
 550:	85 c0                	test   %eax,%eax
    buf[i++] = digits[x % base];
 552:	88 14 3b             	mov    %dl,(%ebx,%edi,1)
  }while((x /= base) != 0);
 555:	75 e9                	jne    540 <printint+0x30>
  if(neg)
 557:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 55a:	85 c0                	test   %eax,%eax
 55c:	74 08                	je     566 <printint+0x56>
    buf[i++] = '-';
 55e:	c6 44 3d d8 2d       	movb   $0x2d,-0x28(%ebp,%edi,1)
 563:	8d 7e 02             	lea    0x2(%esi),%edi
 566:	8d 74 3d d7          	lea    -0x29(%ebp,%edi,1),%esi
 56a:	8b 7d c0             	mov    -0x40(%ebp),%edi
 56d:	8d 76 00             	lea    0x0(%esi),%esi
 570:	0f b6 06             	movzbl (%esi),%eax
  write(fd, &c, 1);
 573:	83 ec 04             	sub    $0x4,%esp
 576:	83 ee 01             	sub    $0x1,%esi
 579:	6a 01                	push   $0x1
 57b:	53                   	push   %ebx
 57c:	57                   	push   %edi
 57d:	88 45 d7             	mov    %al,-0x29(%ebp)
 580:	e8 9d fe ff ff       	call   422 <write>

  while(--i >= 0)
 585:	83 c4 10             	add    $0x10,%esp
 588:	39 de                	cmp    %ebx,%esi
 58a:	75 e4                	jne    570 <printint+0x60>
    putc(fd, buf[i]);
}
 58c:	8d 65 f4             	lea    -0xc(%ebp),%esp
 58f:	5b                   	pop    %ebx
 590:	5e                   	pop    %esi
 591:	5f                   	pop    %edi
 592:	5d                   	pop    %ebp
 593:	c3                   	ret    
 594:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 598:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
 59f:	eb 90                	jmp    531 <printint+0x21>
 5a1:	eb 0d                	jmp    5b0 <printf>
 5a3:	90                   	nop
 5a4:	90                   	nop
 5a5:	90                   	nop
 5a6:	90                   	nop
 5a7:	90                   	nop
 5a8:	90                   	nop
 5a9:	90                   	nop
 5aa:	90                   	nop
 5ab:	90                   	nop
 5ac:	90                   	nop
 5ad:	90                   	nop
 5ae:	90                   	nop
 5af:	90                   	nop

000005b0 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 5b0:	55                   	push   %ebp
 5b1:	89 e5                	mov    %esp,%ebp
 5b3:	57                   	push   %edi
 5b4:	56                   	push   %esi
 5b5:	53                   	push   %ebx
 5b6:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 5b9:	8b 75 0c             	mov    0xc(%ebp),%esi
 5bc:	0f b6 1e             	movzbl (%esi),%ebx
 5bf:	84 db                	test   %bl,%bl
 5c1:	0f 84 b3 00 00 00    	je     67a <printf+0xca>
  ap = (uint*)(void*)&fmt + 1;
 5c7:	8d 45 10             	lea    0x10(%ebp),%eax
 5ca:	83 c6 01             	add    $0x1,%esi
  state = 0;
 5cd:	31 ff                	xor    %edi,%edi
  ap = (uint*)(void*)&fmt + 1;
 5cf:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 5d2:	eb 2f                	jmp    603 <printf+0x53>
 5d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 5d8:	83 f8 25             	cmp    $0x25,%eax
 5db:	0f 84 a7 00 00 00    	je     688 <printf+0xd8>
  write(fd, &c, 1);
 5e1:	8d 45 e2             	lea    -0x1e(%ebp),%eax
 5e4:	83 ec 04             	sub    $0x4,%esp
 5e7:	88 5d e2             	mov    %bl,-0x1e(%ebp)
 5ea:	6a 01                	push   $0x1
 5ec:	50                   	push   %eax
 5ed:	ff 75 08             	pushl  0x8(%ebp)
 5f0:	e8 2d fe ff ff       	call   422 <write>
 5f5:	83 c4 10             	add    $0x10,%esp
 5f8:	83 c6 01             	add    $0x1,%esi
  for(i = 0; fmt[i]; i++){
 5fb:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
 5ff:	84 db                	test   %bl,%bl
 601:	74 77                	je     67a <printf+0xca>
    if(state == 0){
 603:	85 ff                	test   %edi,%edi
    c = fmt[i] & 0xff;
 605:	0f be cb             	movsbl %bl,%ecx
 608:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 60b:	74 cb                	je     5d8 <printf+0x28>
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 60d:	83 ff 25             	cmp    $0x25,%edi
 610:	75 e6                	jne    5f8 <printf+0x48>
      if(c == 'd'){
 612:	83 f8 64             	cmp    $0x64,%eax
 615:	0f 84 05 01 00 00    	je     720 <printf+0x170>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 61b:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
 621:	83 f9 70             	cmp    $0x70,%ecx
 624:	74 72                	je     698 <printf+0xe8>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 626:	83 f8 73             	cmp    $0x73,%eax
 629:	0f 84 99 00 00 00    	je     6c8 <printf+0x118>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 62f:	83 f8 63             	cmp    $0x63,%eax
 632:	0f 84 08 01 00 00    	je     740 <printf+0x190>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 638:	83 f8 25             	cmp    $0x25,%eax
 63b:	0f 84 ef 00 00 00    	je     730 <printf+0x180>
  write(fd, &c, 1);
 641:	8d 45 e7             	lea    -0x19(%ebp),%eax
 644:	83 ec 04             	sub    $0x4,%esp
 647:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 64b:	6a 01                	push   $0x1
 64d:	50                   	push   %eax
 64e:	ff 75 08             	pushl  0x8(%ebp)
 651:	e8 cc fd ff ff       	call   422 <write>
 656:	83 c4 0c             	add    $0xc,%esp
 659:	8d 45 e6             	lea    -0x1a(%ebp),%eax
 65c:	88 5d e6             	mov    %bl,-0x1a(%ebp)
 65f:	6a 01                	push   $0x1
 661:	50                   	push   %eax
 662:	ff 75 08             	pushl  0x8(%ebp)
 665:	83 c6 01             	add    $0x1,%esi
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 668:	31 ff                	xor    %edi,%edi
  write(fd, &c, 1);
 66a:	e8 b3 fd ff ff       	call   422 <write>
  for(i = 0; fmt[i]; i++){
 66f:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
  write(fd, &c, 1);
 673:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
 676:	84 db                	test   %bl,%bl
 678:	75 89                	jne    603 <printf+0x53>
    }
  }
}
 67a:	8d 65 f4             	lea    -0xc(%ebp),%esp
 67d:	5b                   	pop    %ebx
 67e:	5e                   	pop    %esi
 67f:	5f                   	pop    %edi
 680:	5d                   	pop    %ebp
 681:	c3                   	ret    
 682:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        state = '%';
 688:	bf 25 00 00 00       	mov    $0x25,%edi
 68d:	e9 66 ff ff ff       	jmp    5f8 <printf+0x48>
 692:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        printint(fd, *ap, 16, 0);
 698:	83 ec 0c             	sub    $0xc,%esp
 69b:	b9 10 00 00 00       	mov    $0x10,%ecx
 6a0:	6a 00                	push   $0x0
 6a2:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 6a5:	8b 45 08             	mov    0x8(%ebp),%eax
 6a8:	8b 17                	mov    (%edi),%edx
 6aa:	e8 61 fe ff ff       	call   510 <printint>
        ap++;
 6af:	89 f8                	mov    %edi,%eax
 6b1:	83 c4 10             	add    $0x10,%esp
      state = 0;
 6b4:	31 ff                	xor    %edi,%edi
        ap++;
 6b6:	83 c0 04             	add    $0x4,%eax
 6b9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 6bc:	e9 37 ff ff ff       	jmp    5f8 <printf+0x48>
 6c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        s = (char*)*ap;
 6c8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 6cb:	8b 08                	mov    (%eax),%ecx
        ap++;
 6cd:	83 c0 04             	add    $0x4,%eax
 6d0:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        if(s == 0)
 6d3:	85 c9                	test   %ecx,%ecx
 6d5:	0f 84 8e 00 00 00    	je     769 <printf+0x1b9>
        while(*s != 0){
 6db:	0f b6 01             	movzbl (%ecx),%eax
      state = 0;
 6de:	31 ff                	xor    %edi,%edi
        s = (char*)*ap;
 6e0:	89 cb                	mov    %ecx,%ebx
        while(*s != 0){
 6e2:	84 c0                	test   %al,%al
 6e4:	0f 84 0e ff ff ff    	je     5f8 <printf+0x48>
 6ea:	89 75 d0             	mov    %esi,-0x30(%ebp)
 6ed:	89 de                	mov    %ebx,%esi
 6ef:	8b 5d 08             	mov    0x8(%ebp),%ebx
 6f2:	8d 7d e3             	lea    -0x1d(%ebp),%edi
 6f5:	8d 76 00             	lea    0x0(%esi),%esi
  write(fd, &c, 1);
 6f8:	83 ec 04             	sub    $0x4,%esp
          s++;
 6fb:	83 c6 01             	add    $0x1,%esi
 6fe:	88 45 e3             	mov    %al,-0x1d(%ebp)
  write(fd, &c, 1);
 701:	6a 01                	push   $0x1
 703:	57                   	push   %edi
 704:	53                   	push   %ebx
 705:	e8 18 fd ff ff       	call   422 <write>
        while(*s != 0){
 70a:	0f b6 06             	movzbl (%esi),%eax
 70d:	83 c4 10             	add    $0x10,%esp
 710:	84 c0                	test   %al,%al
 712:	75 e4                	jne    6f8 <printf+0x148>
 714:	8b 75 d0             	mov    -0x30(%ebp),%esi
      state = 0;
 717:	31 ff                	xor    %edi,%edi
 719:	e9 da fe ff ff       	jmp    5f8 <printf+0x48>
 71e:	66 90                	xchg   %ax,%ax
        printint(fd, *ap, 10, 1);
 720:	83 ec 0c             	sub    $0xc,%esp
 723:	b9 0a 00 00 00       	mov    $0xa,%ecx
 728:	6a 01                	push   $0x1
 72a:	e9 73 ff ff ff       	jmp    6a2 <printf+0xf2>
 72f:	90                   	nop
  write(fd, &c, 1);
 730:	83 ec 04             	sub    $0x4,%esp
 733:	88 5d e5             	mov    %bl,-0x1b(%ebp)
 736:	8d 45 e5             	lea    -0x1b(%ebp),%eax
 739:	6a 01                	push   $0x1
 73b:	e9 21 ff ff ff       	jmp    661 <printf+0xb1>
        putc(fd, *ap);
 740:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  write(fd, &c, 1);
 743:	83 ec 04             	sub    $0x4,%esp
        putc(fd, *ap);
 746:	8b 07                	mov    (%edi),%eax
  write(fd, &c, 1);
 748:	6a 01                	push   $0x1
        ap++;
 74a:	83 c7 04             	add    $0x4,%edi
        putc(fd, *ap);
 74d:	88 45 e4             	mov    %al,-0x1c(%ebp)
  write(fd, &c, 1);
 750:	8d 45 e4             	lea    -0x1c(%ebp),%eax
 753:	50                   	push   %eax
 754:	ff 75 08             	pushl  0x8(%ebp)
 757:	e8 c6 fc ff ff       	call   422 <write>
        ap++;
 75c:	89 7d d4             	mov    %edi,-0x2c(%ebp)
 75f:	83 c4 10             	add    $0x10,%esp
      state = 0;
 762:	31 ff                	xor    %edi,%edi
 764:	e9 8f fe ff ff       	jmp    5f8 <printf+0x48>
          s = "(null)";
 769:	bb 33 09 00 00       	mov    $0x933,%ebx
        while(*s != 0){
 76e:	b8 28 00 00 00       	mov    $0x28,%eax
 773:	e9 72 ff ff ff       	jmp    6ea <printf+0x13a>
 778:	66 90                	xchg   %ax,%ax
 77a:	66 90                	xchg   %ax,%ax
 77c:	66 90                	xchg   %ax,%ax
 77e:	66 90                	xchg   %ax,%ax

00000780 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 780:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 781:	a1 ec 0b 00 00       	mov    0xbec,%eax
{
 786:	89 e5                	mov    %esp,%ebp
 788:	57                   	push   %edi
 789:	56                   	push   %esi
 78a:	53                   	push   %ebx
 78b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = (Header*)ap - 1;
 78e:	8d 4b f8             	lea    -0x8(%ebx),%ecx
 791:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 798:	39 c8                	cmp    %ecx,%eax
 79a:	8b 10                	mov    (%eax),%edx
 79c:	73 32                	jae    7d0 <free+0x50>
 79e:	39 d1                	cmp    %edx,%ecx
 7a0:	72 04                	jb     7a6 <free+0x26>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7a2:	39 d0                	cmp    %edx,%eax
 7a4:	72 32                	jb     7d8 <free+0x58>
      break;
  if(bp + bp->s.size == p->s.ptr){
 7a6:	8b 73 fc             	mov    -0x4(%ebx),%esi
 7a9:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 7ac:	39 fa                	cmp    %edi,%edx
 7ae:	74 30                	je     7e0 <free+0x60>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 7b0:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 7b3:	8b 50 04             	mov    0x4(%eax),%edx
 7b6:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 7b9:	39 f1                	cmp    %esi,%ecx
 7bb:	74 3a                	je     7f7 <free+0x77>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 7bd:	89 08                	mov    %ecx,(%eax)
  freep = p;
 7bf:	a3 ec 0b 00 00       	mov    %eax,0xbec
}
 7c4:	5b                   	pop    %ebx
 7c5:	5e                   	pop    %esi
 7c6:	5f                   	pop    %edi
 7c7:	5d                   	pop    %ebp
 7c8:	c3                   	ret    
 7c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7d0:	39 d0                	cmp    %edx,%eax
 7d2:	72 04                	jb     7d8 <free+0x58>
 7d4:	39 d1                	cmp    %edx,%ecx
 7d6:	72 ce                	jb     7a6 <free+0x26>
{
 7d8:	89 d0                	mov    %edx,%eax
 7da:	eb bc                	jmp    798 <free+0x18>
 7dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp->s.size += p->s.ptr->s.size;
 7e0:	03 72 04             	add    0x4(%edx),%esi
 7e3:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 7e6:	8b 10                	mov    (%eax),%edx
 7e8:	8b 12                	mov    (%edx),%edx
 7ea:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 7ed:	8b 50 04             	mov    0x4(%eax),%edx
 7f0:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 7f3:	39 f1                	cmp    %esi,%ecx
 7f5:	75 c6                	jne    7bd <free+0x3d>
    p->s.size += bp->s.size;
 7f7:	03 53 fc             	add    -0x4(%ebx),%edx
  freep = p;
 7fa:	a3 ec 0b 00 00       	mov    %eax,0xbec
    p->s.size += bp->s.size;
 7ff:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 802:	8b 53 f8             	mov    -0x8(%ebx),%edx
 805:	89 10                	mov    %edx,(%eax)
}
 807:	5b                   	pop    %ebx
 808:	5e                   	pop    %esi
 809:	5f                   	pop    %edi
 80a:	5d                   	pop    %ebp
 80b:	c3                   	ret    
 80c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000810 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 810:	55                   	push   %ebp
 811:	89 e5                	mov    %esp,%ebp
 813:	57                   	push   %edi
 814:	56                   	push   %esi
 815:	53                   	push   %ebx
 816:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 819:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 81c:	8b 15 ec 0b 00 00    	mov    0xbec,%edx
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 822:	8d 78 07             	lea    0x7(%eax),%edi
 825:	c1 ef 03             	shr    $0x3,%edi
 828:	83 c7 01             	add    $0x1,%edi
  if((prevp = freep) == 0){
 82b:	85 d2                	test   %edx,%edx
 82d:	0f 84 9d 00 00 00    	je     8d0 <malloc+0xc0>
 833:	8b 02                	mov    (%edx),%eax
 835:	8b 48 04             	mov    0x4(%eax),%ecx
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 838:	39 cf                	cmp    %ecx,%edi
 83a:	76 6c                	jbe    8a8 <malloc+0x98>
 83c:	81 ff 00 10 00 00    	cmp    $0x1000,%edi
 842:	bb 00 10 00 00       	mov    $0x1000,%ebx
 847:	0f 43 df             	cmovae %edi,%ebx
  p = sbrk(nu * sizeof(Header));
 84a:	8d 34 dd 00 00 00 00 	lea    0x0(,%ebx,8),%esi
 851:	eb 0e                	jmp    861 <malloc+0x51>
 853:	90                   	nop
 854:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 858:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 85a:	8b 48 04             	mov    0x4(%eax),%ecx
 85d:	39 f9                	cmp    %edi,%ecx
 85f:	73 47                	jae    8a8 <malloc+0x98>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 861:	39 05 ec 0b 00 00    	cmp    %eax,0xbec
 867:	89 c2                	mov    %eax,%edx
 869:	75 ed                	jne    858 <malloc+0x48>
  p = sbrk(nu * sizeof(Header));
 86b:	83 ec 0c             	sub    $0xc,%esp
 86e:	56                   	push   %esi
 86f:	e8 16 fc ff ff       	call   48a <sbrk>
  if(p == (char*)-1)
 874:	83 c4 10             	add    $0x10,%esp
 877:	83 f8 ff             	cmp    $0xffffffff,%eax
 87a:	74 1c                	je     898 <malloc+0x88>
  hp->s.size = nu;
 87c:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 87f:	83 ec 0c             	sub    $0xc,%esp
 882:	83 c0 08             	add    $0x8,%eax
 885:	50                   	push   %eax
 886:	e8 f5 fe ff ff       	call   780 <free>
  return freep;
 88b:	8b 15 ec 0b 00 00    	mov    0xbec,%edx
      if((p = morecore(nunits)) == 0)
 891:	83 c4 10             	add    $0x10,%esp
 894:	85 d2                	test   %edx,%edx
 896:	75 c0                	jne    858 <malloc+0x48>
        return 0;
  }
}
 898:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 89b:	31 c0                	xor    %eax,%eax
}
 89d:	5b                   	pop    %ebx
 89e:	5e                   	pop    %esi
 89f:	5f                   	pop    %edi
 8a0:	5d                   	pop    %ebp
 8a1:	c3                   	ret    
 8a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
 8a8:	39 cf                	cmp    %ecx,%edi
 8aa:	74 54                	je     900 <malloc+0xf0>
        p->s.size -= nunits;
 8ac:	29 f9                	sub    %edi,%ecx
 8ae:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 8b1:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 8b4:	89 78 04             	mov    %edi,0x4(%eax)
      freep = prevp;
 8b7:	89 15 ec 0b 00 00    	mov    %edx,0xbec
}
 8bd:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
 8c0:	83 c0 08             	add    $0x8,%eax
}
 8c3:	5b                   	pop    %ebx
 8c4:	5e                   	pop    %esi
 8c5:	5f                   	pop    %edi
 8c6:	5d                   	pop    %ebp
 8c7:	c3                   	ret    
 8c8:	90                   	nop
 8c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    base.s.ptr = freep = prevp = &base;
 8d0:	c7 05 ec 0b 00 00 f0 	movl   $0xbf0,0xbec
 8d7:	0b 00 00 
 8da:	c7 05 f0 0b 00 00 f0 	movl   $0xbf0,0xbf0
 8e1:	0b 00 00 
    base.s.size = 0;
 8e4:	b8 f0 0b 00 00       	mov    $0xbf0,%eax
 8e9:	c7 05 f4 0b 00 00 00 	movl   $0x0,0xbf4
 8f0:	00 00 00 
 8f3:	e9 44 ff ff ff       	jmp    83c <malloc+0x2c>
 8f8:	90                   	nop
 8f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        prevp->s.ptr = p->s.ptr;
 900:	8b 08                	mov    (%eax),%ecx
 902:	89 0a                	mov    %ecx,(%edx)
 904:	eb b1                	jmp    8b7 <malloc+0xa7>
