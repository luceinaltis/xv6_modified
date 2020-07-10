
_test_thread2:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
  "stridetest",
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
      22:	be 0d 00 00 00       	mov    $0xd,%esi
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
      3f:	e8 26 13 00 00       	call   136a <fork>
      44:	85 c0                	test   %eax,%eax
      46:	0f 88 10 01 00 00    	js     15c <main+0x15c>
    if (pid == 0){
      4c:	0f 84 1d 01 00 00    	je     16f <main+0x16f>
      close(gpipe[1]);
      52:	83 ec 0c             	sub    $0xc,%esp
      55:	ff 35 6c 23 00 00    	pushl  0x236c
      5b:	e8 3a 13 00 00       	call   139a <close>
      if (wait() == -1 || read(gpipe[0], (char*)&ret, sizeof(ret)) == -1 || ret != 0){
      60:	e8 15 13 00 00       	call   137a <wait>
      65:	83 c4 10             	add    $0x10,%esp
      68:	83 f8 ff             	cmp    $0xffffffff,%eax
      6b:	0f 84 d2 00 00 00    	je     143 <main+0x143>
      71:	83 ec 04             	sub    $0x4,%esp
      74:	6a 04                	push   $0x4
      76:	57                   	push   %edi
      77:	ff 35 68 23 00 00    	pushl  0x2368
      7d:	e8 08 13 00 00       	call   138a <read>
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
      9c:	ff 35 68 23 00 00    	pushl  0x2368
      a2:	e8 f3 12 00 00       	call   139a <close>
    }
    printf(1,"%d. %s finish\n", i, testname[i]);
      a7:	ff 34 9d e0 22 00 00 	pushl  0x22e0(,%ebx,4)
      ae:	53                   	push   %ebx
  for (i = start; i <= end; i++){
      af:	83 c3 01             	add    $0x1,%ebx
    printf(1,"%d. %s finish\n", i, testname[i]);
      b2:	68 4e 1a 00 00       	push   $0x1a4e
      b7:	6a 01                	push   $0x1
      b9:	e8 62 14 00 00       	call   1520 <printf>
    sleep(100);
      be:	83 c4 14             	add    $0x14,%esp
      c1:	6a 64                	push   $0x64
      c3:	e8 3a 13 00 00       	call   1402 <sleep>
  for (i = start; i <= end; i++){
      c8:	83 c4 10             	add    $0x10,%esp
      cb:	39 f3                	cmp    %esi,%ebx
      cd:	7f 6f                	jg     13e <main+0x13e>
    printf(1,"%d. %s start\n", i, testname[i]);
      cf:	ff 34 9d e0 22 00 00 	pushl  0x22e0(,%ebx,4)
      d6:	53                   	push   %ebx
      d7:	68 1a 1a 00 00       	push   $0x1a1a
      dc:	6a 01                	push   $0x1
      de:	e8 3d 14 00 00       	call   1520 <printf>
    if (pipe(gpipe) < 0){
      e3:	c7 04 24 68 23 00 00 	movl   $0x2368,(%esp)
      ea:	e8 93 12 00 00       	call   1382 <pipe>
      ef:	83 c4 10             	add    $0x10,%esp
      f2:	85 c0                	test   %eax,%eax
      f4:	0f 89 3e ff ff ff    	jns    38 <main+0x38>
      printf(1,"pipe panic\n");
      fa:	53                   	push   %ebx
      fb:	53                   	push   %ebx
      fc:	68 28 1a 00 00       	push   $0x1a28
     101:	6a 01                	push   $0x1
     103:	e8 18 14 00 00       	call   1520 <printf>
      exit();
     108:	e8 65 12 00 00       	call   1372 <exit>
    start = atoi(argv[1]);
     10d:	83 ec 0c             	sub    $0xc,%esp
     110:	ff 77 04             	pushl  0x4(%edi)
     113:	e8 e8 11 00 00       	call   1300 <atoi>
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
     12c:	e8 cf 11 00 00       	call   1300 <atoi>
     131:	83 c4 10             	add    $0x10,%esp
     134:	89 c6                	mov    %eax,%esi
  for (i = start; i <= end; i++){
     136:	39 de                	cmp    %ebx,%esi
     138:	0f 8d eb fe ff ff    	jge    29 <main+0x29>
  }
  exit();
     13e:	e8 2f 12 00 00       	call   1372 <exit>
        printf(1,"%d. %s panic\n", i, testname[i]);
     143:	ff 34 9d e0 22 00 00 	pushl  0x22e0(,%ebx,4)
     14a:	53                   	push   %ebx
     14b:	68 40 1a 00 00       	push   $0x1a40
     150:	6a 01                	push   $0x1
     152:	e8 c9 13 00 00       	call   1520 <printf>
        exit();
     157:	e8 16 12 00 00       	call   1372 <exit>
      printf(1,"fork panic\n");
     15c:	51                   	push   %ecx
     15d:	51                   	push   %ecx
     15e:	68 34 1a 00 00       	push   $0x1a34
     163:	6a 01                	push   $0x1
     165:	e8 b6 13 00 00       	call   1520 <printf>
      exit();
     16a:	e8 03 12 00 00       	call   1372 <exit>
      close(gpipe[0]);
     16f:	83 ec 0c             	sub    $0xc,%esp
     172:	ff 35 68 23 00 00    	pushl  0x2368
     178:	e8 1d 12 00 00       	call   139a <close>
      ret = testfunc[i]();
     17d:	ff 14 9d 20 23 00 00 	call   *0x2320(,%ebx,4)
     184:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      write(gpipe[1], (char*)&ret, sizeof(ret));
     187:	8d 45 e4             	lea    -0x1c(%ebp),%eax
     18a:	83 c4 0c             	add    $0xc,%esp
     18d:	6a 04                	push   $0x4
     18f:	50                   	push   %eax
     190:	ff 35 6c 23 00 00    	pushl  0x236c
     196:	e8 f7 11 00 00       	call   1392 <write>
      close(gpipe[1]);
     19b:	5a                   	pop    %edx
     19c:	ff 35 6c 23 00 00    	pushl  0x236c
     1a2:	e8 f3 11 00 00       	call   139a <close>
      exit();
     1a7:	e8 c6 11 00 00       	call   1372 <exit>
  int end = NTEST-1;
     1ac:	be 0d 00 00 00       	mov    $0xd,%esi
     1b1:	eb 83                	jmp    136 <main+0x136>
     1b3:	66 90                	xchg   %ax,%ax
     1b5:	66 90                	xchg   %ax,%ax
     1b7:	66 90                	xchg   %ax,%ax
     1b9:	66 90                	xchg   %ax,%ax
     1bb:	66 90                	xchg   %ax,%ax
     1bd:	66 90                	xchg   %ax,%ax
     1bf:	90                   	nop

000001c0 <nop>:
}

// ============================================================================
void nop(){ }
     1c0:	55                   	push   %ebp
     1c1:	89 e5                	mov    %esp,%ebp
     1c3:	5d                   	pop    %ebp
     1c4:	c3                   	ret    
     1c5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
     1c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000001d0 <racingthreadmain>:

void*
racingthreadmain(void *arg)
{
     1d0:	55                   	push   %ebp
  int tid = (int) arg;
     1d1:	ba 80 96 98 00       	mov    $0x989680,%edx
{
     1d6:	89 e5                	mov    %esp,%ebp
     1d8:	83 ec 08             	sub    $0x8,%esp
     1db:	90                   	nop
     1dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  int i;
  int tmp;
  for (i = 0; i < 10000000; i++){
    tmp = gcnt;
     1e0:	a1 64 23 00 00       	mov    0x2364,%eax
    tmp++;
     1e5:	83 c0 01             	add    $0x1,%eax
	asm volatile("call %P0"::"i"(nop));
     1e8:	e8 d3 ff ff ff       	call   1c0 <nop>
  for (i = 0; i < 10000000; i++){
     1ed:	83 ea 01             	sub    $0x1,%edx
    gcnt = tmp;
     1f0:	a3 64 23 00 00       	mov    %eax,0x2364
  for (i = 0; i < 10000000; i++){
     1f5:	75 e9                	jne    1e0 <racingthreadmain+0x10>
  }
  thread_exit((void *)(tid+1));
     1f7:	8b 45 08             	mov    0x8(%ebp),%eax
     1fa:	83 ec 0c             	sub    $0xc,%esp
     1fd:	83 c0 01             	add    $0x1,%eax
     200:	50                   	push   %eax
     201:	e8 34 12 00 00       	call   143a <thread_exit>
     206:	8d 76 00             	lea    0x0(%esi),%esi
     209:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000210 <basicthreadmain>:
}

// ============================================================================
void*
basicthreadmain(void *arg)
{
     210:	55                   	push   %ebp
     211:	89 e5                	mov    %esp,%ebp
     213:	57                   	push   %edi
     214:	56                   	push   %esi
     215:	53                   	push   %ebx
  int tid = (int) arg;
  int i;
  for (i = 0; i < 100000000; i++){
    if (i % 20000000 == 0){
     216:	bf 6b ca 5f 6b       	mov    $0x6b5fca6b,%edi
  for (i = 0; i < 100000000; i++){
     21b:	31 db                	xor    %ebx,%ebx
{
     21d:	83 ec 0c             	sub    $0xc,%esp
     220:	8b 75 08             	mov    0x8(%ebp),%esi
     223:	eb 0e                	jmp    233 <basicthreadmain+0x23>
     225:	8d 76 00             	lea    0x0(%esi),%esi
  for (i = 0; i < 100000000; i++){
     228:	83 c3 01             	add    $0x1,%ebx
     22b:	81 fb 00 e1 f5 05    	cmp    $0x5f5e100,%ebx
     231:	74 2f                	je     262 <basicthreadmain+0x52>
    if (i % 20000000 == 0){
     233:	89 d8                	mov    %ebx,%eax
     235:	f7 e7                	mul    %edi
     237:	c1 ea 17             	shr    $0x17,%edx
     23a:	69 d2 00 2d 31 01    	imul   $0x1312d00,%edx,%edx
     240:	39 d3                	cmp    %edx,%ebx
     242:	75 e4                	jne    228 <basicthreadmain+0x18>
      printf(1, "%d", tid);
     244:	83 ec 04             	sub    $0x4,%esp
  for (i = 0; i < 100000000; i++){
     247:	83 c3 01             	add    $0x1,%ebx
      printf(1, "%d", tid);
     24a:	56                   	push   %esi
     24b:	68 78 18 00 00       	push   $0x1878
     250:	6a 01                	push   $0x1
     252:	e8 c9 12 00 00       	call   1520 <printf>
     257:	83 c4 10             	add    $0x10,%esp
  for (i = 0; i < 100000000; i++){
     25a:	81 fb 00 e1 f5 05    	cmp    $0x5f5e100,%ebx
     260:	75 d1                	jne    233 <basicthreadmain+0x23>
    }
  }
  thread_exit((void *)(tid+1));
     262:	83 ec 0c             	sub    $0xc,%esp
     265:	83 c6 01             	add    $0x1,%esi
     268:	56                   	push   %esi
     269:	e8 cc 11 00 00       	call   143a <thread_exit>
     26e:	66 90                	xchg   %ax,%ax

00000270 <jointhreadmain>:

// ============================================================================

void*
jointhreadmain(void *arg)
{
     270:	55                   	push   %ebp
     271:	89 e5                	mov    %esp,%ebp
     273:	83 ec 14             	sub    $0x14,%esp
  int val = (int)arg;
  sleep(200);
     276:	68 c8 00 00 00       	push   $0xc8
     27b:	e8 82 11 00 00       	call   1402 <sleep>
  printf(1, "thread_exit...\n");
     280:	58                   	pop    %eax
     281:	5a                   	pop    %edx
     282:	68 7b 18 00 00       	push   $0x187b
     287:	6a 01                	push   $0x1
     289:	e8 92 12 00 00       	call   1520 <printf>
  thread_exit((void *)(val*2));
     28e:	8b 45 08             	mov    0x8(%ebp),%eax
     291:	01 c0                	add    %eax,%eax
     293:	89 04 24             	mov    %eax,(%esp)
     296:	e8 9f 11 00 00       	call   143a <thread_exit>
     29b:	90                   	nop
     29c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000002a0 <stressthreadmain>:

// ============================================================================

void*
stressthreadmain(void *arg)
{
     2a0:	55                   	push   %ebp
     2a1:	89 e5                	mov    %esp,%ebp
     2a3:	83 ec 14             	sub    $0x14,%esp
  thread_exit(0);
     2a6:	6a 00                	push   $0x0
     2a8:	e8 8d 11 00 00       	call   143a <thread_exit>
     2ad:	8d 76 00             	lea    0x0(%esi),%esi

000002b0 <exitthreadmain>:

// ============================================================================

void*
exitthreadmain(void *arg)
{
     2b0:	55                   	push   %ebp
     2b1:	89 e5                	mov    %esp,%ebp
     2b3:	83 ec 08             	sub    $0x8,%esp
     2b6:	8b 45 08             	mov    0x8(%ebp),%eax
  int i;
  if ((int)arg == 1){
     2b9:	83 f8 01             	cmp    $0x1,%eax
     2bc:	74 12                	je     2d0 <exitthreadmain+0x20>
    while(1){
      printf(1, "thread_exit ...\n");
      for (i = 0; i < 5000000; i++);
    }
  } else if ((int)arg == 2){
     2be:	83 f8 02             	cmp    $0x2,%eax
     2c1:	74 21                	je     2e4 <exitthreadmain+0x34>
    exit();
  }

  thread_exit(0);
     2c3:	83 ec 0c             	sub    $0xc,%esp
     2c6:	6a 00                	push   $0x0
     2c8:	e8 6d 11 00 00       	call   143a <thread_exit>
     2cd:	8d 76 00             	lea    0x0(%esi),%esi
      printf(1, "thread_exit ...\n");
     2d0:	83 ec 08             	sub    $0x8,%esp
     2d3:	68 8b 18 00 00       	push   $0x188b
     2d8:	6a 01                	push   $0x1
     2da:	e8 41 12 00 00       	call   1520 <printf>
     2df:	83 c4 10             	add    $0x10,%esp
     2e2:	eb ec                	jmp    2d0 <exitthreadmain+0x20>
    exit();
     2e4:	e8 89 10 00 00       	call   1372 <exit>
     2e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

000002f0 <forkthreadmain>:

// ============================================================================

void*
forkthreadmain(void *arg)
{
     2f0:	55                   	push   %ebp
     2f1:	89 e5                	mov    %esp,%ebp
     2f3:	83 ec 08             	sub    $0x8,%esp
  int pid;
  if ((pid = fork()) == -1){
     2f6:	e8 6f 10 00 00       	call   136a <fork>
     2fb:	83 f8 ff             	cmp    $0xffffffff,%eax
     2fe:	74 3c                	je     33c <forkthreadmain+0x4c>
    printf(1, "panic at fork in forktest\n");
    exit();
  } else if (pid == 0){
     300:	85 c0                	test   %eax,%eax
     302:	74 25                	je     329 <forkthreadmain+0x39>
    printf(1, "child\n");
    exit();
  } else{
    printf(1, "parent\n");
     304:	52                   	push   %edx
     305:	52                   	push   %edx
     306:	68 be 18 00 00       	push   $0x18be
     30b:	6a 01                	push   $0x1
     30d:	e8 0e 12 00 00       	call   1520 <printf>
    if (wait() == -1){
     312:	e8 63 10 00 00       	call   137a <wait>
     317:	83 c4 10             	add    $0x10,%esp
     31a:	83 c0 01             	add    $0x1,%eax
     31d:	74 30                	je     34f <forkthreadmain+0x5f>
      printf(1, "panic at wait in forktest\n");
      exit();
    }
  }
  thread_exit(0);
     31f:	83 ec 0c             	sub    $0xc,%esp
     322:	6a 00                	push   $0x0
     324:	e8 11 11 00 00       	call   143a <thread_exit>
    printf(1, "child\n");
     329:	51                   	push   %ecx
     32a:	51                   	push   %ecx
     32b:	68 b7 18 00 00       	push   $0x18b7
     330:	6a 01                	push   $0x1
     332:	e8 e9 11 00 00       	call   1520 <printf>
    exit();
     337:	e8 36 10 00 00       	call   1372 <exit>
    printf(1, "panic at fork in forktest\n");
     33c:	50                   	push   %eax
     33d:	50                   	push   %eax
     33e:	68 9c 18 00 00       	push   $0x189c
     343:	6a 01                	push   $0x1
     345:	e8 d6 11 00 00       	call   1520 <printf>
    exit();
     34a:	e8 23 10 00 00       	call   1372 <exit>
      printf(1, "panic at wait in forktest\n");
     34f:	50                   	push   %eax
     350:	50                   	push   %eax
     351:	68 c6 18 00 00       	push   $0x18c6
     356:	6a 01                	push   $0x1
     358:	e8 c3 11 00 00       	call   1520 <printf>
      exit();
     35d:	e8 10 10 00 00       	call   1372 <exit>
     362:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     369:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000370 <sleepthreadmain>:

// ============================================================================

void*
sleepthreadmain(void *arg)
{
     370:	55                   	push   %ebp
     371:	89 e5                	mov    %esp,%ebp
     373:	83 ec 14             	sub    $0x14,%esp
  sleep(1000000);
     376:	68 40 42 0f 00       	push   $0xf4240
     37b:	e8 82 10 00 00       	call   1402 <sleep>
  thread_exit(0);
     380:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     387:	e8 ae 10 00 00       	call   143a <thread_exit>
     38c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000390 <exittest2>:
{
     390:	55                   	push   %ebp
     391:	89 e5                	mov    %esp,%ebp
     393:	56                   	push   %esi
     394:	53                   	push   %ebx
     395:	8d 75 f8             	lea    -0x8(%ebp),%esi
     398:	8d 5d d0             	lea    -0x30(%ebp),%ebx
     39b:	83 ec 30             	sub    $0x30,%esp
    if (thread_create(&threads[i], exitthreadmain, (void*)2) != 0){
     39e:	83 ec 04             	sub    $0x4,%esp
     3a1:	6a 02                	push   $0x2
     3a3:	68 b0 02 00 00       	push   $0x2b0
     3a8:	53                   	push   %ebx
     3a9:	e8 94 10 00 00       	call   1442 <thread_create>
     3ae:	83 c4 10             	add    $0x10,%esp
     3b1:	85 c0                	test   %eax,%eax
     3b3:	75 0b                	jne    3c0 <exittest2+0x30>
     3b5:	83 c3 04             	add    $0x4,%ebx
  for (i = 0; i < NUM_THREAD; i++){
     3b8:	39 f3                	cmp    %esi,%ebx
     3ba:	75 e2                	jne    39e <exittest2+0xe>
     3bc:	eb fe                	jmp    3bc <exittest2+0x2c>
     3be:	66 90                	xchg   %ax,%ax
      printf(1, "panic at thread_create\n");
     3c0:	83 ec 08             	sub    $0x8,%esp
     3c3:	68 e1 18 00 00       	push   $0x18e1
     3c8:	6a 01                	push   $0x1
     3ca:	e8 51 11 00 00       	call   1520 <printf>
}
     3cf:	8d 65 f8             	lea    -0x8(%ebp),%esp
     3d2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     3d7:	5b                   	pop    %ebx
     3d8:	5e                   	pop    %esi
     3d9:	5d                   	pop    %ebp
     3da:	c3                   	ret    
     3db:	90                   	nop
     3dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000003e0 <jointest2>:
{
     3e0:	55                   	push   %ebp
     3e1:	89 e5                	mov    %esp,%ebp
     3e3:	56                   	push   %esi
     3e4:	53                   	push   %ebx
     3e5:	8d 75 cc             	lea    -0x34(%ebp),%esi
  for (i = 1; i <= NUM_THREAD; i++){
     3e8:	bb 01 00 00 00       	mov    $0x1,%ebx
{
     3ed:	83 ec 40             	sub    $0x40,%esp
    if (thread_create(&threads[i-1], jointhreadmain, (void*)(i)) != 0){
     3f0:	8d 04 9e             	lea    (%esi,%ebx,4),%eax
     3f3:	83 ec 04             	sub    $0x4,%esp
     3f6:	53                   	push   %ebx
     3f7:	68 70 02 00 00       	push   $0x270
     3fc:	50                   	push   %eax
     3fd:	e8 40 10 00 00       	call   1442 <thread_create>
     402:	83 c4 10             	add    $0x10,%esp
     405:	85 c0                	test   %eax,%eax
     407:	75 77                	jne    480 <jointest2+0xa0>
  for (i = 1; i <= NUM_THREAD; i++){
     409:	83 c3 01             	add    $0x1,%ebx
     40c:	83 fb 0b             	cmp    $0xb,%ebx
     40f:	75 df                	jne    3f0 <jointest2+0x10>
  sleep(500);
     411:	83 ec 0c             	sub    $0xc,%esp
  printf(1, "thread_join!!!\n");
     414:	bb 02 00 00 00       	mov    $0x2,%ebx
  sleep(500);
     419:	68 f4 01 00 00       	push   $0x1f4
     41e:	e8 df 0f 00 00       	call   1402 <sleep>
  printf(1, "thread_join!!!\n");
     423:	58                   	pop    %eax
     424:	5a                   	pop    %edx
     425:	68 f9 18 00 00       	push   $0x18f9
     42a:	6a 01                	push   $0x1
     42c:	e8 ef 10 00 00       	call   1520 <printf>
     431:	83 c4 10             	add    $0x10,%esp
     434:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if (thread_join(threads[i-1], &retval) != 0 || (int)retval != i * 2 ){
     438:	83 ec 08             	sub    $0x8,%esp
     43b:	56                   	push   %esi
     43c:	ff 74 5d cc          	pushl  -0x34(%ebp,%ebx,2)
     440:	e8 05 10 00 00       	call   144a <thread_join>
     445:	83 c4 10             	add    $0x10,%esp
     448:	85 c0                	test   %eax,%eax
     44a:	75 54                	jne    4a0 <jointest2+0xc0>
     44c:	39 5d cc             	cmp    %ebx,-0x34(%ebp)
     44f:	75 4f                	jne    4a0 <jointest2+0xc0>
     451:	83 c3 02             	add    $0x2,%ebx
  for (i = 1; i <= NUM_THREAD; i++){
     454:	83 fb 16             	cmp    $0x16,%ebx
     457:	75 df                	jne    438 <jointest2+0x58>
  printf(1,"\n");
     459:	83 ec 08             	sub    $0x8,%esp
     45c:	89 45 c4             	mov    %eax,-0x3c(%ebp)
     45f:	68 07 19 00 00       	push   $0x1907
     464:	6a 01                	push   $0x1
     466:	e8 b5 10 00 00       	call   1520 <printf>
  return 0;
     46b:	8b 45 c4             	mov    -0x3c(%ebp),%eax
     46e:	83 c4 10             	add    $0x10,%esp
}
     471:	8d 65 f8             	lea    -0x8(%ebp),%esp
     474:	5b                   	pop    %ebx
     475:	5e                   	pop    %esi
     476:	5d                   	pop    %ebp
     477:	c3                   	ret    
     478:	90                   	nop
     479:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      printf(1, "panic at thread_create\n");
     480:	83 ec 08             	sub    $0x8,%esp
     483:	68 e1 18 00 00       	push   $0x18e1
     488:	6a 01                	push   $0x1
     48a:	e8 91 10 00 00       	call   1520 <printf>
      return -1;
     48f:	83 c4 10             	add    $0x10,%esp
}
     492:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return -1;
     495:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
     49a:	5b                   	pop    %ebx
     49b:	5e                   	pop    %esi
     49c:	5d                   	pop    %ebp
     49d:	c3                   	ret    
     49e:	66 90                	xchg   %ax,%ax
      printf(1, "panic at thread_join\n");
     4a0:	83 ec 08             	sub    $0x8,%esp
     4a3:	68 09 19 00 00       	push   $0x1909
     4a8:	6a 01                	push   $0x1
     4aa:	e8 71 10 00 00       	call   1520 <printf>
      return -1;
     4af:	83 c4 10             	add    $0x10,%esp
}
     4b2:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return -1;
     4b5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
     4ba:	5b                   	pop    %ebx
     4bb:	5e                   	pop    %esi
     4bc:	5d                   	pop    %ebp
     4bd:	c3                   	ret    
     4be:	66 90                	xchg   %ax,%ax

000004c0 <pipetest>:
{
     4c0:	55                   	push   %ebp
     4c1:	89 e5                	mov    %esp,%ebp
     4c3:	57                   	push   %edi
     4c4:	56                   	push   %esi
     4c5:	53                   	push   %ebx
  if (pipe(fd) < 0){
     4c6:	8d 45 ac             	lea    -0x54(%ebp),%eax
{
     4c9:	83 ec 68             	sub    $0x68,%esp
  if (pipe(fd) < 0){
     4cc:	50                   	push   %eax
     4cd:	e8 b0 0e 00 00       	call   1382 <pipe>
     4d2:	83 c4 10             	add    $0x10,%esp
     4d5:	85 c0                	test   %eax,%eax
     4d7:	0f 88 94 01 00 00    	js     671 <pipetest+0x1b1>
  arg[1] = fd[0];
     4dd:	8b 45 ac             	mov    -0x54(%ebp),%eax
     4e0:	89 45 b8             	mov    %eax,-0x48(%ebp)
  arg[2] = fd[1];
     4e3:	8b 45 b0             	mov    -0x50(%ebp),%eax
     4e6:	89 45 bc             	mov    %eax,-0x44(%ebp)
  if ((pid = fork()) < 0){
     4e9:	e8 7c 0e 00 00       	call   136a <fork>
     4ee:	85 c0                	test   %eax,%eax
     4f0:	0f 88 94 01 00 00    	js     68a <pipetest+0x1ca>
  } else if (pid == 0){
     4f6:	75 78                	jne    570 <pipetest+0xb0>
    close(fd[0]);
     4f8:	83 ec 0c             	sub    $0xc,%esp
     4fb:	8d 5d c0             	lea    -0x40(%ebp),%ebx
     4fe:	ff 75 ac             	pushl  -0x54(%ebp)
     501:	8d 75 b4             	lea    -0x4c(%ebp),%esi
     504:	e8 91 0e 00 00       	call   139a <close>
    arg[0] = 0;
     509:	89 df                	mov    %ebx,%edi
     50b:	c7 45 b4 00 00 00 00 	movl   $0x0,-0x4c(%ebp)
     512:	83 c4 10             	add    $0x10,%esp
     515:	8d 76 00             	lea    0x0(%esi),%esi
      if (thread_create(&threads[i], pipethreadmain, (void*)arg) != 0){
     518:	83 ec 04             	sub    $0x4,%esp
     51b:	56                   	push   %esi
     51c:	68 b0 07 00 00       	push   $0x7b0
     521:	57                   	push   %edi
     522:	e8 1b 0f 00 00       	call   1442 <thread_create>
     527:	83 c4 10             	add    $0x10,%esp
     52a:	85 c0                	test   %eax,%eax
     52c:	0f 85 f6 00 00 00    	jne    628 <pipetest+0x168>
    for (i = 0; i < NUM_THREAD; i++){
     532:	8d 45 e8             	lea    -0x18(%ebp),%eax
     535:	83 c7 04             	add    $0x4,%edi
     538:	39 c7                	cmp    %eax,%edi
     53a:	75 dc                	jne    518 <pipetest+0x58>
     53c:	8d 75 a8             	lea    -0x58(%ebp),%esi
     53f:	90                   	nop
      if (thread_join(threads[i], &retval) != 0){
     540:	83 ec 08             	sub    $0x8,%esp
     543:	56                   	push   %esi
     544:	ff 33                	pushl  (%ebx)
     546:	e8 ff 0e 00 00       	call   144a <thread_join>
     54b:	83 c4 10             	add    $0x10,%esp
     54e:	85 c0                	test   %eax,%eax
     550:	0f 85 fa 00 00 00    	jne    650 <pipetest+0x190>
     556:	83 c3 04             	add    $0x4,%ebx
    for (i = 0; i < NUM_THREAD; i++){
     559:	39 df                	cmp    %ebx,%edi
     55b:	75 e3                	jne    540 <pipetest+0x80>
    close(fd[1]);
     55d:	83 ec 0c             	sub    $0xc,%esp
     560:	ff 75 b0             	pushl  -0x50(%ebp)
     563:	e8 32 0e 00 00       	call   139a <close>
    exit();
     568:	e8 05 0e 00 00       	call   1372 <exit>
     56d:	8d 76 00             	lea    0x0(%esi),%esi
    close(fd[1]);
     570:	83 ec 0c             	sub    $0xc,%esp
     573:	ff 75 b0             	pushl  -0x50(%ebp)
     576:	8d 7d e8             	lea    -0x18(%ebp),%edi
     579:	8d 75 b4             	lea    -0x4c(%ebp),%esi
     57c:	e8 19 0e 00 00       	call   139a <close>
     581:	8d 45 c0             	lea    -0x40(%ebp),%eax
    arg[0] = 1;
     584:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
    gcnt = 0;
     58b:	c7 05 64 23 00 00 00 	movl   $0x0,0x2364
     592:	00 00 00 
     595:	83 c4 10             	add    $0x10,%esp
     598:	89 45 a4             	mov    %eax,-0x5c(%ebp)
     59b:	89 c3                	mov    %eax,%ebx
     59d:	8d 76 00             	lea    0x0(%esi),%esi
      if (thread_create(&threads[i], pipethreadmain, (void*)arg) != 0){
     5a0:	83 ec 04             	sub    $0x4,%esp
     5a3:	56                   	push   %esi
     5a4:	68 b0 07 00 00       	push   $0x7b0
     5a9:	53                   	push   %ebx
     5aa:	e8 93 0e 00 00       	call   1442 <thread_create>
     5af:	83 c4 10             	add    $0x10,%esp
     5b2:	85 c0                	test   %eax,%eax
     5b4:	75 72                	jne    628 <pipetest+0x168>
     5b6:	83 c3 04             	add    $0x4,%ebx
    for (i = 0; i < NUM_THREAD; i++){
     5b9:	39 fb                	cmp    %edi,%ebx
     5bb:	75 e3                	jne    5a0 <pipetest+0xe0>
     5bd:	8d 75 a8             	lea    -0x58(%ebp),%esi
      if (thread_join(threads[i], &retval) != 0){
     5c0:	8b 45 a4             	mov    -0x5c(%ebp),%eax
     5c3:	83 ec 08             	sub    $0x8,%esp
     5c6:	56                   	push   %esi
     5c7:	ff 30                	pushl  (%eax)
     5c9:	e8 7c 0e 00 00       	call   144a <thread_join>
     5ce:	83 c4 10             	add    $0x10,%esp
     5d1:	85 c0                	test   %eax,%eax
     5d3:	89 c7                	mov    %eax,%edi
     5d5:	75 79                	jne    650 <pipetest+0x190>
     5d7:	83 45 a4 04          	addl   $0x4,-0x5c(%ebp)
     5db:	8b 45 a4             	mov    -0x5c(%ebp),%eax
    for (i = 0; i < NUM_THREAD; i++){
     5de:	39 d8                	cmp    %ebx,%eax
     5e0:	75 de                	jne    5c0 <pipetest+0x100>
    close(fd[0]);
     5e2:	83 ec 0c             	sub    $0xc,%esp
     5e5:	ff 75 ac             	pushl  -0x54(%ebp)
     5e8:	e8 ad 0d 00 00       	call   139a <close>
  if (wait() == -1){
     5ed:	e8 88 0d 00 00       	call   137a <wait>
     5f2:	83 c4 10             	add    $0x10,%esp
     5f5:	83 f8 ff             	cmp    $0xffffffff,%eax
     5f8:	0f 84 a5 00 00 00    	je     6a3 <pipetest+0x1e3>
  if (gcnt != 0)
     5fe:	a1 64 23 00 00       	mov    0x2364,%eax
     603:	85 c0                	test   %eax,%eax
     605:	74 38                	je     63f <pipetest+0x17f>
    printf(1,"panic at validation in pipetest : %d\n", gcnt);
     607:	a1 64 23 00 00       	mov    0x2364,%eax
     60c:	83 ec 04             	sub    $0x4,%esp
     60f:	50                   	push   %eax
     610:	68 e8 1a 00 00       	push   $0x1ae8
     615:	6a 01                	push   $0x1
     617:	e8 04 0f 00 00       	call   1520 <printf>
     61c:	83 c4 10             	add    $0x10,%esp
     61f:	eb 1e                	jmp    63f <pipetest+0x17f>
     621:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        printf(1, "panic at thread_create\n");
     628:	83 ec 08             	sub    $0x8,%esp
        return -1;
     62b:	bf ff ff ff ff       	mov    $0xffffffff,%edi
        printf(1, "panic at thread_create\n");
     630:	68 e1 18 00 00       	push   $0x18e1
     635:	6a 01                	push   $0x1
     637:	e8 e4 0e 00 00       	call   1520 <printf>
        return -1;
     63c:	83 c4 10             	add    $0x10,%esp
}
     63f:	8d 65 f4             	lea    -0xc(%ebp),%esp
     642:	89 f8                	mov    %edi,%eax
     644:	5b                   	pop    %ebx
     645:	5e                   	pop    %esi
     646:	5f                   	pop    %edi
     647:	5d                   	pop    %ebp
     648:	c3                   	ret    
     649:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        printf(1, "panic at thread_join\n");
     650:	83 ec 08             	sub    $0x8,%esp
        return -1;
     653:	bf ff ff ff ff       	mov    $0xffffffff,%edi
        printf(1, "panic at thread_join\n");
     658:	68 09 19 00 00       	push   $0x1909
     65d:	6a 01                	push   $0x1
     65f:	e8 bc 0e 00 00       	call   1520 <printf>
        return -1;
     664:	83 c4 10             	add    $0x10,%esp
}
     667:	8d 65 f4             	lea    -0xc(%ebp),%esp
     66a:	89 f8                	mov    %edi,%eax
     66c:	5b                   	pop    %ebx
     66d:	5e                   	pop    %esi
     66e:	5f                   	pop    %edi
     66f:	5d                   	pop    %ebp
     670:	c3                   	ret    
    printf(1, "panic at pipe in pipetest\n");
     671:	83 ec 08             	sub    $0x8,%esp
    return -1;
     674:	bf ff ff ff ff       	mov    $0xffffffff,%edi
    printf(1, "panic at pipe in pipetest\n");
     679:	68 1f 19 00 00       	push   $0x191f
     67e:	6a 01                	push   $0x1
     680:	e8 9b 0e 00 00       	call   1520 <printf>
    return -1;
     685:	83 c4 10             	add    $0x10,%esp
     688:	eb b5                	jmp    63f <pipetest+0x17f>
      printf(1, "panic at fork in pipetest\n");
     68a:	83 ec 08             	sub    $0x8,%esp
      return -1;
     68d:	bf ff ff ff ff       	mov    $0xffffffff,%edi
      printf(1, "panic at fork in pipetest\n");
     692:	68 3a 19 00 00       	push   $0x193a
     697:	6a 01                	push   $0x1
     699:	e8 82 0e 00 00       	call   1520 <printf>
      return -1;
     69e:	83 c4 10             	add    $0x10,%esp
     6a1:	eb 9c                	jmp    63f <pipetest+0x17f>
    printf(1, "panic at wait in pipetest\n");
     6a3:	50                   	push   %eax
     6a4:	50                   	push   %eax
    return -1;
     6a5:	83 cf ff             	or     $0xffffffff,%edi
    printf(1, "panic at wait in pipetest\n");
     6a8:	68 55 19 00 00       	push   $0x1955
     6ad:	6a 01                	push   $0x1
     6af:	e8 6c 0e 00 00       	call   1520 <printf>
    return -1;
     6b4:	83 c4 10             	add    $0x10,%esp
     6b7:	eb 86                	jmp    63f <pipetest+0x17f>
     6b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

000006c0 <execthreadmain>:
{
     6c0:	55                   	push   %ebp
     6c1:	89 e5                	mov    %esp,%ebp
     6c3:	83 ec 24             	sub    $0x24,%esp
  sleep(1);
     6c6:	6a 01                	push   $0x1
  char *args[3] = {"echo", "echo is executed!", 0};
     6c8:	c7 45 ec 70 19 00 00 	movl   $0x1970,-0x14(%ebp)
     6cf:	c7 45 f0 75 19 00 00 	movl   $0x1975,-0x10(%ebp)
     6d6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  sleep(1);
     6dd:	e8 20 0d 00 00       	call   1402 <sleep>
  exec("echo", args);
     6e2:	58                   	pop    %eax
     6e3:	8d 45 ec             	lea    -0x14(%ebp),%eax
     6e6:	5a                   	pop    %edx
     6e7:	50                   	push   %eax
     6e8:	68 70 19 00 00       	push   $0x1970
     6ed:	e8 b8 0c 00 00       	call   13aa <exec>
  printf(1, "panic at execthreadmain\n");
     6f2:	59                   	pop    %ecx
     6f3:	58                   	pop    %eax
     6f4:	68 87 19 00 00       	push   $0x1987
     6f9:	6a 01                	push   $0x1
     6fb:	e8 20 0e 00 00       	call   1520 <printf>
  exit();
     700:	e8 6d 0c 00 00       	call   1372 <exit>
     705:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
     709:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000710 <sbrkthreadmain>:
{
     710:	55                   	push   %ebp
     711:	89 e5                	mov    %esp,%ebp
     713:	57                   	push   %edi
     714:	56                   	push   %esi
     715:	53                   	push   %ebx
     716:	83 ec 18             	sub    $0x18,%esp
     719:	8b 75 08             	mov    0x8(%ebp),%esi
  oldbrk = sbrk(1000);
     71c:	68 e8 03 00 00       	push   $0x3e8
     721:	e8 d4 0c 00 00       	call   13fa <sbrk>
     726:	8d 56 01             	lea    0x1(%esi),%edx
  end = oldbrk + 1000;
     729:	8d 98 e8 03 00 00    	lea    0x3e8(%eax),%ebx
  oldbrk = sbrk(1000);
     72f:	89 c7                	mov    %eax,%edi
     731:	83 c4 10             	add    $0x10,%esp
     734:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *c = tid+1;
     738:	88 10                	mov    %dl,(%eax)
  for (c = oldbrk; c < end; c++){
     73a:	83 c0 01             	add    $0x1,%eax
     73d:	39 c3                	cmp    %eax,%ebx
     73f:	75 f7                	jne    738 <sbrkthreadmain+0x28>
  sleep(1);
     741:	83 ec 0c             	sub    $0xc,%esp
    if (*c != tid+1){
     744:	83 c6 01             	add    $0x1,%esi
  sleep(1);
     747:	6a 01                	push   $0x1
     749:	e8 b4 0c 00 00       	call   1402 <sleep>
    if (*c != tid+1){
     74e:	0f be 17             	movsbl (%edi),%edx
     751:	83 c4 10             	add    $0x10,%esp
     754:	39 d6                	cmp    %edx,%esi
     756:	89 d0                	mov    %edx,%eax
     758:	75 11                	jne    76b <sbrkthreadmain+0x5b>
     75a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for (c = oldbrk; c < end; c++){
     760:	83 c7 01             	add    $0x1,%edi
     763:	39 fb                	cmp    %edi,%ebx
     765:	74 18                	je     77f <sbrkthreadmain+0x6f>
    if (*c != tid+1){
     767:	38 07                	cmp    %al,(%edi)
     769:	74 f5                	je     760 <sbrkthreadmain+0x50>
      printf(1, "panic at sbrkthreadmain\n");
     76b:	83 ec 08             	sub    $0x8,%esp
     76e:	68 a0 19 00 00       	push   $0x19a0
     773:	6a 01                	push   $0x1
     775:	e8 a6 0d 00 00       	call   1520 <printf>
      exit();
     77a:	e8 f3 0b 00 00       	call   1372 <exit>
  thread_exit(0);
     77f:	83 ec 0c             	sub    $0xc,%esp
     782:	6a 00                	push   $0x0
     784:	e8 b1 0c 00 00       	call   143a <thread_exit>
     789:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000790 <killthreadmain>:
{
     790:	55                   	push   %ebp
     791:	89 e5                	mov    %esp,%ebp
     793:	83 ec 08             	sub    $0x8,%esp
  kill(getpid());
     796:	e8 57 0c 00 00       	call   13f2 <getpid>
     79b:	83 ec 0c             	sub    $0xc,%esp
     79e:	50                   	push   %eax
     79f:	e8 fe 0b 00 00       	call   13a2 <kill>
     7a4:	83 c4 10             	add    $0x10,%esp
     7a7:	eb fe                	jmp    7a7 <killthreadmain+0x17>
     7a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

000007b0 <pipethreadmain>:
{
     7b0:	55                   	push   %ebp
     7b1:	89 e5                	mov    %esp,%ebp
     7b3:	57                   	push   %edi
     7b4:	56                   	push   %esi
     7b5:	53                   	push   %ebx
      write(fd[1], &i, sizeof(int));
     7b6:	8d 7d e0             	lea    -0x20(%ebp),%edi
{
     7b9:	83 ec 1c             	sub    $0x1c,%esp
     7bc:	8b 5d 08             	mov    0x8(%ebp),%ebx
  for (i = -5; i <= 5; i++){
     7bf:	c7 45 e0 fb ff ff ff 	movl   $0xfffffffb,-0x20(%ebp)
  int type = ((int*)arg)[0];
     7c6:	8b 33                	mov    (%ebx),%esi
     7c8:	eb 32                	jmp    7fc <pipethreadmain+0x4c>
     7ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      read(fd[0], &input, sizeof(int));
     7d0:	8d 45 e4             	lea    -0x1c(%ebp),%eax
     7d3:	83 ec 04             	sub    $0x4,%esp
     7d6:	6a 04                	push   $0x4
     7d8:	50                   	push   %eax
     7d9:	ff 73 04             	pushl  0x4(%ebx)
     7dc:	e8 a9 0b 00 00       	call   138a <read>
      __sync_fetch_and_add(&gcnt, input);
     7e1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     7e4:	f0 01 05 64 23 00 00 	lock add %eax,0x2364
  for (i = -5; i <= 5; i++){
     7eb:	8b 45 e0             	mov    -0x20(%ebp),%eax
     7ee:	83 c4 10             	add    $0x10,%esp
     7f1:	83 c0 01             	add    $0x1,%eax
     7f4:	83 f8 05             	cmp    $0x5,%eax
     7f7:	89 45 e0             	mov    %eax,-0x20(%ebp)
     7fa:	7f 23                	jg     81f <pipethreadmain+0x6f>
    if (type){
     7fc:	85 f6                	test   %esi,%esi
     7fe:	75 d0                	jne    7d0 <pipethreadmain+0x20>
      write(fd[1], &i, sizeof(int));
     800:	83 ec 04             	sub    $0x4,%esp
     803:	6a 04                	push   $0x4
     805:	57                   	push   %edi
     806:	ff 73 08             	pushl  0x8(%ebx)
     809:	e8 84 0b 00 00       	call   1392 <write>
  for (i = -5; i <= 5; i++){
     80e:	8b 45 e0             	mov    -0x20(%ebp),%eax
      write(fd[1], &i, sizeof(int));
     811:	83 c4 10             	add    $0x10,%esp
  for (i = -5; i <= 5; i++){
     814:	83 c0 01             	add    $0x1,%eax
     817:	83 f8 05             	cmp    $0x5,%eax
     81a:	89 45 e0             	mov    %eax,-0x20(%ebp)
     81d:	7e dd                	jle    7fc <pipethreadmain+0x4c>
  thread_exit(0);
     81f:	83 ec 0c             	sub    $0xc,%esp
     822:	6a 00                	push   $0x0
     824:	e8 11 0c 00 00       	call   143a <thread_exit>
     829:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000830 <stridethreadmain>:

// ============================================================================

void*
stridethreadmain(void *arg)
{
     830:	55                   	push   %ebp
     831:	89 e5                	mov    %esp,%ebp
     833:	83 ec 08             	sub    $0x8,%esp
     836:	8b 55 08             	mov    0x8(%ebp),%edx
     839:	8b 02                	mov    (%edx),%eax
     83b:	90                   	nop
     83c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  int *flag = (int*)arg;
  int t;
  while(*flag){
     840:	85 c0                	test   %eax,%eax
     842:	74 1c                	je     860 <stridethreadmain+0x30>
     844:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    while(*flag == 1){
     848:	83 f8 01             	cmp    $0x1,%eax
     84b:	75 f3                	jne    840 <stridethreadmain+0x10>
      for (t = 0; t < 5; t++);
      __sync_fetch_and_add(&gcnt, 1);
     84d:	f0 83 05 64 23 00 00 	lock addl $0x1,0x2364
     854:	01 
    while(*flag == 1){
     855:	8b 02                	mov    (%edx),%eax
     857:	eb ef                	jmp    848 <stridethreadmain+0x18>
     859:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    }
  }
  thread_exit(0);
     860:	83 ec 0c             	sub    $0xc,%esp
     863:	6a 00                	push   $0x0
     865:	e8 d0 0b 00 00       	call   143a <thread_exit>
     86a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000870 <stridetest>:
  return 0;
}

int
stridetest(void)
{
     870:	55                   	push   %ebp
     871:	89 e5                	mov    %esp,%ebp
     873:	57                   	push   %edi
     874:	56                   	push   %esi
     875:	53                   	push   %ebx
     876:	83 ec 4c             	sub    $0x4c,%esp
  int i;
  int pid;
  int flag;
  void *retval;

  gcnt = 0;
     879:	c7 05 64 23 00 00 00 	movl   $0x0,0x2364
     880:	00 00 00 
  flag = 2;
     883:	c7 45 b8 02 00 00 00 	movl   $0x2,-0x48(%ebp)
  if ((pid = fork()) == -1){
     88a:	e8 db 0a 00 00       	call   136a <fork>
     88f:	83 f8 ff             	cmp    $0xffffffff,%eax
     892:	89 45 b4             	mov    %eax,-0x4c(%ebp)
     895:	0f 84 2e 01 00 00    	je     9c9 <stridetest+0x159>
    printf(1, "panic at fork in stridetest\n");
    exit();
  } else if (pid == 0){
     89b:	8b 5d b4             	mov    -0x4c(%ebp),%ebx
     89e:	85 db                	test   %ebx,%ebx
     8a0:	0f 85 c2 00 00 00    	jne    968 <stridetest+0xf8>
    set_cpu_share(2);
     8a6:	83 ec 0c             	sub    $0xc,%esp
     8a9:	6a 02                	push   $0x2
     8ab:	e8 82 0b 00 00       	call   1432 <set_cpu_share>
     8b0:	83 c4 10             	add    $0x10,%esp
     8b3:	8d 5d c0             	lea    -0x40(%ebp),%ebx
     8b6:	8d 7d b8             	lea    -0x48(%ebp),%edi
{
     8b9:	89 de                	mov    %ebx,%esi
     8bb:	90                   	nop
     8bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  } else{
    set_cpu_share(10);
  }

  for (i = 0; i < NUM_THREAD; i++){
    if (thread_create(&threads[i], stridethreadmain, (void*)&flag) != 0){
     8c0:	83 ec 04             	sub    $0x4,%esp
     8c3:	57                   	push   %edi
     8c4:	68 30 08 00 00       	push   $0x830
     8c9:	56                   	push   %esi
     8ca:	e8 73 0b 00 00       	call   1442 <thread_create>
     8cf:	83 c4 10             	add    $0x10,%esp
     8d2:	85 c0                	test   %eax,%eax
     8d4:	0f 85 a6 00 00 00    	jne    980 <stridetest+0x110>
  for (i = 0; i < NUM_THREAD; i++){
     8da:	8d 45 e8             	lea    -0x18(%ebp),%eax
     8dd:	83 c6 04             	add    $0x4,%esi
     8e0:	39 c6                	cmp    %eax,%esi
     8e2:	75 dc                	jne    8c0 <stridetest+0x50>
      printf(1, "panic at thread_create\n");
      return -1;
    }
  }
  flag = 1;
  sleep(500);
     8e4:	83 ec 0c             	sub    $0xc,%esp
  flag = 1;
     8e7:	c7 45 b8 01 00 00 00 	movl   $0x1,-0x48(%ebp)
  sleep(500);
     8ee:	68 f4 01 00 00       	push   $0x1f4
     8f3:	e8 0a 0b 00 00       	call   1402 <sleep>
  flag = 0;
     8f8:	c7 45 b8 00 00 00 00 	movl   $0x0,-0x48(%ebp)
     8ff:	83 c4 10             	add    $0x10,%esp
     902:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for (i = 0; i < NUM_THREAD; i++){
    if (thread_join(threads[i], &retval) != 0){
     908:	8d 45 bc             	lea    -0x44(%ebp),%eax
     90b:	83 ec 08             	sub    $0x8,%esp
     90e:	50                   	push   %eax
     90f:	ff 33                	pushl  (%ebx)
     911:	e8 34 0b 00 00       	call   144a <thread_join>
     916:	83 c4 10             	add    $0x10,%esp
     919:	85 c0                	test   %eax,%eax
     91b:	89 c7                	mov    %eax,%edi
     91d:	0f 85 85 00 00 00    	jne    9a8 <stridetest+0x138>
     923:	83 c3 04             	add    $0x4,%ebx
  for (i = 0; i < NUM_THREAD; i++){
     926:	39 f3                	cmp    %esi,%ebx
     928:	75 de                	jne    908 <stridetest+0x98>
      printf(1, "panic at thread_join\n");
      return -1;
    }
  }

  if (pid == 0){
     92a:	8b 4d b4             	mov    -0x4c(%ebp),%ecx
    printf(1, " 2% : %d\n", gcnt);
     92d:	a1 64 23 00 00       	mov    0x2364,%eax
  if (pid == 0){
     932:	85 c9                	test   %ecx,%ecx
     934:	0f 84 a2 00 00 00    	je     9dc <stridetest+0x16c>
    exit();
  } else{
    printf(1, "10% : %d\n", gcnt);
     93a:	83 ec 04             	sub    $0x4,%esp
     93d:	50                   	push   %eax
     93e:	68 e0 19 00 00       	push   $0x19e0
     943:	6a 01                	push   $0x1
     945:	e8 d6 0b 00 00       	call   1520 <printf>
    if (wait() == -1){
     94a:	e8 2b 0a 00 00       	call   137a <wait>
     94f:	83 c4 10             	add    $0x10,%esp
     952:	83 f8 ff             	cmp    $0xffffffff,%eax
     955:	0f 84 94 00 00 00    	je     9ef <stridetest+0x17f>
      exit();
    }
  }

  return 0;
}
     95b:	8d 65 f4             	lea    -0xc(%ebp),%esp
     95e:	89 f8                	mov    %edi,%eax
     960:	5b                   	pop    %ebx
     961:	5e                   	pop    %esi
     962:	5f                   	pop    %edi
     963:	5d                   	pop    %ebp
     964:	c3                   	ret    
     965:	8d 76 00             	lea    0x0(%esi),%esi
    set_cpu_share(10);
     968:	83 ec 0c             	sub    $0xc,%esp
     96b:	6a 0a                	push   $0xa
     96d:	e8 c0 0a 00 00       	call   1432 <set_cpu_share>
     972:	83 c4 10             	add    $0x10,%esp
     975:	e9 39 ff ff ff       	jmp    8b3 <stridetest+0x43>
     97a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      printf(1, "panic at thread_create\n");
     980:	83 ec 08             	sub    $0x8,%esp
      return -1;
     983:	bf ff ff ff ff       	mov    $0xffffffff,%edi
      printf(1, "panic at thread_create\n");
     988:	68 e1 18 00 00       	push   $0x18e1
     98d:	6a 01                	push   $0x1
     98f:	e8 8c 0b 00 00       	call   1520 <printf>
      return -1;
     994:	83 c4 10             	add    $0x10,%esp
}
     997:	8d 65 f4             	lea    -0xc(%ebp),%esp
     99a:	89 f8                	mov    %edi,%eax
     99c:	5b                   	pop    %ebx
     99d:	5e                   	pop    %esi
     99e:	5f                   	pop    %edi
     99f:	5d                   	pop    %ebp
     9a0:	c3                   	ret    
     9a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      printf(1, "panic at thread_join\n");
     9a8:	83 ec 08             	sub    $0x8,%esp
      return -1;
     9ab:	bf ff ff ff ff       	mov    $0xffffffff,%edi
      printf(1, "panic at thread_join\n");
     9b0:	68 09 19 00 00       	push   $0x1909
     9b5:	6a 01                	push   $0x1
     9b7:	e8 64 0b 00 00       	call   1520 <printf>
      return -1;
     9bc:	83 c4 10             	add    $0x10,%esp
}
     9bf:	8d 65 f4             	lea    -0xc(%ebp),%esp
     9c2:	89 f8                	mov    %edi,%eax
     9c4:	5b                   	pop    %ebx
     9c5:	5e                   	pop    %esi
     9c6:	5f                   	pop    %edi
     9c7:	5d                   	pop    %ebp
     9c8:	c3                   	ret    
    printf(1, "panic at fork in stridetest\n");
     9c9:	56                   	push   %esi
     9ca:	56                   	push   %esi
     9cb:	68 b9 19 00 00       	push   $0x19b9
     9d0:	6a 01                	push   $0x1
     9d2:	e8 49 0b 00 00       	call   1520 <printf>
    exit();
     9d7:	e8 96 09 00 00       	call   1372 <exit>
    printf(1, " 2% : %d\n", gcnt);
     9dc:	52                   	push   %edx
     9dd:	50                   	push   %eax
     9de:	68 d6 19 00 00       	push   $0x19d6
     9e3:	6a 01                	push   $0x1
     9e5:	e8 36 0b 00 00       	call   1520 <printf>
    exit();
     9ea:	e8 83 09 00 00       	call   1372 <exit>
      printf(1, "panic at wait in stridetest\n");
     9ef:	50                   	push   %eax
     9f0:	50                   	push   %eax
     9f1:	68 ea 19 00 00       	push   $0x19ea
     9f6:	6a 01                	push   $0x1
     9f8:	e8 23 0b 00 00       	call   1520 <printf>
      exit();
     9fd:	e8 70 09 00 00       	call   1372 <exit>
     a02:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     a09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000a10 <exittest1>:
{
     a10:	55                   	push   %ebp
     a11:	89 e5                	mov    %esp,%ebp
     a13:	57                   	push   %edi
     a14:	56                   	push   %esi
     a15:	53                   	push   %ebx
     a16:	8d 7d e8             	lea    -0x18(%ebp),%edi
     a19:	8d 5d c0             	lea    -0x40(%ebp),%ebx
     a1c:	83 ec 3c             	sub    $0x3c,%esp
     a1f:	90                   	nop
    if (thread_create(&threads[i], exitthreadmain, (void*)1) != 0){
     a20:	83 ec 04             	sub    $0x4,%esp
     a23:	6a 01                	push   $0x1
     a25:	68 b0 02 00 00       	push   $0x2b0
     a2a:	53                   	push   %ebx
     a2b:	e8 12 0a 00 00       	call   1442 <thread_create>
     a30:	83 c4 10             	add    $0x10,%esp
     a33:	85 c0                	test   %eax,%eax
     a35:	89 c6                	mov    %eax,%esi
     a37:	75 27                	jne    a60 <exittest1+0x50>
     a39:	83 c3 04             	add    $0x4,%ebx
  for (i = 0; i < NUM_THREAD; i++){
     a3c:	39 fb                	cmp    %edi,%ebx
     a3e:	75 e0                	jne    a20 <exittest1+0x10>
  sleep(1);
     a40:	83 ec 0c             	sub    $0xc,%esp
     a43:	6a 01                	push   $0x1
     a45:	e8 b8 09 00 00       	call   1402 <sleep>
  return 0;
     a4a:	83 c4 10             	add    $0x10,%esp
}
     a4d:	8d 65 f4             	lea    -0xc(%ebp),%esp
     a50:	89 f0                	mov    %esi,%eax
     a52:	5b                   	pop    %ebx
     a53:	5e                   	pop    %esi
     a54:	5f                   	pop    %edi
     a55:	5d                   	pop    %ebp
     a56:	c3                   	ret    
     a57:	89 f6                	mov    %esi,%esi
     a59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      printf(1, "panic at thread_create\n");
     a60:	83 ec 08             	sub    $0x8,%esp
     a63:	be ff ff ff ff       	mov    $0xffffffff,%esi
     a68:	68 e1 18 00 00       	push   $0x18e1
     a6d:	6a 01                	push   $0x1
     a6f:	e8 ac 0a 00 00       	call   1520 <printf>
     a74:	83 c4 10             	add    $0x10,%esp
}
     a77:	8d 65 f4             	lea    -0xc(%ebp),%esp
     a7a:	89 f0                	mov    %esi,%eax
     a7c:	5b                   	pop    %ebx
     a7d:	5e                   	pop    %esi
     a7e:	5f                   	pop    %edi
     a7f:	5d                   	pop    %ebp
     a80:	c3                   	ret    
     a81:	eb 0d                	jmp    a90 <jointest1>
     a83:	90                   	nop
     a84:	90                   	nop
     a85:	90                   	nop
     a86:	90                   	nop
     a87:	90                   	nop
     a88:	90                   	nop
     a89:	90                   	nop
     a8a:	90                   	nop
     a8b:	90                   	nop
     a8c:	90                   	nop
     a8d:	90                   	nop
     a8e:	90                   	nop
     a8f:	90                   	nop

00000a90 <jointest1>:
{
     a90:	55                   	push   %ebp
     a91:	89 e5                	mov    %esp,%ebp
     a93:	56                   	push   %esi
     a94:	53                   	push   %ebx
     a95:	8d 75 cc             	lea    -0x34(%ebp),%esi
  for (i = 1; i <= NUM_THREAD; i++){
     a98:	bb 01 00 00 00       	mov    $0x1,%ebx
{
     a9d:	83 ec 40             	sub    $0x40,%esp
    if (thread_create(&threads[i-1], jointhreadmain, (void*)i) != 0){
     aa0:	8d 04 9e             	lea    (%esi,%ebx,4),%eax
     aa3:	83 ec 04             	sub    $0x4,%esp
     aa6:	53                   	push   %ebx
     aa7:	68 70 02 00 00       	push   $0x270
     aac:	50                   	push   %eax
     aad:	e8 90 09 00 00       	call   1442 <thread_create>
     ab2:	83 c4 10             	add    $0x10,%esp
     ab5:	85 c0                	test   %eax,%eax
     ab7:	75 67                	jne    b20 <jointest1+0x90>
  for (i = 1; i <= NUM_THREAD; i++){
     ab9:	83 c3 01             	add    $0x1,%ebx
     abc:	83 fb 0b             	cmp    $0xb,%ebx
     abf:	75 df                	jne    aa0 <jointest1+0x10>
  printf(1, "thread_join!!!\n");
     ac1:	83 ec 08             	sub    $0x8,%esp
     ac4:	bb 02 00 00 00       	mov    $0x2,%ebx
     ac9:	68 f9 18 00 00       	push   $0x18f9
     ace:	6a 01                	push   $0x1
     ad0:	e8 4b 0a 00 00       	call   1520 <printf>
     ad5:	83 c4 10             	add    $0x10,%esp
     ad8:	90                   	nop
     ad9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if (thread_join(threads[i-1], &retval) != 0 || (int)retval != i * 2 ){
     ae0:	83 ec 08             	sub    $0x8,%esp
     ae3:	56                   	push   %esi
     ae4:	ff 74 5d cc          	pushl  -0x34(%ebp,%ebx,2)
     ae8:	e8 5d 09 00 00       	call   144a <thread_join>
     aed:	83 c4 10             	add    $0x10,%esp
     af0:	85 c0                	test   %eax,%eax
     af2:	75 4c                	jne    b40 <jointest1+0xb0>
     af4:	39 5d cc             	cmp    %ebx,-0x34(%ebp)
     af7:	75 47                	jne    b40 <jointest1+0xb0>
     af9:	83 c3 02             	add    $0x2,%ebx
  for (i = 1; i <= NUM_THREAD; i++){
     afc:	83 fb 16             	cmp    $0x16,%ebx
     aff:	75 df                	jne    ae0 <jointest1+0x50>
  printf(1,"\n");
     b01:	83 ec 08             	sub    $0x8,%esp
     b04:	89 45 c4             	mov    %eax,-0x3c(%ebp)
     b07:	68 07 19 00 00       	push   $0x1907
     b0c:	6a 01                	push   $0x1
     b0e:	e8 0d 0a 00 00       	call   1520 <printf>
  return 0;
     b13:	8b 45 c4             	mov    -0x3c(%ebp),%eax
     b16:	83 c4 10             	add    $0x10,%esp
}
     b19:	8d 65 f8             	lea    -0x8(%ebp),%esp
     b1c:	5b                   	pop    %ebx
     b1d:	5e                   	pop    %esi
     b1e:	5d                   	pop    %ebp
     b1f:	c3                   	ret    
      printf(1, "panic at thread_create\n");
     b20:	83 ec 08             	sub    $0x8,%esp
     b23:	68 e1 18 00 00       	push   $0x18e1
     b28:	6a 01                	push   $0x1
     b2a:	e8 f1 09 00 00       	call   1520 <printf>
      return -1;
     b2f:	83 c4 10             	add    $0x10,%esp
}
     b32:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return -1;
     b35:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
     b3a:	5b                   	pop    %ebx
     b3b:	5e                   	pop    %esi
     b3c:	5d                   	pop    %ebp
     b3d:	c3                   	ret    
     b3e:	66 90                	xchg   %ax,%ax
      printf(1, "panic at thread_join\n");
     b40:	83 ec 08             	sub    $0x8,%esp
     b43:	68 09 19 00 00       	push   $0x1909
     b48:	6a 01                	push   $0x1
     b4a:	e8 d1 09 00 00       	call   1520 <printf>
     b4f:	83 c4 10             	add    $0x10,%esp
}
     b52:	8d 65 f8             	lea    -0x8(%ebp),%esp
      printf(1, "panic at thread_join\n");
     b55:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
     b5a:	5b                   	pop    %ebx
     b5b:	5e                   	pop    %esi
     b5c:	5d                   	pop    %ebp
     b5d:	c3                   	ret    
     b5e:	66 90                	xchg   %ax,%ax

00000b60 <stresstest>:
{
     b60:	55                   	push   %ebp
     b61:	89 e5                	mov    %esp,%ebp
     b63:	57                   	push   %edi
     b64:	56                   	push   %esi
     b65:	53                   	push   %ebx
     b66:	8d 75 bc             	lea    -0x44(%ebp),%esi
     b69:	83 ec 4c             	sub    $0x4c,%esp
  for (n = 1; n <= nstress; n++){
     b6c:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
     b73:	31 ff                	xor    %edi,%edi
     b75:	8d 76 00             	lea    0x0(%esi),%esi
      if (thread_create(&threads[i], stressthreadmain, (void*)i) != 0){
     b78:	8d 44 bd c0          	lea    -0x40(%ebp,%edi,4),%eax
     b7c:	83 ec 04             	sub    $0x4,%esp
     b7f:	8d 5d c0             	lea    -0x40(%ebp),%ebx
     b82:	57                   	push   %edi
     b83:	68 a0 02 00 00       	push   $0x2a0
     b88:	50                   	push   %eax
     b89:	e8 b4 08 00 00       	call   1442 <thread_create>
     b8e:	83 c4 10             	add    $0x10,%esp
     b91:	85 c0                	test   %eax,%eax
     b93:	75 6b                	jne    c00 <stresstest+0xa0>
    for (i = 0; i < NUM_THREAD; i++){
     b95:	83 c7 01             	add    $0x1,%edi
     b98:	83 ff 0a             	cmp    $0xa,%edi
     b9b:	75 db                	jne    b78 <stresstest+0x18>
     b9d:	8d 76 00             	lea    0x0(%esi),%esi
      if (thread_join(threads[i], &retval) != 0){
     ba0:	83 ec 08             	sub    $0x8,%esp
     ba3:	56                   	push   %esi
     ba4:	ff 33                	pushl  (%ebx)
     ba6:	e8 9f 08 00 00       	call   144a <thread_join>
     bab:	83 c4 10             	add    $0x10,%esp
     bae:	85 c0                	test   %eax,%eax
     bb0:	75 6e                	jne    c20 <stresstest+0xc0>
    for (i = 0; i < NUM_THREAD; i++){
     bb2:	8d 4d e8             	lea    -0x18(%ebp),%ecx
     bb5:	83 c3 04             	add    $0x4,%ebx
     bb8:	39 cb                	cmp    %ecx,%ebx
     bba:	75 e4                	jne    ba0 <stresstest+0x40>
  for (n = 1; n <= nstress; n++){
     bbc:	83 45 b4 01          	addl   $0x1,-0x4c(%ebp)
     bc0:	8b 55 b4             	mov    -0x4c(%ebp),%edx
     bc3:	81 fa b9 88 00 00    	cmp    $0x88b9,%edx
     bc9:	74 74                	je     c3f <stresstest+0xdf>
    if (n % 1000 == 0)
     bcb:	8b 45 b4             	mov    -0x4c(%ebp),%eax
     bce:	ba d3 4d 62 10       	mov    $0x10624dd3,%edx
     bd3:	f7 e2                	mul    %edx
     bd5:	8b 45 b4             	mov    -0x4c(%ebp),%eax
     bd8:	c1 ea 06             	shr    $0x6,%edx
     bdb:	69 d2 e8 03 00 00    	imul   $0x3e8,%edx,%edx
     be1:	39 d0                	cmp    %edx,%eax
     be3:	75 8e                	jne    b73 <stresstest+0x13>
      printf(1, "%d\n", n);
     be5:	83 ec 04             	sub    $0x4,%esp
     be8:	50                   	push   %eax
     be9:	68 e6 19 00 00       	push   $0x19e6
     bee:	6a 01                	push   $0x1
     bf0:	e8 2b 09 00 00       	call   1520 <printf>
     bf5:	83 c4 10             	add    $0x10,%esp
     bf8:	e9 76 ff ff ff       	jmp    b73 <stresstest+0x13>
     bfd:	8d 76 00             	lea    0x0(%esi),%esi
        printf(1, "panic at thread_create\n");
     c00:	83 ec 08             	sub    $0x8,%esp
     c03:	68 e1 18 00 00       	push   $0x18e1
     c08:	6a 01                	push   $0x1
     c0a:	e8 11 09 00 00       	call   1520 <printf>
        return -1;
     c0f:	83 c4 10             	add    $0x10,%esp
     c12:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
     c17:	8d 65 f4             	lea    -0xc(%ebp),%esp
     c1a:	5b                   	pop    %ebx
     c1b:	5e                   	pop    %esi
     c1c:	5f                   	pop    %edi
     c1d:	5d                   	pop    %ebp
     c1e:	c3                   	ret    
     c1f:	90                   	nop
        printf(1, "panic at thread_join\n");
     c20:	83 ec 08             	sub    $0x8,%esp
     c23:	68 09 19 00 00       	push   $0x1909
     c28:	6a 01                	push   $0x1
     c2a:	e8 f1 08 00 00       	call   1520 <printf>
        return -1;
     c2f:	83 c4 10             	add    $0x10,%esp
}
     c32:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return -1;
     c35:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
     c3a:	5b                   	pop    %ebx
     c3b:	5e                   	pop    %esi
     c3c:	5f                   	pop    %edi
     c3d:	5d                   	pop    %ebp
     c3e:	c3                   	ret    
  printf(1, "\n");
     c3f:	83 ec 08             	sub    $0x8,%esp
     c42:	89 45 b4             	mov    %eax,-0x4c(%ebp)
     c45:	68 07 19 00 00       	push   $0x1907
     c4a:	6a 01                	push   $0x1
     c4c:	e8 cf 08 00 00       	call   1520 <printf>
     c51:	83 c4 10             	add    $0x10,%esp
     c54:	8b 45 b4             	mov    -0x4c(%ebp),%eax
     c57:	eb be                	jmp    c17 <stresstest+0xb7>
     c59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000c60 <killtest>:
{
     c60:	55                   	push   %ebp
     c61:	89 e5                	mov    %esp,%ebp
     c63:	57                   	push   %edi
     c64:	56                   	push   %esi
     c65:	53                   	push   %ebx
  for (i = 0; i < NUM_THREAD; i++){
     c66:	31 db                	xor    %ebx,%ebx
{
     c68:	83 ec 3c             	sub    $0x3c,%esp
     c6b:	90                   	nop
     c6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if (thread_create(&threads[i], killthreadmain, (void*)i) != 0){
     c70:	8d 44 9d c0          	lea    -0x40(%ebp,%ebx,4),%eax
     c74:	83 ec 04             	sub    $0x4,%esp
     c77:	8d 75 c0             	lea    -0x40(%ebp),%esi
     c7a:	53                   	push   %ebx
     c7b:	68 90 07 00 00       	push   $0x790
     c80:	50                   	push   %eax
     c81:	e8 bc 07 00 00       	call   1442 <thread_create>
     c86:	83 c4 10             	add    $0x10,%esp
     c89:	85 c0                	test   %eax,%eax
     c8b:	75 53                	jne    ce0 <killtest+0x80>
  for (i = 0; i < NUM_THREAD; i++){
     c8d:	83 c3 01             	add    $0x1,%ebx
     c90:	83 fb 0a             	cmp    $0xa,%ebx
     c93:	75 db                	jne    c70 <killtest+0x10>
     c95:	8d 7d e8             	lea    -0x18(%ebp),%edi
     c98:	8d 5d bc             	lea    -0x44(%ebp),%ebx
    if (thread_join(threads[i], &retval) != 0){
     c9b:	83 ec 08             	sub    $0x8,%esp
     c9e:	53                   	push   %ebx
     c9f:	ff 36                	pushl  (%esi)
     ca1:	e8 a4 07 00 00       	call   144a <thread_join>
     ca6:	83 c4 10             	add    $0x10,%esp
     ca9:	85 c0                	test   %eax,%eax
     cab:	75 13                	jne    cc0 <killtest+0x60>
     cad:	83 c6 04             	add    $0x4,%esi
  for (i = 0; i < NUM_THREAD; i++){
     cb0:	39 fe                	cmp    %edi,%esi
     cb2:	75 e7                	jne    c9b <killtest+0x3b>
     cb4:	eb fe                	jmp    cb4 <killtest+0x54>
     cb6:	8d 76 00             	lea    0x0(%esi),%esi
     cb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      printf(1, "panic at thread_join\n");
     cc0:	83 ec 08             	sub    $0x8,%esp
     cc3:	68 09 19 00 00       	push   $0x1909
     cc8:	6a 01                	push   $0x1
     cca:	e8 51 08 00 00       	call   1520 <printf>
      return -1;
     ccf:	83 c4 10             	add    $0x10,%esp
}
     cd2:	8d 65 f4             	lea    -0xc(%ebp),%esp
     cd5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     cda:	5b                   	pop    %ebx
     cdb:	5e                   	pop    %esi
     cdc:	5f                   	pop    %edi
     cdd:	5d                   	pop    %ebp
     cde:	c3                   	ret    
     cdf:	90                   	nop
      printf(1, "panic at thread_create\n");
     ce0:	83 ec 08             	sub    $0x8,%esp
     ce3:	68 e1 18 00 00       	push   $0x18e1
     ce8:	6a 01                	push   $0x1
     cea:	e8 31 08 00 00       	call   1520 <printf>
     cef:	83 c4 10             	add    $0x10,%esp
}
     cf2:	8d 65 f4             	lea    -0xc(%ebp),%esp
     cf5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     cfa:	5b                   	pop    %ebx
     cfb:	5e                   	pop    %esi
     cfc:	5f                   	pop    %edi
     cfd:	5d                   	pop    %ebp
     cfe:	c3                   	ret    
     cff:	90                   	nop

00000d00 <sleeptest>:
{
     d00:	55                   	push   %ebp
     d01:	89 e5                	mov    %esp,%ebp
     d03:	56                   	push   %esi
     d04:	53                   	push   %ebx
  for (i = 0; i < NUM_THREAD; i++){
     d05:	31 db                	xor    %ebx,%ebx
{
     d07:	83 ec 30             	sub    $0x30,%esp
     d0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if (thread_create(&threads[i], sleepthreadmain, (void*)i) != 0){
     d10:	8d 44 9d d0          	lea    -0x30(%ebp,%ebx,4),%eax
     d14:	83 ec 04             	sub    $0x4,%esp
     d17:	53                   	push   %ebx
     d18:	68 70 03 00 00       	push   $0x370
     d1d:	50                   	push   %eax
     d1e:	e8 1f 07 00 00       	call   1442 <thread_create>
     d23:	83 c4 10             	add    $0x10,%esp
     d26:	85 c0                	test   %eax,%eax
     d28:	89 c6                	mov    %eax,%esi
     d2a:	75 24                	jne    d50 <sleeptest+0x50>
  for (i = 0; i < NUM_THREAD; i++){
     d2c:	83 c3 01             	add    $0x1,%ebx
     d2f:	83 fb 0a             	cmp    $0xa,%ebx
     d32:	75 dc                	jne    d10 <sleeptest+0x10>
  sleep(10);
     d34:	83 ec 0c             	sub    $0xc,%esp
     d37:	6a 0a                	push   $0xa
     d39:	e8 c4 06 00 00       	call   1402 <sleep>
  return 0;
     d3e:	83 c4 10             	add    $0x10,%esp
}
     d41:	8d 65 f8             	lea    -0x8(%ebp),%esp
     d44:	89 f0                	mov    %esi,%eax
     d46:	5b                   	pop    %ebx
     d47:	5e                   	pop    %esi
     d48:	5d                   	pop    %ebp
     d49:	c3                   	ret    
     d4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      printf(1, "panic at thread_create\n");
     d50:	83 ec 08             	sub    $0x8,%esp
     d53:	be ff ff ff ff       	mov    $0xffffffff,%esi
     d58:	68 e1 18 00 00       	push   $0x18e1
     d5d:	6a 01                	push   $0x1
     d5f:	e8 bc 07 00 00       	call   1520 <printf>
     d64:	83 c4 10             	add    $0x10,%esp
}
     d67:	8d 65 f8             	lea    -0x8(%ebp),%esp
     d6a:	89 f0                	mov    %esi,%eax
     d6c:	5b                   	pop    %ebx
     d6d:	5e                   	pop    %esi
     d6e:	5d                   	pop    %ebp
     d6f:	c3                   	ret    

00000d70 <forktest>:
{
     d70:	55                   	push   %ebp
     d71:	89 e5                	mov    %esp,%ebp
     d73:	57                   	push   %edi
     d74:	56                   	push   %esi
     d75:	8d 75 c0             	lea    -0x40(%ebp),%esi
     d78:	53                   	push   %ebx
     d79:	8d 7d e8             	lea    -0x18(%ebp),%edi
     d7c:	83 ec 3c             	sub    $0x3c,%esp
     d7f:	89 f3                	mov    %esi,%ebx
     d81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if (thread_create(&threads[i], forkthreadmain, (void*)0) != 0){
     d88:	83 ec 04             	sub    $0x4,%esp
     d8b:	6a 00                	push   $0x0
     d8d:	68 f0 02 00 00       	push   $0x2f0
     d92:	53                   	push   %ebx
     d93:	e8 aa 06 00 00       	call   1442 <thread_create>
     d98:	83 c4 10             	add    $0x10,%esp
     d9b:	85 c0                	test   %eax,%eax
     d9d:	75 39                	jne    dd8 <forktest+0x68>
     d9f:	83 c3 04             	add    $0x4,%ebx
  for (i = 0; i < NUM_THREAD; i++){
     da2:	39 fb                	cmp    %edi,%ebx
     da4:	75 e2                	jne    d88 <forktest+0x18>
     da6:	8d 7d bc             	lea    -0x44(%ebp),%edi
     da9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if (thread_join(threads[i], &retval) != 0){
     db0:	83 ec 08             	sub    $0x8,%esp
     db3:	57                   	push   %edi
     db4:	ff 36                	pushl  (%esi)
     db6:	e8 8f 06 00 00       	call   144a <thread_join>
     dbb:	83 c4 10             	add    $0x10,%esp
     dbe:	85 c0                	test   %eax,%eax
     dc0:	75 3e                	jne    e00 <forktest+0x90>
     dc2:	83 c6 04             	add    $0x4,%esi
  for (i = 0; i < NUM_THREAD; i++){
     dc5:	39 de                	cmp    %ebx,%esi
     dc7:	75 e7                	jne    db0 <forktest+0x40>
}
     dc9:	8d 65 f4             	lea    -0xc(%ebp),%esp
     dcc:	5b                   	pop    %ebx
     dcd:	5e                   	pop    %esi
     dce:	5f                   	pop    %edi
     dcf:	5d                   	pop    %ebp
     dd0:	c3                   	ret    
     dd1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      printf(1, "panic at thread_create\n");
     dd8:	83 ec 08             	sub    $0x8,%esp
     ddb:	68 e1 18 00 00       	push   $0x18e1
     de0:	6a 01                	push   $0x1
     de2:	e8 39 07 00 00       	call   1520 <printf>
      return -1;
     de7:	83 c4 10             	add    $0x10,%esp
}
     dea:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
     ded:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
     df2:	5b                   	pop    %ebx
     df3:	5e                   	pop    %esi
     df4:	5f                   	pop    %edi
     df5:	5d                   	pop    %ebp
     df6:	c3                   	ret    
     df7:	89 f6                	mov    %esi,%esi
     df9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      printf(1, "panic at thread_join\n");
     e00:	83 ec 08             	sub    $0x8,%esp
     e03:	68 09 19 00 00       	push   $0x1909
     e08:	6a 01                	push   $0x1
     e0a:	e8 11 07 00 00       	call   1520 <printf>
     e0f:	83 c4 10             	add    $0x10,%esp
}
     e12:	8d 65 f4             	lea    -0xc(%ebp),%esp
      printf(1, "panic at thread_join\n");
     e15:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
     e1a:	5b                   	pop    %ebx
     e1b:	5e                   	pop    %esi
     e1c:	5f                   	pop    %edi
     e1d:	5d                   	pop    %ebp
     e1e:	c3                   	ret    
     e1f:	90                   	nop

00000e20 <sbrktest>:
{
     e20:	55                   	push   %ebp
     e21:	89 e5                	mov    %esp,%ebp
     e23:	57                   	push   %edi
     e24:	56                   	push   %esi
     e25:	53                   	push   %ebx
  for (i = 0; i < NUM_THREAD; i++){
     e26:	31 db                	xor    %ebx,%ebx
{
     e28:	83 ec 3c             	sub    $0x3c,%esp
     e2b:	90                   	nop
     e2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if (thread_create(&threads[i], sbrkthreadmain, (void*)i) != 0){
     e30:	8d 44 9d c0          	lea    -0x40(%ebp,%ebx,4),%eax
     e34:	83 ec 04             	sub    $0x4,%esp
     e37:	8d 75 c0             	lea    -0x40(%ebp),%esi
     e3a:	53                   	push   %ebx
     e3b:	68 10 07 00 00       	push   $0x710
     e40:	50                   	push   %eax
     e41:	e8 fc 05 00 00       	call   1442 <thread_create>
     e46:	83 c4 10             	add    $0x10,%esp
     e49:	85 c0                	test   %eax,%eax
     e4b:	75 3b                	jne    e88 <sbrktest+0x68>
  for (i = 0; i < NUM_THREAD; i++){
     e4d:	83 c3 01             	add    $0x1,%ebx
     e50:	83 fb 0a             	cmp    $0xa,%ebx
     e53:	75 db                	jne    e30 <sbrktest+0x10>
     e55:	8d 7d e8             	lea    -0x18(%ebp),%edi
     e58:	8d 5d bc             	lea    -0x44(%ebp),%ebx
     e5b:	90                   	nop
     e5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if (thread_join(threads[i], &retval) != 0){
     e60:	83 ec 08             	sub    $0x8,%esp
     e63:	53                   	push   %ebx
     e64:	ff 36                	pushl  (%esi)
     e66:	e8 df 05 00 00       	call   144a <thread_join>
     e6b:	83 c4 10             	add    $0x10,%esp
     e6e:	85 c0                	test   %eax,%eax
     e70:	75 3e                	jne    eb0 <sbrktest+0x90>
     e72:	83 c6 04             	add    $0x4,%esi
  for (i = 0; i < NUM_THREAD; i++){
     e75:	39 fe                	cmp    %edi,%esi
     e77:	75 e7                	jne    e60 <sbrktest+0x40>
}
     e79:	8d 65 f4             	lea    -0xc(%ebp),%esp
     e7c:	5b                   	pop    %ebx
     e7d:	5e                   	pop    %esi
     e7e:	5f                   	pop    %edi
     e7f:	5d                   	pop    %ebp
     e80:	c3                   	ret    
     e81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      printf(1, "panic at thread_create\n");
     e88:	83 ec 08             	sub    $0x8,%esp
     e8b:	68 e1 18 00 00       	push   $0x18e1
     e90:	6a 01                	push   $0x1
     e92:	e8 89 06 00 00       	call   1520 <printf>
      return -1;
     e97:	83 c4 10             	add    $0x10,%esp
}
     e9a:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
     e9d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
     ea2:	5b                   	pop    %ebx
     ea3:	5e                   	pop    %esi
     ea4:	5f                   	pop    %edi
     ea5:	5d                   	pop    %ebp
     ea6:	c3                   	ret    
     ea7:	89 f6                	mov    %esi,%esi
     ea9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      printf(1, "panic at thread_join\n");
     eb0:	83 ec 08             	sub    $0x8,%esp
     eb3:	68 09 19 00 00       	push   $0x1909
     eb8:	6a 01                	push   $0x1
     eba:	e8 61 06 00 00       	call   1520 <printf>
     ebf:	83 c4 10             	add    $0x10,%esp
}
     ec2:	8d 65 f4             	lea    -0xc(%ebp),%esp
      printf(1, "panic at thread_join\n");
     ec5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
     eca:	5b                   	pop    %ebx
     ecb:	5e                   	pop    %esi
     ecc:	5f                   	pop    %edi
     ecd:	5d                   	pop    %ebp
     ece:	c3                   	ret    
     ecf:	90                   	nop

00000ed0 <basictest>:
{
     ed0:	55                   	push   %ebp
     ed1:	89 e5                	mov    %esp,%ebp
     ed3:	56                   	push   %esi
     ed4:	53                   	push   %ebx
  for (i = 0; i < NUM_THREAD; i++){
     ed5:	31 db                	xor    %ebx,%ebx
{
     ed7:	83 ec 40             	sub    $0x40,%esp
     eda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if (thread_create(&threads[i], basicthreadmain, (void*)i) != 0){
     ee0:	8d 44 9d d0          	lea    -0x30(%ebp,%ebx,4),%eax
     ee4:	83 ec 04             	sub    $0x4,%esp
     ee7:	53                   	push   %ebx
     ee8:	68 10 02 00 00       	push   $0x210
     eed:	50                   	push   %eax
     eee:	e8 4f 05 00 00       	call   1442 <thread_create>
     ef3:	83 c4 10             	add    $0x10,%esp
     ef6:	85 c0                	test   %eax,%eax
     ef8:	89 c6                	mov    %eax,%esi
     efa:	75 54                	jne    f50 <basictest+0x80>
  for (i = 0; i < NUM_THREAD; i++){
     efc:	83 c3 01             	add    $0x1,%ebx
     eff:	83 fb 0a             	cmp    $0xa,%ebx
     f02:	75 dc                	jne    ee0 <basictest+0x10>
     f04:	8d 5d cc             	lea    -0x34(%ebp),%ebx
     f07:	89 f6                	mov    %esi,%esi
     f09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if (thread_join(threads[i], &retval) != 0 || (int)retval != i+1){
     f10:	83 ec 08             	sub    $0x8,%esp
     f13:	53                   	push   %ebx
     f14:	ff 74 b5 d0          	pushl  -0x30(%ebp,%esi,4)
     f18:	e8 2d 05 00 00       	call   144a <thread_join>
     f1d:	83 c4 10             	add    $0x10,%esp
     f20:	85 c0                	test   %eax,%eax
     f22:	75 4c                	jne    f70 <basictest+0xa0>
     f24:	83 c6 01             	add    $0x1,%esi
     f27:	39 75 cc             	cmp    %esi,-0x34(%ebp)
     f2a:	75 44                	jne    f70 <basictest+0xa0>
  for (i = 0; i < NUM_THREAD; i++){
     f2c:	83 fe 0a             	cmp    $0xa,%esi
     f2f:	75 df                	jne    f10 <basictest+0x40>
  printf(1,"\n");
     f31:	83 ec 08             	sub    $0x8,%esp
     f34:	89 45 c4             	mov    %eax,-0x3c(%ebp)
     f37:	68 07 19 00 00       	push   $0x1907
     f3c:	6a 01                	push   $0x1
     f3e:	e8 dd 05 00 00       	call   1520 <printf>
  return 0;
     f43:	8b 45 c4             	mov    -0x3c(%ebp),%eax
     f46:	83 c4 10             	add    $0x10,%esp
}
     f49:	8d 65 f8             	lea    -0x8(%ebp),%esp
     f4c:	5b                   	pop    %ebx
     f4d:	5e                   	pop    %esi
     f4e:	5d                   	pop    %ebp
     f4f:	c3                   	ret    
      printf(1, "panic at thread_create\n");
     f50:	83 ec 08             	sub    $0x8,%esp
     f53:	68 e1 18 00 00       	push   $0x18e1
     f58:	6a 01                	push   $0x1
     f5a:	e8 c1 05 00 00       	call   1520 <printf>
      return -1;
     f5f:	83 c4 10             	add    $0x10,%esp
}
     f62:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return -1;
     f65:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
     f6a:	5b                   	pop    %ebx
     f6b:	5e                   	pop    %esi
     f6c:	5d                   	pop    %ebp
     f6d:	c3                   	ret    
     f6e:	66 90                	xchg   %ax,%ax
      printf(1, "panic at thread_join\n");
     f70:	83 ec 08             	sub    $0x8,%esp
     f73:	68 09 19 00 00       	push   $0x1909
     f78:	6a 01                	push   $0x1
     f7a:	e8 a1 05 00 00       	call   1520 <printf>
     f7f:	83 c4 10             	add    $0x10,%esp
}
     f82:	8d 65 f8             	lea    -0x8(%ebp),%esp
      printf(1, "panic at thread_join\n");
     f85:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
     f8a:	5b                   	pop    %ebx
     f8b:	5e                   	pop    %esi
     f8c:	5d                   	pop    %ebp
     f8d:	c3                   	ret    
     f8e:	66 90                	xchg   %ax,%ax

00000f90 <exectest>:
{
     f90:	55                   	push   %ebp
     f91:	89 e5                	mov    %esp,%ebp
     f93:	57                   	push   %edi
     f94:	56                   	push   %esi
     f95:	8d 75 c0             	lea    -0x40(%ebp),%esi
     f98:	53                   	push   %ebx
     f99:	8d 7d e8             	lea    -0x18(%ebp),%edi
     f9c:	83 ec 4c             	sub    $0x4c,%esp
     f9f:	89 f3                	mov    %esi,%ebx
     fa1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if (thread_create(&threads[i], execthreadmain, (void*)0) != 0){
     fa8:	83 ec 04             	sub    $0x4,%esp
     fab:	6a 00                	push   $0x0
     fad:	68 c0 06 00 00       	push   $0x6c0
     fb2:	53                   	push   %ebx
     fb3:	e8 8a 04 00 00       	call   1442 <thread_create>
     fb8:	83 c4 10             	add    $0x10,%esp
     fbb:	85 c0                	test   %eax,%eax
     fbd:	75 51                	jne    1010 <exectest+0x80>
     fbf:	83 c3 04             	add    $0x4,%ebx
  for (i = 0; i < NUM_THREAD; i++){
     fc2:	39 fb                	cmp    %edi,%ebx
     fc4:	75 e2                	jne    fa8 <exectest+0x18>
     fc6:	8d 7d bc             	lea    -0x44(%ebp),%edi
     fc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if (thread_join(threads[i], &retval) != 0){
     fd0:	83 ec 08             	sub    $0x8,%esp
     fd3:	57                   	push   %edi
     fd4:	ff 36                	pushl  (%esi)
     fd6:	e8 6f 04 00 00       	call   144a <thread_join>
     fdb:	83 c4 10             	add    $0x10,%esp
     fde:	85 c0                	test   %eax,%eax
     fe0:	75 4e                	jne    1030 <exectest+0xa0>
     fe2:	83 c6 04             	add    $0x4,%esi
  for (i = 0; i < NUM_THREAD; i++){
     fe5:	39 de                	cmp    %ebx,%esi
     fe7:	75 e7                	jne    fd0 <exectest+0x40>
  printf(1, "panic at exectest\n");
     fe9:	83 ec 08             	sub    $0x8,%esp
     fec:	89 45 b4             	mov    %eax,-0x4c(%ebp)
     fef:	68 07 1a 00 00       	push   $0x1a07
     ff4:	6a 01                	push   $0x1
     ff6:	e8 25 05 00 00       	call   1520 <printf>
  return 0;
     ffb:	8b 45 b4             	mov    -0x4c(%ebp),%eax
     ffe:	83 c4 10             	add    $0x10,%esp
}
    1001:	8d 65 f4             	lea    -0xc(%ebp),%esp
    1004:	5b                   	pop    %ebx
    1005:	5e                   	pop    %esi
    1006:	5f                   	pop    %edi
    1007:	5d                   	pop    %ebp
    1008:	c3                   	ret    
    1009:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      printf(1, "panic at thread_create\n");
    1010:	83 ec 08             	sub    $0x8,%esp
    1013:	68 e1 18 00 00       	push   $0x18e1
    1018:	6a 01                	push   $0x1
    101a:	e8 01 05 00 00       	call   1520 <printf>
      return -1;
    101f:	83 c4 10             	add    $0x10,%esp
}
    1022:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
    1025:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
    102a:	5b                   	pop    %ebx
    102b:	5e                   	pop    %esi
    102c:	5f                   	pop    %edi
    102d:	5d                   	pop    %ebp
    102e:	c3                   	ret    
    102f:	90                   	nop
      printf(1, "panic at thread_join\n");
    1030:	83 ec 08             	sub    $0x8,%esp
    1033:	68 09 19 00 00       	push   $0x1909
    1038:	6a 01                	push   $0x1
    103a:	e8 e1 04 00 00       	call   1520 <printf>
    103f:	83 c4 10             	add    $0x10,%esp
}
    1042:	8d 65 f4             	lea    -0xc(%ebp),%esp
      printf(1, "panic at thread_join\n");
    1045:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
    104a:	5b                   	pop    %ebx
    104b:	5e                   	pop    %esi
    104c:	5f                   	pop    %edi
    104d:	5d                   	pop    %ebp
    104e:	c3                   	ret    
    104f:	90                   	nop

00001050 <racingtest>:
{
    1050:	55                   	push   %ebp
    1051:	89 e5                	mov    %esp,%ebp
    1053:	56                   	push   %esi
    1054:	53                   	push   %ebx
  for (i = 0; i < NUM_THREAD; i++){
    1055:	31 db                	xor    %ebx,%ebx
{
    1057:	83 ec 40             	sub    $0x40,%esp
  gcnt = 0;
    105a:	c7 05 64 23 00 00 00 	movl   $0x0,0x2364
    1061:	00 00 00 
    1064:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if (thread_create(&threads[i], racingthreadmain, (void*)i) != 0){
    1068:	8d 44 9d d0          	lea    -0x30(%ebp,%ebx,4),%eax
    106c:	83 ec 04             	sub    $0x4,%esp
    106f:	53                   	push   %ebx
    1070:	68 d0 01 00 00       	push   $0x1d0
    1075:	50                   	push   %eax
    1076:	e8 c7 03 00 00       	call   1442 <thread_create>
    107b:	83 c4 10             	add    $0x10,%esp
    107e:	85 c0                	test   %eax,%eax
    1080:	89 c6                	mov    %eax,%esi
    1082:	75 5c                	jne    10e0 <racingtest+0x90>
  for (i = 0; i < NUM_THREAD; i++){
    1084:	83 c3 01             	add    $0x1,%ebx
    1087:	83 fb 0a             	cmp    $0xa,%ebx
    108a:	75 dc                	jne    1068 <racingtest+0x18>
    108c:	8d 5d cc             	lea    -0x34(%ebp),%ebx
    108f:	90                   	nop
    if (thread_join(threads[i], &retval) != 0 || (int)retval != i+1){
    1090:	83 ec 08             	sub    $0x8,%esp
    1093:	53                   	push   %ebx
    1094:	ff 74 b5 d0          	pushl  -0x30(%ebp,%esi,4)
    1098:	e8 ad 03 00 00       	call   144a <thread_join>
    109d:	83 c4 10             	add    $0x10,%esp
    10a0:	85 c0                	test   %eax,%eax
    10a2:	75 5c                	jne    1100 <racingtest+0xb0>
    10a4:	83 c6 01             	add    $0x1,%esi
    10a7:	39 75 cc             	cmp    %esi,-0x34(%ebp)
    10aa:	75 54                	jne    1100 <racingtest+0xb0>
  for (i = 0; i < NUM_THREAD; i++){
    10ac:	83 fe 0a             	cmp    $0xa,%esi
    10af:	75 df                	jne    1090 <racingtest+0x40>
  printf(1,"%d\n", gcnt);
    10b1:	8b 15 64 23 00 00    	mov    0x2364,%edx
    10b7:	83 ec 04             	sub    $0x4,%esp
    10ba:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    10bd:	52                   	push   %edx
    10be:	68 e6 19 00 00       	push   $0x19e6
    10c3:	6a 01                	push   $0x1
    10c5:	e8 56 04 00 00       	call   1520 <printf>
  return 0;
    10ca:	8b 45 c4             	mov    -0x3c(%ebp),%eax
    10cd:	83 c4 10             	add    $0x10,%esp
}
    10d0:	8d 65 f8             	lea    -0x8(%ebp),%esp
    10d3:	5b                   	pop    %ebx
    10d4:	5e                   	pop    %esi
    10d5:	5d                   	pop    %ebp
    10d6:	c3                   	ret    
    10d7:	89 f6                	mov    %esi,%esi
    10d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      printf(1, "panic at thread_create\n");
    10e0:	83 ec 08             	sub    $0x8,%esp
    10e3:	68 e1 18 00 00       	push   $0x18e1
    10e8:	6a 01                	push   $0x1
    10ea:	e8 31 04 00 00       	call   1520 <printf>
      return -1;
    10ef:	83 c4 10             	add    $0x10,%esp
}
    10f2:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return -1;
    10f5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
    10fa:	5b                   	pop    %ebx
    10fb:	5e                   	pop    %esi
    10fc:	5d                   	pop    %ebp
    10fd:	c3                   	ret    
    10fe:	66 90                	xchg   %ax,%ax
      printf(1, "panic at thread_join\n");
    1100:	83 ec 08             	sub    $0x8,%esp
    1103:	68 09 19 00 00       	push   $0x1909
    1108:	6a 01                	push   $0x1
    110a:	e8 11 04 00 00       	call   1520 <printf>
    110f:	83 c4 10             	add    $0x10,%esp
}
    1112:	8d 65 f8             	lea    -0x8(%ebp),%esp
      printf(1, "panic at thread_join\n");
    1115:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
    111a:	5b                   	pop    %ebx
    111b:	5e                   	pop    %esi
    111c:	5d                   	pop    %ebp
    111d:	c3                   	ret    
    111e:	66 90                	xchg   %ax,%ax

00001120 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
    1120:	55                   	push   %ebp
    1121:	89 e5                	mov    %esp,%ebp
    1123:	53                   	push   %ebx
    1124:	8b 45 08             	mov    0x8(%ebp),%eax
    1127:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
    112a:	89 c2                	mov    %eax,%edx
    112c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    1130:	83 c1 01             	add    $0x1,%ecx
    1133:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
    1137:	83 c2 01             	add    $0x1,%edx
    113a:	84 db                	test   %bl,%bl
    113c:	88 5a ff             	mov    %bl,-0x1(%edx)
    113f:	75 ef                	jne    1130 <strcpy+0x10>
    ;
  return os;
}
    1141:	5b                   	pop    %ebx
    1142:	5d                   	pop    %ebp
    1143:	c3                   	ret    
    1144:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    114a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00001150 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    1150:	55                   	push   %ebp
    1151:	89 e5                	mov    %esp,%ebp
    1153:	53                   	push   %ebx
    1154:	8b 55 08             	mov    0x8(%ebp),%edx
    1157:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
    115a:	0f b6 02             	movzbl (%edx),%eax
    115d:	0f b6 19             	movzbl (%ecx),%ebx
    1160:	84 c0                	test   %al,%al
    1162:	75 1c                	jne    1180 <strcmp+0x30>
    1164:	eb 2a                	jmp    1190 <strcmp+0x40>
    1166:	8d 76 00             	lea    0x0(%esi),%esi
    1169:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    p++, q++;
    1170:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
    1173:	0f b6 02             	movzbl (%edx),%eax
    p++, q++;
    1176:	83 c1 01             	add    $0x1,%ecx
    1179:	0f b6 19             	movzbl (%ecx),%ebx
  while(*p && *p == *q)
    117c:	84 c0                	test   %al,%al
    117e:	74 10                	je     1190 <strcmp+0x40>
    1180:	38 d8                	cmp    %bl,%al
    1182:	74 ec                	je     1170 <strcmp+0x20>
  return (uchar)*p - (uchar)*q;
    1184:	29 d8                	sub    %ebx,%eax
}
    1186:	5b                   	pop    %ebx
    1187:	5d                   	pop    %ebp
    1188:	c3                   	ret    
    1189:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    1190:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
    1192:	29 d8                	sub    %ebx,%eax
}
    1194:	5b                   	pop    %ebx
    1195:	5d                   	pop    %ebp
    1196:	c3                   	ret    
    1197:	89 f6                	mov    %esi,%esi
    1199:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000011a0 <strlen>:

uint
strlen(const char *s)
{
    11a0:	55                   	push   %ebp
    11a1:	89 e5                	mov    %esp,%ebp
    11a3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
    11a6:	80 39 00             	cmpb   $0x0,(%ecx)
    11a9:	74 15                	je     11c0 <strlen+0x20>
    11ab:	31 d2                	xor    %edx,%edx
    11ad:	8d 76 00             	lea    0x0(%esi),%esi
    11b0:	83 c2 01             	add    $0x1,%edx
    11b3:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
    11b7:	89 d0                	mov    %edx,%eax
    11b9:	75 f5                	jne    11b0 <strlen+0x10>
    ;
  return n;
}
    11bb:	5d                   	pop    %ebp
    11bc:	c3                   	ret    
    11bd:	8d 76 00             	lea    0x0(%esi),%esi
  for(n = 0; s[n]; n++)
    11c0:	31 c0                	xor    %eax,%eax
}
    11c2:	5d                   	pop    %ebp
    11c3:	c3                   	ret    
    11c4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    11ca:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

000011d0 <memset>:

void*
memset(void *dst, int c, uint n)
{
    11d0:	55                   	push   %ebp
    11d1:	89 e5                	mov    %esp,%ebp
    11d3:	57                   	push   %edi
    11d4:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
    11d7:	8b 4d 10             	mov    0x10(%ebp),%ecx
    11da:	8b 45 0c             	mov    0xc(%ebp),%eax
    11dd:	89 d7                	mov    %edx,%edi
    11df:	fc                   	cld    
    11e0:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
    11e2:	89 d0                	mov    %edx,%eax
    11e4:	5f                   	pop    %edi
    11e5:	5d                   	pop    %ebp
    11e6:	c3                   	ret    
    11e7:	89 f6                	mov    %esi,%esi
    11e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000011f0 <strchr>:

char*
strchr(const char *s, char c)
{
    11f0:	55                   	push   %ebp
    11f1:	89 e5                	mov    %esp,%ebp
    11f3:	53                   	push   %ebx
    11f4:	8b 45 08             	mov    0x8(%ebp),%eax
    11f7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  for(; *s; s++)
    11fa:	0f b6 10             	movzbl (%eax),%edx
    11fd:	84 d2                	test   %dl,%dl
    11ff:	74 1d                	je     121e <strchr+0x2e>
    if(*s == c)
    1201:	38 d3                	cmp    %dl,%bl
    1203:	89 d9                	mov    %ebx,%ecx
    1205:	75 0d                	jne    1214 <strchr+0x24>
    1207:	eb 17                	jmp    1220 <strchr+0x30>
    1209:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    1210:	38 ca                	cmp    %cl,%dl
    1212:	74 0c                	je     1220 <strchr+0x30>
  for(; *s; s++)
    1214:	83 c0 01             	add    $0x1,%eax
    1217:	0f b6 10             	movzbl (%eax),%edx
    121a:	84 d2                	test   %dl,%dl
    121c:	75 f2                	jne    1210 <strchr+0x20>
      return (char*)s;
  return 0;
    121e:	31 c0                	xor    %eax,%eax
}
    1220:	5b                   	pop    %ebx
    1221:	5d                   	pop    %ebp
    1222:	c3                   	ret    
    1223:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    1229:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00001230 <gets>:

char*
gets(char *buf, int max)
{
    1230:	55                   	push   %ebp
    1231:	89 e5                	mov    %esp,%ebp
    1233:	57                   	push   %edi
    1234:	56                   	push   %esi
    1235:	53                   	push   %ebx
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    1236:	31 f6                	xor    %esi,%esi
    1238:	89 f3                	mov    %esi,%ebx
{
    123a:	83 ec 1c             	sub    $0x1c,%esp
    123d:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i=0; i+1 < max; ){
    1240:	eb 2f                	jmp    1271 <gets+0x41>
    1242:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cc = read(0, &c, 1);
    1248:	8d 45 e7             	lea    -0x19(%ebp),%eax
    124b:	83 ec 04             	sub    $0x4,%esp
    124e:	6a 01                	push   $0x1
    1250:	50                   	push   %eax
    1251:	6a 00                	push   $0x0
    1253:	e8 32 01 00 00       	call   138a <read>
    if(cc < 1)
    1258:	83 c4 10             	add    $0x10,%esp
    125b:	85 c0                	test   %eax,%eax
    125d:	7e 1c                	jle    127b <gets+0x4b>
      break;
    buf[i++] = c;
    125f:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
    1263:	83 c7 01             	add    $0x1,%edi
    1266:	88 47 ff             	mov    %al,-0x1(%edi)
    if(c == '\n' || c == '\r')
    1269:	3c 0a                	cmp    $0xa,%al
    126b:	74 23                	je     1290 <gets+0x60>
    126d:	3c 0d                	cmp    $0xd,%al
    126f:	74 1f                	je     1290 <gets+0x60>
  for(i=0; i+1 < max; ){
    1271:	83 c3 01             	add    $0x1,%ebx
    1274:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
    1277:	89 fe                	mov    %edi,%esi
    1279:	7c cd                	jl     1248 <gets+0x18>
    127b:	89 f3                	mov    %esi,%ebx
      break;
  }
  buf[i] = '\0';
  return buf;
}
    127d:	8b 45 08             	mov    0x8(%ebp),%eax
  buf[i] = '\0';
    1280:	c6 03 00             	movb   $0x0,(%ebx)
}
    1283:	8d 65 f4             	lea    -0xc(%ebp),%esp
    1286:	5b                   	pop    %ebx
    1287:	5e                   	pop    %esi
    1288:	5f                   	pop    %edi
    1289:	5d                   	pop    %ebp
    128a:	c3                   	ret    
    128b:	90                   	nop
    128c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    1290:	8b 75 08             	mov    0x8(%ebp),%esi
    1293:	8b 45 08             	mov    0x8(%ebp),%eax
    1296:	01 de                	add    %ebx,%esi
    1298:	89 f3                	mov    %esi,%ebx
  buf[i] = '\0';
    129a:	c6 03 00             	movb   $0x0,(%ebx)
}
    129d:	8d 65 f4             	lea    -0xc(%ebp),%esp
    12a0:	5b                   	pop    %ebx
    12a1:	5e                   	pop    %esi
    12a2:	5f                   	pop    %edi
    12a3:	5d                   	pop    %ebp
    12a4:	c3                   	ret    
    12a5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    12a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000012b0 <stat>:

int
stat(const char *n, struct stat *st)
{
    12b0:	55                   	push   %ebp
    12b1:	89 e5                	mov    %esp,%ebp
    12b3:	56                   	push   %esi
    12b4:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    12b5:	83 ec 08             	sub    $0x8,%esp
    12b8:	6a 00                	push   $0x0
    12ba:	ff 75 08             	pushl  0x8(%ebp)
    12bd:	e8 f0 00 00 00       	call   13b2 <open>
  if(fd < 0)
    12c2:	83 c4 10             	add    $0x10,%esp
    12c5:	85 c0                	test   %eax,%eax
    12c7:	78 27                	js     12f0 <stat+0x40>
    return -1;
  r = fstat(fd, st);
    12c9:	83 ec 08             	sub    $0x8,%esp
    12cc:	ff 75 0c             	pushl  0xc(%ebp)
    12cf:	89 c3                	mov    %eax,%ebx
    12d1:	50                   	push   %eax
    12d2:	e8 f3 00 00 00       	call   13ca <fstat>
  close(fd);
    12d7:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
    12da:	89 c6                	mov    %eax,%esi
  close(fd);
    12dc:	e8 b9 00 00 00       	call   139a <close>
  return r;
    12e1:	83 c4 10             	add    $0x10,%esp
}
    12e4:	8d 65 f8             	lea    -0x8(%ebp),%esp
    12e7:	89 f0                	mov    %esi,%eax
    12e9:	5b                   	pop    %ebx
    12ea:	5e                   	pop    %esi
    12eb:	5d                   	pop    %ebp
    12ec:	c3                   	ret    
    12ed:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
    12f0:	be ff ff ff ff       	mov    $0xffffffff,%esi
    12f5:	eb ed                	jmp    12e4 <stat+0x34>
    12f7:	89 f6                	mov    %esi,%esi
    12f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00001300 <atoi>:

int
atoi(const char *s)
{
    1300:	55                   	push   %ebp
    1301:	89 e5                	mov    %esp,%ebp
    1303:	53                   	push   %ebx
    1304:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    1307:	0f be 11             	movsbl (%ecx),%edx
    130a:	8d 42 d0             	lea    -0x30(%edx),%eax
    130d:	3c 09                	cmp    $0x9,%al
  n = 0;
    130f:	b8 00 00 00 00       	mov    $0x0,%eax
  while('0' <= *s && *s <= '9')
    1314:	77 1f                	ja     1335 <atoi+0x35>
    1316:	8d 76 00             	lea    0x0(%esi),%esi
    1319:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    n = n*10 + *s++ - '0';
    1320:	8d 04 80             	lea    (%eax,%eax,4),%eax
    1323:	83 c1 01             	add    $0x1,%ecx
    1326:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
  while('0' <= *s && *s <= '9')
    132a:	0f be 11             	movsbl (%ecx),%edx
    132d:	8d 5a d0             	lea    -0x30(%edx),%ebx
    1330:	80 fb 09             	cmp    $0x9,%bl
    1333:	76 eb                	jbe    1320 <atoi+0x20>
  return n;
}
    1335:	5b                   	pop    %ebx
    1336:	5d                   	pop    %ebp
    1337:	c3                   	ret    
    1338:	90                   	nop
    1339:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00001340 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
    1340:	55                   	push   %ebp
    1341:	89 e5                	mov    %esp,%ebp
    1343:	56                   	push   %esi
    1344:	53                   	push   %ebx
    1345:	8b 5d 10             	mov    0x10(%ebp),%ebx
    1348:	8b 45 08             	mov    0x8(%ebp),%eax
    134b:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    134e:	85 db                	test   %ebx,%ebx
    1350:	7e 14                	jle    1366 <memmove+0x26>
    1352:	31 d2                	xor    %edx,%edx
    1354:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *dst++ = *src++;
    1358:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
    135c:	88 0c 10             	mov    %cl,(%eax,%edx,1)
    135f:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0)
    1362:	39 d3                	cmp    %edx,%ebx
    1364:	75 f2                	jne    1358 <memmove+0x18>
  return vdst;
}
    1366:	5b                   	pop    %ebx
    1367:	5e                   	pop    %esi
    1368:	5d                   	pop    %ebp
    1369:	c3                   	ret    

0000136a <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
    136a:	b8 01 00 00 00       	mov    $0x1,%eax
    136f:	cd 40                	int    $0x40
    1371:	c3                   	ret    

00001372 <exit>:
SYSCALL(exit)
    1372:	b8 02 00 00 00       	mov    $0x2,%eax
    1377:	cd 40                	int    $0x40
    1379:	c3                   	ret    

0000137a <wait>:
SYSCALL(wait)
    137a:	b8 03 00 00 00       	mov    $0x3,%eax
    137f:	cd 40                	int    $0x40
    1381:	c3                   	ret    

00001382 <pipe>:
SYSCALL(pipe)
    1382:	b8 04 00 00 00       	mov    $0x4,%eax
    1387:	cd 40                	int    $0x40
    1389:	c3                   	ret    

0000138a <read>:
SYSCALL(read)
    138a:	b8 05 00 00 00       	mov    $0x5,%eax
    138f:	cd 40                	int    $0x40
    1391:	c3                   	ret    

00001392 <write>:
SYSCALL(write)
    1392:	b8 10 00 00 00       	mov    $0x10,%eax
    1397:	cd 40                	int    $0x40
    1399:	c3                   	ret    

0000139a <close>:
SYSCALL(close)
    139a:	b8 15 00 00 00       	mov    $0x15,%eax
    139f:	cd 40                	int    $0x40
    13a1:	c3                   	ret    

000013a2 <kill>:
SYSCALL(kill)
    13a2:	b8 06 00 00 00       	mov    $0x6,%eax
    13a7:	cd 40                	int    $0x40
    13a9:	c3                   	ret    

000013aa <exec>:
SYSCALL(exec)
    13aa:	b8 07 00 00 00       	mov    $0x7,%eax
    13af:	cd 40                	int    $0x40
    13b1:	c3                   	ret    

000013b2 <open>:
SYSCALL(open)
    13b2:	b8 0f 00 00 00       	mov    $0xf,%eax
    13b7:	cd 40                	int    $0x40
    13b9:	c3                   	ret    

000013ba <mknod>:
SYSCALL(mknod)
    13ba:	b8 11 00 00 00       	mov    $0x11,%eax
    13bf:	cd 40                	int    $0x40
    13c1:	c3                   	ret    

000013c2 <unlink>:
SYSCALL(unlink)
    13c2:	b8 12 00 00 00       	mov    $0x12,%eax
    13c7:	cd 40                	int    $0x40
    13c9:	c3                   	ret    

000013ca <fstat>:
SYSCALL(fstat)
    13ca:	b8 08 00 00 00       	mov    $0x8,%eax
    13cf:	cd 40                	int    $0x40
    13d1:	c3                   	ret    

000013d2 <link>:
SYSCALL(link)
    13d2:	b8 13 00 00 00       	mov    $0x13,%eax
    13d7:	cd 40                	int    $0x40
    13d9:	c3                   	ret    

000013da <mkdir>:
SYSCALL(mkdir)
    13da:	b8 14 00 00 00       	mov    $0x14,%eax
    13df:	cd 40                	int    $0x40
    13e1:	c3                   	ret    

000013e2 <chdir>:
SYSCALL(chdir)
    13e2:	b8 09 00 00 00       	mov    $0x9,%eax
    13e7:	cd 40                	int    $0x40
    13e9:	c3                   	ret    

000013ea <dup>:
SYSCALL(dup)
    13ea:	b8 0a 00 00 00       	mov    $0xa,%eax
    13ef:	cd 40                	int    $0x40
    13f1:	c3                   	ret    

000013f2 <getpid>:
SYSCALL(getpid)
    13f2:	b8 0b 00 00 00       	mov    $0xb,%eax
    13f7:	cd 40                	int    $0x40
    13f9:	c3                   	ret    

000013fa <sbrk>:
SYSCALL(sbrk)
    13fa:	b8 0c 00 00 00       	mov    $0xc,%eax
    13ff:	cd 40                	int    $0x40
    1401:	c3                   	ret    

00001402 <sleep>:
SYSCALL(sleep)
    1402:	b8 0d 00 00 00       	mov    $0xd,%eax
    1407:	cd 40                	int    $0x40
    1409:	c3                   	ret    

0000140a <uptime>:
SYSCALL(uptime)
    140a:	b8 0e 00 00 00       	mov    $0xe,%eax
    140f:	cd 40                	int    $0x40
    1411:	c3                   	ret    

00001412 <myfunction>:
SYSCALL(myfunction)
    1412:	b8 16 00 00 00       	mov    $0x16,%eax
    1417:	cd 40                	int    $0x40
    1419:	c3                   	ret    

0000141a <getppid>:
SYSCALL(getppid)
    141a:	b8 17 00 00 00       	mov    $0x17,%eax
    141f:	cd 40                	int    $0x40
    1421:	c3                   	ret    

00001422 <yield>:
SYSCALL(yield)
    1422:	b8 18 00 00 00       	mov    $0x18,%eax
    1427:	cd 40                	int    $0x40
    1429:	c3                   	ret    

0000142a <getlev>:
SYSCALL(getlev)
    142a:	b8 19 00 00 00       	mov    $0x19,%eax
    142f:	cd 40                	int    $0x40
    1431:	c3                   	ret    

00001432 <set_cpu_share>:
SYSCALL(set_cpu_share)
    1432:	b8 1a 00 00 00       	mov    $0x1a,%eax
    1437:	cd 40                	int    $0x40
    1439:	c3                   	ret    

0000143a <thread_exit>:
SYSCALL(thread_exit)
    143a:	b8 1d 00 00 00       	mov    $0x1d,%eax
    143f:	cd 40                	int    $0x40
    1441:	c3                   	ret    

00001442 <thread_create>:
SYSCALL(thread_create)
    1442:	b8 1b 00 00 00       	mov    $0x1b,%eax
    1447:	cd 40                	int    $0x40
    1449:	c3                   	ret    

0000144a <thread_join>:
SYSCALL(thread_join)
    144a:	b8 1c 00 00 00       	mov    $0x1c,%eax
    144f:	cd 40                	int    $0x40
    1451:	c3                   	ret    

00001452 <pread>:
SYSCALL(pread)
    1452:	b8 1e 00 00 00       	mov    $0x1e,%eax
    1457:	cd 40                	int    $0x40
    1459:	c3                   	ret    

0000145a <pwrite>:
SYSCALL(pwrite)
    145a:	b8 1f 00 00 00       	mov    $0x1f,%eax
    145f:	cd 40                	int    $0x40
    1461:	c3                   	ret    

00001462 <sync>:
SYSCALL(sync)
    1462:	b8 20 00 00 00       	mov    $0x20,%eax
    1467:	cd 40                	int    $0x40
    1469:	c3                   	ret    

0000146a <get_log_num>:
SYSCALL(get_log_num)
    146a:	b8 21 00 00 00       	mov    $0x21,%eax
    146f:	cd 40                	int    $0x40
    1471:	c3                   	ret    
    1472:	66 90                	xchg   %ax,%ax
    1474:	66 90                	xchg   %ax,%ax
    1476:	66 90                	xchg   %ax,%ax
    1478:	66 90                	xchg   %ax,%ax
    147a:	66 90                	xchg   %ax,%ax
    147c:	66 90                	xchg   %ax,%ax
    147e:	66 90                	xchg   %ax,%ax

00001480 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
    1480:	55                   	push   %ebp
    1481:	89 e5                	mov    %esp,%ebp
    1483:	57                   	push   %edi
    1484:	56                   	push   %esi
    1485:	53                   	push   %ebx
    1486:	83 ec 3c             	sub    $0x3c,%esp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    1489:	85 d2                	test   %edx,%edx
{
    148b:	89 45 c0             	mov    %eax,-0x40(%ebp)
    neg = 1;
    x = -xx;
    148e:	89 d0                	mov    %edx,%eax
  if(sgn && xx < 0){
    1490:	79 76                	jns    1508 <printint+0x88>
    1492:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
    1496:	74 70                	je     1508 <printint+0x88>
    x = -xx;
    1498:	f7 d8                	neg    %eax
    neg = 1;
    149a:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
    14a1:	31 f6                	xor    %esi,%esi
    14a3:	8d 5d d7             	lea    -0x29(%ebp),%ebx
    14a6:	eb 0a                	jmp    14b2 <printint+0x32>
    14a8:	90                   	nop
    14a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  do{
    buf[i++] = digits[x % base];
    14b0:	89 fe                	mov    %edi,%esi
    14b2:	31 d2                	xor    %edx,%edx
    14b4:	8d 7e 01             	lea    0x1(%esi),%edi
    14b7:	f7 f1                	div    %ecx
    14b9:	0f b6 92 18 1b 00 00 	movzbl 0x1b18(%edx),%edx
  }while((x /= base) != 0);
    14c0:	85 c0                	test   %eax,%eax
    buf[i++] = digits[x % base];
    14c2:	88 14 3b             	mov    %dl,(%ebx,%edi,1)
  }while((x /= base) != 0);
    14c5:	75 e9                	jne    14b0 <printint+0x30>
  if(neg)
    14c7:	8b 45 c4             	mov    -0x3c(%ebp),%eax
    14ca:	85 c0                	test   %eax,%eax
    14cc:	74 08                	je     14d6 <printint+0x56>
    buf[i++] = '-';
    14ce:	c6 44 3d d8 2d       	movb   $0x2d,-0x28(%ebp,%edi,1)
    14d3:	8d 7e 02             	lea    0x2(%esi),%edi
    14d6:	8d 74 3d d7          	lea    -0x29(%ebp,%edi,1),%esi
    14da:	8b 7d c0             	mov    -0x40(%ebp),%edi
    14dd:	8d 76 00             	lea    0x0(%esi),%esi
    14e0:	0f b6 06             	movzbl (%esi),%eax
  write(fd, &c, 1);
    14e3:	83 ec 04             	sub    $0x4,%esp
    14e6:	83 ee 01             	sub    $0x1,%esi
    14e9:	6a 01                	push   $0x1
    14eb:	53                   	push   %ebx
    14ec:	57                   	push   %edi
    14ed:	88 45 d7             	mov    %al,-0x29(%ebp)
    14f0:	e8 9d fe ff ff       	call   1392 <write>

  while(--i >= 0)
    14f5:	83 c4 10             	add    $0x10,%esp
    14f8:	39 de                	cmp    %ebx,%esi
    14fa:	75 e4                	jne    14e0 <printint+0x60>
    putc(fd, buf[i]);
}
    14fc:	8d 65 f4             	lea    -0xc(%ebp),%esp
    14ff:	5b                   	pop    %ebx
    1500:	5e                   	pop    %esi
    1501:	5f                   	pop    %edi
    1502:	5d                   	pop    %ebp
    1503:	c3                   	ret    
    1504:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
    1508:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
    150f:	eb 90                	jmp    14a1 <printint+0x21>
    1511:	eb 0d                	jmp    1520 <printf>
    1513:	90                   	nop
    1514:	90                   	nop
    1515:	90                   	nop
    1516:	90                   	nop
    1517:	90                   	nop
    1518:	90                   	nop
    1519:	90                   	nop
    151a:	90                   	nop
    151b:	90                   	nop
    151c:	90                   	nop
    151d:	90                   	nop
    151e:	90                   	nop
    151f:	90                   	nop

00001520 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
    1520:	55                   	push   %ebp
    1521:	89 e5                	mov    %esp,%ebp
    1523:	57                   	push   %edi
    1524:	56                   	push   %esi
    1525:	53                   	push   %ebx
    1526:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    1529:	8b 75 0c             	mov    0xc(%ebp),%esi
    152c:	0f b6 1e             	movzbl (%esi),%ebx
    152f:	84 db                	test   %bl,%bl
    1531:	0f 84 b3 00 00 00    	je     15ea <printf+0xca>
  ap = (uint*)(void*)&fmt + 1;
    1537:	8d 45 10             	lea    0x10(%ebp),%eax
    153a:	83 c6 01             	add    $0x1,%esi
  state = 0;
    153d:	31 ff                	xor    %edi,%edi
  ap = (uint*)(void*)&fmt + 1;
    153f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    1542:	eb 2f                	jmp    1573 <printf+0x53>
    1544:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
    1548:	83 f8 25             	cmp    $0x25,%eax
    154b:	0f 84 a7 00 00 00    	je     15f8 <printf+0xd8>
  write(fd, &c, 1);
    1551:	8d 45 e2             	lea    -0x1e(%ebp),%eax
    1554:	83 ec 04             	sub    $0x4,%esp
    1557:	88 5d e2             	mov    %bl,-0x1e(%ebp)
    155a:	6a 01                	push   $0x1
    155c:	50                   	push   %eax
    155d:	ff 75 08             	pushl  0x8(%ebp)
    1560:	e8 2d fe ff ff       	call   1392 <write>
    1565:	83 c4 10             	add    $0x10,%esp
    1568:	83 c6 01             	add    $0x1,%esi
  for(i = 0; fmt[i]; i++){
    156b:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
    156f:	84 db                	test   %bl,%bl
    1571:	74 77                	je     15ea <printf+0xca>
    if(state == 0){
    1573:	85 ff                	test   %edi,%edi
    c = fmt[i] & 0xff;
    1575:	0f be cb             	movsbl %bl,%ecx
    1578:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
    157b:	74 cb                	je     1548 <printf+0x28>
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
    157d:	83 ff 25             	cmp    $0x25,%edi
    1580:	75 e6                	jne    1568 <printf+0x48>
      if(c == 'd'){
    1582:	83 f8 64             	cmp    $0x64,%eax
    1585:	0f 84 05 01 00 00    	je     1690 <printf+0x170>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
    158b:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
    1591:	83 f9 70             	cmp    $0x70,%ecx
    1594:	74 72                	je     1608 <printf+0xe8>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
    1596:	83 f8 73             	cmp    $0x73,%eax
    1599:	0f 84 99 00 00 00    	je     1638 <printf+0x118>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    159f:	83 f8 63             	cmp    $0x63,%eax
    15a2:	0f 84 08 01 00 00    	je     16b0 <printf+0x190>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
    15a8:	83 f8 25             	cmp    $0x25,%eax
    15ab:	0f 84 ef 00 00 00    	je     16a0 <printf+0x180>
  write(fd, &c, 1);
    15b1:	8d 45 e7             	lea    -0x19(%ebp),%eax
    15b4:	83 ec 04             	sub    $0x4,%esp
    15b7:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
    15bb:	6a 01                	push   $0x1
    15bd:	50                   	push   %eax
    15be:	ff 75 08             	pushl  0x8(%ebp)
    15c1:	e8 cc fd ff ff       	call   1392 <write>
    15c6:	83 c4 0c             	add    $0xc,%esp
    15c9:	8d 45 e6             	lea    -0x1a(%ebp),%eax
    15cc:	88 5d e6             	mov    %bl,-0x1a(%ebp)
    15cf:	6a 01                	push   $0x1
    15d1:	50                   	push   %eax
    15d2:	ff 75 08             	pushl  0x8(%ebp)
    15d5:	83 c6 01             	add    $0x1,%esi
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
    15d8:	31 ff                	xor    %edi,%edi
  write(fd, &c, 1);
    15da:	e8 b3 fd ff ff       	call   1392 <write>
  for(i = 0; fmt[i]; i++){
    15df:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
  write(fd, &c, 1);
    15e3:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
    15e6:	84 db                	test   %bl,%bl
    15e8:	75 89                	jne    1573 <printf+0x53>
    }
  }
}
    15ea:	8d 65 f4             	lea    -0xc(%ebp),%esp
    15ed:	5b                   	pop    %ebx
    15ee:	5e                   	pop    %esi
    15ef:	5f                   	pop    %edi
    15f0:	5d                   	pop    %ebp
    15f1:	c3                   	ret    
    15f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        state = '%';
    15f8:	bf 25 00 00 00       	mov    $0x25,%edi
    15fd:	e9 66 ff ff ff       	jmp    1568 <printf+0x48>
    1602:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        printint(fd, *ap, 16, 0);
    1608:	83 ec 0c             	sub    $0xc,%esp
    160b:	b9 10 00 00 00       	mov    $0x10,%ecx
    1610:	6a 00                	push   $0x0
    1612:	8b 7d d4             	mov    -0x2c(%ebp),%edi
    1615:	8b 45 08             	mov    0x8(%ebp),%eax
    1618:	8b 17                	mov    (%edi),%edx
    161a:	e8 61 fe ff ff       	call   1480 <printint>
        ap++;
    161f:	89 f8                	mov    %edi,%eax
    1621:	83 c4 10             	add    $0x10,%esp
      state = 0;
    1624:	31 ff                	xor    %edi,%edi
        ap++;
    1626:	83 c0 04             	add    $0x4,%eax
    1629:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    162c:	e9 37 ff ff ff       	jmp    1568 <printf+0x48>
    1631:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        s = (char*)*ap;
    1638:	8b 45 d4             	mov    -0x2c(%ebp),%eax
    163b:	8b 08                	mov    (%eax),%ecx
        ap++;
    163d:	83 c0 04             	add    $0x4,%eax
    1640:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        if(s == 0)
    1643:	85 c9                	test   %ecx,%ecx
    1645:	0f 84 8e 00 00 00    	je     16d9 <printf+0x1b9>
        while(*s != 0){
    164b:	0f b6 01             	movzbl (%ecx),%eax
      state = 0;
    164e:	31 ff                	xor    %edi,%edi
        s = (char*)*ap;
    1650:	89 cb                	mov    %ecx,%ebx
        while(*s != 0){
    1652:	84 c0                	test   %al,%al
    1654:	0f 84 0e ff ff ff    	je     1568 <printf+0x48>
    165a:	89 75 d0             	mov    %esi,-0x30(%ebp)
    165d:	89 de                	mov    %ebx,%esi
    165f:	8b 5d 08             	mov    0x8(%ebp),%ebx
    1662:	8d 7d e3             	lea    -0x1d(%ebp),%edi
    1665:	8d 76 00             	lea    0x0(%esi),%esi
  write(fd, &c, 1);
    1668:	83 ec 04             	sub    $0x4,%esp
          s++;
    166b:	83 c6 01             	add    $0x1,%esi
    166e:	88 45 e3             	mov    %al,-0x1d(%ebp)
  write(fd, &c, 1);
    1671:	6a 01                	push   $0x1
    1673:	57                   	push   %edi
    1674:	53                   	push   %ebx
    1675:	e8 18 fd ff ff       	call   1392 <write>
        while(*s != 0){
    167a:	0f b6 06             	movzbl (%esi),%eax
    167d:	83 c4 10             	add    $0x10,%esp
    1680:	84 c0                	test   %al,%al
    1682:	75 e4                	jne    1668 <printf+0x148>
    1684:	8b 75 d0             	mov    -0x30(%ebp),%esi
      state = 0;
    1687:	31 ff                	xor    %edi,%edi
    1689:	e9 da fe ff ff       	jmp    1568 <printf+0x48>
    168e:	66 90                	xchg   %ax,%ax
        printint(fd, *ap, 10, 1);
    1690:	83 ec 0c             	sub    $0xc,%esp
    1693:	b9 0a 00 00 00       	mov    $0xa,%ecx
    1698:	6a 01                	push   $0x1
    169a:	e9 73 ff ff ff       	jmp    1612 <printf+0xf2>
    169f:	90                   	nop
  write(fd, &c, 1);
    16a0:	83 ec 04             	sub    $0x4,%esp
    16a3:	88 5d e5             	mov    %bl,-0x1b(%ebp)
    16a6:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    16a9:	6a 01                	push   $0x1
    16ab:	e9 21 ff ff ff       	jmp    15d1 <printf+0xb1>
        putc(fd, *ap);
    16b0:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  write(fd, &c, 1);
    16b3:	83 ec 04             	sub    $0x4,%esp
        putc(fd, *ap);
    16b6:	8b 07                	mov    (%edi),%eax
  write(fd, &c, 1);
    16b8:	6a 01                	push   $0x1
        ap++;
    16ba:	83 c7 04             	add    $0x4,%edi
        putc(fd, *ap);
    16bd:	88 45 e4             	mov    %al,-0x1c(%ebp)
  write(fd, &c, 1);
    16c0:	8d 45 e4             	lea    -0x1c(%ebp),%eax
    16c3:	50                   	push   %eax
    16c4:	ff 75 08             	pushl  0x8(%ebp)
    16c7:	e8 c6 fc ff ff       	call   1392 <write>
        ap++;
    16cc:	89 7d d4             	mov    %edi,-0x2c(%ebp)
    16cf:	83 c4 10             	add    $0x10,%esp
      state = 0;
    16d2:	31 ff                	xor    %edi,%edi
    16d4:	e9 8f fe ff ff       	jmp    1568 <printf+0x48>
          s = "(null)";
    16d9:	bb 10 1b 00 00       	mov    $0x1b10,%ebx
        while(*s != 0){
    16de:	b8 28 00 00 00       	mov    $0x28,%eax
    16e3:	e9 72 ff ff ff       	jmp    165a <printf+0x13a>
    16e8:	66 90                	xchg   %ax,%ax
    16ea:	66 90                	xchg   %ax,%ax
    16ec:	66 90                	xchg   %ax,%ax
    16ee:	66 90                	xchg   %ax,%ax

000016f0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    16f0:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    16f1:	a1 58 23 00 00       	mov    0x2358,%eax
{
    16f6:	89 e5                	mov    %esp,%ebp
    16f8:	57                   	push   %edi
    16f9:	56                   	push   %esi
    16fa:	53                   	push   %ebx
    16fb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = (Header*)ap - 1;
    16fe:	8d 4b f8             	lea    -0x8(%ebx),%ecx
    1701:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1708:	39 c8                	cmp    %ecx,%eax
    170a:	8b 10                	mov    (%eax),%edx
    170c:	73 32                	jae    1740 <free+0x50>
    170e:	39 d1                	cmp    %edx,%ecx
    1710:	72 04                	jb     1716 <free+0x26>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1712:	39 d0                	cmp    %edx,%eax
    1714:	72 32                	jb     1748 <free+0x58>
      break;
  if(bp + bp->s.size == p->s.ptr){
    1716:	8b 73 fc             	mov    -0x4(%ebx),%esi
    1719:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
    171c:	39 fa                	cmp    %edi,%edx
    171e:	74 30                	je     1750 <free+0x60>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
    1720:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
    1723:	8b 50 04             	mov    0x4(%eax),%edx
    1726:	8d 34 d0             	lea    (%eax,%edx,8),%esi
    1729:	39 f1                	cmp    %esi,%ecx
    172b:	74 3a                	je     1767 <free+0x77>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
    172d:	89 08                	mov    %ecx,(%eax)
  freep = p;
    172f:	a3 58 23 00 00       	mov    %eax,0x2358
}
    1734:	5b                   	pop    %ebx
    1735:	5e                   	pop    %esi
    1736:	5f                   	pop    %edi
    1737:	5d                   	pop    %ebp
    1738:	c3                   	ret    
    1739:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1740:	39 d0                	cmp    %edx,%eax
    1742:	72 04                	jb     1748 <free+0x58>
    1744:	39 d1                	cmp    %edx,%ecx
    1746:	72 ce                	jb     1716 <free+0x26>
{
    1748:	89 d0                	mov    %edx,%eax
    174a:	eb bc                	jmp    1708 <free+0x18>
    174c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp->s.size += p->s.ptr->s.size;
    1750:	03 72 04             	add    0x4(%edx),%esi
    1753:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
    1756:	8b 10                	mov    (%eax),%edx
    1758:	8b 12                	mov    (%edx),%edx
    175a:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
    175d:	8b 50 04             	mov    0x4(%eax),%edx
    1760:	8d 34 d0             	lea    (%eax,%edx,8),%esi
    1763:	39 f1                	cmp    %esi,%ecx
    1765:	75 c6                	jne    172d <free+0x3d>
    p->s.size += bp->s.size;
    1767:	03 53 fc             	add    -0x4(%ebx),%edx
  freep = p;
    176a:	a3 58 23 00 00       	mov    %eax,0x2358
    p->s.size += bp->s.size;
    176f:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    1772:	8b 53 f8             	mov    -0x8(%ebx),%edx
    1775:	89 10                	mov    %edx,(%eax)
}
    1777:	5b                   	pop    %ebx
    1778:	5e                   	pop    %esi
    1779:	5f                   	pop    %edi
    177a:	5d                   	pop    %ebp
    177b:	c3                   	ret    
    177c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00001780 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    1780:	55                   	push   %ebp
    1781:	89 e5                	mov    %esp,%ebp
    1783:	57                   	push   %edi
    1784:	56                   	push   %esi
    1785:	53                   	push   %ebx
    1786:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1789:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
    178c:	8b 15 58 23 00 00    	mov    0x2358,%edx
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1792:	8d 78 07             	lea    0x7(%eax),%edi
    1795:	c1 ef 03             	shr    $0x3,%edi
    1798:	83 c7 01             	add    $0x1,%edi
  if((prevp = freep) == 0){
    179b:	85 d2                	test   %edx,%edx
    179d:	0f 84 9d 00 00 00    	je     1840 <malloc+0xc0>
    17a3:	8b 02                	mov    (%edx),%eax
    17a5:	8b 48 04             	mov    0x4(%eax),%ecx
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
    17a8:	39 cf                	cmp    %ecx,%edi
    17aa:	76 6c                	jbe    1818 <malloc+0x98>
    17ac:	81 ff 00 10 00 00    	cmp    $0x1000,%edi
    17b2:	bb 00 10 00 00       	mov    $0x1000,%ebx
    17b7:	0f 43 df             	cmovae %edi,%ebx
  p = sbrk(nu * sizeof(Header));
    17ba:	8d 34 dd 00 00 00 00 	lea    0x0(,%ebx,8),%esi
    17c1:	eb 0e                	jmp    17d1 <malloc+0x51>
    17c3:	90                   	nop
    17c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    17c8:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
    17ca:	8b 48 04             	mov    0x4(%eax),%ecx
    17cd:	39 f9                	cmp    %edi,%ecx
    17cf:	73 47                	jae    1818 <malloc+0x98>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    17d1:	39 05 58 23 00 00    	cmp    %eax,0x2358
    17d7:	89 c2                	mov    %eax,%edx
    17d9:	75 ed                	jne    17c8 <malloc+0x48>
  p = sbrk(nu * sizeof(Header));
    17db:	83 ec 0c             	sub    $0xc,%esp
    17de:	56                   	push   %esi
    17df:	e8 16 fc ff ff       	call   13fa <sbrk>
  if(p == (char*)-1)
    17e4:	83 c4 10             	add    $0x10,%esp
    17e7:	83 f8 ff             	cmp    $0xffffffff,%eax
    17ea:	74 1c                	je     1808 <malloc+0x88>
  hp->s.size = nu;
    17ec:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
    17ef:	83 ec 0c             	sub    $0xc,%esp
    17f2:	83 c0 08             	add    $0x8,%eax
    17f5:	50                   	push   %eax
    17f6:	e8 f5 fe ff ff       	call   16f0 <free>
  return freep;
    17fb:	8b 15 58 23 00 00    	mov    0x2358,%edx
      if((p = morecore(nunits)) == 0)
    1801:	83 c4 10             	add    $0x10,%esp
    1804:	85 d2                	test   %edx,%edx
    1806:	75 c0                	jne    17c8 <malloc+0x48>
        return 0;
  }
}
    1808:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
    180b:	31 c0                	xor    %eax,%eax
}
    180d:	5b                   	pop    %ebx
    180e:	5e                   	pop    %esi
    180f:	5f                   	pop    %edi
    1810:	5d                   	pop    %ebp
    1811:	c3                   	ret    
    1812:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
    1818:	39 cf                	cmp    %ecx,%edi
    181a:	74 54                	je     1870 <malloc+0xf0>
        p->s.size -= nunits;
    181c:	29 f9                	sub    %edi,%ecx
    181e:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
    1821:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
    1824:	89 78 04             	mov    %edi,0x4(%eax)
      freep = prevp;
    1827:	89 15 58 23 00 00    	mov    %edx,0x2358
}
    182d:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
    1830:	83 c0 08             	add    $0x8,%eax
}
    1833:	5b                   	pop    %ebx
    1834:	5e                   	pop    %esi
    1835:	5f                   	pop    %edi
    1836:	5d                   	pop    %ebp
    1837:	c3                   	ret    
    1838:	90                   	nop
    1839:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    base.s.ptr = freep = prevp = &base;
    1840:	c7 05 58 23 00 00 5c 	movl   $0x235c,0x2358
    1847:	23 00 00 
    184a:	c7 05 5c 23 00 00 5c 	movl   $0x235c,0x235c
    1851:	23 00 00 
    base.s.size = 0;
    1854:	b8 5c 23 00 00       	mov    $0x235c,%eax
    1859:	c7 05 60 23 00 00 00 	movl   $0x0,0x2360
    1860:	00 00 00 
    1863:	e9 44 ff ff ff       	jmp    17ac <malloc+0x2c>
    1868:	90                   	nop
    1869:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        prevp->s.ptr = p->s.ptr;
    1870:	8b 08                	mov    (%eax),%ecx
    1872:	89 0a                	mov    %ecx,(%edx)
    1874:	eb b1                	jmp    1827 <malloc+0xa7>
