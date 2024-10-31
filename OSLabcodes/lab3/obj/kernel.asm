
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
ffffffffc020004a:	7fd030ef          	jal	ra,ffffffffc0204046 <memset>

    const char *message = "(THU.CST) os is loading ...";
    cprintf("%s\n\n", message);
ffffffffc020004e:	00004597          	auipc	a1,0x4
ffffffffc0200052:	4ca58593          	addi	a1,a1,1226 # ffffffffc0204518 <etext+0x6>
ffffffffc0200056:	00004517          	auipc	a0,0x4
ffffffffc020005a:	4e250513          	addi	a0,a0,1250 # ffffffffc0204538 <etext+0x26>
ffffffffc020005e:	05c000ef          	jal	ra,ffffffffc02000ba <cprintf>

    print_kerninfo();
ffffffffc0200062:	0fc000ef          	jal	ra,ffffffffc020015e <print_kerninfo>

    // grade_backtrace();

    pmm_init();                 // init physical memory management
ffffffffc0200066:	795020ef          	jal	ra,ffffffffc0202ffa <pmm_init>

    idt_init();                 // init interrupt descriptor table
ffffffffc020006a:	4fa000ef          	jal	ra,ffffffffc0200564 <idt_init>

    vmm_init();                 // init virtual memory management
ffffffffc020006e:	423000ef          	jal	ra,ffffffffc0200c90 <vmm_init>

    ide_init();                 // init ide devices
ffffffffc0200072:	35e000ef          	jal	ra,ffffffffc02003d0 <ide_init>
    swap_init();                // init swap
ffffffffc0200076:	2d2010ef          	jal	ra,ffffffffc0201348 <swap_init>

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
ffffffffc02000ae:	02e040ef          	jal	ra,ffffffffc02040dc <vprintfmt>
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
ffffffffc02000e4:	7f9030ef          	jal	ra,ffffffffc02040dc <vprintfmt>
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
ffffffffc0200134:	41050513          	addi	a0,a0,1040 # ffffffffc0204540 <etext+0x2e>
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
ffffffffc020014a:	d8a50513          	addi	a0,a0,-630 # ffffffffc0205ed0 <default_pmm_manager+0x550>
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
ffffffffc0200164:	40050513          	addi	a0,a0,1024 # ffffffffc0204560 <etext+0x4e>
void print_kerninfo(void) {
ffffffffc0200168:	e406                	sd	ra,8(sp)
    cprintf("Special kernel symbols:\n");
ffffffffc020016a:	f51ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("  entry  0x%08x (virtual)\n", kern_init);
ffffffffc020016e:	00000597          	auipc	a1,0x0
ffffffffc0200172:	ec458593          	addi	a1,a1,-316 # ffffffffc0200032 <kern_init>
ffffffffc0200176:	00004517          	auipc	a0,0x4
ffffffffc020017a:	40a50513          	addi	a0,a0,1034 # ffffffffc0204580 <etext+0x6e>
ffffffffc020017e:	f3dff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("  etext  0x%08x (virtual)\n", etext);
ffffffffc0200182:	00004597          	auipc	a1,0x4
ffffffffc0200186:	39058593          	addi	a1,a1,912 # ffffffffc0204512 <etext>
ffffffffc020018a:	00004517          	auipc	a0,0x4
ffffffffc020018e:	41650513          	addi	a0,a0,1046 # ffffffffc02045a0 <etext+0x8e>
ffffffffc0200192:	f29ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("  edata  0x%08x (virtual)\n", edata);
ffffffffc0200196:	0000a597          	auipc	a1,0xa
ffffffffc020019a:	eaa58593          	addi	a1,a1,-342 # ffffffffc020a040 <ide>
ffffffffc020019e:	00004517          	auipc	a0,0x4
ffffffffc02001a2:	42250513          	addi	a0,a0,1058 # ffffffffc02045c0 <etext+0xae>
ffffffffc02001a6:	f15ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("  end    0x%08x (virtual)\n", end);
ffffffffc02001aa:	00011597          	auipc	a1,0x11
ffffffffc02001ae:	3c658593          	addi	a1,a1,966 # ffffffffc0211570 <end>
ffffffffc02001b2:	00004517          	auipc	a0,0x4
ffffffffc02001b6:	42e50513          	addi	a0,a0,1070 # ffffffffc02045e0 <etext+0xce>
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
ffffffffc02001e4:	42050513          	addi	a0,a0,1056 # ffffffffc0204600 <etext+0xee>
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
ffffffffc02001f2:	44260613          	addi	a2,a2,1090 # ffffffffc0204630 <etext+0x11e>
ffffffffc02001f6:	04e00593          	li	a1,78
ffffffffc02001fa:	00004517          	auipc	a0,0x4
ffffffffc02001fe:	44e50513          	addi	a0,a0,1102 # ffffffffc0204648 <etext+0x136>
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
ffffffffc020020e:	45660613          	addi	a2,a2,1110 # ffffffffc0204660 <etext+0x14e>
ffffffffc0200212:	00004597          	auipc	a1,0x4
ffffffffc0200216:	46e58593          	addi	a1,a1,1134 # ffffffffc0204680 <etext+0x16e>
ffffffffc020021a:	00004517          	auipc	a0,0x4
ffffffffc020021e:	46e50513          	addi	a0,a0,1134 # ffffffffc0204688 <etext+0x176>
mon_help(int argc, char **argv, struct trapframe *tf) {
ffffffffc0200222:	e406                	sd	ra,8(sp)
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
ffffffffc0200224:	e97ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc0200228:	00004617          	auipc	a2,0x4
ffffffffc020022c:	47060613          	addi	a2,a2,1136 # ffffffffc0204698 <etext+0x186>
ffffffffc0200230:	00004597          	auipc	a1,0x4
ffffffffc0200234:	49058593          	addi	a1,a1,1168 # ffffffffc02046c0 <etext+0x1ae>
ffffffffc0200238:	00004517          	auipc	a0,0x4
ffffffffc020023c:	45050513          	addi	a0,a0,1104 # ffffffffc0204688 <etext+0x176>
ffffffffc0200240:	e7bff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc0200244:	00004617          	auipc	a2,0x4
ffffffffc0200248:	48c60613          	addi	a2,a2,1164 # ffffffffc02046d0 <etext+0x1be>
ffffffffc020024c:	00004597          	auipc	a1,0x4
ffffffffc0200250:	4a458593          	addi	a1,a1,1188 # ffffffffc02046f0 <etext+0x1de>
ffffffffc0200254:	00004517          	auipc	a0,0x4
ffffffffc0200258:	43450513          	addi	a0,a0,1076 # ffffffffc0204688 <etext+0x176>
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
ffffffffc0200292:	47250513          	addi	a0,a0,1138 # ffffffffc0204700 <etext+0x1ee>
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
ffffffffc02002b4:	47850513          	addi	a0,a0,1144 # ffffffffc0204728 <etext+0x216>
ffffffffc02002b8:	e03ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    if (tf != NULL) {
ffffffffc02002bc:	000b8563          	beqz	s7,ffffffffc02002c6 <kmonitor+0x3e>
        print_trapframe(tf);
ffffffffc02002c0:	855e                	mv	a0,s7
ffffffffc02002c2:	48c000ef          	jal	ra,ffffffffc020074e <print_trapframe>
ffffffffc02002c6:	00004c17          	auipc	s8,0x4
ffffffffc02002ca:	4cac0c13          	addi	s8,s8,1226 # ffffffffc0204790 <commands>
        if ((buf = readline("")) != NULL) {
ffffffffc02002ce:	00005917          	auipc	s2,0x5
ffffffffc02002d2:	25290913          	addi	s2,s2,594 # ffffffffc0205520 <commands+0xd90>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
ffffffffc02002d6:	00004497          	auipc	s1,0x4
ffffffffc02002da:	47a48493          	addi	s1,s1,1146 # ffffffffc0204750 <etext+0x23e>
        if (argc == MAXARGS - 1) {
ffffffffc02002de:	49bd                	li	s3,15
            cprintf("Too many arguments (max %d).\n", MAXARGS);
ffffffffc02002e0:	00004b17          	auipc	s6,0x4
ffffffffc02002e4:	478b0b13          	addi	s6,s6,1144 # ffffffffc0204758 <etext+0x246>
        argv[argc ++] = buf;
ffffffffc02002e8:	00004a17          	auipc	s4,0x4
ffffffffc02002ec:	398a0a13          	addi	s4,s4,920 # ffffffffc0204680 <etext+0x16e>
    for (i = 0; i < NCOMMANDS; i ++) {
ffffffffc02002f0:	4a8d                	li	s5,3
        if ((buf = readline("")) != NULL) {
ffffffffc02002f2:	854a                	mv	a0,s2
ffffffffc02002f4:	16a040ef          	jal	ra,ffffffffc020445e <readline>
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
ffffffffc020030e:	486d0d13          	addi	s10,s10,1158 # ffffffffc0204790 <commands>
        argv[argc ++] = buf;
ffffffffc0200312:	8552                	mv	a0,s4
    for (i = 0; i < NCOMMANDS; i ++) {
ffffffffc0200314:	4401                	li	s0,0
ffffffffc0200316:	0d61                	addi	s10,s10,24
        if (strcmp(commands[i].name, argv[0]) == 0) {
ffffffffc0200318:	4fb030ef          	jal	ra,ffffffffc0204012 <strcmp>
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
ffffffffc020032c:	4e7030ef          	jal	ra,ffffffffc0204012 <strcmp>
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
ffffffffc020036a:	4c7030ef          	jal	ra,ffffffffc0204030 <strchr>
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
ffffffffc02003a8:	489030ef          	jal	ra,ffffffffc0204030 <strchr>
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
ffffffffc02003c6:	3b650513          	addi	a0,a0,950 # ffffffffc0204778 <etext+0x266>
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
ffffffffc02003f6:	463030ef          	jal	ra,ffffffffc0204058 <memcpy>
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
ffffffffc020041a:	43f030ef          	jal	ra,ffffffffc0204058 <memcpy>
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
ffffffffc0200450:	38c50513          	addi	a0,a0,908 # ffffffffc02047d8 <commands+0x48>
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
ffffffffc0200528:	2d450513          	addi	a0,a0,724 # ffffffffc02047f8 <commands+0x68>
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
ffffffffc0200550:	2cc60613          	addi	a2,a2,716 # ffffffffc0204818 <commands+0x88>
ffffffffc0200554:	07800593          	li	a1,120
ffffffffc0200558:	00004517          	auipc	a0,0x4
ffffffffc020055c:	2d850513          	addi	a0,a0,728 # ffffffffc0204830 <commands+0xa0>
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
ffffffffc020058e:	2be50513          	addi	a0,a0,702 # ffffffffc0204848 <commands+0xb8>
void print_regs(struct pushregs *gpr) {
ffffffffc0200592:	e406                	sd	ra,8(sp)
    cprintf("  zero     0x%08x\n", gpr->zero);
ffffffffc0200594:	b27ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("  ra       0x%08x\n", gpr->ra);
ffffffffc0200598:	640c                	ld	a1,8(s0)
ffffffffc020059a:	00004517          	auipc	a0,0x4
ffffffffc020059e:	2c650513          	addi	a0,a0,710 # ffffffffc0204860 <commands+0xd0>
ffffffffc02005a2:	b19ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("  sp       0x%08x\n", gpr->sp);
ffffffffc02005a6:	680c                	ld	a1,16(s0)
ffffffffc02005a8:	00004517          	auipc	a0,0x4
ffffffffc02005ac:	2d050513          	addi	a0,a0,720 # ffffffffc0204878 <commands+0xe8>
ffffffffc02005b0:	b0bff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("  gp       0x%08x\n", gpr->gp);
ffffffffc02005b4:	6c0c                	ld	a1,24(s0)
ffffffffc02005b6:	00004517          	auipc	a0,0x4
ffffffffc02005ba:	2da50513          	addi	a0,a0,730 # ffffffffc0204890 <commands+0x100>
ffffffffc02005be:	afdff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("  tp       0x%08x\n", gpr->tp);
ffffffffc02005c2:	700c                	ld	a1,32(s0)
ffffffffc02005c4:	00004517          	auipc	a0,0x4
ffffffffc02005c8:	2e450513          	addi	a0,a0,740 # ffffffffc02048a8 <commands+0x118>
ffffffffc02005cc:	aefff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("  t0       0x%08x\n", gpr->t0);
ffffffffc02005d0:	740c                	ld	a1,40(s0)
ffffffffc02005d2:	00004517          	auipc	a0,0x4
ffffffffc02005d6:	2ee50513          	addi	a0,a0,750 # ffffffffc02048c0 <commands+0x130>
ffffffffc02005da:	ae1ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("  t1       0x%08x\n", gpr->t1);
ffffffffc02005de:	780c                	ld	a1,48(s0)
ffffffffc02005e0:	00004517          	auipc	a0,0x4
ffffffffc02005e4:	2f850513          	addi	a0,a0,760 # ffffffffc02048d8 <commands+0x148>
ffffffffc02005e8:	ad3ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("  t2       0x%08x\n", gpr->t2);
ffffffffc02005ec:	7c0c                	ld	a1,56(s0)
ffffffffc02005ee:	00004517          	auipc	a0,0x4
ffffffffc02005f2:	30250513          	addi	a0,a0,770 # ffffffffc02048f0 <commands+0x160>
ffffffffc02005f6:	ac5ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("  s0       0x%08x\n", gpr->s0);
ffffffffc02005fa:	602c                	ld	a1,64(s0)
ffffffffc02005fc:	00004517          	auipc	a0,0x4
ffffffffc0200600:	30c50513          	addi	a0,a0,780 # ffffffffc0204908 <commands+0x178>
ffffffffc0200604:	ab7ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("  s1       0x%08x\n", gpr->s1);
ffffffffc0200608:	642c                	ld	a1,72(s0)
ffffffffc020060a:	00004517          	auipc	a0,0x4
ffffffffc020060e:	31650513          	addi	a0,a0,790 # ffffffffc0204920 <commands+0x190>
ffffffffc0200612:	aa9ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("  a0       0x%08x\n", gpr->a0);
ffffffffc0200616:	682c                	ld	a1,80(s0)
ffffffffc0200618:	00004517          	auipc	a0,0x4
ffffffffc020061c:	32050513          	addi	a0,a0,800 # ffffffffc0204938 <commands+0x1a8>
ffffffffc0200620:	a9bff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("  a1       0x%08x\n", gpr->a1);
ffffffffc0200624:	6c2c                	ld	a1,88(s0)
ffffffffc0200626:	00004517          	auipc	a0,0x4
ffffffffc020062a:	32a50513          	addi	a0,a0,810 # ffffffffc0204950 <commands+0x1c0>
ffffffffc020062e:	a8dff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("  a2       0x%08x\n", gpr->a2);
ffffffffc0200632:	702c                	ld	a1,96(s0)
ffffffffc0200634:	00004517          	auipc	a0,0x4
ffffffffc0200638:	33450513          	addi	a0,a0,820 # ffffffffc0204968 <commands+0x1d8>
ffffffffc020063c:	a7fff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("  a3       0x%08x\n", gpr->a3);
ffffffffc0200640:	742c                	ld	a1,104(s0)
ffffffffc0200642:	00004517          	auipc	a0,0x4
ffffffffc0200646:	33e50513          	addi	a0,a0,830 # ffffffffc0204980 <commands+0x1f0>
ffffffffc020064a:	a71ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("  a4       0x%08x\n", gpr->a4);
ffffffffc020064e:	782c                	ld	a1,112(s0)
ffffffffc0200650:	00004517          	auipc	a0,0x4
ffffffffc0200654:	34850513          	addi	a0,a0,840 # ffffffffc0204998 <commands+0x208>
ffffffffc0200658:	a63ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("  a5       0x%08x\n", gpr->a5);
ffffffffc020065c:	7c2c                	ld	a1,120(s0)
ffffffffc020065e:	00004517          	auipc	a0,0x4
ffffffffc0200662:	35250513          	addi	a0,a0,850 # ffffffffc02049b0 <commands+0x220>
ffffffffc0200666:	a55ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("  a6       0x%08x\n", gpr->a6);
ffffffffc020066a:	604c                	ld	a1,128(s0)
ffffffffc020066c:	00004517          	auipc	a0,0x4
ffffffffc0200670:	35c50513          	addi	a0,a0,860 # ffffffffc02049c8 <commands+0x238>
ffffffffc0200674:	a47ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("  a7       0x%08x\n", gpr->a7);
ffffffffc0200678:	644c                	ld	a1,136(s0)
ffffffffc020067a:	00004517          	auipc	a0,0x4
ffffffffc020067e:	36650513          	addi	a0,a0,870 # ffffffffc02049e0 <commands+0x250>
ffffffffc0200682:	a39ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("  s2       0x%08x\n", gpr->s2);
ffffffffc0200686:	684c                	ld	a1,144(s0)
ffffffffc0200688:	00004517          	auipc	a0,0x4
ffffffffc020068c:	37050513          	addi	a0,a0,880 # ffffffffc02049f8 <commands+0x268>
ffffffffc0200690:	a2bff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("  s3       0x%08x\n", gpr->s3);
ffffffffc0200694:	6c4c                	ld	a1,152(s0)
ffffffffc0200696:	00004517          	auipc	a0,0x4
ffffffffc020069a:	37a50513          	addi	a0,a0,890 # ffffffffc0204a10 <commands+0x280>
ffffffffc020069e:	a1dff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("  s4       0x%08x\n", gpr->s4);
ffffffffc02006a2:	704c                	ld	a1,160(s0)
ffffffffc02006a4:	00004517          	auipc	a0,0x4
ffffffffc02006a8:	38450513          	addi	a0,a0,900 # ffffffffc0204a28 <commands+0x298>
ffffffffc02006ac:	a0fff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("  s5       0x%08x\n", gpr->s5);
ffffffffc02006b0:	744c                	ld	a1,168(s0)
ffffffffc02006b2:	00004517          	auipc	a0,0x4
ffffffffc02006b6:	38e50513          	addi	a0,a0,910 # ffffffffc0204a40 <commands+0x2b0>
ffffffffc02006ba:	a01ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("  s6       0x%08x\n", gpr->s6);
ffffffffc02006be:	784c                	ld	a1,176(s0)
ffffffffc02006c0:	00004517          	auipc	a0,0x4
ffffffffc02006c4:	39850513          	addi	a0,a0,920 # ffffffffc0204a58 <commands+0x2c8>
ffffffffc02006c8:	9f3ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("  s7       0x%08x\n", gpr->s7);
ffffffffc02006cc:	7c4c                	ld	a1,184(s0)
ffffffffc02006ce:	00004517          	auipc	a0,0x4
ffffffffc02006d2:	3a250513          	addi	a0,a0,930 # ffffffffc0204a70 <commands+0x2e0>
ffffffffc02006d6:	9e5ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("  s8       0x%08x\n", gpr->s8);
ffffffffc02006da:	606c                	ld	a1,192(s0)
ffffffffc02006dc:	00004517          	auipc	a0,0x4
ffffffffc02006e0:	3ac50513          	addi	a0,a0,940 # ffffffffc0204a88 <commands+0x2f8>
ffffffffc02006e4:	9d7ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("  s9       0x%08x\n", gpr->s9);
ffffffffc02006e8:	646c                	ld	a1,200(s0)
ffffffffc02006ea:	00004517          	auipc	a0,0x4
ffffffffc02006ee:	3b650513          	addi	a0,a0,950 # ffffffffc0204aa0 <commands+0x310>
ffffffffc02006f2:	9c9ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("  s10      0x%08x\n", gpr->s10);
ffffffffc02006f6:	686c                	ld	a1,208(s0)
ffffffffc02006f8:	00004517          	auipc	a0,0x4
ffffffffc02006fc:	3c050513          	addi	a0,a0,960 # ffffffffc0204ab8 <commands+0x328>
ffffffffc0200700:	9bbff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("  s11      0x%08x\n", gpr->s11);
ffffffffc0200704:	6c6c                	ld	a1,216(s0)
ffffffffc0200706:	00004517          	auipc	a0,0x4
ffffffffc020070a:	3ca50513          	addi	a0,a0,970 # ffffffffc0204ad0 <commands+0x340>
ffffffffc020070e:	9adff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("  t3       0x%08x\n", gpr->t3);
ffffffffc0200712:	706c                	ld	a1,224(s0)
ffffffffc0200714:	00004517          	auipc	a0,0x4
ffffffffc0200718:	3d450513          	addi	a0,a0,980 # ffffffffc0204ae8 <commands+0x358>
ffffffffc020071c:	99fff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("  t4       0x%08x\n", gpr->t4);
ffffffffc0200720:	746c                	ld	a1,232(s0)
ffffffffc0200722:	00004517          	auipc	a0,0x4
ffffffffc0200726:	3de50513          	addi	a0,a0,990 # ffffffffc0204b00 <commands+0x370>
ffffffffc020072a:	991ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("  t5       0x%08x\n", gpr->t5);
ffffffffc020072e:	786c                	ld	a1,240(s0)
ffffffffc0200730:	00004517          	auipc	a0,0x4
ffffffffc0200734:	3e850513          	addi	a0,a0,1000 # ffffffffc0204b18 <commands+0x388>
ffffffffc0200738:	983ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("  t6       0x%08x\n", gpr->t6);
ffffffffc020073c:	7c6c                	ld	a1,248(s0)
}
ffffffffc020073e:	6402                	ld	s0,0(sp)
ffffffffc0200740:	60a2                	ld	ra,8(sp)
    cprintf("  t6       0x%08x\n", gpr->t6);
ffffffffc0200742:	00004517          	auipc	a0,0x4
ffffffffc0200746:	3ee50513          	addi	a0,a0,1006 # ffffffffc0204b30 <commands+0x3a0>
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
ffffffffc020075a:	3f250513          	addi	a0,a0,1010 # ffffffffc0204b48 <commands+0x3b8>
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
ffffffffc0200772:	3f250513          	addi	a0,a0,1010 # ffffffffc0204b60 <commands+0x3d0>
ffffffffc0200776:	945ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("  epc      0x%08x\n", tf->epc);
ffffffffc020077a:	10843583          	ld	a1,264(s0)
ffffffffc020077e:	00004517          	auipc	a0,0x4
ffffffffc0200782:	3fa50513          	addi	a0,a0,1018 # ffffffffc0204b78 <commands+0x3e8>
ffffffffc0200786:	935ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("  badvaddr 0x%08x\n", tf->badvaddr);
ffffffffc020078a:	11043583          	ld	a1,272(s0)
ffffffffc020078e:	00004517          	auipc	a0,0x4
ffffffffc0200792:	40250513          	addi	a0,a0,1026 # ffffffffc0204b90 <commands+0x400>
ffffffffc0200796:	925ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("  cause    0x%08x\n", tf->cause);
ffffffffc020079a:	11843583          	ld	a1,280(s0)
}
ffffffffc020079e:	6402                	ld	s0,0(sp)
ffffffffc02007a0:	60a2                	ld	ra,8(sp)
    cprintf("  cause    0x%08x\n", tf->cause);
ffffffffc02007a2:	00004517          	auipc	a0,0x4
ffffffffc02007a6:	40650513          	addi	a0,a0,1030 # ffffffffc0204ba8 <commands+0x418>
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
ffffffffc02007c2:	4b270713          	addi	a4,a4,1202 # ffffffffc0204c70 <commands+0x4e0>
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
ffffffffc02007d4:	45050513          	addi	a0,a0,1104 # ffffffffc0204c20 <commands+0x490>
ffffffffc02007d8:	8e3ff06f          	j	ffffffffc02000ba <cprintf>
            cprintf("Hypervisor software interrupt\n");
ffffffffc02007dc:	00004517          	auipc	a0,0x4
ffffffffc02007e0:	42450513          	addi	a0,a0,1060 # ffffffffc0204c00 <commands+0x470>
ffffffffc02007e4:	8d7ff06f          	j	ffffffffc02000ba <cprintf>
            cprintf("User software interrupt\n");
ffffffffc02007e8:	00004517          	auipc	a0,0x4
ffffffffc02007ec:	3d850513          	addi	a0,a0,984 # ffffffffc0204bc0 <commands+0x430>
ffffffffc02007f0:	8cbff06f          	j	ffffffffc02000ba <cprintf>
            cprintf("Supervisor software interrupt\n");
ffffffffc02007f4:	00004517          	auipc	a0,0x4
ffffffffc02007f8:	3ec50513          	addi	a0,a0,1004 # ffffffffc0204be0 <commands+0x450>
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
ffffffffc020082a:	42a50513          	addi	a0,a0,1066 # ffffffffc0204c50 <commands+0x4c0>
ffffffffc020082e:	88dff06f          	j	ffffffffc02000ba <cprintf>
            print_trapframe(tf);
ffffffffc0200832:	bf31                	j	ffffffffc020074e <print_trapframe>
}
ffffffffc0200834:	60a2                	ld	ra,8(sp)
    cprintf("%d ticks\n", TICK_NUM);
ffffffffc0200836:	06400593          	li	a1,100
ffffffffc020083a:	00004517          	auipc	a0,0x4
ffffffffc020083e:	40650513          	addi	a0,a0,1030 # ffffffffc0204c40 <commands+0x4b0>
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
ffffffffc0200860:	5fc70713          	addi	a4,a4,1532 # ffffffffc0204e58 <commands+0x6c8>
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
ffffffffc0200872:	5d250513          	addi	a0,a0,1490 # ffffffffc0204e40 <commands+0x6b0>
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
ffffffffc0200894:	41050513          	addi	a0,a0,1040 # ffffffffc0204ca0 <commands+0x510>
}
ffffffffc0200898:	6442                	ld	s0,16(sp)
ffffffffc020089a:	60e2                	ld	ra,24(sp)
ffffffffc020089c:	64a2                	ld	s1,8(sp)
ffffffffc020089e:	6105                	addi	sp,sp,32
            cprintf("Instruction access fault\n");
ffffffffc02008a0:	81bff06f          	j	ffffffffc02000ba <cprintf>
ffffffffc02008a4:	00004517          	auipc	a0,0x4
ffffffffc02008a8:	41c50513          	addi	a0,a0,1052 # ffffffffc0204cc0 <commands+0x530>
ffffffffc02008ac:	b7f5                	j	ffffffffc0200898 <exception_handler+0x50>
            cprintf("Illegal instruction\n");
ffffffffc02008ae:	00004517          	auipc	a0,0x4
ffffffffc02008b2:	43250513          	addi	a0,a0,1074 # ffffffffc0204ce0 <commands+0x550>
ffffffffc02008b6:	b7cd                	j	ffffffffc0200898 <exception_handler+0x50>
            cprintf("Breakpoint\n");
ffffffffc02008b8:	00004517          	auipc	a0,0x4
ffffffffc02008bc:	44050513          	addi	a0,a0,1088 # ffffffffc0204cf8 <commands+0x568>
ffffffffc02008c0:	bfe1                	j	ffffffffc0200898 <exception_handler+0x50>
            cprintf("Load address misaligned\n");
ffffffffc02008c2:	00004517          	auipc	a0,0x4
ffffffffc02008c6:	44650513          	addi	a0,a0,1094 # ffffffffc0204d08 <commands+0x578>
ffffffffc02008ca:	b7f9                	j	ffffffffc0200898 <exception_handler+0x50>
            cprintf("Load access fault\n");
ffffffffc02008cc:	00004517          	auipc	a0,0x4
ffffffffc02008d0:	45c50513          	addi	a0,a0,1116 # ffffffffc0204d28 <commands+0x598>
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
ffffffffc02008ee:	45660613          	addi	a2,a2,1110 # ffffffffc0204d40 <commands+0x5b0>
ffffffffc02008f2:	0ca00593          	li	a1,202
ffffffffc02008f6:	00004517          	auipc	a0,0x4
ffffffffc02008fa:	f3a50513          	addi	a0,a0,-198 # ffffffffc0204830 <commands+0xa0>
ffffffffc02008fe:	805ff0ef          	jal	ra,ffffffffc0200102 <__panic>
            cprintf("AMO address misaligned\n");
ffffffffc0200902:	00004517          	auipc	a0,0x4
ffffffffc0200906:	45e50513          	addi	a0,a0,1118 # ffffffffc0204d60 <commands+0x5d0>
ffffffffc020090a:	b779                	j	ffffffffc0200898 <exception_handler+0x50>
            cprintf("Store/AMO access fault\n");
ffffffffc020090c:	00004517          	auipc	a0,0x4
ffffffffc0200910:	46c50513          	addi	a0,a0,1132 # ffffffffc0204d78 <commands+0x5e8>
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
ffffffffc020092e:	41660613          	addi	a2,a2,1046 # ffffffffc0204d40 <commands+0x5b0>
ffffffffc0200932:	0d400593          	li	a1,212
ffffffffc0200936:	00004517          	auipc	a0,0x4
ffffffffc020093a:	efa50513          	addi	a0,a0,-262 # ffffffffc0204830 <commands+0xa0>
ffffffffc020093e:	fc4ff0ef          	jal	ra,ffffffffc0200102 <__panic>
            cprintf("Environment call from U-mode\n");
ffffffffc0200942:	00004517          	auipc	a0,0x4
ffffffffc0200946:	44e50513          	addi	a0,a0,1102 # ffffffffc0204d90 <commands+0x600>
ffffffffc020094a:	b7b9                	j	ffffffffc0200898 <exception_handler+0x50>
            cprintf("Environment call from S-mode\n");
ffffffffc020094c:	00004517          	auipc	a0,0x4
ffffffffc0200950:	46450513          	addi	a0,a0,1124 # ffffffffc0204db0 <commands+0x620>
ffffffffc0200954:	b791                	j	ffffffffc0200898 <exception_handler+0x50>
            cprintf("Environment call from H-mode\n");
ffffffffc0200956:	00004517          	auipc	a0,0x4
ffffffffc020095a:	47a50513          	addi	a0,a0,1146 # ffffffffc0204dd0 <commands+0x640>
ffffffffc020095e:	bf2d                	j	ffffffffc0200898 <exception_handler+0x50>
            cprintf("Environment call from M-mode\n");
ffffffffc0200960:	00004517          	auipc	a0,0x4
ffffffffc0200964:	49050513          	addi	a0,a0,1168 # ffffffffc0204df0 <commands+0x660>
ffffffffc0200968:	bf05                	j	ffffffffc0200898 <exception_handler+0x50>
            cprintf("Instruction page fault\n");
ffffffffc020096a:	00004517          	auipc	a0,0x4
ffffffffc020096e:	4a650513          	addi	a0,a0,1190 # ffffffffc0204e10 <commands+0x680>
ffffffffc0200972:	b71d                	j	ffffffffc0200898 <exception_handler+0x50>
            cprintf("Load page fault\n");
ffffffffc0200974:	00004517          	auipc	a0,0x4
ffffffffc0200978:	4b450513          	addi	a0,a0,1204 # ffffffffc0204e28 <commands+0x698>
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
ffffffffc0200998:	3ac60613          	addi	a2,a2,940 # ffffffffc0204d40 <commands+0x5b0>
ffffffffc020099c:	0ea00593          	li	a1,234
ffffffffc02009a0:	00004517          	auipc	a0,0x4
ffffffffc02009a4:	e9050513          	addi	a0,a0,-368 # ffffffffc0204830 <commands+0xa0>
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
ffffffffc02009c4:	38060613          	addi	a2,a2,896 # ffffffffc0204d40 <commands+0x5b0>
ffffffffc02009c8:	0f100593          	li	a1,241
ffffffffc02009cc:	00004517          	auipc	a0,0x4
ffffffffc02009d0:	e6450513          	addi	a0,a0,-412 # ffffffffc0204830 <commands+0xa0>
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
ffffffffc0200ab6:	3e668693          	addi	a3,a3,998 # ffffffffc0204e98 <commands+0x708>
ffffffffc0200aba:	00004617          	auipc	a2,0x4
ffffffffc0200abe:	3fe60613          	addi	a2,a2,1022 # ffffffffc0204eb8 <commands+0x728>
ffffffffc0200ac2:	07d00593          	li	a1,125
ffffffffc0200ac6:	00004517          	auipc	a0,0x4
ffffffffc0200aca:	40a50513          	addi	a0,a0,1034 # ffffffffc0204ed0 <commands+0x740>
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
ffffffffc0200ade:	1de030ef          	jal	ra,ffffffffc0203cbc <kmalloc>
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
ffffffffc0200b0e:	6ef000ef          	jal	ra,ffffffffc02019fc <swap_init_mm>
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
ffffffffc0200b30:	18c030ef          	jal	ra,ffffffffc0203cbc <kmalloc>
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
ffffffffc0200bfe:	2e668693          	addi	a3,a3,742 # ffffffffc0204ee0 <commands+0x750>
ffffffffc0200c02:	00004617          	auipc	a2,0x4
ffffffffc0200c06:	2b660613          	addi	a2,a2,694 # ffffffffc0204eb8 <commands+0x728>
ffffffffc0200c0a:	08400593          	li	a1,132
ffffffffc0200c0e:	00004517          	auipc	a0,0x4
ffffffffc0200c12:	2c250513          	addi	a0,a0,706 # ffffffffc0204ed0 <commands+0x740>
ffffffffc0200c16:	cecff0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(prev->vm_end <= next->vm_start);
ffffffffc0200c1a:	00004697          	auipc	a3,0x4
ffffffffc0200c1e:	30668693          	addi	a3,a3,774 # ffffffffc0204f20 <commands+0x790>
ffffffffc0200c22:	00004617          	auipc	a2,0x4
ffffffffc0200c26:	29660613          	addi	a2,a2,662 # ffffffffc0204eb8 <commands+0x728>
ffffffffc0200c2a:	07c00593          	li	a1,124
ffffffffc0200c2e:	00004517          	auipc	a0,0x4
ffffffffc0200c32:	2a250513          	addi	a0,a0,674 # ffffffffc0204ed0 <commands+0x740>
ffffffffc0200c36:	cccff0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(prev->vm_start < prev->vm_end);
ffffffffc0200c3a:	00004697          	auipc	a3,0x4
ffffffffc0200c3e:	2c668693          	addi	a3,a3,710 # ffffffffc0204f00 <commands+0x770>
ffffffffc0200c42:	00004617          	auipc	a2,0x4
ffffffffc0200c46:	27660613          	addi	a2,a2,630 # ffffffffc0204eb8 <commands+0x728>
ffffffffc0200c4a:	07b00593          	li	a1,123
ffffffffc0200c4e:	00004517          	auipc	a0,0x4
ffffffffc0200c52:	28250513          	addi	a0,a0,642 # ffffffffc0204ed0 <commands+0x740>
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
ffffffffc0200c76:	100030ef          	jal	ra,ffffffffc0203d76 <kfree>
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
ffffffffc0200c8c:	0ea0306f          	j	ffffffffc0203d76 <kfree>

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
ffffffffc0200ca4:	733010ef          	jal	ra,ffffffffc0202bd6 <nr_free_pages>
ffffffffc0200ca8:	89aa                	mv	s3,a0
    cprintf("check_vmm() succeeded.\n");
}

static void
check_vma_struct(void) {
    size_t nr_free_pages_store = nr_free_pages();
ffffffffc0200caa:	72d010ef          	jal	ra,ffffffffc0202bd6 <nr_free_pages>
ffffffffc0200cae:	8a2a                	mv	s4,a0
    struct mm_struct *mm = kmalloc(sizeof(struct mm_struct));
ffffffffc0200cb0:	03000513          	li	a0,48
ffffffffc0200cb4:	008030ef          	jal	ra,ffffffffc0203cbc <kmalloc>
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
ffffffffc0200cf8:	7c5020ef          	jal	ra,ffffffffc0203cbc <kmalloc>
ffffffffc0200cfc:	85aa                	mv	a1,a0
ffffffffc0200cfe:	00240793          	addi	a5,s0,2
    if (vma != NULL) {
ffffffffc0200d02:	f165                	bnez	a0,ffffffffc0200ce2 <vmm_init+0x52>
        assert(vma != NULL);
ffffffffc0200d04:	00004697          	auipc	a3,0x4
ffffffffc0200d08:	46c68693          	addi	a3,a3,1132 # ffffffffc0205170 <commands+0x9e0>
ffffffffc0200d0c:	00004617          	auipc	a2,0x4
ffffffffc0200d10:	1ac60613          	addi	a2,a2,428 # ffffffffc0204eb8 <commands+0x728>
ffffffffc0200d14:	0ce00593          	li	a1,206
ffffffffc0200d18:	00004517          	auipc	a0,0x4
ffffffffc0200d1c:	1b850513          	addi	a0,a0,440 # ffffffffc0204ed0 <commands+0x740>
ffffffffc0200d20:	be2ff0ef          	jal	ra,ffffffffc0200102 <__panic>
        if (swap_init_ok) swap_init_mm(mm);
ffffffffc0200d24:	4d9000ef          	jal	ra,ffffffffc02019fc <swap_init_mm>
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
ffffffffc0200d4c:	771020ef          	jal	ra,ffffffffc0203cbc <kmalloc>
ffffffffc0200d50:	85aa                	mv	a1,a0
ffffffffc0200d52:	00240793          	addi	a5,s0,2
    if (vma != NULL) {
ffffffffc0200d56:	fd79                	bnez	a0,ffffffffc0200d34 <vmm_init+0xa4>
        assert(vma != NULL);
ffffffffc0200d58:	00004697          	auipc	a3,0x4
ffffffffc0200d5c:	41868693          	addi	a3,a3,1048 # ffffffffc0205170 <commands+0x9e0>
ffffffffc0200d60:	00004617          	auipc	a2,0x4
ffffffffc0200d64:	15860613          	addi	a2,a2,344 # ffffffffc0204eb8 <commands+0x728>
ffffffffc0200d68:	0d400593          	li	a1,212
ffffffffc0200d6c:	00004517          	auipc	a0,0x4
ffffffffc0200d70:	16450513          	addi	a0,a0,356 # ffffffffc0204ed0 <commands+0x740>
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
ffffffffc0200e30:	21450513          	addi	a0,a0,532 # ffffffffc0205040 <commands+0x8b0>
ffffffffc0200e34:	a86ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
        }
        assert(vma_below_5 == NULL);
ffffffffc0200e38:	00004697          	auipc	a3,0x4
ffffffffc0200e3c:	23068693          	addi	a3,a3,560 # ffffffffc0205068 <commands+0x8d8>
ffffffffc0200e40:	00004617          	auipc	a2,0x4
ffffffffc0200e44:	07860613          	addi	a2,a2,120 # ffffffffc0204eb8 <commands+0x728>
ffffffffc0200e48:	0f600593          	li	a1,246
ffffffffc0200e4c:	00004517          	auipc	a0,0x4
ffffffffc0200e50:	08450513          	addi	a0,a0,132 # ffffffffc0204ed0 <commands+0x740>
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
ffffffffc0200e6e:	709020ef          	jal	ra,ffffffffc0203d76 <kfree>
    return listelm->next;
ffffffffc0200e72:	6488                	ld	a0,8(s1)
    while ((le = list_next(list)) != list) {
ffffffffc0200e74:	fea496e3          	bne	s1,a0,ffffffffc0200e60 <vmm_init+0x1d0>
    kfree(mm, sizeof(struct mm_struct)); //kfree mm
ffffffffc0200e78:	03000593          	li	a1,48
ffffffffc0200e7c:	8526                	mv	a0,s1
ffffffffc0200e7e:	6f9020ef          	jal	ra,ffffffffc0203d76 <kfree>
    }

    mm_destroy(mm);

    assert(nr_free_pages_store == nr_free_pages());
ffffffffc0200e82:	555010ef          	jal	ra,ffffffffc0202bd6 <nr_free_pages>
ffffffffc0200e86:	3caa1163          	bne	s4,a0,ffffffffc0201248 <vmm_init+0x5b8>

    cprintf("check_vma_struct() succeeded!\n");
ffffffffc0200e8a:	00004517          	auipc	a0,0x4
ffffffffc0200e8e:	21e50513          	addi	a0,a0,542 # ffffffffc02050a8 <commands+0x918>
ffffffffc0200e92:	a28ff0ef          	jal	ra,ffffffffc02000ba <cprintf>

// check_pgfault - check correctness of pgfault handler
static void
check_pgfault(void) {
	// char *name = "check_pgfault";
    size_t nr_free_pages_store = nr_free_pages();
ffffffffc0200e96:	541010ef          	jal	ra,ffffffffc0202bd6 <nr_free_pages>
ffffffffc0200e9a:	84aa                	mv	s1,a0
    struct mm_struct *mm = kmalloc(sizeof(struct mm_struct));
ffffffffc0200e9c:	03000513          	li	a0,48
ffffffffc0200ea0:	61d020ef          	jal	ra,ffffffffc0203cbc <kmalloc>
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
ffffffffc0200eea:	5d3020ef          	jal	ra,ffffffffc0203cbc <kmalloc>
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
ffffffffc0200f50:	711010ef          	jal	ra,ffffffffc0202e60 <page_remove>
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
ffffffffc0200f6c:	42073703          	ld	a4,1056(a4) # ffffffffc0206388 <nbase>
ffffffffc0200f70:	8f99                	sub	a5,a5,a4
ffffffffc0200f72:	00379713          	slli	a4,a5,0x3
ffffffffc0200f76:	97ba                	add	a5,a5,a4
ffffffffc0200f78:	078e                	slli	a5,a5,0x3

    free_page(pde2page(pgdir[0]));
ffffffffc0200f7a:	00010517          	auipc	a0,0x10
ffffffffc0200f7e:	5de53503          	ld	a0,1502(a0) # ffffffffc0211558 <pages>
ffffffffc0200f82:	953e                	add	a0,a0,a5
ffffffffc0200f84:	4585                	li	a1,1
ffffffffc0200f86:	411010ef          	jal	ra,ffffffffc0202b96 <free_pages>
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
ffffffffc0200fa6:	5d1020ef          	jal	ra,ffffffffc0203d76 <kfree>
    return listelm->next;
ffffffffc0200faa:	6408                	ld	a0,8(s0)
    while ((le = list_next(list)) != list) {
ffffffffc0200fac:	fea416e3          	bne	s0,a0,ffffffffc0200f98 <vmm_init+0x308>
    kfree(mm, sizeof(struct mm_struct)); //kfree mm
ffffffffc0200fb0:	03000593          	li	a1,48
ffffffffc0200fb4:	8522                	mv	a0,s0
ffffffffc0200fb6:	5c1020ef          	jal	ra,ffffffffc0203d76 <kfree>
    mm_destroy(mm);

    check_mm_struct = NULL;
    nr_free_pages_store--;	// szx : Sv39第二级页表多占了一个内存页，所以执行此操作
ffffffffc0200fba:	14fd                	addi	s1,s1,-1
    check_mm_struct = NULL;
ffffffffc0200fbc:	00010797          	auipc	a5,0x10
ffffffffc0200fc0:	5407ba23          	sd	zero,1364(a5) # ffffffffc0211510 <check_mm_struct>

    assert(nr_free_pages_store == nr_free_pages());
ffffffffc0200fc4:	413010ef          	jal	ra,ffffffffc0202bd6 <nr_free_pages>
ffffffffc0200fc8:	22a49063          	bne	s1,a0,ffffffffc02011e8 <vmm_init+0x558>

    cprintf("check_pgfault() succeeded!\n");
ffffffffc0200fcc:	00004517          	auipc	a0,0x4
ffffffffc0200fd0:	16c50513          	addi	a0,a0,364 # ffffffffc0205138 <commands+0x9a8>
ffffffffc0200fd4:	8e6ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
    assert(nr_free_pages_store == nr_free_pages());
ffffffffc0200fd8:	3ff010ef          	jal	ra,ffffffffc0202bd6 <nr_free_pages>
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
ffffffffc0200ff8:	16450513          	addi	a0,a0,356 # ffffffffc0205158 <commands+0x9c8>
}
ffffffffc0200ffc:	6161                	addi	sp,sp,80
    cprintf("check_vmm() succeeded.\n");
ffffffffc0200ffe:	8bcff06f          	j	ffffffffc02000ba <cprintf>
        if (swap_init_ok) swap_init_mm(mm);
ffffffffc0201002:	1fb000ef          	jal	ra,ffffffffc02019fc <swap_init_mm>
ffffffffc0201006:	b5d1                	j	ffffffffc0200eca <vmm_init+0x23a>
        assert(mmap->vm_start == i * 5 && mmap->vm_end == i * 5 + 2);
ffffffffc0201008:	00004697          	auipc	a3,0x4
ffffffffc020100c:	f5068693          	addi	a3,a3,-176 # ffffffffc0204f58 <commands+0x7c8>
ffffffffc0201010:	00004617          	auipc	a2,0x4
ffffffffc0201014:	ea860613          	addi	a2,a2,-344 # ffffffffc0204eb8 <commands+0x728>
ffffffffc0201018:	0dd00593          	li	a1,221
ffffffffc020101c:	00004517          	auipc	a0,0x4
ffffffffc0201020:	eb450513          	addi	a0,a0,-332 # ffffffffc0204ed0 <commands+0x740>
ffffffffc0201024:	8deff0ef          	jal	ra,ffffffffc0200102 <__panic>
        assert(vma2->vm_start == i  && vma2->vm_end == i  + 2);
ffffffffc0201028:	00004697          	auipc	a3,0x4
ffffffffc020102c:	fe868693          	addi	a3,a3,-24 # ffffffffc0205010 <commands+0x880>
ffffffffc0201030:	00004617          	auipc	a2,0x4
ffffffffc0201034:	e8860613          	addi	a2,a2,-376 # ffffffffc0204eb8 <commands+0x728>
ffffffffc0201038:	0ee00593          	li	a1,238
ffffffffc020103c:	00004517          	auipc	a0,0x4
ffffffffc0201040:	e9450513          	addi	a0,a0,-364 # ffffffffc0204ed0 <commands+0x740>
ffffffffc0201044:	8beff0ef          	jal	ra,ffffffffc0200102 <__panic>
        assert(vma1->vm_start == i  && vma1->vm_end == i  + 2);
ffffffffc0201048:	00004697          	auipc	a3,0x4
ffffffffc020104c:	f9868693          	addi	a3,a3,-104 # ffffffffc0204fe0 <commands+0x850>
ffffffffc0201050:	00004617          	auipc	a2,0x4
ffffffffc0201054:	e6860613          	addi	a2,a2,-408 # ffffffffc0204eb8 <commands+0x728>
ffffffffc0201058:	0ed00593          	li	a1,237
ffffffffc020105c:	00004517          	auipc	a0,0x4
ffffffffc0201060:	e7450513          	addi	a0,a0,-396 # ffffffffc0204ed0 <commands+0x740>
ffffffffc0201064:	89eff0ef          	jal	ra,ffffffffc0200102 <__panic>
        assert(le != &(mm->mmap_list));
ffffffffc0201068:	00004697          	auipc	a3,0x4
ffffffffc020106c:	ed868693          	addi	a3,a3,-296 # ffffffffc0204f40 <commands+0x7b0>
ffffffffc0201070:	00004617          	auipc	a2,0x4
ffffffffc0201074:	e4860613          	addi	a2,a2,-440 # ffffffffc0204eb8 <commands+0x728>
ffffffffc0201078:	0db00593          	li	a1,219
ffffffffc020107c:	00004517          	auipc	a0,0x4
ffffffffc0201080:	e5450513          	addi	a0,a0,-428 # ffffffffc0204ed0 <commands+0x740>
ffffffffc0201084:	87eff0ef          	jal	ra,ffffffffc0200102 <__panic>
        assert(vma1 != NULL);
ffffffffc0201088:	00004697          	auipc	a3,0x4
ffffffffc020108c:	f0868693          	addi	a3,a3,-248 # ffffffffc0204f90 <commands+0x800>
ffffffffc0201090:	00004617          	auipc	a2,0x4
ffffffffc0201094:	e2860613          	addi	a2,a2,-472 # ffffffffc0204eb8 <commands+0x728>
ffffffffc0201098:	0e300593          	li	a1,227
ffffffffc020109c:	00004517          	auipc	a0,0x4
ffffffffc02010a0:	e3450513          	addi	a0,a0,-460 # ffffffffc0204ed0 <commands+0x740>
ffffffffc02010a4:	85eff0ef          	jal	ra,ffffffffc0200102 <__panic>
        assert(vma2 != NULL);
ffffffffc02010a8:	00004697          	auipc	a3,0x4
ffffffffc02010ac:	ef868693          	addi	a3,a3,-264 # ffffffffc0204fa0 <commands+0x810>
ffffffffc02010b0:	00004617          	auipc	a2,0x4
ffffffffc02010b4:	e0860613          	addi	a2,a2,-504 # ffffffffc0204eb8 <commands+0x728>
ffffffffc02010b8:	0e500593          	li	a1,229
ffffffffc02010bc:	00004517          	auipc	a0,0x4
ffffffffc02010c0:	e1450513          	addi	a0,a0,-492 # ffffffffc0204ed0 <commands+0x740>
ffffffffc02010c4:	83eff0ef          	jal	ra,ffffffffc0200102 <__panic>
        assert(vma3 == NULL);
ffffffffc02010c8:	00004697          	auipc	a3,0x4
ffffffffc02010cc:	ee868693          	addi	a3,a3,-280 # ffffffffc0204fb0 <commands+0x820>
ffffffffc02010d0:	00004617          	auipc	a2,0x4
ffffffffc02010d4:	de860613          	addi	a2,a2,-536 # ffffffffc0204eb8 <commands+0x728>
ffffffffc02010d8:	0e700593          	li	a1,231
ffffffffc02010dc:	00004517          	auipc	a0,0x4
ffffffffc02010e0:	df450513          	addi	a0,a0,-524 # ffffffffc0204ed0 <commands+0x740>
ffffffffc02010e4:	81eff0ef          	jal	ra,ffffffffc0200102 <__panic>
        assert(vma4 == NULL);
ffffffffc02010e8:	00004697          	auipc	a3,0x4
ffffffffc02010ec:	ed868693          	addi	a3,a3,-296 # ffffffffc0204fc0 <commands+0x830>
ffffffffc02010f0:	00004617          	auipc	a2,0x4
ffffffffc02010f4:	dc860613          	addi	a2,a2,-568 # ffffffffc0204eb8 <commands+0x728>
ffffffffc02010f8:	0e900593          	li	a1,233
ffffffffc02010fc:	00004517          	auipc	a0,0x4
ffffffffc0201100:	dd450513          	addi	a0,a0,-556 # ffffffffc0204ed0 <commands+0x740>
ffffffffc0201104:	ffffe0ef          	jal	ra,ffffffffc0200102 <__panic>
        assert(vma5 == NULL);
ffffffffc0201108:	00004697          	auipc	a3,0x4
ffffffffc020110c:	ec868693          	addi	a3,a3,-312 # ffffffffc0204fd0 <commands+0x840>
ffffffffc0201110:	00004617          	auipc	a2,0x4
ffffffffc0201114:	da860613          	addi	a2,a2,-600 # ffffffffc0204eb8 <commands+0x728>
ffffffffc0201118:	0eb00593          	li	a1,235
ffffffffc020111c:	00004517          	auipc	a0,0x4
ffffffffc0201120:	db450513          	addi	a0,a0,-588 # ffffffffc0204ed0 <commands+0x740>
ffffffffc0201124:	fdffe0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(pgdir[0] == 0);
ffffffffc0201128:	00004697          	auipc	a3,0x4
ffffffffc020112c:	fa068693          	addi	a3,a3,-96 # ffffffffc02050c8 <commands+0x938>
ffffffffc0201130:	00004617          	auipc	a2,0x4
ffffffffc0201134:	d8860613          	addi	a2,a2,-632 # ffffffffc0204eb8 <commands+0x728>
ffffffffc0201138:	10d00593          	li	a1,269
ffffffffc020113c:	00004517          	auipc	a0,0x4
ffffffffc0201140:	d9450513          	addi	a0,a0,-620 # ffffffffc0204ed0 <commands+0x740>
ffffffffc0201144:	fbffe0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(check_mm_struct != NULL);
ffffffffc0201148:	00004697          	auipc	a3,0x4
ffffffffc020114c:	03868693          	addi	a3,a3,56 # ffffffffc0205180 <commands+0x9f0>
ffffffffc0201150:	00004617          	auipc	a2,0x4
ffffffffc0201154:	d6860613          	addi	a2,a2,-664 # ffffffffc0204eb8 <commands+0x728>
ffffffffc0201158:	10a00593          	li	a1,266
ffffffffc020115c:	00004517          	auipc	a0,0x4
ffffffffc0201160:	d7450513          	addi	a0,a0,-652 # ffffffffc0204ed0 <commands+0x740>
    check_mm_struct = mm_create();
ffffffffc0201164:	00010797          	auipc	a5,0x10
ffffffffc0201168:	3a07b623          	sd	zero,940(a5) # ffffffffc0211510 <check_mm_struct>
    assert(check_mm_struct != NULL);
ffffffffc020116c:	f97fe0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(vma != NULL);
ffffffffc0201170:	00004697          	auipc	a3,0x4
ffffffffc0201174:	00068693          	mv	a3,a3
ffffffffc0201178:	00004617          	auipc	a2,0x4
ffffffffc020117c:	d4060613          	addi	a2,a2,-704 # ffffffffc0204eb8 <commands+0x728>
ffffffffc0201180:	11100593          	li	a1,273
ffffffffc0201184:	00004517          	auipc	a0,0x4
ffffffffc0201188:	d4c50513          	addi	a0,a0,-692 # ffffffffc0204ed0 <commands+0x740>
ffffffffc020118c:	f77fe0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(find_vma(mm, addr) == vma);
ffffffffc0201190:	00004697          	auipc	a3,0x4
ffffffffc0201194:	f4868693          	addi	a3,a3,-184 # ffffffffc02050d8 <commands+0x948>
ffffffffc0201198:	00004617          	auipc	a2,0x4
ffffffffc020119c:	d2060613          	addi	a2,a2,-736 # ffffffffc0204eb8 <commands+0x728>
ffffffffc02011a0:	11600593          	li	a1,278
ffffffffc02011a4:	00004517          	auipc	a0,0x4
ffffffffc02011a8:	d2c50513          	addi	a0,a0,-724 # ffffffffc0204ed0 <commands+0x740>
ffffffffc02011ac:	f57fe0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(sum == 0);
ffffffffc02011b0:	00004697          	auipc	a3,0x4
ffffffffc02011b4:	f4868693          	addi	a3,a3,-184 # ffffffffc02050f8 <commands+0x968>
ffffffffc02011b8:	00004617          	auipc	a2,0x4
ffffffffc02011bc:	d0060613          	addi	a2,a2,-768 # ffffffffc0204eb8 <commands+0x728>
ffffffffc02011c0:	12000593          	li	a1,288
ffffffffc02011c4:	00004517          	auipc	a0,0x4
ffffffffc02011c8:	d0c50513          	addi	a0,a0,-756 # ffffffffc0204ed0 <commands+0x740>
ffffffffc02011cc:	f37fe0ef          	jal	ra,ffffffffc0200102 <__panic>
        panic("pa2page called with invalid pa");
ffffffffc02011d0:	00004617          	auipc	a2,0x4
ffffffffc02011d4:	f3860613          	addi	a2,a2,-200 # ffffffffc0205108 <commands+0x978>
ffffffffc02011d8:	06500593          	li	a1,101
ffffffffc02011dc:	00004517          	auipc	a0,0x4
ffffffffc02011e0:	f4c50513          	addi	a0,a0,-180 # ffffffffc0205128 <commands+0x998>
ffffffffc02011e4:	f1ffe0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(nr_free_pages_store == nr_free_pages());
ffffffffc02011e8:	00004697          	auipc	a3,0x4
ffffffffc02011ec:	e9868693          	addi	a3,a3,-360 # ffffffffc0205080 <commands+0x8f0>
ffffffffc02011f0:	00004617          	auipc	a2,0x4
ffffffffc02011f4:	cc860613          	addi	a2,a2,-824 # ffffffffc0204eb8 <commands+0x728>
ffffffffc02011f8:	12e00593          	li	a1,302
ffffffffc02011fc:	00004517          	auipc	a0,0x4
ffffffffc0201200:	cd450513          	addi	a0,a0,-812 # ffffffffc0204ed0 <commands+0x740>
ffffffffc0201204:	efffe0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(nr_free_pages_store == nr_free_pages());
ffffffffc0201208:	00004697          	auipc	a3,0x4
ffffffffc020120c:	e7868693          	addi	a3,a3,-392 # ffffffffc0205080 <commands+0x8f0>
ffffffffc0201210:	00004617          	auipc	a2,0x4
ffffffffc0201214:	ca860613          	addi	a2,a2,-856 # ffffffffc0204eb8 <commands+0x728>
ffffffffc0201218:	0bd00593          	li	a1,189
ffffffffc020121c:	00004517          	auipc	a0,0x4
ffffffffc0201220:	cb450513          	addi	a0,a0,-844 # ffffffffc0204ed0 <commands+0x740>
ffffffffc0201224:	edffe0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(mm != NULL);
ffffffffc0201228:	00004697          	auipc	a3,0x4
ffffffffc020122c:	f7068693          	addi	a3,a3,-144 # ffffffffc0205198 <commands+0xa08>
ffffffffc0201230:	00004617          	auipc	a2,0x4
ffffffffc0201234:	c8860613          	addi	a2,a2,-888 # ffffffffc0204eb8 <commands+0x728>
ffffffffc0201238:	0c700593          	li	a1,199
ffffffffc020123c:	00004517          	auipc	a0,0x4
ffffffffc0201240:	c9450513          	addi	a0,a0,-876 # ffffffffc0204ed0 <commands+0x740>
ffffffffc0201244:	ebffe0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(nr_free_pages_store == nr_free_pages());
ffffffffc0201248:	00004697          	auipc	a3,0x4
ffffffffc020124c:	e3868693          	addi	a3,a3,-456 # ffffffffc0205080 <commands+0x8f0>
ffffffffc0201250:	00004617          	auipc	a2,0x4
ffffffffc0201254:	c6860613          	addi	a2,a2,-920 # ffffffffc0204eb8 <commands+0x728>
ffffffffc0201258:	0fb00593          	li	a1,251
ffffffffc020125c:	00004517          	auipc	a0,0x4
ffffffffc0201260:	c7450513          	addi	a0,a0,-908 # ffffffffc0204ed0 <commands+0x740>
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
ffffffffc020128e:	cd41                	beqz	a0,ffffffffc0201326 <do_pgfault+0xbe>
ffffffffc0201290:	651c                	ld	a5,8(a0)
ffffffffc0201292:	08f46a63          	bltu	s0,a5,ffffffffc0201326 <do_pgfault+0xbe>
     * THEN 
     *    continue process
     */
    
    uint32_t perm = PTE_U;
    if (vma->vm_flags & VM_WRITE) {
ffffffffc0201296:	6d1c                	ld	a5,24(a0)
    uint32_t perm = PTE_U;
ffffffffc0201298:	4941                	li	s2,16
    if (vma->vm_flags & VM_WRITE) {
ffffffffc020129a:	8b89                	andi	a5,a5,2
ffffffffc020129c:	e7a9                	bnez	a5,ffffffffc02012e6 <do_pgfault+0x7e>
        perm |= (PTE_R | PTE_W);
    }
    addr = ROUNDDOWN(addr, PGSIZE);
ffffffffc020129e:	75fd                	lui	a1,0xfffff
    *   mm->pgdir : the PDT of these vma
    *
    */


    ptep = get_pte(mm->pgdir, addr, 1);  //(1) try to find a pte, if pte's
ffffffffc02012a0:	6c88                	ld	a0,24(s1)
    addr = ROUNDDOWN(addr, PGSIZE);
ffffffffc02012a2:	8c6d                	and	s0,s0,a1
    ptep = get_pte(mm->pgdir, addr, 1);  //(1) try to find a pte, if pte's
ffffffffc02012a4:	85a2                	mv	a1,s0
ffffffffc02012a6:	4605                	li	a2,1
ffffffffc02012a8:	169010ef          	jal	ra,ffffffffc0202c10 <get_pte>
                                         //PT(Page Table) isn't existed, then
                                         //create a PT.
    if (*ptep == 0) {
ffffffffc02012ac:	610c                	ld	a1,0(a0)
ffffffffc02012ae:	cda9                	beqz	a1,ffffffffc0201308 <do_pgfault+0xa0>
        *    swap_in(mm, addr, &page) : 分配一个内存页，然后根据
        *    PTE中的swap条目的addr，找到磁盘页的地址，将磁盘页的内容读入这个内存页
        *    page_insert ： 建立一个Page的phy addr与线性addr la的映射
        *    swap_map_swappable ： 设置页面可交换
        */
        if (swap_init_ok) {
ffffffffc02012b0:	00010797          	auipc	a5,0x10
ffffffffc02012b4:	2807a783          	lw	a5,640(a5) # ffffffffc0211530 <swap_init_ok>
ffffffffc02012b8:	c3c1                	beqz	a5,ffffffffc0201338 <do_pgfault+0xd0>
            struct Page *page = NULL;
            // 你要编写的内容在这里，请基于上文说明以及下文的英文注释完成代码编写
            //(1）According to the mm AND addr, try
            //to load the content of right disk page
            //into the memory which page managed.
            swap_in(mm,addr,&page);
ffffffffc02012ba:	85a2                	mv	a1,s0
ffffffffc02012bc:	0030                	addi	a2,sp,8
ffffffffc02012be:	8526                	mv	a0,s1
            struct Page *page = NULL;
ffffffffc02012c0:	e402                	sd	zero,8(sp)
            swap_in(mm,addr,&page);
ffffffffc02012c2:	067000ef          	jal	ra,ffffffffc0201b28 <swap_in>
            //(2) According to the mm,
            //addr AND page, setup the
            //map of phy addr <--->
            //logical addr
            if(ret=page_insert(mm->pgdir,page,addr,perm)!=0)
ffffffffc02012c6:	65a2                	ld	a1,8(sp)
ffffffffc02012c8:	6c88                	ld	a0,24(s1)
ffffffffc02012ca:	86ca                	mv	a3,s2
ffffffffc02012cc:	8622                	mv	a2,s0
ffffffffc02012ce:	42d010ef          	jal	ra,ffffffffc0202efa <page_insert>
ffffffffc02012d2:	892a                	mv	s2,a0
ffffffffc02012d4:	c919                	beqz	a0,ffffffffc02012ea <do_pgfault+0x82>
            {
                return ret;
ffffffffc02012d6:	4905                	li	s2,1
   }

   ret = 0;
failed:
    return ret;
}
ffffffffc02012d8:	70a2                	ld	ra,40(sp)
ffffffffc02012da:	7402                	ld	s0,32(sp)
ffffffffc02012dc:	64e2                	ld	s1,24(sp)
ffffffffc02012de:	854a                	mv	a0,s2
ffffffffc02012e0:	6942                	ld	s2,16(sp)
ffffffffc02012e2:	6145                	addi	sp,sp,48
ffffffffc02012e4:	8082                	ret
        perm |= (PTE_R | PTE_W);
ffffffffc02012e6:	4959                	li	s2,22
ffffffffc02012e8:	bf5d                	j	ffffffffc020129e <do_pgfault+0x36>
            swap_map_swappable(mm,addr,page,0);
ffffffffc02012ea:	6622                	ld	a2,8(sp)
ffffffffc02012ec:	85a2                	mv	a1,s0
ffffffffc02012ee:	8526                	mv	a0,s1
ffffffffc02012f0:	4681                	li	a3,0
ffffffffc02012f2:	716000ef          	jal	ra,ffffffffc0201a08 <swap_map_swappable>
            page->pra_vaddr = addr;
ffffffffc02012f6:	67a2                	ld	a5,8(sp)
}
ffffffffc02012f8:	70a2                	ld	ra,40(sp)
ffffffffc02012fa:	64e2                	ld	s1,24(sp)
            page->pra_vaddr = addr;
ffffffffc02012fc:	e3a0                	sd	s0,64(a5)
}
ffffffffc02012fe:	7402                	ld	s0,32(sp)
ffffffffc0201300:	854a                	mv	a0,s2
ffffffffc0201302:	6942                	ld	s2,16(sp)
ffffffffc0201304:	6145                	addi	sp,sp,48
ffffffffc0201306:	8082                	ret
        if (pgdir_alloc_page(mm->pgdir, addr, perm) == NULL) {
ffffffffc0201308:	6c88                	ld	a0,24(s1)
ffffffffc020130a:	864a                	mv	a2,s2
ffffffffc020130c:	85a2                	mv	a1,s0
ffffffffc020130e:	0f7020ef          	jal	ra,ffffffffc0203c04 <pgdir_alloc_page>
   ret = 0;
ffffffffc0201312:	4901                	li	s2,0
        if (pgdir_alloc_page(mm->pgdir, addr, perm) == NULL) {
ffffffffc0201314:	f171                	bnez	a0,ffffffffc02012d8 <do_pgfault+0x70>
            cprintf("pgdir_alloc_page in do_pgfault failed\n");
ffffffffc0201316:	00004517          	auipc	a0,0x4
ffffffffc020131a:	ec250513          	addi	a0,a0,-318 # ffffffffc02051d8 <commands+0xa48>
ffffffffc020131e:	d9dfe0ef          	jal	ra,ffffffffc02000ba <cprintf>
    ret = -E_NO_MEM;
ffffffffc0201322:	5971                	li	s2,-4
            goto failed;
ffffffffc0201324:	bf55                	j	ffffffffc02012d8 <do_pgfault+0x70>
        cprintf("not valid addr %x, and  can not find it in vma\n", addr);
ffffffffc0201326:	85a2                	mv	a1,s0
ffffffffc0201328:	00004517          	auipc	a0,0x4
ffffffffc020132c:	e8050513          	addi	a0,a0,-384 # ffffffffc02051a8 <commands+0xa18>
ffffffffc0201330:	d8bfe0ef          	jal	ra,ffffffffc02000ba <cprintf>
    int ret = -E_INVAL;
ffffffffc0201334:	5975                	li	s2,-3
        goto failed;
ffffffffc0201336:	b74d                	j	ffffffffc02012d8 <do_pgfault+0x70>
            cprintf("no swap_init_ok but ptep is %x, failed\n", *ptep);
ffffffffc0201338:	00004517          	auipc	a0,0x4
ffffffffc020133c:	ec850513          	addi	a0,a0,-312 # ffffffffc0205200 <commands+0xa70>
ffffffffc0201340:	d7bfe0ef          	jal	ra,ffffffffc02000ba <cprintf>
    ret = -E_NO_MEM;
ffffffffc0201344:	5971                	li	s2,-4
            goto failed;
ffffffffc0201346:	bf49                	j	ffffffffc02012d8 <do_pgfault+0x70>

ffffffffc0201348 <swap_init>:

static void check_swap(void);

int
swap_init(void)
{
ffffffffc0201348:	7171                	addi	sp,sp,-176
ffffffffc020134a:	f506                	sd	ra,168(sp)
ffffffffc020134c:	f122                	sd	s0,160(sp)
ffffffffc020134e:	ed26                	sd	s1,152(sp)
ffffffffc0201350:	e94a                	sd	s2,144(sp)
ffffffffc0201352:	e54e                	sd	s3,136(sp)
ffffffffc0201354:	e152                	sd	s4,128(sp)
ffffffffc0201356:	fcd6                	sd	s5,120(sp)
ffffffffc0201358:	f8da                	sd	s6,112(sp)
ffffffffc020135a:	f4de                	sd	s7,104(sp)
ffffffffc020135c:	f0e2                	sd	s8,96(sp)
ffffffffc020135e:	ece6                	sd	s9,88(sp)
ffffffffc0201360:	e8ea                	sd	s10,80(sp)
ffffffffc0201362:	e4ee                	sd	s11,72(sp)
     swapfs_init();
ffffffffc0201364:	2fb020ef          	jal	ra,ffffffffc0203e5e <swapfs_init>

     // Since the IDE is faked, it can only store 7 pages at most to pass the test
     if (!(7 <= max_swap_offset &&
ffffffffc0201368:	00010697          	auipc	a3,0x10
ffffffffc020136c:	1b86b683          	ld	a3,440(a3) # ffffffffc0211520 <max_swap_offset>
ffffffffc0201370:	010007b7          	lui	a5,0x1000
ffffffffc0201374:	ff968713          	addi	a4,a3,-7
ffffffffc0201378:	17e1                	addi	a5,a5,-8
ffffffffc020137a:	42e7e563          	bltu	a5,a4,ffffffffc02017a4 <swap_init+0x45c>
        max_swap_offset < MAX_SWAP_OFFSET_LIMIT)) {
        panic("bad max_swap_offset %08x.\n", max_swap_offset);
     }

     sm = &swap_manager_clock;//use first in first out Page Replacement Algorithm
ffffffffc020137e:	00009797          	auipc	a5,0x9
ffffffffc0201382:	c8278793          	addi	a5,a5,-894 # ffffffffc020a000 <swap_manager_clock>
     int r = sm->init();
ffffffffc0201386:	6798                	ld	a4,8(a5)
     sm = &swap_manager_clock;//use first in first out Page Replacement Algorithm
ffffffffc0201388:	00010a97          	auipc	s5,0x10
ffffffffc020138c:	1a0a8a93          	addi	s5,s5,416 # ffffffffc0211528 <sm>
ffffffffc0201390:	00fab023          	sd	a5,0(s5)
     int r = sm->init();
ffffffffc0201394:	9702                	jalr	a4
ffffffffc0201396:	892a                	mv	s2,a0
     
     if (r == 0)
ffffffffc0201398:	c10d                	beqz	a0,ffffffffc02013ba <swap_init+0x72>
          cprintf("SWAP: manager = %s\n", sm->name);
          check_swap();
     }

     return r;
}
ffffffffc020139a:	70aa                	ld	ra,168(sp)
ffffffffc020139c:	740a                	ld	s0,160(sp)
ffffffffc020139e:	64ea                	ld	s1,152(sp)
ffffffffc02013a0:	69aa                	ld	s3,136(sp)
ffffffffc02013a2:	6a0a                	ld	s4,128(sp)
ffffffffc02013a4:	7ae6                	ld	s5,120(sp)
ffffffffc02013a6:	7b46                	ld	s6,112(sp)
ffffffffc02013a8:	7ba6                	ld	s7,104(sp)
ffffffffc02013aa:	7c06                	ld	s8,96(sp)
ffffffffc02013ac:	6ce6                	ld	s9,88(sp)
ffffffffc02013ae:	6d46                	ld	s10,80(sp)
ffffffffc02013b0:	6da6                	ld	s11,72(sp)
ffffffffc02013b2:	854a                	mv	a0,s2
ffffffffc02013b4:	694a                	ld	s2,144(sp)
ffffffffc02013b6:	614d                	addi	sp,sp,176
ffffffffc02013b8:	8082                	ret
          cprintf("SWAP: manager = %s\n", sm->name);
ffffffffc02013ba:	000ab783          	ld	a5,0(s5)
ffffffffc02013be:	00004517          	auipc	a0,0x4
ffffffffc02013c2:	e9a50513          	addi	a0,a0,-358 # ffffffffc0205258 <commands+0xac8>
ffffffffc02013c6:	00010417          	auipc	s0,0x10
ffffffffc02013ca:	d0a40413          	addi	s0,s0,-758 # ffffffffc02110d0 <free_area>
ffffffffc02013ce:	638c                	ld	a1,0(a5)
          swap_init_ok = 1;
ffffffffc02013d0:	4785                	li	a5,1
ffffffffc02013d2:	00010717          	auipc	a4,0x10
ffffffffc02013d6:	14f72f23          	sw	a5,350(a4) # ffffffffc0211530 <swap_init_ok>
          cprintf("SWAP: manager = %s\n", sm->name);
ffffffffc02013da:	ce1fe0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc02013de:	641c                	ld	a5,8(s0)

static void
check_swap(void)
{
    //backup mem env
     int ret, count = 0, total = 0, i;
ffffffffc02013e0:	4d81                	li	s11,0
ffffffffc02013e2:	4d01                	li	s10,0
     list_entry_t *le = &free_list;
     while ((le = list_next(le)) != &free_list) {
ffffffffc02013e4:	30878663          	beq	a5,s0,ffffffffc02016f0 <swap_init+0x3a8>
 * test_bit - Determine whether a bit is set
 * @nr:     the bit to test
 * @addr:   the address to count from
 * */
static inline bool test_bit(int nr, volatile void *addr) {
    return (((*(volatile unsigned long *)addr) >> nr) & 1);
ffffffffc02013e8:	fe87b703          	ld	a4,-24(a5)
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
ffffffffc02013ec:	8b09                	andi	a4,a4,2
ffffffffc02013ee:	30070363          	beqz	a4,ffffffffc02016f4 <swap_init+0x3ac>
        count ++, total += p->property;
ffffffffc02013f2:	ff87a703          	lw	a4,-8(a5)
ffffffffc02013f6:	679c                	ld	a5,8(a5)
ffffffffc02013f8:	2d05                	addiw	s10,s10,1
ffffffffc02013fa:	01b70dbb          	addw	s11,a4,s11
     while ((le = list_next(le)) != &free_list) {
ffffffffc02013fe:	fe8795e3          	bne	a5,s0,ffffffffc02013e8 <swap_init+0xa0>
     }
     assert(total == nr_free_pages());
ffffffffc0201402:	84ee                	mv	s1,s11
ffffffffc0201404:	7d2010ef          	jal	ra,ffffffffc0202bd6 <nr_free_pages>
ffffffffc0201408:	4a951a63          	bne	a0,s1,ffffffffc02018bc <swap_init+0x574>
     cprintf("BEGIN check_swap: count %d, total %d\n",count,total);
ffffffffc020140c:	866e                	mv	a2,s11
ffffffffc020140e:	85ea                	mv	a1,s10
ffffffffc0201410:	00004517          	auipc	a0,0x4
ffffffffc0201414:	e9050513          	addi	a0,a0,-368 # ffffffffc02052a0 <commands+0xb10>
ffffffffc0201418:	ca3fe0ef          	jal	ra,ffffffffc02000ba <cprintf>
     
     //now we set the phy pages env     
     struct mm_struct *mm = mm_create();
ffffffffc020141c:	eb8ff0ef          	jal	ra,ffffffffc0200ad4 <mm_create>
ffffffffc0201420:	f42a                	sd	a0,40(sp)
     assert(mm != NULL);
ffffffffc0201422:	56050d63          	beqz	a0,ffffffffc020199c <swap_init+0x654>

     extern struct mm_struct *check_mm_struct;
     assert(check_mm_struct == NULL);
ffffffffc0201426:	00010797          	auipc	a5,0x10
ffffffffc020142a:	0ea78793          	addi	a5,a5,234 # ffffffffc0211510 <check_mm_struct>
ffffffffc020142e:	6398                	ld	a4,0(a5)
ffffffffc0201430:	58071663          	bnez	a4,ffffffffc02019bc <swap_init+0x674>

     check_mm_struct = mm;
ffffffffc0201434:	76a2                	ld	a3,40(sp)

     pde_t *pgdir = mm->pgdir = boot_pgdir;
ffffffffc0201436:	00010b17          	auipc	s6,0x10
ffffffffc020143a:	112b3b03          	ld	s6,274(s6) # ffffffffc0211548 <boot_pgdir>
     assert(pgdir[0] == 0);
ffffffffc020143e:	000b3703          	ld	a4,0(s6)
     check_mm_struct = mm;
ffffffffc0201442:	e394                	sd	a3,0(a5)
     pde_t *pgdir = mm->pgdir = boot_pgdir;
ffffffffc0201444:	0166bc23          	sd	s6,24(a3)
     assert(pgdir[0] == 0);
ffffffffc0201448:	40071a63          	bnez	a4,ffffffffc020185c <swap_init+0x514>

     struct vma_struct *vma = vma_create(BEING_CHECK_VALID_VADDR, CHECK_VALID_VADDR, VM_WRITE | VM_READ);
ffffffffc020144c:	6599                	lui	a1,0x6
ffffffffc020144e:	460d                	li	a2,3
ffffffffc0201450:	6505                	lui	a0,0x1
ffffffffc0201452:	ecaff0ef          	jal	ra,ffffffffc0200b1c <vma_create>
ffffffffc0201456:	85aa                	mv	a1,a0
     assert(vma != NULL);
ffffffffc0201458:	42050263          	beqz	a0,ffffffffc020187c <swap_init+0x534>

     insert_vma_struct(mm, vma);//初始化一块大的虚拟内存
ffffffffc020145c:	74a2                	ld	s1,40(sp)
ffffffffc020145e:	8526                	mv	a0,s1
ffffffffc0201460:	f2aff0ef          	jal	ra,ffffffffc0200b8a <insert_vma_struct>

     //setup the temp Page Table vaddr 0~4MB
     cprintf("setup Page Table for vaddr 0X1000, so alloc a page\n");
ffffffffc0201464:	00004517          	auipc	a0,0x4
ffffffffc0201468:	e7c50513          	addi	a0,a0,-388 # ffffffffc02052e0 <commands+0xb50>
ffffffffc020146c:	c4ffe0ef          	jal	ra,ffffffffc02000ba <cprintf>
     pte_t *temp_ptep=NULL;
     temp_ptep = get_pte(mm->pgdir, BEING_CHECK_VALID_VADDR, 1);
ffffffffc0201470:	6c88                	ld	a0,24(s1)
ffffffffc0201472:	4605                	li	a2,1
ffffffffc0201474:	6585                	lui	a1,0x1
ffffffffc0201476:	79a010ef          	jal	ra,ffffffffc0202c10 <get_pte>
     assert(temp_ptep!= NULL);
ffffffffc020147a:	42050163          	beqz	a0,ffffffffc020189c <swap_init+0x554>
     cprintf("setup Page Table vaddr 0~4MB OVER!\n");
ffffffffc020147e:	00004517          	auipc	a0,0x4
ffffffffc0201482:	eb250513          	addi	a0,a0,-334 # ffffffffc0205330 <commands+0xba0>
ffffffffc0201486:	00010497          	auipc	s1,0x10
ffffffffc020148a:	bda48493          	addi	s1,s1,-1062 # ffffffffc0211060 <check_rp>
ffffffffc020148e:	c2dfe0ef          	jal	ra,ffffffffc02000ba <cprintf>
     
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
ffffffffc0201492:	00010997          	auipc	s3,0x10
ffffffffc0201496:	bee98993          	addi	s3,s3,-1042 # ffffffffc0211080 <swap_in_seq_no>
     cprintf("setup Page Table vaddr 0~4MB OVER!\n");
ffffffffc020149a:	8ba6                	mv	s7,s1
          check_rp[i] = alloc_page();
ffffffffc020149c:	4505                	li	a0,1
ffffffffc020149e:	666010ef          	jal	ra,ffffffffc0202b04 <alloc_pages>
ffffffffc02014a2:	00abb023          	sd	a0,0(s7)
          assert(check_rp[i] != NULL );
ffffffffc02014a6:	2c050f63          	beqz	a0,ffffffffc0201784 <swap_init+0x43c>
ffffffffc02014aa:	651c                	ld	a5,8(a0)
          assert(!PageProperty(check_rp[i]));
ffffffffc02014ac:	8b89                	andi	a5,a5,2
ffffffffc02014ae:	2a079b63          	bnez	a5,ffffffffc0201764 <swap_init+0x41c>
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
ffffffffc02014b2:	0ba1                	addi	s7,s7,8
ffffffffc02014b4:	ff3b94e3          	bne	s7,s3,ffffffffc020149c <swap_init+0x154>
     }
     list_entry_t free_list_store = free_list;
ffffffffc02014b8:	601c                	ld	a5,0(s0)
ffffffffc02014ba:	00843c03          	ld	s8,8(s0)
    elm->prev = elm->next = elm;
ffffffffc02014be:	e000                	sd	s0,0(s0)
ffffffffc02014c0:	f83e                	sd	a5,48(sp)
     list_init(&free_list);
     assert(list_empty(&free_list));
     
     //assert(alloc_page() == NULL);
     
     unsigned int nr_free_store = nr_free;
ffffffffc02014c2:	481c                	lw	a5,16(s0)
ffffffffc02014c4:	e400                	sd	s0,8(s0)
     nr_free = 0;
ffffffffc02014c6:	00010b97          	auipc	s7,0x10
ffffffffc02014ca:	b9ab8b93          	addi	s7,s7,-1126 # ffffffffc0211060 <check_rp>
     unsigned int nr_free_store = nr_free;
ffffffffc02014ce:	fc3e                	sd	a5,56(sp)
     nr_free = 0;
ffffffffc02014d0:	00010797          	auipc	a5,0x10
ffffffffc02014d4:	c007a823          	sw	zero,-1008(a5) # ffffffffc02110e0 <free_area+0x10>
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
        free_pages(check_rp[i],1);
ffffffffc02014d8:	000bb503          	ld	a0,0(s7)
ffffffffc02014dc:	4585                	li	a1,1
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
ffffffffc02014de:	0ba1                	addi	s7,s7,8
        free_pages(check_rp[i],1);
ffffffffc02014e0:	6b6010ef          	jal	ra,ffffffffc0202b96 <free_pages>
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
ffffffffc02014e4:	ff3b9ae3          	bne	s7,s3,ffffffffc02014d8 <swap_init+0x190>
     }
     assert(nr_free==CHECK_VALID_PHY_PAGE_NUM);
ffffffffc02014e8:	01042b83          	lw	s7,16(s0)
ffffffffc02014ec:	4791                	li	a5,4
ffffffffc02014ee:	4efb9763          	bne	s7,a5,ffffffffc02019dc <swap_init+0x694>
     
     cprintf("set up init env for check_swap begin!\n");
ffffffffc02014f2:	00004517          	auipc	a0,0x4
ffffffffc02014f6:	ec650513          	addi	a0,a0,-314 # ffffffffc02053b8 <commands+0xc28>
ffffffffc02014fa:	bc1fe0ef          	jal	ra,ffffffffc02000ba <cprintf>
     *(unsigned char *)0x1000 = 0x0a;
ffffffffc02014fe:	6605                	lui	a2,0x1
     //setup initial vir_page<->phy_page environment for page relpacement algorithm 

     
     pgfault_num=0;
ffffffffc0201500:	00010797          	auipc	a5,0x10
ffffffffc0201504:	0007ac23          	sw	zero,24(a5) # ffffffffc0211518 <pgfault_num>
     *(unsigned char *)0x1000 = 0x0a;
ffffffffc0201508:	4529                	li	a0,10
ffffffffc020150a:	00a60023          	sb	a0,0(a2) # 1000 <kern_entry-0xffffffffc01ff000>
     assert(pgfault_num==1);
ffffffffc020150e:	00010597          	auipc	a1,0x10
ffffffffc0201512:	00a5a583          	lw	a1,10(a1) # ffffffffc0211518 <pgfault_num>
ffffffffc0201516:	4885                	li	a7,1
ffffffffc0201518:	00010797          	auipc	a5,0x10
ffffffffc020151c:	00078793          	mv	a5,a5
ffffffffc0201520:	43159e63          	bne	a1,a7,ffffffffc020195c <swap_init+0x614>
     *(unsigned char *)0x1010 = 0x0a;
ffffffffc0201524:	00a60823          	sb	a0,16(a2)
     assert(pgfault_num==1);
ffffffffc0201528:	4390                	lw	a2,0(a5)
ffffffffc020152a:	2601                	sext.w	a2,a2
ffffffffc020152c:	44b61863          	bne	a2,a1,ffffffffc020197c <swap_init+0x634>
     *(unsigned char *)0x2000 = 0x0b;
ffffffffc0201530:	6589                	lui	a1,0x2
ffffffffc0201532:	452d                	li	a0,11
ffffffffc0201534:	00a58023          	sb	a0,0(a1) # 2000 <kern_entry-0xffffffffc01fe000>
     assert(pgfault_num==2);
ffffffffc0201538:	4390                	lw	a2,0(a5)
ffffffffc020153a:	4889                	li	a7,2
ffffffffc020153c:	2601                	sext.w	a2,a2
ffffffffc020153e:	39161f63          	bne	a2,a7,ffffffffc02018dc <swap_init+0x594>
     *(unsigned char *)0x2010 = 0x0b;
ffffffffc0201542:	00a58823          	sb	a0,16(a1)
     assert(pgfault_num==2);
ffffffffc0201546:	438c                	lw	a1,0(a5)
ffffffffc0201548:	2581                	sext.w	a1,a1
ffffffffc020154a:	3ac59963          	bne	a1,a2,ffffffffc02018fc <swap_init+0x5b4>
     *(unsigned char *)0x3000 = 0x0c;
ffffffffc020154e:	658d                	lui	a1,0x3
ffffffffc0201550:	4531                	li	a0,12
ffffffffc0201552:	00a58023          	sb	a0,0(a1) # 3000 <kern_entry-0xffffffffc01fd000>
     assert(pgfault_num==3);
ffffffffc0201556:	4390                	lw	a2,0(a5)
ffffffffc0201558:	488d                	li	a7,3
ffffffffc020155a:	2601                	sext.w	a2,a2
ffffffffc020155c:	3d161063          	bne	a2,a7,ffffffffc020191c <swap_init+0x5d4>
     *(unsigned char *)0x3010 = 0x0c;
ffffffffc0201560:	00a58823          	sb	a0,16(a1)
     assert(pgfault_num==3);
ffffffffc0201564:	438c                	lw	a1,0(a5)
ffffffffc0201566:	2581                	sext.w	a1,a1
ffffffffc0201568:	3cc59a63          	bne	a1,a2,ffffffffc020193c <swap_init+0x5f4>
     *(unsigned char *)0x4000 = 0x0d;
ffffffffc020156c:	6591                	lui	a1,0x4
ffffffffc020156e:	4535                	li	a0,13
ffffffffc0201570:	00a58023          	sb	a0,0(a1) # 4000 <kern_entry-0xffffffffc01fc000>
     assert(pgfault_num==4);
ffffffffc0201574:	4390                	lw	a2,0(a5)
ffffffffc0201576:	2601                	sext.w	a2,a2
ffffffffc0201578:	27761263          	bne	a2,s7,ffffffffc02017dc <swap_init+0x494>
     *(unsigned char *)0x4010 = 0x0d;
ffffffffc020157c:	00a58823          	sb	a0,16(a1)
     assert(pgfault_num==4);
ffffffffc0201580:	439c                	lw	a5,0(a5)
ffffffffc0201582:	2781                	sext.w	a5,a5
ffffffffc0201584:	26c79c63          	bne	a5,a2,ffffffffc02017fc <swap_init+0x4b4>
     
     check_content_set();
     assert( nr_free == 0);         
ffffffffc0201588:	481c                	lw	a5,16(s0)
ffffffffc020158a:	28079963          	bnez	a5,ffffffffc020181c <swap_init+0x4d4>
ffffffffc020158e:	00010797          	auipc	a5,0x10
ffffffffc0201592:	af278793          	addi	a5,a5,-1294 # ffffffffc0211080 <swap_in_seq_no>
ffffffffc0201596:	00010617          	auipc	a2,0x10
ffffffffc020159a:	b1260613          	addi	a2,a2,-1262 # ffffffffc02110a8 <swap_out_seq_no>
ffffffffc020159e:	00010517          	auipc	a0,0x10
ffffffffc02015a2:	b0a50513          	addi	a0,a0,-1270 # ffffffffc02110a8 <swap_out_seq_no>
     for(i = 0; i<MAX_SEQ_NO ; i++) 
         swap_out_seq_no[i]=swap_in_seq_no[i]=-1;
ffffffffc02015a6:	55fd                	li	a1,-1
ffffffffc02015a8:	c38c                	sw	a1,0(a5)
ffffffffc02015aa:	c20c                	sw	a1,0(a2)
     for(i = 0; i<MAX_SEQ_NO ; i++) 
ffffffffc02015ac:	0791                	addi	a5,a5,4
ffffffffc02015ae:	0611                	addi	a2,a2,4
ffffffffc02015b0:	fef51ce3          	bne	a0,a5,ffffffffc02015a8 <swap_init+0x260>
ffffffffc02015b4:	00010a17          	auipc	s4,0x10
ffffffffc02015b8:	a8ca0a13          	addi	s4,s4,-1396 # ffffffffc0211040 <check_ptep>
ffffffffc02015bc:	00010e97          	auipc	t4,0x10
ffffffffc02015c0:	aa4e8e93          	addi	t4,t4,-1372 # ffffffffc0211060 <check_rp>
     
     for (i= 0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
ffffffffc02015c4:	4301                	li	t1,0
     for(i = 0; i<MAX_SEQ_NO ; i++) 
ffffffffc02015c6:	6e05                	lui	t3,0x1
    return &pages[PPN(pa) - nbase];
ffffffffc02015c8:	00010b97          	auipc	s7,0x10
ffffffffc02015cc:	f90b8b93          	addi	s7,s7,-112 # ffffffffc0211558 <pages>
ffffffffc02015d0:	00005c97          	auipc	s9,0x5
ffffffffc02015d4:	db8c8c93          	addi	s9,s9,-584 # ffffffffc0206388 <nbase>
         check_ptep[i]=0;
         check_ptep[i] = get_pte(pgdir, (i+1)*0x1000, 0);
ffffffffc02015d8:	85f2                	mv	a1,t3
ffffffffc02015da:	4601                	li	a2,0
ffffffffc02015dc:	855a                	mv	a0,s6
ffffffffc02015de:	f076                	sd	t4,32(sp)
ffffffffc02015e0:	ec72                	sd	t3,24(sp)
ffffffffc02015e2:	e81a                	sd	t1,16(sp)
ffffffffc02015e4:	e41a                	sd	t1,8(sp)
         check_ptep[i]=0;
ffffffffc02015e6:	000a3023          	sd	zero,0(s4)
         check_ptep[i] = get_pte(pgdir, (i+1)*0x1000, 0);
ffffffffc02015ea:	626010ef          	jal	ra,ffffffffc0202c10 <get_pte>
         //cprintf("i %d, check_ptep addr %x, value %x\n", i, check_ptep[i], *check_ptep[i]);
         cprintf("%d\n",i);
ffffffffc02015ee:	63a2                	ld	t2,8(sp)
         check_ptep[i] = get_pte(pgdir, (i+1)*0x1000, 0);
ffffffffc02015f0:	87aa                	mv	a5,a0
         cprintf("%d\n",i);
ffffffffc02015f2:	00004517          	auipc	a0,0x4
ffffffffc02015f6:	e3e50513          	addi	a0,a0,-450 # ffffffffc0205430 <commands+0xca0>
ffffffffc02015fa:	859e                	mv	a1,t2
         check_ptep[i] = get_pte(pgdir, (i+1)*0x1000, 0);
ffffffffc02015fc:	00fa3023          	sd	a5,0(s4)
         cprintf("%d\n",i);
ffffffffc0201600:	abbfe0ef          	jal	ra,ffffffffc02000ba <cprintf>
         check_ptep[i] = get_pte(pgdir, (i+1)*0x1000, 0);
ffffffffc0201604:	6342                	ld	t1,16(sp)
         assert(check_ptep[i] != NULL);
ffffffffc0201606:	000a3783          	ld	a5,0(s4)
ffffffffc020160a:	6e62                	ld	t3,24(sp)
ffffffffc020160c:	7e82                	ld	t4,32(sp)
         check_ptep[i] = get_pte(pgdir, (i+1)*0x1000, 0);
ffffffffc020160e:	2305                	addiw	t1,t1,1
         assert(check_ptep[i] != NULL);
ffffffffc0201610:	00010f17          	auipc	t5,0x10
ffffffffc0201614:	f40f0f13          	addi	t5,t5,-192 # ffffffffc0211550 <npage>
ffffffffc0201618:	1a078263          	beqz	a5,ffffffffc02017bc <swap_init+0x474>
         assert(pte2page(*check_ptep[i]) == check_rp[i]);
ffffffffc020161c:	639c                	ld	a5,0(a5)
    if (!(pte & PTE_V)) {
ffffffffc020161e:	0017f613          	andi	a2,a5,1
ffffffffc0201622:	10060963          	beqz	a2,ffffffffc0201734 <swap_init+0x3ec>
    if (PPN(pa) >= npage) {
ffffffffc0201626:	000f3603          	ld	a2,0(t5)
    return pa2page(PTE_ADDR(pte));
ffffffffc020162a:	078a                	slli	a5,a5,0x2
ffffffffc020162c:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage) {
ffffffffc020162e:	10c7ff63          	bgeu	a5,a2,ffffffffc020174c <swap_init+0x404>
    return &pages[PPN(pa) - nbase];
ffffffffc0201632:	000cb503          	ld	a0,0(s9)
ffffffffc0201636:	000bb603          	ld	a2,0(s7)
ffffffffc020163a:	000eb583          	ld	a1,0(t4)
ffffffffc020163e:	8f89                	sub	a5,a5,a0
ffffffffc0201640:	00379513          	slli	a0,a5,0x3
ffffffffc0201644:	97aa                	add	a5,a5,a0
ffffffffc0201646:	078e                	slli	a5,a5,0x3
ffffffffc0201648:	97b2                	add	a5,a5,a2
ffffffffc020164a:	0cf59563          	bne	a1,a5,ffffffffc0201714 <swap_init+0x3cc>
     for (i= 0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
ffffffffc020164e:	6785                	lui	a5,0x1
ffffffffc0201650:	9e3e                	add	t3,t3,a5
ffffffffc0201652:	4791                	li	a5,4
ffffffffc0201654:	0a21                	addi	s4,s4,8
ffffffffc0201656:	0ea1                	addi	t4,t4,8
ffffffffc0201658:	f8f310e3          	bne	t1,a5,ffffffffc02015d8 <swap_init+0x290>
         assert((*check_ptep[i] & PTE_V));          
     }
     cprintf("set up init env for check_swap over!\n");
ffffffffc020165c:	00004517          	auipc	a0,0x4
ffffffffc0201660:	e4450513          	addi	a0,a0,-444 # ffffffffc02054a0 <commands+0xd10>
ffffffffc0201664:	a57fe0ef          	jal	ra,ffffffffc02000ba <cprintf>
    int ret = sm->check_swap();
ffffffffc0201668:	000ab783          	ld	a5,0(s5)
     cprintf("here2\n");
     assert(ret==0);
     
     //restore kernel mem env
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
         cprintf("here1\n");
ffffffffc020166c:	00004a97          	auipc	s5,0x4
ffffffffc0201670:	e6ca8a93          	addi	s5,s5,-404 # ffffffffc02054d8 <commands+0xd48>
    int ret = sm->check_swap();
ffffffffc0201674:	7f9c                	ld	a5,56(a5)
ffffffffc0201676:	9782                	jalr	a5
ffffffffc0201678:	8b2a                	mv	s6,a0
     cprintf("here2\n");
ffffffffc020167a:	00004517          	auipc	a0,0x4
ffffffffc020167e:	e4e50513          	addi	a0,a0,-434 # ffffffffc02054c8 <commands+0xd38>
ffffffffc0201682:	a39fe0ef          	jal	ra,ffffffffc02000ba <cprintf>
     assert(ret==0);
ffffffffc0201686:	1a0b1b63          	bnez	s6,ffffffffc020183c <swap_init+0x4f4>
         cprintf("here1\n");
ffffffffc020168a:	8556                	mv	a0,s5
ffffffffc020168c:	a2ffe0ef          	jal	ra,ffffffffc02000ba <cprintf>
         free_pages(check_rp[i],1);
ffffffffc0201690:	6088                	ld	a0,0(s1)
ffffffffc0201692:	4585                	li	a1,1
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
ffffffffc0201694:	04a1                	addi	s1,s1,8
         free_pages(check_rp[i],1);
ffffffffc0201696:	500010ef          	jal	ra,ffffffffc0202b96 <free_pages>
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
ffffffffc020169a:	ff3498e3          	bne	s1,s3,ffffffffc020168a <swap_init+0x342>
     } 

     //free_page(pte2page(*temp_ptep));
     cprintf("here\n");
ffffffffc020169e:	00004517          	auipc	a0,0x4
ffffffffc02016a2:	e4250513          	addi	a0,a0,-446 # ffffffffc02054e0 <commands+0xd50>
ffffffffc02016a6:	a15fe0ef          	jal	ra,ffffffffc02000ba <cprintf>
     mm_destroy(mm);
ffffffffc02016aa:	7522                	ld	a0,40(sp)
ffffffffc02016ac:	daeff0ef          	jal	ra,ffffffffc0200c5a <mm_destroy>
         
     nr_free = nr_free_store;
ffffffffc02016b0:	77e2                	ld	a5,56(sp)
     free_list = free_list_store;
ffffffffc02016b2:	01843423          	sd	s8,8(s0)
     nr_free = nr_free_store;
ffffffffc02016b6:	c81c                	sw	a5,16(s0)
     free_list = free_list_store;
ffffffffc02016b8:	77c2                	ld	a5,48(sp)
ffffffffc02016ba:	e01c                	sd	a5,0(s0)

     
     le = &free_list;
     while ((le = list_next(le)) != &free_list) {
ffffffffc02016bc:	008c0b63          	beq	s8,s0,ffffffffc02016d2 <swap_init+0x38a>
         struct Page *p = le2page(le, page_link);
         count --, total -= p->property;
ffffffffc02016c0:	ff8c2783          	lw	a5,-8(s8)
    return listelm->next;
ffffffffc02016c4:	008c3c03          	ld	s8,8(s8)
ffffffffc02016c8:	3d7d                	addiw	s10,s10,-1
ffffffffc02016ca:	40fd8dbb          	subw	s11,s11,a5
     while ((le = list_next(le)) != &free_list) {
ffffffffc02016ce:	fe8c19e3          	bne	s8,s0,ffffffffc02016c0 <swap_init+0x378>
     }
     cprintf("count is %d, total is %d\n",count,total);
ffffffffc02016d2:	866e                	mv	a2,s11
ffffffffc02016d4:	85ea                	mv	a1,s10
ffffffffc02016d6:	00004517          	auipc	a0,0x4
ffffffffc02016da:	e1250513          	addi	a0,a0,-494 # ffffffffc02054e8 <commands+0xd58>
ffffffffc02016de:	9ddfe0ef          	jal	ra,ffffffffc02000ba <cprintf>
     //assert(count == 0);
     
     cprintf("check_swap() succeeded!\n");
ffffffffc02016e2:	00004517          	auipc	a0,0x4
ffffffffc02016e6:	e2650513          	addi	a0,a0,-474 # ffffffffc0205508 <commands+0xd78>
ffffffffc02016ea:	9d1fe0ef          	jal	ra,ffffffffc02000ba <cprintf>
}
ffffffffc02016ee:	b175                	j	ffffffffc020139a <swap_init+0x52>
     while ((le = list_next(le)) != &free_list) {
ffffffffc02016f0:	4481                	li	s1,0
ffffffffc02016f2:	bb09                	j	ffffffffc0201404 <swap_init+0xbc>
        assert(PageProperty(p));
ffffffffc02016f4:	00004697          	auipc	a3,0x4
ffffffffc02016f8:	b7c68693          	addi	a3,a3,-1156 # ffffffffc0205270 <commands+0xae0>
ffffffffc02016fc:	00003617          	auipc	a2,0x3
ffffffffc0201700:	7bc60613          	addi	a2,a2,1980 # ffffffffc0204eb8 <commands+0x728>
ffffffffc0201704:	0ba00593          	li	a1,186
ffffffffc0201708:	00004517          	auipc	a0,0x4
ffffffffc020170c:	b4050513          	addi	a0,a0,-1216 # ffffffffc0205248 <commands+0xab8>
ffffffffc0201710:	9f3fe0ef          	jal	ra,ffffffffc0200102 <__panic>
         assert(pte2page(*check_ptep[i]) == check_rp[i]);
ffffffffc0201714:	00004697          	auipc	a3,0x4
ffffffffc0201718:	d6468693          	addi	a3,a3,-668 # ffffffffc0205478 <commands+0xce8>
ffffffffc020171c:	00003617          	auipc	a2,0x3
ffffffffc0201720:	79c60613          	addi	a2,a2,1948 # ffffffffc0204eb8 <commands+0x728>
ffffffffc0201724:	0fb00593          	li	a1,251
ffffffffc0201728:	00004517          	auipc	a0,0x4
ffffffffc020172c:	b2050513          	addi	a0,a0,-1248 # ffffffffc0205248 <commands+0xab8>
ffffffffc0201730:	9d3fe0ef          	jal	ra,ffffffffc0200102 <__panic>
        panic("pte2page called with invalid pte");
ffffffffc0201734:	00004617          	auipc	a2,0x4
ffffffffc0201738:	d1c60613          	addi	a2,a2,-740 # ffffffffc0205450 <commands+0xcc0>
ffffffffc020173c:	07000593          	li	a1,112
ffffffffc0201740:	00004517          	auipc	a0,0x4
ffffffffc0201744:	9e850513          	addi	a0,a0,-1560 # ffffffffc0205128 <commands+0x998>
ffffffffc0201748:	9bbfe0ef          	jal	ra,ffffffffc0200102 <__panic>
        panic("pa2page called with invalid pa");
ffffffffc020174c:	00004617          	auipc	a2,0x4
ffffffffc0201750:	9bc60613          	addi	a2,a2,-1604 # ffffffffc0205108 <commands+0x978>
ffffffffc0201754:	06500593          	li	a1,101
ffffffffc0201758:	00004517          	auipc	a0,0x4
ffffffffc020175c:	9d050513          	addi	a0,a0,-1584 # ffffffffc0205128 <commands+0x998>
ffffffffc0201760:	9a3fe0ef          	jal	ra,ffffffffc0200102 <__panic>
          assert(!PageProperty(check_rp[i]));
ffffffffc0201764:	00004697          	auipc	a3,0x4
ffffffffc0201768:	c0c68693          	addi	a3,a3,-1012 # ffffffffc0205370 <commands+0xbe0>
ffffffffc020176c:	00003617          	auipc	a2,0x3
ffffffffc0201770:	74c60613          	addi	a2,a2,1868 # ffffffffc0204eb8 <commands+0x728>
ffffffffc0201774:	0db00593          	li	a1,219
ffffffffc0201778:	00004517          	auipc	a0,0x4
ffffffffc020177c:	ad050513          	addi	a0,a0,-1328 # ffffffffc0205248 <commands+0xab8>
ffffffffc0201780:	983fe0ef          	jal	ra,ffffffffc0200102 <__panic>
          assert(check_rp[i] != NULL );
ffffffffc0201784:	00004697          	auipc	a3,0x4
ffffffffc0201788:	bd468693          	addi	a3,a3,-1068 # ffffffffc0205358 <commands+0xbc8>
ffffffffc020178c:	00003617          	auipc	a2,0x3
ffffffffc0201790:	72c60613          	addi	a2,a2,1836 # ffffffffc0204eb8 <commands+0x728>
ffffffffc0201794:	0da00593          	li	a1,218
ffffffffc0201798:	00004517          	auipc	a0,0x4
ffffffffc020179c:	ab050513          	addi	a0,a0,-1360 # ffffffffc0205248 <commands+0xab8>
ffffffffc02017a0:	963fe0ef          	jal	ra,ffffffffc0200102 <__panic>
        panic("bad max_swap_offset %08x.\n", max_swap_offset);
ffffffffc02017a4:	00004617          	auipc	a2,0x4
ffffffffc02017a8:	a8460613          	addi	a2,a2,-1404 # ffffffffc0205228 <commands+0xa98>
ffffffffc02017ac:	02700593          	li	a1,39
ffffffffc02017b0:	00004517          	auipc	a0,0x4
ffffffffc02017b4:	a9850513          	addi	a0,a0,-1384 # ffffffffc0205248 <commands+0xab8>
ffffffffc02017b8:	94bfe0ef          	jal	ra,ffffffffc0200102 <__panic>
         assert(check_ptep[i] != NULL);
ffffffffc02017bc:	00004697          	auipc	a3,0x4
ffffffffc02017c0:	c7c68693          	addi	a3,a3,-900 # ffffffffc0205438 <commands+0xca8>
ffffffffc02017c4:	00003617          	auipc	a2,0x3
ffffffffc02017c8:	6f460613          	addi	a2,a2,1780 # ffffffffc0204eb8 <commands+0x728>
ffffffffc02017cc:	0fa00593          	li	a1,250
ffffffffc02017d0:	00004517          	auipc	a0,0x4
ffffffffc02017d4:	a7850513          	addi	a0,a0,-1416 # ffffffffc0205248 <commands+0xab8>
ffffffffc02017d8:	92bfe0ef          	jal	ra,ffffffffc0200102 <__panic>
     assert(pgfault_num==4);
ffffffffc02017dc:	00004697          	auipc	a3,0x4
ffffffffc02017e0:	c3468693          	addi	a3,a3,-972 # ffffffffc0205410 <commands+0xc80>
ffffffffc02017e4:	00003617          	auipc	a2,0x3
ffffffffc02017e8:	6d460613          	addi	a2,a2,1748 # ffffffffc0204eb8 <commands+0x728>
ffffffffc02017ec:	09d00593          	li	a1,157
ffffffffc02017f0:	00004517          	auipc	a0,0x4
ffffffffc02017f4:	a5850513          	addi	a0,a0,-1448 # ffffffffc0205248 <commands+0xab8>
ffffffffc02017f8:	90bfe0ef          	jal	ra,ffffffffc0200102 <__panic>
     assert(pgfault_num==4);
ffffffffc02017fc:	00004697          	auipc	a3,0x4
ffffffffc0201800:	c1468693          	addi	a3,a3,-1004 # ffffffffc0205410 <commands+0xc80>
ffffffffc0201804:	00003617          	auipc	a2,0x3
ffffffffc0201808:	6b460613          	addi	a2,a2,1716 # ffffffffc0204eb8 <commands+0x728>
ffffffffc020180c:	09f00593          	li	a1,159
ffffffffc0201810:	00004517          	auipc	a0,0x4
ffffffffc0201814:	a3850513          	addi	a0,a0,-1480 # ffffffffc0205248 <commands+0xab8>
ffffffffc0201818:	8ebfe0ef          	jal	ra,ffffffffc0200102 <__panic>
     assert( nr_free == 0);         
ffffffffc020181c:	00004697          	auipc	a3,0x4
ffffffffc0201820:	c0468693          	addi	a3,a3,-1020 # ffffffffc0205420 <commands+0xc90>
ffffffffc0201824:	00003617          	auipc	a2,0x3
ffffffffc0201828:	69460613          	addi	a2,a2,1684 # ffffffffc0204eb8 <commands+0x728>
ffffffffc020182c:	0f100593          	li	a1,241
ffffffffc0201830:	00004517          	auipc	a0,0x4
ffffffffc0201834:	a1850513          	addi	a0,a0,-1512 # ffffffffc0205248 <commands+0xab8>
ffffffffc0201838:	8cbfe0ef          	jal	ra,ffffffffc0200102 <__panic>
     assert(ret==0);
ffffffffc020183c:	00004697          	auipc	a3,0x4
ffffffffc0201840:	c9468693          	addi	a3,a3,-876 # ffffffffc02054d0 <commands+0xd40>
ffffffffc0201844:	00003617          	auipc	a2,0x3
ffffffffc0201848:	67460613          	addi	a2,a2,1652 # ffffffffc0204eb8 <commands+0x728>
ffffffffc020184c:	10200593          	li	a1,258
ffffffffc0201850:	00004517          	auipc	a0,0x4
ffffffffc0201854:	9f850513          	addi	a0,a0,-1544 # ffffffffc0205248 <commands+0xab8>
ffffffffc0201858:	8abfe0ef          	jal	ra,ffffffffc0200102 <__panic>
     assert(pgdir[0] == 0);
ffffffffc020185c:	00004697          	auipc	a3,0x4
ffffffffc0201860:	86c68693          	addi	a3,a3,-1940 # ffffffffc02050c8 <commands+0x938>
ffffffffc0201864:	00003617          	auipc	a2,0x3
ffffffffc0201868:	65460613          	addi	a2,a2,1620 # ffffffffc0204eb8 <commands+0x728>
ffffffffc020186c:	0ca00593          	li	a1,202
ffffffffc0201870:	00004517          	auipc	a0,0x4
ffffffffc0201874:	9d850513          	addi	a0,a0,-1576 # ffffffffc0205248 <commands+0xab8>
ffffffffc0201878:	88bfe0ef          	jal	ra,ffffffffc0200102 <__panic>
     assert(vma != NULL);
ffffffffc020187c:	00004697          	auipc	a3,0x4
ffffffffc0201880:	8f468693          	addi	a3,a3,-1804 # ffffffffc0205170 <commands+0x9e0>
ffffffffc0201884:	00003617          	auipc	a2,0x3
ffffffffc0201888:	63460613          	addi	a2,a2,1588 # ffffffffc0204eb8 <commands+0x728>
ffffffffc020188c:	0cd00593          	li	a1,205
ffffffffc0201890:	00004517          	auipc	a0,0x4
ffffffffc0201894:	9b850513          	addi	a0,a0,-1608 # ffffffffc0205248 <commands+0xab8>
ffffffffc0201898:	86bfe0ef          	jal	ra,ffffffffc0200102 <__panic>
     assert(temp_ptep!= NULL);
ffffffffc020189c:	00004697          	auipc	a3,0x4
ffffffffc02018a0:	a7c68693          	addi	a3,a3,-1412 # ffffffffc0205318 <commands+0xb88>
ffffffffc02018a4:	00003617          	auipc	a2,0x3
ffffffffc02018a8:	61460613          	addi	a2,a2,1556 # ffffffffc0204eb8 <commands+0x728>
ffffffffc02018ac:	0d500593          	li	a1,213
ffffffffc02018b0:	00004517          	auipc	a0,0x4
ffffffffc02018b4:	99850513          	addi	a0,a0,-1640 # ffffffffc0205248 <commands+0xab8>
ffffffffc02018b8:	84bfe0ef          	jal	ra,ffffffffc0200102 <__panic>
     assert(total == nr_free_pages());
ffffffffc02018bc:	00004697          	auipc	a3,0x4
ffffffffc02018c0:	9c468693          	addi	a3,a3,-1596 # ffffffffc0205280 <commands+0xaf0>
ffffffffc02018c4:	00003617          	auipc	a2,0x3
ffffffffc02018c8:	5f460613          	addi	a2,a2,1524 # ffffffffc0204eb8 <commands+0x728>
ffffffffc02018cc:	0bd00593          	li	a1,189
ffffffffc02018d0:	00004517          	auipc	a0,0x4
ffffffffc02018d4:	97850513          	addi	a0,a0,-1672 # ffffffffc0205248 <commands+0xab8>
ffffffffc02018d8:	82bfe0ef          	jal	ra,ffffffffc0200102 <__panic>
     assert(pgfault_num==2);
ffffffffc02018dc:	00004697          	auipc	a3,0x4
ffffffffc02018e0:	b1468693          	addi	a3,a3,-1260 # ffffffffc02053f0 <commands+0xc60>
ffffffffc02018e4:	00003617          	auipc	a2,0x3
ffffffffc02018e8:	5d460613          	addi	a2,a2,1492 # ffffffffc0204eb8 <commands+0x728>
ffffffffc02018ec:	09500593          	li	a1,149
ffffffffc02018f0:	00004517          	auipc	a0,0x4
ffffffffc02018f4:	95850513          	addi	a0,a0,-1704 # ffffffffc0205248 <commands+0xab8>
ffffffffc02018f8:	80bfe0ef          	jal	ra,ffffffffc0200102 <__panic>
     assert(pgfault_num==2);
ffffffffc02018fc:	00004697          	auipc	a3,0x4
ffffffffc0201900:	af468693          	addi	a3,a3,-1292 # ffffffffc02053f0 <commands+0xc60>
ffffffffc0201904:	00003617          	auipc	a2,0x3
ffffffffc0201908:	5b460613          	addi	a2,a2,1460 # ffffffffc0204eb8 <commands+0x728>
ffffffffc020190c:	09700593          	li	a1,151
ffffffffc0201910:	00004517          	auipc	a0,0x4
ffffffffc0201914:	93850513          	addi	a0,a0,-1736 # ffffffffc0205248 <commands+0xab8>
ffffffffc0201918:	feafe0ef          	jal	ra,ffffffffc0200102 <__panic>
     assert(pgfault_num==3);
ffffffffc020191c:	00004697          	auipc	a3,0x4
ffffffffc0201920:	ae468693          	addi	a3,a3,-1308 # ffffffffc0205400 <commands+0xc70>
ffffffffc0201924:	00003617          	auipc	a2,0x3
ffffffffc0201928:	59460613          	addi	a2,a2,1428 # ffffffffc0204eb8 <commands+0x728>
ffffffffc020192c:	09900593          	li	a1,153
ffffffffc0201930:	00004517          	auipc	a0,0x4
ffffffffc0201934:	91850513          	addi	a0,a0,-1768 # ffffffffc0205248 <commands+0xab8>
ffffffffc0201938:	fcafe0ef          	jal	ra,ffffffffc0200102 <__panic>
     assert(pgfault_num==3);
ffffffffc020193c:	00004697          	auipc	a3,0x4
ffffffffc0201940:	ac468693          	addi	a3,a3,-1340 # ffffffffc0205400 <commands+0xc70>
ffffffffc0201944:	00003617          	auipc	a2,0x3
ffffffffc0201948:	57460613          	addi	a2,a2,1396 # ffffffffc0204eb8 <commands+0x728>
ffffffffc020194c:	09b00593          	li	a1,155
ffffffffc0201950:	00004517          	auipc	a0,0x4
ffffffffc0201954:	8f850513          	addi	a0,a0,-1800 # ffffffffc0205248 <commands+0xab8>
ffffffffc0201958:	faafe0ef          	jal	ra,ffffffffc0200102 <__panic>
     assert(pgfault_num==1);
ffffffffc020195c:	00004697          	auipc	a3,0x4
ffffffffc0201960:	a8468693          	addi	a3,a3,-1404 # ffffffffc02053e0 <commands+0xc50>
ffffffffc0201964:	00003617          	auipc	a2,0x3
ffffffffc0201968:	55460613          	addi	a2,a2,1364 # ffffffffc0204eb8 <commands+0x728>
ffffffffc020196c:	09100593          	li	a1,145
ffffffffc0201970:	00004517          	auipc	a0,0x4
ffffffffc0201974:	8d850513          	addi	a0,a0,-1832 # ffffffffc0205248 <commands+0xab8>
ffffffffc0201978:	f8afe0ef          	jal	ra,ffffffffc0200102 <__panic>
     assert(pgfault_num==1);
ffffffffc020197c:	00004697          	auipc	a3,0x4
ffffffffc0201980:	a6468693          	addi	a3,a3,-1436 # ffffffffc02053e0 <commands+0xc50>
ffffffffc0201984:	00003617          	auipc	a2,0x3
ffffffffc0201988:	53460613          	addi	a2,a2,1332 # ffffffffc0204eb8 <commands+0x728>
ffffffffc020198c:	09300593          	li	a1,147
ffffffffc0201990:	00004517          	auipc	a0,0x4
ffffffffc0201994:	8b850513          	addi	a0,a0,-1864 # ffffffffc0205248 <commands+0xab8>
ffffffffc0201998:	f6afe0ef          	jal	ra,ffffffffc0200102 <__panic>
     assert(mm != NULL);
ffffffffc020199c:	00003697          	auipc	a3,0x3
ffffffffc02019a0:	7fc68693          	addi	a3,a3,2044 # ffffffffc0205198 <commands+0xa08>
ffffffffc02019a4:	00003617          	auipc	a2,0x3
ffffffffc02019a8:	51460613          	addi	a2,a2,1300 # ffffffffc0204eb8 <commands+0x728>
ffffffffc02019ac:	0c200593          	li	a1,194
ffffffffc02019b0:	00004517          	auipc	a0,0x4
ffffffffc02019b4:	89850513          	addi	a0,a0,-1896 # ffffffffc0205248 <commands+0xab8>
ffffffffc02019b8:	f4afe0ef          	jal	ra,ffffffffc0200102 <__panic>
     assert(check_mm_struct == NULL);
ffffffffc02019bc:	00004697          	auipc	a3,0x4
ffffffffc02019c0:	90c68693          	addi	a3,a3,-1780 # ffffffffc02052c8 <commands+0xb38>
ffffffffc02019c4:	00003617          	auipc	a2,0x3
ffffffffc02019c8:	4f460613          	addi	a2,a2,1268 # ffffffffc0204eb8 <commands+0x728>
ffffffffc02019cc:	0c500593          	li	a1,197
ffffffffc02019d0:	00004517          	auipc	a0,0x4
ffffffffc02019d4:	87850513          	addi	a0,a0,-1928 # ffffffffc0205248 <commands+0xab8>
ffffffffc02019d8:	f2afe0ef          	jal	ra,ffffffffc0200102 <__panic>
     assert(nr_free==CHECK_VALID_PHY_PAGE_NUM);
ffffffffc02019dc:	00004697          	auipc	a3,0x4
ffffffffc02019e0:	9b468693          	addi	a3,a3,-1612 # ffffffffc0205390 <commands+0xc00>
ffffffffc02019e4:	00003617          	auipc	a2,0x3
ffffffffc02019e8:	4d460613          	addi	a2,a2,1236 # ffffffffc0204eb8 <commands+0x728>
ffffffffc02019ec:	0e800593          	li	a1,232
ffffffffc02019f0:	00004517          	auipc	a0,0x4
ffffffffc02019f4:	85850513          	addi	a0,a0,-1960 # ffffffffc0205248 <commands+0xab8>
ffffffffc02019f8:	f0afe0ef          	jal	ra,ffffffffc0200102 <__panic>

ffffffffc02019fc <swap_init_mm>:
     return sm->init_mm(mm);
ffffffffc02019fc:	00010797          	auipc	a5,0x10
ffffffffc0201a00:	b2c7b783          	ld	a5,-1236(a5) # ffffffffc0211528 <sm>
ffffffffc0201a04:	6b9c                	ld	a5,16(a5)
ffffffffc0201a06:	8782                	jr	a5

ffffffffc0201a08 <swap_map_swappable>:
     return sm->map_swappable(mm, addr, page, swap_in);
ffffffffc0201a08:	00010797          	auipc	a5,0x10
ffffffffc0201a0c:	b207b783          	ld	a5,-1248(a5) # ffffffffc0211528 <sm>
ffffffffc0201a10:	739c                	ld	a5,32(a5)
ffffffffc0201a12:	8782                	jr	a5

ffffffffc0201a14 <swap_out>:
{
ffffffffc0201a14:	711d                	addi	sp,sp,-96
ffffffffc0201a16:	ec86                	sd	ra,88(sp)
ffffffffc0201a18:	e8a2                	sd	s0,80(sp)
ffffffffc0201a1a:	e4a6                	sd	s1,72(sp)
ffffffffc0201a1c:	e0ca                	sd	s2,64(sp)
ffffffffc0201a1e:	fc4e                	sd	s3,56(sp)
ffffffffc0201a20:	f852                	sd	s4,48(sp)
ffffffffc0201a22:	f456                	sd	s5,40(sp)
ffffffffc0201a24:	f05a                	sd	s6,32(sp)
ffffffffc0201a26:	ec5e                	sd	s7,24(sp)
ffffffffc0201a28:	e862                	sd	s8,16(sp)
     for (i = 0; i != n; ++ i)
ffffffffc0201a2a:	cde9                	beqz	a1,ffffffffc0201b04 <swap_out+0xf0>
ffffffffc0201a2c:	8a2e                	mv	s4,a1
ffffffffc0201a2e:	892a                	mv	s2,a0
ffffffffc0201a30:	8ab2                	mv	s5,a2
ffffffffc0201a32:	4401                	li	s0,0
ffffffffc0201a34:	00010997          	auipc	s3,0x10
ffffffffc0201a38:	af498993          	addi	s3,s3,-1292 # ffffffffc0211528 <sm>
                    cprintf("swap_out: i %d, store page in vaddr 0x%x to disk swap entry %d\n", i, v, page->pra_vaddr/PGSIZE+1);
ffffffffc0201a3c:	00004b17          	auipc	s6,0x4
ffffffffc0201a40:	b4cb0b13          	addi	s6,s6,-1204 # ffffffffc0205588 <commands+0xdf8>
                    cprintf("SWAP: failed to save\n");
ffffffffc0201a44:	00004b97          	auipc	s7,0x4
ffffffffc0201a48:	b2cb8b93          	addi	s7,s7,-1236 # ffffffffc0205570 <commands+0xde0>
ffffffffc0201a4c:	a825                	j	ffffffffc0201a84 <swap_out+0x70>
                    cprintf("swap_out: i %d, store page in vaddr 0x%x to disk swap entry %d\n", i, v, page->pra_vaddr/PGSIZE+1);
ffffffffc0201a4e:	67a2                	ld	a5,8(sp)
ffffffffc0201a50:	8626                	mv	a2,s1
ffffffffc0201a52:	85a2                	mv	a1,s0
ffffffffc0201a54:	63b4                	ld	a3,64(a5)
ffffffffc0201a56:	855a                	mv	a0,s6
     for (i = 0; i != n; ++ i)
ffffffffc0201a58:	2405                	addiw	s0,s0,1
                    cprintf("swap_out: i %d, store page in vaddr 0x%x to disk swap entry %d\n", i, v, page->pra_vaddr/PGSIZE+1);
ffffffffc0201a5a:	82b1                	srli	a3,a3,0xc
ffffffffc0201a5c:	0685                	addi	a3,a3,1
ffffffffc0201a5e:	e5cfe0ef          	jal	ra,ffffffffc02000ba <cprintf>
                    *ptep = (page->pra_vaddr/PGSIZE+1)<<8;
ffffffffc0201a62:	6522                	ld	a0,8(sp)
                    free_page(page);
ffffffffc0201a64:	4585                	li	a1,1
                    *ptep = (page->pra_vaddr/PGSIZE+1)<<8;
ffffffffc0201a66:	613c                	ld	a5,64(a0)
ffffffffc0201a68:	83b1                	srli	a5,a5,0xc
ffffffffc0201a6a:	0785                	addi	a5,a5,1
ffffffffc0201a6c:	07a2                	slli	a5,a5,0x8
ffffffffc0201a6e:	00fc3023          	sd	a5,0(s8)
                    free_page(page);
ffffffffc0201a72:	124010ef          	jal	ra,ffffffffc0202b96 <free_pages>
          tlb_invalidate(mm->pgdir, v);
ffffffffc0201a76:	01893503          	ld	a0,24(s2)
ffffffffc0201a7a:	85a6                	mv	a1,s1
ffffffffc0201a7c:	182020ef          	jal	ra,ffffffffc0203bfe <tlb_invalidate>
     for (i = 0; i != n; ++ i)
ffffffffc0201a80:	048a0d63          	beq	s4,s0,ffffffffc0201ada <swap_out+0xc6>
          int r = sm->swap_out_victim(mm, &page, in_tick);
ffffffffc0201a84:	0009b783          	ld	a5,0(s3)
ffffffffc0201a88:	8656                	mv	a2,s5
ffffffffc0201a8a:	002c                	addi	a1,sp,8
ffffffffc0201a8c:	7b9c                	ld	a5,48(a5)
ffffffffc0201a8e:	854a                	mv	a0,s2
ffffffffc0201a90:	9782                	jalr	a5
          if (r != 0) {
ffffffffc0201a92:	e12d                	bnez	a0,ffffffffc0201af4 <swap_out+0xe0>
          v=page->pra_vaddr; 
ffffffffc0201a94:	67a2                	ld	a5,8(sp)
          pte_t *ptep = get_pte(mm->pgdir, v, 0);
ffffffffc0201a96:	01893503          	ld	a0,24(s2)
ffffffffc0201a9a:	4601                	li	a2,0
          v=page->pra_vaddr; 
ffffffffc0201a9c:	63a4                	ld	s1,64(a5)
          pte_t *ptep = get_pte(mm->pgdir, v, 0);
ffffffffc0201a9e:	85a6                	mv	a1,s1
ffffffffc0201aa0:	170010ef          	jal	ra,ffffffffc0202c10 <get_pte>
          assert((*ptep & PTE_V) != 0);
ffffffffc0201aa4:	611c                	ld	a5,0(a0)
          pte_t *ptep = get_pte(mm->pgdir, v, 0);
ffffffffc0201aa6:	8c2a                	mv	s8,a0
          assert((*ptep & PTE_V) != 0);
ffffffffc0201aa8:	8b85                	andi	a5,a5,1
ffffffffc0201aaa:	cfb9                	beqz	a5,ffffffffc0201b08 <swap_out+0xf4>
          if (swapfs_write( (page->pra_vaddr/PGSIZE+1)<<8, page) != 0) {
ffffffffc0201aac:	65a2                	ld	a1,8(sp)
ffffffffc0201aae:	61bc                	ld	a5,64(a1)
ffffffffc0201ab0:	83b1                	srli	a5,a5,0xc
ffffffffc0201ab2:	0785                	addi	a5,a5,1
ffffffffc0201ab4:	00879513          	slli	a0,a5,0x8
ffffffffc0201ab8:	478020ef          	jal	ra,ffffffffc0203f30 <swapfs_write>
ffffffffc0201abc:	d949                	beqz	a0,ffffffffc0201a4e <swap_out+0x3a>
                    cprintf("SWAP: failed to save\n");
ffffffffc0201abe:	855e                	mv	a0,s7
ffffffffc0201ac0:	dfafe0ef          	jal	ra,ffffffffc02000ba <cprintf>
                    sm->map_swappable(mm, v, page, 0);
ffffffffc0201ac4:	0009b783          	ld	a5,0(s3)
ffffffffc0201ac8:	6622                	ld	a2,8(sp)
ffffffffc0201aca:	4681                	li	a3,0
ffffffffc0201acc:	739c                	ld	a5,32(a5)
ffffffffc0201ace:	85a6                	mv	a1,s1
ffffffffc0201ad0:	854a                	mv	a0,s2
     for (i = 0; i != n; ++ i)
ffffffffc0201ad2:	2405                	addiw	s0,s0,1
                    sm->map_swappable(mm, v, page, 0);
ffffffffc0201ad4:	9782                	jalr	a5
     for (i = 0; i != n; ++ i)
ffffffffc0201ad6:	fa8a17e3          	bne	s4,s0,ffffffffc0201a84 <swap_out+0x70>
}
ffffffffc0201ada:	60e6                	ld	ra,88(sp)
ffffffffc0201adc:	8522                	mv	a0,s0
ffffffffc0201ade:	6446                	ld	s0,80(sp)
ffffffffc0201ae0:	64a6                	ld	s1,72(sp)
ffffffffc0201ae2:	6906                	ld	s2,64(sp)
ffffffffc0201ae4:	79e2                	ld	s3,56(sp)
ffffffffc0201ae6:	7a42                	ld	s4,48(sp)
ffffffffc0201ae8:	7aa2                	ld	s5,40(sp)
ffffffffc0201aea:	7b02                	ld	s6,32(sp)
ffffffffc0201aec:	6be2                	ld	s7,24(sp)
ffffffffc0201aee:	6c42                	ld	s8,16(sp)
ffffffffc0201af0:	6125                	addi	sp,sp,96
ffffffffc0201af2:	8082                	ret
                    cprintf("i %d, swap_out: call swap_out_victim failed\n",i);
ffffffffc0201af4:	85a2                	mv	a1,s0
ffffffffc0201af6:	00004517          	auipc	a0,0x4
ffffffffc0201afa:	a3250513          	addi	a0,a0,-1486 # ffffffffc0205528 <commands+0xd98>
ffffffffc0201afe:	dbcfe0ef          	jal	ra,ffffffffc02000ba <cprintf>
                  break;
ffffffffc0201b02:	bfe1                	j	ffffffffc0201ada <swap_out+0xc6>
     for (i = 0; i != n; ++ i)
ffffffffc0201b04:	4401                	li	s0,0
ffffffffc0201b06:	bfd1                	j	ffffffffc0201ada <swap_out+0xc6>
          assert((*ptep & PTE_V) != 0);
ffffffffc0201b08:	00004697          	auipc	a3,0x4
ffffffffc0201b0c:	a5068693          	addi	a3,a3,-1456 # ffffffffc0205558 <commands+0xdc8>
ffffffffc0201b10:	00003617          	auipc	a2,0x3
ffffffffc0201b14:	3a860613          	addi	a2,a2,936 # ffffffffc0204eb8 <commands+0x728>
ffffffffc0201b18:	06600593          	li	a1,102
ffffffffc0201b1c:	00003517          	auipc	a0,0x3
ffffffffc0201b20:	72c50513          	addi	a0,a0,1836 # ffffffffc0205248 <commands+0xab8>
ffffffffc0201b24:	ddefe0ef          	jal	ra,ffffffffc0200102 <__panic>

ffffffffc0201b28 <swap_in>:
{
ffffffffc0201b28:	7179                	addi	sp,sp,-48
ffffffffc0201b2a:	e84a                	sd	s2,16(sp)
ffffffffc0201b2c:	892a                	mv	s2,a0
     struct Page *result = alloc_page();
ffffffffc0201b2e:	4505                	li	a0,1
{
ffffffffc0201b30:	ec26                	sd	s1,24(sp)
ffffffffc0201b32:	e44e                	sd	s3,8(sp)
ffffffffc0201b34:	f406                	sd	ra,40(sp)
ffffffffc0201b36:	f022                	sd	s0,32(sp)
ffffffffc0201b38:	84ae                	mv	s1,a1
ffffffffc0201b3a:	89b2                	mv	s3,a2
     struct Page *result = alloc_page();
ffffffffc0201b3c:	7c9000ef          	jal	ra,ffffffffc0202b04 <alloc_pages>
     assert(result!=NULL);
ffffffffc0201b40:	c129                	beqz	a0,ffffffffc0201b82 <swap_in+0x5a>
     pte_t *ptep = get_pte(mm->pgdir, addr, 0);
ffffffffc0201b42:	842a                	mv	s0,a0
ffffffffc0201b44:	01893503          	ld	a0,24(s2)
ffffffffc0201b48:	4601                	li	a2,0
ffffffffc0201b4a:	85a6                	mv	a1,s1
ffffffffc0201b4c:	0c4010ef          	jal	ra,ffffffffc0202c10 <get_pte>
ffffffffc0201b50:	892a                	mv	s2,a0
     if ((r = swapfs_read((*ptep), result)) != 0)
ffffffffc0201b52:	6108                	ld	a0,0(a0)
ffffffffc0201b54:	85a2                	mv	a1,s0
ffffffffc0201b56:	340020ef          	jal	ra,ffffffffc0203e96 <swapfs_read>
     cprintf("swap_in: load disk swap entry %d with swap_page in vadr 0x%x\n", (*ptep)>>8, addr);
ffffffffc0201b5a:	00093583          	ld	a1,0(s2)
ffffffffc0201b5e:	8626                	mv	a2,s1
ffffffffc0201b60:	00004517          	auipc	a0,0x4
ffffffffc0201b64:	a7850513          	addi	a0,a0,-1416 # ffffffffc02055d8 <commands+0xe48>
ffffffffc0201b68:	81a1                	srli	a1,a1,0x8
ffffffffc0201b6a:	d50fe0ef          	jal	ra,ffffffffc02000ba <cprintf>
}
ffffffffc0201b6e:	70a2                	ld	ra,40(sp)
     *ptr_result=result;
ffffffffc0201b70:	0089b023          	sd	s0,0(s3)
}
ffffffffc0201b74:	7402                	ld	s0,32(sp)
ffffffffc0201b76:	64e2                	ld	s1,24(sp)
ffffffffc0201b78:	6942                	ld	s2,16(sp)
ffffffffc0201b7a:	69a2                	ld	s3,8(sp)
ffffffffc0201b7c:	4501                	li	a0,0
ffffffffc0201b7e:	6145                	addi	sp,sp,48
ffffffffc0201b80:	8082                	ret
     assert(result!=NULL);
ffffffffc0201b82:	00004697          	auipc	a3,0x4
ffffffffc0201b86:	a4668693          	addi	a3,a3,-1466 # ffffffffc02055c8 <commands+0xe38>
ffffffffc0201b8a:	00003617          	auipc	a2,0x3
ffffffffc0201b8e:	32e60613          	addi	a2,a2,814 # ffffffffc0204eb8 <commands+0x728>
ffffffffc0201b92:	07c00593          	li	a1,124
ffffffffc0201b96:	00003517          	auipc	a0,0x3
ffffffffc0201b9a:	6b250513          	addi	a0,a0,1714 # ffffffffc0205248 <commands+0xab8>
ffffffffc0201b9e:	d64fe0ef          	jal	ra,ffffffffc0200102 <__panic>

ffffffffc0201ba2 <default_init>:
    elm->prev = elm->next = elm;
ffffffffc0201ba2:	0000f797          	auipc	a5,0xf
ffffffffc0201ba6:	52e78793          	addi	a5,a5,1326 # ffffffffc02110d0 <free_area>
ffffffffc0201baa:	e79c                	sd	a5,8(a5)
ffffffffc0201bac:	e39c                	sd	a5,0(a5)
#define nr_free (free_area.nr_free)

static void
default_init(void) {
    list_init(&free_list);
    nr_free = 0;
ffffffffc0201bae:	0007a823          	sw	zero,16(a5)
}
ffffffffc0201bb2:	8082                	ret

ffffffffc0201bb4 <default_nr_free_pages>:
}

static size_t
default_nr_free_pages(void) {
    return nr_free;
}
ffffffffc0201bb4:	0000f517          	auipc	a0,0xf
ffffffffc0201bb8:	52c56503          	lwu	a0,1324(a0) # ffffffffc02110e0 <free_area+0x10>
ffffffffc0201bbc:	8082                	ret

ffffffffc0201bbe <default_check>:
}

// LAB2: below code is used to check the first fit allocation algorithm
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
ffffffffc0201bbe:	715d                	addi	sp,sp,-80
ffffffffc0201bc0:	e0a2                	sd	s0,64(sp)
    return listelm->next;
ffffffffc0201bc2:	0000f417          	auipc	s0,0xf
ffffffffc0201bc6:	50e40413          	addi	s0,s0,1294 # ffffffffc02110d0 <free_area>
ffffffffc0201bca:	641c                	ld	a5,8(s0)
ffffffffc0201bcc:	e486                	sd	ra,72(sp)
ffffffffc0201bce:	fc26                	sd	s1,56(sp)
ffffffffc0201bd0:	f84a                	sd	s2,48(sp)
ffffffffc0201bd2:	f44e                	sd	s3,40(sp)
ffffffffc0201bd4:	f052                	sd	s4,32(sp)
ffffffffc0201bd6:	ec56                	sd	s5,24(sp)
ffffffffc0201bd8:	e85a                	sd	s6,16(sp)
ffffffffc0201bda:	e45e                	sd	s7,8(sp)
ffffffffc0201bdc:	e062                	sd	s8,0(sp)
    int count = 0, total = 0;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
ffffffffc0201bde:	2c878763          	beq	a5,s0,ffffffffc0201eac <default_check+0x2ee>
    int count = 0, total = 0;
ffffffffc0201be2:	4481                	li	s1,0
ffffffffc0201be4:	4901                	li	s2,0
ffffffffc0201be6:	fe87b703          	ld	a4,-24(a5)
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
ffffffffc0201bea:	8b09                	andi	a4,a4,2
ffffffffc0201bec:	2c070463          	beqz	a4,ffffffffc0201eb4 <default_check+0x2f6>
        count ++, total += p->property;
ffffffffc0201bf0:	ff87a703          	lw	a4,-8(a5)
ffffffffc0201bf4:	679c                	ld	a5,8(a5)
ffffffffc0201bf6:	2905                	addiw	s2,s2,1
ffffffffc0201bf8:	9cb9                	addw	s1,s1,a4
    while ((le = list_next(le)) != &free_list) {
ffffffffc0201bfa:	fe8796e3          	bne	a5,s0,ffffffffc0201be6 <default_check+0x28>
    }
    assert(total == nr_free_pages());
ffffffffc0201bfe:	89a6                	mv	s3,s1
ffffffffc0201c00:	7d7000ef          	jal	ra,ffffffffc0202bd6 <nr_free_pages>
ffffffffc0201c04:	71351863          	bne	a0,s3,ffffffffc0202314 <default_check+0x756>
    assert((p0 = alloc_page()) != NULL);
ffffffffc0201c08:	4505                	li	a0,1
ffffffffc0201c0a:	6fb000ef          	jal	ra,ffffffffc0202b04 <alloc_pages>
ffffffffc0201c0e:	8a2a                	mv	s4,a0
ffffffffc0201c10:	44050263          	beqz	a0,ffffffffc0202054 <default_check+0x496>
    assert((p1 = alloc_page()) != NULL);
ffffffffc0201c14:	4505                	li	a0,1
ffffffffc0201c16:	6ef000ef          	jal	ra,ffffffffc0202b04 <alloc_pages>
ffffffffc0201c1a:	89aa                	mv	s3,a0
ffffffffc0201c1c:	70050c63          	beqz	a0,ffffffffc0202334 <default_check+0x776>
    assert((p2 = alloc_page()) != NULL);
ffffffffc0201c20:	4505                	li	a0,1
ffffffffc0201c22:	6e3000ef          	jal	ra,ffffffffc0202b04 <alloc_pages>
ffffffffc0201c26:	8aaa                	mv	s5,a0
ffffffffc0201c28:	4a050663          	beqz	a0,ffffffffc02020d4 <default_check+0x516>
    assert(p0 != p1 && p0 != p2 && p1 != p2);
ffffffffc0201c2c:	2b3a0463          	beq	s4,s3,ffffffffc0201ed4 <default_check+0x316>
ffffffffc0201c30:	2aaa0263          	beq	s4,a0,ffffffffc0201ed4 <default_check+0x316>
ffffffffc0201c34:	2aa98063          	beq	s3,a0,ffffffffc0201ed4 <default_check+0x316>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
ffffffffc0201c38:	000a2783          	lw	a5,0(s4)
ffffffffc0201c3c:	2a079c63          	bnez	a5,ffffffffc0201ef4 <default_check+0x336>
ffffffffc0201c40:	0009a783          	lw	a5,0(s3)
ffffffffc0201c44:	2a079863          	bnez	a5,ffffffffc0201ef4 <default_check+0x336>
ffffffffc0201c48:	411c                	lw	a5,0(a0)
ffffffffc0201c4a:	2a079563          	bnez	a5,ffffffffc0201ef4 <default_check+0x336>
static inline ppn_t page2ppn(struct Page *page) { return page - pages + nbase; }
ffffffffc0201c4e:	00010797          	auipc	a5,0x10
ffffffffc0201c52:	90a7b783          	ld	a5,-1782(a5) # ffffffffc0211558 <pages>
ffffffffc0201c56:	40fa0733          	sub	a4,s4,a5
ffffffffc0201c5a:	870d                	srai	a4,a4,0x3
ffffffffc0201c5c:	00004597          	auipc	a1,0x4
ffffffffc0201c60:	7245b583          	ld	a1,1828(a1) # ffffffffc0206380 <error_string+0x38>
ffffffffc0201c64:	02b70733          	mul	a4,a4,a1
ffffffffc0201c68:	00004617          	auipc	a2,0x4
ffffffffc0201c6c:	72063603          	ld	a2,1824(a2) # ffffffffc0206388 <nbase>
    assert(page2pa(p0) < npage * PGSIZE);
ffffffffc0201c70:	00010697          	auipc	a3,0x10
ffffffffc0201c74:	8e06b683          	ld	a3,-1824(a3) # ffffffffc0211550 <npage>
ffffffffc0201c78:	06b2                	slli	a3,a3,0xc
ffffffffc0201c7a:	9732                	add	a4,a4,a2
    return page2ppn(page) << PGSHIFT;
ffffffffc0201c7c:	0732                	slli	a4,a4,0xc
ffffffffc0201c7e:	28d77b63          	bgeu	a4,a3,ffffffffc0201f14 <default_check+0x356>
static inline ppn_t page2ppn(struct Page *page) { return page - pages + nbase; }
ffffffffc0201c82:	40f98733          	sub	a4,s3,a5
ffffffffc0201c86:	870d                	srai	a4,a4,0x3
ffffffffc0201c88:	02b70733          	mul	a4,a4,a1
ffffffffc0201c8c:	9732                	add	a4,a4,a2
    return page2ppn(page) << PGSHIFT;
ffffffffc0201c8e:	0732                	slli	a4,a4,0xc
    assert(page2pa(p1) < npage * PGSIZE);
ffffffffc0201c90:	4cd77263          	bgeu	a4,a3,ffffffffc0202154 <default_check+0x596>
static inline ppn_t page2ppn(struct Page *page) { return page - pages + nbase; }
ffffffffc0201c94:	40f507b3          	sub	a5,a0,a5
ffffffffc0201c98:	878d                	srai	a5,a5,0x3
ffffffffc0201c9a:	02b787b3          	mul	a5,a5,a1
ffffffffc0201c9e:	97b2                	add	a5,a5,a2
    return page2ppn(page) << PGSHIFT;
ffffffffc0201ca0:	07b2                	slli	a5,a5,0xc
    assert(page2pa(p2) < npage * PGSIZE);
ffffffffc0201ca2:	30d7f963          	bgeu	a5,a3,ffffffffc0201fb4 <default_check+0x3f6>
    assert(alloc_page() == NULL);
ffffffffc0201ca6:	4505                	li	a0,1
    list_entry_t free_list_store = free_list;
ffffffffc0201ca8:	00043c03          	ld	s8,0(s0)
ffffffffc0201cac:	00843b83          	ld	s7,8(s0)
    unsigned int nr_free_store = nr_free;
ffffffffc0201cb0:	01042b03          	lw	s6,16(s0)
    elm->prev = elm->next = elm;
ffffffffc0201cb4:	e400                	sd	s0,8(s0)
ffffffffc0201cb6:	e000                	sd	s0,0(s0)
    nr_free = 0;
ffffffffc0201cb8:	0000f797          	auipc	a5,0xf
ffffffffc0201cbc:	4207a423          	sw	zero,1064(a5) # ffffffffc02110e0 <free_area+0x10>
    assert(alloc_page() == NULL);
ffffffffc0201cc0:	645000ef          	jal	ra,ffffffffc0202b04 <alloc_pages>
ffffffffc0201cc4:	2c051863          	bnez	a0,ffffffffc0201f94 <default_check+0x3d6>
    free_page(p0);
ffffffffc0201cc8:	4585                	li	a1,1
ffffffffc0201cca:	8552                	mv	a0,s4
ffffffffc0201ccc:	6cb000ef          	jal	ra,ffffffffc0202b96 <free_pages>
    free_page(p1);
ffffffffc0201cd0:	4585                	li	a1,1
ffffffffc0201cd2:	854e                	mv	a0,s3
ffffffffc0201cd4:	6c3000ef          	jal	ra,ffffffffc0202b96 <free_pages>
    free_page(p2);
ffffffffc0201cd8:	4585                	li	a1,1
ffffffffc0201cda:	8556                	mv	a0,s5
ffffffffc0201cdc:	6bb000ef          	jal	ra,ffffffffc0202b96 <free_pages>
    assert(nr_free == 3);
ffffffffc0201ce0:	4818                	lw	a4,16(s0)
ffffffffc0201ce2:	478d                	li	a5,3
ffffffffc0201ce4:	28f71863          	bne	a4,a5,ffffffffc0201f74 <default_check+0x3b6>
    assert((p0 = alloc_page()) != NULL);
ffffffffc0201ce8:	4505                	li	a0,1
ffffffffc0201cea:	61b000ef          	jal	ra,ffffffffc0202b04 <alloc_pages>
ffffffffc0201cee:	89aa                	mv	s3,a0
ffffffffc0201cf0:	26050263          	beqz	a0,ffffffffc0201f54 <default_check+0x396>
    assert((p1 = alloc_page()) != NULL);
ffffffffc0201cf4:	4505                	li	a0,1
ffffffffc0201cf6:	60f000ef          	jal	ra,ffffffffc0202b04 <alloc_pages>
ffffffffc0201cfa:	8aaa                	mv	s5,a0
ffffffffc0201cfc:	3a050c63          	beqz	a0,ffffffffc02020b4 <default_check+0x4f6>
    assert((p2 = alloc_page()) != NULL);
ffffffffc0201d00:	4505                	li	a0,1
ffffffffc0201d02:	603000ef          	jal	ra,ffffffffc0202b04 <alloc_pages>
ffffffffc0201d06:	8a2a                	mv	s4,a0
ffffffffc0201d08:	38050663          	beqz	a0,ffffffffc0202094 <default_check+0x4d6>
    assert(alloc_page() == NULL);
ffffffffc0201d0c:	4505                	li	a0,1
ffffffffc0201d0e:	5f7000ef          	jal	ra,ffffffffc0202b04 <alloc_pages>
ffffffffc0201d12:	36051163          	bnez	a0,ffffffffc0202074 <default_check+0x4b6>
    free_page(p0);
ffffffffc0201d16:	4585                	li	a1,1
ffffffffc0201d18:	854e                	mv	a0,s3
ffffffffc0201d1a:	67d000ef          	jal	ra,ffffffffc0202b96 <free_pages>
    assert(!list_empty(&free_list));
ffffffffc0201d1e:	641c                	ld	a5,8(s0)
ffffffffc0201d20:	20878a63          	beq	a5,s0,ffffffffc0201f34 <default_check+0x376>
    assert((p = alloc_page()) == p0);
ffffffffc0201d24:	4505                	li	a0,1
ffffffffc0201d26:	5df000ef          	jal	ra,ffffffffc0202b04 <alloc_pages>
ffffffffc0201d2a:	30a99563          	bne	s3,a0,ffffffffc0202034 <default_check+0x476>
    assert(alloc_page() == NULL);
ffffffffc0201d2e:	4505                	li	a0,1
ffffffffc0201d30:	5d5000ef          	jal	ra,ffffffffc0202b04 <alloc_pages>
ffffffffc0201d34:	2e051063          	bnez	a0,ffffffffc0202014 <default_check+0x456>
    assert(nr_free == 0);
ffffffffc0201d38:	481c                	lw	a5,16(s0)
ffffffffc0201d3a:	2a079d63          	bnez	a5,ffffffffc0201ff4 <default_check+0x436>
    free_page(p);
ffffffffc0201d3e:	854e                	mv	a0,s3
ffffffffc0201d40:	4585                	li	a1,1
    free_list = free_list_store;
ffffffffc0201d42:	01843023          	sd	s8,0(s0)
ffffffffc0201d46:	01743423          	sd	s7,8(s0)
    nr_free = nr_free_store;
ffffffffc0201d4a:	01642823          	sw	s6,16(s0)
    free_page(p);
ffffffffc0201d4e:	649000ef          	jal	ra,ffffffffc0202b96 <free_pages>
    free_page(p1);
ffffffffc0201d52:	4585                	li	a1,1
ffffffffc0201d54:	8556                	mv	a0,s5
ffffffffc0201d56:	641000ef          	jal	ra,ffffffffc0202b96 <free_pages>
    free_page(p2);
ffffffffc0201d5a:	4585                	li	a1,1
ffffffffc0201d5c:	8552                	mv	a0,s4
ffffffffc0201d5e:	639000ef          	jal	ra,ffffffffc0202b96 <free_pages>

    basic_check();

    struct Page *p0 = alloc_pages(5), *p1, *p2;
ffffffffc0201d62:	4515                	li	a0,5
ffffffffc0201d64:	5a1000ef          	jal	ra,ffffffffc0202b04 <alloc_pages>
ffffffffc0201d68:	89aa                	mv	s3,a0
    assert(p0 != NULL);
ffffffffc0201d6a:	26050563          	beqz	a0,ffffffffc0201fd4 <default_check+0x416>
ffffffffc0201d6e:	651c                	ld	a5,8(a0)
ffffffffc0201d70:	8385                	srli	a5,a5,0x1
    assert(!PageProperty(p0));
ffffffffc0201d72:	8b85                	andi	a5,a5,1
ffffffffc0201d74:	54079063          	bnez	a5,ffffffffc02022b4 <default_check+0x6f6>

    list_entry_t free_list_store = free_list;
    list_init(&free_list);
    assert(list_empty(&free_list));
    assert(alloc_page() == NULL);
ffffffffc0201d78:	4505                	li	a0,1
    list_entry_t free_list_store = free_list;
ffffffffc0201d7a:	00043b03          	ld	s6,0(s0)
ffffffffc0201d7e:	00843a83          	ld	s5,8(s0)
ffffffffc0201d82:	e000                	sd	s0,0(s0)
ffffffffc0201d84:	e400                	sd	s0,8(s0)
    assert(alloc_page() == NULL);
ffffffffc0201d86:	57f000ef          	jal	ra,ffffffffc0202b04 <alloc_pages>
ffffffffc0201d8a:	50051563          	bnez	a0,ffffffffc0202294 <default_check+0x6d6>

    unsigned int nr_free_store = nr_free;
    nr_free = 0;

    free_pages(p0 + 2, 3);
ffffffffc0201d8e:	09098a13          	addi	s4,s3,144
ffffffffc0201d92:	8552                	mv	a0,s4
ffffffffc0201d94:	458d                	li	a1,3
    unsigned int nr_free_store = nr_free;
ffffffffc0201d96:	01042b83          	lw	s7,16(s0)
    nr_free = 0;
ffffffffc0201d9a:	0000f797          	auipc	a5,0xf
ffffffffc0201d9e:	3407a323          	sw	zero,838(a5) # ffffffffc02110e0 <free_area+0x10>
    free_pages(p0 + 2, 3);
ffffffffc0201da2:	5f5000ef          	jal	ra,ffffffffc0202b96 <free_pages>
    assert(alloc_pages(4) == NULL);
ffffffffc0201da6:	4511                	li	a0,4
ffffffffc0201da8:	55d000ef          	jal	ra,ffffffffc0202b04 <alloc_pages>
ffffffffc0201dac:	4c051463          	bnez	a0,ffffffffc0202274 <default_check+0x6b6>
ffffffffc0201db0:	0989b783          	ld	a5,152(s3)
ffffffffc0201db4:	8385                	srli	a5,a5,0x1
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
ffffffffc0201db6:	8b85                	andi	a5,a5,1
ffffffffc0201db8:	48078e63          	beqz	a5,ffffffffc0202254 <default_check+0x696>
ffffffffc0201dbc:	0a89a703          	lw	a4,168(s3)
ffffffffc0201dc0:	478d                	li	a5,3
ffffffffc0201dc2:	48f71963          	bne	a4,a5,ffffffffc0202254 <default_check+0x696>
    assert((p1 = alloc_pages(3)) != NULL);
ffffffffc0201dc6:	450d                	li	a0,3
ffffffffc0201dc8:	53d000ef          	jal	ra,ffffffffc0202b04 <alloc_pages>
ffffffffc0201dcc:	8c2a                	mv	s8,a0
ffffffffc0201dce:	46050363          	beqz	a0,ffffffffc0202234 <default_check+0x676>
    assert(alloc_page() == NULL);
ffffffffc0201dd2:	4505                	li	a0,1
ffffffffc0201dd4:	531000ef          	jal	ra,ffffffffc0202b04 <alloc_pages>
ffffffffc0201dd8:	42051e63          	bnez	a0,ffffffffc0202214 <default_check+0x656>
    assert(p0 + 2 == p1);
ffffffffc0201ddc:	418a1c63          	bne	s4,s8,ffffffffc02021f4 <default_check+0x636>

    p2 = p0 + 1;
    free_page(p0);
ffffffffc0201de0:	4585                	li	a1,1
ffffffffc0201de2:	854e                	mv	a0,s3
ffffffffc0201de4:	5b3000ef          	jal	ra,ffffffffc0202b96 <free_pages>
    free_pages(p1, 3);
ffffffffc0201de8:	458d                	li	a1,3
ffffffffc0201dea:	8552                	mv	a0,s4
ffffffffc0201dec:	5ab000ef          	jal	ra,ffffffffc0202b96 <free_pages>
ffffffffc0201df0:	0089b783          	ld	a5,8(s3)
    p2 = p0 + 1;
ffffffffc0201df4:	04898c13          	addi	s8,s3,72
ffffffffc0201df8:	8385                	srli	a5,a5,0x1
    assert(PageProperty(p0) && p0->property == 1);
ffffffffc0201dfa:	8b85                	andi	a5,a5,1
ffffffffc0201dfc:	3c078c63          	beqz	a5,ffffffffc02021d4 <default_check+0x616>
ffffffffc0201e00:	0189a703          	lw	a4,24(s3)
ffffffffc0201e04:	4785                	li	a5,1
ffffffffc0201e06:	3cf71763          	bne	a4,a5,ffffffffc02021d4 <default_check+0x616>
ffffffffc0201e0a:	008a3783          	ld	a5,8(s4)
ffffffffc0201e0e:	8385                	srli	a5,a5,0x1
    assert(PageProperty(p1) && p1->property == 3);
ffffffffc0201e10:	8b85                	andi	a5,a5,1
ffffffffc0201e12:	3a078163          	beqz	a5,ffffffffc02021b4 <default_check+0x5f6>
ffffffffc0201e16:	018a2703          	lw	a4,24(s4)
ffffffffc0201e1a:	478d                	li	a5,3
ffffffffc0201e1c:	38f71c63          	bne	a4,a5,ffffffffc02021b4 <default_check+0x5f6>

    assert((p0 = alloc_page()) == p2 - 1);
ffffffffc0201e20:	4505                	li	a0,1
ffffffffc0201e22:	4e3000ef          	jal	ra,ffffffffc0202b04 <alloc_pages>
ffffffffc0201e26:	36a99763          	bne	s3,a0,ffffffffc0202194 <default_check+0x5d6>
    free_page(p0);
ffffffffc0201e2a:	4585                	li	a1,1
ffffffffc0201e2c:	56b000ef          	jal	ra,ffffffffc0202b96 <free_pages>
    assert((p0 = alloc_pages(2)) == p2 + 1);
ffffffffc0201e30:	4509                	li	a0,2
ffffffffc0201e32:	4d3000ef          	jal	ra,ffffffffc0202b04 <alloc_pages>
ffffffffc0201e36:	32aa1f63          	bne	s4,a0,ffffffffc0202174 <default_check+0x5b6>

    free_pages(p0, 2);
ffffffffc0201e3a:	4589                	li	a1,2
ffffffffc0201e3c:	55b000ef          	jal	ra,ffffffffc0202b96 <free_pages>
    free_page(p2);
ffffffffc0201e40:	4585                	li	a1,1
ffffffffc0201e42:	8562                	mv	a0,s8
ffffffffc0201e44:	553000ef          	jal	ra,ffffffffc0202b96 <free_pages>

    assert((p0 = alloc_pages(5)) != NULL);
ffffffffc0201e48:	4515                	li	a0,5
ffffffffc0201e4a:	4bb000ef          	jal	ra,ffffffffc0202b04 <alloc_pages>
ffffffffc0201e4e:	89aa                	mv	s3,a0
ffffffffc0201e50:	48050263          	beqz	a0,ffffffffc02022d4 <default_check+0x716>
    assert(alloc_page() == NULL);
ffffffffc0201e54:	4505                	li	a0,1
ffffffffc0201e56:	4af000ef          	jal	ra,ffffffffc0202b04 <alloc_pages>
ffffffffc0201e5a:	2c051d63          	bnez	a0,ffffffffc0202134 <default_check+0x576>

    assert(nr_free == 0);
ffffffffc0201e5e:	481c                	lw	a5,16(s0)
ffffffffc0201e60:	2a079a63          	bnez	a5,ffffffffc0202114 <default_check+0x556>
    nr_free = nr_free_store;

    free_list = free_list_store;
    free_pages(p0, 5);
ffffffffc0201e64:	4595                	li	a1,5
ffffffffc0201e66:	854e                	mv	a0,s3
    nr_free = nr_free_store;
ffffffffc0201e68:	01742823          	sw	s7,16(s0)
    free_list = free_list_store;
ffffffffc0201e6c:	01643023          	sd	s6,0(s0)
ffffffffc0201e70:	01543423          	sd	s5,8(s0)
    free_pages(p0, 5);
ffffffffc0201e74:	523000ef          	jal	ra,ffffffffc0202b96 <free_pages>
    return listelm->next;
ffffffffc0201e78:	641c                	ld	a5,8(s0)

    le = &free_list;
    while ((le = list_next(le)) != &free_list) {
ffffffffc0201e7a:	00878963          	beq	a5,s0,ffffffffc0201e8c <default_check+0x2ce>
        struct Page *p = le2page(le, page_link);
        count --, total -= p->property;
ffffffffc0201e7e:	ff87a703          	lw	a4,-8(a5)
ffffffffc0201e82:	679c                	ld	a5,8(a5)
ffffffffc0201e84:	397d                	addiw	s2,s2,-1
ffffffffc0201e86:	9c99                	subw	s1,s1,a4
    while ((le = list_next(le)) != &free_list) {
ffffffffc0201e88:	fe879be3          	bne	a5,s0,ffffffffc0201e7e <default_check+0x2c0>
    }
    assert(count == 0);
ffffffffc0201e8c:	26091463          	bnez	s2,ffffffffc02020f4 <default_check+0x536>
    assert(total == 0);
ffffffffc0201e90:	46049263          	bnez	s1,ffffffffc02022f4 <default_check+0x736>
}
ffffffffc0201e94:	60a6                	ld	ra,72(sp)
ffffffffc0201e96:	6406                	ld	s0,64(sp)
ffffffffc0201e98:	74e2                	ld	s1,56(sp)
ffffffffc0201e9a:	7942                	ld	s2,48(sp)
ffffffffc0201e9c:	79a2                	ld	s3,40(sp)
ffffffffc0201e9e:	7a02                	ld	s4,32(sp)
ffffffffc0201ea0:	6ae2                	ld	s5,24(sp)
ffffffffc0201ea2:	6b42                	ld	s6,16(sp)
ffffffffc0201ea4:	6ba2                	ld	s7,8(sp)
ffffffffc0201ea6:	6c02                	ld	s8,0(sp)
ffffffffc0201ea8:	6161                	addi	sp,sp,80
ffffffffc0201eaa:	8082                	ret
    while ((le = list_next(le)) != &free_list) {
ffffffffc0201eac:	4981                	li	s3,0
    int count = 0, total = 0;
ffffffffc0201eae:	4481                	li	s1,0
ffffffffc0201eb0:	4901                	li	s2,0
ffffffffc0201eb2:	b3b9                	j	ffffffffc0201c00 <default_check+0x42>
        assert(PageProperty(p));
ffffffffc0201eb4:	00003697          	auipc	a3,0x3
ffffffffc0201eb8:	3bc68693          	addi	a3,a3,956 # ffffffffc0205270 <commands+0xae0>
ffffffffc0201ebc:	00003617          	auipc	a2,0x3
ffffffffc0201ec0:	ffc60613          	addi	a2,a2,-4 # ffffffffc0204eb8 <commands+0x728>
ffffffffc0201ec4:	0f000593          	li	a1,240
ffffffffc0201ec8:	00003517          	auipc	a0,0x3
ffffffffc0201ecc:	75050513          	addi	a0,a0,1872 # ffffffffc0205618 <commands+0xe88>
ffffffffc0201ed0:	a32fe0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(p0 != p1 && p0 != p2 && p1 != p2);
ffffffffc0201ed4:	00003697          	auipc	a3,0x3
ffffffffc0201ed8:	7bc68693          	addi	a3,a3,1980 # ffffffffc0205690 <commands+0xf00>
ffffffffc0201edc:	00003617          	auipc	a2,0x3
ffffffffc0201ee0:	fdc60613          	addi	a2,a2,-36 # ffffffffc0204eb8 <commands+0x728>
ffffffffc0201ee4:	0bd00593          	li	a1,189
ffffffffc0201ee8:	00003517          	auipc	a0,0x3
ffffffffc0201eec:	73050513          	addi	a0,a0,1840 # ffffffffc0205618 <commands+0xe88>
ffffffffc0201ef0:	a12fe0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
ffffffffc0201ef4:	00003697          	auipc	a3,0x3
ffffffffc0201ef8:	7c468693          	addi	a3,a3,1988 # ffffffffc02056b8 <commands+0xf28>
ffffffffc0201efc:	00003617          	auipc	a2,0x3
ffffffffc0201f00:	fbc60613          	addi	a2,a2,-68 # ffffffffc0204eb8 <commands+0x728>
ffffffffc0201f04:	0be00593          	li	a1,190
ffffffffc0201f08:	00003517          	auipc	a0,0x3
ffffffffc0201f0c:	71050513          	addi	a0,a0,1808 # ffffffffc0205618 <commands+0xe88>
ffffffffc0201f10:	9f2fe0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(page2pa(p0) < npage * PGSIZE);
ffffffffc0201f14:	00003697          	auipc	a3,0x3
ffffffffc0201f18:	7e468693          	addi	a3,a3,2020 # ffffffffc02056f8 <commands+0xf68>
ffffffffc0201f1c:	00003617          	auipc	a2,0x3
ffffffffc0201f20:	f9c60613          	addi	a2,a2,-100 # ffffffffc0204eb8 <commands+0x728>
ffffffffc0201f24:	0c000593          	li	a1,192
ffffffffc0201f28:	00003517          	auipc	a0,0x3
ffffffffc0201f2c:	6f050513          	addi	a0,a0,1776 # ffffffffc0205618 <commands+0xe88>
ffffffffc0201f30:	9d2fe0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(!list_empty(&free_list));
ffffffffc0201f34:	00004697          	auipc	a3,0x4
ffffffffc0201f38:	84c68693          	addi	a3,a3,-1972 # ffffffffc0205780 <commands+0xff0>
ffffffffc0201f3c:	00003617          	auipc	a2,0x3
ffffffffc0201f40:	f7c60613          	addi	a2,a2,-132 # ffffffffc0204eb8 <commands+0x728>
ffffffffc0201f44:	0d900593          	li	a1,217
ffffffffc0201f48:	00003517          	auipc	a0,0x3
ffffffffc0201f4c:	6d050513          	addi	a0,a0,1744 # ffffffffc0205618 <commands+0xe88>
ffffffffc0201f50:	9b2fe0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert((p0 = alloc_page()) != NULL);
ffffffffc0201f54:	00003697          	auipc	a3,0x3
ffffffffc0201f58:	6dc68693          	addi	a3,a3,1756 # ffffffffc0205630 <commands+0xea0>
ffffffffc0201f5c:	00003617          	auipc	a2,0x3
ffffffffc0201f60:	f5c60613          	addi	a2,a2,-164 # ffffffffc0204eb8 <commands+0x728>
ffffffffc0201f64:	0d200593          	li	a1,210
ffffffffc0201f68:	00003517          	auipc	a0,0x3
ffffffffc0201f6c:	6b050513          	addi	a0,a0,1712 # ffffffffc0205618 <commands+0xe88>
ffffffffc0201f70:	992fe0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(nr_free == 3);
ffffffffc0201f74:	00003697          	auipc	a3,0x3
ffffffffc0201f78:	7fc68693          	addi	a3,a3,2044 # ffffffffc0205770 <commands+0xfe0>
ffffffffc0201f7c:	00003617          	auipc	a2,0x3
ffffffffc0201f80:	f3c60613          	addi	a2,a2,-196 # ffffffffc0204eb8 <commands+0x728>
ffffffffc0201f84:	0d000593          	li	a1,208
ffffffffc0201f88:	00003517          	auipc	a0,0x3
ffffffffc0201f8c:	69050513          	addi	a0,a0,1680 # ffffffffc0205618 <commands+0xe88>
ffffffffc0201f90:	972fe0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(alloc_page() == NULL);
ffffffffc0201f94:	00003697          	auipc	a3,0x3
ffffffffc0201f98:	7c468693          	addi	a3,a3,1988 # ffffffffc0205758 <commands+0xfc8>
ffffffffc0201f9c:	00003617          	auipc	a2,0x3
ffffffffc0201fa0:	f1c60613          	addi	a2,a2,-228 # ffffffffc0204eb8 <commands+0x728>
ffffffffc0201fa4:	0cb00593          	li	a1,203
ffffffffc0201fa8:	00003517          	auipc	a0,0x3
ffffffffc0201fac:	67050513          	addi	a0,a0,1648 # ffffffffc0205618 <commands+0xe88>
ffffffffc0201fb0:	952fe0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
ffffffffc0201fb4:	00003697          	auipc	a3,0x3
ffffffffc0201fb8:	78468693          	addi	a3,a3,1924 # ffffffffc0205738 <commands+0xfa8>
ffffffffc0201fbc:	00003617          	auipc	a2,0x3
ffffffffc0201fc0:	efc60613          	addi	a2,a2,-260 # ffffffffc0204eb8 <commands+0x728>
ffffffffc0201fc4:	0c200593          	li	a1,194
ffffffffc0201fc8:	00003517          	auipc	a0,0x3
ffffffffc0201fcc:	65050513          	addi	a0,a0,1616 # ffffffffc0205618 <commands+0xe88>
ffffffffc0201fd0:	932fe0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(p0 != NULL);
ffffffffc0201fd4:	00003697          	auipc	a3,0x3
ffffffffc0201fd8:	7e468693          	addi	a3,a3,2020 # ffffffffc02057b8 <commands+0x1028>
ffffffffc0201fdc:	00003617          	auipc	a2,0x3
ffffffffc0201fe0:	edc60613          	addi	a2,a2,-292 # ffffffffc0204eb8 <commands+0x728>
ffffffffc0201fe4:	0f800593          	li	a1,248
ffffffffc0201fe8:	00003517          	auipc	a0,0x3
ffffffffc0201fec:	63050513          	addi	a0,a0,1584 # ffffffffc0205618 <commands+0xe88>
ffffffffc0201ff0:	912fe0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(nr_free == 0);
ffffffffc0201ff4:	00003697          	auipc	a3,0x3
ffffffffc0201ff8:	42c68693          	addi	a3,a3,1068 # ffffffffc0205420 <commands+0xc90>
ffffffffc0201ffc:	00003617          	auipc	a2,0x3
ffffffffc0202000:	ebc60613          	addi	a2,a2,-324 # ffffffffc0204eb8 <commands+0x728>
ffffffffc0202004:	0df00593          	li	a1,223
ffffffffc0202008:	00003517          	auipc	a0,0x3
ffffffffc020200c:	61050513          	addi	a0,a0,1552 # ffffffffc0205618 <commands+0xe88>
ffffffffc0202010:	8f2fe0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(alloc_page() == NULL);
ffffffffc0202014:	00003697          	auipc	a3,0x3
ffffffffc0202018:	74468693          	addi	a3,a3,1860 # ffffffffc0205758 <commands+0xfc8>
ffffffffc020201c:	00003617          	auipc	a2,0x3
ffffffffc0202020:	e9c60613          	addi	a2,a2,-356 # ffffffffc0204eb8 <commands+0x728>
ffffffffc0202024:	0dd00593          	li	a1,221
ffffffffc0202028:	00003517          	auipc	a0,0x3
ffffffffc020202c:	5f050513          	addi	a0,a0,1520 # ffffffffc0205618 <commands+0xe88>
ffffffffc0202030:	8d2fe0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert((p = alloc_page()) == p0);
ffffffffc0202034:	00003697          	auipc	a3,0x3
ffffffffc0202038:	76468693          	addi	a3,a3,1892 # ffffffffc0205798 <commands+0x1008>
ffffffffc020203c:	00003617          	auipc	a2,0x3
ffffffffc0202040:	e7c60613          	addi	a2,a2,-388 # ffffffffc0204eb8 <commands+0x728>
ffffffffc0202044:	0dc00593          	li	a1,220
ffffffffc0202048:	00003517          	auipc	a0,0x3
ffffffffc020204c:	5d050513          	addi	a0,a0,1488 # ffffffffc0205618 <commands+0xe88>
ffffffffc0202050:	8b2fe0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert((p0 = alloc_page()) != NULL);
ffffffffc0202054:	00003697          	auipc	a3,0x3
ffffffffc0202058:	5dc68693          	addi	a3,a3,1500 # ffffffffc0205630 <commands+0xea0>
ffffffffc020205c:	00003617          	auipc	a2,0x3
ffffffffc0202060:	e5c60613          	addi	a2,a2,-420 # ffffffffc0204eb8 <commands+0x728>
ffffffffc0202064:	0b900593          	li	a1,185
ffffffffc0202068:	00003517          	auipc	a0,0x3
ffffffffc020206c:	5b050513          	addi	a0,a0,1456 # ffffffffc0205618 <commands+0xe88>
ffffffffc0202070:	892fe0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(alloc_page() == NULL);
ffffffffc0202074:	00003697          	auipc	a3,0x3
ffffffffc0202078:	6e468693          	addi	a3,a3,1764 # ffffffffc0205758 <commands+0xfc8>
ffffffffc020207c:	00003617          	auipc	a2,0x3
ffffffffc0202080:	e3c60613          	addi	a2,a2,-452 # ffffffffc0204eb8 <commands+0x728>
ffffffffc0202084:	0d600593          	li	a1,214
ffffffffc0202088:	00003517          	auipc	a0,0x3
ffffffffc020208c:	59050513          	addi	a0,a0,1424 # ffffffffc0205618 <commands+0xe88>
ffffffffc0202090:	872fe0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert((p2 = alloc_page()) != NULL);
ffffffffc0202094:	00003697          	auipc	a3,0x3
ffffffffc0202098:	5dc68693          	addi	a3,a3,1500 # ffffffffc0205670 <commands+0xee0>
ffffffffc020209c:	00003617          	auipc	a2,0x3
ffffffffc02020a0:	e1c60613          	addi	a2,a2,-484 # ffffffffc0204eb8 <commands+0x728>
ffffffffc02020a4:	0d400593          	li	a1,212
ffffffffc02020a8:	00003517          	auipc	a0,0x3
ffffffffc02020ac:	57050513          	addi	a0,a0,1392 # ffffffffc0205618 <commands+0xe88>
ffffffffc02020b0:	852fe0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert((p1 = alloc_page()) != NULL);
ffffffffc02020b4:	00003697          	auipc	a3,0x3
ffffffffc02020b8:	59c68693          	addi	a3,a3,1436 # ffffffffc0205650 <commands+0xec0>
ffffffffc02020bc:	00003617          	auipc	a2,0x3
ffffffffc02020c0:	dfc60613          	addi	a2,a2,-516 # ffffffffc0204eb8 <commands+0x728>
ffffffffc02020c4:	0d300593          	li	a1,211
ffffffffc02020c8:	00003517          	auipc	a0,0x3
ffffffffc02020cc:	55050513          	addi	a0,a0,1360 # ffffffffc0205618 <commands+0xe88>
ffffffffc02020d0:	832fe0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert((p2 = alloc_page()) != NULL);
ffffffffc02020d4:	00003697          	auipc	a3,0x3
ffffffffc02020d8:	59c68693          	addi	a3,a3,1436 # ffffffffc0205670 <commands+0xee0>
ffffffffc02020dc:	00003617          	auipc	a2,0x3
ffffffffc02020e0:	ddc60613          	addi	a2,a2,-548 # ffffffffc0204eb8 <commands+0x728>
ffffffffc02020e4:	0bb00593          	li	a1,187
ffffffffc02020e8:	00003517          	auipc	a0,0x3
ffffffffc02020ec:	53050513          	addi	a0,a0,1328 # ffffffffc0205618 <commands+0xe88>
ffffffffc02020f0:	812fe0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(count == 0);
ffffffffc02020f4:	00004697          	auipc	a3,0x4
ffffffffc02020f8:	81468693          	addi	a3,a3,-2028 # ffffffffc0205908 <commands+0x1178>
ffffffffc02020fc:	00003617          	auipc	a2,0x3
ffffffffc0202100:	dbc60613          	addi	a2,a2,-580 # ffffffffc0204eb8 <commands+0x728>
ffffffffc0202104:	12500593          	li	a1,293
ffffffffc0202108:	00003517          	auipc	a0,0x3
ffffffffc020210c:	51050513          	addi	a0,a0,1296 # ffffffffc0205618 <commands+0xe88>
ffffffffc0202110:	ff3fd0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(nr_free == 0);
ffffffffc0202114:	00003697          	auipc	a3,0x3
ffffffffc0202118:	30c68693          	addi	a3,a3,780 # ffffffffc0205420 <commands+0xc90>
ffffffffc020211c:	00003617          	auipc	a2,0x3
ffffffffc0202120:	d9c60613          	addi	a2,a2,-612 # ffffffffc0204eb8 <commands+0x728>
ffffffffc0202124:	11a00593          	li	a1,282
ffffffffc0202128:	00003517          	auipc	a0,0x3
ffffffffc020212c:	4f050513          	addi	a0,a0,1264 # ffffffffc0205618 <commands+0xe88>
ffffffffc0202130:	fd3fd0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(alloc_page() == NULL);
ffffffffc0202134:	00003697          	auipc	a3,0x3
ffffffffc0202138:	62468693          	addi	a3,a3,1572 # ffffffffc0205758 <commands+0xfc8>
ffffffffc020213c:	00003617          	auipc	a2,0x3
ffffffffc0202140:	d7c60613          	addi	a2,a2,-644 # ffffffffc0204eb8 <commands+0x728>
ffffffffc0202144:	11800593          	li	a1,280
ffffffffc0202148:	00003517          	auipc	a0,0x3
ffffffffc020214c:	4d050513          	addi	a0,a0,1232 # ffffffffc0205618 <commands+0xe88>
ffffffffc0202150:	fb3fd0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
ffffffffc0202154:	00003697          	auipc	a3,0x3
ffffffffc0202158:	5c468693          	addi	a3,a3,1476 # ffffffffc0205718 <commands+0xf88>
ffffffffc020215c:	00003617          	auipc	a2,0x3
ffffffffc0202160:	d5c60613          	addi	a2,a2,-676 # ffffffffc0204eb8 <commands+0x728>
ffffffffc0202164:	0c100593          	li	a1,193
ffffffffc0202168:	00003517          	auipc	a0,0x3
ffffffffc020216c:	4b050513          	addi	a0,a0,1200 # ffffffffc0205618 <commands+0xe88>
ffffffffc0202170:	f93fd0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert((p0 = alloc_pages(2)) == p2 + 1);
ffffffffc0202174:	00003697          	auipc	a3,0x3
ffffffffc0202178:	75468693          	addi	a3,a3,1876 # ffffffffc02058c8 <commands+0x1138>
ffffffffc020217c:	00003617          	auipc	a2,0x3
ffffffffc0202180:	d3c60613          	addi	a2,a2,-708 # ffffffffc0204eb8 <commands+0x728>
ffffffffc0202184:	11200593          	li	a1,274
ffffffffc0202188:	00003517          	auipc	a0,0x3
ffffffffc020218c:	49050513          	addi	a0,a0,1168 # ffffffffc0205618 <commands+0xe88>
ffffffffc0202190:	f73fd0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert((p0 = alloc_page()) == p2 - 1);
ffffffffc0202194:	00003697          	auipc	a3,0x3
ffffffffc0202198:	71468693          	addi	a3,a3,1812 # ffffffffc02058a8 <commands+0x1118>
ffffffffc020219c:	00003617          	auipc	a2,0x3
ffffffffc02021a0:	d1c60613          	addi	a2,a2,-740 # ffffffffc0204eb8 <commands+0x728>
ffffffffc02021a4:	11000593          	li	a1,272
ffffffffc02021a8:	00003517          	auipc	a0,0x3
ffffffffc02021ac:	47050513          	addi	a0,a0,1136 # ffffffffc0205618 <commands+0xe88>
ffffffffc02021b0:	f53fd0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(PageProperty(p1) && p1->property == 3);
ffffffffc02021b4:	00003697          	auipc	a3,0x3
ffffffffc02021b8:	6cc68693          	addi	a3,a3,1740 # ffffffffc0205880 <commands+0x10f0>
ffffffffc02021bc:	00003617          	auipc	a2,0x3
ffffffffc02021c0:	cfc60613          	addi	a2,a2,-772 # ffffffffc0204eb8 <commands+0x728>
ffffffffc02021c4:	10e00593          	li	a1,270
ffffffffc02021c8:	00003517          	auipc	a0,0x3
ffffffffc02021cc:	45050513          	addi	a0,a0,1104 # ffffffffc0205618 <commands+0xe88>
ffffffffc02021d0:	f33fd0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(PageProperty(p0) && p0->property == 1);
ffffffffc02021d4:	00003697          	auipc	a3,0x3
ffffffffc02021d8:	68468693          	addi	a3,a3,1668 # ffffffffc0205858 <commands+0x10c8>
ffffffffc02021dc:	00003617          	auipc	a2,0x3
ffffffffc02021e0:	cdc60613          	addi	a2,a2,-804 # ffffffffc0204eb8 <commands+0x728>
ffffffffc02021e4:	10d00593          	li	a1,269
ffffffffc02021e8:	00003517          	auipc	a0,0x3
ffffffffc02021ec:	43050513          	addi	a0,a0,1072 # ffffffffc0205618 <commands+0xe88>
ffffffffc02021f0:	f13fd0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(p0 + 2 == p1);
ffffffffc02021f4:	00003697          	auipc	a3,0x3
ffffffffc02021f8:	65468693          	addi	a3,a3,1620 # ffffffffc0205848 <commands+0x10b8>
ffffffffc02021fc:	00003617          	auipc	a2,0x3
ffffffffc0202200:	cbc60613          	addi	a2,a2,-836 # ffffffffc0204eb8 <commands+0x728>
ffffffffc0202204:	10800593          	li	a1,264
ffffffffc0202208:	00003517          	auipc	a0,0x3
ffffffffc020220c:	41050513          	addi	a0,a0,1040 # ffffffffc0205618 <commands+0xe88>
ffffffffc0202210:	ef3fd0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(alloc_page() == NULL);
ffffffffc0202214:	00003697          	auipc	a3,0x3
ffffffffc0202218:	54468693          	addi	a3,a3,1348 # ffffffffc0205758 <commands+0xfc8>
ffffffffc020221c:	00003617          	auipc	a2,0x3
ffffffffc0202220:	c9c60613          	addi	a2,a2,-868 # ffffffffc0204eb8 <commands+0x728>
ffffffffc0202224:	10700593          	li	a1,263
ffffffffc0202228:	00003517          	auipc	a0,0x3
ffffffffc020222c:	3f050513          	addi	a0,a0,1008 # ffffffffc0205618 <commands+0xe88>
ffffffffc0202230:	ed3fd0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
ffffffffc0202234:	00003697          	auipc	a3,0x3
ffffffffc0202238:	5f468693          	addi	a3,a3,1524 # ffffffffc0205828 <commands+0x1098>
ffffffffc020223c:	00003617          	auipc	a2,0x3
ffffffffc0202240:	c7c60613          	addi	a2,a2,-900 # ffffffffc0204eb8 <commands+0x728>
ffffffffc0202244:	10600593          	li	a1,262
ffffffffc0202248:	00003517          	auipc	a0,0x3
ffffffffc020224c:	3d050513          	addi	a0,a0,976 # ffffffffc0205618 <commands+0xe88>
ffffffffc0202250:	eb3fd0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
ffffffffc0202254:	00003697          	auipc	a3,0x3
ffffffffc0202258:	5a468693          	addi	a3,a3,1444 # ffffffffc02057f8 <commands+0x1068>
ffffffffc020225c:	00003617          	auipc	a2,0x3
ffffffffc0202260:	c5c60613          	addi	a2,a2,-932 # ffffffffc0204eb8 <commands+0x728>
ffffffffc0202264:	10500593          	li	a1,261
ffffffffc0202268:	00003517          	auipc	a0,0x3
ffffffffc020226c:	3b050513          	addi	a0,a0,944 # ffffffffc0205618 <commands+0xe88>
ffffffffc0202270:	e93fd0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(alloc_pages(4) == NULL);
ffffffffc0202274:	00003697          	auipc	a3,0x3
ffffffffc0202278:	56c68693          	addi	a3,a3,1388 # ffffffffc02057e0 <commands+0x1050>
ffffffffc020227c:	00003617          	auipc	a2,0x3
ffffffffc0202280:	c3c60613          	addi	a2,a2,-964 # ffffffffc0204eb8 <commands+0x728>
ffffffffc0202284:	10400593          	li	a1,260
ffffffffc0202288:	00003517          	auipc	a0,0x3
ffffffffc020228c:	39050513          	addi	a0,a0,912 # ffffffffc0205618 <commands+0xe88>
ffffffffc0202290:	e73fd0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(alloc_page() == NULL);
ffffffffc0202294:	00003697          	auipc	a3,0x3
ffffffffc0202298:	4c468693          	addi	a3,a3,1220 # ffffffffc0205758 <commands+0xfc8>
ffffffffc020229c:	00003617          	auipc	a2,0x3
ffffffffc02022a0:	c1c60613          	addi	a2,a2,-996 # ffffffffc0204eb8 <commands+0x728>
ffffffffc02022a4:	0fe00593          	li	a1,254
ffffffffc02022a8:	00003517          	auipc	a0,0x3
ffffffffc02022ac:	37050513          	addi	a0,a0,880 # ffffffffc0205618 <commands+0xe88>
ffffffffc02022b0:	e53fd0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(!PageProperty(p0));
ffffffffc02022b4:	00003697          	auipc	a3,0x3
ffffffffc02022b8:	51468693          	addi	a3,a3,1300 # ffffffffc02057c8 <commands+0x1038>
ffffffffc02022bc:	00003617          	auipc	a2,0x3
ffffffffc02022c0:	bfc60613          	addi	a2,a2,-1028 # ffffffffc0204eb8 <commands+0x728>
ffffffffc02022c4:	0f900593          	li	a1,249
ffffffffc02022c8:	00003517          	auipc	a0,0x3
ffffffffc02022cc:	35050513          	addi	a0,a0,848 # ffffffffc0205618 <commands+0xe88>
ffffffffc02022d0:	e33fd0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert((p0 = alloc_pages(5)) != NULL);
ffffffffc02022d4:	00003697          	auipc	a3,0x3
ffffffffc02022d8:	61468693          	addi	a3,a3,1556 # ffffffffc02058e8 <commands+0x1158>
ffffffffc02022dc:	00003617          	auipc	a2,0x3
ffffffffc02022e0:	bdc60613          	addi	a2,a2,-1060 # ffffffffc0204eb8 <commands+0x728>
ffffffffc02022e4:	11700593          	li	a1,279
ffffffffc02022e8:	00003517          	auipc	a0,0x3
ffffffffc02022ec:	33050513          	addi	a0,a0,816 # ffffffffc0205618 <commands+0xe88>
ffffffffc02022f0:	e13fd0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(total == 0);
ffffffffc02022f4:	00003697          	auipc	a3,0x3
ffffffffc02022f8:	62468693          	addi	a3,a3,1572 # ffffffffc0205918 <commands+0x1188>
ffffffffc02022fc:	00003617          	auipc	a2,0x3
ffffffffc0202300:	bbc60613          	addi	a2,a2,-1092 # ffffffffc0204eb8 <commands+0x728>
ffffffffc0202304:	12600593          	li	a1,294
ffffffffc0202308:	00003517          	auipc	a0,0x3
ffffffffc020230c:	31050513          	addi	a0,a0,784 # ffffffffc0205618 <commands+0xe88>
ffffffffc0202310:	df3fd0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(total == nr_free_pages());
ffffffffc0202314:	00003697          	auipc	a3,0x3
ffffffffc0202318:	f6c68693          	addi	a3,a3,-148 # ffffffffc0205280 <commands+0xaf0>
ffffffffc020231c:	00003617          	auipc	a2,0x3
ffffffffc0202320:	b9c60613          	addi	a2,a2,-1124 # ffffffffc0204eb8 <commands+0x728>
ffffffffc0202324:	0f300593          	li	a1,243
ffffffffc0202328:	00003517          	auipc	a0,0x3
ffffffffc020232c:	2f050513          	addi	a0,a0,752 # ffffffffc0205618 <commands+0xe88>
ffffffffc0202330:	dd3fd0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert((p1 = alloc_page()) != NULL);
ffffffffc0202334:	00003697          	auipc	a3,0x3
ffffffffc0202338:	31c68693          	addi	a3,a3,796 # ffffffffc0205650 <commands+0xec0>
ffffffffc020233c:	00003617          	auipc	a2,0x3
ffffffffc0202340:	b7c60613          	addi	a2,a2,-1156 # ffffffffc0204eb8 <commands+0x728>
ffffffffc0202344:	0ba00593          	li	a1,186
ffffffffc0202348:	00003517          	auipc	a0,0x3
ffffffffc020234c:	2d050513          	addi	a0,a0,720 # ffffffffc0205618 <commands+0xe88>
ffffffffc0202350:	db3fd0ef          	jal	ra,ffffffffc0200102 <__panic>

ffffffffc0202354 <default_free_pages>:
default_free_pages(struct Page *base, size_t n) {
ffffffffc0202354:	1141                	addi	sp,sp,-16
ffffffffc0202356:	e406                	sd	ra,8(sp)
    assert(n > 0);
ffffffffc0202358:	14058a63          	beqz	a1,ffffffffc02024ac <default_free_pages+0x158>
    for (; p != base + n; p ++) {
ffffffffc020235c:	00359693          	slli	a3,a1,0x3
ffffffffc0202360:	96ae                	add	a3,a3,a1
ffffffffc0202362:	068e                	slli	a3,a3,0x3
ffffffffc0202364:	96aa                	add	a3,a3,a0
ffffffffc0202366:	87aa                	mv	a5,a0
ffffffffc0202368:	02d50263          	beq	a0,a3,ffffffffc020238c <default_free_pages+0x38>
ffffffffc020236c:	6798                	ld	a4,8(a5)
        assert(!PageReserved(p) && !PageProperty(p));
ffffffffc020236e:	8b05                	andi	a4,a4,1
ffffffffc0202370:	10071e63          	bnez	a4,ffffffffc020248c <default_free_pages+0x138>
ffffffffc0202374:	6798                	ld	a4,8(a5)
ffffffffc0202376:	8b09                	andi	a4,a4,2
ffffffffc0202378:	10071a63          	bnez	a4,ffffffffc020248c <default_free_pages+0x138>
        p->flags = 0;
ffffffffc020237c:	0007b423          	sd	zero,8(a5)
}

static inline int page_ref(struct Page *page) { return page->ref; }

static inline void set_page_ref(struct Page *page, int val) { page->ref = val; }
ffffffffc0202380:	0007a023          	sw	zero,0(a5)
    for (; p != base + n; p ++) {
ffffffffc0202384:	04878793          	addi	a5,a5,72
ffffffffc0202388:	fed792e3          	bne	a5,a3,ffffffffc020236c <default_free_pages+0x18>
    base->property = n;
ffffffffc020238c:	2581                	sext.w	a1,a1
ffffffffc020238e:	cd0c                	sw	a1,24(a0)
    SetPageProperty(base);
ffffffffc0202390:	00850893          	addi	a7,a0,8
    __op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc0202394:	4789                	li	a5,2
ffffffffc0202396:	40f8b02f          	amoor.d	zero,a5,(a7)
    nr_free += n;
ffffffffc020239a:	0000f697          	auipc	a3,0xf
ffffffffc020239e:	d3668693          	addi	a3,a3,-714 # ffffffffc02110d0 <free_area>
ffffffffc02023a2:	4a98                	lw	a4,16(a3)
    return list->next == list;
ffffffffc02023a4:	669c                	ld	a5,8(a3)
        list_add(&free_list, &(base->page_link));
ffffffffc02023a6:	02050613          	addi	a2,a0,32
    nr_free += n;
ffffffffc02023aa:	9db9                	addw	a1,a1,a4
ffffffffc02023ac:	ca8c                	sw	a1,16(a3)
    if (list_empty(&free_list)) {
ffffffffc02023ae:	0ad78863          	beq	a5,a3,ffffffffc020245e <default_free_pages+0x10a>
            struct Page* page = le2page(le, page_link);
ffffffffc02023b2:	fe078713          	addi	a4,a5,-32
ffffffffc02023b6:	0006b803          	ld	a6,0(a3)
    if (list_empty(&free_list)) {
ffffffffc02023ba:	4581                	li	a1,0
            if (base < page) {
ffffffffc02023bc:	00e56a63          	bltu	a0,a4,ffffffffc02023d0 <default_free_pages+0x7c>
    return listelm->next;
ffffffffc02023c0:	6798                	ld	a4,8(a5)
            } else if (list_next(le) == &free_list) {
ffffffffc02023c2:	06d70263          	beq	a4,a3,ffffffffc0202426 <default_free_pages+0xd2>
    for (; p != base + n; p ++) {
ffffffffc02023c6:	87ba                	mv	a5,a4
            struct Page* page = le2page(le, page_link);
ffffffffc02023c8:	fe078713          	addi	a4,a5,-32
            if (base < page) {
ffffffffc02023cc:	fee57ae3          	bgeu	a0,a4,ffffffffc02023c0 <default_free_pages+0x6c>
ffffffffc02023d0:	c199                	beqz	a1,ffffffffc02023d6 <default_free_pages+0x82>
ffffffffc02023d2:	0106b023          	sd	a6,0(a3)
    __list_add(elm, listelm->prev, listelm);
ffffffffc02023d6:	6398                	ld	a4,0(a5)
    prev->next = next->prev = elm;
ffffffffc02023d8:	e390                	sd	a2,0(a5)
ffffffffc02023da:	e710                	sd	a2,8(a4)
    elm->next = next;
ffffffffc02023dc:	f51c                	sd	a5,40(a0)
    elm->prev = prev;
ffffffffc02023de:	f118                	sd	a4,32(a0)
    if (le != &free_list) {
ffffffffc02023e0:	02d70063          	beq	a4,a3,ffffffffc0202400 <default_free_pages+0xac>
        if (p + p->property == base) {
ffffffffc02023e4:	ff872803          	lw	a6,-8(a4)
        p = le2page(le, page_link);
ffffffffc02023e8:	fe070593          	addi	a1,a4,-32
        if (p + p->property == base) {
ffffffffc02023ec:	02081613          	slli	a2,a6,0x20
ffffffffc02023f0:	9201                	srli	a2,a2,0x20
ffffffffc02023f2:	00361793          	slli	a5,a2,0x3
ffffffffc02023f6:	97b2                	add	a5,a5,a2
ffffffffc02023f8:	078e                	slli	a5,a5,0x3
ffffffffc02023fa:	97ae                	add	a5,a5,a1
ffffffffc02023fc:	02f50f63          	beq	a0,a5,ffffffffc020243a <default_free_pages+0xe6>
    return listelm->next;
ffffffffc0202400:	7518                	ld	a4,40(a0)
    if (le != &free_list) {
ffffffffc0202402:	00d70f63          	beq	a4,a3,ffffffffc0202420 <default_free_pages+0xcc>
        if (base + base->property == p) {
ffffffffc0202406:	4d0c                	lw	a1,24(a0)
        p = le2page(le, page_link);
ffffffffc0202408:	fe070693          	addi	a3,a4,-32
        if (base + base->property == p) {
ffffffffc020240c:	02059613          	slli	a2,a1,0x20
ffffffffc0202410:	9201                	srli	a2,a2,0x20
ffffffffc0202412:	00361793          	slli	a5,a2,0x3
ffffffffc0202416:	97b2                	add	a5,a5,a2
ffffffffc0202418:	078e                	slli	a5,a5,0x3
ffffffffc020241a:	97aa                	add	a5,a5,a0
ffffffffc020241c:	04f68863          	beq	a3,a5,ffffffffc020246c <default_free_pages+0x118>
}
ffffffffc0202420:	60a2                	ld	ra,8(sp)
ffffffffc0202422:	0141                	addi	sp,sp,16
ffffffffc0202424:	8082                	ret
    prev->next = next->prev = elm;
ffffffffc0202426:	e790                	sd	a2,8(a5)
    elm->next = next;
ffffffffc0202428:	f514                	sd	a3,40(a0)
    return listelm->next;
ffffffffc020242a:	6798                	ld	a4,8(a5)
    elm->prev = prev;
ffffffffc020242c:	f11c                	sd	a5,32(a0)
        while ((le = list_next(le)) != &free_list) {
ffffffffc020242e:	02d70563          	beq	a4,a3,ffffffffc0202458 <default_free_pages+0x104>
    prev->next = next->prev = elm;
ffffffffc0202432:	8832                	mv	a6,a2
ffffffffc0202434:	4585                	li	a1,1
    for (; p != base + n; p ++) {
ffffffffc0202436:	87ba                	mv	a5,a4
ffffffffc0202438:	bf41                	j	ffffffffc02023c8 <default_free_pages+0x74>
            p->property += base->property;
ffffffffc020243a:	4d1c                	lw	a5,24(a0)
ffffffffc020243c:	0107883b          	addw	a6,a5,a6
ffffffffc0202440:	ff072c23          	sw	a6,-8(a4)
    __op_bit(and, __NOT, nr, ((volatile unsigned long *)addr));
ffffffffc0202444:	57f5                	li	a5,-3
ffffffffc0202446:	60f8b02f          	amoand.d	zero,a5,(a7)
    __list_del(listelm->prev, listelm->next);
ffffffffc020244a:	7110                	ld	a2,32(a0)
ffffffffc020244c:	751c                	ld	a5,40(a0)
            base = p;
ffffffffc020244e:	852e                	mv	a0,a1
    prev->next = next;
ffffffffc0202450:	e61c                	sd	a5,8(a2)
    return listelm->next;
ffffffffc0202452:	6718                	ld	a4,8(a4)
    next->prev = prev;
ffffffffc0202454:	e390                	sd	a2,0(a5)
ffffffffc0202456:	b775                	j	ffffffffc0202402 <default_free_pages+0xae>
ffffffffc0202458:	e290                	sd	a2,0(a3)
        while ((le = list_next(le)) != &free_list) {
ffffffffc020245a:	873e                	mv	a4,a5
ffffffffc020245c:	b761                	j	ffffffffc02023e4 <default_free_pages+0x90>
}
ffffffffc020245e:	60a2                	ld	ra,8(sp)
    prev->next = next->prev = elm;
ffffffffc0202460:	e390                	sd	a2,0(a5)
ffffffffc0202462:	e790                	sd	a2,8(a5)
    elm->next = next;
ffffffffc0202464:	f51c                	sd	a5,40(a0)
    elm->prev = prev;
ffffffffc0202466:	f11c                	sd	a5,32(a0)
ffffffffc0202468:	0141                	addi	sp,sp,16
ffffffffc020246a:	8082                	ret
            base->property += p->property;
ffffffffc020246c:	ff872783          	lw	a5,-8(a4)
ffffffffc0202470:	fe870693          	addi	a3,a4,-24
ffffffffc0202474:	9dbd                	addw	a1,a1,a5
ffffffffc0202476:	cd0c                	sw	a1,24(a0)
ffffffffc0202478:	57f5                	li	a5,-3
ffffffffc020247a:	60f6b02f          	amoand.d	zero,a5,(a3)
    __list_del(listelm->prev, listelm->next);
ffffffffc020247e:	6314                	ld	a3,0(a4)
ffffffffc0202480:	671c                	ld	a5,8(a4)
}
ffffffffc0202482:	60a2                	ld	ra,8(sp)
    prev->next = next;
ffffffffc0202484:	e69c                	sd	a5,8(a3)
    next->prev = prev;
ffffffffc0202486:	e394                	sd	a3,0(a5)
ffffffffc0202488:	0141                	addi	sp,sp,16
ffffffffc020248a:	8082                	ret
        assert(!PageReserved(p) && !PageProperty(p));
ffffffffc020248c:	00003697          	auipc	a3,0x3
ffffffffc0202490:	4a468693          	addi	a3,a3,1188 # ffffffffc0205930 <commands+0x11a0>
ffffffffc0202494:	00003617          	auipc	a2,0x3
ffffffffc0202498:	a2460613          	addi	a2,a2,-1500 # ffffffffc0204eb8 <commands+0x728>
ffffffffc020249c:	08300593          	li	a1,131
ffffffffc02024a0:	00003517          	auipc	a0,0x3
ffffffffc02024a4:	17850513          	addi	a0,a0,376 # ffffffffc0205618 <commands+0xe88>
ffffffffc02024a8:	c5bfd0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(n > 0);
ffffffffc02024ac:	00003697          	auipc	a3,0x3
ffffffffc02024b0:	47c68693          	addi	a3,a3,1148 # ffffffffc0205928 <commands+0x1198>
ffffffffc02024b4:	00003617          	auipc	a2,0x3
ffffffffc02024b8:	a0460613          	addi	a2,a2,-1532 # ffffffffc0204eb8 <commands+0x728>
ffffffffc02024bc:	08000593          	li	a1,128
ffffffffc02024c0:	00003517          	auipc	a0,0x3
ffffffffc02024c4:	15850513          	addi	a0,a0,344 # ffffffffc0205618 <commands+0xe88>
ffffffffc02024c8:	c3bfd0ef          	jal	ra,ffffffffc0200102 <__panic>

ffffffffc02024cc <default_alloc_pages>:
    assert(n > 0);
ffffffffc02024cc:	c959                	beqz	a0,ffffffffc0202562 <default_alloc_pages+0x96>
    if (n > nr_free) {
ffffffffc02024ce:	0000f597          	auipc	a1,0xf
ffffffffc02024d2:	c0258593          	addi	a1,a1,-1022 # ffffffffc02110d0 <free_area>
ffffffffc02024d6:	0105a803          	lw	a6,16(a1)
ffffffffc02024da:	862a                	mv	a2,a0
ffffffffc02024dc:	02081793          	slli	a5,a6,0x20
ffffffffc02024e0:	9381                	srli	a5,a5,0x20
ffffffffc02024e2:	00a7ee63          	bltu	a5,a0,ffffffffc02024fe <default_alloc_pages+0x32>
    list_entry_t *le = &free_list;
ffffffffc02024e6:	87ae                	mv	a5,a1
ffffffffc02024e8:	a801                	j	ffffffffc02024f8 <default_alloc_pages+0x2c>
        if (p->property >= n) {
ffffffffc02024ea:	ff87a703          	lw	a4,-8(a5)
ffffffffc02024ee:	02071693          	slli	a3,a4,0x20
ffffffffc02024f2:	9281                	srli	a3,a3,0x20
ffffffffc02024f4:	00c6f763          	bgeu	a3,a2,ffffffffc0202502 <default_alloc_pages+0x36>
    return listelm->next;
ffffffffc02024f8:	679c                	ld	a5,8(a5)
    while ((le = list_next(le)) != &free_list) {
ffffffffc02024fa:	feb798e3          	bne	a5,a1,ffffffffc02024ea <default_alloc_pages+0x1e>
        return NULL;
ffffffffc02024fe:	4501                	li	a0,0
}
ffffffffc0202500:	8082                	ret
    return listelm->prev;
ffffffffc0202502:	0007b883          	ld	a7,0(a5)
    __list_del(listelm->prev, listelm->next);
ffffffffc0202506:	0087b303          	ld	t1,8(a5)
        struct Page *p = le2page(le, page_link);
ffffffffc020250a:	fe078513          	addi	a0,a5,-32
            p->property = page->property - n;
ffffffffc020250e:	00060e1b          	sext.w	t3,a2
    prev->next = next;
ffffffffc0202512:	0068b423          	sd	t1,8(a7)
    next->prev = prev;
ffffffffc0202516:	01133023          	sd	a7,0(t1)
        if (page->property > n) {
ffffffffc020251a:	02d67b63          	bgeu	a2,a3,ffffffffc0202550 <default_alloc_pages+0x84>
            struct Page *p = page + n;
ffffffffc020251e:	00361693          	slli	a3,a2,0x3
ffffffffc0202522:	96b2                	add	a3,a3,a2
ffffffffc0202524:	068e                	slli	a3,a3,0x3
ffffffffc0202526:	96aa                	add	a3,a3,a0
            p->property = page->property - n;
ffffffffc0202528:	41c7073b          	subw	a4,a4,t3
ffffffffc020252c:	ce98                	sw	a4,24(a3)
    __op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc020252e:	00868613          	addi	a2,a3,8
ffffffffc0202532:	4709                	li	a4,2
ffffffffc0202534:	40e6302f          	amoor.d	zero,a4,(a2)
    __list_add(elm, listelm, listelm->next);
ffffffffc0202538:	0088b703          	ld	a4,8(a7)
            list_add(prev, &(p->page_link));
ffffffffc020253c:	02068613          	addi	a2,a3,32
        nr_free -= n;
ffffffffc0202540:	0105a803          	lw	a6,16(a1)
    prev->next = next->prev = elm;
ffffffffc0202544:	e310                	sd	a2,0(a4)
ffffffffc0202546:	00c8b423          	sd	a2,8(a7)
    elm->next = next;
ffffffffc020254a:	f698                	sd	a4,40(a3)
    elm->prev = prev;
ffffffffc020254c:	0316b023          	sd	a7,32(a3)
ffffffffc0202550:	41c8083b          	subw	a6,a6,t3
ffffffffc0202554:	0105a823          	sw	a6,16(a1)
    __op_bit(and, __NOT, nr, ((volatile unsigned long *)addr));
ffffffffc0202558:	5775                	li	a4,-3
ffffffffc020255a:	17a1                	addi	a5,a5,-24
ffffffffc020255c:	60e7b02f          	amoand.d	zero,a4,(a5)
}
ffffffffc0202560:	8082                	ret
default_alloc_pages(size_t n) {
ffffffffc0202562:	1141                	addi	sp,sp,-16
    assert(n > 0);
ffffffffc0202564:	00003697          	auipc	a3,0x3
ffffffffc0202568:	3c468693          	addi	a3,a3,964 # ffffffffc0205928 <commands+0x1198>
ffffffffc020256c:	00003617          	auipc	a2,0x3
ffffffffc0202570:	94c60613          	addi	a2,a2,-1716 # ffffffffc0204eb8 <commands+0x728>
ffffffffc0202574:	06200593          	li	a1,98
ffffffffc0202578:	00003517          	auipc	a0,0x3
ffffffffc020257c:	0a050513          	addi	a0,a0,160 # ffffffffc0205618 <commands+0xe88>
default_alloc_pages(size_t n) {
ffffffffc0202580:	e406                	sd	ra,8(sp)
    assert(n > 0);
ffffffffc0202582:	b81fd0ef          	jal	ra,ffffffffc0200102 <__panic>

ffffffffc0202586 <default_init_memmap>:
default_init_memmap(struct Page *base, size_t n) {
ffffffffc0202586:	1141                	addi	sp,sp,-16
ffffffffc0202588:	e406                	sd	ra,8(sp)
    assert(n > 0);
ffffffffc020258a:	c9e1                	beqz	a1,ffffffffc020265a <default_init_memmap+0xd4>
    for (; p != base + n; p ++) {
ffffffffc020258c:	00359693          	slli	a3,a1,0x3
ffffffffc0202590:	96ae                	add	a3,a3,a1
ffffffffc0202592:	068e                	slli	a3,a3,0x3
ffffffffc0202594:	96aa                	add	a3,a3,a0
ffffffffc0202596:	87aa                	mv	a5,a0
ffffffffc0202598:	00d50f63          	beq	a0,a3,ffffffffc02025b6 <default_init_memmap+0x30>
    return (((*(volatile unsigned long *)addr) >> nr) & 1);
ffffffffc020259c:	6798                	ld	a4,8(a5)
        assert(PageReserved(p));
ffffffffc020259e:	8b05                	andi	a4,a4,1
ffffffffc02025a0:	cf49                	beqz	a4,ffffffffc020263a <default_init_memmap+0xb4>
        p->flags = p->property = 0;
ffffffffc02025a2:	0007ac23          	sw	zero,24(a5)
ffffffffc02025a6:	0007b423          	sd	zero,8(a5)
ffffffffc02025aa:	0007a023          	sw	zero,0(a5)
    for (; p != base + n; p ++) {
ffffffffc02025ae:	04878793          	addi	a5,a5,72
ffffffffc02025b2:	fed795e3          	bne	a5,a3,ffffffffc020259c <default_init_memmap+0x16>
    base->property = n;
ffffffffc02025b6:	2581                	sext.w	a1,a1
ffffffffc02025b8:	cd0c                	sw	a1,24(a0)
    __op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc02025ba:	4789                	li	a5,2
ffffffffc02025bc:	00850713          	addi	a4,a0,8
ffffffffc02025c0:	40f7302f          	amoor.d	zero,a5,(a4)
    nr_free += n;
ffffffffc02025c4:	0000f697          	auipc	a3,0xf
ffffffffc02025c8:	b0c68693          	addi	a3,a3,-1268 # ffffffffc02110d0 <free_area>
ffffffffc02025cc:	4a98                	lw	a4,16(a3)
    return list->next == list;
ffffffffc02025ce:	669c                	ld	a5,8(a3)
        list_add(&free_list, &(base->page_link));
ffffffffc02025d0:	02050613          	addi	a2,a0,32
    nr_free += n;
ffffffffc02025d4:	9db9                	addw	a1,a1,a4
ffffffffc02025d6:	ca8c                	sw	a1,16(a3)
    if (list_empty(&free_list)) {
ffffffffc02025d8:	04d78a63          	beq	a5,a3,ffffffffc020262c <default_init_memmap+0xa6>
            struct Page* page = le2page(le, page_link);
ffffffffc02025dc:	fe078713          	addi	a4,a5,-32
ffffffffc02025e0:	0006b803          	ld	a6,0(a3)
    if (list_empty(&free_list)) {
ffffffffc02025e4:	4581                	li	a1,0
            if (base < page) {
ffffffffc02025e6:	00e56a63          	bltu	a0,a4,ffffffffc02025fa <default_init_memmap+0x74>
    return listelm->next;
ffffffffc02025ea:	6798                	ld	a4,8(a5)
            } else if (list_next(le) == &free_list) {
ffffffffc02025ec:	02d70263          	beq	a4,a3,ffffffffc0202610 <default_init_memmap+0x8a>
    for (; p != base + n; p ++) {
ffffffffc02025f0:	87ba                	mv	a5,a4
            struct Page* page = le2page(le, page_link);
ffffffffc02025f2:	fe078713          	addi	a4,a5,-32
            if (base < page) {
ffffffffc02025f6:	fee57ae3          	bgeu	a0,a4,ffffffffc02025ea <default_init_memmap+0x64>
ffffffffc02025fa:	c199                	beqz	a1,ffffffffc0202600 <default_init_memmap+0x7a>
ffffffffc02025fc:	0106b023          	sd	a6,0(a3)
    __list_add(elm, listelm->prev, listelm);
ffffffffc0202600:	6398                	ld	a4,0(a5)
}
ffffffffc0202602:	60a2                	ld	ra,8(sp)
    prev->next = next->prev = elm;
ffffffffc0202604:	e390                	sd	a2,0(a5)
ffffffffc0202606:	e710                	sd	a2,8(a4)
    elm->next = next;
ffffffffc0202608:	f51c                	sd	a5,40(a0)
    elm->prev = prev;
ffffffffc020260a:	f118                	sd	a4,32(a0)
ffffffffc020260c:	0141                	addi	sp,sp,16
ffffffffc020260e:	8082                	ret
    prev->next = next->prev = elm;
ffffffffc0202610:	e790                	sd	a2,8(a5)
    elm->next = next;
ffffffffc0202612:	f514                	sd	a3,40(a0)
    return listelm->next;
ffffffffc0202614:	6798                	ld	a4,8(a5)
    elm->prev = prev;
ffffffffc0202616:	f11c                	sd	a5,32(a0)
        while ((le = list_next(le)) != &free_list) {
ffffffffc0202618:	00d70663          	beq	a4,a3,ffffffffc0202624 <default_init_memmap+0x9e>
    prev->next = next->prev = elm;
ffffffffc020261c:	8832                	mv	a6,a2
ffffffffc020261e:	4585                	li	a1,1
    for (; p != base + n; p ++) {
ffffffffc0202620:	87ba                	mv	a5,a4
ffffffffc0202622:	bfc1                	j	ffffffffc02025f2 <default_init_memmap+0x6c>
}
ffffffffc0202624:	60a2                	ld	ra,8(sp)
ffffffffc0202626:	e290                	sd	a2,0(a3)
ffffffffc0202628:	0141                	addi	sp,sp,16
ffffffffc020262a:	8082                	ret
ffffffffc020262c:	60a2                	ld	ra,8(sp)
ffffffffc020262e:	e390                	sd	a2,0(a5)
ffffffffc0202630:	e790                	sd	a2,8(a5)
    elm->next = next;
ffffffffc0202632:	f51c                	sd	a5,40(a0)
    elm->prev = prev;
ffffffffc0202634:	f11c                	sd	a5,32(a0)
ffffffffc0202636:	0141                	addi	sp,sp,16
ffffffffc0202638:	8082                	ret
        assert(PageReserved(p));
ffffffffc020263a:	00003697          	auipc	a3,0x3
ffffffffc020263e:	31e68693          	addi	a3,a3,798 # ffffffffc0205958 <commands+0x11c8>
ffffffffc0202642:	00003617          	auipc	a2,0x3
ffffffffc0202646:	87660613          	addi	a2,a2,-1930 # ffffffffc0204eb8 <commands+0x728>
ffffffffc020264a:	04900593          	li	a1,73
ffffffffc020264e:	00003517          	auipc	a0,0x3
ffffffffc0202652:	fca50513          	addi	a0,a0,-54 # ffffffffc0205618 <commands+0xe88>
ffffffffc0202656:	aadfd0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(n > 0);
ffffffffc020265a:	00003697          	auipc	a3,0x3
ffffffffc020265e:	2ce68693          	addi	a3,a3,718 # ffffffffc0205928 <commands+0x1198>
ffffffffc0202662:	00003617          	auipc	a2,0x3
ffffffffc0202666:	85660613          	addi	a2,a2,-1962 # ffffffffc0204eb8 <commands+0x728>
ffffffffc020266a:	04600593          	li	a1,70
ffffffffc020266e:	00003517          	auipc	a0,0x3
ffffffffc0202672:	faa50513          	addi	a0,a0,-86 # ffffffffc0205618 <commands+0xe88>
ffffffffc0202676:	a8dfd0ef          	jal	ra,ffffffffc0200102 <__panic>

ffffffffc020267a <_clock_init_mm>:
    elm->prev = elm->next = elm;
ffffffffc020267a:	0000f797          	auipc	a5,0xf
ffffffffc020267e:	a6e78793          	addi	a5,a5,-1426 # ffffffffc02110e8 <pra_list_head_clock>
     // 初始化当前指针curr_ptr指向pra_list_head，表示当前页面替换位置为链表头
     // 将mm的私有成员指针指向pra_list_head，用于后续的页面替换算法操作
     //cprintf(" mm->sm_priv %x in fifo_init_mm\n",mm->sm_priv);
     list_init(&pra_list_head_clock);
     curr_ptr=&pra_list_head_clock;
     mm->sm_priv = &pra_list_head_clock;
ffffffffc0202682:	f51c                	sd	a5,40(a0)
ffffffffc0202684:	e79c                	sd	a5,8(a5)
ffffffffc0202686:	e39c                	sd	a5,0(a5)
     curr_ptr=&pra_list_head_clock;
ffffffffc0202688:	0000f717          	auipc	a4,0xf
ffffffffc020268c:	eaf73823          	sd	a5,-336(a4) # ffffffffc0211538 <curr_ptr>
     return 0;
}
ffffffffc0202690:	4501                	li	a0,0
ffffffffc0202692:	8082                	ret

ffffffffc0202694 <_clock_init>:

static int
_clock_init(void)
{
    return 0;
}
ffffffffc0202694:	4501                	li	a0,0
ffffffffc0202696:	8082                	ret

ffffffffc0202698 <_clock_set_unswappable>:

static int
_clock_set_unswappable(struct mm_struct *mm, uintptr_t addr)
{
    return 0;
}
ffffffffc0202698:	4501                	li	a0,0
ffffffffc020269a:	8082                	ret

ffffffffc020269c <_clock_tick_event>:

static int
_clock_tick_event(struct mm_struct *mm)
{ return 0; }
ffffffffc020269c:	4501                	li	a0,0
ffffffffc020269e:	8082                	ret

ffffffffc02026a0 <_clock_check_swap>:
_clock_check_swap(void) {
ffffffffc02026a0:	711d                	addi	sp,sp,-96
ffffffffc02026a2:	e0ca                	sd	s2,64(sp)
ffffffffc02026a4:	fc4e                	sd	s3,56(sp)
ffffffffc02026a6:	f852                	sd	s4,48(sp)
ffffffffc02026a8:	ec86                	sd	ra,88(sp)
ffffffffc02026aa:	e8a2                	sd	s0,80(sp)
ffffffffc02026ac:	e4a6                	sd	s1,72(sp)
ffffffffc02026ae:	f456                	sd	s5,40(sp)
ffffffffc02026b0:	f05a                	sd	s6,32(sp)
ffffffffc02026b2:	ec5e                	sd	s7,24(sp)
ffffffffc02026b4:	e862                	sd	s8,16(sp)
ffffffffc02026b6:	e466                	sd	s9,8(sp)
ffffffffc02026b8:	e06a                	sd	s10,0(sp)
    *(unsigned char *)0x3000 = 0x0c;
ffffffffc02026ba:	698d                	lui	s3,0x3
ffffffffc02026bc:	4a31                	li	s4,12
ffffffffc02026be:	01498023          	sb	s4,0(s3) # 3000 <kern_entry-0xffffffffc01fd000>
    cprintf("here1");
ffffffffc02026c2:	00003517          	auipc	a0,0x3
ffffffffc02026c6:	2f650513          	addi	a0,a0,758 # ffffffffc02059b8 <default_pmm_manager+0x38>
ffffffffc02026ca:	9f1fd0ef          	jal	ra,ffffffffc02000ba <cprintf>
    assert(pgfault_num==4);
ffffffffc02026ce:	4791                	li	a5,4
ffffffffc02026d0:	0000f917          	auipc	s2,0xf
ffffffffc02026d4:	e4892903          	lw	s2,-440(s2) # ffffffffc0211518 <pgfault_num>
ffffffffc02026d8:	16f91b63          	bne	s2,a5,ffffffffc020284e <_clock_check_swap+0x1ae>
    *(unsigned char *)0x1000 = 0x0a;
ffffffffc02026dc:	6a85                	lui	s5,0x1
ffffffffc02026de:	4b29                	li	s6,10
ffffffffc02026e0:	0000f417          	auipc	s0,0xf
ffffffffc02026e4:	e3840413          	addi	s0,s0,-456 # ffffffffc0211518 <pgfault_num>
ffffffffc02026e8:	016a8023          	sb	s6,0(s5) # 1000 <kern_entry-0xffffffffc01ff000>
    cprintf("here2");
ffffffffc02026ec:	00003517          	auipc	a0,0x3
ffffffffc02026f0:	2ec50513          	addi	a0,a0,748 # ffffffffc02059d8 <default_pmm_manager+0x58>
ffffffffc02026f4:	9c7fd0ef          	jal	ra,ffffffffc02000ba <cprintf>
    assert(pgfault_num==4);
ffffffffc02026f8:	4004                	lw	s1,0(s0)
ffffffffc02026fa:	2481                	sext.w	s1,s1
ffffffffc02026fc:	2d249963          	bne	s1,s2,ffffffffc02029ce <_clock_check_swap+0x32e>
    *(unsigned char *)0x4000 = 0x0d;
ffffffffc0202700:	6b91                	lui	s7,0x4
ffffffffc0202702:	4c35                	li	s8,13
ffffffffc0202704:	018b8023          	sb	s8,0(s7) # 4000 <kern_entry-0xffffffffc01fc000>
    cprintf("here3");
ffffffffc0202708:	00003517          	auipc	a0,0x3
ffffffffc020270c:	2d850513          	addi	a0,a0,728 # ffffffffc02059e0 <default_pmm_manager+0x60>
ffffffffc0202710:	9abfd0ef          	jal	ra,ffffffffc02000ba <cprintf>
    assert(pgfault_num==4);
ffffffffc0202714:	00042903          	lw	s2,0(s0)
ffffffffc0202718:	2901                	sext.w	s2,s2
ffffffffc020271a:	28991a63          	bne	s2,s1,ffffffffc02029ae <_clock_check_swap+0x30e>
    *(unsigned char *)0x2000 = 0x0b;
ffffffffc020271e:	6c89                	lui	s9,0x2
ffffffffc0202720:	4d2d                	li	s10,11
ffffffffc0202722:	01ac8023          	sb	s10,0(s9) # 2000 <kern_entry-0xffffffffc01fe000>
    cprintf("here4");
ffffffffc0202726:	00003517          	auipc	a0,0x3
ffffffffc020272a:	2c250513          	addi	a0,a0,706 # ffffffffc02059e8 <default_pmm_manager+0x68>
ffffffffc020272e:	98dfd0ef          	jal	ra,ffffffffc02000ba <cprintf>
    assert(pgfault_num==4);
ffffffffc0202732:	401c                	lw	a5,0(s0)
ffffffffc0202734:	2781                	sext.w	a5,a5
ffffffffc0202736:	25279c63          	bne	a5,s2,ffffffffc020298e <_clock_check_swap+0x2ee>
    *(unsigned char *)0x5000 = 0x0e;
ffffffffc020273a:	6795                	lui	a5,0x5
ffffffffc020273c:	4739                	li	a4,14
ffffffffc020273e:	00e78023          	sb	a4,0(a5) # 5000 <kern_entry-0xffffffffc01fb000>
    cprintf("here5");
ffffffffc0202742:	00003517          	auipc	a0,0x3
ffffffffc0202746:	2ae50513          	addi	a0,a0,686 # ffffffffc02059f0 <default_pmm_manager+0x70>
ffffffffc020274a:	971fd0ef          	jal	ra,ffffffffc02000ba <cprintf>
    assert(pgfault_num==5);
ffffffffc020274e:	4004                	lw	s1,0(s0)
ffffffffc0202750:	4795                	li	a5,5
ffffffffc0202752:	2481                	sext.w	s1,s1
ffffffffc0202754:	20f49d63          	bne	s1,a5,ffffffffc020296e <_clock_check_swap+0x2ce>
    *(unsigned char *)0x2000 = 0x0b;
ffffffffc0202758:	01ac8023          	sb	s10,0(s9)
    cprintf("here6");
ffffffffc020275c:	00003517          	auipc	a0,0x3
ffffffffc0202760:	2ac50513          	addi	a0,a0,684 # ffffffffc0205a08 <default_pmm_manager+0x88>
ffffffffc0202764:	957fd0ef          	jal	ra,ffffffffc02000ba <cprintf>
    assert(pgfault_num==5);
ffffffffc0202768:	00042903          	lw	s2,0(s0)
ffffffffc020276c:	2901                	sext.w	s2,s2
ffffffffc020276e:	1e991063          	bne	s2,s1,ffffffffc020294e <_clock_check_swap+0x2ae>
    *(unsigned char *)0x1000 = 0x0a;
ffffffffc0202772:	016a8023          	sb	s6,0(s5)
    cprintf("here7");
ffffffffc0202776:	00003517          	auipc	a0,0x3
ffffffffc020277a:	29a50513          	addi	a0,a0,666 # ffffffffc0205a10 <default_pmm_manager+0x90>
ffffffffc020277e:	93dfd0ef          	jal	ra,ffffffffc02000ba <cprintf>
    assert(pgfault_num==5);
ffffffffc0202782:	4004                	lw	s1,0(s0)
ffffffffc0202784:	2481                	sext.w	s1,s1
ffffffffc0202786:	1b249463          	bne	s1,s2,ffffffffc020292e <_clock_check_swap+0x28e>
    *(unsigned char *)0x2000 = 0x0b;
ffffffffc020278a:	01ac8023          	sb	s10,0(s9)
    cprintf("here8");
ffffffffc020278e:	00003517          	auipc	a0,0x3
ffffffffc0202792:	28a50513          	addi	a0,a0,650 # ffffffffc0205a18 <default_pmm_manager+0x98>
ffffffffc0202796:	925fd0ef          	jal	ra,ffffffffc02000ba <cprintf>
    assert(pgfault_num==5);
ffffffffc020279a:	00042903          	lw	s2,0(s0)
ffffffffc020279e:	2901                	sext.w	s2,s2
ffffffffc02027a0:	16991763          	bne	s2,s1,ffffffffc020290e <_clock_check_swap+0x26e>
    *(unsigned char *)0x3000 = 0x0c;
ffffffffc02027a4:	01498023          	sb	s4,0(s3)
    cprintf("here9");
ffffffffc02027a8:	00003517          	auipc	a0,0x3
ffffffffc02027ac:	27850513          	addi	a0,a0,632 # ffffffffc0205a20 <default_pmm_manager+0xa0>
ffffffffc02027b0:	90bfd0ef          	jal	ra,ffffffffc02000ba <cprintf>
    assert(pgfault_num==5);
ffffffffc02027b4:	4004                	lw	s1,0(s0)
ffffffffc02027b6:	2481                	sext.w	s1,s1
ffffffffc02027b8:	13249b63          	bne	s1,s2,ffffffffc02028ee <_clock_check_swap+0x24e>
    *(unsigned char *)0x4000 = 0x0d;
ffffffffc02027bc:	018b8023          	sb	s8,0(s7)
    cprintf("here10");
ffffffffc02027c0:	00003517          	auipc	a0,0x3
ffffffffc02027c4:	26850513          	addi	a0,a0,616 # ffffffffc0205a28 <default_pmm_manager+0xa8>
ffffffffc02027c8:	8f3fd0ef          	jal	ra,ffffffffc02000ba <cprintf>
    assert(pgfault_num==5);
ffffffffc02027cc:	401c                	lw	a5,0(s0)
ffffffffc02027ce:	2781                	sext.w	a5,a5
ffffffffc02027d0:	0e979f63          	bne	a5,s1,ffffffffc02028ce <_clock_check_swap+0x22e>
    *(unsigned char *)0x5000 = 0x0e;
ffffffffc02027d4:	6795                	lui	a5,0x5
ffffffffc02027d6:	4739                	li	a4,14
ffffffffc02027d8:	00e78023          	sb	a4,0(a5) # 5000 <kern_entry-0xffffffffc01fb000>
    cprintf("here11");
ffffffffc02027dc:	00003517          	auipc	a0,0x3
ffffffffc02027e0:	25450513          	addi	a0,a0,596 # ffffffffc0205a30 <default_pmm_manager+0xb0>
ffffffffc02027e4:	8d7fd0ef          	jal	ra,ffffffffc02000ba <cprintf>
    assert(pgfault_num==5);
ffffffffc02027e8:	401c                	lw	a5,0(s0)
ffffffffc02027ea:	4715                	li	a4,5
ffffffffc02027ec:	2781                	sext.w	a5,a5
ffffffffc02027ee:	0ce79063          	bne	a5,a4,ffffffffc02028ae <_clock_check_swap+0x20e>
    cprintf("here12");
ffffffffc02027f2:	00003517          	auipc	a0,0x3
ffffffffc02027f6:	24650513          	addi	a0,a0,582 # ffffffffc0205a38 <default_pmm_manager+0xb8>
    assert(*(unsigned char *)0x1000 == 0x0a);
ffffffffc02027fa:	6485                	lui	s1,0x1
    cprintf("here12");
ffffffffc02027fc:	8bffd0ef          	jal	ra,ffffffffc02000ba <cprintf>
    assert(*(unsigned char *)0x1000 == 0x0a);
ffffffffc0202800:	0004c903          	lbu	s2,0(s1) # 1000 <kern_entry-0xffffffffc01ff000>
ffffffffc0202804:	47a9                	li	a5,10
ffffffffc0202806:	08f91463          	bne	s2,a5,ffffffffc020288e <_clock_check_swap+0x1ee>
    cprintf("here13");
ffffffffc020280a:	00003517          	auipc	a0,0x3
ffffffffc020280e:	25e50513          	addi	a0,a0,606 # ffffffffc0205a68 <default_pmm_manager+0xe8>
ffffffffc0202812:	8a9fd0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("here14");
ffffffffc0202816:	00003517          	auipc	a0,0x3
ffffffffc020281a:	25a50513          	addi	a0,a0,602 # ffffffffc0205a70 <default_pmm_manager+0xf0>
    *(unsigned char *)0x1000 = 0x0a;
ffffffffc020281e:	01248023          	sb	s2,0(s1)
    cprintf("here14");
ffffffffc0202822:	899fd0ef          	jal	ra,ffffffffc02000ba <cprintf>
    assert(pgfault_num==6);
ffffffffc0202826:	401c                	lw	a5,0(s0)
ffffffffc0202828:	4719                	li	a4,6
ffffffffc020282a:	2781                	sext.w	a5,a5
ffffffffc020282c:	04e79163          	bne	a5,a4,ffffffffc020286e <_clock_check_swap+0x1ce>
}
ffffffffc0202830:	60e6                	ld	ra,88(sp)
ffffffffc0202832:	6446                	ld	s0,80(sp)
ffffffffc0202834:	64a6                	ld	s1,72(sp)
ffffffffc0202836:	6906                	ld	s2,64(sp)
ffffffffc0202838:	79e2                	ld	s3,56(sp)
ffffffffc020283a:	7a42                	ld	s4,48(sp)
ffffffffc020283c:	7aa2                	ld	s5,40(sp)
ffffffffc020283e:	7b02                	ld	s6,32(sp)
ffffffffc0202840:	6be2                	ld	s7,24(sp)
ffffffffc0202842:	6c42                	ld	s8,16(sp)
ffffffffc0202844:	6ca2                	ld	s9,8(sp)
ffffffffc0202846:	6d02                	ld	s10,0(sp)
ffffffffc0202848:	4501                	li	a0,0
ffffffffc020284a:	6125                	addi	sp,sp,96
ffffffffc020284c:	8082                	ret
    assert(pgfault_num==4);
ffffffffc020284e:	00003697          	auipc	a3,0x3
ffffffffc0202852:	bc268693          	addi	a3,a3,-1086 # ffffffffc0205410 <commands+0xc80>
ffffffffc0202856:	00002617          	auipc	a2,0x2
ffffffffc020285a:	66260613          	addi	a2,a2,1634 # ffffffffc0204eb8 <commands+0x728>
ffffffffc020285e:	09200593          	li	a1,146
ffffffffc0202862:	00003517          	auipc	a0,0x3
ffffffffc0202866:	15e50513          	addi	a0,a0,350 # ffffffffc02059c0 <default_pmm_manager+0x40>
ffffffffc020286a:	899fd0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(pgfault_num==6);
ffffffffc020286e:	00003697          	auipc	a3,0x3
ffffffffc0202872:	20a68693          	addi	a3,a3,522 # ffffffffc0205a78 <default_pmm_manager+0xf8>
ffffffffc0202876:	00002617          	auipc	a2,0x2
ffffffffc020287a:	64260613          	addi	a2,a2,1602 # ffffffffc0204eb8 <commands+0x728>
ffffffffc020287e:	0b600593          	li	a1,182
ffffffffc0202882:	00003517          	auipc	a0,0x3
ffffffffc0202886:	13e50513          	addi	a0,a0,318 # ffffffffc02059c0 <default_pmm_manager+0x40>
ffffffffc020288a:	879fd0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(*(unsigned char *)0x1000 == 0x0a);
ffffffffc020288e:	00003697          	auipc	a3,0x3
ffffffffc0202892:	1b268693          	addi	a3,a3,434 # ffffffffc0205a40 <default_pmm_manager+0xc0>
ffffffffc0202896:	00002617          	auipc	a2,0x2
ffffffffc020289a:	62260613          	addi	a2,a2,1570 # ffffffffc0204eb8 <commands+0x728>
ffffffffc020289e:	0b200593          	li	a1,178
ffffffffc02028a2:	00003517          	auipc	a0,0x3
ffffffffc02028a6:	11e50513          	addi	a0,a0,286 # ffffffffc02059c0 <default_pmm_manager+0x40>
ffffffffc02028aa:	859fd0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(pgfault_num==5);
ffffffffc02028ae:	00003697          	auipc	a3,0x3
ffffffffc02028b2:	14a68693          	addi	a3,a3,330 # ffffffffc02059f8 <default_pmm_manager+0x78>
ffffffffc02028b6:	00002617          	auipc	a2,0x2
ffffffffc02028ba:	60260613          	addi	a2,a2,1538 # ffffffffc0204eb8 <commands+0x728>
ffffffffc02028be:	0b000593          	li	a1,176
ffffffffc02028c2:	00003517          	auipc	a0,0x3
ffffffffc02028c6:	0fe50513          	addi	a0,a0,254 # ffffffffc02059c0 <default_pmm_manager+0x40>
ffffffffc02028ca:	839fd0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(pgfault_num==5);
ffffffffc02028ce:	00003697          	auipc	a3,0x3
ffffffffc02028d2:	12a68693          	addi	a3,a3,298 # ffffffffc02059f8 <default_pmm_manager+0x78>
ffffffffc02028d6:	00002617          	auipc	a2,0x2
ffffffffc02028da:	5e260613          	addi	a2,a2,1506 # ffffffffc0204eb8 <commands+0x728>
ffffffffc02028de:	0ad00593          	li	a1,173
ffffffffc02028e2:	00003517          	auipc	a0,0x3
ffffffffc02028e6:	0de50513          	addi	a0,a0,222 # ffffffffc02059c0 <default_pmm_manager+0x40>
ffffffffc02028ea:	819fd0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(pgfault_num==5);
ffffffffc02028ee:	00003697          	auipc	a3,0x3
ffffffffc02028f2:	10a68693          	addi	a3,a3,266 # ffffffffc02059f8 <default_pmm_manager+0x78>
ffffffffc02028f6:	00002617          	auipc	a2,0x2
ffffffffc02028fa:	5c260613          	addi	a2,a2,1474 # ffffffffc0204eb8 <commands+0x728>
ffffffffc02028fe:	0aa00593          	li	a1,170
ffffffffc0202902:	00003517          	auipc	a0,0x3
ffffffffc0202906:	0be50513          	addi	a0,a0,190 # ffffffffc02059c0 <default_pmm_manager+0x40>
ffffffffc020290a:	ff8fd0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(pgfault_num==5);
ffffffffc020290e:	00003697          	auipc	a3,0x3
ffffffffc0202912:	0ea68693          	addi	a3,a3,234 # ffffffffc02059f8 <default_pmm_manager+0x78>
ffffffffc0202916:	00002617          	auipc	a2,0x2
ffffffffc020291a:	5a260613          	addi	a2,a2,1442 # ffffffffc0204eb8 <commands+0x728>
ffffffffc020291e:	0a700593          	li	a1,167
ffffffffc0202922:	00003517          	auipc	a0,0x3
ffffffffc0202926:	09e50513          	addi	a0,a0,158 # ffffffffc02059c0 <default_pmm_manager+0x40>
ffffffffc020292a:	fd8fd0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(pgfault_num==5);
ffffffffc020292e:	00003697          	auipc	a3,0x3
ffffffffc0202932:	0ca68693          	addi	a3,a3,202 # ffffffffc02059f8 <default_pmm_manager+0x78>
ffffffffc0202936:	00002617          	auipc	a2,0x2
ffffffffc020293a:	58260613          	addi	a2,a2,1410 # ffffffffc0204eb8 <commands+0x728>
ffffffffc020293e:	0a400593          	li	a1,164
ffffffffc0202942:	00003517          	auipc	a0,0x3
ffffffffc0202946:	07e50513          	addi	a0,a0,126 # ffffffffc02059c0 <default_pmm_manager+0x40>
ffffffffc020294a:	fb8fd0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(pgfault_num==5);
ffffffffc020294e:	00003697          	auipc	a3,0x3
ffffffffc0202952:	0aa68693          	addi	a3,a3,170 # ffffffffc02059f8 <default_pmm_manager+0x78>
ffffffffc0202956:	00002617          	auipc	a2,0x2
ffffffffc020295a:	56260613          	addi	a2,a2,1378 # ffffffffc0204eb8 <commands+0x728>
ffffffffc020295e:	0a100593          	li	a1,161
ffffffffc0202962:	00003517          	auipc	a0,0x3
ffffffffc0202966:	05e50513          	addi	a0,a0,94 # ffffffffc02059c0 <default_pmm_manager+0x40>
ffffffffc020296a:	f98fd0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(pgfault_num==5);
ffffffffc020296e:	00003697          	auipc	a3,0x3
ffffffffc0202972:	08a68693          	addi	a3,a3,138 # ffffffffc02059f8 <default_pmm_manager+0x78>
ffffffffc0202976:	00002617          	auipc	a2,0x2
ffffffffc020297a:	54260613          	addi	a2,a2,1346 # ffffffffc0204eb8 <commands+0x728>
ffffffffc020297e:	09e00593          	li	a1,158
ffffffffc0202982:	00003517          	auipc	a0,0x3
ffffffffc0202986:	03e50513          	addi	a0,a0,62 # ffffffffc02059c0 <default_pmm_manager+0x40>
ffffffffc020298a:	f78fd0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(pgfault_num==4);
ffffffffc020298e:	00003697          	auipc	a3,0x3
ffffffffc0202992:	a8268693          	addi	a3,a3,-1406 # ffffffffc0205410 <commands+0xc80>
ffffffffc0202996:	00002617          	auipc	a2,0x2
ffffffffc020299a:	52260613          	addi	a2,a2,1314 # ffffffffc0204eb8 <commands+0x728>
ffffffffc020299e:	09b00593          	li	a1,155
ffffffffc02029a2:	00003517          	auipc	a0,0x3
ffffffffc02029a6:	01e50513          	addi	a0,a0,30 # ffffffffc02059c0 <default_pmm_manager+0x40>
ffffffffc02029aa:	f58fd0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(pgfault_num==4);
ffffffffc02029ae:	00003697          	auipc	a3,0x3
ffffffffc02029b2:	a6268693          	addi	a3,a3,-1438 # ffffffffc0205410 <commands+0xc80>
ffffffffc02029b6:	00002617          	auipc	a2,0x2
ffffffffc02029ba:	50260613          	addi	a2,a2,1282 # ffffffffc0204eb8 <commands+0x728>
ffffffffc02029be:	09800593          	li	a1,152
ffffffffc02029c2:	00003517          	auipc	a0,0x3
ffffffffc02029c6:	ffe50513          	addi	a0,a0,-2 # ffffffffc02059c0 <default_pmm_manager+0x40>
ffffffffc02029ca:	f38fd0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(pgfault_num==4);
ffffffffc02029ce:	00003697          	auipc	a3,0x3
ffffffffc02029d2:	a4268693          	addi	a3,a3,-1470 # ffffffffc0205410 <commands+0xc80>
ffffffffc02029d6:	00002617          	auipc	a2,0x2
ffffffffc02029da:	4e260613          	addi	a2,a2,1250 # ffffffffc0204eb8 <commands+0x728>
ffffffffc02029de:	09500593          	li	a1,149
ffffffffc02029e2:	00003517          	auipc	a0,0x3
ffffffffc02029e6:	fde50513          	addi	a0,a0,-34 # ffffffffc02059c0 <default_pmm_manager+0x40>
ffffffffc02029ea:	f18fd0ef          	jal	ra,ffffffffc0200102 <__panic>

ffffffffc02029ee <_clock_swap_out_victim>:
     list_entry_t *head=(list_entry_t*) mm->sm_priv;
ffffffffc02029ee:	7508                	ld	a0,40(a0)
{
ffffffffc02029f0:	1141                	addi	sp,sp,-16
ffffffffc02029f2:	e406                	sd	ra,8(sp)
         assert(head != NULL);
ffffffffc02029f4:	c921                	beqz	a0,ffffffffc0202a44 <_clock_swap_out_victim+0x56>
     assert(in_tick==0);
ffffffffc02029f6:	e63d                	bnez	a2,ffffffffc0202a64 <_clock_swap_out_victim+0x76>
     curr_ptr=head;
ffffffffc02029f8:	0000f817          	auipc	a6,0xf
ffffffffc02029fc:	b4080813          	addi	a6,a6,-1216 # ffffffffc0211538 <curr_ptr>
ffffffffc0202a00:	00a83023          	sd	a0,0(a6)
ffffffffc0202a04:	87aa                	mv	a5,a0
ffffffffc0202a06:	4601                	li	a2,0
ffffffffc0202a08:	a801                	j	ffffffffc0202a18 <_clock_swap_out_victim+0x2a>
        if(page->visited==0)
ffffffffc0202a0a:	fe07b683          	ld	a3,-32(a5)
ffffffffc0202a0e:	ce91                	beqz	a3,ffffffffc0202a2a <_clock_swap_out_victim+0x3c>
            page->visited=0;
ffffffffc0202a10:	fe07b023          	sd	zero,-32(a5)
    while (1) {
ffffffffc0202a14:	4605                	li	a2,1
ffffffffc0202a16:	87ba                	mv	a5,a4
            curr_ptr=curr_ptr->next;
ffffffffc0202a18:	6798                	ld	a4,8(a5)
        if(curr_ptr==head)
ffffffffc0202a1a:	fea798e3          	bne	a5,a0,ffffffffc0202a0a <_clock_swap_out_victim+0x1c>
        curr_ptr=curr_ptr->next;
ffffffffc0202a1e:	87ba                	mv	a5,a4
        if(page->visited==0)
ffffffffc0202a20:	fe07b683          	ld	a3,-32(a5)
        curr_ptr=curr_ptr->next;
ffffffffc0202a24:	6718                	ld	a4,8(a4)
ffffffffc0202a26:	4605                	li	a2,1
        if(page->visited==0)
ffffffffc0202a28:	f6e5                	bnez	a3,ffffffffc0202a10 <_clock_swap_out_victim+0x22>
ffffffffc0202a2a:	c219                	beqz	a2,ffffffffc0202a30 <_clock_swap_out_victim+0x42>
ffffffffc0202a2c:	00f83023          	sd	a5,0(a6)
    __list_del(listelm->prev, listelm->next);
ffffffffc0202a30:	6394                	ld	a3,0(a5)
}
ffffffffc0202a32:	60a2                	ld	ra,8(sp)
        struct Page* page=le2page(curr_ptr,pra_page_link);
ffffffffc0202a34:	fd078793          	addi	a5,a5,-48
    prev->next = next;
ffffffffc0202a38:	e698                	sd	a4,8(a3)
    next->prev = prev;
ffffffffc0202a3a:	e314                	sd	a3,0(a4)
            *ptr_page=page;
ffffffffc0202a3c:	e19c                	sd	a5,0(a1)
}
ffffffffc0202a3e:	4501                	li	a0,0
ffffffffc0202a40:	0141                	addi	sp,sp,16
ffffffffc0202a42:	8082                	ret
         assert(head != NULL);
ffffffffc0202a44:	00003697          	auipc	a3,0x3
ffffffffc0202a48:	04468693          	addi	a3,a3,68 # ffffffffc0205a88 <default_pmm_manager+0x108>
ffffffffc0202a4c:	00002617          	auipc	a2,0x2
ffffffffc0202a50:	46c60613          	addi	a2,a2,1132 # ffffffffc0204eb8 <commands+0x728>
ffffffffc0202a54:	04900593          	li	a1,73
ffffffffc0202a58:	00003517          	auipc	a0,0x3
ffffffffc0202a5c:	f6850513          	addi	a0,a0,-152 # ffffffffc02059c0 <default_pmm_manager+0x40>
ffffffffc0202a60:	ea2fd0ef          	jal	ra,ffffffffc0200102 <__panic>
     assert(in_tick==0);
ffffffffc0202a64:	00003697          	auipc	a3,0x3
ffffffffc0202a68:	03468693          	addi	a3,a3,52 # ffffffffc0205a98 <default_pmm_manager+0x118>
ffffffffc0202a6c:	00002617          	auipc	a2,0x2
ffffffffc0202a70:	44c60613          	addi	a2,a2,1100 # ffffffffc0204eb8 <commands+0x728>
ffffffffc0202a74:	04a00593          	li	a1,74
ffffffffc0202a78:	00003517          	auipc	a0,0x3
ffffffffc0202a7c:	f4850513          	addi	a0,a0,-184 # ffffffffc02059c0 <default_pmm_manager+0x40>
ffffffffc0202a80:	e82fd0ef          	jal	ra,ffffffffc0200102 <__panic>

ffffffffc0202a84 <_clock_map_swappable>:
    assert(entry != NULL && curr_ptr != NULL);
ffffffffc0202a84:	0000f797          	auipc	a5,0xf
ffffffffc0202a88:	ab47b783          	ld	a5,-1356(a5) # ffffffffc0211538 <curr_ptr>
ffffffffc0202a8c:	cf91                	beqz	a5,ffffffffc0202aa8 <_clock_map_swappable+0x24>
    list_add(((list_entry_t*)mm->sm_priv)->prev, entry);
ffffffffc0202a8e:	751c                	ld	a5,40(a0)
ffffffffc0202a90:	03060713          	addi	a4,a2,48
}
ffffffffc0202a94:	4501                	li	a0,0
    list_add(((list_entry_t*)mm->sm_priv)->prev, entry);
ffffffffc0202a96:	639c                	ld	a5,0(a5)
    __list_add(elm, listelm, listelm->next);
ffffffffc0202a98:	6794                	ld	a3,8(a5)
    prev->next = next->prev = elm;
ffffffffc0202a9a:	e298                	sd	a4,0(a3)
ffffffffc0202a9c:	e798                	sd	a4,8(a5)
    elm->prev = prev;
ffffffffc0202a9e:	fa1c                	sd	a5,48(a2)
    page->visited=1;
ffffffffc0202aa0:	4785                	li	a5,1
    elm->next = next;
ffffffffc0202aa2:	fe14                	sd	a3,56(a2)
ffffffffc0202aa4:	ea1c                	sd	a5,16(a2)
}
ffffffffc0202aa6:	8082                	ret
{
ffffffffc0202aa8:	1141                	addi	sp,sp,-16
    assert(entry != NULL && curr_ptr != NULL);
ffffffffc0202aaa:	00003697          	auipc	a3,0x3
ffffffffc0202aae:	ffe68693          	addi	a3,a3,-2 # ffffffffc0205aa8 <default_pmm_manager+0x128>
ffffffffc0202ab2:	00002617          	auipc	a2,0x2
ffffffffc0202ab6:	40660613          	addi	a2,a2,1030 # ffffffffc0204eb8 <commands+0x728>
ffffffffc0202aba:	03600593          	li	a1,54
ffffffffc0202abe:	00003517          	auipc	a0,0x3
ffffffffc0202ac2:	f0250513          	addi	a0,a0,-254 # ffffffffc02059c0 <default_pmm_manager+0x40>
{
ffffffffc0202ac6:	e406                	sd	ra,8(sp)
    assert(entry != NULL && curr_ptr != NULL);
ffffffffc0202ac8:	e3afd0ef          	jal	ra,ffffffffc0200102 <__panic>

ffffffffc0202acc <pa2page.part.0>:
static inline struct Page *pa2page(uintptr_t pa) {
ffffffffc0202acc:	1141                	addi	sp,sp,-16
        panic("pa2page called with invalid pa");
ffffffffc0202ace:	00002617          	auipc	a2,0x2
ffffffffc0202ad2:	63a60613          	addi	a2,a2,1594 # ffffffffc0205108 <commands+0x978>
ffffffffc0202ad6:	06500593          	li	a1,101
ffffffffc0202ada:	00002517          	auipc	a0,0x2
ffffffffc0202ade:	64e50513          	addi	a0,a0,1614 # ffffffffc0205128 <commands+0x998>
static inline struct Page *pa2page(uintptr_t pa) {
ffffffffc0202ae2:	e406                	sd	ra,8(sp)
        panic("pa2page called with invalid pa");
ffffffffc0202ae4:	e1efd0ef          	jal	ra,ffffffffc0200102 <__panic>

ffffffffc0202ae8 <pte2page.part.0>:
static inline struct Page *pte2page(pte_t pte) {
ffffffffc0202ae8:	1141                	addi	sp,sp,-16
        panic("pte2page called with invalid pte");
ffffffffc0202aea:	00003617          	auipc	a2,0x3
ffffffffc0202aee:	96660613          	addi	a2,a2,-1690 # ffffffffc0205450 <commands+0xcc0>
ffffffffc0202af2:	07000593          	li	a1,112
ffffffffc0202af6:	00002517          	auipc	a0,0x2
ffffffffc0202afa:	63250513          	addi	a0,a0,1586 # ffffffffc0205128 <commands+0x998>
static inline struct Page *pte2page(pte_t pte) {
ffffffffc0202afe:	e406                	sd	ra,8(sp)
        panic("pte2page called with invalid pte");
ffffffffc0202b00:	e02fd0ef          	jal	ra,ffffffffc0200102 <__panic>

ffffffffc0202b04 <alloc_pages>:
    pmm_manager->init_memmap(base, n);
}

// alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE
// memory
struct Page *alloc_pages(size_t n) {
ffffffffc0202b04:	7139                	addi	sp,sp,-64
ffffffffc0202b06:	f426                	sd	s1,40(sp)
ffffffffc0202b08:	f04a                	sd	s2,32(sp)
ffffffffc0202b0a:	ec4e                	sd	s3,24(sp)
ffffffffc0202b0c:	e852                	sd	s4,16(sp)
ffffffffc0202b0e:	e456                	sd	s5,8(sp)
ffffffffc0202b10:	e05a                	sd	s6,0(sp)
ffffffffc0202b12:	fc06                	sd	ra,56(sp)
ffffffffc0202b14:	f822                	sd	s0,48(sp)
ffffffffc0202b16:	84aa                	mv	s1,a0
ffffffffc0202b18:	0000f917          	auipc	s2,0xf
ffffffffc0202b1c:	a4890913          	addi	s2,s2,-1464 # ffffffffc0211560 <pmm_manager>
    while (1) {
        local_intr_save(intr_flag);
        { page = pmm_manager->alloc_pages(n); }
        local_intr_restore(intr_flag);

        if (page != NULL || n > 1 || swap_init_ok == 0) break;
ffffffffc0202b20:	4a05                	li	s4,1
ffffffffc0202b22:	0000fa97          	auipc	s5,0xf
ffffffffc0202b26:	a0ea8a93          	addi	s5,s5,-1522 # ffffffffc0211530 <swap_init_ok>

        extern struct mm_struct *check_mm_struct;
        // cprintf("page %x, call swap_out in alloc_pages %d\n",page, n);
        swap_out(check_mm_struct, n, 0);
ffffffffc0202b2a:	0005099b          	sext.w	s3,a0
ffffffffc0202b2e:	0000fb17          	auipc	s6,0xf
ffffffffc0202b32:	9e2b0b13          	addi	s6,s6,-1566 # ffffffffc0211510 <check_mm_struct>
ffffffffc0202b36:	a01d                	j	ffffffffc0202b5c <alloc_pages+0x58>
        { page = pmm_manager->alloc_pages(n); }
ffffffffc0202b38:	00093783          	ld	a5,0(s2)
ffffffffc0202b3c:	6f9c                	ld	a5,24(a5)
ffffffffc0202b3e:	9782                	jalr	a5
ffffffffc0202b40:	842a                	mv	s0,a0
        swap_out(check_mm_struct, n, 0);
ffffffffc0202b42:	4601                	li	a2,0
ffffffffc0202b44:	85ce                	mv	a1,s3
        if (page != NULL || n > 1 || swap_init_ok == 0) break;
ffffffffc0202b46:	ec0d                	bnez	s0,ffffffffc0202b80 <alloc_pages+0x7c>
ffffffffc0202b48:	029a6c63          	bltu	s4,s1,ffffffffc0202b80 <alloc_pages+0x7c>
ffffffffc0202b4c:	000aa783          	lw	a5,0(s5)
ffffffffc0202b50:	2781                	sext.w	a5,a5
ffffffffc0202b52:	c79d                	beqz	a5,ffffffffc0202b80 <alloc_pages+0x7c>
        swap_out(check_mm_struct, n, 0);
ffffffffc0202b54:	000b3503          	ld	a0,0(s6)
ffffffffc0202b58:	ebdfe0ef          	jal	ra,ffffffffc0201a14 <swap_out>
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0202b5c:	100027f3          	csrr	a5,sstatus
ffffffffc0202b60:	8b89                	andi	a5,a5,2
        { page = pmm_manager->alloc_pages(n); }
ffffffffc0202b62:	8526                	mv	a0,s1
ffffffffc0202b64:	dbf1                	beqz	a5,ffffffffc0202b38 <alloc_pages+0x34>
        intr_disable();
ffffffffc0202b66:	989fd0ef          	jal	ra,ffffffffc02004ee <intr_disable>
ffffffffc0202b6a:	00093783          	ld	a5,0(s2)
ffffffffc0202b6e:	8526                	mv	a0,s1
ffffffffc0202b70:	6f9c                	ld	a5,24(a5)
ffffffffc0202b72:	9782                	jalr	a5
ffffffffc0202b74:	842a                	mv	s0,a0
        intr_enable();
ffffffffc0202b76:	973fd0ef          	jal	ra,ffffffffc02004e8 <intr_enable>
        swap_out(check_mm_struct, n, 0);
ffffffffc0202b7a:	4601                	li	a2,0
ffffffffc0202b7c:	85ce                	mv	a1,s3
        if (page != NULL || n > 1 || swap_init_ok == 0) break;
ffffffffc0202b7e:	d469                	beqz	s0,ffffffffc0202b48 <alloc_pages+0x44>
    }
    // cprintf("n %d,get page %x, No %d in alloc_pages\n",n,page,(page-pages));
    return page;
}
ffffffffc0202b80:	70e2                	ld	ra,56(sp)
ffffffffc0202b82:	8522                	mv	a0,s0
ffffffffc0202b84:	7442                	ld	s0,48(sp)
ffffffffc0202b86:	74a2                	ld	s1,40(sp)
ffffffffc0202b88:	7902                	ld	s2,32(sp)
ffffffffc0202b8a:	69e2                	ld	s3,24(sp)
ffffffffc0202b8c:	6a42                	ld	s4,16(sp)
ffffffffc0202b8e:	6aa2                	ld	s5,8(sp)
ffffffffc0202b90:	6b02                	ld	s6,0(sp)
ffffffffc0202b92:	6121                	addi	sp,sp,64
ffffffffc0202b94:	8082                	ret

ffffffffc0202b96 <free_pages>:
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0202b96:	100027f3          	csrr	a5,sstatus
ffffffffc0202b9a:	8b89                	andi	a5,a5,2
ffffffffc0202b9c:	e799                	bnez	a5,ffffffffc0202baa <free_pages+0x14>
// free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory
void free_pages(struct Page *base, size_t n) {
    bool intr_flag;

    local_intr_save(intr_flag);
    { pmm_manager->free_pages(base, n); }
ffffffffc0202b9e:	0000f797          	auipc	a5,0xf
ffffffffc0202ba2:	9c27b783          	ld	a5,-1598(a5) # ffffffffc0211560 <pmm_manager>
ffffffffc0202ba6:	739c                	ld	a5,32(a5)
ffffffffc0202ba8:	8782                	jr	a5
void free_pages(struct Page *base, size_t n) {
ffffffffc0202baa:	1101                	addi	sp,sp,-32
ffffffffc0202bac:	ec06                	sd	ra,24(sp)
ffffffffc0202bae:	e822                	sd	s0,16(sp)
ffffffffc0202bb0:	e426                	sd	s1,8(sp)
ffffffffc0202bb2:	842a                	mv	s0,a0
ffffffffc0202bb4:	84ae                	mv	s1,a1
        intr_disable();
ffffffffc0202bb6:	939fd0ef          	jal	ra,ffffffffc02004ee <intr_disable>
    { pmm_manager->free_pages(base, n); }
ffffffffc0202bba:	0000f797          	auipc	a5,0xf
ffffffffc0202bbe:	9a67b783          	ld	a5,-1626(a5) # ffffffffc0211560 <pmm_manager>
ffffffffc0202bc2:	739c                	ld	a5,32(a5)
ffffffffc0202bc4:	85a6                	mv	a1,s1
ffffffffc0202bc6:	8522                	mv	a0,s0
ffffffffc0202bc8:	9782                	jalr	a5
    local_intr_restore(intr_flag);
}
ffffffffc0202bca:	6442                	ld	s0,16(sp)
ffffffffc0202bcc:	60e2                	ld	ra,24(sp)
ffffffffc0202bce:	64a2                	ld	s1,8(sp)
ffffffffc0202bd0:	6105                	addi	sp,sp,32
        intr_enable();
ffffffffc0202bd2:	917fd06f          	j	ffffffffc02004e8 <intr_enable>

ffffffffc0202bd6 <nr_free_pages>:
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0202bd6:	100027f3          	csrr	a5,sstatus
ffffffffc0202bda:	8b89                	andi	a5,a5,2
ffffffffc0202bdc:	e799                	bnez	a5,ffffffffc0202bea <nr_free_pages+0x14>
// of current free memory
size_t nr_free_pages(void) {
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
    { ret = pmm_manager->nr_free_pages(); }
ffffffffc0202bde:	0000f797          	auipc	a5,0xf
ffffffffc0202be2:	9827b783          	ld	a5,-1662(a5) # ffffffffc0211560 <pmm_manager>
ffffffffc0202be6:	779c                	ld	a5,40(a5)
ffffffffc0202be8:	8782                	jr	a5
size_t nr_free_pages(void) {
ffffffffc0202bea:	1141                	addi	sp,sp,-16
ffffffffc0202bec:	e406                	sd	ra,8(sp)
ffffffffc0202bee:	e022                	sd	s0,0(sp)
        intr_disable();
ffffffffc0202bf0:	8fffd0ef          	jal	ra,ffffffffc02004ee <intr_disable>
    { ret = pmm_manager->nr_free_pages(); }
ffffffffc0202bf4:	0000f797          	auipc	a5,0xf
ffffffffc0202bf8:	96c7b783          	ld	a5,-1684(a5) # ffffffffc0211560 <pmm_manager>
ffffffffc0202bfc:	779c                	ld	a5,40(a5)
ffffffffc0202bfe:	9782                	jalr	a5
ffffffffc0202c00:	842a                	mv	s0,a0
        intr_enable();
ffffffffc0202c02:	8e7fd0ef          	jal	ra,ffffffffc02004e8 <intr_enable>
    local_intr_restore(intr_flag);
    return ret;
}
ffffffffc0202c06:	60a2                	ld	ra,8(sp)
ffffffffc0202c08:	8522                	mv	a0,s0
ffffffffc0202c0a:	6402                	ld	s0,0(sp)
ffffffffc0202c0c:	0141                	addi	sp,sp,16
ffffffffc0202c0e:	8082                	ret

ffffffffc0202c10 <get_pte>:
     *   PTE_W           0x002                   // page table/directory entry
     * flags bit : Writeable
     *   PTE_U           0x004                   // page table/directory entry
     * flags bit : User can access
     */
    pde_t *pdep1 = &pgdir[PDX1(la)];
ffffffffc0202c10:	01e5d793          	srli	a5,a1,0x1e
ffffffffc0202c14:	1ff7f793          	andi	a5,a5,511
pte_t *get_pte(pde_t *pgdir, uintptr_t la, bool create) {
ffffffffc0202c18:	715d                	addi	sp,sp,-80
    pde_t *pdep1 = &pgdir[PDX1(la)];
ffffffffc0202c1a:	078e                	slli	a5,a5,0x3
pte_t *get_pte(pde_t *pgdir, uintptr_t la, bool create) {
ffffffffc0202c1c:	fc26                	sd	s1,56(sp)
    pde_t *pdep1 = &pgdir[PDX1(la)];
ffffffffc0202c1e:	00f504b3          	add	s1,a0,a5
    if (!(*pdep1 & PTE_V)) {
ffffffffc0202c22:	6094                	ld	a3,0(s1)
pte_t *get_pte(pde_t *pgdir, uintptr_t la, bool create) {
ffffffffc0202c24:	f84a                	sd	s2,48(sp)
ffffffffc0202c26:	f44e                	sd	s3,40(sp)
ffffffffc0202c28:	f052                	sd	s4,32(sp)
ffffffffc0202c2a:	e486                	sd	ra,72(sp)
ffffffffc0202c2c:	e0a2                	sd	s0,64(sp)
ffffffffc0202c2e:	ec56                	sd	s5,24(sp)
ffffffffc0202c30:	e85a                	sd	s6,16(sp)
ffffffffc0202c32:	e45e                	sd	s7,8(sp)
    if (!(*pdep1 & PTE_V)) {
ffffffffc0202c34:	0016f793          	andi	a5,a3,1
pte_t *get_pte(pde_t *pgdir, uintptr_t la, bool create) {
ffffffffc0202c38:	892e                	mv	s2,a1
ffffffffc0202c3a:	8a32                	mv	s4,a2
ffffffffc0202c3c:	0000f997          	auipc	s3,0xf
ffffffffc0202c40:	91498993          	addi	s3,s3,-1772 # ffffffffc0211550 <npage>
    if (!(*pdep1 & PTE_V)) {
ffffffffc0202c44:	efb5                	bnez	a5,ffffffffc0202cc0 <get_pte+0xb0>
        struct Page *page;
        if (!create || (page = alloc_page()) == NULL) {
ffffffffc0202c46:	14060c63          	beqz	a2,ffffffffc0202d9e <get_pte+0x18e>
ffffffffc0202c4a:	4505                	li	a0,1
ffffffffc0202c4c:	eb9ff0ef          	jal	ra,ffffffffc0202b04 <alloc_pages>
ffffffffc0202c50:	842a                	mv	s0,a0
ffffffffc0202c52:	14050663          	beqz	a0,ffffffffc0202d9e <get_pte+0x18e>
static inline ppn_t page2ppn(struct Page *page) { return page - pages + nbase; }
ffffffffc0202c56:	0000fb97          	auipc	s7,0xf
ffffffffc0202c5a:	902b8b93          	addi	s7,s7,-1790 # ffffffffc0211558 <pages>
ffffffffc0202c5e:	000bb503          	ld	a0,0(s7)
ffffffffc0202c62:	00003b17          	auipc	s6,0x3
ffffffffc0202c66:	71eb3b03          	ld	s6,1822(s6) # ffffffffc0206380 <error_string+0x38>
ffffffffc0202c6a:	00080ab7          	lui	s5,0x80
ffffffffc0202c6e:	40a40533          	sub	a0,s0,a0
ffffffffc0202c72:	850d                	srai	a0,a0,0x3
ffffffffc0202c74:	03650533          	mul	a0,a0,s6
            return NULL;
        }
        set_page_ref(page, 1);
        uintptr_t pa = page2pa(page);
        memset(KADDR(pa), 0, PGSIZE);
ffffffffc0202c78:	0000f997          	auipc	s3,0xf
ffffffffc0202c7c:	8d898993          	addi	s3,s3,-1832 # ffffffffc0211550 <npage>
static inline void set_page_ref(struct Page *page, int val) { page->ref = val; }
ffffffffc0202c80:	4785                	li	a5,1
ffffffffc0202c82:	0009b703          	ld	a4,0(s3)
ffffffffc0202c86:	c01c                	sw	a5,0(s0)
static inline ppn_t page2ppn(struct Page *page) { return page - pages + nbase; }
ffffffffc0202c88:	9556                	add	a0,a0,s5
ffffffffc0202c8a:	00c51793          	slli	a5,a0,0xc
ffffffffc0202c8e:	83b1                	srli	a5,a5,0xc
    return page2ppn(page) << PGSHIFT;
ffffffffc0202c90:	0532                	slli	a0,a0,0xc
ffffffffc0202c92:	14e7fd63          	bgeu	a5,a4,ffffffffc0202dec <get_pte+0x1dc>
ffffffffc0202c96:	0000f797          	auipc	a5,0xf
ffffffffc0202c9a:	8d27b783          	ld	a5,-1838(a5) # ffffffffc0211568 <va_pa_offset>
ffffffffc0202c9e:	6605                	lui	a2,0x1
ffffffffc0202ca0:	4581                	li	a1,0
ffffffffc0202ca2:	953e                	add	a0,a0,a5
ffffffffc0202ca4:	3a2010ef          	jal	ra,ffffffffc0204046 <memset>
static inline ppn_t page2ppn(struct Page *page) { return page - pages + nbase; }
ffffffffc0202ca8:	000bb683          	ld	a3,0(s7)
ffffffffc0202cac:	40d406b3          	sub	a3,s0,a3
ffffffffc0202cb0:	868d                	srai	a3,a3,0x3
ffffffffc0202cb2:	036686b3          	mul	a3,a3,s6
ffffffffc0202cb6:	96d6                	add	a3,a3,s5

static inline void flush_tlb() { asm volatile("sfence.vma"); }

// construct PTE from a page and permission bits
static inline pte_t pte_create(uintptr_t ppn, int type) {
    return (ppn << PTE_PPN_SHIFT) | PTE_V | type;
ffffffffc0202cb8:	06aa                	slli	a3,a3,0xa
ffffffffc0202cba:	0116e693          	ori	a3,a3,17
        *pdep1 = pte_create(page2ppn(page), PTE_U | PTE_V);
ffffffffc0202cbe:	e094                	sd	a3,0(s1)
    }
    pde_t *pdep0 = &((pde_t *)KADDR(PDE_ADDR(*pdep1)))[PDX0(la)];
ffffffffc0202cc0:	77fd                	lui	a5,0xfffff
ffffffffc0202cc2:	068a                	slli	a3,a3,0x2
ffffffffc0202cc4:	0009b703          	ld	a4,0(s3)
ffffffffc0202cc8:	8efd                	and	a3,a3,a5
ffffffffc0202cca:	00c6d793          	srli	a5,a3,0xc
ffffffffc0202cce:	0ce7fa63          	bgeu	a5,a4,ffffffffc0202da2 <get_pte+0x192>
ffffffffc0202cd2:	0000fa97          	auipc	s5,0xf
ffffffffc0202cd6:	896a8a93          	addi	s5,s5,-1898 # ffffffffc0211568 <va_pa_offset>
ffffffffc0202cda:	000ab403          	ld	s0,0(s5)
ffffffffc0202cde:	01595793          	srli	a5,s2,0x15
ffffffffc0202ce2:	1ff7f793          	andi	a5,a5,511
ffffffffc0202ce6:	96a2                	add	a3,a3,s0
ffffffffc0202ce8:	00379413          	slli	s0,a5,0x3
ffffffffc0202cec:	9436                	add	s0,s0,a3
//    pde_t *pdep0 = &((pde_t *)(PDE_ADDR(*pdep1)))[PDX0(la)];
    if (!(*pdep0 & PTE_V)) {
ffffffffc0202cee:	6014                	ld	a3,0(s0)
ffffffffc0202cf0:	0016f793          	andi	a5,a3,1
ffffffffc0202cf4:	ebad                	bnez	a5,ffffffffc0202d66 <get_pte+0x156>
    	struct Page *page;
    	if (!create || (page = alloc_page()) == NULL) {
ffffffffc0202cf6:	0a0a0463          	beqz	s4,ffffffffc0202d9e <get_pte+0x18e>
ffffffffc0202cfa:	4505                	li	a0,1
ffffffffc0202cfc:	e09ff0ef          	jal	ra,ffffffffc0202b04 <alloc_pages>
ffffffffc0202d00:	84aa                	mv	s1,a0
ffffffffc0202d02:	cd51                	beqz	a0,ffffffffc0202d9e <get_pte+0x18e>
static inline ppn_t page2ppn(struct Page *page) { return page - pages + nbase; }
ffffffffc0202d04:	0000fb97          	auipc	s7,0xf
ffffffffc0202d08:	854b8b93          	addi	s7,s7,-1964 # ffffffffc0211558 <pages>
ffffffffc0202d0c:	000bb503          	ld	a0,0(s7)
ffffffffc0202d10:	00003b17          	auipc	s6,0x3
ffffffffc0202d14:	670b3b03          	ld	s6,1648(s6) # ffffffffc0206380 <error_string+0x38>
ffffffffc0202d18:	00080a37          	lui	s4,0x80
ffffffffc0202d1c:	40a48533          	sub	a0,s1,a0
ffffffffc0202d20:	850d                	srai	a0,a0,0x3
ffffffffc0202d22:	03650533          	mul	a0,a0,s6
static inline void set_page_ref(struct Page *page, int val) { page->ref = val; }
ffffffffc0202d26:	4785                	li	a5,1
    		return NULL;
    	}
    	set_page_ref(page, 1);
    	uintptr_t pa = page2pa(page);
    	memset(KADDR(pa), 0, PGSIZE);
ffffffffc0202d28:	0009b703          	ld	a4,0(s3)
ffffffffc0202d2c:	c09c                	sw	a5,0(s1)
static inline ppn_t page2ppn(struct Page *page) { return page - pages + nbase; }
ffffffffc0202d2e:	9552                	add	a0,a0,s4
ffffffffc0202d30:	00c51793          	slli	a5,a0,0xc
ffffffffc0202d34:	83b1                	srli	a5,a5,0xc
    return page2ppn(page) << PGSHIFT;
ffffffffc0202d36:	0532                	slli	a0,a0,0xc
ffffffffc0202d38:	08e7fd63          	bgeu	a5,a4,ffffffffc0202dd2 <get_pte+0x1c2>
ffffffffc0202d3c:	000ab783          	ld	a5,0(s5)
ffffffffc0202d40:	6605                	lui	a2,0x1
ffffffffc0202d42:	4581                	li	a1,0
ffffffffc0202d44:	953e                	add	a0,a0,a5
ffffffffc0202d46:	300010ef          	jal	ra,ffffffffc0204046 <memset>
static inline ppn_t page2ppn(struct Page *page) { return page - pages + nbase; }
ffffffffc0202d4a:	000bb683          	ld	a3,0(s7)
ffffffffc0202d4e:	40d486b3          	sub	a3,s1,a3
ffffffffc0202d52:	868d                	srai	a3,a3,0x3
ffffffffc0202d54:	036686b3          	mul	a3,a3,s6
ffffffffc0202d58:	96d2                	add	a3,a3,s4
    return (ppn << PTE_PPN_SHIFT) | PTE_V | type;
ffffffffc0202d5a:	06aa                	slli	a3,a3,0xa
ffffffffc0202d5c:	0116e693          	ori	a3,a3,17
 //   	memset(pa, 0, PGSIZE);
    	*pdep0 = pte_create(page2ppn(page), PTE_U | PTE_V);
ffffffffc0202d60:	e014                	sd	a3,0(s0)
    }
    return &((pte_t *)KADDR(PDE_ADDR(*pdep0)))[PTX(la)];
ffffffffc0202d62:	0009b703          	ld	a4,0(s3)
ffffffffc0202d66:	068a                	slli	a3,a3,0x2
ffffffffc0202d68:	757d                	lui	a0,0xfffff
ffffffffc0202d6a:	8ee9                	and	a3,a3,a0
ffffffffc0202d6c:	00c6d793          	srli	a5,a3,0xc
ffffffffc0202d70:	04e7f563          	bgeu	a5,a4,ffffffffc0202dba <get_pte+0x1aa>
ffffffffc0202d74:	000ab503          	ld	a0,0(s5)
ffffffffc0202d78:	00c95913          	srli	s2,s2,0xc
ffffffffc0202d7c:	1ff97913          	andi	s2,s2,511
ffffffffc0202d80:	96aa                	add	a3,a3,a0
ffffffffc0202d82:	00391513          	slli	a0,s2,0x3
ffffffffc0202d86:	9536                	add	a0,a0,a3
}
ffffffffc0202d88:	60a6                	ld	ra,72(sp)
ffffffffc0202d8a:	6406                	ld	s0,64(sp)
ffffffffc0202d8c:	74e2                	ld	s1,56(sp)
ffffffffc0202d8e:	7942                	ld	s2,48(sp)
ffffffffc0202d90:	79a2                	ld	s3,40(sp)
ffffffffc0202d92:	7a02                	ld	s4,32(sp)
ffffffffc0202d94:	6ae2                	ld	s5,24(sp)
ffffffffc0202d96:	6b42                	ld	s6,16(sp)
ffffffffc0202d98:	6ba2                	ld	s7,8(sp)
ffffffffc0202d9a:	6161                	addi	sp,sp,80
ffffffffc0202d9c:	8082                	ret
            return NULL;
ffffffffc0202d9e:	4501                	li	a0,0
ffffffffc0202da0:	b7e5                	j	ffffffffc0202d88 <get_pte+0x178>
    pde_t *pdep0 = &((pde_t *)KADDR(PDE_ADDR(*pdep1)))[PDX0(la)];
ffffffffc0202da2:	00003617          	auipc	a2,0x3
ffffffffc0202da6:	d4660613          	addi	a2,a2,-698 # ffffffffc0205ae8 <default_pmm_manager+0x168>
ffffffffc0202daa:	10200593          	li	a1,258
ffffffffc0202dae:	00003517          	auipc	a0,0x3
ffffffffc0202db2:	d6250513          	addi	a0,a0,-670 # ffffffffc0205b10 <default_pmm_manager+0x190>
ffffffffc0202db6:	b4cfd0ef          	jal	ra,ffffffffc0200102 <__panic>
    return &((pte_t *)KADDR(PDE_ADDR(*pdep0)))[PTX(la)];
ffffffffc0202dba:	00003617          	auipc	a2,0x3
ffffffffc0202dbe:	d2e60613          	addi	a2,a2,-722 # ffffffffc0205ae8 <default_pmm_manager+0x168>
ffffffffc0202dc2:	10f00593          	li	a1,271
ffffffffc0202dc6:	00003517          	auipc	a0,0x3
ffffffffc0202dca:	d4a50513          	addi	a0,a0,-694 # ffffffffc0205b10 <default_pmm_manager+0x190>
ffffffffc0202dce:	b34fd0ef          	jal	ra,ffffffffc0200102 <__panic>
    	memset(KADDR(pa), 0, PGSIZE);
ffffffffc0202dd2:	86aa                	mv	a3,a0
ffffffffc0202dd4:	00003617          	auipc	a2,0x3
ffffffffc0202dd8:	d1460613          	addi	a2,a2,-748 # ffffffffc0205ae8 <default_pmm_manager+0x168>
ffffffffc0202ddc:	10b00593          	li	a1,267
ffffffffc0202de0:	00003517          	auipc	a0,0x3
ffffffffc0202de4:	d3050513          	addi	a0,a0,-720 # ffffffffc0205b10 <default_pmm_manager+0x190>
ffffffffc0202de8:	b1afd0ef          	jal	ra,ffffffffc0200102 <__panic>
        memset(KADDR(pa), 0, PGSIZE);
ffffffffc0202dec:	86aa                	mv	a3,a0
ffffffffc0202dee:	00003617          	auipc	a2,0x3
ffffffffc0202df2:	cfa60613          	addi	a2,a2,-774 # ffffffffc0205ae8 <default_pmm_manager+0x168>
ffffffffc0202df6:	0ff00593          	li	a1,255
ffffffffc0202dfa:	00003517          	auipc	a0,0x3
ffffffffc0202dfe:	d1650513          	addi	a0,a0,-746 # ffffffffc0205b10 <default_pmm_manager+0x190>
ffffffffc0202e02:	b00fd0ef          	jal	ra,ffffffffc0200102 <__panic>

ffffffffc0202e06 <get_page>:

// get_page - get related Page struct for linear address la using PDT pgdir
struct Page *get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store) {
ffffffffc0202e06:	1141                	addi	sp,sp,-16
ffffffffc0202e08:	e022                	sd	s0,0(sp)
ffffffffc0202e0a:	8432                	mv	s0,a2
    pte_t *ptep = get_pte(pgdir, la, 0);
ffffffffc0202e0c:	4601                	li	a2,0
struct Page *get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store) {
ffffffffc0202e0e:	e406                	sd	ra,8(sp)
    pte_t *ptep = get_pte(pgdir, la, 0);
ffffffffc0202e10:	e01ff0ef          	jal	ra,ffffffffc0202c10 <get_pte>
    if (ptep_store != NULL) {
ffffffffc0202e14:	c011                	beqz	s0,ffffffffc0202e18 <get_page+0x12>
        *ptep_store = ptep;
ffffffffc0202e16:	e008                	sd	a0,0(s0)
    }
    if (ptep != NULL && *ptep & PTE_V) {
ffffffffc0202e18:	c511                	beqz	a0,ffffffffc0202e24 <get_page+0x1e>
ffffffffc0202e1a:	611c                	ld	a5,0(a0)
        return pte2page(*ptep);
    }
    return NULL;
ffffffffc0202e1c:	4501                	li	a0,0
    if (ptep != NULL && *ptep & PTE_V) {
ffffffffc0202e1e:	0017f713          	andi	a4,a5,1
ffffffffc0202e22:	e709                	bnez	a4,ffffffffc0202e2c <get_page+0x26>
}
ffffffffc0202e24:	60a2                	ld	ra,8(sp)
ffffffffc0202e26:	6402                	ld	s0,0(sp)
ffffffffc0202e28:	0141                	addi	sp,sp,16
ffffffffc0202e2a:	8082                	ret
    return pa2page(PTE_ADDR(pte));
ffffffffc0202e2c:	078a                	slli	a5,a5,0x2
ffffffffc0202e2e:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage) {
ffffffffc0202e30:	0000e717          	auipc	a4,0xe
ffffffffc0202e34:	72073703          	ld	a4,1824(a4) # ffffffffc0211550 <npage>
ffffffffc0202e38:	02e7f263          	bgeu	a5,a4,ffffffffc0202e5c <get_page+0x56>
    return &pages[PPN(pa) - nbase];
ffffffffc0202e3c:	fff80537          	lui	a0,0xfff80
ffffffffc0202e40:	97aa                	add	a5,a5,a0
ffffffffc0202e42:	60a2                	ld	ra,8(sp)
ffffffffc0202e44:	6402                	ld	s0,0(sp)
ffffffffc0202e46:	00379513          	slli	a0,a5,0x3
ffffffffc0202e4a:	97aa                	add	a5,a5,a0
ffffffffc0202e4c:	078e                	slli	a5,a5,0x3
ffffffffc0202e4e:	0000e517          	auipc	a0,0xe
ffffffffc0202e52:	70a53503          	ld	a0,1802(a0) # ffffffffc0211558 <pages>
ffffffffc0202e56:	953e                	add	a0,a0,a5
ffffffffc0202e58:	0141                	addi	sp,sp,16
ffffffffc0202e5a:	8082                	ret
ffffffffc0202e5c:	c71ff0ef          	jal	ra,ffffffffc0202acc <pa2page.part.0>

ffffffffc0202e60 <page_remove>:
    }
}

// page_remove - free an Page which is related linear address la and has an
// validated pte
void page_remove(pde_t *pgdir, uintptr_t la) {
ffffffffc0202e60:	1101                	addi	sp,sp,-32
    pte_t *ptep = get_pte(pgdir, la, 0);
ffffffffc0202e62:	4601                	li	a2,0
void page_remove(pde_t *pgdir, uintptr_t la) {
ffffffffc0202e64:	ec06                	sd	ra,24(sp)
ffffffffc0202e66:	e822                	sd	s0,16(sp)
    pte_t *ptep = get_pte(pgdir, la, 0);
ffffffffc0202e68:	da9ff0ef          	jal	ra,ffffffffc0202c10 <get_pte>
    if (ptep != NULL) {
ffffffffc0202e6c:	c511                	beqz	a0,ffffffffc0202e78 <page_remove+0x18>
    if (*ptep & PTE_V) {  //(1) check if this page table entry is
ffffffffc0202e6e:	611c                	ld	a5,0(a0)
ffffffffc0202e70:	842a                	mv	s0,a0
ffffffffc0202e72:	0017f713          	andi	a4,a5,1
ffffffffc0202e76:	e709                	bnez	a4,ffffffffc0202e80 <page_remove+0x20>
        page_remove_pte(pgdir, la, ptep);
    }
}
ffffffffc0202e78:	60e2                	ld	ra,24(sp)
ffffffffc0202e7a:	6442                	ld	s0,16(sp)
ffffffffc0202e7c:	6105                	addi	sp,sp,32
ffffffffc0202e7e:	8082                	ret
    return pa2page(PTE_ADDR(pte));
ffffffffc0202e80:	078a                	slli	a5,a5,0x2
ffffffffc0202e82:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage) {
ffffffffc0202e84:	0000e717          	auipc	a4,0xe
ffffffffc0202e88:	6cc73703          	ld	a4,1740(a4) # ffffffffc0211550 <npage>
ffffffffc0202e8c:	06e7f563          	bgeu	a5,a4,ffffffffc0202ef6 <page_remove+0x96>
    return &pages[PPN(pa) - nbase];
ffffffffc0202e90:	fff80737          	lui	a4,0xfff80
ffffffffc0202e94:	97ba                	add	a5,a5,a4
ffffffffc0202e96:	00379513          	slli	a0,a5,0x3
ffffffffc0202e9a:	97aa                	add	a5,a5,a0
ffffffffc0202e9c:	078e                	slli	a5,a5,0x3
ffffffffc0202e9e:	0000e517          	auipc	a0,0xe
ffffffffc0202ea2:	6ba53503          	ld	a0,1722(a0) # ffffffffc0211558 <pages>
ffffffffc0202ea6:	953e                	add	a0,a0,a5
    page->ref -= 1;
ffffffffc0202ea8:	411c                	lw	a5,0(a0)
ffffffffc0202eaa:	fff7871b          	addiw	a4,a5,-1
ffffffffc0202eae:	c118                	sw	a4,0(a0)
        if (page_ref(page) ==
ffffffffc0202eb0:	cb09                	beqz	a4,ffffffffc0202ec2 <page_remove+0x62>
        *ptep = 0;                  //(5) clear second page table entry
ffffffffc0202eb2:	00043023          	sd	zero,0(s0)
static inline void flush_tlb() { asm volatile("sfence.vma"); }
ffffffffc0202eb6:	12000073          	sfence.vma
}
ffffffffc0202eba:	60e2                	ld	ra,24(sp)
ffffffffc0202ebc:	6442                	ld	s0,16(sp)
ffffffffc0202ebe:	6105                	addi	sp,sp,32
ffffffffc0202ec0:	8082                	ret
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0202ec2:	100027f3          	csrr	a5,sstatus
ffffffffc0202ec6:	8b89                	andi	a5,a5,2
ffffffffc0202ec8:	eb89                	bnez	a5,ffffffffc0202eda <page_remove+0x7a>
    { pmm_manager->free_pages(base, n); }
ffffffffc0202eca:	0000e797          	auipc	a5,0xe
ffffffffc0202ece:	6967b783          	ld	a5,1686(a5) # ffffffffc0211560 <pmm_manager>
ffffffffc0202ed2:	739c                	ld	a5,32(a5)
ffffffffc0202ed4:	4585                	li	a1,1
ffffffffc0202ed6:	9782                	jalr	a5
    if (flag) {
ffffffffc0202ed8:	bfe9                	j	ffffffffc0202eb2 <page_remove+0x52>
        intr_disable();
ffffffffc0202eda:	e42a                	sd	a0,8(sp)
ffffffffc0202edc:	e12fd0ef          	jal	ra,ffffffffc02004ee <intr_disable>
ffffffffc0202ee0:	0000e797          	auipc	a5,0xe
ffffffffc0202ee4:	6807b783          	ld	a5,1664(a5) # ffffffffc0211560 <pmm_manager>
ffffffffc0202ee8:	739c                	ld	a5,32(a5)
ffffffffc0202eea:	6522                	ld	a0,8(sp)
ffffffffc0202eec:	4585                	li	a1,1
ffffffffc0202eee:	9782                	jalr	a5
        intr_enable();
ffffffffc0202ef0:	df8fd0ef          	jal	ra,ffffffffc02004e8 <intr_enable>
ffffffffc0202ef4:	bf7d                	j	ffffffffc0202eb2 <page_remove+0x52>
ffffffffc0202ef6:	bd7ff0ef          	jal	ra,ffffffffc0202acc <pa2page.part.0>

ffffffffc0202efa <page_insert>:
//  page:  the Page which need to map
//  la:    the linear address need to map
//  perm:  the permission of this Page which is setted in related pte
// return value: always 0
// note: PT is changed, so the TLB need to be invalidate
int page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
ffffffffc0202efa:	7179                	addi	sp,sp,-48
ffffffffc0202efc:	87b2                	mv	a5,a2
ffffffffc0202efe:	f022                	sd	s0,32(sp)
    pte_t *ptep = get_pte(pgdir, la, 1);
ffffffffc0202f00:	4605                	li	a2,1
int page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
ffffffffc0202f02:	842e                	mv	s0,a1
    pte_t *ptep = get_pte(pgdir, la, 1);
ffffffffc0202f04:	85be                	mv	a1,a5
int page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
ffffffffc0202f06:	ec26                	sd	s1,24(sp)
ffffffffc0202f08:	f406                	sd	ra,40(sp)
ffffffffc0202f0a:	e84a                	sd	s2,16(sp)
ffffffffc0202f0c:	e44e                	sd	s3,8(sp)
ffffffffc0202f0e:	e052                	sd	s4,0(sp)
ffffffffc0202f10:	84b6                	mv	s1,a3
    pte_t *ptep = get_pte(pgdir, la, 1);
ffffffffc0202f12:	cffff0ef          	jal	ra,ffffffffc0202c10 <get_pte>
    if (ptep == NULL) {
ffffffffc0202f16:	cd71                	beqz	a0,ffffffffc0202ff2 <page_insert+0xf8>
    page->ref += 1;
ffffffffc0202f18:	4014                	lw	a3,0(s0)
        return -E_NO_MEM;
    }
    page_ref_inc(page);
    if (*ptep & PTE_V) {
ffffffffc0202f1a:	611c                	ld	a5,0(a0)
ffffffffc0202f1c:	89aa                	mv	s3,a0
ffffffffc0202f1e:	0016871b          	addiw	a4,a3,1
ffffffffc0202f22:	c018                	sw	a4,0(s0)
ffffffffc0202f24:	0017f713          	andi	a4,a5,1
ffffffffc0202f28:	e331                	bnez	a4,ffffffffc0202f6c <page_insert+0x72>
static inline ppn_t page2ppn(struct Page *page) { return page - pages + nbase; }
ffffffffc0202f2a:	0000e797          	auipc	a5,0xe
ffffffffc0202f2e:	62e7b783          	ld	a5,1582(a5) # ffffffffc0211558 <pages>
ffffffffc0202f32:	40f407b3          	sub	a5,s0,a5
ffffffffc0202f36:	878d                	srai	a5,a5,0x3
ffffffffc0202f38:	00003417          	auipc	s0,0x3
ffffffffc0202f3c:	44843403          	ld	s0,1096(s0) # ffffffffc0206380 <error_string+0x38>
ffffffffc0202f40:	028787b3          	mul	a5,a5,s0
ffffffffc0202f44:	00080437          	lui	s0,0x80
ffffffffc0202f48:	97a2                	add	a5,a5,s0
    return (ppn << PTE_PPN_SHIFT) | PTE_V | type;
ffffffffc0202f4a:	07aa                	slli	a5,a5,0xa
ffffffffc0202f4c:	8cdd                	or	s1,s1,a5
ffffffffc0202f4e:	0014e493          	ori	s1,s1,1
            page_ref_dec(page);
        } else {
            page_remove_pte(pgdir, la, ptep);
        }
    }
    *ptep = pte_create(page2ppn(page), PTE_V | perm);
ffffffffc0202f52:	0099b023          	sd	s1,0(s3)
static inline void flush_tlb() { asm volatile("sfence.vma"); }
ffffffffc0202f56:	12000073          	sfence.vma
    tlb_invalidate(pgdir, la);
    return 0;
ffffffffc0202f5a:	4501                	li	a0,0
}
ffffffffc0202f5c:	70a2                	ld	ra,40(sp)
ffffffffc0202f5e:	7402                	ld	s0,32(sp)
ffffffffc0202f60:	64e2                	ld	s1,24(sp)
ffffffffc0202f62:	6942                	ld	s2,16(sp)
ffffffffc0202f64:	69a2                	ld	s3,8(sp)
ffffffffc0202f66:	6a02                	ld	s4,0(sp)
ffffffffc0202f68:	6145                	addi	sp,sp,48
ffffffffc0202f6a:	8082                	ret
    return pa2page(PTE_ADDR(pte));
ffffffffc0202f6c:	00279713          	slli	a4,a5,0x2
ffffffffc0202f70:	8331                	srli	a4,a4,0xc
    if (PPN(pa) >= npage) {
ffffffffc0202f72:	0000e797          	auipc	a5,0xe
ffffffffc0202f76:	5de7b783          	ld	a5,1502(a5) # ffffffffc0211550 <npage>
ffffffffc0202f7a:	06f77e63          	bgeu	a4,a5,ffffffffc0202ff6 <page_insert+0xfc>
    return &pages[PPN(pa) - nbase];
ffffffffc0202f7e:	fff807b7          	lui	a5,0xfff80
ffffffffc0202f82:	973e                	add	a4,a4,a5
ffffffffc0202f84:	0000ea17          	auipc	s4,0xe
ffffffffc0202f88:	5d4a0a13          	addi	s4,s4,1492 # ffffffffc0211558 <pages>
ffffffffc0202f8c:	000a3783          	ld	a5,0(s4)
ffffffffc0202f90:	00371913          	slli	s2,a4,0x3
ffffffffc0202f94:	993a                	add	s2,s2,a4
ffffffffc0202f96:	090e                	slli	s2,s2,0x3
ffffffffc0202f98:	993e                	add	s2,s2,a5
        if (p == page) {
ffffffffc0202f9a:	03240063          	beq	s0,s2,ffffffffc0202fba <page_insert+0xc0>
    page->ref -= 1;
ffffffffc0202f9e:	00092783          	lw	a5,0(s2)
ffffffffc0202fa2:	fff7871b          	addiw	a4,a5,-1
ffffffffc0202fa6:	00e92023          	sw	a4,0(s2)
        if (page_ref(page) ==
ffffffffc0202faa:	cb11                	beqz	a4,ffffffffc0202fbe <page_insert+0xc4>
        *ptep = 0;                  //(5) clear second page table entry
ffffffffc0202fac:	0009b023          	sd	zero,0(s3)
static inline void flush_tlb() { asm volatile("sfence.vma"); }
ffffffffc0202fb0:	12000073          	sfence.vma
static inline ppn_t page2ppn(struct Page *page) { return page - pages + nbase; }
ffffffffc0202fb4:	000a3783          	ld	a5,0(s4)
}
ffffffffc0202fb8:	bfad                	j	ffffffffc0202f32 <page_insert+0x38>
    page->ref -= 1;
ffffffffc0202fba:	c014                	sw	a3,0(s0)
    return page->ref;
ffffffffc0202fbc:	bf9d                	j	ffffffffc0202f32 <page_insert+0x38>
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0202fbe:	100027f3          	csrr	a5,sstatus
ffffffffc0202fc2:	8b89                	andi	a5,a5,2
ffffffffc0202fc4:	eb91                	bnez	a5,ffffffffc0202fd8 <page_insert+0xde>
    { pmm_manager->free_pages(base, n); }
ffffffffc0202fc6:	0000e797          	auipc	a5,0xe
ffffffffc0202fca:	59a7b783          	ld	a5,1434(a5) # ffffffffc0211560 <pmm_manager>
ffffffffc0202fce:	739c                	ld	a5,32(a5)
ffffffffc0202fd0:	4585                	li	a1,1
ffffffffc0202fd2:	854a                	mv	a0,s2
ffffffffc0202fd4:	9782                	jalr	a5
    if (flag) {
ffffffffc0202fd6:	bfd9                	j	ffffffffc0202fac <page_insert+0xb2>
        intr_disable();
ffffffffc0202fd8:	d16fd0ef          	jal	ra,ffffffffc02004ee <intr_disable>
ffffffffc0202fdc:	0000e797          	auipc	a5,0xe
ffffffffc0202fe0:	5847b783          	ld	a5,1412(a5) # ffffffffc0211560 <pmm_manager>
ffffffffc0202fe4:	739c                	ld	a5,32(a5)
ffffffffc0202fe6:	4585                	li	a1,1
ffffffffc0202fe8:	854a                	mv	a0,s2
ffffffffc0202fea:	9782                	jalr	a5
        intr_enable();
ffffffffc0202fec:	cfcfd0ef          	jal	ra,ffffffffc02004e8 <intr_enable>
ffffffffc0202ff0:	bf75                	j	ffffffffc0202fac <page_insert+0xb2>
        return -E_NO_MEM;
ffffffffc0202ff2:	5571                	li	a0,-4
ffffffffc0202ff4:	b7a5                	j	ffffffffc0202f5c <page_insert+0x62>
ffffffffc0202ff6:	ad7ff0ef          	jal	ra,ffffffffc0202acc <pa2page.part.0>

ffffffffc0202ffa <pmm_init>:
    pmm_manager = &default_pmm_manager;
ffffffffc0202ffa:	00003797          	auipc	a5,0x3
ffffffffc0202ffe:	98678793          	addi	a5,a5,-1658 # ffffffffc0205980 <default_pmm_manager>
    cprintf("memory management: %s\n", pmm_manager->name);
ffffffffc0203002:	638c                	ld	a1,0(a5)
void pmm_init(void) {
ffffffffc0203004:	7159                	addi	sp,sp,-112
ffffffffc0203006:	f45e                	sd	s7,40(sp)
    cprintf("memory management: %s\n", pmm_manager->name);
ffffffffc0203008:	00003517          	auipc	a0,0x3
ffffffffc020300c:	b1850513          	addi	a0,a0,-1256 # ffffffffc0205b20 <default_pmm_manager+0x1a0>
    pmm_manager = &default_pmm_manager;
ffffffffc0203010:	0000eb97          	auipc	s7,0xe
ffffffffc0203014:	550b8b93          	addi	s7,s7,1360 # ffffffffc0211560 <pmm_manager>
void pmm_init(void) {
ffffffffc0203018:	f486                	sd	ra,104(sp)
ffffffffc020301a:	f0a2                	sd	s0,96(sp)
ffffffffc020301c:	eca6                	sd	s1,88(sp)
ffffffffc020301e:	e8ca                	sd	s2,80(sp)
ffffffffc0203020:	e4ce                	sd	s3,72(sp)
ffffffffc0203022:	f85a                	sd	s6,48(sp)
    pmm_manager = &default_pmm_manager;
ffffffffc0203024:	00fbb023          	sd	a5,0(s7)
void pmm_init(void) {
ffffffffc0203028:	e0d2                	sd	s4,64(sp)
ffffffffc020302a:	fc56                	sd	s5,56(sp)
ffffffffc020302c:	f062                	sd	s8,32(sp)
ffffffffc020302e:	ec66                	sd	s9,24(sp)
ffffffffc0203030:	e86a                	sd	s10,16(sp)
    cprintf("memory management: %s\n", pmm_manager->name);
ffffffffc0203032:	888fd0ef          	jal	ra,ffffffffc02000ba <cprintf>
    pmm_manager->init();
ffffffffc0203036:	000bb783          	ld	a5,0(s7)
    cprintf("membegin %llx memend %llx mem_size %llx\n",mem_begin, mem_end, mem_size);
ffffffffc020303a:	4445                	li	s0,17
ffffffffc020303c:	40100913          	li	s2,1025
    pmm_manager->init();
ffffffffc0203040:	679c                	ld	a5,8(a5)
    va_pa_offset = KERNBASE - 0x80200000;
ffffffffc0203042:	0000e997          	auipc	s3,0xe
ffffffffc0203046:	52698993          	addi	s3,s3,1318 # ffffffffc0211568 <va_pa_offset>
    npage = maxpa / PGSIZE;
ffffffffc020304a:	0000e497          	auipc	s1,0xe
ffffffffc020304e:	50648493          	addi	s1,s1,1286 # ffffffffc0211550 <npage>
    pmm_manager->init();
ffffffffc0203052:	9782                	jalr	a5
    va_pa_offset = KERNBASE - 0x80200000;
ffffffffc0203054:	57f5                	li	a5,-3
ffffffffc0203056:	07fa                	slli	a5,a5,0x1e
    cprintf("membegin %llx memend %llx mem_size %llx\n",mem_begin, mem_end, mem_size);
ffffffffc0203058:	07e006b7          	lui	a3,0x7e00
ffffffffc020305c:	01b41613          	slli	a2,s0,0x1b
ffffffffc0203060:	01591593          	slli	a1,s2,0x15
ffffffffc0203064:	00003517          	auipc	a0,0x3
ffffffffc0203068:	ad450513          	addi	a0,a0,-1324 # ffffffffc0205b38 <default_pmm_manager+0x1b8>
    va_pa_offset = KERNBASE - 0x80200000;
ffffffffc020306c:	00f9b023          	sd	a5,0(s3)
    cprintf("membegin %llx memend %llx mem_size %llx\n",mem_begin, mem_end, mem_size);
ffffffffc0203070:	84afd0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("physcial memory map:\n");
ffffffffc0203074:	00003517          	auipc	a0,0x3
ffffffffc0203078:	af450513          	addi	a0,a0,-1292 # ffffffffc0205b68 <default_pmm_manager+0x1e8>
ffffffffc020307c:	83efd0ef          	jal	ra,ffffffffc02000ba <cprintf>
    cprintf("  memory: 0x%08lx, [0x%08lx, 0x%08lx].\n", mem_size, mem_begin,
ffffffffc0203080:	01b41693          	slli	a3,s0,0x1b
ffffffffc0203084:	16fd                	addi	a3,a3,-1
ffffffffc0203086:	07e005b7          	lui	a1,0x7e00
ffffffffc020308a:	01591613          	slli	a2,s2,0x15
ffffffffc020308e:	00003517          	auipc	a0,0x3
ffffffffc0203092:	af250513          	addi	a0,a0,-1294 # ffffffffc0205b80 <default_pmm_manager+0x200>
ffffffffc0203096:	824fd0ef          	jal	ra,ffffffffc02000ba <cprintf>
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
ffffffffc020309a:	777d                	lui	a4,0xfffff
ffffffffc020309c:	0000f797          	auipc	a5,0xf
ffffffffc02030a0:	4d378793          	addi	a5,a5,1235 # ffffffffc021256f <end+0xfff>
ffffffffc02030a4:	8ff9                	and	a5,a5,a4
ffffffffc02030a6:	0000eb17          	auipc	s6,0xe
ffffffffc02030aa:	4b2b0b13          	addi	s6,s6,1202 # ffffffffc0211558 <pages>
    npage = maxpa / PGSIZE;
ffffffffc02030ae:	00088737          	lui	a4,0x88
ffffffffc02030b2:	e098                	sd	a4,0(s1)
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
ffffffffc02030b4:	00fb3023          	sd	a5,0(s6)
ffffffffc02030b8:	4681                	li	a3,0
    for (size_t i = 0; i < npage - nbase; i++) {
ffffffffc02030ba:	4701                	li	a4,0
ffffffffc02030bc:	4505                	li	a0,1
ffffffffc02030be:	fff805b7          	lui	a1,0xfff80
ffffffffc02030c2:	a019                	j	ffffffffc02030c8 <pmm_init+0xce>
        SetPageReserved(pages + i);
ffffffffc02030c4:	000b3783          	ld	a5,0(s6)
ffffffffc02030c8:	97b6                	add	a5,a5,a3
ffffffffc02030ca:	07a1                	addi	a5,a5,8
ffffffffc02030cc:	40a7b02f          	amoor.d	zero,a0,(a5)
    for (size_t i = 0; i < npage - nbase; i++) {
ffffffffc02030d0:	609c                	ld	a5,0(s1)
ffffffffc02030d2:	0705                	addi	a4,a4,1
ffffffffc02030d4:	04868693          	addi	a3,a3,72 # 7e00048 <kern_entry-0xffffffffb83fffb8>
ffffffffc02030d8:	00b78633          	add	a2,a5,a1
ffffffffc02030dc:	fec764e3          	bltu	a4,a2,ffffffffc02030c4 <pmm_init+0xca>
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc02030e0:	000b3503          	ld	a0,0(s6)
ffffffffc02030e4:	00379693          	slli	a3,a5,0x3
ffffffffc02030e8:	96be                	add	a3,a3,a5
ffffffffc02030ea:	fdc00737          	lui	a4,0xfdc00
ffffffffc02030ee:	972a                	add	a4,a4,a0
ffffffffc02030f0:	068e                	slli	a3,a3,0x3
ffffffffc02030f2:	96ba                	add	a3,a3,a4
ffffffffc02030f4:	c0200737          	lui	a4,0xc0200
ffffffffc02030f8:	64e6e463          	bltu	a3,a4,ffffffffc0203740 <pmm_init+0x746>
ffffffffc02030fc:	0009b703          	ld	a4,0(s3)
    if (freemem < mem_end) {
ffffffffc0203100:	4645                	li	a2,17
ffffffffc0203102:	066e                	slli	a2,a2,0x1b
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc0203104:	8e99                	sub	a3,a3,a4
    if (freemem < mem_end) {
ffffffffc0203106:	4ec6e263          	bltu	a3,a2,ffffffffc02035ea <pmm_init+0x5f0>

    return page;
}

static void check_alloc_page(void) {
    pmm_manager->check();
ffffffffc020310a:	000bb783          	ld	a5,0(s7)
    boot_pgdir = (pte_t*)boot_page_table_sv39;
ffffffffc020310e:	0000e917          	auipc	s2,0xe
ffffffffc0203112:	43a90913          	addi	s2,s2,1082 # ffffffffc0211548 <boot_pgdir>
    pmm_manager->check();
ffffffffc0203116:	7b9c                	ld	a5,48(a5)
ffffffffc0203118:	9782                	jalr	a5
    cprintf("check_alloc_page() succeeded!\n");
ffffffffc020311a:	00003517          	auipc	a0,0x3
ffffffffc020311e:	ab650513          	addi	a0,a0,-1354 # ffffffffc0205bd0 <default_pmm_manager+0x250>
ffffffffc0203122:	f99fc0ef          	jal	ra,ffffffffc02000ba <cprintf>
    boot_pgdir = (pte_t*)boot_page_table_sv39;
ffffffffc0203126:	00006697          	auipc	a3,0x6
ffffffffc020312a:	eda68693          	addi	a3,a3,-294 # ffffffffc0209000 <boot_page_table_sv39>
ffffffffc020312e:	00d93023          	sd	a3,0(s2)
    boot_cr3 = PADDR(boot_pgdir);
ffffffffc0203132:	c02007b7          	lui	a5,0xc0200
ffffffffc0203136:	62f6e163          	bltu	a3,a5,ffffffffc0203758 <pmm_init+0x75e>
ffffffffc020313a:	0009b783          	ld	a5,0(s3)
ffffffffc020313e:	8e9d                	sub	a3,a3,a5
ffffffffc0203140:	0000e797          	auipc	a5,0xe
ffffffffc0203144:	40d7b023          	sd	a3,1024(a5) # ffffffffc0211540 <boot_cr3>
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0203148:	100027f3          	csrr	a5,sstatus
ffffffffc020314c:	8b89                	andi	a5,a5,2
ffffffffc020314e:	4c079763          	bnez	a5,ffffffffc020361c <pmm_init+0x622>
    { ret = pmm_manager->nr_free_pages(); }
ffffffffc0203152:	000bb783          	ld	a5,0(s7)
ffffffffc0203156:	779c                	ld	a5,40(a5)
ffffffffc0203158:	9782                	jalr	a5
ffffffffc020315a:	842a                	mv	s0,a0
    // so npage is always larger than KMEMSIZE / PGSIZE
    size_t nr_free_store;

    nr_free_store=nr_free_pages();

    assert(npage <= KERNTOP / PGSIZE);
ffffffffc020315c:	6098                	ld	a4,0(s1)
ffffffffc020315e:	c80007b7          	lui	a5,0xc8000
ffffffffc0203162:	83b1                	srli	a5,a5,0xc
ffffffffc0203164:	62e7e663          	bltu	a5,a4,ffffffffc0203790 <pmm_init+0x796>
    assert(boot_pgdir != NULL && (uint32_t)PGOFF(boot_pgdir) == 0);
ffffffffc0203168:	00093503          	ld	a0,0(s2)
ffffffffc020316c:	60050263          	beqz	a0,ffffffffc0203770 <pmm_init+0x776>
ffffffffc0203170:	03451793          	slli	a5,a0,0x34
ffffffffc0203174:	5e079e63          	bnez	a5,ffffffffc0203770 <pmm_init+0x776>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
ffffffffc0203178:	4601                	li	a2,0
ffffffffc020317a:	4581                	li	a1,0
ffffffffc020317c:	c8bff0ef          	jal	ra,ffffffffc0202e06 <get_page>
ffffffffc0203180:	66051a63          	bnez	a0,ffffffffc02037f4 <pmm_init+0x7fa>

    struct Page *p1, *p2;
    p1 = alloc_page();
ffffffffc0203184:	4505                	li	a0,1
ffffffffc0203186:	97fff0ef          	jal	ra,ffffffffc0202b04 <alloc_pages>
ffffffffc020318a:	8a2a                	mv	s4,a0
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
ffffffffc020318c:	00093503          	ld	a0,0(s2)
ffffffffc0203190:	4681                	li	a3,0
ffffffffc0203192:	4601                	li	a2,0
ffffffffc0203194:	85d2                	mv	a1,s4
ffffffffc0203196:	d65ff0ef          	jal	ra,ffffffffc0202efa <page_insert>
ffffffffc020319a:	62051d63          	bnez	a0,ffffffffc02037d4 <pmm_init+0x7da>
    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
ffffffffc020319e:	00093503          	ld	a0,0(s2)
ffffffffc02031a2:	4601                	li	a2,0
ffffffffc02031a4:	4581                	li	a1,0
ffffffffc02031a6:	a6bff0ef          	jal	ra,ffffffffc0202c10 <get_pte>
ffffffffc02031aa:	60050563          	beqz	a0,ffffffffc02037b4 <pmm_init+0x7ba>
    assert(pte2page(*ptep) == p1);
ffffffffc02031ae:	611c                	ld	a5,0(a0)
    if (!(pte & PTE_V)) {
ffffffffc02031b0:	0017f713          	andi	a4,a5,1
ffffffffc02031b4:	5e070e63          	beqz	a4,ffffffffc02037b0 <pmm_init+0x7b6>
    if (PPN(pa) >= npage) {
ffffffffc02031b8:	6090                	ld	a2,0(s1)
    return pa2page(PTE_ADDR(pte));
ffffffffc02031ba:	078a                	slli	a5,a5,0x2
ffffffffc02031bc:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage) {
ffffffffc02031be:	56c7ff63          	bgeu	a5,a2,ffffffffc020373c <pmm_init+0x742>
    return &pages[PPN(pa) - nbase];
ffffffffc02031c2:	fff80737          	lui	a4,0xfff80
ffffffffc02031c6:	97ba                	add	a5,a5,a4
ffffffffc02031c8:	000b3683          	ld	a3,0(s6)
ffffffffc02031cc:	00379713          	slli	a4,a5,0x3
ffffffffc02031d0:	97ba                	add	a5,a5,a4
ffffffffc02031d2:	078e                	slli	a5,a5,0x3
ffffffffc02031d4:	97b6                	add	a5,a5,a3
ffffffffc02031d6:	14fa18e3          	bne	s4,a5,ffffffffc0203b26 <pmm_init+0xb2c>
    assert(page_ref(p1) == 1);
ffffffffc02031da:	000a2703          	lw	a4,0(s4)
ffffffffc02031de:	4785                	li	a5,1
ffffffffc02031e0:	16f71fe3          	bne	a4,a5,ffffffffc0203b5e <pmm_init+0xb64>

    ptep = (pte_t *)KADDR(PDE_ADDR(boot_pgdir[0]));
ffffffffc02031e4:	00093503          	ld	a0,0(s2)
ffffffffc02031e8:	77fd                	lui	a5,0xfffff
ffffffffc02031ea:	6114                	ld	a3,0(a0)
ffffffffc02031ec:	068a                	slli	a3,a3,0x2
ffffffffc02031ee:	8efd                	and	a3,a3,a5
ffffffffc02031f0:	00c6d713          	srli	a4,a3,0xc
ffffffffc02031f4:	14c779e3          	bgeu	a4,a2,ffffffffc0203b46 <pmm_init+0xb4c>
ffffffffc02031f8:	0009bc03          	ld	s8,0(s3)
    ptep = (pte_t *)KADDR(PDE_ADDR(ptep[0])) + 1;
ffffffffc02031fc:	96e2                	add	a3,a3,s8
ffffffffc02031fe:	0006ba83          	ld	s5,0(a3)
ffffffffc0203202:	0a8a                	slli	s5,s5,0x2
ffffffffc0203204:	00fafab3          	and	s5,s5,a5
ffffffffc0203208:	00cad793          	srli	a5,s5,0xc
ffffffffc020320c:	66c7f463          	bgeu	a5,a2,ffffffffc0203874 <pmm_init+0x87a>
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
ffffffffc0203210:	4601                	li	a2,0
ffffffffc0203212:	6585                	lui	a1,0x1
    ptep = (pte_t *)KADDR(PDE_ADDR(ptep[0])) + 1;
ffffffffc0203214:	9ae2                	add	s5,s5,s8
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
ffffffffc0203216:	9fbff0ef          	jal	ra,ffffffffc0202c10 <get_pte>
    ptep = (pte_t *)KADDR(PDE_ADDR(ptep[0])) + 1;
ffffffffc020321a:	0aa1                	addi	s5,s5,8
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
ffffffffc020321c:	63551c63          	bne	a0,s5,ffffffffc0203854 <pmm_init+0x85a>

    p2 = alloc_page();
ffffffffc0203220:	4505                	li	a0,1
ffffffffc0203222:	8e3ff0ef          	jal	ra,ffffffffc0202b04 <alloc_pages>
ffffffffc0203226:	8aaa                	mv	s5,a0
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
ffffffffc0203228:	00093503          	ld	a0,0(s2)
ffffffffc020322c:	46d1                	li	a3,20
ffffffffc020322e:	6605                	lui	a2,0x1
ffffffffc0203230:	85d6                	mv	a1,s5
ffffffffc0203232:	cc9ff0ef          	jal	ra,ffffffffc0202efa <page_insert>
ffffffffc0203236:	5c051f63          	bnez	a0,ffffffffc0203814 <pmm_init+0x81a>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
ffffffffc020323a:	00093503          	ld	a0,0(s2)
ffffffffc020323e:	4601                	li	a2,0
ffffffffc0203240:	6585                	lui	a1,0x1
ffffffffc0203242:	9cfff0ef          	jal	ra,ffffffffc0202c10 <get_pte>
ffffffffc0203246:	12050ce3          	beqz	a0,ffffffffc0203b7e <pmm_init+0xb84>
    assert(*ptep & PTE_U);
ffffffffc020324a:	611c                	ld	a5,0(a0)
ffffffffc020324c:	0107f713          	andi	a4,a5,16
ffffffffc0203250:	72070f63          	beqz	a4,ffffffffc020398e <pmm_init+0x994>
    assert(*ptep & PTE_W);
ffffffffc0203254:	8b91                	andi	a5,a5,4
ffffffffc0203256:	6e078c63          	beqz	a5,ffffffffc020394e <pmm_init+0x954>
    assert(boot_pgdir[0] & PTE_U);
ffffffffc020325a:	00093503          	ld	a0,0(s2)
ffffffffc020325e:	611c                	ld	a5,0(a0)
ffffffffc0203260:	8bc1                	andi	a5,a5,16
ffffffffc0203262:	6c078663          	beqz	a5,ffffffffc020392e <pmm_init+0x934>
    assert(page_ref(p2) == 1);
ffffffffc0203266:	000aa703          	lw	a4,0(s5)
ffffffffc020326a:	4785                	li	a5,1
ffffffffc020326c:	5cf71463          	bne	a4,a5,ffffffffc0203834 <pmm_init+0x83a>

    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
ffffffffc0203270:	4681                	li	a3,0
ffffffffc0203272:	6605                	lui	a2,0x1
ffffffffc0203274:	85d2                	mv	a1,s4
ffffffffc0203276:	c85ff0ef          	jal	ra,ffffffffc0202efa <page_insert>
ffffffffc020327a:	66051a63          	bnez	a0,ffffffffc02038ee <pmm_init+0x8f4>
    assert(page_ref(p1) == 2);
ffffffffc020327e:	000a2703          	lw	a4,0(s4)
ffffffffc0203282:	4789                	li	a5,2
ffffffffc0203284:	64f71563          	bne	a4,a5,ffffffffc02038ce <pmm_init+0x8d4>
    assert(page_ref(p2) == 0);
ffffffffc0203288:	000aa783          	lw	a5,0(s5)
ffffffffc020328c:	62079163          	bnez	a5,ffffffffc02038ae <pmm_init+0x8b4>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
ffffffffc0203290:	00093503          	ld	a0,0(s2)
ffffffffc0203294:	4601                	li	a2,0
ffffffffc0203296:	6585                	lui	a1,0x1
ffffffffc0203298:	979ff0ef          	jal	ra,ffffffffc0202c10 <get_pte>
ffffffffc020329c:	5e050963          	beqz	a0,ffffffffc020388e <pmm_init+0x894>
    assert(pte2page(*ptep) == p1);
ffffffffc02032a0:	6118                	ld	a4,0(a0)
    if (!(pte & PTE_V)) {
ffffffffc02032a2:	00177793          	andi	a5,a4,1
ffffffffc02032a6:	50078563          	beqz	a5,ffffffffc02037b0 <pmm_init+0x7b6>
    if (PPN(pa) >= npage) {
ffffffffc02032aa:	6094                	ld	a3,0(s1)
    return pa2page(PTE_ADDR(pte));
ffffffffc02032ac:	00271793          	slli	a5,a4,0x2
ffffffffc02032b0:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage) {
ffffffffc02032b2:	48d7f563          	bgeu	a5,a3,ffffffffc020373c <pmm_init+0x742>
    return &pages[PPN(pa) - nbase];
ffffffffc02032b6:	fff806b7          	lui	a3,0xfff80
ffffffffc02032ba:	97b6                	add	a5,a5,a3
ffffffffc02032bc:	000b3603          	ld	a2,0(s6)
ffffffffc02032c0:	00379693          	slli	a3,a5,0x3
ffffffffc02032c4:	97b6                	add	a5,a5,a3
ffffffffc02032c6:	078e                	slli	a5,a5,0x3
ffffffffc02032c8:	97b2                	add	a5,a5,a2
ffffffffc02032ca:	72fa1263          	bne	s4,a5,ffffffffc02039ee <pmm_init+0x9f4>
    assert((*ptep & PTE_U) == 0);
ffffffffc02032ce:	8b41                	andi	a4,a4,16
ffffffffc02032d0:	6e071f63          	bnez	a4,ffffffffc02039ce <pmm_init+0x9d4>

    page_remove(boot_pgdir, 0x0);
ffffffffc02032d4:	00093503          	ld	a0,0(s2)
ffffffffc02032d8:	4581                	li	a1,0
ffffffffc02032da:	b87ff0ef          	jal	ra,ffffffffc0202e60 <page_remove>
    assert(page_ref(p1) == 1);
ffffffffc02032de:	000a2703          	lw	a4,0(s4)
ffffffffc02032e2:	4785                	li	a5,1
ffffffffc02032e4:	6cf71563          	bne	a4,a5,ffffffffc02039ae <pmm_init+0x9b4>
    assert(page_ref(p2) == 0);
ffffffffc02032e8:	000aa783          	lw	a5,0(s5)
ffffffffc02032ec:	78079d63          	bnez	a5,ffffffffc0203a86 <pmm_init+0xa8c>

    page_remove(boot_pgdir, PGSIZE);
ffffffffc02032f0:	00093503          	ld	a0,0(s2)
ffffffffc02032f4:	6585                	lui	a1,0x1
ffffffffc02032f6:	b6bff0ef          	jal	ra,ffffffffc0202e60 <page_remove>
    assert(page_ref(p1) == 0);
ffffffffc02032fa:	000a2783          	lw	a5,0(s4)
ffffffffc02032fe:	76079463          	bnez	a5,ffffffffc0203a66 <pmm_init+0xa6c>
    assert(page_ref(p2) == 0);
ffffffffc0203302:	000aa783          	lw	a5,0(s5)
ffffffffc0203306:	74079063          	bnez	a5,ffffffffc0203a46 <pmm_init+0xa4c>

    assert(page_ref(pde2page(boot_pgdir[0])) == 1);
ffffffffc020330a:	00093a03          	ld	s4,0(s2)
    if (PPN(pa) >= npage) {
ffffffffc020330e:	6090                	ld	a2,0(s1)
    return pa2page(PDE_ADDR(pde));
ffffffffc0203310:	000a3783          	ld	a5,0(s4)
ffffffffc0203314:	078a                	slli	a5,a5,0x2
ffffffffc0203316:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage) {
ffffffffc0203318:	42c7f263          	bgeu	a5,a2,ffffffffc020373c <pmm_init+0x742>
    return &pages[PPN(pa) - nbase];
ffffffffc020331c:	fff80737          	lui	a4,0xfff80
ffffffffc0203320:	973e                	add	a4,a4,a5
ffffffffc0203322:	00371793          	slli	a5,a4,0x3
ffffffffc0203326:	000b3503          	ld	a0,0(s6)
ffffffffc020332a:	97ba                	add	a5,a5,a4
ffffffffc020332c:	078e                	slli	a5,a5,0x3
static inline int page_ref(struct Page *page) { return page->ref; }
ffffffffc020332e:	00f50733          	add	a4,a0,a5
ffffffffc0203332:	4314                	lw	a3,0(a4)
ffffffffc0203334:	4705                	li	a4,1
ffffffffc0203336:	6ee69863          	bne	a3,a4,ffffffffc0203a26 <pmm_init+0xa2c>
static inline ppn_t page2ppn(struct Page *page) { return page - pages + nbase; }
ffffffffc020333a:	4037d693          	srai	a3,a5,0x3
ffffffffc020333e:	00003c97          	auipc	s9,0x3
ffffffffc0203342:	042cbc83          	ld	s9,66(s9) # ffffffffc0206380 <error_string+0x38>
ffffffffc0203346:	039686b3          	mul	a3,a3,s9
ffffffffc020334a:	000805b7          	lui	a1,0x80
ffffffffc020334e:	96ae                	add	a3,a3,a1
static inline void *page2kva(struct Page *page) { return KADDR(page2pa(page)); }
ffffffffc0203350:	00c69713          	slli	a4,a3,0xc
ffffffffc0203354:	8331                	srli	a4,a4,0xc
    return page2ppn(page) << PGSHIFT;
ffffffffc0203356:	06b2                	slli	a3,a3,0xc
static inline void *page2kva(struct Page *page) { return KADDR(page2pa(page)); }
ffffffffc0203358:	6ac77b63          	bgeu	a4,a2,ffffffffc0203a0e <pmm_init+0xa14>

    pde_t *pd1=boot_pgdir,*pd0=page2kva(pde2page(boot_pgdir[0]));
    free_page(pde2page(pd0[0]));
ffffffffc020335c:	0009b703          	ld	a4,0(s3)
ffffffffc0203360:	96ba                	add	a3,a3,a4
    return pa2page(PDE_ADDR(pde));
ffffffffc0203362:	629c                	ld	a5,0(a3)
ffffffffc0203364:	078a                	slli	a5,a5,0x2
ffffffffc0203366:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage) {
ffffffffc0203368:	3cc7fa63          	bgeu	a5,a2,ffffffffc020373c <pmm_init+0x742>
    return &pages[PPN(pa) - nbase];
ffffffffc020336c:	8f8d                	sub	a5,a5,a1
ffffffffc020336e:	00379713          	slli	a4,a5,0x3
ffffffffc0203372:	97ba                	add	a5,a5,a4
ffffffffc0203374:	078e                	slli	a5,a5,0x3
ffffffffc0203376:	953e                	add	a0,a0,a5
ffffffffc0203378:	100027f3          	csrr	a5,sstatus
ffffffffc020337c:	8b89                	andi	a5,a5,2
ffffffffc020337e:	2e079963          	bnez	a5,ffffffffc0203670 <pmm_init+0x676>
    { pmm_manager->free_pages(base, n); }
ffffffffc0203382:	000bb783          	ld	a5,0(s7)
ffffffffc0203386:	4585                	li	a1,1
ffffffffc0203388:	739c                	ld	a5,32(a5)
ffffffffc020338a:	9782                	jalr	a5
    return pa2page(PDE_ADDR(pde));
ffffffffc020338c:	000a3783          	ld	a5,0(s4)
    if (PPN(pa) >= npage) {
ffffffffc0203390:	6098                	ld	a4,0(s1)
    return pa2page(PDE_ADDR(pde));
ffffffffc0203392:	078a                	slli	a5,a5,0x2
ffffffffc0203394:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage) {
ffffffffc0203396:	3ae7f363          	bgeu	a5,a4,ffffffffc020373c <pmm_init+0x742>
    return &pages[PPN(pa) - nbase];
ffffffffc020339a:	fff80737          	lui	a4,0xfff80
ffffffffc020339e:	97ba                	add	a5,a5,a4
ffffffffc02033a0:	000b3503          	ld	a0,0(s6)
ffffffffc02033a4:	00379713          	slli	a4,a5,0x3
ffffffffc02033a8:	97ba                	add	a5,a5,a4
ffffffffc02033aa:	078e                	slli	a5,a5,0x3
ffffffffc02033ac:	953e                	add	a0,a0,a5
ffffffffc02033ae:	100027f3          	csrr	a5,sstatus
ffffffffc02033b2:	8b89                	andi	a5,a5,2
ffffffffc02033b4:	2a079263          	bnez	a5,ffffffffc0203658 <pmm_init+0x65e>
ffffffffc02033b8:	000bb783          	ld	a5,0(s7)
ffffffffc02033bc:	4585                	li	a1,1
ffffffffc02033be:	739c                	ld	a5,32(a5)
ffffffffc02033c0:	9782                	jalr	a5
    free_page(pde2page(pd1[0]));
    boot_pgdir[0] = 0;
ffffffffc02033c2:	00093783          	ld	a5,0(s2)
ffffffffc02033c6:	0007b023          	sd	zero,0(a5) # fffffffffffff000 <end+0x3fdeda90>
ffffffffc02033ca:	100027f3          	csrr	a5,sstatus
ffffffffc02033ce:	8b89                	andi	a5,a5,2
ffffffffc02033d0:	26079a63          	bnez	a5,ffffffffc0203644 <pmm_init+0x64a>
    { ret = pmm_manager->nr_free_pages(); }
ffffffffc02033d4:	000bb783          	ld	a5,0(s7)
ffffffffc02033d8:	779c                	ld	a5,40(a5)
ffffffffc02033da:	9782                	jalr	a5
ffffffffc02033dc:	8a2a                	mv	s4,a0

    assert(nr_free_store==nr_free_pages());
ffffffffc02033de:	73441463          	bne	s0,s4,ffffffffc0203b06 <pmm_init+0xb0c>

    cprintf("check_pgdir() succeeded!\n");
ffffffffc02033e2:	00003517          	auipc	a0,0x3
ffffffffc02033e6:	ad650513          	addi	a0,a0,-1322 # ffffffffc0205eb8 <default_pmm_manager+0x538>
ffffffffc02033ea:	cd1fc0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc02033ee:	100027f3          	csrr	a5,sstatus
ffffffffc02033f2:	8b89                	andi	a5,a5,2
ffffffffc02033f4:	22079e63          	bnez	a5,ffffffffc0203630 <pmm_init+0x636>
    { ret = pmm_manager->nr_free_pages(); }
ffffffffc02033f8:	000bb783          	ld	a5,0(s7)
ffffffffc02033fc:	779c                	ld	a5,40(a5)
ffffffffc02033fe:	9782                	jalr	a5
ffffffffc0203400:	8c2a                	mv	s8,a0
    pte_t *ptep;
    int i;

    nr_free_store=nr_free_pages();

    for (i = ROUNDDOWN(KERNBASE, PGSIZE); i < npage * PGSIZE; i += PGSIZE) {
ffffffffc0203402:	6098                	ld	a4,0(s1)
ffffffffc0203404:	c0200437          	lui	s0,0xc0200
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
        assert(PTE_ADDR(*ptep) == i);
ffffffffc0203408:	7afd                	lui	s5,0xfffff
    for (i = ROUNDDOWN(KERNBASE, PGSIZE); i < npage * PGSIZE; i += PGSIZE) {
ffffffffc020340a:	00c71793          	slli	a5,a4,0xc
ffffffffc020340e:	6a05                	lui	s4,0x1
ffffffffc0203410:	02f47c63          	bgeu	s0,a5,ffffffffc0203448 <pmm_init+0x44e>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
ffffffffc0203414:	00c45793          	srli	a5,s0,0xc
ffffffffc0203418:	00093503          	ld	a0,0(s2)
ffffffffc020341c:	30e7f363          	bgeu	a5,a4,ffffffffc0203722 <pmm_init+0x728>
ffffffffc0203420:	0009b583          	ld	a1,0(s3)
ffffffffc0203424:	4601                	li	a2,0
ffffffffc0203426:	95a2                	add	a1,a1,s0
ffffffffc0203428:	fe8ff0ef          	jal	ra,ffffffffc0202c10 <get_pte>
ffffffffc020342c:	2c050b63          	beqz	a0,ffffffffc0203702 <pmm_init+0x708>
        assert(PTE_ADDR(*ptep) == i);
ffffffffc0203430:	611c                	ld	a5,0(a0)
ffffffffc0203432:	078a                	slli	a5,a5,0x2
ffffffffc0203434:	0157f7b3          	and	a5,a5,s5
ffffffffc0203438:	2a879563          	bne	a5,s0,ffffffffc02036e2 <pmm_init+0x6e8>
    for (i = ROUNDDOWN(KERNBASE, PGSIZE); i < npage * PGSIZE; i += PGSIZE) {
ffffffffc020343c:	6098                	ld	a4,0(s1)
ffffffffc020343e:	9452                	add	s0,s0,s4
ffffffffc0203440:	00c71793          	slli	a5,a4,0xc
ffffffffc0203444:	fcf468e3          	bltu	s0,a5,ffffffffc0203414 <pmm_init+0x41a>
    }


    assert(boot_pgdir[0] == 0);
ffffffffc0203448:	00093783          	ld	a5,0(s2)
ffffffffc020344c:	639c                	ld	a5,0(a5)
ffffffffc020344e:	68079c63          	bnez	a5,ffffffffc0203ae6 <pmm_init+0xaec>

    struct Page *p;
    p = alloc_page();
ffffffffc0203452:	4505                	li	a0,1
ffffffffc0203454:	eb0ff0ef          	jal	ra,ffffffffc0202b04 <alloc_pages>
ffffffffc0203458:	8aaa                	mv	s5,a0
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W | PTE_R) == 0);
ffffffffc020345a:	00093503          	ld	a0,0(s2)
ffffffffc020345e:	4699                	li	a3,6
ffffffffc0203460:	10000613          	li	a2,256
ffffffffc0203464:	85d6                	mv	a1,s5
ffffffffc0203466:	a95ff0ef          	jal	ra,ffffffffc0202efa <page_insert>
ffffffffc020346a:	64051e63          	bnez	a0,ffffffffc0203ac6 <pmm_init+0xacc>
    assert(page_ref(p) == 1);
ffffffffc020346e:	000aa703          	lw	a4,0(s5) # fffffffffffff000 <end+0x3fdeda90>
ffffffffc0203472:	4785                	li	a5,1
ffffffffc0203474:	62f71963          	bne	a4,a5,ffffffffc0203aa6 <pmm_init+0xaac>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W | PTE_R) == 0);
ffffffffc0203478:	00093503          	ld	a0,0(s2)
ffffffffc020347c:	6405                	lui	s0,0x1
ffffffffc020347e:	4699                	li	a3,6
ffffffffc0203480:	10040613          	addi	a2,s0,256 # 1100 <kern_entry-0xffffffffc01fef00>
ffffffffc0203484:	85d6                	mv	a1,s5
ffffffffc0203486:	a75ff0ef          	jal	ra,ffffffffc0202efa <page_insert>
ffffffffc020348a:	48051263          	bnez	a0,ffffffffc020390e <pmm_init+0x914>
    assert(page_ref(p) == 2);
ffffffffc020348e:	000aa703          	lw	a4,0(s5)
ffffffffc0203492:	4789                	li	a5,2
ffffffffc0203494:	74f71563          	bne	a4,a5,ffffffffc0203bde <pmm_init+0xbe4>

    const char *str = "ucore: Hello world!!";
    strcpy((void *)0x100, str);
ffffffffc0203498:	00003597          	auipc	a1,0x3
ffffffffc020349c:	b5858593          	addi	a1,a1,-1192 # ffffffffc0205ff0 <default_pmm_manager+0x670>
ffffffffc02034a0:	10000513          	li	a0,256
ffffffffc02034a4:	35d000ef          	jal	ra,ffffffffc0204000 <strcpy>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
ffffffffc02034a8:	10040593          	addi	a1,s0,256
ffffffffc02034ac:	10000513          	li	a0,256
ffffffffc02034b0:	363000ef          	jal	ra,ffffffffc0204012 <strcmp>
ffffffffc02034b4:	70051563          	bnez	a0,ffffffffc0203bbe <pmm_init+0xbc4>
static inline ppn_t page2ppn(struct Page *page) { return page - pages + nbase; }
ffffffffc02034b8:	000b3683          	ld	a3,0(s6)
ffffffffc02034bc:	00080d37          	lui	s10,0x80
static inline void *page2kva(struct Page *page) { return KADDR(page2pa(page)); }
ffffffffc02034c0:	547d                	li	s0,-1
static inline ppn_t page2ppn(struct Page *page) { return page - pages + nbase; }
ffffffffc02034c2:	40da86b3          	sub	a3,s5,a3
ffffffffc02034c6:	868d                	srai	a3,a3,0x3
ffffffffc02034c8:	039686b3          	mul	a3,a3,s9
static inline void *page2kva(struct Page *page) { return KADDR(page2pa(page)); }
ffffffffc02034cc:	609c                	ld	a5,0(s1)
ffffffffc02034ce:	8031                	srli	s0,s0,0xc
static inline ppn_t page2ppn(struct Page *page) { return page - pages + nbase; }
ffffffffc02034d0:	96ea                	add	a3,a3,s10
static inline void *page2kva(struct Page *page) { return KADDR(page2pa(page)); }
ffffffffc02034d2:	0086f733          	and	a4,a3,s0
    return page2ppn(page) << PGSHIFT;
ffffffffc02034d6:	06b2                	slli	a3,a3,0xc
static inline void *page2kva(struct Page *page) { return KADDR(page2pa(page)); }
ffffffffc02034d8:	52f77b63          	bgeu	a4,a5,ffffffffc0203a0e <pmm_init+0xa14>

    *(char *)(page2kva(p) + 0x100) = '\0';
ffffffffc02034dc:	0009b783          	ld	a5,0(s3)
    assert(strlen((const char *)0x100) == 0);
ffffffffc02034e0:	10000513          	li	a0,256
    *(char *)(page2kva(p) + 0x100) = '\0';
ffffffffc02034e4:	96be                	add	a3,a3,a5
ffffffffc02034e6:	10068023          	sb	zero,256(a3) # fffffffffff80100 <end+0x3fd6eb90>
    assert(strlen((const char *)0x100) == 0);
ffffffffc02034ea:	2e1000ef          	jal	ra,ffffffffc0203fca <strlen>
ffffffffc02034ee:	6a051863          	bnez	a0,ffffffffc0203b9e <pmm_init+0xba4>

    pde_t *pd1=boot_pgdir,*pd0=page2kva(pde2page(boot_pgdir[0]));
ffffffffc02034f2:	00093a03          	ld	s4,0(s2)
    if (PPN(pa) >= npage) {
ffffffffc02034f6:	6098                	ld	a4,0(s1)
    return pa2page(PDE_ADDR(pde));
ffffffffc02034f8:	000a3783          	ld	a5,0(s4) # 1000 <kern_entry-0xffffffffc01ff000>
ffffffffc02034fc:	078a                	slli	a5,a5,0x2
ffffffffc02034fe:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage) {
ffffffffc0203500:	22e7fe63          	bgeu	a5,a4,ffffffffc020373c <pmm_init+0x742>
    return &pages[PPN(pa) - nbase];
ffffffffc0203504:	41a787b3          	sub	a5,a5,s10
ffffffffc0203508:	00379693          	slli	a3,a5,0x3
static inline ppn_t page2ppn(struct Page *page) { return page - pages + nbase; }
ffffffffc020350c:	96be                	add	a3,a3,a5
ffffffffc020350e:	03968cb3          	mul	s9,a3,s9
ffffffffc0203512:	01ac86b3          	add	a3,s9,s10
static inline void *page2kva(struct Page *page) { return KADDR(page2pa(page)); }
ffffffffc0203516:	8c75                	and	s0,s0,a3
    return page2ppn(page) << PGSHIFT;
ffffffffc0203518:	06b2                	slli	a3,a3,0xc
static inline void *page2kva(struct Page *page) { return KADDR(page2pa(page)); }
ffffffffc020351a:	4ee47a63          	bgeu	s0,a4,ffffffffc0203a0e <pmm_init+0xa14>
ffffffffc020351e:	0009b403          	ld	s0,0(s3)
ffffffffc0203522:	9436                	add	s0,s0,a3
ffffffffc0203524:	100027f3          	csrr	a5,sstatus
ffffffffc0203528:	8b89                	andi	a5,a5,2
ffffffffc020352a:	1a079163          	bnez	a5,ffffffffc02036cc <pmm_init+0x6d2>
    { pmm_manager->free_pages(base, n); }
ffffffffc020352e:	000bb783          	ld	a5,0(s7)
ffffffffc0203532:	4585                	li	a1,1
ffffffffc0203534:	8556                	mv	a0,s5
ffffffffc0203536:	739c                	ld	a5,32(a5)
ffffffffc0203538:	9782                	jalr	a5
    return pa2page(PDE_ADDR(pde));
ffffffffc020353a:	601c                	ld	a5,0(s0)
    if (PPN(pa) >= npage) {
ffffffffc020353c:	6098                	ld	a4,0(s1)
    return pa2page(PDE_ADDR(pde));
ffffffffc020353e:	078a                	slli	a5,a5,0x2
ffffffffc0203540:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage) {
ffffffffc0203542:	1ee7fd63          	bgeu	a5,a4,ffffffffc020373c <pmm_init+0x742>
    return &pages[PPN(pa) - nbase];
ffffffffc0203546:	fff80737          	lui	a4,0xfff80
ffffffffc020354a:	97ba                	add	a5,a5,a4
ffffffffc020354c:	000b3503          	ld	a0,0(s6)
ffffffffc0203550:	00379713          	slli	a4,a5,0x3
ffffffffc0203554:	97ba                	add	a5,a5,a4
ffffffffc0203556:	078e                	slli	a5,a5,0x3
ffffffffc0203558:	953e                	add	a0,a0,a5
ffffffffc020355a:	100027f3          	csrr	a5,sstatus
ffffffffc020355e:	8b89                	andi	a5,a5,2
ffffffffc0203560:	14079a63          	bnez	a5,ffffffffc02036b4 <pmm_init+0x6ba>
ffffffffc0203564:	000bb783          	ld	a5,0(s7)
ffffffffc0203568:	4585                	li	a1,1
ffffffffc020356a:	739c                	ld	a5,32(a5)
ffffffffc020356c:	9782                	jalr	a5
    return pa2page(PDE_ADDR(pde));
ffffffffc020356e:	000a3783          	ld	a5,0(s4)
    if (PPN(pa) >= npage) {
ffffffffc0203572:	6098                	ld	a4,0(s1)
    return pa2page(PDE_ADDR(pde));
ffffffffc0203574:	078a                	slli	a5,a5,0x2
ffffffffc0203576:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage) {
ffffffffc0203578:	1ce7f263          	bgeu	a5,a4,ffffffffc020373c <pmm_init+0x742>
    return &pages[PPN(pa) - nbase];
ffffffffc020357c:	fff80737          	lui	a4,0xfff80
ffffffffc0203580:	97ba                	add	a5,a5,a4
ffffffffc0203582:	000b3503          	ld	a0,0(s6)
ffffffffc0203586:	00379713          	slli	a4,a5,0x3
ffffffffc020358a:	97ba                	add	a5,a5,a4
ffffffffc020358c:	078e                	slli	a5,a5,0x3
ffffffffc020358e:	953e                	add	a0,a0,a5
ffffffffc0203590:	100027f3          	csrr	a5,sstatus
ffffffffc0203594:	8b89                	andi	a5,a5,2
ffffffffc0203596:	10079363          	bnez	a5,ffffffffc020369c <pmm_init+0x6a2>
ffffffffc020359a:	000bb783          	ld	a5,0(s7)
ffffffffc020359e:	4585                	li	a1,1
ffffffffc02035a0:	739c                	ld	a5,32(a5)
ffffffffc02035a2:	9782                	jalr	a5
    free_page(p);
    free_page(pde2page(pd0[0]));
    free_page(pde2page(pd1[0]));
    boot_pgdir[0] = 0;
ffffffffc02035a4:	00093783          	ld	a5,0(s2)
ffffffffc02035a8:	0007b023          	sd	zero,0(a5)
ffffffffc02035ac:	100027f3          	csrr	a5,sstatus
ffffffffc02035b0:	8b89                	andi	a5,a5,2
ffffffffc02035b2:	0c079b63          	bnez	a5,ffffffffc0203688 <pmm_init+0x68e>
    { ret = pmm_manager->nr_free_pages(); }
ffffffffc02035b6:	000bb783          	ld	a5,0(s7)
ffffffffc02035ba:	779c                	ld	a5,40(a5)
ffffffffc02035bc:	9782                	jalr	a5
ffffffffc02035be:	842a                	mv	s0,a0

    assert(nr_free_store==nr_free_pages());
ffffffffc02035c0:	3a8c1763          	bne	s8,s0,ffffffffc020396e <pmm_init+0x974>
}
ffffffffc02035c4:	7406                	ld	s0,96(sp)
ffffffffc02035c6:	70a6                	ld	ra,104(sp)
ffffffffc02035c8:	64e6                	ld	s1,88(sp)
ffffffffc02035ca:	6946                	ld	s2,80(sp)
ffffffffc02035cc:	69a6                	ld	s3,72(sp)
ffffffffc02035ce:	6a06                	ld	s4,64(sp)
ffffffffc02035d0:	7ae2                	ld	s5,56(sp)
ffffffffc02035d2:	7b42                	ld	s6,48(sp)
ffffffffc02035d4:	7ba2                	ld	s7,40(sp)
ffffffffc02035d6:	7c02                	ld	s8,32(sp)
ffffffffc02035d8:	6ce2                	ld	s9,24(sp)
ffffffffc02035da:	6d42                	ld	s10,16(sp)

    cprintf("check_boot_pgdir() succeeded!\n");
ffffffffc02035dc:	00003517          	auipc	a0,0x3
ffffffffc02035e0:	a8c50513          	addi	a0,a0,-1396 # ffffffffc0206068 <default_pmm_manager+0x6e8>
}
ffffffffc02035e4:	6165                	addi	sp,sp,112
    cprintf("check_boot_pgdir() succeeded!\n");
ffffffffc02035e6:	ad5fc06f          	j	ffffffffc02000ba <cprintf>
    mem_begin = ROUNDUP(freemem, PGSIZE);
ffffffffc02035ea:	6705                	lui	a4,0x1
ffffffffc02035ec:	177d                	addi	a4,a4,-1
ffffffffc02035ee:	96ba                	add	a3,a3,a4
ffffffffc02035f0:	777d                	lui	a4,0xfffff
ffffffffc02035f2:	8f75                	and	a4,a4,a3
    if (PPN(pa) >= npage) {
ffffffffc02035f4:	00c75693          	srli	a3,a4,0xc
ffffffffc02035f8:	14f6f263          	bgeu	a3,a5,ffffffffc020373c <pmm_init+0x742>
    pmm_manager->init_memmap(base, n);
ffffffffc02035fc:	000bb803          	ld	a6,0(s7)
    return &pages[PPN(pa) - nbase];
ffffffffc0203600:	95b6                	add	a1,a1,a3
ffffffffc0203602:	00359793          	slli	a5,a1,0x3
ffffffffc0203606:	97ae                	add	a5,a5,a1
ffffffffc0203608:	01083683          	ld	a3,16(a6)
        init_memmap(pa2page(mem_begin), (mem_end - mem_begin) / PGSIZE);
ffffffffc020360c:	40e60733          	sub	a4,a2,a4
ffffffffc0203610:	078e                	slli	a5,a5,0x3
    pmm_manager->init_memmap(base, n);
ffffffffc0203612:	00c75593          	srli	a1,a4,0xc
ffffffffc0203616:	953e                	add	a0,a0,a5
ffffffffc0203618:	9682                	jalr	a3
}
ffffffffc020361a:	bcc5                	j	ffffffffc020310a <pmm_init+0x110>
        intr_disable();
ffffffffc020361c:	ed3fc0ef          	jal	ra,ffffffffc02004ee <intr_disable>
    { ret = pmm_manager->nr_free_pages(); }
ffffffffc0203620:	000bb783          	ld	a5,0(s7)
ffffffffc0203624:	779c                	ld	a5,40(a5)
ffffffffc0203626:	9782                	jalr	a5
ffffffffc0203628:	842a                	mv	s0,a0
        intr_enable();
ffffffffc020362a:	ebffc0ef          	jal	ra,ffffffffc02004e8 <intr_enable>
ffffffffc020362e:	b63d                	j	ffffffffc020315c <pmm_init+0x162>
        intr_disable();
ffffffffc0203630:	ebffc0ef          	jal	ra,ffffffffc02004ee <intr_disable>
ffffffffc0203634:	000bb783          	ld	a5,0(s7)
ffffffffc0203638:	779c                	ld	a5,40(a5)
ffffffffc020363a:	9782                	jalr	a5
ffffffffc020363c:	8c2a                	mv	s8,a0
        intr_enable();
ffffffffc020363e:	eabfc0ef          	jal	ra,ffffffffc02004e8 <intr_enable>
ffffffffc0203642:	b3c1                	j	ffffffffc0203402 <pmm_init+0x408>
        intr_disable();
ffffffffc0203644:	eabfc0ef          	jal	ra,ffffffffc02004ee <intr_disable>
ffffffffc0203648:	000bb783          	ld	a5,0(s7)
ffffffffc020364c:	779c                	ld	a5,40(a5)
ffffffffc020364e:	9782                	jalr	a5
ffffffffc0203650:	8a2a                	mv	s4,a0
        intr_enable();
ffffffffc0203652:	e97fc0ef          	jal	ra,ffffffffc02004e8 <intr_enable>
ffffffffc0203656:	b361                	j	ffffffffc02033de <pmm_init+0x3e4>
ffffffffc0203658:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc020365a:	e95fc0ef          	jal	ra,ffffffffc02004ee <intr_disable>
    { pmm_manager->free_pages(base, n); }
ffffffffc020365e:	000bb783          	ld	a5,0(s7)
ffffffffc0203662:	6522                	ld	a0,8(sp)
ffffffffc0203664:	4585                	li	a1,1
ffffffffc0203666:	739c                	ld	a5,32(a5)
ffffffffc0203668:	9782                	jalr	a5
        intr_enable();
ffffffffc020366a:	e7ffc0ef          	jal	ra,ffffffffc02004e8 <intr_enable>
ffffffffc020366e:	bb91                	j	ffffffffc02033c2 <pmm_init+0x3c8>
ffffffffc0203670:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc0203672:	e7dfc0ef          	jal	ra,ffffffffc02004ee <intr_disable>
ffffffffc0203676:	000bb783          	ld	a5,0(s7)
ffffffffc020367a:	6522                	ld	a0,8(sp)
ffffffffc020367c:	4585                	li	a1,1
ffffffffc020367e:	739c                	ld	a5,32(a5)
ffffffffc0203680:	9782                	jalr	a5
        intr_enable();
ffffffffc0203682:	e67fc0ef          	jal	ra,ffffffffc02004e8 <intr_enable>
ffffffffc0203686:	b319                	j	ffffffffc020338c <pmm_init+0x392>
        intr_disable();
ffffffffc0203688:	e67fc0ef          	jal	ra,ffffffffc02004ee <intr_disable>
    { ret = pmm_manager->nr_free_pages(); }
ffffffffc020368c:	000bb783          	ld	a5,0(s7)
ffffffffc0203690:	779c                	ld	a5,40(a5)
ffffffffc0203692:	9782                	jalr	a5
ffffffffc0203694:	842a                	mv	s0,a0
        intr_enable();
ffffffffc0203696:	e53fc0ef          	jal	ra,ffffffffc02004e8 <intr_enable>
ffffffffc020369a:	b71d                	j	ffffffffc02035c0 <pmm_init+0x5c6>
ffffffffc020369c:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc020369e:	e51fc0ef          	jal	ra,ffffffffc02004ee <intr_disable>
    { pmm_manager->free_pages(base, n); }
ffffffffc02036a2:	000bb783          	ld	a5,0(s7)
ffffffffc02036a6:	6522                	ld	a0,8(sp)
ffffffffc02036a8:	4585                	li	a1,1
ffffffffc02036aa:	739c                	ld	a5,32(a5)
ffffffffc02036ac:	9782                	jalr	a5
        intr_enable();
ffffffffc02036ae:	e3bfc0ef          	jal	ra,ffffffffc02004e8 <intr_enable>
ffffffffc02036b2:	bdcd                	j	ffffffffc02035a4 <pmm_init+0x5aa>
ffffffffc02036b4:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc02036b6:	e39fc0ef          	jal	ra,ffffffffc02004ee <intr_disable>
ffffffffc02036ba:	000bb783          	ld	a5,0(s7)
ffffffffc02036be:	6522                	ld	a0,8(sp)
ffffffffc02036c0:	4585                	li	a1,1
ffffffffc02036c2:	739c                	ld	a5,32(a5)
ffffffffc02036c4:	9782                	jalr	a5
        intr_enable();
ffffffffc02036c6:	e23fc0ef          	jal	ra,ffffffffc02004e8 <intr_enable>
ffffffffc02036ca:	b555                	j	ffffffffc020356e <pmm_init+0x574>
        intr_disable();
ffffffffc02036cc:	e23fc0ef          	jal	ra,ffffffffc02004ee <intr_disable>
ffffffffc02036d0:	000bb783          	ld	a5,0(s7)
ffffffffc02036d4:	4585                	li	a1,1
ffffffffc02036d6:	8556                	mv	a0,s5
ffffffffc02036d8:	739c                	ld	a5,32(a5)
ffffffffc02036da:	9782                	jalr	a5
        intr_enable();
ffffffffc02036dc:	e0dfc0ef          	jal	ra,ffffffffc02004e8 <intr_enable>
ffffffffc02036e0:	bda9                	j	ffffffffc020353a <pmm_init+0x540>
        assert(PTE_ADDR(*ptep) == i);
ffffffffc02036e2:	00003697          	auipc	a3,0x3
ffffffffc02036e6:	83668693          	addi	a3,a3,-1994 # ffffffffc0205f18 <default_pmm_manager+0x598>
ffffffffc02036ea:	00001617          	auipc	a2,0x1
ffffffffc02036ee:	7ce60613          	addi	a2,a2,1998 # ffffffffc0204eb8 <commands+0x728>
ffffffffc02036f2:	1ce00593          	li	a1,462
ffffffffc02036f6:	00002517          	auipc	a0,0x2
ffffffffc02036fa:	41a50513          	addi	a0,a0,1050 # ffffffffc0205b10 <default_pmm_manager+0x190>
ffffffffc02036fe:	a05fc0ef          	jal	ra,ffffffffc0200102 <__panic>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
ffffffffc0203702:	00002697          	auipc	a3,0x2
ffffffffc0203706:	7d668693          	addi	a3,a3,2006 # ffffffffc0205ed8 <default_pmm_manager+0x558>
ffffffffc020370a:	00001617          	auipc	a2,0x1
ffffffffc020370e:	7ae60613          	addi	a2,a2,1966 # ffffffffc0204eb8 <commands+0x728>
ffffffffc0203712:	1cd00593          	li	a1,461
ffffffffc0203716:	00002517          	auipc	a0,0x2
ffffffffc020371a:	3fa50513          	addi	a0,a0,1018 # ffffffffc0205b10 <default_pmm_manager+0x190>
ffffffffc020371e:	9e5fc0ef          	jal	ra,ffffffffc0200102 <__panic>
ffffffffc0203722:	86a2                	mv	a3,s0
ffffffffc0203724:	00002617          	auipc	a2,0x2
ffffffffc0203728:	3c460613          	addi	a2,a2,964 # ffffffffc0205ae8 <default_pmm_manager+0x168>
ffffffffc020372c:	1cd00593          	li	a1,461
ffffffffc0203730:	00002517          	auipc	a0,0x2
ffffffffc0203734:	3e050513          	addi	a0,a0,992 # ffffffffc0205b10 <default_pmm_manager+0x190>
ffffffffc0203738:	9cbfc0ef          	jal	ra,ffffffffc0200102 <__panic>
ffffffffc020373c:	b90ff0ef          	jal	ra,ffffffffc0202acc <pa2page.part.0>
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc0203740:	00002617          	auipc	a2,0x2
ffffffffc0203744:	46860613          	addi	a2,a2,1128 # ffffffffc0205ba8 <default_pmm_manager+0x228>
ffffffffc0203748:	07700593          	li	a1,119
ffffffffc020374c:	00002517          	auipc	a0,0x2
ffffffffc0203750:	3c450513          	addi	a0,a0,964 # ffffffffc0205b10 <default_pmm_manager+0x190>
ffffffffc0203754:	9affc0ef          	jal	ra,ffffffffc0200102 <__panic>
    boot_cr3 = PADDR(boot_pgdir);
ffffffffc0203758:	00002617          	auipc	a2,0x2
ffffffffc020375c:	45060613          	addi	a2,a2,1104 # ffffffffc0205ba8 <default_pmm_manager+0x228>
ffffffffc0203760:	0bd00593          	li	a1,189
ffffffffc0203764:	00002517          	auipc	a0,0x2
ffffffffc0203768:	3ac50513          	addi	a0,a0,940 # ffffffffc0205b10 <default_pmm_manager+0x190>
ffffffffc020376c:	997fc0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(boot_pgdir != NULL && (uint32_t)PGOFF(boot_pgdir) == 0);
ffffffffc0203770:	00002697          	auipc	a3,0x2
ffffffffc0203774:	4a068693          	addi	a3,a3,1184 # ffffffffc0205c10 <default_pmm_manager+0x290>
ffffffffc0203778:	00001617          	auipc	a2,0x1
ffffffffc020377c:	74060613          	addi	a2,a2,1856 # ffffffffc0204eb8 <commands+0x728>
ffffffffc0203780:	19300593          	li	a1,403
ffffffffc0203784:	00002517          	auipc	a0,0x2
ffffffffc0203788:	38c50513          	addi	a0,a0,908 # ffffffffc0205b10 <default_pmm_manager+0x190>
ffffffffc020378c:	977fc0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(npage <= KERNTOP / PGSIZE);
ffffffffc0203790:	00002697          	auipc	a3,0x2
ffffffffc0203794:	46068693          	addi	a3,a3,1120 # ffffffffc0205bf0 <default_pmm_manager+0x270>
ffffffffc0203798:	00001617          	auipc	a2,0x1
ffffffffc020379c:	72060613          	addi	a2,a2,1824 # ffffffffc0204eb8 <commands+0x728>
ffffffffc02037a0:	19200593          	li	a1,402
ffffffffc02037a4:	00002517          	auipc	a0,0x2
ffffffffc02037a8:	36c50513          	addi	a0,a0,876 # ffffffffc0205b10 <default_pmm_manager+0x190>
ffffffffc02037ac:	957fc0ef          	jal	ra,ffffffffc0200102 <__panic>
ffffffffc02037b0:	b38ff0ef          	jal	ra,ffffffffc0202ae8 <pte2page.part.0>
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
ffffffffc02037b4:	00002697          	auipc	a3,0x2
ffffffffc02037b8:	4ec68693          	addi	a3,a3,1260 # ffffffffc0205ca0 <default_pmm_manager+0x320>
ffffffffc02037bc:	00001617          	auipc	a2,0x1
ffffffffc02037c0:	6fc60613          	addi	a2,a2,1788 # ffffffffc0204eb8 <commands+0x728>
ffffffffc02037c4:	19a00593          	li	a1,410
ffffffffc02037c8:	00002517          	auipc	a0,0x2
ffffffffc02037cc:	34850513          	addi	a0,a0,840 # ffffffffc0205b10 <default_pmm_manager+0x190>
ffffffffc02037d0:	933fc0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
ffffffffc02037d4:	00002697          	auipc	a3,0x2
ffffffffc02037d8:	49c68693          	addi	a3,a3,1180 # ffffffffc0205c70 <default_pmm_manager+0x2f0>
ffffffffc02037dc:	00001617          	auipc	a2,0x1
ffffffffc02037e0:	6dc60613          	addi	a2,a2,1756 # ffffffffc0204eb8 <commands+0x728>
ffffffffc02037e4:	19800593          	li	a1,408
ffffffffc02037e8:	00002517          	auipc	a0,0x2
ffffffffc02037ec:	32850513          	addi	a0,a0,808 # ffffffffc0205b10 <default_pmm_manager+0x190>
ffffffffc02037f0:	913fc0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
ffffffffc02037f4:	00002697          	auipc	a3,0x2
ffffffffc02037f8:	45468693          	addi	a3,a3,1108 # ffffffffc0205c48 <default_pmm_manager+0x2c8>
ffffffffc02037fc:	00001617          	auipc	a2,0x1
ffffffffc0203800:	6bc60613          	addi	a2,a2,1724 # ffffffffc0204eb8 <commands+0x728>
ffffffffc0203804:	19400593          	li	a1,404
ffffffffc0203808:	00002517          	auipc	a0,0x2
ffffffffc020380c:	30850513          	addi	a0,a0,776 # ffffffffc0205b10 <default_pmm_manager+0x190>
ffffffffc0203810:	8f3fc0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
ffffffffc0203814:	00002697          	auipc	a3,0x2
ffffffffc0203818:	51468693          	addi	a3,a3,1300 # ffffffffc0205d28 <default_pmm_manager+0x3a8>
ffffffffc020381c:	00001617          	auipc	a2,0x1
ffffffffc0203820:	69c60613          	addi	a2,a2,1692 # ffffffffc0204eb8 <commands+0x728>
ffffffffc0203824:	1a300593          	li	a1,419
ffffffffc0203828:	00002517          	auipc	a0,0x2
ffffffffc020382c:	2e850513          	addi	a0,a0,744 # ffffffffc0205b10 <default_pmm_manager+0x190>
ffffffffc0203830:	8d3fc0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(page_ref(p2) == 1);
ffffffffc0203834:	00002697          	auipc	a3,0x2
ffffffffc0203838:	59468693          	addi	a3,a3,1428 # ffffffffc0205dc8 <default_pmm_manager+0x448>
ffffffffc020383c:	00001617          	auipc	a2,0x1
ffffffffc0203840:	67c60613          	addi	a2,a2,1660 # ffffffffc0204eb8 <commands+0x728>
ffffffffc0203844:	1a800593          	li	a1,424
ffffffffc0203848:	00002517          	auipc	a0,0x2
ffffffffc020384c:	2c850513          	addi	a0,a0,712 # ffffffffc0205b10 <default_pmm_manager+0x190>
ffffffffc0203850:	8b3fc0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
ffffffffc0203854:	00002697          	auipc	a3,0x2
ffffffffc0203858:	4ac68693          	addi	a3,a3,1196 # ffffffffc0205d00 <default_pmm_manager+0x380>
ffffffffc020385c:	00001617          	auipc	a2,0x1
ffffffffc0203860:	65c60613          	addi	a2,a2,1628 # ffffffffc0204eb8 <commands+0x728>
ffffffffc0203864:	1a000593          	li	a1,416
ffffffffc0203868:	00002517          	auipc	a0,0x2
ffffffffc020386c:	2a850513          	addi	a0,a0,680 # ffffffffc0205b10 <default_pmm_manager+0x190>
ffffffffc0203870:	893fc0ef          	jal	ra,ffffffffc0200102 <__panic>
    ptep = (pte_t *)KADDR(PDE_ADDR(ptep[0])) + 1;
ffffffffc0203874:	86d6                	mv	a3,s5
ffffffffc0203876:	00002617          	auipc	a2,0x2
ffffffffc020387a:	27260613          	addi	a2,a2,626 # ffffffffc0205ae8 <default_pmm_manager+0x168>
ffffffffc020387e:	19f00593          	li	a1,415
ffffffffc0203882:	00002517          	auipc	a0,0x2
ffffffffc0203886:	28e50513          	addi	a0,a0,654 # ffffffffc0205b10 <default_pmm_manager+0x190>
ffffffffc020388a:	879fc0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
ffffffffc020388e:	00002697          	auipc	a3,0x2
ffffffffc0203892:	4d268693          	addi	a3,a3,1234 # ffffffffc0205d60 <default_pmm_manager+0x3e0>
ffffffffc0203896:	00001617          	auipc	a2,0x1
ffffffffc020389a:	62260613          	addi	a2,a2,1570 # ffffffffc0204eb8 <commands+0x728>
ffffffffc020389e:	1ad00593          	li	a1,429
ffffffffc02038a2:	00002517          	auipc	a0,0x2
ffffffffc02038a6:	26e50513          	addi	a0,a0,622 # ffffffffc0205b10 <default_pmm_manager+0x190>
ffffffffc02038aa:	859fc0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(page_ref(p2) == 0);
ffffffffc02038ae:	00002697          	auipc	a3,0x2
ffffffffc02038b2:	57a68693          	addi	a3,a3,1402 # ffffffffc0205e28 <default_pmm_manager+0x4a8>
ffffffffc02038b6:	00001617          	auipc	a2,0x1
ffffffffc02038ba:	60260613          	addi	a2,a2,1538 # ffffffffc0204eb8 <commands+0x728>
ffffffffc02038be:	1ac00593          	li	a1,428
ffffffffc02038c2:	00002517          	auipc	a0,0x2
ffffffffc02038c6:	24e50513          	addi	a0,a0,590 # ffffffffc0205b10 <default_pmm_manager+0x190>
ffffffffc02038ca:	839fc0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(page_ref(p1) == 2);
ffffffffc02038ce:	00002697          	auipc	a3,0x2
ffffffffc02038d2:	54268693          	addi	a3,a3,1346 # ffffffffc0205e10 <default_pmm_manager+0x490>
ffffffffc02038d6:	00001617          	auipc	a2,0x1
ffffffffc02038da:	5e260613          	addi	a2,a2,1506 # ffffffffc0204eb8 <commands+0x728>
ffffffffc02038de:	1ab00593          	li	a1,427
ffffffffc02038e2:	00002517          	auipc	a0,0x2
ffffffffc02038e6:	22e50513          	addi	a0,a0,558 # ffffffffc0205b10 <default_pmm_manager+0x190>
ffffffffc02038ea:	819fc0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
ffffffffc02038ee:	00002697          	auipc	a3,0x2
ffffffffc02038f2:	4f268693          	addi	a3,a3,1266 # ffffffffc0205de0 <default_pmm_manager+0x460>
ffffffffc02038f6:	00001617          	auipc	a2,0x1
ffffffffc02038fa:	5c260613          	addi	a2,a2,1474 # ffffffffc0204eb8 <commands+0x728>
ffffffffc02038fe:	1aa00593          	li	a1,426
ffffffffc0203902:	00002517          	auipc	a0,0x2
ffffffffc0203906:	20e50513          	addi	a0,a0,526 # ffffffffc0205b10 <default_pmm_manager+0x190>
ffffffffc020390a:	ff8fc0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W | PTE_R) == 0);
ffffffffc020390e:	00002697          	auipc	a3,0x2
ffffffffc0203912:	68a68693          	addi	a3,a3,1674 # ffffffffc0205f98 <default_pmm_manager+0x618>
ffffffffc0203916:	00001617          	auipc	a2,0x1
ffffffffc020391a:	5a260613          	addi	a2,a2,1442 # ffffffffc0204eb8 <commands+0x728>
ffffffffc020391e:	1d800593          	li	a1,472
ffffffffc0203922:	00002517          	auipc	a0,0x2
ffffffffc0203926:	1ee50513          	addi	a0,a0,494 # ffffffffc0205b10 <default_pmm_manager+0x190>
ffffffffc020392a:	fd8fc0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(boot_pgdir[0] & PTE_U);
ffffffffc020392e:	00002697          	auipc	a3,0x2
ffffffffc0203932:	48268693          	addi	a3,a3,1154 # ffffffffc0205db0 <default_pmm_manager+0x430>
ffffffffc0203936:	00001617          	auipc	a2,0x1
ffffffffc020393a:	58260613          	addi	a2,a2,1410 # ffffffffc0204eb8 <commands+0x728>
ffffffffc020393e:	1a700593          	li	a1,423
ffffffffc0203942:	00002517          	auipc	a0,0x2
ffffffffc0203946:	1ce50513          	addi	a0,a0,462 # ffffffffc0205b10 <default_pmm_manager+0x190>
ffffffffc020394a:	fb8fc0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(*ptep & PTE_W);
ffffffffc020394e:	00002697          	auipc	a3,0x2
ffffffffc0203952:	45268693          	addi	a3,a3,1106 # ffffffffc0205da0 <default_pmm_manager+0x420>
ffffffffc0203956:	00001617          	auipc	a2,0x1
ffffffffc020395a:	56260613          	addi	a2,a2,1378 # ffffffffc0204eb8 <commands+0x728>
ffffffffc020395e:	1a600593          	li	a1,422
ffffffffc0203962:	00002517          	auipc	a0,0x2
ffffffffc0203966:	1ae50513          	addi	a0,a0,430 # ffffffffc0205b10 <default_pmm_manager+0x190>
ffffffffc020396a:	f98fc0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(nr_free_store==nr_free_pages());
ffffffffc020396e:	00002697          	auipc	a3,0x2
ffffffffc0203972:	52a68693          	addi	a3,a3,1322 # ffffffffc0205e98 <default_pmm_manager+0x518>
ffffffffc0203976:	00001617          	auipc	a2,0x1
ffffffffc020397a:	54260613          	addi	a2,a2,1346 # ffffffffc0204eb8 <commands+0x728>
ffffffffc020397e:	1e800593          	li	a1,488
ffffffffc0203982:	00002517          	auipc	a0,0x2
ffffffffc0203986:	18e50513          	addi	a0,a0,398 # ffffffffc0205b10 <default_pmm_manager+0x190>
ffffffffc020398a:	f78fc0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(*ptep & PTE_U);
ffffffffc020398e:	00002697          	auipc	a3,0x2
ffffffffc0203992:	40268693          	addi	a3,a3,1026 # ffffffffc0205d90 <default_pmm_manager+0x410>
ffffffffc0203996:	00001617          	auipc	a2,0x1
ffffffffc020399a:	52260613          	addi	a2,a2,1314 # ffffffffc0204eb8 <commands+0x728>
ffffffffc020399e:	1a500593          	li	a1,421
ffffffffc02039a2:	00002517          	auipc	a0,0x2
ffffffffc02039a6:	16e50513          	addi	a0,a0,366 # ffffffffc0205b10 <default_pmm_manager+0x190>
ffffffffc02039aa:	f58fc0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(page_ref(p1) == 1);
ffffffffc02039ae:	00002697          	auipc	a3,0x2
ffffffffc02039b2:	33a68693          	addi	a3,a3,826 # ffffffffc0205ce8 <default_pmm_manager+0x368>
ffffffffc02039b6:	00001617          	auipc	a2,0x1
ffffffffc02039ba:	50260613          	addi	a2,a2,1282 # ffffffffc0204eb8 <commands+0x728>
ffffffffc02039be:	1b200593          	li	a1,434
ffffffffc02039c2:	00002517          	auipc	a0,0x2
ffffffffc02039c6:	14e50513          	addi	a0,a0,334 # ffffffffc0205b10 <default_pmm_manager+0x190>
ffffffffc02039ca:	f38fc0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert((*ptep & PTE_U) == 0);
ffffffffc02039ce:	00002697          	auipc	a3,0x2
ffffffffc02039d2:	47268693          	addi	a3,a3,1138 # ffffffffc0205e40 <default_pmm_manager+0x4c0>
ffffffffc02039d6:	00001617          	auipc	a2,0x1
ffffffffc02039da:	4e260613          	addi	a2,a2,1250 # ffffffffc0204eb8 <commands+0x728>
ffffffffc02039de:	1af00593          	li	a1,431
ffffffffc02039e2:	00002517          	auipc	a0,0x2
ffffffffc02039e6:	12e50513          	addi	a0,a0,302 # ffffffffc0205b10 <default_pmm_manager+0x190>
ffffffffc02039ea:	f18fc0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(pte2page(*ptep) == p1);
ffffffffc02039ee:	00002697          	auipc	a3,0x2
ffffffffc02039f2:	2e268693          	addi	a3,a3,738 # ffffffffc0205cd0 <default_pmm_manager+0x350>
ffffffffc02039f6:	00001617          	auipc	a2,0x1
ffffffffc02039fa:	4c260613          	addi	a2,a2,1218 # ffffffffc0204eb8 <commands+0x728>
ffffffffc02039fe:	1ae00593          	li	a1,430
ffffffffc0203a02:	00002517          	auipc	a0,0x2
ffffffffc0203a06:	10e50513          	addi	a0,a0,270 # ffffffffc0205b10 <default_pmm_manager+0x190>
ffffffffc0203a0a:	ef8fc0ef          	jal	ra,ffffffffc0200102 <__panic>
static inline void *page2kva(struct Page *page) { return KADDR(page2pa(page)); }
ffffffffc0203a0e:	00002617          	auipc	a2,0x2
ffffffffc0203a12:	0da60613          	addi	a2,a2,218 # ffffffffc0205ae8 <default_pmm_manager+0x168>
ffffffffc0203a16:	06a00593          	li	a1,106
ffffffffc0203a1a:	00001517          	auipc	a0,0x1
ffffffffc0203a1e:	70e50513          	addi	a0,a0,1806 # ffffffffc0205128 <commands+0x998>
ffffffffc0203a22:	ee0fc0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(page_ref(pde2page(boot_pgdir[0])) == 1);
ffffffffc0203a26:	00002697          	auipc	a3,0x2
ffffffffc0203a2a:	44a68693          	addi	a3,a3,1098 # ffffffffc0205e70 <default_pmm_manager+0x4f0>
ffffffffc0203a2e:	00001617          	auipc	a2,0x1
ffffffffc0203a32:	48a60613          	addi	a2,a2,1162 # ffffffffc0204eb8 <commands+0x728>
ffffffffc0203a36:	1b900593          	li	a1,441
ffffffffc0203a3a:	00002517          	auipc	a0,0x2
ffffffffc0203a3e:	0d650513          	addi	a0,a0,214 # ffffffffc0205b10 <default_pmm_manager+0x190>
ffffffffc0203a42:	ec0fc0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(page_ref(p2) == 0);
ffffffffc0203a46:	00002697          	auipc	a3,0x2
ffffffffc0203a4a:	3e268693          	addi	a3,a3,994 # ffffffffc0205e28 <default_pmm_manager+0x4a8>
ffffffffc0203a4e:	00001617          	auipc	a2,0x1
ffffffffc0203a52:	46a60613          	addi	a2,a2,1130 # ffffffffc0204eb8 <commands+0x728>
ffffffffc0203a56:	1b700593          	li	a1,439
ffffffffc0203a5a:	00002517          	auipc	a0,0x2
ffffffffc0203a5e:	0b650513          	addi	a0,a0,182 # ffffffffc0205b10 <default_pmm_manager+0x190>
ffffffffc0203a62:	ea0fc0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(page_ref(p1) == 0);
ffffffffc0203a66:	00002697          	auipc	a3,0x2
ffffffffc0203a6a:	3f268693          	addi	a3,a3,1010 # ffffffffc0205e58 <default_pmm_manager+0x4d8>
ffffffffc0203a6e:	00001617          	auipc	a2,0x1
ffffffffc0203a72:	44a60613          	addi	a2,a2,1098 # ffffffffc0204eb8 <commands+0x728>
ffffffffc0203a76:	1b600593          	li	a1,438
ffffffffc0203a7a:	00002517          	auipc	a0,0x2
ffffffffc0203a7e:	09650513          	addi	a0,a0,150 # ffffffffc0205b10 <default_pmm_manager+0x190>
ffffffffc0203a82:	e80fc0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(page_ref(p2) == 0);
ffffffffc0203a86:	00002697          	auipc	a3,0x2
ffffffffc0203a8a:	3a268693          	addi	a3,a3,930 # ffffffffc0205e28 <default_pmm_manager+0x4a8>
ffffffffc0203a8e:	00001617          	auipc	a2,0x1
ffffffffc0203a92:	42a60613          	addi	a2,a2,1066 # ffffffffc0204eb8 <commands+0x728>
ffffffffc0203a96:	1b300593          	li	a1,435
ffffffffc0203a9a:	00002517          	auipc	a0,0x2
ffffffffc0203a9e:	07650513          	addi	a0,a0,118 # ffffffffc0205b10 <default_pmm_manager+0x190>
ffffffffc0203aa2:	e60fc0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(page_ref(p) == 1);
ffffffffc0203aa6:	00002697          	auipc	a3,0x2
ffffffffc0203aaa:	4da68693          	addi	a3,a3,1242 # ffffffffc0205f80 <default_pmm_manager+0x600>
ffffffffc0203aae:	00001617          	auipc	a2,0x1
ffffffffc0203ab2:	40a60613          	addi	a2,a2,1034 # ffffffffc0204eb8 <commands+0x728>
ffffffffc0203ab6:	1d700593          	li	a1,471
ffffffffc0203aba:	00002517          	auipc	a0,0x2
ffffffffc0203abe:	05650513          	addi	a0,a0,86 # ffffffffc0205b10 <default_pmm_manager+0x190>
ffffffffc0203ac2:	e40fc0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W | PTE_R) == 0);
ffffffffc0203ac6:	00002697          	auipc	a3,0x2
ffffffffc0203aca:	48268693          	addi	a3,a3,1154 # ffffffffc0205f48 <default_pmm_manager+0x5c8>
ffffffffc0203ace:	00001617          	auipc	a2,0x1
ffffffffc0203ad2:	3ea60613          	addi	a2,a2,1002 # ffffffffc0204eb8 <commands+0x728>
ffffffffc0203ad6:	1d600593          	li	a1,470
ffffffffc0203ada:	00002517          	auipc	a0,0x2
ffffffffc0203ade:	03650513          	addi	a0,a0,54 # ffffffffc0205b10 <default_pmm_manager+0x190>
ffffffffc0203ae2:	e20fc0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(boot_pgdir[0] == 0);
ffffffffc0203ae6:	00002697          	auipc	a3,0x2
ffffffffc0203aea:	44a68693          	addi	a3,a3,1098 # ffffffffc0205f30 <default_pmm_manager+0x5b0>
ffffffffc0203aee:	00001617          	auipc	a2,0x1
ffffffffc0203af2:	3ca60613          	addi	a2,a2,970 # ffffffffc0204eb8 <commands+0x728>
ffffffffc0203af6:	1d200593          	li	a1,466
ffffffffc0203afa:	00002517          	auipc	a0,0x2
ffffffffc0203afe:	01650513          	addi	a0,a0,22 # ffffffffc0205b10 <default_pmm_manager+0x190>
ffffffffc0203b02:	e00fc0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(nr_free_store==nr_free_pages());
ffffffffc0203b06:	00002697          	auipc	a3,0x2
ffffffffc0203b0a:	39268693          	addi	a3,a3,914 # ffffffffc0205e98 <default_pmm_manager+0x518>
ffffffffc0203b0e:	00001617          	auipc	a2,0x1
ffffffffc0203b12:	3aa60613          	addi	a2,a2,938 # ffffffffc0204eb8 <commands+0x728>
ffffffffc0203b16:	1c000593          	li	a1,448
ffffffffc0203b1a:	00002517          	auipc	a0,0x2
ffffffffc0203b1e:	ff650513          	addi	a0,a0,-10 # ffffffffc0205b10 <default_pmm_manager+0x190>
ffffffffc0203b22:	de0fc0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(pte2page(*ptep) == p1);
ffffffffc0203b26:	00002697          	auipc	a3,0x2
ffffffffc0203b2a:	1aa68693          	addi	a3,a3,426 # ffffffffc0205cd0 <default_pmm_manager+0x350>
ffffffffc0203b2e:	00001617          	auipc	a2,0x1
ffffffffc0203b32:	38a60613          	addi	a2,a2,906 # ffffffffc0204eb8 <commands+0x728>
ffffffffc0203b36:	19b00593          	li	a1,411
ffffffffc0203b3a:	00002517          	auipc	a0,0x2
ffffffffc0203b3e:	fd650513          	addi	a0,a0,-42 # ffffffffc0205b10 <default_pmm_manager+0x190>
ffffffffc0203b42:	dc0fc0ef          	jal	ra,ffffffffc0200102 <__panic>
    ptep = (pte_t *)KADDR(PDE_ADDR(boot_pgdir[0]));
ffffffffc0203b46:	00002617          	auipc	a2,0x2
ffffffffc0203b4a:	fa260613          	addi	a2,a2,-94 # ffffffffc0205ae8 <default_pmm_manager+0x168>
ffffffffc0203b4e:	19e00593          	li	a1,414
ffffffffc0203b52:	00002517          	auipc	a0,0x2
ffffffffc0203b56:	fbe50513          	addi	a0,a0,-66 # ffffffffc0205b10 <default_pmm_manager+0x190>
ffffffffc0203b5a:	da8fc0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(page_ref(p1) == 1);
ffffffffc0203b5e:	00002697          	auipc	a3,0x2
ffffffffc0203b62:	18a68693          	addi	a3,a3,394 # ffffffffc0205ce8 <default_pmm_manager+0x368>
ffffffffc0203b66:	00001617          	auipc	a2,0x1
ffffffffc0203b6a:	35260613          	addi	a2,a2,850 # ffffffffc0204eb8 <commands+0x728>
ffffffffc0203b6e:	19c00593          	li	a1,412
ffffffffc0203b72:	00002517          	auipc	a0,0x2
ffffffffc0203b76:	f9e50513          	addi	a0,a0,-98 # ffffffffc0205b10 <default_pmm_manager+0x190>
ffffffffc0203b7a:	d88fc0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
ffffffffc0203b7e:	00002697          	auipc	a3,0x2
ffffffffc0203b82:	1e268693          	addi	a3,a3,482 # ffffffffc0205d60 <default_pmm_manager+0x3e0>
ffffffffc0203b86:	00001617          	auipc	a2,0x1
ffffffffc0203b8a:	33260613          	addi	a2,a2,818 # ffffffffc0204eb8 <commands+0x728>
ffffffffc0203b8e:	1a400593          	li	a1,420
ffffffffc0203b92:	00002517          	auipc	a0,0x2
ffffffffc0203b96:	f7e50513          	addi	a0,a0,-130 # ffffffffc0205b10 <default_pmm_manager+0x190>
ffffffffc0203b9a:	d68fc0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(strlen((const char *)0x100) == 0);
ffffffffc0203b9e:	00002697          	auipc	a3,0x2
ffffffffc0203ba2:	4a268693          	addi	a3,a3,1186 # ffffffffc0206040 <default_pmm_manager+0x6c0>
ffffffffc0203ba6:	00001617          	auipc	a2,0x1
ffffffffc0203baa:	31260613          	addi	a2,a2,786 # ffffffffc0204eb8 <commands+0x728>
ffffffffc0203bae:	1e000593          	li	a1,480
ffffffffc0203bb2:	00002517          	auipc	a0,0x2
ffffffffc0203bb6:	f5e50513          	addi	a0,a0,-162 # ffffffffc0205b10 <default_pmm_manager+0x190>
ffffffffc0203bba:	d48fc0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
ffffffffc0203bbe:	00002697          	auipc	a3,0x2
ffffffffc0203bc2:	44a68693          	addi	a3,a3,1098 # ffffffffc0206008 <default_pmm_manager+0x688>
ffffffffc0203bc6:	00001617          	auipc	a2,0x1
ffffffffc0203bca:	2f260613          	addi	a2,a2,754 # ffffffffc0204eb8 <commands+0x728>
ffffffffc0203bce:	1dd00593          	li	a1,477
ffffffffc0203bd2:	00002517          	auipc	a0,0x2
ffffffffc0203bd6:	f3e50513          	addi	a0,a0,-194 # ffffffffc0205b10 <default_pmm_manager+0x190>
ffffffffc0203bda:	d28fc0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(page_ref(p) == 2);
ffffffffc0203bde:	00002697          	auipc	a3,0x2
ffffffffc0203be2:	3fa68693          	addi	a3,a3,1018 # ffffffffc0205fd8 <default_pmm_manager+0x658>
ffffffffc0203be6:	00001617          	auipc	a2,0x1
ffffffffc0203bea:	2d260613          	addi	a2,a2,722 # ffffffffc0204eb8 <commands+0x728>
ffffffffc0203bee:	1d900593          	li	a1,473
ffffffffc0203bf2:	00002517          	auipc	a0,0x2
ffffffffc0203bf6:	f1e50513          	addi	a0,a0,-226 # ffffffffc0205b10 <default_pmm_manager+0x190>
ffffffffc0203bfa:	d08fc0ef          	jal	ra,ffffffffc0200102 <__panic>

ffffffffc0203bfe <tlb_invalidate>:
static inline void flush_tlb() { asm volatile("sfence.vma"); }
ffffffffc0203bfe:	12000073          	sfence.vma
void tlb_invalidate(pde_t *pgdir, uintptr_t la) { flush_tlb(); }
ffffffffc0203c02:	8082                	ret

ffffffffc0203c04 <pgdir_alloc_page>:
struct Page *pgdir_alloc_page(pde_t *pgdir, uintptr_t la, uint32_t perm) {
ffffffffc0203c04:	7179                	addi	sp,sp,-48
ffffffffc0203c06:	e84a                	sd	s2,16(sp)
ffffffffc0203c08:	892a                	mv	s2,a0
    struct Page *page = alloc_page();
ffffffffc0203c0a:	4505                	li	a0,1
struct Page *pgdir_alloc_page(pde_t *pgdir, uintptr_t la, uint32_t perm) {
ffffffffc0203c0c:	f022                	sd	s0,32(sp)
ffffffffc0203c0e:	ec26                	sd	s1,24(sp)
ffffffffc0203c10:	e44e                	sd	s3,8(sp)
ffffffffc0203c12:	f406                	sd	ra,40(sp)
ffffffffc0203c14:	84ae                	mv	s1,a1
ffffffffc0203c16:	89b2                	mv	s3,a2
    struct Page *page = alloc_page();
ffffffffc0203c18:	eedfe0ef          	jal	ra,ffffffffc0202b04 <alloc_pages>
ffffffffc0203c1c:	842a                	mv	s0,a0
    if (page != NULL) {
ffffffffc0203c1e:	cd09                	beqz	a0,ffffffffc0203c38 <pgdir_alloc_page+0x34>
        if (page_insert(pgdir, page, la, perm) != 0) {
ffffffffc0203c20:	85aa                	mv	a1,a0
ffffffffc0203c22:	86ce                	mv	a3,s3
ffffffffc0203c24:	8626                	mv	a2,s1
ffffffffc0203c26:	854a                	mv	a0,s2
ffffffffc0203c28:	ad2ff0ef          	jal	ra,ffffffffc0202efa <page_insert>
ffffffffc0203c2c:	ed21                	bnez	a0,ffffffffc0203c84 <pgdir_alloc_page+0x80>
        if (swap_init_ok) {
ffffffffc0203c2e:	0000e797          	auipc	a5,0xe
ffffffffc0203c32:	9027a783          	lw	a5,-1790(a5) # ffffffffc0211530 <swap_init_ok>
ffffffffc0203c36:	eb89                	bnez	a5,ffffffffc0203c48 <pgdir_alloc_page+0x44>
}
ffffffffc0203c38:	70a2                	ld	ra,40(sp)
ffffffffc0203c3a:	8522                	mv	a0,s0
ffffffffc0203c3c:	7402                	ld	s0,32(sp)
ffffffffc0203c3e:	64e2                	ld	s1,24(sp)
ffffffffc0203c40:	6942                	ld	s2,16(sp)
ffffffffc0203c42:	69a2                	ld	s3,8(sp)
ffffffffc0203c44:	6145                	addi	sp,sp,48
ffffffffc0203c46:	8082                	ret
            swap_map_swappable(check_mm_struct, la, page, 0);
ffffffffc0203c48:	4681                	li	a3,0
ffffffffc0203c4a:	8622                	mv	a2,s0
ffffffffc0203c4c:	85a6                	mv	a1,s1
ffffffffc0203c4e:	0000e517          	auipc	a0,0xe
ffffffffc0203c52:	8c253503          	ld	a0,-1854(a0) # ffffffffc0211510 <check_mm_struct>
ffffffffc0203c56:	db3fd0ef          	jal	ra,ffffffffc0201a08 <swap_map_swappable>
            assert(page_ref(page) == 1);
ffffffffc0203c5a:	4018                	lw	a4,0(s0)
            page->pra_vaddr = la;
ffffffffc0203c5c:	e024                	sd	s1,64(s0)
            assert(page_ref(page) == 1);
ffffffffc0203c5e:	4785                	li	a5,1
ffffffffc0203c60:	fcf70ce3          	beq	a4,a5,ffffffffc0203c38 <pgdir_alloc_page+0x34>
ffffffffc0203c64:	00002697          	auipc	a3,0x2
ffffffffc0203c68:	42468693          	addi	a3,a3,1060 # ffffffffc0206088 <default_pmm_manager+0x708>
ffffffffc0203c6c:	00001617          	auipc	a2,0x1
ffffffffc0203c70:	24c60613          	addi	a2,a2,588 # ffffffffc0204eb8 <commands+0x728>
ffffffffc0203c74:	17a00593          	li	a1,378
ffffffffc0203c78:	00002517          	auipc	a0,0x2
ffffffffc0203c7c:	e9850513          	addi	a0,a0,-360 # ffffffffc0205b10 <default_pmm_manager+0x190>
ffffffffc0203c80:	c82fc0ef          	jal	ra,ffffffffc0200102 <__panic>
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0203c84:	100027f3          	csrr	a5,sstatus
ffffffffc0203c88:	8b89                	andi	a5,a5,2
ffffffffc0203c8a:	eb99                	bnez	a5,ffffffffc0203ca0 <pgdir_alloc_page+0x9c>
    { pmm_manager->free_pages(base, n); }
ffffffffc0203c8c:	0000e797          	auipc	a5,0xe
ffffffffc0203c90:	8d47b783          	ld	a5,-1836(a5) # ffffffffc0211560 <pmm_manager>
ffffffffc0203c94:	739c                	ld	a5,32(a5)
ffffffffc0203c96:	8522                	mv	a0,s0
ffffffffc0203c98:	4585                	li	a1,1
ffffffffc0203c9a:	9782                	jalr	a5
            return NULL;
ffffffffc0203c9c:	4401                	li	s0,0
ffffffffc0203c9e:	bf69                	j	ffffffffc0203c38 <pgdir_alloc_page+0x34>
        intr_disable();
ffffffffc0203ca0:	84ffc0ef          	jal	ra,ffffffffc02004ee <intr_disable>
    { pmm_manager->free_pages(base, n); }
ffffffffc0203ca4:	0000e797          	auipc	a5,0xe
ffffffffc0203ca8:	8bc7b783          	ld	a5,-1860(a5) # ffffffffc0211560 <pmm_manager>
ffffffffc0203cac:	739c                	ld	a5,32(a5)
ffffffffc0203cae:	8522                	mv	a0,s0
ffffffffc0203cb0:	4585                	li	a1,1
ffffffffc0203cb2:	9782                	jalr	a5
            return NULL;
ffffffffc0203cb4:	4401                	li	s0,0
        intr_enable();
ffffffffc0203cb6:	833fc0ef          	jal	ra,ffffffffc02004e8 <intr_enable>
ffffffffc0203cba:	bfbd                	j	ffffffffc0203c38 <pgdir_alloc_page+0x34>

ffffffffc0203cbc <kmalloc>:
}

void *kmalloc(size_t n) {
ffffffffc0203cbc:	1141                	addi	sp,sp,-16
    void *ptr = NULL;
    struct Page *base = NULL;
    assert(n > 0 && n < 1024 * 0124);
ffffffffc0203cbe:	67d5                	lui	a5,0x15
void *kmalloc(size_t n) {
ffffffffc0203cc0:	e406                	sd	ra,8(sp)
    assert(n > 0 && n < 1024 * 0124);
ffffffffc0203cc2:	fff50713          	addi	a4,a0,-1
ffffffffc0203cc6:	17f9                	addi	a5,a5,-2
ffffffffc0203cc8:	04e7ea63          	bltu	a5,a4,ffffffffc0203d1c <kmalloc+0x60>
    int num_pages = (n + PGSIZE - 1) / PGSIZE;
ffffffffc0203ccc:	6785                	lui	a5,0x1
ffffffffc0203cce:	17fd                	addi	a5,a5,-1
ffffffffc0203cd0:	953e                	add	a0,a0,a5
    base = alloc_pages(num_pages);
ffffffffc0203cd2:	8131                	srli	a0,a0,0xc
ffffffffc0203cd4:	e31fe0ef          	jal	ra,ffffffffc0202b04 <alloc_pages>
    assert(base != NULL);
ffffffffc0203cd8:	cd3d                	beqz	a0,ffffffffc0203d56 <kmalloc+0x9a>
static inline ppn_t page2ppn(struct Page *page) { return page - pages + nbase; }
ffffffffc0203cda:	0000e797          	auipc	a5,0xe
ffffffffc0203cde:	87e7b783          	ld	a5,-1922(a5) # ffffffffc0211558 <pages>
ffffffffc0203ce2:	8d1d                	sub	a0,a0,a5
ffffffffc0203ce4:	00002697          	auipc	a3,0x2
ffffffffc0203ce8:	69c6b683          	ld	a3,1692(a3) # ffffffffc0206380 <error_string+0x38>
ffffffffc0203cec:	850d                	srai	a0,a0,0x3
ffffffffc0203cee:	02d50533          	mul	a0,a0,a3
ffffffffc0203cf2:	000806b7          	lui	a3,0x80
static inline void *page2kva(struct Page *page) { return KADDR(page2pa(page)); }
ffffffffc0203cf6:	0000e717          	auipc	a4,0xe
ffffffffc0203cfa:	85a73703          	ld	a4,-1958(a4) # ffffffffc0211550 <npage>
static inline ppn_t page2ppn(struct Page *page) { return page - pages + nbase; }
ffffffffc0203cfe:	9536                	add	a0,a0,a3
static inline void *page2kva(struct Page *page) { return KADDR(page2pa(page)); }
ffffffffc0203d00:	00c51793          	slli	a5,a0,0xc
ffffffffc0203d04:	83b1                	srli	a5,a5,0xc
    return page2ppn(page) << PGSHIFT;
ffffffffc0203d06:	0532                	slli	a0,a0,0xc
static inline void *page2kva(struct Page *page) { return KADDR(page2pa(page)); }
ffffffffc0203d08:	02e7fa63          	bgeu	a5,a4,ffffffffc0203d3c <kmalloc+0x80>
    ptr = page2kva(base);
    return ptr;
}
ffffffffc0203d0c:	60a2                	ld	ra,8(sp)
ffffffffc0203d0e:	0000e797          	auipc	a5,0xe
ffffffffc0203d12:	85a7b783          	ld	a5,-1958(a5) # ffffffffc0211568 <va_pa_offset>
ffffffffc0203d16:	953e                	add	a0,a0,a5
ffffffffc0203d18:	0141                	addi	sp,sp,16
ffffffffc0203d1a:	8082                	ret
    assert(n > 0 && n < 1024 * 0124);
ffffffffc0203d1c:	00002697          	auipc	a3,0x2
ffffffffc0203d20:	38468693          	addi	a3,a3,900 # ffffffffc02060a0 <default_pmm_manager+0x720>
ffffffffc0203d24:	00001617          	auipc	a2,0x1
ffffffffc0203d28:	19460613          	addi	a2,a2,404 # ffffffffc0204eb8 <commands+0x728>
ffffffffc0203d2c:	1f000593          	li	a1,496
ffffffffc0203d30:	00002517          	auipc	a0,0x2
ffffffffc0203d34:	de050513          	addi	a0,a0,-544 # ffffffffc0205b10 <default_pmm_manager+0x190>
ffffffffc0203d38:	bcafc0ef          	jal	ra,ffffffffc0200102 <__panic>
ffffffffc0203d3c:	86aa                	mv	a3,a0
ffffffffc0203d3e:	00002617          	auipc	a2,0x2
ffffffffc0203d42:	daa60613          	addi	a2,a2,-598 # ffffffffc0205ae8 <default_pmm_manager+0x168>
ffffffffc0203d46:	06a00593          	li	a1,106
ffffffffc0203d4a:	00001517          	auipc	a0,0x1
ffffffffc0203d4e:	3de50513          	addi	a0,a0,990 # ffffffffc0205128 <commands+0x998>
ffffffffc0203d52:	bb0fc0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(base != NULL);
ffffffffc0203d56:	00002697          	auipc	a3,0x2
ffffffffc0203d5a:	36a68693          	addi	a3,a3,874 # ffffffffc02060c0 <default_pmm_manager+0x740>
ffffffffc0203d5e:	00001617          	auipc	a2,0x1
ffffffffc0203d62:	15a60613          	addi	a2,a2,346 # ffffffffc0204eb8 <commands+0x728>
ffffffffc0203d66:	1f300593          	li	a1,499
ffffffffc0203d6a:	00002517          	auipc	a0,0x2
ffffffffc0203d6e:	da650513          	addi	a0,a0,-602 # ffffffffc0205b10 <default_pmm_manager+0x190>
ffffffffc0203d72:	b90fc0ef          	jal	ra,ffffffffc0200102 <__panic>

ffffffffc0203d76 <kfree>:

void kfree(void *ptr, size_t n) {
ffffffffc0203d76:	1101                	addi	sp,sp,-32
    assert(n > 0 && n < 1024 * 0124);
ffffffffc0203d78:	67d5                	lui	a5,0x15
void kfree(void *ptr, size_t n) {
ffffffffc0203d7a:	ec06                	sd	ra,24(sp)
    assert(n > 0 && n < 1024 * 0124);
ffffffffc0203d7c:	fff58713          	addi	a4,a1,-1
ffffffffc0203d80:	17f9                	addi	a5,a5,-2
ffffffffc0203d82:	0ae7ee63          	bltu	a5,a4,ffffffffc0203e3e <kfree+0xc8>
    assert(ptr != NULL);
ffffffffc0203d86:	cd41                	beqz	a0,ffffffffc0203e1e <kfree+0xa8>
    struct Page *base = NULL;
    int num_pages = (n + PGSIZE - 1) / PGSIZE;
ffffffffc0203d88:	6785                	lui	a5,0x1
ffffffffc0203d8a:	17fd                	addi	a5,a5,-1
ffffffffc0203d8c:	95be                	add	a1,a1,a5
static inline struct Page *kva2page(void *kva) { return pa2page(PADDR(kva)); }
ffffffffc0203d8e:	c02007b7          	lui	a5,0xc0200
ffffffffc0203d92:	81b1                	srli	a1,a1,0xc
ffffffffc0203d94:	06f56863          	bltu	a0,a5,ffffffffc0203e04 <kfree+0x8e>
ffffffffc0203d98:	0000d697          	auipc	a3,0xd
ffffffffc0203d9c:	7d06b683          	ld	a3,2000(a3) # ffffffffc0211568 <va_pa_offset>
ffffffffc0203da0:	8d15                	sub	a0,a0,a3
    if (PPN(pa) >= npage) {
ffffffffc0203da2:	8131                	srli	a0,a0,0xc
ffffffffc0203da4:	0000d797          	auipc	a5,0xd
ffffffffc0203da8:	7ac7b783          	ld	a5,1964(a5) # ffffffffc0211550 <npage>
ffffffffc0203dac:	04f57a63          	bgeu	a0,a5,ffffffffc0203e00 <kfree+0x8a>
    return &pages[PPN(pa) - nbase];
ffffffffc0203db0:	fff806b7          	lui	a3,0xfff80
ffffffffc0203db4:	9536                	add	a0,a0,a3
ffffffffc0203db6:	00351793          	slli	a5,a0,0x3
ffffffffc0203dba:	953e                	add	a0,a0,a5
ffffffffc0203dbc:	050e                	slli	a0,a0,0x3
ffffffffc0203dbe:	0000d797          	auipc	a5,0xd
ffffffffc0203dc2:	79a7b783          	ld	a5,1946(a5) # ffffffffc0211558 <pages>
ffffffffc0203dc6:	953e                	add	a0,a0,a5
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0203dc8:	100027f3          	csrr	a5,sstatus
ffffffffc0203dcc:	8b89                	andi	a5,a5,2
ffffffffc0203dce:	eb89                	bnez	a5,ffffffffc0203de0 <kfree+0x6a>
    { pmm_manager->free_pages(base, n); }
ffffffffc0203dd0:	0000d797          	auipc	a5,0xd
ffffffffc0203dd4:	7907b783          	ld	a5,1936(a5) # ffffffffc0211560 <pmm_manager>
    base = kva2page(ptr);
    free_pages(base, num_pages);
}
ffffffffc0203dd8:	60e2                	ld	ra,24(sp)
    { pmm_manager->free_pages(base, n); }
ffffffffc0203dda:	739c                	ld	a5,32(a5)
}
ffffffffc0203ddc:	6105                	addi	sp,sp,32
    { pmm_manager->free_pages(base, n); }
ffffffffc0203dde:	8782                	jr	a5
        intr_disable();
ffffffffc0203de0:	e42a                	sd	a0,8(sp)
ffffffffc0203de2:	e02e                	sd	a1,0(sp)
ffffffffc0203de4:	f0afc0ef          	jal	ra,ffffffffc02004ee <intr_disable>
ffffffffc0203de8:	0000d797          	auipc	a5,0xd
ffffffffc0203dec:	7787b783          	ld	a5,1912(a5) # ffffffffc0211560 <pmm_manager>
ffffffffc0203df0:	6582                	ld	a1,0(sp)
ffffffffc0203df2:	6522                	ld	a0,8(sp)
ffffffffc0203df4:	739c                	ld	a5,32(a5)
ffffffffc0203df6:	9782                	jalr	a5
}
ffffffffc0203df8:	60e2                	ld	ra,24(sp)
ffffffffc0203dfa:	6105                	addi	sp,sp,32
        intr_enable();
ffffffffc0203dfc:	eecfc06f          	j	ffffffffc02004e8 <intr_enable>
ffffffffc0203e00:	ccdfe0ef          	jal	ra,ffffffffc0202acc <pa2page.part.0>
static inline struct Page *kva2page(void *kva) { return pa2page(PADDR(kva)); }
ffffffffc0203e04:	86aa                	mv	a3,a0
ffffffffc0203e06:	00002617          	auipc	a2,0x2
ffffffffc0203e0a:	da260613          	addi	a2,a2,-606 # ffffffffc0205ba8 <default_pmm_manager+0x228>
ffffffffc0203e0e:	06c00593          	li	a1,108
ffffffffc0203e12:	00001517          	auipc	a0,0x1
ffffffffc0203e16:	31650513          	addi	a0,a0,790 # ffffffffc0205128 <commands+0x998>
ffffffffc0203e1a:	ae8fc0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(ptr != NULL);
ffffffffc0203e1e:	00002697          	auipc	a3,0x2
ffffffffc0203e22:	2b268693          	addi	a3,a3,690 # ffffffffc02060d0 <default_pmm_manager+0x750>
ffffffffc0203e26:	00001617          	auipc	a2,0x1
ffffffffc0203e2a:	09260613          	addi	a2,a2,146 # ffffffffc0204eb8 <commands+0x728>
ffffffffc0203e2e:	1fa00593          	li	a1,506
ffffffffc0203e32:	00002517          	auipc	a0,0x2
ffffffffc0203e36:	cde50513          	addi	a0,a0,-802 # ffffffffc0205b10 <default_pmm_manager+0x190>
ffffffffc0203e3a:	ac8fc0ef          	jal	ra,ffffffffc0200102 <__panic>
    assert(n > 0 && n < 1024 * 0124);
ffffffffc0203e3e:	00002697          	auipc	a3,0x2
ffffffffc0203e42:	26268693          	addi	a3,a3,610 # ffffffffc02060a0 <default_pmm_manager+0x720>
ffffffffc0203e46:	00001617          	auipc	a2,0x1
ffffffffc0203e4a:	07260613          	addi	a2,a2,114 # ffffffffc0204eb8 <commands+0x728>
ffffffffc0203e4e:	1f900593          	li	a1,505
ffffffffc0203e52:	00002517          	auipc	a0,0x2
ffffffffc0203e56:	cbe50513          	addi	a0,a0,-834 # ffffffffc0205b10 <default_pmm_manager+0x190>
ffffffffc0203e5a:	aa8fc0ef          	jal	ra,ffffffffc0200102 <__panic>

ffffffffc0203e5e <swapfs_init>:
#include <ide.h>
#include <pmm.h>
#include <assert.h>

void
swapfs_init(void) {
ffffffffc0203e5e:	1141                	addi	sp,sp,-16
    static_assert((PGSIZE % SECTSIZE) == 0);
    if (!ide_device_valid(SWAP_DEV_NO)) {
ffffffffc0203e60:	4505                	li	a0,1
swapfs_init(void) {
ffffffffc0203e62:	e406                	sd	ra,8(sp)
    if (!ide_device_valid(SWAP_DEV_NO)) {
ffffffffc0203e64:	d6efc0ef          	jal	ra,ffffffffc02003d2 <ide_device_valid>
ffffffffc0203e68:	cd01                	beqz	a0,ffffffffc0203e80 <swapfs_init+0x22>
        panic("swap fs isn't available.\n");
    }
    max_swap_offset = ide_device_size(SWAP_DEV_NO) / (PGSIZE / SECTSIZE);
ffffffffc0203e6a:	4505                	li	a0,1
ffffffffc0203e6c:	d6cfc0ef          	jal	ra,ffffffffc02003d8 <ide_device_size>
}
ffffffffc0203e70:	60a2                	ld	ra,8(sp)
    max_swap_offset = ide_device_size(SWAP_DEV_NO) / (PGSIZE / SECTSIZE);
ffffffffc0203e72:	810d                	srli	a0,a0,0x3
ffffffffc0203e74:	0000d797          	auipc	a5,0xd
ffffffffc0203e78:	6aa7b623          	sd	a0,1708(a5) # ffffffffc0211520 <max_swap_offset>
}
ffffffffc0203e7c:	0141                	addi	sp,sp,16
ffffffffc0203e7e:	8082                	ret
        panic("swap fs isn't available.\n");
ffffffffc0203e80:	00002617          	auipc	a2,0x2
ffffffffc0203e84:	26060613          	addi	a2,a2,608 # ffffffffc02060e0 <default_pmm_manager+0x760>
ffffffffc0203e88:	45b5                	li	a1,13
ffffffffc0203e8a:	00002517          	auipc	a0,0x2
ffffffffc0203e8e:	27650513          	addi	a0,a0,630 # ffffffffc0206100 <default_pmm_manager+0x780>
ffffffffc0203e92:	a70fc0ef          	jal	ra,ffffffffc0200102 <__panic>

ffffffffc0203e96 <swapfs_read>:

int
swapfs_read(swap_entry_t entry, struct Page *page) {
ffffffffc0203e96:	1141                	addi	sp,sp,-16
ffffffffc0203e98:	e406                	sd	ra,8(sp)
    return ide_read_secs(SWAP_DEV_NO, swap_offset(entry) * PAGE_NSECT, page2kva(page), PAGE_NSECT);
ffffffffc0203e9a:	00855793          	srli	a5,a0,0x8
ffffffffc0203e9e:	c3a5                	beqz	a5,ffffffffc0203efe <swapfs_read+0x68>
ffffffffc0203ea0:	0000d717          	auipc	a4,0xd
ffffffffc0203ea4:	68073703          	ld	a4,1664(a4) # ffffffffc0211520 <max_swap_offset>
ffffffffc0203ea8:	04e7fb63          	bgeu	a5,a4,ffffffffc0203efe <swapfs_read+0x68>
static inline ppn_t page2ppn(struct Page *page) { return page - pages + nbase; }
ffffffffc0203eac:	0000d617          	auipc	a2,0xd
ffffffffc0203eb0:	6ac63603          	ld	a2,1708(a2) # ffffffffc0211558 <pages>
ffffffffc0203eb4:	8d91                	sub	a1,a1,a2
ffffffffc0203eb6:	4035d613          	srai	a2,a1,0x3
ffffffffc0203eba:	00002597          	auipc	a1,0x2
ffffffffc0203ebe:	4c65b583          	ld	a1,1222(a1) # ffffffffc0206380 <error_string+0x38>
ffffffffc0203ec2:	02b60633          	mul	a2,a2,a1
ffffffffc0203ec6:	0037959b          	slliw	a1,a5,0x3
ffffffffc0203eca:	00002797          	auipc	a5,0x2
ffffffffc0203ece:	4be7b783          	ld	a5,1214(a5) # ffffffffc0206388 <nbase>
static inline void *page2kva(struct Page *page) { return KADDR(page2pa(page)); }
ffffffffc0203ed2:	0000d717          	auipc	a4,0xd
ffffffffc0203ed6:	67e73703          	ld	a4,1662(a4) # ffffffffc0211550 <npage>
static inline ppn_t page2ppn(struct Page *page) { return page - pages + nbase; }
ffffffffc0203eda:	963e                	add	a2,a2,a5
static inline void *page2kva(struct Page *page) { return KADDR(page2pa(page)); }
ffffffffc0203edc:	00c61793          	slli	a5,a2,0xc
ffffffffc0203ee0:	83b1                	srli	a5,a5,0xc
    return page2ppn(page) << PGSHIFT;
ffffffffc0203ee2:	0632                	slli	a2,a2,0xc
static inline void *page2kva(struct Page *page) { return KADDR(page2pa(page)); }
ffffffffc0203ee4:	02e7f963          	bgeu	a5,a4,ffffffffc0203f16 <swapfs_read+0x80>
}
ffffffffc0203ee8:	60a2                	ld	ra,8(sp)
    return ide_read_secs(SWAP_DEV_NO, swap_offset(entry) * PAGE_NSECT, page2kva(page), PAGE_NSECT);
ffffffffc0203eea:	0000d797          	auipc	a5,0xd
ffffffffc0203eee:	67e7b783          	ld	a5,1662(a5) # ffffffffc0211568 <va_pa_offset>
ffffffffc0203ef2:	46a1                	li	a3,8
ffffffffc0203ef4:	963e                	add	a2,a2,a5
ffffffffc0203ef6:	4505                	li	a0,1
}
ffffffffc0203ef8:	0141                	addi	sp,sp,16
    return ide_read_secs(SWAP_DEV_NO, swap_offset(entry) * PAGE_NSECT, page2kva(page), PAGE_NSECT);
ffffffffc0203efa:	ce4fc06f          	j	ffffffffc02003de <ide_read_secs>
ffffffffc0203efe:	86aa                	mv	a3,a0
ffffffffc0203f00:	00002617          	auipc	a2,0x2
ffffffffc0203f04:	21860613          	addi	a2,a2,536 # ffffffffc0206118 <default_pmm_manager+0x798>
ffffffffc0203f08:	45d1                	li	a1,20
ffffffffc0203f0a:	00002517          	auipc	a0,0x2
ffffffffc0203f0e:	1f650513          	addi	a0,a0,502 # ffffffffc0206100 <default_pmm_manager+0x780>
ffffffffc0203f12:	9f0fc0ef          	jal	ra,ffffffffc0200102 <__panic>
ffffffffc0203f16:	86b2                	mv	a3,a2
ffffffffc0203f18:	06a00593          	li	a1,106
ffffffffc0203f1c:	00002617          	auipc	a2,0x2
ffffffffc0203f20:	bcc60613          	addi	a2,a2,-1076 # ffffffffc0205ae8 <default_pmm_manager+0x168>
ffffffffc0203f24:	00001517          	auipc	a0,0x1
ffffffffc0203f28:	20450513          	addi	a0,a0,516 # ffffffffc0205128 <commands+0x998>
ffffffffc0203f2c:	9d6fc0ef          	jal	ra,ffffffffc0200102 <__panic>

ffffffffc0203f30 <swapfs_write>:

int
swapfs_write(swap_entry_t entry, struct Page *page) {
ffffffffc0203f30:	1141                	addi	sp,sp,-16
ffffffffc0203f32:	e406                	sd	ra,8(sp)
    return ide_write_secs(SWAP_DEV_NO, swap_offset(entry) * PAGE_NSECT, page2kva(page), PAGE_NSECT);
ffffffffc0203f34:	00855793          	srli	a5,a0,0x8
ffffffffc0203f38:	c3a5                	beqz	a5,ffffffffc0203f98 <swapfs_write+0x68>
ffffffffc0203f3a:	0000d717          	auipc	a4,0xd
ffffffffc0203f3e:	5e673703          	ld	a4,1510(a4) # ffffffffc0211520 <max_swap_offset>
ffffffffc0203f42:	04e7fb63          	bgeu	a5,a4,ffffffffc0203f98 <swapfs_write+0x68>
static inline ppn_t page2ppn(struct Page *page) { return page - pages + nbase; }
ffffffffc0203f46:	0000d617          	auipc	a2,0xd
ffffffffc0203f4a:	61263603          	ld	a2,1554(a2) # ffffffffc0211558 <pages>
ffffffffc0203f4e:	8d91                	sub	a1,a1,a2
ffffffffc0203f50:	4035d613          	srai	a2,a1,0x3
ffffffffc0203f54:	00002597          	auipc	a1,0x2
ffffffffc0203f58:	42c5b583          	ld	a1,1068(a1) # ffffffffc0206380 <error_string+0x38>
ffffffffc0203f5c:	02b60633          	mul	a2,a2,a1
ffffffffc0203f60:	0037959b          	slliw	a1,a5,0x3
ffffffffc0203f64:	00002797          	auipc	a5,0x2
ffffffffc0203f68:	4247b783          	ld	a5,1060(a5) # ffffffffc0206388 <nbase>
static inline void *page2kva(struct Page *page) { return KADDR(page2pa(page)); }
ffffffffc0203f6c:	0000d717          	auipc	a4,0xd
ffffffffc0203f70:	5e473703          	ld	a4,1508(a4) # ffffffffc0211550 <npage>
static inline ppn_t page2ppn(struct Page *page) { return page - pages + nbase; }
ffffffffc0203f74:	963e                	add	a2,a2,a5
static inline void *page2kva(struct Page *page) { return KADDR(page2pa(page)); }
ffffffffc0203f76:	00c61793          	slli	a5,a2,0xc
ffffffffc0203f7a:	83b1                	srli	a5,a5,0xc
    return page2ppn(page) << PGSHIFT;
ffffffffc0203f7c:	0632                	slli	a2,a2,0xc
static inline void *page2kva(struct Page *page) { return KADDR(page2pa(page)); }
ffffffffc0203f7e:	02e7f963          	bgeu	a5,a4,ffffffffc0203fb0 <swapfs_write+0x80>
}
ffffffffc0203f82:	60a2                	ld	ra,8(sp)
    return ide_write_secs(SWAP_DEV_NO, swap_offset(entry) * PAGE_NSECT, page2kva(page), PAGE_NSECT);
ffffffffc0203f84:	0000d797          	auipc	a5,0xd
ffffffffc0203f88:	5e47b783          	ld	a5,1508(a5) # ffffffffc0211568 <va_pa_offset>
ffffffffc0203f8c:	46a1                	li	a3,8
ffffffffc0203f8e:	963e                	add	a2,a2,a5
ffffffffc0203f90:	4505                	li	a0,1
}
ffffffffc0203f92:	0141                	addi	sp,sp,16
    return ide_write_secs(SWAP_DEV_NO, swap_offset(entry) * PAGE_NSECT, page2kva(page), PAGE_NSECT);
ffffffffc0203f94:	c6efc06f          	j	ffffffffc0200402 <ide_write_secs>
ffffffffc0203f98:	86aa                	mv	a3,a0
ffffffffc0203f9a:	00002617          	auipc	a2,0x2
ffffffffc0203f9e:	17e60613          	addi	a2,a2,382 # ffffffffc0206118 <default_pmm_manager+0x798>
ffffffffc0203fa2:	45e5                	li	a1,25
ffffffffc0203fa4:	00002517          	auipc	a0,0x2
ffffffffc0203fa8:	15c50513          	addi	a0,a0,348 # ffffffffc0206100 <default_pmm_manager+0x780>
ffffffffc0203fac:	956fc0ef          	jal	ra,ffffffffc0200102 <__panic>
ffffffffc0203fb0:	86b2                	mv	a3,a2
ffffffffc0203fb2:	06a00593          	li	a1,106
ffffffffc0203fb6:	00002617          	auipc	a2,0x2
ffffffffc0203fba:	b3260613          	addi	a2,a2,-1230 # ffffffffc0205ae8 <default_pmm_manager+0x168>
ffffffffc0203fbe:	00001517          	auipc	a0,0x1
ffffffffc0203fc2:	16a50513          	addi	a0,a0,362 # ffffffffc0205128 <commands+0x998>
ffffffffc0203fc6:	93cfc0ef          	jal	ra,ffffffffc0200102 <__panic>

ffffffffc0203fca <strlen>:
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
ffffffffc0203fca:	00054783          	lbu	a5,0(a0)
strlen(const char *s) {
ffffffffc0203fce:	872a                	mv	a4,a0
    size_t cnt = 0;
ffffffffc0203fd0:	4501                	li	a0,0
    while (*s ++ != '\0') {
ffffffffc0203fd2:	cb81                	beqz	a5,ffffffffc0203fe2 <strlen+0x18>
        cnt ++;
ffffffffc0203fd4:	0505                	addi	a0,a0,1
    while (*s ++ != '\0') {
ffffffffc0203fd6:	00a707b3          	add	a5,a4,a0
ffffffffc0203fda:	0007c783          	lbu	a5,0(a5)
ffffffffc0203fde:	fbfd                	bnez	a5,ffffffffc0203fd4 <strlen+0xa>
ffffffffc0203fe0:	8082                	ret
    }
    return cnt;
}
ffffffffc0203fe2:	8082                	ret

ffffffffc0203fe4 <strnlen>:
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
ffffffffc0203fe4:	4781                	li	a5,0
    while (cnt < len && *s ++ != '\0') {
ffffffffc0203fe6:	e589                	bnez	a1,ffffffffc0203ff0 <strnlen+0xc>
ffffffffc0203fe8:	a811                	j	ffffffffc0203ffc <strnlen+0x18>
        cnt ++;
ffffffffc0203fea:	0785                	addi	a5,a5,1
    while (cnt < len && *s ++ != '\0') {
ffffffffc0203fec:	00f58863          	beq	a1,a5,ffffffffc0203ffc <strnlen+0x18>
ffffffffc0203ff0:	00f50733          	add	a4,a0,a5
ffffffffc0203ff4:	00074703          	lbu	a4,0(a4)
ffffffffc0203ff8:	fb6d                	bnez	a4,ffffffffc0203fea <strnlen+0x6>
ffffffffc0203ffa:	85be                	mv	a1,a5
    }
    return cnt;
}
ffffffffc0203ffc:	852e                	mv	a0,a1
ffffffffc0203ffe:	8082                	ret

ffffffffc0204000 <strcpy>:
char *
strcpy(char *dst, const char *src) {
#ifdef __HAVE_ARCH_STRCPY
    return __strcpy(dst, src);
#else
    char *p = dst;
ffffffffc0204000:	87aa                	mv	a5,a0
    while ((*p ++ = *src ++) != '\0')
ffffffffc0204002:	0005c703          	lbu	a4,0(a1)
ffffffffc0204006:	0785                	addi	a5,a5,1
ffffffffc0204008:	0585                	addi	a1,a1,1
ffffffffc020400a:	fee78fa3          	sb	a4,-1(a5)
ffffffffc020400e:	fb75                	bnez	a4,ffffffffc0204002 <strcpy+0x2>
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
ffffffffc0204010:	8082                	ret

ffffffffc0204012 <strcmp>:
int
strcmp(const char *s1, const char *s2) {
#ifdef __HAVE_ARCH_STRCMP
    return __strcmp(s1, s2);
#else
    while (*s1 != '\0' && *s1 == *s2) {
ffffffffc0204012:	00054783          	lbu	a5,0(a0)
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc0204016:	0005c703          	lbu	a4,0(a1)
    while (*s1 != '\0' && *s1 == *s2) {
ffffffffc020401a:	cb89                	beqz	a5,ffffffffc020402c <strcmp+0x1a>
        s1 ++, s2 ++;
ffffffffc020401c:	0505                	addi	a0,a0,1
ffffffffc020401e:	0585                	addi	a1,a1,1
    while (*s1 != '\0' && *s1 == *s2) {
ffffffffc0204020:	fee789e3          	beq	a5,a4,ffffffffc0204012 <strcmp>
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc0204024:	0007851b          	sext.w	a0,a5
#endif /* __HAVE_ARCH_STRCMP */
}
ffffffffc0204028:	9d19                	subw	a0,a0,a4
ffffffffc020402a:	8082                	ret
ffffffffc020402c:	4501                	li	a0,0
ffffffffc020402e:	bfed                	j	ffffffffc0204028 <strcmp+0x16>

ffffffffc0204030 <strchr>:
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
ffffffffc0204030:	00054783          	lbu	a5,0(a0)
ffffffffc0204034:	c799                	beqz	a5,ffffffffc0204042 <strchr+0x12>
        if (*s == c) {
ffffffffc0204036:	00f58763          	beq	a1,a5,ffffffffc0204044 <strchr+0x14>
    while (*s != '\0') {
ffffffffc020403a:	00154783          	lbu	a5,1(a0)
            return (char *)s;
        }
        s ++;
ffffffffc020403e:	0505                	addi	a0,a0,1
    while (*s != '\0') {
ffffffffc0204040:	fbfd                	bnez	a5,ffffffffc0204036 <strchr+0x6>
    }
    return NULL;
ffffffffc0204042:	4501                	li	a0,0
}
ffffffffc0204044:	8082                	ret

ffffffffc0204046 <memset>:
memset(void *s, char c, size_t n) {
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
#else
    char *p = s;
    while (n -- > 0) {
ffffffffc0204046:	ca01                	beqz	a2,ffffffffc0204056 <memset+0x10>
ffffffffc0204048:	962a                	add	a2,a2,a0
    char *p = s;
ffffffffc020404a:	87aa                	mv	a5,a0
        *p ++ = c;
ffffffffc020404c:	0785                	addi	a5,a5,1
ffffffffc020404e:	feb78fa3          	sb	a1,-1(a5)
    while (n -- > 0) {
ffffffffc0204052:	fec79de3          	bne	a5,a2,ffffffffc020404c <memset+0x6>
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
ffffffffc0204056:	8082                	ret

ffffffffc0204058 <memcpy>:
#ifdef __HAVE_ARCH_MEMCPY
    return __memcpy(dst, src, n);
#else
    const char *s = src;
    char *d = dst;
    while (n -- > 0) {
ffffffffc0204058:	ca19                	beqz	a2,ffffffffc020406e <memcpy+0x16>
ffffffffc020405a:	962e                	add	a2,a2,a1
    char *d = dst;
ffffffffc020405c:	87aa                	mv	a5,a0
        *d ++ = *s ++;
ffffffffc020405e:	0005c703          	lbu	a4,0(a1)
ffffffffc0204062:	0585                	addi	a1,a1,1
ffffffffc0204064:	0785                	addi	a5,a5,1
ffffffffc0204066:	fee78fa3          	sb	a4,-1(a5)
    while (n -- > 0) {
ffffffffc020406a:	fec59ae3          	bne	a1,a2,ffffffffc020405e <memcpy+0x6>
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
ffffffffc020406e:	8082                	ret

ffffffffc0204070 <printnum>:
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
    unsigned long long result = num;
    unsigned mod = do_div(result, base);
ffffffffc0204070:	02069813          	slli	a6,a3,0x20
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc0204074:	7179                	addi	sp,sp,-48
    unsigned mod = do_div(result, base);
ffffffffc0204076:	02085813          	srli	a6,a6,0x20
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc020407a:	e052                	sd	s4,0(sp)
    unsigned mod = do_div(result, base);
ffffffffc020407c:	03067a33          	remu	s4,a2,a6
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc0204080:	f022                	sd	s0,32(sp)
ffffffffc0204082:	ec26                	sd	s1,24(sp)
ffffffffc0204084:	e84a                	sd	s2,16(sp)
ffffffffc0204086:	f406                	sd	ra,40(sp)
ffffffffc0204088:	e44e                	sd	s3,8(sp)
ffffffffc020408a:	84aa                	mv	s1,a0
ffffffffc020408c:	892e                	mv	s2,a1
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
ffffffffc020408e:	fff7041b          	addiw	s0,a4,-1
    unsigned mod = do_div(result, base);
ffffffffc0204092:	2a01                	sext.w	s4,s4
    if (num >= base) {
ffffffffc0204094:	03067e63          	bgeu	a2,a6,ffffffffc02040d0 <printnum+0x60>
ffffffffc0204098:	89be                	mv	s3,a5
        while (-- width > 0)
ffffffffc020409a:	00805763          	blez	s0,ffffffffc02040a8 <printnum+0x38>
ffffffffc020409e:	347d                	addiw	s0,s0,-1
            putch(padc, putdat);
ffffffffc02040a0:	85ca                	mv	a1,s2
ffffffffc02040a2:	854e                	mv	a0,s3
ffffffffc02040a4:	9482                	jalr	s1
        while (-- width > 0)
ffffffffc02040a6:	fc65                	bnez	s0,ffffffffc020409e <printnum+0x2e>
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
ffffffffc02040a8:	1a02                	slli	s4,s4,0x20
ffffffffc02040aa:	00002797          	auipc	a5,0x2
ffffffffc02040ae:	08e78793          	addi	a5,a5,142 # ffffffffc0206138 <default_pmm_manager+0x7b8>
ffffffffc02040b2:	020a5a13          	srli	s4,s4,0x20
ffffffffc02040b6:	9a3e                	add	s4,s4,a5
}
ffffffffc02040b8:	7402                	ld	s0,32(sp)
    putch("0123456789abcdef"[mod], putdat);
ffffffffc02040ba:	000a4503          	lbu	a0,0(s4)
}
ffffffffc02040be:	70a2                	ld	ra,40(sp)
ffffffffc02040c0:	69a2                	ld	s3,8(sp)
ffffffffc02040c2:	6a02                	ld	s4,0(sp)
    putch("0123456789abcdef"[mod], putdat);
ffffffffc02040c4:	85ca                	mv	a1,s2
ffffffffc02040c6:	87a6                	mv	a5,s1
}
ffffffffc02040c8:	6942                	ld	s2,16(sp)
ffffffffc02040ca:	64e2                	ld	s1,24(sp)
ffffffffc02040cc:	6145                	addi	sp,sp,48
    putch("0123456789abcdef"[mod], putdat);
ffffffffc02040ce:	8782                	jr	a5
        printnum(putch, putdat, result, base, width - 1, padc);
ffffffffc02040d0:	03065633          	divu	a2,a2,a6
ffffffffc02040d4:	8722                	mv	a4,s0
ffffffffc02040d6:	f9bff0ef          	jal	ra,ffffffffc0204070 <printnum>
ffffffffc02040da:	b7f9                	j	ffffffffc02040a8 <printnum+0x38>

ffffffffc02040dc <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
ffffffffc02040dc:	7119                	addi	sp,sp,-128
ffffffffc02040de:	f4a6                	sd	s1,104(sp)
ffffffffc02040e0:	f0ca                	sd	s2,96(sp)
ffffffffc02040e2:	ecce                	sd	s3,88(sp)
ffffffffc02040e4:	e8d2                	sd	s4,80(sp)
ffffffffc02040e6:	e4d6                	sd	s5,72(sp)
ffffffffc02040e8:	e0da                	sd	s6,64(sp)
ffffffffc02040ea:	fc5e                	sd	s7,56(sp)
ffffffffc02040ec:	f06a                	sd	s10,32(sp)
ffffffffc02040ee:	fc86                	sd	ra,120(sp)
ffffffffc02040f0:	f8a2                	sd	s0,112(sp)
ffffffffc02040f2:	f862                	sd	s8,48(sp)
ffffffffc02040f4:	f466                	sd	s9,40(sp)
ffffffffc02040f6:	ec6e                	sd	s11,24(sp)
ffffffffc02040f8:	892a                	mv	s2,a0
ffffffffc02040fa:	84ae                	mv	s1,a1
ffffffffc02040fc:	8d32                	mv	s10,a2
ffffffffc02040fe:	8a36                	mv	s4,a3
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc0204100:	02500993          	li	s3,37
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
        width = precision = -1;
ffffffffc0204104:	5b7d                	li	s6,-1
ffffffffc0204106:	00002a97          	auipc	s5,0x2
ffffffffc020410a:	066a8a93          	addi	s5,s5,102 # ffffffffc020616c <default_pmm_manager+0x7ec>
        case 'e':
            err = va_arg(ap, int);
            if (err < 0) {
                err = -err;
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
ffffffffc020410e:	00002b97          	auipc	s7,0x2
ffffffffc0204112:	23ab8b93          	addi	s7,s7,570 # ffffffffc0206348 <error_string>
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc0204116:	000d4503          	lbu	a0,0(s10) # 80000 <kern_entry-0xffffffffc0180000>
ffffffffc020411a:	001d0413          	addi	s0,s10,1
ffffffffc020411e:	01350a63          	beq	a0,s3,ffffffffc0204132 <vprintfmt+0x56>
            if (ch == '\0') {
ffffffffc0204122:	c121                	beqz	a0,ffffffffc0204162 <vprintfmt+0x86>
            putch(ch, putdat);
ffffffffc0204124:	85a6                	mv	a1,s1
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc0204126:	0405                	addi	s0,s0,1
            putch(ch, putdat);
ffffffffc0204128:	9902                	jalr	s2
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc020412a:	fff44503          	lbu	a0,-1(s0)
ffffffffc020412e:	ff351ae3          	bne	a0,s3,ffffffffc0204122 <vprintfmt+0x46>
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0204132:	00044603          	lbu	a2,0(s0)
        char padc = ' ';
ffffffffc0204136:	02000793          	li	a5,32
        lflag = altflag = 0;
ffffffffc020413a:	4c81                	li	s9,0
ffffffffc020413c:	4881                	li	a7,0
        width = precision = -1;
ffffffffc020413e:	5c7d                	li	s8,-1
ffffffffc0204140:	5dfd                	li	s11,-1
ffffffffc0204142:	05500513          	li	a0,85
                if (ch < '0' || ch > '9') {
ffffffffc0204146:	4825                	li	a6,9
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0204148:	fdd6059b          	addiw	a1,a2,-35
ffffffffc020414c:	0ff5f593          	zext.b	a1,a1
ffffffffc0204150:	00140d13          	addi	s10,s0,1
ffffffffc0204154:	04b56263          	bltu	a0,a1,ffffffffc0204198 <vprintfmt+0xbc>
ffffffffc0204158:	058a                	slli	a1,a1,0x2
ffffffffc020415a:	95d6                	add	a1,a1,s5
ffffffffc020415c:	4194                	lw	a3,0(a1)
ffffffffc020415e:	96d6                	add	a3,a3,s5
ffffffffc0204160:	8682                	jr	a3
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
ffffffffc0204162:	70e6                	ld	ra,120(sp)
ffffffffc0204164:	7446                	ld	s0,112(sp)
ffffffffc0204166:	74a6                	ld	s1,104(sp)
ffffffffc0204168:	7906                	ld	s2,96(sp)
ffffffffc020416a:	69e6                	ld	s3,88(sp)
ffffffffc020416c:	6a46                	ld	s4,80(sp)
ffffffffc020416e:	6aa6                	ld	s5,72(sp)
ffffffffc0204170:	6b06                	ld	s6,64(sp)
ffffffffc0204172:	7be2                	ld	s7,56(sp)
ffffffffc0204174:	7c42                	ld	s8,48(sp)
ffffffffc0204176:	7ca2                	ld	s9,40(sp)
ffffffffc0204178:	7d02                	ld	s10,32(sp)
ffffffffc020417a:	6de2                	ld	s11,24(sp)
ffffffffc020417c:	6109                	addi	sp,sp,128
ffffffffc020417e:	8082                	ret
            padc = '0';
ffffffffc0204180:	87b2                	mv	a5,a2
            goto reswitch;
ffffffffc0204182:	00144603          	lbu	a2,1(s0)
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0204186:	846a                	mv	s0,s10
ffffffffc0204188:	00140d13          	addi	s10,s0,1
ffffffffc020418c:	fdd6059b          	addiw	a1,a2,-35
ffffffffc0204190:	0ff5f593          	zext.b	a1,a1
ffffffffc0204194:	fcb572e3          	bgeu	a0,a1,ffffffffc0204158 <vprintfmt+0x7c>
            putch('%', putdat);
ffffffffc0204198:	85a6                	mv	a1,s1
ffffffffc020419a:	02500513          	li	a0,37
ffffffffc020419e:	9902                	jalr	s2
            for (fmt --; fmt[-1] != '%'; fmt --)
ffffffffc02041a0:	fff44783          	lbu	a5,-1(s0)
ffffffffc02041a4:	8d22                	mv	s10,s0
ffffffffc02041a6:	f73788e3          	beq	a5,s3,ffffffffc0204116 <vprintfmt+0x3a>
ffffffffc02041aa:	ffed4783          	lbu	a5,-2(s10)
ffffffffc02041ae:	1d7d                	addi	s10,s10,-1
ffffffffc02041b0:	ff379de3          	bne	a5,s3,ffffffffc02041aa <vprintfmt+0xce>
ffffffffc02041b4:	b78d                	j	ffffffffc0204116 <vprintfmt+0x3a>
                precision = precision * 10 + ch - '0';
ffffffffc02041b6:	fd060c1b          	addiw	s8,a2,-48
                ch = *fmt;
ffffffffc02041ba:	00144603          	lbu	a2,1(s0)
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc02041be:	846a                	mv	s0,s10
                if (ch < '0' || ch > '9') {
ffffffffc02041c0:	fd06069b          	addiw	a3,a2,-48
                ch = *fmt;
ffffffffc02041c4:	0006059b          	sext.w	a1,a2
                if (ch < '0' || ch > '9') {
ffffffffc02041c8:	02d86463          	bltu	a6,a3,ffffffffc02041f0 <vprintfmt+0x114>
                ch = *fmt;
ffffffffc02041cc:	00144603          	lbu	a2,1(s0)
                precision = precision * 10 + ch - '0';
ffffffffc02041d0:	002c169b          	slliw	a3,s8,0x2
ffffffffc02041d4:	0186873b          	addw	a4,a3,s8
ffffffffc02041d8:	0017171b          	slliw	a4,a4,0x1
ffffffffc02041dc:	9f2d                	addw	a4,a4,a1
                if (ch < '0' || ch > '9') {
ffffffffc02041de:	fd06069b          	addiw	a3,a2,-48
            for (precision = 0; ; ++ fmt) {
ffffffffc02041e2:	0405                	addi	s0,s0,1
                precision = precision * 10 + ch - '0';
ffffffffc02041e4:	fd070c1b          	addiw	s8,a4,-48
                ch = *fmt;
ffffffffc02041e8:	0006059b          	sext.w	a1,a2
                if (ch < '0' || ch > '9') {
ffffffffc02041ec:	fed870e3          	bgeu	a6,a3,ffffffffc02041cc <vprintfmt+0xf0>
            if (width < 0)
ffffffffc02041f0:	f40ddce3          	bgez	s11,ffffffffc0204148 <vprintfmt+0x6c>
                width = precision, precision = -1;
ffffffffc02041f4:	8de2                	mv	s11,s8
ffffffffc02041f6:	5c7d                	li	s8,-1
ffffffffc02041f8:	bf81                	j	ffffffffc0204148 <vprintfmt+0x6c>
            if (width < 0)
ffffffffc02041fa:	fffdc693          	not	a3,s11
ffffffffc02041fe:	96fd                	srai	a3,a3,0x3f
ffffffffc0204200:	00ddfdb3          	and	s11,s11,a3
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0204204:	00144603          	lbu	a2,1(s0)
ffffffffc0204208:	2d81                	sext.w	s11,s11
ffffffffc020420a:	846a                	mv	s0,s10
            goto reswitch;
ffffffffc020420c:	bf35                	j	ffffffffc0204148 <vprintfmt+0x6c>
            precision = va_arg(ap, int);
ffffffffc020420e:	000a2c03          	lw	s8,0(s4)
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0204212:	00144603          	lbu	a2,1(s0)
            precision = va_arg(ap, int);
ffffffffc0204216:	0a21                	addi	s4,s4,8
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0204218:	846a                	mv	s0,s10
            goto process_precision;
ffffffffc020421a:	bfd9                	j	ffffffffc02041f0 <vprintfmt+0x114>
    if (lflag >= 2) {
ffffffffc020421c:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc020421e:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
ffffffffc0204222:	01174463          	blt	a4,a7,ffffffffc020422a <vprintfmt+0x14e>
    else if (lflag) {
ffffffffc0204226:	1a088e63          	beqz	a7,ffffffffc02043e2 <vprintfmt+0x306>
        return va_arg(*ap, unsigned long);
ffffffffc020422a:	000a3603          	ld	a2,0(s4)
ffffffffc020422e:	46c1                	li	a3,16
ffffffffc0204230:	8a2e                	mv	s4,a1
            printnum(putch, putdat, num, base, width, padc);
ffffffffc0204232:	2781                	sext.w	a5,a5
ffffffffc0204234:	876e                	mv	a4,s11
ffffffffc0204236:	85a6                	mv	a1,s1
ffffffffc0204238:	854a                	mv	a0,s2
ffffffffc020423a:	e37ff0ef          	jal	ra,ffffffffc0204070 <printnum>
            break;
ffffffffc020423e:	bde1                	j	ffffffffc0204116 <vprintfmt+0x3a>
            putch(va_arg(ap, int), putdat);
ffffffffc0204240:	000a2503          	lw	a0,0(s4)
ffffffffc0204244:	85a6                	mv	a1,s1
ffffffffc0204246:	0a21                	addi	s4,s4,8
ffffffffc0204248:	9902                	jalr	s2
            break;
ffffffffc020424a:	b5f1                	j	ffffffffc0204116 <vprintfmt+0x3a>
    if (lflag >= 2) {
ffffffffc020424c:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc020424e:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
ffffffffc0204252:	01174463          	blt	a4,a7,ffffffffc020425a <vprintfmt+0x17e>
    else if (lflag) {
ffffffffc0204256:	18088163          	beqz	a7,ffffffffc02043d8 <vprintfmt+0x2fc>
        return va_arg(*ap, unsigned long);
ffffffffc020425a:	000a3603          	ld	a2,0(s4)
ffffffffc020425e:	46a9                	li	a3,10
ffffffffc0204260:	8a2e                	mv	s4,a1
ffffffffc0204262:	bfc1                	j	ffffffffc0204232 <vprintfmt+0x156>
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0204264:	00144603          	lbu	a2,1(s0)
            altflag = 1;
ffffffffc0204268:	4c85                	li	s9,1
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc020426a:	846a                	mv	s0,s10
            goto reswitch;
ffffffffc020426c:	bdf1                	j	ffffffffc0204148 <vprintfmt+0x6c>
            putch(ch, putdat);
ffffffffc020426e:	85a6                	mv	a1,s1
ffffffffc0204270:	02500513          	li	a0,37
ffffffffc0204274:	9902                	jalr	s2
            break;
ffffffffc0204276:	b545                	j	ffffffffc0204116 <vprintfmt+0x3a>
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0204278:	00144603          	lbu	a2,1(s0)
            lflag ++;
ffffffffc020427c:	2885                	addiw	a7,a7,1
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc020427e:	846a                	mv	s0,s10
            goto reswitch;
ffffffffc0204280:	b5e1                	j	ffffffffc0204148 <vprintfmt+0x6c>
    if (lflag >= 2) {
ffffffffc0204282:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc0204284:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
ffffffffc0204288:	01174463          	blt	a4,a7,ffffffffc0204290 <vprintfmt+0x1b4>
    else if (lflag) {
ffffffffc020428c:	14088163          	beqz	a7,ffffffffc02043ce <vprintfmt+0x2f2>
        return va_arg(*ap, unsigned long);
ffffffffc0204290:	000a3603          	ld	a2,0(s4)
ffffffffc0204294:	46a1                	li	a3,8
ffffffffc0204296:	8a2e                	mv	s4,a1
ffffffffc0204298:	bf69                	j	ffffffffc0204232 <vprintfmt+0x156>
            putch('0', putdat);
ffffffffc020429a:	03000513          	li	a0,48
ffffffffc020429e:	85a6                	mv	a1,s1
ffffffffc02042a0:	e03e                	sd	a5,0(sp)
ffffffffc02042a2:	9902                	jalr	s2
            putch('x', putdat);
ffffffffc02042a4:	85a6                	mv	a1,s1
ffffffffc02042a6:	07800513          	li	a0,120
ffffffffc02042aa:	9902                	jalr	s2
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
ffffffffc02042ac:	0a21                	addi	s4,s4,8
            goto number;
ffffffffc02042ae:	6782                	ld	a5,0(sp)
ffffffffc02042b0:	46c1                	li	a3,16
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
ffffffffc02042b2:	ff8a3603          	ld	a2,-8(s4)
            goto number;
ffffffffc02042b6:	bfb5                	j	ffffffffc0204232 <vprintfmt+0x156>
            if ((p = va_arg(ap, char *)) == NULL) {
ffffffffc02042b8:	000a3403          	ld	s0,0(s4)
ffffffffc02042bc:	008a0713          	addi	a4,s4,8
ffffffffc02042c0:	e03a                	sd	a4,0(sp)
ffffffffc02042c2:	14040263          	beqz	s0,ffffffffc0204406 <vprintfmt+0x32a>
            if (width > 0 && padc != '-') {
ffffffffc02042c6:	0fb05763          	blez	s11,ffffffffc02043b4 <vprintfmt+0x2d8>
ffffffffc02042ca:	02d00693          	li	a3,45
ffffffffc02042ce:	0cd79163          	bne	a5,a3,ffffffffc0204390 <vprintfmt+0x2b4>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc02042d2:	00044783          	lbu	a5,0(s0)
ffffffffc02042d6:	0007851b          	sext.w	a0,a5
ffffffffc02042da:	cf85                	beqz	a5,ffffffffc0204312 <vprintfmt+0x236>
ffffffffc02042dc:	00140a13          	addi	s4,s0,1
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc02042e0:	05e00413          	li	s0,94
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc02042e4:	000c4563          	bltz	s8,ffffffffc02042ee <vprintfmt+0x212>
ffffffffc02042e8:	3c7d                	addiw	s8,s8,-1
ffffffffc02042ea:	036c0263          	beq	s8,s6,ffffffffc020430e <vprintfmt+0x232>
                    putch('?', putdat);
ffffffffc02042ee:	85a6                	mv	a1,s1
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc02042f0:	0e0c8e63          	beqz	s9,ffffffffc02043ec <vprintfmt+0x310>
ffffffffc02042f4:	3781                	addiw	a5,a5,-32
ffffffffc02042f6:	0ef47b63          	bgeu	s0,a5,ffffffffc02043ec <vprintfmt+0x310>
                    putch('?', putdat);
ffffffffc02042fa:	03f00513          	li	a0,63
ffffffffc02042fe:	9902                	jalr	s2
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0204300:	000a4783          	lbu	a5,0(s4)
ffffffffc0204304:	3dfd                	addiw	s11,s11,-1
ffffffffc0204306:	0a05                	addi	s4,s4,1
ffffffffc0204308:	0007851b          	sext.w	a0,a5
ffffffffc020430c:	ffe1                	bnez	a5,ffffffffc02042e4 <vprintfmt+0x208>
            for (; width > 0; width --) {
ffffffffc020430e:	01b05963          	blez	s11,ffffffffc0204320 <vprintfmt+0x244>
ffffffffc0204312:	3dfd                	addiw	s11,s11,-1
                putch(' ', putdat);
ffffffffc0204314:	85a6                	mv	a1,s1
ffffffffc0204316:	02000513          	li	a0,32
ffffffffc020431a:	9902                	jalr	s2
            for (; width > 0; width --) {
ffffffffc020431c:	fe0d9be3          	bnez	s11,ffffffffc0204312 <vprintfmt+0x236>
            if ((p = va_arg(ap, char *)) == NULL) {
ffffffffc0204320:	6a02                	ld	s4,0(sp)
ffffffffc0204322:	bbd5                	j	ffffffffc0204116 <vprintfmt+0x3a>
    if (lflag >= 2) {
ffffffffc0204324:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc0204326:	008a0c93          	addi	s9,s4,8
    if (lflag >= 2) {
ffffffffc020432a:	01174463          	blt	a4,a7,ffffffffc0204332 <vprintfmt+0x256>
    else if (lflag) {
ffffffffc020432e:	08088d63          	beqz	a7,ffffffffc02043c8 <vprintfmt+0x2ec>
        return va_arg(*ap, long);
ffffffffc0204332:	000a3403          	ld	s0,0(s4)
            if ((long long)num < 0) {
ffffffffc0204336:	0a044d63          	bltz	s0,ffffffffc02043f0 <vprintfmt+0x314>
            num = getint(&ap, lflag);
ffffffffc020433a:	8622                	mv	a2,s0
ffffffffc020433c:	8a66                	mv	s4,s9
ffffffffc020433e:	46a9                	li	a3,10
ffffffffc0204340:	bdcd                	j	ffffffffc0204232 <vprintfmt+0x156>
            err = va_arg(ap, int);
ffffffffc0204342:	000a2783          	lw	a5,0(s4)
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
ffffffffc0204346:	4719                	li	a4,6
            err = va_arg(ap, int);
ffffffffc0204348:	0a21                	addi	s4,s4,8
            if (err < 0) {
ffffffffc020434a:	41f7d69b          	sraiw	a3,a5,0x1f
ffffffffc020434e:	8fb5                	xor	a5,a5,a3
ffffffffc0204350:	40d786bb          	subw	a3,a5,a3
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
ffffffffc0204354:	02d74163          	blt	a4,a3,ffffffffc0204376 <vprintfmt+0x29a>
ffffffffc0204358:	00369793          	slli	a5,a3,0x3
ffffffffc020435c:	97de                	add	a5,a5,s7
ffffffffc020435e:	639c                	ld	a5,0(a5)
ffffffffc0204360:	cb99                	beqz	a5,ffffffffc0204376 <vprintfmt+0x29a>
                printfmt(putch, putdat, "%s", p);
ffffffffc0204362:	86be                	mv	a3,a5
ffffffffc0204364:	00002617          	auipc	a2,0x2
ffffffffc0204368:	e0460613          	addi	a2,a2,-508 # ffffffffc0206168 <default_pmm_manager+0x7e8>
ffffffffc020436c:	85a6                	mv	a1,s1
ffffffffc020436e:	854a                	mv	a0,s2
ffffffffc0204370:	0ce000ef          	jal	ra,ffffffffc020443e <printfmt>
ffffffffc0204374:	b34d                	j	ffffffffc0204116 <vprintfmt+0x3a>
                printfmt(putch, putdat, "error %d", err);
ffffffffc0204376:	00002617          	auipc	a2,0x2
ffffffffc020437a:	de260613          	addi	a2,a2,-542 # ffffffffc0206158 <default_pmm_manager+0x7d8>
ffffffffc020437e:	85a6                	mv	a1,s1
ffffffffc0204380:	854a                	mv	a0,s2
ffffffffc0204382:	0bc000ef          	jal	ra,ffffffffc020443e <printfmt>
ffffffffc0204386:	bb41                	j	ffffffffc0204116 <vprintfmt+0x3a>
                p = "(null)";
ffffffffc0204388:	00002417          	auipc	s0,0x2
ffffffffc020438c:	dc840413          	addi	s0,s0,-568 # ffffffffc0206150 <default_pmm_manager+0x7d0>
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc0204390:	85e2                	mv	a1,s8
ffffffffc0204392:	8522                	mv	a0,s0
ffffffffc0204394:	e43e                	sd	a5,8(sp)
ffffffffc0204396:	c4fff0ef          	jal	ra,ffffffffc0203fe4 <strnlen>
ffffffffc020439a:	40ad8dbb          	subw	s11,s11,a0
ffffffffc020439e:	01b05b63          	blez	s11,ffffffffc02043b4 <vprintfmt+0x2d8>
                    putch(padc, putdat);
ffffffffc02043a2:	67a2                	ld	a5,8(sp)
ffffffffc02043a4:	00078a1b          	sext.w	s4,a5
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc02043a8:	3dfd                	addiw	s11,s11,-1
                    putch(padc, putdat);
ffffffffc02043aa:	85a6                	mv	a1,s1
ffffffffc02043ac:	8552                	mv	a0,s4
ffffffffc02043ae:	9902                	jalr	s2
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc02043b0:	fe0d9ce3          	bnez	s11,ffffffffc02043a8 <vprintfmt+0x2cc>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc02043b4:	00044783          	lbu	a5,0(s0)
ffffffffc02043b8:	00140a13          	addi	s4,s0,1
ffffffffc02043bc:	0007851b          	sext.w	a0,a5
ffffffffc02043c0:	d3a5                	beqz	a5,ffffffffc0204320 <vprintfmt+0x244>
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc02043c2:	05e00413          	li	s0,94
ffffffffc02043c6:	bf39                	j	ffffffffc02042e4 <vprintfmt+0x208>
        return va_arg(*ap, int);
ffffffffc02043c8:	000a2403          	lw	s0,0(s4)
ffffffffc02043cc:	b7ad                	j	ffffffffc0204336 <vprintfmt+0x25a>
        return va_arg(*ap, unsigned int);
ffffffffc02043ce:	000a6603          	lwu	a2,0(s4)
ffffffffc02043d2:	46a1                	li	a3,8
ffffffffc02043d4:	8a2e                	mv	s4,a1
ffffffffc02043d6:	bdb1                	j	ffffffffc0204232 <vprintfmt+0x156>
ffffffffc02043d8:	000a6603          	lwu	a2,0(s4)
ffffffffc02043dc:	46a9                	li	a3,10
ffffffffc02043de:	8a2e                	mv	s4,a1
ffffffffc02043e0:	bd89                	j	ffffffffc0204232 <vprintfmt+0x156>
ffffffffc02043e2:	000a6603          	lwu	a2,0(s4)
ffffffffc02043e6:	46c1                	li	a3,16
ffffffffc02043e8:	8a2e                	mv	s4,a1
ffffffffc02043ea:	b5a1                	j	ffffffffc0204232 <vprintfmt+0x156>
                    putch(ch, putdat);
ffffffffc02043ec:	9902                	jalr	s2
ffffffffc02043ee:	bf09                	j	ffffffffc0204300 <vprintfmt+0x224>
                putch('-', putdat);
ffffffffc02043f0:	85a6                	mv	a1,s1
ffffffffc02043f2:	02d00513          	li	a0,45
ffffffffc02043f6:	e03e                	sd	a5,0(sp)
ffffffffc02043f8:	9902                	jalr	s2
                num = -(long long)num;
ffffffffc02043fa:	6782                	ld	a5,0(sp)
ffffffffc02043fc:	8a66                	mv	s4,s9
ffffffffc02043fe:	40800633          	neg	a2,s0
ffffffffc0204402:	46a9                	li	a3,10
ffffffffc0204404:	b53d                	j	ffffffffc0204232 <vprintfmt+0x156>
            if (width > 0 && padc != '-') {
ffffffffc0204406:	03b05163          	blez	s11,ffffffffc0204428 <vprintfmt+0x34c>
ffffffffc020440a:	02d00693          	li	a3,45
ffffffffc020440e:	f6d79de3          	bne	a5,a3,ffffffffc0204388 <vprintfmt+0x2ac>
                p = "(null)";
ffffffffc0204412:	00002417          	auipc	s0,0x2
ffffffffc0204416:	d3e40413          	addi	s0,s0,-706 # ffffffffc0206150 <default_pmm_manager+0x7d0>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc020441a:	02800793          	li	a5,40
ffffffffc020441e:	02800513          	li	a0,40
ffffffffc0204422:	00140a13          	addi	s4,s0,1
ffffffffc0204426:	bd6d                	j	ffffffffc02042e0 <vprintfmt+0x204>
ffffffffc0204428:	00002a17          	auipc	s4,0x2
ffffffffc020442c:	d29a0a13          	addi	s4,s4,-727 # ffffffffc0206151 <default_pmm_manager+0x7d1>
ffffffffc0204430:	02800513          	li	a0,40
ffffffffc0204434:	02800793          	li	a5,40
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc0204438:	05e00413          	li	s0,94
ffffffffc020443c:	b565                	j	ffffffffc02042e4 <vprintfmt+0x208>

ffffffffc020443e <printfmt>:
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
ffffffffc020443e:	715d                	addi	sp,sp,-80
    va_start(ap, fmt);
ffffffffc0204440:	02810313          	addi	t1,sp,40
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
ffffffffc0204444:	f436                	sd	a3,40(sp)
    vprintfmt(putch, putdat, fmt, ap);
ffffffffc0204446:	869a                	mv	a3,t1
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
ffffffffc0204448:	ec06                	sd	ra,24(sp)
ffffffffc020444a:	f83a                	sd	a4,48(sp)
ffffffffc020444c:	fc3e                	sd	a5,56(sp)
ffffffffc020444e:	e0c2                	sd	a6,64(sp)
ffffffffc0204450:	e4c6                	sd	a7,72(sp)
    va_start(ap, fmt);
ffffffffc0204452:	e41a                	sd	t1,8(sp)
    vprintfmt(putch, putdat, fmt, ap);
ffffffffc0204454:	c89ff0ef          	jal	ra,ffffffffc02040dc <vprintfmt>
}
ffffffffc0204458:	60e2                	ld	ra,24(sp)
ffffffffc020445a:	6161                	addi	sp,sp,80
ffffffffc020445c:	8082                	ret

ffffffffc020445e <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
ffffffffc020445e:	715d                	addi	sp,sp,-80
ffffffffc0204460:	e486                	sd	ra,72(sp)
ffffffffc0204462:	e0a6                	sd	s1,64(sp)
ffffffffc0204464:	fc4a                	sd	s2,56(sp)
ffffffffc0204466:	f84e                	sd	s3,48(sp)
ffffffffc0204468:	f452                	sd	s4,40(sp)
ffffffffc020446a:	f056                	sd	s5,32(sp)
ffffffffc020446c:	ec5a                	sd	s6,24(sp)
ffffffffc020446e:	e85e                	sd	s7,16(sp)
    if (prompt != NULL) {
ffffffffc0204470:	c901                	beqz	a0,ffffffffc0204480 <readline+0x22>
ffffffffc0204472:	85aa                	mv	a1,a0
        cprintf("%s", prompt);
ffffffffc0204474:	00002517          	auipc	a0,0x2
ffffffffc0204478:	cf450513          	addi	a0,a0,-780 # ffffffffc0206168 <default_pmm_manager+0x7e8>
ffffffffc020447c:	c3ffb0ef          	jal	ra,ffffffffc02000ba <cprintf>
readline(const char *prompt) {
ffffffffc0204480:	4481                	li	s1,0
    while (1) {
        c = getchar();
        if (c < 0) {
            return NULL;
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
ffffffffc0204482:	497d                	li	s2,31
            cputchar(c);
            buf[i ++] = c;
        }
        else if (c == '\b' && i > 0) {
ffffffffc0204484:	49a1                	li	s3,8
            cputchar(c);
            i --;
        }
        else if (c == '\n' || c == '\r') {
ffffffffc0204486:	4aa9                	li	s5,10
ffffffffc0204488:	4b35                	li	s6,13
            buf[i ++] = c;
ffffffffc020448a:	0000db97          	auipc	s7,0xd
ffffffffc020448e:	c6eb8b93          	addi	s7,s7,-914 # ffffffffc02110f8 <buf>
        else if (c >= ' ' && i < BUFSIZE - 1) {
ffffffffc0204492:	3fe00a13          	li	s4,1022
        c = getchar();
ffffffffc0204496:	c5dfb0ef          	jal	ra,ffffffffc02000f2 <getchar>
        if (c < 0) {
ffffffffc020449a:	00054a63          	bltz	a0,ffffffffc02044ae <readline+0x50>
        else if (c >= ' ' && i < BUFSIZE - 1) {
ffffffffc020449e:	00a95a63          	bge	s2,a0,ffffffffc02044b2 <readline+0x54>
ffffffffc02044a2:	029a5263          	bge	s4,s1,ffffffffc02044c6 <readline+0x68>
        c = getchar();
ffffffffc02044a6:	c4dfb0ef          	jal	ra,ffffffffc02000f2 <getchar>
        if (c < 0) {
ffffffffc02044aa:	fe055ae3          	bgez	a0,ffffffffc020449e <readline+0x40>
            return NULL;
ffffffffc02044ae:	4501                	li	a0,0
ffffffffc02044b0:	a091                	j	ffffffffc02044f4 <readline+0x96>
        else if (c == '\b' && i > 0) {
ffffffffc02044b2:	03351463          	bne	a0,s3,ffffffffc02044da <readline+0x7c>
ffffffffc02044b6:	e8a9                	bnez	s1,ffffffffc0204508 <readline+0xaa>
        c = getchar();
ffffffffc02044b8:	c3bfb0ef          	jal	ra,ffffffffc02000f2 <getchar>
        if (c < 0) {
ffffffffc02044bc:	fe0549e3          	bltz	a0,ffffffffc02044ae <readline+0x50>
        else if (c >= ' ' && i < BUFSIZE - 1) {
ffffffffc02044c0:	fea959e3          	bge	s2,a0,ffffffffc02044b2 <readline+0x54>
ffffffffc02044c4:	4481                	li	s1,0
            cputchar(c);
ffffffffc02044c6:	e42a                	sd	a0,8(sp)
ffffffffc02044c8:	c29fb0ef          	jal	ra,ffffffffc02000f0 <cputchar>
            buf[i ++] = c;
ffffffffc02044cc:	6522                	ld	a0,8(sp)
ffffffffc02044ce:	009b87b3          	add	a5,s7,s1
ffffffffc02044d2:	2485                	addiw	s1,s1,1
ffffffffc02044d4:	00a78023          	sb	a0,0(a5)
ffffffffc02044d8:	bf7d                	j	ffffffffc0204496 <readline+0x38>
        else if (c == '\n' || c == '\r') {
ffffffffc02044da:	01550463          	beq	a0,s5,ffffffffc02044e2 <readline+0x84>
ffffffffc02044de:	fb651ce3          	bne	a0,s6,ffffffffc0204496 <readline+0x38>
            cputchar(c);
ffffffffc02044e2:	c0ffb0ef          	jal	ra,ffffffffc02000f0 <cputchar>
            buf[i] = '\0';
ffffffffc02044e6:	0000d517          	auipc	a0,0xd
ffffffffc02044ea:	c1250513          	addi	a0,a0,-1006 # ffffffffc02110f8 <buf>
ffffffffc02044ee:	94aa                	add	s1,s1,a0
ffffffffc02044f0:	00048023          	sb	zero,0(s1)
            return buf;
        }
    }
}
ffffffffc02044f4:	60a6                	ld	ra,72(sp)
ffffffffc02044f6:	6486                	ld	s1,64(sp)
ffffffffc02044f8:	7962                	ld	s2,56(sp)
ffffffffc02044fa:	79c2                	ld	s3,48(sp)
ffffffffc02044fc:	7a22                	ld	s4,40(sp)
ffffffffc02044fe:	7a82                	ld	s5,32(sp)
ffffffffc0204500:	6b62                	ld	s6,24(sp)
ffffffffc0204502:	6bc2                	ld	s7,16(sp)
ffffffffc0204504:	6161                	addi	sp,sp,80
ffffffffc0204506:	8082                	ret
            cputchar(c);
ffffffffc0204508:	4521                	li	a0,8
ffffffffc020450a:	be7fb0ef          	jal	ra,ffffffffc02000f0 <cputchar>
            i --;
ffffffffc020450e:	34fd                	addiw	s1,s1,-1
ffffffffc0204510:	b759                	j	ffffffffc0204496 <readline+0x38>
