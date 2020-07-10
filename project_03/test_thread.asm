
_test_thread:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
  "stresstest",
};

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
  11:	83 ec 18             	sub    $0x18,%esp
  14:	8b 31                	mov    (%ecx),%esi
  16:	8b 79 04             	mov    0x4(%ecx),%edi
  int i;
  int ret;
  int pid;
  int start = 0;
  int end = NTEST-1;
  if (argc >= 2)
  19:	83 fe 01             	cmp    $0x1,%esi
  1c:	0f 8f eb 00 00 00    	jg     10d <main+0x10d>
  int end = NTEST-1;
  22:	be 04 00 00 00       	mov    $0x4,%esi
  int start = 0;
  27:	31 db                	xor    %ebx,%ebx
      write(gpipe[1], (char*)&ret, sizeof(ret));
      close(gpipe[1]);
      exit();
    } else{
      close(gpipe[1]);
      if (wait() == -1 || read(gpipe[0], (char*)&ret, sizeof(ret)) == -1 || ret != 0){
  29:	8d 7d e4             	lea    -0x1c(%ebp),%edi
  2c:	e9 9e 00 00 00       	jmp    cf <main+0xcf>
  31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ret = 0;
  38:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    if ((pid = fork()) < 0){
  3f:	e8 d6 08 00 00       	call   91a <fork>
  44:	85 c0                	test   %eax,%eax
  46:	0f 88 10 01 00 00    	js     15c <main+0x15c>
    if (pid == 0){
  4c:	0f 84 1d 01 00 00    	je     16f <main+0x16f>
      close(gpipe[1]);
  52:	83 ec 0c             	sub    $0xc,%esp
  55:	ff 35 bc 13 00 00    	pushl  0x13bc
  5b:	e8 ea 08 00 00       	call   94a <close>
      if (wait() == -1 || read(gpipe[0], (char*)&ret, sizeof(ret)) == -1 || ret != 0){
  60:	e8 c5 08 00 00       	call   92a <wait>
  65:	83 c4 10             	add    $0x10,%esp
  68:	83 f8 ff             	cmp    $0xffffffff,%eax
  6b:	0f 84 d2 00 00 00    	je     143 <main+0x143>
  71:	83 ec 04             	sub    $0x4,%esp
  74:	6a 04                	push   $0x4
  76:	57                   	push   %edi
  77:	ff 35 b8 13 00 00    	pushl  0x13b8
  7d:	e8 b8 08 00 00       	call   93a <read>
  82:	83 c4 10             	add    $0x10,%esp
  85:	83 f8 ff             	cmp    $0xffffffff,%eax
  88:	0f 84 b5 00 00 00    	je     143 <main+0x143>
  8e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  91:	85 c0                	test   %eax,%eax
  93:	0f 85 aa 00 00 00    	jne    143 <main+0x143>
        printf(1,"%d. %s panic\n", i, testname[i]);
        exit();
      }
      close(gpipe[0]);
  99:	83 ec 0c             	sub    $0xc,%esp
  9c:	ff 35 b8 13 00 00    	pushl  0x13b8
  a2:	e8 a3 08 00 00       	call   94a <close>
    }
    printf(1,"%d. %s finish\n", i, testname[i]);
  a7:	ff 34 9d 80 13 00 00 	pushl  0x1380(,%ebx,4)
  ae:	53                   	push   %ebx
  for (i = start; i <= end; i++){
  af:	83 c3 01             	add    $0x1,%ebx
    printf(1,"%d. %s finish\n", i, testname[i]);
  b2:	68 b1 0e 00 00       	push   $0xeb1
  b7:	6a 01                	push   $0x1
  b9:	e8 12 0a 00 00       	call   ad0 <printf>
    sleep(100);
  be:	83 c4 14             	add    $0x14,%esp
  c1:	6a 64                	push   $0x64
  c3:	e8 ea 08 00 00       	call   9b2 <sleep>
  for (i = start; i <= end; i++){
  c8:	83 c4 10             	add    $0x10,%esp
  cb:	39 f3                	cmp    %esi,%ebx
  cd:	7f 6f                	jg     13e <main+0x13e>
    printf(1,"%d. %s start\n", i, testname[i]);
  cf:	ff 34 9d 80 13 00 00 	pushl  0x1380(,%ebx,4)
  d6:	53                   	push   %ebx
  d7:	68 7d 0e 00 00       	push   $0xe7d
  dc:	6a 01                	push   $0x1
  de:	e8 ed 09 00 00       	call   ad0 <printf>
    if (pipe(gpipe) < 0){
  e3:	c7 04 24 b8 13 00 00 	movl   $0x13b8,(%esp)
  ea:	e8 43 08 00 00       	call   932 <pipe>
  ef:	83 c4 10             	add    $0x10,%esp
  f2:	85 c0                	test   %eax,%eax
  f4:	0f 89 3e ff ff ff    	jns    38 <main+0x38>
      printf(1,"pipe panic\n");
  fa:	53                   	push   %ebx
  fb:	53                   	push   %ebx
  fc:	68 8b 0e 00 00       	push   $0xe8b
 101:	6a 01                	push   $0x1
 103:	e8 c8 09 00 00       	call   ad0 <printf>
      exit();
 108:	e8 15 08 00 00       	call   922 <exit>
    start = atoi(argv[1]);
 10d:	83 ec 0c             	sub    $0xc,%esp
 110:	ff 77 04             	pushl  0x4(%edi)
 113:	e8 98 07 00 00       	call   8b0 <atoi>
  if (argc >= 3)
 118:	83 c4 10             	add    $0x10,%esp
 11b:	83 fe 02             	cmp    $0x2,%esi
    start = atoi(argv[1]);
 11e:	89 c3                	mov    %eax,%ebx
  if (argc >= 3)
 120:	0f 84 86 00 00 00    	je     1ac <main+0x1ac>
    end = atoi(argv[2]);
 126:	83 ec 0c             	sub    $0xc,%esp
 129:	ff 77 08             	pushl  0x8(%edi)
 12c:	e8 7f 07 00 00       	call   8b0 <atoi>
 131:	83 c4 10             	add    $0x10,%esp
 134:	89 c6                	mov    %eax,%esi
  for (i = start; i <= end; i++){
 136:	39 de                	cmp    %ebx,%esi
 138:	0f 8d eb fe ff ff    	jge    29 <main+0x29>
  }
  exit();
 13e:	e8 df 07 00 00       	call   922 <exit>
        printf(1,"%d. %s panic\n", i, testname[i]);
 143:	ff 34 9d 80 13 00 00 	pushl  0x1380(,%ebx,4)
 14a:	53                   	push   %ebx
 14b:	68 a3 0e 00 00       	push   $0xea3
 150:	6a 01                	push   $0x1
 152:	e8 79 09 00 00       	call   ad0 <printf>
        exit();
 157:	e8 c6 07 00 00       	call   922 <exit>
      printf(1,"fork panic\n");
 15c:	51                   	push   %ecx
 15d:	51                   	push   %ecx
 15e:	68 97 0e 00 00       	push   $0xe97
 163:	6a 01                	push   $0x1
 165:	e8 66 09 00 00       	call   ad0 <printf>
      exit();
 16a:	e8 b3 07 00 00       	call   922 <exit>
      close(gpipe[0]);
 16f:	83 ec 0c             	sub    $0xc,%esp
 172:	ff 35 b8 13 00 00    	pushl  0x13b8
 178:	e8 cd 07 00 00       	call   94a <close>
      ret = testfunc[i]();
 17d:	ff 14 9d 94 13 00 00 	call   *0x1394(,%ebx,4)
 184:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      write(gpipe[1], (char*)&ret, sizeof(ret));
 187:	8d 45 e4             	lea    -0x1c(%ebp),%eax
 18a:	83 c4 0c             	add    $0xc,%esp
 18d:	6a 04                	push   $0x4
 18f:	50                   	push   %eax
 190:	ff 35 bc 13 00 00    	pushl  0x13bc
 196:	e8 a7 07 00 00       	call   942 <write>
      close(gpipe[1]);
 19b:	5a                   	pop    %edx
 19c:	ff 35 bc 13 00 00    	pushl  0x13bc
 1a2:	e8 a3 07 00 00       	call   94a <close>
      exit();
 1a7:	e8 76 07 00 00       	call   922 <exit>
  int end = NTEST-1;
 1ac:	be 04 00 00 00       	mov    $0x4,%esi
 1b1:	eb 83                	jmp    136 <main+0x136>
 1b3:	66 90                	xchg   %ax,%ax
 1b5:	66 90                	xchg   %ax,%ax
 1b7:	66 90                	xchg   %ax,%ax
 1b9:	66 90                	xchg   %ax,%ax
 1bb:	66 90                	xchg   %ax,%ax
 1bd:	66 90                	xchg   %ax,%ax
 1bf:	90                   	nop

000001c0 <basicthreadmain>:
}

// ============================================================================
void*
basicthreadmain(void *arg)
{
 1c0:	55                   	push   %ebp
 1c1:	89 e5                	mov    %esp,%ebp
 1c3:	57                   	push   %edi
 1c4:	56                   	push   %esi
 1c5:	53                   	push   %ebx
  int tid = (int) arg;
  int i;
  for (i = 0; i < 100000000; i++){
    if (i % 20000000 == 0){
 1c6:	bf 6b ca 5f 6b       	mov    $0x6b5fca6b,%edi
  for (i = 0; i < 100000000; i++){
 1cb:	31 db                	xor    %ebx,%ebx
{
 1cd:	83 ec 0c             	sub    $0xc,%esp
 1d0:	8b 75 08             	mov    0x8(%ebp),%esi
 1d3:	eb 0e                	jmp    1e3 <basicthreadmain+0x23>
 1d5:	8d 76 00             	lea    0x0(%esi),%esi
  for (i = 0; i < 100000000; i++){
 1d8:	83 c3 01             	add    $0x1,%ebx
 1db:	81 fb 00 e1 f5 05    	cmp    $0x5f5e100,%ebx
 1e1:	74 2f                	je     212 <basicthreadmain+0x52>
    if (i % 20000000 == 0){
 1e3:	89 d8                	mov    %ebx,%eax
 1e5:	f7 e7                	mul    %edi
 1e7:	c1 ea 17             	shr    $0x17,%edx
 1ea:	69 d2 00 2d 31 01    	imul   $0x1312d00,%edx,%edx
 1f0:	39 d3                	cmp    %edx,%ebx
 1f2:	75 e4                	jne    1d8 <basicthreadmain+0x18>
      printf(1, "%d", tid);
 1f4:	83 ec 04             	sub    $0x4,%esp
  for (i = 0; i < 100000000; i++){
 1f7:	83 c3 01             	add    $0x1,%ebx
      printf(1, "%d", tid);
 1fa:	56                   	push   %esi
 1fb:	68 28 0e 00 00       	push   $0xe28
 200:	6a 01                	push   $0x1
 202:	e8 c9 08 00 00       	call   ad0 <printf>
 207:	83 c4 10             	add    $0x10,%esp
  for (i = 0; i < 100000000; i++){
 20a:	81 fb 00 e1 f5 05    	cmp    $0x5f5e100,%ebx
 210:	75 d1                	jne    1e3 <basicthreadmain+0x23>
    }
  }
  thread_exit((void *)(tid+1));
 212:	83 ec 0c             	sub    $0xc,%esp
 215:	83 c6 01             	add    $0x1,%esi
 218:	56                   	push   %esi
 219:	e8 cc 07 00 00       	call   9ea <thread_exit>
 21e:	66 90                	xchg   %ax,%ax

00000220 <jointhreadmain>:

// ============================================================================

void*
jointhreadmain(void *arg)
{
 220:	55                   	push   %ebp
 221:	89 e5                	mov    %esp,%ebp
 223:	83 ec 14             	sub    $0x14,%esp
  int val = (int)arg;
  sleep(200);
 226:	68 c8 00 00 00       	push   $0xc8
 22b:	e8 82 07 00 00       	call   9b2 <sleep>
  printf(1, "thread_exit...\n");
 230:	58                   	pop    %eax
 231:	5a                   	pop    %edx
 232:	68 2b 0e 00 00       	push   $0xe2b
 237:	6a 01                	push   $0x1
 239:	e8 92 08 00 00       	call   ad0 <printf>
  thread_exit((void *)(val*2));
 23e:	8b 45 08             	mov    0x8(%ebp),%eax
 241:	01 c0                	add    %eax,%eax
 243:	89 04 24             	mov    %eax,(%esp)
 246:	e8 9f 07 00 00       	call   9ea <thread_exit>
 24b:	90                   	nop
 24c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000250 <stressthreadmain>:

// ============================================================================

void*
stressthreadmain(void *arg)
{
 250:	55                   	push   %ebp
 251:	89 e5                	mov    %esp,%ebp
 253:	83 ec 14             	sub    $0x14,%esp
  thread_exit(0);
 256:	6a 00                	push   $0x0
 258:	e8 8d 07 00 00       	call   9ea <thread_exit>
 25d:	8d 76 00             	lea    0x0(%esi),%esi

00000260 <racingthreadmain>:
{
 260:	55                   	push   %ebp
 261:	89 e5                	mov    %esp,%ebp
 263:	83 ec 14             	sub    $0x14,%esp
 266:	81 05 b4 13 00 00 80 	addl   $0x989680,0x13b4
 26d:	96 98 00 
  thread_exit((void *)(tid+1));
 270:	8b 45 08             	mov    0x8(%ebp),%eax
 273:	83 c0 01             	add    $0x1,%eax
 276:	50                   	push   %eax
 277:	e8 6e 07 00 00       	call   9ea <thread_exit>
 27c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000280 <jointest2>:
{
 280:	55                   	push   %ebp
 281:	89 e5                	mov    %esp,%ebp
 283:	56                   	push   %esi
 284:	53                   	push   %ebx
 285:	8d 75 cc             	lea    -0x34(%ebp),%esi
  for (i = 1; i <= NUM_THREAD; i++){
 288:	bb 01 00 00 00       	mov    $0x1,%ebx
{
 28d:	83 ec 40             	sub    $0x40,%esp
    if (thread_create(&threads[i-1], jointhreadmain, (void*)(i)) != 0){
 290:	8d 04 9e             	lea    (%esi,%ebx,4),%eax
 293:	83 ec 04             	sub    $0x4,%esp
 296:	53                   	push   %ebx
 297:	68 20 02 00 00       	push   $0x220
 29c:	50                   	push   %eax
 29d:	e8 50 07 00 00       	call   9f2 <thread_create>
 2a2:	83 c4 10             	add    $0x10,%esp
 2a5:	85 c0                	test   %eax,%eax
 2a7:	75 77                	jne    320 <jointest2+0xa0>
  for (i = 1; i <= NUM_THREAD; i++){
 2a9:	83 c3 01             	add    $0x1,%ebx
 2ac:	83 fb 0b             	cmp    $0xb,%ebx
 2af:	75 df                	jne    290 <jointest2+0x10>
  sleep(500);
 2b1:	83 ec 0c             	sub    $0xc,%esp
  printf(1, "thread_join!!!\n");
 2b4:	bb 02 00 00 00       	mov    $0x2,%ebx
  sleep(500);
 2b9:	68 f4 01 00 00       	push   $0x1f4
 2be:	e8 ef 06 00 00       	call   9b2 <sleep>
  printf(1, "thread_join!!!\n");
 2c3:	58                   	pop    %eax
 2c4:	5a                   	pop    %edx
 2c5:	68 53 0e 00 00       	push   $0xe53
 2ca:	6a 01                	push   $0x1
 2cc:	e8 ff 07 00 00       	call   ad0 <printf>
 2d1:	83 c4 10             	add    $0x10,%esp
 2d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if (thread_join(threads[i-1], &retval) != 0 || (int)retval != i * 2 ){
 2d8:	83 ec 08             	sub    $0x8,%esp
 2db:	56                   	push   %esi
 2dc:	ff 74 5d cc          	pushl  -0x34(%ebp,%ebx,2)
 2e0:	e8 15 07 00 00       	call   9fa <thread_join>
 2e5:	83 c4 10             	add    $0x10,%esp
 2e8:	85 c0                	test   %eax,%eax
 2ea:	75 54                	jne    340 <jointest2+0xc0>
 2ec:	39 5d cc             	cmp    %ebx,-0x34(%ebp)
 2ef:	75 4f                	jne    340 <jointest2+0xc0>
 2f1:	83 c3 02             	add    $0x2,%ebx
  for (i = 1; i <= NUM_THREAD; i++){
 2f4:	83 fb 16             	cmp    $0x16,%ebx
 2f7:	75 df                	jne    2d8 <jointest2+0x58>
  printf(1,"\n");
 2f9:	83 ec 08             	sub    $0x8,%esp
 2fc:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 2ff:	68 61 0e 00 00       	push   $0xe61
 304:	6a 01                	push   $0x1
 306:	e8 c5 07 00 00       	call   ad0 <printf>
  return 0;
 30b:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 30e:	83 c4 10             	add    $0x10,%esp
}
 311:	8d 65 f8             	lea    -0x8(%ebp),%esp
 314:	5b                   	pop    %ebx
 315:	5e                   	pop    %esi
 316:	5d                   	pop    %ebp
 317:	c3                   	ret    
 318:	90                   	nop
 319:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      printf(1, "panic at thread_create\n");
 320:	83 ec 08             	sub    $0x8,%esp
 323:	68 3b 0e 00 00       	push   $0xe3b
 328:	6a 01                	push   $0x1
 32a:	e8 a1 07 00 00       	call   ad0 <printf>
      return -1;
 32f:	83 c4 10             	add    $0x10,%esp
}
 332:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return -1;
 335:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
 33a:	5b                   	pop    %ebx
 33b:	5e                   	pop    %esi
 33c:	5d                   	pop    %ebp
 33d:	c3                   	ret    
 33e:	66 90                	xchg   %ax,%ax
      printf(1, "panic at thread_join\n");
 340:	83 ec 08             	sub    $0x8,%esp
 343:	68 63 0e 00 00       	push   $0xe63
 348:	6a 01                	push   $0x1
 34a:	e8 81 07 00 00       	call   ad0 <printf>
      return -1;
 34f:	83 c4 10             	add    $0x10,%esp
}
 352:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return -1;
 355:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
 35a:	5b                   	pop    %ebx
 35b:	5e                   	pop    %esi
 35c:	5d                   	pop    %ebp
 35d:	c3                   	ret    
 35e:	66 90                	xchg   %ax,%ax

00000360 <jointest1>:
{
 360:	55                   	push   %ebp
 361:	89 e5                	mov    %esp,%ebp
 363:	56                   	push   %esi
 364:	53                   	push   %ebx
 365:	8d 75 cc             	lea    -0x34(%ebp),%esi
  for (i = 1; i <= NUM_THREAD; i++){
 368:	bb 01 00 00 00       	mov    $0x1,%ebx
{
 36d:	83 ec 40             	sub    $0x40,%esp
    if (thread_create(&threads[i-1], jointhreadmain, (void*)i) != 0){
 370:	8d 04 9e             	lea    (%esi,%ebx,4),%eax
 373:	83 ec 04             	sub    $0x4,%esp
 376:	53                   	push   %ebx
 377:	68 20 02 00 00       	push   $0x220
 37c:	50                   	push   %eax
 37d:	e8 70 06 00 00       	call   9f2 <thread_create>
 382:	83 c4 10             	add    $0x10,%esp
 385:	85 c0                	test   %eax,%eax
 387:	75 67                	jne    3f0 <jointest1+0x90>
  for (i = 1; i <= NUM_THREAD; i++){
 389:	83 c3 01             	add    $0x1,%ebx
 38c:	83 fb 0b             	cmp    $0xb,%ebx
 38f:	75 df                	jne    370 <jointest1+0x10>
  printf(1, "thread_join!!!\n");
 391:	83 ec 08             	sub    $0x8,%esp
 394:	bb 02 00 00 00       	mov    $0x2,%ebx
 399:	68 53 0e 00 00       	push   $0xe53
 39e:	6a 01                	push   $0x1
 3a0:	e8 2b 07 00 00       	call   ad0 <printf>
 3a5:	83 c4 10             	add    $0x10,%esp
 3a8:	90                   	nop
 3a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if (thread_join(threads[i-1], &retval) != 0 || (int)retval != i * 2 ){
 3b0:	83 ec 08             	sub    $0x8,%esp
 3b3:	56                   	push   %esi
 3b4:	ff 74 5d cc          	pushl  -0x34(%ebp,%ebx,2)
 3b8:	e8 3d 06 00 00       	call   9fa <thread_join>
 3bd:	83 c4 10             	add    $0x10,%esp
 3c0:	85 c0                	test   %eax,%eax
 3c2:	75 4c                	jne    410 <jointest1+0xb0>
 3c4:	39 5d cc             	cmp    %ebx,-0x34(%ebp)
 3c7:	75 47                	jne    410 <jointest1+0xb0>
 3c9:	83 c3 02             	add    $0x2,%ebx
  for (i = 1; i <= NUM_THREAD; i++){
 3cc:	83 fb 16             	cmp    $0x16,%ebx
 3cf:	75 df                	jne    3b0 <jointest1+0x50>
  printf(1,"\n");
 3d1:	83 ec 08             	sub    $0x8,%esp
 3d4:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 3d7:	68 61 0e 00 00       	push   $0xe61
 3dc:	6a 01                	push   $0x1
 3de:	e8 ed 06 00 00       	call   ad0 <printf>
  return 0;
 3e3:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 3e6:	83 c4 10             	add    $0x10,%esp
}
 3e9:	8d 65 f8             	lea    -0x8(%ebp),%esp
 3ec:	5b                   	pop    %ebx
 3ed:	5e                   	pop    %esi
 3ee:	5d                   	pop    %ebp
 3ef:	c3                   	ret    
      printf(1, "panic at thread_create\n");
 3f0:	83 ec 08             	sub    $0x8,%esp
 3f3:	68 3b 0e 00 00       	push   $0xe3b
 3f8:	6a 01                	push   $0x1
 3fa:	e8 d1 06 00 00       	call   ad0 <printf>
      return -1;
 3ff:	83 c4 10             	add    $0x10,%esp
}
 402:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return -1;
 405:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
 40a:	5b                   	pop    %ebx
 40b:	5e                   	pop    %esi
 40c:	5d                   	pop    %ebp
 40d:	c3                   	ret    
 40e:	66 90                	xchg   %ax,%ax
      printf(1, "panic at thread_join\n");
 410:	83 ec 08             	sub    $0x8,%esp
 413:	68 63 0e 00 00       	push   $0xe63
 418:	6a 01                	push   $0x1
 41a:	e8 b1 06 00 00       	call   ad0 <printf>
 41f:	83 c4 10             	add    $0x10,%esp
}
 422:	8d 65 f8             	lea    -0x8(%ebp),%esp
      printf(1, "panic at thread_join\n");
 425:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
 42a:	5b                   	pop    %ebx
 42b:	5e                   	pop    %esi
 42c:	5d                   	pop    %ebp
 42d:	c3                   	ret    
 42e:	66 90                	xchg   %ax,%ax

00000430 <stresstest>:
}

int
stresstest(void)
{
 430:	55                   	push   %ebp
 431:	89 e5                	mov    %esp,%ebp
 433:	57                   	push   %edi
 434:	56                   	push   %esi
 435:	53                   	push   %ebx
 436:	8d 75 bc             	lea    -0x44(%ebp),%esi
 439:	83 ec 4c             	sub    $0x4c,%esp
  const int nstress = 35000;
  thread_t threads[NUM_THREAD];
  int i, n;
  void *retval;

  for (n = 1; n <= nstress; n++){
 43c:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
 443:	31 ff                	xor    %edi,%edi
 445:	8d 76 00             	lea    0x0(%esi),%esi
    if (n % 1000 == 0)
      printf(1, "%d\n", n);
    for (i = 0; i < NUM_THREAD; i++){
      if (thread_create(&threads[i], stressthreadmain, (void*)i) != 0){
 448:	8d 44 bd c0          	lea    -0x40(%ebp,%edi,4),%eax
 44c:	83 ec 04             	sub    $0x4,%esp
 44f:	8d 5d c0             	lea    -0x40(%ebp),%ebx
 452:	57                   	push   %edi
 453:	68 50 02 00 00       	push   $0x250
 458:	50                   	push   %eax
 459:	e8 94 05 00 00       	call   9f2 <thread_create>
 45e:	83 c4 10             	add    $0x10,%esp
 461:	85 c0                	test   %eax,%eax
 463:	75 6b                	jne    4d0 <stresstest+0xa0>
    for (i = 0; i < NUM_THREAD; i++){
 465:	83 c7 01             	add    $0x1,%edi
 468:	83 ff 0a             	cmp    $0xa,%edi
 46b:	75 db                	jne    448 <stresstest+0x18>
 46d:	8d 76 00             	lea    0x0(%esi),%esi
        printf(1, "panic at thread_create\n");
        return -1;
      }
    }
    for (i = 0; i < NUM_THREAD; i++){
      if (thread_join(threads[i], &retval) != 0){
 470:	83 ec 08             	sub    $0x8,%esp
 473:	56                   	push   %esi
 474:	ff 33                	pushl  (%ebx)
 476:	e8 7f 05 00 00       	call   9fa <thread_join>
 47b:	83 c4 10             	add    $0x10,%esp
 47e:	85 c0                	test   %eax,%eax
 480:	75 6e                	jne    4f0 <stresstest+0xc0>
    for (i = 0; i < NUM_THREAD; i++){
 482:	8d 4d e8             	lea    -0x18(%ebp),%ecx
 485:	83 c3 04             	add    $0x4,%ebx
 488:	39 cb                	cmp    %ecx,%ebx
 48a:	75 e4                	jne    470 <stresstest+0x40>
  for (n = 1; n <= nstress; n++){
 48c:	83 45 b4 01          	addl   $0x1,-0x4c(%ebp)
 490:	8b 55 b4             	mov    -0x4c(%ebp),%edx
 493:	81 fa b9 88 00 00    	cmp    $0x88b9,%edx
 499:	74 74                	je     50f <stresstest+0xdf>
    if (n % 1000 == 0)
 49b:	8b 45 b4             	mov    -0x4c(%ebp),%eax
 49e:	ba d3 4d 62 10       	mov    $0x10624dd3,%edx
 4a3:	f7 e2                	mul    %edx
 4a5:	8b 45 b4             	mov    -0x4c(%ebp),%eax
 4a8:	c1 ea 06             	shr    $0x6,%edx
 4ab:	69 d2 e8 03 00 00    	imul   $0x3e8,%edx,%edx
 4b1:	39 d0                	cmp    %edx,%eax
 4b3:	75 8e                	jne    443 <stresstest+0x13>
      printf(1, "%d\n", n);
 4b5:	83 ec 04             	sub    $0x4,%esp
 4b8:	50                   	push   %eax
 4b9:	68 79 0e 00 00       	push   $0xe79
 4be:	6a 01                	push   $0x1
 4c0:	e8 0b 06 00 00       	call   ad0 <printf>
 4c5:	83 c4 10             	add    $0x10,%esp
 4c8:	e9 76 ff ff ff       	jmp    443 <stresstest+0x13>
 4cd:	8d 76 00             	lea    0x0(%esi),%esi
        printf(1, "panic at thread_create\n");
 4d0:	83 ec 08             	sub    $0x8,%esp
 4d3:	68 3b 0e 00 00       	push   $0xe3b
 4d8:	6a 01                	push   $0x1
 4da:	e8 f1 05 00 00       	call   ad0 <printf>
        return -1;
 4df:	83 c4 10             	add    $0x10,%esp
 4e2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      }
    }
  }
  printf(1, "\n");
  return 0;
}
 4e7:	8d 65 f4             	lea    -0xc(%ebp),%esp
 4ea:	5b                   	pop    %ebx
 4eb:	5e                   	pop    %esi
 4ec:	5f                   	pop    %edi
 4ed:	5d                   	pop    %ebp
 4ee:	c3                   	ret    
 4ef:	90                   	nop
        printf(1, "panic at thread_join\n");
 4f0:	83 ec 08             	sub    $0x8,%esp
 4f3:	68 63 0e 00 00       	push   $0xe63
 4f8:	6a 01                	push   $0x1
 4fa:	e8 d1 05 00 00       	call   ad0 <printf>
        return -1;
 4ff:	83 c4 10             	add    $0x10,%esp
}
 502:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return -1;
 505:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
 50a:	5b                   	pop    %ebx
 50b:	5e                   	pop    %esi
 50c:	5f                   	pop    %edi
 50d:	5d                   	pop    %ebp
 50e:	c3                   	ret    
  printf(1, "\n");
 50f:	83 ec 08             	sub    $0x8,%esp
 512:	89 45 b4             	mov    %eax,-0x4c(%ebp)
 515:	68 61 0e 00 00       	push   $0xe61
 51a:	6a 01                	push   $0x1
 51c:	e8 af 05 00 00       	call   ad0 <printf>
 521:	83 c4 10             	add    $0x10,%esp
 524:	8b 45 b4             	mov    -0x4c(%ebp),%eax
 527:	eb be                	jmp    4e7 <stresstest+0xb7>
 529:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000530 <basictest>:
{
 530:	55                   	push   %ebp
 531:	89 e5                	mov    %esp,%ebp
 533:	56                   	push   %esi
 534:	53                   	push   %ebx
  for (i = 0; i < NUM_THREAD; i++){
 535:	31 db                	xor    %ebx,%ebx
{
 537:	83 ec 40             	sub    $0x40,%esp
 53a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if (thread_create(&threads[i], basicthreadmain, (void*)i) != 0){
 540:	8d 44 9d d0          	lea    -0x30(%ebp,%ebx,4),%eax
 544:	83 ec 04             	sub    $0x4,%esp
 547:	53                   	push   %ebx
 548:	68 c0 01 00 00       	push   $0x1c0
 54d:	50                   	push   %eax
 54e:	e8 9f 04 00 00       	call   9f2 <thread_create>
 553:	83 c4 10             	add    $0x10,%esp
 556:	85 c0                	test   %eax,%eax
 558:	89 c6                	mov    %eax,%esi
 55a:	75 54                	jne    5b0 <basictest+0x80>
  for (i = 0; i < NUM_THREAD; i++){
 55c:	83 c3 01             	add    $0x1,%ebx
 55f:	83 fb 0a             	cmp    $0xa,%ebx
 562:	75 dc                	jne    540 <basictest+0x10>
 564:	8d 5d cc             	lea    -0x34(%ebp),%ebx
 567:	89 f6                	mov    %esi,%esi
 569:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if (thread_join(threads[i], &retval) != 0 || (int)retval != i+1){
 570:	83 ec 08             	sub    $0x8,%esp
 573:	53                   	push   %ebx
 574:	ff 74 b5 d0          	pushl  -0x30(%ebp,%esi,4)
 578:	e8 7d 04 00 00       	call   9fa <thread_join>
 57d:	83 c4 10             	add    $0x10,%esp
 580:	85 c0                	test   %eax,%eax
 582:	75 4c                	jne    5d0 <basictest+0xa0>
 584:	83 c6 01             	add    $0x1,%esi
 587:	39 75 cc             	cmp    %esi,-0x34(%ebp)
 58a:	75 44                	jne    5d0 <basictest+0xa0>
  for (i = 0; i < NUM_THREAD; i++){
 58c:	83 fe 0a             	cmp    $0xa,%esi
 58f:	75 df                	jne    570 <basictest+0x40>
  printf(1,"\n");
 591:	83 ec 08             	sub    $0x8,%esp
 594:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 597:	68 61 0e 00 00       	push   $0xe61
 59c:	6a 01                	push   $0x1
 59e:	e8 2d 05 00 00       	call   ad0 <printf>
  return 0;
 5a3:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 5a6:	83 c4 10             	add    $0x10,%esp
}
 5a9:	8d 65 f8             	lea    -0x8(%ebp),%esp
 5ac:	5b                   	pop    %ebx
 5ad:	5e                   	pop    %esi
 5ae:	5d                   	pop    %ebp
 5af:	c3                   	ret    
      printf(1, "panic at thread_create\n");
 5b0:	83 ec 08             	sub    $0x8,%esp
 5b3:	68 3b 0e 00 00       	push   $0xe3b
 5b8:	6a 01                	push   $0x1
 5ba:	e8 11 05 00 00       	call   ad0 <printf>
      return -1;
 5bf:	83 c4 10             	add    $0x10,%esp
}
 5c2:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return -1;
 5c5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
 5ca:	5b                   	pop    %ebx
 5cb:	5e                   	pop    %esi
 5cc:	5d                   	pop    %ebp
 5cd:	c3                   	ret    
 5ce:	66 90                	xchg   %ax,%ax
      printf(1, "panic at thread_join\n");
 5d0:	83 ec 08             	sub    $0x8,%esp
 5d3:	68 63 0e 00 00       	push   $0xe63
 5d8:	6a 01                	push   $0x1
 5da:	e8 f1 04 00 00       	call   ad0 <printf>
 5df:	83 c4 10             	add    $0x10,%esp
}
 5e2:	8d 65 f8             	lea    -0x8(%ebp),%esp
      printf(1, "panic at thread_join\n");
 5e5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
 5ea:	5b                   	pop    %ebx
 5eb:	5e                   	pop    %esi
 5ec:	5d                   	pop    %ebp
 5ed:	c3                   	ret    
 5ee:	66 90                	xchg   %ax,%ax

000005f0 <racingtest>:
{
 5f0:	55                   	push   %ebp
 5f1:	89 e5                	mov    %esp,%ebp
 5f3:	56                   	push   %esi
 5f4:	53                   	push   %ebx
  for (i = 0; i < NUM_THREAD; i++){
 5f5:	31 db                	xor    %ebx,%ebx
{
 5f7:	83 ec 40             	sub    $0x40,%esp
  gcnt = 0;
 5fa:	c7 05 b4 13 00 00 00 	movl   $0x0,0x13b4
 601:	00 00 00 
 604:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if (thread_create(&threads[i], racingthreadmain, (void*)i) != 0){
 608:	8d 44 9d d0          	lea    -0x30(%ebp,%ebx,4),%eax
 60c:	83 ec 04             	sub    $0x4,%esp
 60f:	53                   	push   %ebx
 610:	68 60 02 00 00       	push   $0x260
 615:	50                   	push   %eax
 616:	e8 d7 03 00 00       	call   9f2 <thread_create>
 61b:	83 c4 10             	add    $0x10,%esp
 61e:	85 c0                	test   %eax,%eax
 620:	89 c6                	mov    %eax,%esi
 622:	75 5c                	jne    680 <racingtest+0x90>
  for (i = 0; i < NUM_THREAD; i++){
 624:	83 c3 01             	add    $0x1,%ebx
 627:	83 fb 0a             	cmp    $0xa,%ebx
 62a:	75 dc                	jne    608 <racingtest+0x18>
 62c:	8d 5d cc             	lea    -0x34(%ebp),%ebx
 62f:	90                   	nop
    if (thread_join(threads[i], &retval) != 0 || (int)retval != i+1){
 630:	83 ec 08             	sub    $0x8,%esp
 633:	53                   	push   %ebx
 634:	ff 74 b5 d0          	pushl  -0x30(%ebp,%esi,4)
 638:	e8 bd 03 00 00       	call   9fa <thread_join>
 63d:	83 c4 10             	add    $0x10,%esp
 640:	85 c0                	test   %eax,%eax
 642:	75 5c                	jne    6a0 <racingtest+0xb0>
 644:	83 c6 01             	add    $0x1,%esi
 647:	39 75 cc             	cmp    %esi,-0x34(%ebp)
 64a:	75 54                	jne    6a0 <racingtest+0xb0>
  for (i = 0; i < NUM_THREAD; i++){
 64c:	83 fe 0a             	cmp    $0xa,%esi
 64f:	75 df                	jne    630 <racingtest+0x40>
  printf(1,"%d\n", gcnt);
 651:	83 ec 04             	sub    $0x4,%esp
 654:	ff 35 b4 13 00 00    	pushl  0x13b4
 65a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 65d:	68 79 0e 00 00       	push   $0xe79
 662:	6a 01                	push   $0x1
 664:	e8 67 04 00 00       	call   ad0 <printf>
  return 0;
 669:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 66c:	83 c4 10             	add    $0x10,%esp
}
 66f:	8d 65 f8             	lea    -0x8(%ebp),%esp
 672:	5b                   	pop    %ebx
 673:	5e                   	pop    %esi
 674:	5d                   	pop    %ebp
 675:	c3                   	ret    
 676:	8d 76 00             	lea    0x0(%esi),%esi
 679:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      printf(1, "panic at thread_create\n");
 680:	83 ec 08             	sub    $0x8,%esp
 683:	68 3b 0e 00 00       	push   $0xe3b
 688:	6a 01                	push   $0x1
 68a:	e8 41 04 00 00       	call   ad0 <printf>
      return -1;
 68f:	83 c4 10             	add    $0x10,%esp
}
 692:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return -1;
 695:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
 69a:	5b                   	pop    %ebx
 69b:	5e                   	pop    %esi
 69c:	5d                   	pop    %ebp
 69d:	c3                   	ret    
 69e:	66 90                	xchg   %ax,%ax
      printf(1, "panic at thread_join\n");
 6a0:	83 ec 08             	sub    $0x8,%esp
 6a3:	68 63 0e 00 00       	push   $0xe63
 6a8:	6a 01                	push   $0x1
 6aa:	e8 21 04 00 00       	call   ad0 <printf>
 6af:	83 c4 10             	add    $0x10,%esp
}
 6b2:	8d 65 f8             	lea    -0x8(%ebp),%esp
      printf(1, "panic at thread_join\n");
 6b5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
 6ba:	5b                   	pop    %ebx
 6bb:	5e                   	pop    %esi
 6bc:	5d                   	pop    %ebp
 6bd:	c3                   	ret    
 6be:	66 90                	xchg   %ax,%ax

000006c0 <nop>:
void nop(){ }
 6c0:	55                   	push   %ebp
 6c1:	89 e5                	mov    %esp,%ebp
 6c3:	5d                   	pop    %ebp
 6c4:	c3                   	ret    
 6c5:	66 90                	xchg   %ax,%ax
 6c7:	66 90                	xchg   %ax,%ax
 6c9:	66 90                	xchg   %ax,%ax
 6cb:	66 90                	xchg   %ax,%ax
 6cd:	66 90                	xchg   %ax,%ax
 6cf:	90                   	nop

000006d0 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 6d0:	55                   	push   %ebp
 6d1:	89 e5                	mov    %esp,%ebp
 6d3:	53                   	push   %ebx
 6d4:	8b 45 08             	mov    0x8(%ebp),%eax
 6d7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 6da:	89 c2                	mov    %eax,%edx
 6dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 6e0:	83 c1 01             	add    $0x1,%ecx
 6e3:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
 6e7:	83 c2 01             	add    $0x1,%edx
 6ea:	84 db                	test   %bl,%bl
 6ec:	88 5a ff             	mov    %bl,-0x1(%edx)
 6ef:	75 ef                	jne    6e0 <strcpy+0x10>
    ;
  return os;
}
 6f1:	5b                   	pop    %ebx
 6f2:	5d                   	pop    %ebp
 6f3:	c3                   	ret    
 6f4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 6fa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000700 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 700:	55                   	push   %ebp
 701:	89 e5                	mov    %esp,%ebp
 703:	53                   	push   %ebx
 704:	8b 55 08             	mov    0x8(%ebp),%edx
 707:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
 70a:	0f b6 02             	movzbl (%edx),%eax
 70d:	0f b6 19             	movzbl (%ecx),%ebx
 710:	84 c0                	test   %al,%al
 712:	75 1c                	jne    730 <strcmp+0x30>
 714:	eb 2a                	jmp    740 <strcmp+0x40>
 716:	8d 76 00             	lea    0x0(%esi),%esi
 719:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    p++, q++;
 720:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
 723:	0f b6 02             	movzbl (%edx),%eax
    p++, q++;
 726:	83 c1 01             	add    $0x1,%ecx
 729:	0f b6 19             	movzbl (%ecx),%ebx
  while(*p && *p == *q)
 72c:	84 c0                	test   %al,%al
 72e:	74 10                	je     740 <strcmp+0x40>
 730:	38 d8                	cmp    %bl,%al
 732:	74 ec                	je     720 <strcmp+0x20>
  return (uchar)*p - (uchar)*q;
 734:	29 d8                	sub    %ebx,%eax
}
 736:	5b                   	pop    %ebx
 737:	5d                   	pop    %ebp
 738:	c3                   	ret    
 739:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 740:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
 742:	29 d8                	sub    %ebx,%eax
}
 744:	5b                   	pop    %ebx
 745:	5d                   	pop    %ebp
 746:	c3                   	ret    
 747:	89 f6                	mov    %esi,%esi
 749:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000750 <strlen>:

uint
strlen(const char *s)
{
 750:	55                   	push   %ebp
 751:	89 e5                	mov    %esp,%ebp
 753:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 756:	80 39 00             	cmpb   $0x0,(%ecx)
 759:	74 15                	je     770 <strlen+0x20>
 75b:	31 d2                	xor    %edx,%edx
 75d:	8d 76 00             	lea    0x0(%esi),%esi
 760:	83 c2 01             	add    $0x1,%edx
 763:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
 767:	89 d0                	mov    %edx,%eax
 769:	75 f5                	jne    760 <strlen+0x10>
    ;
  return n;
}
 76b:	5d                   	pop    %ebp
 76c:	c3                   	ret    
 76d:	8d 76 00             	lea    0x0(%esi),%esi
  for(n = 0; s[n]; n++)
 770:	31 c0                	xor    %eax,%eax
}
 772:	5d                   	pop    %ebp
 773:	c3                   	ret    
 774:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 77a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000780 <memset>:

void*
memset(void *dst, int c, uint n)
{
 780:	55                   	push   %ebp
 781:	89 e5                	mov    %esp,%ebp
 783:	57                   	push   %edi
 784:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 787:	8b 4d 10             	mov    0x10(%ebp),%ecx
 78a:	8b 45 0c             	mov    0xc(%ebp),%eax
 78d:	89 d7                	mov    %edx,%edi
 78f:	fc                   	cld    
 790:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 792:	89 d0                	mov    %edx,%eax
 794:	5f                   	pop    %edi
 795:	5d                   	pop    %ebp
 796:	c3                   	ret    
 797:	89 f6                	mov    %esi,%esi
 799:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000007a0 <strchr>:

char*
strchr(const char *s, char c)
{
 7a0:	55                   	push   %ebp
 7a1:	89 e5                	mov    %esp,%ebp
 7a3:	53                   	push   %ebx
 7a4:	8b 45 08             	mov    0x8(%ebp),%eax
 7a7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  for(; *s; s++)
 7aa:	0f b6 10             	movzbl (%eax),%edx
 7ad:	84 d2                	test   %dl,%dl
 7af:	74 1d                	je     7ce <strchr+0x2e>
    if(*s == c)
 7b1:	38 d3                	cmp    %dl,%bl
 7b3:	89 d9                	mov    %ebx,%ecx
 7b5:	75 0d                	jne    7c4 <strchr+0x24>
 7b7:	eb 17                	jmp    7d0 <strchr+0x30>
 7b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 7c0:	38 ca                	cmp    %cl,%dl
 7c2:	74 0c                	je     7d0 <strchr+0x30>
  for(; *s; s++)
 7c4:	83 c0 01             	add    $0x1,%eax
 7c7:	0f b6 10             	movzbl (%eax),%edx
 7ca:	84 d2                	test   %dl,%dl
 7cc:	75 f2                	jne    7c0 <strchr+0x20>
      return (char*)s;
  return 0;
 7ce:	31 c0                	xor    %eax,%eax
}
 7d0:	5b                   	pop    %ebx
 7d1:	5d                   	pop    %ebp
 7d2:	c3                   	ret    
 7d3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 7d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000007e0 <gets>:

char*
gets(char *buf, int max)
{
 7e0:	55                   	push   %ebp
 7e1:	89 e5                	mov    %esp,%ebp
 7e3:	57                   	push   %edi
 7e4:	56                   	push   %esi
 7e5:	53                   	push   %ebx
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 7e6:	31 f6                	xor    %esi,%esi
 7e8:	89 f3                	mov    %esi,%ebx
{
 7ea:	83 ec 1c             	sub    $0x1c,%esp
 7ed:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i=0; i+1 < max; ){
 7f0:	eb 2f                	jmp    821 <gets+0x41>
 7f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cc = read(0, &c, 1);
 7f8:	8d 45 e7             	lea    -0x19(%ebp),%eax
 7fb:	83 ec 04             	sub    $0x4,%esp
 7fe:	6a 01                	push   $0x1
 800:	50                   	push   %eax
 801:	6a 00                	push   $0x0
 803:	e8 32 01 00 00       	call   93a <read>
    if(cc < 1)
 808:	83 c4 10             	add    $0x10,%esp
 80b:	85 c0                	test   %eax,%eax
 80d:	7e 1c                	jle    82b <gets+0x4b>
      break;
    buf[i++] = c;
 80f:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 813:	83 c7 01             	add    $0x1,%edi
 816:	88 47 ff             	mov    %al,-0x1(%edi)
    if(c == '\n' || c == '\r')
 819:	3c 0a                	cmp    $0xa,%al
 81b:	74 23                	je     840 <gets+0x60>
 81d:	3c 0d                	cmp    $0xd,%al
 81f:	74 1f                	je     840 <gets+0x60>
  for(i=0; i+1 < max; ){
 821:	83 c3 01             	add    $0x1,%ebx
 824:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 827:	89 fe                	mov    %edi,%esi
 829:	7c cd                	jl     7f8 <gets+0x18>
 82b:	89 f3                	mov    %esi,%ebx
      break;
  }
  buf[i] = '\0';
  return buf;
}
 82d:	8b 45 08             	mov    0x8(%ebp),%eax
  buf[i] = '\0';
 830:	c6 03 00             	movb   $0x0,(%ebx)
}
 833:	8d 65 f4             	lea    -0xc(%ebp),%esp
 836:	5b                   	pop    %ebx
 837:	5e                   	pop    %esi
 838:	5f                   	pop    %edi
 839:	5d                   	pop    %ebp
 83a:	c3                   	ret    
 83b:	90                   	nop
 83c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 840:	8b 75 08             	mov    0x8(%ebp),%esi
 843:	8b 45 08             	mov    0x8(%ebp),%eax
 846:	01 de                	add    %ebx,%esi
 848:	89 f3                	mov    %esi,%ebx
  buf[i] = '\0';
 84a:	c6 03 00             	movb   $0x0,(%ebx)
}
 84d:	8d 65 f4             	lea    -0xc(%ebp),%esp
 850:	5b                   	pop    %ebx
 851:	5e                   	pop    %esi
 852:	5f                   	pop    %edi
 853:	5d                   	pop    %ebp
 854:	c3                   	ret    
 855:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 859:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000860 <stat>:

int
stat(const char *n, struct stat *st)
{
 860:	55                   	push   %ebp
 861:	89 e5                	mov    %esp,%ebp
 863:	56                   	push   %esi
 864:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 865:	83 ec 08             	sub    $0x8,%esp
 868:	6a 00                	push   $0x0
 86a:	ff 75 08             	pushl  0x8(%ebp)
 86d:	e8 f0 00 00 00       	call   962 <open>
  if(fd < 0)
 872:	83 c4 10             	add    $0x10,%esp
 875:	85 c0                	test   %eax,%eax
 877:	78 27                	js     8a0 <stat+0x40>
    return -1;
  r = fstat(fd, st);
 879:	83 ec 08             	sub    $0x8,%esp
 87c:	ff 75 0c             	pushl  0xc(%ebp)
 87f:	89 c3                	mov    %eax,%ebx
 881:	50                   	push   %eax
 882:	e8 f3 00 00 00       	call   97a <fstat>
  close(fd);
 887:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 88a:	89 c6                	mov    %eax,%esi
  close(fd);
 88c:	e8 b9 00 00 00       	call   94a <close>
  return r;
 891:	83 c4 10             	add    $0x10,%esp
}
 894:	8d 65 f8             	lea    -0x8(%ebp),%esp
 897:	89 f0                	mov    %esi,%eax
 899:	5b                   	pop    %ebx
 89a:	5e                   	pop    %esi
 89b:	5d                   	pop    %ebp
 89c:	c3                   	ret    
 89d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 8a0:	be ff ff ff ff       	mov    $0xffffffff,%esi
 8a5:	eb ed                	jmp    894 <stat+0x34>
 8a7:	89 f6                	mov    %esi,%esi
 8a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000008b0 <atoi>:

int
atoi(const char *s)
{
 8b0:	55                   	push   %ebp
 8b1:	89 e5                	mov    %esp,%ebp
 8b3:	53                   	push   %ebx
 8b4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 8b7:	0f be 11             	movsbl (%ecx),%edx
 8ba:	8d 42 d0             	lea    -0x30(%edx),%eax
 8bd:	3c 09                	cmp    $0x9,%al
  n = 0;
 8bf:	b8 00 00 00 00       	mov    $0x0,%eax
  while('0' <= *s && *s <= '9')
 8c4:	77 1f                	ja     8e5 <atoi+0x35>
 8c6:	8d 76 00             	lea    0x0(%esi),%esi
 8c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    n = n*10 + *s++ - '0';
 8d0:	8d 04 80             	lea    (%eax,%eax,4),%eax
 8d3:	83 c1 01             	add    $0x1,%ecx
 8d6:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
  while('0' <= *s && *s <= '9')
 8da:	0f be 11             	movsbl (%ecx),%edx
 8dd:	8d 5a d0             	lea    -0x30(%edx),%ebx
 8e0:	80 fb 09             	cmp    $0x9,%bl
 8e3:	76 eb                	jbe    8d0 <atoi+0x20>
  return n;
}
 8e5:	5b                   	pop    %ebx
 8e6:	5d                   	pop    %ebp
 8e7:	c3                   	ret    
 8e8:	90                   	nop
 8e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

000008f0 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 8f0:	55                   	push   %ebp
 8f1:	89 e5                	mov    %esp,%ebp
 8f3:	56                   	push   %esi
 8f4:	53                   	push   %ebx
 8f5:	8b 5d 10             	mov    0x10(%ebp),%ebx
 8f8:	8b 45 08             	mov    0x8(%ebp),%eax
 8fb:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 8fe:	85 db                	test   %ebx,%ebx
 900:	7e 14                	jle    916 <memmove+0x26>
 902:	31 d2                	xor    %edx,%edx
 904:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *dst++ = *src++;
 908:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
 90c:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 90f:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0)
 912:	39 d3                	cmp    %edx,%ebx
 914:	75 f2                	jne    908 <memmove+0x18>
  return vdst;
}
 916:	5b                   	pop    %ebx
 917:	5e                   	pop    %esi
 918:	5d                   	pop    %ebp
 919:	c3                   	ret    

0000091a <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 91a:	b8 01 00 00 00       	mov    $0x1,%eax
 91f:	cd 40                	int    $0x40
 921:	c3                   	ret    

00000922 <exit>:
SYSCALL(exit)
 922:	b8 02 00 00 00       	mov    $0x2,%eax
 927:	cd 40                	int    $0x40
 929:	c3                   	ret    

0000092a <wait>:
SYSCALL(wait)
 92a:	b8 03 00 00 00       	mov    $0x3,%eax
 92f:	cd 40                	int    $0x40
 931:	c3                   	ret    

00000932 <pipe>:
SYSCALL(pipe)
 932:	b8 04 00 00 00       	mov    $0x4,%eax
 937:	cd 40                	int    $0x40
 939:	c3                   	ret    

0000093a <read>:
SYSCALL(read)
 93a:	b8 05 00 00 00       	mov    $0x5,%eax
 93f:	cd 40                	int    $0x40
 941:	c3                   	ret    

00000942 <write>:
SYSCALL(write)
 942:	b8 10 00 00 00       	mov    $0x10,%eax
 947:	cd 40                	int    $0x40
 949:	c3                   	ret    

0000094a <close>:
SYSCALL(close)
 94a:	b8 15 00 00 00       	mov    $0x15,%eax
 94f:	cd 40                	int    $0x40
 951:	c3                   	ret    

00000952 <kill>:
SYSCALL(kill)
 952:	b8 06 00 00 00       	mov    $0x6,%eax
 957:	cd 40                	int    $0x40
 959:	c3                   	ret    

0000095a <exec>:
SYSCALL(exec)
 95a:	b8 07 00 00 00       	mov    $0x7,%eax
 95f:	cd 40                	int    $0x40
 961:	c3                   	ret    

00000962 <open>:
SYSCALL(open)
 962:	b8 0f 00 00 00       	mov    $0xf,%eax
 967:	cd 40                	int    $0x40
 969:	c3                   	ret    

0000096a <mknod>:
SYSCALL(mknod)
 96a:	b8 11 00 00 00       	mov    $0x11,%eax
 96f:	cd 40                	int    $0x40
 971:	c3                   	ret    

00000972 <unlink>:
SYSCALL(unlink)
 972:	b8 12 00 00 00       	mov    $0x12,%eax
 977:	cd 40                	int    $0x40
 979:	c3                   	ret    

0000097a <fstat>:
SYSCALL(fstat)
 97a:	b8 08 00 00 00       	mov    $0x8,%eax
 97f:	cd 40                	int    $0x40
 981:	c3                   	ret    

00000982 <link>:
SYSCALL(link)
 982:	b8 13 00 00 00       	mov    $0x13,%eax
 987:	cd 40                	int    $0x40
 989:	c3                   	ret    

0000098a <mkdir>:
SYSCALL(mkdir)
 98a:	b8 14 00 00 00       	mov    $0x14,%eax
 98f:	cd 40                	int    $0x40
 991:	c3                   	ret    

00000992 <chdir>:
SYSCALL(chdir)
 992:	b8 09 00 00 00       	mov    $0x9,%eax
 997:	cd 40                	int    $0x40
 999:	c3                   	ret    

0000099a <dup>:
SYSCALL(dup)
 99a:	b8 0a 00 00 00       	mov    $0xa,%eax
 99f:	cd 40                	int    $0x40
 9a1:	c3                   	ret    

000009a2 <getpid>:
SYSCALL(getpid)
 9a2:	b8 0b 00 00 00       	mov    $0xb,%eax
 9a7:	cd 40                	int    $0x40
 9a9:	c3                   	ret    

000009aa <sbrk>:
SYSCALL(sbrk)
 9aa:	b8 0c 00 00 00       	mov    $0xc,%eax
 9af:	cd 40                	int    $0x40
 9b1:	c3                   	ret    

000009b2 <sleep>:
SYSCALL(sleep)
 9b2:	b8 0d 00 00 00       	mov    $0xd,%eax
 9b7:	cd 40                	int    $0x40
 9b9:	c3                   	ret    

000009ba <uptime>:
SYSCALL(uptime)
 9ba:	b8 0e 00 00 00       	mov    $0xe,%eax
 9bf:	cd 40                	int    $0x40
 9c1:	c3                   	ret    

000009c2 <myfunction>:
SYSCALL(myfunction)
 9c2:	b8 16 00 00 00       	mov    $0x16,%eax
 9c7:	cd 40                	int    $0x40
 9c9:	c3                   	ret    

000009ca <getppid>:
SYSCALL(getppid)
 9ca:	b8 17 00 00 00       	mov    $0x17,%eax
 9cf:	cd 40                	int    $0x40
 9d1:	c3                   	ret    

000009d2 <yield>:
SYSCALL(yield)
 9d2:	b8 18 00 00 00       	mov    $0x18,%eax
 9d7:	cd 40                	int    $0x40
 9d9:	c3                   	ret    

000009da <getlev>:
SYSCALL(getlev)
 9da:	b8 19 00 00 00       	mov    $0x19,%eax
 9df:	cd 40                	int    $0x40
 9e1:	c3                   	ret    

000009e2 <set_cpu_share>:
SYSCALL(set_cpu_share)
 9e2:	b8 1a 00 00 00       	mov    $0x1a,%eax
 9e7:	cd 40                	int    $0x40
 9e9:	c3                   	ret    

000009ea <thread_exit>:
SYSCALL(thread_exit)
 9ea:	b8 1d 00 00 00       	mov    $0x1d,%eax
 9ef:	cd 40                	int    $0x40
 9f1:	c3                   	ret    

000009f2 <thread_create>:
SYSCALL(thread_create)
 9f2:	b8 1b 00 00 00       	mov    $0x1b,%eax
 9f7:	cd 40                	int    $0x40
 9f9:	c3                   	ret    

000009fa <thread_join>:
SYSCALL(thread_join)
 9fa:	b8 1c 00 00 00       	mov    $0x1c,%eax
 9ff:	cd 40                	int    $0x40
 a01:	c3                   	ret    

00000a02 <pread>:
SYSCALL(pread)
 a02:	b8 1e 00 00 00       	mov    $0x1e,%eax
 a07:	cd 40                	int    $0x40
 a09:	c3                   	ret    

00000a0a <pwrite>:
SYSCALL(pwrite)
 a0a:	b8 1f 00 00 00       	mov    $0x1f,%eax
 a0f:	cd 40                	int    $0x40
 a11:	c3                   	ret    

00000a12 <sync>:
SYSCALL(sync)
 a12:	b8 20 00 00 00       	mov    $0x20,%eax
 a17:	cd 40                	int    $0x40
 a19:	c3                   	ret    

00000a1a <get_log_num>:
SYSCALL(get_log_num)
 a1a:	b8 21 00 00 00       	mov    $0x21,%eax
 a1f:	cd 40                	int    $0x40
 a21:	c3                   	ret    
 a22:	66 90                	xchg   %ax,%ax
 a24:	66 90                	xchg   %ax,%ax
 a26:	66 90                	xchg   %ax,%ax
 a28:	66 90                	xchg   %ax,%ax
 a2a:	66 90                	xchg   %ax,%ax
 a2c:	66 90                	xchg   %ax,%ax
 a2e:	66 90                	xchg   %ax,%ax

00000a30 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 a30:	55                   	push   %ebp
 a31:	89 e5                	mov    %esp,%ebp
 a33:	57                   	push   %edi
 a34:	56                   	push   %esi
 a35:	53                   	push   %ebx
 a36:	83 ec 3c             	sub    $0x3c,%esp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 a39:	85 d2                	test   %edx,%edx
{
 a3b:	89 45 c0             	mov    %eax,-0x40(%ebp)
    neg = 1;
    x = -xx;
 a3e:	89 d0                	mov    %edx,%eax
  if(sgn && xx < 0){
 a40:	79 76                	jns    ab8 <printint+0x88>
 a42:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 a46:	74 70                	je     ab8 <printint+0x88>
    x = -xx;
 a48:	f7 d8                	neg    %eax
    neg = 1;
 a4a:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 a51:	31 f6                	xor    %esi,%esi
 a53:	8d 5d d7             	lea    -0x29(%ebp),%ebx
 a56:	eb 0a                	jmp    a62 <printint+0x32>
 a58:	90                   	nop
 a59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  do{
    buf[i++] = digits[x % base];
 a60:	89 fe                	mov    %edi,%esi
 a62:	31 d2                	xor    %edx,%edx
 a64:	8d 7e 01             	lea    0x1(%esi),%edi
 a67:	f7 f1                	div    %ecx
 a69:	0f b6 92 fc 0e 00 00 	movzbl 0xefc(%edx),%edx
  }while((x /= base) != 0);
 a70:	85 c0                	test   %eax,%eax
    buf[i++] = digits[x % base];
 a72:	88 14 3b             	mov    %dl,(%ebx,%edi,1)
  }while((x /= base) != 0);
 a75:	75 e9                	jne    a60 <printint+0x30>
  if(neg)
 a77:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 a7a:	85 c0                	test   %eax,%eax
 a7c:	74 08                	je     a86 <printint+0x56>
    buf[i++] = '-';
 a7e:	c6 44 3d d8 2d       	movb   $0x2d,-0x28(%ebp,%edi,1)
 a83:	8d 7e 02             	lea    0x2(%esi),%edi
 a86:	8d 74 3d d7          	lea    -0x29(%ebp,%edi,1),%esi
 a8a:	8b 7d c0             	mov    -0x40(%ebp),%edi
 a8d:	8d 76 00             	lea    0x0(%esi),%esi
 a90:	0f b6 06             	movzbl (%esi),%eax
  write(fd, &c, 1);
 a93:	83 ec 04             	sub    $0x4,%esp
 a96:	83 ee 01             	sub    $0x1,%esi
 a99:	6a 01                	push   $0x1
 a9b:	53                   	push   %ebx
 a9c:	57                   	push   %edi
 a9d:	88 45 d7             	mov    %al,-0x29(%ebp)
 aa0:	e8 9d fe ff ff       	call   942 <write>

  while(--i >= 0)
 aa5:	83 c4 10             	add    $0x10,%esp
 aa8:	39 de                	cmp    %ebx,%esi
 aaa:	75 e4                	jne    a90 <printint+0x60>
    putc(fd, buf[i]);
}
 aac:	8d 65 f4             	lea    -0xc(%ebp),%esp
 aaf:	5b                   	pop    %ebx
 ab0:	5e                   	pop    %esi
 ab1:	5f                   	pop    %edi
 ab2:	5d                   	pop    %ebp
 ab3:	c3                   	ret    
 ab4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 ab8:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
 abf:	eb 90                	jmp    a51 <printint+0x21>
 ac1:	eb 0d                	jmp    ad0 <printf>
 ac3:	90                   	nop
 ac4:	90                   	nop
 ac5:	90                   	nop
 ac6:	90                   	nop
 ac7:	90                   	nop
 ac8:	90                   	nop
 ac9:	90                   	nop
 aca:	90                   	nop
 acb:	90                   	nop
 acc:	90                   	nop
 acd:	90                   	nop
 ace:	90                   	nop
 acf:	90                   	nop

00000ad0 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 ad0:	55                   	push   %ebp
 ad1:	89 e5                	mov    %esp,%ebp
 ad3:	57                   	push   %edi
 ad4:	56                   	push   %esi
 ad5:	53                   	push   %ebx
 ad6:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 ad9:	8b 75 0c             	mov    0xc(%ebp),%esi
 adc:	0f b6 1e             	movzbl (%esi),%ebx
 adf:	84 db                	test   %bl,%bl
 ae1:	0f 84 b3 00 00 00    	je     b9a <printf+0xca>
  ap = (uint*)(void*)&fmt + 1;
 ae7:	8d 45 10             	lea    0x10(%ebp),%eax
 aea:	83 c6 01             	add    $0x1,%esi
  state = 0;
 aed:	31 ff                	xor    %edi,%edi
  ap = (uint*)(void*)&fmt + 1;
 aef:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 af2:	eb 2f                	jmp    b23 <printf+0x53>
 af4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 af8:	83 f8 25             	cmp    $0x25,%eax
 afb:	0f 84 a7 00 00 00    	je     ba8 <printf+0xd8>
  write(fd, &c, 1);
 b01:	8d 45 e2             	lea    -0x1e(%ebp),%eax
 b04:	83 ec 04             	sub    $0x4,%esp
 b07:	88 5d e2             	mov    %bl,-0x1e(%ebp)
 b0a:	6a 01                	push   $0x1
 b0c:	50                   	push   %eax
 b0d:	ff 75 08             	pushl  0x8(%ebp)
 b10:	e8 2d fe ff ff       	call   942 <write>
 b15:	83 c4 10             	add    $0x10,%esp
 b18:	83 c6 01             	add    $0x1,%esi
  for(i = 0; fmt[i]; i++){
 b1b:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
 b1f:	84 db                	test   %bl,%bl
 b21:	74 77                	je     b9a <printf+0xca>
    if(state == 0){
 b23:	85 ff                	test   %edi,%edi
    c = fmt[i] & 0xff;
 b25:	0f be cb             	movsbl %bl,%ecx
 b28:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 b2b:	74 cb                	je     af8 <printf+0x28>
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 b2d:	83 ff 25             	cmp    $0x25,%edi
 b30:	75 e6                	jne    b18 <printf+0x48>
      if(c == 'd'){
 b32:	83 f8 64             	cmp    $0x64,%eax
 b35:	0f 84 05 01 00 00    	je     c40 <printf+0x170>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 b3b:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
 b41:	83 f9 70             	cmp    $0x70,%ecx
 b44:	74 72                	je     bb8 <printf+0xe8>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 b46:	83 f8 73             	cmp    $0x73,%eax
 b49:	0f 84 99 00 00 00    	je     be8 <printf+0x118>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 b4f:	83 f8 63             	cmp    $0x63,%eax
 b52:	0f 84 08 01 00 00    	je     c60 <printf+0x190>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 b58:	83 f8 25             	cmp    $0x25,%eax
 b5b:	0f 84 ef 00 00 00    	je     c50 <printf+0x180>
  write(fd, &c, 1);
 b61:	8d 45 e7             	lea    -0x19(%ebp),%eax
 b64:	83 ec 04             	sub    $0x4,%esp
 b67:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 b6b:	6a 01                	push   $0x1
 b6d:	50                   	push   %eax
 b6e:	ff 75 08             	pushl  0x8(%ebp)
 b71:	e8 cc fd ff ff       	call   942 <write>
 b76:	83 c4 0c             	add    $0xc,%esp
 b79:	8d 45 e6             	lea    -0x1a(%ebp),%eax
 b7c:	88 5d e6             	mov    %bl,-0x1a(%ebp)
 b7f:	6a 01                	push   $0x1
 b81:	50                   	push   %eax
 b82:	ff 75 08             	pushl  0x8(%ebp)
 b85:	83 c6 01             	add    $0x1,%esi
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 b88:	31 ff                	xor    %edi,%edi
  write(fd, &c, 1);
 b8a:	e8 b3 fd ff ff       	call   942 <write>
  for(i = 0; fmt[i]; i++){
 b8f:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
  write(fd, &c, 1);
 b93:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
 b96:	84 db                	test   %bl,%bl
 b98:	75 89                	jne    b23 <printf+0x53>
    }
  }
}
 b9a:	8d 65 f4             	lea    -0xc(%ebp),%esp
 b9d:	5b                   	pop    %ebx
 b9e:	5e                   	pop    %esi
 b9f:	5f                   	pop    %edi
 ba0:	5d                   	pop    %ebp
 ba1:	c3                   	ret    
 ba2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        state = '%';
 ba8:	bf 25 00 00 00       	mov    $0x25,%edi
 bad:	e9 66 ff ff ff       	jmp    b18 <printf+0x48>
 bb2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        printint(fd, *ap, 16, 0);
 bb8:	83 ec 0c             	sub    $0xc,%esp
 bbb:	b9 10 00 00 00       	mov    $0x10,%ecx
 bc0:	6a 00                	push   $0x0
 bc2:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 bc5:	8b 45 08             	mov    0x8(%ebp),%eax
 bc8:	8b 17                	mov    (%edi),%edx
 bca:	e8 61 fe ff ff       	call   a30 <printint>
        ap++;
 bcf:	89 f8                	mov    %edi,%eax
 bd1:	83 c4 10             	add    $0x10,%esp
      state = 0;
 bd4:	31 ff                	xor    %edi,%edi
        ap++;
 bd6:	83 c0 04             	add    $0x4,%eax
 bd9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 bdc:	e9 37 ff ff ff       	jmp    b18 <printf+0x48>
 be1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        s = (char*)*ap;
 be8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 beb:	8b 08                	mov    (%eax),%ecx
        ap++;
 bed:	83 c0 04             	add    $0x4,%eax
 bf0:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        if(s == 0)
 bf3:	85 c9                	test   %ecx,%ecx
 bf5:	0f 84 8e 00 00 00    	je     c89 <printf+0x1b9>
        while(*s != 0){
 bfb:	0f b6 01             	movzbl (%ecx),%eax
      state = 0;
 bfe:	31 ff                	xor    %edi,%edi
        s = (char*)*ap;
 c00:	89 cb                	mov    %ecx,%ebx
        while(*s != 0){
 c02:	84 c0                	test   %al,%al
 c04:	0f 84 0e ff ff ff    	je     b18 <printf+0x48>
 c0a:	89 75 d0             	mov    %esi,-0x30(%ebp)
 c0d:	89 de                	mov    %ebx,%esi
 c0f:	8b 5d 08             	mov    0x8(%ebp),%ebx
 c12:	8d 7d e3             	lea    -0x1d(%ebp),%edi
 c15:	8d 76 00             	lea    0x0(%esi),%esi
  write(fd, &c, 1);
 c18:	83 ec 04             	sub    $0x4,%esp
          s++;
 c1b:	83 c6 01             	add    $0x1,%esi
 c1e:	88 45 e3             	mov    %al,-0x1d(%ebp)
  write(fd, &c, 1);
 c21:	6a 01                	push   $0x1
 c23:	57                   	push   %edi
 c24:	53                   	push   %ebx
 c25:	e8 18 fd ff ff       	call   942 <write>
        while(*s != 0){
 c2a:	0f b6 06             	movzbl (%esi),%eax
 c2d:	83 c4 10             	add    $0x10,%esp
 c30:	84 c0                	test   %al,%al
 c32:	75 e4                	jne    c18 <printf+0x148>
 c34:	8b 75 d0             	mov    -0x30(%ebp),%esi
      state = 0;
 c37:	31 ff                	xor    %edi,%edi
 c39:	e9 da fe ff ff       	jmp    b18 <printf+0x48>
 c3e:	66 90                	xchg   %ax,%ax
        printint(fd, *ap, 10, 1);
 c40:	83 ec 0c             	sub    $0xc,%esp
 c43:	b9 0a 00 00 00       	mov    $0xa,%ecx
 c48:	6a 01                	push   $0x1
 c4a:	e9 73 ff ff ff       	jmp    bc2 <printf+0xf2>
 c4f:	90                   	nop
  write(fd, &c, 1);
 c50:	83 ec 04             	sub    $0x4,%esp
 c53:	88 5d e5             	mov    %bl,-0x1b(%ebp)
 c56:	8d 45 e5             	lea    -0x1b(%ebp),%eax
 c59:	6a 01                	push   $0x1
 c5b:	e9 21 ff ff ff       	jmp    b81 <printf+0xb1>
        putc(fd, *ap);
 c60:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  write(fd, &c, 1);
 c63:	83 ec 04             	sub    $0x4,%esp
        putc(fd, *ap);
 c66:	8b 07                	mov    (%edi),%eax
  write(fd, &c, 1);
 c68:	6a 01                	push   $0x1
        ap++;
 c6a:	83 c7 04             	add    $0x4,%edi
        putc(fd, *ap);
 c6d:	88 45 e4             	mov    %al,-0x1c(%ebp)
  write(fd, &c, 1);
 c70:	8d 45 e4             	lea    -0x1c(%ebp),%eax
 c73:	50                   	push   %eax
 c74:	ff 75 08             	pushl  0x8(%ebp)
 c77:	e8 c6 fc ff ff       	call   942 <write>
        ap++;
 c7c:	89 7d d4             	mov    %edi,-0x2c(%ebp)
 c7f:	83 c4 10             	add    $0x10,%esp
      state = 0;
 c82:	31 ff                	xor    %edi,%edi
 c84:	e9 8f fe ff ff       	jmp    b18 <printf+0x48>
          s = "(null)";
 c89:	bb f4 0e 00 00       	mov    $0xef4,%ebx
        while(*s != 0){
 c8e:	b8 28 00 00 00       	mov    $0x28,%eax
 c93:	e9 72 ff ff ff       	jmp    c0a <printf+0x13a>
 c98:	66 90                	xchg   %ax,%ax
 c9a:	66 90                	xchg   %ax,%ax
 c9c:	66 90                	xchg   %ax,%ax
 c9e:	66 90                	xchg   %ax,%ax

00000ca0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 ca0:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 ca1:	a1 a8 13 00 00       	mov    0x13a8,%eax
{
 ca6:	89 e5                	mov    %esp,%ebp
 ca8:	57                   	push   %edi
 ca9:	56                   	push   %esi
 caa:	53                   	push   %ebx
 cab:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = (Header*)ap - 1;
 cae:	8d 4b f8             	lea    -0x8(%ebx),%ecx
 cb1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 cb8:	39 c8                	cmp    %ecx,%eax
 cba:	8b 10                	mov    (%eax),%edx
 cbc:	73 32                	jae    cf0 <free+0x50>
 cbe:	39 d1                	cmp    %edx,%ecx
 cc0:	72 04                	jb     cc6 <free+0x26>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 cc2:	39 d0                	cmp    %edx,%eax
 cc4:	72 32                	jb     cf8 <free+0x58>
      break;
  if(bp + bp->s.size == p->s.ptr){
 cc6:	8b 73 fc             	mov    -0x4(%ebx),%esi
 cc9:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 ccc:	39 fa                	cmp    %edi,%edx
 cce:	74 30                	je     d00 <free+0x60>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 cd0:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 cd3:	8b 50 04             	mov    0x4(%eax),%edx
 cd6:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 cd9:	39 f1                	cmp    %esi,%ecx
 cdb:	74 3a                	je     d17 <free+0x77>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 cdd:	89 08                	mov    %ecx,(%eax)
  freep = p;
 cdf:	a3 a8 13 00 00       	mov    %eax,0x13a8
}
 ce4:	5b                   	pop    %ebx
 ce5:	5e                   	pop    %esi
 ce6:	5f                   	pop    %edi
 ce7:	5d                   	pop    %ebp
 ce8:	c3                   	ret    
 ce9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 cf0:	39 d0                	cmp    %edx,%eax
 cf2:	72 04                	jb     cf8 <free+0x58>
 cf4:	39 d1                	cmp    %edx,%ecx
 cf6:	72 ce                	jb     cc6 <free+0x26>
{
 cf8:	89 d0                	mov    %edx,%eax
 cfa:	eb bc                	jmp    cb8 <free+0x18>
 cfc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp->s.size += p->s.ptr->s.size;
 d00:	03 72 04             	add    0x4(%edx),%esi
 d03:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 d06:	8b 10                	mov    (%eax),%edx
 d08:	8b 12                	mov    (%edx),%edx
 d0a:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 d0d:	8b 50 04             	mov    0x4(%eax),%edx
 d10:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 d13:	39 f1                	cmp    %esi,%ecx
 d15:	75 c6                	jne    cdd <free+0x3d>
    p->s.size += bp->s.size;
 d17:	03 53 fc             	add    -0x4(%ebx),%edx
  freep = p;
 d1a:	a3 a8 13 00 00       	mov    %eax,0x13a8
    p->s.size += bp->s.size;
 d1f:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 d22:	8b 53 f8             	mov    -0x8(%ebx),%edx
 d25:	89 10                	mov    %edx,(%eax)
}
 d27:	5b                   	pop    %ebx
 d28:	5e                   	pop    %esi
 d29:	5f                   	pop    %edi
 d2a:	5d                   	pop    %ebp
 d2b:	c3                   	ret    
 d2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000d30 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 d30:	55                   	push   %ebp
 d31:	89 e5                	mov    %esp,%ebp
 d33:	57                   	push   %edi
 d34:	56                   	push   %esi
 d35:	53                   	push   %ebx
 d36:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 d39:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 d3c:	8b 15 a8 13 00 00    	mov    0x13a8,%edx
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 d42:	8d 78 07             	lea    0x7(%eax),%edi
 d45:	c1 ef 03             	shr    $0x3,%edi
 d48:	83 c7 01             	add    $0x1,%edi
  if((prevp = freep) == 0){
 d4b:	85 d2                	test   %edx,%edx
 d4d:	0f 84 9d 00 00 00    	je     df0 <malloc+0xc0>
 d53:	8b 02                	mov    (%edx),%eax
 d55:	8b 48 04             	mov    0x4(%eax),%ecx
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 d58:	39 cf                	cmp    %ecx,%edi
 d5a:	76 6c                	jbe    dc8 <malloc+0x98>
 d5c:	81 ff 00 10 00 00    	cmp    $0x1000,%edi
 d62:	bb 00 10 00 00       	mov    $0x1000,%ebx
 d67:	0f 43 df             	cmovae %edi,%ebx
  p = sbrk(nu * sizeof(Header));
 d6a:	8d 34 dd 00 00 00 00 	lea    0x0(,%ebx,8),%esi
 d71:	eb 0e                	jmp    d81 <malloc+0x51>
 d73:	90                   	nop
 d74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 d78:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 d7a:	8b 48 04             	mov    0x4(%eax),%ecx
 d7d:	39 f9                	cmp    %edi,%ecx
 d7f:	73 47                	jae    dc8 <malloc+0x98>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 d81:	39 05 a8 13 00 00    	cmp    %eax,0x13a8
 d87:	89 c2                	mov    %eax,%edx
 d89:	75 ed                	jne    d78 <malloc+0x48>
  p = sbrk(nu * sizeof(Header));
 d8b:	83 ec 0c             	sub    $0xc,%esp
 d8e:	56                   	push   %esi
 d8f:	e8 16 fc ff ff       	call   9aa <sbrk>
  if(p == (char*)-1)
 d94:	83 c4 10             	add    $0x10,%esp
 d97:	83 f8 ff             	cmp    $0xffffffff,%eax
 d9a:	74 1c                	je     db8 <malloc+0x88>
  hp->s.size = nu;
 d9c:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 d9f:	83 ec 0c             	sub    $0xc,%esp
 da2:	83 c0 08             	add    $0x8,%eax
 da5:	50                   	push   %eax
 da6:	e8 f5 fe ff ff       	call   ca0 <free>
  return freep;
 dab:	8b 15 a8 13 00 00    	mov    0x13a8,%edx
      if((p = morecore(nunits)) == 0)
 db1:	83 c4 10             	add    $0x10,%esp
 db4:	85 d2                	test   %edx,%edx
 db6:	75 c0                	jne    d78 <malloc+0x48>
        return 0;
  }
}
 db8:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 dbb:	31 c0                	xor    %eax,%eax
}
 dbd:	5b                   	pop    %ebx
 dbe:	5e                   	pop    %esi
 dbf:	5f                   	pop    %edi
 dc0:	5d                   	pop    %ebp
 dc1:	c3                   	ret    
 dc2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
 dc8:	39 cf                	cmp    %ecx,%edi
 dca:	74 54                	je     e20 <malloc+0xf0>
        p->s.size -= nunits;
 dcc:	29 f9                	sub    %edi,%ecx
 dce:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 dd1:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 dd4:	89 78 04             	mov    %edi,0x4(%eax)
      freep = prevp;
 dd7:	89 15 a8 13 00 00    	mov    %edx,0x13a8
}
 ddd:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
 de0:	83 c0 08             	add    $0x8,%eax
}
 de3:	5b                   	pop    %ebx
 de4:	5e                   	pop    %esi
 de5:	5f                   	pop    %edi
 de6:	5d                   	pop    %ebp
 de7:	c3                   	ret    
 de8:	90                   	nop
 de9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    base.s.ptr = freep = prevp = &base;
 df0:	c7 05 a8 13 00 00 ac 	movl   $0x13ac,0x13a8
 df7:	13 00 00 
 dfa:	c7 05 ac 13 00 00 ac 	movl   $0x13ac,0x13ac
 e01:	13 00 00 
    base.s.size = 0;
 e04:	b8 ac 13 00 00       	mov    $0x13ac,%eax
 e09:	c7 05 b0 13 00 00 00 	movl   $0x0,0x13b0
 e10:	00 00 00 
 e13:	e9 44 ff ff ff       	jmp    d5c <malloc+0x2c>
 e18:	90                   	nop
 e19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        prevp->s.ptr = p->s.ptr;
 e20:	8b 08                	mov    (%eax),%ecx
 e22:	89 0a                	mov    %ecx,(%edx)
 e24:	eb b1                	jmp    dd7 <malloc+0xa7>
