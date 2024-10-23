
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
<<<<<<< HEAD
ffffffffc0200036:	fde50513          	addi	a0,a0,-34 # ffffffffc0206010 <free_area>
ffffffffc020003a:	00006617          	auipc	a2,0x6
ffffffffc020003e:	43660613          	addi	a2,a2,1078 # ffffffffc0206470 <end>
=======
ffffffffc0200036:	fde50513          	addi	a0,a0,-34 # ffffffffc0206010 <bsfree_area>
ffffffffc020003a:	00006617          	auipc	a2,0x6
ffffffffc020003e:	44e60613          	addi	a2,a2,1102 # ffffffffc0206488 <end>
>>>>>>> origin/main
int kern_init(void) {
ffffffffc0200042:	1141                	addi	sp,sp,-16
    memset(edata, 0, end - edata);
ffffffffc0200044:	8e09                	sub	a2,a2,a0
ffffffffc0200046:	4581                	li	a1,0
int kern_init(void) {
ffffffffc0200048:	e406                	sd	ra,8(sp)
    memset(edata, 0, end - edata);
<<<<<<< HEAD
ffffffffc020004a:	159010ef          	jal	ra,ffffffffc02019a2 <memset>
=======
ffffffffc020004a:	3ba010ef          	jal	ra,ffffffffc0201404 <memset>
>>>>>>> origin/main
    cons_init();  // init the console
ffffffffc020004e:	3fc000ef          	jal	ra,ffffffffc020044a <cons_init>
    const char *message = "(THU.CST) os is loading ...\0";
    //cprintf("%s\n\n", message);
    cputs(message);
ffffffffc0200052:	00002517          	auipc	a0,0x2
<<<<<<< HEAD
ffffffffc0200056:	96650513          	addi	a0,a0,-1690 # ffffffffc02019b8 <etext+0x4>
ffffffffc020005a:	090000ef          	jal	ra,ffffffffc02000ea <cputs>

    print_kerninfo();
ffffffffc020005e:	0dc000ef          	jal	ra,ffffffffc020013a <print_kerninfo>
=======
ffffffffc0200056:	8b650513          	addi	a0,a0,-1866 # ffffffffc0201908 <etext>
ffffffffc020005a:	090000ef          	jal	ra,ffffffffc02000ea <cputs>

    print_kerninfo();
ffffffffc020005e:	138000ef          	jal	ra,ffffffffc0200196 <print_kerninfo>
>>>>>>> origin/main

    // grade_backtrace();
    idt_init();  // init interrupt descriptor table
ffffffffc0200062:	402000ef          	jal	ra,ffffffffc0200464 <idt_init>

    pmm_init();  // init physical memory management
<<<<<<< HEAD
ffffffffc0200066:	266010ef          	jal	ra,ffffffffc02012cc <pmm_init>
=======
ffffffffc0200066:	1a2010ef          	jal	ra,ffffffffc0201208 <pmm_init>
>>>>>>> origin/main

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
<<<<<<< HEAD
ffffffffc02000a6:	426010ef          	jal	ra,ffffffffc02014cc <vprintfmt>
=======
ffffffffc02000a6:	3dc010ef          	jal	ra,ffffffffc0201482 <vprintfmt>
>>>>>>> origin/main
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
<<<<<<< HEAD
ffffffffc02000dc:	3f0010ef          	jal	ra,ffffffffc02014cc <vprintfmt>
=======
ffffffffc02000dc:	3a6010ef          	jal	ra,ffffffffc0201482 <vprintfmt>
>>>>>>> origin/main
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

<<<<<<< HEAD
ffffffffc020013a <print_kerninfo>:
/* *
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void print_kerninfo(void) {
ffffffffc020013a:	1141                	addi	sp,sp,-16
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
ffffffffc020013c:	00002517          	auipc	a0,0x2
ffffffffc0200140:	89c50513          	addi	a0,a0,-1892 # ffffffffc02019d8 <etext+0x24>
void print_kerninfo(void) {
ffffffffc0200144:	e406                	sd	ra,8(sp)
    cprintf("Special kernel symbols:\n");
ffffffffc0200146:	f6dff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    cprintf("  entry  0x%016lx (virtual)\n", kern_init);
ffffffffc020014a:	00000597          	auipc	a1,0x0
ffffffffc020014e:	ee858593          	addi	a1,a1,-280 # ffffffffc0200032 <kern_init>
ffffffffc0200152:	00002517          	auipc	a0,0x2
ffffffffc0200156:	8a650513          	addi	a0,a0,-1882 # ffffffffc02019f8 <etext+0x44>
ffffffffc020015a:	f59ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    cprintf("  etext  0x%016lx (virtual)\n", etext);
ffffffffc020015e:	00002597          	auipc	a1,0x2
ffffffffc0200162:	85658593          	addi	a1,a1,-1962 # ffffffffc02019b4 <etext>
ffffffffc0200166:	00002517          	auipc	a0,0x2
ffffffffc020016a:	8b250513          	addi	a0,a0,-1870 # ffffffffc0201a18 <etext+0x64>
ffffffffc020016e:	f45ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    cprintf("  edata  0x%016lx (virtual)\n", edata);
ffffffffc0200172:	00006597          	auipc	a1,0x6
ffffffffc0200176:	e9e58593          	addi	a1,a1,-354 # ffffffffc0206010 <free_area>
ffffffffc020017a:	00002517          	auipc	a0,0x2
ffffffffc020017e:	8be50513          	addi	a0,a0,-1858 # ffffffffc0201a38 <etext+0x84>
ffffffffc0200182:	f31ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    cprintf("  end    0x%016lx (virtual)\n", end);
ffffffffc0200186:	00006597          	auipc	a1,0x6
ffffffffc020018a:	2ea58593          	addi	a1,a1,746 # ffffffffc0206470 <end>
ffffffffc020018e:	00002517          	auipc	a0,0x2
ffffffffc0200192:	8ca50513          	addi	a0,a0,-1846 # ffffffffc0201a58 <etext+0xa4>
ffffffffc0200196:	f1dff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n",
            (end - kern_init + 1023) / 1024);
ffffffffc020019a:	00006597          	auipc	a1,0x6
ffffffffc020019e:	6d558593          	addi	a1,a1,1749 # ffffffffc020686f <end+0x3ff>
ffffffffc02001a2:	00000797          	auipc	a5,0x0
ffffffffc02001a6:	e9078793          	addi	a5,a5,-368 # ffffffffc0200032 <kern_init>
ffffffffc02001aa:	40f587b3          	sub	a5,a1,a5
    cprintf("Kernel executable memory footprint: %dKB\n",
ffffffffc02001ae:	43f7d593          	srai	a1,a5,0x3f
}
ffffffffc02001b2:	60a2                	ld	ra,8(sp)
    cprintf("Kernel executable memory footprint: %dKB\n",
ffffffffc02001b4:	3ff5f593          	andi	a1,a1,1023
ffffffffc02001b8:	95be                	add	a1,a1,a5
ffffffffc02001ba:	85a9                	srai	a1,a1,0xa
ffffffffc02001bc:	00002517          	auipc	a0,0x2
ffffffffc02001c0:	8bc50513          	addi	a0,a0,-1860 # ffffffffc0201a78 <etext+0xc4>
}
ffffffffc02001c4:	0141                	addi	sp,sp,16
    cprintf("Kernel executable memory footprint: %dKB\n",
ffffffffc02001c6:	b5f5                	j	ffffffffc02000b2 <cprintf>

ffffffffc02001c8 <print_stackframe>:
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before
 * jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the
 * boundary.
 * */
void print_stackframe(void) {
ffffffffc02001c8:	1141                	addi	sp,sp,-16

    panic("Not Implemented!");
ffffffffc02001ca:	00002617          	auipc	a2,0x2
ffffffffc02001ce:	8de60613          	addi	a2,a2,-1826 # ffffffffc0201aa8 <etext+0xf4>
ffffffffc02001d2:	04e00593          	li	a1,78
ffffffffc02001d6:	00002517          	auipc	a0,0x2
ffffffffc02001da:	8ea50513          	addi	a0,a0,-1814 # ffffffffc0201ac0 <etext+0x10c>
void print_stackframe(void) {
ffffffffc02001de:	e406                	sd	ra,8(sp)
    panic("Not Implemented!");
ffffffffc02001e0:	1cc000ef          	jal	ra,ffffffffc02003ac <__panic>

ffffffffc02001e4 <mon_help>:
    }
}

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
ffffffffc02001e4:	1141                	addi	sp,sp,-16
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
ffffffffc02001e6:	00002617          	auipc	a2,0x2
ffffffffc02001ea:	8f260613          	addi	a2,a2,-1806 # ffffffffc0201ad8 <etext+0x124>
ffffffffc02001ee:	00002597          	auipc	a1,0x2
ffffffffc02001f2:	90a58593          	addi	a1,a1,-1782 # ffffffffc0201af8 <etext+0x144>
ffffffffc02001f6:	00002517          	auipc	a0,0x2
ffffffffc02001fa:	90a50513          	addi	a0,a0,-1782 # ffffffffc0201b00 <etext+0x14c>
mon_help(int argc, char **argv, struct trapframe *tf) {
ffffffffc02001fe:	e406                	sd	ra,8(sp)
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
ffffffffc0200200:	eb3ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc0200204:	00002617          	auipc	a2,0x2
ffffffffc0200208:	90c60613          	addi	a2,a2,-1780 # ffffffffc0201b10 <etext+0x15c>
ffffffffc020020c:	00002597          	auipc	a1,0x2
ffffffffc0200210:	92c58593          	addi	a1,a1,-1748 # ffffffffc0201b38 <etext+0x184>
ffffffffc0200214:	00002517          	auipc	a0,0x2
ffffffffc0200218:	8ec50513          	addi	a0,a0,-1812 # ffffffffc0201b00 <etext+0x14c>
ffffffffc020021c:	e97ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc0200220:	00002617          	auipc	a2,0x2
ffffffffc0200224:	92860613          	addi	a2,a2,-1752 # ffffffffc0201b48 <etext+0x194>
ffffffffc0200228:	00002597          	auipc	a1,0x2
ffffffffc020022c:	94058593          	addi	a1,a1,-1728 # ffffffffc0201b68 <etext+0x1b4>
ffffffffc0200230:	00002517          	auipc	a0,0x2
ffffffffc0200234:	8d050513          	addi	a0,a0,-1840 # ffffffffc0201b00 <etext+0x14c>
ffffffffc0200238:	e7bff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    }
    return 0;
}
ffffffffc020023c:	60a2                	ld	ra,8(sp)
ffffffffc020023e:	4501                	li	a0,0
ffffffffc0200240:	0141                	addi	sp,sp,16
ffffffffc0200242:	8082                	ret

ffffffffc0200244 <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
ffffffffc0200244:	1141                	addi	sp,sp,-16
ffffffffc0200246:	e406                	sd	ra,8(sp)
    print_kerninfo();
ffffffffc0200248:	ef3ff0ef          	jal	ra,ffffffffc020013a <print_kerninfo>
    return 0;
}
ffffffffc020024c:	60a2                	ld	ra,8(sp)
ffffffffc020024e:	4501                	li	a0,0
ffffffffc0200250:	0141                	addi	sp,sp,16
ffffffffc0200252:	8082                	ret

ffffffffc0200254 <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
ffffffffc0200254:	1141                	addi	sp,sp,-16
ffffffffc0200256:	e406                	sd	ra,8(sp)
    print_stackframe();
ffffffffc0200258:	f71ff0ef          	jal	ra,ffffffffc02001c8 <print_stackframe>
    return 0;
}
ffffffffc020025c:	60a2                	ld	ra,8(sp)
ffffffffc020025e:	4501                	li	a0,0
ffffffffc0200260:	0141                	addi	sp,sp,16
ffffffffc0200262:	8082                	ret

ffffffffc0200264 <kmonitor>:
kmonitor(struct trapframe *tf) {
ffffffffc0200264:	7115                	addi	sp,sp,-224
ffffffffc0200266:	ed5e                	sd	s7,152(sp)
ffffffffc0200268:	8baa                	mv	s7,a0
    cprintf("Welcome to the kernel debug monitor!!\n");
ffffffffc020026a:	00002517          	auipc	a0,0x2
ffffffffc020026e:	90e50513          	addi	a0,a0,-1778 # ffffffffc0201b78 <etext+0x1c4>
kmonitor(struct trapframe *tf) {
ffffffffc0200272:	ed86                	sd	ra,216(sp)
ffffffffc0200274:	e9a2                	sd	s0,208(sp)
ffffffffc0200276:	e5a6                	sd	s1,200(sp)
ffffffffc0200278:	e1ca                	sd	s2,192(sp)
ffffffffc020027a:	fd4e                	sd	s3,184(sp)
ffffffffc020027c:	f952                	sd	s4,176(sp)
ffffffffc020027e:	f556                	sd	s5,168(sp)
ffffffffc0200280:	f15a                	sd	s6,160(sp)
ffffffffc0200282:	e962                	sd	s8,144(sp)
ffffffffc0200284:	e566                	sd	s9,136(sp)
ffffffffc0200286:	e16a                	sd	s10,128(sp)
    cprintf("Welcome to the kernel debug monitor!!\n");
ffffffffc0200288:	e2bff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
ffffffffc020028c:	00002517          	auipc	a0,0x2
ffffffffc0200290:	91450513          	addi	a0,a0,-1772 # ffffffffc0201ba0 <etext+0x1ec>
ffffffffc0200294:	e1fff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    if (tf != NULL) {
ffffffffc0200298:	000b8563          	beqz	s7,ffffffffc02002a2 <kmonitor+0x3e>
        print_trapframe(tf);
ffffffffc020029c:	855e                	mv	a0,s7
ffffffffc020029e:	3a4000ef          	jal	ra,ffffffffc0200642 <print_trapframe>
ffffffffc02002a2:	00002c17          	auipc	s8,0x2
ffffffffc02002a6:	96ec0c13          	addi	s8,s8,-1682 # ffffffffc0201c10 <commands>
        if ((buf = readline("K> ")) != NULL) {
ffffffffc02002aa:	00002917          	auipc	s2,0x2
ffffffffc02002ae:	91e90913          	addi	s2,s2,-1762 # ffffffffc0201bc8 <etext+0x214>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
ffffffffc02002b2:	00002497          	auipc	s1,0x2
ffffffffc02002b6:	91e48493          	addi	s1,s1,-1762 # ffffffffc0201bd0 <etext+0x21c>
        if (argc == MAXARGS - 1) {
ffffffffc02002ba:	49bd                	li	s3,15
            cprintf("Too many arguments (max %d).\n", MAXARGS);
ffffffffc02002bc:	00002b17          	auipc	s6,0x2
ffffffffc02002c0:	91cb0b13          	addi	s6,s6,-1764 # ffffffffc0201bd8 <etext+0x224>
        argv[argc ++] = buf;
ffffffffc02002c4:	00002a17          	auipc	s4,0x2
ffffffffc02002c8:	834a0a13          	addi	s4,s4,-1996 # ffffffffc0201af8 <etext+0x144>
    for (i = 0; i < NCOMMANDS; i ++) {
ffffffffc02002cc:	4a8d                	li	s5,3
        if ((buf = readline("K> ")) != NULL) {
ffffffffc02002ce:	854a                	mv	a0,s2
ffffffffc02002d0:	57e010ef          	jal	ra,ffffffffc020184e <readline>
ffffffffc02002d4:	842a                	mv	s0,a0
ffffffffc02002d6:	dd65                	beqz	a0,ffffffffc02002ce <kmonitor+0x6a>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
ffffffffc02002d8:	00054583          	lbu	a1,0(a0)
    int argc = 0;
ffffffffc02002dc:	4c81                	li	s9,0
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
ffffffffc02002de:	e1bd                	bnez	a1,ffffffffc0200344 <kmonitor+0xe0>
    if (argc == 0) {
ffffffffc02002e0:	fe0c87e3          	beqz	s9,ffffffffc02002ce <kmonitor+0x6a>
        if (strcmp(commands[i].name, argv[0]) == 0) {
ffffffffc02002e4:	6582                	ld	a1,0(sp)
ffffffffc02002e6:	00002d17          	auipc	s10,0x2
ffffffffc02002ea:	92ad0d13          	addi	s10,s10,-1750 # ffffffffc0201c10 <commands>
        argv[argc ++] = buf;
ffffffffc02002ee:	8552                	mv	a0,s4
    for (i = 0; i < NCOMMANDS; i ++) {
ffffffffc02002f0:	4401                	li	s0,0
ffffffffc02002f2:	0d61                	addi	s10,s10,24
        if (strcmp(commands[i].name, argv[0]) == 0) {
ffffffffc02002f4:	67a010ef          	jal	ra,ffffffffc020196e <strcmp>
ffffffffc02002f8:	c919                	beqz	a0,ffffffffc020030e <kmonitor+0xaa>
    for (i = 0; i < NCOMMANDS; i ++) {
ffffffffc02002fa:	2405                	addiw	s0,s0,1
ffffffffc02002fc:	0b540063          	beq	s0,s5,ffffffffc020039c <kmonitor+0x138>
        if (strcmp(commands[i].name, argv[0]) == 0) {
ffffffffc0200300:	000d3503          	ld	a0,0(s10)
ffffffffc0200304:	6582                	ld	a1,0(sp)
    for (i = 0; i < NCOMMANDS; i ++) {
ffffffffc0200306:	0d61                	addi	s10,s10,24
        if (strcmp(commands[i].name, argv[0]) == 0) {
ffffffffc0200308:	666010ef          	jal	ra,ffffffffc020196e <strcmp>
ffffffffc020030c:	f57d                	bnez	a0,ffffffffc02002fa <kmonitor+0x96>
            return commands[i].func(argc - 1, argv + 1, tf);
ffffffffc020030e:	00141793          	slli	a5,s0,0x1
ffffffffc0200312:	97a2                	add	a5,a5,s0
ffffffffc0200314:	078e                	slli	a5,a5,0x3
ffffffffc0200316:	97e2                	add	a5,a5,s8
ffffffffc0200318:	6b9c                	ld	a5,16(a5)
ffffffffc020031a:	865e                	mv	a2,s7
ffffffffc020031c:	002c                	addi	a1,sp,8
ffffffffc020031e:	fffc851b          	addiw	a0,s9,-1
ffffffffc0200322:	9782                	jalr	a5
            if (runcmd(buf, tf) < 0) {
ffffffffc0200324:	fa0555e3          	bgez	a0,ffffffffc02002ce <kmonitor+0x6a>
}
ffffffffc0200328:	60ee                	ld	ra,216(sp)
ffffffffc020032a:	644e                	ld	s0,208(sp)
ffffffffc020032c:	64ae                	ld	s1,200(sp)
ffffffffc020032e:	690e                	ld	s2,192(sp)
ffffffffc0200330:	79ea                	ld	s3,184(sp)
ffffffffc0200332:	7a4a                	ld	s4,176(sp)
ffffffffc0200334:	7aaa                	ld	s5,168(sp)
ffffffffc0200336:	7b0a                	ld	s6,160(sp)
ffffffffc0200338:	6bea                	ld	s7,152(sp)
ffffffffc020033a:	6c4a                	ld	s8,144(sp)
ffffffffc020033c:	6caa                	ld	s9,136(sp)
ffffffffc020033e:	6d0a                	ld	s10,128(sp)
ffffffffc0200340:	612d                	addi	sp,sp,224
ffffffffc0200342:	8082                	ret
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
ffffffffc0200344:	8526                	mv	a0,s1
ffffffffc0200346:	646010ef          	jal	ra,ffffffffc020198c <strchr>
ffffffffc020034a:	c901                	beqz	a0,ffffffffc020035a <kmonitor+0xf6>
ffffffffc020034c:	00144583          	lbu	a1,1(s0)
            *buf ++ = '\0';
ffffffffc0200350:	00040023          	sb	zero,0(s0)
ffffffffc0200354:	0405                	addi	s0,s0,1
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
ffffffffc0200356:	d5c9                	beqz	a1,ffffffffc02002e0 <kmonitor+0x7c>
ffffffffc0200358:	b7f5                	j	ffffffffc0200344 <kmonitor+0xe0>
        if (*buf == '\0') {
ffffffffc020035a:	00044783          	lbu	a5,0(s0)
ffffffffc020035e:	d3c9                	beqz	a5,ffffffffc02002e0 <kmonitor+0x7c>
        if (argc == MAXARGS - 1) {
ffffffffc0200360:	033c8963          	beq	s9,s3,ffffffffc0200392 <kmonitor+0x12e>
        argv[argc ++] = buf;
ffffffffc0200364:	003c9793          	slli	a5,s9,0x3
ffffffffc0200368:	0118                	addi	a4,sp,128
ffffffffc020036a:	97ba                	add	a5,a5,a4
ffffffffc020036c:	f887b023          	sd	s0,-128(a5)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
ffffffffc0200370:	00044583          	lbu	a1,0(s0)
        argv[argc ++] = buf;
ffffffffc0200374:	2c85                	addiw	s9,s9,1
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
ffffffffc0200376:	e591                	bnez	a1,ffffffffc0200382 <kmonitor+0x11e>
ffffffffc0200378:	b7b5                	j	ffffffffc02002e4 <kmonitor+0x80>
ffffffffc020037a:	00144583          	lbu	a1,1(s0)
            buf ++;
ffffffffc020037e:	0405                	addi	s0,s0,1
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
ffffffffc0200380:	d1a5                	beqz	a1,ffffffffc02002e0 <kmonitor+0x7c>
ffffffffc0200382:	8526                	mv	a0,s1
ffffffffc0200384:	608010ef          	jal	ra,ffffffffc020198c <strchr>
ffffffffc0200388:	d96d                	beqz	a0,ffffffffc020037a <kmonitor+0x116>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
ffffffffc020038a:	00044583          	lbu	a1,0(s0)
ffffffffc020038e:	d9a9                	beqz	a1,ffffffffc02002e0 <kmonitor+0x7c>
ffffffffc0200390:	bf55                	j	ffffffffc0200344 <kmonitor+0xe0>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
ffffffffc0200392:	45c1                	li	a1,16
ffffffffc0200394:	855a                	mv	a0,s6
ffffffffc0200396:	d1dff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc020039a:	b7e9                	j	ffffffffc0200364 <kmonitor+0x100>
    cprintf("Unknown command '%s'\n", argv[0]);
ffffffffc020039c:	6582                	ld	a1,0(sp)
ffffffffc020039e:	00002517          	auipc	a0,0x2
ffffffffc02003a2:	85a50513          	addi	a0,a0,-1958 # ffffffffc0201bf8 <etext+0x244>
ffffffffc02003a6:	d0dff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    return 0;
ffffffffc02003aa:	b715                	j	ffffffffc02002ce <kmonitor+0x6a>

ffffffffc02003ac <__panic>:
=======
ffffffffc020013a <__panic>:
>>>>>>> origin/main
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
    if (is_panic) {
<<<<<<< HEAD
ffffffffc02003ac:	00006317          	auipc	t1,0x6
ffffffffc02003b0:	07c30313          	addi	t1,t1,124 # ffffffffc0206428 <is_panic>
ffffffffc02003b4:	00032e03          	lw	t3,0(t1)
__panic(const char *file, int line, const char *fmt, ...) {
ffffffffc02003b8:	715d                	addi	sp,sp,-80
ffffffffc02003ba:	ec06                	sd	ra,24(sp)
ffffffffc02003bc:	e822                	sd	s0,16(sp)
ffffffffc02003be:	f436                	sd	a3,40(sp)
ffffffffc02003c0:	f83a                	sd	a4,48(sp)
ffffffffc02003c2:	fc3e                	sd	a5,56(sp)
ffffffffc02003c4:	e0c2                	sd	a6,64(sp)
ffffffffc02003c6:	e4c6                	sd	a7,72(sp)
    if (is_panic) {
ffffffffc02003c8:	020e1a63          	bnez	t3,ffffffffc02003fc <__panic+0x50>
        goto panic_dead;
    }
    is_panic = 1;
ffffffffc02003cc:	4785                	li	a5,1
ffffffffc02003ce:	00f32023          	sw	a5,0(t1)
=======
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
>>>>>>> origin/main

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
<<<<<<< HEAD
ffffffffc02003d2:	8432                	mv	s0,a2
ffffffffc02003d4:	103c                	addi	a5,sp,40
    cprintf("kernel panic at %s:%d:\n    ", file, line);
ffffffffc02003d6:	862e                	mv	a2,a1
ffffffffc02003d8:	85aa                	mv	a1,a0
ffffffffc02003da:	00002517          	auipc	a0,0x2
ffffffffc02003de:	87e50513          	addi	a0,a0,-1922 # ffffffffc0201c58 <commands+0x48>
    va_start(ap, fmt);
ffffffffc02003e2:	e43e                	sd	a5,8(sp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
ffffffffc02003e4:	ccfff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    vcprintf(fmt, ap);
ffffffffc02003e8:	65a2                	ld	a1,8(sp)
ffffffffc02003ea:	8522                	mv	a0,s0
ffffffffc02003ec:	ca7ff0ef          	jal	ra,ffffffffc0200092 <vcprintf>
    cprintf("\n");
ffffffffc02003f0:	00001517          	auipc	a0,0x1
ffffffffc02003f4:	6b050513          	addi	a0,a0,1712 # ffffffffc0201aa0 <etext+0xec>
ffffffffc02003f8:	cbbff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
=======
ffffffffc0200160:	8432                	mv	s0,a2
ffffffffc0200162:	103c                	addi	a5,sp,40
    cprintf("kernel panic at %s:%d:\n    ", file, line);
ffffffffc0200164:	862e                	mv	a2,a1
ffffffffc0200166:	85aa                	mv	a1,a0
ffffffffc0200168:	00001517          	auipc	a0,0x1
ffffffffc020016c:	7c050513          	addi	a0,a0,1984 # ffffffffc0201928 <etext+0x20>
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
ffffffffc0200182:	89250513          	addi	a0,a0,-1902 # ffffffffc0201a10 <etext+0x108>
ffffffffc0200186:	f2dff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
>>>>>>> origin/main
    va_end(ap);

panic_dead:
    intr_disable();
<<<<<<< HEAD
ffffffffc02003fc:	062000ef          	jal	ra,ffffffffc020045e <intr_disable>
    while (1) {
        kmonitor(NULL);
ffffffffc0200400:	4501                	li	a0,0
ffffffffc0200402:	e63ff0ef          	jal	ra,ffffffffc0200264 <kmonitor>
    while (1) {
ffffffffc0200406:	bfed                	j	ffffffffc0200400 <__panic+0x54>
=======
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
ffffffffc020019c:	7b050513          	addi	a0,a0,1968 # ffffffffc0201948 <etext+0x40>
void print_kerninfo(void) {
ffffffffc02001a0:	e406                	sd	ra,8(sp)
    cprintf("Special kernel symbols:\n");
ffffffffc02001a2:	f11ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    cprintf("  entry  0x%016lx (virtual)\n", kern_init);
ffffffffc02001a6:	00000597          	auipc	a1,0x0
ffffffffc02001aa:	e8c58593          	addi	a1,a1,-372 # ffffffffc0200032 <kern_init>
ffffffffc02001ae:	00001517          	auipc	a0,0x1
ffffffffc02001b2:	7ba50513          	addi	a0,a0,1978 # ffffffffc0201968 <etext+0x60>
ffffffffc02001b6:	efdff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    cprintf("  etext  0x%016lx (virtual)\n", etext);
ffffffffc02001ba:	00001597          	auipc	a1,0x1
ffffffffc02001be:	74e58593          	addi	a1,a1,1870 # ffffffffc0201908 <etext>
ffffffffc02001c2:	00001517          	auipc	a0,0x1
ffffffffc02001c6:	7c650513          	addi	a0,a0,1990 # ffffffffc0201988 <etext+0x80>
ffffffffc02001ca:	ee9ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    cprintf("  edata  0x%016lx (virtual)\n", edata);
ffffffffc02001ce:	00006597          	auipc	a1,0x6
ffffffffc02001d2:	e4258593          	addi	a1,a1,-446 # ffffffffc0206010 <bsfree_area>
ffffffffc02001d6:	00001517          	auipc	a0,0x1
ffffffffc02001da:	7d250513          	addi	a0,a0,2002 # ffffffffc02019a8 <etext+0xa0>
ffffffffc02001de:	ed5ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    cprintf("  end    0x%016lx (virtual)\n", end);
ffffffffc02001e2:	00006597          	auipc	a1,0x6
ffffffffc02001e6:	2a658593          	addi	a1,a1,678 # ffffffffc0206488 <end>
ffffffffc02001ea:	00001517          	auipc	a0,0x1
ffffffffc02001ee:	7de50513          	addi	a0,a0,2014 # ffffffffc02019c8 <etext+0xc0>
ffffffffc02001f2:	ec1ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n",
            (end - kern_init + 1023) / 1024);
ffffffffc02001f6:	00006597          	auipc	a1,0x6
ffffffffc02001fa:	69158593          	addi	a1,a1,1681 # ffffffffc0206887 <end+0x3ff>
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
ffffffffc020021c:	7d050513          	addi	a0,a0,2000 # ffffffffc02019e8 <etext+0xe0>
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
ffffffffc020022a:	7f260613          	addi	a2,a2,2034 # ffffffffc0201a18 <etext+0x110>
ffffffffc020022e:	04e00593          	li	a1,78
ffffffffc0200232:	00001517          	auipc	a0,0x1
ffffffffc0200236:	7fe50513          	addi	a0,a0,2046 # ffffffffc0201a30 <etext+0x128>
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
ffffffffc0200242:	00002617          	auipc	a2,0x2
ffffffffc0200246:	80660613          	addi	a2,a2,-2042 # ffffffffc0201a48 <etext+0x140>
ffffffffc020024a:	00002597          	auipc	a1,0x2
ffffffffc020024e:	81e58593          	addi	a1,a1,-2018 # ffffffffc0201a68 <etext+0x160>
ffffffffc0200252:	00002517          	auipc	a0,0x2
ffffffffc0200256:	81e50513          	addi	a0,a0,-2018 # ffffffffc0201a70 <etext+0x168>
mon_help(int argc, char **argv, struct trapframe *tf) {
ffffffffc020025a:	e406                	sd	ra,8(sp)
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
ffffffffc020025c:	e57ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc0200260:	00002617          	auipc	a2,0x2
ffffffffc0200264:	82060613          	addi	a2,a2,-2016 # ffffffffc0201a80 <etext+0x178>
ffffffffc0200268:	00002597          	auipc	a1,0x2
ffffffffc020026c:	84058593          	addi	a1,a1,-1984 # ffffffffc0201aa8 <etext+0x1a0>
ffffffffc0200270:	00002517          	auipc	a0,0x2
ffffffffc0200274:	80050513          	addi	a0,a0,-2048 # ffffffffc0201a70 <etext+0x168>
ffffffffc0200278:	e3bff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc020027c:	00002617          	auipc	a2,0x2
ffffffffc0200280:	83c60613          	addi	a2,a2,-1988 # ffffffffc0201ab8 <etext+0x1b0>
ffffffffc0200284:	00002597          	auipc	a1,0x2
ffffffffc0200288:	85458593          	addi	a1,a1,-1964 # ffffffffc0201ad8 <etext+0x1d0>
ffffffffc020028c:	00001517          	auipc	a0,0x1
ffffffffc0200290:	7e450513          	addi	a0,a0,2020 # ffffffffc0201a70 <etext+0x168>
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
ffffffffc02002c6:	00002517          	auipc	a0,0x2
ffffffffc02002ca:	82250513          	addi	a0,a0,-2014 # ffffffffc0201ae8 <etext+0x1e0>
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
ffffffffc02002e8:	00002517          	auipc	a0,0x2
ffffffffc02002ec:	82850513          	addi	a0,a0,-2008 # ffffffffc0201b10 <etext+0x208>
ffffffffc02002f0:	dc3ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    if (tf != NULL) {
ffffffffc02002f4:	000b8563          	beqz	s7,ffffffffc02002fe <kmonitor+0x3e>
        print_trapframe(tf);
ffffffffc02002f8:	855e                	mv	a0,s7
ffffffffc02002fa:	348000ef          	jal	ra,ffffffffc0200642 <print_trapframe>
ffffffffc02002fe:	00002c17          	auipc	s8,0x2
ffffffffc0200302:	882c0c13          	addi	s8,s8,-1918 # ffffffffc0201b80 <commands>
        if ((buf = readline("K> ")) != NULL) {
ffffffffc0200306:	00002917          	auipc	s2,0x2
ffffffffc020030a:	83290913          	addi	s2,s2,-1998 # ffffffffc0201b38 <etext+0x230>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
ffffffffc020030e:	00002497          	auipc	s1,0x2
ffffffffc0200312:	83248493          	addi	s1,s1,-1998 # ffffffffc0201b40 <etext+0x238>
        if (argc == MAXARGS - 1) {
ffffffffc0200316:	49bd                	li	s3,15
            cprintf("Too many arguments (max %d).\n", MAXARGS);
ffffffffc0200318:	00002b17          	auipc	s6,0x2
ffffffffc020031c:	830b0b13          	addi	s6,s6,-2000 # ffffffffc0201b48 <etext+0x240>
        argv[argc ++] = buf;
ffffffffc0200320:	00001a17          	auipc	s4,0x1
ffffffffc0200324:	748a0a13          	addi	s4,s4,1864 # ffffffffc0201a68 <etext+0x160>
    for (i = 0; i < NCOMMANDS; i ++) {
ffffffffc0200328:	4a8d                	li	s5,3
        if ((buf = readline("K> ")) != NULL) {
ffffffffc020032a:	854a                	mv	a0,s2
ffffffffc020032c:	528010ef          	jal	ra,ffffffffc0201854 <readline>
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
ffffffffc0200342:	00002d17          	auipc	s10,0x2
ffffffffc0200346:	83ed0d13          	addi	s10,s10,-1986 # ffffffffc0201b80 <commands>
        argv[argc ++] = buf;
ffffffffc020034a:	8552                	mv	a0,s4
    for (i = 0; i < NCOMMANDS; i ++) {
ffffffffc020034c:	4401                	li	s0,0
ffffffffc020034e:	0d61                	addi	s10,s10,24
        if (strcmp(commands[i].name, argv[0]) == 0) {
ffffffffc0200350:	080010ef          	jal	ra,ffffffffc02013d0 <strcmp>
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
ffffffffc0200364:	06c010ef          	jal	ra,ffffffffc02013d0 <strcmp>
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
ffffffffc02003a2:	04c010ef          	jal	ra,ffffffffc02013ee <strchr>
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
ffffffffc02003e0:	00e010ef          	jal	ra,ffffffffc02013ee <strchr>
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
ffffffffc02003fe:	76e50513          	addi	a0,a0,1902 # ffffffffc0201b68 <etext+0x260>
ffffffffc0200402:	cb1ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    return 0;
ffffffffc0200406:	b715                	j	ffffffffc020032a <kmonitor+0x6a>
>>>>>>> origin/main

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
<<<<<<< HEAD
ffffffffc0200420:	4fc010ef          	jal	ra,ffffffffc020191c <sbi_set_timer>
=======
ffffffffc0200420:	3fe010ef          	jal	ra,ffffffffc020181e <sbi_set_timer>
>>>>>>> origin/main
}
ffffffffc0200424:	60a2                	ld	ra,8(sp)
    ticks = 0;
ffffffffc0200426:	00006797          	auipc	a5,0x6
ffffffffc020042a:	0007b523          	sd	zero,10(a5) # ffffffffc0206430 <ticks>
    cprintf("++ setup timer interrupts\n");
<<<<<<< HEAD
ffffffffc020042e:	00002517          	auipc	a0,0x2
ffffffffc0200432:	84a50513          	addi	a0,a0,-1974 # ffffffffc0201c78 <commands+0x68>
=======
ffffffffc020042e:	00001517          	auipc	a0,0x1
ffffffffc0200432:	79a50513          	addi	a0,a0,1946 # ffffffffc0201bc8 <commands+0x48>
>>>>>>> origin/main
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
<<<<<<< HEAD
ffffffffc0200446:	4d60106f          	j	ffffffffc020191c <sbi_set_timer>
=======
ffffffffc0200446:	3d80106f          	j	ffffffffc020181e <sbi_set_timer>
>>>>>>> origin/main

ffffffffc020044a <cons_init>:

/* serial_intr - try to feed input characters from serial port */
void serial_intr(void) {}

/* cons_init - initializes the console devices */
void cons_init(void) {}
ffffffffc020044a:	8082                	ret

ffffffffc020044c <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void cons_putc(int c) { sbi_console_putchar((unsigned char)c); }
<<<<<<< HEAD
ffffffffc020044c:	0ff57513          	andi	a0,a0,255
ffffffffc0200450:	4b20106f          	j	ffffffffc0201902 <sbi_console_putchar>
=======
ffffffffc020044c:	0ff57513          	zext.b	a0,a0
ffffffffc0200450:	3b40106f          	j	ffffffffc0201804 <sbi_console_putchar>
>>>>>>> origin/main

ffffffffc0200454 <cons_getc>:
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int cons_getc(void) {
    int c = 0;
    c = sbi_console_getchar();
<<<<<<< HEAD
ffffffffc0200454:	4e20106f          	j	ffffffffc0201936 <sbi_console_getchar>
=======
ffffffffc0200454:	3e40106f          	j	ffffffffc0201838 <sbi_console_getchar>
>>>>>>> origin/main

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
<<<<<<< HEAD
ffffffffc020047e:	00002517          	auipc	a0,0x2
ffffffffc0200482:	81a50513          	addi	a0,a0,-2022 # ffffffffc0201c98 <commands+0x88>
=======
ffffffffc020047e:	00001517          	auipc	a0,0x1
ffffffffc0200482:	76a50513          	addi	a0,a0,1898 # ffffffffc0201be8 <commands+0x68>
>>>>>>> origin/main
void print_regs(struct pushregs *gpr) {
ffffffffc0200486:	e406                	sd	ra,8(sp)
    cprintf("  zero     0x%08x\n", gpr->zero);
ffffffffc0200488:	c2bff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    cprintf("  ra       0x%08x\n", gpr->ra);
ffffffffc020048c:	640c                	ld	a1,8(s0)
<<<<<<< HEAD
ffffffffc020048e:	00002517          	auipc	a0,0x2
ffffffffc0200492:	82250513          	addi	a0,a0,-2014 # ffffffffc0201cb0 <commands+0xa0>
ffffffffc0200496:	c1dff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    cprintf("  sp       0x%08x\n", gpr->sp);
ffffffffc020049a:	680c                	ld	a1,16(s0)
ffffffffc020049c:	00002517          	auipc	a0,0x2
ffffffffc02004a0:	82c50513          	addi	a0,a0,-2004 # ffffffffc0201cc8 <commands+0xb8>
ffffffffc02004a4:	c0fff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    cprintf("  gp       0x%08x\n", gpr->gp);
ffffffffc02004a8:	6c0c                	ld	a1,24(s0)
ffffffffc02004aa:	00002517          	auipc	a0,0x2
ffffffffc02004ae:	83650513          	addi	a0,a0,-1994 # ffffffffc0201ce0 <commands+0xd0>
ffffffffc02004b2:	c01ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    cprintf("  tp       0x%08x\n", gpr->tp);
ffffffffc02004b6:	700c                	ld	a1,32(s0)
ffffffffc02004b8:	00002517          	auipc	a0,0x2
ffffffffc02004bc:	84050513          	addi	a0,a0,-1984 # ffffffffc0201cf8 <commands+0xe8>
ffffffffc02004c0:	bf3ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    cprintf("  t0       0x%08x\n", gpr->t0);
ffffffffc02004c4:	740c                	ld	a1,40(s0)
ffffffffc02004c6:	00002517          	auipc	a0,0x2
ffffffffc02004ca:	84a50513          	addi	a0,a0,-1974 # ffffffffc0201d10 <commands+0x100>
ffffffffc02004ce:	be5ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    cprintf("  t1       0x%08x\n", gpr->t1);
ffffffffc02004d2:	780c                	ld	a1,48(s0)
ffffffffc02004d4:	00002517          	auipc	a0,0x2
ffffffffc02004d8:	85450513          	addi	a0,a0,-1964 # ffffffffc0201d28 <commands+0x118>
ffffffffc02004dc:	bd7ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    cprintf("  t2       0x%08x\n", gpr->t2);
ffffffffc02004e0:	7c0c                	ld	a1,56(s0)
ffffffffc02004e2:	00002517          	auipc	a0,0x2
ffffffffc02004e6:	85e50513          	addi	a0,a0,-1954 # ffffffffc0201d40 <commands+0x130>
ffffffffc02004ea:	bc9ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    cprintf("  s0       0x%08x\n", gpr->s0);
ffffffffc02004ee:	602c                	ld	a1,64(s0)
ffffffffc02004f0:	00002517          	auipc	a0,0x2
ffffffffc02004f4:	86850513          	addi	a0,a0,-1944 # ffffffffc0201d58 <commands+0x148>
ffffffffc02004f8:	bbbff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    cprintf("  s1       0x%08x\n", gpr->s1);
ffffffffc02004fc:	642c                	ld	a1,72(s0)
ffffffffc02004fe:	00002517          	auipc	a0,0x2
ffffffffc0200502:	87250513          	addi	a0,a0,-1934 # ffffffffc0201d70 <commands+0x160>
ffffffffc0200506:	badff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    cprintf("  a0       0x%08x\n", gpr->a0);
ffffffffc020050a:	682c                	ld	a1,80(s0)
ffffffffc020050c:	00002517          	auipc	a0,0x2
ffffffffc0200510:	87c50513          	addi	a0,a0,-1924 # ffffffffc0201d88 <commands+0x178>
ffffffffc0200514:	b9fff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    cprintf("  a1       0x%08x\n", gpr->a1);
ffffffffc0200518:	6c2c                	ld	a1,88(s0)
ffffffffc020051a:	00002517          	auipc	a0,0x2
ffffffffc020051e:	88650513          	addi	a0,a0,-1914 # ffffffffc0201da0 <commands+0x190>
ffffffffc0200522:	b91ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    cprintf("  a2       0x%08x\n", gpr->a2);
ffffffffc0200526:	702c                	ld	a1,96(s0)
ffffffffc0200528:	00002517          	auipc	a0,0x2
ffffffffc020052c:	89050513          	addi	a0,a0,-1904 # ffffffffc0201db8 <commands+0x1a8>
ffffffffc0200530:	b83ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    cprintf("  a3       0x%08x\n", gpr->a3);
ffffffffc0200534:	742c                	ld	a1,104(s0)
ffffffffc0200536:	00002517          	auipc	a0,0x2
ffffffffc020053a:	89a50513          	addi	a0,a0,-1894 # ffffffffc0201dd0 <commands+0x1c0>
ffffffffc020053e:	b75ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    cprintf("  a4       0x%08x\n", gpr->a4);
ffffffffc0200542:	782c                	ld	a1,112(s0)
ffffffffc0200544:	00002517          	auipc	a0,0x2
ffffffffc0200548:	8a450513          	addi	a0,a0,-1884 # ffffffffc0201de8 <commands+0x1d8>
ffffffffc020054c:	b67ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    cprintf("  a5       0x%08x\n", gpr->a5);
ffffffffc0200550:	7c2c                	ld	a1,120(s0)
ffffffffc0200552:	00002517          	auipc	a0,0x2
ffffffffc0200556:	8ae50513          	addi	a0,a0,-1874 # ffffffffc0201e00 <commands+0x1f0>
=======
ffffffffc020048e:	00001517          	auipc	a0,0x1
ffffffffc0200492:	77250513          	addi	a0,a0,1906 # ffffffffc0201c00 <commands+0x80>
ffffffffc0200496:	c1dff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    cprintf("  sp       0x%08x\n", gpr->sp);
ffffffffc020049a:	680c                	ld	a1,16(s0)
ffffffffc020049c:	00001517          	auipc	a0,0x1
ffffffffc02004a0:	77c50513          	addi	a0,a0,1916 # ffffffffc0201c18 <commands+0x98>
ffffffffc02004a4:	c0fff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    cprintf("  gp       0x%08x\n", gpr->gp);
ffffffffc02004a8:	6c0c                	ld	a1,24(s0)
ffffffffc02004aa:	00001517          	auipc	a0,0x1
ffffffffc02004ae:	78650513          	addi	a0,a0,1926 # ffffffffc0201c30 <commands+0xb0>
ffffffffc02004b2:	c01ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    cprintf("  tp       0x%08x\n", gpr->tp);
ffffffffc02004b6:	700c                	ld	a1,32(s0)
ffffffffc02004b8:	00001517          	auipc	a0,0x1
ffffffffc02004bc:	79050513          	addi	a0,a0,1936 # ffffffffc0201c48 <commands+0xc8>
ffffffffc02004c0:	bf3ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    cprintf("  t0       0x%08x\n", gpr->t0);
ffffffffc02004c4:	740c                	ld	a1,40(s0)
ffffffffc02004c6:	00001517          	auipc	a0,0x1
ffffffffc02004ca:	79a50513          	addi	a0,a0,1946 # ffffffffc0201c60 <commands+0xe0>
ffffffffc02004ce:	be5ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    cprintf("  t1       0x%08x\n", gpr->t1);
ffffffffc02004d2:	780c                	ld	a1,48(s0)
ffffffffc02004d4:	00001517          	auipc	a0,0x1
ffffffffc02004d8:	7a450513          	addi	a0,a0,1956 # ffffffffc0201c78 <commands+0xf8>
ffffffffc02004dc:	bd7ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    cprintf("  t2       0x%08x\n", gpr->t2);
ffffffffc02004e0:	7c0c                	ld	a1,56(s0)
ffffffffc02004e2:	00001517          	auipc	a0,0x1
ffffffffc02004e6:	7ae50513          	addi	a0,a0,1966 # ffffffffc0201c90 <commands+0x110>
ffffffffc02004ea:	bc9ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    cprintf("  s0       0x%08x\n", gpr->s0);
ffffffffc02004ee:	602c                	ld	a1,64(s0)
ffffffffc02004f0:	00001517          	auipc	a0,0x1
ffffffffc02004f4:	7b850513          	addi	a0,a0,1976 # ffffffffc0201ca8 <commands+0x128>
ffffffffc02004f8:	bbbff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    cprintf("  s1       0x%08x\n", gpr->s1);
ffffffffc02004fc:	642c                	ld	a1,72(s0)
ffffffffc02004fe:	00001517          	auipc	a0,0x1
ffffffffc0200502:	7c250513          	addi	a0,a0,1986 # ffffffffc0201cc0 <commands+0x140>
ffffffffc0200506:	badff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    cprintf("  a0       0x%08x\n", gpr->a0);
ffffffffc020050a:	682c                	ld	a1,80(s0)
ffffffffc020050c:	00001517          	auipc	a0,0x1
ffffffffc0200510:	7cc50513          	addi	a0,a0,1996 # ffffffffc0201cd8 <commands+0x158>
ffffffffc0200514:	b9fff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    cprintf("  a1       0x%08x\n", gpr->a1);
ffffffffc0200518:	6c2c                	ld	a1,88(s0)
ffffffffc020051a:	00001517          	auipc	a0,0x1
ffffffffc020051e:	7d650513          	addi	a0,a0,2006 # ffffffffc0201cf0 <commands+0x170>
ffffffffc0200522:	b91ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    cprintf("  a2       0x%08x\n", gpr->a2);
ffffffffc0200526:	702c                	ld	a1,96(s0)
ffffffffc0200528:	00001517          	auipc	a0,0x1
ffffffffc020052c:	7e050513          	addi	a0,a0,2016 # ffffffffc0201d08 <commands+0x188>
ffffffffc0200530:	b83ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    cprintf("  a3       0x%08x\n", gpr->a3);
ffffffffc0200534:	742c                	ld	a1,104(s0)
ffffffffc0200536:	00001517          	auipc	a0,0x1
ffffffffc020053a:	7ea50513          	addi	a0,a0,2026 # ffffffffc0201d20 <commands+0x1a0>
ffffffffc020053e:	b75ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    cprintf("  a4       0x%08x\n", gpr->a4);
ffffffffc0200542:	782c                	ld	a1,112(s0)
ffffffffc0200544:	00001517          	auipc	a0,0x1
ffffffffc0200548:	7f450513          	addi	a0,a0,2036 # ffffffffc0201d38 <commands+0x1b8>
ffffffffc020054c:	b67ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    cprintf("  a5       0x%08x\n", gpr->a5);
ffffffffc0200550:	7c2c                	ld	a1,120(s0)
ffffffffc0200552:	00001517          	auipc	a0,0x1
ffffffffc0200556:	7fe50513          	addi	a0,a0,2046 # ffffffffc0201d50 <commands+0x1d0>
>>>>>>> origin/main
ffffffffc020055a:	b59ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    cprintf("  a6       0x%08x\n", gpr->a6);
ffffffffc020055e:	604c                	ld	a1,128(s0)
ffffffffc0200560:	00002517          	auipc	a0,0x2
<<<<<<< HEAD
ffffffffc0200564:	8b850513          	addi	a0,a0,-1864 # ffffffffc0201e18 <commands+0x208>
=======
ffffffffc0200564:	80850513          	addi	a0,a0,-2040 # ffffffffc0201d68 <commands+0x1e8>
>>>>>>> origin/main
ffffffffc0200568:	b4bff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    cprintf("  a7       0x%08x\n", gpr->a7);
ffffffffc020056c:	644c                	ld	a1,136(s0)
ffffffffc020056e:	00002517          	auipc	a0,0x2
<<<<<<< HEAD
ffffffffc0200572:	8c250513          	addi	a0,a0,-1854 # ffffffffc0201e30 <commands+0x220>
=======
ffffffffc0200572:	81250513          	addi	a0,a0,-2030 # ffffffffc0201d80 <commands+0x200>
>>>>>>> origin/main
ffffffffc0200576:	b3dff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    cprintf("  s2       0x%08x\n", gpr->s2);
ffffffffc020057a:	684c                	ld	a1,144(s0)
ffffffffc020057c:	00002517          	auipc	a0,0x2
<<<<<<< HEAD
ffffffffc0200580:	8cc50513          	addi	a0,a0,-1844 # ffffffffc0201e48 <commands+0x238>
=======
ffffffffc0200580:	81c50513          	addi	a0,a0,-2020 # ffffffffc0201d98 <commands+0x218>
>>>>>>> origin/main
ffffffffc0200584:	b2fff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    cprintf("  s3       0x%08x\n", gpr->s3);
ffffffffc0200588:	6c4c                	ld	a1,152(s0)
ffffffffc020058a:	00002517          	auipc	a0,0x2
<<<<<<< HEAD
ffffffffc020058e:	8d650513          	addi	a0,a0,-1834 # ffffffffc0201e60 <commands+0x250>
=======
ffffffffc020058e:	82650513          	addi	a0,a0,-2010 # ffffffffc0201db0 <commands+0x230>
>>>>>>> origin/main
ffffffffc0200592:	b21ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    cprintf("  s4       0x%08x\n", gpr->s4);
ffffffffc0200596:	704c                	ld	a1,160(s0)
ffffffffc0200598:	00002517          	auipc	a0,0x2
<<<<<<< HEAD
ffffffffc020059c:	8e050513          	addi	a0,a0,-1824 # ffffffffc0201e78 <commands+0x268>
=======
ffffffffc020059c:	83050513          	addi	a0,a0,-2000 # ffffffffc0201dc8 <commands+0x248>
>>>>>>> origin/main
ffffffffc02005a0:	b13ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    cprintf("  s5       0x%08x\n", gpr->s5);
ffffffffc02005a4:	744c                	ld	a1,168(s0)
ffffffffc02005a6:	00002517          	auipc	a0,0x2
<<<<<<< HEAD
ffffffffc02005aa:	8ea50513          	addi	a0,a0,-1814 # ffffffffc0201e90 <commands+0x280>
=======
ffffffffc02005aa:	83a50513          	addi	a0,a0,-1990 # ffffffffc0201de0 <commands+0x260>
>>>>>>> origin/main
ffffffffc02005ae:	b05ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    cprintf("  s6       0x%08x\n", gpr->s6);
ffffffffc02005b2:	784c                	ld	a1,176(s0)
ffffffffc02005b4:	00002517          	auipc	a0,0x2
<<<<<<< HEAD
ffffffffc02005b8:	8f450513          	addi	a0,a0,-1804 # ffffffffc0201ea8 <commands+0x298>
=======
ffffffffc02005b8:	84450513          	addi	a0,a0,-1980 # ffffffffc0201df8 <commands+0x278>
>>>>>>> origin/main
ffffffffc02005bc:	af7ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    cprintf("  s7       0x%08x\n", gpr->s7);
ffffffffc02005c0:	7c4c                	ld	a1,184(s0)
ffffffffc02005c2:	00002517          	auipc	a0,0x2
<<<<<<< HEAD
ffffffffc02005c6:	8fe50513          	addi	a0,a0,-1794 # ffffffffc0201ec0 <commands+0x2b0>
=======
ffffffffc02005c6:	84e50513          	addi	a0,a0,-1970 # ffffffffc0201e10 <commands+0x290>
>>>>>>> origin/main
ffffffffc02005ca:	ae9ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    cprintf("  s8       0x%08x\n", gpr->s8);
ffffffffc02005ce:	606c                	ld	a1,192(s0)
ffffffffc02005d0:	00002517          	auipc	a0,0x2
<<<<<<< HEAD
ffffffffc02005d4:	90850513          	addi	a0,a0,-1784 # ffffffffc0201ed8 <commands+0x2c8>
=======
ffffffffc02005d4:	85850513          	addi	a0,a0,-1960 # ffffffffc0201e28 <commands+0x2a8>
>>>>>>> origin/main
ffffffffc02005d8:	adbff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    cprintf("  s9       0x%08x\n", gpr->s9);
ffffffffc02005dc:	646c                	ld	a1,200(s0)
ffffffffc02005de:	00002517          	auipc	a0,0x2
<<<<<<< HEAD
ffffffffc02005e2:	91250513          	addi	a0,a0,-1774 # ffffffffc0201ef0 <commands+0x2e0>
=======
ffffffffc02005e2:	86250513          	addi	a0,a0,-1950 # ffffffffc0201e40 <commands+0x2c0>
>>>>>>> origin/main
ffffffffc02005e6:	acdff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    cprintf("  s10      0x%08x\n", gpr->s10);
ffffffffc02005ea:	686c                	ld	a1,208(s0)
ffffffffc02005ec:	00002517          	auipc	a0,0x2
<<<<<<< HEAD
ffffffffc02005f0:	91c50513          	addi	a0,a0,-1764 # ffffffffc0201f08 <commands+0x2f8>
=======
ffffffffc02005f0:	86c50513          	addi	a0,a0,-1940 # ffffffffc0201e58 <commands+0x2d8>
>>>>>>> origin/main
ffffffffc02005f4:	abfff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    cprintf("  s11      0x%08x\n", gpr->s11);
ffffffffc02005f8:	6c6c                	ld	a1,216(s0)
ffffffffc02005fa:	00002517          	auipc	a0,0x2
<<<<<<< HEAD
ffffffffc02005fe:	92650513          	addi	a0,a0,-1754 # ffffffffc0201f20 <commands+0x310>
=======
ffffffffc02005fe:	87650513          	addi	a0,a0,-1930 # ffffffffc0201e70 <commands+0x2f0>
>>>>>>> origin/main
ffffffffc0200602:	ab1ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    cprintf("  t3       0x%08x\n", gpr->t3);
ffffffffc0200606:	706c                	ld	a1,224(s0)
ffffffffc0200608:	00002517          	auipc	a0,0x2
<<<<<<< HEAD
ffffffffc020060c:	93050513          	addi	a0,a0,-1744 # ffffffffc0201f38 <commands+0x328>
=======
ffffffffc020060c:	88050513          	addi	a0,a0,-1920 # ffffffffc0201e88 <commands+0x308>
>>>>>>> origin/main
ffffffffc0200610:	aa3ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    cprintf("  t4       0x%08x\n", gpr->t4);
ffffffffc0200614:	746c                	ld	a1,232(s0)
ffffffffc0200616:	00002517          	auipc	a0,0x2
<<<<<<< HEAD
ffffffffc020061a:	93a50513          	addi	a0,a0,-1734 # ffffffffc0201f50 <commands+0x340>
=======
ffffffffc020061a:	88a50513          	addi	a0,a0,-1910 # ffffffffc0201ea0 <commands+0x320>
>>>>>>> origin/main
ffffffffc020061e:	a95ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    cprintf("  t5       0x%08x\n", gpr->t5);
ffffffffc0200622:	786c                	ld	a1,240(s0)
ffffffffc0200624:	00002517          	auipc	a0,0x2
<<<<<<< HEAD
ffffffffc0200628:	94450513          	addi	a0,a0,-1724 # ffffffffc0201f68 <commands+0x358>
=======
ffffffffc0200628:	89450513          	addi	a0,a0,-1900 # ffffffffc0201eb8 <commands+0x338>
>>>>>>> origin/main
ffffffffc020062c:	a87ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    cprintf("  t6       0x%08x\n", gpr->t6);
ffffffffc0200630:	7c6c                	ld	a1,248(s0)
}
ffffffffc0200632:	6402                	ld	s0,0(sp)
ffffffffc0200634:	60a2                	ld	ra,8(sp)
    cprintf("  t6       0x%08x\n", gpr->t6);
ffffffffc0200636:	00002517          	auipc	a0,0x2
<<<<<<< HEAD
ffffffffc020063a:	94a50513          	addi	a0,a0,-1718 # ffffffffc0201f80 <commands+0x370>
=======
ffffffffc020063a:	89a50513          	addi	a0,a0,-1894 # ffffffffc0201ed0 <commands+0x350>
>>>>>>> origin/main
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
<<<<<<< HEAD
ffffffffc020064e:	94e50513          	addi	a0,a0,-1714 # ffffffffc0201f98 <commands+0x388>
=======
ffffffffc020064e:	89e50513          	addi	a0,a0,-1890 # ffffffffc0201ee8 <commands+0x368>
>>>>>>> origin/main
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
<<<<<<< HEAD
ffffffffc0200666:	94e50513          	addi	a0,a0,-1714 # ffffffffc0201fb0 <commands+0x3a0>
=======
ffffffffc0200666:	89e50513          	addi	a0,a0,-1890 # ffffffffc0201f00 <commands+0x380>
>>>>>>> origin/main
ffffffffc020066a:	a49ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    cprintf("  epc      0x%08x\n", tf->epc);
ffffffffc020066e:	10843583          	ld	a1,264(s0)
ffffffffc0200672:	00002517          	auipc	a0,0x2
<<<<<<< HEAD
ffffffffc0200676:	95650513          	addi	a0,a0,-1706 # ffffffffc0201fc8 <commands+0x3b8>
=======
ffffffffc0200676:	8a650513          	addi	a0,a0,-1882 # ffffffffc0201f18 <commands+0x398>
>>>>>>> origin/main
ffffffffc020067a:	a39ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    cprintf("  badvaddr 0x%08x\n", tf->badvaddr);
ffffffffc020067e:	11043583          	ld	a1,272(s0)
ffffffffc0200682:	00002517          	auipc	a0,0x2
<<<<<<< HEAD
ffffffffc0200686:	95e50513          	addi	a0,a0,-1698 # ffffffffc0201fe0 <commands+0x3d0>
=======
ffffffffc0200686:	8ae50513          	addi	a0,a0,-1874 # ffffffffc0201f30 <commands+0x3b0>
>>>>>>> origin/main
ffffffffc020068a:	a29ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    cprintf("  cause    0x%08x\n", tf->cause);
ffffffffc020068e:	11843583          	ld	a1,280(s0)
}
ffffffffc0200692:	6402                	ld	s0,0(sp)
ffffffffc0200694:	60a2                	ld	ra,8(sp)
    cprintf("  cause    0x%08x\n", tf->cause);
ffffffffc0200696:	00002517          	auipc	a0,0x2
<<<<<<< HEAD
ffffffffc020069a:	96250513          	addi	a0,a0,-1694 # ffffffffc0201ff8 <commands+0x3e8>
=======
ffffffffc020069a:	8b250513          	addi	a0,a0,-1870 # ffffffffc0201f48 <commands+0x3c8>
>>>>>>> origin/main
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
<<<<<<< HEAD
ffffffffc02006b4:	a2870713          	addi	a4,a4,-1496 # ffffffffc02020d8 <commands+0x4c8>
=======
ffffffffc02006b4:	97870713          	addi	a4,a4,-1672 # ffffffffc0202028 <commands+0x4a8>
>>>>>>> origin/main
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
<<<<<<< HEAD
ffffffffc02006c6:	9ae50513          	addi	a0,a0,-1618 # ffffffffc0202070 <commands+0x460>
ffffffffc02006ca:	b2e5                	j	ffffffffc02000b2 <cprintf>
            cprintf("Hypervisor software interrupt\n");
ffffffffc02006cc:	00002517          	auipc	a0,0x2
ffffffffc02006d0:	98450513          	addi	a0,a0,-1660 # ffffffffc0202050 <commands+0x440>
ffffffffc02006d4:	baf9                	j	ffffffffc02000b2 <cprintf>
            cprintf("User software interrupt\n");
ffffffffc02006d6:	00002517          	auipc	a0,0x2
ffffffffc02006da:	93a50513          	addi	a0,a0,-1734 # ffffffffc0202010 <commands+0x400>
=======
ffffffffc02006c6:	8fe50513          	addi	a0,a0,-1794 # ffffffffc0201fc0 <commands+0x440>
ffffffffc02006ca:	b2e5                	j	ffffffffc02000b2 <cprintf>
            cprintf("Hypervisor software interrupt\n");
ffffffffc02006cc:	00002517          	auipc	a0,0x2
ffffffffc02006d0:	8d450513          	addi	a0,a0,-1836 # ffffffffc0201fa0 <commands+0x420>
ffffffffc02006d4:	baf9                	j	ffffffffc02000b2 <cprintf>
            cprintf("User software interrupt\n");
ffffffffc02006d6:	00002517          	auipc	a0,0x2
ffffffffc02006da:	88a50513          	addi	a0,a0,-1910 # ffffffffc0201f60 <commands+0x3e0>
>>>>>>> origin/main
ffffffffc02006de:	bad1                	j	ffffffffc02000b2 <cprintf>
            break;
        case IRQ_U_TIMER:
            cprintf("User Timer interrupt\n");
ffffffffc02006e0:	00002517          	auipc	a0,0x2
<<<<<<< HEAD
ffffffffc02006e4:	9b050513          	addi	a0,a0,-1616 # ffffffffc0202090 <commands+0x480>
=======
ffffffffc02006e4:	90050513          	addi	a0,a0,-1792 # ffffffffc0201fe0 <commands+0x460>
>>>>>>> origin/main
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
<<<<<<< HEAD
ffffffffc0200714:	9a850513          	addi	a0,a0,-1624 # ffffffffc02020b8 <commands+0x4a8>
ffffffffc0200718:	ba69                	j	ffffffffc02000b2 <cprintf>
            cprintf("Supervisor software interrupt\n");
ffffffffc020071a:	00002517          	auipc	a0,0x2
ffffffffc020071e:	91650513          	addi	a0,a0,-1770 # ffffffffc0202030 <commands+0x420>
=======
ffffffffc0200714:	8f850513          	addi	a0,a0,-1800 # ffffffffc0202008 <commands+0x488>
ffffffffc0200718:	ba69                	j	ffffffffc02000b2 <cprintf>
            cprintf("Supervisor software interrupt\n");
ffffffffc020071a:	00002517          	auipc	a0,0x2
ffffffffc020071e:	86650513          	addi	a0,a0,-1946 # ffffffffc0201f80 <commands+0x400>
>>>>>>> origin/main
ffffffffc0200722:	ba41                	j	ffffffffc02000b2 <cprintf>
            print_trapframe(tf);
ffffffffc0200724:	bf39                	j	ffffffffc0200642 <print_trapframe>
}
ffffffffc0200726:	60a2                	ld	ra,8(sp)
    cprintf("%d ticks\n", TICK_NUM);
ffffffffc0200728:	06400593          	li	a1,100
ffffffffc020072c:	00002517          	auipc	a0,0x2
<<<<<<< HEAD
ffffffffc0200730:	97c50513          	addi	a0,a0,-1668 # ffffffffc02020a8 <commands+0x498>
=======
ffffffffc0200730:	8cc50513          	addi	a0,a0,-1844 # ffffffffc0201ff8 <commands+0x478>
>>>>>>> origin/main
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

<<<<<<< HEAD
ffffffffc0200802 <best_fit_init>:
=======
ffffffffc0200802 <buddy_system_init>:
>>>>>>> origin/main
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
ffffffffc0200802:	00006797          	auipc	a5,0x6
<<<<<<< HEAD
ffffffffc0200806:	80e78793          	addi	a5,a5,-2034 # ffffffffc0206010 <free_area>
ffffffffc020080a:	e79c                	sd	a5,8(a5)
ffffffffc020080c:	e39c                	sd	a5,0(a5)
#define nr_free (free_area.nr_free)

static void
best_fit_init(void) {
=======
ffffffffc0200806:	80e78793          	addi	a5,a5,-2034 # ffffffffc0206010 <bsfree_area>
ffffffffc020080a:	e79c                	sd	a5,8(a5)
ffffffffc020080c:	e39c                	sd	a5,0(a5)


static void
buddy_system_init(void) {
>>>>>>> origin/main
    list_init(&free_list);
    nr_free = 0;
ffffffffc020080e:	0007a823          	sw	zero,16(a5)
}
ffffffffc0200812:	8082                	ret

<<<<<<< HEAD
ffffffffc0200814 <best_fit_nr_free_pages>:
}

static size_t
best_fit_nr_free_pages(void) {
    return nr_free;
}
ffffffffc0200814:	00006517          	auipc	a0,0x6
ffffffffc0200818:	80c56503          	lwu	a0,-2036(a0) # ffffffffc0206020 <free_area+0x10>
ffffffffc020081c:	8082                	ret

ffffffffc020081e <best_fit_check>:
=======
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
>>>>>>> origin/main
}

// LAB2: below code is used to check the best fit allocation algorithm 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
<<<<<<< HEAD
best_fit_check(void) {
ffffffffc020081e:	715d                	addi	sp,sp,-80
ffffffffc0200820:	e0a2                	sd	s0,64(sp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
ffffffffc0200822:	00005417          	auipc	s0,0x5
ffffffffc0200826:	7ee40413          	addi	s0,s0,2030 # ffffffffc0206010 <free_area>
ffffffffc020082a:	641c                	ld	a5,8(s0)
ffffffffc020082c:	e486                	sd	ra,72(sp)
ffffffffc020082e:	fc26                	sd	s1,56(sp)
ffffffffc0200830:	f84a                	sd	s2,48(sp)
ffffffffc0200832:	f44e                	sd	s3,40(sp)
ffffffffc0200834:	f052                	sd	s4,32(sp)
ffffffffc0200836:	ec56                	sd	s5,24(sp)
ffffffffc0200838:	e85a                	sd	s6,16(sp)
ffffffffc020083a:	e45e                	sd	s7,8(sp)
ffffffffc020083c:	e062                	sd	s8,0(sp)
    int score = 0 ,sumscore = 6;
    int count = 0, total = 0;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
ffffffffc020083e:	26878b63          	beq	a5,s0,ffffffffc0200ab4 <best_fit_check+0x296>
    int count = 0, total = 0;
ffffffffc0200842:	4481                	li	s1,0
ffffffffc0200844:	4901                	li	s2,0
=======
buddy_system_check(void) {
ffffffffc020081e:	7179                	addi	sp,sp,-48
ffffffffc0200820:	e84a                	sd	s2,16(sp)
ffffffffc0200822:	f406                	sd	ra,40(sp)
ffffffffc0200824:	f022                	sd	s0,32(sp)
ffffffffc0200826:	ec26                	sd	s1,24(sp)
ffffffffc0200828:	e44e                	sd	s3,8(sp)
    int all_pages = nr_free_pages();
ffffffffc020082a:	1a5000ef          	jal	ra,ffffffffc02011ce <nr_free_pages>
ffffffffc020082e:	892a                	mv	s2,a0
    struct Page* p0, *p1, *p2, *p3;
    // 分配过大的页数
    assert(alloc_pages(all_pages + 1) == NULL);
ffffffffc0200830:	2505                	addiw	a0,a0,1
ffffffffc0200832:	11f000ef          	jal	ra,ffffffffc0201150 <alloc_pages>
ffffffffc0200836:	1a051763          	bnez	a0,ffffffffc02009e4 <buddy_system_check+0x1c6>

    //在实验里发现了可分配page数量不是2的次方
    //这里是验证是不是正确选择了合适的页
    //因为不是2的次方，根据分配策略p0较小应该是在后面的内存块，而p1是在最前面的
    //如果没有成功执行策略，p1无法获得内存，因为p0的分配分割了第二层左孩子结点对应的内存块，而没有能满足p1大小的内存块。
    p0 = alloc_pages(1);
ffffffffc020083a:	4505                	li	a0,1
ffffffffc020083c:	115000ef          	jal	ra,ffffffffc0201150 <alloc_pages>
ffffffffc0200840:	84aa                	mv	s1,a0
    assert(p0 != NULL);
ffffffffc0200842:	14050163          	beqz	a0,ffffffffc0200984 <buddy_system_check+0x166>
    p1 = alloc_pages(all_pages/2);
ffffffffc0200846:	2901                	sext.w	s2,s2
ffffffffc0200848:	01f9541b          	srliw	s0,s2,0x1f
ffffffffc020084c:	0124043b          	addw	s0,s0,s2
ffffffffc0200850:	4014541b          	sraiw	s0,s0,0x1
ffffffffc0200854:	8522                	mv	a0,s0
ffffffffc0200856:	0fb000ef          	jal	ra,ffffffffc0201150 <alloc_pages>
    assert(p1 != NULL);
ffffffffc020085a:	14050563          	beqz	a0,ffffffffc02009a4 <buddy_system_check+0x186>
    assert(p1 == propertypages);
ffffffffc020085e:	00006717          	auipc	a4,0x6
ffffffffc0200862:	bda73703          	ld	a4,-1062(a4) # ffffffffc0206438 <propertypages>
ffffffffc0200866:	1ca71f63          	bne	a4,a0,ffffffffc0200a44 <buddy_system_check+0x226>
    free_pages(p1, all_pages/2);
ffffffffc020086a:	85a2                	mv	a1,s0
ffffffffc020086c:	123000ef          	jal	ra,ffffffffc020118e <free_pages>
    //重新分配p1
    p1 = alloc_pages(2);
ffffffffc0200870:	4509                	li	a0,2
ffffffffc0200872:	0df000ef          	jal	ra,ffffffffc0201150 <alloc_pages>
>>>>>>> origin/main
 * test_bit - Determine whether a bit is set
 * @nr:     the bit to test
 * @addr:   the address to count from
 * */
static inline bool test_bit(int nr, volatile void *addr) {
    return (((*(volatile unsigned long *)addr) >> nr) & 1);
<<<<<<< HEAD
ffffffffc0200846:	ff07b703          	ld	a4,-16(a5)
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
ffffffffc020084a:	8b09                	andi	a4,a4,2
ffffffffc020084c:	26070863          	beqz	a4,ffffffffc0200abc <best_fit_check+0x29e>
        count ++, total += p->property;
ffffffffc0200850:	ff87a703          	lw	a4,-8(a5)
ffffffffc0200854:	679c                	ld	a5,8(a5)
ffffffffc0200856:	2905                	addiw	s2,s2,1
ffffffffc0200858:	9cb9                	addw	s1,s1,a4
    while ((le = list_next(le)) != &free_list) {
ffffffffc020085a:	fe8796e3          	bne	a5,s0,ffffffffc0200846 <best_fit_check+0x28>
    }
    assert(total == nr_free_pages());
ffffffffc020085e:	89a6                	mv	s3,s1
ffffffffc0200860:	233000ef          	jal	ra,ffffffffc0201292 <nr_free_pages>
ffffffffc0200864:	33351c63          	bne	a0,s3,ffffffffc0200b9c <best_fit_check+0x37e>
    assert((p0 = alloc_page()) != NULL);
ffffffffc0200868:	4505                	li	a0,1
ffffffffc020086a:	1ab000ef          	jal	ra,ffffffffc0201214 <alloc_pages>
ffffffffc020086e:	8a2a                	mv	s4,a0
ffffffffc0200870:	36050663          	beqz	a0,ffffffffc0200bdc <best_fit_check+0x3be>
    assert((p1 = alloc_page()) != NULL);
ffffffffc0200874:	4505                	li	a0,1
ffffffffc0200876:	19f000ef          	jal	ra,ffffffffc0201214 <alloc_pages>
ffffffffc020087a:	89aa                	mv	s3,a0
ffffffffc020087c:	34050063          	beqz	a0,ffffffffc0200bbc <best_fit_check+0x39e>
    assert((p2 = alloc_page()) != NULL);
ffffffffc0200880:	4505                	li	a0,1
ffffffffc0200882:	193000ef          	jal	ra,ffffffffc0201214 <alloc_pages>
ffffffffc0200886:	8aaa                	mv	s5,a0
ffffffffc0200888:	2c050a63          	beqz	a0,ffffffffc0200b5c <best_fit_check+0x33e>
    assert(p0 != p1 && p0 != p2 && p1 != p2);
ffffffffc020088c:	253a0863          	beq	s4,s3,ffffffffc0200adc <best_fit_check+0x2be>
ffffffffc0200890:	24aa0663          	beq	s4,a0,ffffffffc0200adc <best_fit_check+0x2be>
ffffffffc0200894:	24a98463          	beq	s3,a0,ffffffffc0200adc <best_fit_check+0x2be>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
ffffffffc0200898:	000a2783          	lw	a5,0(s4)
ffffffffc020089c:	26079063          	bnez	a5,ffffffffc0200afc <best_fit_check+0x2de>
ffffffffc02008a0:	0009a783          	lw	a5,0(s3)
ffffffffc02008a4:	24079c63          	bnez	a5,ffffffffc0200afc <best_fit_check+0x2de>
ffffffffc02008a8:	411c                	lw	a5,0(a0)
ffffffffc02008aa:	24079963          	bnez	a5,ffffffffc0200afc <best_fit_check+0x2de>
extern struct Page *pages;
extern size_t npage;
extern const size_t nbase;
extern uint64_t va_pa_offset;

static inline ppn_t page2ppn(struct Page *page) { return page - pages + nbase; }
ffffffffc02008ae:	00006797          	auipc	a5,0x6
ffffffffc02008b2:	b927b783          	ld	a5,-1134(a5) # ffffffffc0206440 <pages>
ffffffffc02008b6:	40fa0733          	sub	a4,s4,a5
ffffffffc02008ba:	870d                	srai	a4,a4,0x3
ffffffffc02008bc:	00002597          	auipc	a1,0x2
ffffffffc02008c0:	f3c5b583          	ld	a1,-196(a1) # ffffffffc02027f8 <error_string+0x38>
ffffffffc02008c4:	02b70733          	mul	a4,a4,a1
ffffffffc02008c8:	00002617          	auipc	a2,0x2
ffffffffc02008cc:	f3863603          	ld	a2,-200(a2) # ffffffffc0202800 <nbase>
    assert(page2pa(p0) < npage * PGSIZE);
ffffffffc02008d0:	00006697          	auipc	a3,0x6
ffffffffc02008d4:	b686b683          	ld	a3,-1176(a3) # ffffffffc0206438 <npage>
ffffffffc02008d8:	06b2                	slli	a3,a3,0xc
ffffffffc02008da:	9732                	add	a4,a4,a2
//将page类型的指针转化为物理页号
static inline uintptr_t page2pa(struct Page *page) {
    return page2ppn(page) << PGSHIFT;
ffffffffc02008dc:	0732                	slli	a4,a4,0xc
ffffffffc02008de:	22d77f63          	bgeu	a4,a3,ffffffffc0200b1c <best_fit_check+0x2fe>
static inline ppn_t page2ppn(struct Page *page) { return page - pages + nbase; }
ffffffffc02008e2:	40f98733          	sub	a4,s3,a5
ffffffffc02008e6:	870d                	srai	a4,a4,0x3
ffffffffc02008e8:	02b70733          	mul	a4,a4,a1
ffffffffc02008ec:	9732                	add	a4,a4,a2
    return page2ppn(page) << PGSHIFT;
ffffffffc02008ee:	0732                	slli	a4,a4,0xc
    assert(page2pa(p1) < npage * PGSIZE);
ffffffffc02008f0:	3ed77663          	bgeu	a4,a3,ffffffffc0200cdc <best_fit_check+0x4be>
static inline ppn_t page2ppn(struct Page *page) { return page - pages + nbase; }
ffffffffc02008f4:	40f507b3          	sub	a5,a0,a5
ffffffffc02008f8:	878d                	srai	a5,a5,0x3
ffffffffc02008fa:	02b787b3          	mul	a5,a5,a1
ffffffffc02008fe:	97b2                	add	a5,a5,a2
    return page2ppn(page) << PGSHIFT;
ffffffffc0200900:	07b2                	slli	a5,a5,0xc
    assert(page2pa(p2) < npage * PGSIZE);
ffffffffc0200902:	3ad7fd63          	bgeu	a5,a3,ffffffffc0200cbc <best_fit_check+0x49e>
    assert(alloc_page() == NULL);
ffffffffc0200906:	4505                	li	a0,1
    list_entry_t free_list_store = free_list;
ffffffffc0200908:	00043c03          	ld	s8,0(s0)
ffffffffc020090c:	00843b83          	ld	s7,8(s0)
    unsigned int nr_free_store = nr_free;
ffffffffc0200910:	01042b03          	lw	s6,16(s0)
    elm->prev = elm->next = elm;
ffffffffc0200914:	e400                	sd	s0,8(s0)
ffffffffc0200916:	e000                	sd	s0,0(s0)
    nr_free = 0;
ffffffffc0200918:	00005797          	auipc	a5,0x5
ffffffffc020091c:	7007a423          	sw	zero,1800(a5) # ffffffffc0206020 <free_area+0x10>
    assert(alloc_page() == NULL);
ffffffffc0200920:	0f5000ef          	jal	ra,ffffffffc0201214 <alloc_pages>
ffffffffc0200924:	36051c63          	bnez	a0,ffffffffc0200c9c <best_fit_check+0x47e>
    free_page(p0);
ffffffffc0200928:	4585                	li	a1,1
ffffffffc020092a:	8552                	mv	a0,s4
ffffffffc020092c:	127000ef          	jal	ra,ffffffffc0201252 <free_pages>
    free_page(p1);
ffffffffc0200930:	4585                	li	a1,1
ffffffffc0200932:	854e                	mv	a0,s3
ffffffffc0200934:	11f000ef          	jal	ra,ffffffffc0201252 <free_pages>
    free_page(p2);
ffffffffc0200938:	4585                	li	a1,1
ffffffffc020093a:	8556                	mv	a0,s5
ffffffffc020093c:	117000ef          	jal	ra,ffffffffc0201252 <free_pages>
    assert(nr_free == 3);
ffffffffc0200940:	4818                	lw	a4,16(s0)
ffffffffc0200942:	478d                	li	a5,3
ffffffffc0200944:	32f71c63          	bne	a4,a5,ffffffffc0200c7c <best_fit_check+0x45e>
    assert((p0 = alloc_page()) != NULL);
ffffffffc0200948:	4505                	li	a0,1
ffffffffc020094a:	0cb000ef          	jal	ra,ffffffffc0201214 <alloc_pages>
ffffffffc020094e:	89aa                	mv	s3,a0
ffffffffc0200950:	30050663          	beqz	a0,ffffffffc0200c5c <best_fit_check+0x43e>
    assert((p1 = alloc_page()) != NULL);
ffffffffc0200954:	4505                	li	a0,1
ffffffffc0200956:	0bf000ef          	jal	ra,ffffffffc0201214 <alloc_pages>
ffffffffc020095a:	8aaa                	mv	s5,a0
ffffffffc020095c:	2e050063          	beqz	a0,ffffffffc0200c3c <best_fit_check+0x41e>
    assert((p2 = alloc_page()) != NULL);
ffffffffc0200960:	4505                	li	a0,1
ffffffffc0200962:	0b3000ef          	jal	ra,ffffffffc0201214 <alloc_pages>
ffffffffc0200966:	8a2a                	mv	s4,a0
ffffffffc0200968:	2a050a63          	beqz	a0,ffffffffc0200c1c <best_fit_check+0x3fe>
    assert(alloc_page() == NULL);
ffffffffc020096c:	4505                	li	a0,1
ffffffffc020096e:	0a7000ef          	jal	ra,ffffffffc0201214 <alloc_pages>
ffffffffc0200972:	28051563          	bnez	a0,ffffffffc0200bfc <best_fit_check+0x3de>
    free_page(p0);
ffffffffc0200976:	4585                	li	a1,1
ffffffffc0200978:	854e                	mv	a0,s3
ffffffffc020097a:	0d9000ef          	jal	ra,ffffffffc0201252 <free_pages>
    assert(!list_empty(&free_list));
ffffffffc020097e:	641c                	ld	a5,8(s0)
ffffffffc0200980:	1a878e63          	beq	a5,s0,ffffffffc0200b3c <best_fit_check+0x31e>
    assert((p = alloc_page()) == p0);
ffffffffc0200984:	4505                	li	a0,1
ffffffffc0200986:	08f000ef          	jal	ra,ffffffffc0201214 <alloc_pages>
ffffffffc020098a:	52a99963          	bne	s3,a0,ffffffffc0200ebc <best_fit_check+0x69e>
    assert(alloc_page() == NULL);
ffffffffc020098e:	4505                	li	a0,1
ffffffffc0200990:	085000ef          	jal	ra,ffffffffc0201214 <alloc_pages>
ffffffffc0200994:	50051463          	bnez	a0,ffffffffc0200e9c <best_fit_check+0x67e>
    assert(nr_free == 0);
ffffffffc0200998:	481c                	lw	a5,16(s0)
ffffffffc020099a:	4e079163          	bnez	a5,ffffffffc0200e7c <best_fit_check+0x65e>
    free_page(p);
ffffffffc020099e:	854e                	mv	a0,s3
ffffffffc02009a0:	4585                	li	a1,1
    free_list = free_list_store;
ffffffffc02009a2:	01843023          	sd	s8,0(s0)
ffffffffc02009a6:	01743423          	sd	s7,8(s0)
    nr_free = nr_free_store;
ffffffffc02009aa:	01642823          	sw	s6,16(s0)
    free_page(p);
ffffffffc02009ae:	0a5000ef          	jal	ra,ffffffffc0201252 <free_pages>
    free_page(p1);
ffffffffc02009b2:	4585                	li	a1,1
ffffffffc02009b4:	8556                	mv	a0,s5
ffffffffc02009b6:	09d000ef          	jal	ra,ffffffffc0201252 <free_pages>
    free_page(p2);
ffffffffc02009ba:	4585                	li	a1,1
ffffffffc02009bc:	8552                	mv	a0,s4
ffffffffc02009be:	095000ef          	jal	ra,ffffffffc0201252 <free_pages>

    #ifdef ucore_test
    score += 1;
    cprintf("grading: %d / %d points\n",score, sumscore);
    #endif
    struct Page *p0 = alloc_pages(5), *p1, *p2;
ffffffffc02009c2:	4515                	li	a0,5
ffffffffc02009c4:	051000ef          	jal	ra,ffffffffc0201214 <alloc_pages>
ffffffffc02009c8:	89aa                	mv	s3,a0
    assert(p0 != NULL);
ffffffffc02009ca:	48050963          	beqz	a0,ffffffffc0200e5c <best_fit_check+0x63e>
ffffffffc02009ce:	651c                	ld	a5,8(a0)
ffffffffc02009d0:	8385                	srli	a5,a5,0x1
    assert(!PageProperty(p0));
ffffffffc02009d2:	8b85                	andi	a5,a5,1
ffffffffc02009d4:	46079463          	bnez	a5,ffffffffc0200e3c <best_fit_check+0x61e>
    cprintf("grading: %d / %d points\n",score, sumscore);
    #endif
    list_entry_t free_list_store = free_list;
    list_init(&free_list);
    assert(list_empty(&free_list));
    assert(alloc_page() == NULL);
ffffffffc02009d8:	4505                	li	a0,1
    list_entry_t free_list_store = free_list;
ffffffffc02009da:	00043a83          	ld	s5,0(s0)
ffffffffc02009de:	00843a03          	ld	s4,8(s0)
ffffffffc02009e2:	e000                	sd	s0,0(s0)
ffffffffc02009e4:	e400                	sd	s0,8(s0)
    assert(alloc_page() == NULL);
ffffffffc02009e6:	02f000ef          	jal	ra,ffffffffc0201214 <alloc_pages>
ffffffffc02009ea:	42051963          	bnez	a0,ffffffffc0200e1c <best_fit_check+0x5fe>
    #endif
    unsigned int nr_free_store = nr_free;
    nr_free = 0;

    // * - - * -
    free_pages(p0 + 1, 2);
ffffffffc02009ee:	4589                	li	a1,2
ffffffffc02009f0:	02898513          	addi	a0,s3,40
    unsigned int nr_free_store = nr_free;
ffffffffc02009f4:	01042b03          	lw	s6,16(s0)
    free_pages(p0 + 4, 1);
ffffffffc02009f8:	0a098c13          	addi	s8,s3,160
    nr_free = 0;
ffffffffc02009fc:	00005797          	auipc	a5,0x5
ffffffffc0200a00:	6207a223          	sw	zero,1572(a5) # ffffffffc0206020 <free_area+0x10>
    free_pages(p0 + 1, 2);
ffffffffc0200a04:	04f000ef          	jal	ra,ffffffffc0201252 <free_pages>
    free_pages(p0 + 4, 1);
ffffffffc0200a08:	8562                	mv	a0,s8
ffffffffc0200a0a:	4585                	li	a1,1
ffffffffc0200a0c:	047000ef          	jal	ra,ffffffffc0201252 <free_pages>
    assert(alloc_pages(4) == NULL);
ffffffffc0200a10:	4511                	li	a0,4
ffffffffc0200a12:	003000ef          	jal	ra,ffffffffc0201214 <alloc_pages>
ffffffffc0200a16:	3e051363          	bnez	a0,ffffffffc0200dfc <best_fit_check+0x5de>
ffffffffc0200a1a:	0309b783          	ld	a5,48(s3)
ffffffffc0200a1e:	8385                	srli	a5,a5,0x1
    assert(PageProperty(p0 + 1) && p0[1].property == 2);
ffffffffc0200a20:	8b85                	andi	a5,a5,1
ffffffffc0200a22:	3a078d63          	beqz	a5,ffffffffc0200ddc <best_fit_check+0x5be>
ffffffffc0200a26:	0389a703          	lw	a4,56(s3)
ffffffffc0200a2a:	4789                	li	a5,2
ffffffffc0200a2c:	3af71863          	bne	a4,a5,ffffffffc0200ddc <best_fit_check+0x5be>
    // * - - * *
    assert((p1 = alloc_pages(1)) != NULL);
ffffffffc0200a30:	4505                	li	a0,1
ffffffffc0200a32:	7e2000ef          	jal	ra,ffffffffc0201214 <alloc_pages>
ffffffffc0200a36:	8baa                	mv	s7,a0
ffffffffc0200a38:	38050263          	beqz	a0,ffffffffc0200dbc <best_fit_check+0x59e>
    assert(alloc_pages(2) != NULL);      // best fit feature
ffffffffc0200a3c:	4509                	li	a0,2
ffffffffc0200a3e:	7d6000ef          	jal	ra,ffffffffc0201214 <alloc_pages>
ffffffffc0200a42:	34050d63          	beqz	a0,ffffffffc0200d9c <best_fit_check+0x57e>
    assert(p0 + 4 == p1);
ffffffffc0200a46:	337c1b63          	bne	s8,s7,ffffffffc0200d7c <best_fit_check+0x55e>
    #ifdef ucore_test
    score += 1;
    cprintf("grading: %d / %d points\n",score, sumscore);
    #endif
    p2 = p0 + 1;
    free_pages(p0, 5);
ffffffffc0200a4a:	854e                	mv	a0,s3
ffffffffc0200a4c:	4595                	li	a1,5
ffffffffc0200a4e:	005000ef          	jal	ra,ffffffffc0201252 <free_pages>
    assert((p0 = alloc_pages(5)) != NULL);
ffffffffc0200a52:	4515                	li	a0,5
ffffffffc0200a54:	7c0000ef          	jal	ra,ffffffffc0201214 <alloc_pages>
ffffffffc0200a58:	89aa                	mv	s3,a0
ffffffffc0200a5a:	30050163          	beqz	a0,ffffffffc0200d5c <best_fit_check+0x53e>
    assert(alloc_page() == NULL);
ffffffffc0200a5e:	4505                	li	a0,1
ffffffffc0200a60:	7b4000ef          	jal	ra,ffffffffc0201214 <alloc_pages>
ffffffffc0200a64:	2c051c63          	bnez	a0,ffffffffc0200d3c <best_fit_check+0x51e>

    #ifdef ucore_test
    score += 1;
    cprintf("grading: %d / %d points\n",score, sumscore);
    #endif
    assert(nr_free == 0);
ffffffffc0200a68:	481c                	lw	a5,16(s0)
ffffffffc0200a6a:	2a079963          	bnez	a5,ffffffffc0200d1c <best_fit_check+0x4fe>
    nr_free = nr_free_store;

    free_list = free_list_store;
    free_pages(p0, 5);
ffffffffc0200a6e:	4595                	li	a1,5
ffffffffc0200a70:	854e                	mv	a0,s3
    nr_free = nr_free_store;
ffffffffc0200a72:	01642823          	sw	s6,16(s0)
    free_list = free_list_store;
ffffffffc0200a76:	01543023          	sd	s5,0(s0)
ffffffffc0200a7a:	01443423          	sd	s4,8(s0)
    free_pages(p0, 5);
ffffffffc0200a7e:	7d4000ef          	jal	ra,ffffffffc0201252 <free_pages>
    return listelm->next;
ffffffffc0200a82:	641c                	ld	a5,8(s0)

    le = &free_list;
    while ((le = list_next(le)) != &free_list) {
ffffffffc0200a84:	00878963          	beq	a5,s0,ffffffffc0200a96 <best_fit_check+0x278>
        struct Page *p = le2page(le, page_link);
        count --, total -= p->property;
ffffffffc0200a88:	ff87a703          	lw	a4,-8(a5)
ffffffffc0200a8c:	679c                	ld	a5,8(a5)
ffffffffc0200a8e:	397d                	addiw	s2,s2,-1
ffffffffc0200a90:	9c99                	subw	s1,s1,a4
    while ((le = list_next(le)) != &free_list) {
ffffffffc0200a92:	fe879be3          	bne	a5,s0,ffffffffc0200a88 <best_fit_check+0x26a>
    }
    assert(count == 0);
ffffffffc0200a96:	26091363          	bnez	s2,ffffffffc0200cfc <best_fit_check+0x4de>
    assert(total == 0);
ffffffffc0200a9a:	e0ed                	bnez	s1,ffffffffc0200b7c <best_fit_check+0x35e>
    #ifdef ucore_test
    score += 1;
    cprintf("grading: %d / %d points\n",score, sumscore);
    #endif
}
ffffffffc0200a9c:	60a6                	ld	ra,72(sp)
ffffffffc0200a9e:	6406                	ld	s0,64(sp)
ffffffffc0200aa0:	74e2                	ld	s1,56(sp)
ffffffffc0200aa2:	7942                	ld	s2,48(sp)
ffffffffc0200aa4:	79a2                	ld	s3,40(sp)
ffffffffc0200aa6:	7a02                	ld	s4,32(sp)
ffffffffc0200aa8:	6ae2                	ld	s5,24(sp)
ffffffffc0200aaa:	6b42                	ld	s6,16(sp)
ffffffffc0200aac:	6ba2                	ld	s7,8(sp)
ffffffffc0200aae:	6c02                	ld	s8,0(sp)
ffffffffc0200ab0:	6161                	addi	sp,sp,80
ffffffffc0200ab2:	8082                	ret
    while ((le = list_next(le)) != &free_list) {
ffffffffc0200ab4:	4981                	li	s3,0
    int count = 0, total = 0;
ffffffffc0200ab6:	4481                	li	s1,0
ffffffffc0200ab8:	4901                	li	s2,0
ffffffffc0200aba:	b35d                	j	ffffffffc0200860 <best_fit_check+0x42>
        assert(PageProperty(p));
ffffffffc0200abc:	00001697          	auipc	a3,0x1
ffffffffc0200ac0:	64c68693          	addi	a3,a3,1612 # ffffffffc0202108 <commands+0x4f8>
ffffffffc0200ac4:	00001617          	auipc	a2,0x1
ffffffffc0200ac8:	65460613          	addi	a2,a2,1620 # ffffffffc0202118 <commands+0x508>
ffffffffc0200acc:	10a00593          	li	a1,266
ffffffffc0200ad0:	00001517          	auipc	a0,0x1
ffffffffc0200ad4:	66050513          	addi	a0,a0,1632 # ffffffffc0202130 <commands+0x520>
ffffffffc0200ad8:	8d5ff0ef          	jal	ra,ffffffffc02003ac <__panic>
    assert(p0 != p1 && p0 != p2 && p1 != p2);
ffffffffc0200adc:	00001697          	auipc	a3,0x1
ffffffffc0200ae0:	6ec68693          	addi	a3,a3,1772 # ffffffffc02021c8 <commands+0x5b8>
ffffffffc0200ae4:	00001617          	auipc	a2,0x1
ffffffffc0200ae8:	63460613          	addi	a2,a2,1588 # ffffffffc0202118 <commands+0x508>
ffffffffc0200aec:	0d600593          	li	a1,214
ffffffffc0200af0:	00001517          	auipc	a0,0x1
ffffffffc0200af4:	64050513          	addi	a0,a0,1600 # ffffffffc0202130 <commands+0x520>
ffffffffc0200af8:	8b5ff0ef          	jal	ra,ffffffffc02003ac <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
ffffffffc0200afc:	00001697          	auipc	a3,0x1
ffffffffc0200b00:	6f468693          	addi	a3,a3,1780 # ffffffffc02021f0 <commands+0x5e0>
ffffffffc0200b04:	00001617          	auipc	a2,0x1
ffffffffc0200b08:	61460613          	addi	a2,a2,1556 # ffffffffc0202118 <commands+0x508>
ffffffffc0200b0c:	0d700593          	li	a1,215
ffffffffc0200b10:	00001517          	auipc	a0,0x1
ffffffffc0200b14:	62050513          	addi	a0,a0,1568 # ffffffffc0202130 <commands+0x520>
ffffffffc0200b18:	895ff0ef          	jal	ra,ffffffffc02003ac <__panic>
    assert(page2pa(p0) < npage * PGSIZE);
ffffffffc0200b1c:	00001697          	auipc	a3,0x1
ffffffffc0200b20:	71468693          	addi	a3,a3,1812 # ffffffffc0202230 <commands+0x620>
ffffffffc0200b24:	00001617          	auipc	a2,0x1
ffffffffc0200b28:	5f460613          	addi	a2,a2,1524 # ffffffffc0202118 <commands+0x508>
ffffffffc0200b2c:	0d900593          	li	a1,217
ffffffffc0200b30:	00001517          	auipc	a0,0x1
ffffffffc0200b34:	60050513          	addi	a0,a0,1536 # ffffffffc0202130 <commands+0x520>
ffffffffc0200b38:	875ff0ef          	jal	ra,ffffffffc02003ac <__panic>
    assert(!list_empty(&free_list));
ffffffffc0200b3c:	00001697          	auipc	a3,0x1
ffffffffc0200b40:	77c68693          	addi	a3,a3,1916 # ffffffffc02022b8 <commands+0x6a8>
ffffffffc0200b44:	00001617          	auipc	a2,0x1
ffffffffc0200b48:	5d460613          	addi	a2,a2,1492 # ffffffffc0202118 <commands+0x508>
ffffffffc0200b4c:	0f200593          	li	a1,242
ffffffffc0200b50:	00001517          	auipc	a0,0x1
ffffffffc0200b54:	5e050513          	addi	a0,a0,1504 # ffffffffc0202130 <commands+0x520>
ffffffffc0200b58:	855ff0ef          	jal	ra,ffffffffc02003ac <__panic>
    assert((p2 = alloc_page()) != NULL);
ffffffffc0200b5c:	00001697          	auipc	a3,0x1
ffffffffc0200b60:	64c68693          	addi	a3,a3,1612 # ffffffffc02021a8 <commands+0x598>
ffffffffc0200b64:	00001617          	auipc	a2,0x1
ffffffffc0200b68:	5b460613          	addi	a2,a2,1460 # ffffffffc0202118 <commands+0x508>
ffffffffc0200b6c:	0d400593          	li	a1,212
ffffffffc0200b70:	00001517          	auipc	a0,0x1
ffffffffc0200b74:	5c050513          	addi	a0,a0,1472 # ffffffffc0202130 <commands+0x520>
ffffffffc0200b78:	835ff0ef          	jal	ra,ffffffffc02003ac <__panic>
    assert(total == 0);
ffffffffc0200b7c:	00002697          	auipc	a3,0x2
ffffffffc0200b80:	86c68693          	addi	a3,a3,-1940 # ffffffffc02023e8 <commands+0x7d8>
ffffffffc0200b84:	00001617          	auipc	a2,0x1
ffffffffc0200b88:	59460613          	addi	a2,a2,1428 # ffffffffc0202118 <commands+0x508>
ffffffffc0200b8c:	14c00593          	li	a1,332
ffffffffc0200b90:	00001517          	auipc	a0,0x1
ffffffffc0200b94:	5a050513          	addi	a0,a0,1440 # ffffffffc0202130 <commands+0x520>
ffffffffc0200b98:	815ff0ef          	jal	ra,ffffffffc02003ac <__panic>
    assert(total == nr_free_pages());
ffffffffc0200b9c:	00001697          	auipc	a3,0x1
ffffffffc0200ba0:	5ac68693          	addi	a3,a3,1452 # ffffffffc0202148 <commands+0x538>
ffffffffc0200ba4:	00001617          	auipc	a2,0x1
ffffffffc0200ba8:	57460613          	addi	a2,a2,1396 # ffffffffc0202118 <commands+0x508>
ffffffffc0200bac:	10d00593          	li	a1,269
ffffffffc0200bb0:	00001517          	auipc	a0,0x1
ffffffffc0200bb4:	58050513          	addi	a0,a0,1408 # ffffffffc0202130 <commands+0x520>
ffffffffc0200bb8:	ff4ff0ef          	jal	ra,ffffffffc02003ac <__panic>
    assert((p1 = alloc_page()) != NULL);
ffffffffc0200bbc:	00001697          	auipc	a3,0x1
ffffffffc0200bc0:	5cc68693          	addi	a3,a3,1484 # ffffffffc0202188 <commands+0x578>
ffffffffc0200bc4:	00001617          	auipc	a2,0x1
ffffffffc0200bc8:	55460613          	addi	a2,a2,1364 # ffffffffc0202118 <commands+0x508>
ffffffffc0200bcc:	0d300593          	li	a1,211
ffffffffc0200bd0:	00001517          	auipc	a0,0x1
ffffffffc0200bd4:	56050513          	addi	a0,a0,1376 # ffffffffc0202130 <commands+0x520>
ffffffffc0200bd8:	fd4ff0ef          	jal	ra,ffffffffc02003ac <__panic>
    assert((p0 = alloc_page()) != NULL);
ffffffffc0200bdc:	00001697          	auipc	a3,0x1
ffffffffc0200be0:	58c68693          	addi	a3,a3,1420 # ffffffffc0202168 <commands+0x558>
ffffffffc0200be4:	00001617          	auipc	a2,0x1
ffffffffc0200be8:	53460613          	addi	a2,a2,1332 # ffffffffc0202118 <commands+0x508>
ffffffffc0200bec:	0d200593          	li	a1,210
ffffffffc0200bf0:	00001517          	auipc	a0,0x1
ffffffffc0200bf4:	54050513          	addi	a0,a0,1344 # ffffffffc0202130 <commands+0x520>
ffffffffc0200bf8:	fb4ff0ef          	jal	ra,ffffffffc02003ac <__panic>
    assert(alloc_page() == NULL);
ffffffffc0200bfc:	00001697          	auipc	a3,0x1
ffffffffc0200c00:	69468693          	addi	a3,a3,1684 # ffffffffc0202290 <commands+0x680>
ffffffffc0200c04:	00001617          	auipc	a2,0x1
ffffffffc0200c08:	51460613          	addi	a2,a2,1300 # ffffffffc0202118 <commands+0x508>
ffffffffc0200c0c:	0ef00593          	li	a1,239
ffffffffc0200c10:	00001517          	auipc	a0,0x1
ffffffffc0200c14:	52050513          	addi	a0,a0,1312 # ffffffffc0202130 <commands+0x520>
ffffffffc0200c18:	f94ff0ef          	jal	ra,ffffffffc02003ac <__panic>
    assert((p2 = alloc_page()) != NULL);
ffffffffc0200c1c:	00001697          	auipc	a3,0x1
ffffffffc0200c20:	58c68693          	addi	a3,a3,1420 # ffffffffc02021a8 <commands+0x598>
ffffffffc0200c24:	00001617          	auipc	a2,0x1
ffffffffc0200c28:	4f460613          	addi	a2,a2,1268 # ffffffffc0202118 <commands+0x508>
ffffffffc0200c2c:	0ed00593          	li	a1,237
ffffffffc0200c30:	00001517          	auipc	a0,0x1
ffffffffc0200c34:	50050513          	addi	a0,a0,1280 # ffffffffc0202130 <commands+0x520>
ffffffffc0200c38:	f74ff0ef          	jal	ra,ffffffffc02003ac <__panic>
    assert((p1 = alloc_page()) != NULL);
ffffffffc0200c3c:	00001697          	auipc	a3,0x1
ffffffffc0200c40:	54c68693          	addi	a3,a3,1356 # ffffffffc0202188 <commands+0x578>
ffffffffc0200c44:	00001617          	auipc	a2,0x1
ffffffffc0200c48:	4d460613          	addi	a2,a2,1236 # ffffffffc0202118 <commands+0x508>
ffffffffc0200c4c:	0ec00593          	li	a1,236
ffffffffc0200c50:	00001517          	auipc	a0,0x1
ffffffffc0200c54:	4e050513          	addi	a0,a0,1248 # ffffffffc0202130 <commands+0x520>
ffffffffc0200c58:	f54ff0ef          	jal	ra,ffffffffc02003ac <__panic>
    assert((p0 = alloc_page()) != NULL);
ffffffffc0200c5c:	00001697          	auipc	a3,0x1
ffffffffc0200c60:	50c68693          	addi	a3,a3,1292 # ffffffffc0202168 <commands+0x558>
ffffffffc0200c64:	00001617          	auipc	a2,0x1
ffffffffc0200c68:	4b460613          	addi	a2,a2,1204 # ffffffffc0202118 <commands+0x508>
ffffffffc0200c6c:	0eb00593          	li	a1,235
ffffffffc0200c70:	00001517          	auipc	a0,0x1
ffffffffc0200c74:	4c050513          	addi	a0,a0,1216 # ffffffffc0202130 <commands+0x520>
ffffffffc0200c78:	f34ff0ef          	jal	ra,ffffffffc02003ac <__panic>
    assert(nr_free == 3);
ffffffffc0200c7c:	00001697          	auipc	a3,0x1
ffffffffc0200c80:	62c68693          	addi	a3,a3,1580 # ffffffffc02022a8 <commands+0x698>
ffffffffc0200c84:	00001617          	auipc	a2,0x1
ffffffffc0200c88:	49460613          	addi	a2,a2,1172 # ffffffffc0202118 <commands+0x508>
ffffffffc0200c8c:	0e900593          	li	a1,233
ffffffffc0200c90:	00001517          	auipc	a0,0x1
ffffffffc0200c94:	4a050513          	addi	a0,a0,1184 # ffffffffc0202130 <commands+0x520>
ffffffffc0200c98:	f14ff0ef          	jal	ra,ffffffffc02003ac <__panic>
    assert(alloc_page() == NULL);
ffffffffc0200c9c:	00001697          	auipc	a3,0x1
ffffffffc0200ca0:	5f468693          	addi	a3,a3,1524 # ffffffffc0202290 <commands+0x680>
ffffffffc0200ca4:	00001617          	auipc	a2,0x1
ffffffffc0200ca8:	47460613          	addi	a2,a2,1140 # ffffffffc0202118 <commands+0x508>
ffffffffc0200cac:	0e400593          	li	a1,228
ffffffffc0200cb0:	00001517          	auipc	a0,0x1
ffffffffc0200cb4:	48050513          	addi	a0,a0,1152 # ffffffffc0202130 <commands+0x520>
ffffffffc0200cb8:	ef4ff0ef          	jal	ra,ffffffffc02003ac <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
ffffffffc0200cbc:	00001697          	auipc	a3,0x1
ffffffffc0200cc0:	5b468693          	addi	a3,a3,1460 # ffffffffc0202270 <commands+0x660>
ffffffffc0200cc4:	00001617          	auipc	a2,0x1
ffffffffc0200cc8:	45460613          	addi	a2,a2,1108 # ffffffffc0202118 <commands+0x508>
ffffffffc0200ccc:	0db00593          	li	a1,219
ffffffffc0200cd0:	00001517          	auipc	a0,0x1
ffffffffc0200cd4:	46050513          	addi	a0,a0,1120 # ffffffffc0202130 <commands+0x520>
ffffffffc0200cd8:	ed4ff0ef          	jal	ra,ffffffffc02003ac <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
ffffffffc0200cdc:	00001697          	auipc	a3,0x1
ffffffffc0200ce0:	57468693          	addi	a3,a3,1396 # ffffffffc0202250 <commands+0x640>
ffffffffc0200ce4:	00001617          	auipc	a2,0x1
ffffffffc0200ce8:	43460613          	addi	a2,a2,1076 # ffffffffc0202118 <commands+0x508>
ffffffffc0200cec:	0da00593          	li	a1,218
ffffffffc0200cf0:	00001517          	auipc	a0,0x1
ffffffffc0200cf4:	44050513          	addi	a0,a0,1088 # ffffffffc0202130 <commands+0x520>
ffffffffc0200cf8:	eb4ff0ef          	jal	ra,ffffffffc02003ac <__panic>
    assert(count == 0);
ffffffffc0200cfc:	00001697          	auipc	a3,0x1
ffffffffc0200d00:	6dc68693          	addi	a3,a3,1756 # ffffffffc02023d8 <commands+0x7c8>
ffffffffc0200d04:	00001617          	auipc	a2,0x1
ffffffffc0200d08:	41460613          	addi	a2,a2,1044 # ffffffffc0202118 <commands+0x508>
ffffffffc0200d0c:	14b00593          	li	a1,331
ffffffffc0200d10:	00001517          	auipc	a0,0x1
ffffffffc0200d14:	42050513          	addi	a0,a0,1056 # ffffffffc0202130 <commands+0x520>
ffffffffc0200d18:	e94ff0ef          	jal	ra,ffffffffc02003ac <__panic>
    assert(nr_free == 0);
ffffffffc0200d1c:	00001697          	auipc	a3,0x1
ffffffffc0200d20:	5d468693          	addi	a3,a3,1492 # ffffffffc02022f0 <commands+0x6e0>
ffffffffc0200d24:	00001617          	auipc	a2,0x1
ffffffffc0200d28:	3f460613          	addi	a2,a2,1012 # ffffffffc0202118 <commands+0x508>
ffffffffc0200d2c:	14000593          	li	a1,320
ffffffffc0200d30:	00001517          	auipc	a0,0x1
ffffffffc0200d34:	40050513          	addi	a0,a0,1024 # ffffffffc0202130 <commands+0x520>
ffffffffc0200d38:	e74ff0ef          	jal	ra,ffffffffc02003ac <__panic>
    assert(alloc_page() == NULL);
ffffffffc0200d3c:	00001697          	auipc	a3,0x1
ffffffffc0200d40:	55468693          	addi	a3,a3,1364 # ffffffffc0202290 <commands+0x680>
ffffffffc0200d44:	00001617          	auipc	a2,0x1
ffffffffc0200d48:	3d460613          	addi	a2,a2,980 # ffffffffc0202118 <commands+0x508>
ffffffffc0200d4c:	13a00593          	li	a1,314
ffffffffc0200d50:	00001517          	auipc	a0,0x1
ffffffffc0200d54:	3e050513          	addi	a0,a0,992 # ffffffffc0202130 <commands+0x520>
ffffffffc0200d58:	e54ff0ef          	jal	ra,ffffffffc02003ac <__panic>
    assert((p0 = alloc_pages(5)) != NULL);
ffffffffc0200d5c:	00001697          	auipc	a3,0x1
ffffffffc0200d60:	65c68693          	addi	a3,a3,1628 # ffffffffc02023b8 <commands+0x7a8>
ffffffffc0200d64:	00001617          	auipc	a2,0x1
ffffffffc0200d68:	3b460613          	addi	a2,a2,948 # ffffffffc0202118 <commands+0x508>
ffffffffc0200d6c:	13900593          	li	a1,313
ffffffffc0200d70:	00001517          	auipc	a0,0x1
ffffffffc0200d74:	3c050513          	addi	a0,a0,960 # ffffffffc0202130 <commands+0x520>
ffffffffc0200d78:	e34ff0ef          	jal	ra,ffffffffc02003ac <__panic>
    assert(p0 + 4 == p1);
ffffffffc0200d7c:	00001697          	auipc	a3,0x1
ffffffffc0200d80:	62c68693          	addi	a3,a3,1580 # ffffffffc02023a8 <commands+0x798>
ffffffffc0200d84:	00001617          	auipc	a2,0x1
ffffffffc0200d88:	39460613          	addi	a2,a2,916 # ffffffffc0202118 <commands+0x508>
ffffffffc0200d8c:	13100593          	li	a1,305
ffffffffc0200d90:	00001517          	auipc	a0,0x1
ffffffffc0200d94:	3a050513          	addi	a0,a0,928 # ffffffffc0202130 <commands+0x520>
ffffffffc0200d98:	e14ff0ef          	jal	ra,ffffffffc02003ac <__panic>
    assert(alloc_pages(2) != NULL);      // best fit feature
ffffffffc0200d9c:	00001697          	auipc	a3,0x1
ffffffffc0200da0:	5f468693          	addi	a3,a3,1524 # ffffffffc0202390 <commands+0x780>
ffffffffc0200da4:	00001617          	auipc	a2,0x1
ffffffffc0200da8:	37460613          	addi	a2,a2,884 # ffffffffc0202118 <commands+0x508>
ffffffffc0200dac:	13000593          	li	a1,304
ffffffffc0200db0:	00001517          	auipc	a0,0x1
ffffffffc0200db4:	38050513          	addi	a0,a0,896 # ffffffffc0202130 <commands+0x520>
ffffffffc0200db8:	df4ff0ef          	jal	ra,ffffffffc02003ac <__panic>
    assert((p1 = alloc_pages(1)) != NULL);
ffffffffc0200dbc:	00001697          	auipc	a3,0x1
ffffffffc0200dc0:	5b468693          	addi	a3,a3,1460 # ffffffffc0202370 <commands+0x760>
ffffffffc0200dc4:	00001617          	auipc	a2,0x1
ffffffffc0200dc8:	35460613          	addi	a2,a2,852 # ffffffffc0202118 <commands+0x508>
ffffffffc0200dcc:	12f00593          	li	a1,303
ffffffffc0200dd0:	00001517          	auipc	a0,0x1
ffffffffc0200dd4:	36050513          	addi	a0,a0,864 # ffffffffc0202130 <commands+0x520>
ffffffffc0200dd8:	dd4ff0ef          	jal	ra,ffffffffc02003ac <__panic>
    assert(PageProperty(p0 + 1) && p0[1].property == 2);
ffffffffc0200ddc:	00001697          	auipc	a3,0x1
ffffffffc0200de0:	56468693          	addi	a3,a3,1380 # ffffffffc0202340 <commands+0x730>
ffffffffc0200de4:	00001617          	auipc	a2,0x1
ffffffffc0200de8:	33460613          	addi	a2,a2,820 # ffffffffc0202118 <commands+0x508>
ffffffffc0200dec:	12d00593          	li	a1,301
ffffffffc0200df0:	00001517          	auipc	a0,0x1
ffffffffc0200df4:	34050513          	addi	a0,a0,832 # ffffffffc0202130 <commands+0x520>
ffffffffc0200df8:	db4ff0ef          	jal	ra,ffffffffc02003ac <__panic>
    assert(alloc_pages(4) == NULL);
ffffffffc0200dfc:	00001697          	auipc	a3,0x1
ffffffffc0200e00:	52c68693          	addi	a3,a3,1324 # ffffffffc0202328 <commands+0x718>
ffffffffc0200e04:	00001617          	auipc	a2,0x1
ffffffffc0200e08:	31460613          	addi	a2,a2,788 # ffffffffc0202118 <commands+0x508>
ffffffffc0200e0c:	12c00593          	li	a1,300
ffffffffc0200e10:	00001517          	auipc	a0,0x1
ffffffffc0200e14:	32050513          	addi	a0,a0,800 # ffffffffc0202130 <commands+0x520>
ffffffffc0200e18:	d94ff0ef          	jal	ra,ffffffffc02003ac <__panic>
    assert(alloc_page() == NULL);
ffffffffc0200e1c:	00001697          	auipc	a3,0x1
ffffffffc0200e20:	47468693          	addi	a3,a3,1140 # ffffffffc0202290 <commands+0x680>
ffffffffc0200e24:	00001617          	auipc	a2,0x1
ffffffffc0200e28:	2f460613          	addi	a2,a2,756 # ffffffffc0202118 <commands+0x508>
ffffffffc0200e2c:	12000593          	li	a1,288
ffffffffc0200e30:	00001517          	auipc	a0,0x1
ffffffffc0200e34:	30050513          	addi	a0,a0,768 # ffffffffc0202130 <commands+0x520>
ffffffffc0200e38:	d74ff0ef          	jal	ra,ffffffffc02003ac <__panic>
    assert(!PageProperty(p0));
ffffffffc0200e3c:	00001697          	auipc	a3,0x1
ffffffffc0200e40:	4d468693          	addi	a3,a3,1236 # ffffffffc0202310 <commands+0x700>
ffffffffc0200e44:	00001617          	auipc	a2,0x1
ffffffffc0200e48:	2d460613          	addi	a2,a2,724 # ffffffffc0202118 <commands+0x508>
ffffffffc0200e4c:	11700593          	li	a1,279
ffffffffc0200e50:	00001517          	auipc	a0,0x1
ffffffffc0200e54:	2e050513          	addi	a0,a0,736 # ffffffffc0202130 <commands+0x520>
ffffffffc0200e58:	d54ff0ef          	jal	ra,ffffffffc02003ac <__panic>
    assert(p0 != NULL);
ffffffffc0200e5c:	00001697          	auipc	a3,0x1
ffffffffc0200e60:	4a468693          	addi	a3,a3,1188 # ffffffffc0202300 <commands+0x6f0>
ffffffffc0200e64:	00001617          	auipc	a2,0x1
ffffffffc0200e68:	2b460613          	addi	a2,a2,692 # ffffffffc0202118 <commands+0x508>
ffffffffc0200e6c:	11600593          	li	a1,278
ffffffffc0200e70:	00001517          	auipc	a0,0x1
ffffffffc0200e74:	2c050513          	addi	a0,a0,704 # ffffffffc0202130 <commands+0x520>
ffffffffc0200e78:	d34ff0ef          	jal	ra,ffffffffc02003ac <__panic>
    assert(nr_free == 0);
ffffffffc0200e7c:	00001697          	auipc	a3,0x1
ffffffffc0200e80:	47468693          	addi	a3,a3,1140 # ffffffffc02022f0 <commands+0x6e0>
ffffffffc0200e84:	00001617          	auipc	a2,0x1
ffffffffc0200e88:	29460613          	addi	a2,a2,660 # ffffffffc0202118 <commands+0x508>
ffffffffc0200e8c:	0f800593          	li	a1,248
ffffffffc0200e90:	00001517          	auipc	a0,0x1
ffffffffc0200e94:	2a050513          	addi	a0,a0,672 # ffffffffc0202130 <commands+0x520>
ffffffffc0200e98:	d14ff0ef          	jal	ra,ffffffffc02003ac <__panic>
    assert(alloc_page() == NULL);
ffffffffc0200e9c:	00001697          	auipc	a3,0x1
ffffffffc0200ea0:	3f468693          	addi	a3,a3,1012 # ffffffffc0202290 <commands+0x680>
ffffffffc0200ea4:	00001617          	auipc	a2,0x1
ffffffffc0200ea8:	27460613          	addi	a2,a2,628 # ffffffffc0202118 <commands+0x508>
ffffffffc0200eac:	0f600593          	li	a1,246
ffffffffc0200eb0:	00001517          	auipc	a0,0x1
ffffffffc0200eb4:	28050513          	addi	a0,a0,640 # ffffffffc0202130 <commands+0x520>
ffffffffc0200eb8:	cf4ff0ef          	jal	ra,ffffffffc02003ac <__panic>
    assert((p = alloc_page()) == p0);
ffffffffc0200ebc:	00001697          	auipc	a3,0x1
ffffffffc0200ec0:	41468693          	addi	a3,a3,1044 # ffffffffc02022d0 <commands+0x6c0>
ffffffffc0200ec4:	00001617          	auipc	a2,0x1
ffffffffc0200ec8:	25460613          	addi	a2,a2,596 # ffffffffc0202118 <commands+0x508>
ffffffffc0200ecc:	0f500593          	li	a1,245
ffffffffc0200ed0:	00001517          	auipc	a0,0x1
ffffffffc0200ed4:	26050513          	addi	a0,a0,608 # ffffffffc0202130 <commands+0x520>
ffffffffc0200ed8:	cd4ff0ef          	jal	ra,ffffffffc02003ac <__panic>

ffffffffc0200edc <best_fit_free_pages>:
best_fit_free_pages(struct Page *base, size_t n) {
ffffffffc0200edc:	1141                	addi	sp,sp,-16
ffffffffc0200ede:	e406                	sd	ra,8(sp)
    assert(n > 0);
ffffffffc0200ee0:	14058a63          	beqz	a1,ffffffffc0201034 <best_fit_free_pages+0x158>
    for (; p != base + n; p ++) {
ffffffffc0200ee4:	00259693          	slli	a3,a1,0x2
ffffffffc0200ee8:	96ae                	add	a3,a3,a1
ffffffffc0200eea:	068e                	slli	a3,a3,0x3
ffffffffc0200eec:	96aa                	add	a3,a3,a0
ffffffffc0200eee:	87aa                	mv	a5,a0
ffffffffc0200ef0:	02d50263          	beq	a0,a3,ffffffffc0200f14 <best_fit_free_pages+0x38>
ffffffffc0200ef4:	6798                	ld	a4,8(a5)
        assert(!PageReserved(p) && !PageProperty(p));
ffffffffc0200ef6:	8b05                	andi	a4,a4,1
ffffffffc0200ef8:	10071e63          	bnez	a4,ffffffffc0201014 <best_fit_free_pages+0x138>
ffffffffc0200efc:	6798                	ld	a4,8(a5)
ffffffffc0200efe:	8b09                	andi	a4,a4,2
ffffffffc0200f00:	10071a63          	bnez	a4,ffffffffc0201014 <best_fit_free_pages+0x138>
        p->flags = 0;
ffffffffc0200f04:	0007b423          	sd	zero,8(a5)
//将page指针转化为物理地址


static inline int page_ref(struct Page *page) { return page->ref; }
//返回页面的引用计数
static inline void set_page_ref(struct Page *page, int val) { page->ref = val; }
ffffffffc0200f08:	0007a023          	sw	zero,0(a5)
    for (; p != base + n; p ++) {
ffffffffc0200f0c:	02878793          	addi	a5,a5,40
ffffffffc0200f10:	fed792e3          	bne	a5,a3,ffffffffc0200ef4 <best_fit_free_pages+0x18>
    base->property = n;
ffffffffc0200f14:	2581                	sext.w	a1,a1
ffffffffc0200f16:	c90c                	sw	a1,16(a0)
    SetPageProperty(base);
ffffffffc0200f18:	00850893          	addi	a7,a0,8
    __op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc0200f1c:	4789                	li	a5,2
ffffffffc0200f1e:	40f8b02f          	amoor.d	zero,a5,(a7)
    nr_free += n;
ffffffffc0200f22:	00005697          	auipc	a3,0x5
ffffffffc0200f26:	0ee68693          	addi	a3,a3,238 # ffffffffc0206010 <free_area>
ffffffffc0200f2a:	4a98                	lw	a4,16(a3)
    return list->next == list;
ffffffffc0200f2c:	669c                	ld	a5,8(a3)
        list_add(&free_list, &(base->page_link));
ffffffffc0200f2e:	01850613          	addi	a2,a0,24
    nr_free += n;
ffffffffc0200f32:	9db9                	addw	a1,a1,a4
ffffffffc0200f34:	ca8c                	sw	a1,16(a3)
    if (list_empty(&free_list)) {
ffffffffc0200f36:	0ad78863          	beq	a5,a3,ffffffffc0200fe6 <best_fit_free_pages+0x10a>
            struct Page* page = le2page(le, page_link);
ffffffffc0200f3a:	fe878713          	addi	a4,a5,-24
ffffffffc0200f3e:	0006b803          	ld	a6,0(a3)
    if (list_empty(&free_list)) {
ffffffffc0200f42:	4581                	li	a1,0
            if (base < page) {
ffffffffc0200f44:	00e56a63          	bltu	a0,a4,ffffffffc0200f58 <best_fit_free_pages+0x7c>
    return listelm->next;
ffffffffc0200f48:	6798                	ld	a4,8(a5)
            } else if (list_next(le) == &free_list) {
ffffffffc0200f4a:	06d70263          	beq	a4,a3,ffffffffc0200fae <best_fit_free_pages+0xd2>
    for (; p != base + n; p ++) {
ffffffffc0200f4e:	87ba                	mv	a5,a4
            struct Page* page = le2page(le, page_link);
ffffffffc0200f50:	fe878713          	addi	a4,a5,-24
            if (base < page) {
ffffffffc0200f54:	fee57ae3          	bgeu	a0,a4,ffffffffc0200f48 <best_fit_free_pages+0x6c>
ffffffffc0200f58:	c199                	beqz	a1,ffffffffc0200f5e <best_fit_free_pages+0x82>
ffffffffc0200f5a:	0106b023          	sd	a6,0(a3)
    __list_add(elm, listelm->prev, listelm);
ffffffffc0200f5e:	6398                	ld	a4,0(a5)
=======
ffffffffc0200876:	649c                	ld	a5,8(s1)
ffffffffc0200878:	842a                	mv	s0,a0
    //free_pages(p1, 2);
    //assert(p1 == p0 + 2);
    assert(!PageReserved(p0) && !PageProperty(p0));
ffffffffc020087a:	8b85                	andi	a5,a5,1
ffffffffc020087c:	0e079463          	bnez	a5,ffffffffc0200964 <buddy_system_check+0x146>
ffffffffc0200880:	649c                	ld	a5,8(s1)
ffffffffc0200882:	8385                	srli	a5,a5,0x1
ffffffffc0200884:	8b85                	andi	a5,a5,1
ffffffffc0200886:	0c079f63          	bnez	a5,ffffffffc0200964 <buddy_system_check+0x146>
ffffffffc020088a:	651c                	ld	a5,8(a0)
    assert(!PageReserved(p1) && !PageProperty(p1));
ffffffffc020088c:	8b85                	andi	a5,a5,1
ffffffffc020088e:	ebdd                	bnez	a5,ffffffffc0200944 <buddy_system_check+0x126>
ffffffffc0200890:	651c                	ld	a5,8(a0)
ffffffffc0200892:	8385                	srli	a5,a5,0x1
ffffffffc0200894:	8b85                	andi	a5,a5,1
ffffffffc0200896:	e7dd                	bnez	a5,ffffffffc0200944 <buddy_system_check+0x126>
    // 再分配两个组页
    p2 = alloc_pages(1);
ffffffffc0200898:	4505                	li	a0,1
ffffffffc020089a:	0b7000ef          	jal	ra,ffffffffc0201150 <alloc_pages>
ffffffffc020089e:	89aa                	mv	s3,a0
    //assert(p2 == p0 + 1);
    p3 = alloc_pages(8);
ffffffffc02008a0:	4521                	li	a0,8
ffffffffc02008a2:	0af000ef          	jal	ra,ffffffffc0201150 <alloc_pages>
ffffffffc02008a6:	651c                	ld	a5,8(a0)
ffffffffc02008a8:	892a                	mv	s2,a0
ffffffffc02008aa:	8385                	srli	a5,a5,0x1
    //assert(p3 == p0 + 8);
    assert(!PageProperty(p3) && !PageProperty(p3 + 7) && PageProperty(p3 + 8));
ffffffffc02008ac:	8b85                	andi	a5,a5,1
ffffffffc02008ae:	ebbd                	bnez	a5,ffffffffc0200924 <buddy_system_check+0x106>
ffffffffc02008b0:	12053783          	ld	a5,288(a0)
ffffffffc02008b4:	8385                	srli	a5,a5,0x1
ffffffffc02008b6:	8b85                	andi	a5,a5,1
ffffffffc02008b8:	e7b5                	bnez	a5,ffffffffc0200924 <buddy_system_check+0x106>
ffffffffc02008ba:	14853783          	ld	a5,328(a0)
ffffffffc02008be:	8385                	srli	a5,a5,0x1
ffffffffc02008c0:	8b85                	andi	a5,a5,1
ffffffffc02008c2:	c3ad                	beqz	a5,ffffffffc0200924 <buddy_system_check+0x106>
    // 回收页
    free_pages(p1, 2);
ffffffffc02008c4:	4589                	li	a1,2
ffffffffc02008c6:	8522                	mv	a0,s0
ffffffffc02008c8:	0c7000ef          	jal	ra,ffffffffc020118e <free_pages>
ffffffffc02008cc:	641c                	ld	a5,8(s0)
ffffffffc02008ce:	8385                	srli	a5,a5,0x1
    assert(PageProperty(p1));
ffffffffc02008d0:	8b85                	andi	a5,a5,1
ffffffffc02008d2:	0e078963          	beqz	a5,ffffffffc02009c4 <buddy_system_check+0x1a6>
    assert(p1->ref == 0);
ffffffffc02008d6:	401c                	lw	a5,0(s0)
ffffffffc02008d8:	14079663          	bnez	a5,ffffffffc0200a24 <buddy_system_check+0x206>
    free_pages(p0, 1);
ffffffffc02008dc:	4585                	li	a1,1
ffffffffc02008de:	8526                	mv	a0,s1
ffffffffc02008e0:	0af000ef          	jal	ra,ffffffffc020118e <free_pages>
    free_pages(p2, 1);
ffffffffc02008e4:	4585                	li	a1,1
ffffffffc02008e6:	854e                	mv	a0,s3
ffffffffc02008e8:	0a7000ef          	jal	ra,ffffffffc020118e <free_pages>
    // 回收后再分配
    p2 = alloc_pages(3);
ffffffffc02008ec:	450d                	li	a0,3
ffffffffc02008ee:	063000ef          	jal	ra,ffffffffc0201150 <alloc_pages>
    //assert(p2 == p0);
    free_pages(p2, 3);
ffffffffc02008f2:	458d                	li	a1,3
    p2 = alloc_pages(3);
ffffffffc02008f4:	842a                	mv	s0,a0
    free_pages(p2, 3);
ffffffffc02008f6:	099000ef          	jal	ra,ffffffffc020118e <free_pages>
    assert((p2 + 2)->ref == 0);
ffffffffc02008fa:	483c                	lw	a5,80(s0)
ffffffffc02008fc:	10079463          	bnez	a5,ffffffffc0200a04 <buddy_system_check+0x1e6>
    //assert(nr_free_pages() == all_pages >> 1);
    p1 = alloc_pages(129);
ffffffffc0200900:	08100513          	li	a0,129
ffffffffc0200904:	04d000ef          	jal	ra,ffffffffc0201150 <alloc_pages>
    //(p1 == p0 + 256);
    free_pages(p1, 256);
ffffffffc0200908:	10000593          	li	a1,256
ffffffffc020090c:	083000ef          	jal	ra,ffffffffc020118e <free_pages>
    free_pages(p3, 8);
}
ffffffffc0200910:	7402                	ld	s0,32(sp)
ffffffffc0200912:	70a2                	ld	ra,40(sp)
ffffffffc0200914:	64e2                	ld	s1,24(sp)
ffffffffc0200916:	69a2                	ld	s3,8(sp)
    free_pages(p3, 8);
ffffffffc0200918:	854a                	mv	a0,s2
}
ffffffffc020091a:	6942                	ld	s2,16(sp)
    free_pages(p3, 8);
ffffffffc020091c:	45a1                	li	a1,8
}
ffffffffc020091e:	6145                	addi	sp,sp,48
    free_pages(p3, 8);
ffffffffc0200920:	06f0006f          	j	ffffffffc020118e <free_pages>
    assert(!PageProperty(p3) && !PageProperty(p3 + 7) && PageProperty(p3 + 8));
ffffffffc0200924:	00002697          	auipc	a3,0x2
ffffffffc0200928:	81c68693          	addi	a3,a3,-2020 # ffffffffc0202140 <commands+0x5c0>
ffffffffc020092c:	00001617          	auipc	a2,0x1
ffffffffc0200930:	75460613          	addi	a2,a2,1876 # ffffffffc0202080 <commands+0x500>
ffffffffc0200934:	1bb00593          	li	a1,443
ffffffffc0200938:	00001517          	auipc	a0,0x1
ffffffffc020093c:	76050513          	addi	a0,a0,1888 # ffffffffc0202098 <commands+0x518>
ffffffffc0200940:	ffaff0ef          	jal	ra,ffffffffc020013a <__panic>
    assert(!PageReserved(p1) && !PageProperty(p1));
ffffffffc0200944:	00001697          	auipc	a3,0x1
ffffffffc0200948:	7d468693          	addi	a3,a3,2004 # ffffffffc0202118 <commands+0x598>
ffffffffc020094c:	00001617          	auipc	a2,0x1
ffffffffc0200950:	73460613          	addi	a2,a2,1844 # ffffffffc0202080 <commands+0x500>
ffffffffc0200954:	1b500593          	li	a1,437
ffffffffc0200958:	00001517          	auipc	a0,0x1
ffffffffc020095c:	74050513          	addi	a0,a0,1856 # ffffffffc0202098 <commands+0x518>
ffffffffc0200960:	fdaff0ef          	jal	ra,ffffffffc020013a <__panic>
    assert(!PageReserved(p0) && !PageProperty(p0));
ffffffffc0200964:	00001697          	auipc	a3,0x1
ffffffffc0200968:	78c68693          	addi	a3,a3,1932 # ffffffffc02020f0 <commands+0x570>
ffffffffc020096c:	00001617          	auipc	a2,0x1
ffffffffc0200970:	71460613          	addi	a2,a2,1812 # ffffffffc0202080 <commands+0x500>
ffffffffc0200974:	1b400593          	li	a1,436
ffffffffc0200978:	00001517          	auipc	a0,0x1
ffffffffc020097c:	72050513          	addi	a0,a0,1824 # ffffffffc0202098 <commands+0x518>
ffffffffc0200980:	fbaff0ef          	jal	ra,ffffffffc020013a <__panic>
    assert(p0 != NULL);
ffffffffc0200984:	00001697          	auipc	a3,0x1
ffffffffc0200988:	73468693          	addi	a3,a3,1844 # ffffffffc02020b8 <commands+0x538>
ffffffffc020098c:	00001617          	auipc	a2,0x1
ffffffffc0200990:	6f460613          	addi	a2,a2,1780 # ffffffffc0202080 <commands+0x500>
ffffffffc0200994:	1ab00593          	li	a1,427
ffffffffc0200998:	00001517          	auipc	a0,0x1
ffffffffc020099c:	70050513          	addi	a0,a0,1792 # ffffffffc0202098 <commands+0x518>
ffffffffc02009a0:	f9aff0ef          	jal	ra,ffffffffc020013a <__panic>
    assert(p1 != NULL);
ffffffffc02009a4:	00001697          	auipc	a3,0x1
ffffffffc02009a8:	72468693          	addi	a3,a3,1828 # ffffffffc02020c8 <commands+0x548>
ffffffffc02009ac:	00001617          	auipc	a2,0x1
ffffffffc02009b0:	6d460613          	addi	a2,a2,1748 # ffffffffc0202080 <commands+0x500>
ffffffffc02009b4:	1ad00593          	li	a1,429
ffffffffc02009b8:	00001517          	auipc	a0,0x1
ffffffffc02009bc:	6e050513          	addi	a0,a0,1760 # ffffffffc0202098 <commands+0x518>
ffffffffc02009c0:	f7aff0ef          	jal	ra,ffffffffc020013a <__panic>
    assert(PageProperty(p1));
ffffffffc02009c4:	00001697          	auipc	a3,0x1
ffffffffc02009c8:	7c468693          	addi	a3,a3,1988 # ffffffffc0202188 <commands+0x608>
ffffffffc02009cc:	00001617          	auipc	a2,0x1
ffffffffc02009d0:	6b460613          	addi	a2,a2,1716 # ffffffffc0202080 <commands+0x500>
ffffffffc02009d4:	1be00593          	li	a1,446
ffffffffc02009d8:	00001517          	auipc	a0,0x1
ffffffffc02009dc:	6c050513          	addi	a0,a0,1728 # ffffffffc0202098 <commands+0x518>
ffffffffc02009e0:	f5aff0ef          	jal	ra,ffffffffc020013a <__panic>
    assert(alloc_pages(all_pages + 1) == NULL);
ffffffffc02009e4:	00001697          	auipc	a3,0x1
ffffffffc02009e8:	67468693          	addi	a3,a3,1652 # ffffffffc0202058 <commands+0x4d8>
ffffffffc02009ec:	00001617          	auipc	a2,0x1
ffffffffc02009f0:	69460613          	addi	a2,a2,1684 # ffffffffc0202080 <commands+0x500>
ffffffffc02009f4:	1a300593          	li	a1,419
ffffffffc02009f8:	00001517          	auipc	a0,0x1
ffffffffc02009fc:	6a050513          	addi	a0,a0,1696 # ffffffffc0202098 <commands+0x518>
ffffffffc0200a00:	f3aff0ef          	jal	ra,ffffffffc020013a <__panic>
    assert((p2 + 2)->ref == 0);
ffffffffc0200a04:	00001697          	auipc	a3,0x1
ffffffffc0200a08:	7ac68693          	addi	a3,a3,1964 # ffffffffc02021b0 <commands+0x630>
ffffffffc0200a0c:	00001617          	auipc	a2,0x1
ffffffffc0200a10:	67460613          	addi	a2,a2,1652 # ffffffffc0202080 <commands+0x500>
ffffffffc0200a14:	1c600593          	li	a1,454
ffffffffc0200a18:	00001517          	auipc	a0,0x1
ffffffffc0200a1c:	68050513          	addi	a0,a0,1664 # ffffffffc0202098 <commands+0x518>
ffffffffc0200a20:	f1aff0ef          	jal	ra,ffffffffc020013a <__panic>
    assert(p1->ref == 0);
ffffffffc0200a24:	00001697          	auipc	a3,0x1
ffffffffc0200a28:	77c68693          	addi	a3,a3,1916 # ffffffffc02021a0 <commands+0x620>
ffffffffc0200a2c:	00001617          	auipc	a2,0x1
ffffffffc0200a30:	65460613          	addi	a2,a2,1620 # ffffffffc0202080 <commands+0x500>
ffffffffc0200a34:	1bf00593          	li	a1,447
ffffffffc0200a38:	00001517          	auipc	a0,0x1
ffffffffc0200a3c:	66050513          	addi	a0,a0,1632 # ffffffffc0202098 <commands+0x518>
ffffffffc0200a40:	efaff0ef          	jal	ra,ffffffffc020013a <__panic>
    assert(p1 == propertypages);
ffffffffc0200a44:	00001697          	auipc	a3,0x1
ffffffffc0200a48:	69468693          	addi	a3,a3,1684 # ffffffffc02020d8 <commands+0x558>
ffffffffc0200a4c:	00001617          	auipc	a2,0x1
ffffffffc0200a50:	63460613          	addi	a2,a2,1588 # ffffffffc0202080 <commands+0x500>
ffffffffc0200a54:	1ae00593          	li	a1,430
ffffffffc0200a58:	00001517          	auipc	a0,0x1
ffffffffc0200a5c:	64050513          	addi	a0,a0,1600 # ffffffffc0202098 <commands+0x518>
ffffffffc0200a60:	edaff0ef          	jal	ra,ffffffffc020013a <__panic>

ffffffffc0200a64 <memtree_init>:
    tree = (struct memtree*)(ROUNDUP((void*)pages + sizeof(struct Page) * (npage - nbase),32));//在Page数组的后面，32字节对齐
ffffffffc0200a64:	00002e97          	auipc	t4,0x2
ffffffffc0200a68:	c24ebe83          	ld	t4,-988(t4) # ffffffffc0202688 <nbase>
ffffffffc0200a6c:	00006797          	auipc	a5,0x6
ffffffffc0200a70:	9e47b783          	ld	a5,-1564(a5) # ffffffffc0206450 <npage>
ffffffffc0200a74:	41d787b3          	sub	a5,a5,t4
ffffffffc0200a78:	00279e93          	slli	t4,a5,0x2
ffffffffc0200a7c:	9ebe                	add	t4,t4,a5
ffffffffc0200a7e:	003e9793          	slli	a5,t4,0x3
ffffffffc0200a82:	00006e97          	auipc	t4,0x6
ffffffffc0200a86:	9d6ebe83          	ld	t4,-1578(t4) # ffffffffc0206458 <pages>
ffffffffc0200a8a:	9ebe                	add	t4,t4,a5
ffffffffc0200a8c:	0efd                	addi	t4,t4,31
    while(np>size)
ffffffffc0200a8e:	4785                	li	a5,1
ffffffffc0200a90:	fe0efe93          	andi	t4,t4,-32
ffffffffc0200a94:	16b7d363          	bge	a5,a1,ffffffffc0200bfa <memtree_init+0x196>
    int size=1;
ffffffffc0200a98:	4885                	li	a7,1
		size=size<<1;	
ffffffffc0200a9a:	0018989b          	slliw	a7,a7,0x1
    while(np>size)
ffffffffc0200a9e:	feb8cee3          	blt	a7,a1,ffffffffc0200a9a <memtree_init+0x36>
    tree_size=2*size-1;
ffffffffc0200aa2:	0018961b          	slliw	a2,a7,0x1
ffffffffc0200aa6:	fff60f1b          	addiw	t5,a2,-1
    tree = (struct memtree*)(ROUNDUP((void*)pages + sizeof(struct Page) * (npage - nbase),32));//在Page数组的后面，32字节对齐
ffffffffc0200aaa:	00006317          	auipc	t1,0x6
ffffffffc0200aae:	99630313          	addi	t1,t1,-1642 # ffffffffc0206440 <tree>
    tree_size=2*size-1;
ffffffffc0200ab2:	00006717          	auipc	a4,0x6
ffffffffc0200ab6:	99e72b23          	sw	t5,-1642(a4) # ffffffffc0206448 <tree_size>
    tree = (struct memtree*)(ROUNDUP((void*)pages + sizeof(struct Page) * (npage - nbase),32));//在Page数组的后面，32字节对齐
ffffffffc0200aba:	01d33023          	sd	t4,0(t1)
    for(int i=tree_size - 1;i>=0;i--)//自下到上
ffffffffc0200abe:	3679                	addiw	a2,a2,-2
        if(i>=size-1)
ffffffffc0200ac0:	fff88f9b          	addiw	t6,a7,-1
ffffffffc0200ac4:	00461e13          	slli	t3,a2,0x4
            tree[i].avail=(i-size+1<np)?1:0;//叶子节点对应的是一个页，判断是不是属于可分配内存块
ffffffffc0200ac8:	4385                	li	t2,1
ffffffffc0200aca:	9e76                	add	t3,t3,t4
ffffffffc0200acc:	411383bb          	subw	t2,t2,a7
    for(int i=tree_size - 1;i>=0;i--)//自下到上
ffffffffc0200ad0:	52fd                	li	t0,-1
    if(pos>=tree_size)return NULL;
ffffffffc0200ad2:	11e65863          	bge	a2,t5,ffffffffc0200be2 <memtree_init+0x17e>
    while(pos >=floorpw*2 + 1)
ffffffffc0200ad6:	10060e63          	beqz	a2,ffffffffc0200bf2 <memtree_init+0x18e>
ffffffffc0200ada:	87c6                	mv	a5,a7
ffffffffc0200adc:	4681                	li	a3,0
        block_size/=2;
ffffffffc0200ade:	01f7d81b          	srliw	a6,a5,0x1f
        floorpw+=1;
ffffffffc0200ae2:	0016871b          	addiw	a4,a3,1
        block_size/=2;
ffffffffc0200ae6:	00f807bb          	addw	a5,a6,a5
    while(pos >=floorpw*2 + 1)
ffffffffc0200aea:	0017169b          	slliw	a3,a4,0x1
        block_size/=2;
ffffffffc0200aee:	4017d79b          	sraiw	a5,a5,0x1
    while(pos >=floorpw*2 + 1)
ffffffffc0200af2:	fec6c6e3          	blt	a3,a2,ffffffffc0200ade <memtree_init+0x7a>
    (struct Page*)(base + (pos-floorpw) * block_size);
ffffffffc0200af6:	40e6073b          	subw	a4,a2,a4
ffffffffc0200afa:	02f707bb          	mulw	a5,a4,a5
        tree[i].page=memmap(base,i);//初始化page
ffffffffc0200afe:	8846                	mv	a6,a7
ffffffffc0200b00:	4681                	li	a3,0
    (struct Page*)(base + (pos-floorpw) * block_size);
ffffffffc0200b02:	00279713          	slli	a4,a5,0x2
ffffffffc0200b06:	97ba                	add	a5,a5,a4
ffffffffc0200b08:	078e                	slli	a5,a5,0x3
    return (struct Page*)(base + (pos-floorpw) * block_size);
ffffffffc0200b0a:	97aa                	add	a5,a5,a0
        tree[i].page=memmap(base,i);//初始化page
ffffffffc0200b0c:	00fe3423          	sd	a5,8(t3)
        block_size/=2;
ffffffffc0200b10:	01f8579b          	srliw	a5,a6,0x1f
        floorpw+=1;
ffffffffc0200b14:	2685                	addiw	a3,a3,1
        block_size/=2;
ffffffffc0200b16:	010787bb          	addw	a5,a5,a6
    while(pos >=floorpw*2 + 1)
ffffffffc0200b1a:	0016969b          	slliw	a3,a3,0x1
        block_size/=2;
ffffffffc0200b1e:	4017d81b          	sraiw	a6,a5,0x1
    while(pos >=floorpw*2 + 1)
ffffffffc0200b22:	fec6c7e3          	blt	a3,a2,ffffffffc0200b10 <memtree_init+0xac>
        tree[i].size=getps(i);//初始化size
ffffffffc0200b26:	010e2223          	sw	a6,4(t3)
        if(i>=size-1)
ffffffffc0200b2a:	09f64a63          	blt	a2,t6,ffffffffc0200bbe <memtree_init+0x15a>
            tree[i].avail=(i-size+1<np)?1:0;//叶子节点对应的是一个页，判断是不是属于可分配内存块
ffffffffc0200b2e:	00c387bb          	addw	a5,t2,a2
ffffffffc0200b32:	00b7a7b3          	slt	a5,a5,a1
ffffffffc0200b36:	00fe2023          	sw	a5,0(t3)
    for(int i=tree_size - 1;i>=0;i--)//自下到上
ffffffffc0200b3a:	367d                	addiw	a2,a2,-1
ffffffffc0200b3c:	1e41                	addi	t3,t3,-16
ffffffffc0200b3e:	f8561ae3          	bne	a2,t0,ffffffffc0200ad2 <memtree_init+0x6e>
    if(np==size)//这意味着刚好页的数量是2的次方
ffffffffc0200b42:	0b158763          	beq	a1,a7,ffffffffc0200bf0 <memtree_init+0x18c>
    while(pos<np)//向左偏的
ffffffffc0200b46:	4785                	li	a5,1
ffffffffc0200b48:	0ab7d463          	bge	a5,a1,ffffffffc0200bf0 <memtree_init+0x18c>
    __op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc0200b4c:	4e89                	li	t4,2
        if(tree[pos].avail==tree[pos].size){//这个地方满了则分出来（都是左孩子），剩下的交由兄弟结点的子节点来里处理内存块链表
ffffffffc0200b4e:	00033703          	ld	a4,0(t1)
ffffffffc0200b52:	00479613          	slli	a2,a5,0x4
ffffffffc0200b56:	00c706b3          	add	a3,a4,a2
ffffffffc0200b5a:	0046a803          	lw	a6,4(a3)
ffffffffc0200b5e:	4288                	lw	a0,0(a3)
ffffffffc0200b60:	05051963          	bne	a0,a6,ffffffffc0200bb2 <memtree_init+0x14e>
            if(tree[pos].page->property==tree[pos].size)
ffffffffc0200b64:	0086b803          	ld	a6,8(a3)
ffffffffc0200b68:	00050e1b          	sext.w	t3,a0
ffffffffc0200b6c:	01082883          	lw	a7,16(a6)
ffffffffc0200b70:	08a88063          	beq	a7,a0,ffffffffc0200bf0 <memtree_init+0x18c>
            tree[pos+1].page->property=tree[pos].page->property-tree[pos].size;
ffffffffc0200b74:	0641                	addi	a2,a2,16
ffffffffc0200b76:	9732                	add	a4,a4,a2
ffffffffc0200b78:	6710                	ld	a2,8(a4)
ffffffffc0200b7a:	41c888bb          	subw	a7,a7,t3
ffffffffc0200b7e:	01162823          	sw	a7,16(a2)
            tree[pos].page->property=tree[pos].size;
ffffffffc0200b82:	01c82823          	sw	t3,16(a6)
ffffffffc0200b86:	00880613          	addi	a2,a6,8
ffffffffc0200b8a:	41d6302f          	amoor.d	zero,t4,(a2)
            list_add(&(tree[pos].page->page_link),&(tree[pos+1].page->page_link));
ffffffffc0200b8e:	6694                	ld	a3,8(a3)
ffffffffc0200b90:	6710                	ld	a2,8(a4)
            assert(tree[pos].avail<tree[pos].size);
ffffffffc0200b92:	00072883          	lw	a7,0(a4)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
ffffffffc0200b96:	7288                	ld	a0,32(a3)
            list_add(&(tree[pos].page->page_link),&(tree[pos+1].page->page_link));
ffffffffc0200b98:	01860813          	addi	a6,a2,24
            assert(tree[pos].avail<tree[pos].size);
ffffffffc0200b9c:	4358                	lw	a4,4(a4)
>>>>>>> origin/main
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
<<<<<<< HEAD
ffffffffc0200f60:	e390                	sd	a2,0(a5)
ffffffffc0200f62:	e710                	sd	a2,8(a4)
    elm->next = next;
ffffffffc0200f64:	f11c                	sd	a5,32(a0)
    elm->prev = prev;
ffffffffc0200f66:	ed18                	sd	a4,24(a0)
    if (le != &free_list) {
ffffffffc0200f68:	02d70063          	beq	a4,a3,ffffffffc0200f88 <best_fit_free_pages+0xac>
         if (p + p->property == base) {
ffffffffc0200f6c:	ff872803          	lw	a6,-8(a4)
        p = le2page(le, page_link);
ffffffffc0200f70:	fe870593          	addi	a1,a4,-24
         if (p + p->property == base) {
ffffffffc0200f74:	02081613          	slli	a2,a6,0x20
ffffffffc0200f78:	9201                	srli	a2,a2,0x20
ffffffffc0200f7a:	00261793          	slli	a5,a2,0x2
ffffffffc0200f7e:	97b2                	add	a5,a5,a2
ffffffffc0200f80:	078e                	slli	a5,a5,0x3
ffffffffc0200f82:	97ae                	add	a5,a5,a1
ffffffffc0200f84:	02f50f63          	beq	a0,a5,ffffffffc0200fc2 <best_fit_free_pages+0xe6>
    return listelm->next;
ffffffffc0200f88:	7118                	ld	a4,32(a0)
    if (le != &free_list) {
ffffffffc0200f8a:	00d70f63          	beq	a4,a3,ffffffffc0200fa8 <best_fit_free_pages+0xcc>
        if (base + base->property == p) {
ffffffffc0200f8e:	490c                	lw	a1,16(a0)
        p = le2page(le, page_link);
ffffffffc0200f90:	fe870693          	addi	a3,a4,-24
        if (base + base->property == p) {
ffffffffc0200f94:	02059613          	slli	a2,a1,0x20
ffffffffc0200f98:	9201                	srli	a2,a2,0x20
ffffffffc0200f9a:	00261793          	slli	a5,a2,0x2
ffffffffc0200f9e:	97b2                	add	a5,a5,a2
ffffffffc0200fa0:	078e                	slli	a5,a5,0x3
ffffffffc0200fa2:	97aa                	add	a5,a5,a0
ffffffffc0200fa4:	04f68863          	beq	a3,a5,ffffffffc0200ff4 <best_fit_free_pages+0x118>
}
ffffffffc0200fa8:	60a2                	ld	ra,8(sp)
ffffffffc0200faa:	0141                	addi	sp,sp,16
ffffffffc0200fac:	8082                	ret
    prev->next = next->prev = elm;
ffffffffc0200fae:	e790                	sd	a2,8(a5)
    elm->next = next;
ffffffffc0200fb0:	f114                	sd	a3,32(a0)
    return listelm->next;
ffffffffc0200fb2:	6798                	ld	a4,8(a5)
    elm->prev = prev;
ffffffffc0200fb4:	ed1c                	sd	a5,24(a0)
        while ((le = list_next(le)) != &free_list) {
ffffffffc0200fb6:	02d70563          	beq	a4,a3,ffffffffc0200fe0 <best_fit_free_pages+0x104>
    prev->next = next->prev = elm;
ffffffffc0200fba:	8832                	mv	a6,a2
ffffffffc0200fbc:	4585                	li	a1,1
    for (; p != base + n; p ++) {
ffffffffc0200fbe:	87ba                	mv	a5,a4
ffffffffc0200fc0:	bf41                	j	ffffffffc0200f50 <best_fit_free_pages+0x74>
            p->property += base->property;
ffffffffc0200fc2:	491c                	lw	a5,16(a0)
ffffffffc0200fc4:	0107883b          	addw	a6,a5,a6
ffffffffc0200fc8:	ff072c23          	sw	a6,-8(a4)
    __op_bit(and, __NOT, nr, ((volatile unsigned long *)addr));
ffffffffc0200fcc:	57f5                	li	a5,-3
ffffffffc0200fce:	60f8b02f          	amoand.d	zero,a5,(a7)
    __list_del(listelm->prev, listelm->next);
ffffffffc0200fd2:	6d10                	ld	a2,24(a0)
ffffffffc0200fd4:	711c                	ld	a5,32(a0)
            base = p;
ffffffffc0200fd6:	852e                	mv	a0,a1
=======
ffffffffc0200b9e:	01053023          	sd	a6,0(a0)
ffffffffc0200ba2:	0306b023          	sd	a6,32(a3)
            list_add(&(tree[pos].page->page_link),&(tree[pos+1].page->page_link));
ffffffffc0200ba6:	06e1                	addi	a3,a3,24
    elm->next = next;
ffffffffc0200ba8:	f208                	sd	a0,32(a2)
    elm->prev = prev;
ffffffffc0200baa:	ee14                	sd	a3,24(a2)
            pos+=1;//换到兄弟节点
ffffffffc0200bac:	2785                	addiw	a5,a5,1
            assert(tree[pos].avail<tree[pos].size);
ffffffffc0200bae:	06e8d563          	bge	a7,a4,ffffffffc0200c18 <memtree_init+0x1b4>
            pos=pos*2+1;//发现不满，给自己的左孩子
ffffffffc0200bb2:	0017979b          	slliw	a5,a5,0x1
ffffffffc0200bb6:	2785                	addiw	a5,a5,1
    while(pos<np)//向左偏的
ffffffffc0200bb8:	f8b7cbe3          	blt	a5,a1,ffffffffc0200b4e <memtree_init+0xea>
ffffffffc0200bbc:	8082                	ret
            if(tree[i*2+1].avail+tree[i*2+2].avail==tree[i].size)
ffffffffc0200bbe:	0016179b          	slliw	a5,a2,0x1
ffffffffc0200bc2:	0785                	addi	a5,a5,1
ffffffffc0200bc4:	0792                	slli	a5,a5,0x4
ffffffffc0200bc6:	97f6                	add	a5,a5,t4
ffffffffc0200bc8:	4398                	lw	a4,0(a5)
ffffffffc0200bca:	4b9c                	lw	a5,16(a5)
ffffffffc0200bcc:	00f706bb          	addw	a3,a4,a5
ffffffffc0200bd0:	01068d63          	beq	a3,a6,ffffffffc0200bea <memtree_init+0x186>
                tree[i].avail=(tree[i*2+1].avail>tree[i*2+2].avail) ?  tree[i*2+1].avail: tree[i*2+2].avail;
ffffffffc0200bd4:	86ba                	mv	a3,a4
ffffffffc0200bd6:	00f75363          	bge	a4,a5,ffffffffc0200bdc <memtree_init+0x178>
ffffffffc0200bda:	86be                	mv	a3,a5
ffffffffc0200bdc:	00de2023          	sw	a3,0(t3)
ffffffffc0200be0:	bfa9                	j	ffffffffc0200b3a <memtree_init+0xd6>
        tree[i].page=memmap(base,i);//初始化page
ffffffffc0200be2:	000e3423          	sd	zero,8(t3)
    if(pos>=tree_size)return 0;
ffffffffc0200be6:	4801                	li	a6,0
ffffffffc0200be8:	bf3d                	j	ffffffffc0200b26 <memtree_init+0xc2>
                tree[i].avail=tree[i].size;
ffffffffc0200bea:	010e2023          	sw	a6,0(t3)
ffffffffc0200bee:	b7b1                	j	ffffffffc0200b3a <memtree_init+0xd6>
ffffffffc0200bf0:	8082                	ret
        tree[i].page=memmap(base,i);//初始化page
ffffffffc0200bf2:	00ae3423          	sd	a0,8(t3)
ffffffffc0200bf6:	8846                	mv	a6,a7
ffffffffc0200bf8:	b73d                	j	ffffffffc0200b26 <memtree_init+0xc2>
    tree = (struct memtree*)(ROUNDUP((void*)pages + sizeof(struct Page) * (npage - nbase),32));//在Page数组的后面，32字节对齐
ffffffffc0200bfa:	00006317          	auipc	t1,0x6
ffffffffc0200bfe:	84630313          	addi	t1,t1,-1978 # ffffffffc0206440 <tree>
    tree_size=2*size-1;
ffffffffc0200c02:	00006717          	auipc	a4,0x6
ffffffffc0200c06:	84f72323          	sw	a5,-1978(a4) # ffffffffc0206448 <tree_size>
    tree = (struct memtree*)(ROUNDUP((void*)pages + sizeof(struct Page) * (npage - nbase),32));//在Page数组的后面，32字节对齐
ffffffffc0200c0a:	01d33023          	sd	t4,0(t1)
ffffffffc0200c0e:	4f81                	li	t6,0
    int size=1;
ffffffffc0200c10:	4885                	li	a7,1
    tree_size=2*size-1;
ffffffffc0200c12:	4f05                	li	t5,1
    for(int i=tree_size - 1;i>=0;i--)//自下到上
ffffffffc0200c14:	4601                	li	a2,0
ffffffffc0200c16:	b57d                	j	ffffffffc0200ac4 <memtree_init+0x60>
{
ffffffffc0200c18:	1141                	addi	sp,sp,-16
            assert(tree[pos].avail<tree[pos].size);
ffffffffc0200c1a:	00001697          	auipc	a3,0x1
ffffffffc0200c1e:	5ae68693          	addi	a3,a3,1454 # ffffffffc02021c8 <commands+0x648>
ffffffffc0200c22:	00001617          	auipc	a2,0x1
ffffffffc0200c26:	45e60613          	addi	a2,a2,1118 # ffffffffc0202080 <commands+0x500>
ffffffffc0200c2a:	09a00593          	li	a1,154
ffffffffc0200c2e:	00001517          	auipc	a0,0x1
ffffffffc0200c32:	46a50513          	addi	a0,a0,1130 # ffffffffc0202098 <commands+0x518>
{
ffffffffc0200c36:	e406                	sd	ra,8(sp)
            assert(tree[pos].avail<tree[pos].size);
ffffffffc0200c38:	d02ff0ef          	jal	ra,ffffffffc020013a <__panic>

ffffffffc0200c3c <buddy_system_init_memmap>:
buddy_system_init_memmap(struct Page *base, size_t n) {
ffffffffc0200c3c:	1141                	addi	sp,sp,-16
ffffffffc0200c3e:	e406                	sd	ra,8(sp)
    assert(n > 0);
ffffffffc0200c40:	cde9                	beqz	a1,ffffffffc0200d1a <buddy_system_init_memmap+0xde>
    for (; p != base + n; p ++) {
ffffffffc0200c42:	00259693          	slli	a3,a1,0x2
ffffffffc0200c46:	96ae                	add	a3,a3,a1
ffffffffc0200c48:	068e                	slli	a3,a3,0x3
    propertypages = base;
ffffffffc0200c4a:	00005797          	auipc	a5,0x5
ffffffffc0200c4e:	7ea7b723          	sd	a0,2030(a5) # ffffffffc0206438 <propertypages>
    for (; p != base + n; p ++) {
ffffffffc0200c52:	96aa                	add	a3,a3,a0
ffffffffc0200c54:	87aa                	mv	a5,a0
ffffffffc0200c56:	00d50f63          	beq	a0,a3,ffffffffc0200c74 <buddy_system_init_memmap+0x38>
    return (((*(volatile unsigned long *)addr) >> nr) & 1);
ffffffffc0200c5a:	6798                	ld	a4,8(a5)
        assert(PageReserved(p));
ffffffffc0200c5c:	8b05                	andi	a4,a4,1
ffffffffc0200c5e:	cf51                	beqz	a4,ffffffffc0200cfa <buddy_system_init_memmap+0xbe>
        p->flags = p->property = 0;
ffffffffc0200c60:	0007a823          	sw	zero,16(a5)
ffffffffc0200c64:	0007b423          	sd	zero,8(a5)



static inline int page_ref(struct Page *page) { return page->ref; }

static inline void set_page_ref(struct Page *page, int val) { page->ref = val; }
ffffffffc0200c68:	0007a023          	sw	zero,0(a5)
    for (; p != base + n; p ++) {
ffffffffc0200c6c:	02878793          	addi	a5,a5,40
ffffffffc0200c70:	fed795e3          	bne	a5,a3,ffffffffc0200c5a <buddy_system_init_memmap+0x1e>
    base->property = n;
ffffffffc0200c74:	2581                	sext.w	a1,a1
ffffffffc0200c76:	c90c                	sw	a1,16(a0)
    __op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc0200c78:	4789                	li	a5,2
ffffffffc0200c7a:	00850713          	addi	a4,a0,8
ffffffffc0200c7e:	40f7302f          	amoor.d	zero,a5,(a4)
    nr_free += n;
ffffffffc0200c82:	00005697          	auipc	a3,0x5
ffffffffc0200c86:	38e68693          	addi	a3,a3,910 # ffffffffc0206010 <bsfree_area>
ffffffffc0200c8a:	4a98                	lw	a4,16(a3)
    return list->next == list;
ffffffffc0200c8c:	669c                	ld	a5,8(a3)
        list_add(&free_list, &(base->page_link));
ffffffffc0200c8e:	01850613          	addi	a2,a0,24
    nr_free += n;
ffffffffc0200c92:	9f2d                	addw	a4,a4,a1
ffffffffc0200c94:	ca98                	sw	a4,16(a3)
    if (list_empty(&free_list)) {
ffffffffc0200c96:	04d78b63          	beq	a5,a3,ffffffffc0200cec <buddy_system_init_memmap+0xb0>
            struct Page* page = le2page(le, page_link);
ffffffffc0200c9a:	fe878713          	addi	a4,a5,-24
ffffffffc0200c9e:	0006b883          	ld	a7,0(a3)
    if (list_empty(&free_list)) {
ffffffffc0200ca2:	4801                	li	a6,0
            if (base < page) {
ffffffffc0200ca4:	00e56a63          	bltu	a0,a4,ffffffffc0200cb8 <buddy_system_init_memmap+0x7c>
    return listelm->next;
ffffffffc0200ca8:	6798                	ld	a4,8(a5)
            } else if (list_next(le) == &free_list) {
ffffffffc0200caa:	02d70363          	beq	a4,a3,ffffffffc0200cd0 <buddy_system_init_memmap+0x94>
    for (; p != base + n; p ++) {
ffffffffc0200cae:	87ba                	mv	a5,a4
            struct Page* page = le2page(le, page_link);
ffffffffc0200cb0:	fe878713          	addi	a4,a5,-24
            if (base < page) {
ffffffffc0200cb4:	fee57ae3          	bgeu	a0,a4,ffffffffc0200ca8 <buddy_system_init_memmap+0x6c>
ffffffffc0200cb8:	00080463          	beqz	a6,ffffffffc0200cc0 <buddy_system_init_memmap+0x84>
ffffffffc0200cbc:	0116b023          	sd	a7,0(a3)
    __list_add(elm, listelm->prev, listelm);
ffffffffc0200cc0:	6398                	ld	a4,0(a5)
    prev->next = next->prev = elm;
ffffffffc0200cc2:	e390                	sd	a2,0(a5)
}
ffffffffc0200cc4:	60a2                	ld	ra,8(sp)
ffffffffc0200cc6:	e710                	sd	a2,8(a4)
    elm->next = next;
ffffffffc0200cc8:	f11c                	sd	a5,32(a0)
    elm->prev = prev;
ffffffffc0200cca:	ed18                	sd	a4,24(a0)
ffffffffc0200ccc:	0141                	addi	sp,sp,16
    memtree_init(base,n);
ffffffffc0200cce:	bb59                	j	ffffffffc0200a64 <memtree_init>
    prev->next = next->prev = elm;
ffffffffc0200cd0:	e790                	sd	a2,8(a5)
    elm->next = next;
ffffffffc0200cd2:	f114                	sd	a3,32(a0)
    return listelm->next;
ffffffffc0200cd4:	6798                	ld	a4,8(a5)
    elm->prev = prev;
ffffffffc0200cd6:	ed1c                	sd	a5,24(a0)
        while ((le = list_next(le)) != &free_list) {
ffffffffc0200cd8:	00d70663          	beq	a4,a3,ffffffffc0200ce4 <buddy_system_init_memmap+0xa8>
    prev->next = next->prev = elm;
ffffffffc0200cdc:	88b2                	mv	a7,a2
ffffffffc0200cde:	4805                	li	a6,1
    for (; p != base + n; p ++) {
ffffffffc0200ce0:	87ba                	mv	a5,a4
ffffffffc0200ce2:	b7f9                	j	ffffffffc0200cb0 <buddy_system_init_memmap+0x74>
}
ffffffffc0200ce4:	60a2                	ld	ra,8(sp)
ffffffffc0200ce6:	e290                	sd	a2,0(a3)
ffffffffc0200ce8:	0141                	addi	sp,sp,16
    memtree_init(base,n);
ffffffffc0200cea:	bbad                	j	ffffffffc0200a64 <memtree_init>
}
ffffffffc0200cec:	60a2                	ld	ra,8(sp)
ffffffffc0200cee:	e390                	sd	a2,0(a5)
ffffffffc0200cf0:	e790                	sd	a2,8(a5)
    elm->next = next;
ffffffffc0200cf2:	f11c                	sd	a5,32(a0)
    elm->prev = prev;
ffffffffc0200cf4:	ed1c                	sd	a5,24(a0)
ffffffffc0200cf6:	0141                	addi	sp,sp,16
    memtree_init(base,n);
ffffffffc0200cf8:	b3b5                	j	ffffffffc0200a64 <memtree_init>
        assert(PageReserved(p));
ffffffffc0200cfa:	00001697          	auipc	a3,0x1
ffffffffc0200cfe:	4f668693          	addi	a3,a3,1270 # ffffffffc02021f0 <commands+0x670>
ffffffffc0200d02:	00001617          	auipc	a2,0x1
ffffffffc0200d06:	37e60613          	addi	a2,a2,894 # ffffffffc0202080 <commands+0x500>
ffffffffc0200d0a:	10c00593          	li	a1,268
ffffffffc0200d0e:	00001517          	auipc	a0,0x1
ffffffffc0200d12:	38a50513          	addi	a0,a0,906 # ffffffffc0202098 <commands+0x518>
ffffffffc0200d16:	c24ff0ef          	jal	ra,ffffffffc020013a <__panic>
    assert(n > 0);
ffffffffc0200d1a:	00001697          	auipc	a3,0x1
ffffffffc0200d1e:	4ce68693          	addi	a3,a3,1230 # ffffffffc02021e8 <commands+0x668>
ffffffffc0200d22:	00001617          	auipc	a2,0x1
ffffffffc0200d26:	35e60613          	addi	a2,a2,862 # ffffffffc0202080 <commands+0x500>
ffffffffc0200d2a:	10800593          	li	a1,264
ffffffffc0200d2e:	00001517          	auipc	a0,0x1
ffffffffc0200d32:	36a50513          	addi	a0,a0,874 # ffffffffc0202098 <commands+0x518>
ffffffffc0200d36:	c04ff0ef          	jal	ra,ffffffffc020013a <__panic>

ffffffffc0200d3a <get_mem>:
    while(tree[find_pos].avail>=n && find_pos<(tree_size-1)/2)
ffffffffc0200d3a:	00005f17          	auipc	t5,0x5
ffffffffc0200d3e:	706f0f13          	addi	t5,t5,1798 # ffffffffc0206440 <tree>
ffffffffc0200d42:	000f3603          	ld	a2,0(t5)
ffffffffc0200d46:	4214                	lw	a3,0(a2)
ffffffffc0200d48:	14a6cc63          	blt	a3,a0,ffffffffc0200ea0 <get_mem+0x166>
{
ffffffffc0200d4c:	1101                	addi	sp,sp,-32
ffffffffc0200d4e:	ec22                	sd	s0,24(sp)
ffffffffc0200d50:	e826                	sd	s1,16(sp)
ffffffffc0200d52:	e44a                	sd	s2,8(sp)
ffffffffc0200d54:	8e2a                	mv	t3,a0
    while(tree[find_pos].avail>=n && find_pos<(tree_size-1)/2)
ffffffffc0200d56:	8332                	mv	t1,a2
    int find_pos=0;
ffffffffc0200d58:	4781                	li	a5,0
    while(tree[find_pos].avail>=n && find_pos<(tree_size-1)/2)
ffffffffc0200d5a:	4281                	li	t0,0
ffffffffc0200d5c:	00005f97          	auipc	t6,0x5
ffffffffc0200d60:	6ecf8f93          	addi	t6,t6,1772 # ffffffffc0206448 <tree_size>
ffffffffc0200d64:	4389                	li	t2,2
ffffffffc0200d66:	000fa703          	lw	a4,0(t6)
ffffffffc0200d6a:	fff7059b          	addiw	a1,a4,-1
ffffffffc0200d6e:	01f5d71b          	srliw	a4,a1,0x1f
ffffffffc0200d72:	9f2d                	addw	a4,a4,a1
ffffffffc0200d74:	4017571b          	sraiw	a4,a4,0x1
ffffffffc0200d78:	10e7df63          	bge	a5,a4,ffffffffc0200e96 <get_mem+0x15c>
        if(tree[find_pos].avail==tree[find_pos].size && tree[find_pos].avail>n)//处理内存块链表
ffffffffc0200d7c:	00432803          	lw	a6,4(t1)
            (tree[find_pos*2+1].page)->property=tree[find_pos*2+1].avail;
ffffffffc0200d80:	0017971b          	slliw	a4,a5,0x1
ffffffffc0200d84:	0017051b          	addiw	a0,a4,1
ffffffffc0200d88:	2709                	addiw	a4,a4,2
ffffffffc0200d8a:	00451593          	slli	a1,a0,0x4
            (tree[find_pos*2+2].page)->property=tree[find_pos*2+2].avail;
ffffffffc0200d8e:	00471893          	slli	a7,a4,0x4
        if(tree[find_pos].avail==tree[find_pos].size && tree[find_pos].avail>n)//处理内存块链表
ffffffffc0200d92:	0ad80163          	beq	a6,a3,ffffffffc0200e34 <get_mem+0xfa>
        if(tree[find_pos*2+1].avail>=n && (tree[find_pos*2+2].avail >= tree[find_pos*2+1].avail || tree[find_pos*2+2].avail<n))//选择左孩子的情况
ffffffffc0200d96:	000f3603          	ld	a2,0(t5)
ffffffffc0200d9a:	00b60333          	add	t1,a2,a1
ffffffffc0200d9e:	01160833          	add	a6,a2,a7
ffffffffc0200da2:	00032683          	lw	a3,0(t1)
ffffffffc0200da6:	00082e83          	lw	t4,0(a6)
ffffffffc0200daa:	03c6c063          	blt	a3,t3,ffffffffc0200dca <get_mem+0x90>
ffffffffc0200dae:	00dedb63          	bge	t4,a3,ffffffffc0200dc4 <get_mem+0x8a>
ffffffffc0200db2:	01cec963          	blt	t4,t3,ffffffffc0200dc4 <get_mem+0x8a>
    while(tree[find_pos].avail>=n && find_pos<(tree_size-1)/2)
ffffffffc0200db6:	00082683          	lw	a3,0(a6)
ffffffffc0200dba:	8342                	mv	t1,a6
ffffffffc0200dbc:	0fc6c063          	blt	a3,t3,ffffffffc0200e9c <get_mem+0x162>
ffffffffc0200dc0:	85c6                	mv	a1,a7
            find_pos=find_pos*2+2;
ffffffffc0200dc2:	853a                	mv	a0,a4
ffffffffc0200dc4:	87aa                	mv	a5,a0
ffffffffc0200dc6:	82ae                	mv	t0,a1
ffffffffc0200dc8:	bf79                	j	ffffffffc0200d66 <get_mem+0x2c>
        if(tree[find_pos*2+2].avail>=n)//选择右孩子
ffffffffc0200dca:	ffced6e3          	bge	t4,t3,ffffffffc0200db6 <get_mem+0x7c>
    if(find_pos==0&&tree[find_pos].avail<n)
ffffffffc0200dce:	00560333          	add	t1,a2,t0
ffffffffc0200dd2:	cbcd                	beqz	a5,ffffffffc0200e84 <get_mem+0x14a>
    tree[find_pos].avail=0;
ffffffffc0200dd4:	00032023          	sw	zero,0(t1)
        int dpos=(pos-1)/2;
ffffffffc0200dd8:	37fd                	addiw	a5,a5,-1
ffffffffc0200dda:	4017d79b          	sraiw	a5,a5,0x1
        tree[dpos].avail=tree[dpos*2+1].avail>tree[dpos*2+2].avail ? tree[dpos*2+1].avail:tree[dpos*2+2].avail;
ffffffffc0200dde:	0017971b          	slliw	a4,a5,0x1
ffffffffc0200de2:	0027069b          	addiw	a3,a4,2
ffffffffc0200de6:	2705                	addiw	a4,a4,1
ffffffffc0200de8:	0692                	slli	a3,a3,0x4
ffffffffc0200dea:	0712                	slli	a4,a4,0x4
ffffffffc0200dec:	9732                	add	a4,a4,a2
ffffffffc0200dee:	96b2                	add	a3,a3,a2
ffffffffc0200df0:	430c                	lw	a1,0(a4)
ffffffffc0200df2:	4294                	lw	a3,0(a3)
ffffffffc0200df4:	00479713          	slli	a4,a5,0x4
ffffffffc0200df8:	0005881b          	sext.w	a6,a1
ffffffffc0200dfc:	0006889b          	sext.w	a7,a3
ffffffffc0200e00:	9732                	add	a4,a4,a2
ffffffffc0200e02:	0108d363          	bge	a7,a6,ffffffffc0200e08 <get_mem+0xce>
ffffffffc0200e06:	86ae                	mv	a3,a1
ffffffffc0200e08:	c314                	sw	a3,0(a4)
    while(pos>0)
ffffffffc0200e0a:	f7f9                	bnez	a5,ffffffffc0200dd8 <get_mem+0x9e>
    list_del(&(tree[find_pos].page->page_link));
ffffffffc0200e0c:	00833503          	ld	a0,8(t1)
    nr_free -= n;
ffffffffc0200e10:	00005717          	auipc	a4,0x5
ffffffffc0200e14:	20070713          	addi	a4,a4,512 # ffffffffc0206010 <bsfree_area>
ffffffffc0200e18:	4b1c                	lw	a5,16(a4)
    __list_del(listelm->prev, listelm->next);
ffffffffc0200e1a:	6d10                	ld	a2,24(a0)
ffffffffc0200e1c:	7114                	ld	a3,32(a0)
ffffffffc0200e1e:	41c78e3b          	subw	t3,a5,t3
>>>>>>> origin/main
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
<<<<<<< HEAD
ffffffffc0200fd8:	e61c                	sd	a5,8(a2)
    return listelm->next;
ffffffffc0200fda:	6718                	ld	a4,8(a4)
    next->prev = prev;
ffffffffc0200fdc:	e390                	sd	a2,0(a5)
ffffffffc0200fde:	b775                	j	ffffffffc0200f8a <best_fit_free_pages+0xae>
ffffffffc0200fe0:	e290                	sd	a2,0(a3)
        while ((le = list_next(le)) != &free_list) {
ffffffffc0200fe2:	873e                	mv	a4,a5
ffffffffc0200fe4:	b761                	j	ffffffffc0200f6c <best_fit_free_pages+0x90>
}
ffffffffc0200fe6:	60a2                	ld	ra,8(sp)
    prev->next = next->prev = elm;
ffffffffc0200fe8:	e390                	sd	a2,0(a5)
ffffffffc0200fea:	e790                	sd	a2,8(a5)
    elm->next = next;
ffffffffc0200fec:	f11c                	sd	a5,32(a0)
    elm->prev = prev;
ffffffffc0200fee:	ed1c                	sd	a5,24(a0)
ffffffffc0200ff0:	0141                	addi	sp,sp,16
ffffffffc0200ff2:	8082                	ret
            base->property += p->property;
ffffffffc0200ff4:	ff872783          	lw	a5,-8(a4)
ffffffffc0200ff8:	ff070693          	addi	a3,a4,-16
ffffffffc0200ffc:	9dbd                	addw	a1,a1,a5
ffffffffc0200ffe:	c90c                	sw	a1,16(a0)
ffffffffc0201000:	57f5                	li	a5,-3
ffffffffc0201002:	60f6b02f          	amoand.d	zero,a5,(a3)
    __list_del(listelm->prev, listelm->next);
ffffffffc0201006:	6314                	ld	a3,0(a4)
ffffffffc0201008:	671c                	ld	a5,8(a4)
}
ffffffffc020100a:	60a2                	ld	ra,8(sp)
    prev->next = next;
ffffffffc020100c:	e69c                	sd	a5,8(a3)
    next->prev = prev;
ffffffffc020100e:	e394                	sd	a3,0(a5)
ffffffffc0201010:	0141                	addi	sp,sp,16
ffffffffc0201012:	8082                	ret
        assert(!PageReserved(p) && !PageProperty(p));
ffffffffc0201014:	00001697          	auipc	a3,0x1
ffffffffc0201018:	3ec68693          	addi	a3,a3,1004 # ffffffffc0202400 <commands+0x7f0>
ffffffffc020101c:	00001617          	auipc	a2,0x1
ffffffffc0201020:	0fc60613          	addi	a2,a2,252 # ffffffffc0202118 <commands+0x508>
ffffffffc0201024:	09300593          	li	a1,147
ffffffffc0201028:	00001517          	auipc	a0,0x1
ffffffffc020102c:	10850513          	addi	a0,a0,264 # ffffffffc0202130 <commands+0x520>
ffffffffc0201030:	b7cff0ef          	jal	ra,ffffffffc02003ac <__panic>
    assert(n > 0);
ffffffffc0201034:	00001697          	auipc	a3,0x1
ffffffffc0201038:	3c468693          	addi	a3,a3,964 # ffffffffc02023f8 <commands+0x7e8>
ffffffffc020103c:	00001617          	auipc	a2,0x1
ffffffffc0201040:	0dc60613          	addi	a2,a2,220 # ffffffffc0202118 <commands+0x508>
ffffffffc0201044:	09000593          	li	a1,144
ffffffffc0201048:	00001517          	auipc	a0,0x1
ffffffffc020104c:	0e850513          	addi	a0,a0,232 # ffffffffc0202130 <commands+0x520>
ffffffffc0201050:	b5cff0ef          	jal	ra,ffffffffc02003ac <__panic>

ffffffffc0201054 <best_fit_alloc_pages>:
    assert(n > 0);
ffffffffc0201054:	c545                	beqz	a0,ffffffffc02010fc <best_fit_alloc_pages+0xa8>
    if (n > nr_free) {
ffffffffc0201056:	00005597          	auipc	a1,0x5
ffffffffc020105a:	fba58593          	addi	a1,a1,-70 # ffffffffc0206010 <free_area>
ffffffffc020105e:	0105a883          	lw	a7,16(a1)
ffffffffc0201062:	86aa                	mv	a3,a0
ffffffffc0201064:	02089793          	slli	a5,a7,0x20
ffffffffc0201068:	9381                	srli	a5,a5,0x20
ffffffffc020106a:	08a7e763          	bltu	a5,a0,ffffffffc02010f8 <best_fit_alloc_pages+0xa4>
    return listelm->next;
ffffffffc020106e:	659c                	ld	a5,8(a1)
    struct Page *best_page=NULL;
ffffffffc0201070:	4501                	li	a0,0
    while ((le = list_next(le)) != &free_list) {
ffffffffc0201072:	08b78263          	beq	a5,a1,ffffffffc02010f6 <best_fit_alloc_pages+0xa2>
    int min= PHYSICAL_MEMORY_END/ PGSIZE;
ffffffffc0201076:	00088837          	lui	a6,0x88
        if (p->property >= n &&(p->property-n)<min) {
ffffffffc020107a:	ff87a603          	lw	a2,-8(a5)
ffffffffc020107e:	02061713          	slli	a4,a2,0x20
ffffffffc0201082:	9301                	srli	a4,a4,0x20
ffffffffc0201084:	00d76963          	bltu	a4,a3,ffffffffc0201096 <best_fit_alloc_pages+0x42>
ffffffffc0201088:	8f15                	sub	a4,a4,a3
ffffffffc020108a:	01077663          	bgeu	a4,a6,ffffffffc0201096 <best_fit_alloc_pages+0x42>
        struct Page *p = le2page(le, page_link);
ffffffffc020108e:	fe878513          	addi	a0,a5,-24
            min=(p->property-n);
ffffffffc0201092:	40d6083b          	subw	a6,a2,a3
ffffffffc0201096:	679c                	ld	a5,8(a5)
    while ((le = list_next(le)) != &free_list) {
ffffffffc0201098:	feb791e3          	bne	a5,a1,ffffffffc020107a <best_fit_alloc_pages+0x26>
    if (page != NULL) {
ffffffffc020109c:	cd29                	beqz	a0,ffffffffc02010f6 <best_fit_alloc_pages+0xa2>
    __list_del(listelm->prev, listelm->next);
ffffffffc020109e:	711c                	ld	a5,32(a0)
    return listelm->prev;
ffffffffc02010a0:	6d18                	ld	a4,24(a0)
        if (page->property > n) {
ffffffffc02010a2:	4910                	lw	a2,16(a0)
            min=(p->property-n);
ffffffffc02010a4:	0006881b          	sext.w	a6,a3
    prev->next = next;
ffffffffc02010a8:	e71c                	sd	a5,8(a4)
    next->prev = prev;
ffffffffc02010aa:	e398                	sd	a4,0(a5)
        if (page->property > n) {
ffffffffc02010ac:	02061793          	slli	a5,a2,0x20
ffffffffc02010b0:	9381                	srli	a5,a5,0x20
ffffffffc02010b2:	02f6f863          	bgeu	a3,a5,ffffffffc02010e2 <best_fit_alloc_pages+0x8e>
            struct Page *p = page + n;
ffffffffc02010b6:	00269793          	slli	a5,a3,0x2
ffffffffc02010ba:	97b6                	add	a5,a5,a3
ffffffffc02010bc:	078e                	slli	a5,a5,0x3
ffffffffc02010be:	97aa                	add	a5,a5,a0
            p->property = page->property - n;
ffffffffc02010c0:	4106063b          	subw	a2,a2,a6
ffffffffc02010c4:	cb90                	sw	a2,16(a5)
    __op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc02010c6:	4689                	li	a3,2
ffffffffc02010c8:	00878613          	addi	a2,a5,8
ffffffffc02010cc:	40d6302f          	amoor.d	zero,a3,(a2)
    __list_add(elm, listelm, listelm->next);
ffffffffc02010d0:	6714                	ld	a3,8(a4)
            list_add(prev, &(p->page_link));
ffffffffc02010d2:	01878613          	addi	a2,a5,24
        nr_free -= n;
ffffffffc02010d6:	0105a883          	lw	a7,16(a1)
    prev->next = next->prev = elm;
ffffffffc02010da:	e290                	sd	a2,0(a3)
ffffffffc02010dc:	e710                	sd	a2,8(a4)
    elm->next = next;
ffffffffc02010de:	f394                	sd	a3,32(a5)
    elm->prev = prev;
ffffffffc02010e0:	ef98                	sd	a4,24(a5)
ffffffffc02010e2:	410888bb          	subw	a7,a7,a6
ffffffffc02010e6:	0115a823          	sw	a7,16(a1)
    __op_bit(and, __NOT, nr, ((volatile unsigned long *)addr));
ffffffffc02010ea:	57f5                	li	a5,-3
ffffffffc02010ec:	00850713          	addi	a4,a0,8
ffffffffc02010f0:	60f7302f          	amoand.d	zero,a5,(a4)
}
ffffffffc02010f4:	8082                	ret
}
ffffffffc02010f6:	8082                	ret
        return NULL;
ffffffffc02010f8:	4501                	li	a0,0
ffffffffc02010fa:	8082                	ret
best_fit_alloc_pages(size_t n) {
ffffffffc02010fc:	1141                	addi	sp,sp,-16
    assert(n > 0);
ffffffffc02010fe:	00001697          	auipc	a3,0x1
ffffffffc0201102:	2fa68693          	addi	a3,a3,762 # ffffffffc02023f8 <commands+0x7e8>
ffffffffc0201106:	00001617          	auipc	a2,0x1
ffffffffc020110a:	01260613          	addi	a2,a2,18 # ffffffffc0202118 <commands+0x508>
ffffffffc020110e:	06a00593          	li	a1,106
ffffffffc0201112:	00001517          	auipc	a0,0x1
ffffffffc0201116:	01e50513          	addi	a0,a0,30 # ffffffffc0202130 <commands+0x520>
best_fit_alloc_pages(size_t n) {
ffffffffc020111a:	e406                	sd	ra,8(sp)
    assert(n > 0);
ffffffffc020111c:	a90ff0ef          	jal	ra,ffffffffc02003ac <__panic>

ffffffffc0201120 <best_fit_init_memmap>:
best_fit_init_memmap(struct Page *base, size_t n) {
ffffffffc0201120:	1141                	addi	sp,sp,-16
ffffffffc0201122:	e406                	sd	ra,8(sp)
    assert(n > 0);
ffffffffc0201124:	c9e1                	beqz	a1,ffffffffc02011f4 <best_fit_init_memmap+0xd4>
    for (; p != base + n; p ++) {
ffffffffc0201126:	00259693          	slli	a3,a1,0x2
ffffffffc020112a:	96ae                	add	a3,a3,a1
ffffffffc020112c:	068e                	slli	a3,a3,0x3
ffffffffc020112e:	96aa                	add	a3,a3,a0
ffffffffc0201130:	87aa                	mv	a5,a0
ffffffffc0201132:	00d50f63          	beq	a0,a3,ffffffffc0201150 <best_fit_init_memmap+0x30>
    return (((*(volatile unsigned long *)addr) >> nr) & 1);
ffffffffc0201136:	6798                	ld	a4,8(a5)
        assert(PageReserved(p));
ffffffffc0201138:	8b05                	andi	a4,a4,1
ffffffffc020113a:	cf49                	beqz	a4,ffffffffc02011d4 <best_fit_init_memmap+0xb4>
        p->flags = p->property = 0;
ffffffffc020113c:	0007a823          	sw	zero,16(a5)
ffffffffc0201140:	0007b423          	sd	zero,8(a5)
ffffffffc0201144:	0007a023          	sw	zero,0(a5)
    for (; p != base + n; p ++) {
ffffffffc0201148:	02878793          	addi	a5,a5,40
ffffffffc020114c:	fed795e3          	bne	a5,a3,ffffffffc0201136 <best_fit_init_memmap+0x16>
    base->property = n;
ffffffffc0201150:	2581                	sext.w	a1,a1
ffffffffc0201152:	c90c                	sw	a1,16(a0)
    __op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc0201154:	4789                	li	a5,2
ffffffffc0201156:	00850713          	addi	a4,a0,8
ffffffffc020115a:	40f7302f          	amoor.d	zero,a5,(a4)
    nr_free += n;
ffffffffc020115e:	00005697          	auipc	a3,0x5
ffffffffc0201162:	eb268693          	addi	a3,a3,-334 # ffffffffc0206010 <free_area>
ffffffffc0201166:	4a98                	lw	a4,16(a3)
    return list->next == list;
ffffffffc0201168:	669c                	ld	a5,8(a3)
        list_add(&free_list, &(base->page_link));
ffffffffc020116a:	01850613          	addi	a2,a0,24
    nr_free += n;
ffffffffc020116e:	9db9                	addw	a1,a1,a4
ffffffffc0201170:	ca8c                	sw	a1,16(a3)
    if (list_empty(&free_list)) {
ffffffffc0201172:	04d78a63          	beq	a5,a3,ffffffffc02011c6 <best_fit_init_memmap+0xa6>
            struct Page* page = le2page(le, page_link);
ffffffffc0201176:	fe878713          	addi	a4,a5,-24
ffffffffc020117a:	0006b803          	ld	a6,0(a3)
    if (list_empty(&free_list)) {
ffffffffc020117e:	4581                	li	a1,0
            if (base < page) {
ffffffffc0201180:	00e56a63          	bltu	a0,a4,ffffffffc0201194 <best_fit_init_memmap+0x74>
    return listelm->next;
ffffffffc0201184:	6798                	ld	a4,8(a5)
            } else if (list_next(le) == &free_list) {
ffffffffc0201186:	02d70263          	beq	a4,a3,ffffffffc02011aa <best_fit_init_memmap+0x8a>
    for (; p != base + n; p ++) {
ffffffffc020118a:	87ba                	mv	a5,a4
            struct Page* page = le2page(le, page_link);
ffffffffc020118c:	fe878713          	addi	a4,a5,-24
            if (base < page) {
ffffffffc0201190:	fee57ae3          	bgeu	a0,a4,ffffffffc0201184 <best_fit_init_memmap+0x64>
ffffffffc0201194:	c199                	beqz	a1,ffffffffc020119a <best_fit_init_memmap+0x7a>
ffffffffc0201196:	0106b023          	sd	a6,0(a3)
    __list_add(elm, listelm->prev, listelm);
ffffffffc020119a:	6398                	ld	a4,0(a5)
}
ffffffffc020119c:	60a2                	ld	ra,8(sp)
    prev->next = next->prev = elm;
ffffffffc020119e:	e390                	sd	a2,0(a5)
ffffffffc02011a0:	e710                	sd	a2,8(a4)
    elm->next = next;
ffffffffc02011a2:	f11c                	sd	a5,32(a0)
    elm->prev = prev;
ffffffffc02011a4:	ed18                	sd	a4,24(a0)
ffffffffc02011a6:	0141                	addi	sp,sp,16
ffffffffc02011a8:	8082                	ret
    prev->next = next->prev = elm;
ffffffffc02011aa:	e790                	sd	a2,8(a5)
    elm->next = next;
ffffffffc02011ac:	f114                	sd	a3,32(a0)
    return listelm->next;
ffffffffc02011ae:	6798                	ld	a4,8(a5)
    elm->prev = prev;
ffffffffc02011b0:	ed1c                	sd	a5,24(a0)
        while ((le = list_next(le)) != &free_list) {
ffffffffc02011b2:	00d70663          	beq	a4,a3,ffffffffc02011be <best_fit_init_memmap+0x9e>
    prev->next = next->prev = elm;
ffffffffc02011b6:	8832                	mv	a6,a2
ffffffffc02011b8:	4585                	li	a1,1
    for (; p != base + n; p ++) {
ffffffffc02011ba:	87ba                	mv	a5,a4
ffffffffc02011bc:	bfc1                	j	ffffffffc020118c <best_fit_init_memmap+0x6c>
}
ffffffffc02011be:	60a2                	ld	ra,8(sp)
ffffffffc02011c0:	e290                	sd	a2,0(a3)
ffffffffc02011c2:	0141                	addi	sp,sp,16
ffffffffc02011c4:	8082                	ret
ffffffffc02011c6:	60a2                	ld	ra,8(sp)
ffffffffc02011c8:	e390                	sd	a2,0(a5)
ffffffffc02011ca:	e790                	sd	a2,8(a5)
    elm->next = next;
ffffffffc02011cc:	f11c                	sd	a5,32(a0)
    elm->prev = prev;
ffffffffc02011ce:	ed1c                	sd	a5,24(a0)
ffffffffc02011d0:	0141                	addi	sp,sp,16
ffffffffc02011d2:	8082                	ret
        assert(PageReserved(p));
ffffffffc02011d4:	00001697          	auipc	a3,0x1
ffffffffc02011d8:	25468693          	addi	a3,a3,596 # ffffffffc0202428 <commands+0x818>
ffffffffc02011dc:	00001617          	auipc	a2,0x1
ffffffffc02011e0:	f3c60613          	addi	a2,a2,-196 # ffffffffc0202118 <commands+0x508>
ffffffffc02011e4:	04a00593          	li	a1,74
ffffffffc02011e8:	00001517          	auipc	a0,0x1
ffffffffc02011ec:	f4850513          	addi	a0,a0,-184 # ffffffffc0202130 <commands+0x520>
ffffffffc02011f0:	9bcff0ef          	jal	ra,ffffffffc02003ac <__panic>
    assert(n > 0);
ffffffffc02011f4:	00001697          	auipc	a3,0x1
ffffffffc02011f8:	20468693          	addi	a3,a3,516 # ffffffffc02023f8 <commands+0x7e8>
ffffffffc02011fc:	00001617          	auipc	a2,0x1
ffffffffc0201200:	f1c60613          	addi	a2,a2,-228 # ffffffffc0202118 <commands+0x508>
ffffffffc0201204:	04700593          	li	a1,71
ffffffffc0201208:	00001517          	auipc	a0,0x1
ffffffffc020120c:	f2850513          	addi	a0,a0,-216 # ffffffffc0202130 <commands+0x520>
ffffffffc0201210:	99cff0ef          	jal	ra,ffffffffc02003ac <__panic>

ffffffffc0201214 <alloc_pages>:
=======
ffffffffc0200e22:	e614                	sd	a3,8(a2)
    next->prev = prev;
ffffffffc0200e24:	e290                	sd	a2,0(a3)
ffffffffc0200e26:	01c72823          	sw	t3,16(a4)
}
ffffffffc0200e2a:	6462                	ld	s0,24(sp)
ffffffffc0200e2c:	64c2                	ld	s1,16(sp)
ffffffffc0200e2e:	6922                	ld	s2,8(sp)
ffffffffc0200e30:	6105                	addi	sp,sp,32
ffffffffc0200e32:	8082                	ret
        if(tree[find_pos].avail==tree[find_pos].size && tree[find_pos].avail>n)//处理内存块链表
ffffffffc0200e34:	f6de51e3          	bge	t3,a3,ffffffffc0200d96 <get_mem+0x5c>
            (tree[find_pos*2+1].page)->property=tree[find_pos*2+1].avail;
ffffffffc0200e38:	00b606b3          	add	a3,a2,a1
ffffffffc0200e3c:	0086b803          	ld	a6,8(a3)
ffffffffc0200e40:	0006a303          	lw	t1,0(a3)
            (tree[find_pos*2+2].page)->property=tree[find_pos*2+2].avail;
ffffffffc0200e44:	9646                	add	a2,a2,a7
ffffffffc0200e46:	6614                	ld	a3,8(a2)
ffffffffc0200e48:	4210                	lw	a2,0(a2)
            (tree[find_pos*2+1].page)->property=tree[find_pos*2+1].avail;
ffffffffc0200e4a:	00682823          	sw	t1,16(a6)
ffffffffc0200e4e:	06a1                	addi	a3,a3,8
            (tree[find_pos*2+2].page)->property=tree[find_pos*2+2].avail;
ffffffffc0200e50:	c690                	sw	a2,8(a3)
ffffffffc0200e52:	4076b02f          	amoor.d	zero,t2,(a3)
            list_add(&(tree[find_pos*2+1].page->page_link), &((tree[find_pos*2+2].page)->page_link));
ffffffffc0200e56:	000f3603          	ld	a2,0(t5)
ffffffffc0200e5a:	00b60333          	add	t1,a2,a1
ffffffffc0200e5e:	00833e83          	ld	t4,8(t1)
ffffffffc0200e62:	01160833          	add	a6,a2,a7
ffffffffc0200e66:	00883683          	ld	a3,8(a6)
    __list_add(elm, listelm, listelm->next);
ffffffffc0200e6a:	020eb403          	ld	s0,32(t4)
ffffffffc0200e6e:	018e8913          	addi	s2,t4,24
ffffffffc0200e72:	01868493          	addi	s1,a3,24
    prev->next = next->prev = elm;
ffffffffc0200e76:	e004                	sd	s1,0(s0)
ffffffffc0200e78:	029eb023          	sd	s1,32(t4)
    elm->next = next;
ffffffffc0200e7c:	f280                	sd	s0,32(a3)
    elm->prev = prev;
ffffffffc0200e7e:	0126bc23          	sd	s2,24(a3)
}
ffffffffc0200e82:	b705                	j	ffffffffc0200da2 <get_mem+0x68>
    if(find_pos==0&&tree[find_pos].avail<n)
ffffffffc0200e84:	00032783          	lw	a5,0(t1)
ffffffffc0200e88:	01c7c563          	blt	a5,t3,ffffffffc0200e92 <get_mem+0x158>
    tree[find_pos].avail=0;
ffffffffc0200e8c:	00032023          	sw	zero,0(t1)
    while(pos>0)
ffffffffc0200e90:	bfb5                	j	ffffffffc0200e0c <get_mem+0xd2>
        return NULL;
ffffffffc0200e92:	4501                	li	a0,0
ffffffffc0200e94:	bf59                	j	ffffffffc0200e2a <get_mem+0xf0>
    if(find_pos==0&&tree[find_pos].avail<n)
ffffffffc0200e96:	000f3603          	ld	a2,0(t5)
ffffffffc0200e9a:	bf15                	j	ffffffffc0200dce <get_mem+0x94>
            find_pos=find_pos*2+2;
ffffffffc0200e9c:	87ba                	mv	a5,a4
ffffffffc0200e9e:	bf1d                	j	ffffffffc0200dd4 <get_mem+0x9a>
        return NULL;
ffffffffc0200ea0:	4501                	li	a0,0
}
ffffffffc0200ea2:	8082                	ret

ffffffffc0200ea4 <buddy_system_alloc_pages>:
buddy_system_alloc_pages(size_t n) {
ffffffffc0200ea4:	1141                	addi	sp,sp,-16
ffffffffc0200ea6:	e406                	sd	ra,8(sp)
    assert(n > 0);
ffffffffc0200ea8:	cd1d                	beqz	a0,ffffffffc0200ee6 <buddy_system_alloc_pages+0x42>
    if (n > nr_free) {
ffffffffc0200eaa:	00005717          	auipc	a4,0x5
ffffffffc0200eae:	17676703          	lwu	a4,374(a4) # ffffffffc0206020 <bsfree_area+0x10>
ffffffffc0200eb2:	87aa                	mv	a5,a0
ffffffffc0200eb4:	02a76563          	bltu	a4,a0,ffffffffc0200ede <buddy_system_alloc_pages+0x3a>
    while(n>size)
ffffffffc0200eb8:	4705                	li	a4,1
    int size=1;
ffffffffc0200eba:	4505                	li	a0,1
    while(n>size)
ffffffffc0200ebc:	00e78663          	beq	a5,a4,ffffffffc0200ec8 <buddy_system_alloc_pages+0x24>
		size=size<<1;	
ffffffffc0200ec0:	0015151b          	slliw	a0,a0,0x1
    while(n>size)
ffffffffc0200ec4:	fef56ee3          	bltu	a0,a5,ffffffffc0200ec0 <buddy_system_alloc_pages+0x1c>
    page=get_mem(size);
ffffffffc0200ec8:	e73ff0ef          	jal	ra,ffffffffc0200d3a <get_mem>
    if (page != NULL) {
ffffffffc0200ecc:	c511                	beqz	a0,ffffffffc0200ed8 <buddy_system_alloc_pages+0x34>
    __op_bit(and, __NOT, nr, ((volatile unsigned long *)addr));
ffffffffc0200ece:	57f5                	li	a5,-3
ffffffffc0200ed0:	00850713          	addi	a4,a0,8
ffffffffc0200ed4:	60f7302f          	amoand.d	zero,a5,(a4)
}
ffffffffc0200ed8:	60a2                	ld	ra,8(sp)
ffffffffc0200eda:	0141                	addi	sp,sp,16
ffffffffc0200edc:	8082                	ret
ffffffffc0200ede:	60a2                	ld	ra,8(sp)
        return NULL;
ffffffffc0200ee0:	4501                	li	a0,0
}
ffffffffc0200ee2:	0141                	addi	sp,sp,16
ffffffffc0200ee4:	8082                	ret
    assert(n > 0);
ffffffffc0200ee6:	00001697          	auipc	a3,0x1
ffffffffc0200eea:	30268693          	addi	a3,a3,770 # ffffffffc02021e8 <commands+0x668>
ffffffffc0200eee:	00001617          	auipc	a2,0x1
ffffffffc0200ef2:	19260613          	addi	a2,a2,402 # ffffffffc0202080 <commands+0x500>
ffffffffc0200ef6:	12800593          	li	a1,296
ffffffffc0200efa:	00001517          	auipc	a0,0x1
ffffffffc0200efe:	19e50513          	addi	a0,a0,414 # ffffffffc0202098 <commands+0x518>
ffffffffc0200f02:	a38ff0ef          	jal	ra,ffffffffc020013a <__panic>

ffffffffc0200f06 <free_mem>:
    int ea= page-tree[0].page;
ffffffffc0200f06:	00005e97          	auipc	t4,0x5
ffffffffc0200f0a:	53ae8e93          	addi	t4,t4,1338 # ffffffffc0206440 <tree>
ffffffffc0200f0e:	000eb803          	ld	a6,0(t4)
    int pos=ea+(tree_size-1)/2;
ffffffffc0200f12:	00005797          	auipc	a5,0x5
ffffffffc0200f16:	5367a783          	lw	a5,1334(a5) # ffffffffc0206448 <tree_size>
ffffffffc0200f1a:	fff7869b          	addiw	a3,a5,-1
    int ea= page-tree[0].page;
ffffffffc0200f1e:	00883703          	ld	a4,8(a6)
ffffffffc0200f22:	40e507b3          	sub	a5,a0,a4
ffffffffc0200f26:	878d                	srai	a5,a5,0x3
ffffffffc0200f28:	00001717          	auipc	a4,0x1
ffffffffc0200f2c:	75873703          	ld	a4,1880(a4) # ffffffffc0202680 <error_string+0x38>
ffffffffc0200f30:	02e78733          	mul	a4,a5,a4
    int pos=ea+(tree_size-1)/2;
ffffffffc0200f34:	01f6d79b          	srliw	a5,a3,0x1f
ffffffffc0200f38:	9fb5                	addw	a5,a5,a3
ffffffffc0200f3a:	4017d79b          	sraiw	a5,a5,0x1
ffffffffc0200f3e:	9fb9                	addw	a5,a5,a4
    while(pos>0)
ffffffffc0200f40:	00f04763          	bgtz	a5,ffffffffc0200f4e <free_mem+0x48>
ffffffffc0200f44:	a05d                	j	ffffffffc0200fea <free_mem+0xe4>
        pos=(pos-1)/2;
ffffffffc0200f46:	37fd                	addiw	a5,a5,-1
ffffffffc0200f48:	4017d79b          	sraiw	a5,a5,0x1
    while(pos>0)
ffffffffc0200f4c:	cfd9                	beqz	a5,ffffffffc0200fea <free_mem+0xe4>
        if (tree[pos].size>=n)break;
ffffffffc0200f4e:	00479713          	slli	a4,a5,0x4
ffffffffc0200f52:	9742                	add	a4,a4,a6
ffffffffc0200f54:	4354                	lw	a3,4(a4)
ffffffffc0200f56:	feb6e8e3          	bltu	a3,a1,ffffffffc0200f46 <free_mem+0x40>
{
ffffffffc0200f5a:	1141                	addi	sp,sp,-16
ffffffffc0200f5c:	e406                	sd	ra,8(sp)
    tree[pos].avail=tree[pos].size;
ffffffffc0200f5e:	c314                	sw	a3,0(a4)
ffffffffc0200f60:	5f75                	li	t5,-3
        int dpos=(pos-1)/2;
ffffffffc0200f62:	37fd                	addiw	a5,a5,-1
ffffffffc0200f64:	4017d79b          	sraiw	a5,a5,0x1
        if(tree[dpos*2+1].avail+tree[dpos*2+2].avail==tree[dpos].size)//遇到可以合并的就合并
ffffffffc0200f68:	0017969b          	slliw	a3,a5,0x1
ffffffffc0200f6c:	0016871b          	addiw	a4,a3,1
ffffffffc0200f70:	0689                	addi	a3,a3,2
ffffffffc0200f72:	0712                	slli	a4,a4,0x4
ffffffffc0200f74:	0692                	slli	a3,a3,0x4
ffffffffc0200f76:	9742                	add	a4,a4,a6
ffffffffc0200f78:	00d808b3          	add	a7,a6,a3
ffffffffc0200f7c:	00479613          	slli	a2,a5,0x4
ffffffffc0200f80:	430c                	lw	a1,0(a4)
ffffffffc0200f82:	0008a503          	lw	a0,0(a7)
ffffffffc0200f86:	9642                	add	a2,a2,a6
ffffffffc0200f88:	00462303          	lw	t1,4(a2)
ffffffffc0200f8c:	00a58e3b          	addw	t3,a1,a0
ffffffffc0200f90:	006e0b63          	beq	t3,t1,ffffffffc0200fa6 <free_mem+0xa0>
            tree[dpos].avail=tree[dpos*2+1].avail>tree[dpos*2+2].avail ? tree[dpos*2+1].avail:tree[dpos*2+2].avail;
ffffffffc0200f94:	872e                	mv	a4,a1
ffffffffc0200f96:	00a5d363          	bge	a1,a0,ffffffffc0200f9c <free_mem+0x96>
ffffffffc0200f9a:	872a                	mv	a4,a0
ffffffffc0200f9c:	c218                	sw	a4,0(a2)
    while(pos>0)
ffffffffc0200f9e:	c3b9                	beqz	a5,ffffffffc0200fe4 <free_mem+0xde>
        if(tree[dpos*2+1].avail+tree[dpos*2+2].avail==tree[dpos].size)//遇到可以合并的就合并
ffffffffc0200fa0:	000eb803          	ld	a6,0(t4)
ffffffffc0200fa4:	bf7d                	j	ffffffffc0200f62 <free_mem+0x5c>
            assert(tree[dpos*2+2].page->property==tree[dpos*2+2].size);
ffffffffc0200fa6:	0088b583          	ld	a1,8(a7)
ffffffffc0200faa:	0048a503          	lw	a0,4(a7)
ffffffffc0200fae:	0105a883          	lw	a7,16(a1)
ffffffffc0200fb2:	06a89163          	bne	a7,a0,ffffffffc0201014 <free_mem+0x10e>
            assert(tree[dpos*2+1].page->property==tree[dpos*2+1].size);
ffffffffc0200fb6:	6708                	ld	a0,8(a4)
ffffffffc0200fb8:	4358                	lw	a4,4(a4)
ffffffffc0200fba:	4908                	lw	a0,16(a0)
ffffffffc0200fbc:	02e51c63          	bne	a0,a4,ffffffffc0200ff4 <free_mem+0xee>
            tree[dpos].page->property=tree[dpos].size;
ffffffffc0200fc0:	6618                	ld	a4,8(a2)
            tree[dpos].avail=tree[dpos].size;
ffffffffc0200fc2:	01c62023          	sw	t3,0(a2)
            tree[dpos].page->property=tree[dpos].size;
ffffffffc0200fc6:	01c72823          	sw	t3,16(a4)
ffffffffc0200fca:	00858713          	addi	a4,a1,8
ffffffffc0200fce:	61e7302f          	amoand.d	zero,t5,(a4)
            list_del(&(tree[dpos*2+2].page->page_link));
ffffffffc0200fd2:	000eb703          	ld	a4,0(t4)
ffffffffc0200fd6:	96ba                	add	a3,a3,a4
ffffffffc0200fd8:	6698                	ld	a4,8(a3)
    __list_del(listelm->prev, listelm->next);
ffffffffc0200fda:	6f14                	ld	a3,24(a4)
ffffffffc0200fdc:	7318                	ld	a4,32(a4)
    prev->next = next;
ffffffffc0200fde:	e698                	sd	a4,8(a3)
    next->prev = prev;
ffffffffc0200fe0:	e314                	sd	a3,0(a4)
    while(pos>0)
ffffffffc0200fe2:	ffdd                	bnez	a5,ffffffffc0200fa0 <free_mem+0x9a>
}
ffffffffc0200fe4:	60a2                	ld	ra,8(sp)
ffffffffc0200fe6:	0141                	addi	sp,sp,16
ffffffffc0200fe8:	8082                	ret
    tree[pos].avail=tree[pos].size;
ffffffffc0200fea:	0792                	slli	a5,a5,0x4
ffffffffc0200fec:	97c2                	add	a5,a5,a6
ffffffffc0200fee:	43d8                	lw	a4,4(a5)
ffffffffc0200ff0:	c398                	sw	a4,0(a5)
    while(pos>0)
ffffffffc0200ff2:	8082                	ret
            assert(tree[dpos*2+1].page->property==tree[dpos*2+1].size);
ffffffffc0200ff4:	00001697          	auipc	a3,0x1
ffffffffc0200ff8:	24468693          	addi	a3,a3,580 # ffffffffc0202238 <commands+0x6b8>
ffffffffc0200ffc:	00001617          	auipc	a2,0x1
ffffffffc0201000:	08460613          	addi	a2,a2,132 # ffffffffc0202080 <commands+0x500>
ffffffffc0201004:	0ee00593          	li	a1,238
ffffffffc0201008:	00001517          	auipc	a0,0x1
ffffffffc020100c:	09050513          	addi	a0,a0,144 # ffffffffc0202098 <commands+0x518>
ffffffffc0201010:	92aff0ef          	jal	ra,ffffffffc020013a <__panic>
            assert(tree[dpos*2+2].page->property==tree[dpos*2+2].size);
ffffffffc0201014:	00001697          	auipc	a3,0x1
ffffffffc0201018:	1ec68693          	addi	a3,a3,492 # ffffffffc0202200 <commands+0x680>
ffffffffc020101c:	00001617          	auipc	a2,0x1
ffffffffc0201020:	06460613          	addi	a2,a2,100 # ffffffffc0202080 <commands+0x500>
ffffffffc0201024:	0ed00593          	li	a1,237
ffffffffc0201028:	00001517          	auipc	a0,0x1
ffffffffc020102c:	07050513          	addi	a0,a0,112 # ffffffffc0202098 <commands+0x518>
ffffffffc0201030:	90aff0ef          	jal	ra,ffffffffc020013a <__panic>

ffffffffc0201034 <buddy_system_free_pages>:
buddy_system_free_pages(struct Page *base, size_t n) {
ffffffffc0201034:	1141                	addi	sp,sp,-16
ffffffffc0201036:	e406                	sd	ra,8(sp)
    assert(n > 0);
ffffffffc0201038:	0e058c63          	beqz	a1,ffffffffc0201130 <buddy_system_free_pages+0xfc>
ffffffffc020103c:	87ae                	mv	a5,a1
    int size=1;
ffffffffc020103e:	4685                	li	a3,1
    while(n>size)
ffffffffc0201040:	4585                	li	a1,1
ffffffffc0201042:	02850613          	addi	a2,a0,40
ffffffffc0201046:	00d78e63          	beq	a5,a3,ffffffffc0201062 <buddy_system_free_pages+0x2e>
		size=size<<1;	
ffffffffc020104a:	0016969b          	slliw	a3,a3,0x1
    while(n>size)
ffffffffc020104e:	85b6                	mv	a1,a3
ffffffffc0201050:	fef6ede3          	bltu	a3,a5,ffffffffc020104a <buddy_system_free_pages+0x16>
    for (; p != base + size; p ++) {
ffffffffc0201054:	00269613          	slli	a2,a3,0x2
ffffffffc0201058:	9636                	add	a2,a2,a3
ffffffffc020105a:	060e                	slli	a2,a2,0x3
ffffffffc020105c:	962a                	add	a2,a2,a0
ffffffffc020105e:	02c50163          	beq	a0,a2,ffffffffc0201080 <buddy_system_free_pages+0x4c>
ffffffffc0201062:	87aa                	mv	a5,a0
    return (((*(volatile unsigned long *)addr) >> nr) & 1);
ffffffffc0201064:	6798                	ld	a4,8(a5)
        assert(!PageReserved(p) && !PageProperty(p));
ffffffffc0201066:	8b05                	andi	a4,a4,1
ffffffffc0201068:	e745                	bnez	a4,ffffffffc0201110 <buddy_system_free_pages+0xdc>
ffffffffc020106a:	6798                	ld	a4,8(a5)
ffffffffc020106c:	8b09                	andi	a4,a4,2
ffffffffc020106e:	e34d                	bnez	a4,ffffffffc0201110 <buddy_system_free_pages+0xdc>
        p->flags = 0;
ffffffffc0201070:	0007b423          	sd	zero,8(a5)
ffffffffc0201074:	0007a023          	sw	zero,0(a5)
    for (; p != base + size; p ++) {
ffffffffc0201078:	02878793          	addi	a5,a5,40
ffffffffc020107c:	fec794e3          	bne	a5,a2,ffffffffc0201064 <buddy_system_free_pages+0x30>
    base->property=size;
ffffffffc0201080:	2681                	sext.w	a3,a3
ffffffffc0201082:	c914                	sw	a3,16(a0)
    __op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc0201084:	4789                	li	a5,2
ffffffffc0201086:	00850713          	addi	a4,a0,8
ffffffffc020108a:	40f7302f          	amoor.d	zero,a5,(a4)
    nr_free += size;
ffffffffc020108e:	00005617          	auipc	a2,0x5
ffffffffc0201092:	f8260613          	addi	a2,a2,-126 # ffffffffc0206010 <bsfree_area>
ffffffffc0201096:	4a18                	lw	a4,16(a2)
    return list->next == list;
ffffffffc0201098:	661c                	ld	a5,8(a2)
        list_add(&free_list, &(base->page_link));
ffffffffc020109a:	01850813          	addi	a6,a0,24
    nr_free += size;
ffffffffc020109e:	9eb9                	addw	a3,a3,a4
ffffffffc02010a0:	ca14                	sw	a3,16(a2)
    if (list_empty(&free_list)) {
ffffffffc02010a2:	04c78e63          	beq	a5,a2,ffffffffc02010fe <buddy_system_free_pages+0xca>
            struct Page* page = le2page(le, page_link);
ffffffffc02010a6:	fe878713          	addi	a4,a5,-24
ffffffffc02010aa:	00063883          	ld	a7,0(a2)
    if (list_empty(&free_list)) {
ffffffffc02010ae:	4681                	li	a3,0
            if (base < page) {
ffffffffc02010b0:	00e56a63          	bltu	a0,a4,ffffffffc02010c4 <buddy_system_free_pages+0x90>
    return listelm->next;
ffffffffc02010b4:	6798                	ld	a4,8(a5)
            } else if (list_next(le) == &free_list) {
ffffffffc02010b6:	02c70463          	beq	a4,a2,ffffffffc02010de <buddy_system_free_pages+0xaa>
    for (; p != base + size; p ++) {
ffffffffc02010ba:	87ba                	mv	a5,a4
            struct Page* page = le2page(le, page_link);
ffffffffc02010bc:	fe878713          	addi	a4,a5,-24
            if (base < page) {
ffffffffc02010c0:	fee57ae3          	bgeu	a0,a4,ffffffffc02010b4 <buddy_system_free_pages+0x80>
ffffffffc02010c4:	c299                	beqz	a3,ffffffffc02010ca <buddy_system_free_pages+0x96>
ffffffffc02010c6:	01163023          	sd	a7,0(a2)
    __list_add(elm, listelm->prev, listelm);
ffffffffc02010ca:	6398                	ld	a4,0(a5)
    prev->next = next->prev = elm;
ffffffffc02010cc:	0107b023          	sd	a6,0(a5)
}
ffffffffc02010d0:	60a2                	ld	ra,8(sp)
ffffffffc02010d2:	01073423          	sd	a6,8(a4)
    elm->next = next;
ffffffffc02010d6:	f11c                	sd	a5,32(a0)
    elm->prev = prev;
ffffffffc02010d8:	ed18                	sd	a4,24(a0)
ffffffffc02010da:	0141                	addi	sp,sp,16
    free_mem(base,size);
ffffffffc02010dc:	b52d                	j	ffffffffc0200f06 <free_mem>
    prev->next = next->prev = elm;
ffffffffc02010de:	0107b423          	sd	a6,8(a5)
    elm->next = next;
ffffffffc02010e2:	f110                	sd	a2,32(a0)
    return listelm->next;
ffffffffc02010e4:	6798                	ld	a4,8(a5)
    elm->prev = prev;
ffffffffc02010e6:	ed1c                	sd	a5,24(a0)
        while ((le = list_next(le)) != &free_list) {
ffffffffc02010e8:	00c70663          	beq	a4,a2,ffffffffc02010f4 <buddy_system_free_pages+0xc0>
    prev->next = next->prev = elm;
ffffffffc02010ec:	88c2                	mv	a7,a6
ffffffffc02010ee:	4685                	li	a3,1
    for (; p != base + size; p ++) {
ffffffffc02010f0:	87ba                	mv	a5,a4
ffffffffc02010f2:	b7e9                	j	ffffffffc02010bc <buddy_system_free_pages+0x88>
}
ffffffffc02010f4:	60a2                	ld	ra,8(sp)
ffffffffc02010f6:	01063023          	sd	a6,0(a2)
ffffffffc02010fa:	0141                	addi	sp,sp,16
    free_mem(base,size);
ffffffffc02010fc:	b529                	j	ffffffffc0200f06 <free_mem>
}
ffffffffc02010fe:	60a2                	ld	ra,8(sp)
ffffffffc0201100:	0107b023          	sd	a6,0(a5)
ffffffffc0201104:	0107b423          	sd	a6,8(a5)
    elm->next = next;
ffffffffc0201108:	f11c                	sd	a5,32(a0)
    elm->prev = prev;
ffffffffc020110a:	ed1c                	sd	a5,24(a0)
ffffffffc020110c:	0141                	addi	sp,sp,16
    free_mem(base,size);
ffffffffc020110e:	bbe5                	j	ffffffffc0200f06 <free_mem>
        assert(!PageReserved(p) && !PageProperty(p));
ffffffffc0201110:	00001697          	auipc	a3,0x1
ffffffffc0201114:	16068693          	addi	a3,a3,352 # ffffffffc0202270 <commands+0x6f0>
ffffffffc0201118:	00001617          	auipc	a2,0x1
ffffffffc020111c:	f6860613          	addi	a2,a2,-152 # ffffffffc0202080 <commands+0x500>
ffffffffc0201120:	14400593          	li	a1,324
ffffffffc0201124:	00001517          	auipc	a0,0x1
ffffffffc0201128:	f7450513          	addi	a0,a0,-140 # ffffffffc0202098 <commands+0x518>
ffffffffc020112c:	80eff0ef          	jal	ra,ffffffffc020013a <__panic>
    assert(n > 0);
ffffffffc0201130:	00001697          	auipc	a3,0x1
ffffffffc0201134:	0b868693          	addi	a3,a3,184 # ffffffffc02021e8 <commands+0x668>
ffffffffc0201138:	00001617          	auipc	a2,0x1
ffffffffc020113c:	f4860613          	addi	a2,a2,-184 # ffffffffc0202080 <commands+0x500>
ffffffffc0201140:	13c00593          	li	a1,316
ffffffffc0201144:	00001517          	auipc	a0,0x1
ffffffffc0201148:	f5450513          	addi	a0,a0,-172 # ffffffffc0202098 <commands+0x518>
ffffffffc020114c:	feffe0ef          	jal	ra,ffffffffc020013a <__panic>

ffffffffc0201150 <alloc_pages>:
>>>>>>> origin/main
#include <defs.h>
#include <intr.h>
#include <riscv.h>

static inline bool __intr_save(void) {
    if (read_csr(sstatus) & SSTATUS_SIE) {
<<<<<<< HEAD
ffffffffc0201214:	100027f3          	csrr	a5,sstatus
ffffffffc0201218:	8b89                	andi	a5,a5,2
ffffffffc020121a:	e799                	bnez	a5,ffffffffc0201228 <alloc_pages+0x14>
    struct Page *page = NULL;
    bool intr_flag;
    local_intr_save(intr_flag);
    //防治中断发生进行sstatus的使能位置位
    {
        page = pmm_manager->alloc_pages(n);
ffffffffc020121c:	00005797          	auipc	a5,0x5
ffffffffc0201220:	22c7b783          	ld	a5,556(a5) # ffffffffc0206448 <pmm_manager>
ffffffffc0201224:	6f9c                	ld	a5,24(a5)
ffffffffc0201226:	8782                	jr	a5
struct Page *alloc_pages(size_t n) {
ffffffffc0201228:	1141                	addi	sp,sp,-16
ffffffffc020122a:	e406                	sd	ra,8(sp)
ffffffffc020122c:	e022                	sd	s0,0(sp)
ffffffffc020122e:	842a                	mv	s0,a0
        intr_disable();
ffffffffc0201230:	a2eff0ef          	jal	ra,ffffffffc020045e <intr_disable>
        page = pmm_manager->alloc_pages(n);
ffffffffc0201234:	00005797          	auipc	a5,0x5
ffffffffc0201238:	2147b783          	ld	a5,532(a5) # ffffffffc0206448 <pmm_manager>
ffffffffc020123c:	6f9c                	ld	a5,24(a5)
ffffffffc020123e:	8522                	mv	a0,s0
ffffffffc0201240:	9782                	jalr	a5
ffffffffc0201242:	842a                	mv	s0,a0
=======
ffffffffc0201150:	100027f3          	csrr	a5,sstatus
ffffffffc0201154:	8b89                	andi	a5,a5,2
ffffffffc0201156:	e799                	bnez	a5,ffffffffc0201164 <alloc_pages+0x14>
struct Page *alloc_pages(size_t n) {
    struct Page *page = NULL;
    bool intr_flag;
    local_intr_save(intr_flag);
    {
        page = pmm_manager->alloc_pages(n);
ffffffffc0201158:	00005797          	auipc	a5,0x5
ffffffffc020115c:	3087b783          	ld	a5,776(a5) # ffffffffc0206460 <pmm_manager>
ffffffffc0201160:	6f9c                	ld	a5,24(a5)
ffffffffc0201162:	8782                	jr	a5
struct Page *alloc_pages(size_t n) {
ffffffffc0201164:	1141                	addi	sp,sp,-16
ffffffffc0201166:	e406                	sd	ra,8(sp)
ffffffffc0201168:	e022                	sd	s0,0(sp)
ffffffffc020116a:	842a                	mv	s0,a0
        intr_disable();
ffffffffc020116c:	af2ff0ef          	jal	ra,ffffffffc020045e <intr_disable>
        page = pmm_manager->alloc_pages(n);
ffffffffc0201170:	00005797          	auipc	a5,0x5
ffffffffc0201174:	2f07b783          	ld	a5,752(a5) # ffffffffc0206460 <pmm_manager>
ffffffffc0201178:	6f9c                	ld	a5,24(a5)
ffffffffc020117a:	8522                	mv	a0,s0
ffffffffc020117c:	9782                	jalr	a5
ffffffffc020117e:	842a                	mv	s0,a0
>>>>>>> origin/main
    return 0;
}

static inline void __intr_restore(bool flag) {
    if (flag) {
        intr_enable();
<<<<<<< HEAD
ffffffffc0201244:	a14ff0ef          	jal	ra,ffffffffc0200458 <intr_enable>
    }
    local_intr_restore(intr_flag);
    //使能位恢复，使其能够处理中断
    return page;
}
ffffffffc0201248:	60a2                	ld	ra,8(sp)
ffffffffc020124a:	8522                	mv	a0,s0
ffffffffc020124c:	6402                	ld	s0,0(sp)
ffffffffc020124e:	0141                	addi	sp,sp,16
ffffffffc0201250:	8082                	ret

ffffffffc0201252 <free_pages>:
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0201252:	100027f3          	csrr	a5,sstatus
ffffffffc0201256:	8b89                	andi	a5,a5,2
ffffffffc0201258:	e799                	bnez	a5,ffffffffc0201266 <free_pages+0x14>
=======
ffffffffc0201180:	ad8ff0ef          	jal	ra,ffffffffc0200458 <intr_enable>
    }
    local_intr_restore(intr_flag);
    return page;
}
ffffffffc0201184:	60a2                	ld	ra,8(sp)
ffffffffc0201186:	8522                	mv	a0,s0
ffffffffc0201188:	6402                	ld	s0,0(sp)
ffffffffc020118a:	0141                	addi	sp,sp,16
ffffffffc020118c:	8082                	ret

ffffffffc020118e <free_pages>:
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc020118e:	100027f3          	csrr	a5,sstatus
ffffffffc0201192:	8b89                	andi	a5,a5,2
ffffffffc0201194:	e799                	bnez	a5,ffffffffc02011a2 <free_pages+0x14>
>>>>>>> origin/main
// free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory
void free_pages(struct Page *base, size_t n) {
    bool intr_flag;
    local_intr_save(intr_flag);
    {
        pmm_manager->free_pages(base, n);
<<<<<<< HEAD
ffffffffc020125a:	00005797          	auipc	a5,0x5
ffffffffc020125e:	1ee7b783          	ld	a5,494(a5) # ffffffffc0206448 <pmm_manager>
ffffffffc0201262:	739c                	ld	a5,32(a5)
ffffffffc0201264:	8782                	jr	a5
void free_pages(struct Page *base, size_t n) {
ffffffffc0201266:	1101                	addi	sp,sp,-32
ffffffffc0201268:	ec06                	sd	ra,24(sp)
ffffffffc020126a:	e822                	sd	s0,16(sp)
ffffffffc020126c:	e426                	sd	s1,8(sp)
ffffffffc020126e:	842a                	mv	s0,a0
ffffffffc0201270:	84ae                	mv	s1,a1
        intr_disable();
ffffffffc0201272:	9ecff0ef          	jal	ra,ffffffffc020045e <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc0201276:	00005797          	auipc	a5,0x5
ffffffffc020127a:	1d27b783          	ld	a5,466(a5) # ffffffffc0206448 <pmm_manager>
ffffffffc020127e:	739c                	ld	a5,32(a5)
ffffffffc0201280:	85a6                	mv	a1,s1
ffffffffc0201282:	8522                	mv	a0,s0
ffffffffc0201284:	9782                	jalr	a5
    }
    local_intr_restore(intr_flag);
}
ffffffffc0201286:	6442                	ld	s0,16(sp)
ffffffffc0201288:	60e2                	ld	ra,24(sp)
ffffffffc020128a:	64a2                	ld	s1,8(sp)
ffffffffc020128c:	6105                	addi	sp,sp,32
        intr_enable();
ffffffffc020128e:	9caff06f          	j	ffffffffc0200458 <intr_enable>

ffffffffc0201292 <nr_free_pages>:
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0201292:	100027f3          	csrr	a5,sstatus
ffffffffc0201296:	8b89                	andi	a5,a5,2
ffffffffc0201298:	e799                	bnez	a5,ffffffffc02012a6 <nr_free_pages+0x14>
    size_t ret;
    bool intr_flag;
    //该变量用于保存当前的中断使能位
    local_intr_save(intr_flag);
    {
        ret = pmm_manager->nr_free_pages();
ffffffffc020129a:	00005797          	auipc	a5,0x5
ffffffffc020129e:	1ae7b783          	ld	a5,430(a5) # ffffffffc0206448 <pmm_manager>
ffffffffc02012a2:	779c                	ld	a5,40(a5)
ffffffffc02012a4:	8782                	jr	a5
size_t nr_free_pages(void) {
ffffffffc02012a6:	1141                	addi	sp,sp,-16
ffffffffc02012a8:	e406                	sd	ra,8(sp)
ffffffffc02012aa:	e022                	sd	s0,0(sp)
        intr_disable();
ffffffffc02012ac:	9b2ff0ef          	jal	ra,ffffffffc020045e <intr_disable>
        ret = pmm_manager->nr_free_pages();
ffffffffc02012b0:	00005797          	auipc	a5,0x5
ffffffffc02012b4:	1987b783          	ld	a5,408(a5) # ffffffffc0206448 <pmm_manager>
ffffffffc02012b8:	779c                	ld	a5,40(a5)
ffffffffc02012ba:	9782                	jalr	a5
ffffffffc02012bc:	842a                	mv	s0,a0
        intr_enable();
ffffffffc02012be:	99aff0ef          	jal	ra,ffffffffc0200458 <intr_enable>
=======
ffffffffc0201196:	00005797          	auipc	a5,0x5
ffffffffc020119a:	2ca7b783          	ld	a5,714(a5) # ffffffffc0206460 <pmm_manager>
ffffffffc020119e:	739c                	ld	a5,32(a5)
ffffffffc02011a0:	8782                	jr	a5
void free_pages(struct Page *base, size_t n) {
ffffffffc02011a2:	1101                	addi	sp,sp,-32
ffffffffc02011a4:	ec06                	sd	ra,24(sp)
ffffffffc02011a6:	e822                	sd	s0,16(sp)
ffffffffc02011a8:	e426                	sd	s1,8(sp)
ffffffffc02011aa:	842a                	mv	s0,a0
ffffffffc02011ac:	84ae                	mv	s1,a1
        intr_disable();
ffffffffc02011ae:	ab0ff0ef          	jal	ra,ffffffffc020045e <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc02011b2:	00005797          	auipc	a5,0x5
ffffffffc02011b6:	2ae7b783          	ld	a5,686(a5) # ffffffffc0206460 <pmm_manager>
ffffffffc02011ba:	739c                	ld	a5,32(a5)
ffffffffc02011bc:	85a6                	mv	a1,s1
ffffffffc02011be:	8522                	mv	a0,s0
ffffffffc02011c0:	9782                	jalr	a5
    }
    local_intr_restore(intr_flag);
}
ffffffffc02011c2:	6442                	ld	s0,16(sp)
ffffffffc02011c4:	60e2                	ld	ra,24(sp)
ffffffffc02011c6:	64a2                	ld	s1,8(sp)
ffffffffc02011c8:	6105                	addi	sp,sp,32
        intr_enable();
ffffffffc02011ca:	a8eff06f          	j	ffffffffc0200458 <intr_enable>

ffffffffc02011ce <nr_free_pages>:
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc02011ce:	100027f3          	csrr	a5,sstatus
ffffffffc02011d2:	8b89                	andi	a5,a5,2
ffffffffc02011d4:	e799                	bnez	a5,ffffffffc02011e2 <nr_free_pages+0x14>
size_t nr_free_pages(void) {
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
    {
        ret = pmm_manager->nr_free_pages();
ffffffffc02011d6:	00005797          	auipc	a5,0x5
ffffffffc02011da:	28a7b783          	ld	a5,650(a5) # ffffffffc0206460 <pmm_manager>
ffffffffc02011de:	779c                	ld	a5,40(a5)
ffffffffc02011e0:	8782                	jr	a5
size_t nr_free_pages(void) {
ffffffffc02011e2:	1141                	addi	sp,sp,-16
ffffffffc02011e4:	e406                	sd	ra,8(sp)
ffffffffc02011e6:	e022                	sd	s0,0(sp)
        intr_disable();
ffffffffc02011e8:	a76ff0ef          	jal	ra,ffffffffc020045e <intr_disable>
        ret = pmm_manager->nr_free_pages();
ffffffffc02011ec:	00005797          	auipc	a5,0x5
ffffffffc02011f0:	2747b783          	ld	a5,628(a5) # ffffffffc0206460 <pmm_manager>
ffffffffc02011f4:	779c                	ld	a5,40(a5)
ffffffffc02011f6:	9782                	jalr	a5
ffffffffc02011f8:	842a                	mv	s0,a0
        intr_enable();
ffffffffc02011fa:	a5eff0ef          	jal	ra,ffffffffc0200458 <intr_enable>
>>>>>>> origin/main
    }
    local_intr_restore(intr_flag);
    return ret;
}
<<<<<<< HEAD
ffffffffc02012c2:	60a2                	ld	ra,8(sp)
ffffffffc02012c4:	8522                	mv	a0,s0
ffffffffc02012c6:	6402                	ld	s0,0(sp)
ffffffffc02012c8:	0141                	addi	sp,sp,16
ffffffffc02012ca:	8082                	ret

ffffffffc02012cc <pmm_init>:
    pmm_manager = &best_fit_pmm_manager;
ffffffffc02012cc:	00001797          	auipc	a5,0x1
ffffffffc02012d0:	18478793          	addi	a5,a5,388 # ffffffffc0202450 <best_fit_pmm_manager>
    cprintf("memory management: %s\n", pmm_manager->name);
ffffffffc02012d4:	638c                	ld	a1,0(a5)
        //在这里进行初始化
    }
}

/* pmm_init - initialize the physical memory management */
void pmm_init(void) {
ffffffffc02012d6:	1101                	addi	sp,sp,-32
ffffffffc02012d8:	e426                	sd	s1,8(sp)
    cprintf("memory management: %s\n", pmm_manager->name);
ffffffffc02012da:	00001517          	auipc	a0,0x1
ffffffffc02012de:	1ae50513          	addi	a0,a0,430 # ffffffffc0202488 <best_fit_pmm_manager+0x38>
    pmm_manager = &best_fit_pmm_manager;
ffffffffc02012e2:	00005497          	auipc	s1,0x5
ffffffffc02012e6:	16648493          	addi	s1,s1,358 # ffffffffc0206448 <pmm_manager>
void pmm_init(void) {
ffffffffc02012ea:	ec06                	sd	ra,24(sp)
ffffffffc02012ec:	e822                	sd	s0,16(sp)
    pmm_manager = &best_fit_pmm_manager;
ffffffffc02012ee:	e09c                	sd	a5,0(s1)
    cprintf("memory management: %s\n", pmm_manager->name);
ffffffffc02012f0:	dc3fe0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    pmm_manager->init();
ffffffffc02012f4:	609c                	ld	a5,0(s1)
    va_pa_offset = PHYSICAL_MEMORY_OFFSET;
ffffffffc02012f6:	00005417          	auipc	s0,0x5
ffffffffc02012fa:	16a40413          	addi	s0,s0,362 # ffffffffc0206460 <va_pa_offset>
    pmm_manager->init();
ffffffffc02012fe:	679c                	ld	a5,8(a5)
ffffffffc0201300:	9782                	jalr	a5
    va_pa_offset = PHYSICAL_MEMORY_OFFSET;
ffffffffc0201302:	57f5                	li	a5,-3
ffffffffc0201304:	07fa                	slli	a5,a5,0x1e
    cprintf("physcial memory map:\n");
ffffffffc0201306:	00001517          	auipc	a0,0x1
ffffffffc020130a:	19a50513          	addi	a0,a0,410 # ffffffffc02024a0 <best_fit_pmm_manager+0x50>
    va_pa_offset = PHYSICAL_MEMORY_OFFSET;
ffffffffc020130e:	e01c                	sd	a5,0(s0)
    cprintf("physcial memory map:\n");
ffffffffc0201310:	da3fe0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    cprintf("  memory: 0x%016lx, [0x%016lx, 0x%016lx].\n", mem_size, mem_begin,
ffffffffc0201314:	46c5                	li	a3,17
ffffffffc0201316:	06ee                	slli	a3,a3,0x1b
ffffffffc0201318:	40100613          	li	a2,1025
ffffffffc020131c:	16fd                	addi	a3,a3,-1
ffffffffc020131e:	07e005b7          	lui	a1,0x7e00
ffffffffc0201322:	0656                	slli	a2,a2,0x15
ffffffffc0201324:	00001517          	auipc	a0,0x1
ffffffffc0201328:	19450513          	addi	a0,a0,404 # ffffffffc02024b8 <best_fit_pmm_manager+0x68>
ffffffffc020132c:	d87fe0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
ffffffffc0201330:	777d                	lui	a4,0xfffff
ffffffffc0201332:	00006797          	auipc	a5,0x6
ffffffffc0201336:	13d78793          	addi	a5,a5,317 # ffffffffc020746f <end+0xfff>
ffffffffc020133a:	8ff9                	and	a5,a5,a4
    npage = maxpa / PGSIZE;
ffffffffc020133c:	00005517          	auipc	a0,0x5
ffffffffc0201340:	0fc50513          	addi	a0,a0,252 # ffffffffc0206438 <npage>
ffffffffc0201344:	00088737          	lui	a4,0x88
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
ffffffffc0201348:	00005597          	auipc	a1,0x5
ffffffffc020134c:	0f858593          	addi	a1,a1,248 # ffffffffc0206440 <pages>
    npage = maxpa / PGSIZE;
ffffffffc0201350:	e118                	sd	a4,0(a0)
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
ffffffffc0201352:	e19c                	sd	a5,0(a1)
ffffffffc0201354:	4681                	li	a3,0
    for (size_t i = 0; i < npage - nbase; i++) {
ffffffffc0201356:	4701                	li	a4,0
ffffffffc0201358:	4885                	li	a7,1
ffffffffc020135a:	fff80837          	lui	a6,0xfff80
ffffffffc020135e:	a011                	j	ffffffffc0201362 <pmm_init+0x96>
        SetPageReserved(pages + i);
ffffffffc0201360:	619c                	ld	a5,0(a1)
ffffffffc0201362:	97b6                	add	a5,a5,a3
ffffffffc0201364:	07a1                	addi	a5,a5,8
ffffffffc0201366:	4117b02f          	amoor.d	zero,a7,(a5)
    for (size_t i = 0; i < npage - nbase; i++) {
ffffffffc020136a:	611c                	ld	a5,0(a0)
ffffffffc020136c:	0705                	addi	a4,a4,1
ffffffffc020136e:	02868693          	addi	a3,a3,40
ffffffffc0201372:	01078633          	add	a2,a5,a6
ffffffffc0201376:	fec765e3          	bltu	a4,a2,ffffffffc0201360 <pmm_init+0x94>
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc020137a:	6190                	ld	a2,0(a1)
ffffffffc020137c:	00279713          	slli	a4,a5,0x2
ffffffffc0201380:	973e                	add	a4,a4,a5
ffffffffc0201382:	fec006b7          	lui	a3,0xfec00
ffffffffc0201386:	070e                	slli	a4,a4,0x3
ffffffffc0201388:	96b2                	add	a3,a3,a2
ffffffffc020138a:	96ba                	add	a3,a3,a4
ffffffffc020138c:	c0200737          	lui	a4,0xc0200
ffffffffc0201390:	08e6ef63          	bltu	a3,a4,ffffffffc020142e <pmm_init+0x162>
ffffffffc0201394:	6018                	ld	a4,0(s0)
    if (freemem < mem_end) {
ffffffffc0201396:	45c5                	li	a1,17
ffffffffc0201398:	05ee                	slli	a1,a1,0x1b
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc020139a:	8e99                	sub	a3,a3,a4
    if (freemem < mem_end) {
ffffffffc020139c:	04b6e863          	bltu	a3,a1,ffffffffc02013ec <pmm_init+0x120>
=======
ffffffffc02011fe:	60a2                	ld	ra,8(sp)
ffffffffc0201200:	8522                	mv	a0,s0
ffffffffc0201202:	6402                	ld	s0,0(sp)
ffffffffc0201204:	0141                	addi	sp,sp,16
ffffffffc0201206:	8082                	ret

ffffffffc0201208 <pmm_init>:
    pmm_manager = &buddy_system_pmm_manager;
ffffffffc0201208:	00001797          	auipc	a5,0x1
ffffffffc020120c:	0b078793          	addi	a5,a5,176 # ffffffffc02022b8 <buddy_system_pmm_manager>
    cprintf("memory management: %s\n", pmm_manager->name);
ffffffffc0201210:	638c                	ld	a1,0(a5)




/* pmm_init - initialize the physical memory management */
void pmm_init(void) {
ffffffffc0201212:	1101                	addi	sp,sp,-32
ffffffffc0201214:	e822                	sd	s0,16(sp)
    cprintf("memory management: %s\n", pmm_manager->name);
ffffffffc0201216:	00001517          	auipc	a0,0x1
ffffffffc020121a:	0da50513          	addi	a0,a0,218 # ffffffffc02022f0 <buddy_system_pmm_manager+0x38>
    pmm_manager = &buddy_system_pmm_manager;
ffffffffc020121e:	00005417          	auipc	s0,0x5
ffffffffc0201222:	24240413          	addi	s0,s0,578 # ffffffffc0206460 <pmm_manager>
void pmm_init(void) {
ffffffffc0201226:	ec06                	sd	ra,24(sp)
ffffffffc0201228:	e426                	sd	s1,8(sp)
    pmm_manager = &buddy_system_pmm_manager;
ffffffffc020122a:	e01c                	sd	a5,0(s0)
    cprintf("memory management: %s\n", pmm_manager->name);
ffffffffc020122c:	e87fe0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    pmm_manager->init();
ffffffffc0201230:	601c                	ld	a5,0(s0)
    va_pa_offset = PHYSICAL_MEMORY_OFFSET;
ffffffffc0201232:	00005497          	auipc	s1,0x5
ffffffffc0201236:	24648493          	addi	s1,s1,582 # ffffffffc0206478 <va_pa_offset>
    pmm_manager->init();
ffffffffc020123a:	679c                	ld	a5,8(a5)
ffffffffc020123c:	9782                	jalr	a5
    // Now the first_fit/best_fit/worst_fit/buddy_system pmm are available.
    init_pmm_manager();

    // detect physical memory space, reserve already used memory,
    // then use pmm->init_memmap to create free page list
    cprintf("init begin\n");
ffffffffc020123e:	00001517          	auipc	a0,0x1
ffffffffc0201242:	0ca50513          	addi	a0,a0,202 # ffffffffc0202308 <buddy_system_pmm_manager+0x50>
ffffffffc0201246:	e6dfe0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    va_pa_offset = PHYSICAL_MEMORY_OFFSET;
ffffffffc020124a:	57f5                	li	a5,-3
ffffffffc020124c:	07fa                	slli	a5,a5,0x1e
    cprintf("physcial memory map:\n");
ffffffffc020124e:	00001517          	auipc	a0,0x1
ffffffffc0201252:	0ca50513          	addi	a0,a0,202 # ffffffffc0202318 <buddy_system_pmm_manager+0x60>
    va_pa_offset = PHYSICAL_MEMORY_OFFSET;
ffffffffc0201256:	e09c                	sd	a5,0(s1)
    cprintf("physcial memory map:\n");
ffffffffc0201258:	e5bfe0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    cprintf("  memory: 0x%016lx, [0x%016lx, 0x%016lx].\n", mem_size, mem_begin,
ffffffffc020125c:	46c5                	li	a3,17
ffffffffc020125e:	06ee                	slli	a3,a3,0x1b
ffffffffc0201260:	40100613          	li	a2,1025
ffffffffc0201264:	16fd                	addi	a3,a3,-1
ffffffffc0201266:	07e005b7          	lui	a1,0x7e00
ffffffffc020126a:	0656                	slli	a2,a2,0x15
ffffffffc020126c:	00001517          	auipc	a0,0x1
ffffffffc0201270:	0c450513          	addi	a0,a0,196 # ffffffffc0202330 <buddy_system_pmm_manager+0x78>
ffffffffc0201274:	e3ffe0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
ffffffffc0201278:	777d                	lui	a4,0xfffff
ffffffffc020127a:	00006797          	auipc	a5,0x6
ffffffffc020127e:	20d78793          	addi	a5,a5,525 # ffffffffc0207487 <end+0xfff>
ffffffffc0201282:	8ff9                	and	a5,a5,a4
    npage = maxpa / PGSIZE;
ffffffffc0201284:	00005517          	auipc	a0,0x5
ffffffffc0201288:	1cc50513          	addi	a0,a0,460 # ffffffffc0206450 <npage>
ffffffffc020128c:	00088737          	lui	a4,0x88
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
ffffffffc0201290:	00005597          	auipc	a1,0x5
ffffffffc0201294:	1c858593          	addi	a1,a1,456 # ffffffffc0206458 <pages>
    npage = maxpa / PGSIZE;
ffffffffc0201298:	e118                	sd	a4,0(a0)
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
ffffffffc020129a:	e19c                	sd	a5,0(a1)
ffffffffc020129c:	4681                	li	a3,0
    for (size_t i = 0; i < npage - nbase; i++) {
ffffffffc020129e:	4701                	li	a4,0
ffffffffc02012a0:	4885                	li	a7,1
ffffffffc02012a2:	fff80837          	lui	a6,0xfff80
ffffffffc02012a6:	a011                	j	ffffffffc02012aa <pmm_init+0xa2>
        SetPageReserved(pages + i);
ffffffffc02012a8:	619c                	ld	a5,0(a1)
ffffffffc02012aa:	97b6                	add	a5,a5,a3
ffffffffc02012ac:	07a1                	addi	a5,a5,8
ffffffffc02012ae:	4117b02f          	amoor.d	zero,a7,(a5)
    for (size_t i = 0; i < npage - nbase; i++) {
ffffffffc02012b2:	611c                	ld	a5,0(a0)
ffffffffc02012b4:	0705                	addi	a4,a4,1
ffffffffc02012b6:	02868693          	addi	a3,a3,40
ffffffffc02012ba:	01078633          	add	a2,a5,a6
ffffffffc02012be:	fec765e3          	bltu	a4,a2,ffffffffc02012a8 <pmm_init+0xa0>
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc02012c2:	6190                	ld	a2,0(a1)
ffffffffc02012c4:	00279693          	slli	a3,a5,0x2
ffffffffc02012c8:	96be                	add	a3,a3,a5
ffffffffc02012ca:	fec00737          	lui	a4,0xfec00
ffffffffc02012ce:	9732                	add	a4,a4,a2
ffffffffc02012d0:	068e                	slli	a3,a3,0x3
ffffffffc02012d2:	96ba                	add	a3,a3,a4
ffffffffc02012d4:	c0200737          	lui	a4,0xc0200
ffffffffc02012d8:	0ae6e563          	bltu	a3,a4,ffffffffc0201382 <pmm_init+0x17a>
ffffffffc02012dc:	6098                	ld	a4,0(s1)
    if (freemem < mem_end) {
ffffffffc02012de:	45c5                	li	a1,17
ffffffffc02012e0:	05ee                	slli	a1,a1,0x1b
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc02012e2:	8e99                	sub	a3,a3,a4
    if (freemem < mem_end) {
ffffffffc02012e4:	04b6ee63          	bltu	a3,a1,ffffffffc0201340 <pmm_init+0x138>
    page_init();
    cprintf("init end\n");
ffffffffc02012e8:	00001517          	auipc	a0,0x1
ffffffffc02012ec:	0e050513          	addi	a0,a0,224 # ffffffffc02023c8 <buddy_system_pmm_manager+0x110>
ffffffffc02012f0:	dc3fe0ef          	jal	ra,ffffffffc02000b2 <cprintf>
>>>>>>> origin/main
    satp_physical = PADDR(satp_virtual);
    cprintf("satp virtual address: 0x%016lx\nsatp physical address: 0x%016lx\n", satp_virtual, satp_physical);
}

static void check_alloc_page(void) {
    pmm_manager->check();
<<<<<<< HEAD
ffffffffc02013a0:	609c                	ld	a5,0(s1)
ffffffffc02013a2:	7b9c                	ld	a5,48(a5)
ffffffffc02013a4:	9782                	jalr	a5
    cprintf("check_alloc_page() succeeded!\n");
ffffffffc02013a6:	00001517          	auipc	a0,0x1
ffffffffc02013aa:	1aa50513          	addi	a0,a0,426 # ffffffffc0202550 <best_fit_pmm_manager+0x100>
ffffffffc02013ae:	d05fe0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    satp_virtual = (pte_t*)boot_page_table_sv39;
ffffffffc02013b2:	00004597          	auipc	a1,0x4
ffffffffc02013b6:	c4e58593          	addi	a1,a1,-946 # ffffffffc0205000 <boot_page_table_sv39>
ffffffffc02013ba:	00005797          	auipc	a5,0x5
ffffffffc02013be:	08b7bf23          	sd	a1,158(a5) # ffffffffc0206458 <satp_virtual>
    satp_physical = PADDR(satp_virtual);
ffffffffc02013c2:	c02007b7          	lui	a5,0xc0200
ffffffffc02013c6:	08f5e063          	bltu	a1,a5,ffffffffc0201446 <pmm_init+0x17a>
ffffffffc02013ca:	6010                	ld	a2,0(s0)
}
ffffffffc02013cc:	6442                	ld	s0,16(sp)
ffffffffc02013ce:	60e2                	ld	ra,24(sp)
ffffffffc02013d0:	64a2                	ld	s1,8(sp)
    satp_physical = PADDR(satp_virtual);
ffffffffc02013d2:	40c58633          	sub	a2,a1,a2
ffffffffc02013d6:	00005797          	auipc	a5,0x5
ffffffffc02013da:	06c7bd23          	sd	a2,122(a5) # ffffffffc0206450 <satp_physical>
    cprintf("satp virtual address: 0x%016lx\nsatp physical address: 0x%016lx\n", satp_virtual, satp_physical);
ffffffffc02013de:	00001517          	auipc	a0,0x1
ffffffffc02013e2:	19250513          	addi	a0,a0,402 # ffffffffc0202570 <best_fit_pmm_manager+0x120>
}
ffffffffc02013e6:	6105                	addi	sp,sp,32
    cprintf("satp virtual address: 0x%016lx\nsatp physical address: 0x%016lx\n", satp_virtual, satp_physical);
ffffffffc02013e8:	ccbfe06f          	j	ffffffffc02000b2 <cprintf>
    mem_begin = ROUNDUP(freemem, PGSIZE);
ffffffffc02013ec:	6705                	lui	a4,0x1
ffffffffc02013ee:	177d                	addi	a4,a4,-1
ffffffffc02013f0:	96ba                	add	a3,a3,a4
ffffffffc02013f2:	777d                	lui	a4,0xfffff
ffffffffc02013f4:	8ef9                	and	a3,a3,a4
    page->ref -= 1;
    return page->ref;
}
//引用次数减1
static inline struct Page *pa2page(uintptr_t pa) {
    if (PPN(pa) >= npage) {
ffffffffc02013f6:	00c6d513          	srli	a0,a3,0xc
ffffffffc02013fa:	00f57e63          	bgeu	a0,a5,ffffffffc0201416 <pmm_init+0x14a>
    pmm_manager->init_memmap(base, n);
ffffffffc02013fe:	609c                	ld	a5,0(s1)
        panic("pa2page called with invalid pa");
    }
    return &pages[PPN(pa) - nbase];
ffffffffc0201400:	982a                	add	a6,a6,a0
ffffffffc0201402:	00281513          	slli	a0,a6,0x2
ffffffffc0201406:	9542                	add	a0,a0,a6
ffffffffc0201408:	6b9c                	ld	a5,16(a5)
        init_memmap(pa2page(mem_begin), (mem_end - mem_begin) / PGSIZE);
ffffffffc020140a:	8d95                	sub	a1,a1,a3
ffffffffc020140c:	050e                	slli	a0,a0,0x3
    pmm_manager->init_memmap(base, n);
ffffffffc020140e:	81b1                	srli	a1,a1,0xc
ffffffffc0201410:	9532                	add	a0,a0,a2
ffffffffc0201412:	9782                	jalr	a5
}
ffffffffc0201414:	b771                	j	ffffffffc02013a0 <pmm_init+0xd4>
        panic("pa2page called with invalid pa");
ffffffffc0201416:	00001617          	auipc	a2,0x1
ffffffffc020141a:	10a60613          	addi	a2,a2,266 # ffffffffc0202520 <best_fit_pmm_manager+0xd0>
ffffffffc020141e:	06c00593          	li	a1,108
ffffffffc0201422:	00001517          	auipc	a0,0x1
ffffffffc0201426:	11e50513          	addi	a0,a0,286 # ffffffffc0202540 <best_fit_pmm_manager+0xf0>
ffffffffc020142a:	f83fe0ef          	jal	ra,ffffffffc02003ac <__panic>
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc020142e:	00001617          	auipc	a2,0x1
ffffffffc0201432:	0ba60613          	addi	a2,a2,186 # ffffffffc02024e8 <best_fit_pmm_manager+0x98>
ffffffffc0201436:	08600593          	li	a1,134
ffffffffc020143a:	00001517          	auipc	a0,0x1
ffffffffc020143e:	0d650513          	addi	a0,a0,214 # ffffffffc0202510 <best_fit_pmm_manager+0xc0>
ffffffffc0201442:	f6bfe0ef          	jal	ra,ffffffffc02003ac <__panic>
    satp_physical = PADDR(satp_virtual);
ffffffffc0201446:	86ae                	mv	a3,a1
ffffffffc0201448:	00001617          	auipc	a2,0x1
ffffffffc020144c:	0a060613          	addi	a2,a2,160 # ffffffffc02024e8 <best_fit_pmm_manager+0x98>
ffffffffc0201450:	0a300593          	li	a1,163
ffffffffc0201454:	00001517          	auipc	a0,0x1
ffffffffc0201458:	0bc50513          	addi	a0,a0,188 # ffffffffc0202510 <best_fit_pmm_manager+0xc0>
ffffffffc020145c:	f51fe0ef          	jal	ra,ffffffffc02003ac <__panic>

ffffffffc0201460 <printnum>:
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
    unsigned long long result = num;
    unsigned mod = do_div(result, base);
ffffffffc0201460:	02069813          	slli	a6,a3,0x20
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc0201464:	7179                	addi	sp,sp,-48
    unsigned mod = do_div(result, base);
ffffffffc0201466:	02085813          	srli	a6,a6,0x20
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc020146a:	e052                	sd	s4,0(sp)
    unsigned mod = do_div(result, base);
ffffffffc020146c:	03067a33          	remu	s4,a2,a6
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc0201470:	f022                	sd	s0,32(sp)
ffffffffc0201472:	ec26                	sd	s1,24(sp)
ffffffffc0201474:	e84a                	sd	s2,16(sp)
ffffffffc0201476:	f406                	sd	ra,40(sp)
ffffffffc0201478:	e44e                	sd	s3,8(sp)
ffffffffc020147a:	84aa                	mv	s1,a0
ffffffffc020147c:	892e                	mv	s2,a1
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
ffffffffc020147e:	fff7041b          	addiw	s0,a4,-1
    unsigned mod = do_div(result, base);
ffffffffc0201482:	2a01                	sext.w	s4,s4
    if (num >= base) {
ffffffffc0201484:	03067e63          	bgeu	a2,a6,ffffffffc02014c0 <printnum+0x60>
ffffffffc0201488:	89be                	mv	s3,a5
        while (-- width > 0)
ffffffffc020148a:	00805763          	blez	s0,ffffffffc0201498 <printnum+0x38>
ffffffffc020148e:	347d                	addiw	s0,s0,-1
            putch(padc, putdat);
ffffffffc0201490:	85ca                	mv	a1,s2
ffffffffc0201492:	854e                	mv	a0,s3
ffffffffc0201494:	9482                	jalr	s1
        while (-- width > 0)
ffffffffc0201496:	fc65                	bnez	s0,ffffffffc020148e <printnum+0x2e>
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
ffffffffc0201498:	1a02                	slli	s4,s4,0x20
ffffffffc020149a:	00001797          	auipc	a5,0x1
ffffffffc020149e:	11678793          	addi	a5,a5,278 # ffffffffc02025b0 <best_fit_pmm_manager+0x160>
ffffffffc02014a2:	020a5a13          	srli	s4,s4,0x20
ffffffffc02014a6:	9a3e                	add	s4,s4,a5
}
ffffffffc02014a8:	7402                	ld	s0,32(sp)
    putch("0123456789abcdef"[mod], putdat);
ffffffffc02014aa:	000a4503          	lbu	a0,0(s4)
}
ffffffffc02014ae:	70a2                	ld	ra,40(sp)
ffffffffc02014b0:	69a2                	ld	s3,8(sp)
ffffffffc02014b2:	6a02                	ld	s4,0(sp)
    putch("0123456789abcdef"[mod], putdat);
ffffffffc02014b4:	85ca                	mv	a1,s2
ffffffffc02014b6:	87a6                	mv	a5,s1
}
ffffffffc02014b8:	6942                	ld	s2,16(sp)
ffffffffc02014ba:	64e2                	ld	s1,24(sp)
ffffffffc02014bc:	6145                	addi	sp,sp,48
    putch("0123456789abcdef"[mod], putdat);
ffffffffc02014be:	8782                	jr	a5
        printnum(putch, putdat, result, base, width - 1, padc);
ffffffffc02014c0:	03065633          	divu	a2,a2,a6
ffffffffc02014c4:	8722                	mv	a4,s0
ffffffffc02014c6:	f9bff0ef          	jal	ra,ffffffffc0201460 <printnum>
ffffffffc02014ca:	b7f9                	j	ffffffffc0201498 <printnum+0x38>

ffffffffc02014cc <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
ffffffffc02014cc:	7119                	addi	sp,sp,-128
ffffffffc02014ce:	f4a6                	sd	s1,104(sp)
ffffffffc02014d0:	f0ca                	sd	s2,96(sp)
ffffffffc02014d2:	ecce                	sd	s3,88(sp)
ffffffffc02014d4:	e8d2                	sd	s4,80(sp)
ffffffffc02014d6:	e4d6                	sd	s5,72(sp)
ffffffffc02014d8:	e0da                	sd	s6,64(sp)
ffffffffc02014da:	fc5e                	sd	s7,56(sp)
ffffffffc02014dc:	f06a                	sd	s10,32(sp)
ffffffffc02014de:	fc86                	sd	ra,120(sp)
ffffffffc02014e0:	f8a2                	sd	s0,112(sp)
ffffffffc02014e2:	f862                	sd	s8,48(sp)
ffffffffc02014e4:	f466                	sd	s9,40(sp)
ffffffffc02014e6:	ec6e                	sd	s11,24(sp)
ffffffffc02014e8:	892a                	mv	s2,a0
ffffffffc02014ea:	84ae                	mv	s1,a1
ffffffffc02014ec:	8d32                	mv	s10,a2
ffffffffc02014ee:	8a36                	mv	s4,a3
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc02014f0:	02500993          	li	s3,37
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
        width = precision = -1;
ffffffffc02014f4:	5b7d                	li	s6,-1
ffffffffc02014f6:	00001a97          	auipc	s5,0x1
ffffffffc02014fa:	0eea8a93          	addi	s5,s5,238 # ffffffffc02025e4 <best_fit_pmm_manager+0x194>
        case 'e':
            err = va_arg(ap, int);
            if (err < 0) {
                err = -err;
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
ffffffffc02014fe:	00001b97          	auipc	s7,0x1
ffffffffc0201502:	2c2b8b93          	addi	s7,s7,706 # ffffffffc02027c0 <error_string>
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc0201506:	000d4503          	lbu	a0,0(s10)
ffffffffc020150a:	001d0413          	addi	s0,s10,1
ffffffffc020150e:	01350a63          	beq	a0,s3,ffffffffc0201522 <vprintfmt+0x56>
            if (ch == '\0') {
ffffffffc0201512:	c121                	beqz	a0,ffffffffc0201552 <vprintfmt+0x86>
            putch(ch, putdat);
ffffffffc0201514:	85a6                	mv	a1,s1
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc0201516:	0405                	addi	s0,s0,1
            putch(ch, putdat);
ffffffffc0201518:	9902                	jalr	s2
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc020151a:	fff44503          	lbu	a0,-1(s0)
ffffffffc020151e:	ff351ae3          	bne	a0,s3,ffffffffc0201512 <vprintfmt+0x46>
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0201522:	00044603          	lbu	a2,0(s0)
        char padc = ' ';
ffffffffc0201526:	02000793          	li	a5,32
        lflag = altflag = 0;
ffffffffc020152a:	4c81                	li	s9,0
ffffffffc020152c:	4881                	li	a7,0
        width = precision = -1;
ffffffffc020152e:	5c7d                	li	s8,-1
ffffffffc0201530:	5dfd                	li	s11,-1
ffffffffc0201532:	05500513          	li	a0,85
                if (ch < '0' || ch > '9') {
ffffffffc0201536:	4825                	li	a6,9
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0201538:	fdd6059b          	addiw	a1,a2,-35
ffffffffc020153c:	0ff5f593          	andi	a1,a1,255
ffffffffc0201540:	00140d13          	addi	s10,s0,1
ffffffffc0201544:	04b56263          	bltu	a0,a1,ffffffffc0201588 <vprintfmt+0xbc>
ffffffffc0201548:	058a                	slli	a1,a1,0x2
ffffffffc020154a:	95d6                	add	a1,a1,s5
ffffffffc020154c:	4194                	lw	a3,0(a1)
ffffffffc020154e:	96d6                	add	a3,a3,s5
ffffffffc0201550:	8682                	jr	a3
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
ffffffffc0201552:	70e6                	ld	ra,120(sp)
ffffffffc0201554:	7446                	ld	s0,112(sp)
ffffffffc0201556:	74a6                	ld	s1,104(sp)
ffffffffc0201558:	7906                	ld	s2,96(sp)
ffffffffc020155a:	69e6                	ld	s3,88(sp)
ffffffffc020155c:	6a46                	ld	s4,80(sp)
ffffffffc020155e:	6aa6                	ld	s5,72(sp)
ffffffffc0201560:	6b06                	ld	s6,64(sp)
ffffffffc0201562:	7be2                	ld	s7,56(sp)
ffffffffc0201564:	7c42                	ld	s8,48(sp)
ffffffffc0201566:	7ca2                	ld	s9,40(sp)
ffffffffc0201568:	7d02                	ld	s10,32(sp)
ffffffffc020156a:	6de2                	ld	s11,24(sp)
ffffffffc020156c:	6109                	addi	sp,sp,128
ffffffffc020156e:	8082                	ret
            padc = '0';
ffffffffc0201570:	87b2                	mv	a5,a2
            goto reswitch;
ffffffffc0201572:	00144603          	lbu	a2,1(s0)
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0201576:	846a                	mv	s0,s10
ffffffffc0201578:	00140d13          	addi	s10,s0,1
ffffffffc020157c:	fdd6059b          	addiw	a1,a2,-35
ffffffffc0201580:	0ff5f593          	andi	a1,a1,255
ffffffffc0201584:	fcb572e3          	bgeu	a0,a1,ffffffffc0201548 <vprintfmt+0x7c>
            putch('%', putdat);
ffffffffc0201588:	85a6                	mv	a1,s1
ffffffffc020158a:	02500513          	li	a0,37
ffffffffc020158e:	9902                	jalr	s2
            for (fmt --; fmt[-1] != '%'; fmt --)
ffffffffc0201590:	fff44783          	lbu	a5,-1(s0)
ffffffffc0201594:	8d22                	mv	s10,s0
ffffffffc0201596:	f73788e3          	beq	a5,s3,ffffffffc0201506 <vprintfmt+0x3a>
ffffffffc020159a:	ffed4783          	lbu	a5,-2(s10)
ffffffffc020159e:	1d7d                	addi	s10,s10,-1
ffffffffc02015a0:	ff379de3          	bne	a5,s3,ffffffffc020159a <vprintfmt+0xce>
ffffffffc02015a4:	b78d                	j	ffffffffc0201506 <vprintfmt+0x3a>
                precision = precision * 10 + ch - '0';
ffffffffc02015a6:	fd060c1b          	addiw	s8,a2,-48
                ch = *fmt;
ffffffffc02015aa:	00144603          	lbu	a2,1(s0)
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc02015ae:	846a                	mv	s0,s10
                if (ch < '0' || ch > '9') {
ffffffffc02015b0:	fd06069b          	addiw	a3,a2,-48
                ch = *fmt;
ffffffffc02015b4:	0006059b          	sext.w	a1,a2
                if (ch < '0' || ch > '9') {
ffffffffc02015b8:	02d86463          	bltu	a6,a3,ffffffffc02015e0 <vprintfmt+0x114>
                ch = *fmt;
ffffffffc02015bc:	00144603          	lbu	a2,1(s0)
                precision = precision * 10 + ch - '0';
ffffffffc02015c0:	002c169b          	slliw	a3,s8,0x2
ffffffffc02015c4:	0186873b          	addw	a4,a3,s8
ffffffffc02015c8:	0017171b          	slliw	a4,a4,0x1
ffffffffc02015cc:	9f2d                	addw	a4,a4,a1
                if (ch < '0' || ch > '9') {
ffffffffc02015ce:	fd06069b          	addiw	a3,a2,-48
            for (precision = 0; ; ++ fmt) {
ffffffffc02015d2:	0405                	addi	s0,s0,1
                precision = precision * 10 + ch - '0';
ffffffffc02015d4:	fd070c1b          	addiw	s8,a4,-48
                ch = *fmt;
ffffffffc02015d8:	0006059b          	sext.w	a1,a2
                if (ch < '0' || ch > '9') {
ffffffffc02015dc:	fed870e3          	bgeu	a6,a3,ffffffffc02015bc <vprintfmt+0xf0>
            if (width < 0)
ffffffffc02015e0:	f40ddce3          	bgez	s11,ffffffffc0201538 <vprintfmt+0x6c>
                width = precision, precision = -1;
ffffffffc02015e4:	8de2                	mv	s11,s8
ffffffffc02015e6:	5c7d                	li	s8,-1
ffffffffc02015e8:	bf81                	j	ffffffffc0201538 <vprintfmt+0x6c>
            if (width < 0)
ffffffffc02015ea:	fffdc693          	not	a3,s11
ffffffffc02015ee:	96fd                	srai	a3,a3,0x3f
ffffffffc02015f0:	00ddfdb3          	and	s11,s11,a3
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc02015f4:	00144603          	lbu	a2,1(s0)
ffffffffc02015f8:	2d81                	sext.w	s11,s11
ffffffffc02015fa:	846a                	mv	s0,s10
            goto reswitch;
ffffffffc02015fc:	bf35                	j	ffffffffc0201538 <vprintfmt+0x6c>
            precision = va_arg(ap, int);
ffffffffc02015fe:	000a2c03          	lw	s8,0(s4)
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0201602:	00144603          	lbu	a2,1(s0)
            precision = va_arg(ap, int);
ffffffffc0201606:	0a21                	addi	s4,s4,8
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0201608:	846a                	mv	s0,s10
            goto process_precision;
ffffffffc020160a:	bfd9                	j	ffffffffc02015e0 <vprintfmt+0x114>
    if (lflag >= 2) {
ffffffffc020160c:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc020160e:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
ffffffffc0201612:	01174463          	blt	a4,a7,ffffffffc020161a <vprintfmt+0x14e>
    else if (lflag) {
ffffffffc0201616:	1a088e63          	beqz	a7,ffffffffc02017d2 <vprintfmt+0x306>
        return va_arg(*ap, unsigned long);
ffffffffc020161a:	000a3603          	ld	a2,0(s4)
ffffffffc020161e:	46c1                	li	a3,16
ffffffffc0201620:	8a2e                	mv	s4,a1
            printnum(putch, putdat, num, base, width, padc);
ffffffffc0201622:	2781                	sext.w	a5,a5
ffffffffc0201624:	876e                	mv	a4,s11
ffffffffc0201626:	85a6                	mv	a1,s1
ffffffffc0201628:	854a                	mv	a0,s2
ffffffffc020162a:	e37ff0ef          	jal	ra,ffffffffc0201460 <printnum>
            break;
ffffffffc020162e:	bde1                	j	ffffffffc0201506 <vprintfmt+0x3a>
            putch(va_arg(ap, int), putdat);
ffffffffc0201630:	000a2503          	lw	a0,0(s4)
ffffffffc0201634:	85a6                	mv	a1,s1
ffffffffc0201636:	0a21                	addi	s4,s4,8
ffffffffc0201638:	9902                	jalr	s2
            break;
ffffffffc020163a:	b5f1                	j	ffffffffc0201506 <vprintfmt+0x3a>
    if (lflag >= 2) {
ffffffffc020163c:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc020163e:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
ffffffffc0201642:	01174463          	blt	a4,a7,ffffffffc020164a <vprintfmt+0x17e>
    else if (lflag) {
ffffffffc0201646:	18088163          	beqz	a7,ffffffffc02017c8 <vprintfmt+0x2fc>
        return va_arg(*ap, unsigned long);
ffffffffc020164a:	000a3603          	ld	a2,0(s4)
ffffffffc020164e:	46a9                	li	a3,10
ffffffffc0201650:	8a2e                	mv	s4,a1
ffffffffc0201652:	bfc1                	j	ffffffffc0201622 <vprintfmt+0x156>
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0201654:	00144603          	lbu	a2,1(s0)
            altflag = 1;
ffffffffc0201658:	4c85                	li	s9,1
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc020165a:	846a                	mv	s0,s10
            goto reswitch;
ffffffffc020165c:	bdf1                	j	ffffffffc0201538 <vprintfmt+0x6c>
            putch(ch, putdat);
ffffffffc020165e:	85a6                	mv	a1,s1
ffffffffc0201660:	02500513          	li	a0,37
ffffffffc0201664:	9902                	jalr	s2
            break;
ffffffffc0201666:	b545                	j	ffffffffc0201506 <vprintfmt+0x3a>
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0201668:	00144603          	lbu	a2,1(s0)
            lflag ++;
ffffffffc020166c:	2885                	addiw	a7,a7,1
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc020166e:	846a                	mv	s0,s10
            goto reswitch;
ffffffffc0201670:	b5e1                	j	ffffffffc0201538 <vprintfmt+0x6c>
    if (lflag >= 2) {
ffffffffc0201672:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc0201674:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
ffffffffc0201678:	01174463          	blt	a4,a7,ffffffffc0201680 <vprintfmt+0x1b4>
    else if (lflag) {
ffffffffc020167c:	14088163          	beqz	a7,ffffffffc02017be <vprintfmt+0x2f2>
        return va_arg(*ap, unsigned long);
ffffffffc0201680:	000a3603          	ld	a2,0(s4)
ffffffffc0201684:	46a1                	li	a3,8
ffffffffc0201686:	8a2e                	mv	s4,a1
ffffffffc0201688:	bf69                	j	ffffffffc0201622 <vprintfmt+0x156>
            putch('0', putdat);
ffffffffc020168a:	03000513          	li	a0,48
ffffffffc020168e:	85a6                	mv	a1,s1
ffffffffc0201690:	e03e                	sd	a5,0(sp)
ffffffffc0201692:	9902                	jalr	s2
            putch('x', putdat);
ffffffffc0201694:	85a6                	mv	a1,s1
ffffffffc0201696:	07800513          	li	a0,120
ffffffffc020169a:	9902                	jalr	s2
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
ffffffffc020169c:	0a21                	addi	s4,s4,8
            goto number;
ffffffffc020169e:	6782                	ld	a5,0(sp)
ffffffffc02016a0:	46c1                	li	a3,16
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
ffffffffc02016a2:	ff8a3603          	ld	a2,-8(s4)
            goto number;
ffffffffc02016a6:	bfb5                	j	ffffffffc0201622 <vprintfmt+0x156>
            if ((p = va_arg(ap, char *)) == NULL) {
ffffffffc02016a8:	000a3403          	ld	s0,0(s4)
ffffffffc02016ac:	008a0713          	addi	a4,s4,8
ffffffffc02016b0:	e03a                	sd	a4,0(sp)
ffffffffc02016b2:	14040263          	beqz	s0,ffffffffc02017f6 <vprintfmt+0x32a>
            if (width > 0 && padc != '-') {
ffffffffc02016b6:	0fb05763          	blez	s11,ffffffffc02017a4 <vprintfmt+0x2d8>
ffffffffc02016ba:	02d00693          	li	a3,45
ffffffffc02016be:	0cd79163          	bne	a5,a3,ffffffffc0201780 <vprintfmt+0x2b4>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc02016c2:	00044783          	lbu	a5,0(s0)
ffffffffc02016c6:	0007851b          	sext.w	a0,a5
ffffffffc02016ca:	cf85                	beqz	a5,ffffffffc0201702 <vprintfmt+0x236>
ffffffffc02016cc:	00140a13          	addi	s4,s0,1
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc02016d0:	05e00413          	li	s0,94
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc02016d4:	000c4563          	bltz	s8,ffffffffc02016de <vprintfmt+0x212>
ffffffffc02016d8:	3c7d                	addiw	s8,s8,-1
ffffffffc02016da:	036c0263          	beq	s8,s6,ffffffffc02016fe <vprintfmt+0x232>
                    putch('?', putdat);
ffffffffc02016de:	85a6                	mv	a1,s1
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc02016e0:	0e0c8e63          	beqz	s9,ffffffffc02017dc <vprintfmt+0x310>
ffffffffc02016e4:	3781                	addiw	a5,a5,-32
ffffffffc02016e6:	0ef47b63          	bgeu	s0,a5,ffffffffc02017dc <vprintfmt+0x310>
                    putch('?', putdat);
ffffffffc02016ea:	03f00513          	li	a0,63
ffffffffc02016ee:	9902                	jalr	s2
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc02016f0:	000a4783          	lbu	a5,0(s4)
ffffffffc02016f4:	3dfd                	addiw	s11,s11,-1
ffffffffc02016f6:	0a05                	addi	s4,s4,1
ffffffffc02016f8:	0007851b          	sext.w	a0,a5
ffffffffc02016fc:	ffe1                	bnez	a5,ffffffffc02016d4 <vprintfmt+0x208>
            for (; width > 0; width --) {
ffffffffc02016fe:	01b05963          	blez	s11,ffffffffc0201710 <vprintfmt+0x244>
ffffffffc0201702:	3dfd                	addiw	s11,s11,-1
                putch(' ', putdat);
ffffffffc0201704:	85a6                	mv	a1,s1
ffffffffc0201706:	02000513          	li	a0,32
ffffffffc020170a:	9902                	jalr	s2
            for (; width > 0; width --) {
ffffffffc020170c:	fe0d9be3          	bnez	s11,ffffffffc0201702 <vprintfmt+0x236>
            if ((p = va_arg(ap, char *)) == NULL) {
ffffffffc0201710:	6a02                	ld	s4,0(sp)
ffffffffc0201712:	bbd5                	j	ffffffffc0201506 <vprintfmt+0x3a>
    if (lflag >= 2) {
ffffffffc0201714:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc0201716:	008a0c93          	addi	s9,s4,8
    if (lflag >= 2) {
ffffffffc020171a:	01174463          	blt	a4,a7,ffffffffc0201722 <vprintfmt+0x256>
    else if (lflag) {
ffffffffc020171e:	08088d63          	beqz	a7,ffffffffc02017b8 <vprintfmt+0x2ec>
        return va_arg(*ap, long);
ffffffffc0201722:	000a3403          	ld	s0,0(s4)
            if ((long long)num < 0) {
ffffffffc0201726:	0a044d63          	bltz	s0,ffffffffc02017e0 <vprintfmt+0x314>
            num = getint(&ap, lflag);
ffffffffc020172a:	8622                	mv	a2,s0
ffffffffc020172c:	8a66                	mv	s4,s9
ffffffffc020172e:	46a9                	li	a3,10
ffffffffc0201730:	bdcd                	j	ffffffffc0201622 <vprintfmt+0x156>
            err = va_arg(ap, int);
ffffffffc0201732:	000a2783          	lw	a5,0(s4)
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
ffffffffc0201736:	4719                	li	a4,6
            err = va_arg(ap, int);
ffffffffc0201738:	0a21                	addi	s4,s4,8
            if (err < 0) {
ffffffffc020173a:	41f7d69b          	sraiw	a3,a5,0x1f
ffffffffc020173e:	8fb5                	xor	a5,a5,a3
ffffffffc0201740:	40d786bb          	subw	a3,a5,a3
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
ffffffffc0201744:	02d74163          	blt	a4,a3,ffffffffc0201766 <vprintfmt+0x29a>
ffffffffc0201748:	00369793          	slli	a5,a3,0x3
ffffffffc020174c:	97de                	add	a5,a5,s7
ffffffffc020174e:	639c                	ld	a5,0(a5)
ffffffffc0201750:	cb99                	beqz	a5,ffffffffc0201766 <vprintfmt+0x29a>
                printfmt(putch, putdat, "%s", p);
ffffffffc0201752:	86be                	mv	a3,a5
ffffffffc0201754:	00001617          	auipc	a2,0x1
ffffffffc0201758:	e8c60613          	addi	a2,a2,-372 # ffffffffc02025e0 <best_fit_pmm_manager+0x190>
ffffffffc020175c:	85a6                	mv	a1,s1
ffffffffc020175e:	854a                	mv	a0,s2
ffffffffc0201760:	0ce000ef          	jal	ra,ffffffffc020182e <printfmt>
ffffffffc0201764:	b34d                	j	ffffffffc0201506 <vprintfmt+0x3a>
                printfmt(putch, putdat, "error %d", err);
ffffffffc0201766:	00001617          	auipc	a2,0x1
ffffffffc020176a:	e6a60613          	addi	a2,a2,-406 # ffffffffc02025d0 <best_fit_pmm_manager+0x180>
ffffffffc020176e:	85a6                	mv	a1,s1
ffffffffc0201770:	854a                	mv	a0,s2
ffffffffc0201772:	0bc000ef          	jal	ra,ffffffffc020182e <printfmt>
ffffffffc0201776:	bb41                	j	ffffffffc0201506 <vprintfmt+0x3a>
                p = "(null)";
ffffffffc0201778:	00001417          	auipc	s0,0x1
ffffffffc020177c:	e5040413          	addi	s0,s0,-432 # ffffffffc02025c8 <best_fit_pmm_manager+0x178>
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc0201780:	85e2                	mv	a1,s8
ffffffffc0201782:	8522                	mv	a0,s0
ffffffffc0201784:	e43e                	sd	a5,8(sp)
ffffffffc0201786:	1cc000ef          	jal	ra,ffffffffc0201952 <strnlen>
ffffffffc020178a:	40ad8dbb          	subw	s11,s11,a0
ffffffffc020178e:	01b05b63          	blez	s11,ffffffffc02017a4 <vprintfmt+0x2d8>
                    putch(padc, putdat);
ffffffffc0201792:	67a2                	ld	a5,8(sp)
ffffffffc0201794:	00078a1b          	sext.w	s4,a5
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc0201798:	3dfd                	addiw	s11,s11,-1
                    putch(padc, putdat);
ffffffffc020179a:	85a6                	mv	a1,s1
ffffffffc020179c:	8552                	mv	a0,s4
ffffffffc020179e:	9902                	jalr	s2
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc02017a0:	fe0d9ce3          	bnez	s11,ffffffffc0201798 <vprintfmt+0x2cc>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc02017a4:	00044783          	lbu	a5,0(s0)
ffffffffc02017a8:	00140a13          	addi	s4,s0,1
ffffffffc02017ac:	0007851b          	sext.w	a0,a5
ffffffffc02017b0:	d3a5                	beqz	a5,ffffffffc0201710 <vprintfmt+0x244>
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc02017b2:	05e00413          	li	s0,94
ffffffffc02017b6:	bf39                	j	ffffffffc02016d4 <vprintfmt+0x208>
        return va_arg(*ap, int);
ffffffffc02017b8:	000a2403          	lw	s0,0(s4)
ffffffffc02017bc:	b7ad                	j	ffffffffc0201726 <vprintfmt+0x25a>
        return va_arg(*ap, unsigned int);
ffffffffc02017be:	000a6603          	lwu	a2,0(s4)
ffffffffc02017c2:	46a1                	li	a3,8
ffffffffc02017c4:	8a2e                	mv	s4,a1
ffffffffc02017c6:	bdb1                	j	ffffffffc0201622 <vprintfmt+0x156>
ffffffffc02017c8:	000a6603          	lwu	a2,0(s4)
ffffffffc02017cc:	46a9                	li	a3,10
ffffffffc02017ce:	8a2e                	mv	s4,a1
ffffffffc02017d0:	bd89                	j	ffffffffc0201622 <vprintfmt+0x156>
ffffffffc02017d2:	000a6603          	lwu	a2,0(s4)
ffffffffc02017d6:	46c1                	li	a3,16
ffffffffc02017d8:	8a2e                	mv	s4,a1
ffffffffc02017da:	b5a1                	j	ffffffffc0201622 <vprintfmt+0x156>
                    putch(ch, putdat);
ffffffffc02017dc:	9902                	jalr	s2
ffffffffc02017de:	bf09                	j	ffffffffc02016f0 <vprintfmt+0x224>
                putch('-', putdat);
ffffffffc02017e0:	85a6                	mv	a1,s1
ffffffffc02017e2:	02d00513          	li	a0,45
ffffffffc02017e6:	e03e                	sd	a5,0(sp)
ffffffffc02017e8:	9902                	jalr	s2
                num = -(long long)num;
ffffffffc02017ea:	6782                	ld	a5,0(sp)
ffffffffc02017ec:	8a66                	mv	s4,s9
ffffffffc02017ee:	40800633          	neg	a2,s0
ffffffffc02017f2:	46a9                	li	a3,10
ffffffffc02017f4:	b53d                	j	ffffffffc0201622 <vprintfmt+0x156>
            if (width > 0 && padc != '-') {
ffffffffc02017f6:	03b05163          	blez	s11,ffffffffc0201818 <vprintfmt+0x34c>
ffffffffc02017fa:	02d00693          	li	a3,45
ffffffffc02017fe:	f6d79de3          	bne	a5,a3,ffffffffc0201778 <vprintfmt+0x2ac>
                p = "(null)";
ffffffffc0201802:	00001417          	auipc	s0,0x1
ffffffffc0201806:	dc640413          	addi	s0,s0,-570 # ffffffffc02025c8 <best_fit_pmm_manager+0x178>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc020180a:	02800793          	li	a5,40
ffffffffc020180e:	02800513          	li	a0,40
ffffffffc0201812:	00140a13          	addi	s4,s0,1
ffffffffc0201816:	bd6d                	j	ffffffffc02016d0 <vprintfmt+0x204>
ffffffffc0201818:	00001a17          	auipc	s4,0x1
ffffffffc020181c:	db1a0a13          	addi	s4,s4,-591 # ffffffffc02025c9 <best_fit_pmm_manager+0x179>
ffffffffc0201820:	02800513          	li	a0,40
ffffffffc0201824:	02800793          	li	a5,40
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc0201828:	05e00413          	li	s0,94
ffffffffc020182c:	b565                	j	ffffffffc02016d4 <vprintfmt+0x208>

ffffffffc020182e <printfmt>:
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
ffffffffc020182e:	715d                	addi	sp,sp,-80
    va_start(ap, fmt);
ffffffffc0201830:	02810313          	addi	t1,sp,40
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
ffffffffc0201834:	f436                	sd	a3,40(sp)
    vprintfmt(putch, putdat, fmt, ap);
ffffffffc0201836:	869a                	mv	a3,t1
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
ffffffffc0201838:	ec06                	sd	ra,24(sp)
ffffffffc020183a:	f83a                	sd	a4,48(sp)
ffffffffc020183c:	fc3e                	sd	a5,56(sp)
ffffffffc020183e:	e0c2                	sd	a6,64(sp)
ffffffffc0201840:	e4c6                	sd	a7,72(sp)
    va_start(ap, fmt);
ffffffffc0201842:	e41a                	sd	t1,8(sp)
    vprintfmt(putch, putdat, fmt, ap);
ffffffffc0201844:	c89ff0ef          	jal	ra,ffffffffc02014cc <vprintfmt>
}
ffffffffc0201848:	60e2                	ld	ra,24(sp)
ffffffffc020184a:	6161                	addi	sp,sp,80
ffffffffc020184c:	8082                	ret

ffffffffc020184e <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
ffffffffc020184e:	715d                	addi	sp,sp,-80
ffffffffc0201850:	e486                	sd	ra,72(sp)
ffffffffc0201852:	e0a6                	sd	s1,64(sp)
ffffffffc0201854:	fc4a                	sd	s2,56(sp)
ffffffffc0201856:	f84e                	sd	s3,48(sp)
ffffffffc0201858:	f452                	sd	s4,40(sp)
ffffffffc020185a:	f056                	sd	s5,32(sp)
ffffffffc020185c:	ec5a                	sd	s6,24(sp)
ffffffffc020185e:	e85e                	sd	s7,16(sp)
    if (prompt != NULL) {
ffffffffc0201860:	c901                	beqz	a0,ffffffffc0201870 <readline+0x22>
ffffffffc0201862:	85aa                	mv	a1,a0
        cprintf("%s", prompt);
ffffffffc0201864:	00001517          	auipc	a0,0x1
ffffffffc0201868:	d7c50513          	addi	a0,a0,-644 # ffffffffc02025e0 <best_fit_pmm_manager+0x190>
ffffffffc020186c:	847fe0ef          	jal	ra,ffffffffc02000b2 <cprintf>
readline(const char *prompt) {
ffffffffc0201870:	4481                	li	s1,0
    while (1) {
        c = getchar();
        if (c < 0) {
            return NULL;
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
ffffffffc0201872:	497d                	li	s2,31
            cputchar(c);
            buf[i ++] = c;
        }
        else if (c == '\b' && i > 0) {
ffffffffc0201874:	49a1                	li	s3,8
            cputchar(c);
            i --;
        }
        else if (c == '\n' || c == '\r') {
ffffffffc0201876:	4aa9                	li	s5,10
ffffffffc0201878:	4b35                	li	s6,13
            buf[i ++] = c;
ffffffffc020187a:	00004b97          	auipc	s7,0x4
ffffffffc020187e:	7aeb8b93          	addi	s7,s7,1966 # ffffffffc0206028 <buf>
        else if (c >= ' ' && i < BUFSIZE - 1) {
ffffffffc0201882:	3fe00a13          	li	s4,1022
        c = getchar();
ffffffffc0201886:	8a5fe0ef          	jal	ra,ffffffffc020012a <getchar>
        if (c < 0) {
ffffffffc020188a:	00054a63          	bltz	a0,ffffffffc020189e <readline+0x50>
        else if (c >= ' ' && i < BUFSIZE - 1) {
ffffffffc020188e:	00a95a63          	bge	s2,a0,ffffffffc02018a2 <readline+0x54>
ffffffffc0201892:	029a5263          	bge	s4,s1,ffffffffc02018b6 <readline+0x68>
        c = getchar();
ffffffffc0201896:	895fe0ef          	jal	ra,ffffffffc020012a <getchar>
        if (c < 0) {
ffffffffc020189a:	fe055ae3          	bgez	a0,ffffffffc020188e <readline+0x40>
            return NULL;
ffffffffc020189e:	4501                	li	a0,0
ffffffffc02018a0:	a091                	j	ffffffffc02018e4 <readline+0x96>
        else if (c == '\b' && i > 0) {
ffffffffc02018a2:	03351463          	bne	a0,s3,ffffffffc02018ca <readline+0x7c>
ffffffffc02018a6:	e8a9                	bnez	s1,ffffffffc02018f8 <readline+0xaa>
        c = getchar();
ffffffffc02018a8:	883fe0ef          	jal	ra,ffffffffc020012a <getchar>
        if (c < 0) {
ffffffffc02018ac:	fe0549e3          	bltz	a0,ffffffffc020189e <readline+0x50>
        else if (c >= ' ' && i < BUFSIZE - 1) {
ffffffffc02018b0:	fea959e3          	bge	s2,a0,ffffffffc02018a2 <readline+0x54>
ffffffffc02018b4:	4481                	li	s1,0
            cputchar(c);
ffffffffc02018b6:	e42a                	sd	a0,8(sp)
ffffffffc02018b8:	831fe0ef          	jal	ra,ffffffffc02000e8 <cputchar>
            buf[i ++] = c;
ffffffffc02018bc:	6522                	ld	a0,8(sp)
ffffffffc02018be:	009b87b3          	add	a5,s7,s1
ffffffffc02018c2:	2485                	addiw	s1,s1,1
ffffffffc02018c4:	00a78023          	sb	a0,0(a5)
ffffffffc02018c8:	bf7d                	j	ffffffffc0201886 <readline+0x38>
        else if (c == '\n' || c == '\r') {
ffffffffc02018ca:	01550463          	beq	a0,s5,ffffffffc02018d2 <readline+0x84>
ffffffffc02018ce:	fb651ce3          	bne	a0,s6,ffffffffc0201886 <readline+0x38>
            cputchar(c);
ffffffffc02018d2:	817fe0ef          	jal	ra,ffffffffc02000e8 <cputchar>
            buf[i] = '\0';
ffffffffc02018d6:	00004517          	auipc	a0,0x4
ffffffffc02018da:	75250513          	addi	a0,a0,1874 # ffffffffc0206028 <buf>
ffffffffc02018de:	94aa                	add	s1,s1,a0
ffffffffc02018e0:	00048023          	sb	zero,0(s1)
            return buf;
        }
    }
}
ffffffffc02018e4:	60a6                	ld	ra,72(sp)
ffffffffc02018e6:	6486                	ld	s1,64(sp)
ffffffffc02018e8:	7962                	ld	s2,56(sp)
ffffffffc02018ea:	79c2                	ld	s3,48(sp)
ffffffffc02018ec:	7a22                	ld	s4,40(sp)
ffffffffc02018ee:	7a82                	ld	s5,32(sp)
ffffffffc02018f0:	6b62                	ld	s6,24(sp)
ffffffffc02018f2:	6bc2                	ld	s7,16(sp)
ffffffffc02018f4:	6161                	addi	sp,sp,80
ffffffffc02018f6:	8082                	ret
            cputchar(c);
ffffffffc02018f8:	4521                	li	a0,8
ffffffffc02018fa:	feefe0ef          	jal	ra,ffffffffc02000e8 <cputchar>
            i --;
ffffffffc02018fe:	34fd                	addiw	s1,s1,-1
ffffffffc0201900:	b759                	j	ffffffffc0201886 <readline+0x38>

ffffffffc0201902 <sbi_console_putchar>:
uint64_t SBI_REMOTE_SFENCE_VMA_ASID = 7;
uint64_t SBI_SHUTDOWN = 8;

uint64_t sbi_call(uint64_t sbi_type, uint64_t arg0, uint64_t arg1, uint64_t arg2) {
    uint64_t ret_val;
    __asm__ volatile (
ffffffffc0201902:	4781                	li	a5,0
ffffffffc0201904:	00004717          	auipc	a4,0x4
ffffffffc0201908:	70473703          	ld	a4,1796(a4) # ffffffffc0206008 <SBI_CONSOLE_PUTCHAR>
ffffffffc020190c:	88ba                	mv	a7,a4
ffffffffc020190e:	852a                	mv	a0,a0
ffffffffc0201910:	85be                	mv	a1,a5
ffffffffc0201912:	863e                	mv	a2,a5
ffffffffc0201914:	00000073          	ecall
ffffffffc0201918:	87aa                	mv	a5,a0
    return ret_val;
}

void sbi_console_putchar(unsigned char ch) {
    sbi_call(SBI_CONSOLE_PUTCHAR, ch, 0, 0);
}
ffffffffc020191a:	8082                	ret

ffffffffc020191c <sbi_set_timer>:
    __asm__ volatile (
ffffffffc020191c:	4781                	li	a5,0
ffffffffc020191e:	00005717          	auipc	a4,0x5
ffffffffc0201922:	b4a73703          	ld	a4,-1206(a4) # ffffffffc0206468 <SBI_SET_TIMER>
ffffffffc0201926:	88ba                	mv	a7,a4
ffffffffc0201928:	852a                	mv	a0,a0
ffffffffc020192a:	85be                	mv	a1,a5
ffffffffc020192c:	863e                	mv	a2,a5
ffffffffc020192e:	00000073          	ecall
ffffffffc0201932:	87aa                	mv	a5,a0

void sbi_set_timer(unsigned long long stime_value) {
    sbi_call(SBI_SET_TIMER, stime_value, 0, 0);
}
ffffffffc0201934:	8082                	ret

ffffffffc0201936 <sbi_console_getchar>:
    __asm__ volatile (
ffffffffc0201936:	4501                	li	a0,0
ffffffffc0201938:	00004797          	auipc	a5,0x4
ffffffffc020193c:	6c87b783          	ld	a5,1736(a5) # ffffffffc0206000 <SBI_CONSOLE_GETCHAR>
ffffffffc0201940:	88be                	mv	a7,a5
ffffffffc0201942:	852a                	mv	a0,a0
ffffffffc0201944:	85aa                	mv	a1,a0
ffffffffc0201946:	862a                	mv	a2,a0
ffffffffc0201948:	00000073          	ecall
ffffffffc020194c:	852a                	mv	a0,a0

int sbi_console_getchar(void) {
    return sbi_call(SBI_CONSOLE_GETCHAR, 0, 0, 0);
ffffffffc020194e:	2501                	sext.w	a0,a0
ffffffffc0201950:	8082                	ret

ffffffffc0201952 <strnlen>:
=======
ffffffffc02012f4:	601c                	ld	a5,0(s0)
ffffffffc02012f6:	7b9c                	ld	a5,48(a5)
ffffffffc02012f8:	9782                	jalr	a5
    cprintf("check_alloc_page() succeeded!\n");
ffffffffc02012fa:	00001517          	auipc	a0,0x1
ffffffffc02012fe:	0de50513          	addi	a0,a0,222 # ffffffffc02023d8 <buddy_system_pmm_manager+0x120>
ffffffffc0201302:	db1fe0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    satp_virtual = (pte_t*)boot_page_table_sv39;
ffffffffc0201306:	00004597          	auipc	a1,0x4
ffffffffc020130a:	cfa58593          	addi	a1,a1,-774 # ffffffffc0205000 <boot_page_table_sv39>
ffffffffc020130e:	00005797          	auipc	a5,0x5
ffffffffc0201312:	16b7b123          	sd	a1,354(a5) # ffffffffc0206470 <satp_virtual>
    satp_physical = PADDR(satp_virtual);
ffffffffc0201316:	c02007b7          	lui	a5,0xc0200
ffffffffc020131a:	08f5e063          	bltu	a1,a5,ffffffffc020139a <pmm_init+0x192>
ffffffffc020131e:	6090                	ld	a2,0(s1)
}
ffffffffc0201320:	6442                	ld	s0,16(sp)
ffffffffc0201322:	60e2                	ld	ra,24(sp)
ffffffffc0201324:	64a2                	ld	s1,8(sp)
    satp_physical = PADDR(satp_virtual);
ffffffffc0201326:	40c58633          	sub	a2,a1,a2
ffffffffc020132a:	00005797          	auipc	a5,0x5
ffffffffc020132e:	12c7bf23          	sd	a2,318(a5) # ffffffffc0206468 <satp_physical>
    cprintf("satp virtual address: 0x%016lx\nsatp physical address: 0x%016lx\n", satp_virtual, satp_physical);
ffffffffc0201332:	00001517          	auipc	a0,0x1
ffffffffc0201336:	0c650513          	addi	a0,a0,198 # ffffffffc02023f8 <buddy_system_pmm_manager+0x140>
}
ffffffffc020133a:	6105                	addi	sp,sp,32
    cprintf("satp virtual address: 0x%016lx\nsatp physical address: 0x%016lx\n", satp_virtual, satp_physical);
ffffffffc020133c:	d77fe06f          	j	ffffffffc02000b2 <cprintf>
    mem_begin = ROUNDUP(freemem, PGSIZE);
ffffffffc0201340:	6705                	lui	a4,0x1
ffffffffc0201342:	177d                	addi	a4,a4,-1
ffffffffc0201344:	96ba                	add	a3,a3,a4
ffffffffc0201346:	777d                	lui	a4,0xfffff
ffffffffc0201348:	8ef9                	and	a3,a3,a4
static inline int page_ref_dec(struct Page *page) {
    page->ref -= 1;
    return page->ref;
}
static inline struct Page *pa2page(uintptr_t pa) {
    if (PPN(pa) >= npage) {
ffffffffc020134a:	00c6d513          	srli	a0,a3,0xc
ffffffffc020134e:	00f57e63          	bgeu	a0,a5,ffffffffc020136a <pmm_init+0x162>
    pmm_manager->init_memmap(base, n);
ffffffffc0201352:	601c                	ld	a5,0(s0)
        panic("pa2page called with invalid pa");
    }
    return &pages[PPN(pa) - nbase];
ffffffffc0201354:	982a                	add	a6,a6,a0
ffffffffc0201356:	00281513          	slli	a0,a6,0x2
ffffffffc020135a:	9542                	add	a0,a0,a6
ffffffffc020135c:	6b9c                	ld	a5,16(a5)
        init_memmap(pa2page(mem_begin), (mem_end - mem_begin) / PGSIZE);
ffffffffc020135e:	8d95                	sub	a1,a1,a3
ffffffffc0201360:	050e                	slli	a0,a0,0x3
    pmm_manager->init_memmap(base, n);
ffffffffc0201362:	81b1                	srli	a1,a1,0xc
ffffffffc0201364:	9532                	add	a0,a0,a2
ffffffffc0201366:	9782                	jalr	a5
}
ffffffffc0201368:	b741                	j	ffffffffc02012e8 <pmm_init+0xe0>
        panic("pa2page called with invalid pa");
ffffffffc020136a:	00001617          	auipc	a2,0x1
ffffffffc020136e:	02e60613          	addi	a2,a2,46 # ffffffffc0202398 <buddy_system_pmm_manager+0xe0>
ffffffffc0201372:	06c00593          	li	a1,108
ffffffffc0201376:	00001517          	auipc	a0,0x1
ffffffffc020137a:	04250513          	addi	a0,a0,66 # ffffffffc02023b8 <buddy_system_pmm_manager+0x100>
ffffffffc020137e:	dbdfe0ef          	jal	ra,ffffffffc020013a <__panic>
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc0201382:	00001617          	auipc	a2,0x1
ffffffffc0201386:	fde60613          	addi	a2,a2,-34 # ffffffffc0202360 <buddy_system_pmm_manager+0xa8>
ffffffffc020138a:	06f00593          	li	a1,111
ffffffffc020138e:	00001517          	auipc	a0,0x1
ffffffffc0201392:	ffa50513          	addi	a0,a0,-6 # ffffffffc0202388 <buddy_system_pmm_manager+0xd0>
ffffffffc0201396:	da5fe0ef          	jal	ra,ffffffffc020013a <__panic>
    satp_physical = PADDR(satp_virtual);
ffffffffc020139a:	86ae                	mv	a3,a1
ffffffffc020139c:	00001617          	auipc	a2,0x1
ffffffffc02013a0:	fc460613          	addi	a2,a2,-60 # ffffffffc0202360 <buddy_system_pmm_manager+0xa8>
ffffffffc02013a4:	09100593          	li	a1,145
ffffffffc02013a8:	00001517          	auipc	a0,0x1
ffffffffc02013ac:	fe050513          	addi	a0,a0,-32 # ffffffffc0202388 <buddy_system_pmm_manager+0xd0>
ffffffffc02013b0:	d8bfe0ef          	jal	ra,ffffffffc020013a <__panic>

ffffffffc02013b4 <strnlen>:
>>>>>>> origin/main
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
<<<<<<< HEAD
ffffffffc0201952:	4781                	li	a5,0
    while (cnt < len && *s ++ != '\0') {
ffffffffc0201954:	e589                	bnez	a1,ffffffffc020195e <strnlen+0xc>
ffffffffc0201956:	a811                	j	ffffffffc020196a <strnlen+0x18>
        cnt ++;
ffffffffc0201958:	0785                	addi	a5,a5,1
    while (cnt < len && *s ++ != '\0') {
ffffffffc020195a:	00f58863          	beq	a1,a5,ffffffffc020196a <strnlen+0x18>
ffffffffc020195e:	00f50733          	add	a4,a0,a5
ffffffffc0201962:	00074703          	lbu	a4,0(a4)
ffffffffc0201966:	fb6d                	bnez	a4,ffffffffc0201958 <strnlen+0x6>
ffffffffc0201968:	85be                	mv	a1,a5
    }
    return cnt;
}
ffffffffc020196a:	852e                	mv	a0,a1
ffffffffc020196c:	8082                	ret

ffffffffc020196e <strcmp>:
=======
ffffffffc02013b4:	4781                	li	a5,0
    while (cnt < len && *s ++ != '\0') {
ffffffffc02013b6:	e589                	bnez	a1,ffffffffc02013c0 <strnlen+0xc>
ffffffffc02013b8:	a811                	j	ffffffffc02013cc <strnlen+0x18>
        cnt ++;
ffffffffc02013ba:	0785                	addi	a5,a5,1
    while (cnt < len && *s ++ != '\0') {
ffffffffc02013bc:	00f58863          	beq	a1,a5,ffffffffc02013cc <strnlen+0x18>
ffffffffc02013c0:	00f50733          	add	a4,a0,a5
ffffffffc02013c4:	00074703          	lbu	a4,0(a4) # fffffffffffff000 <end+0x3fdf8b78>
ffffffffc02013c8:	fb6d                	bnez	a4,ffffffffc02013ba <strnlen+0x6>
ffffffffc02013ca:	85be                	mv	a1,a5
    }
    return cnt;
}
ffffffffc02013cc:	852e                	mv	a0,a1
ffffffffc02013ce:	8082                	ret

ffffffffc02013d0 <strcmp>:
>>>>>>> origin/main
int
strcmp(const char *s1, const char *s2) {
#ifdef __HAVE_ARCH_STRCMP
    return __strcmp(s1, s2);
#else
    while (*s1 != '\0' && *s1 == *s2) {
<<<<<<< HEAD
ffffffffc020196e:	00054783          	lbu	a5,0(a0)
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc0201972:	0005c703          	lbu	a4,0(a1)
    while (*s1 != '\0' && *s1 == *s2) {
ffffffffc0201976:	cb89                	beqz	a5,ffffffffc0201988 <strcmp+0x1a>
        s1 ++, s2 ++;
ffffffffc0201978:	0505                	addi	a0,a0,1
ffffffffc020197a:	0585                	addi	a1,a1,1
    while (*s1 != '\0' && *s1 == *s2) {
ffffffffc020197c:	fee789e3          	beq	a5,a4,ffffffffc020196e <strcmp>
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc0201980:	0007851b          	sext.w	a0,a5
#endif /* __HAVE_ARCH_STRCMP */
}
ffffffffc0201984:	9d19                	subw	a0,a0,a4
ffffffffc0201986:	8082                	ret
ffffffffc0201988:	4501                	li	a0,0
ffffffffc020198a:	bfed                	j	ffffffffc0201984 <strcmp+0x16>

ffffffffc020198c <strchr>:
=======
ffffffffc02013d0:	00054783          	lbu	a5,0(a0)
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc02013d4:	0005c703          	lbu	a4,0(a1)
    while (*s1 != '\0' && *s1 == *s2) {
ffffffffc02013d8:	cb89                	beqz	a5,ffffffffc02013ea <strcmp+0x1a>
        s1 ++, s2 ++;
ffffffffc02013da:	0505                	addi	a0,a0,1
ffffffffc02013dc:	0585                	addi	a1,a1,1
    while (*s1 != '\0' && *s1 == *s2) {
ffffffffc02013de:	fee789e3          	beq	a5,a4,ffffffffc02013d0 <strcmp>
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc02013e2:	0007851b          	sext.w	a0,a5
#endif /* __HAVE_ARCH_STRCMP */
}
ffffffffc02013e6:	9d19                	subw	a0,a0,a4
ffffffffc02013e8:	8082                	ret
ffffffffc02013ea:	4501                	li	a0,0
ffffffffc02013ec:	bfed                	j	ffffffffc02013e6 <strcmp+0x16>

ffffffffc02013ee <strchr>:
>>>>>>> origin/main
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
<<<<<<< HEAD
ffffffffc020198c:	00054783          	lbu	a5,0(a0)
ffffffffc0201990:	c799                	beqz	a5,ffffffffc020199e <strchr+0x12>
        if (*s == c) {
ffffffffc0201992:	00f58763          	beq	a1,a5,ffffffffc02019a0 <strchr+0x14>
    while (*s != '\0') {
ffffffffc0201996:	00154783          	lbu	a5,1(a0)
            return (char *)s;
        }
        s ++;
ffffffffc020199a:	0505                	addi	a0,a0,1
    while (*s != '\0') {
ffffffffc020199c:	fbfd                	bnez	a5,ffffffffc0201992 <strchr+0x6>
    }
    return NULL;
ffffffffc020199e:	4501                	li	a0,0
}
ffffffffc02019a0:	8082                	ret

ffffffffc02019a2 <memset>:
=======
ffffffffc02013ee:	00054783          	lbu	a5,0(a0)
ffffffffc02013f2:	c799                	beqz	a5,ffffffffc0201400 <strchr+0x12>
        if (*s == c) {
ffffffffc02013f4:	00f58763          	beq	a1,a5,ffffffffc0201402 <strchr+0x14>
    while (*s != '\0') {
ffffffffc02013f8:	00154783          	lbu	a5,1(a0)
            return (char *)s;
        }
        s ++;
ffffffffc02013fc:	0505                	addi	a0,a0,1
    while (*s != '\0') {
ffffffffc02013fe:	fbfd                	bnez	a5,ffffffffc02013f4 <strchr+0x6>
    }
    return NULL;
ffffffffc0201400:	4501                	li	a0,0
}
ffffffffc0201402:	8082                	ret

ffffffffc0201404 <memset>:
>>>>>>> origin/main
memset(void *s, char c, size_t n) {
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
#else
    char *p = s;
    while (n -- > 0) {
<<<<<<< HEAD
ffffffffc02019a2:	ca01                	beqz	a2,ffffffffc02019b2 <memset+0x10>
ffffffffc02019a4:	962a                	add	a2,a2,a0
    char *p = s;
ffffffffc02019a6:	87aa                	mv	a5,a0
        *p ++ = c;
ffffffffc02019a8:	0785                	addi	a5,a5,1
ffffffffc02019aa:	feb78fa3          	sb	a1,-1(a5)
    while (n -- > 0) {
ffffffffc02019ae:	fec79de3          	bne	a5,a2,ffffffffc02019a8 <memset+0x6>
=======
ffffffffc0201404:	ca01                	beqz	a2,ffffffffc0201414 <memset+0x10>
ffffffffc0201406:	962a                	add	a2,a2,a0
    char *p = s;
ffffffffc0201408:	87aa                	mv	a5,a0
        *p ++ = c;
ffffffffc020140a:	0785                	addi	a5,a5,1
ffffffffc020140c:	feb78fa3          	sb	a1,-1(a5)
    while (n -- > 0) {
ffffffffc0201410:	fec79de3          	bne	a5,a2,ffffffffc020140a <memset+0x6>
>>>>>>> origin/main
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
<<<<<<< HEAD
ffffffffc02019b2:	8082                	ret
=======
ffffffffc0201414:	8082                	ret

ffffffffc0201416 <printnum>:
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
    unsigned long long result = num;
    unsigned mod = do_div(result, base);
ffffffffc0201416:	02069813          	slli	a6,a3,0x20
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc020141a:	7179                	addi	sp,sp,-48
    unsigned mod = do_div(result, base);
ffffffffc020141c:	02085813          	srli	a6,a6,0x20
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc0201420:	e052                	sd	s4,0(sp)
    unsigned mod = do_div(result, base);
ffffffffc0201422:	03067a33          	remu	s4,a2,a6
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc0201426:	f022                	sd	s0,32(sp)
ffffffffc0201428:	ec26                	sd	s1,24(sp)
ffffffffc020142a:	e84a                	sd	s2,16(sp)
ffffffffc020142c:	f406                	sd	ra,40(sp)
ffffffffc020142e:	e44e                	sd	s3,8(sp)
ffffffffc0201430:	84aa                	mv	s1,a0
ffffffffc0201432:	892e                	mv	s2,a1
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
ffffffffc0201434:	fff7041b          	addiw	s0,a4,-1
    unsigned mod = do_div(result, base);
ffffffffc0201438:	2a01                	sext.w	s4,s4
    if (num >= base) {
ffffffffc020143a:	03067e63          	bgeu	a2,a6,ffffffffc0201476 <printnum+0x60>
ffffffffc020143e:	89be                	mv	s3,a5
        while (-- width > 0)
ffffffffc0201440:	00805763          	blez	s0,ffffffffc020144e <printnum+0x38>
ffffffffc0201444:	347d                	addiw	s0,s0,-1
            putch(padc, putdat);
ffffffffc0201446:	85ca                	mv	a1,s2
ffffffffc0201448:	854e                	mv	a0,s3
ffffffffc020144a:	9482                	jalr	s1
        while (-- width > 0)
ffffffffc020144c:	fc65                	bnez	s0,ffffffffc0201444 <printnum+0x2e>
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
ffffffffc020144e:	1a02                	slli	s4,s4,0x20
ffffffffc0201450:	00001797          	auipc	a5,0x1
ffffffffc0201454:	fe878793          	addi	a5,a5,-24 # ffffffffc0202438 <buddy_system_pmm_manager+0x180>
ffffffffc0201458:	020a5a13          	srli	s4,s4,0x20
ffffffffc020145c:	9a3e                	add	s4,s4,a5
}
ffffffffc020145e:	7402                	ld	s0,32(sp)
    putch("0123456789abcdef"[mod], putdat);
ffffffffc0201460:	000a4503          	lbu	a0,0(s4)
}
ffffffffc0201464:	70a2                	ld	ra,40(sp)
ffffffffc0201466:	69a2                	ld	s3,8(sp)
ffffffffc0201468:	6a02                	ld	s4,0(sp)
    putch("0123456789abcdef"[mod], putdat);
ffffffffc020146a:	85ca                	mv	a1,s2
ffffffffc020146c:	87a6                	mv	a5,s1
}
ffffffffc020146e:	6942                	ld	s2,16(sp)
ffffffffc0201470:	64e2                	ld	s1,24(sp)
ffffffffc0201472:	6145                	addi	sp,sp,48
    putch("0123456789abcdef"[mod], putdat);
ffffffffc0201474:	8782                	jr	a5
        printnum(putch, putdat, result, base, width - 1, padc);
ffffffffc0201476:	03065633          	divu	a2,a2,a6
ffffffffc020147a:	8722                	mv	a4,s0
ffffffffc020147c:	f9bff0ef          	jal	ra,ffffffffc0201416 <printnum>
ffffffffc0201480:	b7f9                	j	ffffffffc020144e <printnum+0x38>

ffffffffc0201482 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
ffffffffc0201482:	7119                	addi	sp,sp,-128
ffffffffc0201484:	f4a6                	sd	s1,104(sp)
ffffffffc0201486:	f0ca                	sd	s2,96(sp)
ffffffffc0201488:	ecce                	sd	s3,88(sp)
ffffffffc020148a:	e8d2                	sd	s4,80(sp)
ffffffffc020148c:	e4d6                	sd	s5,72(sp)
ffffffffc020148e:	e0da                	sd	s6,64(sp)
ffffffffc0201490:	fc5e                	sd	s7,56(sp)
ffffffffc0201492:	f06a                	sd	s10,32(sp)
ffffffffc0201494:	fc86                	sd	ra,120(sp)
ffffffffc0201496:	f8a2                	sd	s0,112(sp)
ffffffffc0201498:	f862                	sd	s8,48(sp)
ffffffffc020149a:	f466                	sd	s9,40(sp)
ffffffffc020149c:	ec6e                	sd	s11,24(sp)
ffffffffc020149e:	892a                	mv	s2,a0
ffffffffc02014a0:	84ae                	mv	s1,a1
ffffffffc02014a2:	8d32                	mv	s10,a2
ffffffffc02014a4:	8a36                	mv	s4,a3
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc02014a6:	02500993          	li	s3,37
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
        width = precision = -1;
ffffffffc02014aa:	5b7d                	li	s6,-1
ffffffffc02014ac:	00001a97          	auipc	s5,0x1
ffffffffc02014b0:	fc0a8a93          	addi	s5,s5,-64 # ffffffffc020246c <buddy_system_pmm_manager+0x1b4>
        case 'e':
            err = va_arg(ap, int);
            if (err < 0) {
                err = -err;
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
ffffffffc02014b4:	00001b97          	auipc	s7,0x1
ffffffffc02014b8:	194b8b93          	addi	s7,s7,404 # ffffffffc0202648 <error_string>
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc02014bc:	000d4503          	lbu	a0,0(s10)
ffffffffc02014c0:	001d0413          	addi	s0,s10,1
ffffffffc02014c4:	01350a63          	beq	a0,s3,ffffffffc02014d8 <vprintfmt+0x56>
            if (ch == '\0') {
ffffffffc02014c8:	c121                	beqz	a0,ffffffffc0201508 <vprintfmt+0x86>
            putch(ch, putdat);
ffffffffc02014ca:	85a6                	mv	a1,s1
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc02014cc:	0405                	addi	s0,s0,1
            putch(ch, putdat);
ffffffffc02014ce:	9902                	jalr	s2
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc02014d0:	fff44503          	lbu	a0,-1(s0)
ffffffffc02014d4:	ff351ae3          	bne	a0,s3,ffffffffc02014c8 <vprintfmt+0x46>
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc02014d8:	00044603          	lbu	a2,0(s0)
        char padc = ' ';
ffffffffc02014dc:	02000793          	li	a5,32
        lflag = altflag = 0;
ffffffffc02014e0:	4c81                	li	s9,0
ffffffffc02014e2:	4881                	li	a7,0
        width = precision = -1;
ffffffffc02014e4:	5c7d                	li	s8,-1
ffffffffc02014e6:	5dfd                	li	s11,-1
ffffffffc02014e8:	05500513          	li	a0,85
                if (ch < '0' || ch > '9') {
ffffffffc02014ec:	4825                	li	a6,9
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc02014ee:	fdd6059b          	addiw	a1,a2,-35
ffffffffc02014f2:	0ff5f593          	zext.b	a1,a1
ffffffffc02014f6:	00140d13          	addi	s10,s0,1
ffffffffc02014fa:	04b56263          	bltu	a0,a1,ffffffffc020153e <vprintfmt+0xbc>
ffffffffc02014fe:	058a                	slli	a1,a1,0x2
ffffffffc0201500:	95d6                	add	a1,a1,s5
ffffffffc0201502:	4194                	lw	a3,0(a1)
ffffffffc0201504:	96d6                	add	a3,a3,s5
ffffffffc0201506:	8682                	jr	a3
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
ffffffffc0201508:	70e6                	ld	ra,120(sp)
ffffffffc020150a:	7446                	ld	s0,112(sp)
ffffffffc020150c:	74a6                	ld	s1,104(sp)
ffffffffc020150e:	7906                	ld	s2,96(sp)
ffffffffc0201510:	69e6                	ld	s3,88(sp)
ffffffffc0201512:	6a46                	ld	s4,80(sp)
ffffffffc0201514:	6aa6                	ld	s5,72(sp)
ffffffffc0201516:	6b06                	ld	s6,64(sp)
ffffffffc0201518:	7be2                	ld	s7,56(sp)
ffffffffc020151a:	7c42                	ld	s8,48(sp)
ffffffffc020151c:	7ca2                	ld	s9,40(sp)
ffffffffc020151e:	7d02                	ld	s10,32(sp)
ffffffffc0201520:	6de2                	ld	s11,24(sp)
ffffffffc0201522:	6109                	addi	sp,sp,128
ffffffffc0201524:	8082                	ret
            padc = '0';
ffffffffc0201526:	87b2                	mv	a5,a2
            goto reswitch;
ffffffffc0201528:	00144603          	lbu	a2,1(s0)
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc020152c:	846a                	mv	s0,s10
ffffffffc020152e:	00140d13          	addi	s10,s0,1
ffffffffc0201532:	fdd6059b          	addiw	a1,a2,-35
ffffffffc0201536:	0ff5f593          	zext.b	a1,a1
ffffffffc020153a:	fcb572e3          	bgeu	a0,a1,ffffffffc02014fe <vprintfmt+0x7c>
            putch('%', putdat);
ffffffffc020153e:	85a6                	mv	a1,s1
ffffffffc0201540:	02500513          	li	a0,37
ffffffffc0201544:	9902                	jalr	s2
            for (fmt --; fmt[-1] != '%'; fmt --)
ffffffffc0201546:	fff44783          	lbu	a5,-1(s0)
ffffffffc020154a:	8d22                	mv	s10,s0
ffffffffc020154c:	f73788e3          	beq	a5,s3,ffffffffc02014bc <vprintfmt+0x3a>
ffffffffc0201550:	ffed4783          	lbu	a5,-2(s10)
ffffffffc0201554:	1d7d                	addi	s10,s10,-1
ffffffffc0201556:	ff379de3          	bne	a5,s3,ffffffffc0201550 <vprintfmt+0xce>
ffffffffc020155a:	b78d                	j	ffffffffc02014bc <vprintfmt+0x3a>
                precision = precision * 10 + ch - '0';
ffffffffc020155c:	fd060c1b          	addiw	s8,a2,-48
                ch = *fmt;
ffffffffc0201560:	00144603          	lbu	a2,1(s0)
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0201564:	846a                	mv	s0,s10
                if (ch < '0' || ch > '9') {
ffffffffc0201566:	fd06069b          	addiw	a3,a2,-48
                ch = *fmt;
ffffffffc020156a:	0006059b          	sext.w	a1,a2
                if (ch < '0' || ch > '9') {
ffffffffc020156e:	02d86463          	bltu	a6,a3,ffffffffc0201596 <vprintfmt+0x114>
                ch = *fmt;
ffffffffc0201572:	00144603          	lbu	a2,1(s0)
                precision = precision * 10 + ch - '0';
ffffffffc0201576:	002c169b          	slliw	a3,s8,0x2
ffffffffc020157a:	0186873b          	addw	a4,a3,s8
ffffffffc020157e:	0017171b          	slliw	a4,a4,0x1
ffffffffc0201582:	9f2d                	addw	a4,a4,a1
                if (ch < '0' || ch > '9') {
ffffffffc0201584:	fd06069b          	addiw	a3,a2,-48
            for (precision = 0; ; ++ fmt) {
ffffffffc0201588:	0405                	addi	s0,s0,1
                precision = precision * 10 + ch - '0';
ffffffffc020158a:	fd070c1b          	addiw	s8,a4,-48
                ch = *fmt;
ffffffffc020158e:	0006059b          	sext.w	a1,a2
                if (ch < '0' || ch > '9') {
ffffffffc0201592:	fed870e3          	bgeu	a6,a3,ffffffffc0201572 <vprintfmt+0xf0>
            if (width < 0)
ffffffffc0201596:	f40ddce3          	bgez	s11,ffffffffc02014ee <vprintfmt+0x6c>
                width = precision, precision = -1;
ffffffffc020159a:	8de2                	mv	s11,s8
ffffffffc020159c:	5c7d                	li	s8,-1
ffffffffc020159e:	bf81                	j	ffffffffc02014ee <vprintfmt+0x6c>
            if (width < 0)
ffffffffc02015a0:	fffdc693          	not	a3,s11
ffffffffc02015a4:	96fd                	srai	a3,a3,0x3f
ffffffffc02015a6:	00ddfdb3          	and	s11,s11,a3
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc02015aa:	00144603          	lbu	a2,1(s0)
ffffffffc02015ae:	2d81                	sext.w	s11,s11
ffffffffc02015b0:	846a                	mv	s0,s10
            goto reswitch;
ffffffffc02015b2:	bf35                	j	ffffffffc02014ee <vprintfmt+0x6c>
            precision = va_arg(ap, int);
ffffffffc02015b4:	000a2c03          	lw	s8,0(s4)
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc02015b8:	00144603          	lbu	a2,1(s0)
            precision = va_arg(ap, int);
ffffffffc02015bc:	0a21                	addi	s4,s4,8
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc02015be:	846a                	mv	s0,s10
            goto process_precision;
ffffffffc02015c0:	bfd9                	j	ffffffffc0201596 <vprintfmt+0x114>
    if (lflag >= 2) {
ffffffffc02015c2:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc02015c4:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
ffffffffc02015c8:	01174463          	blt	a4,a7,ffffffffc02015d0 <vprintfmt+0x14e>
    else if (lflag) {
ffffffffc02015cc:	1a088e63          	beqz	a7,ffffffffc0201788 <vprintfmt+0x306>
        return va_arg(*ap, unsigned long);
ffffffffc02015d0:	000a3603          	ld	a2,0(s4)
ffffffffc02015d4:	46c1                	li	a3,16
ffffffffc02015d6:	8a2e                	mv	s4,a1
            printnum(putch, putdat, num, base, width, padc);
ffffffffc02015d8:	2781                	sext.w	a5,a5
ffffffffc02015da:	876e                	mv	a4,s11
ffffffffc02015dc:	85a6                	mv	a1,s1
ffffffffc02015de:	854a                	mv	a0,s2
ffffffffc02015e0:	e37ff0ef          	jal	ra,ffffffffc0201416 <printnum>
            break;
ffffffffc02015e4:	bde1                	j	ffffffffc02014bc <vprintfmt+0x3a>
            putch(va_arg(ap, int), putdat);
ffffffffc02015e6:	000a2503          	lw	a0,0(s4)
ffffffffc02015ea:	85a6                	mv	a1,s1
ffffffffc02015ec:	0a21                	addi	s4,s4,8
ffffffffc02015ee:	9902                	jalr	s2
            break;
ffffffffc02015f0:	b5f1                	j	ffffffffc02014bc <vprintfmt+0x3a>
    if (lflag >= 2) {
ffffffffc02015f2:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc02015f4:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
ffffffffc02015f8:	01174463          	blt	a4,a7,ffffffffc0201600 <vprintfmt+0x17e>
    else if (lflag) {
ffffffffc02015fc:	18088163          	beqz	a7,ffffffffc020177e <vprintfmt+0x2fc>
        return va_arg(*ap, unsigned long);
ffffffffc0201600:	000a3603          	ld	a2,0(s4)
ffffffffc0201604:	46a9                	li	a3,10
ffffffffc0201606:	8a2e                	mv	s4,a1
ffffffffc0201608:	bfc1                	j	ffffffffc02015d8 <vprintfmt+0x156>
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc020160a:	00144603          	lbu	a2,1(s0)
            altflag = 1;
ffffffffc020160e:	4c85                	li	s9,1
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0201610:	846a                	mv	s0,s10
            goto reswitch;
ffffffffc0201612:	bdf1                	j	ffffffffc02014ee <vprintfmt+0x6c>
            putch(ch, putdat);
ffffffffc0201614:	85a6                	mv	a1,s1
ffffffffc0201616:	02500513          	li	a0,37
ffffffffc020161a:	9902                	jalr	s2
            break;
ffffffffc020161c:	b545                	j	ffffffffc02014bc <vprintfmt+0x3a>
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc020161e:	00144603          	lbu	a2,1(s0)
            lflag ++;
ffffffffc0201622:	2885                	addiw	a7,a7,1
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0201624:	846a                	mv	s0,s10
            goto reswitch;
ffffffffc0201626:	b5e1                	j	ffffffffc02014ee <vprintfmt+0x6c>
    if (lflag >= 2) {
ffffffffc0201628:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc020162a:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
ffffffffc020162e:	01174463          	blt	a4,a7,ffffffffc0201636 <vprintfmt+0x1b4>
    else if (lflag) {
ffffffffc0201632:	14088163          	beqz	a7,ffffffffc0201774 <vprintfmt+0x2f2>
        return va_arg(*ap, unsigned long);
ffffffffc0201636:	000a3603          	ld	a2,0(s4)
ffffffffc020163a:	46a1                	li	a3,8
ffffffffc020163c:	8a2e                	mv	s4,a1
ffffffffc020163e:	bf69                	j	ffffffffc02015d8 <vprintfmt+0x156>
            putch('0', putdat);
ffffffffc0201640:	03000513          	li	a0,48
ffffffffc0201644:	85a6                	mv	a1,s1
ffffffffc0201646:	e03e                	sd	a5,0(sp)
ffffffffc0201648:	9902                	jalr	s2
            putch('x', putdat);
ffffffffc020164a:	85a6                	mv	a1,s1
ffffffffc020164c:	07800513          	li	a0,120
ffffffffc0201650:	9902                	jalr	s2
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
ffffffffc0201652:	0a21                	addi	s4,s4,8
            goto number;
ffffffffc0201654:	6782                	ld	a5,0(sp)
ffffffffc0201656:	46c1                	li	a3,16
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
ffffffffc0201658:	ff8a3603          	ld	a2,-8(s4)
            goto number;
ffffffffc020165c:	bfb5                	j	ffffffffc02015d8 <vprintfmt+0x156>
            if ((p = va_arg(ap, char *)) == NULL) {
ffffffffc020165e:	000a3403          	ld	s0,0(s4)
ffffffffc0201662:	008a0713          	addi	a4,s4,8
ffffffffc0201666:	e03a                	sd	a4,0(sp)
ffffffffc0201668:	14040263          	beqz	s0,ffffffffc02017ac <vprintfmt+0x32a>
            if (width > 0 && padc != '-') {
ffffffffc020166c:	0fb05763          	blez	s11,ffffffffc020175a <vprintfmt+0x2d8>
ffffffffc0201670:	02d00693          	li	a3,45
ffffffffc0201674:	0cd79163          	bne	a5,a3,ffffffffc0201736 <vprintfmt+0x2b4>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0201678:	00044783          	lbu	a5,0(s0)
ffffffffc020167c:	0007851b          	sext.w	a0,a5
ffffffffc0201680:	cf85                	beqz	a5,ffffffffc02016b8 <vprintfmt+0x236>
ffffffffc0201682:	00140a13          	addi	s4,s0,1
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc0201686:	05e00413          	li	s0,94
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc020168a:	000c4563          	bltz	s8,ffffffffc0201694 <vprintfmt+0x212>
ffffffffc020168e:	3c7d                	addiw	s8,s8,-1
ffffffffc0201690:	036c0263          	beq	s8,s6,ffffffffc02016b4 <vprintfmt+0x232>
                    putch('?', putdat);
ffffffffc0201694:	85a6                	mv	a1,s1
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc0201696:	0e0c8e63          	beqz	s9,ffffffffc0201792 <vprintfmt+0x310>
ffffffffc020169a:	3781                	addiw	a5,a5,-32
ffffffffc020169c:	0ef47b63          	bgeu	s0,a5,ffffffffc0201792 <vprintfmt+0x310>
                    putch('?', putdat);
ffffffffc02016a0:	03f00513          	li	a0,63
ffffffffc02016a4:	9902                	jalr	s2
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc02016a6:	000a4783          	lbu	a5,0(s4)
ffffffffc02016aa:	3dfd                	addiw	s11,s11,-1
ffffffffc02016ac:	0a05                	addi	s4,s4,1
ffffffffc02016ae:	0007851b          	sext.w	a0,a5
ffffffffc02016b2:	ffe1                	bnez	a5,ffffffffc020168a <vprintfmt+0x208>
            for (; width > 0; width --) {
ffffffffc02016b4:	01b05963          	blez	s11,ffffffffc02016c6 <vprintfmt+0x244>
ffffffffc02016b8:	3dfd                	addiw	s11,s11,-1
                putch(' ', putdat);
ffffffffc02016ba:	85a6                	mv	a1,s1
ffffffffc02016bc:	02000513          	li	a0,32
ffffffffc02016c0:	9902                	jalr	s2
            for (; width > 0; width --) {
ffffffffc02016c2:	fe0d9be3          	bnez	s11,ffffffffc02016b8 <vprintfmt+0x236>
            if ((p = va_arg(ap, char *)) == NULL) {
ffffffffc02016c6:	6a02                	ld	s4,0(sp)
ffffffffc02016c8:	bbd5                	j	ffffffffc02014bc <vprintfmt+0x3a>
    if (lflag >= 2) {
ffffffffc02016ca:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc02016cc:	008a0c93          	addi	s9,s4,8
    if (lflag >= 2) {
ffffffffc02016d0:	01174463          	blt	a4,a7,ffffffffc02016d8 <vprintfmt+0x256>
    else if (lflag) {
ffffffffc02016d4:	08088d63          	beqz	a7,ffffffffc020176e <vprintfmt+0x2ec>
        return va_arg(*ap, long);
ffffffffc02016d8:	000a3403          	ld	s0,0(s4)
            if ((long long)num < 0) {
ffffffffc02016dc:	0a044d63          	bltz	s0,ffffffffc0201796 <vprintfmt+0x314>
            num = getint(&ap, lflag);
ffffffffc02016e0:	8622                	mv	a2,s0
ffffffffc02016e2:	8a66                	mv	s4,s9
ffffffffc02016e4:	46a9                	li	a3,10
ffffffffc02016e6:	bdcd                	j	ffffffffc02015d8 <vprintfmt+0x156>
            err = va_arg(ap, int);
ffffffffc02016e8:	000a2783          	lw	a5,0(s4)
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
ffffffffc02016ec:	4719                	li	a4,6
            err = va_arg(ap, int);
ffffffffc02016ee:	0a21                	addi	s4,s4,8
            if (err < 0) {
ffffffffc02016f0:	41f7d69b          	sraiw	a3,a5,0x1f
ffffffffc02016f4:	8fb5                	xor	a5,a5,a3
ffffffffc02016f6:	40d786bb          	subw	a3,a5,a3
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
ffffffffc02016fa:	02d74163          	blt	a4,a3,ffffffffc020171c <vprintfmt+0x29a>
ffffffffc02016fe:	00369793          	slli	a5,a3,0x3
ffffffffc0201702:	97de                	add	a5,a5,s7
ffffffffc0201704:	639c                	ld	a5,0(a5)
ffffffffc0201706:	cb99                	beqz	a5,ffffffffc020171c <vprintfmt+0x29a>
                printfmt(putch, putdat, "%s", p);
ffffffffc0201708:	86be                	mv	a3,a5
ffffffffc020170a:	00001617          	auipc	a2,0x1
ffffffffc020170e:	d5e60613          	addi	a2,a2,-674 # ffffffffc0202468 <buddy_system_pmm_manager+0x1b0>
ffffffffc0201712:	85a6                	mv	a1,s1
ffffffffc0201714:	854a                	mv	a0,s2
ffffffffc0201716:	0ce000ef          	jal	ra,ffffffffc02017e4 <printfmt>
ffffffffc020171a:	b34d                	j	ffffffffc02014bc <vprintfmt+0x3a>
                printfmt(putch, putdat, "error %d", err);
ffffffffc020171c:	00001617          	auipc	a2,0x1
ffffffffc0201720:	d3c60613          	addi	a2,a2,-708 # ffffffffc0202458 <buddy_system_pmm_manager+0x1a0>
ffffffffc0201724:	85a6                	mv	a1,s1
ffffffffc0201726:	854a                	mv	a0,s2
ffffffffc0201728:	0bc000ef          	jal	ra,ffffffffc02017e4 <printfmt>
ffffffffc020172c:	bb41                	j	ffffffffc02014bc <vprintfmt+0x3a>
                p = "(null)";
ffffffffc020172e:	00001417          	auipc	s0,0x1
ffffffffc0201732:	d2240413          	addi	s0,s0,-734 # ffffffffc0202450 <buddy_system_pmm_manager+0x198>
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc0201736:	85e2                	mv	a1,s8
ffffffffc0201738:	8522                	mv	a0,s0
ffffffffc020173a:	e43e                	sd	a5,8(sp)
ffffffffc020173c:	c79ff0ef          	jal	ra,ffffffffc02013b4 <strnlen>
ffffffffc0201740:	40ad8dbb          	subw	s11,s11,a0
ffffffffc0201744:	01b05b63          	blez	s11,ffffffffc020175a <vprintfmt+0x2d8>
                    putch(padc, putdat);
ffffffffc0201748:	67a2                	ld	a5,8(sp)
ffffffffc020174a:	00078a1b          	sext.w	s4,a5
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc020174e:	3dfd                	addiw	s11,s11,-1
                    putch(padc, putdat);
ffffffffc0201750:	85a6                	mv	a1,s1
ffffffffc0201752:	8552                	mv	a0,s4
ffffffffc0201754:	9902                	jalr	s2
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc0201756:	fe0d9ce3          	bnez	s11,ffffffffc020174e <vprintfmt+0x2cc>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc020175a:	00044783          	lbu	a5,0(s0)
ffffffffc020175e:	00140a13          	addi	s4,s0,1
ffffffffc0201762:	0007851b          	sext.w	a0,a5
ffffffffc0201766:	d3a5                	beqz	a5,ffffffffc02016c6 <vprintfmt+0x244>
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc0201768:	05e00413          	li	s0,94
ffffffffc020176c:	bf39                	j	ffffffffc020168a <vprintfmt+0x208>
        return va_arg(*ap, int);
ffffffffc020176e:	000a2403          	lw	s0,0(s4)
ffffffffc0201772:	b7ad                	j	ffffffffc02016dc <vprintfmt+0x25a>
        return va_arg(*ap, unsigned int);
ffffffffc0201774:	000a6603          	lwu	a2,0(s4)
ffffffffc0201778:	46a1                	li	a3,8
ffffffffc020177a:	8a2e                	mv	s4,a1
ffffffffc020177c:	bdb1                	j	ffffffffc02015d8 <vprintfmt+0x156>
ffffffffc020177e:	000a6603          	lwu	a2,0(s4)
ffffffffc0201782:	46a9                	li	a3,10
ffffffffc0201784:	8a2e                	mv	s4,a1
ffffffffc0201786:	bd89                	j	ffffffffc02015d8 <vprintfmt+0x156>
ffffffffc0201788:	000a6603          	lwu	a2,0(s4)
ffffffffc020178c:	46c1                	li	a3,16
ffffffffc020178e:	8a2e                	mv	s4,a1
ffffffffc0201790:	b5a1                	j	ffffffffc02015d8 <vprintfmt+0x156>
                    putch(ch, putdat);
ffffffffc0201792:	9902                	jalr	s2
ffffffffc0201794:	bf09                	j	ffffffffc02016a6 <vprintfmt+0x224>
                putch('-', putdat);
ffffffffc0201796:	85a6                	mv	a1,s1
ffffffffc0201798:	02d00513          	li	a0,45
ffffffffc020179c:	e03e                	sd	a5,0(sp)
ffffffffc020179e:	9902                	jalr	s2
                num = -(long long)num;
ffffffffc02017a0:	6782                	ld	a5,0(sp)
ffffffffc02017a2:	8a66                	mv	s4,s9
ffffffffc02017a4:	40800633          	neg	a2,s0
ffffffffc02017a8:	46a9                	li	a3,10
ffffffffc02017aa:	b53d                	j	ffffffffc02015d8 <vprintfmt+0x156>
            if (width > 0 && padc != '-') {
ffffffffc02017ac:	03b05163          	blez	s11,ffffffffc02017ce <vprintfmt+0x34c>
ffffffffc02017b0:	02d00693          	li	a3,45
ffffffffc02017b4:	f6d79de3          	bne	a5,a3,ffffffffc020172e <vprintfmt+0x2ac>
                p = "(null)";
ffffffffc02017b8:	00001417          	auipc	s0,0x1
ffffffffc02017bc:	c9840413          	addi	s0,s0,-872 # ffffffffc0202450 <buddy_system_pmm_manager+0x198>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc02017c0:	02800793          	li	a5,40
ffffffffc02017c4:	02800513          	li	a0,40
ffffffffc02017c8:	00140a13          	addi	s4,s0,1
ffffffffc02017cc:	bd6d                	j	ffffffffc0201686 <vprintfmt+0x204>
ffffffffc02017ce:	00001a17          	auipc	s4,0x1
ffffffffc02017d2:	c83a0a13          	addi	s4,s4,-893 # ffffffffc0202451 <buddy_system_pmm_manager+0x199>
ffffffffc02017d6:	02800513          	li	a0,40
ffffffffc02017da:	02800793          	li	a5,40
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc02017de:	05e00413          	li	s0,94
ffffffffc02017e2:	b565                	j	ffffffffc020168a <vprintfmt+0x208>

ffffffffc02017e4 <printfmt>:
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
ffffffffc02017e4:	715d                	addi	sp,sp,-80
    va_start(ap, fmt);
ffffffffc02017e6:	02810313          	addi	t1,sp,40
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
ffffffffc02017ea:	f436                	sd	a3,40(sp)
    vprintfmt(putch, putdat, fmt, ap);
ffffffffc02017ec:	869a                	mv	a3,t1
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
ffffffffc02017ee:	ec06                	sd	ra,24(sp)
ffffffffc02017f0:	f83a                	sd	a4,48(sp)
ffffffffc02017f2:	fc3e                	sd	a5,56(sp)
ffffffffc02017f4:	e0c2                	sd	a6,64(sp)
ffffffffc02017f6:	e4c6                	sd	a7,72(sp)
    va_start(ap, fmt);
ffffffffc02017f8:	e41a                	sd	t1,8(sp)
    vprintfmt(putch, putdat, fmt, ap);
ffffffffc02017fa:	c89ff0ef          	jal	ra,ffffffffc0201482 <vprintfmt>
}
ffffffffc02017fe:	60e2                	ld	ra,24(sp)
ffffffffc0201800:	6161                	addi	sp,sp,80
ffffffffc0201802:	8082                	ret

ffffffffc0201804 <sbi_console_putchar>:
uint64_t SBI_REMOTE_SFENCE_VMA_ASID = 7;
uint64_t SBI_SHUTDOWN = 8;

uint64_t sbi_call(uint64_t sbi_type, uint64_t arg0, uint64_t arg1, uint64_t arg2) {
    uint64_t ret_val;
    __asm__ volatile (
ffffffffc0201804:	4781                	li	a5,0
ffffffffc0201806:	00005717          	auipc	a4,0x5
ffffffffc020180a:	80273703          	ld	a4,-2046(a4) # ffffffffc0206008 <SBI_CONSOLE_PUTCHAR>
ffffffffc020180e:	88ba                	mv	a7,a4
ffffffffc0201810:	852a                	mv	a0,a0
ffffffffc0201812:	85be                	mv	a1,a5
ffffffffc0201814:	863e                	mv	a2,a5
ffffffffc0201816:	00000073          	ecall
ffffffffc020181a:	87aa                	mv	a5,a0
    return ret_val;
}

void sbi_console_putchar(unsigned char ch) {
    sbi_call(SBI_CONSOLE_PUTCHAR, ch, 0, 0);
}
ffffffffc020181c:	8082                	ret

ffffffffc020181e <sbi_set_timer>:
    __asm__ volatile (
ffffffffc020181e:	4781                	li	a5,0
ffffffffc0201820:	00005717          	auipc	a4,0x5
ffffffffc0201824:	c6073703          	ld	a4,-928(a4) # ffffffffc0206480 <SBI_SET_TIMER>
ffffffffc0201828:	88ba                	mv	a7,a4
ffffffffc020182a:	852a                	mv	a0,a0
ffffffffc020182c:	85be                	mv	a1,a5
ffffffffc020182e:	863e                	mv	a2,a5
ffffffffc0201830:	00000073          	ecall
ffffffffc0201834:	87aa                	mv	a5,a0

void sbi_set_timer(unsigned long long stime_value) {
    sbi_call(SBI_SET_TIMER, stime_value, 0, 0);
}
ffffffffc0201836:	8082                	ret

ffffffffc0201838 <sbi_console_getchar>:
    __asm__ volatile (
ffffffffc0201838:	4501                	li	a0,0
ffffffffc020183a:	00004797          	auipc	a5,0x4
ffffffffc020183e:	7c67b783          	ld	a5,1990(a5) # ffffffffc0206000 <SBI_CONSOLE_GETCHAR>
ffffffffc0201842:	88be                	mv	a7,a5
ffffffffc0201844:	852a                	mv	a0,a0
ffffffffc0201846:	85aa                	mv	a1,a0
ffffffffc0201848:	862a                	mv	a2,a0
ffffffffc020184a:	00000073          	ecall
ffffffffc020184e:	852a                	mv	a0,a0

int sbi_console_getchar(void) {
    return sbi_call(SBI_CONSOLE_GETCHAR, 0, 0, 0);
ffffffffc0201850:	2501                	sext.w	a0,a0
ffffffffc0201852:	8082                	ret

ffffffffc0201854 <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
ffffffffc0201854:	715d                	addi	sp,sp,-80
ffffffffc0201856:	e486                	sd	ra,72(sp)
ffffffffc0201858:	e0a6                	sd	s1,64(sp)
ffffffffc020185a:	fc4a                	sd	s2,56(sp)
ffffffffc020185c:	f84e                	sd	s3,48(sp)
ffffffffc020185e:	f452                	sd	s4,40(sp)
ffffffffc0201860:	f056                	sd	s5,32(sp)
ffffffffc0201862:	ec5a                	sd	s6,24(sp)
ffffffffc0201864:	e85e                	sd	s7,16(sp)
    if (prompt != NULL) {
ffffffffc0201866:	c901                	beqz	a0,ffffffffc0201876 <readline+0x22>
ffffffffc0201868:	85aa                	mv	a1,a0
        cprintf("%s", prompt);
ffffffffc020186a:	00001517          	auipc	a0,0x1
ffffffffc020186e:	bfe50513          	addi	a0,a0,-1026 # ffffffffc0202468 <buddy_system_pmm_manager+0x1b0>
ffffffffc0201872:	841fe0ef          	jal	ra,ffffffffc02000b2 <cprintf>
readline(const char *prompt) {
ffffffffc0201876:	4481                	li	s1,0
    while (1) {
        c = getchar();
        if (c < 0) {
            return NULL;
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
ffffffffc0201878:	497d                	li	s2,31
            cputchar(c);
            buf[i ++] = c;
        }
        else if (c == '\b' && i > 0) {
ffffffffc020187a:	49a1                	li	s3,8
            cputchar(c);
            i --;
        }
        else if (c == '\n' || c == '\r') {
ffffffffc020187c:	4aa9                	li	s5,10
ffffffffc020187e:	4b35                	li	s6,13
            buf[i ++] = c;
ffffffffc0201880:	00004b97          	auipc	s7,0x4
ffffffffc0201884:	7a8b8b93          	addi	s7,s7,1960 # ffffffffc0206028 <buf>
        else if (c >= ' ' && i < BUFSIZE - 1) {
ffffffffc0201888:	3fe00a13          	li	s4,1022
        c = getchar();
ffffffffc020188c:	89ffe0ef          	jal	ra,ffffffffc020012a <getchar>
        if (c < 0) {
ffffffffc0201890:	00054a63          	bltz	a0,ffffffffc02018a4 <readline+0x50>
        else if (c >= ' ' && i < BUFSIZE - 1) {
ffffffffc0201894:	00a95a63          	bge	s2,a0,ffffffffc02018a8 <readline+0x54>
ffffffffc0201898:	029a5263          	bge	s4,s1,ffffffffc02018bc <readline+0x68>
        c = getchar();
ffffffffc020189c:	88ffe0ef          	jal	ra,ffffffffc020012a <getchar>
        if (c < 0) {
ffffffffc02018a0:	fe055ae3          	bgez	a0,ffffffffc0201894 <readline+0x40>
            return NULL;
ffffffffc02018a4:	4501                	li	a0,0
ffffffffc02018a6:	a091                	j	ffffffffc02018ea <readline+0x96>
        else if (c == '\b' && i > 0) {
ffffffffc02018a8:	03351463          	bne	a0,s3,ffffffffc02018d0 <readline+0x7c>
ffffffffc02018ac:	e8a9                	bnez	s1,ffffffffc02018fe <readline+0xaa>
        c = getchar();
ffffffffc02018ae:	87dfe0ef          	jal	ra,ffffffffc020012a <getchar>
        if (c < 0) {
ffffffffc02018b2:	fe0549e3          	bltz	a0,ffffffffc02018a4 <readline+0x50>
        else if (c >= ' ' && i < BUFSIZE - 1) {
ffffffffc02018b6:	fea959e3          	bge	s2,a0,ffffffffc02018a8 <readline+0x54>
ffffffffc02018ba:	4481                	li	s1,0
            cputchar(c);
ffffffffc02018bc:	e42a                	sd	a0,8(sp)
ffffffffc02018be:	82bfe0ef          	jal	ra,ffffffffc02000e8 <cputchar>
            buf[i ++] = c;
ffffffffc02018c2:	6522                	ld	a0,8(sp)
ffffffffc02018c4:	009b87b3          	add	a5,s7,s1
ffffffffc02018c8:	2485                	addiw	s1,s1,1
ffffffffc02018ca:	00a78023          	sb	a0,0(a5)
ffffffffc02018ce:	bf7d                	j	ffffffffc020188c <readline+0x38>
        else if (c == '\n' || c == '\r') {
ffffffffc02018d0:	01550463          	beq	a0,s5,ffffffffc02018d8 <readline+0x84>
ffffffffc02018d4:	fb651ce3          	bne	a0,s6,ffffffffc020188c <readline+0x38>
            cputchar(c);
ffffffffc02018d8:	811fe0ef          	jal	ra,ffffffffc02000e8 <cputchar>
            buf[i] = '\0';
ffffffffc02018dc:	00004517          	auipc	a0,0x4
ffffffffc02018e0:	74c50513          	addi	a0,a0,1868 # ffffffffc0206028 <buf>
ffffffffc02018e4:	94aa                	add	s1,s1,a0
ffffffffc02018e6:	00048023          	sb	zero,0(s1)
            return buf;
        }
    }
}
ffffffffc02018ea:	60a6                	ld	ra,72(sp)
ffffffffc02018ec:	6486                	ld	s1,64(sp)
ffffffffc02018ee:	7962                	ld	s2,56(sp)
ffffffffc02018f0:	79c2                	ld	s3,48(sp)
ffffffffc02018f2:	7a22                	ld	s4,40(sp)
ffffffffc02018f4:	7a82                	ld	s5,32(sp)
ffffffffc02018f6:	6b62                	ld	s6,24(sp)
ffffffffc02018f8:	6bc2                	ld	s7,16(sp)
ffffffffc02018fa:	6161                	addi	sp,sp,80
ffffffffc02018fc:	8082                	ret
            cputchar(c);
ffffffffc02018fe:	4521                	li	a0,8
ffffffffc0201900:	fe8fe0ef          	jal	ra,ffffffffc02000e8 <cputchar>
            i --;
ffffffffc0201904:	34fd                	addiw	s1,s1,-1
ffffffffc0201906:	b759                	j	ffffffffc020188c <readline+0x38>
>>>>>>> origin/main
