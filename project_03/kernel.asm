
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 b0 10 00       	mov    $0x10b000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc c0 d5 10 80       	mov    $0x8010d5c0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 40 36 10 80       	mov    $0x80103640,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax
80100034:	66 90                	xchg   %ax,%ax
80100036:	66 90                	xchg   %ax,%ax
80100038:	66 90                	xchg   %ax,%ax
8010003a:	66 90                	xchg   %ax,%ax
8010003c:	66 90                	xchg   %ax,%ax
8010003e:	66 90                	xchg   %ax,%ax

80100040 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100040:	55                   	push   %ebp
80100041:	89 e5                	mov    %esp,%ebp
80100043:	53                   	push   %ebx

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100044:	bb f4 d5 10 80       	mov    $0x8010d5f4,%ebx
{
80100049:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
8010004c:	68 c0 8f 10 80       	push   $0x80108fc0
80100051:	68 c0 d5 10 80       	push   $0x8010d5c0
80100056:	e8 65 55 00 00       	call   801055c0 <initlock>
  bcache.head.prev = &bcache.head;
8010005b:	c7 05 0c 1d 11 80 bc 	movl   $0x80111cbc,0x80111d0c
80100062:	1c 11 80 
  bcache.head.next = &bcache.head;
80100065:	c7 05 10 1d 11 80 bc 	movl   $0x80111cbc,0x80111d10
8010006c:	1c 11 80 
8010006f:	83 c4 10             	add    $0x10,%esp
80100072:	ba bc 1c 11 80       	mov    $0x80111cbc,%edx
80100077:	eb 09                	jmp    80100082 <binit+0x42>
80100079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100080:	89 c3                	mov    %eax,%ebx
    b->next = bcache.head.next;
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
80100082:	8d 43 0c             	lea    0xc(%ebx),%eax
80100085:	83 ec 08             	sub    $0x8,%esp
    b->next = bcache.head.next;
80100088:	89 53 54             	mov    %edx,0x54(%ebx)
    b->prev = &bcache.head;
8010008b:	c7 43 50 bc 1c 11 80 	movl   $0x80111cbc,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 c7 8f 10 80       	push   $0x80108fc7
80100097:	50                   	push   %eax
80100098:	e8 f3 53 00 00       	call   80105490 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 10 1d 11 80       	mov    0x80111d10,%eax
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	83 c4 10             	add    $0x10,%esp
801000a5:	89 da                	mov    %ebx,%edx
    bcache.head.next->prev = b;
801000a7:	89 58 50             	mov    %ebx,0x50(%eax)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000aa:	8d 83 5c 02 00 00    	lea    0x25c(%ebx),%eax
    bcache.head.next = b;
801000b0:	89 1d 10 1d 11 80    	mov    %ebx,0x80111d10
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	3d bc 1c 11 80       	cmp    $0x80111cbc,%eax
801000bb:	72 c3                	jb     80100080 <binit+0x40>
  }
}
801000bd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801000c0:	c9                   	leave  
801000c1:	c3                   	ret    
801000c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801000c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801000d0 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801000d0:	55                   	push   %ebp
801000d1:	89 e5                	mov    %esp,%ebp
801000d3:	57                   	push   %edi
801000d4:	56                   	push   %esi
801000d5:	53                   	push   %ebx
801000d6:	83 ec 18             	sub    $0x18,%esp
801000d9:	8b 75 08             	mov    0x8(%ebp),%esi
801000dc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  acquire(&bcache.lock);
801000df:	68 c0 d5 10 80       	push   $0x8010d5c0
801000e4:	e8 17 56 00 00       	call   80105700 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000e9:	8b 1d 10 1d 11 80    	mov    0x80111d10,%ebx
801000ef:	83 c4 10             	add    $0x10,%esp
801000f2:	81 fb bc 1c 11 80    	cmp    $0x80111cbc,%ebx
801000f8:	75 11                	jne    8010010b <bread+0x3b>
801000fa:	eb 24                	jmp    80100120 <bread+0x50>
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb bc 1c 11 80    	cmp    $0x80111cbc,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
    if(b->dev == dev && b->blockno == blockno){
8010010b:	3b 73 04             	cmp    0x4(%ebx),%esi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 7b 08             	cmp    0x8(%ebx),%edi
80100113:	75 eb                	jne    80100100 <bread+0x30>
      b->refcnt++;
80100115:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
80100119:	eb 3f                	jmp    8010015a <bread+0x8a>
8010011b:	90                   	nop
8010011c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d 0c 1d 11 80    	mov    0x80111d0c,%ebx
80100126:	81 fb bc 1c 11 80    	cmp    $0x80111cbc,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 60                	jmp    80100190 <bread+0xc0>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb bc 1c 11 80    	cmp    $0x80111cbc,%ebx
80100139:	74 55                	je     80100190 <bread+0xc0>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010013b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010013e:	85 c0                	test   %eax,%eax
80100140:	75 ee                	jne    80100130 <bread+0x60>
80100142:	f6 03 04             	testb  $0x4,(%ebx)
80100145:	75 e9                	jne    80100130 <bread+0x60>
      b->dev = dev;
80100147:	89 73 04             	mov    %esi,0x4(%ebx)
      b->blockno = blockno;
8010014a:	89 7b 08             	mov    %edi,0x8(%ebx)
      b->flags = 0;
8010014d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
80100153:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
8010015a:	83 ec 0c             	sub    $0xc,%esp
8010015d:	68 c0 d5 10 80       	push   $0x8010d5c0
80100162:	e8 59 56 00 00       	call   801057c0 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 5e 53 00 00       	call   801054d0 <acquiresleep>
80100172:	83 c4 10             	add    $0x10,%esp
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100175:	f6 03 02             	testb  $0x2,(%ebx)
80100178:	75 0c                	jne    80100186 <bread+0xb6>
    iderw(b);
8010017a:	83 ec 0c             	sub    $0xc,%esp
8010017d:	53                   	push   %ebx
8010017e:	e8 cd 25 00 00       	call   80102750 <iderw>
80100183:	83 c4 10             	add    $0x10,%esp
  }
  return b;
}
80100186:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100189:	89 d8                	mov    %ebx,%eax
8010018b:	5b                   	pop    %ebx
8010018c:	5e                   	pop    %esi
8010018d:	5f                   	pop    %edi
8010018e:	5d                   	pop    %ebp
8010018f:	c3                   	ret    
  panic("bget: no buffers");
80100190:	83 ec 0c             	sub    $0xc,%esp
80100193:	68 ce 8f 10 80       	push   $0x80108fce
80100198:	e8 f3 01 00 00       	call   80100390 <panic>
8010019d:	8d 76 00             	lea    0x0(%esi),%esi

801001a0 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001a0:	55                   	push   %ebp
801001a1:	89 e5                	mov    %esp,%ebp
801001a3:	53                   	push   %ebx
801001a4:	83 ec 10             	sub    $0x10,%esp
801001a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001aa:	8d 43 0c             	lea    0xc(%ebx),%eax
801001ad:	50                   	push   %eax
801001ae:	e8 bd 53 00 00       	call   80105570 <holdingsleep>
801001b3:	83 c4 10             	add    $0x10,%esp
801001b6:	85 c0                	test   %eax,%eax
801001b8:	74 0f                	je     801001c9 <bwrite+0x29>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001ba:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001bd:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001c0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001c3:	c9                   	leave  
  iderw(b);
801001c4:	e9 87 25 00 00       	jmp    80102750 <iderw>
    panic("bwrite");
801001c9:	83 ec 0c             	sub    $0xc,%esp
801001cc:	68 df 8f 10 80       	push   $0x80108fdf
801001d1:	e8 ba 01 00 00       	call   80100390 <panic>
801001d6:	8d 76 00             	lea    0x0(%esi),%esi
801001d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801001e0 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001e0:	55                   	push   %ebp
801001e1:	89 e5                	mov    %esp,%ebp
801001e3:	56                   	push   %esi
801001e4:	53                   	push   %ebx
801001e5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001e8:	83 ec 0c             	sub    $0xc,%esp
801001eb:	8d 73 0c             	lea    0xc(%ebx),%esi
801001ee:	56                   	push   %esi
801001ef:	e8 7c 53 00 00       	call   80105570 <holdingsleep>
801001f4:	83 c4 10             	add    $0x10,%esp
801001f7:	85 c0                	test   %eax,%eax
801001f9:	74 66                	je     80100261 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 2c 53 00 00       	call   80105530 <releasesleep>

  acquire(&bcache.lock);
80100204:	c7 04 24 c0 d5 10 80 	movl   $0x8010d5c0,(%esp)
8010020b:	e8 f0 54 00 00       	call   80105700 <acquire>
  b->refcnt--;
80100210:	8b 43 4c             	mov    0x4c(%ebx),%eax
  if (b->refcnt == 0) {
80100213:	83 c4 10             	add    $0x10,%esp
  b->refcnt--;
80100216:	83 e8 01             	sub    $0x1,%eax
  if (b->refcnt == 0) {
80100219:	85 c0                	test   %eax,%eax
  b->refcnt--;
8010021b:	89 43 4c             	mov    %eax,0x4c(%ebx)
  if (b->refcnt == 0) {
8010021e:	75 2f                	jne    8010024f <brelse+0x6f>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100220:	8b 43 54             	mov    0x54(%ebx),%eax
80100223:	8b 53 50             	mov    0x50(%ebx),%edx
80100226:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
80100229:	8b 43 50             	mov    0x50(%ebx),%eax
8010022c:	8b 53 54             	mov    0x54(%ebx),%edx
8010022f:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100232:	a1 10 1d 11 80       	mov    0x80111d10,%eax
    b->prev = &bcache.head;
80100237:	c7 43 50 bc 1c 11 80 	movl   $0x80111cbc,0x50(%ebx)
    b->next = bcache.head.next;
8010023e:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
80100241:	a1 10 1d 11 80       	mov    0x80111d10,%eax
80100246:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
80100249:	89 1d 10 1d 11 80    	mov    %ebx,0x80111d10
  }
  
  release(&bcache.lock);
8010024f:	c7 45 08 c0 d5 10 80 	movl   $0x8010d5c0,0x8(%ebp)
}
80100256:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100259:	5b                   	pop    %ebx
8010025a:	5e                   	pop    %esi
8010025b:	5d                   	pop    %ebp
  release(&bcache.lock);
8010025c:	e9 5f 55 00 00       	jmp    801057c0 <release>
    panic("brelse");
80100261:	83 ec 0c             	sub    $0xc,%esp
80100264:	68 e6 8f 10 80       	push   $0x80108fe6
80100269:	e8 22 01 00 00       	call   80100390 <panic>
8010026e:	66 90                	xchg   %ax,%ax

80100270 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100270:	55                   	push   %ebp
80100271:	89 e5                	mov    %esp,%ebp
80100273:	57                   	push   %edi
80100274:	56                   	push   %esi
80100275:	53                   	push   %ebx
80100276:	83 ec 28             	sub    $0x28,%esp
80100279:	8b 7d 08             	mov    0x8(%ebp),%edi
8010027c:	8b 75 0c             	mov    0xc(%ebp),%esi
  uint target;
  int c;

  iunlock(ip);
8010027f:	57                   	push   %edi
80100280:	e8 2b 19 00 00       	call   80101bb0 <iunlock>
  target = n;
  acquire(&cons.lock);
80100285:	c7 04 24 20 c5 10 80 	movl   $0x8010c520,(%esp)
8010028c:	e8 6f 54 00 00       	call   80105700 <acquire>
  while(n > 0){
80100291:	8b 5d 10             	mov    0x10(%ebp),%ebx
80100294:	83 c4 10             	add    $0x10,%esp
80100297:	31 c0                	xor    %eax,%eax
80100299:	85 db                	test   %ebx,%ebx
8010029b:	0f 8e a1 00 00 00    	jle    80100342 <consoleread+0xd2>
    while(input.r == input.w){
801002a1:	8b 15 a0 1f 11 80    	mov    0x80111fa0,%edx
801002a7:	39 15 a4 1f 11 80    	cmp    %edx,0x80111fa4
801002ad:	74 2c                	je     801002db <consoleread+0x6b>
801002af:	eb 5f                	jmp    80100310 <consoleread+0xa0>
801002b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(myproc()->killed){
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
801002b8:	83 ec 08             	sub    $0x8,%esp
801002bb:	68 20 c5 10 80       	push   $0x8010c520
801002c0:	68 a0 1f 11 80       	push   $0x80111fa0
801002c5:	e8 d6 45 00 00       	call   801048a0 <sleep>
    while(input.r == input.w){
801002ca:	8b 15 a0 1f 11 80    	mov    0x80111fa0,%edx
801002d0:	83 c4 10             	add    $0x10,%esp
801002d3:	3b 15 a4 1f 11 80    	cmp    0x80111fa4,%edx
801002d9:	75 35                	jne    80100310 <consoleread+0xa0>
      if(myproc()->killed){
801002db:	e8 d0 3f 00 00       	call   801042b0 <myproc>
801002e0:	8b 40 24             	mov    0x24(%eax),%eax
801002e3:	85 c0                	test   %eax,%eax
801002e5:	74 d1                	je     801002b8 <consoleread+0x48>
        release(&cons.lock);
801002e7:	83 ec 0c             	sub    $0xc,%esp
801002ea:	68 20 c5 10 80       	push   $0x8010c520
801002ef:	e8 cc 54 00 00       	call   801057c0 <release>
        ilock(ip);
801002f4:	89 3c 24             	mov    %edi,(%esp)
801002f7:	e8 d4 17 00 00       	call   80101ad0 <ilock>
        return -1;
801002fc:	83 c4 10             	add    $0x10,%esp
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
801002ff:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return -1;
80100302:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100307:	5b                   	pop    %ebx
80100308:	5e                   	pop    %esi
80100309:	5f                   	pop    %edi
8010030a:	5d                   	pop    %ebp
8010030b:	c3                   	ret    
8010030c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = input.buf[input.r++ % INPUT_BUF];
80100310:	8d 42 01             	lea    0x1(%edx),%eax
80100313:	a3 a0 1f 11 80       	mov    %eax,0x80111fa0
80100318:	89 d0                	mov    %edx,%eax
8010031a:	83 e0 7f             	and    $0x7f,%eax
8010031d:	0f be 80 20 1f 11 80 	movsbl -0x7feee0e0(%eax),%eax
    if(c == C('D')){  // EOF
80100324:	83 f8 04             	cmp    $0x4,%eax
80100327:	74 3f                	je     80100368 <consoleread+0xf8>
    *dst++ = c;
80100329:	83 c6 01             	add    $0x1,%esi
    --n;
8010032c:	83 eb 01             	sub    $0x1,%ebx
    if(c == '\n')
8010032f:	83 f8 0a             	cmp    $0xa,%eax
    *dst++ = c;
80100332:	88 46 ff             	mov    %al,-0x1(%esi)
    if(c == '\n')
80100335:	74 43                	je     8010037a <consoleread+0x10a>
  while(n > 0){
80100337:	85 db                	test   %ebx,%ebx
80100339:	0f 85 62 ff ff ff    	jne    801002a1 <consoleread+0x31>
8010033f:	8b 45 10             	mov    0x10(%ebp),%eax
  release(&cons.lock);
80100342:	83 ec 0c             	sub    $0xc,%esp
80100345:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100348:	68 20 c5 10 80       	push   $0x8010c520
8010034d:	e8 6e 54 00 00       	call   801057c0 <release>
  ilock(ip);
80100352:	89 3c 24             	mov    %edi,(%esp)
80100355:	e8 76 17 00 00       	call   80101ad0 <ilock>
  return target - n;
8010035a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010035d:	83 c4 10             	add    $0x10,%esp
}
80100360:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100363:	5b                   	pop    %ebx
80100364:	5e                   	pop    %esi
80100365:	5f                   	pop    %edi
80100366:	5d                   	pop    %ebp
80100367:	c3                   	ret    
80100368:	8b 45 10             	mov    0x10(%ebp),%eax
8010036b:	29 d8                	sub    %ebx,%eax
      if(n < target){
8010036d:	3b 5d 10             	cmp    0x10(%ebp),%ebx
80100370:	73 d0                	jae    80100342 <consoleread+0xd2>
        input.r--;
80100372:	89 15 a0 1f 11 80    	mov    %edx,0x80111fa0
80100378:	eb c8                	jmp    80100342 <consoleread+0xd2>
8010037a:	8b 45 10             	mov    0x10(%ebp),%eax
8010037d:	29 d8                	sub    %ebx,%eax
8010037f:	eb c1                	jmp    80100342 <consoleread+0xd2>
80100381:	eb 0d                	jmp    80100390 <panic>
80100383:	90                   	nop
80100384:	90                   	nop
80100385:	90                   	nop
80100386:	90                   	nop
80100387:	90                   	nop
80100388:	90                   	nop
80100389:	90                   	nop
8010038a:	90                   	nop
8010038b:	90                   	nop
8010038c:	90                   	nop
8010038d:	90                   	nop
8010038e:	90                   	nop
8010038f:	90                   	nop

80100390 <panic>:
{
80100390:	55                   	push   %ebp
80100391:	89 e5                	mov    %esp,%ebp
80100393:	56                   	push   %esi
80100394:	53                   	push   %ebx
80100395:	83 ec 30             	sub    $0x30,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
80100398:	fa                   	cli    
  cons.locking = 0;
80100399:	c7 05 54 c5 10 80 00 	movl   $0x0,0x8010c554
801003a0:	00 00 00 
  getcallerpcs(&s, pcs);
801003a3:	8d 5d d0             	lea    -0x30(%ebp),%ebx
801003a6:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
801003a9:	e8 b2 29 00 00       	call   80102d60 <lapicid>
801003ae:	83 ec 08             	sub    $0x8,%esp
801003b1:	50                   	push   %eax
801003b2:	68 ed 8f 10 80       	push   $0x80108fed
801003b7:	e8 a4 02 00 00       	call   80100660 <cprintf>
  cprintf(s);
801003bc:	58                   	pop    %eax
801003bd:	ff 75 08             	pushl  0x8(%ebp)
801003c0:	e8 9b 02 00 00       	call   80100660 <cprintf>
  cprintf("\n");
801003c5:	c7 04 24 47 9a 10 80 	movl   $0x80109a47,(%esp)
801003cc:	e8 8f 02 00 00       	call   80100660 <cprintf>
  getcallerpcs(&s, pcs);
801003d1:	5a                   	pop    %edx
801003d2:	8d 45 08             	lea    0x8(%ebp),%eax
801003d5:	59                   	pop    %ecx
801003d6:	53                   	push   %ebx
801003d7:	50                   	push   %eax
801003d8:	e8 03 52 00 00       	call   801055e0 <getcallerpcs>
801003dd:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003e0:	83 ec 08             	sub    $0x8,%esp
801003e3:	ff 33                	pushl  (%ebx)
801003e5:	83 c3 04             	add    $0x4,%ebx
801003e8:	68 01 90 10 80       	push   $0x80109001
801003ed:	e8 6e 02 00 00       	call   80100660 <cprintf>
  for(i=0; i<10; i++)
801003f2:	83 c4 10             	add    $0x10,%esp
801003f5:	39 f3                	cmp    %esi,%ebx
801003f7:	75 e7                	jne    801003e0 <panic+0x50>
  panicked = 1; // freeze other CPU
801003f9:	c7 05 58 c5 10 80 01 	movl   $0x1,0x8010c558
80100400:	00 00 00 
80100403:	eb fe                	jmp    80100403 <panic+0x73>
80100405:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100409:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100410 <consputc>:
  if(panicked){
80100410:	8b 0d 58 c5 10 80    	mov    0x8010c558,%ecx
80100416:	85 c9                	test   %ecx,%ecx
80100418:	74 06                	je     80100420 <consputc+0x10>
8010041a:	fa                   	cli    
8010041b:	eb fe                	jmp    8010041b <consputc+0xb>
8010041d:	8d 76 00             	lea    0x0(%esi),%esi
{
80100420:	55                   	push   %ebp
80100421:	89 e5                	mov    %esp,%ebp
80100423:	57                   	push   %edi
80100424:	56                   	push   %esi
80100425:	53                   	push   %ebx
80100426:	89 c6                	mov    %eax,%esi
80100428:	83 ec 0c             	sub    $0xc,%esp
  if(c == BACKSPACE){
8010042b:	3d 00 01 00 00       	cmp    $0x100,%eax
80100430:	0f 84 b1 00 00 00    	je     801004e7 <consputc+0xd7>
    uartputc(c);
80100436:	83 ec 0c             	sub    $0xc,%esp
80100439:	50                   	push   %eax
8010043a:	e8 11 6d 00 00       	call   80107150 <uartputc>
8010043f:	83 c4 10             	add    $0x10,%esp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100442:	bb d4 03 00 00       	mov    $0x3d4,%ebx
80100447:	b8 0e 00 00 00       	mov    $0xe,%eax
8010044c:	89 da                	mov    %ebx,%edx
8010044e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010044f:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
80100454:	89 ca                	mov    %ecx,%edx
80100456:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100457:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010045a:	89 da                	mov    %ebx,%edx
8010045c:	c1 e0 08             	shl    $0x8,%eax
8010045f:	89 c7                	mov    %eax,%edi
80100461:	b8 0f 00 00 00       	mov    $0xf,%eax
80100466:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100467:	89 ca                	mov    %ecx,%edx
80100469:	ec                   	in     (%dx),%al
8010046a:	0f b6 d8             	movzbl %al,%ebx
  pos |= inb(CRTPORT+1);
8010046d:	09 fb                	or     %edi,%ebx
  if(c == '\n')
8010046f:	83 fe 0a             	cmp    $0xa,%esi
80100472:	0f 84 f3 00 00 00    	je     8010056b <consputc+0x15b>
  else if(c == BACKSPACE){
80100478:	81 fe 00 01 00 00    	cmp    $0x100,%esi
8010047e:	0f 84 d7 00 00 00    	je     8010055b <consputc+0x14b>
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
80100484:	89 f0                	mov    %esi,%eax
80100486:	0f b6 c0             	movzbl %al,%eax
80100489:	80 cc 07             	or     $0x7,%ah
8010048c:	66 89 84 1b 00 80 0b 	mov    %ax,-0x7ff48000(%ebx,%ebx,1)
80100493:	80 
80100494:	83 c3 01             	add    $0x1,%ebx
  if(pos < 0 || pos > 25*80)
80100497:	81 fb d0 07 00 00    	cmp    $0x7d0,%ebx
8010049d:	0f 8f ab 00 00 00    	jg     8010054e <consputc+0x13e>
  if((pos/80) >= 24){  // Scroll up.
801004a3:	81 fb 7f 07 00 00    	cmp    $0x77f,%ebx
801004a9:	7f 66                	jg     80100511 <consputc+0x101>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801004ab:	be d4 03 00 00       	mov    $0x3d4,%esi
801004b0:	b8 0e 00 00 00       	mov    $0xe,%eax
801004b5:	89 f2                	mov    %esi,%edx
801004b7:	ee                   	out    %al,(%dx)
801004b8:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
  outb(CRTPORT+1, pos>>8);
801004bd:	89 d8                	mov    %ebx,%eax
801004bf:	c1 f8 08             	sar    $0x8,%eax
801004c2:	89 ca                	mov    %ecx,%edx
801004c4:	ee                   	out    %al,(%dx)
801004c5:	b8 0f 00 00 00       	mov    $0xf,%eax
801004ca:	89 f2                	mov    %esi,%edx
801004cc:	ee                   	out    %al,(%dx)
801004cd:	89 d8                	mov    %ebx,%eax
801004cf:	89 ca                	mov    %ecx,%edx
801004d1:	ee                   	out    %al,(%dx)
  crt[pos] = ' ' | 0x0700;
801004d2:	b8 20 07 00 00       	mov    $0x720,%eax
801004d7:	66 89 84 1b 00 80 0b 	mov    %ax,-0x7ff48000(%ebx,%ebx,1)
801004de:	80 
}
801004df:	8d 65 f4             	lea    -0xc(%ebp),%esp
801004e2:	5b                   	pop    %ebx
801004e3:	5e                   	pop    %esi
801004e4:	5f                   	pop    %edi
801004e5:	5d                   	pop    %ebp
801004e6:	c3                   	ret    
    uartputc('\b'); uartputc(' '); uartputc('\b');
801004e7:	83 ec 0c             	sub    $0xc,%esp
801004ea:	6a 08                	push   $0x8
801004ec:	e8 5f 6c 00 00       	call   80107150 <uartputc>
801004f1:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801004f8:	e8 53 6c 00 00       	call   80107150 <uartputc>
801004fd:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100504:	e8 47 6c 00 00       	call   80107150 <uartputc>
80100509:	83 c4 10             	add    $0x10,%esp
8010050c:	e9 31 ff ff ff       	jmp    80100442 <consputc+0x32>
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100511:	52                   	push   %edx
80100512:	68 60 0e 00 00       	push   $0xe60
    pos -= 80;
80100517:	83 eb 50             	sub    $0x50,%ebx
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
8010051a:	68 a0 80 0b 80       	push   $0x800b80a0
8010051f:	68 00 80 0b 80       	push   $0x800b8000
80100524:	e8 97 53 00 00       	call   801058c0 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100529:	b8 80 07 00 00       	mov    $0x780,%eax
8010052e:	83 c4 0c             	add    $0xc,%esp
80100531:	29 d8                	sub    %ebx,%eax
80100533:	01 c0                	add    %eax,%eax
80100535:	50                   	push   %eax
80100536:	8d 04 1b             	lea    (%ebx,%ebx,1),%eax
80100539:	6a 00                	push   $0x0
8010053b:	2d 00 80 f4 7f       	sub    $0x7ff48000,%eax
80100540:	50                   	push   %eax
80100541:	e8 ca 52 00 00       	call   80105810 <memset>
80100546:	83 c4 10             	add    $0x10,%esp
80100549:	e9 5d ff ff ff       	jmp    801004ab <consputc+0x9b>
    panic("pos under/overflow");
8010054e:	83 ec 0c             	sub    $0xc,%esp
80100551:	68 05 90 10 80       	push   $0x80109005
80100556:	e8 35 fe ff ff       	call   80100390 <panic>
    if(pos > 0) --pos;
8010055b:	85 db                	test   %ebx,%ebx
8010055d:	0f 84 48 ff ff ff    	je     801004ab <consputc+0x9b>
80100563:	83 eb 01             	sub    $0x1,%ebx
80100566:	e9 2c ff ff ff       	jmp    80100497 <consputc+0x87>
    pos += 80 - pos%80;
8010056b:	89 d8                	mov    %ebx,%eax
8010056d:	b9 50 00 00 00       	mov    $0x50,%ecx
80100572:	99                   	cltd   
80100573:	f7 f9                	idiv   %ecx
80100575:	29 d1                	sub    %edx,%ecx
80100577:	01 cb                	add    %ecx,%ebx
80100579:	e9 19 ff ff ff       	jmp    80100497 <consputc+0x87>
8010057e:	66 90                	xchg   %ax,%ax

80100580 <printint>:
{
80100580:	55                   	push   %ebp
80100581:	89 e5                	mov    %esp,%ebp
80100583:	57                   	push   %edi
80100584:	56                   	push   %esi
80100585:	53                   	push   %ebx
80100586:	89 d3                	mov    %edx,%ebx
80100588:	83 ec 2c             	sub    $0x2c,%esp
  if(sign && (sign = xx < 0))
8010058b:	85 c9                	test   %ecx,%ecx
{
8010058d:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  if(sign && (sign = xx < 0))
80100590:	74 04                	je     80100596 <printint+0x16>
80100592:	85 c0                	test   %eax,%eax
80100594:	78 5a                	js     801005f0 <printint+0x70>
    x = xx;
80100596:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
  i = 0;
8010059d:	31 c9                	xor    %ecx,%ecx
8010059f:	8d 75 d7             	lea    -0x29(%ebp),%esi
801005a2:	eb 06                	jmp    801005aa <printint+0x2a>
801005a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    buf[i++] = digits[x % base];
801005a8:	89 f9                	mov    %edi,%ecx
801005aa:	31 d2                	xor    %edx,%edx
801005ac:	8d 79 01             	lea    0x1(%ecx),%edi
801005af:	f7 f3                	div    %ebx
801005b1:	0f b6 92 30 90 10 80 	movzbl -0x7fef6fd0(%edx),%edx
  }while((x /= base) != 0);
801005b8:	85 c0                	test   %eax,%eax
    buf[i++] = digits[x % base];
801005ba:	88 14 3e             	mov    %dl,(%esi,%edi,1)
  }while((x /= base) != 0);
801005bd:	75 e9                	jne    801005a8 <printint+0x28>
  if(sign)
801005bf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
801005c2:	85 c0                	test   %eax,%eax
801005c4:	74 08                	je     801005ce <printint+0x4e>
    buf[i++] = '-';
801005c6:	c6 44 3d d8 2d       	movb   $0x2d,-0x28(%ebp,%edi,1)
801005cb:	8d 79 02             	lea    0x2(%ecx),%edi
801005ce:	8d 5c 3d d7          	lea    -0x29(%ebp,%edi,1),%ebx
801005d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    consputc(buf[i]);
801005d8:	0f be 03             	movsbl (%ebx),%eax
801005db:	83 eb 01             	sub    $0x1,%ebx
801005de:	e8 2d fe ff ff       	call   80100410 <consputc>
  while(--i >= 0)
801005e3:	39 f3                	cmp    %esi,%ebx
801005e5:	75 f1                	jne    801005d8 <printint+0x58>
}
801005e7:	83 c4 2c             	add    $0x2c,%esp
801005ea:	5b                   	pop    %ebx
801005eb:	5e                   	pop    %esi
801005ec:	5f                   	pop    %edi
801005ed:	5d                   	pop    %ebp
801005ee:	c3                   	ret    
801005ef:	90                   	nop
    x = -xx;
801005f0:	f7 d8                	neg    %eax
801005f2:	eb a9                	jmp    8010059d <printint+0x1d>
801005f4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801005fa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80100600 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100600:	55                   	push   %ebp
80100601:	89 e5                	mov    %esp,%ebp
80100603:	57                   	push   %edi
80100604:	56                   	push   %esi
80100605:	53                   	push   %ebx
80100606:	83 ec 18             	sub    $0x18,%esp
80100609:	8b 75 10             	mov    0x10(%ebp),%esi
  int i;

  iunlock(ip);
8010060c:	ff 75 08             	pushl  0x8(%ebp)
8010060f:	e8 9c 15 00 00       	call   80101bb0 <iunlock>
  acquire(&cons.lock);
80100614:	c7 04 24 20 c5 10 80 	movl   $0x8010c520,(%esp)
8010061b:	e8 e0 50 00 00       	call   80105700 <acquire>
  for(i = 0; i < n; i++)
80100620:	83 c4 10             	add    $0x10,%esp
80100623:	85 f6                	test   %esi,%esi
80100625:	7e 18                	jle    8010063f <consolewrite+0x3f>
80100627:	8b 7d 0c             	mov    0xc(%ebp),%edi
8010062a:	8d 1c 37             	lea    (%edi,%esi,1),%ebx
8010062d:	8d 76 00             	lea    0x0(%esi),%esi
    consputc(buf[i] & 0xff);
80100630:	0f b6 07             	movzbl (%edi),%eax
80100633:	83 c7 01             	add    $0x1,%edi
80100636:	e8 d5 fd ff ff       	call   80100410 <consputc>
  for(i = 0; i < n; i++)
8010063b:	39 fb                	cmp    %edi,%ebx
8010063d:	75 f1                	jne    80100630 <consolewrite+0x30>
  release(&cons.lock);
8010063f:	83 ec 0c             	sub    $0xc,%esp
80100642:	68 20 c5 10 80       	push   $0x8010c520
80100647:	e8 74 51 00 00       	call   801057c0 <release>
  ilock(ip);
8010064c:	58                   	pop    %eax
8010064d:	ff 75 08             	pushl  0x8(%ebp)
80100650:	e8 7b 14 00 00       	call   80101ad0 <ilock>

  return n;
}
80100655:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100658:	89 f0                	mov    %esi,%eax
8010065a:	5b                   	pop    %ebx
8010065b:	5e                   	pop    %esi
8010065c:	5f                   	pop    %edi
8010065d:	5d                   	pop    %ebp
8010065e:	c3                   	ret    
8010065f:	90                   	nop

80100660 <cprintf>:
{
80100660:	55                   	push   %ebp
80100661:	89 e5                	mov    %esp,%ebp
80100663:	57                   	push   %edi
80100664:	56                   	push   %esi
80100665:	53                   	push   %ebx
80100666:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
80100669:	a1 54 c5 10 80       	mov    0x8010c554,%eax
  if(locking)
8010066e:	85 c0                	test   %eax,%eax
  locking = cons.locking;
80100670:	89 45 dc             	mov    %eax,-0x24(%ebp)
  if(locking)
80100673:	0f 85 6f 01 00 00    	jne    801007e8 <cprintf+0x188>
  if (fmt == 0)
80100679:	8b 45 08             	mov    0x8(%ebp),%eax
8010067c:	85 c0                	test   %eax,%eax
8010067e:	89 c7                	mov    %eax,%edi
80100680:	0f 84 77 01 00 00    	je     801007fd <cprintf+0x19d>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100686:	0f b6 00             	movzbl (%eax),%eax
  argp = (uint*)(void*)(&fmt + 1);
80100689:	8d 4d 0c             	lea    0xc(%ebp),%ecx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010068c:	31 db                	xor    %ebx,%ebx
  argp = (uint*)(void*)(&fmt + 1);
8010068e:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100691:	85 c0                	test   %eax,%eax
80100693:	75 56                	jne    801006eb <cprintf+0x8b>
80100695:	eb 79                	jmp    80100710 <cprintf+0xb0>
80100697:	89 f6                	mov    %esi,%esi
80100699:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    c = fmt[++i] & 0xff;
801006a0:	0f b6 16             	movzbl (%esi),%edx
    if(c == 0)
801006a3:	85 d2                	test   %edx,%edx
801006a5:	74 69                	je     80100710 <cprintf+0xb0>
801006a7:	83 c3 02             	add    $0x2,%ebx
    switch(c){
801006aa:	83 fa 70             	cmp    $0x70,%edx
801006ad:	8d 34 1f             	lea    (%edi,%ebx,1),%esi
801006b0:	0f 84 84 00 00 00    	je     8010073a <cprintf+0xda>
801006b6:	7f 78                	jg     80100730 <cprintf+0xd0>
801006b8:	83 fa 25             	cmp    $0x25,%edx
801006bb:	0f 84 ff 00 00 00    	je     801007c0 <cprintf+0x160>
801006c1:	83 fa 64             	cmp    $0x64,%edx
801006c4:	0f 85 8e 00 00 00    	jne    80100758 <cprintf+0xf8>
      printint(*argp++, 10, 1);
801006ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801006cd:	ba 0a 00 00 00       	mov    $0xa,%edx
801006d2:	8d 48 04             	lea    0x4(%eax),%ecx
801006d5:	8b 00                	mov    (%eax),%eax
801006d7:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
801006da:	b9 01 00 00 00       	mov    $0x1,%ecx
801006df:	e8 9c fe ff ff       	call   80100580 <printint>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006e4:	0f b6 06             	movzbl (%esi),%eax
801006e7:	85 c0                	test   %eax,%eax
801006e9:	74 25                	je     80100710 <cprintf+0xb0>
801006eb:	8d 53 01             	lea    0x1(%ebx),%edx
    if(c != '%'){
801006ee:	83 f8 25             	cmp    $0x25,%eax
801006f1:	8d 34 17             	lea    (%edi,%edx,1),%esi
801006f4:	74 aa                	je     801006a0 <cprintf+0x40>
801006f6:	89 55 e0             	mov    %edx,-0x20(%ebp)
      consputc(c);
801006f9:	e8 12 fd ff ff       	call   80100410 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006fe:	0f b6 06             	movzbl (%esi),%eax
      continue;
80100701:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100704:	89 d3                	mov    %edx,%ebx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100706:	85 c0                	test   %eax,%eax
80100708:	75 e1                	jne    801006eb <cprintf+0x8b>
8010070a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if(locking)
80100710:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100713:	85 c0                	test   %eax,%eax
80100715:	74 10                	je     80100727 <cprintf+0xc7>
    release(&cons.lock);
80100717:	83 ec 0c             	sub    $0xc,%esp
8010071a:	68 20 c5 10 80       	push   $0x8010c520
8010071f:	e8 9c 50 00 00       	call   801057c0 <release>
80100724:	83 c4 10             	add    $0x10,%esp
}
80100727:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010072a:	5b                   	pop    %ebx
8010072b:	5e                   	pop    %esi
8010072c:	5f                   	pop    %edi
8010072d:	5d                   	pop    %ebp
8010072e:	c3                   	ret    
8010072f:	90                   	nop
    switch(c){
80100730:	83 fa 73             	cmp    $0x73,%edx
80100733:	74 43                	je     80100778 <cprintf+0x118>
80100735:	83 fa 78             	cmp    $0x78,%edx
80100738:	75 1e                	jne    80100758 <cprintf+0xf8>
      printint(*argp++, 16, 0);
8010073a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010073d:	ba 10 00 00 00       	mov    $0x10,%edx
80100742:	8d 48 04             	lea    0x4(%eax),%ecx
80100745:	8b 00                	mov    (%eax),%eax
80100747:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
8010074a:	31 c9                	xor    %ecx,%ecx
8010074c:	e8 2f fe ff ff       	call   80100580 <printint>
      break;
80100751:	eb 91                	jmp    801006e4 <cprintf+0x84>
80100753:	90                   	nop
80100754:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      consputc('%');
80100758:	b8 25 00 00 00       	mov    $0x25,%eax
8010075d:	89 55 e0             	mov    %edx,-0x20(%ebp)
80100760:	e8 ab fc ff ff       	call   80100410 <consputc>
      consputc(c);
80100765:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100768:	89 d0                	mov    %edx,%eax
8010076a:	e8 a1 fc ff ff       	call   80100410 <consputc>
      break;
8010076f:	e9 70 ff ff ff       	jmp    801006e4 <cprintf+0x84>
80100774:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if((s = (char*)*argp++) == 0)
80100778:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010077b:	8b 10                	mov    (%eax),%edx
8010077d:	8d 48 04             	lea    0x4(%eax),%ecx
80100780:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80100783:	85 d2                	test   %edx,%edx
80100785:	74 49                	je     801007d0 <cprintf+0x170>
      for(; *s; s++)
80100787:	0f be 02             	movsbl (%edx),%eax
      if((s = (char*)*argp++) == 0)
8010078a:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
      for(; *s; s++)
8010078d:	84 c0                	test   %al,%al
8010078f:	0f 84 4f ff ff ff    	je     801006e4 <cprintf+0x84>
80100795:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80100798:	89 d3                	mov    %edx,%ebx
8010079a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801007a0:	83 c3 01             	add    $0x1,%ebx
        consputc(*s);
801007a3:	e8 68 fc ff ff       	call   80100410 <consputc>
      for(; *s; s++)
801007a8:	0f be 03             	movsbl (%ebx),%eax
801007ab:	84 c0                	test   %al,%al
801007ad:	75 f1                	jne    801007a0 <cprintf+0x140>
      if((s = (char*)*argp++) == 0)
801007af:	8b 45 e0             	mov    -0x20(%ebp),%eax
801007b2:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801007b5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801007b8:	e9 27 ff ff ff       	jmp    801006e4 <cprintf+0x84>
801007bd:	8d 76 00             	lea    0x0(%esi),%esi
      consputc('%');
801007c0:	b8 25 00 00 00       	mov    $0x25,%eax
801007c5:	e8 46 fc ff ff       	call   80100410 <consputc>
      break;
801007ca:	e9 15 ff ff ff       	jmp    801006e4 <cprintf+0x84>
801007cf:	90                   	nop
        s = "(null)";
801007d0:	ba 18 90 10 80       	mov    $0x80109018,%edx
      for(; *s; s++)
801007d5:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
801007d8:	b8 28 00 00 00       	mov    $0x28,%eax
801007dd:	89 d3                	mov    %edx,%ebx
801007df:	eb bf                	jmp    801007a0 <cprintf+0x140>
801007e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&cons.lock);
801007e8:	83 ec 0c             	sub    $0xc,%esp
801007eb:	68 20 c5 10 80       	push   $0x8010c520
801007f0:	e8 0b 4f 00 00       	call   80105700 <acquire>
801007f5:	83 c4 10             	add    $0x10,%esp
801007f8:	e9 7c fe ff ff       	jmp    80100679 <cprintf+0x19>
    panic("null fmt");
801007fd:	83 ec 0c             	sub    $0xc,%esp
80100800:	68 1f 90 10 80       	push   $0x8010901f
80100805:	e8 86 fb ff ff       	call   80100390 <panic>
8010080a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100810 <consoleintr>:
{
80100810:	55                   	push   %ebp
80100811:	89 e5                	mov    %esp,%ebp
80100813:	57                   	push   %edi
80100814:	56                   	push   %esi
80100815:	53                   	push   %ebx
  int c, doprocdump = 0;
80100816:	31 f6                	xor    %esi,%esi
{
80100818:	83 ec 18             	sub    $0x18,%esp
8010081b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&cons.lock);
8010081e:	68 20 c5 10 80       	push   $0x8010c520
80100823:	e8 d8 4e 00 00       	call   80105700 <acquire>
  while((c = getc()) >= 0){
80100828:	83 c4 10             	add    $0x10,%esp
8010082b:	90                   	nop
8010082c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100830:	ff d3                	call   *%ebx
80100832:	85 c0                	test   %eax,%eax
80100834:	89 c7                	mov    %eax,%edi
80100836:	78 48                	js     80100880 <consoleintr+0x70>
    switch(c){
80100838:	83 ff 10             	cmp    $0x10,%edi
8010083b:	0f 84 e7 00 00 00    	je     80100928 <consoleintr+0x118>
80100841:	7e 5d                	jle    801008a0 <consoleintr+0x90>
80100843:	83 ff 15             	cmp    $0x15,%edi
80100846:	0f 84 ec 00 00 00    	je     80100938 <consoleintr+0x128>
8010084c:	83 ff 7f             	cmp    $0x7f,%edi
8010084f:	75 54                	jne    801008a5 <consoleintr+0x95>
      if(input.e != input.w){
80100851:	a1 a8 1f 11 80       	mov    0x80111fa8,%eax
80100856:	3b 05 a4 1f 11 80    	cmp    0x80111fa4,%eax
8010085c:	74 d2                	je     80100830 <consoleintr+0x20>
        input.e--;
8010085e:	83 e8 01             	sub    $0x1,%eax
80100861:	a3 a8 1f 11 80       	mov    %eax,0x80111fa8
        consputc(BACKSPACE);
80100866:	b8 00 01 00 00       	mov    $0x100,%eax
8010086b:	e8 a0 fb ff ff       	call   80100410 <consputc>
  while((c = getc()) >= 0){
80100870:	ff d3                	call   *%ebx
80100872:	85 c0                	test   %eax,%eax
80100874:	89 c7                	mov    %eax,%edi
80100876:	79 c0                	jns    80100838 <consoleintr+0x28>
80100878:	90                   	nop
80100879:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  release(&cons.lock);
80100880:	83 ec 0c             	sub    $0xc,%esp
80100883:	68 20 c5 10 80       	push   $0x8010c520
80100888:	e8 33 4f 00 00       	call   801057c0 <release>
  if(doprocdump) {
8010088d:	83 c4 10             	add    $0x10,%esp
80100890:	85 f6                	test   %esi,%esi
80100892:	0f 85 f8 00 00 00    	jne    80100990 <consoleintr+0x180>
}
80100898:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010089b:	5b                   	pop    %ebx
8010089c:	5e                   	pop    %esi
8010089d:	5f                   	pop    %edi
8010089e:	5d                   	pop    %ebp
8010089f:	c3                   	ret    
    switch(c){
801008a0:	83 ff 08             	cmp    $0x8,%edi
801008a3:	74 ac                	je     80100851 <consoleintr+0x41>
      if(c != 0 && input.e-input.r < INPUT_BUF){
801008a5:	85 ff                	test   %edi,%edi
801008a7:	74 87                	je     80100830 <consoleintr+0x20>
801008a9:	a1 a8 1f 11 80       	mov    0x80111fa8,%eax
801008ae:	89 c2                	mov    %eax,%edx
801008b0:	2b 15 a0 1f 11 80    	sub    0x80111fa0,%edx
801008b6:	83 fa 7f             	cmp    $0x7f,%edx
801008b9:	0f 87 71 ff ff ff    	ja     80100830 <consoleintr+0x20>
801008bf:	8d 50 01             	lea    0x1(%eax),%edx
801008c2:	83 e0 7f             	and    $0x7f,%eax
        c = (c == '\r') ? '\n' : c;
801008c5:	83 ff 0d             	cmp    $0xd,%edi
        input.buf[input.e++ % INPUT_BUF] = c;
801008c8:	89 15 a8 1f 11 80    	mov    %edx,0x80111fa8
        c = (c == '\r') ? '\n' : c;
801008ce:	0f 84 cc 00 00 00    	je     801009a0 <consoleintr+0x190>
        input.buf[input.e++ % INPUT_BUF] = c;
801008d4:	89 f9                	mov    %edi,%ecx
801008d6:	88 88 20 1f 11 80    	mov    %cl,-0x7feee0e0(%eax)
        consputc(c);
801008dc:	89 f8                	mov    %edi,%eax
801008de:	e8 2d fb ff ff       	call   80100410 <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
801008e3:	83 ff 0a             	cmp    $0xa,%edi
801008e6:	0f 84 c5 00 00 00    	je     801009b1 <consoleintr+0x1a1>
801008ec:	83 ff 04             	cmp    $0x4,%edi
801008ef:	0f 84 bc 00 00 00    	je     801009b1 <consoleintr+0x1a1>
801008f5:	a1 a0 1f 11 80       	mov    0x80111fa0,%eax
801008fa:	83 e8 80             	sub    $0xffffff80,%eax
801008fd:	39 05 a8 1f 11 80    	cmp    %eax,0x80111fa8
80100903:	0f 85 27 ff ff ff    	jne    80100830 <consoleintr+0x20>
          wakeup(&input.r);
80100909:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
8010090c:	a3 a4 1f 11 80       	mov    %eax,0x80111fa4
          wakeup(&input.r);
80100911:	68 a0 1f 11 80       	push   $0x80111fa0
80100916:	e8 d5 43 00 00       	call   80104cf0 <wakeup>
8010091b:	83 c4 10             	add    $0x10,%esp
8010091e:	e9 0d ff ff ff       	jmp    80100830 <consoleintr+0x20>
80100923:	90                   	nop
80100924:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      doprocdump = 1;
80100928:	be 01 00 00 00       	mov    $0x1,%esi
8010092d:	e9 fe fe ff ff       	jmp    80100830 <consoleintr+0x20>
80100932:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      while(input.e != input.w &&
80100938:	a1 a8 1f 11 80       	mov    0x80111fa8,%eax
8010093d:	39 05 a4 1f 11 80    	cmp    %eax,0x80111fa4
80100943:	75 2b                	jne    80100970 <consoleintr+0x160>
80100945:	e9 e6 fe ff ff       	jmp    80100830 <consoleintr+0x20>
8010094a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        input.e--;
80100950:	a3 a8 1f 11 80       	mov    %eax,0x80111fa8
        consputc(BACKSPACE);
80100955:	b8 00 01 00 00       	mov    $0x100,%eax
8010095a:	e8 b1 fa ff ff       	call   80100410 <consputc>
      while(input.e != input.w &&
8010095f:	a1 a8 1f 11 80       	mov    0x80111fa8,%eax
80100964:	3b 05 a4 1f 11 80    	cmp    0x80111fa4,%eax
8010096a:	0f 84 c0 fe ff ff    	je     80100830 <consoleintr+0x20>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100970:	83 e8 01             	sub    $0x1,%eax
80100973:	89 c2                	mov    %eax,%edx
80100975:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100978:	80 ba 20 1f 11 80 0a 	cmpb   $0xa,-0x7feee0e0(%edx)
8010097f:	75 cf                	jne    80100950 <consoleintr+0x140>
80100981:	e9 aa fe ff ff       	jmp    80100830 <consoleintr+0x20>
80100986:	8d 76 00             	lea    0x0(%esi),%esi
80100989:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
}
80100990:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100993:	5b                   	pop    %ebx
80100994:	5e                   	pop    %esi
80100995:	5f                   	pop    %edi
80100996:	5d                   	pop    %ebp
    procdump();  // now call procdump() wo. cons.lock held
80100997:	e9 34 44 00 00       	jmp    80104dd0 <procdump>
8010099c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        input.buf[input.e++ % INPUT_BUF] = c;
801009a0:	c6 80 20 1f 11 80 0a 	movb   $0xa,-0x7feee0e0(%eax)
        consputc(c);
801009a7:	b8 0a 00 00 00       	mov    $0xa,%eax
801009ac:	e8 5f fa ff ff       	call   80100410 <consputc>
801009b1:	a1 a8 1f 11 80       	mov    0x80111fa8,%eax
801009b6:	e9 4e ff ff ff       	jmp    80100909 <consoleintr+0xf9>
801009bb:	90                   	nop
801009bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801009c0 <consoleinit>:

void
consoleinit(void)
{
801009c0:	55                   	push   %ebp
801009c1:	89 e5                	mov    %esp,%ebp
801009c3:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
801009c6:	68 28 90 10 80       	push   $0x80109028
801009cb:	68 20 c5 10 80       	push   $0x8010c520
801009d0:	e8 eb 4b 00 00       	call   801055c0 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
801009d5:	58                   	pop    %eax
801009d6:	5a                   	pop    %edx
801009d7:	6a 00                	push   $0x0
801009d9:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
801009db:	c7 05 6c 29 11 80 00 	movl   $0x80100600,0x8011296c
801009e2:	06 10 80 
  devsw[CONSOLE].read = consoleread;
801009e5:	c7 05 68 29 11 80 70 	movl   $0x80100270,0x80112968
801009ec:	02 10 80 
  cons.locking = 1;
801009ef:	c7 05 54 c5 10 80 01 	movl   $0x1,0x8010c554
801009f6:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
801009f9:	e8 02 1f 00 00       	call   80102900 <ioapicenable>
}
801009fe:	83 c4 10             	add    $0x10,%esp
80100a01:	c9                   	leave  
80100a02:	c3                   	ret    
80100a03:	66 90                	xchg   %ax,%ax
80100a05:	66 90                	xchg   %ax,%ax
80100a07:	66 90                	xchg   %ax,%ax
80100a09:	66 90                	xchg   %ax,%ax
80100a0b:	66 90                	xchg   %ax,%ax
80100a0d:	66 90                	xchg   %ax,%ax
80100a0f:	90                   	nop

80100a10 <exec>:

extern int nextpid;

int
exec(char *path, char **argv)
{
80100a10:	55                   	push   %ebp
80100a11:	89 e5                	mov    %esp,%ebp
80100a13:	57                   	push   %edi
80100a14:	56                   	push   %esi
80100a15:	53                   	push   %ebx
80100a16:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80100a1c:	e8 8f 38 00 00       	call   801042b0 <myproc>
  int isMaster = 1;

  // If it is not master thread.
  if(curproc->tid != 1)
80100a21:	8b b8 8c 00 00 00    	mov    0x8c(%eax),%edi
  struct proc *curproc = myproc();
80100a27:	89 c6                	mov    %eax,%esi
  if(curproc->tid != 1)
80100a29:	83 ff 01             	cmp    $0x1,%edi
80100a2c:	74 0e                	je     80100a3c <exec+0x2c>
  {
    isMaster = 0;
    exec_delete_thread(curproc);
80100a2e:	83 ec 0c             	sub    $0xc,%esp
    isMaster = 0;
80100a31:	31 ff                	xor    %edi,%edi
    exec_delete_thread(curproc);
80100a33:	50                   	push   %eax
80100a34:	e8 e7 34 00 00       	call   80103f20 <exec_delete_thread>
80100a39:	83 c4 10             	add    $0x10,%esp
  }

  begin_op();
80100a3c:	e8 2f 28 00 00       	call   80103270 <begin_op>

  if((ip = namei(path)) == 0){
80100a41:	83 ec 0c             	sub    $0xc,%esp
80100a44:	ff 75 08             	pushl  0x8(%ebp)
80100a47:	e8 c4 1a 00 00       	call   80102510 <namei>
80100a4c:	83 c4 10             	add    $0x10,%esp
80100a4f:	85 c0                	test   %eax,%eax
80100a51:	89 c3                	mov    %eax,%ebx
80100a53:	0f 84 ca 01 00 00    	je     80100c23 <exec+0x213>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100a59:	83 ec 0c             	sub    $0xc,%esp
80100a5c:	50                   	push   %eax
80100a5d:	e8 6e 10 00 00       	call   80101ad0 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100a62:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100a68:	6a 34                	push   $0x34
80100a6a:	6a 00                	push   $0x0
80100a6c:	50                   	push   %eax
80100a6d:	53                   	push   %ebx
80100a6e:	e8 1d 15 00 00       	call   80101f90 <readi>
80100a73:	83 c4 20             	add    $0x20,%esp
80100a76:	83 f8 34             	cmp    $0x34,%eax
80100a79:	74 25                	je     80100aa0 <exec+0x90>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100a7b:	83 ec 0c             	sub    $0xc,%esp
80100a7e:	53                   	push   %ebx
80100a7f:	e8 bc 14 00 00       	call   80101f40 <iunlockput>
    end_op();
80100a84:	e8 97 28 00 00       	call   80103320 <end_op>
80100a89:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
80100a8c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100a91:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100a94:	5b                   	pop    %ebx
80100a95:	5e                   	pop    %esi
80100a96:	5f                   	pop    %edi
80100a97:	5d                   	pop    %ebp
80100a98:	c3                   	ret    
80100a99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(elf.magic != ELF_MAGIC)
80100aa0:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100aa7:	45 4c 46 
80100aaa:	75 cf                	jne    80100a7b <exec+0x6b>
  if((pgdir = setupkvm()) == 0)
80100aac:	e8 ef 78 00 00       	call   801083a0 <setupkvm>
80100ab1:	85 c0                	test   %eax,%eax
80100ab3:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80100ab9:	74 c0                	je     80100a7b <exec+0x6b>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100abb:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100ac2:	00 
80100ac3:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
80100ac9:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100acf:	0f 84 17 03 00 00    	je     80100dec <exec+0x3dc>
  sz = 0;
80100ad5:	31 d2                	xor    %edx,%edx
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100ad7:	31 c0                	xor    %eax,%eax
80100ad9:	89 bd ec fe ff ff    	mov    %edi,-0x114(%ebp)
80100adf:	89 b5 e8 fe ff ff    	mov    %esi,-0x118(%ebp)
80100ae5:	89 d7                	mov    %edx,%edi
80100ae7:	89 c6                	mov    %eax,%esi
80100ae9:	eb 7f                	jmp    80100b6a <exec+0x15a>
80100aeb:	90                   	nop
80100aec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ph.type != ELF_PROG_LOAD)
80100af0:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100af7:	75 63                	jne    80100b5c <exec+0x14c>
    if(ph.memsz < ph.filesz)
80100af9:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100aff:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100b05:	0f 82 86 00 00 00    	jb     80100b91 <exec+0x181>
80100b0b:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100b11:	72 7e                	jb     80100b91 <exec+0x181>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100b13:	83 ec 04             	sub    $0x4,%esp
80100b16:	50                   	push   %eax
80100b17:	57                   	push   %edi
80100b18:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100b1e:	e8 9d 76 00 00       	call   801081c0 <allocuvm>
80100b23:	83 c4 10             	add    $0x10,%esp
80100b26:	85 c0                	test   %eax,%eax
80100b28:	89 c7                	mov    %eax,%edi
80100b2a:	74 65                	je     80100b91 <exec+0x181>
    if(ph.vaddr % PGSIZE != 0)
80100b2c:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100b32:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100b37:	75 58                	jne    80100b91 <exec+0x181>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100b39:	83 ec 0c             	sub    $0xc,%esp
80100b3c:	ff b5 14 ff ff ff    	pushl  -0xec(%ebp)
80100b42:	ff b5 08 ff ff ff    	pushl  -0xf8(%ebp)
80100b48:	53                   	push   %ebx
80100b49:	50                   	push   %eax
80100b4a:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100b50:	e8 ab 75 00 00       	call   80108100 <loaduvm>
80100b55:	83 c4 20             	add    $0x20,%esp
80100b58:	85 c0                	test   %eax,%eax
80100b5a:	78 35                	js     80100b91 <exec+0x181>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b5c:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100b63:	83 c6 01             	add    $0x1,%esi
80100b66:	39 f0                	cmp    %esi,%eax
80100b68:	7e 3d                	jle    80100ba7 <exec+0x197>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100b6a:	89 f0                	mov    %esi,%eax
80100b6c:	6a 20                	push   $0x20
80100b6e:	c1 e0 05             	shl    $0x5,%eax
80100b71:	03 85 f0 fe ff ff    	add    -0x110(%ebp),%eax
80100b77:	50                   	push   %eax
80100b78:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100b7e:	50                   	push   %eax
80100b7f:	53                   	push   %ebx
80100b80:	e8 0b 14 00 00       	call   80101f90 <readi>
80100b85:	83 c4 10             	add    $0x10,%esp
80100b88:	83 f8 20             	cmp    $0x20,%eax
80100b8b:	0f 84 5f ff ff ff    	je     80100af0 <exec+0xe0>
    freevm(pgdir);
80100b91:	83 ec 0c             	sub    $0xc,%esp
80100b94:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100b9a:	e8 81 77 00 00       	call   80108320 <freevm>
80100b9f:	83 c4 10             	add    $0x10,%esp
80100ba2:	e9 d4 fe ff ff       	jmp    80100a7b <exec+0x6b>
80100ba7:	89 f8                	mov    %edi,%eax
80100ba9:	8b b5 e8 fe ff ff    	mov    -0x118(%ebp),%esi
80100baf:	8b bd ec fe ff ff    	mov    -0x114(%ebp),%edi
80100bb5:	05 ff 0f 00 00       	add    $0xfff,%eax
80100bba:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80100bbf:	8d 90 00 20 00 00    	lea    0x2000(%eax),%edx
  iunlockput(ip);
80100bc5:	83 ec 0c             	sub    $0xc,%esp
80100bc8:	89 95 ec fe ff ff    	mov    %edx,-0x114(%ebp)
80100bce:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100bd4:	53                   	push   %ebx
80100bd5:	e8 66 13 00 00       	call   80101f40 <iunlockput>
  end_op();
80100bda:	e8 41 27 00 00       	call   80103320 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100bdf:	8b 95 ec fe ff ff    	mov    -0x114(%ebp),%edx
80100be5:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100beb:	83 c4 0c             	add    $0xc,%esp
80100bee:	52                   	push   %edx
80100bef:	50                   	push   %eax
80100bf0:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100bf6:	e8 c5 75 00 00       	call   801081c0 <allocuvm>
80100bfb:	83 c4 10             	add    $0x10,%esp
80100bfe:	85 c0                	test   %eax,%eax
80100c00:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100c06:	75 3a                	jne    80100c42 <exec+0x232>
    freevm(pgdir);
80100c08:	83 ec 0c             	sub    $0xc,%esp
80100c0b:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100c11:	e8 0a 77 00 00       	call   80108320 <freevm>
80100c16:	83 c4 10             	add    $0x10,%esp
  return -1;
80100c19:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100c1e:	e9 6e fe ff ff       	jmp    80100a91 <exec+0x81>
    end_op();
80100c23:	e8 f8 26 00 00       	call   80103320 <end_op>
    cprintf("exec: fail\n");
80100c28:	83 ec 0c             	sub    $0xc,%esp
80100c2b:	68 41 90 10 80       	push   $0x80109041
80100c30:	e8 2b fa ff ff       	call   80100660 <cprintf>
    return -1;
80100c35:	83 c4 10             	add    $0x10,%esp
80100c38:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100c3d:	e9 4f fe ff ff       	jmp    80100a91 <exec+0x81>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c42:	89 c3                	mov    %eax,%ebx
80100c44:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
80100c4a:	83 ec 08             	sub    $0x8,%esp
80100c4d:	50                   	push   %eax
80100c4e:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100c54:	e8 e7 77 00 00       	call   80108440 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80100c59:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c5c:	83 c4 10             	add    $0x10,%esp
80100c5f:	31 d2                	xor    %edx,%edx
80100c61:	8b 00                	mov    (%eax),%eax
80100c63:	85 c0                	test   %eax,%eax
80100c65:	0f 84 8d 01 00 00    	je     80100df8 <exec+0x3e8>
80100c6b:	89 bd ec fe ff ff    	mov    %edi,-0x114(%ebp)
80100c71:	89 b5 e8 fe ff ff    	mov    %esi,-0x118(%ebp)
80100c77:	89 d6                	mov    %edx,%esi
80100c79:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100c7f:	eb 10                	jmp    80100c91 <exec+0x281>
80100c81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(argc >= MAXARG)
80100c88:	83 fe 20             	cmp    $0x20,%esi
80100c8b:	0f 84 77 ff ff ff    	je     80100c08 <exec+0x1f8>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c91:	83 ec 0c             	sub    $0xc,%esp
80100c94:	50                   	push   %eax
80100c95:	e8 96 4d 00 00       	call   80105a30 <strlen>
80100c9a:	f7 d0                	not    %eax
80100c9c:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c9e:	8b 45 0c             	mov    0xc(%ebp),%eax
80100ca1:	5a                   	pop    %edx
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100ca2:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100ca5:	ff 34 b0             	pushl  (%eax,%esi,4)
80100ca8:	e8 83 4d 00 00       	call   80105a30 <strlen>
80100cad:	83 c0 01             	add    $0x1,%eax
80100cb0:	50                   	push   %eax
80100cb1:	8b 45 0c             	mov    0xc(%ebp),%eax
80100cb4:	ff 34 b0             	pushl  (%eax,%esi,4)
80100cb7:	53                   	push   %ebx
80100cb8:	57                   	push   %edi
80100cb9:	e8 e2 78 00 00       	call   801085a0 <copyout>
80100cbe:	83 c4 20             	add    $0x20,%esp
80100cc1:	85 c0                	test   %eax,%eax
80100cc3:	0f 88 3f ff ff ff    	js     80100c08 <exec+0x1f8>
  for(argc = 0; argv[argc]; argc++) {
80100cc9:	8b 45 0c             	mov    0xc(%ebp),%eax
    ustack[3+argc] = sp;
80100ccc:	89 9c b5 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%esi,4)
  for(argc = 0; argv[argc]; argc++) {
80100cd3:	83 c6 01             	add    $0x1,%esi
    ustack[3+argc] = sp;
80100cd6:	8d 8d 58 ff ff ff    	lea    -0xa8(%ebp),%ecx
  for(argc = 0; argv[argc]; argc++) {
80100cdc:	8b 04 b0             	mov    (%eax,%esi,4),%eax
80100cdf:	85 c0                	test   %eax,%eax
80100ce1:	75 a5                	jne    80100c88 <exec+0x278>
80100ce3:	89 f2                	mov    %esi,%edx
80100ce5:	8b bd ec fe ff ff    	mov    -0x114(%ebp),%edi
80100ceb:	8b b5 e8 fe ff ff    	mov    -0x118(%ebp),%esi
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100cf1:	8d 04 95 04 00 00 00 	lea    0x4(,%edx,4),%eax
  ustack[3+argc] = 0;
80100cf8:	c7 84 95 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edx,4)
80100cff:	00 00 00 00 
  ustack[1] = argc;
80100d03:	89 95 5c ff ff ff    	mov    %edx,-0xa4(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d09:	89 da                	mov    %ebx,%edx
  ustack[0] = 0xffffffff;  // fake return PC
80100d0b:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100d12:	ff ff ff 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d15:	29 c2                	sub    %eax,%edx
  sp -= (3+argc+1) * 4;
80100d17:	83 c0 0c             	add    $0xc,%eax
80100d1a:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100d1c:	50                   	push   %eax
80100d1d:	51                   	push   %ecx
80100d1e:	53                   	push   %ebx
80100d1f:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d25:	89 95 60 ff ff ff    	mov    %edx,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100d2b:	e8 70 78 00 00       	call   801085a0 <copyout>
80100d30:	83 c4 10             	add    $0x10,%esp
80100d33:	85 c0                	test   %eax,%eax
80100d35:	0f 88 cd fe ff ff    	js     80100c08 <exec+0x1f8>
  for(last=s=path; *s; s++)
80100d3b:	8b 45 08             	mov    0x8(%ebp),%eax
80100d3e:	0f b6 00             	movzbl (%eax),%eax
80100d41:	84 c0                	test   %al,%al
80100d43:	74 17                	je     80100d5c <exec+0x34c>
80100d45:	8b 55 08             	mov    0x8(%ebp),%edx
80100d48:	89 d1                	mov    %edx,%ecx
80100d4a:	83 c1 01             	add    $0x1,%ecx
80100d4d:	3c 2f                	cmp    $0x2f,%al
80100d4f:	0f b6 01             	movzbl (%ecx),%eax
80100d52:	0f 44 d1             	cmove  %ecx,%edx
80100d55:	84 c0                	test   %al,%al
80100d57:	75 f1                	jne    80100d4a <exec+0x33a>
80100d59:	89 55 08             	mov    %edx,0x8(%ebp)
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100d5c:	50                   	push   %eax
80100d5d:	8d 46 6c             	lea    0x6c(%esi),%eax
80100d60:	6a 10                	push   $0x10
80100d62:	ff 75 08             	pushl  0x8(%ebp)
80100d65:	50                   	push   %eax
80100d66:	e8 85 4c 00 00       	call   801059f0 <safestrcpy>
  oldpgdir = curproc->pgdir;
80100d6b:	8b 46 04             	mov    0x4(%esi),%eax
  curproc->tf->eip = elf.entry;  // main
80100d6e:	8b 56 18             	mov    0x18(%esi),%edx
  oldpgdir = curproc->pgdir;
80100d71:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)
  curproc->pgdir = pgdir;
80100d77:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
80100d7d:	89 46 04             	mov    %eax,0x4(%esi)
  curproc->sz = sz;
80100d80:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100d86:	89 06                	mov    %eax,(%esi)
  curproc->tf->eip = elf.entry;  // main
80100d88:	8b 8d 3c ff ff ff    	mov    -0xc4(%ebp),%ecx
80100d8e:	89 4a 38             	mov    %ecx,0x38(%edx)
  curproc->tf->esp = sp;
80100d91:	8b 56 18             	mov    0x18(%esi),%edx
80100d94:	89 5a 44             	mov    %ebx,0x44(%edx)
  switchuvm(curproc);
80100d97:	89 34 24             	mov    %esi,(%esp)
80100d9a:	e8 d1 70 00 00       	call   80107e70 <switchuvm>
  if(isMaster)
80100d9f:	83 c4 10             	add    $0x10,%esp
80100da2:	85 ff                	test   %edi,%edi
80100da4:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
80100daa:	74 0c                	je     80100db8 <exec+0x3a8>
    freevm(oldpgdir);
80100dac:	83 ec 0c             	sub    $0xc,%esp
80100daf:	50                   	push   %eax
80100db0:	e8 6b 75 00 00       	call   80108320 <freevm>
80100db5:	83 c4 10             	add    $0x10,%esp
  acquire(&ptable.lock);
80100db8:	83 ec 0c             	sub    $0xc,%esp
80100dbb:	68 40 5f 11 80       	push   $0x80115f40
80100dc0:	e8 3b 49 00 00       	call   80105700 <acquire>
  if(curproc->state == SLEEPING)
80100dc5:	83 c4 10             	add    $0x10,%esp
80100dc8:	83 7e 0c 02          	cmpl   $0x2,0xc(%esi)
80100dcc:	75 07                	jne    80100dd5 <exec+0x3c5>
    curproc->state = RUNNABLE;
80100dce:	c7 46 0c 03 00 00 00 	movl   $0x3,0xc(%esi)
  release(&ptable.lock);
80100dd5:	83 ec 0c             	sub    $0xc,%esp
80100dd8:	68 40 5f 11 80       	push   $0x80115f40
80100ddd:	e8 de 49 00 00       	call   801057c0 <release>
  return 0;
80100de2:	83 c4 10             	add    $0x10,%esp
80100de5:	31 c0                	xor    %eax,%eax
80100de7:	e9 a5 fc ff ff       	jmp    80100a91 <exec+0x81>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100dec:	31 c0                	xor    %eax,%eax
80100dee:	ba 00 20 00 00       	mov    $0x2000,%edx
80100df3:	e9 cd fd ff ff       	jmp    80100bc5 <exec+0x1b5>
  for(argc = 0; argv[argc]; argc++) {
80100df8:	8b 9d f0 fe ff ff    	mov    -0x110(%ebp),%ebx
80100dfe:	8d 8d 58 ff ff ff    	lea    -0xa8(%ebp),%ecx
80100e04:	e9 e8 fe ff ff       	jmp    80100cf1 <exec+0x2e1>
80100e09:	66 90                	xchg   %ax,%ax
80100e0b:	66 90                	xchg   %ax,%ax
80100e0d:	66 90                	xchg   %ax,%ax
80100e0f:	90                   	nop

80100e10 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100e10:	55                   	push   %ebp
80100e11:	89 e5                	mov    %esp,%ebp
80100e13:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100e16:	68 4d 90 10 80       	push   $0x8010904d
80100e1b:	68 c0 1f 11 80       	push   $0x80111fc0
80100e20:	e8 9b 47 00 00       	call   801055c0 <initlock>
}
80100e25:	83 c4 10             	add    $0x10,%esp
80100e28:	c9                   	leave  
80100e29:	c3                   	ret    
80100e2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100e30 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100e30:	55                   	push   %ebp
80100e31:	89 e5                	mov    %esp,%ebp
80100e33:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e34:	bb f4 1f 11 80       	mov    $0x80111ff4,%ebx
{
80100e39:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80100e3c:	68 c0 1f 11 80       	push   $0x80111fc0
80100e41:	e8 ba 48 00 00       	call   80105700 <acquire>
80100e46:	83 c4 10             	add    $0x10,%esp
80100e49:	eb 10                	jmp    80100e5b <filealloc+0x2b>
80100e4b:	90                   	nop
80100e4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e50:	83 c3 18             	add    $0x18,%ebx
80100e53:	81 fb 54 29 11 80    	cmp    $0x80112954,%ebx
80100e59:	73 25                	jae    80100e80 <filealloc+0x50>
    if(f->ref == 0){
80100e5b:	8b 43 04             	mov    0x4(%ebx),%eax
80100e5e:	85 c0                	test   %eax,%eax
80100e60:	75 ee                	jne    80100e50 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100e62:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80100e65:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100e6c:	68 c0 1f 11 80       	push   $0x80111fc0
80100e71:	e8 4a 49 00 00       	call   801057c0 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80100e76:	89 d8                	mov    %ebx,%eax
      return f;
80100e78:	83 c4 10             	add    $0x10,%esp
}
80100e7b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e7e:	c9                   	leave  
80100e7f:	c3                   	ret    
  release(&ftable.lock);
80100e80:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80100e83:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80100e85:	68 c0 1f 11 80       	push   $0x80111fc0
80100e8a:	e8 31 49 00 00       	call   801057c0 <release>
}
80100e8f:	89 d8                	mov    %ebx,%eax
  return 0;
80100e91:	83 c4 10             	add    $0x10,%esp
}
80100e94:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e97:	c9                   	leave  
80100e98:	c3                   	ret    
80100e99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100ea0 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100ea0:	55                   	push   %ebp
80100ea1:	89 e5                	mov    %esp,%ebp
80100ea3:	53                   	push   %ebx
80100ea4:	83 ec 10             	sub    $0x10,%esp
80100ea7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100eaa:	68 c0 1f 11 80       	push   $0x80111fc0
80100eaf:	e8 4c 48 00 00       	call   80105700 <acquire>
  if(f->ref < 1)
80100eb4:	8b 43 04             	mov    0x4(%ebx),%eax
80100eb7:	83 c4 10             	add    $0x10,%esp
80100eba:	85 c0                	test   %eax,%eax
80100ebc:	7e 1a                	jle    80100ed8 <filedup+0x38>
    panic("filedup");
  f->ref++;
80100ebe:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80100ec1:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
80100ec4:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100ec7:	68 c0 1f 11 80       	push   $0x80111fc0
80100ecc:	e8 ef 48 00 00       	call   801057c0 <release>
  return f;
}
80100ed1:	89 d8                	mov    %ebx,%eax
80100ed3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100ed6:	c9                   	leave  
80100ed7:	c3                   	ret    
    panic("filedup");
80100ed8:	83 ec 0c             	sub    $0xc,%esp
80100edb:	68 54 90 10 80       	push   $0x80109054
80100ee0:	e8 ab f4 ff ff       	call   80100390 <panic>
80100ee5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100ee9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100ef0 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100ef0:	55                   	push   %ebp
80100ef1:	89 e5                	mov    %esp,%ebp
80100ef3:	57                   	push   %edi
80100ef4:	56                   	push   %esi
80100ef5:	53                   	push   %ebx
80100ef6:	83 ec 28             	sub    $0x28,%esp
80100ef9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
80100efc:	68 c0 1f 11 80       	push   $0x80111fc0
80100f01:	e8 fa 47 00 00       	call   80105700 <acquire>
  if(f->ref < 1)
80100f06:	8b 43 04             	mov    0x4(%ebx),%eax
80100f09:	83 c4 10             	add    $0x10,%esp
80100f0c:	85 c0                	test   %eax,%eax
80100f0e:	0f 8e 9b 00 00 00    	jle    80100faf <fileclose+0xbf>
    panic("fileclose");
  if(--f->ref > 0){
80100f14:	83 e8 01             	sub    $0x1,%eax
80100f17:	85 c0                	test   %eax,%eax
80100f19:	89 43 04             	mov    %eax,0x4(%ebx)
80100f1c:	74 1a                	je     80100f38 <fileclose+0x48>
    release(&ftable.lock);
80100f1e:	c7 45 08 c0 1f 11 80 	movl   $0x80111fc0,0x8(%ebp)
  else if(ff.type == FD_INODE){
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100f25:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f28:	5b                   	pop    %ebx
80100f29:	5e                   	pop    %esi
80100f2a:	5f                   	pop    %edi
80100f2b:	5d                   	pop    %ebp
    release(&ftable.lock);
80100f2c:	e9 8f 48 00 00       	jmp    801057c0 <release>
80100f31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  ff = *f;
80100f38:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
80100f3c:	8b 3b                	mov    (%ebx),%edi
  release(&ftable.lock);
80100f3e:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80100f41:	8b 73 0c             	mov    0xc(%ebx),%esi
  f->type = FD_NONE;
80100f44:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
80100f4a:	88 45 e7             	mov    %al,-0x19(%ebp)
80100f4d:	8b 43 10             	mov    0x10(%ebx),%eax
  release(&ftable.lock);
80100f50:	68 c0 1f 11 80       	push   $0x80111fc0
  ff = *f;
80100f55:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80100f58:	e8 63 48 00 00       	call   801057c0 <release>
  if(ff.type == FD_PIPE)
80100f5d:	83 c4 10             	add    $0x10,%esp
80100f60:	83 ff 01             	cmp    $0x1,%edi
80100f63:	74 13                	je     80100f78 <fileclose+0x88>
  else if(ff.type == FD_INODE){
80100f65:	83 ff 02             	cmp    $0x2,%edi
80100f68:	74 26                	je     80100f90 <fileclose+0xa0>
}
80100f6a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f6d:	5b                   	pop    %ebx
80100f6e:	5e                   	pop    %esi
80100f6f:	5f                   	pop    %edi
80100f70:	5d                   	pop    %ebp
80100f71:	c3                   	ret    
80100f72:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pipeclose(ff.pipe, ff.writable);
80100f78:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80100f7c:	83 ec 08             	sub    $0x8,%esp
80100f7f:	53                   	push   %ebx
80100f80:	56                   	push   %esi
80100f81:	e8 6a 2b 00 00       	call   80103af0 <pipeclose>
80100f86:	83 c4 10             	add    $0x10,%esp
80100f89:	eb df                	jmp    80100f6a <fileclose+0x7a>
80100f8b:	90                   	nop
80100f8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    begin_op();
80100f90:	e8 db 22 00 00       	call   80103270 <begin_op>
    iput(ff.ip);
80100f95:	83 ec 0c             	sub    $0xc,%esp
80100f98:	ff 75 e0             	pushl  -0x20(%ebp)
80100f9b:	e8 60 0c 00 00       	call   80101c00 <iput>
    end_op();
80100fa0:	83 c4 10             	add    $0x10,%esp
}
80100fa3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fa6:	5b                   	pop    %ebx
80100fa7:	5e                   	pop    %esi
80100fa8:	5f                   	pop    %edi
80100fa9:	5d                   	pop    %ebp
    end_op();
80100faa:	e9 71 23 00 00       	jmp    80103320 <end_op>
    panic("fileclose");
80100faf:	83 ec 0c             	sub    $0xc,%esp
80100fb2:	68 5c 90 10 80       	push   $0x8010905c
80100fb7:	e8 d4 f3 ff ff       	call   80100390 <panic>
80100fbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100fc0 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100fc0:	55                   	push   %ebp
80100fc1:	89 e5                	mov    %esp,%ebp
80100fc3:	53                   	push   %ebx
80100fc4:	83 ec 04             	sub    $0x4,%esp
80100fc7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100fca:	83 3b 02             	cmpl   $0x2,(%ebx)
80100fcd:	75 31                	jne    80101000 <filestat+0x40>
    ilock(f->ip);
80100fcf:	83 ec 0c             	sub    $0xc,%esp
80100fd2:	ff 73 10             	pushl  0x10(%ebx)
80100fd5:	e8 f6 0a 00 00       	call   80101ad0 <ilock>
    stati(f->ip, st);
80100fda:	58                   	pop    %eax
80100fdb:	5a                   	pop    %edx
80100fdc:	ff 75 0c             	pushl  0xc(%ebp)
80100fdf:	ff 73 10             	pushl  0x10(%ebx)
80100fe2:	e8 79 0f 00 00       	call   80101f60 <stati>
    iunlock(f->ip);
80100fe7:	59                   	pop    %ecx
80100fe8:	ff 73 10             	pushl  0x10(%ebx)
80100feb:	e8 c0 0b 00 00       	call   80101bb0 <iunlock>
    return 0;
80100ff0:	83 c4 10             	add    $0x10,%esp
80100ff3:	31 c0                	xor    %eax,%eax
  }
  return -1;
}
80100ff5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100ff8:	c9                   	leave  
80100ff9:	c3                   	ret    
80100ffa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return -1;
80101000:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101005:	eb ee                	jmp    80100ff5 <filestat+0x35>
80101007:	89 f6                	mov    %esi,%esi
80101009:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101010 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80101010:	55                   	push   %ebp
80101011:	89 e5                	mov    %esp,%ebp
80101013:	57                   	push   %edi
80101014:	56                   	push   %esi
80101015:	53                   	push   %ebx
80101016:	83 ec 0c             	sub    $0xc,%esp
80101019:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010101c:	8b 75 0c             	mov    0xc(%ebp),%esi
8010101f:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80101022:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80101026:	74 60                	je     80101088 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
80101028:	8b 03                	mov    (%ebx),%eax
8010102a:	83 f8 01             	cmp    $0x1,%eax
8010102d:	74 41                	je     80101070 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010102f:	83 f8 02             	cmp    $0x2,%eax
80101032:	75 5b                	jne    8010108f <fileread+0x7f>
    ilock(f->ip);
80101034:	83 ec 0c             	sub    $0xc,%esp
80101037:	ff 73 10             	pushl  0x10(%ebx)
8010103a:	e8 91 0a 00 00       	call   80101ad0 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
8010103f:	57                   	push   %edi
80101040:	ff 73 14             	pushl  0x14(%ebx)
80101043:	56                   	push   %esi
80101044:	ff 73 10             	pushl  0x10(%ebx)
80101047:	e8 44 0f 00 00       	call   80101f90 <readi>
8010104c:	83 c4 20             	add    $0x20,%esp
8010104f:	85 c0                	test   %eax,%eax
80101051:	89 c6                	mov    %eax,%esi
80101053:	7e 03                	jle    80101058 <fileread+0x48>
      f->off += r;
80101055:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80101058:	83 ec 0c             	sub    $0xc,%esp
8010105b:	ff 73 10             	pushl  0x10(%ebx)
8010105e:	e8 4d 0b 00 00       	call   80101bb0 <iunlock>
    return r;
80101063:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
80101066:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101069:	89 f0                	mov    %esi,%eax
8010106b:	5b                   	pop    %ebx
8010106c:	5e                   	pop    %esi
8010106d:	5f                   	pop    %edi
8010106e:	5d                   	pop    %ebp
8010106f:	c3                   	ret    
    return piperead(f->pipe, addr, n);
80101070:	8b 43 0c             	mov    0xc(%ebx),%eax
80101073:	89 45 08             	mov    %eax,0x8(%ebp)
}
80101076:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101079:	5b                   	pop    %ebx
8010107a:	5e                   	pop    %esi
8010107b:	5f                   	pop    %edi
8010107c:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
8010107d:	e9 1e 2c 00 00       	jmp    80103ca0 <piperead>
80101082:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80101088:	be ff ff ff ff       	mov    $0xffffffff,%esi
8010108d:	eb d7                	jmp    80101066 <fileread+0x56>
  panic("fileread");
8010108f:	83 ec 0c             	sub    $0xc,%esp
80101092:	68 66 90 10 80       	push   $0x80109066
80101097:	e8 f4 f2 ff ff       	call   80100390 <panic>
8010109c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801010a0 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
801010a0:	55                   	push   %ebp
801010a1:	89 e5                	mov    %esp,%ebp
801010a3:	57                   	push   %edi
801010a4:	56                   	push   %esi
801010a5:	53                   	push   %ebx
801010a6:	83 ec 1c             	sub    $0x1c,%esp
801010a9:	8b 75 08             	mov    0x8(%ebp),%esi
801010ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  int r;

  if(f->writable == 0)
801010af:	80 7e 09 00          	cmpb   $0x0,0x9(%esi)
{
801010b3:	89 45 dc             	mov    %eax,-0x24(%ebp)
801010b6:	8b 45 10             	mov    0x10(%ebp),%eax
801010b9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
801010bc:	0f 84 aa 00 00 00    	je     8010116c <filewrite+0xcc>
    return -1;
  if(f->type == FD_PIPE)
801010c2:	8b 06                	mov    (%esi),%eax
801010c4:	83 f8 01             	cmp    $0x1,%eax
801010c7:	0f 84 c3 00 00 00    	je     80101190 <filewrite+0xf0>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
801010cd:	83 f8 02             	cmp    $0x2,%eax
801010d0:	0f 85 d9 00 00 00    	jne    801011af <filewrite+0x10f>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
801010d6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
801010d9:	31 ff                	xor    %edi,%edi
    while(i < n){
801010db:	85 c0                	test   %eax,%eax
801010dd:	7f 34                	jg     80101113 <filewrite+0x73>
801010df:	e9 9c 00 00 00       	jmp    80101180 <filewrite+0xe0>
801010e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
801010e8:	01 46 14             	add    %eax,0x14(%esi)
      iunlock(f->ip);
801010eb:	83 ec 0c             	sub    $0xc,%esp
801010ee:	ff 76 10             	pushl  0x10(%esi)
        f->off += r;
801010f1:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
801010f4:	e8 b7 0a 00 00       	call   80101bb0 <iunlock>
      end_op();
801010f9:	e8 22 22 00 00       	call   80103320 <end_op>
801010fe:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101101:	83 c4 10             	add    $0x10,%esp

      if(r < 0)
        break;
      if(r != n1)
80101104:	39 c3                	cmp    %eax,%ebx
80101106:	0f 85 96 00 00 00    	jne    801011a2 <filewrite+0x102>
        panic("short filewrite");
      i += r;
8010110c:	01 df                	add    %ebx,%edi
    while(i < n){
8010110e:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101111:	7e 6d                	jle    80101180 <filewrite+0xe0>
      int n1 = n - i;
80101113:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101116:	b8 00 06 00 00       	mov    $0x600,%eax
8010111b:	29 fb                	sub    %edi,%ebx
8010111d:	81 fb 00 06 00 00    	cmp    $0x600,%ebx
80101123:	0f 4f d8             	cmovg  %eax,%ebx
      begin_op();
80101126:	e8 45 21 00 00       	call   80103270 <begin_op>
      ilock(f->ip);
8010112b:	83 ec 0c             	sub    $0xc,%esp
8010112e:	ff 76 10             	pushl  0x10(%esi)
80101131:	e8 9a 09 00 00       	call   80101ad0 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
80101136:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101139:	53                   	push   %ebx
8010113a:	ff 76 14             	pushl  0x14(%esi)
8010113d:	01 f8                	add    %edi,%eax
8010113f:	50                   	push   %eax
80101140:	ff 76 10             	pushl  0x10(%esi)
80101143:	e8 48 0f 00 00       	call   80102090 <writei>
80101148:	83 c4 20             	add    $0x20,%esp
8010114b:	85 c0                	test   %eax,%eax
8010114d:	7f 99                	jg     801010e8 <filewrite+0x48>
      iunlock(f->ip);
8010114f:	83 ec 0c             	sub    $0xc,%esp
80101152:	ff 76 10             	pushl  0x10(%esi)
80101155:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101158:	e8 53 0a 00 00       	call   80101bb0 <iunlock>
      end_op();
8010115d:	e8 be 21 00 00       	call   80103320 <end_op>
      if(r < 0)
80101162:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101165:	83 c4 10             	add    $0x10,%esp
80101168:	85 c0                	test   %eax,%eax
8010116a:	74 98                	je     80101104 <filewrite+0x64>
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
8010116c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
8010116f:	bf ff ff ff ff       	mov    $0xffffffff,%edi
}
80101174:	89 f8                	mov    %edi,%eax
80101176:	5b                   	pop    %ebx
80101177:	5e                   	pop    %esi
80101178:	5f                   	pop    %edi
80101179:	5d                   	pop    %ebp
8010117a:	c3                   	ret    
8010117b:	90                   	nop
8010117c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return i == n ? n : -1;
80101180:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101183:	75 e7                	jne    8010116c <filewrite+0xcc>
}
80101185:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101188:	89 f8                	mov    %edi,%eax
8010118a:	5b                   	pop    %ebx
8010118b:	5e                   	pop    %esi
8010118c:	5f                   	pop    %edi
8010118d:	5d                   	pop    %ebp
8010118e:	c3                   	ret    
8010118f:	90                   	nop
    return pipewrite(f->pipe, addr, n);
80101190:	8b 46 0c             	mov    0xc(%esi),%eax
80101193:	89 45 08             	mov    %eax,0x8(%ebp)
}
80101196:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101199:	5b                   	pop    %ebx
8010119a:	5e                   	pop    %esi
8010119b:	5f                   	pop    %edi
8010119c:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
8010119d:	e9 ee 29 00 00       	jmp    80103b90 <pipewrite>
        panic("short filewrite");
801011a2:	83 ec 0c             	sub    $0xc,%esp
801011a5:	68 6f 90 10 80       	push   $0x8010906f
801011aa:	e8 e1 f1 ff ff       	call   80100390 <panic>
  panic("filewrite");
801011af:	83 ec 0c             	sub    $0xc,%esp
801011b2:	68 75 90 10 80       	push   $0x80109075
801011b7:	e8 d4 f1 ff ff       	call   80100390 <panic>
801011bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801011c0 <filepwrite>:

// project 3 - milestone 2
int
filepwrite(struct file *f, void* addr, int n, int off)
{
801011c0:	55                   	push   %ebp
801011c1:	89 e5                	mov    %esp,%ebp
801011c3:	57                   	push   %edi
801011c4:	56                   	push   %esi
801011c5:	53                   	push   %ebx
801011c6:	83 ec 1c             	sub    $0x1c,%esp
801011c9:	8b 45 0c             	mov    0xc(%ebp),%eax
801011cc:	8b 75 08             	mov    0x8(%ebp),%esi
801011cf:	89 45 dc             	mov    %eax,-0x24(%ebp)
801011d2:	8b 45 10             	mov    0x10(%ebp),%eax
  int r;

  if(f->writable == 0)
801011d5:	80 7e 09 00          	cmpb   $0x0,0x9(%esi)
{
801011d9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801011dc:	8b 45 14             	mov    0x14(%ebp),%eax
801011df:	89 45 d8             	mov    %eax,-0x28(%ebp)
  if(f->writable == 0)
801011e2:	0f 84 89 00 00 00    	je     80101271 <filepwrite+0xb1>
    return -1;
  if(f->type == FD_PIPE)
801011e8:	8b 06                	mov    (%esi),%eax
801011ea:	83 f8 01             	cmp    $0x1,%eax
801011ed:	0f 84 9d 00 00 00    	je     80101290 <filepwrite+0xd0>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
801011f3:	83 f8 02             	cmp    $0x2,%eax
801011f6:	0f 85 b3 00 00 00    	jne    801012af <filepwrite+0xef>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
801011fc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
801011ff:	31 ff                	xor    %edi,%edi
    while(i < n){
80101201:	85 c0                	test   %eax,%eax
80101203:	7f 1a                	jg     8010121f <filepwrite+0x5f>
80101205:	eb 79                	jmp    80101280 <filepwrite+0xc0>
80101207:	89 f6                	mov    %esi,%esi
80101209:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      iunlock(f->ip);
      end_op();

      if(r < 0)
        break;
      if(r != n1)
80101210:	39 c3                	cmp    %eax,%ebx
80101212:	0f 85 8a 00 00 00    	jne    801012a2 <filepwrite+0xe2>
        panic("short filewrite");
      i += r;
80101218:	01 df                	add    %ebx,%edi
    while(i < n){
8010121a:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
8010121d:	7e 61                	jle    80101280 <filepwrite+0xc0>
      int n1 = n - i;
8010121f:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101222:	b8 00 06 00 00       	mov    $0x600,%eax
80101227:	29 fb                	sub    %edi,%ebx
80101229:	81 fb 00 06 00 00    	cmp    $0x600,%ebx
8010122f:	0f 4f d8             	cmovg  %eax,%ebx
      begin_op();
80101232:	e8 39 20 00 00       	call   80103270 <begin_op>
      ilock(f->ip);
80101237:	83 ec 0c             	sub    $0xc,%esp
8010123a:	ff 76 10             	pushl  0x10(%esi)
8010123d:	e8 8e 08 00 00       	call   80101ad0 <ilock>
      r = writei(f->ip, addr + i, off, n1);
80101242:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101245:	53                   	push   %ebx
80101246:	ff 75 d8             	pushl  -0x28(%ebp)
80101249:	01 f8                	add    %edi,%eax
8010124b:	50                   	push   %eax
8010124c:	ff 76 10             	pushl  0x10(%esi)
8010124f:	e8 3c 0e 00 00       	call   80102090 <writei>
      iunlock(f->ip);
80101254:	83 c4 14             	add    $0x14,%esp
80101257:	ff 76 10             	pushl  0x10(%esi)
      r = writei(f->ip, addr + i, off, n1);
8010125a:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
8010125d:	e8 4e 09 00 00       	call   80101bb0 <iunlock>
      end_op();
80101262:	e8 b9 20 00 00       	call   80103320 <end_op>
      if(r < 0)
80101267:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010126a:	83 c4 10             	add    $0x10,%esp
8010126d:	85 c0                	test   %eax,%eax
8010126f:	79 9f                	jns    80101210 <filepwrite+0x50>
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
80101271:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
80101274:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80101279:	5b                   	pop    %ebx
8010127a:	5e                   	pop    %esi
8010127b:	5f                   	pop    %edi
8010127c:	5d                   	pop    %ebp
8010127d:	c3                   	ret    
8010127e:	66 90                	xchg   %ax,%ax
    return i == n ? n : -1;
80101280:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
80101283:	75 ec                	jne    80101271 <filepwrite+0xb1>
}
80101285:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101288:	89 f8                	mov    %edi,%eax
8010128a:	5b                   	pop    %ebx
8010128b:	5e                   	pop    %esi
8010128c:	5f                   	pop    %edi
8010128d:	5d                   	pop    %ebp
8010128e:	c3                   	ret    
8010128f:	90                   	nop
    return pipewrite(f->pipe, addr, n);
80101290:	8b 46 0c             	mov    0xc(%esi),%eax
80101293:	89 45 08             	mov    %eax,0x8(%ebp)
}
80101296:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101299:	5b                   	pop    %ebx
8010129a:	5e                   	pop    %esi
8010129b:	5f                   	pop    %edi
8010129c:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
8010129d:	e9 ee 28 00 00       	jmp    80103b90 <pipewrite>
        panic("short filewrite");
801012a2:	83 ec 0c             	sub    $0xc,%esp
801012a5:	68 6f 90 10 80       	push   $0x8010906f
801012aa:	e8 e1 f0 ff ff       	call   80100390 <panic>
  panic("filewrite");
801012af:	83 ec 0c             	sub    $0xc,%esp
801012b2:	68 75 90 10 80       	push   $0x80109075
801012b7:	e8 d4 f0 ff ff       	call   80100390 <panic>
801012bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801012c0 <filepread>:

// project 3 - milestone 2
int
filepread(struct file *f, void* addr, int n, int off)
{
801012c0:	55                   	push   %ebp
801012c1:	89 e5                	mov    %esp,%ebp
801012c3:	57                   	push   %edi
801012c4:	56                   	push   %esi
801012c5:	53                   	push   %ebx
801012c6:	83 ec 1c             	sub    $0x1c,%esp
801012c9:	8b 5d 08             	mov    0x8(%ebp),%ebx
801012cc:	8b 75 0c             	mov    0xc(%ebp),%esi
801012cf:	8b 55 10             	mov    0x10(%ebp),%edx
801012d2:	8b 7d 14             	mov    0x14(%ebp),%edi
  int r;

  if(f->readable == 0)
801012d5:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
801012d9:	74 5d                	je     80101338 <filepread+0x78>
    return -1;
  if(f->type == FD_PIPE)
801012db:	8b 03                	mov    (%ebx),%eax
801012dd:	83 f8 01             	cmp    $0x1,%eax
801012e0:	74 3e                	je     80101320 <filepread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
801012e2:	83 f8 02             	cmp    $0x2,%eax
801012e5:	89 55 e4             	mov    %edx,-0x1c(%ebp)
801012e8:	75 55                	jne    8010133f <filepread+0x7f>
    ilock(f->ip);
801012ea:	83 ec 0c             	sub    $0xc,%esp
801012ed:	ff 73 10             	pushl  0x10(%ebx)
801012f0:	e8 db 07 00 00       	call   80101ad0 <ilock>
    r = readi(f->ip, addr, off, n);
801012f5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801012f8:	52                   	push   %edx
801012f9:	57                   	push   %edi
801012fa:	56                   	push   %esi
801012fb:	ff 73 10             	pushl  0x10(%ebx)
801012fe:	e8 8d 0c 00 00       	call   80101f90 <readi>
    iunlock(f->ip);
80101303:	83 c4 14             	add    $0x14,%esp
80101306:	ff 73 10             	pushl  0x10(%ebx)
    r = readi(f->ip, addr, off, n);
80101309:	89 c6                	mov    %eax,%esi
    iunlock(f->ip);
8010130b:	e8 a0 08 00 00       	call   80101bb0 <iunlock>
    return r;
80101310:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
80101313:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101316:	89 f0                	mov    %esi,%eax
80101318:	5b                   	pop    %ebx
80101319:	5e                   	pop    %esi
8010131a:	5f                   	pop    %edi
8010131b:	5d                   	pop    %ebp
8010131c:	c3                   	ret    
8010131d:	8d 76 00             	lea    0x0(%esi),%esi
    return piperead(f->pipe, addr, n);
80101320:	8b 43 0c             	mov    0xc(%ebx),%eax
80101323:	89 45 08             	mov    %eax,0x8(%ebp)
80101326:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101329:	5b                   	pop    %ebx
8010132a:	5e                   	pop    %esi
8010132b:	5f                   	pop    %edi
8010132c:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
8010132d:	e9 6e 29 00 00       	jmp    80103ca0 <piperead>
80101332:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80101338:	be ff ff ff ff       	mov    $0xffffffff,%esi
8010133d:	eb d4                	jmp    80101313 <filepread+0x53>
  panic("fileread");
8010133f:	83 ec 0c             	sub    $0xc,%esp
80101342:	68 66 90 10 80       	push   $0x80109066
80101347:	e8 44 f0 ff ff       	call   80100390 <panic>
8010134c:	66 90                	xchg   %ax,%ax
8010134e:	66 90                	xchg   %ax,%ax

80101350 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
80101350:	55                   	push   %ebp
80101351:	89 e5                	mov    %esp,%ebp
80101353:	56                   	push   %esi
80101354:	53                   	push   %ebx
80101355:	89 d3                	mov    %edx,%ebx
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
80101357:	c1 ea 0c             	shr    $0xc,%edx
8010135a:	03 15 d8 29 11 80    	add    0x801129d8,%edx
80101360:	83 ec 08             	sub    $0x8,%esp
80101363:	52                   	push   %edx
80101364:	50                   	push   %eax
80101365:	e8 66 ed ff ff       	call   801000d0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
8010136a:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
8010136c:	c1 fb 03             	sar    $0x3,%ebx
  m = 1 << (bi % 8);
8010136f:	ba 01 00 00 00       	mov    $0x1,%edx
80101374:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
80101377:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
8010137d:	83 c4 10             	add    $0x10,%esp
  m = 1 << (bi % 8);
80101380:	d3 e2                	shl    %cl,%edx
  if((bp->data[bi/8] & m) == 0)
80101382:	0f b6 4c 18 5c       	movzbl 0x5c(%eax,%ebx,1),%ecx
80101387:	85 d1                	test   %edx,%ecx
80101389:	74 25                	je     801013b0 <bfree+0x60>
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
8010138b:	f7 d2                	not    %edx
8010138d:	89 c6                	mov    %eax,%esi
  log_write(bp);
8010138f:	83 ec 0c             	sub    $0xc,%esp
  bp->data[bi/8] &= ~m;
80101392:	21 ca                	and    %ecx,%edx
80101394:	88 54 1e 5c          	mov    %dl,0x5c(%esi,%ebx,1)
  log_write(bp);
80101398:	56                   	push   %esi
80101399:	e8 72 21 00 00       	call   80103510 <log_write>
  brelse(bp);
8010139e:	89 34 24             	mov    %esi,(%esp)
801013a1:	e8 3a ee ff ff       	call   801001e0 <brelse>
}
801013a6:	83 c4 10             	add    $0x10,%esp
801013a9:	8d 65 f8             	lea    -0x8(%ebp),%esp
801013ac:	5b                   	pop    %ebx
801013ad:	5e                   	pop    %esi
801013ae:	5d                   	pop    %ebp
801013af:	c3                   	ret    
    panic("freeing free block");
801013b0:	83 ec 0c             	sub    $0xc,%esp
801013b3:	68 7f 90 10 80       	push   $0x8010907f
801013b8:	e8 d3 ef ff ff       	call   80100390 <panic>
801013bd:	8d 76 00             	lea    0x0(%esi),%esi

801013c0 <balloc>:
{
801013c0:	55                   	push   %ebp
801013c1:	89 e5                	mov    %esp,%ebp
801013c3:	57                   	push   %edi
801013c4:	56                   	push   %esi
801013c5:	53                   	push   %ebx
801013c6:	83 ec 1c             	sub    $0x1c,%esp
  for(b = 0; b < sb.size; b += BPB){
801013c9:	8b 0d c0 29 11 80    	mov    0x801129c0,%ecx
{
801013cf:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
801013d2:	85 c9                	test   %ecx,%ecx
801013d4:	0f 84 87 00 00 00    	je     80101461 <balloc+0xa1>
801013da:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
801013e1:	8b 75 dc             	mov    -0x24(%ebp),%esi
801013e4:	83 ec 08             	sub    $0x8,%esp
801013e7:	89 f0                	mov    %esi,%eax
801013e9:	c1 f8 0c             	sar    $0xc,%eax
801013ec:	03 05 d8 29 11 80    	add    0x801129d8,%eax
801013f2:	50                   	push   %eax
801013f3:	ff 75 d8             	pushl  -0x28(%ebp)
801013f6:	e8 d5 ec ff ff       	call   801000d0 <bread>
801013fb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801013fe:	a1 c0 29 11 80       	mov    0x801129c0,%eax
80101403:	83 c4 10             	add    $0x10,%esp
80101406:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101409:	31 c0                	xor    %eax,%eax
8010140b:	eb 2f                	jmp    8010143c <balloc+0x7c>
8010140d:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
80101410:	89 c1                	mov    %eax,%ecx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101412:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      m = 1 << (bi % 8);
80101415:	bb 01 00 00 00       	mov    $0x1,%ebx
8010141a:	83 e1 07             	and    $0x7,%ecx
8010141d:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010141f:	89 c1                	mov    %eax,%ecx
80101421:	c1 f9 03             	sar    $0x3,%ecx
80101424:	0f b6 7c 0a 5c       	movzbl 0x5c(%edx,%ecx,1),%edi
80101429:	85 df                	test   %ebx,%edi
8010142b:	89 fa                	mov    %edi,%edx
8010142d:	74 41                	je     80101470 <balloc+0xb0>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010142f:	83 c0 01             	add    $0x1,%eax
80101432:	83 c6 01             	add    $0x1,%esi
80101435:	3d 00 10 00 00       	cmp    $0x1000,%eax
8010143a:	74 05                	je     80101441 <balloc+0x81>
8010143c:	39 75 e0             	cmp    %esi,-0x20(%ebp)
8010143f:	77 cf                	ja     80101410 <balloc+0x50>
    brelse(bp);
80101441:	83 ec 0c             	sub    $0xc,%esp
80101444:	ff 75 e4             	pushl  -0x1c(%ebp)
80101447:	e8 94 ed ff ff       	call   801001e0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
8010144c:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
80101453:	83 c4 10             	add    $0x10,%esp
80101456:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101459:	39 05 c0 29 11 80    	cmp    %eax,0x801129c0
8010145f:	77 80                	ja     801013e1 <balloc+0x21>
  panic("balloc: out of blocks");
80101461:	83 ec 0c             	sub    $0xc,%esp
80101464:	68 92 90 10 80       	push   $0x80109092
80101469:	e8 22 ef ff ff       	call   80100390 <panic>
8010146e:	66 90                	xchg   %ax,%ax
        bp->data[bi/8] |= m;  // Mark block in use.
80101470:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
80101473:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
80101476:	09 da                	or     %ebx,%edx
80101478:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
8010147c:	57                   	push   %edi
8010147d:	e8 8e 20 00 00       	call   80103510 <log_write>
        brelse(bp);
80101482:	89 3c 24             	mov    %edi,(%esp)
80101485:	e8 56 ed ff ff       	call   801001e0 <brelse>
  bp = bread(dev, bno);
8010148a:	58                   	pop    %eax
8010148b:	5a                   	pop    %edx
8010148c:	56                   	push   %esi
8010148d:	ff 75 d8             	pushl  -0x28(%ebp)
80101490:	e8 3b ec ff ff       	call   801000d0 <bread>
80101495:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
80101497:	8d 40 5c             	lea    0x5c(%eax),%eax
8010149a:	83 c4 0c             	add    $0xc,%esp
8010149d:	68 00 02 00 00       	push   $0x200
801014a2:	6a 00                	push   $0x0
801014a4:	50                   	push   %eax
801014a5:	e8 66 43 00 00       	call   80105810 <memset>
  log_write(bp);
801014aa:	89 1c 24             	mov    %ebx,(%esp)
801014ad:	e8 5e 20 00 00       	call   80103510 <log_write>
  brelse(bp);
801014b2:	89 1c 24             	mov    %ebx,(%esp)
801014b5:	e8 26 ed ff ff       	call   801001e0 <brelse>
}
801014ba:	8d 65 f4             	lea    -0xc(%ebp),%esp
801014bd:	89 f0                	mov    %esi,%eax
801014bf:	5b                   	pop    %ebx
801014c0:	5e                   	pop    %esi
801014c1:	5f                   	pop    %edi
801014c2:	5d                   	pop    %ebp
801014c3:	c3                   	ret    
801014c4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801014ca:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801014d0 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
801014d0:	55                   	push   %ebp
801014d1:	89 e5                	mov    %esp,%ebp
801014d3:	57                   	push   %edi
801014d4:	56                   	push   %esi
801014d5:	53                   	push   %ebx
801014d6:	89 c7                	mov    %eax,%edi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
801014d8:	31 f6                	xor    %esi,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801014da:	bb 14 2a 11 80       	mov    $0x80112a14,%ebx
{
801014df:	83 ec 28             	sub    $0x28,%esp
801014e2:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
801014e5:	68 e0 29 11 80       	push   $0x801129e0
801014ea:	e8 11 42 00 00       	call   80105700 <acquire>
801014ef:	83 c4 10             	add    $0x10,%esp
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801014f2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801014f5:	eb 17                	jmp    8010150e <iget+0x3e>
801014f7:	89 f6                	mov    %esi,%esi
801014f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80101500:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101506:	81 fb 34 46 11 80    	cmp    $0x80114634,%ebx
8010150c:	73 22                	jae    80101530 <iget+0x60>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
8010150e:	8b 4b 08             	mov    0x8(%ebx),%ecx
80101511:	85 c9                	test   %ecx,%ecx
80101513:	7e 04                	jle    80101519 <iget+0x49>
80101515:	39 3b                	cmp    %edi,(%ebx)
80101517:	74 4f                	je     80101568 <iget+0x98>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101519:	85 f6                	test   %esi,%esi
8010151b:	75 e3                	jne    80101500 <iget+0x30>
8010151d:	85 c9                	test   %ecx,%ecx
8010151f:	0f 44 f3             	cmove  %ebx,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101522:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101528:	81 fb 34 46 11 80    	cmp    $0x80114634,%ebx
8010152e:	72 de                	jb     8010150e <iget+0x3e>
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
80101530:	85 f6                	test   %esi,%esi
80101532:	74 5b                	je     8010158f <iget+0xbf>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
80101534:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
80101537:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
80101539:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
8010153c:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
80101543:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
8010154a:	68 e0 29 11 80       	push   $0x801129e0
8010154f:	e8 6c 42 00 00       	call   801057c0 <release>

  return ip;
80101554:	83 c4 10             	add    $0x10,%esp
}
80101557:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010155a:	89 f0                	mov    %esi,%eax
8010155c:	5b                   	pop    %ebx
8010155d:	5e                   	pop    %esi
8010155e:	5f                   	pop    %edi
8010155f:	5d                   	pop    %ebp
80101560:	c3                   	ret    
80101561:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101568:	39 53 04             	cmp    %edx,0x4(%ebx)
8010156b:	75 ac                	jne    80101519 <iget+0x49>
      release(&icache.lock);
8010156d:	83 ec 0c             	sub    $0xc,%esp
      ip->ref++;
80101570:	83 c1 01             	add    $0x1,%ecx
      return ip;
80101573:	89 de                	mov    %ebx,%esi
      release(&icache.lock);
80101575:	68 e0 29 11 80       	push   $0x801129e0
      ip->ref++;
8010157a:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
8010157d:	e8 3e 42 00 00       	call   801057c0 <release>
      return ip;
80101582:	83 c4 10             	add    $0x10,%esp
}
80101585:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101588:	89 f0                	mov    %esi,%eax
8010158a:	5b                   	pop    %ebx
8010158b:	5e                   	pop    %esi
8010158c:	5f                   	pop    %edi
8010158d:	5d                   	pop    %ebp
8010158e:	c3                   	ret    
    panic("iget: no inodes");
8010158f:	83 ec 0c             	sub    $0xc,%esp
80101592:	68 a8 90 10 80       	push   $0x801090a8
80101597:	e8 f4 ed ff ff       	call   80100390 <panic>
8010159c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801015a0 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
801015a0:	55                   	push   %ebp
801015a1:	89 e5                	mov    %esp,%ebp
801015a3:	57                   	push   %edi
801015a4:	56                   	push   %esi
801015a5:	53                   	push   %ebx
801015a6:	89 c7                	mov    %eax,%edi
801015a8:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
801015ab:	83 fa 09             	cmp    $0x9,%edx
801015ae:	77 20                	ja     801015d0 <bmap+0x30>
801015b0:	8d 34 90             	lea    (%eax,%edx,4),%esi
    if((addr = ip->addrs[bn]) == 0)
801015b3:	8b 5e 5c             	mov    0x5c(%esi),%ebx
801015b6:	85 db                	test   %ebx,%ebx
801015b8:	0f 84 32 01 00 00    	je     801016f0 <bmap+0x150>
    return addr;
  }
  
  // reach == error
  panic("bmap: out of range");
}
801015be:	8d 65 f4             	lea    -0xc(%ebp),%esp
801015c1:	89 d8                	mov    %ebx,%eax
801015c3:	5b                   	pop    %ebx
801015c4:	5e                   	pop    %esi
801015c5:	5f                   	pop    %edi
801015c6:	5d                   	pop    %ebp
801015c7:	c3                   	ret    
801015c8:	90                   	nop
801015c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  bn -= NDIRECT;
801015d0:	8d 5a f6             	lea    -0xa(%edx),%ebx
  if(bn < NINDIRECT){
801015d3:	83 fb 7f             	cmp    $0x7f,%ebx
801015d6:	77 48                	ja     80101620 <bmap+0x80>
    if((addr = ip->addrs[NDIRECT]) ==   0)
801015d8:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
801015de:	8b 00                	mov    (%eax),%eax
801015e0:	85 d2                	test   %edx,%edx
801015e2:	0f 84 f0 01 00 00    	je     801017d8 <bmap+0x238>
    bp = bread(ip->dev, addr);
801015e8:	83 ec 08             	sub    $0x8,%esp
801015eb:	52                   	push   %edx
801015ec:	50                   	push   %eax
801015ed:	e8 de ea ff ff       	call   801000d0 <bread>
    if((addr = a[bn]) == 0){
801015f2:	8d 54 98 5c          	lea    0x5c(%eax,%ebx,4),%edx
801015f6:	83 c4 10             	add    $0x10,%esp
    bp = bread(ip->dev, addr);
801015f9:	89 c6                	mov    %eax,%esi
    if((addr = a[bn]) == 0){
801015fb:	8b 1a                	mov    (%edx),%ebx
801015fd:	85 db                	test   %ebx,%ebx
801015ff:	0f 84 ab 01 00 00    	je     801017b0 <bmap+0x210>
    brelse(bp);
80101605:	83 ec 0c             	sub    $0xc,%esp
80101608:	56                   	push   %esi
80101609:	e8 d2 eb ff ff       	call   801001e0 <brelse>
8010160e:	83 c4 10             	add    $0x10,%esp
}
80101611:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101614:	89 d8                	mov    %ebx,%eax
80101616:	5b                   	pop    %ebx
80101617:	5e                   	pop    %esi
80101618:	5f                   	pop    %edi
80101619:	5d                   	pop    %ebp
8010161a:	c3                   	ret    
8010161b:	90                   	nop
8010161c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  bn -= NINDIRECT;
80101620:	8d 82 76 ff ff ff    	lea    -0x8a(%edx),%eax
  if(bn < NINDIRECT*NINDIRECT){
80101626:	3d ff 3f 00 00       	cmp    $0x3fff,%eax
8010162b:	0f 86 df 00 00 00    	jbe    80101710 <bmap+0x170>
  bn -= NINDIRECT*NINDIRECT;
80101631:	8d 9a 76 bf ff ff    	lea    -0x408a(%edx),%ebx
  if(bn < NINDIRECT*NINDIRECT*NINDIRECT){
80101637:	81 fb ff ff 1f 00    	cmp    $0x1fffff,%ebx
8010163d:	0f 87 39 02 00 00    	ja     8010187c <bmap+0x2dc>
    if((addr = ip->addrs[NDIRECT+2]) == 0)
80101643:	8b 97 8c 00 00 00    	mov    0x8c(%edi),%edx
    uint first_addr = bn / (NINDIRECT*NINDIRECT), second_addr = (bn % (NINDIRECT*NINDIRECT)) / NINDIRECT, triple_addr = bn % NINDIRECT;
80101649:	89 de                	mov    %ebx,%esi
8010164b:	89 d8                	mov    %ebx,%eax
8010164d:	c1 ee 07             	shr    $0x7,%esi
80101650:	c1 e8 0e             	shr    $0xe,%eax
80101653:	83 e3 7f             	and    $0x7f,%ebx
80101656:	83 e6 7f             	and    $0x7f,%esi
80101659:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010165c:	8b 07                	mov    (%edi),%eax
    if((addr = ip->addrs[NDIRECT+2]) == 0)
8010165e:	85 d2                	test   %edx,%edx
80101660:	0f 84 02 02 00 00    	je     80101868 <bmap+0x2c8>
    bp = bread(ip->dev, addr);
80101666:	83 ec 08             	sub    $0x8,%esp
80101669:	52                   	push   %edx
8010166a:	50                   	push   %eax
8010166b:	e8 60 ea ff ff       	call   801000d0 <bread>
80101670:	89 c2                	mov    %eax,%edx
    if((addr = a[first_addr]) == 0){
80101672:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101675:	83 c4 10             	add    $0x10,%esp
80101678:	8d 4c 82 5c          	lea    0x5c(%edx,%eax,4),%ecx
8010167c:	8b 01                	mov    (%ecx),%eax
8010167e:	85 c0                	test   %eax,%eax
80101680:	0f 84 c2 01 00 00    	je     80101848 <bmap+0x2a8>
    brelse(bp);
80101686:	83 ec 0c             	sub    $0xc,%esp
80101689:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010168c:	52                   	push   %edx
8010168d:	e8 4e eb ff ff       	call   801001e0 <brelse>
    bp = bread(ip->dev, addr);
80101692:	58                   	pop    %eax
80101693:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101696:	5a                   	pop    %edx
80101697:	50                   	push   %eax
80101698:	ff 37                	pushl  (%edi)
8010169a:	e8 31 ea ff ff       	call   801000d0 <bread>
    if((addr = a[second_addr]) == 0){
8010169f:	8d 54 b0 5c          	lea    0x5c(%eax,%esi,4),%edx
801016a3:	83 c4 10             	add    $0x10,%esp
    bp = bread(ip->dev, addr);
801016a6:	89 c1                	mov    %eax,%ecx
    if((addr = a[second_addr]) == 0){
801016a8:	8b 32                	mov    (%edx),%esi
801016aa:	85 f6                	test   %esi,%esi
801016ac:	0f 84 76 01 00 00    	je     80101828 <bmap+0x288>
    brelse(bp);
801016b2:	83 ec 0c             	sub    $0xc,%esp
801016b5:	51                   	push   %ecx
801016b6:	e8 25 eb ff ff       	call   801001e0 <brelse>
    bp = bread(ip->dev, addr);
801016bb:	59                   	pop    %ecx
801016bc:	58                   	pop    %eax
801016bd:	56                   	push   %esi
801016be:	ff 37                	pushl  (%edi)
801016c0:	e8 0b ea ff ff       	call   801000d0 <bread>
    if((addr = a[triple_addr]) == 0){
801016c5:	8d 54 98 5c          	lea    0x5c(%eax,%ebx,4),%edx
801016c9:	83 c4 10             	add    $0x10,%esp
    bp = bread(ip->dev, addr);
801016cc:	89 c6                	mov    %eax,%esi
    if((addr = a[triple_addr]) == 0){
801016ce:	8b 1a                	mov    (%edx),%ebx
801016d0:	85 db                	test   %ebx,%ebx
801016d2:	75 11                	jne    801016e5 <bmap+0x145>
      a[triple_addr] = addr = balloc(ip->dev);
801016d4:	8b 07                	mov    (%edi),%eax
801016d6:	89 55 e4             	mov    %edx,-0x1c(%ebp)
801016d9:	e8 e2 fc ff ff       	call   801013c0 <balloc>
801016de:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801016e1:	89 c3                	mov    %eax,%ebx
801016e3:	89 02                	mov    %eax,(%edx)
    brelse(bp);
801016e5:	83 ec 0c             	sub    $0xc,%esp
801016e8:	56                   	push   %esi
801016e9:	e9 90 00 00 00       	jmp    8010177e <bmap+0x1de>
801016ee:	66 90                	xchg   %ax,%ax
      ip->addrs[bn] = addr = balloc(ip->dev);
801016f0:	8b 00                	mov    (%eax),%eax
801016f2:	e8 c9 fc ff ff       	call   801013c0 <balloc>
801016f7:	89 46 5c             	mov    %eax,0x5c(%esi)
}
801016fa:	8d 65 f4             	lea    -0xc(%ebp),%esp
      ip->addrs[bn] = addr = balloc(ip->dev);
801016fd:	89 c3                	mov    %eax,%ebx
}
801016ff:	89 d8                	mov    %ebx,%eax
80101701:	5b                   	pop    %ebx
80101702:	5e                   	pop    %esi
80101703:	5f                   	pop    %edi
80101704:	5d                   	pop    %ebp
80101705:	c3                   	ret    
80101706:	8d 76 00             	lea    0x0(%esi),%esi
80101709:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if((addr = ip->addrs[NDIRECT+1]) == 0)
80101710:	8b 97 88 00 00 00    	mov    0x88(%edi),%edx
    uint first_addr = bn / NINDIRECT, second_addr = bn % NINDIRECT;
80101716:	89 c3                	mov    %eax,%ebx
80101718:	83 e0 7f             	and    $0x7f,%eax
8010171b:	c1 eb 07             	shr    $0x7,%ebx
8010171e:	89 c6                	mov    %eax,%esi
80101720:	8b 07                	mov    (%edi),%eax
    if((addr = ip->addrs[NDIRECT+1]) == 0)
80101722:	85 d2                	test   %edx,%edx
80101724:	0f 84 e6 00 00 00    	je     80101810 <bmap+0x270>
    bp = bread(ip->dev, addr);
8010172a:	83 ec 08             	sub    $0x8,%esp
8010172d:	52                   	push   %edx
8010172e:	50                   	push   %eax
8010172f:	e8 9c e9 ff ff       	call   801000d0 <bread>
    if((addr = a[first_addr]) == 0){
80101734:	8d 54 98 5c          	lea    0x5c(%eax,%ebx,4),%edx
80101738:	83 c4 10             	add    $0x10,%esp
    bp = bread(ip->dev, addr);
8010173b:	89 c1                	mov    %eax,%ecx
    if((addr = a[first_addr]) == 0){
8010173d:	8b 1a                	mov    (%edx),%ebx
8010173f:	85 db                	test   %ebx,%ebx
80101741:	0f 84 a9 00 00 00    	je     801017f0 <bmap+0x250>
    brelse(bp);
80101747:	83 ec 0c             	sub    $0xc,%esp
8010174a:	51                   	push   %ecx
8010174b:	e8 90 ea ff ff       	call   801001e0 <brelse>
    bp = bread(ip->dev, addr);
80101750:	59                   	pop    %ecx
80101751:	58                   	pop    %eax
80101752:	53                   	push   %ebx
80101753:	ff 37                	pushl  (%edi)
80101755:	e8 76 e9 ff ff       	call   801000d0 <bread>
    if((addr = a[second_addr]) == 0){
8010175a:	8d 74 b0 5c          	lea    0x5c(%eax,%esi,4),%esi
8010175e:	83 c4 10             	add    $0x10,%esp
    bp = bread(ip->dev, addr);
80101761:	89 c2                	mov    %eax,%edx
    if((addr = a[second_addr]) == 0){
80101763:	8b 1e                	mov    (%esi),%ebx
80101765:	85 db                	test   %ebx,%ebx
80101767:	75 11                	jne    8010177a <bmap+0x1da>
80101769:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      a[second_addr] = addr = balloc(ip->dev);
8010176c:	8b 07                	mov    (%edi),%eax
8010176e:	e8 4d fc ff ff       	call   801013c0 <balloc>
80101773:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101776:	89 c3                	mov    %eax,%ebx
80101778:	89 06                	mov    %eax,(%esi)
    brelse(bp);
8010177a:	83 ec 0c             	sub    $0xc,%esp
8010177d:	52                   	push   %edx
    brelse(bp);
8010177e:	e8 5d ea ff ff       	call   801001e0 <brelse>
    bp = bread(ip->dev, addr);
80101783:	58                   	pop    %eax
80101784:	5a                   	pop    %edx
80101785:	53                   	push   %ebx
80101786:	ff 37                	pushl  (%edi)
80101788:	e8 43 e9 ff ff       	call   801000d0 <bread>
8010178d:	89 c6                	mov    %eax,%esi
    log_write(bp);
8010178f:	89 04 24             	mov    %eax,(%esp)
80101792:	e8 79 1d 00 00       	call   80103510 <log_write>
    brelse(bp);
80101797:	89 34 24             	mov    %esi,(%esp)
8010179a:	e8 41 ea ff ff       	call   801001e0 <brelse>
8010179f:	83 c4 10             	add    $0x10,%esp
}
801017a2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801017a5:	89 d8                	mov    %ebx,%eax
801017a7:	5b                   	pop    %ebx
801017a8:	5e                   	pop    %esi
801017a9:	5f                   	pop    %edi
801017aa:	5d                   	pop    %ebp
801017ab:	c3                   	ret    
801017ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      a[bn] = addr = balloc(ip->dev);
801017b0:	8b 07                	mov    (%edi),%eax
801017b2:	89 55 e4             	mov    %edx,-0x1c(%ebp)
801017b5:	e8 06 fc ff ff       	call   801013c0 <balloc>
801017ba:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      log_write(bp);
801017bd:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
801017c0:	89 c3                	mov    %eax,%ebx
801017c2:	89 02                	mov    %eax,(%edx)
      log_write(bp);
801017c4:	56                   	push   %esi
801017c5:	e8 46 1d 00 00       	call   80103510 <log_write>
801017ca:	83 c4 10             	add    $0x10,%esp
801017cd:	e9 33 fe ff ff       	jmp    80101605 <bmap+0x65>
801017d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
801017d8:	e8 e3 fb ff ff       	call   801013c0 <balloc>
801017dd:	89 c2                	mov    %eax,%edx
801017df:	89 87 84 00 00 00    	mov    %eax,0x84(%edi)
801017e5:	8b 07                	mov    (%edi),%eax
801017e7:	e9 fc fd ff ff       	jmp    801015e8 <bmap+0x48>
801017ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801017f0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      a[first_addr] = addr = balloc(ip->dev);
801017f3:	8b 07                	mov    (%edi),%eax
801017f5:	89 55 e0             	mov    %edx,-0x20(%ebp)
801017f8:	e8 c3 fb ff ff       	call   801013c0 <balloc>
801017fd:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101800:	89 c3                	mov    %eax,%ebx
80101802:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101805:	89 02                	mov    %eax,(%edx)
80101807:	e9 3b ff ff ff       	jmp    80101747 <bmap+0x1a7>
8010180c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ip->addrs[NDIRECT+1] = addr = balloc(ip->dev);
80101810:	e8 ab fb ff ff       	call   801013c0 <balloc>
80101815:	89 c2                	mov    %eax,%edx
80101817:	89 87 88 00 00 00    	mov    %eax,0x88(%edi)
8010181d:	8b 07                	mov    (%edi),%eax
8010181f:	e9 06 ff ff ff       	jmp    8010172a <bmap+0x18a>
80101824:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101828:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      a[second_addr] = addr = balloc(ip->dev);
8010182b:	8b 07                	mov    (%edi),%eax
8010182d:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101830:	e8 8b fb ff ff       	call   801013c0 <balloc>
80101835:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101838:	89 c6                	mov    %eax,%esi
8010183a:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
8010183d:	89 02                	mov    %eax,(%edx)
8010183f:	e9 6e fe ff ff       	jmp    801016b2 <bmap+0x112>
80101844:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      a[first_addr] = addr = balloc(ip->dev);
80101848:	8b 07                	mov    (%edi),%eax
8010184a:	89 4d e0             	mov    %ecx,-0x20(%ebp)
8010184d:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101850:	e8 6b fb ff ff       	call   801013c0 <balloc>
80101855:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80101858:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010185b:	89 01                	mov    %eax,(%ecx)
8010185d:	e9 24 fe ff ff       	jmp    80101686 <bmap+0xe6>
80101862:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      ip->addrs[NDIRECT+2] = addr = balloc(ip->dev);
80101868:	e8 53 fb ff ff       	call   801013c0 <balloc>
8010186d:	89 c2                	mov    %eax,%edx
8010186f:	89 87 8c 00 00 00    	mov    %eax,0x8c(%edi)
80101875:	8b 07                	mov    (%edi),%eax
80101877:	e9 ea fd ff ff       	jmp    80101666 <bmap+0xc6>
  panic("bmap: out of range");
8010187c:	83 ec 0c             	sub    $0xc,%esp
8010187f:	68 b8 90 10 80       	push   $0x801090b8
80101884:	e8 07 eb ff ff       	call   80100390 <panic>
80101889:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101890 <readsb>:
{
80101890:	55                   	push   %ebp
80101891:	89 e5                	mov    %esp,%ebp
80101893:	56                   	push   %esi
80101894:	53                   	push   %ebx
80101895:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
80101898:	83 ec 08             	sub    $0x8,%esp
8010189b:	6a 01                	push   $0x1
8010189d:	ff 75 08             	pushl  0x8(%ebp)
801018a0:	e8 2b e8 ff ff       	call   801000d0 <bread>
801018a5:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
801018a7:	8d 40 5c             	lea    0x5c(%eax),%eax
801018aa:	83 c4 0c             	add    $0xc,%esp
801018ad:	6a 1c                	push   $0x1c
801018af:	50                   	push   %eax
801018b0:	56                   	push   %esi
801018b1:	e8 0a 40 00 00       	call   801058c0 <memmove>
  brelse(bp);
801018b6:	89 5d 08             	mov    %ebx,0x8(%ebp)
801018b9:	83 c4 10             	add    $0x10,%esp
}
801018bc:	8d 65 f8             	lea    -0x8(%ebp),%esp
801018bf:	5b                   	pop    %ebx
801018c0:	5e                   	pop    %esi
801018c1:	5d                   	pop    %ebp
  brelse(bp);
801018c2:	e9 19 e9 ff ff       	jmp    801001e0 <brelse>
801018c7:	89 f6                	mov    %esi,%esi
801018c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801018d0 <iinit>:
{
801018d0:	55                   	push   %ebp
801018d1:	89 e5                	mov    %esp,%ebp
801018d3:	53                   	push   %ebx
801018d4:	bb 20 2a 11 80       	mov    $0x80112a20,%ebx
801018d9:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
801018dc:	68 cb 90 10 80       	push   $0x801090cb
801018e1:	68 e0 29 11 80       	push   $0x801129e0
801018e6:	e8 d5 3c 00 00       	call   801055c0 <initlock>
801018eb:	83 c4 10             	add    $0x10,%esp
801018ee:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
801018f0:	83 ec 08             	sub    $0x8,%esp
801018f3:	68 d2 90 10 80       	push   $0x801090d2
801018f8:	53                   	push   %ebx
801018f9:	81 c3 90 00 00 00    	add    $0x90,%ebx
801018ff:	e8 8c 3b 00 00       	call   80105490 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
80101904:	83 c4 10             	add    $0x10,%esp
80101907:	81 fb 40 46 11 80    	cmp    $0x80114640,%ebx
8010190d:	75 e1                	jne    801018f0 <iinit+0x20>
  readsb(dev, &sb);
8010190f:	83 ec 08             	sub    $0x8,%esp
80101912:	68 c0 29 11 80       	push   $0x801129c0
80101917:	ff 75 08             	pushl  0x8(%ebp)
8010191a:	e8 71 ff ff ff       	call   80101890 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
8010191f:	ff 35 d8 29 11 80    	pushl  0x801129d8
80101925:	ff 35 d4 29 11 80    	pushl  0x801129d4
8010192b:	ff 35 d0 29 11 80    	pushl  0x801129d0
80101931:	ff 35 cc 29 11 80    	pushl  0x801129cc
80101937:	ff 35 c8 29 11 80    	pushl  0x801129c8
8010193d:	ff 35 c4 29 11 80    	pushl  0x801129c4
80101943:	ff 35 c0 29 11 80    	pushl  0x801129c0
80101949:	68 38 91 10 80       	push   $0x80109138
8010194e:	e8 0d ed ff ff       	call   80100660 <cprintf>
}
80101953:	83 c4 30             	add    $0x30,%esp
80101956:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101959:	c9                   	leave  
8010195a:	c3                   	ret    
8010195b:	90                   	nop
8010195c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101960 <ialloc>:
{
80101960:	55                   	push   %ebp
80101961:	89 e5                	mov    %esp,%ebp
80101963:	57                   	push   %edi
80101964:	56                   	push   %esi
80101965:	53                   	push   %ebx
80101966:	83 ec 1c             	sub    $0x1c,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101969:	83 3d c8 29 11 80 01 	cmpl   $0x1,0x801129c8
{
80101970:	8b 45 0c             	mov    0xc(%ebp),%eax
80101973:	8b 75 08             	mov    0x8(%ebp),%esi
80101976:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
80101979:	0f 86 91 00 00 00    	jbe    80101a10 <ialloc+0xb0>
8010197f:	bb 01 00 00 00       	mov    $0x1,%ebx
80101984:	eb 21                	jmp    801019a7 <ialloc+0x47>
80101986:	8d 76 00             	lea    0x0(%esi),%esi
80101989:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    brelse(bp);
80101990:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101993:	83 c3 01             	add    $0x1,%ebx
    brelse(bp);
80101996:	57                   	push   %edi
80101997:	e8 44 e8 ff ff       	call   801001e0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
8010199c:	83 c4 10             	add    $0x10,%esp
8010199f:	39 1d c8 29 11 80    	cmp    %ebx,0x801129c8
801019a5:	76 69                	jbe    80101a10 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
801019a7:	89 d8                	mov    %ebx,%eax
801019a9:	83 ec 08             	sub    $0x8,%esp
801019ac:	c1 e8 03             	shr    $0x3,%eax
801019af:	03 05 d4 29 11 80    	add    0x801129d4,%eax
801019b5:	50                   	push   %eax
801019b6:	56                   	push   %esi
801019b7:	e8 14 e7 ff ff       	call   801000d0 <bread>
801019bc:	89 c7                	mov    %eax,%edi
    dip = (struct dinode*)bp->data + inum%IPB;
801019be:	89 d8                	mov    %ebx,%eax
    if(dip->type == 0){  // a free inode
801019c0:	83 c4 10             	add    $0x10,%esp
    dip = (struct dinode*)bp->data + inum%IPB;
801019c3:	83 e0 07             	and    $0x7,%eax
801019c6:	c1 e0 06             	shl    $0x6,%eax
801019c9:	8d 4c 07 5c          	lea    0x5c(%edi,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
801019cd:	66 83 39 00          	cmpw   $0x0,(%ecx)
801019d1:	75 bd                	jne    80101990 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
801019d3:	83 ec 04             	sub    $0x4,%esp
801019d6:	89 4d e0             	mov    %ecx,-0x20(%ebp)
801019d9:	6a 40                	push   $0x40
801019db:	6a 00                	push   $0x0
801019dd:	51                   	push   %ecx
801019de:	e8 2d 3e 00 00       	call   80105810 <memset>
      dip->type = type;
801019e3:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
801019e7:	8b 4d e0             	mov    -0x20(%ebp),%ecx
801019ea:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
801019ed:	89 3c 24             	mov    %edi,(%esp)
801019f0:	e8 1b 1b 00 00       	call   80103510 <log_write>
      brelse(bp);
801019f5:	89 3c 24             	mov    %edi,(%esp)
801019f8:	e8 e3 e7 ff ff       	call   801001e0 <brelse>
      return iget(dev, inum);
801019fd:	83 c4 10             	add    $0x10,%esp
}
80101a00:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
80101a03:	89 da                	mov    %ebx,%edx
80101a05:	89 f0                	mov    %esi,%eax
}
80101a07:	5b                   	pop    %ebx
80101a08:	5e                   	pop    %esi
80101a09:	5f                   	pop    %edi
80101a0a:	5d                   	pop    %ebp
      return iget(dev, inum);
80101a0b:	e9 c0 fa ff ff       	jmp    801014d0 <iget>
  panic("ialloc: no inodes");
80101a10:	83 ec 0c             	sub    $0xc,%esp
80101a13:	68 d8 90 10 80       	push   $0x801090d8
80101a18:	e8 73 e9 ff ff       	call   80100390 <panic>
80101a1d:	8d 76 00             	lea    0x0(%esi),%esi

80101a20 <iupdate>:
{
80101a20:	55                   	push   %ebp
80101a21:	89 e5                	mov    %esp,%ebp
80101a23:	56                   	push   %esi
80101a24:	53                   	push   %ebx
80101a25:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101a28:	83 ec 08             	sub    $0x8,%esp
80101a2b:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101a2e:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101a31:	c1 e8 03             	shr    $0x3,%eax
80101a34:	03 05 d4 29 11 80    	add    0x801129d4,%eax
80101a3a:	50                   	push   %eax
80101a3b:	ff 73 a4             	pushl  -0x5c(%ebx)
80101a3e:	e8 8d e6 ff ff       	call   801000d0 <bread>
80101a43:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
80101a45:	8b 43 a8             	mov    -0x58(%ebx),%eax
  dip->type = ip->type;
80101a48:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101a4c:	83 c4 0c             	add    $0xc,%esp
  dip = (struct dinode*)bp->data + ip->inum%IPB;
80101a4f:	83 e0 07             	and    $0x7,%eax
80101a52:	c1 e0 06             	shl    $0x6,%eax
80101a55:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
80101a59:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
80101a5c:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101a60:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
80101a63:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
80101a67:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
80101a6b:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
80101a6f:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80101a73:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
80101a77:	8b 53 fc             	mov    -0x4(%ebx),%edx
80101a7a:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101a7d:	6a 34                	push   $0x34
80101a7f:	53                   	push   %ebx
80101a80:	50                   	push   %eax
80101a81:	e8 3a 3e 00 00       	call   801058c0 <memmove>
  log_write(bp);
80101a86:	89 34 24             	mov    %esi,(%esp)
80101a89:	e8 82 1a 00 00       	call   80103510 <log_write>
  brelse(bp);
80101a8e:	89 75 08             	mov    %esi,0x8(%ebp)
80101a91:	83 c4 10             	add    $0x10,%esp
}
80101a94:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101a97:	5b                   	pop    %ebx
80101a98:	5e                   	pop    %esi
80101a99:	5d                   	pop    %ebp
  brelse(bp);
80101a9a:	e9 41 e7 ff ff       	jmp    801001e0 <brelse>
80101a9f:	90                   	nop

80101aa0 <idup>:
{
80101aa0:	55                   	push   %ebp
80101aa1:	89 e5                	mov    %esp,%ebp
80101aa3:	53                   	push   %ebx
80101aa4:	83 ec 10             	sub    $0x10,%esp
80101aa7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
80101aaa:	68 e0 29 11 80       	push   $0x801129e0
80101aaf:	e8 4c 3c 00 00       	call   80105700 <acquire>
  ip->ref++;
80101ab4:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101ab8:	c7 04 24 e0 29 11 80 	movl   $0x801129e0,(%esp)
80101abf:	e8 fc 3c 00 00       	call   801057c0 <release>
}
80101ac4:	89 d8                	mov    %ebx,%eax
80101ac6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101ac9:	c9                   	leave  
80101aca:	c3                   	ret    
80101acb:	90                   	nop
80101acc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101ad0 <ilock>:
{
80101ad0:	55                   	push   %ebp
80101ad1:	89 e5                	mov    %esp,%ebp
80101ad3:	56                   	push   %esi
80101ad4:	53                   	push   %ebx
80101ad5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
80101ad8:	85 db                	test   %ebx,%ebx
80101ada:	0f 84 b7 00 00 00    	je     80101b97 <ilock+0xc7>
80101ae0:	8b 53 08             	mov    0x8(%ebx),%edx
80101ae3:	85 d2                	test   %edx,%edx
80101ae5:	0f 8e ac 00 00 00    	jle    80101b97 <ilock+0xc7>
  acquiresleep(&ip->lock);
80101aeb:	8d 43 0c             	lea    0xc(%ebx),%eax
80101aee:	83 ec 0c             	sub    $0xc,%esp
80101af1:	50                   	push   %eax
80101af2:	e8 d9 39 00 00       	call   801054d0 <acquiresleep>
  if(ip->valid == 0){
80101af7:	8b 43 4c             	mov    0x4c(%ebx),%eax
80101afa:	83 c4 10             	add    $0x10,%esp
80101afd:	85 c0                	test   %eax,%eax
80101aff:	74 0f                	je     80101b10 <ilock+0x40>
}
80101b01:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101b04:	5b                   	pop    %ebx
80101b05:	5e                   	pop    %esi
80101b06:	5d                   	pop    %ebp
80101b07:	c3                   	ret    
80101b08:	90                   	nop
80101b09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101b10:	8b 43 04             	mov    0x4(%ebx),%eax
80101b13:	83 ec 08             	sub    $0x8,%esp
80101b16:	c1 e8 03             	shr    $0x3,%eax
80101b19:	03 05 d4 29 11 80    	add    0x801129d4,%eax
80101b1f:	50                   	push   %eax
80101b20:	ff 33                	pushl  (%ebx)
80101b22:	e8 a9 e5 ff ff       	call   801000d0 <bread>
80101b27:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
80101b29:	8b 43 04             	mov    0x4(%ebx),%eax
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101b2c:	83 c4 0c             	add    $0xc,%esp
    dip = (struct dinode*)bp->data + ip->inum%IPB;
80101b2f:	83 e0 07             	and    $0x7,%eax
80101b32:	c1 e0 06             	shl    $0x6,%eax
80101b35:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
80101b39:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101b3c:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
80101b3f:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
80101b43:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
80101b47:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
80101b4b:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
80101b4f:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
80101b53:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
80101b57:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
80101b5b:	8b 50 fc             	mov    -0x4(%eax),%edx
80101b5e:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101b61:	6a 34                	push   $0x34
80101b63:	50                   	push   %eax
80101b64:	8d 43 5c             	lea    0x5c(%ebx),%eax
80101b67:	50                   	push   %eax
80101b68:	e8 53 3d 00 00       	call   801058c0 <memmove>
    brelse(bp);
80101b6d:	89 34 24             	mov    %esi,(%esp)
80101b70:	e8 6b e6 ff ff       	call   801001e0 <brelse>
    if(ip->type == 0)
80101b75:	83 c4 10             	add    $0x10,%esp
80101b78:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
80101b7d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101b84:	0f 85 77 ff ff ff    	jne    80101b01 <ilock+0x31>
      panic("ilock: no type");
80101b8a:	83 ec 0c             	sub    $0xc,%esp
80101b8d:	68 f0 90 10 80       	push   $0x801090f0
80101b92:	e8 f9 e7 ff ff       	call   80100390 <panic>
    panic("ilock");
80101b97:	83 ec 0c             	sub    $0xc,%esp
80101b9a:	68 ea 90 10 80       	push   $0x801090ea
80101b9f:	e8 ec e7 ff ff       	call   80100390 <panic>
80101ba4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101baa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101bb0 <iunlock>:
{
80101bb0:	55                   	push   %ebp
80101bb1:	89 e5                	mov    %esp,%ebp
80101bb3:	56                   	push   %esi
80101bb4:	53                   	push   %ebx
80101bb5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101bb8:	85 db                	test   %ebx,%ebx
80101bba:	74 28                	je     80101be4 <iunlock+0x34>
80101bbc:	8d 73 0c             	lea    0xc(%ebx),%esi
80101bbf:	83 ec 0c             	sub    $0xc,%esp
80101bc2:	56                   	push   %esi
80101bc3:	e8 a8 39 00 00       	call   80105570 <holdingsleep>
80101bc8:	83 c4 10             	add    $0x10,%esp
80101bcb:	85 c0                	test   %eax,%eax
80101bcd:	74 15                	je     80101be4 <iunlock+0x34>
80101bcf:	8b 43 08             	mov    0x8(%ebx),%eax
80101bd2:	85 c0                	test   %eax,%eax
80101bd4:	7e 0e                	jle    80101be4 <iunlock+0x34>
  releasesleep(&ip->lock);
80101bd6:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101bd9:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101bdc:	5b                   	pop    %ebx
80101bdd:	5e                   	pop    %esi
80101bde:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
80101bdf:	e9 4c 39 00 00       	jmp    80105530 <releasesleep>
    panic("iunlock");
80101be4:	83 ec 0c             	sub    $0xc,%esp
80101be7:	68 ff 90 10 80       	push   $0x801090ff
80101bec:	e8 9f e7 ff ff       	call   80100390 <panic>
80101bf1:	eb 0d                	jmp    80101c00 <iput>
80101bf3:	90                   	nop
80101bf4:	90                   	nop
80101bf5:	90                   	nop
80101bf6:	90                   	nop
80101bf7:	90                   	nop
80101bf8:	90                   	nop
80101bf9:	90                   	nop
80101bfa:	90                   	nop
80101bfb:	90                   	nop
80101bfc:	90                   	nop
80101bfd:	90                   	nop
80101bfe:	90                   	nop
80101bff:	90                   	nop

80101c00 <iput>:
{
80101c00:	55                   	push   %ebp
80101c01:	89 e5                	mov    %esp,%ebp
80101c03:	57                   	push   %edi
80101c04:	56                   	push   %esi
80101c05:	53                   	push   %ebx
80101c06:	83 ec 38             	sub    $0x38,%esp
80101c09:	8b 7d 08             	mov    0x8(%ebp),%edi
  acquiresleep(&ip->lock);
80101c0c:	8d 47 0c             	lea    0xc(%edi),%eax
80101c0f:	50                   	push   %eax
80101c10:	89 45 d0             	mov    %eax,-0x30(%ebp)
80101c13:	e8 b8 38 00 00       	call   801054d0 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
80101c18:	8b 77 4c             	mov    0x4c(%edi),%esi
80101c1b:	83 c4 10             	add    $0x10,%esp
80101c1e:	85 f6                	test   %esi,%esi
80101c20:	74 07                	je     80101c29 <iput+0x29>
80101c22:	66 83 7f 56 00       	cmpw   $0x0,0x56(%edi)
80101c27:	74 31                	je     80101c5a <iput+0x5a>
  releasesleep(&ip->lock);
80101c29:	83 ec 0c             	sub    $0xc,%esp
80101c2c:	ff 75 d0             	pushl  -0x30(%ebp)
80101c2f:	e8 fc 38 00 00       	call   80105530 <releasesleep>
  acquire(&icache.lock);
80101c34:	c7 04 24 e0 29 11 80 	movl   $0x801129e0,(%esp)
80101c3b:	e8 c0 3a 00 00       	call   80105700 <acquire>
  ip->ref--;
80101c40:	83 6f 08 01          	subl   $0x1,0x8(%edi)
  release(&icache.lock);
80101c44:	83 c4 10             	add    $0x10,%esp
80101c47:	c7 45 08 e0 29 11 80 	movl   $0x801129e0,0x8(%ebp)
}
80101c4e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c51:	5b                   	pop    %ebx
80101c52:	5e                   	pop    %esi
80101c53:	5f                   	pop    %edi
80101c54:	5d                   	pop    %ebp
  release(&icache.lock);
80101c55:	e9 66 3b 00 00       	jmp    801057c0 <release>
    acquire(&icache.lock);
80101c5a:	83 ec 0c             	sub    $0xc,%esp
80101c5d:	68 e0 29 11 80       	push   $0x801129e0
80101c62:	e8 99 3a 00 00       	call   80105700 <acquire>
    int r = ip->ref;
80101c67:	8b 5f 08             	mov    0x8(%edi),%ebx
    release(&icache.lock);
80101c6a:	c7 04 24 e0 29 11 80 	movl   $0x801129e0,(%esp)
80101c71:	e8 4a 3b 00 00       	call   801057c0 <release>
    if(r == 1){
80101c76:	83 c4 10             	add    $0x10,%esp
80101c79:	83 fb 01             	cmp    $0x1,%ebx
80101c7c:	75 ab                	jne    80101c29 <iput+0x29>
80101c7e:	8d 77 5c             	lea    0x5c(%edi),%esi
80101c81:	8d 9f 84 00 00 00    	lea    0x84(%edi),%ebx
80101c87:	eb 07                	jmp    80101c90 <iput+0x90>
80101c89:	83 c6 04             	add    $0x4,%esi
{
  int i, j;
  struct buf *bp, *bp1, *bp2;
  uint *a, *a1, *a2;

  for(i = 0; i < NDIRECT; i++){
80101c8c:	39 de                	cmp    %ebx,%esi
80101c8e:	74 1b                	je     80101cab <iput+0xab>
    if(ip->addrs[i]){
80101c90:	8b 16                	mov    (%esi),%edx
80101c92:	85 d2                	test   %edx,%edx
80101c94:	74 f3                	je     80101c89 <iput+0x89>
      bfree(ip->dev, ip->addrs[i]);
80101c96:	8b 07                	mov    (%edi),%eax
80101c98:	83 c6 04             	add    $0x4,%esi
80101c9b:	e8 b0 f6 ff ff       	call   80101350 <bfree>
      ip->addrs[i] = 0;
80101ca0:	c7 46 fc 00 00 00 00 	movl   $0x0,-0x4(%esi)
  for(i = 0; i < NDIRECT; i++){
80101ca7:	39 de                	cmp    %ebx,%esi
80101ca9:	75 e5                	jne    80101c90 <iput+0x90>
    }
  }

  if(ip->addrs[NDIRECT]){
80101cab:	8b 87 84 00 00 00    	mov    0x84(%edi),%eax
80101cb1:	85 c0                	test   %eax,%eax
80101cb3:	75 49                	jne    80101cfe <iput+0xfe>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  // doubly
  if(ip->addrs[NDIRECT+1]){
80101cb5:	8b 87 88 00 00 00    	mov    0x88(%edi),%eax
80101cbb:	85 c0                	test   %eax,%eax
80101cbd:	0f 85 92 01 00 00    	jne    80101e55 <iput+0x255>
    bfree(ip->dev, ip->addrs[NDIRECT+1]);
    ip->addrs[NDIRECT+1] = 0;
  }

  // triple
  if(ip->addrs[NDIRECT+2]){
80101cc3:	8b 87 8c 00 00 00    	mov    0x8c(%edi),%eax
80101cc9:	85 c0                	test   %eax,%eax
80101ccb:	0f 85 93 00 00 00    	jne    80101d64 <iput+0x164>
    bfree(ip->dev, ip->addrs[NDIRECT+2]);
    ip->addrs[NDIRECT+2] = 0;
  }

  ip->size = 0;
  iupdate(ip);
80101cd1:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
80101cd4:	c7 47 58 00 00 00 00 	movl   $0x0,0x58(%edi)
  iupdate(ip);
80101cdb:	57                   	push   %edi
80101cdc:	e8 3f fd ff ff       	call   80101a20 <iupdate>
      ip->type = 0;
80101ce1:	31 c0                	xor    %eax,%eax
80101ce3:	66 89 47 50          	mov    %ax,0x50(%edi)
      iupdate(ip);
80101ce7:	89 3c 24             	mov    %edi,(%esp)
80101cea:	e8 31 fd ff ff       	call   80101a20 <iupdate>
      ip->valid = 0;
80101cef:	c7 47 4c 00 00 00 00 	movl   $0x0,0x4c(%edi)
80101cf6:	83 c4 10             	add    $0x10,%esp
80101cf9:	e9 2b ff ff ff       	jmp    80101c29 <iput+0x29>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101cfe:	53                   	push   %ebx
80101cff:	53                   	push   %ebx
80101d00:	50                   	push   %eax
80101d01:	ff 37                	pushl  (%edi)
80101d03:	e8 c8 e3 ff ff       	call   801000d0 <bread>
80101d08:	83 c4 10             	add    $0x10,%esp
80101d0b:	89 c6                	mov    %eax,%esi
    a = (uint*)bp->data;
80101d0d:	8d 58 5c             	lea    0x5c(%eax),%ebx
80101d10:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
80101d16:	eb 0f                	jmp    80101d27 <iput+0x127>
80101d18:	90                   	nop
80101d19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101d20:	83 c3 04             	add    $0x4,%ebx
    for(j = 0; j < NINDIRECT; j++){
80101d23:	39 cb                	cmp    %ecx,%ebx
80101d25:	74 15                	je     80101d3c <iput+0x13c>
      if(a[j])
80101d27:	8b 13                	mov    (%ebx),%edx
80101d29:	85 d2                	test   %edx,%edx
80101d2b:	74 f3                	je     80101d20 <iput+0x120>
        bfree(ip->dev, a[j]);
80101d2d:	8b 07                	mov    (%edi),%eax
80101d2f:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80101d32:	e8 19 f6 ff ff       	call   80101350 <bfree>
80101d37:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101d3a:	eb e4                	jmp    80101d20 <iput+0x120>
    brelse(bp);
80101d3c:	83 ec 0c             	sub    $0xc,%esp
80101d3f:	56                   	push   %esi
80101d40:	e8 9b e4 ff ff       	call   801001e0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101d45:	8b 97 84 00 00 00    	mov    0x84(%edi),%edx
80101d4b:	8b 07                	mov    (%edi),%eax
80101d4d:	e8 fe f5 ff ff       	call   80101350 <bfree>
    ip->addrs[NDIRECT] = 0;
80101d52:	c7 87 84 00 00 00 00 	movl   $0x0,0x84(%edi)
80101d59:	00 00 00 
80101d5c:	83 c4 10             	add    $0x10,%esp
80101d5f:	e9 51 ff ff ff       	jmp    80101cb5 <iput+0xb5>
    bp = bread(ip->dev, ip->addrs[NDIRECT+2]);
80101d64:	52                   	push   %edx
80101d65:	52                   	push   %edx
80101d66:	50                   	push   %eax
80101d67:	ff 37                	pushl  (%edi)
80101d69:	e8 62 e3 ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
80101d6e:	8d 48 5c             	lea    0x5c(%eax),%ecx
    bp = bread(ip->dev, ip->addrs[NDIRECT+2]);
80101d71:	89 45 cc             	mov    %eax,-0x34(%ebp)
80101d74:	05 5c 02 00 00       	add    $0x25c,%eax
80101d79:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80101d7c:	83 c4 10             	add    $0x10,%esp
    a = (uint*)bp->data;
80101d7f:	89 4d d8             	mov    %ecx,-0x28(%ebp)
80101d82:	eb 14                	jmp    80101d98 <iput+0x198>
80101d84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101d88:	83 45 d8 04          	addl   $0x4,-0x28(%ebp)
80101d8c:	8b 45 d8             	mov    -0x28(%ebp),%eax
    for(int i = 0; i < NINDIRECT; ++i)
80101d8f:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
80101d92:	0f 84 4f 01 00 00    	je     80101ee7 <iput+0x2e7>
      if(a[i]){
80101d98:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101d9b:	8b 00                	mov    (%eax),%eax
80101d9d:	85 c0                	test   %eax,%eax
80101d9f:	74 e7                	je     80101d88 <iput+0x188>
        bp1 = bread(ip->dev, a[i]);
80101da1:	83 ec 08             	sub    $0x8,%esp
80101da4:	50                   	push   %eax
80101da5:	ff 37                	pushl  (%edi)
80101da7:	e8 24 e3 ff ff       	call   801000d0 <bread>
        a1 = (uint*)bp1->data;
80101dac:	8d 48 5c             	lea    0x5c(%eax),%ecx
        bp1 = bread(ip->dev, a[i]);
80101daf:	89 45 c8             	mov    %eax,-0x38(%ebp)
80101db2:	05 5c 02 00 00       	add    $0x25c,%eax
80101db7:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101dba:	83 c4 10             	add    $0x10,%esp
        a1 = (uint*)bp1->data;
80101dbd:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80101dc0:	eb 12                	jmp    80101dd4 <iput+0x1d4>
80101dc2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101dc8:	83 45 e4 04          	addl   $0x4,-0x1c(%ebp)
80101dcc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
        for(j = 0; j < NINDIRECT; j++){
80101dcf:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101dd2:	74 62                	je     80101e36 <iput+0x236>
          if(a1[j]){
80101dd4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101dd7:	8b 00                	mov    (%eax),%eax
80101dd9:	85 c0                	test   %eax,%eax
80101ddb:	74 eb                	je     80101dc8 <iput+0x1c8>
            bp2 = bread(ip->dev, a1[j]);
80101ddd:	83 ec 08             	sub    $0x8,%esp
80101de0:	50                   	push   %eax
80101de1:	ff 37                	pushl  (%edi)
80101de3:	e8 e8 e2 ff ff       	call   801000d0 <bread>
            a2 = (uint*)bp2->data;
80101de8:	8d 70 5c             	lea    0x5c(%eax),%esi
80101deb:	8d 98 5c 02 00 00    	lea    0x25c(%eax),%ebx
            bp2 = bread(ip->dev, a1[j]);
80101df1:	89 45 dc             	mov    %eax,-0x24(%ebp)
80101df4:	83 c4 10             	add    $0x10,%esp
80101df7:	89 f6                	mov    %esi,%esi
80101df9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
              bfree(ip->dev, a2[k]);
80101e00:	8b 16                	mov    (%esi),%edx
80101e02:	8b 07                	mov    (%edi),%eax
80101e04:	83 c6 04             	add    $0x4,%esi
80101e07:	e8 44 f5 ff ff       	call   80101350 <bfree>
            for(int k = 0; k < NINDIRECT; ++k){
80101e0c:	39 f3                	cmp    %esi,%ebx
80101e0e:	75 f0                	jne    80101e00 <iput+0x200>
            brelse(bp2);
80101e10:	83 ec 0c             	sub    $0xc,%esp
80101e13:	ff 75 dc             	pushl  -0x24(%ebp)
80101e16:	e8 c5 e3 ff ff       	call   801001e0 <brelse>
            bfree(ip->dev,a1[j]);
80101e1b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101e1e:	8b 10                	mov    (%eax),%edx
80101e20:	8b 07                	mov    (%edi),%eax
80101e22:	e8 29 f5 ff ff       	call   80101350 <bfree>
80101e27:	83 45 e4 04          	addl   $0x4,-0x1c(%ebp)
80101e2b:	83 c4 10             	add    $0x10,%esp
80101e2e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
        for(j = 0; j < NINDIRECT; j++){
80101e31:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101e34:	75 9e                	jne    80101dd4 <iput+0x1d4>
        brelse(bp1);
80101e36:	83 ec 0c             	sub    $0xc,%esp
80101e39:	ff 75 c8             	pushl  -0x38(%ebp)
80101e3c:	e8 9f e3 ff ff       	call   801001e0 <brelse>
        bfree(ip->dev,a[i]);
80101e41:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101e44:	8b 10                	mov    (%eax),%edx
80101e46:	8b 07                	mov    (%edi),%eax
80101e48:	e8 03 f5 ff ff       	call   80101350 <bfree>
80101e4d:	83 c4 10             	add    $0x10,%esp
80101e50:	e9 33 ff ff ff       	jmp    80101d88 <iput+0x188>
    bp = bread(ip->dev, ip->addrs[NDIRECT+1]);
80101e55:	51                   	push   %ecx
80101e56:	51                   	push   %ecx
80101e57:	50                   	push   %eax
80101e58:	ff 37                	pushl  (%edi)
80101e5a:	e8 71 e2 ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
80101e5f:	8d 48 5c             	lea    0x5c(%eax),%ecx
    bp = bread(ip->dev, ip->addrs[NDIRECT+1]);
80101e62:	89 45 dc             	mov    %eax,-0x24(%ebp)
80101e65:	05 5c 02 00 00       	add    $0x25c,%eax
80101e6a:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101e6d:	83 c4 10             	add    $0x10,%esp
    a = (uint*)bp->data;
80101e70:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80101e73:	eb 13                	jmp    80101e88 <iput+0x288>
80101e75:	8d 76 00             	lea    0x0(%esi),%esi
80101e78:	83 45 e4 04          	addl   $0x4,-0x1c(%ebp)
80101e7c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    for(int i = 0; i < NINDIRECT; ++i)
80101e7f:	3b 45 e0             	cmp    -0x20(%ebp),%eax
80101e82:	0f 84 89 00 00 00    	je     80101f11 <iput+0x311>
      if(a[i]){
80101e88:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101e8b:	8b 00                	mov    (%eax),%eax
80101e8d:	85 c0                	test   %eax,%eax
80101e8f:	74 e7                	je     80101e78 <iput+0x278>
        bp1 = bread(ip->dev, a[i]);
80101e91:	83 ec 08             	sub    $0x8,%esp
80101e94:	50                   	push   %eax
80101e95:	ff 37                	pushl  (%edi)
80101e97:	e8 34 e2 ff ff       	call   801000d0 <bread>
80101e9c:	83 c4 10             	add    $0x10,%esp
80101e9f:	89 45 d8             	mov    %eax,-0x28(%ebp)
        a1 = (uint*)bp1->data;
80101ea2:	8d 58 5c             	lea    0x5c(%eax),%ebx
80101ea5:	8d b0 5c 02 00 00    	lea    0x25c(%eax),%esi
80101eab:	eb 0a                	jmp    80101eb7 <iput+0x2b7>
80101ead:	8d 76 00             	lea    0x0(%esi),%esi
80101eb0:	83 c3 04             	add    $0x4,%ebx
        for(j = 0; j < NINDIRECT; j++){
80101eb3:	39 f3                	cmp    %esi,%ebx
80101eb5:	74 14                	je     80101ecb <iput+0x2cb>
          if(a1[j])
80101eb7:	8b 13                	mov    (%ebx),%edx
80101eb9:	85 d2                	test   %edx,%edx
80101ebb:	74 f3                	je     80101eb0 <iput+0x2b0>
            bfree(ip->dev, a1[j]);
80101ebd:	8b 07                	mov    (%edi),%eax
80101ebf:	83 c3 04             	add    $0x4,%ebx
80101ec2:	e8 89 f4 ff ff       	call   80101350 <bfree>
        for(j = 0; j < NINDIRECT; j++){
80101ec7:	39 f3                	cmp    %esi,%ebx
80101ec9:	75 ec                	jne    80101eb7 <iput+0x2b7>
        brelse(bp1);
80101ecb:	83 ec 0c             	sub    $0xc,%esp
80101ece:	ff 75 d8             	pushl  -0x28(%ebp)
80101ed1:	e8 0a e3 ff ff       	call   801001e0 <brelse>
        bfree(ip->dev,a[i]);
80101ed6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101ed9:	8b 10                	mov    (%eax),%edx
80101edb:	8b 07                	mov    (%edi),%eax
80101edd:	e8 6e f4 ff ff       	call   80101350 <bfree>
80101ee2:	83 c4 10             	add    $0x10,%esp
80101ee5:	eb 91                	jmp    80101e78 <iput+0x278>
    brelse(bp);
80101ee7:	83 ec 0c             	sub    $0xc,%esp
80101eea:	ff 75 cc             	pushl  -0x34(%ebp)
80101eed:	e8 ee e2 ff ff       	call   801001e0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT+2]);
80101ef2:	8b 97 8c 00 00 00    	mov    0x8c(%edi),%edx
80101ef8:	8b 07                	mov    (%edi),%eax
80101efa:	e8 51 f4 ff ff       	call   80101350 <bfree>
    ip->addrs[NDIRECT+2] = 0;
80101eff:	c7 87 8c 00 00 00 00 	movl   $0x0,0x8c(%edi)
80101f06:	00 00 00 
80101f09:	83 c4 10             	add    $0x10,%esp
80101f0c:	e9 c0 fd ff ff       	jmp    80101cd1 <iput+0xd1>
    brelse(bp);
80101f11:	83 ec 0c             	sub    $0xc,%esp
80101f14:	ff 75 dc             	pushl  -0x24(%ebp)
80101f17:	e8 c4 e2 ff ff       	call   801001e0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT+1]);
80101f1c:	8b 97 88 00 00 00    	mov    0x88(%edi),%edx
80101f22:	8b 07                	mov    (%edi),%eax
80101f24:	e8 27 f4 ff ff       	call   80101350 <bfree>
    ip->addrs[NDIRECT+1] = 0;
80101f29:	c7 87 88 00 00 00 00 	movl   $0x0,0x88(%edi)
80101f30:	00 00 00 
80101f33:	83 c4 10             	add    $0x10,%esp
80101f36:	e9 88 fd ff ff       	jmp    80101cc3 <iput+0xc3>
80101f3b:	90                   	nop
80101f3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101f40 <iunlockput>:
{
80101f40:	55                   	push   %ebp
80101f41:	89 e5                	mov    %esp,%ebp
80101f43:	53                   	push   %ebx
80101f44:	83 ec 10             	sub    $0x10,%esp
80101f47:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
80101f4a:	53                   	push   %ebx
80101f4b:	e8 60 fc ff ff       	call   80101bb0 <iunlock>
  iput(ip);
80101f50:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101f53:	83 c4 10             	add    $0x10,%esp
}
80101f56:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101f59:	c9                   	leave  
  iput(ip);
80101f5a:	e9 a1 fc ff ff       	jmp    80101c00 <iput>
80101f5f:	90                   	nop

80101f60 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101f60:	55                   	push   %ebp
80101f61:	89 e5                	mov    %esp,%ebp
80101f63:	8b 55 08             	mov    0x8(%ebp),%edx
80101f66:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101f69:	8b 0a                	mov    (%edx),%ecx
80101f6b:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
80101f6e:	8b 4a 04             	mov    0x4(%edx),%ecx
80101f71:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101f74:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101f78:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
80101f7b:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
80101f7f:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101f83:	8b 52 58             	mov    0x58(%edx),%edx
80101f86:	89 50 10             	mov    %edx,0x10(%eax)
}
80101f89:	5d                   	pop    %ebp
80101f8a:	c3                   	ret    
80101f8b:	90                   	nop
80101f8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101f90 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101f90:	55                   	push   %ebp
80101f91:	89 e5                	mov    %esp,%ebp
80101f93:	57                   	push   %edi
80101f94:	56                   	push   %esi
80101f95:	53                   	push   %ebx
80101f96:	83 ec 1c             	sub    $0x1c,%esp
80101f99:	8b 45 08             	mov    0x8(%ebp),%eax
80101f9c:	8b 75 0c             	mov    0xc(%ebp),%esi
80101f9f:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101fa2:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101fa7:	89 75 e0             	mov    %esi,-0x20(%ebp)
80101faa:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101fad:	8b 75 10             	mov    0x10(%ebp),%esi
80101fb0:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  if(ip->type == T_DEV){
80101fb3:	0f 84 a7 00 00 00    	je     80102060 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101fb9:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101fbc:	8b 40 58             	mov    0x58(%eax),%eax
80101fbf:	39 c6                	cmp    %eax,%esi
80101fc1:	0f 87 ba 00 00 00    	ja     80102081 <readi+0xf1>
80101fc7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101fca:	89 f9                	mov    %edi,%ecx
80101fcc:	01 f1                	add    %esi,%ecx
80101fce:	0f 82 ad 00 00 00    	jb     80102081 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101fd4:	89 c2                	mov    %eax,%edx
80101fd6:	29 f2                	sub    %esi,%edx
80101fd8:	39 c8                	cmp    %ecx,%eax
80101fda:	0f 43 d7             	cmovae %edi,%edx

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101fdd:	31 ff                	xor    %edi,%edi
80101fdf:	85 d2                	test   %edx,%edx
    n = ip->size - off;
80101fe1:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101fe4:	74 6c                	je     80102052 <readi+0xc2>
80101fe6:	8d 76 00             	lea    0x0(%esi),%esi
80101fe9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101ff0:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101ff3:	89 f2                	mov    %esi,%edx
80101ff5:	c1 ea 09             	shr    $0x9,%edx
80101ff8:	89 d8                	mov    %ebx,%eax
80101ffa:	e8 a1 f5 ff ff       	call   801015a0 <bmap>
80101fff:	83 ec 08             	sub    $0x8,%esp
80102002:	50                   	push   %eax
80102003:	ff 33                	pushl  (%ebx)
80102005:	e8 c6 e0 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
8010200a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
8010200d:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
8010200f:	89 f0                	mov    %esi,%eax
80102011:	25 ff 01 00 00       	and    $0x1ff,%eax
80102016:	b9 00 02 00 00       	mov    $0x200,%ecx
8010201b:	83 c4 0c             	add    $0xc,%esp
8010201e:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80102020:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
80102024:	89 55 dc             	mov    %edx,-0x24(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80102027:	29 fb                	sub    %edi,%ebx
80102029:	39 d9                	cmp    %ebx,%ecx
8010202b:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
8010202e:	53                   	push   %ebx
8010202f:	50                   	push   %eax
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80102030:	01 df                	add    %ebx,%edi
    memmove(dst, bp->data + off%BSIZE, m);
80102032:	ff 75 e0             	pushl  -0x20(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80102035:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
80102037:	e8 84 38 00 00       	call   801058c0 <memmove>
    brelse(bp);
8010203c:	8b 55 dc             	mov    -0x24(%ebp),%edx
8010203f:	89 14 24             	mov    %edx,(%esp)
80102042:	e8 99 e1 ff ff       	call   801001e0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80102047:	01 5d e0             	add    %ebx,-0x20(%ebp)
8010204a:	83 c4 10             	add    $0x10,%esp
8010204d:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80102050:	77 9e                	ja     80101ff0 <readi+0x60>
  }
  return n;
80102052:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80102055:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102058:	5b                   	pop    %ebx
80102059:	5e                   	pop    %esi
8010205a:	5f                   	pop    %edi
8010205b:	5d                   	pop    %ebp
8010205c:	c3                   	ret    
8010205d:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80102060:	0f bf 40 52          	movswl 0x52(%eax),%eax
80102064:	66 83 f8 09          	cmp    $0x9,%ax
80102068:	77 17                	ja     80102081 <readi+0xf1>
8010206a:	8b 04 c5 60 29 11 80 	mov    -0x7feed6a0(,%eax,8),%eax
80102071:	85 c0                	test   %eax,%eax
80102073:	74 0c                	je     80102081 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80102075:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80102078:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010207b:	5b                   	pop    %ebx
8010207c:	5e                   	pop    %esi
8010207d:	5f                   	pop    %edi
8010207e:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
8010207f:	ff e0                	jmp    *%eax
      return -1;
80102081:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102086:	eb cd                	jmp    80102055 <readi+0xc5>
80102088:	90                   	nop
80102089:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102090 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80102090:	55                   	push   %ebp
80102091:	89 e5                	mov    %esp,%ebp
80102093:	57                   	push   %edi
80102094:	56                   	push   %esi
80102095:	53                   	push   %ebx
80102096:	83 ec 1c             	sub    $0x1c,%esp
80102099:	8b 45 08             	mov    0x8(%ebp),%eax
8010209c:	8b 75 0c             	mov    0xc(%ebp),%esi
8010209f:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
801020a2:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
801020a7:	89 75 dc             	mov    %esi,-0x24(%ebp)
801020aa:	89 45 d8             	mov    %eax,-0x28(%ebp)
801020ad:	8b 75 10             	mov    0x10(%ebp),%esi
801020b0:	89 7d e0             	mov    %edi,-0x20(%ebp)
  if(ip->type == T_DEV){
801020b3:	0f 84 b7 00 00 00    	je     80102170 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
801020b9:	8b 45 d8             	mov    -0x28(%ebp),%eax
801020bc:	39 70 58             	cmp    %esi,0x58(%eax)
801020bf:	0f 82 eb 00 00 00    	jb     801021b0 <writei+0x120>
801020c5:	8b 7d e0             	mov    -0x20(%ebp),%edi
801020c8:	31 d2                	xor    %edx,%edx
801020ca:	89 f8                	mov    %edi,%eax
801020cc:	01 f0                	add    %esi,%eax
801020ce:	0f 92 c2             	setb   %dl
    return -1;
  if(off + n > MAXFILE*BSIZE)
801020d1:	3d 00 14 81 40       	cmp    $0x40811400,%eax
801020d6:	0f 87 d4 00 00 00    	ja     801021b0 <writei+0x120>
801020dc:	85 d2                	test   %edx,%edx
801020de:	0f 85 cc 00 00 00    	jne    801021b0 <writei+0x120>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
801020e4:	85 ff                	test   %edi,%edi
801020e6:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
801020ed:	74 72                	je     80102161 <writei+0xd1>
801020ef:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801020f0:	8b 7d d8             	mov    -0x28(%ebp),%edi
801020f3:	89 f2                	mov    %esi,%edx
801020f5:	c1 ea 09             	shr    $0x9,%edx
801020f8:	89 f8                	mov    %edi,%eax
801020fa:	e8 a1 f4 ff ff       	call   801015a0 <bmap>
801020ff:	83 ec 08             	sub    $0x8,%esp
80102102:	50                   	push   %eax
80102103:	ff 37                	pushl  (%edi)
80102105:	e8 c6 df ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
8010210a:	8b 5d e0             	mov    -0x20(%ebp),%ebx
8010210d:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80102110:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80102112:	89 f0                	mov    %esi,%eax
80102114:	b9 00 02 00 00       	mov    $0x200,%ecx
80102119:	83 c4 0c             	add    $0xc,%esp
8010211c:	25 ff 01 00 00       	and    $0x1ff,%eax
80102121:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80102123:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80102127:	39 d9                	cmp    %ebx,%ecx
80102129:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
8010212c:	53                   	push   %ebx
8010212d:	ff 75 dc             	pushl  -0x24(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80102130:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
80102132:	50                   	push   %eax
80102133:	e8 88 37 00 00       	call   801058c0 <memmove>
    log_write(bp);
80102138:	89 3c 24             	mov    %edi,(%esp)
8010213b:	e8 d0 13 00 00       	call   80103510 <log_write>
    brelse(bp);
80102140:	89 3c 24             	mov    %edi,(%esp)
80102143:	e8 98 e0 ff ff       	call   801001e0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80102148:	01 5d e4             	add    %ebx,-0x1c(%ebp)
8010214b:	01 5d dc             	add    %ebx,-0x24(%ebp)
8010214e:	83 c4 10             	add    $0x10,%esp
80102151:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80102154:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80102157:	77 97                	ja     801020f0 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80102159:	8b 45 d8             	mov    -0x28(%ebp),%eax
8010215c:	3b 70 58             	cmp    0x58(%eax),%esi
8010215f:	77 37                	ja     80102198 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80102161:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80102164:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102167:	5b                   	pop    %ebx
80102168:	5e                   	pop    %esi
80102169:	5f                   	pop    %edi
8010216a:	5d                   	pop    %ebp
8010216b:	c3                   	ret    
8010216c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80102170:	0f bf 40 52          	movswl 0x52(%eax),%eax
80102174:	66 83 f8 09          	cmp    $0x9,%ax
80102178:	77 36                	ja     801021b0 <writei+0x120>
8010217a:	8b 04 c5 64 29 11 80 	mov    -0x7feed69c(,%eax,8),%eax
80102181:	85 c0                	test   %eax,%eax
80102183:	74 2b                	je     801021b0 <writei+0x120>
    return devsw[ip->major].write(ip, src, n);
80102185:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80102188:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010218b:	5b                   	pop    %ebx
8010218c:	5e                   	pop    %esi
8010218d:	5f                   	pop    %edi
8010218e:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
8010218f:	ff e0                	jmp    *%eax
80102191:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
80102198:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
8010219b:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
8010219e:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
801021a1:	50                   	push   %eax
801021a2:	e8 79 f8 ff ff       	call   80101a20 <iupdate>
801021a7:	83 c4 10             	add    $0x10,%esp
801021aa:	eb b5                	jmp    80102161 <writei+0xd1>
801021ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return -1;
801021b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801021b5:	eb ad                	jmp    80102164 <writei+0xd4>
801021b7:	89 f6                	mov    %esi,%esi
801021b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801021c0 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
801021c0:	55                   	push   %ebp
801021c1:	89 e5                	mov    %esp,%ebp
801021c3:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
801021c6:	6a 0e                	push   $0xe
801021c8:	ff 75 0c             	pushl  0xc(%ebp)
801021cb:	ff 75 08             	pushl  0x8(%ebp)
801021ce:	e8 5d 37 00 00       	call   80105930 <strncmp>
}
801021d3:	c9                   	leave  
801021d4:	c3                   	ret    
801021d5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801021d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801021e0 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
801021e0:	55                   	push   %ebp
801021e1:	89 e5                	mov    %esp,%ebp
801021e3:	57                   	push   %edi
801021e4:	56                   	push   %esi
801021e5:	53                   	push   %ebx
801021e6:	83 ec 1c             	sub    $0x1c,%esp
801021e9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
801021ec:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801021f1:	0f 85 85 00 00 00    	jne    8010227c <dirlookup+0x9c>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
801021f7:	8b 53 58             	mov    0x58(%ebx),%edx
801021fa:	31 ff                	xor    %edi,%edi
801021fc:	8d 75 d8             	lea    -0x28(%ebp),%esi
801021ff:	85 d2                	test   %edx,%edx
80102201:	74 3e                	je     80102241 <dirlookup+0x61>
80102203:	90                   	nop
80102204:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102208:	6a 10                	push   $0x10
8010220a:	57                   	push   %edi
8010220b:	56                   	push   %esi
8010220c:	53                   	push   %ebx
8010220d:	e8 7e fd ff ff       	call   80101f90 <readi>
80102212:	83 c4 10             	add    $0x10,%esp
80102215:	83 f8 10             	cmp    $0x10,%eax
80102218:	75 55                	jne    8010226f <dirlookup+0x8f>
      panic("dirlookup read");
    if(de.inum == 0)
8010221a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
8010221f:	74 18                	je     80102239 <dirlookup+0x59>
  return strncmp(s, t, DIRSIZ);
80102221:	8d 45 da             	lea    -0x26(%ebp),%eax
80102224:	83 ec 04             	sub    $0x4,%esp
80102227:	6a 0e                	push   $0xe
80102229:	50                   	push   %eax
8010222a:	ff 75 0c             	pushl  0xc(%ebp)
8010222d:	e8 fe 36 00 00       	call   80105930 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80102232:	83 c4 10             	add    $0x10,%esp
80102235:	85 c0                	test   %eax,%eax
80102237:	74 17                	je     80102250 <dirlookup+0x70>
  for(off = 0; off < dp->size; off += sizeof(de)){
80102239:	83 c7 10             	add    $0x10,%edi
8010223c:	3b 7b 58             	cmp    0x58(%ebx),%edi
8010223f:	72 c7                	jb     80102208 <dirlookup+0x28>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80102241:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80102244:	31 c0                	xor    %eax,%eax
}
80102246:	5b                   	pop    %ebx
80102247:	5e                   	pop    %esi
80102248:	5f                   	pop    %edi
80102249:	5d                   	pop    %ebp
8010224a:	c3                   	ret    
8010224b:	90                   	nop
8010224c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(poff)
80102250:	8b 45 10             	mov    0x10(%ebp),%eax
80102253:	85 c0                	test   %eax,%eax
80102255:	74 05                	je     8010225c <dirlookup+0x7c>
        *poff = off;
80102257:	8b 45 10             	mov    0x10(%ebp),%eax
8010225a:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
8010225c:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80102260:	8b 03                	mov    (%ebx),%eax
80102262:	e8 69 f2 ff ff       	call   801014d0 <iget>
}
80102267:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010226a:	5b                   	pop    %ebx
8010226b:	5e                   	pop    %esi
8010226c:	5f                   	pop    %edi
8010226d:	5d                   	pop    %ebp
8010226e:	c3                   	ret    
      panic("dirlookup read");
8010226f:	83 ec 0c             	sub    $0xc,%esp
80102272:	68 19 91 10 80       	push   $0x80109119
80102277:	e8 14 e1 ff ff       	call   80100390 <panic>
    panic("dirlookup not DIR");
8010227c:	83 ec 0c             	sub    $0xc,%esp
8010227f:	68 07 91 10 80       	push   $0x80109107
80102284:	e8 07 e1 ff ff       	call   80100390 <panic>
80102289:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102290 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80102290:	55                   	push   %ebp
80102291:	89 e5                	mov    %esp,%ebp
80102293:	57                   	push   %edi
80102294:	56                   	push   %esi
80102295:	53                   	push   %ebx
80102296:	89 cf                	mov    %ecx,%edi
80102298:	89 c3                	mov    %eax,%ebx
8010229a:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
8010229d:	80 38 2f             	cmpb   $0x2f,(%eax)
{
801022a0:	89 55 e0             	mov    %edx,-0x20(%ebp)
  if(*path == '/')
801022a3:	0f 84 67 01 00 00    	je     80102410 <namex+0x180>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
801022a9:	e8 02 20 00 00       	call   801042b0 <myproc>
  acquire(&icache.lock);
801022ae:	83 ec 0c             	sub    $0xc,%esp
    ip = idup(myproc()->cwd);
801022b1:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
801022b4:	68 e0 29 11 80       	push   $0x801129e0
801022b9:	e8 42 34 00 00       	call   80105700 <acquire>
  ip->ref++;
801022be:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
801022c2:	c7 04 24 e0 29 11 80 	movl   $0x801129e0,(%esp)
801022c9:	e8 f2 34 00 00       	call   801057c0 <release>
801022ce:	83 c4 10             	add    $0x10,%esp
801022d1:	eb 08                	jmp    801022db <namex+0x4b>
801022d3:	90                   	nop
801022d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
801022d8:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
801022db:	0f b6 03             	movzbl (%ebx),%eax
801022de:	3c 2f                	cmp    $0x2f,%al
801022e0:	74 f6                	je     801022d8 <namex+0x48>
  if(*path == 0)
801022e2:	84 c0                	test   %al,%al
801022e4:	0f 84 ee 00 00 00    	je     801023d8 <namex+0x148>
  while(*path != '/' && *path != 0)
801022ea:	0f b6 03             	movzbl (%ebx),%eax
801022ed:	3c 2f                	cmp    $0x2f,%al
801022ef:	0f 84 b3 00 00 00    	je     801023a8 <namex+0x118>
801022f5:	84 c0                	test   %al,%al
801022f7:	89 da                	mov    %ebx,%edx
801022f9:	75 09                	jne    80102304 <namex+0x74>
801022fb:	e9 a8 00 00 00       	jmp    801023a8 <namex+0x118>
80102300:	84 c0                	test   %al,%al
80102302:	74 0a                	je     8010230e <namex+0x7e>
    path++;
80102304:	83 c2 01             	add    $0x1,%edx
  while(*path != '/' && *path != 0)
80102307:	0f b6 02             	movzbl (%edx),%eax
8010230a:	3c 2f                	cmp    $0x2f,%al
8010230c:	75 f2                	jne    80102300 <namex+0x70>
8010230e:	89 d1                	mov    %edx,%ecx
80102310:	29 d9                	sub    %ebx,%ecx
  if(len >= DIRSIZ)
80102312:	83 f9 0d             	cmp    $0xd,%ecx
80102315:	0f 8e 91 00 00 00    	jle    801023ac <namex+0x11c>
    memmove(name, s, DIRSIZ);
8010231b:	83 ec 04             	sub    $0x4,%esp
8010231e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80102321:	6a 0e                	push   $0xe
80102323:	53                   	push   %ebx
80102324:	57                   	push   %edi
80102325:	e8 96 35 00 00       	call   801058c0 <memmove>
    path++;
8010232a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
    memmove(name, s, DIRSIZ);
8010232d:	83 c4 10             	add    $0x10,%esp
    path++;
80102330:	89 d3                	mov    %edx,%ebx
  while(*path == '/')
80102332:	80 3a 2f             	cmpb   $0x2f,(%edx)
80102335:	75 11                	jne    80102348 <namex+0xb8>
80102337:	89 f6                	mov    %esi,%esi
80102339:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    path++;
80102340:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80102343:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80102346:	74 f8                	je     80102340 <namex+0xb0>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80102348:	83 ec 0c             	sub    $0xc,%esp
8010234b:	56                   	push   %esi
8010234c:	e8 7f f7 ff ff       	call   80101ad0 <ilock>
    if(ip->type != T_DIR){
80102351:	83 c4 10             	add    $0x10,%esp
80102354:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80102359:	0f 85 91 00 00 00    	jne    801023f0 <namex+0x160>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
8010235f:	8b 55 e0             	mov    -0x20(%ebp),%edx
80102362:	85 d2                	test   %edx,%edx
80102364:	74 09                	je     8010236f <namex+0xdf>
80102366:	80 3b 00             	cmpb   $0x0,(%ebx)
80102369:	0f 84 b7 00 00 00    	je     80102426 <namex+0x196>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
8010236f:	83 ec 04             	sub    $0x4,%esp
80102372:	6a 00                	push   $0x0
80102374:	57                   	push   %edi
80102375:	56                   	push   %esi
80102376:	e8 65 fe ff ff       	call   801021e0 <dirlookup>
8010237b:	83 c4 10             	add    $0x10,%esp
8010237e:	85 c0                	test   %eax,%eax
80102380:	74 6e                	je     801023f0 <namex+0x160>
  iunlock(ip);
80102382:	83 ec 0c             	sub    $0xc,%esp
80102385:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80102388:	56                   	push   %esi
80102389:	e8 22 f8 ff ff       	call   80101bb0 <iunlock>
  iput(ip);
8010238e:	89 34 24             	mov    %esi,(%esp)
80102391:	e8 6a f8 ff ff       	call   80101c00 <iput>
80102396:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80102399:	83 c4 10             	add    $0x10,%esp
8010239c:	89 c6                	mov    %eax,%esi
8010239e:	e9 38 ff ff ff       	jmp    801022db <namex+0x4b>
801023a3:	90                   	nop
801023a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while(*path != '/' && *path != 0)
801023a8:	89 da                	mov    %ebx,%edx
801023aa:	31 c9                	xor    %ecx,%ecx
    memmove(name, s, len);
801023ac:	83 ec 04             	sub    $0x4,%esp
801023af:	89 55 dc             	mov    %edx,-0x24(%ebp)
801023b2:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
801023b5:	51                   	push   %ecx
801023b6:	53                   	push   %ebx
801023b7:	57                   	push   %edi
801023b8:	e8 03 35 00 00       	call   801058c0 <memmove>
    name[len] = 0;
801023bd:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801023c0:	8b 55 dc             	mov    -0x24(%ebp),%edx
801023c3:	83 c4 10             	add    $0x10,%esp
801023c6:	c6 04 0f 00          	movb   $0x0,(%edi,%ecx,1)
801023ca:	89 d3                	mov    %edx,%ebx
801023cc:	e9 61 ff ff ff       	jmp    80102332 <namex+0xa2>
801023d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
801023d8:	8b 45 e0             	mov    -0x20(%ebp),%eax
801023db:	85 c0                	test   %eax,%eax
801023dd:	75 5d                	jne    8010243c <namex+0x1ac>
    iput(ip);
    return 0;
  }
  return ip;
}
801023df:	8d 65 f4             	lea    -0xc(%ebp),%esp
801023e2:	89 f0                	mov    %esi,%eax
801023e4:	5b                   	pop    %ebx
801023e5:	5e                   	pop    %esi
801023e6:	5f                   	pop    %edi
801023e7:	5d                   	pop    %ebp
801023e8:	c3                   	ret    
801023e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  iunlock(ip);
801023f0:	83 ec 0c             	sub    $0xc,%esp
801023f3:	56                   	push   %esi
801023f4:	e8 b7 f7 ff ff       	call   80101bb0 <iunlock>
  iput(ip);
801023f9:	89 34 24             	mov    %esi,(%esp)
      return 0;
801023fc:	31 f6                	xor    %esi,%esi
  iput(ip);
801023fe:	e8 fd f7 ff ff       	call   80101c00 <iput>
      return 0;
80102403:	83 c4 10             	add    $0x10,%esp
}
80102406:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102409:	89 f0                	mov    %esi,%eax
8010240b:	5b                   	pop    %ebx
8010240c:	5e                   	pop    %esi
8010240d:	5f                   	pop    %edi
8010240e:	5d                   	pop    %ebp
8010240f:	c3                   	ret    
    ip = iget(ROOTDEV, ROOTINO);
80102410:	ba 01 00 00 00       	mov    $0x1,%edx
80102415:	b8 01 00 00 00       	mov    $0x1,%eax
8010241a:	e8 b1 f0 ff ff       	call   801014d0 <iget>
8010241f:	89 c6                	mov    %eax,%esi
80102421:	e9 b5 fe ff ff       	jmp    801022db <namex+0x4b>
      iunlock(ip);
80102426:	83 ec 0c             	sub    $0xc,%esp
80102429:	56                   	push   %esi
8010242a:	e8 81 f7 ff ff       	call   80101bb0 <iunlock>
      return ip;
8010242f:	83 c4 10             	add    $0x10,%esp
}
80102432:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102435:	89 f0                	mov    %esi,%eax
80102437:	5b                   	pop    %ebx
80102438:	5e                   	pop    %esi
80102439:	5f                   	pop    %edi
8010243a:	5d                   	pop    %ebp
8010243b:	c3                   	ret    
    iput(ip);
8010243c:	83 ec 0c             	sub    $0xc,%esp
8010243f:	56                   	push   %esi
    return 0;
80102440:	31 f6                	xor    %esi,%esi
    iput(ip);
80102442:	e8 b9 f7 ff ff       	call   80101c00 <iput>
    return 0;
80102447:	83 c4 10             	add    $0x10,%esp
8010244a:	eb 93                	jmp    801023df <namex+0x14f>
8010244c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102450 <dirlink>:
{
80102450:	55                   	push   %ebp
80102451:	89 e5                	mov    %esp,%ebp
80102453:	57                   	push   %edi
80102454:	56                   	push   %esi
80102455:	53                   	push   %ebx
80102456:	83 ec 20             	sub    $0x20,%esp
80102459:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
8010245c:	6a 00                	push   $0x0
8010245e:	ff 75 0c             	pushl  0xc(%ebp)
80102461:	53                   	push   %ebx
80102462:	e8 79 fd ff ff       	call   801021e0 <dirlookup>
80102467:	83 c4 10             	add    $0x10,%esp
8010246a:	85 c0                	test   %eax,%eax
8010246c:	75 67                	jne    801024d5 <dirlink+0x85>
  for(off = 0; off < dp->size; off += sizeof(de)){
8010246e:	8b 7b 58             	mov    0x58(%ebx),%edi
80102471:	8d 75 d8             	lea    -0x28(%ebp),%esi
80102474:	85 ff                	test   %edi,%edi
80102476:	74 29                	je     801024a1 <dirlink+0x51>
80102478:	31 ff                	xor    %edi,%edi
8010247a:	8d 75 d8             	lea    -0x28(%ebp),%esi
8010247d:	eb 09                	jmp    80102488 <dirlink+0x38>
8010247f:	90                   	nop
80102480:	83 c7 10             	add    $0x10,%edi
80102483:	3b 7b 58             	cmp    0x58(%ebx),%edi
80102486:	73 19                	jae    801024a1 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102488:	6a 10                	push   $0x10
8010248a:	57                   	push   %edi
8010248b:	56                   	push   %esi
8010248c:	53                   	push   %ebx
8010248d:	e8 fe fa ff ff       	call   80101f90 <readi>
80102492:	83 c4 10             	add    $0x10,%esp
80102495:	83 f8 10             	cmp    $0x10,%eax
80102498:	75 4e                	jne    801024e8 <dirlink+0x98>
    if(de.inum == 0)
8010249a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
8010249f:	75 df                	jne    80102480 <dirlink+0x30>
  strncpy(de.name, name, DIRSIZ);
801024a1:	8d 45 da             	lea    -0x26(%ebp),%eax
801024a4:	83 ec 04             	sub    $0x4,%esp
801024a7:	6a 0e                	push   $0xe
801024a9:	ff 75 0c             	pushl  0xc(%ebp)
801024ac:	50                   	push   %eax
801024ad:	e8 de 34 00 00       	call   80105990 <strncpy>
  de.inum = inum;
801024b2:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801024b5:	6a 10                	push   $0x10
801024b7:	57                   	push   %edi
801024b8:	56                   	push   %esi
801024b9:	53                   	push   %ebx
  de.inum = inum;
801024ba:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801024be:	e8 cd fb ff ff       	call   80102090 <writei>
801024c3:	83 c4 20             	add    $0x20,%esp
801024c6:	83 f8 10             	cmp    $0x10,%eax
801024c9:	75 2a                	jne    801024f5 <dirlink+0xa5>
  return 0;
801024cb:	31 c0                	xor    %eax,%eax
}
801024cd:	8d 65 f4             	lea    -0xc(%ebp),%esp
801024d0:	5b                   	pop    %ebx
801024d1:	5e                   	pop    %esi
801024d2:	5f                   	pop    %edi
801024d3:	5d                   	pop    %ebp
801024d4:	c3                   	ret    
    iput(ip);
801024d5:	83 ec 0c             	sub    $0xc,%esp
801024d8:	50                   	push   %eax
801024d9:	e8 22 f7 ff ff       	call   80101c00 <iput>
    return -1;
801024de:	83 c4 10             	add    $0x10,%esp
801024e1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801024e6:	eb e5                	jmp    801024cd <dirlink+0x7d>
      panic("dirlink read");
801024e8:	83 ec 0c             	sub    $0xc,%esp
801024eb:	68 28 91 10 80       	push   $0x80109128
801024f0:	e8 9b de ff ff       	call   80100390 <panic>
    panic("dirlink");
801024f5:	83 ec 0c             	sub    $0xc,%esp
801024f8:	68 2e 98 10 80       	push   $0x8010982e
801024fd:	e8 8e de ff ff       	call   80100390 <panic>
80102502:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102509:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102510 <namei>:

struct inode*
namei(char *path)
{
80102510:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80102511:	31 d2                	xor    %edx,%edx
{
80102513:	89 e5                	mov    %esp,%ebp
80102515:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
80102518:	8b 45 08             	mov    0x8(%ebp),%eax
8010251b:	8d 4d ea             	lea    -0x16(%ebp),%ecx
8010251e:	e8 6d fd ff ff       	call   80102290 <namex>
}
80102523:	c9                   	leave  
80102524:	c3                   	ret    
80102525:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102529:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102530 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80102530:	55                   	push   %ebp
  return namex(path, 1, name);
80102531:	ba 01 00 00 00       	mov    $0x1,%edx
{
80102536:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
80102538:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010253b:	8b 45 08             	mov    0x8(%ebp),%eax
}
8010253e:	5d                   	pop    %ebp
  return namex(path, 1, name);
8010253f:	e9 4c fd ff ff       	jmp    80102290 <namex>
80102544:	66 90                	xchg   %ax,%ax
80102546:	66 90                	xchg   %ax,%ax
80102548:	66 90                	xchg   %ax,%ax
8010254a:	66 90                	xchg   %ax,%ax
8010254c:	66 90                	xchg   %ax,%ax
8010254e:	66 90                	xchg   %ax,%ax

80102550 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80102550:	55                   	push   %ebp
80102551:	89 e5                	mov    %esp,%ebp
80102553:	57                   	push   %edi
80102554:	56                   	push   %esi
80102555:	53                   	push   %ebx
80102556:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
80102559:	85 c0                	test   %eax,%eax
8010255b:	0f 84 b4 00 00 00    	je     80102615 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80102561:	8b 58 08             	mov    0x8(%eax),%ebx
80102564:	89 c6                	mov    %eax,%esi
80102566:	81 fb 3f 9c 00 00    	cmp    $0x9c3f,%ebx
8010256c:	0f 87 96 00 00 00    	ja     80102608 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102572:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
80102577:	89 f6                	mov    %esi,%esi
80102579:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80102580:	89 ca                	mov    %ecx,%edx
80102582:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102583:	83 e0 c0             	and    $0xffffffc0,%eax
80102586:	3c 40                	cmp    $0x40,%al
80102588:	75 f6                	jne    80102580 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010258a:	31 ff                	xor    %edi,%edi
8010258c:	ba f6 03 00 00       	mov    $0x3f6,%edx
80102591:	89 f8                	mov    %edi,%eax
80102593:	ee                   	out    %al,(%dx)
80102594:	b8 01 00 00 00       	mov    $0x1,%eax
80102599:	ba f2 01 00 00       	mov    $0x1f2,%edx
8010259e:	ee                   	out    %al,(%dx)
8010259f:	ba f3 01 00 00       	mov    $0x1f3,%edx
801025a4:	89 d8                	mov    %ebx,%eax
801025a6:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
801025a7:	89 d8                	mov    %ebx,%eax
801025a9:	ba f4 01 00 00       	mov    $0x1f4,%edx
801025ae:	c1 f8 08             	sar    $0x8,%eax
801025b1:	ee                   	out    %al,(%dx)
801025b2:	ba f5 01 00 00       	mov    $0x1f5,%edx
801025b7:	89 f8                	mov    %edi,%eax
801025b9:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
801025ba:	0f b6 46 04          	movzbl 0x4(%esi),%eax
801025be:	ba f6 01 00 00       	mov    $0x1f6,%edx
801025c3:	c1 e0 04             	shl    $0x4,%eax
801025c6:	83 e0 10             	and    $0x10,%eax
801025c9:	83 c8 e0             	or     $0xffffffe0,%eax
801025cc:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
801025cd:	f6 06 04             	testb  $0x4,(%esi)
801025d0:	75 16                	jne    801025e8 <idestart+0x98>
801025d2:	b8 20 00 00 00       	mov    $0x20,%eax
801025d7:	89 ca                	mov    %ecx,%edx
801025d9:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
801025da:	8d 65 f4             	lea    -0xc(%ebp),%esp
801025dd:	5b                   	pop    %ebx
801025de:	5e                   	pop    %esi
801025df:	5f                   	pop    %edi
801025e0:	5d                   	pop    %ebp
801025e1:	c3                   	ret    
801025e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801025e8:	b8 30 00 00 00       	mov    $0x30,%eax
801025ed:	89 ca                	mov    %ecx,%edx
801025ef:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
801025f0:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
801025f5:	83 c6 5c             	add    $0x5c,%esi
801025f8:	ba f0 01 00 00       	mov    $0x1f0,%edx
801025fd:	fc                   	cld    
801025fe:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
80102600:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102603:	5b                   	pop    %ebx
80102604:	5e                   	pop    %esi
80102605:	5f                   	pop    %edi
80102606:	5d                   	pop    %ebp
80102607:	c3                   	ret    
    panic("incorrect blockno");
80102608:	83 ec 0c             	sub    $0xc,%esp
8010260b:	68 94 91 10 80       	push   $0x80109194
80102610:	e8 7b dd ff ff       	call   80100390 <panic>
    panic("idestart");
80102615:	83 ec 0c             	sub    $0xc,%esp
80102618:	68 8b 91 10 80       	push   $0x8010918b
8010261d:	e8 6e dd ff ff       	call   80100390 <panic>
80102622:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102629:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102630 <ideinit>:
{
80102630:	55                   	push   %ebp
80102631:	89 e5                	mov    %esp,%ebp
80102633:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
80102636:	68 a6 91 10 80       	push   $0x801091a6
8010263b:	68 80 c5 10 80       	push   $0x8010c580
80102640:	e8 7b 2f 00 00       	call   801055c0 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80102645:	58                   	pop    %eax
80102646:	a1 00 4d 11 80       	mov    0x80114d00,%eax
8010264b:	5a                   	pop    %edx
8010264c:	83 e8 01             	sub    $0x1,%eax
8010264f:	50                   	push   %eax
80102650:	6a 0e                	push   $0xe
80102652:	e8 a9 02 00 00       	call   80102900 <ioapicenable>
80102657:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010265a:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010265f:	90                   	nop
80102660:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102661:	83 e0 c0             	and    $0xffffffc0,%eax
80102664:	3c 40                	cmp    $0x40,%al
80102666:	75 f8                	jne    80102660 <ideinit+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102668:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
8010266d:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102672:	ee                   	out    %al,(%dx)
80102673:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102678:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010267d:	eb 06                	jmp    80102685 <ideinit+0x55>
8010267f:	90                   	nop
  for(i=0; i<1000; i++){
80102680:	83 e9 01             	sub    $0x1,%ecx
80102683:	74 0f                	je     80102694 <ideinit+0x64>
80102685:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80102686:	84 c0                	test   %al,%al
80102688:	74 f6                	je     80102680 <ideinit+0x50>
      havedisk1 = 1;
8010268a:	c7 05 60 c5 10 80 01 	movl   $0x1,0x8010c560
80102691:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102694:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80102699:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010269e:	ee                   	out    %al,(%dx)
}
8010269f:	c9                   	leave  
801026a0:	c3                   	ret    
801026a1:	eb 0d                	jmp    801026b0 <ideintr>
801026a3:	90                   	nop
801026a4:	90                   	nop
801026a5:	90                   	nop
801026a6:	90                   	nop
801026a7:	90                   	nop
801026a8:	90                   	nop
801026a9:	90                   	nop
801026aa:	90                   	nop
801026ab:	90                   	nop
801026ac:	90                   	nop
801026ad:	90                   	nop
801026ae:	90                   	nop
801026af:	90                   	nop

801026b0 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
801026b0:	55                   	push   %ebp
801026b1:	89 e5                	mov    %esp,%ebp
801026b3:	57                   	push   %edi
801026b4:	56                   	push   %esi
801026b5:	53                   	push   %ebx
801026b6:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
801026b9:	68 80 c5 10 80       	push   $0x8010c580
801026be:	e8 3d 30 00 00       	call   80105700 <acquire>

  if((b = idequeue) == 0){
801026c3:	8b 1d 64 c5 10 80    	mov    0x8010c564,%ebx
801026c9:	83 c4 10             	add    $0x10,%esp
801026cc:	85 db                	test   %ebx,%ebx
801026ce:	74 67                	je     80102737 <ideintr+0x87>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
801026d0:	8b 43 58             	mov    0x58(%ebx),%eax
801026d3:	a3 64 c5 10 80       	mov    %eax,0x8010c564

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
801026d8:	8b 3b                	mov    (%ebx),%edi
801026da:	f7 c7 04 00 00 00    	test   $0x4,%edi
801026e0:	75 31                	jne    80102713 <ideintr+0x63>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801026e2:	ba f7 01 00 00       	mov    $0x1f7,%edx
801026e7:	89 f6                	mov    %esi,%esi
801026e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801026f0:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801026f1:	89 c6                	mov    %eax,%esi
801026f3:	83 e6 c0             	and    $0xffffffc0,%esi
801026f6:	89 f1                	mov    %esi,%ecx
801026f8:	80 f9 40             	cmp    $0x40,%cl
801026fb:	75 f3                	jne    801026f0 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
801026fd:	a8 21                	test   $0x21,%al
801026ff:	75 12                	jne    80102713 <ideintr+0x63>
    insl(0x1f0, b->data, BSIZE/4);
80102701:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
80102704:	b9 80 00 00 00       	mov    $0x80,%ecx
80102709:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010270e:	fc                   	cld    
8010270f:	f3 6d                	rep insl (%dx),%es:(%edi)
80102711:	8b 3b                	mov    (%ebx),%edi

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
80102713:	83 e7 fb             	and    $0xfffffffb,%edi
  wakeup(b);
80102716:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
80102719:	89 f9                	mov    %edi,%ecx
8010271b:	83 c9 02             	or     $0x2,%ecx
8010271e:	89 0b                	mov    %ecx,(%ebx)
  wakeup(b);
80102720:	53                   	push   %ebx
80102721:	e8 ca 25 00 00       	call   80104cf0 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80102726:	a1 64 c5 10 80       	mov    0x8010c564,%eax
8010272b:	83 c4 10             	add    $0x10,%esp
8010272e:	85 c0                	test   %eax,%eax
80102730:	74 05                	je     80102737 <ideintr+0x87>
    idestart(idequeue);
80102732:	e8 19 fe ff ff       	call   80102550 <idestart>
    release(&idelock);
80102737:	83 ec 0c             	sub    $0xc,%esp
8010273a:	68 80 c5 10 80       	push   $0x8010c580
8010273f:	e8 7c 30 00 00       	call   801057c0 <release>

  release(&idelock);
}
80102744:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102747:	5b                   	pop    %ebx
80102748:	5e                   	pop    %esi
80102749:	5f                   	pop    %edi
8010274a:	5d                   	pop    %ebp
8010274b:	c3                   	ret    
8010274c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102750 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102750:	55                   	push   %ebp
80102751:	89 e5                	mov    %esp,%ebp
80102753:	53                   	push   %ebx
80102754:	83 ec 10             	sub    $0x10,%esp
80102757:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
8010275a:	8d 43 0c             	lea    0xc(%ebx),%eax
8010275d:	50                   	push   %eax
8010275e:	e8 0d 2e 00 00       	call   80105570 <holdingsleep>
80102763:	83 c4 10             	add    $0x10,%esp
80102766:	85 c0                	test   %eax,%eax
80102768:	0f 84 c6 00 00 00    	je     80102834 <iderw+0xe4>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
8010276e:	8b 03                	mov    (%ebx),%eax
80102770:	83 e0 06             	and    $0x6,%eax
80102773:	83 f8 02             	cmp    $0x2,%eax
80102776:	0f 84 ab 00 00 00    	je     80102827 <iderw+0xd7>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
8010277c:	8b 53 04             	mov    0x4(%ebx),%edx
8010277f:	85 d2                	test   %edx,%edx
80102781:	74 0d                	je     80102790 <iderw+0x40>
80102783:	a1 60 c5 10 80       	mov    0x8010c560,%eax
80102788:	85 c0                	test   %eax,%eax
8010278a:	0f 84 b1 00 00 00    	je     80102841 <iderw+0xf1>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80102790:	83 ec 0c             	sub    $0xc,%esp
80102793:	68 80 c5 10 80       	push   $0x8010c580
80102798:	e8 63 2f 00 00       	call   80105700 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010279d:	8b 15 64 c5 10 80    	mov    0x8010c564,%edx
801027a3:	83 c4 10             	add    $0x10,%esp
  b->qnext = 0;
801027a6:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801027ad:	85 d2                	test   %edx,%edx
801027af:	75 09                	jne    801027ba <iderw+0x6a>
801027b1:	eb 6d                	jmp    80102820 <iderw+0xd0>
801027b3:	90                   	nop
801027b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801027b8:	89 c2                	mov    %eax,%edx
801027ba:	8b 42 58             	mov    0x58(%edx),%eax
801027bd:	85 c0                	test   %eax,%eax
801027bf:	75 f7                	jne    801027b8 <iderw+0x68>
801027c1:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
801027c4:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
801027c6:	39 1d 64 c5 10 80    	cmp    %ebx,0x8010c564
801027cc:	74 42                	je     80102810 <iderw+0xc0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801027ce:	8b 03                	mov    (%ebx),%eax
801027d0:	83 e0 06             	and    $0x6,%eax
801027d3:	83 f8 02             	cmp    $0x2,%eax
801027d6:	74 23                	je     801027fb <iderw+0xab>
801027d8:	90                   	nop
801027d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sleep(b, &idelock);
801027e0:	83 ec 08             	sub    $0x8,%esp
801027e3:	68 80 c5 10 80       	push   $0x8010c580
801027e8:	53                   	push   %ebx
801027e9:	e8 b2 20 00 00       	call   801048a0 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801027ee:	8b 03                	mov    (%ebx),%eax
801027f0:	83 c4 10             	add    $0x10,%esp
801027f3:	83 e0 06             	and    $0x6,%eax
801027f6:	83 f8 02             	cmp    $0x2,%eax
801027f9:	75 e5                	jne    801027e0 <iderw+0x90>
  }


  release(&idelock);
801027fb:	c7 45 08 80 c5 10 80 	movl   $0x8010c580,0x8(%ebp)
}
80102802:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102805:	c9                   	leave  
  release(&idelock);
80102806:	e9 b5 2f 00 00       	jmp    801057c0 <release>
8010280b:	90                   	nop
8010280c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    idestart(b);
80102810:	89 d8                	mov    %ebx,%eax
80102812:	e8 39 fd ff ff       	call   80102550 <idestart>
80102817:	eb b5                	jmp    801027ce <iderw+0x7e>
80102819:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102820:	ba 64 c5 10 80       	mov    $0x8010c564,%edx
80102825:	eb 9d                	jmp    801027c4 <iderw+0x74>
    panic("iderw: nothing to do");
80102827:	83 ec 0c             	sub    $0xc,%esp
8010282a:	68 c0 91 10 80       	push   $0x801091c0
8010282f:	e8 5c db ff ff       	call   80100390 <panic>
    panic("iderw: buf not locked");
80102834:	83 ec 0c             	sub    $0xc,%esp
80102837:	68 aa 91 10 80       	push   $0x801091aa
8010283c:	e8 4f db ff ff       	call   80100390 <panic>
    panic("iderw: ide disk 1 not present");
80102841:	83 ec 0c             	sub    $0xc,%esp
80102844:	68 d5 91 10 80       	push   $0x801091d5
80102849:	e8 42 db ff ff       	call   80100390 <panic>
8010284e:	66 90                	xchg   %ax,%ax

80102850 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
80102850:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102851:	c7 05 34 46 11 80 00 	movl   $0xfec00000,0x80114634
80102858:	00 c0 fe 
{
8010285b:	89 e5                	mov    %esp,%ebp
8010285d:	56                   	push   %esi
8010285e:	53                   	push   %ebx
  ioapic->reg = reg;
8010285f:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
80102866:	00 00 00 
  return ioapic->data;
80102869:	a1 34 46 11 80       	mov    0x80114634,%eax
8010286e:	8b 58 10             	mov    0x10(%eax),%ebx
  ioapic->reg = reg;
80102871:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  return ioapic->data;
80102877:	8b 0d 34 46 11 80    	mov    0x80114634,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
8010287d:	0f b6 15 60 47 11 80 	movzbl 0x80114760,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102884:	c1 eb 10             	shr    $0x10,%ebx
  return ioapic->data;
80102887:	8b 41 10             	mov    0x10(%ecx),%eax
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
8010288a:	0f b6 db             	movzbl %bl,%ebx
  id = ioapicread(REG_ID) >> 24;
8010288d:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80102890:	39 c2                	cmp    %eax,%edx
80102892:	74 16                	je     801028aa <ioapicinit+0x5a>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102894:	83 ec 0c             	sub    $0xc,%esp
80102897:	68 f4 91 10 80       	push   $0x801091f4
8010289c:	e8 bf dd ff ff       	call   80100660 <cprintf>
801028a1:	8b 0d 34 46 11 80    	mov    0x80114634,%ecx
801028a7:	83 c4 10             	add    $0x10,%esp
801028aa:	83 c3 21             	add    $0x21,%ebx
{
801028ad:	ba 10 00 00 00       	mov    $0x10,%edx
801028b2:	b8 20 00 00 00       	mov    $0x20,%eax
801028b7:	89 f6                	mov    %esi,%esi
801028b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  ioapic->reg = reg;
801028c0:	89 11                	mov    %edx,(%ecx)
  ioapic->data = data;
801028c2:	8b 0d 34 46 11 80    	mov    0x80114634,%ecx

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
801028c8:	89 c6                	mov    %eax,%esi
801028ca:	81 ce 00 00 01 00    	or     $0x10000,%esi
801028d0:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
801028d3:	89 71 10             	mov    %esi,0x10(%ecx)
801028d6:	8d 72 01             	lea    0x1(%edx),%esi
801028d9:	83 c2 02             	add    $0x2,%edx
  for(i = 0; i <= maxintr; i++){
801028dc:	39 d8                	cmp    %ebx,%eax
  ioapic->reg = reg;
801028de:	89 31                	mov    %esi,(%ecx)
  ioapic->data = data;
801028e0:	8b 0d 34 46 11 80    	mov    0x80114634,%ecx
801028e6:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
801028ed:	75 d1                	jne    801028c0 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
801028ef:	8d 65 f8             	lea    -0x8(%ebp),%esp
801028f2:	5b                   	pop    %ebx
801028f3:	5e                   	pop    %esi
801028f4:	5d                   	pop    %ebp
801028f5:	c3                   	ret    
801028f6:	8d 76 00             	lea    0x0(%esi),%esi
801028f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102900 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102900:	55                   	push   %ebp
  ioapic->reg = reg;
80102901:	8b 0d 34 46 11 80    	mov    0x80114634,%ecx
{
80102907:	89 e5                	mov    %esp,%ebp
80102909:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
8010290c:	8d 50 20             	lea    0x20(%eax),%edx
8010290f:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
80102913:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102915:	8b 0d 34 46 11 80    	mov    0x80114634,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010291b:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
8010291e:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102921:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
80102924:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102926:	a1 34 46 11 80       	mov    0x80114634,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010292b:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
8010292e:	89 50 10             	mov    %edx,0x10(%eax)
}
80102931:	5d                   	pop    %ebp
80102932:	c3                   	ret    
80102933:	66 90                	xchg   %ax,%ax
80102935:	66 90                	xchg   %ax,%ax
80102937:	66 90                	xchg   %ax,%ax
80102939:	66 90                	xchg   %ax,%ax
8010293b:	66 90                	xchg   %ax,%ax
8010293d:	66 90                	xchg   %ax,%ax
8010293f:	90                   	nop

80102940 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102940:	55                   	push   %ebp
80102941:	89 e5                	mov    %esp,%ebp
80102943:	53                   	push   %ebx
80102944:	83 ec 04             	sub    $0x4,%esp
80102947:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
8010294a:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
80102950:	75 70                	jne    801029c2 <kfree+0x82>
80102952:	81 fb 18 d0 11 80    	cmp    $0x8011d018,%ebx
80102958:	72 68                	jb     801029c2 <kfree+0x82>
8010295a:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102960:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102965:	77 5b                	ja     801029c2 <kfree+0x82>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102967:	83 ec 04             	sub    $0x4,%esp
8010296a:	68 00 10 00 00       	push   $0x1000
8010296f:	6a 01                	push   $0x1
80102971:	53                   	push   %ebx
80102972:	e8 99 2e 00 00       	call   80105810 <memset>

  if(kmem.use_lock)
80102977:	8b 15 74 46 11 80    	mov    0x80114674,%edx
8010297d:	83 c4 10             	add    $0x10,%esp
80102980:	85 d2                	test   %edx,%edx
80102982:	75 2c                	jne    801029b0 <kfree+0x70>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102984:	a1 78 46 11 80       	mov    0x80114678,%eax
80102989:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
8010298b:	a1 74 46 11 80       	mov    0x80114674,%eax
  kmem.freelist = r;
80102990:	89 1d 78 46 11 80    	mov    %ebx,0x80114678
  if(kmem.use_lock)
80102996:	85 c0                	test   %eax,%eax
80102998:	75 06                	jne    801029a0 <kfree+0x60>
    release(&kmem.lock);
}
8010299a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010299d:	c9                   	leave  
8010299e:	c3                   	ret    
8010299f:	90                   	nop
    release(&kmem.lock);
801029a0:	c7 45 08 40 46 11 80 	movl   $0x80114640,0x8(%ebp)
}
801029a7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801029aa:	c9                   	leave  
    release(&kmem.lock);
801029ab:	e9 10 2e 00 00       	jmp    801057c0 <release>
    acquire(&kmem.lock);
801029b0:	83 ec 0c             	sub    $0xc,%esp
801029b3:	68 40 46 11 80       	push   $0x80114640
801029b8:	e8 43 2d 00 00       	call   80105700 <acquire>
801029bd:	83 c4 10             	add    $0x10,%esp
801029c0:	eb c2                	jmp    80102984 <kfree+0x44>
    panic("kfree");
801029c2:	83 ec 0c             	sub    $0xc,%esp
801029c5:	68 26 92 10 80       	push   $0x80109226
801029ca:	e8 c1 d9 ff ff       	call   80100390 <panic>
801029cf:	90                   	nop

801029d0 <freerange>:
{
801029d0:	55                   	push   %ebp
801029d1:	89 e5                	mov    %esp,%ebp
801029d3:	56                   	push   %esi
801029d4:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
801029d5:	8b 45 08             	mov    0x8(%ebp),%eax
{
801029d8:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
801029db:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801029e1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801029e7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801029ed:	39 de                	cmp    %ebx,%esi
801029ef:	72 23                	jb     80102a14 <freerange+0x44>
801029f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
801029f8:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
801029fe:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102a01:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102a07:	50                   	push   %eax
80102a08:	e8 33 ff ff ff       	call   80102940 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102a0d:	83 c4 10             	add    $0x10,%esp
80102a10:	39 f3                	cmp    %esi,%ebx
80102a12:	76 e4                	jbe    801029f8 <freerange+0x28>
}
80102a14:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102a17:	5b                   	pop    %ebx
80102a18:	5e                   	pop    %esi
80102a19:	5d                   	pop    %ebp
80102a1a:	c3                   	ret    
80102a1b:	90                   	nop
80102a1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102a20 <kinit1>:
{
80102a20:	55                   	push   %ebp
80102a21:	89 e5                	mov    %esp,%ebp
80102a23:	56                   	push   %esi
80102a24:	53                   	push   %ebx
80102a25:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
80102a28:	83 ec 08             	sub    $0x8,%esp
80102a2b:	68 2c 92 10 80       	push   $0x8010922c
80102a30:	68 40 46 11 80       	push   $0x80114640
80102a35:	e8 86 2b 00 00       	call   801055c0 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
80102a3a:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102a3d:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102a40:	c7 05 74 46 11 80 00 	movl   $0x0,0x80114674
80102a47:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
80102a4a:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102a50:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102a56:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102a5c:	39 de                	cmp    %ebx,%esi
80102a5e:	72 1c                	jb     80102a7c <kinit1+0x5c>
    kfree(p);
80102a60:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
80102a66:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102a69:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102a6f:	50                   	push   %eax
80102a70:	e8 cb fe ff ff       	call   80102940 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102a75:	83 c4 10             	add    $0x10,%esp
80102a78:	39 de                	cmp    %ebx,%esi
80102a7a:	73 e4                	jae    80102a60 <kinit1+0x40>
}
80102a7c:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102a7f:	5b                   	pop    %ebx
80102a80:	5e                   	pop    %esi
80102a81:	5d                   	pop    %ebp
80102a82:	c3                   	ret    
80102a83:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102a89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102a90 <kinit2>:
{
80102a90:	55                   	push   %ebp
80102a91:	89 e5                	mov    %esp,%ebp
80102a93:	56                   	push   %esi
80102a94:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
80102a95:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102a98:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
80102a9b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102aa1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102aa7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102aad:	39 de                	cmp    %ebx,%esi
80102aaf:	72 23                	jb     80102ad4 <kinit2+0x44>
80102ab1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102ab8:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
80102abe:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102ac1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102ac7:	50                   	push   %eax
80102ac8:	e8 73 fe ff ff       	call   80102940 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102acd:	83 c4 10             	add    $0x10,%esp
80102ad0:	39 de                	cmp    %ebx,%esi
80102ad2:	73 e4                	jae    80102ab8 <kinit2+0x28>
  kmem.use_lock = 1;
80102ad4:	c7 05 74 46 11 80 01 	movl   $0x1,0x80114674
80102adb:	00 00 00 
}
80102ade:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102ae1:	5b                   	pop    %ebx
80102ae2:	5e                   	pop    %esi
80102ae3:	5d                   	pop    %ebp
80102ae4:	c3                   	ret    
80102ae5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102ae9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102af0 <kalloc>:
char*
kalloc(void)
{
  struct run *r;

  if(kmem.use_lock)
80102af0:	a1 74 46 11 80       	mov    0x80114674,%eax
80102af5:	85 c0                	test   %eax,%eax
80102af7:	75 1f                	jne    80102b18 <kalloc+0x28>
    acquire(&kmem.lock);
  r = kmem.freelist;
80102af9:	a1 78 46 11 80       	mov    0x80114678,%eax
  if(r)
80102afe:	85 c0                	test   %eax,%eax
80102b00:	74 0e                	je     80102b10 <kalloc+0x20>
    kmem.freelist = r->next;
80102b02:	8b 10                	mov    (%eax),%edx
80102b04:	89 15 78 46 11 80    	mov    %edx,0x80114678
80102b0a:	c3                   	ret    
80102b0b:	90                   	nop
80102b0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(kmem.use_lock)
    release(&kmem.lock);
  return (char*)r;
}
80102b10:	f3 c3                	repz ret 
80102b12:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
{
80102b18:	55                   	push   %ebp
80102b19:	89 e5                	mov    %esp,%ebp
80102b1b:	83 ec 24             	sub    $0x24,%esp
    acquire(&kmem.lock);
80102b1e:	68 40 46 11 80       	push   $0x80114640
80102b23:	e8 d8 2b 00 00       	call   80105700 <acquire>
  r = kmem.freelist;
80102b28:	a1 78 46 11 80       	mov    0x80114678,%eax
  if(r)
80102b2d:	83 c4 10             	add    $0x10,%esp
80102b30:	8b 15 74 46 11 80    	mov    0x80114674,%edx
80102b36:	85 c0                	test   %eax,%eax
80102b38:	74 08                	je     80102b42 <kalloc+0x52>
    kmem.freelist = r->next;
80102b3a:	8b 08                	mov    (%eax),%ecx
80102b3c:	89 0d 78 46 11 80    	mov    %ecx,0x80114678
  if(kmem.use_lock)
80102b42:	85 d2                	test   %edx,%edx
80102b44:	74 16                	je     80102b5c <kalloc+0x6c>
    release(&kmem.lock);
80102b46:	83 ec 0c             	sub    $0xc,%esp
80102b49:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102b4c:	68 40 46 11 80       	push   $0x80114640
80102b51:	e8 6a 2c 00 00       	call   801057c0 <release>
  return (char*)r;
80102b56:	8b 45 f4             	mov    -0xc(%ebp),%eax
    release(&kmem.lock);
80102b59:	83 c4 10             	add    $0x10,%esp
}
80102b5c:	c9                   	leave  
80102b5d:	c3                   	ret    
80102b5e:	66 90                	xchg   %ax,%ax

80102b60 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b60:	ba 64 00 00 00       	mov    $0x64,%edx
80102b65:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80102b66:	a8 01                	test   $0x1,%al
80102b68:	0f 84 c2 00 00 00    	je     80102c30 <kbdgetc+0xd0>
80102b6e:	ba 60 00 00 00       	mov    $0x60,%edx
80102b73:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);
80102b74:	0f b6 d0             	movzbl %al,%edx
80102b77:	8b 0d b4 c5 10 80    	mov    0x8010c5b4,%ecx

  if(data == 0xE0){
80102b7d:	81 fa e0 00 00 00    	cmp    $0xe0,%edx
80102b83:	0f 84 7f 00 00 00    	je     80102c08 <kbdgetc+0xa8>
{
80102b89:	55                   	push   %ebp
80102b8a:	89 e5                	mov    %esp,%ebp
80102b8c:	53                   	push   %ebx
80102b8d:	89 cb                	mov    %ecx,%ebx
80102b8f:	83 e3 40             	and    $0x40,%ebx
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
80102b92:	84 c0                	test   %al,%al
80102b94:	78 4a                	js     80102be0 <kbdgetc+0x80>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
80102b96:	85 db                	test   %ebx,%ebx
80102b98:	74 09                	je     80102ba3 <kbdgetc+0x43>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102b9a:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
80102b9d:	83 e1 bf             	and    $0xffffffbf,%ecx
    data |= 0x80;
80102ba0:	0f b6 d0             	movzbl %al,%edx
  }

  shift |= shiftcode[data];
80102ba3:	0f b6 82 60 93 10 80 	movzbl -0x7fef6ca0(%edx),%eax
80102baa:	09 c1                	or     %eax,%ecx
  shift ^= togglecode[data];
80102bac:	0f b6 82 60 92 10 80 	movzbl -0x7fef6da0(%edx),%eax
80102bb3:	31 c1                	xor    %eax,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102bb5:	89 c8                	mov    %ecx,%eax
  shift ^= togglecode[data];
80102bb7:	89 0d b4 c5 10 80    	mov    %ecx,0x8010c5b4
  c = charcode[shift & (CTL | SHIFT)][data];
80102bbd:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
80102bc0:	83 e1 08             	and    $0x8,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102bc3:	8b 04 85 40 92 10 80 	mov    -0x7fef6dc0(,%eax,4),%eax
80102bca:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
  if(shift & CAPSLOCK){
80102bce:	74 31                	je     80102c01 <kbdgetc+0xa1>
    if('a' <= c && c <= 'z')
80102bd0:	8d 50 9f             	lea    -0x61(%eax),%edx
80102bd3:	83 fa 19             	cmp    $0x19,%edx
80102bd6:	77 40                	ja     80102c18 <kbdgetc+0xb8>
      c += 'A' - 'a';
80102bd8:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102bdb:	5b                   	pop    %ebx
80102bdc:	5d                   	pop    %ebp
80102bdd:	c3                   	ret    
80102bde:	66 90                	xchg   %ax,%ax
    data = (shift & E0ESC ? data : data & 0x7F);
80102be0:	83 e0 7f             	and    $0x7f,%eax
80102be3:	85 db                	test   %ebx,%ebx
80102be5:	0f 44 d0             	cmove  %eax,%edx
    shift &= ~(shiftcode[data] | E0ESC);
80102be8:	0f b6 82 60 93 10 80 	movzbl -0x7fef6ca0(%edx),%eax
80102bef:	83 c8 40             	or     $0x40,%eax
80102bf2:	0f b6 c0             	movzbl %al,%eax
80102bf5:	f7 d0                	not    %eax
80102bf7:	21 c1                	and    %eax,%ecx
    return 0;
80102bf9:	31 c0                	xor    %eax,%eax
    shift &= ~(shiftcode[data] | E0ESC);
80102bfb:	89 0d b4 c5 10 80    	mov    %ecx,0x8010c5b4
}
80102c01:	5b                   	pop    %ebx
80102c02:	5d                   	pop    %ebp
80102c03:	c3                   	ret    
80102c04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    shift |= E0ESC;
80102c08:	83 c9 40             	or     $0x40,%ecx
    return 0;
80102c0b:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
80102c0d:	89 0d b4 c5 10 80    	mov    %ecx,0x8010c5b4
    return 0;
80102c13:	c3                   	ret    
80102c14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    else if('A' <= c && c <= 'Z')
80102c18:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
80102c1b:	8d 50 20             	lea    0x20(%eax),%edx
}
80102c1e:	5b                   	pop    %ebx
      c += 'a' - 'A';
80102c1f:	83 f9 1a             	cmp    $0x1a,%ecx
80102c22:	0f 42 c2             	cmovb  %edx,%eax
}
80102c25:	5d                   	pop    %ebp
80102c26:	c3                   	ret    
80102c27:	89 f6                	mov    %esi,%esi
80102c29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80102c30:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102c35:	c3                   	ret    
80102c36:	8d 76 00             	lea    0x0(%esi),%esi
80102c39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102c40 <kbdintr>:

void
kbdintr(void)
{
80102c40:	55                   	push   %ebp
80102c41:	89 e5                	mov    %esp,%ebp
80102c43:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
80102c46:	68 60 2b 10 80       	push   $0x80102b60
80102c4b:	e8 c0 db ff ff       	call   80100810 <consoleintr>
}
80102c50:	83 c4 10             	add    $0x10,%esp
80102c53:	c9                   	leave  
80102c54:	c3                   	ret    
80102c55:	66 90                	xchg   %ax,%ax
80102c57:	66 90                	xchg   %ax,%ax
80102c59:	66 90                	xchg   %ax,%ax
80102c5b:	66 90                	xchg   %ax,%ax
80102c5d:	66 90                	xchg   %ax,%ax
80102c5f:	90                   	nop

80102c60 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
80102c60:	a1 7c 46 11 80       	mov    0x8011467c,%eax
{
80102c65:	55                   	push   %ebp
80102c66:	89 e5                	mov    %esp,%ebp
  if(!lapic)
80102c68:	85 c0                	test   %eax,%eax
80102c6a:	0f 84 c8 00 00 00    	je     80102d38 <lapicinit+0xd8>
  lapic[index] = value;
80102c70:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102c77:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102c7a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102c7d:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102c84:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102c87:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102c8a:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
80102c91:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102c94:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102c97:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
80102c9e:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
80102ca1:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102ca4:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
80102cab:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102cae:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102cb1:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102cb8:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102cbb:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
80102cbe:	8b 50 30             	mov    0x30(%eax),%edx
80102cc1:	c1 ea 10             	shr    $0x10,%edx
80102cc4:	80 fa 03             	cmp    $0x3,%dl
80102cc7:	77 77                	ja     80102d40 <lapicinit+0xe0>
  lapic[index] = value;
80102cc9:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102cd0:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102cd3:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102cd6:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102cdd:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102ce0:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102ce3:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102cea:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102ced:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102cf0:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102cf7:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102cfa:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102cfd:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102d04:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102d07:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102d0a:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102d11:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102d14:	8b 50 20             	mov    0x20(%eax),%edx
80102d17:	89 f6                	mov    %esi,%esi
80102d19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80102d20:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
80102d26:	80 e6 10             	and    $0x10,%dh
80102d29:	75 f5                	jne    80102d20 <lapicinit+0xc0>
  lapic[index] = value;
80102d2b:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80102d32:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102d35:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102d38:	5d                   	pop    %ebp
80102d39:	c3                   	ret    
80102d3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  lapic[index] = value;
80102d40:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80102d47:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102d4a:	8b 50 20             	mov    0x20(%eax),%edx
80102d4d:	e9 77 ff ff ff       	jmp    80102cc9 <lapicinit+0x69>
80102d52:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102d59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102d60 <lapicid>:

int
lapicid(void)
{
  if (!lapic)
80102d60:	8b 15 7c 46 11 80    	mov    0x8011467c,%edx
{
80102d66:	55                   	push   %ebp
80102d67:	31 c0                	xor    %eax,%eax
80102d69:	89 e5                	mov    %esp,%ebp
  if (!lapic)
80102d6b:	85 d2                	test   %edx,%edx
80102d6d:	74 06                	je     80102d75 <lapicid+0x15>
    return 0;
  return lapic[ID] >> 24;
80102d6f:	8b 42 20             	mov    0x20(%edx),%eax
80102d72:	c1 e8 18             	shr    $0x18,%eax
}
80102d75:	5d                   	pop    %ebp
80102d76:	c3                   	ret    
80102d77:	89 f6                	mov    %esi,%esi
80102d79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102d80 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80102d80:	a1 7c 46 11 80       	mov    0x8011467c,%eax
{
80102d85:	55                   	push   %ebp
80102d86:	89 e5                	mov    %esp,%ebp
  if(lapic)
80102d88:	85 c0                	test   %eax,%eax
80102d8a:	74 0d                	je     80102d99 <lapiceoi+0x19>
  lapic[index] = value;
80102d8c:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102d93:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102d96:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
80102d99:	5d                   	pop    %ebp
80102d9a:	c3                   	ret    
80102d9b:	90                   	nop
80102d9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102da0 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80102da0:	55                   	push   %ebp
80102da1:	89 e5                	mov    %esp,%ebp
}
80102da3:	5d                   	pop    %ebp
80102da4:	c3                   	ret    
80102da5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102da9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102db0 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102db0:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102db1:	b8 0f 00 00 00       	mov    $0xf,%eax
80102db6:	ba 70 00 00 00       	mov    $0x70,%edx
80102dbb:	89 e5                	mov    %esp,%ebp
80102dbd:	53                   	push   %ebx
80102dbe:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102dc1:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102dc4:	ee                   	out    %al,(%dx)
80102dc5:	b8 0a 00 00 00       	mov    $0xa,%eax
80102dca:	ba 71 00 00 00       	mov    $0x71,%edx
80102dcf:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102dd0:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80102dd2:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
80102dd5:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
80102ddb:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
80102ddd:	c1 e9 0c             	shr    $0xc,%ecx
  wrv[1] = addr >> 4;
80102de0:	c1 e8 04             	shr    $0x4,%eax
  lapicw(ICRHI, apicid<<24);
80102de3:	89 da                	mov    %ebx,%edx
    lapicw(ICRLO, STARTUP | (addr>>12));
80102de5:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
80102de8:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
80102dee:	a1 7c 46 11 80       	mov    0x8011467c,%eax
80102df3:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102df9:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102dfc:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80102e03:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102e06:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102e09:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102e10:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102e13:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102e16:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102e1c:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102e1f:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102e25:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102e28:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102e2e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102e31:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102e37:	8b 40 20             	mov    0x20(%eax),%eax
    microdelay(200);
  }
}
80102e3a:	5b                   	pop    %ebx
80102e3b:	5d                   	pop    %ebp
80102e3c:	c3                   	ret    
80102e3d:	8d 76 00             	lea    0x0(%esi),%esi

80102e40 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
80102e40:	55                   	push   %ebp
80102e41:	b8 0b 00 00 00       	mov    $0xb,%eax
80102e46:	ba 70 00 00 00       	mov    $0x70,%edx
80102e4b:	89 e5                	mov    %esp,%ebp
80102e4d:	57                   	push   %edi
80102e4e:	56                   	push   %esi
80102e4f:	53                   	push   %ebx
80102e50:	83 ec 4c             	sub    $0x4c,%esp
80102e53:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102e54:	ba 71 00 00 00       	mov    $0x71,%edx
80102e59:	ec                   	in     (%dx),%al
80102e5a:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102e5d:	bb 70 00 00 00       	mov    $0x70,%ebx
80102e62:	88 45 b3             	mov    %al,-0x4d(%ebp)
80102e65:	8d 76 00             	lea    0x0(%esi),%esi
80102e68:	31 c0                	xor    %eax,%eax
80102e6a:	89 da                	mov    %ebx,%edx
80102e6c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102e6d:	b9 71 00 00 00       	mov    $0x71,%ecx
80102e72:	89 ca                	mov    %ecx,%edx
80102e74:	ec                   	in     (%dx),%al
80102e75:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102e78:	89 da                	mov    %ebx,%edx
80102e7a:	b8 02 00 00 00       	mov    $0x2,%eax
80102e7f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102e80:	89 ca                	mov    %ecx,%edx
80102e82:	ec                   	in     (%dx),%al
80102e83:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102e86:	89 da                	mov    %ebx,%edx
80102e88:	b8 04 00 00 00       	mov    $0x4,%eax
80102e8d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102e8e:	89 ca                	mov    %ecx,%edx
80102e90:	ec                   	in     (%dx),%al
80102e91:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102e94:	89 da                	mov    %ebx,%edx
80102e96:	b8 07 00 00 00       	mov    $0x7,%eax
80102e9b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102e9c:	89 ca                	mov    %ecx,%edx
80102e9e:	ec                   	in     (%dx),%al
80102e9f:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ea2:	89 da                	mov    %ebx,%edx
80102ea4:	b8 08 00 00 00       	mov    $0x8,%eax
80102ea9:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102eaa:	89 ca                	mov    %ecx,%edx
80102eac:	ec                   	in     (%dx),%al
80102ead:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102eaf:	89 da                	mov    %ebx,%edx
80102eb1:	b8 09 00 00 00       	mov    $0x9,%eax
80102eb6:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102eb7:	89 ca                	mov    %ecx,%edx
80102eb9:	ec                   	in     (%dx),%al
80102eba:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ebc:	89 da                	mov    %ebx,%edx
80102ebe:	b8 0a 00 00 00       	mov    $0xa,%eax
80102ec3:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ec4:	89 ca                	mov    %ecx,%edx
80102ec6:	ec                   	in     (%dx),%al
  bcd = (sb & (1 << 2)) == 0;

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102ec7:	84 c0                	test   %al,%al
80102ec9:	78 9d                	js     80102e68 <cmostime+0x28>
  return inb(CMOS_RETURN);
80102ecb:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
80102ecf:	89 fa                	mov    %edi,%edx
80102ed1:	0f b6 fa             	movzbl %dl,%edi
80102ed4:	89 f2                	mov    %esi,%edx
80102ed6:	0f b6 f2             	movzbl %dl,%esi
80102ed9:	89 7d c8             	mov    %edi,-0x38(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102edc:	89 da                	mov    %ebx,%edx
80102ede:	89 75 cc             	mov    %esi,-0x34(%ebp)
80102ee1:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102ee4:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80102ee8:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102eeb:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
80102eef:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102ef2:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80102ef6:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102ef9:	31 c0                	xor    %eax,%eax
80102efb:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102efc:	89 ca                	mov    %ecx,%edx
80102efe:	ec                   	in     (%dx),%al
80102eff:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102f02:	89 da                	mov    %ebx,%edx
80102f04:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102f07:	b8 02 00 00 00       	mov    $0x2,%eax
80102f0c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102f0d:	89 ca                	mov    %ecx,%edx
80102f0f:	ec                   	in     (%dx),%al
80102f10:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102f13:	89 da                	mov    %ebx,%edx
80102f15:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102f18:	b8 04 00 00 00       	mov    $0x4,%eax
80102f1d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102f1e:	89 ca                	mov    %ecx,%edx
80102f20:	ec                   	in     (%dx),%al
80102f21:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102f24:	89 da                	mov    %ebx,%edx
80102f26:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102f29:	b8 07 00 00 00       	mov    $0x7,%eax
80102f2e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102f2f:	89 ca                	mov    %ecx,%edx
80102f31:	ec                   	in     (%dx),%al
80102f32:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102f35:	89 da                	mov    %ebx,%edx
80102f37:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102f3a:	b8 08 00 00 00       	mov    $0x8,%eax
80102f3f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102f40:	89 ca                	mov    %ecx,%edx
80102f42:	ec                   	in     (%dx),%al
80102f43:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102f46:	89 da                	mov    %ebx,%edx
80102f48:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102f4b:	b8 09 00 00 00       	mov    $0x9,%eax
80102f50:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102f51:	89 ca                	mov    %ecx,%edx
80102f53:	ec                   	in     (%dx),%al
80102f54:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102f57:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
80102f5a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102f5d:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102f60:	6a 18                	push   $0x18
80102f62:	50                   	push   %eax
80102f63:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102f66:	50                   	push   %eax
80102f67:	e8 f4 28 00 00       	call   80105860 <memcmp>
80102f6c:	83 c4 10             	add    $0x10,%esp
80102f6f:	85 c0                	test   %eax,%eax
80102f71:	0f 85 f1 fe ff ff    	jne    80102e68 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
80102f77:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
80102f7b:	75 78                	jne    80102ff5 <cmostime+0x1b5>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102f7d:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102f80:	89 c2                	mov    %eax,%edx
80102f82:	83 e0 0f             	and    $0xf,%eax
80102f85:	c1 ea 04             	shr    $0x4,%edx
80102f88:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102f8b:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102f8e:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102f91:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102f94:	89 c2                	mov    %eax,%edx
80102f96:	83 e0 0f             	and    $0xf,%eax
80102f99:	c1 ea 04             	shr    $0x4,%edx
80102f9c:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102f9f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102fa2:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102fa5:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102fa8:	89 c2                	mov    %eax,%edx
80102faa:	83 e0 0f             	and    $0xf,%eax
80102fad:	c1 ea 04             	shr    $0x4,%edx
80102fb0:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102fb3:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102fb6:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102fb9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102fbc:	89 c2                	mov    %eax,%edx
80102fbe:	83 e0 0f             	and    $0xf,%eax
80102fc1:	c1 ea 04             	shr    $0x4,%edx
80102fc4:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102fc7:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102fca:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80102fcd:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102fd0:	89 c2                	mov    %eax,%edx
80102fd2:	83 e0 0f             	and    $0xf,%eax
80102fd5:	c1 ea 04             	shr    $0x4,%edx
80102fd8:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102fdb:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102fde:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80102fe1:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102fe4:	89 c2                	mov    %eax,%edx
80102fe6:	83 e0 0f             	and    $0xf,%eax
80102fe9:	c1 ea 04             	shr    $0x4,%edx
80102fec:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102fef:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102ff2:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102ff5:	8b 75 08             	mov    0x8(%ebp),%esi
80102ff8:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102ffb:	89 06                	mov    %eax,(%esi)
80102ffd:	8b 45 bc             	mov    -0x44(%ebp),%eax
80103000:	89 46 04             	mov    %eax,0x4(%esi)
80103003:	8b 45 c0             	mov    -0x40(%ebp),%eax
80103006:	89 46 08             	mov    %eax,0x8(%esi)
80103009:	8b 45 c4             	mov    -0x3c(%ebp),%eax
8010300c:	89 46 0c             	mov    %eax,0xc(%esi)
8010300f:	8b 45 c8             	mov    -0x38(%ebp),%eax
80103012:	89 46 10             	mov    %eax,0x10(%esi)
80103015:	8b 45 cc             	mov    -0x34(%ebp),%eax
80103018:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
8010301b:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
80103022:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103025:	5b                   	pop    %ebx
80103026:	5e                   	pop    %esi
80103027:	5f                   	pop    %edi
80103028:	5d                   	pop    %ebp
80103029:	c3                   	ret    
8010302a:	66 90                	xchg   %ax,%ax
8010302c:	66 90                	xchg   %ax,%ax
8010302e:	66 90                	xchg   %ax,%ax

80103030 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80103030:	8b 0d c8 46 11 80    	mov    0x801146c8,%ecx
80103036:	85 c9                	test   %ecx,%ecx
80103038:	0f 8e 8a 00 00 00    	jle    801030c8 <install_trans+0x98>
{
8010303e:	55                   	push   %ebp
8010303f:	89 e5                	mov    %esp,%ebp
80103041:	57                   	push   %edi
80103042:	56                   	push   %esi
80103043:	53                   	push   %ebx
  for (tail = 0; tail < log.lh.n; tail++) {
80103044:	31 db                	xor    %ebx,%ebx
{
80103046:	83 ec 0c             	sub    $0xc,%esp
80103049:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80103050:	a1 b4 46 11 80       	mov    0x801146b4,%eax
80103055:	83 ec 08             	sub    $0x8,%esp
80103058:	01 d8                	add    %ebx,%eax
8010305a:	83 c0 01             	add    $0x1,%eax
8010305d:	50                   	push   %eax
8010305e:	ff 35 c4 46 11 80    	pushl  0x801146c4
80103064:	e8 67 d0 ff ff       	call   801000d0 <bread>
80103069:	89 c7                	mov    %eax,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
8010306b:	58                   	pop    %eax
8010306c:	5a                   	pop    %edx
8010306d:	ff 34 9d cc 46 11 80 	pushl  -0x7feeb934(,%ebx,4)
80103074:	ff 35 c4 46 11 80    	pushl  0x801146c4
  for (tail = 0; tail < log.lh.n; tail++) {
8010307a:	83 c3 01             	add    $0x1,%ebx
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
8010307d:	e8 4e d0 ff ff       	call   801000d0 <bread>
80103082:	89 c6                	mov    %eax,%esi
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80103084:	8d 47 5c             	lea    0x5c(%edi),%eax
80103087:	83 c4 0c             	add    $0xc,%esp
8010308a:	68 00 02 00 00       	push   $0x200
8010308f:	50                   	push   %eax
80103090:	8d 46 5c             	lea    0x5c(%esi),%eax
80103093:	50                   	push   %eax
80103094:	e8 27 28 00 00       	call   801058c0 <memmove>
    bwrite(dbuf);  // write dst to disk
80103099:	89 34 24             	mov    %esi,(%esp)
8010309c:	e8 ff d0 ff ff       	call   801001a0 <bwrite>
    brelse(lbuf);
801030a1:	89 3c 24             	mov    %edi,(%esp)
801030a4:	e8 37 d1 ff ff       	call   801001e0 <brelse>
    brelse(dbuf);
801030a9:	89 34 24             	mov    %esi,(%esp)
801030ac:	e8 2f d1 ff ff       	call   801001e0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
801030b1:	83 c4 10             	add    $0x10,%esp
801030b4:	39 1d c8 46 11 80    	cmp    %ebx,0x801146c8
801030ba:	7f 94                	jg     80103050 <install_trans+0x20>
  }
}
801030bc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801030bf:	5b                   	pop    %ebx
801030c0:	5e                   	pop    %esi
801030c1:	5f                   	pop    %edi
801030c2:	5d                   	pop    %ebp
801030c3:	c3                   	ret    
801030c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801030c8:	f3 c3                	repz ret 
801030ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801030d0 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
801030d0:	55                   	push   %ebp
801030d1:	89 e5                	mov    %esp,%ebp
801030d3:	56                   	push   %esi
801030d4:	53                   	push   %ebx
  struct buf *buf = bread(log.dev, log.start);
801030d5:	83 ec 08             	sub    $0x8,%esp
801030d8:	ff 35 b4 46 11 80    	pushl  0x801146b4
801030de:	ff 35 c4 46 11 80    	pushl  0x801146c4
801030e4:	e8 e7 cf ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
801030e9:	8b 1d c8 46 11 80    	mov    0x801146c8,%ebx
  for (i = 0; i < log.lh.n; i++) {
801030ef:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
801030f2:	89 c6                	mov    %eax,%esi
  for (i = 0; i < log.lh.n; i++) {
801030f4:	85 db                	test   %ebx,%ebx
  hb->n = log.lh.n;
801030f6:	89 58 5c             	mov    %ebx,0x5c(%eax)
  for (i = 0; i < log.lh.n; i++) {
801030f9:	7e 16                	jle    80103111 <write_head+0x41>
801030fb:	c1 e3 02             	shl    $0x2,%ebx
801030fe:	31 d2                	xor    %edx,%edx
    hb->block[i] = log.lh.block[i];
80103100:	8b 8a cc 46 11 80    	mov    -0x7feeb934(%edx),%ecx
80103106:	89 4c 16 60          	mov    %ecx,0x60(%esi,%edx,1)
8010310a:	83 c2 04             	add    $0x4,%edx
  for (i = 0; i < log.lh.n; i++) {
8010310d:	39 da                	cmp    %ebx,%edx
8010310f:	75 ef                	jne    80103100 <write_head+0x30>
  }
  bwrite(buf);
80103111:	83 ec 0c             	sub    $0xc,%esp
80103114:	56                   	push   %esi
80103115:	e8 86 d0 ff ff       	call   801001a0 <bwrite>
  brelse(buf);
8010311a:	89 34 24             	mov    %esi,(%esp)
8010311d:	e8 be d0 ff ff       	call   801001e0 <brelse>
}
80103122:	83 c4 10             	add    $0x10,%esp
80103125:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103128:	5b                   	pop    %ebx
80103129:	5e                   	pop    %esi
8010312a:	5d                   	pop    %ebp
8010312b:	c3                   	ret    
8010312c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103130 <write_log>:
static void
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80103130:	8b 0d c8 46 11 80    	mov    0x801146c8,%ecx
80103136:	85 c9                	test   %ecx,%ecx
80103138:	0f 8e 8a 00 00 00    	jle    801031c8 <write_log+0x98>
{
8010313e:	55                   	push   %ebp
8010313f:	89 e5                	mov    %esp,%ebp
80103141:	57                   	push   %edi
80103142:	56                   	push   %esi
80103143:	53                   	push   %ebx
  for (tail = 0; tail < log.lh.n; tail++) {
80103144:	31 db                	xor    %ebx,%ebx
{
80103146:	83 ec 0c             	sub    $0xc,%esp
80103149:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80103150:	a1 b4 46 11 80       	mov    0x801146b4,%eax
80103155:	83 ec 08             	sub    $0x8,%esp
80103158:	01 d8                	add    %ebx,%eax
8010315a:	83 c0 01             	add    $0x1,%eax
8010315d:	50                   	push   %eax
8010315e:	ff 35 c4 46 11 80    	pushl  0x801146c4
80103164:	e8 67 cf ff ff       	call   801000d0 <bread>
80103169:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
8010316b:	58                   	pop    %eax
8010316c:	5a                   	pop    %edx
8010316d:	ff 34 9d cc 46 11 80 	pushl  -0x7feeb934(,%ebx,4)
80103174:	ff 35 c4 46 11 80    	pushl  0x801146c4
  for (tail = 0; tail < log.lh.n; tail++) {
8010317a:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
8010317d:	e8 4e cf ff ff       	call   801000d0 <bread>
80103182:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80103184:	8d 40 5c             	lea    0x5c(%eax),%eax
80103187:	83 c4 0c             	add    $0xc,%esp
8010318a:	68 00 02 00 00       	push   $0x200
8010318f:	50                   	push   %eax
80103190:	8d 46 5c             	lea    0x5c(%esi),%eax
80103193:	50                   	push   %eax
80103194:	e8 27 27 00 00       	call   801058c0 <memmove>
    bwrite(to);  // write the log
80103199:	89 34 24             	mov    %esi,(%esp)
8010319c:	e8 ff cf ff ff       	call   801001a0 <bwrite>
    brelse(from);
801031a1:	89 3c 24             	mov    %edi,(%esp)
801031a4:	e8 37 d0 ff ff       	call   801001e0 <brelse>
    brelse(to);
801031a9:	89 34 24             	mov    %esi,(%esp)
801031ac:	e8 2f d0 ff ff       	call   801001e0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
801031b1:	83 c4 10             	add    $0x10,%esp
801031b4:	39 1d c8 46 11 80    	cmp    %ebx,0x801146c8
801031ba:	7f 94                	jg     80103150 <write_log+0x20>
  }
}
801031bc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801031bf:	5b                   	pop    %ebx
801031c0:	5e                   	pop    %esi
801031c1:	5f                   	pop    %edi
801031c2:	5d                   	pop    %ebp
801031c3:	c3                   	ret    
801031c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801031c8:	f3 c3                	repz ret 
801031ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801031d0 <initlog>:
{
801031d0:	55                   	push   %ebp
801031d1:	89 e5                	mov    %esp,%ebp
801031d3:	53                   	push   %ebx
801031d4:	83 ec 2c             	sub    $0x2c,%esp
801031d7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
801031da:	68 60 94 10 80       	push   $0x80109460
801031df:	68 80 46 11 80       	push   $0x80114680
801031e4:	e8 d7 23 00 00       	call   801055c0 <initlock>
  readsb(dev, &sb);
801031e9:	58                   	pop    %eax
801031ea:	8d 45 dc             	lea    -0x24(%ebp),%eax
801031ed:	5a                   	pop    %edx
801031ee:	50                   	push   %eax
801031ef:	53                   	push   %ebx
801031f0:	e8 9b e6 ff ff       	call   80101890 <readsb>
  log.size = sb.nlog;
801031f5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
801031f8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
801031fb:	59                   	pop    %ecx
  log.dev = dev;
801031fc:	89 1d c4 46 11 80    	mov    %ebx,0x801146c4
  log.size = sb.nlog;
80103202:	89 15 b8 46 11 80    	mov    %edx,0x801146b8
  log.start = sb.logstart;
80103208:	a3 b4 46 11 80       	mov    %eax,0x801146b4
  struct buf *buf = bread(log.dev, log.start);
8010320d:	5a                   	pop    %edx
8010320e:	50                   	push   %eax
8010320f:	53                   	push   %ebx
80103210:	e8 bb ce ff ff       	call   801000d0 <bread>
  log.lh.n = lh->n;
80103215:	8b 58 5c             	mov    0x5c(%eax),%ebx
  for (i = 0; i < log.lh.n; i++) {
80103218:	83 c4 10             	add    $0x10,%esp
8010321b:	85 db                	test   %ebx,%ebx
  log.lh.n = lh->n;
8010321d:	89 1d c8 46 11 80    	mov    %ebx,0x801146c8
  for (i = 0; i < log.lh.n; i++) {
80103223:	7e 1c                	jle    80103241 <initlog+0x71>
80103225:	c1 e3 02             	shl    $0x2,%ebx
80103228:	31 d2                	xor    %edx,%edx
8010322a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    log.lh.block[i] = lh->block[i];
80103230:	8b 4c 10 60          	mov    0x60(%eax,%edx,1),%ecx
80103234:	83 c2 04             	add    $0x4,%edx
80103237:	89 8a c8 46 11 80    	mov    %ecx,-0x7feeb938(%edx)
  for (i = 0; i < log.lh.n; i++) {
8010323d:	39 d3                	cmp    %edx,%ebx
8010323f:	75 ef                	jne    80103230 <initlog+0x60>
  brelse(buf);
80103241:	83 ec 0c             	sub    $0xc,%esp
80103244:	50                   	push   %eax
80103245:	e8 96 cf ff ff       	call   801001e0 <brelse>
  install_trans(); // if committed, copy from log to disk
8010324a:	e8 e1 fd ff ff       	call   80103030 <install_trans>
  log.lh.n = 0;
8010324f:	c7 05 c8 46 11 80 00 	movl   $0x0,0x801146c8
80103256:	00 00 00 
  write_head(); // clear the log
80103259:	e8 72 fe ff ff       	call   801030d0 <write_head>
}
8010325e:	83 c4 10             	add    $0x10,%esp
80103261:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103264:	c9                   	leave  
80103265:	c3                   	ret    
80103266:	8d 76 00             	lea    0x0(%esi),%esi
80103269:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103270 <begin_op>:
{
80103270:	55                   	push   %ebp
80103271:	89 e5                	mov    %esp,%ebp
80103273:	53                   	push   %ebx
80103274:	83 ec 10             	sub    $0x10,%esp
  acquire(&log.lock);
80103277:	68 80 46 11 80       	push   $0x80114680
8010327c:	e8 7f 24 00 00       	call   80105700 <acquire>
80103281:	83 c4 10             	add    $0x10,%esp
80103284:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(log.committing){
80103288:	8b 15 c0 46 11 80    	mov    0x801146c0,%edx
8010328e:	85 d2                	test   %edx,%edx
80103290:	75 56                	jne    801032e8 <begin_op+0x78>
    } else if(log.outstanding > 0 || isBufFull() == 1 || log.lh.n + (log.outstanding+2)*MAXOPBLOCKS > LOGSIZE){
80103292:	8b 1d bc 46 11 80    	mov    0x801146bc,%ebx
80103298:	85 db                	test   %ebx,%ebx
8010329a:	7f 4c                	jg     801032e8 <begin_op+0x78>
isBufFull(void)
{
  struct buf *b;
  int count = 0;

  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
8010329c:	a1 0c 1d 11 80       	mov    0x80111d0c,%eax
801032a1:	3d bc 1c 11 80       	cmp    $0x80111cbc,%eax
801032a6:	74 40                	je     801032e8 <begin_op+0x78>
801032a8:	90                   	nop
801032a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0)
801032b0:	8b 48 4c             	mov    0x4c(%eax),%ecx
801032b3:	85 c9                	test   %ecx,%ecx
801032b5:	75 0b                	jne    801032c2 <begin_op+0x52>
801032b7:	8b 08                	mov    (%eax),%ecx
801032b9:	83 e1 04             	and    $0x4,%ecx
    {
      count++;
801032bc:	83 f9 01             	cmp    $0x1,%ecx
801032bf:	83 d2 00             	adc    $0x0,%edx
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
801032c2:	8b 40 50             	mov    0x50(%eax),%eax
801032c5:	3d bc 1c 11 80       	cmp    $0x80111cbc,%eax
801032ca:	75 e4                	jne    801032b0 <begin_op+0x40>
    }
  }
  if(count <= 1+MAXOPBLOCKS)
801032cc:	83 fa 0b             	cmp    $0xb,%edx
801032cf:	7e 17                	jle    801032e8 <begin_op+0x78>
    } else if(log.outstanding > 0 || isBufFull() == 1 || log.lh.n + (log.outstanding+2)*MAXOPBLOCKS > LOGSIZE){
801032d1:	8b 15 c8 46 11 80    	mov    0x801146c8,%edx
801032d7:	8d 44 9b 0a          	lea    0xa(%ebx,%ebx,4),%eax
801032db:	8d 04 42             	lea    (%edx,%eax,2),%eax
801032de:	83 f8 1e             	cmp    $0x1e,%eax
801032e1:	7e 1d                	jle    80103300 <begin_op+0x90>
801032e3:	90                   	nop
801032e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      sleep(&log, &log.lock);
801032e8:	83 ec 08             	sub    $0x8,%esp
801032eb:	68 80 46 11 80       	push   $0x80114680
801032f0:	68 80 46 11 80       	push   $0x80114680
801032f5:	e8 a6 15 00 00       	call   801048a0 <sleep>
801032fa:	83 c4 10             	add    $0x10,%esp
801032fd:	eb 89                	jmp    80103288 <begin_op+0x18>
801032ff:	90                   	nop
      release(&log.lock);
80103300:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80103303:	83 c3 01             	add    $0x1,%ebx
      release(&log.lock);
80103306:	68 80 46 11 80       	push   $0x80114680
      log.outstanding += 1;
8010330b:	89 1d bc 46 11 80    	mov    %ebx,0x801146bc
      release(&log.lock);
80103311:	e8 aa 24 00 00       	call   801057c0 <release>
}
80103316:	83 c4 10             	add    $0x10,%esp
80103319:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010331c:	c9                   	leave  
8010331d:	c3                   	ret    
8010331e:	66 90                	xchg   %ax,%ax

80103320 <end_op>:
{
80103320:	55                   	push   %ebp
80103321:	89 e5                	mov    %esp,%ebp
80103323:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80103326:	68 80 46 11 80       	push   $0x80114680
8010332b:	e8 d0 23 00 00       	call   80105700 <acquire>
  log.outstanding -= 1;
80103330:	a1 bc 46 11 80       	mov    0x801146bc,%eax
  if(log.committing)
80103335:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80103338:	8d 50 ff             	lea    -0x1(%eax),%edx
  if(log.committing)
8010333b:	a1 c0 46 11 80       	mov    0x801146c0,%eax
  log.outstanding -= 1;
80103340:	89 15 bc 46 11 80    	mov    %edx,0x801146bc
  if(log.committing)
80103346:	85 c0                	test   %eax,%eax
80103348:	0f 85 e0 00 00 00    	jne    8010342e <end_op+0x10e>
  if(log.outstanding == 0 &&( isBufFull() == 1 || log.lh.n + (log.outstanding+2)*MAXOPBLOCKS > LOGSIZE)){
8010334e:	85 d2                	test   %edx,%edx
80103350:	0f 85 ba 00 00 00    	jne    80103410 <end_op+0xf0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80103356:	a1 0c 1d 11 80       	mov    0x80111d0c,%eax
8010335b:	3d bc 1c 11 80       	cmp    $0x80111cbc,%eax
80103360:	74 30                	je     80103392 <end_op+0x72>
80103362:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0)
80103368:	8b 48 4c             	mov    0x4c(%eax),%ecx
8010336b:	85 c9                	test   %ecx,%ecx
8010336d:	75 0b                	jne    8010337a <end_op+0x5a>
8010336f:	8b 08                	mov    (%eax),%ecx
80103371:	83 e1 04             	and    $0x4,%ecx
      count++;
80103374:	83 f9 01             	cmp    $0x1,%ecx
80103377:	83 d2 00             	adc    $0x0,%edx
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
8010337a:	8b 40 50             	mov    0x50(%eax),%eax
8010337d:	3d bc 1c 11 80       	cmp    $0x80111cbc,%eax
80103382:	75 e4                	jne    80103368 <end_op+0x48>
  if(count <= 1+MAXOPBLOCKS)
80103384:	83 fa 0b             	cmp    $0xb,%edx
80103387:	7e 09                	jle    80103392 <end_op+0x72>
  if(log.outstanding == 0 &&( isBufFull() == 1 || log.lh.n + (log.outstanding+2)*MAXOPBLOCKS > LOGSIZE)){
80103389:	83 3d c8 46 11 80 0a 	cmpl   $0xa,0x801146c8
80103390:	7e 7e                	jle    80103410 <end_op+0xf0>
  release(&log.lock);
80103392:	83 ec 0c             	sub    $0xc,%esp
    log.committing = 1;
80103395:	c7 05 c0 46 11 80 01 	movl   $0x1,0x801146c0
8010339c:	00 00 00 
  release(&log.lock);
8010339f:	68 80 46 11 80       	push   $0x80114680
801033a4:	e8 17 24 00 00       	call   801057c0 <release>
  if (log.lh.n > 0) {
801033a9:	a1 c8 46 11 80       	mov    0x801146c8,%eax
801033ae:	83 c4 10             	add    $0x10,%esp
801033b1:	85 c0                	test   %eax,%eax
801033b3:	7f 3b                	jg     801033f0 <end_op+0xd0>
    acquire(&log.lock);
801033b5:	83 ec 0c             	sub    $0xc,%esp
801033b8:	68 80 46 11 80       	push   $0x80114680
801033bd:	e8 3e 23 00 00       	call   80105700 <acquire>
    wakeup(&log);
801033c2:	c7 04 24 80 46 11 80 	movl   $0x80114680,(%esp)
    log.committing = 0;
801033c9:	c7 05 c0 46 11 80 00 	movl   $0x0,0x801146c0
801033d0:	00 00 00 
    wakeup(&log);
801033d3:	e8 18 19 00 00       	call   80104cf0 <wakeup>
    release(&log.lock);
801033d8:	c7 04 24 80 46 11 80 	movl   $0x80114680,(%esp)
801033df:	e8 dc 23 00 00       	call   801057c0 <release>
801033e4:	83 c4 10             	add    $0x10,%esp
}
801033e7:	c9                   	leave  
801033e8:	c3                   	ret    
801033e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    write_log();     // Write modified blocks from cache to log
801033f0:	e8 3b fd ff ff       	call   80103130 <write_log>
    write_head();    // Write header to disk -- the real commit
801033f5:	e8 d6 fc ff ff       	call   801030d0 <write_head>
    install_trans(); // Now install writes to home locations
801033fa:	e8 31 fc ff ff       	call   80103030 <install_trans>
    log.lh.n = 0;
801033ff:	c7 05 c8 46 11 80 00 	movl   $0x0,0x801146c8
80103406:	00 00 00 
    write_head();    // Erase the transaction from the log
80103409:	e8 c2 fc ff ff       	call   801030d0 <write_head>
8010340e:	eb a5                	jmp    801033b5 <end_op+0x95>
    wakeup(&log);
80103410:	83 ec 0c             	sub    $0xc,%esp
80103413:	68 80 46 11 80       	push   $0x80114680
80103418:	e8 d3 18 00 00       	call   80104cf0 <wakeup>
  release(&log.lock);
8010341d:	c7 04 24 80 46 11 80 	movl   $0x80114680,(%esp)
80103424:	e8 97 23 00 00       	call   801057c0 <release>
80103429:	83 c4 10             	add    $0x10,%esp
}
8010342c:	c9                   	leave  
8010342d:	c3                   	ret    
    panic("log.committing");
8010342e:	83 ec 0c             	sub    $0xc,%esp
80103431:	68 64 94 10 80       	push   $0x80109464
80103436:	e8 55 cf ff ff       	call   80100390 <panic>
8010343b:	90                   	nop
8010343c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103440 <isBufFull>:
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80103440:	a1 0c 1d 11 80       	mov    0x80111d0c,%eax
{
80103445:	55                   	push   %ebp
80103446:	89 e5                	mov    %esp,%ebp
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80103448:	3d bc 1c 11 80       	cmp    $0x80111cbc,%eax
8010344d:	74 31                	je     80103480 <isBufFull+0x40>
  int count = 0;
8010344f:	31 c9                	xor    %ecx,%ecx
80103451:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0)
80103458:	8b 50 4c             	mov    0x4c(%eax),%edx
8010345b:	85 d2                	test   %edx,%edx
8010345d:	75 0b                	jne    8010346a <isBufFull+0x2a>
8010345f:	8b 10                	mov    (%eax),%edx
80103461:	83 e2 04             	and    $0x4,%edx
      count++;
80103464:	83 fa 01             	cmp    $0x1,%edx
80103467:	83 d1 00             	adc    $0x0,%ecx
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
8010346a:	8b 40 50             	mov    0x50(%eax),%eax
8010346d:	3d bc 1c 11 80       	cmp    $0x80111cbc,%eax
80103472:	75 e4                	jne    80103458 <isBufFull+0x18>
80103474:	31 c0                	xor    %eax,%eax
80103476:	83 f9 0b             	cmp    $0xb,%ecx
80103479:	0f 9e c0             	setle  %al
  }
  else
  {
    return 0;
  }
}
8010347c:	5d                   	pop    %ebp
8010347d:	c3                   	ret    
8010347e:	66 90                	xchg   %ax,%ax
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80103480:	b8 01 00 00 00       	mov    $0x1,%eax
}
80103485:	5d                   	pop    %ebp
80103486:	c3                   	ret    
80103487:	89 f6                	mov    %esi,%esi
80103489:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103490 <sync>:

//project03 - milestone03
int
sync(void)
{
80103490:	55                   	push   %ebp
80103491:	89 e5                	mov    %esp,%ebp
80103493:	83 ec 08             	sub    $0x8,%esp
  if (log.lh.n > 0) {
80103496:	a1 c8 46 11 80       	mov    0x801146c8,%eax
  log.committing = 1;
8010349b:	c7 05 c0 46 11 80 01 	movl   $0x1,0x801146c0
801034a2:	00 00 00 
  if (log.lh.n > 0) {
801034a5:	85 c0                	test   %eax,%eax
801034a7:	7e 1e                	jle    801034c7 <sync+0x37>
    write_log();     // Write modified blocks from cache to log
801034a9:	e8 82 fc ff ff       	call   80103130 <write_log>
    write_head();    // Write header to disk -- the real commit
801034ae:	e8 1d fc ff ff       	call   801030d0 <write_head>
    install_trans(); // Now install writes to home locations
801034b3:	e8 78 fb ff ff       	call   80103030 <install_trans>
    log.lh.n = 0;
801034b8:	c7 05 c8 46 11 80 00 	movl   $0x0,0x801146c8
801034bf:	00 00 00 
    write_head();    // Erase the transaction from the log
801034c2:	e8 09 fc ff ff       	call   801030d0 <write_head>

  commit();
  acquire(&log.lock);
801034c7:	83 ec 0c             	sub    $0xc,%esp
801034ca:	68 80 46 11 80       	push   $0x80114680
801034cf:	e8 2c 22 00 00       	call   80105700 <acquire>
  log.committing = 0;
  wakeup(&log);
801034d4:	c7 04 24 80 46 11 80 	movl   $0x80114680,(%esp)
  log.committing = 0;
801034db:	c7 05 c0 46 11 80 00 	movl   $0x0,0x801146c0
801034e2:	00 00 00 
  wakeup(&log);
801034e5:	e8 06 18 00 00       	call   80104cf0 <wakeup>
  release(&log.lock);
801034ea:	c7 04 24 80 46 11 80 	movl   $0x80114680,(%esp)
801034f1:	e8 ca 22 00 00       	call   801057c0 <release>

  return 0;
}
801034f6:	31 c0                	xor    %eax,%eax
801034f8:	c9                   	leave  
801034f9:	c3                   	ret    
801034fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103500 <get_log_num>:


//project03 - milestone03
int
get_log_num(void)
{
80103500:	55                   	push   %ebp
  return log.lh.n;
}
80103501:	a1 c8 46 11 80       	mov    0x801146c8,%eax
{
80103506:	89 e5                	mov    %esp,%ebp
}
80103508:	5d                   	pop    %ebp
80103509:	c3                   	ret    
8010350a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103510 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80103510:	55                   	push   %ebp
80103511:	89 e5                	mov    %esp,%ebp
80103513:	53                   	push   %ebx
80103514:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103517:	8b 15 c8 46 11 80    	mov    0x801146c8,%edx
{
8010351d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103520:	83 fa 1d             	cmp    $0x1d,%edx
80103523:	0f 8f 9d 00 00 00    	jg     801035c6 <log_write+0xb6>
80103529:	a1 b8 46 11 80       	mov    0x801146b8,%eax
8010352e:	83 e8 01             	sub    $0x1,%eax
80103531:	39 c2                	cmp    %eax,%edx
80103533:	0f 8d 8d 00 00 00    	jge    801035c6 <log_write+0xb6>
    panic("too big a transaction");
  if (log.outstanding < 1)
80103539:	a1 bc 46 11 80       	mov    0x801146bc,%eax
8010353e:	85 c0                	test   %eax,%eax
80103540:	0f 8e 8d 00 00 00    	jle    801035d3 <log_write+0xc3>
    panic("log_write outside of trans");

  acquire(&log.lock);
80103546:	83 ec 0c             	sub    $0xc,%esp
80103549:	68 80 46 11 80       	push   $0x80114680
8010354e:	e8 ad 21 00 00       	call   80105700 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80103553:	8b 0d c8 46 11 80    	mov    0x801146c8,%ecx
80103559:	83 c4 10             	add    $0x10,%esp
8010355c:	83 f9 00             	cmp    $0x0,%ecx
8010355f:	7e 57                	jle    801035b8 <log_write+0xa8>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103561:	8b 53 08             	mov    0x8(%ebx),%edx
  for (i = 0; i < log.lh.n; i++) {
80103564:	31 c0                	xor    %eax,%eax
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103566:	3b 15 cc 46 11 80    	cmp    0x801146cc,%edx
8010356c:	75 0b                	jne    80103579 <log_write+0x69>
8010356e:	eb 38                	jmp    801035a8 <log_write+0x98>
80103570:	39 14 85 cc 46 11 80 	cmp    %edx,-0x7feeb934(,%eax,4)
80103577:	74 2f                	je     801035a8 <log_write+0x98>
  for (i = 0; i < log.lh.n; i++) {
80103579:	83 c0 01             	add    $0x1,%eax
8010357c:	39 c1                	cmp    %eax,%ecx
8010357e:	75 f0                	jne    80103570 <log_write+0x60>
      break;
  }
  log.lh.block[i] = b->blockno;
80103580:	89 14 85 cc 46 11 80 	mov    %edx,-0x7feeb934(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
80103587:	83 c0 01             	add    $0x1,%eax
8010358a:	a3 c8 46 11 80       	mov    %eax,0x801146c8
  b->flags |= B_DIRTY; // prevent eviction
8010358f:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
80103592:	c7 45 08 80 46 11 80 	movl   $0x80114680,0x8(%ebp)
}
80103599:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010359c:	c9                   	leave  
  release(&log.lock);
8010359d:	e9 1e 22 00 00       	jmp    801057c0 <release>
801035a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
801035a8:	89 14 85 cc 46 11 80 	mov    %edx,-0x7feeb934(,%eax,4)
801035af:	eb de                	jmp    8010358f <log_write+0x7f>
801035b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801035b8:	8b 43 08             	mov    0x8(%ebx),%eax
801035bb:	a3 cc 46 11 80       	mov    %eax,0x801146cc
  if (i == log.lh.n)
801035c0:	75 cd                	jne    8010358f <log_write+0x7f>
801035c2:	31 c0                	xor    %eax,%eax
801035c4:	eb c1                	jmp    80103587 <log_write+0x77>
    panic("too big a transaction");
801035c6:	83 ec 0c             	sub    $0xc,%esp
801035c9:	68 73 94 10 80       	push   $0x80109473
801035ce:	e8 bd cd ff ff       	call   80100390 <panic>
    panic("log_write outside of trans");
801035d3:	83 ec 0c             	sub    $0xc,%esp
801035d6:	68 89 94 10 80       	push   $0x80109489
801035db:	e8 b0 cd ff ff       	call   80100390 <panic>

801035e0 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
801035e0:	55                   	push   %ebp
801035e1:	89 e5                	mov    %esp,%ebp
801035e3:	53                   	push   %ebx
801035e4:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
801035e7:	e8 a4 0c 00 00       	call   80104290 <cpuid>
801035ec:	89 c3                	mov    %eax,%ebx
801035ee:	e8 9d 0c 00 00       	call   80104290 <cpuid>
801035f3:	83 ec 04             	sub    $0x4,%esp
801035f6:	53                   	push   %ebx
801035f7:	50                   	push   %eax
801035f8:	68 a4 94 10 80       	push   $0x801094a4
801035fd:	e8 5e d0 ff ff       	call   80100660 <cprintf>
  idtinit();       // load idt register
80103602:	e8 f9 36 00 00       	call   80106d00 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80103607:	e8 04 0c 00 00       	call   80104210 <mycpu>
8010360c:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
8010360e:	b8 01 00 00 00       	mov    $0x1,%eax
80103613:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
8010361a:	e8 c1 54 00 00       	call   80108ae0 <scheduler>
8010361f:	90                   	nop

80103620 <mpenter>:
{
80103620:	55                   	push   %ebp
80103621:	89 e5                	mov    %esp,%ebp
80103623:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80103626:	e8 25 48 00 00       	call   80107e50 <switchkvm>
  seginit();
8010362b:	e8 90 47 00 00       	call   80107dc0 <seginit>
  lapicinit();
80103630:	e8 2b f6 ff ff       	call   80102c60 <lapicinit>
  mpmain();
80103635:	e8 a6 ff ff ff       	call   801035e0 <mpmain>
8010363a:	66 90                	xchg   %ax,%ax
8010363c:	66 90                	xchg   %ax,%ax
8010363e:	66 90                	xchg   %ax,%ax

80103640 <main>:
{
80103640:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80103644:	83 e4 f0             	and    $0xfffffff0,%esp
80103647:	ff 71 fc             	pushl  -0x4(%ecx)
8010364a:	55                   	push   %ebp
8010364b:	89 e5                	mov    %esp,%ebp
8010364d:	53                   	push   %ebx
8010364e:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
8010364f:	83 ec 08             	sub    $0x8,%esp
80103652:	68 00 00 40 80       	push   $0x80400000
80103657:	68 18 d0 11 80       	push   $0x8011d018
8010365c:	e8 bf f3 ff ff       	call   80102a20 <kinit1>
  kvmalloc();      // kernel page table
80103661:	e8 ba 4d 00 00       	call   80108420 <kvmalloc>
  mpinit();        // detect other processors
80103666:	e8 75 01 00 00       	call   801037e0 <mpinit>
  lapicinit();     // interrupt controller
8010366b:	e8 f0 f5 ff ff       	call   80102c60 <lapicinit>
  seginit();       // segment descriptors
80103670:	e8 4b 47 00 00       	call   80107dc0 <seginit>
  picinit();       // disable pic
80103675:	e8 46 03 00 00       	call   801039c0 <picinit>
  ioapicinit();    // another interrupt controller
8010367a:	e8 d1 f1 ff ff       	call   80102850 <ioapicinit>
  consoleinit();   // console hardware
8010367f:	e8 3c d3 ff ff       	call   801009c0 <consoleinit>
  uartinit();      // serial port
80103684:	e8 07 3a 00 00       	call   80107090 <uartinit>
  pinit();         // process table
80103689:	e8 62 0b 00 00       	call   801041f0 <pinit>
  tvinit();        // trap vectors
8010368e:	e8 ed 35 00 00       	call   80106c80 <tvinit>
  binit();         // buffer cache
80103693:	e8 a8 c9 ff ff       	call   80100040 <binit>
  fileinit();      // file table
80103698:	e8 73 d7 ff ff       	call   80100e10 <fileinit>
  ideinit();       // disk 
8010369d:	e8 8e ef ff ff       	call   80102630 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
801036a2:	83 c4 0c             	add    $0xc,%esp
801036a5:	68 8a 00 00 00       	push   $0x8a
801036aa:	68 8c c4 10 80       	push   $0x8010c48c
801036af:	68 00 70 00 80       	push   $0x80007000
801036b4:	e8 07 22 00 00       	call   801058c0 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
801036b9:	69 05 00 4d 11 80 b0 	imul   $0xb0,0x80114d00,%eax
801036c0:	00 00 00 
801036c3:	83 c4 10             	add    $0x10,%esp
801036c6:	05 80 47 11 80       	add    $0x80114780,%eax
801036cb:	3d 80 47 11 80       	cmp    $0x80114780,%eax
801036d0:	76 71                	jbe    80103743 <main+0x103>
801036d2:	bb 80 47 11 80       	mov    $0x80114780,%ebx
801036d7:	89 f6                	mov    %esi,%esi
801036d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(c == mycpu())  // We've started already.
801036e0:	e8 2b 0b 00 00       	call   80104210 <mycpu>
801036e5:	39 d8                	cmp    %ebx,%eax
801036e7:	74 41                	je     8010372a <main+0xea>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
801036e9:	e8 02 f4 ff ff       	call   80102af0 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
801036ee:	05 00 10 00 00       	add    $0x1000,%eax
    *(void(**)(void))(code-8) = mpenter;
801036f3:	c7 05 f8 6f 00 80 20 	movl   $0x80103620,0x80006ff8
801036fa:	36 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
801036fd:	c7 05 f4 6f 00 80 00 	movl   $0x10b000,0x80006ff4
80103704:	b0 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
80103707:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc

    lapicstartap(c->apicid, V2P(code));
8010370c:	0f b6 03             	movzbl (%ebx),%eax
8010370f:	83 ec 08             	sub    $0x8,%esp
80103712:	68 00 70 00 00       	push   $0x7000
80103717:	50                   	push   %eax
80103718:	e8 93 f6 ff ff       	call   80102db0 <lapicstartap>
8010371d:	83 c4 10             	add    $0x10,%esp

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103720:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80103726:	85 c0                	test   %eax,%eax
80103728:	74 f6                	je     80103720 <main+0xe0>
  for(c = cpus; c < cpus+ncpu; c++){
8010372a:	69 05 00 4d 11 80 b0 	imul   $0xb0,0x80114d00,%eax
80103731:	00 00 00 
80103734:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
8010373a:	05 80 47 11 80       	add    $0x80114780,%eax
8010373f:	39 c3                	cmp    %eax,%ebx
80103741:	72 9d                	jb     801036e0 <main+0xa0>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103743:	83 ec 08             	sub    $0x8,%esp
80103746:	68 00 00 00 8e       	push   $0x8e000000
8010374b:	68 00 00 40 80       	push   $0x80400000
80103750:	e8 3b f3 ff ff       	call   80102a90 <kinit2>
  userinit();      // first user process
80103755:	e8 86 0b 00 00       	call   801042e0 <userinit>
  mpmain();        // finish this processor's setup
8010375a:	e8 81 fe ff ff       	call   801035e0 <mpmain>
8010375f:	90                   	nop

80103760 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103760:	55                   	push   %ebp
80103761:	89 e5                	mov    %esp,%ebp
80103763:	57                   	push   %edi
80103764:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80103765:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
8010376b:	53                   	push   %ebx
  e = addr+len;
8010376c:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
8010376f:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
80103772:	39 de                	cmp    %ebx,%esi
80103774:	72 10                	jb     80103786 <mpsearch1+0x26>
80103776:	eb 50                	jmp    801037c8 <mpsearch1+0x68>
80103778:	90                   	nop
80103779:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103780:	39 fb                	cmp    %edi,%ebx
80103782:	89 fe                	mov    %edi,%esi
80103784:	76 42                	jbe    801037c8 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103786:	83 ec 04             	sub    $0x4,%esp
80103789:	8d 7e 10             	lea    0x10(%esi),%edi
8010378c:	6a 04                	push   $0x4
8010378e:	68 b8 94 10 80       	push   $0x801094b8
80103793:	56                   	push   %esi
80103794:	e8 c7 20 00 00       	call   80105860 <memcmp>
80103799:	83 c4 10             	add    $0x10,%esp
8010379c:	85 c0                	test   %eax,%eax
8010379e:	75 e0                	jne    80103780 <mpsearch1+0x20>
801037a0:	89 f1                	mov    %esi,%ecx
801037a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
801037a8:	0f b6 11             	movzbl (%ecx),%edx
801037ab:	83 c1 01             	add    $0x1,%ecx
801037ae:	01 d0                	add    %edx,%eax
  for(i=0; i<len; i++)
801037b0:	39 f9                	cmp    %edi,%ecx
801037b2:	75 f4                	jne    801037a8 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801037b4:	84 c0                	test   %al,%al
801037b6:	75 c8                	jne    80103780 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
801037b8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801037bb:	89 f0                	mov    %esi,%eax
801037bd:	5b                   	pop    %ebx
801037be:	5e                   	pop    %esi
801037bf:	5f                   	pop    %edi
801037c0:	5d                   	pop    %ebp
801037c1:	c3                   	ret    
801037c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801037c8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801037cb:	31 f6                	xor    %esi,%esi
}
801037cd:	89 f0                	mov    %esi,%eax
801037cf:	5b                   	pop    %ebx
801037d0:	5e                   	pop    %esi
801037d1:	5f                   	pop    %edi
801037d2:	5d                   	pop    %ebp
801037d3:	c3                   	ret    
801037d4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801037da:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801037e0 <mpinit>:
  return conf;
}

void
mpinit(void)
{
801037e0:	55                   	push   %ebp
801037e1:	89 e5                	mov    %esp,%ebp
801037e3:	57                   	push   %edi
801037e4:	56                   	push   %esi
801037e5:	53                   	push   %ebx
801037e6:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
801037e9:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
801037f0:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
801037f7:	c1 e0 08             	shl    $0x8,%eax
801037fa:	09 d0                	or     %edx,%eax
801037fc:	c1 e0 04             	shl    $0x4,%eax
801037ff:	85 c0                	test   %eax,%eax
80103801:	75 1b                	jne    8010381e <mpinit+0x3e>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103803:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
8010380a:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
80103811:	c1 e0 08             	shl    $0x8,%eax
80103814:	09 d0                	or     %edx,%eax
80103816:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80103819:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
8010381e:	ba 00 04 00 00       	mov    $0x400,%edx
80103823:	e8 38 ff ff ff       	call   80103760 <mpsearch1>
80103828:	85 c0                	test   %eax,%eax
8010382a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010382d:	0f 84 3d 01 00 00    	je     80103970 <mpinit+0x190>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103833:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103836:	8b 58 04             	mov    0x4(%eax),%ebx
80103839:	85 db                	test   %ebx,%ebx
8010383b:	0f 84 4f 01 00 00    	je     80103990 <mpinit+0x1b0>
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80103841:	8d b3 00 00 00 80    	lea    -0x80000000(%ebx),%esi
  if(memcmp(conf, "PCMP", 4) != 0)
80103847:	83 ec 04             	sub    $0x4,%esp
8010384a:	6a 04                	push   $0x4
8010384c:	68 d5 94 10 80       	push   $0x801094d5
80103851:	56                   	push   %esi
80103852:	e8 09 20 00 00       	call   80105860 <memcmp>
80103857:	83 c4 10             	add    $0x10,%esp
8010385a:	85 c0                	test   %eax,%eax
8010385c:	0f 85 2e 01 00 00    	jne    80103990 <mpinit+0x1b0>
  if(conf->version != 1 && conf->version != 4)
80103862:	0f b6 83 06 00 00 80 	movzbl -0x7ffffffa(%ebx),%eax
80103869:	3c 01                	cmp    $0x1,%al
8010386b:	0f 95 c2             	setne  %dl
8010386e:	3c 04                	cmp    $0x4,%al
80103870:	0f 95 c0             	setne  %al
80103873:	20 c2                	and    %al,%dl
80103875:	0f 85 15 01 00 00    	jne    80103990 <mpinit+0x1b0>
  if(sum((uchar*)conf, conf->length) != 0)
8010387b:	0f b7 bb 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edi
  for(i=0; i<len; i++)
80103882:	66 85 ff             	test   %di,%di
80103885:	74 1a                	je     801038a1 <mpinit+0xc1>
80103887:	89 f0                	mov    %esi,%eax
80103889:	01 f7                	add    %esi,%edi
  sum = 0;
8010388b:	31 d2                	xor    %edx,%edx
8010388d:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
80103890:	0f b6 08             	movzbl (%eax),%ecx
80103893:	83 c0 01             	add    $0x1,%eax
80103896:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
80103898:	39 c7                	cmp    %eax,%edi
8010389a:	75 f4                	jne    80103890 <mpinit+0xb0>
8010389c:	84 d2                	test   %dl,%dl
8010389e:	0f 95 c2             	setne  %dl
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
801038a1:	85 f6                	test   %esi,%esi
801038a3:	0f 84 e7 00 00 00    	je     80103990 <mpinit+0x1b0>
801038a9:	84 d2                	test   %dl,%dl
801038ab:	0f 85 df 00 00 00    	jne    80103990 <mpinit+0x1b0>
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
801038b1:	8b 83 24 00 00 80    	mov    -0x7fffffdc(%ebx),%eax
801038b7:	a3 7c 46 11 80       	mov    %eax,0x8011467c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801038bc:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
801038c3:	8d 83 2c 00 00 80    	lea    -0x7fffffd4(%ebx),%eax
  ismp = 1;
801038c9:	bb 01 00 00 00       	mov    $0x1,%ebx
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801038ce:	01 d6                	add    %edx,%esi
801038d0:	39 c6                	cmp    %eax,%esi
801038d2:	76 23                	jbe    801038f7 <mpinit+0x117>
    switch(*p){
801038d4:	0f b6 10             	movzbl (%eax),%edx
801038d7:	80 fa 04             	cmp    $0x4,%dl
801038da:	0f 87 ca 00 00 00    	ja     801039aa <mpinit+0x1ca>
801038e0:	ff 24 95 fc 94 10 80 	jmp    *-0x7fef6b04(,%edx,4)
801038e7:	89 f6                	mov    %esi,%esi
801038e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
801038f0:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801038f3:	39 c6                	cmp    %eax,%esi
801038f5:	77 dd                	ja     801038d4 <mpinit+0xf4>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
801038f7:	85 db                	test   %ebx,%ebx
801038f9:	0f 84 9e 00 00 00    	je     8010399d <mpinit+0x1bd>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
801038ff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103902:	80 78 0c 00          	cmpb   $0x0,0xc(%eax)
80103906:	74 15                	je     8010391d <mpinit+0x13d>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103908:	b8 70 00 00 00       	mov    $0x70,%eax
8010390d:	ba 22 00 00 00       	mov    $0x22,%edx
80103912:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103913:	ba 23 00 00 00       	mov    $0x23,%edx
80103918:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80103919:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010391c:	ee                   	out    %al,(%dx)
  }
}
8010391d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103920:	5b                   	pop    %ebx
80103921:	5e                   	pop    %esi
80103922:	5f                   	pop    %edi
80103923:	5d                   	pop    %ebp
80103924:	c3                   	ret    
80103925:	8d 76 00             	lea    0x0(%esi),%esi
      if(ncpu < NCPU) {
80103928:	8b 0d 00 4d 11 80    	mov    0x80114d00,%ecx
8010392e:	83 f9 07             	cmp    $0x7,%ecx
80103931:	7f 19                	jg     8010394c <mpinit+0x16c>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103933:	0f b6 50 01          	movzbl 0x1(%eax),%edx
80103937:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
        ncpu++;
8010393d:	83 c1 01             	add    $0x1,%ecx
80103940:	89 0d 00 4d 11 80    	mov    %ecx,0x80114d00
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103946:	88 97 80 47 11 80    	mov    %dl,-0x7feeb880(%edi)
      p += sizeof(struct mpproc);
8010394c:	83 c0 14             	add    $0x14,%eax
      continue;
8010394f:	e9 7c ff ff ff       	jmp    801038d0 <mpinit+0xf0>
80103954:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
80103958:	0f b6 50 01          	movzbl 0x1(%eax),%edx
      p += sizeof(struct mpioapic);
8010395c:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
8010395f:	88 15 60 47 11 80    	mov    %dl,0x80114760
      continue;
80103965:	e9 66 ff ff ff       	jmp    801038d0 <mpinit+0xf0>
8010396a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return mpsearch1(0xF0000, 0x10000);
80103970:	ba 00 00 01 00       	mov    $0x10000,%edx
80103975:	b8 00 00 0f 00       	mov    $0xf0000,%eax
8010397a:	e8 e1 fd ff ff       	call   80103760 <mpsearch1>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
8010397f:	85 c0                	test   %eax,%eax
  return mpsearch1(0xF0000, 0x10000);
80103981:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103984:	0f 85 a9 fe ff ff    	jne    80103833 <mpinit+0x53>
8010398a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    panic("Expect to run on an SMP");
80103990:	83 ec 0c             	sub    $0xc,%esp
80103993:	68 bd 94 10 80       	push   $0x801094bd
80103998:	e8 f3 c9 ff ff       	call   80100390 <panic>
    panic("Didn't find a suitable machine");
8010399d:	83 ec 0c             	sub    $0xc,%esp
801039a0:	68 dc 94 10 80       	push   $0x801094dc
801039a5:	e8 e6 c9 ff ff       	call   80100390 <panic>
      ismp = 0;
801039aa:	31 db                	xor    %ebx,%ebx
801039ac:	e9 26 ff ff ff       	jmp    801038d7 <mpinit+0xf7>
801039b1:	66 90                	xchg   %ax,%ax
801039b3:	66 90                	xchg   %ax,%ax
801039b5:	66 90                	xchg   %ax,%ax
801039b7:	66 90                	xchg   %ax,%ax
801039b9:	66 90                	xchg   %ax,%ax
801039bb:	66 90                	xchg   %ax,%ax
801039bd:	66 90                	xchg   %ax,%ax
801039bf:	90                   	nop

801039c0 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
801039c0:	55                   	push   %ebp
801039c1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801039c6:	ba 21 00 00 00       	mov    $0x21,%edx
801039cb:	89 e5                	mov    %esp,%ebp
801039cd:	ee                   	out    %al,(%dx)
801039ce:	ba a1 00 00 00       	mov    $0xa1,%edx
801039d3:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
801039d4:	5d                   	pop    %ebp
801039d5:	c3                   	ret    
801039d6:	66 90                	xchg   %ax,%ax
801039d8:	66 90                	xchg   %ax,%ax
801039da:	66 90                	xchg   %ax,%ax
801039dc:	66 90                	xchg   %ax,%ax
801039de:	66 90                	xchg   %ax,%ax

801039e0 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
801039e0:	55                   	push   %ebp
801039e1:	89 e5                	mov    %esp,%ebp
801039e3:	57                   	push   %edi
801039e4:	56                   	push   %esi
801039e5:	53                   	push   %ebx
801039e6:	83 ec 0c             	sub    $0xc,%esp
801039e9:	8b 5d 08             	mov    0x8(%ebp),%ebx
801039ec:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
801039ef:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
801039f5:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
801039fb:	e8 30 d4 ff ff       	call   80100e30 <filealloc>
80103a00:	85 c0                	test   %eax,%eax
80103a02:	89 03                	mov    %eax,(%ebx)
80103a04:	74 22                	je     80103a28 <pipealloc+0x48>
80103a06:	e8 25 d4 ff ff       	call   80100e30 <filealloc>
80103a0b:	85 c0                	test   %eax,%eax
80103a0d:	89 06                	mov    %eax,(%esi)
80103a0f:	74 3f                	je     80103a50 <pipealloc+0x70>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103a11:	e8 da f0 ff ff       	call   80102af0 <kalloc>
80103a16:	85 c0                	test   %eax,%eax
80103a18:	89 c7                	mov    %eax,%edi
80103a1a:	75 54                	jne    80103a70 <pipealloc+0x90>

//PAGEBREAK: 20
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
80103a1c:	8b 03                	mov    (%ebx),%eax
80103a1e:	85 c0                	test   %eax,%eax
80103a20:	75 34                	jne    80103a56 <pipealloc+0x76>
80103a22:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    fileclose(*f0);
  if(*f1)
80103a28:	8b 06                	mov    (%esi),%eax
80103a2a:	85 c0                	test   %eax,%eax
80103a2c:	74 0c                	je     80103a3a <pipealloc+0x5a>
    fileclose(*f1);
80103a2e:	83 ec 0c             	sub    $0xc,%esp
80103a31:	50                   	push   %eax
80103a32:	e8 b9 d4 ff ff       	call   80100ef0 <fileclose>
80103a37:	83 c4 10             	add    $0x10,%esp
  return -1;
}
80103a3a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
80103a3d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103a42:	5b                   	pop    %ebx
80103a43:	5e                   	pop    %esi
80103a44:	5f                   	pop    %edi
80103a45:	5d                   	pop    %ebp
80103a46:	c3                   	ret    
80103a47:	89 f6                	mov    %esi,%esi
80103a49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  if(*f0)
80103a50:	8b 03                	mov    (%ebx),%eax
80103a52:	85 c0                	test   %eax,%eax
80103a54:	74 e4                	je     80103a3a <pipealloc+0x5a>
    fileclose(*f0);
80103a56:	83 ec 0c             	sub    $0xc,%esp
80103a59:	50                   	push   %eax
80103a5a:	e8 91 d4 ff ff       	call   80100ef0 <fileclose>
  if(*f1)
80103a5f:	8b 06                	mov    (%esi),%eax
    fileclose(*f0);
80103a61:	83 c4 10             	add    $0x10,%esp
  if(*f1)
80103a64:	85 c0                	test   %eax,%eax
80103a66:	75 c6                	jne    80103a2e <pipealloc+0x4e>
80103a68:	eb d0                	jmp    80103a3a <pipealloc+0x5a>
80103a6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  initlock(&p->lock, "pipe");
80103a70:	83 ec 08             	sub    $0x8,%esp
  p->readopen = 1;
80103a73:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
80103a7a:	00 00 00 
  p->writeopen = 1;
80103a7d:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80103a84:	00 00 00 
  p->nwrite = 0;
80103a87:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80103a8e:	00 00 00 
  p->nread = 0;
80103a91:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103a98:	00 00 00 
  initlock(&p->lock, "pipe");
80103a9b:	68 10 95 10 80       	push   $0x80109510
80103aa0:	50                   	push   %eax
80103aa1:	e8 1a 1b 00 00       	call   801055c0 <initlock>
  (*f0)->type = FD_PIPE;
80103aa6:	8b 03                	mov    (%ebx),%eax
  return 0;
80103aa8:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
80103aab:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103ab1:	8b 03                	mov    (%ebx),%eax
80103ab3:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80103ab7:	8b 03                	mov    (%ebx),%eax
80103ab9:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80103abd:	8b 03                	mov    (%ebx),%eax
80103abf:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
80103ac2:	8b 06                	mov    (%esi),%eax
80103ac4:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80103aca:	8b 06                	mov    (%esi),%eax
80103acc:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103ad0:	8b 06                	mov    (%esi),%eax
80103ad2:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80103ad6:	8b 06                	mov    (%esi),%eax
80103ad8:	89 78 0c             	mov    %edi,0xc(%eax)
}
80103adb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80103ade:	31 c0                	xor    %eax,%eax
}
80103ae0:	5b                   	pop    %ebx
80103ae1:	5e                   	pop    %esi
80103ae2:	5f                   	pop    %edi
80103ae3:	5d                   	pop    %ebp
80103ae4:	c3                   	ret    
80103ae5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103ae9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103af0 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103af0:	55                   	push   %ebp
80103af1:	89 e5                	mov    %esp,%ebp
80103af3:	56                   	push   %esi
80103af4:	53                   	push   %ebx
80103af5:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103af8:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
80103afb:	83 ec 0c             	sub    $0xc,%esp
80103afe:	53                   	push   %ebx
80103aff:	e8 fc 1b 00 00       	call   80105700 <acquire>
  if(writable){
80103b04:	83 c4 10             	add    $0x10,%esp
80103b07:	85 f6                	test   %esi,%esi
80103b09:	74 45                	je     80103b50 <pipeclose+0x60>
    p->writeopen = 0;
    wakeup(&p->nread);
80103b0b:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103b11:	83 ec 0c             	sub    $0xc,%esp
    p->writeopen = 0;
80103b14:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
80103b1b:	00 00 00 
    wakeup(&p->nread);
80103b1e:	50                   	push   %eax
80103b1f:	e8 cc 11 00 00       	call   80104cf0 <wakeup>
80103b24:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103b27:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
80103b2d:	85 d2                	test   %edx,%edx
80103b2f:	75 0a                	jne    80103b3b <pipeclose+0x4b>
80103b31:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80103b37:	85 c0                	test   %eax,%eax
80103b39:	74 35                	je     80103b70 <pipeclose+0x80>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
80103b3b:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80103b3e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103b41:	5b                   	pop    %ebx
80103b42:	5e                   	pop    %esi
80103b43:	5d                   	pop    %ebp
    release(&p->lock);
80103b44:	e9 77 1c 00 00       	jmp    801057c0 <release>
80103b49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    wakeup(&p->nwrite);
80103b50:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
80103b56:	83 ec 0c             	sub    $0xc,%esp
    p->readopen = 0;
80103b59:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103b60:	00 00 00 
    wakeup(&p->nwrite);
80103b63:	50                   	push   %eax
80103b64:	e8 87 11 00 00       	call   80104cf0 <wakeup>
80103b69:	83 c4 10             	add    $0x10,%esp
80103b6c:	eb b9                	jmp    80103b27 <pipeclose+0x37>
80103b6e:	66 90                	xchg   %ax,%ax
    release(&p->lock);
80103b70:	83 ec 0c             	sub    $0xc,%esp
80103b73:	53                   	push   %ebx
80103b74:	e8 47 1c 00 00       	call   801057c0 <release>
    kfree((char*)p);
80103b79:	89 5d 08             	mov    %ebx,0x8(%ebp)
80103b7c:	83 c4 10             	add    $0x10,%esp
}
80103b7f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103b82:	5b                   	pop    %ebx
80103b83:	5e                   	pop    %esi
80103b84:	5d                   	pop    %ebp
    kfree((char*)p);
80103b85:	e9 b6 ed ff ff       	jmp    80102940 <kfree>
80103b8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103b90 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103b90:	55                   	push   %ebp
80103b91:	89 e5                	mov    %esp,%ebp
80103b93:	57                   	push   %edi
80103b94:	56                   	push   %esi
80103b95:	53                   	push   %ebx
80103b96:	83 ec 28             	sub    $0x28,%esp
80103b99:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
80103b9c:	53                   	push   %ebx
80103b9d:	e8 5e 1b 00 00       	call   80105700 <acquire>
  for(i = 0; i < n; i++){
80103ba2:	8b 45 10             	mov    0x10(%ebp),%eax
80103ba5:	83 c4 10             	add    $0x10,%esp
80103ba8:	85 c0                	test   %eax,%eax
80103baa:	0f 8e c9 00 00 00    	jle    80103c79 <pipewrite+0xe9>
80103bb0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80103bb3:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103bb9:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
80103bbf:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80103bc2:	03 4d 10             	add    0x10(%ebp),%ecx
80103bc5:	89 4d e0             	mov    %ecx,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103bc8:	8b 8b 34 02 00 00    	mov    0x234(%ebx),%ecx
80103bce:	8d 91 00 02 00 00    	lea    0x200(%ecx),%edx
80103bd4:	39 d0                	cmp    %edx,%eax
80103bd6:	75 71                	jne    80103c49 <pipewrite+0xb9>
      if(p->readopen == 0 || myproc()->killed){
80103bd8:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
80103bde:	85 c0                	test   %eax,%eax
80103be0:	74 4e                	je     80103c30 <pipewrite+0xa0>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103be2:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
80103be8:	eb 3a                	jmp    80103c24 <pipewrite+0x94>
80103bea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      wakeup(&p->nread);
80103bf0:	83 ec 0c             	sub    $0xc,%esp
80103bf3:	57                   	push   %edi
80103bf4:	e8 f7 10 00 00       	call   80104cf0 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103bf9:	5a                   	pop    %edx
80103bfa:	59                   	pop    %ecx
80103bfb:	53                   	push   %ebx
80103bfc:	56                   	push   %esi
80103bfd:	e8 9e 0c 00 00       	call   801048a0 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103c02:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80103c08:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
80103c0e:	83 c4 10             	add    $0x10,%esp
80103c11:	05 00 02 00 00       	add    $0x200,%eax
80103c16:	39 c2                	cmp    %eax,%edx
80103c18:	75 36                	jne    80103c50 <pipewrite+0xc0>
      if(p->readopen == 0 || myproc()->killed){
80103c1a:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
80103c20:	85 c0                	test   %eax,%eax
80103c22:	74 0c                	je     80103c30 <pipewrite+0xa0>
80103c24:	e8 87 06 00 00       	call   801042b0 <myproc>
80103c29:	8b 40 24             	mov    0x24(%eax),%eax
80103c2c:	85 c0                	test   %eax,%eax
80103c2e:	74 c0                	je     80103bf0 <pipewrite+0x60>
        release(&p->lock);
80103c30:	83 ec 0c             	sub    $0xc,%esp
80103c33:	53                   	push   %ebx
80103c34:	e8 87 1b 00 00       	call   801057c0 <release>
        return -1;
80103c39:	83 c4 10             	add    $0x10,%esp
80103c3c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80103c41:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103c44:	5b                   	pop    %ebx
80103c45:	5e                   	pop    %esi
80103c46:	5f                   	pop    %edi
80103c47:	5d                   	pop    %ebp
80103c48:	c3                   	ret    
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103c49:	89 c2                	mov    %eax,%edx
80103c4b:	90                   	nop
80103c4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103c50:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80103c53:	8d 42 01             	lea    0x1(%edx),%eax
80103c56:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
80103c5c:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
80103c62:	83 c6 01             	add    $0x1,%esi
80103c65:	0f b6 4e ff          	movzbl -0x1(%esi),%ecx
  for(i = 0; i < n; i++){
80103c69:	3b 75 e0             	cmp    -0x20(%ebp),%esi
80103c6c:	89 75 e4             	mov    %esi,-0x1c(%ebp)
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103c6f:	88 4c 13 34          	mov    %cl,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
80103c73:	0f 85 4f ff ff ff    	jne    80103bc8 <pipewrite+0x38>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103c79:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103c7f:	83 ec 0c             	sub    $0xc,%esp
80103c82:	50                   	push   %eax
80103c83:	e8 68 10 00 00       	call   80104cf0 <wakeup>
  release(&p->lock);
80103c88:	89 1c 24             	mov    %ebx,(%esp)
80103c8b:	e8 30 1b 00 00       	call   801057c0 <release>
  return n;
80103c90:	83 c4 10             	add    $0x10,%esp
80103c93:	8b 45 10             	mov    0x10(%ebp),%eax
80103c96:	eb a9                	jmp    80103c41 <pipewrite+0xb1>
80103c98:	90                   	nop
80103c99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103ca0 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80103ca0:	55                   	push   %ebp
80103ca1:	89 e5                	mov    %esp,%ebp
80103ca3:	57                   	push   %edi
80103ca4:	56                   	push   %esi
80103ca5:	53                   	push   %ebx
80103ca6:	83 ec 18             	sub    $0x18,%esp
80103ca9:	8b 75 08             	mov    0x8(%ebp),%esi
80103cac:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
80103caf:	56                   	push   %esi
80103cb0:	e8 4b 1a 00 00       	call   80105700 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103cb5:	83 c4 10             	add    $0x10,%esp
80103cb8:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
80103cbe:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
80103cc4:	75 6a                	jne    80103d30 <piperead+0x90>
80103cc6:	8b 9e 40 02 00 00    	mov    0x240(%esi),%ebx
80103ccc:	85 db                	test   %ebx,%ebx
80103cce:	0f 84 c4 00 00 00    	je     80103d98 <piperead+0xf8>
    if(myproc()->killed){
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103cd4:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
80103cda:	eb 2d                	jmp    80103d09 <piperead+0x69>
80103cdc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103ce0:	83 ec 08             	sub    $0x8,%esp
80103ce3:	56                   	push   %esi
80103ce4:	53                   	push   %ebx
80103ce5:	e8 b6 0b 00 00       	call   801048a0 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103cea:	83 c4 10             	add    $0x10,%esp
80103ced:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
80103cf3:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
80103cf9:	75 35                	jne    80103d30 <piperead+0x90>
80103cfb:	8b 96 40 02 00 00    	mov    0x240(%esi),%edx
80103d01:	85 d2                	test   %edx,%edx
80103d03:	0f 84 8f 00 00 00    	je     80103d98 <piperead+0xf8>
    if(myproc()->killed){
80103d09:	e8 a2 05 00 00       	call   801042b0 <myproc>
80103d0e:	8b 48 24             	mov    0x24(%eax),%ecx
80103d11:	85 c9                	test   %ecx,%ecx
80103d13:	74 cb                	je     80103ce0 <piperead+0x40>
      release(&p->lock);
80103d15:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80103d18:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
80103d1d:	56                   	push   %esi
80103d1e:	e8 9d 1a 00 00       	call   801057c0 <release>
      return -1;
80103d23:	83 c4 10             	add    $0x10,%esp
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
80103d26:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103d29:	89 d8                	mov    %ebx,%eax
80103d2b:	5b                   	pop    %ebx
80103d2c:	5e                   	pop    %esi
80103d2d:	5f                   	pop    %edi
80103d2e:	5d                   	pop    %ebp
80103d2f:	c3                   	ret    
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103d30:	8b 45 10             	mov    0x10(%ebp),%eax
80103d33:	85 c0                	test   %eax,%eax
80103d35:	7e 61                	jle    80103d98 <piperead+0xf8>
    if(p->nread == p->nwrite)
80103d37:	31 db                	xor    %ebx,%ebx
80103d39:	eb 13                	jmp    80103d4e <piperead+0xae>
80103d3b:	90                   	nop
80103d3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103d40:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
80103d46:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
80103d4c:	74 1f                	je     80103d6d <piperead+0xcd>
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103d4e:	8d 41 01             	lea    0x1(%ecx),%eax
80103d51:	81 e1 ff 01 00 00    	and    $0x1ff,%ecx
80103d57:	89 86 34 02 00 00    	mov    %eax,0x234(%esi)
80103d5d:	0f b6 44 0e 34       	movzbl 0x34(%esi,%ecx,1),%eax
80103d62:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103d65:	83 c3 01             	add    $0x1,%ebx
80103d68:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80103d6b:	75 d3                	jne    80103d40 <piperead+0xa0>
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
80103d6d:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80103d73:	83 ec 0c             	sub    $0xc,%esp
80103d76:	50                   	push   %eax
80103d77:	e8 74 0f 00 00       	call   80104cf0 <wakeup>
  release(&p->lock);
80103d7c:	89 34 24             	mov    %esi,(%esp)
80103d7f:	e8 3c 1a 00 00       	call   801057c0 <release>
  return i;
80103d84:	83 c4 10             	add    $0x10,%esp
}
80103d87:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103d8a:	89 d8                	mov    %ebx,%eax
80103d8c:	5b                   	pop    %ebx
80103d8d:	5e                   	pop    %esi
80103d8e:	5f                   	pop    %edi
80103d8f:	5d                   	pop    %ebp
80103d90:	c3                   	ret    
80103d91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103d98:	31 db                	xor    %ebx,%ebx
80103d9a:	eb d1                	jmp    80103d6d <piperead+0xcd>
80103d9c:	66 90                	xchg   %ax,%ax
80103d9e:	66 90                	xchg   %ax,%ax

80103da0 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103da0:	55                   	push   %ebp
80103da1:	89 e5                	mov    %esp,%ebp
80103da3:	53                   	push   %ebx
  char *sp;


  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103da4:	bb 74 5f 11 80       	mov    $0x80115f74,%ebx
{
80103da9:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
80103dac:	68 40 5f 11 80       	push   $0x80115f40
80103db1:	e8 4a 19 00 00       	call   80105700 <acquire>
80103db6:	83 c4 10             	add    $0x10,%esp
80103db9:	eb 17                	jmp    80103dd2 <allocproc+0x32>
80103dbb:	90                   	nop
80103dbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103dc0:	81 c3 a0 01 00 00    	add    $0x1a0,%ebx
80103dc6:	81 fb 74 c7 11 80    	cmp    $0x8011c774,%ebx
80103dcc:	0f 83 ce 00 00 00    	jae    80103ea0 <allocproc+0x100>
    if(p->state == UNUSED)
80103dd2:	8b 4b 0c             	mov    0xc(%ebx),%ecx
80103dd5:	85 c9                	test   %ecx,%ecx
80103dd7:	75 e7                	jne    80103dc0 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
80103dd9:	a1 04 c0 10 80       	mov    0x8010c004,%eax
  p->stack_size = 0;
  p->cur = 0;
  p->base = p->sz;
  p->pgdir = 0;

  release(&ptable.lock);
80103dde:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
80103de1:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->tid = 1;
80103de8:	c7 83 8c 00 00 00 01 	movl   $0x1,0x8c(%ebx)
80103def:	00 00 00 
  p->parent = p;
80103df2:	89 5b 14             	mov    %ebx,0x14(%ebx)
  p->master = p;
80103df5:	89 9b 90 00 00 00    	mov    %ebx,0x90(%ebx)
  p->stack_size = 0;
80103dfb:	c7 83 9c 00 00 00 00 	movl   $0x0,0x9c(%ebx)
80103e02:	00 00 00 
  p->pid = nextpid++;
80103e05:	8d 50 01             	lea    0x1(%eax),%edx
80103e08:	89 43 10             	mov    %eax,0x10(%ebx)
  p->base = p->sz;
80103e0b:	8b 03                	mov    (%ebx),%eax
  p->cur = 0;
80103e0d:	c7 83 98 00 00 00 00 	movl   $0x0,0x98(%ebx)
80103e14:	00 00 00 
  p->pgdir = 0;
80103e17:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
  p->pid = nextpid++;
80103e1e:	89 15 04 c0 10 80    	mov    %edx,0x8010c004
  p->base = p->sz;
80103e24:	89 83 94 00 00 00    	mov    %eax,0x94(%ebx)
  release(&ptable.lock);
80103e2a:	68 40 5f 11 80       	push   $0x80115f40
80103e2f:	e8 8c 19 00 00       	call   801057c0 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80103e34:	e8 b7 ec ff ff       	call   80102af0 <kalloc>
80103e39:	83 c4 10             	add    $0x10,%esp
80103e3c:	85 c0                	test   %eax,%eax
80103e3e:	89 43 08             	mov    %eax,0x8(%ebx)
80103e41:	74 76                	je     80103eb9 <allocproc+0x119>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103e43:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
80103e49:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
80103e4c:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
80103e51:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
80103e54:	c7 40 14 6f 6c 10 80 	movl   $0x80106c6f,0x14(%eax)
  p->context = (struct context*)sp;
80103e5b:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80103e5e:	6a 14                	push   $0x14
80103e60:	6a 00                	push   $0x0
80103e62:	50                   	push   %eax
80103e63:	e8 a8 19 00 00       	call   80105810 <memset>
  p->context->eip = (uint)forkret;
80103e68:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103e6b:	c7 40 10 d0 3e 10 80 	movl   $0x80103ed0,0x10(%eax)

  push_mlfq(p->pid, 0);  // When process is allocated, it pushed into MLFQ
80103e72:	58                   	pop    %eax
80103e73:	5a                   	pop    %edx
80103e74:	6a 00                	push   $0x0
80103e76:	ff 73 10             	pushl  0x10(%ebx)
80103e79:	e8 a2 4a 00 00       	call   80108920 <push_mlfq>
  
  p->pstride = s_table;
80103e7e:	c7 83 80 00 00 00 20 	movl   $0x80114d20,0x80(%ebx)
80103e85:	4d 11 80 
  p->schedstate = MLFQ;
80103e88:	c7 43 7c 02 00 00 00 	movl   $0x2,0x7c(%ebx)
  return p;
80103e8f:	83 c4 10             	add    $0x10,%esp
}
80103e92:	89 d8                	mov    %ebx,%eax
80103e94:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103e97:	c9                   	leave  
80103e98:	c3                   	ret    
80103e99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  release(&ptable.lock);
80103ea0:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80103ea3:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
80103ea5:	68 40 5f 11 80       	push   $0x80115f40
80103eaa:	e8 11 19 00 00       	call   801057c0 <release>
}
80103eaf:	89 d8                	mov    %ebx,%eax
  return 0;
80103eb1:	83 c4 10             	add    $0x10,%esp
}
80103eb4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103eb7:	c9                   	leave  
80103eb8:	c3                   	ret    
    p->state = UNUSED;
80103eb9:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
80103ec0:	31 db                	xor    %ebx,%ebx
80103ec2:	eb ce                	jmp    80103e92 <allocproc+0xf2>
80103ec4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103eca:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103ed0 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80103ed0:	55                   	push   %ebp
80103ed1:	89 e5                	mov    %esp,%ebp
80103ed3:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80103ed6:	68 40 5f 11 80       	push   $0x80115f40
80103edb:	e8 e0 18 00 00       	call   801057c0 <release>

  if (first) {
80103ee0:	a1 00 c0 10 80       	mov    0x8010c000,%eax
80103ee5:	83 c4 10             	add    $0x10,%esp
80103ee8:	85 c0                	test   %eax,%eax
80103eea:	75 04                	jne    80103ef0 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
80103eec:	c9                   	leave  
80103eed:	c3                   	ret    
80103eee:	66 90                	xchg   %ax,%ax
    iinit(ROOTDEV);
80103ef0:	83 ec 0c             	sub    $0xc,%esp
    first = 0;
80103ef3:	c7 05 00 c0 10 80 00 	movl   $0x0,0x8010c000
80103efa:	00 00 00 
    iinit(ROOTDEV);
80103efd:	6a 01                	push   $0x1
80103eff:	e8 cc d9 ff ff       	call   801018d0 <iinit>
    initlog(ROOTDEV);
80103f04:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80103f0b:	e8 c0 f2 ff ff       	call   801031d0 <initlog>
80103f10:	83 c4 10             	add    $0x10,%esp
}
80103f13:	c9                   	leave  
80103f14:	c3                   	ret    
80103f15:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103f19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103f20 <exec_delete_thread>:
{
80103f20:	55                   	push   %ebp
80103f21:	89 e5                	mov    %esp,%ebp
80103f23:	53                   	push   %ebx
80103f24:	83 ec 10             	sub    $0x10,%esp
80103f27:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
80103f2a:	68 40 5f 11 80       	push   $0x80115f40
80103f2f:	e8 cc 17 00 00       	call   80105700 <acquire>
80103f34:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103f37:	b8 74 5f 11 80       	mov    $0x80115f74,%eax
80103f3c:	eb 0e                	jmp    80103f4c <exec_delete_thread+0x2c>
80103f3e:	66 90                	xchg   %ax,%ax
80103f40:	05 a0 01 00 00       	add    $0x1a0,%eax
80103f45:	3d 74 c7 11 80       	cmp    $0x8011c774,%eax
80103f4a:	73 32                	jae    80103f7e <exec_delete_thread+0x5e>
    if(cur->master == p->master&& p != cur)
80103f4c:	8b 88 90 00 00 00    	mov    0x90(%eax),%ecx
80103f52:	39 8b 90 00 00 00    	cmp    %ecx,0x90(%ebx)
80103f58:	75 e6                	jne    80103f40 <exec_delete_thread+0x20>
80103f5a:	39 c3                	cmp    %eax,%ebx
80103f5c:	74 e2                	je     80103f40 <exec_delete_thread+0x20>
      if(p->state == SLEEPING)
80103f5e:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
80103f62:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
80103f69:	75 d5                	jne    80103f40 <exec_delete_thread+0x20>
        p->state = RUNNABLE;
80103f6b:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103f72:	05 a0 01 00 00       	add    $0x1a0,%eax
80103f77:	3d 74 c7 11 80       	cmp    $0x8011c774,%eax
80103f7c:	72 ce                	jb     80103f4c <exec_delete_thread+0x2c>
  cur->pid = nextpid++;
80103f7e:	a1 04 c0 10 80       	mov    0x8010c004,%eax
  push_mlfq(cur->pid, 0);
80103f83:	83 ec 08             	sub    $0x8,%esp
  cur->schedstate = UNUSED;
80103f86:	c7 43 7c 00 00 00 00 	movl   $0x0,0x7c(%ebx)
  cur->pmlfq_node = 0;
80103f8d:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
80103f94:	00 00 00 
  cur->pstride = 0;
80103f97:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
80103f9e:	00 00 00 
  cur->tid = 1;
80103fa1:	c7 83 8c 00 00 00 01 	movl   $0x1,0x8c(%ebx)
80103fa8:	00 00 00 
  cur->master = cur;
80103fab:	89 9b 90 00 00 00    	mov    %ebx,0x90(%ebx)
  cur->pid = nextpid++;
80103fb1:	8d 50 01             	lea    0x1(%eax),%edx
80103fb4:	89 43 10             	mov    %eax,0x10(%ebx)
80103fb7:	89 15 04 c0 10 80    	mov    %edx,0x8010c004
  cur->parent = initproc;
80103fbd:	8b 15 b8 c5 10 80    	mov    0x8010c5b8,%edx
80103fc3:	89 53 14             	mov    %edx,0x14(%ebx)
  push_mlfq(cur->pid, 0);
80103fc6:	6a 00                	push   $0x0
80103fc8:	50                   	push   %eax
80103fc9:	e8 52 49 00 00       	call   80108920 <push_mlfq>
  release(&ptable.lock);
80103fce:	83 c4 10             	add    $0x10,%esp
80103fd1:	c7 45 08 40 5f 11 80 	movl   $0x80115f40,0x8(%ebp)
}
80103fd8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103fdb:	c9                   	leave  
  release(&ptable.lock);
80103fdc:	e9 df 17 00 00       	jmp    801057c0 <release>
80103fe1:	eb 0d                	jmp    80103ff0 <delete_thread>
80103fe3:	90                   	nop
80103fe4:	90                   	nop
80103fe5:	90                   	nop
80103fe6:	90                   	nop
80103fe7:	90                   	nop
80103fe8:	90                   	nop
80103fe9:	90                   	nop
80103fea:	90                   	nop
80103feb:	90                   	nop
80103fec:	90                   	nop
80103fed:	90                   	nop
80103fee:	90                   	nop
80103fef:	90                   	nop

80103ff0 <delete_thread>:
{
80103ff0:	55                   	push   %ebp
80103ff1:	89 e5                	mov    %esp,%ebp
80103ff3:	57                   	push   %edi
80103ff4:	56                   	push   %esi
80103ff5:	53                   	push   %ebx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; ++p)
80103ff6:	bb 74 5f 11 80       	mov    $0x80115f74,%ebx
{
80103ffb:	83 ec 0c             	sub    $0xc,%esp
80103ffe:	8b 75 08             	mov    0x8(%ebp),%esi
  struct proc* master_thread = find_master(p->pid);
80104001:	8b 46 10             	mov    0x10(%esi),%eax
80104004:	eb 1c                	jmp    80104022 <delete_thread+0x32>
80104006:	8d 76 00             	lea    0x0(%esi),%esi
80104009:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; ++p)
80104010:	81 c3 a0 01 00 00    	add    $0x1a0,%ebx
80104016:	81 fb 74 c7 11 80    	cmp    $0x8011c774,%ebx
8010401c:	0f 83 ae 00 00 00    	jae    801040d0 <delete_thread+0xe0>
    if(p->pid == pid && p->tid == 1)
80104022:	3b 43 10             	cmp    0x10(%ebx),%eax
80104025:	75 e9                	jne    80104010 <delete_thread+0x20>
80104027:	83 bb 8c 00 00 00 01 	cmpl   $0x1,0x8c(%ebx)
8010402e:	75 e0                	jne    80104010 <delete_thread+0x20>
  if(p->tid == 1)
80104030:	83 be 8c 00 00 00 01 	cmpl   $0x1,0x8c(%esi)
80104037:	0f 84 a2 00 00 00    	je     801040df <delete_thread+0xef>
  kfree(p->kstack);
8010403d:	83 ec 0c             	sub    $0xc,%esp
80104040:	ff 76 08             	pushl  0x8(%esi)
80104043:	e8 f8 e8 ff ff       	call   80102940 <kfree>
  p->kstack = 0;
80104048:	c7 46 08 00 00 00 00 	movl   $0x0,0x8(%esi)
  p->master = 0;
8010404f:	c7 86 90 00 00 00 00 	movl   $0x0,0x90(%esi)
80104056:	00 00 00 
  deallocuvm(p->pgdir, p->sz, p->base);
80104059:	83 c4 0c             	add    $0xc,%esp
  p->pid = 0;
8010405c:	c7 46 10 00 00 00 00 	movl   $0x0,0x10(%esi)
  p->tid = 0;
80104063:	c7 86 8c 00 00 00 00 	movl   $0x0,0x8c(%esi)
8010406a:	00 00 00 
  p->parent = 0;
8010406d:	c7 46 14 00 00 00 00 	movl   $0x0,0x14(%esi)
  p->name[0] = 0;
80104074:	c6 46 6c 00          	movb   $0x0,0x6c(%esi)
  p->killed = 0;
80104078:	c7 46 24 00 00 00 00 	movl   $0x0,0x24(%esi)
  p->state = UNUSED;
8010407f:	c7 46 0c 00 00 00 00 	movl   $0x0,0xc(%esi)
  master_thread->stack[master_thread->stack_size++] = p->base;
80104086:	8b 83 9c 00 00 00    	mov    0x9c(%ebx),%eax
8010408c:	8b 96 94 00 00 00    	mov    0x94(%esi),%edx
80104092:	8d 48 01             	lea    0x1(%eax),%ecx
80104095:	89 8b 9c 00 00 00    	mov    %ecx,0x9c(%ebx)
8010409b:	89 94 83 a0 00 00 00 	mov    %edx,0xa0(%ebx,%eax,4)
  deallocuvm(p->pgdir, p->sz, p->base);
801040a2:	ff b6 94 00 00 00    	pushl  0x94(%esi)
801040a8:	ff 36                	pushl  (%esi)
801040aa:	ff 76 04             	pushl  0x4(%esi)
801040ad:	e8 3e 42 00 00       	call   801082f0 <deallocuvm>
  p->sz = 0;
801040b2:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  p->base = 0;
801040b8:	c7 86 94 00 00 00 00 	movl   $0x0,0x94(%esi)
801040bf:	00 00 00 
}
801040c2:	83 c4 10             	add    $0x10,%esp
801040c5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801040c8:	5b                   	pop    %ebx
801040c9:	5e                   	pop    %esi
801040ca:	5f                   	pop    %edi
801040cb:	5d                   	pop    %ebp
801040cc:	c3                   	ret    
801040cd:	8d 76 00             	lea    0x0(%esi),%esi
  return 0;
801040d0:	31 db                	xor    %ebx,%ebx
  if(p->tid == 1)
801040d2:	83 be 8c 00 00 00 01 	cmpl   $0x1,0x8c(%esi)
801040d9:	0f 85 5e ff ff ff    	jne    8010403d <delete_thread+0x4d>
    if(p->schedstate == MLFQ)
801040df:	8b 46 7c             	mov    0x7c(%esi),%eax
    p->stack_size = 0;
801040e2:	c7 86 9c 00 00 00 00 	movl   $0x0,0x9c(%esi)
801040e9:	00 00 00 
    if(p->schedstate == MLFQ)
801040ec:	83 f8 02             	cmp    $0x2,%eax
801040ef:	0f 84 9d 00 00 00    	je     80104192 <delete_thread+0x1a2>
    else if(p->schedstate == STRIDE)
801040f5:	83 f8 03             	cmp    $0x3,%eax
801040f8:	74 38                	je     80104132 <delete_thread+0x142>
    freevm(p->pgdir);
801040fa:	83 ec 0c             	sub    $0xc,%esp
    p->schedstate = MLFQ;
801040fd:	c7 46 7c 02 00 00 00 	movl   $0x2,0x7c(%esi)
    p->pstride = 0;
80104104:	c7 86 80 00 00 00 00 	movl   $0x0,0x80(%esi)
8010410b:	00 00 00 
    p->pmlfq_node = 0;
8010410e:	c7 86 84 00 00 00 00 	movl   $0x0,0x84(%esi)
80104115:	00 00 00 
    p->stack_size = 0;
80104118:	c7 86 9c 00 00 00 00 	movl   $0x0,0x9c(%esi)
8010411f:	00 00 00 
    freevm(p->pgdir);
80104122:	ff 76 04             	pushl  0x4(%esi)
80104125:	e8 f6 41 00 00       	call   80108320 <freevm>
8010412a:	83 c4 10             	add    $0x10,%esp
8010412d:	e9 0b ff ff ff       	jmp    8010403d <delete_thread+0x4d>
      s_table->tickets += p->pstride->tickets;
80104132:	8b be 80 00 00 00    	mov    0x80(%esi),%edi
      s_table->stride = stride1/(s_table->tickets);
80104138:	a1 08 c0 10 80       	mov    0x8010c008,%eax
      s_table->tickets += p->pstride->tickets;
8010413d:	8b 0f                	mov    (%edi),%ecx
8010413f:	03 0d 20 4d 11 80    	add    0x80114d20,%ecx
      s_table->stride = stride1/(s_table->tickets);
80104145:	99                   	cltd   
      p->pstride->state = EMPTY;
80104146:	c7 47 14 01 00 00 00 	movl   $0x1,0x14(%edi)
      s_table->stride = stride1/(s_table->tickets);
8010414d:	f7 f9                	idiv   %ecx
      s_table->tickets += p->pstride->tickets;
8010414f:	89 0d 20 4d 11 80    	mov    %ecx,0x80114d20
      s_table->stride = stride1/(s_table->tickets);
80104155:	a3 24 4d 11 80       	mov    %eax,0x80114d24
      p->pstride->tickets = 0;
8010415a:	8b 86 80 00 00 00    	mov    0x80(%esi),%eax
80104160:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
      p->pstride->pass = 0;
80104166:	8b 86 80 00 00 00    	mov    0x80(%esi),%eax
8010416c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
      p->pstride->stride = 0;
80104173:	8b 86 80 00 00 00    	mov    0x80(%esi),%eax
80104179:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
      p->pstride->pid = 0;
80104180:	8b 86 80 00 00 00    	mov    0x80(%esi),%eax
80104186:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
8010418d:	e9 68 ff ff ff       	jmp    801040fa <delete_thread+0x10a>
      p->pmlfq_node->state = EMPTY;
80104192:	8b 86 84 00 00 00    	mov    0x84(%esi),%eax
80104198:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
      p->pmlfq_node->pid = 0;
8010419e:	8b 86 84 00 00 00    	mov    0x84(%esi),%eax
801041a4:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
801041ab:	e9 4a ff ff ff       	jmp    801040fa <delete_thread+0x10a>

801041b0 <find_master>:
{
801041b0:	55                   	push   %ebp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; ++p)
801041b1:	b8 74 5f 11 80       	mov    $0x80115f74,%eax
{
801041b6:	89 e5                	mov    %esp,%ebp
801041b8:	8b 55 08             	mov    0x8(%ebp),%edx
801041bb:	eb 0f                	jmp    801041cc <find_master+0x1c>
801041bd:	8d 76 00             	lea    0x0(%esi),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; ++p)
801041c0:	05 a0 01 00 00       	add    $0x1a0,%eax
801041c5:	3d 74 c7 11 80       	cmp    $0x8011c774,%eax
801041ca:	73 14                	jae    801041e0 <find_master+0x30>
    if(p->pid == pid && p->tid == 1)
801041cc:	39 50 10             	cmp    %edx,0x10(%eax)
801041cf:	75 ef                	jne    801041c0 <find_master+0x10>
801041d1:	83 b8 8c 00 00 00 01 	cmpl   $0x1,0x8c(%eax)
801041d8:	75 e6                	jne    801041c0 <find_master+0x10>
}
801041da:	5d                   	pop    %ebp
801041db:	c3                   	ret    
801041dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return 0;
801041e0:	31 c0                	xor    %eax,%eax
}
801041e2:	5d                   	pop    %ebp
801041e3:	c3                   	ret    
801041e4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801041ea:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801041f0 <pinit>:
{
801041f0:	55                   	push   %ebp
801041f1:	89 e5                	mov    %esp,%ebp
801041f3:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
801041f6:	68 15 95 10 80       	push   $0x80109515
801041fb:	68 40 5f 11 80       	push   $0x80115f40
80104200:	e8 bb 13 00 00       	call   801055c0 <initlock>
}
80104205:	83 c4 10             	add    $0x10,%esp
80104208:	c9                   	leave  
80104209:	c3                   	ret    
8010420a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104210 <mycpu>:
{
80104210:	55                   	push   %ebp
80104211:	89 e5                	mov    %esp,%ebp
80104213:	56                   	push   %esi
80104214:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104215:	9c                   	pushf  
80104216:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104217:	f6 c4 02             	test   $0x2,%ah
8010421a:	75 5e                	jne    8010427a <mycpu+0x6a>
  apicid = lapicid();
8010421c:	e8 3f eb ff ff       	call   80102d60 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80104221:	8b 35 00 4d 11 80    	mov    0x80114d00,%esi
80104227:	85 f6                	test   %esi,%esi
80104229:	7e 42                	jle    8010426d <mycpu+0x5d>
    if (cpus[i].apicid == apicid)
8010422b:	0f b6 15 80 47 11 80 	movzbl 0x80114780,%edx
80104232:	39 d0                	cmp    %edx,%eax
80104234:	74 30                	je     80104266 <mycpu+0x56>
80104236:	b9 30 48 11 80       	mov    $0x80114830,%ecx
  for (i = 0; i < ncpu; ++i) {
8010423b:	31 d2                	xor    %edx,%edx
8010423d:	8d 76 00             	lea    0x0(%esi),%esi
80104240:	83 c2 01             	add    $0x1,%edx
80104243:	39 f2                	cmp    %esi,%edx
80104245:	74 26                	je     8010426d <mycpu+0x5d>
    if (cpus[i].apicid == apicid)
80104247:	0f b6 19             	movzbl (%ecx),%ebx
8010424a:	81 c1 b0 00 00 00    	add    $0xb0,%ecx
80104250:	39 c3                	cmp    %eax,%ebx
80104252:	75 ec                	jne    80104240 <mycpu+0x30>
80104254:	69 c2 b0 00 00 00    	imul   $0xb0,%edx,%eax
8010425a:	05 80 47 11 80       	add    $0x80114780,%eax
}
8010425f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104262:	5b                   	pop    %ebx
80104263:	5e                   	pop    %esi
80104264:	5d                   	pop    %ebp
80104265:	c3                   	ret    
    if (cpus[i].apicid == apicid)
80104266:	b8 80 47 11 80       	mov    $0x80114780,%eax
      return &cpus[i];
8010426b:	eb f2                	jmp    8010425f <mycpu+0x4f>
  panic("unknown apicid\n");
8010426d:	83 ec 0c             	sub    $0xc,%esp
80104270:	68 1c 95 10 80       	push   $0x8010951c
80104275:	e8 16 c1 ff ff       	call   80100390 <panic>
    panic("mycpu called with interrupts enabled\n");
8010427a:	83 ec 0c             	sub    $0xc,%esp
8010427d:	68 90 96 10 80       	push   $0x80109690
80104282:	e8 09 c1 ff ff       	call   80100390 <panic>
80104287:	89 f6                	mov    %esi,%esi
80104289:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104290 <cpuid>:
cpuid() {
80104290:	55                   	push   %ebp
80104291:	89 e5                	mov    %esp,%ebp
80104293:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80104296:	e8 75 ff ff ff       	call   80104210 <mycpu>
8010429b:	2d 80 47 11 80       	sub    $0x80114780,%eax
}
801042a0:	c9                   	leave  
  return mycpu()-cpus;
801042a1:	c1 f8 04             	sar    $0x4,%eax
801042a4:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
801042aa:	c3                   	ret    
801042ab:	90                   	nop
801042ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801042b0 <myproc>:
myproc(void) {
801042b0:	55                   	push   %ebp
801042b1:	89 e5                	mov    %esp,%ebp
801042b3:	53                   	push   %ebx
801042b4:	83 ec 04             	sub    $0x4,%esp
  pushcli();
801042b7:	e8 74 13 00 00       	call   80105630 <pushcli>
  c = mycpu();
801042bc:	e8 4f ff ff ff       	call   80104210 <mycpu>
  p = c->proc;
801042c1:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801042c7:	e8 a4 13 00 00       	call   80105670 <popcli>
}
801042cc:	83 c4 04             	add    $0x4,%esp
801042cf:	89 d8                	mov    %ebx,%eax
801042d1:	5b                   	pop    %ebx
801042d2:	5d                   	pop    %ebp
801042d3:	c3                   	ret    
801042d4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801042da:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801042e0 <userinit>:
{
801042e0:	55                   	push   %ebp
  for(s = s_table; s < &s_table[NPROC]; s++){
801042e1:	b8 20 4d 11 80       	mov    $0x80114d20,%eax
{
801042e6:	89 e5                	mov    %esp,%ebp
801042e8:	53                   	push   %ebx
801042e9:	83 ec 04             	sub    $0x4,%esp
801042ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    s->isMLFQ = 0;
801042f0:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
    s->state = EMPTY;
801042f7:	c7 40 14 01 00 00 00 	movl   $0x1,0x14(%eax)
  for(s = s_table; s < &s_table[NPROC]; s++){
801042fe:	83 c0 18             	add    $0x18,%eax
    s->pass = 0;
80104301:	c7 40 f0 00 00 00 00 	movl   $0x0,-0x10(%eax)
    s->stride = 0;
80104308:	c7 40 ec 00 00 00 00 	movl   $0x0,-0x14(%eax)
    s->pid = 0;
8010430f:	c7 40 f4 00 00 00 00 	movl   $0x0,-0xc(%eax)
  for(s = s_table; s < &s_table[NPROC]; s++){
80104316:	3d 20 53 11 80       	cmp    $0x80115320,%eax
8010431b:	75 d3                	jne    801042f0 <userinit+0x10>
8010431d:	bb 20 53 11 80       	mov    $0x80115320,%ebx
  for(int prior = 0; prior < 3; ++prior){
80104322:	31 d2                	xor    %edx,%edx
80104324:	8d 8b 00 04 00 00    	lea    0x400(%ebx),%ecx
    m_table[prior].count = 0;
8010432a:	c7 83 00 04 00 00 00 	movl   $0x0,0x400(%ebx)
80104331:	00 00 00 
    m_table[prior].recent_index = 0;
80104334:	c7 83 04 04 00 00 00 	movl   $0x0,0x404(%ebx)
8010433b:	00 00 00 
8010433e:	89 d8                	mov    %ebx,%eax
      m_table[prior].table[i].eticks = 0;
80104340:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
      m_table[prior].table[i].prior = prior;
80104347:	89 50 0c             	mov    %edx,0xc(%eax)
8010434a:	83 c0 10             	add    $0x10,%eax
      m_table[prior].table[i].state = EMPTY;
8010434d:	c7 40 f0 01 00 00 00 	movl   $0x1,-0x10(%eax)
      m_table[prior].table[i].pid = 0;
80104354:	c7 40 f8 00 00 00 00 	movl   $0x0,-0x8(%eax)
    for(int i = 0; i < NPROC; ++i){
8010435b:	39 c8                	cmp    %ecx,%eax
8010435d:	75 e1                	jne    80104340 <userinit+0x60>
  for(int prior = 0; prior < 3; ++prior){
8010435f:	83 c2 01             	add    $0x1,%edx
80104362:	81 c3 08 04 00 00    	add    $0x408,%ebx
80104368:	83 fa 03             	cmp    $0x3,%edx
8010436b:	75 b7                	jne    80104324 <userinit+0x44>
  p = allocproc();
8010436d:	e8 2e fa ff ff       	call   80103da0 <allocproc>
  s_table[0].stride = stride1/(s_table[0].tickets);
80104372:	8b 0d 08 c0 10 80    	mov    0x8010c008,%ecx
  p = allocproc();
80104378:	89 c3                	mov    %eax,%ebx
  s_table[0].stride = stride1/(s_table[0].tickets);
8010437a:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
  s_table[0].isMLFQ = 1;
8010437f:	c7 05 30 4d 11 80 01 	movl   $0x1,0x80114d30
80104386:	00 00 00 
  s_table[0].state = USED;
80104389:	c7 05 34 4d 11 80 00 	movl   $0x0,0x80114d34
80104390:	00 00 00 
  s_table[0].tickets = 100;
80104393:	c7 05 20 4d 11 80 64 	movl   $0x64,0x80114d20
8010439a:	00 00 00 
  initproc = p;
8010439d:	89 1d b8 c5 10 80    	mov    %ebx,0x8010c5b8
  s_table[0].stride = stride1/(s_table[0].tickets);
801043a3:	89 c8                	mov    %ecx,%eax
801043a5:	c1 f9 1f             	sar    $0x1f,%ecx
801043a8:	f7 ea                	imul   %edx
801043aa:	c1 fa 05             	sar    $0x5,%edx
801043ad:	29 ca                	sub    %ecx,%edx
801043af:	89 15 24 4d 11 80    	mov    %edx,0x80114d24
  if((p->pgdir = setupkvm()) == 0)
801043b5:	e8 e6 3f 00 00       	call   801083a0 <setupkvm>
801043ba:	85 c0                	test   %eax,%eax
801043bc:	89 43 04             	mov    %eax,0x4(%ebx)
801043bf:	0f 84 bd 00 00 00    	je     80104482 <userinit+0x1a2>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
801043c5:	83 ec 04             	sub    $0x4,%esp
801043c8:	68 2c 00 00 00       	push   $0x2c
801043cd:	68 60 c4 10 80       	push   $0x8010c460
801043d2:	50                   	push   %eax
801043d3:	e8 a8 3c 00 00       	call   80108080 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
801043d8:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
801043db:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
801043e1:	6a 4c                	push   $0x4c
801043e3:	6a 00                	push   $0x0
801043e5:	ff 73 18             	pushl  0x18(%ebx)
801043e8:	e8 23 14 00 00       	call   80105810 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
801043ed:	8b 43 18             	mov    0x18(%ebx),%eax
801043f0:	ba 1b 00 00 00       	mov    $0x1b,%edx
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
801043f5:	b9 23 00 00 00       	mov    $0x23,%ecx
  safestrcpy(p->name, "initcode", sizeof(p->name));
801043fa:	83 c4 0c             	add    $0xc,%esp
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
801043fd:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80104401:	8b 43 18             	mov    0x18(%ebx),%eax
80104404:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80104408:	8b 43 18             	mov    0x18(%ebx),%eax
8010440b:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
8010440f:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80104413:	8b 43 18             	mov    0x18(%ebx),%eax
80104416:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
8010441a:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
8010441e:	8b 43 18             	mov    0x18(%ebx),%eax
80104421:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80104428:	8b 43 18             	mov    0x18(%ebx),%eax
8010442b:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80104432:	8b 43 18             	mov    0x18(%ebx),%eax
80104435:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
8010443c:	8d 43 6c             	lea    0x6c(%ebx),%eax
8010443f:	6a 10                	push   $0x10
80104441:	68 45 95 10 80       	push   $0x80109545
80104446:	50                   	push   %eax
80104447:	e8 a4 15 00 00       	call   801059f0 <safestrcpy>
  p->cwd = namei("/");
8010444c:	c7 04 24 4e 95 10 80 	movl   $0x8010954e,(%esp)
80104453:	e8 b8 e0 ff ff       	call   80102510 <namei>
80104458:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
8010445b:	c7 04 24 40 5f 11 80 	movl   $0x80115f40,(%esp)
80104462:	e8 99 12 00 00       	call   80105700 <acquire>
  p->state = RUNNABLE;
80104467:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
8010446e:	c7 04 24 40 5f 11 80 	movl   $0x80115f40,(%esp)
80104475:	e8 46 13 00 00       	call   801057c0 <release>
}
8010447a:	83 c4 10             	add    $0x10,%esp
8010447d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104480:	c9                   	leave  
80104481:	c3                   	ret    
    panic("userinit: out of memory?");
80104482:	83 ec 0c             	sub    $0xc,%esp
80104485:	68 2c 95 10 80       	push   $0x8010952c
8010448a:	e8 01 bf ff ff       	call   80100390 <panic>
8010448f:	90                   	nop

80104490 <growproc>:
{
80104490:	55                   	push   %ebp
80104491:	89 e5                	mov    %esp,%ebp
80104493:	57                   	push   %edi
80104494:	56                   	push   %esi
80104495:	53                   	push   %ebx
80104496:	83 ec 0c             	sub    $0xc,%esp
80104499:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
8010449c:	e8 8f 11 00 00       	call   80105630 <pushcli>
  c = mycpu();
801044a1:	e8 6a fd ff ff       	call   80104210 <mycpu>
  p = c->proc;
801044a6:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
801044ac:	e8 bf 11 00 00       	call   80105670 <popcli>
  if(n > 0){
801044b1:	83 fb 00             	cmp    $0x0,%ebx
  struct proc *master_thread = curproc->master;
801044b4:	8b be 90 00 00 00    	mov    0x90(%esi),%edi
  sz = master_thread->sz;
801044ba:	8b 07                	mov    (%edi),%eax
  if(n > 0){
801044bc:	7f 22                	jg     801044e0 <growproc+0x50>
  } else if(n < 0){
801044be:	75 40                	jne    80104500 <growproc+0x70>
  switchuvm(curproc);
801044c0:	83 ec 0c             	sub    $0xc,%esp
  master_thread->sz = sz;
801044c3:	89 07                	mov    %eax,(%edi)
  switchuvm(curproc);
801044c5:	56                   	push   %esi
801044c6:	e8 a5 39 00 00       	call   80107e70 <switchuvm>
  return 0;
801044cb:	83 c4 10             	add    $0x10,%esp
801044ce:	31 c0                	xor    %eax,%eax
}
801044d0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801044d3:	5b                   	pop    %ebx
801044d4:	5e                   	pop    %esi
801044d5:	5f                   	pop    %edi
801044d6:	5d                   	pop    %ebp
801044d7:	c3                   	ret    
801044d8:	90                   	nop
801044d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if((sz = allocuvm(master_thread->pgdir, sz, sz + n)) == 0)
801044e0:	83 ec 04             	sub    $0x4,%esp
801044e3:	01 c3                	add    %eax,%ebx
801044e5:	53                   	push   %ebx
801044e6:	50                   	push   %eax
801044e7:	ff 77 04             	pushl  0x4(%edi)
801044ea:	e8 d1 3c 00 00       	call   801081c0 <allocuvm>
801044ef:	83 c4 10             	add    $0x10,%esp
801044f2:	85 c0                	test   %eax,%eax
801044f4:	75 ca                	jne    801044c0 <growproc+0x30>
      return -1;
801044f6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801044fb:	eb d3                	jmp    801044d0 <growproc+0x40>
801044fd:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(master_thread->pgdir, sz, sz + n)) == 0)
80104500:	83 ec 04             	sub    $0x4,%esp
80104503:	01 c3                	add    %eax,%ebx
80104505:	53                   	push   %ebx
80104506:	50                   	push   %eax
80104507:	ff 77 04             	pushl  0x4(%edi)
8010450a:	e8 e1 3d 00 00       	call   801082f0 <deallocuvm>
8010450f:	83 c4 10             	add    $0x10,%esp
80104512:	85 c0                	test   %eax,%eax
80104514:	75 aa                	jne    801044c0 <growproc+0x30>
80104516:	eb de                	jmp    801044f6 <growproc+0x66>
80104518:	90                   	nop
80104519:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104520 <fork>:
{
80104520:	55                   	push   %ebp
80104521:	89 e5                	mov    %esp,%ebp
80104523:	57                   	push   %edi
80104524:	56                   	push   %esi
80104525:	53                   	push   %ebx
80104526:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80104529:	e8 02 11 00 00       	call   80105630 <pushcli>
  c = mycpu();
8010452e:	e8 dd fc ff ff       	call   80104210 <mycpu>
  p = c->proc;
80104533:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104539:	e8 32 11 00 00       	call   80105670 <popcli>
  struct proc *master_thread = curproc->master;
8010453e:	8b b3 90 00 00 00    	mov    0x90(%ebx),%esi
  if((np = allocproc()) == 0){
80104544:	e8 57 f8 ff ff       	call   80103da0 <allocproc>
80104549:	85 c0                	test   %eax,%eax
8010454b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010454e:	0f 84 c1 00 00 00    	je     80104615 <fork+0xf5>
  if((np->pgdir = copyuvm(master_thread->pgdir, master_thread->sz)) == 0){
80104554:	83 ec 08             	sub    $0x8,%esp
80104557:	ff 36                	pushl  (%esi)
80104559:	ff 76 04             	pushl  0x4(%esi)
8010455c:	89 c7                	mov    %eax,%edi
8010455e:	e8 0d 3f 00 00       	call   80108470 <copyuvm>
80104563:	83 c4 10             	add    $0x10,%esp
80104566:	85 c0                	test   %eax,%eax
80104568:	89 47 04             	mov    %eax,0x4(%edi)
8010456b:	0f 84 ab 00 00 00    	je     8010461c <fork+0xfc>
  np->sz = curproc->sz;
80104571:	8b 03                	mov    (%ebx),%eax
80104573:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80104576:	89 01                	mov    %eax,(%ecx)
  np->parent = curproc;
80104578:	89 59 14             	mov    %ebx,0x14(%ecx)
8010457b:	89 c8                	mov    %ecx,%eax
  *np->tf = *curproc->tf;
8010457d:	8b 79 18             	mov    0x18(%ecx),%edi
80104580:	8b 73 18             	mov    0x18(%ebx),%esi
80104583:	b9 13 00 00 00       	mov    $0x13,%ecx
80104588:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
8010458a:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
8010458c:	8b 40 18             	mov    0x18(%eax),%eax
8010458f:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
80104596:	8d 76 00             	lea    0x0(%esi),%esi
80104599:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(curproc->ofile[i])
801045a0:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
801045a4:	85 c0                	test   %eax,%eax
801045a6:	74 13                	je     801045bb <fork+0x9b>
      np->ofile[i] = filedup(curproc->ofile[i]);
801045a8:	83 ec 0c             	sub    $0xc,%esp
801045ab:	50                   	push   %eax
801045ac:	e8 ef c8 ff ff       	call   80100ea0 <filedup>
801045b1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801045b4:	83 c4 10             	add    $0x10,%esp
801045b7:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
801045bb:	83 c6 01             	add    $0x1,%esi
801045be:	83 fe 10             	cmp    $0x10,%esi
801045c1:	75 dd                	jne    801045a0 <fork+0x80>
  np->cwd = idup(curproc->cwd);
801045c3:	83 ec 0c             	sub    $0xc,%esp
801045c6:	ff 73 68             	pushl  0x68(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
801045c9:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
801045cc:	e8 cf d4 ff ff       	call   80101aa0 <idup>
801045d1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
801045d4:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
801045d7:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
801045da:	8d 47 6c             	lea    0x6c(%edi),%eax
801045dd:	6a 10                	push   $0x10
801045df:	53                   	push   %ebx
801045e0:	50                   	push   %eax
801045e1:	e8 0a 14 00 00       	call   801059f0 <safestrcpy>
  pid = np->pid;
801045e6:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
801045e9:	c7 04 24 40 5f 11 80 	movl   $0x80115f40,(%esp)
801045f0:	e8 0b 11 00 00       	call   80105700 <acquire>
  np->state = RUNNABLE;
801045f5:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
801045fc:	c7 04 24 40 5f 11 80 	movl   $0x80115f40,(%esp)
80104603:	e8 b8 11 00 00       	call   801057c0 <release>
  return pid;
80104608:	83 c4 10             	add    $0x10,%esp
}
8010460b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010460e:	89 d8                	mov    %ebx,%eax
80104610:	5b                   	pop    %ebx
80104611:	5e                   	pop    %esi
80104612:	5f                   	pop    %edi
80104613:	5d                   	pop    %ebp
80104614:	c3                   	ret    
    return -1;
80104615:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
8010461a:	eb ef                	jmp    8010460b <fork+0xeb>
    kfree(np->kstack);
8010461c:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
8010461f:	83 ec 0c             	sub    $0xc,%esp
80104622:	ff 73 08             	pushl  0x8(%ebx)
80104625:	e8 16 e3 ff ff       	call   80102940 <kfree>
    np->kstack = 0;
8010462a:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    np->state = UNUSED;
80104631:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80104638:	83 c4 10             	add    $0x10,%esp
8010463b:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80104640:	eb c9                	jmp    8010460b <fork+0xeb>
80104642:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104649:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104650 <sched>:
{
80104650:	55                   	push   %ebp
80104651:	89 e5                	mov    %esp,%ebp
80104653:	56                   	push   %esi
80104654:	53                   	push   %ebx
  pushcli();
80104655:	e8 d6 0f 00 00       	call   80105630 <pushcli>
  c = mycpu();
8010465a:	e8 b1 fb ff ff       	call   80104210 <mycpu>
  p = c->proc;
8010465f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104665:	e8 06 10 00 00       	call   80105670 <popcli>
  if(!holding(&ptable.lock))
8010466a:	83 ec 0c             	sub    $0xc,%esp
8010466d:	68 40 5f 11 80       	push   $0x80115f40
80104672:	e8 59 10 00 00       	call   801056d0 <holding>
80104677:	83 c4 10             	add    $0x10,%esp
8010467a:	85 c0                	test   %eax,%eax
8010467c:	74 4f                	je     801046cd <sched+0x7d>
  if(mycpu()->ncli != 1)
8010467e:	e8 8d fb ff ff       	call   80104210 <mycpu>
80104683:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
8010468a:	75 68                	jne    801046f4 <sched+0xa4>
  if(p->state == RUNNING)
8010468c:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80104690:	74 55                	je     801046e7 <sched+0x97>
80104692:	9c                   	pushf  
80104693:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104694:	f6 c4 02             	test   $0x2,%ah
80104697:	75 41                	jne    801046da <sched+0x8a>
  intena = mycpu()->intena;
80104699:	e8 72 fb ff ff       	call   80104210 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
8010469e:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
801046a1:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
801046a7:	e8 64 fb ff ff       	call   80104210 <mycpu>
801046ac:	83 ec 08             	sub    $0x8,%esp
801046af:	ff 70 04             	pushl  0x4(%eax)
801046b2:	53                   	push   %ebx
801046b3:	e8 93 13 00 00       	call   80105a4b <swtch>
  mycpu()->intena = intena;
801046b8:	e8 53 fb ff ff       	call   80104210 <mycpu>
}
801046bd:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
801046c0:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
801046c6:	8d 65 f8             	lea    -0x8(%ebp),%esp
801046c9:	5b                   	pop    %ebx
801046ca:	5e                   	pop    %esi
801046cb:	5d                   	pop    %ebp
801046cc:	c3                   	ret    
    panic("sched ptable.lock");
801046cd:	83 ec 0c             	sub    $0xc,%esp
801046d0:	68 50 95 10 80       	push   $0x80109550
801046d5:	e8 b6 bc ff ff       	call   80100390 <panic>
    panic("sched interruptible");
801046da:	83 ec 0c             	sub    $0xc,%esp
801046dd:	68 7c 95 10 80       	push   $0x8010957c
801046e2:	e8 a9 bc ff ff       	call   80100390 <panic>
    panic("sched running");
801046e7:	83 ec 0c             	sub    $0xc,%esp
801046ea:	68 6e 95 10 80       	push   $0x8010956e
801046ef:	e8 9c bc ff ff       	call   80100390 <panic>
    panic("sched locks");
801046f4:	83 ec 0c             	sub    $0xc,%esp
801046f7:	68 62 95 10 80       	push   $0x80109562
801046fc:	e8 8f bc ff ff       	call   80100390 <panic>
80104701:	eb 0d                	jmp    80104710 <sched_thread>
80104703:	90                   	nop
80104704:	90                   	nop
80104705:	90                   	nop
80104706:	90                   	nop
80104707:	90                   	nop
80104708:	90                   	nop
80104709:	90                   	nop
8010470a:	90                   	nop
8010470b:	90                   	nop
8010470c:	90                   	nop
8010470d:	90                   	nop
8010470e:	90                   	nop
8010470f:	90                   	nop

80104710 <sched_thread>:
{
80104710:	55                   	push   %ebp
80104711:	89 e5                	mov    %esp,%ebp
80104713:	57                   	push   %edi
80104714:	56                   	push   %esi
80104715:	53                   	push   %ebx
80104716:	83 ec 1c             	sub    $0x1c,%esp
  struct cpu *c = mycpu();
80104719:	e8 f2 fa ff ff       	call   80104210 <mycpu>
8010471e:	89 c7                	mov    %eax,%edi
  pushcli();
80104720:	e8 0b 0f 00 00       	call   80105630 <pushcli>
  c = mycpu();
80104725:	e8 e6 fa ff ff       	call   80104210 <mycpu>
  p = c->proc;
8010472a:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104730:	e8 3b 0f 00 00       	call   80105670 <popcli>
  if(!holding(&ptable.lock))
80104735:	83 ec 0c             	sub    $0xc,%esp
80104738:	68 40 5f 11 80       	push   $0x80115f40
8010473d:	e8 8e 0f 00 00       	call   801056d0 <holding>
80104742:	83 c4 10             	add    $0x10,%esp
80104745:	85 c0                	test   %eax,%eax
80104747:	74 7c                	je     801047c5 <sched_thread+0xb5>
  if(mycpu()->ncli != 1)
80104749:	e8 c2 fa ff ff       	call   80104210 <mycpu>
8010474e:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80104755:	0f 85 91 00 00 00    	jne    801047ec <sched_thread+0xdc>
  if(p->state == RUNNING)
8010475b:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
8010475f:	74 7e                	je     801047df <sched_thread+0xcf>
80104761:	9c                   	pushf  
80104762:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104763:	f6 c4 02             	test   $0x2,%ah
80104766:	75 6a                	jne    801047d2 <sched_thread+0xc2>
  intena = mycpu()->intena;
80104768:	e8 a3 fa ff ff       	call   80104210 <mycpu>
  next = pick_lwp(p->pid);
8010476d:	83 ec 0c             	sub    $0xc,%esp
  intena = mycpu()->intena;
80104770:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  next = pick_lwp(p->pid);
80104776:	ff 73 10             	pushl  0x10(%ebx)
80104779:	e8 62 3f 00 00       	call   801086e0 <pick_lwp>
  if(next != p)
8010477e:	83 c4 10             	add    $0x10,%esp
80104781:	39 d8                	cmp    %ebx,%eax
  c->proc = next;
80104783:	89 87 ac 00 00 00    	mov    %eax,0xac(%edi)
  next->state = RUNNING;
80104789:	c7 40 0c 04 00 00 00 	movl   $0x4,0xc(%eax)
  if(next != p)
80104790:	74 20                	je     801047b2 <sched_thread+0xa2>
    switchuvm1(next);
80104792:	83 ec 0c             	sub    $0xc,%esp
80104795:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    swtch(&(p->context), next->context);
80104798:	83 c3 1c             	add    $0x1c,%ebx
    switchuvm1(next);
8010479b:	50                   	push   %eax
8010479c:	e8 df 37 00 00       	call   80107f80 <switchuvm1>
    swtch(&(p->context), next->context);
801047a1:	58                   	pop    %eax
801047a2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801047a5:	5a                   	pop    %edx
801047a6:	ff 70 1c             	pushl  0x1c(%eax)
801047a9:	53                   	push   %ebx
801047aa:	e8 9c 12 00 00       	call   80105a4b <swtch>
801047af:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
801047b2:	e8 59 fa ff ff       	call   80104210 <mycpu>
801047b7:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
801047bd:	8d 65 f4             	lea    -0xc(%ebp),%esp
801047c0:	5b                   	pop    %ebx
801047c1:	5e                   	pop    %esi
801047c2:	5f                   	pop    %edi
801047c3:	5d                   	pop    %ebp
801047c4:	c3                   	ret    
    panic("sched_thread ptable.lock");
801047c5:	83 ec 0c             	sub    $0xc,%esp
801047c8:	68 90 95 10 80       	push   $0x80109590
801047cd:	e8 be bb ff ff       	call   80100390 <panic>
    panic("sched_thread interruptible");
801047d2:	83 ec 0c             	sub    $0xc,%esp
801047d5:	68 d1 95 10 80       	push   $0x801095d1
801047da:	e8 b1 bb ff ff       	call   80100390 <panic>
    panic("sched_thread running");
801047df:	83 ec 0c             	sub    $0xc,%esp
801047e2:	68 bc 95 10 80       	push   $0x801095bc
801047e7:	e8 a4 bb ff ff       	call   80100390 <panic>
    panic("sched_thread locks");
801047ec:	83 ec 0c             	sub    $0xc,%esp
801047ef:	68 a9 95 10 80       	push   $0x801095a9
801047f4:	e8 97 bb ff ff       	call   80100390 <panic>
801047f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104800 <yield>:
{
80104800:	55                   	push   %ebp
80104801:	89 e5                	mov    %esp,%ebp
80104803:	53                   	push   %ebx
80104804:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80104807:	68 40 5f 11 80       	push   $0x80115f40
8010480c:	e8 ef 0e 00 00       	call   80105700 <acquire>
  pushcli();
80104811:	e8 1a 0e 00 00       	call   80105630 <pushcli>
  c = mycpu();
80104816:	e8 f5 f9 ff ff       	call   80104210 <mycpu>
  p = c->proc;
8010481b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104821:	e8 4a 0e 00 00       	call   80105670 <popcli>
  myproc()->state = RUNNABLE;
80104826:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
8010482d:	e8 1e fe ff ff       	call   80104650 <sched>
  release(&ptable.lock);
80104832:	c7 04 24 40 5f 11 80 	movl   $0x80115f40,(%esp)
80104839:	e8 82 0f 00 00       	call   801057c0 <release>
}
8010483e:	83 c4 10             	add    $0x10,%esp
80104841:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104844:	c9                   	leave  
80104845:	c3                   	ret    
80104846:	8d 76 00             	lea    0x0(%esi),%esi
80104849:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104850 <yield_thread>:
{
80104850:	55                   	push   %ebp
80104851:	89 e5                	mov    %esp,%ebp
80104853:	53                   	push   %ebx
80104854:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80104857:	68 40 5f 11 80       	push   $0x80115f40
8010485c:	e8 9f 0e 00 00       	call   80105700 <acquire>
  pushcli();
80104861:	e8 ca 0d 00 00       	call   80105630 <pushcli>
  c = mycpu();
80104866:	e8 a5 f9 ff ff       	call   80104210 <mycpu>
  p = c->proc;
8010486b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104871:	e8 fa 0d 00 00       	call   80105670 <popcli>
  myproc()->state = RUNNABLE;
80104876:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched_thread();
8010487d:	e8 8e fe ff ff       	call   80104710 <sched_thread>
  release(&ptable.lock);
80104882:	c7 04 24 40 5f 11 80 	movl   $0x80115f40,(%esp)
80104889:	e8 32 0f 00 00       	call   801057c0 <release>
}
8010488e:	83 c4 10             	add    $0x10,%esp
80104891:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104894:	c9                   	leave  
80104895:	c3                   	ret    
80104896:	8d 76 00             	lea    0x0(%esi),%esi
80104899:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801048a0 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
801048a0:	55                   	push   %ebp
801048a1:	89 e5                	mov    %esp,%ebp
801048a3:	57                   	push   %edi
801048a4:	56                   	push   %esi
801048a5:	53                   	push   %ebx
801048a6:	83 ec 0c             	sub    $0xc,%esp
801048a9:	8b 7d 08             	mov    0x8(%ebp),%edi
801048ac:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
801048af:	e8 7c 0d 00 00       	call   80105630 <pushcli>
  c = mycpu();
801048b4:	e8 57 f9 ff ff       	call   80104210 <mycpu>
  p = c->proc;
801048b9:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801048bf:	e8 ac 0d 00 00       	call   80105670 <popcli>
  struct proc *p = myproc();
  
  if(p == 0)
801048c4:	85 db                	test   %ebx,%ebx
801048c6:	0f 84 87 00 00 00    	je     80104953 <sleep+0xb3>
    panic("sleep");

  if(lk == 0)
801048cc:	85 f6                	test   %esi,%esi
801048ce:	74 76                	je     80104946 <sleep+0xa6>
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){  //DOC: sleeplock0
801048d0:	81 fe 40 5f 11 80    	cmp    $0x80115f40,%esi
801048d6:	74 50                	je     80104928 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
801048d8:	83 ec 0c             	sub    $0xc,%esp
801048db:	68 40 5f 11 80       	push   $0x80115f40
801048e0:	e8 1b 0e 00 00       	call   80105700 <acquire>
    release(lk);
801048e5:	89 34 24             	mov    %esi,(%esp)
801048e8:	e8 d3 0e 00 00       	call   801057c0 <release>
  }
  // Go to sleep.
  p->chan = chan;
801048ed:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
801048f0:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)

  sched();
801048f7:	e8 54 fd ff ff       	call   80104650 <sched>

  // Tidy up.
  p->chan = 0;
801048fc:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
80104903:	c7 04 24 40 5f 11 80 	movl   $0x80115f40,(%esp)
8010490a:	e8 b1 0e 00 00       	call   801057c0 <release>
    acquire(lk);
8010490f:	89 75 08             	mov    %esi,0x8(%ebp)
80104912:	83 c4 10             	add    $0x10,%esp
  }
}
80104915:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104918:	5b                   	pop    %ebx
80104919:	5e                   	pop    %esi
8010491a:	5f                   	pop    %edi
8010491b:	5d                   	pop    %ebp
    acquire(lk);
8010491c:	e9 df 0d 00 00       	jmp    80105700 <acquire>
80104921:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  p->chan = chan;
80104928:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
8010492b:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104932:	e8 19 fd ff ff       	call   80104650 <sched>
  p->chan = 0;
80104937:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
8010493e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104941:	5b                   	pop    %ebx
80104942:	5e                   	pop    %esi
80104943:	5f                   	pop    %edi
80104944:	5d                   	pop    %ebp
80104945:	c3                   	ret    
    panic("sleep without lk");
80104946:	83 ec 0c             	sub    $0xc,%esp
80104949:	68 f2 95 10 80       	push   $0x801095f2
8010494e:	e8 3d ba ff ff       	call   80100390 <panic>
    panic("sleep");
80104953:	83 ec 0c             	sub    $0xc,%esp
80104956:	68 ec 95 10 80       	push   $0x801095ec
8010495b:	e8 30 ba ff ff       	call   80100390 <panic>

80104960 <exit>:
{
80104960:	55                   	push   %ebp
80104961:	89 e5                	mov    %esp,%ebp
80104963:	57                   	push   %edi
80104964:	56                   	push   %esi
80104965:	53                   	push   %ebx
80104966:	83 ec 0c             	sub    $0xc,%esp
  pushcli();
80104969:	e8 c2 0c 00 00       	call   80105630 <pushcli>
  c = mycpu();
8010496e:	e8 9d f8 ff ff       	call   80104210 <mycpu>
  p = c->proc;
80104973:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104979:	e8 f2 0c 00 00       	call   80105670 <popcli>
  if(curproc == initproc)
8010497e:	39 35 b8 c5 10 80    	cmp    %esi,0x8010c5b8
80104984:	8d 5e 28             	lea    0x28(%esi),%ebx
80104987:	8d 7e 68             	lea    0x68(%esi),%edi
8010498a:	0f 84 3e 02 00 00    	je     80104bce <exit+0x26e>
    if(curproc->ofile[fd]){
80104990:	8b 03                	mov    (%ebx),%eax
80104992:	85 c0                	test   %eax,%eax
80104994:	74 12                	je     801049a8 <exit+0x48>
      fileclose(curproc->ofile[fd]);
80104996:	83 ec 0c             	sub    $0xc,%esp
80104999:	50                   	push   %eax
8010499a:	e8 51 c5 ff ff       	call   80100ef0 <fileclose>
      curproc->ofile[fd] = 0;
8010499f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
801049a5:	83 c4 10             	add    $0x10,%esp
801049a8:	83 c3 04             	add    $0x4,%ebx
  for(fd = 0; fd < NOFILE; fd++){
801049ab:	39 df                	cmp    %ebx,%edi
801049ad:	75 e1                	jne    80104990 <exit+0x30>
  begin_op();
801049af:	e8 bc e8 ff ff       	call   80103270 <begin_op>
  iput(curproc->cwd);
801049b4:	83 ec 0c             	sub    $0xc,%esp
801049b7:	ff 76 68             	pushl  0x68(%esi)
801049ba:	e8 41 d2 ff ff       	call   80101c00 <iput>
  end_op();
801049bf:	e8 5c e9 ff ff       	call   80103320 <end_op>
  curproc->cwd = 0;
801049c4:	c7 46 68 00 00 00 00 	movl   $0x0,0x68(%esi)
  acquire(&ptable.lock);
801049cb:	c7 04 24 40 5f 11 80 	movl   $0x80115f40,(%esp)
801049d2:	e8 29 0d 00 00       	call   80105700 <acquire>
  if (curproc->tid != 1){
801049d7:	83 c4 10             	add    $0x10,%esp
801049da:	83 be 8c 00 00 00 01 	cmpl   $0x1,0x8c(%esi)
801049e1:	74 47                	je     80104a2a <exit+0xca>
    curproc->master->killed = 1;
801049e3:	8b 86 90 00 00 00    	mov    0x90(%esi),%eax
801049e9:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801049f0:	b8 74 5f 11 80       	mov    $0x80115f74,%eax
    wakeup1(curproc->master);
801049f5:	8b 96 90 00 00 00    	mov    0x90(%esi),%edx
801049fb:	eb 0f                	jmp    80104a0c <exit+0xac>
801049fd:	8d 76 00             	lea    0x0(%esi),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104a00:	05 a0 01 00 00       	add    $0x1a0,%eax
80104a05:	3d 74 c7 11 80       	cmp    $0x8011c774,%eax
80104a0a:	73 1e                	jae    80104a2a <exit+0xca>
    if(p->state == SLEEPING && p->chan == chan)
80104a0c:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104a10:	75 ee                	jne    80104a00 <exit+0xa0>
80104a12:	3b 50 20             	cmp    0x20(%eax),%edx
80104a15:	75 e9                	jne    80104a00 <exit+0xa0>
      p->state = RUNNABLE;
80104a17:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104a1e:	05 a0 01 00 00       	add    $0x1a0,%eax
80104a23:	3d 74 c7 11 80       	cmp    $0x8011c774,%eax
80104a28:	72 e2                	jb     80104a0c <exit+0xac>
      p->parent = initproc;
80104a2a:	8b 0d b8 c5 10 80    	mov    0x8010c5b8,%ecx
80104a30:	ba 74 5f 11 80       	mov    $0x80115f74,%edx
80104a35:	eb 17                	jmp    80104a4e <exit+0xee>
80104a37:	89 f6                	mov    %esi,%esi
80104a39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104a40:	81 c2 a0 01 00 00    	add    $0x1a0,%edx
80104a46:	81 fa 74 c7 11 80    	cmp    $0x8011c774,%edx
80104a4c:	73 4a                	jae    80104a98 <exit+0x138>
    if(p->pid != curproc->pid && p->parent == curproc->master){
80104a4e:	8b 46 10             	mov    0x10(%esi),%eax
80104a51:	39 42 10             	cmp    %eax,0x10(%edx)
80104a54:	74 ea                	je     80104a40 <exit+0xe0>
80104a56:	8b 86 90 00 00 00    	mov    0x90(%esi),%eax
80104a5c:	39 42 14             	cmp    %eax,0x14(%edx)
80104a5f:	75 df                	jne    80104a40 <exit+0xe0>
      if(p->state == ZOMBIE)
80104a61:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
80104a65:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
80104a68:	75 d6                	jne    80104a40 <exit+0xe0>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104a6a:	b8 74 5f 11 80       	mov    $0x80115f74,%eax
80104a6f:	eb 13                	jmp    80104a84 <exit+0x124>
80104a71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a78:	05 a0 01 00 00       	add    $0x1a0,%eax
80104a7d:	3d 74 c7 11 80       	cmp    $0x8011c774,%eax
80104a82:	73 bc                	jae    80104a40 <exit+0xe0>
    if(p->state == SLEEPING && p->chan == chan)
80104a84:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104a88:	75 ee                	jne    80104a78 <exit+0x118>
80104a8a:	3b 48 20             	cmp    0x20(%eax),%ecx
80104a8d:	75 e9                	jne    80104a78 <exit+0x118>
      p->state = RUNNABLE;
80104a8f:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80104a96:	eb e0                	jmp    80104a78 <exit+0x118>
  if(curproc->tid == 1)
80104a98:	83 be 8c 00 00 00 01 	cmpl   $0x1,0x8c(%esi)
80104a9f:	0f 84 b0 00 00 00    	je     80104b55 <exit+0x1f5>
  curproc->state = ZOMBIE;
80104aa5:	c7 46 0c 05 00 00 00 	movl   $0x5,0xc(%esi)
  wakeup1(curproc->parent);
80104aac:	8b 56 14             	mov    0x14(%esi),%edx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104aaf:	b8 74 5f 11 80       	mov    $0x80115f74,%eax
80104ab4:	eb 16                	jmp    80104acc <exit+0x16c>
80104ab6:	8d 76 00             	lea    0x0(%esi),%esi
80104ab9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104ac0:	05 a0 01 00 00       	add    $0x1a0,%eax
80104ac5:	3d 74 c7 11 80       	cmp    $0x8011c774,%eax
80104aca:	73 1e                	jae    80104aea <exit+0x18a>
    if(p->state == SLEEPING && p->chan == chan)
80104acc:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104ad0:	75 ee                	jne    80104ac0 <exit+0x160>
80104ad2:	3b 50 20             	cmp    0x20(%eax),%edx
80104ad5:	75 e9                	jne    80104ac0 <exit+0x160>
      p->state = RUNNABLE;
80104ad7:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104ade:	05 a0 01 00 00       	add    $0x1a0,%eax
80104ae3:	3d 74 c7 11 80       	cmp    $0x8011c774,%eax
80104ae8:	72 e2                	jb     80104acc <exit+0x16c>
  wakeup1(curproc->master);
80104aea:	8b 96 90 00 00 00    	mov    0x90(%esi),%edx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104af0:	b8 74 5f 11 80       	mov    $0x80115f74,%eax
80104af5:	eb 15                	jmp    80104b0c <exit+0x1ac>
80104af7:	89 f6                	mov    %esi,%esi
80104af9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104b00:	05 a0 01 00 00       	add    $0x1a0,%eax
80104b05:	3d 74 c7 11 80       	cmp    $0x8011c774,%eax
80104b0a:	73 1e                	jae    80104b2a <exit+0x1ca>
    if(p->state == SLEEPING && p->chan == chan)
80104b0c:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104b10:	75 ee                	jne    80104b00 <exit+0x1a0>
80104b12:	3b 50 20             	cmp    0x20(%eax),%edx
80104b15:	75 e9                	jne    80104b00 <exit+0x1a0>
      p->state = RUNNABLE;
80104b17:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104b1e:	05 a0 01 00 00       	add    $0x1a0,%eax
80104b23:	3d 74 c7 11 80       	cmp    $0x8011c774,%eax
80104b28:	72 e2                	jb     80104b0c <exit+0x1ac>
  sched();
80104b2a:	e8 21 fb ff ff       	call   80104650 <sched>
  panic("zombie exit");
80104b2f:	83 ec 0c             	sub    $0xc,%esp
80104b32:	68 10 96 10 80       	push   $0x80109610
80104b37:	e8 54 b8 ff ff       	call   80100390 <panic>
      if(kids != 0)
80104b3c:	85 ff                	test   %edi,%edi
80104b3e:	0f 84 61 ff ff ff    	je     80104aa5 <exit+0x145>
        sleep(curproc, &ptable.lock);
80104b44:	83 ec 08             	sub    $0x8,%esp
80104b47:	68 40 5f 11 80       	push   $0x80115f40
80104b4c:	56                   	push   %esi
80104b4d:	e8 4e fd ff ff       	call   801048a0 <sleep>
    {
80104b52:	83 c4 10             	add    $0x10,%esp
      int kids = 0;
80104b55:	31 ff                	xor    %edi,%edi
      for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104b57:	bb 74 5f 11 80       	mov    $0x80115f74,%ebx
80104b5c:	eb 10                	jmp    80104b6e <exit+0x20e>
80104b5e:	66 90                	xchg   %ax,%ax
80104b60:	81 c3 a0 01 00 00    	add    $0x1a0,%ebx
80104b66:	81 fb 74 c7 11 80    	cmp    $0x8011c774,%ebx
80104b6c:	73 ce                	jae    80104b3c <exit+0x1dc>
        if(p == curproc)
80104b6e:	8b 86 90 00 00 00    	mov    0x90(%esi),%eax
80104b74:	39 83 90 00 00 00    	cmp    %eax,0x90(%ebx)
80104b7a:	75 e4                	jne    80104b60 <exit+0x200>
80104b7c:	39 de                	cmp    %ebx,%esi
80104b7e:	74 e0                	je     80104b60 <exit+0x200>
        if(p->state == ZOMBIE){
80104b80:	8b 43 0c             	mov    0xc(%ebx),%eax
80104b83:	83 f8 05             	cmp    $0x5,%eax
80104b86:	74 38                	je     80104bc0 <exit+0x260>
        else if(p->state != UNUSED)
80104b88:	85 c0                	test   %eax,%eax
80104b8a:	74 d4                	je     80104b60 <exit+0x200>
          kids++;
80104b8c:	83 c7 01             	add    $0x1,%edi
          p->killed = 1;
80104b8f:	c7 43 24 01 00 00 00 	movl   $0x1,0x24(%ebx)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104b96:	b8 74 5f 11 80       	mov    $0x80115f74,%eax
80104b9b:	eb 0f                	jmp    80104bac <exit+0x24c>
80104b9d:	8d 76 00             	lea    0x0(%esi),%esi
80104ba0:	05 a0 01 00 00       	add    $0x1a0,%eax
80104ba5:	3d 74 c7 11 80       	cmp    $0x8011c774,%eax
80104baa:	73 b4                	jae    80104b60 <exit+0x200>
    if(p->state == SLEEPING && p->chan == chan)
80104bac:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104bb0:	75 ee                	jne    80104ba0 <exit+0x240>
80104bb2:	39 58 20             	cmp    %ebx,0x20(%eax)
80104bb5:	75 e9                	jne    80104ba0 <exit+0x240>
      p->state = RUNNABLE;
80104bb7:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80104bbe:	eb e0                	jmp    80104ba0 <exit+0x240>
          delete_thread(p);
80104bc0:	83 ec 0c             	sub    $0xc,%esp
80104bc3:	53                   	push   %ebx
80104bc4:	e8 27 f4 ff ff       	call   80103ff0 <delete_thread>
80104bc9:	83 c4 10             	add    $0x10,%esp
80104bcc:	eb 92                	jmp    80104b60 <exit+0x200>
    panic("init exiting");
80104bce:	83 ec 0c             	sub    $0xc,%esp
80104bd1:	68 03 96 10 80       	push   $0x80109603
80104bd6:	e8 b5 b7 ff ff       	call   80100390 <panic>
80104bdb:	90                   	nop
80104bdc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104be0 <wait>:
{
80104be0:	55                   	push   %ebp
80104be1:	89 e5                	mov    %esp,%ebp
80104be3:	53                   	push   %ebx
80104be4:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80104be7:	e8 44 0a 00 00       	call   80105630 <pushcli>
  c = mycpu();
80104bec:	e8 1f f6 ff ff       	call   80104210 <mycpu>
  p = c->proc;
80104bf1:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104bf7:	e8 74 0a 00 00       	call   80105670 <popcli>
  acquire(&ptable.lock);
80104bfc:	83 ec 0c             	sub    $0xc,%esp
80104bff:	68 40 5f 11 80       	push   $0x80115f40
80104c04:	e8 f7 0a 00 00       	call   80105700 <acquire>
80104c09:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
80104c0c:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104c0e:	ba 74 5f 11 80       	mov    $0x80115f74,%edx
80104c13:	eb 11                	jmp    80104c26 <wait+0x46>
80104c15:	8d 76 00             	lea    0x0(%esi),%esi
80104c18:	81 c2 a0 01 00 00    	add    $0x1a0,%edx
80104c1e:	81 fa 74 c7 11 80    	cmp    $0x8011c774,%edx
80104c24:	73 1e                	jae    80104c44 <wait+0x64>
      if(p->parent != curproc)
80104c26:	39 5a 14             	cmp    %ebx,0x14(%edx)
80104c29:	75 ed                	jne    80104c18 <wait+0x38>
      if(p->state == ZOMBIE){
80104c2b:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
80104c2f:	74 7f                	je     80104cb0 <wait+0xd0>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104c31:	81 c2 a0 01 00 00    	add    $0x1a0,%edx
      havekids = 1;
80104c37:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104c3c:	81 fa 74 c7 11 80    	cmp    $0x8011c774,%edx
80104c42:	72 e2                	jb     80104c26 <wait+0x46>
    if(!havekids || curproc->killed){
80104c44:	85 c0                	test   %eax,%eax
80104c46:	0f 84 86 00 00 00    	je     80104cd2 <wait+0xf2>
80104c4c:	8b 43 24             	mov    0x24(%ebx),%eax
80104c4f:	85 c0                	test   %eax,%eax
80104c51:	75 7f                	jne    80104cd2 <wait+0xf2>
    wakeup1(curproc->parent);
80104c53:	8b 53 14             	mov    0x14(%ebx),%edx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104c56:	b8 74 5f 11 80       	mov    $0x80115f74,%eax
80104c5b:	eb 0f                	jmp    80104c6c <wait+0x8c>
80104c5d:	8d 76 00             	lea    0x0(%esi),%esi
80104c60:	05 a0 01 00 00       	add    $0x1a0,%eax
80104c65:	3d 74 c7 11 80       	cmp    $0x8011c774,%eax
80104c6a:	73 24                	jae    80104c90 <wait+0xb0>
    if(p->state == SLEEPING && p->chan == chan)
80104c6c:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104c70:	75 ee                	jne    80104c60 <wait+0x80>
80104c72:	3b 50 20             	cmp    0x20(%eax),%edx
80104c75:	75 e9                	jne    80104c60 <wait+0x80>
      p->state = RUNNABLE;
80104c77:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104c7e:	05 a0 01 00 00       	add    $0x1a0,%eax
80104c83:	3d 74 c7 11 80       	cmp    $0x8011c774,%eax
80104c88:	72 e2                	jb     80104c6c <wait+0x8c>
80104c8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
80104c90:	83 ec 08             	sub    $0x8,%esp
80104c93:	68 40 5f 11 80       	push   $0x80115f40
80104c98:	53                   	push   %ebx
80104c99:	e8 02 fc ff ff       	call   801048a0 <sleep>
    havekids = 0;
80104c9e:	83 c4 10             	add    $0x10,%esp
80104ca1:	e9 66 ff ff ff       	jmp    80104c0c <wait+0x2c>
80104ca6:	8d 76 00             	lea    0x0(%esi),%esi
80104ca9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
        delete_thread(p);
80104cb0:	83 ec 0c             	sub    $0xc,%esp
        pid = p->pid;
80104cb3:	8b 5a 10             	mov    0x10(%edx),%ebx
        delete_thread(p);
80104cb6:	52                   	push   %edx
80104cb7:	e8 34 f3 ff ff       	call   80103ff0 <delete_thread>
        release(&ptable.lock);
80104cbc:	c7 04 24 40 5f 11 80 	movl   $0x80115f40,(%esp)
80104cc3:	e8 f8 0a 00 00       	call   801057c0 <release>
        return pid;
80104cc8:	83 c4 10             	add    $0x10,%esp
}
80104ccb:	89 d8                	mov    %ebx,%eax
80104ccd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104cd0:	c9                   	leave  
80104cd1:	c3                   	ret    
      release(&ptable.lock);
80104cd2:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80104cd5:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&ptable.lock);
80104cda:	68 40 5f 11 80       	push   $0x80115f40
80104cdf:	e8 dc 0a 00 00       	call   801057c0 <release>
      return -1;
80104ce4:	83 c4 10             	add    $0x10,%esp
80104ce7:	eb e2                	jmp    80104ccb <wait+0xeb>
80104ce9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104cf0 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104cf0:	55                   	push   %ebp
80104cf1:	89 e5                	mov    %esp,%ebp
80104cf3:	53                   	push   %ebx
80104cf4:	83 ec 10             	sub    $0x10,%esp
80104cf7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
80104cfa:	68 40 5f 11 80       	push   $0x80115f40
80104cff:	e8 fc 09 00 00       	call   80105700 <acquire>
80104d04:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104d07:	b8 74 5f 11 80       	mov    $0x80115f74,%eax
80104d0c:	eb 0e                	jmp    80104d1c <wakeup+0x2c>
80104d0e:	66 90                	xchg   %ax,%ax
80104d10:	05 a0 01 00 00       	add    $0x1a0,%eax
80104d15:	3d 74 c7 11 80       	cmp    $0x8011c774,%eax
80104d1a:	73 1e                	jae    80104d3a <wakeup+0x4a>
    if(p->state == SLEEPING && p->chan == chan)
80104d1c:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104d20:	75 ee                	jne    80104d10 <wakeup+0x20>
80104d22:	3b 58 20             	cmp    0x20(%eax),%ebx
80104d25:	75 e9                	jne    80104d10 <wakeup+0x20>
      p->state = RUNNABLE;
80104d27:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104d2e:	05 a0 01 00 00       	add    $0x1a0,%eax
80104d33:	3d 74 c7 11 80       	cmp    $0x8011c774,%eax
80104d38:	72 e2                	jb     80104d1c <wakeup+0x2c>
  wakeup1(chan);
  release(&ptable.lock);
80104d3a:	c7 45 08 40 5f 11 80 	movl   $0x80115f40,0x8(%ebp)
}
80104d41:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104d44:	c9                   	leave  
  release(&ptable.lock);
80104d45:	e9 76 0a 00 00       	jmp    801057c0 <release>
80104d4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104d50 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104d50:	55                   	push   %ebp
80104d51:	89 e5                	mov    %esp,%ebp
80104d53:	53                   	push   %ebx
80104d54:	83 ec 10             	sub    $0x10,%esp
80104d57:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;
  acquire(&ptable.lock);
80104d5a:	68 40 5f 11 80       	push   $0x80115f40
80104d5f:	e8 9c 09 00 00       	call   80105700 <acquire>
80104d64:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104d67:	b8 74 5f 11 80       	mov    $0x80115f74,%eax
80104d6c:	eb 0e                	jmp    80104d7c <kill+0x2c>
80104d6e:	66 90                	xchg   %ax,%ax
80104d70:	05 a0 01 00 00       	add    $0x1a0,%eax
80104d75:	3d 74 c7 11 80       	cmp    $0x8011c774,%eax
80104d7a:	73 34                	jae    80104db0 <kill+0x60>
    if(p->pid == pid){
80104d7c:	39 58 10             	cmp    %ebx,0x10(%eax)
80104d7f:	75 ef                	jne    80104d70 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80104d81:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
80104d85:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
80104d8c:	75 07                	jne    80104d95 <kill+0x45>
        p->state = RUNNABLE;
80104d8e:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
80104d95:	83 ec 0c             	sub    $0xc,%esp
80104d98:	68 40 5f 11 80       	push   $0x80115f40
80104d9d:	e8 1e 0a 00 00       	call   801057c0 <release>
      return 0;
80104da2:	83 c4 10             	add    $0x10,%esp
80104da5:	31 c0                	xor    %eax,%eax
    }
  }
  release(&ptable.lock);
  return -1;
}
80104da7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104daa:	c9                   	leave  
80104dab:	c3                   	ret    
80104dac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&ptable.lock);
80104db0:	83 ec 0c             	sub    $0xc,%esp
80104db3:	68 40 5f 11 80       	push   $0x80115f40
80104db8:	e8 03 0a 00 00       	call   801057c0 <release>
  return -1;
80104dbd:	83 c4 10             	add    $0x10,%esp
80104dc0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104dc5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104dc8:	c9                   	leave  
80104dc9:	c3                   	ret    
80104dca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104dd0 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104dd0:	55                   	push   %ebp
80104dd1:	89 e5                	mov    %esp,%ebp
80104dd3:	57                   	push   %edi
80104dd4:	56                   	push   %esi
80104dd5:	53                   	push   %ebx
80104dd6:	8d 75 e8             	lea    -0x18(%ebp),%esi
  struct stride *s;
  struct mlfq_node *m;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104dd9:	bb 74 5f 11 80       	mov    $0x80115f74,%ebx
{
80104dde:	83 ec 3c             	sub    $0x3c,%esp
80104de1:	eb 27                	jmp    80104e0a <procdump+0x3a>
80104de3:	90                   	nop
80104de4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104de8:	83 ec 0c             	sub    $0xc,%esp
80104deb:	68 47 9a 10 80       	push   $0x80109a47
80104df0:	e8 6b b8 ff ff       	call   80100660 <cprintf>
80104df5:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104df8:	81 c3 a0 01 00 00    	add    $0x1a0,%ebx
80104dfe:	81 fb 74 c7 11 80    	cmp    $0x8011c774,%ebx
80104e04:	0f 83 a6 00 00 00    	jae    80104eb0 <procdump+0xe0>
    if(p->state == UNUSED)
80104e0a:	8b 43 0c             	mov    0xc(%ebx),%eax
80104e0d:	85 c0                	test   %eax,%eax
80104e0f:	74 e7                	je     80104df8 <procdump+0x28>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104e11:	83 f8 05             	cmp    $0x5,%eax
      state = "???";
80104e14:	ba 1c 96 10 80       	mov    $0x8010961c,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104e19:	77 11                	ja     80104e2c <procdump+0x5c>
80104e1b:	8b 14 85 f4 96 10 80 	mov    -0x7fef690c(,%eax,4),%edx
      state = "???";
80104e22:	b8 1c 96 10 80       	mov    $0x8010961c,%eax
80104e27:	85 d2                	test   %edx,%edx
80104e29:	0f 44 d0             	cmove  %eax,%edx
    cprintf("pid:%d tid:%d     %s  %s  killed : %d ::parent pid:%d %d\n", p->pid, p->tid, state, p->name,p->killed ,p->parent->pid, p->parent->tid);
80104e2c:	8b 43 14             	mov    0x14(%ebx),%eax
80104e2f:	ff b0 8c 00 00 00    	pushl  0x8c(%eax)
80104e35:	ff 70 10             	pushl  0x10(%eax)
80104e38:	8d 43 6c             	lea    0x6c(%ebx),%eax
80104e3b:	ff 73 24             	pushl  0x24(%ebx)
80104e3e:	50                   	push   %eax
80104e3f:	52                   	push   %edx
80104e40:	ff b3 8c 00 00 00    	pushl  0x8c(%ebx)
80104e46:	ff 73 10             	pushl  0x10(%ebx)
80104e49:	68 b8 96 10 80       	push   $0x801096b8
80104e4e:	e8 0d b8 ff ff       	call   80100660 <cprintf>
    if(p->state == SLEEPING){
80104e53:	83 c4 20             	add    $0x20,%esp
80104e56:	83 7b 0c 02          	cmpl   $0x2,0xc(%ebx)
80104e5a:	75 8c                	jne    80104de8 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104e5c:	8d 45 c0             	lea    -0x40(%ebp),%eax
80104e5f:	83 ec 08             	sub    $0x8,%esp
80104e62:	8d 7d c0             	lea    -0x40(%ebp),%edi
80104e65:	50                   	push   %eax
80104e66:	8b 43 1c             	mov    0x1c(%ebx),%eax
80104e69:	8b 40 0c             	mov    0xc(%eax),%eax
80104e6c:	83 c0 08             	add    $0x8,%eax
80104e6f:	50                   	push   %eax
80104e70:	e8 6b 07 00 00       	call   801055e0 <getcallerpcs>
80104e75:	83 c4 10             	add    $0x10,%esp
80104e78:	90                   	nop
80104e79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      for(i=0; i<10 && pc[i] != 0; i++)
80104e80:	8b 17                	mov    (%edi),%edx
80104e82:	85 d2                	test   %edx,%edx
80104e84:	0f 84 5e ff ff ff    	je     80104de8 <procdump+0x18>
        cprintf(" %p", pc[i]);
80104e8a:	83 ec 08             	sub    $0x8,%esp
80104e8d:	83 c7 04             	add    $0x4,%edi
80104e90:	52                   	push   %edx
80104e91:	68 01 90 10 80       	push   $0x80109001
80104e96:	e8 c5 b7 ff ff       	call   80100660 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
80104e9b:	83 c4 10             	add    $0x10,%esp
80104e9e:	39 fe                	cmp    %edi,%esi
80104ea0:	75 de                	jne    80104e80 <procdump+0xb0>
80104ea2:	e9 41 ff ff ff       	jmp    80104de8 <procdump+0x18>
80104ea7:	89 f6                	mov    %esi,%esi
80104ea9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  }
  cprintf("-----\n");
80104eb0:	83 ec 0c             	sub    $0xc,%esp
  for(s = s_table; s < &s_table[NPROC]; ++s)
80104eb3:	bb 20 4d 11 80       	mov    $0x80114d20,%ebx
  cprintf("-----\n");
80104eb8:	68 20 96 10 80       	push   $0x80109620
80104ebd:	e8 9e b7 ff ff       	call   80100660 <cprintf>
80104ec2:	83 c4 10             	add    $0x10,%esp
80104ec5:	8d 76 00             	lea    0x0(%esi),%esi
  {
    if(s->state == EMPTY)
80104ec8:	83 7b 14 01          	cmpl   $0x1,0x14(%ebx)
80104ecc:	74 16                	je     80104ee4 <procdump+0x114>
      continue;
    cprintf("s->pid:%d  s->pass:%d\n", s->pid, s->pass);
80104ece:	83 ec 04             	sub    $0x4,%esp
80104ed1:	ff 73 08             	pushl  0x8(%ebx)
80104ed4:	ff 73 0c             	pushl  0xc(%ebx)
80104ed7:	68 27 96 10 80       	push   $0x80109627
80104edc:	e8 7f b7 ff ff       	call   80100660 <cprintf>
80104ee1:	83 c4 10             	add    $0x10,%esp
  for(s = s_table; s < &s_table[NPROC]; ++s)
80104ee4:	83 c3 18             	add    $0x18,%ebx
80104ee7:	81 fb 20 53 11 80    	cmp    $0x80115320,%ebx
80104eed:	75 d9                	jne    80104ec8 <procdump+0xf8>
  }
  cprintf("-----\n");
80104eef:	83 ec 0c             	sub    $0xc,%esp
80104ef2:	be 20 53 11 80       	mov    $0x80115320,%esi
80104ef7:	68 20 96 10 80       	push   $0x80109620
80104efc:	e8 5f b7 ff ff       	call   80100660 <cprintf>
80104f01:	83 c4 10             	add    $0x10,%esp
80104f04:	8d 9e 00 04 00 00    	lea    0x400(%esi),%ebx
  for(int prior = 0 ;prior<3; ++prior)
  {
    for(m = m_table[prior].table; m < &m_table[prior].table[NPROC]; ++m)
80104f0a:	89 f7                	mov    %esi,%edi
80104f0c:	39 f3                	cmp    %esi,%ebx
80104f0e:	76 22                	jbe    80104f32 <procdump+0x162>
    {
      if(m->state == EMPTY)
80104f10:	83 3f 01             	cmpl   $0x1,(%edi)
80104f13:	74 16                	je     80104f2b <procdump+0x15b>
        continue;
      cprintf("m->pid:%d  m->eticks:%d\n", m->pid, m->eticks);
80104f15:	83 ec 04             	sub    $0x4,%esp
80104f18:	ff 77 04             	pushl  0x4(%edi)
80104f1b:	ff 77 08             	pushl  0x8(%edi)
80104f1e:	68 3e 96 10 80       	push   $0x8010963e
80104f23:	e8 38 b7 ff ff       	call   80100660 <cprintf>
80104f28:	83 c4 10             	add    $0x10,%esp
    for(m = m_table[prior].table; m < &m_table[prior].table[NPROC]; ++m)
80104f2b:	83 c7 10             	add    $0x10,%edi
80104f2e:	39 fb                	cmp    %edi,%ebx
80104f30:	77 de                	ja     80104f10 <procdump+0x140>
80104f32:	81 c6 08 04 00 00    	add    $0x408,%esi
  for(int prior = 0 ;prior<3; ++prior)
80104f38:	b8 38 5f 11 80       	mov    $0x80115f38,%eax
80104f3d:	39 f0                	cmp    %esi,%eax
80104f3f:	75 c3                	jne    80104f04 <procdump+0x134>
    }
  }
  cprintf("-----\n");
80104f41:	83 ec 0c             	sub    $0xc,%esp
80104f44:	68 20 96 10 80       	push   $0x80109620
80104f49:	e8 12 b7 ff ff       	call   80100660 <cprintf>
}
80104f4e:	83 c4 10             	add    $0x10,%esp
80104f51:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104f54:	5b                   	pop    %ebx
80104f55:	5e                   	pop    %esi
80104f56:	5f                   	pop    %edi
80104f57:	5d                   	pop    %ebp
80104f58:	c3                   	ret    
80104f59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104f60 <getppid>:

int
getppid(void)
{
80104f60:	55                   	push   %ebp
80104f61:	89 e5                	mov    %esp,%ebp
80104f63:	53                   	push   %ebx
80104f64:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80104f67:	e8 c4 06 00 00       	call   80105630 <pushcli>
  c = mycpu();
80104f6c:	e8 9f f2 ff ff       	call   80104210 <mycpu>
  p = c->proc;
80104f71:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104f77:	e8 f4 06 00 00       	call   80105670 <popcli>
	return myproc()->parent->pid;
80104f7c:	8b 43 14             	mov    0x14(%ebx),%eax
80104f7f:	8b 40 10             	mov    0x10(%eax),%eax
}
80104f82:	83 c4 04             	add    $0x4,%esp
80104f85:	5b                   	pop    %ebx
80104f86:	5d                   	pop    %ebp
80104f87:	c3                   	ret    
80104f88:	90                   	nop
80104f89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104f90 <thread_create>:

// Create new thread
int 
thread_create(thread_t * thread, void *(*start_routine)(void *), void *arg)
{
80104f90:	55                   	push   %ebp
80104f91:	89 e5                	mov    %esp,%ebp
80104f93:	57                   	push   %edi
80104f94:	56                   	push   %esi
80104f95:	53                   	push   %ebx
80104f96:	83 ec 3c             	sub    $0x3c,%esp
  pushcli();
80104f99:	e8 92 06 00 00       	call   80105630 <pushcli>
  c = mycpu();
80104f9e:	e8 6d f2 ff ff       	call   80104210 <mycpu>
  p = c->proc;
80104fa3:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104fa9:	e8 c2 06 00 00       	call   80105670 <popcli>
  struct proc *curproc = myproc(); 
  struct proc *master_thread = curproc->master;
  struct proc *p;
  uint ustack[2];

  acquire (&ptable.lock);
80104fae:	83 ec 0c             	sub    $0xc,%esp
  struct proc *master_thread = curproc->master;
80104fb1:	8b 96 90 00 00 00    	mov    0x90(%esi),%edx
  acquire (&ptable.lock);
80104fb7:	68 40 5f 11 80       	push   $0x80115f40
  struct proc *master_thread = curproc->master;
80104fbc:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  acquire (&ptable.lock);
80104fbf:	e8 3c 07 00 00       	call   80105700 <acquire>
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
  {
    if (p->pid == curproc->pid)
80104fc4:	8b 7e 10             	mov    0x10(%esi),%edi
  int next_tid = 1;
80104fc7:	8b 55 d4             	mov    -0x2c(%ebp),%edx
    if (p->pid == curproc->pid)
80104fca:	83 c4 10             	add    $0x10,%esp
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104fcd:	b8 74 5f 11 80       	mov    $0x80115f74,%eax
  int next_tid = 1;
80104fd2:	b9 01 00 00 00       	mov    $0x1,%ecx
80104fd7:	89 f6                	mov    %esi,%esi
80104fd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if (p->pid == curproc->pid)
80104fe0:	39 78 10             	cmp    %edi,0x10(%eax)
80104fe3:	75 0b                	jne    80104ff0 <thread_create+0x60>
80104fe5:	8b 98 8c 00 00 00    	mov    0x8c(%eax),%ebx
80104feb:	39 d9                	cmp    %ebx,%ecx
80104fed:	0f 4c cb             	cmovl  %ebx,%ecx
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104ff0:	05 a0 01 00 00       	add    $0x1a0,%eax
80104ff5:	3d 74 c7 11 80       	cmp    $0x8011c774,%eax
80104ffa:	72 e4                	jb     80104fe0 <thread_create+0x50>
	      next_tid = p->tid;
      }
    }
  }
  next_tid++;
  release(&ptable.lock);
80104ffc:	83 ec 0c             	sub    $0xc,%esp
  next_tid++;
80104fff:	8d 41 01             	lea    0x1(%ecx),%eax
80105002:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  release(&ptable.lock);
80105005:	68 40 5f 11 80       	push   $0x80115f40
  next_tid++;
8010500a:	89 45 c8             	mov    %eax,-0x38(%ebp)
  release(&ptable.lock);
8010500d:	e8 ae 07 00 00       	call   801057c0 <release>

  // allocate thread
  if((np = allocproc()) == 0){
80105012:	e8 89 ed ff ff       	call   80103da0 <allocproc>
80105017:	83 c4 10             	add    $0x10,%esp
8010501a:	85 c0                	test   %eax,%eax
8010501c:	89 c3                	mov    %eax,%ebx
8010501e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
80105021:	0f 84 1e 02 00 00    	je     80105245 <thread_create+0x2b5>
    panic("alloc 실패\n");
    return -1;
  }
  np->pmlfq_node->pid = 0;
80105027:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
8010502d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  np->pmlfq_node->state = EMPTY;
80105034:	8b 83 84 00 00 00    	mov    0x84(%ebx),%eax
8010503a:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  np->pmlfq_node->eticks = 0;
80105040:	8b 83 84 00 00 00    	mov    0x84(%ebx),%eax
80105046:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

  // If there is empty space, reallocate the space into new user stack
  if(master_thread->stack_size > 0)
8010504d:	8b 82 9c 00 00 00    	mov    0x9c(%edx),%eax
80105053:	85 c0                	test   %eax,%eax
80105055:	0f 8e 8d 01 00 00    	jle    801051e8 <thread_create+0x258>
  {
    base = master_thread->stack[--(master_thread->stack_size)];
8010505b:	8d 48 ff             	lea    -0x1(%eax),%ecx
8010505e:	89 8a 9c 00 00 00    	mov    %ecx,0x9c(%edx)
80105064:	8b 84 82 9c 00 00 00 	mov    0x9c(%edx,%eax,4),%eax
8010506b:	8d b8 00 20 00 00    	lea    0x2000(%eax),%edi
80105071:	89 45 d0             	mov    %eax,-0x30(%ebp)
  {
    base = master_thread->sz;
    master_thread->sz += 2*PGSIZE;
  }

  if((sz = allocuvm(master_thread->pgdir, base, base + 2*PGSIZE)) == 0)
80105074:	83 ec 04             	sub    $0x4,%esp
80105077:	89 55 cc             	mov    %edx,-0x34(%ebp)
8010507a:	57                   	push   %edi
8010507b:	ff 75 d0             	pushl  -0x30(%ebp)
8010507e:	ff 72 04             	pushl  0x4(%edx)
80105081:	e8 3a 31 00 00       	call   801081c0 <allocuvm>
80105086:	83 c4 10             	add    $0x10,%esp
80105089:	85 c0                	test   %eax,%eax
8010508b:	89 45 d4             	mov    %eax,-0x2c(%ebp)
8010508e:	8b 55 cc             	mov    -0x34(%ebp),%edx
80105091:	0f 84 63 01 00 00    	je     801051fa <thread_create+0x26a>
  {
    np->state = UNUSED;
    return -1;
  }
  clearpteu(master_thread->pgdir, (char*)(sz - 2*PGSIZE));
80105097:	8b 45 d4             	mov    -0x2c(%ebp),%eax
8010509a:	83 ec 08             	sub    $0x8,%esp
8010509d:	89 55 c4             	mov    %edx,-0x3c(%ebp)
801050a0:	2d 00 20 00 00       	sub    $0x2000,%eax
801050a5:	50                   	push   %eax
801050a6:	ff 72 04             	pushl  0x4(%edx)
801050a9:	e8 92 33 00 00       	call   80108440 <clearpteu>
  // Make new stack
  sp = sz;

  ustack[0] = 0xffffffff;  // fake return PC
  ustack[1] = (uint)arg;
801050ae:	8b 45 10             	mov    0x10(%ebp),%eax

  sp -= 8;
  if(copyout(master_thread->pgdir, sp, ustack, 8) < 0)
801050b1:	6a 08                	push   $0x8
  ustack[0] = 0xffffffff;  // fake return PC
801050b3:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
  ustack[1] = (uint)arg;
801050ba:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  sp -= 8;
801050bd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
801050c0:	83 e8 08             	sub    $0x8,%eax
801050c3:	89 c2                	mov    %eax,%edx
801050c5:	89 45 cc             	mov    %eax,-0x34(%ebp)
  if(copyout(master_thread->pgdir, sp, ustack, 8) < 0)
801050c8:	8d 45 e0             	lea    -0x20(%ebp),%eax
801050cb:	50                   	push   %eax
801050cc:	52                   	push   %edx
801050cd:	8b 55 c4             	mov    -0x3c(%ebp),%edx
801050d0:	ff 72 04             	pushl  0x4(%edx)
801050d3:	e8 c8 34 00 00       	call   801085a0 <copyout>
801050d8:	83 c4 20             	add    $0x20,%esp
801050db:	85 c0                	test   %eax,%eax
801050dd:	8b 55 c4             	mov    -0x3c(%ebp),%edx
801050e0:	0f 88 22 01 00 00    	js     80105208 <thread_create+0x278>
    master_thread->stack[(master_thread->stack_size)++] = base;
    np->state = UNUSED;
    return -1;
  }

  for(int i = 0; i < NOFILE; i++)
801050e6:	89 75 c4             	mov    %esi,-0x3c(%ebp)
801050e9:	31 ff                	xor    %edi,%edi
801050eb:	89 d6                	mov    %edx,%esi
801050ed:	8d 76 00             	lea    0x0(%esi),%esi
    if(master_thread->ofile[i])
801050f0:	8b 44 be 28          	mov    0x28(%esi,%edi,4),%eax
801050f4:	85 c0                	test   %eax,%eax
801050f6:	74 10                	je     80105108 <thread_create+0x178>
      np->ofile[i] = filedup(master_thread->ofile[i]);
801050f8:	83 ec 0c             	sub    $0xc,%esp
801050fb:	50                   	push   %eax
801050fc:	e8 9f bd ff ff       	call   80100ea0 <filedup>
80105101:	83 c4 10             	add    $0x10,%esp
80105104:	89 44 bb 28          	mov    %eax,0x28(%ebx,%edi,4)
  for(int i = 0; i < NOFILE; i++)
80105108:	83 c7 01             	add    $0x1,%edi
8010510b:	83 ff 10             	cmp    $0x10,%edi
8010510e:	75 e0                	jne    801050f0 <thread_create+0x160>
80105110:	89 f2                	mov    %esi,%edx
  np->cwd = idup(master_thread->cwd);
80105112:	83 ec 0c             	sub    $0xc,%esp
80105115:	8b 75 c4             	mov    -0x3c(%ebp),%esi
80105118:	ff 72 68             	pushl  0x68(%edx)
8010511b:	89 55 c4             	mov    %edx,-0x3c(%ebp)
8010511e:	e8 7d c9 ff ff       	call   80101aa0 <idup>

  safestrcpy(np->name, master_thread->name, sizeof(master_thread->name)); // copy process name
80105123:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  np->cwd = idup(master_thread->cwd);
80105126:	89 43 68             	mov    %eax,0x68(%ebx)
  safestrcpy(np->name, master_thread->name, sizeof(master_thread->name)); // copy process name
80105129:	83 c4 0c             	add    $0xc,%esp
8010512c:	6a 10                	push   $0x10
8010512e:	8d 42 6c             	lea    0x6c(%edx),%eax
80105131:	50                   	push   %eax
80105132:	8d 43 6c             	lea    0x6c(%ebx),%eax
80105135:	50                   	push   %eax
80105136:	e8 b5 08 00 00       	call   801059f0 <safestrcpy>


  np->tid = next_tid; // set tid
8010513b:	8b 45 c8             	mov    -0x38(%ebp),%eax
  np->pid = curproc->pid; // set pid as same with master

  np->base = base;
  np->pgdir = master_thread->pgdir; // share page table with master thread
8010513e:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  np->sz = sz; // same memory size with master thread
  np->parent = curproc; // parent is current thread
  np->master = master_thread; // but master thread is same pid, tid == 1
  *np->tf = *master_thread->tf; // same trap frame for current syscall
80105141:	b9 13 00 00 00       	mov    $0x13,%ecx
80105146:	8b 7b 18             	mov    0x18(%ebx),%edi
  np->tid = next_tid; // set tid
80105149:	89 83 8c 00 00 00    	mov    %eax,0x8c(%ebx)
  np->pid = curproc->pid; // set pid as same with master
8010514f:	8b 46 10             	mov    0x10(%esi),%eax
80105152:	89 43 10             	mov    %eax,0x10(%ebx)
  np->base = base;
80105155:	8b 45 d0             	mov    -0x30(%ebp),%eax
80105158:	89 83 94 00 00 00    	mov    %eax,0x94(%ebx)
  np->pgdir = master_thread->pgdir; // share page table with master thread
8010515e:	8b 42 04             	mov    0x4(%edx),%eax
  np->master = master_thread; // but master thread is same pid, tid == 1
80105161:	89 93 90 00 00 00    	mov    %edx,0x90(%ebx)
  np->parent = curproc; // parent is current thread
80105167:	89 73 14             	mov    %esi,0x14(%ebx)
  np->pgdir = master_thread->pgdir; // share page table with master thread
8010516a:	89 43 04             	mov    %eax,0x4(%ebx)
  np->sz = sz; // same memory size with master thread
8010516d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80105170:	89 03                	mov    %eax,(%ebx)
  *np->tf = *master_thread->tf; // same trap frame for current syscall
80105172:	8b 72 18             	mov    0x18(%edx),%esi
80105175:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  np->pstride = master_thread->pstride;
  np->pmlfq_node = master_thread->pmlfq_node;

  // moving arg to function
  np->tf->eip = (uint)start_routine;
  np->tf->esp = (uint)sp; // top of stack
80105177:	8b 75 cc             	mov    -0x34(%ebp),%esi
  np->schedstate = master_thread->schedstate;
8010517a:	8b 42 7c             	mov    0x7c(%edx),%eax
8010517d:	89 43 7c             	mov    %eax,0x7c(%ebx)
  np->pstride = master_thread->pstride;
80105180:	8b 82 80 00 00 00    	mov    0x80(%edx),%eax
80105186:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
  np->pmlfq_node = master_thread->pmlfq_node;
8010518c:	8b 82 84 00 00 00    	mov    0x84(%edx),%eax
  np->tf->eip = (uint)start_routine;
80105192:	8b 55 0c             	mov    0xc(%ebp),%edx
  np->pmlfq_node = master_thread->pmlfq_node;
80105195:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
  np->tf->eip = (uint)start_routine;
8010519b:	8b 43 18             	mov    0x18(%ebx),%eax
8010519e:	89 50 38             	mov    %edx,0x38(%eax)
  np->tf->esp = (uint)sp; // top of stack
801051a1:	8b 43 18             	mov    0x18(%ebx),%eax
801051a4:	89 70 44             	mov    %esi,0x44(%eax)
  np->tf->eax = 0;
801051a7:	8b 43 18             	mov    0x18(%ebx),%eax
801051aa:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
 
  *thread = np->tid;
801051b1:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
801051b7:	8b 45 08             	mov    0x8(%ebp),%eax
801051ba:	89 10                	mov    %edx,(%eax)

  // change state
  acquire(&ptable.lock);
801051bc:	c7 04 24 40 5f 11 80 	movl   $0x80115f40,(%esp)
801051c3:	e8 38 05 00 00       	call   80105700 <acquire>
  np->state = RUNNABLE;
801051c8:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
801051cf:	c7 04 24 40 5f 11 80 	movl   $0x80115f40,(%esp)
801051d6:	e8 e5 05 00 00       	call   801057c0 <release>

  return 0;
801051db:	83 c4 10             	add    $0x10,%esp
801051de:	31 c0                	xor    %eax,%eax
}
801051e0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801051e3:	5b                   	pop    %ebx
801051e4:	5e                   	pop    %esi
801051e5:	5f                   	pop    %edi
801051e6:	5d                   	pop    %ebp
801051e7:	c3                   	ret    
    base = master_thread->sz;
801051e8:	8b 02                	mov    (%edx),%eax
    master_thread->sz += 2*PGSIZE;
801051ea:	8d b8 00 20 00 00    	lea    0x2000(%eax),%edi
    base = master_thread->sz;
801051f0:	89 45 d0             	mov    %eax,-0x30(%ebp)
    master_thread->sz += 2*PGSIZE;
801051f3:	89 3a                	mov    %edi,(%edx)
801051f5:	e9 7a fe ff ff       	jmp    80105074 <thread_create+0xe4>
    np->state = UNUSED;
801051fa:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80105201:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105206:	eb d8                	jmp    801051e0 <thread_create+0x250>
    deallocuvm(master_thread->pgdir, base+2*PGSIZE, base);
80105208:	8b 75 d0             	mov    -0x30(%ebp),%esi
8010520b:	83 ec 04             	sub    $0x4,%esp
8010520e:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80105211:	56                   	push   %esi
80105212:	57                   	push   %edi
80105213:	ff 72 04             	pushl  0x4(%edx)
80105216:	e8 d5 30 00 00       	call   801082f0 <deallocuvm>
    master_thread->stack[(master_thread->stack_size)++] = base;
8010521b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
    return -1;
8010521e:	83 c4 10             	add    $0x10,%esp
    master_thread->stack[(master_thread->stack_size)++] = base;
80105221:	8b 82 9c 00 00 00    	mov    0x9c(%edx),%eax
80105227:	8d 48 01             	lea    0x1(%eax),%ecx
8010522a:	89 8a 9c 00 00 00    	mov    %ecx,0x9c(%edx)
80105230:	89 b4 82 a0 00 00 00 	mov    %esi,0xa0(%edx,%eax,4)
    return -1;
80105237:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    np->state = UNUSED;
8010523c:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80105243:	eb 9b                	jmp    801051e0 <thread_create+0x250>
    panic("alloc 실패\n");
80105245:	83 ec 0c             	sub    $0xc,%esp
80105248:	68 57 96 10 80       	push   $0x80109657
8010524d:	e8 3e b1 ff ff       	call   80100390 <panic>
80105252:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105259:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105260 <thread_exit>:

// Exit thread
void
thread_exit(void *retval)
{
80105260:	55                   	push   %ebp
80105261:	89 e5                	mov    %esp,%ebp
80105263:	57                   	push   %edi
80105264:	56                   	push   %esi
80105265:	53                   	push   %ebx
80105266:	83 ec 0c             	sub    $0xc,%esp
  pushcli();
80105269:	e8 c2 03 00 00       	call   80105630 <pushcli>
  c = mycpu();
8010526e:	e8 9d ef ff ff       	call   80104210 <mycpu>
  p = c->proc;
80105273:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80105279:	e8 f2 03 00 00       	call   80105670 <popcli>
8010527e:	8d 73 28             	lea    0x28(%ebx),%esi
80105281:	8d 7b 68             	lea    0x68(%ebx),%edi
80105284:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  struct proc *curproc = myproc();
  int fd;

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd]){
80105288:	8b 06                	mov    (%esi),%eax
8010528a:	85 c0                	test   %eax,%eax
8010528c:	74 12                	je     801052a0 <thread_exit+0x40>
      fileclose(curproc->ofile[fd]);
8010528e:	83 ec 0c             	sub    $0xc,%esp
80105291:	50                   	push   %eax
80105292:	e8 59 bc ff ff       	call   80100ef0 <fileclose>
      curproc->ofile[fd] = 0;
80105297:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
8010529d:	83 c4 10             	add    $0x10,%esp
801052a0:	83 c6 04             	add    $0x4,%esi
  for(fd = 0; fd < NOFILE; fd++){
801052a3:	39 fe                	cmp    %edi,%esi
801052a5:	75 e1                	jne    80105288 <thread_exit+0x28>
    }
  }

  begin_op();
801052a7:	e8 c4 df ff ff       	call   80103270 <begin_op>
  iput(curproc->cwd);
801052ac:	83 ec 0c             	sub    $0xc,%esp
801052af:	ff 73 68             	pushl  0x68(%ebx)
801052b2:	e8 49 c9 ff ff       	call   80101c00 <iput>
  end_op();
801052b7:	e8 64 e0 ff ff       	call   80103320 <end_op>
  curproc->cwd = 0;
801052bc:	c7 43 68 00 00 00 00 	movl   $0x0,0x68(%ebx)

  acquire(&ptable.lock);
801052c3:	c7 04 24 40 5f 11 80 	movl   $0x80115f40,(%esp)
801052ca:	e8 31 04 00 00       	call   80105700 <acquire>
  
  // Save retval temporarily
  curproc->retVal = retval;
801052cf:	8b 45 08             	mov    0x8(%ebp),%eax

  // Master process might be sleeping in wait().
  wakeup1(curproc->master);
801052d2:	8b 93 90 00 00 00    	mov    0x90(%ebx),%edx
801052d8:	83 c4 10             	add    $0x10,%esp
  curproc->retVal = retval;
801052db:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801052e1:	b8 74 5f 11 80       	mov    $0x80115f74,%eax
801052e6:	eb 14                	jmp    801052fc <thread_exit+0x9c>
801052e8:	90                   	nop
801052e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801052f0:	05 a0 01 00 00       	add    $0x1a0,%eax
801052f5:	3d 74 c7 11 80       	cmp    $0x8011c774,%eax
801052fa:	73 1e                	jae    8010531a <thread_exit+0xba>
    if(p->state == SLEEPING && p->chan == chan)
801052fc:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80105300:	75 ee                	jne    801052f0 <thread_exit+0x90>
80105302:	3b 50 20             	cmp    0x20(%eax),%edx
80105305:	75 e9                	jne    801052f0 <thread_exit+0x90>
      p->state = RUNNABLE;
80105307:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010530e:	05 a0 01 00 00       	add    $0x1a0,%eax
80105313:	3d 74 c7 11 80       	cmp    $0x8011c774,%eax
80105318:	72 e2                	jb     801052fc <thread_exit+0x9c>

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->parent == curproc || p->master == curproc){
      p->parent = initproc;
8010531a:	8b 0d b8 c5 10 80    	mov    0x8010c5b8,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80105320:	ba 74 5f 11 80       	mov    $0x80115f74,%edx
80105325:	eb 1f                	jmp    80105346 <thread_exit+0xe6>
80105327:	89 f6                	mov    %esi,%esi
80105329:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(p->parent == curproc || p->master == curproc){
80105330:	39 9a 90 00 00 00    	cmp    %ebx,0x90(%edx)
80105336:	74 13                	je     8010534b <thread_exit+0xeb>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80105338:	81 c2 a0 01 00 00    	add    $0x1a0,%edx
8010533e:	81 fa 74 c7 11 80    	cmp    $0x8011c774,%edx
80105344:	73 3a                	jae    80105380 <thread_exit+0x120>
    if(p->parent == curproc || p->master == curproc){
80105346:	39 5a 14             	cmp    %ebx,0x14(%edx)
80105349:	75 e5                	jne    80105330 <thread_exit+0xd0>
      if(p->state == ZOMBIE)
8010534b:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
8010534f:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
80105352:	75 e4                	jne    80105338 <thread_exit+0xd8>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80105354:	b8 74 5f 11 80       	mov    $0x80115f74,%eax
80105359:	eb 11                	jmp    8010536c <thread_exit+0x10c>
8010535b:	90                   	nop
8010535c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105360:	05 a0 01 00 00       	add    $0x1a0,%eax
80105365:	3d 74 c7 11 80       	cmp    $0x8011c774,%eax
8010536a:	73 cc                	jae    80105338 <thread_exit+0xd8>
    if(p->state == SLEEPING && p->chan == chan)
8010536c:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80105370:	75 ee                	jne    80105360 <thread_exit+0x100>
80105372:	3b 48 20             	cmp    0x20(%eax),%ecx
80105375:	75 e9                	jne    80105360 <thread_exit+0x100>
      p->state = RUNNABLE;
80105377:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
8010537e:	eb e0                	jmp    80105360 <thread_exit+0x100>
        wakeup1(initproc);
    }
  }

  // Jump into the scheduler, never to return.
  curproc->state = ZOMBIE;
80105380:	c7 43 0c 05 00 00 00 	movl   $0x5,0xc(%ebx)
  sched();
80105387:	e8 c4 f2 ff ff       	call   80104650 <sched>
  panic("zombie exit");
8010538c:	83 ec 0c             	sub    $0xc,%esp
8010538f:	68 10 96 10 80       	push   $0x80109610
80105394:	e8 f7 af ff ff       	call   80100390 <panic>
80105399:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801053a0 <thread_join>:
}

// Wait until the thread is finished
int
thread_join(thread_t thread, void **retval)
{
801053a0:	55                   	push   %ebp
801053a1:	89 e5                	mov    %esp,%ebp
801053a3:	56                   	push   %esi
801053a4:	53                   	push   %ebx
801053a5:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
801053a8:	e8 83 02 00 00       	call   80105630 <pushcli>
  c = mycpu();
801053ad:	e8 5e ee ff ff       	call   80104210 <mycpu>
  p = c->proc;
801053b2:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801053b8:	e8 b3 02 00 00       	call   80105670 <popcli>
  struct proc *p;
  struct proc *curproc = myproc();
  int kids;

  if(curproc->tid != 1){
801053bd:	83 bb 8c 00 00 00 01 	cmpl   $0x1,0x8c(%ebx)
801053c4:	0f 85 9c 00 00 00    	jne    80105466 <thread_join+0xc6>
    return -1;
  }

  acquire(&ptable.lock);
801053ca:	83 ec 0c             	sub    $0xc,%esp
801053cd:	68 40 5f 11 80       	push   $0x80115f40
801053d2:	e8 29 03 00 00       	call   80105700 <acquire>
801053d7:	83 c4 10             	add    $0x10,%esp
  for(;;){
    kids = 0;
    // Scan through table looking for exited slave threads.
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if(p->pid != curproc->pid|| p->tid != thread)
801053da:	8b 53 10             	mov    0x10(%ebx),%edx
    kids = 0;
801053dd:	31 c9                	xor    %ecx,%ecx
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801053df:	b8 74 5f 11 80       	mov    $0x80115f74,%eax
801053e4:	eb 1b                	jmp    80105401 <thread_join+0x61>
801053e6:	8d 76 00             	lea    0x0(%esi),%esi
801053e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
        continue;

      kids = 1;
801053f0:	b9 01 00 00 00       	mov    $0x1,%ecx
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801053f5:	05 a0 01 00 00       	add    $0x1a0,%eax
801053fa:	3d 74 c7 11 80       	cmp    $0x8011c774,%eax
801053ff:	73 3f                	jae    80105440 <thread_join+0xa0>
      if(p->pid != curproc->pid|| p->tid != thread)
80105401:	39 50 10             	cmp    %edx,0x10(%eax)
80105404:	75 ef                	jne    801053f5 <thread_join+0x55>
80105406:	39 b0 8c 00 00 00    	cmp    %esi,0x8c(%eax)
8010540c:	75 e7                	jne    801053f5 <thread_join+0x55>

      if(p->state == ZOMBIE){
8010540e:	83 78 0c 05          	cmpl   $0x5,0xc(%eax)
80105412:	75 dc                	jne    801053f0 <thread_join+0x50>
        *retval = p->retVal;
80105414:	8b 88 88 00 00 00    	mov    0x88(%eax),%ecx
8010541a:	8b 55 0c             	mov    0xc(%ebp),%edx
        delete_thread(p);
8010541d:	83 ec 0c             	sub    $0xc,%esp
        *retval = p->retVal;
80105420:	89 0a                	mov    %ecx,(%edx)
        delete_thread(p);
80105422:	50                   	push   %eax
80105423:	e8 c8 eb ff ff       	call   80103ff0 <delete_thread>
        release(&ptable.lock);
80105428:	c7 04 24 40 5f 11 80 	movl   $0x80115f40,(%esp)
8010542f:	e8 8c 03 00 00       	call   801057c0 <release>
        return 0;
80105434:	83 c4 10             	add    $0x10,%esp
80105437:	31 c0                	xor    %eax,%eax
      release(&ptable.lock);
      return -1;
    }
    sleep(curproc->master, &ptable.lock);
  }
}
80105439:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010543c:	5b                   	pop    %ebx
8010543d:	5e                   	pop    %esi
8010543e:	5d                   	pop    %ebp
8010543f:	c3                   	ret    
    if(!kids || curproc->killed){
80105440:	85 c9                	test   %ecx,%ecx
80105442:	74 29                	je     8010546d <thread_join+0xcd>
80105444:	8b 43 24             	mov    0x24(%ebx),%eax
80105447:	85 c0                	test   %eax,%eax
80105449:	75 22                	jne    8010546d <thread_join+0xcd>
    sleep(curproc->master, &ptable.lock);
8010544b:	83 ec 08             	sub    $0x8,%esp
8010544e:	68 40 5f 11 80       	push   $0x80115f40
80105453:	ff b3 90 00 00 00    	pushl  0x90(%ebx)
80105459:	e8 42 f4 ff ff       	call   801048a0 <sleep>
    kids = 0;
8010545e:	83 c4 10             	add    $0x10,%esp
80105461:	e9 74 ff ff ff       	jmp    801053da <thread_join+0x3a>
    return -1;
80105466:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010546b:	eb cc                	jmp    80105439 <thread_join+0x99>
      release(&ptable.lock);
8010546d:	83 ec 0c             	sub    $0xc,%esp
80105470:	68 40 5f 11 80       	push   $0x80115f40
80105475:	e8 46 03 00 00       	call   801057c0 <release>
      return -1;
8010547a:	83 c4 10             	add    $0x10,%esp
8010547d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105482:	eb b5                	jmp    80105439 <thread_join+0x99>
80105484:	66 90                	xchg   %ax,%ax
80105486:	66 90                	xchg   %ax,%ax
80105488:	66 90                	xchg   %ax,%ax
8010548a:	66 90                	xchg   %ax,%ax
8010548c:	66 90                	xchg   %ax,%ax
8010548e:	66 90                	xchg   %ax,%ax

80105490 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80105490:	55                   	push   %ebp
80105491:	89 e5                	mov    %esp,%ebp
80105493:	53                   	push   %ebx
80105494:	83 ec 0c             	sub    $0xc,%esp
80105497:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
8010549a:	68 0c 97 10 80       	push   $0x8010970c
8010549f:	8d 43 04             	lea    0x4(%ebx),%eax
801054a2:	50                   	push   %eax
801054a3:	e8 18 01 00 00       	call   801055c0 <initlock>
  lk->name = name;
801054a8:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
801054ab:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
801054b1:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
801054b4:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
801054bb:	89 43 38             	mov    %eax,0x38(%ebx)
}
801054be:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801054c1:	c9                   	leave  
801054c2:	c3                   	ret    
801054c3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801054c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801054d0 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
801054d0:	55                   	push   %ebp
801054d1:	89 e5                	mov    %esp,%ebp
801054d3:	56                   	push   %esi
801054d4:	53                   	push   %ebx
801054d5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
801054d8:	83 ec 0c             	sub    $0xc,%esp
801054db:	8d 73 04             	lea    0x4(%ebx),%esi
801054de:	56                   	push   %esi
801054df:	e8 1c 02 00 00       	call   80105700 <acquire>
  while (lk->locked) {
801054e4:	8b 13                	mov    (%ebx),%edx
801054e6:	83 c4 10             	add    $0x10,%esp
801054e9:	85 d2                	test   %edx,%edx
801054eb:	74 16                	je     80105503 <acquiresleep+0x33>
801054ed:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
801054f0:	83 ec 08             	sub    $0x8,%esp
801054f3:	56                   	push   %esi
801054f4:	53                   	push   %ebx
801054f5:	e8 a6 f3 ff ff       	call   801048a0 <sleep>
  while (lk->locked) {
801054fa:	8b 03                	mov    (%ebx),%eax
801054fc:	83 c4 10             	add    $0x10,%esp
801054ff:	85 c0                	test   %eax,%eax
80105501:	75 ed                	jne    801054f0 <acquiresleep+0x20>
  }
  lk->locked = 1;
80105503:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80105509:	e8 a2 ed ff ff       	call   801042b0 <myproc>
8010550e:	8b 40 10             	mov    0x10(%eax),%eax
80105511:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80105514:	89 75 08             	mov    %esi,0x8(%ebp)
}
80105517:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010551a:	5b                   	pop    %ebx
8010551b:	5e                   	pop    %esi
8010551c:	5d                   	pop    %ebp
  release(&lk->lk);
8010551d:	e9 9e 02 00 00       	jmp    801057c0 <release>
80105522:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105529:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105530 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80105530:	55                   	push   %ebp
80105531:	89 e5                	mov    %esp,%ebp
80105533:	56                   	push   %esi
80105534:	53                   	push   %ebx
80105535:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80105538:	83 ec 0c             	sub    $0xc,%esp
8010553b:	8d 73 04             	lea    0x4(%ebx),%esi
8010553e:	56                   	push   %esi
8010553f:	e8 bc 01 00 00       	call   80105700 <acquire>
  lk->locked = 0;
80105544:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
8010554a:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80105551:	89 1c 24             	mov    %ebx,(%esp)
80105554:	e8 97 f7 ff ff       	call   80104cf0 <wakeup>
  release(&lk->lk);
80105559:	89 75 08             	mov    %esi,0x8(%ebp)
8010555c:	83 c4 10             	add    $0x10,%esp
}
8010555f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105562:	5b                   	pop    %ebx
80105563:	5e                   	pop    %esi
80105564:	5d                   	pop    %ebp
  release(&lk->lk);
80105565:	e9 56 02 00 00       	jmp    801057c0 <release>
8010556a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105570 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80105570:	55                   	push   %ebp
80105571:	89 e5                	mov    %esp,%ebp
80105573:	57                   	push   %edi
80105574:	56                   	push   %esi
80105575:	53                   	push   %ebx
80105576:	31 ff                	xor    %edi,%edi
80105578:	83 ec 18             	sub    $0x18,%esp
8010557b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
8010557e:	8d 73 04             	lea    0x4(%ebx),%esi
80105581:	56                   	push   %esi
80105582:	e8 79 01 00 00       	call   80105700 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
80105587:	8b 03                	mov    (%ebx),%eax
80105589:	83 c4 10             	add    $0x10,%esp
8010558c:	85 c0                	test   %eax,%eax
8010558e:	74 13                	je     801055a3 <holdingsleep+0x33>
80105590:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
80105593:	e8 18 ed ff ff       	call   801042b0 <myproc>
80105598:	39 58 10             	cmp    %ebx,0x10(%eax)
8010559b:	0f 94 c0             	sete   %al
8010559e:	0f b6 c0             	movzbl %al,%eax
801055a1:	89 c7                	mov    %eax,%edi
  release(&lk->lk);
801055a3:	83 ec 0c             	sub    $0xc,%esp
801055a6:	56                   	push   %esi
801055a7:	e8 14 02 00 00       	call   801057c0 <release>
  return r;
}
801055ac:	8d 65 f4             	lea    -0xc(%ebp),%esp
801055af:	89 f8                	mov    %edi,%eax
801055b1:	5b                   	pop    %ebx
801055b2:	5e                   	pop    %esi
801055b3:	5f                   	pop    %edi
801055b4:	5d                   	pop    %ebp
801055b5:	c3                   	ret    
801055b6:	66 90                	xchg   %ax,%ax
801055b8:	66 90                	xchg   %ax,%ax
801055ba:	66 90                	xchg   %ax,%ax
801055bc:	66 90                	xchg   %ax,%ax
801055be:	66 90                	xchg   %ax,%ax

801055c0 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
801055c0:	55                   	push   %ebp
801055c1:	89 e5                	mov    %esp,%ebp
801055c3:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
801055c6:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
801055c9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
801055cf:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
801055d2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
801055d9:	5d                   	pop    %ebp
801055da:	c3                   	ret    
801055db:	90                   	nop
801055dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801055e0 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
801055e0:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
801055e1:	31 d2                	xor    %edx,%edx
{
801055e3:	89 e5                	mov    %esp,%ebp
801055e5:	53                   	push   %ebx
  ebp = (uint*)v - 2;
801055e6:	8b 45 08             	mov    0x8(%ebp),%eax
{
801055e9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
801055ec:	83 e8 08             	sub    $0x8,%eax
801055ef:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801055f0:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
801055f6:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
801055fc:	77 1a                	ja     80105618 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
801055fe:	8b 58 04             	mov    0x4(%eax),%ebx
80105601:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
80105604:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80105607:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80105609:	83 fa 0a             	cmp    $0xa,%edx
8010560c:	75 e2                	jne    801055f0 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
8010560e:	5b                   	pop    %ebx
8010560f:	5d                   	pop    %ebp
80105610:	c3                   	ret    
80105611:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105618:	8d 04 91             	lea    (%ecx,%edx,4),%eax
8010561b:	83 c1 28             	add    $0x28,%ecx
8010561e:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80105620:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80105626:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
80105629:	39 c1                	cmp    %eax,%ecx
8010562b:	75 f3                	jne    80105620 <getcallerpcs+0x40>
}
8010562d:	5b                   	pop    %ebx
8010562e:	5d                   	pop    %ebp
8010562f:	c3                   	ret    

80105630 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80105630:	55                   	push   %ebp
80105631:	89 e5                	mov    %esp,%ebp
80105633:	53                   	push   %ebx
80105634:	83 ec 04             	sub    $0x4,%esp
80105637:	9c                   	pushf  
80105638:	5b                   	pop    %ebx
  asm volatile("cli");
80105639:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
8010563a:	e8 d1 eb ff ff       	call   80104210 <mycpu>
8010563f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80105645:	85 c0                	test   %eax,%eax
80105647:	75 11                	jne    8010565a <pushcli+0x2a>
    mycpu()->intena = eflags & FL_IF;
80105649:	81 e3 00 02 00 00    	and    $0x200,%ebx
8010564f:	e8 bc eb ff ff       	call   80104210 <mycpu>
80105654:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
  mycpu()->ncli += 1;
8010565a:	e8 b1 eb ff ff       	call   80104210 <mycpu>
8010565f:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80105666:	83 c4 04             	add    $0x4,%esp
80105669:	5b                   	pop    %ebx
8010566a:	5d                   	pop    %ebp
8010566b:	c3                   	ret    
8010566c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105670 <popcli>:

void
popcli(void)
{
80105670:	55                   	push   %ebp
80105671:	89 e5                	mov    %esp,%ebp
80105673:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80105676:	9c                   	pushf  
80105677:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80105678:	f6 c4 02             	test   $0x2,%ah
8010567b:	75 35                	jne    801056b2 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
8010567d:	e8 8e eb ff ff       	call   80104210 <mycpu>
80105682:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
80105689:	78 34                	js     801056bf <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
8010568b:	e8 80 eb ff ff       	call   80104210 <mycpu>
80105690:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80105696:	85 d2                	test   %edx,%edx
80105698:	74 06                	je     801056a0 <popcli+0x30>
    sti();
}
8010569a:	c9                   	leave  
8010569b:	c3                   	ret    
8010569c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
801056a0:	e8 6b eb ff ff       	call   80104210 <mycpu>
801056a5:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
801056ab:	85 c0                	test   %eax,%eax
801056ad:	74 eb                	je     8010569a <popcli+0x2a>
  asm volatile("sti");
801056af:	fb                   	sti    
}
801056b0:	c9                   	leave  
801056b1:	c3                   	ret    
    panic("popcli - interruptible");
801056b2:	83 ec 0c             	sub    $0xc,%esp
801056b5:	68 17 97 10 80       	push   $0x80109717
801056ba:	e8 d1 ac ff ff       	call   80100390 <panic>
    panic("popcli");
801056bf:	83 ec 0c             	sub    $0xc,%esp
801056c2:	68 2e 97 10 80       	push   $0x8010972e
801056c7:	e8 c4 ac ff ff       	call   80100390 <panic>
801056cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801056d0 <holding>:
{
801056d0:	55                   	push   %ebp
801056d1:	89 e5                	mov    %esp,%ebp
801056d3:	56                   	push   %esi
801056d4:	53                   	push   %ebx
801056d5:	8b 75 08             	mov    0x8(%ebp),%esi
801056d8:	31 db                	xor    %ebx,%ebx
  pushcli();
801056da:	e8 51 ff ff ff       	call   80105630 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
801056df:	8b 06                	mov    (%esi),%eax
801056e1:	85 c0                	test   %eax,%eax
801056e3:	74 10                	je     801056f5 <holding+0x25>
801056e5:	8b 5e 08             	mov    0x8(%esi),%ebx
801056e8:	e8 23 eb ff ff       	call   80104210 <mycpu>
801056ed:	39 c3                	cmp    %eax,%ebx
801056ef:	0f 94 c3             	sete   %bl
801056f2:	0f b6 db             	movzbl %bl,%ebx
  popcli();
801056f5:	e8 76 ff ff ff       	call   80105670 <popcli>
}
801056fa:	89 d8                	mov    %ebx,%eax
801056fc:	5b                   	pop    %ebx
801056fd:	5e                   	pop    %esi
801056fe:	5d                   	pop    %ebp
801056ff:	c3                   	ret    

80105700 <acquire>:
{
80105700:	55                   	push   %ebp
80105701:	89 e5                	mov    %esp,%ebp
80105703:	56                   	push   %esi
80105704:	53                   	push   %ebx
  pushcli(); // disable interrupts to avoid deadlock.
80105705:	e8 26 ff ff ff       	call   80105630 <pushcli>
  if(holding(lk))
8010570a:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010570d:	83 ec 0c             	sub    $0xc,%esp
80105710:	53                   	push   %ebx
80105711:	e8 ba ff ff ff       	call   801056d0 <holding>
80105716:	83 c4 10             	add    $0x10,%esp
80105719:	85 c0                	test   %eax,%eax
8010571b:	0f 85 83 00 00 00    	jne    801057a4 <acquire+0xa4>
80105721:	89 c6                	mov    %eax,%esi
  asm volatile("lock; xchgl %0, %1" :
80105723:	ba 01 00 00 00       	mov    $0x1,%edx
80105728:	eb 09                	jmp    80105733 <acquire+0x33>
8010572a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105730:	8b 5d 08             	mov    0x8(%ebp),%ebx
80105733:	89 d0                	mov    %edx,%eax
80105735:	f0 87 03             	lock xchg %eax,(%ebx)
  while(xchg(&lk->locked, 1) != 0)
80105738:	85 c0                	test   %eax,%eax
8010573a:	75 f4                	jne    80105730 <acquire+0x30>
  __sync_synchronize();
8010573c:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80105741:	8b 5d 08             	mov    0x8(%ebp),%ebx
80105744:	e8 c7 ea ff ff       	call   80104210 <mycpu>
  getcallerpcs(&lk, lk->pcs);
80105749:	8d 53 0c             	lea    0xc(%ebx),%edx
  lk->cpu = mycpu();
8010574c:	89 43 08             	mov    %eax,0x8(%ebx)
  ebp = (uint*)v - 2;
8010574f:	89 e8                	mov    %ebp,%eax
80105751:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80105758:	8d 88 00 00 00 80    	lea    -0x80000000(%eax),%ecx
8010575e:	81 f9 fe ff ff 7f    	cmp    $0x7ffffffe,%ecx
80105764:	77 1a                	ja     80105780 <acquire+0x80>
    pcs[i] = ebp[1];     // saved %eip
80105766:	8b 48 04             	mov    0x4(%eax),%ecx
80105769:	89 0c b2             	mov    %ecx,(%edx,%esi,4)
  for(i = 0; i < 10; i++){
8010576c:	83 c6 01             	add    $0x1,%esi
    ebp = (uint*)ebp[0]; // saved %ebp
8010576f:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80105771:	83 fe 0a             	cmp    $0xa,%esi
80105774:	75 e2                	jne    80105758 <acquire+0x58>
}
80105776:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105779:	5b                   	pop    %ebx
8010577a:	5e                   	pop    %esi
8010577b:	5d                   	pop    %ebp
8010577c:	c3                   	ret    
8010577d:	8d 76 00             	lea    0x0(%esi),%esi
80105780:	8d 04 b2             	lea    (%edx,%esi,4),%eax
80105783:	83 c2 28             	add    $0x28,%edx
80105786:	8d 76 00             	lea    0x0(%esi),%esi
80105789:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    pcs[i] = 0;
80105790:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80105796:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
80105799:	39 d0                	cmp    %edx,%eax
8010579b:	75 f3                	jne    80105790 <acquire+0x90>
}
8010579d:	8d 65 f8             	lea    -0x8(%ebp),%esp
801057a0:	5b                   	pop    %ebx
801057a1:	5e                   	pop    %esi
801057a2:	5d                   	pop    %ebp
801057a3:	c3                   	ret    
    panic("acquire");
801057a4:	83 ec 0c             	sub    $0xc,%esp
801057a7:	68 35 97 10 80       	push   $0x80109735
801057ac:	e8 df ab ff ff       	call   80100390 <panic>
801057b1:	eb 0d                	jmp    801057c0 <release>
801057b3:	90                   	nop
801057b4:	90                   	nop
801057b5:	90                   	nop
801057b6:	90                   	nop
801057b7:	90                   	nop
801057b8:	90                   	nop
801057b9:	90                   	nop
801057ba:	90                   	nop
801057bb:	90                   	nop
801057bc:	90                   	nop
801057bd:	90                   	nop
801057be:	90                   	nop
801057bf:	90                   	nop

801057c0 <release>:
{
801057c0:	55                   	push   %ebp
801057c1:	89 e5                	mov    %esp,%ebp
801057c3:	53                   	push   %ebx
801057c4:	83 ec 10             	sub    $0x10,%esp
801057c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lk))
801057ca:	53                   	push   %ebx
801057cb:	e8 00 ff ff ff       	call   801056d0 <holding>
801057d0:	83 c4 10             	add    $0x10,%esp
801057d3:	85 c0                	test   %eax,%eax
801057d5:	74 22                	je     801057f9 <release+0x39>
  lk->pcs[0] = 0;
801057d7:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
801057de:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
801057e5:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
801057ea:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
801057f0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801057f3:	c9                   	leave  
  popcli();
801057f4:	e9 77 fe ff ff       	jmp    80105670 <popcli>
    panic("release");
801057f9:	83 ec 0c             	sub    $0xc,%esp
801057fc:	68 3d 97 10 80       	push   $0x8010973d
80105801:	e8 8a ab ff ff       	call   80100390 <panic>
80105806:	66 90                	xchg   %ax,%ax
80105808:	66 90                	xchg   %ax,%ax
8010580a:	66 90                	xchg   %ax,%ax
8010580c:	66 90                	xchg   %ax,%ax
8010580e:	66 90                	xchg   %ax,%ax

80105810 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80105810:	55                   	push   %ebp
80105811:	89 e5                	mov    %esp,%ebp
80105813:	57                   	push   %edi
80105814:	53                   	push   %ebx
80105815:	8b 55 08             	mov    0x8(%ebp),%edx
80105818:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if ((int)dst%4 == 0 && n%4 == 0){
8010581b:	f6 c2 03             	test   $0x3,%dl
8010581e:	75 05                	jne    80105825 <memset+0x15>
80105820:	f6 c1 03             	test   $0x3,%cl
80105823:	74 13                	je     80105838 <memset+0x28>
  asm volatile("cld; rep stosb" :
80105825:	89 d7                	mov    %edx,%edi
80105827:	8b 45 0c             	mov    0xc(%ebp),%eax
8010582a:	fc                   	cld    
8010582b:	f3 aa                	rep stos %al,%es:(%edi)
    c &= 0xFF;
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
8010582d:	5b                   	pop    %ebx
8010582e:	89 d0                	mov    %edx,%eax
80105830:	5f                   	pop    %edi
80105831:	5d                   	pop    %ebp
80105832:	c3                   	ret    
80105833:	90                   	nop
80105834:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c &= 0xFF;
80105838:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
8010583c:	c1 e9 02             	shr    $0x2,%ecx
8010583f:	89 f8                	mov    %edi,%eax
80105841:	89 fb                	mov    %edi,%ebx
80105843:	c1 e0 18             	shl    $0x18,%eax
80105846:	c1 e3 10             	shl    $0x10,%ebx
80105849:	09 d8                	or     %ebx,%eax
8010584b:	09 f8                	or     %edi,%eax
8010584d:	c1 e7 08             	shl    $0x8,%edi
80105850:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
80105852:	89 d7                	mov    %edx,%edi
80105854:	fc                   	cld    
80105855:	f3 ab                	rep stos %eax,%es:(%edi)
}
80105857:	5b                   	pop    %ebx
80105858:	89 d0                	mov    %edx,%eax
8010585a:	5f                   	pop    %edi
8010585b:	5d                   	pop    %ebp
8010585c:	c3                   	ret    
8010585d:	8d 76 00             	lea    0x0(%esi),%esi

80105860 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80105860:	55                   	push   %ebp
80105861:	89 e5                	mov    %esp,%ebp
80105863:	57                   	push   %edi
80105864:	56                   	push   %esi
80105865:	53                   	push   %ebx
80105866:	8b 5d 10             	mov    0x10(%ebp),%ebx
80105869:	8b 75 08             	mov    0x8(%ebp),%esi
8010586c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
8010586f:	85 db                	test   %ebx,%ebx
80105871:	74 29                	je     8010589c <memcmp+0x3c>
    if(*s1 != *s2)
80105873:	0f b6 16             	movzbl (%esi),%edx
80105876:	0f b6 0f             	movzbl (%edi),%ecx
80105879:	38 d1                	cmp    %dl,%cl
8010587b:	75 2b                	jne    801058a8 <memcmp+0x48>
8010587d:	b8 01 00 00 00       	mov    $0x1,%eax
80105882:	eb 14                	jmp    80105898 <memcmp+0x38>
80105884:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105888:	0f b6 14 06          	movzbl (%esi,%eax,1),%edx
8010588c:	83 c0 01             	add    $0x1,%eax
8010588f:	0f b6 4c 07 ff       	movzbl -0x1(%edi,%eax,1),%ecx
80105894:	38 ca                	cmp    %cl,%dl
80105896:	75 10                	jne    801058a8 <memcmp+0x48>
  while(n-- > 0){
80105898:	39 d8                	cmp    %ebx,%eax
8010589a:	75 ec                	jne    80105888 <memcmp+0x28>
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
}
8010589c:	5b                   	pop    %ebx
  return 0;
8010589d:	31 c0                	xor    %eax,%eax
}
8010589f:	5e                   	pop    %esi
801058a0:	5f                   	pop    %edi
801058a1:	5d                   	pop    %ebp
801058a2:	c3                   	ret    
801058a3:	90                   	nop
801058a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return *s1 - *s2;
801058a8:	0f b6 c2             	movzbl %dl,%eax
}
801058ab:	5b                   	pop    %ebx
      return *s1 - *s2;
801058ac:	29 c8                	sub    %ecx,%eax
}
801058ae:	5e                   	pop    %esi
801058af:	5f                   	pop    %edi
801058b0:	5d                   	pop    %ebp
801058b1:	c3                   	ret    
801058b2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801058b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801058c0 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
801058c0:	55                   	push   %ebp
801058c1:	89 e5                	mov    %esp,%ebp
801058c3:	56                   	push   %esi
801058c4:	53                   	push   %ebx
801058c5:	8b 45 08             	mov    0x8(%ebp),%eax
801058c8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
801058cb:	8b 75 10             	mov    0x10(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
801058ce:	39 c3                	cmp    %eax,%ebx
801058d0:	73 26                	jae    801058f8 <memmove+0x38>
801058d2:	8d 0c 33             	lea    (%ebx,%esi,1),%ecx
801058d5:	39 c8                	cmp    %ecx,%eax
801058d7:	73 1f                	jae    801058f8 <memmove+0x38>
    s += n;
    d += n;
    while(n-- > 0)
801058d9:	85 f6                	test   %esi,%esi
801058db:	8d 56 ff             	lea    -0x1(%esi),%edx
801058de:	74 0f                	je     801058ef <memmove+0x2f>
      *--d = *--s;
801058e0:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
801058e4:	88 0c 10             	mov    %cl,(%eax,%edx,1)
    while(n-- > 0)
801058e7:	83 ea 01             	sub    $0x1,%edx
801058ea:	83 fa ff             	cmp    $0xffffffff,%edx
801058ed:	75 f1                	jne    801058e0 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
801058ef:	5b                   	pop    %ebx
801058f0:	5e                   	pop    %esi
801058f1:	5d                   	pop    %ebp
801058f2:	c3                   	ret    
801058f3:	90                   	nop
801058f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    while(n-- > 0)
801058f8:	31 d2                	xor    %edx,%edx
801058fa:	85 f6                	test   %esi,%esi
801058fc:	74 f1                	je     801058ef <memmove+0x2f>
801058fe:	66 90                	xchg   %ax,%ax
      *d++ = *s++;
80105900:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
80105904:	88 0c 10             	mov    %cl,(%eax,%edx,1)
80105907:	83 c2 01             	add    $0x1,%edx
    while(n-- > 0)
8010590a:	39 d6                	cmp    %edx,%esi
8010590c:	75 f2                	jne    80105900 <memmove+0x40>
}
8010590e:	5b                   	pop    %ebx
8010590f:	5e                   	pop    %esi
80105910:	5d                   	pop    %ebp
80105911:	c3                   	ret    
80105912:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105919:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105920 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80105920:	55                   	push   %ebp
80105921:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
}
80105923:	5d                   	pop    %ebp
  return memmove(dst, src, n);
80105924:	eb 9a                	jmp    801058c0 <memmove>
80105926:	8d 76 00             	lea    0x0(%esi),%esi
80105929:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105930 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
80105930:	55                   	push   %ebp
80105931:	89 e5                	mov    %esp,%ebp
80105933:	57                   	push   %edi
80105934:	56                   	push   %esi
80105935:	8b 7d 10             	mov    0x10(%ebp),%edi
80105938:	53                   	push   %ebx
80105939:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010593c:	8b 75 0c             	mov    0xc(%ebp),%esi
  while(n > 0 && *p && *p == *q)
8010593f:	85 ff                	test   %edi,%edi
80105941:	74 2f                	je     80105972 <strncmp+0x42>
80105943:	0f b6 01             	movzbl (%ecx),%eax
80105946:	0f b6 1e             	movzbl (%esi),%ebx
80105949:	84 c0                	test   %al,%al
8010594b:	74 37                	je     80105984 <strncmp+0x54>
8010594d:	38 c3                	cmp    %al,%bl
8010594f:	75 33                	jne    80105984 <strncmp+0x54>
80105951:	01 f7                	add    %esi,%edi
80105953:	eb 13                	jmp    80105968 <strncmp+0x38>
80105955:	8d 76 00             	lea    0x0(%esi),%esi
80105958:	0f b6 01             	movzbl (%ecx),%eax
8010595b:	84 c0                	test   %al,%al
8010595d:	74 21                	je     80105980 <strncmp+0x50>
8010595f:	0f b6 1a             	movzbl (%edx),%ebx
80105962:	89 d6                	mov    %edx,%esi
80105964:	38 d8                	cmp    %bl,%al
80105966:	75 1c                	jne    80105984 <strncmp+0x54>
    n--, p++, q++;
80105968:	8d 56 01             	lea    0x1(%esi),%edx
8010596b:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
8010596e:	39 fa                	cmp    %edi,%edx
80105970:	75 e6                	jne    80105958 <strncmp+0x28>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
}
80105972:	5b                   	pop    %ebx
    return 0;
80105973:	31 c0                	xor    %eax,%eax
}
80105975:	5e                   	pop    %esi
80105976:	5f                   	pop    %edi
80105977:	5d                   	pop    %ebp
80105978:	c3                   	ret    
80105979:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105980:	0f b6 5e 01          	movzbl 0x1(%esi),%ebx
  return (uchar)*p - (uchar)*q;
80105984:	29 d8                	sub    %ebx,%eax
}
80105986:	5b                   	pop    %ebx
80105987:	5e                   	pop    %esi
80105988:	5f                   	pop    %edi
80105989:	5d                   	pop    %ebp
8010598a:	c3                   	ret    
8010598b:	90                   	nop
8010598c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105990 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80105990:	55                   	push   %ebp
80105991:	89 e5                	mov    %esp,%ebp
80105993:	56                   	push   %esi
80105994:	53                   	push   %ebx
80105995:	8b 45 08             	mov    0x8(%ebp),%eax
80105998:	8b 5d 0c             	mov    0xc(%ebp),%ebx
8010599b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
8010599e:	89 c2                	mov    %eax,%edx
801059a0:	eb 19                	jmp    801059bb <strncpy+0x2b>
801059a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801059a8:	83 c3 01             	add    $0x1,%ebx
801059ab:	0f b6 4b ff          	movzbl -0x1(%ebx),%ecx
801059af:	83 c2 01             	add    $0x1,%edx
801059b2:	84 c9                	test   %cl,%cl
801059b4:	88 4a ff             	mov    %cl,-0x1(%edx)
801059b7:	74 09                	je     801059c2 <strncpy+0x32>
801059b9:	89 f1                	mov    %esi,%ecx
801059bb:	85 c9                	test   %ecx,%ecx
801059bd:	8d 71 ff             	lea    -0x1(%ecx),%esi
801059c0:	7f e6                	jg     801059a8 <strncpy+0x18>
    ;
  while(n-- > 0)
801059c2:	31 c9                	xor    %ecx,%ecx
801059c4:	85 f6                	test   %esi,%esi
801059c6:	7e 17                	jle    801059df <strncpy+0x4f>
801059c8:	90                   	nop
801059c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
801059d0:	c6 04 0a 00          	movb   $0x0,(%edx,%ecx,1)
801059d4:	89 f3                	mov    %esi,%ebx
801059d6:	83 c1 01             	add    $0x1,%ecx
801059d9:	29 cb                	sub    %ecx,%ebx
  while(n-- > 0)
801059db:	85 db                	test   %ebx,%ebx
801059dd:	7f f1                	jg     801059d0 <strncpy+0x40>
  return os;
}
801059df:	5b                   	pop    %ebx
801059e0:	5e                   	pop    %esi
801059e1:	5d                   	pop    %ebp
801059e2:	c3                   	ret    
801059e3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801059e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801059f0 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
801059f0:	55                   	push   %ebp
801059f1:	89 e5                	mov    %esp,%ebp
801059f3:	56                   	push   %esi
801059f4:	53                   	push   %ebx
801059f5:	8b 4d 10             	mov    0x10(%ebp),%ecx
801059f8:	8b 45 08             	mov    0x8(%ebp),%eax
801059fb:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  if(n <= 0)
801059fe:	85 c9                	test   %ecx,%ecx
80105a00:	7e 26                	jle    80105a28 <safestrcpy+0x38>
80105a02:	8d 74 0a ff          	lea    -0x1(%edx,%ecx,1),%esi
80105a06:	89 c1                	mov    %eax,%ecx
80105a08:	eb 17                	jmp    80105a21 <safestrcpy+0x31>
80105a0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80105a10:	83 c2 01             	add    $0x1,%edx
80105a13:	0f b6 5a ff          	movzbl -0x1(%edx),%ebx
80105a17:	83 c1 01             	add    $0x1,%ecx
80105a1a:	84 db                	test   %bl,%bl
80105a1c:	88 59 ff             	mov    %bl,-0x1(%ecx)
80105a1f:	74 04                	je     80105a25 <safestrcpy+0x35>
80105a21:	39 f2                	cmp    %esi,%edx
80105a23:	75 eb                	jne    80105a10 <safestrcpy+0x20>
    ;
  *s = 0;
80105a25:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
80105a28:	5b                   	pop    %ebx
80105a29:	5e                   	pop    %esi
80105a2a:	5d                   	pop    %ebp
80105a2b:	c3                   	ret    
80105a2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105a30 <strlen>:

int
strlen(const char *s)
{
80105a30:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80105a31:	31 c0                	xor    %eax,%eax
{
80105a33:	89 e5                	mov    %esp,%ebp
80105a35:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80105a38:	80 3a 00             	cmpb   $0x0,(%edx)
80105a3b:	74 0c                	je     80105a49 <strlen+0x19>
80105a3d:	8d 76 00             	lea    0x0(%esi),%esi
80105a40:	83 c0 01             	add    $0x1,%eax
80105a43:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80105a47:	75 f7                	jne    80105a40 <strlen+0x10>
    ;
  return n;
}
80105a49:	5d                   	pop    %ebp
80105a4a:	c3                   	ret    

80105a4b <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
80105a4b:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80105a4f:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80105a53:	55                   	push   %ebp
  pushl %ebx
80105a54:	53                   	push   %ebx
  pushl %esi
80105a55:	56                   	push   %esi
  pushl %edi
80105a56:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80105a57:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80105a59:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
80105a5b:	5f                   	pop    %edi
  popl %esi
80105a5c:	5e                   	pop    %esi
  popl %ebx
80105a5d:	5b                   	pop    %ebx
  popl %ebp
80105a5e:	5d                   	pop    %ebp
  ret
80105a5f:	c3                   	ret    

80105a60 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80105a60:	55                   	push   %ebp
80105a61:	89 e5                	mov    %esp,%ebp
80105a63:	53                   	push   %ebx
80105a64:	83 ec 04             	sub    $0x4,%esp
80105a67:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
80105a6a:	e8 41 e8 ff ff       	call   801042b0 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80105a6f:	8b 00                	mov    (%eax),%eax
80105a71:	39 d8                	cmp    %ebx,%eax
80105a73:	76 1b                	jbe    80105a90 <fetchint+0x30>
80105a75:	8d 53 04             	lea    0x4(%ebx),%edx
80105a78:	39 d0                	cmp    %edx,%eax
80105a7a:	72 14                	jb     80105a90 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
80105a7c:	8b 45 0c             	mov    0xc(%ebp),%eax
80105a7f:	8b 13                	mov    (%ebx),%edx
80105a81:	89 10                	mov    %edx,(%eax)
  return 0;
80105a83:	31 c0                	xor    %eax,%eax
}
80105a85:	83 c4 04             	add    $0x4,%esp
80105a88:	5b                   	pop    %ebx
80105a89:	5d                   	pop    %ebp
80105a8a:	c3                   	ret    
80105a8b:	90                   	nop
80105a8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105a90:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a95:	eb ee                	jmp    80105a85 <fetchint+0x25>
80105a97:	89 f6                	mov    %esi,%esi
80105a99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105aa0 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80105aa0:	55                   	push   %ebp
80105aa1:	89 e5                	mov    %esp,%ebp
80105aa3:	53                   	push   %ebx
80105aa4:	83 ec 04             	sub    $0x4,%esp
80105aa7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
80105aaa:	e8 01 e8 ff ff       	call   801042b0 <myproc>

  if(addr >= curproc->sz)
80105aaf:	39 18                	cmp    %ebx,(%eax)
80105ab1:	76 29                	jbe    80105adc <fetchstr+0x3c>
    return -1;
  *pp = (char*)addr;
80105ab3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80105ab6:	89 da                	mov    %ebx,%edx
80105ab8:	89 19                	mov    %ebx,(%ecx)
  ep = (char*)curproc->sz;
80105aba:	8b 00                	mov    (%eax),%eax
  for(s = *pp; s < ep; s++){
80105abc:	39 c3                	cmp    %eax,%ebx
80105abe:	73 1c                	jae    80105adc <fetchstr+0x3c>
    if(*s == 0)
80105ac0:	80 3b 00             	cmpb   $0x0,(%ebx)
80105ac3:	75 10                	jne    80105ad5 <fetchstr+0x35>
80105ac5:	eb 39                	jmp    80105b00 <fetchstr+0x60>
80105ac7:	89 f6                	mov    %esi,%esi
80105ac9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80105ad0:	80 3a 00             	cmpb   $0x0,(%edx)
80105ad3:	74 1b                	je     80105af0 <fetchstr+0x50>
  for(s = *pp; s < ep; s++){
80105ad5:	83 c2 01             	add    $0x1,%edx
80105ad8:	39 d0                	cmp    %edx,%eax
80105ada:	77 f4                	ja     80105ad0 <fetchstr+0x30>
    return -1;
80105adc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      return s - *pp;
  }
  return -1;
}
80105ae1:	83 c4 04             	add    $0x4,%esp
80105ae4:	5b                   	pop    %ebx
80105ae5:	5d                   	pop    %ebp
80105ae6:	c3                   	ret    
80105ae7:	89 f6                	mov    %esi,%esi
80105ae9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80105af0:	83 c4 04             	add    $0x4,%esp
80105af3:	89 d0                	mov    %edx,%eax
80105af5:	29 d8                	sub    %ebx,%eax
80105af7:	5b                   	pop    %ebx
80105af8:	5d                   	pop    %ebp
80105af9:	c3                   	ret    
80105afa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(*s == 0)
80105b00:	31 c0                	xor    %eax,%eax
      return s - *pp;
80105b02:	eb dd                	jmp    80105ae1 <fetchstr+0x41>
80105b04:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105b0a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80105b10 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80105b10:	55                   	push   %ebp
80105b11:	89 e5                	mov    %esp,%ebp
80105b13:	56                   	push   %esi
80105b14:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105b15:	e8 96 e7 ff ff       	call   801042b0 <myproc>
80105b1a:	8b 40 18             	mov    0x18(%eax),%eax
80105b1d:	8b 55 08             	mov    0x8(%ebp),%edx
80105b20:	8b 40 44             	mov    0x44(%eax),%eax
80105b23:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80105b26:	e8 85 e7 ff ff       	call   801042b0 <myproc>
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80105b2b:	8b 00                	mov    (%eax),%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105b2d:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80105b30:	39 c6                	cmp    %eax,%esi
80105b32:	73 1c                	jae    80105b50 <argint+0x40>
80105b34:	8d 53 08             	lea    0x8(%ebx),%edx
80105b37:	39 d0                	cmp    %edx,%eax
80105b39:	72 15                	jb     80105b50 <argint+0x40>
  *ip = *(int*)(addr);
80105b3b:	8b 45 0c             	mov    0xc(%ebp),%eax
80105b3e:	8b 53 04             	mov    0x4(%ebx),%edx
80105b41:	89 10                	mov    %edx,(%eax)
  return 0;
80105b43:	31 c0                	xor    %eax,%eax
}
80105b45:	5b                   	pop    %ebx
80105b46:	5e                   	pop    %esi
80105b47:	5d                   	pop    %ebp
80105b48:	c3                   	ret    
80105b49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105b50:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105b55:	eb ee                	jmp    80105b45 <argint+0x35>
80105b57:	89 f6                	mov    %esi,%esi
80105b59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105b60 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80105b60:	55                   	push   %ebp
80105b61:	89 e5                	mov    %esp,%ebp
80105b63:	56                   	push   %esi
80105b64:	53                   	push   %ebx
80105b65:	83 ec 10             	sub    $0x10,%esp
80105b68:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
80105b6b:	e8 40 e7 ff ff       	call   801042b0 <myproc>
80105b70:	89 c6                	mov    %eax,%esi
 
  if(argint(n, &i) < 0)
80105b72:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105b75:	83 ec 08             	sub    $0x8,%esp
80105b78:	50                   	push   %eax
80105b79:	ff 75 08             	pushl  0x8(%ebp)
80105b7c:	e8 8f ff ff ff       	call   80105b10 <argint>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80105b81:	83 c4 10             	add    $0x10,%esp
80105b84:	85 c0                	test   %eax,%eax
80105b86:	78 28                	js     80105bb0 <argptr+0x50>
80105b88:	85 db                	test   %ebx,%ebx
80105b8a:	78 24                	js     80105bb0 <argptr+0x50>
80105b8c:	8b 16                	mov    (%esi),%edx
80105b8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b91:	39 c2                	cmp    %eax,%edx
80105b93:	76 1b                	jbe    80105bb0 <argptr+0x50>
80105b95:	01 c3                	add    %eax,%ebx
80105b97:	39 da                	cmp    %ebx,%edx
80105b99:	72 15                	jb     80105bb0 <argptr+0x50>
    return -1;
  *pp = (char*)i;
80105b9b:	8b 55 0c             	mov    0xc(%ebp),%edx
80105b9e:	89 02                	mov    %eax,(%edx)
  return 0;
80105ba0:	31 c0                	xor    %eax,%eax
}
80105ba2:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105ba5:	5b                   	pop    %ebx
80105ba6:	5e                   	pop    %esi
80105ba7:	5d                   	pop    %ebp
80105ba8:	c3                   	ret    
80105ba9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105bb0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105bb5:	eb eb                	jmp    80105ba2 <argptr+0x42>
80105bb7:	89 f6                	mov    %esi,%esi
80105bb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105bc0 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80105bc0:	55                   	push   %ebp
80105bc1:	89 e5                	mov    %esp,%ebp
80105bc3:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
80105bc6:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105bc9:	50                   	push   %eax
80105bca:	ff 75 08             	pushl  0x8(%ebp)
80105bcd:	e8 3e ff ff ff       	call   80105b10 <argint>
80105bd2:	83 c4 10             	add    $0x10,%esp
80105bd5:	85 c0                	test   %eax,%eax
80105bd7:	78 17                	js     80105bf0 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
80105bd9:	83 ec 08             	sub    $0x8,%esp
80105bdc:	ff 75 0c             	pushl  0xc(%ebp)
80105bdf:	ff 75 f4             	pushl  -0xc(%ebp)
80105be2:	e8 b9 fe ff ff       	call   80105aa0 <fetchstr>
80105be7:	83 c4 10             	add    $0x10,%esp
}
80105bea:	c9                   	leave  
80105beb:	c3                   	ret    
80105bec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105bf0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105bf5:	c9                   	leave  
80105bf6:	c3                   	ret    
80105bf7:	89 f6                	mov    %esi,%esi
80105bf9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105c00 <syscall>:
[SYS_get_log_num]	sys_get_log_num,
};

void 
syscall(void)
{
80105c00:	55                   	push   %ebp
80105c01:	89 e5                	mov    %esp,%ebp
80105c03:	53                   	push   %ebx
80105c04:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
80105c07:	e8 a4 e6 ff ff       	call   801042b0 <myproc>
80105c0c:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
80105c0e:	8b 40 18             	mov    0x18(%eax),%eax
80105c11:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80105c14:	8d 50 ff             	lea    -0x1(%eax),%edx
80105c17:	83 fa 20             	cmp    $0x20,%edx
80105c1a:	77 1c                	ja     80105c38 <syscall+0x38>
80105c1c:	8b 14 85 80 97 10 80 	mov    -0x7fef6880(,%eax,4),%edx
80105c23:	85 d2                	test   %edx,%edx
80105c25:	74 11                	je     80105c38 <syscall+0x38>
    curproc->tf->eax = syscalls[num]();
80105c27:	ff d2                	call   *%edx
80105c29:	8b 53 18             	mov    0x18(%ebx),%edx
80105c2c:	89 42 1c             	mov    %eax,0x1c(%edx)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80105c2f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105c32:	c9                   	leave  
80105c33:	c3                   	ret    
80105c34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("%d %s: unknown sys call %d\n",
80105c38:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80105c39:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
80105c3c:	50                   	push   %eax
80105c3d:	ff 73 10             	pushl  0x10(%ebx)
80105c40:	68 45 97 10 80       	push   $0x80109745
80105c45:	e8 16 aa ff ff       	call   80100660 <cprintf>
    curproc->tf->eax = -1;
80105c4a:	8b 43 18             	mov    0x18(%ebx),%eax
80105c4d:	83 c4 10             	add    $0x10,%esp
80105c50:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80105c57:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105c5a:	c9                   	leave  
80105c5b:	c3                   	ret    
80105c5c:	66 90                	xchg   %ax,%ax
80105c5e:	66 90                	xchg   %ax,%ax

80105c60 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80105c60:	55                   	push   %ebp
80105c61:	89 e5                	mov    %esp,%ebp
80105c63:	57                   	push   %edi
80105c64:	56                   	push   %esi
80105c65:	53                   	push   %ebx
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80105c66:	8d 75 da             	lea    -0x26(%ebp),%esi
{
80105c69:	83 ec 34             	sub    $0x34,%esp
80105c6c:	89 4d d0             	mov    %ecx,-0x30(%ebp)
80105c6f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
80105c72:	56                   	push   %esi
80105c73:	50                   	push   %eax
{
80105c74:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80105c77:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
80105c7a:	e8 b1 c8 ff ff       	call   80102530 <nameiparent>
80105c7f:	83 c4 10             	add    $0x10,%esp
80105c82:	85 c0                	test   %eax,%eax
80105c84:	0f 84 46 01 00 00    	je     80105dd0 <create+0x170>
    return 0;
  ilock(dp);
80105c8a:	83 ec 0c             	sub    $0xc,%esp
80105c8d:	89 c3                	mov    %eax,%ebx
80105c8f:	50                   	push   %eax
80105c90:	e8 3b be ff ff       	call   80101ad0 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
80105c95:	83 c4 0c             	add    $0xc,%esp
80105c98:	6a 00                	push   $0x0
80105c9a:	56                   	push   %esi
80105c9b:	53                   	push   %ebx
80105c9c:	e8 3f c5 ff ff       	call   801021e0 <dirlookup>
80105ca1:	83 c4 10             	add    $0x10,%esp
80105ca4:	85 c0                	test   %eax,%eax
80105ca6:	89 c7                	mov    %eax,%edi
80105ca8:	74 36                	je     80105ce0 <create+0x80>
    iunlockput(dp);
80105caa:	83 ec 0c             	sub    $0xc,%esp
80105cad:	53                   	push   %ebx
80105cae:	e8 8d c2 ff ff       	call   80101f40 <iunlockput>
    ilock(ip);
80105cb3:	89 3c 24             	mov    %edi,(%esp)
80105cb6:	e8 15 be ff ff       	call   80101ad0 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80105cbb:	83 c4 10             	add    $0x10,%esp
80105cbe:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80105cc3:	0f 85 97 00 00 00    	jne    80105d60 <create+0x100>
80105cc9:	66 83 7f 50 02       	cmpw   $0x2,0x50(%edi)
80105cce:	0f 85 8c 00 00 00    	jne    80105d60 <create+0x100>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80105cd4:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105cd7:	89 f8                	mov    %edi,%eax
80105cd9:	5b                   	pop    %ebx
80105cda:	5e                   	pop    %esi
80105cdb:	5f                   	pop    %edi
80105cdc:	5d                   	pop    %ebp
80105cdd:	c3                   	ret    
80105cde:	66 90                	xchg   %ax,%ax
  if((ip = ialloc(dp->dev, type)) == 0)
80105ce0:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80105ce4:	83 ec 08             	sub    $0x8,%esp
80105ce7:	50                   	push   %eax
80105ce8:	ff 33                	pushl  (%ebx)
80105cea:	e8 71 bc ff ff       	call   80101960 <ialloc>
80105cef:	83 c4 10             	add    $0x10,%esp
80105cf2:	85 c0                	test   %eax,%eax
80105cf4:	89 c7                	mov    %eax,%edi
80105cf6:	0f 84 e8 00 00 00    	je     80105de4 <create+0x184>
  ilock(ip);
80105cfc:	83 ec 0c             	sub    $0xc,%esp
80105cff:	50                   	push   %eax
80105d00:	e8 cb bd ff ff       	call   80101ad0 <ilock>
  ip->major = major;
80105d05:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80105d09:	66 89 47 52          	mov    %ax,0x52(%edi)
  ip->minor = minor;
80105d0d:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80105d11:	66 89 47 54          	mov    %ax,0x54(%edi)
  ip->nlink = 1;
80105d15:	b8 01 00 00 00       	mov    $0x1,%eax
80105d1a:	66 89 47 56          	mov    %ax,0x56(%edi)
  iupdate(ip);
80105d1e:	89 3c 24             	mov    %edi,(%esp)
80105d21:	e8 fa bc ff ff       	call   80101a20 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80105d26:	83 c4 10             	add    $0x10,%esp
80105d29:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80105d2e:	74 50                	je     80105d80 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
80105d30:	83 ec 04             	sub    $0x4,%esp
80105d33:	ff 77 04             	pushl  0x4(%edi)
80105d36:	56                   	push   %esi
80105d37:	53                   	push   %ebx
80105d38:	e8 13 c7 ff ff       	call   80102450 <dirlink>
80105d3d:	83 c4 10             	add    $0x10,%esp
80105d40:	85 c0                	test   %eax,%eax
80105d42:	0f 88 8f 00 00 00    	js     80105dd7 <create+0x177>
  iunlockput(dp);
80105d48:	83 ec 0c             	sub    $0xc,%esp
80105d4b:	53                   	push   %ebx
80105d4c:	e8 ef c1 ff ff       	call   80101f40 <iunlockput>
  return ip;
80105d51:	83 c4 10             	add    $0x10,%esp
}
80105d54:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105d57:	89 f8                	mov    %edi,%eax
80105d59:	5b                   	pop    %ebx
80105d5a:	5e                   	pop    %esi
80105d5b:	5f                   	pop    %edi
80105d5c:	5d                   	pop    %ebp
80105d5d:	c3                   	ret    
80105d5e:	66 90                	xchg   %ax,%ax
    iunlockput(ip);
80105d60:	83 ec 0c             	sub    $0xc,%esp
80105d63:	57                   	push   %edi
    return 0;
80105d64:	31 ff                	xor    %edi,%edi
    iunlockput(ip);
80105d66:	e8 d5 c1 ff ff       	call   80101f40 <iunlockput>
    return 0;
80105d6b:	83 c4 10             	add    $0x10,%esp
}
80105d6e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105d71:	89 f8                	mov    %edi,%eax
80105d73:	5b                   	pop    %ebx
80105d74:	5e                   	pop    %esi
80105d75:	5f                   	pop    %edi
80105d76:	5d                   	pop    %ebp
80105d77:	c3                   	ret    
80105d78:	90                   	nop
80105d79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    dp->nlink++;  // for ".."
80105d80:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80105d85:	83 ec 0c             	sub    $0xc,%esp
80105d88:	53                   	push   %ebx
80105d89:	e8 92 bc ff ff       	call   80101a20 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80105d8e:	83 c4 0c             	add    $0xc,%esp
80105d91:	ff 77 04             	pushl  0x4(%edi)
80105d94:	68 24 98 10 80       	push   $0x80109824
80105d99:	57                   	push   %edi
80105d9a:	e8 b1 c6 ff ff       	call   80102450 <dirlink>
80105d9f:	83 c4 10             	add    $0x10,%esp
80105da2:	85 c0                	test   %eax,%eax
80105da4:	78 1c                	js     80105dc2 <create+0x162>
80105da6:	83 ec 04             	sub    $0x4,%esp
80105da9:	ff 73 04             	pushl  0x4(%ebx)
80105dac:	68 23 98 10 80       	push   $0x80109823
80105db1:	57                   	push   %edi
80105db2:	e8 99 c6 ff ff       	call   80102450 <dirlink>
80105db7:	83 c4 10             	add    $0x10,%esp
80105dba:	85 c0                	test   %eax,%eax
80105dbc:	0f 89 6e ff ff ff    	jns    80105d30 <create+0xd0>
      panic("create dots");
80105dc2:	83 ec 0c             	sub    $0xc,%esp
80105dc5:	68 17 98 10 80       	push   $0x80109817
80105dca:	e8 c1 a5 ff ff       	call   80100390 <panic>
80105dcf:	90                   	nop
    return 0;
80105dd0:	31 ff                	xor    %edi,%edi
80105dd2:	e9 fd fe ff ff       	jmp    80105cd4 <create+0x74>
    panic("create: dirlink");
80105dd7:	83 ec 0c             	sub    $0xc,%esp
80105dda:	68 26 98 10 80       	push   $0x80109826
80105ddf:	e8 ac a5 ff ff       	call   80100390 <panic>
    panic("create: ialloc");
80105de4:	83 ec 0c             	sub    $0xc,%esp
80105de7:	68 08 98 10 80       	push   $0x80109808
80105dec:	e8 9f a5 ff ff       	call   80100390 <panic>
80105df1:	eb 0d                	jmp    80105e00 <argfd.constprop.0>
80105df3:	90                   	nop
80105df4:	90                   	nop
80105df5:	90                   	nop
80105df6:	90                   	nop
80105df7:	90                   	nop
80105df8:	90                   	nop
80105df9:	90                   	nop
80105dfa:	90                   	nop
80105dfb:	90                   	nop
80105dfc:	90                   	nop
80105dfd:	90                   	nop
80105dfe:	90                   	nop
80105dff:	90                   	nop

80105e00 <argfd.constprop.0>:
argfd(int n, int *pfd, struct file **pf)
80105e00:	55                   	push   %ebp
80105e01:	89 e5                	mov    %esp,%ebp
80105e03:	56                   	push   %esi
80105e04:	53                   	push   %ebx
80105e05:	89 c3                	mov    %eax,%ebx
  if(argint(n, &fd) < 0)
80105e07:	8d 45 f4             	lea    -0xc(%ebp),%eax
argfd(int n, int *pfd, struct file **pf)
80105e0a:	89 d6                	mov    %edx,%esi
80105e0c:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80105e0f:	50                   	push   %eax
80105e10:	6a 00                	push   $0x0
80105e12:	e8 f9 fc ff ff       	call   80105b10 <argint>
80105e17:	83 c4 10             	add    $0x10,%esp
80105e1a:	85 c0                	test   %eax,%eax
80105e1c:	78 2a                	js     80105e48 <argfd.constprop.0+0x48>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80105e1e:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80105e22:	77 24                	ja     80105e48 <argfd.constprop.0+0x48>
80105e24:	e8 87 e4 ff ff       	call   801042b0 <myproc>
80105e29:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105e2c:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
80105e30:	85 c0                	test   %eax,%eax
80105e32:	74 14                	je     80105e48 <argfd.constprop.0+0x48>
  if(pfd)
80105e34:	85 db                	test   %ebx,%ebx
80105e36:	74 02                	je     80105e3a <argfd.constprop.0+0x3a>
    *pfd = fd;
80105e38:	89 13                	mov    %edx,(%ebx)
    *pf = f;
80105e3a:	89 06                	mov    %eax,(%esi)
  return 0;
80105e3c:	31 c0                	xor    %eax,%eax
}
80105e3e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105e41:	5b                   	pop    %ebx
80105e42:	5e                   	pop    %esi
80105e43:	5d                   	pop    %ebp
80105e44:	c3                   	ret    
80105e45:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105e48:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105e4d:	eb ef                	jmp    80105e3e <argfd.constprop.0+0x3e>
80105e4f:	90                   	nop

80105e50 <sys_dup>:
{
80105e50:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0)
80105e51:	31 c0                	xor    %eax,%eax
{
80105e53:	89 e5                	mov    %esp,%ebp
80105e55:	56                   	push   %esi
80105e56:	53                   	push   %ebx
  if(argfd(0, 0, &f) < 0)
80105e57:	8d 55 f4             	lea    -0xc(%ebp),%edx
{
80105e5a:	83 ec 10             	sub    $0x10,%esp
  if(argfd(0, 0, &f) < 0)
80105e5d:	e8 9e ff ff ff       	call   80105e00 <argfd.constprop.0>
80105e62:	85 c0                	test   %eax,%eax
80105e64:	78 42                	js     80105ea8 <sys_dup+0x58>
  if((fd=fdalloc(f)) < 0)
80105e66:	8b 75 f4             	mov    -0xc(%ebp),%esi
  for(fd = 0; fd < NOFILE; fd++){
80105e69:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80105e6b:	e8 40 e4 ff ff       	call   801042b0 <myproc>
80105e70:	eb 0e                	jmp    80105e80 <sys_dup+0x30>
80105e72:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(fd = 0; fd < NOFILE; fd++){
80105e78:	83 c3 01             	add    $0x1,%ebx
80105e7b:	83 fb 10             	cmp    $0x10,%ebx
80105e7e:	74 28                	je     80105ea8 <sys_dup+0x58>
    if(curproc->ofile[fd] == 0){
80105e80:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105e84:	85 d2                	test   %edx,%edx
80105e86:	75 f0                	jne    80105e78 <sys_dup+0x28>
      curproc->ofile[fd] = f;
80105e88:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
80105e8c:	83 ec 0c             	sub    $0xc,%esp
80105e8f:	ff 75 f4             	pushl  -0xc(%ebp)
80105e92:	e8 09 b0 ff ff       	call   80100ea0 <filedup>
  return fd;
80105e97:	83 c4 10             	add    $0x10,%esp
}
80105e9a:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105e9d:	89 d8                	mov    %ebx,%eax
80105e9f:	5b                   	pop    %ebx
80105ea0:	5e                   	pop    %esi
80105ea1:	5d                   	pop    %ebp
80105ea2:	c3                   	ret    
80105ea3:	90                   	nop
80105ea4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105ea8:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
80105eab:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80105eb0:	89 d8                	mov    %ebx,%eax
80105eb2:	5b                   	pop    %ebx
80105eb3:	5e                   	pop    %esi
80105eb4:	5d                   	pop    %ebp
80105eb5:	c3                   	ret    
80105eb6:	8d 76 00             	lea    0x0(%esi),%esi
80105eb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105ec0 <sys_read>:
{
80105ec0:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105ec1:	31 c0                	xor    %eax,%eax
{
80105ec3:	89 e5                	mov    %esp,%ebp
80105ec5:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105ec8:	8d 55 ec             	lea    -0x14(%ebp),%edx
80105ecb:	e8 30 ff ff ff       	call   80105e00 <argfd.constprop.0>
80105ed0:	85 c0                	test   %eax,%eax
80105ed2:	78 4c                	js     80105f20 <sys_read+0x60>
80105ed4:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105ed7:	83 ec 08             	sub    $0x8,%esp
80105eda:	50                   	push   %eax
80105edb:	6a 02                	push   $0x2
80105edd:	e8 2e fc ff ff       	call   80105b10 <argint>
80105ee2:	83 c4 10             	add    $0x10,%esp
80105ee5:	85 c0                	test   %eax,%eax
80105ee7:	78 37                	js     80105f20 <sys_read+0x60>
80105ee9:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105eec:	83 ec 04             	sub    $0x4,%esp
80105eef:	ff 75 f0             	pushl  -0x10(%ebp)
80105ef2:	50                   	push   %eax
80105ef3:	6a 01                	push   $0x1
80105ef5:	e8 66 fc ff ff       	call   80105b60 <argptr>
80105efa:	83 c4 10             	add    $0x10,%esp
80105efd:	85 c0                	test   %eax,%eax
80105eff:	78 1f                	js     80105f20 <sys_read+0x60>
  return fileread(f, p, n);
80105f01:	83 ec 04             	sub    $0x4,%esp
80105f04:	ff 75 f0             	pushl  -0x10(%ebp)
80105f07:	ff 75 f4             	pushl  -0xc(%ebp)
80105f0a:	ff 75 ec             	pushl  -0x14(%ebp)
80105f0d:	e8 fe b0 ff ff       	call   80101010 <fileread>
80105f12:	83 c4 10             	add    $0x10,%esp
}
80105f15:	c9                   	leave  
80105f16:	c3                   	ret    
80105f17:	89 f6                	mov    %esi,%esi
80105f19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80105f20:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105f25:	c9                   	leave  
80105f26:	c3                   	ret    
80105f27:	89 f6                	mov    %esi,%esi
80105f29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105f30 <sys_write>:
{
80105f30:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105f31:	31 c0                	xor    %eax,%eax
{
80105f33:	89 e5                	mov    %esp,%ebp
80105f35:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105f38:	8d 55 ec             	lea    -0x14(%ebp),%edx
80105f3b:	e8 c0 fe ff ff       	call   80105e00 <argfd.constprop.0>
80105f40:	85 c0                	test   %eax,%eax
80105f42:	78 4c                	js     80105f90 <sys_write+0x60>
80105f44:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105f47:	83 ec 08             	sub    $0x8,%esp
80105f4a:	50                   	push   %eax
80105f4b:	6a 02                	push   $0x2
80105f4d:	e8 be fb ff ff       	call   80105b10 <argint>
80105f52:	83 c4 10             	add    $0x10,%esp
80105f55:	85 c0                	test   %eax,%eax
80105f57:	78 37                	js     80105f90 <sys_write+0x60>
80105f59:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105f5c:	83 ec 04             	sub    $0x4,%esp
80105f5f:	ff 75 f0             	pushl  -0x10(%ebp)
80105f62:	50                   	push   %eax
80105f63:	6a 01                	push   $0x1
80105f65:	e8 f6 fb ff ff       	call   80105b60 <argptr>
80105f6a:	83 c4 10             	add    $0x10,%esp
80105f6d:	85 c0                	test   %eax,%eax
80105f6f:	78 1f                	js     80105f90 <sys_write+0x60>
  return filewrite(f, p, n);
80105f71:	83 ec 04             	sub    $0x4,%esp
80105f74:	ff 75 f0             	pushl  -0x10(%ebp)
80105f77:	ff 75 f4             	pushl  -0xc(%ebp)
80105f7a:	ff 75 ec             	pushl  -0x14(%ebp)
80105f7d:	e8 1e b1 ff ff       	call   801010a0 <filewrite>
80105f82:	83 c4 10             	add    $0x10,%esp
}
80105f85:	c9                   	leave  
80105f86:	c3                   	ret    
80105f87:	89 f6                	mov    %esi,%esi
80105f89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80105f90:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105f95:	c9                   	leave  
80105f96:	c3                   	ret    
80105f97:	89 f6                	mov    %esi,%esi
80105f99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105fa0 <sys_close>:
{
80105fa0:	55                   	push   %ebp
80105fa1:	89 e5                	mov    %esp,%ebp
80105fa3:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, &fd, &f) < 0)
80105fa6:	8d 55 f4             	lea    -0xc(%ebp),%edx
80105fa9:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105fac:	e8 4f fe ff ff       	call   80105e00 <argfd.constprop.0>
80105fb1:	85 c0                	test   %eax,%eax
80105fb3:	78 2b                	js     80105fe0 <sys_close+0x40>
  myproc()->ofile[fd] = 0;
80105fb5:	e8 f6 e2 ff ff       	call   801042b0 <myproc>
80105fba:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
80105fbd:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
80105fc0:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
80105fc7:	00 
  fileclose(f);
80105fc8:	ff 75 f4             	pushl  -0xc(%ebp)
80105fcb:	e8 20 af ff ff       	call   80100ef0 <fileclose>
  return 0;
80105fd0:	83 c4 10             	add    $0x10,%esp
80105fd3:	31 c0                	xor    %eax,%eax
}
80105fd5:	c9                   	leave  
80105fd6:	c3                   	ret    
80105fd7:	89 f6                	mov    %esi,%esi
80105fd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80105fe0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105fe5:	c9                   	leave  
80105fe6:	c3                   	ret    
80105fe7:	89 f6                	mov    %esi,%esi
80105fe9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105ff0 <sys_pread>:
{
80105ff0:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0 || argint(3, &n1) < 0)
80105ff1:	31 c0                	xor    %eax,%eax
{
80105ff3:	89 e5                	mov    %esp,%ebp
80105ff5:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0 || argint(3, &n1) < 0)
80105ff8:	8d 55 e8             	lea    -0x18(%ebp),%edx
80105ffb:	e8 00 fe ff ff       	call   80105e00 <argfd.constprop.0>
80106000:	85 c0                	test   %eax,%eax
80106002:	78 5c                	js     80106060 <sys_pread+0x70>
80106004:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106007:	83 ec 08             	sub    $0x8,%esp
8010600a:	50                   	push   %eax
8010600b:	6a 02                	push   $0x2
8010600d:	e8 fe fa ff ff       	call   80105b10 <argint>
80106012:	83 c4 10             	add    $0x10,%esp
80106015:	85 c0                	test   %eax,%eax
80106017:	78 47                	js     80106060 <sys_pread+0x70>
80106019:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010601c:	83 ec 04             	sub    $0x4,%esp
8010601f:	ff 75 ec             	pushl  -0x14(%ebp)
80106022:	50                   	push   %eax
80106023:	6a 01                	push   $0x1
80106025:	e8 36 fb ff ff       	call   80105b60 <argptr>
8010602a:	83 c4 10             	add    $0x10,%esp
8010602d:	85 c0                	test   %eax,%eax
8010602f:	78 2f                	js     80106060 <sys_pread+0x70>
80106031:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106034:	83 ec 08             	sub    $0x8,%esp
80106037:	50                   	push   %eax
80106038:	6a 03                	push   $0x3
8010603a:	e8 d1 fa ff ff       	call   80105b10 <argint>
8010603f:	83 c4 10             	add    $0x10,%esp
80106042:	85 c0                	test   %eax,%eax
80106044:	78 1a                	js     80106060 <sys_pread+0x70>
  return filepread(f, p, n, n1);
80106046:	ff 75 f0             	pushl  -0x10(%ebp)
80106049:	ff 75 ec             	pushl  -0x14(%ebp)
8010604c:	ff 75 f4             	pushl  -0xc(%ebp)
8010604f:	ff 75 e8             	pushl  -0x18(%ebp)
80106052:	e8 69 b2 ff ff       	call   801012c0 <filepread>
80106057:	83 c4 10             	add    $0x10,%esp
}
8010605a:	c9                   	leave  
8010605b:	c3                   	ret    
8010605c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80106060:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106065:	c9                   	leave  
80106066:	c3                   	ret    
80106067:	89 f6                	mov    %esi,%esi
80106069:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106070 <sys_pwrite>:
{
80106070:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0 || argint(3, &n1) < 0)
80106071:	31 c0                	xor    %eax,%eax
{
80106073:	89 e5                	mov    %esp,%ebp
80106075:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0 || argint(3, &n1) < 0)
80106078:	8d 55 e8             	lea    -0x18(%ebp),%edx
8010607b:	e8 80 fd ff ff       	call   80105e00 <argfd.constprop.0>
80106080:	85 c0                	test   %eax,%eax
80106082:	78 5c                	js     801060e0 <sys_pwrite+0x70>
80106084:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106087:	83 ec 08             	sub    $0x8,%esp
8010608a:	50                   	push   %eax
8010608b:	6a 02                	push   $0x2
8010608d:	e8 7e fa ff ff       	call   80105b10 <argint>
80106092:	83 c4 10             	add    $0x10,%esp
80106095:	85 c0                	test   %eax,%eax
80106097:	78 47                	js     801060e0 <sys_pwrite+0x70>
80106099:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010609c:	83 ec 04             	sub    $0x4,%esp
8010609f:	ff 75 ec             	pushl  -0x14(%ebp)
801060a2:	50                   	push   %eax
801060a3:	6a 01                	push   $0x1
801060a5:	e8 b6 fa ff ff       	call   80105b60 <argptr>
801060aa:	83 c4 10             	add    $0x10,%esp
801060ad:	85 c0                	test   %eax,%eax
801060af:	78 2f                	js     801060e0 <sys_pwrite+0x70>
801060b1:	8d 45 f0             	lea    -0x10(%ebp),%eax
801060b4:	83 ec 08             	sub    $0x8,%esp
801060b7:	50                   	push   %eax
801060b8:	6a 03                	push   $0x3
801060ba:	e8 51 fa ff ff       	call   80105b10 <argint>
801060bf:	83 c4 10             	add    $0x10,%esp
801060c2:	85 c0                	test   %eax,%eax
801060c4:	78 1a                	js     801060e0 <sys_pwrite+0x70>
  return filepwrite(f, p, n, n1);
801060c6:	ff 75 f0             	pushl  -0x10(%ebp)
801060c9:	ff 75 ec             	pushl  -0x14(%ebp)
801060cc:	ff 75 f4             	pushl  -0xc(%ebp)
801060cf:	ff 75 e8             	pushl  -0x18(%ebp)
801060d2:	e8 e9 b0 ff ff       	call   801011c0 <filepwrite>
801060d7:	83 c4 10             	add    $0x10,%esp
}
801060da:	c9                   	leave  
801060db:	c3                   	ret    
801060dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801060e0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801060e5:	c9                   	leave  
801060e6:	c3                   	ret    
801060e7:	89 f6                	mov    %esi,%esi
801060e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801060f0 <sys_fstat>:
{
801060f0:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
801060f1:	31 c0                	xor    %eax,%eax
{
801060f3:	89 e5                	mov    %esp,%ebp
801060f5:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
801060f8:	8d 55 f0             	lea    -0x10(%ebp),%edx
801060fb:	e8 00 fd ff ff       	call   80105e00 <argfd.constprop.0>
80106100:	85 c0                	test   %eax,%eax
80106102:	78 2c                	js     80106130 <sys_fstat+0x40>
80106104:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106107:	83 ec 04             	sub    $0x4,%esp
8010610a:	6a 14                	push   $0x14
8010610c:	50                   	push   %eax
8010610d:	6a 01                	push   $0x1
8010610f:	e8 4c fa ff ff       	call   80105b60 <argptr>
80106114:	83 c4 10             	add    $0x10,%esp
80106117:	85 c0                	test   %eax,%eax
80106119:	78 15                	js     80106130 <sys_fstat+0x40>
  return filestat(f, st);
8010611b:	83 ec 08             	sub    $0x8,%esp
8010611e:	ff 75 f4             	pushl  -0xc(%ebp)
80106121:	ff 75 f0             	pushl  -0x10(%ebp)
80106124:	e8 97 ae ff ff       	call   80100fc0 <filestat>
80106129:	83 c4 10             	add    $0x10,%esp
}
8010612c:	c9                   	leave  
8010612d:	c3                   	ret    
8010612e:	66 90                	xchg   %ax,%ax
    return -1;
80106130:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106135:	c9                   	leave  
80106136:	c3                   	ret    
80106137:	89 f6                	mov    %esi,%esi
80106139:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106140 <sys_link>:
{
80106140:	55                   	push   %ebp
80106141:	89 e5                	mov    %esp,%ebp
80106143:	57                   	push   %edi
80106144:	56                   	push   %esi
80106145:	53                   	push   %ebx
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80106146:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
80106149:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
8010614c:	50                   	push   %eax
8010614d:	6a 00                	push   $0x0
8010614f:	e8 6c fa ff ff       	call   80105bc0 <argstr>
80106154:	83 c4 10             	add    $0x10,%esp
80106157:	85 c0                	test   %eax,%eax
80106159:	0f 88 fb 00 00 00    	js     8010625a <sys_link+0x11a>
8010615f:	8d 45 d0             	lea    -0x30(%ebp),%eax
80106162:	83 ec 08             	sub    $0x8,%esp
80106165:	50                   	push   %eax
80106166:	6a 01                	push   $0x1
80106168:	e8 53 fa ff ff       	call   80105bc0 <argstr>
8010616d:	83 c4 10             	add    $0x10,%esp
80106170:	85 c0                	test   %eax,%eax
80106172:	0f 88 e2 00 00 00    	js     8010625a <sys_link+0x11a>
  begin_op();
80106178:	e8 f3 d0 ff ff       	call   80103270 <begin_op>
  if((ip = namei(old)) == 0){
8010617d:	83 ec 0c             	sub    $0xc,%esp
80106180:	ff 75 d4             	pushl  -0x2c(%ebp)
80106183:	e8 88 c3 ff ff       	call   80102510 <namei>
80106188:	83 c4 10             	add    $0x10,%esp
8010618b:	85 c0                	test   %eax,%eax
8010618d:	89 c3                	mov    %eax,%ebx
8010618f:	0f 84 ea 00 00 00    	je     8010627f <sys_link+0x13f>
  ilock(ip);
80106195:	83 ec 0c             	sub    $0xc,%esp
80106198:	50                   	push   %eax
80106199:	e8 32 b9 ff ff       	call   80101ad0 <ilock>
  if(ip->type == T_DIR){
8010619e:	83 c4 10             	add    $0x10,%esp
801061a1:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801061a6:	0f 84 bb 00 00 00    	je     80106267 <sys_link+0x127>
  ip->nlink++;
801061ac:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  iupdate(ip);
801061b1:	83 ec 0c             	sub    $0xc,%esp
  if((dp = nameiparent(new, name)) == 0)
801061b4:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
801061b7:	53                   	push   %ebx
801061b8:	e8 63 b8 ff ff       	call   80101a20 <iupdate>
  iunlock(ip);
801061bd:	89 1c 24             	mov    %ebx,(%esp)
801061c0:	e8 eb b9 ff ff       	call   80101bb0 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
801061c5:	58                   	pop    %eax
801061c6:	5a                   	pop    %edx
801061c7:	57                   	push   %edi
801061c8:	ff 75 d0             	pushl  -0x30(%ebp)
801061cb:	e8 60 c3 ff ff       	call   80102530 <nameiparent>
801061d0:	83 c4 10             	add    $0x10,%esp
801061d3:	85 c0                	test   %eax,%eax
801061d5:	89 c6                	mov    %eax,%esi
801061d7:	74 5b                	je     80106234 <sys_link+0xf4>
  ilock(dp);
801061d9:	83 ec 0c             	sub    $0xc,%esp
801061dc:	50                   	push   %eax
801061dd:	e8 ee b8 ff ff       	call   80101ad0 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
801061e2:	83 c4 10             	add    $0x10,%esp
801061e5:	8b 03                	mov    (%ebx),%eax
801061e7:	39 06                	cmp    %eax,(%esi)
801061e9:	75 3d                	jne    80106228 <sys_link+0xe8>
801061eb:	83 ec 04             	sub    $0x4,%esp
801061ee:	ff 73 04             	pushl  0x4(%ebx)
801061f1:	57                   	push   %edi
801061f2:	56                   	push   %esi
801061f3:	e8 58 c2 ff ff       	call   80102450 <dirlink>
801061f8:	83 c4 10             	add    $0x10,%esp
801061fb:	85 c0                	test   %eax,%eax
801061fd:	78 29                	js     80106228 <sys_link+0xe8>
  iunlockput(dp);
801061ff:	83 ec 0c             	sub    $0xc,%esp
80106202:	56                   	push   %esi
80106203:	e8 38 bd ff ff       	call   80101f40 <iunlockput>
  iput(ip);
80106208:	89 1c 24             	mov    %ebx,(%esp)
8010620b:	e8 f0 b9 ff ff       	call   80101c00 <iput>
  end_op();
80106210:	e8 0b d1 ff ff       	call   80103320 <end_op>
  return 0;
80106215:	83 c4 10             	add    $0x10,%esp
80106218:	31 c0                	xor    %eax,%eax
}
8010621a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010621d:	5b                   	pop    %ebx
8010621e:	5e                   	pop    %esi
8010621f:	5f                   	pop    %edi
80106220:	5d                   	pop    %ebp
80106221:	c3                   	ret    
80106222:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
80106228:	83 ec 0c             	sub    $0xc,%esp
8010622b:	56                   	push   %esi
8010622c:	e8 0f bd ff ff       	call   80101f40 <iunlockput>
    goto bad;
80106231:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80106234:	83 ec 0c             	sub    $0xc,%esp
80106237:	53                   	push   %ebx
80106238:	e8 93 b8 ff ff       	call   80101ad0 <ilock>
  ip->nlink--;
8010623d:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80106242:	89 1c 24             	mov    %ebx,(%esp)
80106245:	e8 d6 b7 ff ff       	call   80101a20 <iupdate>
  iunlockput(ip);
8010624a:	89 1c 24             	mov    %ebx,(%esp)
8010624d:	e8 ee bc ff ff       	call   80101f40 <iunlockput>
  end_op();
80106252:	e8 c9 d0 ff ff       	call   80103320 <end_op>
  return -1;
80106257:	83 c4 10             	add    $0x10,%esp
}
8010625a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
8010625d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106262:	5b                   	pop    %ebx
80106263:	5e                   	pop    %esi
80106264:	5f                   	pop    %edi
80106265:	5d                   	pop    %ebp
80106266:	c3                   	ret    
    iunlockput(ip);
80106267:	83 ec 0c             	sub    $0xc,%esp
8010626a:	53                   	push   %ebx
8010626b:	e8 d0 bc ff ff       	call   80101f40 <iunlockput>
    end_op();
80106270:	e8 ab d0 ff ff       	call   80103320 <end_op>
    return -1;
80106275:	83 c4 10             	add    $0x10,%esp
80106278:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010627d:	eb 9b                	jmp    8010621a <sys_link+0xda>
    end_op();
8010627f:	e8 9c d0 ff ff       	call   80103320 <end_op>
    return -1;
80106284:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106289:	eb 8f                	jmp    8010621a <sys_link+0xda>
8010628b:	90                   	nop
8010628c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106290 <sys_unlink>:
{
80106290:	55                   	push   %ebp
80106291:	89 e5                	mov    %esp,%ebp
80106293:	57                   	push   %edi
80106294:	56                   	push   %esi
80106295:	53                   	push   %ebx
  if(argstr(0, &path) < 0)
80106296:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
80106299:	83 ec 44             	sub    $0x44,%esp
  if(argstr(0, &path) < 0)
8010629c:	50                   	push   %eax
8010629d:	6a 00                	push   $0x0
8010629f:	e8 1c f9 ff ff       	call   80105bc0 <argstr>
801062a4:	83 c4 10             	add    $0x10,%esp
801062a7:	85 c0                	test   %eax,%eax
801062a9:	0f 88 77 01 00 00    	js     80106426 <sys_unlink+0x196>
  if((dp = nameiparent(path, name)) == 0){
801062af:	8d 5d ca             	lea    -0x36(%ebp),%ebx
  begin_op();
801062b2:	e8 b9 cf ff ff       	call   80103270 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
801062b7:	83 ec 08             	sub    $0x8,%esp
801062ba:	53                   	push   %ebx
801062bb:	ff 75 c0             	pushl  -0x40(%ebp)
801062be:	e8 6d c2 ff ff       	call   80102530 <nameiparent>
801062c3:	83 c4 10             	add    $0x10,%esp
801062c6:	85 c0                	test   %eax,%eax
801062c8:	89 c6                	mov    %eax,%esi
801062ca:	0f 84 60 01 00 00    	je     80106430 <sys_unlink+0x1a0>
  ilock(dp);
801062d0:	83 ec 0c             	sub    $0xc,%esp
801062d3:	50                   	push   %eax
801062d4:	e8 f7 b7 ff ff       	call   80101ad0 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
801062d9:	58                   	pop    %eax
801062da:	5a                   	pop    %edx
801062db:	68 24 98 10 80       	push   $0x80109824
801062e0:	53                   	push   %ebx
801062e1:	e8 da be ff ff       	call   801021c0 <namecmp>
801062e6:	83 c4 10             	add    $0x10,%esp
801062e9:	85 c0                	test   %eax,%eax
801062eb:	0f 84 03 01 00 00    	je     801063f4 <sys_unlink+0x164>
801062f1:	83 ec 08             	sub    $0x8,%esp
801062f4:	68 23 98 10 80       	push   $0x80109823
801062f9:	53                   	push   %ebx
801062fa:	e8 c1 be ff ff       	call   801021c0 <namecmp>
801062ff:	83 c4 10             	add    $0x10,%esp
80106302:	85 c0                	test   %eax,%eax
80106304:	0f 84 ea 00 00 00    	je     801063f4 <sys_unlink+0x164>
  if((ip = dirlookup(dp, name, &off)) == 0)
8010630a:	8d 45 c4             	lea    -0x3c(%ebp),%eax
8010630d:	83 ec 04             	sub    $0x4,%esp
80106310:	50                   	push   %eax
80106311:	53                   	push   %ebx
80106312:	56                   	push   %esi
80106313:	e8 c8 be ff ff       	call   801021e0 <dirlookup>
80106318:	83 c4 10             	add    $0x10,%esp
8010631b:	85 c0                	test   %eax,%eax
8010631d:	89 c3                	mov    %eax,%ebx
8010631f:	0f 84 cf 00 00 00    	je     801063f4 <sys_unlink+0x164>
  ilock(ip);
80106325:	83 ec 0c             	sub    $0xc,%esp
80106328:	50                   	push   %eax
80106329:	e8 a2 b7 ff ff       	call   80101ad0 <ilock>
  if(ip->nlink < 1)
8010632e:	83 c4 10             	add    $0x10,%esp
80106331:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80106336:	0f 8e 10 01 00 00    	jle    8010644c <sys_unlink+0x1bc>
  if(ip->type == T_DIR && !isdirempty(ip)){
8010633c:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80106341:	74 6d                	je     801063b0 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
80106343:	8d 45 d8             	lea    -0x28(%ebp),%eax
80106346:	83 ec 04             	sub    $0x4,%esp
80106349:	6a 10                	push   $0x10
8010634b:	6a 00                	push   $0x0
8010634d:	50                   	push   %eax
8010634e:	e8 bd f4 ff ff       	call   80105810 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80106353:	8d 45 d8             	lea    -0x28(%ebp),%eax
80106356:	6a 10                	push   $0x10
80106358:	ff 75 c4             	pushl  -0x3c(%ebp)
8010635b:	50                   	push   %eax
8010635c:	56                   	push   %esi
8010635d:	e8 2e bd ff ff       	call   80102090 <writei>
80106362:	83 c4 20             	add    $0x20,%esp
80106365:	83 f8 10             	cmp    $0x10,%eax
80106368:	0f 85 eb 00 00 00    	jne    80106459 <sys_unlink+0x1c9>
  if(ip->type == T_DIR){
8010636e:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80106373:	0f 84 97 00 00 00    	je     80106410 <sys_unlink+0x180>
  iunlockput(dp);
80106379:	83 ec 0c             	sub    $0xc,%esp
8010637c:	56                   	push   %esi
8010637d:	e8 be bb ff ff       	call   80101f40 <iunlockput>
  ip->nlink--;
80106382:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80106387:	89 1c 24             	mov    %ebx,(%esp)
8010638a:	e8 91 b6 ff ff       	call   80101a20 <iupdate>
  iunlockput(ip);
8010638f:	89 1c 24             	mov    %ebx,(%esp)
80106392:	e8 a9 bb ff ff       	call   80101f40 <iunlockput>
  end_op();
80106397:	e8 84 cf ff ff       	call   80103320 <end_op>
  return 0;
8010639c:	83 c4 10             	add    $0x10,%esp
8010639f:	31 c0                	xor    %eax,%eax
}
801063a1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801063a4:	5b                   	pop    %ebx
801063a5:	5e                   	pop    %esi
801063a6:	5f                   	pop    %edi
801063a7:	5d                   	pop    %ebp
801063a8:	c3                   	ret    
801063a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
801063b0:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
801063b4:	76 8d                	jbe    80106343 <sys_unlink+0xb3>
801063b6:	bf 20 00 00 00       	mov    $0x20,%edi
801063bb:	eb 0f                	jmp    801063cc <sys_unlink+0x13c>
801063bd:	8d 76 00             	lea    0x0(%esi),%esi
801063c0:	83 c7 10             	add    $0x10,%edi
801063c3:	3b 7b 58             	cmp    0x58(%ebx),%edi
801063c6:	0f 83 77 ff ff ff    	jae    80106343 <sys_unlink+0xb3>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801063cc:	8d 45 d8             	lea    -0x28(%ebp),%eax
801063cf:	6a 10                	push   $0x10
801063d1:	57                   	push   %edi
801063d2:	50                   	push   %eax
801063d3:	53                   	push   %ebx
801063d4:	e8 b7 bb ff ff       	call   80101f90 <readi>
801063d9:	83 c4 10             	add    $0x10,%esp
801063dc:	83 f8 10             	cmp    $0x10,%eax
801063df:	75 5e                	jne    8010643f <sys_unlink+0x1af>
    if(de.inum != 0)
801063e1:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
801063e6:	74 d8                	je     801063c0 <sys_unlink+0x130>
    iunlockput(ip);
801063e8:	83 ec 0c             	sub    $0xc,%esp
801063eb:	53                   	push   %ebx
801063ec:	e8 4f bb ff ff       	call   80101f40 <iunlockput>
    goto bad;
801063f1:	83 c4 10             	add    $0x10,%esp
  iunlockput(dp);
801063f4:	83 ec 0c             	sub    $0xc,%esp
801063f7:	56                   	push   %esi
801063f8:	e8 43 bb ff ff       	call   80101f40 <iunlockput>
  end_op();
801063fd:	e8 1e cf ff ff       	call   80103320 <end_op>
  return -1;
80106402:	83 c4 10             	add    $0x10,%esp
80106405:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010640a:	eb 95                	jmp    801063a1 <sys_unlink+0x111>
8010640c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    dp->nlink--;
80106410:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
    iupdate(dp);
80106415:	83 ec 0c             	sub    $0xc,%esp
80106418:	56                   	push   %esi
80106419:	e8 02 b6 ff ff       	call   80101a20 <iupdate>
8010641e:	83 c4 10             	add    $0x10,%esp
80106421:	e9 53 ff ff ff       	jmp    80106379 <sys_unlink+0xe9>
    return -1;
80106426:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010642b:	e9 71 ff ff ff       	jmp    801063a1 <sys_unlink+0x111>
    end_op();
80106430:	e8 eb ce ff ff       	call   80103320 <end_op>
    return -1;
80106435:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010643a:	e9 62 ff ff ff       	jmp    801063a1 <sys_unlink+0x111>
      panic("isdirempty: readi");
8010643f:	83 ec 0c             	sub    $0xc,%esp
80106442:	68 48 98 10 80       	push   $0x80109848
80106447:	e8 44 9f ff ff       	call   80100390 <panic>
    panic("unlink: nlink < 1");
8010644c:	83 ec 0c             	sub    $0xc,%esp
8010644f:	68 36 98 10 80       	push   $0x80109836
80106454:	e8 37 9f ff ff       	call   80100390 <panic>
    panic("unlink: writei");
80106459:	83 ec 0c             	sub    $0xc,%esp
8010645c:	68 5a 98 10 80       	push   $0x8010985a
80106461:	e8 2a 9f ff ff       	call   80100390 <panic>
80106466:	8d 76 00             	lea    0x0(%esi),%esi
80106469:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106470 <sys_open>:

int
sys_open(void)
{
80106470:	55                   	push   %ebp
80106471:	89 e5                	mov    %esp,%ebp
80106473:	57                   	push   %edi
80106474:	56                   	push   %esi
80106475:	53                   	push   %ebx
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80106476:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
80106479:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
8010647c:	50                   	push   %eax
8010647d:	6a 00                	push   $0x0
8010647f:	e8 3c f7 ff ff       	call   80105bc0 <argstr>
80106484:	83 c4 10             	add    $0x10,%esp
80106487:	85 c0                	test   %eax,%eax
80106489:	0f 88 1d 01 00 00    	js     801065ac <sys_open+0x13c>
8010648f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80106492:	83 ec 08             	sub    $0x8,%esp
80106495:	50                   	push   %eax
80106496:	6a 01                	push   $0x1
80106498:	e8 73 f6 ff ff       	call   80105b10 <argint>
8010649d:	83 c4 10             	add    $0x10,%esp
801064a0:	85 c0                	test   %eax,%eax
801064a2:	0f 88 04 01 00 00    	js     801065ac <sys_open+0x13c>
    return -1;

  begin_op();
801064a8:	e8 c3 cd ff ff       	call   80103270 <begin_op>

  if(omode & O_CREATE){
801064ad:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
801064b1:	0f 85 a9 00 00 00    	jne    80106560 <sys_open+0xf0>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
801064b7:	83 ec 0c             	sub    $0xc,%esp
801064ba:	ff 75 e0             	pushl  -0x20(%ebp)
801064bd:	e8 4e c0 ff ff       	call   80102510 <namei>
801064c2:	83 c4 10             	add    $0x10,%esp
801064c5:	85 c0                	test   %eax,%eax
801064c7:	89 c6                	mov    %eax,%esi
801064c9:	0f 84 b2 00 00 00    	je     80106581 <sys_open+0x111>
      end_op();
      return -1;
    }
    ilock(ip);
801064cf:	83 ec 0c             	sub    $0xc,%esp
801064d2:	50                   	push   %eax
801064d3:	e8 f8 b5 ff ff       	call   80101ad0 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
801064d8:	83 c4 10             	add    $0x10,%esp
801064db:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
801064e0:	0f 84 aa 00 00 00    	je     80106590 <sys_open+0x120>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
801064e6:	e8 45 a9 ff ff       	call   80100e30 <filealloc>
801064eb:	85 c0                	test   %eax,%eax
801064ed:	89 c7                	mov    %eax,%edi
801064ef:	0f 84 a6 00 00 00    	je     8010659b <sys_open+0x12b>
  struct proc *curproc = myproc();
801064f5:	e8 b6 dd ff ff       	call   801042b0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801064fa:	31 db                	xor    %ebx,%ebx
801064fc:	eb 0e                	jmp    8010650c <sys_open+0x9c>
801064fe:	66 90                	xchg   %ax,%ax
80106500:	83 c3 01             	add    $0x1,%ebx
80106503:	83 fb 10             	cmp    $0x10,%ebx
80106506:	0f 84 ac 00 00 00    	je     801065b8 <sys_open+0x148>
    if(curproc->ofile[fd] == 0){
8010650c:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80106510:	85 d2                	test   %edx,%edx
80106512:	75 ec                	jne    80106500 <sys_open+0x90>
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80106514:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80106517:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
8010651b:	56                   	push   %esi
8010651c:	e8 8f b6 ff ff       	call   80101bb0 <iunlock>
  end_op();
80106521:	e8 fa cd ff ff       	call   80103320 <end_op>

  f->type = FD_INODE;
80106526:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
8010652c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010652f:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
80106532:	89 77 10             	mov    %esi,0x10(%edi)
  f->off = 0;
80106535:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
8010653c:	89 d0                	mov    %edx,%eax
8010653e:	f7 d0                	not    %eax
80106540:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80106543:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
80106546:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80106549:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
8010654d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106550:	89 d8                	mov    %ebx,%eax
80106552:	5b                   	pop    %ebx
80106553:	5e                   	pop    %esi
80106554:	5f                   	pop    %edi
80106555:	5d                   	pop    %ebp
80106556:	c3                   	ret    
80106557:	89 f6                	mov    %esi,%esi
80106559:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    ip = create(path, T_FILE, 0, 0);
80106560:	83 ec 0c             	sub    $0xc,%esp
80106563:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106566:	31 c9                	xor    %ecx,%ecx
80106568:	6a 00                	push   $0x0
8010656a:	ba 02 00 00 00       	mov    $0x2,%edx
8010656f:	e8 ec f6 ff ff       	call   80105c60 <create>
    if(ip == 0){
80106574:	83 c4 10             	add    $0x10,%esp
80106577:	85 c0                	test   %eax,%eax
    ip = create(path, T_FILE, 0, 0);
80106579:	89 c6                	mov    %eax,%esi
    if(ip == 0){
8010657b:	0f 85 65 ff ff ff    	jne    801064e6 <sys_open+0x76>
      end_op();
80106581:	e8 9a cd ff ff       	call   80103320 <end_op>
      return -1;
80106586:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
8010658b:	eb c0                	jmp    8010654d <sys_open+0xdd>
8010658d:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->type == T_DIR && omode != O_RDONLY){
80106590:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106593:	85 c9                	test   %ecx,%ecx
80106595:	0f 84 4b ff ff ff    	je     801064e6 <sys_open+0x76>
    iunlockput(ip);
8010659b:	83 ec 0c             	sub    $0xc,%esp
8010659e:	56                   	push   %esi
8010659f:	e8 9c b9 ff ff       	call   80101f40 <iunlockput>
    end_op();
801065a4:	e8 77 cd ff ff       	call   80103320 <end_op>
    return -1;
801065a9:	83 c4 10             	add    $0x10,%esp
801065ac:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801065b1:	eb 9a                	jmp    8010654d <sys_open+0xdd>
801065b3:	90                   	nop
801065b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      fileclose(f);
801065b8:	83 ec 0c             	sub    $0xc,%esp
801065bb:	57                   	push   %edi
801065bc:	e8 2f a9 ff ff       	call   80100ef0 <fileclose>
801065c1:	83 c4 10             	add    $0x10,%esp
801065c4:	eb d5                	jmp    8010659b <sys_open+0x12b>
801065c6:	8d 76 00             	lea    0x0(%esi),%esi
801065c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801065d0 <sys_mkdir>:

int
sys_mkdir(void)
{
801065d0:	55                   	push   %ebp
801065d1:	89 e5                	mov    %esp,%ebp
801065d3:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
801065d6:	e8 95 cc ff ff       	call   80103270 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
801065db:	8d 45 f4             	lea    -0xc(%ebp),%eax
801065de:	83 ec 08             	sub    $0x8,%esp
801065e1:	50                   	push   %eax
801065e2:	6a 00                	push   $0x0
801065e4:	e8 d7 f5 ff ff       	call   80105bc0 <argstr>
801065e9:	83 c4 10             	add    $0x10,%esp
801065ec:	85 c0                	test   %eax,%eax
801065ee:	78 30                	js     80106620 <sys_mkdir+0x50>
801065f0:	83 ec 0c             	sub    $0xc,%esp
801065f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801065f6:	31 c9                	xor    %ecx,%ecx
801065f8:	6a 00                	push   $0x0
801065fa:	ba 01 00 00 00       	mov    $0x1,%edx
801065ff:	e8 5c f6 ff ff       	call   80105c60 <create>
80106604:	83 c4 10             	add    $0x10,%esp
80106607:	85 c0                	test   %eax,%eax
80106609:	74 15                	je     80106620 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010660b:	83 ec 0c             	sub    $0xc,%esp
8010660e:	50                   	push   %eax
8010660f:	e8 2c b9 ff ff       	call   80101f40 <iunlockput>
  end_op();
80106614:	e8 07 cd ff ff       	call   80103320 <end_op>
  return 0;
80106619:	83 c4 10             	add    $0x10,%esp
8010661c:	31 c0                	xor    %eax,%eax
}
8010661e:	c9                   	leave  
8010661f:	c3                   	ret    
    end_op();
80106620:	e8 fb cc ff ff       	call   80103320 <end_op>
    return -1;
80106625:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010662a:	c9                   	leave  
8010662b:	c3                   	ret    
8010662c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106630 <sys_mknod>:

int
sys_mknod(void)
{
80106630:	55                   	push   %ebp
80106631:	89 e5                	mov    %esp,%ebp
80106633:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80106636:	e8 35 cc ff ff       	call   80103270 <begin_op>
  if((argstr(0, &path)) < 0 ||
8010663b:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010663e:	83 ec 08             	sub    $0x8,%esp
80106641:	50                   	push   %eax
80106642:	6a 00                	push   $0x0
80106644:	e8 77 f5 ff ff       	call   80105bc0 <argstr>
80106649:	83 c4 10             	add    $0x10,%esp
8010664c:	85 c0                	test   %eax,%eax
8010664e:	78 60                	js     801066b0 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80106650:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106653:	83 ec 08             	sub    $0x8,%esp
80106656:	50                   	push   %eax
80106657:	6a 01                	push   $0x1
80106659:	e8 b2 f4 ff ff       	call   80105b10 <argint>
  if((argstr(0, &path)) < 0 ||
8010665e:	83 c4 10             	add    $0x10,%esp
80106661:	85 c0                	test   %eax,%eax
80106663:	78 4b                	js     801066b0 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
80106665:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106668:	83 ec 08             	sub    $0x8,%esp
8010666b:	50                   	push   %eax
8010666c:	6a 02                	push   $0x2
8010666e:	e8 9d f4 ff ff       	call   80105b10 <argint>
     argint(1, &major) < 0 ||
80106673:	83 c4 10             	add    $0x10,%esp
80106676:	85 c0                	test   %eax,%eax
80106678:	78 36                	js     801066b0 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
8010667a:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
     argint(2, &minor) < 0 ||
8010667e:	83 ec 0c             	sub    $0xc,%esp
     (ip = create(path, T_DEV, major, minor)) == 0){
80106681:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
     argint(2, &minor) < 0 ||
80106685:	ba 03 00 00 00       	mov    $0x3,%edx
8010668a:	50                   	push   %eax
8010668b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010668e:	e8 cd f5 ff ff       	call   80105c60 <create>
80106693:	83 c4 10             	add    $0x10,%esp
80106696:	85 c0                	test   %eax,%eax
80106698:	74 16                	je     801066b0 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010669a:	83 ec 0c             	sub    $0xc,%esp
8010669d:	50                   	push   %eax
8010669e:	e8 9d b8 ff ff       	call   80101f40 <iunlockput>
  end_op();
801066a3:	e8 78 cc ff ff       	call   80103320 <end_op>
  return 0;
801066a8:	83 c4 10             	add    $0x10,%esp
801066ab:	31 c0                	xor    %eax,%eax
}
801066ad:	c9                   	leave  
801066ae:	c3                   	ret    
801066af:	90                   	nop
    end_op();
801066b0:	e8 6b cc ff ff       	call   80103320 <end_op>
    return -1;
801066b5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801066ba:	c9                   	leave  
801066bb:	c3                   	ret    
801066bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801066c0 <sys_chdir>:

int
sys_chdir(void)
{
801066c0:	55                   	push   %ebp
801066c1:	89 e5                	mov    %esp,%ebp
801066c3:	56                   	push   %esi
801066c4:	53                   	push   %ebx
801066c5:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
801066c8:	e8 e3 db ff ff       	call   801042b0 <myproc>
801066cd:	89 c6                	mov    %eax,%esi
  
  begin_op();
801066cf:	e8 9c cb ff ff       	call   80103270 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
801066d4:	8d 45 f4             	lea    -0xc(%ebp),%eax
801066d7:	83 ec 08             	sub    $0x8,%esp
801066da:	50                   	push   %eax
801066db:	6a 00                	push   $0x0
801066dd:	e8 de f4 ff ff       	call   80105bc0 <argstr>
801066e2:	83 c4 10             	add    $0x10,%esp
801066e5:	85 c0                	test   %eax,%eax
801066e7:	78 77                	js     80106760 <sys_chdir+0xa0>
801066e9:	83 ec 0c             	sub    $0xc,%esp
801066ec:	ff 75 f4             	pushl  -0xc(%ebp)
801066ef:	e8 1c be ff ff       	call   80102510 <namei>
801066f4:	83 c4 10             	add    $0x10,%esp
801066f7:	85 c0                	test   %eax,%eax
801066f9:	89 c3                	mov    %eax,%ebx
801066fb:	74 63                	je     80106760 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
801066fd:	83 ec 0c             	sub    $0xc,%esp
80106700:	50                   	push   %eax
80106701:	e8 ca b3 ff ff       	call   80101ad0 <ilock>
  if(ip->type != T_DIR){
80106706:	83 c4 10             	add    $0x10,%esp
80106709:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
8010670e:	75 30                	jne    80106740 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80106710:	83 ec 0c             	sub    $0xc,%esp
80106713:	53                   	push   %ebx
80106714:	e8 97 b4 ff ff       	call   80101bb0 <iunlock>
  iput(curproc->cwd);
80106719:	58                   	pop    %eax
8010671a:	ff 76 68             	pushl  0x68(%esi)
8010671d:	e8 de b4 ff ff       	call   80101c00 <iput>
  end_op();
80106722:	e8 f9 cb ff ff       	call   80103320 <end_op>
  curproc->cwd = ip;
80106727:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
8010672a:	83 c4 10             	add    $0x10,%esp
8010672d:	31 c0                	xor    %eax,%eax
}
8010672f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106732:	5b                   	pop    %ebx
80106733:	5e                   	pop    %esi
80106734:	5d                   	pop    %ebp
80106735:	c3                   	ret    
80106736:	8d 76 00             	lea    0x0(%esi),%esi
80106739:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    iunlockput(ip);
80106740:	83 ec 0c             	sub    $0xc,%esp
80106743:	53                   	push   %ebx
80106744:	e8 f7 b7 ff ff       	call   80101f40 <iunlockput>
    end_op();
80106749:	e8 d2 cb ff ff       	call   80103320 <end_op>
    return -1;
8010674e:	83 c4 10             	add    $0x10,%esp
80106751:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106756:	eb d7                	jmp    8010672f <sys_chdir+0x6f>
80106758:	90                   	nop
80106759:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    end_op();
80106760:	e8 bb cb ff ff       	call   80103320 <end_op>
    return -1;
80106765:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010676a:	eb c3                	jmp    8010672f <sys_chdir+0x6f>
8010676c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106770 <sys_exec>:

int
sys_exec(void)
{
80106770:	55                   	push   %ebp
80106771:	89 e5                	mov    %esp,%ebp
80106773:	57                   	push   %edi
80106774:	56                   	push   %esi
80106775:	53                   	push   %ebx
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80106776:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
8010677c:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80106782:	50                   	push   %eax
80106783:	6a 00                	push   $0x0
80106785:	e8 36 f4 ff ff       	call   80105bc0 <argstr>
8010678a:	83 c4 10             	add    $0x10,%esp
8010678d:	85 c0                	test   %eax,%eax
8010678f:	0f 88 87 00 00 00    	js     8010681c <sys_exec+0xac>
80106795:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
8010679b:	83 ec 08             	sub    $0x8,%esp
8010679e:	50                   	push   %eax
8010679f:	6a 01                	push   $0x1
801067a1:	e8 6a f3 ff ff       	call   80105b10 <argint>
801067a6:	83 c4 10             	add    $0x10,%esp
801067a9:	85 c0                	test   %eax,%eax
801067ab:	78 6f                	js     8010681c <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
801067ad:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
801067b3:	83 ec 04             	sub    $0x4,%esp
  for(i=0;; i++){
801067b6:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
801067b8:	68 80 00 00 00       	push   $0x80
801067bd:	6a 00                	push   $0x0
801067bf:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
801067c5:	50                   	push   %eax
801067c6:	e8 45 f0 ff ff       	call   80105810 <memset>
801067cb:	83 c4 10             	add    $0x10,%esp
801067ce:	eb 2c                	jmp    801067fc <sys_exec+0x8c>
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
      return -1;
    if(uarg == 0){
801067d0:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
801067d6:	85 c0                	test   %eax,%eax
801067d8:	74 56                	je     80106830 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
801067da:	8d 8d 68 ff ff ff    	lea    -0x98(%ebp),%ecx
801067e0:	83 ec 08             	sub    $0x8,%esp
801067e3:	8d 14 31             	lea    (%ecx,%esi,1),%edx
801067e6:	52                   	push   %edx
801067e7:	50                   	push   %eax
801067e8:	e8 b3 f2 ff ff       	call   80105aa0 <fetchstr>
801067ed:	83 c4 10             	add    $0x10,%esp
801067f0:	85 c0                	test   %eax,%eax
801067f2:	78 28                	js     8010681c <sys_exec+0xac>
  for(i=0;; i++){
801067f4:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
801067f7:	83 fb 20             	cmp    $0x20,%ebx
801067fa:	74 20                	je     8010681c <sys_exec+0xac>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
801067fc:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80106802:	8d 34 9d 00 00 00 00 	lea    0x0(,%ebx,4),%esi
80106809:	83 ec 08             	sub    $0x8,%esp
8010680c:	57                   	push   %edi
8010680d:	01 f0                	add    %esi,%eax
8010680f:	50                   	push   %eax
80106810:	e8 4b f2 ff ff       	call   80105a60 <fetchint>
80106815:	83 c4 10             	add    $0x10,%esp
80106818:	85 c0                	test   %eax,%eax
8010681a:	79 b4                	jns    801067d0 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
8010681c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
8010681f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106824:	5b                   	pop    %ebx
80106825:	5e                   	pop    %esi
80106826:	5f                   	pop    %edi
80106827:	5d                   	pop    %ebp
80106828:	c3                   	ret    
80106829:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return exec(path, argv);
80106830:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80106836:	83 ec 08             	sub    $0x8,%esp
      argv[i] = 0;
80106839:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80106840:	00 00 00 00 
  return exec(path, argv);
80106844:	50                   	push   %eax
80106845:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
8010684b:	e8 c0 a1 ff ff       	call   80100a10 <exec>
80106850:	83 c4 10             	add    $0x10,%esp
}
80106853:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106856:	5b                   	pop    %ebx
80106857:	5e                   	pop    %esi
80106858:	5f                   	pop    %edi
80106859:	5d                   	pop    %ebp
8010685a:	c3                   	ret    
8010685b:	90                   	nop
8010685c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106860 <sys_pipe>:

int
sys_pipe(void)
{
80106860:	55                   	push   %ebp
80106861:	89 e5                	mov    %esp,%ebp
80106863:	57                   	push   %edi
80106864:	56                   	push   %esi
80106865:	53                   	push   %ebx
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80106866:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
80106869:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
8010686c:	6a 08                	push   $0x8
8010686e:	50                   	push   %eax
8010686f:	6a 00                	push   $0x0
80106871:	e8 ea f2 ff ff       	call   80105b60 <argptr>
80106876:	83 c4 10             	add    $0x10,%esp
80106879:	85 c0                	test   %eax,%eax
8010687b:	0f 88 ae 00 00 00    	js     8010692f <sys_pipe+0xcf>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80106881:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80106884:	83 ec 08             	sub    $0x8,%esp
80106887:	50                   	push   %eax
80106888:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010688b:	50                   	push   %eax
8010688c:	e8 4f d1 ff ff       	call   801039e0 <pipealloc>
80106891:	83 c4 10             	add    $0x10,%esp
80106894:	85 c0                	test   %eax,%eax
80106896:	0f 88 93 00 00 00    	js     8010692f <sys_pipe+0xcf>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
8010689c:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
8010689f:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
801068a1:	e8 0a da ff ff       	call   801042b0 <myproc>
801068a6:	eb 10                	jmp    801068b8 <sys_pipe+0x58>
801068a8:	90                   	nop
801068a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(fd = 0; fd < NOFILE; fd++){
801068b0:	83 c3 01             	add    $0x1,%ebx
801068b3:	83 fb 10             	cmp    $0x10,%ebx
801068b6:	74 60                	je     80106918 <sys_pipe+0xb8>
    if(curproc->ofile[fd] == 0){
801068b8:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
801068bc:	85 f6                	test   %esi,%esi
801068be:	75 f0                	jne    801068b0 <sys_pipe+0x50>
      curproc->ofile[fd] = f;
801068c0:	8d 73 08             	lea    0x8(%ebx),%esi
801068c3:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801068c7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
801068ca:	e8 e1 d9 ff ff       	call   801042b0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801068cf:	31 d2                	xor    %edx,%edx
801068d1:	eb 0d                	jmp    801068e0 <sys_pipe+0x80>
801068d3:	90                   	nop
801068d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801068d8:	83 c2 01             	add    $0x1,%edx
801068db:	83 fa 10             	cmp    $0x10,%edx
801068de:	74 28                	je     80106908 <sys_pipe+0xa8>
    if(curproc->ofile[fd] == 0){
801068e0:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
801068e4:	85 c9                	test   %ecx,%ecx
801068e6:	75 f0                	jne    801068d8 <sys_pipe+0x78>
      curproc->ofile[fd] = f;
801068e8:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
801068ec:	8b 45 dc             	mov    -0x24(%ebp),%eax
801068ef:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
801068f1:	8b 45 dc             	mov    -0x24(%ebp),%eax
801068f4:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
801068f7:	31 c0                	xor    %eax,%eax
}
801068f9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801068fc:	5b                   	pop    %ebx
801068fd:	5e                   	pop    %esi
801068fe:	5f                   	pop    %edi
801068ff:	5d                   	pop    %ebp
80106900:	c3                   	ret    
80106901:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      myproc()->ofile[fd0] = 0;
80106908:	e8 a3 d9 ff ff       	call   801042b0 <myproc>
8010690d:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80106914:	00 
80106915:	8d 76 00             	lea    0x0(%esi),%esi
    fileclose(rf);
80106918:	83 ec 0c             	sub    $0xc,%esp
8010691b:	ff 75 e0             	pushl  -0x20(%ebp)
8010691e:	e8 cd a5 ff ff       	call   80100ef0 <fileclose>
    fileclose(wf);
80106923:	58                   	pop    %eax
80106924:	ff 75 e4             	pushl  -0x1c(%ebp)
80106927:	e8 c4 a5 ff ff       	call   80100ef0 <fileclose>
    return -1;
8010692c:	83 c4 10             	add    $0x10,%esp
8010692f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106934:	eb c3                	jmp    801068f9 <sys_pipe+0x99>
80106936:	8d 76 00             	lea    0x0(%esi),%esi
80106939:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106940 <sys_sync>:

int
sys_sync(void)
{
80106940:	55                   	push   %ebp
80106941:	89 e5                	mov    %esp,%ebp
80106943:	83 ec 08             	sub    $0x8,%esp
  sync();
80106946:	e8 45 cb ff ff       	call   80103490 <sync>
  return 0;
}
8010694b:	31 c0                	xor    %eax,%eax
8010694d:	c9                   	leave  
8010694e:	c3                   	ret    
8010694f:	90                   	nop

80106950 <sys_get_log_num>:

int
sys_get_log_num(void)
{
80106950:	55                   	push   %ebp
80106951:	89 e5                	mov    %esp,%ebp
  return get_log_num();
}
80106953:	5d                   	pop    %ebp
  return get_log_num();
80106954:	e9 a7 cb ff ff       	jmp    80103500 <get_log_num>
80106959:	66 90                	xchg   %ax,%ax
8010695b:	66 90                	xchg   %ax,%ax
8010695d:	66 90                	xchg   %ax,%ax
8010695f:	90                   	nop

80106960 <sys_yield>:
#include "proc.h"

/* hw1 - yield_wrapper */
int
sys_yield(void)
{
80106960:	55                   	push   %ebp
80106961:	89 e5                	mov    %esp,%ebp
80106963:	83 ec 08             	sub    $0x8,%esp
	yield();
80106966:	e8 95 de ff ff       	call   80104800 <yield>
	return 0; // not reached
}
8010696b:	31 c0                	xor    %eax,%eax
8010696d:	c9                   	leave  
8010696e:	c3                   	ret    
8010696f:	90                   	nop

80106970 <sys_fork>:

int
sys_fork(void)
{
80106970:	55                   	push   %ebp
80106971:	89 e5                	mov    %esp,%ebp
  return fork();
}
80106973:	5d                   	pop    %ebp
  return fork();
80106974:	e9 a7 db ff ff       	jmp    80104520 <fork>
80106979:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106980 <sys_exit>:

int
sys_exit(void)
{
80106980:	55                   	push   %ebp
80106981:	89 e5                	mov    %esp,%ebp
80106983:	83 ec 08             	sub    $0x8,%esp
  exit();
80106986:	e8 d5 df ff ff       	call   80104960 <exit>
  return 0;  // not reached
}
8010698b:	31 c0                	xor    %eax,%eax
8010698d:	c9                   	leave  
8010698e:	c3                   	ret    
8010698f:	90                   	nop

80106990 <sys_wait>:

int
sys_wait(void)
{
80106990:	55                   	push   %ebp
80106991:	89 e5                	mov    %esp,%ebp
  return wait();
}
80106993:	5d                   	pop    %ebp
  return wait();
80106994:	e9 47 e2 ff ff       	jmp    80104be0 <wait>
80106999:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801069a0 <sys_kill>:

int
sys_kill(void)
{
801069a0:	55                   	push   %ebp
801069a1:	89 e5                	mov    %esp,%ebp
801069a3:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
801069a6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801069a9:	50                   	push   %eax
801069aa:	6a 00                	push   $0x0
801069ac:	e8 5f f1 ff ff       	call   80105b10 <argint>
801069b1:	83 c4 10             	add    $0x10,%esp
801069b4:	85 c0                	test   %eax,%eax
801069b6:	78 18                	js     801069d0 <sys_kill+0x30>
    return -1;
  return kill(pid);
801069b8:	83 ec 0c             	sub    $0xc,%esp
801069bb:	ff 75 f4             	pushl  -0xc(%ebp)
801069be:	e8 8d e3 ff ff       	call   80104d50 <kill>
801069c3:	83 c4 10             	add    $0x10,%esp
}
801069c6:	c9                   	leave  
801069c7:	c3                   	ret    
801069c8:	90                   	nop
801069c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801069d0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801069d5:	c9                   	leave  
801069d6:	c3                   	ret    
801069d7:	89 f6                	mov    %esi,%esi
801069d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801069e0 <sys_getppid>:

int
sys_getppid(void)
{
801069e0:	55                   	push   %ebp
801069e1:	89 e5                	mov    %esp,%ebp
	return getppid();
}
801069e3:	5d                   	pop    %ebp
	return getppid();
801069e4:	e9 77 e5 ff ff       	jmp    80104f60 <getppid>
801069e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801069f0 <sys_getpid>:

int
sys_getpid(void)
{
801069f0:	55                   	push   %ebp
801069f1:	89 e5                	mov    %esp,%ebp
801069f3:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
801069f6:	e8 b5 d8 ff ff       	call   801042b0 <myproc>
801069fb:	8b 40 10             	mov    0x10(%eax),%eax
}
801069fe:	c9                   	leave  
801069ff:	c3                   	ret    

80106a00 <sys_sbrk>:

int
sys_sbrk(void)
{
80106a00:	55                   	push   %ebp
80106a01:	89 e5                	mov    %esp,%ebp
80106a03:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80106a04:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80106a07:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80106a0a:	50                   	push   %eax
80106a0b:	6a 00                	push   $0x0
80106a0d:	e8 fe f0 ff ff       	call   80105b10 <argint>
80106a12:	83 c4 10             	add    $0x10,%esp
80106a15:	85 c0                	test   %eax,%eax
80106a17:	78 27                	js     80106a40 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->master->sz;
80106a19:	e8 92 d8 ff ff       	call   801042b0 <myproc>
80106a1e:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
  if(growproc(n) < 0)
80106a24:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->master->sz;
80106a27:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80106a29:	ff 75 f4             	pushl  -0xc(%ebp)
80106a2c:	e8 5f da ff ff       	call   80104490 <growproc>
80106a31:	83 c4 10             	add    $0x10,%esp
80106a34:	85 c0                	test   %eax,%eax
80106a36:	78 08                	js     80106a40 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80106a38:	89 d8                	mov    %ebx,%eax
80106a3a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106a3d:	c9                   	leave  
80106a3e:	c3                   	ret    
80106a3f:	90                   	nop
    return -1;
80106a40:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80106a45:	eb f1                	jmp    80106a38 <sys_sbrk+0x38>
80106a47:	89 f6                	mov    %esi,%esi
80106a49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106a50 <sys_sleep>:

int
sys_sleep(void)
{
80106a50:	55                   	push   %ebp
80106a51:	89 e5                	mov    %esp,%ebp
80106a53:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80106a54:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80106a57:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80106a5a:	50                   	push   %eax
80106a5b:	6a 00                	push   $0x0
80106a5d:	e8 ae f0 ff ff       	call   80105b10 <argint>
80106a62:	83 c4 10             	add    $0x10,%esp
80106a65:	85 c0                	test   %eax,%eax
80106a67:	0f 88 8a 00 00 00    	js     80106af7 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
80106a6d:	83 ec 0c             	sub    $0xc,%esp
80106a70:	68 80 c7 11 80       	push   $0x8011c780
80106a75:	e8 86 ec ff ff       	call   80105700 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80106a7a:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106a7d:	83 c4 10             	add    $0x10,%esp
  ticks0 = ticks;
80106a80:	8b 1d c0 cf 11 80    	mov    0x8011cfc0,%ebx
  while(ticks - ticks0 < n){
80106a86:	85 d2                	test   %edx,%edx
80106a88:	75 27                	jne    80106ab1 <sys_sleep+0x61>
80106a8a:	eb 54                	jmp    80106ae0 <sys_sleep+0x90>
80106a8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80106a90:	83 ec 08             	sub    $0x8,%esp
80106a93:	68 80 c7 11 80       	push   $0x8011c780
80106a98:	68 c0 cf 11 80       	push   $0x8011cfc0
80106a9d:	e8 fe dd ff ff       	call   801048a0 <sleep>
  while(ticks - ticks0 < n){
80106aa2:	a1 c0 cf 11 80       	mov    0x8011cfc0,%eax
80106aa7:	83 c4 10             	add    $0x10,%esp
80106aaa:	29 d8                	sub    %ebx,%eax
80106aac:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80106aaf:	73 2f                	jae    80106ae0 <sys_sleep+0x90>
    if(myproc()->killed){
80106ab1:	e8 fa d7 ff ff       	call   801042b0 <myproc>
80106ab6:	8b 40 24             	mov    0x24(%eax),%eax
80106ab9:	85 c0                	test   %eax,%eax
80106abb:	74 d3                	je     80106a90 <sys_sleep+0x40>
      release(&tickslock);
80106abd:	83 ec 0c             	sub    $0xc,%esp
80106ac0:	68 80 c7 11 80       	push   $0x8011c780
80106ac5:	e8 f6 ec ff ff       	call   801057c0 <release>
      return -1;
80106aca:	83 c4 10             	add    $0x10,%esp
80106acd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  release(&tickslock);
  return 0;
}
80106ad2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106ad5:	c9                   	leave  
80106ad6:	c3                   	ret    
80106ad7:	89 f6                	mov    %esi,%esi
80106ad9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  release(&tickslock);
80106ae0:	83 ec 0c             	sub    $0xc,%esp
80106ae3:	68 80 c7 11 80       	push   $0x8011c780
80106ae8:	e8 d3 ec ff ff       	call   801057c0 <release>
  return 0;
80106aed:	83 c4 10             	add    $0x10,%esp
80106af0:	31 c0                	xor    %eax,%eax
}
80106af2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106af5:	c9                   	leave  
80106af6:	c3                   	ret    
    return -1;
80106af7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106afc:	eb f4                	jmp    80106af2 <sys_sleep+0xa2>
80106afe:	66 90                	xchg   %ax,%ax

80106b00 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80106b00:	55                   	push   %ebp
80106b01:	89 e5                	mov    %esp,%ebp
80106b03:	53                   	push   %ebx
80106b04:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80106b07:	68 80 c7 11 80       	push   $0x8011c780
80106b0c:	e8 ef eb ff ff       	call   80105700 <acquire>
  xticks = ticks;
80106b11:	8b 1d c0 cf 11 80    	mov    0x8011cfc0,%ebx
  release(&tickslock);
80106b17:	c7 04 24 80 c7 11 80 	movl   $0x8011c780,(%esp)
80106b1e:	e8 9d ec ff ff       	call   801057c0 <release>
  return xticks;
}
80106b23:	89 d8                	mov    %ebx,%eax
80106b25:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106b28:	c9                   	leave  
80106b29:	c3                   	ret    
80106b2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106b30 <sys_getlev>:

int
sys_getlev(void)
{
80106b30:	55                   	push   %ebp
80106b31:	89 e5                	mov    %esp,%ebp
	return getlev();
}
80106b33:	5d                   	pop    %ebp
	return getlev();
80106b34:	e9 f7 21 00 00       	jmp    80108d30 <getlev>
80106b39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106b40 <sys_set_cpu_share>:

int
sys_set_cpu_share(void)
{
80106b40:	55                   	push   %ebp
80106b41:	89 e5                	mov    %esp,%ebp
80106b43:	83 ec 20             	sub    $0x20,%esp
	int n;
	if(argint(0, &n) < 0)
80106b46:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106b49:	50                   	push   %eax
80106b4a:	6a 00                	push   $0x0
80106b4c:	e8 bf ef ff ff       	call   80105b10 <argint>
80106b51:	83 c4 10             	add    $0x10,%esp
80106b54:	85 c0                	test   %eax,%eax
80106b56:	78 18                	js     80106b70 <sys_set_cpu_share+0x30>
	{
		return -1;
	}
	return set_cpu_share(n);
80106b58:	83 ec 0c             	sub    $0xc,%esp
80106b5b:	ff 75 f4             	pushl  -0xc(%ebp)
80106b5e:	e8 7d 20 00 00       	call   80108be0 <set_cpu_share>
80106b63:	83 c4 10             	add    $0x10,%esp
}
80106b66:	c9                   	leave  
80106b67:	c3                   	ret    
80106b68:	90                   	nop
80106b69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
		return -1;
80106b70:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106b75:	c9                   	leave  
80106b76:	c3                   	ret    
80106b77:	89 f6                	mov    %esi,%esi
80106b79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106b80 <sys_thread_create>:

int
sys_thread_create(void)
{
80106b80:	55                   	push   %ebp
80106b81:	89 e5                	mov    %esp,%ebp
80106b83:	83 ec 20             	sub    $0x20,%esp
	thread_t* thread;
	void* start_routine;
	void* arg;

	if(argint(0, (int*)&thread)<0)
80106b86:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106b89:	50                   	push   %eax
80106b8a:	6a 00                	push   $0x0
80106b8c:	e8 7f ef ff ff       	call   80105b10 <argint>
80106b91:	83 c4 10             	add    $0x10,%esp
80106b94:	85 c0                	test   %eax,%eax
80106b96:	78 48                	js     80106be0 <sys_thread_create+0x60>
  {
    return -1;
  }

	if(argint(1, (int*)&start_routine))
80106b98:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106b9b:	83 ec 08             	sub    $0x8,%esp
80106b9e:	50                   	push   %eax
80106b9f:	6a 01                	push   $0x1
80106ba1:	e8 6a ef ff ff       	call   80105b10 <argint>
80106ba6:	83 c4 10             	add    $0x10,%esp
80106ba9:	85 c0                	test   %eax,%eax
80106bab:	75 33                	jne    80106be0 <sys_thread_create+0x60>
  {
    return -1;
  }
	if(argint(2, (int*)&arg))
80106bad:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106bb0:	83 ec 08             	sub    $0x8,%esp
80106bb3:	50                   	push   %eax
80106bb4:	6a 02                	push   $0x2
80106bb6:	e8 55 ef ff ff       	call   80105b10 <argint>
80106bbb:	83 c4 10             	add    $0x10,%esp
80106bbe:	85 c0                	test   %eax,%eax
80106bc0:	75 1e                	jne    80106be0 <sys_thread_create+0x60>
  {
    return -1;
  }
	return thread_create(thread, start_routine, arg);
80106bc2:	83 ec 04             	sub    $0x4,%esp
80106bc5:	ff 75 f4             	pushl  -0xc(%ebp)
80106bc8:	ff 75 f0             	pushl  -0x10(%ebp)
80106bcb:	ff 75 ec             	pushl  -0x14(%ebp)
80106bce:	e8 bd e3 ff ff       	call   80104f90 <thread_create>
80106bd3:	83 c4 10             	add    $0x10,%esp
}
80106bd6:	c9                   	leave  
80106bd7:	c3                   	ret    
80106bd8:	90                   	nop
80106bd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80106be0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106be5:	c9                   	leave  
80106be6:	c3                   	ret    
80106be7:	89 f6                	mov    %esi,%esi
80106be9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106bf0 <sys_thread_exit>:

void
sys_thread_exit(void)
{
80106bf0:	55                   	push   %ebp
80106bf1:	89 e5                	mov    %esp,%ebp
80106bf3:	83 ec 20             	sub    $0x20,%esp
	void* retval;
	argint(0, (int*)&retval);
80106bf6:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106bf9:	50                   	push   %eax
80106bfa:	6a 00                	push   $0x0
80106bfc:	e8 0f ef ff ff       	call   80105b10 <argint>
	thread_exit(retval);
80106c01:	58                   	pop    %eax
80106c02:	ff 75 f4             	pushl  -0xc(%ebp)
80106c05:	e8 56 e6 ff ff       	call   80105260 <thread_exit>
}
80106c0a:	83 c4 10             	add    $0x10,%esp
80106c0d:	c9                   	leave  
80106c0e:	c3                   	ret    
80106c0f:	90                   	nop

80106c10 <sys_thread_join>:

int
sys_thread_join(void)
{
80106c10:	55                   	push   %ebp
80106c11:	89 e5                	mov    %esp,%ebp
80106c13:	83 ec 20             	sub    $0x20,%esp
	thread_t thread;
	void** retval;
	if(argint(0, (int*)&thread) < 0)
80106c16:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106c19:	50                   	push   %eax
80106c1a:	6a 00                	push   $0x0
80106c1c:	e8 ef ee ff ff       	call   80105b10 <argint>
80106c21:	83 c4 10             	add    $0x10,%esp
80106c24:	85 c0                	test   %eax,%eax
80106c26:	78 28                	js     80106c50 <sys_thread_join+0x40>
  {
    return -1;
  }
  
	if(argint(1, (int*)&retval))
80106c28:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106c2b:	83 ec 08             	sub    $0x8,%esp
80106c2e:	50                   	push   %eax
80106c2f:	6a 01                	push   $0x1
80106c31:	e8 da ee ff ff       	call   80105b10 <argint>
80106c36:	83 c4 10             	add    $0x10,%esp
80106c39:	85 c0                	test   %eax,%eax
80106c3b:	75 13                	jne    80106c50 <sys_thread_join+0x40>
  {
    return -1;
  }
	return thread_join(thread, retval);
80106c3d:	83 ec 08             	sub    $0x8,%esp
80106c40:	ff 75 f4             	pushl  -0xc(%ebp)
80106c43:	ff 75 f0             	pushl  -0x10(%ebp)
80106c46:	e8 55 e7 ff ff       	call   801053a0 <thread_join>
80106c4b:	83 c4 10             	add    $0x10,%esp
}
80106c4e:	c9                   	leave  
80106c4f:	c3                   	ret    
    return -1;
80106c50:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106c55:	c9                   	leave  
80106c56:	c3                   	ret    

80106c57 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80106c57:	1e                   	push   %ds
  pushl %es
80106c58:	06                   	push   %es
  pushl %fs
80106c59:	0f a0                	push   %fs
  pushl %gs
80106c5b:	0f a8                	push   %gs
  pushal
80106c5d:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80106c5e:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80106c62:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80106c64:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80106c66:	54                   	push   %esp
  call trap
80106c67:	e8 c4 00 00 00       	call   80106d30 <trap>
  addl $4, %esp
80106c6c:	83 c4 04             	add    $0x4,%esp

80106c6f <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80106c6f:	61                   	popa   
  popl %gs
80106c70:	0f a9                	pop    %gs
  popl %fs
80106c72:	0f a1                	pop    %fs
  popl %es
80106c74:	07                   	pop    %es
  popl %ds
80106c75:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80106c76:	83 c4 08             	add    $0x8,%esp
  iret
80106c79:	cf                   	iret   
80106c7a:	66 90                	xchg   %ax,%ax
80106c7c:	66 90                	xchg   %ax,%ax
80106c7e:	66 90                	xchg   %ax,%ax

80106c80 <tvinit>:
  struct proc proc[NPROC];
} ptable;

void
tvinit(void)
{
80106c80:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80106c81:	31 c0                	xor    %eax,%eax
{
80106c83:	89 e5                	mov    %esp,%ebp
80106c85:	83 ec 08             	sub    $0x8,%esp
80106c88:	90                   	nop
80106c89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80106c90:	8b 14 85 0c c0 10 80 	mov    -0x7fef3ff4(,%eax,4),%edx
80106c97:	c7 04 c5 c2 c7 11 80 	movl   $0x8e000008,-0x7fee383e(,%eax,8)
80106c9e:	08 00 00 8e 
80106ca2:	66 89 14 c5 c0 c7 11 	mov    %dx,-0x7fee3840(,%eax,8)
80106ca9:	80 
80106caa:	c1 ea 10             	shr    $0x10,%edx
80106cad:	66 89 14 c5 c6 c7 11 	mov    %dx,-0x7fee383a(,%eax,8)
80106cb4:	80 
  for(i = 0; i < 256; i++)
80106cb5:	83 c0 01             	add    $0x1,%eax
80106cb8:	3d 00 01 00 00       	cmp    $0x100,%eax
80106cbd:	75 d1                	jne    80106c90 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80106cbf:	a1 0c c1 10 80       	mov    0x8010c10c,%eax

  initlock(&tickslock, "time");
80106cc4:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80106cc7:	c7 05 c2 c9 11 80 08 	movl   $0xef000008,0x8011c9c2
80106cce:	00 00 ef 
  initlock(&tickslock, "time");
80106cd1:	68 69 98 10 80       	push   $0x80109869
80106cd6:	68 80 c7 11 80       	push   $0x8011c780
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80106cdb:	66 a3 c0 c9 11 80    	mov    %ax,0x8011c9c0
80106ce1:	c1 e8 10             	shr    $0x10,%eax
80106ce4:	66 a3 c6 c9 11 80    	mov    %ax,0x8011c9c6
  initlock(&tickslock, "time");
80106cea:	e8 d1 e8 ff ff       	call   801055c0 <initlock>
}
80106cef:	83 c4 10             	add    $0x10,%esp
80106cf2:	c9                   	leave  
80106cf3:	c3                   	ret    
80106cf4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106cfa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80106d00 <idtinit>:

void
idtinit(void)
{
80106d00:	55                   	push   %ebp
  pd[0] = size-1;
80106d01:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80106d06:	89 e5                	mov    %esp,%ebp
80106d08:	83 ec 10             	sub    $0x10,%esp
80106d0b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80106d0f:	b8 c0 c7 11 80       	mov    $0x8011c7c0,%eax
80106d14:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80106d18:	c1 e8 10             	shr    $0x10,%eax
80106d1b:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80106d1f:	8d 45 fa             	lea    -0x6(%ebp),%eax
80106d22:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80106d25:	c9                   	leave  
80106d26:	c3                   	ret    
80106d27:	89 f6                	mov    %esi,%esi
80106d29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106d30 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80106d30:	55                   	push   %ebp
80106d31:	89 e5                	mov    %esp,%ebp
80106d33:	57                   	push   %edi
80106d34:	56                   	push   %esi
80106d35:	53                   	push   %ebx
80106d36:	83 ec 1c             	sub    $0x1c,%esp
80106d39:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(tf->trapno == T_SYSCALL){
80106d3c:	8b 47 30             	mov    0x30(%edi),%eax
80106d3f:	83 f8 40             	cmp    $0x40,%eax
80106d42:	0f 84 f0 00 00 00    	je     80106e38 <trap+0x108>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80106d48:	83 e8 20             	sub    $0x20,%eax
80106d4b:	83 f8 1f             	cmp    $0x1f,%eax
80106d4e:	77 10                	ja     80106d60 <trap+0x30>
80106d50:	ff 24 85 10 99 10 80 	jmp    *-0x7fef66f0(,%eax,4)
80106d57:	89 f6                	mov    %esi,%esi
80106d59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    lapiceoi();
    break;

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
80106d60:	e8 4b d5 ff ff       	call   801042b0 <myproc>
80106d65:	85 c0                	test   %eax,%eax
80106d67:	8b 5f 38             	mov    0x38(%edi),%ebx
80106d6a:	0f 84 6e 02 00 00    	je     80106fde <trap+0x2ae>
80106d70:	f6 47 3c 03          	testb  $0x3,0x3c(%edi)
80106d74:	0f 84 64 02 00 00    	je     80106fde <trap+0x2ae>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80106d7a:	0f 20 d1             	mov    %cr2,%ecx
80106d7d:	89 4d d8             	mov    %ecx,-0x28(%ebp)
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106d80:	e8 0b d5 ff ff       	call   80104290 <cpuid>
80106d85:	89 45 dc             	mov    %eax,-0x24(%ebp)
80106d88:	8b 47 34             	mov    0x34(%edi),%eax
80106d8b:	8b 77 30             	mov    0x30(%edi),%esi
80106d8e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80106d91:	e8 1a d5 ff ff       	call   801042b0 <myproc>
80106d96:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106d99:	e8 12 d5 ff ff       	call   801042b0 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106d9e:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80106da1:	8b 55 dc             	mov    -0x24(%ebp),%edx
80106da4:	51                   	push   %ecx
80106da5:	53                   	push   %ebx
80106da6:	52                   	push   %edx
            myproc()->pid, myproc()->name, tf->trapno,
80106da7:	8b 55 e0             	mov    -0x20(%ebp),%edx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106daa:	ff 75 e4             	pushl  -0x1c(%ebp)
80106dad:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
80106dae:	83 c2 6c             	add    $0x6c,%edx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106db1:	52                   	push   %edx
80106db2:	ff 70 10             	pushl  0x10(%eax)
80106db5:	68 cc 98 10 80       	push   $0x801098cc
80106dba:	e8 a1 98 ff ff       	call   80100660 <cprintf>
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
80106dbf:	83 c4 20             	add    $0x20,%esp
80106dc2:	e8 e9 d4 ff ff       	call   801042b0 <myproc>
80106dc7:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106dce:	e8 dd d4 ff ff       	call   801042b0 <myproc>
80106dd3:	85 c0                	test   %eax,%eax
80106dd5:	74 1d                	je     80106df4 <trap+0xc4>
80106dd7:	e8 d4 d4 ff ff       	call   801042b0 <myproc>
80106ddc:	8b 48 24             	mov    0x24(%eax),%ecx
80106ddf:	85 c9                	test   %ecx,%ecx
80106de1:	74 11                	je     80106df4 <trap+0xc4>
80106de3:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80106de7:	83 e0 03             	and    $0x3,%eax
80106dea:	66 83 f8 03          	cmp    $0x3,%ax
80106dee:	0f 84 5c 01 00 00    	je     80106f50 <trap+0x220>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER)
80106df4:	e8 b7 d4 ff ff       	call   801042b0 <myproc>
80106df9:	85 c0                	test   %eax,%eax
80106dfb:	74 0b                	je     80106e08 <trap+0xd8>
80106dfd:	e8 ae d4 ff ff       	call   801042b0 <myproc>
80106e02:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80106e06:	74 68                	je     80106e70 <trap+0x140>
      }
    }
  }

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106e08:	e8 a3 d4 ff ff       	call   801042b0 <myproc>
80106e0d:	85 c0                	test   %eax,%eax
80106e0f:	74 19                	je     80106e2a <trap+0xfa>
80106e11:	e8 9a d4 ff ff       	call   801042b0 <myproc>
80106e16:	8b 40 24             	mov    0x24(%eax),%eax
80106e19:	85 c0                	test   %eax,%eax
80106e1b:	74 0d                	je     80106e2a <trap+0xfa>
80106e1d:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80106e21:	83 e0 03             	and    $0x3,%eax
80106e24:	66 83 f8 03          	cmp    $0x3,%ax
80106e28:	74 37                	je     80106e61 <trap+0x131>
    exit();
}
80106e2a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106e2d:	5b                   	pop    %ebx
80106e2e:	5e                   	pop    %esi
80106e2f:	5f                   	pop    %edi
80106e30:	5d                   	pop    %ebp
80106e31:	c3                   	ret    
80106e32:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(myproc()->killed)
80106e38:	e8 73 d4 ff ff       	call   801042b0 <myproc>
80106e3d:	8b 70 24             	mov    0x24(%eax),%esi
80106e40:	85 f6                	test   %esi,%esi
80106e42:	0f 85 f8 00 00 00    	jne    80106f40 <trap+0x210>
    myproc()->tf = tf;
80106e48:	e8 63 d4 ff ff       	call   801042b0 <myproc>
80106e4d:	89 78 18             	mov    %edi,0x18(%eax)
    syscall();
80106e50:	e8 ab ed ff ff       	call   80105c00 <syscall>
    if(myproc()->killed)
80106e55:	e8 56 d4 ff ff       	call   801042b0 <myproc>
80106e5a:	8b 58 24             	mov    0x24(%eax),%ebx
80106e5d:	85 db                	test   %ebx,%ebx
80106e5f:	74 c9                	je     80106e2a <trap+0xfa>
}
80106e61:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106e64:	5b                   	pop    %ebx
80106e65:	5e                   	pop    %esi
80106e66:	5f                   	pop    %edi
80106e67:	5d                   	pop    %ebp
      exit();
80106e68:	e9 f3 da ff ff       	jmp    80104960 <exit>
80106e6d:	8d 76 00             	lea    0x0(%esi),%esi
  if(myproc() && myproc()->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER)
80106e70:	83 7f 30 20          	cmpl   $0x20,0x30(%edi)
80106e74:	75 92                	jne    80106e08 <trap+0xd8>
    if(add_tick())
80106e76:	e8 65 1f 00 00       	call   80108de0 <add_tick>
80106e7b:	85 c0                	test   %eax,%eax
80106e7d:	0f 84 15 01 00 00    	je     80106f98 <trap+0x268>
      yield();
80106e83:	e8 78 d9 ff ff       	call   80104800 <yield>
80106e88:	e9 7b ff ff ff       	jmp    80106e08 <trap+0xd8>
80106e8d:	8d 76 00             	lea    0x0(%esi),%esi
    if(cpuid() == 0){
80106e90:	e8 fb d3 ff ff       	call   80104290 <cpuid>
80106e95:	85 c0                	test   %eax,%eax
80106e97:	0f 84 c3 00 00 00    	je     80106f60 <trap+0x230>
    lapiceoi();
80106e9d:	e8 de be ff ff       	call   80102d80 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106ea2:	e8 09 d4 ff ff       	call   801042b0 <myproc>
80106ea7:	85 c0                	test   %eax,%eax
80106ea9:	0f 85 28 ff ff ff    	jne    80106dd7 <trap+0xa7>
80106eaf:	e9 40 ff ff ff       	jmp    80106df4 <trap+0xc4>
80106eb4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kbdintr();
80106eb8:	e8 83 bd ff ff       	call   80102c40 <kbdintr>
    lapiceoi();
80106ebd:	e8 be be ff ff       	call   80102d80 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106ec2:	e8 e9 d3 ff ff       	call   801042b0 <myproc>
80106ec7:	85 c0                	test   %eax,%eax
80106ec9:	0f 85 08 ff ff ff    	jne    80106dd7 <trap+0xa7>
80106ecf:	e9 20 ff ff ff       	jmp    80106df4 <trap+0xc4>
80106ed4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    uartintr();
80106ed8:	e8 a3 02 00 00       	call   80107180 <uartintr>
    lapiceoi();
80106edd:	e8 9e be ff ff       	call   80102d80 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106ee2:	e8 c9 d3 ff ff       	call   801042b0 <myproc>
80106ee7:	85 c0                	test   %eax,%eax
80106ee9:	0f 85 e8 fe ff ff    	jne    80106dd7 <trap+0xa7>
80106eef:	e9 00 ff ff ff       	jmp    80106df4 <trap+0xc4>
80106ef4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106ef8:	0f b7 5f 3c          	movzwl 0x3c(%edi),%ebx
80106efc:	8b 77 38             	mov    0x38(%edi),%esi
80106eff:	e8 8c d3 ff ff       	call   80104290 <cpuid>
80106f04:	56                   	push   %esi
80106f05:	53                   	push   %ebx
80106f06:	50                   	push   %eax
80106f07:	68 74 98 10 80       	push   $0x80109874
80106f0c:	e8 4f 97 ff ff       	call   80100660 <cprintf>
    lapiceoi();
80106f11:	e8 6a be ff ff       	call   80102d80 <lapiceoi>
    break;
80106f16:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106f19:	e8 92 d3 ff ff       	call   801042b0 <myproc>
80106f1e:	85 c0                	test   %eax,%eax
80106f20:	0f 85 b1 fe ff ff    	jne    80106dd7 <trap+0xa7>
80106f26:	e9 c9 fe ff ff       	jmp    80106df4 <trap+0xc4>
80106f2b:	90                   	nop
80106f2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ideintr();
80106f30:	e8 7b b7 ff ff       	call   801026b0 <ideintr>
80106f35:	e9 63 ff ff ff       	jmp    80106e9d <trap+0x16d>
80106f3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
80106f40:	e8 1b da ff ff       	call   80104960 <exit>
80106f45:	e9 fe fe ff ff       	jmp    80106e48 <trap+0x118>
80106f4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    exit();
80106f50:	e8 0b da ff ff       	call   80104960 <exit>
80106f55:	e9 9a fe ff ff       	jmp    80106df4 <trap+0xc4>
80106f5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      acquire(&tickslock);
80106f60:	83 ec 0c             	sub    $0xc,%esp
80106f63:	68 80 c7 11 80       	push   $0x8011c780
80106f68:	e8 93 e7 ff ff       	call   80105700 <acquire>
      wakeup(&ticks);
80106f6d:	c7 04 24 c0 cf 11 80 	movl   $0x8011cfc0,(%esp)
      ticks++;
80106f74:	83 05 c0 cf 11 80 01 	addl   $0x1,0x8011cfc0
      wakeup(&ticks);
80106f7b:	e8 70 dd ff ff       	call   80104cf0 <wakeup>
      release(&tickslock);
80106f80:	c7 04 24 80 c7 11 80 	movl   $0x8011c780,(%esp)
80106f87:	e8 34 e8 ff ff       	call   801057c0 <release>
80106f8c:	83 c4 10             	add    $0x10,%esp
80106f8f:	e9 09 ff ff ff       	jmp    80106e9d <trap+0x16d>
80106f94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(isRunnable(myproc()->pid))
80106f98:	e8 13 d3 ff ff       	call   801042b0 <myproc>
80106f9d:	83 ec 0c             	sub    $0xc,%esp
80106fa0:	ff 70 10             	pushl  0x10(%eax)
80106fa3:	e8 f8 16 00 00       	call   801086a0 <isRunnable>
80106fa8:	83 c4 10             	add    $0x10,%esp
80106fab:	85 c0                	test   %eax,%eax
80106fad:	74 0a                	je     80106fb9 <trap+0x289>
        yield_thread();
80106faf:	e8 9c d8 ff ff       	call   80104850 <yield_thread>
80106fb4:	e9 4f fe ff ff       	jmp    80106e08 <trap+0xd8>
      else if(myproc()->killed || myproc()->state != RUNNING)
80106fb9:	e8 f2 d2 ff ff       	call   801042b0 <myproc>
80106fbe:	8b 50 24             	mov    0x24(%eax),%edx
80106fc1:	85 d2                	test   %edx,%edx
80106fc3:	75 0f                	jne    80106fd4 <trap+0x2a4>
80106fc5:	e8 e6 d2 ff ff       	call   801042b0 <myproc>
80106fca:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80106fce:	0f 84 34 fe ff ff    	je     80106e08 <trap+0xd8>
        exit();
80106fd4:	e8 87 d9 ff ff       	call   80104960 <exit>
80106fd9:	e9 2a fe ff ff       	jmp    80106e08 <trap+0xd8>
80106fde:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80106fe1:	e8 aa d2 ff ff       	call   80104290 <cpuid>
80106fe6:	83 ec 0c             	sub    $0xc,%esp
80106fe9:	56                   	push   %esi
80106fea:	53                   	push   %ebx
80106feb:	50                   	push   %eax
80106fec:	ff 77 30             	pushl  0x30(%edi)
80106fef:	68 98 98 10 80       	push   $0x80109898
80106ff4:	e8 67 96 ff ff       	call   80100660 <cprintf>
      panic("trap");
80106ff9:	83 c4 14             	add    $0x14,%esp
80106ffc:	68 6e 98 10 80       	push   $0x8010986e
80107001:	e8 8a 93 ff ff       	call   80100390 <panic>
80107006:	66 90                	xchg   %ax,%ax
80107008:	66 90                	xchg   %ax,%ax
8010700a:	66 90                	xchg   %ax,%ax
8010700c:	66 90                	xchg   %ax,%ax
8010700e:	66 90                	xchg   %ax,%ax

80107010 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80107010:	a1 bc c5 10 80       	mov    0x8010c5bc,%eax
{
80107015:	55                   	push   %ebp
80107016:	89 e5                	mov    %esp,%ebp
  if(!uart)
80107018:	85 c0                	test   %eax,%eax
8010701a:	74 1c                	je     80107038 <uartgetc+0x28>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010701c:	ba fd 03 00 00       	mov    $0x3fd,%edx
80107021:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80107022:	a8 01                	test   $0x1,%al
80107024:	74 12                	je     80107038 <uartgetc+0x28>
80107026:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010702b:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
8010702c:	0f b6 c0             	movzbl %al,%eax
}
8010702f:	5d                   	pop    %ebp
80107030:	c3                   	ret    
80107031:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80107038:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010703d:	5d                   	pop    %ebp
8010703e:	c3                   	ret    
8010703f:	90                   	nop

80107040 <uartputc.part.0>:
uartputc(int c)
80107040:	55                   	push   %ebp
80107041:	89 e5                	mov    %esp,%ebp
80107043:	57                   	push   %edi
80107044:	56                   	push   %esi
80107045:	53                   	push   %ebx
80107046:	89 c7                	mov    %eax,%edi
80107048:	bb 80 00 00 00       	mov    $0x80,%ebx
8010704d:	be fd 03 00 00       	mov    $0x3fd,%esi
80107052:	83 ec 0c             	sub    $0xc,%esp
80107055:	eb 1b                	jmp    80107072 <uartputc.part.0+0x32>
80107057:	89 f6                	mov    %esi,%esi
80107059:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    microdelay(10);
80107060:	83 ec 0c             	sub    $0xc,%esp
80107063:	6a 0a                	push   $0xa
80107065:	e8 36 bd ff ff       	call   80102da0 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010706a:	83 c4 10             	add    $0x10,%esp
8010706d:	83 eb 01             	sub    $0x1,%ebx
80107070:	74 07                	je     80107079 <uartputc.part.0+0x39>
80107072:	89 f2                	mov    %esi,%edx
80107074:	ec                   	in     (%dx),%al
80107075:	a8 20                	test   $0x20,%al
80107077:	74 e7                	je     80107060 <uartputc.part.0+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80107079:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010707e:	89 f8                	mov    %edi,%eax
80107080:	ee                   	out    %al,(%dx)
}
80107081:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107084:	5b                   	pop    %ebx
80107085:	5e                   	pop    %esi
80107086:	5f                   	pop    %edi
80107087:	5d                   	pop    %ebp
80107088:	c3                   	ret    
80107089:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107090 <uartinit>:
{
80107090:	55                   	push   %ebp
80107091:	31 c9                	xor    %ecx,%ecx
80107093:	89 c8                	mov    %ecx,%eax
80107095:	89 e5                	mov    %esp,%ebp
80107097:	57                   	push   %edi
80107098:	56                   	push   %esi
80107099:	53                   	push   %ebx
8010709a:	bb fa 03 00 00       	mov    $0x3fa,%ebx
8010709f:	89 da                	mov    %ebx,%edx
801070a1:	83 ec 0c             	sub    $0xc,%esp
801070a4:	ee                   	out    %al,(%dx)
801070a5:	bf fb 03 00 00       	mov    $0x3fb,%edi
801070aa:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
801070af:	89 fa                	mov    %edi,%edx
801070b1:	ee                   	out    %al,(%dx)
801070b2:	b8 0c 00 00 00       	mov    $0xc,%eax
801070b7:	ba f8 03 00 00       	mov    $0x3f8,%edx
801070bc:	ee                   	out    %al,(%dx)
801070bd:	be f9 03 00 00       	mov    $0x3f9,%esi
801070c2:	89 c8                	mov    %ecx,%eax
801070c4:	89 f2                	mov    %esi,%edx
801070c6:	ee                   	out    %al,(%dx)
801070c7:	b8 03 00 00 00       	mov    $0x3,%eax
801070cc:	89 fa                	mov    %edi,%edx
801070ce:	ee                   	out    %al,(%dx)
801070cf:	ba fc 03 00 00       	mov    $0x3fc,%edx
801070d4:	89 c8                	mov    %ecx,%eax
801070d6:	ee                   	out    %al,(%dx)
801070d7:	b8 01 00 00 00       	mov    $0x1,%eax
801070dc:	89 f2                	mov    %esi,%edx
801070de:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801070df:	ba fd 03 00 00       	mov    $0x3fd,%edx
801070e4:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
801070e5:	3c ff                	cmp    $0xff,%al
801070e7:	74 5a                	je     80107143 <uartinit+0xb3>
  uart = 1;
801070e9:	c7 05 bc c5 10 80 01 	movl   $0x1,0x8010c5bc
801070f0:	00 00 00 
801070f3:	89 da                	mov    %ebx,%edx
801070f5:	ec                   	in     (%dx),%al
801070f6:	ba f8 03 00 00       	mov    $0x3f8,%edx
801070fb:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
801070fc:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
801070ff:	bb 90 99 10 80       	mov    $0x80109990,%ebx
  ioapicenable(IRQ_COM1, 0);
80107104:	6a 00                	push   $0x0
80107106:	6a 04                	push   $0x4
80107108:	e8 f3 b7 ff ff       	call   80102900 <ioapicenable>
8010710d:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
80107110:	b8 78 00 00 00       	mov    $0x78,%eax
80107115:	eb 13                	jmp    8010712a <uartinit+0x9a>
80107117:	89 f6                	mov    %esi,%esi
80107119:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80107120:	83 c3 01             	add    $0x1,%ebx
80107123:	0f be 03             	movsbl (%ebx),%eax
80107126:	84 c0                	test   %al,%al
80107128:	74 19                	je     80107143 <uartinit+0xb3>
  if(!uart)
8010712a:	8b 15 bc c5 10 80    	mov    0x8010c5bc,%edx
80107130:	85 d2                	test   %edx,%edx
80107132:	74 ec                	je     80107120 <uartinit+0x90>
  for(p="xv6...\n"; *p; p++)
80107134:	83 c3 01             	add    $0x1,%ebx
80107137:	e8 04 ff ff ff       	call   80107040 <uartputc.part.0>
8010713c:	0f be 03             	movsbl (%ebx),%eax
8010713f:	84 c0                	test   %al,%al
80107141:	75 e7                	jne    8010712a <uartinit+0x9a>
}
80107143:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107146:	5b                   	pop    %ebx
80107147:	5e                   	pop    %esi
80107148:	5f                   	pop    %edi
80107149:	5d                   	pop    %ebp
8010714a:	c3                   	ret    
8010714b:	90                   	nop
8010714c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107150 <uartputc>:
  if(!uart)
80107150:	8b 15 bc c5 10 80    	mov    0x8010c5bc,%edx
{
80107156:	55                   	push   %ebp
80107157:	89 e5                	mov    %esp,%ebp
  if(!uart)
80107159:	85 d2                	test   %edx,%edx
{
8010715b:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!uart)
8010715e:	74 10                	je     80107170 <uartputc+0x20>
}
80107160:	5d                   	pop    %ebp
80107161:	e9 da fe ff ff       	jmp    80107040 <uartputc.part.0>
80107166:	8d 76 00             	lea    0x0(%esi),%esi
80107169:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80107170:	5d                   	pop    %ebp
80107171:	c3                   	ret    
80107172:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107179:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107180 <uartintr>:

void
uartintr(void)
{
80107180:	55                   	push   %ebp
80107181:	89 e5                	mov    %esp,%ebp
80107183:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80107186:	68 10 70 10 80       	push   $0x80107010
8010718b:	e8 80 96 ff ff       	call   80100810 <consoleintr>
}
80107190:	83 c4 10             	add    $0x10,%esp
80107193:	c9                   	leave  
80107194:	c3                   	ret    

80107195 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80107195:	6a 00                	push   $0x0
  pushl $0
80107197:	6a 00                	push   $0x0
  jmp alltraps
80107199:	e9 b9 fa ff ff       	jmp    80106c57 <alltraps>

8010719e <vector1>:
.globl vector1
vector1:
  pushl $0
8010719e:	6a 00                	push   $0x0
  pushl $1
801071a0:	6a 01                	push   $0x1
  jmp alltraps
801071a2:	e9 b0 fa ff ff       	jmp    80106c57 <alltraps>

801071a7 <vector2>:
.globl vector2
vector2:
  pushl $0
801071a7:	6a 00                	push   $0x0
  pushl $2
801071a9:	6a 02                	push   $0x2
  jmp alltraps
801071ab:	e9 a7 fa ff ff       	jmp    80106c57 <alltraps>

801071b0 <vector3>:
.globl vector3
vector3:
  pushl $0
801071b0:	6a 00                	push   $0x0
  pushl $3
801071b2:	6a 03                	push   $0x3
  jmp alltraps
801071b4:	e9 9e fa ff ff       	jmp    80106c57 <alltraps>

801071b9 <vector4>:
.globl vector4
vector4:
  pushl $0
801071b9:	6a 00                	push   $0x0
  pushl $4
801071bb:	6a 04                	push   $0x4
  jmp alltraps
801071bd:	e9 95 fa ff ff       	jmp    80106c57 <alltraps>

801071c2 <vector5>:
.globl vector5
vector5:
  pushl $0
801071c2:	6a 00                	push   $0x0
  pushl $5
801071c4:	6a 05                	push   $0x5
  jmp alltraps
801071c6:	e9 8c fa ff ff       	jmp    80106c57 <alltraps>

801071cb <vector6>:
.globl vector6
vector6:
  pushl $0
801071cb:	6a 00                	push   $0x0
  pushl $6
801071cd:	6a 06                	push   $0x6
  jmp alltraps
801071cf:	e9 83 fa ff ff       	jmp    80106c57 <alltraps>

801071d4 <vector7>:
.globl vector7
vector7:
  pushl $0
801071d4:	6a 00                	push   $0x0
  pushl $7
801071d6:	6a 07                	push   $0x7
  jmp alltraps
801071d8:	e9 7a fa ff ff       	jmp    80106c57 <alltraps>

801071dd <vector8>:
.globl vector8
vector8:
  pushl $8
801071dd:	6a 08                	push   $0x8
  jmp alltraps
801071df:	e9 73 fa ff ff       	jmp    80106c57 <alltraps>

801071e4 <vector9>:
.globl vector9
vector9:
  pushl $0
801071e4:	6a 00                	push   $0x0
  pushl $9
801071e6:	6a 09                	push   $0x9
  jmp alltraps
801071e8:	e9 6a fa ff ff       	jmp    80106c57 <alltraps>

801071ed <vector10>:
.globl vector10
vector10:
  pushl $10
801071ed:	6a 0a                	push   $0xa
  jmp alltraps
801071ef:	e9 63 fa ff ff       	jmp    80106c57 <alltraps>

801071f4 <vector11>:
.globl vector11
vector11:
  pushl $11
801071f4:	6a 0b                	push   $0xb
  jmp alltraps
801071f6:	e9 5c fa ff ff       	jmp    80106c57 <alltraps>

801071fb <vector12>:
.globl vector12
vector12:
  pushl $12
801071fb:	6a 0c                	push   $0xc
  jmp alltraps
801071fd:	e9 55 fa ff ff       	jmp    80106c57 <alltraps>

80107202 <vector13>:
.globl vector13
vector13:
  pushl $13
80107202:	6a 0d                	push   $0xd
  jmp alltraps
80107204:	e9 4e fa ff ff       	jmp    80106c57 <alltraps>

80107209 <vector14>:
.globl vector14
vector14:
  pushl $14
80107209:	6a 0e                	push   $0xe
  jmp alltraps
8010720b:	e9 47 fa ff ff       	jmp    80106c57 <alltraps>

80107210 <vector15>:
.globl vector15
vector15:
  pushl $0
80107210:	6a 00                	push   $0x0
  pushl $15
80107212:	6a 0f                	push   $0xf
  jmp alltraps
80107214:	e9 3e fa ff ff       	jmp    80106c57 <alltraps>

80107219 <vector16>:
.globl vector16
vector16:
  pushl $0
80107219:	6a 00                	push   $0x0
  pushl $16
8010721b:	6a 10                	push   $0x10
  jmp alltraps
8010721d:	e9 35 fa ff ff       	jmp    80106c57 <alltraps>

80107222 <vector17>:
.globl vector17
vector17:
  pushl $17
80107222:	6a 11                	push   $0x11
  jmp alltraps
80107224:	e9 2e fa ff ff       	jmp    80106c57 <alltraps>

80107229 <vector18>:
.globl vector18
vector18:
  pushl $0
80107229:	6a 00                	push   $0x0
  pushl $18
8010722b:	6a 12                	push   $0x12
  jmp alltraps
8010722d:	e9 25 fa ff ff       	jmp    80106c57 <alltraps>

80107232 <vector19>:
.globl vector19
vector19:
  pushl $0
80107232:	6a 00                	push   $0x0
  pushl $19
80107234:	6a 13                	push   $0x13
  jmp alltraps
80107236:	e9 1c fa ff ff       	jmp    80106c57 <alltraps>

8010723b <vector20>:
.globl vector20
vector20:
  pushl $0
8010723b:	6a 00                	push   $0x0
  pushl $20
8010723d:	6a 14                	push   $0x14
  jmp alltraps
8010723f:	e9 13 fa ff ff       	jmp    80106c57 <alltraps>

80107244 <vector21>:
.globl vector21
vector21:
  pushl $0
80107244:	6a 00                	push   $0x0
  pushl $21
80107246:	6a 15                	push   $0x15
  jmp alltraps
80107248:	e9 0a fa ff ff       	jmp    80106c57 <alltraps>

8010724d <vector22>:
.globl vector22
vector22:
  pushl $0
8010724d:	6a 00                	push   $0x0
  pushl $22
8010724f:	6a 16                	push   $0x16
  jmp alltraps
80107251:	e9 01 fa ff ff       	jmp    80106c57 <alltraps>

80107256 <vector23>:
.globl vector23
vector23:
  pushl $0
80107256:	6a 00                	push   $0x0
  pushl $23
80107258:	6a 17                	push   $0x17
  jmp alltraps
8010725a:	e9 f8 f9 ff ff       	jmp    80106c57 <alltraps>

8010725f <vector24>:
.globl vector24
vector24:
  pushl $0
8010725f:	6a 00                	push   $0x0
  pushl $24
80107261:	6a 18                	push   $0x18
  jmp alltraps
80107263:	e9 ef f9 ff ff       	jmp    80106c57 <alltraps>

80107268 <vector25>:
.globl vector25
vector25:
  pushl $0
80107268:	6a 00                	push   $0x0
  pushl $25
8010726a:	6a 19                	push   $0x19
  jmp alltraps
8010726c:	e9 e6 f9 ff ff       	jmp    80106c57 <alltraps>

80107271 <vector26>:
.globl vector26
vector26:
  pushl $0
80107271:	6a 00                	push   $0x0
  pushl $26
80107273:	6a 1a                	push   $0x1a
  jmp alltraps
80107275:	e9 dd f9 ff ff       	jmp    80106c57 <alltraps>

8010727a <vector27>:
.globl vector27
vector27:
  pushl $0
8010727a:	6a 00                	push   $0x0
  pushl $27
8010727c:	6a 1b                	push   $0x1b
  jmp alltraps
8010727e:	e9 d4 f9 ff ff       	jmp    80106c57 <alltraps>

80107283 <vector28>:
.globl vector28
vector28:
  pushl $0
80107283:	6a 00                	push   $0x0
  pushl $28
80107285:	6a 1c                	push   $0x1c
  jmp alltraps
80107287:	e9 cb f9 ff ff       	jmp    80106c57 <alltraps>

8010728c <vector29>:
.globl vector29
vector29:
  pushl $0
8010728c:	6a 00                	push   $0x0
  pushl $29
8010728e:	6a 1d                	push   $0x1d
  jmp alltraps
80107290:	e9 c2 f9 ff ff       	jmp    80106c57 <alltraps>

80107295 <vector30>:
.globl vector30
vector30:
  pushl $0
80107295:	6a 00                	push   $0x0
  pushl $30
80107297:	6a 1e                	push   $0x1e
  jmp alltraps
80107299:	e9 b9 f9 ff ff       	jmp    80106c57 <alltraps>

8010729e <vector31>:
.globl vector31
vector31:
  pushl $0
8010729e:	6a 00                	push   $0x0
  pushl $31
801072a0:	6a 1f                	push   $0x1f
  jmp alltraps
801072a2:	e9 b0 f9 ff ff       	jmp    80106c57 <alltraps>

801072a7 <vector32>:
.globl vector32
vector32:
  pushl $0
801072a7:	6a 00                	push   $0x0
  pushl $32
801072a9:	6a 20                	push   $0x20
  jmp alltraps
801072ab:	e9 a7 f9 ff ff       	jmp    80106c57 <alltraps>

801072b0 <vector33>:
.globl vector33
vector33:
  pushl $0
801072b0:	6a 00                	push   $0x0
  pushl $33
801072b2:	6a 21                	push   $0x21
  jmp alltraps
801072b4:	e9 9e f9 ff ff       	jmp    80106c57 <alltraps>

801072b9 <vector34>:
.globl vector34
vector34:
  pushl $0
801072b9:	6a 00                	push   $0x0
  pushl $34
801072bb:	6a 22                	push   $0x22
  jmp alltraps
801072bd:	e9 95 f9 ff ff       	jmp    80106c57 <alltraps>

801072c2 <vector35>:
.globl vector35
vector35:
  pushl $0
801072c2:	6a 00                	push   $0x0
  pushl $35
801072c4:	6a 23                	push   $0x23
  jmp alltraps
801072c6:	e9 8c f9 ff ff       	jmp    80106c57 <alltraps>

801072cb <vector36>:
.globl vector36
vector36:
  pushl $0
801072cb:	6a 00                	push   $0x0
  pushl $36
801072cd:	6a 24                	push   $0x24
  jmp alltraps
801072cf:	e9 83 f9 ff ff       	jmp    80106c57 <alltraps>

801072d4 <vector37>:
.globl vector37
vector37:
  pushl $0
801072d4:	6a 00                	push   $0x0
  pushl $37
801072d6:	6a 25                	push   $0x25
  jmp alltraps
801072d8:	e9 7a f9 ff ff       	jmp    80106c57 <alltraps>

801072dd <vector38>:
.globl vector38
vector38:
  pushl $0
801072dd:	6a 00                	push   $0x0
  pushl $38
801072df:	6a 26                	push   $0x26
  jmp alltraps
801072e1:	e9 71 f9 ff ff       	jmp    80106c57 <alltraps>

801072e6 <vector39>:
.globl vector39
vector39:
  pushl $0
801072e6:	6a 00                	push   $0x0
  pushl $39
801072e8:	6a 27                	push   $0x27
  jmp alltraps
801072ea:	e9 68 f9 ff ff       	jmp    80106c57 <alltraps>

801072ef <vector40>:
.globl vector40
vector40:
  pushl $0
801072ef:	6a 00                	push   $0x0
  pushl $40
801072f1:	6a 28                	push   $0x28
  jmp alltraps
801072f3:	e9 5f f9 ff ff       	jmp    80106c57 <alltraps>

801072f8 <vector41>:
.globl vector41
vector41:
  pushl $0
801072f8:	6a 00                	push   $0x0
  pushl $41
801072fa:	6a 29                	push   $0x29
  jmp alltraps
801072fc:	e9 56 f9 ff ff       	jmp    80106c57 <alltraps>

80107301 <vector42>:
.globl vector42
vector42:
  pushl $0
80107301:	6a 00                	push   $0x0
  pushl $42
80107303:	6a 2a                	push   $0x2a
  jmp alltraps
80107305:	e9 4d f9 ff ff       	jmp    80106c57 <alltraps>

8010730a <vector43>:
.globl vector43
vector43:
  pushl $0
8010730a:	6a 00                	push   $0x0
  pushl $43
8010730c:	6a 2b                	push   $0x2b
  jmp alltraps
8010730e:	e9 44 f9 ff ff       	jmp    80106c57 <alltraps>

80107313 <vector44>:
.globl vector44
vector44:
  pushl $0
80107313:	6a 00                	push   $0x0
  pushl $44
80107315:	6a 2c                	push   $0x2c
  jmp alltraps
80107317:	e9 3b f9 ff ff       	jmp    80106c57 <alltraps>

8010731c <vector45>:
.globl vector45
vector45:
  pushl $0
8010731c:	6a 00                	push   $0x0
  pushl $45
8010731e:	6a 2d                	push   $0x2d
  jmp alltraps
80107320:	e9 32 f9 ff ff       	jmp    80106c57 <alltraps>

80107325 <vector46>:
.globl vector46
vector46:
  pushl $0
80107325:	6a 00                	push   $0x0
  pushl $46
80107327:	6a 2e                	push   $0x2e
  jmp alltraps
80107329:	e9 29 f9 ff ff       	jmp    80106c57 <alltraps>

8010732e <vector47>:
.globl vector47
vector47:
  pushl $0
8010732e:	6a 00                	push   $0x0
  pushl $47
80107330:	6a 2f                	push   $0x2f
  jmp alltraps
80107332:	e9 20 f9 ff ff       	jmp    80106c57 <alltraps>

80107337 <vector48>:
.globl vector48
vector48:
  pushl $0
80107337:	6a 00                	push   $0x0
  pushl $48
80107339:	6a 30                	push   $0x30
  jmp alltraps
8010733b:	e9 17 f9 ff ff       	jmp    80106c57 <alltraps>

80107340 <vector49>:
.globl vector49
vector49:
  pushl $0
80107340:	6a 00                	push   $0x0
  pushl $49
80107342:	6a 31                	push   $0x31
  jmp alltraps
80107344:	e9 0e f9 ff ff       	jmp    80106c57 <alltraps>

80107349 <vector50>:
.globl vector50
vector50:
  pushl $0
80107349:	6a 00                	push   $0x0
  pushl $50
8010734b:	6a 32                	push   $0x32
  jmp alltraps
8010734d:	e9 05 f9 ff ff       	jmp    80106c57 <alltraps>

80107352 <vector51>:
.globl vector51
vector51:
  pushl $0
80107352:	6a 00                	push   $0x0
  pushl $51
80107354:	6a 33                	push   $0x33
  jmp alltraps
80107356:	e9 fc f8 ff ff       	jmp    80106c57 <alltraps>

8010735b <vector52>:
.globl vector52
vector52:
  pushl $0
8010735b:	6a 00                	push   $0x0
  pushl $52
8010735d:	6a 34                	push   $0x34
  jmp alltraps
8010735f:	e9 f3 f8 ff ff       	jmp    80106c57 <alltraps>

80107364 <vector53>:
.globl vector53
vector53:
  pushl $0
80107364:	6a 00                	push   $0x0
  pushl $53
80107366:	6a 35                	push   $0x35
  jmp alltraps
80107368:	e9 ea f8 ff ff       	jmp    80106c57 <alltraps>

8010736d <vector54>:
.globl vector54
vector54:
  pushl $0
8010736d:	6a 00                	push   $0x0
  pushl $54
8010736f:	6a 36                	push   $0x36
  jmp alltraps
80107371:	e9 e1 f8 ff ff       	jmp    80106c57 <alltraps>

80107376 <vector55>:
.globl vector55
vector55:
  pushl $0
80107376:	6a 00                	push   $0x0
  pushl $55
80107378:	6a 37                	push   $0x37
  jmp alltraps
8010737a:	e9 d8 f8 ff ff       	jmp    80106c57 <alltraps>

8010737f <vector56>:
.globl vector56
vector56:
  pushl $0
8010737f:	6a 00                	push   $0x0
  pushl $56
80107381:	6a 38                	push   $0x38
  jmp alltraps
80107383:	e9 cf f8 ff ff       	jmp    80106c57 <alltraps>

80107388 <vector57>:
.globl vector57
vector57:
  pushl $0
80107388:	6a 00                	push   $0x0
  pushl $57
8010738a:	6a 39                	push   $0x39
  jmp alltraps
8010738c:	e9 c6 f8 ff ff       	jmp    80106c57 <alltraps>

80107391 <vector58>:
.globl vector58
vector58:
  pushl $0
80107391:	6a 00                	push   $0x0
  pushl $58
80107393:	6a 3a                	push   $0x3a
  jmp alltraps
80107395:	e9 bd f8 ff ff       	jmp    80106c57 <alltraps>

8010739a <vector59>:
.globl vector59
vector59:
  pushl $0
8010739a:	6a 00                	push   $0x0
  pushl $59
8010739c:	6a 3b                	push   $0x3b
  jmp alltraps
8010739e:	e9 b4 f8 ff ff       	jmp    80106c57 <alltraps>

801073a3 <vector60>:
.globl vector60
vector60:
  pushl $0
801073a3:	6a 00                	push   $0x0
  pushl $60
801073a5:	6a 3c                	push   $0x3c
  jmp alltraps
801073a7:	e9 ab f8 ff ff       	jmp    80106c57 <alltraps>

801073ac <vector61>:
.globl vector61
vector61:
  pushl $0
801073ac:	6a 00                	push   $0x0
  pushl $61
801073ae:	6a 3d                	push   $0x3d
  jmp alltraps
801073b0:	e9 a2 f8 ff ff       	jmp    80106c57 <alltraps>

801073b5 <vector62>:
.globl vector62
vector62:
  pushl $0
801073b5:	6a 00                	push   $0x0
  pushl $62
801073b7:	6a 3e                	push   $0x3e
  jmp alltraps
801073b9:	e9 99 f8 ff ff       	jmp    80106c57 <alltraps>

801073be <vector63>:
.globl vector63
vector63:
  pushl $0
801073be:	6a 00                	push   $0x0
  pushl $63
801073c0:	6a 3f                	push   $0x3f
  jmp alltraps
801073c2:	e9 90 f8 ff ff       	jmp    80106c57 <alltraps>

801073c7 <vector64>:
.globl vector64
vector64:
  pushl $0
801073c7:	6a 00                	push   $0x0
  pushl $64
801073c9:	6a 40                	push   $0x40
  jmp alltraps
801073cb:	e9 87 f8 ff ff       	jmp    80106c57 <alltraps>

801073d0 <vector65>:
.globl vector65
vector65:
  pushl $0
801073d0:	6a 00                	push   $0x0
  pushl $65
801073d2:	6a 41                	push   $0x41
  jmp alltraps
801073d4:	e9 7e f8 ff ff       	jmp    80106c57 <alltraps>

801073d9 <vector66>:
.globl vector66
vector66:
  pushl $0
801073d9:	6a 00                	push   $0x0
  pushl $66
801073db:	6a 42                	push   $0x42
  jmp alltraps
801073dd:	e9 75 f8 ff ff       	jmp    80106c57 <alltraps>

801073e2 <vector67>:
.globl vector67
vector67:
  pushl $0
801073e2:	6a 00                	push   $0x0
  pushl $67
801073e4:	6a 43                	push   $0x43
  jmp alltraps
801073e6:	e9 6c f8 ff ff       	jmp    80106c57 <alltraps>

801073eb <vector68>:
.globl vector68
vector68:
  pushl $0
801073eb:	6a 00                	push   $0x0
  pushl $68
801073ed:	6a 44                	push   $0x44
  jmp alltraps
801073ef:	e9 63 f8 ff ff       	jmp    80106c57 <alltraps>

801073f4 <vector69>:
.globl vector69
vector69:
  pushl $0
801073f4:	6a 00                	push   $0x0
  pushl $69
801073f6:	6a 45                	push   $0x45
  jmp alltraps
801073f8:	e9 5a f8 ff ff       	jmp    80106c57 <alltraps>

801073fd <vector70>:
.globl vector70
vector70:
  pushl $0
801073fd:	6a 00                	push   $0x0
  pushl $70
801073ff:	6a 46                	push   $0x46
  jmp alltraps
80107401:	e9 51 f8 ff ff       	jmp    80106c57 <alltraps>

80107406 <vector71>:
.globl vector71
vector71:
  pushl $0
80107406:	6a 00                	push   $0x0
  pushl $71
80107408:	6a 47                	push   $0x47
  jmp alltraps
8010740a:	e9 48 f8 ff ff       	jmp    80106c57 <alltraps>

8010740f <vector72>:
.globl vector72
vector72:
  pushl $0
8010740f:	6a 00                	push   $0x0
  pushl $72
80107411:	6a 48                	push   $0x48
  jmp alltraps
80107413:	e9 3f f8 ff ff       	jmp    80106c57 <alltraps>

80107418 <vector73>:
.globl vector73
vector73:
  pushl $0
80107418:	6a 00                	push   $0x0
  pushl $73
8010741a:	6a 49                	push   $0x49
  jmp alltraps
8010741c:	e9 36 f8 ff ff       	jmp    80106c57 <alltraps>

80107421 <vector74>:
.globl vector74
vector74:
  pushl $0
80107421:	6a 00                	push   $0x0
  pushl $74
80107423:	6a 4a                	push   $0x4a
  jmp alltraps
80107425:	e9 2d f8 ff ff       	jmp    80106c57 <alltraps>

8010742a <vector75>:
.globl vector75
vector75:
  pushl $0
8010742a:	6a 00                	push   $0x0
  pushl $75
8010742c:	6a 4b                	push   $0x4b
  jmp alltraps
8010742e:	e9 24 f8 ff ff       	jmp    80106c57 <alltraps>

80107433 <vector76>:
.globl vector76
vector76:
  pushl $0
80107433:	6a 00                	push   $0x0
  pushl $76
80107435:	6a 4c                	push   $0x4c
  jmp alltraps
80107437:	e9 1b f8 ff ff       	jmp    80106c57 <alltraps>

8010743c <vector77>:
.globl vector77
vector77:
  pushl $0
8010743c:	6a 00                	push   $0x0
  pushl $77
8010743e:	6a 4d                	push   $0x4d
  jmp alltraps
80107440:	e9 12 f8 ff ff       	jmp    80106c57 <alltraps>

80107445 <vector78>:
.globl vector78
vector78:
  pushl $0
80107445:	6a 00                	push   $0x0
  pushl $78
80107447:	6a 4e                	push   $0x4e
  jmp alltraps
80107449:	e9 09 f8 ff ff       	jmp    80106c57 <alltraps>

8010744e <vector79>:
.globl vector79
vector79:
  pushl $0
8010744e:	6a 00                	push   $0x0
  pushl $79
80107450:	6a 4f                	push   $0x4f
  jmp alltraps
80107452:	e9 00 f8 ff ff       	jmp    80106c57 <alltraps>

80107457 <vector80>:
.globl vector80
vector80:
  pushl $0
80107457:	6a 00                	push   $0x0
  pushl $80
80107459:	6a 50                	push   $0x50
  jmp alltraps
8010745b:	e9 f7 f7 ff ff       	jmp    80106c57 <alltraps>

80107460 <vector81>:
.globl vector81
vector81:
  pushl $0
80107460:	6a 00                	push   $0x0
  pushl $81
80107462:	6a 51                	push   $0x51
  jmp alltraps
80107464:	e9 ee f7 ff ff       	jmp    80106c57 <alltraps>

80107469 <vector82>:
.globl vector82
vector82:
  pushl $0
80107469:	6a 00                	push   $0x0
  pushl $82
8010746b:	6a 52                	push   $0x52
  jmp alltraps
8010746d:	e9 e5 f7 ff ff       	jmp    80106c57 <alltraps>

80107472 <vector83>:
.globl vector83
vector83:
  pushl $0
80107472:	6a 00                	push   $0x0
  pushl $83
80107474:	6a 53                	push   $0x53
  jmp alltraps
80107476:	e9 dc f7 ff ff       	jmp    80106c57 <alltraps>

8010747b <vector84>:
.globl vector84
vector84:
  pushl $0
8010747b:	6a 00                	push   $0x0
  pushl $84
8010747d:	6a 54                	push   $0x54
  jmp alltraps
8010747f:	e9 d3 f7 ff ff       	jmp    80106c57 <alltraps>

80107484 <vector85>:
.globl vector85
vector85:
  pushl $0
80107484:	6a 00                	push   $0x0
  pushl $85
80107486:	6a 55                	push   $0x55
  jmp alltraps
80107488:	e9 ca f7 ff ff       	jmp    80106c57 <alltraps>

8010748d <vector86>:
.globl vector86
vector86:
  pushl $0
8010748d:	6a 00                	push   $0x0
  pushl $86
8010748f:	6a 56                	push   $0x56
  jmp alltraps
80107491:	e9 c1 f7 ff ff       	jmp    80106c57 <alltraps>

80107496 <vector87>:
.globl vector87
vector87:
  pushl $0
80107496:	6a 00                	push   $0x0
  pushl $87
80107498:	6a 57                	push   $0x57
  jmp alltraps
8010749a:	e9 b8 f7 ff ff       	jmp    80106c57 <alltraps>

8010749f <vector88>:
.globl vector88
vector88:
  pushl $0
8010749f:	6a 00                	push   $0x0
  pushl $88
801074a1:	6a 58                	push   $0x58
  jmp alltraps
801074a3:	e9 af f7 ff ff       	jmp    80106c57 <alltraps>

801074a8 <vector89>:
.globl vector89
vector89:
  pushl $0
801074a8:	6a 00                	push   $0x0
  pushl $89
801074aa:	6a 59                	push   $0x59
  jmp alltraps
801074ac:	e9 a6 f7 ff ff       	jmp    80106c57 <alltraps>

801074b1 <vector90>:
.globl vector90
vector90:
  pushl $0
801074b1:	6a 00                	push   $0x0
  pushl $90
801074b3:	6a 5a                	push   $0x5a
  jmp alltraps
801074b5:	e9 9d f7 ff ff       	jmp    80106c57 <alltraps>

801074ba <vector91>:
.globl vector91
vector91:
  pushl $0
801074ba:	6a 00                	push   $0x0
  pushl $91
801074bc:	6a 5b                	push   $0x5b
  jmp alltraps
801074be:	e9 94 f7 ff ff       	jmp    80106c57 <alltraps>

801074c3 <vector92>:
.globl vector92
vector92:
  pushl $0
801074c3:	6a 00                	push   $0x0
  pushl $92
801074c5:	6a 5c                	push   $0x5c
  jmp alltraps
801074c7:	e9 8b f7 ff ff       	jmp    80106c57 <alltraps>

801074cc <vector93>:
.globl vector93
vector93:
  pushl $0
801074cc:	6a 00                	push   $0x0
  pushl $93
801074ce:	6a 5d                	push   $0x5d
  jmp alltraps
801074d0:	e9 82 f7 ff ff       	jmp    80106c57 <alltraps>

801074d5 <vector94>:
.globl vector94
vector94:
  pushl $0
801074d5:	6a 00                	push   $0x0
  pushl $94
801074d7:	6a 5e                	push   $0x5e
  jmp alltraps
801074d9:	e9 79 f7 ff ff       	jmp    80106c57 <alltraps>

801074de <vector95>:
.globl vector95
vector95:
  pushl $0
801074de:	6a 00                	push   $0x0
  pushl $95
801074e0:	6a 5f                	push   $0x5f
  jmp alltraps
801074e2:	e9 70 f7 ff ff       	jmp    80106c57 <alltraps>

801074e7 <vector96>:
.globl vector96
vector96:
  pushl $0
801074e7:	6a 00                	push   $0x0
  pushl $96
801074e9:	6a 60                	push   $0x60
  jmp alltraps
801074eb:	e9 67 f7 ff ff       	jmp    80106c57 <alltraps>

801074f0 <vector97>:
.globl vector97
vector97:
  pushl $0
801074f0:	6a 00                	push   $0x0
  pushl $97
801074f2:	6a 61                	push   $0x61
  jmp alltraps
801074f4:	e9 5e f7 ff ff       	jmp    80106c57 <alltraps>

801074f9 <vector98>:
.globl vector98
vector98:
  pushl $0
801074f9:	6a 00                	push   $0x0
  pushl $98
801074fb:	6a 62                	push   $0x62
  jmp alltraps
801074fd:	e9 55 f7 ff ff       	jmp    80106c57 <alltraps>

80107502 <vector99>:
.globl vector99
vector99:
  pushl $0
80107502:	6a 00                	push   $0x0
  pushl $99
80107504:	6a 63                	push   $0x63
  jmp alltraps
80107506:	e9 4c f7 ff ff       	jmp    80106c57 <alltraps>

8010750b <vector100>:
.globl vector100
vector100:
  pushl $0
8010750b:	6a 00                	push   $0x0
  pushl $100
8010750d:	6a 64                	push   $0x64
  jmp alltraps
8010750f:	e9 43 f7 ff ff       	jmp    80106c57 <alltraps>

80107514 <vector101>:
.globl vector101
vector101:
  pushl $0
80107514:	6a 00                	push   $0x0
  pushl $101
80107516:	6a 65                	push   $0x65
  jmp alltraps
80107518:	e9 3a f7 ff ff       	jmp    80106c57 <alltraps>

8010751d <vector102>:
.globl vector102
vector102:
  pushl $0
8010751d:	6a 00                	push   $0x0
  pushl $102
8010751f:	6a 66                	push   $0x66
  jmp alltraps
80107521:	e9 31 f7 ff ff       	jmp    80106c57 <alltraps>

80107526 <vector103>:
.globl vector103
vector103:
  pushl $0
80107526:	6a 00                	push   $0x0
  pushl $103
80107528:	6a 67                	push   $0x67
  jmp alltraps
8010752a:	e9 28 f7 ff ff       	jmp    80106c57 <alltraps>

8010752f <vector104>:
.globl vector104
vector104:
  pushl $0
8010752f:	6a 00                	push   $0x0
  pushl $104
80107531:	6a 68                	push   $0x68
  jmp alltraps
80107533:	e9 1f f7 ff ff       	jmp    80106c57 <alltraps>

80107538 <vector105>:
.globl vector105
vector105:
  pushl $0
80107538:	6a 00                	push   $0x0
  pushl $105
8010753a:	6a 69                	push   $0x69
  jmp alltraps
8010753c:	e9 16 f7 ff ff       	jmp    80106c57 <alltraps>

80107541 <vector106>:
.globl vector106
vector106:
  pushl $0
80107541:	6a 00                	push   $0x0
  pushl $106
80107543:	6a 6a                	push   $0x6a
  jmp alltraps
80107545:	e9 0d f7 ff ff       	jmp    80106c57 <alltraps>

8010754a <vector107>:
.globl vector107
vector107:
  pushl $0
8010754a:	6a 00                	push   $0x0
  pushl $107
8010754c:	6a 6b                	push   $0x6b
  jmp alltraps
8010754e:	e9 04 f7 ff ff       	jmp    80106c57 <alltraps>

80107553 <vector108>:
.globl vector108
vector108:
  pushl $0
80107553:	6a 00                	push   $0x0
  pushl $108
80107555:	6a 6c                	push   $0x6c
  jmp alltraps
80107557:	e9 fb f6 ff ff       	jmp    80106c57 <alltraps>

8010755c <vector109>:
.globl vector109
vector109:
  pushl $0
8010755c:	6a 00                	push   $0x0
  pushl $109
8010755e:	6a 6d                	push   $0x6d
  jmp alltraps
80107560:	e9 f2 f6 ff ff       	jmp    80106c57 <alltraps>

80107565 <vector110>:
.globl vector110
vector110:
  pushl $0
80107565:	6a 00                	push   $0x0
  pushl $110
80107567:	6a 6e                	push   $0x6e
  jmp alltraps
80107569:	e9 e9 f6 ff ff       	jmp    80106c57 <alltraps>

8010756e <vector111>:
.globl vector111
vector111:
  pushl $0
8010756e:	6a 00                	push   $0x0
  pushl $111
80107570:	6a 6f                	push   $0x6f
  jmp alltraps
80107572:	e9 e0 f6 ff ff       	jmp    80106c57 <alltraps>

80107577 <vector112>:
.globl vector112
vector112:
  pushl $0
80107577:	6a 00                	push   $0x0
  pushl $112
80107579:	6a 70                	push   $0x70
  jmp alltraps
8010757b:	e9 d7 f6 ff ff       	jmp    80106c57 <alltraps>

80107580 <vector113>:
.globl vector113
vector113:
  pushl $0
80107580:	6a 00                	push   $0x0
  pushl $113
80107582:	6a 71                	push   $0x71
  jmp alltraps
80107584:	e9 ce f6 ff ff       	jmp    80106c57 <alltraps>

80107589 <vector114>:
.globl vector114
vector114:
  pushl $0
80107589:	6a 00                	push   $0x0
  pushl $114
8010758b:	6a 72                	push   $0x72
  jmp alltraps
8010758d:	e9 c5 f6 ff ff       	jmp    80106c57 <alltraps>

80107592 <vector115>:
.globl vector115
vector115:
  pushl $0
80107592:	6a 00                	push   $0x0
  pushl $115
80107594:	6a 73                	push   $0x73
  jmp alltraps
80107596:	e9 bc f6 ff ff       	jmp    80106c57 <alltraps>

8010759b <vector116>:
.globl vector116
vector116:
  pushl $0
8010759b:	6a 00                	push   $0x0
  pushl $116
8010759d:	6a 74                	push   $0x74
  jmp alltraps
8010759f:	e9 b3 f6 ff ff       	jmp    80106c57 <alltraps>

801075a4 <vector117>:
.globl vector117
vector117:
  pushl $0
801075a4:	6a 00                	push   $0x0
  pushl $117
801075a6:	6a 75                	push   $0x75
  jmp alltraps
801075a8:	e9 aa f6 ff ff       	jmp    80106c57 <alltraps>

801075ad <vector118>:
.globl vector118
vector118:
  pushl $0
801075ad:	6a 00                	push   $0x0
  pushl $118
801075af:	6a 76                	push   $0x76
  jmp alltraps
801075b1:	e9 a1 f6 ff ff       	jmp    80106c57 <alltraps>

801075b6 <vector119>:
.globl vector119
vector119:
  pushl $0
801075b6:	6a 00                	push   $0x0
  pushl $119
801075b8:	6a 77                	push   $0x77
  jmp alltraps
801075ba:	e9 98 f6 ff ff       	jmp    80106c57 <alltraps>

801075bf <vector120>:
.globl vector120
vector120:
  pushl $0
801075bf:	6a 00                	push   $0x0
  pushl $120
801075c1:	6a 78                	push   $0x78
  jmp alltraps
801075c3:	e9 8f f6 ff ff       	jmp    80106c57 <alltraps>

801075c8 <vector121>:
.globl vector121
vector121:
  pushl $0
801075c8:	6a 00                	push   $0x0
  pushl $121
801075ca:	6a 79                	push   $0x79
  jmp alltraps
801075cc:	e9 86 f6 ff ff       	jmp    80106c57 <alltraps>

801075d1 <vector122>:
.globl vector122
vector122:
  pushl $0
801075d1:	6a 00                	push   $0x0
  pushl $122
801075d3:	6a 7a                	push   $0x7a
  jmp alltraps
801075d5:	e9 7d f6 ff ff       	jmp    80106c57 <alltraps>

801075da <vector123>:
.globl vector123
vector123:
  pushl $0
801075da:	6a 00                	push   $0x0
  pushl $123
801075dc:	6a 7b                	push   $0x7b
  jmp alltraps
801075de:	e9 74 f6 ff ff       	jmp    80106c57 <alltraps>

801075e3 <vector124>:
.globl vector124
vector124:
  pushl $0
801075e3:	6a 00                	push   $0x0
  pushl $124
801075e5:	6a 7c                	push   $0x7c
  jmp alltraps
801075e7:	e9 6b f6 ff ff       	jmp    80106c57 <alltraps>

801075ec <vector125>:
.globl vector125
vector125:
  pushl $0
801075ec:	6a 00                	push   $0x0
  pushl $125
801075ee:	6a 7d                	push   $0x7d
  jmp alltraps
801075f0:	e9 62 f6 ff ff       	jmp    80106c57 <alltraps>

801075f5 <vector126>:
.globl vector126
vector126:
  pushl $0
801075f5:	6a 00                	push   $0x0
  pushl $126
801075f7:	6a 7e                	push   $0x7e
  jmp alltraps
801075f9:	e9 59 f6 ff ff       	jmp    80106c57 <alltraps>

801075fe <vector127>:
.globl vector127
vector127:
  pushl $0
801075fe:	6a 00                	push   $0x0
  pushl $127
80107600:	6a 7f                	push   $0x7f
  jmp alltraps
80107602:	e9 50 f6 ff ff       	jmp    80106c57 <alltraps>

80107607 <vector128>:
.globl vector128
vector128:
  pushl $0
80107607:	6a 00                	push   $0x0
  pushl $128
80107609:	68 80 00 00 00       	push   $0x80
  jmp alltraps
8010760e:	e9 44 f6 ff ff       	jmp    80106c57 <alltraps>

80107613 <vector129>:
.globl vector129
vector129:
  pushl $0
80107613:	6a 00                	push   $0x0
  pushl $129
80107615:	68 81 00 00 00       	push   $0x81
  jmp alltraps
8010761a:	e9 38 f6 ff ff       	jmp    80106c57 <alltraps>

8010761f <vector130>:
.globl vector130
vector130:
  pushl $0
8010761f:	6a 00                	push   $0x0
  pushl $130
80107621:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80107626:	e9 2c f6 ff ff       	jmp    80106c57 <alltraps>

8010762b <vector131>:
.globl vector131
vector131:
  pushl $0
8010762b:	6a 00                	push   $0x0
  pushl $131
8010762d:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80107632:	e9 20 f6 ff ff       	jmp    80106c57 <alltraps>

80107637 <vector132>:
.globl vector132
vector132:
  pushl $0
80107637:	6a 00                	push   $0x0
  pushl $132
80107639:	68 84 00 00 00       	push   $0x84
  jmp alltraps
8010763e:	e9 14 f6 ff ff       	jmp    80106c57 <alltraps>

80107643 <vector133>:
.globl vector133
vector133:
  pushl $0
80107643:	6a 00                	push   $0x0
  pushl $133
80107645:	68 85 00 00 00       	push   $0x85
  jmp alltraps
8010764a:	e9 08 f6 ff ff       	jmp    80106c57 <alltraps>

8010764f <vector134>:
.globl vector134
vector134:
  pushl $0
8010764f:	6a 00                	push   $0x0
  pushl $134
80107651:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80107656:	e9 fc f5 ff ff       	jmp    80106c57 <alltraps>

8010765b <vector135>:
.globl vector135
vector135:
  pushl $0
8010765b:	6a 00                	push   $0x0
  pushl $135
8010765d:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80107662:	e9 f0 f5 ff ff       	jmp    80106c57 <alltraps>

80107667 <vector136>:
.globl vector136
vector136:
  pushl $0
80107667:	6a 00                	push   $0x0
  pushl $136
80107669:	68 88 00 00 00       	push   $0x88
  jmp alltraps
8010766e:	e9 e4 f5 ff ff       	jmp    80106c57 <alltraps>

80107673 <vector137>:
.globl vector137
vector137:
  pushl $0
80107673:	6a 00                	push   $0x0
  pushl $137
80107675:	68 89 00 00 00       	push   $0x89
  jmp alltraps
8010767a:	e9 d8 f5 ff ff       	jmp    80106c57 <alltraps>

8010767f <vector138>:
.globl vector138
vector138:
  pushl $0
8010767f:	6a 00                	push   $0x0
  pushl $138
80107681:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80107686:	e9 cc f5 ff ff       	jmp    80106c57 <alltraps>

8010768b <vector139>:
.globl vector139
vector139:
  pushl $0
8010768b:	6a 00                	push   $0x0
  pushl $139
8010768d:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80107692:	e9 c0 f5 ff ff       	jmp    80106c57 <alltraps>

80107697 <vector140>:
.globl vector140
vector140:
  pushl $0
80107697:	6a 00                	push   $0x0
  pushl $140
80107699:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
8010769e:	e9 b4 f5 ff ff       	jmp    80106c57 <alltraps>

801076a3 <vector141>:
.globl vector141
vector141:
  pushl $0
801076a3:	6a 00                	push   $0x0
  pushl $141
801076a5:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
801076aa:	e9 a8 f5 ff ff       	jmp    80106c57 <alltraps>

801076af <vector142>:
.globl vector142
vector142:
  pushl $0
801076af:	6a 00                	push   $0x0
  pushl $142
801076b1:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
801076b6:	e9 9c f5 ff ff       	jmp    80106c57 <alltraps>

801076bb <vector143>:
.globl vector143
vector143:
  pushl $0
801076bb:	6a 00                	push   $0x0
  pushl $143
801076bd:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
801076c2:	e9 90 f5 ff ff       	jmp    80106c57 <alltraps>

801076c7 <vector144>:
.globl vector144
vector144:
  pushl $0
801076c7:	6a 00                	push   $0x0
  pushl $144
801076c9:	68 90 00 00 00       	push   $0x90
  jmp alltraps
801076ce:	e9 84 f5 ff ff       	jmp    80106c57 <alltraps>

801076d3 <vector145>:
.globl vector145
vector145:
  pushl $0
801076d3:	6a 00                	push   $0x0
  pushl $145
801076d5:	68 91 00 00 00       	push   $0x91
  jmp alltraps
801076da:	e9 78 f5 ff ff       	jmp    80106c57 <alltraps>

801076df <vector146>:
.globl vector146
vector146:
  pushl $0
801076df:	6a 00                	push   $0x0
  pushl $146
801076e1:	68 92 00 00 00       	push   $0x92
  jmp alltraps
801076e6:	e9 6c f5 ff ff       	jmp    80106c57 <alltraps>

801076eb <vector147>:
.globl vector147
vector147:
  pushl $0
801076eb:	6a 00                	push   $0x0
  pushl $147
801076ed:	68 93 00 00 00       	push   $0x93
  jmp alltraps
801076f2:	e9 60 f5 ff ff       	jmp    80106c57 <alltraps>

801076f7 <vector148>:
.globl vector148
vector148:
  pushl $0
801076f7:	6a 00                	push   $0x0
  pushl $148
801076f9:	68 94 00 00 00       	push   $0x94
  jmp alltraps
801076fe:	e9 54 f5 ff ff       	jmp    80106c57 <alltraps>

80107703 <vector149>:
.globl vector149
vector149:
  pushl $0
80107703:	6a 00                	push   $0x0
  pushl $149
80107705:	68 95 00 00 00       	push   $0x95
  jmp alltraps
8010770a:	e9 48 f5 ff ff       	jmp    80106c57 <alltraps>

8010770f <vector150>:
.globl vector150
vector150:
  pushl $0
8010770f:	6a 00                	push   $0x0
  pushl $150
80107711:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80107716:	e9 3c f5 ff ff       	jmp    80106c57 <alltraps>

8010771b <vector151>:
.globl vector151
vector151:
  pushl $0
8010771b:	6a 00                	push   $0x0
  pushl $151
8010771d:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80107722:	e9 30 f5 ff ff       	jmp    80106c57 <alltraps>

80107727 <vector152>:
.globl vector152
vector152:
  pushl $0
80107727:	6a 00                	push   $0x0
  pushl $152
80107729:	68 98 00 00 00       	push   $0x98
  jmp alltraps
8010772e:	e9 24 f5 ff ff       	jmp    80106c57 <alltraps>

80107733 <vector153>:
.globl vector153
vector153:
  pushl $0
80107733:	6a 00                	push   $0x0
  pushl $153
80107735:	68 99 00 00 00       	push   $0x99
  jmp alltraps
8010773a:	e9 18 f5 ff ff       	jmp    80106c57 <alltraps>

8010773f <vector154>:
.globl vector154
vector154:
  pushl $0
8010773f:	6a 00                	push   $0x0
  pushl $154
80107741:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80107746:	e9 0c f5 ff ff       	jmp    80106c57 <alltraps>

8010774b <vector155>:
.globl vector155
vector155:
  pushl $0
8010774b:	6a 00                	push   $0x0
  pushl $155
8010774d:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80107752:	e9 00 f5 ff ff       	jmp    80106c57 <alltraps>

80107757 <vector156>:
.globl vector156
vector156:
  pushl $0
80107757:	6a 00                	push   $0x0
  pushl $156
80107759:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
8010775e:	e9 f4 f4 ff ff       	jmp    80106c57 <alltraps>

80107763 <vector157>:
.globl vector157
vector157:
  pushl $0
80107763:	6a 00                	push   $0x0
  pushl $157
80107765:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
8010776a:	e9 e8 f4 ff ff       	jmp    80106c57 <alltraps>

8010776f <vector158>:
.globl vector158
vector158:
  pushl $0
8010776f:	6a 00                	push   $0x0
  pushl $158
80107771:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80107776:	e9 dc f4 ff ff       	jmp    80106c57 <alltraps>

8010777b <vector159>:
.globl vector159
vector159:
  pushl $0
8010777b:	6a 00                	push   $0x0
  pushl $159
8010777d:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80107782:	e9 d0 f4 ff ff       	jmp    80106c57 <alltraps>

80107787 <vector160>:
.globl vector160
vector160:
  pushl $0
80107787:	6a 00                	push   $0x0
  pushl $160
80107789:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
8010778e:	e9 c4 f4 ff ff       	jmp    80106c57 <alltraps>

80107793 <vector161>:
.globl vector161
vector161:
  pushl $0
80107793:	6a 00                	push   $0x0
  pushl $161
80107795:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
8010779a:	e9 b8 f4 ff ff       	jmp    80106c57 <alltraps>

8010779f <vector162>:
.globl vector162
vector162:
  pushl $0
8010779f:	6a 00                	push   $0x0
  pushl $162
801077a1:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
801077a6:	e9 ac f4 ff ff       	jmp    80106c57 <alltraps>

801077ab <vector163>:
.globl vector163
vector163:
  pushl $0
801077ab:	6a 00                	push   $0x0
  pushl $163
801077ad:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
801077b2:	e9 a0 f4 ff ff       	jmp    80106c57 <alltraps>

801077b7 <vector164>:
.globl vector164
vector164:
  pushl $0
801077b7:	6a 00                	push   $0x0
  pushl $164
801077b9:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
801077be:	e9 94 f4 ff ff       	jmp    80106c57 <alltraps>

801077c3 <vector165>:
.globl vector165
vector165:
  pushl $0
801077c3:	6a 00                	push   $0x0
  pushl $165
801077c5:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
801077ca:	e9 88 f4 ff ff       	jmp    80106c57 <alltraps>

801077cf <vector166>:
.globl vector166
vector166:
  pushl $0
801077cf:	6a 00                	push   $0x0
  pushl $166
801077d1:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
801077d6:	e9 7c f4 ff ff       	jmp    80106c57 <alltraps>

801077db <vector167>:
.globl vector167
vector167:
  pushl $0
801077db:	6a 00                	push   $0x0
  pushl $167
801077dd:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
801077e2:	e9 70 f4 ff ff       	jmp    80106c57 <alltraps>

801077e7 <vector168>:
.globl vector168
vector168:
  pushl $0
801077e7:	6a 00                	push   $0x0
  pushl $168
801077e9:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
801077ee:	e9 64 f4 ff ff       	jmp    80106c57 <alltraps>

801077f3 <vector169>:
.globl vector169
vector169:
  pushl $0
801077f3:	6a 00                	push   $0x0
  pushl $169
801077f5:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
801077fa:	e9 58 f4 ff ff       	jmp    80106c57 <alltraps>

801077ff <vector170>:
.globl vector170
vector170:
  pushl $0
801077ff:	6a 00                	push   $0x0
  pushl $170
80107801:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80107806:	e9 4c f4 ff ff       	jmp    80106c57 <alltraps>

8010780b <vector171>:
.globl vector171
vector171:
  pushl $0
8010780b:	6a 00                	push   $0x0
  pushl $171
8010780d:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80107812:	e9 40 f4 ff ff       	jmp    80106c57 <alltraps>

80107817 <vector172>:
.globl vector172
vector172:
  pushl $0
80107817:	6a 00                	push   $0x0
  pushl $172
80107819:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
8010781e:	e9 34 f4 ff ff       	jmp    80106c57 <alltraps>

80107823 <vector173>:
.globl vector173
vector173:
  pushl $0
80107823:	6a 00                	push   $0x0
  pushl $173
80107825:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
8010782a:	e9 28 f4 ff ff       	jmp    80106c57 <alltraps>

8010782f <vector174>:
.globl vector174
vector174:
  pushl $0
8010782f:	6a 00                	push   $0x0
  pushl $174
80107831:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80107836:	e9 1c f4 ff ff       	jmp    80106c57 <alltraps>

8010783b <vector175>:
.globl vector175
vector175:
  pushl $0
8010783b:	6a 00                	push   $0x0
  pushl $175
8010783d:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80107842:	e9 10 f4 ff ff       	jmp    80106c57 <alltraps>

80107847 <vector176>:
.globl vector176
vector176:
  pushl $0
80107847:	6a 00                	push   $0x0
  pushl $176
80107849:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
8010784e:	e9 04 f4 ff ff       	jmp    80106c57 <alltraps>

80107853 <vector177>:
.globl vector177
vector177:
  pushl $0
80107853:	6a 00                	push   $0x0
  pushl $177
80107855:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
8010785a:	e9 f8 f3 ff ff       	jmp    80106c57 <alltraps>

8010785f <vector178>:
.globl vector178
vector178:
  pushl $0
8010785f:	6a 00                	push   $0x0
  pushl $178
80107861:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80107866:	e9 ec f3 ff ff       	jmp    80106c57 <alltraps>

8010786b <vector179>:
.globl vector179
vector179:
  pushl $0
8010786b:	6a 00                	push   $0x0
  pushl $179
8010786d:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80107872:	e9 e0 f3 ff ff       	jmp    80106c57 <alltraps>

80107877 <vector180>:
.globl vector180
vector180:
  pushl $0
80107877:	6a 00                	push   $0x0
  pushl $180
80107879:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
8010787e:	e9 d4 f3 ff ff       	jmp    80106c57 <alltraps>

80107883 <vector181>:
.globl vector181
vector181:
  pushl $0
80107883:	6a 00                	push   $0x0
  pushl $181
80107885:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
8010788a:	e9 c8 f3 ff ff       	jmp    80106c57 <alltraps>

8010788f <vector182>:
.globl vector182
vector182:
  pushl $0
8010788f:	6a 00                	push   $0x0
  pushl $182
80107891:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80107896:	e9 bc f3 ff ff       	jmp    80106c57 <alltraps>

8010789b <vector183>:
.globl vector183
vector183:
  pushl $0
8010789b:	6a 00                	push   $0x0
  pushl $183
8010789d:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
801078a2:	e9 b0 f3 ff ff       	jmp    80106c57 <alltraps>

801078a7 <vector184>:
.globl vector184
vector184:
  pushl $0
801078a7:	6a 00                	push   $0x0
  pushl $184
801078a9:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
801078ae:	e9 a4 f3 ff ff       	jmp    80106c57 <alltraps>

801078b3 <vector185>:
.globl vector185
vector185:
  pushl $0
801078b3:	6a 00                	push   $0x0
  pushl $185
801078b5:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
801078ba:	e9 98 f3 ff ff       	jmp    80106c57 <alltraps>

801078bf <vector186>:
.globl vector186
vector186:
  pushl $0
801078bf:	6a 00                	push   $0x0
  pushl $186
801078c1:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
801078c6:	e9 8c f3 ff ff       	jmp    80106c57 <alltraps>

801078cb <vector187>:
.globl vector187
vector187:
  pushl $0
801078cb:	6a 00                	push   $0x0
  pushl $187
801078cd:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
801078d2:	e9 80 f3 ff ff       	jmp    80106c57 <alltraps>

801078d7 <vector188>:
.globl vector188
vector188:
  pushl $0
801078d7:	6a 00                	push   $0x0
  pushl $188
801078d9:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
801078de:	e9 74 f3 ff ff       	jmp    80106c57 <alltraps>

801078e3 <vector189>:
.globl vector189
vector189:
  pushl $0
801078e3:	6a 00                	push   $0x0
  pushl $189
801078e5:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
801078ea:	e9 68 f3 ff ff       	jmp    80106c57 <alltraps>

801078ef <vector190>:
.globl vector190
vector190:
  pushl $0
801078ef:	6a 00                	push   $0x0
  pushl $190
801078f1:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
801078f6:	e9 5c f3 ff ff       	jmp    80106c57 <alltraps>

801078fb <vector191>:
.globl vector191
vector191:
  pushl $0
801078fb:	6a 00                	push   $0x0
  pushl $191
801078fd:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80107902:	e9 50 f3 ff ff       	jmp    80106c57 <alltraps>

80107907 <vector192>:
.globl vector192
vector192:
  pushl $0
80107907:	6a 00                	push   $0x0
  pushl $192
80107909:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
8010790e:	e9 44 f3 ff ff       	jmp    80106c57 <alltraps>

80107913 <vector193>:
.globl vector193
vector193:
  pushl $0
80107913:	6a 00                	push   $0x0
  pushl $193
80107915:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
8010791a:	e9 38 f3 ff ff       	jmp    80106c57 <alltraps>

8010791f <vector194>:
.globl vector194
vector194:
  pushl $0
8010791f:	6a 00                	push   $0x0
  pushl $194
80107921:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80107926:	e9 2c f3 ff ff       	jmp    80106c57 <alltraps>

8010792b <vector195>:
.globl vector195
vector195:
  pushl $0
8010792b:	6a 00                	push   $0x0
  pushl $195
8010792d:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80107932:	e9 20 f3 ff ff       	jmp    80106c57 <alltraps>

80107937 <vector196>:
.globl vector196
vector196:
  pushl $0
80107937:	6a 00                	push   $0x0
  pushl $196
80107939:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
8010793e:	e9 14 f3 ff ff       	jmp    80106c57 <alltraps>

80107943 <vector197>:
.globl vector197
vector197:
  pushl $0
80107943:	6a 00                	push   $0x0
  pushl $197
80107945:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
8010794a:	e9 08 f3 ff ff       	jmp    80106c57 <alltraps>

8010794f <vector198>:
.globl vector198
vector198:
  pushl $0
8010794f:	6a 00                	push   $0x0
  pushl $198
80107951:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80107956:	e9 fc f2 ff ff       	jmp    80106c57 <alltraps>

8010795b <vector199>:
.globl vector199
vector199:
  pushl $0
8010795b:	6a 00                	push   $0x0
  pushl $199
8010795d:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80107962:	e9 f0 f2 ff ff       	jmp    80106c57 <alltraps>

80107967 <vector200>:
.globl vector200
vector200:
  pushl $0
80107967:	6a 00                	push   $0x0
  pushl $200
80107969:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
8010796e:	e9 e4 f2 ff ff       	jmp    80106c57 <alltraps>

80107973 <vector201>:
.globl vector201
vector201:
  pushl $0
80107973:	6a 00                	push   $0x0
  pushl $201
80107975:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
8010797a:	e9 d8 f2 ff ff       	jmp    80106c57 <alltraps>

8010797f <vector202>:
.globl vector202
vector202:
  pushl $0
8010797f:	6a 00                	push   $0x0
  pushl $202
80107981:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80107986:	e9 cc f2 ff ff       	jmp    80106c57 <alltraps>

8010798b <vector203>:
.globl vector203
vector203:
  pushl $0
8010798b:	6a 00                	push   $0x0
  pushl $203
8010798d:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80107992:	e9 c0 f2 ff ff       	jmp    80106c57 <alltraps>

80107997 <vector204>:
.globl vector204
vector204:
  pushl $0
80107997:	6a 00                	push   $0x0
  pushl $204
80107999:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
8010799e:	e9 b4 f2 ff ff       	jmp    80106c57 <alltraps>

801079a3 <vector205>:
.globl vector205
vector205:
  pushl $0
801079a3:	6a 00                	push   $0x0
  pushl $205
801079a5:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
801079aa:	e9 a8 f2 ff ff       	jmp    80106c57 <alltraps>

801079af <vector206>:
.globl vector206
vector206:
  pushl $0
801079af:	6a 00                	push   $0x0
  pushl $206
801079b1:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
801079b6:	e9 9c f2 ff ff       	jmp    80106c57 <alltraps>

801079bb <vector207>:
.globl vector207
vector207:
  pushl $0
801079bb:	6a 00                	push   $0x0
  pushl $207
801079bd:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
801079c2:	e9 90 f2 ff ff       	jmp    80106c57 <alltraps>

801079c7 <vector208>:
.globl vector208
vector208:
  pushl $0
801079c7:	6a 00                	push   $0x0
  pushl $208
801079c9:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
801079ce:	e9 84 f2 ff ff       	jmp    80106c57 <alltraps>

801079d3 <vector209>:
.globl vector209
vector209:
  pushl $0
801079d3:	6a 00                	push   $0x0
  pushl $209
801079d5:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
801079da:	e9 78 f2 ff ff       	jmp    80106c57 <alltraps>

801079df <vector210>:
.globl vector210
vector210:
  pushl $0
801079df:	6a 00                	push   $0x0
  pushl $210
801079e1:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
801079e6:	e9 6c f2 ff ff       	jmp    80106c57 <alltraps>

801079eb <vector211>:
.globl vector211
vector211:
  pushl $0
801079eb:	6a 00                	push   $0x0
  pushl $211
801079ed:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
801079f2:	e9 60 f2 ff ff       	jmp    80106c57 <alltraps>

801079f7 <vector212>:
.globl vector212
vector212:
  pushl $0
801079f7:	6a 00                	push   $0x0
  pushl $212
801079f9:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
801079fe:	e9 54 f2 ff ff       	jmp    80106c57 <alltraps>

80107a03 <vector213>:
.globl vector213
vector213:
  pushl $0
80107a03:	6a 00                	push   $0x0
  pushl $213
80107a05:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80107a0a:	e9 48 f2 ff ff       	jmp    80106c57 <alltraps>

80107a0f <vector214>:
.globl vector214
vector214:
  pushl $0
80107a0f:	6a 00                	push   $0x0
  pushl $214
80107a11:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80107a16:	e9 3c f2 ff ff       	jmp    80106c57 <alltraps>

80107a1b <vector215>:
.globl vector215
vector215:
  pushl $0
80107a1b:	6a 00                	push   $0x0
  pushl $215
80107a1d:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80107a22:	e9 30 f2 ff ff       	jmp    80106c57 <alltraps>

80107a27 <vector216>:
.globl vector216
vector216:
  pushl $0
80107a27:	6a 00                	push   $0x0
  pushl $216
80107a29:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80107a2e:	e9 24 f2 ff ff       	jmp    80106c57 <alltraps>

80107a33 <vector217>:
.globl vector217
vector217:
  pushl $0
80107a33:	6a 00                	push   $0x0
  pushl $217
80107a35:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80107a3a:	e9 18 f2 ff ff       	jmp    80106c57 <alltraps>

80107a3f <vector218>:
.globl vector218
vector218:
  pushl $0
80107a3f:	6a 00                	push   $0x0
  pushl $218
80107a41:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80107a46:	e9 0c f2 ff ff       	jmp    80106c57 <alltraps>

80107a4b <vector219>:
.globl vector219
vector219:
  pushl $0
80107a4b:	6a 00                	push   $0x0
  pushl $219
80107a4d:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80107a52:	e9 00 f2 ff ff       	jmp    80106c57 <alltraps>

80107a57 <vector220>:
.globl vector220
vector220:
  pushl $0
80107a57:	6a 00                	push   $0x0
  pushl $220
80107a59:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80107a5e:	e9 f4 f1 ff ff       	jmp    80106c57 <alltraps>

80107a63 <vector221>:
.globl vector221
vector221:
  pushl $0
80107a63:	6a 00                	push   $0x0
  pushl $221
80107a65:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80107a6a:	e9 e8 f1 ff ff       	jmp    80106c57 <alltraps>

80107a6f <vector222>:
.globl vector222
vector222:
  pushl $0
80107a6f:	6a 00                	push   $0x0
  pushl $222
80107a71:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80107a76:	e9 dc f1 ff ff       	jmp    80106c57 <alltraps>

80107a7b <vector223>:
.globl vector223
vector223:
  pushl $0
80107a7b:	6a 00                	push   $0x0
  pushl $223
80107a7d:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80107a82:	e9 d0 f1 ff ff       	jmp    80106c57 <alltraps>

80107a87 <vector224>:
.globl vector224
vector224:
  pushl $0
80107a87:	6a 00                	push   $0x0
  pushl $224
80107a89:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80107a8e:	e9 c4 f1 ff ff       	jmp    80106c57 <alltraps>

80107a93 <vector225>:
.globl vector225
vector225:
  pushl $0
80107a93:	6a 00                	push   $0x0
  pushl $225
80107a95:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80107a9a:	e9 b8 f1 ff ff       	jmp    80106c57 <alltraps>

80107a9f <vector226>:
.globl vector226
vector226:
  pushl $0
80107a9f:	6a 00                	push   $0x0
  pushl $226
80107aa1:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80107aa6:	e9 ac f1 ff ff       	jmp    80106c57 <alltraps>

80107aab <vector227>:
.globl vector227
vector227:
  pushl $0
80107aab:	6a 00                	push   $0x0
  pushl $227
80107aad:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80107ab2:	e9 a0 f1 ff ff       	jmp    80106c57 <alltraps>

80107ab7 <vector228>:
.globl vector228
vector228:
  pushl $0
80107ab7:	6a 00                	push   $0x0
  pushl $228
80107ab9:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80107abe:	e9 94 f1 ff ff       	jmp    80106c57 <alltraps>

80107ac3 <vector229>:
.globl vector229
vector229:
  pushl $0
80107ac3:	6a 00                	push   $0x0
  pushl $229
80107ac5:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80107aca:	e9 88 f1 ff ff       	jmp    80106c57 <alltraps>

80107acf <vector230>:
.globl vector230
vector230:
  pushl $0
80107acf:	6a 00                	push   $0x0
  pushl $230
80107ad1:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80107ad6:	e9 7c f1 ff ff       	jmp    80106c57 <alltraps>

80107adb <vector231>:
.globl vector231
vector231:
  pushl $0
80107adb:	6a 00                	push   $0x0
  pushl $231
80107add:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80107ae2:	e9 70 f1 ff ff       	jmp    80106c57 <alltraps>

80107ae7 <vector232>:
.globl vector232
vector232:
  pushl $0
80107ae7:	6a 00                	push   $0x0
  pushl $232
80107ae9:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80107aee:	e9 64 f1 ff ff       	jmp    80106c57 <alltraps>

80107af3 <vector233>:
.globl vector233
vector233:
  pushl $0
80107af3:	6a 00                	push   $0x0
  pushl $233
80107af5:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80107afa:	e9 58 f1 ff ff       	jmp    80106c57 <alltraps>

80107aff <vector234>:
.globl vector234
vector234:
  pushl $0
80107aff:	6a 00                	push   $0x0
  pushl $234
80107b01:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80107b06:	e9 4c f1 ff ff       	jmp    80106c57 <alltraps>

80107b0b <vector235>:
.globl vector235
vector235:
  pushl $0
80107b0b:	6a 00                	push   $0x0
  pushl $235
80107b0d:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80107b12:	e9 40 f1 ff ff       	jmp    80106c57 <alltraps>

80107b17 <vector236>:
.globl vector236
vector236:
  pushl $0
80107b17:	6a 00                	push   $0x0
  pushl $236
80107b19:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80107b1e:	e9 34 f1 ff ff       	jmp    80106c57 <alltraps>

80107b23 <vector237>:
.globl vector237
vector237:
  pushl $0
80107b23:	6a 00                	push   $0x0
  pushl $237
80107b25:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80107b2a:	e9 28 f1 ff ff       	jmp    80106c57 <alltraps>

80107b2f <vector238>:
.globl vector238
vector238:
  pushl $0
80107b2f:	6a 00                	push   $0x0
  pushl $238
80107b31:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80107b36:	e9 1c f1 ff ff       	jmp    80106c57 <alltraps>

80107b3b <vector239>:
.globl vector239
vector239:
  pushl $0
80107b3b:	6a 00                	push   $0x0
  pushl $239
80107b3d:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80107b42:	e9 10 f1 ff ff       	jmp    80106c57 <alltraps>

80107b47 <vector240>:
.globl vector240
vector240:
  pushl $0
80107b47:	6a 00                	push   $0x0
  pushl $240
80107b49:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80107b4e:	e9 04 f1 ff ff       	jmp    80106c57 <alltraps>

80107b53 <vector241>:
.globl vector241
vector241:
  pushl $0
80107b53:	6a 00                	push   $0x0
  pushl $241
80107b55:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80107b5a:	e9 f8 f0 ff ff       	jmp    80106c57 <alltraps>

80107b5f <vector242>:
.globl vector242
vector242:
  pushl $0
80107b5f:	6a 00                	push   $0x0
  pushl $242
80107b61:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80107b66:	e9 ec f0 ff ff       	jmp    80106c57 <alltraps>

80107b6b <vector243>:
.globl vector243
vector243:
  pushl $0
80107b6b:	6a 00                	push   $0x0
  pushl $243
80107b6d:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80107b72:	e9 e0 f0 ff ff       	jmp    80106c57 <alltraps>

80107b77 <vector244>:
.globl vector244
vector244:
  pushl $0
80107b77:	6a 00                	push   $0x0
  pushl $244
80107b79:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80107b7e:	e9 d4 f0 ff ff       	jmp    80106c57 <alltraps>

80107b83 <vector245>:
.globl vector245
vector245:
  pushl $0
80107b83:	6a 00                	push   $0x0
  pushl $245
80107b85:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80107b8a:	e9 c8 f0 ff ff       	jmp    80106c57 <alltraps>

80107b8f <vector246>:
.globl vector246
vector246:
  pushl $0
80107b8f:	6a 00                	push   $0x0
  pushl $246
80107b91:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80107b96:	e9 bc f0 ff ff       	jmp    80106c57 <alltraps>

80107b9b <vector247>:
.globl vector247
vector247:
  pushl $0
80107b9b:	6a 00                	push   $0x0
  pushl $247
80107b9d:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80107ba2:	e9 b0 f0 ff ff       	jmp    80106c57 <alltraps>

80107ba7 <vector248>:
.globl vector248
vector248:
  pushl $0
80107ba7:	6a 00                	push   $0x0
  pushl $248
80107ba9:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80107bae:	e9 a4 f0 ff ff       	jmp    80106c57 <alltraps>

80107bb3 <vector249>:
.globl vector249
vector249:
  pushl $0
80107bb3:	6a 00                	push   $0x0
  pushl $249
80107bb5:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80107bba:	e9 98 f0 ff ff       	jmp    80106c57 <alltraps>

80107bbf <vector250>:
.globl vector250
vector250:
  pushl $0
80107bbf:	6a 00                	push   $0x0
  pushl $250
80107bc1:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80107bc6:	e9 8c f0 ff ff       	jmp    80106c57 <alltraps>

80107bcb <vector251>:
.globl vector251
vector251:
  pushl $0
80107bcb:	6a 00                	push   $0x0
  pushl $251
80107bcd:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80107bd2:	e9 80 f0 ff ff       	jmp    80106c57 <alltraps>

80107bd7 <vector252>:
.globl vector252
vector252:
  pushl $0
80107bd7:	6a 00                	push   $0x0
  pushl $252
80107bd9:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80107bde:	e9 74 f0 ff ff       	jmp    80106c57 <alltraps>

80107be3 <vector253>:
.globl vector253
vector253:
  pushl $0
80107be3:	6a 00                	push   $0x0
  pushl $253
80107be5:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80107bea:	e9 68 f0 ff ff       	jmp    80106c57 <alltraps>

80107bef <vector254>:
.globl vector254
vector254:
  pushl $0
80107bef:	6a 00                	push   $0x0
  pushl $254
80107bf1:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80107bf6:	e9 5c f0 ff ff       	jmp    80106c57 <alltraps>

80107bfb <vector255>:
.globl vector255
vector255:
  pushl $0
80107bfb:	6a 00                	push   $0x0
  pushl $255
80107bfd:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80107c02:	e9 50 f0 ff ff       	jmp    80106c57 <alltraps>
80107c07:	66 90                	xchg   %ax,%ax
80107c09:	66 90                	xchg   %ax,%ax
80107c0b:	66 90                	xchg   %ax,%ax
80107c0d:	66 90                	xchg   %ax,%ax
80107c0f:	90                   	nop

80107c10 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80107c10:	55                   	push   %ebp
80107c11:	89 e5                	mov    %esp,%ebp
80107c13:	57                   	push   %edi
80107c14:	56                   	push   %esi
80107c15:	53                   	push   %ebx
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80107c16:	89 d3                	mov    %edx,%ebx
{
80107c18:	89 d7                	mov    %edx,%edi
  pde = &pgdir[PDX(va)];
80107c1a:	c1 eb 16             	shr    $0x16,%ebx
80107c1d:	8d 34 98             	lea    (%eax,%ebx,4),%esi
{
80107c20:	83 ec 0c             	sub    $0xc,%esp
  if(*pde & PTE_P){
80107c23:	8b 06                	mov    (%esi),%eax
80107c25:	a8 01                	test   $0x1,%al
80107c27:	74 27                	je     80107c50 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107c29:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107c2e:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80107c34:	c1 ef 0a             	shr    $0xa,%edi
}
80107c37:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return &pgtab[PTX(va)];
80107c3a:	89 fa                	mov    %edi,%edx
80107c3c:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80107c42:	8d 04 13             	lea    (%ebx,%edx,1),%eax
}
80107c45:	5b                   	pop    %ebx
80107c46:	5e                   	pop    %esi
80107c47:	5f                   	pop    %edi
80107c48:	5d                   	pop    %ebp
80107c49:	c3                   	ret    
80107c4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80107c50:	85 c9                	test   %ecx,%ecx
80107c52:	74 2c                	je     80107c80 <walkpgdir+0x70>
80107c54:	e8 97 ae ff ff       	call   80102af0 <kalloc>
80107c59:	85 c0                	test   %eax,%eax
80107c5b:	89 c3                	mov    %eax,%ebx
80107c5d:	74 21                	je     80107c80 <walkpgdir+0x70>
    memset(pgtab, 0, PGSIZE);
80107c5f:	83 ec 04             	sub    $0x4,%esp
80107c62:	68 00 10 00 00       	push   $0x1000
80107c67:	6a 00                	push   $0x0
80107c69:	50                   	push   %eax
80107c6a:	e8 a1 db ff ff       	call   80105810 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80107c6f:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80107c75:	83 c4 10             	add    $0x10,%esp
80107c78:	83 c8 07             	or     $0x7,%eax
80107c7b:	89 06                	mov    %eax,(%esi)
80107c7d:	eb b5                	jmp    80107c34 <walkpgdir+0x24>
80107c7f:	90                   	nop
}
80107c80:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
80107c83:	31 c0                	xor    %eax,%eax
}
80107c85:	5b                   	pop    %ebx
80107c86:	5e                   	pop    %esi
80107c87:	5f                   	pop    %edi
80107c88:	5d                   	pop    %ebp
80107c89:	c3                   	ret    
80107c8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107c90 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80107c90:	55                   	push   %ebp
80107c91:	89 e5                	mov    %esp,%ebp
80107c93:	57                   	push   %edi
80107c94:	56                   	push   %esi
80107c95:	53                   	push   %ebx
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
80107c96:	89 d3                	mov    %edx,%ebx
80107c98:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
80107c9e:	83 ec 1c             	sub    $0x1c,%esp
80107ca1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80107ca4:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80107ca8:	8b 7d 08             	mov    0x8(%ebp),%edi
80107cab:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107cb0:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
80107cb3:	8b 45 0c             	mov    0xc(%ebp),%eax
80107cb6:	29 df                	sub    %ebx,%edi
80107cb8:	83 c8 01             	or     $0x1,%eax
80107cbb:	89 45 dc             	mov    %eax,-0x24(%ebp)
80107cbe:	eb 15                	jmp    80107cd5 <mappages+0x45>
    if(*pte & PTE_P)
80107cc0:	f6 00 01             	testb  $0x1,(%eax)
80107cc3:	75 45                	jne    80107d0a <mappages+0x7a>
    *pte = pa | perm | PTE_P;
80107cc5:	0b 75 dc             	or     -0x24(%ebp),%esi
    if(a == last)
80107cc8:	3b 5d e0             	cmp    -0x20(%ebp),%ebx
    *pte = pa | perm | PTE_P;
80107ccb:	89 30                	mov    %esi,(%eax)
    if(a == last)
80107ccd:	74 31                	je     80107d00 <mappages+0x70>
      break;
    a += PGSIZE;
80107ccf:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80107cd5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107cd8:	b9 01 00 00 00       	mov    $0x1,%ecx
80107cdd:	89 da                	mov    %ebx,%edx
80107cdf:	8d 34 3b             	lea    (%ebx,%edi,1),%esi
80107ce2:	e8 29 ff ff ff       	call   80107c10 <walkpgdir>
80107ce7:	85 c0                	test   %eax,%eax
80107ce9:	75 d5                	jne    80107cc0 <mappages+0x30>
    pa += PGSIZE;
  }
  return 0;
}
80107ceb:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107cee:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107cf3:	5b                   	pop    %ebx
80107cf4:	5e                   	pop    %esi
80107cf5:	5f                   	pop    %edi
80107cf6:	5d                   	pop    %ebp
80107cf7:	c3                   	ret    
80107cf8:	90                   	nop
80107cf9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107d00:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107d03:	31 c0                	xor    %eax,%eax
}
80107d05:	5b                   	pop    %ebx
80107d06:	5e                   	pop    %esi
80107d07:	5f                   	pop    %edi
80107d08:	5d                   	pop    %ebp
80107d09:	c3                   	ret    
      panic("remap");
80107d0a:	83 ec 0c             	sub    $0xc,%esp
80107d0d:	68 98 99 10 80       	push   $0x80109998
80107d12:	e8 79 86 ff ff       	call   80100390 <panic>
80107d17:	89 f6                	mov    %esi,%esi
80107d19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107d20 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80107d20:	55                   	push   %ebp
80107d21:	89 e5                	mov    %esp,%ebp
80107d23:	57                   	push   %edi
80107d24:	56                   	push   %esi
80107d25:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80107d26:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80107d2c:	89 c7                	mov    %eax,%edi
  a = PGROUNDUP(newsz);
80107d2e:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80107d34:	83 ec 1c             	sub    $0x1c,%esp
80107d37:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80107d3a:	39 d3                	cmp    %edx,%ebx
80107d3c:	73 66                	jae    80107da4 <deallocuvm.part.0+0x84>
80107d3e:	89 d6                	mov    %edx,%esi
80107d40:	eb 3d                	jmp    80107d7f <deallocuvm.part.0+0x5f>
80107d42:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
80107d48:	8b 10                	mov    (%eax),%edx
80107d4a:	f6 c2 01             	test   $0x1,%dl
80107d4d:	74 26                	je     80107d75 <deallocuvm.part.0+0x55>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
80107d4f:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
80107d55:	74 58                	je     80107daf <deallocuvm.part.0+0x8f>
        panic("kfree");
      char *v = P2V(pa);
      kfree(v);
80107d57:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
80107d5a:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80107d60:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      kfree(v);
80107d63:	52                   	push   %edx
80107d64:	e8 d7 ab ff ff       	call   80102940 <kfree>
      *pte = 0;
80107d69:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107d6c:	83 c4 10             	add    $0x10,%esp
80107d6f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; a  < oldsz; a += PGSIZE){
80107d75:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107d7b:	39 f3                	cmp    %esi,%ebx
80107d7d:	73 25                	jae    80107da4 <deallocuvm.part.0+0x84>
    pte = walkpgdir(pgdir, (char*)a, 0);
80107d7f:	31 c9                	xor    %ecx,%ecx
80107d81:	89 da                	mov    %ebx,%edx
80107d83:	89 f8                	mov    %edi,%eax
80107d85:	e8 86 fe ff ff       	call   80107c10 <walkpgdir>
    if(!pte)
80107d8a:	85 c0                	test   %eax,%eax
80107d8c:	75 ba                	jne    80107d48 <deallocuvm.part.0+0x28>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80107d8e:	81 e3 00 00 c0 ff    	and    $0xffc00000,%ebx
80107d94:	81 c3 00 f0 3f 00    	add    $0x3ff000,%ebx
  for(; a  < oldsz; a += PGSIZE){
80107d9a:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107da0:	39 f3                	cmp    %esi,%ebx
80107da2:	72 db                	jb     80107d7f <deallocuvm.part.0+0x5f>
    }
  }
  return newsz;
}
80107da4:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107da7:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107daa:	5b                   	pop    %ebx
80107dab:	5e                   	pop    %esi
80107dac:	5f                   	pop    %edi
80107dad:	5d                   	pop    %ebp
80107dae:	c3                   	ret    
        panic("kfree");
80107daf:	83 ec 0c             	sub    $0xc,%esp
80107db2:	68 26 92 10 80       	push   $0x80109226
80107db7:	e8 d4 85 ff ff       	call   80100390 <panic>
80107dbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107dc0 <seginit>:
{
80107dc0:	55                   	push   %ebp
80107dc1:	89 e5                	mov    %esp,%ebp
80107dc3:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80107dc6:	e8 c5 c4 ff ff       	call   80104290 <cpuid>
80107dcb:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
  pd[0] = size-1;
80107dd1:	ba 2f 00 00 00       	mov    $0x2f,%edx
80107dd6:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80107dda:	c7 80 f8 47 11 80 ff 	movl   $0xffff,-0x7feeb808(%eax)
80107de1:	ff 00 00 
80107de4:	c7 80 fc 47 11 80 00 	movl   $0xcf9a00,-0x7feeb804(%eax)
80107deb:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80107dee:	c7 80 00 48 11 80 ff 	movl   $0xffff,-0x7feeb800(%eax)
80107df5:	ff 00 00 
80107df8:	c7 80 04 48 11 80 00 	movl   $0xcf9200,-0x7feeb7fc(%eax)
80107dff:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80107e02:	c7 80 08 48 11 80 ff 	movl   $0xffff,-0x7feeb7f8(%eax)
80107e09:	ff 00 00 
80107e0c:	c7 80 0c 48 11 80 00 	movl   $0xcffa00,-0x7feeb7f4(%eax)
80107e13:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80107e16:	c7 80 10 48 11 80 ff 	movl   $0xffff,-0x7feeb7f0(%eax)
80107e1d:	ff 00 00 
80107e20:	c7 80 14 48 11 80 00 	movl   $0xcff200,-0x7feeb7ec(%eax)
80107e27:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
80107e2a:	05 f0 47 11 80       	add    $0x801147f0,%eax
  pd[1] = (uint)p;
80107e2f:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80107e33:	c1 e8 10             	shr    $0x10,%eax
80107e36:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
80107e3a:	8d 45 f2             	lea    -0xe(%ebp),%eax
80107e3d:	0f 01 10             	lgdtl  (%eax)
}
80107e40:	c9                   	leave  
80107e41:	c3                   	ret    
80107e42:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107e49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107e50 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107e50:	a1 c4 cf 11 80       	mov    0x8011cfc4,%eax
{
80107e55:	55                   	push   %ebp
80107e56:	89 e5                	mov    %esp,%ebp
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107e58:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107e5d:	0f 22 d8             	mov    %eax,%cr3
}
80107e60:	5d                   	pop    %ebp
80107e61:	c3                   	ret    
80107e62:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107e69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107e70 <switchuvm>:
{
80107e70:	55                   	push   %ebp
80107e71:	89 e5                	mov    %esp,%ebp
80107e73:	57                   	push   %edi
80107e74:	56                   	push   %esi
80107e75:	53                   	push   %ebx
80107e76:	83 ec 1c             	sub    $0x1c,%esp
80107e79:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(p == 0)
80107e7c:	85 db                	test   %ebx,%ebx
80107e7e:	0f 84 cb 00 00 00    	je     80107f4f <switchuvm+0xdf>
  if(p->kstack == 0)
80107e84:	8b 43 08             	mov    0x8(%ebx),%eax
80107e87:	85 c0                	test   %eax,%eax
80107e89:	0f 84 da 00 00 00    	je     80107f69 <switchuvm+0xf9>
  if(p->pgdir == 0)
80107e8f:	8b 43 04             	mov    0x4(%ebx),%eax
80107e92:	85 c0                	test   %eax,%eax
80107e94:	0f 84 c2 00 00 00    	je     80107f5c <switchuvm+0xec>
  pushcli();
80107e9a:	e8 91 d7 ff ff       	call   80105630 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80107e9f:	e8 6c c3 ff ff       	call   80104210 <mycpu>
80107ea4:	89 c6                	mov    %eax,%esi
80107ea6:	e8 65 c3 ff ff       	call   80104210 <mycpu>
80107eab:	89 c7                	mov    %eax,%edi
80107ead:	e8 5e c3 ff ff       	call   80104210 <mycpu>
80107eb2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107eb5:	83 c7 08             	add    $0x8,%edi
80107eb8:	e8 53 c3 ff ff       	call   80104210 <mycpu>
80107ebd:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80107ec0:	83 c0 08             	add    $0x8,%eax
80107ec3:	ba 67 00 00 00       	mov    $0x67,%edx
80107ec8:	c1 e8 18             	shr    $0x18,%eax
80107ecb:	66 89 96 98 00 00 00 	mov    %dx,0x98(%esi)
80107ed2:	66 89 be 9a 00 00 00 	mov    %di,0x9a(%esi)
80107ed9:	88 86 9f 00 00 00    	mov    %al,0x9f(%esi)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80107edf:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80107ee4:	83 c1 08             	add    $0x8,%ecx
80107ee7:	c1 e9 10             	shr    $0x10,%ecx
80107eea:	88 8e 9c 00 00 00    	mov    %cl,0x9c(%esi)
80107ef0:	b9 99 40 00 00       	mov    $0x4099,%ecx
80107ef5:	66 89 8e 9d 00 00 00 	mov    %cx,0x9d(%esi)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80107efc:	be 10 00 00 00       	mov    $0x10,%esi
  mycpu()->gdt[SEG_TSS].s = 0;
80107f01:	e8 0a c3 ff ff       	call   80104210 <mycpu>
80107f06:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80107f0d:	e8 fe c2 ff ff       	call   80104210 <mycpu>
80107f12:	66 89 70 10          	mov    %si,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80107f16:	8b 73 08             	mov    0x8(%ebx),%esi
80107f19:	e8 f2 c2 ff ff       	call   80104210 <mycpu>
80107f1e:	81 c6 00 10 00 00    	add    $0x1000,%esi
80107f24:	89 70 0c             	mov    %esi,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80107f27:	e8 e4 c2 ff ff       	call   80104210 <mycpu>
80107f2c:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80107f30:	b8 28 00 00 00       	mov    $0x28,%eax
80107f35:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
80107f38:	8b 43 04             	mov    0x4(%ebx),%eax
80107f3b:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107f40:	0f 22 d8             	mov    %eax,%cr3
}
80107f43:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107f46:	5b                   	pop    %ebx
80107f47:	5e                   	pop    %esi
80107f48:	5f                   	pop    %edi
80107f49:	5d                   	pop    %ebp
  popcli();
80107f4a:	e9 21 d7 ff ff       	jmp    80105670 <popcli>
    panic("switchuvm: no process");
80107f4f:	83 ec 0c             	sub    $0xc,%esp
80107f52:	68 9e 99 10 80       	push   $0x8010999e
80107f57:	e8 34 84 ff ff       	call   80100390 <panic>
    panic("switchuvm: no pgdir");
80107f5c:	83 ec 0c             	sub    $0xc,%esp
80107f5f:	68 c9 99 10 80       	push   $0x801099c9
80107f64:	e8 27 84 ff ff       	call   80100390 <panic>
    panic("switchuvm: no kstack");
80107f69:	83 ec 0c             	sub    $0xc,%esp
80107f6c:	68 b4 99 10 80       	push   $0x801099b4
80107f71:	e8 1a 84 ff ff       	call   80100390 <panic>
80107f76:	8d 76 00             	lea    0x0(%esi),%esi
80107f79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107f80 <switchuvm1>:
{
80107f80:	55                   	push   %ebp
80107f81:	89 e5                	mov    %esp,%ebp
80107f83:	57                   	push   %edi
80107f84:	56                   	push   %esi
80107f85:	53                   	push   %ebx
80107f86:	83 ec 1c             	sub    $0x1c,%esp
80107f89:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
80107f8c:	85 f6                	test   %esi,%esi
80107f8e:	0f 84 c0 00 00 00    	je     80108054 <switchuvm1+0xd4>
  if(p->kstack == 0)
80107f94:	8b 46 08             	mov    0x8(%esi),%eax
80107f97:	85 c0                	test   %eax,%eax
80107f99:	0f 84 cf 00 00 00    	je     8010806e <switchuvm1+0xee>
  if(p->pgdir == 0)
80107f9f:	8b 7e 04             	mov    0x4(%esi),%edi
80107fa2:	85 ff                	test   %edi,%edi
80107fa4:	0f 84 b7 00 00 00    	je     80108061 <switchuvm1+0xe1>
  pushcli();
80107faa:	e8 81 d6 ff ff       	call   80105630 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80107faf:	e8 5c c2 ff ff       	call   80104210 <mycpu>
80107fb4:	89 c3                	mov    %eax,%ebx
80107fb6:	e8 55 c2 ff ff       	call   80104210 <mycpu>
80107fbb:	89 c7                	mov    %eax,%edi
80107fbd:	e8 4e c2 ff ff       	call   80104210 <mycpu>
80107fc2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107fc5:	83 c7 08             	add    $0x8,%edi
80107fc8:	e8 43 c2 ff ff       	call   80104210 <mycpu>
80107fcd:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80107fd0:	83 c0 08             	add    $0x8,%eax
80107fd3:	ba 67 00 00 00       	mov    $0x67,%edx
80107fd8:	c1 e8 18             	shr    $0x18,%eax
80107fdb:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
80107fe2:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
80107fe9:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
80107fef:	83 c1 08             	add    $0x8,%ecx
80107ff2:	c1 e9 10             	shr    $0x10,%ecx
80107ff5:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
80107ffb:	b9 99 40 00 00       	mov    $0x4099,%ecx
80108000:	66 89 8b 9d 00 00 00 	mov    %cx,0x9d(%ebx)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80108007:	bb 10 00 00 00       	mov    $0x10,%ebx
  mycpu()->gdt[SEG_TSS].s = 0;
8010800c:	e8 ff c1 ff ff       	call   80104210 <mycpu>
80108011:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80108018:	e8 f3 c1 ff ff       	call   80104210 <mycpu>
8010801d:	66 89 58 10          	mov    %bx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80108021:	8b 5e 08             	mov    0x8(%esi),%ebx
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80108024:	be ff ff ff ff       	mov    $0xffffffff,%esi
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80108029:	e8 e2 c1 ff ff       	call   80104210 <mycpu>
8010802e:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80108034:	89 58 0c             	mov    %ebx,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80108037:	e8 d4 c1 ff ff       	call   80104210 <mycpu>
8010803c:	66 89 70 6e          	mov    %si,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80108040:	b8 28 00 00 00       	mov    $0x28,%eax
80108045:	0f 00 d8             	ltr    %ax
}
80108048:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010804b:	5b                   	pop    %ebx
8010804c:	5e                   	pop    %esi
8010804d:	5f                   	pop    %edi
8010804e:	5d                   	pop    %ebp
  popcli();
8010804f:	e9 1c d6 ff ff       	jmp    80105670 <popcli>
    panic("switchuvm: no process");
80108054:	83 ec 0c             	sub    $0xc,%esp
80108057:	68 9e 99 10 80       	push   $0x8010999e
8010805c:	e8 2f 83 ff ff       	call   80100390 <panic>
    panic("switchuvm: no pgdir");
80108061:	83 ec 0c             	sub    $0xc,%esp
80108064:	68 c9 99 10 80       	push   $0x801099c9
80108069:	e8 22 83 ff ff       	call   80100390 <panic>
    panic("switchuvm: no kstack");
8010806e:	83 ec 0c             	sub    $0xc,%esp
80108071:	68 b4 99 10 80       	push   $0x801099b4
80108076:	e8 15 83 ff ff       	call   80100390 <panic>
8010807b:	90                   	nop
8010807c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80108080 <inituvm>:
{
80108080:	55                   	push   %ebp
80108081:	89 e5                	mov    %esp,%ebp
80108083:	57                   	push   %edi
80108084:	56                   	push   %esi
80108085:	53                   	push   %ebx
80108086:	83 ec 1c             	sub    $0x1c,%esp
80108089:	8b 75 10             	mov    0x10(%ebp),%esi
8010808c:	8b 45 08             	mov    0x8(%ebp),%eax
8010808f:	8b 7d 0c             	mov    0xc(%ebp),%edi
  if(sz >= PGSIZE)
80108092:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
{
80108098:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
8010809b:	77 49                	ja     801080e6 <inituvm+0x66>
  mem = kalloc();
8010809d:	e8 4e aa ff ff       	call   80102af0 <kalloc>
  memset(mem, 0, PGSIZE);
801080a2:	83 ec 04             	sub    $0x4,%esp
  mem = kalloc();
801080a5:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
801080a7:	68 00 10 00 00       	push   $0x1000
801080ac:	6a 00                	push   $0x0
801080ae:	50                   	push   %eax
801080af:	e8 5c d7 ff ff       	call   80105810 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
801080b4:	58                   	pop    %eax
801080b5:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801080bb:	b9 00 10 00 00       	mov    $0x1000,%ecx
801080c0:	5a                   	pop    %edx
801080c1:	6a 06                	push   $0x6
801080c3:	50                   	push   %eax
801080c4:	31 d2                	xor    %edx,%edx
801080c6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801080c9:	e8 c2 fb ff ff       	call   80107c90 <mappages>
  memmove(mem, init, sz);
801080ce:	89 75 10             	mov    %esi,0x10(%ebp)
801080d1:	89 7d 0c             	mov    %edi,0xc(%ebp)
801080d4:	83 c4 10             	add    $0x10,%esp
801080d7:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801080da:	8d 65 f4             	lea    -0xc(%ebp),%esp
801080dd:	5b                   	pop    %ebx
801080de:	5e                   	pop    %esi
801080df:	5f                   	pop    %edi
801080e0:	5d                   	pop    %ebp
  memmove(mem, init, sz);
801080e1:	e9 da d7 ff ff       	jmp    801058c0 <memmove>
    panic("inituvm: more than a page");
801080e6:	83 ec 0c             	sub    $0xc,%esp
801080e9:	68 dd 99 10 80       	push   $0x801099dd
801080ee:	e8 9d 82 ff ff       	call   80100390 <panic>
801080f3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801080f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80108100 <loaduvm>:
{
80108100:	55                   	push   %ebp
80108101:	89 e5                	mov    %esp,%ebp
80108103:	57                   	push   %edi
80108104:	56                   	push   %esi
80108105:	53                   	push   %ebx
80108106:	83 ec 0c             	sub    $0xc,%esp
  if((uint) addr % PGSIZE != 0)
80108109:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
80108110:	0f 85 91 00 00 00    	jne    801081a7 <loaduvm+0xa7>
  for(i = 0; i < sz; i += PGSIZE){
80108116:	8b 75 18             	mov    0x18(%ebp),%esi
80108119:	31 db                	xor    %ebx,%ebx
8010811b:	85 f6                	test   %esi,%esi
8010811d:	75 1a                	jne    80108139 <loaduvm+0x39>
8010811f:	eb 6f                	jmp    80108190 <loaduvm+0x90>
80108121:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80108128:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010812e:	81 ee 00 10 00 00    	sub    $0x1000,%esi
80108134:	39 5d 18             	cmp    %ebx,0x18(%ebp)
80108137:	76 57                	jbe    80108190 <loaduvm+0x90>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80108139:	8b 55 0c             	mov    0xc(%ebp),%edx
8010813c:	8b 45 08             	mov    0x8(%ebp),%eax
8010813f:	31 c9                	xor    %ecx,%ecx
80108141:	01 da                	add    %ebx,%edx
80108143:	e8 c8 fa ff ff       	call   80107c10 <walkpgdir>
80108148:	85 c0                	test   %eax,%eax
8010814a:	74 4e                	je     8010819a <loaduvm+0x9a>
    pa = PTE_ADDR(*pte);
8010814c:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
8010814e:	8b 4d 14             	mov    0x14(%ebp),%ecx
    if(sz - i < PGSIZE)
80108151:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
80108156:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
8010815b:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80108161:	0f 46 fe             	cmovbe %esi,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80108164:	01 d9                	add    %ebx,%ecx
80108166:	05 00 00 00 80       	add    $0x80000000,%eax
8010816b:	57                   	push   %edi
8010816c:	51                   	push   %ecx
8010816d:	50                   	push   %eax
8010816e:	ff 75 10             	pushl  0x10(%ebp)
80108171:	e8 1a 9e ff ff       	call   80101f90 <readi>
80108176:	83 c4 10             	add    $0x10,%esp
80108179:	39 f8                	cmp    %edi,%eax
8010817b:	74 ab                	je     80108128 <loaduvm+0x28>
}
8010817d:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80108180:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80108185:	5b                   	pop    %ebx
80108186:	5e                   	pop    %esi
80108187:	5f                   	pop    %edi
80108188:	5d                   	pop    %ebp
80108189:	c3                   	ret    
8010818a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80108190:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80108193:	31 c0                	xor    %eax,%eax
}
80108195:	5b                   	pop    %ebx
80108196:	5e                   	pop    %esi
80108197:	5f                   	pop    %edi
80108198:	5d                   	pop    %ebp
80108199:	c3                   	ret    
      panic("loaduvm: address should exist");
8010819a:	83 ec 0c             	sub    $0xc,%esp
8010819d:	68 f7 99 10 80       	push   $0x801099f7
801081a2:	e8 e9 81 ff ff       	call   80100390 <panic>
    panic("loaduvm: addr must be page aligned");
801081a7:	83 ec 0c             	sub    $0xc,%esp
801081aa:	68 98 9a 10 80       	push   $0x80109a98
801081af:	e8 dc 81 ff ff       	call   80100390 <panic>
801081b4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801081ba:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801081c0 <allocuvm>:
{
801081c0:	55                   	push   %ebp
801081c1:	89 e5                	mov    %esp,%ebp
801081c3:	57                   	push   %edi
801081c4:	56                   	push   %esi
801081c5:	53                   	push   %ebx
801081c6:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
801081c9:	8b 7d 10             	mov    0x10(%ebp),%edi
801081cc:	85 ff                	test   %edi,%edi
801081ce:	0f 88 8e 00 00 00    	js     80108262 <allocuvm+0xa2>
  if(newsz < oldsz)
801081d4:	3b 7d 0c             	cmp    0xc(%ebp),%edi
801081d7:	0f 82 93 00 00 00    	jb     80108270 <allocuvm+0xb0>
  a = PGROUNDUP(oldsz);
801081dd:	8b 45 0c             	mov    0xc(%ebp),%eax
801081e0:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801081e6:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a < newsz; a += PGSIZE){
801081ec:	39 5d 10             	cmp    %ebx,0x10(%ebp)
801081ef:	0f 86 7e 00 00 00    	jbe    80108273 <allocuvm+0xb3>
801081f5:	89 7d e4             	mov    %edi,-0x1c(%ebp)
801081f8:	8b 7d 08             	mov    0x8(%ebp),%edi
801081fb:	eb 42                	jmp    8010823f <allocuvm+0x7f>
801081fd:	8d 76 00             	lea    0x0(%esi),%esi
    memset(mem, 0, PGSIZE);
80108200:	83 ec 04             	sub    $0x4,%esp
80108203:	68 00 10 00 00       	push   $0x1000
80108208:	6a 00                	push   $0x0
8010820a:	50                   	push   %eax
8010820b:	e8 00 d6 ff ff       	call   80105810 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80108210:	58                   	pop    %eax
80108211:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80108217:	b9 00 10 00 00       	mov    $0x1000,%ecx
8010821c:	5a                   	pop    %edx
8010821d:	6a 06                	push   $0x6
8010821f:	50                   	push   %eax
80108220:	89 da                	mov    %ebx,%edx
80108222:	89 f8                	mov    %edi,%eax
80108224:	e8 67 fa ff ff       	call   80107c90 <mappages>
80108229:	83 c4 10             	add    $0x10,%esp
8010822c:	85 c0                	test   %eax,%eax
8010822e:	78 50                	js     80108280 <allocuvm+0xc0>
  for(; a < newsz; a += PGSIZE){
80108230:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80108236:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80108239:	0f 86 81 00 00 00    	jbe    801082c0 <allocuvm+0x100>
    mem = kalloc();
8010823f:	e8 ac a8 ff ff       	call   80102af0 <kalloc>
    if(mem == 0){
80108244:	85 c0                	test   %eax,%eax
    mem = kalloc();
80108246:	89 c6                	mov    %eax,%esi
    if(mem == 0){
80108248:	75 b6                	jne    80108200 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
8010824a:	83 ec 0c             	sub    $0xc,%esp
8010824d:	68 15 9a 10 80       	push   $0x80109a15
80108252:	e8 09 84 ff ff       	call   80100660 <cprintf>
  if(newsz >= oldsz)
80108257:	83 c4 10             	add    $0x10,%esp
8010825a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010825d:	39 45 10             	cmp    %eax,0x10(%ebp)
80108260:	77 6e                	ja     801082d0 <allocuvm+0x110>
}
80108262:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80108265:	31 ff                	xor    %edi,%edi
}
80108267:	89 f8                	mov    %edi,%eax
80108269:	5b                   	pop    %ebx
8010826a:	5e                   	pop    %esi
8010826b:	5f                   	pop    %edi
8010826c:	5d                   	pop    %ebp
8010826d:	c3                   	ret    
8010826e:	66 90                	xchg   %ax,%ax
    return oldsz;
80108270:	8b 7d 0c             	mov    0xc(%ebp),%edi
}
80108273:	8d 65 f4             	lea    -0xc(%ebp),%esp
80108276:	89 f8                	mov    %edi,%eax
80108278:	5b                   	pop    %ebx
80108279:	5e                   	pop    %esi
8010827a:	5f                   	pop    %edi
8010827b:	5d                   	pop    %ebp
8010827c:	c3                   	ret    
8010827d:	8d 76 00             	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
80108280:	83 ec 0c             	sub    $0xc,%esp
80108283:	68 2d 9a 10 80       	push   $0x80109a2d
80108288:	e8 d3 83 ff ff       	call   80100660 <cprintf>
  if(newsz >= oldsz)
8010828d:	83 c4 10             	add    $0x10,%esp
80108290:	8b 45 0c             	mov    0xc(%ebp),%eax
80108293:	39 45 10             	cmp    %eax,0x10(%ebp)
80108296:	76 0d                	jbe    801082a5 <allocuvm+0xe5>
80108298:	89 c1                	mov    %eax,%ecx
8010829a:	8b 55 10             	mov    0x10(%ebp),%edx
8010829d:	8b 45 08             	mov    0x8(%ebp),%eax
801082a0:	e8 7b fa ff ff       	call   80107d20 <deallocuvm.part.0>
      kfree(mem);
801082a5:	83 ec 0c             	sub    $0xc,%esp
      return 0;
801082a8:	31 ff                	xor    %edi,%edi
      kfree(mem);
801082aa:	56                   	push   %esi
801082ab:	e8 90 a6 ff ff       	call   80102940 <kfree>
      return 0;
801082b0:	83 c4 10             	add    $0x10,%esp
}
801082b3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801082b6:	89 f8                	mov    %edi,%eax
801082b8:	5b                   	pop    %ebx
801082b9:	5e                   	pop    %esi
801082ba:	5f                   	pop    %edi
801082bb:	5d                   	pop    %ebp
801082bc:	c3                   	ret    
801082bd:	8d 76 00             	lea    0x0(%esi),%esi
801082c0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
801082c3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801082c6:	5b                   	pop    %ebx
801082c7:	89 f8                	mov    %edi,%eax
801082c9:	5e                   	pop    %esi
801082ca:	5f                   	pop    %edi
801082cb:	5d                   	pop    %ebp
801082cc:	c3                   	ret    
801082cd:	8d 76 00             	lea    0x0(%esi),%esi
801082d0:	89 c1                	mov    %eax,%ecx
801082d2:	8b 55 10             	mov    0x10(%ebp),%edx
801082d5:	8b 45 08             	mov    0x8(%ebp),%eax
      return 0;
801082d8:	31 ff                	xor    %edi,%edi
801082da:	e8 41 fa ff ff       	call   80107d20 <deallocuvm.part.0>
801082df:	eb 92                	jmp    80108273 <allocuvm+0xb3>
801082e1:	eb 0d                	jmp    801082f0 <deallocuvm>
801082e3:	90                   	nop
801082e4:	90                   	nop
801082e5:	90                   	nop
801082e6:	90                   	nop
801082e7:	90                   	nop
801082e8:	90                   	nop
801082e9:	90                   	nop
801082ea:	90                   	nop
801082eb:	90                   	nop
801082ec:	90                   	nop
801082ed:	90                   	nop
801082ee:	90                   	nop
801082ef:	90                   	nop

801082f0 <deallocuvm>:
{
801082f0:	55                   	push   %ebp
801082f1:	89 e5                	mov    %esp,%ebp
801082f3:	8b 55 0c             	mov    0xc(%ebp),%edx
801082f6:	8b 4d 10             	mov    0x10(%ebp),%ecx
801082f9:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
801082fc:	39 d1                	cmp    %edx,%ecx
801082fe:	73 10                	jae    80108310 <deallocuvm+0x20>
}
80108300:	5d                   	pop    %ebp
80108301:	e9 1a fa ff ff       	jmp    80107d20 <deallocuvm.part.0>
80108306:	8d 76 00             	lea    0x0(%esi),%esi
80108309:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80108310:	89 d0                	mov    %edx,%eax
80108312:	5d                   	pop    %ebp
80108313:	c3                   	ret    
80108314:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010831a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80108320 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80108320:	55                   	push   %ebp
80108321:	89 e5                	mov    %esp,%ebp
80108323:	57                   	push   %edi
80108324:	56                   	push   %esi
80108325:	53                   	push   %ebx
80108326:	83 ec 0c             	sub    $0xc,%esp
80108329:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
8010832c:	85 f6                	test   %esi,%esi
8010832e:	74 59                	je     80108389 <freevm+0x69>
80108330:	31 c9                	xor    %ecx,%ecx
80108332:	ba 00 00 00 80       	mov    $0x80000000,%edx
80108337:	89 f0                	mov    %esi,%eax
80108339:	e8 e2 f9 ff ff       	call   80107d20 <deallocuvm.part.0>
8010833e:	89 f3                	mov    %esi,%ebx
80108340:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80108346:	eb 0f                	jmp    80108357 <freevm+0x37>
80108348:	90                   	nop
80108349:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80108350:	83 c3 04             	add    $0x4,%ebx
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80108353:	39 fb                	cmp    %edi,%ebx
80108355:	74 23                	je     8010837a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80108357:	8b 03                	mov    (%ebx),%eax
80108359:	a8 01                	test   $0x1,%al
8010835b:	74 f3                	je     80108350 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
8010835d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
80108362:	83 ec 0c             	sub    $0xc,%esp
80108365:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80108368:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
8010836d:	50                   	push   %eax
8010836e:	e8 cd a5 ff ff       	call   80102940 <kfree>
80108373:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80108376:	39 fb                	cmp    %edi,%ebx
80108378:	75 dd                	jne    80108357 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
8010837a:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010837d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80108380:	5b                   	pop    %ebx
80108381:	5e                   	pop    %esi
80108382:	5f                   	pop    %edi
80108383:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80108384:	e9 b7 a5 ff ff       	jmp    80102940 <kfree>
    panic("freevm: no pgdir");
80108389:	83 ec 0c             	sub    $0xc,%esp
8010838c:	68 49 9a 10 80       	push   $0x80109a49
80108391:	e8 fa 7f ff ff       	call   80100390 <panic>
80108396:	8d 76 00             	lea    0x0(%esi),%esi
80108399:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801083a0 <setupkvm>:
{
801083a0:	55                   	push   %ebp
801083a1:	89 e5                	mov    %esp,%ebp
801083a3:	56                   	push   %esi
801083a4:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
801083a5:	e8 46 a7 ff ff       	call   80102af0 <kalloc>
801083aa:	85 c0                	test   %eax,%eax
801083ac:	89 c6                	mov    %eax,%esi
801083ae:	74 42                	je     801083f2 <setupkvm+0x52>
  memset(pgdir, 0, PGSIZE);
801083b0:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801083b3:	bb 20 c4 10 80       	mov    $0x8010c420,%ebx
  memset(pgdir, 0, PGSIZE);
801083b8:	68 00 10 00 00       	push   $0x1000
801083bd:	6a 00                	push   $0x0
801083bf:	50                   	push   %eax
801083c0:	e8 4b d4 ff ff       	call   80105810 <memset>
801083c5:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
801083c8:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
801083cb:	8b 4b 08             	mov    0x8(%ebx),%ecx
801083ce:	83 ec 08             	sub    $0x8,%esp
801083d1:	8b 13                	mov    (%ebx),%edx
801083d3:	ff 73 0c             	pushl  0xc(%ebx)
801083d6:	50                   	push   %eax
801083d7:	29 c1                	sub    %eax,%ecx
801083d9:	89 f0                	mov    %esi,%eax
801083db:	e8 b0 f8 ff ff       	call   80107c90 <mappages>
801083e0:	83 c4 10             	add    $0x10,%esp
801083e3:	85 c0                	test   %eax,%eax
801083e5:	78 19                	js     80108400 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801083e7:	83 c3 10             	add    $0x10,%ebx
801083ea:	81 fb 60 c4 10 80    	cmp    $0x8010c460,%ebx
801083f0:	75 d6                	jne    801083c8 <setupkvm+0x28>
}
801083f2:	8d 65 f8             	lea    -0x8(%ebp),%esp
801083f5:	89 f0                	mov    %esi,%eax
801083f7:	5b                   	pop    %ebx
801083f8:	5e                   	pop    %esi
801083f9:	5d                   	pop    %ebp
801083fa:	c3                   	ret    
801083fb:	90                   	nop
801083fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      freevm(pgdir);
80108400:	83 ec 0c             	sub    $0xc,%esp
80108403:	56                   	push   %esi
      return 0;
80108404:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
80108406:	e8 15 ff ff ff       	call   80108320 <freevm>
      return 0;
8010840b:	83 c4 10             	add    $0x10,%esp
}
8010840e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80108411:	89 f0                	mov    %esi,%eax
80108413:	5b                   	pop    %ebx
80108414:	5e                   	pop    %esi
80108415:	5d                   	pop    %ebp
80108416:	c3                   	ret    
80108417:	89 f6                	mov    %esi,%esi
80108419:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80108420 <kvmalloc>:
{
80108420:	55                   	push   %ebp
80108421:	89 e5                	mov    %esp,%ebp
80108423:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80108426:	e8 75 ff ff ff       	call   801083a0 <setupkvm>
8010842b:	a3 c4 cf 11 80       	mov    %eax,0x8011cfc4
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80108430:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80108435:	0f 22 d8             	mov    %eax,%cr3
}
80108438:	c9                   	leave  
80108439:	c3                   	ret    
8010843a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80108440 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80108440:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80108441:	31 c9                	xor    %ecx,%ecx
{
80108443:	89 e5                	mov    %esp,%ebp
80108445:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
80108448:	8b 55 0c             	mov    0xc(%ebp),%edx
8010844b:	8b 45 08             	mov    0x8(%ebp),%eax
8010844e:	e8 bd f7 ff ff       	call   80107c10 <walkpgdir>
  if(pte == 0)
80108453:	85 c0                	test   %eax,%eax
80108455:	74 05                	je     8010845c <clearpteu+0x1c>
    panic("clearpteu");
  *pte &= ~PTE_U;
80108457:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
8010845a:	c9                   	leave  
8010845b:	c3                   	ret    
    panic("clearpteu");
8010845c:	83 ec 0c             	sub    $0xc,%esp
8010845f:	68 5a 9a 10 80       	push   $0x80109a5a
80108464:	e8 27 7f ff ff       	call   80100390 <panic>
80108469:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80108470 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80108470:	55                   	push   %ebp
80108471:	89 e5                	mov    %esp,%ebp
80108473:	57                   	push   %edi
80108474:	56                   	push   %esi
80108475:	53                   	push   %ebx
80108476:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80108479:	e8 22 ff ff ff       	call   801083a0 <setupkvm>
8010847e:	85 c0                	test   %eax,%eax
80108480:	89 45 e0             	mov    %eax,-0x20(%ebp)
80108483:	0f 84 9f 00 00 00    	je     80108528 <copyuvm+0xb8>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80108489:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010848c:	85 c9                	test   %ecx,%ecx
8010848e:	0f 84 94 00 00 00    	je     80108528 <copyuvm+0xb8>
80108494:	31 ff                	xor    %edi,%edi
80108496:	eb 4a                	jmp    801084e2 <copyuvm+0x72>
80108498:	90                   	nop
80108499:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
801084a0:	83 ec 04             	sub    $0x4,%esp
801084a3:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
801084a9:	68 00 10 00 00       	push   $0x1000
801084ae:	53                   	push   %ebx
801084af:	50                   	push   %eax
801084b0:	e8 0b d4 ff ff       	call   801058c0 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
801084b5:	58                   	pop    %eax
801084b6:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
801084bc:	b9 00 10 00 00       	mov    $0x1000,%ecx
801084c1:	5a                   	pop    %edx
801084c2:	ff 75 e4             	pushl  -0x1c(%ebp)
801084c5:	50                   	push   %eax
801084c6:	89 fa                	mov    %edi,%edx
801084c8:	8b 45 e0             	mov    -0x20(%ebp),%eax
801084cb:	e8 c0 f7 ff ff       	call   80107c90 <mappages>
801084d0:	83 c4 10             	add    $0x10,%esp
801084d3:	85 c0                	test   %eax,%eax
801084d5:	78 61                	js     80108538 <copyuvm+0xc8>
  for(i = 0; i < sz; i += PGSIZE){
801084d7:	81 c7 00 10 00 00    	add    $0x1000,%edi
801084dd:	39 7d 0c             	cmp    %edi,0xc(%ebp)
801084e0:	76 46                	jbe    80108528 <copyuvm+0xb8>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
801084e2:	8b 45 08             	mov    0x8(%ebp),%eax
801084e5:	31 c9                	xor    %ecx,%ecx
801084e7:	89 fa                	mov    %edi,%edx
801084e9:	e8 22 f7 ff ff       	call   80107c10 <walkpgdir>
801084ee:	85 c0                	test   %eax,%eax
801084f0:	74 61                	je     80108553 <copyuvm+0xe3>
    if(!(*pte & PTE_P))
801084f2:	8b 00                	mov    (%eax),%eax
801084f4:	a8 01                	test   $0x1,%al
801084f6:	74 4e                	je     80108546 <copyuvm+0xd6>
    pa = PTE_ADDR(*pte);
801084f8:	89 c3                	mov    %eax,%ebx
    flags = PTE_FLAGS(*pte);
801084fa:	25 ff 0f 00 00       	and    $0xfff,%eax
    pa = PTE_ADDR(*pte);
801084ff:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
    flags = PTE_FLAGS(*pte);
80108505:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if((mem = kalloc()) == 0)
80108508:	e8 e3 a5 ff ff       	call   80102af0 <kalloc>
8010850d:	85 c0                	test   %eax,%eax
8010850f:	89 c6                	mov    %eax,%esi
80108511:	75 8d                	jne    801084a0 <copyuvm+0x30>
    }
  }
  return d;

bad:
  freevm(d);
80108513:	83 ec 0c             	sub    $0xc,%esp
80108516:	ff 75 e0             	pushl  -0x20(%ebp)
80108519:	e8 02 fe ff ff       	call   80108320 <freevm>
  return 0;
8010851e:	83 c4 10             	add    $0x10,%esp
80108521:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
}
80108528:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010852b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010852e:	5b                   	pop    %ebx
8010852f:	5e                   	pop    %esi
80108530:	5f                   	pop    %edi
80108531:	5d                   	pop    %ebp
80108532:	c3                   	ret    
80108533:	90                   	nop
80108534:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      kfree(mem);
80108538:	83 ec 0c             	sub    $0xc,%esp
8010853b:	56                   	push   %esi
8010853c:	e8 ff a3 ff ff       	call   80102940 <kfree>
      goto bad;
80108541:	83 c4 10             	add    $0x10,%esp
80108544:	eb cd                	jmp    80108513 <copyuvm+0xa3>
      panic("copyuvm: page not present");
80108546:	83 ec 0c             	sub    $0xc,%esp
80108549:	68 7e 9a 10 80       	push   $0x80109a7e
8010854e:	e8 3d 7e ff ff       	call   80100390 <panic>
      panic("copyuvm: pte should exist");
80108553:	83 ec 0c             	sub    $0xc,%esp
80108556:	68 64 9a 10 80       	push   $0x80109a64
8010855b:	e8 30 7e ff ff       	call   80100390 <panic>

80108560 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80108560:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80108561:	31 c9                	xor    %ecx,%ecx
{
80108563:	89 e5                	mov    %esp,%ebp
80108565:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
80108568:	8b 55 0c             	mov    0xc(%ebp),%edx
8010856b:	8b 45 08             	mov    0x8(%ebp),%eax
8010856e:	e8 9d f6 ff ff       	call   80107c10 <walkpgdir>
  if((*pte & PTE_P) == 0)
80108573:	8b 00                	mov    (%eax),%eax
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
80108575:	c9                   	leave  
  if((*pte & PTE_U) == 0)
80108576:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80108578:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
8010857d:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80108580:	05 00 00 00 80       	add    $0x80000000,%eax
80108585:	83 fa 05             	cmp    $0x5,%edx
80108588:	ba 00 00 00 00       	mov    $0x0,%edx
8010858d:	0f 45 c2             	cmovne %edx,%eax
}
80108590:	c3                   	ret    
80108591:	eb 0d                	jmp    801085a0 <copyout>
80108593:	90                   	nop
80108594:	90                   	nop
80108595:	90                   	nop
80108596:	90                   	nop
80108597:	90                   	nop
80108598:	90                   	nop
80108599:	90                   	nop
8010859a:	90                   	nop
8010859b:	90                   	nop
8010859c:	90                   	nop
8010859d:	90                   	nop
8010859e:	90                   	nop
8010859f:	90                   	nop

801085a0 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
801085a0:	55                   	push   %ebp
801085a1:	89 e5                	mov    %esp,%ebp
801085a3:	57                   	push   %edi
801085a4:	56                   	push   %esi
801085a5:	53                   	push   %ebx
801085a6:	83 ec 1c             	sub    $0x1c,%esp
801085a9:	8b 5d 14             	mov    0x14(%ebp),%ebx
801085ac:	8b 55 0c             	mov    0xc(%ebp),%edx
801085af:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
801085b2:	85 db                	test   %ebx,%ebx
801085b4:	75 40                	jne    801085f6 <copyout+0x56>
801085b6:	eb 70                	jmp    80108628 <copyout+0x88>
801085b8:	90                   	nop
801085b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
801085c0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801085c3:	89 f1                	mov    %esi,%ecx
801085c5:	29 d1                	sub    %edx,%ecx
801085c7:	81 c1 00 10 00 00    	add    $0x1000,%ecx
801085cd:	39 d9                	cmp    %ebx,%ecx
801085cf:	0f 47 cb             	cmova  %ebx,%ecx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
801085d2:	29 f2                	sub    %esi,%edx
801085d4:	83 ec 04             	sub    $0x4,%esp
801085d7:	01 d0                	add    %edx,%eax
801085d9:	51                   	push   %ecx
801085da:	57                   	push   %edi
801085db:	50                   	push   %eax
801085dc:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
801085df:	e8 dc d2 ff ff       	call   801058c0 <memmove>
    len -= n;
    buf += n;
801085e4:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  while(len > 0){
801085e7:	83 c4 10             	add    $0x10,%esp
    va = va0 + PGSIZE;
801085ea:	8d 96 00 10 00 00    	lea    0x1000(%esi),%edx
    buf += n;
801085f0:	01 cf                	add    %ecx,%edi
  while(len > 0){
801085f2:	29 cb                	sub    %ecx,%ebx
801085f4:	74 32                	je     80108628 <copyout+0x88>
    va0 = (uint)PGROUNDDOWN(va);
801085f6:	89 d6                	mov    %edx,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
801085f8:	83 ec 08             	sub    $0x8,%esp
    va0 = (uint)PGROUNDDOWN(va);
801085fb:	89 55 e4             	mov    %edx,-0x1c(%ebp)
801085fe:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80108604:	56                   	push   %esi
80108605:	ff 75 08             	pushl  0x8(%ebp)
80108608:	e8 53 ff ff ff       	call   80108560 <uva2ka>
    if(pa0 == 0)
8010860d:	83 c4 10             	add    $0x10,%esp
80108610:	85 c0                	test   %eax,%eax
80108612:	75 ac                	jne    801085c0 <copyout+0x20>
  }
  return 0;
}
80108614:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80108617:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010861c:	5b                   	pop    %ebx
8010861d:	5e                   	pop    %esi
8010861e:	5f                   	pop    %edi
8010861f:	5d                   	pop    %ebp
80108620:	c3                   	ret    
80108621:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80108628:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010862b:	31 c0                	xor    %eax,%eax
}
8010862d:	5b                   	pop    %ebx
8010862e:	5e                   	pop    %esi
8010862f:	5f                   	pop    %edi
80108630:	5d                   	pop    %ebp
80108631:	c3                   	ret    
80108632:	66 90                	xchg   %ax,%ax
80108634:	66 90                	xchg   %ax,%ax
80108636:	66 90                	xchg   %ax,%ax
80108638:	66 90                	xchg   %ax,%ax
8010863a:	66 90                	xchg   %ax,%ax
8010863c:	66 90                	xchg   %ax,%ax
8010863e:	66 90                	xchg   %ax,%ax

80108640 <printk_str>:
#include "types.h"
#include "defs.h"

int
printk_str(char * str)
{
80108640:	55                   	push   %ebp
80108641:	89 e5                	mov    %esp,%ebp
80108643:	83 ec 10             	sub    $0x10,%esp
	cprintf("%sn", str);
80108646:	ff 75 08             	pushl  0x8(%ebp)
80108649:	68 bc 9a 10 80       	push   $0x80109abc
8010864e:	e8 0d 80 ff ff       	call   80100660 <cprintf>
	return 0xABCDABCD;
}
80108653:	b8 cd ab cd ab       	mov    $0xabcdabcd,%eax
80108658:	c9                   	leave  
80108659:	c3                   	ret    
8010865a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80108660 <sys_myfunction>:

int
sys_myfunction(void)
{
80108660:	55                   	push   %ebp
80108661:	89 e5                	mov    %esp,%ebp
80108663:	83 ec 20             	sub    $0x20,%esp
	char * str;

	if(argstr(0, &str) < 0)
80108666:	8d 45 f4             	lea    -0xc(%ebp),%eax
80108669:	50                   	push   %eax
8010866a:	6a 00                	push   $0x0
8010866c:	e8 4f d5 ff ff       	call   80105bc0 <argstr>
80108671:	83 c4 10             	add    $0x10,%esp
80108674:	85 c0                	test   %eax,%eax
80108676:	ba ff ff ff ff       	mov    $0xffffffff,%edx
8010867b:	78 18                	js     80108695 <sys_myfunction+0x35>
	cprintf("%sn", str);
8010867d:	83 ec 08             	sub    $0x8,%esp
80108680:	ff 75 f4             	pushl  -0xc(%ebp)
80108683:	68 bc 9a 10 80       	push   $0x80109abc
80108688:	e8 d3 7f ff ff       	call   80100660 <cprintf>
	{	
		return -1;
	}
	return printk_str(str);
8010868d:	83 c4 10             	add    $0x10,%esp
80108690:	ba cd ab cd ab       	mov    $0xabcdabcd,%edx
}
80108695:	89 d0                	mov    %edx,%eax
80108697:	c9                   	leave  
80108698:	c3                   	ret    
80108699:	66 90                	xchg   %ax,%ax
8010869b:	66 90                	xchg   %ax,%ax
8010869d:	66 90                	xchg   %ax,%ax
8010869f:	90                   	nop

801086a0 <isRunnable>:

// ptable을 순회하면서
// 해당 pid에 runnable이 있는지 반환
int
isRunnable(int pid)
{
801086a0:	55                   	push   %ebp
    struct proc* p;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; ++p)
801086a1:	b8 74 5f 11 80       	mov    $0x80115f74,%eax
{
801086a6:	89 e5                	mov    %esp,%ebp
801086a8:	8b 55 08             	mov    0x8(%ebp),%edx
801086ab:	eb 0f                	jmp    801086bc <isRunnable+0x1c>
801086ad:	8d 76 00             	lea    0x0(%esi),%esi
    for(p = ptable.proc; p < &ptable.proc[NPROC]; ++p)
801086b0:	05 a0 01 00 00       	add    $0x1a0,%eax
801086b5:	3d 74 c7 11 80       	cmp    $0x8011c774,%eax
801086ba:	73 14                	jae    801086d0 <isRunnable+0x30>
    {
        if(p->pid == pid && p->state == RUNNABLE)
801086bc:	39 50 10             	cmp    %edx,0x10(%eax)
801086bf:	75 ef                	jne    801086b0 <isRunnable+0x10>
801086c1:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
801086c5:	75 e9                	jne    801086b0 <isRunnable+0x10>
        {
            return 1;
801086c7:	b8 01 00 00 00       	mov    $0x1,%eax
        }
    }
    return 0;
}
801086cc:	5d                   	pop    %ebp
801086cd:	c3                   	ret    
801086ce:	66 90                	xchg   %ax,%ax
    return 0;
801086d0:	31 c0                	xor    %eax,%eax
}
801086d2:	5d                   	pop    %ebp
801086d3:	c3                   	ret    
801086d4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801086da:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801086e0 <pick_lwp>:

// numLWP의 그룹에서 실행 할 수 있는 프로세스 반환.
struct proc*
pick_lwp(int pid)
{
801086e0:	55                   	push   %ebp
801086e1:	89 e5                	mov    %esp,%ebp
801086e3:	57                   	push   %edi
801086e4:	56                   	push   %esi
801086e5:	53                   	push   %ebx
801086e6:	83 ec 28             	sub    $0x28,%esp
    struct proc* master_thread = find_master(pid);
801086e9:	ff 75 08             	pushl  0x8(%ebp)
801086ec:	e8 bf ba ff ff       	call   801041b0 <find_master>

    int recent = master_thread->cur;
801086f1:	8b 98 98 00 00 00    	mov    0x98(%eax),%ebx
    struct proc* master_thread = find_master(pid);
801086f7:	89 45 e0             	mov    %eax,-0x20(%ebp)
    int recent = master_thread->cur;
801086fa:	83 c4 10             	add    $0x10,%esp
801086fd:	89 da                	mov    %ebx,%edx
801086ff:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80108702:	eb 09                	jmp    8010870d <pick_lwp+0x2d>
80108704:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        {
            master_thread->cur = recent;
            return &ptable.proc[recent];
        }
    }
    while(master_thread->cur != recent);
80108708:	39 4d e4             	cmp    %ecx,-0x1c(%ebp)
8010870b:	74 4b                	je     80108758 <pick_lwp+0x78>
        recent = (recent+1)%NPROC;
8010870d:	83 c2 01             	add    $0x1,%edx
80108710:	89 d0                	mov    %edx,%eax
80108712:	c1 f8 1f             	sar    $0x1f,%eax
80108715:	c1 e8 1a             	shr    $0x1a,%eax
80108718:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
8010871b:	83 e1 3f             	and    $0x3f,%ecx
8010871e:	29 c1                	sub    %eax,%ecx
        if(ptable.proc[recent].state == RUNNABLE && ptable.proc[recent].pid == pid)
80108720:	69 c1 a0 01 00 00    	imul   $0x1a0,%ecx,%eax
        recent = (recent+1)%NPROC;
80108726:	89 ca                	mov    %ecx,%edx
        if(ptable.proc[recent].state == RUNNABLE && ptable.proc[recent].pid == pid)
80108728:	8b b8 80 5f 11 80    	mov    -0x7feea080(%eax),%edi
8010872e:	83 ff 03             	cmp    $0x3,%edi
80108731:	75 d5                	jne    80108708 <pick_lwp+0x28>
80108733:	8b 5d 08             	mov    0x8(%ebp),%ebx
80108736:	39 98 84 5f 11 80    	cmp    %ebx,-0x7feea07c(%eax)
8010873c:	75 ca                	jne    80108708 <pick_lwp+0x28>
            master_thread->cur = recent;
8010873e:	8b 5d e0             	mov    -0x20(%ebp),%ebx
            return &ptable.proc[recent];
80108741:	05 74 5f 11 80       	add    $0x80115f74,%eax
            master_thread->cur = recent;
80108746:	89 8b 98 00 00 00    	mov    %ecx,0x98(%ebx)
    {
        master_thread->cur = recent;
        return &ptable.proc[recent];
    }
    return 0;
}
8010874c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010874f:	5b                   	pop    %ebx
80108750:	5e                   	pop    %esi
80108751:	5f                   	pop    %edi
80108752:	5d                   	pop    %ebp
80108753:	c3                   	ret    
80108754:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ptable.proc[recent].state == RUNNABLE)
80108758:	83 ff 03             	cmp    $0x3,%edi
8010875b:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
8010875e:	75 18                	jne    80108778 <pick_lwp+0x98>
        return &ptable.proc[recent];
80108760:	69 c3 a0 01 00 00    	imul   $0x1a0,%ebx,%eax
}
80108766:	8d 65 f4             	lea    -0xc(%ebp),%esp
80108769:	5b                   	pop    %ebx
        return &ptable.proc[recent];
8010876a:	05 74 5f 11 80       	add    $0x80115f74,%eax
}
8010876f:	5e                   	pop    %esi
80108770:	5f                   	pop    %edi
80108771:	5d                   	pop    %ebp
80108772:	c3                   	ret    
80108773:	90                   	nop
80108774:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80108778:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
8010877b:	31 c0                	xor    %eax,%eax
}
8010877d:	5b                   	pop    %ebx
8010877e:	5e                   	pop    %esi
8010877f:	5f                   	pop    %edi
80108780:	5d                   	pop    %ebp
80108781:	c3                   	ret    
80108782:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80108789:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80108790 <pick_mlfq>:

// Loop over MLFQ in priority order.
struct proc*
pick_mlfq(void)
{
80108790:	55                   	push   %ebp
80108791:	89 e5                	mov    %esp,%ebp
80108793:	57                   	push   %edi
80108794:	56                   	push   %esi
80108795:	53                   	push   %ebx
80108796:	83 ec 1c             	sub    $0x1c,%esp
80108799:	c7 45 e0 20 53 11 80 	movl   $0x80115320,-0x20(%ebp)
  // Loop over MLFQ in priority order
  for(int prior = 0; prior < 3; ++prior){
801087a0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
      if(m_table[prior].count == 0)
801087a7:	8b 45 e0             	mov    -0x20(%ebp),%eax
801087aa:	8b b0 00 04 00 00    	mov    0x400(%eax),%esi
801087b0:	85 f6                	test   %esi,%esi
801087b2:	0f 84 98 00 00 00    	je     80108850 <pick_mlfq+0xc0>
        continue;    

      int recent = m_table[prior].recent_index;
801087b8:	8b b0 04 04 00 00    	mov    0x404(%eax),%esi
      do
      {   
          recent = (recent+1)%NPROC;

          if(m_table[prior].table[recent].state == USED && isRunnable(m_table[prior].table[recent].pid))
801087be:	69 7d e4 08 04 00 00 	imul   $0x408,-0x1c(%ebp),%edi
      int recent = m_table[prior].recent_index;
801087c5:	89 f1                	mov    %esi,%ecx
801087c7:	eb 0b                	jmp    801087d4 <pick_mlfq+0x44>
801087c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
          {
              m_table[prior].recent_index = recent;
              return pick_lwp(m_table[prior].table[recent].pid);
          }
      }
      while(m_table[prior].recent_index != recent);
801087d0:	39 d6                	cmp    %edx,%esi
801087d2:	74 7c                	je     80108850 <pick_mlfq+0xc0>
          recent = (recent+1)%NPROC;
801087d4:	83 c1 01             	add    $0x1,%ecx
801087d7:	89 c8                	mov    %ecx,%eax
801087d9:	c1 f8 1f             	sar    $0x1f,%eax
801087dc:	c1 e8 1a             	shr    $0x1a,%eax
801087df:	01 c1                	add    %eax,%ecx
801087e1:	83 e1 3f             	and    $0x3f,%ecx
801087e4:	89 ca                	mov    %ecx,%edx
801087e6:	29 c2                	sub    %eax,%edx
          if(m_table[prior].table[recent].state == USED && isRunnable(m_table[prior].table[recent].pid))
801087e8:	89 d0                	mov    %edx,%eax
          recent = (recent+1)%NPROC;
801087ea:	89 d1                	mov    %edx,%ecx
          if(m_table[prior].table[recent].state == USED && isRunnable(m_table[prior].table[recent].pid))
801087ec:	c1 e0 04             	shl    $0x4,%eax
801087ef:	01 f8                	add    %edi,%eax
801087f1:	8b 98 20 53 11 80    	mov    -0x7feeace0(%eax),%ebx
801087f7:	85 db                	test   %ebx,%ebx
801087f9:	75 d5                	jne    801087d0 <pick_mlfq+0x40>
801087fb:	8b 98 28 53 11 80    	mov    -0x7feeacd8(%eax),%ebx
    for(p = ptable.proc; p < &ptable.proc[NPROC]; ++p)
80108801:	b8 74 5f 11 80       	mov    $0x80115f74,%eax
80108806:	eb 14                	jmp    8010881c <pick_mlfq+0x8c>
80108808:	90                   	nop
80108809:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80108810:	05 a0 01 00 00       	add    $0x1a0,%eax
80108815:	3d 74 c7 11 80       	cmp    $0x8011c774,%eax
8010881a:	73 b4                	jae    801087d0 <pick_mlfq+0x40>
        if(p->pid == pid && p->state == RUNNABLE)
8010881c:	3b 58 10             	cmp    0x10(%eax),%ebx
8010881f:	75 ef                	jne    80108810 <pick_mlfq+0x80>
80108821:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
80108825:	75 e9                	jne    80108810 <pick_mlfq+0x80>
              m_table[prior].recent_index = recent;
80108827:	69 45 e4 08 04 00 00 	imul   $0x408,-0x1c(%ebp),%eax
              return pick_lwp(m_table[prior].table[recent].pid);
8010882e:	83 ec 0c             	sub    $0xc,%esp
80108831:	53                   	push   %ebx
              m_table[prior].recent_index = recent;
80108832:	89 90 24 57 11 80    	mov    %edx,-0x7feea8dc(%eax)
              return pick_lwp(m_table[prior].table[recent].pid);
80108838:	e8 a3 fe ff ff       	call   801086e0 <pick_lwp>
8010883d:	83 c4 10             	add    $0x10,%esp
  }

  return 0;
}
80108840:	8d 65 f4             	lea    -0xc(%ebp),%esp
80108843:	5b                   	pop    %ebx
80108844:	5e                   	pop    %esi
80108845:	5f                   	pop    %edi
80108846:	5d                   	pop    %ebp
80108847:	c3                   	ret    
80108848:	90                   	nop
80108849:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(int prior = 0; prior < 3; ++prior){
80108850:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
80108854:	81 45 e0 08 04 00 00 	addl   $0x408,-0x20(%ebp)
8010885b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010885e:	83 f8 03             	cmp    $0x3,%eax
80108861:	0f 85 40 ff ff ff    	jne    801087a7 <pick_mlfq+0x17>
}
80108867:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010886a:	31 c0                	xor    %eax,%eax
}
8010886c:	5b                   	pop    %ebx
8010886d:	5e                   	pop    %esi
8010886e:	5f                   	pop    %edi
8010886f:	5d                   	pop    %ebp
80108870:	c3                   	ret    
80108871:	eb 0d                	jmp    80108880 <pop_mlfq>
80108873:	90                   	nop
80108874:	90                   	nop
80108875:	90                   	nop
80108876:	90                   	nop
80108877:	90                   	nop
80108878:	90                   	nop
80108879:	90                   	nop
8010887a:	90                   	nop
8010887b:	90                   	nop
8010887c:	90                   	nop
8010887d:	90                   	nop
8010887e:	90                   	nop
8010887f:	90                   	nop

80108880 <pop_mlfq>:

// Find mlfq node pointing numLWP
// And pop from queue all of lwps
int
pop_mlfq(int pid)
{
80108880:	55                   	push   %ebp
80108881:	89 e5                	mov    %esp,%ebp
80108883:	53                   	push   %ebx
80108884:	bb 20 53 11 80       	mov    $0x80115320,%ebx
80108889:	8b 55 08             	mov    0x8(%ebp),%edx
8010888c:	8d 83 00 04 00 00    	lea    0x400(%ebx),%eax
    // Deconnect the link with mlfq_node
    struct mlfq_node* m;
    for(int prior = 0; prior < 3; ++prior){
        for(m = m_table[prior].table; m < &m_table[prior].table[NPROC]; ++m){
80108892:	89 d9                	mov    %ebx,%ecx
80108894:	39 c3                	cmp    %eax,%ebx
80108896:	73 14                	jae    801088ac <pop_mlfq+0x2c>
            if(m->pid == pid)
80108898:	39 53 08             	cmp    %edx,0x8(%ebx)
8010889b:	75 08                	jne    801088a5 <pop_mlfq+0x25>
8010889d:	eb 29                	jmp    801088c8 <pop_mlfq+0x48>
8010889f:	90                   	nop
801088a0:	39 51 08             	cmp    %edx,0x8(%ecx)
801088a3:	74 23                	je     801088c8 <pop_mlfq+0x48>
        for(m = m_table[prior].table; m < &m_table[prior].table[NPROC]; ++m){
801088a5:	83 c1 10             	add    $0x10,%ecx
801088a8:	39 c1                	cmp    %eax,%ecx
801088aa:	72 f4                	jb     801088a0 <pop_mlfq+0x20>
801088ac:	81 c3 08 04 00 00    	add    $0x408,%ebx
    for(int prior = 0; prior < 3; ++prior){
801088b2:	81 fb 38 5f 11 80    	cmp    $0x80115f38,%ebx
801088b8:	75 d2                	jne    8010888c <pop_mlfq+0xc>
                return 0;
            }
        }
    }

    return -1;
801088ba:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801088bf:	5b                   	pop    %ebx
801088c0:	5d                   	pop    %ebp
801088c1:	c3                   	ret    
801088c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801088c8:	b8 84 5f 11 80       	mov    $0x80115f84,%eax
801088cd:	8d 76 00             	lea    0x0(%esi),%esi
                    if(ptable.proc[i].pid == pid)
801088d0:	39 10                	cmp    %edx,(%eax)
801088d2:	75 0e                	jne    801088e2 <pop_mlfq+0x62>
                        ptable.proc[i].schedstate = UNUSED;
801088d4:	c7 40 6c 00 00 00 00 	movl   $0x0,0x6c(%eax)
                        ptable.proc[i].pmlfq_node = 0;
801088db:	c7 40 74 00 00 00 00 	movl   $0x0,0x74(%eax)
801088e2:	05 a0 01 00 00       	add    $0x1a0,%eax
                for(int i = 0; i < NPROC; ++i)
801088e7:	3d 84 c7 11 80       	cmp    $0x8011c784,%eax
801088ec:	75 e2                	jne    801088d0 <pop_mlfq+0x50>
                m_table[m->prior].count -= 1;
801088ee:	69 41 0c 08 04 00 00 	imul   $0x408,0xc(%ecx),%eax
                m->state = EMPTY;
801088f5:	c7 01 01 00 00 00    	movl   $0x1,(%ecx)
                m->pid = 0;
801088fb:	c7 41 08 00 00 00 00 	movl   $0x0,0x8(%ecx)
                m->eticks = 0;
80108902:	c7 41 04 00 00 00 00 	movl   $0x0,0x4(%ecx)
}
80108909:	5b                   	pop    %ebx
8010890a:	5d                   	pop    %ebp
                m_table[m->prior].count -= 1;
8010890b:	83 a8 20 57 11 80 01 	subl   $0x1,-0x7feea8e0(%eax)
                return 0;
80108912:	31 c0                	xor    %eax,%eax
}
80108914:	c3                   	ret    
80108915:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80108919:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80108920 <push_mlfq>:

// Push this parameter proc to mlfq in highest priority
int
push_mlfq(int pid, int prior)
{
80108920:	55                   	push   %ebp
80108921:	89 e5                	mov    %esp,%ebp
80108923:	56                   	push   %esi
80108924:	53                   	push   %ebx
80108925:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80108928:	8b 55 08             	mov    0x8(%ebp),%edx
    if(prior < 0 || prior > 2)
8010892b:	83 fb 02             	cmp    $0x2,%ebx
8010892e:	77 7e                	ja     801089ae <push_mlfq+0x8e>
80108930:	69 c3 08 04 00 00    	imul   $0x408,%ebx,%eax
    }

    struct proc* p;
    struct mlfq_node* m;

    for(m = m_table[prior].table; m < &m_table[prior].table[NPROC]; ++m)
80108936:	8d 88 20 53 11 80    	lea    -0x7feeace0(%eax),%ecx
8010893c:	8d b0 20 57 11 80    	lea    -0x7feea8e0(%eax),%esi
80108942:	39 ce                	cmp    %ecx,%esi
80108944:	76 4d                	jbe    80108993 <push_mlfq+0x73>
    {
        if(m->state != EMPTY)
80108946:	83 b8 20 53 11 80 01 	cmpl   $0x1,-0x7feeace0(%eax)
8010894d:	75 51                	jne    801089a0 <push_mlfq+0x80>
            continue;

        for(p = ptable.proc; p < &ptable.proc[NPROC]; ++p)
8010894f:	b8 74 5f 11 80       	mov    $0x80115f74,%eax
80108954:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        {
            if(p->pid != pid)
80108958:	39 50 10             	cmp    %edx,0x10(%eax)
8010895b:	75 0d                	jne    8010896a <push_mlfq+0x4a>
                continue;

            // 프로세스 세팅
            p->schedstate = MLFQ;
8010895d:	c7 40 7c 02 00 00 00 	movl   $0x2,0x7c(%eax)
            p->pmlfq_node = m;
80108964:	89 88 84 00 00 00    	mov    %ecx,0x84(%eax)
        for(p = ptable.proc; p < &ptable.proc[NPROC]; ++p)
8010896a:	05 a0 01 00 00       	add    $0x1a0,%eax
8010896f:	3d 74 c7 11 80       	cmp    $0x8011c774,%eax
80108974:	72 e2                	jb     80108958 <push_mlfq+0x38>
        }

        m_table[prior].count += 1;
80108976:	69 db 08 04 00 00    	imul   $0x408,%ebx,%ebx
8010897c:	83 83 20 57 11 80 01 	addl   $0x1,-0x7feea8e0(%ebx)
        m->pid = pid;
80108983:	89 51 08             	mov    %edx,0x8(%ecx)
        m->state = USED;
80108986:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
        m->eticks = 0;
8010898c:	c7 41 04 00 00 00 00 	movl   $0x0,0x4(%ecx)

        break;
    }

    return 0;
80108993:	31 c0                	xor    %eax,%eax
}
80108995:	5b                   	pop    %ebx
80108996:	5e                   	pop    %esi
80108997:	5d                   	pop    %ebp
80108998:	c3                   	ret    
80108999:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    for(m = m_table[prior].table; m < &m_table[prior].table[NPROC]; ++m)
801089a0:	83 c1 10             	add    $0x10,%ecx
801089a3:	39 ce                	cmp    %ecx,%esi
801089a5:	76 ec                	jbe    80108993 <push_mlfq+0x73>
        if(m->state != EMPTY)
801089a7:	83 39 01             	cmpl   $0x1,(%ecx)
801089aa:	74 a3                	je     8010894f <push_mlfq+0x2f>
801089ac:	eb f2                	jmp    801089a0 <push_mlfq+0x80>
        return -1;
801089ae:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801089b3:	eb e0                	jmp    80108995 <push_mlfq+0x75>
801089b5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801089b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801089c0 <move_prior>:

// Downgrade selected node's priority
int
move_prior(int pid, int prior) 
{
801089c0:	55                   	push   %ebp
801089c1:	89 e5                	mov    %esp,%ebp
801089c3:	56                   	push   %esi
801089c4:	53                   	push   %ebx
801089c5:	8b 5d 08             	mov    0x8(%ebp),%ebx
801089c8:	8b 75 0c             	mov    0xc(%ebp),%esi
    // Pop an push for immigration
    if(pop_mlfq(pid) == -1)
801089cb:	53                   	push   %ebx
801089cc:	e8 af fe ff ff       	call   80108880 <pop_mlfq>
801089d1:	83 f8 ff             	cmp    $0xffffffff,%eax
801089d4:	5a                   	pop    %edx
801089d5:	74 19                	je     801089f0 <move_prior+0x30>
    {
        return -1;
    }
    return push_mlfq(pid, prior);
801089d7:	89 75 0c             	mov    %esi,0xc(%ebp)
801089da:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801089dd:	8d 65 f8             	lea    -0x8(%ebp),%esp
801089e0:	5b                   	pop    %ebx
801089e1:	5e                   	pop    %esi
801089e2:	5d                   	pop    %ebp
    return push_mlfq(pid, prior);
801089e3:	e9 38 ff ff ff       	jmp    80108920 <push_mlfq>
801089e8:	90                   	nop
801089e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
}
801089f0:	8d 65 f8             	lea    -0x8(%ebp),%esp
801089f3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801089f8:	5b                   	pop    %ebx
801089f9:	5e                   	pop    %esi
801089fa:	5d                   	pop    %ebp
801089fb:	c3                   	ret    
801089fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80108a00 <pick_stride>:

// Find min pass in s_table
// There is no need to take ptable.lock
struct proc*
pick_stride(void)
{
80108a00:	55                   	push   %ebp
80108a01:	89 e5                	mov    %esp,%ebp
80108a03:	56                   	push   %esi
80108a04:	53                   	push   %ebx
    struct stride* s;
    struct stride* ret = &s_table[0];
80108a05:	bb 20 4d 11 80       	mov    $0x80114d20,%ebx
    for(s = s_table; s < &s_table[NPROC]; ++s){
80108a0a:	89 d9                	mov    %ebx,%ecx
80108a0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        if(s->state != USED){
80108a10:	8b 41 14             	mov    0x14(%ecx),%eax
80108a13:	85 c0                	test   %eax,%eax
80108a15:	75 31                	jne    80108a48 <pick_stride+0x48>
            continue;
        }

        if(isRunnable(s->pid) == 0)
80108a17:	8b 51 0c             	mov    0xc(%ecx),%edx
    for(p = ptable.proc; p < &ptable.proc[NPROC]; ++p)
80108a1a:	b8 74 5f 11 80       	mov    $0x80115f74,%eax
80108a1f:	eb 13                	jmp    80108a34 <pick_stride+0x34>
80108a21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80108a28:	05 a0 01 00 00       	add    $0x1a0,%eax
80108a2d:	3d 74 c7 11 80       	cmp    $0x8011c774,%eax
80108a32:	73 14                	jae    80108a48 <pick_stride+0x48>
        if(p->pid == pid && p->state == RUNNABLE)
80108a34:	3b 50 10             	cmp    0x10(%eax),%edx
80108a37:	75 ef                	jne    80108a28 <pick_stride+0x28>
80108a39:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
80108a3d:	75 e9                	jne    80108a28 <pick_stride+0x28>
            continue;


        if(ret->pass > s->pass){
80108a3f:	8b 41 08             	mov    0x8(%ecx),%eax
80108a42:	39 43 08             	cmp    %eax,0x8(%ebx)
80108a45:	0f 4f d9             	cmovg  %ecx,%ebx
    for(s = s_table; s < &s_table[NPROC]; ++s){
80108a48:	83 c1 18             	add    $0x18,%ecx
80108a4b:	81 f9 20 53 11 80    	cmp    $0x80115320,%ecx
80108a51:	75 bd                	jne    80108a10 <pick_stride+0x10>
            ret = s;
        }
    }

    if(ret == s_table){
80108a53:	81 fb 20 4d 11 80    	cmp    $0x80114d20,%ebx
80108a59:	74 15                	je     80108a70 <pick_stride+0x70>
        }
        return p;
    }

    
    return pick_lwp(ret->pid);
80108a5b:	83 ec 0c             	sub    $0xc,%esp
80108a5e:	ff 73 0c             	pushl  0xc(%ebx)
80108a61:	e8 7a fc ff ff       	call   801086e0 <pick_lwp>
80108a66:	83 c4 10             	add    $0x10,%esp
}
80108a69:	8d 65 f8             	lea    -0x8(%ebp),%esp
80108a6c:	5b                   	pop    %ebx
80108a6d:	5e                   	pop    %esi
80108a6e:	5d                   	pop    %ebp
80108a6f:	c3                   	ret    
        struct proc* p = pick_mlfq();
80108a70:	e8 1b fd ff ff       	call   80108790 <pick_mlfq>
        if(p == 0){
80108a75:	85 c0                	test   %eax,%eax
80108a77:	75 f0                	jne    80108a69 <pick_stride+0x69>
80108a79:	be 20 4d 11 80       	mov    $0x80114d20,%esi
            int minimum = 1000000000;
80108a7e:	bb 00 ca 9a 3b       	mov    $0x3b9aca00,%ebx
            for(s = s_table; s < &s_table[NPROC]; ++s){
80108a83:	89 f1                	mov    %esi,%ecx
                if(s->state == EMPTY)
80108a85:	83 79 14 01          	cmpl   $0x1,0x14(%ecx)
80108a89:	74 2f                	je     80108aba <pick_stride+0xba>
                if(!isRunnable(s->pid))
80108a8b:	8b 51 0c             	mov    0xc(%ecx),%edx
    for(p = ptable.proc; p < &ptable.proc[NPROC]; ++p)
80108a8e:	b8 74 5f 11 80       	mov    $0x80115f74,%eax
80108a93:	eb 0f                	jmp    80108aa4 <pick_stride+0xa4>
80108a95:	8d 76 00             	lea    0x0(%esi),%esi
80108a98:	05 a0 01 00 00       	add    $0x1a0,%eax
80108a9d:	3d 74 c7 11 80       	cmp    $0x8011c774,%eax
80108aa2:	73 16                	jae    80108aba <pick_stride+0xba>
        if(p->pid == pid && p->state == RUNNABLE)
80108aa4:	3b 50 10             	cmp    0x10(%eax),%edx
80108aa7:	75 ef                	jne    80108a98 <pick_stride+0x98>
80108aa9:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
80108aad:	75 e9                	jne    80108a98 <pick_stride+0x98>
                if(minimum > s->pass){
80108aaf:	8b 41 08             	mov    0x8(%ecx),%eax
80108ab2:	39 d8                	cmp    %ebx,%eax
80108ab4:	7d 04                	jge    80108aba <pick_stride+0xba>
80108ab6:	89 c3                	mov    %eax,%ebx
80108ab8:	89 ce                	mov    %ecx,%esi
            for(s = s_table; s < &s_table[NPROC]; ++s){
80108aba:	83 c1 18             	add    $0x18,%ecx
80108abd:	81 f9 20 53 11 80    	cmp    $0x80115320,%ecx
80108ac3:	75 c0                	jne    80108a85 <pick_stride+0x85>
            return pick_lwp(ret->pid);
80108ac5:	83 ec 0c             	sub    $0xc,%esp
80108ac8:	ff 76 0c             	pushl  0xc(%esi)
80108acb:	e8 10 fc ff ff       	call   801086e0 <pick_lwp>
80108ad0:	83 c4 10             	add    $0x10,%esp
}
80108ad3:	8d 65 f8             	lea    -0x8(%ebp),%esp
80108ad6:	5b                   	pop    %ebx
80108ad7:	5e                   	pop    %esi
80108ad8:	5d                   	pop    %ebp
80108ad9:	c3                   	ret    
80108ada:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80108ae0 <scheduler>:
{
80108ae0:	55                   	push   %ebp
80108ae1:	89 e5                	mov    %esp,%ebp
80108ae3:	57                   	push   %edi
80108ae4:	56                   	push   %esi
80108ae5:	53                   	push   %ebx
80108ae6:	83 ec 1c             	sub    $0x1c,%esp
  struct cpu *c = mycpu();
80108ae9:	e8 22 b7 ff ff       	call   80104210 <mycpu>
  c->proc = 0;
80108aee:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80108af5:	00 00 00 
  struct cpu *c = mycpu();
80108af8:	89 c6                	mov    %eax,%esi
80108afa:	8d 40 04             	lea    0x4(%eax),%eax
80108afd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  asm volatile("sti");
80108b00:	fb                   	sti    
    acquire(&ptable.lock);
80108b01:	83 ec 0c             	sub    $0xc,%esp
    for(cand = ptable.proc; cand < &ptable.proc[NPROC]; cand++){
80108b04:	bb 74 5f 11 80       	mov    $0x80115f74,%ebx
    acquire(&ptable.lock);
80108b09:	68 40 5f 11 80       	push   $0x80115f40
80108b0e:	e8 ed cb ff ff       	call   80105700 <acquire>
80108b13:	83 c4 10             	add    $0x10,%esp
80108b16:	8d 76 00             	lea    0x0(%esi),%esi
80108b19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
        if(cand->state != RUNNABLE)
80108b20:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80108b24:	75 44                	jne    80108b6a <scheduler+0x8a>
        p = pick_stride();
80108b26:	e8 d5 fe ff ff       	call   80108a00 <pick_stride>
        if(p < 0 || p > &ptable.proc[NPROC])
80108b2b:	3d 74 c7 11 80       	cmp    $0x8011c774,%eax
        p = pick_stride();
80108b30:	89 c7                	mov    %eax,%edi
        if(p < 0 || p > &ptable.proc[NPROC])
80108b32:	0f 47 fb             	cmova  %ebx,%edi
        switchuvm(p);
80108b35:	83 ec 0c             	sub    $0xc,%esp
        c->proc = p;
80108b38:	89 be ac 00 00 00    	mov    %edi,0xac(%esi)
        switchuvm(p);
80108b3e:	57                   	push   %edi
80108b3f:	e8 2c f3 ff ff       	call   80107e70 <switchuvm>
        p->state = RUNNING;
80108b44:	c7 47 0c 04 00 00 00 	movl   $0x4,0xc(%edi)
        swtch(&(c->scheduler), p->context);
80108b4b:	58                   	pop    %eax
80108b4c:	5a                   	pop    %edx
80108b4d:	ff 77 1c             	pushl  0x1c(%edi)
80108b50:	ff 75 e4             	pushl  -0x1c(%ebp)
80108b53:	e8 f3 ce ff ff       	call   80105a4b <swtch>
        switchkvm();
80108b58:	e8 f3 f2 ff ff       	call   80107e50 <switchkvm>
        c->proc = 0;
80108b5d:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80108b64:	00 00 00 
80108b67:	83 c4 10             	add    $0x10,%esp
    for(cand = ptable.proc; cand < &ptable.proc[NPROC]; cand++){
80108b6a:	81 c3 a0 01 00 00    	add    $0x1a0,%ebx
80108b70:	81 fb 74 c7 11 80    	cmp    $0x8011c774,%ebx
80108b76:	72 a8                	jb     80108b20 <scheduler+0x40>
    release(&ptable.lock);
80108b78:	83 ec 0c             	sub    $0xc,%esp
80108b7b:	68 40 5f 11 80       	push   $0x80115f40
80108b80:	e8 3b cc ff ff       	call   801057c0 <release>
    sti();
80108b85:	83 c4 10             	add    $0x10,%esp
80108b88:	e9 73 ff ff ff       	jmp    80108b00 <scheduler+0x20>
80108b8d:	8d 76 00             	lea    0x0(%esi),%esi

80108b90 <add_pass_stride>:

// Add pass to this stride
void
add_pass_stride(void)
{
80108b90:	55                   	push   %ebp
80108b91:	89 e5                	mov    %esp,%ebp
80108b93:	83 ec 08             	sub    $0x8,%esp
    struct stride* s = myproc()->pstride;
80108b96:	e8 15 b7 ff ff       	call   801042b0 <myproc>
80108b9b:	8b 90 80 00 00 00    	mov    0x80(%eax),%edx

    s->pass += s->stride;
80108ba1:	8b 42 04             	mov    0x4(%edx),%eax
80108ba4:	03 42 08             	add    0x8(%edx),%eax

    // Check whether it is overflow or not
    if(s->pass > 100000000){
80108ba7:	3d 00 e1 f5 05       	cmp    $0x5f5e100,%eax
    s->pass += s->stride;
80108bac:	89 42 08             	mov    %eax,0x8(%edx)
    if(s->pass > 100000000){
80108baf:	7e 27                	jle    80108bd8 <add_pass_stride+0x48>
        for(s = s_table; s < &s_table[NPROC]; ++s){
80108bb1:	b8 20 4d 11 80       	mov    $0x80114d20,%eax
80108bb6:	8d 76 00             	lea    0x0(%esi),%esi
80108bb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
            if(s->state != USED)
80108bc0:	8b 50 14             	mov    0x14(%eax),%edx
80108bc3:	85 d2                	test   %edx,%edx
80108bc5:	75 07                	jne    80108bce <add_pass_stride+0x3e>
                continue;
            
            s->pass = 0;
80108bc7:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        for(s = s_table; s < &s_table[NPROC]; ++s){
80108bce:	83 c0 18             	add    $0x18,%eax
80108bd1:	3d 20 53 11 80       	cmp    $0x80115320,%eax
80108bd6:	75 e8                	jne    80108bc0 <add_pass_stride+0x30>
        }
    }
}
80108bd8:	c9                   	leave  
80108bd9:	c3                   	ret    
80108bda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80108be0 <set_cpu_share>:


// Set for CPU share
int
set_cpu_share(int inquire)
{
80108be0:	55                   	push   %ebp
80108be1:	89 e5                	mov    %esp,%ebp
80108be3:	57                   	push   %edi
80108be4:	56                   	push   %esi
80108be5:	53                   	push   %ebx
80108be6:	83 ec 0c             	sub    $0xc,%esp
80108be9:	8b 75 08             	mov    0x8(%ebp),%esi
    int min_pass = 1000000000;
    struct stride* s;
    struct proc* p;
    struct proc* curproc = myproc();
80108bec:	e8 bf b6 ff ff       	call   801042b0 <myproc>
    struct proc* master_thread = find_master(curproc->pid);
80108bf1:	83 ec 0c             	sub    $0xc,%esp
80108bf4:	ff 70 10             	pushl  0x10(%eax)
80108bf7:	e8 b4 b5 ff ff       	call   801041b0 <find_master>
80108bfc:	89 c7                	mov    %eax,%edi

    if(inquire <= 0 || inquire > 80)
80108bfe:	8d 46 ff             	lea    -0x1(%esi),%eax
80108c01:	83 c4 10             	add    $0x10,%esp
80108c04:	83 f8 4f             	cmp    $0x4f,%eax
80108c07:	0f 87 0e 01 00 00    	ja     80108d1b <set_cpu_share+0x13b>
        return -1;

    if(myproc()->schedstate == STRIDE){
80108c0d:	e8 9e b6 ff ff       	call   801042b0 <myproc>
80108c12:	83 78 7c 03          	cmpl   $0x3,0x7c(%eax)
80108c16:	0f 84 ff 00 00 00    	je     80108d1b <set_cpu_share+0x13b>
80108c1c:	b8 38 4d 11 80       	mov    $0x80114d38,%eax
80108c21:	89 f2                	mov    %esi,%edx
    int min_pass = 1000000000;
80108c23:	bb 00 ca 9a 3b       	mov    $0x3b9aca00,%ebx
80108c28:	90                   	nop
80108c29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    }

    // Calculate already assigned value's sum
    int sum = inquire;
    for(int i = 1; i < NPROC; ++i){
        if(s_table[i].state == USED)
80108c30:	8b 48 14             	mov    0x14(%eax),%ecx
80108c33:	85 c9                	test   %ecx,%ecx
80108c35:	75 0a                	jne    80108c41 <set_cpu_share+0x61>
80108c37:	8b 48 08             	mov    0x8(%eax),%ecx
        {
            sum += s_table[i].tickets;
80108c3a:	03 10                	add    (%eax),%edx
80108c3c:	39 cb                	cmp    %ecx,%ebx
80108c3e:	0f 4f d9             	cmovg  %ecx,%ebx
80108c41:	83 c0 18             	add    $0x18,%eax
    for(int i = 1; i < NPROC; ++i){
80108c44:	3d 20 53 11 80       	cmp    $0x80115320,%eax
80108c49:	75 e5                	jne    80108c30 <set_cpu_share+0x50>
80108c4b:	39 1d 28 4d 11 80    	cmp    %ebx,0x80114d28
80108c51:	0f 4e 1d 28 4d 11 80 	cmovle 0x80114d28,%ebx
    if(min_pass > s_table[0].pass)
    {
        min_pass = s_table[0].pass;
    }

    if(sum > 80)
80108c58:	83 fa 50             	cmp    $0x50,%edx
80108c5b:	0f 8f ba 00 00 00    	jg     80108d1b <set_cpu_share+0x13b>
      return -1;


    acquire(&ptable.lock);
80108c61:	83 ec 0c             	sub    $0xc,%esp
80108c64:	68 40 5f 11 80       	push   $0x80115f40
80108c69:	e8 92 ca ff ff       	call   80105700 <acquire>
    
    pop_mlfq(master_thread->pid);
80108c6e:	58                   	pop    %eax
80108c6f:	ff 77 10             	pushl  0x10(%edi)
80108c72:	e8 09 fc ff ff       	call   80108880 <pop_mlfq>
80108c77:	83 c4 10             	add    $0x10,%esp
    for(s = &s_table[1];s < &s_table[NPROC]; s++)
80108c7a:	b9 38 4d 11 80       	mov    $0x80114d38,%ecx
80108c7f:	eb 12                	jmp    80108c93 <set_cpu_share+0xb3>
80108c81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80108c88:	83 c1 18             	add    $0x18,%ecx
80108c8b:	81 f9 20 53 11 80    	cmp    $0x80115320,%ecx
80108c91:	73 06                	jae    80108c99 <set_cpu_share+0xb9>
    {
        if(s->state == EMPTY)
80108c93:	83 79 14 01          	cmpl   $0x1,0x14(%ecx)
80108c97:	75 ef                	jne    80108c88 <set_cpu_share+0xa8>
            break;
    }

    // New stride is assigned into s
    s->tickets = inquire;
    s->stride = stride1/(s->tickets);
80108c99:	a1 08 c0 10 80       	mov    0x8010c008,%eax
    s->tickets = inquire;
80108c9e:	89 31                	mov    %esi,(%ecx)
    s->pass = min_pass;
80108ca0:	89 59 08             	mov    %ebx,0x8(%ecx)
    s->state = USED;
80108ca3:	c7 41 14 00 00 00 00 	movl   $0x0,0x14(%ecx)
    s->pid = master_thread->pid;
    
    // MLFQ stride
    s_table->tickets -= inquire;
80108caa:	8b 1d 20 4d 11 80    	mov    0x80114d20,%ebx
    s->stride = stride1/(s->tickets);
80108cb0:	99                   	cltd   
80108cb1:	f7 fe                	idiv   %esi
    s_table->tickets -= inquire;
80108cb3:	29 f3                	sub    %esi,%ebx
80108cb5:	89 1d 20 4d 11 80    	mov    %ebx,0x80114d20
    s->stride = stride1/(s->tickets);
80108cbb:	89 41 04             	mov    %eax,0x4(%ecx)
    s->pid = master_thread->pid;
80108cbe:	8b 47 10             	mov    0x10(%edi),%eax
80108cc1:	89 41 0c             	mov    %eax,0xc(%ecx)
    s_table->stride = stride1/(s_table->tickets);
80108cc4:	a1 08 c0 10 80       	mov    0x8010c008,%eax
80108cc9:	99                   	cltd   
80108cca:	f7 fb                	idiv   %ebx
80108ccc:	a3 24 4d 11 80       	mov    %eax,0x80114d24

    // Link processes with stride
    for(p = ptable.proc; p < &ptable.proc[NPROC]; ++p)
80108cd1:	b8 74 5f 11 80       	mov    $0x80115f74,%eax
80108cd6:	8d 76 00             	lea    0x0(%esi),%esi
80108cd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    {
        if(p->pid != master_thread->pid)
80108ce0:	8b 77 10             	mov    0x10(%edi),%esi
80108ce3:	39 70 10             	cmp    %esi,0x10(%eax)
80108ce6:	75 0d                	jne    80108cf5 <set_cpu_share+0x115>
            continue;

        p->schedstate = STRIDE;
80108ce8:	c7 40 7c 03 00 00 00 	movl   $0x3,0x7c(%eax)
        p->pstride = s;
80108cef:	89 88 80 00 00 00    	mov    %ecx,0x80(%eax)
    for(p = ptable.proc; p < &ptable.proc[NPROC]; ++p)
80108cf5:	05 a0 01 00 00       	add    $0x1a0,%eax
80108cfa:	3d 74 c7 11 80       	cmp    $0x8011c774,%eax
80108cff:	72 df                	jb     80108ce0 <set_cpu_share+0x100>
    }
    release(&ptable.lock);
80108d01:	83 ec 0c             	sub    $0xc,%esp
80108d04:	68 40 5f 11 80       	push   $0x80115f40
80108d09:	e8 b2 ca ff ff       	call   801057c0 <release>

    return 0;
80108d0e:	83 c4 10             	add    $0x10,%esp
80108d11:	31 c0                	xor    %eax,%eax
}
80108d13:	8d 65 f4             	lea    -0xc(%ebp),%esp
80108d16:	5b                   	pop    %ebx
80108d17:	5e                   	pop    %esi
80108d18:	5f                   	pop    %edi
80108d19:	5d                   	pop    %ebp
80108d1a:	c3                   	ret    
        return -1;
80108d1b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108d20:	eb f1                	jmp    80108d13 <set_cpu_share+0x133>
80108d22:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80108d29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80108d30 <getlev>:

int
getlev(void)
{
80108d30:	55                   	push   %ebp
80108d31:	89 e5                	mov    %esp,%ebp
80108d33:	83 ec 08             	sub    $0x8,%esp
    struct proc* p = myproc();
80108d36:	e8 75 b5 ff ff       	call   801042b0 <myproc>

    if(p->schedstate == STRIDE)
80108d3b:	83 78 7c 03          	cmpl   $0x3,0x7c(%eax)
80108d3f:	74 0f                	je     80108d50 <getlev+0x20>
        return -1;

    return p->pmlfq_node->prior;
80108d41:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
80108d47:	8b 40 0c             	mov    0xc(%eax),%eax
}
80108d4a:	c9                   	leave  
80108d4b:	c3                   	ret    
80108d4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        return -1;
80108d50:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80108d55:	c9                   	leave  
80108d56:	c3                   	ret    
80108d57:	89 f6                	mov    %esi,%esi
80108d59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80108d60 <prior_boost>:

// Priority boost evry 200 ticks
void
prior_boost(void)
{  
80108d60:	55                   	push   %ebp
80108d61:	89 e5                	mov    %esp,%ebp
80108d63:	57                   	push   %edi
80108d64:	56                   	push   %esi
80108d65:	53                   	push   %ebx
80108d66:	be 20 53 11 80       	mov    $0x80115320,%esi
80108d6b:	83 ec 0c             	sub    $0xc,%esp
    struct mlfq_node* m;

    for(int prior = 0; prior < 3; ++prior)
    {
        if(m_table[prior].count == 0)
80108d6e:	8b be 00 04 00 00    	mov    0x400(%esi),%edi
80108d74:	89 f3                	mov    %esi,%ebx
80108d76:	85 ff                	test   %edi,%edi
80108d78:	74 27                	je     80108da1 <prior_boost+0x41>
80108d7a:	8d be 00 04 00 00    	lea    0x400(%esi),%edi
            continue;

        for(m = m_table[prior].table; m < &m_table[prior].table[NPROC]; ++m){
80108d80:	39 fe                	cmp    %edi,%esi
80108d82:	73 1d                	jae    80108da1 <prior_boost+0x41>
80108d84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
            if(m->state != USED)
80108d88:	8b 0b                	mov    (%ebx),%ecx
80108d8a:	85 c9                	test   %ecx,%ecx
80108d8c:	75 0c                	jne    80108d9a <prior_boost+0x3a>
                continue;
            move_prior(m->pid, 0);
80108d8e:	6a 00                	push   $0x0
80108d90:	ff 73 08             	pushl  0x8(%ebx)
80108d93:	e8 28 fc ff ff       	call   801089c0 <move_prior>
80108d98:	58                   	pop    %eax
80108d99:	5a                   	pop    %edx
        for(m = m_table[prior].table; m < &m_table[prior].table[NPROC]; ++m){
80108d9a:	83 c3 10             	add    $0x10,%ebx
80108d9d:	39 fb                	cmp    %edi,%ebx
80108d9f:	72 e7                	jb     80108d88 <prior_boost+0x28>
80108da1:	81 c6 08 04 00 00    	add    $0x408,%esi
    for(int prior = 0; prior < 3; ++prior)
80108da7:	81 fe 38 5f 11 80    	cmp    $0x80115f38,%esi
80108dad:	75 bf                	jne    80108d6e <prior_boost+0xe>
        }
    }

    acquire(&sched_tickslock);
80108daf:	83 ec 0c             	sub    $0xc,%esp
80108db2:	68 e0 cf 11 80       	push   $0x8011cfe0
80108db7:	e8 44 c9 ff ff       	call   80105700 <acquire>
    schedticks = 0;
    release(&sched_tickslock);
80108dbc:	c7 04 24 e0 cf 11 80 	movl   $0x8011cfe0,(%esp)
    schedticks = 0;
80108dc3:	c7 05 14 d0 11 80 00 	movl   $0x0,0x8011d014
80108dca:	00 00 00 
    release(&sched_tickslock);
80108dcd:	e8 ee c9 ff ff       	call   801057c0 <release>
}
80108dd2:	83 c4 10             	add    $0x10,%esp
80108dd5:	8d 65 f4             	lea    -0xc(%ebp),%esp
80108dd8:	5b                   	pop    %ebx
80108dd9:	5e                   	pop    %esi
80108dda:	5f                   	pop    %edi
80108ddb:	5d                   	pop    %ebp
80108ddc:	c3                   	ret    
80108ddd:	8d 76 00             	lea    0x0(%esi),%esi

80108de0 <add_tick>:
{
80108de0:	55                   	push   %ebp
80108de1:	89 e5                	mov    %esp,%ebp
80108de3:	57                   	push   %edi
80108de4:	56                   	push   %esi
80108de5:	53                   	push   %ebx
80108de6:	83 ec 0c             	sub    $0xc,%esp
    struct proc* p = myproc();
80108de9:	e8 c2 b4 ff ff       	call   801042b0 <myproc>
    acquire(&ptable.lock);
80108dee:	83 ec 0c             	sub    $0xc,%esp
    struct proc* p = myproc();
80108df1:	89 c3                	mov    %eax,%ebx
    acquire(&ptable.lock);
80108df3:	68 40 5f 11 80       	push   $0x80115f40
80108df8:	e8 03 c9 ff ff       	call   80105700 <acquire>
    add_pass_stride();
80108dfd:	e8 8e fd ff ff       	call   80108b90 <add_pass_stride>
    if(p->state != RUNNING)
80108e02:	83 c4 10             	add    $0x10,%esp
80108e05:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80108e09:	74 25                	je     80108e30 <add_tick+0x50>
        release(&ptable.lock);
80108e0b:	83 ec 0c             	sub    $0xc,%esp
80108e0e:	68 40 5f 11 80       	push   $0x80115f40
80108e13:	e8 a8 c9 ff ff       	call   801057c0 <release>
        return 1;
80108e18:	83 c4 10             	add    $0x10,%esp
}
80108e1b:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 1;
80108e1e:	b8 01 00 00 00       	mov    $0x1,%eax
}
80108e23:	5b                   	pop    %ebx
80108e24:	5e                   	pop    %esi
80108e25:	5f                   	pop    %edi
80108e26:	5d                   	pop    %ebp
80108e27:	c3                   	ret    
80108e28:	90                   	nop
80108e29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&sched_tickslock);
80108e30:	83 ec 0c             	sub    $0xc,%esp
80108e33:	68 e0 cf 11 80       	push   $0x8011cfe0
80108e38:	e8 c3 c8 ff ff       	call   80105700 <acquire>
    int cur_tick = schedticks++;
80108e3d:	8b 35 14 d0 11 80    	mov    0x8011d014,%esi
    release(&sched_tickslock);
80108e43:	c7 04 24 e0 cf 11 80 	movl   $0x8011cfe0,(%esp)
    int cur_tick = schedticks++;
80108e4a:	8d 46 01             	lea    0x1(%esi),%eax
80108e4d:	a3 14 d0 11 80       	mov    %eax,0x8011d014
    release(&sched_tickslock);
80108e52:	e8 69 c9 ff ff       	call   801057c0 <release>
    if(p->schedstate != MLFQ)
80108e57:	83 c4 10             	add    $0x10,%esp
80108e5a:	83 7b 7c 02          	cmpl   $0x2,0x7c(%ebx)
80108e5e:	74 38                	je     80108e98 <add_tick+0xb8>
        if(cur_tick % 5 == 0)
80108e60:	89 f0                	mov    %esi,%eax
80108e62:	ba 67 66 66 66       	mov    $0x66666667,%edx
80108e67:	f7 ea                	imul   %edx
80108e69:	89 f0                	mov    %esi,%eax
80108e6b:	c1 f8 1f             	sar    $0x1f,%eax
80108e6e:	d1 fa                	sar    %edx
80108e70:	29 c2                	sub    %eax,%edx
80108e72:	8d 04 92             	lea    (%edx,%edx,4),%eax
80108e75:	39 c6                	cmp    %eax,%esi
80108e77:	74 92                	je     80108e0b <add_tick+0x2b>
        release(&ptable.lock);
80108e79:	83 ec 0c             	sub    $0xc,%esp
80108e7c:	68 40 5f 11 80       	push   $0x80115f40
80108e81:	e8 3a c9 ff ff       	call   801057c0 <release>
        return 0;
80108e86:	83 c4 10             	add    $0x10,%esp
}
80108e89:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
80108e8c:	31 c0                	xor    %eax,%eax
}
80108e8e:	5b                   	pop    %ebx
80108e8f:	5e                   	pop    %esi
80108e90:	5f                   	pop    %edi
80108e91:	5d                   	pop    %ebp
80108e92:	c3                   	ret    
80108e93:	90                   	nop
80108e94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    m = p->pmlfq_node;
80108e98:	8b 83 84 00 00 00    	mov    0x84(%ebx),%eax
    m->eticks += 1;
80108e9e:	8b 48 04             	mov    0x4(%eax),%ecx
80108ea1:	8d 79 01             	lea    0x1(%ecx),%edi
80108ea4:	89 78 04             	mov    %edi,0x4(%eax)
    switch (m->prior)
80108ea7:	8b 40 0c             	mov    0xc(%eax),%eax
80108eaa:	83 f8 01             	cmp    $0x1,%eax
80108ead:	0f 84 95 00 00 00    	je     80108f48 <add_tick+0x168>
80108eb3:	83 f8 02             	cmp    $0x2,%eax
80108eb6:	74 48                	je     80108f00 <add_tick+0x120>
80108eb8:	85 c0                	test   %eax,%eax
80108eba:	0f 85 4b ff ff ff    	jne    80108e0b <add_tick+0x2b>
        if(elapsed_ticks >= 20){
80108ec0:	83 ff 13             	cmp    $0x13,%edi
80108ec3:	0f 8f af 00 00 00    	jg     80108f78 <add_tick+0x198>
        if((elapsed_ticks % 5) == 0){
80108ec9:	89 f8                	mov    %edi,%eax
80108ecb:	ba 67 66 66 66       	mov    $0x66666667,%edx
80108ed0:	f7 ea                	imul   %edx
80108ed2:	89 f8                	mov    %edi,%eax
80108ed4:	c1 f8 1f             	sar    $0x1f,%eax
80108ed7:	d1 fa                	sar    %edx
80108ed9:	29 c2                	sub    %eax,%edx
80108edb:	8d 04 92             	lea    (%edx,%edx,4),%eax
80108ede:	39 c7                	cmp    %eax,%edi
80108ee0:	75 97                	jne    80108e79 <add_tick+0x99>
            if(cur_tick >= 200){
80108ee2:	81 fe c7 00 00 00    	cmp    $0xc7,%esi
80108ee8:	0f 8e 1d ff ff ff    	jle    80108e0b <add_tick+0x2b>
                prior_boost();
80108eee:	e8 6d fe ff ff       	call   80108d60 <prior_boost>
80108ef3:	e9 13 ff ff ff       	jmp    80108e0b <add_tick+0x2b>
80108ef8:	90                   	nop
80108ef9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        if((elapsed_ticks % 20) == 0){
80108f00:	89 f8                	mov    %edi,%eax
80108f02:	ba 67 66 66 66       	mov    $0x66666667,%edx
80108f07:	f7 ea                	imul   %edx
80108f09:	89 f8                	mov    %edi,%eax
80108f0b:	c1 f8 1f             	sar    $0x1f,%eax
80108f0e:	c1 fa 03             	sar    $0x3,%edx
80108f11:	29 c2                	sub    %eax,%edx
80108f13:	8d 04 92             	lea    (%edx,%edx,4),%eax
80108f16:	c1 e0 02             	shl    $0x2,%eax
80108f19:	39 c7                	cmp    %eax,%edi
80108f1b:	0f 85 58 ff ff ff    	jne    80108e79 <add_tick+0x99>
            if(cur_tick >= 200){
80108f21:	81 fe c7 00 00 00    	cmp    $0xc7,%esi
80108f27:	0f 8e de fe ff ff    	jle    80108e0b <add_tick+0x2b>
                prior_boost();
80108f2d:	e8 2e fe ff ff       	call   80108d60 <prior_boost>
                schedticks = 0;
80108f32:	c7 05 14 d0 11 80 00 	movl   $0x0,0x8011d014
80108f39:	00 00 00 
80108f3c:	e9 ca fe ff ff       	jmp    80108e0b <add_tick+0x2b>
80108f41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        if(elapsed_ticks >= 40){
80108f48:	83 ff 27             	cmp    $0x27,%edi
80108f4b:	7f 43                	jg     80108f90 <add_tick+0x1b0>
        if((elapsed_ticks % 10) == 0){
80108f4d:	89 f8                	mov    %edi,%eax
80108f4f:	ba 67 66 66 66       	mov    $0x66666667,%edx
80108f54:	f7 ea                	imul   %edx
80108f56:	89 f8                	mov    %edi,%eax
80108f58:	c1 f8 1f             	sar    $0x1f,%eax
80108f5b:	c1 fa 02             	sar    $0x2,%edx
80108f5e:	29 c2                	sub    %eax,%edx
80108f60:	8d 04 92             	lea    (%edx,%edx,4),%eax
80108f63:	01 c0                	add    %eax,%eax
80108f65:	39 c7                	cmp    %eax,%edi
80108f67:	0f 84 75 ff ff ff    	je     80108ee2 <add_tick+0x102>
80108f6d:	e9 07 ff ff ff       	jmp    80108e79 <add_tick+0x99>
80108f72:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
            move_prior(p->pid, 1);
80108f78:	83 ec 08             	sub    $0x8,%esp
80108f7b:	6a 01                	push   $0x1
80108f7d:	ff 73 10             	pushl  0x10(%ebx)
80108f80:	e8 3b fa ff ff       	call   801089c0 <move_prior>
80108f85:	83 c4 10             	add    $0x10,%esp
80108f88:	e9 3c ff ff ff       	jmp    80108ec9 <add_tick+0xe9>
80108f8d:	8d 76 00             	lea    0x0(%esi),%esi
            move_prior(p->pid, 2);
80108f90:	83 ec 08             	sub    $0x8,%esp
80108f93:	6a 02                	push   $0x2
80108f95:	ff 73 10             	pushl  0x10(%ebx)
80108f98:	e8 23 fa ff ff       	call   801089c0 <move_prior>
80108f9d:	83 c4 10             	add    $0x10,%esp
80108fa0:	eb ab                	jmp    80108f4d <add_tick+0x16d>
