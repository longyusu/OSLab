
bin/kernel:     file format elf64-littleriscv


Disassembly of section .text:

ffffffffc0200000 <kern_entry>:

    .section .text,"ax",%progbits
    .globl kern_entry
kern_entry:
    # t0 := 三级页表的虚拟地址
    lui     t0, %hi(boot_page_table_sv39)
ffffffffc0200000:	c02092b7          	lui	t0,0xc0209
    # t1 := 0xffffffff40000000 即虚实映射偏移量
    li      t1, 0xffffffffc0000000 - 0x80000000
ffffffffc0200004:	ffd0031b          	addiw	t1,zero,-3
ffffffffc0200008:	037a                	slli	t1,t1,0x1e
    # t0 减去虚实映射偏移量 0xffffffff40000000，变为三级页表的物理地址
    sub     t0, t0, t1
ffffffffc020000a:	406282b3          	sub	t0,t0,t1
    # t0 >>= 12，变为三级页表的物理页号
    srli    t0, t0, 12
ffffffffc020000e:	00c2d293          	srli	t0,t0,0xc

    # t1 := 8 << 60，设置 satp 的 MODE 字段为 Sv39
    li      t1, 8 << 60
ffffffffc0200012:	fff0031b          	addiw	t1,zero,-1
ffffffffc0200016:	137e                	slli	t1,t1,0x3f
    # 将刚才计算出的预设三级页表物理页号附加到 satp 中
    or      t0, t0, t1
ffffffffc0200018:	0062e2b3          	or	t0,t0,t1
    # 将算出的 t0(即新的MODE|页表基址物理页号) 覆盖到 satp 中
    csrw    satp, t0
ffffffffc020001c:	18029073          	csrw	satp,t0
    # 使用 sfence.vma 指令刷新 TLB
    sfence.vma
ffffffffc0200020:	12000073          	sfence.vma
    # 从此，我们给内核搭建出了一个完美的虚拟内存空间！
    #nop # 可能映射的位置有些bug。。插入一个nop
    
    # 我们在虚拟内存空间中：随意将 sp 设置为虚拟地址！
    lui sp, %hi(bootstacktop)
ffffffffc0200024:	c0209137          	lui	sp,0xc0209

    # 我们在虚拟内存空间中：随意跳转到虚拟地址！
    # 跳转到 kern_init
    lui t0, %hi(kern_init)
ffffffffc0200028:	c02002b7          	lui	t0,0xc0200
    addi t0, t0, %lo(kern_init)
ffffffffc020002c:	03228293          	addi	t0,t0,50 # ffffffffc0200032 <kern_init>
    jr t0
ffffffffc0200030:	8282                	jr	t0

ffffffffc0200032 <kern_init>:


int
kern_init(void) {
    extern char edata[], end[];
    memset(edata, 0, end - edata);
ffffffffc0200032:	0000a517          	auipc	a0,0xa
ffffffffc0200036:	00e50513          	addi	a0,a0,14 # ffffffffc020a040 <ide>
ffffffffc020003a:	00011617          	auipc	a2,0x11
ffffffffc020003e:	53660613          	addi	a2,a2,1334 # ffffffffc0211570 <end>
kern_init(void) {
ffffffffc0200042:	1141                	addi	sp,sp,-16
    memset(edata, 0, end - edata);
ffffffffc0200044:	8e09                	sub	a2,a2,a0
ffffffffc0200046:	4581                	li	a1,0
kern_init(void) {
ffffffffc0200048:	e406                	sd	ra,8(sp)
    memset(edata, 0, end - edata);
ffffffffc020004a:	713030ef          	jal	ra,ffffffffc0203f5c <memset>

    const char *message = "(THU.CST) os is loading ...";
    cprintf("%s\n\n", message);
ffffffffc020004e:	00004597          	auipc	a1,0x4
ffffffffc0200052:	3da58593          	addi	a1,a1,986 # ffffffffc0204428 <etext>
ffffffffc0200056:	00004517          	auipc	a0,0x4
ffffffffc020005a:	3f250513          	addi	a0,a0,1010 # ffffffffc0204448 <etext+0x20>
ffffffffc020005e:	05c000ef          	jal	ra,ffffffffc02000ba <cprintf>

    print_kerninfo();
ffffffffc0200062:	0fc000ef          	jal	ra,ffffffffc020015e <print_kerninfo>

    // grade_backtrace();

    pmm_init();                 // init physical memory management
ffffffffc0200066:	6ab020ef          	jal	ra,ffffffffc0202f10 <pmm_init>

    idt_init();                 // init interrupt descriptor table
ffffffffc020006a:	4fa000ef          	jal	ra,ffffffffc0200564 <idt_init>

    vmm_init();                 // init virtual memory management
ffffffffc020006e:	423000ef          	jal	ra,ffffffffc0200c90 <vmm_init>

    ide_init();                 // init ide devices
ffffffffc0200072:	35e000ef          	jal	ra,ffffffffc02003d0 <ide_init>
    swap_init();                // init swap
ffffffffc0200076:	316010ef          	jal	ra,ffffffffc020138c <swap_init>

    clock_init();               // init clock interrupt
ffffffffc020007a:	3ac000ef          	jal	ra,ffffffffc0200426 <clock_init>
    // intr_enable();              // enable irq interrupt



    /* do nothing */
    while (1);
ffffffffc020007e:	a001                	j	ffffffffc020007e <kern_init+0x4c>

ffffffffc0200080 <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
ffffffffc0200080:	1141                	addi	sp,sp,-16
ffffffffc0200082:	e022                	sd	s0,0(sp)
ffffffffc0200084:	e406                	sd	ra,8(sp)
ffffffffc0200086:	842e                	mv	s0,a1
    cons_putc(c);
ffffffffc0200088:	3f0000ef          	jal	ra,ffffffffc0200478 <cons_putc>
    (*cnt) ++;
ffffffffc020008c:	401c                	lw	a5,0(s0)
}
ffffffffc020008e:	60a2                	ld	ra,8(sp)
    (*cnt) ++;
ffffffffc0200090:	2785                	addiw	a5,a5,1
ffffffffc0200092:	c01c                	sw	a5,0(s0)
}
ffffffffc0200094:	6402                	ld	s0,0(sp)
ffffffffc0200096:	0141                	addi	sp,sp,16
ffffffffc0200098:	8082                	ret

ffffffffc020009a <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
ffffffffc020009a:	1101                	addi	sp,sp,-32
ffffffffc020009c:	862a                	mv	a2,a0
ffffffffc020009e:	86ae                	mv	a3,a1
    int cnt = 0;
    vprintfmt((void*)cputch, &cnt, fmt, ap);
ffffffffc02000a0:	00000517          	auipc	a0,0x0
ffffffffc02000a4:	fe050513          	addi	a0,a0,-32 # ffffffffc0200080 <cputch>
ffffffffc02000a8:	006c                	addi	a1,sp,12
vcprintf(const char *fmt, va_list ap) {
ffffffffc02000aa:	ec06                	sd	ra,24(sp)
    int cnt = 0;
ffffffffc02000ac:	c602                	sw	zero,12(sp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
ffffffffc02000ae:	745030ef          	jal	ra,ffffffffc0203ff2 <vprintfmt>
    return cnt;
}
ffffffffc02000b2:	60e2                	ld	ra,24(sp)
ffffffffc02000b4:	4532                	lw	a0,12(sp)
ffffffffc02000b6:	6105                	addi	sp,sp,32
ffffffffc02000b8:	8082                	ret

ffffffffc02000ba <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
ffffffffc02000ba:	711d                	addi	sp,sp,-96
    va_list ap;
    int cnt;
    va_start(ap, fmt);
ffffffffc02000bc:	02810313          	addi	t1,sp,40 # ffffffffc0209028 <boot_page_table_sv39+0x28>
cprintf(const char *fmt, ...) {
ffffffffc02000c0:	8e2a                	mv	t3,a0
ffffffffc02000c2:	f42e                	sd	a1,40(sp)
ffffffffc02000c4:	f832                	sd	a2,48(sp)
ffffffffc02000c6:	fc36                	sd	a3,56(sp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
ffffffffc02000c8:	00000517          	auipc	a0,0x0
ffffffffc02000cc:	fb850513          	addi	a0,a0,-72 # ffffffffc0200080 <cputch>
ffffffffc02000d0:	004c                	addi	a1,sp,4
ffffffffc02000d2:	869a                	mv	a3,t1
ffffffffc02000d4:	8672                	mv	a2,t3
cprintf(const char *fmt, ...) {
ffffffffc02000d6:	ec06                	sd	ra,24(sp)
ffffffffc02000d8:	e0ba                	sd	a4,64(sp)
ffffffffc02000da:	e4be                	sd	a5,72(sp)
ffffffffc02000dc:	e8c2                	sd	a6,80(sp)
ffffffffc02000de:	ecc6                	sd	a7,88(sp)
    va_start(ap, fmt);
ffffffffc02000e0:	e41a                	sd	t1,8(sp)
    int cnt = 0;
ffffffffc02000e2:	c202                	sw	zero,4(sp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
ffffffffc02000e4:	70f030ef          	jal	ra,ffffffffc0203ff2 <vprintfmt>
    cnt = vcprintf(fmt, ap);
    va_end(ap);
    return cnt;
}
ffffffffc02000e8:	60e2                	ld	ra,24(sp)
ffffffffc02000ea:	4512                	lw	a0,4(sp)
ffffffffc02000ec:	6125                	addi	sp,sp,96
ffffffffc02000ee:	8082                	ret

ffffffffc02000f0 <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
    cons_putc(c);
ffffffffc02000f0:	a661                	j	ffffffffc0200478 <cons_putc>

ffffffffc02000f2 <getchar>:
    return cnt;
}

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
ffffffffc02000f2:	1141                	addi	sp,sp,-16
ffffffffc02000f4:	e406                	sd	ra,8(sp)
    int c;
    while ((c = cons_getc()) == 0)
ffffffffc02000f6:	3b6000ef          	jal	ra,ffffffffc02004ac <cons_getc>
ffffffffc02000fa:	dd75                	beqz	a0,ffffffffc02000f6 <getchar+0x4>
        /* do nothing */;
    return c;
}
ffffffffc02000fc:	60a2                	ld	ra,8(sp)
ffffffffc02000fe:	0141                	addi	sp,sp,16
ffffffffc0200100:	8082                	ret

ffffffffc0200102 <__panic>:
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
    if (is_panic) {
ffffffffc0200102:	00011317          	auipc	t1,0x11
ffffffffc0200106:	3f630313          	addi	t1,t1,1014 # ffffffffc02114f8 <is_panic>
ffffffffc020010a:	00032e03          	lw	t3,0(t1)
__panic(const char *file, int line, const char *fmt, ...) {
ffffffffc020010e:	715d                	addi	sp,sp,-80
ffffffffc0200110:	ec06                	sd	ra,24(sp)
ffffffffc0200112:	e822                	sd	s0,16(sp)
ffffffffc0200114:	f436                	sd	a3,40(sp)
ffffffffc0200116:	f83a                	sd	a4,48(sp)
ffffffffc0200118:	fc3e                	sd	a5,56(sp)
ffffffffc020011a:	e0c2                	sd	a6,64(sp)
ffffffffc020011c:	e4c6                	sd	a7,72(sp)
    if (is_panic) {
ffffffffc020011e:	020e1a63          	bnez	t3,ffffffffc0200152 <__panic+0x50>
        goto panic_dead;
    }
    is_panic = 1;
ffffffffc0200122:	4785                	li	a5,1
ffffffffc0200124:	00f32023          	sw	a5,0(t1)

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
ffffffffc0200128:	8432                	mv	s0,a2
ffffffffc020012a:	103c                	addi	a5,sp,40
    cprintf("kernel panic at %s:%d:\n    ", file, line);
ffffffffc020012c:	862e                	mv	a2,a1
ffffffffc020012e:	85aa                	mv	a1,a0
ffffffffc0200130:	00004517          	auipc	a0,0x4
ffffffffc0200134:	32050513          	addi	a0,a0,800 # ffffffffc0204450 <etext+0x28>
    va_start(ap, fmt);
ffffffffc0200138:	e43e                	sd	a5,8(sp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
ffffffffc020013a:	f81ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    vcprintf(fmt, ap);
ffffffffc020013e:	65a2                	ld	a1,8(sp)
ffffffffc0200140:	8522                	mv	a0,s0
ffffffffc0200142:	f59ff0ef          	jal	ra,ffffffffc020009a <vcprintf>
    cprintf("\n");
ffffffffc0200146:	00006517          	auipc	a0,0x6
ffffffffc020014a:	c5250513          	addi	a0,a0,-942 # ffffffffc0205d98 <default_pmm_manager+0x500>
ffffffffc020014e:	f6dff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    va_end(ap);

panic_dead:
    intr_disable();
ffffffffc0200152:	39c000ef          	jal	ra,ffffffffc02004ee <intr_disable>
    while (1) {
        kmonitor(NULL);
ffffffffc0200156:	4501                	li	a0,0
ffffffffc0200158:	130000ef          	jal	ra,ffffffffc0200288 <kmonitor>
    while (1) {
ffffffffc020015c:	bfed                	j	ffffffffc0200156 <__panic+0x54>

ffffffffc020015e <print_kerninfo>:
/* *
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void print_kerninfo(void) {
ffffffffc020015e:	1141                	addi	sp,sp,-16
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
ffffffffc0200160:	00004517          	auipc	a0,0x4
ffffffffc0200164:	31050513          	addi	a0,a0,784 # ffffffffc0204470 <etext+0x48>
void print_kerninfo(void) {
ffffffffc0200168:	e406                	sd	ra,8(sp)
    cprintf("Special kernel symbols:\n");
ffffffffc020016a:	f51ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("  entry  0x%08x (virtual)\n", kern_init);
ffffffffc020016e:	00000597          	auipc	a1,0x0
ffffffffc0200172:	ec458593          	addi	a1,a1,-316 # ffffffffc0200032 <kern_init>
ffffffffc0200176:	00004517          	auipc	a0,0x4
ffffffffc020017a:	31a50513          	addi	a0,a0,794 # ffffffffc0204490 <etext+0x68>
ffffffffc020017e:	f3dff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("  etext  0x%08x (virtual)\n", etext);
ffffffffc0200182:	00004597          	auipc	a1,0x4
ffffffffc0200186:	2a658593          	addi	a1,a1,678 # ffffffffc0204428 <etext>
ffffffffc020018a:	00004517          	auipc	a0,0x4
ffffffffc020018e:	32650513          	addi	a0,a0,806 # ffffffffc02044b0 <etext+0x88>
ffffffffc0200192:	f29ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("  edata  0x%08x (virtual)\n", edata);
ffffffffc0200196:	0000a597          	auipc	a1,0xa
ffffffffc020019a:	eaa58593          	addi	a1,a1,-342 # ffffffffc020a040 <ide>
ffffffffc020019e:	00004517          	auipc	a0,0x4
ffffffffc02001a2:	33250513          	addi	a0,a0,818 # ffffffffc02044d0 <etext+0xa8>
ffffffffc02001a6:	f15ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("  end    0x%08x (virtual)\n", end);
ffffffffc02001aa:	00011597          	auipc	a1,0x11
ffffffffc02001ae:	3c658593          	addi	a1,a1,966 # ffffffffc0211570 <end>
ffffffffc02001b2:	00004517          	auipc	a0,0x4
ffffffffc02001b6:	33e50513          	addi	a0,a0,830 # ffffffffc02044f0 <etext+0xc8>
ffffffffc02001ba:	f01ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n",
            (end - kern_init + 1023) / 1024);
ffffffffc02001be:	00011597          	auipc	a1,0x11
ffffffffc02001c2:	7b158593          	addi	a1,a1,1969 # ffffffffc021196f <end+0x3ff>
ffffffffc02001c6:	00000797          	auipc	a5,0x0
ffffffffc02001ca:	e6c78793          	addi	a5,a5,-404 # ffffffffc0200032 <kern_init>
ffffffffc02001ce:	40f587b3          	sub	a5,a1,a5
    cprintf("Kernel executable memory footprint: %dKB\n",
ffffffffc02001d2:	43f7d593          	srai	a1,a5,0x3f
}
ffffffffc02001d6:	60a2                	ld	ra,8(sp)
    cprintf("Kernel executable memory footprint: %dKB\n",
ffffffffc02001d8:	3ff5f593          	andi	a1,a1,1023
ffffffffc02001dc:	95be                	add	a1,a1,a5
ffffffffc02001de:	85a9                	srai	a1,a1,0xa
ffffffffc02001e0:	00004517          	auipc	a0,0x4
ffffffffc02001e4:	33050513          	addi	a0,a0,816 # ffffffffc0204510 <etext+0xe8>
}
ffffffffc02001e8:	0141                	addi	sp,sp,16
    cprintf("Kernel executable memory footprint: %dKB\n",
ffffffffc02001ea:	bdc1                	j	ffffffffc02000ba <cprintf>

ffffffffc02001ec <print_stackframe>:
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before
 * jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the
 * boundary.
 * */
void print_stackframe(void) {
ffffffffc02001ec:	1141                	addi	sp,sp,-16

    panic("Not Implemented!");
ffffffffc02001ee:	00004617          	auipc	a2,0x4
ffffffffc02001f2:	35260613          	addi	a2,a2,850 # ffffffffc0204540 <etext+0x118>
ffffffffc02001f6:	04e00593          	li	a1,78
ffffffffc02001fa:	00004517          	auipc	a0,0x4
ffffffffc02001fe:	35e50513          	addi	a0,a0,862 # ffffffffc0204558 <etext+0x130>
void print_stackframe(void) {
ffffffffc0200202:	e406                	sd	ra,8(sp)
    panic("Not Implemented!");
ffffffffc0200204:	effff0ef          	jal	ra,ffffffffc0200102 <__panic>

ffffffffc0200208 <mon_help>:
    }
}

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
ffffffffc0200208:	1141                	addi	sp,sp,-16
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
ffffffffc020020a:	00004617          	auipc	a2,0x4
ffffffffc020020e:	36660613          	addi	a2,a2,870 # ffffffffc0204570 <etext+0x148>
ffffffffc0200212:	00004597          	auipc	a1,0x4
ffffffffc0200216:	37e58593          	addi	a1,a1,894 # ffffffffc0204590 <etext+0x168>
ffffffffc020021a:	00004517          	auipc	a0,0x4
ffffffffc020021e:	37e50513          	addi	a0,a0,894 # ffffffffc0204598 <etext+0x170>
mon_help(int argc, char **argv, struct trapframe *tf) {
ffffffffc0200222:	e406                	sd	ra,8(sp)
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
ffffffffc0200224:	e97ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc0200228:	00004617          	auipc	a2,0x4
ffffffffc020022c:	38060613          	addi	a2,a2,896 # ffffffffc02045a8 <etext+0x180>
ffffffffc0200230:	00004597          	auipc	a1,0x4
ffffffffc0200234:	3a058593          	addi	a1,a1,928 # ffffffffc02045d0 <etext+0x1a8>
ffffffffc0200238:	00004517          	auipc	a0,0x4
ffffffffc020023c:	36050513          	addi	a0,a0,864 # ffffffffc0204598 <etext+0x170>
ffffffffc0200240:	e7bff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc0200244:	00004617          	auipc	a2,0x4
ffffffffc0200248:	39c60613          	addi	a2,a2,924 # ffffffffc02045e0 <etext+0x1b8>
ffffffffc020024c:	00004597          	auipc	a1,0x4
ffffffffc0200250:	3b458593          	addi	a1,a1,948 # ffffffffc0204600 <etext+0x1d8>
ffffffffc0200254:	00004517          	auipc	a0,0x4
ffffffffc0200258:	34450513          	addi	a0,a0,836 # ffffffffc0204598 <etext+0x170>
ffffffffc020025c:	e5fff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    }
    return 0;
}
ffffffffc0200260:	60a2                	ld	ra,8(sp)
ffffffffc0200262:	4501                	li	a0,0
ffffffffc0200264:	0141                	addi	sp,sp,16
ffffffffc0200266:	8082                	ret

ffffffffc0200268 <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
ffffffffc0200268:	1141                	addi	sp,sp,-16
ffffffffc020026a:	e406                	sd	ra,8(sp)
    print_kerninfo();
ffffffffc020026c:	ef3ff0ef          	jal	ra,ffffffffc020015e <print_kerninfo>
    return 0;
}
ffffffffc0200270:	60a2                	ld	ra,8(sp)
ffffffffc0200272:	4501                	li	a0,0
ffffffffc0200274:	0141                	addi	sp,sp,16
ffffffffc0200276:	8082                	ret

ffffffffc0200278 <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
ffffffffc0200278:	1141                	addi	sp,sp,-16
ffffffffc020027a:	e406                	sd	ra,8(sp)
    print_stackframe();
ffffffffc020027c:	f71ff0ef          	jal	ra,ffffffffc02001ec <print_stackframe>
    return 0;
}
ffffffffc0200280:	60a2                	ld	ra,8(sp)
ffffffffc0200282:	4501                	li	a0,0
ffffffffc0200284:	0141                	addi	sp,sp,16
ffffffffc0200286:	8082                	ret

ffffffffc0200288 <kmonitor>:
kmonitor(struct trapframe *tf) {
ffffffffc0200288:	7115                	addi	sp,sp,-224
ffffffffc020028a:	ed5e                	sd	s7,152(sp)
ffffffffc020028c:	8baa                	mv	s7,a0
    cprintf("Welcome to the kernel debug monitor!!\n");
ffffffffc020028e:	00004517          	auipc	a0,0x4
ffffffffc0200292:	38250513          	addi	a0,a0,898 # ffffffffc0204610 <etext+0x1e8>
kmonitor(struct trapframe *tf) {
ffffffffc0200296:	ed86                	sd	ra,216(sp)
ffffffffc0200298:	e9a2                	sd	s0,208(sp)
ffffffffc020029a:	e5a6                	sd	s1,200(sp)
ffffffffc020029c:	e1ca                	sd	s2,192(sp)
ffffffffc020029e:	fd4e                	sd	s3,184(sp)
ffffffffc02002a0:	f952                	sd	s4,176(sp)
ffffffffc02002a2:	f556                	sd	s5,168(sp)
ffffffffc02002a4:	f15a                	sd	s6,160(sp)
ffffffffc02002a6:	e962                	sd	s8,144(sp)
ffffffffc02002a8:	e566                	sd	s9,136(sp)
ffffffffc02002aa:	e16a                	sd	s10,128(sp)
    cprintf("Welcome to the kernel debug monitor!!\n");
ffffffffc02002ac:	e0fff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
ffffffffc02002b0:	00004517          	auipc	a0,0x4
ffffffffc02002b4:	38850513          	addi	a0,a0,904 # ffffffffc0204638 <etext+0x210>
ffffffffc02002b8:	e03ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    if (tf != NULL) {
ffffffffc02002bc:	000b8563          	beqz	s7,ffffffffc02002c6 <kmonitor+0x3e>
        print_trapframe(tf);
ffffffffc02002c0:	855e                	mv	a0,s7
ffffffffc02002c2:	48c000ef          	jal	ra,ffffffffc020074e <print_trapframe>
ffffffffc02002c6:	00004c17          	auipc	s8,0x4
ffffffffc02002ca:	3dac0c13          	addi	s8,s8,986 # ffffffffc02046a0 <commands>
        if ((buf = readline("")) != NULL) {
ffffffffc02002ce:	00005917          	auipc	s2,0x5
ffffffffc02002d2:	16a90913          	addi	s2,s2,362 # ffffffffc0205438 <commands+0xd98>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
ffffffffc02002d6:	00004497          	auipc	s1,0x4
ffffffffc02002da:	38a48493          	addi	s1,s1,906 # ffffffffc0204660 <etext+0x238>
        if (argc == MAXARGS - 1) {
ffffffffc02002de:	49bd                	li	s3,15
            cprintf("Too many arguments (max %d).\n", MAXARGS);
ffffffffc02002e0:	00004b17          	auipc	s6,0x4
ffffffffc02002e4:	388b0b13          	addi	s6,s6,904 # ffffffffc0204668 <etext+0x240>
        argv[argc ++] = buf;
ffffffffc02002e8:	00004a17          	auipc	s4,0x4
ffffffffc02002ec:	2a8a0a13          	addi	s4,s4,680 # ffffffffc0204590 <etext+0x168>
    for (i = 0; i < NCOMMANDS; i ++) {
ffffffffc02002f0:	4a8d                	li	s5,3
        if ((buf = readline("")) != NULL) {
ffffffffc02002f2:	854a                	mv	a0,s2
ffffffffc02002f4:	080040ef          	jal	ra,ffffffffc0204374 <readline>
ffffffffc02002f8:	842a                	mv	s0,a0
ffffffffc02002fa:	dd65                	beqz	a0,ffffffffc02002f2 <kmonitor+0x6a>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
ffffffffc02002fc:	00054583          	lbu	a1,0(a0)
    int argc = 0;
ffffffffc0200300:	4c81                	li	s9,0
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
ffffffffc0200302:	e1bd                	bnez	a1,ffffffffc0200368 <kmonitor+0xe0>
    if (argc == 0) {
ffffffffc0200304:	fe0c87e3          	beqz	s9,ffffffffc02002f2 <kmonitor+0x6a>
        if (strcmp(commands[i].name, argv[0]) == 0) {
ffffffffc0200308:	6582                	ld	a1,0(sp)
ffffffffc020030a:	00004d17          	auipc	s10,0x4
ffffffffc020030e:	396d0d13          	addi	s10,s10,918 # ffffffffc02046a0 <commands>
        argv[argc ++] = buf;
ffffffffc0200312:	8552                	mv	a0,s4
    for (i = 0; i < NCOMMANDS; i ++) {
ffffffffc0200314:	4401                	li	s0,0
ffffffffc0200316:	0d61                	addi	s10,s10,24
        if (strcmp(commands[i].name, argv[0]) == 0) {
ffffffffc0200318:	411030ef          	jal	ra,ffffffffc0203f28 <strcmp>
ffffffffc020031c:	c919                	beqz	a0,ffffffffc0200332 <kmonitor+0xaa>
    for (i = 0; i < NCOMMANDS; i ++) {
ffffffffc020031e:	2405                	addiw	s0,s0,1
ffffffffc0200320:	0b540063          	beq	s0,s5,ffffffffc02003c0 <kmonitor+0x138>
        if (strcmp(commands[i].name, argv[0]) == 0) {
ffffffffc0200324:	000d3503          	ld	a0,0(s10)
ffffffffc0200328:	6582                	ld	a1,0(sp)
    for (i = 0; i < NCOMMANDS; i ++) {
ffffffffc020032a:	0d61                	addi	s10,s10,24
        if (strcmp(commands[i].name, argv[0]) == 0) {
ffffffffc020032c:	3fd030ef          	jal	ra,ffffffffc0203f28 <strcmp>
ffffffffc0200330:	f57d                	bnez	a0,ffffffffc020031e <kmonitor+0x96>
            return commands[i].func(argc - 1, argv + 1, tf);
ffffffffc0200332:	00141793          	slli	a5,s0,0x1
ffffffffc0200336:	97a2                	add	a5,a5,s0
ffffffffc0200338:	078e                	slli	a5,a5,0x3
ffffffffc020033a:	97e2                	add	a5,a5,s8
ffffffffc020033c:	6b9c                	ld	a5,16(a5)
ffffffffc020033e:	865e                	mv	a2,s7
ffffffffc0200340:	002c                	addi	a1,sp,8
ffffffffc0200342:	fffc851b          	addiw	a0,s9,-1
ffffffffc0200346:	9782                	jalr	a5
            if (runcmd(buf, tf) < 0) {
ffffffffc0200348:	fa0555e3          	bgez	a0,ffffffffc02002f2 <kmonitor+0x6a>
}
ffffffffc020034c:	60ee                	ld	ra,216(sp)
ffffffffc020034e:	644e                	ld	s0,208(sp)
ffffffffc0200350:	64ae                	ld	s1,200(sp)
ffffffffc0200352:	690e                	ld	s2,192(sp)
ffffffffc0200354:	79ea                	ld	s3,184(sp)
ffffffffc0200356:	7a4a                	ld	s4,176(sp)
ffffffffc0200358:	7aaa                	ld	s5,168(sp)
ffffffffc020035a:	7b0a                	ld	s6,160(sp)
ffffffffc020035c:	6bea                	ld	s7,152(sp)
ffffffffc020035e:	6c4a                	ld	s8,144(sp)
ffffffffc0200360:	6caa                	ld	s9,136(sp)
ffffffffc0200362:	6d0a                	ld	s10,128(sp)
ffffffffc0200364:	612d                	addi	sp,sp,224
ffffffffc0200366:	8082                	ret
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
ffffffffc0200368:	8526                	mv	a0,s1
ffffffffc020036a:	3dd030ef          	jal	ra,ffffffffc0203f46 <strchr>
ffffffffc020036e:	c901                	beqz	a0,ffffffffc020037e <kmonitor+0xf6>
ffffffffc0200370:	00144583          	lbu	a1,1(s0)
            *buf ++ = '\0';
ffffffffc0200374:	00040023          	sb	zero,0(s0)
ffffffffc0200378:	0405                	addi	s0,s0,1
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
ffffffffc020037a:	d5c9                	beqz	a1,ffffffffc0200304 <kmonitor+0x7c>
ffffffffc020037c:	b7f5                	j	ffffffffc0200368 <kmonitor+0xe0>
        if (*buf == '\0') {
ffffffffc020037e:	00044783          	lbu	a5,0(s0)
ffffffffc0200382:	d3c9                	beqz	a5,ffffffffc0200304 <kmonitor+0x7c>
        if (argc == MAXARGS - 1) {
ffffffffc0200384:	033c8963          	beq	s9,s3,ffffffffc02003b6 <kmonitor+0x12e>
        argv[argc ++] = buf;
ffffffffc0200388:	003c9793          	slli	a5,s9,0x3
ffffffffc020038c:	0118                	addi	a4,sp,128
ffffffffc020038e:	97ba                	add	a5,a5,a4
ffffffffc0200390:	f887b023          	sd	s0,-128(a5)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
ffffffffc0200394:	00044583          	lbu	a1,0(s0)
        argv[argc ++] = buf;
ffffffffc0200398:	2c85                	addiw	s9,s9,1
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
ffffffffc020039a:	e591                	bnez	a1,ffffffffc02003a6 <kmonitor+0x11e>
ffffffffc020039c:	b7b5                	j	ffffffffc0200308 <kmonitor+0x80>
ffffffffc020039e:	00144583          	lbu	a1,1(s0)
            buf ++;
ffffffffc02003a2:	0405                	addi	s0,s0,1
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
ffffffffc02003a4:	d1a5                	beqz	a1,ffffffffc0200304 <kmonitor+0x7c>
ffffffffc02003a6:	8526                	mv	a0,s1
ffffffffc02003a8:	39f030ef          	jal	ra,ffffffffc0203f46 <strchr>
ffffffffc02003ac:	d96d                	beqz	a0,ffffffffc020039e <kmonitor+0x116>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
ffffffffc02003ae:	00044583          	lbu	a1,0(s0)
ffffffffc02003b2:	d9a9                	beqz	a1,ffffffffc0200304 <kmonitor+0x7c>
ffffffffc02003b4:	bf55                	j	ffffffffc0200368 <kmonitor+0xe0>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
ffffffffc02003b6:	45c1                	li	a1,16
ffffffffc02003b8:	855a                	mv	a0,s6
ffffffffc02003ba:	d01ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc02003be:	b7e9                	j	ffffffffc0200388 <kmonitor+0x100>
    cprintf("Unknown command '%s'\n", argv[0]);
ffffffffc02003c0:	6582                	ld	a1,0(sp)
ffffffffc02003c2:	00004517          	auipc	a0,0x4
ffffffffc02003c6:	2c650513          	addi	a0,a0,710 # ffffffffc0204688 <etext+0x260>
ffffffffc02003ca:	cf1ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    return 0;
ffffffffc02003ce:	b715                	j	ffffffffc02002f2 <kmonitor+0x6a>

ffffffffc02003d0 <ide_init>:
#include <stdio.h>
#include <string.h>
#include <trap.h>
#include <riscv.h>

void ide_init(void) {}
ffffffffc02003d0:	8082                	ret

ffffffffc02003d2 <ide_device_valid>:

#define MAX_IDE 2
#define MAX_DISK_NSECS 56
static char ide[MAX_DISK_NSECS * SECTSIZE];

bool ide_device_valid(unsigned short ideno) { return ideno < MAX_IDE; }
ffffffffc02003d2:	00253513          	sltiu	a0,a0,2
ffffffffc02003d6:	8082                	ret

ffffffffc02003d8 <ide_device_size>:

size_t ide_device_size(unsigned short ideno) { return MAX_DISK_NSECS; }
ffffffffc02003d8:	03800513          	li	a0,56
ffffffffc02003dc:	8082                	ret

ffffffffc02003de <ide_read_secs>:

int ide_read_secs(unsigned short ideno, uint32_t secno, void *dst,
                  size_t nsecs) {
    int iobase = secno * SECTSIZE;
    memcpy(dst, &ide[iobase], nsecs * SECTSIZE);
ffffffffc02003de:	0000a797          	auipc	a5,0xa
ffffffffc02003e2:	c6278793          	addi	a5,a5,-926 # ffffffffc020a040 <ide>
    int iobase = secno * SECTSIZE;
ffffffffc02003e6:	0095959b          	slliw	a1,a1,0x9
                  size_t nsecs) {
ffffffffc02003ea:	1141                	addi	sp,sp,-16
ffffffffc02003ec:	8532                	mv	a0,a2
    memcpy(dst, &ide[iobase], nsecs * SECTSIZE);
ffffffffc02003ee:	95be                	add	a1,a1,a5
ffffffffc02003f0:	00969613          	slli	a2,a3,0x9
                  size_t nsecs) {
ffffffffc02003f4:	e406                	sd	ra,8(sp)
    memcpy(dst, &ide[iobase], nsecs * SECTSIZE);
ffffffffc02003f6:	379030ef          	jal	ra,ffffffffc0203f6e <memcpy>
    return 0;
}
ffffffffc02003fa:	60a2                	ld	ra,8(sp)
ffffffffc02003fc:	4501                	li	a0,0
ffffffffc02003fe:	0141                	addi	sp,sp,16
ffffffffc0200400:	8082                	ret

ffffffffc0200402 <ide_write_secs>:

int ide_write_secs(unsigned short ideno, uint32_t secno, const void *src,
                   size_t nsecs) {
    int iobase = secno * SECTSIZE;
ffffffffc0200402:	0095979b          	slliw	a5,a1,0x9
    memcpy(&ide[iobase], src, nsecs * SECTSIZE);
ffffffffc0200406:	0000a517          	auipc	a0,0xa
ffffffffc020040a:	c3a50513          	addi	a0,a0,-966 # ffffffffc020a040 <ide>
                   size_t nsecs) {
ffffffffc020040e:	1141                	addi	sp,sp,-16
ffffffffc0200410:	85b2                	mv	a1,a2
    memcpy(&ide[iobase], src, nsecs * SECTSIZE);
ffffffffc0200412:	953e                	add	a0,a0,a5
ffffffffc0200414:	00969613          	slli	a2,a3,0x9
                   size_t nsecs) {
ffffffffc0200418:	e406                	sd	ra,8(sp)
    memcpy(&ide[iobase], src, nsecs * SECTSIZE);
ffffffffc020041a:	355030ef          	jal	ra,ffffffffc0203f6e <memcpy>
    return 0;
}
ffffffffc020041e:	60a2                	ld	ra,8(sp)
ffffffffc0200420:	4501                	li	a0,0
ffffffffc0200422:	0141                	addi	sp,sp,16
ffffffffc0200424:	8082                	ret

ffffffffc0200426 <clock_init>:
 * and then enable IRQ_TIMER.
 * */
void clock_init(void) {
    // divided by 500 when using Spike(2MHz)
    // divided by 100 when using QEMU(10MHz)
    timebase = 1e7 / 100;
ffffffffc0200426:	67e1                	lui	a5,0x18
ffffffffc0200428:	6a078793          	addi	a5,a5,1696 # 186a0 <kern_entry-0xffffffffc01e7960>
ffffffffc020042c:	00011717          	auipc	a4,0x11
ffffffffc0200430:	0cf73e23          	sd	a5,220(a4) # ffffffffc0211508 <timebase>
    __asm__ __volatile__("rdtime %0" : "=r"(n));
ffffffffc0200434:	c0102573          	rdtime	a0
static inline void sbi_set_timer(uint64_t stime_value)
{
#if __riscv_xlen == 32
	SBI_CALL_2(SBI_SET_TIMER, stime_value, stime_value >> 32);
#else
	SBI_CALL_1(SBI_SET_TIMER, stime_value);
ffffffffc0200438:	4581                	li	a1,0
    ticks = 0;

    cprintf("++ setup timer interrupts\n");
}

void clock_set_next_event(void) { sbi_set_timer(get_cycles() + timebase); }
ffffffffc020043a:	953e                	add	a0,a0,a5
ffffffffc020043c:	4601                	li	a2,0
ffffffffc020043e:	4881                	li	a7,0
ffffffffc0200440:	00000073          	ecall
    set_csr(sie, MIP_STIP);
ffffffffc0200444:	02000793          	li	a5,32
ffffffffc0200448:	1047a7f3          	csrrs	a5,sie,a5
    cprintf("++ setup timer interrupts\n");
ffffffffc020044c:	00004517          	auipc	a0,0x4
ffffffffc0200450:	29c50513          	addi	a0,a0,668 # ffffffffc02046e8 <commands+0x48>
    ticks = 0;
ffffffffc0200454:	00011797          	auipc	a5,0x11
ffffffffc0200458:	0a07b623          	sd	zero,172(a5) # ffffffffc0211500 <ticks>
    cprintf("++ setup timer interrupts\n");
ffffffffc020045c:	b9b9                	j	ffffffffc02000ba <cprintf>

ffffffffc020045e <clock_set_next_event>:
    __asm__ __volatile__("rdtime %0" : "=r"(n));
ffffffffc020045e:	c0102573          	rdtime	a0
void clock_set_next_event(void) { sbi_set_timer(get_cycles() + timebase); }
ffffffffc0200462:	00011797          	auipc	a5,0x11
ffffffffc0200466:	0a67b783          	ld	a5,166(a5) # ffffffffc0211508 <timebase>
ffffffffc020046a:	953e                	add	a0,a0,a5
ffffffffc020046c:	4581                	li	a1,0
ffffffffc020046e:	4601                	li	a2,0
ffffffffc0200470:	4881                	li	a7,0
ffffffffc0200472:	00000073          	ecall
ffffffffc0200476:	8082                	ret

ffffffffc0200478 <cons_putc>:
#include <intr.h>
#include <mmu.h>
#include <riscv.h>

static inline bool __intr_save(void) {
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0200478:	100027f3          	csrr	a5,sstatus
ffffffffc020047c:	8b89                	andi	a5,a5,2
	SBI_CALL_1(SBI_CONSOLE_PUTCHAR, ch);
ffffffffc020047e:	0ff57513          	zext.b	a0,a0
ffffffffc0200482:	e799                	bnez	a5,ffffffffc0200490 <cons_putc+0x18>
ffffffffc0200484:	4581                	li	a1,0
ffffffffc0200486:	4601                	li	a2,0
ffffffffc0200488:	4885                	li	a7,1
ffffffffc020048a:	00000073          	ecall
    }
    return 0;
}

static inline void __intr_restore(bool flag) {
    if (flag) {
ffffffffc020048e:	8082                	ret

/* cons_init - initializes the console devices */
void cons_init(void) {}

/* cons_putc - print a single character @c to console devices */
void cons_putc(int c) {
ffffffffc0200490:	1101                	addi	sp,sp,-32
ffffffffc0200492:	ec06                	sd	ra,24(sp)
ffffffffc0200494:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc0200496:	058000ef          	jal	ra,ffffffffc02004ee <intr_disable>
ffffffffc020049a:	6522                	ld	a0,8(sp)
ffffffffc020049c:	4581                	li	a1,0
ffffffffc020049e:	4601                	li	a2,0
ffffffffc02004a0:	4885                	li	a7,1
ffffffffc02004a2:	00000073          	ecall
    local_intr_save(intr_flag);
    {
        sbi_console_putchar((unsigned char)c);
    }
    local_intr_restore(intr_flag);
}
ffffffffc02004a6:	60e2                	ld	ra,24(sp)
ffffffffc02004a8:	6105                	addi	sp,sp,32
        intr_enable();
ffffffffc02004aa:	a83d                	j	ffffffffc02004e8 <intr_enable>

ffffffffc02004ac <cons_getc>:
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc02004ac:	100027f3          	csrr	a5,sstatus
ffffffffc02004b0:	8b89                	andi	a5,a5,2
ffffffffc02004b2:	eb89                	bnez	a5,ffffffffc02004c4 <cons_getc+0x18>
	return SBI_CALL_0(SBI_CONSOLE_GETCHAR);
ffffffffc02004b4:	4501                	li	a0,0
ffffffffc02004b6:	4581                	li	a1,0
ffffffffc02004b8:	4601                	li	a2,0
ffffffffc02004ba:	4889                	li	a7,2
ffffffffc02004bc:	00000073          	ecall
ffffffffc02004c0:	2501                	sext.w	a0,a0
    {
        c = sbi_console_getchar();
    }
    local_intr_restore(intr_flag);
    return c;
}
ffffffffc02004c2:	8082                	ret
int cons_getc(void) {
ffffffffc02004c4:	1101                	addi	sp,sp,-32
ffffffffc02004c6:	ec06                	sd	ra,24(sp)
        intr_disable();
ffffffffc02004c8:	026000ef          	jal	ra,ffffffffc02004ee <intr_disable>
ffffffffc02004cc:	4501                	li	a0,0
ffffffffc02004ce:	4581                	li	a1,0
ffffffffc02004d0:	4601                	li	a2,0
ffffffffc02004d2:	4889                	li	a7,2
ffffffffc02004d4:	00000073          	ecall
ffffffffc02004d8:	2501                	sext.w	a0,a0
ffffffffc02004da:	e42a                	sd	a0,8(sp)
        intr_enable();
ffffffffc02004dc:	00c000ef          	jal	ra,ffffffffc02004e8 <intr_enable>
}
ffffffffc02004e0:	60e2                	ld	ra,24(sp)
ffffffffc02004e2:	6522                	ld	a0,8(sp)
ffffffffc02004e4:	6105                	addi	sp,sp,32
ffffffffc02004e6:	8082                	ret

ffffffffc02004e8 <intr_enable>:
#include <intr.h>
#include <riscv.h>

/* intr_enable - enable irq interrupt */
void intr_enable(void) { set_csr(sstatus, SSTATUS_SIE); }
ffffffffc02004e8:	100167f3          	csrrsi	a5,sstatus,2
ffffffffc02004ec:	8082                	ret

ffffffffc02004ee <intr_disable>:

/* intr_disable - disable irq interrupt */
void intr_disable(void) { clear_csr(sstatus, SSTATUS_SIE); }
ffffffffc02004ee:	100177f3          	csrrci	a5,sstatus,2
ffffffffc02004f2:	8082                	ret

ffffffffc02004f4 <pgfault_handler>:
    set_csr(sstatus, SSTATUS_SUM);
}

/* trap_in_kernel - test if trap happened in kernel */
bool trap_in_kernel(struct trapframe *tf) {
    return (tf->status & SSTATUS_SPP) != 0;
ffffffffc02004f4:	10053783          	ld	a5,256(a0)
    cprintf("page fault at 0x%08x: %c/%c\n", tf->badvaddr,
            trap_in_kernel(tf) ? 'K' : 'U',
            tf->cause == CAUSE_STORE_PAGE_FAULT ? 'W' : 'R');
}

static int pgfault_handler(struct trapframe *tf) {
ffffffffc02004f8:	1141                	addi	sp,sp,-16
ffffffffc02004fa:	e022                	sd	s0,0(sp)
ffffffffc02004fc:	e406                	sd	ra,8(sp)
    return (tf->status & SSTATUS_SPP) != 0;
ffffffffc02004fe:	1007f793          	andi	a5,a5,256
    cprintf("page fault at 0x%08x: %c/%c\n", tf->badvaddr,
ffffffffc0200502:	11053583          	ld	a1,272(a0)
static int pgfault_handler(struct trapframe *tf) {
ffffffffc0200506:	842a                	mv	s0,a0
    cprintf("page fault at 0x%08x: %c/%c\n", tf->badvaddr,
ffffffffc0200508:	05500613          	li	a2,85
ffffffffc020050c:	c399                	beqz	a5,ffffffffc0200512 <pgfault_handler+0x1e>
ffffffffc020050e:	04b00613          	li	a2,75
ffffffffc0200512:	11843703          	ld	a4,280(s0)
ffffffffc0200516:	47bd                	li	a5,15
ffffffffc0200518:	05700693          	li	a3,87
ffffffffc020051c:	00f70463          	beq	a4,a5,ffffffffc0200524 <pgfault_handler+0x30>
ffffffffc0200520:	05200693          	li	a3,82
ffffffffc0200524:	00004517          	auipc	a0,0x4
ffffffffc0200528:	1e450513          	addi	a0,a0,484 # ffffffffc0204708 <commands+0x68>
ffffffffc020052c:	b8fff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    extern struct mm_struct *check_mm_struct;
    print_pgfault(tf);
    if (check_mm_struct != NULL) {
ffffffffc0200530:	00011517          	auipc	a0,0x11
ffffffffc0200534:	fe053503          	ld	a0,-32(a0) # ffffffffc0211510 <check_mm_struct>
ffffffffc0200538:	c911                	beqz	a0,ffffffffc020054c <pgfault_handler+0x58>
        return do_pgfault(check_mm_struct, tf->cause, tf->badvaddr);
ffffffffc020053a:	11043603          	ld	a2,272(s0)
ffffffffc020053e:	11843583          	ld	a1,280(s0)
    }
    panic("unhandled page fault.\n");
}
ffffffffc0200542:	6402                	ld	s0,0(sp)
ffffffffc0200544:	60a2                	ld	ra,8(sp)
ffffffffc0200546:	0141                	addi	sp,sp,16
        return do_pgfault(check_mm_struct, tf->cause, tf->badvaddr);
ffffffffc0200548:	5210006f          	j	ffffffffc0201268 <do_pgfault>
    panic("unhandled page fault.\n");
ffffffffc020054c:	00004617          	auipc	a2,0x4
ffffffffc0200550:	1dc60613          	addi	a2,a2,476 # ffffffffc0204728 <commands+0x88>
ffffffffc0200554:	07800593          	li	a1,120
ffffffffc0200558:	00004517          	auipc	a0,0x4
ffffffffc020055c:	1e850513          	addi	a0,a0,488 # ffffffffc0204740 <commands+0xa0>
ffffffffc0200560:	ba3ff0ef          	jal	ra,ffffffffc0200102 <__panic>

ffffffffc0200564 <idt_init>:
    write_csr(sscratch, 0);
ffffffffc0200564:	14005073          	csrwi	sscratch,0
    write_csr(stvec, &__alltraps);
ffffffffc0200568:	00000797          	auipc	a5,0x0
ffffffffc020056c:	48878793          	addi	a5,a5,1160 # ffffffffc02009f0 <__alltraps>
ffffffffc0200570:	10579073          	csrw	stvec,a5
    set_csr(sstatus, SSTATUS_SIE);
ffffffffc0200574:	100167f3          	csrrsi	a5,sstatus,2
    set_csr(sstatus, SSTATUS_SUM);
ffffffffc0200578:	000407b7          	lui	a5,0x40
ffffffffc020057c:	1007a7f3          	csrrs	a5,sstatus,a5
}
ffffffffc0200580:	8082                	ret

ffffffffc0200582 <print_regs>:
    cprintf("  zero     0x%08x\n", gpr->zero);
ffffffffc0200582:	610c                	ld	a1,0(a0)
void print_regs(struct pushregs *gpr) {
ffffffffc0200584:	1141                	addi	sp,sp,-16
ffffffffc0200586:	e022                	sd	s0,0(sp)
ffffffffc0200588:	842a                	mv	s0,a0
    cprintf("  zero     0x%08x\n", gpr->zero);
ffffffffc020058a:	00004517          	auipc	a0,0x4
ffffffffc020058e:	1ce50513          	addi	a0,a0,462 # ffffffffc0204758 <commands+0xb8>
void print_regs(struct pushregs *gpr) {
ffffffffc0200592:	e406                	sd	ra,8(sp)
    cprintf("  zero     0x%08x\n", gpr->zero);
ffffffffc0200594:	b27ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("  ra       0x%08x\n", gpr->ra);
ffffffffc0200598:	640c                	ld	a1,8(s0)
ffffffffc020059a:	00004517          	auipc	a0,0x4
ffffffffc020059e:	1d650513          	addi	a0,a0,470 # ffffffffc0204770 <commands+0xd0>
ffffffffc02005a2:	b19ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("  sp       0x%08x\n", gpr->sp);
ffffffffc02005a6:	680c                	ld	a1,16(s0)
ffffffffc02005a8:	00004517          	auipc	a0,0x4
ffffffffc02005ac:	1e050513          	addi	a0,a0,480 # ffffffffc0204788 <commands+0xe8>
ffffffffc02005b0:	b0bff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("  gp       0x%08x\n", gpr->gp);
ffffffffc02005b4:	6c0c                	ld	a1,24(s0)
ffffffffc02005b6:	00004517          	auipc	a0,0x4
ffffffffc02005ba:	1ea50513          	addi	a0,a0,490 # ffffffffc02047a0 <commands+0x100>
ffffffffc02005be:	afdff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("  tp       0x%08x\n", gpr->tp);
ffffffffc02005c2:	700c                	ld	a1,32(s0)
ffffffffc02005c4:	00004517          	auipc	a0,0x4
ffffffffc02005c8:	1f450513          	addi	a0,a0,500 # ffffffffc02047b8 <commands+0x118>
ffffffffc02005cc:	aefff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("  t0       0x%08x\n", gpr->t0);
ffffffffc02005d0:	740c                	ld	a1,40(s0)
ffffffffc02005d2:	00004517          	auipc	a0,0x4
ffffffffc02005d6:	1fe50513          	addi	a0,a0,510 # ffffffffc02047d0 <commands+0x130>
ffffffffc02005da:	ae1ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("  t1       0x%08x\n", gpr->t1);
ffffffffc02005de:	780c                	ld	a1,48(s0)
ffffffffc02005e0:	00004517          	auipc	a0,0x4
ffffffffc02005e4:	20850513          	addi	a0,a0,520 # ffffffffc02047e8 <commands+0x148>
ffffffffc02005e8:	ad3ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("  t2       0x%08x\n", gpr->t2);
ffffffffc02005ec:	7c0c                	ld	a1,56(s0)
ffffffffc02005ee:	00004517          	auipc	a0,0x4
ffffffffc02005f2:	21250513          	addi	a0,a0,530 # ffffffffc0204800 <commands+0x160>
ffffffffc02005f6:	ac5ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("  s0       0x%08x\n", gpr->s0);
ffffffffc02005fa:	602c                	ld	a1,64(s0)
ffffffffc02005fc:	00004517          	auipc	a0,0x4
ffffffffc0200600:	21c50513          	addi	a0,a0,540 # ffffffffc0204818 <commands+0x178>
ffffffffc0200604:	ab7ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("  s1       0x%08x\n", gpr->s1);
ffffffffc0200608:	642c                	ld	a1,72(s0)
ffffffffc020060a:	00004517          	auipc	a0,0x4
ffffffffc020060e:	22650513          	addi	a0,a0,550 # ffffffffc0204830 <commands+0x190>
ffffffffc0200612:	aa9ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("  a0       0x%08x\n", gpr->a0);
ffffffffc0200616:	682c                	ld	a1,80(s0)
ffffffffc0200618:	00004517          	auipc	a0,0x4
ffffffffc020061c:	23050513          	addi	a0,a0,560 # ffffffffc0204848 <commands+0x1a8>
ffffffffc0200620:	a9bff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("  a1       0x%08x\n", gpr->a1);
ffffffffc0200624:	6c2c                	ld	a1,88(s0)
ffffffffc0200626:	00004517          	auipc	a0,0x4
ffffffffc020062a:	23a50513          	addi	a0,a0,570 # ffffffffc0204860 <commands+0x1c0>
ffffffffc020062e:	a8dff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("  a2       0x%08x\n", gpr->a2);
ffffffffc0200632:	702c                	ld	a1,96(s0)
ffffffffc0200634:	00004517          	auipc	a0,0x4
ffffffffc0200638:	24450513          	addi	a0,a0,580 # ffffffffc0204878 <commands+0x1d8>
ffffffffc020063c:	a7fff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("  a3       0x%08x\n", gpr->a3);
ffffffffc0200640:	742c                	ld	a1,104(s0)
ffffffffc0200642:	00004517          	auipc	a0,0x4
ffffffffc0200646:	24e50513          	addi	a0,a0,590 # ffffffffc0204890 <commands+0x1f0>
ffffffffc020064a:	a71ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("  a4       0x%08x\n", gpr->a4);
ffffffffc020064e:	782c                	ld	a1,112(s0)
ffffffffc0200650:	00004517          	auipc	a0,0x4
ffffffffc0200654:	25850513          	addi	a0,a0,600 # ffffffffc02048a8 <commands+0x208>
ffffffffc0200658:	a63ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("  a5       0x%08x\n", gpr->a5);
ffffffffc020065c:	7c2c                	ld	a1,120(s0)
ffffffffc020065e:	00004517          	auipc	a0,0x4
ffffffffc0200662:	26250513          	addi	a0,a0,610 # ffffffffc02048c0 <commands+0x220>
ffffffffc0200666:	a55ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("  a6       0x%08x\n", gpr->a6);
ffffffffc020066a:	604c                	ld	a1,128(s0)
ffffffffc020066c:	00004517          	auipc	a0,0x4
ffffffffc0200670:	26c50513          	addi	a0,a0,620 # ffffffffc02048d8 <commands+0x238>
ffffffffc0200674:	a47ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("  a7       0x%08x\n", gpr->a7);
ffffffffc0200678:	644c                	ld	a1,136(s0)
ffffffffc020067a:	00004517          	auipc	a0,0x4
ffffffffc020067e:	27650513          	addi	a0,a0,630 # ffffffffc02048f0 <commands+0x250>
ffffffffc0200682:	a39ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("  s2       0x%08x\n", gpr->s2);
ffffffffc0200686:	684c                	ld	a1,144(s0)
ffffffffc0200688:	00004517          	auipc	a0,0x4
ffffffffc020068c:	28050513          	addi	a0,a0,640 # ffffffffc0204908 <commands+0x268>
ffffffffc0200690:	a2bff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("  s3       0x%08x\n", gpr->s3);
ffffffffc0200694:	6c4c                	ld	a1,152(s0)
ffffffffc0200696:	00004517          	auipc	a0,0x4
ffffffffc020069a:	28a50513          	addi	a0,a0,650 # ffffffffc0204920 <commands+0x280>
ffffffffc020069e:	a1dff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("  s4       0x%08x\n", gpr->s4);
ffffffffc02006a2:	704c                	ld	a1,160(s0)
ffffffffc02006a4:	00004517          	auipc	a0,0x4
ffffffffc02006a8:	29450513          	addi	a0,a0,660 # ffffffffc0204938 <commands+0x298>
ffffffffc02006ac:	a0fff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("  s5       0x%08x\n", gpr->s5);
ffffffffc02006b0:	744c                	ld	a1,168(s0)
ffffffffc02006b2:	00004517          	auipc	a0,0x4
ffffffffc02006b6:	29e50513          	addi	a0,a0,670 # ffffffffc0204950 <commands+0x2b0>
ffffffffc02006ba:	a01ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("  s6       0x%08x\n", gpr->s6);
ffffffffc02006be:	784c                	ld	a1,176(s0)
ffffffffc02006c0:	00004517          	auipc	a0,0x4
ffffffffc02006c4:	2a850513          	addi	a0,a0,680 # ffffffffc0204968 <commands+0x2c8>
ffffffffc02006c8:	9f3ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("  s7       0x%08x\n", gpr->s7);
ffffffffc02006cc:	7c4c                	ld	a1,184(s0)
ffffffffc02006ce:	00004517          	auipc	a0,0x4
ffffffffc02006d2:	2b250513          	addi	a0,a0,690 # ffffffffc0204980 <commands+0x2e0>
ffffffffc02006d6:	9e5ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("  s8       0x%08x\n", gpr->s8);
ffffffffc02006da:	606c                	ld	a1,192(s0)
ffffffffc02006dc:	00004517          	auipc	a0,0x4
ffffffffc02006e0:	2bc50513          	addi	a0,a0,700 # ffffffffc0204998 <commands+0x2f8>
ffffffffc02006e4:	9d7ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("  s9       0x%08x\n", gpr->s9);
ffffffffc02006e8:	646c                	ld	a1,200(s0)
ffffffffc02006ea:	00004517          	auipc	a0,0x4
ffffffffc02006ee:	2c650513          	addi	a0,a0,710 # ffffffffc02049b0 <commands+0x310>
ffffffffc02006f2:	9c9ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("  s10      0x%08x\n", gpr->s10);
ffffffffc02006f6:	686c                	ld	a1,208(s0)
ffffffffc02006f8:	00004517          	auipc	a0,0x4
ffffffffc02006fc:	2d050513          	addi	a0,a0,720 # ffffffffc02049c8 <commands+0x328>
ffffffffc0200700:	9bbff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("  s11      0x%08x\n", gpr->s11);
ffffffffc0200704:	6c6c                	ld	a1,216(s0)
ffffffffc0200706:	00004517          	auipc	a0,0x4
ffffffffc020070a:	2da50513          	addi	a0,a0,730 # ffffffffc02049e0 <commands+0x340>
ffffffffc020070e:	9adff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("  t3       0x%08x\n", gpr->t3);
ffffffffc0200712:	706c                	ld	a1,224(s0)
ffffffffc0200714:	00004517          	auipc	a0,0x4
ffffffffc0200718:	2e450513          	addi	a0,a0,740 # ffffffffc02049f8 <commands+0x358>
ffffffffc020071c:	99fff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("  t4       0x%08x\n", gpr->t4);
ffffffffc0200720:	746c                	ld	a1,232(s0)
ffffffffc0200722:	00004517          	auipc	a0,0x4
ffffffffc0200726:	2ee50513          	addi	a0,a0,750 # ffffffffc0204a10 <commands+0x370>
ffffffffc020072a:	991ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("  t5       0x%08x\n", gpr->t5);
ffffffffc020072e:	786c                	ld	a1,240(s0)
ffffffffc0200730:	00004517          	auipc	a0,0x4
ffffffffc0200734:	2f850513          	addi	a0,a0,760 # ffffffffc0204a28 <commands+0x388>
ffffffffc0200738:	983ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("  t6       0x%08x\n", gpr->t6);
ffffffffc020073c:	7c6c                	ld	a1,248(s0)
}
ffffffffc020073e:	6402                	ld	s0,0(sp)
ffffffffc0200740:	60a2                	ld	ra,8(sp)
    cprintf("  t6       0x%08x\n", gpr->t6);
ffffffffc0200742:	00004517          	auipc	a0,0x4
ffffffffc0200746:	2fe50513          	addi	a0,a0,766 # ffffffffc0204a40 <commands+0x3a0>
}
ffffffffc020074a:	0141                	addi	sp,sp,16
    cprintf("  t6       0x%08x\n", gpr->t6);
ffffffffc020074c:	b2bd                	j	ffffffffc02000ba <cprintf>

ffffffffc020074e <print_trapframe>:
void print_trapframe(struct trapframe *tf) {
ffffffffc020074e:	1141                	addi	sp,sp,-16
ffffffffc0200750:	e022                	sd	s0,0(sp)
    cprintf("trapframe at %p\n", tf);
ffffffffc0200752:	85aa                	mv	a1,a0
void print_trapframe(struct trapframe *tf) {
ffffffffc0200754:	842a                	mv	s0,a0
    cprintf("trapframe at %p\n", tf);
ffffffffc0200756:	00004517          	auipc	a0,0x4
ffffffffc020075a:	30250513          	addi	a0,a0,770 # ffffffffc0204a58 <commands+0x3b8>
void print_trapframe(struct trapframe *tf) {
ffffffffc020075e:	e406                	sd	ra,8(sp)
    cprintf("trapframe at %p\n", tf);
ffffffffc0200760:	95bff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    print_regs(&tf->gpr);
ffffffffc0200764:	8522                	mv	a0,s0
ffffffffc0200766:	e1dff0ef          	jal	ra,ffffffffc0200582 <print_regs>
    cprintf("  status   0x%08x\n", tf->status);
ffffffffc020076a:	10043583          	ld	a1,256(s0)
ffffffffc020076e:	00004517          	auipc	a0,0x4
ffffffffc0200772:	30250513          	addi	a0,a0,770 # ffffffffc0204a70 <commands+0x3d0>
ffffffffc0200776:	945ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("  epc      0x%08x\n", tf->epc);
ffffffffc020077a:	10843583          	ld	a1,264(s0)
ffffffffc020077e:	00004517          	auipc	a0,0x4
ffffffffc0200782:	30a50513          	addi	a0,a0,778 # ffffffffc0204a88 <commands+0x3e8>
ffffffffc0200786:	935ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("  badvaddr 0x%08x\n", tf->badvaddr);
ffffffffc020078a:	11043583          	ld	a1,272(s0)
ffffffffc020078e:	00004517          	auipc	a0,0x4
ffffffffc0200792:	31250513          	addi	a0,a0,786 # ffffffffc0204aa0 <commands+0x400>
ffffffffc0200796:	925ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("  cause    0x%08x\n", tf->cause);
ffffffffc020079a:	11843583          	ld	a1,280(s0)
}
ffffffffc020079e:	6402                	ld	s0,0(sp)
ffffffffc02007a0:	60a2                	ld	ra,8(sp)
    cprintf("  cause    0x%08x\n", tf->cause);
ffffffffc02007a2:	00004517          	auipc	a0,0x4
ffffffffc02007a6:	31650513          	addi	a0,a0,790 # ffffffffc0204ab8 <commands+0x418>
}
ffffffffc02007aa:	0141                	addi	sp,sp,16
    cprintf("  cause    0x%08x\n", tf->cause);
ffffffffc02007ac:	90fff06f          	j	ffffffffc02000ba <cprintf>

ffffffffc02007b0 <interrupt_handler>:

static volatile int in_swap_tick_event = 0;
extern struct mm_struct *check_mm_struct;

void interrupt_handler(struct trapframe *tf) {
    intptr_t cause = (tf->cause << 1) >> 1;
ffffffffc02007b0:	11853783          	ld	a5,280(a0)
ffffffffc02007b4:	472d                	li	a4,11
ffffffffc02007b6:	0786                	slli	a5,a5,0x1
ffffffffc02007b8:	8385                	srli	a5,a5,0x1
ffffffffc02007ba:	06f76c63          	bltu	a4,a5,ffffffffc0200832 <interrupt_handler+0x82>
ffffffffc02007be:	00004717          	auipc	a4,0x4
ffffffffc02007c2:	3c270713          	addi	a4,a4,962 # ffffffffc0204b80 <commands+0x4e0>
ffffffffc02007c6:	078a                	slli	a5,a5,0x2
ffffffffc02007c8:	97ba                	add	a5,a5,a4
ffffffffc02007ca:	439c                	lw	a5,0(a5)
ffffffffc02007cc:	97ba                	add	a5,a5,a4
ffffffffc02007ce:	8782                	jr	a5
            break;
        case IRQ_H_SOFT:
            cprintf("Hypervisor software interrupt\n");
            break;
        case IRQ_M_SOFT:
            cprintf("Machine software interrupt\n");
ffffffffc02007d0:	00004517          	auipc	a0,0x4
ffffffffc02007d4:	36050513          	addi	a0,a0,864 # ffffffffc0204b30 <commands+0x490>
ffffffffc02007d8:	8e3ff06f          	j	ffffffffc02000ba <cprintf>
            cprintf("Hypervisor software interrupt\n");
ffffffffc02007dc:	00004517          	auipc	a0,0x4
ffffffffc02007e0:	33450513          	addi	a0,a0,820 # ffffffffc0204b10 <commands+0x470>
ffffffffc02007e4:	8d7ff06f          	j	ffffffffc02000ba <cprintf>
            cprintf("User software interrupt\n");
ffffffffc02007e8:	00004517          	auipc	a0,0x4
ffffffffc02007ec:	2e850513          	addi	a0,a0,744 # ffffffffc0204ad0 <commands+0x430>
ffffffffc02007f0:	8cbff06f          	j	ffffffffc02000ba <cprintf>
            cprintf("Supervisor software interrupt\n");
ffffffffc02007f4:	00004517          	auipc	a0,0x4
ffffffffc02007f8:	2fc50513          	addi	a0,a0,764 # ffffffffc0204af0 <commands+0x450>
ffffffffc02007fc:	8bfff06f          	j	ffffffffc02000ba <cprintf>
void interrupt_handler(struct trapframe *tf) {
ffffffffc0200800:	1141                	addi	sp,sp,-16
ffffffffc0200802:	e406                	sd	ra,8(sp)
            // "All bits besides SSIP and USIP in the sip register are
            // read-only." -- privileged spec1.9.1, 4.1.4, p59
            // In fact, Call sbi_set_timer will clear STIP, or you can clear it
            // directly.
            // clear_csr(sip, SIP_STIP);
            clock_set_next_event();
ffffffffc0200804:	c5bff0ef          	jal	ra,ffffffffc020045e <clock_set_next_event>
            if (++ticks % TICK_NUM == 0) {
ffffffffc0200808:	00011697          	auipc	a3,0x11
ffffffffc020080c:	cf868693          	addi	a3,a3,-776 # ffffffffc0211500 <ticks>
ffffffffc0200810:	629c                	ld	a5,0(a3)
ffffffffc0200812:	06400713          	li	a4,100
ffffffffc0200816:	0785                	addi	a5,a5,1
ffffffffc0200818:	02e7f733          	remu	a4,a5,a4
ffffffffc020081c:	e29c                	sd	a5,0(a3)
ffffffffc020081e:	cb19                	beqz	a4,ffffffffc0200834 <interrupt_handler+0x84>
            break;
        default:
            print_trapframe(tf);
            break;
    }
}
ffffffffc0200820:	60a2                	ld	ra,8(sp)
ffffffffc0200822:	0141                	addi	sp,sp,16
ffffffffc0200824:	8082                	ret
            cprintf("Supervisor external interrupt\n");
ffffffffc0200826:	00004517          	auipc	a0,0x4
ffffffffc020082a:	33a50513          	addi	a0,a0,826 # ffffffffc0204b60 <commands+0x4c0>
ffffffffc020082e:	88dff06f          	j	ffffffffc02000ba <cprintf>
            print_trapframe(tf);
ffffffffc0200832:	bf31                	j	ffffffffc020074e <print_trapframe>
}
ffffffffc0200834:	60a2                	ld	ra,8(sp)
    cprintf("%d ticks\n", TICK_NUM);
ffffffffc0200836:	06400593          	li	a1,100
ffffffffc020083a:	00004517          	auipc	a0,0x4
ffffffffc020083e:	31650513          	addi	a0,a0,790 # ffffffffc0204b50 <commands+0x4b0>
}
ffffffffc0200842:	0141                	addi	sp,sp,16
    cprintf("%d ticks\n", TICK_NUM);
ffffffffc0200844:	877ff06f          	j	ffffffffc02000ba <cprintf>

ffffffffc0200848 <exception_handler>:


void exception_handler(struct trapframe *tf) {
    int ret;
    switch (tf->cause) {
ffffffffc0200848:	11853783          	ld	a5,280(a0)
void exception_handler(struct trapframe *tf) {
ffffffffc020084c:	1101                	addi	sp,sp,-32
ffffffffc020084e:	e822                	sd	s0,16(sp)
ffffffffc0200850:	ec06                	sd	ra,24(sp)
ffffffffc0200852:	e426                	sd	s1,8(sp)
ffffffffc0200854:	473d                	li	a4,15
ffffffffc0200856:	842a                	mv	s0,a0
ffffffffc0200858:	14f76a63          	bltu	a4,a5,ffffffffc02009ac <exception_handler+0x164>
ffffffffc020085c:	00004717          	auipc	a4,0x4
ffffffffc0200860:	50c70713          	addi	a4,a4,1292 # ffffffffc0204d68 <commands+0x6c8>
ffffffffc0200864:	078a                	slli	a5,a5,0x2
ffffffffc0200866:	97ba                	add	a5,a5,a4
ffffffffc0200868:	439c                	lw	a5,0(a5)
ffffffffc020086a:	97ba                	add	a5,a5,a4
ffffffffc020086c:	8782                	jr	a5
                print_trapframe(tf);
                panic("handle pgfault failed. %e\n", ret);
            }
            break;
        case CAUSE_STORE_PAGE_FAULT:
            cprintf("Store/AMO page fault\n");
ffffffffc020086e:	00004517          	auipc	a0,0x4
ffffffffc0200872:	4e250513          	addi	a0,a0,1250 # ffffffffc0204d50 <commands+0x6b0>
ffffffffc0200876:	845ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
            if ((ret = pgfault_handler(tf)) != 0) {
ffffffffc020087a:	8522                	mv	a0,s0
ffffffffc020087c:	c79ff0ef          	jal	ra,ffffffffc02004f4 <pgfault_handler>
ffffffffc0200880:	84aa                	mv	s1,a0
ffffffffc0200882:	12051b63          	bnez	a0,ffffffffc02009b8 <exception_handler+0x170>
            break;
        default:
            print_trapframe(tf);
            break;
    }
}
ffffffffc0200886:	60e2                	ld	ra,24(sp)
ffffffffc0200888:	6442                	ld	s0,16(sp)
ffffffffc020088a:	64a2                	ld	s1,8(sp)
ffffffffc020088c:	6105                	addi	sp,sp,32
ffffffffc020088e:	8082                	ret
            cprintf("Instruction address misaligned\n");
ffffffffc0200890:	00004517          	auipc	a0,0x4
ffffffffc0200894:	32050513          	addi	a0,a0,800 # ffffffffc0204bb0 <commands+0x510>
}
ffffffffc0200898:	6442                	ld	s0,16(sp)
ffffffffc020089a:	60e2                	ld	ra,24(sp)
ffffffffc020089c:	64a2                	ld	s1,8(sp)
ffffffffc020089e:	6105                	addi	sp,sp,32
            cprintf("Instruction access fault\n");
ffffffffc02008a0:	81bff06f          	j	ffffffffc02000ba <cprintf>
ffffffffc02008a4:	00004517          	auipc	a0,0x4
ffffffffc02008a8:	32c50513          	addi	a0,a0,812 # ffffffffc0204bd0 <commands+0x530>
ffffffffc02008ac:	b7f5                	j	ffffffffc0200898 <exception_handler+0x50>
            cprintf("Illegal instruction\n");
ffffffffc02008ae:	00004517          	auipc	a0,0x4
ffffffffc02008b2:	34250513          	addi	a0,a0,834 # ffffffffc0204bf0 <commands+0x550>
ffffffffc02008b6:	b7cd                	j	ffffffffc0200898 <exception_handler+0x50>
            cprintf("Breakpoint\n");
ffffffffc02008b8:	00004517          	auipc	a0,0x4
ffffffffc02008bc:	35050513          	addi	a0,a0,848 # ffffffffc0204c08 <commands+0x568>
ffffffffc02008c0:	bfe1                	j	ffffffffc0200898 <exception_handler+0x50>
            cprintf("Load address misaligned\n");
ffffffffc02008c2:	00004517          	auipc	a0,0x4
ffffffffc02008c6:	35650513          	addi	a0,a0,854 # ffffffffc0204c18 <commands+0x578>
ffffffffc02008ca:	b7f9                	j	ffffffffc0200898 <exception_handler+0x50>
            cprintf("Load access fault\n");
ffffffffc02008cc:	00004517          	auipc	a0,0x4
ffffffffc02008d0:	36c50513          	addi	a0,a0,876 # ffffffffc0204c38 <commands+0x598>
ffffffffc02008d4:	fe6ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
            if ((ret = pgfault_handler(tf)) != 0) {
ffffffffc02008d8:	8522                	mv	a0,s0
ffffffffc02008da:	c1bff0ef          	jal	ra,ffffffffc02004f4 <pgfault_handler>
ffffffffc02008de:	84aa                	mv	s1,a0
ffffffffc02008e0:	d15d                	beqz	a0,ffffffffc0200886 <exception_handler+0x3e>
                print_trapframe(tf);
ffffffffc02008e2:	8522                	mv	a0,s0
ffffffffc02008e4:	e6bff0ef          	jal	ra,ffffffffc020074e <print_trapframe>
                panic("handle pgfault failed. %e\n", ret);
ffffffffc02008e8:	86a6                	mv	a3,s1
ffffffffc02008ea:	00004617          	auipc	a2,0x4
ffffffffc02008ee:	36660613          	addi	a2,a2,870 # ffffffffc0204c50 <commands+0x5b0>
ffffffffc02008f2:	0ca00593          	li	a1,202
ffffffffc02008f6:	00004517          	auipc	a0,0x4
ffffffffc02008fa:	e4a50513          	addi	a0,a0,-438 # ffffffffc0204740 <commands+0xa0>
ffffffffc02008fe:	805ff0ef          	jal	ra,ffffffffc0200102 <__panic>
            cprintf("AMO address misaligned\n");
ffffffffc0200902:	00004517          	auipc	a0,0x4
ffffffffc0200906:	36e50513          	addi	a0,a0,878 # ffffffffc0204c70 <commands+0x5d0>
ffffffffc020090a:	b779                	j	ffffffffc0200898 <exception_handler+0x50>
            cprintf("Store/AMO access fault\n");
ffffffffc020090c:	00004517          	auipc	a0,0x4
ffffffffc0200910:	37c50513          	addi	a0,a0,892 # ffffffffc0204c88 <commands+0x5e8>
ffffffffc0200914:	fa6ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
            if ((ret = pgfault_handler(tf)) != 0) {
ffffffffc0200918:	8522                	mv	a0,s0
ffffffffc020091a:	bdbff0ef          	jal	ra,ffffffffc02004f4 <pgfault_handler>
ffffffffc020091e:	84aa                	mv	s1,a0
ffffffffc0200920:	d13d                	beqz	a0,ffffffffc0200886 <exception_handler+0x3e>
                print_trapframe(tf);
ffffffffc0200922:	8522                	mv	a0,s0
ffffffffc0200924:	e2bff0ef          	jal	ra,ffffffffc020074e <print_trapframe>
                panic("handle pgfault failed. %e\n", ret);
ffffffffc0200928:	86a6                	mv	a3,s1
ffffffffc020092a:	00004617          	auipc	a2,0x4
ffffffffc020092e:	32660613          	addi	a2,a2,806 # ffffffffc0204c50 <commands+0x5b0>
ffffffffc0200932:	0d400593          	li	a1,212
ffffffffc0200936:	00004517          	auipc	a0,0x4
ffffffffc020093a:	e0a50513          	addi	a0,a0,-502 # ffffffffc0204740 <commands+0xa0>
ffffffffc020093e:	fc4ff0ef          	jal	ra,ffffffffc0200102 <__panic>
            cprintf("Environment call from U-mode\n");
ffffffffc0200942:	00004517          	auipc	a0,0x4
ffffffffc0200946:	35e50513          	addi	a0,a0,862 # ffffffffc0204ca0 <commands+0x600>
ffffffffc020094a:	b7b9                	j	ffffffffc0200898 <exception_handler+0x50>
            cprintf("Environment call from S-mode\n");
ffffffffc020094c:	00004517          	auipc	a0,0x4
ffffffffc0200950:	37450513          	addi	a0,a0,884 # ffffffffc0204cc0 <commands+0x620>
ffffffffc0200954:	b791                	j	ffffffffc0200898 <exception_handler+0x50>
            cprintf("Environment call from H-mode\n");
ffffffffc0200956:	00004517          	auipc	a0,0x4
ffffffffc020095a:	38a50513          	addi	a0,a0,906 # ffffffffc0204ce0 <commands+0x640>
ffffffffc020095e:	bf2d                	j	ffffffffc0200898 <exception_handler+0x50>
            cprintf("Environment call from M-mode\n");
ffffffffc0200960:	00004517          	auipc	a0,0x4
ffffffffc0200964:	3a050513          	addi	a0,a0,928 # ffffffffc0204d00 <commands+0x660>
ffffffffc0200968:	bf05                	j	ffffffffc0200898 <exception_handler+0x50>
            cprintf("Instruction page fault\n");
ffffffffc020096a:	00004517          	auipc	a0,0x4
ffffffffc020096e:	3b650513          	addi	a0,a0,950 # ffffffffc0204d20 <commands+0x680>
ffffffffc0200972:	b71d                	j	ffffffffc0200898 <exception_handler+0x50>
            cprintf("Load page fault\n");
ffffffffc0200974:	00004517          	auipc	a0,0x4
ffffffffc0200978:	3c450513          	addi	a0,a0,964 # ffffffffc0204d38 <commands+0x698>
ffffffffc020097c:	f3eff0ef          	jal	ra,ffffffffc02000ba <cprintf>
            if ((ret = pgfault_handler(tf)) != 0) {
ffffffffc0200980:	8522                	mv	a0,s0
ffffffffc0200982:	b73ff0ef          	jal	ra,ffffffffc02004f4 <pgfault_handler>
ffffffffc0200986:	84aa                	mv	s1,a0
ffffffffc0200988:	ee050fe3          	beqz	a0,ffffffffc0200886 <exception_handler+0x3e>
                print_trapframe(tf);
ffffffffc020098c:	8522                	mv	a0,s0
ffffffffc020098e:	dc1ff0ef          	jal	ra,ffffffffc020074e <print_trapframe>
                panic("handle pgfault failed. %e\n", ret);
ffffffffc0200992:	86a6                	mv	a3,s1
ffffffffc0200994:	00004617          	auipc	a2,0x4
ffffffffc0200998:	2bc60613          	addi	a2,a2,700 # ffffffffc0204c50 <commands+0x5b0>
ffffffffc020099c:	0ea00593          	li	a1,234
ffffffffc02009a0:	00004517          	auipc	a0,0x4
ffffffffc02009a4:	da050513          	addi	a0,a0,-608 # ffffffffc0204740 <commands+0xa0>
ffffffffc02009a8:	f5aff0ef          	jal	ra,ffffffffc0200102 <__panic>
            print_trapframe(tf);
ffffffffc02009ac:	8522                	mv	a0,s0
}
ffffffffc02009ae:	6442                	ld	s0,16(sp)
ffffffffc02009b0:	60e2                	ld	ra,24(sp)
ffffffffc02009b2:	64a2                	ld	s1,8(sp)
ffffffffc02009b4:	6105                	addi	sp,sp,32
            print_trapframe(tf);
ffffffffc02009b6:	bb61                	j	ffffffffc020074e <print_trapframe>
                print_trapframe(tf);
ffffffffc02009b8:	8522                	mv	a0,s0
ffffffffc02009ba:	d95ff0ef          	jal	ra,ffffffffc020074e <print_trapframe>
                panic("handle pgfault failed. %e\n", ret);
ffffffffc02009be:	86a6                	mv	a3,s1
ffffffffc02009c0:	00004617          	auipc	a2,0x4
ffffffffc02009c4:	29060613          	addi	a2,a2,656 # ffffffffc0204c50 <commands+0x5b0>
ffffffffc02009c8:	0f100593          	li	a1,241
ffffffffc02009cc:	00004517          	auipc	a0,0x4
ffffffffc02009d0:	d7450513          	addi	a0,a0,-652 # ffffffffc0204740 <commands+0xa0>
ffffffffc02009d4:	f2eff0ef          	jal	ra,ffffffffc0200102 <__panic>

ffffffffc02009d8 <trap>:
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void trap(struct trapframe *tf) {
    // dispatch based on what type of trap occurred
    if ((intptr_t)tf->cause < 0) {
ffffffffc02009d8:	11853783          	ld	a5,280(a0)
ffffffffc02009dc:	0007c363          	bltz	a5,ffffffffc02009e2 <trap+0xa>
        // interrupts
        interrupt_handler(tf);
    } else {
        // exceptions
        exception_handler(tf);
ffffffffc02009e0:	b5a5                	j	ffffffffc0200848 <exception_handler>
        interrupt_handler(tf);
ffffffffc02009e2:	b3f9                	j	ffffffffc02007b0 <interrupt_handler>
	...

ffffffffc02009f0 <__alltraps>:
    .endm

    .align 4
    .globl __alltraps
__alltraps:
    SAVE_ALL
ffffffffc02009f0:	14011073          	csrw	sscratch,sp
ffffffffc02009f4:	712d                	addi	sp,sp,-288
ffffffffc02009f6:	e406                	sd	ra,8(sp)
ffffffffc02009f8:	ec0e                	sd	gp,24(sp)
ffffffffc02009fa:	f012                	sd	tp,32(sp)
ffffffffc02009fc:	f416                	sd	t0,40(sp)
ffffffffc02009fe:	f81a                	sd	t1,48(sp)
ffffffffc0200a00:	fc1e                	sd	t2,56(sp)
ffffffffc0200a02:	e0a2                	sd	s0,64(sp)
ffffffffc0200a04:	e4a6                	sd	s1,72(sp)
ffffffffc0200a06:	e8aa                	sd	a0,80(sp)
ffffffffc0200a08:	ecae                	sd	a1,88(sp)
ffffffffc0200a0a:	f0b2                	sd	a2,96(sp)
ffffffffc0200a0c:	f4b6                	sd	a3,104(sp)
ffffffffc0200a0e:	f8ba                	sd	a4,112(sp)
ffffffffc0200a10:	fcbe                	sd	a5,120(sp)
ffffffffc0200a12:	e142                	sd	a6,128(sp)
ffffffffc0200a14:	e546                	sd	a7,136(sp)
ffffffffc0200a16:	e94a                	sd	s2,144(sp)
ffffffffc0200a18:	ed4e                	sd	s3,152(sp)
ffffffffc0200a1a:	f152                	sd	s4,160(sp)
ffffffffc0200a1c:	f556                	sd	s5,168(sp)
ffffffffc0200a1e:	f95a                	sd	s6,176(sp)
ffffffffc0200a20:	fd5e                	sd	s7,184(sp)
ffffffffc0200a22:	e1e2                	sd	s8,192(sp)
ffffffffc0200a24:	e5e6                	sd	s9,200(sp)
ffffffffc0200a26:	e9ea                	sd	s10,208(sp)
ffffffffc0200a28:	edee                	sd	s11,216(sp)
ffffffffc0200a2a:	f1f2                	sd	t3,224(sp)
ffffffffc0200a2c:	f5f6                	sd	t4,232(sp)
ffffffffc0200a2e:	f9fa                	sd	t5,240(sp)
ffffffffc0200a30:	fdfe                	sd	t6,248(sp)
ffffffffc0200a32:	14002473          	csrr	s0,sscratch
ffffffffc0200a36:	100024f3          	csrr	s1,sstatus
ffffffffc0200a3a:	14102973          	csrr	s2,sepc
ffffffffc0200a3e:	143029f3          	csrr	s3,stval
ffffffffc0200a42:	14202a73          	csrr	s4,scause
ffffffffc0200a46:	e822                	sd	s0,16(sp)
ffffffffc0200a48:	e226                	sd	s1,256(sp)
ffffffffc0200a4a:	e64a                	sd	s2,264(sp)
ffffffffc0200a4c:	ea4e                	sd	s3,272(sp)
ffffffffc0200a4e:	ee52                	sd	s4,280(sp)

    move  a0, sp
ffffffffc0200a50:	850a                	mv	a0,sp
    jal trap
ffffffffc0200a52:	f87ff0ef          	jal	ra,ffffffffc02009d8 <trap>

ffffffffc0200a56 <__trapret>:
    // sp should be the same as before "jal trap"
    .globl __trapret
__trapret:
    RESTORE_ALL
ffffffffc0200a56:	6492                	ld	s1,256(sp)
ffffffffc0200a58:	6932                	ld	s2,264(sp)
ffffffffc0200a5a:	10049073          	csrw	sstatus,s1
ffffffffc0200a5e:	14191073          	csrw	sepc,s2
ffffffffc0200a62:	60a2                	ld	ra,8(sp)
ffffffffc0200a64:	61e2                	ld	gp,24(sp)
ffffffffc0200a66:	7202                	ld	tp,32(sp)
ffffffffc0200a68:	72a2                	ld	t0,40(sp)
ffffffffc0200a6a:	7342                	ld	t1,48(sp)
ffffffffc0200a6c:	73e2                	ld	t2,56(sp)
ffffffffc0200a6e:	6406                	ld	s0,64(sp)
ffffffffc0200a70:	64a6                	ld	s1,72(sp)
ffffffffc0200a72:	6546                	ld	a0,80(sp)
ffffffffc0200a74:	65e6                	ld	a1,88(sp)
ffffffffc0200a76:	7606                	ld	a2,96(sp)
ffffffffc0200a78:	76a6                	ld	a3,104(sp)
ffffffffc0200a7a:	7746                	ld	a4,112(sp)
ffffffffc0200a7c:	77e6                	ld	a5,120(sp)
ffffffffc0200a7e:	680a                	ld	a6,128(sp)
ffffffffc0200a80:	68aa                	ld	a7,136(sp)
ffffffffc0200a82:	694a                	ld	s2,144(sp)
ffffffffc0200a84:	69ea                	ld	s3,152(sp)
ffffffffc0200a86:	7a0a                	ld	s4,160(sp)
ffffffffc0200a88:	7aaa                	ld	s5,168(sp)
ffffffffc0200a8a:	7b4a                	ld	s6,176(sp)
ffffffffc0200a8c:	7bea                	ld	s7,184(sp)
ffffffffc0200a8e:	6c0e                	ld	s8,192(sp)
ffffffffc0200a90:	6cae                	ld	s9,200(sp)
ffffffffc0200a92:	6d4e                	ld	s10,208(sp)
ffffffffc0200a94:	6dee                	ld	s11,216(sp)
ffffffffc0200a96:	7e0e                	ld	t3,224(sp)
ffffffffc0200a98:	7eae                	ld	t4,232(sp)
ffffffffc0200a9a:	7f4e                	ld	t5,240(sp)
ffffffffc0200a9c:	7fee                	ld	t6,248(sp)
ffffffffc0200a9e:	6142                	ld	sp,16(sp)
    // go back from supervisor call
    sret
ffffffffc0200aa0:	10200073          	sret
	...

ffffffffc0200ab0 <check_vma_overlap.part.0>:
}


// check_vma_overlap - check if vma1 overlaps vma2 ?
static inline void
check_vma_overlap(struct vma_struct *prev, struct vma_struct *next) {
ffffffffc0200ab0:	1141                	addi	sp,sp,-16
    assert(prev->vm_start < prev->vm_end);
    assert(prev->vm_end <= next->vm_start);
    assert(next->vm_start < next->vm_end);
ffffffffc0200ab2:	00004697          	auipc	a3,0x4
ffffffffc0200ab6:	2f668693          	addi	a3,a3,758 # ffffffffc0204da8 <commands+0x708>
ffffffffc0200aba:	00004617          	auipc	a2,0x4
ffffffffc0200abe:	30e60613          	addi	a2,a2,782 # ffffffffc0204dc8 <commands+0x728>
ffffffffc0200ac2:	07d00593          	li	a1,125
ffffffffc0200ac6:	00004517          	auipc	a0,0x4
ffffffffc0200aca:	31a50513          	addi	a0,a0,794 # ffffffffc0204de0 <commands+0x740>
check_vma_overlap(struct vma_struct *prev, struct vma_struct *next) {
ffffffffc0200ace:	e406                	sd	ra,8(sp)
    assert(next->vm_start < next->vm_end);
ffffffffc0200ad0:	e32ff0ef          	jal	ra,ffffffffc0200102 <__panic>

ffffffffc0200ad4 <mm_create>:
mm_create(void) {
ffffffffc0200ad4:	1141                	addi	sp,sp,-16
    struct mm_struct *mm = kmalloc(sizeof(struct mm_struct));
ffffffffc0200ad6:	03000513          	li	a0,48
mm_create(void) {
ffffffffc0200ada:	e022                	sd	s0,0(sp)
ffffffffc0200adc:	e406                	sd	ra,8(sp)
    struct mm_struct *mm = kmalloc(sizeof(struct mm_struct));
ffffffffc0200ade:	0f4030ef          	jal	ra,ffffffffc0203bd2 <kmalloc>
ffffffffc0200ae2:	842a                	mv	s0,a0
    if (mm != NULL) {
ffffffffc0200ae4:	c105                	beqz	a0,ffffffffc0200b04 <mm_create+0x30>
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
ffffffffc0200ae6:	e408                	sd	a0,8(s0)
ffffffffc0200ae8:	e008                	sd	a0,0(s0)
        mm->mmap_cache = NULL;
ffffffffc0200aea:	00053823          	sd	zero,16(a0)
        mm->pgdir = NULL;
ffffffffc0200aee:	00053c23          	sd	zero,24(a0)
        mm->map_count = 0;
ffffffffc0200af2:	02052023          	sw	zero,32(a0)
        if (swap_init_ok) swap_init_mm(mm);
ffffffffc0200af6:	00011797          	auipc	a5,0x11
ffffffffc0200afa:	a3a7a783          	lw	a5,-1478(a5) # ffffffffc0211530 <swap_init_ok>
ffffffffc0200afe:	eb81                	bnez	a5,ffffffffc0200b0e <mm_create+0x3a>
        else mm->sm_priv = NULL;
ffffffffc0200b00:	02053423          	sd	zero,40(a0)
}
ffffffffc0200b04:	60a2                	ld	ra,8(sp)
ffffffffc0200b06:	8522                	mv	a0,s0
ffffffffc0200b08:	6402                	ld	s0,0(sp)
ffffffffc0200b0a:	0141                	addi	sp,sp,16
ffffffffc0200b0c:	8082                	ret
        if (swap_init_ok) swap_init_mm(mm);
ffffffffc0200b0e:	6e9000ef          	jal	ra,ffffffffc02019f6 <swap_init_mm>
}
ffffffffc0200b12:	60a2                	ld	ra,8(sp)
ffffffffc0200b14:	8522                	mv	a0,s0
ffffffffc0200b16:	6402                	ld	s0,0(sp)
ffffffffc0200b18:	0141                	addi	sp,sp,16
ffffffffc0200b1a:	8082                	ret

ffffffffc0200b1c <vma_create>:
vma_create(uintptr_t vm_start, uintptr_t vm_end, uint_t vm_flags) {
ffffffffc0200b1c:	1101                	addi	sp,sp,-32
ffffffffc0200b1e:	e04a                	sd	s2,0(sp)
ffffffffc0200b20:	892a                	mv	s2,a0
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
ffffffffc0200b22:	03000513          	li	a0,48
vma_create(uintptr_t vm_start, uintptr_t vm_end, uint_t vm_flags) {
ffffffffc0200b26:	e822                	sd	s0,16(sp)
ffffffffc0200b28:	e426                	sd	s1,8(sp)
ffffffffc0200b2a:	ec06                	sd	ra,24(sp)
ffffffffc0200b2c:	84ae                	mv	s1,a1
ffffffffc0200b2e:	8432                	mv	s0,a2
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
ffffffffc0200b30:	0a2030ef          	jal	ra,ffffffffc0203bd2 <kmalloc>
    if (vma != NULL) {
ffffffffc0200b34:	c509                	beqz	a0,ffffffffc0200b3e <vma_create+0x22>
        vma->vm_start = vm_start;
ffffffffc0200b36:	01253423          	sd	s2,8(a0)
        vma->vm_end = vm_end;
ffffffffc0200b3a:	e904                	sd	s1,16(a0)
        vma->vm_flags = vm_flags;
ffffffffc0200b3c:	ed00                	sd	s0,24(a0)
}
ffffffffc0200b3e:	60e2                	ld	ra,24(sp)
ffffffffc0200b40:	6442                	ld	s0,16(sp)
ffffffffc0200b42:	64a2                	ld	s1,8(sp)
ffffffffc0200b44:	6902                	ld	s2,0(sp)
ffffffffc0200b46:	6105                	addi	sp,sp,32
ffffffffc0200b48:	8082                	ret

ffffffffc0200b4a <find_vma>:
find_vma(struct mm_struct *mm, uintptr_t addr) {
ffffffffc0200b4a:	86aa                	mv	a3,a0
    if (mm != NULL) {
ffffffffc0200b4c:	c505                	beqz	a0,ffffffffc0200b74 <find_vma+0x2a>
        vma = mm->mmap_cache;
ffffffffc0200b4e:	6908                	ld	a0,16(a0)
        if (!(vma != NULL && vma->vm_start <= addr && vma->vm_end > addr)) {
ffffffffc0200b50:	c501                	beqz	a0,ffffffffc0200b58 <find_vma+0xe>
ffffffffc0200b52:	651c                	ld	a5,8(a0)
ffffffffc0200b54:	02f5f263          	bgeu	a1,a5,ffffffffc0200b78 <find_vma+0x2e>
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
ffffffffc0200b58:	669c                	ld	a5,8(a3)
                while ((le = list_next(le)) != list) {
ffffffffc0200b5a:	00f68d63          	beq	a3,a5,ffffffffc0200b74 <find_vma+0x2a>
                    if (vma->vm_start<=addr && addr < vma->vm_end) {
ffffffffc0200b5e:	fe87b703          	ld	a4,-24(a5)
ffffffffc0200b62:	00e5e663          	bltu	a1,a4,ffffffffc0200b6e <find_vma+0x24>
ffffffffc0200b66:	ff07b703          	ld	a4,-16(a5)
ffffffffc0200b6a:	00e5ec63          	bltu	a1,a4,ffffffffc0200b82 <find_vma+0x38>
ffffffffc0200b6e:	679c                	ld	a5,8(a5)
                while ((le = list_next(le)) != list) {
ffffffffc0200b70:	fef697e3          	bne	a3,a5,ffffffffc0200b5e <find_vma+0x14>
    struct vma_struct *vma = NULL;
ffffffffc0200b74:	4501                	li	a0,0
}
ffffffffc0200b76:	8082                	ret
        if (!(vma != NULL && vma->vm_start <= addr && vma->vm_end > addr)) {
ffffffffc0200b78:	691c                	ld	a5,16(a0)
ffffffffc0200b7a:	fcf5ffe3          	bgeu	a1,a5,ffffffffc0200b58 <find_vma+0xe>
            mm->mmap_cache = vma;
ffffffffc0200b7e:	ea88                	sd	a0,16(a3)
ffffffffc0200b80:	8082                	ret
                    vma = le2vma(le, list_link);
ffffffffc0200b82:	fe078513          	addi	a0,a5,-32
            mm->mmap_cache = vma;
ffffffffc0200b86:	ea88                	sd	a0,16(a3)
ffffffffc0200b88:	8082                	ret

ffffffffc0200b8a <insert_vma_struct>:


// insert_vma_struct -insert vma in mm's list link
void
insert_vma_struct(struct mm_struct *mm, struct vma_struct *vma) {
    assert(vma->vm_start < vma->vm_end);
ffffffffc0200b8a:	6590                	ld	a2,8(a1)
ffffffffc0200b8c:	0105b803          	ld	a6,16(a1)
insert_vma_struct(struct mm_struct *mm, struct vma_struct *vma) {
ffffffffc0200b90:	1141                	addi	sp,sp,-16
ffffffffc0200b92:	e406                	sd	ra,8(sp)
ffffffffc0200b94:	87aa                	mv	a5,a0
    assert(vma->vm_start < vma->vm_end);
ffffffffc0200b96:	01066763          	bltu	a2,a6,ffffffffc0200ba4 <insert_vma_struct+0x1a>
ffffffffc0200b9a:	a085                	j	ffffffffc0200bfa <insert_vma_struct+0x70>
    list_entry_t *le_prev = list, *le_next;

        list_entry_t *le = list;
        while ((le = list_next(le)) != list) {
            struct vma_struct *mmap_prev = le2vma(le, list_link);
            if (mmap_prev->vm_start > vma->vm_start) {
ffffffffc0200b9c:	fe87b703          	ld	a4,-24(a5)
ffffffffc0200ba0:	04e66863          	bltu	a2,a4,ffffffffc0200bf0 <insert_vma_struct+0x66>
ffffffffc0200ba4:	86be                	mv	a3,a5
ffffffffc0200ba6:	679c                	ld	a5,8(a5)
        while ((le = list_next(le)) != list) {
ffffffffc0200ba8:	fef51ae3          	bne	a0,a5,ffffffffc0200b9c <insert_vma_struct+0x12>
        }

    le_next = list_next(le_prev);

    /* check overlap */
    if (le_prev != list) {
ffffffffc0200bac:	02a68463          	beq	a3,a0,ffffffffc0200bd4 <insert_vma_struct+0x4a>
        check_vma_overlap(le2vma(le_prev, list_link), vma);
ffffffffc0200bb0:	ff06b703          	ld	a4,-16(a3)
    assert(prev->vm_start < prev->vm_end);
ffffffffc0200bb4:	fe86b883          	ld	a7,-24(a3)
ffffffffc0200bb8:	08e8f163          	bgeu	a7,a4,ffffffffc0200c3a <insert_vma_struct+0xb0>
    assert(prev->vm_end <= next->vm_start);
ffffffffc0200bbc:	04e66f63          	bltu	a2,a4,ffffffffc0200c1a <insert_vma_struct+0x90>
    }
    if (le_next != list) {
ffffffffc0200bc0:	00f50a63          	beq	a0,a5,ffffffffc0200bd4 <insert_vma_struct+0x4a>
            if (mmap_prev->vm_start > vma->vm_start) {
ffffffffc0200bc4:	fe87b703          	ld	a4,-24(a5)
    assert(prev->vm_end <= next->vm_start);
ffffffffc0200bc8:	05076963          	bltu	a4,a6,ffffffffc0200c1a <insert_vma_struct+0x90>
    assert(next->vm_start < next->vm_end);
ffffffffc0200bcc:	ff07b603          	ld	a2,-16(a5)
ffffffffc0200bd0:	02c77363          	bgeu	a4,a2,ffffffffc0200bf6 <insert_vma_struct+0x6c>
    }

    vma->vm_mm = mm;
    list_add_after(le_prev, &(vma->list_link));

    mm->map_count ++;
ffffffffc0200bd4:	5118                	lw	a4,32(a0)
    vma->vm_mm = mm;
ffffffffc0200bd6:	e188                	sd	a0,0(a1)
    list_add_after(le_prev, &(vma->list_link));
ffffffffc0200bd8:	02058613          	addi	a2,a1,32
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
ffffffffc0200bdc:	e390                	sd	a2,0(a5)
ffffffffc0200bde:	e690                	sd	a2,8(a3)
}
ffffffffc0200be0:	60a2                	ld	ra,8(sp)
    elm->next = next;
ffffffffc0200be2:	f59c                	sd	a5,40(a1)
    elm->prev = prev;
ffffffffc0200be4:	f194                	sd	a3,32(a1)
    mm->map_count ++;
ffffffffc0200be6:	0017079b          	addiw	a5,a4,1
ffffffffc0200bea:	d11c                	sw	a5,32(a0)
}
ffffffffc0200bec:	0141                	addi	sp,sp,16
ffffffffc0200bee:	8082                	ret
    if (le_prev != list) {
ffffffffc0200bf0:	fca690e3          	bne	a3,a0,ffffffffc0200bb0 <insert_vma_struct+0x26>
ffffffffc0200bf4:	bfd1                	j	ffffffffc0200bc8 <insert_vma_struct+0x3e>
ffffffffc0200bf6:	ebbff0ef          	jal	ra,ffffffffc0200ab0 <check_vma_overlap.part.0>
    assert(vma->vm_start < vma->vm_end);
ffffffffc0200bfa:	00004697          	auipc	a3,0x4
ffffffffc0200bfe:	1f668693          	addi	a3,a3,502 # ffffffffc0204df0 <commands+0x750>
ffffffffc0200c02:	00004617          	auipc	a2,0x4
ffffffffc0200c06:	1c660613          	addi	a2,a2,454 # ffffffffc0204dc8 <commands+0x728>
ffffffffc0200c0a:	08400593          	li	a1,132
ffffffffc0200c0e:	00004517          	auipc	a0,0x4
ffffffffc0200c12:	1d250513          	addi	a0,a0,466 # ffffffffc0204de0 <commands+0x740>
ffffffffc0200c16:	cecff0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(prev->vm_end <= next->vm_start);
ffffffffc0200c1a:	00004697          	auipc	a3,0x4
ffffffffc0200c1e:	21668693          	addi	a3,a3,534 # ffffffffc0204e30 <commands+0x790>
ffffffffc0200c22:	00004617          	auipc	a2,0x4
ffffffffc0200c26:	1a660613          	addi	a2,a2,422 # ffffffffc0204dc8 <commands+0x728>
ffffffffc0200c2a:	07c00593          	li	a1,124
ffffffffc0200c2e:	00004517          	auipc	a0,0x4
ffffffffc0200c32:	1b250513          	addi	a0,a0,434 # ffffffffc0204de0 <commands+0x740>
ffffffffc0200c36:	cccff0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(prev->vm_start < prev->vm_end);
ffffffffc0200c3a:	00004697          	auipc	a3,0x4
ffffffffc0200c3e:	1d668693          	addi	a3,a3,470 # ffffffffc0204e10 <commands+0x770>
ffffffffc0200c42:	00004617          	auipc	a2,0x4
ffffffffc0200c46:	18660613          	addi	a2,a2,390 # ffffffffc0204dc8 <commands+0x728>
ffffffffc0200c4a:	07b00593          	li	a1,123
ffffffffc0200c4e:	00004517          	auipc	a0,0x4
ffffffffc0200c52:	19250513          	addi	a0,a0,402 # ffffffffc0204de0 <commands+0x740>
ffffffffc0200c56:	cacff0ef          	jal	ra,ffffffffc0200102 <__panic>

ffffffffc0200c5a <mm_destroy>:

// mm_destroy - free mm and mm internal fields
void
mm_destroy(struct mm_struct *mm) {
ffffffffc0200c5a:	1141                	addi	sp,sp,-16
ffffffffc0200c5c:	e022                	sd	s0,0(sp)
ffffffffc0200c5e:	842a                	mv	s0,a0
    return listelm->next;
ffffffffc0200c60:	6508                	ld	a0,8(a0)
ffffffffc0200c62:	e406                	sd	ra,8(sp)

    list_entry_t *list = &(mm->mmap_list), *le;
    while ((le = list_next(list)) != list) {
ffffffffc0200c64:	00a40e63          	beq	s0,a0,ffffffffc0200c80 <mm_destroy+0x26>
    __list_del(listelm->prev, listelm->next);
ffffffffc0200c68:	6118                	ld	a4,0(a0)
ffffffffc0200c6a:	651c                	ld	a5,8(a0)
        list_del(le);
        kfree(le2vma(le, list_link),sizeof(struct vma_struct));  //kfree vma        
ffffffffc0200c6c:	03000593          	li	a1,48
ffffffffc0200c70:	1501                	addi	a0,a0,-32
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
ffffffffc0200c72:	e71c                	sd	a5,8(a4)
    next->prev = prev;
ffffffffc0200c74:	e398                	sd	a4,0(a5)
ffffffffc0200c76:	016030ef          	jal	ra,ffffffffc0203c8c <kfree>
    return listelm->next;
ffffffffc0200c7a:	6408                	ld	a0,8(s0)
    while ((le = list_next(list)) != list) {
ffffffffc0200c7c:	fea416e3          	bne	s0,a0,ffffffffc0200c68 <mm_destroy+0xe>
    }
    kfree(mm, sizeof(struct mm_struct)); //kfree mm
ffffffffc0200c80:	8522                	mv	a0,s0
    mm=NULL;
}
ffffffffc0200c82:	6402                	ld	s0,0(sp)
ffffffffc0200c84:	60a2                	ld	ra,8(sp)
    kfree(mm, sizeof(struct mm_struct)); //kfree mm
ffffffffc0200c86:	03000593          	li	a1,48
}
ffffffffc0200c8a:	0141                	addi	sp,sp,16
    kfree(mm, sizeof(struct mm_struct)); //kfree mm
ffffffffc0200c8c:	0000306f          	j	ffffffffc0203c8c <kfree>

ffffffffc0200c90 <vmm_init>:

// vmm_init - initialize virtual memory management
//          - now just call check_vmm to check correctness of vmm
void
vmm_init(void) {
ffffffffc0200c90:	715d                	addi	sp,sp,-80
ffffffffc0200c92:	e486                	sd	ra,72(sp)
ffffffffc0200c94:	f44e                	sd	s3,40(sp)
ffffffffc0200c96:	f052                	sd	s4,32(sp)
ffffffffc0200c98:	e0a2                	sd	s0,64(sp)
ffffffffc0200c9a:	fc26                	sd	s1,56(sp)
ffffffffc0200c9c:	f84a                	sd	s2,48(sp)
ffffffffc0200c9e:	ec56                	sd	s5,24(sp)
ffffffffc0200ca0:	e85a                	sd	s6,16(sp)
ffffffffc0200ca2:	e45e                	sd	s7,8(sp)
}

// check_vmm - check correctness of vmm
static void
check_vmm(void) {
    size_t nr_free_pages_store = nr_free_pages();
ffffffffc0200ca4:	649010ef          	jal	ra,ffffffffc0202aec <nr_free_pages>
ffffffffc0200ca8:	89aa                	mv	s3,a0
    cprintf("check_vmm() succeeded.\n");
}

static void
check_vma_struct(void) {
    size_t nr_free_pages_store = nr_free_pages();
ffffffffc0200caa:	643010ef          	jal	ra,ffffffffc0202aec <nr_free_pages>
ffffffffc0200cae:	8a2a                	mv	s4,a0
    struct mm_struct *mm = kmalloc(sizeof(struct mm_struct));
ffffffffc0200cb0:	03000513          	li	a0,48
ffffffffc0200cb4:	71f020ef          	jal	ra,ffffffffc0203bd2 <kmalloc>
    if (mm != NULL) {
ffffffffc0200cb8:	56050863          	beqz	a0,ffffffffc0201228 <vmm_init+0x598>
    elm->prev = elm->next = elm;
ffffffffc0200cbc:	e508                	sd	a0,8(a0)
ffffffffc0200cbe:	e108                	sd	a0,0(a0)
        mm->mmap_cache = NULL;
ffffffffc0200cc0:	00053823          	sd	zero,16(a0)
        mm->pgdir = NULL;
ffffffffc0200cc4:	00053c23          	sd	zero,24(a0)
        mm->map_count = 0;
ffffffffc0200cc8:	02052023          	sw	zero,32(a0)
        if (swap_init_ok) swap_init_mm(mm);
ffffffffc0200ccc:	00011797          	auipc	a5,0x11
ffffffffc0200cd0:	8647a783          	lw	a5,-1948(a5) # ffffffffc0211530 <swap_init_ok>
ffffffffc0200cd4:	84aa                	mv	s1,a0
ffffffffc0200cd6:	e7b9                	bnez	a5,ffffffffc0200d24 <vmm_init+0x94>
        else mm->sm_priv = NULL;
ffffffffc0200cd8:	02053423          	sd	zero,40(a0)
vmm_init(void) {
ffffffffc0200cdc:	03200413          	li	s0,50
ffffffffc0200ce0:	a811                	j	ffffffffc0200cf4 <vmm_init+0x64>
        vma->vm_start = vm_start;
ffffffffc0200ce2:	e500                	sd	s0,8(a0)
        vma->vm_end = vm_end;
ffffffffc0200ce4:	e91c                	sd	a5,16(a0)
        vma->vm_flags = vm_flags;
ffffffffc0200ce6:	00053c23          	sd	zero,24(a0)
    assert(mm != NULL);

    int step1 = 10, step2 = step1 * 10;

    int i;
    for (i = step1; i >= 1; i --) {
ffffffffc0200cea:	146d                	addi	s0,s0,-5
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
        assert(vma != NULL);
        insert_vma_struct(mm, vma);
ffffffffc0200cec:	8526                	mv	a0,s1
ffffffffc0200cee:	e9dff0ef          	jal	ra,ffffffffc0200b8a <insert_vma_struct>
    for (i = step1; i >= 1; i --) {
ffffffffc0200cf2:	cc05                	beqz	s0,ffffffffc0200d2a <vmm_init+0x9a>
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
ffffffffc0200cf4:	03000513          	li	a0,48
ffffffffc0200cf8:	6db020ef          	jal	ra,ffffffffc0203bd2 <kmalloc>
ffffffffc0200cfc:	85aa                	mv	a1,a0
ffffffffc0200cfe:	00240793          	addi	a5,s0,2
    if (vma != NULL) {
ffffffffc0200d02:	f165                	bnez	a0,ffffffffc0200ce2 <vmm_init+0x52>
        assert(vma != NULL);
ffffffffc0200d04:	00004697          	auipc	a3,0x4
ffffffffc0200d08:	37c68693          	addi	a3,a3,892 # ffffffffc0205080 <commands+0x9e0>
ffffffffc0200d0c:	00004617          	auipc	a2,0x4
ffffffffc0200d10:	0bc60613          	addi	a2,a2,188 # ffffffffc0204dc8 <commands+0x728>
ffffffffc0200d14:	0ce00593          	li	a1,206
ffffffffc0200d18:	00004517          	auipc	a0,0x4
ffffffffc0200d1c:	0c850513          	addi	a0,a0,200 # ffffffffc0204de0 <commands+0x740>
ffffffffc0200d20:	be2ff0ef          	jal	ra,ffffffffc0200102 <__panic>
        if (swap_init_ok) swap_init_mm(mm);
ffffffffc0200d24:	4d3000ef          	jal	ra,ffffffffc02019f6 <swap_init_mm>
ffffffffc0200d28:	bf55                	j	ffffffffc0200cdc <vmm_init+0x4c>
ffffffffc0200d2a:	03700413          	li	s0,55
    }

    for (i = step1 + 1; i <= step2; i ++) {
ffffffffc0200d2e:	1f900913          	li	s2,505
ffffffffc0200d32:	a819                	j	ffffffffc0200d48 <vmm_init+0xb8>
        vma->vm_start = vm_start;
ffffffffc0200d34:	e500                	sd	s0,8(a0)
        vma->vm_end = vm_end;
ffffffffc0200d36:	e91c                	sd	a5,16(a0)
        vma->vm_flags = vm_flags;
ffffffffc0200d38:	00053c23          	sd	zero,24(a0)
    for (i = step1 + 1; i <= step2; i ++) {
ffffffffc0200d3c:	0415                	addi	s0,s0,5
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
        assert(vma != NULL);
        insert_vma_struct(mm, vma);
ffffffffc0200d3e:	8526                	mv	a0,s1
ffffffffc0200d40:	e4bff0ef          	jal	ra,ffffffffc0200b8a <insert_vma_struct>
    for (i = step1 + 1; i <= step2; i ++) {
ffffffffc0200d44:	03240a63          	beq	s0,s2,ffffffffc0200d78 <vmm_init+0xe8>
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
ffffffffc0200d48:	03000513          	li	a0,48
ffffffffc0200d4c:	687020ef          	jal	ra,ffffffffc0203bd2 <kmalloc>
ffffffffc0200d50:	85aa                	mv	a1,a0
ffffffffc0200d52:	00240793          	addi	a5,s0,2
    if (vma != NULL) {
ffffffffc0200d56:	fd79                	bnez	a0,ffffffffc0200d34 <vmm_init+0xa4>
        assert(vma != NULL);
ffffffffc0200d58:	00004697          	auipc	a3,0x4
ffffffffc0200d5c:	32868693          	addi	a3,a3,808 # ffffffffc0205080 <commands+0x9e0>
ffffffffc0200d60:	00004617          	auipc	a2,0x4
ffffffffc0200d64:	06860613          	addi	a2,a2,104 # ffffffffc0204dc8 <commands+0x728>
ffffffffc0200d68:	0d400593          	li	a1,212
ffffffffc0200d6c:	00004517          	auipc	a0,0x4
ffffffffc0200d70:	07450513          	addi	a0,a0,116 # ffffffffc0204de0 <commands+0x740>
ffffffffc0200d74:	b8eff0ef          	jal	ra,ffffffffc0200102 <__panic>
    return listelm->next;
ffffffffc0200d78:	649c                	ld	a5,8(s1)
ffffffffc0200d7a:	471d                	li	a4,7
    }

    list_entry_t *le = list_next(&(mm->mmap_list));

    for (i = 1; i <= step2; i ++) {
ffffffffc0200d7c:	1fb00593          	li	a1,507
        assert(le != &(mm->mmap_list));
ffffffffc0200d80:	2ef48463          	beq	s1,a5,ffffffffc0201068 <vmm_init+0x3d8>
        struct vma_struct *mmap = le2vma(le, list_link);
        assert(mmap->vm_start == i * 5 && mmap->vm_end == i * 5 + 2);
ffffffffc0200d84:	fe87b603          	ld	a2,-24(a5)
ffffffffc0200d88:	ffe70693          	addi	a3,a4,-2
ffffffffc0200d8c:	26d61e63          	bne	a2,a3,ffffffffc0201008 <vmm_init+0x378>
ffffffffc0200d90:	ff07b683          	ld	a3,-16(a5)
ffffffffc0200d94:	26e69a63          	bne	a3,a4,ffffffffc0201008 <vmm_init+0x378>
    for (i = 1; i <= step2; i ++) {
ffffffffc0200d98:	0715                	addi	a4,a4,5
ffffffffc0200d9a:	679c                	ld	a5,8(a5)
ffffffffc0200d9c:	feb712e3          	bne	a4,a1,ffffffffc0200d80 <vmm_init+0xf0>
ffffffffc0200da0:	4b1d                	li	s6,7
ffffffffc0200da2:	4415                	li	s0,5
        le = list_next(le);
    }

    for (i = 5; i <= 5 * step2; i +=5) {
ffffffffc0200da4:	1f900b93          	li	s7,505
        struct vma_struct *vma1 = find_vma(mm, i);
ffffffffc0200da8:	85a2                	mv	a1,s0
ffffffffc0200daa:	8526                	mv	a0,s1
ffffffffc0200dac:	d9fff0ef          	jal	ra,ffffffffc0200b4a <find_vma>
ffffffffc0200db0:	892a                	mv	s2,a0
        assert(vma1 != NULL);
ffffffffc0200db2:	2c050b63          	beqz	a0,ffffffffc0201088 <vmm_init+0x3f8>
        struct vma_struct *vma2 = find_vma(mm, i+1);
ffffffffc0200db6:	00140593          	addi	a1,s0,1
ffffffffc0200dba:	8526                	mv	a0,s1
ffffffffc0200dbc:	d8fff0ef          	jal	ra,ffffffffc0200b4a <find_vma>
ffffffffc0200dc0:	8aaa                	mv	s5,a0
        assert(vma2 != NULL);
ffffffffc0200dc2:	2e050363          	beqz	a0,ffffffffc02010a8 <vmm_init+0x418>
        struct vma_struct *vma3 = find_vma(mm, i+2);
ffffffffc0200dc6:	85da                	mv	a1,s6
ffffffffc0200dc8:	8526                	mv	a0,s1
ffffffffc0200dca:	d81ff0ef          	jal	ra,ffffffffc0200b4a <find_vma>
        assert(vma3 == NULL);
ffffffffc0200dce:	2e051d63          	bnez	a0,ffffffffc02010c8 <vmm_init+0x438>
        struct vma_struct *vma4 = find_vma(mm, i+3);
ffffffffc0200dd2:	00340593          	addi	a1,s0,3
ffffffffc0200dd6:	8526                	mv	a0,s1
ffffffffc0200dd8:	d73ff0ef          	jal	ra,ffffffffc0200b4a <find_vma>
        assert(vma4 == NULL);
ffffffffc0200ddc:	30051663          	bnez	a0,ffffffffc02010e8 <vmm_init+0x458>
        struct vma_struct *vma5 = find_vma(mm, i+4);
ffffffffc0200de0:	00440593          	addi	a1,s0,4
ffffffffc0200de4:	8526                	mv	a0,s1
ffffffffc0200de6:	d65ff0ef          	jal	ra,ffffffffc0200b4a <find_vma>
        assert(vma5 == NULL);
ffffffffc0200dea:	30051f63          	bnez	a0,ffffffffc0201108 <vmm_init+0x478>

        assert(vma1->vm_start == i  && vma1->vm_end == i  + 2);
ffffffffc0200dee:	00893783          	ld	a5,8(s2)
ffffffffc0200df2:	24879b63          	bne	a5,s0,ffffffffc0201048 <vmm_init+0x3b8>
ffffffffc0200df6:	01093783          	ld	a5,16(s2)
ffffffffc0200dfa:	25679763          	bne	a5,s6,ffffffffc0201048 <vmm_init+0x3b8>
        assert(vma2->vm_start == i  && vma2->vm_end == i  + 2);
ffffffffc0200dfe:	008ab783          	ld	a5,8(s5)
ffffffffc0200e02:	22879363          	bne	a5,s0,ffffffffc0201028 <vmm_init+0x398>
ffffffffc0200e06:	010ab783          	ld	a5,16(s5)
ffffffffc0200e0a:	21679f63          	bne	a5,s6,ffffffffc0201028 <vmm_init+0x398>
    for (i = 5; i <= 5 * step2; i +=5) {
ffffffffc0200e0e:	0415                	addi	s0,s0,5
ffffffffc0200e10:	0b15                	addi	s6,s6,5
ffffffffc0200e12:	f9741be3          	bne	s0,s7,ffffffffc0200da8 <vmm_init+0x118>
ffffffffc0200e16:	4411                	li	s0,4
    }

    for (i =4; i>=0; i--) {
ffffffffc0200e18:	597d                	li	s2,-1
        struct vma_struct *vma_below_5= find_vma(mm,i);
ffffffffc0200e1a:	85a2                	mv	a1,s0
ffffffffc0200e1c:	8526                	mv	a0,s1
ffffffffc0200e1e:	d2dff0ef          	jal	ra,ffffffffc0200b4a <find_vma>
ffffffffc0200e22:	0004059b          	sext.w	a1,s0
        if (vma_below_5 != NULL ) {
ffffffffc0200e26:	c90d                	beqz	a0,ffffffffc0200e58 <vmm_init+0x1c8>
           cprintf("vma_below_5: i %x, start %x, end %x\n",i, vma_below_5->vm_start, vma_below_5->vm_end); 
ffffffffc0200e28:	6914                	ld	a3,16(a0)
ffffffffc0200e2a:	6510                	ld	a2,8(a0)
ffffffffc0200e2c:	00004517          	auipc	a0,0x4
ffffffffc0200e30:	12450513          	addi	a0,a0,292 # ffffffffc0204f50 <commands+0x8b0>
ffffffffc0200e34:	a86ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
        }
        assert(vma_below_5 == NULL);
ffffffffc0200e38:	00004697          	auipc	a3,0x4
ffffffffc0200e3c:	14068693          	addi	a3,a3,320 # ffffffffc0204f78 <commands+0x8d8>
ffffffffc0200e40:	00004617          	auipc	a2,0x4
ffffffffc0200e44:	f8860613          	addi	a2,a2,-120 # ffffffffc0204dc8 <commands+0x728>
ffffffffc0200e48:	0f600593          	li	a1,246
ffffffffc0200e4c:	00004517          	auipc	a0,0x4
ffffffffc0200e50:	f9450513          	addi	a0,a0,-108 # ffffffffc0204de0 <commands+0x740>
ffffffffc0200e54:	aaeff0ef          	jal	ra,ffffffffc0200102 <__panic>
    for (i =4; i>=0; i--) {
ffffffffc0200e58:	147d                	addi	s0,s0,-1
ffffffffc0200e5a:	fd2410e3          	bne	s0,s2,ffffffffc0200e1a <vmm_init+0x18a>
ffffffffc0200e5e:	a811                	j	ffffffffc0200e72 <vmm_init+0x1e2>
    __list_del(listelm->prev, listelm->next);
ffffffffc0200e60:	6118                	ld	a4,0(a0)
ffffffffc0200e62:	651c                	ld	a5,8(a0)
        kfree(le2vma(le, list_link),sizeof(struct vma_struct));  //kfree vma        
ffffffffc0200e64:	03000593          	li	a1,48
ffffffffc0200e68:	1501                	addi	a0,a0,-32
    prev->next = next;
ffffffffc0200e6a:	e71c                	sd	a5,8(a4)
    next->prev = prev;
ffffffffc0200e6c:	e398                	sd	a4,0(a5)
ffffffffc0200e6e:	61f020ef          	jal	ra,ffffffffc0203c8c <kfree>
    return listelm->next;
ffffffffc0200e72:	6488                	ld	a0,8(s1)
    while ((le = list_next(list)) != list) {
ffffffffc0200e74:	fea496e3          	bne	s1,a0,ffffffffc0200e60 <vmm_init+0x1d0>
    kfree(mm, sizeof(struct mm_struct)); //kfree mm
ffffffffc0200e78:	03000593          	li	a1,48
ffffffffc0200e7c:	8526                	mv	a0,s1
ffffffffc0200e7e:	60f020ef          	jal	ra,ffffffffc0203c8c <kfree>
    }

    mm_destroy(mm);

    assert(nr_free_pages_store == nr_free_pages());
ffffffffc0200e82:	46b010ef          	jal	ra,ffffffffc0202aec <nr_free_pages>
ffffffffc0200e86:	3caa1163          	bne	s4,a0,ffffffffc0201248 <vmm_init+0x5b8>

    cprintf("check_vma_struct() succeeded!\n");
ffffffffc0200e8a:	00004517          	auipc	a0,0x4
ffffffffc0200e8e:	12e50513          	addi	a0,a0,302 # ffffffffc0204fb8 <commands+0x918>
ffffffffc0200e92:	a28ff0ef          	jal	ra,ffffffffc02000ba <cprintf>

// check_pgfault - check correctness of pgfault handler
static void
check_pgfault(void) {
	// char *name = "check_pgfault";
    size_t nr_free_pages_store = nr_free_pages();
ffffffffc0200e96:	457010ef          	jal	ra,ffffffffc0202aec <nr_free_pages>
ffffffffc0200e9a:	84aa                	mv	s1,a0
    struct mm_struct *mm = kmalloc(sizeof(struct mm_struct));
ffffffffc0200e9c:	03000513          	li	a0,48
ffffffffc0200ea0:	533020ef          	jal	ra,ffffffffc0203bd2 <kmalloc>
ffffffffc0200ea4:	842a                	mv	s0,a0
    if (mm != NULL) {
ffffffffc0200ea6:	2a050163          	beqz	a0,ffffffffc0201148 <vmm_init+0x4b8>
        if (swap_init_ok) swap_init_mm(mm);
ffffffffc0200eaa:	00010797          	auipc	a5,0x10
ffffffffc0200eae:	6867a783          	lw	a5,1670(a5) # ffffffffc0211530 <swap_init_ok>
    elm->prev = elm->next = elm;
ffffffffc0200eb2:	e508                	sd	a0,8(a0)
ffffffffc0200eb4:	e108                	sd	a0,0(a0)
        mm->mmap_cache = NULL;
ffffffffc0200eb6:	00053823          	sd	zero,16(a0)
        mm->pgdir = NULL;
ffffffffc0200eba:	00053c23          	sd	zero,24(a0)
        mm->map_count = 0;
ffffffffc0200ebe:	02052023          	sw	zero,32(a0)
        if (swap_init_ok) swap_init_mm(mm);
ffffffffc0200ec2:	14079063          	bnez	a5,ffffffffc0201002 <vmm_init+0x372>
        else mm->sm_priv = NULL;
ffffffffc0200ec6:	02053423          	sd	zero,40(a0)

    check_mm_struct = mm_create();

    assert(check_mm_struct != NULL);
    struct mm_struct *mm = check_mm_struct;
    pde_t *pgdir = mm->pgdir = boot_pgdir;
ffffffffc0200eca:	00010917          	auipc	s2,0x10
ffffffffc0200ece:	67e93903          	ld	s2,1662(s2) # ffffffffc0211548 <boot_pgdir>
    assert(pgdir[0] == 0);
ffffffffc0200ed2:	00093783          	ld	a5,0(s2)
    check_mm_struct = mm_create();
ffffffffc0200ed6:	00010717          	auipc	a4,0x10
ffffffffc0200eda:	62873d23          	sd	s0,1594(a4) # ffffffffc0211510 <check_mm_struct>
    pde_t *pgdir = mm->pgdir = boot_pgdir;
ffffffffc0200ede:	01243c23          	sd	s2,24(s0)
    assert(pgdir[0] == 0);
ffffffffc0200ee2:	24079363          	bnez	a5,ffffffffc0201128 <vmm_init+0x498>
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
ffffffffc0200ee6:	03000513          	li	a0,48
ffffffffc0200eea:	4e9020ef          	jal	ra,ffffffffc0203bd2 <kmalloc>
ffffffffc0200eee:	8a2a                	mv	s4,a0
    if (vma != NULL) {
ffffffffc0200ef0:	28050063          	beqz	a0,ffffffffc0201170 <vmm_init+0x4e0>
        vma->vm_end = vm_end;
ffffffffc0200ef4:	002007b7          	lui	a5,0x200
ffffffffc0200ef8:	00fa3823          	sd	a5,16(s4)
        vma->vm_flags = vm_flags;
ffffffffc0200efc:	4789                	li	a5,2

    struct vma_struct *vma = vma_create(0, PTSIZE, VM_WRITE);

    assert(vma != NULL);

    insert_vma_struct(mm, vma);
ffffffffc0200efe:	85aa                	mv	a1,a0
        vma->vm_flags = vm_flags;
ffffffffc0200f00:	00fa3c23          	sd	a5,24(s4)
    insert_vma_struct(mm, vma);
ffffffffc0200f04:	8522                	mv	a0,s0
        vma->vm_start = vm_start;
ffffffffc0200f06:	000a3423          	sd	zero,8(s4)
    insert_vma_struct(mm, vma);
ffffffffc0200f0a:	c81ff0ef          	jal	ra,ffffffffc0200b8a <insert_vma_struct>

    uintptr_t addr = 0x100;
    assert(find_vma(mm, addr) == vma);
ffffffffc0200f0e:	10000593          	li	a1,256
ffffffffc0200f12:	8522                	mv	a0,s0
ffffffffc0200f14:	c37ff0ef          	jal	ra,ffffffffc0200b4a <find_vma>
ffffffffc0200f18:	10000793          	li	a5,256

    int i, sum = 0;
    for (i = 0; i < 100; i ++) {
ffffffffc0200f1c:	16400713          	li	a4,356
    assert(find_vma(mm, addr) == vma);
ffffffffc0200f20:	26aa1863          	bne	s4,a0,ffffffffc0201190 <vmm_init+0x500>
        *(char *)(addr + i) = i;
ffffffffc0200f24:	00f78023          	sb	a5,0(a5) # 200000 <kern_entry-0xffffffffc0000000>
    for (i = 0; i < 100; i ++) {
ffffffffc0200f28:	0785                	addi	a5,a5,1
ffffffffc0200f2a:	fee79de3          	bne	a5,a4,ffffffffc0200f24 <vmm_init+0x294>
        sum += i;
ffffffffc0200f2e:	6705                	lui	a4,0x1
ffffffffc0200f30:	10000793          	li	a5,256
ffffffffc0200f34:	35670713          	addi	a4,a4,854 # 1356 <kern_entry-0xffffffffc01fecaa>
    }
    for (i = 0; i < 100; i ++) {
ffffffffc0200f38:	16400613          	li	a2,356
        sum -= *(char *)(addr + i);
ffffffffc0200f3c:	0007c683          	lbu	a3,0(a5)
    for (i = 0; i < 100; i ++) {
ffffffffc0200f40:	0785                	addi	a5,a5,1
        sum -= *(char *)(addr + i);
ffffffffc0200f42:	9f15                	subw	a4,a4,a3
    for (i = 0; i < 100; i ++) {
ffffffffc0200f44:	fec79ce3          	bne	a5,a2,ffffffffc0200f3c <vmm_init+0x2ac>
    }
    assert(sum == 0);
ffffffffc0200f48:	26071463          	bnez	a4,ffffffffc02011b0 <vmm_init+0x520>

    page_remove(pgdir, ROUNDDOWN(addr, PGSIZE));
ffffffffc0200f4c:	4581                	li	a1,0
ffffffffc0200f4e:	854a                	mv	a0,s2
ffffffffc0200f50:	627010ef          	jal	ra,ffffffffc0202d76 <page_remove>
    }
    return pa2page(PTE_ADDR(pte));
}

static inline struct Page *pde2page(pde_t pde) {
    return pa2page(PDE_ADDR(pde));
ffffffffc0200f54:	00093783          	ld	a5,0(s2)
    if (PPN(pa) >= npage) {
ffffffffc0200f58:	00010717          	auipc	a4,0x10
ffffffffc0200f5c:	5f873703          	ld	a4,1528(a4) # ffffffffc0211550 <npage>
    return pa2page(PDE_ADDR(pde));
ffffffffc0200f60:	078a                	slli	a5,a5,0x2
ffffffffc0200f62:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage) {
ffffffffc0200f64:	26e7f663          	bgeu	a5,a4,ffffffffc02011d0 <vmm_init+0x540>
    return &pages[PPN(pa) - nbase];
ffffffffc0200f68:	00005717          	auipc	a4,0x5
ffffffffc0200f6c:	2e873703          	ld	a4,744(a4) # ffffffffc0206250 <nbase>
ffffffffc0200f70:	8f99                	sub	a5,a5,a4
ffffffffc0200f72:	00379713          	slli	a4,a5,0x3
ffffffffc0200f76:	97ba                	add	a5,a5,a4
ffffffffc0200f78:	078e                	slli	a5,a5,0x3

    free_page(pde2page(pgdir[0]));
ffffffffc0200f7a:	00010517          	auipc	a0,0x10
ffffffffc0200f7e:	5de53503          	ld	a0,1502(a0) # ffffffffc0211558 <pages>
ffffffffc0200f82:	953e                	add	a0,a0,a5
ffffffffc0200f84:	4585                	li	a1,1
ffffffffc0200f86:	327010ef          	jal	ra,ffffffffc0202aac <free_pages>
    return listelm->next;
ffffffffc0200f8a:	6408                	ld	a0,8(s0)

    pgdir[0] = 0;
ffffffffc0200f8c:	00093023          	sd	zero,0(s2)

    mm->pgdir = NULL;
ffffffffc0200f90:	00043c23          	sd	zero,24(s0)
    while ((le = list_next(list)) != list) {
ffffffffc0200f94:	00a40e63          	beq	s0,a0,ffffffffc0200fb0 <vmm_init+0x320>
    __list_del(listelm->prev, listelm->next);
ffffffffc0200f98:	6118                	ld	a4,0(a0)
ffffffffc0200f9a:	651c                	ld	a5,8(a0)
        kfree(le2vma(le, list_link),sizeof(struct vma_struct));  //kfree vma        
ffffffffc0200f9c:	03000593          	li	a1,48
ffffffffc0200fa0:	1501                	addi	a0,a0,-32
    prev->next = next;
ffffffffc0200fa2:	e71c                	sd	a5,8(a4)
    next->prev = prev;
ffffffffc0200fa4:	e398                	sd	a4,0(a5)
ffffffffc0200fa6:	4e7020ef          	jal	ra,ffffffffc0203c8c <kfree>
    return listelm->next;
ffffffffc0200faa:	6408                	ld	a0,8(s0)
    while ((le = list_next(list)) != list) {
ffffffffc0200fac:	fea416e3          	bne	s0,a0,ffffffffc0200f98 <vmm_init+0x308>
    kfree(mm, sizeof(struct mm_struct)); //kfree mm
ffffffffc0200fb0:	03000593          	li	a1,48
ffffffffc0200fb4:	8522                	mv	a0,s0
ffffffffc0200fb6:	4d7020ef          	jal	ra,ffffffffc0203c8c <kfree>
    mm_destroy(mm);

    check_mm_struct = NULL;
    nr_free_pages_store--;	// szx : Sv39第二级页表多占了一个内存页，所以执行此操作
ffffffffc0200fba:	14fd                	addi	s1,s1,-1
    check_mm_struct = NULL;
ffffffffc0200fbc:	00010797          	auipc	a5,0x10
ffffffffc0200fc0:	5407ba23          	sd	zero,1364(a5) # ffffffffc0211510 <check_mm_struct>

    assert(nr_free_pages_store == nr_free_pages());
ffffffffc0200fc4:	329010ef          	jal	ra,ffffffffc0202aec <nr_free_pages>
ffffffffc0200fc8:	22a49063          	bne	s1,a0,ffffffffc02011e8 <vmm_init+0x558>

    cprintf("check_pgfault() succeeded!\n");
ffffffffc0200fcc:	00004517          	auipc	a0,0x4
ffffffffc0200fd0:	07c50513          	addi	a0,a0,124 # ffffffffc0205048 <commands+0x9a8>
ffffffffc0200fd4:	8e6ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    assert(nr_free_pages_store == nr_free_pages());
ffffffffc0200fd8:	315010ef          	jal	ra,ffffffffc0202aec <nr_free_pages>
    nr_free_pages_store--;	// szx : Sv39三级页表多占一个内存页，所以执行此操作
ffffffffc0200fdc:	19fd                	addi	s3,s3,-1
    assert(nr_free_pages_store == nr_free_pages());
ffffffffc0200fde:	22a99563          	bne	s3,a0,ffffffffc0201208 <vmm_init+0x578>
}
ffffffffc0200fe2:	6406                	ld	s0,64(sp)
ffffffffc0200fe4:	60a6                	ld	ra,72(sp)
ffffffffc0200fe6:	74e2                	ld	s1,56(sp)
ffffffffc0200fe8:	7942                	ld	s2,48(sp)
ffffffffc0200fea:	79a2                	ld	s3,40(sp)
ffffffffc0200fec:	7a02                	ld	s4,32(sp)
ffffffffc0200fee:	6ae2                	ld	s5,24(sp)
ffffffffc0200ff0:	6b42                	ld	s6,16(sp)
ffffffffc0200ff2:	6ba2                	ld	s7,8(sp)
    cprintf("check_vmm() succeeded.\n");
ffffffffc0200ff4:	00004517          	auipc	a0,0x4
ffffffffc0200ff8:	07450513          	addi	a0,a0,116 # ffffffffc0205068 <commands+0x9c8>
}
ffffffffc0200ffc:	6161                	addi	sp,sp,80
    cprintf("check_vmm() succeeded.\n");
ffffffffc0200ffe:	8bcff06f          	j	ffffffffc02000ba <cprintf>
        if (swap_init_ok) swap_init_mm(mm);
ffffffffc0201002:	1f5000ef          	jal	ra,ffffffffc02019f6 <swap_init_mm>
ffffffffc0201006:	b5d1                	j	ffffffffc0200eca <vmm_init+0x23a>
        assert(mmap->vm_start == i * 5 && mmap->vm_end == i * 5 + 2);
ffffffffc0201008:	00004697          	auipc	a3,0x4
ffffffffc020100c:	e6068693          	addi	a3,a3,-416 # ffffffffc0204e68 <commands+0x7c8>
ffffffffc0201010:	00004617          	auipc	a2,0x4
ffffffffc0201014:	db860613          	addi	a2,a2,-584 # ffffffffc0204dc8 <commands+0x728>
ffffffffc0201018:	0dd00593          	li	a1,221
ffffffffc020101c:	00004517          	auipc	a0,0x4
ffffffffc0201020:	dc450513          	addi	a0,a0,-572 # ffffffffc0204de0 <commands+0x740>
ffffffffc0201024:	8deff0ef          	jal	ra,ffffffffc0200102 <__panic>
        assert(vma2->vm_start == i  && vma2->vm_end == i  + 2);
ffffffffc0201028:	00004697          	auipc	a3,0x4
ffffffffc020102c:	ef868693          	addi	a3,a3,-264 # ffffffffc0204f20 <commands+0x880>
ffffffffc0201030:	00004617          	auipc	a2,0x4
ffffffffc0201034:	d9860613          	addi	a2,a2,-616 # ffffffffc0204dc8 <commands+0x728>
ffffffffc0201038:	0ee00593          	li	a1,238
ffffffffc020103c:	00004517          	auipc	a0,0x4
ffffffffc0201040:	da450513          	addi	a0,a0,-604 # ffffffffc0204de0 <commands+0x740>
ffffffffc0201044:	8beff0ef          	jal	ra,ffffffffc0200102 <__panic>
        assert(vma1->vm_start == i  && vma1->vm_end == i  + 2);
ffffffffc0201048:	00004697          	auipc	a3,0x4
ffffffffc020104c:	ea868693          	addi	a3,a3,-344 # ffffffffc0204ef0 <commands+0x850>
ffffffffc0201050:	00004617          	auipc	a2,0x4
ffffffffc0201054:	d7860613          	addi	a2,a2,-648 # ffffffffc0204dc8 <commands+0x728>
ffffffffc0201058:	0ed00593          	li	a1,237
ffffffffc020105c:	00004517          	auipc	a0,0x4
ffffffffc0201060:	d8450513          	addi	a0,a0,-636 # ffffffffc0204de0 <commands+0x740>
ffffffffc0201064:	89eff0ef          	jal	ra,ffffffffc0200102 <__panic>
        assert(le != &(mm->mmap_list));
ffffffffc0201068:	00004697          	auipc	a3,0x4
ffffffffc020106c:	de868693          	addi	a3,a3,-536 # ffffffffc0204e50 <commands+0x7b0>
ffffffffc0201070:	00004617          	auipc	a2,0x4
ffffffffc0201074:	d5860613          	addi	a2,a2,-680 # ffffffffc0204dc8 <commands+0x728>
ffffffffc0201078:	0db00593          	li	a1,219
ffffffffc020107c:	00004517          	auipc	a0,0x4
ffffffffc0201080:	d6450513          	addi	a0,a0,-668 # ffffffffc0204de0 <commands+0x740>
ffffffffc0201084:	87eff0ef          	jal	ra,ffffffffc0200102 <__panic>
        assert(vma1 != NULL);
ffffffffc0201088:	00004697          	auipc	a3,0x4
ffffffffc020108c:	e1868693          	addi	a3,a3,-488 # ffffffffc0204ea0 <commands+0x800>
ffffffffc0201090:	00004617          	auipc	a2,0x4
ffffffffc0201094:	d3860613          	addi	a2,a2,-712 # ffffffffc0204dc8 <commands+0x728>
ffffffffc0201098:	0e300593          	li	a1,227
ffffffffc020109c:	00004517          	auipc	a0,0x4
ffffffffc02010a0:	d4450513          	addi	a0,a0,-700 # ffffffffc0204de0 <commands+0x740>
ffffffffc02010a4:	85eff0ef          	jal	ra,ffffffffc0200102 <__panic>
        assert(vma2 != NULL);
ffffffffc02010a8:	00004697          	auipc	a3,0x4
ffffffffc02010ac:	e0868693          	addi	a3,a3,-504 # ffffffffc0204eb0 <commands+0x810>
ffffffffc02010b0:	00004617          	auipc	a2,0x4
ffffffffc02010b4:	d1860613          	addi	a2,a2,-744 # ffffffffc0204dc8 <commands+0x728>
ffffffffc02010b8:	0e500593          	li	a1,229
ffffffffc02010bc:	00004517          	auipc	a0,0x4
ffffffffc02010c0:	d2450513          	addi	a0,a0,-732 # ffffffffc0204de0 <commands+0x740>
ffffffffc02010c4:	83eff0ef          	jal	ra,ffffffffc0200102 <__panic>
        assert(vma3 == NULL);
ffffffffc02010c8:	00004697          	auipc	a3,0x4
ffffffffc02010cc:	df868693          	addi	a3,a3,-520 # ffffffffc0204ec0 <commands+0x820>
ffffffffc02010d0:	00004617          	auipc	a2,0x4
ffffffffc02010d4:	cf860613          	addi	a2,a2,-776 # ffffffffc0204dc8 <commands+0x728>
ffffffffc02010d8:	0e700593          	li	a1,231
ffffffffc02010dc:	00004517          	auipc	a0,0x4
ffffffffc02010e0:	d0450513          	addi	a0,a0,-764 # ffffffffc0204de0 <commands+0x740>
ffffffffc02010e4:	81eff0ef          	jal	ra,ffffffffc0200102 <__panic>
        assert(vma4 == NULL);
ffffffffc02010e8:	00004697          	auipc	a3,0x4
ffffffffc02010ec:	de868693          	addi	a3,a3,-536 # ffffffffc0204ed0 <commands+0x830>
ffffffffc02010f0:	00004617          	auipc	a2,0x4
ffffffffc02010f4:	cd860613          	addi	a2,a2,-808 # ffffffffc0204dc8 <commands+0x728>
ffffffffc02010f8:	0e900593          	li	a1,233
ffffffffc02010fc:	00004517          	auipc	a0,0x4
ffffffffc0201100:	ce450513          	addi	a0,a0,-796 # ffffffffc0204de0 <commands+0x740>
ffffffffc0201104:	ffffe0ef          	jal	ra,ffffffffc0200102 <__panic>
        assert(vma5 == NULL);
ffffffffc0201108:	00004697          	auipc	a3,0x4
ffffffffc020110c:	dd868693          	addi	a3,a3,-552 # ffffffffc0204ee0 <commands+0x840>
ffffffffc0201110:	00004617          	auipc	a2,0x4
ffffffffc0201114:	cb860613          	addi	a2,a2,-840 # ffffffffc0204dc8 <commands+0x728>
ffffffffc0201118:	0eb00593          	li	a1,235
ffffffffc020111c:	00004517          	auipc	a0,0x4
ffffffffc0201120:	cc450513          	addi	a0,a0,-828 # ffffffffc0204de0 <commands+0x740>
ffffffffc0201124:	fdffe0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(pgdir[0] == 0);
ffffffffc0201128:	00004697          	auipc	a3,0x4
ffffffffc020112c:	eb068693          	addi	a3,a3,-336 # ffffffffc0204fd8 <commands+0x938>
ffffffffc0201130:	00004617          	auipc	a2,0x4
ffffffffc0201134:	c9860613          	addi	a2,a2,-872 # ffffffffc0204dc8 <commands+0x728>
ffffffffc0201138:	10d00593          	li	a1,269
ffffffffc020113c:	00004517          	auipc	a0,0x4
ffffffffc0201140:	ca450513          	addi	a0,a0,-860 # ffffffffc0204de0 <commands+0x740>
ffffffffc0201144:	fbffe0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(check_mm_struct != NULL);
ffffffffc0201148:	00004697          	auipc	a3,0x4
ffffffffc020114c:	f4868693          	addi	a3,a3,-184 # ffffffffc0205090 <commands+0x9f0>
ffffffffc0201150:	00004617          	auipc	a2,0x4
ffffffffc0201154:	c7860613          	addi	a2,a2,-904 # ffffffffc0204dc8 <commands+0x728>
ffffffffc0201158:	10a00593          	li	a1,266
ffffffffc020115c:	00004517          	auipc	a0,0x4
ffffffffc0201160:	c8450513          	addi	a0,a0,-892 # ffffffffc0204de0 <commands+0x740>
    check_mm_struct = mm_create();
ffffffffc0201164:	00010797          	auipc	a5,0x10
ffffffffc0201168:	3a07b623          	sd	zero,940(a5) # ffffffffc0211510 <check_mm_struct>
    assert(check_mm_struct != NULL);
ffffffffc020116c:	f97fe0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(vma != NULL);
ffffffffc0201170:	00004697          	auipc	a3,0x4
ffffffffc0201174:	f1068693          	addi	a3,a3,-240 # ffffffffc0205080 <commands+0x9e0>
ffffffffc0201178:	00004617          	auipc	a2,0x4
ffffffffc020117c:	c5060613          	addi	a2,a2,-944 # ffffffffc0204dc8 <commands+0x728>
ffffffffc0201180:	11100593          	li	a1,273
ffffffffc0201184:	00004517          	auipc	a0,0x4
ffffffffc0201188:	c5c50513          	addi	a0,a0,-932 # ffffffffc0204de0 <commands+0x740>
ffffffffc020118c:	f77fe0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(find_vma(mm, addr) == vma);
ffffffffc0201190:	00004697          	auipc	a3,0x4
ffffffffc0201194:	e5868693          	addi	a3,a3,-424 # ffffffffc0204fe8 <commands+0x948>
ffffffffc0201198:	00004617          	auipc	a2,0x4
ffffffffc020119c:	c3060613          	addi	a2,a2,-976 # ffffffffc0204dc8 <commands+0x728>
ffffffffc02011a0:	11600593          	li	a1,278
ffffffffc02011a4:	00004517          	auipc	a0,0x4
ffffffffc02011a8:	c3c50513          	addi	a0,a0,-964 # ffffffffc0204de0 <commands+0x740>
ffffffffc02011ac:	f57fe0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(sum == 0);
ffffffffc02011b0:	00004697          	auipc	a3,0x4
ffffffffc02011b4:	e5868693          	addi	a3,a3,-424 # ffffffffc0205008 <commands+0x968>
ffffffffc02011b8:	00004617          	auipc	a2,0x4
ffffffffc02011bc:	c1060613          	addi	a2,a2,-1008 # ffffffffc0204dc8 <commands+0x728>
ffffffffc02011c0:	12000593          	li	a1,288
ffffffffc02011c4:	00004517          	auipc	a0,0x4
ffffffffc02011c8:	c1c50513          	addi	a0,a0,-996 # ffffffffc0204de0 <commands+0x740>
ffffffffc02011cc:	f37fe0ef          	jal	ra,ffffffffc0200102 <__panic>
        panic("pa2page called with invalid pa");
ffffffffc02011d0:	00004617          	auipc	a2,0x4
ffffffffc02011d4:	e4860613          	addi	a2,a2,-440 # ffffffffc0205018 <commands+0x978>
ffffffffc02011d8:	06500593          	li	a1,101
ffffffffc02011dc:	00004517          	auipc	a0,0x4
ffffffffc02011e0:	e5c50513          	addi	a0,a0,-420 # ffffffffc0205038 <commands+0x998>
ffffffffc02011e4:	f1ffe0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(nr_free_pages_store == nr_free_pages());
ffffffffc02011e8:	00004697          	auipc	a3,0x4
ffffffffc02011ec:	da868693          	addi	a3,a3,-600 # ffffffffc0204f90 <commands+0x8f0>
ffffffffc02011f0:	00004617          	auipc	a2,0x4
ffffffffc02011f4:	bd860613          	addi	a2,a2,-1064 # ffffffffc0204dc8 <commands+0x728>
ffffffffc02011f8:	12e00593          	li	a1,302
ffffffffc02011fc:	00004517          	auipc	a0,0x4
ffffffffc0201200:	be450513          	addi	a0,a0,-1052 # ffffffffc0204de0 <commands+0x740>
ffffffffc0201204:	efffe0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(nr_free_pages_store == nr_free_pages());
ffffffffc0201208:	00004697          	auipc	a3,0x4
ffffffffc020120c:	d8868693          	addi	a3,a3,-632 # ffffffffc0204f90 <commands+0x8f0>
ffffffffc0201210:	00004617          	auipc	a2,0x4
ffffffffc0201214:	bb860613          	addi	a2,a2,-1096 # ffffffffc0204dc8 <commands+0x728>
ffffffffc0201218:	0bd00593          	li	a1,189
ffffffffc020121c:	00004517          	auipc	a0,0x4
ffffffffc0201220:	bc450513          	addi	a0,a0,-1084 # ffffffffc0204de0 <commands+0x740>
ffffffffc0201224:	edffe0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(mm != NULL);
ffffffffc0201228:	00004697          	auipc	a3,0x4
ffffffffc020122c:	e8068693          	addi	a3,a3,-384 # ffffffffc02050a8 <commands+0xa08>
ffffffffc0201230:	00004617          	auipc	a2,0x4
ffffffffc0201234:	b9860613          	addi	a2,a2,-1128 # ffffffffc0204dc8 <commands+0x728>
ffffffffc0201238:	0c700593          	li	a1,199
ffffffffc020123c:	00004517          	auipc	a0,0x4
ffffffffc0201240:	ba450513          	addi	a0,a0,-1116 # ffffffffc0204de0 <commands+0x740>
ffffffffc0201244:	ebffe0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(nr_free_pages_store == nr_free_pages());
ffffffffc0201248:	00004697          	auipc	a3,0x4
ffffffffc020124c:	d4868693          	addi	a3,a3,-696 # ffffffffc0204f90 <commands+0x8f0>
ffffffffc0201250:	00004617          	auipc	a2,0x4
ffffffffc0201254:	b7860613          	addi	a2,a2,-1160 # ffffffffc0204dc8 <commands+0x728>
ffffffffc0201258:	0fb00593          	li	a1,251
ffffffffc020125c:	00004517          	auipc	a0,0x4
ffffffffc0201260:	b8450513          	addi	a0,a0,-1148 # ffffffffc0204de0 <commands+0x740>
ffffffffc0201264:	e9ffe0ef          	jal	ra,ffffffffc0200102 <__panic>

ffffffffc0201268 <do_pgfault>:
 *            was a read (0) or write (1).
 *         -- The U/S flag (bit 2) indicates whether the processor was executing at user mode (1)
 *            or supervisor mode (0) at the time of the exception.
 */
int
do_pgfault(struct mm_struct *mm, uint_t error_code, uintptr_t addr) {//
ffffffffc0201268:	7179                	addi	sp,sp,-48
    int ret = -E_INVAL;
    //try to find a vma which include addr
    struct vma_struct *vma = find_vma(mm, addr);
ffffffffc020126a:	85b2                	mv	a1,a2
do_pgfault(struct mm_struct *mm, uint_t error_code, uintptr_t addr) {//
ffffffffc020126c:	f022                	sd	s0,32(sp)
ffffffffc020126e:	ec26                	sd	s1,24(sp)
ffffffffc0201270:	f406                	sd	ra,40(sp)
ffffffffc0201272:	e84a                	sd	s2,16(sp)
ffffffffc0201274:	8432                	mv	s0,a2
ffffffffc0201276:	84aa                	mv	s1,a0
    struct vma_struct *vma = find_vma(mm, addr);
ffffffffc0201278:	8d3ff0ef          	jal	ra,ffffffffc0200b4a <find_vma>

    pgfault_num++;
ffffffffc020127c:	00010797          	auipc	a5,0x10
ffffffffc0201280:	29c7a783          	lw	a5,668(a5) # ffffffffc0211518 <pgfault_num>
ffffffffc0201284:	2785                	addiw	a5,a5,1
ffffffffc0201286:	00010717          	auipc	a4,0x10
ffffffffc020128a:	28f72923          	sw	a5,658(a4) # ffffffffc0211518 <pgfault_num>
    //If the addr is in the range of a mm's vma?
    if (vma == NULL || vma->vm_start > addr) {
ffffffffc020128e:	0c050e63          	beqz	a0,ffffffffc020136a <do_pgfault+0x102>
ffffffffc0201292:	651c                	ld	a5,8(a0)
ffffffffc0201294:	0cf46b63          	bltu	s0,a5,ffffffffc020136a <do_pgfault+0x102>
     * THEN 
     *    continue process
     */
    
    uint32_t perm = PTE_U;
    if (vma->vm_flags & VM_WRITE) {
ffffffffc0201298:	6d1c                	ld	a5,24(a0)
    uint32_t perm = PTE_U;
ffffffffc020129a:	4941                	li	s2,16
    if (vma->vm_flags & VM_WRITE) {
ffffffffc020129c:	8b89                	andi	a5,a5,2
ffffffffc020129e:	e7a9                	bnez	a5,ffffffffc02012e8 <do_pgfault+0x80>
        perm |= (PTE_R | PTE_W);
    }
    addr = ROUNDDOWN(addr, PGSIZE);
ffffffffc02012a0:	75fd                	lui	a1,0xfffff
    *   mm->pgdir : the PDT of these vma
    *
    */


    ptep = get_pte(mm->pgdir, addr, 1);  //(1) try to find a pte, if pte's
ffffffffc02012a2:	6c88                	ld	a0,24(s1)
    addr = ROUNDDOWN(addr, PGSIZE);
ffffffffc02012a4:	8c6d                	and	s0,s0,a1
    ptep = get_pte(mm->pgdir, addr, 1);  //(1) try to find a pte, if pte's
ffffffffc02012a6:	85a2                	mv	a1,s0
ffffffffc02012a8:	4605                	li	a2,1
ffffffffc02012aa:	07d010ef          	jal	ra,ffffffffc0202b26 <get_pte>
                                         //PT(Page Table) isn't existed, then
                                         //create a PT.
    if (*ptep == 0) {
ffffffffc02012ae:	610c                	ld	a1,0(a0)
ffffffffc02012b0:	cda5                	beqz	a1,ffffffffc0201328 <do_pgfault+0xc0>
        *    swap_in(mm, addr, &page) : 分配一个内存页，然后根据
        *    PTE中的swap条目的addr，找到磁盘页的地址，将磁盘页的内容读入这个内存页
        *    page_insert ： 建立一个Page的phy addr与线性addr la的映射
        *    swap_map_swappable ： 设置页面可交换
        */
        if (swap_init_ok) {
ffffffffc02012b2:	00010797          	auipc	a5,0x10
ffffffffc02012b6:	27e7a783          	lw	a5,638(a5) # ffffffffc0211530 <swap_init_ok>
ffffffffc02012ba:	c3e9                	beqz	a5,ffffffffc020137c <do_pgfault+0x114>
            struct Page *page = NULL;
            // 你要编写的内容在这里，请基于上文说明以及下文的英文注释完成代码编写
            //(1）According to the mm AND addr, try
            //to load the content of right disk page
            //into the memory which page managed.
            swap_in(mm,addr,&page);
ffffffffc02012bc:	85a2                	mv	a1,s0
ffffffffc02012be:	0030                	addi	a2,sp,8
ffffffffc02012c0:	8526                	mv	a0,s1
            struct Page *page = NULL;
ffffffffc02012c2:	e402                	sd	zero,8(sp)
            swap_in(mm,addr,&page);
ffffffffc02012c4:	05f000ef          	jal	ra,ffffffffc0201b22 <swap_in>
            //(2) According to the mm,
            //addr AND page, setup the
            //map of phy addr <--->
            //logical addr
            if(ret=page_insert(mm->pgdir,page,addr,perm)!=0)
ffffffffc02012c8:	65a2                	ld	a1,8(sp)
ffffffffc02012ca:	6c88                	ld	a0,24(s1)
ffffffffc02012cc:	86ca                	mv	a3,s2
ffffffffc02012ce:	8622                	mv	a2,s0
ffffffffc02012d0:	341010ef          	jal	ra,ffffffffc0202e10 <page_insert>
ffffffffc02012d4:	892a                	mv	s2,a0
ffffffffc02012d6:	c919                	beqz	a0,ffffffffc02012ec <do_pgfault+0x84>
            {
                return ret;
ffffffffc02012d8:	4905                	li	s2,1
   }

   ret = 0;
failed:
    return ret;
}
ffffffffc02012da:	70a2                	ld	ra,40(sp)
ffffffffc02012dc:	7402                	ld	s0,32(sp)
ffffffffc02012de:	64e2                	ld	s1,24(sp)
ffffffffc02012e0:	854a                	mv	a0,s2
ffffffffc02012e2:	6942                	ld	s2,16(sp)
ffffffffc02012e4:	6145                	addi	sp,sp,48
ffffffffc02012e6:	8082                	ret
        perm |= (PTE_R | PTE_W);
ffffffffc02012e8:	4959                	li	s2,22
ffffffffc02012ea:	bf5d                	j	ffffffffc02012a0 <do_pgfault+0x38>
            swap_map_swappable(mm,addr,page,0);
ffffffffc02012ec:	6622                	ld	a2,8(sp)
ffffffffc02012ee:	4681                	li	a3,0
ffffffffc02012f0:	85a2                	mv	a1,s0
ffffffffc02012f2:	8526                	mv	a0,s1
ffffffffc02012f4:	70e000ef          	jal	ra,ffffffffc0201a02 <swap_map_swappable>
            if(*get_pte(mm->pgdir, page->pra_vaddr, 1)&PTE_V)
ffffffffc02012f8:	67a2                	ld	a5,8(sp)
ffffffffc02012fa:	6c88                	ld	a0,24(s1)
ffffffffc02012fc:	4605                	li	a2,1
ffffffffc02012fe:	63ac                	ld	a1,64(a5)
ffffffffc0201300:	027010ef          	jal	ra,ffffffffc0202b26 <get_pte>
ffffffffc0201304:	611c                	ld	a5,0(a0)
ffffffffc0201306:	8b85                	andi	a5,a5,1
ffffffffc0201308:	ef9d                	bnez	a5,ffffffffc0201346 <do_pgfault+0xde>
                cprintf("have changed");
ffffffffc020130a:	00004517          	auipc	a0,0x4
ffffffffc020130e:	e1e50513          	addi	a0,a0,-482 # ffffffffc0205128 <commands+0xa88>
ffffffffc0201312:	da9fe0ef          	jal	ra,ffffffffc02000ba <cprintf>
            page->pra_vaddr = addr;
ffffffffc0201316:	67a2                	ld	a5,8(sp)
}
ffffffffc0201318:	70a2                	ld	ra,40(sp)
ffffffffc020131a:	64e2                	ld	s1,24(sp)
            page->pra_vaddr = addr;
ffffffffc020131c:	e3a0                	sd	s0,64(a5)
}
ffffffffc020131e:	7402                	ld	s0,32(sp)
ffffffffc0201320:	854a                	mv	a0,s2
ffffffffc0201322:	6942                	ld	s2,16(sp)
ffffffffc0201324:	6145                	addi	sp,sp,48
ffffffffc0201326:	8082                	ret
        if (pgdir_alloc_page(mm->pgdir, addr, perm) == NULL) {
ffffffffc0201328:	6c88                	ld	a0,24(s1)
ffffffffc020132a:	864a                	mv	a2,s2
ffffffffc020132c:	85a2                	mv	a1,s0
ffffffffc020132e:	7ec020ef          	jal	ra,ffffffffc0203b1a <pgdir_alloc_page>
   ret = 0;
ffffffffc0201332:	4901                	li	s2,0
        if (pgdir_alloc_page(mm->pgdir, addr, perm) == NULL) {
ffffffffc0201334:	f15d                	bnez	a0,ffffffffc02012da <do_pgfault+0x72>
            cprintf("pgdir_alloc_page in do_pgfault failed\n");
ffffffffc0201336:	00004517          	auipc	a0,0x4
ffffffffc020133a:	db250513          	addi	a0,a0,-590 # ffffffffc02050e8 <commands+0xa48>
ffffffffc020133e:	d7dfe0ef          	jal	ra,ffffffffc02000ba <cprintf>
    ret = -E_NO_MEM;
ffffffffc0201342:	5971                	li	s2,-4
            goto failed;
ffffffffc0201344:	bf59                	j	ffffffffc02012da <do_pgfault+0x72>
                *get_pte(mm->pgdir, page->pra_vaddr, 1)^=PTE_V;
ffffffffc0201346:	67a2                	ld	a5,8(sp)
ffffffffc0201348:	6c88                	ld	a0,24(s1)
ffffffffc020134a:	4605                	li	a2,1
ffffffffc020134c:	63ac                	ld	a1,64(a5)
ffffffffc020134e:	7d8010ef          	jal	ra,ffffffffc0202b26 <get_pte>
ffffffffc0201352:	6118                	ld	a4,0(a0)
ffffffffc0201354:	87aa                	mv	a5,a0
                cprintf("change by my hand");
ffffffffc0201356:	00004517          	auipc	a0,0x4
ffffffffc020135a:	dba50513          	addi	a0,a0,-582 # ffffffffc0205110 <commands+0xa70>
                *get_pte(mm->pgdir, page->pra_vaddr, 1)^=PTE_V;
ffffffffc020135e:	00174713          	xori	a4,a4,1
ffffffffc0201362:	e398                	sd	a4,0(a5)
                cprintf("change by my hand");
ffffffffc0201364:	d57fe0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc0201368:	b77d                	j	ffffffffc0201316 <do_pgfault+0xae>
        cprintf("not valid addr %x, and  can not find it in vma\n", addr);
ffffffffc020136a:	85a2                	mv	a1,s0
ffffffffc020136c:	00004517          	auipc	a0,0x4
ffffffffc0201370:	d4c50513          	addi	a0,a0,-692 # ffffffffc02050b8 <commands+0xa18>
ffffffffc0201374:	d47fe0ef          	jal	ra,ffffffffc02000ba <cprintf>
    int ret = -E_INVAL;
ffffffffc0201378:	5975                	li	s2,-3
        goto failed;
ffffffffc020137a:	b785                	j	ffffffffc02012da <do_pgfault+0x72>
            cprintf("no swap_init_ok but ptep is %x, failed\n", *ptep);
ffffffffc020137c:	00004517          	auipc	a0,0x4
ffffffffc0201380:	dbc50513          	addi	a0,a0,-580 # ffffffffc0205138 <commands+0xa98>
ffffffffc0201384:	d37fe0ef          	jal	ra,ffffffffc02000ba <cprintf>
    ret = -E_NO_MEM;
ffffffffc0201388:	5971                	li	s2,-4
            goto failed;
ffffffffc020138a:	bf81                	j	ffffffffc02012da <do_pgfault+0x72>

ffffffffc020138c <swap_init>:

static void check_swap(void);

int
swap_init(void)
{
ffffffffc020138c:	7135                	addi	sp,sp,-160
ffffffffc020138e:	ed06                	sd	ra,152(sp)
ffffffffc0201390:	e922                	sd	s0,144(sp)
ffffffffc0201392:	e526                	sd	s1,136(sp)
ffffffffc0201394:	e14a                	sd	s2,128(sp)
ffffffffc0201396:	fcce                	sd	s3,120(sp)
ffffffffc0201398:	f8d2                	sd	s4,112(sp)
ffffffffc020139a:	f4d6                	sd	s5,104(sp)
ffffffffc020139c:	f0da                	sd	s6,96(sp)
ffffffffc020139e:	ecde                	sd	s7,88(sp)
ffffffffc02013a0:	e8e2                	sd	s8,80(sp)
ffffffffc02013a2:	e4e6                	sd	s9,72(sp)
ffffffffc02013a4:	e0ea                	sd	s10,64(sp)
ffffffffc02013a6:	fc6e                	sd	s11,56(sp)
     swapfs_init();
ffffffffc02013a8:	1cd020ef          	jal	ra,ffffffffc0203d74 <swapfs_init>

     // Since the IDE is faked, it can only store 7 pages at most to pass the test
     if (!(7 <= max_swap_offset &&
ffffffffc02013ac:	00010697          	auipc	a3,0x10
ffffffffc02013b0:	1746b683          	ld	a3,372(a3) # ffffffffc0211520 <max_swap_offset>
ffffffffc02013b4:	010007b7          	lui	a5,0x1000
ffffffffc02013b8:	ff968713          	addi	a4,a3,-7
ffffffffc02013bc:	17e1                	addi	a5,a5,-8
ffffffffc02013be:	3ee7e063          	bltu	a5,a4,ffffffffc020179e <swap_init+0x412>
        max_swap_offset < MAX_SWAP_OFFSET_LIMIT)) {
        panic("bad max_swap_offset %08x.\n", max_swap_offset);
     }

     sm = &swap_manager_clock;//use first in first out Page Replacement Algorithm
ffffffffc02013c2:	00009797          	auipc	a5,0x9
ffffffffc02013c6:	c3e78793          	addi	a5,a5,-962 # ffffffffc020a000 <swap_manager_clock>
     int r = sm->init();
ffffffffc02013ca:	6798                	ld	a4,8(a5)
     sm = &swap_manager_clock;//use first in first out Page Replacement Algorithm
ffffffffc02013cc:	00010b17          	auipc	s6,0x10
ffffffffc02013d0:	15cb0b13          	addi	s6,s6,348 # ffffffffc0211528 <sm>
ffffffffc02013d4:	00fb3023          	sd	a5,0(s6)
     int r = sm->init();
ffffffffc02013d8:	9702                	jalr	a4
ffffffffc02013da:	89aa                	mv	s3,a0
     
     if (r == 0)
ffffffffc02013dc:	c10d                	beqz	a0,ffffffffc02013fe <swap_init+0x72>
          cprintf("SWAP: manager = %s\n", sm->name);
          check_swap();
     }

     return r;
}
ffffffffc02013de:	60ea                	ld	ra,152(sp)
ffffffffc02013e0:	644a                	ld	s0,144(sp)
ffffffffc02013e2:	64aa                	ld	s1,136(sp)
ffffffffc02013e4:	690a                	ld	s2,128(sp)
ffffffffc02013e6:	7a46                	ld	s4,112(sp)
ffffffffc02013e8:	7aa6                	ld	s5,104(sp)
ffffffffc02013ea:	7b06                	ld	s6,96(sp)
ffffffffc02013ec:	6be6                	ld	s7,88(sp)
ffffffffc02013ee:	6c46                	ld	s8,80(sp)
ffffffffc02013f0:	6ca6                	ld	s9,72(sp)
ffffffffc02013f2:	6d06                	ld	s10,64(sp)
ffffffffc02013f4:	7de2                	ld	s11,56(sp)
ffffffffc02013f6:	854e                	mv	a0,s3
ffffffffc02013f8:	79e6                	ld	s3,120(sp)
ffffffffc02013fa:	610d                	addi	sp,sp,160
ffffffffc02013fc:	8082                	ret
          cprintf("SWAP: manager = %s\n", sm->name);
ffffffffc02013fe:	000b3783          	ld	a5,0(s6)
ffffffffc0201402:	00004517          	auipc	a0,0x4
ffffffffc0201406:	d8e50513          	addi	a0,a0,-626 # ffffffffc0205190 <commands+0xaf0>
ffffffffc020140a:	00010497          	auipc	s1,0x10
ffffffffc020140e:	cc648493          	addi	s1,s1,-826 # ffffffffc02110d0 <free_area>
ffffffffc0201412:	638c                	ld	a1,0(a5)
          swap_init_ok = 1;
ffffffffc0201414:	4785                	li	a5,1
ffffffffc0201416:	00010717          	auipc	a4,0x10
ffffffffc020141a:	10f72d23          	sw	a5,282(a4) # ffffffffc0211530 <swap_init_ok>
          cprintf("SWAP: manager = %s\n", sm->name);
ffffffffc020141e:	c9dfe0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc0201422:	649c                	ld	a5,8(s1)

static void
check_swap(void)
{
    //backup mem env
     int ret, count = 0, total = 0, i;
ffffffffc0201424:	4401                	li	s0,0
ffffffffc0201426:	4d01                	li	s10,0
     list_entry_t *le = &free_list;
     while ((le = list_next(le)) != &free_list) {
ffffffffc0201428:	2c978163          	beq	a5,s1,ffffffffc02016ea <swap_init+0x35e>
 * test_bit - Determine whether a bit is set
 * @nr:     the bit to test
 * @addr:   the address to count from
 * */
static inline bool test_bit(int nr, volatile void *addr) {
    return (((*(volatile unsigned long *)addr) >> nr) & 1);
ffffffffc020142c:	fe87b703          	ld	a4,-24(a5)
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
ffffffffc0201430:	8b09                	andi	a4,a4,2
ffffffffc0201432:	2a070e63          	beqz	a4,ffffffffc02016ee <swap_init+0x362>
        count ++, total += p->property;
ffffffffc0201436:	ff87a703          	lw	a4,-8(a5)
ffffffffc020143a:	679c                	ld	a5,8(a5)
ffffffffc020143c:	2d05                	addiw	s10,s10,1
ffffffffc020143e:	9c39                	addw	s0,s0,a4
     while ((le = list_next(le)) != &free_list) {
ffffffffc0201440:	fe9796e3          	bne	a5,s1,ffffffffc020142c <swap_init+0xa0>
     }
     assert(total == nr_free_pages());
ffffffffc0201444:	8922                	mv	s2,s0
ffffffffc0201446:	6a6010ef          	jal	ra,ffffffffc0202aec <nr_free_pages>
ffffffffc020144a:	47251663          	bne	a0,s2,ffffffffc02018b6 <swap_init+0x52a>
     cprintf("BEGIN check_swap: count %d, total %d\n",count,total);
ffffffffc020144e:	8622                	mv	a2,s0
ffffffffc0201450:	85ea                	mv	a1,s10
ffffffffc0201452:	00004517          	auipc	a0,0x4
ffffffffc0201456:	d8650513          	addi	a0,a0,-634 # ffffffffc02051d8 <commands+0xb38>
ffffffffc020145a:	c61fe0ef          	jal	ra,ffffffffc02000ba <cprintf>
     
     //now we set the phy pages env     
     struct mm_struct *mm = mm_create();
ffffffffc020145e:	e76ff0ef          	jal	ra,ffffffffc0200ad4 <mm_create>
ffffffffc0201462:	8aaa                	mv	s5,a0
     assert(mm != NULL);
ffffffffc0201464:	52050963          	beqz	a0,ffffffffc0201996 <swap_init+0x60a>

     extern struct mm_struct *check_mm_struct;
     assert(check_mm_struct == NULL);
ffffffffc0201468:	00010797          	auipc	a5,0x10
ffffffffc020146c:	0a878793          	addi	a5,a5,168 # ffffffffc0211510 <check_mm_struct>
ffffffffc0201470:	6398                	ld	a4,0(a5)
ffffffffc0201472:	54071263          	bnez	a4,ffffffffc02019b6 <swap_init+0x62a>

     check_mm_struct = mm;

     pde_t *pgdir = mm->pgdir = boot_pgdir;
ffffffffc0201476:	00010b97          	auipc	s7,0x10
ffffffffc020147a:	0d2bbb83          	ld	s7,210(s7) # ffffffffc0211548 <boot_pgdir>
     assert(pgdir[0] == 0);
ffffffffc020147e:	000bb703          	ld	a4,0(s7)
     check_mm_struct = mm;
ffffffffc0201482:	e388                	sd	a0,0(a5)
     pde_t *pgdir = mm->pgdir = boot_pgdir;
ffffffffc0201484:	01753c23          	sd	s7,24(a0)
     assert(pgdir[0] == 0);
ffffffffc0201488:	3c071763          	bnez	a4,ffffffffc0201856 <swap_init+0x4ca>

     struct vma_struct *vma = vma_create(BEING_CHECK_VALID_VADDR, CHECK_VALID_VADDR, VM_WRITE | VM_READ);
ffffffffc020148c:	6599                	lui	a1,0x6
ffffffffc020148e:	460d                	li	a2,3
ffffffffc0201490:	6505                	lui	a0,0x1
ffffffffc0201492:	e8aff0ef          	jal	ra,ffffffffc0200b1c <vma_create>
ffffffffc0201496:	85aa                	mv	a1,a0
     assert(vma != NULL);
ffffffffc0201498:	3c050f63          	beqz	a0,ffffffffc0201876 <swap_init+0x4ea>

     insert_vma_struct(mm, vma);//初始化一块大的虚拟内存
ffffffffc020149c:	8556                	mv	a0,s5
ffffffffc020149e:	eecff0ef          	jal	ra,ffffffffc0200b8a <insert_vma_struct>

     //setup the temp Page Table vaddr 0~4MB
     cprintf("setup Page Table for vaddr 0X1000, so alloc a page\n");
ffffffffc02014a2:	00004517          	auipc	a0,0x4
ffffffffc02014a6:	d7650513          	addi	a0,a0,-650 # ffffffffc0205218 <commands+0xb78>
ffffffffc02014aa:	c11fe0ef          	jal	ra,ffffffffc02000ba <cprintf>
     pte_t *temp_ptep=NULL;
     temp_ptep = get_pte(mm->pgdir, BEING_CHECK_VALID_VADDR, 1);
ffffffffc02014ae:	018ab503          	ld	a0,24(s5)
ffffffffc02014b2:	4605                	li	a2,1
ffffffffc02014b4:	6585                	lui	a1,0x1
ffffffffc02014b6:	670010ef          	jal	ra,ffffffffc0202b26 <get_pte>
     assert(temp_ptep!= NULL);
ffffffffc02014ba:	3c050e63          	beqz	a0,ffffffffc0201896 <swap_init+0x50a>
     cprintf("setup Page Table vaddr 0~4MB OVER!\n");
ffffffffc02014be:	00004517          	auipc	a0,0x4
ffffffffc02014c2:	daa50513          	addi	a0,a0,-598 # ffffffffc0205268 <commands+0xbc8>
ffffffffc02014c6:	00010917          	auipc	s2,0x10
ffffffffc02014ca:	b9a90913          	addi	s2,s2,-1126 # ffffffffc0211060 <check_rp>
ffffffffc02014ce:	bedfe0ef          	jal	ra,ffffffffc02000ba <cprintf>
     
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
ffffffffc02014d2:	00010a17          	auipc	s4,0x10
ffffffffc02014d6:	baea0a13          	addi	s4,s4,-1106 # ffffffffc0211080 <swap_in_seq_no>
     cprintf("setup Page Table vaddr 0~4MB OVER!\n");
ffffffffc02014da:	8c4a                	mv	s8,s2
          check_rp[i] = alloc_page();
ffffffffc02014dc:	4505                	li	a0,1
ffffffffc02014de:	53c010ef          	jal	ra,ffffffffc0202a1a <alloc_pages>
ffffffffc02014e2:	00ac3023          	sd	a0,0(s8)
          assert(check_rp[i] != NULL );
ffffffffc02014e6:	28050c63          	beqz	a0,ffffffffc020177e <swap_init+0x3f2>
ffffffffc02014ea:	651c                	ld	a5,8(a0)
          assert(!PageProperty(check_rp[i]));
ffffffffc02014ec:	8b89                	andi	a5,a5,2
ffffffffc02014ee:	26079863          	bnez	a5,ffffffffc020175e <swap_init+0x3d2>
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
ffffffffc02014f2:	0c21                	addi	s8,s8,8
ffffffffc02014f4:	ff4c14e3          	bne	s8,s4,ffffffffc02014dc <swap_init+0x150>
     }
     list_entry_t free_list_store = free_list;
ffffffffc02014f8:	609c                	ld	a5,0(s1)
ffffffffc02014fa:	0084bd83          	ld	s11,8(s1)
    elm->prev = elm->next = elm;
ffffffffc02014fe:	e084                	sd	s1,0(s1)
ffffffffc0201500:	f03e                	sd	a5,32(sp)
     list_init(&free_list);
     assert(list_empty(&free_list));
     
     //assert(alloc_page() == NULL);
     
     unsigned int nr_free_store = nr_free;
ffffffffc0201502:	489c                	lw	a5,16(s1)
ffffffffc0201504:	e484                	sd	s1,8(s1)
     nr_free = 0;
ffffffffc0201506:	00010c17          	auipc	s8,0x10
ffffffffc020150a:	b5ac0c13          	addi	s8,s8,-1190 # ffffffffc0211060 <check_rp>
     unsigned int nr_free_store = nr_free;
ffffffffc020150e:	f43e                	sd	a5,40(sp)
     nr_free = 0;
ffffffffc0201510:	00010797          	auipc	a5,0x10
ffffffffc0201514:	bc07a823          	sw	zero,-1072(a5) # ffffffffc02110e0 <free_area+0x10>
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
        free_pages(check_rp[i],1);
ffffffffc0201518:	000c3503          	ld	a0,0(s8)
ffffffffc020151c:	4585                	li	a1,1
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
ffffffffc020151e:	0c21                	addi	s8,s8,8
        free_pages(check_rp[i],1);
ffffffffc0201520:	58c010ef          	jal	ra,ffffffffc0202aac <free_pages>
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
ffffffffc0201524:	ff4c1ae3          	bne	s8,s4,ffffffffc0201518 <swap_init+0x18c>
     }
     assert(nr_free==CHECK_VALID_PHY_PAGE_NUM);
ffffffffc0201528:	0104ac03          	lw	s8,16(s1)
ffffffffc020152c:	4791                	li	a5,4
ffffffffc020152e:	4afc1463          	bne	s8,a5,ffffffffc02019d6 <swap_init+0x64a>
     
     cprintf("set up init env for check_swap begin!\n");
ffffffffc0201532:	00004517          	auipc	a0,0x4
ffffffffc0201536:	dbe50513          	addi	a0,a0,-578 # ffffffffc02052f0 <commands+0xc50>
ffffffffc020153a:	b81fe0ef          	jal	ra,ffffffffc02000ba <cprintf>
     *(unsigned char *)0x1000 = 0x0a;
ffffffffc020153e:	6605                	lui	a2,0x1
     //setup initial vir_page<->phy_page environment for page relpacement algorithm 

     
     pgfault_num=0;
ffffffffc0201540:	00010797          	auipc	a5,0x10
ffffffffc0201544:	fc07ac23          	sw	zero,-40(a5) # ffffffffc0211518 <pgfault_num>
     *(unsigned char *)0x1000 = 0x0a;
ffffffffc0201548:	4529                	li	a0,10
ffffffffc020154a:	00a60023          	sb	a0,0(a2) # 1000 <kern_entry-0xffffffffc01ff000>
     assert(pgfault_num==1);
ffffffffc020154e:	00010597          	auipc	a1,0x10
ffffffffc0201552:	fca5a583          	lw	a1,-54(a1) # ffffffffc0211518 <pgfault_num>
ffffffffc0201556:	4805                	li	a6,1
ffffffffc0201558:	00010797          	auipc	a5,0x10
ffffffffc020155c:	fc078793          	addi	a5,a5,-64 # ffffffffc0211518 <pgfault_num>
ffffffffc0201560:	3f059b63          	bne	a1,a6,ffffffffc0201956 <swap_init+0x5ca>
     *(unsigned char *)0x1010 = 0x0a;
ffffffffc0201564:	00a60823          	sb	a0,16(a2)
     assert(pgfault_num==1);
ffffffffc0201568:	4390                	lw	a2,0(a5)
ffffffffc020156a:	2601                	sext.w	a2,a2
ffffffffc020156c:	40b61563          	bne	a2,a1,ffffffffc0201976 <swap_init+0x5ea>
     *(unsigned char *)0x2000 = 0x0b;
ffffffffc0201570:	6589                	lui	a1,0x2
ffffffffc0201572:	452d                	li	a0,11
ffffffffc0201574:	00a58023          	sb	a0,0(a1) # 2000 <kern_entry-0xffffffffc01fe000>
     assert(pgfault_num==2);
ffffffffc0201578:	4390                	lw	a2,0(a5)
ffffffffc020157a:	4809                	li	a6,2
ffffffffc020157c:	2601                	sext.w	a2,a2
ffffffffc020157e:	35061c63          	bne	a2,a6,ffffffffc02018d6 <swap_init+0x54a>
     *(unsigned char *)0x2010 = 0x0b;
ffffffffc0201582:	00a58823          	sb	a0,16(a1)
     assert(pgfault_num==2);
ffffffffc0201586:	438c                	lw	a1,0(a5)
ffffffffc0201588:	2581                	sext.w	a1,a1
ffffffffc020158a:	36c59663          	bne	a1,a2,ffffffffc02018f6 <swap_init+0x56a>
     *(unsigned char *)0x3000 = 0x0c;
ffffffffc020158e:	658d                	lui	a1,0x3
ffffffffc0201590:	4531                	li	a0,12
ffffffffc0201592:	00a58023          	sb	a0,0(a1) # 3000 <kern_entry-0xffffffffc01fd000>
     assert(pgfault_num==3);
ffffffffc0201596:	4390                	lw	a2,0(a5)
ffffffffc0201598:	480d                	li	a6,3
ffffffffc020159a:	2601                	sext.w	a2,a2
ffffffffc020159c:	37061d63          	bne	a2,a6,ffffffffc0201916 <swap_init+0x58a>
     *(unsigned char *)0x3010 = 0x0c;
ffffffffc02015a0:	00a58823          	sb	a0,16(a1)
     assert(pgfault_num==3);
ffffffffc02015a4:	438c                	lw	a1,0(a5)
ffffffffc02015a6:	2581                	sext.w	a1,a1
ffffffffc02015a8:	38c59763          	bne	a1,a2,ffffffffc0201936 <swap_init+0x5aa>
     *(unsigned char *)0x4000 = 0x0d;
ffffffffc02015ac:	6591                	lui	a1,0x4
ffffffffc02015ae:	4535                	li	a0,13
ffffffffc02015b0:	00a58023          	sb	a0,0(a1) # 4000 <kern_entry-0xffffffffc01fc000>
     assert(pgfault_num==4);
ffffffffc02015b4:	4390                	lw	a2,0(a5)
ffffffffc02015b6:	2601                	sext.w	a2,a2
ffffffffc02015b8:	21861f63          	bne	a2,s8,ffffffffc02017d6 <swap_init+0x44a>
     *(unsigned char *)0x4010 = 0x0d;
ffffffffc02015bc:	00a58823          	sb	a0,16(a1)
     assert(pgfault_num==4);
ffffffffc02015c0:	439c                	lw	a5,0(a5)
ffffffffc02015c2:	2781                	sext.w	a5,a5
ffffffffc02015c4:	22c79963          	bne	a5,a2,ffffffffc02017f6 <swap_init+0x46a>
     
     check_content_set();
     assert( nr_free == 0);         
ffffffffc02015c8:	489c                	lw	a5,16(s1)
ffffffffc02015ca:	24079663          	bnez	a5,ffffffffc0201816 <swap_init+0x48a>
ffffffffc02015ce:	00010797          	auipc	a5,0x10
ffffffffc02015d2:	ab278793          	addi	a5,a5,-1358 # ffffffffc0211080 <swap_in_seq_no>
ffffffffc02015d6:	00010617          	auipc	a2,0x10
ffffffffc02015da:	ad260613          	addi	a2,a2,-1326 # ffffffffc02110a8 <swap_out_seq_no>
ffffffffc02015de:	00010517          	auipc	a0,0x10
ffffffffc02015e2:	aca50513          	addi	a0,a0,-1334 # ffffffffc02110a8 <swap_out_seq_no>
     for(i = 0; i<MAX_SEQ_NO ; i++) 
         swap_out_seq_no[i]=swap_in_seq_no[i]=-1;
ffffffffc02015e6:	55fd                	li	a1,-1
ffffffffc02015e8:	c38c                	sw	a1,0(a5)
ffffffffc02015ea:	c20c                	sw	a1,0(a2)
     for(i = 0; i<MAX_SEQ_NO ; i++) 
ffffffffc02015ec:	0791                	addi	a5,a5,4
ffffffffc02015ee:	0611                	addi	a2,a2,4
ffffffffc02015f0:	fef51ce3          	bne	a0,a5,ffffffffc02015e8 <swap_init+0x25c>
ffffffffc02015f4:	00010817          	auipc	a6,0x10
ffffffffc02015f8:	a4c80813          	addi	a6,a6,-1460 # ffffffffc0211040 <check_ptep>
ffffffffc02015fc:	00010897          	auipc	a7,0x10
ffffffffc0201600:	a6488893          	addi	a7,a7,-1436 # ffffffffc0211060 <check_rp>
ffffffffc0201604:	6585                	lui	a1,0x1
    return &pages[PPN(pa) - nbase];
ffffffffc0201606:	00010c97          	auipc	s9,0x10
ffffffffc020160a:	f52c8c93          	addi	s9,s9,-174 # ffffffffc0211558 <pages>
ffffffffc020160e:	00005c17          	auipc	s8,0x5
ffffffffc0201612:	c42c0c13          	addi	s8,s8,-958 # ffffffffc0206250 <nbase>
     
     for (i= 0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
         check_ptep[i]=0;
ffffffffc0201616:	00083023          	sd	zero,0(a6)
         check_ptep[i] = get_pte(pgdir, (i+1)*0x1000, 0);
ffffffffc020161a:	4601                	li	a2,0
ffffffffc020161c:	855e                	mv	a0,s7
ffffffffc020161e:	ec46                	sd	a7,24(sp)
ffffffffc0201620:	e82e                	sd	a1,16(sp)
         check_ptep[i]=0;
ffffffffc0201622:	e442                	sd	a6,8(sp)
         check_ptep[i] = get_pte(pgdir, (i+1)*0x1000, 0);
ffffffffc0201624:	502010ef          	jal	ra,ffffffffc0202b26 <get_pte>
ffffffffc0201628:	6822                	ld	a6,8(sp)
         //cprintf("i %d, check_ptep addr %x, value %x\n", i, check_ptep[i], *check_ptep[i]);
         //cprintf("%d\n",i);
         assert(check_ptep[i] != NULL);
ffffffffc020162a:	65c2                	ld	a1,16(sp)
ffffffffc020162c:	68e2                	ld	a7,24(sp)
         check_ptep[i] = get_pte(pgdir, (i+1)*0x1000, 0);
ffffffffc020162e:	00a83023          	sd	a0,0(a6)
         assert(check_ptep[i] != NULL);
ffffffffc0201632:	00010317          	auipc	t1,0x10
ffffffffc0201636:	f1e30313          	addi	t1,t1,-226 # ffffffffc0211550 <npage>
ffffffffc020163a:	16050e63          	beqz	a0,ffffffffc02017b6 <swap_init+0x42a>
         assert(pte2page(*check_ptep[i]) == check_rp[i]);
ffffffffc020163e:	611c                	ld	a5,0(a0)
    if (!(pte & PTE_V)) {
ffffffffc0201640:	0017f613          	andi	a2,a5,1
ffffffffc0201644:	0e060563          	beqz	a2,ffffffffc020172e <swap_init+0x3a2>
    if (PPN(pa) >= npage) {
ffffffffc0201648:	00033603          	ld	a2,0(t1)
    return pa2page(PTE_ADDR(pte));
ffffffffc020164c:	078a                	slli	a5,a5,0x2
ffffffffc020164e:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage) {
ffffffffc0201650:	0ec7fb63          	bgeu	a5,a2,ffffffffc0201746 <swap_init+0x3ba>
    return &pages[PPN(pa) - nbase];
ffffffffc0201654:	000c3603          	ld	a2,0(s8)
ffffffffc0201658:	000cb503          	ld	a0,0(s9)
ffffffffc020165c:	0008bf03          	ld	t5,0(a7)
ffffffffc0201660:	8f91                	sub	a5,a5,a2
ffffffffc0201662:	00379613          	slli	a2,a5,0x3
ffffffffc0201666:	97b2                	add	a5,a5,a2
ffffffffc0201668:	078e                	slli	a5,a5,0x3
ffffffffc020166a:	97aa                	add	a5,a5,a0
ffffffffc020166c:	0aff1163          	bne	t5,a5,ffffffffc020170e <swap_init+0x382>
     for (i= 0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
ffffffffc0201670:	6785                	lui	a5,0x1
ffffffffc0201672:	95be                	add	a1,a1,a5
ffffffffc0201674:	6795                	lui	a5,0x5
ffffffffc0201676:	0821                	addi	a6,a6,8
ffffffffc0201678:	08a1                	addi	a7,a7,8
ffffffffc020167a:	f8f59ee3          	bne	a1,a5,ffffffffc0201616 <swap_init+0x28a>
         assert((*check_ptep[i] & PTE_V));          
     }
     cprintf("set up init env for check_swap over!\n");
ffffffffc020167e:	00004517          	auipc	a0,0x4
ffffffffc0201682:	d5250513          	addi	a0,a0,-686 # ffffffffc02053d0 <commands+0xd30>
ffffffffc0201686:	a35fe0ef          	jal	ra,ffffffffc02000ba <cprintf>
    int ret = sm->check_swap();
ffffffffc020168a:	000b3783          	ld	a5,0(s6)
ffffffffc020168e:	7f9c                	ld	a5,56(a5)
ffffffffc0201690:	9782                	jalr	a5
     // now access the virt pages to test  page relpacement algorithm 
     ret=check_content_access();
     //cprintf("here2\n");
     assert(ret==0);
ffffffffc0201692:	1a051263          	bnez	a0,ffffffffc0201836 <swap_init+0x4aa>
     
     //restore kernel mem env
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
         //cprintf("here1\n");
         free_pages(check_rp[i],1);
ffffffffc0201696:	00093503          	ld	a0,0(s2)
ffffffffc020169a:	4585                	li	a1,1
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
ffffffffc020169c:	0921                	addi	s2,s2,8
         free_pages(check_rp[i],1);
ffffffffc020169e:	40e010ef          	jal	ra,ffffffffc0202aac <free_pages>
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
ffffffffc02016a2:	ff491ae3          	bne	s2,s4,ffffffffc0201696 <swap_init+0x30a>
     } 

     //free_page(pte2page(*temp_ptep));
     //cprintf("here\n");
     mm_destroy(mm);
ffffffffc02016a6:	8556                	mv	a0,s5
ffffffffc02016a8:	db2ff0ef          	jal	ra,ffffffffc0200c5a <mm_destroy>
         
     nr_free = nr_free_store;
ffffffffc02016ac:	77a2                	ld	a5,40(sp)
     free_list = free_list_store;
ffffffffc02016ae:	01b4b423          	sd	s11,8(s1)
     nr_free = nr_free_store;
ffffffffc02016b2:	c89c                	sw	a5,16(s1)
     free_list = free_list_store;
ffffffffc02016b4:	7782                	ld	a5,32(sp)
ffffffffc02016b6:	e09c                	sd	a5,0(s1)

     
     le = &free_list;
     while ((le = list_next(le)) != &free_list) {
ffffffffc02016b8:	009d8a63          	beq	s11,s1,ffffffffc02016cc <swap_init+0x340>
         struct Page *p = le2page(le, page_link);
         count --, total -= p->property;
ffffffffc02016bc:	ff8da783          	lw	a5,-8(s11)
    return listelm->next;
ffffffffc02016c0:	008dbd83          	ld	s11,8(s11)
ffffffffc02016c4:	3d7d                	addiw	s10,s10,-1
ffffffffc02016c6:	9c1d                	subw	s0,s0,a5
     while ((le = list_next(le)) != &free_list) {
ffffffffc02016c8:	fe9d9ae3          	bne	s11,s1,ffffffffc02016bc <swap_init+0x330>
     }
     cprintf("count is %d, total is %d\n",count,total);
ffffffffc02016cc:	8622                	mv	a2,s0
ffffffffc02016ce:	85ea                	mv	a1,s10
ffffffffc02016d0:	00004517          	auipc	a0,0x4
ffffffffc02016d4:	d3050513          	addi	a0,a0,-720 # ffffffffc0205400 <commands+0xd60>
ffffffffc02016d8:	9e3fe0ef          	jal	ra,ffffffffc02000ba <cprintf>
     //assert(count == 0);
     
     cprintf("check_swap() succeeded!\n");
ffffffffc02016dc:	00004517          	auipc	a0,0x4
ffffffffc02016e0:	d4450513          	addi	a0,a0,-700 # ffffffffc0205420 <commands+0xd80>
ffffffffc02016e4:	9d7fe0ef          	jal	ra,ffffffffc02000ba <cprintf>
}
ffffffffc02016e8:	b9dd                	j	ffffffffc02013de <swap_init+0x52>
     while ((le = list_next(le)) != &free_list) {
ffffffffc02016ea:	4901                	li	s2,0
ffffffffc02016ec:	bba9                	j	ffffffffc0201446 <swap_init+0xba>
        assert(PageProperty(p));
ffffffffc02016ee:	00004697          	auipc	a3,0x4
ffffffffc02016f2:	aba68693          	addi	a3,a3,-1350 # ffffffffc02051a8 <commands+0xb08>
ffffffffc02016f6:	00003617          	auipc	a2,0x3
ffffffffc02016fa:	6d260613          	addi	a2,a2,1746 # ffffffffc0204dc8 <commands+0x728>
ffffffffc02016fe:	0ba00593          	li	a1,186
ffffffffc0201702:	00004517          	auipc	a0,0x4
ffffffffc0201706:	a7e50513          	addi	a0,a0,-1410 # ffffffffc0205180 <commands+0xae0>
ffffffffc020170a:	9f9fe0ef          	jal	ra,ffffffffc0200102 <__panic>
         assert(pte2page(*check_ptep[i]) == check_rp[i]);
ffffffffc020170e:	00004697          	auipc	a3,0x4
ffffffffc0201712:	c9a68693          	addi	a3,a3,-870 # ffffffffc02053a8 <commands+0xd08>
ffffffffc0201716:	00003617          	auipc	a2,0x3
ffffffffc020171a:	6b260613          	addi	a2,a2,1714 # ffffffffc0204dc8 <commands+0x728>
ffffffffc020171e:	0fb00593          	li	a1,251
ffffffffc0201722:	00004517          	auipc	a0,0x4
ffffffffc0201726:	a5e50513          	addi	a0,a0,-1442 # ffffffffc0205180 <commands+0xae0>
ffffffffc020172a:	9d9fe0ef          	jal	ra,ffffffffc0200102 <__panic>
        panic("pte2page called with invalid pte");
ffffffffc020172e:	00004617          	auipc	a2,0x4
ffffffffc0201732:	c5260613          	addi	a2,a2,-942 # ffffffffc0205380 <commands+0xce0>
ffffffffc0201736:	07000593          	li	a1,112
ffffffffc020173a:	00004517          	auipc	a0,0x4
ffffffffc020173e:	8fe50513          	addi	a0,a0,-1794 # ffffffffc0205038 <commands+0x998>
ffffffffc0201742:	9c1fe0ef          	jal	ra,ffffffffc0200102 <__panic>
        panic("pa2page called with invalid pa");
ffffffffc0201746:	00004617          	auipc	a2,0x4
ffffffffc020174a:	8d260613          	addi	a2,a2,-1838 # ffffffffc0205018 <commands+0x978>
ffffffffc020174e:	06500593          	li	a1,101
ffffffffc0201752:	00004517          	auipc	a0,0x4
ffffffffc0201756:	8e650513          	addi	a0,a0,-1818 # ffffffffc0205038 <commands+0x998>
ffffffffc020175a:	9a9fe0ef          	jal	ra,ffffffffc0200102 <__panic>
          assert(!PageProperty(check_rp[i]));
ffffffffc020175e:	00004697          	auipc	a3,0x4
ffffffffc0201762:	b4a68693          	addi	a3,a3,-1206 # ffffffffc02052a8 <commands+0xc08>
ffffffffc0201766:	00003617          	auipc	a2,0x3
ffffffffc020176a:	66260613          	addi	a2,a2,1634 # ffffffffc0204dc8 <commands+0x728>
ffffffffc020176e:	0db00593          	li	a1,219
ffffffffc0201772:	00004517          	auipc	a0,0x4
ffffffffc0201776:	a0e50513          	addi	a0,a0,-1522 # ffffffffc0205180 <commands+0xae0>
ffffffffc020177a:	989fe0ef          	jal	ra,ffffffffc0200102 <__panic>
          assert(check_rp[i] != NULL );
ffffffffc020177e:	00004697          	auipc	a3,0x4
ffffffffc0201782:	b1268693          	addi	a3,a3,-1262 # ffffffffc0205290 <commands+0xbf0>
ffffffffc0201786:	00003617          	auipc	a2,0x3
ffffffffc020178a:	64260613          	addi	a2,a2,1602 # ffffffffc0204dc8 <commands+0x728>
ffffffffc020178e:	0da00593          	li	a1,218
ffffffffc0201792:	00004517          	auipc	a0,0x4
ffffffffc0201796:	9ee50513          	addi	a0,a0,-1554 # ffffffffc0205180 <commands+0xae0>
ffffffffc020179a:	969fe0ef          	jal	ra,ffffffffc0200102 <__panic>
        panic("bad max_swap_offset %08x.\n", max_swap_offset);
ffffffffc020179e:	00004617          	auipc	a2,0x4
ffffffffc02017a2:	9c260613          	addi	a2,a2,-1598 # ffffffffc0205160 <commands+0xac0>
ffffffffc02017a6:	02700593          	li	a1,39
ffffffffc02017aa:	00004517          	auipc	a0,0x4
ffffffffc02017ae:	9d650513          	addi	a0,a0,-1578 # ffffffffc0205180 <commands+0xae0>
ffffffffc02017b2:	951fe0ef          	jal	ra,ffffffffc0200102 <__panic>
         assert(check_ptep[i] != NULL);
ffffffffc02017b6:	00004697          	auipc	a3,0x4
ffffffffc02017ba:	bb268693          	addi	a3,a3,-1102 # ffffffffc0205368 <commands+0xcc8>
ffffffffc02017be:	00003617          	auipc	a2,0x3
ffffffffc02017c2:	60a60613          	addi	a2,a2,1546 # ffffffffc0204dc8 <commands+0x728>
ffffffffc02017c6:	0fa00593          	li	a1,250
ffffffffc02017ca:	00004517          	auipc	a0,0x4
ffffffffc02017ce:	9b650513          	addi	a0,a0,-1610 # ffffffffc0205180 <commands+0xae0>
ffffffffc02017d2:	931fe0ef          	jal	ra,ffffffffc0200102 <__panic>
     assert(pgfault_num==4);
ffffffffc02017d6:	00004697          	auipc	a3,0x4
ffffffffc02017da:	b7268693          	addi	a3,a3,-1166 # ffffffffc0205348 <commands+0xca8>
ffffffffc02017de:	00003617          	auipc	a2,0x3
ffffffffc02017e2:	5ea60613          	addi	a2,a2,1514 # ffffffffc0204dc8 <commands+0x728>
ffffffffc02017e6:	09d00593          	li	a1,157
ffffffffc02017ea:	00004517          	auipc	a0,0x4
ffffffffc02017ee:	99650513          	addi	a0,a0,-1642 # ffffffffc0205180 <commands+0xae0>
ffffffffc02017f2:	911fe0ef          	jal	ra,ffffffffc0200102 <__panic>
     assert(pgfault_num==4);
ffffffffc02017f6:	00004697          	auipc	a3,0x4
ffffffffc02017fa:	b5268693          	addi	a3,a3,-1198 # ffffffffc0205348 <commands+0xca8>
ffffffffc02017fe:	00003617          	auipc	a2,0x3
ffffffffc0201802:	5ca60613          	addi	a2,a2,1482 # ffffffffc0204dc8 <commands+0x728>
ffffffffc0201806:	09f00593          	li	a1,159
ffffffffc020180a:	00004517          	auipc	a0,0x4
ffffffffc020180e:	97650513          	addi	a0,a0,-1674 # ffffffffc0205180 <commands+0xae0>
ffffffffc0201812:	8f1fe0ef          	jal	ra,ffffffffc0200102 <__panic>
     assert( nr_free == 0);         
ffffffffc0201816:	00004697          	auipc	a3,0x4
ffffffffc020181a:	b4268693          	addi	a3,a3,-1214 # ffffffffc0205358 <commands+0xcb8>
ffffffffc020181e:	00003617          	auipc	a2,0x3
ffffffffc0201822:	5aa60613          	addi	a2,a2,1450 # ffffffffc0204dc8 <commands+0x728>
ffffffffc0201826:	0f100593          	li	a1,241
ffffffffc020182a:	00004517          	auipc	a0,0x4
ffffffffc020182e:	95650513          	addi	a0,a0,-1706 # ffffffffc0205180 <commands+0xae0>
ffffffffc0201832:	8d1fe0ef          	jal	ra,ffffffffc0200102 <__panic>
     assert(ret==0);
ffffffffc0201836:	00004697          	auipc	a3,0x4
ffffffffc020183a:	bc268693          	addi	a3,a3,-1086 # ffffffffc02053f8 <commands+0xd58>
ffffffffc020183e:	00003617          	auipc	a2,0x3
ffffffffc0201842:	58a60613          	addi	a2,a2,1418 # ffffffffc0204dc8 <commands+0x728>
ffffffffc0201846:	10200593          	li	a1,258
ffffffffc020184a:	00004517          	auipc	a0,0x4
ffffffffc020184e:	93650513          	addi	a0,a0,-1738 # ffffffffc0205180 <commands+0xae0>
ffffffffc0201852:	8b1fe0ef          	jal	ra,ffffffffc0200102 <__panic>
     assert(pgdir[0] == 0);
ffffffffc0201856:	00003697          	auipc	a3,0x3
ffffffffc020185a:	78268693          	addi	a3,a3,1922 # ffffffffc0204fd8 <commands+0x938>
ffffffffc020185e:	00003617          	auipc	a2,0x3
ffffffffc0201862:	56a60613          	addi	a2,a2,1386 # ffffffffc0204dc8 <commands+0x728>
ffffffffc0201866:	0ca00593          	li	a1,202
ffffffffc020186a:	00004517          	auipc	a0,0x4
ffffffffc020186e:	91650513          	addi	a0,a0,-1770 # ffffffffc0205180 <commands+0xae0>
ffffffffc0201872:	891fe0ef          	jal	ra,ffffffffc0200102 <__panic>
     assert(vma != NULL);
ffffffffc0201876:	00004697          	auipc	a3,0x4
ffffffffc020187a:	80a68693          	addi	a3,a3,-2038 # ffffffffc0205080 <commands+0x9e0>
ffffffffc020187e:	00003617          	auipc	a2,0x3
ffffffffc0201882:	54a60613          	addi	a2,a2,1354 # ffffffffc0204dc8 <commands+0x728>
ffffffffc0201886:	0cd00593          	li	a1,205
ffffffffc020188a:	00004517          	auipc	a0,0x4
ffffffffc020188e:	8f650513          	addi	a0,a0,-1802 # ffffffffc0205180 <commands+0xae0>
ffffffffc0201892:	871fe0ef          	jal	ra,ffffffffc0200102 <__panic>
     assert(temp_ptep!= NULL);
ffffffffc0201896:	00004697          	auipc	a3,0x4
ffffffffc020189a:	9ba68693          	addi	a3,a3,-1606 # ffffffffc0205250 <commands+0xbb0>
ffffffffc020189e:	00003617          	auipc	a2,0x3
ffffffffc02018a2:	52a60613          	addi	a2,a2,1322 # ffffffffc0204dc8 <commands+0x728>
ffffffffc02018a6:	0d500593          	li	a1,213
ffffffffc02018aa:	00004517          	auipc	a0,0x4
ffffffffc02018ae:	8d650513          	addi	a0,a0,-1834 # ffffffffc0205180 <commands+0xae0>
ffffffffc02018b2:	851fe0ef          	jal	ra,ffffffffc0200102 <__panic>
     assert(total == nr_free_pages());
ffffffffc02018b6:	00004697          	auipc	a3,0x4
ffffffffc02018ba:	90268693          	addi	a3,a3,-1790 # ffffffffc02051b8 <commands+0xb18>
ffffffffc02018be:	00003617          	auipc	a2,0x3
ffffffffc02018c2:	50a60613          	addi	a2,a2,1290 # ffffffffc0204dc8 <commands+0x728>
ffffffffc02018c6:	0bd00593          	li	a1,189
ffffffffc02018ca:	00004517          	auipc	a0,0x4
ffffffffc02018ce:	8b650513          	addi	a0,a0,-1866 # ffffffffc0205180 <commands+0xae0>
ffffffffc02018d2:	831fe0ef          	jal	ra,ffffffffc0200102 <__panic>
     assert(pgfault_num==2);
ffffffffc02018d6:	00004697          	auipc	a3,0x4
ffffffffc02018da:	a5268693          	addi	a3,a3,-1454 # ffffffffc0205328 <commands+0xc88>
ffffffffc02018de:	00003617          	auipc	a2,0x3
ffffffffc02018e2:	4ea60613          	addi	a2,a2,1258 # ffffffffc0204dc8 <commands+0x728>
ffffffffc02018e6:	09500593          	li	a1,149
ffffffffc02018ea:	00004517          	auipc	a0,0x4
ffffffffc02018ee:	89650513          	addi	a0,a0,-1898 # ffffffffc0205180 <commands+0xae0>
ffffffffc02018f2:	811fe0ef          	jal	ra,ffffffffc0200102 <__panic>
     assert(pgfault_num==2);
ffffffffc02018f6:	00004697          	auipc	a3,0x4
ffffffffc02018fa:	a3268693          	addi	a3,a3,-1486 # ffffffffc0205328 <commands+0xc88>
ffffffffc02018fe:	00003617          	auipc	a2,0x3
ffffffffc0201902:	4ca60613          	addi	a2,a2,1226 # ffffffffc0204dc8 <commands+0x728>
ffffffffc0201906:	09700593          	li	a1,151
ffffffffc020190a:	00004517          	auipc	a0,0x4
ffffffffc020190e:	87650513          	addi	a0,a0,-1930 # ffffffffc0205180 <commands+0xae0>
ffffffffc0201912:	ff0fe0ef          	jal	ra,ffffffffc0200102 <__panic>
     assert(pgfault_num==3);
ffffffffc0201916:	00004697          	auipc	a3,0x4
ffffffffc020191a:	a2268693          	addi	a3,a3,-1502 # ffffffffc0205338 <commands+0xc98>
ffffffffc020191e:	00003617          	auipc	a2,0x3
ffffffffc0201922:	4aa60613          	addi	a2,a2,1194 # ffffffffc0204dc8 <commands+0x728>
ffffffffc0201926:	09900593          	li	a1,153
ffffffffc020192a:	00004517          	auipc	a0,0x4
ffffffffc020192e:	85650513          	addi	a0,a0,-1962 # ffffffffc0205180 <commands+0xae0>
ffffffffc0201932:	fd0fe0ef          	jal	ra,ffffffffc0200102 <__panic>
     assert(pgfault_num==3);
ffffffffc0201936:	00004697          	auipc	a3,0x4
ffffffffc020193a:	a0268693          	addi	a3,a3,-1534 # ffffffffc0205338 <commands+0xc98>
ffffffffc020193e:	00003617          	auipc	a2,0x3
ffffffffc0201942:	48a60613          	addi	a2,a2,1162 # ffffffffc0204dc8 <commands+0x728>
ffffffffc0201946:	09b00593          	li	a1,155
ffffffffc020194a:	00004517          	auipc	a0,0x4
ffffffffc020194e:	83650513          	addi	a0,a0,-1994 # ffffffffc0205180 <commands+0xae0>
ffffffffc0201952:	fb0fe0ef          	jal	ra,ffffffffc0200102 <__panic>
     assert(pgfault_num==1);
ffffffffc0201956:	00004697          	auipc	a3,0x4
ffffffffc020195a:	9c268693          	addi	a3,a3,-1598 # ffffffffc0205318 <commands+0xc78>
ffffffffc020195e:	00003617          	auipc	a2,0x3
ffffffffc0201962:	46a60613          	addi	a2,a2,1130 # ffffffffc0204dc8 <commands+0x728>
ffffffffc0201966:	09100593          	li	a1,145
ffffffffc020196a:	00004517          	auipc	a0,0x4
ffffffffc020196e:	81650513          	addi	a0,a0,-2026 # ffffffffc0205180 <commands+0xae0>
ffffffffc0201972:	f90fe0ef          	jal	ra,ffffffffc0200102 <__panic>
     assert(pgfault_num==1);
ffffffffc0201976:	00004697          	auipc	a3,0x4
ffffffffc020197a:	9a268693          	addi	a3,a3,-1630 # ffffffffc0205318 <commands+0xc78>
ffffffffc020197e:	00003617          	auipc	a2,0x3
ffffffffc0201982:	44a60613          	addi	a2,a2,1098 # ffffffffc0204dc8 <commands+0x728>
ffffffffc0201986:	09300593          	li	a1,147
ffffffffc020198a:	00003517          	auipc	a0,0x3
ffffffffc020198e:	7f650513          	addi	a0,a0,2038 # ffffffffc0205180 <commands+0xae0>
ffffffffc0201992:	f70fe0ef          	jal	ra,ffffffffc0200102 <__panic>
     assert(mm != NULL);
ffffffffc0201996:	00003697          	auipc	a3,0x3
ffffffffc020199a:	71268693          	addi	a3,a3,1810 # ffffffffc02050a8 <commands+0xa08>
ffffffffc020199e:	00003617          	auipc	a2,0x3
ffffffffc02019a2:	42a60613          	addi	a2,a2,1066 # ffffffffc0204dc8 <commands+0x728>
ffffffffc02019a6:	0c200593          	li	a1,194
ffffffffc02019aa:	00003517          	auipc	a0,0x3
ffffffffc02019ae:	7d650513          	addi	a0,a0,2006 # ffffffffc0205180 <commands+0xae0>
ffffffffc02019b2:	f50fe0ef          	jal	ra,ffffffffc0200102 <__panic>
     assert(check_mm_struct == NULL);
ffffffffc02019b6:	00004697          	auipc	a3,0x4
ffffffffc02019ba:	84a68693          	addi	a3,a3,-1974 # ffffffffc0205200 <commands+0xb60>
ffffffffc02019be:	00003617          	auipc	a2,0x3
ffffffffc02019c2:	40a60613          	addi	a2,a2,1034 # ffffffffc0204dc8 <commands+0x728>
ffffffffc02019c6:	0c500593          	li	a1,197
ffffffffc02019ca:	00003517          	auipc	a0,0x3
ffffffffc02019ce:	7b650513          	addi	a0,a0,1974 # ffffffffc0205180 <commands+0xae0>
ffffffffc02019d2:	f30fe0ef          	jal	ra,ffffffffc0200102 <__panic>
     assert(nr_free==CHECK_VALID_PHY_PAGE_NUM);
ffffffffc02019d6:	00004697          	auipc	a3,0x4
ffffffffc02019da:	8f268693          	addi	a3,a3,-1806 # ffffffffc02052c8 <commands+0xc28>
ffffffffc02019de:	00003617          	auipc	a2,0x3
ffffffffc02019e2:	3ea60613          	addi	a2,a2,1002 # ffffffffc0204dc8 <commands+0x728>
ffffffffc02019e6:	0e800593          	li	a1,232
ffffffffc02019ea:	00003517          	auipc	a0,0x3
ffffffffc02019ee:	79650513          	addi	a0,a0,1942 # ffffffffc0205180 <commands+0xae0>
ffffffffc02019f2:	f10fe0ef          	jal	ra,ffffffffc0200102 <__panic>

ffffffffc02019f6 <swap_init_mm>:
     return sm->init_mm(mm);
ffffffffc02019f6:	00010797          	auipc	a5,0x10
ffffffffc02019fa:	b327b783          	ld	a5,-1230(a5) # ffffffffc0211528 <sm>
ffffffffc02019fe:	6b9c                	ld	a5,16(a5)
ffffffffc0201a00:	8782                	jr	a5

ffffffffc0201a02 <swap_map_swappable>:
     return sm->map_swappable(mm, addr, page, swap_in);
ffffffffc0201a02:	00010797          	auipc	a5,0x10
ffffffffc0201a06:	b267b783          	ld	a5,-1242(a5) # ffffffffc0211528 <sm>
ffffffffc0201a0a:	739c                	ld	a5,32(a5)
ffffffffc0201a0c:	8782                	jr	a5

ffffffffc0201a0e <swap_out>:
{
ffffffffc0201a0e:	711d                	addi	sp,sp,-96
ffffffffc0201a10:	ec86                	sd	ra,88(sp)
ffffffffc0201a12:	e8a2                	sd	s0,80(sp)
ffffffffc0201a14:	e4a6                	sd	s1,72(sp)
ffffffffc0201a16:	e0ca                	sd	s2,64(sp)
ffffffffc0201a18:	fc4e                	sd	s3,56(sp)
ffffffffc0201a1a:	f852                	sd	s4,48(sp)
ffffffffc0201a1c:	f456                	sd	s5,40(sp)
ffffffffc0201a1e:	f05a                	sd	s6,32(sp)
ffffffffc0201a20:	ec5e                	sd	s7,24(sp)
ffffffffc0201a22:	e862                	sd	s8,16(sp)
     for (i = 0; i != n; ++ i)
ffffffffc0201a24:	cde9                	beqz	a1,ffffffffc0201afe <swap_out+0xf0>
ffffffffc0201a26:	8a2e                	mv	s4,a1
ffffffffc0201a28:	892a                	mv	s2,a0
ffffffffc0201a2a:	8ab2                	mv	s5,a2
ffffffffc0201a2c:	4401                	li	s0,0
ffffffffc0201a2e:	00010997          	auipc	s3,0x10
ffffffffc0201a32:	afa98993          	addi	s3,s3,-1286 # ffffffffc0211528 <sm>
                    cprintf("swap_out: i %d, store page in vaddr 0x%x to disk swap entry %d\n", i, v, page->pra_vaddr/PGSIZE+1);
ffffffffc0201a36:	00004b17          	auipc	s6,0x4
ffffffffc0201a3a:	a6ab0b13          	addi	s6,s6,-1430 # ffffffffc02054a0 <commands+0xe00>
                    cprintf("SWAP: failed to save\n");
ffffffffc0201a3e:	00004b97          	auipc	s7,0x4
ffffffffc0201a42:	a4ab8b93          	addi	s7,s7,-1462 # ffffffffc0205488 <commands+0xde8>
ffffffffc0201a46:	a825                	j	ffffffffc0201a7e <swap_out+0x70>
                    cprintf("swap_out: i %d, store page in vaddr 0x%x to disk swap entry %d\n", i, v, page->pra_vaddr/PGSIZE+1);
ffffffffc0201a48:	67a2                	ld	a5,8(sp)
ffffffffc0201a4a:	8626                	mv	a2,s1
ffffffffc0201a4c:	85a2                	mv	a1,s0
ffffffffc0201a4e:	63b4                	ld	a3,64(a5)
ffffffffc0201a50:	855a                	mv	a0,s6
     for (i = 0; i != n; ++ i)
ffffffffc0201a52:	2405                	addiw	s0,s0,1
                    cprintf("swap_out: i %d, store page in vaddr 0x%x to disk swap entry %d\n", i, v, page->pra_vaddr/PGSIZE+1);
ffffffffc0201a54:	82b1                	srli	a3,a3,0xc
ffffffffc0201a56:	0685                	addi	a3,a3,1
ffffffffc0201a58:	e62fe0ef          	jal	ra,ffffffffc02000ba <cprintf>
                    *ptep = (page->pra_vaddr/PGSIZE+1)<<8;
ffffffffc0201a5c:	6522                	ld	a0,8(sp)
                    free_page(page);
ffffffffc0201a5e:	4585                	li	a1,1
                    *ptep = (page->pra_vaddr/PGSIZE+1)<<8;
ffffffffc0201a60:	613c                	ld	a5,64(a0)
ffffffffc0201a62:	83b1                	srli	a5,a5,0xc
ffffffffc0201a64:	0785                	addi	a5,a5,1
ffffffffc0201a66:	07a2                	slli	a5,a5,0x8
ffffffffc0201a68:	00fc3023          	sd	a5,0(s8)
                    free_page(page);
ffffffffc0201a6c:	040010ef          	jal	ra,ffffffffc0202aac <free_pages>
          tlb_invalidate(mm->pgdir, v);
ffffffffc0201a70:	01893503          	ld	a0,24(s2)
ffffffffc0201a74:	85a6                	mv	a1,s1
ffffffffc0201a76:	09e020ef          	jal	ra,ffffffffc0203b14 <tlb_invalidate>
     for (i = 0; i != n; ++ i)
ffffffffc0201a7a:	048a0d63          	beq	s4,s0,ffffffffc0201ad4 <swap_out+0xc6>
          int r = sm->swap_out_victim(mm, &page, in_tick);
ffffffffc0201a7e:	0009b783          	ld	a5,0(s3)
ffffffffc0201a82:	8656                	mv	a2,s5
ffffffffc0201a84:	002c                	addi	a1,sp,8
ffffffffc0201a86:	7b9c                	ld	a5,48(a5)
ffffffffc0201a88:	854a                	mv	a0,s2
ffffffffc0201a8a:	9782                	jalr	a5
          if (r != 0) {
ffffffffc0201a8c:	e12d                	bnez	a0,ffffffffc0201aee <swap_out+0xe0>
          v=page->pra_vaddr; 
ffffffffc0201a8e:	67a2                	ld	a5,8(sp)
          pte_t *ptep = get_pte(mm->pgdir, v, 0);
ffffffffc0201a90:	01893503          	ld	a0,24(s2)
ffffffffc0201a94:	4601                	li	a2,0
          v=page->pra_vaddr; 
ffffffffc0201a96:	63a4                	ld	s1,64(a5)
          pte_t *ptep = get_pte(mm->pgdir, v, 0);
ffffffffc0201a98:	85a6                	mv	a1,s1
ffffffffc0201a9a:	08c010ef          	jal	ra,ffffffffc0202b26 <get_pte>
          assert((*ptep & PTE_V) != 0);
ffffffffc0201a9e:	611c                	ld	a5,0(a0)
          pte_t *ptep = get_pte(mm->pgdir, v, 0);
ffffffffc0201aa0:	8c2a                	mv	s8,a0
          assert((*ptep & PTE_V) != 0);
ffffffffc0201aa2:	8b85                	andi	a5,a5,1
ffffffffc0201aa4:	cfb9                	beqz	a5,ffffffffc0201b02 <swap_out+0xf4>
          if (swapfs_write( (page->pra_vaddr/PGSIZE+1)<<8, page) != 0) {
ffffffffc0201aa6:	65a2                	ld	a1,8(sp)
ffffffffc0201aa8:	61bc                	ld	a5,64(a1)
ffffffffc0201aaa:	83b1                	srli	a5,a5,0xc
ffffffffc0201aac:	0785                	addi	a5,a5,1
ffffffffc0201aae:	00879513          	slli	a0,a5,0x8
ffffffffc0201ab2:	394020ef          	jal	ra,ffffffffc0203e46 <swapfs_write>
ffffffffc0201ab6:	d949                	beqz	a0,ffffffffc0201a48 <swap_out+0x3a>
                    cprintf("SWAP: failed to save\n");
ffffffffc0201ab8:	855e                	mv	a0,s7
ffffffffc0201aba:	e00fe0ef          	jal	ra,ffffffffc02000ba <cprintf>
                    sm->map_swappable(mm, v, page, 0);
ffffffffc0201abe:	0009b783          	ld	a5,0(s3)
ffffffffc0201ac2:	6622                	ld	a2,8(sp)
ffffffffc0201ac4:	4681                	li	a3,0
ffffffffc0201ac6:	739c                	ld	a5,32(a5)
ffffffffc0201ac8:	85a6                	mv	a1,s1
ffffffffc0201aca:	854a                	mv	a0,s2
     for (i = 0; i != n; ++ i)
ffffffffc0201acc:	2405                	addiw	s0,s0,1
                    sm->map_swappable(mm, v, page, 0);
ffffffffc0201ace:	9782                	jalr	a5
     for (i = 0; i != n; ++ i)
ffffffffc0201ad0:	fa8a17e3          	bne	s4,s0,ffffffffc0201a7e <swap_out+0x70>
}
ffffffffc0201ad4:	60e6                	ld	ra,88(sp)
ffffffffc0201ad6:	8522                	mv	a0,s0
ffffffffc0201ad8:	6446                	ld	s0,80(sp)
ffffffffc0201ada:	64a6                	ld	s1,72(sp)
ffffffffc0201adc:	6906                	ld	s2,64(sp)
ffffffffc0201ade:	79e2                	ld	s3,56(sp)
ffffffffc0201ae0:	7a42                	ld	s4,48(sp)
ffffffffc0201ae2:	7aa2                	ld	s5,40(sp)
ffffffffc0201ae4:	7b02                	ld	s6,32(sp)
ffffffffc0201ae6:	6be2                	ld	s7,24(sp)
ffffffffc0201ae8:	6c42                	ld	s8,16(sp)
ffffffffc0201aea:	6125                	addi	sp,sp,96
ffffffffc0201aec:	8082                	ret
                    cprintf("i %d, swap_out: call swap_out_victim failed\n",i);
ffffffffc0201aee:	85a2                	mv	a1,s0
ffffffffc0201af0:	00004517          	auipc	a0,0x4
ffffffffc0201af4:	95050513          	addi	a0,a0,-1712 # ffffffffc0205440 <commands+0xda0>
ffffffffc0201af8:	dc2fe0ef          	jal	ra,ffffffffc02000ba <cprintf>
                  break;
ffffffffc0201afc:	bfe1                	j	ffffffffc0201ad4 <swap_out+0xc6>
     for (i = 0; i != n; ++ i)
ffffffffc0201afe:	4401                	li	s0,0
ffffffffc0201b00:	bfd1                	j	ffffffffc0201ad4 <swap_out+0xc6>
          assert((*ptep & PTE_V) != 0);
ffffffffc0201b02:	00004697          	auipc	a3,0x4
ffffffffc0201b06:	96e68693          	addi	a3,a3,-1682 # ffffffffc0205470 <commands+0xdd0>
ffffffffc0201b0a:	00003617          	auipc	a2,0x3
ffffffffc0201b0e:	2be60613          	addi	a2,a2,702 # ffffffffc0204dc8 <commands+0x728>
ffffffffc0201b12:	06600593          	li	a1,102
ffffffffc0201b16:	00003517          	auipc	a0,0x3
ffffffffc0201b1a:	66a50513          	addi	a0,a0,1642 # ffffffffc0205180 <commands+0xae0>
ffffffffc0201b1e:	de4fe0ef          	jal	ra,ffffffffc0200102 <__panic>

ffffffffc0201b22 <swap_in>:
{
ffffffffc0201b22:	7179                	addi	sp,sp,-48
ffffffffc0201b24:	e84a                	sd	s2,16(sp)
ffffffffc0201b26:	892a                	mv	s2,a0
     struct Page *result = alloc_page();
ffffffffc0201b28:	4505                	li	a0,1
{
ffffffffc0201b2a:	ec26                	sd	s1,24(sp)
ffffffffc0201b2c:	e44e                	sd	s3,8(sp)
ffffffffc0201b2e:	f406                	sd	ra,40(sp)
ffffffffc0201b30:	f022                	sd	s0,32(sp)
ffffffffc0201b32:	84ae                	mv	s1,a1
ffffffffc0201b34:	89b2                	mv	s3,a2
     struct Page *result = alloc_page();
ffffffffc0201b36:	6e5000ef          	jal	ra,ffffffffc0202a1a <alloc_pages>
     assert(result!=NULL);
ffffffffc0201b3a:	c129                	beqz	a0,ffffffffc0201b7c <swap_in+0x5a>
     pte_t *ptep = get_pte(mm->pgdir, addr, 0);
ffffffffc0201b3c:	842a                	mv	s0,a0
ffffffffc0201b3e:	01893503          	ld	a0,24(s2)
ffffffffc0201b42:	4601                	li	a2,0
ffffffffc0201b44:	85a6                	mv	a1,s1
ffffffffc0201b46:	7e1000ef          	jal	ra,ffffffffc0202b26 <get_pte>
ffffffffc0201b4a:	892a                	mv	s2,a0
     if ((r = swapfs_read((*ptep), result)) != 0)
ffffffffc0201b4c:	6108                	ld	a0,0(a0)
ffffffffc0201b4e:	85a2                	mv	a1,s0
ffffffffc0201b50:	25c020ef          	jal	ra,ffffffffc0203dac <swapfs_read>
     cprintf("swap_in: load disk swap entry %d with swap_page in vadr 0x%x\n", (*ptep)>>8, addr);
ffffffffc0201b54:	00093583          	ld	a1,0(s2)
ffffffffc0201b58:	8626                	mv	a2,s1
ffffffffc0201b5a:	00004517          	auipc	a0,0x4
ffffffffc0201b5e:	99650513          	addi	a0,a0,-1642 # ffffffffc02054f0 <commands+0xe50>
ffffffffc0201b62:	81a1                	srli	a1,a1,0x8
ffffffffc0201b64:	d56fe0ef          	jal	ra,ffffffffc02000ba <cprintf>
}
ffffffffc0201b68:	70a2                	ld	ra,40(sp)
     *ptr_result=result;
ffffffffc0201b6a:	0089b023          	sd	s0,0(s3)
}
ffffffffc0201b6e:	7402                	ld	s0,32(sp)
ffffffffc0201b70:	64e2                	ld	s1,24(sp)
ffffffffc0201b72:	6942                	ld	s2,16(sp)
ffffffffc0201b74:	69a2                	ld	s3,8(sp)
ffffffffc0201b76:	4501                	li	a0,0
ffffffffc0201b78:	6145                	addi	sp,sp,48
ffffffffc0201b7a:	8082                	ret
     assert(result!=NULL);
ffffffffc0201b7c:	00004697          	auipc	a3,0x4
ffffffffc0201b80:	96468693          	addi	a3,a3,-1692 # ffffffffc02054e0 <commands+0xe40>
ffffffffc0201b84:	00003617          	auipc	a2,0x3
ffffffffc0201b88:	24460613          	addi	a2,a2,580 # ffffffffc0204dc8 <commands+0x728>
ffffffffc0201b8c:	07c00593          	li	a1,124
ffffffffc0201b90:	00003517          	auipc	a0,0x3
ffffffffc0201b94:	5f050513          	addi	a0,a0,1520 # ffffffffc0205180 <commands+0xae0>
ffffffffc0201b98:	d6afe0ef          	jal	ra,ffffffffc0200102 <__panic>

ffffffffc0201b9c <default_init>:
    elm->prev = elm->next = elm;
ffffffffc0201b9c:	0000f797          	auipc	a5,0xf
ffffffffc0201ba0:	53478793          	addi	a5,a5,1332 # ffffffffc02110d0 <free_area>
ffffffffc0201ba4:	e79c                	sd	a5,8(a5)
ffffffffc0201ba6:	e39c                	sd	a5,0(a5)
#define nr_free (free_area.nr_free)

static void
default_init(void) {
    list_init(&free_list);
    nr_free = 0;
ffffffffc0201ba8:	0007a823          	sw	zero,16(a5)
}
ffffffffc0201bac:	8082                	ret

ffffffffc0201bae <default_nr_free_pages>:
}

static size_t
default_nr_free_pages(void) {
    return nr_free;
}
ffffffffc0201bae:	0000f517          	auipc	a0,0xf
ffffffffc0201bb2:	53256503          	lwu	a0,1330(a0) # ffffffffc02110e0 <free_area+0x10>
ffffffffc0201bb6:	8082                	ret

ffffffffc0201bb8 <default_check>:
}

// LAB2: below code is used to check the first fit allocation algorithm
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
ffffffffc0201bb8:	715d                	addi	sp,sp,-80
ffffffffc0201bba:	e0a2                	sd	s0,64(sp)
    return listelm->next;
ffffffffc0201bbc:	0000f417          	auipc	s0,0xf
ffffffffc0201bc0:	51440413          	addi	s0,s0,1300 # ffffffffc02110d0 <free_area>
ffffffffc0201bc4:	641c                	ld	a5,8(s0)
ffffffffc0201bc6:	e486                	sd	ra,72(sp)
ffffffffc0201bc8:	fc26                	sd	s1,56(sp)
ffffffffc0201bca:	f84a                	sd	s2,48(sp)
ffffffffc0201bcc:	f44e                	sd	s3,40(sp)
ffffffffc0201bce:	f052                	sd	s4,32(sp)
ffffffffc0201bd0:	ec56                	sd	s5,24(sp)
ffffffffc0201bd2:	e85a                	sd	s6,16(sp)
ffffffffc0201bd4:	e45e                	sd	s7,8(sp)
ffffffffc0201bd6:	e062                	sd	s8,0(sp)
    int count = 0, total = 0;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
ffffffffc0201bd8:	2c878763          	beq	a5,s0,ffffffffc0201ea6 <default_check+0x2ee>
    int count = 0, total = 0;
ffffffffc0201bdc:	4481                	li	s1,0
ffffffffc0201bde:	4901                	li	s2,0
ffffffffc0201be0:	fe87b703          	ld	a4,-24(a5)
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
ffffffffc0201be4:	8b09                	andi	a4,a4,2
ffffffffc0201be6:	2c070463          	beqz	a4,ffffffffc0201eae <default_check+0x2f6>
        count ++, total += p->property;
ffffffffc0201bea:	ff87a703          	lw	a4,-8(a5)
ffffffffc0201bee:	679c                	ld	a5,8(a5)
ffffffffc0201bf0:	2905                	addiw	s2,s2,1
ffffffffc0201bf2:	9cb9                	addw	s1,s1,a4
    while ((le = list_next(le)) != &free_list) {
ffffffffc0201bf4:	fe8796e3          	bne	a5,s0,ffffffffc0201be0 <default_check+0x28>
    }
    assert(total == nr_free_pages());
ffffffffc0201bf8:	89a6                	mv	s3,s1
ffffffffc0201bfa:	6f3000ef          	jal	ra,ffffffffc0202aec <nr_free_pages>
ffffffffc0201bfe:	71351863          	bne	a0,s3,ffffffffc020230e <default_check+0x756>
    assert((p0 = alloc_page()) != NULL);
ffffffffc0201c02:	4505                	li	a0,1
ffffffffc0201c04:	617000ef          	jal	ra,ffffffffc0202a1a <alloc_pages>
ffffffffc0201c08:	8a2a                	mv	s4,a0
ffffffffc0201c0a:	44050263          	beqz	a0,ffffffffc020204e <default_check+0x496>
    assert((p1 = alloc_page()) != NULL);
ffffffffc0201c0e:	4505                	li	a0,1
ffffffffc0201c10:	60b000ef          	jal	ra,ffffffffc0202a1a <alloc_pages>
ffffffffc0201c14:	89aa                	mv	s3,a0
ffffffffc0201c16:	70050c63          	beqz	a0,ffffffffc020232e <default_check+0x776>
    assert((p2 = alloc_page()) != NULL);
ffffffffc0201c1a:	4505                	li	a0,1
ffffffffc0201c1c:	5ff000ef          	jal	ra,ffffffffc0202a1a <alloc_pages>
ffffffffc0201c20:	8aaa                	mv	s5,a0
ffffffffc0201c22:	4a050663          	beqz	a0,ffffffffc02020ce <default_check+0x516>
    assert(p0 != p1 && p0 != p2 && p1 != p2);
ffffffffc0201c26:	2b3a0463          	beq	s4,s3,ffffffffc0201ece <default_check+0x316>
ffffffffc0201c2a:	2aaa0263          	beq	s4,a0,ffffffffc0201ece <default_check+0x316>
ffffffffc0201c2e:	2aa98063          	beq	s3,a0,ffffffffc0201ece <default_check+0x316>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
ffffffffc0201c32:	000a2783          	lw	a5,0(s4)
ffffffffc0201c36:	2a079c63          	bnez	a5,ffffffffc0201eee <default_check+0x336>
ffffffffc0201c3a:	0009a783          	lw	a5,0(s3)
ffffffffc0201c3e:	2a079863          	bnez	a5,ffffffffc0201eee <default_check+0x336>
ffffffffc0201c42:	411c                	lw	a5,0(a0)
ffffffffc0201c44:	2a079563          	bnez	a5,ffffffffc0201eee <default_check+0x336>
static inline ppn_t page2ppn(struct Page *page) { return page - pages + nbase; }
ffffffffc0201c48:	00010797          	auipc	a5,0x10
ffffffffc0201c4c:	9107b783          	ld	a5,-1776(a5) # ffffffffc0211558 <pages>
ffffffffc0201c50:	40fa0733          	sub	a4,s4,a5
ffffffffc0201c54:	870d                	srai	a4,a4,0x3
ffffffffc0201c56:	00004597          	auipc	a1,0x4
ffffffffc0201c5a:	5f25b583          	ld	a1,1522(a1) # ffffffffc0206248 <error_string+0x38>
ffffffffc0201c5e:	02b70733          	mul	a4,a4,a1
ffffffffc0201c62:	00004617          	auipc	a2,0x4
ffffffffc0201c66:	5ee63603          	ld	a2,1518(a2) # ffffffffc0206250 <nbase>
    assert(page2pa(p0) < npage * PGSIZE);
ffffffffc0201c6a:	00010697          	auipc	a3,0x10
ffffffffc0201c6e:	8e66b683          	ld	a3,-1818(a3) # ffffffffc0211550 <npage>
ffffffffc0201c72:	06b2                	slli	a3,a3,0xc
ffffffffc0201c74:	9732                	add	a4,a4,a2
    return page2ppn(page) << PGSHIFT;
ffffffffc0201c76:	0732                	slli	a4,a4,0xc
ffffffffc0201c78:	28d77b63          	bgeu	a4,a3,ffffffffc0201f0e <default_check+0x356>
static inline ppn_t page2ppn(struct Page *page) { return page - pages + nbase; }
ffffffffc0201c7c:	40f98733          	sub	a4,s3,a5
ffffffffc0201c80:	870d                	srai	a4,a4,0x3
ffffffffc0201c82:	02b70733          	mul	a4,a4,a1
ffffffffc0201c86:	9732                	add	a4,a4,a2
    return page2ppn(page) << PGSHIFT;
ffffffffc0201c88:	0732                	slli	a4,a4,0xc
    assert(page2pa(p1) < npage * PGSIZE);
ffffffffc0201c8a:	4cd77263          	bgeu	a4,a3,ffffffffc020214e <default_check+0x596>
static inline ppn_t page2ppn(struct Page *page) { return page - pages + nbase; }
ffffffffc0201c8e:	40f507b3          	sub	a5,a0,a5
ffffffffc0201c92:	878d                	srai	a5,a5,0x3
ffffffffc0201c94:	02b787b3          	mul	a5,a5,a1
ffffffffc0201c98:	97b2                	add	a5,a5,a2
    return page2ppn(page) << PGSHIFT;
ffffffffc0201c9a:	07b2                	slli	a5,a5,0xc
    assert(page2pa(p2) < npage * PGSIZE);
ffffffffc0201c9c:	30d7f963          	bgeu	a5,a3,ffffffffc0201fae <default_check+0x3f6>
    assert(alloc_page() == NULL);
ffffffffc0201ca0:	4505                	li	a0,1
    list_entry_t free_list_store = free_list;
ffffffffc0201ca2:	00043c03          	ld	s8,0(s0)
ffffffffc0201ca6:	00843b83          	ld	s7,8(s0)
    unsigned int nr_free_store = nr_free;
ffffffffc0201caa:	01042b03          	lw	s6,16(s0)
    elm->prev = elm->next = elm;
ffffffffc0201cae:	e400                	sd	s0,8(s0)
ffffffffc0201cb0:	e000                	sd	s0,0(s0)
    nr_free = 0;
ffffffffc0201cb2:	0000f797          	auipc	a5,0xf
ffffffffc0201cb6:	4207a723          	sw	zero,1070(a5) # ffffffffc02110e0 <free_area+0x10>
    assert(alloc_page() == NULL);
ffffffffc0201cba:	561000ef          	jal	ra,ffffffffc0202a1a <alloc_pages>
ffffffffc0201cbe:	2c051863          	bnez	a0,ffffffffc0201f8e <default_check+0x3d6>
    free_page(p0);
ffffffffc0201cc2:	4585                	li	a1,1
ffffffffc0201cc4:	8552                	mv	a0,s4
ffffffffc0201cc6:	5e7000ef          	jal	ra,ffffffffc0202aac <free_pages>
    free_page(p1);
ffffffffc0201cca:	4585                	li	a1,1
ffffffffc0201ccc:	854e                	mv	a0,s3
ffffffffc0201cce:	5df000ef          	jal	ra,ffffffffc0202aac <free_pages>
    free_page(p2);
ffffffffc0201cd2:	4585                	li	a1,1
ffffffffc0201cd4:	8556                	mv	a0,s5
ffffffffc0201cd6:	5d7000ef          	jal	ra,ffffffffc0202aac <free_pages>
    assert(nr_free == 3);
ffffffffc0201cda:	4818                	lw	a4,16(s0)
ffffffffc0201cdc:	478d                	li	a5,3
ffffffffc0201cde:	28f71863          	bne	a4,a5,ffffffffc0201f6e <default_check+0x3b6>
    assert((p0 = alloc_page()) != NULL);
ffffffffc0201ce2:	4505                	li	a0,1
ffffffffc0201ce4:	537000ef          	jal	ra,ffffffffc0202a1a <alloc_pages>
ffffffffc0201ce8:	89aa                	mv	s3,a0
ffffffffc0201cea:	26050263          	beqz	a0,ffffffffc0201f4e <default_check+0x396>
    assert((p1 = alloc_page()) != NULL);
ffffffffc0201cee:	4505                	li	a0,1
ffffffffc0201cf0:	52b000ef          	jal	ra,ffffffffc0202a1a <alloc_pages>
ffffffffc0201cf4:	8aaa                	mv	s5,a0
ffffffffc0201cf6:	3a050c63          	beqz	a0,ffffffffc02020ae <default_check+0x4f6>
    assert((p2 = alloc_page()) != NULL);
ffffffffc0201cfa:	4505                	li	a0,1
ffffffffc0201cfc:	51f000ef          	jal	ra,ffffffffc0202a1a <alloc_pages>
ffffffffc0201d00:	8a2a                	mv	s4,a0
ffffffffc0201d02:	38050663          	beqz	a0,ffffffffc020208e <default_check+0x4d6>
    assert(alloc_page() == NULL);
ffffffffc0201d06:	4505                	li	a0,1
ffffffffc0201d08:	513000ef          	jal	ra,ffffffffc0202a1a <alloc_pages>
ffffffffc0201d0c:	36051163          	bnez	a0,ffffffffc020206e <default_check+0x4b6>
    free_page(p0);
ffffffffc0201d10:	4585                	li	a1,1
ffffffffc0201d12:	854e                	mv	a0,s3
ffffffffc0201d14:	599000ef          	jal	ra,ffffffffc0202aac <free_pages>
    assert(!list_empty(&free_list));
ffffffffc0201d18:	641c                	ld	a5,8(s0)
ffffffffc0201d1a:	20878a63          	beq	a5,s0,ffffffffc0201f2e <default_check+0x376>
    assert((p = alloc_page()) == p0);
ffffffffc0201d1e:	4505                	li	a0,1
ffffffffc0201d20:	4fb000ef          	jal	ra,ffffffffc0202a1a <alloc_pages>
ffffffffc0201d24:	30a99563          	bne	s3,a0,ffffffffc020202e <default_check+0x476>
    assert(alloc_page() == NULL);
ffffffffc0201d28:	4505                	li	a0,1
ffffffffc0201d2a:	4f1000ef          	jal	ra,ffffffffc0202a1a <alloc_pages>
ffffffffc0201d2e:	2e051063          	bnez	a0,ffffffffc020200e <default_check+0x456>
    assert(nr_free == 0);
ffffffffc0201d32:	481c                	lw	a5,16(s0)
ffffffffc0201d34:	2a079d63          	bnez	a5,ffffffffc0201fee <default_check+0x436>
    free_page(p);
ffffffffc0201d38:	854e                	mv	a0,s3
ffffffffc0201d3a:	4585                	li	a1,1
    free_list = free_list_store;
ffffffffc0201d3c:	01843023          	sd	s8,0(s0)
ffffffffc0201d40:	01743423          	sd	s7,8(s0)
    nr_free = nr_free_store;
ffffffffc0201d44:	01642823          	sw	s6,16(s0)
    free_page(p);
ffffffffc0201d48:	565000ef          	jal	ra,ffffffffc0202aac <free_pages>
    free_page(p1);
ffffffffc0201d4c:	4585                	li	a1,1
ffffffffc0201d4e:	8556                	mv	a0,s5
ffffffffc0201d50:	55d000ef          	jal	ra,ffffffffc0202aac <free_pages>
    free_page(p2);
ffffffffc0201d54:	4585                	li	a1,1
ffffffffc0201d56:	8552                	mv	a0,s4
ffffffffc0201d58:	555000ef          	jal	ra,ffffffffc0202aac <free_pages>

    basic_check();

    struct Page *p0 = alloc_pages(5), *p1, *p2;
ffffffffc0201d5c:	4515                	li	a0,5
ffffffffc0201d5e:	4bd000ef          	jal	ra,ffffffffc0202a1a <alloc_pages>
ffffffffc0201d62:	89aa                	mv	s3,a0
    assert(p0 != NULL);
ffffffffc0201d64:	26050563          	beqz	a0,ffffffffc0201fce <default_check+0x416>
ffffffffc0201d68:	651c                	ld	a5,8(a0)
ffffffffc0201d6a:	8385                	srli	a5,a5,0x1
    assert(!PageProperty(p0));
ffffffffc0201d6c:	8b85                	andi	a5,a5,1
ffffffffc0201d6e:	54079063          	bnez	a5,ffffffffc02022ae <default_check+0x6f6>

    list_entry_t free_list_store = free_list;
    list_init(&free_list);
    assert(list_empty(&free_list));
    assert(alloc_page() == NULL);
ffffffffc0201d72:	4505                	li	a0,1
    list_entry_t free_list_store = free_list;
ffffffffc0201d74:	00043b03          	ld	s6,0(s0)
ffffffffc0201d78:	00843a83          	ld	s5,8(s0)
ffffffffc0201d7c:	e000                	sd	s0,0(s0)
ffffffffc0201d7e:	e400                	sd	s0,8(s0)
    assert(alloc_page() == NULL);
ffffffffc0201d80:	49b000ef          	jal	ra,ffffffffc0202a1a <alloc_pages>
ffffffffc0201d84:	50051563          	bnez	a0,ffffffffc020228e <default_check+0x6d6>

    unsigned int nr_free_store = nr_free;
    nr_free = 0;

    free_pages(p0 + 2, 3);
ffffffffc0201d88:	09098a13          	addi	s4,s3,144
ffffffffc0201d8c:	8552                	mv	a0,s4
ffffffffc0201d8e:	458d                	li	a1,3
    unsigned int nr_free_store = nr_free;
ffffffffc0201d90:	01042b83          	lw	s7,16(s0)
    nr_free = 0;
ffffffffc0201d94:	0000f797          	auipc	a5,0xf
ffffffffc0201d98:	3407a623          	sw	zero,844(a5) # ffffffffc02110e0 <free_area+0x10>
    free_pages(p0 + 2, 3);
ffffffffc0201d9c:	511000ef          	jal	ra,ffffffffc0202aac <free_pages>
    assert(alloc_pages(4) == NULL);
ffffffffc0201da0:	4511                	li	a0,4
ffffffffc0201da2:	479000ef          	jal	ra,ffffffffc0202a1a <alloc_pages>
ffffffffc0201da6:	4c051463          	bnez	a0,ffffffffc020226e <default_check+0x6b6>
ffffffffc0201daa:	0989b783          	ld	a5,152(s3)
ffffffffc0201dae:	8385                	srli	a5,a5,0x1
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
ffffffffc0201db0:	8b85                	andi	a5,a5,1
ffffffffc0201db2:	48078e63          	beqz	a5,ffffffffc020224e <default_check+0x696>
ffffffffc0201db6:	0a89a703          	lw	a4,168(s3)
ffffffffc0201dba:	478d                	li	a5,3
ffffffffc0201dbc:	48f71963          	bne	a4,a5,ffffffffc020224e <default_check+0x696>
    assert((p1 = alloc_pages(3)) != NULL);
ffffffffc0201dc0:	450d                	li	a0,3
ffffffffc0201dc2:	459000ef          	jal	ra,ffffffffc0202a1a <alloc_pages>
ffffffffc0201dc6:	8c2a                	mv	s8,a0
ffffffffc0201dc8:	46050363          	beqz	a0,ffffffffc020222e <default_check+0x676>
    assert(alloc_page() == NULL);
ffffffffc0201dcc:	4505                	li	a0,1
ffffffffc0201dce:	44d000ef          	jal	ra,ffffffffc0202a1a <alloc_pages>
ffffffffc0201dd2:	42051e63          	bnez	a0,ffffffffc020220e <default_check+0x656>
    assert(p0 + 2 == p1);
ffffffffc0201dd6:	418a1c63          	bne	s4,s8,ffffffffc02021ee <default_check+0x636>

    p2 = p0 + 1;
    free_page(p0);
ffffffffc0201dda:	4585                	li	a1,1
ffffffffc0201ddc:	854e                	mv	a0,s3
ffffffffc0201dde:	4cf000ef          	jal	ra,ffffffffc0202aac <free_pages>
    free_pages(p1, 3);
ffffffffc0201de2:	458d                	li	a1,3
ffffffffc0201de4:	8552                	mv	a0,s4
ffffffffc0201de6:	4c7000ef          	jal	ra,ffffffffc0202aac <free_pages>
ffffffffc0201dea:	0089b783          	ld	a5,8(s3)
    p2 = p0 + 1;
ffffffffc0201dee:	04898c13          	addi	s8,s3,72
ffffffffc0201df2:	8385                	srli	a5,a5,0x1
    assert(PageProperty(p0) && p0->property == 1);
ffffffffc0201df4:	8b85                	andi	a5,a5,1
ffffffffc0201df6:	3c078c63          	beqz	a5,ffffffffc02021ce <default_check+0x616>
ffffffffc0201dfa:	0189a703          	lw	a4,24(s3)
ffffffffc0201dfe:	4785                	li	a5,1
ffffffffc0201e00:	3cf71763          	bne	a4,a5,ffffffffc02021ce <default_check+0x616>
ffffffffc0201e04:	008a3783          	ld	a5,8(s4)
ffffffffc0201e08:	8385                	srli	a5,a5,0x1
    assert(PageProperty(p1) && p1->property == 3);
ffffffffc0201e0a:	8b85                	andi	a5,a5,1
ffffffffc0201e0c:	3a078163          	beqz	a5,ffffffffc02021ae <default_check+0x5f6>
ffffffffc0201e10:	018a2703          	lw	a4,24(s4)
ffffffffc0201e14:	478d                	li	a5,3
ffffffffc0201e16:	38f71c63          	bne	a4,a5,ffffffffc02021ae <default_check+0x5f6>

    assert((p0 = alloc_page()) == p2 - 1);
ffffffffc0201e1a:	4505                	li	a0,1
ffffffffc0201e1c:	3ff000ef          	jal	ra,ffffffffc0202a1a <alloc_pages>
ffffffffc0201e20:	36a99763          	bne	s3,a0,ffffffffc020218e <default_check+0x5d6>
    free_page(p0);
ffffffffc0201e24:	4585                	li	a1,1
ffffffffc0201e26:	487000ef          	jal	ra,ffffffffc0202aac <free_pages>
    assert((p0 = alloc_pages(2)) == p2 + 1);
ffffffffc0201e2a:	4509                	li	a0,2
ffffffffc0201e2c:	3ef000ef          	jal	ra,ffffffffc0202a1a <alloc_pages>
ffffffffc0201e30:	32aa1f63          	bne	s4,a0,ffffffffc020216e <default_check+0x5b6>

    free_pages(p0, 2);
ffffffffc0201e34:	4589                	li	a1,2
ffffffffc0201e36:	477000ef          	jal	ra,ffffffffc0202aac <free_pages>
    free_page(p2);
ffffffffc0201e3a:	4585                	li	a1,1
ffffffffc0201e3c:	8562                	mv	a0,s8
ffffffffc0201e3e:	46f000ef          	jal	ra,ffffffffc0202aac <free_pages>

    assert((p0 = alloc_pages(5)) != NULL);
ffffffffc0201e42:	4515                	li	a0,5
ffffffffc0201e44:	3d7000ef          	jal	ra,ffffffffc0202a1a <alloc_pages>
ffffffffc0201e48:	89aa                	mv	s3,a0
ffffffffc0201e4a:	48050263          	beqz	a0,ffffffffc02022ce <default_check+0x716>
    assert(alloc_page() == NULL);
ffffffffc0201e4e:	4505                	li	a0,1
ffffffffc0201e50:	3cb000ef          	jal	ra,ffffffffc0202a1a <alloc_pages>
ffffffffc0201e54:	2c051d63          	bnez	a0,ffffffffc020212e <default_check+0x576>

    assert(nr_free == 0);
ffffffffc0201e58:	481c                	lw	a5,16(s0)
ffffffffc0201e5a:	2a079a63          	bnez	a5,ffffffffc020210e <default_check+0x556>
    nr_free = nr_free_store;

    free_list = free_list_store;
    free_pages(p0, 5);
ffffffffc0201e5e:	4595                	li	a1,5
ffffffffc0201e60:	854e                	mv	a0,s3
    nr_free = nr_free_store;
ffffffffc0201e62:	01742823          	sw	s7,16(s0)
    free_list = free_list_store;
ffffffffc0201e66:	01643023          	sd	s6,0(s0)
ffffffffc0201e6a:	01543423          	sd	s5,8(s0)
    free_pages(p0, 5);
ffffffffc0201e6e:	43f000ef          	jal	ra,ffffffffc0202aac <free_pages>
    return listelm->next;
ffffffffc0201e72:	641c                	ld	a5,8(s0)

    le = &free_list;
    while ((le = list_next(le)) != &free_list) {
ffffffffc0201e74:	00878963          	beq	a5,s0,ffffffffc0201e86 <default_check+0x2ce>
        struct Page *p = le2page(le, page_link);
        count --, total -= p->property;
ffffffffc0201e78:	ff87a703          	lw	a4,-8(a5)
ffffffffc0201e7c:	679c                	ld	a5,8(a5)
ffffffffc0201e7e:	397d                	addiw	s2,s2,-1
ffffffffc0201e80:	9c99                	subw	s1,s1,a4
    while ((le = list_next(le)) != &free_list) {
ffffffffc0201e82:	fe879be3          	bne	a5,s0,ffffffffc0201e78 <default_check+0x2c0>
    }
    assert(count == 0);
ffffffffc0201e86:	26091463          	bnez	s2,ffffffffc02020ee <default_check+0x536>
    assert(total == 0);
ffffffffc0201e8a:	46049263          	bnez	s1,ffffffffc02022ee <default_check+0x736>
}
ffffffffc0201e8e:	60a6                	ld	ra,72(sp)
ffffffffc0201e90:	6406                	ld	s0,64(sp)
ffffffffc0201e92:	74e2                	ld	s1,56(sp)
ffffffffc0201e94:	7942                	ld	s2,48(sp)
ffffffffc0201e96:	79a2                	ld	s3,40(sp)
ffffffffc0201e98:	7a02                	ld	s4,32(sp)
ffffffffc0201e9a:	6ae2                	ld	s5,24(sp)
ffffffffc0201e9c:	6b42                	ld	s6,16(sp)
ffffffffc0201e9e:	6ba2                	ld	s7,8(sp)
ffffffffc0201ea0:	6c02                	ld	s8,0(sp)
ffffffffc0201ea2:	6161                	addi	sp,sp,80
ffffffffc0201ea4:	8082                	ret
    while ((le = list_next(le)) != &free_list) {
ffffffffc0201ea6:	4981                	li	s3,0
    int count = 0, total = 0;
ffffffffc0201ea8:	4481                	li	s1,0
ffffffffc0201eaa:	4901                	li	s2,0
ffffffffc0201eac:	b3b9                	j	ffffffffc0201bfa <default_check+0x42>
        assert(PageProperty(p));
ffffffffc0201eae:	00003697          	auipc	a3,0x3
ffffffffc0201eb2:	2fa68693          	addi	a3,a3,762 # ffffffffc02051a8 <commands+0xb08>
ffffffffc0201eb6:	00003617          	auipc	a2,0x3
ffffffffc0201eba:	f1260613          	addi	a2,a2,-238 # ffffffffc0204dc8 <commands+0x728>
ffffffffc0201ebe:	0f000593          	li	a1,240
ffffffffc0201ec2:	00003517          	auipc	a0,0x3
ffffffffc0201ec6:	66e50513          	addi	a0,a0,1646 # ffffffffc0205530 <commands+0xe90>
ffffffffc0201eca:	a38fe0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(p0 != p1 && p0 != p2 && p1 != p2);
ffffffffc0201ece:	00003697          	auipc	a3,0x3
ffffffffc0201ed2:	6da68693          	addi	a3,a3,1754 # ffffffffc02055a8 <commands+0xf08>
ffffffffc0201ed6:	00003617          	auipc	a2,0x3
ffffffffc0201eda:	ef260613          	addi	a2,a2,-270 # ffffffffc0204dc8 <commands+0x728>
ffffffffc0201ede:	0bd00593          	li	a1,189
ffffffffc0201ee2:	00003517          	auipc	a0,0x3
ffffffffc0201ee6:	64e50513          	addi	a0,a0,1614 # ffffffffc0205530 <commands+0xe90>
ffffffffc0201eea:	a18fe0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
ffffffffc0201eee:	00003697          	auipc	a3,0x3
ffffffffc0201ef2:	6e268693          	addi	a3,a3,1762 # ffffffffc02055d0 <commands+0xf30>
ffffffffc0201ef6:	00003617          	auipc	a2,0x3
ffffffffc0201efa:	ed260613          	addi	a2,a2,-302 # ffffffffc0204dc8 <commands+0x728>
ffffffffc0201efe:	0be00593          	li	a1,190
ffffffffc0201f02:	00003517          	auipc	a0,0x3
ffffffffc0201f06:	62e50513          	addi	a0,a0,1582 # ffffffffc0205530 <commands+0xe90>
ffffffffc0201f0a:	9f8fe0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(page2pa(p0) < npage * PGSIZE);
ffffffffc0201f0e:	00003697          	auipc	a3,0x3
ffffffffc0201f12:	70268693          	addi	a3,a3,1794 # ffffffffc0205610 <commands+0xf70>
ffffffffc0201f16:	00003617          	auipc	a2,0x3
ffffffffc0201f1a:	eb260613          	addi	a2,a2,-334 # ffffffffc0204dc8 <commands+0x728>
ffffffffc0201f1e:	0c000593          	li	a1,192
ffffffffc0201f22:	00003517          	auipc	a0,0x3
ffffffffc0201f26:	60e50513          	addi	a0,a0,1550 # ffffffffc0205530 <commands+0xe90>
ffffffffc0201f2a:	9d8fe0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(!list_empty(&free_list));
ffffffffc0201f2e:	00003697          	auipc	a3,0x3
ffffffffc0201f32:	76a68693          	addi	a3,a3,1898 # ffffffffc0205698 <commands+0xff8>
ffffffffc0201f36:	00003617          	auipc	a2,0x3
ffffffffc0201f3a:	e9260613          	addi	a2,a2,-366 # ffffffffc0204dc8 <commands+0x728>
ffffffffc0201f3e:	0d900593          	li	a1,217
ffffffffc0201f42:	00003517          	auipc	a0,0x3
ffffffffc0201f46:	5ee50513          	addi	a0,a0,1518 # ffffffffc0205530 <commands+0xe90>
ffffffffc0201f4a:	9b8fe0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert((p0 = alloc_page()) != NULL);
ffffffffc0201f4e:	00003697          	auipc	a3,0x3
ffffffffc0201f52:	5fa68693          	addi	a3,a3,1530 # ffffffffc0205548 <commands+0xea8>
ffffffffc0201f56:	00003617          	auipc	a2,0x3
ffffffffc0201f5a:	e7260613          	addi	a2,a2,-398 # ffffffffc0204dc8 <commands+0x728>
ffffffffc0201f5e:	0d200593          	li	a1,210
ffffffffc0201f62:	00003517          	auipc	a0,0x3
ffffffffc0201f66:	5ce50513          	addi	a0,a0,1486 # ffffffffc0205530 <commands+0xe90>
ffffffffc0201f6a:	998fe0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(nr_free == 3);
ffffffffc0201f6e:	00003697          	auipc	a3,0x3
ffffffffc0201f72:	71a68693          	addi	a3,a3,1818 # ffffffffc0205688 <commands+0xfe8>
ffffffffc0201f76:	00003617          	auipc	a2,0x3
ffffffffc0201f7a:	e5260613          	addi	a2,a2,-430 # ffffffffc0204dc8 <commands+0x728>
ffffffffc0201f7e:	0d000593          	li	a1,208
ffffffffc0201f82:	00003517          	auipc	a0,0x3
ffffffffc0201f86:	5ae50513          	addi	a0,a0,1454 # ffffffffc0205530 <commands+0xe90>
ffffffffc0201f8a:	978fe0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(alloc_page() == NULL);
ffffffffc0201f8e:	00003697          	auipc	a3,0x3
ffffffffc0201f92:	6e268693          	addi	a3,a3,1762 # ffffffffc0205670 <commands+0xfd0>
ffffffffc0201f96:	00003617          	auipc	a2,0x3
ffffffffc0201f9a:	e3260613          	addi	a2,a2,-462 # ffffffffc0204dc8 <commands+0x728>
ffffffffc0201f9e:	0cb00593          	li	a1,203
ffffffffc0201fa2:	00003517          	auipc	a0,0x3
ffffffffc0201fa6:	58e50513          	addi	a0,a0,1422 # ffffffffc0205530 <commands+0xe90>
ffffffffc0201faa:	958fe0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
ffffffffc0201fae:	00003697          	auipc	a3,0x3
ffffffffc0201fb2:	6a268693          	addi	a3,a3,1698 # ffffffffc0205650 <commands+0xfb0>
ffffffffc0201fb6:	00003617          	auipc	a2,0x3
ffffffffc0201fba:	e1260613          	addi	a2,a2,-494 # ffffffffc0204dc8 <commands+0x728>
ffffffffc0201fbe:	0c200593          	li	a1,194
ffffffffc0201fc2:	00003517          	auipc	a0,0x3
ffffffffc0201fc6:	56e50513          	addi	a0,a0,1390 # ffffffffc0205530 <commands+0xe90>
ffffffffc0201fca:	938fe0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(p0 != NULL);
ffffffffc0201fce:	00003697          	auipc	a3,0x3
ffffffffc0201fd2:	70268693          	addi	a3,a3,1794 # ffffffffc02056d0 <commands+0x1030>
ffffffffc0201fd6:	00003617          	auipc	a2,0x3
ffffffffc0201fda:	df260613          	addi	a2,a2,-526 # ffffffffc0204dc8 <commands+0x728>
ffffffffc0201fde:	0f800593          	li	a1,248
ffffffffc0201fe2:	00003517          	auipc	a0,0x3
ffffffffc0201fe6:	54e50513          	addi	a0,a0,1358 # ffffffffc0205530 <commands+0xe90>
ffffffffc0201fea:	918fe0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(nr_free == 0);
ffffffffc0201fee:	00003697          	auipc	a3,0x3
ffffffffc0201ff2:	36a68693          	addi	a3,a3,874 # ffffffffc0205358 <commands+0xcb8>
ffffffffc0201ff6:	00003617          	auipc	a2,0x3
ffffffffc0201ffa:	dd260613          	addi	a2,a2,-558 # ffffffffc0204dc8 <commands+0x728>
ffffffffc0201ffe:	0df00593          	li	a1,223
ffffffffc0202002:	00003517          	auipc	a0,0x3
ffffffffc0202006:	52e50513          	addi	a0,a0,1326 # ffffffffc0205530 <commands+0xe90>
ffffffffc020200a:	8f8fe0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(alloc_page() == NULL);
ffffffffc020200e:	00003697          	auipc	a3,0x3
ffffffffc0202012:	66268693          	addi	a3,a3,1634 # ffffffffc0205670 <commands+0xfd0>
ffffffffc0202016:	00003617          	auipc	a2,0x3
ffffffffc020201a:	db260613          	addi	a2,a2,-590 # ffffffffc0204dc8 <commands+0x728>
ffffffffc020201e:	0dd00593          	li	a1,221
ffffffffc0202022:	00003517          	auipc	a0,0x3
ffffffffc0202026:	50e50513          	addi	a0,a0,1294 # ffffffffc0205530 <commands+0xe90>
ffffffffc020202a:	8d8fe0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert((p = alloc_page()) == p0);
ffffffffc020202e:	00003697          	auipc	a3,0x3
ffffffffc0202032:	68268693          	addi	a3,a3,1666 # ffffffffc02056b0 <commands+0x1010>
ffffffffc0202036:	00003617          	auipc	a2,0x3
ffffffffc020203a:	d9260613          	addi	a2,a2,-622 # ffffffffc0204dc8 <commands+0x728>
ffffffffc020203e:	0dc00593          	li	a1,220
ffffffffc0202042:	00003517          	auipc	a0,0x3
ffffffffc0202046:	4ee50513          	addi	a0,a0,1262 # ffffffffc0205530 <commands+0xe90>
ffffffffc020204a:	8b8fe0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert((p0 = alloc_page()) != NULL);
ffffffffc020204e:	00003697          	auipc	a3,0x3
ffffffffc0202052:	4fa68693          	addi	a3,a3,1274 # ffffffffc0205548 <commands+0xea8>
ffffffffc0202056:	00003617          	auipc	a2,0x3
ffffffffc020205a:	d7260613          	addi	a2,a2,-654 # ffffffffc0204dc8 <commands+0x728>
ffffffffc020205e:	0b900593          	li	a1,185
ffffffffc0202062:	00003517          	auipc	a0,0x3
ffffffffc0202066:	4ce50513          	addi	a0,a0,1230 # ffffffffc0205530 <commands+0xe90>
ffffffffc020206a:	898fe0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(alloc_page() == NULL);
ffffffffc020206e:	00003697          	auipc	a3,0x3
ffffffffc0202072:	60268693          	addi	a3,a3,1538 # ffffffffc0205670 <commands+0xfd0>
ffffffffc0202076:	00003617          	auipc	a2,0x3
ffffffffc020207a:	d5260613          	addi	a2,a2,-686 # ffffffffc0204dc8 <commands+0x728>
ffffffffc020207e:	0d600593          	li	a1,214
ffffffffc0202082:	00003517          	auipc	a0,0x3
ffffffffc0202086:	4ae50513          	addi	a0,a0,1198 # ffffffffc0205530 <commands+0xe90>
ffffffffc020208a:	878fe0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert((p2 = alloc_page()) != NULL);
ffffffffc020208e:	00003697          	auipc	a3,0x3
ffffffffc0202092:	4fa68693          	addi	a3,a3,1274 # ffffffffc0205588 <commands+0xee8>
ffffffffc0202096:	00003617          	auipc	a2,0x3
ffffffffc020209a:	d3260613          	addi	a2,a2,-718 # ffffffffc0204dc8 <commands+0x728>
ffffffffc020209e:	0d400593          	li	a1,212
ffffffffc02020a2:	00003517          	auipc	a0,0x3
ffffffffc02020a6:	48e50513          	addi	a0,a0,1166 # ffffffffc0205530 <commands+0xe90>
ffffffffc02020aa:	858fe0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert((p1 = alloc_page()) != NULL);
ffffffffc02020ae:	00003697          	auipc	a3,0x3
ffffffffc02020b2:	4ba68693          	addi	a3,a3,1210 # ffffffffc0205568 <commands+0xec8>
ffffffffc02020b6:	00003617          	auipc	a2,0x3
ffffffffc02020ba:	d1260613          	addi	a2,a2,-750 # ffffffffc0204dc8 <commands+0x728>
ffffffffc02020be:	0d300593          	li	a1,211
ffffffffc02020c2:	00003517          	auipc	a0,0x3
ffffffffc02020c6:	46e50513          	addi	a0,a0,1134 # ffffffffc0205530 <commands+0xe90>
ffffffffc02020ca:	838fe0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert((p2 = alloc_page()) != NULL);
ffffffffc02020ce:	00003697          	auipc	a3,0x3
ffffffffc02020d2:	4ba68693          	addi	a3,a3,1210 # ffffffffc0205588 <commands+0xee8>
ffffffffc02020d6:	00003617          	auipc	a2,0x3
ffffffffc02020da:	cf260613          	addi	a2,a2,-782 # ffffffffc0204dc8 <commands+0x728>
ffffffffc02020de:	0bb00593          	li	a1,187
ffffffffc02020e2:	00003517          	auipc	a0,0x3
ffffffffc02020e6:	44e50513          	addi	a0,a0,1102 # ffffffffc0205530 <commands+0xe90>
ffffffffc02020ea:	818fe0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(count == 0);
ffffffffc02020ee:	00003697          	auipc	a3,0x3
ffffffffc02020f2:	73268693          	addi	a3,a3,1842 # ffffffffc0205820 <commands+0x1180>
ffffffffc02020f6:	00003617          	auipc	a2,0x3
ffffffffc02020fa:	cd260613          	addi	a2,a2,-814 # ffffffffc0204dc8 <commands+0x728>
ffffffffc02020fe:	12500593          	li	a1,293
ffffffffc0202102:	00003517          	auipc	a0,0x3
ffffffffc0202106:	42e50513          	addi	a0,a0,1070 # ffffffffc0205530 <commands+0xe90>
ffffffffc020210a:	ff9fd0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(nr_free == 0);
ffffffffc020210e:	00003697          	auipc	a3,0x3
ffffffffc0202112:	24a68693          	addi	a3,a3,586 # ffffffffc0205358 <commands+0xcb8>
ffffffffc0202116:	00003617          	auipc	a2,0x3
ffffffffc020211a:	cb260613          	addi	a2,a2,-846 # ffffffffc0204dc8 <commands+0x728>
ffffffffc020211e:	11a00593          	li	a1,282
ffffffffc0202122:	00003517          	auipc	a0,0x3
ffffffffc0202126:	40e50513          	addi	a0,a0,1038 # ffffffffc0205530 <commands+0xe90>
ffffffffc020212a:	fd9fd0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(alloc_page() == NULL);
ffffffffc020212e:	00003697          	auipc	a3,0x3
ffffffffc0202132:	54268693          	addi	a3,a3,1346 # ffffffffc0205670 <commands+0xfd0>
ffffffffc0202136:	00003617          	auipc	a2,0x3
ffffffffc020213a:	c9260613          	addi	a2,a2,-878 # ffffffffc0204dc8 <commands+0x728>
ffffffffc020213e:	11800593          	li	a1,280
ffffffffc0202142:	00003517          	auipc	a0,0x3
ffffffffc0202146:	3ee50513          	addi	a0,a0,1006 # ffffffffc0205530 <commands+0xe90>
ffffffffc020214a:	fb9fd0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
ffffffffc020214e:	00003697          	auipc	a3,0x3
ffffffffc0202152:	4e268693          	addi	a3,a3,1250 # ffffffffc0205630 <commands+0xf90>
ffffffffc0202156:	00003617          	auipc	a2,0x3
ffffffffc020215a:	c7260613          	addi	a2,a2,-910 # ffffffffc0204dc8 <commands+0x728>
ffffffffc020215e:	0c100593          	li	a1,193
ffffffffc0202162:	00003517          	auipc	a0,0x3
ffffffffc0202166:	3ce50513          	addi	a0,a0,974 # ffffffffc0205530 <commands+0xe90>
ffffffffc020216a:	f99fd0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert((p0 = alloc_pages(2)) == p2 + 1);
ffffffffc020216e:	00003697          	auipc	a3,0x3
ffffffffc0202172:	67268693          	addi	a3,a3,1650 # ffffffffc02057e0 <commands+0x1140>
ffffffffc0202176:	00003617          	auipc	a2,0x3
ffffffffc020217a:	c5260613          	addi	a2,a2,-942 # ffffffffc0204dc8 <commands+0x728>
ffffffffc020217e:	11200593          	li	a1,274
ffffffffc0202182:	00003517          	auipc	a0,0x3
ffffffffc0202186:	3ae50513          	addi	a0,a0,942 # ffffffffc0205530 <commands+0xe90>
ffffffffc020218a:	f79fd0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert((p0 = alloc_page()) == p2 - 1);
ffffffffc020218e:	00003697          	auipc	a3,0x3
ffffffffc0202192:	63268693          	addi	a3,a3,1586 # ffffffffc02057c0 <commands+0x1120>
ffffffffc0202196:	00003617          	auipc	a2,0x3
ffffffffc020219a:	c3260613          	addi	a2,a2,-974 # ffffffffc0204dc8 <commands+0x728>
ffffffffc020219e:	11000593          	li	a1,272
ffffffffc02021a2:	00003517          	auipc	a0,0x3
ffffffffc02021a6:	38e50513          	addi	a0,a0,910 # ffffffffc0205530 <commands+0xe90>
ffffffffc02021aa:	f59fd0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(PageProperty(p1) && p1->property == 3);
ffffffffc02021ae:	00003697          	auipc	a3,0x3
ffffffffc02021b2:	5ea68693          	addi	a3,a3,1514 # ffffffffc0205798 <commands+0x10f8>
ffffffffc02021b6:	00003617          	auipc	a2,0x3
ffffffffc02021ba:	c1260613          	addi	a2,a2,-1006 # ffffffffc0204dc8 <commands+0x728>
ffffffffc02021be:	10e00593          	li	a1,270
ffffffffc02021c2:	00003517          	auipc	a0,0x3
ffffffffc02021c6:	36e50513          	addi	a0,a0,878 # ffffffffc0205530 <commands+0xe90>
ffffffffc02021ca:	f39fd0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(PageProperty(p0) && p0->property == 1);
ffffffffc02021ce:	00003697          	auipc	a3,0x3
ffffffffc02021d2:	5a268693          	addi	a3,a3,1442 # ffffffffc0205770 <commands+0x10d0>
ffffffffc02021d6:	00003617          	auipc	a2,0x3
ffffffffc02021da:	bf260613          	addi	a2,a2,-1038 # ffffffffc0204dc8 <commands+0x728>
ffffffffc02021de:	10d00593          	li	a1,269
ffffffffc02021e2:	00003517          	auipc	a0,0x3
ffffffffc02021e6:	34e50513          	addi	a0,a0,846 # ffffffffc0205530 <commands+0xe90>
ffffffffc02021ea:	f19fd0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(p0 + 2 == p1);
ffffffffc02021ee:	00003697          	auipc	a3,0x3
ffffffffc02021f2:	57268693          	addi	a3,a3,1394 # ffffffffc0205760 <commands+0x10c0>
ffffffffc02021f6:	00003617          	auipc	a2,0x3
ffffffffc02021fa:	bd260613          	addi	a2,a2,-1070 # ffffffffc0204dc8 <commands+0x728>
ffffffffc02021fe:	10800593          	li	a1,264
ffffffffc0202202:	00003517          	auipc	a0,0x3
ffffffffc0202206:	32e50513          	addi	a0,a0,814 # ffffffffc0205530 <commands+0xe90>
ffffffffc020220a:	ef9fd0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(alloc_page() == NULL);
ffffffffc020220e:	00003697          	auipc	a3,0x3
ffffffffc0202212:	46268693          	addi	a3,a3,1122 # ffffffffc0205670 <commands+0xfd0>
ffffffffc0202216:	00003617          	auipc	a2,0x3
ffffffffc020221a:	bb260613          	addi	a2,a2,-1102 # ffffffffc0204dc8 <commands+0x728>
ffffffffc020221e:	10700593          	li	a1,263
ffffffffc0202222:	00003517          	auipc	a0,0x3
ffffffffc0202226:	30e50513          	addi	a0,a0,782 # ffffffffc0205530 <commands+0xe90>
ffffffffc020222a:	ed9fd0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
ffffffffc020222e:	00003697          	auipc	a3,0x3
ffffffffc0202232:	51268693          	addi	a3,a3,1298 # ffffffffc0205740 <commands+0x10a0>
ffffffffc0202236:	00003617          	auipc	a2,0x3
ffffffffc020223a:	b9260613          	addi	a2,a2,-1134 # ffffffffc0204dc8 <commands+0x728>
ffffffffc020223e:	10600593          	li	a1,262
ffffffffc0202242:	00003517          	auipc	a0,0x3
ffffffffc0202246:	2ee50513          	addi	a0,a0,750 # ffffffffc0205530 <commands+0xe90>
ffffffffc020224a:	eb9fd0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
ffffffffc020224e:	00003697          	auipc	a3,0x3
ffffffffc0202252:	4c268693          	addi	a3,a3,1218 # ffffffffc0205710 <commands+0x1070>
ffffffffc0202256:	00003617          	auipc	a2,0x3
ffffffffc020225a:	b7260613          	addi	a2,a2,-1166 # ffffffffc0204dc8 <commands+0x728>
ffffffffc020225e:	10500593          	li	a1,261
ffffffffc0202262:	00003517          	auipc	a0,0x3
ffffffffc0202266:	2ce50513          	addi	a0,a0,718 # ffffffffc0205530 <commands+0xe90>
ffffffffc020226a:	e99fd0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(alloc_pages(4) == NULL);
ffffffffc020226e:	00003697          	auipc	a3,0x3
ffffffffc0202272:	48a68693          	addi	a3,a3,1162 # ffffffffc02056f8 <commands+0x1058>
ffffffffc0202276:	00003617          	auipc	a2,0x3
ffffffffc020227a:	b5260613          	addi	a2,a2,-1198 # ffffffffc0204dc8 <commands+0x728>
ffffffffc020227e:	10400593          	li	a1,260
ffffffffc0202282:	00003517          	auipc	a0,0x3
ffffffffc0202286:	2ae50513          	addi	a0,a0,686 # ffffffffc0205530 <commands+0xe90>
ffffffffc020228a:	e79fd0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(alloc_page() == NULL);
ffffffffc020228e:	00003697          	auipc	a3,0x3
ffffffffc0202292:	3e268693          	addi	a3,a3,994 # ffffffffc0205670 <commands+0xfd0>
ffffffffc0202296:	00003617          	auipc	a2,0x3
ffffffffc020229a:	b3260613          	addi	a2,a2,-1230 # ffffffffc0204dc8 <commands+0x728>
ffffffffc020229e:	0fe00593          	li	a1,254
ffffffffc02022a2:	00003517          	auipc	a0,0x3
ffffffffc02022a6:	28e50513          	addi	a0,a0,654 # ffffffffc0205530 <commands+0xe90>
ffffffffc02022aa:	e59fd0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(!PageProperty(p0));
ffffffffc02022ae:	00003697          	auipc	a3,0x3
ffffffffc02022b2:	43268693          	addi	a3,a3,1074 # ffffffffc02056e0 <commands+0x1040>
ffffffffc02022b6:	00003617          	auipc	a2,0x3
ffffffffc02022ba:	b1260613          	addi	a2,a2,-1262 # ffffffffc0204dc8 <commands+0x728>
ffffffffc02022be:	0f900593          	li	a1,249
ffffffffc02022c2:	00003517          	auipc	a0,0x3
ffffffffc02022c6:	26e50513          	addi	a0,a0,622 # ffffffffc0205530 <commands+0xe90>
ffffffffc02022ca:	e39fd0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert((p0 = alloc_pages(5)) != NULL);
ffffffffc02022ce:	00003697          	auipc	a3,0x3
ffffffffc02022d2:	53268693          	addi	a3,a3,1330 # ffffffffc0205800 <commands+0x1160>
ffffffffc02022d6:	00003617          	auipc	a2,0x3
ffffffffc02022da:	af260613          	addi	a2,a2,-1294 # ffffffffc0204dc8 <commands+0x728>
ffffffffc02022de:	11700593          	li	a1,279
ffffffffc02022e2:	00003517          	auipc	a0,0x3
ffffffffc02022e6:	24e50513          	addi	a0,a0,590 # ffffffffc0205530 <commands+0xe90>
ffffffffc02022ea:	e19fd0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(total == 0);
ffffffffc02022ee:	00003697          	auipc	a3,0x3
ffffffffc02022f2:	54268693          	addi	a3,a3,1346 # ffffffffc0205830 <commands+0x1190>
ffffffffc02022f6:	00003617          	auipc	a2,0x3
ffffffffc02022fa:	ad260613          	addi	a2,a2,-1326 # ffffffffc0204dc8 <commands+0x728>
ffffffffc02022fe:	12600593          	li	a1,294
ffffffffc0202302:	00003517          	auipc	a0,0x3
ffffffffc0202306:	22e50513          	addi	a0,a0,558 # ffffffffc0205530 <commands+0xe90>
ffffffffc020230a:	df9fd0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(total == nr_free_pages());
ffffffffc020230e:	00003697          	auipc	a3,0x3
ffffffffc0202312:	eaa68693          	addi	a3,a3,-342 # ffffffffc02051b8 <commands+0xb18>
ffffffffc0202316:	00003617          	auipc	a2,0x3
ffffffffc020231a:	ab260613          	addi	a2,a2,-1358 # ffffffffc0204dc8 <commands+0x728>
ffffffffc020231e:	0f300593          	li	a1,243
ffffffffc0202322:	00003517          	auipc	a0,0x3
ffffffffc0202326:	20e50513          	addi	a0,a0,526 # ffffffffc0205530 <commands+0xe90>
ffffffffc020232a:	dd9fd0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert((p1 = alloc_page()) != NULL);
ffffffffc020232e:	00003697          	auipc	a3,0x3
ffffffffc0202332:	23a68693          	addi	a3,a3,570 # ffffffffc0205568 <commands+0xec8>
ffffffffc0202336:	00003617          	auipc	a2,0x3
ffffffffc020233a:	a9260613          	addi	a2,a2,-1390 # ffffffffc0204dc8 <commands+0x728>
ffffffffc020233e:	0ba00593          	li	a1,186
ffffffffc0202342:	00003517          	auipc	a0,0x3
ffffffffc0202346:	1ee50513          	addi	a0,a0,494 # ffffffffc0205530 <commands+0xe90>
ffffffffc020234a:	db9fd0ef          	jal	ra,ffffffffc0200102 <__panic>

ffffffffc020234e <default_free_pages>:
default_free_pages(struct Page *base, size_t n) {
ffffffffc020234e:	1141                	addi	sp,sp,-16
ffffffffc0202350:	e406                	sd	ra,8(sp)
    assert(n > 0);
ffffffffc0202352:	14058a63          	beqz	a1,ffffffffc02024a6 <default_free_pages+0x158>
    for (; p != base + n; p ++) {
ffffffffc0202356:	00359693          	slli	a3,a1,0x3
ffffffffc020235a:	96ae                	add	a3,a3,a1
ffffffffc020235c:	068e                	slli	a3,a3,0x3
ffffffffc020235e:	96aa                	add	a3,a3,a0
ffffffffc0202360:	87aa                	mv	a5,a0
ffffffffc0202362:	02d50263          	beq	a0,a3,ffffffffc0202386 <default_free_pages+0x38>
ffffffffc0202366:	6798                	ld	a4,8(a5)
        assert(!PageReserved(p) && !PageProperty(p));
ffffffffc0202368:	8b05                	andi	a4,a4,1
ffffffffc020236a:	10071e63          	bnez	a4,ffffffffc0202486 <default_free_pages+0x138>
ffffffffc020236e:	6798                	ld	a4,8(a5)
ffffffffc0202370:	8b09                	andi	a4,a4,2
ffffffffc0202372:	10071a63          	bnez	a4,ffffffffc0202486 <default_free_pages+0x138>
        p->flags = 0;
ffffffffc0202376:	0007b423          	sd	zero,8(a5)
}

static inline int page_ref(struct Page *page) { return page->ref; }

static inline void set_page_ref(struct Page *page, int val) { page->ref = val; }
ffffffffc020237a:	0007a023          	sw	zero,0(a5)
    for (; p != base + n; p ++) {
ffffffffc020237e:	04878793          	addi	a5,a5,72
ffffffffc0202382:	fed792e3          	bne	a5,a3,ffffffffc0202366 <default_free_pages+0x18>
    base->property = n;
ffffffffc0202386:	2581                	sext.w	a1,a1
ffffffffc0202388:	cd0c                	sw	a1,24(a0)
    SetPageProperty(base);
ffffffffc020238a:	00850893          	addi	a7,a0,8
    __op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc020238e:	4789                	li	a5,2
ffffffffc0202390:	40f8b02f          	amoor.d	zero,a5,(a7)
    nr_free += n;
ffffffffc0202394:	0000f697          	auipc	a3,0xf
ffffffffc0202398:	d3c68693          	addi	a3,a3,-708 # ffffffffc02110d0 <free_area>
ffffffffc020239c:	4a98                	lw	a4,16(a3)
    return list->next == list;
ffffffffc020239e:	669c                	ld	a5,8(a3)
        list_add(&free_list, &(base->page_link));
ffffffffc02023a0:	02050613          	addi	a2,a0,32
    nr_free += n;
ffffffffc02023a4:	9db9                	addw	a1,a1,a4
ffffffffc02023a6:	ca8c                	sw	a1,16(a3)
    if (list_empty(&free_list)) {
ffffffffc02023a8:	0ad78863          	beq	a5,a3,ffffffffc0202458 <default_free_pages+0x10a>
            struct Page* page = le2page(le, page_link);
ffffffffc02023ac:	fe078713          	addi	a4,a5,-32
ffffffffc02023b0:	0006b803          	ld	a6,0(a3)
    if (list_empty(&free_list)) {
ffffffffc02023b4:	4581                	li	a1,0
            if (base < page) {
ffffffffc02023b6:	00e56a63          	bltu	a0,a4,ffffffffc02023ca <default_free_pages+0x7c>
    return listelm->next;
ffffffffc02023ba:	6798                	ld	a4,8(a5)
            } else if (list_next(le) == &free_list) {
ffffffffc02023bc:	06d70263          	beq	a4,a3,ffffffffc0202420 <default_free_pages+0xd2>
    for (; p != base + n; p ++) {
ffffffffc02023c0:	87ba                	mv	a5,a4
            struct Page* page = le2page(le, page_link);
ffffffffc02023c2:	fe078713          	addi	a4,a5,-32
            if (base < page) {
ffffffffc02023c6:	fee57ae3          	bgeu	a0,a4,ffffffffc02023ba <default_free_pages+0x6c>
ffffffffc02023ca:	c199                	beqz	a1,ffffffffc02023d0 <default_free_pages+0x82>
ffffffffc02023cc:	0106b023          	sd	a6,0(a3)
    __list_add(elm, listelm->prev, listelm);
ffffffffc02023d0:	6398                	ld	a4,0(a5)
    prev->next = next->prev = elm;
ffffffffc02023d2:	e390                	sd	a2,0(a5)
ffffffffc02023d4:	e710                	sd	a2,8(a4)
    elm->next = next;
ffffffffc02023d6:	f51c                	sd	a5,40(a0)
    elm->prev = prev;
ffffffffc02023d8:	f118                	sd	a4,32(a0)
    if (le != &free_list) {
ffffffffc02023da:	02d70063          	beq	a4,a3,ffffffffc02023fa <default_free_pages+0xac>
        if (p + p->property == base) {
ffffffffc02023de:	ff872803          	lw	a6,-8(a4)
        p = le2page(le, page_link);
ffffffffc02023e2:	fe070593          	addi	a1,a4,-32
        if (p + p->property == base) {
ffffffffc02023e6:	02081613          	slli	a2,a6,0x20
ffffffffc02023ea:	9201                	srli	a2,a2,0x20
ffffffffc02023ec:	00361793          	slli	a5,a2,0x3
ffffffffc02023f0:	97b2                	add	a5,a5,a2
ffffffffc02023f2:	078e                	slli	a5,a5,0x3
ffffffffc02023f4:	97ae                	add	a5,a5,a1
ffffffffc02023f6:	02f50f63          	beq	a0,a5,ffffffffc0202434 <default_free_pages+0xe6>
    return listelm->next;
ffffffffc02023fa:	7518                	ld	a4,40(a0)
    if (le != &free_list) {
ffffffffc02023fc:	00d70f63          	beq	a4,a3,ffffffffc020241a <default_free_pages+0xcc>
        if (base + base->property == p) {
ffffffffc0202400:	4d0c                	lw	a1,24(a0)
        p = le2page(le, page_link);
ffffffffc0202402:	fe070693          	addi	a3,a4,-32
        if (base + base->property == p) {
ffffffffc0202406:	02059613          	slli	a2,a1,0x20
ffffffffc020240a:	9201                	srli	a2,a2,0x20
ffffffffc020240c:	00361793          	slli	a5,a2,0x3
ffffffffc0202410:	97b2                	add	a5,a5,a2
ffffffffc0202412:	078e                	slli	a5,a5,0x3
ffffffffc0202414:	97aa                	add	a5,a5,a0
ffffffffc0202416:	04f68863          	beq	a3,a5,ffffffffc0202466 <default_free_pages+0x118>
}
ffffffffc020241a:	60a2                	ld	ra,8(sp)
ffffffffc020241c:	0141                	addi	sp,sp,16
ffffffffc020241e:	8082                	ret
    prev->next = next->prev = elm;
ffffffffc0202420:	e790                	sd	a2,8(a5)
    elm->next = next;
ffffffffc0202422:	f514                	sd	a3,40(a0)
    return listelm->next;
ffffffffc0202424:	6798                	ld	a4,8(a5)
    elm->prev = prev;
ffffffffc0202426:	f11c                	sd	a5,32(a0)
        while ((le = list_next(le)) != &free_list) {
ffffffffc0202428:	02d70563          	beq	a4,a3,ffffffffc0202452 <default_free_pages+0x104>
    prev->next = next->prev = elm;
ffffffffc020242c:	8832                	mv	a6,a2
ffffffffc020242e:	4585                	li	a1,1
    for (; p != base + n; p ++) {
ffffffffc0202430:	87ba                	mv	a5,a4
ffffffffc0202432:	bf41                	j	ffffffffc02023c2 <default_free_pages+0x74>
            p->property += base->property;
ffffffffc0202434:	4d1c                	lw	a5,24(a0)
ffffffffc0202436:	0107883b          	addw	a6,a5,a6
ffffffffc020243a:	ff072c23          	sw	a6,-8(a4)
    __op_bit(and, __NOT, nr, ((volatile unsigned long *)addr));
ffffffffc020243e:	57f5                	li	a5,-3
ffffffffc0202440:	60f8b02f          	amoand.d	zero,a5,(a7)
    __list_del(listelm->prev, listelm->next);
ffffffffc0202444:	7110                	ld	a2,32(a0)
ffffffffc0202446:	751c                	ld	a5,40(a0)
            base = p;
ffffffffc0202448:	852e                	mv	a0,a1
    prev->next = next;
ffffffffc020244a:	e61c                	sd	a5,8(a2)
    return listelm->next;
ffffffffc020244c:	6718                	ld	a4,8(a4)
    next->prev = prev;
ffffffffc020244e:	e390                	sd	a2,0(a5)
ffffffffc0202450:	b775                	j	ffffffffc02023fc <default_free_pages+0xae>
ffffffffc0202452:	e290                	sd	a2,0(a3)
        while ((le = list_next(le)) != &free_list) {
ffffffffc0202454:	873e                	mv	a4,a5
ffffffffc0202456:	b761                	j	ffffffffc02023de <default_free_pages+0x90>
}
ffffffffc0202458:	60a2                	ld	ra,8(sp)
    prev->next = next->prev = elm;
ffffffffc020245a:	e390                	sd	a2,0(a5)
ffffffffc020245c:	e790                	sd	a2,8(a5)
    elm->next = next;
ffffffffc020245e:	f51c                	sd	a5,40(a0)
    elm->prev = prev;
ffffffffc0202460:	f11c                	sd	a5,32(a0)
ffffffffc0202462:	0141                	addi	sp,sp,16
ffffffffc0202464:	8082                	ret
            base->property += p->property;
ffffffffc0202466:	ff872783          	lw	a5,-8(a4)
ffffffffc020246a:	fe870693          	addi	a3,a4,-24
ffffffffc020246e:	9dbd                	addw	a1,a1,a5
ffffffffc0202470:	cd0c                	sw	a1,24(a0)
ffffffffc0202472:	57f5                	li	a5,-3
ffffffffc0202474:	60f6b02f          	amoand.d	zero,a5,(a3)
    __list_del(listelm->prev, listelm->next);
ffffffffc0202478:	6314                	ld	a3,0(a4)
ffffffffc020247a:	671c                	ld	a5,8(a4)
}
ffffffffc020247c:	60a2                	ld	ra,8(sp)
    prev->next = next;
ffffffffc020247e:	e69c                	sd	a5,8(a3)
    next->prev = prev;
ffffffffc0202480:	e394                	sd	a3,0(a5)
ffffffffc0202482:	0141                	addi	sp,sp,16
ffffffffc0202484:	8082                	ret
        assert(!PageReserved(p) && !PageProperty(p));
ffffffffc0202486:	00003697          	auipc	a3,0x3
ffffffffc020248a:	3c268693          	addi	a3,a3,962 # ffffffffc0205848 <commands+0x11a8>
ffffffffc020248e:	00003617          	auipc	a2,0x3
ffffffffc0202492:	93a60613          	addi	a2,a2,-1734 # ffffffffc0204dc8 <commands+0x728>
ffffffffc0202496:	08300593          	li	a1,131
ffffffffc020249a:	00003517          	auipc	a0,0x3
ffffffffc020249e:	09650513          	addi	a0,a0,150 # ffffffffc0205530 <commands+0xe90>
ffffffffc02024a2:	c61fd0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(n > 0);
ffffffffc02024a6:	00003697          	auipc	a3,0x3
ffffffffc02024aa:	39a68693          	addi	a3,a3,922 # ffffffffc0205840 <commands+0x11a0>
ffffffffc02024ae:	00003617          	auipc	a2,0x3
ffffffffc02024b2:	91a60613          	addi	a2,a2,-1766 # ffffffffc0204dc8 <commands+0x728>
ffffffffc02024b6:	08000593          	li	a1,128
ffffffffc02024ba:	00003517          	auipc	a0,0x3
ffffffffc02024be:	07650513          	addi	a0,a0,118 # ffffffffc0205530 <commands+0xe90>
ffffffffc02024c2:	c41fd0ef          	jal	ra,ffffffffc0200102 <__panic>

ffffffffc02024c6 <default_alloc_pages>:
    assert(n > 0);
ffffffffc02024c6:	c959                	beqz	a0,ffffffffc020255c <default_alloc_pages+0x96>
    if (n > nr_free) {
ffffffffc02024c8:	0000f597          	auipc	a1,0xf
ffffffffc02024cc:	c0858593          	addi	a1,a1,-1016 # ffffffffc02110d0 <free_area>
ffffffffc02024d0:	0105a803          	lw	a6,16(a1)
ffffffffc02024d4:	862a                	mv	a2,a0
ffffffffc02024d6:	02081793          	slli	a5,a6,0x20
ffffffffc02024da:	9381                	srli	a5,a5,0x20
ffffffffc02024dc:	00a7ee63          	bltu	a5,a0,ffffffffc02024f8 <default_alloc_pages+0x32>
    list_entry_t *le = &free_list;
ffffffffc02024e0:	87ae                	mv	a5,a1
ffffffffc02024e2:	a801                	j	ffffffffc02024f2 <default_alloc_pages+0x2c>
        if (p->property >= n) {
ffffffffc02024e4:	ff87a703          	lw	a4,-8(a5)
ffffffffc02024e8:	02071693          	slli	a3,a4,0x20
ffffffffc02024ec:	9281                	srli	a3,a3,0x20
ffffffffc02024ee:	00c6f763          	bgeu	a3,a2,ffffffffc02024fc <default_alloc_pages+0x36>
    return listelm->next;
ffffffffc02024f2:	679c                	ld	a5,8(a5)
    while ((le = list_next(le)) != &free_list) {
ffffffffc02024f4:	feb798e3          	bne	a5,a1,ffffffffc02024e4 <default_alloc_pages+0x1e>
        return NULL;
ffffffffc02024f8:	4501                	li	a0,0
}
ffffffffc02024fa:	8082                	ret
    return listelm->prev;
ffffffffc02024fc:	0007b883          	ld	a7,0(a5)
    __list_del(listelm->prev, listelm->next);
ffffffffc0202500:	0087b303          	ld	t1,8(a5)
        struct Page *p = le2page(le, page_link);
ffffffffc0202504:	fe078513          	addi	a0,a5,-32
            p->property = page->property - n;
ffffffffc0202508:	00060e1b          	sext.w	t3,a2
    prev->next = next;
ffffffffc020250c:	0068b423          	sd	t1,8(a7)
    next->prev = prev;
ffffffffc0202510:	01133023          	sd	a7,0(t1)
        if (page->property > n) {
ffffffffc0202514:	02d67b63          	bgeu	a2,a3,ffffffffc020254a <default_alloc_pages+0x84>
            struct Page *p = page + n;
ffffffffc0202518:	00361693          	slli	a3,a2,0x3
ffffffffc020251c:	96b2                	add	a3,a3,a2
ffffffffc020251e:	068e                	slli	a3,a3,0x3
ffffffffc0202520:	96aa                	add	a3,a3,a0
            p->property = page->property - n;
ffffffffc0202522:	41c7073b          	subw	a4,a4,t3
ffffffffc0202526:	ce98                	sw	a4,24(a3)
    __op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc0202528:	00868613          	addi	a2,a3,8
ffffffffc020252c:	4709                	li	a4,2
ffffffffc020252e:	40e6302f          	amoor.d	zero,a4,(a2)
    __list_add(elm, listelm, listelm->next);
ffffffffc0202532:	0088b703          	ld	a4,8(a7)
            list_add(prev, &(p->page_link));
ffffffffc0202536:	02068613          	addi	a2,a3,32
        nr_free -= n;
ffffffffc020253a:	0105a803          	lw	a6,16(a1)
    prev->next = next->prev = elm;
ffffffffc020253e:	e310                	sd	a2,0(a4)
ffffffffc0202540:	00c8b423          	sd	a2,8(a7)
    elm->next = next;
ffffffffc0202544:	f698                	sd	a4,40(a3)
    elm->prev = prev;
ffffffffc0202546:	0316b023          	sd	a7,32(a3)
ffffffffc020254a:	41c8083b          	subw	a6,a6,t3
ffffffffc020254e:	0105a823          	sw	a6,16(a1)
    __op_bit(and, __NOT, nr, ((volatile unsigned long *)addr));
ffffffffc0202552:	5775                	li	a4,-3
ffffffffc0202554:	17a1                	addi	a5,a5,-24
ffffffffc0202556:	60e7b02f          	amoand.d	zero,a4,(a5)
}
ffffffffc020255a:	8082                	ret
default_alloc_pages(size_t n) {
ffffffffc020255c:	1141                	addi	sp,sp,-16
    assert(n > 0);
ffffffffc020255e:	00003697          	auipc	a3,0x3
ffffffffc0202562:	2e268693          	addi	a3,a3,738 # ffffffffc0205840 <commands+0x11a0>
ffffffffc0202566:	00003617          	auipc	a2,0x3
ffffffffc020256a:	86260613          	addi	a2,a2,-1950 # ffffffffc0204dc8 <commands+0x728>
ffffffffc020256e:	06200593          	li	a1,98
ffffffffc0202572:	00003517          	auipc	a0,0x3
ffffffffc0202576:	fbe50513          	addi	a0,a0,-66 # ffffffffc0205530 <commands+0xe90>
default_alloc_pages(size_t n) {
ffffffffc020257a:	e406                	sd	ra,8(sp)
    assert(n > 0);
ffffffffc020257c:	b87fd0ef          	jal	ra,ffffffffc0200102 <__panic>

ffffffffc0202580 <default_init_memmap>:
default_init_memmap(struct Page *base, size_t n) {
ffffffffc0202580:	1141                	addi	sp,sp,-16
ffffffffc0202582:	e406                	sd	ra,8(sp)
    assert(n > 0);
ffffffffc0202584:	c9e1                	beqz	a1,ffffffffc0202654 <default_init_memmap+0xd4>
    for (; p != base + n; p ++) {
ffffffffc0202586:	00359693          	slli	a3,a1,0x3
ffffffffc020258a:	96ae                	add	a3,a3,a1
ffffffffc020258c:	068e                	slli	a3,a3,0x3
ffffffffc020258e:	96aa                	add	a3,a3,a0
ffffffffc0202590:	87aa                	mv	a5,a0
ffffffffc0202592:	00d50f63          	beq	a0,a3,ffffffffc02025b0 <default_init_memmap+0x30>
    return (((*(volatile unsigned long *)addr) >> nr) & 1);
ffffffffc0202596:	6798                	ld	a4,8(a5)
        assert(PageReserved(p));
ffffffffc0202598:	8b05                	andi	a4,a4,1
ffffffffc020259a:	cf49                	beqz	a4,ffffffffc0202634 <default_init_memmap+0xb4>
        p->flags = p->property = 0;
ffffffffc020259c:	0007ac23          	sw	zero,24(a5)
ffffffffc02025a0:	0007b423          	sd	zero,8(a5)
ffffffffc02025a4:	0007a023          	sw	zero,0(a5)
    for (; p != base + n; p ++) {
ffffffffc02025a8:	04878793          	addi	a5,a5,72
ffffffffc02025ac:	fed795e3          	bne	a5,a3,ffffffffc0202596 <default_init_memmap+0x16>
    base->property = n;
ffffffffc02025b0:	2581                	sext.w	a1,a1
ffffffffc02025b2:	cd0c                	sw	a1,24(a0)
    __op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc02025b4:	4789                	li	a5,2
ffffffffc02025b6:	00850713          	addi	a4,a0,8
ffffffffc02025ba:	40f7302f          	amoor.d	zero,a5,(a4)
    nr_free += n;
ffffffffc02025be:	0000f697          	auipc	a3,0xf
ffffffffc02025c2:	b1268693          	addi	a3,a3,-1262 # ffffffffc02110d0 <free_area>
ffffffffc02025c6:	4a98                	lw	a4,16(a3)
    return list->next == list;
ffffffffc02025c8:	669c                	ld	a5,8(a3)
        list_add(&free_list, &(base->page_link));
ffffffffc02025ca:	02050613          	addi	a2,a0,32
    nr_free += n;
ffffffffc02025ce:	9db9                	addw	a1,a1,a4
ffffffffc02025d0:	ca8c                	sw	a1,16(a3)
    if (list_empty(&free_list)) {
ffffffffc02025d2:	04d78a63          	beq	a5,a3,ffffffffc0202626 <default_init_memmap+0xa6>
            struct Page* page = le2page(le, page_link);
ffffffffc02025d6:	fe078713          	addi	a4,a5,-32
ffffffffc02025da:	0006b803          	ld	a6,0(a3)
    if (list_empty(&free_list)) {
ffffffffc02025de:	4581                	li	a1,0
            if (base < page) {
ffffffffc02025e0:	00e56a63          	bltu	a0,a4,ffffffffc02025f4 <default_init_memmap+0x74>
    return listelm->next;
ffffffffc02025e4:	6798                	ld	a4,8(a5)
            } else if (list_next(le) == &free_list) {
ffffffffc02025e6:	02d70263          	beq	a4,a3,ffffffffc020260a <default_init_memmap+0x8a>
    for (; p != base + n; p ++) {
ffffffffc02025ea:	87ba                	mv	a5,a4
            struct Page* page = le2page(le, page_link);
ffffffffc02025ec:	fe078713          	addi	a4,a5,-32
            if (base < page) {
ffffffffc02025f0:	fee57ae3          	bgeu	a0,a4,ffffffffc02025e4 <default_init_memmap+0x64>
ffffffffc02025f4:	c199                	beqz	a1,ffffffffc02025fa <default_init_memmap+0x7a>
ffffffffc02025f6:	0106b023          	sd	a6,0(a3)
    __list_add(elm, listelm->prev, listelm);
ffffffffc02025fa:	6398                	ld	a4,0(a5)
}
ffffffffc02025fc:	60a2                	ld	ra,8(sp)
    prev->next = next->prev = elm;
ffffffffc02025fe:	e390                	sd	a2,0(a5)
ffffffffc0202600:	e710                	sd	a2,8(a4)
    elm->next = next;
ffffffffc0202602:	f51c                	sd	a5,40(a0)
    elm->prev = prev;
ffffffffc0202604:	f118                	sd	a4,32(a0)
ffffffffc0202606:	0141                	addi	sp,sp,16
ffffffffc0202608:	8082                	ret
    prev->next = next->prev = elm;
ffffffffc020260a:	e790                	sd	a2,8(a5)
    elm->next = next;
ffffffffc020260c:	f514                	sd	a3,40(a0)
    return listelm->next;
ffffffffc020260e:	6798                	ld	a4,8(a5)
    elm->prev = prev;
ffffffffc0202610:	f11c                	sd	a5,32(a0)
        while ((le = list_next(le)) != &free_list) {
ffffffffc0202612:	00d70663          	beq	a4,a3,ffffffffc020261e <default_init_memmap+0x9e>
    prev->next = next->prev = elm;
ffffffffc0202616:	8832                	mv	a6,a2
ffffffffc0202618:	4585                	li	a1,1
    for (; p != base + n; p ++) {
ffffffffc020261a:	87ba                	mv	a5,a4
ffffffffc020261c:	bfc1                	j	ffffffffc02025ec <default_init_memmap+0x6c>
}
ffffffffc020261e:	60a2                	ld	ra,8(sp)
ffffffffc0202620:	e290                	sd	a2,0(a3)
ffffffffc0202622:	0141                	addi	sp,sp,16
ffffffffc0202624:	8082                	ret
ffffffffc0202626:	60a2                	ld	ra,8(sp)
ffffffffc0202628:	e390                	sd	a2,0(a5)
ffffffffc020262a:	e790                	sd	a2,8(a5)
    elm->next = next;
ffffffffc020262c:	f51c                	sd	a5,40(a0)
    elm->prev = prev;
ffffffffc020262e:	f11c                	sd	a5,32(a0)
ffffffffc0202630:	0141                	addi	sp,sp,16
ffffffffc0202632:	8082                	ret
        assert(PageReserved(p));
ffffffffc0202634:	00003697          	auipc	a3,0x3
ffffffffc0202638:	23c68693          	addi	a3,a3,572 # ffffffffc0205870 <commands+0x11d0>
ffffffffc020263c:	00002617          	auipc	a2,0x2
ffffffffc0202640:	78c60613          	addi	a2,a2,1932 # ffffffffc0204dc8 <commands+0x728>
ffffffffc0202644:	04900593          	li	a1,73
ffffffffc0202648:	00003517          	auipc	a0,0x3
ffffffffc020264c:	ee850513          	addi	a0,a0,-280 # ffffffffc0205530 <commands+0xe90>
ffffffffc0202650:	ab3fd0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(n > 0);
ffffffffc0202654:	00003697          	auipc	a3,0x3
ffffffffc0202658:	1ec68693          	addi	a3,a3,492 # ffffffffc0205840 <commands+0x11a0>
ffffffffc020265c:	00002617          	auipc	a2,0x2
ffffffffc0202660:	76c60613          	addi	a2,a2,1900 # ffffffffc0204dc8 <commands+0x728>
ffffffffc0202664:	04600593          	li	a1,70
ffffffffc0202668:	00003517          	auipc	a0,0x3
ffffffffc020266c:	ec850513          	addi	a0,a0,-312 # ffffffffc0205530 <commands+0xe90>
ffffffffc0202670:	a93fd0ef          	jal	ra,ffffffffc0200102 <__panic>

ffffffffc0202674 <_clock_init_mm>:
    elm->prev = elm->next = elm;
ffffffffc0202674:	0000f797          	auipc	a5,0xf
ffffffffc0202678:	a7478793          	addi	a5,a5,-1420 # ffffffffc02110e8 <pra_list_head_clock>
     // 初始化当前指针curr_ptr指向pra_list_head，表示当前页面替换位置为链表头
     // 将mm的私有成员指针指向pra_list_head，用于后续的页面替换算法操作
     //cprintf(" mm->sm_priv %x in fifo_init_mm\n",mm->sm_priv);
     list_init(&pra_list_head_clock);
     curr_ptr=&pra_list_head_clock;
     mm->sm_priv = &pra_list_head_clock;
ffffffffc020267c:	f51c                	sd	a5,40(a0)
ffffffffc020267e:	e79c                	sd	a5,8(a5)
ffffffffc0202680:	e39c                	sd	a5,0(a5)
     curr_ptr=&pra_list_head_clock;
ffffffffc0202682:	0000f717          	auipc	a4,0xf
ffffffffc0202686:	eaf73b23          	sd	a5,-330(a4) # ffffffffc0211538 <curr_ptr>
     return 0;
}
ffffffffc020268a:	4501                	li	a0,0
ffffffffc020268c:	8082                	ret

ffffffffc020268e <_clock_init>:

static int
_clock_init(void)
{
    return 0;
}
ffffffffc020268e:	4501                	li	a0,0
ffffffffc0202690:	8082                	ret

ffffffffc0202692 <_clock_set_unswappable>:

static int
_clock_set_unswappable(struct mm_struct *mm, uintptr_t addr)
{
    return 0;
}
ffffffffc0202692:	4501                	li	a0,0
ffffffffc0202694:	8082                	ret

ffffffffc0202696 <_clock_tick_event>:

static int
_clock_tick_event(struct mm_struct *mm)
{ return 0; }
ffffffffc0202696:	4501                	li	a0,0
ffffffffc0202698:	8082                	ret

ffffffffc020269a <_clock_check_swap>:
_clock_check_swap(void) {
ffffffffc020269a:	1141                	addi	sp,sp,-16
    *(unsigned char *)0x3000 = 0x0c;
ffffffffc020269c:	4731                	li	a4,12
_clock_check_swap(void) {
ffffffffc020269e:	e406                	sd	ra,8(sp)
    *(unsigned char *)0x3000 = 0x0c;
ffffffffc02026a0:	678d                	lui	a5,0x3
ffffffffc02026a2:	00e78023          	sb	a4,0(a5) # 3000 <kern_entry-0xffffffffc01fd000>
    assert(pgfault_num==4);
ffffffffc02026a6:	0000f697          	auipc	a3,0xf
ffffffffc02026aa:	e726a683          	lw	a3,-398(a3) # ffffffffc0211518 <pgfault_num>
ffffffffc02026ae:	4711                	li	a4,4
ffffffffc02026b0:	0ae69363          	bne	a3,a4,ffffffffc0202756 <_clock_check_swap+0xbc>
    *(unsigned char *)0x1000 = 0x0a;
ffffffffc02026b4:	6705                	lui	a4,0x1
ffffffffc02026b6:	4629                	li	a2,10
ffffffffc02026b8:	0000f797          	auipc	a5,0xf
ffffffffc02026bc:	e6078793          	addi	a5,a5,-416 # ffffffffc0211518 <pgfault_num>
ffffffffc02026c0:	00c70023          	sb	a2,0(a4) # 1000 <kern_entry-0xffffffffc01ff000>
    assert(pgfault_num==4);
ffffffffc02026c4:	4398                	lw	a4,0(a5)
ffffffffc02026c6:	2701                	sext.w	a4,a4
ffffffffc02026c8:	20d71763          	bne	a4,a3,ffffffffc02028d6 <_clock_check_swap+0x23c>
    *(unsigned char *)0x4000 = 0x0d;
ffffffffc02026cc:	6691                	lui	a3,0x4
ffffffffc02026ce:	4635                	li	a2,13
ffffffffc02026d0:	00c68023          	sb	a2,0(a3) # 4000 <kern_entry-0xffffffffc01fc000>
    assert(pgfault_num==4);
ffffffffc02026d4:	4394                	lw	a3,0(a5)
ffffffffc02026d6:	2681                	sext.w	a3,a3
ffffffffc02026d8:	1ce69f63          	bne	a3,a4,ffffffffc02028b6 <_clock_check_swap+0x21c>
    *(unsigned char *)0x2000 = 0x0b;
ffffffffc02026dc:	6709                	lui	a4,0x2
ffffffffc02026de:	462d                	li	a2,11
ffffffffc02026e0:	00c70023          	sb	a2,0(a4) # 2000 <kern_entry-0xffffffffc01fe000>
    assert(pgfault_num==4);
ffffffffc02026e4:	4398                	lw	a4,0(a5)
ffffffffc02026e6:	2701                	sext.w	a4,a4
ffffffffc02026e8:	1ad71763          	bne	a4,a3,ffffffffc0202896 <_clock_check_swap+0x1fc>
    *(unsigned char *)0x5000 = 0x0e;
ffffffffc02026ec:	6715                	lui	a4,0x5
ffffffffc02026ee:	46b9                	li	a3,14
ffffffffc02026f0:	00d70023          	sb	a3,0(a4) # 5000 <kern_entry-0xffffffffc01fb000>
    assert(pgfault_num==5);
ffffffffc02026f4:	4398                	lw	a4,0(a5)
ffffffffc02026f6:	4695                	li	a3,5
ffffffffc02026f8:	2701                	sext.w	a4,a4
ffffffffc02026fa:	16d71e63          	bne	a4,a3,ffffffffc0202876 <_clock_check_swap+0x1dc>
    assert(pgfault_num==5);
ffffffffc02026fe:	4394                	lw	a3,0(a5)
ffffffffc0202700:	2681                	sext.w	a3,a3
ffffffffc0202702:	14e69a63          	bne	a3,a4,ffffffffc0202856 <_clock_check_swap+0x1bc>
    assert(pgfault_num==5);
ffffffffc0202706:	4398                	lw	a4,0(a5)
ffffffffc0202708:	2701                	sext.w	a4,a4
ffffffffc020270a:	12d71663          	bne	a4,a3,ffffffffc0202836 <_clock_check_swap+0x19c>
    assert(pgfault_num==5);
ffffffffc020270e:	4394                	lw	a3,0(a5)
ffffffffc0202710:	2681                	sext.w	a3,a3
ffffffffc0202712:	10e69263          	bne	a3,a4,ffffffffc0202816 <_clock_check_swap+0x17c>
    assert(pgfault_num==5);
ffffffffc0202716:	4398                	lw	a4,0(a5)
ffffffffc0202718:	2701                	sext.w	a4,a4
ffffffffc020271a:	0cd71e63          	bne	a4,a3,ffffffffc02027f6 <_clock_check_swap+0x15c>
    assert(pgfault_num==5);
ffffffffc020271e:	4394                	lw	a3,0(a5)
ffffffffc0202720:	2681                	sext.w	a3,a3
ffffffffc0202722:	0ae69a63          	bne	a3,a4,ffffffffc02027d6 <_clock_check_swap+0x13c>
    *(unsigned char *)0x5000 = 0x0e;
ffffffffc0202726:	6715                	lui	a4,0x5
ffffffffc0202728:	46b9                	li	a3,14
ffffffffc020272a:	00d70023          	sb	a3,0(a4) # 5000 <kern_entry-0xffffffffc01fb000>
    assert(pgfault_num==5);
ffffffffc020272e:	4398                	lw	a4,0(a5)
ffffffffc0202730:	4695                	li	a3,5
ffffffffc0202732:	2701                	sext.w	a4,a4
ffffffffc0202734:	08d71163          	bne	a4,a3,ffffffffc02027b6 <_clock_check_swap+0x11c>
    assert(*(unsigned char *)0x1000 == 0x0a);
ffffffffc0202738:	6705                	lui	a4,0x1
ffffffffc020273a:	00074683          	lbu	a3,0(a4) # 1000 <kern_entry-0xffffffffc01ff000>
ffffffffc020273e:	4729                	li	a4,10
ffffffffc0202740:	04e69b63          	bne	a3,a4,ffffffffc0202796 <_clock_check_swap+0xfc>
    assert(pgfault_num==6);
ffffffffc0202744:	439c                	lw	a5,0(a5)
ffffffffc0202746:	4719                	li	a4,6
ffffffffc0202748:	2781                	sext.w	a5,a5
ffffffffc020274a:	02e79663          	bne	a5,a4,ffffffffc0202776 <_clock_check_swap+0xdc>
}
ffffffffc020274e:	60a2                	ld	ra,8(sp)
ffffffffc0202750:	4501                	li	a0,0
ffffffffc0202752:	0141                	addi	sp,sp,16
ffffffffc0202754:	8082                	ret
    assert(pgfault_num==4);
ffffffffc0202756:	00003697          	auipc	a3,0x3
ffffffffc020275a:	bf268693          	addi	a3,a3,-1038 # ffffffffc0205348 <commands+0xca8>
ffffffffc020275e:	00002617          	auipc	a2,0x2
ffffffffc0202762:	66a60613          	addi	a2,a2,1642 # ffffffffc0204dc8 <commands+0x728>
ffffffffc0202766:	09300593          	li	a1,147
ffffffffc020276a:	00003517          	auipc	a0,0x3
ffffffffc020276e:	16650513          	addi	a0,a0,358 # ffffffffc02058d0 <default_pmm_manager+0x38>
ffffffffc0202772:	991fd0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(pgfault_num==6);
ffffffffc0202776:	00003697          	auipc	a3,0x3
ffffffffc020277a:	1aa68693          	addi	a3,a3,426 # ffffffffc0205920 <default_pmm_manager+0x88>
ffffffffc020277e:	00002617          	auipc	a2,0x2
ffffffffc0202782:	64a60613          	addi	a2,a2,1610 # ffffffffc0204dc8 <commands+0x728>
ffffffffc0202786:	0b700593          	li	a1,183
ffffffffc020278a:	00003517          	auipc	a0,0x3
ffffffffc020278e:	14650513          	addi	a0,a0,326 # ffffffffc02058d0 <default_pmm_manager+0x38>
ffffffffc0202792:	971fd0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(*(unsigned char *)0x1000 == 0x0a);
ffffffffc0202796:	00003697          	auipc	a3,0x3
ffffffffc020279a:	16268693          	addi	a3,a3,354 # ffffffffc02058f8 <default_pmm_manager+0x60>
ffffffffc020279e:	00002617          	auipc	a2,0x2
ffffffffc02027a2:	62a60613          	addi	a2,a2,1578 # ffffffffc0204dc8 <commands+0x728>
ffffffffc02027a6:	0b300593          	li	a1,179
ffffffffc02027aa:	00003517          	auipc	a0,0x3
ffffffffc02027ae:	12650513          	addi	a0,a0,294 # ffffffffc02058d0 <default_pmm_manager+0x38>
ffffffffc02027b2:	951fd0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(pgfault_num==5);
ffffffffc02027b6:	00003697          	auipc	a3,0x3
ffffffffc02027ba:	13268693          	addi	a3,a3,306 # ffffffffc02058e8 <default_pmm_manager+0x50>
ffffffffc02027be:	00002617          	auipc	a2,0x2
ffffffffc02027c2:	60a60613          	addi	a2,a2,1546 # ffffffffc0204dc8 <commands+0x728>
ffffffffc02027c6:	0b100593          	li	a1,177
ffffffffc02027ca:	00003517          	auipc	a0,0x3
ffffffffc02027ce:	10650513          	addi	a0,a0,262 # ffffffffc02058d0 <default_pmm_manager+0x38>
ffffffffc02027d2:	931fd0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(pgfault_num==5);
ffffffffc02027d6:	00003697          	auipc	a3,0x3
ffffffffc02027da:	11268693          	addi	a3,a3,274 # ffffffffc02058e8 <default_pmm_manager+0x50>
ffffffffc02027de:	00002617          	auipc	a2,0x2
ffffffffc02027e2:	5ea60613          	addi	a2,a2,1514 # ffffffffc0204dc8 <commands+0x728>
ffffffffc02027e6:	0ae00593          	li	a1,174
ffffffffc02027ea:	00003517          	auipc	a0,0x3
ffffffffc02027ee:	0e650513          	addi	a0,a0,230 # ffffffffc02058d0 <default_pmm_manager+0x38>
ffffffffc02027f2:	911fd0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(pgfault_num==5);
ffffffffc02027f6:	00003697          	auipc	a3,0x3
ffffffffc02027fa:	0f268693          	addi	a3,a3,242 # ffffffffc02058e8 <default_pmm_manager+0x50>
ffffffffc02027fe:	00002617          	auipc	a2,0x2
ffffffffc0202802:	5ca60613          	addi	a2,a2,1482 # ffffffffc0204dc8 <commands+0x728>
ffffffffc0202806:	0ab00593          	li	a1,171
ffffffffc020280a:	00003517          	auipc	a0,0x3
ffffffffc020280e:	0c650513          	addi	a0,a0,198 # ffffffffc02058d0 <default_pmm_manager+0x38>
ffffffffc0202812:	8f1fd0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(pgfault_num==5);
ffffffffc0202816:	00003697          	auipc	a3,0x3
ffffffffc020281a:	0d268693          	addi	a3,a3,210 # ffffffffc02058e8 <default_pmm_manager+0x50>
ffffffffc020281e:	00002617          	auipc	a2,0x2
ffffffffc0202822:	5aa60613          	addi	a2,a2,1450 # ffffffffc0204dc8 <commands+0x728>
ffffffffc0202826:	0a800593          	li	a1,168
ffffffffc020282a:	00003517          	auipc	a0,0x3
ffffffffc020282e:	0a650513          	addi	a0,a0,166 # ffffffffc02058d0 <default_pmm_manager+0x38>
ffffffffc0202832:	8d1fd0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(pgfault_num==5);
ffffffffc0202836:	00003697          	auipc	a3,0x3
ffffffffc020283a:	0b268693          	addi	a3,a3,178 # ffffffffc02058e8 <default_pmm_manager+0x50>
ffffffffc020283e:	00002617          	auipc	a2,0x2
ffffffffc0202842:	58a60613          	addi	a2,a2,1418 # ffffffffc0204dc8 <commands+0x728>
ffffffffc0202846:	0a500593          	li	a1,165
ffffffffc020284a:	00003517          	auipc	a0,0x3
ffffffffc020284e:	08650513          	addi	a0,a0,134 # ffffffffc02058d0 <default_pmm_manager+0x38>
ffffffffc0202852:	8b1fd0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(pgfault_num==5);
ffffffffc0202856:	00003697          	auipc	a3,0x3
ffffffffc020285a:	09268693          	addi	a3,a3,146 # ffffffffc02058e8 <default_pmm_manager+0x50>
ffffffffc020285e:	00002617          	auipc	a2,0x2
ffffffffc0202862:	56a60613          	addi	a2,a2,1386 # ffffffffc0204dc8 <commands+0x728>
ffffffffc0202866:	0a200593          	li	a1,162
ffffffffc020286a:	00003517          	auipc	a0,0x3
ffffffffc020286e:	06650513          	addi	a0,a0,102 # ffffffffc02058d0 <default_pmm_manager+0x38>
ffffffffc0202872:	891fd0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(pgfault_num==5);
ffffffffc0202876:	00003697          	auipc	a3,0x3
ffffffffc020287a:	07268693          	addi	a3,a3,114 # ffffffffc02058e8 <default_pmm_manager+0x50>
ffffffffc020287e:	00002617          	auipc	a2,0x2
ffffffffc0202882:	54a60613          	addi	a2,a2,1354 # ffffffffc0204dc8 <commands+0x728>
ffffffffc0202886:	09f00593          	li	a1,159
ffffffffc020288a:	00003517          	auipc	a0,0x3
ffffffffc020288e:	04650513          	addi	a0,a0,70 # ffffffffc02058d0 <default_pmm_manager+0x38>
ffffffffc0202892:	871fd0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(pgfault_num==4);
ffffffffc0202896:	00003697          	auipc	a3,0x3
ffffffffc020289a:	ab268693          	addi	a3,a3,-1358 # ffffffffc0205348 <commands+0xca8>
ffffffffc020289e:	00002617          	auipc	a2,0x2
ffffffffc02028a2:	52a60613          	addi	a2,a2,1322 # ffffffffc0204dc8 <commands+0x728>
ffffffffc02028a6:	09c00593          	li	a1,156
ffffffffc02028aa:	00003517          	auipc	a0,0x3
ffffffffc02028ae:	02650513          	addi	a0,a0,38 # ffffffffc02058d0 <default_pmm_manager+0x38>
ffffffffc02028b2:	851fd0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(pgfault_num==4);
ffffffffc02028b6:	00003697          	auipc	a3,0x3
ffffffffc02028ba:	a9268693          	addi	a3,a3,-1390 # ffffffffc0205348 <commands+0xca8>
ffffffffc02028be:	00002617          	auipc	a2,0x2
ffffffffc02028c2:	50a60613          	addi	a2,a2,1290 # ffffffffc0204dc8 <commands+0x728>
ffffffffc02028c6:	09900593          	li	a1,153
ffffffffc02028ca:	00003517          	auipc	a0,0x3
ffffffffc02028ce:	00650513          	addi	a0,a0,6 # ffffffffc02058d0 <default_pmm_manager+0x38>
ffffffffc02028d2:	831fd0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(pgfault_num==4);
ffffffffc02028d6:	00003697          	auipc	a3,0x3
ffffffffc02028da:	a7268693          	addi	a3,a3,-1422 # ffffffffc0205348 <commands+0xca8>
ffffffffc02028de:	00002617          	auipc	a2,0x2
ffffffffc02028e2:	4ea60613          	addi	a2,a2,1258 # ffffffffc0204dc8 <commands+0x728>
ffffffffc02028e6:	09600593          	li	a1,150
ffffffffc02028ea:	00003517          	auipc	a0,0x3
ffffffffc02028ee:	fe650513          	addi	a0,a0,-26 # ffffffffc02058d0 <default_pmm_manager+0x38>
ffffffffc02028f2:	811fd0ef          	jal	ra,ffffffffc0200102 <__panic>

ffffffffc02028f6 <_clock_swap_out_victim>:
     list_entry_t *head=(list_entry_t*) mm->sm_priv;
ffffffffc02028f6:	7514                	ld	a3,40(a0)
{
ffffffffc02028f8:	1141                	addi	sp,sp,-16
ffffffffc02028fa:	e406                	sd	ra,8(sp)
         assert(head != NULL);
ffffffffc02028fc:	ceb9                	beqz	a3,ffffffffc020295a <_clock_swap_out_victim+0x64>
     assert(in_tick==0);
ffffffffc02028fe:	ee35                	bnez	a2,ffffffffc020297a <_clock_swap_out_victim+0x84>
     curr_ptr=head;
ffffffffc0202900:	0000f817          	auipc	a6,0xf
ffffffffc0202904:	c3880813          	addi	a6,a6,-968 # ffffffffc0211538 <curr_ptr>
ffffffffc0202908:	852e                	mv	a0,a1
ffffffffc020290a:	00d83023          	sd	a3,0(a6)
ffffffffc020290e:	85b6                	mv	a1,a3
ffffffffc0202910:	4601                	li	a2,0
ffffffffc0202912:	a801                	j	ffffffffc0202922 <_clock_swap_out_victim+0x2c>
        if(page->visited==0)
ffffffffc0202914:	fe05b703          	ld	a4,-32(a1)
ffffffffc0202918:	cf11                	beqz	a4,ffffffffc0202934 <_clock_swap_out_victim+0x3e>
            page->visited=0;
ffffffffc020291a:	fe05b023          	sd	zero,-32(a1)
    while (1) {
ffffffffc020291e:	4605                	li	a2,1
ffffffffc0202920:	85be                	mv	a1,a5
            curr_ptr=curr_ptr->next;
ffffffffc0202922:	659c                	ld	a5,8(a1)
        if(curr_ptr==head)
ffffffffc0202924:	fed598e3          	bne	a1,a3,ffffffffc0202914 <_clock_swap_out_victim+0x1e>
        curr_ptr=curr_ptr->next;
ffffffffc0202928:	85be                	mv	a1,a5
        if(page->visited==0)
ffffffffc020292a:	fe05b703          	ld	a4,-32(a1)
        curr_ptr=curr_ptr->next;
ffffffffc020292e:	679c                	ld	a5,8(a5)
ffffffffc0202930:	4605                	li	a2,1
        if(page->visited==0)
ffffffffc0202932:	f765                	bnez	a4,ffffffffc020291a <_clock_swap_out_victim+0x24>
ffffffffc0202934:	c219                	beqz	a2,ffffffffc020293a <_clock_swap_out_victim+0x44>
ffffffffc0202936:	00b83023          	sd	a1,0(a6)
    __list_del(listelm->prev, listelm->next);
ffffffffc020293a:	6198                	ld	a4,0(a1)
        struct Page* page=le2page(curr_ptr,pra_page_link);
ffffffffc020293c:	fd058693          	addi	a3,a1,-48
    prev->next = next;
ffffffffc0202940:	e71c                	sd	a5,8(a4)
    next->prev = prev;
ffffffffc0202942:	e398                	sd	a4,0(a5)
            *ptr_page=page;
ffffffffc0202944:	e114                	sd	a3,0(a0)
    cprintf("curr_ptr 0xffffffff%16x\n", curr_ptr);
ffffffffc0202946:	00003517          	auipc	a0,0x3
ffffffffc020294a:	00a50513          	addi	a0,a0,10 # ffffffffc0205950 <default_pmm_manager+0xb8>
ffffffffc020294e:	f6cfd0ef          	jal	ra,ffffffffc02000ba <cprintf>
}
ffffffffc0202952:	60a2                	ld	ra,8(sp)
ffffffffc0202954:	4501                	li	a0,0
ffffffffc0202956:	0141                	addi	sp,sp,16
ffffffffc0202958:	8082                	ret
         assert(head != NULL);
ffffffffc020295a:	00003697          	auipc	a3,0x3
ffffffffc020295e:	fd668693          	addi	a3,a3,-42 # ffffffffc0205930 <default_pmm_manager+0x98>
ffffffffc0202962:	00002617          	auipc	a2,0x2
ffffffffc0202966:	46660613          	addi	a2,a2,1126 # ffffffffc0204dc8 <commands+0x728>
ffffffffc020296a:	04900593          	li	a1,73
ffffffffc020296e:	00003517          	auipc	a0,0x3
ffffffffc0202972:	f6250513          	addi	a0,a0,-158 # ffffffffc02058d0 <default_pmm_manager+0x38>
ffffffffc0202976:	f8cfd0ef          	jal	ra,ffffffffc0200102 <__panic>
     assert(in_tick==0);
ffffffffc020297a:	00003697          	auipc	a3,0x3
ffffffffc020297e:	fc668693          	addi	a3,a3,-58 # ffffffffc0205940 <default_pmm_manager+0xa8>
ffffffffc0202982:	00002617          	auipc	a2,0x2
ffffffffc0202986:	44660613          	addi	a2,a2,1094 # ffffffffc0204dc8 <commands+0x728>
ffffffffc020298a:	04a00593          	li	a1,74
ffffffffc020298e:	00003517          	auipc	a0,0x3
ffffffffc0202992:	f4250513          	addi	a0,a0,-190 # ffffffffc02058d0 <default_pmm_manager+0x38>
ffffffffc0202996:	f6cfd0ef          	jal	ra,ffffffffc0200102 <__panic>

ffffffffc020299a <_clock_map_swappable>:
    assert(entry != NULL && curr_ptr != NULL);
ffffffffc020299a:	0000f797          	auipc	a5,0xf
ffffffffc020299e:	b9e7b783          	ld	a5,-1122(a5) # ffffffffc0211538 <curr_ptr>
ffffffffc02029a2:	cf91                	beqz	a5,ffffffffc02029be <_clock_map_swappable+0x24>
    list_add(((list_entry_t*)mm->sm_priv)->prev, entry);
ffffffffc02029a4:	751c                	ld	a5,40(a0)
ffffffffc02029a6:	03060713          	addi	a4,a2,48
}
ffffffffc02029aa:	4501                	li	a0,0
    list_add(((list_entry_t*)mm->sm_priv)->prev, entry);
ffffffffc02029ac:	639c                	ld	a5,0(a5)
    __list_add(elm, listelm, listelm->next);
ffffffffc02029ae:	6794                	ld	a3,8(a5)
    prev->next = next->prev = elm;
ffffffffc02029b0:	e298                	sd	a4,0(a3)
ffffffffc02029b2:	e798                	sd	a4,8(a5)
    elm->prev = prev;
ffffffffc02029b4:	fa1c                	sd	a5,48(a2)
    page->visited=1;
ffffffffc02029b6:	4785                	li	a5,1
    elm->next = next;
ffffffffc02029b8:	fe14                	sd	a3,56(a2)
ffffffffc02029ba:	ea1c                	sd	a5,16(a2)
}
ffffffffc02029bc:	8082                	ret
{
ffffffffc02029be:	1141                	addi	sp,sp,-16
    assert(entry != NULL && curr_ptr != NULL);
ffffffffc02029c0:	00003697          	auipc	a3,0x3
ffffffffc02029c4:	fb068693          	addi	a3,a3,-80 # ffffffffc0205970 <default_pmm_manager+0xd8>
ffffffffc02029c8:	00002617          	auipc	a2,0x2
ffffffffc02029cc:	40060613          	addi	a2,a2,1024 # ffffffffc0204dc8 <commands+0x728>
ffffffffc02029d0:	03600593          	li	a1,54
ffffffffc02029d4:	00003517          	auipc	a0,0x3
ffffffffc02029d8:	efc50513          	addi	a0,a0,-260 # ffffffffc02058d0 <default_pmm_manager+0x38>
{
ffffffffc02029dc:	e406                	sd	ra,8(sp)
    assert(entry != NULL && curr_ptr != NULL);
ffffffffc02029de:	f24fd0ef          	jal	ra,ffffffffc0200102 <__panic>

ffffffffc02029e2 <pa2page.part.0>:
static inline struct Page *pa2page(uintptr_t pa) {
ffffffffc02029e2:	1141                	addi	sp,sp,-16
        panic("pa2page called with invalid pa");
ffffffffc02029e4:	00002617          	auipc	a2,0x2
ffffffffc02029e8:	63460613          	addi	a2,a2,1588 # ffffffffc0205018 <commands+0x978>
ffffffffc02029ec:	06500593          	li	a1,101
ffffffffc02029f0:	00002517          	auipc	a0,0x2
ffffffffc02029f4:	64850513          	addi	a0,a0,1608 # ffffffffc0205038 <commands+0x998>
static inline struct Page *pa2page(uintptr_t pa) {
ffffffffc02029f8:	e406                	sd	ra,8(sp)
        panic("pa2page called with invalid pa");
ffffffffc02029fa:	f08fd0ef          	jal	ra,ffffffffc0200102 <__panic>

ffffffffc02029fe <pte2page.part.0>:
static inline struct Page *pte2page(pte_t pte) {
ffffffffc02029fe:	1141                	addi	sp,sp,-16
        panic("pte2page called with invalid pte");
ffffffffc0202a00:	00003617          	auipc	a2,0x3
ffffffffc0202a04:	98060613          	addi	a2,a2,-1664 # ffffffffc0205380 <commands+0xce0>
ffffffffc0202a08:	07000593          	li	a1,112
ffffffffc0202a0c:	00002517          	auipc	a0,0x2
ffffffffc0202a10:	62c50513          	addi	a0,a0,1580 # ffffffffc0205038 <commands+0x998>
static inline struct Page *pte2page(pte_t pte) {
ffffffffc0202a14:	e406                	sd	ra,8(sp)
        panic("pte2page called with invalid pte");
ffffffffc0202a16:	eecfd0ef          	jal	ra,ffffffffc0200102 <__panic>

ffffffffc0202a1a <alloc_pages>:
    pmm_manager->init_memmap(base, n);
}

// alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE
// memory
struct Page *alloc_pages(size_t n) {
ffffffffc0202a1a:	7139                	addi	sp,sp,-64
ffffffffc0202a1c:	f426                	sd	s1,40(sp)
ffffffffc0202a1e:	f04a                	sd	s2,32(sp)
ffffffffc0202a20:	ec4e                	sd	s3,24(sp)
ffffffffc0202a22:	e852                	sd	s4,16(sp)
ffffffffc0202a24:	e456                	sd	s5,8(sp)
ffffffffc0202a26:	e05a                	sd	s6,0(sp)
ffffffffc0202a28:	fc06                	sd	ra,56(sp)
ffffffffc0202a2a:	f822                	sd	s0,48(sp)
ffffffffc0202a2c:	84aa                	mv	s1,a0
ffffffffc0202a2e:	0000f917          	auipc	s2,0xf
ffffffffc0202a32:	b3290913          	addi	s2,s2,-1230 # ffffffffc0211560 <pmm_manager>
    while (1) {
        local_intr_save(intr_flag);
        { page = pmm_manager->alloc_pages(n); }
        local_intr_restore(intr_flag);

        if (page != NULL || n > 1 || swap_init_ok == 0) break;
ffffffffc0202a36:	4a05                	li	s4,1
ffffffffc0202a38:	0000fa97          	auipc	s5,0xf
ffffffffc0202a3c:	af8a8a93          	addi	s5,s5,-1288 # ffffffffc0211530 <swap_init_ok>

        extern struct mm_struct *check_mm_struct;
        // cprintf("page %x, call swap_out in alloc_pages %d\n",page, n);
        swap_out(check_mm_struct, n, 0);
ffffffffc0202a40:	0005099b          	sext.w	s3,a0
ffffffffc0202a44:	0000fb17          	auipc	s6,0xf
ffffffffc0202a48:	accb0b13          	addi	s6,s6,-1332 # ffffffffc0211510 <check_mm_struct>
ffffffffc0202a4c:	a01d                	j	ffffffffc0202a72 <alloc_pages+0x58>
        { page = pmm_manager->alloc_pages(n); }
ffffffffc0202a4e:	00093783          	ld	a5,0(s2)
ffffffffc0202a52:	6f9c                	ld	a5,24(a5)
ffffffffc0202a54:	9782                	jalr	a5
ffffffffc0202a56:	842a                	mv	s0,a0
        swap_out(check_mm_struct, n, 0);
ffffffffc0202a58:	4601                	li	a2,0
ffffffffc0202a5a:	85ce                	mv	a1,s3
        if (page != NULL || n > 1 || swap_init_ok == 0) break;
ffffffffc0202a5c:	ec0d                	bnez	s0,ffffffffc0202a96 <alloc_pages+0x7c>
ffffffffc0202a5e:	029a6c63          	bltu	s4,s1,ffffffffc0202a96 <alloc_pages+0x7c>
ffffffffc0202a62:	000aa783          	lw	a5,0(s5)
ffffffffc0202a66:	2781                	sext.w	a5,a5
ffffffffc0202a68:	c79d                	beqz	a5,ffffffffc0202a96 <alloc_pages+0x7c>
        swap_out(check_mm_struct, n, 0);
ffffffffc0202a6a:	000b3503          	ld	a0,0(s6)
ffffffffc0202a6e:	fa1fe0ef          	jal	ra,ffffffffc0201a0e <swap_out>
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0202a72:	100027f3          	csrr	a5,sstatus
ffffffffc0202a76:	8b89                	andi	a5,a5,2
        { page = pmm_manager->alloc_pages(n); }
ffffffffc0202a78:	8526                	mv	a0,s1
ffffffffc0202a7a:	dbf1                	beqz	a5,ffffffffc0202a4e <alloc_pages+0x34>
        intr_disable();
ffffffffc0202a7c:	a73fd0ef          	jal	ra,ffffffffc02004ee <intr_disable>
ffffffffc0202a80:	00093783          	ld	a5,0(s2)
ffffffffc0202a84:	8526                	mv	a0,s1
ffffffffc0202a86:	6f9c                	ld	a5,24(a5)
ffffffffc0202a88:	9782                	jalr	a5
ffffffffc0202a8a:	842a                	mv	s0,a0
        intr_enable();
ffffffffc0202a8c:	a5dfd0ef          	jal	ra,ffffffffc02004e8 <intr_enable>
        swap_out(check_mm_struct, n, 0);
ffffffffc0202a90:	4601                	li	a2,0
ffffffffc0202a92:	85ce                	mv	a1,s3
        if (page != NULL || n > 1 || swap_init_ok == 0) break;
ffffffffc0202a94:	d469                	beqz	s0,ffffffffc0202a5e <alloc_pages+0x44>
    }
    // cprintf("n %d,get page %x, No %d in alloc_pages\n",n,page,(page-pages));
    return page;
}
ffffffffc0202a96:	70e2                	ld	ra,56(sp)
ffffffffc0202a98:	8522                	mv	a0,s0
ffffffffc0202a9a:	7442                	ld	s0,48(sp)
ffffffffc0202a9c:	74a2                	ld	s1,40(sp)
ffffffffc0202a9e:	7902                	ld	s2,32(sp)
ffffffffc0202aa0:	69e2                	ld	s3,24(sp)
ffffffffc0202aa2:	6a42                	ld	s4,16(sp)
ffffffffc0202aa4:	6aa2                	ld	s5,8(sp)
ffffffffc0202aa6:	6b02                	ld	s6,0(sp)
ffffffffc0202aa8:	6121                	addi	sp,sp,64
ffffffffc0202aaa:	8082                	ret

ffffffffc0202aac <free_pages>:
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0202aac:	100027f3          	csrr	a5,sstatus
ffffffffc0202ab0:	8b89                	andi	a5,a5,2
ffffffffc0202ab2:	e799                	bnez	a5,ffffffffc0202ac0 <free_pages+0x14>
// free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory
void free_pages(struct Page *base, size_t n) {
    bool intr_flag;

    local_intr_save(intr_flag);
    { pmm_manager->free_pages(base, n); }
ffffffffc0202ab4:	0000f797          	auipc	a5,0xf
ffffffffc0202ab8:	aac7b783          	ld	a5,-1364(a5) # ffffffffc0211560 <pmm_manager>
ffffffffc0202abc:	739c                	ld	a5,32(a5)
ffffffffc0202abe:	8782                	jr	a5
void free_pages(struct Page *base, size_t n) {
ffffffffc0202ac0:	1101                	addi	sp,sp,-32
ffffffffc0202ac2:	ec06                	sd	ra,24(sp)
ffffffffc0202ac4:	e822                	sd	s0,16(sp)
ffffffffc0202ac6:	e426                	sd	s1,8(sp)
ffffffffc0202ac8:	842a                	mv	s0,a0
ffffffffc0202aca:	84ae                	mv	s1,a1
        intr_disable();
ffffffffc0202acc:	a23fd0ef          	jal	ra,ffffffffc02004ee <intr_disable>
    { pmm_manager->free_pages(base, n); }
ffffffffc0202ad0:	0000f797          	auipc	a5,0xf
ffffffffc0202ad4:	a907b783          	ld	a5,-1392(a5) # ffffffffc0211560 <pmm_manager>
ffffffffc0202ad8:	739c                	ld	a5,32(a5)
ffffffffc0202ada:	85a6                	mv	a1,s1
ffffffffc0202adc:	8522                	mv	a0,s0
ffffffffc0202ade:	9782                	jalr	a5
    local_intr_restore(intr_flag);
}
ffffffffc0202ae0:	6442                	ld	s0,16(sp)
ffffffffc0202ae2:	60e2                	ld	ra,24(sp)
ffffffffc0202ae4:	64a2                	ld	s1,8(sp)
ffffffffc0202ae6:	6105                	addi	sp,sp,32
        intr_enable();
ffffffffc0202ae8:	a01fd06f          	j	ffffffffc02004e8 <intr_enable>

ffffffffc0202aec <nr_free_pages>:
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0202aec:	100027f3          	csrr	a5,sstatus
ffffffffc0202af0:	8b89                	andi	a5,a5,2
ffffffffc0202af2:	e799                	bnez	a5,ffffffffc0202b00 <nr_free_pages+0x14>
// of current free memory
size_t nr_free_pages(void) {
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
    { ret = pmm_manager->nr_free_pages(); }
ffffffffc0202af4:	0000f797          	auipc	a5,0xf
ffffffffc0202af8:	a6c7b783          	ld	a5,-1428(a5) # ffffffffc0211560 <pmm_manager>
ffffffffc0202afc:	779c                	ld	a5,40(a5)
ffffffffc0202afe:	8782                	jr	a5
size_t nr_free_pages(void) {
ffffffffc0202b00:	1141                	addi	sp,sp,-16
ffffffffc0202b02:	e406                	sd	ra,8(sp)
ffffffffc0202b04:	e022                	sd	s0,0(sp)
        intr_disable();
ffffffffc0202b06:	9e9fd0ef          	jal	ra,ffffffffc02004ee <intr_disable>
    { ret = pmm_manager->nr_free_pages(); }
ffffffffc0202b0a:	0000f797          	auipc	a5,0xf
ffffffffc0202b0e:	a567b783          	ld	a5,-1450(a5) # ffffffffc0211560 <pmm_manager>
ffffffffc0202b12:	779c                	ld	a5,40(a5)
ffffffffc0202b14:	9782                	jalr	a5
ffffffffc0202b16:	842a                	mv	s0,a0
        intr_enable();
ffffffffc0202b18:	9d1fd0ef          	jal	ra,ffffffffc02004e8 <intr_enable>
    local_intr_restore(intr_flag);
    return ret;
}
ffffffffc0202b1c:	60a2                	ld	ra,8(sp)
ffffffffc0202b1e:	8522                	mv	a0,s0
ffffffffc0202b20:	6402                	ld	s0,0(sp)
ffffffffc0202b22:	0141                	addi	sp,sp,16
ffffffffc0202b24:	8082                	ret

ffffffffc0202b26 <get_pte>:
     *   PTE_W           0x002                   // page table/directory entry
     * flags bit : Writeable
     *   PTE_U           0x004                   // page table/directory entry
     * flags bit : User can access
     */
    pde_t *pdep1 = &pgdir[PDX1(la)];
ffffffffc0202b26:	01e5d793          	srli	a5,a1,0x1e
ffffffffc0202b2a:	1ff7f793          	andi	a5,a5,511
pte_t *get_pte(pde_t *pgdir, uintptr_t la, bool create) {
ffffffffc0202b2e:	715d                	addi	sp,sp,-80
    pde_t *pdep1 = &pgdir[PDX1(la)];
ffffffffc0202b30:	078e                	slli	a5,a5,0x3
pte_t *get_pte(pde_t *pgdir, uintptr_t la, bool create) {
ffffffffc0202b32:	fc26                	sd	s1,56(sp)
    pde_t *pdep1 = &pgdir[PDX1(la)];
ffffffffc0202b34:	00f504b3          	add	s1,a0,a5
    if (!(*pdep1 & PTE_V)) {
ffffffffc0202b38:	6094                	ld	a3,0(s1)
pte_t *get_pte(pde_t *pgdir, uintptr_t la, bool create) {
ffffffffc0202b3a:	f84a                	sd	s2,48(sp)
ffffffffc0202b3c:	f44e                	sd	s3,40(sp)
ffffffffc0202b3e:	f052                	sd	s4,32(sp)
ffffffffc0202b40:	e486                	sd	ra,72(sp)
ffffffffc0202b42:	e0a2                	sd	s0,64(sp)
ffffffffc0202b44:	ec56                	sd	s5,24(sp)
ffffffffc0202b46:	e85a                	sd	s6,16(sp)
ffffffffc0202b48:	e45e                	sd	s7,8(sp)
    if (!(*pdep1 & PTE_V)) {
ffffffffc0202b4a:	0016f793          	andi	a5,a3,1
pte_t *get_pte(pde_t *pgdir, uintptr_t la, bool create) {
ffffffffc0202b4e:	892e                	mv	s2,a1
ffffffffc0202b50:	8a32                	mv	s4,a2
ffffffffc0202b52:	0000f997          	auipc	s3,0xf
ffffffffc0202b56:	9fe98993          	addi	s3,s3,-1538 # ffffffffc0211550 <npage>
    if (!(*pdep1 & PTE_V)) {
ffffffffc0202b5a:	efb5                	bnez	a5,ffffffffc0202bd6 <get_pte+0xb0>
        struct Page *page;
        if (!create || (page = alloc_page()) == NULL) {
ffffffffc0202b5c:	14060c63          	beqz	a2,ffffffffc0202cb4 <get_pte+0x18e>
ffffffffc0202b60:	4505                	li	a0,1
ffffffffc0202b62:	eb9ff0ef          	jal	ra,ffffffffc0202a1a <alloc_pages>
ffffffffc0202b66:	842a                	mv	s0,a0
ffffffffc0202b68:	14050663          	beqz	a0,ffffffffc0202cb4 <get_pte+0x18e>
static inline ppn_t page2ppn(struct Page *page) { return page - pages + nbase; }
ffffffffc0202b6c:	0000fb97          	auipc	s7,0xf
ffffffffc0202b70:	9ecb8b93          	addi	s7,s7,-1556 # ffffffffc0211558 <pages>
ffffffffc0202b74:	000bb503          	ld	a0,0(s7)
ffffffffc0202b78:	00003b17          	auipc	s6,0x3
ffffffffc0202b7c:	6d0b3b03          	ld	s6,1744(s6) # ffffffffc0206248 <error_string+0x38>
ffffffffc0202b80:	00080ab7          	lui	s5,0x80
ffffffffc0202b84:	40a40533          	sub	a0,s0,a0
ffffffffc0202b88:	850d                	srai	a0,a0,0x3
ffffffffc0202b8a:	03650533          	mul	a0,a0,s6
            return NULL;
        }
        set_page_ref(page, 1);
        uintptr_t pa = page2pa(page);
        memset(KADDR(pa), 0, PGSIZE);
ffffffffc0202b8e:	0000f997          	auipc	s3,0xf
ffffffffc0202b92:	9c298993          	addi	s3,s3,-1598 # ffffffffc0211550 <npage>
static inline void set_page_ref(struct Page *page, int val) { page->ref = val; }
ffffffffc0202b96:	4785                	li	a5,1
ffffffffc0202b98:	0009b703          	ld	a4,0(s3)
ffffffffc0202b9c:	c01c                	sw	a5,0(s0)
static inline ppn_t page2ppn(struct Page *page) { return page - pages + nbase; }
ffffffffc0202b9e:	9556                	add	a0,a0,s5
ffffffffc0202ba0:	00c51793          	slli	a5,a0,0xc
ffffffffc0202ba4:	83b1                	srli	a5,a5,0xc
    return page2ppn(page) << PGSHIFT;
ffffffffc0202ba6:	0532                	slli	a0,a0,0xc
ffffffffc0202ba8:	14e7fd63          	bgeu	a5,a4,ffffffffc0202d02 <get_pte+0x1dc>
ffffffffc0202bac:	0000f797          	auipc	a5,0xf
ffffffffc0202bb0:	9bc7b783          	ld	a5,-1604(a5) # ffffffffc0211568 <va_pa_offset>
ffffffffc0202bb4:	6605                	lui	a2,0x1
ffffffffc0202bb6:	4581                	li	a1,0
ffffffffc0202bb8:	953e                	add	a0,a0,a5
ffffffffc0202bba:	3a2010ef          	jal	ra,ffffffffc0203f5c <memset>
static inline ppn_t page2ppn(struct Page *page) { return page - pages + nbase; }
ffffffffc0202bbe:	000bb683          	ld	a3,0(s7)
ffffffffc0202bc2:	40d406b3          	sub	a3,s0,a3
ffffffffc0202bc6:	868d                	srai	a3,a3,0x3
ffffffffc0202bc8:	036686b3          	mul	a3,a3,s6
ffffffffc0202bcc:	96d6                	add	a3,a3,s5

static inline void flush_tlb() { asm volatile("sfence.vma"); }

// construct PTE from a page and permission bits
static inline pte_t pte_create(uintptr_t ppn, int type) {
    return (ppn << PTE_PPN_SHIFT) | PTE_V | type;
ffffffffc0202bce:	06aa                	slli	a3,a3,0xa
ffffffffc0202bd0:	0116e693          	ori	a3,a3,17
        *pdep1 = pte_create(page2ppn(page), PTE_U | PTE_V);
ffffffffc0202bd4:	e094                	sd	a3,0(s1)
    }
    pde_t *pdep0 = &((pde_t *)KADDR(PDE_ADDR(*pdep1)))[PDX0(la)];
ffffffffc0202bd6:	77fd                	lui	a5,0xfffff
ffffffffc0202bd8:	068a                	slli	a3,a3,0x2
ffffffffc0202bda:	0009b703          	ld	a4,0(s3)
ffffffffc0202bde:	8efd                	and	a3,a3,a5
ffffffffc0202be0:	00c6d793          	srli	a5,a3,0xc
ffffffffc0202be4:	0ce7fa63          	bgeu	a5,a4,ffffffffc0202cb8 <get_pte+0x192>
ffffffffc0202be8:	0000fa97          	auipc	s5,0xf
ffffffffc0202bec:	980a8a93          	addi	s5,s5,-1664 # ffffffffc0211568 <va_pa_offset>
ffffffffc0202bf0:	000ab403          	ld	s0,0(s5)
ffffffffc0202bf4:	01595793          	srli	a5,s2,0x15
ffffffffc0202bf8:	1ff7f793          	andi	a5,a5,511
ffffffffc0202bfc:	96a2                	add	a3,a3,s0
ffffffffc0202bfe:	00379413          	slli	s0,a5,0x3
ffffffffc0202c02:	9436                	add	s0,s0,a3
//    pde_t *pdep0 = &((pde_t *)(PDE_ADDR(*pdep1)))[PDX0(la)];
    if (!(*pdep0 & PTE_V)) {
ffffffffc0202c04:	6014                	ld	a3,0(s0)
ffffffffc0202c06:	0016f793          	andi	a5,a3,1
ffffffffc0202c0a:	ebad                	bnez	a5,ffffffffc0202c7c <get_pte+0x156>
    	struct Page *page;
    	if (!create || (page = alloc_page()) == NULL) {
ffffffffc0202c0c:	0a0a0463          	beqz	s4,ffffffffc0202cb4 <get_pte+0x18e>
ffffffffc0202c10:	4505                	li	a0,1
ffffffffc0202c12:	e09ff0ef          	jal	ra,ffffffffc0202a1a <alloc_pages>
ffffffffc0202c16:	84aa                	mv	s1,a0
ffffffffc0202c18:	cd51                	beqz	a0,ffffffffc0202cb4 <get_pte+0x18e>
static inline ppn_t page2ppn(struct Page *page) { return page - pages + nbase; }
ffffffffc0202c1a:	0000fb97          	auipc	s7,0xf
ffffffffc0202c1e:	93eb8b93          	addi	s7,s7,-1730 # ffffffffc0211558 <pages>
ffffffffc0202c22:	000bb503          	ld	a0,0(s7)
ffffffffc0202c26:	00003b17          	auipc	s6,0x3
ffffffffc0202c2a:	622b3b03          	ld	s6,1570(s6) # ffffffffc0206248 <error_string+0x38>
ffffffffc0202c2e:	00080a37          	lui	s4,0x80
ffffffffc0202c32:	40a48533          	sub	a0,s1,a0
ffffffffc0202c36:	850d                	srai	a0,a0,0x3
ffffffffc0202c38:	03650533          	mul	a0,a0,s6
static inline void set_page_ref(struct Page *page, int val) { page->ref = val; }
ffffffffc0202c3c:	4785                	li	a5,1
    		return NULL;
    	}
    	set_page_ref(page, 1);
    	uintptr_t pa = page2pa(page);
    	memset(KADDR(pa), 0, PGSIZE);
ffffffffc0202c3e:	0009b703          	ld	a4,0(s3)
ffffffffc0202c42:	c09c                	sw	a5,0(s1)
static inline ppn_t page2ppn(struct Page *page) { return page - pages + nbase; }
ffffffffc0202c44:	9552                	add	a0,a0,s4
ffffffffc0202c46:	00c51793          	slli	a5,a0,0xc
ffffffffc0202c4a:	83b1                	srli	a5,a5,0xc
    return page2ppn(page) << PGSHIFT;
ffffffffc0202c4c:	0532                	slli	a0,a0,0xc
ffffffffc0202c4e:	08e7fd63          	bgeu	a5,a4,ffffffffc0202ce8 <get_pte+0x1c2>
ffffffffc0202c52:	000ab783          	ld	a5,0(s5)
ffffffffc0202c56:	6605                	lui	a2,0x1
ffffffffc0202c58:	4581                	li	a1,0
ffffffffc0202c5a:	953e                	add	a0,a0,a5
ffffffffc0202c5c:	300010ef          	jal	ra,ffffffffc0203f5c <memset>
static inline ppn_t page2ppn(struct Page *page) { return page - pages + nbase; }
ffffffffc0202c60:	000bb683          	ld	a3,0(s7)
ffffffffc0202c64:	40d486b3          	sub	a3,s1,a3
ffffffffc0202c68:	868d                	srai	a3,a3,0x3
ffffffffc0202c6a:	036686b3          	mul	a3,a3,s6
ffffffffc0202c6e:	96d2                	add	a3,a3,s4
    return (ppn << PTE_PPN_SHIFT) | PTE_V | type;
ffffffffc0202c70:	06aa                	slli	a3,a3,0xa
ffffffffc0202c72:	0116e693          	ori	a3,a3,17
 //   	memset(pa, 0, PGSIZE);
    	*pdep0 = pte_create(page2ppn(page), PTE_U | PTE_V);
ffffffffc0202c76:	e014                	sd	a3,0(s0)
    }
    return &((pte_t *)KADDR(PDE_ADDR(*pdep0)))[PTX(la)];
ffffffffc0202c78:	0009b703          	ld	a4,0(s3)
ffffffffc0202c7c:	068a                	slli	a3,a3,0x2
ffffffffc0202c7e:	757d                	lui	a0,0xfffff
ffffffffc0202c80:	8ee9                	and	a3,a3,a0
ffffffffc0202c82:	00c6d793          	srli	a5,a3,0xc
ffffffffc0202c86:	04e7f563          	bgeu	a5,a4,ffffffffc0202cd0 <get_pte+0x1aa>
ffffffffc0202c8a:	000ab503          	ld	a0,0(s5)
ffffffffc0202c8e:	00c95913          	srli	s2,s2,0xc
ffffffffc0202c92:	1ff97913          	andi	s2,s2,511
ffffffffc0202c96:	96aa                	add	a3,a3,a0
ffffffffc0202c98:	00391513          	slli	a0,s2,0x3
ffffffffc0202c9c:	9536                	add	a0,a0,a3
}
ffffffffc0202c9e:	60a6                	ld	ra,72(sp)
ffffffffc0202ca0:	6406                	ld	s0,64(sp)
ffffffffc0202ca2:	74e2                	ld	s1,56(sp)
ffffffffc0202ca4:	7942                	ld	s2,48(sp)
ffffffffc0202ca6:	79a2                	ld	s3,40(sp)
ffffffffc0202ca8:	7a02                	ld	s4,32(sp)
ffffffffc0202caa:	6ae2                	ld	s5,24(sp)
ffffffffc0202cac:	6b42                	ld	s6,16(sp)
ffffffffc0202cae:	6ba2                	ld	s7,8(sp)
ffffffffc0202cb0:	6161                	addi	sp,sp,80
ffffffffc0202cb2:	8082                	ret
            return NULL;
ffffffffc0202cb4:	4501                	li	a0,0
ffffffffc0202cb6:	b7e5                	j	ffffffffc0202c9e <get_pte+0x178>
    pde_t *pdep0 = &((pde_t *)KADDR(PDE_ADDR(*pdep1)))[PDX0(la)];
ffffffffc0202cb8:	00003617          	auipc	a2,0x3
ffffffffc0202cbc:	cf860613          	addi	a2,a2,-776 # ffffffffc02059b0 <default_pmm_manager+0x118>
ffffffffc0202cc0:	10200593          	li	a1,258
ffffffffc0202cc4:	00003517          	auipc	a0,0x3
ffffffffc0202cc8:	d1450513          	addi	a0,a0,-748 # ffffffffc02059d8 <default_pmm_manager+0x140>
ffffffffc0202ccc:	c36fd0ef          	jal	ra,ffffffffc0200102 <__panic>
    return &((pte_t *)KADDR(PDE_ADDR(*pdep0)))[PTX(la)];
ffffffffc0202cd0:	00003617          	auipc	a2,0x3
ffffffffc0202cd4:	ce060613          	addi	a2,a2,-800 # ffffffffc02059b0 <default_pmm_manager+0x118>
ffffffffc0202cd8:	10f00593          	li	a1,271
ffffffffc0202cdc:	00003517          	auipc	a0,0x3
ffffffffc0202ce0:	cfc50513          	addi	a0,a0,-772 # ffffffffc02059d8 <default_pmm_manager+0x140>
ffffffffc0202ce4:	c1efd0ef          	jal	ra,ffffffffc0200102 <__panic>
    	memset(KADDR(pa), 0, PGSIZE);
ffffffffc0202ce8:	86aa                	mv	a3,a0
ffffffffc0202cea:	00003617          	auipc	a2,0x3
ffffffffc0202cee:	cc660613          	addi	a2,a2,-826 # ffffffffc02059b0 <default_pmm_manager+0x118>
ffffffffc0202cf2:	10b00593          	li	a1,267
ffffffffc0202cf6:	00003517          	auipc	a0,0x3
ffffffffc0202cfa:	ce250513          	addi	a0,a0,-798 # ffffffffc02059d8 <default_pmm_manager+0x140>
ffffffffc0202cfe:	c04fd0ef          	jal	ra,ffffffffc0200102 <__panic>
        memset(KADDR(pa), 0, PGSIZE);
ffffffffc0202d02:	86aa                	mv	a3,a0
ffffffffc0202d04:	00003617          	auipc	a2,0x3
ffffffffc0202d08:	cac60613          	addi	a2,a2,-852 # ffffffffc02059b0 <default_pmm_manager+0x118>
ffffffffc0202d0c:	0ff00593          	li	a1,255
ffffffffc0202d10:	00003517          	auipc	a0,0x3
ffffffffc0202d14:	cc850513          	addi	a0,a0,-824 # ffffffffc02059d8 <default_pmm_manager+0x140>
ffffffffc0202d18:	beafd0ef          	jal	ra,ffffffffc0200102 <__panic>

ffffffffc0202d1c <get_page>:

// get_page - get related Page struct for linear address la using PDT pgdir
struct Page *get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store) {
ffffffffc0202d1c:	1141                	addi	sp,sp,-16
ffffffffc0202d1e:	e022                	sd	s0,0(sp)
ffffffffc0202d20:	8432                	mv	s0,a2
    pte_t *ptep = get_pte(pgdir, la, 0);
ffffffffc0202d22:	4601                	li	a2,0
struct Page *get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store) {
ffffffffc0202d24:	e406                	sd	ra,8(sp)
    pte_t *ptep = get_pte(pgdir, la, 0);
ffffffffc0202d26:	e01ff0ef          	jal	ra,ffffffffc0202b26 <get_pte>
    if (ptep_store != NULL) {
ffffffffc0202d2a:	c011                	beqz	s0,ffffffffc0202d2e <get_page+0x12>
        *ptep_store = ptep;
ffffffffc0202d2c:	e008                	sd	a0,0(s0)
    }
    if (ptep != NULL && *ptep & PTE_V) {
ffffffffc0202d2e:	c511                	beqz	a0,ffffffffc0202d3a <get_page+0x1e>
ffffffffc0202d30:	611c                	ld	a5,0(a0)
        return pte2page(*ptep);
    }
    return NULL;
ffffffffc0202d32:	4501                	li	a0,0
    if (ptep != NULL && *ptep & PTE_V) {
ffffffffc0202d34:	0017f713          	andi	a4,a5,1
ffffffffc0202d38:	e709                	bnez	a4,ffffffffc0202d42 <get_page+0x26>
}
ffffffffc0202d3a:	60a2                	ld	ra,8(sp)
ffffffffc0202d3c:	6402                	ld	s0,0(sp)
ffffffffc0202d3e:	0141                	addi	sp,sp,16
ffffffffc0202d40:	8082                	ret
    return pa2page(PTE_ADDR(pte));
ffffffffc0202d42:	078a                	slli	a5,a5,0x2
ffffffffc0202d44:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage) {
ffffffffc0202d46:	0000f717          	auipc	a4,0xf
ffffffffc0202d4a:	80a73703          	ld	a4,-2038(a4) # ffffffffc0211550 <npage>
ffffffffc0202d4e:	02e7f263          	bgeu	a5,a4,ffffffffc0202d72 <get_page+0x56>
    return &pages[PPN(pa) - nbase];
ffffffffc0202d52:	fff80537          	lui	a0,0xfff80
ffffffffc0202d56:	97aa                	add	a5,a5,a0
ffffffffc0202d58:	60a2                	ld	ra,8(sp)
ffffffffc0202d5a:	6402                	ld	s0,0(sp)
ffffffffc0202d5c:	00379513          	slli	a0,a5,0x3
ffffffffc0202d60:	97aa                	add	a5,a5,a0
ffffffffc0202d62:	078e                	slli	a5,a5,0x3
ffffffffc0202d64:	0000e517          	auipc	a0,0xe
ffffffffc0202d68:	7f453503          	ld	a0,2036(a0) # ffffffffc0211558 <pages>
ffffffffc0202d6c:	953e                	add	a0,a0,a5
ffffffffc0202d6e:	0141                	addi	sp,sp,16
ffffffffc0202d70:	8082                	ret
ffffffffc0202d72:	c71ff0ef          	jal	ra,ffffffffc02029e2 <pa2page.part.0>

ffffffffc0202d76 <page_remove>:
    }
}

// page_remove - free an Page which is related linear address la and has an
// validated pte
void page_remove(pde_t *pgdir, uintptr_t la) {
ffffffffc0202d76:	1101                	addi	sp,sp,-32
    pte_t *ptep = get_pte(pgdir, la, 0);
ffffffffc0202d78:	4601                	li	a2,0
void page_remove(pde_t *pgdir, uintptr_t la) {
ffffffffc0202d7a:	ec06                	sd	ra,24(sp)
ffffffffc0202d7c:	e822                	sd	s0,16(sp)
    pte_t *ptep = get_pte(pgdir, la, 0);
ffffffffc0202d7e:	da9ff0ef          	jal	ra,ffffffffc0202b26 <get_pte>
    if (ptep != NULL) {
ffffffffc0202d82:	c511                	beqz	a0,ffffffffc0202d8e <page_remove+0x18>
    if (*ptep & PTE_V) {  //(1) check if this page table entry is
ffffffffc0202d84:	611c                	ld	a5,0(a0)
ffffffffc0202d86:	842a                	mv	s0,a0
ffffffffc0202d88:	0017f713          	andi	a4,a5,1
ffffffffc0202d8c:	e709                	bnez	a4,ffffffffc0202d96 <page_remove+0x20>
        page_remove_pte(pgdir, la, ptep);
    }
}
ffffffffc0202d8e:	60e2                	ld	ra,24(sp)
ffffffffc0202d90:	6442                	ld	s0,16(sp)
ffffffffc0202d92:	6105                	addi	sp,sp,32
ffffffffc0202d94:	8082                	ret
    return pa2page(PTE_ADDR(pte));
ffffffffc0202d96:	078a                	slli	a5,a5,0x2
ffffffffc0202d98:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage) {
ffffffffc0202d9a:	0000e717          	auipc	a4,0xe
ffffffffc0202d9e:	7b673703          	ld	a4,1974(a4) # ffffffffc0211550 <npage>
ffffffffc0202da2:	06e7f563          	bgeu	a5,a4,ffffffffc0202e0c <page_remove+0x96>
    return &pages[PPN(pa) - nbase];
ffffffffc0202da6:	fff80737          	lui	a4,0xfff80
ffffffffc0202daa:	97ba                	add	a5,a5,a4
ffffffffc0202dac:	00379513          	slli	a0,a5,0x3
ffffffffc0202db0:	97aa                	add	a5,a5,a0
ffffffffc0202db2:	078e                	slli	a5,a5,0x3
ffffffffc0202db4:	0000e517          	auipc	a0,0xe
ffffffffc0202db8:	7a453503          	ld	a0,1956(a0) # ffffffffc0211558 <pages>
ffffffffc0202dbc:	953e                	add	a0,a0,a5
    page->ref -= 1;
ffffffffc0202dbe:	411c                	lw	a5,0(a0)
ffffffffc0202dc0:	fff7871b          	addiw	a4,a5,-1
ffffffffc0202dc4:	c118                	sw	a4,0(a0)
        if (page_ref(page) ==
ffffffffc0202dc6:	cb09                	beqz	a4,ffffffffc0202dd8 <page_remove+0x62>
        *ptep = 0;                  //(5) clear second page table entry
ffffffffc0202dc8:	00043023          	sd	zero,0(s0)
static inline void flush_tlb() { asm volatile("sfence.vma"); }
ffffffffc0202dcc:	12000073          	sfence.vma
}
ffffffffc0202dd0:	60e2                	ld	ra,24(sp)
ffffffffc0202dd2:	6442                	ld	s0,16(sp)
ffffffffc0202dd4:	6105                	addi	sp,sp,32
ffffffffc0202dd6:	8082                	ret
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0202dd8:	100027f3          	csrr	a5,sstatus
ffffffffc0202ddc:	8b89                	andi	a5,a5,2
ffffffffc0202dde:	eb89                	bnez	a5,ffffffffc0202df0 <page_remove+0x7a>
    { pmm_manager->free_pages(base, n); }
ffffffffc0202de0:	0000e797          	auipc	a5,0xe
ffffffffc0202de4:	7807b783          	ld	a5,1920(a5) # ffffffffc0211560 <pmm_manager>
ffffffffc0202de8:	739c                	ld	a5,32(a5)
ffffffffc0202dea:	4585                	li	a1,1
ffffffffc0202dec:	9782                	jalr	a5
    if (flag) {
ffffffffc0202dee:	bfe9                	j	ffffffffc0202dc8 <page_remove+0x52>
        intr_disable();
ffffffffc0202df0:	e42a                	sd	a0,8(sp)
ffffffffc0202df2:	efcfd0ef          	jal	ra,ffffffffc02004ee <intr_disable>
ffffffffc0202df6:	0000e797          	auipc	a5,0xe
ffffffffc0202dfa:	76a7b783          	ld	a5,1898(a5) # ffffffffc0211560 <pmm_manager>
ffffffffc0202dfe:	739c                	ld	a5,32(a5)
ffffffffc0202e00:	6522                	ld	a0,8(sp)
ffffffffc0202e02:	4585                	li	a1,1
ffffffffc0202e04:	9782                	jalr	a5
        intr_enable();
ffffffffc0202e06:	ee2fd0ef          	jal	ra,ffffffffc02004e8 <intr_enable>
ffffffffc0202e0a:	bf7d                	j	ffffffffc0202dc8 <page_remove+0x52>
ffffffffc0202e0c:	bd7ff0ef          	jal	ra,ffffffffc02029e2 <pa2page.part.0>

ffffffffc0202e10 <page_insert>:
//  page:  the Page which need to map
//  la:    the linear address need to map
//  perm:  the permission of this Page which is setted in related pte
// return value: always 0
// note: PT is changed, so the TLB need to be invalidate
int page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
ffffffffc0202e10:	7179                	addi	sp,sp,-48
ffffffffc0202e12:	87b2                	mv	a5,a2
ffffffffc0202e14:	f022                	sd	s0,32(sp)
    pte_t *ptep = get_pte(pgdir, la, 1);
ffffffffc0202e16:	4605                	li	a2,1
int page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
ffffffffc0202e18:	842e                	mv	s0,a1
    pte_t *ptep = get_pte(pgdir, la, 1);
ffffffffc0202e1a:	85be                	mv	a1,a5
int page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
ffffffffc0202e1c:	ec26                	sd	s1,24(sp)
ffffffffc0202e1e:	f406                	sd	ra,40(sp)
ffffffffc0202e20:	e84a                	sd	s2,16(sp)
ffffffffc0202e22:	e44e                	sd	s3,8(sp)
ffffffffc0202e24:	e052                	sd	s4,0(sp)
ffffffffc0202e26:	84b6                	mv	s1,a3
    pte_t *ptep = get_pte(pgdir, la, 1);
ffffffffc0202e28:	cffff0ef          	jal	ra,ffffffffc0202b26 <get_pte>
    if (ptep == NULL) {
ffffffffc0202e2c:	cd71                	beqz	a0,ffffffffc0202f08 <page_insert+0xf8>
    page->ref += 1;
ffffffffc0202e2e:	4014                	lw	a3,0(s0)
        return -E_NO_MEM;
    }
    page_ref_inc(page);
    if (*ptep & PTE_V) {
ffffffffc0202e30:	611c                	ld	a5,0(a0)
ffffffffc0202e32:	89aa                	mv	s3,a0
ffffffffc0202e34:	0016871b          	addiw	a4,a3,1
ffffffffc0202e38:	c018                	sw	a4,0(s0)
ffffffffc0202e3a:	0017f713          	andi	a4,a5,1
ffffffffc0202e3e:	e331                	bnez	a4,ffffffffc0202e82 <page_insert+0x72>
static inline ppn_t page2ppn(struct Page *page) { return page - pages + nbase; }
ffffffffc0202e40:	0000e797          	auipc	a5,0xe
ffffffffc0202e44:	7187b783          	ld	a5,1816(a5) # ffffffffc0211558 <pages>
ffffffffc0202e48:	40f407b3          	sub	a5,s0,a5
ffffffffc0202e4c:	878d                	srai	a5,a5,0x3
ffffffffc0202e4e:	00003417          	auipc	s0,0x3
ffffffffc0202e52:	3fa43403          	ld	s0,1018(s0) # ffffffffc0206248 <error_string+0x38>
ffffffffc0202e56:	028787b3          	mul	a5,a5,s0
ffffffffc0202e5a:	00080437          	lui	s0,0x80
ffffffffc0202e5e:	97a2                	add	a5,a5,s0
    return (ppn << PTE_PPN_SHIFT) | PTE_V | type;
ffffffffc0202e60:	07aa                	slli	a5,a5,0xa
ffffffffc0202e62:	8cdd                	or	s1,s1,a5
ffffffffc0202e64:	0014e493          	ori	s1,s1,1
            page_ref_dec(page);
        } else {
            page_remove_pte(pgdir, la, ptep);
        }
    }
    *ptep = pte_create(page2ppn(page), PTE_V | perm);
ffffffffc0202e68:	0099b023          	sd	s1,0(s3)
static inline void flush_tlb() { asm volatile("sfence.vma"); }
ffffffffc0202e6c:	12000073          	sfence.vma
    tlb_invalidate(pgdir, la);
    return 0;
ffffffffc0202e70:	4501                	li	a0,0
}
ffffffffc0202e72:	70a2                	ld	ra,40(sp)
ffffffffc0202e74:	7402                	ld	s0,32(sp)
ffffffffc0202e76:	64e2                	ld	s1,24(sp)
ffffffffc0202e78:	6942                	ld	s2,16(sp)
ffffffffc0202e7a:	69a2                	ld	s3,8(sp)
ffffffffc0202e7c:	6a02                	ld	s4,0(sp)
ffffffffc0202e7e:	6145                	addi	sp,sp,48
ffffffffc0202e80:	8082                	ret
    return pa2page(PTE_ADDR(pte));
ffffffffc0202e82:	00279713          	slli	a4,a5,0x2
ffffffffc0202e86:	8331                	srli	a4,a4,0xc
    if (PPN(pa) >= npage) {
ffffffffc0202e88:	0000e797          	auipc	a5,0xe
ffffffffc0202e8c:	6c87b783          	ld	a5,1736(a5) # ffffffffc0211550 <npage>
ffffffffc0202e90:	06f77e63          	bgeu	a4,a5,ffffffffc0202f0c <page_insert+0xfc>
    return &pages[PPN(pa) - nbase];
ffffffffc0202e94:	fff807b7          	lui	a5,0xfff80
ffffffffc0202e98:	973e                	add	a4,a4,a5
ffffffffc0202e9a:	0000ea17          	auipc	s4,0xe
ffffffffc0202e9e:	6bea0a13          	addi	s4,s4,1726 # ffffffffc0211558 <pages>
ffffffffc0202ea2:	000a3783          	ld	a5,0(s4)
ffffffffc0202ea6:	00371913          	slli	s2,a4,0x3
ffffffffc0202eaa:	993a                	add	s2,s2,a4
ffffffffc0202eac:	090e                	slli	s2,s2,0x3
ffffffffc0202eae:	993e                	add	s2,s2,a5
        if (p == page) {
ffffffffc0202eb0:	03240063          	beq	s0,s2,ffffffffc0202ed0 <page_insert+0xc0>
    page->ref -= 1;
ffffffffc0202eb4:	00092783          	lw	a5,0(s2)
ffffffffc0202eb8:	fff7871b          	addiw	a4,a5,-1
ffffffffc0202ebc:	00e92023          	sw	a4,0(s2)
        if (page_ref(page) ==
ffffffffc0202ec0:	cb11                	beqz	a4,ffffffffc0202ed4 <page_insert+0xc4>
        *ptep = 0;                  //(5) clear second page table entry
ffffffffc0202ec2:	0009b023          	sd	zero,0(s3)
static inline void flush_tlb() { asm volatile("sfence.vma"); }
ffffffffc0202ec6:	12000073          	sfence.vma
static inline ppn_t page2ppn(struct Page *page) { return page - pages + nbase; }
ffffffffc0202eca:	000a3783          	ld	a5,0(s4)
}
ffffffffc0202ece:	bfad                	j	ffffffffc0202e48 <page_insert+0x38>
    page->ref -= 1;
ffffffffc0202ed0:	c014                	sw	a3,0(s0)
    return page->ref;
ffffffffc0202ed2:	bf9d                	j	ffffffffc0202e48 <page_insert+0x38>
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0202ed4:	100027f3          	csrr	a5,sstatus
ffffffffc0202ed8:	8b89                	andi	a5,a5,2
ffffffffc0202eda:	eb91                	bnez	a5,ffffffffc0202eee <page_insert+0xde>
    { pmm_manager->free_pages(base, n); }
ffffffffc0202edc:	0000e797          	auipc	a5,0xe
ffffffffc0202ee0:	6847b783          	ld	a5,1668(a5) # ffffffffc0211560 <pmm_manager>
ffffffffc0202ee4:	739c                	ld	a5,32(a5)
ffffffffc0202ee6:	4585                	li	a1,1
ffffffffc0202ee8:	854a                	mv	a0,s2
ffffffffc0202eea:	9782                	jalr	a5
    if (flag) {
ffffffffc0202eec:	bfd9                	j	ffffffffc0202ec2 <page_insert+0xb2>
        intr_disable();
ffffffffc0202eee:	e00fd0ef          	jal	ra,ffffffffc02004ee <intr_disable>
ffffffffc0202ef2:	0000e797          	auipc	a5,0xe
ffffffffc0202ef6:	66e7b783          	ld	a5,1646(a5) # ffffffffc0211560 <pmm_manager>
ffffffffc0202efa:	739c                	ld	a5,32(a5)
ffffffffc0202efc:	4585                	li	a1,1
ffffffffc0202efe:	854a                	mv	a0,s2
ffffffffc0202f00:	9782                	jalr	a5
        intr_enable();
ffffffffc0202f02:	de6fd0ef          	jal	ra,ffffffffc02004e8 <intr_enable>
ffffffffc0202f06:	bf75                	j	ffffffffc0202ec2 <page_insert+0xb2>
        return -E_NO_MEM;
ffffffffc0202f08:	5571                	li	a0,-4
ffffffffc0202f0a:	b7a5                	j	ffffffffc0202e72 <page_insert+0x62>
ffffffffc0202f0c:	ad7ff0ef          	jal	ra,ffffffffc02029e2 <pa2page.part.0>

ffffffffc0202f10 <pmm_init>:
    pmm_manager = &default_pmm_manager;
ffffffffc0202f10:	00003797          	auipc	a5,0x3
ffffffffc0202f14:	98878793          	addi	a5,a5,-1656 # ffffffffc0205898 <default_pmm_manager>
    cprintf("memory management: %s\n", pmm_manager->name);
ffffffffc0202f18:	638c                	ld	a1,0(a5)
void pmm_init(void) {
ffffffffc0202f1a:	7159                	addi	sp,sp,-112
ffffffffc0202f1c:	f45e                	sd	s7,40(sp)
    cprintf("memory management: %s\n", pmm_manager->name);
ffffffffc0202f1e:	00003517          	auipc	a0,0x3
ffffffffc0202f22:	aca50513          	addi	a0,a0,-1334 # ffffffffc02059e8 <default_pmm_manager+0x150>
    pmm_manager = &default_pmm_manager;
ffffffffc0202f26:	0000eb97          	auipc	s7,0xe
ffffffffc0202f2a:	63ab8b93          	addi	s7,s7,1594 # ffffffffc0211560 <pmm_manager>
void pmm_init(void) {
ffffffffc0202f2e:	f486                	sd	ra,104(sp)
ffffffffc0202f30:	f0a2                	sd	s0,96(sp)
ffffffffc0202f32:	eca6                	sd	s1,88(sp)
ffffffffc0202f34:	e8ca                	sd	s2,80(sp)
ffffffffc0202f36:	e4ce                	sd	s3,72(sp)
ffffffffc0202f38:	f85a                	sd	s6,48(sp)
    pmm_manager = &default_pmm_manager;
ffffffffc0202f3a:	00fbb023          	sd	a5,0(s7)
void pmm_init(void) {
ffffffffc0202f3e:	e0d2                	sd	s4,64(sp)
ffffffffc0202f40:	fc56                	sd	s5,56(sp)
ffffffffc0202f42:	f062                	sd	s8,32(sp)
ffffffffc0202f44:	ec66                	sd	s9,24(sp)
ffffffffc0202f46:	e86a                	sd	s10,16(sp)
    cprintf("memory management: %s\n", pmm_manager->name);
ffffffffc0202f48:	972fd0ef          	jal	ra,ffffffffc02000ba <cprintf>
    pmm_manager->init();
ffffffffc0202f4c:	000bb783          	ld	a5,0(s7)
    cprintf("membegin %llx memend %llx mem_size %llx\n",mem_begin, mem_end, mem_size);
ffffffffc0202f50:	4445                	li	s0,17
ffffffffc0202f52:	40100913          	li	s2,1025
    pmm_manager->init();
ffffffffc0202f56:	679c                	ld	a5,8(a5)
    va_pa_offset = KERNBASE - 0x80200000;
ffffffffc0202f58:	0000e997          	auipc	s3,0xe
ffffffffc0202f5c:	61098993          	addi	s3,s3,1552 # ffffffffc0211568 <va_pa_offset>
    npage = maxpa / PGSIZE;
ffffffffc0202f60:	0000e497          	auipc	s1,0xe
ffffffffc0202f64:	5f048493          	addi	s1,s1,1520 # ffffffffc0211550 <npage>
    pmm_manager->init();
ffffffffc0202f68:	9782                	jalr	a5
    va_pa_offset = KERNBASE - 0x80200000;
ffffffffc0202f6a:	57f5                	li	a5,-3
ffffffffc0202f6c:	07fa                	slli	a5,a5,0x1e
    cprintf("membegin %llx memend %llx mem_size %llx\n",mem_begin, mem_end, mem_size);
ffffffffc0202f6e:	07e006b7          	lui	a3,0x7e00
ffffffffc0202f72:	01b41613          	slli	a2,s0,0x1b
ffffffffc0202f76:	01591593          	slli	a1,s2,0x15
ffffffffc0202f7a:	00003517          	auipc	a0,0x3
ffffffffc0202f7e:	a8650513          	addi	a0,a0,-1402 # ffffffffc0205a00 <default_pmm_manager+0x168>
    va_pa_offset = KERNBASE - 0x80200000;
ffffffffc0202f82:	00f9b023          	sd	a5,0(s3)
    cprintf("membegin %llx memend %llx mem_size %llx\n",mem_begin, mem_end, mem_size);
ffffffffc0202f86:	934fd0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("physcial memory map:\n");
ffffffffc0202f8a:	00003517          	auipc	a0,0x3
ffffffffc0202f8e:	aa650513          	addi	a0,a0,-1370 # ffffffffc0205a30 <default_pmm_manager+0x198>
ffffffffc0202f92:	928fd0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("  memory: 0x%08lx, [0x%08lx, 0x%08lx].\n", mem_size, mem_begin,
ffffffffc0202f96:	01b41693          	slli	a3,s0,0x1b
ffffffffc0202f9a:	16fd                	addi	a3,a3,-1
ffffffffc0202f9c:	07e005b7          	lui	a1,0x7e00
ffffffffc0202fa0:	01591613          	slli	a2,s2,0x15
ffffffffc0202fa4:	00003517          	auipc	a0,0x3
ffffffffc0202fa8:	aa450513          	addi	a0,a0,-1372 # ffffffffc0205a48 <default_pmm_manager+0x1b0>
ffffffffc0202fac:	90efd0ef          	jal	ra,ffffffffc02000ba <cprintf>
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
ffffffffc0202fb0:	777d                	lui	a4,0xfffff
ffffffffc0202fb2:	0000f797          	auipc	a5,0xf
ffffffffc0202fb6:	5bd78793          	addi	a5,a5,1469 # ffffffffc021256f <end+0xfff>
ffffffffc0202fba:	8ff9                	and	a5,a5,a4
ffffffffc0202fbc:	0000eb17          	auipc	s6,0xe
ffffffffc0202fc0:	59cb0b13          	addi	s6,s6,1436 # ffffffffc0211558 <pages>
    npage = maxpa / PGSIZE;
ffffffffc0202fc4:	00088737          	lui	a4,0x88
ffffffffc0202fc8:	e098                	sd	a4,0(s1)
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
ffffffffc0202fca:	00fb3023          	sd	a5,0(s6)
ffffffffc0202fce:	4681                	li	a3,0
    for (size_t i = 0; i < npage - nbase; i++) {
ffffffffc0202fd0:	4701                	li	a4,0
ffffffffc0202fd2:	4505                	li	a0,1
ffffffffc0202fd4:	fff805b7          	lui	a1,0xfff80
ffffffffc0202fd8:	a019                	j	ffffffffc0202fde <pmm_init+0xce>
        SetPageReserved(pages + i);
ffffffffc0202fda:	000b3783          	ld	a5,0(s6)
ffffffffc0202fde:	97b6                	add	a5,a5,a3
ffffffffc0202fe0:	07a1                	addi	a5,a5,8
ffffffffc0202fe2:	40a7b02f          	amoor.d	zero,a0,(a5)
    for (size_t i = 0; i < npage - nbase; i++) {
ffffffffc0202fe6:	609c                	ld	a5,0(s1)
ffffffffc0202fe8:	0705                	addi	a4,a4,1
ffffffffc0202fea:	04868693          	addi	a3,a3,72 # 7e00048 <kern_entry-0xffffffffb83fffb8>
ffffffffc0202fee:	00b78633          	add	a2,a5,a1
ffffffffc0202ff2:	fec764e3          	bltu	a4,a2,ffffffffc0202fda <pmm_init+0xca>
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc0202ff6:	000b3503          	ld	a0,0(s6)
ffffffffc0202ffa:	00379693          	slli	a3,a5,0x3
ffffffffc0202ffe:	96be                	add	a3,a3,a5
ffffffffc0203000:	fdc00737          	lui	a4,0xfdc00
ffffffffc0203004:	972a                	add	a4,a4,a0
ffffffffc0203006:	068e                	slli	a3,a3,0x3
ffffffffc0203008:	96ba                	add	a3,a3,a4
ffffffffc020300a:	c0200737          	lui	a4,0xc0200
ffffffffc020300e:	64e6e463          	bltu	a3,a4,ffffffffc0203656 <pmm_init+0x746>
ffffffffc0203012:	0009b703          	ld	a4,0(s3)
    if (freemem < mem_end) {
ffffffffc0203016:	4645                	li	a2,17
ffffffffc0203018:	066e                	slli	a2,a2,0x1b
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc020301a:	8e99                	sub	a3,a3,a4
    if (freemem < mem_end) {
ffffffffc020301c:	4ec6e263          	bltu	a3,a2,ffffffffc0203500 <pmm_init+0x5f0>

    return page;
}

static void check_alloc_page(void) {
    pmm_manager->check();
ffffffffc0203020:	000bb783          	ld	a5,0(s7)
    boot_pgdir = (pte_t*)boot_page_table_sv39;
ffffffffc0203024:	0000e917          	auipc	s2,0xe
ffffffffc0203028:	52490913          	addi	s2,s2,1316 # ffffffffc0211548 <boot_pgdir>
    pmm_manager->check();
ffffffffc020302c:	7b9c                	ld	a5,48(a5)
ffffffffc020302e:	9782                	jalr	a5
    cprintf("check_alloc_page() succeeded!\n");
ffffffffc0203030:	00003517          	auipc	a0,0x3
ffffffffc0203034:	a6850513          	addi	a0,a0,-1432 # ffffffffc0205a98 <default_pmm_manager+0x200>
ffffffffc0203038:	882fd0ef          	jal	ra,ffffffffc02000ba <cprintf>
    boot_pgdir = (pte_t*)boot_page_table_sv39;
ffffffffc020303c:	00006697          	auipc	a3,0x6
ffffffffc0203040:	fc468693          	addi	a3,a3,-60 # ffffffffc0209000 <boot_page_table_sv39>
ffffffffc0203044:	00d93023          	sd	a3,0(s2)
    boot_cr3 = PADDR(boot_pgdir);
ffffffffc0203048:	c02007b7          	lui	a5,0xc0200
ffffffffc020304c:	62f6e163          	bltu	a3,a5,ffffffffc020366e <pmm_init+0x75e>
ffffffffc0203050:	0009b783          	ld	a5,0(s3)
ffffffffc0203054:	8e9d                	sub	a3,a3,a5
ffffffffc0203056:	0000e797          	auipc	a5,0xe
ffffffffc020305a:	4ed7b523          	sd	a3,1258(a5) # ffffffffc0211540 <boot_cr3>
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc020305e:	100027f3          	csrr	a5,sstatus
ffffffffc0203062:	8b89                	andi	a5,a5,2
ffffffffc0203064:	4c079763          	bnez	a5,ffffffffc0203532 <pmm_init+0x622>
    { ret = pmm_manager->nr_free_pages(); }
ffffffffc0203068:	000bb783          	ld	a5,0(s7)
ffffffffc020306c:	779c                	ld	a5,40(a5)
ffffffffc020306e:	9782                	jalr	a5
ffffffffc0203070:	842a                	mv	s0,a0
    // so npage is always larger than KMEMSIZE / PGSIZE
    size_t nr_free_store;

    nr_free_store=nr_free_pages();

    assert(npage <= KERNTOP / PGSIZE);
ffffffffc0203072:	6098                	ld	a4,0(s1)
ffffffffc0203074:	c80007b7          	lui	a5,0xc8000
ffffffffc0203078:	83b1                	srli	a5,a5,0xc
ffffffffc020307a:	62e7e663          	bltu	a5,a4,ffffffffc02036a6 <pmm_init+0x796>
    assert(boot_pgdir != NULL && (uint32_t)PGOFF(boot_pgdir) == 0);
ffffffffc020307e:	00093503          	ld	a0,0(s2)
ffffffffc0203082:	60050263          	beqz	a0,ffffffffc0203686 <pmm_init+0x776>
ffffffffc0203086:	03451793          	slli	a5,a0,0x34
ffffffffc020308a:	5e079e63          	bnez	a5,ffffffffc0203686 <pmm_init+0x776>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
ffffffffc020308e:	4601                	li	a2,0
ffffffffc0203090:	4581                	li	a1,0
ffffffffc0203092:	c8bff0ef          	jal	ra,ffffffffc0202d1c <get_page>
ffffffffc0203096:	66051a63          	bnez	a0,ffffffffc020370a <pmm_init+0x7fa>

    struct Page *p1, *p2;
    p1 = alloc_page();
ffffffffc020309a:	4505                	li	a0,1
ffffffffc020309c:	97fff0ef          	jal	ra,ffffffffc0202a1a <alloc_pages>
ffffffffc02030a0:	8a2a                	mv	s4,a0
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
ffffffffc02030a2:	00093503          	ld	a0,0(s2)
ffffffffc02030a6:	4681                	li	a3,0
ffffffffc02030a8:	4601                	li	a2,0
ffffffffc02030aa:	85d2                	mv	a1,s4
ffffffffc02030ac:	d65ff0ef          	jal	ra,ffffffffc0202e10 <page_insert>
ffffffffc02030b0:	62051d63          	bnez	a0,ffffffffc02036ea <pmm_init+0x7da>
    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
ffffffffc02030b4:	00093503          	ld	a0,0(s2)
ffffffffc02030b8:	4601                	li	a2,0
ffffffffc02030ba:	4581                	li	a1,0
ffffffffc02030bc:	a6bff0ef          	jal	ra,ffffffffc0202b26 <get_pte>
ffffffffc02030c0:	60050563          	beqz	a0,ffffffffc02036ca <pmm_init+0x7ba>
    assert(pte2page(*ptep) == p1);
ffffffffc02030c4:	611c                	ld	a5,0(a0)
    if (!(pte & PTE_V)) {
ffffffffc02030c6:	0017f713          	andi	a4,a5,1
ffffffffc02030ca:	5e070e63          	beqz	a4,ffffffffc02036c6 <pmm_init+0x7b6>
    if (PPN(pa) >= npage) {
ffffffffc02030ce:	6090                	ld	a2,0(s1)
    return pa2page(PTE_ADDR(pte));
ffffffffc02030d0:	078a                	slli	a5,a5,0x2
ffffffffc02030d2:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage) {
ffffffffc02030d4:	56c7ff63          	bgeu	a5,a2,ffffffffc0203652 <pmm_init+0x742>
    return &pages[PPN(pa) - nbase];
ffffffffc02030d8:	fff80737          	lui	a4,0xfff80
ffffffffc02030dc:	97ba                	add	a5,a5,a4
ffffffffc02030de:	000b3683          	ld	a3,0(s6)
ffffffffc02030e2:	00379713          	slli	a4,a5,0x3
ffffffffc02030e6:	97ba                	add	a5,a5,a4
ffffffffc02030e8:	078e                	slli	a5,a5,0x3
ffffffffc02030ea:	97b6                	add	a5,a5,a3
ffffffffc02030ec:	14fa18e3          	bne	s4,a5,ffffffffc0203a3c <pmm_init+0xb2c>
    assert(page_ref(p1) == 1);
ffffffffc02030f0:	000a2703          	lw	a4,0(s4)
ffffffffc02030f4:	4785                	li	a5,1
ffffffffc02030f6:	16f71fe3          	bne	a4,a5,ffffffffc0203a74 <pmm_init+0xb64>

    ptep = (pte_t *)KADDR(PDE_ADDR(boot_pgdir[0]));
ffffffffc02030fa:	00093503          	ld	a0,0(s2)
ffffffffc02030fe:	77fd                	lui	a5,0xfffff
ffffffffc0203100:	6114                	ld	a3,0(a0)
ffffffffc0203102:	068a                	slli	a3,a3,0x2
ffffffffc0203104:	8efd                	and	a3,a3,a5
ffffffffc0203106:	00c6d713          	srli	a4,a3,0xc
ffffffffc020310a:	14c779e3          	bgeu	a4,a2,ffffffffc0203a5c <pmm_init+0xb4c>
ffffffffc020310e:	0009bc03          	ld	s8,0(s3)
    ptep = (pte_t *)KADDR(PDE_ADDR(ptep[0])) + 1;
ffffffffc0203112:	96e2                	add	a3,a3,s8
ffffffffc0203114:	0006ba83          	ld	s5,0(a3)
ffffffffc0203118:	0a8a                	slli	s5,s5,0x2
ffffffffc020311a:	00fafab3          	and	s5,s5,a5
ffffffffc020311e:	00cad793          	srli	a5,s5,0xc
ffffffffc0203122:	66c7f463          	bgeu	a5,a2,ffffffffc020378a <pmm_init+0x87a>
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
ffffffffc0203126:	4601                	li	a2,0
ffffffffc0203128:	6585                	lui	a1,0x1
    ptep = (pte_t *)KADDR(PDE_ADDR(ptep[0])) + 1;
ffffffffc020312a:	9ae2                	add	s5,s5,s8
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
ffffffffc020312c:	9fbff0ef          	jal	ra,ffffffffc0202b26 <get_pte>
    ptep = (pte_t *)KADDR(PDE_ADDR(ptep[0])) + 1;
ffffffffc0203130:	0aa1                	addi	s5,s5,8
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
ffffffffc0203132:	63551c63          	bne	a0,s5,ffffffffc020376a <pmm_init+0x85a>

    p2 = alloc_page();
ffffffffc0203136:	4505                	li	a0,1
ffffffffc0203138:	8e3ff0ef          	jal	ra,ffffffffc0202a1a <alloc_pages>
ffffffffc020313c:	8aaa                	mv	s5,a0
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
ffffffffc020313e:	00093503          	ld	a0,0(s2)
ffffffffc0203142:	46d1                	li	a3,20
ffffffffc0203144:	6605                	lui	a2,0x1
ffffffffc0203146:	85d6                	mv	a1,s5
ffffffffc0203148:	cc9ff0ef          	jal	ra,ffffffffc0202e10 <page_insert>
ffffffffc020314c:	5c051f63          	bnez	a0,ffffffffc020372a <pmm_init+0x81a>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
ffffffffc0203150:	00093503          	ld	a0,0(s2)
ffffffffc0203154:	4601                	li	a2,0
ffffffffc0203156:	6585                	lui	a1,0x1
ffffffffc0203158:	9cfff0ef          	jal	ra,ffffffffc0202b26 <get_pte>
ffffffffc020315c:	12050ce3          	beqz	a0,ffffffffc0203a94 <pmm_init+0xb84>
    assert(*ptep & PTE_U);
ffffffffc0203160:	611c                	ld	a5,0(a0)
ffffffffc0203162:	0107f713          	andi	a4,a5,16
ffffffffc0203166:	72070f63          	beqz	a4,ffffffffc02038a4 <pmm_init+0x994>
    assert(*ptep & PTE_W);
ffffffffc020316a:	8b91                	andi	a5,a5,4
ffffffffc020316c:	6e078c63          	beqz	a5,ffffffffc0203864 <pmm_init+0x954>
    assert(boot_pgdir[0] & PTE_U);
ffffffffc0203170:	00093503          	ld	a0,0(s2)
ffffffffc0203174:	611c                	ld	a5,0(a0)
ffffffffc0203176:	8bc1                	andi	a5,a5,16
ffffffffc0203178:	6c078663          	beqz	a5,ffffffffc0203844 <pmm_init+0x934>
    assert(page_ref(p2) == 1);
ffffffffc020317c:	000aa703          	lw	a4,0(s5)
ffffffffc0203180:	4785                	li	a5,1
ffffffffc0203182:	5cf71463          	bne	a4,a5,ffffffffc020374a <pmm_init+0x83a>

    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
ffffffffc0203186:	4681                	li	a3,0
ffffffffc0203188:	6605                	lui	a2,0x1
ffffffffc020318a:	85d2                	mv	a1,s4
ffffffffc020318c:	c85ff0ef          	jal	ra,ffffffffc0202e10 <page_insert>
ffffffffc0203190:	66051a63          	bnez	a0,ffffffffc0203804 <pmm_init+0x8f4>
    assert(page_ref(p1) == 2);
ffffffffc0203194:	000a2703          	lw	a4,0(s4)
ffffffffc0203198:	4789                	li	a5,2
ffffffffc020319a:	64f71563          	bne	a4,a5,ffffffffc02037e4 <pmm_init+0x8d4>
    assert(page_ref(p2) == 0);
ffffffffc020319e:	000aa783          	lw	a5,0(s5)
ffffffffc02031a2:	62079163          	bnez	a5,ffffffffc02037c4 <pmm_init+0x8b4>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
ffffffffc02031a6:	00093503          	ld	a0,0(s2)
ffffffffc02031aa:	4601                	li	a2,0
ffffffffc02031ac:	6585                	lui	a1,0x1
ffffffffc02031ae:	979ff0ef          	jal	ra,ffffffffc0202b26 <get_pte>
ffffffffc02031b2:	5e050963          	beqz	a0,ffffffffc02037a4 <pmm_init+0x894>
    assert(pte2page(*ptep) == p1);
ffffffffc02031b6:	6118                	ld	a4,0(a0)
    if (!(pte & PTE_V)) {
ffffffffc02031b8:	00177793          	andi	a5,a4,1
ffffffffc02031bc:	50078563          	beqz	a5,ffffffffc02036c6 <pmm_init+0x7b6>
    if (PPN(pa) >= npage) {
ffffffffc02031c0:	6094                	ld	a3,0(s1)
    return pa2page(PTE_ADDR(pte));
ffffffffc02031c2:	00271793          	slli	a5,a4,0x2
ffffffffc02031c6:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage) {
ffffffffc02031c8:	48d7f563          	bgeu	a5,a3,ffffffffc0203652 <pmm_init+0x742>
    return &pages[PPN(pa) - nbase];
ffffffffc02031cc:	fff806b7          	lui	a3,0xfff80
ffffffffc02031d0:	97b6                	add	a5,a5,a3
ffffffffc02031d2:	000b3603          	ld	a2,0(s6)
ffffffffc02031d6:	00379693          	slli	a3,a5,0x3
ffffffffc02031da:	97b6                	add	a5,a5,a3
ffffffffc02031dc:	078e                	slli	a5,a5,0x3
ffffffffc02031de:	97b2                	add	a5,a5,a2
ffffffffc02031e0:	72fa1263          	bne	s4,a5,ffffffffc0203904 <pmm_init+0x9f4>
    assert((*ptep & PTE_U) == 0);
ffffffffc02031e4:	8b41                	andi	a4,a4,16
ffffffffc02031e6:	6e071f63          	bnez	a4,ffffffffc02038e4 <pmm_init+0x9d4>

    page_remove(boot_pgdir, 0x0);
ffffffffc02031ea:	00093503          	ld	a0,0(s2)
ffffffffc02031ee:	4581                	li	a1,0
ffffffffc02031f0:	b87ff0ef          	jal	ra,ffffffffc0202d76 <page_remove>
    assert(page_ref(p1) == 1);
ffffffffc02031f4:	000a2703          	lw	a4,0(s4)
ffffffffc02031f8:	4785                	li	a5,1
ffffffffc02031fa:	6cf71563          	bne	a4,a5,ffffffffc02038c4 <pmm_init+0x9b4>
    assert(page_ref(p2) == 0);
ffffffffc02031fe:	000aa783          	lw	a5,0(s5)
ffffffffc0203202:	78079d63          	bnez	a5,ffffffffc020399c <pmm_init+0xa8c>

    page_remove(boot_pgdir, PGSIZE);
ffffffffc0203206:	00093503          	ld	a0,0(s2)
ffffffffc020320a:	6585                	lui	a1,0x1
ffffffffc020320c:	b6bff0ef          	jal	ra,ffffffffc0202d76 <page_remove>
    assert(page_ref(p1) == 0);
ffffffffc0203210:	000a2783          	lw	a5,0(s4)
ffffffffc0203214:	76079463          	bnez	a5,ffffffffc020397c <pmm_init+0xa6c>
    assert(page_ref(p2) == 0);
ffffffffc0203218:	000aa783          	lw	a5,0(s5)
ffffffffc020321c:	74079063          	bnez	a5,ffffffffc020395c <pmm_init+0xa4c>

    assert(page_ref(pde2page(boot_pgdir[0])) == 1);
ffffffffc0203220:	00093a03          	ld	s4,0(s2)
    if (PPN(pa) >= npage) {
ffffffffc0203224:	6090                	ld	a2,0(s1)
    return pa2page(PDE_ADDR(pde));
ffffffffc0203226:	000a3783          	ld	a5,0(s4)
ffffffffc020322a:	078a                	slli	a5,a5,0x2
ffffffffc020322c:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage) {
ffffffffc020322e:	42c7f263          	bgeu	a5,a2,ffffffffc0203652 <pmm_init+0x742>
    return &pages[PPN(pa) - nbase];
ffffffffc0203232:	fff80737          	lui	a4,0xfff80
ffffffffc0203236:	973e                	add	a4,a4,a5
ffffffffc0203238:	00371793          	slli	a5,a4,0x3
ffffffffc020323c:	000b3503          	ld	a0,0(s6)
ffffffffc0203240:	97ba                	add	a5,a5,a4
ffffffffc0203242:	078e                	slli	a5,a5,0x3
static inline int page_ref(struct Page *page) { return page->ref; }
ffffffffc0203244:	00f50733          	add	a4,a0,a5
ffffffffc0203248:	4314                	lw	a3,0(a4)
ffffffffc020324a:	4705                	li	a4,1
ffffffffc020324c:	6ee69863          	bne	a3,a4,ffffffffc020393c <pmm_init+0xa2c>
static inline ppn_t page2ppn(struct Page *page) { return page - pages + nbase; }
ffffffffc0203250:	4037d693          	srai	a3,a5,0x3
ffffffffc0203254:	00003c97          	auipc	s9,0x3
ffffffffc0203258:	ff4cbc83          	ld	s9,-12(s9) # ffffffffc0206248 <error_string+0x38>
ffffffffc020325c:	039686b3          	mul	a3,a3,s9
ffffffffc0203260:	000805b7          	lui	a1,0x80
ffffffffc0203264:	96ae                	add	a3,a3,a1
static inline void *page2kva(struct Page *page) { return KADDR(page2pa(page)); }
ffffffffc0203266:	00c69713          	slli	a4,a3,0xc
ffffffffc020326a:	8331                	srli	a4,a4,0xc
    return page2ppn(page) << PGSHIFT;
ffffffffc020326c:	06b2                	slli	a3,a3,0xc
static inline void *page2kva(struct Page *page) { return KADDR(page2pa(page)); }
ffffffffc020326e:	6ac77b63          	bgeu	a4,a2,ffffffffc0203924 <pmm_init+0xa14>

    pde_t *pd1=boot_pgdir,*pd0=page2kva(pde2page(boot_pgdir[0]));
    free_page(pde2page(pd0[0]));
ffffffffc0203272:	0009b703          	ld	a4,0(s3)
ffffffffc0203276:	96ba                	add	a3,a3,a4
    return pa2page(PDE_ADDR(pde));
ffffffffc0203278:	629c                	ld	a5,0(a3)
ffffffffc020327a:	078a                	slli	a5,a5,0x2
ffffffffc020327c:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage) {
ffffffffc020327e:	3cc7fa63          	bgeu	a5,a2,ffffffffc0203652 <pmm_init+0x742>
    return &pages[PPN(pa) - nbase];
ffffffffc0203282:	8f8d                	sub	a5,a5,a1
ffffffffc0203284:	00379713          	slli	a4,a5,0x3
ffffffffc0203288:	97ba                	add	a5,a5,a4
ffffffffc020328a:	078e                	slli	a5,a5,0x3
ffffffffc020328c:	953e                	add	a0,a0,a5
ffffffffc020328e:	100027f3          	csrr	a5,sstatus
ffffffffc0203292:	8b89                	andi	a5,a5,2
ffffffffc0203294:	2e079963          	bnez	a5,ffffffffc0203586 <pmm_init+0x676>
    { pmm_manager->free_pages(base, n); }
ffffffffc0203298:	000bb783          	ld	a5,0(s7)
ffffffffc020329c:	4585                	li	a1,1
ffffffffc020329e:	739c                	ld	a5,32(a5)
ffffffffc02032a0:	9782                	jalr	a5
    return pa2page(PDE_ADDR(pde));
ffffffffc02032a2:	000a3783          	ld	a5,0(s4)
    if (PPN(pa) >= npage) {
ffffffffc02032a6:	6098                	ld	a4,0(s1)
    return pa2page(PDE_ADDR(pde));
ffffffffc02032a8:	078a                	slli	a5,a5,0x2
ffffffffc02032aa:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage) {
ffffffffc02032ac:	3ae7f363          	bgeu	a5,a4,ffffffffc0203652 <pmm_init+0x742>
    return &pages[PPN(pa) - nbase];
ffffffffc02032b0:	fff80737          	lui	a4,0xfff80
ffffffffc02032b4:	97ba                	add	a5,a5,a4
ffffffffc02032b6:	000b3503          	ld	a0,0(s6)
ffffffffc02032ba:	00379713          	slli	a4,a5,0x3
ffffffffc02032be:	97ba                	add	a5,a5,a4
ffffffffc02032c0:	078e                	slli	a5,a5,0x3
ffffffffc02032c2:	953e                	add	a0,a0,a5
ffffffffc02032c4:	100027f3          	csrr	a5,sstatus
ffffffffc02032c8:	8b89                	andi	a5,a5,2
ffffffffc02032ca:	2a079263          	bnez	a5,ffffffffc020356e <pmm_init+0x65e>
ffffffffc02032ce:	000bb783          	ld	a5,0(s7)
ffffffffc02032d2:	4585                	li	a1,1
ffffffffc02032d4:	739c                	ld	a5,32(a5)
ffffffffc02032d6:	9782                	jalr	a5
    free_page(pde2page(pd1[0]));
    boot_pgdir[0] = 0;
ffffffffc02032d8:	00093783          	ld	a5,0(s2)
ffffffffc02032dc:	0007b023          	sd	zero,0(a5) # fffffffffffff000 <end+0x3fdeda90>
ffffffffc02032e0:	100027f3          	csrr	a5,sstatus
ffffffffc02032e4:	8b89                	andi	a5,a5,2
ffffffffc02032e6:	26079a63          	bnez	a5,ffffffffc020355a <pmm_init+0x64a>
    { ret = pmm_manager->nr_free_pages(); }
ffffffffc02032ea:	000bb783          	ld	a5,0(s7)
ffffffffc02032ee:	779c                	ld	a5,40(a5)
ffffffffc02032f0:	9782                	jalr	a5
ffffffffc02032f2:	8a2a                	mv	s4,a0

    assert(nr_free_store==nr_free_pages());
ffffffffc02032f4:	73441463          	bne	s0,s4,ffffffffc0203a1c <pmm_init+0xb0c>

    cprintf("check_pgdir() succeeded!\n");
ffffffffc02032f8:	00003517          	auipc	a0,0x3
ffffffffc02032fc:	a8850513          	addi	a0,a0,-1400 # ffffffffc0205d80 <default_pmm_manager+0x4e8>
ffffffffc0203300:	dbbfc0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc0203304:	100027f3          	csrr	a5,sstatus
ffffffffc0203308:	8b89                	andi	a5,a5,2
ffffffffc020330a:	22079e63          	bnez	a5,ffffffffc0203546 <pmm_init+0x636>
    { ret = pmm_manager->nr_free_pages(); }
ffffffffc020330e:	000bb783          	ld	a5,0(s7)
ffffffffc0203312:	779c                	ld	a5,40(a5)
ffffffffc0203314:	9782                	jalr	a5
ffffffffc0203316:	8c2a                	mv	s8,a0
    pte_t *ptep;
    int i;

    nr_free_store=nr_free_pages();

    for (i = ROUNDDOWN(KERNBASE, PGSIZE); i < npage * PGSIZE; i += PGSIZE) {
ffffffffc0203318:	6098                	ld	a4,0(s1)
ffffffffc020331a:	c0200437          	lui	s0,0xc0200
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
        assert(PTE_ADDR(*ptep) == i);
ffffffffc020331e:	7afd                	lui	s5,0xfffff
    for (i = ROUNDDOWN(KERNBASE, PGSIZE); i < npage * PGSIZE; i += PGSIZE) {
ffffffffc0203320:	00c71793          	slli	a5,a4,0xc
ffffffffc0203324:	6a05                	lui	s4,0x1
ffffffffc0203326:	02f47c63          	bgeu	s0,a5,ffffffffc020335e <pmm_init+0x44e>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
ffffffffc020332a:	00c45793          	srli	a5,s0,0xc
ffffffffc020332e:	00093503          	ld	a0,0(s2)
ffffffffc0203332:	30e7f363          	bgeu	a5,a4,ffffffffc0203638 <pmm_init+0x728>
ffffffffc0203336:	0009b583          	ld	a1,0(s3)
ffffffffc020333a:	4601                	li	a2,0
ffffffffc020333c:	95a2                	add	a1,a1,s0
ffffffffc020333e:	fe8ff0ef          	jal	ra,ffffffffc0202b26 <get_pte>
ffffffffc0203342:	2c050b63          	beqz	a0,ffffffffc0203618 <pmm_init+0x708>
        assert(PTE_ADDR(*ptep) == i);
ffffffffc0203346:	611c                	ld	a5,0(a0)
ffffffffc0203348:	078a                	slli	a5,a5,0x2
ffffffffc020334a:	0157f7b3          	and	a5,a5,s5
ffffffffc020334e:	2a879563          	bne	a5,s0,ffffffffc02035f8 <pmm_init+0x6e8>
    for (i = ROUNDDOWN(KERNBASE, PGSIZE); i < npage * PGSIZE; i += PGSIZE) {
ffffffffc0203352:	6098                	ld	a4,0(s1)
ffffffffc0203354:	9452                	add	s0,s0,s4
ffffffffc0203356:	00c71793          	slli	a5,a4,0xc
ffffffffc020335a:	fcf468e3          	bltu	s0,a5,ffffffffc020332a <pmm_init+0x41a>
    }


    assert(boot_pgdir[0] == 0);
ffffffffc020335e:	00093783          	ld	a5,0(s2)
ffffffffc0203362:	639c                	ld	a5,0(a5)
ffffffffc0203364:	68079c63          	bnez	a5,ffffffffc02039fc <pmm_init+0xaec>

    struct Page *p;
    p = alloc_page();
ffffffffc0203368:	4505                	li	a0,1
ffffffffc020336a:	eb0ff0ef          	jal	ra,ffffffffc0202a1a <alloc_pages>
ffffffffc020336e:	8aaa                	mv	s5,a0
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W | PTE_R) == 0);
ffffffffc0203370:	00093503          	ld	a0,0(s2)
ffffffffc0203374:	4699                	li	a3,6
ffffffffc0203376:	10000613          	li	a2,256
ffffffffc020337a:	85d6                	mv	a1,s5
ffffffffc020337c:	a95ff0ef          	jal	ra,ffffffffc0202e10 <page_insert>
ffffffffc0203380:	64051e63          	bnez	a0,ffffffffc02039dc <pmm_init+0xacc>
    assert(page_ref(p) == 1);
ffffffffc0203384:	000aa703          	lw	a4,0(s5) # fffffffffffff000 <end+0x3fdeda90>
ffffffffc0203388:	4785                	li	a5,1
ffffffffc020338a:	62f71963          	bne	a4,a5,ffffffffc02039bc <pmm_init+0xaac>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W | PTE_R) == 0);
ffffffffc020338e:	00093503          	ld	a0,0(s2)
ffffffffc0203392:	6405                	lui	s0,0x1
ffffffffc0203394:	4699                	li	a3,6
ffffffffc0203396:	10040613          	addi	a2,s0,256 # 1100 <kern_entry-0xffffffffc01fef00>
ffffffffc020339a:	85d6                	mv	a1,s5
ffffffffc020339c:	a75ff0ef          	jal	ra,ffffffffc0202e10 <page_insert>
ffffffffc02033a0:	48051263          	bnez	a0,ffffffffc0203824 <pmm_init+0x914>
    assert(page_ref(p) == 2);
ffffffffc02033a4:	000aa703          	lw	a4,0(s5)
ffffffffc02033a8:	4789                	li	a5,2
ffffffffc02033aa:	74f71563          	bne	a4,a5,ffffffffc0203af4 <pmm_init+0xbe4>

    const char *str = "ucore: Hello world!!";
    strcpy((void *)0x100, str);
ffffffffc02033ae:	00003597          	auipc	a1,0x3
ffffffffc02033b2:	b0a58593          	addi	a1,a1,-1270 # ffffffffc0205eb8 <default_pmm_manager+0x620>
ffffffffc02033b6:	10000513          	li	a0,256
ffffffffc02033ba:	35d000ef          	jal	ra,ffffffffc0203f16 <strcpy>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
ffffffffc02033be:	10040593          	addi	a1,s0,256
ffffffffc02033c2:	10000513          	li	a0,256
ffffffffc02033c6:	363000ef          	jal	ra,ffffffffc0203f28 <strcmp>
ffffffffc02033ca:	70051563          	bnez	a0,ffffffffc0203ad4 <pmm_init+0xbc4>
static inline ppn_t page2ppn(struct Page *page) { return page - pages + nbase; }
ffffffffc02033ce:	000b3683          	ld	a3,0(s6)
ffffffffc02033d2:	00080d37          	lui	s10,0x80
static inline void *page2kva(struct Page *page) { return KADDR(page2pa(page)); }
ffffffffc02033d6:	547d                	li	s0,-1
static inline ppn_t page2ppn(struct Page *page) { return page - pages + nbase; }
ffffffffc02033d8:	40da86b3          	sub	a3,s5,a3
ffffffffc02033dc:	868d                	srai	a3,a3,0x3
ffffffffc02033de:	039686b3          	mul	a3,a3,s9
static inline void *page2kva(struct Page *page) { return KADDR(page2pa(page)); }
ffffffffc02033e2:	609c                	ld	a5,0(s1)
ffffffffc02033e4:	8031                	srli	s0,s0,0xc
static inline ppn_t page2ppn(struct Page *page) { return page - pages + nbase; }
ffffffffc02033e6:	96ea                	add	a3,a3,s10
static inline void *page2kva(struct Page *page) { return KADDR(page2pa(page)); }
ffffffffc02033e8:	0086f733          	and	a4,a3,s0
    return page2ppn(page) << PGSHIFT;
ffffffffc02033ec:	06b2                	slli	a3,a3,0xc
static inline void *page2kva(struct Page *page) { return KADDR(page2pa(page)); }
ffffffffc02033ee:	52f77b63          	bgeu	a4,a5,ffffffffc0203924 <pmm_init+0xa14>

    *(char *)(page2kva(p) + 0x100) = '\0';
ffffffffc02033f2:	0009b783          	ld	a5,0(s3)
    assert(strlen((const char *)0x100) == 0);
ffffffffc02033f6:	10000513          	li	a0,256
    *(char *)(page2kva(p) + 0x100) = '\0';
ffffffffc02033fa:	96be                	add	a3,a3,a5
ffffffffc02033fc:	10068023          	sb	zero,256(a3) # fffffffffff80100 <end+0x3fd6eb90>
    assert(strlen((const char *)0x100) == 0);
ffffffffc0203400:	2e1000ef          	jal	ra,ffffffffc0203ee0 <strlen>
ffffffffc0203404:	6a051863          	bnez	a0,ffffffffc0203ab4 <pmm_init+0xba4>

    pde_t *pd1=boot_pgdir,*pd0=page2kva(pde2page(boot_pgdir[0]));
ffffffffc0203408:	00093a03          	ld	s4,0(s2)
    if (PPN(pa) >= npage) {
ffffffffc020340c:	6098                	ld	a4,0(s1)
    return pa2page(PDE_ADDR(pde));
ffffffffc020340e:	000a3783          	ld	a5,0(s4) # 1000 <kern_entry-0xffffffffc01ff000>
ffffffffc0203412:	078a                	slli	a5,a5,0x2
ffffffffc0203414:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage) {
ffffffffc0203416:	22e7fe63          	bgeu	a5,a4,ffffffffc0203652 <pmm_init+0x742>
    return &pages[PPN(pa) - nbase];
ffffffffc020341a:	41a787b3          	sub	a5,a5,s10
ffffffffc020341e:	00379693          	slli	a3,a5,0x3
static inline ppn_t page2ppn(struct Page *page) { return page - pages + nbase; }
ffffffffc0203422:	96be                	add	a3,a3,a5
ffffffffc0203424:	03968cb3          	mul	s9,a3,s9
ffffffffc0203428:	01ac86b3          	add	a3,s9,s10
static inline void *page2kva(struct Page *page) { return KADDR(page2pa(page)); }
ffffffffc020342c:	8c75                	and	s0,s0,a3
    return page2ppn(page) << PGSHIFT;
ffffffffc020342e:	06b2                	slli	a3,a3,0xc
static inline void *page2kva(struct Page *page) { return KADDR(page2pa(page)); }
ffffffffc0203430:	4ee47a63          	bgeu	s0,a4,ffffffffc0203924 <pmm_init+0xa14>
ffffffffc0203434:	0009b403          	ld	s0,0(s3)
ffffffffc0203438:	9436                	add	s0,s0,a3
ffffffffc020343a:	100027f3          	csrr	a5,sstatus
ffffffffc020343e:	8b89                	andi	a5,a5,2
ffffffffc0203440:	1a079163          	bnez	a5,ffffffffc02035e2 <pmm_init+0x6d2>
    { pmm_manager->free_pages(base, n); }
ffffffffc0203444:	000bb783          	ld	a5,0(s7)
ffffffffc0203448:	4585                	li	a1,1
ffffffffc020344a:	8556                	mv	a0,s5
ffffffffc020344c:	739c                	ld	a5,32(a5)
ffffffffc020344e:	9782                	jalr	a5
    return pa2page(PDE_ADDR(pde));
ffffffffc0203450:	601c                	ld	a5,0(s0)
    if (PPN(pa) >= npage) {
ffffffffc0203452:	6098                	ld	a4,0(s1)
    return pa2page(PDE_ADDR(pde));
ffffffffc0203454:	078a                	slli	a5,a5,0x2
ffffffffc0203456:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage) {
ffffffffc0203458:	1ee7fd63          	bgeu	a5,a4,ffffffffc0203652 <pmm_init+0x742>
    return &pages[PPN(pa) - nbase];
ffffffffc020345c:	fff80737          	lui	a4,0xfff80
ffffffffc0203460:	97ba                	add	a5,a5,a4
ffffffffc0203462:	000b3503          	ld	a0,0(s6)
ffffffffc0203466:	00379713          	slli	a4,a5,0x3
ffffffffc020346a:	97ba                	add	a5,a5,a4
ffffffffc020346c:	078e                	slli	a5,a5,0x3
ffffffffc020346e:	953e                	add	a0,a0,a5
ffffffffc0203470:	100027f3          	csrr	a5,sstatus
ffffffffc0203474:	8b89                	andi	a5,a5,2
ffffffffc0203476:	14079a63          	bnez	a5,ffffffffc02035ca <pmm_init+0x6ba>
ffffffffc020347a:	000bb783          	ld	a5,0(s7)
ffffffffc020347e:	4585                	li	a1,1
ffffffffc0203480:	739c                	ld	a5,32(a5)
ffffffffc0203482:	9782                	jalr	a5
    return pa2page(PDE_ADDR(pde));
ffffffffc0203484:	000a3783          	ld	a5,0(s4)
    if (PPN(pa) >= npage) {
ffffffffc0203488:	6098                	ld	a4,0(s1)
    return pa2page(PDE_ADDR(pde));
ffffffffc020348a:	078a                	slli	a5,a5,0x2
ffffffffc020348c:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage) {
ffffffffc020348e:	1ce7f263          	bgeu	a5,a4,ffffffffc0203652 <pmm_init+0x742>
    return &pages[PPN(pa) - nbase];
ffffffffc0203492:	fff80737          	lui	a4,0xfff80
ffffffffc0203496:	97ba                	add	a5,a5,a4
ffffffffc0203498:	000b3503          	ld	a0,0(s6)
ffffffffc020349c:	00379713          	slli	a4,a5,0x3
ffffffffc02034a0:	97ba                	add	a5,a5,a4
ffffffffc02034a2:	078e                	slli	a5,a5,0x3
ffffffffc02034a4:	953e                	add	a0,a0,a5
ffffffffc02034a6:	100027f3          	csrr	a5,sstatus
ffffffffc02034aa:	8b89                	andi	a5,a5,2
ffffffffc02034ac:	10079363          	bnez	a5,ffffffffc02035b2 <pmm_init+0x6a2>
ffffffffc02034b0:	000bb783          	ld	a5,0(s7)
ffffffffc02034b4:	4585                	li	a1,1
ffffffffc02034b6:	739c                	ld	a5,32(a5)
ffffffffc02034b8:	9782                	jalr	a5
    free_page(p);
    free_page(pde2page(pd0[0]));
    free_page(pde2page(pd1[0]));
    boot_pgdir[0] = 0;
ffffffffc02034ba:	00093783          	ld	a5,0(s2)
ffffffffc02034be:	0007b023          	sd	zero,0(a5)
ffffffffc02034c2:	100027f3          	csrr	a5,sstatus
ffffffffc02034c6:	8b89                	andi	a5,a5,2
ffffffffc02034c8:	0c079b63          	bnez	a5,ffffffffc020359e <pmm_init+0x68e>
    { ret = pmm_manager->nr_free_pages(); }
ffffffffc02034cc:	000bb783          	ld	a5,0(s7)
ffffffffc02034d0:	779c                	ld	a5,40(a5)
ffffffffc02034d2:	9782                	jalr	a5
ffffffffc02034d4:	842a                	mv	s0,a0

    assert(nr_free_store==nr_free_pages());
ffffffffc02034d6:	3a8c1763          	bne	s8,s0,ffffffffc0203884 <pmm_init+0x974>
}
ffffffffc02034da:	7406                	ld	s0,96(sp)
ffffffffc02034dc:	70a6                	ld	ra,104(sp)
ffffffffc02034de:	64e6                	ld	s1,88(sp)
ffffffffc02034e0:	6946                	ld	s2,80(sp)
ffffffffc02034e2:	69a6                	ld	s3,72(sp)
ffffffffc02034e4:	6a06                	ld	s4,64(sp)
ffffffffc02034e6:	7ae2                	ld	s5,56(sp)
ffffffffc02034e8:	7b42                	ld	s6,48(sp)
ffffffffc02034ea:	7ba2                	ld	s7,40(sp)
ffffffffc02034ec:	7c02                	ld	s8,32(sp)
ffffffffc02034ee:	6ce2                	ld	s9,24(sp)
ffffffffc02034f0:	6d42                	ld	s10,16(sp)

    cprintf("check_boot_pgdir() succeeded!\n");
ffffffffc02034f2:	00003517          	auipc	a0,0x3
ffffffffc02034f6:	a3e50513          	addi	a0,a0,-1474 # ffffffffc0205f30 <default_pmm_manager+0x698>
}
ffffffffc02034fa:	6165                	addi	sp,sp,112
    cprintf("check_boot_pgdir() succeeded!\n");
ffffffffc02034fc:	bbffc06f          	j	ffffffffc02000ba <cprintf>
    mem_begin = ROUNDUP(freemem, PGSIZE);
ffffffffc0203500:	6705                	lui	a4,0x1
ffffffffc0203502:	177d                	addi	a4,a4,-1
ffffffffc0203504:	96ba                	add	a3,a3,a4
ffffffffc0203506:	777d                	lui	a4,0xfffff
ffffffffc0203508:	8f75                	and	a4,a4,a3
    if (PPN(pa) >= npage) {
ffffffffc020350a:	00c75693          	srli	a3,a4,0xc
ffffffffc020350e:	14f6f263          	bgeu	a3,a5,ffffffffc0203652 <pmm_init+0x742>
    pmm_manager->init_memmap(base, n);
ffffffffc0203512:	000bb803          	ld	a6,0(s7)
    return &pages[PPN(pa) - nbase];
ffffffffc0203516:	95b6                	add	a1,a1,a3
ffffffffc0203518:	00359793          	slli	a5,a1,0x3
ffffffffc020351c:	97ae                	add	a5,a5,a1
ffffffffc020351e:	01083683          	ld	a3,16(a6)
        init_memmap(pa2page(mem_begin), (mem_end - mem_begin) / PGSIZE);
ffffffffc0203522:	40e60733          	sub	a4,a2,a4
ffffffffc0203526:	078e                	slli	a5,a5,0x3
    pmm_manager->init_memmap(base, n);
ffffffffc0203528:	00c75593          	srli	a1,a4,0xc
ffffffffc020352c:	953e                	add	a0,a0,a5
ffffffffc020352e:	9682                	jalr	a3
}
ffffffffc0203530:	bcc5                	j	ffffffffc0203020 <pmm_init+0x110>
        intr_disable();
ffffffffc0203532:	fbdfc0ef          	jal	ra,ffffffffc02004ee <intr_disable>
    { ret = pmm_manager->nr_free_pages(); }
ffffffffc0203536:	000bb783          	ld	a5,0(s7)
ffffffffc020353a:	779c                	ld	a5,40(a5)
ffffffffc020353c:	9782                	jalr	a5
ffffffffc020353e:	842a                	mv	s0,a0
        intr_enable();
ffffffffc0203540:	fa9fc0ef          	jal	ra,ffffffffc02004e8 <intr_enable>
ffffffffc0203544:	b63d                	j	ffffffffc0203072 <pmm_init+0x162>
        intr_disable();
ffffffffc0203546:	fa9fc0ef          	jal	ra,ffffffffc02004ee <intr_disable>
ffffffffc020354a:	000bb783          	ld	a5,0(s7)
ffffffffc020354e:	779c                	ld	a5,40(a5)
ffffffffc0203550:	9782                	jalr	a5
ffffffffc0203552:	8c2a                	mv	s8,a0
        intr_enable();
ffffffffc0203554:	f95fc0ef          	jal	ra,ffffffffc02004e8 <intr_enable>
ffffffffc0203558:	b3c1                	j	ffffffffc0203318 <pmm_init+0x408>
        intr_disable();
ffffffffc020355a:	f95fc0ef          	jal	ra,ffffffffc02004ee <intr_disable>
ffffffffc020355e:	000bb783          	ld	a5,0(s7)
ffffffffc0203562:	779c                	ld	a5,40(a5)
ffffffffc0203564:	9782                	jalr	a5
ffffffffc0203566:	8a2a                	mv	s4,a0
        intr_enable();
ffffffffc0203568:	f81fc0ef          	jal	ra,ffffffffc02004e8 <intr_enable>
ffffffffc020356c:	b361                	j	ffffffffc02032f4 <pmm_init+0x3e4>
ffffffffc020356e:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc0203570:	f7ffc0ef          	jal	ra,ffffffffc02004ee <intr_disable>
    { pmm_manager->free_pages(base, n); }
ffffffffc0203574:	000bb783          	ld	a5,0(s7)
ffffffffc0203578:	6522                	ld	a0,8(sp)
ffffffffc020357a:	4585                	li	a1,1
ffffffffc020357c:	739c                	ld	a5,32(a5)
ffffffffc020357e:	9782                	jalr	a5
        intr_enable();
ffffffffc0203580:	f69fc0ef          	jal	ra,ffffffffc02004e8 <intr_enable>
ffffffffc0203584:	bb91                	j	ffffffffc02032d8 <pmm_init+0x3c8>
ffffffffc0203586:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc0203588:	f67fc0ef          	jal	ra,ffffffffc02004ee <intr_disable>
ffffffffc020358c:	000bb783          	ld	a5,0(s7)
ffffffffc0203590:	6522                	ld	a0,8(sp)
ffffffffc0203592:	4585                	li	a1,1
ffffffffc0203594:	739c                	ld	a5,32(a5)
ffffffffc0203596:	9782                	jalr	a5
        intr_enable();
ffffffffc0203598:	f51fc0ef          	jal	ra,ffffffffc02004e8 <intr_enable>
ffffffffc020359c:	b319                	j	ffffffffc02032a2 <pmm_init+0x392>
        intr_disable();
ffffffffc020359e:	f51fc0ef          	jal	ra,ffffffffc02004ee <intr_disable>
    { ret = pmm_manager->nr_free_pages(); }
ffffffffc02035a2:	000bb783          	ld	a5,0(s7)
ffffffffc02035a6:	779c                	ld	a5,40(a5)
ffffffffc02035a8:	9782                	jalr	a5
ffffffffc02035aa:	842a                	mv	s0,a0
        intr_enable();
ffffffffc02035ac:	f3dfc0ef          	jal	ra,ffffffffc02004e8 <intr_enable>
ffffffffc02035b0:	b71d                	j	ffffffffc02034d6 <pmm_init+0x5c6>
ffffffffc02035b2:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc02035b4:	f3bfc0ef          	jal	ra,ffffffffc02004ee <intr_disable>
    { pmm_manager->free_pages(base, n); }
ffffffffc02035b8:	000bb783          	ld	a5,0(s7)
ffffffffc02035bc:	6522                	ld	a0,8(sp)
ffffffffc02035be:	4585                	li	a1,1
ffffffffc02035c0:	739c                	ld	a5,32(a5)
ffffffffc02035c2:	9782                	jalr	a5
        intr_enable();
ffffffffc02035c4:	f25fc0ef          	jal	ra,ffffffffc02004e8 <intr_enable>
ffffffffc02035c8:	bdcd                	j	ffffffffc02034ba <pmm_init+0x5aa>
ffffffffc02035ca:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc02035cc:	f23fc0ef          	jal	ra,ffffffffc02004ee <intr_disable>
ffffffffc02035d0:	000bb783          	ld	a5,0(s7)
ffffffffc02035d4:	6522                	ld	a0,8(sp)
ffffffffc02035d6:	4585                	li	a1,1
ffffffffc02035d8:	739c                	ld	a5,32(a5)
ffffffffc02035da:	9782                	jalr	a5
        intr_enable();
ffffffffc02035dc:	f0dfc0ef          	jal	ra,ffffffffc02004e8 <intr_enable>
ffffffffc02035e0:	b555                	j	ffffffffc0203484 <pmm_init+0x574>
        intr_disable();
ffffffffc02035e2:	f0dfc0ef          	jal	ra,ffffffffc02004ee <intr_disable>
ffffffffc02035e6:	000bb783          	ld	a5,0(s7)
ffffffffc02035ea:	4585                	li	a1,1
ffffffffc02035ec:	8556                	mv	a0,s5
ffffffffc02035ee:	739c                	ld	a5,32(a5)
ffffffffc02035f0:	9782                	jalr	a5
        intr_enable();
ffffffffc02035f2:	ef7fc0ef          	jal	ra,ffffffffc02004e8 <intr_enable>
ffffffffc02035f6:	bda9                	j	ffffffffc0203450 <pmm_init+0x540>
        assert(PTE_ADDR(*ptep) == i);
ffffffffc02035f8:	00002697          	auipc	a3,0x2
ffffffffc02035fc:	7e868693          	addi	a3,a3,2024 # ffffffffc0205de0 <default_pmm_manager+0x548>
ffffffffc0203600:	00001617          	auipc	a2,0x1
ffffffffc0203604:	7c860613          	addi	a2,a2,1992 # ffffffffc0204dc8 <commands+0x728>
ffffffffc0203608:	1ce00593          	li	a1,462
ffffffffc020360c:	00002517          	auipc	a0,0x2
ffffffffc0203610:	3cc50513          	addi	a0,a0,972 # ffffffffc02059d8 <default_pmm_manager+0x140>
ffffffffc0203614:	aeffc0ef          	jal	ra,ffffffffc0200102 <__panic>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
ffffffffc0203618:	00002697          	auipc	a3,0x2
ffffffffc020361c:	78868693          	addi	a3,a3,1928 # ffffffffc0205da0 <default_pmm_manager+0x508>
ffffffffc0203620:	00001617          	auipc	a2,0x1
ffffffffc0203624:	7a860613          	addi	a2,a2,1960 # ffffffffc0204dc8 <commands+0x728>
ffffffffc0203628:	1cd00593          	li	a1,461
ffffffffc020362c:	00002517          	auipc	a0,0x2
ffffffffc0203630:	3ac50513          	addi	a0,a0,940 # ffffffffc02059d8 <default_pmm_manager+0x140>
ffffffffc0203634:	acffc0ef          	jal	ra,ffffffffc0200102 <__panic>
ffffffffc0203638:	86a2                	mv	a3,s0
ffffffffc020363a:	00002617          	auipc	a2,0x2
ffffffffc020363e:	37660613          	addi	a2,a2,886 # ffffffffc02059b0 <default_pmm_manager+0x118>
ffffffffc0203642:	1cd00593          	li	a1,461
ffffffffc0203646:	00002517          	auipc	a0,0x2
ffffffffc020364a:	39250513          	addi	a0,a0,914 # ffffffffc02059d8 <default_pmm_manager+0x140>
ffffffffc020364e:	ab5fc0ef          	jal	ra,ffffffffc0200102 <__panic>
ffffffffc0203652:	b90ff0ef          	jal	ra,ffffffffc02029e2 <pa2page.part.0>
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc0203656:	00002617          	auipc	a2,0x2
ffffffffc020365a:	41a60613          	addi	a2,a2,1050 # ffffffffc0205a70 <default_pmm_manager+0x1d8>
ffffffffc020365e:	07700593          	li	a1,119
ffffffffc0203662:	00002517          	auipc	a0,0x2
ffffffffc0203666:	37650513          	addi	a0,a0,886 # ffffffffc02059d8 <default_pmm_manager+0x140>
ffffffffc020366a:	a99fc0ef          	jal	ra,ffffffffc0200102 <__panic>
    boot_cr3 = PADDR(boot_pgdir);
ffffffffc020366e:	00002617          	auipc	a2,0x2
ffffffffc0203672:	40260613          	addi	a2,a2,1026 # ffffffffc0205a70 <default_pmm_manager+0x1d8>
ffffffffc0203676:	0bd00593          	li	a1,189
ffffffffc020367a:	00002517          	auipc	a0,0x2
ffffffffc020367e:	35e50513          	addi	a0,a0,862 # ffffffffc02059d8 <default_pmm_manager+0x140>
ffffffffc0203682:	a81fc0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(boot_pgdir != NULL && (uint32_t)PGOFF(boot_pgdir) == 0);
ffffffffc0203686:	00002697          	auipc	a3,0x2
ffffffffc020368a:	45268693          	addi	a3,a3,1106 # ffffffffc0205ad8 <default_pmm_manager+0x240>
ffffffffc020368e:	00001617          	auipc	a2,0x1
ffffffffc0203692:	73a60613          	addi	a2,a2,1850 # ffffffffc0204dc8 <commands+0x728>
ffffffffc0203696:	19300593          	li	a1,403
ffffffffc020369a:	00002517          	auipc	a0,0x2
ffffffffc020369e:	33e50513          	addi	a0,a0,830 # ffffffffc02059d8 <default_pmm_manager+0x140>
ffffffffc02036a2:	a61fc0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(npage <= KERNTOP / PGSIZE);
ffffffffc02036a6:	00002697          	auipc	a3,0x2
ffffffffc02036aa:	41268693          	addi	a3,a3,1042 # ffffffffc0205ab8 <default_pmm_manager+0x220>
ffffffffc02036ae:	00001617          	auipc	a2,0x1
ffffffffc02036b2:	71a60613          	addi	a2,a2,1818 # ffffffffc0204dc8 <commands+0x728>
ffffffffc02036b6:	19200593          	li	a1,402
ffffffffc02036ba:	00002517          	auipc	a0,0x2
ffffffffc02036be:	31e50513          	addi	a0,a0,798 # ffffffffc02059d8 <default_pmm_manager+0x140>
ffffffffc02036c2:	a41fc0ef          	jal	ra,ffffffffc0200102 <__panic>
ffffffffc02036c6:	b38ff0ef          	jal	ra,ffffffffc02029fe <pte2page.part.0>
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
ffffffffc02036ca:	00002697          	auipc	a3,0x2
ffffffffc02036ce:	49e68693          	addi	a3,a3,1182 # ffffffffc0205b68 <default_pmm_manager+0x2d0>
ffffffffc02036d2:	00001617          	auipc	a2,0x1
ffffffffc02036d6:	6f660613          	addi	a2,a2,1782 # ffffffffc0204dc8 <commands+0x728>
ffffffffc02036da:	19a00593          	li	a1,410
ffffffffc02036de:	00002517          	auipc	a0,0x2
ffffffffc02036e2:	2fa50513          	addi	a0,a0,762 # ffffffffc02059d8 <default_pmm_manager+0x140>
ffffffffc02036e6:	a1dfc0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
ffffffffc02036ea:	00002697          	auipc	a3,0x2
ffffffffc02036ee:	44e68693          	addi	a3,a3,1102 # ffffffffc0205b38 <default_pmm_manager+0x2a0>
ffffffffc02036f2:	00001617          	auipc	a2,0x1
ffffffffc02036f6:	6d660613          	addi	a2,a2,1750 # ffffffffc0204dc8 <commands+0x728>
ffffffffc02036fa:	19800593          	li	a1,408
ffffffffc02036fe:	00002517          	auipc	a0,0x2
ffffffffc0203702:	2da50513          	addi	a0,a0,730 # ffffffffc02059d8 <default_pmm_manager+0x140>
ffffffffc0203706:	9fdfc0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
ffffffffc020370a:	00002697          	auipc	a3,0x2
ffffffffc020370e:	40668693          	addi	a3,a3,1030 # ffffffffc0205b10 <default_pmm_manager+0x278>
ffffffffc0203712:	00001617          	auipc	a2,0x1
ffffffffc0203716:	6b660613          	addi	a2,a2,1718 # ffffffffc0204dc8 <commands+0x728>
ffffffffc020371a:	19400593          	li	a1,404
ffffffffc020371e:	00002517          	auipc	a0,0x2
ffffffffc0203722:	2ba50513          	addi	a0,a0,698 # ffffffffc02059d8 <default_pmm_manager+0x140>
ffffffffc0203726:	9ddfc0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
ffffffffc020372a:	00002697          	auipc	a3,0x2
ffffffffc020372e:	4c668693          	addi	a3,a3,1222 # ffffffffc0205bf0 <default_pmm_manager+0x358>
ffffffffc0203732:	00001617          	auipc	a2,0x1
ffffffffc0203736:	69660613          	addi	a2,a2,1686 # ffffffffc0204dc8 <commands+0x728>
ffffffffc020373a:	1a300593          	li	a1,419
ffffffffc020373e:	00002517          	auipc	a0,0x2
ffffffffc0203742:	29a50513          	addi	a0,a0,666 # ffffffffc02059d8 <default_pmm_manager+0x140>
ffffffffc0203746:	9bdfc0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(page_ref(p2) == 1);
ffffffffc020374a:	00002697          	auipc	a3,0x2
ffffffffc020374e:	54668693          	addi	a3,a3,1350 # ffffffffc0205c90 <default_pmm_manager+0x3f8>
ffffffffc0203752:	00001617          	auipc	a2,0x1
ffffffffc0203756:	67660613          	addi	a2,a2,1654 # ffffffffc0204dc8 <commands+0x728>
ffffffffc020375a:	1a800593          	li	a1,424
ffffffffc020375e:	00002517          	auipc	a0,0x2
ffffffffc0203762:	27a50513          	addi	a0,a0,634 # ffffffffc02059d8 <default_pmm_manager+0x140>
ffffffffc0203766:	99dfc0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
ffffffffc020376a:	00002697          	auipc	a3,0x2
ffffffffc020376e:	45e68693          	addi	a3,a3,1118 # ffffffffc0205bc8 <default_pmm_manager+0x330>
ffffffffc0203772:	00001617          	auipc	a2,0x1
ffffffffc0203776:	65660613          	addi	a2,a2,1622 # ffffffffc0204dc8 <commands+0x728>
ffffffffc020377a:	1a000593          	li	a1,416
ffffffffc020377e:	00002517          	auipc	a0,0x2
ffffffffc0203782:	25a50513          	addi	a0,a0,602 # ffffffffc02059d8 <default_pmm_manager+0x140>
ffffffffc0203786:	97dfc0ef          	jal	ra,ffffffffc0200102 <__panic>
    ptep = (pte_t *)KADDR(PDE_ADDR(ptep[0])) + 1;
ffffffffc020378a:	86d6                	mv	a3,s5
ffffffffc020378c:	00002617          	auipc	a2,0x2
ffffffffc0203790:	22460613          	addi	a2,a2,548 # ffffffffc02059b0 <default_pmm_manager+0x118>
ffffffffc0203794:	19f00593          	li	a1,415
ffffffffc0203798:	00002517          	auipc	a0,0x2
ffffffffc020379c:	24050513          	addi	a0,a0,576 # ffffffffc02059d8 <default_pmm_manager+0x140>
ffffffffc02037a0:	963fc0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
ffffffffc02037a4:	00002697          	auipc	a3,0x2
ffffffffc02037a8:	48468693          	addi	a3,a3,1156 # ffffffffc0205c28 <default_pmm_manager+0x390>
ffffffffc02037ac:	00001617          	auipc	a2,0x1
ffffffffc02037b0:	61c60613          	addi	a2,a2,1564 # ffffffffc0204dc8 <commands+0x728>
ffffffffc02037b4:	1ad00593          	li	a1,429
ffffffffc02037b8:	00002517          	auipc	a0,0x2
ffffffffc02037bc:	22050513          	addi	a0,a0,544 # ffffffffc02059d8 <default_pmm_manager+0x140>
ffffffffc02037c0:	943fc0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(page_ref(p2) == 0);
ffffffffc02037c4:	00002697          	auipc	a3,0x2
ffffffffc02037c8:	52c68693          	addi	a3,a3,1324 # ffffffffc0205cf0 <default_pmm_manager+0x458>
ffffffffc02037cc:	00001617          	auipc	a2,0x1
ffffffffc02037d0:	5fc60613          	addi	a2,a2,1532 # ffffffffc0204dc8 <commands+0x728>
ffffffffc02037d4:	1ac00593          	li	a1,428
ffffffffc02037d8:	00002517          	auipc	a0,0x2
ffffffffc02037dc:	20050513          	addi	a0,a0,512 # ffffffffc02059d8 <default_pmm_manager+0x140>
ffffffffc02037e0:	923fc0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(page_ref(p1) == 2);
ffffffffc02037e4:	00002697          	auipc	a3,0x2
ffffffffc02037e8:	4f468693          	addi	a3,a3,1268 # ffffffffc0205cd8 <default_pmm_manager+0x440>
ffffffffc02037ec:	00001617          	auipc	a2,0x1
ffffffffc02037f0:	5dc60613          	addi	a2,a2,1500 # ffffffffc0204dc8 <commands+0x728>
ffffffffc02037f4:	1ab00593          	li	a1,427
ffffffffc02037f8:	00002517          	auipc	a0,0x2
ffffffffc02037fc:	1e050513          	addi	a0,a0,480 # ffffffffc02059d8 <default_pmm_manager+0x140>
ffffffffc0203800:	903fc0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
ffffffffc0203804:	00002697          	auipc	a3,0x2
ffffffffc0203808:	4a468693          	addi	a3,a3,1188 # ffffffffc0205ca8 <default_pmm_manager+0x410>
ffffffffc020380c:	00001617          	auipc	a2,0x1
ffffffffc0203810:	5bc60613          	addi	a2,a2,1468 # ffffffffc0204dc8 <commands+0x728>
ffffffffc0203814:	1aa00593          	li	a1,426
ffffffffc0203818:	00002517          	auipc	a0,0x2
ffffffffc020381c:	1c050513          	addi	a0,a0,448 # ffffffffc02059d8 <default_pmm_manager+0x140>
ffffffffc0203820:	8e3fc0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W | PTE_R) == 0);
ffffffffc0203824:	00002697          	auipc	a3,0x2
ffffffffc0203828:	63c68693          	addi	a3,a3,1596 # ffffffffc0205e60 <default_pmm_manager+0x5c8>
ffffffffc020382c:	00001617          	auipc	a2,0x1
ffffffffc0203830:	59c60613          	addi	a2,a2,1436 # ffffffffc0204dc8 <commands+0x728>
ffffffffc0203834:	1d800593          	li	a1,472
ffffffffc0203838:	00002517          	auipc	a0,0x2
ffffffffc020383c:	1a050513          	addi	a0,a0,416 # ffffffffc02059d8 <default_pmm_manager+0x140>
ffffffffc0203840:	8c3fc0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(boot_pgdir[0] & PTE_U);
ffffffffc0203844:	00002697          	auipc	a3,0x2
ffffffffc0203848:	43468693          	addi	a3,a3,1076 # ffffffffc0205c78 <default_pmm_manager+0x3e0>
ffffffffc020384c:	00001617          	auipc	a2,0x1
ffffffffc0203850:	57c60613          	addi	a2,a2,1404 # ffffffffc0204dc8 <commands+0x728>
ffffffffc0203854:	1a700593          	li	a1,423
ffffffffc0203858:	00002517          	auipc	a0,0x2
ffffffffc020385c:	18050513          	addi	a0,a0,384 # ffffffffc02059d8 <default_pmm_manager+0x140>
ffffffffc0203860:	8a3fc0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(*ptep & PTE_W);
ffffffffc0203864:	00002697          	auipc	a3,0x2
ffffffffc0203868:	40468693          	addi	a3,a3,1028 # ffffffffc0205c68 <default_pmm_manager+0x3d0>
ffffffffc020386c:	00001617          	auipc	a2,0x1
ffffffffc0203870:	55c60613          	addi	a2,a2,1372 # ffffffffc0204dc8 <commands+0x728>
ffffffffc0203874:	1a600593          	li	a1,422
ffffffffc0203878:	00002517          	auipc	a0,0x2
ffffffffc020387c:	16050513          	addi	a0,a0,352 # ffffffffc02059d8 <default_pmm_manager+0x140>
ffffffffc0203880:	883fc0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(nr_free_store==nr_free_pages());
ffffffffc0203884:	00002697          	auipc	a3,0x2
ffffffffc0203888:	4dc68693          	addi	a3,a3,1244 # ffffffffc0205d60 <default_pmm_manager+0x4c8>
ffffffffc020388c:	00001617          	auipc	a2,0x1
ffffffffc0203890:	53c60613          	addi	a2,a2,1340 # ffffffffc0204dc8 <commands+0x728>
ffffffffc0203894:	1e800593          	li	a1,488
ffffffffc0203898:	00002517          	auipc	a0,0x2
ffffffffc020389c:	14050513          	addi	a0,a0,320 # ffffffffc02059d8 <default_pmm_manager+0x140>
ffffffffc02038a0:	863fc0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(*ptep & PTE_U);
ffffffffc02038a4:	00002697          	auipc	a3,0x2
ffffffffc02038a8:	3b468693          	addi	a3,a3,948 # ffffffffc0205c58 <default_pmm_manager+0x3c0>
ffffffffc02038ac:	00001617          	auipc	a2,0x1
ffffffffc02038b0:	51c60613          	addi	a2,a2,1308 # ffffffffc0204dc8 <commands+0x728>
ffffffffc02038b4:	1a500593          	li	a1,421
ffffffffc02038b8:	00002517          	auipc	a0,0x2
ffffffffc02038bc:	12050513          	addi	a0,a0,288 # ffffffffc02059d8 <default_pmm_manager+0x140>
ffffffffc02038c0:	843fc0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(page_ref(p1) == 1);
ffffffffc02038c4:	00002697          	auipc	a3,0x2
ffffffffc02038c8:	2ec68693          	addi	a3,a3,748 # ffffffffc0205bb0 <default_pmm_manager+0x318>
ffffffffc02038cc:	00001617          	auipc	a2,0x1
ffffffffc02038d0:	4fc60613          	addi	a2,a2,1276 # ffffffffc0204dc8 <commands+0x728>
ffffffffc02038d4:	1b200593          	li	a1,434
ffffffffc02038d8:	00002517          	auipc	a0,0x2
ffffffffc02038dc:	10050513          	addi	a0,a0,256 # ffffffffc02059d8 <default_pmm_manager+0x140>
ffffffffc02038e0:	823fc0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert((*ptep & PTE_U) == 0);
ffffffffc02038e4:	00002697          	auipc	a3,0x2
ffffffffc02038e8:	42468693          	addi	a3,a3,1060 # ffffffffc0205d08 <default_pmm_manager+0x470>
ffffffffc02038ec:	00001617          	auipc	a2,0x1
ffffffffc02038f0:	4dc60613          	addi	a2,a2,1244 # ffffffffc0204dc8 <commands+0x728>
ffffffffc02038f4:	1af00593          	li	a1,431
ffffffffc02038f8:	00002517          	auipc	a0,0x2
ffffffffc02038fc:	0e050513          	addi	a0,a0,224 # ffffffffc02059d8 <default_pmm_manager+0x140>
ffffffffc0203900:	803fc0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(pte2page(*ptep) == p1);
ffffffffc0203904:	00002697          	auipc	a3,0x2
ffffffffc0203908:	29468693          	addi	a3,a3,660 # ffffffffc0205b98 <default_pmm_manager+0x300>
ffffffffc020390c:	00001617          	auipc	a2,0x1
ffffffffc0203910:	4bc60613          	addi	a2,a2,1212 # ffffffffc0204dc8 <commands+0x728>
ffffffffc0203914:	1ae00593          	li	a1,430
ffffffffc0203918:	00002517          	auipc	a0,0x2
ffffffffc020391c:	0c050513          	addi	a0,a0,192 # ffffffffc02059d8 <default_pmm_manager+0x140>
ffffffffc0203920:	fe2fc0ef          	jal	ra,ffffffffc0200102 <__panic>
static inline void *page2kva(struct Page *page) { return KADDR(page2pa(page)); }
ffffffffc0203924:	00002617          	auipc	a2,0x2
ffffffffc0203928:	08c60613          	addi	a2,a2,140 # ffffffffc02059b0 <default_pmm_manager+0x118>
ffffffffc020392c:	06a00593          	li	a1,106
ffffffffc0203930:	00001517          	auipc	a0,0x1
ffffffffc0203934:	70850513          	addi	a0,a0,1800 # ffffffffc0205038 <commands+0x998>
ffffffffc0203938:	fcafc0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(page_ref(pde2page(boot_pgdir[0])) == 1);
ffffffffc020393c:	00002697          	auipc	a3,0x2
ffffffffc0203940:	3fc68693          	addi	a3,a3,1020 # ffffffffc0205d38 <default_pmm_manager+0x4a0>
ffffffffc0203944:	00001617          	auipc	a2,0x1
ffffffffc0203948:	48460613          	addi	a2,a2,1156 # ffffffffc0204dc8 <commands+0x728>
ffffffffc020394c:	1b900593          	li	a1,441
ffffffffc0203950:	00002517          	auipc	a0,0x2
ffffffffc0203954:	08850513          	addi	a0,a0,136 # ffffffffc02059d8 <default_pmm_manager+0x140>
ffffffffc0203958:	faafc0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(page_ref(p2) == 0);
ffffffffc020395c:	00002697          	auipc	a3,0x2
ffffffffc0203960:	39468693          	addi	a3,a3,916 # ffffffffc0205cf0 <default_pmm_manager+0x458>
ffffffffc0203964:	00001617          	auipc	a2,0x1
ffffffffc0203968:	46460613          	addi	a2,a2,1124 # ffffffffc0204dc8 <commands+0x728>
ffffffffc020396c:	1b700593          	li	a1,439
ffffffffc0203970:	00002517          	auipc	a0,0x2
ffffffffc0203974:	06850513          	addi	a0,a0,104 # ffffffffc02059d8 <default_pmm_manager+0x140>
ffffffffc0203978:	f8afc0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(page_ref(p1) == 0);
ffffffffc020397c:	00002697          	auipc	a3,0x2
ffffffffc0203980:	3a468693          	addi	a3,a3,932 # ffffffffc0205d20 <default_pmm_manager+0x488>
ffffffffc0203984:	00001617          	auipc	a2,0x1
ffffffffc0203988:	44460613          	addi	a2,a2,1092 # ffffffffc0204dc8 <commands+0x728>
ffffffffc020398c:	1b600593          	li	a1,438
ffffffffc0203990:	00002517          	auipc	a0,0x2
ffffffffc0203994:	04850513          	addi	a0,a0,72 # ffffffffc02059d8 <default_pmm_manager+0x140>
ffffffffc0203998:	f6afc0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(page_ref(p2) == 0);
ffffffffc020399c:	00002697          	auipc	a3,0x2
ffffffffc02039a0:	35468693          	addi	a3,a3,852 # ffffffffc0205cf0 <default_pmm_manager+0x458>
ffffffffc02039a4:	00001617          	auipc	a2,0x1
ffffffffc02039a8:	42460613          	addi	a2,a2,1060 # ffffffffc0204dc8 <commands+0x728>
ffffffffc02039ac:	1b300593          	li	a1,435
ffffffffc02039b0:	00002517          	auipc	a0,0x2
ffffffffc02039b4:	02850513          	addi	a0,a0,40 # ffffffffc02059d8 <default_pmm_manager+0x140>
ffffffffc02039b8:	f4afc0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(page_ref(p) == 1);
ffffffffc02039bc:	00002697          	auipc	a3,0x2
ffffffffc02039c0:	48c68693          	addi	a3,a3,1164 # ffffffffc0205e48 <default_pmm_manager+0x5b0>
ffffffffc02039c4:	00001617          	auipc	a2,0x1
ffffffffc02039c8:	40460613          	addi	a2,a2,1028 # ffffffffc0204dc8 <commands+0x728>
ffffffffc02039cc:	1d700593          	li	a1,471
ffffffffc02039d0:	00002517          	auipc	a0,0x2
ffffffffc02039d4:	00850513          	addi	a0,a0,8 # ffffffffc02059d8 <default_pmm_manager+0x140>
ffffffffc02039d8:	f2afc0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W | PTE_R) == 0);
ffffffffc02039dc:	00002697          	auipc	a3,0x2
ffffffffc02039e0:	43468693          	addi	a3,a3,1076 # ffffffffc0205e10 <default_pmm_manager+0x578>
ffffffffc02039e4:	00001617          	auipc	a2,0x1
ffffffffc02039e8:	3e460613          	addi	a2,a2,996 # ffffffffc0204dc8 <commands+0x728>
ffffffffc02039ec:	1d600593          	li	a1,470
ffffffffc02039f0:	00002517          	auipc	a0,0x2
ffffffffc02039f4:	fe850513          	addi	a0,a0,-24 # ffffffffc02059d8 <default_pmm_manager+0x140>
ffffffffc02039f8:	f0afc0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(boot_pgdir[0] == 0);
ffffffffc02039fc:	00002697          	auipc	a3,0x2
ffffffffc0203a00:	3fc68693          	addi	a3,a3,1020 # ffffffffc0205df8 <default_pmm_manager+0x560>
ffffffffc0203a04:	00001617          	auipc	a2,0x1
ffffffffc0203a08:	3c460613          	addi	a2,a2,964 # ffffffffc0204dc8 <commands+0x728>
ffffffffc0203a0c:	1d200593          	li	a1,466
ffffffffc0203a10:	00002517          	auipc	a0,0x2
ffffffffc0203a14:	fc850513          	addi	a0,a0,-56 # ffffffffc02059d8 <default_pmm_manager+0x140>
ffffffffc0203a18:	eeafc0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(nr_free_store==nr_free_pages());
ffffffffc0203a1c:	00002697          	auipc	a3,0x2
ffffffffc0203a20:	34468693          	addi	a3,a3,836 # ffffffffc0205d60 <default_pmm_manager+0x4c8>
ffffffffc0203a24:	00001617          	auipc	a2,0x1
ffffffffc0203a28:	3a460613          	addi	a2,a2,932 # ffffffffc0204dc8 <commands+0x728>
ffffffffc0203a2c:	1c000593          	li	a1,448
ffffffffc0203a30:	00002517          	auipc	a0,0x2
ffffffffc0203a34:	fa850513          	addi	a0,a0,-88 # ffffffffc02059d8 <default_pmm_manager+0x140>
ffffffffc0203a38:	ecafc0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(pte2page(*ptep) == p1);
ffffffffc0203a3c:	00002697          	auipc	a3,0x2
ffffffffc0203a40:	15c68693          	addi	a3,a3,348 # ffffffffc0205b98 <default_pmm_manager+0x300>
ffffffffc0203a44:	00001617          	auipc	a2,0x1
ffffffffc0203a48:	38460613          	addi	a2,a2,900 # ffffffffc0204dc8 <commands+0x728>
ffffffffc0203a4c:	19b00593          	li	a1,411
ffffffffc0203a50:	00002517          	auipc	a0,0x2
ffffffffc0203a54:	f8850513          	addi	a0,a0,-120 # ffffffffc02059d8 <default_pmm_manager+0x140>
ffffffffc0203a58:	eaafc0ef          	jal	ra,ffffffffc0200102 <__panic>
    ptep = (pte_t *)KADDR(PDE_ADDR(boot_pgdir[0]));
ffffffffc0203a5c:	00002617          	auipc	a2,0x2
ffffffffc0203a60:	f5460613          	addi	a2,a2,-172 # ffffffffc02059b0 <default_pmm_manager+0x118>
ffffffffc0203a64:	19e00593          	li	a1,414
ffffffffc0203a68:	00002517          	auipc	a0,0x2
ffffffffc0203a6c:	f7050513          	addi	a0,a0,-144 # ffffffffc02059d8 <default_pmm_manager+0x140>
ffffffffc0203a70:	e92fc0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(page_ref(p1) == 1);
ffffffffc0203a74:	00002697          	auipc	a3,0x2
ffffffffc0203a78:	13c68693          	addi	a3,a3,316 # ffffffffc0205bb0 <default_pmm_manager+0x318>
ffffffffc0203a7c:	00001617          	auipc	a2,0x1
ffffffffc0203a80:	34c60613          	addi	a2,a2,844 # ffffffffc0204dc8 <commands+0x728>
ffffffffc0203a84:	19c00593          	li	a1,412
ffffffffc0203a88:	00002517          	auipc	a0,0x2
ffffffffc0203a8c:	f5050513          	addi	a0,a0,-176 # ffffffffc02059d8 <default_pmm_manager+0x140>
ffffffffc0203a90:	e72fc0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
ffffffffc0203a94:	00002697          	auipc	a3,0x2
ffffffffc0203a98:	19468693          	addi	a3,a3,404 # ffffffffc0205c28 <default_pmm_manager+0x390>
ffffffffc0203a9c:	00001617          	auipc	a2,0x1
ffffffffc0203aa0:	32c60613          	addi	a2,a2,812 # ffffffffc0204dc8 <commands+0x728>
ffffffffc0203aa4:	1a400593          	li	a1,420
ffffffffc0203aa8:	00002517          	auipc	a0,0x2
ffffffffc0203aac:	f3050513          	addi	a0,a0,-208 # ffffffffc02059d8 <default_pmm_manager+0x140>
ffffffffc0203ab0:	e52fc0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(strlen((const char *)0x100) == 0);
ffffffffc0203ab4:	00002697          	auipc	a3,0x2
ffffffffc0203ab8:	45468693          	addi	a3,a3,1108 # ffffffffc0205f08 <default_pmm_manager+0x670>
ffffffffc0203abc:	00001617          	auipc	a2,0x1
ffffffffc0203ac0:	30c60613          	addi	a2,a2,780 # ffffffffc0204dc8 <commands+0x728>
ffffffffc0203ac4:	1e000593          	li	a1,480
ffffffffc0203ac8:	00002517          	auipc	a0,0x2
ffffffffc0203acc:	f1050513          	addi	a0,a0,-240 # ffffffffc02059d8 <default_pmm_manager+0x140>
ffffffffc0203ad0:	e32fc0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
ffffffffc0203ad4:	00002697          	auipc	a3,0x2
ffffffffc0203ad8:	3fc68693          	addi	a3,a3,1020 # ffffffffc0205ed0 <default_pmm_manager+0x638>
ffffffffc0203adc:	00001617          	auipc	a2,0x1
ffffffffc0203ae0:	2ec60613          	addi	a2,a2,748 # ffffffffc0204dc8 <commands+0x728>
ffffffffc0203ae4:	1dd00593          	li	a1,477
ffffffffc0203ae8:	00002517          	auipc	a0,0x2
ffffffffc0203aec:	ef050513          	addi	a0,a0,-272 # ffffffffc02059d8 <default_pmm_manager+0x140>
ffffffffc0203af0:	e12fc0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(page_ref(p) == 2);
ffffffffc0203af4:	00002697          	auipc	a3,0x2
ffffffffc0203af8:	3ac68693          	addi	a3,a3,940 # ffffffffc0205ea0 <default_pmm_manager+0x608>
ffffffffc0203afc:	00001617          	auipc	a2,0x1
ffffffffc0203b00:	2cc60613          	addi	a2,a2,716 # ffffffffc0204dc8 <commands+0x728>
ffffffffc0203b04:	1d900593          	li	a1,473
ffffffffc0203b08:	00002517          	auipc	a0,0x2
ffffffffc0203b0c:	ed050513          	addi	a0,a0,-304 # ffffffffc02059d8 <default_pmm_manager+0x140>
ffffffffc0203b10:	df2fc0ef          	jal	ra,ffffffffc0200102 <__panic>

ffffffffc0203b14 <tlb_invalidate>:
static inline void flush_tlb() { asm volatile("sfence.vma"); }
ffffffffc0203b14:	12000073          	sfence.vma
void tlb_invalidate(pde_t *pgdir, uintptr_t la) { flush_tlb(); }
ffffffffc0203b18:	8082                	ret

ffffffffc0203b1a <pgdir_alloc_page>:
struct Page *pgdir_alloc_page(pde_t *pgdir, uintptr_t la, uint32_t perm) {
ffffffffc0203b1a:	7179                	addi	sp,sp,-48
ffffffffc0203b1c:	e84a                	sd	s2,16(sp)
ffffffffc0203b1e:	892a                	mv	s2,a0
    struct Page *page = alloc_page();
ffffffffc0203b20:	4505                	li	a0,1
struct Page *pgdir_alloc_page(pde_t *pgdir, uintptr_t la, uint32_t perm) {
ffffffffc0203b22:	f022                	sd	s0,32(sp)
ffffffffc0203b24:	ec26                	sd	s1,24(sp)
ffffffffc0203b26:	e44e                	sd	s3,8(sp)
ffffffffc0203b28:	f406                	sd	ra,40(sp)
ffffffffc0203b2a:	84ae                	mv	s1,a1
ffffffffc0203b2c:	89b2                	mv	s3,a2
    struct Page *page = alloc_page();
ffffffffc0203b2e:	eedfe0ef          	jal	ra,ffffffffc0202a1a <alloc_pages>
ffffffffc0203b32:	842a                	mv	s0,a0
    if (page != NULL) {
ffffffffc0203b34:	cd09                	beqz	a0,ffffffffc0203b4e <pgdir_alloc_page+0x34>
        if (page_insert(pgdir, page, la, perm) != 0) {
ffffffffc0203b36:	85aa                	mv	a1,a0
ffffffffc0203b38:	86ce                	mv	a3,s3
ffffffffc0203b3a:	8626                	mv	a2,s1
ffffffffc0203b3c:	854a                	mv	a0,s2
ffffffffc0203b3e:	ad2ff0ef          	jal	ra,ffffffffc0202e10 <page_insert>
ffffffffc0203b42:	ed21                	bnez	a0,ffffffffc0203b9a <pgdir_alloc_page+0x80>
        if (swap_init_ok) {
ffffffffc0203b44:	0000e797          	auipc	a5,0xe
ffffffffc0203b48:	9ec7a783          	lw	a5,-1556(a5) # ffffffffc0211530 <swap_init_ok>
ffffffffc0203b4c:	eb89                	bnez	a5,ffffffffc0203b5e <pgdir_alloc_page+0x44>
}
ffffffffc0203b4e:	70a2                	ld	ra,40(sp)
ffffffffc0203b50:	8522                	mv	a0,s0
ffffffffc0203b52:	7402                	ld	s0,32(sp)
ffffffffc0203b54:	64e2                	ld	s1,24(sp)
ffffffffc0203b56:	6942                	ld	s2,16(sp)
ffffffffc0203b58:	69a2                	ld	s3,8(sp)
ffffffffc0203b5a:	6145                	addi	sp,sp,48
ffffffffc0203b5c:	8082                	ret
            swap_map_swappable(check_mm_struct, la, page, 0);
ffffffffc0203b5e:	4681                	li	a3,0
ffffffffc0203b60:	8622                	mv	a2,s0
ffffffffc0203b62:	85a6                	mv	a1,s1
ffffffffc0203b64:	0000e517          	auipc	a0,0xe
ffffffffc0203b68:	9ac53503          	ld	a0,-1620(a0) # ffffffffc0211510 <check_mm_struct>
ffffffffc0203b6c:	e97fd0ef          	jal	ra,ffffffffc0201a02 <swap_map_swappable>
            assert(page_ref(page) == 1);
ffffffffc0203b70:	4018                	lw	a4,0(s0)
            page->pra_vaddr = la;
ffffffffc0203b72:	e024                	sd	s1,64(s0)
            assert(page_ref(page) == 1);
ffffffffc0203b74:	4785                	li	a5,1
ffffffffc0203b76:	fcf70ce3          	beq	a4,a5,ffffffffc0203b4e <pgdir_alloc_page+0x34>
ffffffffc0203b7a:	00002697          	auipc	a3,0x2
ffffffffc0203b7e:	3d668693          	addi	a3,a3,982 # ffffffffc0205f50 <default_pmm_manager+0x6b8>
ffffffffc0203b82:	00001617          	auipc	a2,0x1
ffffffffc0203b86:	24660613          	addi	a2,a2,582 # ffffffffc0204dc8 <commands+0x728>
ffffffffc0203b8a:	17a00593          	li	a1,378
ffffffffc0203b8e:	00002517          	auipc	a0,0x2
ffffffffc0203b92:	e4a50513          	addi	a0,a0,-438 # ffffffffc02059d8 <default_pmm_manager+0x140>
ffffffffc0203b96:	d6cfc0ef          	jal	ra,ffffffffc0200102 <__panic>
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0203b9a:	100027f3          	csrr	a5,sstatus
ffffffffc0203b9e:	8b89                	andi	a5,a5,2
ffffffffc0203ba0:	eb99                	bnez	a5,ffffffffc0203bb6 <pgdir_alloc_page+0x9c>
    { pmm_manager->free_pages(base, n); }
ffffffffc0203ba2:	0000e797          	auipc	a5,0xe
ffffffffc0203ba6:	9be7b783          	ld	a5,-1602(a5) # ffffffffc0211560 <pmm_manager>
ffffffffc0203baa:	739c                	ld	a5,32(a5)
ffffffffc0203bac:	8522                	mv	a0,s0
ffffffffc0203bae:	4585                	li	a1,1
ffffffffc0203bb0:	9782                	jalr	a5
            return NULL;
ffffffffc0203bb2:	4401                	li	s0,0
ffffffffc0203bb4:	bf69                	j	ffffffffc0203b4e <pgdir_alloc_page+0x34>
        intr_disable();
ffffffffc0203bb6:	939fc0ef          	jal	ra,ffffffffc02004ee <intr_disable>
    { pmm_manager->free_pages(base, n); }
ffffffffc0203bba:	0000e797          	auipc	a5,0xe
ffffffffc0203bbe:	9a67b783          	ld	a5,-1626(a5) # ffffffffc0211560 <pmm_manager>
ffffffffc0203bc2:	739c                	ld	a5,32(a5)
ffffffffc0203bc4:	8522                	mv	a0,s0
ffffffffc0203bc6:	4585                	li	a1,1
ffffffffc0203bc8:	9782                	jalr	a5
            return NULL;
ffffffffc0203bca:	4401                	li	s0,0
        intr_enable();
ffffffffc0203bcc:	91dfc0ef          	jal	ra,ffffffffc02004e8 <intr_enable>
ffffffffc0203bd0:	bfbd                	j	ffffffffc0203b4e <pgdir_alloc_page+0x34>

ffffffffc0203bd2 <kmalloc>:
}

void *kmalloc(size_t n) {
ffffffffc0203bd2:	1141                	addi	sp,sp,-16
    void *ptr = NULL;
    struct Page *base = NULL;
    assert(n > 0 && n < 1024 * 0124);
ffffffffc0203bd4:	67d5                	lui	a5,0x15
void *kmalloc(size_t n) {
ffffffffc0203bd6:	e406                	sd	ra,8(sp)
    assert(n > 0 && n < 1024 * 0124);
ffffffffc0203bd8:	fff50713          	addi	a4,a0,-1
ffffffffc0203bdc:	17f9                	addi	a5,a5,-2
ffffffffc0203bde:	04e7ea63          	bltu	a5,a4,ffffffffc0203c32 <kmalloc+0x60>
    int num_pages = (n + PGSIZE - 1) / PGSIZE;
ffffffffc0203be2:	6785                	lui	a5,0x1
ffffffffc0203be4:	17fd                	addi	a5,a5,-1
ffffffffc0203be6:	953e                	add	a0,a0,a5
    base = alloc_pages(num_pages);
ffffffffc0203be8:	8131                	srli	a0,a0,0xc
ffffffffc0203bea:	e31fe0ef          	jal	ra,ffffffffc0202a1a <alloc_pages>
    assert(base != NULL);
ffffffffc0203bee:	cd3d                	beqz	a0,ffffffffc0203c6c <kmalloc+0x9a>
static inline ppn_t page2ppn(struct Page *page) { return page - pages + nbase; }
ffffffffc0203bf0:	0000e797          	auipc	a5,0xe
ffffffffc0203bf4:	9687b783          	ld	a5,-1688(a5) # ffffffffc0211558 <pages>
ffffffffc0203bf8:	8d1d                	sub	a0,a0,a5
ffffffffc0203bfa:	00002697          	auipc	a3,0x2
ffffffffc0203bfe:	64e6b683          	ld	a3,1614(a3) # ffffffffc0206248 <error_string+0x38>
ffffffffc0203c02:	850d                	srai	a0,a0,0x3
ffffffffc0203c04:	02d50533          	mul	a0,a0,a3
ffffffffc0203c08:	000806b7          	lui	a3,0x80
static inline void *page2kva(struct Page *page) { return KADDR(page2pa(page)); }
ffffffffc0203c0c:	0000e717          	auipc	a4,0xe
ffffffffc0203c10:	94473703          	ld	a4,-1724(a4) # ffffffffc0211550 <npage>
static inline ppn_t page2ppn(struct Page *page) { return page - pages + nbase; }
ffffffffc0203c14:	9536                	add	a0,a0,a3
static inline void *page2kva(struct Page *page) { return KADDR(page2pa(page)); }
ffffffffc0203c16:	00c51793          	slli	a5,a0,0xc
ffffffffc0203c1a:	83b1                	srli	a5,a5,0xc
    return page2ppn(page) << PGSHIFT;
ffffffffc0203c1c:	0532                	slli	a0,a0,0xc
static inline void *page2kva(struct Page *page) { return KADDR(page2pa(page)); }
ffffffffc0203c1e:	02e7fa63          	bgeu	a5,a4,ffffffffc0203c52 <kmalloc+0x80>
    ptr = page2kva(base);
    return ptr;
}
ffffffffc0203c22:	60a2                	ld	ra,8(sp)
ffffffffc0203c24:	0000e797          	auipc	a5,0xe
ffffffffc0203c28:	9447b783          	ld	a5,-1724(a5) # ffffffffc0211568 <va_pa_offset>
ffffffffc0203c2c:	953e                	add	a0,a0,a5
ffffffffc0203c2e:	0141                	addi	sp,sp,16
ffffffffc0203c30:	8082                	ret
    assert(n > 0 && n < 1024 * 0124);
ffffffffc0203c32:	00002697          	auipc	a3,0x2
ffffffffc0203c36:	33668693          	addi	a3,a3,822 # ffffffffc0205f68 <default_pmm_manager+0x6d0>
ffffffffc0203c3a:	00001617          	auipc	a2,0x1
ffffffffc0203c3e:	18e60613          	addi	a2,a2,398 # ffffffffc0204dc8 <commands+0x728>
ffffffffc0203c42:	1f000593          	li	a1,496
ffffffffc0203c46:	00002517          	auipc	a0,0x2
ffffffffc0203c4a:	d9250513          	addi	a0,a0,-622 # ffffffffc02059d8 <default_pmm_manager+0x140>
ffffffffc0203c4e:	cb4fc0ef          	jal	ra,ffffffffc0200102 <__panic>
ffffffffc0203c52:	86aa                	mv	a3,a0
ffffffffc0203c54:	00002617          	auipc	a2,0x2
ffffffffc0203c58:	d5c60613          	addi	a2,a2,-676 # ffffffffc02059b0 <default_pmm_manager+0x118>
ffffffffc0203c5c:	06a00593          	li	a1,106
ffffffffc0203c60:	00001517          	auipc	a0,0x1
ffffffffc0203c64:	3d850513          	addi	a0,a0,984 # ffffffffc0205038 <commands+0x998>
ffffffffc0203c68:	c9afc0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(base != NULL);
ffffffffc0203c6c:	00002697          	auipc	a3,0x2
ffffffffc0203c70:	31c68693          	addi	a3,a3,796 # ffffffffc0205f88 <default_pmm_manager+0x6f0>
ffffffffc0203c74:	00001617          	auipc	a2,0x1
ffffffffc0203c78:	15460613          	addi	a2,a2,340 # ffffffffc0204dc8 <commands+0x728>
ffffffffc0203c7c:	1f300593          	li	a1,499
ffffffffc0203c80:	00002517          	auipc	a0,0x2
ffffffffc0203c84:	d5850513          	addi	a0,a0,-680 # ffffffffc02059d8 <default_pmm_manager+0x140>
ffffffffc0203c88:	c7afc0ef          	jal	ra,ffffffffc0200102 <__panic>

ffffffffc0203c8c <kfree>:

void kfree(void *ptr, size_t n) {
ffffffffc0203c8c:	1101                	addi	sp,sp,-32
    assert(n > 0 && n < 1024 * 0124);
ffffffffc0203c8e:	67d5                	lui	a5,0x15
void kfree(void *ptr, size_t n) {
ffffffffc0203c90:	ec06                	sd	ra,24(sp)
    assert(n > 0 && n < 1024 * 0124);
ffffffffc0203c92:	fff58713          	addi	a4,a1,-1
ffffffffc0203c96:	17f9                	addi	a5,a5,-2
ffffffffc0203c98:	0ae7ee63          	bltu	a5,a4,ffffffffc0203d54 <kfree+0xc8>
    assert(ptr != NULL);
ffffffffc0203c9c:	cd41                	beqz	a0,ffffffffc0203d34 <kfree+0xa8>
    struct Page *base = NULL;
    int num_pages = (n + PGSIZE - 1) / PGSIZE;
ffffffffc0203c9e:	6785                	lui	a5,0x1
ffffffffc0203ca0:	17fd                	addi	a5,a5,-1
ffffffffc0203ca2:	95be                	add	a1,a1,a5
static inline struct Page *kva2page(void *kva) { return pa2page(PADDR(kva)); }
ffffffffc0203ca4:	c02007b7          	lui	a5,0xc0200
ffffffffc0203ca8:	81b1                	srli	a1,a1,0xc
ffffffffc0203caa:	06f56863          	bltu	a0,a5,ffffffffc0203d1a <kfree+0x8e>
ffffffffc0203cae:	0000e697          	auipc	a3,0xe
ffffffffc0203cb2:	8ba6b683          	ld	a3,-1862(a3) # ffffffffc0211568 <va_pa_offset>
ffffffffc0203cb6:	8d15                	sub	a0,a0,a3
    if (PPN(pa) >= npage) {
ffffffffc0203cb8:	8131                	srli	a0,a0,0xc
ffffffffc0203cba:	0000e797          	auipc	a5,0xe
ffffffffc0203cbe:	8967b783          	ld	a5,-1898(a5) # ffffffffc0211550 <npage>
ffffffffc0203cc2:	04f57a63          	bgeu	a0,a5,ffffffffc0203d16 <kfree+0x8a>
    return &pages[PPN(pa) - nbase];
ffffffffc0203cc6:	fff806b7          	lui	a3,0xfff80
ffffffffc0203cca:	9536                	add	a0,a0,a3
ffffffffc0203ccc:	00351793          	slli	a5,a0,0x3
ffffffffc0203cd0:	953e                	add	a0,a0,a5
ffffffffc0203cd2:	050e                	slli	a0,a0,0x3
ffffffffc0203cd4:	0000e797          	auipc	a5,0xe
ffffffffc0203cd8:	8847b783          	ld	a5,-1916(a5) # ffffffffc0211558 <pages>
ffffffffc0203cdc:	953e                	add	a0,a0,a5
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0203cde:	100027f3          	csrr	a5,sstatus
ffffffffc0203ce2:	8b89                	andi	a5,a5,2
ffffffffc0203ce4:	eb89                	bnez	a5,ffffffffc0203cf6 <kfree+0x6a>
    { pmm_manager->free_pages(base, n); }
ffffffffc0203ce6:	0000e797          	auipc	a5,0xe
ffffffffc0203cea:	87a7b783          	ld	a5,-1926(a5) # ffffffffc0211560 <pmm_manager>
    base = kva2page(ptr);
    free_pages(base, num_pages);
}
ffffffffc0203cee:	60e2                	ld	ra,24(sp)
    { pmm_manager->free_pages(base, n); }
ffffffffc0203cf0:	739c                	ld	a5,32(a5)
}
ffffffffc0203cf2:	6105                	addi	sp,sp,32
    { pmm_manager->free_pages(base, n); }
ffffffffc0203cf4:	8782                	jr	a5
        intr_disable();
ffffffffc0203cf6:	e42a                	sd	a0,8(sp)
ffffffffc0203cf8:	e02e                	sd	a1,0(sp)
ffffffffc0203cfa:	ff4fc0ef          	jal	ra,ffffffffc02004ee <intr_disable>
ffffffffc0203cfe:	0000e797          	auipc	a5,0xe
ffffffffc0203d02:	8627b783          	ld	a5,-1950(a5) # ffffffffc0211560 <pmm_manager>
ffffffffc0203d06:	6582                	ld	a1,0(sp)
ffffffffc0203d08:	6522                	ld	a0,8(sp)
ffffffffc0203d0a:	739c                	ld	a5,32(a5)
ffffffffc0203d0c:	9782                	jalr	a5
}
ffffffffc0203d0e:	60e2                	ld	ra,24(sp)
ffffffffc0203d10:	6105                	addi	sp,sp,32
        intr_enable();
ffffffffc0203d12:	fd6fc06f          	j	ffffffffc02004e8 <intr_enable>
ffffffffc0203d16:	ccdfe0ef          	jal	ra,ffffffffc02029e2 <pa2page.part.0>
static inline struct Page *kva2page(void *kva) { return pa2page(PADDR(kva)); }
ffffffffc0203d1a:	86aa                	mv	a3,a0
ffffffffc0203d1c:	00002617          	auipc	a2,0x2
ffffffffc0203d20:	d5460613          	addi	a2,a2,-684 # ffffffffc0205a70 <default_pmm_manager+0x1d8>
ffffffffc0203d24:	06c00593          	li	a1,108
ffffffffc0203d28:	00001517          	auipc	a0,0x1
ffffffffc0203d2c:	31050513          	addi	a0,a0,784 # ffffffffc0205038 <commands+0x998>
ffffffffc0203d30:	bd2fc0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(ptr != NULL);
ffffffffc0203d34:	00002697          	auipc	a3,0x2
ffffffffc0203d38:	26468693          	addi	a3,a3,612 # ffffffffc0205f98 <default_pmm_manager+0x700>
ffffffffc0203d3c:	00001617          	auipc	a2,0x1
ffffffffc0203d40:	08c60613          	addi	a2,a2,140 # ffffffffc0204dc8 <commands+0x728>
ffffffffc0203d44:	1fa00593          	li	a1,506
ffffffffc0203d48:	00002517          	auipc	a0,0x2
ffffffffc0203d4c:	c9050513          	addi	a0,a0,-880 # ffffffffc02059d8 <default_pmm_manager+0x140>
ffffffffc0203d50:	bb2fc0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(n > 0 && n < 1024 * 0124);
ffffffffc0203d54:	00002697          	auipc	a3,0x2
ffffffffc0203d58:	21468693          	addi	a3,a3,532 # ffffffffc0205f68 <default_pmm_manager+0x6d0>
ffffffffc0203d5c:	00001617          	auipc	a2,0x1
ffffffffc0203d60:	06c60613          	addi	a2,a2,108 # ffffffffc0204dc8 <commands+0x728>
ffffffffc0203d64:	1f900593          	li	a1,505
ffffffffc0203d68:	00002517          	auipc	a0,0x2
ffffffffc0203d6c:	c7050513          	addi	a0,a0,-912 # ffffffffc02059d8 <default_pmm_manager+0x140>
ffffffffc0203d70:	b92fc0ef          	jal	ra,ffffffffc0200102 <__panic>

ffffffffc0203d74 <swapfs_init>:
#include <ide.h>
#include <pmm.h>
#include <assert.h>

void
swapfs_init(void) {
ffffffffc0203d74:	1141                	addi	sp,sp,-16
    static_assert((PGSIZE % SECTSIZE) == 0);
    if (!ide_device_valid(SWAP_DEV_NO)) {
ffffffffc0203d76:	4505                	li	a0,1
swapfs_init(void) {
ffffffffc0203d78:	e406                	sd	ra,8(sp)
    if (!ide_device_valid(SWAP_DEV_NO)) {
ffffffffc0203d7a:	e58fc0ef          	jal	ra,ffffffffc02003d2 <ide_device_valid>
ffffffffc0203d7e:	cd01                	beqz	a0,ffffffffc0203d96 <swapfs_init+0x22>
        panic("swap fs isn't available.\n");
    }
    max_swap_offset = ide_device_size(SWAP_DEV_NO) / (PGSIZE / SECTSIZE);
ffffffffc0203d80:	4505                	li	a0,1
ffffffffc0203d82:	e56fc0ef          	jal	ra,ffffffffc02003d8 <ide_device_size>
}
ffffffffc0203d86:	60a2                	ld	ra,8(sp)
    max_swap_offset = ide_device_size(SWAP_DEV_NO) / (PGSIZE / SECTSIZE);
ffffffffc0203d88:	810d                	srli	a0,a0,0x3
ffffffffc0203d8a:	0000d797          	auipc	a5,0xd
ffffffffc0203d8e:	78a7bb23          	sd	a0,1942(a5) # ffffffffc0211520 <max_swap_offset>
}
ffffffffc0203d92:	0141                	addi	sp,sp,16
ffffffffc0203d94:	8082                	ret
        panic("swap fs isn't available.\n");
ffffffffc0203d96:	00002617          	auipc	a2,0x2
ffffffffc0203d9a:	21260613          	addi	a2,a2,530 # ffffffffc0205fa8 <default_pmm_manager+0x710>
ffffffffc0203d9e:	45b5                	li	a1,13
ffffffffc0203da0:	00002517          	auipc	a0,0x2
ffffffffc0203da4:	22850513          	addi	a0,a0,552 # ffffffffc0205fc8 <default_pmm_manager+0x730>
ffffffffc0203da8:	b5afc0ef          	jal	ra,ffffffffc0200102 <__panic>

ffffffffc0203dac <swapfs_read>:

int
swapfs_read(swap_entry_t entry, struct Page *page) {
ffffffffc0203dac:	1141                	addi	sp,sp,-16
ffffffffc0203dae:	e406                	sd	ra,8(sp)
    return ide_read_secs(SWAP_DEV_NO, swap_offset(entry) * PAGE_NSECT, page2kva(page), PAGE_NSECT);
ffffffffc0203db0:	00855793          	srli	a5,a0,0x8
ffffffffc0203db4:	c3a5                	beqz	a5,ffffffffc0203e14 <swapfs_read+0x68>
ffffffffc0203db6:	0000d717          	auipc	a4,0xd
ffffffffc0203dba:	76a73703          	ld	a4,1898(a4) # ffffffffc0211520 <max_swap_offset>
ffffffffc0203dbe:	04e7fb63          	bgeu	a5,a4,ffffffffc0203e14 <swapfs_read+0x68>
static inline ppn_t page2ppn(struct Page *page) { return page - pages + nbase; }
ffffffffc0203dc2:	0000d617          	auipc	a2,0xd
ffffffffc0203dc6:	79663603          	ld	a2,1942(a2) # ffffffffc0211558 <pages>
ffffffffc0203dca:	8d91                	sub	a1,a1,a2
ffffffffc0203dcc:	4035d613          	srai	a2,a1,0x3
ffffffffc0203dd0:	00002597          	auipc	a1,0x2
ffffffffc0203dd4:	4785b583          	ld	a1,1144(a1) # ffffffffc0206248 <error_string+0x38>
ffffffffc0203dd8:	02b60633          	mul	a2,a2,a1
ffffffffc0203ddc:	0037959b          	slliw	a1,a5,0x3
ffffffffc0203de0:	00002797          	auipc	a5,0x2
ffffffffc0203de4:	4707b783          	ld	a5,1136(a5) # ffffffffc0206250 <nbase>
static inline void *page2kva(struct Page *page) { return KADDR(page2pa(page)); }
ffffffffc0203de8:	0000d717          	auipc	a4,0xd
ffffffffc0203dec:	76873703          	ld	a4,1896(a4) # ffffffffc0211550 <npage>
static inline ppn_t page2ppn(struct Page *page) { return page - pages + nbase; }
ffffffffc0203df0:	963e                	add	a2,a2,a5
static inline void *page2kva(struct Page *page) { return KADDR(page2pa(page)); }
ffffffffc0203df2:	00c61793          	slli	a5,a2,0xc
ffffffffc0203df6:	83b1                	srli	a5,a5,0xc
    return page2ppn(page) << PGSHIFT;
ffffffffc0203df8:	0632                	slli	a2,a2,0xc
static inline void *page2kva(struct Page *page) { return KADDR(page2pa(page)); }
ffffffffc0203dfa:	02e7f963          	bgeu	a5,a4,ffffffffc0203e2c <swapfs_read+0x80>
}
ffffffffc0203dfe:	60a2                	ld	ra,8(sp)
    return ide_read_secs(SWAP_DEV_NO, swap_offset(entry) * PAGE_NSECT, page2kva(page), PAGE_NSECT);
ffffffffc0203e00:	0000d797          	auipc	a5,0xd
ffffffffc0203e04:	7687b783          	ld	a5,1896(a5) # ffffffffc0211568 <va_pa_offset>
ffffffffc0203e08:	46a1                	li	a3,8
ffffffffc0203e0a:	963e                	add	a2,a2,a5
ffffffffc0203e0c:	4505                	li	a0,1
}
ffffffffc0203e0e:	0141                	addi	sp,sp,16
    return ide_read_secs(SWAP_DEV_NO, swap_offset(entry) * PAGE_NSECT, page2kva(page), PAGE_NSECT);
ffffffffc0203e10:	dcefc06f          	j	ffffffffc02003de <ide_read_secs>
ffffffffc0203e14:	86aa                	mv	a3,a0
ffffffffc0203e16:	00002617          	auipc	a2,0x2
ffffffffc0203e1a:	1ca60613          	addi	a2,a2,458 # ffffffffc0205fe0 <default_pmm_manager+0x748>
ffffffffc0203e1e:	45d1                	li	a1,20
ffffffffc0203e20:	00002517          	auipc	a0,0x2
ffffffffc0203e24:	1a850513          	addi	a0,a0,424 # ffffffffc0205fc8 <default_pmm_manager+0x730>
ffffffffc0203e28:	adafc0ef          	jal	ra,ffffffffc0200102 <__panic>
ffffffffc0203e2c:	86b2                	mv	a3,a2
ffffffffc0203e2e:	06a00593          	li	a1,106
ffffffffc0203e32:	00002617          	auipc	a2,0x2
ffffffffc0203e36:	b7e60613          	addi	a2,a2,-1154 # ffffffffc02059b0 <default_pmm_manager+0x118>
ffffffffc0203e3a:	00001517          	auipc	a0,0x1
ffffffffc0203e3e:	1fe50513          	addi	a0,a0,510 # ffffffffc0205038 <commands+0x998>
ffffffffc0203e42:	ac0fc0ef          	jal	ra,ffffffffc0200102 <__panic>

ffffffffc0203e46 <swapfs_write>:

int
swapfs_write(swap_entry_t entry, struct Page *page) {
ffffffffc0203e46:	1141                	addi	sp,sp,-16
ffffffffc0203e48:	e406                	sd	ra,8(sp)
    return ide_write_secs(SWAP_DEV_NO, swap_offset(entry) * PAGE_NSECT, page2kva(page), PAGE_NSECT);
ffffffffc0203e4a:	00855793          	srli	a5,a0,0x8
ffffffffc0203e4e:	c3a5                	beqz	a5,ffffffffc0203eae <swapfs_write+0x68>
ffffffffc0203e50:	0000d717          	auipc	a4,0xd
ffffffffc0203e54:	6d073703          	ld	a4,1744(a4) # ffffffffc0211520 <max_swap_offset>
ffffffffc0203e58:	04e7fb63          	bgeu	a5,a4,ffffffffc0203eae <swapfs_write+0x68>
static inline ppn_t page2ppn(struct Page *page) { return page - pages + nbase; }
ffffffffc0203e5c:	0000d617          	auipc	a2,0xd
ffffffffc0203e60:	6fc63603          	ld	a2,1788(a2) # ffffffffc0211558 <pages>
ffffffffc0203e64:	8d91                	sub	a1,a1,a2
ffffffffc0203e66:	4035d613          	srai	a2,a1,0x3
ffffffffc0203e6a:	00002597          	auipc	a1,0x2
ffffffffc0203e6e:	3de5b583          	ld	a1,990(a1) # ffffffffc0206248 <error_string+0x38>
ffffffffc0203e72:	02b60633          	mul	a2,a2,a1
ffffffffc0203e76:	0037959b          	slliw	a1,a5,0x3
ffffffffc0203e7a:	00002797          	auipc	a5,0x2
ffffffffc0203e7e:	3d67b783          	ld	a5,982(a5) # ffffffffc0206250 <nbase>
static inline void *page2kva(struct Page *page) { return KADDR(page2pa(page)); }
ffffffffc0203e82:	0000d717          	auipc	a4,0xd
ffffffffc0203e86:	6ce73703          	ld	a4,1742(a4) # ffffffffc0211550 <npage>
static inline ppn_t page2ppn(struct Page *page) { return page - pages + nbase; }
ffffffffc0203e8a:	963e                	add	a2,a2,a5
static inline void *page2kva(struct Page *page) { return KADDR(page2pa(page)); }
ffffffffc0203e8c:	00c61793          	slli	a5,a2,0xc
ffffffffc0203e90:	83b1                	srli	a5,a5,0xc
    return page2ppn(page) << PGSHIFT;
ffffffffc0203e92:	0632                	slli	a2,a2,0xc
static inline void *page2kva(struct Page *page) { return KADDR(page2pa(page)); }
ffffffffc0203e94:	02e7f963          	bgeu	a5,a4,ffffffffc0203ec6 <swapfs_write+0x80>
}
ffffffffc0203e98:	60a2                	ld	ra,8(sp)
    return ide_write_secs(SWAP_DEV_NO, swap_offset(entry) * PAGE_NSECT, page2kva(page), PAGE_NSECT);
ffffffffc0203e9a:	0000d797          	auipc	a5,0xd
ffffffffc0203e9e:	6ce7b783          	ld	a5,1742(a5) # ffffffffc0211568 <va_pa_offset>
ffffffffc0203ea2:	46a1                	li	a3,8
ffffffffc0203ea4:	963e                	add	a2,a2,a5
ffffffffc0203ea6:	4505                	li	a0,1
}
ffffffffc0203ea8:	0141                	addi	sp,sp,16
    return ide_write_secs(SWAP_DEV_NO, swap_offset(entry) * PAGE_NSECT, page2kva(page), PAGE_NSECT);
ffffffffc0203eaa:	d58fc06f          	j	ffffffffc0200402 <ide_write_secs>
ffffffffc0203eae:	86aa                	mv	a3,a0
ffffffffc0203eb0:	00002617          	auipc	a2,0x2
ffffffffc0203eb4:	13060613          	addi	a2,a2,304 # ffffffffc0205fe0 <default_pmm_manager+0x748>
ffffffffc0203eb8:	45e5                	li	a1,25
ffffffffc0203eba:	00002517          	auipc	a0,0x2
ffffffffc0203ebe:	10e50513          	addi	a0,a0,270 # ffffffffc0205fc8 <default_pmm_manager+0x730>
ffffffffc0203ec2:	a40fc0ef          	jal	ra,ffffffffc0200102 <__panic>
ffffffffc0203ec6:	86b2                	mv	a3,a2
ffffffffc0203ec8:	06a00593          	li	a1,106
ffffffffc0203ecc:	00002617          	auipc	a2,0x2
ffffffffc0203ed0:	ae460613          	addi	a2,a2,-1308 # ffffffffc02059b0 <default_pmm_manager+0x118>
ffffffffc0203ed4:	00001517          	auipc	a0,0x1
ffffffffc0203ed8:	16450513          	addi	a0,a0,356 # ffffffffc0205038 <commands+0x998>
ffffffffc0203edc:	a26fc0ef          	jal	ra,ffffffffc0200102 <__panic>

ffffffffc0203ee0 <strlen>:
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
ffffffffc0203ee0:	00054783          	lbu	a5,0(a0)
strlen(const char *s) {
ffffffffc0203ee4:	872a                	mv	a4,a0
    size_t cnt = 0;
ffffffffc0203ee6:	4501                	li	a0,0
    while (*s ++ != '\0') {
ffffffffc0203ee8:	cb81                	beqz	a5,ffffffffc0203ef8 <strlen+0x18>
        cnt ++;
ffffffffc0203eea:	0505                	addi	a0,a0,1
    while (*s ++ != '\0') {
ffffffffc0203eec:	00a707b3          	add	a5,a4,a0
ffffffffc0203ef0:	0007c783          	lbu	a5,0(a5)
ffffffffc0203ef4:	fbfd                	bnez	a5,ffffffffc0203eea <strlen+0xa>
ffffffffc0203ef6:	8082                	ret
    }
    return cnt;
}
ffffffffc0203ef8:	8082                	ret

ffffffffc0203efa <strnlen>:
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
ffffffffc0203efa:	4781                	li	a5,0
    while (cnt < len && *s ++ != '\0') {
ffffffffc0203efc:	e589                	bnez	a1,ffffffffc0203f06 <strnlen+0xc>
ffffffffc0203efe:	a811                	j	ffffffffc0203f12 <strnlen+0x18>
        cnt ++;
ffffffffc0203f00:	0785                	addi	a5,a5,1
    while (cnt < len && *s ++ != '\0') {
ffffffffc0203f02:	00f58863          	beq	a1,a5,ffffffffc0203f12 <strnlen+0x18>
ffffffffc0203f06:	00f50733          	add	a4,a0,a5
ffffffffc0203f0a:	00074703          	lbu	a4,0(a4)
ffffffffc0203f0e:	fb6d                	bnez	a4,ffffffffc0203f00 <strnlen+0x6>
ffffffffc0203f10:	85be                	mv	a1,a5
    }
    return cnt;
}
ffffffffc0203f12:	852e                	mv	a0,a1
ffffffffc0203f14:	8082                	ret

ffffffffc0203f16 <strcpy>:
char *
strcpy(char *dst, const char *src) {
#ifdef __HAVE_ARCH_STRCPY
    return __strcpy(dst, src);
#else
    char *p = dst;
ffffffffc0203f16:	87aa                	mv	a5,a0
    while ((*p ++ = *src ++) != '\0')
ffffffffc0203f18:	0005c703          	lbu	a4,0(a1)
ffffffffc0203f1c:	0785                	addi	a5,a5,1
ffffffffc0203f1e:	0585                	addi	a1,a1,1
ffffffffc0203f20:	fee78fa3          	sb	a4,-1(a5)
ffffffffc0203f24:	fb75                	bnez	a4,ffffffffc0203f18 <strcpy+0x2>
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
ffffffffc0203f26:	8082                	ret

ffffffffc0203f28 <strcmp>:
int
strcmp(const char *s1, const char *s2) {
#ifdef __HAVE_ARCH_STRCMP
    return __strcmp(s1, s2);
#else
    while (*s1 != '\0' && *s1 == *s2) {
ffffffffc0203f28:	00054783          	lbu	a5,0(a0)
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc0203f2c:	0005c703          	lbu	a4,0(a1)
    while (*s1 != '\0' && *s1 == *s2) {
ffffffffc0203f30:	cb89                	beqz	a5,ffffffffc0203f42 <strcmp+0x1a>
        s1 ++, s2 ++;
ffffffffc0203f32:	0505                	addi	a0,a0,1
ffffffffc0203f34:	0585                	addi	a1,a1,1
    while (*s1 != '\0' && *s1 == *s2) {
ffffffffc0203f36:	fee789e3          	beq	a5,a4,ffffffffc0203f28 <strcmp>
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc0203f3a:	0007851b          	sext.w	a0,a5
#endif /* __HAVE_ARCH_STRCMP */
}
ffffffffc0203f3e:	9d19                	subw	a0,a0,a4
ffffffffc0203f40:	8082                	ret
ffffffffc0203f42:	4501                	li	a0,0
ffffffffc0203f44:	bfed                	j	ffffffffc0203f3e <strcmp+0x16>

ffffffffc0203f46 <strchr>:
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
ffffffffc0203f46:	00054783          	lbu	a5,0(a0)
ffffffffc0203f4a:	c799                	beqz	a5,ffffffffc0203f58 <strchr+0x12>
        if (*s == c) {
ffffffffc0203f4c:	00f58763          	beq	a1,a5,ffffffffc0203f5a <strchr+0x14>
    while (*s != '\0') {
ffffffffc0203f50:	00154783          	lbu	a5,1(a0)
            return (char *)s;
        }
        s ++;
ffffffffc0203f54:	0505                	addi	a0,a0,1
    while (*s != '\0') {
ffffffffc0203f56:	fbfd                	bnez	a5,ffffffffc0203f4c <strchr+0x6>
    }
    return NULL;
ffffffffc0203f58:	4501                	li	a0,0
}
ffffffffc0203f5a:	8082                	ret

ffffffffc0203f5c <memset>:
memset(void *s, char c, size_t n) {
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
#else
    char *p = s;
    while (n -- > 0) {
ffffffffc0203f5c:	ca01                	beqz	a2,ffffffffc0203f6c <memset+0x10>
ffffffffc0203f5e:	962a                	add	a2,a2,a0
    char *p = s;
ffffffffc0203f60:	87aa                	mv	a5,a0
        *p ++ = c;
ffffffffc0203f62:	0785                	addi	a5,a5,1
ffffffffc0203f64:	feb78fa3          	sb	a1,-1(a5)
    while (n -- > 0) {
ffffffffc0203f68:	fec79de3          	bne	a5,a2,ffffffffc0203f62 <memset+0x6>
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
ffffffffc0203f6c:	8082                	ret

ffffffffc0203f6e <memcpy>:
#ifdef __HAVE_ARCH_MEMCPY
    return __memcpy(dst, src, n);
#else
    const char *s = src;
    char *d = dst;
    while (n -- > 0) {
ffffffffc0203f6e:	ca19                	beqz	a2,ffffffffc0203f84 <memcpy+0x16>
ffffffffc0203f70:	962e                	add	a2,a2,a1
    char *d = dst;
ffffffffc0203f72:	87aa                	mv	a5,a0
        *d ++ = *s ++;
ffffffffc0203f74:	0005c703          	lbu	a4,0(a1)
ffffffffc0203f78:	0585                	addi	a1,a1,1
ffffffffc0203f7a:	0785                	addi	a5,a5,1
ffffffffc0203f7c:	fee78fa3          	sb	a4,-1(a5)
    while (n -- > 0) {
ffffffffc0203f80:	fec59ae3          	bne	a1,a2,ffffffffc0203f74 <memcpy+0x6>
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
ffffffffc0203f84:	8082                	ret

ffffffffc0203f86 <printnum>:
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
    unsigned long long result = num;
    unsigned mod = do_div(result, base);
ffffffffc0203f86:	02069813          	slli	a6,a3,0x20
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc0203f8a:	7179                	addi	sp,sp,-48
    unsigned mod = do_div(result, base);
ffffffffc0203f8c:	02085813          	srli	a6,a6,0x20
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc0203f90:	e052                	sd	s4,0(sp)
    unsigned mod = do_div(result, base);
ffffffffc0203f92:	03067a33          	remu	s4,a2,a6
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc0203f96:	f022                	sd	s0,32(sp)
ffffffffc0203f98:	ec26                	sd	s1,24(sp)
ffffffffc0203f9a:	e84a                	sd	s2,16(sp)
ffffffffc0203f9c:	f406                	sd	ra,40(sp)
ffffffffc0203f9e:	e44e                	sd	s3,8(sp)
ffffffffc0203fa0:	84aa                	mv	s1,a0
ffffffffc0203fa2:	892e                	mv	s2,a1
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
ffffffffc0203fa4:	fff7041b          	addiw	s0,a4,-1
    unsigned mod = do_div(result, base);
ffffffffc0203fa8:	2a01                	sext.w	s4,s4
    if (num >= base) {
ffffffffc0203faa:	03067e63          	bgeu	a2,a6,ffffffffc0203fe6 <printnum+0x60>
ffffffffc0203fae:	89be                	mv	s3,a5
        while (-- width > 0)
ffffffffc0203fb0:	00805763          	blez	s0,ffffffffc0203fbe <printnum+0x38>
ffffffffc0203fb4:	347d                	addiw	s0,s0,-1
            putch(padc, putdat);
ffffffffc0203fb6:	85ca                	mv	a1,s2
ffffffffc0203fb8:	854e                	mv	a0,s3
ffffffffc0203fba:	9482                	jalr	s1
        while (-- width > 0)
ffffffffc0203fbc:	fc65                	bnez	s0,ffffffffc0203fb4 <printnum+0x2e>
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
ffffffffc0203fbe:	1a02                	slli	s4,s4,0x20
ffffffffc0203fc0:	00002797          	auipc	a5,0x2
ffffffffc0203fc4:	04078793          	addi	a5,a5,64 # ffffffffc0206000 <default_pmm_manager+0x768>
ffffffffc0203fc8:	020a5a13          	srli	s4,s4,0x20
ffffffffc0203fcc:	9a3e                	add	s4,s4,a5
}
ffffffffc0203fce:	7402                	ld	s0,32(sp)
    putch("0123456789abcdef"[mod], putdat);
ffffffffc0203fd0:	000a4503          	lbu	a0,0(s4)
}
ffffffffc0203fd4:	70a2                	ld	ra,40(sp)
ffffffffc0203fd6:	69a2                	ld	s3,8(sp)
ffffffffc0203fd8:	6a02                	ld	s4,0(sp)
    putch("0123456789abcdef"[mod], putdat);
ffffffffc0203fda:	85ca                	mv	a1,s2
ffffffffc0203fdc:	87a6                	mv	a5,s1
}
ffffffffc0203fde:	6942                	ld	s2,16(sp)
ffffffffc0203fe0:	64e2                	ld	s1,24(sp)
ffffffffc0203fe2:	6145                	addi	sp,sp,48
    putch("0123456789abcdef"[mod], putdat);
ffffffffc0203fe4:	8782                	jr	a5
        printnum(putch, putdat, result, base, width - 1, padc);
ffffffffc0203fe6:	03065633          	divu	a2,a2,a6
ffffffffc0203fea:	8722                	mv	a4,s0
ffffffffc0203fec:	f9bff0ef          	jal	ra,ffffffffc0203f86 <printnum>
ffffffffc0203ff0:	b7f9                	j	ffffffffc0203fbe <printnum+0x38>

ffffffffc0203ff2 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
ffffffffc0203ff2:	7119                	addi	sp,sp,-128
ffffffffc0203ff4:	f4a6                	sd	s1,104(sp)
ffffffffc0203ff6:	f0ca                	sd	s2,96(sp)
ffffffffc0203ff8:	ecce                	sd	s3,88(sp)
ffffffffc0203ffa:	e8d2                	sd	s4,80(sp)
ffffffffc0203ffc:	e4d6                	sd	s5,72(sp)
ffffffffc0203ffe:	e0da                	sd	s6,64(sp)
ffffffffc0204000:	fc5e                	sd	s7,56(sp)
ffffffffc0204002:	f06a                	sd	s10,32(sp)
ffffffffc0204004:	fc86                	sd	ra,120(sp)
ffffffffc0204006:	f8a2                	sd	s0,112(sp)
ffffffffc0204008:	f862                	sd	s8,48(sp)
ffffffffc020400a:	f466                	sd	s9,40(sp)
ffffffffc020400c:	ec6e                	sd	s11,24(sp)
ffffffffc020400e:	892a                	mv	s2,a0
ffffffffc0204010:	84ae                	mv	s1,a1
ffffffffc0204012:	8d32                	mv	s10,a2
ffffffffc0204014:	8a36                	mv	s4,a3
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc0204016:	02500993          	li	s3,37
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
        width = precision = -1;
ffffffffc020401a:	5b7d                	li	s6,-1
ffffffffc020401c:	00002a97          	auipc	s5,0x2
ffffffffc0204020:	018a8a93          	addi	s5,s5,24 # ffffffffc0206034 <default_pmm_manager+0x79c>
        case 'e':
            err = va_arg(ap, int);
            if (err < 0) {
                err = -err;
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
ffffffffc0204024:	00002b97          	auipc	s7,0x2
ffffffffc0204028:	1ecb8b93          	addi	s7,s7,492 # ffffffffc0206210 <error_string>
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc020402c:	000d4503          	lbu	a0,0(s10) # 80000 <kern_entry-0xffffffffc0180000>
ffffffffc0204030:	001d0413          	addi	s0,s10,1
ffffffffc0204034:	01350a63          	beq	a0,s3,ffffffffc0204048 <vprintfmt+0x56>
            if (ch == '\0') {
ffffffffc0204038:	c121                	beqz	a0,ffffffffc0204078 <vprintfmt+0x86>
            putch(ch, putdat);
ffffffffc020403a:	85a6                	mv	a1,s1
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc020403c:	0405                	addi	s0,s0,1
            putch(ch, putdat);
ffffffffc020403e:	9902                	jalr	s2
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc0204040:	fff44503          	lbu	a0,-1(s0)
ffffffffc0204044:	ff351ae3          	bne	a0,s3,ffffffffc0204038 <vprintfmt+0x46>
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0204048:	00044603          	lbu	a2,0(s0)
        char padc = ' ';
ffffffffc020404c:	02000793          	li	a5,32
        lflag = altflag = 0;
ffffffffc0204050:	4c81                	li	s9,0
ffffffffc0204052:	4881                	li	a7,0
        width = precision = -1;
ffffffffc0204054:	5c7d                	li	s8,-1
ffffffffc0204056:	5dfd                	li	s11,-1
ffffffffc0204058:	05500513          	li	a0,85
                if (ch < '0' || ch > '9') {
ffffffffc020405c:	4825                	li	a6,9
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc020405e:	fdd6059b          	addiw	a1,a2,-35
ffffffffc0204062:	0ff5f593          	zext.b	a1,a1
ffffffffc0204066:	00140d13          	addi	s10,s0,1
ffffffffc020406a:	04b56263          	bltu	a0,a1,ffffffffc02040ae <vprintfmt+0xbc>
ffffffffc020406e:	058a                	slli	a1,a1,0x2
ffffffffc0204070:	95d6                	add	a1,a1,s5
ffffffffc0204072:	4194                	lw	a3,0(a1)
ffffffffc0204074:	96d6                	add	a3,a3,s5
ffffffffc0204076:	8682                	jr	a3
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
ffffffffc0204078:	70e6                	ld	ra,120(sp)
ffffffffc020407a:	7446                	ld	s0,112(sp)
ffffffffc020407c:	74a6                	ld	s1,104(sp)
ffffffffc020407e:	7906                	ld	s2,96(sp)
ffffffffc0204080:	69e6                	ld	s3,88(sp)
ffffffffc0204082:	6a46                	ld	s4,80(sp)
ffffffffc0204084:	6aa6                	ld	s5,72(sp)
ffffffffc0204086:	6b06                	ld	s6,64(sp)
ffffffffc0204088:	7be2                	ld	s7,56(sp)
ffffffffc020408a:	7c42                	ld	s8,48(sp)
ffffffffc020408c:	7ca2                	ld	s9,40(sp)
ffffffffc020408e:	7d02                	ld	s10,32(sp)
ffffffffc0204090:	6de2                	ld	s11,24(sp)
ffffffffc0204092:	6109                	addi	sp,sp,128
ffffffffc0204094:	8082                	ret
            padc = '0';
ffffffffc0204096:	87b2                	mv	a5,a2
            goto reswitch;
ffffffffc0204098:	00144603          	lbu	a2,1(s0)
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc020409c:	846a                	mv	s0,s10
ffffffffc020409e:	00140d13          	addi	s10,s0,1
ffffffffc02040a2:	fdd6059b          	addiw	a1,a2,-35
ffffffffc02040a6:	0ff5f593          	zext.b	a1,a1
ffffffffc02040aa:	fcb572e3          	bgeu	a0,a1,ffffffffc020406e <vprintfmt+0x7c>
            putch('%', putdat);
ffffffffc02040ae:	85a6                	mv	a1,s1
ffffffffc02040b0:	02500513          	li	a0,37
ffffffffc02040b4:	9902                	jalr	s2
            for (fmt --; fmt[-1] != '%'; fmt --)
ffffffffc02040b6:	fff44783          	lbu	a5,-1(s0)
ffffffffc02040ba:	8d22                	mv	s10,s0
ffffffffc02040bc:	f73788e3          	beq	a5,s3,ffffffffc020402c <vprintfmt+0x3a>
ffffffffc02040c0:	ffed4783          	lbu	a5,-2(s10)
ffffffffc02040c4:	1d7d                	addi	s10,s10,-1
ffffffffc02040c6:	ff379de3          	bne	a5,s3,ffffffffc02040c0 <vprintfmt+0xce>
ffffffffc02040ca:	b78d                	j	ffffffffc020402c <vprintfmt+0x3a>
                precision = precision * 10 + ch - '0';
ffffffffc02040cc:	fd060c1b          	addiw	s8,a2,-48
                ch = *fmt;
ffffffffc02040d0:	00144603          	lbu	a2,1(s0)
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc02040d4:	846a                	mv	s0,s10
                if (ch < '0' || ch > '9') {
ffffffffc02040d6:	fd06069b          	addiw	a3,a2,-48
                ch = *fmt;
ffffffffc02040da:	0006059b          	sext.w	a1,a2
                if (ch < '0' || ch > '9') {
ffffffffc02040de:	02d86463          	bltu	a6,a3,ffffffffc0204106 <vprintfmt+0x114>
                ch = *fmt;
ffffffffc02040e2:	00144603          	lbu	a2,1(s0)
                precision = precision * 10 + ch - '0';
ffffffffc02040e6:	002c169b          	slliw	a3,s8,0x2
ffffffffc02040ea:	0186873b          	addw	a4,a3,s8
ffffffffc02040ee:	0017171b          	slliw	a4,a4,0x1
ffffffffc02040f2:	9f2d                	addw	a4,a4,a1
                if (ch < '0' || ch > '9') {
ffffffffc02040f4:	fd06069b          	addiw	a3,a2,-48
            for (precision = 0; ; ++ fmt) {
ffffffffc02040f8:	0405                	addi	s0,s0,1
                precision = precision * 10 + ch - '0';
ffffffffc02040fa:	fd070c1b          	addiw	s8,a4,-48
                ch = *fmt;
ffffffffc02040fe:	0006059b          	sext.w	a1,a2
                if (ch < '0' || ch > '9') {
ffffffffc0204102:	fed870e3          	bgeu	a6,a3,ffffffffc02040e2 <vprintfmt+0xf0>
            if (width < 0)
ffffffffc0204106:	f40ddce3          	bgez	s11,ffffffffc020405e <vprintfmt+0x6c>
                width = precision, precision = -1;
ffffffffc020410a:	8de2                	mv	s11,s8
ffffffffc020410c:	5c7d                	li	s8,-1
ffffffffc020410e:	bf81                	j	ffffffffc020405e <vprintfmt+0x6c>
            if (width < 0)
ffffffffc0204110:	fffdc693          	not	a3,s11
ffffffffc0204114:	96fd                	srai	a3,a3,0x3f
ffffffffc0204116:	00ddfdb3          	and	s11,s11,a3
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc020411a:	00144603          	lbu	a2,1(s0)
ffffffffc020411e:	2d81                	sext.w	s11,s11
ffffffffc0204120:	846a                	mv	s0,s10
            goto reswitch;
ffffffffc0204122:	bf35                	j	ffffffffc020405e <vprintfmt+0x6c>
            precision = va_arg(ap, int);
ffffffffc0204124:	000a2c03          	lw	s8,0(s4)
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0204128:	00144603          	lbu	a2,1(s0)
            precision = va_arg(ap, int);
ffffffffc020412c:	0a21                	addi	s4,s4,8
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc020412e:	846a                	mv	s0,s10
            goto process_precision;
ffffffffc0204130:	bfd9                	j	ffffffffc0204106 <vprintfmt+0x114>
    if (lflag >= 2) {
ffffffffc0204132:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc0204134:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
ffffffffc0204138:	01174463          	blt	a4,a7,ffffffffc0204140 <vprintfmt+0x14e>
    else if (lflag) {
ffffffffc020413c:	1a088e63          	beqz	a7,ffffffffc02042f8 <vprintfmt+0x306>
        return va_arg(*ap, unsigned long);
ffffffffc0204140:	000a3603          	ld	a2,0(s4)
ffffffffc0204144:	46c1                	li	a3,16
ffffffffc0204146:	8a2e                	mv	s4,a1
            printnum(putch, putdat, num, base, width, padc);
ffffffffc0204148:	2781                	sext.w	a5,a5
ffffffffc020414a:	876e                	mv	a4,s11
ffffffffc020414c:	85a6                	mv	a1,s1
ffffffffc020414e:	854a                	mv	a0,s2
ffffffffc0204150:	e37ff0ef          	jal	ra,ffffffffc0203f86 <printnum>
            break;
ffffffffc0204154:	bde1                	j	ffffffffc020402c <vprintfmt+0x3a>
            putch(va_arg(ap, int), putdat);
ffffffffc0204156:	000a2503          	lw	a0,0(s4)
ffffffffc020415a:	85a6                	mv	a1,s1
ffffffffc020415c:	0a21                	addi	s4,s4,8
ffffffffc020415e:	9902                	jalr	s2
            break;
ffffffffc0204160:	b5f1                	j	ffffffffc020402c <vprintfmt+0x3a>
    if (lflag >= 2) {
ffffffffc0204162:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc0204164:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
ffffffffc0204168:	01174463          	blt	a4,a7,ffffffffc0204170 <vprintfmt+0x17e>
    else if (lflag) {
ffffffffc020416c:	18088163          	beqz	a7,ffffffffc02042ee <vprintfmt+0x2fc>
        return va_arg(*ap, unsigned long);
ffffffffc0204170:	000a3603          	ld	a2,0(s4)
ffffffffc0204174:	46a9                	li	a3,10
ffffffffc0204176:	8a2e                	mv	s4,a1
ffffffffc0204178:	bfc1                	j	ffffffffc0204148 <vprintfmt+0x156>
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc020417a:	00144603          	lbu	a2,1(s0)
            altflag = 1;
ffffffffc020417e:	4c85                	li	s9,1
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0204180:	846a                	mv	s0,s10
            goto reswitch;
ffffffffc0204182:	bdf1                	j	ffffffffc020405e <vprintfmt+0x6c>
            putch(ch, putdat);
ffffffffc0204184:	85a6                	mv	a1,s1
ffffffffc0204186:	02500513          	li	a0,37
ffffffffc020418a:	9902                	jalr	s2
            break;
ffffffffc020418c:	b545                	j	ffffffffc020402c <vprintfmt+0x3a>
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc020418e:	00144603          	lbu	a2,1(s0)
            lflag ++;
ffffffffc0204192:	2885                	addiw	a7,a7,1
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0204194:	846a                	mv	s0,s10
            goto reswitch;
ffffffffc0204196:	b5e1                	j	ffffffffc020405e <vprintfmt+0x6c>
    if (lflag >= 2) {
ffffffffc0204198:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc020419a:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
ffffffffc020419e:	01174463          	blt	a4,a7,ffffffffc02041a6 <vprintfmt+0x1b4>
    else if (lflag) {
ffffffffc02041a2:	14088163          	beqz	a7,ffffffffc02042e4 <vprintfmt+0x2f2>
        return va_arg(*ap, unsigned long);
ffffffffc02041a6:	000a3603          	ld	a2,0(s4)
ffffffffc02041aa:	46a1                	li	a3,8
ffffffffc02041ac:	8a2e                	mv	s4,a1
ffffffffc02041ae:	bf69                	j	ffffffffc0204148 <vprintfmt+0x156>
            putch('0', putdat);
ffffffffc02041b0:	03000513          	li	a0,48
ffffffffc02041b4:	85a6                	mv	a1,s1
ffffffffc02041b6:	e03e                	sd	a5,0(sp)
ffffffffc02041b8:	9902                	jalr	s2
            putch('x', putdat);
ffffffffc02041ba:	85a6                	mv	a1,s1
ffffffffc02041bc:	07800513          	li	a0,120
ffffffffc02041c0:	9902                	jalr	s2
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
ffffffffc02041c2:	0a21                	addi	s4,s4,8
            goto number;
ffffffffc02041c4:	6782                	ld	a5,0(sp)
ffffffffc02041c6:	46c1                	li	a3,16
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
ffffffffc02041c8:	ff8a3603          	ld	a2,-8(s4)
            goto number;
ffffffffc02041cc:	bfb5                	j	ffffffffc0204148 <vprintfmt+0x156>
            if ((p = va_arg(ap, char *)) == NULL) {
ffffffffc02041ce:	000a3403          	ld	s0,0(s4)
ffffffffc02041d2:	008a0713          	addi	a4,s4,8
ffffffffc02041d6:	e03a                	sd	a4,0(sp)
ffffffffc02041d8:	14040263          	beqz	s0,ffffffffc020431c <vprintfmt+0x32a>
            if (width > 0 && padc != '-') {
ffffffffc02041dc:	0fb05763          	blez	s11,ffffffffc02042ca <vprintfmt+0x2d8>
ffffffffc02041e0:	02d00693          	li	a3,45
ffffffffc02041e4:	0cd79163          	bne	a5,a3,ffffffffc02042a6 <vprintfmt+0x2b4>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc02041e8:	00044783          	lbu	a5,0(s0)
ffffffffc02041ec:	0007851b          	sext.w	a0,a5
ffffffffc02041f0:	cf85                	beqz	a5,ffffffffc0204228 <vprintfmt+0x236>
ffffffffc02041f2:	00140a13          	addi	s4,s0,1
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc02041f6:	05e00413          	li	s0,94
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc02041fa:	000c4563          	bltz	s8,ffffffffc0204204 <vprintfmt+0x212>
ffffffffc02041fe:	3c7d                	addiw	s8,s8,-1
ffffffffc0204200:	036c0263          	beq	s8,s6,ffffffffc0204224 <vprintfmt+0x232>
                    putch('?', putdat);
ffffffffc0204204:	85a6                	mv	a1,s1
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc0204206:	0e0c8e63          	beqz	s9,ffffffffc0204302 <vprintfmt+0x310>
ffffffffc020420a:	3781                	addiw	a5,a5,-32
ffffffffc020420c:	0ef47b63          	bgeu	s0,a5,ffffffffc0204302 <vprintfmt+0x310>
                    putch('?', putdat);
ffffffffc0204210:	03f00513          	li	a0,63
ffffffffc0204214:	9902                	jalr	s2
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0204216:	000a4783          	lbu	a5,0(s4)
ffffffffc020421a:	3dfd                	addiw	s11,s11,-1
ffffffffc020421c:	0a05                	addi	s4,s4,1
ffffffffc020421e:	0007851b          	sext.w	a0,a5
ffffffffc0204222:	ffe1                	bnez	a5,ffffffffc02041fa <vprintfmt+0x208>
            for (; width > 0; width --) {
ffffffffc0204224:	01b05963          	blez	s11,ffffffffc0204236 <vprintfmt+0x244>
ffffffffc0204228:	3dfd                	addiw	s11,s11,-1
                putch(' ', putdat);
ffffffffc020422a:	85a6                	mv	a1,s1
ffffffffc020422c:	02000513          	li	a0,32
ffffffffc0204230:	9902                	jalr	s2
            for (; width > 0; width --) {
ffffffffc0204232:	fe0d9be3          	bnez	s11,ffffffffc0204228 <vprintfmt+0x236>
            if ((p = va_arg(ap, char *)) == NULL) {
ffffffffc0204236:	6a02                	ld	s4,0(sp)
ffffffffc0204238:	bbd5                	j	ffffffffc020402c <vprintfmt+0x3a>
    if (lflag >= 2) {
ffffffffc020423a:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc020423c:	008a0c93          	addi	s9,s4,8
    if (lflag >= 2) {
ffffffffc0204240:	01174463          	blt	a4,a7,ffffffffc0204248 <vprintfmt+0x256>
    else if (lflag) {
ffffffffc0204244:	08088d63          	beqz	a7,ffffffffc02042de <vprintfmt+0x2ec>
        return va_arg(*ap, long);
ffffffffc0204248:	000a3403          	ld	s0,0(s4)
            if ((long long)num < 0) {
ffffffffc020424c:	0a044d63          	bltz	s0,ffffffffc0204306 <vprintfmt+0x314>
            num = getint(&ap, lflag);
ffffffffc0204250:	8622                	mv	a2,s0
ffffffffc0204252:	8a66                	mv	s4,s9
ffffffffc0204254:	46a9                	li	a3,10
ffffffffc0204256:	bdcd                	j	ffffffffc0204148 <vprintfmt+0x156>
            err = va_arg(ap, int);
ffffffffc0204258:	000a2783          	lw	a5,0(s4)
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
ffffffffc020425c:	4719                	li	a4,6
            err = va_arg(ap, int);
ffffffffc020425e:	0a21                	addi	s4,s4,8
            if (err < 0) {
ffffffffc0204260:	41f7d69b          	sraiw	a3,a5,0x1f
ffffffffc0204264:	8fb5                	xor	a5,a5,a3
ffffffffc0204266:	40d786bb          	subw	a3,a5,a3
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
ffffffffc020426a:	02d74163          	blt	a4,a3,ffffffffc020428c <vprintfmt+0x29a>
ffffffffc020426e:	00369793          	slli	a5,a3,0x3
ffffffffc0204272:	97de                	add	a5,a5,s7
ffffffffc0204274:	639c                	ld	a5,0(a5)
ffffffffc0204276:	cb99                	beqz	a5,ffffffffc020428c <vprintfmt+0x29a>
                printfmt(putch, putdat, "%s", p);
ffffffffc0204278:	86be                	mv	a3,a5
ffffffffc020427a:	00002617          	auipc	a2,0x2
ffffffffc020427e:	db660613          	addi	a2,a2,-586 # ffffffffc0206030 <default_pmm_manager+0x798>
ffffffffc0204282:	85a6                	mv	a1,s1
ffffffffc0204284:	854a                	mv	a0,s2
ffffffffc0204286:	0ce000ef          	jal	ra,ffffffffc0204354 <printfmt>
ffffffffc020428a:	b34d                	j	ffffffffc020402c <vprintfmt+0x3a>
                printfmt(putch, putdat, "error %d", err);
ffffffffc020428c:	00002617          	auipc	a2,0x2
ffffffffc0204290:	d9460613          	addi	a2,a2,-620 # ffffffffc0206020 <default_pmm_manager+0x788>
ffffffffc0204294:	85a6                	mv	a1,s1
ffffffffc0204296:	854a                	mv	a0,s2
ffffffffc0204298:	0bc000ef          	jal	ra,ffffffffc0204354 <printfmt>
ffffffffc020429c:	bb41                	j	ffffffffc020402c <vprintfmt+0x3a>
                p = "(null)";
ffffffffc020429e:	00002417          	auipc	s0,0x2
ffffffffc02042a2:	d7a40413          	addi	s0,s0,-646 # ffffffffc0206018 <default_pmm_manager+0x780>
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc02042a6:	85e2                	mv	a1,s8
ffffffffc02042a8:	8522                	mv	a0,s0
ffffffffc02042aa:	e43e                	sd	a5,8(sp)
ffffffffc02042ac:	c4fff0ef          	jal	ra,ffffffffc0203efa <strnlen>
ffffffffc02042b0:	40ad8dbb          	subw	s11,s11,a0
ffffffffc02042b4:	01b05b63          	blez	s11,ffffffffc02042ca <vprintfmt+0x2d8>
                    putch(padc, putdat);
ffffffffc02042b8:	67a2                	ld	a5,8(sp)
ffffffffc02042ba:	00078a1b          	sext.w	s4,a5
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc02042be:	3dfd                	addiw	s11,s11,-1
                    putch(padc, putdat);
ffffffffc02042c0:	85a6                	mv	a1,s1
ffffffffc02042c2:	8552                	mv	a0,s4
ffffffffc02042c4:	9902                	jalr	s2
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc02042c6:	fe0d9ce3          	bnez	s11,ffffffffc02042be <vprintfmt+0x2cc>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc02042ca:	00044783          	lbu	a5,0(s0)
ffffffffc02042ce:	00140a13          	addi	s4,s0,1
ffffffffc02042d2:	0007851b          	sext.w	a0,a5
ffffffffc02042d6:	d3a5                	beqz	a5,ffffffffc0204236 <vprintfmt+0x244>
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc02042d8:	05e00413          	li	s0,94
ffffffffc02042dc:	bf39                	j	ffffffffc02041fa <vprintfmt+0x208>
        return va_arg(*ap, int);
ffffffffc02042de:	000a2403          	lw	s0,0(s4)
ffffffffc02042e2:	b7ad                	j	ffffffffc020424c <vprintfmt+0x25a>
        return va_arg(*ap, unsigned int);
ffffffffc02042e4:	000a6603          	lwu	a2,0(s4)
ffffffffc02042e8:	46a1                	li	a3,8
ffffffffc02042ea:	8a2e                	mv	s4,a1
ffffffffc02042ec:	bdb1                	j	ffffffffc0204148 <vprintfmt+0x156>
ffffffffc02042ee:	000a6603          	lwu	a2,0(s4)
ffffffffc02042f2:	46a9                	li	a3,10
ffffffffc02042f4:	8a2e                	mv	s4,a1
ffffffffc02042f6:	bd89                	j	ffffffffc0204148 <vprintfmt+0x156>
ffffffffc02042f8:	000a6603          	lwu	a2,0(s4)
ffffffffc02042fc:	46c1                	li	a3,16
ffffffffc02042fe:	8a2e                	mv	s4,a1
ffffffffc0204300:	b5a1                	j	ffffffffc0204148 <vprintfmt+0x156>
                    putch(ch, putdat);
ffffffffc0204302:	9902                	jalr	s2
ffffffffc0204304:	bf09                	j	ffffffffc0204216 <vprintfmt+0x224>
                putch('-', putdat);
ffffffffc0204306:	85a6                	mv	a1,s1
ffffffffc0204308:	02d00513          	li	a0,45
ffffffffc020430c:	e03e                	sd	a5,0(sp)
ffffffffc020430e:	9902                	jalr	s2
                num = -(long long)num;
ffffffffc0204310:	6782                	ld	a5,0(sp)
ffffffffc0204312:	8a66                	mv	s4,s9
ffffffffc0204314:	40800633          	neg	a2,s0
ffffffffc0204318:	46a9                	li	a3,10
ffffffffc020431a:	b53d                	j	ffffffffc0204148 <vprintfmt+0x156>
            if (width > 0 && padc != '-') {
ffffffffc020431c:	03b05163          	blez	s11,ffffffffc020433e <vprintfmt+0x34c>
ffffffffc0204320:	02d00693          	li	a3,45
ffffffffc0204324:	f6d79de3          	bne	a5,a3,ffffffffc020429e <vprintfmt+0x2ac>
                p = "(null)";
ffffffffc0204328:	00002417          	auipc	s0,0x2
ffffffffc020432c:	cf040413          	addi	s0,s0,-784 # ffffffffc0206018 <default_pmm_manager+0x780>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0204330:	02800793          	li	a5,40
ffffffffc0204334:	02800513          	li	a0,40
ffffffffc0204338:	00140a13          	addi	s4,s0,1
ffffffffc020433c:	bd6d                	j	ffffffffc02041f6 <vprintfmt+0x204>
ffffffffc020433e:	00002a17          	auipc	s4,0x2
ffffffffc0204342:	cdba0a13          	addi	s4,s4,-805 # ffffffffc0206019 <default_pmm_manager+0x781>
ffffffffc0204346:	02800513          	li	a0,40
ffffffffc020434a:	02800793          	li	a5,40
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc020434e:	05e00413          	li	s0,94
ffffffffc0204352:	b565                	j	ffffffffc02041fa <vprintfmt+0x208>

ffffffffc0204354 <printfmt>:
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
ffffffffc0204354:	715d                	addi	sp,sp,-80
    va_start(ap, fmt);
ffffffffc0204356:	02810313          	addi	t1,sp,40
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
ffffffffc020435a:	f436                	sd	a3,40(sp)
    vprintfmt(putch, putdat, fmt, ap);
ffffffffc020435c:	869a                	mv	a3,t1
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
ffffffffc020435e:	ec06                	sd	ra,24(sp)
ffffffffc0204360:	f83a                	sd	a4,48(sp)
ffffffffc0204362:	fc3e                	sd	a5,56(sp)
ffffffffc0204364:	e0c2                	sd	a6,64(sp)
ffffffffc0204366:	e4c6                	sd	a7,72(sp)
    va_start(ap, fmt);
ffffffffc0204368:	e41a                	sd	t1,8(sp)
    vprintfmt(putch, putdat, fmt, ap);
ffffffffc020436a:	c89ff0ef          	jal	ra,ffffffffc0203ff2 <vprintfmt>
}
ffffffffc020436e:	60e2                	ld	ra,24(sp)
ffffffffc0204370:	6161                	addi	sp,sp,80
ffffffffc0204372:	8082                	ret

ffffffffc0204374 <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
ffffffffc0204374:	715d                	addi	sp,sp,-80
ffffffffc0204376:	e486                	sd	ra,72(sp)
ffffffffc0204378:	e0a6                	sd	s1,64(sp)
ffffffffc020437a:	fc4a                	sd	s2,56(sp)
ffffffffc020437c:	f84e                	sd	s3,48(sp)
ffffffffc020437e:	f452                	sd	s4,40(sp)
ffffffffc0204380:	f056                	sd	s5,32(sp)
ffffffffc0204382:	ec5a                	sd	s6,24(sp)
ffffffffc0204384:	e85e                	sd	s7,16(sp)
    if (prompt != NULL) {
ffffffffc0204386:	c901                	beqz	a0,ffffffffc0204396 <readline+0x22>
ffffffffc0204388:	85aa                	mv	a1,a0
        cprintf("%s", prompt);
ffffffffc020438a:	00002517          	auipc	a0,0x2
ffffffffc020438e:	ca650513          	addi	a0,a0,-858 # ffffffffc0206030 <default_pmm_manager+0x798>
ffffffffc0204392:	d29fb0ef          	jal	ra,ffffffffc02000ba <cprintf>
readline(const char *prompt) {
ffffffffc0204396:	4481                	li	s1,0
    while (1) {
        c = getchar();
        if (c < 0) {
            return NULL;
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
ffffffffc0204398:	497d                	li	s2,31
            cputchar(c);
            buf[i ++] = c;
        }
        else if (c == '\b' && i > 0) {
ffffffffc020439a:	49a1                	li	s3,8
            cputchar(c);
            i --;
        }
        else if (c == '\n' || c == '\r') {
ffffffffc020439c:	4aa9                	li	s5,10
ffffffffc020439e:	4b35                	li	s6,13
            buf[i ++] = c;
ffffffffc02043a0:	0000db97          	auipc	s7,0xd
ffffffffc02043a4:	d58b8b93          	addi	s7,s7,-680 # ffffffffc02110f8 <buf>
        else if (c >= ' ' && i < BUFSIZE - 1) {
ffffffffc02043a8:	3fe00a13          	li	s4,1022
        c = getchar();
ffffffffc02043ac:	d47fb0ef          	jal	ra,ffffffffc02000f2 <getchar>
        if (c < 0) {
ffffffffc02043b0:	00054a63          	bltz	a0,ffffffffc02043c4 <readline+0x50>
        else if (c >= ' ' && i < BUFSIZE - 1) {
ffffffffc02043b4:	00a95a63          	bge	s2,a0,ffffffffc02043c8 <readline+0x54>
ffffffffc02043b8:	029a5263          	bge	s4,s1,ffffffffc02043dc <readline+0x68>
        c = getchar();
ffffffffc02043bc:	d37fb0ef          	jal	ra,ffffffffc02000f2 <getchar>
        if (c < 0) {
ffffffffc02043c0:	fe055ae3          	bgez	a0,ffffffffc02043b4 <readline+0x40>
            return NULL;
ffffffffc02043c4:	4501                	li	a0,0
ffffffffc02043c6:	a091                	j	ffffffffc020440a <readline+0x96>
        else if (c == '\b' && i > 0) {
ffffffffc02043c8:	03351463          	bne	a0,s3,ffffffffc02043f0 <readline+0x7c>
ffffffffc02043cc:	e8a9                	bnez	s1,ffffffffc020441e <readline+0xaa>
        c = getchar();
ffffffffc02043ce:	d25fb0ef          	jal	ra,ffffffffc02000f2 <getchar>
        if (c < 0) {
ffffffffc02043d2:	fe0549e3          	bltz	a0,ffffffffc02043c4 <readline+0x50>
        else if (c >= ' ' && i < BUFSIZE - 1) {
ffffffffc02043d6:	fea959e3          	bge	s2,a0,ffffffffc02043c8 <readline+0x54>
ffffffffc02043da:	4481                	li	s1,0
            cputchar(c);
ffffffffc02043dc:	e42a                	sd	a0,8(sp)
ffffffffc02043de:	d13fb0ef          	jal	ra,ffffffffc02000f0 <cputchar>
            buf[i ++] = c;
ffffffffc02043e2:	6522                	ld	a0,8(sp)
ffffffffc02043e4:	009b87b3          	add	a5,s7,s1
ffffffffc02043e8:	2485                	addiw	s1,s1,1
ffffffffc02043ea:	00a78023          	sb	a0,0(a5)
ffffffffc02043ee:	bf7d                	j	ffffffffc02043ac <readline+0x38>
        else if (c == '\n' || c == '\r') {
ffffffffc02043f0:	01550463          	beq	a0,s5,ffffffffc02043f8 <readline+0x84>
ffffffffc02043f4:	fb651ce3          	bne	a0,s6,ffffffffc02043ac <readline+0x38>
            cputchar(c);
ffffffffc02043f8:	cf9fb0ef          	jal	ra,ffffffffc02000f0 <cputchar>
            buf[i] = '\0';
ffffffffc02043fc:	0000d517          	auipc	a0,0xd
ffffffffc0204400:	cfc50513          	addi	a0,a0,-772 # ffffffffc02110f8 <buf>
ffffffffc0204404:	94aa                	add	s1,s1,a0
ffffffffc0204406:	00048023          	sb	zero,0(s1)
            return buf;
        }
    }
}
ffffffffc020440a:	60a6                	ld	ra,72(sp)
ffffffffc020440c:	6486                	ld	s1,64(sp)
ffffffffc020440e:	7962                	ld	s2,56(sp)
ffffffffc0204410:	79c2                	ld	s3,48(sp)
ffffffffc0204412:	7a22                	ld	s4,40(sp)
ffffffffc0204414:	7a82                	ld	s5,32(sp)
ffffffffc0204416:	6b62                	ld	s6,24(sp)
ffffffffc0204418:	6bc2                	ld	s7,16(sp)
ffffffffc020441a:	6161                	addi	sp,sp,80
ffffffffc020441c:	8082                	ret
            cputchar(c);
ffffffffc020441e:	4521                	li	a0,8
ffffffffc0204420:	cd1fb0ef          	jal	ra,ffffffffc02000f0 <cputchar>
            i --;
ffffffffc0204424:	34fd                	addiw	s1,s1,-1
ffffffffc0204426:	b759                	j	ffffffffc02043ac <readline+0x38>
