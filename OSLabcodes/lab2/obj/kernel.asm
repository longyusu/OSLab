
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
ffffffffc020004a:	37a010ef          	jal	ra,ffffffffc02013c4 <memset>
    cons_init();  // init the console
ffffffffc020004e:	3fc000ef          	jal	ra,ffffffffc020044a <cons_init>
    const char *message = "(THU.CST) os is loading ...\0";
    //cprintf("%s\n\n", message);
    cputs(message);
ffffffffc0200052:	00002517          	auipc	a0,0x2
ffffffffc0200056:	87650513          	addi	a0,a0,-1930 # ffffffffc02018c8 <etext>
ffffffffc020005a:	090000ef          	jal	ra,ffffffffc02000ea <cputs>

    print_kerninfo();
ffffffffc020005e:	138000ef          	jal	ra,ffffffffc0200196 <print_kerninfo>

    // grade_backtrace();
    idt_init();  // init interrupt descriptor table
ffffffffc0200062:	402000ef          	jal	ra,ffffffffc0200464 <idt_init>

    pmm_init();  // init physical memory management
ffffffffc0200066:	162010ef          	jal	ra,ffffffffc02011c8 <pmm_init>

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
ffffffffc02000a6:	39c010ef          	jal	ra,ffffffffc0201442 <vprintfmt>
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
ffffffffc02000dc:	366010ef          	jal	ra,ffffffffc0201442 <vprintfmt>
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
ffffffffc020016c:	78050513          	addi	a0,a0,1920 # ffffffffc02018e8 <etext+0x20>
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
ffffffffc0200182:	85250513          	addi	a0,a0,-1966 # ffffffffc02019d0 <etext+0x108>
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
ffffffffc020019c:	77050513          	addi	a0,a0,1904 # ffffffffc0201908 <etext+0x40>
void print_kerninfo(void) {
ffffffffc02001a0:	e406                	sd	ra,8(sp)
    cprintf("Special kernel symbols:\n");
ffffffffc02001a2:	f11ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    cprintf("  entry  0x%016lx (virtual)\n", kern_init);
ffffffffc02001a6:	00000597          	auipc	a1,0x0
ffffffffc02001aa:	e8c58593          	addi	a1,a1,-372 # ffffffffc0200032 <kern_init>
ffffffffc02001ae:	00001517          	auipc	a0,0x1
ffffffffc02001b2:	77a50513          	addi	a0,a0,1914 # ffffffffc0201928 <etext+0x60>
ffffffffc02001b6:	efdff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    cprintf("  etext  0x%016lx (virtual)\n", etext);
ffffffffc02001ba:	00001597          	auipc	a1,0x1
ffffffffc02001be:	70e58593          	addi	a1,a1,1806 # ffffffffc02018c8 <etext>
ffffffffc02001c2:	00001517          	auipc	a0,0x1
ffffffffc02001c6:	78650513          	addi	a0,a0,1926 # ffffffffc0201948 <etext+0x80>
ffffffffc02001ca:	ee9ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    cprintf("  edata  0x%016lx (virtual)\n", edata);
ffffffffc02001ce:	00006597          	auipc	a1,0x6
ffffffffc02001d2:	e4258593          	addi	a1,a1,-446 # ffffffffc0206010 <bsfree_area>
ffffffffc02001d6:	00001517          	auipc	a0,0x1
ffffffffc02001da:	79250513          	addi	a0,a0,1938 # ffffffffc0201968 <etext+0xa0>
ffffffffc02001de:	ed5ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    cprintf("  end    0x%016lx (virtual)\n", end);
ffffffffc02001e2:	00006597          	auipc	a1,0x6
ffffffffc02001e6:	29e58593          	addi	a1,a1,670 # ffffffffc0206480 <end>
ffffffffc02001ea:	00001517          	auipc	a0,0x1
ffffffffc02001ee:	79e50513          	addi	a0,a0,1950 # ffffffffc0201988 <etext+0xc0>
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
ffffffffc020021c:	79050513          	addi	a0,a0,1936 # ffffffffc02019a8 <etext+0xe0>
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
ffffffffc020022a:	7b260613          	addi	a2,a2,1970 # ffffffffc02019d8 <etext+0x110>
ffffffffc020022e:	04e00593          	li	a1,78
ffffffffc0200232:	00001517          	auipc	a0,0x1
ffffffffc0200236:	7be50513          	addi	a0,a0,1982 # ffffffffc02019f0 <etext+0x128>
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
ffffffffc0200246:	7c660613          	addi	a2,a2,1990 # ffffffffc0201a08 <etext+0x140>
ffffffffc020024a:	00001597          	auipc	a1,0x1
ffffffffc020024e:	7de58593          	addi	a1,a1,2014 # ffffffffc0201a28 <etext+0x160>
ffffffffc0200252:	00001517          	auipc	a0,0x1
ffffffffc0200256:	7de50513          	addi	a0,a0,2014 # ffffffffc0201a30 <etext+0x168>
mon_help(int argc, char **argv, struct trapframe *tf) {
ffffffffc020025a:	e406                	sd	ra,8(sp)
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
ffffffffc020025c:	e57ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc0200260:	00001617          	auipc	a2,0x1
ffffffffc0200264:	7e060613          	addi	a2,a2,2016 # ffffffffc0201a40 <etext+0x178>
ffffffffc0200268:	00002597          	auipc	a1,0x2
ffffffffc020026c:	80058593          	addi	a1,a1,-2048 # ffffffffc0201a68 <etext+0x1a0>
ffffffffc0200270:	00001517          	auipc	a0,0x1
ffffffffc0200274:	7c050513          	addi	a0,a0,1984 # ffffffffc0201a30 <etext+0x168>
ffffffffc0200278:	e3bff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc020027c:	00001617          	auipc	a2,0x1
ffffffffc0200280:	7fc60613          	addi	a2,a2,2044 # ffffffffc0201a78 <etext+0x1b0>
ffffffffc0200284:	00002597          	auipc	a1,0x2
ffffffffc0200288:	81458593          	addi	a1,a1,-2028 # ffffffffc0201a98 <etext+0x1d0>
ffffffffc020028c:	00001517          	auipc	a0,0x1
ffffffffc0200290:	7a450513          	addi	a0,a0,1956 # ffffffffc0201a30 <etext+0x168>
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
ffffffffc02002ca:	7e250513          	addi	a0,a0,2018 # ffffffffc0201aa8 <etext+0x1e0>
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
ffffffffc02002ec:	7e850513          	addi	a0,a0,2024 # ffffffffc0201ad0 <etext+0x208>
ffffffffc02002f0:	dc3ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    if (tf != NULL) {
ffffffffc02002f4:	000b8563          	beqz	s7,ffffffffc02002fe <kmonitor+0x3e>
        print_trapframe(tf);
ffffffffc02002f8:	855e                	mv	a0,s7
ffffffffc02002fa:	348000ef          	jal	ra,ffffffffc0200642 <print_trapframe>
ffffffffc02002fe:	00002c17          	auipc	s8,0x2
ffffffffc0200302:	842c0c13          	addi	s8,s8,-1982 # ffffffffc0201b40 <commands>
        if ((buf = readline("K> ")) != NULL) {
ffffffffc0200306:	00001917          	auipc	s2,0x1
ffffffffc020030a:	7f290913          	addi	s2,s2,2034 # ffffffffc0201af8 <etext+0x230>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
ffffffffc020030e:	00001497          	auipc	s1,0x1
ffffffffc0200312:	7f248493          	addi	s1,s1,2034 # ffffffffc0201b00 <etext+0x238>
        if (argc == MAXARGS - 1) {
ffffffffc0200316:	49bd                	li	s3,15
            cprintf("Too many arguments (max %d).\n", MAXARGS);
ffffffffc0200318:	00001b17          	auipc	s6,0x1
ffffffffc020031c:	7f0b0b13          	addi	s6,s6,2032 # ffffffffc0201b08 <etext+0x240>
        argv[argc ++] = buf;
ffffffffc0200320:	00001a17          	auipc	s4,0x1
ffffffffc0200324:	708a0a13          	addi	s4,s4,1800 # ffffffffc0201a28 <etext+0x160>
    for (i = 0; i < NCOMMANDS; i ++) {
ffffffffc0200328:	4a8d                	li	s5,3
        if ((buf = readline("K> ")) != NULL) {
ffffffffc020032a:	854a                	mv	a0,s2
ffffffffc020032c:	4e8010ef          	jal	ra,ffffffffc0201814 <readline>
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
ffffffffc0200346:	7fed0d13          	addi	s10,s10,2046 # ffffffffc0201b40 <commands>
        argv[argc ++] = buf;
ffffffffc020034a:	8552                	mv	a0,s4
    for (i = 0; i < NCOMMANDS; i ++) {
ffffffffc020034c:	4401                	li	s0,0
ffffffffc020034e:	0d61                	addi	s10,s10,24
        if (strcmp(commands[i].name, argv[0]) == 0) {
ffffffffc0200350:	040010ef          	jal	ra,ffffffffc0201390 <strcmp>
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
ffffffffc0200364:	02c010ef          	jal	ra,ffffffffc0201390 <strcmp>
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
ffffffffc02003a2:	00c010ef          	jal	ra,ffffffffc02013ae <strchr>
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
ffffffffc02003e0:	7cf000ef          	jal	ra,ffffffffc02013ae <strchr>
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
ffffffffc02003fe:	72e50513          	addi	a0,a0,1838 # ffffffffc0201b28 <etext+0x260>
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
ffffffffc0200420:	3be010ef          	jal	ra,ffffffffc02017de <sbi_set_timer>
}
ffffffffc0200424:	60a2                	ld	ra,8(sp)
    ticks = 0;
ffffffffc0200426:	00006797          	auipc	a5,0x6
ffffffffc020042a:	0007b523          	sd	zero,10(a5) # ffffffffc0206430 <ticks>
    cprintf("++ setup timer interrupts\n");
ffffffffc020042e:	00001517          	auipc	a0,0x1
ffffffffc0200432:	75a50513          	addi	a0,a0,1882 # ffffffffc0201b88 <commands+0x48>
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
ffffffffc0200446:	3980106f          	j	ffffffffc02017de <sbi_set_timer>

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
ffffffffc0200450:	3740106f          	j	ffffffffc02017c4 <sbi_console_putchar>

ffffffffc0200454 <cons_getc>:
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int cons_getc(void) {
    int c = 0;
    c = sbi_console_getchar();
ffffffffc0200454:	3a40106f          	j	ffffffffc02017f8 <sbi_console_getchar>

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
ffffffffc0200482:	72a50513          	addi	a0,a0,1834 # ffffffffc0201ba8 <commands+0x68>
void print_regs(struct pushregs *gpr) {
ffffffffc0200486:	e406                	sd	ra,8(sp)
    cprintf("  zero     0x%08x\n", gpr->zero);
ffffffffc0200488:	c2bff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    cprintf("  ra       0x%08x\n", gpr->ra);
ffffffffc020048c:	640c                	ld	a1,8(s0)
ffffffffc020048e:	00001517          	auipc	a0,0x1
ffffffffc0200492:	73250513          	addi	a0,a0,1842 # ffffffffc0201bc0 <commands+0x80>
ffffffffc0200496:	c1dff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    cprintf("  sp       0x%08x\n", gpr->sp);
ffffffffc020049a:	680c                	ld	a1,16(s0)
ffffffffc020049c:	00001517          	auipc	a0,0x1
ffffffffc02004a0:	73c50513          	addi	a0,a0,1852 # ffffffffc0201bd8 <commands+0x98>
ffffffffc02004a4:	c0fff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    cprintf("  gp       0x%08x\n", gpr->gp);
ffffffffc02004a8:	6c0c                	ld	a1,24(s0)
ffffffffc02004aa:	00001517          	auipc	a0,0x1
ffffffffc02004ae:	74650513          	addi	a0,a0,1862 # ffffffffc0201bf0 <commands+0xb0>
ffffffffc02004b2:	c01ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    cprintf("  tp       0x%08x\n", gpr->tp);
ffffffffc02004b6:	700c                	ld	a1,32(s0)
ffffffffc02004b8:	00001517          	auipc	a0,0x1
ffffffffc02004bc:	75050513          	addi	a0,a0,1872 # ffffffffc0201c08 <commands+0xc8>
ffffffffc02004c0:	bf3ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    cprintf("  t0       0x%08x\n", gpr->t0);
ffffffffc02004c4:	740c                	ld	a1,40(s0)
ffffffffc02004c6:	00001517          	auipc	a0,0x1
ffffffffc02004ca:	75a50513          	addi	a0,a0,1882 # ffffffffc0201c20 <commands+0xe0>
ffffffffc02004ce:	be5ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    cprintf("  t1       0x%08x\n", gpr->t1);
ffffffffc02004d2:	780c                	ld	a1,48(s0)
ffffffffc02004d4:	00001517          	auipc	a0,0x1
ffffffffc02004d8:	76450513          	addi	a0,a0,1892 # ffffffffc0201c38 <commands+0xf8>
ffffffffc02004dc:	bd7ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    cprintf("  t2       0x%08x\n", gpr->t2);
ffffffffc02004e0:	7c0c                	ld	a1,56(s0)
ffffffffc02004e2:	00001517          	auipc	a0,0x1
ffffffffc02004e6:	76e50513          	addi	a0,a0,1902 # ffffffffc0201c50 <commands+0x110>
ffffffffc02004ea:	bc9ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    cprintf("  s0       0x%08x\n", gpr->s0);
ffffffffc02004ee:	602c                	ld	a1,64(s0)
ffffffffc02004f0:	00001517          	auipc	a0,0x1
ffffffffc02004f4:	77850513          	addi	a0,a0,1912 # ffffffffc0201c68 <commands+0x128>
ffffffffc02004f8:	bbbff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    cprintf("  s1       0x%08x\n", gpr->s1);
ffffffffc02004fc:	642c                	ld	a1,72(s0)
ffffffffc02004fe:	00001517          	auipc	a0,0x1
ffffffffc0200502:	78250513          	addi	a0,a0,1922 # ffffffffc0201c80 <commands+0x140>
ffffffffc0200506:	badff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    cprintf("  a0       0x%08x\n", gpr->a0);
ffffffffc020050a:	682c                	ld	a1,80(s0)
ffffffffc020050c:	00001517          	auipc	a0,0x1
ffffffffc0200510:	78c50513          	addi	a0,a0,1932 # ffffffffc0201c98 <commands+0x158>
ffffffffc0200514:	b9fff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    cprintf("  a1       0x%08x\n", gpr->a1);
ffffffffc0200518:	6c2c                	ld	a1,88(s0)
ffffffffc020051a:	00001517          	auipc	a0,0x1
ffffffffc020051e:	79650513          	addi	a0,a0,1942 # ffffffffc0201cb0 <commands+0x170>
ffffffffc0200522:	b91ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    cprintf("  a2       0x%08x\n", gpr->a2);
ffffffffc0200526:	702c                	ld	a1,96(s0)
ffffffffc0200528:	00001517          	auipc	a0,0x1
ffffffffc020052c:	7a050513          	addi	a0,a0,1952 # ffffffffc0201cc8 <commands+0x188>
ffffffffc0200530:	b83ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    cprintf("  a3       0x%08x\n", gpr->a3);
ffffffffc0200534:	742c                	ld	a1,104(s0)
ffffffffc0200536:	00001517          	auipc	a0,0x1
ffffffffc020053a:	7aa50513          	addi	a0,a0,1962 # ffffffffc0201ce0 <commands+0x1a0>
ffffffffc020053e:	b75ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    cprintf("  a4       0x%08x\n", gpr->a4);
ffffffffc0200542:	782c                	ld	a1,112(s0)
ffffffffc0200544:	00001517          	auipc	a0,0x1
ffffffffc0200548:	7b450513          	addi	a0,a0,1972 # ffffffffc0201cf8 <commands+0x1b8>
ffffffffc020054c:	b67ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    cprintf("  a5       0x%08x\n", gpr->a5);
ffffffffc0200550:	7c2c                	ld	a1,120(s0)
ffffffffc0200552:	00001517          	auipc	a0,0x1
ffffffffc0200556:	7be50513          	addi	a0,a0,1982 # ffffffffc0201d10 <commands+0x1d0>
ffffffffc020055a:	b59ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    cprintf("  a6       0x%08x\n", gpr->a6);
ffffffffc020055e:	604c                	ld	a1,128(s0)
ffffffffc0200560:	00001517          	auipc	a0,0x1
ffffffffc0200564:	7c850513          	addi	a0,a0,1992 # ffffffffc0201d28 <commands+0x1e8>
ffffffffc0200568:	b4bff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    cprintf("  a7       0x%08x\n", gpr->a7);
ffffffffc020056c:	644c                	ld	a1,136(s0)
ffffffffc020056e:	00001517          	auipc	a0,0x1
ffffffffc0200572:	7d250513          	addi	a0,a0,2002 # ffffffffc0201d40 <commands+0x200>
ffffffffc0200576:	b3dff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    cprintf("  s2       0x%08x\n", gpr->s2);
ffffffffc020057a:	684c                	ld	a1,144(s0)
ffffffffc020057c:	00001517          	auipc	a0,0x1
ffffffffc0200580:	7dc50513          	addi	a0,a0,2012 # ffffffffc0201d58 <commands+0x218>
ffffffffc0200584:	b2fff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    cprintf("  s3       0x%08x\n", gpr->s3);
ffffffffc0200588:	6c4c                	ld	a1,152(s0)
ffffffffc020058a:	00001517          	auipc	a0,0x1
ffffffffc020058e:	7e650513          	addi	a0,a0,2022 # ffffffffc0201d70 <commands+0x230>
ffffffffc0200592:	b21ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    cprintf("  s4       0x%08x\n", gpr->s4);
ffffffffc0200596:	704c                	ld	a1,160(s0)
ffffffffc0200598:	00001517          	auipc	a0,0x1
ffffffffc020059c:	7f050513          	addi	a0,a0,2032 # ffffffffc0201d88 <commands+0x248>
ffffffffc02005a0:	b13ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    cprintf("  s5       0x%08x\n", gpr->s5);
ffffffffc02005a4:	744c                	ld	a1,168(s0)
ffffffffc02005a6:	00001517          	auipc	a0,0x1
ffffffffc02005aa:	7fa50513          	addi	a0,a0,2042 # ffffffffc0201da0 <commands+0x260>
ffffffffc02005ae:	b05ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    cprintf("  s6       0x%08x\n", gpr->s6);
ffffffffc02005b2:	784c                	ld	a1,176(s0)
ffffffffc02005b4:	00002517          	auipc	a0,0x2
ffffffffc02005b8:	80450513          	addi	a0,a0,-2044 # ffffffffc0201db8 <commands+0x278>
ffffffffc02005bc:	af7ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    cprintf("  s7       0x%08x\n", gpr->s7);
ffffffffc02005c0:	7c4c                	ld	a1,184(s0)
ffffffffc02005c2:	00002517          	auipc	a0,0x2
ffffffffc02005c6:	80e50513          	addi	a0,a0,-2034 # ffffffffc0201dd0 <commands+0x290>
ffffffffc02005ca:	ae9ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    cprintf("  s8       0x%08x\n", gpr->s8);
ffffffffc02005ce:	606c                	ld	a1,192(s0)
ffffffffc02005d0:	00002517          	auipc	a0,0x2
ffffffffc02005d4:	81850513          	addi	a0,a0,-2024 # ffffffffc0201de8 <commands+0x2a8>
ffffffffc02005d8:	adbff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    cprintf("  s9       0x%08x\n", gpr->s9);
ffffffffc02005dc:	646c                	ld	a1,200(s0)
ffffffffc02005de:	00002517          	auipc	a0,0x2
ffffffffc02005e2:	82250513          	addi	a0,a0,-2014 # ffffffffc0201e00 <commands+0x2c0>
ffffffffc02005e6:	acdff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    cprintf("  s10      0x%08x\n", gpr->s10);
ffffffffc02005ea:	686c                	ld	a1,208(s0)
ffffffffc02005ec:	00002517          	auipc	a0,0x2
ffffffffc02005f0:	82c50513          	addi	a0,a0,-2004 # ffffffffc0201e18 <commands+0x2d8>
ffffffffc02005f4:	abfff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    cprintf("  s11      0x%08x\n", gpr->s11);
ffffffffc02005f8:	6c6c                	ld	a1,216(s0)
ffffffffc02005fa:	00002517          	auipc	a0,0x2
ffffffffc02005fe:	83650513          	addi	a0,a0,-1994 # ffffffffc0201e30 <commands+0x2f0>
ffffffffc0200602:	ab1ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    cprintf("  t3       0x%08x\n", gpr->t3);
ffffffffc0200606:	706c                	ld	a1,224(s0)
ffffffffc0200608:	00002517          	auipc	a0,0x2
ffffffffc020060c:	84050513          	addi	a0,a0,-1984 # ffffffffc0201e48 <commands+0x308>
ffffffffc0200610:	aa3ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    cprintf("  t4       0x%08x\n", gpr->t4);
ffffffffc0200614:	746c                	ld	a1,232(s0)
ffffffffc0200616:	00002517          	auipc	a0,0x2
ffffffffc020061a:	84a50513          	addi	a0,a0,-1974 # ffffffffc0201e60 <commands+0x320>
ffffffffc020061e:	a95ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    cprintf("  t5       0x%08x\n", gpr->t5);
ffffffffc0200622:	786c                	ld	a1,240(s0)
ffffffffc0200624:	00002517          	auipc	a0,0x2
ffffffffc0200628:	85450513          	addi	a0,a0,-1964 # ffffffffc0201e78 <commands+0x338>
ffffffffc020062c:	a87ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    cprintf("  t6       0x%08x\n", gpr->t6);
ffffffffc0200630:	7c6c                	ld	a1,248(s0)
}
ffffffffc0200632:	6402                	ld	s0,0(sp)
ffffffffc0200634:	60a2                	ld	ra,8(sp)
    cprintf("  t6       0x%08x\n", gpr->t6);
ffffffffc0200636:	00002517          	auipc	a0,0x2
ffffffffc020063a:	85a50513          	addi	a0,a0,-1958 # ffffffffc0201e90 <commands+0x350>
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
ffffffffc020064e:	85e50513          	addi	a0,a0,-1954 # ffffffffc0201ea8 <commands+0x368>
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
ffffffffc0200666:	85e50513          	addi	a0,a0,-1954 # ffffffffc0201ec0 <commands+0x380>
ffffffffc020066a:	a49ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    cprintf("  epc      0x%08x\n", tf->epc);
ffffffffc020066e:	10843583          	ld	a1,264(s0)
ffffffffc0200672:	00002517          	auipc	a0,0x2
ffffffffc0200676:	86650513          	addi	a0,a0,-1946 # ffffffffc0201ed8 <commands+0x398>
ffffffffc020067a:	a39ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    cprintf("  badvaddr 0x%08x\n", tf->badvaddr);
ffffffffc020067e:	11043583          	ld	a1,272(s0)
ffffffffc0200682:	00002517          	auipc	a0,0x2
ffffffffc0200686:	86e50513          	addi	a0,a0,-1938 # ffffffffc0201ef0 <commands+0x3b0>
ffffffffc020068a:	a29ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    cprintf("  cause    0x%08x\n", tf->cause);
ffffffffc020068e:	11843583          	ld	a1,280(s0)
}
ffffffffc0200692:	6402                	ld	s0,0(sp)
ffffffffc0200694:	60a2                	ld	ra,8(sp)
    cprintf("  cause    0x%08x\n", tf->cause);
ffffffffc0200696:	00002517          	auipc	a0,0x2
ffffffffc020069a:	87250513          	addi	a0,a0,-1934 # ffffffffc0201f08 <commands+0x3c8>
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
ffffffffc02006b4:	93870713          	addi	a4,a4,-1736 # ffffffffc0201fe8 <commands+0x4a8>
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
ffffffffc02006c6:	8be50513          	addi	a0,a0,-1858 # ffffffffc0201f80 <commands+0x440>
ffffffffc02006ca:	b2e5                	j	ffffffffc02000b2 <cprintf>
            cprintf("Hypervisor software interrupt\n");
ffffffffc02006cc:	00002517          	auipc	a0,0x2
ffffffffc02006d0:	89450513          	addi	a0,a0,-1900 # ffffffffc0201f60 <commands+0x420>
ffffffffc02006d4:	baf9                	j	ffffffffc02000b2 <cprintf>
            cprintf("User software interrupt\n");
ffffffffc02006d6:	00002517          	auipc	a0,0x2
ffffffffc02006da:	84a50513          	addi	a0,a0,-1974 # ffffffffc0201f20 <commands+0x3e0>
ffffffffc02006de:	bad1                	j	ffffffffc02000b2 <cprintf>
            break;
        case IRQ_U_TIMER:
            cprintf("User Timer interrupt\n");
ffffffffc02006e0:	00002517          	auipc	a0,0x2
ffffffffc02006e4:	8c050513          	addi	a0,a0,-1856 # ffffffffc0201fa0 <commands+0x460>
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
ffffffffc0200714:	8b850513          	addi	a0,a0,-1864 # ffffffffc0201fc8 <commands+0x488>
ffffffffc0200718:	ba69                	j	ffffffffc02000b2 <cprintf>
            cprintf("Supervisor software interrupt\n");
ffffffffc020071a:	00002517          	auipc	a0,0x2
ffffffffc020071e:	82650513          	addi	a0,a0,-2010 # ffffffffc0201f40 <commands+0x400>
ffffffffc0200722:	ba41                	j	ffffffffc02000b2 <cprintf>
            print_trapframe(tf);
ffffffffc0200724:	bf39                	j	ffffffffc0200642 <print_trapframe>
}
ffffffffc0200726:	60a2                	ld	ra,8(sp)
    cprintf("%d ticks\n", TICK_NUM);
ffffffffc0200728:	06400593          	li	a1,100
ffffffffc020072c:	00002517          	auipc	a0,0x2
ffffffffc0200730:	88c50513          	addi	a0,a0,-1908 # ffffffffc0201fb8 <commands+0x478>
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
ffffffffc0200820:	e84a                	sd	s2,16(sp)
ffffffffc0200822:	f406                	sd	ra,40(sp)
ffffffffc0200824:	f022                	sd	s0,32(sp)
ffffffffc0200826:	ec26                	sd	s1,24(sp)
ffffffffc0200828:	e44e                	sd	s3,8(sp)
    int all_pages = nr_free_pages();
ffffffffc020082a:	165000ef          	jal	ra,ffffffffc020118e <nr_free_pages>
ffffffffc020082e:	892a                	mv	s2,a0
    struct Page* p0, *p1, *p2, *p3;
    // 分配过大的页数
    assert(alloc_pages(all_pages + 1) == NULL);
ffffffffc0200830:	2505                	addiw	a0,a0,1
ffffffffc0200832:	0df000ef          	jal	ra,ffffffffc0201110 <alloc_pages>
ffffffffc0200836:	18051163          	bnez	a0,ffffffffc02009b8 <buddy_system_check+0x19a>
    // 分配两个组页
    p0 = alloc_pages(1);
ffffffffc020083a:	4505                	li	a0,1
ffffffffc020083c:	0d5000ef          	jal	ra,ffffffffc0201110 <alloc_pages>
ffffffffc0200840:	84aa                	mv	s1,a0
    assert(p0 != NULL);
ffffffffc0200842:	14050b63          	beqz	a0,ffffffffc0200998 <buddy_system_check+0x17a>
    p1 = alloc_pages(all_pages/2);
ffffffffc0200846:	2901                	sext.w	s2,s2
ffffffffc0200848:	01f9541b          	srliw	s0,s2,0x1f
ffffffffc020084c:	0124043b          	addw	s0,s0,s2
ffffffffc0200850:	4014541b          	sraiw	s0,s0,0x1
ffffffffc0200854:	8522                	mv	a0,s0
ffffffffc0200856:	0bb000ef          	jal	ra,ffffffffc0201110 <alloc_pages>
    assert(p1 != NULL);
ffffffffc020085a:	10050f63          	beqz	a0,ffffffffc0200978 <buddy_system_check+0x15a>
    free_pages(p1, all_pages/2);
ffffffffc020085e:	85a2                	mv	a1,s0
ffffffffc0200860:	0ef000ef          	jal	ra,ffffffffc020114e <free_pages>
    p1 = alloc_pages(2);
ffffffffc0200864:	4509                	li	a0,2
ffffffffc0200866:	0ab000ef          	jal	ra,ffffffffc0201110 <alloc_pages>
 * test_bit - Determine whether a bit is set
 * @nr:     the bit to test
 * @addr:   the address to count from
 * */
static inline bool test_bit(int nr, volatile void *addr) {
    return (((*(volatile unsigned long *)addr) >> nr) & 1);
ffffffffc020086a:	649c                	ld	a5,8(s1)
ffffffffc020086c:	842a                	mv	s0,a0
    //free_pages(p1, 2);
    //assert(p1 == p0 + 2);
    assert(!PageReserved(p0) && !PageProperty(p0));
ffffffffc020086e:	8b85                	andi	a5,a5,1
ffffffffc0200870:	0e079463          	bnez	a5,ffffffffc0200958 <buddy_system_check+0x13a>
ffffffffc0200874:	649c                	ld	a5,8(s1)
ffffffffc0200876:	8385                	srli	a5,a5,0x1
ffffffffc0200878:	8b85                	andi	a5,a5,1
ffffffffc020087a:	0c079f63          	bnez	a5,ffffffffc0200958 <buddy_system_check+0x13a>
ffffffffc020087e:	651c                	ld	a5,8(a0)
    assert(!PageReserved(p1) && !PageProperty(p1));
ffffffffc0200880:	8b85                	andi	a5,a5,1
ffffffffc0200882:	ebdd                	bnez	a5,ffffffffc0200938 <buddy_system_check+0x11a>
ffffffffc0200884:	651c                	ld	a5,8(a0)
ffffffffc0200886:	8385                	srli	a5,a5,0x1
ffffffffc0200888:	8b85                	andi	a5,a5,1
ffffffffc020088a:	e7dd                	bnez	a5,ffffffffc0200938 <buddy_system_check+0x11a>
    // 再分配两个组页
    p2 = alloc_pages(1);
ffffffffc020088c:	4505                	li	a0,1
ffffffffc020088e:	083000ef          	jal	ra,ffffffffc0201110 <alloc_pages>
ffffffffc0200892:	89aa                	mv	s3,a0
    //assert(p2 == p0 + 1);
    p3 = alloc_pages(8);
ffffffffc0200894:	4521                	li	a0,8
ffffffffc0200896:	07b000ef          	jal	ra,ffffffffc0201110 <alloc_pages>
ffffffffc020089a:	651c                	ld	a5,8(a0)
ffffffffc020089c:	892a                	mv	s2,a0
ffffffffc020089e:	8385                	srli	a5,a5,0x1
    //assert(p3 == p0 + 8);
    assert(!PageProperty(p3) && !PageProperty(p3 + 7) && PageProperty(p3 + 8));
ffffffffc02008a0:	8b85                	andi	a5,a5,1
ffffffffc02008a2:	ebbd                	bnez	a5,ffffffffc0200918 <buddy_system_check+0xfa>
ffffffffc02008a4:	12053783          	ld	a5,288(a0)
ffffffffc02008a8:	8385                	srli	a5,a5,0x1
ffffffffc02008aa:	8b85                	andi	a5,a5,1
ffffffffc02008ac:	e7b5                	bnez	a5,ffffffffc0200918 <buddy_system_check+0xfa>
ffffffffc02008ae:	14853783          	ld	a5,328(a0)
ffffffffc02008b2:	8385                	srli	a5,a5,0x1
ffffffffc02008b4:	8b85                	andi	a5,a5,1
ffffffffc02008b6:	c3ad                	beqz	a5,ffffffffc0200918 <buddy_system_check+0xfa>
    //cprintf("here3\n");
    // 回收页
    free_pages(p1, 2);
ffffffffc02008b8:	4589                	li	a1,2
ffffffffc02008ba:	8522                	mv	a0,s0
ffffffffc02008bc:	093000ef          	jal	ra,ffffffffc020114e <free_pages>
ffffffffc02008c0:	641c                	ld	a5,8(s0)
ffffffffc02008c2:	8385                	srli	a5,a5,0x1
    assert(PageProperty(p1));
ffffffffc02008c4:	8b85                	andi	a5,a5,1
ffffffffc02008c6:	14078963          	beqz	a5,ffffffffc0200a18 <buddy_system_check+0x1fa>
    assert(p1->ref == 0);
ffffffffc02008ca:	401c                	lw	a5,0(s0)
ffffffffc02008cc:	12079663          	bnez	a5,ffffffffc02009f8 <buddy_system_check+0x1da>
    free_pages(p0, 1);
ffffffffc02008d0:	4585                	li	a1,1
ffffffffc02008d2:	8526                	mv	a0,s1
ffffffffc02008d4:	07b000ef          	jal	ra,ffffffffc020114e <free_pages>
    free_pages(p2, 1);
ffffffffc02008d8:	4585                	li	a1,1
ffffffffc02008da:	854e                	mv	a0,s3
ffffffffc02008dc:	073000ef          	jal	ra,ffffffffc020114e <free_pages>
    // 回收后再分配
    p2 = alloc_pages(3);
ffffffffc02008e0:	450d                	li	a0,3
ffffffffc02008e2:	02f000ef          	jal	ra,ffffffffc0201110 <alloc_pages>
    //assert(p2 == p0);
    free_pages(p2, 3);
ffffffffc02008e6:	458d                	li	a1,3
    p2 = alloc_pages(3);
ffffffffc02008e8:	842a                	mv	s0,a0
    free_pages(p2, 3);
ffffffffc02008ea:	065000ef          	jal	ra,ffffffffc020114e <free_pages>
    assert((p2 + 2)->ref == 0);
ffffffffc02008ee:	483c                	lw	a5,80(s0)
ffffffffc02008f0:	0e079463          	bnez	a5,ffffffffc02009d8 <buddy_system_check+0x1ba>
    //assert(nr_free_pages() == all_pages >> 1);
    p1 = alloc_pages(129);
ffffffffc02008f4:	08100513          	li	a0,129
ffffffffc02008f8:	019000ef          	jal	ra,ffffffffc0201110 <alloc_pages>
    //(p1 == p0 + 256);
    free_pages(p1, 256);
ffffffffc02008fc:	10000593          	li	a1,256
ffffffffc0200900:	04f000ef          	jal	ra,ffffffffc020114e <free_pages>
    free_pages(p3, 8);
}
ffffffffc0200904:	7402                	ld	s0,32(sp)
ffffffffc0200906:	70a2                	ld	ra,40(sp)
ffffffffc0200908:	64e2                	ld	s1,24(sp)
ffffffffc020090a:	69a2                	ld	s3,8(sp)
    free_pages(p3, 8);
ffffffffc020090c:	854a                	mv	a0,s2
}
ffffffffc020090e:	6942                	ld	s2,16(sp)
    free_pages(p3, 8);
ffffffffc0200910:	45a1                	li	a1,8
}
ffffffffc0200912:	6145                	addi	sp,sp,48
    free_pages(p3, 8);
ffffffffc0200914:	03b0006f          	j	ffffffffc020114e <free_pages>
    assert(!PageProperty(p3) && !PageProperty(p3 + 7) && PageProperty(p3 + 8));
ffffffffc0200918:	00001697          	auipc	a3,0x1
ffffffffc020091c:	7d068693          	addi	a3,a3,2000 # ffffffffc02020e8 <commands+0x5a8>
ffffffffc0200920:	00001617          	auipc	a2,0x1
ffffffffc0200924:	72060613          	addi	a2,a2,1824 # ffffffffc0202040 <commands+0x500>
ffffffffc0200928:	1ad00593          	li	a1,429
ffffffffc020092c:	00001517          	auipc	a0,0x1
ffffffffc0200930:	72c50513          	addi	a0,a0,1836 # ffffffffc0202058 <commands+0x518>
ffffffffc0200934:	807ff0ef          	jal	ra,ffffffffc020013a <__panic>
    assert(!PageReserved(p1) && !PageProperty(p1));
ffffffffc0200938:	00001697          	auipc	a3,0x1
ffffffffc020093c:	78868693          	addi	a3,a3,1928 # ffffffffc02020c0 <commands+0x580>
ffffffffc0200940:	00001617          	auipc	a2,0x1
ffffffffc0200944:	70060613          	addi	a2,a2,1792 # ffffffffc0202040 <commands+0x500>
ffffffffc0200948:	1a700593          	li	a1,423
ffffffffc020094c:	00001517          	auipc	a0,0x1
ffffffffc0200950:	70c50513          	addi	a0,a0,1804 # ffffffffc0202058 <commands+0x518>
ffffffffc0200954:	fe6ff0ef          	jal	ra,ffffffffc020013a <__panic>
    assert(!PageReserved(p0) && !PageProperty(p0));
ffffffffc0200958:	00001697          	auipc	a3,0x1
ffffffffc020095c:	74068693          	addi	a3,a3,1856 # ffffffffc0202098 <commands+0x558>
ffffffffc0200960:	00001617          	auipc	a2,0x1
ffffffffc0200964:	6e060613          	addi	a2,a2,1760 # ffffffffc0202040 <commands+0x500>
ffffffffc0200968:	1a600593          	li	a1,422
ffffffffc020096c:	00001517          	auipc	a0,0x1
ffffffffc0200970:	6ec50513          	addi	a0,a0,1772 # ffffffffc0202058 <commands+0x518>
ffffffffc0200974:	fc6ff0ef          	jal	ra,ffffffffc020013a <__panic>
    assert(p1 != NULL);
ffffffffc0200978:	00001697          	auipc	a3,0x1
ffffffffc020097c:	71068693          	addi	a3,a3,1808 # ffffffffc0202088 <commands+0x548>
ffffffffc0200980:	00001617          	auipc	a2,0x1
ffffffffc0200984:	6c060613          	addi	a2,a2,1728 # ffffffffc0202040 <commands+0x500>
ffffffffc0200988:	1a100593          	li	a1,417
ffffffffc020098c:	00001517          	auipc	a0,0x1
ffffffffc0200990:	6cc50513          	addi	a0,a0,1740 # ffffffffc0202058 <commands+0x518>
ffffffffc0200994:	fa6ff0ef          	jal	ra,ffffffffc020013a <__panic>
    assert(p0 != NULL);
ffffffffc0200998:	00001697          	auipc	a3,0x1
ffffffffc020099c:	6e068693          	addi	a3,a3,1760 # ffffffffc0202078 <commands+0x538>
ffffffffc02009a0:	00001617          	auipc	a2,0x1
ffffffffc02009a4:	6a060613          	addi	a2,a2,1696 # ffffffffc0202040 <commands+0x500>
ffffffffc02009a8:	19f00593          	li	a1,415
ffffffffc02009ac:	00001517          	auipc	a0,0x1
ffffffffc02009b0:	6ac50513          	addi	a0,a0,1708 # ffffffffc0202058 <commands+0x518>
ffffffffc02009b4:	f86ff0ef          	jal	ra,ffffffffc020013a <__panic>
    assert(alloc_pages(all_pages + 1) == NULL);
ffffffffc02009b8:	00001697          	auipc	a3,0x1
ffffffffc02009bc:	66068693          	addi	a3,a3,1632 # ffffffffc0202018 <commands+0x4d8>
ffffffffc02009c0:	00001617          	auipc	a2,0x1
ffffffffc02009c4:	68060613          	addi	a2,a2,1664 # ffffffffc0202040 <commands+0x500>
ffffffffc02009c8:	19c00593          	li	a1,412
ffffffffc02009cc:	00001517          	auipc	a0,0x1
ffffffffc02009d0:	68c50513          	addi	a0,a0,1676 # ffffffffc0202058 <commands+0x518>
ffffffffc02009d4:	f66ff0ef          	jal	ra,ffffffffc020013a <__panic>
    assert((p2 + 2)->ref == 0);
ffffffffc02009d8:	00001697          	auipc	a3,0x1
ffffffffc02009dc:	78068693          	addi	a3,a3,1920 # ffffffffc0202158 <commands+0x618>
ffffffffc02009e0:	00001617          	auipc	a2,0x1
ffffffffc02009e4:	66060613          	addi	a2,a2,1632 # ffffffffc0202040 <commands+0x500>
ffffffffc02009e8:	1b900593          	li	a1,441
ffffffffc02009ec:	00001517          	auipc	a0,0x1
ffffffffc02009f0:	66c50513          	addi	a0,a0,1644 # ffffffffc0202058 <commands+0x518>
ffffffffc02009f4:	f46ff0ef          	jal	ra,ffffffffc020013a <__panic>
    assert(p1->ref == 0);
ffffffffc02009f8:	00001697          	auipc	a3,0x1
ffffffffc02009fc:	75068693          	addi	a3,a3,1872 # ffffffffc0202148 <commands+0x608>
ffffffffc0200a00:	00001617          	auipc	a2,0x1
ffffffffc0200a04:	64060613          	addi	a2,a2,1600 # ffffffffc0202040 <commands+0x500>
ffffffffc0200a08:	1b200593          	li	a1,434
ffffffffc0200a0c:	00001517          	auipc	a0,0x1
ffffffffc0200a10:	64c50513          	addi	a0,a0,1612 # ffffffffc0202058 <commands+0x518>
ffffffffc0200a14:	f26ff0ef          	jal	ra,ffffffffc020013a <__panic>
    assert(PageProperty(p1));
ffffffffc0200a18:	00001697          	auipc	a3,0x1
ffffffffc0200a1c:	71868693          	addi	a3,a3,1816 # ffffffffc0202130 <commands+0x5f0>
ffffffffc0200a20:	00001617          	auipc	a2,0x1
ffffffffc0200a24:	62060613          	addi	a2,a2,1568 # ffffffffc0202040 <commands+0x500>
ffffffffc0200a28:	1b100593          	li	a1,433
ffffffffc0200a2c:	00001517          	auipc	a0,0x1
ffffffffc0200a30:	62c50513          	addi	a0,a0,1580 # ffffffffc0202058 <commands+0x518>
ffffffffc0200a34:	f06ff0ef          	jal	ra,ffffffffc020013a <__panic>

ffffffffc0200a38 <memtree_init>:
    while(np>size)
ffffffffc0200a38:	4785                	li	a5,1
ffffffffc0200a3a:	18b7df63          	bge	a5,a1,ffffffffc0200bd8 <memtree_init+0x1a0>
    int size=1;
ffffffffc0200a3e:	4305                	li	t1,1
		size=size<<1;	
ffffffffc0200a40:	0013131b          	slliw	t1,t1,0x1
    while(np>size)
ffffffffc0200a44:	feb34ee3          	blt	t1,a1,ffffffffc0200a40 <memtree_init+0x8>
    tree_size=2*size-1;
ffffffffc0200a48:	0013161b          	slliw	a2,t1,0x1
ffffffffc0200a4c:	fff60f1b          	addiw	t5,a2,-1
    for(int i=tree_size - 1;i>=0;i--)
ffffffffc0200a50:	3679                	addiw	a2,a2,-2
    tree = (struct memtree*)(ROUNDUP((void*)pages + sizeof(struct Page) * (npage - nbase),32));
ffffffffc0200a52:	00002897          	auipc	a7,0x2
ffffffffc0200a56:	bde8b883          	ld	a7,-1058(a7) # ffffffffc0202630 <nbase>
ffffffffc0200a5a:	00006797          	auipc	a5,0x6
ffffffffc0200a5e:	9ee7b783          	ld	a5,-1554(a5) # ffffffffc0206448 <npage>
ffffffffc0200a62:	411787b3          	sub	a5,a5,a7
ffffffffc0200a66:	00279893          	slli	a7,a5,0x2
ffffffffc0200a6a:	98be                	add	a7,a7,a5
ffffffffc0200a6c:	00389793          	slli	a5,a7,0x3
ffffffffc0200a70:	00006897          	auipc	a7,0x6
ffffffffc0200a74:	9e08b883          	ld	a7,-1568(a7) # ffffffffc0206450 <pages>
ffffffffc0200a78:	98be                	add	a7,a7,a5
ffffffffc0200a7a:	08fd                	addi	a7,a7,31
ffffffffc0200a7c:	fe08f893          	andi	a7,a7,-32
ffffffffc0200a80:	00006e17          	auipc	t3,0x6
ffffffffc0200a84:	9b8e0e13          	addi	t3,t3,-1608 # ffffffffc0206438 <tree>
ffffffffc0200a88:	00461e93          	slli	t4,a2,0x4
            tree[i].avail=(i-size+1<np)?1:0;
ffffffffc0200a8c:	4385                	li	t2,1
    tree_size=2*size-1;
ffffffffc0200a8e:	00006797          	auipc	a5,0x6
ffffffffc0200a92:	9be7a923          	sw	t5,-1614(a5) # ffffffffc0206440 <tree_size>
    tree = (struct memtree*)(ROUNDUP((void*)pages + sizeof(struct Page) * (npage - nbase),32));
ffffffffc0200a96:	011e3023          	sd	a7,0(t3)
    tree[0].page=NULL;
ffffffffc0200a9a:	0008b423          	sd	zero,8(a7)
        if(i>=size-1)
ffffffffc0200a9e:	fff3029b          	addiw	t0,t1,-1
ffffffffc0200aa2:	9ec6                	add	t4,t4,a7
            tree[i].avail=(i-size+1<np)?1:0;
ffffffffc0200aa4:	406383bb          	subw	t2,t2,t1
    for(int i=tree_size - 1;i>=0;i--)
ffffffffc0200aa8:	5ffd                	li	t6,-1
    if(pos>=tree_size)return NULL;
ffffffffc0200aaa:	11e65b63          	bge	a2,t5,ffffffffc0200bc0 <memtree_init+0x188>
    while(pos >=floorpw*2 + 1)
ffffffffc0200aae:	12060063          	beqz	a2,ffffffffc0200bce <memtree_init+0x196>
ffffffffc0200ab2:	879a                	mv	a5,t1
ffffffffc0200ab4:	4681                	li	a3,0
        block_size/=2;
ffffffffc0200ab6:	01f7d81b          	srliw	a6,a5,0x1f
        floorpw+=1;
ffffffffc0200aba:	0016871b          	addiw	a4,a3,1
        block_size/=2;
ffffffffc0200abe:	00f807bb          	addw	a5,a6,a5
    while(pos >=floorpw*2 + 1)
ffffffffc0200ac2:	0017169b          	slliw	a3,a4,0x1
        block_size/=2;
ffffffffc0200ac6:	4017d79b          	sraiw	a5,a5,0x1
    while(pos >=floorpw*2 + 1)
ffffffffc0200aca:	fec6c6e3          	blt	a3,a2,ffffffffc0200ab6 <memtree_init+0x7e>
    (struct Page*)(base + (pos-floorpw) * block_size);
ffffffffc0200ace:	40e6073b          	subw	a4,a2,a4
ffffffffc0200ad2:	02f707bb          	mulw	a5,a4,a5
        tree[i].page=memmap(base,i);
ffffffffc0200ad6:	881a                	mv	a6,t1
ffffffffc0200ad8:	4681                	li	a3,0
    (struct Page*)(base + (pos-floorpw) * block_size);
ffffffffc0200ada:	00279713          	slli	a4,a5,0x2
ffffffffc0200ade:	97ba                	add	a5,a5,a4
ffffffffc0200ae0:	078e                	slli	a5,a5,0x3
    return (struct Page*)(base + (pos-floorpw) * block_size);
ffffffffc0200ae2:	97aa                	add	a5,a5,a0
        tree[i].page=memmap(base,i);
ffffffffc0200ae4:	00feb423          	sd	a5,8(t4)
        block_size/=2;
ffffffffc0200ae8:	01f8579b          	srliw	a5,a6,0x1f
        floorpw+=1;
ffffffffc0200aec:	2685                	addiw	a3,a3,1
        block_size/=2;
ffffffffc0200aee:	010787bb          	addw	a5,a5,a6
    while(pos >=floorpw*2 + 1)
ffffffffc0200af2:	0016969b          	slliw	a3,a3,0x1
        block_size/=2;
ffffffffc0200af6:	4017d81b          	sraiw	a6,a5,0x1
    while(pos >=floorpw*2 + 1)
ffffffffc0200afa:	fec6c7e3          	blt	a3,a2,ffffffffc0200ae8 <memtree_init+0xb0>
        tree[i].size=getps(i);
ffffffffc0200afe:	010ea223          	sw	a6,4(t4)
        if(i>=size-1)
ffffffffc0200b02:	08564d63          	blt	a2,t0,ffffffffc0200b9c <memtree_init+0x164>
            tree[i].avail=(i-size+1<np)?1:0;
ffffffffc0200b06:	00c387bb          	addw	a5,t2,a2
ffffffffc0200b0a:	00b7a7b3          	slt	a5,a5,a1
ffffffffc0200b0e:	00fea023          	sw	a5,0(t4)
    for(int i=tree_size - 1;i>=0;i--)
ffffffffc0200b12:	367d                	addiw	a2,a2,-1
ffffffffc0200b14:	1ec1                	addi	t4,t4,-16
ffffffffc0200b16:	f9f61ae3          	bne	a2,t6,ffffffffc0200aaa <memtree_init+0x72>
    if(np==size)
ffffffffc0200b1a:	0a658e63          	beq	a1,t1,ffffffffc0200bd6 <memtree_init+0x19e>
    while(pos<np)
ffffffffc0200b1e:	4785                	li	a5,1
ffffffffc0200b20:	06b7dd63          	bge	a5,a1,ffffffffc0200b9a <memtree_init+0x162>
    __op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc0200b24:	4e89                	li	t4,2
ffffffffc0200b26:	a019                	j	ffffffffc0200b2c <memtree_init+0xf4>
        if(tree[pos].avail==tree[pos].size){
ffffffffc0200b28:	000e3883          	ld	a7,0(t3)
ffffffffc0200b2c:	00479713          	slli	a4,a5,0x4
ffffffffc0200b30:	00e886b3          	add	a3,a7,a4
ffffffffc0200b34:	42c8                	lw	a0,4(a3)
ffffffffc0200b36:	4290                	lw	a2,0(a3)
ffffffffc0200b38:	04a61c63          	bne	a2,a0,ffffffffc0200b90 <memtree_init+0x158>
            if(tree[pos].page->property==tree[pos].size)
ffffffffc0200b3c:	6694                	ld	a3,8(a3)
ffffffffc0200b3e:	0006081b          	sext.w	a6,a2
ffffffffc0200b42:	4a88                	lw	a0,16(a3)
ffffffffc0200b44:	04c50b63          	beq	a0,a2,ffffffffc0200b9a <memtree_init+0x162>
            tree[pos+1].page->property=tree[pos].page->property-tree[pos].size;
ffffffffc0200b48:	01070313          	addi	t1,a4,16
ffffffffc0200b4c:	989a                	add	a7,a7,t1
ffffffffc0200b4e:	0088b603          	ld	a2,8(a7)
ffffffffc0200b52:	4105053b          	subw	a0,a0,a6
ffffffffc0200b56:	06a1                	addi	a3,a3,8
ffffffffc0200b58:	ca08                	sw	a0,16(a2)
            tree[pos].page->property=tree[pos].size;
ffffffffc0200b5a:	0106a423          	sw	a6,8(a3)
ffffffffc0200b5e:	41d6b02f          	amoor.d	zero,t4,(a3)
            list_add(&(tree[pos].page->page_link),&(tree[pos+1].page->page_link));
ffffffffc0200b62:	000e3683          	ld	a3,0(t3)
            pos+=1;
ffffffffc0200b66:	2785                	addiw	a5,a5,1
            list_add(&(tree[pos].page->page_link),&(tree[pos+1].page->page_link));
ffffffffc0200b68:	9736                	add	a4,a4,a3
ffffffffc0200b6a:	6710                	ld	a2,8(a4)
ffffffffc0200b6c:	00668733          	add	a4,a3,t1
ffffffffc0200b70:	6714                	ld	a3,8(a4)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
ffffffffc0200b72:	7208                	ld	a0,32(a2)
            assert(tree[pos].avail<tree[pos].size);
ffffffffc0200b74:	00072883          	lw	a7,0(a4)
            list_add(&(tree[pos].page->page_link),&(tree[pos+1].page->page_link));
ffffffffc0200b78:	01868813          	addi	a6,a3,24
            assert(tree[pos].avail<tree[pos].size);
ffffffffc0200b7c:	4358                	lw	a4,4(a4)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
ffffffffc0200b7e:	01053023          	sd	a6,0(a0)
ffffffffc0200b82:	03063023          	sd	a6,32(a2)
            list_add(&(tree[pos].page->page_link),&(tree[pos+1].page->page_link));
ffffffffc0200b86:	0661                	addi	a2,a2,24
    elm->next = next;
ffffffffc0200b88:	f288                	sd	a0,32(a3)
    elm->prev = prev;
ffffffffc0200b8a:	ee90                	sd	a2,24(a3)
            assert(tree[pos].avail<tree[pos].size);
ffffffffc0200b8c:	04e8da63          	bge	a7,a4,ffffffffc0200be0 <memtree_init+0x1a8>
            pos=pos*2+1;
ffffffffc0200b90:	0017979b          	slliw	a5,a5,0x1
ffffffffc0200b94:	2785                	addiw	a5,a5,1
    while(pos<np)
ffffffffc0200b96:	f8b7c9e3          	blt	a5,a1,ffffffffc0200b28 <memtree_init+0xf0>
ffffffffc0200b9a:	8082                	ret
            if(tree[i*2+1].avail+tree[i*2+2].avail==tree[i].size)
ffffffffc0200b9c:	0016179b          	slliw	a5,a2,0x1
ffffffffc0200ba0:	0785                	addi	a5,a5,1
ffffffffc0200ba2:	0792                	slli	a5,a5,0x4
ffffffffc0200ba4:	97c6                	add	a5,a5,a7
ffffffffc0200ba6:	4398                	lw	a4,0(a5)
ffffffffc0200ba8:	4b9c                	lw	a5,16(a5)
ffffffffc0200baa:	00f706bb          	addw	a3,a4,a5
ffffffffc0200bae:	01068d63          	beq	a3,a6,ffffffffc0200bc8 <memtree_init+0x190>
                tree[i].avail=(tree[i*2+1].avail>tree[i*2+2].avail) ?  tree[i*2+1].avail: tree[i*2+2].avail;
ffffffffc0200bb2:	86ba                	mv	a3,a4
ffffffffc0200bb4:	00f75363          	bge	a4,a5,ffffffffc0200bba <memtree_init+0x182>
ffffffffc0200bb8:	86be                	mv	a3,a5
ffffffffc0200bba:	00dea023          	sw	a3,0(t4)
ffffffffc0200bbe:	bf91                	j	ffffffffc0200b12 <memtree_init+0xda>
        tree[i].page=memmap(base,i);
ffffffffc0200bc0:	000eb423          	sd	zero,8(t4)
    if(pos>=tree_size)return 0;
ffffffffc0200bc4:	4801                	li	a6,0
ffffffffc0200bc6:	bf25                	j	ffffffffc0200afe <memtree_init+0xc6>
                tree[i].avail=tree[i].size;
ffffffffc0200bc8:	010ea023          	sw	a6,0(t4)
ffffffffc0200bcc:	b799                	j	ffffffffc0200b12 <memtree_init+0xda>
        tree[i].page=memmap(base,i);
ffffffffc0200bce:	00aeb423          	sd	a0,8(t4)
ffffffffc0200bd2:	881a                	mv	a6,t1
ffffffffc0200bd4:	b72d                	j	ffffffffc0200afe <memtree_init+0xc6>
ffffffffc0200bd6:	8082                	ret
    while(np>size)
ffffffffc0200bd8:	4601                	li	a2,0
ffffffffc0200bda:	4f05                	li	t5,1
    int size=1;
ffffffffc0200bdc:	4305                	li	t1,1
ffffffffc0200bde:	bd95                	j	ffffffffc0200a52 <memtree_init+0x1a>
{
ffffffffc0200be0:	1141                	addi	sp,sp,-16
            assert(tree[pos].avail<tree[pos].size);
ffffffffc0200be2:	00001697          	auipc	a3,0x1
ffffffffc0200be6:	58e68693          	addi	a3,a3,1422 # ffffffffc0202170 <commands+0x630>
ffffffffc0200bea:	00001617          	auipc	a2,0x1
ffffffffc0200bee:	45660613          	addi	a2,a2,1110 # ffffffffc0202040 <commands+0x500>
ffffffffc0200bf2:	09500593          	li	a1,149
ffffffffc0200bf6:	00001517          	auipc	a0,0x1
ffffffffc0200bfa:	46250513          	addi	a0,a0,1122 # ffffffffc0202058 <commands+0x518>
{
ffffffffc0200bfe:	e406                	sd	ra,8(sp)
            assert(tree[pos].avail<tree[pos].size);
ffffffffc0200c00:	d3aff0ef          	jal	ra,ffffffffc020013a <__panic>

ffffffffc0200c04 <buddy_system_init_memmap>:
buddy_system_init_memmap(struct Page *base, size_t n) {
ffffffffc0200c04:	1141                	addi	sp,sp,-16
ffffffffc0200c06:	e406                	sd	ra,8(sp)
    assert(n > 0);
ffffffffc0200c08:	c9e9                	beqz	a1,ffffffffc0200cda <buddy_system_init_memmap+0xd6>
    for (; p != base + n; p ++) {
ffffffffc0200c0a:	00259693          	slli	a3,a1,0x2
ffffffffc0200c0e:	96ae                	add	a3,a3,a1
ffffffffc0200c10:	068e                	slli	a3,a3,0x3
ffffffffc0200c12:	96aa                	add	a3,a3,a0
ffffffffc0200c14:	87aa                	mv	a5,a0
ffffffffc0200c16:	00d50f63          	beq	a0,a3,ffffffffc0200c34 <buddy_system_init_memmap+0x30>
    return (((*(volatile unsigned long *)addr) >> nr) & 1);
ffffffffc0200c1a:	6798                	ld	a4,8(a5)
        assert(PageReserved(p));
ffffffffc0200c1c:	8b05                	andi	a4,a4,1
ffffffffc0200c1e:	cf51                	beqz	a4,ffffffffc0200cba <buddy_system_init_memmap+0xb6>
        p->flags = p->property = 0;
ffffffffc0200c20:	0007a823          	sw	zero,16(a5)
ffffffffc0200c24:	0007b423          	sd	zero,8(a5)



static inline int page_ref(struct Page *page) { return page->ref; }

static inline void set_page_ref(struct Page *page, int val) { page->ref = val; }
ffffffffc0200c28:	0007a023          	sw	zero,0(a5)
    for (; p != base + n; p ++) {
ffffffffc0200c2c:	02878793          	addi	a5,a5,40
ffffffffc0200c30:	fed795e3          	bne	a5,a3,ffffffffc0200c1a <buddy_system_init_memmap+0x16>
    base->property = n;
ffffffffc0200c34:	2581                	sext.w	a1,a1
ffffffffc0200c36:	c90c                	sw	a1,16(a0)
    __op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc0200c38:	4789                	li	a5,2
ffffffffc0200c3a:	00850713          	addi	a4,a0,8
ffffffffc0200c3e:	40f7302f          	amoor.d	zero,a5,(a4)
    nr_free += n;
ffffffffc0200c42:	00005697          	auipc	a3,0x5
ffffffffc0200c46:	3ce68693          	addi	a3,a3,974 # ffffffffc0206010 <bsfree_area>
ffffffffc0200c4a:	4a98                	lw	a4,16(a3)
    return list->next == list;
ffffffffc0200c4c:	669c                	ld	a5,8(a3)
        list_add(&free_list, &(base->page_link));
ffffffffc0200c4e:	01850613          	addi	a2,a0,24
    nr_free += n;
ffffffffc0200c52:	9f2d                	addw	a4,a4,a1
ffffffffc0200c54:	ca98                	sw	a4,16(a3)
    if (list_empty(&free_list)) {
ffffffffc0200c56:	04d78b63          	beq	a5,a3,ffffffffc0200cac <buddy_system_init_memmap+0xa8>
            struct Page* page = le2page(le, page_link);
ffffffffc0200c5a:	fe878713          	addi	a4,a5,-24
ffffffffc0200c5e:	0006b883          	ld	a7,0(a3)
    if (list_empty(&free_list)) {
ffffffffc0200c62:	4801                	li	a6,0
            if (base < page) {
ffffffffc0200c64:	00e56a63          	bltu	a0,a4,ffffffffc0200c78 <buddy_system_init_memmap+0x74>
    return listelm->next;
ffffffffc0200c68:	6798                	ld	a4,8(a5)
            } else if (list_next(le) == &free_list) {
ffffffffc0200c6a:	02d70363          	beq	a4,a3,ffffffffc0200c90 <buddy_system_init_memmap+0x8c>
    for (; p != base + n; p ++) {
ffffffffc0200c6e:	87ba                	mv	a5,a4
            struct Page* page = le2page(le, page_link);
ffffffffc0200c70:	fe878713          	addi	a4,a5,-24
            if (base < page) {
ffffffffc0200c74:	fee57ae3          	bgeu	a0,a4,ffffffffc0200c68 <buddy_system_init_memmap+0x64>
ffffffffc0200c78:	00080463          	beqz	a6,ffffffffc0200c80 <buddy_system_init_memmap+0x7c>
ffffffffc0200c7c:	0116b023          	sd	a7,0(a3)
    __list_add(elm, listelm->prev, listelm);
ffffffffc0200c80:	6398                	ld	a4,0(a5)
    prev->next = next->prev = elm;
ffffffffc0200c82:	e390                	sd	a2,0(a5)
}
ffffffffc0200c84:	60a2                	ld	ra,8(sp)
ffffffffc0200c86:	e710                	sd	a2,8(a4)
    elm->next = next;
ffffffffc0200c88:	f11c                	sd	a5,32(a0)
    elm->prev = prev;
ffffffffc0200c8a:	ed18                	sd	a4,24(a0)
ffffffffc0200c8c:	0141                	addi	sp,sp,16
    memtree_init(base,n);
ffffffffc0200c8e:	b36d                	j	ffffffffc0200a38 <memtree_init>
    prev->next = next->prev = elm;
ffffffffc0200c90:	e790                	sd	a2,8(a5)
    elm->next = next;
ffffffffc0200c92:	f114                	sd	a3,32(a0)
    return listelm->next;
ffffffffc0200c94:	6798                	ld	a4,8(a5)
    elm->prev = prev;
ffffffffc0200c96:	ed1c                	sd	a5,24(a0)
        while ((le = list_next(le)) != &free_list) {
ffffffffc0200c98:	00d70663          	beq	a4,a3,ffffffffc0200ca4 <buddy_system_init_memmap+0xa0>
    prev->next = next->prev = elm;
ffffffffc0200c9c:	88b2                	mv	a7,a2
ffffffffc0200c9e:	4805                	li	a6,1
    for (; p != base + n; p ++) {
ffffffffc0200ca0:	87ba                	mv	a5,a4
ffffffffc0200ca2:	b7f9                	j	ffffffffc0200c70 <buddy_system_init_memmap+0x6c>
}
ffffffffc0200ca4:	60a2                	ld	ra,8(sp)
ffffffffc0200ca6:	e290                	sd	a2,0(a3)
ffffffffc0200ca8:	0141                	addi	sp,sp,16
    memtree_init(base,n);
ffffffffc0200caa:	b379                	j	ffffffffc0200a38 <memtree_init>
}
ffffffffc0200cac:	60a2                	ld	ra,8(sp)
ffffffffc0200cae:	e390                	sd	a2,0(a5)
ffffffffc0200cb0:	e790                	sd	a2,8(a5)
    elm->next = next;
ffffffffc0200cb2:	f11c                	sd	a5,32(a0)
    elm->prev = prev;
ffffffffc0200cb4:	ed1c                	sd	a5,24(a0)
ffffffffc0200cb6:	0141                	addi	sp,sp,16
    memtree_init(base,n);
ffffffffc0200cb8:	b341                	j	ffffffffc0200a38 <memtree_init>
        assert(PageReserved(p));
ffffffffc0200cba:	00001697          	auipc	a3,0x1
ffffffffc0200cbe:	4de68693          	addi	a3,a3,1246 # ffffffffc0202198 <commands+0x658>
ffffffffc0200cc2:	00001617          	auipc	a2,0x1
ffffffffc0200cc6:	37e60613          	addi	a2,a2,894 # ffffffffc0202040 <commands+0x500>
ffffffffc0200cca:	10200593          	li	a1,258
ffffffffc0200cce:	00001517          	auipc	a0,0x1
ffffffffc0200cd2:	38a50513          	addi	a0,a0,906 # ffffffffc0202058 <commands+0x518>
ffffffffc0200cd6:	c64ff0ef          	jal	ra,ffffffffc020013a <__panic>
    assert(n > 0);
ffffffffc0200cda:	00001697          	auipc	a3,0x1
ffffffffc0200cde:	4b668693          	addi	a3,a3,1206 # ffffffffc0202190 <commands+0x650>
ffffffffc0200ce2:	00001617          	auipc	a2,0x1
ffffffffc0200ce6:	35e60613          	addi	a2,a2,862 # ffffffffc0202040 <commands+0x500>
ffffffffc0200cea:	0ff00593          	li	a1,255
ffffffffc0200cee:	00001517          	auipc	a0,0x1
ffffffffc0200cf2:	36a50513          	addi	a0,a0,874 # ffffffffc0202058 <commands+0x518>
ffffffffc0200cf6:	c44ff0ef          	jal	ra,ffffffffc020013a <__panic>

ffffffffc0200cfa <get_mem>:
    while(tree[find_pos].avail>=n && find_pos<(tree_size-1)/2)
ffffffffc0200cfa:	00005f17          	auipc	t5,0x5
ffffffffc0200cfe:	73ef0f13          	addi	t5,t5,1854 # ffffffffc0206438 <tree>
ffffffffc0200d02:	000f3603          	ld	a2,0(t5)
ffffffffc0200d06:	4214                	lw	a3,0(a2)
ffffffffc0200d08:	14a6cc63          	blt	a3,a0,ffffffffc0200e60 <get_mem+0x166>
{
ffffffffc0200d0c:	1101                	addi	sp,sp,-32
ffffffffc0200d0e:	ec22                	sd	s0,24(sp)
ffffffffc0200d10:	e826                	sd	s1,16(sp)
ffffffffc0200d12:	e44a                	sd	s2,8(sp)
ffffffffc0200d14:	8e2a                	mv	t3,a0
    while(tree[find_pos].avail>=n && find_pos<(tree_size-1)/2)
ffffffffc0200d16:	8332                	mv	t1,a2
    int find_pos=0;
ffffffffc0200d18:	4781                	li	a5,0
    while(tree[find_pos].avail>=n && find_pos<(tree_size-1)/2)
ffffffffc0200d1a:	4281                	li	t0,0
ffffffffc0200d1c:	00005f97          	auipc	t6,0x5
ffffffffc0200d20:	724f8f93          	addi	t6,t6,1828 # ffffffffc0206440 <tree_size>
ffffffffc0200d24:	4389                	li	t2,2
ffffffffc0200d26:	000fa703          	lw	a4,0(t6)
ffffffffc0200d2a:	fff7059b          	addiw	a1,a4,-1
ffffffffc0200d2e:	01f5d71b          	srliw	a4,a1,0x1f
ffffffffc0200d32:	9f2d                	addw	a4,a4,a1
ffffffffc0200d34:	4017571b          	sraiw	a4,a4,0x1
ffffffffc0200d38:	10e7df63          	bge	a5,a4,ffffffffc0200e56 <get_mem+0x15c>
        if(tree[find_pos].avail==tree[find_pos].size && tree[find_pos].avail>n)
ffffffffc0200d3c:	00432803          	lw	a6,4(t1)
            (tree[find_pos*2+1].page)->property=tree[find_pos*2+1].avail;
ffffffffc0200d40:	0017971b          	slliw	a4,a5,0x1
ffffffffc0200d44:	0017051b          	addiw	a0,a4,1
ffffffffc0200d48:	2709                	addiw	a4,a4,2
ffffffffc0200d4a:	00451593          	slli	a1,a0,0x4
            (tree[find_pos*2+2].page)->property=tree[find_pos*2+2].avail;
ffffffffc0200d4e:	00471893          	slli	a7,a4,0x4
        if(tree[find_pos].avail==tree[find_pos].size && tree[find_pos].avail>n)
ffffffffc0200d52:	0ad80163          	beq	a6,a3,ffffffffc0200df4 <get_mem+0xfa>
        if(tree[find_pos*2+1].avail>=n && (tree[find_pos*2+2].avail >= tree[find_pos*2+1].avail || tree[find_pos*2+2].avail<n))
ffffffffc0200d56:	000f3603          	ld	a2,0(t5)
ffffffffc0200d5a:	00b60333          	add	t1,a2,a1
ffffffffc0200d5e:	01160833          	add	a6,a2,a7
ffffffffc0200d62:	00032683          	lw	a3,0(t1)
ffffffffc0200d66:	00082e83          	lw	t4,0(a6)
ffffffffc0200d6a:	03c6c063          	blt	a3,t3,ffffffffc0200d8a <get_mem+0x90>
ffffffffc0200d6e:	00dedb63          	bge	t4,a3,ffffffffc0200d84 <get_mem+0x8a>
ffffffffc0200d72:	01cec963          	blt	t4,t3,ffffffffc0200d84 <get_mem+0x8a>
    while(tree[find_pos].avail>=n && find_pos<(tree_size-1)/2)
ffffffffc0200d76:	00082683          	lw	a3,0(a6)
ffffffffc0200d7a:	8342                	mv	t1,a6
ffffffffc0200d7c:	0fc6c063          	blt	a3,t3,ffffffffc0200e5c <get_mem+0x162>
ffffffffc0200d80:	85c6                	mv	a1,a7
            find_pos=find_pos*2+2;
ffffffffc0200d82:	853a                	mv	a0,a4
ffffffffc0200d84:	87aa                	mv	a5,a0
ffffffffc0200d86:	82ae                	mv	t0,a1
ffffffffc0200d88:	bf79                	j	ffffffffc0200d26 <get_mem+0x2c>
        if(tree[find_pos*2+2].avail>=n)
ffffffffc0200d8a:	ffced6e3          	bge	t4,t3,ffffffffc0200d76 <get_mem+0x7c>
    if(find_pos==0&&tree[find_pos].avail<n)
ffffffffc0200d8e:	00560333          	add	t1,a2,t0
ffffffffc0200d92:	cbcd                	beqz	a5,ffffffffc0200e44 <get_mem+0x14a>
    tree[find_pos].avail=0;
ffffffffc0200d94:	00032023          	sw	zero,0(t1)
        int dpos=(pos-1)/2;
ffffffffc0200d98:	37fd                	addiw	a5,a5,-1
ffffffffc0200d9a:	4017d79b          	sraiw	a5,a5,0x1
        tree[dpos].avail=tree[dpos*2+1].avail>tree[dpos*2+2].avail ? tree[dpos*2+1].avail:tree[dpos*2+2].avail;
ffffffffc0200d9e:	0017971b          	slliw	a4,a5,0x1
ffffffffc0200da2:	0027069b          	addiw	a3,a4,2
ffffffffc0200da6:	2705                	addiw	a4,a4,1
ffffffffc0200da8:	0692                	slli	a3,a3,0x4
ffffffffc0200daa:	0712                	slli	a4,a4,0x4
ffffffffc0200dac:	9732                	add	a4,a4,a2
ffffffffc0200dae:	96b2                	add	a3,a3,a2
ffffffffc0200db0:	430c                	lw	a1,0(a4)
ffffffffc0200db2:	4294                	lw	a3,0(a3)
ffffffffc0200db4:	00479713          	slli	a4,a5,0x4
ffffffffc0200db8:	0005881b          	sext.w	a6,a1
ffffffffc0200dbc:	0006889b          	sext.w	a7,a3
ffffffffc0200dc0:	9732                	add	a4,a4,a2
ffffffffc0200dc2:	0108d363          	bge	a7,a6,ffffffffc0200dc8 <get_mem+0xce>
ffffffffc0200dc6:	86ae                	mv	a3,a1
ffffffffc0200dc8:	c314                	sw	a3,0(a4)
    while(pos>0)
ffffffffc0200dca:	f7f9                	bnez	a5,ffffffffc0200d98 <get_mem+0x9e>
    list_del(&(tree[find_pos].page->page_link));
ffffffffc0200dcc:	00833503          	ld	a0,8(t1)
    nr_free -= n;
ffffffffc0200dd0:	00005717          	auipc	a4,0x5
ffffffffc0200dd4:	24070713          	addi	a4,a4,576 # ffffffffc0206010 <bsfree_area>
ffffffffc0200dd8:	4b1c                	lw	a5,16(a4)
    __list_del(listelm->prev, listelm->next);
ffffffffc0200dda:	6d10                	ld	a2,24(a0)
ffffffffc0200ddc:	7114                	ld	a3,32(a0)
ffffffffc0200dde:	41c78e3b          	subw	t3,a5,t3
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
ffffffffc0200de2:	e614                	sd	a3,8(a2)
    next->prev = prev;
ffffffffc0200de4:	e290                	sd	a2,0(a3)
ffffffffc0200de6:	01c72823          	sw	t3,16(a4)
}
ffffffffc0200dea:	6462                	ld	s0,24(sp)
ffffffffc0200dec:	64c2                	ld	s1,16(sp)
ffffffffc0200dee:	6922                	ld	s2,8(sp)
ffffffffc0200df0:	6105                	addi	sp,sp,32
ffffffffc0200df2:	8082                	ret
        if(tree[find_pos].avail==tree[find_pos].size && tree[find_pos].avail>n)
ffffffffc0200df4:	f6de51e3          	bge	t3,a3,ffffffffc0200d56 <get_mem+0x5c>
            (tree[find_pos*2+1].page)->property=tree[find_pos*2+1].avail;
ffffffffc0200df8:	00b606b3          	add	a3,a2,a1
ffffffffc0200dfc:	0086b803          	ld	a6,8(a3)
ffffffffc0200e00:	0006a303          	lw	t1,0(a3)
            (tree[find_pos*2+2].page)->property=tree[find_pos*2+2].avail;
ffffffffc0200e04:	9646                	add	a2,a2,a7
ffffffffc0200e06:	6614                	ld	a3,8(a2)
ffffffffc0200e08:	4210                	lw	a2,0(a2)
            (tree[find_pos*2+1].page)->property=tree[find_pos*2+1].avail;
ffffffffc0200e0a:	00682823          	sw	t1,16(a6)
ffffffffc0200e0e:	06a1                	addi	a3,a3,8
            (tree[find_pos*2+2].page)->property=tree[find_pos*2+2].avail;
ffffffffc0200e10:	c690                	sw	a2,8(a3)
ffffffffc0200e12:	4076b02f          	amoor.d	zero,t2,(a3)
            list_add(&(tree[find_pos*2+1].page->page_link), &((tree[find_pos*2+2].page)->page_link));
ffffffffc0200e16:	000f3603          	ld	a2,0(t5)
ffffffffc0200e1a:	00b60333          	add	t1,a2,a1
ffffffffc0200e1e:	00833e83          	ld	t4,8(t1)
ffffffffc0200e22:	01160833          	add	a6,a2,a7
ffffffffc0200e26:	00883683          	ld	a3,8(a6)
    __list_add(elm, listelm, listelm->next);
ffffffffc0200e2a:	020eb403          	ld	s0,32(t4)
ffffffffc0200e2e:	018e8913          	addi	s2,t4,24
ffffffffc0200e32:	01868493          	addi	s1,a3,24
    prev->next = next->prev = elm;
ffffffffc0200e36:	e004                	sd	s1,0(s0)
ffffffffc0200e38:	029eb023          	sd	s1,32(t4)
    elm->next = next;
ffffffffc0200e3c:	f280                	sd	s0,32(a3)
    elm->prev = prev;
ffffffffc0200e3e:	0126bc23          	sd	s2,24(a3)
}
ffffffffc0200e42:	b705                	j	ffffffffc0200d62 <get_mem+0x68>
    if(find_pos==0&&tree[find_pos].avail<n)
ffffffffc0200e44:	00032783          	lw	a5,0(t1)
ffffffffc0200e48:	01c7c563          	blt	a5,t3,ffffffffc0200e52 <get_mem+0x158>
    tree[find_pos].avail=0;
ffffffffc0200e4c:	00032023          	sw	zero,0(t1)
    while(pos>0)
ffffffffc0200e50:	bfb5                	j	ffffffffc0200dcc <get_mem+0xd2>
        return NULL;
ffffffffc0200e52:	4501                	li	a0,0
ffffffffc0200e54:	bf59                	j	ffffffffc0200dea <get_mem+0xf0>
    if(find_pos==0&&tree[find_pos].avail<n)
ffffffffc0200e56:	000f3603          	ld	a2,0(t5)
ffffffffc0200e5a:	bf15                	j	ffffffffc0200d8e <get_mem+0x94>
            find_pos=find_pos*2+2;
ffffffffc0200e5c:	87ba                	mv	a5,a4
ffffffffc0200e5e:	bf1d                	j	ffffffffc0200d94 <get_mem+0x9a>
        return NULL;
ffffffffc0200e60:	4501                	li	a0,0
}
ffffffffc0200e62:	8082                	ret

ffffffffc0200e64 <buddy_system_alloc_pages>:
buddy_system_alloc_pages(size_t n) {
ffffffffc0200e64:	1141                	addi	sp,sp,-16
ffffffffc0200e66:	e406                	sd	ra,8(sp)
    assert(n > 0);
ffffffffc0200e68:	cd1d                	beqz	a0,ffffffffc0200ea6 <buddy_system_alloc_pages+0x42>
    if (n > nr_free) {
ffffffffc0200e6a:	00005717          	auipc	a4,0x5
ffffffffc0200e6e:	1b676703          	lwu	a4,438(a4) # ffffffffc0206020 <bsfree_area+0x10>
ffffffffc0200e72:	87aa                	mv	a5,a0
ffffffffc0200e74:	02a76563          	bltu	a4,a0,ffffffffc0200e9e <buddy_system_alloc_pages+0x3a>
    while(n>size)
ffffffffc0200e78:	4705                	li	a4,1
    int size=1;
ffffffffc0200e7a:	4505                	li	a0,1
    while(n>size)
ffffffffc0200e7c:	00e78663          	beq	a5,a4,ffffffffc0200e88 <buddy_system_alloc_pages+0x24>
		size=size<<1;	
ffffffffc0200e80:	0015151b          	slliw	a0,a0,0x1
    while(n>size)
ffffffffc0200e84:	fef56ee3          	bltu	a0,a5,ffffffffc0200e80 <buddy_system_alloc_pages+0x1c>
    page=get_mem(size);
ffffffffc0200e88:	e73ff0ef          	jal	ra,ffffffffc0200cfa <get_mem>
    if (page != NULL) {
ffffffffc0200e8c:	c511                	beqz	a0,ffffffffc0200e98 <buddy_system_alloc_pages+0x34>
    __op_bit(and, __NOT, nr, ((volatile unsigned long *)addr));
ffffffffc0200e8e:	57f5                	li	a5,-3
ffffffffc0200e90:	00850713          	addi	a4,a0,8
ffffffffc0200e94:	60f7302f          	amoand.d	zero,a5,(a4)
}
ffffffffc0200e98:	60a2                	ld	ra,8(sp)
ffffffffc0200e9a:	0141                	addi	sp,sp,16
ffffffffc0200e9c:	8082                	ret
ffffffffc0200e9e:	60a2                	ld	ra,8(sp)
        return NULL;
ffffffffc0200ea0:	4501                	li	a0,0
}
ffffffffc0200ea2:	0141                	addi	sp,sp,16
ffffffffc0200ea4:	8082                	ret
    assert(n > 0);
ffffffffc0200ea6:	00001697          	auipc	a3,0x1
ffffffffc0200eaa:	2ea68693          	addi	a3,a3,746 # ffffffffc0202190 <commands+0x650>
ffffffffc0200eae:	00001617          	auipc	a2,0x1
ffffffffc0200eb2:	19260613          	addi	a2,a2,402 # ffffffffc0202040 <commands+0x500>
ffffffffc0200eb6:	11e00593          	li	a1,286
ffffffffc0200eba:	00001517          	auipc	a0,0x1
ffffffffc0200ebe:	19e50513          	addi	a0,a0,414 # ffffffffc0202058 <commands+0x518>
ffffffffc0200ec2:	a78ff0ef          	jal	ra,ffffffffc020013a <__panic>

ffffffffc0200ec6 <free_mem>:
    int ea= page-tree[0].page;
ffffffffc0200ec6:	00005e97          	auipc	t4,0x5
ffffffffc0200eca:	572e8e93          	addi	t4,t4,1394 # ffffffffc0206438 <tree>
ffffffffc0200ece:	000eb803          	ld	a6,0(t4)
    int pos=ea+(tree_size-1)/2;
ffffffffc0200ed2:	00005797          	auipc	a5,0x5
ffffffffc0200ed6:	56e7a783          	lw	a5,1390(a5) # ffffffffc0206440 <tree_size>
ffffffffc0200eda:	fff7869b          	addiw	a3,a5,-1
    int ea= page-tree[0].page;
ffffffffc0200ede:	00883703          	ld	a4,8(a6)
ffffffffc0200ee2:	40e507b3          	sub	a5,a0,a4
ffffffffc0200ee6:	878d                	srai	a5,a5,0x3
ffffffffc0200ee8:	00001717          	auipc	a4,0x1
ffffffffc0200eec:	74073703          	ld	a4,1856(a4) # ffffffffc0202628 <error_string+0x38>
ffffffffc0200ef0:	02e78733          	mul	a4,a5,a4
    int pos=ea+(tree_size-1)/2;
ffffffffc0200ef4:	01f6d79b          	srliw	a5,a3,0x1f
ffffffffc0200ef8:	9fb5                	addw	a5,a5,a3
ffffffffc0200efa:	4017d79b          	sraiw	a5,a5,0x1
ffffffffc0200efe:	9fb9                	addw	a5,a5,a4
    while(pos>0)
ffffffffc0200f00:	00f04763          	bgtz	a5,ffffffffc0200f0e <free_mem+0x48>
ffffffffc0200f04:	a05d                	j	ffffffffc0200faa <free_mem+0xe4>
        pos=(pos-1)/2;
ffffffffc0200f06:	37fd                	addiw	a5,a5,-1
ffffffffc0200f08:	4017d79b          	sraiw	a5,a5,0x1
    while(pos>0)
ffffffffc0200f0c:	cfd9                	beqz	a5,ffffffffc0200faa <free_mem+0xe4>
        if (tree[pos].size>=n)break;
ffffffffc0200f0e:	00479713          	slli	a4,a5,0x4
ffffffffc0200f12:	9742                	add	a4,a4,a6
ffffffffc0200f14:	4354                	lw	a3,4(a4)
ffffffffc0200f16:	feb6e8e3          	bltu	a3,a1,ffffffffc0200f06 <free_mem+0x40>
{
ffffffffc0200f1a:	1141                	addi	sp,sp,-16
ffffffffc0200f1c:	e406                	sd	ra,8(sp)
    tree[pos].avail=tree[pos].size;
ffffffffc0200f1e:	c314                	sw	a3,0(a4)
ffffffffc0200f20:	5f75                	li	t5,-3
        int dpos=(pos-1)/2;
ffffffffc0200f22:	37fd                	addiw	a5,a5,-1
ffffffffc0200f24:	4017d79b          	sraiw	a5,a5,0x1
        if(tree[dpos*2+1].avail+tree[dpos*2+2].avail==tree[dpos].size)//遇到可以合并的就合并
ffffffffc0200f28:	0017969b          	slliw	a3,a5,0x1
ffffffffc0200f2c:	0016871b          	addiw	a4,a3,1
ffffffffc0200f30:	0689                	addi	a3,a3,2
ffffffffc0200f32:	0712                	slli	a4,a4,0x4
ffffffffc0200f34:	0692                	slli	a3,a3,0x4
ffffffffc0200f36:	9742                	add	a4,a4,a6
ffffffffc0200f38:	00d808b3          	add	a7,a6,a3
ffffffffc0200f3c:	00479613          	slli	a2,a5,0x4
ffffffffc0200f40:	430c                	lw	a1,0(a4)
ffffffffc0200f42:	0008a503          	lw	a0,0(a7)
ffffffffc0200f46:	9642                	add	a2,a2,a6
ffffffffc0200f48:	00462303          	lw	t1,4(a2)
ffffffffc0200f4c:	00a58e3b          	addw	t3,a1,a0
ffffffffc0200f50:	006e0b63          	beq	t3,t1,ffffffffc0200f66 <free_mem+0xa0>
            tree[dpos].avail=tree[dpos*2+1].avail>tree[dpos*2+2].avail ? tree[dpos*2+1].avail:tree[dpos*2+2].avail;
ffffffffc0200f54:	872e                	mv	a4,a1
ffffffffc0200f56:	00a5d363          	bge	a1,a0,ffffffffc0200f5c <free_mem+0x96>
ffffffffc0200f5a:	872a                	mv	a4,a0
ffffffffc0200f5c:	c218                	sw	a4,0(a2)
    while(pos>0)
ffffffffc0200f5e:	c3b9                	beqz	a5,ffffffffc0200fa4 <free_mem+0xde>
        if(tree[dpos*2+1].avail+tree[dpos*2+2].avail==tree[dpos].size)//遇到可以合并的就合并
ffffffffc0200f60:	000eb803          	ld	a6,0(t4)
ffffffffc0200f64:	bf7d                	j	ffffffffc0200f22 <free_mem+0x5c>
            assert(tree[dpos*2+2].page->property==tree[dpos*2+2].size);
ffffffffc0200f66:	0088b583          	ld	a1,8(a7)
ffffffffc0200f6a:	0048a503          	lw	a0,4(a7)
ffffffffc0200f6e:	0105a883          	lw	a7,16(a1)
ffffffffc0200f72:	06a89163          	bne	a7,a0,ffffffffc0200fd4 <free_mem+0x10e>
            assert(tree[dpos*2+1].page->property==tree[dpos*2+1].size);
ffffffffc0200f76:	6708                	ld	a0,8(a4)
ffffffffc0200f78:	4358                	lw	a4,4(a4)
ffffffffc0200f7a:	4908                	lw	a0,16(a0)
ffffffffc0200f7c:	02e51c63          	bne	a0,a4,ffffffffc0200fb4 <free_mem+0xee>
            tree[dpos].page->property=tree[dpos].size;
ffffffffc0200f80:	6618                	ld	a4,8(a2)
            tree[dpos].avail=tree[dpos].size;
ffffffffc0200f82:	01c62023          	sw	t3,0(a2)
            tree[dpos].page->property=tree[dpos].size;
ffffffffc0200f86:	01c72823          	sw	t3,16(a4)
ffffffffc0200f8a:	00858713          	addi	a4,a1,8
ffffffffc0200f8e:	61e7302f          	amoand.d	zero,t5,(a4)
            list_del(&(tree[dpos*2+2].page->page_link));
ffffffffc0200f92:	000eb703          	ld	a4,0(t4)
ffffffffc0200f96:	96ba                	add	a3,a3,a4
ffffffffc0200f98:	6698                	ld	a4,8(a3)
    __list_del(listelm->prev, listelm->next);
ffffffffc0200f9a:	6f14                	ld	a3,24(a4)
ffffffffc0200f9c:	7318                	ld	a4,32(a4)
    prev->next = next;
ffffffffc0200f9e:	e698                	sd	a4,8(a3)
    next->prev = prev;
ffffffffc0200fa0:	e314                	sd	a3,0(a4)
    while(pos>0)
ffffffffc0200fa2:	ffdd                	bnez	a5,ffffffffc0200f60 <free_mem+0x9a>
}
ffffffffc0200fa4:	60a2                	ld	ra,8(sp)
ffffffffc0200fa6:	0141                	addi	sp,sp,16
ffffffffc0200fa8:	8082                	ret
    tree[pos].avail=tree[pos].size;
ffffffffc0200faa:	0792                	slli	a5,a5,0x4
ffffffffc0200fac:	97c2                	add	a5,a5,a6
ffffffffc0200fae:	43d8                	lw	a4,4(a5)
ffffffffc0200fb0:	c398                	sw	a4,0(a5)
    while(pos>0)
ffffffffc0200fb2:	8082                	ret
            assert(tree[dpos*2+1].page->property==tree[dpos*2+1].size);
ffffffffc0200fb4:	00001697          	auipc	a3,0x1
ffffffffc0200fb8:	22c68693          	addi	a3,a3,556 # ffffffffc02021e0 <commands+0x6a0>
ffffffffc0200fbc:	00001617          	auipc	a2,0x1
ffffffffc0200fc0:	08460613          	addi	a2,a2,132 # ffffffffc0202040 <commands+0x500>
ffffffffc0200fc4:	0e500593          	li	a1,229
ffffffffc0200fc8:	00001517          	auipc	a0,0x1
ffffffffc0200fcc:	09050513          	addi	a0,a0,144 # ffffffffc0202058 <commands+0x518>
ffffffffc0200fd0:	96aff0ef          	jal	ra,ffffffffc020013a <__panic>
            assert(tree[dpos*2+2].page->property==tree[dpos*2+2].size);
ffffffffc0200fd4:	00001697          	auipc	a3,0x1
ffffffffc0200fd8:	1d468693          	addi	a3,a3,468 # ffffffffc02021a8 <commands+0x668>
ffffffffc0200fdc:	00001617          	auipc	a2,0x1
ffffffffc0200fe0:	06460613          	addi	a2,a2,100 # ffffffffc0202040 <commands+0x500>
ffffffffc0200fe4:	0e400593          	li	a1,228
ffffffffc0200fe8:	00001517          	auipc	a0,0x1
ffffffffc0200fec:	07050513          	addi	a0,a0,112 # ffffffffc0202058 <commands+0x518>
ffffffffc0200ff0:	94aff0ef          	jal	ra,ffffffffc020013a <__panic>

ffffffffc0200ff4 <buddy_system_free_pages>:
buddy_system_free_pages(struct Page *base, size_t n) {
ffffffffc0200ff4:	1141                	addi	sp,sp,-16
ffffffffc0200ff6:	e406                	sd	ra,8(sp)
    assert(n > 0);
ffffffffc0200ff8:	0e058c63          	beqz	a1,ffffffffc02010f0 <buddy_system_free_pages+0xfc>
ffffffffc0200ffc:	87ae                	mv	a5,a1
    int size=1;
ffffffffc0200ffe:	4685                	li	a3,1
    while(n>size)
ffffffffc0201000:	4585                	li	a1,1
ffffffffc0201002:	02850613          	addi	a2,a0,40
ffffffffc0201006:	00d78e63          	beq	a5,a3,ffffffffc0201022 <buddy_system_free_pages+0x2e>
		size=size<<1;	
ffffffffc020100a:	0016969b          	slliw	a3,a3,0x1
    while(n>size)
ffffffffc020100e:	85b6                	mv	a1,a3
ffffffffc0201010:	fef6ede3          	bltu	a3,a5,ffffffffc020100a <buddy_system_free_pages+0x16>
    for (; p != base + size; p ++) {
ffffffffc0201014:	00269613          	slli	a2,a3,0x2
ffffffffc0201018:	9636                	add	a2,a2,a3
ffffffffc020101a:	060e                	slli	a2,a2,0x3
ffffffffc020101c:	962a                	add	a2,a2,a0
ffffffffc020101e:	02c50163          	beq	a0,a2,ffffffffc0201040 <buddy_system_free_pages+0x4c>
ffffffffc0201022:	87aa                	mv	a5,a0
    return (((*(volatile unsigned long *)addr) >> nr) & 1);
ffffffffc0201024:	6798                	ld	a4,8(a5)
        assert(!PageReserved(p) && !PageProperty(p));
ffffffffc0201026:	8b05                	andi	a4,a4,1
ffffffffc0201028:	e745                	bnez	a4,ffffffffc02010d0 <buddy_system_free_pages+0xdc>
ffffffffc020102a:	6798                	ld	a4,8(a5)
ffffffffc020102c:	8b09                	andi	a4,a4,2
ffffffffc020102e:	e34d                	bnez	a4,ffffffffc02010d0 <buddy_system_free_pages+0xdc>
        p->flags = 0;
ffffffffc0201030:	0007b423          	sd	zero,8(a5)
ffffffffc0201034:	0007a023          	sw	zero,0(a5)
    for (; p != base + size; p ++) {
ffffffffc0201038:	02878793          	addi	a5,a5,40
ffffffffc020103c:	fec794e3          	bne	a5,a2,ffffffffc0201024 <buddy_system_free_pages+0x30>
    base->property=size;
ffffffffc0201040:	2681                	sext.w	a3,a3
ffffffffc0201042:	c914                	sw	a3,16(a0)
    __op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc0201044:	4789                	li	a5,2
ffffffffc0201046:	00850713          	addi	a4,a0,8
ffffffffc020104a:	40f7302f          	amoor.d	zero,a5,(a4)
    nr_free += size;
ffffffffc020104e:	00005617          	auipc	a2,0x5
ffffffffc0201052:	fc260613          	addi	a2,a2,-62 # ffffffffc0206010 <bsfree_area>
ffffffffc0201056:	4a18                	lw	a4,16(a2)
    return list->next == list;
ffffffffc0201058:	661c                	ld	a5,8(a2)
        list_add(&free_list, &(base->page_link));
ffffffffc020105a:	01850813          	addi	a6,a0,24
    nr_free += size;
ffffffffc020105e:	9eb9                	addw	a3,a3,a4
ffffffffc0201060:	ca14                	sw	a3,16(a2)
    if (list_empty(&free_list)) {
ffffffffc0201062:	04c78e63          	beq	a5,a2,ffffffffc02010be <buddy_system_free_pages+0xca>
            struct Page* page = le2page(le, page_link);
ffffffffc0201066:	fe878713          	addi	a4,a5,-24
ffffffffc020106a:	00063883          	ld	a7,0(a2)
    if (list_empty(&free_list)) {
ffffffffc020106e:	4681                	li	a3,0
            if (base < page) {
ffffffffc0201070:	00e56a63          	bltu	a0,a4,ffffffffc0201084 <buddy_system_free_pages+0x90>
    return listelm->next;
ffffffffc0201074:	6798                	ld	a4,8(a5)
            } else if (list_next(le) == &free_list) {
ffffffffc0201076:	02c70463          	beq	a4,a2,ffffffffc020109e <buddy_system_free_pages+0xaa>
    for (; p != base + size; p ++) {
ffffffffc020107a:	87ba                	mv	a5,a4
            struct Page* page = le2page(le, page_link);
ffffffffc020107c:	fe878713          	addi	a4,a5,-24
            if (base < page) {
ffffffffc0201080:	fee57ae3          	bgeu	a0,a4,ffffffffc0201074 <buddy_system_free_pages+0x80>
ffffffffc0201084:	c299                	beqz	a3,ffffffffc020108a <buddy_system_free_pages+0x96>
ffffffffc0201086:	01163023          	sd	a7,0(a2)
    __list_add(elm, listelm->prev, listelm);
ffffffffc020108a:	6398                	ld	a4,0(a5)
    prev->next = next->prev = elm;
ffffffffc020108c:	0107b023          	sd	a6,0(a5)
}
ffffffffc0201090:	60a2                	ld	ra,8(sp)
ffffffffc0201092:	01073423          	sd	a6,8(a4)
    elm->next = next;
ffffffffc0201096:	f11c                	sd	a5,32(a0)
    elm->prev = prev;
ffffffffc0201098:	ed18                	sd	a4,24(a0)
ffffffffc020109a:	0141                	addi	sp,sp,16
    free_mem(base,size);
ffffffffc020109c:	b52d                	j	ffffffffc0200ec6 <free_mem>
    prev->next = next->prev = elm;
ffffffffc020109e:	0107b423          	sd	a6,8(a5)
    elm->next = next;
ffffffffc02010a2:	f110                	sd	a2,32(a0)
    return listelm->next;
ffffffffc02010a4:	6798                	ld	a4,8(a5)
    elm->prev = prev;
ffffffffc02010a6:	ed1c                	sd	a5,24(a0)
        while ((le = list_next(le)) != &free_list) {
ffffffffc02010a8:	00c70663          	beq	a4,a2,ffffffffc02010b4 <buddy_system_free_pages+0xc0>
    prev->next = next->prev = elm;
ffffffffc02010ac:	88c2                	mv	a7,a6
ffffffffc02010ae:	4685                	li	a3,1
    for (; p != base + size; p ++) {
ffffffffc02010b0:	87ba                	mv	a5,a4
ffffffffc02010b2:	b7e9                	j	ffffffffc020107c <buddy_system_free_pages+0x88>
}
ffffffffc02010b4:	60a2                	ld	ra,8(sp)
ffffffffc02010b6:	01063023          	sd	a6,0(a2)
ffffffffc02010ba:	0141                	addi	sp,sp,16
    free_mem(base,size);
ffffffffc02010bc:	b529                	j	ffffffffc0200ec6 <free_mem>
}
ffffffffc02010be:	60a2                	ld	ra,8(sp)
ffffffffc02010c0:	0107b023          	sd	a6,0(a5)
ffffffffc02010c4:	0107b423          	sd	a6,8(a5)
    elm->next = next;
ffffffffc02010c8:	f11c                	sd	a5,32(a0)
    elm->prev = prev;
ffffffffc02010ca:	ed1c                	sd	a5,24(a0)
ffffffffc02010cc:	0141                	addi	sp,sp,16
    free_mem(base,size);
ffffffffc02010ce:	bbe5                	j	ffffffffc0200ec6 <free_mem>
        assert(!PageReserved(p) && !PageProperty(p));
ffffffffc02010d0:	00001697          	auipc	a3,0x1
ffffffffc02010d4:	14868693          	addi	a3,a3,328 # ffffffffc0202218 <commands+0x6d8>
ffffffffc02010d8:	00001617          	auipc	a2,0x1
ffffffffc02010dc:	f6860613          	addi	a2,a2,-152 # ffffffffc0202040 <commands+0x500>
ffffffffc02010e0:	13c00593          	li	a1,316
ffffffffc02010e4:	00001517          	auipc	a0,0x1
ffffffffc02010e8:	f7450513          	addi	a0,a0,-140 # ffffffffc0202058 <commands+0x518>
ffffffffc02010ec:	84eff0ef          	jal	ra,ffffffffc020013a <__panic>
    assert(n > 0);
ffffffffc02010f0:	00001697          	auipc	a3,0x1
ffffffffc02010f4:	0a068693          	addi	a3,a3,160 # ffffffffc0202190 <commands+0x650>
ffffffffc02010f8:	00001617          	auipc	a2,0x1
ffffffffc02010fc:	f4860613          	addi	a2,a2,-184 # ffffffffc0202040 <commands+0x500>
ffffffffc0201100:	13400593          	li	a1,308
ffffffffc0201104:	00001517          	auipc	a0,0x1
ffffffffc0201108:	f5450513          	addi	a0,a0,-172 # ffffffffc0202058 <commands+0x518>
ffffffffc020110c:	82eff0ef          	jal	ra,ffffffffc020013a <__panic>

ffffffffc0201110 <alloc_pages>:
#include <defs.h>
#include <intr.h>
#include <riscv.h>

static inline bool __intr_save(void) {
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0201110:	100027f3          	csrr	a5,sstatus
ffffffffc0201114:	8b89                	andi	a5,a5,2
ffffffffc0201116:	e799                	bnez	a5,ffffffffc0201124 <alloc_pages+0x14>
struct Page *alloc_pages(size_t n) {
    struct Page *page = NULL;
    bool intr_flag;
    local_intr_save(intr_flag);
    {
        page = pmm_manager->alloc_pages(n);
ffffffffc0201118:	00005797          	auipc	a5,0x5
ffffffffc020111c:	3407b783          	ld	a5,832(a5) # ffffffffc0206458 <pmm_manager>
ffffffffc0201120:	6f9c                	ld	a5,24(a5)
ffffffffc0201122:	8782                	jr	a5
struct Page *alloc_pages(size_t n) {
ffffffffc0201124:	1141                	addi	sp,sp,-16
ffffffffc0201126:	e406                	sd	ra,8(sp)
ffffffffc0201128:	e022                	sd	s0,0(sp)
ffffffffc020112a:	842a                	mv	s0,a0
        intr_disable();
ffffffffc020112c:	b32ff0ef          	jal	ra,ffffffffc020045e <intr_disable>
        page = pmm_manager->alloc_pages(n);
ffffffffc0201130:	00005797          	auipc	a5,0x5
ffffffffc0201134:	3287b783          	ld	a5,808(a5) # ffffffffc0206458 <pmm_manager>
ffffffffc0201138:	6f9c                	ld	a5,24(a5)
ffffffffc020113a:	8522                	mv	a0,s0
ffffffffc020113c:	9782                	jalr	a5
ffffffffc020113e:	842a                	mv	s0,a0
    return 0;
}

static inline void __intr_restore(bool flag) {
    if (flag) {
        intr_enable();
ffffffffc0201140:	b18ff0ef          	jal	ra,ffffffffc0200458 <intr_enable>
    }
    local_intr_restore(intr_flag);
    return page;
}
ffffffffc0201144:	60a2                	ld	ra,8(sp)
ffffffffc0201146:	8522                	mv	a0,s0
ffffffffc0201148:	6402                	ld	s0,0(sp)
ffffffffc020114a:	0141                	addi	sp,sp,16
ffffffffc020114c:	8082                	ret

ffffffffc020114e <free_pages>:
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc020114e:	100027f3          	csrr	a5,sstatus
ffffffffc0201152:	8b89                	andi	a5,a5,2
ffffffffc0201154:	e799                	bnez	a5,ffffffffc0201162 <free_pages+0x14>
// free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory
void free_pages(struct Page *base, size_t n) {
    bool intr_flag;
    local_intr_save(intr_flag);
    {
        pmm_manager->free_pages(base, n);
ffffffffc0201156:	00005797          	auipc	a5,0x5
ffffffffc020115a:	3027b783          	ld	a5,770(a5) # ffffffffc0206458 <pmm_manager>
ffffffffc020115e:	739c                	ld	a5,32(a5)
ffffffffc0201160:	8782                	jr	a5
void free_pages(struct Page *base, size_t n) {
ffffffffc0201162:	1101                	addi	sp,sp,-32
ffffffffc0201164:	ec06                	sd	ra,24(sp)
ffffffffc0201166:	e822                	sd	s0,16(sp)
ffffffffc0201168:	e426                	sd	s1,8(sp)
ffffffffc020116a:	842a                	mv	s0,a0
ffffffffc020116c:	84ae                	mv	s1,a1
        intr_disable();
ffffffffc020116e:	af0ff0ef          	jal	ra,ffffffffc020045e <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc0201172:	00005797          	auipc	a5,0x5
ffffffffc0201176:	2e67b783          	ld	a5,742(a5) # ffffffffc0206458 <pmm_manager>
ffffffffc020117a:	739c                	ld	a5,32(a5)
ffffffffc020117c:	85a6                	mv	a1,s1
ffffffffc020117e:	8522                	mv	a0,s0
ffffffffc0201180:	9782                	jalr	a5
    }
    local_intr_restore(intr_flag);
}
ffffffffc0201182:	6442                	ld	s0,16(sp)
ffffffffc0201184:	60e2                	ld	ra,24(sp)
ffffffffc0201186:	64a2                	ld	s1,8(sp)
ffffffffc0201188:	6105                	addi	sp,sp,32
        intr_enable();
ffffffffc020118a:	aceff06f          	j	ffffffffc0200458 <intr_enable>

ffffffffc020118e <nr_free_pages>:
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc020118e:	100027f3          	csrr	a5,sstatus
ffffffffc0201192:	8b89                	andi	a5,a5,2
ffffffffc0201194:	e799                	bnez	a5,ffffffffc02011a2 <nr_free_pages+0x14>
size_t nr_free_pages(void) {
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
    {
        ret = pmm_manager->nr_free_pages();
ffffffffc0201196:	00005797          	auipc	a5,0x5
ffffffffc020119a:	2c27b783          	ld	a5,706(a5) # ffffffffc0206458 <pmm_manager>
ffffffffc020119e:	779c                	ld	a5,40(a5)
ffffffffc02011a0:	8782                	jr	a5
size_t nr_free_pages(void) {
ffffffffc02011a2:	1141                	addi	sp,sp,-16
ffffffffc02011a4:	e406                	sd	ra,8(sp)
ffffffffc02011a6:	e022                	sd	s0,0(sp)
        intr_disable();
ffffffffc02011a8:	ab6ff0ef          	jal	ra,ffffffffc020045e <intr_disable>
        ret = pmm_manager->nr_free_pages();
ffffffffc02011ac:	00005797          	auipc	a5,0x5
ffffffffc02011b0:	2ac7b783          	ld	a5,684(a5) # ffffffffc0206458 <pmm_manager>
ffffffffc02011b4:	779c                	ld	a5,40(a5)
ffffffffc02011b6:	9782                	jalr	a5
ffffffffc02011b8:	842a                	mv	s0,a0
        intr_enable();
ffffffffc02011ba:	a9eff0ef          	jal	ra,ffffffffc0200458 <intr_enable>
    }
    local_intr_restore(intr_flag);
    return ret;
}
ffffffffc02011be:	60a2                	ld	ra,8(sp)
ffffffffc02011c0:	8522                	mv	a0,s0
ffffffffc02011c2:	6402                	ld	s0,0(sp)
ffffffffc02011c4:	0141                	addi	sp,sp,16
ffffffffc02011c6:	8082                	ret

ffffffffc02011c8 <pmm_init>:
    pmm_manager = &buddy_system_pmm_manager;
ffffffffc02011c8:	00001797          	auipc	a5,0x1
ffffffffc02011cc:	09878793          	addi	a5,a5,152 # ffffffffc0202260 <buddy_system_pmm_manager>
    cprintf("memory management: %s\n", pmm_manager->name);
ffffffffc02011d0:	638c                	ld	a1,0(a5)




/* pmm_init - initialize the physical memory management */
void pmm_init(void) {
ffffffffc02011d2:	1101                	addi	sp,sp,-32
ffffffffc02011d4:	e822                	sd	s0,16(sp)
    cprintf("memory management: %s\n", pmm_manager->name);
ffffffffc02011d6:	00001517          	auipc	a0,0x1
ffffffffc02011da:	0c250513          	addi	a0,a0,194 # ffffffffc0202298 <buddy_system_pmm_manager+0x38>
    pmm_manager = &buddy_system_pmm_manager;
ffffffffc02011de:	00005417          	auipc	s0,0x5
ffffffffc02011e2:	27a40413          	addi	s0,s0,634 # ffffffffc0206458 <pmm_manager>
void pmm_init(void) {
ffffffffc02011e6:	ec06                	sd	ra,24(sp)
ffffffffc02011e8:	e426                	sd	s1,8(sp)
    pmm_manager = &buddy_system_pmm_manager;
ffffffffc02011ea:	e01c                	sd	a5,0(s0)
    cprintf("memory management: %s\n", pmm_manager->name);
ffffffffc02011ec:	ec7fe0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    pmm_manager->init();
ffffffffc02011f0:	601c                	ld	a5,0(s0)
    va_pa_offset = PHYSICAL_MEMORY_OFFSET;
ffffffffc02011f2:	00005497          	auipc	s1,0x5
ffffffffc02011f6:	27e48493          	addi	s1,s1,638 # ffffffffc0206470 <va_pa_offset>
    pmm_manager->init();
ffffffffc02011fa:	679c                	ld	a5,8(a5)
ffffffffc02011fc:	9782                	jalr	a5
    // Now the first_fit/best_fit/worst_fit/buddy_system pmm are available.
    init_pmm_manager();

    // detect physical memory space, reserve already used memory,
    // then use pmm->init_memmap to create free page list
    cprintf("init begin\n");
ffffffffc02011fe:	00001517          	auipc	a0,0x1
ffffffffc0201202:	0b250513          	addi	a0,a0,178 # ffffffffc02022b0 <buddy_system_pmm_manager+0x50>
ffffffffc0201206:	eadfe0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    va_pa_offset = PHYSICAL_MEMORY_OFFSET;
ffffffffc020120a:	57f5                	li	a5,-3
ffffffffc020120c:	07fa                	slli	a5,a5,0x1e
    cprintf("physcial memory map:\n");
ffffffffc020120e:	00001517          	auipc	a0,0x1
ffffffffc0201212:	0b250513          	addi	a0,a0,178 # ffffffffc02022c0 <buddy_system_pmm_manager+0x60>
    va_pa_offset = PHYSICAL_MEMORY_OFFSET;
ffffffffc0201216:	e09c                	sd	a5,0(s1)
    cprintf("physcial memory map:\n");
ffffffffc0201218:	e9bfe0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    cprintf("  memory: 0x%016lx, [0x%016lx, 0x%016lx].\n", mem_size, mem_begin,
ffffffffc020121c:	46c5                	li	a3,17
ffffffffc020121e:	06ee                	slli	a3,a3,0x1b
ffffffffc0201220:	40100613          	li	a2,1025
ffffffffc0201224:	16fd                	addi	a3,a3,-1
ffffffffc0201226:	07e005b7          	lui	a1,0x7e00
ffffffffc020122a:	0656                	slli	a2,a2,0x15
ffffffffc020122c:	00001517          	auipc	a0,0x1
ffffffffc0201230:	0ac50513          	addi	a0,a0,172 # ffffffffc02022d8 <buddy_system_pmm_manager+0x78>
ffffffffc0201234:	e7ffe0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
ffffffffc0201238:	777d                	lui	a4,0xfffff
ffffffffc020123a:	00006797          	auipc	a5,0x6
ffffffffc020123e:	24578793          	addi	a5,a5,581 # ffffffffc020747f <end+0xfff>
ffffffffc0201242:	8ff9                	and	a5,a5,a4
    npage = maxpa / PGSIZE;
ffffffffc0201244:	00005517          	auipc	a0,0x5
ffffffffc0201248:	20450513          	addi	a0,a0,516 # ffffffffc0206448 <npage>
ffffffffc020124c:	00088737          	lui	a4,0x88
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
ffffffffc0201250:	00005597          	auipc	a1,0x5
ffffffffc0201254:	20058593          	addi	a1,a1,512 # ffffffffc0206450 <pages>
    npage = maxpa / PGSIZE;
ffffffffc0201258:	e118                	sd	a4,0(a0)
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
ffffffffc020125a:	e19c                	sd	a5,0(a1)
ffffffffc020125c:	4681                	li	a3,0
    for (size_t i = 0; i < npage - nbase; i++) {
ffffffffc020125e:	4701                	li	a4,0
ffffffffc0201260:	4885                	li	a7,1
ffffffffc0201262:	fff80837          	lui	a6,0xfff80
ffffffffc0201266:	a011                	j	ffffffffc020126a <pmm_init+0xa2>
        SetPageReserved(pages + i);
ffffffffc0201268:	619c                	ld	a5,0(a1)
ffffffffc020126a:	97b6                	add	a5,a5,a3
ffffffffc020126c:	07a1                	addi	a5,a5,8
ffffffffc020126e:	4117b02f          	amoor.d	zero,a7,(a5)
    for (size_t i = 0; i < npage - nbase; i++) {
ffffffffc0201272:	611c                	ld	a5,0(a0)
ffffffffc0201274:	0705                	addi	a4,a4,1
ffffffffc0201276:	02868693          	addi	a3,a3,40
ffffffffc020127a:	01078633          	add	a2,a5,a6
ffffffffc020127e:	fec765e3          	bltu	a4,a2,ffffffffc0201268 <pmm_init+0xa0>
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc0201282:	6190                	ld	a2,0(a1)
ffffffffc0201284:	00279693          	slli	a3,a5,0x2
ffffffffc0201288:	96be                	add	a3,a3,a5
ffffffffc020128a:	fec00737          	lui	a4,0xfec00
ffffffffc020128e:	9732                	add	a4,a4,a2
ffffffffc0201290:	068e                	slli	a3,a3,0x3
ffffffffc0201292:	96ba                	add	a3,a3,a4
ffffffffc0201294:	c0200737          	lui	a4,0xc0200
ffffffffc0201298:	0ae6e563          	bltu	a3,a4,ffffffffc0201342 <pmm_init+0x17a>
ffffffffc020129c:	6098                	ld	a4,0(s1)
    if (freemem < mem_end) {
ffffffffc020129e:	45c5                	li	a1,17
ffffffffc02012a0:	05ee                	slli	a1,a1,0x1b
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc02012a2:	8e99                	sub	a3,a3,a4
    if (freemem < mem_end) {
ffffffffc02012a4:	04b6ee63          	bltu	a3,a1,ffffffffc0201300 <pmm_init+0x138>
    page_init();
    cprintf("init end\n");
ffffffffc02012a8:	00001517          	auipc	a0,0x1
ffffffffc02012ac:	0c850513          	addi	a0,a0,200 # ffffffffc0202370 <buddy_system_pmm_manager+0x110>
ffffffffc02012b0:	e03fe0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    satp_physical = PADDR(satp_virtual);
    cprintf("satp virtual address: 0x%016lx\nsatp physical address: 0x%016lx\n", satp_virtual, satp_physical);
}

static void check_alloc_page(void) {
    pmm_manager->check();
ffffffffc02012b4:	601c                	ld	a5,0(s0)
ffffffffc02012b6:	7b9c                	ld	a5,48(a5)
ffffffffc02012b8:	9782                	jalr	a5
    cprintf("check_alloc_page() succeeded!\n");
ffffffffc02012ba:	00001517          	auipc	a0,0x1
ffffffffc02012be:	0c650513          	addi	a0,a0,198 # ffffffffc0202380 <buddy_system_pmm_manager+0x120>
ffffffffc02012c2:	df1fe0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    satp_virtual = (pte_t*)boot_page_table_sv39;
ffffffffc02012c6:	00004597          	auipc	a1,0x4
ffffffffc02012ca:	d3a58593          	addi	a1,a1,-710 # ffffffffc0205000 <boot_page_table_sv39>
ffffffffc02012ce:	00005797          	auipc	a5,0x5
ffffffffc02012d2:	18b7bd23          	sd	a1,410(a5) # ffffffffc0206468 <satp_virtual>
    satp_physical = PADDR(satp_virtual);
ffffffffc02012d6:	c02007b7          	lui	a5,0xc0200
ffffffffc02012da:	08f5e063          	bltu	a1,a5,ffffffffc020135a <pmm_init+0x192>
ffffffffc02012de:	6090                	ld	a2,0(s1)
}
ffffffffc02012e0:	6442                	ld	s0,16(sp)
ffffffffc02012e2:	60e2                	ld	ra,24(sp)
ffffffffc02012e4:	64a2                	ld	s1,8(sp)
    satp_physical = PADDR(satp_virtual);
ffffffffc02012e6:	40c58633          	sub	a2,a1,a2
ffffffffc02012ea:	00005797          	auipc	a5,0x5
ffffffffc02012ee:	16c7bb23          	sd	a2,374(a5) # ffffffffc0206460 <satp_physical>
    cprintf("satp virtual address: 0x%016lx\nsatp physical address: 0x%016lx\n", satp_virtual, satp_physical);
ffffffffc02012f2:	00001517          	auipc	a0,0x1
ffffffffc02012f6:	0ae50513          	addi	a0,a0,174 # ffffffffc02023a0 <buddy_system_pmm_manager+0x140>
}
ffffffffc02012fa:	6105                	addi	sp,sp,32
    cprintf("satp virtual address: 0x%016lx\nsatp physical address: 0x%016lx\n", satp_virtual, satp_physical);
ffffffffc02012fc:	db7fe06f          	j	ffffffffc02000b2 <cprintf>
    mem_begin = ROUNDUP(freemem, PGSIZE);
ffffffffc0201300:	6705                	lui	a4,0x1
ffffffffc0201302:	177d                	addi	a4,a4,-1
ffffffffc0201304:	96ba                	add	a3,a3,a4
ffffffffc0201306:	777d                	lui	a4,0xfffff
ffffffffc0201308:	8ef9                	and	a3,a3,a4
static inline int page_ref_dec(struct Page *page) {
    page->ref -= 1;
    return page->ref;
}
static inline struct Page *pa2page(uintptr_t pa) {
    if (PPN(pa) >= npage) {
ffffffffc020130a:	00c6d513          	srli	a0,a3,0xc
ffffffffc020130e:	00f57e63          	bgeu	a0,a5,ffffffffc020132a <pmm_init+0x162>
    pmm_manager->init_memmap(base, n);
ffffffffc0201312:	601c                	ld	a5,0(s0)
        panic("pa2page called with invalid pa");
    }
    return &pages[PPN(pa) - nbase];
ffffffffc0201314:	982a                	add	a6,a6,a0
ffffffffc0201316:	00281513          	slli	a0,a6,0x2
ffffffffc020131a:	9542                	add	a0,a0,a6
ffffffffc020131c:	6b9c                	ld	a5,16(a5)
        init_memmap(pa2page(mem_begin), (mem_end - mem_begin) / PGSIZE);
ffffffffc020131e:	8d95                	sub	a1,a1,a3
ffffffffc0201320:	050e                	slli	a0,a0,0x3
    pmm_manager->init_memmap(base, n);
ffffffffc0201322:	81b1                	srli	a1,a1,0xc
ffffffffc0201324:	9532                	add	a0,a0,a2
ffffffffc0201326:	9782                	jalr	a5
}
ffffffffc0201328:	b741                	j	ffffffffc02012a8 <pmm_init+0xe0>
        panic("pa2page called with invalid pa");
ffffffffc020132a:	00001617          	auipc	a2,0x1
ffffffffc020132e:	01660613          	addi	a2,a2,22 # ffffffffc0202340 <buddy_system_pmm_manager+0xe0>
ffffffffc0201332:	06c00593          	li	a1,108
ffffffffc0201336:	00001517          	auipc	a0,0x1
ffffffffc020133a:	02a50513          	addi	a0,a0,42 # ffffffffc0202360 <buddy_system_pmm_manager+0x100>
ffffffffc020133e:	dfdfe0ef          	jal	ra,ffffffffc020013a <__panic>
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc0201342:	00001617          	auipc	a2,0x1
ffffffffc0201346:	fc660613          	addi	a2,a2,-58 # ffffffffc0202308 <buddy_system_pmm_manager+0xa8>
ffffffffc020134a:	06f00593          	li	a1,111
ffffffffc020134e:	00001517          	auipc	a0,0x1
ffffffffc0201352:	fe250513          	addi	a0,a0,-30 # ffffffffc0202330 <buddy_system_pmm_manager+0xd0>
ffffffffc0201356:	de5fe0ef          	jal	ra,ffffffffc020013a <__panic>
    satp_physical = PADDR(satp_virtual);
ffffffffc020135a:	86ae                	mv	a3,a1
ffffffffc020135c:	00001617          	auipc	a2,0x1
ffffffffc0201360:	fac60613          	addi	a2,a2,-84 # ffffffffc0202308 <buddy_system_pmm_manager+0xa8>
ffffffffc0201364:	09100593          	li	a1,145
ffffffffc0201368:	00001517          	auipc	a0,0x1
ffffffffc020136c:	fc850513          	addi	a0,a0,-56 # ffffffffc0202330 <buddy_system_pmm_manager+0xd0>
ffffffffc0201370:	dcbfe0ef          	jal	ra,ffffffffc020013a <__panic>

ffffffffc0201374 <strnlen>:
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
ffffffffc0201374:	4781                	li	a5,0
    while (cnt < len && *s ++ != '\0') {
ffffffffc0201376:	e589                	bnez	a1,ffffffffc0201380 <strnlen+0xc>
ffffffffc0201378:	a811                	j	ffffffffc020138c <strnlen+0x18>
        cnt ++;
ffffffffc020137a:	0785                	addi	a5,a5,1
    while (cnt < len && *s ++ != '\0') {
ffffffffc020137c:	00f58863          	beq	a1,a5,ffffffffc020138c <strnlen+0x18>
ffffffffc0201380:	00f50733          	add	a4,a0,a5
ffffffffc0201384:	00074703          	lbu	a4,0(a4) # fffffffffffff000 <end+0x3fdf8b80>
ffffffffc0201388:	fb6d                	bnez	a4,ffffffffc020137a <strnlen+0x6>
ffffffffc020138a:	85be                	mv	a1,a5
    }
    return cnt;
}
ffffffffc020138c:	852e                	mv	a0,a1
ffffffffc020138e:	8082                	ret

ffffffffc0201390 <strcmp>:
int
strcmp(const char *s1, const char *s2) {
#ifdef __HAVE_ARCH_STRCMP
    return __strcmp(s1, s2);
#else
    while (*s1 != '\0' && *s1 == *s2) {
ffffffffc0201390:	00054783          	lbu	a5,0(a0)
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc0201394:	0005c703          	lbu	a4,0(a1)
    while (*s1 != '\0' && *s1 == *s2) {
ffffffffc0201398:	cb89                	beqz	a5,ffffffffc02013aa <strcmp+0x1a>
        s1 ++, s2 ++;
ffffffffc020139a:	0505                	addi	a0,a0,1
ffffffffc020139c:	0585                	addi	a1,a1,1
    while (*s1 != '\0' && *s1 == *s2) {
ffffffffc020139e:	fee789e3          	beq	a5,a4,ffffffffc0201390 <strcmp>
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc02013a2:	0007851b          	sext.w	a0,a5
#endif /* __HAVE_ARCH_STRCMP */
}
ffffffffc02013a6:	9d19                	subw	a0,a0,a4
ffffffffc02013a8:	8082                	ret
ffffffffc02013aa:	4501                	li	a0,0
ffffffffc02013ac:	bfed                	j	ffffffffc02013a6 <strcmp+0x16>

ffffffffc02013ae <strchr>:
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
ffffffffc02013ae:	00054783          	lbu	a5,0(a0)
ffffffffc02013b2:	c799                	beqz	a5,ffffffffc02013c0 <strchr+0x12>
        if (*s == c) {
ffffffffc02013b4:	00f58763          	beq	a1,a5,ffffffffc02013c2 <strchr+0x14>
    while (*s != '\0') {
ffffffffc02013b8:	00154783          	lbu	a5,1(a0)
            return (char *)s;
        }
        s ++;
ffffffffc02013bc:	0505                	addi	a0,a0,1
    while (*s != '\0') {
ffffffffc02013be:	fbfd                	bnez	a5,ffffffffc02013b4 <strchr+0x6>
    }
    return NULL;
ffffffffc02013c0:	4501                	li	a0,0
}
ffffffffc02013c2:	8082                	ret

ffffffffc02013c4 <memset>:
memset(void *s, char c, size_t n) {
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
#else
    char *p = s;
    while (n -- > 0) {
ffffffffc02013c4:	ca01                	beqz	a2,ffffffffc02013d4 <memset+0x10>
ffffffffc02013c6:	962a                	add	a2,a2,a0
    char *p = s;
ffffffffc02013c8:	87aa                	mv	a5,a0
        *p ++ = c;
ffffffffc02013ca:	0785                	addi	a5,a5,1
ffffffffc02013cc:	feb78fa3          	sb	a1,-1(a5)
    while (n -- > 0) {
ffffffffc02013d0:	fec79de3          	bne	a5,a2,ffffffffc02013ca <memset+0x6>
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
ffffffffc02013d4:	8082                	ret

ffffffffc02013d6 <printnum>:
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
    unsigned long long result = num;
    unsigned mod = do_div(result, base);
ffffffffc02013d6:	02069813          	slli	a6,a3,0x20
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc02013da:	7179                	addi	sp,sp,-48
    unsigned mod = do_div(result, base);
ffffffffc02013dc:	02085813          	srli	a6,a6,0x20
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc02013e0:	e052                	sd	s4,0(sp)
    unsigned mod = do_div(result, base);
ffffffffc02013e2:	03067a33          	remu	s4,a2,a6
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc02013e6:	f022                	sd	s0,32(sp)
ffffffffc02013e8:	ec26                	sd	s1,24(sp)
ffffffffc02013ea:	e84a                	sd	s2,16(sp)
ffffffffc02013ec:	f406                	sd	ra,40(sp)
ffffffffc02013ee:	e44e                	sd	s3,8(sp)
ffffffffc02013f0:	84aa                	mv	s1,a0
ffffffffc02013f2:	892e                	mv	s2,a1
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
ffffffffc02013f4:	fff7041b          	addiw	s0,a4,-1
    unsigned mod = do_div(result, base);
ffffffffc02013f8:	2a01                	sext.w	s4,s4
    if (num >= base) {
ffffffffc02013fa:	03067e63          	bgeu	a2,a6,ffffffffc0201436 <printnum+0x60>
ffffffffc02013fe:	89be                	mv	s3,a5
        while (-- width > 0)
ffffffffc0201400:	00805763          	blez	s0,ffffffffc020140e <printnum+0x38>
ffffffffc0201404:	347d                	addiw	s0,s0,-1
            putch(padc, putdat);
ffffffffc0201406:	85ca                	mv	a1,s2
ffffffffc0201408:	854e                	mv	a0,s3
ffffffffc020140a:	9482                	jalr	s1
        while (-- width > 0)
ffffffffc020140c:	fc65                	bnez	s0,ffffffffc0201404 <printnum+0x2e>
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
ffffffffc020140e:	1a02                	slli	s4,s4,0x20
ffffffffc0201410:	00001797          	auipc	a5,0x1
ffffffffc0201414:	fd078793          	addi	a5,a5,-48 # ffffffffc02023e0 <buddy_system_pmm_manager+0x180>
ffffffffc0201418:	020a5a13          	srli	s4,s4,0x20
ffffffffc020141c:	9a3e                	add	s4,s4,a5
}
ffffffffc020141e:	7402                	ld	s0,32(sp)
    putch("0123456789abcdef"[mod], putdat);
ffffffffc0201420:	000a4503          	lbu	a0,0(s4)
}
ffffffffc0201424:	70a2                	ld	ra,40(sp)
ffffffffc0201426:	69a2                	ld	s3,8(sp)
ffffffffc0201428:	6a02                	ld	s4,0(sp)
    putch("0123456789abcdef"[mod], putdat);
ffffffffc020142a:	85ca                	mv	a1,s2
ffffffffc020142c:	87a6                	mv	a5,s1
}
ffffffffc020142e:	6942                	ld	s2,16(sp)
ffffffffc0201430:	64e2                	ld	s1,24(sp)
ffffffffc0201432:	6145                	addi	sp,sp,48
    putch("0123456789abcdef"[mod], putdat);
ffffffffc0201434:	8782                	jr	a5
        printnum(putch, putdat, result, base, width - 1, padc);
ffffffffc0201436:	03065633          	divu	a2,a2,a6
ffffffffc020143a:	8722                	mv	a4,s0
ffffffffc020143c:	f9bff0ef          	jal	ra,ffffffffc02013d6 <printnum>
ffffffffc0201440:	b7f9                	j	ffffffffc020140e <printnum+0x38>

ffffffffc0201442 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
ffffffffc0201442:	7119                	addi	sp,sp,-128
ffffffffc0201444:	f4a6                	sd	s1,104(sp)
ffffffffc0201446:	f0ca                	sd	s2,96(sp)
ffffffffc0201448:	ecce                	sd	s3,88(sp)
ffffffffc020144a:	e8d2                	sd	s4,80(sp)
ffffffffc020144c:	e4d6                	sd	s5,72(sp)
ffffffffc020144e:	e0da                	sd	s6,64(sp)
ffffffffc0201450:	fc5e                	sd	s7,56(sp)
ffffffffc0201452:	f06a                	sd	s10,32(sp)
ffffffffc0201454:	fc86                	sd	ra,120(sp)
ffffffffc0201456:	f8a2                	sd	s0,112(sp)
ffffffffc0201458:	f862                	sd	s8,48(sp)
ffffffffc020145a:	f466                	sd	s9,40(sp)
ffffffffc020145c:	ec6e                	sd	s11,24(sp)
ffffffffc020145e:	892a                	mv	s2,a0
ffffffffc0201460:	84ae                	mv	s1,a1
ffffffffc0201462:	8d32                	mv	s10,a2
ffffffffc0201464:	8a36                	mv	s4,a3
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc0201466:	02500993          	li	s3,37
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
        width = precision = -1;
ffffffffc020146a:	5b7d                	li	s6,-1
ffffffffc020146c:	00001a97          	auipc	s5,0x1
ffffffffc0201470:	fa8a8a93          	addi	s5,s5,-88 # ffffffffc0202414 <buddy_system_pmm_manager+0x1b4>
        case 'e':
            err = va_arg(ap, int);
            if (err < 0) {
                err = -err;
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
ffffffffc0201474:	00001b97          	auipc	s7,0x1
ffffffffc0201478:	17cb8b93          	addi	s7,s7,380 # ffffffffc02025f0 <error_string>
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc020147c:	000d4503          	lbu	a0,0(s10)
ffffffffc0201480:	001d0413          	addi	s0,s10,1
ffffffffc0201484:	01350a63          	beq	a0,s3,ffffffffc0201498 <vprintfmt+0x56>
            if (ch == '\0') {
ffffffffc0201488:	c121                	beqz	a0,ffffffffc02014c8 <vprintfmt+0x86>
            putch(ch, putdat);
ffffffffc020148a:	85a6                	mv	a1,s1
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc020148c:	0405                	addi	s0,s0,1
            putch(ch, putdat);
ffffffffc020148e:	9902                	jalr	s2
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc0201490:	fff44503          	lbu	a0,-1(s0)
ffffffffc0201494:	ff351ae3          	bne	a0,s3,ffffffffc0201488 <vprintfmt+0x46>
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0201498:	00044603          	lbu	a2,0(s0)
        char padc = ' ';
ffffffffc020149c:	02000793          	li	a5,32
        lflag = altflag = 0;
ffffffffc02014a0:	4c81                	li	s9,0
ffffffffc02014a2:	4881                	li	a7,0
        width = precision = -1;
ffffffffc02014a4:	5c7d                	li	s8,-1
ffffffffc02014a6:	5dfd                	li	s11,-1
ffffffffc02014a8:	05500513          	li	a0,85
                if (ch < '0' || ch > '9') {
ffffffffc02014ac:	4825                	li	a6,9
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc02014ae:	fdd6059b          	addiw	a1,a2,-35
ffffffffc02014b2:	0ff5f593          	zext.b	a1,a1
ffffffffc02014b6:	00140d13          	addi	s10,s0,1
ffffffffc02014ba:	04b56263          	bltu	a0,a1,ffffffffc02014fe <vprintfmt+0xbc>
ffffffffc02014be:	058a                	slli	a1,a1,0x2
ffffffffc02014c0:	95d6                	add	a1,a1,s5
ffffffffc02014c2:	4194                	lw	a3,0(a1)
ffffffffc02014c4:	96d6                	add	a3,a3,s5
ffffffffc02014c6:	8682                	jr	a3
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
ffffffffc02014c8:	70e6                	ld	ra,120(sp)
ffffffffc02014ca:	7446                	ld	s0,112(sp)
ffffffffc02014cc:	74a6                	ld	s1,104(sp)
ffffffffc02014ce:	7906                	ld	s2,96(sp)
ffffffffc02014d0:	69e6                	ld	s3,88(sp)
ffffffffc02014d2:	6a46                	ld	s4,80(sp)
ffffffffc02014d4:	6aa6                	ld	s5,72(sp)
ffffffffc02014d6:	6b06                	ld	s6,64(sp)
ffffffffc02014d8:	7be2                	ld	s7,56(sp)
ffffffffc02014da:	7c42                	ld	s8,48(sp)
ffffffffc02014dc:	7ca2                	ld	s9,40(sp)
ffffffffc02014de:	7d02                	ld	s10,32(sp)
ffffffffc02014e0:	6de2                	ld	s11,24(sp)
ffffffffc02014e2:	6109                	addi	sp,sp,128
ffffffffc02014e4:	8082                	ret
            padc = '0';
ffffffffc02014e6:	87b2                	mv	a5,a2
            goto reswitch;
ffffffffc02014e8:	00144603          	lbu	a2,1(s0)
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc02014ec:	846a                	mv	s0,s10
ffffffffc02014ee:	00140d13          	addi	s10,s0,1
ffffffffc02014f2:	fdd6059b          	addiw	a1,a2,-35
ffffffffc02014f6:	0ff5f593          	zext.b	a1,a1
ffffffffc02014fa:	fcb572e3          	bgeu	a0,a1,ffffffffc02014be <vprintfmt+0x7c>
            putch('%', putdat);
ffffffffc02014fe:	85a6                	mv	a1,s1
ffffffffc0201500:	02500513          	li	a0,37
ffffffffc0201504:	9902                	jalr	s2
            for (fmt --; fmt[-1] != '%'; fmt --)
ffffffffc0201506:	fff44783          	lbu	a5,-1(s0)
ffffffffc020150a:	8d22                	mv	s10,s0
ffffffffc020150c:	f73788e3          	beq	a5,s3,ffffffffc020147c <vprintfmt+0x3a>
ffffffffc0201510:	ffed4783          	lbu	a5,-2(s10)
ffffffffc0201514:	1d7d                	addi	s10,s10,-1
ffffffffc0201516:	ff379de3          	bne	a5,s3,ffffffffc0201510 <vprintfmt+0xce>
ffffffffc020151a:	b78d                	j	ffffffffc020147c <vprintfmt+0x3a>
                precision = precision * 10 + ch - '0';
ffffffffc020151c:	fd060c1b          	addiw	s8,a2,-48
                ch = *fmt;
ffffffffc0201520:	00144603          	lbu	a2,1(s0)
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0201524:	846a                	mv	s0,s10
                if (ch < '0' || ch > '9') {
ffffffffc0201526:	fd06069b          	addiw	a3,a2,-48
                ch = *fmt;
ffffffffc020152a:	0006059b          	sext.w	a1,a2
                if (ch < '0' || ch > '9') {
ffffffffc020152e:	02d86463          	bltu	a6,a3,ffffffffc0201556 <vprintfmt+0x114>
                ch = *fmt;
ffffffffc0201532:	00144603          	lbu	a2,1(s0)
                precision = precision * 10 + ch - '0';
ffffffffc0201536:	002c169b          	slliw	a3,s8,0x2
ffffffffc020153a:	0186873b          	addw	a4,a3,s8
ffffffffc020153e:	0017171b          	slliw	a4,a4,0x1
ffffffffc0201542:	9f2d                	addw	a4,a4,a1
                if (ch < '0' || ch > '9') {
ffffffffc0201544:	fd06069b          	addiw	a3,a2,-48
            for (precision = 0; ; ++ fmt) {
ffffffffc0201548:	0405                	addi	s0,s0,1
                precision = precision * 10 + ch - '0';
ffffffffc020154a:	fd070c1b          	addiw	s8,a4,-48
                ch = *fmt;
ffffffffc020154e:	0006059b          	sext.w	a1,a2
                if (ch < '0' || ch > '9') {
ffffffffc0201552:	fed870e3          	bgeu	a6,a3,ffffffffc0201532 <vprintfmt+0xf0>
            if (width < 0)
ffffffffc0201556:	f40ddce3          	bgez	s11,ffffffffc02014ae <vprintfmt+0x6c>
                width = precision, precision = -1;
ffffffffc020155a:	8de2                	mv	s11,s8
ffffffffc020155c:	5c7d                	li	s8,-1
ffffffffc020155e:	bf81                	j	ffffffffc02014ae <vprintfmt+0x6c>
            if (width < 0)
ffffffffc0201560:	fffdc693          	not	a3,s11
ffffffffc0201564:	96fd                	srai	a3,a3,0x3f
ffffffffc0201566:	00ddfdb3          	and	s11,s11,a3
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc020156a:	00144603          	lbu	a2,1(s0)
ffffffffc020156e:	2d81                	sext.w	s11,s11
ffffffffc0201570:	846a                	mv	s0,s10
            goto reswitch;
ffffffffc0201572:	bf35                	j	ffffffffc02014ae <vprintfmt+0x6c>
            precision = va_arg(ap, int);
ffffffffc0201574:	000a2c03          	lw	s8,0(s4)
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0201578:	00144603          	lbu	a2,1(s0)
            precision = va_arg(ap, int);
ffffffffc020157c:	0a21                	addi	s4,s4,8
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc020157e:	846a                	mv	s0,s10
            goto process_precision;
ffffffffc0201580:	bfd9                	j	ffffffffc0201556 <vprintfmt+0x114>
    if (lflag >= 2) {
ffffffffc0201582:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc0201584:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
ffffffffc0201588:	01174463          	blt	a4,a7,ffffffffc0201590 <vprintfmt+0x14e>
    else if (lflag) {
ffffffffc020158c:	1a088e63          	beqz	a7,ffffffffc0201748 <vprintfmt+0x306>
        return va_arg(*ap, unsigned long);
ffffffffc0201590:	000a3603          	ld	a2,0(s4)
ffffffffc0201594:	46c1                	li	a3,16
ffffffffc0201596:	8a2e                	mv	s4,a1
            printnum(putch, putdat, num, base, width, padc);
ffffffffc0201598:	2781                	sext.w	a5,a5
ffffffffc020159a:	876e                	mv	a4,s11
ffffffffc020159c:	85a6                	mv	a1,s1
ffffffffc020159e:	854a                	mv	a0,s2
ffffffffc02015a0:	e37ff0ef          	jal	ra,ffffffffc02013d6 <printnum>
            break;
ffffffffc02015a4:	bde1                	j	ffffffffc020147c <vprintfmt+0x3a>
            putch(va_arg(ap, int), putdat);
ffffffffc02015a6:	000a2503          	lw	a0,0(s4)
ffffffffc02015aa:	85a6                	mv	a1,s1
ffffffffc02015ac:	0a21                	addi	s4,s4,8
ffffffffc02015ae:	9902                	jalr	s2
            break;
ffffffffc02015b0:	b5f1                	j	ffffffffc020147c <vprintfmt+0x3a>
    if (lflag >= 2) {
ffffffffc02015b2:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc02015b4:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
ffffffffc02015b8:	01174463          	blt	a4,a7,ffffffffc02015c0 <vprintfmt+0x17e>
    else if (lflag) {
ffffffffc02015bc:	18088163          	beqz	a7,ffffffffc020173e <vprintfmt+0x2fc>
        return va_arg(*ap, unsigned long);
ffffffffc02015c0:	000a3603          	ld	a2,0(s4)
ffffffffc02015c4:	46a9                	li	a3,10
ffffffffc02015c6:	8a2e                	mv	s4,a1
ffffffffc02015c8:	bfc1                	j	ffffffffc0201598 <vprintfmt+0x156>
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc02015ca:	00144603          	lbu	a2,1(s0)
            altflag = 1;
ffffffffc02015ce:	4c85                	li	s9,1
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc02015d0:	846a                	mv	s0,s10
            goto reswitch;
ffffffffc02015d2:	bdf1                	j	ffffffffc02014ae <vprintfmt+0x6c>
            putch(ch, putdat);
ffffffffc02015d4:	85a6                	mv	a1,s1
ffffffffc02015d6:	02500513          	li	a0,37
ffffffffc02015da:	9902                	jalr	s2
            break;
ffffffffc02015dc:	b545                	j	ffffffffc020147c <vprintfmt+0x3a>
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc02015de:	00144603          	lbu	a2,1(s0)
            lflag ++;
ffffffffc02015e2:	2885                	addiw	a7,a7,1
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc02015e4:	846a                	mv	s0,s10
            goto reswitch;
ffffffffc02015e6:	b5e1                	j	ffffffffc02014ae <vprintfmt+0x6c>
    if (lflag >= 2) {
ffffffffc02015e8:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc02015ea:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
ffffffffc02015ee:	01174463          	blt	a4,a7,ffffffffc02015f6 <vprintfmt+0x1b4>
    else if (lflag) {
ffffffffc02015f2:	14088163          	beqz	a7,ffffffffc0201734 <vprintfmt+0x2f2>
        return va_arg(*ap, unsigned long);
ffffffffc02015f6:	000a3603          	ld	a2,0(s4)
ffffffffc02015fa:	46a1                	li	a3,8
ffffffffc02015fc:	8a2e                	mv	s4,a1
ffffffffc02015fe:	bf69                	j	ffffffffc0201598 <vprintfmt+0x156>
            putch('0', putdat);
ffffffffc0201600:	03000513          	li	a0,48
ffffffffc0201604:	85a6                	mv	a1,s1
ffffffffc0201606:	e03e                	sd	a5,0(sp)
ffffffffc0201608:	9902                	jalr	s2
            putch('x', putdat);
ffffffffc020160a:	85a6                	mv	a1,s1
ffffffffc020160c:	07800513          	li	a0,120
ffffffffc0201610:	9902                	jalr	s2
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
ffffffffc0201612:	0a21                	addi	s4,s4,8
            goto number;
ffffffffc0201614:	6782                	ld	a5,0(sp)
ffffffffc0201616:	46c1                	li	a3,16
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
ffffffffc0201618:	ff8a3603          	ld	a2,-8(s4)
            goto number;
ffffffffc020161c:	bfb5                	j	ffffffffc0201598 <vprintfmt+0x156>
            if ((p = va_arg(ap, char *)) == NULL) {
ffffffffc020161e:	000a3403          	ld	s0,0(s4)
ffffffffc0201622:	008a0713          	addi	a4,s4,8
ffffffffc0201626:	e03a                	sd	a4,0(sp)
ffffffffc0201628:	14040263          	beqz	s0,ffffffffc020176c <vprintfmt+0x32a>
            if (width > 0 && padc != '-') {
ffffffffc020162c:	0fb05763          	blez	s11,ffffffffc020171a <vprintfmt+0x2d8>
ffffffffc0201630:	02d00693          	li	a3,45
ffffffffc0201634:	0cd79163          	bne	a5,a3,ffffffffc02016f6 <vprintfmt+0x2b4>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0201638:	00044783          	lbu	a5,0(s0)
ffffffffc020163c:	0007851b          	sext.w	a0,a5
ffffffffc0201640:	cf85                	beqz	a5,ffffffffc0201678 <vprintfmt+0x236>
ffffffffc0201642:	00140a13          	addi	s4,s0,1
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc0201646:	05e00413          	li	s0,94
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc020164a:	000c4563          	bltz	s8,ffffffffc0201654 <vprintfmt+0x212>
ffffffffc020164e:	3c7d                	addiw	s8,s8,-1
ffffffffc0201650:	036c0263          	beq	s8,s6,ffffffffc0201674 <vprintfmt+0x232>
                    putch('?', putdat);
ffffffffc0201654:	85a6                	mv	a1,s1
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc0201656:	0e0c8e63          	beqz	s9,ffffffffc0201752 <vprintfmt+0x310>
ffffffffc020165a:	3781                	addiw	a5,a5,-32
ffffffffc020165c:	0ef47b63          	bgeu	s0,a5,ffffffffc0201752 <vprintfmt+0x310>
                    putch('?', putdat);
ffffffffc0201660:	03f00513          	li	a0,63
ffffffffc0201664:	9902                	jalr	s2
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0201666:	000a4783          	lbu	a5,0(s4)
ffffffffc020166a:	3dfd                	addiw	s11,s11,-1
ffffffffc020166c:	0a05                	addi	s4,s4,1
ffffffffc020166e:	0007851b          	sext.w	a0,a5
ffffffffc0201672:	ffe1                	bnez	a5,ffffffffc020164a <vprintfmt+0x208>
            for (; width > 0; width --) {
ffffffffc0201674:	01b05963          	blez	s11,ffffffffc0201686 <vprintfmt+0x244>
ffffffffc0201678:	3dfd                	addiw	s11,s11,-1
                putch(' ', putdat);
ffffffffc020167a:	85a6                	mv	a1,s1
ffffffffc020167c:	02000513          	li	a0,32
ffffffffc0201680:	9902                	jalr	s2
            for (; width > 0; width --) {
ffffffffc0201682:	fe0d9be3          	bnez	s11,ffffffffc0201678 <vprintfmt+0x236>
            if ((p = va_arg(ap, char *)) == NULL) {
ffffffffc0201686:	6a02                	ld	s4,0(sp)
ffffffffc0201688:	bbd5                	j	ffffffffc020147c <vprintfmt+0x3a>
    if (lflag >= 2) {
ffffffffc020168a:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc020168c:	008a0c93          	addi	s9,s4,8
    if (lflag >= 2) {
ffffffffc0201690:	01174463          	blt	a4,a7,ffffffffc0201698 <vprintfmt+0x256>
    else if (lflag) {
ffffffffc0201694:	08088d63          	beqz	a7,ffffffffc020172e <vprintfmt+0x2ec>
        return va_arg(*ap, long);
ffffffffc0201698:	000a3403          	ld	s0,0(s4)
            if ((long long)num < 0) {
ffffffffc020169c:	0a044d63          	bltz	s0,ffffffffc0201756 <vprintfmt+0x314>
            num = getint(&ap, lflag);
ffffffffc02016a0:	8622                	mv	a2,s0
ffffffffc02016a2:	8a66                	mv	s4,s9
ffffffffc02016a4:	46a9                	li	a3,10
ffffffffc02016a6:	bdcd                	j	ffffffffc0201598 <vprintfmt+0x156>
            err = va_arg(ap, int);
ffffffffc02016a8:	000a2783          	lw	a5,0(s4)
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
ffffffffc02016ac:	4719                	li	a4,6
            err = va_arg(ap, int);
ffffffffc02016ae:	0a21                	addi	s4,s4,8
            if (err < 0) {
ffffffffc02016b0:	41f7d69b          	sraiw	a3,a5,0x1f
ffffffffc02016b4:	8fb5                	xor	a5,a5,a3
ffffffffc02016b6:	40d786bb          	subw	a3,a5,a3
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
ffffffffc02016ba:	02d74163          	blt	a4,a3,ffffffffc02016dc <vprintfmt+0x29a>
ffffffffc02016be:	00369793          	slli	a5,a3,0x3
ffffffffc02016c2:	97de                	add	a5,a5,s7
ffffffffc02016c4:	639c                	ld	a5,0(a5)
ffffffffc02016c6:	cb99                	beqz	a5,ffffffffc02016dc <vprintfmt+0x29a>
                printfmt(putch, putdat, "%s", p);
ffffffffc02016c8:	86be                	mv	a3,a5
ffffffffc02016ca:	00001617          	auipc	a2,0x1
ffffffffc02016ce:	d4660613          	addi	a2,a2,-698 # ffffffffc0202410 <buddy_system_pmm_manager+0x1b0>
ffffffffc02016d2:	85a6                	mv	a1,s1
ffffffffc02016d4:	854a                	mv	a0,s2
ffffffffc02016d6:	0ce000ef          	jal	ra,ffffffffc02017a4 <printfmt>
ffffffffc02016da:	b34d                	j	ffffffffc020147c <vprintfmt+0x3a>
                printfmt(putch, putdat, "error %d", err);
ffffffffc02016dc:	00001617          	auipc	a2,0x1
ffffffffc02016e0:	d2460613          	addi	a2,a2,-732 # ffffffffc0202400 <buddy_system_pmm_manager+0x1a0>
ffffffffc02016e4:	85a6                	mv	a1,s1
ffffffffc02016e6:	854a                	mv	a0,s2
ffffffffc02016e8:	0bc000ef          	jal	ra,ffffffffc02017a4 <printfmt>
ffffffffc02016ec:	bb41                	j	ffffffffc020147c <vprintfmt+0x3a>
                p = "(null)";
ffffffffc02016ee:	00001417          	auipc	s0,0x1
ffffffffc02016f2:	d0a40413          	addi	s0,s0,-758 # ffffffffc02023f8 <buddy_system_pmm_manager+0x198>
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc02016f6:	85e2                	mv	a1,s8
ffffffffc02016f8:	8522                	mv	a0,s0
ffffffffc02016fa:	e43e                	sd	a5,8(sp)
ffffffffc02016fc:	c79ff0ef          	jal	ra,ffffffffc0201374 <strnlen>
ffffffffc0201700:	40ad8dbb          	subw	s11,s11,a0
ffffffffc0201704:	01b05b63          	blez	s11,ffffffffc020171a <vprintfmt+0x2d8>
                    putch(padc, putdat);
ffffffffc0201708:	67a2                	ld	a5,8(sp)
ffffffffc020170a:	00078a1b          	sext.w	s4,a5
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc020170e:	3dfd                	addiw	s11,s11,-1
                    putch(padc, putdat);
ffffffffc0201710:	85a6                	mv	a1,s1
ffffffffc0201712:	8552                	mv	a0,s4
ffffffffc0201714:	9902                	jalr	s2
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc0201716:	fe0d9ce3          	bnez	s11,ffffffffc020170e <vprintfmt+0x2cc>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc020171a:	00044783          	lbu	a5,0(s0)
ffffffffc020171e:	00140a13          	addi	s4,s0,1
ffffffffc0201722:	0007851b          	sext.w	a0,a5
ffffffffc0201726:	d3a5                	beqz	a5,ffffffffc0201686 <vprintfmt+0x244>
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc0201728:	05e00413          	li	s0,94
ffffffffc020172c:	bf39                	j	ffffffffc020164a <vprintfmt+0x208>
        return va_arg(*ap, int);
ffffffffc020172e:	000a2403          	lw	s0,0(s4)
ffffffffc0201732:	b7ad                	j	ffffffffc020169c <vprintfmt+0x25a>
        return va_arg(*ap, unsigned int);
ffffffffc0201734:	000a6603          	lwu	a2,0(s4)
ffffffffc0201738:	46a1                	li	a3,8
ffffffffc020173a:	8a2e                	mv	s4,a1
ffffffffc020173c:	bdb1                	j	ffffffffc0201598 <vprintfmt+0x156>
ffffffffc020173e:	000a6603          	lwu	a2,0(s4)
ffffffffc0201742:	46a9                	li	a3,10
ffffffffc0201744:	8a2e                	mv	s4,a1
ffffffffc0201746:	bd89                	j	ffffffffc0201598 <vprintfmt+0x156>
ffffffffc0201748:	000a6603          	lwu	a2,0(s4)
ffffffffc020174c:	46c1                	li	a3,16
ffffffffc020174e:	8a2e                	mv	s4,a1
ffffffffc0201750:	b5a1                	j	ffffffffc0201598 <vprintfmt+0x156>
                    putch(ch, putdat);
ffffffffc0201752:	9902                	jalr	s2
ffffffffc0201754:	bf09                	j	ffffffffc0201666 <vprintfmt+0x224>
                putch('-', putdat);
ffffffffc0201756:	85a6                	mv	a1,s1
ffffffffc0201758:	02d00513          	li	a0,45
ffffffffc020175c:	e03e                	sd	a5,0(sp)
ffffffffc020175e:	9902                	jalr	s2
                num = -(long long)num;
ffffffffc0201760:	6782                	ld	a5,0(sp)
ffffffffc0201762:	8a66                	mv	s4,s9
ffffffffc0201764:	40800633          	neg	a2,s0
ffffffffc0201768:	46a9                	li	a3,10
ffffffffc020176a:	b53d                	j	ffffffffc0201598 <vprintfmt+0x156>
            if (width > 0 && padc != '-') {
ffffffffc020176c:	03b05163          	blez	s11,ffffffffc020178e <vprintfmt+0x34c>
ffffffffc0201770:	02d00693          	li	a3,45
ffffffffc0201774:	f6d79de3          	bne	a5,a3,ffffffffc02016ee <vprintfmt+0x2ac>
                p = "(null)";
ffffffffc0201778:	00001417          	auipc	s0,0x1
ffffffffc020177c:	c8040413          	addi	s0,s0,-896 # ffffffffc02023f8 <buddy_system_pmm_manager+0x198>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0201780:	02800793          	li	a5,40
ffffffffc0201784:	02800513          	li	a0,40
ffffffffc0201788:	00140a13          	addi	s4,s0,1
ffffffffc020178c:	bd6d                	j	ffffffffc0201646 <vprintfmt+0x204>
ffffffffc020178e:	00001a17          	auipc	s4,0x1
ffffffffc0201792:	c6ba0a13          	addi	s4,s4,-917 # ffffffffc02023f9 <buddy_system_pmm_manager+0x199>
ffffffffc0201796:	02800513          	li	a0,40
ffffffffc020179a:	02800793          	li	a5,40
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc020179e:	05e00413          	li	s0,94
ffffffffc02017a2:	b565                	j	ffffffffc020164a <vprintfmt+0x208>

ffffffffc02017a4 <printfmt>:
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
ffffffffc02017a4:	715d                	addi	sp,sp,-80
    va_start(ap, fmt);
ffffffffc02017a6:	02810313          	addi	t1,sp,40
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
ffffffffc02017aa:	f436                	sd	a3,40(sp)
    vprintfmt(putch, putdat, fmt, ap);
ffffffffc02017ac:	869a                	mv	a3,t1
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
ffffffffc02017ae:	ec06                	sd	ra,24(sp)
ffffffffc02017b0:	f83a                	sd	a4,48(sp)
ffffffffc02017b2:	fc3e                	sd	a5,56(sp)
ffffffffc02017b4:	e0c2                	sd	a6,64(sp)
ffffffffc02017b6:	e4c6                	sd	a7,72(sp)
    va_start(ap, fmt);
ffffffffc02017b8:	e41a                	sd	t1,8(sp)
    vprintfmt(putch, putdat, fmt, ap);
ffffffffc02017ba:	c89ff0ef          	jal	ra,ffffffffc0201442 <vprintfmt>
}
ffffffffc02017be:	60e2                	ld	ra,24(sp)
ffffffffc02017c0:	6161                	addi	sp,sp,80
ffffffffc02017c2:	8082                	ret

ffffffffc02017c4 <sbi_console_putchar>:
uint64_t SBI_REMOTE_SFENCE_VMA_ASID = 7;
uint64_t SBI_SHUTDOWN = 8;

uint64_t sbi_call(uint64_t sbi_type, uint64_t arg0, uint64_t arg1, uint64_t arg2) {
    uint64_t ret_val;
    __asm__ volatile (
ffffffffc02017c4:	4781                	li	a5,0
ffffffffc02017c6:	00005717          	auipc	a4,0x5
ffffffffc02017ca:	84273703          	ld	a4,-1982(a4) # ffffffffc0206008 <SBI_CONSOLE_PUTCHAR>
ffffffffc02017ce:	88ba                	mv	a7,a4
ffffffffc02017d0:	852a                	mv	a0,a0
ffffffffc02017d2:	85be                	mv	a1,a5
ffffffffc02017d4:	863e                	mv	a2,a5
ffffffffc02017d6:	00000073          	ecall
ffffffffc02017da:	87aa                	mv	a5,a0
    return ret_val;
}

void sbi_console_putchar(unsigned char ch) {
    sbi_call(SBI_CONSOLE_PUTCHAR, ch, 0, 0);
}
ffffffffc02017dc:	8082                	ret

ffffffffc02017de <sbi_set_timer>:
    __asm__ volatile (
ffffffffc02017de:	4781                	li	a5,0
ffffffffc02017e0:	00005717          	auipc	a4,0x5
ffffffffc02017e4:	c9873703          	ld	a4,-872(a4) # ffffffffc0206478 <SBI_SET_TIMER>
ffffffffc02017e8:	88ba                	mv	a7,a4
ffffffffc02017ea:	852a                	mv	a0,a0
ffffffffc02017ec:	85be                	mv	a1,a5
ffffffffc02017ee:	863e                	mv	a2,a5
ffffffffc02017f0:	00000073          	ecall
ffffffffc02017f4:	87aa                	mv	a5,a0

void sbi_set_timer(unsigned long long stime_value) {
    sbi_call(SBI_SET_TIMER, stime_value, 0, 0);
}
ffffffffc02017f6:	8082                	ret

ffffffffc02017f8 <sbi_console_getchar>:
    __asm__ volatile (
ffffffffc02017f8:	4501                	li	a0,0
ffffffffc02017fa:	00005797          	auipc	a5,0x5
ffffffffc02017fe:	8067b783          	ld	a5,-2042(a5) # ffffffffc0206000 <SBI_CONSOLE_GETCHAR>
ffffffffc0201802:	88be                	mv	a7,a5
ffffffffc0201804:	852a                	mv	a0,a0
ffffffffc0201806:	85aa                	mv	a1,a0
ffffffffc0201808:	862a                	mv	a2,a0
ffffffffc020180a:	00000073          	ecall
ffffffffc020180e:	852a                	mv	a0,a0

int sbi_console_getchar(void) {
    return sbi_call(SBI_CONSOLE_GETCHAR, 0, 0, 0);
ffffffffc0201810:	2501                	sext.w	a0,a0
ffffffffc0201812:	8082                	ret

ffffffffc0201814 <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
ffffffffc0201814:	715d                	addi	sp,sp,-80
ffffffffc0201816:	e486                	sd	ra,72(sp)
ffffffffc0201818:	e0a6                	sd	s1,64(sp)
ffffffffc020181a:	fc4a                	sd	s2,56(sp)
ffffffffc020181c:	f84e                	sd	s3,48(sp)
ffffffffc020181e:	f452                	sd	s4,40(sp)
ffffffffc0201820:	f056                	sd	s5,32(sp)
ffffffffc0201822:	ec5a                	sd	s6,24(sp)
ffffffffc0201824:	e85e                	sd	s7,16(sp)
    if (prompt != NULL) {
ffffffffc0201826:	c901                	beqz	a0,ffffffffc0201836 <readline+0x22>
ffffffffc0201828:	85aa                	mv	a1,a0
        cprintf("%s", prompt);
ffffffffc020182a:	00001517          	auipc	a0,0x1
ffffffffc020182e:	be650513          	addi	a0,a0,-1050 # ffffffffc0202410 <buddy_system_pmm_manager+0x1b0>
ffffffffc0201832:	881fe0ef          	jal	ra,ffffffffc02000b2 <cprintf>
readline(const char *prompt) {
ffffffffc0201836:	4481                	li	s1,0
    while (1) {
        c = getchar();
        if (c < 0) {
            return NULL;
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
ffffffffc0201838:	497d                	li	s2,31
            cputchar(c);
            buf[i ++] = c;
        }
        else if (c == '\b' && i > 0) {
ffffffffc020183a:	49a1                	li	s3,8
            cputchar(c);
            i --;
        }
        else if (c == '\n' || c == '\r') {
ffffffffc020183c:	4aa9                	li	s5,10
ffffffffc020183e:	4b35                	li	s6,13
            buf[i ++] = c;
ffffffffc0201840:	00004b97          	auipc	s7,0x4
ffffffffc0201844:	7e8b8b93          	addi	s7,s7,2024 # ffffffffc0206028 <buf>
        else if (c >= ' ' && i < BUFSIZE - 1) {
ffffffffc0201848:	3fe00a13          	li	s4,1022
        c = getchar();
ffffffffc020184c:	8dffe0ef          	jal	ra,ffffffffc020012a <getchar>
        if (c < 0) {
ffffffffc0201850:	00054a63          	bltz	a0,ffffffffc0201864 <readline+0x50>
        else if (c >= ' ' && i < BUFSIZE - 1) {
ffffffffc0201854:	00a95a63          	bge	s2,a0,ffffffffc0201868 <readline+0x54>
ffffffffc0201858:	029a5263          	bge	s4,s1,ffffffffc020187c <readline+0x68>
        c = getchar();
ffffffffc020185c:	8cffe0ef          	jal	ra,ffffffffc020012a <getchar>
        if (c < 0) {
ffffffffc0201860:	fe055ae3          	bgez	a0,ffffffffc0201854 <readline+0x40>
            return NULL;
ffffffffc0201864:	4501                	li	a0,0
ffffffffc0201866:	a091                	j	ffffffffc02018aa <readline+0x96>
        else if (c == '\b' && i > 0) {
ffffffffc0201868:	03351463          	bne	a0,s3,ffffffffc0201890 <readline+0x7c>
ffffffffc020186c:	e8a9                	bnez	s1,ffffffffc02018be <readline+0xaa>
        c = getchar();
ffffffffc020186e:	8bdfe0ef          	jal	ra,ffffffffc020012a <getchar>
        if (c < 0) {
ffffffffc0201872:	fe0549e3          	bltz	a0,ffffffffc0201864 <readline+0x50>
        else if (c >= ' ' && i < BUFSIZE - 1) {
ffffffffc0201876:	fea959e3          	bge	s2,a0,ffffffffc0201868 <readline+0x54>
ffffffffc020187a:	4481                	li	s1,0
            cputchar(c);
ffffffffc020187c:	e42a                	sd	a0,8(sp)
ffffffffc020187e:	86bfe0ef          	jal	ra,ffffffffc02000e8 <cputchar>
            buf[i ++] = c;
ffffffffc0201882:	6522                	ld	a0,8(sp)
ffffffffc0201884:	009b87b3          	add	a5,s7,s1
ffffffffc0201888:	2485                	addiw	s1,s1,1
ffffffffc020188a:	00a78023          	sb	a0,0(a5)
ffffffffc020188e:	bf7d                	j	ffffffffc020184c <readline+0x38>
        else if (c == '\n' || c == '\r') {
ffffffffc0201890:	01550463          	beq	a0,s5,ffffffffc0201898 <readline+0x84>
ffffffffc0201894:	fb651ce3          	bne	a0,s6,ffffffffc020184c <readline+0x38>
            cputchar(c);
ffffffffc0201898:	851fe0ef          	jal	ra,ffffffffc02000e8 <cputchar>
            buf[i] = '\0';
ffffffffc020189c:	00004517          	auipc	a0,0x4
ffffffffc02018a0:	78c50513          	addi	a0,a0,1932 # ffffffffc0206028 <buf>
ffffffffc02018a4:	94aa                	add	s1,s1,a0
ffffffffc02018a6:	00048023          	sb	zero,0(s1)
            return buf;
        }
    }
}
ffffffffc02018aa:	60a6                	ld	ra,72(sp)
ffffffffc02018ac:	6486                	ld	s1,64(sp)
ffffffffc02018ae:	7962                	ld	s2,56(sp)
ffffffffc02018b0:	79c2                	ld	s3,48(sp)
ffffffffc02018b2:	7a22                	ld	s4,40(sp)
ffffffffc02018b4:	7a82                	ld	s5,32(sp)
ffffffffc02018b6:	6b62                	ld	s6,24(sp)
ffffffffc02018b8:	6bc2                	ld	s7,16(sp)
ffffffffc02018ba:	6161                	addi	sp,sp,80
ffffffffc02018bc:	8082                	ret
            cputchar(c);
ffffffffc02018be:	4521                	li	a0,8
ffffffffc02018c0:	829fe0ef          	jal	ra,ffffffffc02000e8 <cputchar>
            i --;
ffffffffc02018c4:	34fd                	addiw	s1,s1,-1
ffffffffc02018c6:	b759                	j	ffffffffc020184c <readline+0x38>
