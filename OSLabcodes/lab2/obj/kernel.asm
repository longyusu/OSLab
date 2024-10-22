
bin/kernel:     file format elf64-littleriscv


Disassembly of section .text:

ffffffffc0200000 <kern_entry>:

    .section .text,"ax",%progbits
    .globl kern_entry
kern_entry:
    # t0 := 三级页表的虚拟地址
    lui     t0, %hi(boot_page_table_sv39)
ffffffffc0200000:	c02052b7          	lui	t0,0xc0205
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
ffffffffc0200024:	c0205137          	lui	sp,0xc0205

    # 我们在虚拟内存空间中：随意跳转到虚拟地址！
    # 跳转到 kern_init
    lui t0, %hi(kern_init)
ffffffffc0200028:	c02002b7          	lui	t0,0xc0200
    addi t0, t0, %lo(kern_init)
ffffffffc020002c:	03228293          	addi	t0,t0,50 # ffffffffc0200032 <kern_init>
    jr t0
ffffffffc0200030:	8282                	jr	t0

ffffffffc0200032 <kern_init>:
void grade_backtrace(void);


int kern_init(void) {
    extern char edata[], end[];
    memset(edata, 0, end - edata);
ffffffffc0200032:	00006517          	auipc	a0,0x6
ffffffffc0200036:	fde50513          	addi	a0,a0,-34 # ffffffffc0206010 <bsfree_area>
ffffffffc020003a:	00006617          	auipc	a2,0x6
ffffffffc020003e:	44660613          	addi	a2,a2,1094 # ffffffffc0206480 <end>
int kern_init(void) {
ffffffffc0200042:	1141                	addi	sp,sp,-16
    memset(edata, 0, end - edata);
ffffffffc0200044:	8e09                	sub	a2,a2,a0
ffffffffc0200046:	4581                	li	a1,0
int kern_init(void) {
ffffffffc0200048:	e406                	sd	ra,8(sp)
    memset(edata, 0, end - edata);
ffffffffc020004a:	33e010ef          	jal	ra,ffffffffc0201388 <memset>
    cons_init();  // init the console
ffffffffc020004e:	3fc000ef          	jal	ra,ffffffffc020044a <cons_init>
    const char *message = "(THU.CST) os is loading ...\0";
    //cprintf("%s\n\n", message);
    cputs(message);
ffffffffc0200052:	00002517          	auipc	a0,0x2
ffffffffc0200056:	83e50513          	addi	a0,a0,-1986 # ffffffffc0201890 <etext+0x4>
ffffffffc020005a:	090000ef          	jal	ra,ffffffffc02000ea <cputs>

    print_kerninfo();
ffffffffc020005e:	138000ef          	jal	ra,ffffffffc0200196 <print_kerninfo>

    // grade_backtrace();
    idt_init();  // init interrupt descriptor table
ffffffffc0200062:	402000ef          	jal	ra,ffffffffc0200464 <idt_init>

    pmm_init();  // init physical memory management
ffffffffc0200066:	126010ef          	jal	ra,ffffffffc020118c <pmm_init>

    idt_init();  // init interrupt descriptor table
ffffffffc020006a:	3fa000ef          	jal	ra,ffffffffc0200464 <idt_init>

    clock_init();   // init clock interrupt
ffffffffc020006e:	39a000ef          	jal	ra,ffffffffc0200408 <clock_init>
    intr_enable();  // enable irq interrupt
ffffffffc0200072:	3e6000ef          	jal	ra,ffffffffc0200458 <intr_enable>



    /* do nothing */
    while (1)
ffffffffc0200076:	a001                	j	ffffffffc0200076 <kern_init+0x44>

ffffffffc0200078 <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
ffffffffc0200078:	1141                	addi	sp,sp,-16
ffffffffc020007a:	e022                	sd	s0,0(sp)
ffffffffc020007c:	e406                	sd	ra,8(sp)
ffffffffc020007e:	842e                	mv	s0,a1
    cons_putc(c);
ffffffffc0200080:	3cc000ef          	jal	ra,ffffffffc020044c <cons_putc>
    (*cnt) ++;
ffffffffc0200084:	401c                	lw	a5,0(s0)
}
ffffffffc0200086:	60a2                	ld	ra,8(sp)
    (*cnt) ++;
ffffffffc0200088:	2785                	addiw	a5,a5,1
ffffffffc020008a:	c01c                	sw	a5,0(s0)
}
ffffffffc020008c:	6402                	ld	s0,0(sp)
ffffffffc020008e:	0141                	addi	sp,sp,16
ffffffffc0200090:	8082                	ret

ffffffffc0200092 <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
ffffffffc0200092:	1101                	addi	sp,sp,-32
ffffffffc0200094:	862a                	mv	a2,a0
ffffffffc0200096:	86ae                	mv	a3,a1
    int cnt = 0;
    vprintfmt((void*)cputch, &cnt, fmt, ap);
ffffffffc0200098:	00000517          	auipc	a0,0x0
ffffffffc020009c:	fe050513          	addi	a0,a0,-32 # ffffffffc0200078 <cputch>
ffffffffc02000a0:	006c                	addi	a1,sp,12
vcprintf(const char *fmt, va_list ap) {
ffffffffc02000a2:	ec06                	sd	ra,24(sp)
    int cnt = 0;
ffffffffc02000a4:	c602                	sw	zero,12(sp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
ffffffffc02000a6:	360010ef          	jal	ra,ffffffffc0201406 <vprintfmt>
    return cnt;
}
ffffffffc02000aa:	60e2                	ld	ra,24(sp)
ffffffffc02000ac:	4532                	lw	a0,12(sp)
ffffffffc02000ae:	6105                	addi	sp,sp,32
ffffffffc02000b0:	8082                	ret

ffffffffc02000b2 <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
ffffffffc02000b2:	711d                	addi	sp,sp,-96
    va_list ap;
    int cnt;
    va_start(ap, fmt);
ffffffffc02000b4:	02810313          	addi	t1,sp,40 # ffffffffc0205028 <boot_page_table_sv39+0x28>
cprintf(const char *fmt, ...) {
ffffffffc02000b8:	8e2a                	mv	t3,a0
ffffffffc02000ba:	f42e                	sd	a1,40(sp)
ffffffffc02000bc:	f832                	sd	a2,48(sp)
ffffffffc02000be:	fc36                	sd	a3,56(sp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
ffffffffc02000c0:	00000517          	auipc	a0,0x0
ffffffffc02000c4:	fb850513          	addi	a0,a0,-72 # ffffffffc0200078 <cputch>
ffffffffc02000c8:	004c                	addi	a1,sp,4
ffffffffc02000ca:	869a                	mv	a3,t1
ffffffffc02000cc:	8672                	mv	a2,t3
cprintf(const char *fmt, ...) {
ffffffffc02000ce:	ec06                	sd	ra,24(sp)
ffffffffc02000d0:	e0ba                	sd	a4,64(sp)
ffffffffc02000d2:	e4be                	sd	a5,72(sp)
ffffffffc02000d4:	e8c2                	sd	a6,80(sp)
ffffffffc02000d6:	ecc6                	sd	a7,88(sp)
    va_start(ap, fmt);
ffffffffc02000d8:	e41a                	sd	t1,8(sp)
    int cnt = 0;
ffffffffc02000da:	c202                	sw	zero,4(sp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
ffffffffc02000dc:	32a010ef          	jal	ra,ffffffffc0201406 <vprintfmt>
    cnt = vcprintf(fmt, ap);
    va_end(ap);
    return cnt;
}
ffffffffc02000e0:	60e2                	ld	ra,24(sp)
ffffffffc02000e2:	4512                	lw	a0,4(sp)
ffffffffc02000e4:	6125                	addi	sp,sp,96
ffffffffc02000e6:	8082                	ret

ffffffffc02000e8 <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
    cons_putc(c);
ffffffffc02000e8:	a695                	j	ffffffffc020044c <cons_putc>

ffffffffc02000ea <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
ffffffffc02000ea:	1101                	addi	sp,sp,-32
ffffffffc02000ec:	e822                	sd	s0,16(sp)
ffffffffc02000ee:	ec06                	sd	ra,24(sp)
ffffffffc02000f0:	e426                	sd	s1,8(sp)
ffffffffc02000f2:	842a                	mv	s0,a0
    int cnt = 0;
    char c;
    while ((c = *str ++) != '\0') {
ffffffffc02000f4:	00054503          	lbu	a0,0(a0)
ffffffffc02000f8:	c51d                	beqz	a0,ffffffffc0200126 <cputs+0x3c>
ffffffffc02000fa:	0405                	addi	s0,s0,1
ffffffffc02000fc:	4485                	li	s1,1
ffffffffc02000fe:	9c81                	subw	s1,s1,s0
    cons_putc(c);
ffffffffc0200100:	34c000ef          	jal	ra,ffffffffc020044c <cons_putc>
    while ((c = *str ++) != '\0') {
ffffffffc0200104:	00044503          	lbu	a0,0(s0)
ffffffffc0200108:	008487bb          	addw	a5,s1,s0
ffffffffc020010c:	0405                	addi	s0,s0,1
ffffffffc020010e:	f96d                	bnez	a0,ffffffffc0200100 <cputs+0x16>
    (*cnt) ++;
ffffffffc0200110:	0017841b          	addiw	s0,a5,1
    cons_putc(c);
ffffffffc0200114:	4529                	li	a0,10
ffffffffc0200116:	336000ef          	jal	ra,ffffffffc020044c <cons_putc>
        cputch(c, &cnt);
    }
    cputch('\n', &cnt);
    return cnt;
}
ffffffffc020011a:	60e2                	ld	ra,24(sp)
ffffffffc020011c:	8522                	mv	a0,s0
ffffffffc020011e:	6442                	ld	s0,16(sp)
ffffffffc0200120:	64a2                	ld	s1,8(sp)
ffffffffc0200122:	6105                	addi	sp,sp,32
ffffffffc0200124:	8082                	ret
    while ((c = *str ++) != '\0') {
ffffffffc0200126:	4405                	li	s0,1
ffffffffc0200128:	b7f5                	j	ffffffffc0200114 <cputs+0x2a>

ffffffffc020012a <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
ffffffffc020012a:	1141                	addi	sp,sp,-16
ffffffffc020012c:	e406                	sd	ra,8(sp)
    int c;
    while ((c = cons_getc()) == 0)
ffffffffc020012e:	326000ef          	jal	ra,ffffffffc0200454 <cons_getc>
ffffffffc0200132:	dd75                	beqz	a0,ffffffffc020012e <getchar+0x4>
        /* do nothing */;
    return c;
}
ffffffffc0200134:	60a2                	ld	ra,8(sp)
ffffffffc0200136:	0141                	addi	sp,sp,16
ffffffffc0200138:	8082                	ret

ffffffffc020013a <__panic>:
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
    if (is_panic) {
ffffffffc020013a:	00006317          	auipc	t1,0x6
ffffffffc020013e:	2ee30313          	addi	t1,t1,750 # ffffffffc0206428 <is_panic>
ffffffffc0200142:	00032e03          	lw	t3,0(t1)
__panic(const char *file, int line, const char *fmt, ...) {
ffffffffc0200146:	715d                	addi	sp,sp,-80
ffffffffc0200148:	ec06                	sd	ra,24(sp)
ffffffffc020014a:	e822                	sd	s0,16(sp)
ffffffffc020014c:	f436                	sd	a3,40(sp)
ffffffffc020014e:	f83a                	sd	a4,48(sp)
ffffffffc0200150:	fc3e                	sd	a5,56(sp)
ffffffffc0200152:	e0c2                	sd	a6,64(sp)
ffffffffc0200154:	e4c6                	sd	a7,72(sp)
    if (is_panic) {
ffffffffc0200156:	020e1a63          	bnez	t3,ffffffffc020018a <__panic+0x50>
        goto panic_dead;
    }
    is_panic = 1;
ffffffffc020015a:	4785                	li	a5,1
ffffffffc020015c:	00f32023          	sw	a5,0(t1)

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
ffffffffc0200160:	8432                	mv	s0,a2
ffffffffc0200162:	103c                	addi	a5,sp,40
    cprintf("kernel panic at %s:%d:\n    ", file, line);
ffffffffc0200164:	862e                	mv	a2,a1
ffffffffc0200166:	85aa                	mv	a1,a0
ffffffffc0200168:	00001517          	auipc	a0,0x1
ffffffffc020016c:	74850513          	addi	a0,a0,1864 # ffffffffc02018b0 <etext+0x24>
    va_start(ap, fmt);
ffffffffc0200170:	e43e                	sd	a5,8(sp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
ffffffffc0200172:	f41ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    vcprintf(fmt, ap);
ffffffffc0200176:	65a2                	ld	a1,8(sp)
ffffffffc0200178:	8522                	mv	a0,s0
ffffffffc020017a:	f19ff0ef          	jal	ra,ffffffffc0200092 <vcprintf>
    cprintf("\n");
ffffffffc020017e:	00002517          	auipc	a0,0x2
ffffffffc0200182:	81a50513          	addi	a0,a0,-2022 # ffffffffc0201998 <etext+0x10c>
ffffffffc0200186:	f2dff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    va_end(ap);

panic_dead:
    intr_disable();
ffffffffc020018a:	2d4000ef          	jal	ra,ffffffffc020045e <intr_disable>
    while (1) {
        kmonitor(NULL);
ffffffffc020018e:	4501                	li	a0,0
ffffffffc0200190:	130000ef          	jal	ra,ffffffffc02002c0 <kmonitor>
    while (1) {
ffffffffc0200194:	bfed                	j	ffffffffc020018e <__panic+0x54>

ffffffffc0200196 <print_kerninfo>:
/* *
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void print_kerninfo(void) {
ffffffffc0200196:	1141                	addi	sp,sp,-16
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
ffffffffc0200198:	00001517          	auipc	a0,0x1
ffffffffc020019c:	73850513          	addi	a0,a0,1848 # ffffffffc02018d0 <etext+0x44>
void print_kerninfo(void) {
ffffffffc02001a0:	e406                	sd	ra,8(sp)
    cprintf("Special kernel symbols:\n");
ffffffffc02001a2:	f11ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    cprintf("  entry  0x%016lx (virtual)\n", kern_init);
ffffffffc02001a6:	00000597          	auipc	a1,0x0
ffffffffc02001aa:	e8c58593          	addi	a1,a1,-372 # ffffffffc0200032 <kern_init>
ffffffffc02001ae:	00001517          	auipc	a0,0x1
ffffffffc02001b2:	74250513          	addi	a0,a0,1858 # ffffffffc02018f0 <etext+0x64>
ffffffffc02001b6:	efdff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    cprintf("  etext  0x%016lx (virtual)\n", etext);
ffffffffc02001ba:	00001597          	auipc	a1,0x1
ffffffffc02001be:	6d258593          	addi	a1,a1,1746 # ffffffffc020188c <etext>
ffffffffc02001c2:	00001517          	auipc	a0,0x1
ffffffffc02001c6:	74e50513          	addi	a0,a0,1870 # ffffffffc0201910 <etext+0x84>
ffffffffc02001ca:	ee9ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    cprintf("  edata  0x%016lx (virtual)\n", edata);
ffffffffc02001ce:	00006597          	auipc	a1,0x6
ffffffffc02001d2:	e4258593          	addi	a1,a1,-446 # ffffffffc0206010 <bsfree_area>
ffffffffc02001d6:	00001517          	auipc	a0,0x1
ffffffffc02001da:	75a50513          	addi	a0,a0,1882 # ffffffffc0201930 <etext+0xa4>
ffffffffc02001de:	ed5ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    cprintf("  end    0x%016lx (virtual)\n", end);
ffffffffc02001e2:	00006597          	auipc	a1,0x6
ffffffffc02001e6:	29e58593          	addi	a1,a1,670 # ffffffffc0206480 <end>
ffffffffc02001ea:	00001517          	auipc	a0,0x1
ffffffffc02001ee:	76650513          	addi	a0,a0,1894 # ffffffffc0201950 <etext+0xc4>
ffffffffc02001f2:	ec1ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n",
            (end - kern_init + 1023) / 1024);
ffffffffc02001f6:	00006597          	auipc	a1,0x6
ffffffffc02001fa:	68958593          	addi	a1,a1,1673 # ffffffffc020687f <end+0x3ff>
ffffffffc02001fe:	00000797          	auipc	a5,0x0
ffffffffc0200202:	e3478793          	addi	a5,a5,-460 # ffffffffc0200032 <kern_init>
ffffffffc0200206:	40f587b3          	sub	a5,a1,a5
    cprintf("Kernel executable memory footprint: %dKB\n",
ffffffffc020020a:	43f7d593          	srai	a1,a5,0x3f
}
ffffffffc020020e:	60a2                	ld	ra,8(sp)
    cprintf("Kernel executable memory footprint: %dKB\n",
ffffffffc0200210:	3ff5f593          	andi	a1,a1,1023
ffffffffc0200214:	95be                	add	a1,a1,a5
ffffffffc0200216:	85a9                	srai	a1,a1,0xa
ffffffffc0200218:	00001517          	auipc	a0,0x1
ffffffffc020021c:	75850513          	addi	a0,a0,1880 # ffffffffc0201970 <etext+0xe4>
}
ffffffffc0200220:	0141                	addi	sp,sp,16
    cprintf("Kernel executable memory footprint: %dKB\n",
ffffffffc0200222:	bd41                	j	ffffffffc02000b2 <cprintf>

ffffffffc0200224 <print_stackframe>:
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before
 * jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the
 * boundary.
 * */
void print_stackframe(void) {
ffffffffc0200224:	1141                	addi	sp,sp,-16

    panic("Not Implemented!");
ffffffffc0200226:	00001617          	auipc	a2,0x1
ffffffffc020022a:	77a60613          	addi	a2,a2,1914 # ffffffffc02019a0 <etext+0x114>
ffffffffc020022e:	04e00593          	li	a1,78
ffffffffc0200232:	00001517          	auipc	a0,0x1
ffffffffc0200236:	78650513          	addi	a0,a0,1926 # ffffffffc02019b8 <etext+0x12c>
void print_stackframe(void) {
ffffffffc020023a:	e406                	sd	ra,8(sp)
    panic("Not Implemented!");
ffffffffc020023c:	effff0ef          	jal	ra,ffffffffc020013a <__panic>

ffffffffc0200240 <mon_help>:
    }
}

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
ffffffffc0200240:	1141                	addi	sp,sp,-16
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
ffffffffc0200242:	00001617          	auipc	a2,0x1
ffffffffc0200246:	78e60613          	addi	a2,a2,1934 # ffffffffc02019d0 <etext+0x144>
ffffffffc020024a:	00001597          	auipc	a1,0x1
ffffffffc020024e:	7a658593          	addi	a1,a1,1958 # ffffffffc02019f0 <etext+0x164>
ffffffffc0200252:	00001517          	auipc	a0,0x1
ffffffffc0200256:	7a650513          	addi	a0,a0,1958 # ffffffffc02019f8 <etext+0x16c>
mon_help(int argc, char **argv, struct trapframe *tf) {
ffffffffc020025a:	e406                	sd	ra,8(sp)
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
ffffffffc020025c:	e57ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc0200260:	00001617          	auipc	a2,0x1
ffffffffc0200264:	7a860613          	addi	a2,a2,1960 # ffffffffc0201a08 <etext+0x17c>
ffffffffc0200268:	00001597          	auipc	a1,0x1
ffffffffc020026c:	7c858593          	addi	a1,a1,1992 # ffffffffc0201a30 <etext+0x1a4>
ffffffffc0200270:	00001517          	auipc	a0,0x1
ffffffffc0200274:	78850513          	addi	a0,a0,1928 # ffffffffc02019f8 <etext+0x16c>
ffffffffc0200278:	e3bff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc020027c:	00001617          	auipc	a2,0x1
ffffffffc0200280:	7c460613          	addi	a2,a2,1988 # ffffffffc0201a40 <etext+0x1b4>
ffffffffc0200284:	00001597          	auipc	a1,0x1
ffffffffc0200288:	7dc58593          	addi	a1,a1,2012 # ffffffffc0201a60 <etext+0x1d4>
ffffffffc020028c:	00001517          	auipc	a0,0x1
ffffffffc0200290:	76c50513          	addi	a0,a0,1900 # ffffffffc02019f8 <etext+0x16c>
ffffffffc0200294:	e1fff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    }
    return 0;
}
ffffffffc0200298:	60a2                	ld	ra,8(sp)
ffffffffc020029a:	4501                	li	a0,0
ffffffffc020029c:	0141                	addi	sp,sp,16
ffffffffc020029e:	8082                	ret

ffffffffc02002a0 <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
ffffffffc02002a0:	1141                	addi	sp,sp,-16
ffffffffc02002a2:	e406                	sd	ra,8(sp)
    print_kerninfo();
ffffffffc02002a4:	ef3ff0ef          	jal	ra,ffffffffc0200196 <print_kerninfo>
    return 0;
}
ffffffffc02002a8:	60a2                	ld	ra,8(sp)
ffffffffc02002aa:	4501                	li	a0,0
ffffffffc02002ac:	0141                	addi	sp,sp,16
ffffffffc02002ae:	8082                	ret

ffffffffc02002b0 <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
ffffffffc02002b0:	1141                	addi	sp,sp,-16
ffffffffc02002b2:	e406                	sd	ra,8(sp)
    print_stackframe();
ffffffffc02002b4:	f71ff0ef          	jal	ra,ffffffffc0200224 <print_stackframe>
    return 0;
}
ffffffffc02002b8:	60a2                	ld	ra,8(sp)
ffffffffc02002ba:	4501                	li	a0,0
ffffffffc02002bc:	0141                	addi	sp,sp,16
ffffffffc02002be:	8082                	ret

ffffffffc02002c0 <kmonitor>:
kmonitor(struct trapframe *tf) {
ffffffffc02002c0:	7115                	addi	sp,sp,-224
ffffffffc02002c2:	ed5e                	sd	s7,152(sp)
ffffffffc02002c4:	8baa                	mv	s7,a0
    cprintf("Welcome to the kernel debug monitor!!\n");
ffffffffc02002c6:	00001517          	auipc	a0,0x1
ffffffffc02002ca:	7aa50513          	addi	a0,a0,1962 # ffffffffc0201a70 <etext+0x1e4>
kmonitor(struct trapframe *tf) {
ffffffffc02002ce:	ed86                	sd	ra,216(sp)
ffffffffc02002d0:	e9a2                	sd	s0,208(sp)
ffffffffc02002d2:	e5a6                	sd	s1,200(sp)
ffffffffc02002d4:	e1ca                	sd	s2,192(sp)
ffffffffc02002d6:	fd4e                	sd	s3,184(sp)
ffffffffc02002d8:	f952                	sd	s4,176(sp)
ffffffffc02002da:	f556                	sd	s5,168(sp)
ffffffffc02002dc:	f15a                	sd	s6,160(sp)
ffffffffc02002de:	e962                	sd	s8,144(sp)
ffffffffc02002e0:	e566                	sd	s9,136(sp)
ffffffffc02002e2:	e16a                	sd	s10,128(sp)
    cprintf("Welcome to the kernel debug monitor!!\n");
ffffffffc02002e4:	dcfff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
ffffffffc02002e8:	00001517          	auipc	a0,0x1
ffffffffc02002ec:	7b050513          	addi	a0,a0,1968 # ffffffffc0201a98 <etext+0x20c>
ffffffffc02002f0:	dc3ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    if (tf != NULL) {
ffffffffc02002f4:	000b8563          	beqz	s7,ffffffffc02002fe <kmonitor+0x3e>
        print_trapframe(tf);
ffffffffc02002f8:	855e                	mv	a0,s7
ffffffffc02002fa:	348000ef          	jal	ra,ffffffffc0200642 <print_trapframe>
ffffffffc02002fe:	00002c17          	auipc	s8,0x2
ffffffffc0200302:	80ac0c13          	addi	s8,s8,-2038 # ffffffffc0201b08 <commands>
        if ((buf = readline("K> ")) != NULL) {
ffffffffc0200306:	00001917          	auipc	s2,0x1
ffffffffc020030a:	7ba90913          	addi	s2,s2,1978 # ffffffffc0201ac0 <etext+0x234>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
ffffffffc020030e:	00001497          	auipc	s1,0x1
ffffffffc0200312:	7ba48493          	addi	s1,s1,1978 # ffffffffc0201ac8 <etext+0x23c>
        if (argc == MAXARGS - 1) {
ffffffffc0200316:	49bd                	li	s3,15
            cprintf("Too many arguments (max %d).\n", MAXARGS);
ffffffffc0200318:	00001b17          	auipc	s6,0x1
ffffffffc020031c:	7b8b0b13          	addi	s6,s6,1976 # ffffffffc0201ad0 <etext+0x244>
        argv[argc ++] = buf;
ffffffffc0200320:	00001a17          	auipc	s4,0x1
ffffffffc0200324:	6d0a0a13          	addi	s4,s4,1744 # ffffffffc02019f0 <etext+0x164>
    for (i = 0; i < NCOMMANDS; i ++) {
ffffffffc0200328:	4a8d                	li	s5,3
        if ((buf = readline("K> ")) != NULL) {
ffffffffc020032a:	854a                	mv	a0,s2
ffffffffc020032c:	4ac010ef          	jal	ra,ffffffffc02017d8 <readline>
ffffffffc0200330:	842a                	mv	s0,a0
ffffffffc0200332:	dd65                	beqz	a0,ffffffffc020032a <kmonitor+0x6a>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
ffffffffc0200334:	00054583          	lbu	a1,0(a0)
    int argc = 0;
ffffffffc0200338:	4c81                	li	s9,0
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
ffffffffc020033a:	e1bd                	bnez	a1,ffffffffc02003a0 <kmonitor+0xe0>
    if (argc == 0) {
ffffffffc020033c:	fe0c87e3          	beqz	s9,ffffffffc020032a <kmonitor+0x6a>
        if (strcmp(commands[i].name, argv[0]) == 0) {
ffffffffc0200340:	6582                	ld	a1,0(sp)
ffffffffc0200342:	00001d17          	auipc	s10,0x1
ffffffffc0200346:	7c6d0d13          	addi	s10,s10,1990 # ffffffffc0201b08 <commands>
        argv[argc ++] = buf;
ffffffffc020034a:	8552                	mv	a0,s4
    for (i = 0; i < NCOMMANDS; i ++) {
ffffffffc020034c:	4401                	li	s0,0
ffffffffc020034e:	0d61                	addi	s10,s10,24
        if (strcmp(commands[i].name, argv[0]) == 0) {
ffffffffc0200350:	004010ef          	jal	ra,ffffffffc0201354 <strcmp>
ffffffffc0200354:	c919                	beqz	a0,ffffffffc020036a <kmonitor+0xaa>
    for (i = 0; i < NCOMMANDS; i ++) {
ffffffffc0200356:	2405                	addiw	s0,s0,1
ffffffffc0200358:	0b540063          	beq	s0,s5,ffffffffc02003f8 <kmonitor+0x138>
        if (strcmp(commands[i].name, argv[0]) == 0) {
ffffffffc020035c:	000d3503          	ld	a0,0(s10)
ffffffffc0200360:	6582                	ld	a1,0(sp)
    for (i = 0; i < NCOMMANDS; i ++) {
ffffffffc0200362:	0d61                	addi	s10,s10,24
        if (strcmp(commands[i].name, argv[0]) == 0) {
ffffffffc0200364:	7f1000ef          	jal	ra,ffffffffc0201354 <strcmp>
ffffffffc0200368:	f57d                	bnez	a0,ffffffffc0200356 <kmonitor+0x96>
            return commands[i].func(argc - 1, argv + 1, tf);
ffffffffc020036a:	00141793          	slli	a5,s0,0x1
ffffffffc020036e:	97a2                	add	a5,a5,s0
ffffffffc0200370:	078e                	slli	a5,a5,0x3
ffffffffc0200372:	97e2                	add	a5,a5,s8
ffffffffc0200374:	6b9c                	ld	a5,16(a5)
ffffffffc0200376:	865e                	mv	a2,s7
ffffffffc0200378:	002c                	addi	a1,sp,8
ffffffffc020037a:	fffc851b          	addiw	a0,s9,-1
ffffffffc020037e:	9782                	jalr	a5
            if (runcmd(buf, tf) < 0) {
ffffffffc0200380:	fa0555e3          	bgez	a0,ffffffffc020032a <kmonitor+0x6a>
}
ffffffffc0200384:	60ee                	ld	ra,216(sp)
ffffffffc0200386:	644e                	ld	s0,208(sp)
ffffffffc0200388:	64ae                	ld	s1,200(sp)
ffffffffc020038a:	690e                	ld	s2,192(sp)
ffffffffc020038c:	79ea                	ld	s3,184(sp)
ffffffffc020038e:	7a4a                	ld	s4,176(sp)
ffffffffc0200390:	7aaa                	ld	s5,168(sp)
ffffffffc0200392:	7b0a                	ld	s6,160(sp)
ffffffffc0200394:	6bea                	ld	s7,152(sp)
ffffffffc0200396:	6c4a                	ld	s8,144(sp)
ffffffffc0200398:	6caa                	ld	s9,136(sp)
ffffffffc020039a:	6d0a                	ld	s10,128(sp)
ffffffffc020039c:	612d                	addi	sp,sp,224
ffffffffc020039e:	8082                	ret
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
ffffffffc02003a0:	8526                	mv	a0,s1
ffffffffc02003a2:	7d1000ef          	jal	ra,ffffffffc0201372 <strchr>
ffffffffc02003a6:	c901                	beqz	a0,ffffffffc02003b6 <kmonitor+0xf6>
ffffffffc02003a8:	00144583          	lbu	a1,1(s0)
            *buf ++ = '\0';
ffffffffc02003ac:	00040023          	sb	zero,0(s0)
ffffffffc02003b0:	0405                	addi	s0,s0,1
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
ffffffffc02003b2:	d5c9                	beqz	a1,ffffffffc020033c <kmonitor+0x7c>
ffffffffc02003b4:	b7f5                	j	ffffffffc02003a0 <kmonitor+0xe0>
        if (*buf == '\0') {
ffffffffc02003b6:	00044783          	lbu	a5,0(s0)
ffffffffc02003ba:	d3c9                	beqz	a5,ffffffffc020033c <kmonitor+0x7c>
        if (argc == MAXARGS - 1) {
ffffffffc02003bc:	033c8963          	beq	s9,s3,ffffffffc02003ee <kmonitor+0x12e>
        argv[argc ++] = buf;
ffffffffc02003c0:	003c9793          	slli	a5,s9,0x3
ffffffffc02003c4:	0118                	addi	a4,sp,128
ffffffffc02003c6:	97ba                	add	a5,a5,a4
ffffffffc02003c8:	f887b023          	sd	s0,-128(a5)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
ffffffffc02003cc:	00044583          	lbu	a1,0(s0)
        argv[argc ++] = buf;
ffffffffc02003d0:	2c85                	addiw	s9,s9,1
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
ffffffffc02003d2:	e591                	bnez	a1,ffffffffc02003de <kmonitor+0x11e>
ffffffffc02003d4:	b7b5                	j	ffffffffc0200340 <kmonitor+0x80>
ffffffffc02003d6:	00144583          	lbu	a1,1(s0)
            buf ++;
ffffffffc02003da:	0405                	addi	s0,s0,1
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
ffffffffc02003dc:	d1a5                	beqz	a1,ffffffffc020033c <kmonitor+0x7c>
ffffffffc02003de:	8526                	mv	a0,s1
ffffffffc02003e0:	793000ef          	jal	ra,ffffffffc0201372 <strchr>
ffffffffc02003e4:	d96d                	beqz	a0,ffffffffc02003d6 <kmonitor+0x116>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
ffffffffc02003e6:	00044583          	lbu	a1,0(s0)
ffffffffc02003ea:	d9a9                	beqz	a1,ffffffffc020033c <kmonitor+0x7c>
ffffffffc02003ec:	bf55                	j	ffffffffc02003a0 <kmonitor+0xe0>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
ffffffffc02003ee:	45c1                	li	a1,16
ffffffffc02003f0:	855a                	mv	a0,s6
ffffffffc02003f2:	cc1ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc02003f6:	b7e9                	j	ffffffffc02003c0 <kmonitor+0x100>
    cprintf("Unknown command '%s'\n", argv[0]);
ffffffffc02003f8:	6582                	ld	a1,0(sp)
ffffffffc02003fa:	00001517          	auipc	a0,0x1
ffffffffc02003fe:	6f650513          	addi	a0,a0,1782 # ffffffffc0201af0 <etext+0x264>
ffffffffc0200402:	cb1ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    return 0;
ffffffffc0200406:	b715                	j	ffffffffc020032a <kmonitor+0x6a>

ffffffffc0200408 <clock_init>:

/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void clock_init(void) {
ffffffffc0200408:	1141                	addi	sp,sp,-16
ffffffffc020040a:	e406                	sd	ra,8(sp)
    // enable timer interrupt in sie
    set_csr(sie, MIP_STIP);
ffffffffc020040c:	02000793          	li	a5,32
ffffffffc0200410:	1047a7f3          	csrrs	a5,sie,a5
    __asm__ __volatile__("rdtime %0" : "=r"(n));
ffffffffc0200414:	c0102573          	rdtime	a0
    ticks = 0;

    cprintf("++ setup timer interrupts\n");
}

void clock_set_next_event(void) { sbi_set_timer(get_cycles() + timebase); }
ffffffffc0200418:	67e1                	lui	a5,0x18
ffffffffc020041a:	6a078793          	addi	a5,a5,1696 # 186a0 <kern_entry-0xffffffffc01e7960>
ffffffffc020041e:	953e                	add	a0,a0,a5
ffffffffc0200420:	382010ef          	jal	ra,ffffffffc02017a2 <sbi_set_timer>
}
ffffffffc0200424:	60a2                	ld	ra,8(sp)
    ticks = 0;
ffffffffc0200426:	00006797          	auipc	a5,0x6
ffffffffc020042a:	0007b523          	sd	zero,10(a5) # ffffffffc0206430 <ticks>
    cprintf("++ setup timer interrupts\n");
ffffffffc020042e:	00001517          	auipc	a0,0x1
ffffffffc0200432:	72250513          	addi	a0,a0,1826 # ffffffffc0201b50 <commands+0x48>
}
ffffffffc0200436:	0141                	addi	sp,sp,16
    cprintf("++ setup timer interrupts\n");
ffffffffc0200438:	b9ad                	j	ffffffffc02000b2 <cprintf>

ffffffffc020043a <clock_set_next_event>:
    __asm__ __volatile__("rdtime %0" : "=r"(n));
ffffffffc020043a:	c0102573          	rdtime	a0
void clock_set_next_event(void) { sbi_set_timer(get_cycles() + timebase); }
ffffffffc020043e:	67e1                	lui	a5,0x18
ffffffffc0200440:	6a078793          	addi	a5,a5,1696 # 186a0 <kern_entry-0xffffffffc01e7960>
ffffffffc0200444:	953e                	add	a0,a0,a5
ffffffffc0200446:	35c0106f          	j	ffffffffc02017a2 <sbi_set_timer>

ffffffffc020044a <cons_init>:

/* serial_intr - try to feed input characters from serial port */
void serial_intr(void) {}

/* cons_init - initializes the console devices */
void cons_init(void) {}
ffffffffc020044a:	8082                	ret

ffffffffc020044c <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void cons_putc(int c) { sbi_console_putchar((unsigned char)c); }
ffffffffc020044c:	0ff57513          	zext.b	a0,a0
ffffffffc0200450:	3380106f          	j	ffffffffc0201788 <sbi_console_putchar>

ffffffffc0200454 <cons_getc>:
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int cons_getc(void) {
    int c = 0;
    c = sbi_console_getchar();
ffffffffc0200454:	3680106f          	j	ffffffffc02017bc <sbi_console_getchar>

ffffffffc0200458 <intr_enable>:
#include <intr.h>
#include <riscv.h>

/* intr_enable - enable irq interrupt */
void intr_enable(void) { set_csr(sstatus, SSTATUS_SIE); }
ffffffffc0200458:	100167f3          	csrrsi	a5,sstatus,2
ffffffffc020045c:	8082                	ret

ffffffffc020045e <intr_disable>:

/* intr_disable - disable irq interrupt */
void intr_disable(void) { clear_csr(sstatus, SSTATUS_SIE); }
ffffffffc020045e:	100177f3          	csrrci	a5,sstatus,2
ffffffffc0200462:	8082                	ret

ffffffffc0200464 <idt_init>:
     */

    extern void __alltraps(void);
    /* Set sup0 scratch register to 0, indicating to exception vector
       that we are presently executing in the kernel */
    write_csr(sscratch, 0);
ffffffffc0200464:	14005073          	csrwi	sscratch,0
    /* Set the exception vector address */
    write_csr(stvec, &__alltraps);
ffffffffc0200468:	00000797          	auipc	a5,0x0
ffffffffc020046c:	2e478793          	addi	a5,a5,740 # ffffffffc020074c <__alltraps>
ffffffffc0200470:	10579073          	csrw	stvec,a5
}
ffffffffc0200474:	8082                	ret

ffffffffc0200476 <print_regs>:
    cprintf("  badvaddr 0x%08x\n", tf->badvaddr);
    cprintf("  cause    0x%08x\n", tf->cause);
}

void print_regs(struct pushregs *gpr) {
    cprintf("  zero     0x%08x\n", gpr->zero);
ffffffffc0200476:	610c                	ld	a1,0(a0)
void print_regs(struct pushregs *gpr) {
ffffffffc0200478:	1141                	addi	sp,sp,-16
ffffffffc020047a:	e022                	sd	s0,0(sp)
ffffffffc020047c:	842a                	mv	s0,a0
    cprintf("  zero     0x%08x\n", gpr->zero);
ffffffffc020047e:	00001517          	auipc	a0,0x1
ffffffffc0200482:	6f250513          	addi	a0,a0,1778 # ffffffffc0201b70 <commands+0x68>
void print_regs(struct pushregs *gpr) {
ffffffffc0200486:	e406                	sd	ra,8(sp)
    cprintf("  zero     0x%08x\n", gpr->zero);
ffffffffc0200488:	c2bff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    cprintf("  ra       0x%08x\n", gpr->ra);
ffffffffc020048c:	640c                	ld	a1,8(s0)
ffffffffc020048e:	00001517          	auipc	a0,0x1
ffffffffc0200492:	6fa50513          	addi	a0,a0,1786 # ffffffffc0201b88 <commands+0x80>
ffffffffc0200496:	c1dff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    cprintf("  sp       0x%08x\n", gpr->sp);
ffffffffc020049a:	680c                	ld	a1,16(s0)
ffffffffc020049c:	00001517          	auipc	a0,0x1
ffffffffc02004a0:	70450513          	addi	a0,a0,1796 # ffffffffc0201ba0 <commands+0x98>
ffffffffc02004a4:	c0fff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    cprintf("  gp       0x%08x\n", gpr->gp);
ffffffffc02004a8:	6c0c                	ld	a1,24(s0)
ffffffffc02004aa:	00001517          	auipc	a0,0x1
ffffffffc02004ae:	70e50513          	addi	a0,a0,1806 # ffffffffc0201bb8 <commands+0xb0>
ffffffffc02004b2:	c01ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    cprintf("  tp       0x%08x\n", gpr->tp);
ffffffffc02004b6:	700c                	ld	a1,32(s0)
ffffffffc02004b8:	00001517          	auipc	a0,0x1
ffffffffc02004bc:	71850513          	addi	a0,a0,1816 # ffffffffc0201bd0 <commands+0xc8>
ffffffffc02004c0:	bf3ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    cprintf("  t0       0x%08x\n", gpr->t0);
ffffffffc02004c4:	740c                	ld	a1,40(s0)
ffffffffc02004c6:	00001517          	auipc	a0,0x1
ffffffffc02004ca:	72250513          	addi	a0,a0,1826 # ffffffffc0201be8 <commands+0xe0>
ffffffffc02004ce:	be5ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    cprintf("  t1       0x%08x\n", gpr->t1);
ffffffffc02004d2:	780c                	ld	a1,48(s0)
ffffffffc02004d4:	00001517          	auipc	a0,0x1
ffffffffc02004d8:	72c50513          	addi	a0,a0,1836 # ffffffffc0201c00 <commands+0xf8>
ffffffffc02004dc:	bd7ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    cprintf("  t2       0x%08x\n", gpr->t2);
ffffffffc02004e0:	7c0c                	ld	a1,56(s0)
ffffffffc02004e2:	00001517          	auipc	a0,0x1
ffffffffc02004e6:	73650513          	addi	a0,a0,1846 # ffffffffc0201c18 <commands+0x110>
ffffffffc02004ea:	bc9ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    cprintf("  s0       0x%08x\n", gpr->s0);
ffffffffc02004ee:	602c                	ld	a1,64(s0)
ffffffffc02004f0:	00001517          	auipc	a0,0x1
ffffffffc02004f4:	74050513          	addi	a0,a0,1856 # ffffffffc0201c30 <commands+0x128>
ffffffffc02004f8:	bbbff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    cprintf("  s1       0x%08x\n", gpr->s1);
ffffffffc02004fc:	642c                	ld	a1,72(s0)
ffffffffc02004fe:	00001517          	auipc	a0,0x1
ffffffffc0200502:	74a50513          	addi	a0,a0,1866 # ffffffffc0201c48 <commands+0x140>
ffffffffc0200506:	badff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    cprintf("  a0       0x%08x\n", gpr->a0);
ffffffffc020050a:	682c                	ld	a1,80(s0)
ffffffffc020050c:	00001517          	auipc	a0,0x1
ffffffffc0200510:	75450513          	addi	a0,a0,1876 # ffffffffc0201c60 <commands+0x158>
ffffffffc0200514:	b9fff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    cprintf("  a1       0x%08x\n", gpr->a1);
ffffffffc0200518:	6c2c                	ld	a1,88(s0)
ffffffffc020051a:	00001517          	auipc	a0,0x1
ffffffffc020051e:	75e50513          	addi	a0,a0,1886 # ffffffffc0201c78 <commands+0x170>
ffffffffc0200522:	b91ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    cprintf("  a2       0x%08x\n", gpr->a2);
ffffffffc0200526:	702c                	ld	a1,96(s0)
ffffffffc0200528:	00001517          	auipc	a0,0x1
ffffffffc020052c:	76850513          	addi	a0,a0,1896 # ffffffffc0201c90 <commands+0x188>
ffffffffc0200530:	b83ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    cprintf("  a3       0x%08x\n", gpr->a3);
ffffffffc0200534:	742c                	ld	a1,104(s0)
ffffffffc0200536:	00001517          	auipc	a0,0x1
ffffffffc020053a:	77250513          	addi	a0,a0,1906 # ffffffffc0201ca8 <commands+0x1a0>
ffffffffc020053e:	b75ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    cprintf("  a4       0x%08x\n", gpr->a4);
ffffffffc0200542:	782c                	ld	a1,112(s0)
ffffffffc0200544:	00001517          	auipc	a0,0x1
ffffffffc0200548:	77c50513          	addi	a0,a0,1916 # ffffffffc0201cc0 <commands+0x1b8>
ffffffffc020054c:	b67ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    cprintf("  a5       0x%08x\n", gpr->a5);
ffffffffc0200550:	7c2c                	ld	a1,120(s0)
ffffffffc0200552:	00001517          	auipc	a0,0x1
ffffffffc0200556:	78650513          	addi	a0,a0,1926 # ffffffffc0201cd8 <commands+0x1d0>
ffffffffc020055a:	b59ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    cprintf("  a6       0x%08x\n", gpr->a6);
ffffffffc020055e:	604c                	ld	a1,128(s0)
ffffffffc0200560:	00001517          	auipc	a0,0x1
ffffffffc0200564:	79050513          	addi	a0,a0,1936 # ffffffffc0201cf0 <commands+0x1e8>
ffffffffc0200568:	b4bff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    cprintf("  a7       0x%08x\n", gpr->a7);
ffffffffc020056c:	644c                	ld	a1,136(s0)
ffffffffc020056e:	00001517          	auipc	a0,0x1
ffffffffc0200572:	79a50513          	addi	a0,a0,1946 # ffffffffc0201d08 <commands+0x200>
ffffffffc0200576:	b3dff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    cprintf("  s2       0x%08x\n", gpr->s2);
ffffffffc020057a:	684c                	ld	a1,144(s0)
ffffffffc020057c:	00001517          	auipc	a0,0x1
ffffffffc0200580:	7a450513          	addi	a0,a0,1956 # ffffffffc0201d20 <commands+0x218>
ffffffffc0200584:	b2fff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    cprintf("  s3       0x%08x\n", gpr->s3);
ffffffffc0200588:	6c4c                	ld	a1,152(s0)
ffffffffc020058a:	00001517          	auipc	a0,0x1
ffffffffc020058e:	7ae50513          	addi	a0,a0,1966 # ffffffffc0201d38 <commands+0x230>
ffffffffc0200592:	b21ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    cprintf("  s4       0x%08x\n", gpr->s4);
ffffffffc0200596:	704c                	ld	a1,160(s0)
ffffffffc0200598:	00001517          	auipc	a0,0x1
ffffffffc020059c:	7b850513          	addi	a0,a0,1976 # ffffffffc0201d50 <commands+0x248>
ffffffffc02005a0:	b13ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    cprintf("  s5       0x%08x\n", gpr->s5);
ffffffffc02005a4:	744c                	ld	a1,168(s0)
ffffffffc02005a6:	00001517          	auipc	a0,0x1
ffffffffc02005aa:	7c250513          	addi	a0,a0,1986 # ffffffffc0201d68 <commands+0x260>
ffffffffc02005ae:	b05ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    cprintf("  s6       0x%08x\n", gpr->s6);
ffffffffc02005b2:	784c                	ld	a1,176(s0)
ffffffffc02005b4:	00001517          	auipc	a0,0x1
ffffffffc02005b8:	7cc50513          	addi	a0,a0,1996 # ffffffffc0201d80 <commands+0x278>
ffffffffc02005bc:	af7ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    cprintf("  s7       0x%08x\n", gpr->s7);
ffffffffc02005c0:	7c4c                	ld	a1,184(s0)
ffffffffc02005c2:	00001517          	auipc	a0,0x1
ffffffffc02005c6:	7d650513          	addi	a0,a0,2006 # ffffffffc0201d98 <commands+0x290>
ffffffffc02005ca:	ae9ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    cprintf("  s8       0x%08x\n", gpr->s8);
ffffffffc02005ce:	606c                	ld	a1,192(s0)
ffffffffc02005d0:	00001517          	auipc	a0,0x1
ffffffffc02005d4:	7e050513          	addi	a0,a0,2016 # ffffffffc0201db0 <commands+0x2a8>
ffffffffc02005d8:	adbff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    cprintf("  s9       0x%08x\n", gpr->s9);
ffffffffc02005dc:	646c                	ld	a1,200(s0)
ffffffffc02005de:	00001517          	auipc	a0,0x1
ffffffffc02005e2:	7ea50513          	addi	a0,a0,2026 # ffffffffc0201dc8 <commands+0x2c0>
ffffffffc02005e6:	acdff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    cprintf("  s10      0x%08x\n", gpr->s10);
ffffffffc02005ea:	686c                	ld	a1,208(s0)
ffffffffc02005ec:	00001517          	auipc	a0,0x1
ffffffffc02005f0:	7f450513          	addi	a0,a0,2036 # ffffffffc0201de0 <commands+0x2d8>
ffffffffc02005f4:	abfff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    cprintf("  s11      0x%08x\n", gpr->s11);
ffffffffc02005f8:	6c6c                	ld	a1,216(s0)
ffffffffc02005fa:	00001517          	auipc	a0,0x1
ffffffffc02005fe:	7fe50513          	addi	a0,a0,2046 # ffffffffc0201df8 <commands+0x2f0>
ffffffffc0200602:	ab1ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    cprintf("  t3       0x%08x\n", gpr->t3);
ffffffffc0200606:	706c                	ld	a1,224(s0)
ffffffffc0200608:	00002517          	auipc	a0,0x2
ffffffffc020060c:	80850513          	addi	a0,a0,-2040 # ffffffffc0201e10 <commands+0x308>
ffffffffc0200610:	aa3ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    cprintf("  t4       0x%08x\n", gpr->t4);
ffffffffc0200614:	746c                	ld	a1,232(s0)
ffffffffc0200616:	00002517          	auipc	a0,0x2
ffffffffc020061a:	81250513          	addi	a0,a0,-2030 # ffffffffc0201e28 <commands+0x320>
ffffffffc020061e:	a95ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    cprintf("  t5       0x%08x\n", gpr->t5);
ffffffffc0200622:	786c                	ld	a1,240(s0)
ffffffffc0200624:	00002517          	auipc	a0,0x2
ffffffffc0200628:	81c50513          	addi	a0,a0,-2020 # ffffffffc0201e40 <commands+0x338>
ffffffffc020062c:	a87ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    cprintf("  t6       0x%08x\n", gpr->t6);
ffffffffc0200630:	7c6c                	ld	a1,248(s0)
}
ffffffffc0200632:	6402                	ld	s0,0(sp)
ffffffffc0200634:	60a2                	ld	ra,8(sp)
    cprintf("  t6       0x%08x\n", gpr->t6);
ffffffffc0200636:	00002517          	auipc	a0,0x2
ffffffffc020063a:	82250513          	addi	a0,a0,-2014 # ffffffffc0201e58 <commands+0x350>
}
ffffffffc020063e:	0141                	addi	sp,sp,16
    cprintf("  t6       0x%08x\n", gpr->t6);
ffffffffc0200640:	bc8d                	j	ffffffffc02000b2 <cprintf>

ffffffffc0200642 <print_trapframe>:
void print_trapframe(struct trapframe *tf) {
ffffffffc0200642:	1141                	addi	sp,sp,-16
ffffffffc0200644:	e022                	sd	s0,0(sp)
    cprintf("trapframe at %p\n", tf);
ffffffffc0200646:	85aa                	mv	a1,a0
void print_trapframe(struct trapframe *tf) {
ffffffffc0200648:	842a                	mv	s0,a0
    cprintf("trapframe at %p\n", tf);
ffffffffc020064a:	00002517          	auipc	a0,0x2
ffffffffc020064e:	82650513          	addi	a0,a0,-2010 # ffffffffc0201e70 <commands+0x368>
void print_trapframe(struct trapframe *tf) {
ffffffffc0200652:	e406                	sd	ra,8(sp)
    cprintf("trapframe at %p\n", tf);
ffffffffc0200654:	a5fff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    print_regs(&tf->gpr);
ffffffffc0200658:	8522                	mv	a0,s0
ffffffffc020065a:	e1dff0ef          	jal	ra,ffffffffc0200476 <print_regs>
    cprintf("  status   0x%08x\n", tf->status);
ffffffffc020065e:	10043583          	ld	a1,256(s0)
ffffffffc0200662:	00002517          	auipc	a0,0x2
ffffffffc0200666:	82650513          	addi	a0,a0,-2010 # ffffffffc0201e88 <commands+0x380>
ffffffffc020066a:	a49ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    cprintf("  epc      0x%08x\n", tf->epc);
ffffffffc020066e:	10843583          	ld	a1,264(s0)
ffffffffc0200672:	00002517          	auipc	a0,0x2
ffffffffc0200676:	82e50513          	addi	a0,a0,-2002 # ffffffffc0201ea0 <commands+0x398>
ffffffffc020067a:	a39ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    cprintf("  badvaddr 0x%08x\n", tf->badvaddr);
ffffffffc020067e:	11043583          	ld	a1,272(s0)
ffffffffc0200682:	00002517          	auipc	a0,0x2
ffffffffc0200686:	83650513          	addi	a0,a0,-1994 # ffffffffc0201eb8 <commands+0x3b0>
ffffffffc020068a:	a29ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    cprintf("  cause    0x%08x\n", tf->cause);
ffffffffc020068e:	11843583          	ld	a1,280(s0)
}
ffffffffc0200692:	6402                	ld	s0,0(sp)
ffffffffc0200694:	60a2                	ld	ra,8(sp)
    cprintf("  cause    0x%08x\n", tf->cause);
ffffffffc0200696:	00002517          	auipc	a0,0x2
ffffffffc020069a:	83a50513          	addi	a0,a0,-1990 # ffffffffc0201ed0 <commands+0x3c8>
}
ffffffffc020069e:	0141                	addi	sp,sp,16
    cprintf("  cause    0x%08x\n", tf->cause);
ffffffffc02006a0:	bc09                	j	ffffffffc02000b2 <cprintf>

ffffffffc02006a2 <interrupt_handler>:

void interrupt_handler(struct trapframe *tf) {
    intptr_t cause = (tf->cause << 1) >> 1;
ffffffffc02006a2:	11853783          	ld	a5,280(a0)
ffffffffc02006a6:	472d                	li	a4,11
ffffffffc02006a8:	0786                	slli	a5,a5,0x1
ffffffffc02006aa:	8385                	srli	a5,a5,0x1
ffffffffc02006ac:	06f76c63          	bltu	a4,a5,ffffffffc0200724 <interrupt_handler+0x82>
ffffffffc02006b0:	00002717          	auipc	a4,0x2
ffffffffc02006b4:	90070713          	addi	a4,a4,-1792 # ffffffffc0201fb0 <commands+0x4a8>
ffffffffc02006b8:	078a                	slli	a5,a5,0x2
ffffffffc02006ba:	97ba                	add	a5,a5,a4
ffffffffc02006bc:	439c                	lw	a5,0(a5)
ffffffffc02006be:	97ba                	add	a5,a5,a4
ffffffffc02006c0:	8782                	jr	a5
            break;
        case IRQ_H_SOFT:
            cprintf("Hypervisor software interrupt\n");
            break;
        case IRQ_M_SOFT:
            cprintf("Machine software interrupt\n");
ffffffffc02006c2:	00002517          	auipc	a0,0x2
ffffffffc02006c6:	88650513          	addi	a0,a0,-1914 # ffffffffc0201f48 <commands+0x440>
ffffffffc02006ca:	b2e5                	j	ffffffffc02000b2 <cprintf>
            cprintf("Hypervisor software interrupt\n");
ffffffffc02006cc:	00002517          	auipc	a0,0x2
ffffffffc02006d0:	85c50513          	addi	a0,a0,-1956 # ffffffffc0201f28 <commands+0x420>
ffffffffc02006d4:	baf9                	j	ffffffffc02000b2 <cprintf>
            cprintf("User software interrupt\n");
ffffffffc02006d6:	00002517          	auipc	a0,0x2
ffffffffc02006da:	81250513          	addi	a0,a0,-2030 # ffffffffc0201ee8 <commands+0x3e0>
ffffffffc02006de:	bad1                	j	ffffffffc02000b2 <cprintf>
            break;
        case IRQ_U_TIMER:
            cprintf("User Timer interrupt\n");
ffffffffc02006e0:	00002517          	auipc	a0,0x2
ffffffffc02006e4:	88850513          	addi	a0,a0,-1912 # ffffffffc0201f68 <commands+0x460>
ffffffffc02006e8:	b2e9                	j	ffffffffc02000b2 <cprintf>
void interrupt_handler(struct trapframe *tf) {
ffffffffc02006ea:	1141                	addi	sp,sp,-16
ffffffffc02006ec:	e406                	sd	ra,8(sp)
            // read-only." -- privileged spec1.9.1, 4.1.4, p59
            // In fact, Call sbi_set_timer will clear STIP, or you can clear it
            // directly.
            // cprintf("Supervisor timer interrupt\n");
            // clear_csr(sip, SIP_STIP);
            clock_set_next_event();
ffffffffc02006ee:	d4dff0ef          	jal	ra,ffffffffc020043a <clock_set_next_event>
            if (++ticks % TICK_NUM == 0) {
ffffffffc02006f2:	00006697          	auipc	a3,0x6
ffffffffc02006f6:	d3e68693          	addi	a3,a3,-706 # ffffffffc0206430 <ticks>
ffffffffc02006fa:	629c                	ld	a5,0(a3)
ffffffffc02006fc:	06400713          	li	a4,100
ffffffffc0200700:	0785                	addi	a5,a5,1
ffffffffc0200702:	02e7f733          	remu	a4,a5,a4
ffffffffc0200706:	e29c                	sd	a5,0(a3)
ffffffffc0200708:	cf19                	beqz	a4,ffffffffc0200726 <interrupt_handler+0x84>
            break;
        default:
            print_trapframe(tf);
            break;
    }
}
ffffffffc020070a:	60a2                	ld	ra,8(sp)
ffffffffc020070c:	0141                	addi	sp,sp,16
ffffffffc020070e:	8082                	ret
            cprintf("Supervisor external interrupt\n");
ffffffffc0200710:	00002517          	auipc	a0,0x2
ffffffffc0200714:	88050513          	addi	a0,a0,-1920 # ffffffffc0201f90 <commands+0x488>
ffffffffc0200718:	ba69                	j	ffffffffc02000b2 <cprintf>
            cprintf("Supervisor software interrupt\n");
ffffffffc020071a:	00001517          	auipc	a0,0x1
ffffffffc020071e:	7ee50513          	addi	a0,a0,2030 # ffffffffc0201f08 <commands+0x400>
ffffffffc0200722:	ba41                	j	ffffffffc02000b2 <cprintf>
            print_trapframe(tf);
ffffffffc0200724:	bf39                	j	ffffffffc0200642 <print_trapframe>
}
ffffffffc0200726:	60a2                	ld	ra,8(sp)
    cprintf("%d ticks\n", TICK_NUM);
ffffffffc0200728:	06400593          	li	a1,100
ffffffffc020072c:	00002517          	auipc	a0,0x2
ffffffffc0200730:	85450513          	addi	a0,a0,-1964 # ffffffffc0201f80 <commands+0x478>
}
ffffffffc0200734:	0141                	addi	sp,sp,16
    cprintf("%d ticks\n", TICK_NUM);
ffffffffc0200736:	bab5                	j	ffffffffc02000b2 <cprintf>

ffffffffc0200738 <trap>:
            break;
    }
}

static inline void trap_dispatch(struct trapframe *tf) {
    if ((intptr_t)tf->cause < 0) {
ffffffffc0200738:	11853783          	ld	a5,280(a0)
ffffffffc020073c:	0007c763          	bltz	a5,ffffffffc020074a <trap+0x12>
    switch (tf->cause) {
ffffffffc0200740:	472d                	li	a4,11
ffffffffc0200742:	00f76363          	bltu	a4,a5,ffffffffc0200748 <trap+0x10>
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void trap(struct trapframe *tf) {
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
}
ffffffffc0200746:	8082                	ret
            print_trapframe(tf);
ffffffffc0200748:	bded                	j	ffffffffc0200642 <print_trapframe>
        interrupt_handler(tf);
ffffffffc020074a:	bfa1                	j	ffffffffc02006a2 <interrupt_handler>

ffffffffc020074c <__alltraps>:
    .endm

    .globl __alltraps
    .align(2)
__alltraps:
    SAVE_ALL
ffffffffc020074c:	14011073          	csrw	sscratch,sp
ffffffffc0200750:	712d                	addi	sp,sp,-288
ffffffffc0200752:	e002                	sd	zero,0(sp)
ffffffffc0200754:	e406                	sd	ra,8(sp)
ffffffffc0200756:	ec0e                	sd	gp,24(sp)
ffffffffc0200758:	f012                	sd	tp,32(sp)
ffffffffc020075a:	f416                	sd	t0,40(sp)
ffffffffc020075c:	f81a                	sd	t1,48(sp)
ffffffffc020075e:	fc1e                	sd	t2,56(sp)
ffffffffc0200760:	e0a2                	sd	s0,64(sp)
ffffffffc0200762:	e4a6                	sd	s1,72(sp)
ffffffffc0200764:	e8aa                	sd	a0,80(sp)
ffffffffc0200766:	ecae                	sd	a1,88(sp)
ffffffffc0200768:	f0b2                	sd	a2,96(sp)
ffffffffc020076a:	f4b6                	sd	a3,104(sp)
ffffffffc020076c:	f8ba                	sd	a4,112(sp)
ffffffffc020076e:	fcbe                	sd	a5,120(sp)
ffffffffc0200770:	e142                	sd	a6,128(sp)
ffffffffc0200772:	e546                	sd	a7,136(sp)
ffffffffc0200774:	e94a                	sd	s2,144(sp)
ffffffffc0200776:	ed4e                	sd	s3,152(sp)
ffffffffc0200778:	f152                	sd	s4,160(sp)
ffffffffc020077a:	f556                	sd	s5,168(sp)
ffffffffc020077c:	f95a                	sd	s6,176(sp)
ffffffffc020077e:	fd5e                	sd	s7,184(sp)
ffffffffc0200780:	e1e2                	sd	s8,192(sp)
ffffffffc0200782:	e5e6                	sd	s9,200(sp)
ffffffffc0200784:	e9ea                	sd	s10,208(sp)
ffffffffc0200786:	edee                	sd	s11,216(sp)
ffffffffc0200788:	f1f2                	sd	t3,224(sp)
ffffffffc020078a:	f5f6                	sd	t4,232(sp)
ffffffffc020078c:	f9fa                	sd	t5,240(sp)
ffffffffc020078e:	fdfe                	sd	t6,248(sp)
ffffffffc0200790:	14001473          	csrrw	s0,sscratch,zero
ffffffffc0200794:	100024f3          	csrr	s1,sstatus
ffffffffc0200798:	14102973          	csrr	s2,sepc
ffffffffc020079c:	143029f3          	csrr	s3,stval
ffffffffc02007a0:	14202a73          	csrr	s4,scause
ffffffffc02007a4:	e822                	sd	s0,16(sp)
ffffffffc02007a6:	e226                	sd	s1,256(sp)
ffffffffc02007a8:	e64a                	sd	s2,264(sp)
ffffffffc02007aa:	ea4e                	sd	s3,272(sp)
ffffffffc02007ac:	ee52                	sd	s4,280(sp)

    move  a0, sp
ffffffffc02007ae:	850a                	mv	a0,sp
    jal trap
ffffffffc02007b0:	f89ff0ef          	jal	ra,ffffffffc0200738 <trap>

ffffffffc02007b4 <__trapret>:
    # sp should be the same as before "jal trap"

    .globl __trapret
__trapret:
    RESTORE_ALL
ffffffffc02007b4:	6492                	ld	s1,256(sp)
ffffffffc02007b6:	6932                	ld	s2,264(sp)
ffffffffc02007b8:	10049073          	csrw	sstatus,s1
ffffffffc02007bc:	14191073          	csrw	sepc,s2
ffffffffc02007c0:	60a2                	ld	ra,8(sp)
ffffffffc02007c2:	61e2                	ld	gp,24(sp)
ffffffffc02007c4:	7202                	ld	tp,32(sp)
ffffffffc02007c6:	72a2                	ld	t0,40(sp)
ffffffffc02007c8:	7342                	ld	t1,48(sp)
ffffffffc02007ca:	73e2                	ld	t2,56(sp)
ffffffffc02007cc:	6406                	ld	s0,64(sp)
ffffffffc02007ce:	64a6                	ld	s1,72(sp)
ffffffffc02007d0:	6546                	ld	a0,80(sp)
ffffffffc02007d2:	65e6                	ld	a1,88(sp)
ffffffffc02007d4:	7606                	ld	a2,96(sp)
ffffffffc02007d6:	76a6                	ld	a3,104(sp)
ffffffffc02007d8:	7746                	ld	a4,112(sp)
ffffffffc02007da:	77e6                	ld	a5,120(sp)
ffffffffc02007dc:	680a                	ld	a6,128(sp)
ffffffffc02007de:	68aa                	ld	a7,136(sp)
ffffffffc02007e0:	694a                	ld	s2,144(sp)
ffffffffc02007e2:	69ea                	ld	s3,152(sp)
ffffffffc02007e4:	7a0a                	ld	s4,160(sp)
ffffffffc02007e6:	7aaa                	ld	s5,168(sp)
ffffffffc02007e8:	7b4a                	ld	s6,176(sp)
ffffffffc02007ea:	7bea                	ld	s7,184(sp)
ffffffffc02007ec:	6c0e                	ld	s8,192(sp)
ffffffffc02007ee:	6cae                	ld	s9,200(sp)
ffffffffc02007f0:	6d4e                	ld	s10,208(sp)
ffffffffc02007f2:	6dee                	ld	s11,216(sp)
ffffffffc02007f4:	7e0e                	ld	t3,224(sp)
ffffffffc02007f6:	7eae                	ld	t4,232(sp)
ffffffffc02007f8:	7f4e                	ld	t5,240(sp)
ffffffffc02007fa:	7fee                	ld	t6,248(sp)
ffffffffc02007fc:	6142                	ld	sp,16(sp)
    # return from supervisor call
    sret
ffffffffc02007fe:	10200073          	sret

ffffffffc0200802 <buddy_system_init>:
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
ffffffffc0200802:	00006797          	auipc	a5,0x6
ffffffffc0200806:	80e78793          	addi	a5,a5,-2034 # ffffffffc0206010 <bsfree_area>
ffffffffc020080a:	e79c                	sd	a5,8(a5)
ffffffffc020080c:	e39c                	sd	a5,0(a5)


static void
buddy_system_init(void) {
    list_init(&free_list);
    nr_free = 0;
ffffffffc020080e:	0007a823          	sw	zero,16(a5)
}
ffffffffc0200812:	8082                	ret

ffffffffc0200814 <buddy_system_nr_free_pages>:
}

static size_t
buddy_system_nr_free_pages(void) {
    return nr_free;
}
ffffffffc0200814:	00006517          	auipc	a0,0x6
ffffffffc0200818:	80c56503          	lwu	a0,-2036(a0) # ffffffffc0206020 <bsfree_area+0x10>
ffffffffc020081c:	8082                	ret

ffffffffc020081e <buddy_system_check>:
}

// LAB2: below code is used to check the best fit allocation algorithm 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
buddy_system_check(void) {
ffffffffc020081e:	7179                	addi	sp,sp,-48
ffffffffc0200820:	f406                	sd	ra,40(sp)
ffffffffc0200822:	f022                	sd	s0,32(sp)
ffffffffc0200824:	ec26                	sd	s1,24(sp)
ffffffffc0200826:	e84a                	sd	s2,16(sp)
ffffffffc0200828:	e44e                	sd	s3,8(sp)
    int all_pages = nr_free_pages();
ffffffffc020082a:	129000ef          	jal	ra,ffffffffc0201152 <nr_free_pages>
    struct Page* p0, *p1, *p2, *p3;
    // 分配过大的页数
    assert(alloc_pages(all_pages + 1) == NULL);
ffffffffc020082e:	2505                	addiw	a0,a0,1
ffffffffc0200830:	0a5000ef          	jal	ra,ffffffffc02010d4 <alloc_pages>
ffffffffc0200834:	1c051663          	bnez	a0,ffffffffc0200a00 <buddy_system_check+0x1e2>
    // 分配两个组页
    p0 = alloc_pages(1);
ffffffffc0200838:	4505                	li	a0,1
ffffffffc020083a:	09b000ef          	jal	ra,ffffffffc02010d4 <alloc_pages>
ffffffffc020083e:	842a                	mv	s0,a0
    assert(p0 != NULL);
ffffffffc0200840:	1a050063          	beqz	a0,ffffffffc02009e0 <buddy_system_check+0x1c2>
    p1 = alloc_pages(2);
ffffffffc0200844:	4509                	li	a0,2
ffffffffc0200846:	08f000ef          	jal	ra,ffffffffc02010d4 <alloc_pages>
    assert(p1 == p0 + 2);
ffffffffc020084a:	05040793          	addi	a5,s0,80
    p1 = alloc_pages(2);
ffffffffc020084e:	84aa                	mv	s1,a0
    assert(p1 == p0 + 2);
ffffffffc0200850:	16f51863          	bne	a0,a5,ffffffffc02009c0 <buddy_system_check+0x1a2>
 * test_bit - Determine whether a bit is set
 * @nr:     the bit to test
 * @addr:   the address to count from
 * */
static inline bool test_bit(int nr, volatile void *addr) {
    return (((*(volatile unsigned long *)addr) >> nr) & 1);
ffffffffc0200854:	641c                	ld	a5,8(s0)
    assert(!PageReserved(p0) && !PageProperty(p0));
ffffffffc0200856:	8b85                	andi	a5,a5,1
ffffffffc0200858:	10079463          	bnez	a5,ffffffffc0200960 <buddy_system_check+0x142>
ffffffffc020085c:	641c                	ld	a5,8(s0)
ffffffffc020085e:	8385                	srli	a5,a5,0x1
ffffffffc0200860:	8b85                	andi	a5,a5,1
ffffffffc0200862:	0e079f63          	bnez	a5,ffffffffc0200960 <buddy_system_check+0x142>
ffffffffc0200866:	651c                	ld	a5,8(a0)
    assert(!PageReserved(p1) && !PageProperty(p1));
ffffffffc0200868:	8b85                	andi	a5,a5,1
ffffffffc020086a:	0c079b63          	bnez	a5,ffffffffc0200940 <buddy_system_check+0x122>
ffffffffc020086e:	651c                	ld	a5,8(a0)
ffffffffc0200870:	8385                	srli	a5,a5,0x1
ffffffffc0200872:	8b85                	andi	a5,a5,1
ffffffffc0200874:	e7f1                	bnez	a5,ffffffffc0200940 <buddy_system_check+0x122>
    // 再分配两个组页
    p2 = alloc_pages(1);
ffffffffc0200876:	4505                	li	a0,1
ffffffffc0200878:	05d000ef          	jal	ra,ffffffffc02010d4 <alloc_pages>
    assert(p2 == p0 + 1);
ffffffffc020087c:	02840793          	addi	a5,s0,40
    p2 = alloc_pages(1);
ffffffffc0200880:	89aa                	mv	s3,a0
    assert(p2 == p0 + 1);
ffffffffc0200882:	10f51f63          	bne	a0,a5,ffffffffc02009a0 <buddy_system_check+0x182>
    p3 = alloc_pages(8);
ffffffffc0200886:	4521                	li	a0,8
ffffffffc0200888:	04d000ef          	jal	ra,ffffffffc02010d4 <alloc_pages>
    assert(p3 == p0 + 8);
ffffffffc020088c:	14040793          	addi	a5,s0,320
    p3 = alloc_pages(8);
ffffffffc0200890:	892a                	mv	s2,a0
    assert(p3 == p0 + 8);
ffffffffc0200892:	0ef51763          	bne	a0,a5,ffffffffc0200980 <buddy_system_check+0x162>
ffffffffc0200896:	651c                	ld	a5,8(a0)
ffffffffc0200898:	8385                	srli	a5,a5,0x1
    assert(!PageProperty(p3) && !PageProperty(p3 + 7) && PageProperty(p3 + 8));
ffffffffc020089a:	8b85                	andi	a5,a5,1
ffffffffc020089c:	e3d1                	bnez	a5,ffffffffc0200920 <buddy_system_check+0x102>
ffffffffc020089e:	12053783          	ld	a5,288(a0)
ffffffffc02008a2:	8385                	srli	a5,a5,0x1
ffffffffc02008a4:	8b85                	andi	a5,a5,1
ffffffffc02008a6:	efad                	bnez	a5,ffffffffc0200920 <buddy_system_check+0x102>
ffffffffc02008a8:	14853783          	ld	a5,328(a0)
ffffffffc02008ac:	8385                	srli	a5,a5,0x1
ffffffffc02008ae:	8b85                	andi	a5,a5,1
ffffffffc02008b0:	cba5                	beqz	a5,ffffffffc0200920 <buddy_system_check+0x102>
    // 回收页
    free_pages(p1, 2);
ffffffffc02008b2:	4589                	li	a1,2
ffffffffc02008b4:	8526                	mv	a0,s1
ffffffffc02008b6:	05d000ef          	jal	ra,ffffffffc0201112 <free_pages>
ffffffffc02008ba:	649c                	ld	a5,8(s1)
ffffffffc02008bc:	8385                	srli	a5,a5,0x1
    assert(PageProperty(p1));
ffffffffc02008be:	8b85                	andi	a5,a5,1
ffffffffc02008c0:	1e078063          	beqz	a5,ffffffffc0200aa0 <buddy_system_check+0x282>
    assert(p1->ref == 0);
ffffffffc02008c4:	409c                	lw	a5,0(s1)
ffffffffc02008c6:	1a079d63          	bnez	a5,ffffffffc0200a80 <buddy_system_check+0x262>
    free_pages(p0, 1);
ffffffffc02008ca:	4585                	li	a1,1
ffffffffc02008cc:	8522                	mv	a0,s0
ffffffffc02008ce:	045000ef          	jal	ra,ffffffffc0201112 <free_pages>
    free_pages(p2, 1);
ffffffffc02008d2:	854e                	mv	a0,s3
ffffffffc02008d4:	4585                	li	a1,1
ffffffffc02008d6:	03d000ef          	jal	ra,ffffffffc0201112 <free_pages>
    // 回收后再分配
    p2 = alloc_pages(3);
ffffffffc02008da:	450d                	li	a0,3
ffffffffc02008dc:	7f8000ef          	jal	ra,ffffffffc02010d4 <alloc_pages>
    assert(p2 == p0);
ffffffffc02008e0:	18a41063          	bne	s0,a0,ffffffffc0200a60 <buddy_system_check+0x242>
    free_pages(p2, 3);
ffffffffc02008e4:	458d                	li	a1,3
ffffffffc02008e6:	02d000ef          	jal	ra,ffffffffc0201112 <free_pages>
    assert((p2 + 2)->ref == 0);
ffffffffc02008ea:	483c                	lw	a5,80(s0)
ffffffffc02008ec:	14079a63          	bnez	a5,ffffffffc0200a40 <buddy_system_check+0x222>
    //assert(nr_free_pages() == all_pages >> 1);

    p1 = alloc_pages(129);
ffffffffc02008f0:	08100513          	li	a0,129
ffffffffc02008f4:	7e0000ef          	jal	ra,ffffffffc02010d4 <alloc_pages>
    assert(p1 == p0 + 256);
ffffffffc02008f8:	678d                	lui	a5,0x3
ffffffffc02008fa:	80078793          	addi	a5,a5,-2048 # 2800 <kern_entry-0xffffffffc01fd800>
ffffffffc02008fe:	943e                	add	s0,s0,a5
ffffffffc0200900:	12851063          	bne	a0,s0,ffffffffc0200a20 <buddy_system_check+0x202>
    free_pages(p1, 256);
ffffffffc0200904:	10000593          	li	a1,256
ffffffffc0200908:	00b000ef          	jal	ra,ffffffffc0201112 <free_pages>
    free_pages(p3, 8);
}
ffffffffc020090c:	7402                	ld	s0,32(sp)
ffffffffc020090e:	70a2                	ld	ra,40(sp)
ffffffffc0200910:	64e2                	ld	s1,24(sp)
ffffffffc0200912:	69a2                	ld	s3,8(sp)
    free_pages(p3, 8);
ffffffffc0200914:	854a                	mv	a0,s2
}
ffffffffc0200916:	6942                	ld	s2,16(sp)
    free_pages(p3, 8);
ffffffffc0200918:	45a1                	li	a1,8
}
ffffffffc020091a:	6145                	addi	sp,sp,48
    free_pages(p3, 8);
ffffffffc020091c:	7f60006f          	j	ffffffffc0201112 <free_pages>
    assert(!PageProperty(p3) && !PageProperty(p3 + 7) && PageProperty(p3 + 8));
ffffffffc0200920:	00001697          	auipc	a3,0x1
ffffffffc0200924:	7b068693          	addi	a3,a3,1968 # ffffffffc02020d0 <commands+0x5c8>
ffffffffc0200928:	00001617          	auipc	a2,0x1
ffffffffc020092c:	6e060613          	addi	a2,a2,1760 # ffffffffc0202008 <commands+0x500>
ffffffffc0200930:	1a200593          	li	a1,418
ffffffffc0200934:	00001517          	auipc	a0,0x1
ffffffffc0200938:	6ec50513          	addi	a0,a0,1772 # ffffffffc0202020 <commands+0x518>
ffffffffc020093c:	ffeff0ef          	jal	ra,ffffffffc020013a <__panic>
    assert(!PageReserved(p1) && !PageProperty(p1));
ffffffffc0200940:	00001697          	auipc	a3,0x1
ffffffffc0200944:	74868693          	addi	a3,a3,1864 # ffffffffc0202088 <commands+0x580>
ffffffffc0200948:	00001617          	auipc	a2,0x1
ffffffffc020094c:	6c060613          	addi	a2,a2,1728 # ffffffffc0202008 <commands+0x500>
ffffffffc0200950:	19c00593          	li	a1,412
ffffffffc0200954:	00001517          	auipc	a0,0x1
ffffffffc0200958:	6cc50513          	addi	a0,a0,1740 # ffffffffc0202020 <commands+0x518>
ffffffffc020095c:	fdeff0ef          	jal	ra,ffffffffc020013a <__panic>
    assert(!PageReserved(p0) && !PageProperty(p0));
ffffffffc0200960:	00001697          	auipc	a3,0x1
ffffffffc0200964:	70068693          	addi	a3,a3,1792 # ffffffffc0202060 <commands+0x558>
ffffffffc0200968:	00001617          	auipc	a2,0x1
ffffffffc020096c:	6a060613          	addi	a2,a2,1696 # ffffffffc0202008 <commands+0x500>
ffffffffc0200970:	19b00593          	li	a1,411
ffffffffc0200974:	00001517          	auipc	a0,0x1
ffffffffc0200978:	6ac50513          	addi	a0,a0,1708 # ffffffffc0202020 <commands+0x518>
ffffffffc020097c:	fbeff0ef          	jal	ra,ffffffffc020013a <__panic>
    assert(p3 == p0 + 8);
ffffffffc0200980:	00001697          	auipc	a3,0x1
ffffffffc0200984:	74068693          	addi	a3,a3,1856 # ffffffffc02020c0 <commands+0x5b8>
ffffffffc0200988:	00001617          	auipc	a2,0x1
ffffffffc020098c:	68060613          	addi	a2,a2,1664 # ffffffffc0202008 <commands+0x500>
ffffffffc0200990:	1a100593          	li	a1,417
ffffffffc0200994:	00001517          	auipc	a0,0x1
ffffffffc0200998:	68c50513          	addi	a0,a0,1676 # ffffffffc0202020 <commands+0x518>
ffffffffc020099c:	f9eff0ef          	jal	ra,ffffffffc020013a <__panic>
    assert(p2 == p0 + 1);
ffffffffc02009a0:	00001697          	auipc	a3,0x1
ffffffffc02009a4:	71068693          	addi	a3,a3,1808 # ffffffffc02020b0 <commands+0x5a8>
ffffffffc02009a8:	00001617          	auipc	a2,0x1
ffffffffc02009ac:	66060613          	addi	a2,a2,1632 # ffffffffc0202008 <commands+0x500>
ffffffffc02009b0:	19f00593          	li	a1,415
ffffffffc02009b4:	00001517          	auipc	a0,0x1
ffffffffc02009b8:	66c50513          	addi	a0,a0,1644 # ffffffffc0202020 <commands+0x518>
ffffffffc02009bc:	f7eff0ef          	jal	ra,ffffffffc020013a <__panic>
    assert(p1 == p0 + 2);
ffffffffc02009c0:	00001697          	auipc	a3,0x1
ffffffffc02009c4:	69068693          	addi	a3,a3,1680 # ffffffffc0202050 <commands+0x548>
ffffffffc02009c8:	00001617          	auipc	a2,0x1
ffffffffc02009cc:	64060613          	addi	a2,a2,1600 # ffffffffc0202008 <commands+0x500>
ffffffffc02009d0:	19a00593          	li	a1,410
ffffffffc02009d4:	00001517          	auipc	a0,0x1
ffffffffc02009d8:	64c50513          	addi	a0,a0,1612 # ffffffffc0202020 <commands+0x518>
ffffffffc02009dc:	f5eff0ef          	jal	ra,ffffffffc020013a <__panic>
    assert(p0 != NULL);
ffffffffc02009e0:	00001697          	auipc	a3,0x1
ffffffffc02009e4:	66068693          	addi	a3,a3,1632 # ffffffffc0202040 <commands+0x538>
ffffffffc02009e8:	00001617          	auipc	a2,0x1
ffffffffc02009ec:	62060613          	addi	a2,a2,1568 # ffffffffc0202008 <commands+0x500>
ffffffffc02009f0:	19800593          	li	a1,408
ffffffffc02009f4:	00001517          	auipc	a0,0x1
ffffffffc02009f8:	62c50513          	addi	a0,a0,1580 # ffffffffc0202020 <commands+0x518>
ffffffffc02009fc:	f3eff0ef          	jal	ra,ffffffffc020013a <__panic>
    assert(alloc_pages(all_pages + 1) == NULL);
ffffffffc0200a00:	00001697          	auipc	a3,0x1
ffffffffc0200a04:	5e068693          	addi	a3,a3,1504 # ffffffffc0201fe0 <commands+0x4d8>
ffffffffc0200a08:	00001617          	auipc	a2,0x1
ffffffffc0200a0c:	60060613          	addi	a2,a2,1536 # ffffffffc0202008 <commands+0x500>
ffffffffc0200a10:	19500593          	li	a1,405
ffffffffc0200a14:	00001517          	auipc	a0,0x1
ffffffffc0200a18:	60c50513          	addi	a0,a0,1548 # ffffffffc0202020 <commands+0x518>
ffffffffc0200a1c:	f1eff0ef          	jal	ra,ffffffffc020013a <__panic>
    assert(p1 == p0 + 256);
ffffffffc0200a20:	00001697          	auipc	a3,0x1
ffffffffc0200a24:	74868693          	addi	a3,a3,1864 # ffffffffc0202168 <commands+0x660>
ffffffffc0200a28:	00001617          	auipc	a2,0x1
ffffffffc0200a2c:	5e060613          	addi	a2,a2,1504 # ffffffffc0202008 <commands+0x500>
ffffffffc0200a30:	1b100593          	li	a1,433
ffffffffc0200a34:	00001517          	auipc	a0,0x1
ffffffffc0200a38:	5ec50513          	addi	a0,a0,1516 # ffffffffc0202020 <commands+0x518>
ffffffffc0200a3c:	efeff0ef          	jal	ra,ffffffffc020013a <__panic>
    assert((p2 + 2)->ref == 0);
ffffffffc0200a40:	00001697          	auipc	a3,0x1
ffffffffc0200a44:	71068693          	addi	a3,a3,1808 # ffffffffc0202150 <commands+0x648>
ffffffffc0200a48:	00001617          	auipc	a2,0x1
ffffffffc0200a4c:	5c060613          	addi	a2,a2,1472 # ffffffffc0202008 <commands+0x500>
ffffffffc0200a50:	1ad00593          	li	a1,429
ffffffffc0200a54:	00001517          	auipc	a0,0x1
ffffffffc0200a58:	5cc50513          	addi	a0,a0,1484 # ffffffffc0202020 <commands+0x518>
ffffffffc0200a5c:	edeff0ef          	jal	ra,ffffffffc020013a <__panic>
    assert(p2 == p0);
ffffffffc0200a60:	00001697          	auipc	a3,0x1
ffffffffc0200a64:	6e068693          	addi	a3,a3,1760 # ffffffffc0202140 <commands+0x638>
ffffffffc0200a68:	00001617          	auipc	a2,0x1
ffffffffc0200a6c:	5a060613          	addi	a2,a2,1440 # ffffffffc0202008 <commands+0x500>
ffffffffc0200a70:	1ab00593          	li	a1,427
ffffffffc0200a74:	00001517          	auipc	a0,0x1
ffffffffc0200a78:	5ac50513          	addi	a0,a0,1452 # ffffffffc0202020 <commands+0x518>
ffffffffc0200a7c:	ebeff0ef          	jal	ra,ffffffffc020013a <__panic>
    assert(p1->ref == 0);
ffffffffc0200a80:	00001697          	auipc	a3,0x1
ffffffffc0200a84:	6b068693          	addi	a3,a3,1712 # ffffffffc0202130 <commands+0x628>
ffffffffc0200a88:	00001617          	auipc	a2,0x1
ffffffffc0200a8c:	58060613          	addi	a2,a2,1408 # ffffffffc0202008 <commands+0x500>
ffffffffc0200a90:	1a600593          	li	a1,422
ffffffffc0200a94:	00001517          	auipc	a0,0x1
ffffffffc0200a98:	58c50513          	addi	a0,a0,1420 # ffffffffc0202020 <commands+0x518>
ffffffffc0200a9c:	e9eff0ef          	jal	ra,ffffffffc020013a <__panic>
    assert(PageProperty(p1));
ffffffffc0200aa0:	00001697          	auipc	a3,0x1
ffffffffc0200aa4:	67868693          	addi	a3,a3,1656 # ffffffffc0202118 <commands+0x610>
ffffffffc0200aa8:	00001617          	auipc	a2,0x1
ffffffffc0200aac:	56060613          	addi	a2,a2,1376 # ffffffffc0202008 <commands+0x500>
ffffffffc0200ab0:	1a500593          	li	a1,421
ffffffffc0200ab4:	00001517          	auipc	a0,0x1
ffffffffc0200ab8:	56c50513          	addi	a0,a0,1388 # ffffffffc0202020 <commands+0x518>
ffffffffc0200abc:	e7eff0ef          	jal	ra,ffffffffc020013a <__panic>

ffffffffc0200ac0 <memtree_init>:
    while(np>size)
ffffffffc0200ac0:	4785                	li	a5,1
ffffffffc0200ac2:	12b7da63          	bge	a5,a1,ffffffffc0200bf6 <memtree_init+0x136>
		size=size<<1;	
ffffffffc0200ac6:	0017979b          	slliw	a5,a5,0x1
    while(np>size)
ffffffffc0200aca:	feb7cee3          	blt	a5,a1,ffffffffc0200ac6 <memtree_init+0x6>
    tree_size=2*size-1;
ffffffffc0200ace:	0017971b          	slliw	a4,a5,0x1
ffffffffc0200ad2:	377d                	addiw	a4,a4,-1
ffffffffc0200ad4:	00006617          	auipc	a2,0x6
ffffffffc0200ad8:	96c60613          	addi	a2,a2,-1684 # ffffffffc0206440 <tree_size>
ffffffffc0200adc:	c218                	sw	a4,0(a2)
    __op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc0200ade:	fe050693          	addi	a3,a0,-32
ffffffffc0200ae2:	4709                	li	a4,2
ffffffffc0200ae4:	40e6b02f          	amoor.d	zero,a4,(a3)
    tree = (struct memtree*)(ROUNDUP((void*)pages + sizeof(struct Page) * (npage - nbase),32));
ffffffffc0200ae8:	00002717          	auipc	a4,0x2
ffffffffc0200aec:	b3073703          	ld	a4,-1232(a4) # ffffffffc0202618 <nbase>
ffffffffc0200af0:	00006697          	auipc	a3,0x6
ffffffffc0200af4:	9586b683          	ld	a3,-1704(a3) # ffffffffc0206448 <npage>
ffffffffc0200af8:	8e99                	sub	a3,a3,a4
ffffffffc0200afa:	00269713          	slli	a4,a3,0x2
ffffffffc0200afe:	9736                	add	a4,a4,a3
ffffffffc0200b00:	00371693          	slli	a3,a4,0x3
ffffffffc0200b04:	00006717          	auipc	a4,0x6
ffffffffc0200b08:	94c73703          	ld	a4,-1716(a4) # ffffffffc0206450 <pages>
ffffffffc0200b0c:	9736                	add	a4,a4,a3
ffffffffc0200b0e:	077d                	addi	a4,a4,31
ffffffffc0200b10:	00006697          	auipc	a3,0x6
ffffffffc0200b14:	92868693          	addi	a3,a3,-1752 # ffffffffc0206438 <tree>
ffffffffc0200b18:	9b01                	andi	a4,a4,-32
ffffffffc0200b1a:	e298                	sd	a4,0(a3)
ffffffffc0200b1c:	fe050813          	addi	a6,a0,-32
ffffffffc0200b20:	4705                	li	a4,1
ffffffffc0200b22:	40e8302f          	amoor.d	zero,a4,(a6)
    tree[0].page=NULL;
ffffffffc0200b26:	0006bf83          	ld	t6,0(a3)
    for(int i=tree_size - 1;i>=0;i--)
ffffffffc0200b2a:	00062e03          	lw	t3,0(a2)
    tree[0].page=NULL;
ffffffffc0200b2e:	000fb423          	sd	zero,8(t6)
    for(int i=tree_size - 1;i>=0;i--)
ffffffffc0200b32:	fffe069b          	addiw	a3,t3,-1
ffffffffc0200b36:	0a06c463          	bltz	a3,ffffffffc0200bde <memtree_init+0x11e>
    int block_size=(tree_size+1)/2;
ffffffffc0200b3a:	001e031b          	addiw	t1,t3,1
ffffffffc0200b3e:	004e1893          	slli	a7,t3,0x4
            tree[i].avail=(i-size+1<np)?1:0;
ffffffffc0200b42:	4285                	li	t0,1
    int block_size=(tree_size+1)/2;
ffffffffc0200b44:	4013531b          	sraiw	t1,t1,0x1
        if(i>=size-1)
ffffffffc0200b48:	fff78f1b          	addiw	t5,a5,-1
ffffffffc0200b4c:	98fe                	add	a7,a7,t6
            tree[i].avail=(i-size+1<np)?1:0;
ffffffffc0200b4e:	40f282bb          	subw	t0,t0,a5
    for(int i=tree_size - 1;i>=0;i--)
ffffffffc0200b52:	5efd                	li	t4,-1
    if(pos>=tree_size)return NULL;
ffffffffc0200b54:	09c6d163          	bge	a3,t3,ffffffffc0200bd6 <memtree_init+0x116>
    while(pos >=floorpw*2 + 1)
ffffffffc0200b58:	08d05463          	blez	a3,ffffffffc0200be0 <memtree_init+0x120>
    int block_size=(tree_size+1)/2;
ffffffffc0200b5c:	861a                	mv	a2,t1
    while(pos >=floorpw*2 + 1)
ffffffffc0200b5e:	4701                	li	a4,0
        floorpw+=1;
ffffffffc0200b60:	0017079b          	addiw	a5,a4,1
    while(pos >=floorpw*2 + 1)
ffffffffc0200b64:	0017971b          	slliw	a4,a5,0x1
        block_size/=2;
ffffffffc0200b68:	8605                	srai	a2,a2,0x1
    while(pos >=floorpw*2 + 1)
ffffffffc0200b6a:	fed74be3          	blt	a4,a3,ffffffffc0200b60 <memtree_init+0xa0>
    (struct Page*)(base + (pos-floorpw) * block_size);
ffffffffc0200b6e:	40f687bb          	subw	a5,a3,a5
ffffffffc0200b72:	02c787bb          	mulw	a5,a5,a2
        tree[i].page=memmap(base,i);
ffffffffc0200b76:	4701                	li	a4,0
ffffffffc0200b78:	861a                	mv	a2,t1
    (struct Page*)(base + (pos-floorpw) * block_size);
ffffffffc0200b7a:	00279813          	slli	a6,a5,0x2
ffffffffc0200b7e:	97c2                	add	a5,a5,a6
ffffffffc0200b80:	078e                	slli	a5,a5,0x3
    return (struct Page*)(base + (pos-floorpw) * block_size);
ffffffffc0200b82:	97aa                	add	a5,a5,a0
        tree[i].page=memmap(base,i);
ffffffffc0200b84:	fef8bc23          	sd	a5,-8(a7)
        floorpw+=1;
ffffffffc0200b88:	2705                	addiw	a4,a4,1
    while(pos >=floorpw*2 + 1)
ffffffffc0200b8a:	0017171b          	slliw	a4,a4,0x1
        block_size/=2;
ffffffffc0200b8e:	8605                	srai	a2,a2,0x1
    while(pos >=floorpw*2 + 1)
ffffffffc0200b90:	fed74ce3          	blt	a4,a3,ffffffffc0200b88 <memtree_init+0xc8>
        tree[i].size=getps(i);
ffffffffc0200b94:	fec8aa23          	sw	a2,-12(a7)
        if(i>=size-1)
ffffffffc0200b98:	01e6cd63          	blt	a3,t5,ffffffffc0200bb2 <memtree_init+0xf2>
            tree[i].avail=(i-size+1<np)?1:0;
ffffffffc0200b9c:	00d287bb          	addw	a5,t0,a3
ffffffffc0200ba0:	00b7a7b3          	slt	a5,a5,a1
ffffffffc0200ba4:	fef8a823          	sw	a5,-16(a7)
    for(int i=tree_size - 1;i>=0;i--)
ffffffffc0200ba8:	36fd                	addiw	a3,a3,-1
ffffffffc0200baa:	18c1                	addi	a7,a7,-16
ffffffffc0200bac:	fbd694e3          	bne	a3,t4,ffffffffc0200b54 <memtree_init+0x94>
ffffffffc0200bb0:	8082                	ret
            if(tree[i*2+1].avail+tree[i*2+2].avail==tree[i].size)
ffffffffc0200bb2:	0016979b          	slliw	a5,a3,0x1
ffffffffc0200bb6:	0785                	addi	a5,a5,1
ffffffffc0200bb8:	0792                	slli	a5,a5,0x4
ffffffffc0200bba:	97fe                	add	a5,a5,t6
ffffffffc0200bbc:	4398                	lw	a4,0(a5)
ffffffffc0200bbe:	4b9c                	lw	a5,16(a5)
ffffffffc0200bc0:	00f7083b          	addw	a6,a4,a5
ffffffffc0200bc4:	00c80663          	beq	a6,a2,ffffffffc0200bd0 <memtree_init+0x110>
                tree[i].avail=(tree[i*2+1].avail>tree[i*2+2].avail) ?  tree[i*2+1].avail: tree[i*2+2].avail;
ffffffffc0200bc8:	863a                	mv	a2,a4
ffffffffc0200bca:	00f75363          	bge	a4,a5,ffffffffc0200bd0 <memtree_init+0x110>
ffffffffc0200bce:	863e                	mv	a2,a5
ffffffffc0200bd0:	fec8a823          	sw	a2,-16(a7)
ffffffffc0200bd4:	bfd1                	j	ffffffffc0200ba8 <memtree_init+0xe8>
        tree[i].page=memmap(base,i);
ffffffffc0200bd6:	fe08bc23          	sd	zero,-8(a7)
    if(pos>=tree_size)return 0;
ffffffffc0200bda:	4601                	li	a2,0
ffffffffc0200bdc:	bf65                	j	ffffffffc0200b94 <memtree_init+0xd4>
}
ffffffffc0200bde:	8082                	ret
    (struct Page*)(base + (pos-floorpw) * block_size);
ffffffffc0200be0:	02d3073b          	mulw	a4,t1,a3
    int block_size=(tree_size+1)/2;
ffffffffc0200be4:	861a                	mv	a2,t1
    (struct Page*)(base + (pos-floorpw) * block_size);
ffffffffc0200be6:	00271793          	slli	a5,a4,0x2
ffffffffc0200bea:	97ba                	add	a5,a5,a4
ffffffffc0200bec:	078e                	slli	a5,a5,0x3
    return (struct Page*)(base + (pos-floorpw) * block_size);
ffffffffc0200bee:	97aa                	add	a5,a5,a0
        tree[i].page=memmap(base,i);
ffffffffc0200bf0:	fef8bc23          	sd	a5,-8(a7)
    while(pos >=floorpw*2 + 1)
ffffffffc0200bf4:	b745                	j	ffffffffc0200b94 <memtree_init+0xd4>
    while(np>size)
ffffffffc0200bf6:	4705                	li	a4,1
    int size=1;
ffffffffc0200bf8:	4785                	li	a5,1
ffffffffc0200bfa:	bde9                	j	ffffffffc0200ad4 <memtree_init+0x14>

ffffffffc0200bfc <buddy_system_init_memmap>:
buddy_system_init_memmap(struct Page *base, size_t n) {
ffffffffc0200bfc:	1101                	addi	sp,sp,-32
ffffffffc0200bfe:	ec06                	sd	ra,24(sp)
ffffffffc0200c00:	e822                	sd	s0,16(sp)
ffffffffc0200c02:	e426                	sd	s1,8(sp)
    assert(n > 0);
ffffffffc0200c04:	c1e5                	beqz	a1,ffffffffc0200ce4 <buddy_system_init_memmap+0xe8>
    for (; p != base + n; p ++) {
ffffffffc0200c06:	00259693          	slli	a3,a1,0x2
ffffffffc0200c0a:	96ae                	add	a3,a3,a1
ffffffffc0200c0c:	068e                	slli	a3,a3,0x3
ffffffffc0200c0e:	96aa                	add	a3,a3,a0
ffffffffc0200c10:	842a                	mv	s0,a0
ffffffffc0200c12:	87aa                	mv	a5,a0
ffffffffc0200c14:	00d50f63          	beq	a0,a3,ffffffffc0200c32 <buddy_system_init_memmap+0x36>
    return (((*(volatile unsigned long *)addr) >> nr) & 1);
ffffffffc0200c18:	6798                	ld	a4,8(a5)
        assert(PageReserved(p));
ffffffffc0200c1a:	8b05                	andi	a4,a4,1
ffffffffc0200c1c:	c745                	beqz	a4,ffffffffc0200cc4 <buddy_system_init_memmap+0xc8>
        p->flags = p->property = 0;
ffffffffc0200c1e:	0007a823          	sw	zero,16(a5)
ffffffffc0200c22:	0007b423          	sd	zero,8(a5)



static inline int page_ref(struct Page *page) { return page->ref; }

static inline void set_page_ref(struct Page *page, int val) { page->ref = val; }
ffffffffc0200c26:	0007a023          	sw	zero,0(a5)
    for (; p != base + n; p ++) {
ffffffffc0200c2a:	02878793          	addi	a5,a5,40
ffffffffc0200c2e:	fed795e3          	bne	a5,a3,ffffffffc0200c18 <buddy_system_init_memmap+0x1c>
    base->property = n;
ffffffffc0200c32:	2581                	sext.w	a1,a1
ffffffffc0200c34:	c80c                	sw	a1,16(s0)
    __op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc0200c36:	4789                	li	a5,2
ffffffffc0200c38:	00840713          	addi	a4,s0,8
ffffffffc0200c3c:	40f7302f          	amoor.d	zero,a5,(a4)
    nr_free += n;
ffffffffc0200c40:	00005497          	auipc	s1,0x5
ffffffffc0200c44:	3d048493          	addi	s1,s1,976 # ffffffffc0206010 <bsfree_area>
ffffffffc0200c48:	489c                	lw	a5,16(s1)
    memtree_init(base,n);
ffffffffc0200c4a:	8522                	mv	a0,s0
    nr_free += n;
ffffffffc0200c4c:	9fad                	addw	a5,a5,a1
ffffffffc0200c4e:	c89c                	sw	a5,16(s1)
    memtree_init(base,n);
ffffffffc0200c50:	e71ff0ef          	jal	ra,ffffffffc0200ac0 <memtree_init>
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
ffffffffc0200c54:	649c                	ld	a5,8(s1)
        list_add(&free_list, &(base->page_link));
ffffffffc0200c56:	01840693          	addi	a3,s0,24
    if (list_empty(&free_list)) {
ffffffffc0200c5a:	04978c63          	beq	a5,s1,ffffffffc0200cb2 <buddy_system_init_memmap+0xb6>
            struct Page* page = le2page(le, page_link);
ffffffffc0200c5e:	fe878713          	addi	a4,a5,-24
ffffffffc0200c62:	608c                	ld	a1,0(s1)
    if (list_empty(&free_list)) {
ffffffffc0200c64:	4601                	li	a2,0
            if (base < page) {
ffffffffc0200c66:	00e46a63          	bltu	s0,a4,ffffffffc0200c7a <buddy_system_init_memmap+0x7e>
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
ffffffffc0200c6a:	6798                	ld	a4,8(a5)
            } else if (list_next(le) == &free_list) {
ffffffffc0200c6c:	02970363          	beq	a4,s1,ffffffffc0200c92 <buddy_system_init_memmap+0x96>
    for (; p != base + n; p ++) {
ffffffffc0200c70:	87ba                	mv	a5,a4
            struct Page* page = le2page(le, page_link);
ffffffffc0200c72:	fe878713          	addi	a4,a5,-24
            if (base < page) {
ffffffffc0200c76:	fee47ae3          	bgeu	s0,a4,ffffffffc0200c6a <buddy_system_init_memmap+0x6e>
ffffffffc0200c7a:	c211                	beqz	a2,ffffffffc0200c7e <buddy_system_init_memmap+0x82>
ffffffffc0200c7c:	e08c                	sd	a1,0(s1)
    __list_add(elm, listelm->prev, listelm);
ffffffffc0200c7e:	6398                	ld	a4,0(a5)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
ffffffffc0200c80:	e394                	sd	a3,0(a5)
}
ffffffffc0200c82:	60e2                	ld	ra,24(sp)
ffffffffc0200c84:	e714                	sd	a3,8(a4)
    elm->next = next;
ffffffffc0200c86:	f01c                	sd	a5,32(s0)
    elm->prev = prev;
ffffffffc0200c88:	ec18                	sd	a4,24(s0)
ffffffffc0200c8a:	6442                	ld	s0,16(sp)
ffffffffc0200c8c:	64a2                	ld	s1,8(sp)
ffffffffc0200c8e:	6105                	addi	sp,sp,32
ffffffffc0200c90:	8082                	ret
    prev->next = next->prev = elm;
ffffffffc0200c92:	e794                	sd	a3,8(a5)
    elm->next = next;
ffffffffc0200c94:	f004                	sd	s1,32(s0)
    return listelm->next;
ffffffffc0200c96:	6798                	ld	a4,8(a5)
    elm->prev = prev;
ffffffffc0200c98:	ec1c                	sd	a5,24(s0)
        while ((le = list_next(le)) != &free_list) {
ffffffffc0200c9a:	00970663          	beq	a4,s1,ffffffffc0200ca6 <buddy_system_init_memmap+0xaa>
    prev->next = next->prev = elm;
ffffffffc0200c9e:	85b6                	mv	a1,a3
ffffffffc0200ca0:	4605                	li	a2,1
    for (; p != base + n; p ++) {
ffffffffc0200ca2:	87ba                	mv	a5,a4
ffffffffc0200ca4:	b7f9                	j	ffffffffc0200c72 <buddy_system_init_memmap+0x76>
}
ffffffffc0200ca6:	60e2                	ld	ra,24(sp)
ffffffffc0200ca8:	6442                	ld	s0,16(sp)
ffffffffc0200caa:	e094                	sd	a3,0(s1)
ffffffffc0200cac:	64a2                	ld	s1,8(sp)
ffffffffc0200cae:	6105                	addi	sp,sp,32
ffffffffc0200cb0:	8082                	ret
ffffffffc0200cb2:	60e2                	ld	ra,24(sp)
    elm->next = next;
ffffffffc0200cb4:	f01c                	sd	a5,32(s0)
    elm->prev = prev;
ffffffffc0200cb6:	ec1c                	sd	a5,24(s0)
ffffffffc0200cb8:	6442                	ld	s0,16(sp)
    prev->next = next->prev = elm;
ffffffffc0200cba:	e394                	sd	a3,0(a5)
ffffffffc0200cbc:	e794                	sd	a3,8(a5)
ffffffffc0200cbe:	64a2                	ld	s1,8(sp)
ffffffffc0200cc0:	6105                	addi	sp,sp,32
ffffffffc0200cc2:	8082                	ret
        assert(PageReserved(p));
ffffffffc0200cc4:	00001697          	auipc	a3,0x1
ffffffffc0200cc8:	4bc68693          	addi	a3,a3,1212 # ffffffffc0202180 <commands+0x678>
ffffffffc0200ccc:	00001617          	auipc	a2,0x1
ffffffffc0200cd0:	33c60613          	addi	a2,a2,828 # ffffffffc0202008 <commands+0x500>
ffffffffc0200cd4:	0f700593          	li	a1,247
ffffffffc0200cd8:	00001517          	auipc	a0,0x1
ffffffffc0200cdc:	34850513          	addi	a0,a0,840 # ffffffffc0202020 <commands+0x518>
ffffffffc0200ce0:	c5aff0ef          	jal	ra,ffffffffc020013a <__panic>
    assert(n > 0);
ffffffffc0200ce4:	00001697          	auipc	a3,0x1
ffffffffc0200ce8:	49468693          	addi	a3,a3,1172 # ffffffffc0202178 <commands+0x670>
ffffffffc0200cec:	00001617          	auipc	a2,0x1
ffffffffc0200cf0:	31c60613          	addi	a2,a2,796 # ffffffffc0202008 <commands+0x500>
ffffffffc0200cf4:	0f400593          	li	a1,244
ffffffffc0200cf8:	00001517          	auipc	a0,0x1
ffffffffc0200cfc:	32850513          	addi	a0,a0,808 # ffffffffc0202020 <commands+0x518>
ffffffffc0200d00:	c3aff0ef          	jal	ra,ffffffffc020013a <__panic>

ffffffffc0200d04 <get_mem>:
    while(tree[find_pos].avail>=n)
ffffffffc0200d04:	00005e17          	auipc	t3,0x5
ffffffffc0200d08:	734e0e13          	addi	t3,t3,1844 # ffffffffc0206438 <tree>
ffffffffc0200d0c:	000e3603          	ld	a2,0(t3)
{
ffffffffc0200d10:	832a                	mv	t1,a0
    int find_pos=0;
ffffffffc0200d12:	4781                	li	a5,0
    while(tree[find_pos].avail>=n)
ffffffffc0200d14:	420c                	lw	a1,0(a2)
ffffffffc0200d16:	8532                	mv	a0,a2
ffffffffc0200d18:	4881                	li	a7,0
ffffffffc0200d1a:	4e89                	li	t4,2
ffffffffc0200d1c:	1065c463          	blt	a1,t1,ffffffffc0200e24 <get_mem+0x120>
        if(tree[find_pos].avail==tree[find_pos].size && tree[find_pos].avail>n)
ffffffffc0200d20:	00452803          	lw	a6,4(a0)
            (tree[find_pos*2+1].page)->property=tree[find_pos*2+1].avail;
ffffffffc0200d24:	0017971b          	slliw	a4,a5,0x1
ffffffffc0200d28:	00170693          	addi	a3,a4,1
ffffffffc0200d2c:	853a                	mv	a0,a4
ffffffffc0200d2e:	0692                	slli	a3,a3,0x4
        if(tree[find_pos].avail==tree[find_pos].size && tree[find_pos].avail>n)
ffffffffc0200d30:	08b80b63          	beq	a6,a1,ffffffffc0200dc6 <get_mem+0xc2>
        if(tree[find_pos*2+1].avail>=n)
ffffffffc0200d34:	000e3603          	ld	a2,0(t3)
ffffffffc0200d38:	96b2                	add	a3,a3,a2
ffffffffc0200d3a:	4294                	lw	a3,0(a3)
        if(tree[find_pos*2+2].avail>=n)
ffffffffc0200d3c:	0709                	addi	a4,a4,2
ffffffffc0200d3e:	0712                	slli	a4,a4,0x4
ffffffffc0200d40:	9732                	add	a4,a4,a2
        if(tree[find_pos*2+1].avail>=n)
ffffffffc0200d42:	0266dc63          	bge	a3,t1,ffffffffc0200d7a <get_mem+0x76>
        if(tree[find_pos*2+2].avail>=n)
ffffffffc0200d46:	4318                	lw	a4,0(a4)
ffffffffc0200d48:	0c675b63          	bge	a4,t1,ffffffffc0200e1e <get_mem+0x11a>
    if(find_pos==0&&tree[find_pos].avail<n)
ffffffffc0200d4c:	01160533          	add	a0,a2,a7
ffffffffc0200d50:	ef95                	bnez	a5,ffffffffc0200d8c <get_mem+0x88>
ffffffffc0200d52:	411c                	lw	a5,0(a0)
ffffffffc0200d54:	0c67c863          	blt	a5,t1,ffffffffc0200e24 <get_mem+0x120>
    tree[find_pos].avail=0;
ffffffffc0200d58:	00052023          	sw	zero,0(a0)
    list_del(&(tree[find_pos].page->page_link));
ffffffffc0200d5c:	6508                	ld	a0,8(a0)
    nr_free -= n;
ffffffffc0200d5e:	00005717          	auipc	a4,0x5
ffffffffc0200d62:	2b270713          	addi	a4,a4,690 # ffffffffc0206010 <bsfree_area>
ffffffffc0200d66:	4b1c                	lw	a5,16(a4)
    __list_del(listelm->prev, listelm->next);
ffffffffc0200d68:	6d10                	ld	a2,24(a0)
ffffffffc0200d6a:	7114                	ld	a3,32(a0)
ffffffffc0200d6c:	4067833b          	subw	t1,a5,t1
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
ffffffffc0200d70:	e614                	sd	a3,8(a2)
    next->prev = prev;
ffffffffc0200d72:	e290                	sd	a2,0(a3)
ffffffffc0200d74:	00672823          	sw	t1,16(a4)
}
ffffffffc0200d78:	8082                	ret
            find_pos=find_pos*2+1;
ffffffffc0200d7a:	0015079b          	addiw	a5,a0,1
    while(tree[find_pos].avail>=n)
ffffffffc0200d7e:	00479893          	slli	a7,a5,0x4
ffffffffc0200d82:	01160533          	add	a0,a2,a7
ffffffffc0200d86:	410c                	lw	a1,0(a0)
ffffffffc0200d88:	f865dce3          	bge	a1,t1,ffffffffc0200d20 <get_mem+0x1c>
    tree[find_pos].avail=0;
ffffffffc0200d8c:	00052023          	sw	zero,0(a0)
        int dpos=(pos-1)/2;
ffffffffc0200d90:	37fd                	addiw	a5,a5,-1
ffffffffc0200d92:	4017d79b          	sraiw	a5,a5,0x1
        tree[dpos].avail=tree[dpos*2+1].avail>tree[dpos*2+2].avail ? tree[dpos*2+1].avail:tree[dpos*2+2].avail;
ffffffffc0200d96:	0017969b          	slliw	a3,a5,0x1
ffffffffc0200d9a:	8736                	mv	a4,a3
ffffffffc0200d9c:	2705                	addiw	a4,a4,1
ffffffffc0200d9e:	0689                	addi	a3,a3,2
ffffffffc0200da0:	0692                	slli	a3,a3,0x4
ffffffffc0200da2:	0712                	slli	a4,a4,0x4
ffffffffc0200da4:	9732                	add	a4,a4,a2
ffffffffc0200da6:	96b2                	add	a3,a3,a2
ffffffffc0200da8:	430c                	lw	a1,0(a4)
ffffffffc0200daa:	4294                	lw	a3,0(a3)
ffffffffc0200dac:	00479713          	slli	a4,a5,0x4
ffffffffc0200db0:	0005881b          	sext.w	a6,a1
ffffffffc0200db4:	0006889b          	sext.w	a7,a3
ffffffffc0200db8:	9732                	add	a4,a4,a2
ffffffffc0200dba:	0108d363          	bge	a7,a6,ffffffffc0200dc0 <get_mem+0xbc>
ffffffffc0200dbe:	86ae                	mv	a3,a1
ffffffffc0200dc0:	c314                	sw	a3,0(a4)
    while(pos>0)
ffffffffc0200dc2:	f7f9                	bnez	a5,ffffffffc0200d90 <get_mem+0x8c>
ffffffffc0200dc4:	bf61                	j	ffffffffc0200d5c <get_mem+0x58>
            (tree[find_pos*2+2].page)->property=tree[find_pos*2+2].avail;
ffffffffc0200dc6:	00270813          	addi	a6,a4,2
ffffffffc0200dca:	0812                	slli	a6,a6,0x4
            (tree[find_pos*2+1].page)->property=tree[find_pos*2+1].avail;
ffffffffc0200dcc:	00d60f33          	add	t5,a2,a3
            (tree[find_pos*2+2].page)->property=tree[find_pos*2+2].avail;
ffffffffc0200dd0:	9642                	add	a2,a2,a6
        if(tree[find_pos].avail==tree[find_pos].size && tree[find_pos].avail>n)
ffffffffc0200dd2:	f6b351e3          	bge	t1,a1,ffffffffc0200d34 <get_mem+0x30>
            (tree[find_pos*2+1].page)->property=tree[find_pos*2+1].avail;
ffffffffc0200dd6:	008f3f83          	ld	t6,8(t5)
ffffffffc0200dda:	000f2f03          	lw	t5,0(t5)
            (tree[find_pos*2+2].page)->property=tree[find_pos*2+2].avail;
ffffffffc0200dde:	660c                	ld	a1,8(a2)
ffffffffc0200de0:	4210                	lw	a2,0(a2)
            (tree[find_pos*2+1].page)->property=tree[find_pos*2+1].avail;
ffffffffc0200de2:	01efa823          	sw	t5,16(t6)
            (tree[find_pos*2+2].page)->property=tree[find_pos*2+2].avail;
ffffffffc0200de6:	c990                	sw	a2,16(a1)
ffffffffc0200de8:	00858613          	addi	a2,a1,8
ffffffffc0200dec:	41d6302f          	amoor.d	zero,t4,(a2)
            list_add(&(tree[find_pos*2+1].page->page_link), &((tree[find_pos*2+2].page)->page_link));
ffffffffc0200df0:	000e3603          	ld	a2,0(t3)
ffffffffc0200df4:	96b2                	add	a3,a3,a2
ffffffffc0200df6:	0086bf03          	ld	t5,8(a3)
ffffffffc0200dfa:	9832                	add	a6,a6,a2
ffffffffc0200dfc:	00883583          	ld	a1,8(a6)
    __list_add(elm, listelm, listelm->next);
ffffffffc0200e00:	020f3803          	ld	a6,32(t5)
ffffffffc0200e04:	018f0293          	addi	t0,t5,24
ffffffffc0200e08:	01858f93          	addi	t6,a1,24
    prev->next = next->prev = elm;
ffffffffc0200e0c:	01f83023          	sd	t6,0(a6)
ffffffffc0200e10:	03ff3023          	sd	t6,32(t5)
    elm->next = next;
ffffffffc0200e14:	0305b023          	sd	a6,32(a1)
    elm->prev = prev;
ffffffffc0200e18:	0055bc23          	sd	t0,24(a1)
}
ffffffffc0200e1c:	bf39                	j	ffffffffc0200d3a <get_mem+0x36>
            find_pos=find_pos*2+2;
ffffffffc0200e1e:	0025079b          	addiw	a5,a0,2
            continue;
ffffffffc0200e22:	bfb1                	j	ffffffffc0200d7e <get_mem+0x7a>
        return NULL;
ffffffffc0200e24:	4501                	li	a0,0
ffffffffc0200e26:	8082                	ret

ffffffffc0200e28 <buddy_system_alloc_pages>:
buddy_system_alloc_pages(size_t n) {
ffffffffc0200e28:	1141                	addi	sp,sp,-16
ffffffffc0200e2a:	e406                	sd	ra,8(sp)
    assert(n > 0);
ffffffffc0200e2c:	cd1d                	beqz	a0,ffffffffc0200e6a <buddy_system_alloc_pages+0x42>
    if (n > nr_free) {
ffffffffc0200e2e:	00005717          	auipc	a4,0x5
ffffffffc0200e32:	1f276703          	lwu	a4,498(a4) # ffffffffc0206020 <bsfree_area+0x10>
ffffffffc0200e36:	87aa                	mv	a5,a0
ffffffffc0200e38:	02a76563          	bltu	a4,a0,ffffffffc0200e62 <buddy_system_alloc_pages+0x3a>
    while(n>size)
ffffffffc0200e3c:	4705                	li	a4,1
    int size=1;
ffffffffc0200e3e:	4505                	li	a0,1
    while(n>size)
ffffffffc0200e40:	00e78663          	beq	a5,a4,ffffffffc0200e4c <buddy_system_alloc_pages+0x24>
		size=size<<1;	
ffffffffc0200e44:	0015151b          	slliw	a0,a0,0x1
    while(n>size)
ffffffffc0200e48:	fef56ee3          	bltu	a0,a5,ffffffffc0200e44 <buddy_system_alloc_pages+0x1c>
    page=get_mem(size);
ffffffffc0200e4c:	eb9ff0ef          	jal	ra,ffffffffc0200d04 <get_mem>
    if (page != NULL) {
ffffffffc0200e50:	c511                	beqz	a0,ffffffffc0200e5c <buddy_system_alloc_pages+0x34>
    __op_bit(and, __NOT, nr, ((volatile unsigned long *)addr));
ffffffffc0200e52:	57f5                	li	a5,-3
ffffffffc0200e54:	00850713          	addi	a4,a0,8
ffffffffc0200e58:	60f7302f          	amoand.d	zero,a5,(a4)
}
ffffffffc0200e5c:	60a2                	ld	ra,8(sp)
ffffffffc0200e5e:	0141                	addi	sp,sp,16
ffffffffc0200e60:	8082                	ret
ffffffffc0200e62:	60a2                	ld	ra,8(sp)
        return NULL;
ffffffffc0200e64:	4501                	li	a0,0
}
ffffffffc0200e66:	0141                	addi	sp,sp,16
ffffffffc0200e68:	8082                	ret
    assert(n > 0);
ffffffffc0200e6a:	00001697          	auipc	a3,0x1
ffffffffc0200e6e:	30e68693          	addi	a3,a3,782 # ffffffffc0202178 <commands+0x670>
ffffffffc0200e72:	00001617          	auipc	a2,0x1
ffffffffc0200e76:	19660613          	addi	a2,a2,406 # ffffffffc0202008 <commands+0x500>
ffffffffc0200e7a:	11600593          	li	a1,278
ffffffffc0200e7e:	00001517          	auipc	a0,0x1
ffffffffc0200e82:	1a250513          	addi	a0,a0,418 # ffffffffc0202020 <commands+0x518>
ffffffffc0200e86:	ab4ff0ef          	jal	ra,ffffffffc020013a <__panic>

ffffffffc0200e8a <free_mem>:
    int ea= page-tree[0].page;
ffffffffc0200e8a:	00005e97          	auipc	t4,0x5
ffffffffc0200e8e:	5aee8e93          	addi	t4,t4,1454 # ffffffffc0206438 <tree>
ffffffffc0200e92:	000eb803          	ld	a6,0(t4)
    int pos=ea+(tree_size-1)/2;
ffffffffc0200e96:	00005797          	auipc	a5,0x5
ffffffffc0200e9a:	5aa7a783          	lw	a5,1450(a5) # ffffffffc0206440 <tree_size>
ffffffffc0200e9e:	fff7869b          	addiw	a3,a5,-1
    int ea= page-tree[0].page;
ffffffffc0200ea2:	00883703          	ld	a4,8(a6)
ffffffffc0200ea6:	40e507b3          	sub	a5,a0,a4
ffffffffc0200eaa:	878d                	srai	a5,a5,0x3
ffffffffc0200eac:	00001717          	auipc	a4,0x1
ffffffffc0200eb0:	76473703          	ld	a4,1892(a4) # ffffffffc0202610 <error_string+0x38>
ffffffffc0200eb4:	02e78733          	mul	a4,a5,a4
    int pos=ea+(tree_size-1)/2;
ffffffffc0200eb8:	01f6d79b          	srliw	a5,a3,0x1f
ffffffffc0200ebc:	9fb5                	addw	a5,a5,a3
ffffffffc0200ebe:	4017d79b          	sraiw	a5,a5,0x1
ffffffffc0200ec2:	9fb9                	addw	a5,a5,a4
    while(pos>0)
ffffffffc0200ec4:	00f04763          	bgtz	a5,ffffffffc0200ed2 <free_mem+0x48>
ffffffffc0200ec8:	a05d                	j	ffffffffc0200f6e <free_mem+0xe4>
        pos=(pos-1)/2;
ffffffffc0200eca:	37fd                	addiw	a5,a5,-1
ffffffffc0200ecc:	4017d79b          	sraiw	a5,a5,0x1
    while(pos>0)
ffffffffc0200ed0:	cfd9                	beqz	a5,ffffffffc0200f6e <free_mem+0xe4>
        if (tree[pos].size>=n)break;
ffffffffc0200ed2:	00479713          	slli	a4,a5,0x4
ffffffffc0200ed6:	9742                	add	a4,a4,a6
ffffffffc0200ed8:	4354                	lw	a3,4(a4)
ffffffffc0200eda:	feb6e8e3          	bltu	a3,a1,ffffffffc0200eca <free_mem+0x40>
{
ffffffffc0200ede:	1141                	addi	sp,sp,-16
ffffffffc0200ee0:	e406                	sd	ra,8(sp)
    tree[pos].avail=tree[pos].size;
ffffffffc0200ee2:	c314                	sw	a3,0(a4)
ffffffffc0200ee4:	5f75                	li	t5,-3
        int dpos=(pos-1)/2;
ffffffffc0200ee6:	37fd                	addiw	a5,a5,-1
ffffffffc0200ee8:	4017d79b          	sraiw	a5,a5,0x1
        if(tree[dpos*2+1].avail+tree[dpos*2+2].avail==tree[dpos].size)//遇到可以合并的就合并
ffffffffc0200eec:	0017969b          	slliw	a3,a5,0x1
ffffffffc0200ef0:	0016871b          	addiw	a4,a3,1
ffffffffc0200ef4:	0689                	addi	a3,a3,2
ffffffffc0200ef6:	0712                	slli	a4,a4,0x4
ffffffffc0200ef8:	0692                	slli	a3,a3,0x4
ffffffffc0200efa:	9742                	add	a4,a4,a6
ffffffffc0200efc:	00d808b3          	add	a7,a6,a3
ffffffffc0200f00:	00479613          	slli	a2,a5,0x4
ffffffffc0200f04:	430c                	lw	a1,0(a4)
ffffffffc0200f06:	0008a503          	lw	a0,0(a7)
ffffffffc0200f0a:	9642                	add	a2,a2,a6
ffffffffc0200f0c:	00462303          	lw	t1,4(a2)
ffffffffc0200f10:	00a58e3b          	addw	t3,a1,a0
ffffffffc0200f14:	006e0b63          	beq	t3,t1,ffffffffc0200f2a <free_mem+0xa0>
            tree[dpos].avail=tree[dpos*2+1].avail>tree[dpos*2+2].avail ? tree[dpos*2+1].avail:tree[dpos*2+2].avail;
ffffffffc0200f18:	872e                	mv	a4,a1
ffffffffc0200f1a:	00a5d363          	bge	a1,a0,ffffffffc0200f20 <free_mem+0x96>
ffffffffc0200f1e:	872a                	mv	a4,a0
ffffffffc0200f20:	c218                	sw	a4,0(a2)
    while(pos>0)
ffffffffc0200f22:	c3b9                	beqz	a5,ffffffffc0200f68 <free_mem+0xde>
        if(tree[dpos*2+1].avail+tree[dpos*2+2].avail==tree[dpos].size)//遇到可以合并的就合并
ffffffffc0200f24:	000eb803          	ld	a6,0(t4)
ffffffffc0200f28:	bf7d                	j	ffffffffc0200ee6 <free_mem+0x5c>
            assert(tree[dpos*2+2].page->property==tree[dpos*2+2].size);
ffffffffc0200f2a:	0088b583          	ld	a1,8(a7)
ffffffffc0200f2e:	0048a503          	lw	a0,4(a7)
ffffffffc0200f32:	0105a883          	lw	a7,16(a1)
ffffffffc0200f36:	06a89163          	bne	a7,a0,ffffffffc0200f98 <free_mem+0x10e>
            assert(tree[dpos*2+1].page->property==tree[dpos*2+1].size);
ffffffffc0200f3a:	6708                	ld	a0,8(a4)
ffffffffc0200f3c:	4358                	lw	a4,4(a4)
ffffffffc0200f3e:	4908                	lw	a0,16(a0)
ffffffffc0200f40:	02e51c63          	bne	a0,a4,ffffffffc0200f78 <free_mem+0xee>
            tree[dpos].page->property=tree[dpos].size;
ffffffffc0200f44:	6618                	ld	a4,8(a2)
            tree[dpos].avail=tree[dpos].size;
ffffffffc0200f46:	01c62023          	sw	t3,0(a2)
            tree[dpos].page->property=tree[dpos].size;
ffffffffc0200f4a:	01c72823          	sw	t3,16(a4)
ffffffffc0200f4e:	00858713          	addi	a4,a1,8
ffffffffc0200f52:	61e7302f          	amoand.d	zero,t5,(a4)
            list_del(&(tree[dpos*2+2].page->page_link));
ffffffffc0200f56:	000eb703          	ld	a4,0(t4)
ffffffffc0200f5a:	96ba                	add	a3,a3,a4
ffffffffc0200f5c:	6698                	ld	a4,8(a3)
    __list_del(listelm->prev, listelm->next);
ffffffffc0200f5e:	6f14                	ld	a3,24(a4)
ffffffffc0200f60:	7318                	ld	a4,32(a4)
    prev->next = next;
ffffffffc0200f62:	e698                	sd	a4,8(a3)
    next->prev = prev;
ffffffffc0200f64:	e314                	sd	a3,0(a4)
    while(pos>0)
ffffffffc0200f66:	ffdd                	bnez	a5,ffffffffc0200f24 <free_mem+0x9a>
}
ffffffffc0200f68:	60a2                	ld	ra,8(sp)
ffffffffc0200f6a:	0141                	addi	sp,sp,16
ffffffffc0200f6c:	8082                	ret
    tree[pos].avail=tree[pos].size;
ffffffffc0200f6e:	0792                	slli	a5,a5,0x4
ffffffffc0200f70:	97c2                	add	a5,a5,a6
ffffffffc0200f72:	43d8                	lw	a4,4(a5)
ffffffffc0200f74:	c398                	sw	a4,0(a5)
    while(pos>0)
ffffffffc0200f76:	8082                	ret
            assert(tree[dpos*2+1].page->property==tree[dpos*2+1].size);
ffffffffc0200f78:	00001697          	auipc	a3,0x1
ffffffffc0200f7c:	25068693          	addi	a3,a3,592 # ffffffffc02021c8 <commands+0x6c0>
ffffffffc0200f80:	00001617          	auipc	a2,0x1
ffffffffc0200f84:	08860613          	addi	a2,a2,136 # ffffffffc0202008 <commands+0x500>
ffffffffc0200f88:	0da00593          	li	a1,218
ffffffffc0200f8c:	00001517          	auipc	a0,0x1
ffffffffc0200f90:	09450513          	addi	a0,a0,148 # ffffffffc0202020 <commands+0x518>
ffffffffc0200f94:	9a6ff0ef          	jal	ra,ffffffffc020013a <__panic>
            assert(tree[dpos*2+2].page->property==tree[dpos*2+2].size);
ffffffffc0200f98:	00001697          	auipc	a3,0x1
ffffffffc0200f9c:	1f868693          	addi	a3,a3,504 # ffffffffc0202190 <commands+0x688>
ffffffffc0200fa0:	00001617          	auipc	a2,0x1
ffffffffc0200fa4:	06860613          	addi	a2,a2,104 # ffffffffc0202008 <commands+0x500>
ffffffffc0200fa8:	0d900593          	li	a1,217
ffffffffc0200fac:	00001517          	auipc	a0,0x1
ffffffffc0200fb0:	07450513          	addi	a0,a0,116 # ffffffffc0202020 <commands+0x518>
ffffffffc0200fb4:	986ff0ef          	jal	ra,ffffffffc020013a <__panic>

ffffffffc0200fb8 <buddy_system_free_pages>:
buddy_system_free_pages(struct Page *base, size_t n) {
ffffffffc0200fb8:	1141                	addi	sp,sp,-16
ffffffffc0200fba:	e406                	sd	ra,8(sp)
    assert(n > 0);
ffffffffc0200fbc:	0e058c63          	beqz	a1,ffffffffc02010b4 <buddy_system_free_pages+0xfc>
ffffffffc0200fc0:	87ae                	mv	a5,a1
    int size=1;
ffffffffc0200fc2:	4685                	li	a3,1
    while(n>size)
ffffffffc0200fc4:	4585                	li	a1,1
ffffffffc0200fc6:	02850613          	addi	a2,a0,40
ffffffffc0200fca:	00d78e63          	beq	a5,a3,ffffffffc0200fe6 <buddy_system_free_pages+0x2e>
		size=size<<1;	
ffffffffc0200fce:	0016969b          	slliw	a3,a3,0x1
    while(n>size)
ffffffffc0200fd2:	85b6                	mv	a1,a3
ffffffffc0200fd4:	fef6ede3          	bltu	a3,a5,ffffffffc0200fce <buddy_system_free_pages+0x16>
    for (; p != base + size; p ++) {
ffffffffc0200fd8:	00269613          	slli	a2,a3,0x2
ffffffffc0200fdc:	9636                	add	a2,a2,a3
ffffffffc0200fde:	060e                	slli	a2,a2,0x3
ffffffffc0200fe0:	962a                	add	a2,a2,a0
ffffffffc0200fe2:	02c50163          	beq	a0,a2,ffffffffc0201004 <buddy_system_free_pages+0x4c>
ffffffffc0200fe6:	87aa                	mv	a5,a0
    return (((*(volatile unsigned long *)addr) >> nr) & 1);
ffffffffc0200fe8:	6798                	ld	a4,8(a5)
        assert(!PageReserved(p) && !PageProperty(p));
ffffffffc0200fea:	8b05                	andi	a4,a4,1
ffffffffc0200fec:	e745                	bnez	a4,ffffffffc0201094 <buddy_system_free_pages+0xdc>
ffffffffc0200fee:	6798                	ld	a4,8(a5)
ffffffffc0200ff0:	8b09                	andi	a4,a4,2
ffffffffc0200ff2:	e34d                	bnez	a4,ffffffffc0201094 <buddy_system_free_pages+0xdc>
        p->flags = 0;
ffffffffc0200ff4:	0007b423          	sd	zero,8(a5)
ffffffffc0200ff8:	0007a023          	sw	zero,0(a5)
    for (; p != base + size; p ++) {
ffffffffc0200ffc:	02878793          	addi	a5,a5,40
ffffffffc0201000:	fec794e3          	bne	a5,a2,ffffffffc0200fe8 <buddy_system_free_pages+0x30>
    base->property=size;
ffffffffc0201004:	2681                	sext.w	a3,a3
ffffffffc0201006:	c914                	sw	a3,16(a0)
    __op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc0201008:	4789                	li	a5,2
ffffffffc020100a:	00850713          	addi	a4,a0,8
ffffffffc020100e:	40f7302f          	amoor.d	zero,a5,(a4)
    nr_free += size;
ffffffffc0201012:	00005617          	auipc	a2,0x5
ffffffffc0201016:	ffe60613          	addi	a2,a2,-2 # ffffffffc0206010 <bsfree_area>
ffffffffc020101a:	4a18                	lw	a4,16(a2)
    return list->next == list;
ffffffffc020101c:	661c                	ld	a5,8(a2)
        list_add(&free_list, &(base->page_link));
ffffffffc020101e:	01850813          	addi	a6,a0,24
    nr_free += size;
ffffffffc0201022:	9eb9                	addw	a3,a3,a4
ffffffffc0201024:	ca14                	sw	a3,16(a2)
    if (list_empty(&free_list)) {
ffffffffc0201026:	04c78e63          	beq	a5,a2,ffffffffc0201082 <buddy_system_free_pages+0xca>
            struct Page* page = le2page(le, page_link);
ffffffffc020102a:	fe878713          	addi	a4,a5,-24
ffffffffc020102e:	00063883          	ld	a7,0(a2)
    if (list_empty(&free_list)) {
ffffffffc0201032:	4681                	li	a3,0
            if (base < page) {
ffffffffc0201034:	00e56a63          	bltu	a0,a4,ffffffffc0201048 <buddy_system_free_pages+0x90>
    return listelm->next;
ffffffffc0201038:	6798                	ld	a4,8(a5)
            } else if (list_next(le) == &free_list) {
ffffffffc020103a:	02c70463          	beq	a4,a2,ffffffffc0201062 <buddy_system_free_pages+0xaa>
    for (; p != base + size; p ++) {
ffffffffc020103e:	87ba                	mv	a5,a4
            struct Page* page = le2page(le, page_link);
ffffffffc0201040:	fe878713          	addi	a4,a5,-24
            if (base < page) {
ffffffffc0201044:	fee57ae3          	bgeu	a0,a4,ffffffffc0201038 <buddy_system_free_pages+0x80>
ffffffffc0201048:	c299                	beqz	a3,ffffffffc020104e <buddy_system_free_pages+0x96>
ffffffffc020104a:	01163023          	sd	a7,0(a2)
    __list_add(elm, listelm->prev, listelm);
ffffffffc020104e:	6398                	ld	a4,0(a5)
    prev->next = next->prev = elm;
ffffffffc0201050:	0107b023          	sd	a6,0(a5)
}
ffffffffc0201054:	60a2                	ld	ra,8(sp)
ffffffffc0201056:	01073423          	sd	a6,8(a4)
    elm->next = next;
ffffffffc020105a:	f11c                	sd	a5,32(a0)
    elm->prev = prev;
ffffffffc020105c:	ed18                	sd	a4,24(a0)
ffffffffc020105e:	0141                	addi	sp,sp,16
    free_mem(base,size);
ffffffffc0201060:	b52d                	j	ffffffffc0200e8a <free_mem>
    prev->next = next->prev = elm;
ffffffffc0201062:	0107b423          	sd	a6,8(a5)
    elm->next = next;
ffffffffc0201066:	f110                	sd	a2,32(a0)
    return listelm->next;
ffffffffc0201068:	6798                	ld	a4,8(a5)
    elm->prev = prev;
ffffffffc020106a:	ed1c                	sd	a5,24(a0)
        while ((le = list_next(le)) != &free_list) {
ffffffffc020106c:	00c70663          	beq	a4,a2,ffffffffc0201078 <buddy_system_free_pages+0xc0>
    prev->next = next->prev = elm;
ffffffffc0201070:	88c2                	mv	a7,a6
ffffffffc0201072:	4685                	li	a3,1
    for (; p != base + size; p ++) {
ffffffffc0201074:	87ba                	mv	a5,a4
ffffffffc0201076:	b7e9                	j	ffffffffc0201040 <buddy_system_free_pages+0x88>
}
ffffffffc0201078:	60a2                	ld	ra,8(sp)
ffffffffc020107a:	01063023          	sd	a6,0(a2)
ffffffffc020107e:	0141                	addi	sp,sp,16
    free_mem(base,size);
ffffffffc0201080:	b529                	j	ffffffffc0200e8a <free_mem>
}
ffffffffc0201082:	60a2                	ld	ra,8(sp)
ffffffffc0201084:	0107b023          	sd	a6,0(a5)
ffffffffc0201088:	0107b423          	sd	a6,8(a5)
    elm->next = next;
ffffffffc020108c:	f11c                	sd	a5,32(a0)
    elm->prev = prev;
ffffffffc020108e:	ed1c                	sd	a5,24(a0)
ffffffffc0201090:	0141                	addi	sp,sp,16
    free_mem(base,size);
ffffffffc0201092:	bbe5                	j	ffffffffc0200e8a <free_mem>
        assert(!PageReserved(p) && !PageProperty(p));
ffffffffc0201094:	00001697          	auipc	a3,0x1
ffffffffc0201098:	16c68693          	addi	a3,a3,364 # ffffffffc0202200 <commands+0x6f8>
ffffffffc020109c:	00001617          	auipc	a2,0x1
ffffffffc02010a0:	f6c60613          	addi	a2,a2,-148 # ffffffffc0202008 <commands+0x500>
ffffffffc02010a4:	13400593          	li	a1,308
ffffffffc02010a8:	00001517          	auipc	a0,0x1
ffffffffc02010ac:	f7850513          	addi	a0,a0,-136 # ffffffffc0202020 <commands+0x518>
ffffffffc02010b0:	88aff0ef          	jal	ra,ffffffffc020013a <__panic>
    assert(n > 0);
ffffffffc02010b4:	00001697          	auipc	a3,0x1
ffffffffc02010b8:	0c468693          	addi	a3,a3,196 # ffffffffc0202178 <commands+0x670>
ffffffffc02010bc:	00001617          	auipc	a2,0x1
ffffffffc02010c0:	f4c60613          	addi	a2,a2,-180 # ffffffffc0202008 <commands+0x500>
ffffffffc02010c4:	12b00593          	li	a1,299
ffffffffc02010c8:	00001517          	auipc	a0,0x1
ffffffffc02010cc:	f5850513          	addi	a0,a0,-168 # ffffffffc0202020 <commands+0x518>
ffffffffc02010d0:	86aff0ef          	jal	ra,ffffffffc020013a <__panic>

ffffffffc02010d4 <alloc_pages>:
#include <defs.h>
#include <intr.h>
#include <riscv.h>

static inline bool __intr_save(void) {
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc02010d4:	100027f3          	csrr	a5,sstatus
ffffffffc02010d8:	8b89                	andi	a5,a5,2
ffffffffc02010da:	e799                	bnez	a5,ffffffffc02010e8 <alloc_pages+0x14>
struct Page *alloc_pages(size_t n) {
    struct Page *page = NULL;
    bool intr_flag;
    local_intr_save(intr_flag);
    {
        page = pmm_manager->alloc_pages(n);
ffffffffc02010dc:	00005797          	auipc	a5,0x5
ffffffffc02010e0:	37c7b783          	ld	a5,892(a5) # ffffffffc0206458 <pmm_manager>
ffffffffc02010e4:	6f9c                	ld	a5,24(a5)
ffffffffc02010e6:	8782                	jr	a5
struct Page *alloc_pages(size_t n) {
ffffffffc02010e8:	1141                	addi	sp,sp,-16
ffffffffc02010ea:	e406                	sd	ra,8(sp)
ffffffffc02010ec:	e022                	sd	s0,0(sp)
ffffffffc02010ee:	842a                	mv	s0,a0
        intr_disable();
ffffffffc02010f0:	b6eff0ef          	jal	ra,ffffffffc020045e <intr_disable>
        page = pmm_manager->alloc_pages(n);
ffffffffc02010f4:	00005797          	auipc	a5,0x5
ffffffffc02010f8:	3647b783          	ld	a5,868(a5) # ffffffffc0206458 <pmm_manager>
ffffffffc02010fc:	6f9c                	ld	a5,24(a5)
ffffffffc02010fe:	8522                	mv	a0,s0
ffffffffc0201100:	9782                	jalr	a5
ffffffffc0201102:	842a                	mv	s0,a0
    return 0;
}

static inline void __intr_restore(bool flag) {
    if (flag) {
        intr_enable();
ffffffffc0201104:	b54ff0ef          	jal	ra,ffffffffc0200458 <intr_enable>
    }
    local_intr_restore(intr_flag);
    return page;
}
ffffffffc0201108:	60a2                	ld	ra,8(sp)
ffffffffc020110a:	8522                	mv	a0,s0
ffffffffc020110c:	6402                	ld	s0,0(sp)
ffffffffc020110e:	0141                	addi	sp,sp,16
ffffffffc0201110:	8082                	ret

ffffffffc0201112 <free_pages>:
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0201112:	100027f3          	csrr	a5,sstatus
ffffffffc0201116:	8b89                	andi	a5,a5,2
ffffffffc0201118:	e799                	bnez	a5,ffffffffc0201126 <free_pages+0x14>
// free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory
void free_pages(struct Page *base, size_t n) {
    bool intr_flag;
    local_intr_save(intr_flag);
    {
        pmm_manager->free_pages(base, n);
ffffffffc020111a:	00005797          	auipc	a5,0x5
ffffffffc020111e:	33e7b783          	ld	a5,830(a5) # ffffffffc0206458 <pmm_manager>
ffffffffc0201122:	739c                	ld	a5,32(a5)
ffffffffc0201124:	8782                	jr	a5
void free_pages(struct Page *base, size_t n) {
ffffffffc0201126:	1101                	addi	sp,sp,-32
ffffffffc0201128:	ec06                	sd	ra,24(sp)
ffffffffc020112a:	e822                	sd	s0,16(sp)
ffffffffc020112c:	e426                	sd	s1,8(sp)
ffffffffc020112e:	842a                	mv	s0,a0
ffffffffc0201130:	84ae                	mv	s1,a1
        intr_disable();
ffffffffc0201132:	b2cff0ef          	jal	ra,ffffffffc020045e <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc0201136:	00005797          	auipc	a5,0x5
ffffffffc020113a:	3227b783          	ld	a5,802(a5) # ffffffffc0206458 <pmm_manager>
ffffffffc020113e:	739c                	ld	a5,32(a5)
ffffffffc0201140:	85a6                	mv	a1,s1
ffffffffc0201142:	8522                	mv	a0,s0
ffffffffc0201144:	9782                	jalr	a5
    }
    local_intr_restore(intr_flag);
}
ffffffffc0201146:	6442                	ld	s0,16(sp)
ffffffffc0201148:	60e2                	ld	ra,24(sp)
ffffffffc020114a:	64a2                	ld	s1,8(sp)
ffffffffc020114c:	6105                	addi	sp,sp,32
        intr_enable();
ffffffffc020114e:	b0aff06f          	j	ffffffffc0200458 <intr_enable>

ffffffffc0201152 <nr_free_pages>:
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0201152:	100027f3          	csrr	a5,sstatus
ffffffffc0201156:	8b89                	andi	a5,a5,2
ffffffffc0201158:	e799                	bnez	a5,ffffffffc0201166 <nr_free_pages+0x14>
size_t nr_free_pages(void) {
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
    {
        ret = pmm_manager->nr_free_pages();
ffffffffc020115a:	00005797          	auipc	a5,0x5
ffffffffc020115e:	2fe7b783          	ld	a5,766(a5) # ffffffffc0206458 <pmm_manager>
ffffffffc0201162:	779c                	ld	a5,40(a5)
ffffffffc0201164:	8782                	jr	a5
size_t nr_free_pages(void) {
ffffffffc0201166:	1141                	addi	sp,sp,-16
ffffffffc0201168:	e406                	sd	ra,8(sp)
ffffffffc020116a:	e022                	sd	s0,0(sp)
        intr_disable();
ffffffffc020116c:	af2ff0ef          	jal	ra,ffffffffc020045e <intr_disable>
        ret = pmm_manager->nr_free_pages();
ffffffffc0201170:	00005797          	auipc	a5,0x5
ffffffffc0201174:	2e87b783          	ld	a5,744(a5) # ffffffffc0206458 <pmm_manager>
ffffffffc0201178:	779c                	ld	a5,40(a5)
ffffffffc020117a:	9782                	jalr	a5
ffffffffc020117c:	842a                	mv	s0,a0
        intr_enable();
ffffffffc020117e:	adaff0ef          	jal	ra,ffffffffc0200458 <intr_enable>
    }
    local_intr_restore(intr_flag);
    return ret;
}
ffffffffc0201182:	60a2                	ld	ra,8(sp)
ffffffffc0201184:	8522                	mv	a0,s0
ffffffffc0201186:	6402                	ld	s0,0(sp)
ffffffffc0201188:	0141                	addi	sp,sp,16
ffffffffc020118a:	8082                	ret

ffffffffc020118c <pmm_init>:
    pmm_manager = &buddy_system_pmm_manager;
ffffffffc020118c:	00001797          	auipc	a5,0x1
ffffffffc0201190:	0bc78793          	addi	a5,a5,188 # ffffffffc0202248 <buddy_system_pmm_manager>
    cprintf("memory management: %s\n", pmm_manager->name);
ffffffffc0201194:	638c                	ld	a1,0(a5)




/* pmm_init - initialize the physical memory management */
void pmm_init(void) {
ffffffffc0201196:	1101                	addi	sp,sp,-32
ffffffffc0201198:	e822                	sd	s0,16(sp)
    cprintf("memory management: %s\n", pmm_manager->name);
ffffffffc020119a:	00001517          	auipc	a0,0x1
ffffffffc020119e:	0e650513          	addi	a0,a0,230 # ffffffffc0202280 <buddy_system_pmm_manager+0x38>
    pmm_manager = &buddy_system_pmm_manager;
ffffffffc02011a2:	00005417          	auipc	s0,0x5
ffffffffc02011a6:	2b640413          	addi	s0,s0,694 # ffffffffc0206458 <pmm_manager>
void pmm_init(void) {
ffffffffc02011aa:	ec06                	sd	ra,24(sp)
ffffffffc02011ac:	e426                	sd	s1,8(sp)
    pmm_manager = &buddy_system_pmm_manager;
ffffffffc02011ae:	e01c                	sd	a5,0(s0)
    cprintf("memory management: %s\n", pmm_manager->name);
ffffffffc02011b0:	f03fe0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    pmm_manager->init();
ffffffffc02011b4:	601c                	ld	a5,0(s0)
    va_pa_offset = PHYSICAL_MEMORY_OFFSET;
ffffffffc02011b6:	00005497          	auipc	s1,0x5
ffffffffc02011ba:	2ba48493          	addi	s1,s1,698 # ffffffffc0206470 <va_pa_offset>
    pmm_manager->init();
ffffffffc02011be:	679c                	ld	a5,8(a5)
ffffffffc02011c0:	9782                	jalr	a5
    // Now the first_fit/best_fit/worst_fit/buddy_system pmm are available.
    init_pmm_manager();

    // detect physical memory space, reserve already used memory,
    // then use pmm->init_memmap to create free page list
    cprintf("init begin\n");
ffffffffc02011c2:	00001517          	auipc	a0,0x1
ffffffffc02011c6:	0d650513          	addi	a0,a0,214 # ffffffffc0202298 <buddy_system_pmm_manager+0x50>
ffffffffc02011ca:	ee9fe0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    va_pa_offset = PHYSICAL_MEMORY_OFFSET;
ffffffffc02011ce:	57f5                	li	a5,-3
ffffffffc02011d0:	07fa                	slli	a5,a5,0x1e
    cprintf("physcial memory map:\n");
ffffffffc02011d2:	00001517          	auipc	a0,0x1
ffffffffc02011d6:	0d650513          	addi	a0,a0,214 # ffffffffc02022a8 <buddy_system_pmm_manager+0x60>
    va_pa_offset = PHYSICAL_MEMORY_OFFSET;
ffffffffc02011da:	e09c                	sd	a5,0(s1)
    cprintf("physcial memory map:\n");
ffffffffc02011dc:	ed7fe0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    cprintf("  memory: 0x%016lx, [0x%016lx, 0x%016lx].\n", mem_size, mem_begin,
ffffffffc02011e0:	46c5                	li	a3,17
ffffffffc02011e2:	06ee                	slli	a3,a3,0x1b
ffffffffc02011e4:	40100613          	li	a2,1025
ffffffffc02011e8:	16fd                	addi	a3,a3,-1
ffffffffc02011ea:	07e005b7          	lui	a1,0x7e00
ffffffffc02011ee:	0656                	slli	a2,a2,0x15
ffffffffc02011f0:	00001517          	auipc	a0,0x1
ffffffffc02011f4:	0d050513          	addi	a0,a0,208 # ffffffffc02022c0 <buddy_system_pmm_manager+0x78>
ffffffffc02011f8:	ebbfe0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
ffffffffc02011fc:	777d                	lui	a4,0xfffff
ffffffffc02011fe:	00006797          	auipc	a5,0x6
ffffffffc0201202:	28178793          	addi	a5,a5,641 # ffffffffc020747f <end+0xfff>
ffffffffc0201206:	8ff9                	and	a5,a5,a4
    npage = maxpa / PGSIZE;
ffffffffc0201208:	00005517          	auipc	a0,0x5
ffffffffc020120c:	24050513          	addi	a0,a0,576 # ffffffffc0206448 <npage>
ffffffffc0201210:	00088737          	lui	a4,0x88
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
ffffffffc0201214:	00005597          	auipc	a1,0x5
ffffffffc0201218:	23c58593          	addi	a1,a1,572 # ffffffffc0206450 <pages>
    npage = maxpa / PGSIZE;
ffffffffc020121c:	e118                	sd	a4,0(a0)
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
ffffffffc020121e:	e19c                	sd	a5,0(a1)
ffffffffc0201220:	4681                	li	a3,0
    for (size_t i = 0; i < npage - nbase; i++) {
ffffffffc0201222:	4701                	li	a4,0
ffffffffc0201224:	4885                	li	a7,1
ffffffffc0201226:	fff80837          	lui	a6,0xfff80
ffffffffc020122a:	a011                	j	ffffffffc020122e <pmm_init+0xa2>
        SetPageReserved(pages + i);
ffffffffc020122c:	619c                	ld	a5,0(a1)
ffffffffc020122e:	97b6                	add	a5,a5,a3
ffffffffc0201230:	07a1                	addi	a5,a5,8
ffffffffc0201232:	4117b02f          	amoor.d	zero,a7,(a5)
    for (size_t i = 0; i < npage - nbase; i++) {
ffffffffc0201236:	611c                	ld	a5,0(a0)
ffffffffc0201238:	0705                	addi	a4,a4,1
ffffffffc020123a:	02868693          	addi	a3,a3,40
ffffffffc020123e:	01078633          	add	a2,a5,a6
ffffffffc0201242:	fec765e3          	bltu	a4,a2,ffffffffc020122c <pmm_init+0xa0>
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc0201246:	6190                	ld	a2,0(a1)
ffffffffc0201248:	00279693          	slli	a3,a5,0x2
ffffffffc020124c:	96be                	add	a3,a3,a5
ffffffffc020124e:	fec00737          	lui	a4,0xfec00
ffffffffc0201252:	9732                	add	a4,a4,a2
ffffffffc0201254:	068e                	slli	a3,a3,0x3
ffffffffc0201256:	96ba                	add	a3,a3,a4
ffffffffc0201258:	c0200737          	lui	a4,0xc0200
ffffffffc020125c:	0ae6e563          	bltu	a3,a4,ffffffffc0201306 <pmm_init+0x17a>
ffffffffc0201260:	6098                	ld	a4,0(s1)
    if (freemem < mem_end) {
ffffffffc0201262:	45c5                	li	a1,17
ffffffffc0201264:	05ee                	slli	a1,a1,0x1b
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc0201266:	8e99                	sub	a3,a3,a4
    if (freemem < mem_end) {
ffffffffc0201268:	04b6ee63          	bltu	a3,a1,ffffffffc02012c4 <pmm_init+0x138>
    page_init();
    cprintf("init end\n");
ffffffffc020126c:	00001517          	auipc	a0,0x1
ffffffffc0201270:	0ec50513          	addi	a0,a0,236 # ffffffffc0202358 <buddy_system_pmm_manager+0x110>
ffffffffc0201274:	e3ffe0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    satp_physical = PADDR(satp_virtual);
    cprintf("satp virtual address: 0x%016lx\nsatp physical address: 0x%016lx\n", satp_virtual, satp_physical);
}

static void check_alloc_page(void) {
    pmm_manager->check();
ffffffffc0201278:	601c                	ld	a5,0(s0)
ffffffffc020127a:	7b9c                	ld	a5,48(a5)
ffffffffc020127c:	9782                	jalr	a5
    cprintf("check_alloc_page() succeeded!\n");
ffffffffc020127e:	00001517          	auipc	a0,0x1
ffffffffc0201282:	0ea50513          	addi	a0,a0,234 # ffffffffc0202368 <buddy_system_pmm_manager+0x120>
ffffffffc0201286:	e2dfe0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    satp_virtual = (pte_t*)boot_page_table_sv39;
ffffffffc020128a:	00004597          	auipc	a1,0x4
ffffffffc020128e:	d7658593          	addi	a1,a1,-650 # ffffffffc0205000 <boot_page_table_sv39>
ffffffffc0201292:	00005797          	auipc	a5,0x5
ffffffffc0201296:	1cb7bb23          	sd	a1,470(a5) # ffffffffc0206468 <satp_virtual>
    satp_physical = PADDR(satp_virtual);
ffffffffc020129a:	c02007b7          	lui	a5,0xc0200
ffffffffc020129e:	08f5e063          	bltu	a1,a5,ffffffffc020131e <pmm_init+0x192>
ffffffffc02012a2:	6090                	ld	a2,0(s1)
}
ffffffffc02012a4:	6442                	ld	s0,16(sp)
ffffffffc02012a6:	60e2                	ld	ra,24(sp)
ffffffffc02012a8:	64a2                	ld	s1,8(sp)
    satp_physical = PADDR(satp_virtual);
ffffffffc02012aa:	40c58633          	sub	a2,a1,a2
ffffffffc02012ae:	00005797          	auipc	a5,0x5
ffffffffc02012b2:	1ac7b923          	sd	a2,434(a5) # ffffffffc0206460 <satp_physical>
    cprintf("satp virtual address: 0x%016lx\nsatp physical address: 0x%016lx\n", satp_virtual, satp_physical);
ffffffffc02012b6:	00001517          	auipc	a0,0x1
ffffffffc02012ba:	0d250513          	addi	a0,a0,210 # ffffffffc0202388 <buddy_system_pmm_manager+0x140>
}
ffffffffc02012be:	6105                	addi	sp,sp,32
    cprintf("satp virtual address: 0x%016lx\nsatp physical address: 0x%016lx\n", satp_virtual, satp_physical);
ffffffffc02012c0:	df3fe06f          	j	ffffffffc02000b2 <cprintf>
    mem_begin = ROUNDUP(freemem, PGSIZE);
ffffffffc02012c4:	6705                	lui	a4,0x1
ffffffffc02012c6:	177d                	addi	a4,a4,-1
ffffffffc02012c8:	96ba                	add	a3,a3,a4
ffffffffc02012ca:	777d                	lui	a4,0xfffff
ffffffffc02012cc:	8ef9                	and	a3,a3,a4
static inline int page_ref_dec(struct Page *page) {
    page->ref -= 1;
    return page->ref;
}
static inline struct Page *pa2page(uintptr_t pa) {
    if (PPN(pa) >= npage) {
ffffffffc02012ce:	00c6d513          	srli	a0,a3,0xc
ffffffffc02012d2:	00f57e63          	bgeu	a0,a5,ffffffffc02012ee <pmm_init+0x162>
    pmm_manager->init_memmap(base, n);
ffffffffc02012d6:	601c                	ld	a5,0(s0)
        panic("pa2page called with invalid pa");
    }
    return &pages[PPN(pa) - nbase];
ffffffffc02012d8:	982a                	add	a6,a6,a0
ffffffffc02012da:	00281513          	slli	a0,a6,0x2
ffffffffc02012de:	9542                	add	a0,a0,a6
ffffffffc02012e0:	6b9c                	ld	a5,16(a5)
        init_memmap(pa2page(mem_begin), (mem_end - mem_begin) / PGSIZE);
ffffffffc02012e2:	8d95                	sub	a1,a1,a3
ffffffffc02012e4:	050e                	slli	a0,a0,0x3
    pmm_manager->init_memmap(base, n);
ffffffffc02012e6:	81b1                	srli	a1,a1,0xc
ffffffffc02012e8:	9532                	add	a0,a0,a2
ffffffffc02012ea:	9782                	jalr	a5
}
ffffffffc02012ec:	b741                	j	ffffffffc020126c <pmm_init+0xe0>
        panic("pa2page called with invalid pa");
ffffffffc02012ee:	00001617          	auipc	a2,0x1
ffffffffc02012f2:	03a60613          	addi	a2,a2,58 # ffffffffc0202328 <buddy_system_pmm_manager+0xe0>
ffffffffc02012f6:	06c00593          	li	a1,108
ffffffffc02012fa:	00001517          	auipc	a0,0x1
ffffffffc02012fe:	04e50513          	addi	a0,a0,78 # ffffffffc0202348 <buddy_system_pmm_manager+0x100>
ffffffffc0201302:	e39fe0ef          	jal	ra,ffffffffc020013a <__panic>
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc0201306:	00001617          	auipc	a2,0x1
ffffffffc020130a:	fea60613          	addi	a2,a2,-22 # ffffffffc02022f0 <buddy_system_pmm_manager+0xa8>
ffffffffc020130e:	06f00593          	li	a1,111
ffffffffc0201312:	00001517          	auipc	a0,0x1
ffffffffc0201316:	00650513          	addi	a0,a0,6 # ffffffffc0202318 <buddy_system_pmm_manager+0xd0>
ffffffffc020131a:	e21fe0ef          	jal	ra,ffffffffc020013a <__panic>
    satp_physical = PADDR(satp_virtual);
ffffffffc020131e:	86ae                	mv	a3,a1
ffffffffc0201320:	00001617          	auipc	a2,0x1
ffffffffc0201324:	fd060613          	addi	a2,a2,-48 # ffffffffc02022f0 <buddy_system_pmm_manager+0xa8>
ffffffffc0201328:	09100593          	li	a1,145
ffffffffc020132c:	00001517          	auipc	a0,0x1
ffffffffc0201330:	fec50513          	addi	a0,a0,-20 # ffffffffc0202318 <buddy_system_pmm_manager+0xd0>
ffffffffc0201334:	e07fe0ef          	jal	ra,ffffffffc020013a <__panic>

ffffffffc0201338 <strnlen>:
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
ffffffffc0201338:	4781                	li	a5,0
    while (cnt < len && *s ++ != '\0') {
ffffffffc020133a:	e589                	bnez	a1,ffffffffc0201344 <strnlen+0xc>
ffffffffc020133c:	a811                	j	ffffffffc0201350 <strnlen+0x18>
        cnt ++;
ffffffffc020133e:	0785                	addi	a5,a5,1
    while (cnt < len && *s ++ != '\0') {
ffffffffc0201340:	00f58863          	beq	a1,a5,ffffffffc0201350 <strnlen+0x18>
ffffffffc0201344:	00f50733          	add	a4,a0,a5
ffffffffc0201348:	00074703          	lbu	a4,0(a4) # fffffffffffff000 <end+0x3fdf8b80>
ffffffffc020134c:	fb6d                	bnez	a4,ffffffffc020133e <strnlen+0x6>
ffffffffc020134e:	85be                	mv	a1,a5
    }
    return cnt;
}
ffffffffc0201350:	852e                	mv	a0,a1
ffffffffc0201352:	8082                	ret

ffffffffc0201354 <strcmp>:
int
strcmp(const char *s1, const char *s2) {
#ifdef __HAVE_ARCH_STRCMP
    return __strcmp(s1, s2);
#else
    while (*s1 != '\0' && *s1 == *s2) {
ffffffffc0201354:	00054783          	lbu	a5,0(a0)
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc0201358:	0005c703          	lbu	a4,0(a1)
    while (*s1 != '\0' && *s1 == *s2) {
ffffffffc020135c:	cb89                	beqz	a5,ffffffffc020136e <strcmp+0x1a>
        s1 ++, s2 ++;
ffffffffc020135e:	0505                	addi	a0,a0,1
ffffffffc0201360:	0585                	addi	a1,a1,1
    while (*s1 != '\0' && *s1 == *s2) {
ffffffffc0201362:	fee789e3          	beq	a5,a4,ffffffffc0201354 <strcmp>
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc0201366:	0007851b          	sext.w	a0,a5
#endif /* __HAVE_ARCH_STRCMP */
}
ffffffffc020136a:	9d19                	subw	a0,a0,a4
ffffffffc020136c:	8082                	ret
ffffffffc020136e:	4501                	li	a0,0
ffffffffc0201370:	bfed                	j	ffffffffc020136a <strcmp+0x16>

ffffffffc0201372 <strchr>:
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
ffffffffc0201372:	00054783          	lbu	a5,0(a0)
ffffffffc0201376:	c799                	beqz	a5,ffffffffc0201384 <strchr+0x12>
        if (*s == c) {
ffffffffc0201378:	00f58763          	beq	a1,a5,ffffffffc0201386 <strchr+0x14>
    while (*s != '\0') {
ffffffffc020137c:	00154783          	lbu	a5,1(a0)
            return (char *)s;
        }
        s ++;
ffffffffc0201380:	0505                	addi	a0,a0,1
    while (*s != '\0') {
ffffffffc0201382:	fbfd                	bnez	a5,ffffffffc0201378 <strchr+0x6>
    }
    return NULL;
ffffffffc0201384:	4501                	li	a0,0
}
ffffffffc0201386:	8082                	ret

ffffffffc0201388 <memset>:
memset(void *s, char c, size_t n) {
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
#else
    char *p = s;
    while (n -- > 0) {
ffffffffc0201388:	ca01                	beqz	a2,ffffffffc0201398 <memset+0x10>
ffffffffc020138a:	962a                	add	a2,a2,a0
    char *p = s;
ffffffffc020138c:	87aa                	mv	a5,a0
        *p ++ = c;
ffffffffc020138e:	0785                	addi	a5,a5,1
ffffffffc0201390:	feb78fa3          	sb	a1,-1(a5)
    while (n -- > 0) {
ffffffffc0201394:	fec79de3          	bne	a5,a2,ffffffffc020138e <memset+0x6>
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
ffffffffc0201398:	8082                	ret

ffffffffc020139a <printnum>:
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
    unsigned long long result = num;
    unsigned mod = do_div(result, base);
ffffffffc020139a:	02069813          	slli	a6,a3,0x20
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc020139e:	7179                	addi	sp,sp,-48
    unsigned mod = do_div(result, base);
ffffffffc02013a0:	02085813          	srli	a6,a6,0x20
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc02013a4:	e052                	sd	s4,0(sp)
    unsigned mod = do_div(result, base);
ffffffffc02013a6:	03067a33          	remu	s4,a2,a6
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc02013aa:	f022                	sd	s0,32(sp)
ffffffffc02013ac:	ec26                	sd	s1,24(sp)
ffffffffc02013ae:	e84a                	sd	s2,16(sp)
ffffffffc02013b0:	f406                	sd	ra,40(sp)
ffffffffc02013b2:	e44e                	sd	s3,8(sp)
ffffffffc02013b4:	84aa                	mv	s1,a0
ffffffffc02013b6:	892e                	mv	s2,a1
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
ffffffffc02013b8:	fff7041b          	addiw	s0,a4,-1
    unsigned mod = do_div(result, base);
ffffffffc02013bc:	2a01                	sext.w	s4,s4
    if (num >= base) {
ffffffffc02013be:	03067e63          	bgeu	a2,a6,ffffffffc02013fa <printnum+0x60>
ffffffffc02013c2:	89be                	mv	s3,a5
        while (-- width > 0)
ffffffffc02013c4:	00805763          	blez	s0,ffffffffc02013d2 <printnum+0x38>
ffffffffc02013c8:	347d                	addiw	s0,s0,-1
            putch(padc, putdat);
ffffffffc02013ca:	85ca                	mv	a1,s2
ffffffffc02013cc:	854e                	mv	a0,s3
ffffffffc02013ce:	9482                	jalr	s1
        while (-- width > 0)
ffffffffc02013d0:	fc65                	bnez	s0,ffffffffc02013c8 <printnum+0x2e>
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
ffffffffc02013d2:	1a02                	slli	s4,s4,0x20
ffffffffc02013d4:	00001797          	auipc	a5,0x1
ffffffffc02013d8:	ff478793          	addi	a5,a5,-12 # ffffffffc02023c8 <buddy_system_pmm_manager+0x180>
ffffffffc02013dc:	020a5a13          	srli	s4,s4,0x20
ffffffffc02013e0:	9a3e                	add	s4,s4,a5
}
ffffffffc02013e2:	7402                	ld	s0,32(sp)
    putch("0123456789abcdef"[mod], putdat);
ffffffffc02013e4:	000a4503          	lbu	a0,0(s4)
}
ffffffffc02013e8:	70a2                	ld	ra,40(sp)
ffffffffc02013ea:	69a2                	ld	s3,8(sp)
ffffffffc02013ec:	6a02                	ld	s4,0(sp)
    putch("0123456789abcdef"[mod], putdat);
ffffffffc02013ee:	85ca                	mv	a1,s2
ffffffffc02013f0:	87a6                	mv	a5,s1
}
ffffffffc02013f2:	6942                	ld	s2,16(sp)
ffffffffc02013f4:	64e2                	ld	s1,24(sp)
ffffffffc02013f6:	6145                	addi	sp,sp,48
    putch("0123456789abcdef"[mod], putdat);
ffffffffc02013f8:	8782                	jr	a5
        printnum(putch, putdat, result, base, width - 1, padc);
ffffffffc02013fa:	03065633          	divu	a2,a2,a6
ffffffffc02013fe:	8722                	mv	a4,s0
ffffffffc0201400:	f9bff0ef          	jal	ra,ffffffffc020139a <printnum>
ffffffffc0201404:	b7f9                	j	ffffffffc02013d2 <printnum+0x38>

ffffffffc0201406 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
ffffffffc0201406:	7119                	addi	sp,sp,-128
ffffffffc0201408:	f4a6                	sd	s1,104(sp)
ffffffffc020140a:	f0ca                	sd	s2,96(sp)
ffffffffc020140c:	ecce                	sd	s3,88(sp)
ffffffffc020140e:	e8d2                	sd	s4,80(sp)
ffffffffc0201410:	e4d6                	sd	s5,72(sp)
ffffffffc0201412:	e0da                	sd	s6,64(sp)
ffffffffc0201414:	fc5e                	sd	s7,56(sp)
ffffffffc0201416:	f06a                	sd	s10,32(sp)
ffffffffc0201418:	fc86                	sd	ra,120(sp)
ffffffffc020141a:	f8a2                	sd	s0,112(sp)
ffffffffc020141c:	f862                	sd	s8,48(sp)
ffffffffc020141e:	f466                	sd	s9,40(sp)
ffffffffc0201420:	ec6e                	sd	s11,24(sp)
ffffffffc0201422:	892a                	mv	s2,a0
ffffffffc0201424:	84ae                	mv	s1,a1
ffffffffc0201426:	8d32                	mv	s10,a2
ffffffffc0201428:	8a36                	mv	s4,a3
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc020142a:	02500993          	li	s3,37
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
        width = precision = -1;
ffffffffc020142e:	5b7d                	li	s6,-1
ffffffffc0201430:	00001a97          	auipc	s5,0x1
ffffffffc0201434:	fcca8a93          	addi	s5,s5,-52 # ffffffffc02023fc <buddy_system_pmm_manager+0x1b4>
        case 'e':
            err = va_arg(ap, int);
            if (err < 0) {
                err = -err;
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
ffffffffc0201438:	00001b97          	auipc	s7,0x1
ffffffffc020143c:	1a0b8b93          	addi	s7,s7,416 # ffffffffc02025d8 <error_string>
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc0201440:	000d4503          	lbu	a0,0(s10)
ffffffffc0201444:	001d0413          	addi	s0,s10,1
ffffffffc0201448:	01350a63          	beq	a0,s3,ffffffffc020145c <vprintfmt+0x56>
            if (ch == '\0') {
ffffffffc020144c:	c121                	beqz	a0,ffffffffc020148c <vprintfmt+0x86>
            putch(ch, putdat);
ffffffffc020144e:	85a6                	mv	a1,s1
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc0201450:	0405                	addi	s0,s0,1
            putch(ch, putdat);
ffffffffc0201452:	9902                	jalr	s2
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc0201454:	fff44503          	lbu	a0,-1(s0)
ffffffffc0201458:	ff351ae3          	bne	a0,s3,ffffffffc020144c <vprintfmt+0x46>
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc020145c:	00044603          	lbu	a2,0(s0)
        char padc = ' ';
ffffffffc0201460:	02000793          	li	a5,32
        lflag = altflag = 0;
ffffffffc0201464:	4c81                	li	s9,0
ffffffffc0201466:	4881                	li	a7,0
        width = precision = -1;
ffffffffc0201468:	5c7d                	li	s8,-1
ffffffffc020146a:	5dfd                	li	s11,-1
ffffffffc020146c:	05500513          	li	a0,85
                if (ch < '0' || ch > '9') {
ffffffffc0201470:	4825                	li	a6,9
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0201472:	fdd6059b          	addiw	a1,a2,-35
ffffffffc0201476:	0ff5f593          	zext.b	a1,a1
ffffffffc020147a:	00140d13          	addi	s10,s0,1
ffffffffc020147e:	04b56263          	bltu	a0,a1,ffffffffc02014c2 <vprintfmt+0xbc>
ffffffffc0201482:	058a                	slli	a1,a1,0x2
ffffffffc0201484:	95d6                	add	a1,a1,s5
ffffffffc0201486:	4194                	lw	a3,0(a1)
ffffffffc0201488:	96d6                	add	a3,a3,s5
ffffffffc020148a:	8682                	jr	a3
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
ffffffffc020148c:	70e6                	ld	ra,120(sp)
ffffffffc020148e:	7446                	ld	s0,112(sp)
ffffffffc0201490:	74a6                	ld	s1,104(sp)
ffffffffc0201492:	7906                	ld	s2,96(sp)
ffffffffc0201494:	69e6                	ld	s3,88(sp)
ffffffffc0201496:	6a46                	ld	s4,80(sp)
ffffffffc0201498:	6aa6                	ld	s5,72(sp)
ffffffffc020149a:	6b06                	ld	s6,64(sp)
ffffffffc020149c:	7be2                	ld	s7,56(sp)
ffffffffc020149e:	7c42                	ld	s8,48(sp)
ffffffffc02014a0:	7ca2                	ld	s9,40(sp)
ffffffffc02014a2:	7d02                	ld	s10,32(sp)
ffffffffc02014a4:	6de2                	ld	s11,24(sp)
ffffffffc02014a6:	6109                	addi	sp,sp,128
ffffffffc02014a8:	8082                	ret
            padc = '0';
ffffffffc02014aa:	87b2                	mv	a5,a2
            goto reswitch;
ffffffffc02014ac:	00144603          	lbu	a2,1(s0)
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc02014b0:	846a                	mv	s0,s10
ffffffffc02014b2:	00140d13          	addi	s10,s0,1
ffffffffc02014b6:	fdd6059b          	addiw	a1,a2,-35
ffffffffc02014ba:	0ff5f593          	zext.b	a1,a1
ffffffffc02014be:	fcb572e3          	bgeu	a0,a1,ffffffffc0201482 <vprintfmt+0x7c>
            putch('%', putdat);
ffffffffc02014c2:	85a6                	mv	a1,s1
ffffffffc02014c4:	02500513          	li	a0,37
ffffffffc02014c8:	9902                	jalr	s2
            for (fmt --; fmt[-1] != '%'; fmt --)
ffffffffc02014ca:	fff44783          	lbu	a5,-1(s0)
ffffffffc02014ce:	8d22                	mv	s10,s0
ffffffffc02014d0:	f73788e3          	beq	a5,s3,ffffffffc0201440 <vprintfmt+0x3a>
ffffffffc02014d4:	ffed4783          	lbu	a5,-2(s10)
ffffffffc02014d8:	1d7d                	addi	s10,s10,-1
ffffffffc02014da:	ff379de3          	bne	a5,s3,ffffffffc02014d4 <vprintfmt+0xce>
ffffffffc02014de:	b78d                	j	ffffffffc0201440 <vprintfmt+0x3a>
                precision = precision * 10 + ch - '0';
ffffffffc02014e0:	fd060c1b          	addiw	s8,a2,-48
                ch = *fmt;
ffffffffc02014e4:	00144603          	lbu	a2,1(s0)
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc02014e8:	846a                	mv	s0,s10
                if (ch < '0' || ch > '9') {
ffffffffc02014ea:	fd06069b          	addiw	a3,a2,-48
                ch = *fmt;
ffffffffc02014ee:	0006059b          	sext.w	a1,a2
                if (ch < '0' || ch > '9') {
ffffffffc02014f2:	02d86463          	bltu	a6,a3,ffffffffc020151a <vprintfmt+0x114>
                ch = *fmt;
ffffffffc02014f6:	00144603          	lbu	a2,1(s0)
                precision = precision * 10 + ch - '0';
ffffffffc02014fa:	002c169b          	slliw	a3,s8,0x2
ffffffffc02014fe:	0186873b          	addw	a4,a3,s8
ffffffffc0201502:	0017171b          	slliw	a4,a4,0x1
ffffffffc0201506:	9f2d                	addw	a4,a4,a1
                if (ch < '0' || ch > '9') {
ffffffffc0201508:	fd06069b          	addiw	a3,a2,-48
            for (precision = 0; ; ++ fmt) {
ffffffffc020150c:	0405                	addi	s0,s0,1
                precision = precision * 10 + ch - '0';
ffffffffc020150e:	fd070c1b          	addiw	s8,a4,-48
                ch = *fmt;
ffffffffc0201512:	0006059b          	sext.w	a1,a2
                if (ch < '0' || ch > '9') {
ffffffffc0201516:	fed870e3          	bgeu	a6,a3,ffffffffc02014f6 <vprintfmt+0xf0>
            if (width < 0)
ffffffffc020151a:	f40ddce3          	bgez	s11,ffffffffc0201472 <vprintfmt+0x6c>
                width = precision, precision = -1;
ffffffffc020151e:	8de2                	mv	s11,s8
ffffffffc0201520:	5c7d                	li	s8,-1
ffffffffc0201522:	bf81                	j	ffffffffc0201472 <vprintfmt+0x6c>
            if (width < 0)
ffffffffc0201524:	fffdc693          	not	a3,s11
ffffffffc0201528:	96fd                	srai	a3,a3,0x3f
ffffffffc020152a:	00ddfdb3          	and	s11,s11,a3
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc020152e:	00144603          	lbu	a2,1(s0)
ffffffffc0201532:	2d81                	sext.w	s11,s11
ffffffffc0201534:	846a                	mv	s0,s10
            goto reswitch;
ffffffffc0201536:	bf35                	j	ffffffffc0201472 <vprintfmt+0x6c>
            precision = va_arg(ap, int);
ffffffffc0201538:	000a2c03          	lw	s8,0(s4)
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc020153c:	00144603          	lbu	a2,1(s0)
            precision = va_arg(ap, int);
ffffffffc0201540:	0a21                	addi	s4,s4,8
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0201542:	846a                	mv	s0,s10
            goto process_precision;
ffffffffc0201544:	bfd9                	j	ffffffffc020151a <vprintfmt+0x114>
    if (lflag >= 2) {
ffffffffc0201546:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc0201548:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
ffffffffc020154c:	01174463          	blt	a4,a7,ffffffffc0201554 <vprintfmt+0x14e>
    else if (lflag) {
ffffffffc0201550:	1a088e63          	beqz	a7,ffffffffc020170c <vprintfmt+0x306>
        return va_arg(*ap, unsigned long);
ffffffffc0201554:	000a3603          	ld	a2,0(s4)
ffffffffc0201558:	46c1                	li	a3,16
ffffffffc020155a:	8a2e                	mv	s4,a1
            printnum(putch, putdat, num, base, width, padc);
ffffffffc020155c:	2781                	sext.w	a5,a5
ffffffffc020155e:	876e                	mv	a4,s11
ffffffffc0201560:	85a6                	mv	a1,s1
ffffffffc0201562:	854a                	mv	a0,s2
ffffffffc0201564:	e37ff0ef          	jal	ra,ffffffffc020139a <printnum>
            break;
ffffffffc0201568:	bde1                	j	ffffffffc0201440 <vprintfmt+0x3a>
            putch(va_arg(ap, int), putdat);
ffffffffc020156a:	000a2503          	lw	a0,0(s4)
ffffffffc020156e:	85a6                	mv	a1,s1
ffffffffc0201570:	0a21                	addi	s4,s4,8
ffffffffc0201572:	9902                	jalr	s2
            break;
ffffffffc0201574:	b5f1                	j	ffffffffc0201440 <vprintfmt+0x3a>
    if (lflag >= 2) {
ffffffffc0201576:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc0201578:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
ffffffffc020157c:	01174463          	blt	a4,a7,ffffffffc0201584 <vprintfmt+0x17e>
    else if (lflag) {
ffffffffc0201580:	18088163          	beqz	a7,ffffffffc0201702 <vprintfmt+0x2fc>
        return va_arg(*ap, unsigned long);
ffffffffc0201584:	000a3603          	ld	a2,0(s4)
ffffffffc0201588:	46a9                	li	a3,10
ffffffffc020158a:	8a2e                	mv	s4,a1
ffffffffc020158c:	bfc1                	j	ffffffffc020155c <vprintfmt+0x156>
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc020158e:	00144603          	lbu	a2,1(s0)
            altflag = 1;
ffffffffc0201592:	4c85                	li	s9,1
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0201594:	846a                	mv	s0,s10
            goto reswitch;
ffffffffc0201596:	bdf1                	j	ffffffffc0201472 <vprintfmt+0x6c>
            putch(ch, putdat);
ffffffffc0201598:	85a6                	mv	a1,s1
ffffffffc020159a:	02500513          	li	a0,37
ffffffffc020159e:	9902                	jalr	s2
            break;
ffffffffc02015a0:	b545                	j	ffffffffc0201440 <vprintfmt+0x3a>
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc02015a2:	00144603          	lbu	a2,1(s0)
            lflag ++;
ffffffffc02015a6:	2885                	addiw	a7,a7,1
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc02015a8:	846a                	mv	s0,s10
            goto reswitch;
ffffffffc02015aa:	b5e1                	j	ffffffffc0201472 <vprintfmt+0x6c>
    if (lflag >= 2) {
ffffffffc02015ac:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc02015ae:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
ffffffffc02015b2:	01174463          	blt	a4,a7,ffffffffc02015ba <vprintfmt+0x1b4>
    else if (lflag) {
ffffffffc02015b6:	14088163          	beqz	a7,ffffffffc02016f8 <vprintfmt+0x2f2>
        return va_arg(*ap, unsigned long);
ffffffffc02015ba:	000a3603          	ld	a2,0(s4)
ffffffffc02015be:	46a1                	li	a3,8
ffffffffc02015c0:	8a2e                	mv	s4,a1
ffffffffc02015c2:	bf69                	j	ffffffffc020155c <vprintfmt+0x156>
            putch('0', putdat);
ffffffffc02015c4:	03000513          	li	a0,48
ffffffffc02015c8:	85a6                	mv	a1,s1
ffffffffc02015ca:	e03e                	sd	a5,0(sp)
ffffffffc02015cc:	9902                	jalr	s2
            putch('x', putdat);
ffffffffc02015ce:	85a6                	mv	a1,s1
ffffffffc02015d0:	07800513          	li	a0,120
ffffffffc02015d4:	9902                	jalr	s2
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
ffffffffc02015d6:	0a21                	addi	s4,s4,8
            goto number;
ffffffffc02015d8:	6782                	ld	a5,0(sp)
ffffffffc02015da:	46c1                	li	a3,16
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
ffffffffc02015dc:	ff8a3603          	ld	a2,-8(s4)
            goto number;
ffffffffc02015e0:	bfb5                	j	ffffffffc020155c <vprintfmt+0x156>
            if ((p = va_arg(ap, char *)) == NULL) {
ffffffffc02015e2:	000a3403          	ld	s0,0(s4)
ffffffffc02015e6:	008a0713          	addi	a4,s4,8
ffffffffc02015ea:	e03a                	sd	a4,0(sp)
ffffffffc02015ec:	14040263          	beqz	s0,ffffffffc0201730 <vprintfmt+0x32a>
            if (width > 0 && padc != '-') {
ffffffffc02015f0:	0fb05763          	blez	s11,ffffffffc02016de <vprintfmt+0x2d8>
ffffffffc02015f4:	02d00693          	li	a3,45
ffffffffc02015f8:	0cd79163          	bne	a5,a3,ffffffffc02016ba <vprintfmt+0x2b4>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc02015fc:	00044783          	lbu	a5,0(s0)
ffffffffc0201600:	0007851b          	sext.w	a0,a5
ffffffffc0201604:	cf85                	beqz	a5,ffffffffc020163c <vprintfmt+0x236>
ffffffffc0201606:	00140a13          	addi	s4,s0,1
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc020160a:	05e00413          	li	s0,94
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc020160e:	000c4563          	bltz	s8,ffffffffc0201618 <vprintfmt+0x212>
ffffffffc0201612:	3c7d                	addiw	s8,s8,-1
ffffffffc0201614:	036c0263          	beq	s8,s6,ffffffffc0201638 <vprintfmt+0x232>
                    putch('?', putdat);
ffffffffc0201618:	85a6                	mv	a1,s1
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc020161a:	0e0c8e63          	beqz	s9,ffffffffc0201716 <vprintfmt+0x310>
ffffffffc020161e:	3781                	addiw	a5,a5,-32
ffffffffc0201620:	0ef47b63          	bgeu	s0,a5,ffffffffc0201716 <vprintfmt+0x310>
                    putch('?', putdat);
ffffffffc0201624:	03f00513          	li	a0,63
ffffffffc0201628:	9902                	jalr	s2
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc020162a:	000a4783          	lbu	a5,0(s4)
ffffffffc020162e:	3dfd                	addiw	s11,s11,-1
ffffffffc0201630:	0a05                	addi	s4,s4,1
ffffffffc0201632:	0007851b          	sext.w	a0,a5
ffffffffc0201636:	ffe1                	bnez	a5,ffffffffc020160e <vprintfmt+0x208>
            for (; width > 0; width --) {
ffffffffc0201638:	01b05963          	blez	s11,ffffffffc020164a <vprintfmt+0x244>
ffffffffc020163c:	3dfd                	addiw	s11,s11,-1
                putch(' ', putdat);
ffffffffc020163e:	85a6                	mv	a1,s1
ffffffffc0201640:	02000513          	li	a0,32
ffffffffc0201644:	9902                	jalr	s2
            for (; width > 0; width --) {
ffffffffc0201646:	fe0d9be3          	bnez	s11,ffffffffc020163c <vprintfmt+0x236>
            if ((p = va_arg(ap, char *)) == NULL) {
ffffffffc020164a:	6a02                	ld	s4,0(sp)
ffffffffc020164c:	bbd5                	j	ffffffffc0201440 <vprintfmt+0x3a>
    if (lflag >= 2) {
ffffffffc020164e:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc0201650:	008a0c93          	addi	s9,s4,8
    if (lflag >= 2) {
ffffffffc0201654:	01174463          	blt	a4,a7,ffffffffc020165c <vprintfmt+0x256>
    else if (lflag) {
ffffffffc0201658:	08088d63          	beqz	a7,ffffffffc02016f2 <vprintfmt+0x2ec>
        return va_arg(*ap, long);
ffffffffc020165c:	000a3403          	ld	s0,0(s4)
            if ((long long)num < 0) {
ffffffffc0201660:	0a044d63          	bltz	s0,ffffffffc020171a <vprintfmt+0x314>
            num = getint(&ap, lflag);
ffffffffc0201664:	8622                	mv	a2,s0
ffffffffc0201666:	8a66                	mv	s4,s9
ffffffffc0201668:	46a9                	li	a3,10
ffffffffc020166a:	bdcd                	j	ffffffffc020155c <vprintfmt+0x156>
            err = va_arg(ap, int);
ffffffffc020166c:	000a2783          	lw	a5,0(s4)
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
ffffffffc0201670:	4719                	li	a4,6
            err = va_arg(ap, int);
ffffffffc0201672:	0a21                	addi	s4,s4,8
            if (err < 0) {
ffffffffc0201674:	41f7d69b          	sraiw	a3,a5,0x1f
ffffffffc0201678:	8fb5                	xor	a5,a5,a3
ffffffffc020167a:	40d786bb          	subw	a3,a5,a3
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
ffffffffc020167e:	02d74163          	blt	a4,a3,ffffffffc02016a0 <vprintfmt+0x29a>
ffffffffc0201682:	00369793          	slli	a5,a3,0x3
ffffffffc0201686:	97de                	add	a5,a5,s7
ffffffffc0201688:	639c                	ld	a5,0(a5)
ffffffffc020168a:	cb99                	beqz	a5,ffffffffc02016a0 <vprintfmt+0x29a>
                printfmt(putch, putdat, "%s", p);
ffffffffc020168c:	86be                	mv	a3,a5
ffffffffc020168e:	00001617          	auipc	a2,0x1
ffffffffc0201692:	d6a60613          	addi	a2,a2,-662 # ffffffffc02023f8 <buddy_system_pmm_manager+0x1b0>
ffffffffc0201696:	85a6                	mv	a1,s1
ffffffffc0201698:	854a                	mv	a0,s2
ffffffffc020169a:	0ce000ef          	jal	ra,ffffffffc0201768 <printfmt>
ffffffffc020169e:	b34d                	j	ffffffffc0201440 <vprintfmt+0x3a>
                printfmt(putch, putdat, "error %d", err);
ffffffffc02016a0:	00001617          	auipc	a2,0x1
ffffffffc02016a4:	d4860613          	addi	a2,a2,-696 # ffffffffc02023e8 <buddy_system_pmm_manager+0x1a0>
ffffffffc02016a8:	85a6                	mv	a1,s1
ffffffffc02016aa:	854a                	mv	a0,s2
ffffffffc02016ac:	0bc000ef          	jal	ra,ffffffffc0201768 <printfmt>
ffffffffc02016b0:	bb41                	j	ffffffffc0201440 <vprintfmt+0x3a>
                p = "(null)";
ffffffffc02016b2:	00001417          	auipc	s0,0x1
ffffffffc02016b6:	d2e40413          	addi	s0,s0,-722 # ffffffffc02023e0 <buddy_system_pmm_manager+0x198>
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc02016ba:	85e2                	mv	a1,s8
ffffffffc02016bc:	8522                	mv	a0,s0
ffffffffc02016be:	e43e                	sd	a5,8(sp)
ffffffffc02016c0:	c79ff0ef          	jal	ra,ffffffffc0201338 <strnlen>
ffffffffc02016c4:	40ad8dbb          	subw	s11,s11,a0
ffffffffc02016c8:	01b05b63          	blez	s11,ffffffffc02016de <vprintfmt+0x2d8>
                    putch(padc, putdat);
ffffffffc02016cc:	67a2                	ld	a5,8(sp)
ffffffffc02016ce:	00078a1b          	sext.w	s4,a5
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc02016d2:	3dfd                	addiw	s11,s11,-1
                    putch(padc, putdat);
ffffffffc02016d4:	85a6                	mv	a1,s1
ffffffffc02016d6:	8552                	mv	a0,s4
ffffffffc02016d8:	9902                	jalr	s2
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc02016da:	fe0d9ce3          	bnez	s11,ffffffffc02016d2 <vprintfmt+0x2cc>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc02016de:	00044783          	lbu	a5,0(s0)
ffffffffc02016e2:	00140a13          	addi	s4,s0,1
ffffffffc02016e6:	0007851b          	sext.w	a0,a5
ffffffffc02016ea:	d3a5                	beqz	a5,ffffffffc020164a <vprintfmt+0x244>
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc02016ec:	05e00413          	li	s0,94
ffffffffc02016f0:	bf39                	j	ffffffffc020160e <vprintfmt+0x208>
        return va_arg(*ap, int);
ffffffffc02016f2:	000a2403          	lw	s0,0(s4)
ffffffffc02016f6:	b7ad                	j	ffffffffc0201660 <vprintfmt+0x25a>
        return va_arg(*ap, unsigned int);
ffffffffc02016f8:	000a6603          	lwu	a2,0(s4)
ffffffffc02016fc:	46a1                	li	a3,8
ffffffffc02016fe:	8a2e                	mv	s4,a1
ffffffffc0201700:	bdb1                	j	ffffffffc020155c <vprintfmt+0x156>
ffffffffc0201702:	000a6603          	lwu	a2,0(s4)
ffffffffc0201706:	46a9                	li	a3,10
ffffffffc0201708:	8a2e                	mv	s4,a1
ffffffffc020170a:	bd89                	j	ffffffffc020155c <vprintfmt+0x156>
ffffffffc020170c:	000a6603          	lwu	a2,0(s4)
ffffffffc0201710:	46c1                	li	a3,16
ffffffffc0201712:	8a2e                	mv	s4,a1
ffffffffc0201714:	b5a1                	j	ffffffffc020155c <vprintfmt+0x156>
                    putch(ch, putdat);
ffffffffc0201716:	9902                	jalr	s2
ffffffffc0201718:	bf09                	j	ffffffffc020162a <vprintfmt+0x224>
                putch('-', putdat);
ffffffffc020171a:	85a6                	mv	a1,s1
ffffffffc020171c:	02d00513          	li	a0,45
ffffffffc0201720:	e03e                	sd	a5,0(sp)
ffffffffc0201722:	9902                	jalr	s2
                num = -(long long)num;
ffffffffc0201724:	6782                	ld	a5,0(sp)
ffffffffc0201726:	8a66                	mv	s4,s9
ffffffffc0201728:	40800633          	neg	a2,s0
ffffffffc020172c:	46a9                	li	a3,10
ffffffffc020172e:	b53d                	j	ffffffffc020155c <vprintfmt+0x156>
            if (width > 0 && padc != '-') {
ffffffffc0201730:	03b05163          	blez	s11,ffffffffc0201752 <vprintfmt+0x34c>
ffffffffc0201734:	02d00693          	li	a3,45
ffffffffc0201738:	f6d79de3          	bne	a5,a3,ffffffffc02016b2 <vprintfmt+0x2ac>
                p = "(null)";
ffffffffc020173c:	00001417          	auipc	s0,0x1
ffffffffc0201740:	ca440413          	addi	s0,s0,-860 # ffffffffc02023e0 <buddy_system_pmm_manager+0x198>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0201744:	02800793          	li	a5,40
ffffffffc0201748:	02800513          	li	a0,40
ffffffffc020174c:	00140a13          	addi	s4,s0,1
ffffffffc0201750:	bd6d                	j	ffffffffc020160a <vprintfmt+0x204>
ffffffffc0201752:	00001a17          	auipc	s4,0x1
ffffffffc0201756:	c8fa0a13          	addi	s4,s4,-881 # ffffffffc02023e1 <buddy_system_pmm_manager+0x199>
ffffffffc020175a:	02800513          	li	a0,40
ffffffffc020175e:	02800793          	li	a5,40
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc0201762:	05e00413          	li	s0,94
ffffffffc0201766:	b565                	j	ffffffffc020160e <vprintfmt+0x208>

ffffffffc0201768 <printfmt>:
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
ffffffffc0201768:	715d                	addi	sp,sp,-80
    va_start(ap, fmt);
ffffffffc020176a:	02810313          	addi	t1,sp,40
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
ffffffffc020176e:	f436                	sd	a3,40(sp)
    vprintfmt(putch, putdat, fmt, ap);
ffffffffc0201770:	869a                	mv	a3,t1
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
ffffffffc0201772:	ec06                	sd	ra,24(sp)
ffffffffc0201774:	f83a                	sd	a4,48(sp)
ffffffffc0201776:	fc3e                	sd	a5,56(sp)
ffffffffc0201778:	e0c2                	sd	a6,64(sp)
ffffffffc020177a:	e4c6                	sd	a7,72(sp)
    va_start(ap, fmt);
ffffffffc020177c:	e41a                	sd	t1,8(sp)
    vprintfmt(putch, putdat, fmt, ap);
ffffffffc020177e:	c89ff0ef          	jal	ra,ffffffffc0201406 <vprintfmt>
}
ffffffffc0201782:	60e2                	ld	ra,24(sp)
ffffffffc0201784:	6161                	addi	sp,sp,80
ffffffffc0201786:	8082                	ret

ffffffffc0201788 <sbi_console_putchar>:
uint64_t SBI_REMOTE_SFENCE_VMA_ASID = 7;
uint64_t SBI_SHUTDOWN = 8;

uint64_t sbi_call(uint64_t sbi_type, uint64_t arg0, uint64_t arg1, uint64_t arg2) {
    uint64_t ret_val;
    __asm__ volatile (
ffffffffc0201788:	4781                	li	a5,0
ffffffffc020178a:	00005717          	auipc	a4,0x5
ffffffffc020178e:	87e73703          	ld	a4,-1922(a4) # ffffffffc0206008 <SBI_CONSOLE_PUTCHAR>
ffffffffc0201792:	88ba                	mv	a7,a4
ffffffffc0201794:	852a                	mv	a0,a0
ffffffffc0201796:	85be                	mv	a1,a5
ffffffffc0201798:	863e                	mv	a2,a5
ffffffffc020179a:	00000073          	ecall
ffffffffc020179e:	87aa                	mv	a5,a0
    return ret_val;
}

void sbi_console_putchar(unsigned char ch) {
    sbi_call(SBI_CONSOLE_PUTCHAR, ch, 0, 0);
}
ffffffffc02017a0:	8082                	ret

ffffffffc02017a2 <sbi_set_timer>:
    __asm__ volatile (
ffffffffc02017a2:	4781                	li	a5,0
ffffffffc02017a4:	00005717          	auipc	a4,0x5
ffffffffc02017a8:	cd473703          	ld	a4,-812(a4) # ffffffffc0206478 <SBI_SET_TIMER>
ffffffffc02017ac:	88ba                	mv	a7,a4
ffffffffc02017ae:	852a                	mv	a0,a0
ffffffffc02017b0:	85be                	mv	a1,a5
ffffffffc02017b2:	863e                	mv	a2,a5
ffffffffc02017b4:	00000073          	ecall
ffffffffc02017b8:	87aa                	mv	a5,a0

void sbi_set_timer(unsigned long long stime_value) {
    sbi_call(SBI_SET_TIMER, stime_value, 0, 0);
}
ffffffffc02017ba:	8082                	ret

ffffffffc02017bc <sbi_console_getchar>:
    __asm__ volatile (
ffffffffc02017bc:	4501                	li	a0,0
ffffffffc02017be:	00005797          	auipc	a5,0x5
ffffffffc02017c2:	8427b783          	ld	a5,-1982(a5) # ffffffffc0206000 <SBI_CONSOLE_GETCHAR>
ffffffffc02017c6:	88be                	mv	a7,a5
ffffffffc02017c8:	852a                	mv	a0,a0
ffffffffc02017ca:	85aa                	mv	a1,a0
ffffffffc02017cc:	862a                	mv	a2,a0
ffffffffc02017ce:	00000073          	ecall
ffffffffc02017d2:	852a                	mv	a0,a0

int sbi_console_getchar(void) {
    return sbi_call(SBI_CONSOLE_GETCHAR, 0, 0, 0);
ffffffffc02017d4:	2501                	sext.w	a0,a0
ffffffffc02017d6:	8082                	ret

ffffffffc02017d8 <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
ffffffffc02017d8:	715d                	addi	sp,sp,-80
ffffffffc02017da:	e486                	sd	ra,72(sp)
ffffffffc02017dc:	e0a6                	sd	s1,64(sp)
ffffffffc02017de:	fc4a                	sd	s2,56(sp)
ffffffffc02017e0:	f84e                	sd	s3,48(sp)
ffffffffc02017e2:	f452                	sd	s4,40(sp)
ffffffffc02017e4:	f056                	sd	s5,32(sp)
ffffffffc02017e6:	ec5a                	sd	s6,24(sp)
ffffffffc02017e8:	e85e                	sd	s7,16(sp)
    if (prompt != NULL) {
ffffffffc02017ea:	c901                	beqz	a0,ffffffffc02017fa <readline+0x22>
ffffffffc02017ec:	85aa                	mv	a1,a0
        cprintf("%s", prompt);
ffffffffc02017ee:	00001517          	auipc	a0,0x1
ffffffffc02017f2:	c0a50513          	addi	a0,a0,-1014 # ffffffffc02023f8 <buddy_system_pmm_manager+0x1b0>
ffffffffc02017f6:	8bdfe0ef          	jal	ra,ffffffffc02000b2 <cprintf>
readline(const char *prompt) {
ffffffffc02017fa:	4481                	li	s1,0
    while (1) {
        c = getchar();
        if (c < 0) {
            return NULL;
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
ffffffffc02017fc:	497d                	li	s2,31
            cputchar(c);
            buf[i ++] = c;
        }
        else if (c == '\b' && i > 0) {
ffffffffc02017fe:	49a1                	li	s3,8
            cputchar(c);
            i --;
        }
        else if (c == '\n' || c == '\r') {
ffffffffc0201800:	4aa9                	li	s5,10
ffffffffc0201802:	4b35                	li	s6,13
            buf[i ++] = c;
ffffffffc0201804:	00005b97          	auipc	s7,0x5
ffffffffc0201808:	824b8b93          	addi	s7,s7,-2012 # ffffffffc0206028 <buf>
        else if (c >= ' ' && i < BUFSIZE - 1) {
ffffffffc020180c:	3fe00a13          	li	s4,1022
        c = getchar();
ffffffffc0201810:	91bfe0ef          	jal	ra,ffffffffc020012a <getchar>
        if (c < 0) {
ffffffffc0201814:	00054a63          	bltz	a0,ffffffffc0201828 <readline+0x50>
        else if (c >= ' ' && i < BUFSIZE - 1) {
ffffffffc0201818:	00a95a63          	bge	s2,a0,ffffffffc020182c <readline+0x54>
ffffffffc020181c:	029a5263          	bge	s4,s1,ffffffffc0201840 <readline+0x68>
        c = getchar();
ffffffffc0201820:	90bfe0ef          	jal	ra,ffffffffc020012a <getchar>
        if (c < 0) {
ffffffffc0201824:	fe055ae3          	bgez	a0,ffffffffc0201818 <readline+0x40>
            return NULL;
ffffffffc0201828:	4501                	li	a0,0
ffffffffc020182a:	a091                	j	ffffffffc020186e <readline+0x96>
        else if (c == '\b' && i > 0) {
ffffffffc020182c:	03351463          	bne	a0,s3,ffffffffc0201854 <readline+0x7c>
ffffffffc0201830:	e8a9                	bnez	s1,ffffffffc0201882 <readline+0xaa>
        c = getchar();
ffffffffc0201832:	8f9fe0ef          	jal	ra,ffffffffc020012a <getchar>
        if (c < 0) {
ffffffffc0201836:	fe0549e3          	bltz	a0,ffffffffc0201828 <readline+0x50>
        else if (c >= ' ' && i < BUFSIZE - 1) {
ffffffffc020183a:	fea959e3          	bge	s2,a0,ffffffffc020182c <readline+0x54>
ffffffffc020183e:	4481                	li	s1,0
            cputchar(c);
ffffffffc0201840:	e42a                	sd	a0,8(sp)
ffffffffc0201842:	8a7fe0ef          	jal	ra,ffffffffc02000e8 <cputchar>
            buf[i ++] = c;
ffffffffc0201846:	6522                	ld	a0,8(sp)
ffffffffc0201848:	009b87b3          	add	a5,s7,s1
ffffffffc020184c:	2485                	addiw	s1,s1,1
ffffffffc020184e:	00a78023          	sb	a0,0(a5)
ffffffffc0201852:	bf7d                	j	ffffffffc0201810 <readline+0x38>
        else if (c == '\n' || c == '\r') {
ffffffffc0201854:	01550463          	beq	a0,s5,ffffffffc020185c <readline+0x84>
ffffffffc0201858:	fb651ce3          	bne	a0,s6,ffffffffc0201810 <readline+0x38>
            cputchar(c);
ffffffffc020185c:	88dfe0ef          	jal	ra,ffffffffc02000e8 <cputchar>
            buf[i] = '\0';
ffffffffc0201860:	00004517          	auipc	a0,0x4
ffffffffc0201864:	7c850513          	addi	a0,a0,1992 # ffffffffc0206028 <buf>
ffffffffc0201868:	94aa                	add	s1,s1,a0
ffffffffc020186a:	00048023          	sb	zero,0(s1)
            return buf;
        }
    }
}
ffffffffc020186e:	60a6                	ld	ra,72(sp)
ffffffffc0201870:	6486                	ld	s1,64(sp)
ffffffffc0201872:	7962                	ld	s2,56(sp)
ffffffffc0201874:	79c2                	ld	s3,48(sp)
ffffffffc0201876:	7a22                	ld	s4,40(sp)
ffffffffc0201878:	7a82                	ld	s5,32(sp)
ffffffffc020187a:	6b62                	ld	s6,24(sp)
ffffffffc020187c:	6bc2                	ld	s7,16(sp)
ffffffffc020187e:	6161                	addi	sp,sp,80
ffffffffc0201880:	8082                	ret
            cputchar(c);
ffffffffc0201882:	4521                	li	a0,8
ffffffffc0201884:	865fe0ef          	jal	ra,ffffffffc02000e8 <cputchar>
            i --;
ffffffffc0201888:	34fd                	addiw	s1,s1,-1
ffffffffc020188a:	b759                	j	ffffffffc0201810 <readline+0x38>
