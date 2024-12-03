
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
void grade_backtrace(void);

int
kern_init(void) {
    extern char edata[], end[];
    memset(edata, 0, end - edata);
ffffffffc0200032:	0000a517          	auipc	a0,0xa
ffffffffc0200036:	02650513          	addi	a0,a0,38 # ffffffffc020a058 <buf>
ffffffffc020003a:	00015617          	auipc	a2,0x15
ffffffffc020003e:	58a60613          	addi	a2,a2,1418 # ffffffffc02155c4 <end>
kern_init(void) {
ffffffffc0200042:	1141                	addi	sp,sp,-16
    memset(edata, 0, end - edata);
ffffffffc0200044:	8e09                	sub	a2,a2,a0
ffffffffc0200046:	4581                	li	a1,0
kern_init(void) {
ffffffffc0200048:	e406                	sd	ra,8(sp)
    memset(edata, 0, end - edata);
ffffffffc020004a:	22b040ef          	jal	ra,ffffffffc0204a74 <memset>

    cons_init();                // init the console
ffffffffc020004e:	4a6000ef          	jal	ra,ffffffffc02004f4 <cons_init>

    const char *message = "(THU.CST) os is loading ...";
    cprintf("%s\n\n", message);
ffffffffc0200052:	00005597          	auipc	a1,0x5
ffffffffc0200056:	a7658593          	addi	a1,a1,-1418 # ffffffffc0204ac8 <etext+0x6>
ffffffffc020005a:	00005517          	auipc	a0,0x5
ffffffffc020005e:	a8e50513          	addi	a0,a0,-1394 # ffffffffc0204ae8 <etext+0x26>
ffffffffc0200062:	11e000ef          	jal	ra,ffffffffc0200180 <cprintf>

    print_kerninfo();
ffffffffc0200066:	162000ef          	jal	ra,ffffffffc02001c8 <print_kerninfo>

    // grade_backtrace();

    pmm_init();                 // init physical memory management
ffffffffc020006a:	6e5010ef          	jal	ra,ffffffffc0201f4e <pmm_init>

    pic_init();                 // init interrupt controller
ffffffffc020006e:	536000ef          	jal	ra,ffffffffc02005a4 <pic_init>
    idt_init();                 // init interrupt descriptor table
ffffffffc0200072:	5a4000ef          	jal	ra,ffffffffc0200616 <idt_init>

    vmm_init();                 // init virtual memory management
ffffffffc0200076:	207030ef          	jal	ra,ffffffffc0203a7c <vmm_init>
    proc_init();                // init process table
ffffffffc020007a:	220040ef          	jal	ra,ffffffffc020429a <proc_init>
    
    ide_init();                 // init ide devices
ffffffffc020007e:	4e8000ef          	jal	ra,ffffffffc0200566 <ide_init>
    swap_init();                // init swap
ffffffffc0200082:	3a9020ef          	jal	ra,ffffffffc0202c2a <swap_init>

    clock_init();               // init clock interrupt
ffffffffc0200086:	41c000ef          	jal	ra,ffffffffc02004a2 <clock_init>
    intr_enable();              // enable irq interrupt
ffffffffc020008a:	50e000ef          	jal	ra,ffffffffc0200598 <intr_enable>

    cpu_idle();                 // run idle process
ffffffffc020008e:	4b6040ef          	jal	ra,ffffffffc0204544 <cpu_idle>

ffffffffc0200092 <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
ffffffffc0200092:	715d                	addi	sp,sp,-80
ffffffffc0200094:	e486                	sd	ra,72(sp)
ffffffffc0200096:	e0a6                	sd	s1,64(sp)
ffffffffc0200098:	fc4a                	sd	s2,56(sp)
ffffffffc020009a:	f84e                	sd	s3,48(sp)
ffffffffc020009c:	f452                	sd	s4,40(sp)
ffffffffc020009e:	f056                	sd	s5,32(sp)
ffffffffc02000a0:	ec5a                	sd	s6,24(sp)
ffffffffc02000a2:	e85e                	sd	s7,16(sp)
    if (prompt != NULL) {
ffffffffc02000a4:	c901                	beqz	a0,ffffffffc02000b4 <readline+0x22>
ffffffffc02000a6:	85aa                	mv	a1,a0
        cprintf("%s", prompt);
ffffffffc02000a8:	00005517          	auipc	a0,0x5
ffffffffc02000ac:	a4850513          	addi	a0,a0,-1464 # ffffffffc0204af0 <etext+0x2e>
ffffffffc02000b0:	0d0000ef          	jal	ra,ffffffffc0200180 <cprintf>
readline(const char *prompt) {
ffffffffc02000b4:	4481                	li	s1,0
    while (1) {
        c = getchar();
        if (c < 0) {
            return NULL;
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
ffffffffc02000b6:	497d                	li	s2,31
            cputchar(c);
            buf[i ++] = c;
        }
        else if (c == '\b' && i > 0) {
ffffffffc02000b8:	49a1                	li	s3,8
            cputchar(c);
            i --;
        }
        else if (c == '\n' || c == '\r') {
ffffffffc02000ba:	4aa9                	li	s5,10
ffffffffc02000bc:	4b35                	li	s6,13
            buf[i ++] = c;
ffffffffc02000be:	0000ab97          	auipc	s7,0xa
ffffffffc02000c2:	f9ab8b93          	addi	s7,s7,-102 # ffffffffc020a058 <buf>
        else if (c >= ' ' && i < BUFSIZE - 1) {
ffffffffc02000c6:	3fe00a13          	li	s4,1022
        c = getchar();
ffffffffc02000ca:	0ee000ef          	jal	ra,ffffffffc02001b8 <getchar>
        if (c < 0) {
ffffffffc02000ce:	00054a63          	bltz	a0,ffffffffc02000e2 <readline+0x50>
        else if (c >= ' ' && i < BUFSIZE - 1) {
ffffffffc02000d2:	00a95a63          	bge	s2,a0,ffffffffc02000e6 <readline+0x54>
ffffffffc02000d6:	029a5263          	bge	s4,s1,ffffffffc02000fa <readline+0x68>
        c = getchar();
ffffffffc02000da:	0de000ef          	jal	ra,ffffffffc02001b8 <getchar>
        if (c < 0) {
ffffffffc02000de:	fe055ae3          	bgez	a0,ffffffffc02000d2 <readline+0x40>
            return NULL;
ffffffffc02000e2:	4501                	li	a0,0
ffffffffc02000e4:	a091                	j	ffffffffc0200128 <readline+0x96>
        else if (c == '\b' && i > 0) {
ffffffffc02000e6:	03351463          	bne	a0,s3,ffffffffc020010e <readline+0x7c>
ffffffffc02000ea:	e8a9                	bnez	s1,ffffffffc020013c <readline+0xaa>
        c = getchar();
ffffffffc02000ec:	0cc000ef          	jal	ra,ffffffffc02001b8 <getchar>
        if (c < 0) {
ffffffffc02000f0:	fe0549e3          	bltz	a0,ffffffffc02000e2 <readline+0x50>
        else if (c >= ' ' && i < BUFSIZE - 1) {
ffffffffc02000f4:	fea959e3          	bge	s2,a0,ffffffffc02000e6 <readline+0x54>
ffffffffc02000f8:	4481                	li	s1,0
            cputchar(c);
ffffffffc02000fa:	e42a                	sd	a0,8(sp)
ffffffffc02000fc:	0ba000ef          	jal	ra,ffffffffc02001b6 <cputchar>
            buf[i ++] = c;
ffffffffc0200100:	6522                	ld	a0,8(sp)
ffffffffc0200102:	009b87b3          	add	a5,s7,s1
ffffffffc0200106:	2485                	addiw	s1,s1,1
ffffffffc0200108:	00a78023          	sb	a0,0(a5)
ffffffffc020010c:	bf7d                	j	ffffffffc02000ca <readline+0x38>
        else if (c == '\n' || c == '\r') {
ffffffffc020010e:	01550463          	beq	a0,s5,ffffffffc0200116 <readline+0x84>
ffffffffc0200112:	fb651ce3          	bne	a0,s6,ffffffffc02000ca <readline+0x38>
            cputchar(c);
ffffffffc0200116:	0a0000ef          	jal	ra,ffffffffc02001b6 <cputchar>
            buf[i] = '\0';
ffffffffc020011a:	0000a517          	auipc	a0,0xa
ffffffffc020011e:	f3e50513          	addi	a0,a0,-194 # ffffffffc020a058 <buf>
ffffffffc0200122:	94aa                	add	s1,s1,a0
ffffffffc0200124:	00048023          	sb	zero,0(s1)
            return buf;
        }
    }
}
ffffffffc0200128:	60a6                	ld	ra,72(sp)
ffffffffc020012a:	6486                	ld	s1,64(sp)
ffffffffc020012c:	7962                	ld	s2,56(sp)
ffffffffc020012e:	79c2                	ld	s3,48(sp)
ffffffffc0200130:	7a22                	ld	s4,40(sp)
ffffffffc0200132:	7a82                	ld	s5,32(sp)
ffffffffc0200134:	6b62                	ld	s6,24(sp)
ffffffffc0200136:	6bc2                	ld	s7,16(sp)
ffffffffc0200138:	6161                	addi	sp,sp,80
ffffffffc020013a:	8082                	ret
            cputchar(c);
ffffffffc020013c:	4521                	li	a0,8
ffffffffc020013e:	078000ef          	jal	ra,ffffffffc02001b6 <cputchar>
            i --;
ffffffffc0200142:	34fd                	addiw	s1,s1,-1
ffffffffc0200144:	b759                	j	ffffffffc02000ca <readline+0x38>

ffffffffc0200146 <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
ffffffffc0200146:	1141                	addi	sp,sp,-16
ffffffffc0200148:	e022                	sd	s0,0(sp)
ffffffffc020014a:	e406                	sd	ra,8(sp)
ffffffffc020014c:	842e                	mv	s0,a1
    cons_putc(c);
ffffffffc020014e:	3a8000ef          	jal	ra,ffffffffc02004f6 <cons_putc>
    (*cnt) ++;
ffffffffc0200152:	401c                	lw	a5,0(s0)
}
ffffffffc0200154:	60a2                	ld	ra,8(sp)
    (*cnt) ++;
ffffffffc0200156:	2785                	addiw	a5,a5,1
ffffffffc0200158:	c01c                	sw	a5,0(s0)
}
ffffffffc020015a:	6402                	ld	s0,0(sp)
ffffffffc020015c:	0141                	addi	sp,sp,16
ffffffffc020015e:	8082                	ret

ffffffffc0200160 <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
ffffffffc0200160:	1101                	addi	sp,sp,-32
ffffffffc0200162:	862a                	mv	a2,a0
ffffffffc0200164:	86ae                	mv	a3,a1
    int cnt = 0;
    vprintfmt((void*)cputch, &cnt, fmt, ap);
ffffffffc0200166:	00000517          	auipc	a0,0x0
ffffffffc020016a:	fe050513          	addi	a0,a0,-32 # ffffffffc0200146 <cputch>
ffffffffc020016e:	006c                	addi	a1,sp,12
vcprintf(const char *fmt, va_list ap) {
ffffffffc0200170:	ec06                	sd	ra,24(sp)
    int cnt = 0;
ffffffffc0200172:	c602                	sw	zero,12(sp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
ffffffffc0200174:	502040ef          	jal	ra,ffffffffc0204676 <vprintfmt>
    return cnt;
}
ffffffffc0200178:	60e2                	ld	ra,24(sp)
ffffffffc020017a:	4532                	lw	a0,12(sp)
ffffffffc020017c:	6105                	addi	sp,sp,32
ffffffffc020017e:	8082                	ret

ffffffffc0200180 <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
ffffffffc0200180:	711d                	addi	sp,sp,-96
    va_list ap;
    int cnt;
    va_start(ap, fmt);
ffffffffc0200182:	02810313          	addi	t1,sp,40 # ffffffffc0209028 <boot_page_table_sv39+0x28>
cprintf(const char *fmt, ...) {
ffffffffc0200186:	8e2a                	mv	t3,a0
ffffffffc0200188:	f42e                	sd	a1,40(sp)
ffffffffc020018a:	f832                	sd	a2,48(sp)
ffffffffc020018c:	fc36                	sd	a3,56(sp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
ffffffffc020018e:	00000517          	auipc	a0,0x0
ffffffffc0200192:	fb850513          	addi	a0,a0,-72 # ffffffffc0200146 <cputch>
ffffffffc0200196:	004c                	addi	a1,sp,4
ffffffffc0200198:	869a                	mv	a3,t1
ffffffffc020019a:	8672                	mv	a2,t3
cprintf(const char *fmt, ...) {
ffffffffc020019c:	ec06                	sd	ra,24(sp)
ffffffffc020019e:	e0ba                	sd	a4,64(sp)
ffffffffc02001a0:	e4be                	sd	a5,72(sp)
ffffffffc02001a2:	e8c2                	sd	a6,80(sp)
ffffffffc02001a4:	ecc6                	sd	a7,88(sp)
    va_start(ap, fmt);
ffffffffc02001a6:	e41a                	sd	t1,8(sp)
    int cnt = 0;
ffffffffc02001a8:	c202                	sw	zero,4(sp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
ffffffffc02001aa:	4cc040ef          	jal	ra,ffffffffc0204676 <vprintfmt>
    cnt = vcprintf(fmt, ap);
    va_end(ap);
    return cnt;
}
ffffffffc02001ae:	60e2                	ld	ra,24(sp)
ffffffffc02001b0:	4512                	lw	a0,4(sp)
ffffffffc02001b2:	6125                	addi	sp,sp,96
ffffffffc02001b4:	8082                	ret

ffffffffc02001b6 <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
    cons_putc(c);
ffffffffc02001b6:	a681                	j	ffffffffc02004f6 <cons_putc>

ffffffffc02001b8 <getchar>:
    return cnt;
}

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
ffffffffc02001b8:	1141                	addi	sp,sp,-16
ffffffffc02001ba:	e406                	sd	ra,8(sp)
    int c;
    while ((c = cons_getc()) == 0)
ffffffffc02001bc:	36e000ef          	jal	ra,ffffffffc020052a <cons_getc>
ffffffffc02001c0:	dd75                	beqz	a0,ffffffffc02001bc <getchar+0x4>
        /* do nothing */;
    return c;
}
ffffffffc02001c2:	60a2                	ld	ra,8(sp)
ffffffffc02001c4:	0141                	addi	sp,sp,16
ffffffffc02001c6:	8082                	ret

ffffffffc02001c8 <print_kerninfo>:
/* *
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void print_kerninfo(void) {
ffffffffc02001c8:	1141                	addi	sp,sp,-16
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
ffffffffc02001ca:	00005517          	auipc	a0,0x5
ffffffffc02001ce:	92e50513          	addi	a0,a0,-1746 # ffffffffc0204af8 <etext+0x36>
void print_kerninfo(void) {
ffffffffc02001d2:	e406                	sd	ra,8(sp)
    cprintf("Special kernel symbols:\n");
ffffffffc02001d4:	fadff0ef          	jal	ra,ffffffffc0200180 <cprintf>
    cprintf("  entry  0x%08x (virtual)\n", kern_init);
ffffffffc02001d8:	00000597          	auipc	a1,0x0
ffffffffc02001dc:	e5a58593          	addi	a1,a1,-422 # ffffffffc0200032 <kern_init>
ffffffffc02001e0:	00005517          	auipc	a0,0x5
ffffffffc02001e4:	93850513          	addi	a0,a0,-1736 # ffffffffc0204b18 <etext+0x56>
ffffffffc02001e8:	f99ff0ef          	jal	ra,ffffffffc0200180 <cprintf>
    cprintf("  etext  0x%08x (virtual)\n", etext);
ffffffffc02001ec:	00005597          	auipc	a1,0x5
ffffffffc02001f0:	8d658593          	addi	a1,a1,-1834 # ffffffffc0204ac2 <etext>
ffffffffc02001f4:	00005517          	auipc	a0,0x5
ffffffffc02001f8:	94450513          	addi	a0,a0,-1724 # ffffffffc0204b38 <etext+0x76>
ffffffffc02001fc:	f85ff0ef          	jal	ra,ffffffffc0200180 <cprintf>
    cprintf("  edata  0x%08x (virtual)\n", edata);
ffffffffc0200200:	0000a597          	auipc	a1,0xa
ffffffffc0200204:	e5858593          	addi	a1,a1,-424 # ffffffffc020a058 <buf>
ffffffffc0200208:	00005517          	auipc	a0,0x5
ffffffffc020020c:	95050513          	addi	a0,a0,-1712 # ffffffffc0204b58 <etext+0x96>
ffffffffc0200210:	f71ff0ef          	jal	ra,ffffffffc0200180 <cprintf>
    cprintf("  end    0x%08x (virtual)\n", end);
ffffffffc0200214:	00015597          	auipc	a1,0x15
ffffffffc0200218:	3b058593          	addi	a1,a1,944 # ffffffffc02155c4 <end>
ffffffffc020021c:	00005517          	auipc	a0,0x5
ffffffffc0200220:	95c50513          	addi	a0,a0,-1700 # ffffffffc0204b78 <etext+0xb6>
ffffffffc0200224:	f5dff0ef          	jal	ra,ffffffffc0200180 <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n",
            (end - kern_init + 1023) / 1024);
ffffffffc0200228:	00015597          	auipc	a1,0x15
ffffffffc020022c:	79b58593          	addi	a1,a1,1947 # ffffffffc02159c3 <end+0x3ff>
ffffffffc0200230:	00000797          	auipc	a5,0x0
ffffffffc0200234:	e0278793          	addi	a5,a5,-510 # ffffffffc0200032 <kern_init>
ffffffffc0200238:	40f587b3          	sub	a5,a1,a5
    cprintf("Kernel executable memory footprint: %dKB\n",
ffffffffc020023c:	43f7d593          	srai	a1,a5,0x3f
}
ffffffffc0200240:	60a2                	ld	ra,8(sp)
    cprintf("Kernel executable memory footprint: %dKB\n",
ffffffffc0200242:	3ff5f593          	andi	a1,a1,1023
ffffffffc0200246:	95be                	add	a1,a1,a5
ffffffffc0200248:	85a9                	srai	a1,a1,0xa
ffffffffc020024a:	00005517          	auipc	a0,0x5
ffffffffc020024e:	94e50513          	addi	a0,a0,-1714 # ffffffffc0204b98 <etext+0xd6>
}
ffffffffc0200252:	0141                	addi	sp,sp,16
    cprintf("Kernel executable memory footprint: %dKB\n",
ffffffffc0200254:	b735                	j	ffffffffc0200180 <cprintf>

ffffffffc0200256 <print_stackframe>:
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before
 * jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the
 * boundary.
 * */
void print_stackframe(void) {
ffffffffc0200256:	1141                	addi	sp,sp,-16
    panic("Not Implemented!");
ffffffffc0200258:	00005617          	auipc	a2,0x5
ffffffffc020025c:	97060613          	addi	a2,a2,-1680 # ffffffffc0204bc8 <etext+0x106>
ffffffffc0200260:	04d00593          	li	a1,77
ffffffffc0200264:	00005517          	auipc	a0,0x5
ffffffffc0200268:	97c50513          	addi	a0,a0,-1668 # ffffffffc0204be0 <etext+0x11e>
void print_stackframe(void) {
ffffffffc020026c:	e406                	sd	ra,8(sp)
    panic("Not Implemented!");
ffffffffc020026e:	1d8000ef          	jal	ra,ffffffffc0200446 <__panic>

ffffffffc0200272 <mon_help>:
    }
}

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
ffffffffc0200272:	1141                	addi	sp,sp,-16
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
ffffffffc0200274:	00005617          	auipc	a2,0x5
ffffffffc0200278:	98460613          	addi	a2,a2,-1660 # ffffffffc0204bf8 <etext+0x136>
ffffffffc020027c:	00005597          	auipc	a1,0x5
ffffffffc0200280:	99c58593          	addi	a1,a1,-1636 # ffffffffc0204c18 <etext+0x156>
ffffffffc0200284:	00005517          	auipc	a0,0x5
ffffffffc0200288:	99c50513          	addi	a0,a0,-1636 # ffffffffc0204c20 <etext+0x15e>
mon_help(int argc, char **argv, struct trapframe *tf) {
ffffffffc020028c:	e406                	sd	ra,8(sp)
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
ffffffffc020028e:	ef3ff0ef          	jal	ra,ffffffffc0200180 <cprintf>
ffffffffc0200292:	00005617          	auipc	a2,0x5
ffffffffc0200296:	99e60613          	addi	a2,a2,-1634 # ffffffffc0204c30 <etext+0x16e>
ffffffffc020029a:	00005597          	auipc	a1,0x5
ffffffffc020029e:	9be58593          	addi	a1,a1,-1602 # ffffffffc0204c58 <etext+0x196>
ffffffffc02002a2:	00005517          	auipc	a0,0x5
ffffffffc02002a6:	97e50513          	addi	a0,a0,-1666 # ffffffffc0204c20 <etext+0x15e>
ffffffffc02002aa:	ed7ff0ef          	jal	ra,ffffffffc0200180 <cprintf>
ffffffffc02002ae:	00005617          	auipc	a2,0x5
ffffffffc02002b2:	9ba60613          	addi	a2,a2,-1606 # ffffffffc0204c68 <etext+0x1a6>
ffffffffc02002b6:	00005597          	auipc	a1,0x5
ffffffffc02002ba:	9d258593          	addi	a1,a1,-1582 # ffffffffc0204c88 <etext+0x1c6>
ffffffffc02002be:	00005517          	auipc	a0,0x5
ffffffffc02002c2:	96250513          	addi	a0,a0,-1694 # ffffffffc0204c20 <etext+0x15e>
ffffffffc02002c6:	ebbff0ef          	jal	ra,ffffffffc0200180 <cprintf>
    }
    return 0;
}
ffffffffc02002ca:	60a2                	ld	ra,8(sp)
ffffffffc02002cc:	4501                	li	a0,0
ffffffffc02002ce:	0141                	addi	sp,sp,16
ffffffffc02002d0:	8082                	ret

ffffffffc02002d2 <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
ffffffffc02002d2:	1141                	addi	sp,sp,-16
ffffffffc02002d4:	e406                	sd	ra,8(sp)
    print_kerninfo();
ffffffffc02002d6:	ef3ff0ef          	jal	ra,ffffffffc02001c8 <print_kerninfo>
    return 0;
}
ffffffffc02002da:	60a2                	ld	ra,8(sp)
ffffffffc02002dc:	4501                	li	a0,0
ffffffffc02002de:	0141                	addi	sp,sp,16
ffffffffc02002e0:	8082                	ret

ffffffffc02002e2 <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
ffffffffc02002e2:	1141                	addi	sp,sp,-16
ffffffffc02002e4:	e406                	sd	ra,8(sp)
    print_stackframe();
ffffffffc02002e6:	f71ff0ef          	jal	ra,ffffffffc0200256 <print_stackframe>
    return 0;
}
ffffffffc02002ea:	60a2                	ld	ra,8(sp)
ffffffffc02002ec:	4501                	li	a0,0
ffffffffc02002ee:	0141                	addi	sp,sp,16
ffffffffc02002f0:	8082                	ret

ffffffffc02002f2 <kmonitor>:
kmonitor(struct trapframe *tf) {
ffffffffc02002f2:	7115                	addi	sp,sp,-224
ffffffffc02002f4:	ed5e                	sd	s7,152(sp)
ffffffffc02002f6:	8baa                	mv	s7,a0
    cprintf("Welcome to the kernel debug monitor!!\n");
ffffffffc02002f8:	00005517          	auipc	a0,0x5
ffffffffc02002fc:	9a050513          	addi	a0,a0,-1632 # ffffffffc0204c98 <etext+0x1d6>
kmonitor(struct trapframe *tf) {
ffffffffc0200300:	ed86                	sd	ra,216(sp)
ffffffffc0200302:	e9a2                	sd	s0,208(sp)
ffffffffc0200304:	e5a6                	sd	s1,200(sp)
ffffffffc0200306:	e1ca                	sd	s2,192(sp)
ffffffffc0200308:	fd4e                	sd	s3,184(sp)
ffffffffc020030a:	f952                	sd	s4,176(sp)
ffffffffc020030c:	f556                	sd	s5,168(sp)
ffffffffc020030e:	f15a                	sd	s6,160(sp)
ffffffffc0200310:	e962                	sd	s8,144(sp)
ffffffffc0200312:	e566                	sd	s9,136(sp)
ffffffffc0200314:	e16a                	sd	s10,128(sp)
    cprintf("Welcome to the kernel debug monitor!!\n");
ffffffffc0200316:	e6bff0ef          	jal	ra,ffffffffc0200180 <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
ffffffffc020031a:	00005517          	auipc	a0,0x5
ffffffffc020031e:	9a650513          	addi	a0,a0,-1626 # ffffffffc0204cc0 <etext+0x1fe>
ffffffffc0200322:	e5fff0ef          	jal	ra,ffffffffc0200180 <cprintf>
    if (tf != NULL) {
ffffffffc0200326:	000b8563          	beqz	s7,ffffffffc0200330 <kmonitor+0x3e>
        print_trapframe(tf);
ffffffffc020032a:	855e                	mv	a0,s7
ffffffffc020032c:	4d0000ef          	jal	ra,ffffffffc02007fc <print_trapframe>
#endif
}

static inline void sbi_shutdown(void)
{
	SBI_CALL_0(SBI_SHUTDOWN);
ffffffffc0200330:	4501                	li	a0,0
ffffffffc0200332:	4581                	li	a1,0
ffffffffc0200334:	4601                	li	a2,0
ffffffffc0200336:	48a1                	li	a7,8
ffffffffc0200338:	00000073          	ecall
ffffffffc020033c:	00005c17          	auipc	s8,0x5
ffffffffc0200340:	9f4c0c13          	addi	s8,s8,-1548 # ffffffffc0204d30 <commands>
        if ((buf = readline("K> ")) != NULL) {
ffffffffc0200344:	00005917          	auipc	s2,0x5
ffffffffc0200348:	9a490913          	addi	s2,s2,-1628 # ffffffffc0204ce8 <etext+0x226>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
ffffffffc020034c:	00005497          	auipc	s1,0x5
ffffffffc0200350:	9a448493          	addi	s1,s1,-1628 # ffffffffc0204cf0 <etext+0x22e>
        if (argc == MAXARGS - 1) {
ffffffffc0200354:	49bd                	li	s3,15
            cprintf("Too many arguments (max %d).\n", MAXARGS);
ffffffffc0200356:	00005b17          	auipc	s6,0x5
ffffffffc020035a:	9a2b0b13          	addi	s6,s6,-1630 # ffffffffc0204cf8 <etext+0x236>
        argv[argc ++] = buf;
ffffffffc020035e:	00005a17          	auipc	s4,0x5
ffffffffc0200362:	8baa0a13          	addi	s4,s4,-1862 # ffffffffc0204c18 <etext+0x156>
    for (i = 0; i < NCOMMANDS; i ++) {
ffffffffc0200366:	4a8d                	li	s5,3
        if ((buf = readline("K> ")) != NULL) {
ffffffffc0200368:	854a                	mv	a0,s2
ffffffffc020036a:	d29ff0ef          	jal	ra,ffffffffc0200092 <readline>
ffffffffc020036e:	842a                	mv	s0,a0
ffffffffc0200370:	dd65                	beqz	a0,ffffffffc0200368 <kmonitor+0x76>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
ffffffffc0200372:	00054583          	lbu	a1,0(a0)
    int argc = 0;
ffffffffc0200376:	4c81                	li	s9,0
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
ffffffffc0200378:	e1bd                	bnez	a1,ffffffffc02003de <kmonitor+0xec>
    if (argc == 0) {
ffffffffc020037a:	fe0c87e3          	beqz	s9,ffffffffc0200368 <kmonitor+0x76>
        if (strcmp(commands[i].name, argv[0]) == 0) {
ffffffffc020037e:	6582                	ld	a1,0(sp)
ffffffffc0200380:	00005d17          	auipc	s10,0x5
ffffffffc0200384:	9b0d0d13          	addi	s10,s10,-1616 # ffffffffc0204d30 <commands>
        argv[argc ++] = buf;
ffffffffc0200388:	8552                	mv	a0,s4
    for (i = 0; i < NCOMMANDS; i ++) {
ffffffffc020038a:	4401                	li	s0,0
ffffffffc020038c:	0d61                	addi	s10,s10,24
        if (strcmp(commands[i].name, argv[0]) == 0) {
ffffffffc020038e:	6b2040ef          	jal	ra,ffffffffc0204a40 <strcmp>
ffffffffc0200392:	c919                	beqz	a0,ffffffffc02003a8 <kmonitor+0xb6>
    for (i = 0; i < NCOMMANDS; i ++) {
ffffffffc0200394:	2405                	addiw	s0,s0,1
ffffffffc0200396:	0b540063          	beq	s0,s5,ffffffffc0200436 <kmonitor+0x144>
        if (strcmp(commands[i].name, argv[0]) == 0) {
ffffffffc020039a:	000d3503          	ld	a0,0(s10)
ffffffffc020039e:	6582                	ld	a1,0(sp)
    for (i = 0; i < NCOMMANDS; i ++) {
ffffffffc02003a0:	0d61                	addi	s10,s10,24
        if (strcmp(commands[i].name, argv[0]) == 0) {
ffffffffc02003a2:	69e040ef          	jal	ra,ffffffffc0204a40 <strcmp>
ffffffffc02003a6:	f57d                	bnez	a0,ffffffffc0200394 <kmonitor+0xa2>
            return commands[i].func(argc - 1, argv + 1, tf);
ffffffffc02003a8:	00141793          	slli	a5,s0,0x1
ffffffffc02003ac:	97a2                	add	a5,a5,s0
ffffffffc02003ae:	078e                	slli	a5,a5,0x3
ffffffffc02003b0:	97e2                	add	a5,a5,s8
ffffffffc02003b2:	6b9c                	ld	a5,16(a5)
ffffffffc02003b4:	865e                	mv	a2,s7
ffffffffc02003b6:	002c                	addi	a1,sp,8
ffffffffc02003b8:	fffc851b          	addiw	a0,s9,-1
ffffffffc02003bc:	9782                	jalr	a5
            if (runcmd(buf, tf) < 0) {
ffffffffc02003be:	fa0555e3          	bgez	a0,ffffffffc0200368 <kmonitor+0x76>
}
ffffffffc02003c2:	60ee                	ld	ra,216(sp)
ffffffffc02003c4:	644e                	ld	s0,208(sp)
ffffffffc02003c6:	64ae                	ld	s1,200(sp)
ffffffffc02003c8:	690e                	ld	s2,192(sp)
ffffffffc02003ca:	79ea                	ld	s3,184(sp)
ffffffffc02003cc:	7a4a                	ld	s4,176(sp)
ffffffffc02003ce:	7aaa                	ld	s5,168(sp)
ffffffffc02003d0:	7b0a                	ld	s6,160(sp)
ffffffffc02003d2:	6bea                	ld	s7,152(sp)
ffffffffc02003d4:	6c4a                	ld	s8,144(sp)
ffffffffc02003d6:	6caa                	ld	s9,136(sp)
ffffffffc02003d8:	6d0a                	ld	s10,128(sp)
ffffffffc02003da:	612d                	addi	sp,sp,224
ffffffffc02003dc:	8082                	ret
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
ffffffffc02003de:	8526                	mv	a0,s1
ffffffffc02003e0:	67e040ef          	jal	ra,ffffffffc0204a5e <strchr>
ffffffffc02003e4:	c901                	beqz	a0,ffffffffc02003f4 <kmonitor+0x102>
ffffffffc02003e6:	00144583          	lbu	a1,1(s0)
            *buf ++ = '\0';
ffffffffc02003ea:	00040023          	sb	zero,0(s0)
ffffffffc02003ee:	0405                	addi	s0,s0,1
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
ffffffffc02003f0:	d5c9                	beqz	a1,ffffffffc020037a <kmonitor+0x88>
ffffffffc02003f2:	b7f5                	j	ffffffffc02003de <kmonitor+0xec>
        if (*buf == '\0') {
ffffffffc02003f4:	00044783          	lbu	a5,0(s0)
ffffffffc02003f8:	d3c9                	beqz	a5,ffffffffc020037a <kmonitor+0x88>
        if (argc == MAXARGS - 1) {
ffffffffc02003fa:	033c8963          	beq	s9,s3,ffffffffc020042c <kmonitor+0x13a>
        argv[argc ++] = buf;
ffffffffc02003fe:	003c9793          	slli	a5,s9,0x3
ffffffffc0200402:	0118                	addi	a4,sp,128
ffffffffc0200404:	97ba                	add	a5,a5,a4
ffffffffc0200406:	f887b023          	sd	s0,-128(a5)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
ffffffffc020040a:	00044583          	lbu	a1,0(s0)
        argv[argc ++] = buf;
ffffffffc020040e:	2c85                	addiw	s9,s9,1
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
ffffffffc0200410:	e591                	bnez	a1,ffffffffc020041c <kmonitor+0x12a>
ffffffffc0200412:	b7b5                	j	ffffffffc020037e <kmonitor+0x8c>
ffffffffc0200414:	00144583          	lbu	a1,1(s0)
            buf ++;
ffffffffc0200418:	0405                	addi	s0,s0,1
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
ffffffffc020041a:	d1a5                	beqz	a1,ffffffffc020037a <kmonitor+0x88>
ffffffffc020041c:	8526                	mv	a0,s1
ffffffffc020041e:	640040ef          	jal	ra,ffffffffc0204a5e <strchr>
ffffffffc0200422:	d96d                	beqz	a0,ffffffffc0200414 <kmonitor+0x122>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
ffffffffc0200424:	00044583          	lbu	a1,0(s0)
ffffffffc0200428:	d9a9                	beqz	a1,ffffffffc020037a <kmonitor+0x88>
ffffffffc020042a:	bf55                	j	ffffffffc02003de <kmonitor+0xec>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
ffffffffc020042c:	45c1                	li	a1,16
ffffffffc020042e:	855a                	mv	a0,s6
ffffffffc0200430:	d51ff0ef          	jal	ra,ffffffffc0200180 <cprintf>
ffffffffc0200434:	b7e9                	j	ffffffffc02003fe <kmonitor+0x10c>
    cprintf("Unknown command '%s'\n", argv[0]);
ffffffffc0200436:	6582                	ld	a1,0(sp)
ffffffffc0200438:	00005517          	auipc	a0,0x5
ffffffffc020043c:	8e050513          	addi	a0,a0,-1824 # ffffffffc0204d18 <etext+0x256>
ffffffffc0200440:	d41ff0ef          	jal	ra,ffffffffc0200180 <cprintf>
    return 0;
ffffffffc0200444:	b715                	j	ffffffffc0200368 <kmonitor+0x76>

ffffffffc0200446 <__panic>:
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
    if (is_panic) {
ffffffffc0200446:	00015317          	auipc	t1,0x15
ffffffffc020044a:	0ea30313          	addi	t1,t1,234 # ffffffffc0215530 <is_panic>
ffffffffc020044e:	00032e03          	lw	t3,0(t1)
__panic(const char *file, int line, const char *fmt, ...) {
ffffffffc0200452:	715d                	addi	sp,sp,-80
ffffffffc0200454:	ec06                	sd	ra,24(sp)
ffffffffc0200456:	e822                	sd	s0,16(sp)
ffffffffc0200458:	f436                	sd	a3,40(sp)
ffffffffc020045a:	f83a                	sd	a4,48(sp)
ffffffffc020045c:	fc3e                	sd	a5,56(sp)
ffffffffc020045e:	e0c2                	sd	a6,64(sp)
ffffffffc0200460:	e4c6                	sd	a7,72(sp)
    if (is_panic) {
ffffffffc0200462:	020e1a63          	bnez	t3,ffffffffc0200496 <__panic+0x50>
        goto panic_dead;
    }
    is_panic = 1;
ffffffffc0200466:	4785                	li	a5,1
ffffffffc0200468:	00f32023          	sw	a5,0(t1)

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
ffffffffc020046c:	8432                	mv	s0,a2
ffffffffc020046e:	103c                	addi	a5,sp,40
    cprintf("kernel panic at %s:%d:\n    ", file, line);
ffffffffc0200470:	862e                	mv	a2,a1
ffffffffc0200472:	85aa                	mv	a1,a0
ffffffffc0200474:	00005517          	auipc	a0,0x5
ffffffffc0200478:	90450513          	addi	a0,a0,-1788 # ffffffffc0204d78 <commands+0x48>
    va_start(ap, fmt);
ffffffffc020047c:	e43e                	sd	a5,8(sp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
ffffffffc020047e:	d03ff0ef          	jal	ra,ffffffffc0200180 <cprintf>
    vcprintf(fmt, ap);
ffffffffc0200482:	65a2                	ld	a1,8(sp)
ffffffffc0200484:	8522                	mv	a0,s0
ffffffffc0200486:	cdbff0ef          	jal	ra,ffffffffc0200160 <vcprintf>
    cprintf("\n");
ffffffffc020048a:	00006517          	auipc	a0,0x6
ffffffffc020048e:	85e50513          	addi	a0,a0,-1954 # ffffffffc0205ce8 <default_pmm_manager+0x4d0>
ffffffffc0200492:	cefff0ef          	jal	ra,ffffffffc0200180 <cprintf>
    va_end(ap);

panic_dead:
    intr_disable();
ffffffffc0200496:	108000ef          	jal	ra,ffffffffc020059e <intr_disable>
    while (1) {
        kmonitor(NULL);
ffffffffc020049a:	4501                	li	a0,0
ffffffffc020049c:	e57ff0ef          	jal	ra,ffffffffc02002f2 <kmonitor>
    while (1) {
ffffffffc02004a0:	bfed                	j	ffffffffc020049a <__panic+0x54>

ffffffffc02004a2 <clock_init>:
 * and then enable IRQ_TIMER.
 * */
void clock_init(void) {
    // divided by 500 when using Spike(2MHz)
    // divided by 100 when using QEMU(10MHz)
    timebase = 1e7 / 100;
ffffffffc02004a2:	67e1                	lui	a5,0x18
ffffffffc02004a4:	6a078793          	addi	a5,a5,1696 # 186a0 <kern_entry-0xffffffffc01e7960>
ffffffffc02004a8:	00015717          	auipc	a4,0x15
ffffffffc02004ac:	08f73c23          	sd	a5,152(a4) # ffffffffc0215540 <timebase>
    __asm__ __volatile__("rdtime %0" : "=r"(n));
ffffffffc02004b0:	c0102573          	rdtime	a0
	SBI_CALL_1(SBI_SET_TIMER, stime_value);
ffffffffc02004b4:	4581                	li	a1,0
    ticks = 0;

    cprintf("++ setup timer interrupts\n");
}

void clock_set_next_event(void) { sbi_set_timer(get_cycles() + timebase); }
ffffffffc02004b6:	953e                	add	a0,a0,a5
ffffffffc02004b8:	4601                	li	a2,0
ffffffffc02004ba:	4881                	li	a7,0
ffffffffc02004bc:	00000073          	ecall
    set_csr(sie, MIP_STIP);
ffffffffc02004c0:	02000793          	li	a5,32
ffffffffc02004c4:	1047a7f3          	csrrs	a5,sie,a5
    cprintf("++ setup timer interrupts\n");
ffffffffc02004c8:	00005517          	auipc	a0,0x5
ffffffffc02004cc:	8d050513          	addi	a0,a0,-1840 # ffffffffc0204d98 <commands+0x68>
    ticks = 0;
ffffffffc02004d0:	00015797          	auipc	a5,0x15
ffffffffc02004d4:	0607b423          	sd	zero,104(a5) # ffffffffc0215538 <ticks>
    cprintf("++ setup timer interrupts\n");
ffffffffc02004d8:	b165                	j	ffffffffc0200180 <cprintf>

ffffffffc02004da <clock_set_next_event>:
    __asm__ __volatile__("rdtime %0" : "=r"(n));
ffffffffc02004da:	c0102573          	rdtime	a0
void clock_set_next_event(void) { sbi_set_timer(get_cycles() + timebase); }
ffffffffc02004de:	00015797          	auipc	a5,0x15
ffffffffc02004e2:	0627b783          	ld	a5,98(a5) # ffffffffc0215540 <timebase>
ffffffffc02004e6:	953e                	add	a0,a0,a5
ffffffffc02004e8:	4581                	li	a1,0
ffffffffc02004ea:	4601                	li	a2,0
ffffffffc02004ec:	4881                	li	a7,0
ffffffffc02004ee:	00000073          	ecall
ffffffffc02004f2:	8082                	ret

ffffffffc02004f4 <cons_init>:

/* serial_intr - try to feed input characters from serial port */
void serial_intr(void) {}

/* cons_init - initializes the console devices */
void cons_init(void) {}
ffffffffc02004f4:	8082                	ret

ffffffffc02004f6 <cons_putc>:
#include <defs.h>
#include <intr.h>
#include <riscv.h>

static inline bool __intr_save(void) {
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc02004f6:	100027f3          	csrr	a5,sstatus
ffffffffc02004fa:	8b89                	andi	a5,a5,2
	SBI_CALL_1(SBI_CONSOLE_PUTCHAR, ch);
ffffffffc02004fc:	0ff57513          	zext.b	a0,a0
ffffffffc0200500:	e799                	bnez	a5,ffffffffc020050e <cons_putc+0x18>
ffffffffc0200502:	4581                	li	a1,0
ffffffffc0200504:	4601                	li	a2,0
ffffffffc0200506:	4885                	li	a7,1
ffffffffc0200508:	00000073          	ecall
    }
    return 0;
}

static inline void __intr_restore(bool flag) {
    if (flag) {
ffffffffc020050c:	8082                	ret

/* cons_putc - print a single character @c to console devices */
void cons_putc(int c) {
ffffffffc020050e:	1101                	addi	sp,sp,-32
ffffffffc0200510:	ec06                	sd	ra,24(sp)
ffffffffc0200512:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc0200514:	08a000ef          	jal	ra,ffffffffc020059e <intr_disable>
ffffffffc0200518:	6522                	ld	a0,8(sp)
ffffffffc020051a:	4581                	li	a1,0
ffffffffc020051c:	4601                	li	a2,0
ffffffffc020051e:	4885                	li	a7,1
ffffffffc0200520:	00000073          	ecall
    local_intr_save(intr_flag);
    {
        sbi_console_putchar((unsigned char)c);
    }
    local_intr_restore(intr_flag);
}
ffffffffc0200524:	60e2                	ld	ra,24(sp)
ffffffffc0200526:	6105                	addi	sp,sp,32
        intr_enable();
ffffffffc0200528:	a885                	j	ffffffffc0200598 <intr_enable>

ffffffffc020052a <cons_getc>:
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc020052a:	100027f3          	csrr	a5,sstatus
ffffffffc020052e:	8b89                	andi	a5,a5,2
ffffffffc0200530:	eb89                	bnez	a5,ffffffffc0200542 <cons_getc+0x18>
	return SBI_CALL_0(SBI_CONSOLE_GETCHAR);
ffffffffc0200532:	4501                	li	a0,0
ffffffffc0200534:	4581                	li	a1,0
ffffffffc0200536:	4601                	li	a2,0
ffffffffc0200538:	4889                	li	a7,2
ffffffffc020053a:	00000073          	ecall
ffffffffc020053e:	2501                	sext.w	a0,a0
    {
        c = sbi_console_getchar();
    }
    local_intr_restore(intr_flag);
    return c;
}
ffffffffc0200540:	8082                	ret
int cons_getc(void) {
ffffffffc0200542:	1101                	addi	sp,sp,-32
ffffffffc0200544:	ec06                	sd	ra,24(sp)
        intr_disable();
ffffffffc0200546:	058000ef          	jal	ra,ffffffffc020059e <intr_disable>
ffffffffc020054a:	4501                	li	a0,0
ffffffffc020054c:	4581                	li	a1,0
ffffffffc020054e:	4601                	li	a2,0
ffffffffc0200550:	4889                	li	a7,2
ffffffffc0200552:	00000073          	ecall
ffffffffc0200556:	2501                	sext.w	a0,a0
ffffffffc0200558:	e42a                	sd	a0,8(sp)
        intr_enable();
ffffffffc020055a:	03e000ef          	jal	ra,ffffffffc0200598 <intr_enable>
}
ffffffffc020055e:	60e2                	ld	ra,24(sp)
ffffffffc0200560:	6522                	ld	a0,8(sp)
ffffffffc0200562:	6105                	addi	sp,sp,32
ffffffffc0200564:	8082                	ret

ffffffffc0200566 <ide_init>:
#include <stdio.h>
#include <string.h>
#include <trap.h>
#include <riscv.h>

void ide_init(void) {}
ffffffffc0200566:	8082                	ret

ffffffffc0200568 <ide_device_valid>:

#define MAX_IDE 2
#define MAX_DISK_NSECS 56
static char ide[MAX_DISK_NSECS * SECTSIZE];

bool ide_device_valid(unsigned short ideno) { return ideno < MAX_IDE; }
ffffffffc0200568:	00253513          	sltiu	a0,a0,2
ffffffffc020056c:	8082                	ret

ffffffffc020056e <ide_device_size>:

size_t ide_device_size(unsigned short ideno) { return MAX_DISK_NSECS; }
ffffffffc020056e:	03800513          	li	a0,56
ffffffffc0200572:	8082                	ret

ffffffffc0200574 <ide_write_secs>:
    return 0;
}

int ide_write_secs(unsigned short ideno, uint32_t secno, const void *src,
                   size_t nsecs) {
    int iobase = secno * SECTSIZE;
ffffffffc0200574:	0095979b          	slliw	a5,a1,0x9
    memcpy(&ide[iobase], src, nsecs * SECTSIZE);
ffffffffc0200578:	0000a517          	auipc	a0,0xa
ffffffffc020057c:	ee050513          	addi	a0,a0,-288 # ffffffffc020a458 <ide>
                   size_t nsecs) {
ffffffffc0200580:	1141                	addi	sp,sp,-16
ffffffffc0200582:	85b2                	mv	a1,a2
    memcpy(&ide[iobase], src, nsecs * SECTSIZE);
ffffffffc0200584:	953e                	add	a0,a0,a5
ffffffffc0200586:	00969613          	slli	a2,a3,0x9
                   size_t nsecs) {
ffffffffc020058a:	e406                	sd	ra,8(sp)
    memcpy(&ide[iobase], src, nsecs * SECTSIZE);
ffffffffc020058c:	4fa040ef          	jal	ra,ffffffffc0204a86 <memcpy>
    return 0;
}
ffffffffc0200590:	60a2                	ld	ra,8(sp)
ffffffffc0200592:	4501                	li	a0,0
ffffffffc0200594:	0141                	addi	sp,sp,16
ffffffffc0200596:	8082                	ret

ffffffffc0200598 <intr_enable>:
#include <intr.h>
#include <riscv.h>

/* intr_enable - enable irq interrupt */
void intr_enable(void) { set_csr(sstatus, SSTATUS_SIE); }
ffffffffc0200598:	100167f3          	csrrsi	a5,sstatus,2
ffffffffc020059c:	8082                	ret

ffffffffc020059e <intr_disable>:

/* intr_disable - disable irq interrupt */
void intr_disable(void) { clear_csr(sstatus, SSTATUS_SIE); }
ffffffffc020059e:	100177f3          	csrrci	a5,sstatus,2
ffffffffc02005a2:	8082                	ret

ffffffffc02005a4 <pic_init>:
#include <picirq.h>

void pic_enable(unsigned int irq) {}

/* pic_init - initialize the 8259A interrupt controllers */
void pic_init(void) {}
ffffffffc02005a4:	8082                	ret

ffffffffc02005a6 <pgfault_handler>:
    set_csr(sstatus, SSTATUS_SUM);
}

/* trap_in_kernel - test if trap happened in kernel */
bool trap_in_kernel(struct trapframe *tf) {
    return (tf->status & SSTATUS_SPP) != 0;
ffffffffc02005a6:	10053783          	ld	a5,256(a0)
    cprintf("page falut at 0x%08x: %c/%c\n", tf->badvaddr,
            trap_in_kernel(tf) ? 'K' : 'U',
            tf->cause == CAUSE_STORE_PAGE_FAULT ? 'W' : 'R');
}

static int pgfault_handler(struct trapframe *tf) {
ffffffffc02005aa:	1141                	addi	sp,sp,-16
ffffffffc02005ac:	e022                	sd	s0,0(sp)
ffffffffc02005ae:	e406                	sd	ra,8(sp)
    return (tf->status & SSTATUS_SPP) != 0;
ffffffffc02005b0:	1007f793          	andi	a5,a5,256
    cprintf("page falut at 0x%08x: %c/%c\n", tf->badvaddr,
ffffffffc02005b4:	11053583          	ld	a1,272(a0)
static int pgfault_handler(struct trapframe *tf) {
ffffffffc02005b8:	842a                	mv	s0,a0
    cprintf("page falut at 0x%08x: %c/%c\n", tf->badvaddr,
ffffffffc02005ba:	05500613          	li	a2,85
ffffffffc02005be:	c399                	beqz	a5,ffffffffc02005c4 <pgfault_handler+0x1e>
ffffffffc02005c0:	04b00613          	li	a2,75
ffffffffc02005c4:	11843703          	ld	a4,280(s0)
ffffffffc02005c8:	47bd                	li	a5,15
ffffffffc02005ca:	05700693          	li	a3,87
ffffffffc02005ce:	00f70463          	beq	a4,a5,ffffffffc02005d6 <pgfault_handler+0x30>
ffffffffc02005d2:	05200693          	li	a3,82
ffffffffc02005d6:	00004517          	auipc	a0,0x4
ffffffffc02005da:	7e250513          	addi	a0,a0,2018 # ffffffffc0204db8 <commands+0x88>
ffffffffc02005de:	ba3ff0ef          	jal	ra,ffffffffc0200180 <cprintf>
    extern struct mm_struct *check_mm_struct;
    print_pgfault(tf);
    if (check_mm_struct != NULL) {
ffffffffc02005e2:	00015517          	auipc	a0,0x15
ffffffffc02005e6:	fb653503          	ld	a0,-74(a0) # ffffffffc0215598 <check_mm_struct>
ffffffffc02005ea:	c911                	beqz	a0,ffffffffc02005fe <pgfault_handler+0x58>
        return do_pgfault(check_mm_struct, tf->cause, tf->badvaddr);
ffffffffc02005ec:	11043603          	ld	a2,272(s0)
ffffffffc02005f0:	11842583          	lw	a1,280(s0)
    }
    panic("unhandled page fault.\n");
}
ffffffffc02005f4:	6402                	ld	s0,0(sp)
ffffffffc02005f6:	60a2                	ld	ra,8(sp)
ffffffffc02005f8:	0141                	addi	sp,sp,16
        return do_pgfault(check_mm_struct, tf->cause, tf->badvaddr);
ffffffffc02005fa:	2750306f          	j	ffffffffc020406e <do_pgfault>
    panic("unhandled page fault.\n");
ffffffffc02005fe:	00004617          	auipc	a2,0x4
ffffffffc0200602:	7da60613          	addi	a2,a2,2010 # ffffffffc0204dd8 <commands+0xa8>
ffffffffc0200606:	06200593          	li	a1,98
ffffffffc020060a:	00004517          	auipc	a0,0x4
ffffffffc020060e:	7e650513          	addi	a0,a0,2022 # ffffffffc0204df0 <commands+0xc0>
ffffffffc0200612:	e35ff0ef          	jal	ra,ffffffffc0200446 <__panic>

ffffffffc0200616 <idt_init>:
    write_csr(sscratch, 0);
ffffffffc0200616:	14005073          	csrwi	sscratch,0
    write_csr(stvec, &__alltraps);
ffffffffc020061a:	00000797          	auipc	a5,0x0
ffffffffc020061e:	47a78793          	addi	a5,a5,1146 # ffffffffc0200a94 <__alltraps>
ffffffffc0200622:	10579073          	csrw	stvec,a5
    set_csr(sstatus, SSTATUS_SUM);
ffffffffc0200626:	000407b7          	lui	a5,0x40
ffffffffc020062a:	1007a7f3          	csrrs	a5,sstatus,a5
}
ffffffffc020062e:	8082                	ret

ffffffffc0200630 <print_regs>:
    cprintf("  zero     0x%08x\n", gpr->zero);
ffffffffc0200630:	610c                	ld	a1,0(a0)
void print_regs(struct pushregs *gpr) {
ffffffffc0200632:	1141                	addi	sp,sp,-16
ffffffffc0200634:	e022                	sd	s0,0(sp)
ffffffffc0200636:	842a                	mv	s0,a0
    cprintf("  zero     0x%08x\n", gpr->zero);
ffffffffc0200638:	00004517          	auipc	a0,0x4
ffffffffc020063c:	7d050513          	addi	a0,a0,2000 # ffffffffc0204e08 <commands+0xd8>
void print_regs(struct pushregs *gpr) {
ffffffffc0200640:	e406                	sd	ra,8(sp)
    cprintf("  zero     0x%08x\n", gpr->zero);
ffffffffc0200642:	b3fff0ef          	jal	ra,ffffffffc0200180 <cprintf>
    cprintf("  ra       0x%08x\n", gpr->ra);
ffffffffc0200646:	640c                	ld	a1,8(s0)
ffffffffc0200648:	00004517          	auipc	a0,0x4
ffffffffc020064c:	7d850513          	addi	a0,a0,2008 # ffffffffc0204e20 <commands+0xf0>
ffffffffc0200650:	b31ff0ef          	jal	ra,ffffffffc0200180 <cprintf>
    cprintf("  sp       0x%08x\n", gpr->sp);
ffffffffc0200654:	680c                	ld	a1,16(s0)
ffffffffc0200656:	00004517          	auipc	a0,0x4
ffffffffc020065a:	7e250513          	addi	a0,a0,2018 # ffffffffc0204e38 <commands+0x108>
ffffffffc020065e:	b23ff0ef          	jal	ra,ffffffffc0200180 <cprintf>
    cprintf("  gp       0x%08x\n", gpr->gp);
ffffffffc0200662:	6c0c                	ld	a1,24(s0)
ffffffffc0200664:	00004517          	auipc	a0,0x4
ffffffffc0200668:	7ec50513          	addi	a0,a0,2028 # ffffffffc0204e50 <commands+0x120>
ffffffffc020066c:	b15ff0ef          	jal	ra,ffffffffc0200180 <cprintf>
    cprintf("  tp       0x%08x\n", gpr->tp);
ffffffffc0200670:	700c                	ld	a1,32(s0)
ffffffffc0200672:	00004517          	auipc	a0,0x4
ffffffffc0200676:	7f650513          	addi	a0,a0,2038 # ffffffffc0204e68 <commands+0x138>
ffffffffc020067a:	b07ff0ef          	jal	ra,ffffffffc0200180 <cprintf>
    cprintf("  t0       0x%08x\n", gpr->t0);
ffffffffc020067e:	740c                	ld	a1,40(s0)
ffffffffc0200680:	00005517          	auipc	a0,0x5
ffffffffc0200684:	80050513          	addi	a0,a0,-2048 # ffffffffc0204e80 <commands+0x150>
ffffffffc0200688:	af9ff0ef          	jal	ra,ffffffffc0200180 <cprintf>
    cprintf("  t1       0x%08x\n", gpr->t1);
ffffffffc020068c:	780c                	ld	a1,48(s0)
ffffffffc020068e:	00005517          	auipc	a0,0x5
ffffffffc0200692:	80a50513          	addi	a0,a0,-2038 # ffffffffc0204e98 <commands+0x168>
ffffffffc0200696:	aebff0ef          	jal	ra,ffffffffc0200180 <cprintf>
    cprintf("  t2       0x%08x\n", gpr->t2);
ffffffffc020069a:	7c0c                	ld	a1,56(s0)
ffffffffc020069c:	00005517          	auipc	a0,0x5
ffffffffc02006a0:	81450513          	addi	a0,a0,-2028 # ffffffffc0204eb0 <commands+0x180>
ffffffffc02006a4:	addff0ef          	jal	ra,ffffffffc0200180 <cprintf>
    cprintf("  s0       0x%08x\n", gpr->s0);
ffffffffc02006a8:	602c                	ld	a1,64(s0)
ffffffffc02006aa:	00005517          	auipc	a0,0x5
ffffffffc02006ae:	81e50513          	addi	a0,a0,-2018 # ffffffffc0204ec8 <commands+0x198>
ffffffffc02006b2:	acfff0ef          	jal	ra,ffffffffc0200180 <cprintf>
    cprintf("  s1       0x%08x\n", gpr->s1);
ffffffffc02006b6:	642c                	ld	a1,72(s0)
ffffffffc02006b8:	00005517          	auipc	a0,0x5
ffffffffc02006bc:	82850513          	addi	a0,a0,-2008 # ffffffffc0204ee0 <commands+0x1b0>
ffffffffc02006c0:	ac1ff0ef          	jal	ra,ffffffffc0200180 <cprintf>
    cprintf("  a0       0x%08x\n", gpr->a0);
ffffffffc02006c4:	682c                	ld	a1,80(s0)
ffffffffc02006c6:	00005517          	auipc	a0,0x5
ffffffffc02006ca:	83250513          	addi	a0,a0,-1998 # ffffffffc0204ef8 <commands+0x1c8>
ffffffffc02006ce:	ab3ff0ef          	jal	ra,ffffffffc0200180 <cprintf>
    cprintf("  a1       0x%08x\n", gpr->a1);
ffffffffc02006d2:	6c2c                	ld	a1,88(s0)
ffffffffc02006d4:	00005517          	auipc	a0,0x5
ffffffffc02006d8:	83c50513          	addi	a0,a0,-1988 # ffffffffc0204f10 <commands+0x1e0>
ffffffffc02006dc:	aa5ff0ef          	jal	ra,ffffffffc0200180 <cprintf>
    cprintf("  a2       0x%08x\n", gpr->a2);
ffffffffc02006e0:	702c                	ld	a1,96(s0)
ffffffffc02006e2:	00005517          	auipc	a0,0x5
ffffffffc02006e6:	84650513          	addi	a0,a0,-1978 # ffffffffc0204f28 <commands+0x1f8>
ffffffffc02006ea:	a97ff0ef          	jal	ra,ffffffffc0200180 <cprintf>
    cprintf("  a3       0x%08x\n", gpr->a3);
ffffffffc02006ee:	742c                	ld	a1,104(s0)
ffffffffc02006f0:	00005517          	auipc	a0,0x5
ffffffffc02006f4:	85050513          	addi	a0,a0,-1968 # ffffffffc0204f40 <commands+0x210>
ffffffffc02006f8:	a89ff0ef          	jal	ra,ffffffffc0200180 <cprintf>
    cprintf("  a4       0x%08x\n", gpr->a4);
ffffffffc02006fc:	782c                	ld	a1,112(s0)
ffffffffc02006fe:	00005517          	auipc	a0,0x5
ffffffffc0200702:	85a50513          	addi	a0,a0,-1958 # ffffffffc0204f58 <commands+0x228>
ffffffffc0200706:	a7bff0ef          	jal	ra,ffffffffc0200180 <cprintf>
    cprintf("  a5       0x%08x\n", gpr->a5);
ffffffffc020070a:	7c2c                	ld	a1,120(s0)
ffffffffc020070c:	00005517          	auipc	a0,0x5
ffffffffc0200710:	86450513          	addi	a0,a0,-1948 # ffffffffc0204f70 <commands+0x240>
ffffffffc0200714:	a6dff0ef          	jal	ra,ffffffffc0200180 <cprintf>
    cprintf("  a6       0x%08x\n", gpr->a6);
ffffffffc0200718:	604c                	ld	a1,128(s0)
ffffffffc020071a:	00005517          	auipc	a0,0x5
ffffffffc020071e:	86e50513          	addi	a0,a0,-1938 # ffffffffc0204f88 <commands+0x258>
ffffffffc0200722:	a5fff0ef          	jal	ra,ffffffffc0200180 <cprintf>
    cprintf("  a7       0x%08x\n", gpr->a7);
ffffffffc0200726:	644c                	ld	a1,136(s0)
ffffffffc0200728:	00005517          	auipc	a0,0x5
ffffffffc020072c:	87850513          	addi	a0,a0,-1928 # ffffffffc0204fa0 <commands+0x270>
ffffffffc0200730:	a51ff0ef          	jal	ra,ffffffffc0200180 <cprintf>
    cprintf("  s2       0x%08x\n", gpr->s2);
ffffffffc0200734:	684c                	ld	a1,144(s0)
ffffffffc0200736:	00005517          	auipc	a0,0x5
ffffffffc020073a:	88250513          	addi	a0,a0,-1918 # ffffffffc0204fb8 <commands+0x288>
ffffffffc020073e:	a43ff0ef          	jal	ra,ffffffffc0200180 <cprintf>
    cprintf("  s3       0x%08x\n", gpr->s3);
ffffffffc0200742:	6c4c                	ld	a1,152(s0)
ffffffffc0200744:	00005517          	auipc	a0,0x5
ffffffffc0200748:	88c50513          	addi	a0,a0,-1908 # ffffffffc0204fd0 <commands+0x2a0>
ffffffffc020074c:	a35ff0ef          	jal	ra,ffffffffc0200180 <cprintf>
    cprintf("  s4       0x%08x\n", gpr->s4);
ffffffffc0200750:	704c                	ld	a1,160(s0)
ffffffffc0200752:	00005517          	auipc	a0,0x5
ffffffffc0200756:	89650513          	addi	a0,a0,-1898 # ffffffffc0204fe8 <commands+0x2b8>
ffffffffc020075a:	a27ff0ef          	jal	ra,ffffffffc0200180 <cprintf>
    cprintf("  s5       0x%08x\n", gpr->s5);
ffffffffc020075e:	744c                	ld	a1,168(s0)
ffffffffc0200760:	00005517          	auipc	a0,0x5
ffffffffc0200764:	8a050513          	addi	a0,a0,-1888 # ffffffffc0205000 <commands+0x2d0>
ffffffffc0200768:	a19ff0ef          	jal	ra,ffffffffc0200180 <cprintf>
    cprintf("  s6       0x%08x\n", gpr->s6);
ffffffffc020076c:	784c                	ld	a1,176(s0)
ffffffffc020076e:	00005517          	auipc	a0,0x5
ffffffffc0200772:	8aa50513          	addi	a0,a0,-1878 # ffffffffc0205018 <commands+0x2e8>
ffffffffc0200776:	a0bff0ef          	jal	ra,ffffffffc0200180 <cprintf>
    cprintf("  s7       0x%08x\n", gpr->s7);
ffffffffc020077a:	7c4c                	ld	a1,184(s0)
ffffffffc020077c:	00005517          	auipc	a0,0x5
ffffffffc0200780:	8b450513          	addi	a0,a0,-1868 # ffffffffc0205030 <commands+0x300>
ffffffffc0200784:	9fdff0ef          	jal	ra,ffffffffc0200180 <cprintf>
    cprintf("  s8       0x%08x\n", gpr->s8);
ffffffffc0200788:	606c                	ld	a1,192(s0)
ffffffffc020078a:	00005517          	auipc	a0,0x5
ffffffffc020078e:	8be50513          	addi	a0,a0,-1858 # ffffffffc0205048 <commands+0x318>
ffffffffc0200792:	9efff0ef          	jal	ra,ffffffffc0200180 <cprintf>
    cprintf("  s9       0x%08x\n", gpr->s9);
ffffffffc0200796:	646c                	ld	a1,200(s0)
ffffffffc0200798:	00005517          	auipc	a0,0x5
ffffffffc020079c:	8c850513          	addi	a0,a0,-1848 # ffffffffc0205060 <commands+0x330>
ffffffffc02007a0:	9e1ff0ef          	jal	ra,ffffffffc0200180 <cprintf>
    cprintf("  s10      0x%08x\n", gpr->s10);
ffffffffc02007a4:	686c                	ld	a1,208(s0)
ffffffffc02007a6:	00005517          	auipc	a0,0x5
ffffffffc02007aa:	8d250513          	addi	a0,a0,-1838 # ffffffffc0205078 <commands+0x348>
ffffffffc02007ae:	9d3ff0ef          	jal	ra,ffffffffc0200180 <cprintf>
    cprintf("  s11      0x%08x\n", gpr->s11);
ffffffffc02007b2:	6c6c                	ld	a1,216(s0)
ffffffffc02007b4:	00005517          	auipc	a0,0x5
ffffffffc02007b8:	8dc50513          	addi	a0,a0,-1828 # ffffffffc0205090 <commands+0x360>
ffffffffc02007bc:	9c5ff0ef          	jal	ra,ffffffffc0200180 <cprintf>
    cprintf("  t3       0x%08x\n", gpr->t3);
ffffffffc02007c0:	706c                	ld	a1,224(s0)
ffffffffc02007c2:	00005517          	auipc	a0,0x5
ffffffffc02007c6:	8e650513          	addi	a0,a0,-1818 # ffffffffc02050a8 <commands+0x378>
ffffffffc02007ca:	9b7ff0ef          	jal	ra,ffffffffc0200180 <cprintf>
    cprintf("  t4       0x%08x\n", gpr->t4);
ffffffffc02007ce:	746c                	ld	a1,232(s0)
ffffffffc02007d0:	00005517          	auipc	a0,0x5
ffffffffc02007d4:	8f050513          	addi	a0,a0,-1808 # ffffffffc02050c0 <commands+0x390>
ffffffffc02007d8:	9a9ff0ef          	jal	ra,ffffffffc0200180 <cprintf>
    cprintf("  t5       0x%08x\n", gpr->t5);
ffffffffc02007dc:	786c                	ld	a1,240(s0)
ffffffffc02007de:	00005517          	auipc	a0,0x5
ffffffffc02007e2:	8fa50513          	addi	a0,a0,-1798 # ffffffffc02050d8 <commands+0x3a8>
ffffffffc02007e6:	99bff0ef          	jal	ra,ffffffffc0200180 <cprintf>
    cprintf("  t6       0x%08x\n", gpr->t6);
ffffffffc02007ea:	7c6c                	ld	a1,248(s0)
}
ffffffffc02007ec:	6402                	ld	s0,0(sp)
ffffffffc02007ee:	60a2                	ld	ra,8(sp)
    cprintf("  t6       0x%08x\n", gpr->t6);
ffffffffc02007f0:	00005517          	auipc	a0,0x5
ffffffffc02007f4:	90050513          	addi	a0,a0,-1792 # ffffffffc02050f0 <commands+0x3c0>
}
ffffffffc02007f8:	0141                	addi	sp,sp,16
    cprintf("  t6       0x%08x\n", gpr->t6);
ffffffffc02007fa:	b259                	j	ffffffffc0200180 <cprintf>

ffffffffc02007fc <print_trapframe>:
void print_trapframe(struct trapframe *tf) {
ffffffffc02007fc:	1141                	addi	sp,sp,-16
ffffffffc02007fe:	e022                	sd	s0,0(sp)
    cprintf("trapframe at %p\n", tf);
ffffffffc0200800:	85aa                	mv	a1,a0
void print_trapframe(struct trapframe *tf) {
ffffffffc0200802:	842a                	mv	s0,a0
    cprintf("trapframe at %p\n", tf);
ffffffffc0200804:	00005517          	auipc	a0,0x5
ffffffffc0200808:	90450513          	addi	a0,a0,-1788 # ffffffffc0205108 <commands+0x3d8>
void print_trapframe(struct trapframe *tf) {
ffffffffc020080c:	e406                	sd	ra,8(sp)
    cprintf("trapframe at %p\n", tf);
ffffffffc020080e:	973ff0ef          	jal	ra,ffffffffc0200180 <cprintf>
    print_regs(&tf->gpr);
ffffffffc0200812:	8522                	mv	a0,s0
ffffffffc0200814:	e1dff0ef          	jal	ra,ffffffffc0200630 <print_regs>
    cprintf("  status   0x%08x\n", tf->status);
ffffffffc0200818:	10043583          	ld	a1,256(s0)
ffffffffc020081c:	00005517          	auipc	a0,0x5
ffffffffc0200820:	90450513          	addi	a0,a0,-1788 # ffffffffc0205120 <commands+0x3f0>
ffffffffc0200824:	95dff0ef          	jal	ra,ffffffffc0200180 <cprintf>
    cprintf("  epc      0x%08x\n", tf->epc);
ffffffffc0200828:	10843583          	ld	a1,264(s0)
ffffffffc020082c:	00005517          	auipc	a0,0x5
ffffffffc0200830:	90c50513          	addi	a0,a0,-1780 # ffffffffc0205138 <commands+0x408>
ffffffffc0200834:	94dff0ef          	jal	ra,ffffffffc0200180 <cprintf>
    cprintf("  badvaddr 0x%08x\n", tf->badvaddr);
ffffffffc0200838:	11043583          	ld	a1,272(s0)
ffffffffc020083c:	00005517          	auipc	a0,0x5
ffffffffc0200840:	91450513          	addi	a0,a0,-1772 # ffffffffc0205150 <commands+0x420>
ffffffffc0200844:	93dff0ef          	jal	ra,ffffffffc0200180 <cprintf>
    cprintf("  cause    0x%08x\n", tf->cause);
ffffffffc0200848:	11843583          	ld	a1,280(s0)
}
ffffffffc020084c:	6402                	ld	s0,0(sp)
ffffffffc020084e:	60a2                	ld	ra,8(sp)
    cprintf("  cause    0x%08x\n", tf->cause);
ffffffffc0200850:	00005517          	auipc	a0,0x5
ffffffffc0200854:	91850513          	addi	a0,a0,-1768 # ffffffffc0205168 <commands+0x438>
}
ffffffffc0200858:	0141                	addi	sp,sp,16
    cprintf("  cause    0x%08x\n", tf->cause);
ffffffffc020085a:	927ff06f          	j	ffffffffc0200180 <cprintf>

ffffffffc020085e <interrupt_handler>:

static volatile int in_swap_tick_event = 0;
extern struct mm_struct *check_mm_struct;

void interrupt_handler(struct trapframe *tf) {
    intptr_t cause = (tf->cause << 1) >> 1;
ffffffffc020085e:	11853783          	ld	a5,280(a0)
ffffffffc0200862:	472d                	li	a4,11
ffffffffc0200864:	0786                	slli	a5,a5,0x1
ffffffffc0200866:	8385                	srli	a5,a5,0x1
ffffffffc0200868:	06f76c63          	bltu	a4,a5,ffffffffc02008e0 <interrupt_handler+0x82>
ffffffffc020086c:	00005717          	auipc	a4,0x5
ffffffffc0200870:	9c470713          	addi	a4,a4,-1596 # ffffffffc0205230 <commands+0x500>
ffffffffc0200874:	078a                	slli	a5,a5,0x2
ffffffffc0200876:	97ba                	add	a5,a5,a4
ffffffffc0200878:	439c                	lw	a5,0(a5)
ffffffffc020087a:	97ba                	add	a5,a5,a4
ffffffffc020087c:	8782                	jr	a5
            break;
        case IRQ_H_SOFT:
            cprintf("Hypervisor software interrupt\n");
            break;
        case IRQ_M_SOFT:
            cprintf("Machine software interrupt\n");
ffffffffc020087e:	00005517          	auipc	a0,0x5
ffffffffc0200882:	96250513          	addi	a0,a0,-1694 # ffffffffc02051e0 <commands+0x4b0>
ffffffffc0200886:	8fbff06f          	j	ffffffffc0200180 <cprintf>
            cprintf("Hypervisor software interrupt\n");
ffffffffc020088a:	00005517          	auipc	a0,0x5
ffffffffc020088e:	93650513          	addi	a0,a0,-1738 # ffffffffc02051c0 <commands+0x490>
ffffffffc0200892:	8efff06f          	j	ffffffffc0200180 <cprintf>
            cprintf("User software interrupt\n");
ffffffffc0200896:	00005517          	auipc	a0,0x5
ffffffffc020089a:	8ea50513          	addi	a0,a0,-1814 # ffffffffc0205180 <commands+0x450>
ffffffffc020089e:	8e3ff06f          	j	ffffffffc0200180 <cprintf>
            cprintf("Supervisor software interrupt\n");
ffffffffc02008a2:	00005517          	auipc	a0,0x5
ffffffffc02008a6:	8fe50513          	addi	a0,a0,-1794 # ffffffffc02051a0 <commands+0x470>
ffffffffc02008aa:	8d7ff06f          	j	ffffffffc0200180 <cprintf>
void interrupt_handler(struct trapframe *tf) {
ffffffffc02008ae:	1141                	addi	sp,sp,-16
ffffffffc02008b0:	e406                	sd	ra,8(sp)
            // "All bits besides SSIP and USIP in the sip register are
            // read-only." -- privileged spec1.9.1, 4.1.4, p59
            // In fact, Call sbi_set_timer will clear STIP, or you can clear it
            // directly.
            // clear_csr(sip, SIP_STIP);
            clock_set_next_event();
ffffffffc02008b2:	c29ff0ef          	jal	ra,ffffffffc02004da <clock_set_next_event>
            if (++ticks % TICK_NUM == 0) {
ffffffffc02008b6:	00015697          	auipc	a3,0x15
ffffffffc02008ba:	c8268693          	addi	a3,a3,-894 # ffffffffc0215538 <ticks>
ffffffffc02008be:	629c                	ld	a5,0(a3)
ffffffffc02008c0:	06400713          	li	a4,100
ffffffffc02008c4:	0785                	addi	a5,a5,1
ffffffffc02008c6:	02e7f733          	remu	a4,a5,a4
ffffffffc02008ca:	e29c                	sd	a5,0(a3)
ffffffffc02008cc:	cb19                	beqz	a4,ffffffffc02008e2 <interrupt_handler+0x84>
            break;
        default:
            print_trapframe(tf);
            break;
    }
}
ffffffffc02008ce:	60a2                	ld	ra,8(sp)
ffffffffc02008d0:	0141                	addi	sp,sp,16
ffffffffc02008d2:	8082                	ret
            cprintf("Supervisor external interrupt\n");
ffffffffc02008d4:	00005517          	auipc	a0,0x5
ffffffffc02008d8:	93c50513          	addi	a0,a0,-1732 # ffffffffc0205210 <commands+0x4e0>
ffffffffc02008dc:	8a5ff06f          	j	ffffffffc0200180 <cprintf>
            print_trapframe(tf);
ffffffffc02008e0:	bf31                	j	ffffffffc02007fc <print_trapframe>
}
ffffffffc02008e2:	60a2                	ld	ra,8(sp)
    cprintf("%d ticks\n", TICK_NUM);
ffffffffc02008e4:	06400593          	li	a1,100
ffffffffc02008e8:	00005517          	auipc	a0,0x5
ffffffffc02008ec:	91850513          	addi	a0,a0,-1768 # ffffffffc0205200 <commands+0x4d0>
}
ffffffffc02008f0:	0141                	addi	sp,sp,16
    cprintf("%d ticks\n", TICK_NUM);
ffffffffc02008f2:	88fff06f          	j	ffffffffc0200180 <cprintf>

ffffffffc02008f6 <exception_handler>:

void exception_handler(struct trapframe *tf) {
    int ret;
    switch (tf->cause) {
ffffffffc02008f6:	11853783          	ld	a5,280(a0)
void exception_handler(struct trapframe *tf) {
ffffffffc02008fa:	1101                	addi	sp,sp,-32
ffffffffc02008fc:	e822                	sd	s0,16(sp)
ffffffffc02008fe:	ec06                	sd	ra,24(sp)
ffffffffc0200900:	e426                	sd	s1,8(sp)
ffffffffc0200902:	473d                	li	a4,15
ffffffffc0200904:	842a                	mv	s0,a0
ffffffffc0200906:	14f76a63          	bltu	a4,a5,ffffffffc0200a5a <exception_handler+0x164>
ffffffffc020090a:	00005717          	auipc	a4,0x5
ffffffffc020090e:	b0e70713          	addi	a4,a4,-1266 # ffffffffc0205418 <commands+0x6e8>
ffffffffc0200912:	078a                	slli	a5,a5,0x2
ffffffffc0200914:	97ba                	add	a5,a5,a4
ffffffffc0200916:	439c                	lw	a5,0(a5)
ffffffffc0200918:	97ba                	add	a5,a5,a4
ffffffffc020091a:	8782                	jr	a5
                print_trapframe(tf);
                panic("handle pgfault failed. %e\n", ret);
            }
            break;
        case CAUSE_STORE_PAGE_FAULT:
            cprintf("Store/AMO page fault\n");
ffffffffc020091c:	00005517          	auipc	a0,0x5
ffffffffc0200920:	ae450513          	addi	a0,a0,-1308 # ffffffffc0205400 <commands+0x6d0>
ffffffffc0200924:	85dff0ef          	jal	ra,ffffffffc0200180 <cprintf>
            if ((ret = pgfault_handler(tf)) != 0) {
ffffffffc0200928:	8522                	mv	a0,s0
ffffffffc020092a:	c7dff0ef          	jal	ra,ffffffffc02005a6 <pgfault_handler>
ffffffffc020092e:	84aa                	mv	s1,a0
ffffffffc0200930:	12051b63          	bnez	a0,ffffffffc0200a66 <exception_handler+0x170>
            break;
        default:
            print_trapframe(tf);
            break;
    }
}
ffffffffc0200934:	60e2                	ld	ra,24(sp)
ffffffffc0200936:	6442                	ld	s0,16(sp)
ffffffffc0200938:	64a2                	ld	s1,8(sp)
ffffffffc020093a:	6105                	addi	sp,sp,32
ffffffffc020093c:	8082                	ret
            cprintf("Instruction address misaligned\n");
ffffffffc020093e:	00005517          	auipc	a0,0x5
ffffffffc0200942:	92250513          	addi	a0,a0,-1758 # ffffffffc0205260 <commands+0x530>
}
ffffffffc0200946:	6442                	ld	s0,16(sp)
ffffffffc0200948:	60e2                	ld	ra,24(sp)
ffffffffc020094a:	64a2                	ld	s1,8(sp)
ffffffffc020094c:	6105                	addi	sp,sp,32
            cprintf("Instruction access fault\n");
ffffffffc020094e:	833ff06f          	j	ffffffffc0200180 <cprintf>
ffffffffc0200952:	00005517          	auipc	a0,0x5
ffffffffc0200956:	92e50513          	addi	a0,a0,-1746 # ffffffffc0205280 <commands+0x550>
ffffffffc020095a:	b7f5                	j	ffffffffc0200946 <exception_handler+0x50>
            cprintf("Illegal instruction\n");
ffffffffc020095c:	00005517          	auipc	a0,0x5
ffffffffc0200960:	94450513          	addi	a0,a0,-1724 # ffffffffc02052a0 <commands+0x570>
ffffffffc0200964:	b7cd                	j	ffffffffc0200946 <exception_handler+0x50>
            cprintf("Breakpoint\n");
ffffffffc0200966:	00005517          	auipc	a0,0x5
ffffffffc020096a:	95250513          	addi	a0,a0,-1710 # ffffffffc02052b8 <commands+0x588>
ffffffffc020096e:	bfe1                	j	ffffffffc0200946 <exception_handler+0x50>
            cprintf("Load address misaligned\n");
ffffffffc0200970:	00005517          	auipc	a0,0x5
ffffffffc0200974:	95850513          	addi	a0,a0,-1704 # ffffffffc02052c8 <commands+0x598>
ffffffffc0200978:	b7f9                	j	ffffffffc0200946 <exception_handler+0x50>
            cprintf("Load access fault\n");
ffffffffc020097a:	00005517          	auipc	a0,0x5
ffffffffc020097e:	96e50513          	addi	a0,a0,-1682 # ffffffffc02052e8 <commands+0x5b8>
ffffffffc0200982:	ffeff0ef          	jal	ra,ffffffffc0200180 <cprintf>
            if ((ret = pgfault_handler(tf)) != 0) {
ffffffffc0200986:	8522                	mv	a0,s0
ffffffffc0200988:	c1fff0ef          	jal	ra,ffffffffc02005a6 <pgfault_handler>
ffffffffc020098c:	84aa                	mv	s1,a0
ffffffffc020098e:	d15d                	beqz	a0,ffffffffc0200934 <exception_handler+0x3e>
                print_trapframe(tf);
ffffffffc0200990:	8522                	mv	a0,s0
ffffffffc0200992:	e6bff0ef          	jal	ra,ffffffffc02007fc <print_trapframe>
                panic("handle pgfault failed. %e\n", ret);
ffffffffc0200996:	86a6                	mv	a3,s1
ffffffffc0200998:	00005617          	auipc	a2,0x5
ffffffffc020099c:	96860613          	addi	a2,a2,-1688 # ffffffffc0205300 <commands+0x5d0>
ffffffffc02009a0:	0b300593          	li	a1,179
ffffffffc02009a4:	00004517          	auipc	a0,0x4
ffffffffc02009a8:	44c50513          	addi	a0,a0,1100 # ffffffffc0204df0 <commands+0xc0>
ffffffffc02009ac:	a9bff0ef          	jal	ra,ffffffffc0200446 <__panic>
            cprintf("AMO address misaligned\n");
ffffffffc02009b0:	00005517          	auipc	a0,0x5
ffffffffc02009b4:	97050513          	addi	a0,a0,-1680 # ffffffffc0205320 <commands+0x5f0>
ffffffffc02009b8:	b779                	j	ffffffffc0200946 <exception_handler+0x50>
            cprintf("Store/AMO access fault\n");
ffffffffc02009ba:	00005517          	auipc	a0,0x5
ffffffffc02009be:	97e50513          	addi	a0,a0,-1666 # ffffffffc0205338 <commands+0x608>
ffffffffc02009c2:	fbeff0ef          	jal	ra,ffffffffc0200180 <cprintf>
            if ((ret = pgfault_handler(tf)) != 0) {
ffffffffc02009c6:	8522                	mv	a0,s0
ffffffffc02009c8:	bdfff0ef          	jal	ra,ffffffffc02005a6 <pgfault_handler>
ffffffffc02009cc:	84aa                	mv	s1,a0
ffffffffc02009ce:	d13d                	beqz	a0,ffffffffc0200934 <exception_handler+0x3e>
                print_trapframe(tf);
ffffffffc02009d0:	8522                	mv	a0,s0
ffffffffc02009d2:	e2bff0ef          	jal	ra,ffffffffc02007fc <print_trapframe>
                panic("handle pgfault failed. %e\n", ret);
ffffffffc02009d6:	86a6                	mv	a3,s1
ffffffffc02009d8:	00005617          	auipc	a2,0x5
ffffffffc02009dc:	92860613          	addi	a2,a2,-1752 # ffffffffc0205300 <commands+0x5d0>
ffffffffc02009e0:	0bd00593          	li	a1,189
ffffffffc02009e4:	00004517          	auipc	a0,0x4
ffffffffc02009e8:	40c50513          	addi	a0,a0,1036 # ffffffffc0204df0 <commands+0xc0>
ffffffffc02009ec:	a5bff0ef          	jal	ra,ffffffffc0200446 <__panic>
            cprintf("Environment call from U-mode\n");
ffffffffc02009f0:	00005517          	auipc	a0,0x5
ffffffffc02009f4:	96050513          	addi	a0,a0,-1696 # ffffffffc0205350 <commands+0x620>
ffffffffc02009f8:	b7b9                	j	ffffffffc0200946 <exception_handler+0x50>
            cprintf("Environment call from S-mode\n");
ffffffffc02009fa:	00005517          	auipc	a0,0x5
ffffffffc02009fe:	97650513          	addi	a0,a0,-1674 # ffffffffc0205370 <commands+0x640>
ffffffffc0200a02:	b791                	j	ffffffffc0200946 <exception_handler+0x50>
            cprintf("Environment call from H-mode\n");
ffffffffc0200a04:	00005517          	auipc	a0,0x5
ffffffffc0200a08:	98c50513          	addi	a0,a0,-1652 # ffffffffc0205390 <commands+0x660>
ffffffffc0200a0c:	bf2d                	j	ffffffffc0200946 <exception_handler+0x50>
            cprintf("Environment call from M-mode\n");
ffffffffc0200a0e:	00005517          	auipc	a0,0x5
ffffffffc0200a12:	9a250513          	addi	a0,a0,-1630 # ffffffffc02053b0 <commands+0x680>
ffffffffc0200a16:	bf05                	j	ffffffffc0200946 <exception_handler+0x50>
            cprintf("Instruction page fault\n");
ffffffffc0200a18:	00005517          	auipc	a0,0x5
ffffffffc0200a1c:	9b850513          	addi	a0,a0,-1608 # ffffffffc02053d0 <commands+0x6a0>
ffffffffc0200a20:	b71d                	j	ffffffffc0200946 <exception_handler+0x50>
            cprintf("Load page fault\n");
ffffffffc0200a22:	00005517          	auipc	a0,0x5
ffffffffc0200a26:	9c650513          	addi	a0,a0,-1594 # ffffffffc02053e8 <commands+0x6b8>
ffffffffc0200a2a:	f56ff0ef          	jal	ra,ffffffffc0200180 <cprintf>
            if ((ret = pgfault_handler(tf)) != 0) {
ffffffffc0200a2e:	8522                	mv	a0,s0
ffffffffc0200a30:	b77ff0ef          	jal	ra,ffffffffc02005a6 <pgfault_handler>
ffffffffc0200a34:	84aa                	mv	s1,a0
ffffffffc0200a36:	ee050fe3          	beqz	a0,ffffffffc0200934 <exception_handler+0x3e>
                print_trapframe(tf);
ffffffffc0200a3a:	8522                	mv	a0,s0
ffffffffc0200a3c:	dc1ff0ef          	jal	ra,ffffffffc02007fc <print_trapframe>
                panic("handle pgfault failed. %e\n", ret);
ffffffffc0200a40:	86a6                	mv	a3,s1
ffffffffc0200a42:	00005617          	auipc	a2,0x5
ffffffffc0200a46:	8be60613          	addi	a2,a2,-1858 # ffffffffc0205300 <commands+0x5d0>
ffffffffc0200a4a:	0d300593          	li	a1,211
ffffffffc0200a4e:	00004517          	auipc	a0,0x4
ffffffffc0200a52:	3a250513          	addi	a0,a0,930 # ffffffffc0204df0 <commands+0xc0>
ffffffffc0200a56:	9f1ff0ef          	jal	ra,ffffffffc0200446 <__panic>
            print_trapframe(tf);
ffffffffc0200a5a:	8522                	mv	a0,s0
}
ffffffffc0200a5c:	6442                	ld	s0,16(sp)
ffffffffc0200a5e:	60e2                	ld	ra,24(sp)
ffffffffc0200a60:	64a2                	ld	s1,8(sp)
ffffffffc0200a62:	6105                	addi	sp,sp,32
            print_trapframe(tf);
ffffffffc0200a64:	bb61                	j	ffffffffc02007fc <print_trapframe>
                print_trapframe(tf);
ffffffffc0200a66:	8522                	mv	a0,s0
ffffffffc0200a68:	d95ff0ef          	jal	ra,ffffffffc02007fc <print_trapframe>
                panic("handle pgfault failed. %e\n", ret);
ffffffffc0200a6c:	86a6                	mv	a3,s1
ffffffffc0200a6e:	00005617          	auipc	a2,0x5
ffffffffc0200a72:	89260613          	addi	a2,a2,-1902 # ffffffffc0205300 <commands+0x5d0>
ffffffffc0200a76:	0da00593          	li	a1,218
ffffffffc0200a7a:	00004517          	auipc	a0,0x4
ffffffffc0200a7e:	37650513          	addi	a0,a0,886 # ffffffffc0204df0 <commands+0xc0>
ffffffffc0200a82:	9c5ff0ef          	jal	ra,ffffffffc0200446 <__panic>

ffffffffc0200a86 <trap>:
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void trap(struct trapframe *tf) {
    // dispatch based on what type of trap occurred
    if ((intptr_t)tf->cause < 0) {
ffffffffc0200a86:	11853783          	ld	a5,280(a0)
ffffffffc0200a8a:	0007c363          	bltz	a5,ffffffffc0200a90 <trap+0xa>
        // interrupts
        interrupt_handler(tf);
    } else {
        // exceptions
        exception_handler(tf);
ffffffffc0200a8e:	b5a5                	j	ffffffffc02008f6 <exception_handler>
        interrupt_handler(tf);
ffffffffc0200a90:	b3f9                	j	ffffffffc020085e <interrupt_handler>
	...

ffffffffc0200a94 <__alltraps>:
    LOAD  x2,2*REGBYTES(sp)
    .endm

    .globl __alltraps
__alltraps:
    SAVE_ALL
ffffffffc0200a94:	14011073          	csrw	sscratch,sp
ffffffffc0200a98:	712d                	addi	sp,sp,-288
ffffffffc0200a9a:	e406                	sd	ra,8(sp)
ffffffffc0200a9c:	ec0e                	sd	gp,24(sp)
ffffffffc0200a9e:	f012                	sd	tp,32(sp)
ffffffffc0200aa0:	f416                	sd	t0,40(sp)
ffffffffc0200aa2:	f81a                	sd	t1,48(sp)
ffffffffc0200aa4:	fc1e                	sd	t2,56(sp)
ffffffffc0200aa6:	e0a2                	sd	s0,64(sp)
ffffffffc0200aa8:	e4a6                	sd	s1,72(sp)
ffffffffc0200aaa:	e8aa                	sd	a0,80(sp)
ffffffffc0200aac:	ecae                	sd	a1,88(sp)
ffffffffc0200aae:	f0b2                	sd	a2,96(sp)
ffffffffc0200ab0:	f4b6                	sd	a3,104(sp)
ffffffffc0200ab2:	f8ba                	sd	a4,112(sp)
ffffffffc0200ab4:	fcbe                	sd	a5,120(sp)
ffffffffc0200ab6:	e142                	sd	a6,128(sp)
ffffffffc0200ab8:	e546                	sd	a7,136(sp)
ffffffffc0200aba:	e94a                	sd	s2,144(sp)
ffffffffc0200abc:	ed4e                	sd	s3,152(sp)
ffffffffc0200abe:	f152                	sd	s4,160(sp)
ffffffffc0200ac0:	f556                	sd	s5,168(sp)
ffffffffc0200ac2:	f95a                	sd	s6,176(sp)
ffffffffc0200ac4:	fd5e                	sd	s7,184(sp)
ffffffffc0200ac6:	e1e2                	sd	s8,192(sp)
ffffffffc0200ac8:	e5e6                	sd	s9,200(sp)
ffffffffc0200aca:	e9ea                	sd	s10,208(sp)
ffffffffc0200acc:	edee                	sd	s11,216(sp)
ffffffffc0200ace:	f1f2                	sd	t3,224(sp)
ffffffffc0200ad0:	f5f6                	sd	t4,232(sp)
ffffffffc0200ad2:	f9fa                	sd	t5,240(sp)
ffffffffc0200ad4:	fdfe                	sd	t6,248(sp)
ffffffffc0200ad6:	14002473          	csrr	s0,sscratch
ffffffffc0200ada:	100024f3          	csrr	s1,sstatus
ffffffffc0200ade:	14102973          	csrr	s2,sepc
ffffffffc0200ae2:	143029f3          	csrr	s3,stval
ffffffffc0200ae6:	14202a73          	csrr	s4,scause
ffffffffc0200aea:	e822                	sd	s0,16(sp)
ffffffffc0200aec:	e226                	sd	s1,256(sp)
ffffffffc0200aee:	e64a                	sd	s2,264(sp)
ffffffffc0200af0:	ea4e                	sd	s3,272(sp)
ffffffffc0200af2:	ee52                	sd	s4,280(sp)

    move  a0, sp
ffffffffc0200af4:	850a                	mv	a0,sp
    jal trap
ffffffffc0200af6:	f91ff0ef          	jal	ra,ffffffffc0200a86 <trap>

ffffffffc0200afa <__trapret>:
    # sp should be the same as before "jal trap"

    .globl __trapret
__trapret:
    RESTORE_ALL
ffffffffc0200afa:	6492                	ld	s1,256(sp)
ffffffffc0200afc:	6932                	ld	s2,264(sp)
ffffffffc0200afe:	10049073          	csrw	sstatus,s1
ffffffffc0200b02:	14191073          	csrw	sepc,s2
ffffffffc0200b06:	60a2                	ld	ra,8(sp)
ffffffffc0200b08:	61e2                	ld	gp,24(sp)
ffffffffc0200b0a:	7202                	ld	tp,32(sp)
ffffffffc0200b0c:	72a2                	ld	t0,40(sp)
ffffffffc0200b0e:	7342                	ld	t1,48(sp)
ffffffffc0200b10:	73e2                	ld	t2,56(sp)
ffffffffc0200b12:	6406                	ld	s0,64(sp)
ffffffffc0200b14:	64a6                	ld	s1,72(sp)
ffffffffc0200b16:	6546                	ld	a0,80(sp)
ffffffffc0200b18:	65e6                	ld	a1,88(sp)
ffffffffc0200b1a:	7606                	ld	a2,96(sp)
ffffffffc0200b1c:	76a6                	ld	a3,104(sp)
ffffffffc0200b1e:	7746                	ld	a4,112(sp)
ffffffffc0200b20:	77e6                	ld	a5,120(sp)
ffffffffc0200b22:	680a                	ld	a6,128(sp)
ffffffffc0200b24:	68aa                	ld	a7,136(sp)
ffffffffc0200b26:	694a                	ld	s2,144(sp)
ffffffffc0200b28:	69ea                	ld	s3,152(sp)
ffffffffc0200b2a:	7a0a                	ld	s4,160(sp)
ffffffffc0200b2c:	7aaa                	ld	s5,168(sp)
ffffffffc0200b2e:	7b4a                	ld	s6,176(sp)
ffffffffc0200b30:	7bea                	ld	s7,184(sp)
ffffffffc0200b32:	6c0e                	ld	s8,192(sp)
ffffffffc0200b34:	6cae                	ld	s9,200(sp)
ffffffffc0200b36:	6d4e                	ld	s10,208(sp)
ffffffffc0200b38:	6dee                	ld	s11,216(sp)
ffffffffc0200b3a:	7e0e                	ld	t3,224(sp)
ffffffffc0200b3c:	7eae                	ld	t4,232(sp)
ffffffffc0200b3e:	7f4e                	ld	t5,240(sp)
ffffffffc0200b40:	7fee                	ld	t6,248(sp)
ffffffffc0200b42:	6142                	ld	sp,16(sp)
    # go back from supervisor call
    sret
ffffffffc0200b44:	10200073          	sret

ffffffffc0200b48 <forkrets>:
 
    .globl forkrets
forkrets:
    # set stack to this new process's trapframe
    move sp, a0
ffffffffc0200b48:	812a                	mv	sp,a0
    j __trapret
ffffffffc0200b4a:	bf45                	j	ffffffffc0200afa <__trapret>
	...

ffffffffc0200b4e <default_init>:
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
ffffffffc0200b4e:	00011797          	auipc	a5,0x11
ffffffffc0200b52:	90a78793          	addi	a5,a5,-1782 # ffffffffc0211458 <free_area>
ffffffffc0200b56:	e79c                	sd	a5,8(a5)
ffffffffc0200b58:	e39c                	sd	a5,0(a5)
#define nr_free (free_area.nr_free)

static void
default_init(void) {
    list_init(&free_list);
    nr_free = 0;
ffffffffc0200b5a:	0007a823          	sw	zero,16(a5)
}
ffffffffc0200b5e:	8082                	ret

ffffffffc0200b60 <default_nr_free_pages>:
}

static size_t
default_nr_free_pages(void) {
    return nr_free;
}
ffffffffc0200b60:	00011517          	auipc	a0,0x11
ffffffffc0200b64:	90856503          	lwu	a0,-1784(a0) # ffffffffc0211468 <free_area+0x10>
ffffffffc0200b68:	8082                	ret

ffffffffc0200b6a <default_check>:
}

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1) 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
ffffffffc0200b6a:	715d                	addi	sp,sp,-80
ffffffffc0200b6c:	e0a2                	sd	s0,64(sp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
ffffffffc0200b6e:	00011417          	auipc	s0,0x11
ffffffffc0200b72:	8ea40413          	addi	s0,s0,-1814 # ffffffffc0211458 <free_area>
ffffffffc0200b76:	641c                	ld	a5,8(s0)
ffffffffc0200b78:	e486                	sd	ra,72(sp)
ffffffffc0200b7a:	fc26                	sd	s1,56(sp)
ffffffffc0200b7c:	f84a                	sd	s2,48(sp)
ffffffffc0200b7e:	f44e                	sd	s3,40(sp)
ffffffffc0200b80:	f052                	sd	s4,32(sp)
ffffffffc0200b82:	ec56                	sd	s5,24(sp)
ffffffffc0200b84:	e85a                	sd	s6,16(sp)
ffffffffc0200b86:	e45e                	sd	s7,8(sp)
ffffffffc0200b88:	e062                	sd	s8,0(sp)
    int count = 0, total = 0;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
ffffffffc0200b8a:	2c878763          	beq	a5,s0,ffffffffc0200e58 <default_check+0x2ee>
    int count = 0, total = 0;
ffffffffc0200b8e:	4481                	li	s1,0
ffffffffc0200b90:	4901                	li	s2,0
 * test_bit - Determine whether a bit is set
 * @nr:     the bit to test
 * @addr:   the address to count from
 * */
static inline bool test_bit(int nr, volatile void *addr) {
    return (((*(volatile unsigned long *)addr) >> nr) & 1);
ffffffffc0200b92:	fe87b703          	ld	a4,-24(a5)
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
ffffffffc0200b96:	8b09                	andi	a4,a4,2
ffffffffc0200b98:	2c070463          	beqz	a4,ffffffffc0200e60 <default_check+0x2f6>
        count ++, total += p->property;
ffffffffc0200b9c:	ff87a703          	lw	a4,-8(a5)
ffffffffc0200ba0:	679c                	ld	a5,8(a5)
ffffffffc0200ba2:	2905                	addiw	s2,s2,1
ffffffffc0200ba4:	9cb9                	addw	s1,s1,a4
    while ((le = list_next(le)) != &free_list) {
ffffffffc0200ba6:	fe8796e3          	bne	a5,s0,ffffffffc0200b92 <default_check+0x28>
    }
    assert(total == nr_free_pages());
ffffffffc0200baa:	89a6                	mv	s3,s1
ffffffffc0200bac:	76b000ef          	jal	ra,ffffffffc0201b16 <nr_free_pages>
ffffffffc0200bb0:	71351863          	bne	a0,s3,ffffffffc02012c0 <default_check+0x756>
    assert((p0 = alloc_page()) != NULL);
ffffffffc0200bb4:	4505                	li	a0,1
ffffffffc0200bb6:	68f000ef          	jal	ra,ffffffffc0201a44 <alloc_pages>
ffffffffc0200bba:	8a2a                	mv	s4,a0
ffffffffc0200bbc:	44050263          	beqz	a0,ffffffffc0201000 <default_check+0x496>
    assert((p1 = alloc_page()) != NULL);
ffffffffc0200bc0:	4505                	li	a0,1
ffffffffc0200bc2:	683000ef          	jal	ra,ffffffffc0201a44 <alloc_pages>
ffffffffc0200bc6:	89aa                	mv	s3,a0
ffffffffc0200bc8:	70050c63          	beqz	a0,ffffffffc02012e0 <default_check+0x776>
    assert((p2 = alloc_page()) != NULL);
ffffffffc0200bcc:	4505                	li	a0,1
ffffffffc0200bce:	677000ef          	jal	ra,ffffffffc0201a44 <alloc_pages>
ffffffffc0200bd2:	8aaa                	mv	s5,a0
ffffffffc0200bd4:	4a050663          	beqz	a0,ffffffffc0201080 <default_check+0x516>
    assert(p0 != p1 && p0 != p2 && p1 != p2);
ffffffffc0200bd8:	2b3a0463          	beq	s4,s3,ffffffffc0200e80 <default_check+0x316>
ffffffffc0200bdc:	2aaa0263          	beq	s4,a0,ffffffffc0200e80 <default_check+0x316>
ffffffffc0200be0:	2aa98063          	beq	s3,a0,ffffffffc0200e80 <default_check+0x316>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
ffffffffc0200be4:	000a2783          	lw	a5,0(s4)
ffffffffc0200be8:	2a079c63          	bnez	a5,ffffffffc0200ea0 <default_check+0x336>
ffffffffc0200bec:	0009a783          	lw	a5,0(s3)
ffffffffc0200bf0:	2a079863          	bnez	a5,ffffffffc0200ea0 <default_check+0x336>
ffffffffc0200bf4:	411c                	lw	a5,0(a0)
ffffffffc0200bf6:	2a079563          	bnez	a5,ffffffffc0200ea0 <default_check+0x336>
extern size_t npage;
extern uint_t va_pa_offset;

static inline ppn_t
page2ppn(struct Page *page) {
    return page - pages + nbase;
ffffffffc0200bfa:	00015797          	auipc	a5,0x15
ffffffffc0200bfe:	96e7b783          	ld	a5,-1682(a5) # ffffffffc0215568 <pages>
ffffffffc0200c02:	40fa0733          	sub	a4,s4,a5
ffffffffc0200c06:	870d                	srai	a4,a4,0x3
ffffffffc0200c08:	00006597          	auipc	a1,0x6
ffffffffc0200c0c:	ee05b583          	ld	a1,-288(a1) # ffffffffc0206ae8 <error_string+0x38>
ffffffffc0200c10:	02b70733          	mul	a4,a4,a1
ffffffffc0200c14:	00006617          	auipc	a2,0x6
ffffffffc0200c18:	edc63603          	ld	a2,-292(a2) # ffffffffc0206af0 <nbase>
    assert(page2pa(p0) < npage * PGSIZE);
ffffffffc0200c1c:	00015697          	auipc	a3,0x15
ffffffffc0200c20:	9446b683          	ld	a3,-1724(a3) # ffffffffc0215560 <npage>
ffffffffc0200c24:	06b2                	slli	a3,a3,0xc
ffffffffc0200c26:	9732                	add	a4,a4,a2
}

static inline uintptr_t
page2pa(struct Page *page) {
    return page2ppn(page) << PGSHIFT;
ffffffffc0200c28:	0732                	slli	a4,a4,0xc
ffffffffc0200c2a:	28d77b63          	bgeu	a4,a3,ffffffffc0200ec0 <default_check+0x356>
    return page - pages + nbase;
ffffffffc0200c2e:	40f98733          	sub	a4,s3,a5
ffffffffc0200c32:	870d                	srai	a4,a4,0x3
ffffffffc0200c34:	02b70733          	mul	a4,a4,a1
ffffffffc0200c38:	9732                	add	a4,a4,a2
    return page2ppn(page) << PGSHIFT;
ffffffffc0200c3a:	0732                	slli	a4,a4,0xc
    assert(page2pa(p1) < npage * PGSIZE);
ffffffffc0200c3c:	4cd77263          	bgeu	a4,a3,ffffffffc0201100 <default_check+0x596>
    return page - pages + nbase;
ffffffffc0200c40:	40f507b3          	sub	a5,a0,a5
ffffffffc0200c44:	878d                	srai	a5,a5,0x3
ffffffffc0200c46:	02b787b3          	mul	a5,a5,a1
ffffffffc0200c4a:	97b2                	add	a5,a5,a2
    return page2ppn(page) << PGSHIFT;
ffffffffc0200c4c:	07b2                	slli	a5,a5,0xc
    assert(page2pa(p2) < npage * PGSIZE);
ffffffffc0200c4e:	30d7f963          	bgeu	a5,a3,ffffffffc0200f60 <default_check+0x3f6>
    assert(alloc_page() == NULL);
ffffffffc0200c52:	4505                	li	a0,1
    list_entry_t free_list_store = free_list;
ffffffffc0200c54:	00043c03          	ld	s8,0(s0)
ffffffffc0200c58:	00843b83          	ld	s7,8(s0)
    unsigned int nr_free_store = nr_free;
ffffffffc0200c5c:	01042b03          	lw	s6,16(s0)
    elm->prev = elm->next = elm;
ffffffffc0200c60:	e400                	sd	s0,8(s0)
ffffffffc0200c62:	e000                	sd	s0,0(s0)
    nr_free = 0;
ffffffffc0200c64:	00011797          	auipc	a5,0x11
ffffffffc0200c68:	8007a223          	sw	zero,-2044(a5) # ffffffffc0211468 <free_area+0x10>
    assert(alloc_page() == NULL);
ffffffffc0200c6c:	5d9000ef          	jal	ra,ffffffffc0201a44 <alloc_pages>
ffffffffc0200c70:	2c051863          	bnez	a0,ffffffffc0200f40 <default_check+0x3d6>
    free_page(p0);
ffffffffc0200c74:	4585                	li	a1,1
ffffffffc0200c76:	8552                	mv	a0,s4
ffffffffc0200c78:	65f000ef          	jal	ra,ffffffffc0201ad6 <free_pages>
    free_page(p1);
ffffffffc0200c7c:	4585                	li	a1,1
ffffffffc0200c7e:	854e                	mv	a0,s3
ffffffffc0200c80:	657000ef          	jal	ra,ffffffffc0201ad6 <free_pages>
    free_page(p2);
ffffffffc0200c84:	4585                	li	a1,1
ffffffffc0200c86:	8556                	mv	a0,s5
ffffffffc0200c88:	64f000ef          	jal	ra,ffffffffc0201ad6 <free_pages>
    assert(nr_free == 3);
ffffffffc0200c8c:	4818                	lw	a4,16(s0)
ffffffffc0200c8e:	478d                	li	a5,3
ffffffffc0200c90:	28f71863          	bne	a4,a5,ffffffffc0200f20 <default_check+0x3b6>
    assert((p0 = alloc_page()) != NULL);
ffffffffc0200c94:	4505                	li	a0,1
ffffffffc0200c96:	5af000ef          	jal	ra,ffffffffc0201a44 <alloc_pages>
ffffffffc0200c9a:	89aa                	mv	s3,a0
ffffffffc0200c9c:	26050263          	beqz	a0,ffffffffc0200f00 <default_check+0x396>
    assert((p1 = alloc_page()) != NULL);
ffffffffc0200ca0:	4505                	li	a0,1
ffffffffc0200ca2:	5a3000ef          	jal	ra,ffffffffc0201a44 <alloc_pages>
ffffffffc0200ca6:	8aaa                	mv	s5,a0
ffffffffc0200ca8:	3a050c63          	beqz	a0,ffffffffc0201060 <default_check+0x4f6>
    assert((p2 = alloc_page()) != NULL);
ffffffffc0200cac:	4505                	li	a0,1
ffffffffc0200cae:	597000ef          	jal	ra,ffffffffc0201a44 <alloc_pages>
ffffffffc0200cb2:	8a2a                	mv	s4,a0
ffffffffc0200cb4:	38050663          	beqz	a0,ffffffffc0201040 <default_check+0x4d6>
    assert(alloc_page() == NULL);
ffffffffc0200cb8:	4505                	li	a0,1
ffffffffc0200cba:	58b000ef          	jal	ra,ffffffffc0201a44 <alloc_pages>
ffffffffc0200cbe:	36051163          	bnez	a0,ffffffffc0201020 <default_check+0x4b6>
    free_page(p0);
ffffffffc0200cc2:	4585                	li	a1,1
ffffffffc0200cc4:	854e                	mv	a0,s3
ffffffffc0200cc6:	611000ef          	jal	ra,ffffffffc0201ad6 <free_pages>
    assert(!list_empty(&free_list));
ffffffffc0200cca:	641c                	ld	a5,8(s0)
ffffffffc0200ccc:	20878a63          	beq	a5,s0,ffffffffc0200ee0 <default_check+0x376>
    assert((p = alloc_page()) == p0);
ffffffffc0200cd0:	4505                	li	a0,1
ffffffffc0200cd2:	573000ef          	jal	ra,ffffffffc0201a44 <alloc_pages>
ffffffffc0200cd6:	30a99563          	bne	s3,a0,ffffffffc0200fe0 <default_check+0x476>
    assert(alloc_page() == NULL);
ffffffffc0200cda:	4505                	li	a0,1
ffffffffc0200cdc:	569000ef          	jal	ra,ffffffffc0201a44 <alloc_pages>
ffffffffc0200ce0:	2e051063          	bnez	a0,ffffffffc0200fc0 <default_check+0x456>
    assert(nr_free == 0);
ffffffffc0200ce4:	481c                	lw	a5,16(s0)
ffffffffc0200ce6:	2a079d63          	bnez	a5,ffffffffc0200fa0 <default_check+0x436>
    free_page(p);
ffffffffc0200cea:	854e                	mv	a0,s3
ffffffffc0200cec:	4585                	li	a1,1
    free_list = free_list_store;
ffffffffc0200cee:	01843023          	sd	s8,0(s0)
ffffffffc0200cf2:	01743423          	sd	s7,8(s0)
    nr_free = nr_free_store;
ffffffffc0200cf6:	01642823          	sw	s6,16(s0)
    free_page(p);
ffffffffc0200cfa:	5dd000ef          	jal	ra,ffffffffc0201ad6 <free_pages>
    free_page(p1);
ffffffffc0200cfe:	4585                	li	a1,1
ffffffffc0200d00:	8556                	mv	a0,s5
ffffffffc0200d02:	5d5000ef          	jal	ra,ffffffffc0201ad6 <free_pages>
    free_page(p2);
ffffffffc0200d06:	4585                	li	a1,1
ffffffffc0200d08:	8552                	mv	a0,s4
ffffffffc0200d0a:	5cd000ef          	jal	ra,ffffffffc0201ad6 <free_pages>

    basic_check();

    struct Page *p0 = alloc_pages(5), *p1, *p2;
ffffffffc0200d0e:	4515                	li	a0,5
ffffffffc0200d10:	535000ef          	jal	ra,ffffffffc0201a44 <alloc_pages>
ffffffffc0200d14:	89aa                	mv	s3,a0
    assert(p0 != NULL);
ffffffffc0200d16:	26050563          	beqz	a0,ffffffffc0200f80 <default_check+0x416>
ffffffffc0200d1a:	651c                	ld	a5,8(a0)
ffffffffc0200d1c:	8385                	srli	a5,a5,0x1
    assert(!PageProperty(p0));
ffffffffc0200d1e:	8b85                	andi	a5,a5,1
ffffffffc0200d20:	54079063          	bnez	a5,ffffffffc0201260 <default_check+0x6f6>

    list_entry_t free_list_store = free_list;
    list_init(&free_list);
    assert(list_empty(&free_list));
    assert(alloc_page() == NULL);
ffffffffc0200d24:	4505                	li	a0,1
    list_entry_t free_list_store = free_list;
ffffffffc0200d26:	00043b03          	ld	s6,0(s0)
ffffffffc0200d2a:	00843a83          	ld	s5,8(s0)
ffffffffc0200d2e:	e000                	sd	s0,0(s0)
ffffffffc0200d30:	e400                	sd	s0,8(s0)
    assert(alloc_page() == NULL);
ffffffffc0200d32:	513000ef          	jal	ra,ffffffffc0201a44 <alloc_pages>
ffffffffc0200d36:	50051563          	bnez	a0,ffffffffc0201240 <default_check+0x6d6>

    unsigned int nr_free_store = nr_free;
    nr_free = 0;

    free_pages(p0 + 2, 3);
ffffffffc0200d3a:	09098a13          	addi	s4,s3,144
ffffffffc0200d3e:	8552                	mv	a0,s4
ffffffffc0200d40:	458d                	li	a1,3
    unsigned int nr_free_store = nr_free;
ffffffffc0200d42:	01042b83          	lw	s7,16(s0)
    nr_free = 0;
ffffffffc0200d46:	00010797          	auipc	a5,0x10
ffffffffc0200d4a:	7207a123          	sw	zero,1826(a5) # ffffffffc0211468 <free_area+0x10>
    free_pages(p0 + 2, 3);
ffffffffc0200d4e:	589000ef          	jal	ra,ffffffffc0201ad6 <free_pages>
    assert(alloc_pages(4) == NULL);
ffffffffc0200d52:	4511                	li	a0,4
ffffffffc0200d54:	4f1000ef          	jal	ra,ffffffffc0201a44 <alloc_pages>
ffffffffc0200d58:	4c051463          	bnez	a0,ffffffffc0201220 <default_check+0x6b6>
ffffffffc0200d5c:	0989b783          	ld	a5,152(s3)
ffffffffc0200d60:	8385                	srli	a5,a5,0x1
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
ffffffffc0200d62:	8b85                	andi	a5,a5,1
ffffffffc0200d64:	48078e63          	beqz	a5,ffffffffc0201200 <default_check+0x696>
ffffffffc0200d68:	0a89a703          	lw	a4,168(s3)
ffffffffc0200d6c:	478d                	li	a5,3
ffffffffc0200d6e:	48f71963          	bne	a4,a5,ffffffffc0201200 <default_check+0x696>
    assert((p1 = alloc_pages(3)) != NULL);
ffffffffc0200d72:	450d                	li	a0,3
ffffffffc0200d74:	4d1000ef          	jal	ra,ffffffffc0201a44 <alloc_pages>
ffffffffc0200d78:	8c2a                	mv	s8,a0
ffffffffc0200d7a:	46050363          	beqz	a0,ffffffffc02011e0 <default_check+0x676>
    assert(alloc_page() == NULL);
ffffffffc0200d7e:	4505                	li	a0,1
ffffffffc0200d80:	4c5000ef          	jal	ra,ffffffffc0201a44 <alloc_pages>
ffffffffc0200d84:	42051e63          	bnez	a0,ffffffffc02011c0 <default_check+0x656>
    assert(p0 + 2 == p1);
ffffffffc0200d88:	418a1c63          	bne	s4,s8,ffffffffc02011a0 <default_check+0x636>

    p2 = p0 + 1;
    free_page(p0);
ffffffffc0200d8c:	4585                	li	a1,1
ffffffffc0200d8e:	854e                	mv	a0,s3
ffffffffc0200d90:	547000ef          	jal	ra,ffffffffc0201ad6 <free_pages>
    free_pages(p1, 3);
ffffffffc0200d94:	458d                	li	a1,3
ffffffffc0200d96:	8552                	mv	a0,s4
ffffffffc0200d98:	53f000ef          	jal	ra,ffffffffc0201ad6 <free_pages>
ffffffffc0200d9c:	0089b783          	ld	a5,8(s3)
    p2 = p0 + 1;
ffffffffc0200da0:	04898c13          	addi	s8,s3,72
ffffffffc0200da4:	8385                	srli	a5,a5,0x1
    assert(PageProperty(p0) && p0->property == 1);
ffffffffc0200da6:	8b85                	andi	a5,a5,1
ffffffffc0200da8:	3c078c63          	beqz	a5,ffffffffc0201180 <default_check+0x616>
ffffffffc0200dac:	0189a703          	lw	a4,24(s3)
ffffffffc0200db0:	4785                	li	a5,1
ffffffffc0200db2:	3cf71763          	bne	a4,a5,ffffffffc0201180 <default_check+0x616>
ffffffffc0200db6:	008a3783          	ld	a5,8(s4)
ffffffffc0200dba:	8385                	srli	a5,a5,0x1
    assert(PageProperty(p1) && p1->property == 3);
ffffffffc0200dbc:	8b85                	andi	a5,a5,1
ffffffffc0200dbe:	3a078163          	beqz	a5,ffffffffc0201160 <default_check+0x5f6>
ffffffffc0200dc2:	018a2703          	lw	a4,24(s4)
ffffffffc0200dc6:	478d                	li	a5,3
ffffffffc0200dc8:	38f71c63          	bne	a4,a5,ffffffffc0201160 <default_check+0x5f6>

    assert((p0 = alloc_page()) == p2 - 1);
ffffffffc0200dcc:	4505                	li	a0,1
ffffffffc0200dce:	477000ef          	jal	ra,ffffffffc0201a44 <alloc_pages>
ffffffffc0200dd2:	36a99763          	bne	s3,a0,ffffffffc0201140 <default_check+0x5d6>
    free_page(p0);
ffffffffc0200dd6:	4585                	li	a1,1
ffffffffc0200dd8:	4ff000ef          	jal	ra,ffffffffc0201ad6 <free_pages>
    assert((p0 = alloc_pages(2)) == p2 + 1);
ffffffffc0200ddc:	4509                	li	a0,2
ffffffffc0200dde:	467000ef          	jal	ra,ffffffffc0201a44 <alloc_pages>
ffffffffc0200de2:	32aa1f63          	bne	s4,a0,ffffffffc0201120 <default_check+0x5b6>

    free_pages(p0, 2);
ffffffffc0200de6:	4589                	li	a1,2
ffffffffc0200de8:	4ef000ef          	jal	ra,ffffffffc0201ad6 <free_pages>
    free_page(p2);
ffffffffc0200dec:	4585                	li	a1,1
ffffffffc0200dee:	8562                	mv	a0,s8
ffffffffc0200df0:	4e7000ef          	jal	ra,ffffffffc0201ad6 <free_pages>

    assert((p0 = alloc_pages(5)) != NULL);
ffffffffc0200df4:	4515                	li	a0,5
ffffffffc0200df6:	44f000ef          	jal	ra,ffffffffc0201a44 <alloc_pages>
ffffffffc0200dfa:	89aa                	mv	s3,a0
ffffffffc0200dfc:	48050263          	beqz	a0,ffffffffc0201280 <default_check+0x716>
    assert(alloc_page() == NULL);
ffffffffc0200e00:	4505                	li	a0,1
ffffffffc0200e02:	443000ef          	jal	ra,ffffffffc0201a44 <alloc_pages>
ffffffffc0200e06:	2c051d63          	bnez	a0,ffffffffc02010e0 <default_check+0x576>

    assert(nr_free == 0);
ffffffffc0200e0a:	481c                	lw	a5,16(s0)
ffffffffc0200e0c:	2a079a63          	bnez	a5,ffffffffc02010c0 <default_check+0x556>
    nr_free = nr_free_store;

    free_list = free_list_store;
    free_pages(p0, 5);
ffffffffc0200e10:	4595                	li	a1,5
ffffffffc0200e12:	854e                	mv	a0,s3
    nr_free = nr_free_store;
ffffffffc0200e14:	01742823          	sw	s7,16(s0)
    free_list = free_list_store;
ffffffffc0200e18:	01643023          	sd	s6,0(s0)
ffffffffc0200e1c:	01543423          	sd	s5,8(s0)
    free_pages(p0, 5);
ffffffffc0200e20:	4b7000ef          	jal	ra,ffffffffc0201ad6 <free_pages>
    return listelm->next;
ffffffffc0200e24:	641c                	ld	a5,8(s0)

    le = &free_list;
    while ((le = list_next(le)) != &free_list) {
ffffffffc0200e26:	00878963          	beq	a5,s0,ffffffffc0200e38 <default_check+0x2ce>
        struct Page *p = le2page(le, page_link);
        count --, total -= p->property;
ffffffffc0200e2a:	ff87a703          	lw	a4,-8(a5)
ffffffffc0200e2e:	679c                	ld	a5,8(a5)
ffffffffc0200e30:	397d                	addiw	s2,s2,-1
ffffffffc0200e32:	9c99                	subw	s1,s1,a4
    while ((le = list_next(le)) != &free_list) {
ffffffffc0200e34:	fe879be3          	bne	a5,s0,ffffffffc0200e2a <default_check+0x2c0>
    }
    assert(count == 0);
ffffffffc0200e38:	26091463          	bnez	s2,ffffffffc02010a0 <default_check+0x536>
    assert(total == 0);
ffffffffc0200e3c:	46049263          	bnez	s1,ffffffffc02012a0 <default_check+0x736>
}
ffffffffc0200e40:	60a6                	ld	ra,72(sp)
ffffffffc0200e42:	6406                	ld	s0,64(sp)
ffffffffc0200e44:	74e2                	ld	s1,56(sp)
ffffffffc0200e46:	7942                	ld	s2,48(sp)
ffffffffc0200e48:	79a2                	ld	s3,40(sp)
ffffffffc0200e4a:	7a02                	ld	s4,32(sp)
ffffffffc0200e4c:	6ae2                	ld	s5,24(sp)
ffffffffc0200e4e:	6b42                	ld	s6,16(sp)
ffffffffc0200e50:	6ba2                	ld	s7,8(sp)
ffffffffc0200e52:	6c02                	ld	s8,0(sp)
ffffffffc0200e54:	6161                	addi	sp,sp,80
ffffffffc0200e56:	8082                	ret
    while ((le = list_next(le)) != &free_list) {
ffffffffc0200e58:	4981                	li	s3,0
    int count = 0, total = 0;
ffffffffc0200e5a:	4481                	li	s1,0
ffffffffc0200e5c:	4901                	li	s2,0
ffffffffc0200e5e:	b3b9                	j	ffffffffc0200bac <default_check+0x42>
        assert(PageProperty(p));
ffffffffc0200e60:	00004697          	auipc	a3,0x4
ffffffffc0200e64:	5f868693          	addi	a3,a3,1528 # ffffffffc0205458 <commands+0x728>
ffffffffc0200e68:	00004617          	auipc	a2,0x4
ffffffffc0200e6c:	60060613          	addi	a2,a2,1536 # ffffffffc0205468 <commands+0x738>
ffffffffc0200e70:	0f000593          	li	a1,240
ffffffffc0200e74:	00004517          	auipc	a0,0x4
ffffffffc0200e78:	60c50513          	addi	a0,a0,1548 # ffffffffc0205480 <commands+0x750>
ffffffffc0200e7c:	dcaff0ef          	jal	ra,ffffffffc0200446 <__panic>
    assert(p0 != p1 && p0 != p2 && p1 != p2);
ffffffffc0200e80:	00004697          	auipc	a3,0x4
ffffffffc0200e84:	69868693          	addi	a3,a3,1688 # ffffffffc0205518 <commands+0x7e8>
ffffffffc0200e88:	00004617          	auipc	a2,0x4
ffffffffc0200e8c:	5e060613          	addi	a2,a2,1504 # ffffffffc0205468 <commands+0x738>
ffffffffc0200e90:	0bd00593          	li	a1,189
ffffffffc0200e94:	00004517          	auipc	a0,0x4
ffffffffc0200e98:	5ec50513          	addi	a0,a0,1516 # ffffffffc0205480 <commands+0x750>
ffffffffc0200e9c:	daaff0ef          	jal	ra,ffffffffc0200446 <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
ffffffffc0200ea0:	00004697          	auipc	a3,0x4
ffffffffc0200ea4:	6a068693          	addi	a3,a3,1696 # ffffffffc0205540 <commands+0x810>
ffffffffc0200ea8:	00004617          	auipc	a2,0x4
ffffffffc0200eac:	5c060613          	addi	a2,a2,1472 # ffffffffc0205468 <commands+0x738>
ffffffffc0200eb0:	0be00593          	li	a1,190
ffffffffc0200eb4:	00004517          	auipc	a0,0x4
ffffffffc0200eb8:	5cc50513          	addi	a0,a0,1484 # ffffffffc0205480 <commands+0x750>
ffffffffc0200ebc:	d8aff0ef          	jal	ra,ffffffffc0200446 <__panic>
    assert(page2pa(p0) < npage * PGSIZE);
ffffffffc0200ec0:	00004697          	auipc	a3,0x4
ffffffffc0200ec4:	6c068693          	addi	a3,a3,1728 # ffffffffc0205580 <commands+0x850>
ffffffffc0200ec8:	00004617          	auipc	a2,0x4
ffffffffc0200ecc:	5a060613          	addi	a2,a2,1440 # ffffffffc0205468 <commands+0x738>
ffffffffc0200ed0:	0c000593          	li	a1,192
ffffffffc0200ed4:	00004517          	auipc	a0,0x4
ffffffffc0200ed8:	5ac50513          	addi	a0,a0,1452 # ffffffffc0205480 <commands+0x750>
ffffffffc0200edc:	d6aff0ef          	jal	ra,ffffffffc0200446 <__panic>
    assert(!list_empty(&free_list));
ffffffffc0200ee0:	00004697          	auipc	a3,0x4
ffffffffc0200ee4:	72868693          	addi	a3,a3,1832 # ffffffffc0205608 <commands+0x8d8>
ffffffffc0200ee8:	00004617          	auipc	a2,0x4
ffffffffc0200eec:	58060613          	addi	a2,a2,1408 # ffffffffc0205468 <commands+0x738>
ffffffffc0200ef0:	0d900593          	li	a1,217
ffffffffc0200ef4:	00004517          	auipc	a0,0x4
ffffffffc0200ef8:	58c50513          	addi	a0,a0,1420 # ffffffffc0205480 <commands+0x750>
ffffffffc0200efc:	d4aff0ef          	jal	ra,ffffffffc0200446 <__panic>
    assert((p0 = alloc_page()) != NULL);
ffffffffc0200f00:	00004697          	auipc	a3,0x4
ffffffffc0200f04:	5b868693          	addi	a3,a3,1464 # ffffffffc02054b8 <commands+0x788>
ffffffffc0200f08:	00004617          	auipc	a2,0x4
ffffffffc0200f0c:	56060613          	addi	a2,a2,1376 # ffffffffc0205468 <commands+0x738>
ffffffffc0200f10:	0d200593          	li	a1,210
ffffffffc0200f14:	00004517          	auipc	a0,0x4
ffffffffc0200f18:	56c50513          	addi	a0,a0,1388 # ffffffffc0205480 <commands+0x750>
ffffffffc0200f1c:	d2aff0ef          	jal	ra,ffffffffc0200446 <__panic>
    assert(nr_free == 3);
ffffffffc0200f20:	00004697          	auipc	a3,0x4
ffffffffc0200f24:	6d868693          	addi	a3,a3,1752 # ffffffffc02055f8 <commands+0x8c8>
ffffffffc0200f28:	00004617          	auipc	a2,0x4
ffffffffc0200f2c:	54060613          	addi	a2,a2,1344 # ffffffffc0205468 <commands+0x738>
ffffffffc0200f30:	0d000593          	li	a1,208
ffffffffc0200f34:	00004517          	auipc	a0,0x4
ffffffffc0200f38:	54c50513          	addi	a0,a0,1356 # ffffffffc0205480 <commands+0x750>
ffffffffc0200f3c:	d0aff0ef          	jal	ra,ffffffffc0200446 <__panic>
    assert(alloc_page() == NULL);
ffffffffc0200f40:	00004697          	auipc	a3,0x4
ffffffffc0200f44:	6a068693          	addi	a3,a3,1696 # ffffffffc02055e0 <commands+0x8b0>
ffffffffc0200f48:	00004617          	auipc	a2,0x4
ffffffffc0200f4c:	52060613          	addi	a2,a2,1312 # ffffffffc0205468 <commands+0x738>
ffffffffc0200f50:	0cb00593          	li	a1,203
ffffffffc0200f54:	00004517          	auipc	a0,0x4
ffffffffc0200f58:	52c50513          	addi	a0,a0,1324 # ffffffffc0205480 <commands+0x750>
ffffffffc0200f5c:	ceaff0ef          	jal	ra,ffffffffc0200446 <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
ffffffffc0200f60:	00004697          	auipc	a3,0x4
ffffffffc0200f64:	66068693          	addi	a3,a3,1632 # ffffffffc02055c0 <commands+0x890>
ffffffffc0200f68:	00004617          	auipc	a2,0x4
ffffffffc0200f6c:	50060613          	addi	a2,a2,1280 # ffffffffc0205468 <commands+0x738>
ffffffffc0200f70:	0c200593          	li	a1,194
ffffffffc0200f74:	00004517          	auipc	a0,0x4
ffffffffc0200f78:	50c50513          	addi	a0,a0,1292 # ffffffffc0205480 <commands+0x750>
ffffffffc0200f7c:	ccaff0ef          	jal	ra,ffffffffc0200446 <__panic>
    assert(p0 != NULL);
ffffffffc0200f80:	00004697          	auipc	a3,0x4
ffffffffc0200f84:	6d068693          	addi	a3,a3,1744 # ffffffffc0205650 <commands+0x920>
ffffffffc0200f88:	00004617          	auipc	a2,0x4
ffffffffc0200f8c:	4e060613          	addi	a2,a2,1248 # ffffffffc0205468 <commands+0x738>
ffffffffc0200f90:	0f800593          	li	a1,248
ffffffffc0200f94:	00004517          	auipc	a0,0x4
ffffffffc0200f98:	4ec50513          	addi	a0,a0,1260 # ffffffffc0205480 <commands+0x750>
ffffffffc0200f9c:	caaff0ef          	jal	ra,ffffffffc0200446 <__panic>
    assert(nr_free == 0);
ffffffffc0200fa0:	00004697          	auipc	a3,0x4
ffffffffc0200fa4:	6a068693          	addi	a3,a3,1696 # ffffffffc0205640 <commands+0x910>
ffffffffc0200fa8:	00004617          	auipc	a2,0x4
ffffffffc0200fac:	4c060613          	addi	a2,a2,1216 # ffffffffc0205468 <commands+0x738>
ffffffffc0200fb0:	0df00593          	li	a1,223
ffffffffc0200fb4:	00004517          	auipc	a0,0x4
ffffffffc0200fb8:	4cc50513          	addi	a0,a0,1228 # ffffffffc0205480 <commands+0x750>
ffffffffc0200fbc:	c8aff0ef          	jal	ra,ffffffffc0200446 <__panic>
    assert(alloc_page() == NULL);
ffffffffc0200fc0:	00004697          	auipc	a3,0x4
ffffffffc0200fc4:	62068693          	addi	a3,a3,1568 # ffffffffc02055e0 <commands+0x8b0>
ffffffffc0200fc8:	00004617          	auipc	a2,0x4
ffffffffc0200fcc:	4a060613          	addi	a2,a2,1184 # ffffffffc0205468 <commands+0x738>
ffffffffc0200fd0:	0dd00593          	li	a1,221
ffffffffc0200fd4:	00004517          	auipc	a0,0x4
ffffffffc0200fd8:	4ac50513          	addi	a0,a0,1196 # ffffffffc0205480 <commands+0x750>
ffffffffc0200fdc:	c6aff0ef          	jal	ra,ffffffffc0200446 <__panic>
    assert((p = alloc_page()) == p0);
ffffffffc0200fe0:	00004697          	auipc	a3,0x4
ffffffffc0200fe4:	64068693          	addi	a3,a3,1600 # ffffffffc0205620 <commands+0x8f0>
ffffffffc0200fe8:	00004617          	auipc	a2,0x4
ffffffffc0200fec:	48060613          	addi	a2,a2,1152 # ffffffffc0205468 <commands+0x738>
ffffffffc0200ff0:	0dc00593          	li	a1,220
ffffffffc0200ff4:	00004517          	auipc	a0,0x4
ffffffffc0200ff8:	48c50513          	addi	a0,a0,1164 # ffffffffc0205480 <commands+0x750>
ffffffffc0200ffc:	c4aff0ef          	jal	ra,ffffffffc0200446 <__panic>
    assert((p0 = alloc_page()) != NULL);
ffffffffc0201000:	00004697          	auipc	a3,0x4
ffffffffc0201004:	4b868693          	addi	a3,a3,1208 # ffffffffc02054b8 <commands+0x788>
ffffffffc0201008:	00004617          	auipc	a2,0x4
ffffffffc020100c:	46060613          	addi	a2,a2,1120 # ffffffffc0205468 <commands+0x738>
ffffffffc0201010:	0b900593          	li	a1,185
ffffffffc0201014:	00004517          	auipc	a0,0x4
ffffffffc0201018:	46c50513          	addi	a0,a0,1132 # ffffffffc0205480 <commands+0x750>
ffffffffc020101c:	c2aff0ef          	jal	ra,ffffffffc0200446 <__panic>
    assert(alloc_page() == NULL);
ffffffffc0201020:	00004697          	auipc	a3,0x4
ffffffffc0201024:	5c068693          	addi	a3,a3,1472 # ffffffffc02055e0 <commands+0x8b0>
ffffffffc0201028:	00004617          	auipc	a2,0x4
ffffffffc020102c:	44060613          	addi	a2,a2,1088 # ffffffffc0205468 <commands+0x738>
ffffffffc0201030:	0d600593          	li	a1,214
ffffffffc0201034:	00004517          	auipc	a0,0x4
ffffffffc0201038:	44c50513          	addi	a0,a0,1100 # ffffffffc0205480 <commands+0x750>
ffffffffc020103c:	c0aff0ef          	jal	ra,ffffffffc0200446 <__panic>
    assert((p2 = alloc_page()) != NULL);
ffffffffc0201040:	00004697          	auipc	a3,0x4
ffffffffc0201044:	4b868693          	addi	a3,a3,1208 # ffffffffc02054f8 <commands+0x7c8>
ffffffffc0201048:	00004617          	auipc	a2,0x4
ffffffffc020104c:	42060613          	addi	a2,a2,1056 # ffffffffc0205468 <commands+0x738>
ffffffffc0201050:	0d400593          	li	a1,212
ffffffffc0201054:	00004517          	auipc	a0,0x4
ffffffffc0201058:	42c50513          	addi	a0,a0,1068 # ffffffffc0205480 <commands+0x750>
ffffffffc020105c:	beaff0ef          	jal	ra,ffffffffc0200446 <__panic>
    assert((p1 = alloc_page()) != NULL);
ffffffffc0201060:	00004697          	auipc	a3,0x4
ffffffffc0201064:	47868693          	addi	a3,a3,1144 # ffffffffc02054d8 <commands+0x7a8>
ffffffffc0201068:	00004617          	auipc	a2,0x4
ffffffffc020106c:	40060613          	addi	a2,a2,1024 # ffffffffc0205468 <commands+0x738>
ffffffffc0201070:	0d300593          	li	a1,211
ffffffffc0201074:	00004517          	auipc	a0,0x4
ffffffffc0201078:	40c50513          	addi	a0,a0,1036 # ffffffffc0205480 <commands+0x750>
ffffffffc020107c:	bcaff0ef          	jal	ra,ffffffffc0200446 <__panic>
    assert((p2 = alloc_page()) != NULL);
ffffffffc0201080:	00004697          	auipc	a3,0x4
ffffffffc0201084:	47868693          	addi	a3,a3,1144 # ffffffffc02054f8 <commands+0x7c8>
ffffffffc0201088:	00004617          	auipc	a2,0x4
ffffffffc020108c:	3e060613          	addi	a2,a2,992 # ffffffffc0205468 <commands+0x738>
ffffffffc0201090:	0bb00593          	li	a1,187
ffffffffc0201094:	00004517          	auipc	a0,0x4
ffffffffc0201098:	3ec50513          	addi	a0,a0,1004 # ffffffffc0205480 <commands+0x750>
ffffffffc020109c:	baaff0ef          	jal	ra,ffffffffc0200446 <__panic>
    assert(count == 0);
ffffffffc02010a0:	00004697          	auipc	a3,0x4
ffffffffc02010a4:	70068693          	addi	a3,a3,1792 # ffffffffc02057a0 <commands+0xa70>
ffffffffc02010a8:	00004617          	auipc	a2,0x4
ffffffffc02010ac:	3c060613          	addi	a2,a2,960 # ffffffffc0205468 <commands+0x738>
ffffffffc02010b0:	12500593          	li	a1,293
ffffffffc02010b4:	00004517          	auipc	a0,0x4
ffffffffc02010b8:	3cc50513          	addi	a0,a0,972 # ffffffffc0205480 <commands+0x750>
ffffffffc02010bc:	b8aff0ef          	jal	ra,ffffffffc0200446 <__panic>
    assert(nr_free == 0);
ffffffffc02010c0:	00004697          	auipc	a3,0x4
ffffffffc02010c4:	58068693          	addi	a3,a3,1408 # ffffffffc0205640 <commands+0x910>
ffffffffc02010c8:	00004617          	auipc	a2,0x4
ffffffffc02010cc:	3a060613          	addi	a2,a2,928 # ffffffffc0205468 <commands+0x738>
ffffffffc02010d0:	11a00593          	li	a1,282
ffffffffc02010d4:	00004517          	auipc	a0,0x4
ffffffffc02010d8:	3ac50513          	addi	a0,a0,940 # ffffffffc0205480 <commands+0x750>
ffffffffc02010dc:	b6aff0ef          	jal	ra,ffffffffc0200446 <__panic>
    assert(alloc_page() == NULL);
ffffffffc02010e0:	00004697          	auipc	a3,0x4
ffffffffc02010e4:	50068693          	addi	a3,a3,1280 # ffffffffc02055e0 <commands+0x8b0>
ffffffffc02010e8:	00004617          	auipc	a2,0x4
ffffffffc02010ec:	38060613          	addi	a2,a2,896 # ffffffffc0205468 <commands+0x738>
ffffffffc02010f0:	11800593          	li	a1,280
ffffffffc02010f4:	00004517          	auipc	a0,0x4
ffffffffc02010f8:	38c50513          	addi	a0,a0,908 # ffffffffc0205480 <commands+0x750>
ffffffffc02010fc:	b4aff0ef          	jal	ra,ffffffffc0200446 <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
ffffffffc0201100:	00004697          	auipc	a3,0x4
ffffffffc0201104:	4a068693          	addi	a3,a3,1184 # ffffffffc02055a0 <commands+0x870>
ffffffffc0201108:	00004617          	auipc	a2,0x4
ffffffffc020110c:	36060613          	addi	a2,a2,864 # ffffffffc0205468 <commands+0x738>
ffffffffc0201110:	0c100593          	li	a1,193
ffffffffc0201114:	00004517          	auipc	a0,0x4
ffffffffc0201118:	36c50513          	addi	a0,a0,876 # ffffffffc0205480 <commands+0x750>
ffffffffc020111c:	b2aff0ef          	jal	ra,ffffffffc0200446 <__panic>
    assert((p0 = alloc_pages(2)) == p2 + 1);
ffffffffc0201120:	00004697          	auipc	a3,0x4
ffffffffc0201124:	64068693          	addi	a3,a3,1600 # ffffffffc0205760 <commands+0xa30>
ffffffffc0201128:	00004617          	auipc	a2,0x4
ffffffffc020112c:	34060613          	addi	a2,a2,832 # ffffffffc0205468 <commands+0x738>
ffffffffc0201130:	11200593          	li	a1,274
ffffffffc0201134:	00004517          	auipc	a0,0x4
ffffffffc0201138:	34c50513          	addi	a0,a0,844 # ffffffffc0205480 <commands+0x750>
ffffffffc020113c:	b0aff0ef          	jal	ra,ffffffffc0200446 <__panic>
    assert((p0 = alloc_page()) == p2 - 1);
ffffffffc0201140:	00004697          	auipc	a3,0x4
ffffffffc0201144:	60068693          	addi	a3,a3,1536 # ffffffffc0205740 <commands+0xa10>
ffffffffc0201148:	00004617          	auipc	a2,0x4
ffffffffc020114c:	32060613          	addi	a2,a2,800 # ffffffffc0205468 <commands+0x738>
ffffffffc0201150:	11000593          	li	a1,272
ffffffffc0201154:	00004517          	auipc	a0,0x4
ffffffffc0201158:	32c50513          	addi	a0,a0,812 # ffffffffc0205480 <commands+0x750>
ffffffffc020115c:	aeaff0ef          	jal	ra,ffffffffc0200446 <__panic>
    assert(PageProperty(p1) && p1->property == 3);
ffffffffc0201160:	00004697          	auipc	a3,0x4
ffffffffc0201164:	5b868693          	addi	a3,a3,1464 # ffffffffc0205718 <commands+0x9e8>
ffffffffc0201168:	00004617          	auipc	a2,0x4
ffffffffc020116c:	30060613          	addi	a2,a2,768 # ffffffffc0205468 <commands+0x738>
ffffffffc0201170:	10e00593          	li	a1,270
ffffffffc0201174:	00004517          	auipc	a0,0x4
ffffffffc0201178:	30c50513          	addi	a0,a0,780 # ffffffffc0205480 <commands+0x750>
ffffffffc020117c:	acaff0ef          	jal	ra,ffffffffc0200446 <__panic>
    assert(PageProperty(p0) && p0->property == 1);
ffffffffc0201180:	00004697          	auipc	a3,0x4
ffffffffc0201184:	57068693          	addi	a3,a3,1392 # ffffffffc02056f0 <commands+0x9c0>
ffffffffc0201188:	00004617          	auipc	a2,0x4
ffffffffc020118c:	2e060613          	addi	a2,a2,736 # ffffffffc0205468 <commands+0x738>
ffffffffc0201190:	10d00593          	li	a1,269
ffffffffc0201194:	00004517          	auipc	a0,0x4
ffffffffc0201198:	2ec50513          	addi	a0,a0,748 # ffffffffc0205480 <commands+0x750>
ffffffffc020119c:	aaaff0ef          	jal	ra,ffffffffc0200446 <__panic>
    assert(p0 + 2 == p1);
ffffffffc02011a0:	00004697          	auipc	a3,0x4
ffffffffc02011a4:	54068693          	addi	a3,a3,1344 # ffffffffc02056e0 <commands+0x9b0>
ffffffffc02011a8:	00004617          	auipc	a2,0x4
ffffffffc02011ac:	2c060613          	addi	a2,a2,704 # ffffffffc0205468 <commands+0x738>
ffffffffc02011b0:	10800593          	li	a1,264
ffffffffc02011b4:	00004517          	auipc	a0,0x4
ffffffffc02011b8:	2cc50513          	addi	a0,a0,716 # ffffffffc0205480 <commands+0x750>
ffffffffc02011bc:	a8aff0ef          	jal	ra,ffffffffc0200446 <__panic>
    assert(alloc_page() == NULL);
ffffffffc02011c0:	00004697          	auipc	a3,0x4
ffffffffc02011c4:	42068693          	addi	a3,a3,1056 # ffffffffc02055e0 <commands+0x8b0>
ffffffffc02011c8:	00004617          	auipc	a2,0x4
ffffffffc02011cc:	2a060613          	addi	a2,a2,672 # ffffffffc0205468 <commands+0x738>
ffffffffc02011d0:	10700593          	li	a1,263
ffffffffc02011d4:	00004517          	auipc	a0,0x4
ffffffffc02011d8:	2ac50513          	addi	a0,a0,684 # ffffffffc0205480 <commands+0x750>
ffffffffc02011dc:	a6aff0ef          	jal	ra,ffffffffc0200446 <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
ffffffffc02011e0:	00004697          	auipc	a3,0x4
ffffffffc02011e4:	4e068693          	addi	a3,a3,1248 # ffffffffc02056c0 <commands+0x990>
ffffffffc02011e8:	00004617          	auipc	a2,0x4
ffffffffc02011ec:	28060613          	addi	a2,a2,640 # ffffffffc0205468 <commands+0x738>
ffffffffc02011f0:	10600593          	li	a1,262
ffffffffc02011f4:	00004517          	auipc	a0,0x4
ffffffffc02011f8:	28c50513          	addi	a0,a0,652 # ffffffffc0205480 <commands+0x750>
ffffffffc02011fc:	a4aff0ef          	jal	ra,ffffffffc0200446 <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
ffffffffc0201200:	00004697          	auipc	a3,0x4
ffffffffc0201204:	49068693          	addi	a3,a3,1168 # ffffffffc0205690 <commands+0x960>
ffffffffc0201208:	00004617          	auipc	a2,0x4
ffffffffc020120c:	26060613          	addi	a2,a2,608 # ffffffffc0205468 <commands+0x738>
ffffffffc0201210:	10500593          	li	a1,261
ffffffffc0201214:	00004517          	auipc	a0,0x4
ffffffffc0201218:	26c50513          	addi	a0,a0,620 # ffffffffc0205480 <commands+0x750>
ffffffffc020121c:	a2aff0ef          	jal	ra,ffffffffc0200446 <__panic>
    assert(alloc_pages(4) == NULL);
ffffffffc0201220:	00004697          	auipc	a3,0x4
ffffffffc0201224:	45868693          	addi	a3,a3,1112 # ffffffffc0205678 <commands+0x948>
ffffffffc0201228:	00004617          	auipc	a2,0x4
ffffffffc020122c:	24060613          	addi	a2,a2,576 # ffffffffc0205468 <commands+0x738>
ffffffffc0201230:	10400593          	li	a1,260
ffffffffc0201234:	00004517          	auipc	a0,0x4
ffffffffc0201238:	24c50513          	addi	a0,a0,588 # ffffffffc0205480 <commands+0x750>
ffffffffc020123c:	a0aff0ef          	jal	ra,ffffffffc0200446 <__panic>
    assert(alloc_page() == NULL);
ffffffffc0201240:	00004697          	auipc	a3,0x4
ffffffffc0201244:	3a068693          	addi	a3,a3,928 # ffffffffc02055e0 <commands+0x8b0>
ffffffffc0201248:	00004617          	auipc	a2,0x4
ffffffffc020124c:	22060613          	addi	a2,a2,544 # ffffffffc0205468 <commands+0x738>
ffffffffc0201250:	0fe00593          	li	a1,254
ffffffffc0201254:	00004517          	auipc	a0,0x4
ffffffffc0201258:	22c50513          	addi	a0,a0,556 # ffffffffc0205480 <commands+0x750>
ffffffffc020125c:	9eaff0ef          	jal	ra,ffffffffc0200446 <__panic>
    assert(!PageProperty(p0));
ffffffffc0201260:	00004697          	auipc	a3,0x4
ffffffffc0201264:	40068693          	addi	a3,a3,1024 # ffffffffc0205660 <commands+0x930>
ffffffffc0201268:	00004617          	auipc	a2,0x4
ffffffffc020126c:	20060613          	addi	a2,a2,512 # ffffffffc0205468 <commands+0x738>
ffffffffc0201270:	0f900593          	li	a1,249
ffffffffc0201274:	00004517          	auipc	a0,0x4
ffffffffc0201278:	20c50513          	addi	a0,a0,524 # ffffffffc0205480 <commands+0x750>
ffffffffc020127c:	9caff0ef          	jal	ra,ffffffffc0200446 <__panic>
    assert((p0 = alloc_pages(5)) != NULL);
ffffffffc0201280:	00004697          	auipc	a3,0x4
ffffffffc0201284:	50068693          	addi	a3,a3,1280 # ffffffffc0205780 <commands+0xa50>
ffffffffc0201288:	00004617          	auipc	a2,0x4
ffffffffc020128c:	1e060613          	addi	a2,a2,480 # ffffffffc0205468 <commands+0x738>
ffffffffc0201290:	11700593          	li	a1,279
ffffffffc0201294:	00004517          	auipc	a0,0x4
ffffffffc0201298:	1ec50513          	addi	a0,a0,492 # ffffffffc0205480 <commands+0x750>
ffffffffc020129c:	9aaff0ef          	jal	ra,ffffffffc0200446 <__panic>
    assert(total == 0);
ffffffffc02012a0:	00004697          	auipc	a3,0x4
ffffffffc02012a4:	51068693          	addi	a3,a3,1296 # ffffffffc02057b0 <commands+0xa80>
ffffffffc02012a8:	00004617          	auipc	a2,0x4
ffffffffc02012ac:	1c060613          	addi	a2,a2,448 # ffffffffc0205468 <commands+0x738>
ffffffffc02012b0:	12600593          	li	a1,294
ffffffffc02012b4:	00004517          	auipc	a0,0x4
ffffffffc02012b8:	1cc50513          	addi	a0,a0,460 # ffffffffc0205480 <commands+0x750>
ffffffffc02012bc:	98aff0ef          	jal	ra,ffffffffc0200446 <__panic>
    assert(total == nr_free_pages());
ffffffffc02012c0:	00004697          	auipc	a3,0x4
ffffffffc02012c4:	1d868693          	addi	a3,a3,472 # ffffffffc0205498 <commands+0x768>
ffffffffc02012c8:	00004617          	auipc	a2,0x4
ffffffffc02012cc:	1a060613          	addi	a2,a2,416 # ffffffffc0205468 <commands+0x738>
ffffffffc02012d0:	0f300593          	li	a1,243
ffffffffc02012d4:	00004517          	auipc	a0,0x4
ffffffffc02012d8:	1ac50513          	addi	a0,a0,428 # ffffffffc0205480 <commands+0x750>
ffffffffc02012dc:	96aff0ef          	jal	ra,ffffffffc0200446 <__panic>
    assert((p1 = alloc_page()) != NULL);
ffffffffc02012e0:	00004697          	auipc	a3,0x4
ffffffffc02012e4:	1f868693          	addi	a3,a3,504 # ffffffffc02054d8 <commands+0x7a8>
ffffffffc02012e8:	00004617          	auipc	a2,0x4
ffffffffc02012ec:	18060613          	addi	a2,a2,384 # ffffffffc0205468 <commands+0x738>
ffffffffc02012f0:	0ba00593          	li	a1,186
ffffffffc02012f4:	00004517          	auipc	a0,0x4
ffffffffc02012f8:	18c50513          	addi	a0,a0,396 # ffffffffc0205480 <commands+0x750>
ffffffffc02012fc:	94aff0ef          	jal	ra,ffffffffc0200446 <__panic>

ffffffffc0201300 <default_free_pages>:
default_free_pages(struct Page *base, size_t n) {
ffffffffc0201300:	1141                	addi	sp,sp,-16
ffffffffc0201302:	e406                	sd	ra,8(sp)
    assert(n > 0);
ffffffffc0201304:	14058a63          	beqz	a1,ffffffffc0201458 <default_free_pages+0x158>
    for (; p != base + n; p ++) {
ffffffffc0201308:	00359693          	slli	a3,a1,0x3
ffffffffc020130c:	96ae                	add	a3,a3,a1
ffffffffc020130e:	068e                	slli	a3,a3,0x3
ffffffffc0201310:	96aa                	add	a3,a3,a0
ffffffffc0201312:	87aa                	mv	a5,a0
ffffffffc0201314:	02d50263          	beq	a0,a3,ffffffffc0201338 <default_free_pages+0x38>
ffffffffc0201318:	6798                	ld	a4,8(a5)
        assert(!PageReserved(p) && !PageProperty(p));
ffffffffc020131a:	8b05                	andi	a4,a4,1
ffffffffc020131c:	10071e63          	bnez	a4,ffffffffc0201438 <default_free_pages+0x138>
ffffffffc0201320:	6798                	ld	a4,8(a5)
ffffffffc0201322:	8b09                	andi	a4,a4,2
ffffffffc0201324:	10071a63          	bnez	a4,ffffffffc0201438 <default_free_pages+0x138>
        p->flags = 0;
ffffffffc0201328:	0007b423          	sd	zero,8(a5)
    return page->ref;
}

static inline void
set_page_ref(struct Page *page, int val) {
    page->ref = val;
ffffffffc020132c:	0007a023          	sw	zero,0(a5)
    for (; p != base + n; p ++) {
ffffffffc0201330:	04878793          	addi	a5,a5,72
ffffffffc0201334:	fed792e3          	bne	a5,a3,ffffffffc0201318 <default_free_pages+0x18>
    base->property = n;
ffffffffc0201338:	2581                	sext.w	a1,a1
ffffffffc020133a:	cd0c                	sw	a1,24(a0)
    SetPageProperty(base);
ffffffffc020133c:	00850893          	addi	a7,a0,8
    __op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc0201340:	4789                	li	a5,2
ffffffffc0201342:	40f8b02f          	amoor.d	zero,a5,(a7)
    nr_free += n;
ffffffffc0201346:	00010697          	auipc	a3,0x10
ffffffffc020134a:	11268693          	addi	a3,a3,274 # ffffffffc0211458 <free_area>
ffffffffc020134e:	4a98                	lw	a4,16(a3)
    return list->next == list;
ffffffffc0201350:	669c                	ld	a5,8(a3)
        list_add(&free_list, &(base->page_link));
ffffffffc0201352:	02050613          	addi	a2,a0,32
    nr_free += n;
ffffffffc0201356:	9db9                	addw	a1,a1,a4
ffffffffc0201358:	ca8c                	sw	a1,16(a3)
    if (list_empty(&free_list)) {
ffffffffc020135a:	0ad78863          	beq	a5,a3,ffffffffc020140a <default_free_pages+0x10a>
            struct Page* page = le2page(le, page_link);
ffffffffc020135e:	fe078713          	addi	a4,a5,-32
ffffffffc0201362:	0006b803          	ld	a6,0(a3)
    if (list_empty(&free_list)) {
ffffffffc0201366:	4581                	li	a1,0
            if (base < page) {
ffffffffc0201368:	00e56a63          	bltu	a0,a4,ffffffffc020137c <default_free_pages+0x7c>
    return listelm->next;
ffffffffc020136c:	6798                	ld	a4,8(a5)
            } else if (list_next(le) == &free_list) {
ffffffffc020136e:	06d70263          	beq	a4,a3,ffffffffc02013d2 <default_free_pages+0xd2>
    for (; p != base + n; p ++) {
ffffffffc0201372:	87ba                	mv	a5,a4
            struct Page* page = le2page(le, page_link);
ffffffffc0201374:	fe078713          	addi	a4,a5,-32
            if (base < page) {
ffffffffc0201378:	fee57ae3          	bgeu	a0,a4,ffffffffc020136c <default_free_pages+0x6c>
ffffffffc020137c:	c199                	beqz	a1,ffffffffc0201382 <default_free_pages+0x82>
ffffffffc020137e:	0106b023          	sd	a6,0(a3)
    __list_add(elm, listelm->prev, listelm);
ffffffffc0201382:	6398                	ld	a4,0(a5)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
ffffffffc0201384:	e390                	sd	a2,0(a5)
ffffffffc0201386:	e710                	sd	a2,8(a4)
    elm->next = next;
ffffffffc0201388:	f51c                	sd	a5,40(a0)
    elm->prev = prev;
ffffffffc020138a:	f118                	sd	a4,32(a0)
    if (le != &free_list) {
ffffffffc020138c:	02d70063          	beq	a4,a3,ffffffffc02013ac <default_free_pages+0xac>
        if (p + p->property == base) {
ffffffffc0201390:	ff872803          	lw	a6,-8(a4)
        p = le2page(le, page_link);
ffffffffc0201394:	fe070593          	addi	a1,a4,-32
        if (p + p->property == base) {
ffffffffc0201398:	02081613          	slli	a2,a6,0x20
ffffffffc020139c:	9201                	srli	a2,a2,0x20
ffffffffc020139e:	00361793          	slli	a5,a2,0x3
ffffffffc02013a2:	97b2                	add	a5,a5,a2
ffffffffc02013a4:	078e                	slli	a5,a5,0x3
ffffffffc02013a6:	97ae                	add	a5,a5,a1
ffffffffc02013a8:	02f50f63          	beq	a0,a5,ffffffffc02013e6 <default_free_pages+0xe6>
    return listelm->next;
ffffffffc02013ac:	7518                	ld	a4,40(a0)
    if (le != &free_list) {
ffffffffc02013ae:	00d70f63          	beq	a4,a3,ffffffffc02013cc <default_free_pages+0xcc>
        if (base + base->property == p) {
ffffffffc02013b2:	4d0c                	lw	a1,24(a0)
        p = le2page(le, page_link);
ffffffffc02013b4:	fe070693          	addi	a3,a4,-32
        if (base + base->property == p) {
ffffffffc02013b8:	02059613          	slli	a2,a1,0x20
ffffffffc02013bc:	9201                	srli	a2,a2,0x20
ffffffffc02013be:	00361793          	slli	a5,a2,0x3
ffffffffc02013c2:	97b2                	add	a5,a5,a2
ffffffffc02013c4:	078e                	slli	a5,a5,0x3
ffffffffc02013c6:	97aa                	add	a5,a5,a0
ffffffffc02013c8:	04f68863          	beq	a3,a5,ffffffffc0201418 <default_free_pages+0x118>
}
ffffffffc02013cc:	60a2                	ld	ra,8(sp)
ffffffffc02013ce:	0141                	addi	sp,sp,16
ffffffffc02013d0:	8082                	ret
    prev->next = next->prev = elm;
ffffffffc02013d2:	e790                	sd	a2,8(a5)
    elm->next = next;
ffffffffc02013d4:	f514                	sd	a3,40(a0)
    return listelm->next;
ffffffffc02013d6:	6798                	ld	a4,8(a5)
    elm->prev = prev;
ffffffffc02013d8:	f11c                	sd	a5,32(a0)
        while ((le = list_next(le)) != &free_list) {
ffffffffc02013da:	02d70563          	beq	a4,a3,ffffffffc0201404 <default_free_pages+0x104>
    prev->next = next->prev = elm;
ffffffffc02013de:	8832                	mv	a6,a2
ffffffffc02013e0:	4585                	li	a1,1
    for (; p != base + n; p ++) {
ffffffffc02013e2:	87ba                	mv	a5,a4
ffffffffc02013e4:	bf41                	j	ffffffffc0201374 <default_free_pages+0x74>
            p->property += base->property;
ffffffffc02013e6:	4d1c                	lw	a5,24(a0)
ffffffffc02013e8:	0107883b          	addw	a6,a5,a6
ffffffffc02013ec:	ff072c23          	sw	a6,-8(a4)
    __op_bit(and, __NOT, nr, ((volatile unsigned long *)addr));
ffffffffc02013f0:	57f5                	li	a5,-3
ffffffffc02013f2:	60f8b02f          	amoand.d	zero,a5,(a7)
    __list_del(listelm->prev, listelm->next);
ffffffffc02013f6:	7110                	ld	a2,32(a0)
ffffffffc02013f8:	751c                	ld	a5,40(a0)
            base = p;
ffffffffc02013fa:	852e                	mv	a0,a1
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
ffffffffc02013fc:	e61c                	sd	a5,8(a2)
    return listelm->next;
ffffffffc02013fe:	6718                	ld	a4,8(a4)
    next->prev = prev;
ffffffffc0201400:	e390                	sd	a2,0(a5)
ffffffffc0201402:	b775                	j	ffffffffc02013ae <default_free_pages+0xae>
ffffffffc0201404:	e290                	sd	a2,0(a3)
        while ((le = list_next(le)) != &free_list) {
ffffffffc0201406:	873e                	mv	a4,a5
ffffffffc0201408:	b761                	j	ffffffffc0201390 <default_free_pages+0x90>
}
ffffffffc020140a:	60a2                	ld	ra,8(sp)
    prev->next = next->prev = elm;
ffffffffc020140c:	e390                	sd	a2,0(a5)
ffffffffc020140e:	e790                	sd	a2,8(a5)
    elm->next = next;
ffffffffc0201410:	f51c                	sd	a5,40(a0)
    elm->prev = prev;
ffffffffc0201412:	f11c                	sd	a5,32(a0)
ffffffffc0201414:	0141                	addi	sp,sp,16
ffffffffc0201416:	8082                	ret
            base->property += p->property;
ffffffffc0201418:	ff872783          	lw	a5,-8(a4)
ffffffffc020141c:	fe870693          	addi	a3,a4,-24
ffffffffc0201420:	9dbd                	addw	a1,a1,a5
ffffffffc0201422:	cd0c                	sw	a1,24(a0)
ffffffffc0201424:	57f5                	li	a5,-3
ffffffffc0201426:	60f6b02f          	amoand.d	zero,a5,(a3)
    __list_del(listelm->prev, listelm->next);
ffffffffc020142a:	6314                	ld	a3,0(a4)
ffffffffc020142c:	671c                	ld	a5,8(a4)
}
ffffffffc020142e:	60a2                	ld	ra,8(sp)
    prev->next = next;
ffffffffc0201430:	e69c                	sd	a5,8(a3)
    next->prev = prev;
ffffffffc0201432:	e394                	sd	a3,0(a5)
ffffffffc0201434:	0141                	addi	sp,sp,16
ffffffffc0201436:	8082                	ret
        assert(!PageReserved(p) && !PageProperty(p));
ffffffffc0201438:	00004697          	auipc	a3,0x4
ffffffffc020143c:	39068693          	addi	a3,a3,912 # ffffffffc02057c8 <commands+0xa98>
ffffffffc0201440:	00004617          	auipc	a2,0x4
ffffffffc0201444:	02860613          	addi	a2,a2,40 # ffffffffc0205468 <commands+0x738>
ffffffffc0201448:	08300593          	li	a1,131
ffffffffc020144c:	00004517          	auipc	a0,0x4
ffffffffc0201450:	03450513          	addi	a0,a0,52 # ffffffffc0205480 <commands+0x750>
ffffffffc0201454:	ff3fe0ef          	jal	ra,ffffffffc0200446 <__panic>
    assert(n > 0);
ffffffffc0201458:	00004697          	auipc	a3,0x4
ffffffffc020145c:	36868693          	addi	a3,a3,872 # ffffffffc02057c0 <commands+0xa90>
ffffffffc0201460:	00004617          	auipc	a2,0x4
ffffffffc0201464:	00860613          	addi	a2,a2,8 # ffffffffc0205468 <commands+0x738>
ffffffffc0201468:	08000593          	li	a1,128
ffffffffc020146c:	00004517          	auipc	a0,0x4
ffffffffc0201470:	01450513          	addi	a0,a0,20 # ffffffffc0205480 <commands+0x750>
ffffffffc0201474:	fd3fe0ef          	jal	ra,ffffffffc0200446 <__panic>

ffffffffc0201478 <default_alloc_pages>:
    assert(n > 0);
ffffffffc0201478:	c959                	beqz	a0,ffffffffc020150e <default_alloc_pages+0x96>
    if (n > nr_free) {
ffffffffc020147a:	00010597          	auipc	a1,0x10
ffffffffc020147e:	fde58593          	addi	a1,a1,-34 # ffffffffc0211458 <free_area>
ffffffffc0201482:	0105a803          	lw	a6,16(a1)
ffffffffc0201486:	862a                	mv	a2,a0
ffffffffc0201488:	02081793          	slli	a5,a6,0x20
ffffffffc020148c:	9381                	srli	a5,a5,0x20
ffffffffc020148e:	00a7ee63          	bltu	a5,a0,ffffffffc02014aa <default_alloc_pages+0x32>
    list_entry_t *le = &free_list;
ffffffffc0201492:	87ae                	mv	a5,a1
ffffffffc0201494:	a801                	j	ffffffffc02014a4 <default_alloc_pages+0x2c>
        if (p->property >= n) {
ffffffffc0201496:	ff87a703          	lw	a4,-8(a5)
ffffffffc020149a:	02071693          	slli	a3,a4,0x20
ffffffffc020149e:	9281                	srli	a3,a3,0x20
ffffffffc02014a0:	00c6f763          	bgeu	a3,a2,ffffffffc02014ae <default_alloc_pages+0x36>
    return listelm->next;
ffffffffc02014a4:	679c                	ld	a5,8(a5)
    while ((le = list_next(le)) != &free_list) {
ffffffffc02014a6:	feb798e3          	bne	a5,a1,ffffffffc0201496 <default_alloc_pages+0x1e>
        return NULL;
ffffffffc02014aa:	4501                	li	a0,0
}
ffffffffc02014ac:	8082                	ret
    return listelm->prev;
ffffffffc02014ae:	0007b883          	ld	a7,0(a5)
    __list_del(listelm->prev, listelm->next);
ffffffffc02014b2:	0087b303          	ld	t1,8(a5)
        struct Page *p = le2page(le, page_link);
ffffffffc02014b6:	fe078513          	addi	a0,a5,-32
            p->property = page->property - n;
ffffffffc02014ba:	00060e1b          	sext.w	t3,a2
    prev->next = next;
ffffffffc02014be:	0068b423          	sd	t1,8(a7)
    next->prev = prev;
ffffffffc02014c2:	01133023          	sd	a7,0(t1)
        if (page->property > n) {
ffffffffc02014c6:	02d67b63          	bgeu	a2,a3,ffffffffc02014fc <default_alloc_pages+0x84>
            struct Page *p = page + n;
ffffffffc02014ca:	00361693          	slli	a3,a2,0x3
ffffffffc02014ce:	96b2                	add	a3,a3,a2
ffffffffc02014d0:	068e                	slli	a3,a3,0x3
ffffffffc02014d2:	96aa                	add	a3,a3,a0
            p->property = page->property - n;
ffffffffc02014d4:	41c7073b          	subw	a4,a4,t3
ffffffffc02014d8:	ce98                	sw	a4,24(a3)
    __op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc02014da:	00868613          	addi	a2,a3,8
ffffffffc02014de:	4709                	li	a4,2
ffffffffc02014e0:	40e6302f          	amoor.d	zero,a4,(a2)
    __list_add(elm, listelm, listelm->next);
ffffffffc02014e4:	0088b703          	ld	a4,8(a7)
            list_add(prev, &(p->page_link));
ffffffffc02014e8:	02068613          	addi	a2,a3,32
        nr_free -= n;
ffffffffc02014ec:	0105a803          	lw	a6,16(a1)
    prev->next = next->prev = elm;
ffffffffc02014f0:	e310                	sd	a2,0(a4)
ffffffffc02014f2:	00c8b423          	sd	a2,8(a7)
    elm->next = next;
ffffffffc02014f6:	f698                	sd	a4,40(a3)
    elm->prev = prev;
ffffffffc02014f8:	0316b023          	sd	a7,32(a3)
ffffffffc02014fc:	41c8083b          	subw	a6,a6,t3
ffffffffc0201500:	0105a823          	sw	a6,16(a1)
    __op_bit(and, __NOT, nr, ((volatile unsigned long *)addr));
ffffffffc0201504:	5775                	li	a4,-3
ffffffffc0201506:	17a1                	addi	a5,a5,-24
ffffffffc0201508:	60e7b02f          	amoand.d	zero,a4,(a5)
}
ffffffffc020150c:	8082                	ret
default_alloc_pages(size_t n) {
ffffffffc020150e:	1141                	addi	sp,sp,-16
    assert(n > 0);
ffffffffc0201510:	00004697          	auipc	a3,0x4
ffffffffc0201514:	2b068693          	addi	a3,a3,688 # ffffffffc02057c0 <commands+0xa90>
ffffffffc0201518:	00004617          	auipc	a2,0x4
ffffffffc020151c:	f5060613          	addi	a2,a2,-176 # ffffffffc0205468 <commands+0x738>
ffffffffc0201520:	06200593          	li	a1,98
ffffffffc0201524:	00004517          	auipc	a0,0x4
ffffffffc0201528:	f5c50513          	addi	a0,a0,-164 # ffffffffc0205480 <commands+0x750>
default_alloc_pages(size_t n) {
ffffffffc020152c:	e406                	sd	ra,8(sp)
    assert(n > 0);
ffffffffc020152e:	f19fe0ef          	jal	ra,ffffffffc0200446 <__panic>

ffffffffc0201532 <default_init_memmap>:
default_init_memmap(struct Page *base, size_t n) {
ffffffffc0201532:	1141                	addi	sp,sp,-16
ffffffffc0201534:	e406                	sd	ra,8(sp)
    assert(n > 0);
ffffffffc0201536:	c9e1                	beqz	a1,ffffffffc0201606 <default_init_memmap+0xd4>
    for (; p != base + n; p ++) {
ffffffffc0201538:	00359693          	slli	a3,a1,0x3
ffffffffc020153c:	96ae                	add	a3,a3,a1
ffffffffc020153e:	068e                	slli	a3,a3,0x3
ffffffffc0201540:	96aa                	add	a3,a3,a0
ffffffffc0201542:	87aa                	mv	a5,a0
ffffffffc0201544:	00d50f63          	beq	a0,a3,ffffffffc0201562 <default_init_memmap+0x30>
    return (((*(volatile unsigned long *)addr) >> nr) & 1);
ffffffffc0201548:	6798                	ld	a4,8(a5)
        assert(PageReserved(p));
ffffffffc020154a:	8b05                	andi	a4,a4,1
ffffffffc020154c:	cf49                	beqz	a4,ffffffffc02015e6 <default_init_memmap+0xb4>
        p->flags = p->property = 0;
ffffffffc020154e:	0007ac23          	sw	zero,24(a5)
ffffffffc0201552:	0007b423          	sd	zero,8(a5)
ffffffffc0201556:	0007a023          	sw	zero,0(a5)
    for (; p != base + n; p ++) {
ffffffffc020155a:	04878793          	addi	a5,a5,72
ffffffffc020155e:	fed795e3          	bne	a5,a3,ffffffffc0201548 <default_init_memmap+0x16>
    base->property = n;
ffffffffc0201562:	2581                	sext.w	a1,a1
ffffffffc0201564:	cd0c                	sw	a1,24(a0)
    __op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc0201566:	4789                	li	a5,2
ffffffffc0201568:	00850713          	addi	a4,a0,8
ffffffffc020156c:	40f7302f          	amoor.d	zero,a5,(a4)
    nr_free += n;
ffffffffc0201570:	00010697          	auipc	a3,0x10
ffffffffc0201574:	ee868693          	addi	a3,a3,-280 # ffffffffc0211458 <free_area>
ffffffffc0201578:	4a98                	lw	a4,16(a3)
    return list->next == list;
ffffffffc020157a:	669c                	ld	a5,8(a3)
        list_add(&free_list, &(base->page_link));
ffffffffc020157c:	02050613          	addi	a2,a0,32
    nr_free += n;
ffffffffc0201580:	9db9                	addw	a1,a1,a4
ffffffffc0201582:	ca8c                	sw	a1,16(a3)
    if (list_empty(&free_list)) {
ffffffffc0201584:	04d78a63          	beq	a5,a3,ffffffffc02015d8 <default_init_memmap+0xa6>
            struct Page* page = le2page(le, page_link);
ffffffffc0201588:	fe078713          	addi	a4,a5,-32
ffffffffc020158c:	0006b803          	ld	a6,0(a3)
    if (list_empty(&free_list)) {
ffffffffc0201590:	4581                	li	a1,0
            if (base < page) {
ffffffffc0201592:	00e56a63          	bltu	a0,a4,ffffffffc02015a6 <default_init_memmap+0x74>
    return listelm->next;
ffffffffc0201596:	6798                	ld	a4,8(a5)
            } else if (list_next(le) == &free_list) {
ffffffffc0201598:	02d70263          	beq	a4,a3,ffffffffc02015bc <default_init_memmap+0x8a>
    for (; p != base + n; p ++) {
ffffffffc020159c:	87ba                	mv	a5,a4
            struct Page* page = le2page(le, page_link);
ffffffffc020159e:	fe078713          	addi	a4,a5,-32
            if (base < page) {
ffffffffc02015a2:	fee57ae3          	bgeu	a0,a4,ffffffffc0201596 <default_init_memmap+0x64>
ffffffffc02015a6:	c199                	beqz	a1,ffffffffc02015ac <default_init_memmap+0x7a>
ffffffffc02015a8:	0106b023          	sd	a6,0(a3)
    __list_add(elm, listelm->prev, listelm);
ffffffffc02015ac:	6398                	ld	a4,0(a5)
}
ffffffffc02015ae:	60a2                	ld	ra,8(sp)
    prev->next = next->prev = elm;
ffffffffc02015b0:	e390                	sd	a2,0(a5)
ffffffffc02015b2:	e710                	sd	a2,8(a4)
    elm->next = next;
ffffffffc02015b4:	f51c                	sd	a5,40(a0)
    elm->prev = prev;
ffffffffc02015b6:	f118                	sd	a4,32(a0)
ffffffffc02015b8:	0141                	addi	sp,sp,16
ffffffffc02015ba:	8082                	ret
    prev->next = next->prev = elm;
ffffffffc02015bc:	e790                	sd	a2,8(a5)
    elm->next = next;
ffffffffc02015be:	f514                	sd	a3,40(a0)
    return listelm->next;
ffffffffc02015c0:	6798                	ld	a4,8(a5)
    elm->prev = prev;
ffffffffc02015c2:	f11c                	sd	a5,32(a0)
        while ((le = list_next(le)) != &free_list) {
ffffffffc02015c4:	00d70663          	beq	a4,a3,ffffffffc02015d0 <default_init_memmap+0x9e>
    prev->next = next->prev = elm;
ffffffffc02015c8:	8832                	mv	a6,a2
ffffffffc02015ca:	4585                	li	a1,1
    for (; p != base + n; p ++) {
ffffffffc02015cc:	87ba                	mv	a5,a4
ffffffffc02015ce:	bfc1                	j	ffffffffc020159e <default_init_memmap+0x6c>
}
ffffffffc02015d0:	60a2                	ld	ra,8(sp)
ffffffffc02015d2:	e290                	sd	a2,0(a3)
ffffffffc02015d4:	0141                	addi	sp,sp,16
ffffffffc02015d6:	8082                	ret
ffffffffc02015d8:	60a2                	ld	ra,8(sp)
ffffffffc02015da:	e390                	sd	a2,0(a5)
ffffffffc02015dc:	e790                	sd	a2,8(a5)
    elm->next = next;
ffffffffc02015de:	f51c                	sd	a5,40(a0)
    elm->prev = prev;
ffffffffc02015e0:	f11c                	sd	a5,32(a0)
ffffffffc02015e2:	0141                	addi	sp,sp,16
ffffffffc02015e4:	8082                	ret
        assert(PageReserved(p));
ffffffffc02015e6:	00004697          	auipc	a3,0x4
ffffffffc02015ea:	20a68693          	addi	a3,a3,522 # ffffffffc02057f0 <commands+0xac0>
ffffffffc02015ee:	00004617          	auipc	a2,0x4
ffffffffc02015f2:	e7a60613          	addi	a2,a2,-390 # ffffffffc0205468 <commands+0x738>
ffffffffc02015f6:	04900593          	li	a1,73
ffffffffc02015fa:	00004517          	auipc	a0,0x4
ffffffffc02015fe:	e8650513          	addi	a0,a0,-378 # ffffffffc0205480 <commands+0x750>
ffffffffc0201602:	e45fe0ef          	jal	ra,ffffffffc0200446 <__panic>
    assert(n > 0);
ffffffffc0201606:	00004697          	auipc	a3,0x4
ffffffffc020160a:	1ba68693          	addi	a3,a3,442 # ffffffffc02057c0 <commands+0xa90>
ffffffffc020160e:	00004617          	auipc	a2,0x4
ffffffffc0201612:	e5a60613          	addi	a2,a2,-422 # ffffffffc0205468 <commands+0x738>
ffffffffc0201616:	04600593          	li	a1,70
ffffffffc020161a:	00004517          	auipc	a0,0x4
ffffffffc020161e:	e6650513          	addi	a0,a0,-410 # ffffffffc0205480 <commands+0x750>
ffffffffc0201622:	e25fe0ef          	jal	ra,ffffffffc0200446 <__panic>

ffffffffc0201626 <slob_free>:
static void slob_free(void *block, int size)
{
	slob_t *cur, *b = (slob_t *)block;
	unsigned long flags;

	if (!block)
ffffffffc0201626:	c94d                	beqz	a0,ffffffffc02016d8 <slob_free+0xb2>
{
ffffffffc0201628:	1141                	addi	sp,sp,-16
ffffffffc020162a:	e022                	sd	s0,0(sp)
ffffffffc020162c:	e406                	sd	ra,8(sp)
ffffffffc020162e:	842a                	mv	s0,a0
		return;

	if (size)
ffffffffc0201630:	e9c1                	bnez	a1,ffffffffc02016c0 <slob_free+0x9a>
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0201632:	100027f3          	csrr	a5,sstatus
ffffffffc0201636:	8b89                	andi	a5,a5,2
    return 0;
ffffffffc0201638:	4501                	li	a0,0
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc020163a:	ebd9                	bnez	a5,ffffffffc02016d0 <slob_free+0xaa>
		b->units = SLOB_UNITS(size);

	/* Find reinsertion point */
	spin_lock_irqsave(&slob_lock, flags);
	for (cur = slobfree; !(b > cur && b < cur->next); cur = cur->next)
ffffffffc020163c:	00009617          	auipc	a2,0x9
ffffffffc0201640:	a1460613          	addi	a2,a2,-1516 # ffffffffc020a050 <slobfree>
ffffffffc0201644:	621c                	ld	a5,0(a2)
		if (cur >= cur->next && (b > cur || b < cur->next))
ffffffffc0201646:	873e                	mv	a4,a5
	for (cur = slobfree; !(b > cur && b < cur->next); cur = cur->next)
ffffffffc0201648:	679c                	ld	a5,8(a5)
ffffffffc020164a:	02877a63          	bgeu	a4,s0,ffffffffc020167e <slob_free+0x58>
ffffffffc020164e:	00f46463          	bltu	s0,a5,ffffffffc0201656 <slob_free+0x30>
		if (cur >= cur->next && (b > cur || b < cur->next))
ffffffffc0201652:	fef76ae3          	bltu	a4,a5,ffffffffc0201646 <slob_free+0x20>
			break;

	if (b + b->units == cur->next) {
ffffffffc0201656:	400c                	lw	a1,0(s0)
ffffffffc0201658:	00459693          	slli	a3,a1,0x4
ffffffffc020165c:	96a2                	add	a3,a3,s0
ffffffffc020165e:	02d78a63          	beq	a5,a3,ffffffffc0201692 <slob_free+0x6c>
		b->units += cur->next->units;
		b->next = cur->next->next;
	} else
		b->next = cur->next;

	if (cur + cur->units == b) {
ffffffffc0201662:	4314                	lw	a3,0(a4)
		b->next = cur->next;
ffffffffc0201664:	e41c                	sd	a5,8(s0)
	if (cur + cur->units == b) {
ffffffffc0201666:	00469793          	slli	a5,a3,0x4
ffffffffc020166a:	97ba                	add	a5,a5,a4
ffffffffc020166c:	02f40e63          	beq	s0,a5,ffffffffc02016a8 <slob_free+0x82>
		cur->units += b->units;
		cur->next = b->next;
	} else
		cur->next = b;
ffffffffc0201670:	e700                	sd	s0,8(a4)

	slobfree = cur;
ffffffffc0201672:	e218                	sd	a4,0(a2)
    if (flag) {
ffffffffc0201674:	e129                	bnez	a0,ffffffffc02016b6 <slob_free+0x90>

	spin_unlock_irqrestore(&slob_lock, flags);
}
ffffffffc0201676:	60a2                	ld	ra,8(sp)
ffffffffc0201678:	6402                	ld	s0,0(sp)
ffffffffc020167a:	0141                	addi	sp,sp,16
ffffffffc020167c:	8082                	ret
		if (cur >= cur->next && (b > cur || b < cur->next))
ffffffffc020167e:	fcf764e3          	bltu	a4,a5,ffffffffc0201646 <slob_free+0x20>
ffffffffc0201682:	fcf472e3          	bgeu	s0,a5,ffffffffc0201646 <slob_free+0x20>
	if (b + b->units == cur->next) {
ffffffffc0201686:	400c                	lw	a1,0(s0)
ffffffffc0201688:	00459693          	slli	a3,a1,0x4
ffffffffc020168c:	96a2                	add	a3,a3,s0
ffffffffc020168e:	fcd79ae3          	bne	a5,a3,ffffffffc0201662 <slob_free+0x3c>
		b->units += cur->next->units;
ffffffffc0201692:	4394                	lw	a3,0(a5)
		b->next = cur->next->next;
ffffffffc0201694:	679c                	ld	a5,8(a5)
		b->units += cur->next->units;
ffffffffc0201696:	9db5                	addw	a1,a1,a3
ffffffffc0201698:	c00c                	sw	a1,0(s0)
	if (cur + cur->units == b) {
ffffffffc020169a:	4314                	lw	a3,0(a4)
		b->next = cur->next->next;
ffffffffc020169c:	e41c                	sd	a5,8(s0)
	if (cur + cur->units == b) {
ffffffffc020169e:	00469793          	slli	a5,a3,0x4
ffffffffc02016a2:	97ba                	add	a5,a5,a4
ffffffffc02016a4:	fcf416e3          	bne	s0,a5,ffffffffc0201670 <slob_free+0x4a>
		cur->units += b->units;
ffffffffc02016a8:	401c                	lw	a5,0(s0)
		cur->next = b->next;
ffffffffc02016aa:	640c                	ld	a1,8(s0)
	slobfree = cur;
ffffffffc02016ac:	e218                	sd	a4,0(a2)
		cur->units += b->units;
ffffffffc02016ae:	9ebd                	addw	a3,a3,a5
ffffffffc02016b0:	c314                	sw	a3,0(a4)
		cur->next = b->next;
ffffffffc02016b2:	e70c                	sd	a1,8(a4)
ffffffffc02016b4:	d169                	beqz	a0,ffffffffc0201676 <slob_free+0x50>
}
ffffffffc02016b6:	6402                	ld	s0,0(sp)
ffffffffc02016b8:	60a2                	ld	ra,8(sp)
ffffffffc02016ba:	0141                	addi	sp,sp,16
        intr_enable();
ffffffffc02016bc:	eddfe06f          	j	ffffffffc0200598 <intr_enable>
		b->units = SLOB_UNITS(size);
ffffffffc02016c0:	25bd                	addiw	a1,a1,15
ffffffffc02016c2:	8191                	srli	a1,a1,0x4
ffffffffc02016c4:	c10c                	sw	a1,0(a0)
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc02016c6:	100027f3          	csrr	a5,sstatus
ffffffffc02016ca:	8b89                	andi	a5,a5,2
    return 0;
ffffffffc02016cc:	4501                	li	a0,0
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc02016ce:	d7bd                	beqz	a5,ffffffffc020163c <slob_free+0x16>
        intr_disable();
ffffffffc02016d0:	ecffe0ef          	jal	ra,ffffffffc020059e <intr_disable>
        return 1;
ffffffffc02016d4:	4505                	li	a0,1
ffffffffc02016d6:	b79d                	j	ffffffffc020163c <slob_free+0x16>
ffffffffc02016d8:	8082                	ret

ffffffffc02016da <__slob_get_free_pages.constprop.0>:
  struct Page * page = alloc_pages(1 << order);
ffffffffc02016da:	4785                	li	a5,1
static void* __slob_get_free_pages(gfp_t gfp, int order)
ffffffffc02016dc:	1141                	addi	sp,sp,-16
  struct Page * page = alloc_pages(1 << order);
ffffffffc02016de:	00a7953b          	sllw	a0,a5,a0
static void* __slob_get_free_pages(gfp_t gfp, int order)
ffffffffc02016e2:	e406                	sd	ra,8(sp)
  struct Page * page = alloc_pages(1 << order);
ffffffffc02016e4:	360000ef          	jal	ra,ffffffffc0201a44 <alloc_pages>
  if(!page)
ffffffffc02016e8:	c129                	beqz	a0,ffffffffc020172a <__slob_get_free_pages.constprop.0+0x50>
    return page - pages + nbase;
ffffffffc02016ea:	00014697          	auipc	a3,0x14
ffffffffc02016ee:	e7e6b683          	ld	a3,-386(a3) # ffffffffc0215568 <pages>
ffffffffc02016f2:	8d15                	sub	a0,a0,a3
ffffffffc02016f4:	850d                	srai	a0,a0,0x3
ffffffffc02016f6:	00005697          	auipc	a3,0x5
ffffffffc02016fa:	3f26b683          	ld	a3,1010(a3) # ffffffffc0206ae8 <error_string+0x38>
ffffffffc02016fe:	02d50533          	mul	a0,a0,a3
ffffffffc0201702:	00005697          	auipc	a3,0x5
ffffffffc0201706:	3ee6b683          	ld	a3,1006(a3) # ffffffffc0206af0 <nbase>
    return KADDR(page2pa(page));
ffffffffc020170a:	00014717          	auipc	a4,0x14
ffffffffc020170e:	e5673703          	ld	a4,-426(a4) # ffffffffc0215560 <npage>
    return page - pages + nbase;
ffffffffc0201712:	9536                	add	a0,a0,a3
    return KADDR(page2pa(page));
ffffffffc0201714:	00c51793          	slli	a5,a0,0xc
ffffffffc0201718:	83b1                	srli	a5,a5,0xc
    return page2ppn(page) << PGSHIFT;
ffffffffc020171a:	0532                	slli	a0,a0,0xc
    return KADDR(page2pa(page));
ffffffffc020171c:	00e7fa63          	bgeu	a5,a4,ffffffffc0201730 <__slob_get_free_pages.constprop.0+0x56>
ffffffffc0201720:	00014697          	auipc	a3,0x14
ffffffffc0201724:	e586b683          	ld	a3,-424(a3) # ffffffffc0215578 <va_pa_offset>
ffffffffc0201728:	9536                	add	a0,a0,a3
}
ffffffffc020172a:	60a2                	ld	ra,8(sp)
ffffffffc020172c:	0141                	addi	sp,sp,16
ffffffffc020172e:	8082                	ret
ffffffffc0201730:	86aa                	mv	a3,a0
ffffffffc0201732:	00004617          	auipc	a2,0x4
ffffffffc0201736:	11e60613          	addi	a2,a2,286 # ffffffffc0205850 <default_pmm_manager+0x38>
ffffffffc020173a:	06900593          	li	a1,105
ffffffffc020173e:	00004517          	auipc	a0,0x4
ffffffffc0201742:	13a50513          	addi	a0,a0,314 # ffffffffc0205878 <default_pmm_manager+0x60>
ffffffffc0201746:	d01fe0ef          	jal	ra,ffffffffc0200446 <__panic>

ffffffffc020174a <slob_alloc.constprop.0>:
static void *slob_alloc(size_t size, gfp_t gfp, int align)
ffffffffc020174a:	1101                	addi	sp,sp,-32
ffffffffc020174c:	ec06                	sd	ra,24(sp)
ffffffffc020174e:	e822                	sd	s0,16(sp)
ffffffffc0201750:	e426                	sd	s1,8(sp)
ffffffffc0201752:	e04a                	sd	s2,0(sp)
	assert( (size + SLOB_UNIT) < PAGE_SIZE );
ffffffffc0201754:	01050713          	addi	a4,a0,16
ffffffffc0201758:	6785                	lui	a5,0x1
ffffffffc020175a:	0cf77363          	bgeu	a4,a5,ffffffffc0201820 <slob_alloc.constprop.0+0xd6>
	int delta = 0, units = SLOB_UNITS(size);
ffffffffc020175e:	00f50493          	addi	s1,a0,15
ffffffffc0201762:	8091                	srli	s1,s1,0x4
ffffffffc0201764:	2481                	sext.w	s1,s1
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0201766:	10002673          	csrr	a2,sstatus
ffffffffc020176a:	8a09                	andi	a2,a2,2
ffffffffc020176c:	e25d                	bnez	a2,ffffffffc0201812 <slob_alloc.constprop.0+0xc8>
	prev = slobfree;
ffffffffc020176e:	00009917          	auipc	s2,0x9
ffffffffc0201772:	8e290913          	addi	s2,s2,-1822 # ffffffffc020a050 <slobfree>
ffffffffc0201776:	00093683          	ld	a3,0(s2)
	for (cur = prev->next; ; prev = cur, cur = cur->next) {
ffffffffc020177a:	669c                	ld	a5,8(a3)
		if (cur->units >= units + delta) { /* room enough? */
ffffffffc020177c:	4398                	lw	a4,0(a5)
ffffffffc020177e:	08975e63          	bge	a4,s1,ffffffffc020181a <slob_alloc.constprop.0+0xd0>
		if (cur == slobfree) {
ffffffffc0201782:	00d78b63          	beq	a5,a3,ffffffffc0201798 <slob_alloc.constprop.0+0x4e>
	for (cur = prev->next; ; prev = cur, cur = cur->next) {
ffffffffc0201786:	6780                	ld	s0,8(a5)
		if (cur->units >= units + delta) { /* room enough? */
ffffffffc0201788:	4018                	lw	a4,0(s0)
ffffffffc020178a:	02975a63          	bge	a4,s1,ffffffffc02017be <slob_alloc.constprop.0+0x74>
		if (cur == slobfree) {
ffffffffc020178e:	00093683          	ld	a3,0(s2)
ffffffffc0201792:	87a2                	mv	a5,s0
ffffffffc0201794:	fed799e3          	bne	a5,a3,ffffffffc0201786 <slob_alloc.constprop.0+0x3c>
    if (flag) {
ffffffffc0201798:	ee31                	bnez	a2,ffffffffc02017f4 <slob_alloc.constprop.0+0xaa>
			cur = (slob_t *)__slob_get_free_page(gfp);
ffffffffc020179a:	4501                	li	a0,0
ffffffffc020179c:	f3fff0ef          	jal	ra,ffffffffc02016da <__slob_get_free_pages.constprop.0>
ffffffffc02017a0:	842a                	mv	s0,a0
			if (!cur)
ffffffffc02017a2:	cd05                	beqz	a0,ffffffffc02017da <slob_alloc.constprop.0+0x90>
			slob_free(cur, PAGE_SIZE);
ffffffffc02017a4:	6585                	lui	a1,0x1
ffffffffc02017a6:	e81ff0ef          	jal	ra,ffffffffc0201626 <slob_free>
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc02017aa:	10002673          	csrr	a2,sstatus
ffffffffc02017ae:	8a09                	andi	a2,a2,2
ffffffffc02017b0:	ee05                	bnez	a2,ffffffffc02017e8 <slob_alloc.constprop.0+0x9e>
			cur = slobfree;
ffffffffc02017b2:	00093783          	ld	a5,0(s2)
	for (cur = prev->next; ; prev = cur, cur = cur->next) {
ffffffffc02017b6:	6780                	ld	s0,8(a5)
		if (cur->units >= units + delta) { /* room enough? */
ffffffffc02017b8:	4018                	lw	a4,0(s0)
ffffffffc02017ba:	fc974ae3          	blt	a4,s1,ffffffffc020178e <slob_alloc.constprop.0+0x44>
			if (cur->units == units) /* exact fit? */
ffffffffc02017be:	04e48763          	beq	s1,a4,ffffffffc020180c <slob_alloc.constprop.0+0xc2>
				prev->next = cur + units;
ffffffffc02017c2:	00449693          	slli	a3,s1,0x4
ffffffffc02017c6:	96a2                	add	a3,a3,s0
ffffffffc02017c8:	e794                	sd	a3,8(a5)
				prev->next->next = cur->next;
ffffffffc02017ca:	640c                	ld	a1,8(s0)
				prev->next->units = cur->units - units;
ffffffffc02017cc:	9f05                	subw	a4,a4,s1
ffffffffc02017ce:	c298                	sw	a4,0(a3)
				prev->next->next = cur->next;
ffffffffc02017d0:	e68c                	sd	a1,8(a3)
				cur->units = units;
ffffffffc02017d2:	c004                	sw	s1,0(s0)
			slobfree = prev;
ffffffffc02017d4:	00f93023          	sd	a5,0(s2)
    if (flag) {
ffffffffc02017d8:	e20d                	bnez	a2,ffffffffc02017fa <slob_alloc.constprop.0+0xb0>
}
ffffffffc02017da:	60e2                	ld	ra,24(sp)
ffffffffc02017dc:	8522                	mv	a0,s0
ffffffffc02017de:	6442                	ld	s0,16(sp)
ffffffffc02017e0:	64a2                	ld	s1,8(sp)
ffffffffc02017e2:	6902                	ld	s2,0(sp)
ffffffffc02017e4:	6105                	addi	sp,sp,32
ffffffffc02017e6:	8082                	ret
        intr_disable();
ffffffffc02017e8:	db7fe0ef          	jal	ra,ffffffffc020059e <intr_disable>
			cur = slobfree;
ffffffffc02017ec:	00093783          	ld	a5,0(s2)
        return 1;
ffffffffc02017f0:	4605                	li	a2,1
ffffffffc02017f2:	b7d1                	j	ffffffffc02017b6 <slob_alloc.constprop.0+0x6c>
        intr_enable();
ffffffffc02017f4:	da5fe0ef          	jal	ra,ffffffffc0200598 <intr_enable>
ffffffffc02017f8:	b74d                	j	ffffffffc020179a <slob_alloc.constprop.0+0x50>
ffffffffc02017fa:	d9ffe0ef          	jal	ra,ffffffffc0200598 <intr_enable>
}
ffffffffc02017fe:	60e2                	ld	ra,24(sp)
ffffffffc0201800:	8522                	mv	a0,s0
ffffffffc0201802:	6442                	ld	s0,16(sp)
ffffffffc0201804:	64a2                	ld	s1,8(sp)
ffffffffc0201806:	6902                	ld	s2,0(sp)
ffffffffc0201808:	6105                	addi	sp,sp,32
ffffffffc020180a:	8082                	ret
				prev->next = cur->next; /* unlink */
ffffffffc020180c:	6418                	ld	a4,8(s0)
ffffffffc020180e:	e798                	sd	a4,8(a5)
ffffffffc0201810:	b7d1                	j	ffffffffc02017d4 <slob_alloc.constprop.0+0x8a>
        intr_disable();
ffffffffc0201812:	d8dfe0ef          	jal	ra,ffffffffc020059e <intr_disable>
        return 1;
ffffffffc0201816:	4605                	li	a2,1
ffffffffc0201818:	bf99                	j	ffffffffc020176e <slob_alloc.constprop.0+0x24>
		if (cur->units >= units + delta) { /* room enough? */
ffffffffc020181a:	843e                	mv	s0,a5
ffffffffc020181c:	87b6                	mv	a5,a3
ffffffffc020181e:	b745                	j	ffffffffc02017be <slob_alloc.constprop.0+0x74>
	assert( (size + SLOB_UNIT) < PAGE_SIZE );
ffffffffc0201820:	00004697          	auipc	a3,0x4
ffffffffc0201824:	06868693          	addi	a3,a3,104 # ffffffffc0205888 <default_pmm_manager+0x70>
ffffffffc0201828:	00004617          	auipc	a2,0x4
ffffffffc020182c:	c4060613          	addi	a2,a2,-960 # ffffffffc0205468 <commands+0x738>
ffffffffc0201830:	06300593          	li	a1,99
ffffffffc0201834:	00004517          	auipc	a0,0x4
ffffffffc0201838:	07450513          	addi	a0,a0,116 # ffffffffc02058a8 <default_pmm_manager+0x90>
ffffffffc020183c:	c0bfe0ef          	jal	ra,ffffffffc0200446 <__panic>

ffffffffc0201840 <kmalloc_init>:
slob_init(void) {
  cprintf("use SLOB allocator\n");
}

inline void 
kmalloc_init(void) {
ffffffffc0201840:	1141                	addi	sp,sp,-16
  cprintf("use SLOB allocator\n");
ffffffffc0201842:	00004517          	auipc	a0,0x4
ffffffffc0201846:	07e50513          	addi	a0,a0,126 # ffffffffc02058c0 <default_pmm_manager+0xa8>
kmalloc_init(void) {
ffffffffc020184a:	e406                	sd	ra,8(sp)
  cprintf("use SLOB allocator\n");
ffffffffc020184c:	935fe0ef          	jal	ra,ffffffffc0200180 <cprintf>
    slob_init();
    cprintf("kmalloc_init() succeeded!\n");
}
ffffffffc0201850:	60a2                	ld	ra,8(sp)
    cprintf("kmalloc_init() succeeded!\n");
ffffffffc0201852:	00004517          	auipc	a0,0x4
ffffffffc0201856:	08650513          	addi	a0,a0,134 # ffffffffc02058d8 <default_pmm_manager+0xc0>
}
ffffffffc020185a:	0141                	addi	sp,sp,16
    cprintf("kmalloc_init() succeeded!\n");
ffffffffc020185c:	925fe06f          	j	ffffffffc0200180 <cprintf>

ffffffffc0201860 <kmalloc>:
	return 0;
}

void *
kmalloc(size_t size)
{
ffffffffc0201860:	1101                	addi	sp,sp,-32
ffffffffc0201862:	e04a                	sd	s2,0(sp)
	if (size < PAGE_SIZE - SLOB_UNIT) {
ffffffffc0201864:	6905                	lui	s2,0x1
{
ffffffffc0201866:	e822                	sd	s0,16(sp)
ffffffffc0201868:	ec06                	sd	ra,24(sp)
ffffffffc020186a:	e426                	sd	s1,8(sp)
	if (size < PAGE_SIZE - SLOB_UNIT) {
ffffffffc020186c:	fef90793          	addi	a5,s2,-17 # fef <kern_entry-0xffffffffc01ff011>
{
ffffffffc0201870:	842a                	mv	s0,a0
	if (size < PAGE_SIZE - SLOB_UNIT) {
ffffffffc0201872:	04a7f963          	bgeu	a5,a0,ffffffffc02018c4 <kmalloc+0x64>
	bb = slob_alloc(sizeof(bigblock_t), gfp, 0);
ffffffffc0201876:	4561                	li	a0,24
ffffffffc0201878:	ed3ff0ef          	jal	ra,ffffffffc020174a <slob_alloc.constprop.0>
ffffffffc020187c:	84aa                	mv	s1,a0
	if (!bb)
ffffffffc020187e:	c929                	beqz	a0,ffffffffc02018d0 <kmalloc+0x70>
	bb->order = find_order(size);
ffffffffc0201880:	0004079b          	sext.w	a5,s0
	int order = 0;
ffffffffc0201884:	4501                	li	a0,0
	for ( ; size > 4096 ; size >>=1)
ffffffffc0201886:	00f95763          	bge	s2,a5,ffffffffc0201894 <kmalloc+0x34>
ffffffffc020188a:	6705                	lui	a4,0x1
ffffffffc020188c:	8785                	srai	a5,a5,0x1
		order++;
ffffffffc020188e:	2505                	addiw	a0,a0,1
	for ( ; size > 4096 ; size >>=1)
ffffffffc0201890:	fef74ee3          	blt	a4,a5,ffffffffc020188c <kmalloc+0x2c>
	bb->order = find_order(size);
ffffffffc0201894:	c088                	sw	a0,0(s1)
	bb->pages = (void *)__slob_get_free_pages(gfp, bb->order);
ffffffffc0201896:	e45ff0ef          	jal	ra,ffffffffc02016da <__slob_get_free_pages.constprop.0>
ffffffffc020189a:	e488                	sd	a0,8(s1)
ffffffffc020189c:	842a                	mv	s0,a0
	if (bb->pages) {
ffffffffc020189e:	c525                	beqz	a0,ffffffffc0201906 <kmalloc+0xa6>
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc02018a0:	100027f3          	csrr	a5,sstatus
ffffffffc02018a4:	8b89                	andi	a5,a5,2
ffffffffc02018a6:	ef8d                	bnez	a5,ffffffffc02018e0 <kmalloc+0x80>
		bb->next = bigblocks;
ffffffffc02018a8:	00014797          	auipc	a5,0x14
ffffffffc02018ac:	ca078793          	addi	a5,a5,-864 # ffffffffc0215548 <bigblocks>
ffffffffc02018b0:	6398                	ld	a4,0(a5)
		bigblocks = bb;
ffffffffc02018b2:	e384                	sd	s1,0(a5)
		bb->next = bigblocks;
ffffffffc02018b4:	e898                	sd	a4,16(s1)
  return __kmalloc(size, 0);
}
ffffffffc02018b6:	60e2                	ld	ra,24(sp)
ffffffffc02018b8:	8522                	mv	a0,s0
ffffffffc02018ba:	6442                	ld	s0,16(sp)
ffffffffc02018bc:	64a2                	ld	s1,8(sp)
ffffffffc02018be:	6902                	ld	s2,0(sp)
ffffffffc02018c0:	6105                	addi	sp,sp,32
ffffffffc02018c2:	8082                	ret
		m = slob_alloc(size + SLOB_UNIT, gfp, 0);
ffffffffc02018c4:	0541                	addi	a0,a0,16
ffffffffc02018c6:	e85ff0ef          	jal	ra,ffffffffc020174a <slob_alloc.constprop.0>
		return m ? (void *)(m + 1) : 0;
ffffffffc02018ca:	01050413          	addi	s0,a0,16
ffffffffc02018ce:	f565                	bnez	a0,ffffffffc02018b6 <kmalloc+0x56>
ffffffffc02018d0:	4401                	li	s0,0
}
ffffffffc02018d2:	60e2                	ld	ra,24(sp)
ffffffffc02018d4:	8522                	mv	a0,s0
ffffffffc02018d6:	6442                	ld	s0,16(sp)
ffffffffc02018d8:	64a2                	ld	s1,8(sp)
ffffffffc02018da:	6902                	ld	s2,0(sp)
ffffffffc02018dc:	6105                	addi	sp,sp,32
ffffffffc02018de:	8082                	ret
        intr_disable();
ffffffffc02018e0:	cbffe0ef          	jal	ra,ffffffffc020059e <intr_disable>
		bb->next = bigblocks;
ffffffffc02018e4:	00014797          	auipc	a5,0x14
ffffffffc02018e8:	c6478793          	addi	a5,a5,-924 # ffffffffc0215548 <bigblocks>
ffffffffc02018ec:	6398                	ld	a4,0(a5)
		bigblocks = bb;
ffffffffc02018ee:	e384                	sd	s1,0(a5)
		bb->next = bigblocks;
ffffffffc02018f0:	e898                	sd	a4,16(s1)
        intr_enable();
ffffffffc02018f2:	ca7fe0ef          	jal	ra,ffffffffc0200598 <intr_enable>
		return bb->pages;
ffffffffc02018f6:	6480                	ld	s0,8(s1)
}
ffffffffc02018f8:	60e2                	ld	ra,24(sp)
ffffffffc02018fa:	64a2                	ld	s1,8(sp)
ffffffffc02018fc:	8522                	mv	a0,s0
ffffffffc02018fe:	6442                	ld	s0,16(sp)
ffffffffc0201900:	6902                	ld	s2,0(sp)
ffffffffc0201902:	6105                	addi	sp,sp,32
ffffffffc0201904:	8082                	ret
	slob_free(bb, sizeof(bigblock_t));
ffffffffc0201906:	45e1                	li	a1,24
ffffffffc0201908:	8526                	mv	a0,s1
ffffffffc020190a:	d1dff0ef          	jal	ra,ffffffffc0201626 <slob_free>
  return __kmalloc(size, 0);
ffffffffc020190e:	b765                	j	ffffffffc02018b6 <kmalloc+0x56>

ffffffffc0201910 <kfree>:
void kfree(void *block)
{
	bigblock_t *bb, **last = &bigblocks;
	unsigned long flags;

	if (!block)
ffffffffc0201910:	c561                	beqz	a0,ffffffffc02019d8 <kfree+0xc8>
{
ffffffffc0201912:	1101                	addi	sp,sp,-32
ffffffffc0201914:	e822                	sd	s0,16(sp)
ffffffffc0201916:	ec06                	sd	ra,24(sp)
ffffffffc0201918:	e426                	sd	s1,8(sp)
		return;

	if (!((unsigned long)block & (PAGE_SIZE-1))) {
ffffffffc020191a:	03451793          	slli	a5,a0,0x34
ffffffffc020191e:	842a                	mv	s0,a0
ffffffffc0201920:	e7d1                	bnez	a5,ffffffffc02019ac <kfree+0x9c>
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0201922:	100027f3          	csrr	a5,sstatus
ffffffffc0201926:	8b89                	andi	a5,a5,2
ffffffffc0201928:	ebd1                	bnez	a5,ffffffffc02019bc <kfree+0xac>
		/* might be on the big block list */
		spin_lock_irqsave(&block_lock, flags);
		for (bb = bigblocks; bb; last = &bb->next, bb = bb->next) {
ffffffffc020192a:	00014797          	auipc	a5,0x14
ffffffffc020192e:	c1e7b783          	ld	a5,-994(a5) # ffffffffc0215548 <bigblocks>
    return 0;
ffffffffc0201932:	4601                	li	a2,0
ffffffffc0201934:	cfa5                	beqz	a5,ffffffffc02019ac <kfree+0x9c>
	bigblock_t *bb, **last = &bigblocks;
ffffffffc0201936:	00014697          	auipc	a3,0x14
ffffffffc020193a:	c1268693          	addi	a3,a3,-1006 # ffffffffc0215548 <bigblocks>
ffffffffc020193e:	a021                	j	ffffffffc0201946 <kfree+0x36>
		for (bb = bigblocks; bb; last = &bb->next, bb = bb->next) {
ffffffffc0201940:	01048693          	addi	a3,s1,16
ffffffffc0201944:	c3bd                	beqz	a5,ffffffffc02019aa <kfree+0x9a>
			if (bb->pages == block) {
ffffffffc0201946:	6798                	ld	a4,8(a5)
ffffffffc0201948:	84be                	mv	s1,a5
				*last = bb->next;
ffffffffc020194a:	6b9c                	ld	a5,16(a5)
			if (bb->pages == block) {
ffffffffc020194c:	fe871ae3          	bne	a4,s0,ffffffffc0201940 <kfree+0x30>
				*last = bb->next;
ffffffffc0201950:	e29c                	sd	a5,0(a3)
    if (flag) {
ffffffffc0201952:	e241                	bnez	a2,ffffffffc02019d2 <kfree+0xc2>
    return pa2page(PADDR(kva));
ffffffffc0201954:	c02007b7          	lui	a5,0xc0200
				spin_unlock_irqrestore(&block_lock, flags);
				__slob_free_pages((unsigned long)block, bb->order);
ffffffffc0201958:	4098                	lw	a4,0(s1)
ffffffffc020195a:	08f46c63          	bltu	s0,a5,ffffffffc02019f2 <kfree+0xe2>
ffffffffc020195e:	00014697          	auipc	a3,0x14
ffffffffc0201962:	c1a6b683          	ld	a3,-998(a3) # ffffffffc0215578 <va_pa_offset>
ffffffffc0201966:	8c15                	sub	s0,s0,a3
    if (PPN(pa) >= npage) {
ffffffffc0201968:	8031                	srli	s0,s0,0xc
ffffffffc020196a:	00014797          	auipc	a5,0x14
ffffffffc020196e:	bf67b783          	ld	a5,-1034(a5) # ffffffffc0215560 <npage>
ffffffffc0201972:	06f47463          	bgeu	s0,a5,ffffffffc02019da <kfree+0xca>
    return &pages[PPN(pa) - nbase];
ffffffffc0201976:	00005797          	auipc	a5,0x5
ffffffffc020197a:	17a7b783          	ld	a5,378(a5) # ffffffffc0206af0 <nbase>
ffffffffc020197e:	8c1d                	sub	s0,s0,a5
ffffffffc0201980:	00341513          	slli	a0,s0,0x3
ffffffffc0201984:	942a                	add	s0,s0,a0
ffffffffc0201986:	040e                	slli	s0,s0,0x3
  free_pages(kva2page(kva), 1 << order);
ffffffffc0201988:	00014517          	auipc	a0,0x14
ffffffffc020198c:	be053503          	ld	a0,-1056(a0) # ffffffffc0215568 <pages>
ffffffffc0201990:	4585                	li	a1,1
ffffffffc0201992:	9522                	add	a0,a0,s0
ffffffffc0201994:	00e595bb          	sllw	a1,a1,a4
ffffffffc0201998:	13e000ef          	jal	ra,ffffffffc0201ad6 <free_pages>
		spin_unlock_irqrestore(&block_lock, flags);
	}

	slob_free((slob_t *)block - 1, 0);
	return;
}
ffffffffc020199c:	6442                	ld	s0,16(sp)
ffffffffc020199e:	60e2                	ld	ra,24(sp)
				slob_free(bb, sizeof(bigblock_t));
ffffffffc02019a0:	8526                	mv	a0,s1
}
ffffffffc02019a2:	64a2                	ld	s1,8(sp)
				slob_free(bb, sizeof(bigblock_t));
ffffffffc02019a4:	45e1                	li	a1,24
}
ffffffffc02019a6:	6105                	addi	sp,sp,32
	slob_free((slob_t *)block - 1, 0);
ffffffffc02019a8:	b9bd                	j	ffffffffc0201626 <slob_free>
ffffffffc02019aa:	e20d                	bnez	a2,ffffffffc02019cc <kfree+0xbc>
ffffffffc02019ac:	ff040513          	addi	a0,s0,-16
}
ffffffffc02019b0:	6442                	ld	s0,16(sp)
ffffffffc02019b2:	60e2                	ld	ra,24(sp)
ffffffffc02019b4:	64a2                	ld	s1,8(sp)
	slob_free((slob_t *)block - 1, 0);
ffffffffc02019b6:	4581                	li	a1,0
}
ffffffffc02019b8:	6105                	addi	sp,sp,32
	slob_free((slob_t *)block - 1, 0);
ffffffffc02019ba:	b1b5                	j	ffffffffc0201626 <slob_free>
        intr_disable();
ffffffffc02019bc:	be3fe0ef          	jal	ra,ffffffffc020059e <intr_disable>
		for (bb = bigblocks; bb; last = &bb->next, bb = bb->next) {
ffffffffc02019c0:	00014797          	auipc	a5,0x14
ffffffffc02019c4:	b887b783          	ld	a5,-1144(a5) # ffffffffc0215548 <bigblocks>
        return 1;
ffffffffc02019c8:	4605                	li	a2,1
ffffffffc02019ca:	f7b5                	bnez	a5,ffffffffc0201936 <kfree+0x26>
        intr_enable();
ffffffffc02019cc:	bcdfe0ef          	jal	ra,ffffffffc0200598 <intr_enable>
ffffffffc02019d0:	bff1                	j	ffffffffc02019ac <kfree+0x9c>
ffffffffc02019d2:	bc7fe0ef          	jal	ra,ffffffffc0200598 <intr_enable>
ffffffffc02019d6:	bfbd                	j	ffffffffc0201954 <kfree+0x44>
ffffffffc02019d8:	8082                	ret
        panic("pa2page called with invalid pa");
ffffffffc02019da:	00004617          	auipc	a2,0x4
ffffffffc02019de:	f4660613          	addi	a2,a2,-186 # ffffffffc0205920 <default_pmm_manager+0x108>
ffffffffc02019e2:	06200593          	li	a1,98
ffffffffc02019e6:	00004517          	auipc	a0,0x4
ffffffffc02019ea:	e9250513          	addi	a0,a0,-366 # ffffffffc0205878 <default_pmm_manager+0x60>
ffffffffc02019ee:	a59fe0ef          	jal	ra,ffffffffc0200446 <__panic>
    return pa2page(PADDR(kva));
ffffffffc02019f2:	86a2                	mv	a3,s0
ffffffffc02019f4:	00004617          	auipc	a2,0x4
ffffffffc02019f8:	f0460613          	addi	a2,a2,-252 # ffffffffc02058f8 <default_pmm_manager+0xe0>
ffffffffc02019fc:	06e00593          	li	a1,110
ffffffffc0201a00:	00004517          	auipc	a0,0x4
ffffffffc0201a04:	e7850513          	addi	a0,a0,-392 # ffffffffc0205878 <default_pmm_manager+0x60>
ffffffffc0201a08:	a3ffe0ef          	jal	ra,ffffffffc0200446 <__panic>

ffffffffc0201a0c <pa2page.part.0>:
pa2page(uintptr_t pa) {
ffffffffc0201a0c:	1141                	addi	sp,sp,-16
        panic("pa2page called with invalid pa");
ffffffffc0201a0e:	00004617          	auipc	a2,0x4
ffffffffc0201a12:	f1260613          	addi	a2,a2,-238 # ffffffffc0205920 <default_pmm_manager+0x108>
ffffffffc0201a16:	06200593          	li	a1,98
ffffffffc0201a1a:	00004517          	auipc	a0,0x4
ffffffffc0201a1e:	e5e50513          	addi	a0,a0,-418 # ffffffffc0205878 <default_pmm_manager+0x60>
pa2page(uintptr_t pa) {
ffffffffc0201a22:	e406                	sd	ra,8(sp)
        panic("pa2page called with invalid pa");
ffffffffc0201a24:	a23fe0ef          	jal	ra,ffffffffc0200446 <__panic>

ffffffffc0201a28 <pte2page.part.0>:
pte2page(pte_t pte) {
ffffffffc0201a28:	1141                	addi	sp,sp,-16
        panic("pte2page called with invalid pte");
ffffffffc0201a2a:	00004617          	auipc	a2,0x4
ffffffffc0201a2e:	f1660613          	addi	a2,a2,-234 # ffffffffc0205940 <default_pmm_manager+0x128>
ffffffffc0201a32:	07400593          	li	a1,116
ffffffffc0201a36:	00004517          	auipc	a0,0x4
ffffffffc0201a3a:	e4250513          	addi	a0,a0,-446 # ffffffffc0205878 <default_pmm_manager+0x60>
pte2page(pte_t pte) {
ffffffffc0201a3e:	e406                	sd	ra,8(sp)
        panic("pte2page called with invalid pte");
ffffffffc0201a40:	a07fe0ef          	jal	ra,ffffffffc0200446 <__panic>

ffffffffc0201a44 <alloc_pages>:
    pmm_manager->init_memmap(base, n);
}

// alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE
// memory
struct Page *alloc_pages(size_t n) {
ffffffffc0201a44:	7139                	addi	sp,sp,-64
ffffffffc0201a46:	f426                	sd	s1,40(sp)
ffffffffc0201a48:	f04a                	sd	s2,32(sp)
ffffffffc0201a4a:	ec4e                	sd	s3,24(sp)
ffffffffc0201a4c:	e852                	sd	s4,16(sp)
ffffffffc0201a4e:	e456                	sd	s5,8(sp)
ffffffffc0201a50:	e05a                	sd	s6,0(sp)
ffffffffc0201a52:	fc06                	sd	ra,56(sp)
ffffffffc0201a54:	f822                	sd	s0,48(sp)
ffffffffc0201a56:	84aa                	mv	s1,a0
ffffffffc0201a58:	00014917          	auipc	s2,0x14
ffffffffc0201a5c:	b1890913          	addi	s2,s2,-1256 # ffffffffc0215570 <pmm_manager>
        {
            page = pmm_manager->alloc_pages(n);
        }
        local_intr_restore(intr_flag);

        if (page != NULL || n > 1 || swap_init_ok == 0) break;
ffffffffc0201a60:	4a05                	li	s4,1
ffffffffc0201a62:	00014a97          	auipc	s5,0x14
ffffffffc0201a66:	b2ea8a93          	addi	s5,s5,-1234 # ffffffffc0215590 <swap_init_ok>

        extern struct mm_struct *check_mm_struct;
        // cprintf("page %x, call swap_out in alloc_pages %d\n",page, n);
        swap_out(check_mm_struct, n, 0);
ffffffffc0201a6a:	0005099b          	sext.w	s3,a0
ffffffffc0201a6e:	00014b17          	auipc	s6,0x14
ffffffffc0201a72:	b2ab0b13          	addi	s6,s6,-1238 # ffffffffc0215598 <check_mm_struct>
ffffffffc0201a76:	a01d                	j	ffffffffc0201a9c <alloc_pages+0x58>
            page = pmm_manager->alloc_pages(n);
ffffffffc0201a78:	00093783          	ld	a5,0(s2)
ffffffffc0201a7c:	6f9c                	ld	a5,24(a5)
ffffffffc0201a7e:	9782                	jalr	a5
ffffffffc0201a80:	842a                	mv	s0,a0
        swap_out(check_mm_struct, n, 0);
ffffffffc0201a82:	4601                	li	a2,0
ffffffffc0201a84:	85ce                	mv	a1,s3
        if (page != NULL || n > 1 || swap_init_ok == 0) break;
ffffffffc0201a86:	ec0d                	bnez	s0,ffffffffc0201ac0 <alloc_pages+0x7c>
ffffffffc0201a88:	029a6c63          	bltu	s4,s1,ffffffffc0201ac0 <alloc_pages+0x7c>
ffffffffc0201a8c:	000aa783          	lw	a5,0(s5)
ffffffffc0201a90:	2781                	sext.w	a5,a5
ffffffffc0201a92:	c79d                	beqz	a5,ffffffffc0201ac0 <alloc_pages+0x7c>
        swap_out(check_mm_struct, n, 0);
ffffffffc0201a94:	000b3503          	ld	a0,0(s6)
ffffffffc0201a98:	10b010ef          	jal	ra,ffffffffc02033a2 <swap_out>
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0201a9c:	100027f3          	csrr	a5,sstatus
ffffffffc0201aa0:	8b89                	andi	a5,a5,2
            page = pmm_manager->alloc_pages(n);
ffffffffc0201aa2:	8526                	mv	a0,s1
ffffffffc0201aa4:	dbf1                	beqz	a5,ffffffffc0201a78 <alloc_pages+0x34>
        intr_disable();
ffffffffc0201aa6:	af9fe0ef          	jal	ra,ffffffffc020059e <intr_disable>
ffffffffc0201aaa:	00093783          	ld	a5,0(s2)
ffffffffc0201aae:	8526                	mv	a0,s1
ffffffffc0201ab0:	6f9c                	ld	a5,24(a5)
ffffffffc0201ab2:	9782                	jalr	a5
ffffffffc0201ab4:	842a                	mv	s0,a0
        intr_enable();
ffffffffc0201ab6:	ae3fe0ef          	jal	ra,ffffffffc0200598 <intr_enable>
        swap_out(check_mm_struct, n, 0);
ffffffffc0201aba:	4601                	li	a2,0
ffffffffc0201abc:	85ce                	mv	a1,s3
        if (page != NULL || n > 1 || swap_init_ok == 0) break;
ffffffffc0201abe:	d469                	beqz	s0,ffffffffc0201a88 <alloc_pages+0x44>
    }
    // cprintf("n %d,get page %x, No %d in alloc_pages\n",n,page,(page-pages));
    return page;
}
ffffffffc0201ac0:	70e2                	ld	ra,56(sp)
ffffffffc0201ac2:	8522                	mv	a0,s0
ffffffffc0201ac4:	7442                	ld	s0,48(sp)
ffffffffc0201ac6:	74a2                	ld	s1,40(sp)
ffffffffc0201ac8:	7902                	ld	s2,32(sp)
ffffffffc0201aca:	69e2                	ld	s3,24(sp)
ffffffffc0201acc:	6a42                	ld	s4,16(sp)
ffffffffc0201ace:	6aa2                	ld	s5,8(sp)
ffffffffc0201ad0:	6b02                	ld	s6,0(sp)
ffffffffc0201ad2:	6121                	addi	sp,sp,64
ffffffffc0201ad4:	8082                	ret

ffffffffc0201ad6 <free_pages>:
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0201ad6:	100027f3          	csrr	a5,sstatus
ffffffffc0201ada:	8b89                	andi	a5,a5,2
ffffffffc0201adc:	e799                	bnez	a5,ffffffffc0201aea <free_pages+0x14>
// free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory
void free_pages(struct Page *base, size_t n) {
    bool intr_flag;
    local_intr_save(intr_flag);
    {
        pmm_manager->free_pages(base, n);
ffffffffc0201ade:	00014797          	auipc	a5,0x14
ffffffffc0201ae2:	a927b783          	ld	a5,-1390(a5) # ffffffffc0215570 <pmm_manager>
ffffffffc0201ae6:	739c                	ld	a5,32(a5)
ffffffffc0201ae8:	8782                	jr	a5
void free_pages(struct Page *base, size_t n) {
ffffffffc0201aea:	1101                	addi	sp,sp,-32
ffffffffc0201aec:	ec06                	sd	ra,24(sp)
ffffffffc0201aee:	e822                	sd	s0,16(sp)
ffffffffc0201af0:	e426                	sd	s1,8(sp)
ffffffffc0201af2:	842a                	mv	s0,a0
ffffffffc0201af4:	84ae                	mv	s1,a1
        intr_disable();
ffffffffc0201af6:	aa9fe0ef          	jal	ra,ffffffffc020059e <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc0201afa:	00014797          	auipc	a5,0x14
ffffffffc0201afe:	a767b783          	ld	a5,-1418(a5) # ffffffffc0215570 <pmm_manager>
ffffffffc0201b02:	739c                	ld	a5,32(a5)
ffffffffc0201b04:	85a6                	mv	a1,s1
ffffffffc0201b06:	8522                	mv	a0,s0
ffffffffc0201b08:	9782                	jalr	a5
    }
    local_intr_restore(intr_flag);
}
ffffffffc0201b0a:	6442                	ld	s0,16(sp)
ffffffffc0201b0c:	60e2                	ld	ra,24(sp)
ffffffffc0201b0e:	64a2                	ld	s1,8(sp)
ffffffffc0201b10:	6105                	addi	sp,sp,32
        intr_enable();
ffffffffc0201b12:	a87fe06f          	j	ffffffffc0200598 <intr_enable>

ffffffffc0201b16 <nr_free_pages>:
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0201b16:	100027f3          	csrr	a5,sstatus
ffffffffc0201b1a:	8b89                	andi	a5,a5,2
ffffffffc0201b1c:	e799                	bnez	a5,ffffffffc0201b2a <nr_free_pages+0x14>
size_t nr_free_pages(void) {
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
    {
        ret = pmm_manager->nr_free_pages();
ffffffffc0201b1e:	00014797          	auipc	a5,0x14
ffffffffc0201b22:	a527b783          	ld	a5,-1454(a5) # ffffffffc0215570 <pmm_manager>
ffffffffc0201b26:	779c                	ld	a5,40(a5)
ffffffffc0201b28:	8782                	jr	a5
size_t nr_free_pages(void) {
ffffffffc0201b2a:	1141                	addi	sp,sp,-16
ffffffffc0201b2c:	e406                	sd	ra,8(sp)
ffffffffc0201b2e:	e022                	sd	s0,0(sp)
        intr_disable();
ffffffffc0201b30:	a6ffe0ef          	jal	ra,ffffffffc020059e <intr_disable>
        ret = pmm_manager->nr_free_pages();
ffffffffc0201b34:	00014797          	auipc	a5,0x14
ffffffffc0201b38:	a3c7b783          	ld	a5,-1476(a5) # ffffffffc0215570 <pmm_manager>
ffffffffc0201b3c:	779c                	ld	a5,40(a5)
ffffffffc0201b3e:	9782                	jalr	a5
ffffffffc0201b40:	842a                	mv	s0,a0
        intr_enable();
ffffffffc0201b42:	a57fe0ef          	jal	ra,ffffffffc0200598 <intr_enable>
    }
    local_intr_restore(intr_flag);
    return ret;
}
ffffffffc0201b46:	60a2                	ld	ra,8(sp)
ffffffffc0201b48:	8522                	mv	a0,s0
ffffffffc0201b4a:	6402                	ld	s0,0(sp)
ffffffffc0201b4c:	0141                	addi	sp,sp,16
ffffffffc0201b4e:	8082                	ret

ffffffffc0201b50 <get_pte>:
//  pgdir:  the kernel virtual base address of PDT
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *get_pte(pde_t *pgdir, uintptr_t la, bool create) {
    pde_t *pdep1 = &pgdir[PDX1(la)];
ffffffffc0201b50:	01e5d793          	srli	a5,a1,0x1e
ffffffffc0201b54:	1ff7f793          	andi	a5,a5,511
pte_t *get_pte(pde_t *pgdir, uintptr_t la, bool create) {
ffffffffc0201b58:	715d                	addi	sp,sp,-80
    pde_t *pdep1 = &pgdir[PDX1(la)];
ffffffffc0201b5a:	078e                	slli	a5,a5,0x3
pte_t *get_pte(pde_t *pgdir, uintptr_t la, bool create) {
ffffffffc0201b5c:	fc26                	sd	s1,56(sp)
    pde_t *pdep1 = &pgdir[PDX1(la)];
ffffffffc0201b5e:	00f504b3          	add	s1,a0,a5
    if (!(*pdep1 & PTE_V)) {
ffffffffc0201b62:	6094                	ld	a3,0(s1)
pte_t *get_pte(pde_t *pgdir, uintptr_t la, bool create) {
ffffffffc0201b64:	f84a                	sd	s2,48(sp)
ffffffffc0201b66:	f44e                	sd	s3,40(sp)
ffffffffc0201b68:	f052                	sd	s4,32(sp)
ffffffffc0201b6a:	e486                	sd	ra,72(sp)
ffffffffc0201b6c:	e0a2                	sd	s0,64(sp)
ffffffffc0201b6e:	ec56                	sd	s5,24(sp)
ffffffffc0201b70:	e85a                	sd	s6,16(sp)
ffffffffc0201b72:	e45e                	sd	s7,8(sp)
    if (!(*pdep1 & PTE_V)) {
ffffffffc0201b74:	0016f793          	andi	a5,a3,1
pte_t *get_pte(pde_t *pgdir, uintptr_t la, bool create) {
ffffffffc0201b78:	892e                	mv	s2,a1
ffffffffc0201b7a:	8a32                	mv	s4,a2
ffffffffc0201b7c:	00014997          	auipc	s3,0x14
ffffffffc0201b80:	9e498993          	addi	s3,s3,-1564 # ffffffffc0215560 <npage>
    if (!(*pdep1 & PTE_V)) {
ffffffffc0201b84:	efb5                	bnez	a5,ffffffffc0201c00 <get_pte+0xb0>
        struct Page *page;
        if (!create || (page = alloc_page()) == NULL) {
ffffffffc0201b86:	14060c63          	beqz	a2,ffffffffc0201cde <get_pte+0x18e>
ffffffffc0201b8a:	4505                	li	a0,1
ffffffffc0201b8c:	eb9ff0ef          	jal	ra,ffffffffc0201a44 <alloc_pages>
ffffffffc0201b90:	842a                	mv	s0,a0
ffffffffc0201b92:	14050663          	beqz	a0,ffffffffc0201cde <get_pte+0x18e>
    return page - pages + nbase;
ffffffffc0201b96:	00014b97          	auipc	s7,0x14
ffffffffc0201b9a:	9d2b8b93          	addi	s7,s7,-1582 # ffffffffc0215568 <pages>
ffffffffc0201b9e:	000bb503          	ld	a0,0(s7)
ffffffffc0201ba2:	00005b17          	auipc	s6,0x5
ffffffffc0201ba6:	f46b3b03          	ld	s6,-186(s6) # ffffffffc0206ae8 <error_string+0x38>
ffffffffc0201baa:	00080ab7          	lui	s5,0x80
ffffffffc0201bae:	40a40533          	sub	a0,s0,a0
ffffffffc0201bb2:	850d                	srai	a0,a0,0x3
ffffffffc0201bb4:	03650533          	mul	a0,a0,s6
            return NULL;
        }
        set_page_ref(page, 1);
        uintptr_t pa = page2pa(page);
        memset(KADDR(pa), 0, PGSIZE);
ffffffffc0201bb8:	00014997          	auipc	s3,0x14
ffffffffc0201bbc:	9a898993          	addi	s3,s3,-1624 # ffffffffc0215560 <npage>
    page->ref = val;
ffffffffc0201bc0:	4785                	li	a5,1
ffffffffc0201bc2:	0009b703          	ld	a4,0(s3)
ffffffffc0201bc6:	c01c                	sw	a5,0(s0)
    return page - pages + nbase;
ffffffffc0201bc8:	9556                	add	a0,a0,s5
ffffffffc0201bca:	00c51793          	slli	a5,a0,0xc
ffffffffc0201bce:	83b1                	srli	a5,a5,0xc
    return page2ppn(page) << PGSHIFT;
ffffffffc0201bd0:	0532                	slli	a0,a0,0xc
ffffffffc0201bd2:	14e7fd63          	bgeu	a5,a4,ffffffffc0201d2c <get_pte+0x1dc>
ffffffffc0201bd6:	00014797          	auipc	a5,0x14
ffffffffc0201bda:	9a27b783          	ld	a5,-1630(a5) # ffffffffc0215578 <va_pa_offset>
ffffffffc0201bde:	6605                	lui	a2,0x1
ffffffffc0201be0:	4581                	li	a1,0
ffffffffc0201be2:	953e                	add	a0,a0,a5
ffffffffc0201be4:	691020ef          	jal	ra,ffffffffc0204a74 <memset>
    return page - pages + nbase;
ffffffffc0201be8:	000bb683          	ld	a3,0(s7)
ffffffffc0201bec:	40d406b3          	sub	a3,s0,a3
ffffffffc0201bf0:	868d                	srai	a3,a3,0x3
ffffffffc0201bf2:	036686b3          	mul	a3,a3,s6
ffffffffc0201bf6:	96d6                	add	a3,a3,s5
  asm volatile("sfence.vma");
}

// construct PTE from a page and permission bits
static inline pte_t pte_create(uintptr_t ppn, int type) {
  return (ppn << PTE_PPN_SHIFT) | PTE_V | type;
ffffffffc0201bf8:	06aa                	slli	a3,a3,0xa
ffffffffc0201bfa:	0116e693          	ori	a3,a3,17
        *pdep1 = pte_create(page2ppn(page), PTE_U | PTE_V);
ffffffffc0201bfe:	e094                	sd	a3,0(s1)
    }
    pde_t *pdep0 = &((pte_t *)KADDR(PDE_ADDR(*pdep1)))[PDX0(la)];
ffffffffc0201c00:	77fd                	lui	a5,0xfffff
ffffffffc0201c02:	068a                	slli	a3,a3,0x2
ffffffffc0201c04:	0009b703          	ld	a4,0(s3)
ffffffffc0201c08:	8efd                	and	a3,a3,a5
ffffffffc0201c0a:	00c6d793          	srli	a5,a3,0xc
ffffffffc0201c0e:	0ce7fa63          	bgeu	a5,a4,ffffffffc0201ce2 <get_pte+0x192>
ffffffffc0201c12:	00014a97          	auipc	s5,0x14
ffffffffc0201c16:	966a8a93          	addi	s5,s5,-1690 # ffffffffc0215578 <va_pa_offset>
ffffffffc0201c1a:	000ab403          	ld	s0,0(s5)
ffffffffc0201c1e:	01595793          	srli	a5,s2,0x15
ffffffffc0201c22:	1ff7f793          	andi	a5,a5,511
ffffffffc0201c26:	96a2                	add	a3,a3,s0
ffffffffc0201c28:	00379413          	slli	s0,a5,0x3
ffffffffc0201c2c:	9436                	add	s0,s0,a3
    if (!(*pdep0 & PTE_V)) {
ffffffffc0201c2e:	6014                	ld	a3,0(s0)
ffffffffc0201c30:	0016f793          	andi	a5,a3,1
ffffffffc0201c34:	ebad                	bnez	a5,ffffffffc0201ca6 <get_pte+0x156>
        struct Page *page;
        if (!create || (page = alloc_page()) == NULL) {
ffffffffc0201c36:	0a0a0463          	beqz	s4,ffffffffc0201cde <get_pte+0x18e>
ffffffffc0201c3a:	4505                	li	a0,1
ffffffffc0201c3c:	e09ff0ef          	jal	ra,ffffffffc0201a44 <alloc_pages>
ffffffffc0201c40:	84aa                	mv	s1,a0
ffffffffc0201c42:	cd51                	beqz	a0,ffffffffc0201cde <get_pte+0x18e>
    return page - pages + nbase;
ffffffffc0201c44:	00014b97          	auipc	s7,0x14
ffffffffc0201c48:	924b8b93          	addi	s7,s7,-1756 # ffffffffc0215568 <pages>
ffffffffc0201c4c:	000bb503          	ld	a0,0(s7)
ffffffffc0201c50:	00005b17          	auipc	s6,0x5
ffffffffc0201c54:	e98b3b03          	ld	s6,-360(s6) # ffffffffc0206ae8 <error_string+0x38>
ffffffffc0201c58:	00080a37          	lui	s4,0x80
ffffffffc0201c5c:	40a48533          	sub	a0,s1,a0
ffffffffc0201c60:	850d                	srai	a0,a0,0x3
ffffffffc0201c62:	03650533          	mul	a0,a0,s6
    page->ref = val;
ffffffffc0201c66:	4785                	li	a5,1
            return NULL;
        }
        set_page_ref(page, 1);
        uintptr_t pa = page2pa(page);
        memset(KADDR(pa), 0, PGSIZE);
ffffffffc0201c68:	0009b703          	ld	a4,0(s3)
ffffffffc0201c6c:	c09c                	sw	a5,0(s1)
    return page - pages + nbase;
ffffffffc0201c6e:	9552                	add	a0,a0,s4
ffffffffc0201c70:	00c51793          	slli	a5,a0,0xc
ffffffffc0201c74:	83b1                	srli	a5,a5,0xc
    return page2ppn(page) << PGSHIFT;
ffffffffc0201c76:	0532                	slli	a0,a0,0xc
ffffffffc0201c78:	08e7fd63          	bgeu	a5,a4,ffffffffc0201d12 <get_pte+0x1c2>
ffffffffc0201c7c:	000ab783          	ld	a5,0(s5)
ffffffffc0201c80:	6605                	lui	a2,0x1
ffffffffc0201c82:	4581                	li	a1,0
ffffffffc0201c84:	953e                	add	a0,a0,a5
ffffffffc0201c86:	5ef020ef          	jal	ra,ffffffffc0204a74 <memset>
    return page - pages + nbase;
ffffffffc0201c8a:	000bb683          	ld	a3,0(s7)
ffffffffc0201c8e:	40d486b3          	sub	a3,s1,a3
ffffffffc0201c92:	868d                	srai	a3,a3,0x3
ffffffffc0201c94:	036686b3          	mul	a3,a3,s6
ffffffffc0201c98:	96d2                	add	a3,a3,s4
  return (ppn << PTE_PPN_SHIFT) | PTE_V | type;
ffffffffc0201c9a:	06aa                	slli	a3,a3,0xa
ffffffffc0201c9c:	0116e693          	ori	a3,a3,17
        *pdep0 = pte_create(page2ppn(page), PTE_U | PTE_V);
ffffffffc0201ca0:	e014                	sd	a3,0(s0)
    }
    return &((pte_t *)KADDR(PDE_ADDR(*pdep0)))[PTX(la)];
ffffffffc0201ca2:	0009b703          	ld	a4,0(s3)
ffffffffc0201ca6:	068a                	slli	a3,a3,0x2
ffffffffc0201ca8:	757d                	lui	a0,0xfffff
ffffffffc0201caa:	8ee9                	and	a3,a3,a0
ffffffffc0201cac:	00c6d793          	srli	a5,a3,0xc
ffffffffc0201cb0:	04e7f563          	bgeu	a5,a4,ffffffffc0201cfa <get_pte+0x1aa>
ffffffffc0201cb4:	000ab503          	ld	a0,0(s5)
ffffffffc0201cb8:	00c95913          	srli	s2,s2,0xc
ffffffffc0201cbc:	1ff97913          	andi	s2,s2,511
ffffffffc0201cc0:	96aa                	add	a3,a3,a0
ffffffffc0201cc2:	00391513          	slli	a0,s2,0x3
ffffffffc0201cc6:	9536                	add	a0,a0,a3
}
ffffffffc0201cc8:	60a6                	ld	ra,72(sp)
ffffffffc0201cca:	6406                	ld	s0,64(sp)
ffffffffc0201ccc:	74e2                	ld	s1,56(sp)
ffffffffc0201cce:	7942                	ld	s2,48(sp)
ffffffffc0201cd0:	79a2                	ld	s3,40(sp)
ffffffffc0201cd2:	7a02                	ld	s4,32(sp)
ffffffffc0201cd4:	6ae2                	ld	s5,24(sp)
ffffffffc0201cd6:	6b42                	ld	s6,16(sp)
ffffffffc0201cd8:	6ba2                	ld	s7,8(sp)
ffffffffc0201cda:	6161                	addi	sp,sp,80
ffffffffc0201cdc:	8082                	ret
            return NULL;
ffffffffc0201cde:	4501                	li	a0,0
ffffffffc0201ce0:	b7e5                	j	ffffffffc0201cc8 <get_pte+0x178>
    pde_t *pdep0 = &((pte_t *)KADDR(PDE_ADDR(*pdep1)))[PDX0(la)];
ffffffffc0201ce2:	00004617          	auipc	a2,0x4
ffffffffc0201ce6:	b6e60613          	addi	a2,a2,-1170 # ffffffffc0205850 <default_pmm_manager+0x38>
ffffffffc0201cea:	0e400593          	li	a1,228
ffffffffc0201cee:	00004517          	auipc	a0,0x4
ffffffffc0201cf2:	c7a50513          	addi	a0,a0,-902 # ffffffffc0205968 <default_pmm_manager+0x150>
ffffffffc0201cf6:	f50fe0ef          	jal	ra,ffffffffc0200446 <__panic>
    return &((pte_t *)KADDR(PDE_ADDR(*pdep0)))[PTX(la)];
ffffffffc0201cfa:	00004617          	auipc	a2,0x4
ffffffffc0201cfe:	b5660613          	addi	a2,a2,-1194 # ffffffffc0205850 <default_pmm_manager+0x38>
ffffffffc0201d02:	0ef00593          	li	a1,239
ffffffffc0201d06:	00004517          	auipc	a0,0x4
ffffffffc0201d0a:	c6250513          	addi	a0,a0,-926 # ffffffffc0205968 <default_pmm_manager+0x150>
ffffffffc0201d0e:	f38fe0ef          	jal	ra,ffffffffc0200446 <__panic>
        memset(KADDR(pa), 0, PGSIZE);
ffffffffc0201d12:	86aa                	mv	a3,a0
ffffffffc0201d14:	00004617          	auipc	a2,0x4
ffffffffc0201d18:	b3c60613          	addi	a2,a2,-1220 # ffffffffc0205850 <default_pmm_manager+0x38>
ffffffffc0201d1c:	0ec00593          	li	a1,236
ffffffffc0201d20:	00004517          	auipc	a0,0x4
ffffffffc0201d24:	c4850513          	addi	a0,a0,-952 # ffffffffc0205968 <default_pmm_manager+0x150>
ffffffffc0201d28:	f1efe0ef          	jal	ra,ffffffffc0200446 <__panic>
        memset(KADDR(pa), 0, PGSIZE);
ffffffffc0201d2c:	86aa                	mv	a3,a0
ffffffffc0201d2e:	00004617          	auipc	a2,0x4
ffffffffc0201d32:	b2260613          	addi	a2,a2,-1246 # ffffffffc0205850 <default_pmm_manager+0x38>
ffffffffc0201d36:	0e100593          	li	a1,225
ffffffffc0201d3a:	00004517          	auipc	a0,0x4
ffffffffc0201d3e:	c2e50513          	addi	a0,a0,-978 # ffffffffc0205968 <default_pmm_manager+0x150>
ffffffffc0201d42:	f04fe0ef          	jal	ra,ffffffffc0200446 <__panic>

ffffffffc0201d46 <get_page>:

// get_page - get related Page struct for linear address la using PDT pgdir
struct Page *get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store) {
ffffffffc0201d46:	1141                	addi	sp,sp,-16
ffffffffc0201d48:	e022                	sd	s0,0(sp)
ffffffffc0201d4a:	8432                	mv	s0,a2
    pte_t *ptep = get_pte(pgdir, la, 0);
ffffffffc0201d4c:	4601                	li	a2,0
struct Page *get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store) {
ffffffffc0201d4e:	e406                	sd	ra,8(sp)
    pte_t *ptep = get_pte(pgdir, la, 0);
ffffffffc0201d50:	e01ff0ef          	jal	ra,ffffffffc0201b50 <get_pte>
    if (ptep_store != NULL) {
ffffffffc0201d54:	c011                	beqz	s0,ffffffffc0201d58 <get_page+0x12>
        *ptep_store = ptep;
ffffffffc0201d56:	e008                	sd	a0,0(s0)
    }
    if (ptep != NULL && *ptep & PTE_V) {
ffffffffc0201d58:	c511                	beqz	a0,ffffffffc0201d64 <get_page+0x1e>
ffffffffc0201d5a:	611c                	ld	a5,0(a0)
        return pte2page(*ptep);
    }
    return NULL;
ffffffffc0201d5c:	4501                	li	a0,0
    if (ptep != NULL && *ptep & PTE_V) {
ffffffffc0201d5e:	0017f713          	andi	a4,a5,1
ffffffffc0201d62:	e709                	bnez	a4,ffffffffc0201d6c <get_page+0x26>
}
ffffffffc0201d64:	60a2                	ld	ra,8(sp)
ffffffffc0201d66:	6402                	ld	s0,0(sp)
ffffffffc0201d68:	0141                	addi	sp,sp,16
ffffffffc0201d6a:	8082                	ret
    return pa2page(PTE_ADDR(pte));
ffffffffc0201d6c:	078a                	slli	a5,a5,0x2
ffffffffc0201d6e:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage) {
ffffffffc0201d70:	00013717          	auipc	a4,0x13
ffffffffc0201d74:	7f073703          	ld	a4,2032(a4) # ffffffffc0215560 <npage>
ffffffffc0201d78:	02e7f263          	bgeu	a5,a4,ffffffffc0201d9c <get_page+0x56>
    return &pages[PPN(pa) - nbase];
ffffffffc0201d7c:	fff80537          	lui	a0,0xfff80
ffffffffc0201d80:	97aa                	add	a5,a5,a0
ffffffffc0201d82:	60a2                	ld	ra,8(sp)
ffffffffc0201d84:	6402                	ld	s0,0(sp)
ffffffffc0201d86:	00379513          	slli	a0,a5,0x3
ffffffffc0201d8a:	97aa                	add	a5,a5,a0
ffffffffc0201d8c:	078e                	slli	a5,a5,0x3
ffffffffc0201d8e:	00013517          	auipc	a0,0x13
ffffffffc0201d92:	7da53503          	ld	a0,2010(a0) # ffffffffc0215568 <pages>
ffffffffc0201d96:	953e                	add	a0,a0,a5
ffffffffc0201d98:	0141                	addi	sp,sp,16
ffffffffc0201d9a:	8082                	ret
ffffffffc0201d9c:	c71ff0ef          	jal	ra,ffffffffc0201a0c <pa2page.part.0>

ffffffffc0201da0 <page_remove>:
    }
}

// page_remove - free an Page which is related linear address la and has an
// validated pte
void page_remove(pde_t *pgdir, uintptr_t la) {
ffffffffc0201da0:	7179                	addi	sp,sp,-48
    pte_t *ptep = get_pte(pgdir, la, 0);
ffffffffc0201da2:	4601                	li	a2,0
void page_remove(pde_t *pgdir, uintptr_t la) {
ffffffffc0201da4:	ec26                	sd	s1,24(sp)
ffffffffc0201da6:	f406                	sd	ra,40(sp)
ffffffffc0201da8:	f022                	sd	s0,32(sp)
ffffffffc0201daa:	84ae                	mv	s1,a1
    pte_t *ptep = get_pte(pgdir, la, 0);
ffffffffc0201dac:	da5ff0ef          	jal	ra,ffffffffc0201b50 <get_pte>
    if (ptep != NULL) {
ffffffffc0201db0:	c511                	beqz	a0,ffffffffc0201dbc <page_remove+0x1c>
    if (*ptep & PTE_V) {  //(1) check if this page table entry is
ffffffffc0201db2:	611c                	ld	a5,0(a0)
ffffffffc0201db4:	842a                	mv	s0,a0
ffffffffc0201db6:	0017f713          	andi	a4,a5,1
ffffffffc0201dba:	e711                	bnez	a4,ffffffffc0201dc6 <page_remove+0x26>
        page_remove_pte(pgdir, la, ptep);
    }
}
ffffffffc0201dbc:	70a2                	ld	ra,40(sp)
ffffffffc0201dbe:	7402                	ld	s0,32(sp)
ffffffffc0201dc0:	64e2                	ld	s1,24(sp)
ffffffffc0201dc2:	6145                	addi	sp,sp,48
ffffffffc0201dc4:	8082                	ret
    return pa2page(PTE_ADDR(pte));
ffffffffc0201dc6:	078a                	slli	a5,a5,0x2
ffffffffc0201dc8:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage) {
ffffffffc0201dca:	00013717          	auipc	a4,0x13
ffffffffc0201dce:	79673703          	ld	a4,1942(a4) # ffffffffc0215560 <npage>
ffffffffc0201dd2:	06e7f663          	bgeu	a5,a4,ffffffffc0201e3e <page_remove+0x9e>
    return &pages[PPN(pa) - nbase];
ffffffffc0201dd6:	fff80737          	lui	a4,0xfff80
ffffffffc0201dda:	97ba                	add	a5,a5,a4
ffffffffc0201ddc:	00379513          	slli	a0,a5,0x3
ffffffffc0201de0:	97aa                	add	a5,a5,a0
ffffffffc0201de2:	078e                	slli	a5,a5,0x3
ffffffffc0201de4:	00013517          	auipc	a0,0x13
ffffffffc0201de8:	78453503          	ld	a0,1924(a0) # ffffffffc0215568 <pages>
ffffffffc0201dec:	953e                	add	a0,a0,a5
    page->ref -= 1;
ffffffffc0201dee:	411c                	lw	a5,0(a0)
ffffffffc0201df0:	fff7871b          	addiw	a4,a5,-1
ffffffffc0201df4:	c118                	sw	a4,0(a0)
        if (page_ref(page) ==
ffffffffc0201df6:	cb11                	beqz	a4,ffffffffc0201e0a <page_remove+0x6a>
        *ptep = 0;                  //(5) clear second page table entry
ffffffffc0201df8:	00043023          	sd	zero,0(s0)
// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void tlb_invalidate(pde_t *pgdir, uintptr_t la) {
    // flush_tlb();
    // The flush_tlb flush the entire TLB, is there any better way?
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc0201dfc:	12048073          	sfence.vma	s1
}
ffffffffc0201e00:	70a2                	ld	ra,40(sp)
ffffffffc0201e02:	7402                	ld	s0,32(sp)
ffffffffc0201e04:	64e2                	ld	s1,24(sp)
ffffffffc0201e06:	6145                	addi	sp,sp,48
ffffffffc0201e08:	8082                	ret
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0201e0a:	100027f3          	csrr	a5,sstatus
ffffffffc0201e0e:	8b89                	andi	a5,a5,2
ffffffffc0201e10:	eb89                	bnez	a5,ffffffffc0201e22 <page_remove+0x82>
        pmm_manager->free_pages(base, n);
ffffffffc0201e12:	00013797          	auipc	a5,0x13
ffffffffc0201e16:	75e7b783          	ld	a5,1886(a5) # ffffffffc0215570 <pmm_manager>
ffffffffc0201e1a:	739c                	ld	a5,32(a5)
ffffffffc0201e1c:	4585                	li	a1,1
ffffffffc0201e1e:	9782                	jalr	a5
    if (flag) {
ffffffffc0201e20:	bfe1                	j	ffffffffc0201df8 <page_remove+0x58>
        intr_disable();
ffffffffc0201e22:	e42a                	sd	a0,8(sp)
ffffffffc0201e24:	f7afe0ef          	jal	ra,ffffffffc020059e <intr_disable>
ffffffffc0201e28:	00013797          	auipc	a5,0x13
ffffffffc0201e2c:	7487b783          	ld	a5,1864(a5) # ffffffffc0215570 <pmm_manager>
ffffffffc0201e30:	739c                	ld	a5,32(a5)
ffffffffc0201e32:	6522                	ld	a0,8(sp)
ffffffffc0201e34:	4585                	li	a1,1
ffffffffc0201e36:	9782                	jalr	a5
        intr_enable();
ffffffffc0201e38:	f60fe0ef          	jal	ra,ffffffffc0200598 <intr_enable>
ffffffffc0201e3c:	bf75                	j	ffffffffc0201df8 <page_remove+0x58>
ffffffffc0201e3e:	bcfff0ef          	jal	ra,ffffffffc0201a0c <pa2page.part.0>

ffffffffc0201e42 <page_insert>:
int page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
ffffffffc0201e42:	7139                	addi	sp,sp,-64
ffffffffc0201e44:	ec4e                	sd	s3,24(sp)
ffffffffc0201e46:	89b2                	mv	s3,a2
ffffffffc0201e48:	f822                	sd	s0,48(sp)
    pte_t *ptep = get_pte(pgdir, la, 1);
ffffffffc0201e4a:	4605                	li	a2,1
int page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
ffffffffc0201e4c:	842e                	mv	s0,a1
    pte_t *ptep = get_pte(pgdir, la, 1);
ffffffffc0201e4e:	85ce                	mv	a1,s3
int page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
ffffffffc0201e50:	f426                	sd	s1,40(sp)
ffffffffc0201e52:	fc06                	sd	ra,56(sp)
ffffffffc0201e54:	f04a                	sd	s2,32(sp)
ffffffffc0201e56:	e852                	sd	s4,16(sp)
ffffffffc0201e58:	e456                	sd	s5,8(sp)
ffffffffc0201e5a:	84b6                	mv	s1,a3
    pte_t *ptep = get_pte(pgdir, la, 1);
ffffffffc0201e5c:	cf5ff0ef          	jal	ra,ffffffffc0201b50 <get_pte>
    if (ptep == NULL) {
ffffffffc0201e60:	c17d                	beqz	a0,ffffffffc0201f46 <page_insert+0x104>
    page->ref += 1;
ffffffffc0201e62:	4014                	lw	a3,0(s0)
    if (*ptep & PTE_V) {
ffffffffc0201e64:	611c                	ld	a5,0(a0)
ffffffffc0201e66:	8a2a                	mv	s4,a0
ffffffffc0201e68:	0016871b          	addiw	a4,a3,1
ffffffffc0201e6c:	c018                	sw	a4,0(s0)
ffffffffc0201e6e:	0017f713          	andi	a4,a5,1
ffffffffc0201e72:	e339                	bnez	a4,ffffffffc0201eb8 <page_insert+0x76>
    return page - pages + nbase;
ffffffffc0201e74:	00013797          	auipc	a5,0x13
ffffffffc0201e78:	6f47b783          	ld	a5,1780(a5) # ffffffffc0215568 <pages>
ffffffffc0201e7c:	40f407b3          	sub	a5,s0,a5
ffffffffc0201e80:	878d                	srai	a5,a5,0x3
ffffffffc0201e82:	00005417          	auipc	s0,0x5
ffffffffc0201e86:	c6643403          	ld	s0,-922(s0) # ffffffffc0206ae8 <error_string+0x38>
ffffffffc0201e8a:	028787b3          	mul	a5,a5,s0
ffffffffc0201e8e:	00080437          	lui	s0,0x80
ffffffffc0201e92:	97a2                	add	a5,a5,s0
  return (ppn << PTE_PPN_SHIFT) | PTE_V | type;
ffffffffc0201e94:	07aa                	slli	a5,a5,0xa
ffffffffc0201e96:	8cdd                	or	s1,s1,a5
ffffffffc0201e98:	0014e493          	ori	s1,s1,1
    *ptep = pte_create(page2ppn(page), PTE_V | perm);
ffffffffc0201e9c:	009a3023          	sd	s1,0(s4) # 80000 <kern_entry-0xffffffffc0180000>
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc0201ea0:	12098073          	sfence.vma	s3
    return 0;
ffffffffc0201ea4:	4501                	li	a0,0
}
ffffffffc0201ea6:	70e2                	ld	ra,56(sp)
ffffffffc0201ea8:	7442                	ld	s0,48(sp)
ffffffffc0201eaa:	74a2                	ld	s1,40(sp)
ffffffffc0201eac:	7902                	ld	s2,32(sp)
ffffffffc0201eae:	69e2                	ld	s3,24(sp)
ffffffffc0201eb0:	6a42                	ld	s4,16(sp)
ffffffffc0201eb2:	6aa2                	ld	s5,8(sp)
ffffffffc0201eb4:	6121                	addi	sp,sp,64
ffffffffc0201eb6:	8082                	ret
    return pa2page(PTE_ADDR(pte));
ffffffffc0201eb8:	00279713          	slli	a4,a5,0x2
ffffffffc0201ebc:	8331                	srli	a4,a4,0xc
    if (PPN(pa) >= npage) {
ffffffffc0201ebe:	00013797          	auipc	a5,0x13
ffffffffc0201ec2:	6a27b783          	ld	a5,1698(a5) # ffffffffc0215560 <npage>
ffffffffc0201ec6:	08f77263          	bgeu	a4,a5,ffffffffc0201f4a <page_insert+0x108>
    return &pages[PPN(pa) - nbase];
ffffffffc0201eca:	fff807b7          	lui	a5,0xfff80
ffffffffc0201ece:	973e                	add	a4,a4,a5
ffffffffc0201ed0:	00013a97          	auipc	s5,0x13
ffffffffc0201ed4:	698a8a93          	addi	s5,s5,1688 # ffffffffc0215568 <pages>
ffffffffc0201ed8:	000ab783          	ld	a5,0(s5)
ffffffffc0201edc:	00371913          	slli	s2,a4,0x3
ffffffffc0201ee0:	993a                	add	s2,s2,a4
ffffffffc0201ee2:	090e                	slli	s2,s2,0x3
ffffffffc0201ee4:	993e                	add	s2,s2,a5
        if (p == page) {
ffffffffc0201ee6:	01240c63          	beq	s0,s2,ffffffffc0201efe <page_insert+0xbc>
    page->ref -= 1;
ffffffffc0201eea:	00092703          	lw	a4,0(s2)
ffffffffc0201eee:	fff7069b          	addiw	a3,a4,-1
ffffffffc0201ef2:	00d92023          	sw	a3,0(s2)
        if (page_ref(page) ==
ffffffffc0201ef6:	c691                	beqz	a3,ffffffffc0201f02 <page_insert+0xc0>
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc0201ef8:	12098073          	sfence.vma	s3
}
ffffffffc0201efc:	b741                	j	ffffffffc0201e7c <page_insert+0x3a>
ffffffffc0201efe:	c014                	sw	a3,0(s0)
    return page->ref;
ffffffffc0201f00:	bfb5                	j	ffffffffc0201e7c <page_insert+0x3a>
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0201f02:	100027f3          	csrr	a5,sstatus
ffffffffc0201f06:	8b89                	andi	a5,a5,2
ffffffffc0201f08:	ef91                	bnez	a5,ffffffffc0201f24 <page_insert+0xe2>
        pmm_manager->free_pages(base, n);
ffffffffc0201f0a:	00013797          	auipc	a5,0x13
ffffffffc0201f0e:	6667b783          	ld	a5,1638(a5) # ffffffffc0215570 <pmm_manager>
ffffffffc0201f12:	739c                	ld	a5,32(a5)
ffffffffc0201f14:	4585                	li	a1,1
ffffffffc0201f16:	854a                	mv	a0,s2
ffffffffc0201f18:	9782                	jalr	a5
    return page - pages + nbase;
ffffffffc0201f1a:	000ab783          	ld	a5,0(s5)
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc0201f1e:	12098073          	sfence.vma	s3
ffffffffc0201f22:	bfa9                	j	ffffffffc0201e7c <page_insert+0x3a>
        intr_disable();
ffffffffc0201f24:	e7afe0ef          	jal	ra,ffffffffc020059e <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc0201f28:	00013797          	auipc	a5,0x13
ffffffffc0201f2c:	6487b783          	ld	a5,1608(a5) # ffffffffc0215570 <pmm_manager>
ffffffffc0201f30:	739c                	ld	a5,32(a5)
ffffffffc0201f32:	4585                	li	a1,1
ffffffffc0201f34:	854a                	mv	a0,s2
ffffffffc0201f36:	9782                	jalr	a5
        intr_enable();
ffffffffc0201f38:	e60fe0ef          	jal	ra,ffffffffc0200598 <intr_enable>
ffffffffc0201f3c:	000ab783          	ld	a5,0(s5)
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc0201f40:	12098073          	sfence.vma	s3
ffffffffc0201f44:	bf25                	j	ffffffffc0201e7c <page_insert+0x3a>
        return -E_NO_MEM;
ffffffffc0201f46:	5571                	li	a0,-4
ffffffffc0201f48:	bfb9                	j	ffffffffc0201ea6 <page_insert+0x64>
ffffffffc0201f4a:	ac3ff0ef          	jal	ra,ffffffffc0201a0c <pa2page.part.0>

ffffffffc0201f4e <pmm_init>:
    pmm_manager = &default_pmm_manager;
ffffffffc0201f4e:	00004797          	auipc	a5,0x4
ffffffffc0201f52:	8ca78793          	addi	a5,a5,-1846 # ffffffffc0205818 <default_pmm_manager>
    cprintf("memory management: %s\n", pmm_manager->name);
ffffffffc0201f56:	638c                	ld	a1,0(a5)
void pmm_init(void) {
ffffffffc0201f58:	7159                	addi	sp,sp,-112
ffffffffc0201f5a:	f45e                	sd	s7,40(sp)
    cprintf("memory management: %s\n", pmm_manager->name);
ffffffffc0201f5c:	00004517          	auipc	a0,0x4
ffffffffc0201f60:	a1c50513          	addi	a0,a0,-1508 # ffffffffc0205978 <default_pmm_manager+0x160>
    pmm_manager = &default_pmm_manager;
ffffffffc0201f64:	00013b97          	auipc	s7,0x13
ffffffffc0201f68:	60cb8b93          	addi	s7,s7,1548 # ffffffffc0215570 <pmm_manager>
void pmm_init(void) {
ffffffffc0201f6c:	f486                	sd	ra,104(sp)
ffffffffc0201f6e:	eca6                	sd	s1,88(sp)
ffffffffc0201f70:	e4ce                	sd	s3,72(sp)
ffffffffc0201f72:	f85a                	sd	s6,48(sp)
    pmm_manager = &default_pmm_manager;
ffffffffc0201f74:	00fbb023          	sd	a5,0(s7)
void pmm_init(void) {
ffffffffc0201f78:	f0a2                	sd	s0,96(sp)
ffffffffc0201f7a:	e8ca                	sd	s2,80(sp)
ffffffffc0201f7c:	e0d2                	sd	s4,64(sp)
ffffffffc0201f7e:	fc56                	sd	s5,56(sp)
ffffffffc0201f80:	f062                	sd	s8,32(sp)
ffffffffc0201f82:	ec66                	sd	s9,24(sp)
ffffffffc0201f84:	e86a                	sd	s10,16(sp)
    cprintf("memory management: %s\n", pmm_manager->name);
ffffffffc0201f86:	9fafe0ef          	jal	ra,ffffffffc0200180 <cprintf>
    pmm_manager->init();
ffffffffc0201f8a:	000bb783          	ld	a5,0(s7)
    va_pa_offset = KERNBASE - 0x80200000;
ffffffffc0201f8e:	00013997          	auipc	s3,0x13
ffffffffc0201f92:	5ea98993          	addi	s3,s3,1514 # ffffffffc0215578 <va_pa_offset>
    npage = maxpa / PGSIZE;
ffffffffc0201f96:	00013497          	auipc	s1,0x13
ffffffffc0201f9a:	5ca48493          	addi	s1,s1,1482 # ffffffffc0215560 <npage>
    pmm_manager->init();
ffffffffc0201f9e:	679c                	ld	a5,8(a5)
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
ffffffffc0201fa0:	00013b17          	auipc	s6,0x13
ffffffffc0201fa4:	5c8b0b13          	addi	s6,s6,1480 # ffffffffc0215568 <pages>
    pmm_manager->init();
ffffffffc0201fa8:	9782                	jalr	a5
    va_pa_offset = KERNBASE - 0x80200000;
ffffffffc0201faa:	57f5                	li	a5,-3
ffffffffc0201fac:	07fa                	slli	a5,a5,0x1e
    cprintf("physcial memory map:\n");
ffffffffc0201fae:	00004517          	auipc	a0,0x4
ffffffffc0201fb2:	9e250513          	addi	a0,a0,-1566 # ffffffffc0205990 <default_pmm_manager+0x178>
    va_pa_offset = KERNBASE - 0x80200000;
ffffffffc0201fb6:	00f9b023          	sd	a5,0(s3)
    cprintf("physcial memory map:\n");
ffffffffc0201fba:	9c6fe0ef          	jal	ra,ffffffffc0200180 <cprintf>
    cprintf("  memory: 0x%08lx, [0x%08lx, 0x%08lx].\n", mem_size, mem_begin,
ffffffffc0201fbe:	46c5                	li	a3,17
ffffffffc0201fc0:	06ee                	slli	a3,a3,0x1b
ffffffffc0201fc2:	40100613          	li	a2,1025
ffffffffc0201fc6:	16fd                	addi	a3,a3,-1
ffffffffc0201fc8:	07e005b7          	lui	a1,0x7e00
ffffffffc0201fcc:	0656                	slli	a2,a2,0x15
ffffffffc0201fce:	00004517          	auipc	a0,0x4
ffffffffc0201fd2:	9da50513          	addi	a0,a0,-1574 # ffffffffc02059a8 <default_pmm_manager+0x190>
ffffffffc0201fd6:	9aafe0ef          	jal	ra,ffffffffc0200180 <cprintf>
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
ffffffffc0201fda:	777d                	lui	a4,0xfffff
ffffffffc0201fdc:	00014797          	auipc	a5,0x14
ffffffffc0201fe0:	5e778793          	addi	a5,a5,1511 # ffffffffc02165c3 <end+0xfff>
ffffffffc0201fe4:	8ff9                	and	a5,a5,a4
    npage = maxpa / PGSIZE;
ffffffffc0201fe6:	00088737          	lui	a4,0x88
ffffffffc0201fea:	e098                	sd	a4,0(s1)
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
ffffffffc0201fec:	00fb3023          	sd	a5,0(s6)
ffffffffc0201ff0:	4681                	li	a3,0
    for (size_t i = 0; i < npage - nbase; i++) {
ffffffffc0201ff2:	4701                	li	a4,0
ffffffffc0201ff4:	4585                	li	a1,1
ffffffffc0201ff6:	fff80837          	lui	a6,0xfff80
ffffffffc0201ffa:	a019                	j	ffffffffc0202000 <pmm_init+0xb2>
        SetPageReserved(pages + i);
ffffffffc0201ffc:	000b3783          	ld	a5,0(s6)
ffffffffc0202000:	97b6                	add	a5,a5,a3
ffffffffc0202002:	07a1                	addi	a5,a5,8
ffffffffc0202004:	40b7b02f          	amoor.d	zero,a1,(a5)
    for (size_t i = 0; i < npage - nbase; i++) {
ffffffffc0202008:	609c                	ld	a5,0(s1)
ffffffffc020200a:	0705                	addi	a4,a4,1
ffffffffc020200c:	04868693          	addi	a3,a3,72
ffffffffc0202010:	01078633          	add	a2,a5,a6
ffffffffc0202014:	fec764e3          	bltu	a4,a2,ffffffffc0201ffc <pmm_init+0xae>
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc0202018:	000b3503          	ld	a0,0(s6)
ffffffffc020201c:	00379693          	slli	a3,a5,0x3
ffffffffc0202020:	96be                	add	a3,a3,a5
ffffffffc0202022:	fdc00737          	lui	a4,0xfdc00
ffffffffc0202026:	972a                	add	a4,a4,a0
ffffffffc0202028:	068e                	slli	a3,a3,0x3
ffffffffc020202a:	96ba                	add	a3,a3,a4
ffffffffc020202c:	c0200737          	lui	a4,0xc0200
ffffffffc0202030:	66e6e163          	bltu	a3,a4,ffffffffc0202692 <pmm_init+0x744>
ffffffffc0202034:	0009b583          	ld	a1,0(s3)
    if (freemem < mem_end) {
ffffffffc0202038:	4645                	li	a2,17
ffffffffc020203a:	066e                	slli	a2,a2,0x1b
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc020203c:	8e8d                	sub	a3,a3,a1
    if (freemem < mem_end) {
ffffffffc020203e:	4ec6ee63          	bltu	a3,a2,ffffffffc020253a <pmm_init+0x5ec>
    cprintf("vapaofset is %llu\n",va_pa_offset);
ffffffffc0202042:	00004517          	auipc	a0,0x4
ffffffffc0202046:	98e50513          	addi	a0,a0,-1650 # ffffffffc02059d0 <default_pmm_manager+0x1b8>
ffffffffc020204a:	936fe0ef          	jal	ra,ffffffffc0200180 <cprintf>

    return page;
}

static void check_alloc_page(void) {
    pmm_manager->check();
ffffffffc020204e:	000bb783          	ld	a5,0(s7)
    boot_pgdir = (pte_t*)boot_page_table_sv39;
ffffffffc0202052:	00013917          	auipc	s2,0x13
ffffffffc0202056:	50690913          	addi	s2,s2,1286 # ffffffffc0215558 <boot_pgdir>
    pmm_manager->check();
ffffffffc020205a:	7b9c                	ld	a5,48(a5)
ffffffffc020205c:	9782                	jalr	a5
    cprintf("check_alloc_page() succeeded!\n");
ffffffffc020205e:	00004517          	auipc	a0,0x4
ffffffffc0202062:	98a50513          	addi	a0,a0,-1654 # ffffffffc02059e8 <default_pmm_manager+0x1d0>
ffffffffc0202066:	91afe0ef          	jal	ra,ffffffffc0200180 <cprintf>
    boot_pgdir = (pte_t*)boot_page_table_sv39;
ffffffffc020206a:	00007697          	auipc	a3,0x7
ffffffffc020206e:	f9668693          	addi	a3,a3,-106 # ffffffffc0209000 <boot_page_table_sv39>
ffffffffc0202072:	00d93023          	sd	a3,0(s2)
    boot_cr3 = PADDR(boot_pgdir);
ffffffffc0202076:	c02007b7          	lui	a5,0xc0200
ffffffffc020207a:	62f6e863          	bltu	a3,a5,ffffffffc02026aa <pmm_init+0x75c>
ffffffffc020207e:	0009b783          	ld	a5,0(s3)
ffffffffc0202082:	8e9d                	sub	a3,a3,a5
ffffffffc0202084:	00013797          	auipc	a5,0x13
ffffffffc0202088:	4cd7b623          	sd	a3,1228(a5) # ffffffffc0215550 <boot_cr3>
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc020208c:	100027f3          	csrr	a5,sstatus
ffffffffc0202090:	8b89                	andi	a5,a5,2
ffffffffc0202092:	4c079e63          	bnez	a5,ffffffffc020256e <pmm_init+0x620>
        ret = pmm_manager->nr_free_pages();
ffffffffc0202096:	000bb783          	ld	a5,0(s7)
ffffffffc020209a:	779c                	ld	a5,40(a5)
ffffffffc020209c:	9782                	jalr	a5
ffffffffc020209e:	842a                	mv	s0,a0
    // so npage is always larger than KMEMSIZE / PGSIZE
    size_t nr_free_store;

    nr_free_store=nr_free_pages();

    assert(npage <= KERNTOP / PGSIZE);
ffffffffc02020a0:	6098                	ld	a4,0(s1)
ffffffffc02020a2:	c80007b7          	lui	a5,0xc8000
ffffffffc02020a6:	83b1                	srli	a5,a5,0xc
ffffffffc02020a8:	62e7ed63          	bltu	a5,a4,ffffffffc02026e2 <pmm_init+0x794>
    assert(boot_pgdir != NULL && (uint32_t)PGOFF(boot_pgdir) == 0);
ffffffffc02020ac:	00093503          	ld	a0,0(s2)
ffffffffc02020b0:	60050963          	beqz	a0,ffffffffc02026c2 <pmm_init+0x774>
ffffffffc02020b4:	03451793          	slli	a5,a0,0x34
ffffffffc02020b8:	60079563          	bnez	a5,ffffffffc02026c2 <pmm_init+0x774>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
ffffffffc02020bc:	4601                	li	a2,0
ffffffffc02020be:	4581                	li	a1,0
ffffffffc02020c0:	c87ff0ef          	jal	ra,ffffffffc0201d46 <get_page>
ffffffffc02020c4:	68051163          	bnez	a0,ffffffffc0202746 <pmm_init+0x7f8>

    struct Page *p1, *p2;
    p1 = alloc_page();
ffffffffc02020c8:	4505                	li	a0,1
ffffffffc02020ca:	97bff0ef          	jal	ra,ffffffffc0201a44 <alloc_pages>
ffffffffc02020ce:	8a2a                	mv	s4,a0
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
ffffffffc02020d0:	00093503          	ld	a0,0(s2)
ffffffffc02020d4:	4681                	li	a3,0
ffffffffc02020d6:	4601                	li	a2,0
ffffffffc02020d8:	85d2                	mv	a1,s4
ffffffffc02020da:	d69ff0ef          	jal	ra,ffffffffc0201e42 <page_insert>
ffffffffc02020de:	64051463          	bnez	a0,ffffffffc0202726 <pmm_init+0x7d8>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
ffffffffc02020e2:	00093503          	ld	a0,0(s2)
ffffffffc02020e6:	4601                	li	a2,0
ffffffffc02020e8:	4581                	li	a1,0
ffffffffc02020ea:	a67ff0ef          	jal	ra,ffffffffc0201b50 <get_pte>
ffffffffc02020ee:	60050c63          	beqz	a0,ffffffffc0202706 <pmm_init+0x7b8>
    assert(pte2page(*ptep) == p1);
ffffffffc02020f2:	611c                	ld	a5,0(a0)
    if (!(pte & PTE_V)) {
ffffffffc02020f4:	0017f713          	andi	a4,a5,1
ffffffffc02020f8:	60070563          	beqz	a4,ffffffffc0202702 <pmm_init+0x7b4>
    if (PPN(pa) >= npage) {
ffffffffc02020fc:	6090                	ld	a2,0(s1)
    return pa2page(PTE_ADDR(pte));
ffffffffc02020fe:	078a                	slli	a5,a5,0x2
ffffffffc0202100:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage) {
ffffffffc0202102:	58c7f663          	bgeu	a5,a2,ffffffffc020268e <pmm_init+0x740>
    return &pages[PPN(pa) - nbase];
ffffffffc0202106:	fff80737          	lui	a4,0xfff80
ffffffffc020210a:	97ba                	add	a5,a5,a4
ffffffffc020210c:	000b3683          	ld	a3,0(s6)
ffffffffc0202110:	00379713          	slli	a4,a5,0x3
ffffffffc0202114:	97ba                	add	a5,a5,a4
ffffffffc0202116:	078e                	slli	a5,a5,0x3
ffffffffc0202118:	97b6                	add	a5,a5,a3
ffffffffc020211a:	14fa1fe3          	bne	s4,a5,ffffffffc0202a78 <pmm_init+0xb2a>
    assert(page_ref(p1) == 1);
ffffffffc020211e:	000a2703          	lw	a4,0(s4)
ffffffffc0202122:	4785                	li	a5,1
ffffffffc0202124:	18f716e3          	bne	a4,a5,ffffffffc0202ab0 <pmm_init+0xb62>

    ptep = (pte_t *)KADDR(PDE_ADDR(boot_pgdir[0]));
ffffffffc0202128:	00093503          	ld	a0,0(s2)
ffffffffc020212c:	77fd                	lui	a5,0xfffff
ffffffffc020212e:	6114                	ld	a3,0(a0)
ffffffffc0202130:	068a                	slli	a3,a3,0x2
ffffffffc0202132:	8efd                	and	a3,a3,a5
ffffffffc0202134:	00c6d713          	srli	a4,a3,0xc
ffffffffc0202138:	16c770e3          	bgeu	a4,a2,ffffffffc0202a98 <pmm_init+0xb4a>
ffffffffc020213c:	0009bc03          	ld	s8,0(s3)
    ptep = (pte_t *)KADDR(PDE_ADDR(ptep[0])) + 1;
ffffffffc0202140:	96e2                	add	a3,a3,s8
ffffffffc0202142:	0006ba83          	ld	s5,0(a3)
ffffffffc0202146:	0a8a                	slli	s5,s5,0x2
ffffffffc0202148:	00fafab3          	and	s5,s5,a5
ffffffffc020214c:	00cad793          	srli	a5,s5,0xc
ffffffffc0202150:	66c7fb63          	bgeu	a5,a2,ffffffffc02027c6 <pmm_init+0x878>
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
ffffffffc0202154:	4601                	li	a2,0
ffffffffc0202156:	6585                	lui	a1,0x1
    ptep = (pte_t *)KADDR(PDE_ADDR(ptep[0])) + 1;
ffffffffc0202158:	9ae2                	add	s5,s5,s8
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
ffffffffc020215a:	9f7ff0ef          	jal	ra,ffffffffc0201b50 <get_pte>
    ptep = (pte_t *)KADDR(PDE_ADDR(ptep[0])) + 1;
ffffffffc020215e:	0aa1                	addi	s5,s5,8
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
ffffffffc0202160:	65551363          	bne	a0,s5,ffffffffc02027a6 <pmm_init+0x858>

    p2 = alloc_page();
ffffffffc0202164:	4505                	li	a0,1
ffffffffc0202166:	8dfff0ef          	jal	ra,ffffffffc0201a44 <alloc_pages>
ffffffffc020216a:	8aaa                	mv	s5,a0
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
ffffffffc020216c:	00093503          	ld	a0,0(s2)
ffffffffc0202170:	46d1                	li	a3,20
ffffffffc0202172:	6605                	lui	a2,0x1
ffffffffc0202174:	85d6                	mv	a1,s5
ffffffffc0202176:	ccdff0ef          	jal	ra,ffffffffc0201e42 <page_insert>
ffffffffc020217a:	5e051663          	bnez	a0,ffffffffc0202766 <pmm_init+0x818>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
ffffffffc020217e:	00093503          	ld	a0,0(s2)
ffffffffc0202182:	4601                	li	a2,0
ffffffffc0202184:	6585                	lui	a1,0x1
ffffffffc0202186:	9cbff0ef          	jal	ra,ffffffffc0201b50 <get_pte>
ffffffffc020218a:	140503e3          	beqz	a0,ffffffffc0202ad0 <pmm_init+0xb82>
    assert(*ptep & PTE_U);
ffffffffc020218e:	611c                	ld	a5,0(a0)
ffffffffc0202190:	0107f713          	andi	a4,a5,16
ffffffffc0202194:	74070663          	beqz	a4,ffffffffc02028e0 <pmm_init+0x992>
    assert(*ptep & PTE_W);
ffffffffc0202198:	8b91                	andi	a5,a5,4
ffffffffc020219a:	70078363          	beqz	a5,ffffffffc02028a0 <pmm_init+0x952>
    assert(boot_pgdir[0] & PTE_U);
ffffffffc020219e:	00093503          	ld	a0,0(s2)
ffffffffc02021a2:	611c                	ld	a5,0(a0)
ffffffffc02021a4:	8bc1                	andi	a5,a5,16
ffffffffc02021a6:	6c078d63          	beqz	a5,ffffffffc0202880 <pmm_init+0x932>
    assert(page_ref(p2) == 1);
ffffffffc02021aa:	000aa703          	lw	a4,0(s5)
ffffffffc02021ae:	4785                	li	a5,1
ffffffffc02021b0:	5cf71b63          	bne	a4,a5,ffffffffc0202786 <pmm_init+0x838>

    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
ffffffffc02021b4:	4681                	li	a3,0
ffffffffc02021b6:	6605                	lui	a2,0x1
ffffffffc02021b8:	85d2                	mv	a1,s4
ffffffffc02021ba:	c89ff0ef          	jal	ra,ffffffffc0201e42 <page_insert>
ffffffffc02021be:	68051163          	bnez	a0,ffffffffc0202840 <pmm_init+0x8f2>
    assert(page_ref(p1) == 2);
ffffffffc02021c2:	000a2703          	lw	a4,0(s4)
ffffffffc02021c6:	4789                	li	a5,2
ffffffffc02021c8:	64f71c63          	bne	a4,a5,ffffffffc0202820 <pmm_init+0x8d2>
    assert(page_ref(p2) == 0);
ffffffffc02021cc:	000aa783          	lw	a5,0(s5)
ffffffffc02021d0:	62079863          	bnez	a5,ffffffffc0202800 <pmm_init+0x8b2>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
ffffffffc02021d4:	00093503          	ld	a0,0(s2)
ffffffffc02021d8:	4601                	li	a2,0
ffffffffc02021da:	6585                	lui	a1,0x1
ffffffffc02021dc:	975ff0ef          	jal	ra,ffffffffc0201b50 <get_pte>
ffffffffc02021e0:	60050063          	beqz	a0,ffffffffc02027e0 <pmm_init+0x892>
    assert(pte2page(*ptep) == p1);
ffffffffc02021e4:	6118                	ld	a4,0(a0)
    if (!(pte & PTE_V)) {
ffffffffc02021e6:	00177793          	andi	a5,a4,1
ffffffffc02021ea:	50078c63          	beqz	a5,ffffffffc0202702 <pmm_init+0x7b4>
    if (PPN(pa) >= npage) {
ffffffffc02021ee:	6094                	ld	a3,0(s1)
    return pa2page(PTE_ADDR(pte));
ffffffffc02021f0:	00271793          	slli	a5,a4,0x2
ffffffffc02021f4:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage) {
ffffffffc02021f6:	48d7fc63          	bgeu	a5,a3,ffffffffc020268e <pmm_init+0x740>
    return &pages[PPN(pa) - nbase];
ffffffffc02021fa:	fff806b7          	lui	a3,0xfff80
ffffffffc02021fe:	97b6                	add	a5,a5,a3
ffffffffc0202200:	000b3603          	ld	a2,0(s6)
ffffffffc0202204:	00379693          	slli	a3,a5,0x3
ffffffffc0202208:	97b6                	add	a5,a5,a3
ffffffffc020220a:	078e                	slli	a5,a5,0x3
ffffffffc020220c:	97b2                	add	a5,a5,a2
ffffffffc020220e:	72fa1963          	bne	s4,a5,ffffffffc0202940 <pmm_init+0x9f2>
    assert((*ptep & PTE_U) == 0);
ffffffffc0202212:	8b41                	andi	a4,a4,16
ffffffffc0202214:	70071663          	bnez	a4,ffffffffc0202920 <pmm_init+0x9d2>

    page_remove(boot_pgdir, 0x0);
ffffffffc0202218:	00093503          	ld	a0,0(s2)
ffffffffc020221c:	4581                	li	a1,0
ffffffffc020221e:	b83ff0ef          	jal	ra,ffffffffc0201da0 <page_remove>
    assert(page_ref(p1) == 1);
ffffffffc0202222:	000a2703          	lw	a4,0(s4)
ffffffffc0202226:	4785                	li	a5,1
ffffffffc0202228:	6cf71c63          	bne	a4,a5,ffffffffc0202900 <pmm_init+0x9b2>
    assert(page_ref(p2) == 0);
ffffffffc020222c:	000aa783          	lw	a5,0(s5)
ffffffffc0202230:	7a079463          	bnez	a5,ffffffffc02029d8 <pmm_init+0xa8a>

    page_remove(boot_pgdir, PGSIZE);
ffffffffc0202234:	00093503          	ld	a0,0(s2)
ffffffffc0202238:	6585                	lui	a1,0x1
ffffffffc020223a:	b67ff0ef          	jal	ra,ffffffffc0201da0 <page_remove>
    assert(page_ref(p1) == 0);
ffffffffc020223e:	000a2783          	lw	a5,0(s4)
ffffffffc0202242:	76079b63          	bnez	a5,ffffffffc02029b8 <pmm_init+0xa6a>
    assert(page_ref(p2) == 0);
ffffffffc0202246:	000aa783          	lw	a5,0(s5)
ffffffffc020224a:	74079763          	bnez	a5,ffffffffc0202998 <pmm_init+0xa4a>

    assert(page_ref(pde2page(boot_pgdir[0])) == 1);
ffffffffc020224e:	00093a03          	ld	s4,0(s2)
    if (PPN(pa) >= npage) {
ffffffffc0202252:	6090                	ld	a2,0(s1)
    return pa2page(PDE_ADDR(pde));
ffffffffc0202254:	000a3783          	ld	a5,0(s4)
ffffffffc0202258:	078a                	slli	a5,a5,0x2
ffffffffc020225a:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage) {
ffffffffc020225c:	42c7f963          	bgeu	a5,a2,ffffffffc020268e <pmm_init+0x740>
    return &pages[PPN(pa) - nbase];
ffffffffc0202260:	fff80737          	lui	a4,0xfff80
ffffffffc0202264:	973e                	add	a4,a4,a5
ffffffffc0202266:	00371793          	slli	a5,a4,0x3
ffffffffc020226a:	000b3503          	ld	a0,0(s6)
ffffffffc020226e:	97ba                	add	a5,a5,a4
ffffffffc0202270:	078e                	slli	a5,a5,0x3
    return page->ref;
ffffffffc0202272:	00f50733          	add	a4,a0,a5
ffffffffc0202276:	4314                	lw	a3,0(a4)
ffffffffc0202278:	4705                	li	a4,1
ffffffffc020227a:	6ee69f63          	bne	a3,a4,ffffffffc0202978 <pmm_init+0xa2a>
    return page - pages + nbase;
ffffffffc020227e:	4037d693          	srai	a3,a5,0x3
ffffffffc0202282:	00005c97          	auipc	s9,0x5
ffffffffc0202286:	866cbc83          	ld	s9,-1946(s9) # ffffffffc0206ae8 <error_string+0x38>
ffffffffc020228a:	039686b3          	mul	a3,a3,s9
ffffffffc020228e:	000805b7          	lui	a1,0x80
ffffffffc0202292:	96ae                	add	a3,a3,a1
    return KADDR(page2pa(page));
ffffffffc0202294:	00c69713          	slli	a4,a3,0xc
ffffffffc0202298:	8331                	srli	a4,a4,0xc
    return page2ppn(page) << PGSHIFT;
ffffffffc020229a:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc020229c:	6cc77263          	bgeu	a4,a2,ffffffffc0202960 <pmm_init+0xa12>

    pde_t *pd1=boot_pgdir,*pd0=page2kva(pde2page(boot_pgdir[0]));
    free_page(pde2page(pd0[0]));
ffffffffc02022a0:	0009b703          	ld	a4,0(s3)
ffffffffc02022a4:	96ba                	add	a3,a3,a4
    return pa2page(PDE_ADDR(pde));
ffffffffc02022a6:	629c                	ld	a5,0(a3)
ffffffffc02022a8:	078a                	slli	a5,a5,0x2
ffffffffc02022aa:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage) {
ffffffffc02022ac:	3ec7f163          	bgeu	a5,a2,ffffffffc020268e <pmm_init+0x740>
    return &pages[PPN(pa) - nbase];
ffffffffc02022b0:	8f8d                	sub	a5,a5,a1
ffffffffc02022b2:	00379713          	slli	a4,a5,0x3
ffffffffc02022b6:	97ba                	add	a5,a5,a4
ffffffffc02022b8:	078e                	slli	a5,a5,0x3
ffffffffc02022ba:	953e                	add	a0,a0,a5
ffffffffc02022bc:	100027f3          	csrr	a5,sstatus
ffffffffc02022c0:	8b89                	andi	a5,a5,2
ffffffffc02022c2:	30079063          	bnez	a5,ffffffffc02025c2 <pmm_init+0x674>
        pmm_manager->free_pages(base, n);
ffffffffc02022c6:	000bb783          	ld	a5,0(s7)
ffffffffc02022ca:	4585                	li	a1,1
ffffffffc02022cc:	739c                	ld	a5,32(a5)
ffffffffc02022ce:	9782                	jalr	a5
    return pa2page(PDE_ADDR(pde));
ffffffffc02022d0:	000a3783          	ld	a5,0(s4)
    if (PPN(pa) >= npage) {
ffffffffc02022d4:	6098                	ld	a4,0(s1)
    return pa2page(PDE_ADDR(pde));
ffffffffc02022d6:	078a                	slli	a5,a5,0x2
ffffffffc02022d8:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage) {
ffffffffc02022da:	3ae7fa63          	bgeu	a5,a4,ffffffffc020268e <pmm_init+0x740>
    return &pages[PPN(pa) - nbase];
ffffffffc02022de:	fff80737          	lui	a4,0xfff80
ffffffffc02022e2:	97ba                	add	a5,a5,a4
ffffffffc02022e4:	000b3503          	ld	a0,0(s6)
ffffffffc02022e8:	00379713          	slli	a4,a5,0x3
ffffffffc02022ec:	97ba                	add	a5,a5,a4
ffffffffc02022ee:	078e                	slli	a5,a5,0x3
ffffffffc02022f0:	953e                	add	a0,a0,a5
ffffffffc02022f2:	100027f3          	csrr	a5,sstatus
ffffffffc02022f6:	8b89                	andi	a5,a5,2
ffffffffc02022f8:	2a079963          	bnez	a5,ffffffffc02025aa <pmm_init+0x65c>
ffffffffc02022fc:	000bb783          	ld	a5,0(s7)
ffffffffc0202300:	4585                	li	a1,1
ffffffffc0202302:	739c                	ld	a5,32(a5)
ffffffffc0202304:	9782                	jalr	a5
    free_page(pde2page(pd1[0]));
    boot_pgdir[0] = 0;
ffffffffc0202306:	00093783          	ld	a5,0(s2)
ffffffffc020230a:	0007b023          	sd	zero,0(a5) # fffffffffffff000 <end+0x3fde9a3c>
  asm volatile("sfence.vma");
ffffffffc020230e:	12000073          	sfence.vma
ffffffffc0202312:	100027f3          	csrr	a5,sstatus
ffffffffc0202316:	8b89                	andi	a5,a5,2
ffffffffc0202318:	26079f63          	bnez	a5,ffffffffc0202596 <pmm_init+0x648>
        ret = pmm_manager->nr_free_pages();
ffffffffc020231c:	000bb783          	ld	a5,0(s7)
ffffffffc0202320:	779c                	ld	a5,40(a5)
ffffffffc0202322:	9782                	jalr	a5
ffffffffc0202324:	8a2a                	mv	s4,a0
    flush_tlb();

    assert(nr_free_store==nr_free_pages());
ffffffffc0202326:	73441963          	bne	s0,s4,ffffffffc0202a58 <pmm_init+0xb0a>

    cprintf("check_pgdir() succeeded!\n");
ffffffffc020232a:	00004517          	auipc	a0,0x4
ffffffffc020232e:	9a650513          	addi	a0,a0,-1626 # ffffffffc0205cd0 <default_pmm_manager+0x4b8>
ffffffffc0202332:	e4ffd0ef          	jal	ra,ffffffffc0200180 <cprintf>
ffffffffc0202336:	100027f3          	csrr	a5,sstatus
ffffffffc020233a:	8b89                	andi	a5,a5,2
ffffffffc020233c:	24079363          	bnez	a5,ffffffffc0202582 <pmm_init+0x634>
        ret = pmm_manager->nr_free_pages();
ffffffffc0202340:	000bb783          	ld	a5,0(s7)
ffffffffc0202344:	779c                	ld	a5,40(a5)
ffffffffc0202346:	9782                	jalr	a5
ffffffffc0202348:	8c2a                	mv	s8,a0
    pte_t *ptep;
    int i;

    nr_free_store=nr_free_pages();

    for (i = ROUNDDOWN(KERNBASE, PGSIZE); i < npage * PGSIZE; i += PGSIZE) {
ffffffffc020234a:	6098                	ld	a4,0(s1)
ffffffffc020234c:	c0200437          	lui	s0,0xc0200
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
        assert(PTE_ADDR(*ptep) == i);
ffffffffc0202350:	7afd                	lui	s5,0xfffff
    for (i = ROUNDDOWN(KERNBASE, PGSIZE); i < npage * PGSIZE; i += PGSIZE) {
ffffffffc0202352:	00c71793          	slli	a5,a4,0xc
ffffffffc0202356:	6a05                	lui	s4,0x1
ffffffffc0202358:	02f47c63          	bgeu	s0,a5,ffffffffc0202390 <pmm_init+0x442>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
ffffffffc020235c:	00c45793          	srli	a5,s0,0xc
ffffffffc0202360:	00093503          	ld	a0,0(s2)
ffffffffc0202364:	30e7f863          	bgeu	a5,a4,ffffffffc0202674 <pmm_init+0x726>
ffffffffc0202368:	0009b583          	ld	a1,0(s3)
ffffffffc020236c:	4601                	li	a2,0
ffffffffc020236e:	95a2                	add	a1,a1,s0
ffffffffc0202370:	fe0ff0ef          	jal	ra,ffffffffc0201b50 <get_pte>
ffffffffc0202374:	2e050063          	beqz	a0,ffffffffc0202654 <pmm_init+0x706>
        assert(PTE_ADDR(*ptep) == i);
ffffffffc0202378:	611c                	ld	a5,0(a0)
ffffffffc020237a:	078a                	slli	a5,a5,0x2
ffffffffc020237c:	0157f7b3          	and	a5,a5,s5
ffffffffc0202380:	2a879a63          	bne	a5,s0,ffffffffc0202634 <pmm_init+0x6e6>
    for (i = ROUNDDOWN(KERNBASE, PGSIZE); i < npage * PGSIZE; i += PGSIZE) {
ffffffffc0202384:	6098                	ld	a4,0(s1)
ffffffffc0202386:	9452                	add	s0,s0,s4
ffffffffc0202388:	00c71793          	slli	a5,a4,0xc
ffffffffc020238c:	fcf468e3          	bltu	s0,a5,ffffffffc020235c <pmm_init+0x40e>
    }

    assert(boot_pgdir[0] == 0);
ffffffffc0202390:	00093783          	ld	a5,0(s2)
ffffffffc0202394:	639c                	ld	a5,0(a5)
ffffffffc0202396:	6a079163          	bnez	a5,ffffffffc0202a38 <pmm_init+0xaea>

    struct Page *p;
    p = alloc_page();
ffffffffc020239a:	4505                	li	a0,1
ffffffffc020239c:	ea8ff0ef          	jal	ra,ffffffffc0201a44 <alloc_pages>
ffffffffc02023a0:	8aaa                	mv	s5,a0
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W | PTE_R) == 0);
ffffffffc02023a2:	00093503          	ld	a0,0(s2)
ffffffffc02023a6:	4699                	li	a3,6
ffffffffc02023a8:	10000613          	li	a2,256
ffffffffc02023ac:	85d6                	mv	a1,s5
ffffffffc02023ae:	a95ff0ef          	jal	ra,ffffffffc0201e42 <page_insert>
ffffffffc02023b2:	66051363          	bnez	a0,ffffffffc0202a18 <pmm_init+0xaca>
    assert(page_ref(p) == 1);
ffffffffc02023b6:	000aa703          	lw	a4,0(s5) # fffffffffffff000 <end+0x3fde9a3c>
ffffffffc02023ba:	4785                	li	a5,1
ffffffffc02023bc:	62f71e63          	bne	a4,a5,ffffffffc02029f8 <pmm_init+0xaaa>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W | PTE_R) == 0);
ffffffffc02023c0:	00093503          	ld	a0,0(s2)
ffffffffc02023c4:	6405                	lui	s0,0x1
ffffffffc02023c6:	4699                	li	a3,6
ffffffffc02023c8:	10040613          	addi	a2,s0,256 # 1100 <kern_entry-0xffffffffc01fef00>
ffffffffc02023cc:	85d6                	mv	a1,s5
ffffffffc02023ce:	a75ff0ef          	jal	ra,ffffffffc0201e42 <page_insert>
ffffffffc02023d2:	48051763          	bnez	a0,ffffffffc0202860 <pmm_init+0x912>
    assert(page_ref(p) == 2);
ffffffffc02023d6:	000aa703          	lw	a4,0(s5)
ffffffffc02023da:	4789                	li	a5,2
ffffffffc02023dc:	74f71a63          	bne	a4,a5,ffffffffc0202b30 <pmm_init+0xbe2>

    const char *str = "ucore: Hello world!!";
    strcpy((void *)0x100, str);
ffffffffc02023e0:	00004597          	auipc	a1,0x4
ffffffffc02023e4:	a2858593          	addi	a1,a1,-1496 # ffffffffc0205e08 <default_pmm_manager+0x5f0>
ffffffffc02023e8:	10000513          	li	a0,256
ffffffffc02023ec:	642020ef          	jal	ra,ffffffffc0204a2e <strcpy>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
ffffffffc02023f0:	10040593          	addi	a1,s0,256
ffffffffc02023f4:	10000513          	li	a0,256
ffffffffc02023f8:	648020ef          	jal	ra,ffffffffc0204a40 <strcmp>
ffffffffc02023fc:	70051a63          	bnez	a0,ffffffffc0202b10 <pmm_init+0xbc2>
    return page - pages + nbase;
ffffffffc0202400:	000b3683          	ld	a3,0(s6)
ffffffffc0202404:	00080d37          	lui	s10,0x80
    return KADDR(page2pa(page));
ffffffffc0202408:	547d                	li	s0,-1
    return page - pages + nbase;
ffffffffc020240a:	40da86b3          	sub	a3,s5,a3
ffffffffc020240e:	868d                	srai	a3,a3,0x3
ffffffffc0202410:	039686b3          	mul	a3,a3,s9
    return KADDR(page2pa(page));
ffffffffc0202414:	609c                	ld	a5,0(s1)
ffffffffc0202416:	8031                	srli	s0,s0,0xc
    return page - pages + nbase;
ffffffffc0202418:	96ea                	add	a3,a3,s10
    return KADDR(page2pa(page));
ffffffffc020241a:	0086f733          	and	a4,a3,s0
    return page2ppn(page) << PGSHIFT;
ffffffffc020241e:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0202420:	54f77063          	bgeu	a4,a5,ffffffffc0202960 <pmm_init+0xa12>

    *(char *)(page2kva(p) + 0x100) = '\0';
ffffffffc0202424:	0009b783          	ld	a5,0(s3)
    assert(strlen((const char *)0x100) == 0);
ffffffffc0202428:	10000513          	li	a0,256
    *(char *)(page2kva(p) + 0x100) = '\0';
ffffffffc020242c:	96be                	add	a3,a3,a5
ffffffffc020242e:	10068023          	sb	zero,256(a3) # fffffffffff80100 <end+0x3fd6ab3c>
    assert(strlen((const char *)0x100) == 0);
ffffffffc0202432:	5c6020ef          	jal	ra,ffffffffc02049f8 <strlen>
ffffffffc0202436:	6a051d63          	bnez	a0,ffffffffc0202af0 <pmm_init+0xba2>

    pde_t *pd1=boot_pgdir,*pd0=page2kva(pde2page(boot_pgdir[0]));
ffffffffc020243a:	00093a03          	ld	s4,0(s2)
    if (PPN(pa) >= npage) {
ffffffffc020243e:	6098                	ld	a4,0(s1)
    return pa2page(PDE_ADDR(pde));
ffffffffc0202440:	000a3783          	ld	a5,0(s4) # 1000 <kern_entry-0xffffffffc01ff000>
ffffffffc0202444:	078a                	slli	a5,a5,0x2
ffffffffc0202446:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage) {
ffffffffc0202448:	24e7f363          	bgeu	a5,a4,ffffffffc020268e <pmm_init+0x740>
    return &pages[PPN(pa) - nbase];
ffffffffc020244c:	41a787b3          	sub	a5,a5,s10
ffffffffc0202450:	00379693          	slli	a3,a5,0x3
    return page - pages + nbase;
ffffffffc0202454:	96be                	add	a3,a3,a5
ffffffffc0202456:	03968cb3          	mul	s9,a3,s9
ffffffffc020245a:	01ac86b3          	add	a3,s9,s10
    return KADDR(page2pa(page));
ffffffffc020245e:	8c75                	and	s0,s0,a3
    return page2ppn(page) << PGSHIFT;
ffffffffc0202460:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0202462:	4ee47f63          	bgeu	s0,a4,ffffffffc0202960 <pmm_init+0xa12>
ffffffffc0202466:	0009b403          	ld	s0,0(s3)
ffffffffc020246a:	9436                	add	s0,s0,a3
ffffffffc020246c:	100027f3          	csrr	a5,sstatus
ffffffffc0202470:	8b89                	andi	a5,a5,2
ffffffffc0202472:	1a079663          	bnez	a5,ffffffffc020261e <pmm_init+0x6d0>
        pmm_manager->free_pages(base, n);
ffffffffc0202476:	000bb783          	ld	a5,0(s7)
ffffffffc020247a:	4585                	li	a1,1
ffffffffc020247c:	8556                	mv	a0,s5
ffffffffc020247e:	739c                	ld	a5,32(a5)
ffffffffc0202480:	9782                	jalr	a5
    return pa2page(PDE_ADDR(pde));
ffffffffc0202482:	601c                	ld	a5,0(s0)
    if (PPN(pa) >= npage) {
ffffffffc0202484:	6098                	ld	a4,0(s1)
    return pa2page(PDE_ADDR(pde));
ffffffffc0202486:	078a                	slli	a5,a5,0x2
ffffffffc0202488:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage) {
ffffffffc020248a:	20e7f263          	bgeu	a5,a4,ffffffffc020268e <pmm_init+0x740>
    return &pages[PPN(pa) - nbase];
ffffffffc020248e:	fff80737          	lui	a4,0xfff80
ffffffffc0202492:	97ba                	add	a5,a5,a4
ffffffffc0202494:	000b3503          	ld	a0,0(s6)
ffffffffc0202498:	00379713          	slli	a4,a5,0x3
ffffffffc020249c:	97ba                	add	a5,a5,a4
ffffffffc020249e:	078e                	slli	a5,a5,0x3
ffffffffc02024a0:	953e                	add	a0,a0,a5
ffffffffc02024a2:	100027f3          	csrr	a5,sstatus
ffffffffc02024a6:	8b89                	andi	a5,a5,2
ffffffffc02024a8:	14079f63          	bnez	a5,ffffffffc0202606 <pmm_init+0x6b8>
ffffffffc02024ac:	000bb783          	ld	a5,0(s7)
ffffffffc02024b0:	4585                	li	a1,1
ffffffffc02024b2:	739c                	ld	a5,32(a5)
ffffffffc02024b4:	9782                	jalr	a5
    return pa2page(PDE_ADDR(pde));
ffffffffc02024b6:	000a3783          	ld	a5,0(s4)
    if (PPN(pa) >= npage) {
ffffffffc02024ba:	6098                	ld	a4,0(s1)
    return pa2page(PDE_ADDR(pde));
ffffffffc02024bc:	078a                	slli	a5,a5,0x2
ffffffffc02024be:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage) {
ffffffffc02024c0:	1ce7f763          	bgeu	a5,a4,ffffffffc020268e <pmm_init+0x740>
    return &pages[PPN(pa) - nbase];
ffffffffc02024c4:	fff80737          	lui	a4,0xfff80
ffffffffc02024c8:	97ba                	add	a5,a5,a4
ffffffffc02024ca:	000b3503          	ld	a0,0(s6)
ffffffffc02024ce:	00379713          	slli	a4,a5,0x3
ffffffffc02024d2:	97ba                	add	a5,a5,a4
ffffffffc02024d4:	078e                	slli	a5,a5,0x3
ffffffffc02024d6:	953e                	add	a0,a0,a5
ffffffffc02024d8:	100027f3          	csrr	a5,sstatus
ffffffffc02024dc:	8b89                	andi	a5,a5,2
ffffffffc02024de:	10079863          	bnez	a5,ffffffffc02025ee <pmm_init+0x6a0>
ffffffffc02024e2:	000bb783          	ld	a5,0(s7)
ffffffffc02024e6:	4585                	li	a1,1
ffffffffc02024e8:	739c                	ld	a5,32(a5)
ffffffffc02024ea:	9782                	jalr	a5
    free_page(p);
    free_page(pde2page(pd0[0]));
    free_page(pde2page(pd1[0]));
    boot_pgdir[0] = 0;
ffffffffc02024ec:	00093783          	ld	a5,0(s2)
ffffffffc02024f0:	0007b023          	sd	zero,0(a5)
  asm volatile("sfence.vma");
ffffffffc02024f4:	12000073          	sfence.vma
ffffffffc02024f8:	100027f3          	csrr	a5,sstatus
ffffffffc02024fc:	8b89                	andi	a5,a5,2
ffffffffc02024fe:	0c079e63          	bnez	a5,ffffffffc02025da <pmm_init+0x68c>
        ret = pmm_manager->nr_free_pages();
ffffffffc0202502:	000bb783          	ld	a5,0(s7)
ffffffffc0202506:	779c                	ld	a5,40(a5)
ffffffffc0202508:	9782                	jalr	a5
ffffffffc020250a:	842a                	mv	s0,a0
    flush_tlb();

    assert(nr_free_store==nr_free_pages());
ffffffffc020250c:	3a8c1a63          	bne	s8,s0,ffffffffc02028c0 <pmm_init+0x972>

    cprintf("check_boot_pgdir() succeeded!\n");
ffffffffc0202510:	00004517          	auipc	a0,0x4
ffffffffc0202514:	97050513          	addi	a0,a0,-1680 # ffffffffc0205e80 <default_pmm_manager+0x668>
ffffffffc0202518:	c69fd0ef          	jal	ra,ffffffffc0200180 <cprintf>
}
ffffffffc020251c:	7406                	ld	s0,96(sp)
ffffffffc020251e:	70a6                	ld	ra,104(sp)
ffffffffc0202520:	64e6                	ld	s1,88(sp)
ffffffffc0202522:	6946                	ld	s2,80(sp)
ffffffffc0202524:	69a6                	ld	s3,72(sp)
ffffffffc0202526:	6a06                	ld	s4,64(sp)
ffffffffc0202528:	7ae2                	ld	s5,56(sp)
ffffffffc020252a:	7b42                	ld	s6,48(sp)
ffffffffc020252c:	7ba2                	ld	s7,40(sp)
ffffffffc020252e:	7c02                	ld	s8,32(sp)
ffffffffc0202530:	6ce2                	ld	s9,24(sp)
ffffffffc0202532:	6d42                	ld	s10,16(sp)
ffffffffc0202534:	6165                	addi	sp,sp,112
    kmalloc_init();
ffffffffc0202536:	b0aff06f          	j	ffffffffc0201840 <kmalloc_init>
    mem_begin = ROUNDUP(freemem, PGSIZE);
ffffffffc020253a:	6705                	lui	a4,0x1
ffffffffc020253c:	177d                	addi	a4,a4,-1
ffffffffc020253e:	96ba                	add	a3,a3,a4
ffffffffc0202540:	777d                	lui	a4,0xfffff
ffffffffc0202542:	8f75                	and	a4,a4,a3
    if (PPN(pa) >= npage) {
ffffffffc0202544:	00c75693          	srli	a3,a4,0xc
ffffffffc0202548:	14f6f363          	bgeu	a3,a5,ffffffffc020268e <pmm_init+0x740>
    pmm_manager->init_memmap(base, n);
ffffffffc020254c:	000bb583          	ld	a1,0(s7)
    return &pages[PPN(pa) - nbase];
ffffffffc0202550:	9836                	add	a6,a6,a3
ffffffffc0202552:	00381793          	slli	a5,a6,0x3
ffffffffc0202556:	6994                	ld	a3,16(a1)
ffffffffc0202558:	97c2                	add	a5,a5,a6
        init_memmap(pa2page(mem_begin), (mem_end - mem_begin) / PGSIZE);
ffffffffc020255a:	40e60733          	sub	a4,a2,a4
ffffffffc020255e:	078e                	slli	a5,a5,0x3
    pmm_manager->init_memmap(base, n);
ffffffffc0202560:	00c75593          	srli	a1,a4,0xc
ffffffffc0202564:	953e                	add	a0,a0,a5
ffffffffc0202566:	9682                	jalr	a3
    cprintf("vapaofset is %llu\n",va_pa_offset);
ffffffffc0202568:	0009b583          	ld	a1,0(s3)
}
ffffffffc020256c:	bcd9                	j	ffffffffc0202042 <pmm_init+0xf4>
        intr_disable();
ffffffffc020256e:	830fe0ef          	jal	ra,ffffffffc020059e <intr_disable>
        ret = pmm_manager->nr_free_pages();
ffffffffc0202572:	000bb783          	ld	a5,0(s7)
ffffffffc0202576:	779c                	ld	a5,40(a5)
ffffffffc0202578:	9782                	jalr	a5
ffffffffc020257a:	842a                	mv	s0,a0
        intr_enable();
ffffffffc020257c:	81cfe0ef          	jal	ra,ffffffffc0200598 <intr_enable>
ffffffffc0202580:	b605                	j	ffffffffc02020a0 <pmm_init+0x152>
        intr_disable();
ffffffffc0202582:	81cfe0ef          	jal	ra,ffffffffc020059e <intr_disable>
ffffffffc0202586:	000bb783          	ld	a5,0(s7)
ffffffffc020258a:	779c                	ld	a5,40(a5)
ffffffffc020258c:	9782                	jalr	a5
ffffffffc020258e:	8c2a                	mv	s8,a0
        intr_enable();
ffffffffc0202590:	808fe0ef          	jal	ra,ffffffffc0200598 <intr_enable>
ffffffffc0202594:	bb5d                	j	ffffffffc020234a <pmm_init+0x3fc>
        intr_disable();
ffffffffc0202596:	808fe0ef          	jal	ra,ffffffffc020059e <intr_disable>
ffffffffc020259a:	000bb783          	ld	a5,0(s7)
ffffffffc020259e:	779c                	ld	a5,40(a5)
ffffffffc02025a0:	9782                	jalr	a5
ffffffffc02025a2:	8a2a                	mv	s4,a0
        intr_enable();
ffffffffc02025a4:	ff5fd0ef          	jal	ra,ffffffffc0200598 <intr_enable>
ffffffffc02025a8:	bbbd                	j	ffffffffc0202326 <pmm_init+0x3d8>
ffffffffc02025aa:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc02025ac:	ff3fd0ef          	jal	ra,ffffffffc020059e <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc02025b0:	000bb783          	ld	a5,0(s7)
ffffffffc02025b4:	6522                	ld	a0,8(sp)
ffffffffc02025b6:	4585                	li	a1,1
ffffffffc02025b8:	739c                	ld	a5,32(a5)
ffffffffc02025ba:	9782                	jalr	a5
        intr_enable();
ffffffffc02025bc:	fddfd0ef          	jal	ra,ffffffffc0200598 <intr_enable>
ffffffffc02025c0:	b399                	j	ffffffffc0202306 <pmm_init+0x3b8>
ffffffffc02025c2:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc02025c4:	fdbfd0ef          	jal	ra,ffffffffc020059e <intr_disable>
ffffffffc02025c8:	000bb783          	ld	a5,0(s7)
ffffffffc02025cc:	6522                	ld	a0,8(sp)
ffffffffc02025ce:	4585                	li	a1,1
ffffffffc02025d0:	739c                	ld	a5,32(a5)
ffffffffc02025d2:	9782                	jalr	a5
        intr_enable();
ffffffffc02025d4:	fc5fd0ef          	jal	ra,ffffffffc0200598 <intr_enable>
ffffffffc02025d8:	b9e5                	j	ffffffffc02022d0 <pmm_init+0x382>
        intr_disable();
ffffffffc02025da:	fc5fd0ef          	jal	ra,ffffffffc020059e <intr_disable>
        ret = pmm_manager->nr_free_pages();
ffffffffc02025de:	000bb783          	ld	a5,0(s7)
ffffffffc02025e2:	779c                	ld	a5,40(a5)
ffffffffc02025e4:	9782                	jalr	a5
ffffffffc02025e6:	842a                	mv	s0,a0
        intr_enable();
ffffffffc02025e8:	fb1fd0ef          	jal	ra,ffffffffc0200598 <intr_enable>
ffffffffc02025ec:	b705                	j	ffffffffc020250c <pmm_init+0x5be>
ffffffffc02025ee:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc02025f0:	faffd0ef          	jal	ra,ffffffffc020059e <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc02025f4:	000bb783          	ld	a5,0(s7)
ffffffffc02025f8:	6522                	ld	a0,8(sp)
ffffffffc02025fa:	4585                	li	a1,1
ffffffffc02025fc:	739c                	ld	a5,32(a5)
ffffffffc02025fe:	9782                	jalr	a5
        intr_enable();
ffffffffc0202600:	f99fd0ef          	jal	ra,ffffffffc0200598 <intr_enable>
ffffffffc0202604:	b5e5                	j	ffffffffc02024ec <pmm_init+0x59e>
ffffffffc0202606:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc0202608:	f97fd0ef          	jal	ra,ffffffffc020059e <intr_disable>
ffffffffc020260c:	000bb783          	ld	a5,0(s7)
ffffffffc0202610:	6522                	ld	a0,8(sp)
ffffffffc0202612:	4585                	li	a1,1
ffffffffc0202614:	739c                	ld	a5,32(a5)
ffffffffc0202616:	9782                	jalr	a5
        intr_enable();
ffffffffc0202618:	f81fd0ef          	jal	ra,ffffffffc0200598 <intr_enable>
ffffffffc020261c:	bd69                	j	ffffffffc02024b6 <pmm_init+0x568>
        intr_disable();
ffffffffc020261e:	f81fd0ef          	jal	ra,ffffffffc020059e <intr_disable>
ffffffffc0202622:	000bb783          	ld	a5,0(s7)
ffffffffc0202626:	4585                	li	a1,1
ffffffffc0202628:	8556                	mv	a0,s5
ffffffffc020262a:	739c                	ld	a5,32(a5)
ffffffffc020262c:	9782                	jalr	a5
        intr_enable();
ffffffffc020262e:	f6bfd0ef          	jal	ra,ffffffffc0200598 <intr_enable>
ffffffffc0202632:	bd81                	j	ffffffffc0202482 <pmm_init+0x534>
        assert(PTE_ADDR(*ptep) == i);
ffffffffc0202634:	00003697          	auipc	a3,0x3
ffffffffc0202638:	6fc68693          	addi	a3,a3,1788 # ffffffffc0205d30 <default_pmm_manager+0x518>
ffffffffc020263c:	00003617          	auipc	a2,0x3
ffffffffc0202640:	e2c60613          	addi	a2,a2,-468 # ffffffffc0205468 <commands+0x738>
ffffffffc0202644:	19e00593          	li	a1,414
ffffffffc0202648:	00003517          	auipc	a0,0x3
ffffffffc020264c:	32050513          	addi	a0,a0,800 # ffffffffc0205968 <default_pmm_manager+0x150>
ffffffffc0202650:	df7fd0ef          	jal	ra,ffffffffc0200446 <__panic>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
ffffffffc0202654:	00003697          	auipc	a3,0x3
ffffffffc0202658:	69c68693          	addi	a3,a3,1692 # ffffffffc0205cf0 <default_pmm_manager+0x4d8>
ffffffffc020265c:	00003617          	auipc	a2,0x3
ffffffffc0202660:	e0c60613          	addi	a2,a2,-500 # ffffffffc0205468 <commands+0x738>
ffffffffc0202664:	19d00593          	li	a1,413
ffffffffc0202668:	00003517          	auipc	a0,0x3
ffffffffc020266c:	30050513          	addi	a0,a0,768 # ffffffffc0205968 <default_pmm_manager+0x150>
ffffffffc0202670:	dd7fd0ef          	jal	ra,ffffffffc0200446 <__panic>
ffffffffc0202674:	86a2                	mv	a3,s0
ffffffffc0202676:	00003617          	auipc	a2,0x3
ffffffffc020267a:	1da60613          	addi	a2,a2,474 # ffffffffc0205850 <default_pmm_manager+0x38>
ffffffffc020267e:	19d00593          	li	a1,413
ffffffffc0202682:	00003517          	auipc	a0,0x3
ffffffffc0202686:	2e650513          	addi	a0,a0,742 # ffffffffc0205968 <default_pmm_manager+0x150>
ffffffffc020268a:	dbdfd0ef          	jal	ra,ffffffffc0200446 <__panic>
ffffffffc020268e:	b7eff0ef          	jal	ra,ffffffffc0201a0c <pa2page.part.0>
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc0202692:	00003617          	auipc	a2,0x3
ffffffffc0202696:	26660613          	addi	a2,a2,614 # ffffffffc02058f8 <default_pmm_manager+0xe0>
ffffffffc020269a:	07f00593          	li	a1,127
ffffffffc020269e:	00003517          	auipc	a0,0x3
ffffffffc02026a2:	2ca50513          	addi	a0,a0,714 # ffffffffc0205968 <default_pmm_manager+0x150>
ffffffffc02026a6:	da1fd0ef          	jal	ra,ffffffffc0200446 <__panic>
    boot_cr3 = PADDR(boot_pgdir);
ffffffffc02026aa:	00003617          	auipc	a2,0x3
ffffffffc02026ae:	24e60613          	addi	a2,a2,590 # ffffffffc02058f8 <default_pmm_manager+0xe0>
ffffffffc02026b2:	0c300593          	li	a1,195
ffffffffc02026b6:	00003517          	auipc	a0,0x3
ffffffffc02026ba:	2b250513          	addi	a0,a0,690 # ffffffffc0205968 <default_pmm_manager+0x150>
ffffffffc02026be:	d89fd0ef          	jal	ra,ffffffffc0200446 <__panic>
    assert(boot_pgdir != NULL && (uint32_t)PGOFF(boot_pgdir) == 0);
ffffffffc02026c2:	00003697          	auipc	a3,0x3
ffffffffc02026c6:	36668693          	addi	a3,a3,870 # ffffffffc0205a28 <default_pmm_manager+0x210>
ffffffffc02026ca:	00003617          	auipc	a2,0x3
ffffffffc02026ce:	d9e60613          	addi	a2,a2,-610 # ffffffffc0205468 <commands+0x738>
ffffffffc02026d2:	16100593          	li	a1,353
ffffffffc02026d6:	00003517          	auipc	a0,0x3
ffffffffc02026da:	29250513          	addi	a0,a0,658 # ffffffffc0205968 <default_pmm_manager+0x150>
ffffffffc02026de:	d69fd0ef          	jal	ra,ffffffffc0200446 <__panic>
    assert(npage <= KERNTOP / PGSIZE);
ffffffffc02026e2:	00003697          	auipc	a3,0x3
ffffffffc02026e6:	32668693          	addi	a3,a3,806 # ffffffffc0205a08 <default_pmm_manager+0x1f0>
ffffffffc02026ea:	00003617          	auipc	a2,0x3
ffffffffc02026ee:	d7e60613          	addi	a2,a2,-642 # ffffffffc0205468 <commands+0x738>
ffffffffc02026f2:	16000593          	li	a1,352
ffffffffc02026f6:	00003517          	auipc	a0,0x3
ffffffffc02026fa:	27250513          	addi	a0,a0,626 # ffffffffc0205968 <default_pmm_manager+0x150>
ffffffffc02026fe:	d49fd0ef          	jal	ra,ffffffffc0200446 <__panic>
ffffffffc0202702:	b26ff0ef          	jal	ra,ffffffffc0201a28 <pte2page.part.0>
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
ffffffffc0202706:	00003697          	auipc	a3,0x3
ffffffffc020270a:	3b268693          	addi	a3,a3,946 # ffffffffc0205ab8 <default_pmm_manager+0x2a0>
ffffffffc020270e:	00003617          	auipc	a2,0x3
ffffffffc0202712:	d5a60613          	addi	a2,a2,-678 # ffffffffc0205468 <commands+0x738>
ffffffffc0202716:	16900593          	li	a1,361
ffffffffc020271a:	00003517          	auipc	a0,0x3
ffffffffc020271e:	24e50513          	addi	a0,a0,590 # ffffffffc0205968 <default_pmm_manager+0x150>
ffffffffc0202722:	d25fd0ef          	jal	ra,ffffffffc0200446 <__panic>
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
ffffffffc0202726:	00003697          	auipc	a3,0x3
ffffffffc020272a:	36268693          	addi	a3,a3,866 # ffffffffc0205a88 <default_pmm_manager+0x270>
ffffffffc020272e:	00003617          	auipc	a2,0x3
ffffffffc0202732:	d3a60613          	addi	a2,a2,-710 # ffffffffc0205468 <commands+0x738>
ffffffffc0202736:	16600593          	li	a1,358
ffffffffc020273a:	00003517          	auipc	a0,0x3
ffffffffc020273e:	22e50513          	addi	a0,a0,558 # ffffffffc0205968 <default_pmm_manager+0x150>
ffffffffc0202742:	d05fd0ef          	jal	ra,ffffffffc0200446 <__panic>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
ffffffffc0202746:	00003697          	auipc	a3,0x3
ffffffffc020274a:	31a68693          	addi	a3,a3,794 # ffffffffc0205a60 <default_pmm_manager+0x248>
ffffffffc020274e:	00003617          	auipc	a2,0x3
ffffffffc0202752:	d1a60613          	addi	a2,a2,-742 # ffffffffc0205468 <commands+0x738>
ffffffffc0202756:	16200593          	li	a1,354
ffffffffc020275a:	00003517          	auipc	a0,0x3
ffffffffc020275e:	20e50513          	addi	a0,a0,526 # ffffffffc0205968 <default_pmm_manager+0x150>
ffffffffc0202762:	ce5fd0ef          	jal	ra,ffffffffc0200446 <__panic>
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
ffffffffc0202766:	00003697          	auipc	a3,0x3
ffffffffc020276a:	3da68693          	addi	a3,a3,986 # ffffffffc0205b40 <default_pmm_manager+0x328>
ffffffffc020276e:	00003617          	auipc	a2,0x3
ffffffffc0202772:	cfa60613          	addi	a2,a2,-774 # ffffffffc0205468 <commands+0x738>
ffffffffc0202776:	17200593          	li	a1,370
ffffffffc020277a:	00003517          	auipc	a0,0x3
ffffffffc020277e:	1ee50513          	addi	a0,a0,494 # ffffffffc0205968 <default_pmm_manager+0x150>
ffffffffc0202782:	cc5fd0ef          	jal	ra,ffffffffc0200446 <__panic>
    assert(page_ref(p2) == 1);
ffffffffc0202786:	00003697          	auipc	a3,0x3
ffffffffc020278a:	45a68693          	addi	a3,a3,1114 # ffffffffc0205be0 <default_pmm_manager+0x3c8>
ffffffffc020278e:	00003617          	auipc	a2,0x3
ffffffffc0202792:	cda60613          	addi	a2,a2,-806 # ffffffffc0205468 <commands+0x738>
ffffffffc0202796:	17700593          	li	a1,375
ffffffffc020279a:	00003517          	auipc	a0,0x3
ffffffffc020279e:	1ce50513          	addi	a0,a0,462 # ffffffffc0205968 <default_pmm_manager+0x150>
ffffffffc02027a2:	ca5fd0ef          	jal	ra,ffffffffc0200446 <__panic>
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
ffffffffc02027a6:	00003697          	auipc	a3,0x3
ffffffffc02027aa:	37268693          	addi	a3,a3,882 # ffffffffc0205b18 <default_pmm_manager+0x300>
ffffffffc02027ae:	00003617          	auipc	a2,0x3
ffffffffc02027b2:	cba60613          	addi	a2,a2,-838 # ffffffffc0205468 <commands+0x738>
ffffffffc02027b6:	16f00593          	li	a1,367
ffffffffc02027ba:	00003517          	auipc	a0,0x3
ffffffffc02027be:	1ae50513          	addi	a0,a0,430 # ffffffffc0205968 <default_pmm_manager+0x150>
ffffffffc02027c2:	c85fd0ef          	jal	ra,ffffffffc0200446 <__panic>
    ptep = (pte_t *)KADDR(PDE_ADDR(ptep[0])) + 1;
ffffffffc02027c6:	86d6                	mv	a3,s5
ffffffffc02027c8:	00003617          	auipc	a2,0x3
ffffffffc02027cc:	08860613          	addi	a2,a2,136 # ffffffffc0205850 <default_pmm_manager+0x38>
ffffffffc02027d0:	16e00593          	li	a1,366
ffffffffc02027d4:	00003517          	auipc	a0,0x3
ffffffffc02027d8:	19450513          	addi	a0,a0,404 # ffffffffc0205968 <default_pmm_manager+0x150>
ffffffffc02027dc:	c6bfd0ef          	jal	ra,ffffffffc0200446 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
ffffffffc02027e0:	00003697          	auipc	a3,0x3
ffffffffc02027e4:	39868693          	addi	a3,a3,920 # ffffffffc0205b78 <default_pmm_manager+0x360>
ffffffffc02027e8:	00003617          	auipc	a2,0x3
ffffffffc02027ec:	c8060613          	addi	a2,a2,-896 # ffffffffc0205468 <commands+0x738>
ffffffffc02027f0:	17c00593          	li	a1,380
ffffffffc02027f4:	00003517          	auipc	a0,0x3
ffffffffc02027f8:	17450513          	addi	a0,a0,372 # ffffffffc0205968 <default_pmm_manager+0x150>
ffffffffc02027fc:	c4bfd0ef          	jal	ra,ffffffffc0200446 <__panic>
    assert(page_ref(p2) == 0);
ffffffffc0202800:	00003697          	auipc	a3,0x3
ffffffffc0202804:	44068693          	addi	a3,a3,1088 # ffffffffc0205c40 <default_pmm_manager+0x428>
ffffffffc0202808:	00003617          	auipc	a2,0x3
ffffffffc020280c:	c6060613          	addi	a2,a2,-928 # ffffffffc0205468 <commands+0x738>
ffffffffc0202810:	17b00593          	li	a1,379
ffffffffc0202814:	00003517          	auipc	a0,0x3
ffffffffc0202818:	15450513          	addi	a0,a0,340 # ffffffffc0205968 <default_pmm_manager+0x150>
ffffffffc020281c:	c2bfd0ef          	jal	ra,ffffffffc0200446 <__panic>
    assert(page_ref(p1) == 2);
ffffffffc0202820:	00003697          	auipc	a3,0x3
ffffffffc0202824:	40868693          	addi	a3,a3,1032 # ffffffffc0205c28 <default_pmm_manager+0x410>
ffffffffc0202828:	00003617          	auipc	a2,0x3
ffffffffc020282c:	c4060613          	addi	a2,a2,-960 # ffffffffc0205468 <commands+0x738>
ffffffffc0202830:	17a00593          	li	a1,378
ffffffffc0202834:	00003517          	auipc	a0,0x3
ffffffffc0202838:	13450513          	addi	a0,a0,308 # ffffffffc0205968 <default_pmm_manager+0x150>
ffffffffc020283c:	c0bfd0ef          	jal	ra,ffffffffc0200446 <__panic>
    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
ffffffffc0202840:	00003697          	auipc	a3,0x3
ffffffffc0202844:	3b868693          	addi	a3,a3,952 # ffffffffc0205bf8 <default_pmm_manager+0x3e0>
ffffffffc0202848:	00003617          	auipc	a2,0x3
ffffffffc020284c:	c2060613          	addi	a2,a2,-992 # ffffffffc0205468 <commands+0x738>
ffffffffc0202850:	17900593          	li	a1,377
ffffffffc0202854:	00003517          	auipc	a0,0x3
ffffffffc0202858:	11450513          	addi	a0,a0,276 # ffffffffc0205968 <default_pmm_manager+0x150>
ffffffffc020285c:	bebfd0ef          	jal	ra,ffffffffc0200446 <__panic>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W | PTE_R) == 0);
ffffffffc0202860:	00003697          	auipc	a3,0x3
ffffffffc0202864:	55068693          	addi	a3,a3,1360 # ffffffffc0205db0 <default_pmm_manager+0x598>
ffffffffc0202868:	00003617          	auipc	a2,0x3
ffffffffc020286c:	c0060613          	addi	a2,a2,-1024 # ffffffffc0205468 <commands+0x738>
ffffffffc0202870:	1a700593          	li	a1,423
ffffffffc0202874:	00003517          	auipc	a0,0x3
ffffffffc0202878:	0f450513          	addi	a0,a0,244 # ffffffffc0205968 <default_pmm_manager+0x150>
ffffffffc020287c:	bcbfd0ef          	jal	ra,ffffffffc0200446 <__panic>
    assert(boot_pgdir[0] & PTE_U);
ffffffffc0202880:	00003697          	auipc	a3,0x3
ffffffffc0202884:	34868693          	addi	a3,a3,840 # ffffffffc0205bc8 <default_pmm_manager+0x3b0>
ffffffffc0202888:	00003617          	auipc	a2,0x3
ffffffffc020288c:	be060613          	addi	a2,a2,-1056 # ffffffffc0205468 <commands+0x738>
ffffffffc0202890:	17600593          	li	a1,374
ffffffffc0202894:	00003517          	auipc	a0,0x3
ffffffffc0202898:	0d450513          	addi	a0,a0,212 # ffffffffc0205968 <default_pmm_manager+0x150>
ffffffffc020289c:	babfd0ef          	jal	ra,ffffffffc0200446 <__panic>
    assert(*ptep & PTE_W);
ffffffffc02028a0:	00003697          	auipc	a3,0x3
ffffffffc02028a4:	31868693          	addi	a3,a3,792 # ffffffffc0205bb8 <default_pmm_manager+0x3a0>
ffffffffc02028a8:	00003617          	auipc	a2,0x3
ffffffffc02028ac:	bc060613          	addi	a2,a2,-1088 # ffffffffc0205468 <commands+0x738>
ffffffffc02028b0:	17500593          	li	a1,373
ffffffffc02028b4:	00003517          	auipc	a0,0x3
ffffffffc02028b8:	0b450513          	addi	a0,a0,180 # ffffffffc0205968 <default_pmm_manager+0x150>
ffffffffc02028bc:	b8bfd0ef          	jal	ra,ffffffffc0200446 <__panic>
    assert(nr_free_store==nr_free_pages());
ffffffffc02028c0:	00003697          	auipc	a3,0x3
ffffffffc02028c4:	3f068693          	addi	a3,a3,1008 # ffffffffc0205cb0 <default_pmm_manager+0x498>
ffffffffc02028c8:	00003617          	auipc	a2,0x3
ffffffffc02028cc:	ba060613          	addi	a2,a2,-1120 # ffffffffc0205468 <commands+0x738>
ffffffffc02028d0:	1b800593          	li	a1,440
ffffffffc02028d4:	00003517          	auipc	a0,0x3
ffffffffc02028d8:	09450513          	addi	a0,a0,148 # ffffffffc0205968 <default_pmm_manager+0x150>
ffffffffc02028dc:	b6bfd0ef          	jal	ra,ffffffffc0200446 <__panic>
    assert(*ptep & PTE_U);
ffffffffc02028e0:	00003697          	auipc	a3,0x3
ffffffffc02028e4:	2c868693          	addi	a3,a3,712 # ffffffffc0205ba8 <default_pmm_manager+0x390>
ffffffffc02028e8:	00003617          	auipc	a2,0x3
ffffffffc02028ec:	b8060613          	addi	a2,a2,-1152 # ffffffffc0205468 <commands+0x738>
ffffffffc02028f0:	17400593          	li	a1,372
ffffffffc02028f4:	00003517          	auipc	a0,0x3
ffffffffc02028f8:	07450513          	addi	a0,a0,116 # ffffffffc0205968 <default_pmm_manager+0x150>
ffffffffc02028fc:	b4bfd0ef          	jal	ra,ffffffffc0200446 <__panic>
    assert(page_ref(p1) == 1);
ffffffffc0202900:	00003697          	auipc	a3,0x3
ffffffffc0202904:	20068693          	addi	a3,a3,512 # ffffffffc0205b00 <default_pmm_manager+0x2e8>
ffffffffc0202908:	00003617          	auipc	a2,0x3
ffffffffc020290c:	b6060613          	addi	a2,a2,-1184 # ffffffffc0205468 <commands+0x738>
ffffffffc0202910:	18100593          	li	a1,385
ffffffffc0202914:	00003517          	auipc	a0,0x3
ffffffffc0202918:	05450513          	addi	a0,a0,84 # ffffffffc0205968 <default_pmm_manager+0x150>
ffffffffc020291c:	b2bfd0ef          	jal	ra,ffffffffc0200446 <__panic>
    assert((*ptep & PTE_U) == 0);
ffffffffc0202920:	00003697          	auipc	a3,0x3
ffffffffc0202924:	33868693          	addi	a3,a3,824 # ffffffffc0205c58 <default_pmm_manager+0x440>
ffffffffc0202928:	00003617          	auipc	a2,0x3
ffffffffc020292c:	b4060613          	addi	a2,a2,-1216 # ffffffffc0205468 <commands+0x738>
ffffffffc0202930:	17e00593          	li	a1,382
ffffffffc0202934:	00003517          	auipc	a0,0x3
ffffffffc0202938:	03450513          	addi	a0,a0,52 # ffffffffc0205968 <default_pmm_manager+0x150>
ffffffffc020293c:	b0bfd0ef          	jal	ra,ffffffffc0200446 <__panic>
    assert(pte2page(*ptep) == p1);
ffffffffc0202940:	00003697          	auipc	a3,0x3
ffffffffc0202944:	1a868693          	addi	a3,a3,424 # ffffffffc0205ae8 <default_pmm_manager+0x2d0>
ffffffffc0202948:	00003617          	auipc	a2,0x3
ffffffffc020294c:	b2060613          	addi	a2,a2,-1248 # ffffffffc0205468 <commands+0x738>
ffffffffc0202950:	17d00593          	li	a1,381
ffffffffc0202954:	00003517          	auipc	a0,0x3
ffffffffc0202958:	01450513          	addi	a0,a0,20 # ffffffffc0205968 <default_pmm_manager+0x150>
ffffffffc020295c:	aebfd0ef          	jal	ra,ffffffffc0200446 <__panic>
    return KADDR(page2pa(page));
ffffffffc0202960:	00003617          	auipc	a2,0x3
ffffffffc0202964:	ef060613          	addi	a2,a2,-272 # ffffffffc0205850 <default_pmm_manager+0x38>
ffffffffc0202968:	06900593          	li	a1,105
ffffffffc020296c:	00003517          	auipc	a0,0x3
ffffffffc0202970:	f0c50513          	addi	a0,a0,-244 # ffffffffc0205878 <default_pmm_manager+0x60>
ffffffffc0202974:	ad3fd0ef          	jal	ra,ffffffffc0200446 <__panic>
    assert(page_ref(pde2page(boot_pgdir[0])) == 1);
ffffffffc0202978:	00003697          	auipc	a3,0x3
ffffffffc020297c:	31068693          	addi	a3,a3,784 # ffffffffc0205c88 <default_pmm_manager+0x470>
ffffffffc0202980:	00003617          	auipc	a2,0x3
ffffffffc0202984:	ae860613          	addi	a2,a2,-1304 # ffffffffc0205468 <commands+0x738>
ffffffffc0202988:	18800593          	li	a1,392
ffffffffc020298c:	00003517          	auipc	a0,0x3
ffffffffc0202990:	fdc50513          	addi	a0,a0,-36 # ffffffffc0205968 <default_pmm_manager+0x150>
ffffffffc0202994:	ab3fd0ef          	jal	ra,ffffffffc0200446 <__panic>
    assert(page_ref(p2) == 0);
ffffffffc0202998:	00003697          	auipc	a3,0x3
ffffffffc020299c:	2a868693          	addi	a3,a3,680 # ffffffffc0205c40 <default_pmm_manager+0x428>
ffffffffc02029a0:	00003617          	auipc	a2,0x3
ffffffffc02029a4:	ac860613          	addi	a2,a2,-1336 # ffffffffc0205468 <commands+0x738>
ffffffffc02029a8:	18600593          	li	a1,390
ffffffffc02029ac:	00003517          	auipc	a0,0x3
ffffffffc02029b0:	fbc50513          	addi	a0,a0,-68 # ffffffffc0205968 <default_pmm_manager+0x150>
ffffffffc02029b4:	a93fd0ef          	jal	ra,ffffffffc0200446 <__panic>
    assert(page_ref(p1) == 0);
ffffffffc02029b8:	00003697          	auipc	a3,0x3
ffffffffc02029bc:	2b868693          	addi	a3,a3,696 # ffffffffc0205c70 <default_pmm_manager+0x458>
ffffffffc02029c0:	00003617          	auipc	a2,0x3
ffffffffc02029c4:	aa860613          	addi	a2,a2,-1368 # ffffffffc0205468 <commands+0x738>
ffffffffc02029c8:	18500593          	li	a1,389
ffffffffc02029cc:	00003517          	auipc	a0,0x3
ffffffffc02029d0:	f9c50513          	addi	a0,a0,-100 # ffffffffc0205968 <default_pmm_manager+0x150>
ffffffffc02029d4:	a73fd0ef          	jal	ra,ffffffffc0200446 <__panic>
    assert(page_ref(p2) == 0);
ffffffffc02029d8:	00003697          	auipc	a3,0x3
ffffffffc02029dc:	26868693          	addi	a3,a3,616 # ffffffffc0205c40 <default_pmm_manager+0x428>
ffffffffc02029e0:	00003617          	auipc	a2,0x3
ffffffffc02029e4:	a8860613          	addi	a2,a2,-1400 # ffffffffc0205468 <commands+0x738>
ffffffffc02029e8:	18200593          	li	a1,386
ffffffffc02029ec:	00003517          	auipc	a0,0x3
ffffffffc02029f0:	f7c50513          	addi	a0,a0,-132 # ffffffffc0205968 <default_pmm_manager+0x150>
ffffffffc02029f4:	a53fd0ef          	jal	ra,ffffffffc0200446 <__panic>
    assert(page_ref(p) == 1);
ffffffffc02029f8:	00003697          	auipc	a3,0x3
ffffffffc02029fc:	3a068693          	addi	a3,a3,928 # ffffffffc0205d98 <default_pmm_manager+0x580>
ffffffffc0202a00:	00003617          	auipc	a2,0x3
ffffffffc0202a04:	a6860613          	addi	a2,a2,-1432 # ffffffffc0205468 <commands+0x738>
ffffffffc0202a08:	1a600593          	li	a1,422
ffffffffc0202a0c:	00003517          	auipc	a0,0x3
ffffffffc0202a10:	f5c50513          	addi	a0,a0,-164 # ffffffffc0205968 <default_pmm_manager+0x150>
ffffffffc0202a14:	a33fd0ef          	jal	ra,ffffffffc0200446 <__panic>
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W | PTE_R) == 0);
ffffffffc0202a18:	00003697          	auipc	a3,0x3
ffffffffc0202a1c:	34868693          	addi	a3,a3,840 # ffffffffc0205d60 <default_pmm_manager+0x548>
ffffffffc0202a20:	00003617          	auipc	a2,0x3
ffffffffc0202a24:	a4860613          	addi	a2,a2,-1464 # ffffffffc0205468 <commands+0x738>
ffffffffc0202a28:	1a500593          	li	a1,421
ffffffffc0202a2c:	00003517          	auipc	a0,0x3
ffffffffc0202a30:	f3c50513          	addi	a0,a0,-196 # ffffffffc0205968 <default_pmm_manager+0x150>
ffffffffc0202a34:	a13fd0ef          	jal	ra,ffffffffc0200446 <__panic>
    assert(boot_pgdir[0] == 0);
ffffffffc0202a38:	00003697          	auipc	a3,0x3
ffffffffc0202a3c:	31068693          	addi	a3,a3,784 # ffffffffc0205d48 <default_pmm_manager+0x530>
ffffffffc0202a40:	00003617          	auipc	a2,0x3
ffffffffc0202a44:	a2860613          	addi	a2,a2,-1496 # ffffffffc0205468 <commands+0x738>
ffffffffc0202a48:	1a100593          	li	a1,417
ffffffffc0202a4c:	00003517          	auipc	a0,0x3
ffffffffc0202a50:	f1c50513          	addi	a0,a0,-228 # ffffffffc0205968 <default_pmm_manager+0x150>
ffffffffc0202a54:	9f3fd0ef          	jal	ra,ffffffffc0200446 <__panic>
    assert(nr_free_store==nr_free_pages());
ffffffffc0202a58:	00003697          	auipc	a3,0x3
ffffffffc0202a5c:	25868693          	addi	a3,a3,600 # ffffffffc0205cb0 <default_pmm_manager+0x498>
ffffffffc0202a60:	00003617          	auipc	a2,0x3
ffffffffc0202a64:	a0860613          	addi	a2,a2,-1528 # ffffffffc0205468 <commands+0x738>
ffffffffc0202a68:	19000593          	li	a1,400
ffffffffc0202a6c:	00003517          	auipc	a0,0x3
ffffffffc0202a70:	efc50513          	addi	a0,a0,-260 # ffffffffc0205968 <default_pmm_manager+0x150>
ffffffffc0202a74:	9d3fd0ef          	jal	ra,ffffffffc0200446 <__panic>
    assert(pte2page(*ptep) == p1);
ffffffffc0202a78:	00003697          	auipc	a3,0x3
ffffffffc0202a7c:	07068693          	addi	a3,a3,112 # ffffffffc0205ae8 <default_pmm_manager+0x2d0>
ffffffffc0202a80:	00003617          	auipc	a2,0x3
ffffffffc0202a84:	9e860613          	addi	a2,a2,-1560 # ffffffffc0205468 <commands+0x738>
ffffffffc0202a88:	16a00593          	li	a1,362
ffffffffc0202a8c:	00003517          	auipc	a0,0x3
ffffffffc0202a90:	edc50513          	addi	a0,a0,-292 # ffffffffc0205968 <default_pmm_manager+0x150>
ffffffffc0202a94:	9b3fd0ef          	jal	ra,ffffffffc0200446 <__panic>
    ptep = (pte_t *)KADDR(PDE_ADDR(boot_pgdir[0]));
ffffffffc0202a98:	00003617          	auipc	a2,0x3
ffffffffc0202a9c:	db860613          	addi	a2,a2,-584 # ffffffffc0205850 <default_pmm_manager+0x38>
ffffffffc0202aa0:	16d00593          	li	a1,365
ffffffffc0202aa4:	00003517          	auipc	a0,0x3
ffffffffc0202aa8:	ec450513          	addi	a0,a0,-316 # ffffffffc0205968 <default_pmm_manager+0x150>
ffffffffc0202aac:	99bfd0ef          	jal	ra,ffffffffc0200446 <__panic>
    assert(page_ref(p1) == 1);
ffffffffc0202ab0:	00003697          	auipc	a3,0x3
ffffffffc0202ab4:	05068693          	addi	a3,a3,80 # ffffffffc0205b00 <default_pmm_manager+0x2e8>
ffffffffc0202ab8:	00003617          	auipc	a2,0x3
ffffffffc0202abc:	9b060613          	addi	a2,a2,-1616 # ffffffffc0205468 <commands+0x738>
ffffffffc0202ac0:	16b00593          	li	a1,363
ffffffffc0202ac4:	00003517          	auipc	a0,0x3
ffffffffc0202ac8:	ea450513          	addi	a0,a0,-348 # ffffffffc0205968 <default_pmm_manager+0x150>
ffffffffc0202acc:	97bfd0ef          	jal	ra,ffffffffc0200446 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
ffffffffc0202ad0:	00003697          	auipc	a3,0x3
ffffffffc0202ad4:	0a868693          	addi	a3,a3,168 # ffffffffc0205b78 <default_pmm_manager+0x360>
ffffffffc0202ad8:	00003617          	auipc	a2,0x3
ffffffffc0202adc:	99060613          	addi	a2,a2,-1648 # ffffffffc0205468 <commands+0x738>
ffffffffc0202ae0:	17300593          	li	a1,371
ffffffffc0202ae4:	00003517          	auipc	a0,0x3
ffffffffc0202ae8:	e8450513          	addi	a0,a0,-380 # ffffffffc0205968 <default_pmm_manager+0x150>
ffffffffc0202aec:	95bfd0ef          	jal	ra,ffffffffc0200446 <__panic>
    assert(strlen((const char *)0x100) == 0);
ffffffffc0202af0:	00003697          	auipc	a3,0x3
ffffffffc0202af4:	36868693          	addi	a3,a3,872 # ffffffffc0205e58 <default_pmm_manager+0x640>
ffffffffc0202af8:	00003617          	auipc	a2,0x3
ffffffffc0202afc:	97060613          	addi	a2,a2,-1680 # ffffffffc0205468 <commands+0x738>
ffffffffc0202b00:	1af00593          	li	a1,431
ffffffffc0202b04:	00003517          	auipc	a0,0x3
ffffffffc0202b08:	e6450513          	addi	a0,a0,-412 # ffffffffc0205968 <default_pmm_manager+0x150>
ffffffffc0202b0c:	93bfd0ef          	jal	ra,ffffffffc0200446 <__panic>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
ffffffffc0202b10:	00003697          	auipc	a3,0x3
ffffffffc0202b14:	31068693          	addi	a3,a3,784 # ffffffffc0205e20 <default_pmm_manager+0x608>
ffffffffc0202b18:	00003617          	auipc	a2,0x3
ffffffffc0202b1c:	95060613          	addi	a2,a2,-1712 # ffffffffc0205468 <commands+0x738>
ffffffffc0202b20:	1ac00593          	li	a1,428
ffffffffc0202b24:	00003517          	auipc	a0,0x3
ffffffffc0202b28:	e4450513          	addi	a0,a0,-444 # ffffffffc0205968 <default_pmm_manager+0x150>
ffffffffc0202b2c:	91bfd0ef          	jal	ra,ffffffffc0200446 <__panic>
    assert(page_ref(p) == 2);
ffffffffc0202b30:	00003697          	auipc	a3,0x3
ffffffffc0202b34:	2c068693          	addi	a3,a3,704 # ffffffffc0205df0 <default_pmm_manager+0x5d8>
ffffffffc0202b38:	00003617          	auipc	a2,0x3
ffffffffc0202b3c:	93060613          	addi	a2,a2,-1744 # ffffffffc0205468 <commands+0x738>
ffffffffc0202b40:	1a800593          	li	a1,424
ffffffffc0202b44:	00003517          	auipc	a0,0x3
ffffffffc0202b48:	e2450513          	addi	a0,a0,-476 # ffffffffc0205968 <default_pmm_manager+0x150>
ffffffffc0202b4c:	8fbfd0ef          	jal	ra,ffffffffc0200446 <__panic>

ffffffffc0202b50 <tlb_invalidate>:
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc0202b50:	12058073          	sfence.vma	a1
}
ffffffffc0202b54:	8082                	ret

ffffffffc0202b56 <pgdir_alloc_page>:
struct Page *pgdir_alloc_page(pde_t *pgdir, uintptr_t la, uint32_t perm) {
ffffffffc0202b56:	7179                	addi	sp,sp,-48
ffffffffc0202b58:	e84a                	sd	s2,16(sp)
ffffffffc0202b5a:	892a                	mv	s2,a0
    struct Page *page = alloc_page();
ffffffffc0202b5c:	4505                	li	a0,1
struct Page *pgdir_alloc_page(pde_t *pgdir, uintptr_t la, uint32_t perm) {
ffffffffc0202b5e:	f022                	sd	s0,32(sp)
ffffffffc0202b60:	ec26                	sd	s1,24(sp)
ffffffffc0202b62:	e44e                	sd	s3,8(sp)
ffffffffc0202b64:	f406                	sd	ra,40(sp)
ffffffffc0202b66:	84ae                	mv	s1,a1
ffffffffc0202b68:	89b2                	mv	s3,a2
    struct Page *page = alloc_page();
ffffffffc0202b6a:	edbfe0ef          	jal	ra,ffffffffc0201a44 <alloc_pages>
ffffffffc0202b6e:	842a                	mv	s0,a0
    if (page != NULL) {
ffffffffc0202b70:	cd09                	beqz	a0,ffffffffc0202b8a <pgdir_alloc_page+0x34>
        if (page_insert(pgdir, page, la, perm) != 0) {
ffffffffc0202b72:	85aa                	mv	a1,a0
ffffffffc0202b74:	86ce                	mv	a3,s3
ffffffffc0202b76:	8626                	mv	a2,s1
ffffffffc0202b78:	854a                	mv	a0,s2
ffffffffc0202b7a:	ac8ff0ef          	jal	ra,ffffffffc0201e42 <page_insert>
ffffffffc0202b7e:	ed21                	bnez	a0,ffffffffc0202bd6 <pgdir_alloc_page+0x80>
        if (swap_init_ok) {
ffffffffc0202b80:	00013797          	auipc	a5,0x13
ffffffffc0202b84:	a107a783          	lw	a5,-1520(a5) # ffffffffc0215590 <swap_init_ok>
ffffffffc0202b88:	eb89                	bnez	a5,ffffffffc0202b9a <pgdir_alloc_page+0x44>
}
ffffffffc0202b8a:	70a2                	ld	ra,40(sp)
ffffffffc0202b8c:	8522                	mv	a0,s0
ffffffffc0202b8e:	7402                	ld	s0,32(sp)
ffffffffc0202b90:	64e2                	ld	s1,24(sp)
ffffffffc0202b92:	6942                	ld	s2,16(sp)
ffffffffc0202b94:	69a2                	ld	s3,8(sp)
ffffffffc0202b96:	6145                	addi	sp,sp,48
ffffffffc0202b98:	8082                	ret
            swap_map_swappable(check_mm_struct, la, page, 0);
ffffffffc0202b9a:	4681                	li	a3,0
ffffffffc0202b9c:	8622                	mv	a2,s0
ffffffffc0202b9e:	85a6                	mv	a1,s1
ffffffffc0202ba0:	00013517          	auipc	a0,0x13
ffffffffc0202ba4:	9f853503          	ld	a0,-1544(a0) # ffffffffc0215598 <check_mm_struct>
ffffffffc0202ba8:	7ee000ef          	jal	ra,ffffffffc0203396 <swap_map_swappable>
            assert(page_ref(page) == 1);
ffffffffc0202bac:	4018                	lw	a4,0(s0)
            page->pra_vaddr = la;
ffffffffc0202bae:	e024                	sd	s1,64(s0)
            assert(page_ref(page) == 1);
ffffffffc0202bb0:	4785                	li	a5,1
ffffffffc0202bb2:	fcf70ce3          	beq	a4,a5,ffffffffc0202b8a <pgdir_alloc_page+0x34>
ffffffffc0202bb6:	00003697          	auipc	a3,0x3
ffffffffc0202bba:	2ea68693          	addi	a3,a3,746 # ffffffffc0205ea0 <default_pmm_manager+0x688>
ffffffffc0202bbe:	00003617          	auipc	a2,0x3
ffffffffc0202bc2:	8aa60613          	addi	a2,a2,-1878 # ffffffffc0205468 <commands+0x738>
ffffffffc0202bc6:	14800593          	li	a1,328
ffffffffc0202bca:	00003517          	auipc	a0,0x3
ffffffffc0202bce:	d9e50513          	addi	a0,a0,-610 # ffffffffc0205968 <default_pmm_manager+0x150>
ffffffffc0202bd2:	875fd0ef          	jal	ra,ffffffffc0200446 <__panic>
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0202bd6:	100027f3          	csrr	a5,sstatus
ffffffffc0202bda:	8b89                	andi	a5,a5,2
ffffffffc0202bdc:	eb99                	bnez	a5,ffffffffc0202bf2 <pgdir_alloc_page+0x9c>
        pmm_manager->free_pages(base, n);
ffffffffc0202bde:	00013797          	auipc	a5,0x13
ffffffffc0202be2:	9927b783          	ld	a5,-1646(a5) # ffffffffc0215570 <pmm_manager>
ffffffffc0202be6:	739c                	ld	a5,32(a5)
ffffffffc0202be8:	8522                	mv	a0,s0
ffffffffc0202bea:	4585                	li	a1,1
ffffffffc0202bec:	9782                	jalr	a5
            return NULL;
ffffffffc0202bee:	4401                	li	s0,0
ffffffffc0202bf0:	bf69                	j	ffffffffc0202b8a <pgdir_alloc_page+0x34>
        intr_disable();
ffffffffc0202bf2:	9adfd0ef          	jal	ra,ffffffffc020059e <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc0202bf6:	00013797          	auipc	a5,0x13
ffffffffc0202bfa:	97a7b783          	ld	a5,-1670(a5) # ffffffffc0215570 <pmm_manager>
ffffffffc0202bfe:	739c                	ld	a5,32(a5)
ffffffffc0202c00:	8522                	mv	a0,s0
ffffffffc0202c02:	4585                	li	a1,1
ffffffffc0202c04:	9782                	jalr	a5
            return NULL;
ffffffffc0202c06:	4401                	li	s0,0
        intr_enable();
ffffffffc0202c08:	991fd0ef          	jal	ra,ffffffffc0200598 <intr_enable>
ffffffffc0202c0c:	bfbd                	j	ffffffffc0202b8a <pgdir_alloc_page+0x34>

ffffffffc0202c0e <pa2page.part.0>:
pa2page(uintptr_t pa) {
ffffffffc0202c0e:	1141                	addi	sp,sp,-16
        panic("pa2page called with invalid pa");
ffffffffc0202c10:	00003617          	auipc	a2,0x3
ffffffffc0202c14:	d1060613          	addi	a2,a2,-752 # ffffffffc0205920 <default_pmm_manager+0x108>
ffffffffc0202c18:	06200593          	li	a1,98
ffffffffc0202c1c:	00003517          	auipc	a0,0x3
ffffffffc0202c20:	c5c50513          	addi	a0,a0,-932 # ffffffffc0205878 <default_pmm_manager+0x60>
pa2page(uintptr_t pa) {
ffffffffc0202c24:	e406                	sd	ra,8(sp)
        panic("pa2page called with invalid pa");
ffffffffc0202c26:	821fd0ef          	jal	ra,ffffffffc0200446 <__panic>

ffffffffc0202c2a <swap_init>:

static void check_swap(void);

int
swap_init(void)
{
ffffffffc0202c2a:	7135                	addi	sp,sp,-160
ffffffffc0202c2c:	ed06                	sd	ra,152(sp)
ffffffffc0202c2e:	e922                	sd	s0,144(sp)
ffffffffc0202c30:	e526                	sd	s1,136(sp)
ffffffffc0202c32:	e14a                	sd	s2,128(sp)
ffffffffc0202c34:	fcce                	sd	s3,120(sp)
ffffffffc0202c36:	f8d2                	sd	s4,112(sp)
ffffffffc0202c38:	f4d6                	sd	s5,104(sp)
ffffffffc0202c3a:	f0da                	sd	s6,96(sp)
ffffffffc0202c3c:	ecde                	sd	s7,88(sp)
ffffffffc0202c3e:	e8e2                	sd	s8,80(sp)
ffffffffc0202c40:	e4e6                	sd	s9,72(sp)
ffffffffc0202c42:	e0ea                	sd	s10,64(sp)
ffffffffc0202c44:	fc6e                	sd	s11,56(sp)
     swapfs_init();
ffffffffc0202c46:	4e4010ef          	jal	ra,ffffffffc020412a <swapfs_init>
     // if (!(1024 <= max_swap_offset && max_swap_offset < MAX_SWAP_OFFSET_LIMIT))
     // {
     //      panic("bad max_swap_offset %08x.\n", max_swap_offset);
     // }
     // Since the IDE is faked, it can only store 7 pages at most to pass the test
     if (!(7 <= max_swap_offset &&
ffffffffc0202c4a:	00013697          	auipc	a3,0x13
ffffffffc0202c4e:	9366b683          	ld	a3,-1738(a3) # ffffffffc0215580 <max_swap_offset>
ffffffffc0202c52:	010007b7          	lui	a5,0x1000
ffffffffc0202c56:	ff968713          	addi	a4,a3,-7
ffffffffc0202c5a:	17e1                	addi	a5,a5,-8
ffffffffc0202c5c:	44e7e363          	bltu	a5,a4,ffffffffc02030a2 <swap_init+0x478>
        max_swap_offset < MAX_SWAP_OFFSET_LIMIT)) {
        panic("bad max_swap_offset %08x.\n", max_swap_offset);
     }

     sm = &swap_manager_fifo;
ffffffffc0202c60:	00007797          	auipc	a5,0x7
ffffffffc0202c64:	3b078793          	addi	a5,a5,944 # ffffffffc020a010 <swap_manager_fifo>
     int r = sm->init();
ffffffffc0202c68:	6798                	ld	a4,8(a5)
     sm = &swap_manager_fifo;
ffffffffc0202c6a:	00013b97          	auipc	s7,0x13
ffffffffc0202c6e:	91eb8b93          	addi	s7,s7,-1762 # ffffffffc0215588 <sm>
ffffffffc0202c72:	00fbb023          	sd	a5,0(s7)
     int r = sm->init();
ffffffffc0202c76:	9702                	jalr	a4
ffffffffc0202c78:	892a                	mv	s2,a0
     
     if (r == 0)
ffffffffc0202c7a:	c10d                	beqz	a0,ffffffffc0202c9c <swap_init+0x72>
          cprintf("SWAP: manager = %s\n", sm->name);
          check_swap();
     }

     return r;
}
ffffffffc0202c7c:	60ea                	ld	ra,152(sp)
ffffffffc0202c7e:	644a                	ld	s0,144(sp)
ffffffffc0202c80:	64aa                	ld	s1,136(sp)
ffffffffc0202c82:	79e6                	ld	s3,120(sp)
ffffffffc0202c84:	7a46                	ld	s4,112(sp)
ffffffffc0202c86:	7aa6                	ld	s5,104(sp)
ffffffffc0202c88:	7b06                	ld	s6,96(sp)
ffffffffc0202c8a:	6be6                	ld	s7,88(sp)
ffffffffc0202c8c:	6c46                	ld	s8,80(sp)
ffffffffc0202c8e:	6ca6                	ld	s9,72(sp)
ffffffffc0202c90:	6d06                	ld	s10,64(sp)
ffffffffc0202c92:	7de2                	ld	s11,56(sp)
ffffffffc0202c94:	854a                	mv	a0,s2
ffffffffc0202c96:	690a                	ld	s2,128(sp)
ffffffffc0202c98:	610d                	addi	sp,sp,160
ffffffffc0202c9a:	8082                	ret
          cprintf("SWAP: manager = %s\n", sm->name);
ffffffffc0202c9c:	000bb783          	ld	a5,0(s7)
ffffffffc0202ca0:	00003517          	auipc	a0,0x3
ffffffffc0202ca4:	24850513          	addi	a0,a0,584 # ffffffffc0205ee8 <default_pmm_manager+0x6d0>
    return listelm->next;
ffffffffc0202ca8:	0000e417          	auipc	s0,0xe
ffffffffc0202cac:	7b040413          	addi	s0,s0,1968 # ffffffffc0211458 <free_area>
ffffffffc0202cb0:	638c                	ld	a1,0(a5)
          swap_init_ok = 1;
ffffffffc0202cb2:	4785                	li	a5,1
ffffffffc0202cb4:	00013717          	auipc	a4,0x13
ffffffffc0202cb8:	8cf72e23          	sw	a5,-1828(a4) # ffffffffc0215590 <swap_init_ok>
          cprintf("SWAP: manager = %s\n", sm->name);
ffffffffc0202cbc:	cc4fd0ef          	jal	ra,ffffffffc0200180 <cprintf>
ffffffffc0202cc0:	641c                	ld	a5,8(s0)

static void
check_swap(void)
{
    //backup mem env
     int ret, count = 0, total = 0, i;
ffffffffc0202cc2:	4d01                	li	s10,0
ffffffffc0202cc4:	4d81                	li	s11,0
     list_entry_t *le = &free_list;
     while ((le = list_next(le)) != &free_list) {
ffffffffc0202cc6:	34878e63          	beq	a5,s0,ffffffffc0203022 <swap_init+0x3f8>
    return (((*(volatile unsigned long *)addr) >> nr) & 1);
ffffffffc0202cca:	fe87b703          	ld	a4,-24(a5)
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
ffffffffc0202cce:	8b09                	andi	a4,a4,2
ffffffffc0202cd0:	34070b63          	beqz	a4,ffffffffc0203026 <swap_init+0x3fc>
        count ++, total += p->property;
ffffffffc0202cd4:	ff87a703          	lw	a4,-8(a5)
ffffffffc0202cd8:	679c                	ld	a5,8(a5)
ffffffffc0202cda:	2d85                	addiw	s11,s11,1
ffffffffc0202cdc:	01a70d3b          	addw	s10,a4,s10
     while ((le = list_next(le)) != &free_list) {
ffffffffc0202ce0:	fe8795e3          	bne	a5,s0,ffffffffc0202cca <swap_init+0xa0>
     }
     assert(total == nr_free_pages());
ffffffffc0202ce4:	84ea                	mv	s1,s10
ffffffffc0202ce6:	e31fe0ef          	jal	ra,ffffffffc0201b16 <nr_free_pages>
ffffffffc0202cea:	44951463          	bne	a0,s1,ffffffffc0203132 <swap_init+0x508>
     cprintf("BEGIN check_swap: count %d, total %d\n",count,total);
ffffffffc0202cee:	866a                	mv	a2,s10
ffffffffc0202cf0:	85ee                	mv	a1,s11
ffffffffc0202cf2:	00003517          	auipc	a0,0x3
ffffffffc0202cf6:	20e50513          	addi	a0,a0,526 # ffffffffc0205f00 <default_pmm_manager+0x6e8>
ffffffffc0202cfa:	c86fd0ef          	jal	ra,ffffffffc0200180 <cprintf>
     
     //now we set the phy pages env     
     struct mm_struct *mm = mm_create();
ffffffffc0202cfe:	3cb000ef          	jal	ra,ffffffffc02038c8 <mm_create>
ffffffffc0202d02:	8aaa                	mv	s5,a0
     assert(mm != NULL);
ffffffffc0202d04:	48050763          	beqz	a0,ffffffffc0203192 <swap_init+0x568>

     extern struct mm_struct *check_mm_struct;
     assert(check_mm_struct == NULL);
ffffffffc0202d08:	00013797          	auipc	a5,0x13
ffffffffc0202d0c:	89078793          	addi	a5,a5,-1904 # ffffffffc0215598 <check_mm_struct>
ffffffffc0202d10:	6398                	ld	a4,0(a5)
ffffffffc0202d12:	40071063          	bnez	a4,ffffffffc0203112 <swap_init+0x4e8>

     check_mm_struct = mm;

     pde_t *pgdir = mm->pgdir = boot_pgdir;
ffffffffc0202d16:	00013717          	auipc	a4,0x13
ffffffffc0202d1a:	84270713          	addi	a4,a4,-1982 # ffffffffc0215558 <boot_pgdir>
ffffffffc0202d1e:	00073b03          	ld	s6,0(a4)
     check_mm_struct = mm;
ffffffffc0202d22:	e388                	sd	a0,0(a5)
     assert(pgdir[0] == 0);
ffffffffc0202d24:	000b3783          	ld	a5,0(s6)
     pde_t *pgdir = mm->pgdir = boot_pgdir;
ffffffffc0202d28:	01653c23          	sd	s6,24(a0)
     assert(pgdir[0] == 0);
ffffffffc0202d2c:	44079363          	bnez	a5,ffffffffc0203172 <swap_init+0x548>

     struct vma_struct *vma = vma_create(BEING_CHECK_VALID_VADDR, CHECK_VALID_VADDR, VM_WRITE | VM_READ);
ffffffffc0202d30:	6599                	lui	a1,0x6
ffffffffc0202d32:	460d                	li	a2,3
ffffffffc0202d34:	6505                	lui	a0,0x1
ffffffffc0202d36:	3db000ef          	jal	ra,ffffffffc0203910 <vma_create>
ffffffffc0202d3a:	85aa                	mv	a1,a0
     assert(vma != NULL);
ffffffffc0202d3c:	54050763          	beqz	a0,ffffffffc020328a <swap_init+0x660>

     insert_vma_struct(mm, vma);
ffffffffc0202d40:	8556                	mv	a0,s5
ffffffffc0202d42:	43d000ef          	jal	ra,ffffffffc020397e <insert_vma_struct>

     //setup the temp Page Table vaddr 0~4MB
     cprintf("setup Page Table for vaddr 0X1000, so alloc a page\n");
ffffffffc0202d46:	00003517          	auipc	a0,0x3
ffffffffc0202d4a:	22a50513          	addi	a0,a0,554 # ffffffffc0205f70 <default_pmm_manager+0x758>
ffffffffc0202d4e:	c32fd0ef          	jal	ra,ffffffffc0200180 <cprintf>
     pte_t *temp_ptep=NULL;
     temp_ptep = get_pte(mm->pgdir, BEING_CHECK_VALID_VADDR, 1);
ffffffffc0202d52:	018ab503          	ld	a0,24(s5)
ffffffffc0202d56:	4605                	li	a2,1
ffffffffc0202d58:	6585                	lui	a1,0x1
ffffffffc0202d5a:	df7fe0ef          	jal	ra,ffffffffc0201b50 <get_pte>
     assert(temp_ptep!= NULL);
ffffffffc0202d5e:	4e050663          	beqz	a0,ffffffffc020324a <swap_init+0x620>
     cprintf("setup Page Table vaddr 0~4MB OVER!\n");
ffffffffc0202d62:	00003517          	auipc	a0,0x3
ffffffffc0202d66:	25e50513          	addi	a0,a0,606 # ffffffffc0205fc0 <default_pmm_manager+0x7a8>
ffffffffc0202d6a:	0000e497          	auipc	s1,0xe
ffffffffc0202d6e:	72648493          	addi	s1,s1,1830 # ffffffffc0211490 <check_rp>
ffffffffc0202d72:	c0efd0ef          	jal	ra,ffffffffc0200180 <cprintf>
     
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
ffffffffc0202d76:	0000e997          	auipc	s3,0xe
ffffffffc0202d7a:	73a98993          	addi	s3,s3,1850 # ffffffffc02114b0 <swap_in_seq_no>
     cprintf("setup Page Table vaddr 0~4MB OVER!\n");
ffffffffc0202d7e:	8a26                	mv	s4,s1
          check_rp[i] = alloc_page();
ffffffffc0202d80:	4505                	li	a0,1
ffffffffc0202d82:	cc3fe0ef          	jal	ra,ffffffffc0201a44 <alloc_pages>
ffffffffc0202d86:	00aa3023          	sd	a0,0(s4)
          assert(check_rp[i] != NULL );
ffffffffc0202d8a:	2e050c63          	beqz	a0,ffffffffc0203082 <swap_init+0x458>
ffffffffc0202d8e:	651c                	ld	a5,8(a0)
          assert(!PageProperty(check_rp[i]));
ffffffffc0202d90:	8b89                	andi	a5,a5,2
ffffffffc0202d92:	36079063          	bnez	a5,ffffffffc02030f2 <swap_init+0x4c8>
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
ffffffffc0202d96:	0a21                	addi	s4,s4,8
ffffffffc0202d98:	ff3a14e3          	bne	s4,s3,ffffffffc0202d80 <swap_init+0x156>
     }
     list_entry_t free_list_store = free_list;
ffffffffc0202d9c:	601c                	ld	a5,0(s0)
     assert(list_empty(&free_list));
     
     //assert(alloc_page() == NULL);
     
     unsigned int nr_free_store = nr_free;
     nr_free = 0;
ffffffffc0202d9e:	0000ea17          	auipc	s4,0xe
ffffffffc0202da2:	6f2a0a13          	addi	s4,s4,1778 # ffffffffc0211490 <check_rp>
    elm->prev = elm->next = elm;
ffffffffc0202da6:	e000                	sd	s0,0(s0)
     list_entry_t free_list_store = free_list;
ffffffffc0202da8:	ec3e                	sd	a5,24(sp)
ffffffffc0202daa:	641c                	ld	a5,8(s0)
ffffffffc0202dac:	e400                	sd	s0,8(s0)
ffffffffc0202dae:	f03e                	sd	a5,32(sp)
     unsigned int nr_free_store = nr_free;
ffffffffc0202db0:	481c                	lw	a5,16(s0)
ffffffffc0202db2:	f43e                	sd	a5,40(sp)
     nr_free = 0;
ffffffffc0202db4:	0000e797          	auipc	a5,0xe
ffffffffc0202db8:	6a07aa23          	sw	zero,1716(a5) # ffffffffc0211468 <free_area+0x10>
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
        free_pages(check_rp[i],1);
ffffffffc0202dbc:	000a3503          	ld	a0,0(s4)
ffffffffc0202dc0:	4585                	li	a1,1
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
ffffffffc0202dc2:	0a21                	addi	s4,s4,8
        free_pages(check_rp[i],1);
ffffffffc0202dc4:	d13fe0ef          	jal	ra,ffffffffc0201ad6 <free_pages>
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
ffffffffc0202dc8:	ff3a1ae3          	bne	s4,s3,ffffffffc0202dbc <swap_init+0x192>
     }
     assert(nr_free==CHECK_VALID_PHY_PAGE_NUM);
ffffffffc0202dcc:	01042a03          	lw	s4,16(s0)
ffffffffc0202dd0:	4791                	li	a5,4
ffffffffc0202dd2:	44fa1c63          	bne	s4,a5,ffffffffc020322a <swap_init+0x600>
     
     cprintf("set up init env for check_swap begin!\n");
ffffffffc0202dd6:	00003517          	auipc	a0,0x3
ffffffffc0202dda:	27250513          	addi	a0,a0,626 # ffffffffc0206048 <default_pmm_manager+0x830>
ffffffffc0202dde:	ba2fd0ef          	jal	ra,ffffffffc0200180 <cprintf>
     *(unsigned char *)0x1000 = 0x0a;
ffffffffc0202de2:	6705                	lui	a4,0x1
     //setup initial vir_page<->phy_page environment for page relpacement algorithm 

     
     pgfault_num=0;
ffffffffc0202de4:	00012797          	auipc	a5,0x12
ffffffffc0202de8:	7a07ae23          	sw	zero,1980(a5) # ffffffffc02155a0 <pgfault_num>
     *(unsigned char *)0x1000 = 0x0a;
ffffffffc0202dec:	4629                	li	a2,10
ffffffffc0202dee:	00c70023          	sb	a2,0(a4) # 1000 <kern_entry-0xffffffffc01ff000>
     assert(pgfault_num==1);
ffffffffc0202df2:	00012697          	auipc	a3,0x12
ffffffffc0202df6:	7ae6a683          	lw	a3,1966(a3) # ffffffffc02155a0 <pgfault_num>
ffffffffc0202dfa:	4585                	li	a1,1
ffffffffc0202dfc:	00012797          	auipc	a5,0x12
ffffffffc0202e00:	7a478793          	addi	a5,a5,1956 # ffffffffc02155a0 <pgfault_num>
ffffffffc0202e04:	56b69363          	bne	a3,a1,ffffffffc020336a <swap_init+0x740>
     *(unsigned char *)0x1010 = 0x0a;
ffffffffc0202e08:	00c70823          	sb	a2,16(a4)
     assert(pgfault_num==1);
ffffffffc0202e0c:	4398                	lw	a4,0(a5)
ffffffffc0202e0e:	2701                	sext.w	a4,a4
ffffffffc0202e10:	3ed71d63          	bne	a4,a3,ffffffffc020320a <swap_init+0x5e0>
     *(unsigned char *)0x2000 = 0x0b;
ffffffffc0202e14:	6689                	lui	a3,0x2
ffffffffc0202e16:	462d                	li	a2,11
ffffffffc0202e18:	00c68023          	sb	a2,0(a3) # 2000 <kern_entry-0xffffffffc01fe000>
     assert(pgfault_num==2);
ffffffffc0202e1c:	4398                	lw	a4,0(a5)
ffffffffc0202e1e:	4589                	li	a1,2
ffffffffc0202e20:	2701                	sext.w	a4,a4
ffffffffc0202e22:	4cb71463          	bne	a4,a1,ffffffffc02032ea <swap_init+0x6c0>
     *(unsigned char *)0x2010 = 0x0b;
ffffffffc0202e26:	00c68823          	sb	a2,16(a3)
     assert(pgfault_num==2);
ffffffffc0202e2a:	4394                	lw	a3,0(a5)
ffffffffc0202e2c:	2681                	sext.w	a3,a3
ffffffffc0202e2e:	4ce69e63          	bne	a3,a4,ffffffffc020330a <swap_init+0x6e0>
     *(unsigned char *)0x3000 = 0x0c;
ffffffffc0202e32:	668d                	lui	a3,0x3
ffffffffc0202e34:	4631                	li	a2,12
ffffffffc0202e36:	00c68023          	sb	a2,0(a3) # 3000 <kern_entry-0xffffffffc01fd000>
     assert(pgfault_num==3);
ffffffffc0202e3a:	4398                	lw	a4,0(a5)
ffffffffc0202e3c:	458d                	li	a1,3
ffffffffc0202e3e:	2701                	sext.w	a4,a4
ffffffffc0202e40:	4eb71563          	bne	a4,a1,ffffffffc020332a <swap_init+0x700>
     *(unsigned char *)0x3010 = 0x0c;
ffffffffc0202e44:	00c68823          	sb	a2,16(a3)
     assert(pgfault_num==3);
ffffffffc0202e48:	4394                	lw	a3,0(a5)
ffffffffc0202e4a:	2681                	sext.w	a3,a3
ffffffffc0202e4c:	4ee69f63          	bne	a3,a4,ffffffffc020334a <swap_init+0x720>
     *(unsigned char *)0x4000 = 0x0d;
ffffffffc0202e50:	6691                	lui	a3,0x4
ffffffffc0202e52:	4635                	li	a2,13
ffffffffc0202e54:	00c68023          	sb	a2,0(a3) # 4000 <kern_entry-0xffffffffc01fc000>
     assert(pgfault_num==4);
ffffffffc0202e58:	4398                	lw	a4,0(a5)
ffffffffc0202e5a:	2701                	sext.w	a4,a4
ffffffffc0202e5c:	45471763          	bne	a4,s4,ffffffffc02032aa <swap_init+0x680>
     *(unsigned char *)0x4010 = 0x0d;
ffffffffc0202e60:	00c68823          	sb	a2,16(a3)
     assert(pgfault_num==4);
ffffffffc0202e64:	439c                	lw	a5,0(a5)
ffffffffc0202e66:	2781                	sext.w	a5,a5
ffffffffc0202e68:	46e79163          	bne	a5,a4,ffffffffc02032ca <swap_init+0x6a0>
     
     check_content_set();
     assert( nr_free == 0);         
ffffffffc0202e6c:	481c                	lw	a5,16(s0)
ffffffffc0202e6e:	2e079263          	bnez	a5,ffffffffc0203152 <swap_init+0x528>
ffffffffc0202e72:	0000e797          	auipc	a5,0xe
ffffffffc0202e76:	63e78793          	addi	a5,a5,1598 # ffffffffc02114b0 <swap_in_seq_no>
ffffffffc0202e7a:	0000e717          	auipc	a4,0xe
ffffffffc0202e7e:	65e70713          	addi	a4,a4,1630 # ffffffffc02114d8 <swap_out_seq_no>
ffffffffc0202e82:	0000e617          	auipc	a2,0xe
ffffffffc0202e86:	65660613          	addi	a2,a2,1622 # ffffffffc02114d8 <swap_out_seq_no>
     for(i = 0; i<MAX_SEQ_NO ; i++) 
         swap_out_seq_no[i]=swap_in_seq_no[i]=-1;
ffffffffc0202e8a:	56fd                	li	a3,-1
ffffffffc0202e8c:	c394                	sw	a3,0(a5)
ffffffffc0202e8e:	c314                	sw	a3,0(a4)
     for(i = 0; i<MAX_SEQ_NO ; i++) 
ffffffffc0202e90:	0791                	addi	a5,a5,4
ffffffffc0202e92:	0711                	addi	a4,a4,4
ffffffffc0202e94:	fec79ce3          	bne	a5,a2,ffffffffc0202e8c <swap_init+0x262>
ffffffffc0202e98:	0000e717          	auipc	a4,0xe
ffffffffc0202e9c:	5d870713          	addi	a4,a4,1496 # ffffffffc0211470 <check_ptep>
ffffffffc0202ea0:	0000e697          	auipc	a3,0xe
ffffffffc0202ea4:	5f068693          	addi	a3,a3,1520 # ffffffffc0211490 <check_rp>
ffffffffc0202ea8:	6585                	lui	a1,0x1
    if (PPN(pa) >= npage) {
ffffffffc0202eaa:	00012c17          	auipc	s8,0x12
ffffffffc0202eae:	6b6c0c13          	addi	s8,s8,1718 # ffffffffc0215560 <npage>
    return &pages[PPN(pa) - nbase];
ffffffffc0202eb2:	00012c97          	auipc	s9,0x12
ffffffffc0202eb6:	6b6c8c93          	addi	s9,s9,1718 # ffffffffc0215568 <pages>
     
     for (i= 0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
         check_ptep[i]=0;
ffffffffc0202eba:	00073023          	sd	zero,0(a4)
         check_ptep[i] = get_pte(pgdir, (i+1)*0x1000, 0);
ffffffffc0202ebe:	4601                	li	a2,0
ffffffffc0202ec0:	855a                	mv	a0,s6
ffffffffc0202ec2:	e836                	sd	a3,16(sp)
ffffffffc0202ec4:	e42e                	sd	a1,8(sp)
         check_ptep[i]=0;
ffffffffc0202ec6:	e03a                	sd	a4,0(sp)
         check_ptep[i] = get_pte(pgdir, (i+1)*0x1000, 0);
ffffffffc0202ec8:	c89fe0ef          	jal	ra,ffffffffc0201b50 <get_pte>
ffffffffc0202ecc:	6702                	ld	a4,0(sp)
         //cprintf("i %d, check_ptep addr %x, value %x\n", i, check_ptep[i], *check_ptep[i]);
         assert(check_ptep[i] != NULL);
ffffffffc0202ece:	65a2                	ld	a1,8(sp)
ffffffffc0202ed0:	66c2                	ld	a3,16(sp)
         check_ptep[i] = get_pte(pgdir, (i+1)*0x1000, 0);
ffffffffc0202ed2:	e308                	sd	a0,0(a4)
         assert(check_ptep[i] != NULL);
ffffffffc0202ed4:	1e050363          	beqz	a0,ffffffffc02030ba <swap_init+0x490>
         assert(pte2page(*check_ptep[i]) == check_rp[i]);
ffffffffc0202ed8:	611c                	ld	a5,0(a0)
    if (!(pte & PTE_V)) {
ffffffffc0202eda:	0017f613          	andi	a2,a5,1
ffffffffc0202ede:	1e060e63          	beqz	a2,ffffffffc02030da <swap_init+0x4b0>
    if (PPN(pa) >= npage) {
ffffffffc0202ee2:	000c3603          	ld	a2,0(s8)
    return pa2page(PTE_ADDR(pte));
ffffffffc0202ee6:	078a                	slli	a5,a5,0x2
ffffffffc0202ee8:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage) {
ffffffffc0202eea:	16c7f063          	bgeu	a5,a2,ffffffffc020304a <swap_init+0x420>
    return &pages[PPN(pa) - nbase];
ffffffffc0202eee:	00004617          	auipc	a2,0x4
ffffffffc0202ef2:	c0260613          	addi	a2,a2,-1022 # ffffffffc0206af0 <nbase>
ffffffffc0202ef6:	00063a03          	ld	s4,0(a2)
ffffffffc0202efa:	000cb503          	ld	a0,0(s9)
ffffffffc0202efe:	0006b303          	ld	t1,0(a3)
ffffffffc0202f02:	414787b3          	sub	a5,a5,s4
ffffffffc0202f06:	00379613          	slli	a2,a5,0x3
ffffffffc0202f0a:	97b2                	add	a5,a5,a2
ffffffffc0202f0c:	078e                	slli	a5,a5,0x3
ffffffffc0202f0e:	97aa                	add	a5,a5,a0
ffffffffc0202f10:	14f31963          	bne	t1,a5,ffffffffc0203062 <swap_init+0x438>
     for (i= 0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
ffffffffc0202f14:	6785                	lui	a5,0x1
ffffffffc0202f16:	95be                	add	a1,a1,a5
ffffffffc0202f18:	6795                	lui	a5,0x5
ffffffffc0202f1a:	0721                	addi	a4,a4,8
ffffffffc0202f1c:	06a1                	addi	a3,a3,8
ffffffffc0202f1e:	f8f59ee3          	bne	a1,a5,ffffffffc0202eba <swap_init+0x290>
         assert((*check_ptep[i] & PTE_V));          
     }
     cprintf("set up init env for check_swap over!\n");
ffffffffc0202f22:	00003517          	auipc	a0,0x3
ffffffffc0202f26:	1ce50513          	addi	a0,a0,462 # ffffffffc02060f0 <default_pmm_manager+0x8d8>
ffffffffc0202f2a:	a56fd0ef          	jal	ra,ffffffffc0200180 <cprintf>
    int ret = sm->check_swap();
ffffffffc0202f2e:	000bb783          	ld	a5,0(s7)
ffffffffc0202f32:	7f9c                	ld	a5,56(a5)
ffffffffc0202f34:	9782                	jalr	a5
     // now access the virt pages to test  page relpacement algorithm 
     ret=check_content_access();
     assert(ret==0);
ffffffffc0202f36:	32051a63          	bnez	a0,ffffffffc020326a <swap_init+0x640>

     nr_free = nr_free_store;
ffffffffc0202f3a:	77a2                	ld	a5,40(sp)
ffffffffc0202f3c:	c81c                	sw	a5,16(s0)
     free_list = free_list_store;
ffffffffc0202f3e:	67e2                	ld	a5,24(sp)
ffffffffc0202f40:	e01c                	sd	a5,0(s0)
ffffffffc0202f42:	7782                	ld	a5,32(sp)
ffffffffc0202f44:	e41c                	sd	a5,8(s0)

     //restore kernel mem env
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
         free_pages(check_rp[i],1);
ffffffffc0202f46:	6088                	ld	a0,0(s1)
ffffffffc0202f48:	4585                	li	a1,1
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
ffffffffc0202f4a:	04a1                	addi	s1,s1,8
         free_pages(check_rp[i],1);
ffffffffc0202f4c:	b8bfe0ef          	jal	ra,ffffffffc0201ad6 <free_pages>
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
ffffffffc0202f50:	ff349be3          	bne	s1,s3,ffffffffc0202f46 <swap_init+0x31c>
     } 

     //free_page(pte2page(*temp_ptep));
     
     mm_destroy(mm);
ffffffffc0202f54:	8556                	mv	a0,s5
ffffffffc0202f56:	2f9000ef          	jal	ra,ffffffffc0203a4e <mm_destroy>

     pde_t *pd1=pgdir,*pd0=page2kva(pde2page(boot_pgdir[0]));
ffffffffc0202f5a:	00012797          	auipc	a5,0x12
ffffffffc0202f5e:	5fe78793          	addi	a5,a5,1534 # ffffffffc0215558 <boot_pgdir>
ffffffffc0202f62:	639c                	ld	a5,0(a5)
    if (PPN(pa) >= npage) {
ffffffffc0202f64:	000c3703          	ld	a4,0(s8)
    return pa2page(PDE_ADDR(pde));
ffffffffc0202f68:	6394                	ld	a3,0(a5)
ffffffffc0202f6a:	068a                	slli	a3,a3,0x2
ffffffffc0202f6c:	82b1                	srli	a3,a3,0xc
    if (PPN(pa) >= npage) {
ffffffffc0202f6e:	0ce6fc63          	bgeu	a3,a4,ffffffffc0203046 <swap_init+0x41c>
    return &pages[PPN(pa) - nbase];
ffffffffc0202f72:	414687b3          	sub	a5,a3,s4
ffffffffc0202f76:	00379693          	slli	a3,a5,0x3
ffffffffc0202f7a:	96be                	add	a3,a3,a5
ffffffffc0202f7c:	068e                	slli	a3,a3,0x3
    return page - pages + nbase;
ffffffffc0202f7e:	00004797          	auipc	a5,0x4
ffffffffc0202f82:	b6a7b783          	ld	a5,-1174(a5) # ffffffffc0206ae8 <error_string+0x38>
ffffffffc0202f86:	868d                	srai	a3,a3,0x3
ffffffffc0202f88:	02f686b3          	mul	a3,a3,a5
    return &pages[PPN(pa) - nbase];
ffffffffc0202f8c:	000cb503          	ld	a0,0(s9)
    return page - pages + nbase;
ffffffffc0202f90:	96d2                	add	a3,a3,s4
    return KADDR(page2pa(page));
ffffffffc0202f92:	00c69793          	slli	a5,a3,0xc
ffffffffc0202f96:	83b1                	srli	a5,a5,0xc
    return page2ppn(page) << PGSHIFT;
ffffffffc0202f98:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0202f9a:	22e7fc63          	bgeu	a5,a4,ffffffffc02031d2 <swap_init+0x5a8>
     free_page(pde2page(pd0[0]));
ffffffffc0202f9e:	00012797          	auipc	a5,0x12
ffffffffc0202fa2:	5da7b783          	ld	a5,1498(a5) # ffffffffc0215578 <va_pa_offset>
ffffffffc0202fa6:	96be                	add	a3,a3,a5
    return pa2page(PDE_ADDR(pde));
ffffffffc0202fa8:	629c                	ld	a5,0(a3)
ffffffffc0202faa:	078a                	slli	a5,a5,0x2
ffffffffc0202fac:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage) {
ffffffffc0202fae:	08e7fc63          	bgeu	a5,a4,ffffffffc0203046 <swap_init+0x41c>
    return &pages[PPN(pa) - nbase];
ffffffffc0202fb2:	414787b3          	sub	a5,a5,s4
ffffffffc0202fb6:	00379713          	slli	a4,a5,0x3
ffffffffc0202fba:	97ba                	add	a5,a5,a4
ffffffffc0202fbc:	078e                	slli	a5,a5,0x3
ffffffffc0202fbe:	953e                	add	a0,a0,a5
ffffffffc0202fc0:	4585                	li	a1,1
ffffffffc0202fc2:	b15fe0ef          	jal	ra,ffffffffc0201ad6 <free_pages>
    return pa2page(PDE_ADDR(pde));
ffffffffc0202fc6:	000b3783          	ld	a5,0(s6)
    if (PPN(pa) >= npage) {
ffffffffc0202fca:	000c3703          	ld	a4,0(s8)
    return pa2page(PDE_ADDR(pde));
ffffffffc0202fce:	078a                	slli	a5,a5,0x2
ffffffffc0202fd0:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage) {
ffffffffc0202fd2:	06e7fa63          	bgeu	a5,a4,ffffffffc0203046 <swap_init+0x41c>
    return &pages[PPN(pa) - nbase];
ffffffffc0202fd6:	414787b3          	sub	a5,a5,s4
ffffffffc0202fda:	000cb503          	ld	a0,0(s9)
ffffffffc0202fde:	00379a13          	slli	s4,a5,0x3
ffffffffc0202fe2:	97d2                	add	a5,a5,s4
ffffffffc0202fe4:	078e                	slli	a5,a5,0x3
     free_page(pde2page(pd1[0]));
ffffffffc0202fe6:	4585                	li	a1,1
ffffffffc0202fe8:	953e                	add	a0,a0,a5
ffffffffc0202fea:	aedfe0ef          	jal	ra,ffffffffc0201ad6 <free_pages>
     pgdir[0] = 0;
ffffffffc0202fee:	000b3023          	sd	zero,0(s6)
  asm volatile("sfence.vma");
ffffffffc0202ff2:	12000073          	sfence.vma
    return listelm->next;
ffffffffc0202ff6:	641c                	ld	a5,8(s0)
     flush_tlb();

     le = &free_list;
     while ((le = list_next(le)) != &free_list) {
ffffffffc0202ff8:	00878a63          	beq	a5,s0,ffffffffc020300c <swap_init+0x3e2>
         struct Page *p = le2page(le, page_link);
         count --, total -= p->property;
ffffffffc0202ffc:	ff87a703          	lw	a4,-8(a5)
ffffffffc0203000:	679c                	ld	a5,8(a5)
ffffffffc0203002:	3dfd                	addiw	s11,s11,-1
ffffffffc0203004:	40ed0d3b          	subw	s10,s10,a4
     while ((le = list_next(le)) != &free_list) {
ffffffffc0203008:	fe879ae3          	bne	a5,s0,ffffffffc0202ffc <swap_init+0x3d2>
     }
     assert(count==0);
ffffffffc020300c:	1c0d9f63          	bnez	s11,ffffffffc02031ea <swap_init+0x5c0>
     assert(total==0);
ffffffffc0203010:	1a0d1163          	bnez	s10,ffffffffc02031b2 <swap_init+0x588>

     cprintf("check_swap() succeeded!\n");
ffffffffc0203014:	00003517          	auipc	a0,0x3
ffffffffc0203018:	12c50513          	addi	a0,a0,300 # ffffffffc0206140 <default_pmm_manager+0x928>
ffffffffc020301c:	964fd0ef          	jal	ra,ffffffffc0200180 <cprintf>
}
ffffffffc0203020:	b9b1                	j	ffffffffc0202c7c <swap_init+0x52>
     while ((le = list_next(le)) != &free_list) {
ffffffffc0203022:	4481                	li	s1,0
ffffffffc0203024:	b1c9                	j	ffffffffc0202ce6 <swap_init+0xbc>
        assert(PageProperty(p));
ffffffffc0203026:	00002697          	auipc	a3,0x2
ffffffffc020302a:	43268693          	addi	a3,a3,1074 # ffffffffc0205458 <commands+0x728>
ffffffffc020302e:	00002617          	auipc	a2,0x2
ffffffffc0203032:	43a60613          	addi	a2,a2,1082 # ffffffffc0205468 <commands+0x738>
ffffffffc0203036:	0bd00593          	li	a1,189
ffffffffc020303a:	00003517          	auipc	a0,0x3
ffffffffc020303e:	e9e50513          	addi	a0,a0,-354 # ffffffffc0205ed8 <default_pmm_manager+0x6c0>
ffffffffc0203042:	c04fd0ef          	jal	ra,ffffffffc0200446 <__panic>
ffffffffc0203046:	bc9ff0ef          	jal	ra,ffffffffc0202c0e <pa2page.part.0>
        panic("pa2page called with invalid pa");
ffffffffc020304a:	00003617          	auipc	a2,0x3
ffffffffc020304e:	8d660613          	addi	a2,a2,-1834 # ffffffffc0205920 <default_pmm_manager+0x108>
ffffffffc0203052:	06200593          	li	a1,98
ffffffffc0203056:	00003517          	auipc	a0,0x3
ffffffffc020305a:	82250513          	addi	a0,a0,-2014 # ffffffffc0205878 <default_pmm_manager+0x60>
ffffffffc020305e:	be8fd0ef          	jal	ra,ffffffffc0200446 <__panic>
         assert(pte2page(*check_ptep[i]) == check_rp[i]);
ffffffffc0203062:	00003697          	auipc	a3,0x3
ffffffffc0203066:	06668693          	addi	a3,a3,102 # ffffffffc02060c8 <default_pmm_manager+0x8b0>
ffffffffc020306a:	00002617          	auipc	a2,0x2
ffffffffc020306e:	3fe60613          	addi	a2,a2,1022 # ffffffffc0205468 <commands+0x738>
ffffffffc0203072:	0fd00593          	li	a1,253
ffffffffc0203076:	00003517          	auipc	a0,0x3
ffffffffc020307a:	e6250513          	addi	a0,a0,-414 # ffffffffc0205ed8 <default_pmm_manager+0x6c0>
ffffffffc020307e:	bc8fd0ef          	jal	ra,ffffffffc0200446 <__panic>
          assert(check_rp[i] != NULL );
ffffffffc0203082:	00003697          	auipc	a3,0x3
ffffffffc0203086:	f6668693          	addi	a3,a3,-154 # ffffffffc0205fe8 <default_pmm_manager+0x7d0>
ffffffffc020308a:	00002617          	auipc	a2,0x2
ffffffffc020308e:	3de60613          	addi	a2,a2,990 # ffffffffc0205468 <commands+0x738>
ffffffffc0203092:	0dd00593          	li	a1,221
ffffffffc0203096:	00003517          	auipc	a0,0x3
ffffffffc020309a:	e4250513          	addi	a0,a0,-446 # ffffffffc0205ed8 <default_pmm_manager+0x6c0>
ffffffffc020309e:	ba8fd0ef          	jal	ra,ffffffffc0200446 <__panic>
        panic("bad max_swap_offset %08x.\n", max_swap_offset);
ffffffffc02030a2:	00003617          	auipc	a2,0x3
ffffffffc02030a6:	e1660613          	addi	a2,a2,-490 # ffffffffc0205eb8 <default_pmm_manager+0x6a0>
ffffffffc02030aa:	02a00593          	li	a1,42
ffffffffc02030ae:	00003517          	auipc	a0,0x3
ffffffffc02030b2:	e2a50513          	addi	a0,a0,-470 # ffffffffc0205ed8 <default_pmm_manager+0x6c0>
ffffffffc02030b6:	b90fd0ef          	jal	ra,ffffffffc0200446 <__panic>
         assert(check_ptep[i] != NULL);
ffffffffc02030ba:	00003697          	auipc	a3,0x3
ffffffffc02030be:	ff668693          	addi	a3,a3,-10 # ffffffffc02060b0 <default_pmm_manager+0x898>
ffffffffc02030c2:	00002617          	auipc	a2,0x2
ffffffffc02030c6:	3a660613          	addi	a2,a2,934 # ffffffffc0205468 <commands+0x738>
ffffffffc02030ca:	0fc00593          	li	a1,252
ffffffffc02030ce:	00003517          	auipc	a0,0x3
ffffffffc02030d2:	e0a50513          	addi	a0,a0,-502 # ffffffffc0205ed8 <default_pmm_manager+0x6c0>
ffffffffc02030d6:	b70fd0ef          	jal	ra,ffffffffc0200446 <__panic>
        panic("pte2page called with invalid pte");
ffffffffc02030da:	00003617          	auipc	a2,0x3
ffffffffc02030de:	86660613          	addi	a2,a2,-1946 # ffffffffc0205940 <default_pmm_manager+0x128>
ffffffffc02030e2:	07400593          	li	a1,116
ffffffffc02030e6:	00002517          	auipc	a0,0x2
ffffffffc02030ea:	79250513          	addi	a0,a0,1938 # ffffffffc0205878 <default_pmm_manager+0x60>
ffffffffc02030ee:	b58fd0ef          	jal	ra,ffffffffc0200446 <__panic>
          assert(!PageProperty(check_rp[i]));
ffffffffc02030f2:	00003697          	auipc	a3,0x3
ffffffffc02030f6:	f0e68693          	addi	a3,a3,-242 # ffffffffc0206000 <default_pmm_manager+0x7e8>
ffffffffc02030fa:	00002617          	auipc	a2,0x2
ffffffffc02030fe:	36e60613          	addi	a2,a2,878 # ffffffffc0205468 <commands+0x738>
ffffffffc0203102:	0de00593          	li	a1,222
ffffffffc0203106:	00003517          	auipc	a0,0x3
ffffffffc020310a:	dd250513          	addi	a0,a0,-558 # ffffffffc0205ed8 <default_pmm_manager+0x6c0>
ffffffffc020310e:	b38fd0ef          	jal	ra,ffffffffc0200446 <__panic>
     assert(check_mm_struct == NULL);
ffffffffc0203112:	00003697          	auipc	a3,0x3
ffffffffc0203116:	e2668693          	addi	a3,a3,-474 # ffffffffc0205f38 <default_pmm_manager+0x720>
ffffffffc020311a:	00002617          	auipc	a2,0x2
ffffffffc020311e:	34e60613          	addi	a2,a2,846 # ffffffffc0205468 <commands+0x738>
ffffffffc0203122:	0c800593          	li	a1,200
ffffffffc0203126:	00003517          	auipc	a0,0x3
ffffffffc020312a:	db250513          	addi	a0,a0,-590 # ffffffffc0205ed8 <default_pmm_manager+0x6c0>
ffffffffc020312e:	b18fd0ef          	jal	ra,ffffffffc0200446 <__panic>
     assert(total == nr_free_pages());
ffffffffc0203132:	00002697          	auipc	a3,0x2
ffffffffc0203136:	36668693          	addi	a3,a3,870 # ffffffffc0205498 <commands+0x768>
ffffffffc020313a:	00002617          	auipc	a2,0x2
ffffffffc020313e:	32e60613          	addi	a2,a2,814 # ffffffffc0205468 <commands+0x738>
ffffffffc0203142:	0c000593          	li	a1,192
ffffffffc0203146:	00003517          	auipc	a0,0x3
ffffffffc020314a:	d9250513          	addi	a0,a0,-622 # ffffffffc0205ed8 <default_pmm_manager+0x6c0>
ffffffffc020314e:	af8fd0ef          	jal	ra,ffffffffc0200446 <__panic>
     assert( nr_free == 0);         
ffffffffc0203152:	00002697          	auipc	a3,0x2
ffffffffc0203156:	4ee68693          	addi	a3,a3,1262 # ffffffffc0205640 <commands+0x910>
ffffffffc020315a:	00002617          	auipc	a2,0x2
ffffffffc020315e:	30e60613          	addi	a2,a2,782 # ffffffffc0205468 <commands+0x738>
ffffffffc0203162:	0f400593          	li	a1,244
ffffffffc0203166:	00003517          	auipc	a0,0x3
ffffffffc020316a:	d7250513          	addi	a0,a0,-654 # ffffffffc0205ed8 <default_pmm_manager+0x6c0>
ffffffffc020316e:	ad8fd0ef          	jal	ra,ffffffffc0200446 <__panic>
     assert(pgdir[0] == 0);
ffffffffc0203172:	00003697          	auipc	a3,0x3
ffffffffc0203176:	dde68693          	addi	a3,a3,-546 # ffffffffc0205f50 <default_pmm_manager+0x738>
ffffffffc020317a:	00002617          	auipc	a2,0x2
ffffffffc020317e:	2ee60613          	addi	a2,a2,750 # ffffffffc0205468 <commands+0x738>
ffffffffc0203182:	0cd00593          	li	a1,205
ffffffffc0203186:	00003517          	auipc	a0,0x3
ffffffffc020318a:	d5250513          	addi	a0,a0,-686 # ffffffffc0205ed8 <default_pmm_manager+0x6c0>
ffffffffc020318e:	ab8fd0ef          	jal	ra,ffffffffc0200446 <__panic>
     assert(mm != NULL);
ffffffffc0203192:	00003697          	auipc	a3,0x3
ffffffffc0203196:	d9668693          	addi	a3,a3,-618 # ffffffffc0205f28 <default_pmm_manager+0x710>
ffffffffc020319a:	00002617          	auipc	a2,0x2
ffffffffc020319e:	2ce60613          	addi	a2,a2,718 # ffffffffc0205468 <commands+0x738>
ffffffffc02031a2:	0c500593          	li	a1,197
ffffffffc02031a6:	00003517          	auipc	a0,0x3
ffffffffc02031aa:	d3250513          	addi	a0,a0,-718 # ffffffffc0205ed8 <default_pmm_manager+0x6c0>
ffffffffc02031ae:	a98fd0ef          	jal	ra,ffffffffc0200446 <__panic>
     assert(total==0);
ffffffffc02031b2:	00003697          	auipc	a3,0x3
ffffffffc02031b6:	f7e68693          	addi	a3,a3,-130 # ffffffffc0206130 <default_pmm_manager+0x918>
ffffffffc02031ba:	00002617          	auipc	a2,0x2
ffffffffc02031be:	2ae60613          	addi	a2,a2,686 # ffffffffc0205468 <commands+0x738>
ffffffffc02031c2:	11d00593          	li	a1,285
ffffffffc02031c6:	00003517          	auipc	a0,0x3
ffffffffc02031ca:	d1250513          	addi	a0,a0,-750 # ffffffffc0205ed8 <default_pmm_manager+0x6c0>
ffffffffc02031ce:	a78fd0ef          	jal	ra,ffffffffc0200446 <__panic>
    return KADDR(page2pa(page));
ffffffffc02031d2:	00002617          	auipc	a2,0x2
ffffffffc02031d6:	67e60613          	addi	a2,a2,1662 # ffffffffc0205850 <default_pmm_manager+0x38>
ffffffffc02031da:	06900593          	li	a1,105
ffffffffc02031de:	00002517          	auipc	a0,0x2
ffffffffc02031e2:	69a50513          	addi	a0,a0,1690 # ffffffffc0205878 <default_pmm_manager+0x60>
ffffffffc02031e6:	a60fd0ef          	jal	ra,ffffffffc0200446 <__panic>
     assert(count==0);
ffffffffc02031ea:	00003697          	auipc	a3,0x3
ffffffffc02031ee:	f3668693          	addi	a3,a3,-202 # ffffffffc0206120 <default_pmm_manager+0x908>
ffffffffc02031f2:	00002617          	auipc	a2,0x2
ffffffffc02031f6:	27660613          	addi	a2,a2,630 # ffffffffc0205468 <commands+0x738>
ffffffffc02031fa:	11c00593          	li	a1,284
ffffffffc02031fe:	00003517          	auipc	a0,0x3
ffffffffc0203202:	cda50513          	addi	a0,a0,-806 # ffffffffc0205ed8 <default_pmm_manager+0x6c0>
ffffffffc0203206:	a40fd0ef          	jal	ra,ffffffffc0200446 <__panic>
     assert(pgfault_num==1);
ffffffffc020320a:	00003697          	auipc	a3,0x3
ffffffffc020320e:	e6668693          	addi	a3,a3,-410 # ffffffffc0206070 <default_pmm_manager+0x858>
ffffffffc0203212:	00002617          	auipc	a2,0x2
ffffffffc0203216:	25660613          	addi	a2,a2,598 # ffffffffc0205468 <commands+0x738>
ffffffffc020321a:	09600593          	li	a1,150
ffffffffc020321e:	00003517          	auipc	a0,0x3
ffffffffc0203222:	cba50513          	addi	a0,a0,-838 # ffffffffc0205ed8 <default_pmm_manager+0x6c0>
ffffffffc0203226:	a20fd0ef          	jal	ra,ffffffffc0200446 <__panic>
     assert(nr_free==CHECK_VALID_PHY_PAGE_NUM);
ffffffffc020322a:	00003697          	auipc	a3,0x3
ffffffffc020322e:	df668693          	addi	a3,a3,-522 # ffffffffc0206020 <default_pmm_manager+0x808>
ffffffffc0203232:	00002617          	auipc	a2,0x2
ffffffffc0203236:	23660613          	addi	a2,a2,566 # ffffffffc0205468 <commands+0x738>
ffffffffc020323a:	0eb00593          	li	a1,235
ffffffffc020323e:	00003517          	auipc	a0,0x3
ffffffffc0203242:	c9a50513          	addi	a0,a0,-870 # ffffffffc0205ed8 <default_pmm_manager+0x6c0>
ffffffffc0203246:	a00fd0ef          	jal	ra,ffffffffc0200446 <__panic>
     assert(temp_ptep!= NULL);
ffffffffc020324a:	00003697          	auipc	a3,0x3
ffffffffc020324e:	d5e68693          	addi	a3,a3,-674 # ffffffffc0205fa8 <default_pmm_manager+0x790>
ffffffffc0203252:	00002617          	auipc	a2,0x2
ffffffffc0203256:	21660613          	addi	a2,a2,534 # ffffffffc0205468 <commands+0x738>
ffffffffc020325a:	0d800593          	li	a1,216
ffffffffc020325e:	00003517          	auipc	a0,0x3
ffffffffc0203262:	c7a50513          	addi	a0,a0,-902 # ffffffffc0205ed8 <default_pmm_manager+0x6c0>
ffffffffc0203266:	9e0fd0ef          	jal	ra,ffffffffc0200446 <__panic>
     assert(ret==0);
ffffffffc020326a:	00003697          	auipc	a3,0x3
ffffffffc020326e:	eae68693          	addi	a3,a3,-338 # ffffffffc0206118 <default_pmm_manager+0x900>
ffffffffc0203272:	00002617          	auipc	a2,0x2
ffffffffc0203276:	1f660613          	addi	a2,a2,502 # ffffffffc0205468 <commands+0x738>
ffffffffc020327a:	10300593          	li	a1,259
ffffffffc020327e:	00003517          	auipc	a0,0x3
ffffffffc0203282:	c5a50513          	addi	a0,a0,-934 # ffffffffc0205ed8 <default_pmm_manager+0x6c0>
ffffffffc0203286:	9c0fd0ef          	jal	ra,ffffffffc0200446 <__panic>
     assert(vma != NULL);
ffffffffc020328a:	00003697          	auipc	a3,0x3
ffffffffc020328e:	cd668693          	addi	a3,a3,-810 # ffffffffc0205f60 <default_pmm_manager+0x748>
ffffffffc0203292:	00002617          	auipc	a2,0x2
ffffffffc0203296:	1d660613          	addi	a2,a2,470 # ffffffffc0205468 <commands+0x738>
ffffffffc020329a:	0d000593          	li	a1,208
ffffffffc020329e:	00003517          	auipc	a0,0x3
ffffffffc02032a2:	c3a50513          	addi	a0,a0,-966 # ffffffffc0205ed8 <default_pmm_manager+0x6c0>
ffffffffc02032a6:	9a0fd0ef          	jal	ra,ffffffffc0200446 <__panic>
     assert(pgfault_num==4);
ffffffffc02032aa:	00003697          	auipc	a3,0x3
ffffffffc02032ae:	df668693          	addi	a3,a3,-522 # ffffffffc02060a0 <default_pmm_manager+0x888>
ffffffffc02032b2:	00002617          	auipc	a2,0x2
ffffffffc02032b6:	1b660613          	addi	a2,a2,438 # ffffffffc0205468 <commands+0x738>
ffffffffc02032ba:	0a000593          	li	a1,160
ffffffffc02032be:	00003517          	auipc	a0,0x3
ffffffffc02032c2:	c1a50513          	addi	a0,a0,-998 # ffffffffc0205ed8 <default_pmm_manager+0x6c0>
ffffffffc02032c6:	980fd0ef          	jal	ra,ffffffffc0200446 <__panic>
     assert(pgfault_num==4);
ffffffffc02032ca:	00003697          	auipc	a3,0x3
ffffffffc02032ce:	dd668693          	addi	a3,a3,-554 # ffffffffc02060a0 <default_pmm_manager+0x888>
ffffffffc02032d2:	00002617          	auipc	a2,0x2
ffffffffc02032d6:	19660613          	addi	a2,a2,406 # ffffffffc0205468 <commands+0x738>
ffffffffc02032da:	0a200593          	li	a1,162
ffffffffc02032de:	00003517          	auipc	a0,0x3
ffffffffc02032e2:	bfa50513          	addi	a0,a0,-1030 # ffffffffc0205ed8 <default_pmm_manager+0x6c0>
ffffffffc02032e6:	960fd0ef          	jal	ra,ffffffffc0200446 <__panic>
     assert(pgfault_num==2);
ffffffffc02032ea:	00003697          	auipc	a3,0x3
ffffffffc02032ee:	d9668693          	addi	a3,a3,-618 # ffffffffc0206080 <default_pmm_manager+0x868>
ffffffffc02032f2:	00002617          	auipc	a2,0x2
ffffffffc02032f6:	17660613          	addi	a2,a2,374 # ffffffffc0205468 <commands+0x738>
ffffffffc02032fa:	09800593          	li	a1,152
ffffffffc02032fe:	00003517          	auipc	a0,0x3
ffffffffc0203302:	bda50513          	addi	a0,a0,-1062 # ffffffffc0205ed8 <default_pmm_manager+0x6c0>
ffffffffc0203306:	940fd0ef          	jal	ra,ffffffffc0200446 <__panic>
     assert(pgfault_num==2);
ffffffffc020330a:	00003697          	auipc	a3,0x3
ffffffffc020330e:	d7668693          	addi	a3,a3,-650 # ffffffffc0206080 <default_pmm_manager+0x868>
ffffffffc0203312:	00002617          	auipc	a2,0x2
ffffffffc0203316:	15660613          	addi	a2,a2,342 # ffffffffc0205468 <commands+0x738>
ffffffffc020331a:	09a00593          	li	a1,154
ffffffffc020331e:	00003517          	auipc	a0,0x3
ffffffffc0203322:	bba50513          	addi	a0,a0,-1094 # ffffffffc0205ed8 <default_pmm_manager+0x6c0>
ffffffffc0203326:	920fd0ef          	jal	ra,ffffffffc0200446 <__panic>
     assert(pgfault_num==3);
ffffffffc020332a:	00003697          	auipc	a3,0x3
ffffffffc020332e:	d6668693          	addi	a3,a3,-666 # ffffffffc0206090 <default_pmm_manager+0x878>
ffffffffc0203332:	00002617          	auipc	a2,0x2
ffffffffc0203336:	13660613          	addi	a2,a2,310 # ffffffffc0205468 <commands+0x738>
ffffffffc020333a:	09c00593          	li	a1,156
ffffffffc020333e:	00003517          	auipc	a0,0x3
ffffffffc0203342:	b9a50513          	addi	a0,a0,-1126 # ffffffffc0205ed8 <default_pmm_manager+0x6c0>
ffffffffc0203346:	900fd0ef          	jal	ra,ffffffffc0200446 <__panic>
     assert(pgfault_num==3);
ffffffffc020334a:	00003697          	auipc	a3,0x3
ffffffffc020334e:	d4668693          	addi	a3,a3,-698 # ffffffffc0206090 <default_pmm_manager+0x878>
ffffffffc0203352:	00002617          	auipc	a2,0x2
ffffffffc0203356:	11660613          	addi	a2,a2,278 # ffffffffc0205468 <commands+0x738>
ffffffffc020335a:	09e00593          	li	a1,158
ffffffffc020335e:	00003517          	auipc	a0,0x3
ffffffffc0203362:	b7a50513          	addi	a0,a0,-1158 # ffffffffc0205ed8 <default_pmm_manager+0x6c0>
ffffffffc0203366:	8e0fd0ef          	jal	ra,ffffffffc0200446 <__panic>
     assert(pgfault_num==1);
ffffffffc020336a:	00003697          	auipc	a3,0x3
ffffffffc020336e:	d0668693          	addi	a3,a3,-762 # ffffffffc0206070 <default_pmm_manager+0x858>
ffffffffc0203372:	00002617          	auipc	a2,0x2
ffffffffc0203376:	0f660613          	addi	a2,a2,246 # ffffffffc0205468 <commands+0x738>
ffffffffc020337a:	09400593          	li	a1,148
ffffffffc020337e:	00003517          	auipc	a0,0x3
ffffffffc0203382:	b5a50513          	addi	a0,a0,-1190 # ffffffffc0205ed8 <default_pmm_manager+0x6c0>
ffffffffc0203386:	8c0fd0ef          	jal	ra,ffffffffc0200446 <__panic>

ffffffffc020338a <swap_init_mm>:
     return sm->init_mm(mm);
ffffffffc020338a:	00012797          	auipc	a5,0x12
ffffffffc020338e:	1fe7b783          	ld	a5,510(a5) # ffffffffc0215588 <sm>
ffffffffc0203392:	6b9c                	ld	a5,16(a5)
ffffffffc0203394:	8782                	jr	a5

ffffffffc0203396 <swap_map_swappable>:
     return sm->map_swappable(mm, addr, page, swap_in);
ffffffffc0203396:	00012797          	auipc	a5,0x12
ffffffffc020339a:	1f27b783          	ld	a5,498(a5) # ffffffffc0215588 <sm>
ffffffffc020339e:	739c                	ld	a5,32(a5)
ffffffffc02033a0:	8782                	jr	a5

ffffffffc02033a2 <swap_out>:
{
ffffffffc02033a2:	711d                	addi	sp,sp,-96
ffffffffc02033a4:	ec86                	sd	ra,88(sp)
ffffffffc02033a6:	e8a2                	sd	s0,80(sp)
ffffffffc02033a8:	e4a6                	sd	s1,72(sp)
ffffffffc02033aa:	e0ca                	sd	s2,64(sp)
ffffffffc02033ac:	fc4e                	sd	s3,56(sp)
ffffffffc02033ae:	f852                	sd	s4,48(sp)
ffffffffc02033b0:	f456                	sd	s5,40(sp)
ffffffffc02033b2:	f05a                	sd	s6,32(sp)
ffffffffc02033b4:	ec5e                	sd	s7,24(sp)
ffffffffc02033b6:	e862                	sd	s8,16(sp)
     for (i = 0; i != n; ++ i)
ffffffffc02033b8:	cde9                	beqz	a1,ffffffffc0203492 <swap_out+0xf0>
ffffffffc02033ba:	8a2e                	mv	s4,a1
ffffffffc02033bc:	892a                	mv	s2,a0
ffffffffc02033be:	8ab2                	mv	s5,a2
ffffffffc02033c0:	4401                	li	s0,0
ffffffffc02033c2:	00012997          	auipc	s3,0x12
ffffffffc02033c6:	1c698993          	addi	s3,s3,454 # ffffffffc0215588 <sm>
                    cprintf("swap_out: i %d, store page in vaddr 0x%x to disk swap entry %d\n", i, v, page->pra_vaddr/PGSIZE+1);
ffffffffc02033ca:	00003b17          	auipc	s6,0x3
ffffffffc02033ce:	df6b0b13          	addi	s6,s6,-522 # ffffffffc02061c0 <default_pmm_manager+0x9a8>
                    cprintf("SWAP: failed to save\n");
ffffffffc02033d2:	00003b97          	auipc	s7,0x3
ffffffffc02033d6:	dd6b8b93          	addi	s7,s7,-554 # ffffffffc02061a8 <default_pmm_manager+0x990>
ffffffffc02033da:	a825                	j	ffffffffc0203412 <swap_out+0x70>
                    cprintf("swap_out: i %d, store page in vaddr 0x%x to disk swap entry %d\n", i, v, page->pra_vaddr/PGSIZE+1);
ffffffffc02033dc:	67a2                	ld	a5,8(sp)
ffffffffc02033de:	8626                	mv	a2,s1
ffffffffc02033e0:	85a2                	mv	a1,s0
ffffffffc02033e2:	63b4                	ld	a3,64(a5)
ffffffffc02033e4:	855a                	mv	a0,s6
     for (i = 0; i != n; ++ i)
ffffffffc02033e6:	2405                	addiw	s0,s0,1
                    cprintf("swap_out: i %d, store page in vaddr 0x%x to disk swap entry %d\n", i, v, page->pra_vaddr/PGSIZE+1);
ffffffffc02033e8:	82b1                	srli	a3,a3,0xc
ffffffffc02033ea:	0685                	addi	a3,a3,1
ffffffffc02033ec:	d95fc0ef          	jal	ra,ffffffffc0200180 <cprintf>
                    *ptep = (page->pra_vaddr/PGSIZE+1)<<8;
ffffffffc02033f0:	6522                	ld	a0,8(sp)
                    free_page(page);
ffffffffc02033f2:	4585                	li	a1,1
                    *ptep = (page->pra_vaddr/PGSIZE+1)<<8;
ffffffffc02033f4:	613c                	ld	a5,64(a0)
ffffffffc02033f6:	83b1                	srli	a5,a5,0xc
ffffffffc02033f8:	0785                	addi	a5,a5,1
ffffffffc02033fa:	07a2                	slli	a5,a5,0x8
ffffffffc02033fc:	00fc3023          	sd	a5,0(s8)
                    free_page(page);
ffffffffc0203400:	ed6fe0ef          	jal	ra,ffffffffc0201ad6 <free_pages>
          tlb_invalidate(mm->pgdir, v);
ffffffffc0203404:	01893503          	ld	a0,24(s2)
ffffffffc0203408:	85a6                	mv	a1,s1
ffffffffc020340a:	f46ff0ef          	jal	ra,ffffffffc0202b50 <tlb_invalidate>
     for (i = 0; i != n; ++ i)
ffffffffc020340e:	048a0d63          	beq	s4,s0,ffffffffc0203468 <swap_out+0xc6>
          int r = sm->swap_out_victim(mm, &page, in_tick);
ffffffffc0203412:	0009b783          	ld	a5,0(s3)
ffffffffc0203416:	8656                	mv	a2,s5
ffffffffc0203418:	002c                	addi	a1,sp,8
ffffffffc020341a:	7b9c                	ld	a5,48(a5)
ffffffffc020341c:	854a                	mv	a0,s2
ffffffffc020341e:	9782                	jalr	a5
          if (r != 0) {
ffffffffc0203420:	e12d                	bnez	a0,ffffffffc0203482 <swap_out+0xe0>
          v=page->pra_vaddr; 
ffffffffc0203422:	67a2                	ld	a5,8(sp)
          pte_t *ptep = get_pte(mm->pgdir, v, 0);
ffffffffc0203424:	01893503          	ld	a0,24(s2)
ffffffffc0203428:	4601                	li	a2,0
          v=page->pra_vaddr; 
ffffffffc020342a:	63a4                	ld	s1,64(a5)
          pte_t *ptep = get_pte(mm->pgdir, v, 0);
ffffffffc020342c:	85a6                	mv	a1,s1
ffffffffc020342e:	f22fe0ef          	jal	ra,ffffffffc0201b50 <get_pte>
          assert((*ptep & PTE_V) != 0);
ffffffffc0203432:	611c                	ld	a5,0(a0)
          pte_t *ptep = get_pte(mm->pgdir, v, 0);
ffffffffc0203434:	8c2a                	mv	s8,a0
          assert((*ptep & PTE_V) != 0);
ffffffffc0203436:	8b85                	andi	a5,a5,1
ffffffffc0203438:	cfb9                	beqz	a5,ffffffffc0203496 <swap_out+0xf4>
          if (swapfs_write( (page->pra_vaddr/PGSIZE+1)<<8, page) != 0) {
ffffffffc020343a:	65a2                	ld	a1,8(sp)
ffffffffc020343c:	61bc                	ld	a5,64(a1)
ffffffffc020343e:	83b1                	srli	a5,a5,0xc
ffffffffc0203440:	0785                	addi	a5,a5,1
ffffffffc0203442:	00879513          	slli	a0,a5,0x8
ffffffffc0203446:	51d000ef          	jal	ra,ffffffffc0204162 <swapfs_write>
ffffffffc020344a:	d949                	beqz	a0,ffffffffc02033dc <swap_out+0x3a>
                    cprintf("SWAP: failed to save\n");
ffffffffc020344c:	855e                	mv	a0,s7
ffffffffc020344e:	d33fc0ef          	jal	ra,ffffffffc0200180 <cprintf>
                    sm->map_swappable(mm, v, page, 0);
ffffffffc0203452:	0009b783          	ld	a5,0(s3)
ffffffffc0203456:	6622                	ld	a2,8(sp)
ffffffffc0203458:	4681                	li	a3,0
ffffffffc020345a:	739c                	ld	a5,32(a5)
ffffffffc020345c:	85a6                	mv	a1,s1
ffffffffc020345e:	854a                	mv	a0,s2
     for (i = 0; i != n; ++ i)
ffffffffc0203460:	2405                	addiw	s0,s0,1
                    sm->map_swappable(mm, v, page, 0);
ffffffffc0203462:	9782                	jalr	a5
     for (i = 0; i != n; ++ i)
ffffffffc0203464:	fa8a17e3          	bne	s4,s0,ffffffffc0203412 <swap_out+0x70>
}
ffffffffc0203468:	60e6                	ld	ra,88(sp)
ffffffffc020346a:	8522                	mv	a0,s0
ffffffffc020346c:	6446                	ld	s0,80(sp)
ffffffffc020346e:	64a6                	ld	s1,72(sp)
ffffffffc0203470:	6906                	ld	s2,64(sp)
ffffffffc0203472:	79e2                	ld	s3,56(sp)
ffffffffc0203474:	7a42                	ld	s4,48(sp)
ffffffffc0203476:	7aa2                	ld	s5,40(sp)
ffffffffc0203478:	7b02                	ld	s6,32(sp)
ffffffffc020347a:	6be2                	ld	s7,24(sp)
ffffffffc020347c:	6c42                	ld	s8,16(sp)
ffffffffc020347e:	6125                	addi	sp,sp,96
ffffffffc0203480:	8082                	ret
                    cprintf("i %d, swap_out: call swap_out_victim failed\n",i);
ffffffffc0203482:	85a2                	mv	a1,s0
ffffffffc0203484:	00003517          	auipc	a0,0x3
ffffffffc0203488:	cdc50513          	addi	a0,a0,-804 # ffffffffc0206160 <default_pmm_manager+0x948>
ffffffffc020348c:	cf5fc0ef          	jal	ra,ffffffffc0200180 <cprintf>
                  break;
ffffffffc0203490:	bfe1                	j	ffffffffc0203468 <swap_out+0xc6>
     for (i = 0; i != n; ++ i)
ffffffffc0203492:	4401                	li	s0,0
ffffffffc0203494:	bfd1                	j	ffffffffc0203468 <swap_out+0xc6>
          assert((*ptep & PTE_V) != 0);
ffffffffc0203496:	00003697          	auipc	a3,0x3
ffffffffc020349a:	cfa68693          	addi	a3,a3,-774 # ffffffffc0206190 <default_pmm_manager+0x978>
ffffffffc020349e:	00002617          	auipc	a2,0x2
ffffffffc02034a2:	fca60613          	addi	a2,a2,-54 # ffffffffc0205468 <commands+0x738>
ffffffffc02034a6:	06900593          	li	a1,105
ffffffffc02034aa:	00003517          	auipc	a0,0x3
ffffffffc02034ae:	a2e50513          	addi	a0,a0,-1490 # ffffffffc0205ed8 <default_pmm_manager+0x6c0>
ffffffffc02034b2:	f95fc0ef          	jal	ra,ffffffffc0200446 <__panic>

ffffffffc02034b6 <_fifo_init_mm>:
    elm->prev = elm->next = elm;
ffffffffc02034b6:	0000e797          	auipc	a5,0xe
ffffffffc02034ba:	04a78793          	addi	a5,a5,74 # ffffffffc0211500 <pra_list_head>
 */
static int
_fifo_init_mm(struct mm_struct *mm)
{     
     list_init(&pra_list_head);
     mm->sm_priv = &pra_list_head;
ffffffffc02034be:	f51c                	sd	a5,40(a0)
ffffffffc02034c0:	e79c                	sd	a5,8(a5)
ffffffffc02034c2:	e39c                	sd	a5,0(a5)
     //cprintf(" mm->sm_priv %x in fifo_init_mm\n",mm->sm_priv);
     return 0;
}
ffffffffc02034c4:	4501                	li	a0,0
ffffffffc02034c6:	8082                	ret

ffffffffc02034c8 <_fifo_init>:

static int
_fifo_init(void)
{
    return 0;
}
ffffffffc02034c8:	4501                	li	a0,0
ffffffffc02034ca:	8082                	ret

ffffffffc02034cc <_fifo_set_unswappable>:

static int
_fifo_set_unswappable(struct mm_struct *mm, uintptr_t addr)
{
    return 0;
}
ffffffffc02034cc:	4501                	li	a0,0
ffffffffc02034ce:	8082                	ret

ffffffffc02034d0 <_fifo_tick_event>:

static int
_fifo_tick_event(struct mm_struct *mm)
{ return 0; }
ffffffffc02034d0:	4501                	li	a0,0
ffffffffc02034d2:	8082                	ret

ffffffffc02034d4 <_fifo_check_swap>:
_fifo_check_swap(void) {
ffffffffc02034d4:	711d                	addi	sp,sp,-96
ffffffffc02034d6:	fc4e                	sd	s3,56(sp)
ffffffffc02034d8:	f852                	sd	s4,48(sp)
    cprintf("write Virt Page c in fifo_check_swap\n");
ffffffffc02034da:	00003517          	auipc	a0,0x3
ffffffffc02034de:	d2650513          	addi	a0,a0,-730 # ffffffffc0206200 <default_pmm_manager+0x9e8>
    *(unsigned char *)0x3000 = 0x0c;
ffffffffc02034e2:	698d                	lui	s3,0x3
ffffffffc02034e4:	4a31                	li	s4,12
_fifo_check_swap(void) {
ffffffffc02034e6:	e0ca                	sd	s2,64(sp)
ffffffffc02034e8:	ec86                	sd	ra,88(sp)
ffffffffc02034ea:	e8a2                	sd	s0,80(sp)
ffffffffc02034ec:	e4a6                	sd	s1,72(sp)
ffffffffc02034ee:	f456                	sd	s5,40(sp)
ffffffffc02034f0:	f05a                	sd	s6,32(sp)
ffffffffc02034f2:	ec5e                	sd	s7,24(sp)
ffffffffc02034f4:	e862                	sd	s8,16(sp)
ffffffffc02034f6:	e466                	sd	s9,8(sp)
ffffffffc02034f8:	e06a                	sd	s10,0(sp)
    cprintf("write Virt Page c in fifo_check_swap\n");
ffffffffc02034fa:	c87fc0ef          	jal	ra,ffffffffc0200180 <cprintf>
    *(unsigned char *)0x3000 = 0x0c;
ffffffffc02034fe:	01498023          	sb	s4,0(s3) # 3000 <kern_entry-0xffffffffc01fd000>
    assert(pgfault_num==4);
ffffffffc0203502:	00012917          	auipc	s2,0x12
ffffffffc0203506:	09e92903          	lw	s2,158(s2) # ffffffffc02155a0 <pgfault_num>
ffffffffc020350a:	4791                	li	a5,4
ffffffffc020350c:	14f91e63          	bne	s2,a5,ffffffffc0203668 <_fifo_check_swap+0x194>
    cprintf("write Virt Page a in fifo_check_swap\n");
ffffffffc0203510:	00003517          	auipc	a0,0x3
ffffffffc0203514:	d3050513          	addi	a0,a0,-720 # ffffffffc0206240 <default_pmm_manager+0xa28>
    *(unsigned char *)0x1000 = 0x0a;
ffffffffc0203518:	6a85                	lui	s5,0x1
ffffffffc020351a:	4b29                	li	s6,10
    cprintf("write Virt Page a in fifo_check_swap\n");
ffffffffc020351c:	c65fc0ef          	jal	ra,ffffffffc0200180 <cprintf>
ffffffffc0203520:	00012417          	auipc	s0,0x12
ffffffffc0203524:	08040413          	addi	s0,s0,128 # ffffffffc02155a0 <pgfault_num>
    *(unsigned char *)0x1000 = 0x0a;
ffffffffc0203528:	016a8023          	sb	s6,0(s5) # 1000 <kern_entry-0xffffffffc01ff000>
    assert(pgfault_num==4);
ffffffffc020352c:	4004                	lw	s1,0(s0)
ffffffffc020352e:	2481                	sext.w	s1,s1
ffffffffc0203530:	2b249c63          	bne	s1,s2,ffffffffc02037e8 <_fifo_check_swap+0x314>
    cprintf("write Virt Page d in fifo_check_swap\n");
ffffffffc0203534:	00003517          	auipc	a0,0x3
ffffffffc0203538:	d3450513          	addi	a0,a0,-716 # ffffffffc0206268 <default_pmm_manager+0xa50>
    *(unsigned char *)0x4000 = 0x0d;
ffffffffc020353c:	6b91                	lui	s7,0x4
ffffffffc020353e:	4c35                	li	s8,13
    cprintf("write Virt Page d in fifo_check_swap\n");
ffffffffc0203540:	c41fc0ef          	jal	ra,ffffffffc0200180 <cprintf>
    *(unsigned char *)0x4000 = 0x0d;
ffffffffc0203544:	018b8023          	sb	s8,0(s7) # 4000 <kern_entry-0xffffffffc01fc000>
    assert(pgfault_num==4);
ffffffffc0203548:	00042903          	lw	s2,0(s0)
ffffffffc020354c:	2901                	sext.w	s2,s2
ffffffffc020354e:	26991d63          	bne	s2,s1,ffffffffc02037c8 <_fifo_check_swap+0x2f4>
    cprintf("write Virt Page b in fifo_check_swap\n");
ffffffffc0203552:	00003517          	auipc	a0,0x3
ffffffffc0203556:	d3e50513          	addi	a0,a0,-706 # ffffffffc0206290 <default_pmm_manager+0xa78>
    *(unsigned char *)0x2000 = 0x0b;
ffffffffc020355a:	6c89                	lui	s9,0x2
ffffffffc020355c:	4d2d                	li	s10,11
    cprintf("write Virt Page b in fifo_check_swap\n");
ffffffffc020355e:	c23fc0ef          	jal	ra,ffffffffc0200180 <cprintf>
    *(unsigned char *)0x2000 = 0x0b;
ffffffffc0203562:	01ac8023          	sb	s10,0(s9) # 2000 <kern_entry-0xffffffffc01fe000>
    assert(pgfault_num==4);
ffffffffc0203566:	401c                	lw	a5,0(s0)
ffffffffc0203568:	2781                	sext.w	a5,a5
ffffffffc020356a:	23279f63          	bne	a5,s2,ffffffffc02037a8 <_fifo_check_swap+0x2d4>
    cprintf("write Virt Page e in fifo_check_swap\n");
ffffffffc020356e:	00003517          	auipc	a0,0x3
ffffffffc0203572:	d4a50513          	addi	a0,a0,-694 # ffffffffc02062b8 <default_pmm_manager+0xaa0>
ffffffffc0203576:	c0bfc0ef          	jal	ra,ffffffffc0200180 <cprintf>
    *(unsigned char *)0x5000 = 0x0e;
ffffffffc020357a:	6795                	lui	a5,0x5
ffffffffc020357c:	4739                	li	a4,14
ffffffffc020357e:	00e78023          	sb	a4,0(a5) # 5000 <kern_entry-0xffffffffc01fb000>
    assert(pgfault_num==5);
ffffffffc0203582:	4004                	lw	s1,0(s0)
ffffffffc0203584:	4795                	li	a5,5
ffffffffc0203586:	2481                	sext.w	s1,s1
ffffffffc0203588:	20f49063          	bne	s1,a5,ffffffffc0203788 <_fifo_check_swap+0x2b4>
    cprintf("write Virt Page b in fifo_check_swap\n");
ffffffffc020358c:	00003517          	auipc	a0,0x3
ffffffffc0203590:	d0450513          	addi	a0,a0,-764 # ffffffffc0206290 <default_pmm_manager+0xa78>
ffffffffc0203594:	bedfc0ef          	jal	ra,ffffffffc0200180 <cprintf>
    *(unsigned char *)0x2000 = 0x0b;
ffffffffc0203598:	01ac8023          	sb	s10,0(s9)
    assert(pgfault_num==5);
ffffffffc020359c:	401c                	lw	a5,0(s0)
ffffffffc020359e:	2781                	sext.w	a5,a5
ffffffffc02035a0:	1c979463          	bne	a5,s1,ffffffffc0203768 <_fifo_check_swap+0x294>
    cprintf("write Virt Page a in fifo_check_swap\n");
ffffffffc02035a4:	00003517          	auipc	a0,0x3
ffffffffc02035a8:	c9c50513          	addi	a0,a0,-868 # ffffffffc0206240 <default_pmm_manager+0xa28>
ffffffffc02035ac:	bd5fc0ef          	jal	ra,ffffffffc0200180 <cprintf>
    *(unsigned char *)0x1000 = 0x0a;
ffffffffc02035b0:	016a8023          	sb	s6,0(s5)
    assert(pgfault_num==6);
ffffffffc02035b4:	401c                	lw	a5,0(s0)
ffffffffc02035b6:	4719                	li	a4,6
ffffffffc02035b8:	2781                	sext.w	a5,a5
ffffffffc02035ba:	18e79763          	bne	a5,a4,ffffffffc0203748 <_fifo_check_swap+0x274>
    cprintf("write Virt Page b in fifo_check_swap\n");
ffffffffc02035be:	00003517          	auipc	a0,0x3
ffffffffc02035c2:	cd250513          	addi	a0,a0,-814 # ffffffffc0206290 <default_pmm_manager+0xa78>
ffffffffc02035c6:	bbbfc0ef          	jal	ra,ffffffffc0200180 <cprintf>
    *(unsigned char *)0x2000 = 0x0b;
ffffffffc02035ca:	01ac8023          	sb	s10,0(s9)
    assert(pgfault_num==7);
ffffffffc02035ce:	401c                	lw	a5,0(s0)
ffffffffc02035d0:	471d                	li	a4,7
ffffffffc02035d2:	2781                	sext.w	a5,a5
ffffffffc02035d4:	14e79a63          	bne	a5,a4,ffffffffc0203728 <_fifo_check_swap+0x254>
    cprintf("write Virt Page c in fifo_check_swap\n");
ffffffffc02035d8:	00003517          	auipc	a0,0x3
ffffffffc02035dc:	c2850513          	addi	a0,a0,-984 # ffffffffc0206200 <default_pmm_manager+0x9e8>
ffffffffc02035e0:	ba1fc0ef          	jal	ra,ffffffffc0200180 <cprintf>
    *(unsigned char *)0x3000 = 0x0c;
ffffffffc02035e4:	01498023          	sb	s4,0(s3)
    assert(pgfault_num==8);
ffffffffc02035e8:	401c                	lw	a5,0(s0)
ffffffffc02035ea:	4721                	li	a4,8
ffffffffc02035ec:	2781                	sext.w	a5,a5
ffffffffc02035ee:	10e79d63          	bne	a5,a4,ffffffffc0203708 <_fifo_check_swap+0x234>
    cprintf("write Virt Page d in fifo_check_swap\n");
ffffffffc02035f2:	00003517          	auipc	a0,0x3
ffffffffc02035f6:	c7650513          	addi	a0,a0,-906 # ffffffffc0206268 <default_pmm_manager+0xa50>
ffffffffc02035fa:	b87fc0ef          	jal	ra,ffffffffc0200180 <cprintf>
    *(unsigned char *)0x4000 = 0x0d;
ffffffffc02035fe:	018b8023          	sb	s8,0(s7)
    assert(pgfault_num==9);
ffffffffc0203602:	401c                	lw	a5,0(s0)
ffffffffc0203604:	4725                	li	a4,9
ffffffffc0203606:	2781                	sext.w	a5,a5
ffffffffc0203608:	0ee79063          	bne	a5,a4,ffffffffc02036e8 <_fifo_check_swap+0x214>
    cprintf("write Virt Page e in fifo_check_swap\n");
ffffffffc020360c:	00003517          	auipc	a0,0x3
ffffffffc0203610:	cac50513          	addi	a0,a0,-852 # ffffffffc02062b8 <default_pmm_manager+0xaa0>
ffffffffc0203614:	b6dfc0ef          	jal	ra,ffffffffc0200180 <cprintf>
    *(unsigned char *)0x5000 = 0x0e;
ffffffffc0203618:	6795                	lui	a5,0x5
ffffffffc020361a:	4739                	li	a4,14
ffffffffc020361c:	00e78023          	sb	a4,0(a5) # 5000 <kern_entry-0xffffffffc01fb000>
    assert(pgfault_num==10);
ffffffffc0203620:	4004                	lw	s1,0(s0)
ffffffffc0203622:	47a9                	li	a5,10
ffffffffc0203624:	2481                	sext.w	s1,s1
ffffffffc0203626:	0af49163          	bne	s1,a5,ffffffffc02036c8 <_fifo_check_swap+0x1f4>
    cprintf("write Virt Page a in fifo_check_swap\n");
ffffffffc020362a:	00003517          	auipc	a0,0x3
ffffffffc020362e:	c1650513          	addi	a0,a0,-1002 # ffffffffc0206240 <default_pmm_manager+0xa28>
ffffffffc0203632:	b4ffc0ef          	jal	ra,ffffffffc0200180 <cprintf>
    assert(*(unsigned char *)0x1000 == 0x0a);
ffffffffc0203636:	6785                	lui	a5,0x1
ffffffffc0203638:	0007c783          	lbu	a5,0(a5) # 1000 <kern_entry-0xffffffffc01ff000>
ffffffffc020363c:	06979663          	bne	a5,s1,ffffffffc02036a8 <_fifo_check_swap+0x1d4>
    assert(pgfault_num==11);
ffffffffc0203640:	401c                	lw	a5,0(s0)
ffffffffc0203642:	472d                	li	a4,11
ffffffffc0203644:	2781                	sext.w	a5,a5
ffffffffc0203646:	04e79163          	bne	a5,a4,ffffffffc0203688 <_fifo_check_swap+0x1b4>
}
ffffffffc020364a:	60e6                	ld	ra,88(sp)
ffffffffc020364c:	6446                	ld	s0,80(sp)
ffffffffc020364e:	64a6                	ld	s1,72(sp)
ffffffffc0203650:	6906                	ld	s2,64(sp)
ffffffffc0203652:	79e2                	ld	s3,56(sp)
ffffffffc0203654:	7a42                	ld	s4,48(sp)
ffffffffc0203656:	7aa2                	ld	s5,40(sp)
ffffffffc0203658:	7b02                	ld	s6,32(sp)
ffffffffc020365a:	6be2                	ld	s7,24(sp)
ffffffffc020365c:	6c42                	ld	s8,16(sp)
ffffffffc020365e:	6ca2                	ld	s9,8(sp)
ffffffffc0203660:	6d02                	ld	s10,0(sp)
ffffffffc0203662:	4501                	li	a0,0
ffffffffc0203664:	6125                	addi	sp,sp,96
ffffffffc0203666:	8082                	ret
    assert(pgfault_num==4);
ffffffffc0203668:	00003697          	auipc	a3,0x3
ffffffffc020366c:	a3868693          	addi	a3,a3,-1480 # ffffffffc02060a0 <default_pmm_manager+0x888>
ffffffffc0203670:	00002617          	auipc	a2,0x2
ffffffffc0203674:	df860613          	addi	a2,a2,-520 # ffffffffc0205468 <commands+0x738>
ffffffffc0203678:	05100593          	li	a1,81
ffffffffc020367c:	00003517          	auipc	a0,0x3
ffffffffc0203680:	bac50513          	addi	a0,a0,-1108 # ffffffffc0206228 <default_pmm_manager+0xa10>
ffffffffc0203684:	dc3fc0ef          	jal	ra,ffffffffc0200446 <__panic>
    assert(pgfault_num==11);
ffffffffc0203688:	00003697          	auipc	a3,0x3
ffffffffc020368c:	ce068693          	addi	a3,a3,-800 # ffffffffc0206368 <default_pmm_manager+0xb50>
ffffffffc0203690:	00002617          	auipc	a2,0x2
ffffffffc0203694:	dd860613          	addi	a2,a2,-552 # ffffffffc0205468 <commands+0x738>
ffffffffc0203698:	07300593          	li	a1,115
ffffffffc020369c:	00003517          	auipc	a0,0x3
ffffffffc02036a0:	b8c50513          	addi	a0,a0,-1140 # ffffffffc0206228 <default_pmm_manager+0xa10>
ffffffffc02036a4:	da3fc0ef          	jal	ra,ffffffffc0200446 <__panic>
    assert(*(unsigned char *)0x1000 == 0x0a);
ffffffffc02036a8:	00003697          	auipc	a3,0x3
ffffffffc02036ac:	c9868693          	addi	a3,a3,-872 # ffffffffc0206340 <default_pmm_manager+0xb28>
ffffffffc02036b0:	00002617          	auipc	a2,0x2
ffffffffc02036b4:	db860613          	addi	a2,a2,-584 # ffffffffc0205468 <commands+0x738>
ffffffffc02036b8:	07100593          	li	a1,113
ffffffffc02036bc:	00003517          	auipc	a0,0x3
ffffffffc02036c0:	b6c50513          	addi	a0,a0,-1172 # ffffffffc0206228 <default_pmm_manager+0xa10>
ffffffffc02036c4:	d83fc0ef          	jal	ra,ffffffffc0200446 <__panic>
    assert(pgfault_num==10);
ffffffffc02036c8:	00003697          	auipc	a3,0x3
ffffffffc02036cc:	c6868693          	addi	a3,a3,-920 # ffffffffc0206330 <default_pmm_manager+0xb18>
ffffffffc02036d0:	00002617          	auipc	a2,0x2
ffffffffc02036d4:	d9860613          	addi	a2,a2,-616 # ffffffffc0205468 <commands+0x738>
ffffffffc02036d8:	06f00593          	li	a1,111
ffffffffc02036dc:	00003517          	auipc	a0,0x3
ffffffffc02036e0:	b4c50513          	addi	a0,a0,-1204 # ffffffffc0206228 <default_pmm_manager+0xa10>
ffffffffc02036e4:	d63fc0ef          	jal	ra,ffffffffc0200446 <__panic>
    assert(pgfault_num==9);
ffffffffc02036e8:	00003697          	auipc	a3,0x3
ffffffffc02036ec:	c3868693          	addi	a3,a3,-968 # ffffffffc0206320 <default_pmm_manager+0xb08>
ffffffffc02036f0:	00002617          	auipc	a2,0x2
ffffffffc02036f4:	d7860613          	addi	a2,a2,-648 # ffffffffc0205468 <commands+0x738>
ffffffffc02036f8:	06c00593          	li	a1,108
ffffffffc02036fc:	00003517          	auipc	a0,0x3
ffffffffc0203700:	b2c50513          	addi	a0,a0,-1236 # ffffffffc0206228 <default_pmm_manager+0xa10>
ffffffffc0203704:	d43fc0ef          	jal	ra,ffffffffc0200446 <__panic>
    assert(pgfault_num==8);
ffffffffc0203708:	00003697          	auipc	a3,0x3
ffffffffc020370c:	c0868693          	addi	a3,a3,-1016 # ffffffffc0206310 <default_pmm_manager+0xaf8>
ffffffffc0203710:	00002617          	auipc	a2,0x2
ffffffffc0203714:	d5860613          	addi	a2,a2,-680 # ffffffffc0205468 <commands+0x738>
ffffffffc0203718:	06900593          	li	a1,105
ffffffffc020371c:	00003517          	auipc	a0,0x3
ffffffffc0203720:	b0c50513          	addi	a0,a0,-1268 # ffffffffc0206228 <default_pmm_manager+0xa10>
ffffffffc0203724:	d23fc0ef          	jal	ra,ffffffffc0200446 <__panic>
    assert(pgfault_num==7);
ffffffffc0203728:	00003697          	auipc	a3,0x3
ffffffffc020372c:	bd868693          	addi	a3,a3,-1064 # ffffffffc0206300 <default_pmm_manager+0xae8>
ffffffffc0203730:	00002617          	auipc	a2,0x2
ffffffffc0203734:	d3860613          	addi	a2,a2,-712 # ffffffffc0205468 <commands+0x738>
ffffffffc0203738:	06600593          	li	a1,102
ffffffffc020373c:	00003517          	auipc	a0,0x3
ffffffffc0203740:	aec50513          	addi	a0,a0,-1300 # ffffffffc0206228 <default_pmm_manager+0xa10>
ffffffffc0203744:	d03fc0ef          	jal	ra,ffffffffc0200446 <__panic>
    assert(pgfault_num==6);
ffffffffc0203748:	00003697          	auipc	a3,0x3
ffffffffc020374c:	ba868693          	addi	a3,a3,-1112 # ffffffffc02062f0 <default_pmm_manager+0xad8>
ffffffffc0203750:	00002617          	auipc	a2,0x2
ffffffffc0203754:	d1860613          	addi	a2,a2,-744 # ffffffffc0205468 <commands+0x738>
ffffffffc0203758:	06300593          	li	a1,99
ffffffffc020375c:	00003517          	auipc	a0,0x3
ffffffffc0203760:	acc50513          	addi	a0,a0,-1332 # ffffffffc0206228 <default_pmm_manager+0xa10>
ffffffffc0203764:	ce3fc0ef          	jal	ra,ffffffffc0200446 <__panic>
    assert(pgfault_num==5);
ffffffffc0203768:	00003697          	auipc	a3,0x3
ffffffffc020376c:	b7868693          	addi	a3,a3,-1160 # ffffffffc02062e0 <default_pmm_manager+0xac8>
ffffffffc0203770:	00002617          	auipc	a2,0x2
ffffffffc0203774:	cf860613          	addi	a2,a2,-776 # ffffffffc0205468 <commands+0x738>
ffffffffc0203778:	06000593          	li	a1,96
ffffffffc020377c:	00003517          	auipc	a0,0x3
ffffffffc0203780:	aac50513          	addi	a0,a0,-1364 # ffffffffc0206228 <default_pmm_manager+0xa10>
ffffffffc0203784:	cc3fc0ef          	jal	ra,ffffffffc0200446 <__panic>
    assert(pgfault_num==5);
ffffffffc0203788:	00003697          	auipc	a3,0x3
ffffffffc020378c:	b5868693          	addi	a3,a3,-1192 # ffffffffc02062e0 <default_pmm_manager+0xac8>
ffffffffc0203790:	00002617          	auipc	a2,0x2
ffffffffc0203794:	cd860613          	addi	a2,a2,-808 # ffffffffc0205468 <commands+0x738>
ffffffffc0203798:	05d00593          	li	a1,93
ffffffffc020379c:	00003517          	auipc	a0,0x3
ffffffffc02037a0:	a8c50513          	addi	a0,a0,-1396 # ffffffffc0206228 <default_pmm_manager+0xa10>
ffffffffc02037a4:	ca3fc0ef          	jal	ra,ffffffffc0200446 <__panic>
    assert(pgfault_num==4);
ffffffffc02037a8:	00003697          	auipc	a3,0x3
ffffffffc02037ac:	8f868693          	addi	a3,a3,-1800 # ffffffffc02060a0 <default_pmm_manager+0x888>
ffffffffc02037b0:	00002617          	auipc	a2,0x2
ffffffffc02037b4:	cb860613          	addi	a2,a2,-840 # ffffffffc0205468 <commands+0x738>
ffffffffc02037b8:	05a00593          	li	a1,90
ffffffffc02037bc:	00003517          	auipc	a0,0x3
ffffffffc02037c0:	a6c50513          	addi	a0,a0,-1428 # ffffffffc0206228 <default_pmm_manager+0xa10>
ffffffffc02037c4:	c83fc0ef          	jal	ra,ffffffffc0200446 <__panic>
    assert(pgfault_num==4);
ffffffffc02037c8:	00003697          	auipc	a3,0x3
ffffffffc02037cc:	8d868693          	addi	a3,a3,-1832 # ffffffffc02060a0 <default_pmm_manager+0x888>
ffffffffc02037d0:	00002617          	auipc	a2,0x2
ffffffffc02037d4:	c9860613          	addi	a2,a2,-872 # ffffffffc0205468 <commands+0x738>
ffffffffc02037d8:	05700593          	li	a1,87
ffffffffc02037dc:	00003517          	auipc	a0,0x3
ffffffffc02037e0:	a4c50513          	addi	a0,a0,-1460 # ffffffffc0206228 <default_pmm_manager+0xa10>
ffffffffc02037e4:	c63fc0ef          	jal	ra,ffffffffc0200446 <__panic>
    assert(pgfault_num==4);
ffffffffc02037e8:	00003697          	auipc	a3,0x3
ffffffffc02037ec:	8b868693          	addi	a3,a3,-1864 # ffffffffc02060a0 <default_pmm_manager+0x888>
ffffffffc02037f0:	00002617          	auipc	a2,0x2
ffffffffc02037f4:	c7860613          	addi	a2,a2,-904 # ffffffffc0205468 <commands+0x738>
ffffffffc02037f8:	05400593          	li	a1,84
ffffffffc02037fc:	00003517          	auipc	a0,0x3
ffffffffc0203800:	a2c50513          	addi	a0,a0,-1492 # ffffffffc0206228 <default_pmm_manager+0xa10>
ffffffffc0203804:	c43fc0ef          	jal	ra,ffffffffc0200446 <__panic>

ffffffffc0203808 <_fifo_swap_out_victim>:
     list_entry_t *head=(list_entry_t*) mm->sm_priv;
ffffffffc0203808:	751c                	ld	a5,40(a0)
{
ffffffffc020380a:	1141                	addi	sp,sp,-16
ffffffffc020380c:	e406                	sd	ra,8(sp)
         assert(head != NULL);
ffffffffc020380e:	cf91                	beqz	a5,ffffffffc020382a <_fifo_swap_out_victim+0x22>
     assert(in_tick==0);
ffffffffc0203810:	ee0d                	bnez	a2,ffffffffc020384a <_fifo_swap_out_victim+0x42>
    return listelm->next;
ffffffffc0203812:	679c                	ld	a5,8(a5)
}
ffffffffc0203814:	60a2                	ld	ra,8(sp)
ffffffffc0203816:	4501                	li	a0,0
    __list_del(listelm->prev, listelm->next);
ffffffffc0203818:	6394                	ld	a3,0(a5)
ffffffffc020381a:	6798                	ld	a4,8(a5)
    *ptr_page = le2page(entry, pra_page_link);
ffffffffc020381c:	fd078793          	addi	a5,a5,-48
    prev->next = next;
ffffffffc0203820:	e698                	sd	a4,8(a3)
    next->prev = prev;
ffffffffc0203822:	e314                	sd	a3,0(a4)
ffffffffc0203824:	e19c                	sd	a5,0(a1)
}
ffffffffc0203826:	0141                	addi	sp,sp,16
ffffffffc0203828:	8082                	ret
         assert(head != NULL);
ffffffffc020382a:	00003697          	auipc	a3,0x3
ffffffffc020382e:	b4e68693          	addi	a3,a3,-1202 # ffffffffc0206378 <default_pmm_manager+0xb60>
ffffffffc0203832:	00002617          	auipc	a2,0x2
ffffffffc0203836:	c3660613          	addi	a2,a2,-970 # ffffffffc0205468 <commands+0x738>
ffffffffc020383a:	04100593          	li	a1,65
ffffffffc020383e:	00003517          	auipc	a0,0x3
ffffffffc0203842:	9ea50513          	addi	a0,a0,-1558 # ffffffffc0206228 <default_pmm_manager+0xa10>
ffffffffc0203846:	c01fc0ef          	jal	ra,ffffffffc0200446 <__panic>
     assert(in_tick==0);
ffffffffc020384a:	00003697          	auipc	a3,0x3
ffffffffc020384e:	b3e68693          	addi	a3,a3,-1218 # ffffffffc0206388 <default_pmm_manager+0xb70>
ffffffffc0203852:	00002617          	auipc	a2,0x2
ffffffffc0203856:	c1660613          	addi	a2,a2,-1002 # ffffffffc0205468 <commands+0x738>
ffffffffc020385a:	04200593          	li	a1,66
ffffffffc020385e:	00003517          	auipc	a0,0x3
ffffffffc0203862:	9ca50513          	addi	a0,a0,-1590 # ffffffffc0206228 <default_pmm_manager+0xa10>
ffffffffc0203866:	be1fc0ef          	jal	ra,ffffffffc0200446 <__panic>

ffffffffc020386a <_fifo_map_swappable>:
    list_entry_t *head=(list_entry_t*) mm->sm_priv;
ffffffffc020386a:	751c                	ld	a5,40(a0)
    assert(entry != NULL && head != NULL);
ffffffffc020386c:	cb91                	beqz	a5,ffffffffc0203880 <_fifo_map_swappable+0x16>
    __list_add(elm, listelm->prev, listelm);
ffffffffc020386e:	6394                	ld	a3,0(a5)
ffffffffc0203870:	03060713          	addi	a4,a2,48
    prev->next = next->prev = elm;
ffffffffc0203874:	e398                	sd	a4,0(a5)
ffffffffc0203876:	e698                	sd	a4,8(a3)
}
ffffffffc0203878:	4501                	li	a0,0
    elm->next = next;
ffffffffc020387a:	fe1c                	sd	a5,56(a2)
    elm->prev = prev;
ffffffffc020387c:	fa14                	sd	a3,48(a2)
ffffffffc020387e:	8082                	ret
{
ffffffffc0203880:	1141                	addi	sp,sp,-16
    assert(entry != NULL && head != NULL);
ffffffffc0203882:	00003697          	auipc	a3,0x3
ffffffffc0203886:	b1668693          	addi	a3,a3,-1258 # ffffffffc0206398 <default_pmm_manager+0xb80>
ffffffffc020388a:	00002617          	auipc	a2,0x2
ffffffffc020388e:	bde60613          	addi	a2,a2,-1058 # ffffffffc0205468 <commands+0x738>
ffffffffc0203892:	03200593          	li	a1,50
ffffffffc0203896:	00003517          	auipc	a0,0x3
ffffffffc020389a:	99250513          	addi	a0,a0,-1646 # ffffffffc0206228 <default_pmm_manager+0xa10>
{
ffffffffc020389e:	e406                	sd	ra,8(sp)
    assert(entry != NULL && head != NULL);
ffffffffc02038a0:	ba7fc0ef          	jal	ra,ffffffffc0200446 <__panic>

ffffffffc02038a4 <check_vma_overlap.part.0>:
}


// check_vma_overlap - check if vma1 overlaps vma2 ?
static inline void
check_vma_overlap(struct vma_struct *prev, struct vma_struct *next) {
ffffffffc02038a4:	1141                	addi	sp,sp,-16
    assert(prev->vm_start < prev->vm_end);
    assert(prev->vm_end <= next->vm_start);
    assert(next->vm_start < next->vm_end);
ffffffffc02038a6:	00003697          	auipc	a3,0x3
ffffffffc02038aa:	b2a68693          	addi	a3,a3,-1238 # ffffffffc02063d0 <default_pmm_manager+0xbb8>
ffffffffc02038ae:	00002617          	auipc	a2,0x2
ffffffffc02038b2:	bba60613          	addi	a2,a2,-1094 # ffffffffc0205468 <commands+0x738>
ffffffffc02038b6:	07e00593          	li	a1,126
ffffffffc02038ba:	00003517          	auipc	a0,0x3
ffffffffc02038be:	b3650513          	addi	a0,a0,-1226 # ffffffffc02063f0 <default_pmm_manager+0xbd8>
check_vma_overlap(struct vma_struct *prev, struct vma_struct *next) {
ffffffffc02038c2:	e406                	sd	ra,8(sp)
    assert(next->vm_start < next->vm_end);
ffffffffc02038c4:	b83fc0ef          	jal	ra,ffffffffc0200446 <__panic>

ffffffffc02038c8 <mm_create>:
mm_create(void) {
ffffffffc02038c8:	1141                	addi	sp,sp,-16
    struct mm_struct *mm = kmalloc(sizeof(struct mm_struct));
ffffffffc02038ca:	03000513          	li	a0,48
mm_create(void) {
ffffffffc02038ce:	e022                	sd	s0,0(sp)
ffffffffc02038d0:	e406                	sd	ra,8(sp)
    struct mm_struct *mm = kmalloc(sizeof(struct mm_struct));
ffffffffc02038d2:	f8ffd0ef          	jal	ra,ffffffffc0201860 <kmalloc>
ffffffffc02038d6:	842a                	mv	s0,a0
    if (mm != NULL) {
ffffffffc02038d8:	c105                	beqz	a0,ffffffffc02038f8 <mm_create+0x30>
    elm->prev = elm->next = elm;
ffffffffc02038da:	e408                	sd	a0,8(s0)
ffffffffc02038dc:	e008                	sd	a0,0(s0)
        mm->mmap_cache = NULL;
ffffffffc02038de:	00053823          	sd	zero,16(a0)
        mm->pgdir = NULL;
ffffffffc02038e2:	00053c23          	sd	zero,24(a0)
        mm->map_count = 0;
ffffffffc02038e6:	02052023          	sw	zero,32(a0)
        if (swap_init_ok) swap_init_mm(mm);
ffffffffc02038ea:	00012797          	auipc	a5,0x12
ffffffffc02038ee:	ca67a783          	lw	a5,-858(a5) # ffffffffc0215590 <swap_init_ok>
ffffffffc02038f2:	eb81                	bnez	a5,ffffffffc0203902 <mm_create+0x3a>
        else mm->sm_priv = NULL;
ffffffffc02038f4:	02053423          	sd	zero,40(a0)
}
ffffffffc02038f8:	60a2                	ld	ra,8(sp)
ffffffffc02038fa:	8522                	mv	a0,s0
ffffffffc02038fc:	6402                	ld	s0,0(sp)
ffffffffc02038fe:	0141                	addi	sp,sp,16
ffffffffc0203900:	8082                	ret
        if (swap_init_ok) swap_init_mm(mm);
ffffffffc0203902:	a89ff0ef          	jal	ra,ffffffffc020338a <swap_init_mm>
}
ffffffffc0203906:	60a2                	ld	ra,8(sp)
ffffffffc0203908:	8522                	mv	a0,s0
ffffffffc020390a:	6402                	ld	s0,0(sp)
ffffffffc020390c:	0141                	addi	sp,sp,16
ffffffffc020390e:	8082                	ret

ffffffffc0203910 <vma_create>:
vma_create(uintptr_t vm_start, uintptr_t vm_end, uint32_t vm_flags) {
ffffffffc0203910:	1101                	addi	sp,sp,-32
ffffffffc0203912:	e04a                	sd	s2,0(sp)
ffffffffc0203914:	892a                	mv	s2,a0
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
ffffffffc0203916:	03000513          	li	a0,48
vma_create(uintptr_t vm_start, uintptr_t vm_end, uint32_t vm_flags) {
ffffffffc020391a:	e822                	sd	s0,16(sp)
ffffffffc020391c:	e426                	sd	s1,8(sp)
ffffffffc020391e:	ec06                	sd	ra,24(sp)
ffffffffc0203920:	84ae                	mv	s1,a1
ffffffffc0203922:	8432                	mv	s0,a2
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
ffffffffc0203924:	f3dfd0ef          	jal	ra,ffffffffc0201860 <kmalloc>
    if (vma != NULL) {
ffffffffc0203928:	c509                	beqz	a0,ffffffffc0203932 <vma_create+0x22>
        vma->vm_start = vm_start;
ffffffffc020392a:	01253423          	sd	s2,8(a0)
        vma->vm_end = vm_end;
ffffffffc020392e:	e904                	sd	s1,16(a0)
        vma->vm_flags = vm_flags;
ffffffffc0203930:	cd00                	sw	s0,24(a0)
}
ffffffffc0203932:	60e2                	ld	ra,24(sp)
ffffffffc0203934:	6442                	ld	s0,16(sp)
ffffffffc0203936:	64a2                	ld	s1,8(sp)
ffffffffc0203938:	6902                	ld	s2,0(sp)
ffffffffc020393a:	6105                	addi	sp,sp,32
ffffffffc020393c:	8082                	ret

ffffffffc020393e <find_vma>:
find_vma(struct mm_struct *mm, uintptr_t addr) {
ffffffffc020393e:	86aa                	mv	a3,a0
    if (mm != NULL) {
ffffffffc0203940:	c505                	beqz	a0,ffffffffc0203968 <find_vma+0x2a>
        vma = mm->mmap_cache;
ffffffffc0203942:	6908                	ld	a0,16(a0)
        if (!(vma != NULL && vma->vm_start <= addr && vma->vm_end > addr)) {
ffffffffc0203944:	c501                	beqz	a0,ffffffffc020394c <find_vma+0xe>
ffffffffc0203946:	651c                	ld	a5,8(a0)
ffffffffc0203948:	02f5f263          	bgeu	a1,a5,ffffffffc020396c <find_vma+0x2e>
    return listelm->next;
ffffffffc020394c:	669c                	ld	a5,8(a3)
                while ((le = list_next(le)) != list) {
ffffffffc020394e:	00f68d63          	beq	a3,a5,ffffffffc0203968 <find_vma+0x2a>
                    if (vma->vm_start<=addr && addr < vma->vm_end) {
ffffffffc0203952:	fe87b703          	ld	a4,-24(a5)
ffffffffc0203956:	00e5e663          	bltu	a1,a4,ffffffffc0203962 <find_vma+0x24>
ffffffffc020395a:	ff07b703          	ld	a4,-16(a5)
ffffffffc020395e:	00e5ec63          	bltu	a1,a4,ffffffffc0203976 <find_vma+0x38>
ffffffffc0203962:	679c                	ld	a5,8(a5)
                while ((le = list_next(le)) != list) {
ffffffffc0203964:	fef697e3          	bne	a3,a5,ffffffffc0203952 <find_vma+0x14>
    struct vma_struct *vma = NULL;
ffffffffc0203968:	4501                	li	a0,0
}
ffffffffc020396a:	8082                	ret
        if (!(vma != NULL && vma->vm_start <= addr && vma->vm_end > addr)) {
ffffffffc020396c:	691c                	ld	a5,16(a0)
ffffffffc020396e:	fcf5ffe3          	bgeu	a1,a5,ffffffffc020394c <find_vma+0xe>
            mm->mmap_cache = vma;
ffffffffc0203972:	ea88                	sd	a0,16(a3)
ffffffffc0203974:	8082                	ret
                    vma = le2vma(le, list_link);
ffffffffc0203976:	fe078513          	addi	a0,a5,-32
            mm->mmap_cache = vma;
ffffffffc020397a:	ea88                	sd	a0,16(a3)
ffffffffc020397c:	8082                	ret

ffffffffc020397e <insert_vma_struct>:


// insert_vma_struct -insert vma in mm's list link
void
insert_vma_struct(struct mm_struct *mm, struct vma_struct *vma) {
    assert(vma->vm_start < vma->vm_end);
ffffffffc020397e:	6590                	ld	a2,8(a1)
ffffffffc0203980:	0105b803          	ld	a6,16(a1) # 1010 <kern_entry-0xffffffffc01feff0>
insert_vma_struct(struct mm_struct *mm, struct vma_struct *vma) {
ffffffffc0203984:	1141                	addi	sp,sp,-16
ffffffffc0203986:	e406                	sd	ra,8(sp)
ffffffffc0203988:	87aa                	mv	a5,a0
    assert(vma->vm_start < vma->vm_end);
ffffffffc020398a:	01066763          	bltu	a2,a6,ffffffffc0203998 <insert_vma_struct+0x1a>
ffffffffc020398e:	a085                	j	ffffffffc02039ee <insert_vma_struct+0x70>
    list_entry_t *le_prev = list, *le_next;

        list_entry_t *le = list;
        while ((le = list_next(le)) != list) {
            struct vma_struct *mmap_prev = le2vma(le, list_link);
            if (mmap_prev->vm_start > vma->vm_start) {
ffffffffc0203990:	fe87b703          	ld	a4,-24(a5)
ffffffffc0203994:	04e66863          	bltu	a2,a4,ffffffffc02039e4 <insert_vma_struct+0x66>
ffffffffc0203998:	86be                	mv	a3,a5
ffffffffc020399a:	679c                	ld	a5,8(a5)
        while ((le = list_next(le)) != list) {
ffffffffc020399c:	fef51ae3          	bne	a0,a5,ffffffffc0203990 <insert_vma_struct+0x12>
        }

    le_next = list_next(le_prev);

    /* check overlap */
    if (le_prev != list) {
ffffffffc02039a0:	02a68463          	beq	a3,a0,ffffffffc02039c8 <insert_vma_struct+0x4a>
        check_vma_overlap(le2vma(le_prev, list_link), vma);
ffffffffc02039a4:	ff06b703          	ld	a4,-16(a3)
    assert(prev->vm_start < prev->vm_end);
ffffffffc02039a8:	fe86b883          	ld	a7,-24(a3)
ffffffffc02039ac:	08e8f163          	bgeu	a7,a4,ffffffffc0203a2e <insert_vma_struct+0xb0>
    assert(prev->vm_end <= next->vm_start);
ffffffffc02039b0:	04e66f63          	bltu	a2,a4,ffffffffc0203a0e <insert_vma_struct+0x90>
    }
    if (le_next != list) {
ffffffffc02039b4:	00f50a63          	beq	a0,a5,ffffffffc02039c8 <insert_vma_struct+0x4a>
            if (mmap_prev->vm_start > vma->vm_start) {
ffffffffc02039b8:	fe87b703          	ld	a4,-24(a5)
    assert(prev->vm_end <= next->vm_start);
ffffffffc02039bc:	05076963          	bltu	a4,a6,ffffffffc0203a0e <insert_vma_struct+0x90>
    assert(next->vm_start < next->vm_end);
ffffffffc02039c0:	ff07b603          	ld	a2,-16(a5)
ffffffffc02039c4:	02c77363          	bgeu	a4,a2,ffffffffc02039ea <insert_vma_struct+0x6c>
    }

    vma->vm_mm = mm;
    list_add_after(le_prev, &(vma->list_link));

    mm->map_count ++;
ffffffffc02039c8:	5118                	lw	a4,32(a0)
    vma->vm_mm = mm;
ffffffffc02039ca:	e188                	sd	a0,0(a1)
    list_add_after(le_prev, &(vma->list_link));
ffffffffc02039cc:	02058613          	addi	a2,a1,32
    prev->next = next->prev = elm;
ffffffffc02039d0:	e390                	sd	a2,0(a5)
ffffffffc02039d2:	e690                	sd	a2,8(a3)
}
ffffffffc02039d4:	60a2                	ld	ra,8(sp)
    elm->next = next;
ffffffffc02039d6:	f59c                	sd	a5,40(a1)
    elm->prev = prev;
ffffffffc02039d8:	f194                	sd	a3,32(a1)
    mm->map_count ++;
ffffffffc02039da:	0017079b          	addiw	a5,a4,1
ffffffffc02039de:	d11c                	sw	a5,32(a0)
}
ffffffffc02039e0:	0141                	addi	sp,sp,16
ffffffffc02039e2:	8082                	ret
    if (le_prev != list) {
ffffffffc02039e4:	fca690e3          	bne	a3,a0,ffffffffc02039a4 <insert_vma_struct+0x26>
ffffffffc02039e8:	bfd1                	j	ffffffffc02039bc <insert_vma_struct+0x3e>
ffffffffc02039ea:	ebbff0ef          	jal	ra,ffffffffc02038a4 <check_vma_overlap.part.0>
    assert(vma->vm_start < vma->vm_end);
ffffffffc02039ee:	00003697          	auipc	a3,0x3
ffffffffc02039f2:	a1268693          	addi	a3,a3,-1518 # ffffffffc0206400 <default_pmm_manager+0xbe8>
ffffffffc02039f6:	00002617          	auipc	a2,0x2
ffffffffc02039fa:	a7260613          	addi	a2,a2,-1422 # ffffffffc0205468 <commands+0x738>
ffffffffc02039fe:	08500593          	li	a1,133
ffffffffc0203a02:	00003517          	auipc	a0,0x3
ffffffffc0203a06:	9ee50513          	addi	a0,a0,-1554 # ffffffffc02063f0 <default_pmm_manager+0xbd8>
ffffffffc0203a0a:	a3dfc0ef          	jal	ra,ffffffffc0200446 <__panic>
    assert(prev->vm_end <= next->vm_start);
ffffffffc0203a0e:	00003697          	auipc	a3,0x3
ffffffffc0203a12:	a3268693          	addi	a3,a3,-1486 # ffffffffc0206440 <default_pmm_manager+0xc28>
ffffffffc0203a16:	00002617          	auipc	a2,0x2
ffffffffc0203a1a:	a5260613          	addi	a2,a2,-1454 # ffffffffc0205468 <commands+0x738>
ffffffffc0203a1e:	07d00593          	li	a1,125
ffffffffc0203a22:	00003517          	auipc	a0,0x3
ffffffffc0203a26:	9ce50513          	addi	a0,a0,-1586 # ffffffffc02063f0 <default_pmm_manager+0xbd8>
ffffffffc0203a2a:	a1dfc0ef          	jal	ra,ffffffffc0200446 <__panic>
    assert(prev->vm_start < prev->vm_end);
ffffffffc0203a2e:	00003697          	auipc	a3,0x3
ffffffffc0203a32:	9f268693          	addi	a3,a3,-1550 # ffffffffc0206420 <default_pmm_manager+0xc08>
ffffffffc0203a36:	00002617          	auipc	a2,0x2
ffffffffc0203a3a:	a3260613          	addi	a2,a2,-1486 # ffffffffc0205468 <commands+0x738>
ffffffffc0203a3e:	07c00593          	li	a1,124
ffffffffc0203a42:	00003517          	auipc	a0,0x3
ffffffffc0203a46:	9ae50513          	addi	a0,a0,-1618 # ffffffffc02063f0 <default_pmm_manager+0xbd8>
ffffffffc0203a4a:	9fdfc0ef          	jal	ra,ffffffffc0200446 <__panic>

ffffffffc0203a4e <mm_destroy>:

// mm_destroy - free mm and mm internal fields
void
mm_destroy(struct mm_struct *mm) {
ffffffffc0203a4e:	1141                	addi	sp,sp,-16
ffffffffc0203a50:	e022                	sd	s0,0(sp)
ffffffffc0203a52:	842a                	mv	s0,a0
    return listelm->next;
ffffffffc0203a54:	6508                	ld	a0,8(a0)
ffffffffc0203a56:	e406                	sd	ra,8(sp)

    list_entry_t *list = &(mm->mmap_list), *le;
    while ((le = list_next(list)) != list) {
ffffffffc0203a58:	00a40c63          	beq	s0,a0,ffffffffc0203a70 <mm_destroy+0x22>
    __list_del(listelm->prev, listelm->next);
ffffffffc0203a5c:	6118                	ld	a4,0(a0)
ffffffffc0203a5e:	651c                	ld	a5,8(a0)
        list_del(le);
        kfree(le2vma(le, list_link));  //kfree vma        
ffffffffc0203a60:	1501                	addi	a0,a0,-32
    prev->next = next;
ffffffffc0203a62:	e71c                	sd	a5,8(a4)
    next->prev = prev;
ffffffffc0203a64:	e398                	sd	a4,0(a5)
ffffffffc0203a66:	eabfd0ef          	jal	ra,ffffffffc0201910 <kfree>
    return listelm->next;
ffffffffc0203a6a:	6408                	ld	a0,8(s0)
    while ((le = list_next(list)) != list) {
ffffffffc0203a6c:	fea418e3          	bne	s0,a0,ffffffffc0203a5c <mm_destroy+0xe>
    }
    kfree(mm); //kfree mm
ffffffffc0203a70:	8522                	mv	a0,s0
    mm=NULL;
}
ffffffffc0203a72:	6402                	ld	s0,0(sp)
ffffffffc0203a74:	60a2                	ld	ra,8(sp)
ffffffffc0203a76:	0141                	addi	sp,sp,16
    kfree(mm); //kfree mm
ffffffffc0203a78:	e99fd06f          	j	ffffffffc0201910 <kfree>

ffffffffc0203a7c <vmm_init>:

// vmm_init - initialize virtual memory management
//          - now just call check_vmm to check correctness of vmm
void
vmm_init(void) {
ffffffffc0203a7c:	7139                	addi	sp,sp,-64
    struct mm_struct *mm = kmalloc(sizeof(struct mm_struct));
ffffffffc0203a7e:	03000513          	li	a0,48
vmm_init(void) {
ffffffffc0203a82:	fc06                	sd	ra,56(sp)
ffffffffc0203a84:	f822                	sd	s0,48(sp)
ffffffffc0203a86:	f426                	sd	s1,40(sp)
ffffffffc0203a88:	f04a                	sd	s2,32(sp)
ffffffffc0203a8a:	ec4e                	sd	s3,24(sp)
ffffffffc0203a8c:	e852                	sd	s4,16(sp)
ffffffffc0203a8e:	e456                	sd	s5,8(sp)
    struct mm_struct *mm = kmalloc(sizeof(struct mm_struct));
ffffffffc0203a90:	dd1fd0ef          	jal	ra,ffffffffc0201860 <kmalloc>
    if (mm != NULL) {
ffffffffc0203a94:	5a050d63          	beqz	a0,ffffffffc020404e <vmm_init+0x5d2>
    elm->prev = elm->next = elm;
ffffffffc0203a98:	e508                	sd	a0,8(a0)
ffffffffc0203a9a:	e108                	sd	a0,0(a0)
        mm->mmap_cache = NULL;
ffffffffc0203a9c:	00053823          	sd	zero,16(a0)
        mm->pgdir = NULL;
ffffffffc0203aa0:	00053c23          	sd	zero,24(a0)
        mm->map_count = 0;
ffffffffc0203aa4:	02052023          	sw	zero,32(a0)
        if (swap_init_ok) swap_init_mm(mm);
ffffffffc0203aa8:	00012797          	auipc	a5,0x12
ffffffffc0203aac:	ae87a783          	lw	a5,-1304(a5) # ffffffffc0215590 <swap_init_ok>
ffffffffc0203ab0:	84aa                	mv	s1,a0
ffffffffc0203ab2:	e7b9                	bnez	a5,ffffffffc0203b00 <vmm_init+0x84>
        else mm->sm_priv = NULL;
ffffffffc0203ab4:	02053423          	sd	zero,40(a0)
vmm_init(void) {
ffffffffc0203ab8:	03200413          	li	s0,50
ffffffffc0203abc:	a811                	j	ffffffffc0203ad0 <vmm_init+0x54>
        vma->vm_start = vm_start;
ffffffffc0203abe:	e500                	sd	s0,8(a0)
        vma->vm_end = vm_end;
ffffffffc0203ac0:	e91c                	sd	a5,16(a0)
        vma->vm_flags = vm_flags;
ffffffffc0203ac2:	00052c23          	sw	zero,24(a0)
    assert(mm != NULL);

    int step1 = 10, step2 = step1 * 10;

    int i;
    for (i = step1; i >= 1; i --) {
ffffffffc0203ac6:	146d                	addi	s0,s0,-5
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
        assert(vma != NULL);
        insert_vma_struct(mm, vma);
ffffffffc0203ac8:	8526                	mv	a0,s1
ffffffffc0203aca:	eb5ff0ef          	jal	ra,ffffffffc020397e <insert_vma_struct>
    for (i = step1; i >= 1; i --) {
ffffffffc0203ace:	cc05                	beqz	s0,ffffffffc0203b06 <vmm_init+0x8a>
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
ffffffffc0203ad0:	03000513          	li	a0,48
ffffffffc0203ad4:	d8dfd0ef          	jal	ra,ffffffffc0201860 <kmalloc>
ffffffffc0203ad8:	85aa                	mv	a1,a0
ffffffffc0203ada:	00240793          	addi	a5,s0,2
    if (vma != NULL) {
ffffffffc0203ade:	f165                	bnez	a0,ffffffffc0203abe <vmm_init+0x42>
        assert(vma != NULL);
ffffffffc0203ae0:	00002697          	auipc	a3,0x2
ffffffffc0203ae4:	48068693          	addi	a3,a3,1152 # ffffffffc0205f60 <default_pmm_manager+0x748>
ffffffffc0203ae8:	00002617          	auipc	a2,0x2
ffffffffc0203aec:	98060613          	addi	a2,a2,-1664 # ffffffffc0205468 <commands+0x738>
ffffffffc0203af0:	0c900593          	li	a1,201
ffffffffc0203af4:	00003517          	auipc	a0,0x3
ffffffffc0203af8:	8fc50513          	addi	a0,a0,-1796 # ffffffffc02063f0 <default_pmm_manager+0xbd8>
ffffffffc0203afc:	94bfc0ef          	jal	ra,ffffffffc0200446 <__panic>
        if (swap_init_ok) swap_init_mm(mm);
ffffffffc0203b00:	88bff0ef          	jal	ra,ffffffffc020338a <swap_init_mm>
ffffffffc0203b04:	bf55                	j	ffffffffc0203ab8 <vmm_init+0x3c>
ffffffffc0203b06:	03700413          	li	s0,55
    }

    for (i = step1 + 1; i <= step2; i ++) {
ffffffffc0203b0a:	1f900913          	li	s2,505
ffffffffc0203b0e:	a819                	j	ffffffffc0203b24 <vmm_init+0xa8>
        vma->vm_start = vm_start;
ffffffffc0203b10:	e500                	sd	s0,8(a0)
        vma->vm_end = vm_end;
ffffffffc0203b12:	e91c                	sd	a5,16(a0)
        vma->vm_flags = vm_flags;
ffffffffc0203b14:	00052c23          	sw	zero,24(a0)
    for (i = step1 + 1; i <= step2; i ++) {
ffffffffc0203b18:	0415                	addi	s0,s0,5
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
        assert(vma != NULL);
        insert_vma_struct(mm, vma);
ffffffffc0203b1a:	8526                	mv	a0,s1
ffffffffc0203b1c:	e63ff0ef          	jal	ra,ffffffffc020397e <insert_vma_struct>
    for (i = step1 + 1; i <= step2; i ++) {
ffffffffc0203b20:	03240a63          	beq	s0,s2,ffffffffc0203b54 <vmm_init+0xd8>
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
ffffffffc0203b24:	03000513          	li	a0,48
ffffffffc0203b28:	d39fd0ef          	jal	ra,ffffffffc0201860 <kmalloc>
ffffffffc0203b2c:	85aa                	mv	a1,a0
ffffffffc0203b2e:	00240793          	addi	a5,s0,2
    if (vma != NULL) {
ffffffffc0203b32:	fd79                	bnez	a0,ffffffffc0203b10 <vmm_init+0x94>
        assert(vma != NULL);
ffffffffc0203b34:	00002697          	auipc	a3,0x2
ffffffffc0203b38:	42c68693          	addi	a3,a3,1068 # ffffffffc0205f60 <default_pmm_manager+0x748>
ffffffffc0203b3c:	00002617          	auipc	a2,0x2
ffffffffc0203b40:	92c60613          	addi	a2,a2,-1748 # ffffffffc0205468 <commands+0x738>
ffffffffc0203b44:	0cf00593          	li	a1,207
ffffffffc0203b48:	00003517          	auipc	a0,0x3
ffffffffc0203b4c:	8a850513          	addi	a0,a0,-1880 # ffffffffc02063f0 <default_pmm_manager+0xbd8>
ffffffffc0203b50:	8f7fc0ef          	jal	ra,ffffffffc0200446 <__panic>
    return listelm->next;
ffffffffc0203b54:	649c                	ld	a5,8(s1)
ffffffffc0203b56:	471d                	li	a4,7
    }

    list_entry_t *le = list_next(&(mm->mmap_list));

    for (i = 1; i <= step2; i ++) {
ffffffffc0203b58:	1fb00593          	li	a1,507
        assert(le != &(mm->mmap_list));
ffffffffc0203b5c:	32f48d63          	beq	s1,a5,ffffffffc0203e96 <vmm_init+0x41a>
        struct vma_struct *mmap = le2vma(le, list_link);
        assert(mmap->vm_start == i * 5 && mmap->vm_end == i * 5 + 2);
ffffffffc0203b60:	fe87b683          	ld	a3,-24(a5)
ffffffffc0203b64:	ffe70613          	addi	a2,a4,-2
ffffffffc0203b68:	2cd61763          	bne	a2,a3,ffffffffc0203e36 <vmm_init+0x3ba>
ffffffffc0203b6c:	ff07b683          	ld	a3,-16(a5)
ffffffffc0203b70:	2ce69363          	bne	a3,a4,ffffffffc0203e36 <vmm_init+0x3ba>
    for (i = 1; i <= step2; i ++) {
ffffffffc0203b74:	0715                	addi	a4,a4,5
ffffffffc0203b76:	679c                	ld	a5,8(a5)
ffffffffc0203b78:	feb712e3          	bne	a4,a1,ffffffffc0203b5c <vmm_init+0xe0>
ffffffffc0203b7c:	4a1d                	li	s4,7
ffffffffc0203b7e:	4415                	li	s0,5
        le = list_next(le);
    }

    for (i = 5; i <= 5 * step2; i +=5) {
ffffffffc0203b80:	1f900a93          	li	s5,505
        struct vma_struct *vma1 = find_vma(mm, i);
ffffffffc0203b84:	85a2                	mv	a1,s0
ffffffffc0203b86:	8526                	mv	a0,s1
ffffffffc0203b88:	db7ff0ef          	jal	ra,ffffffffc020393e <find_vma>
ffffffffc0203b8c:	892a                	mv	s2,a0
        assert(vma1 != NULL);
ffffffffc0203b8e:	36050463          	beqz	a0,ffffffffc0203ef6 <vmm_init+0x47a>
        struct vma_struct *vma2 = find_vma(mm, i+1);
ffffffffc0203b92:	00140593          	addi	a1,s0,1
ffffffffc0203b96:	8526                	mv	a0,s1
ffffffffc0203b98:	da7ff0ef          	jal	ra,ffffffffc020393e <find_vma>
ffffffffc0203b9c:	89aa                	mv	s3,a0
        assert(vma2 != NULL);
ffffffffc0203b9e:	36050c63          	beqz	a0,ffffffffc0203f16 <vmm_init+0x49a>
        struct vma_struct *vma3 = find_vma(mm, i+2);
ffffffffc0203ba2:	85d2                	mv	a1,s4
ffffffffc0203ba4:	8526                	mv	a0,s1
ffffffffc0203ba6:	d99ff0ef          	jal	ra,ffffffffc020393e <find_vma>
        assert(vma3 == NULL);
ffffffffc0203baa:	38051663          	bnez	a0,ffffffffc0203f36 <vmm_init+0x4ba>
        struct vma_struct *vma4 = find_vma(mm, i+3);
ffffffffc0203bae:	00340593          	addi	a1,s0,3
ffffffffc0203bb2:	8526                	mv	a0,s1
ffffffffc0203bb4:	d8bff0ef          	jal	ra,ffffffffc020393e <find_vma>
        assert(vma4 == NULL);
ffffffffc0203bb8:	2e051f63          	bnez	a0,ffffffffc0203eb6 <vmm_init+0x43a>
        struct vma_struct *vma5 = find_vma(mm, i+4);
ffffffffc0203bbc:	00440593          	addi	a1,s0,4
ffffffffc0203bc0:	8526                	mv	a0,s1
ffffffffc0203bc2:	d7dff0ef          	jal	ra,ffffffffc020393e <find_vma>
        assert(vma5 == NULL);
ffffffffc0203bc6:	30051863          	bnez	a0,ffffffffc0203ed6 <vmm_init+0x45a>

        assert(vma1->vm_start == i  && vma1->vm_end == i  + 2);
ffffffffc0203bca:	00893783          	ld	a5,8(s2)
ffffffffc0203bce:	28879463          	bne	a5,s0,ffffffffc0203e56 <vmm_init+0x3da>
ffffffffc0203bd2:	01093783          	ld	a5,16(s2)
ffffffffc0203bd6:	29479063          	bne	a5,s4,ffffffffc0203e56 <vmm_init+0x3da>
        assert(vma2->vm_start == i  && vma2->vm_end == i  + 2);
ffffffffc0203bda:	0089b783          	ld	a5,8(s3)
ffffffffc0203bde:	28879c63          	bne	a5,s0,ffffffffc0203e76 <vmm_init+0x3fa>
ffffffffc0203be2:	0109b783          	ld	a5,16(s3)
ffffffffc0203be6:	29479863          	bne	a5,s4,ffffffffc0203e76 <vmm_init+0x3fa>
    for (i = 5; i <= 5 * step2; i +=5) {
ffffffffc0203bea:	0415                	addi	s0,s0,5
ffffffffc0203bec:	0a15                	addi	s4,s4,5
ffffffffc0203bee:	f9541be3          	bne	s0,s5,ffffffffc0203b84 <vmm_init+0x108>
ffffffffc0203bf2:	4411                	li	s0,4
    }

    for (i =4; i>=0; i--) {
ffffffffc0203bf4:	597d                	li	s2,-1
        struct vma_struct *vma_below_5= find_vma(mm,i);
ffffffffc0203bf6:	85a2                	mv	a1,s0
ffffffffc0203bf8:	8526                	mv	a0,s1
ffffffffc0203bfa:	d45ff0ef          	jal	ra,ffffffffc020393e <find_vma>
ffffffffc0203bfe:	0004059b          	sext.w	a1,s0
        if (vma_below_5 != NULL ) {
ffffffffc0203c02:	c90d                	beqz	a0,ffffffffc0203c34 <vmm_init+0x1b8>
           cprintf("vma_below_5: i %x, start %x, end %x\n",i, vma_below_5->vm_start, vma_below_5->vm_end); 
ffffffffc0203c04:	6914                	ld	a3,16(a0)
ffffffffc0203c06:	6510                	ld	a2,8(a0)
ffffffffc0203c08:	00003517          	auipc	a0,0x3
ffffffffc0203c0c:	95850513          	addi	a0,a0,-1704 # ffffffffc0206560 <default_pmm_manager+0xd48>
ffffffffc0203c10:	d70fc0ef          	jal	ra,ffffffffc0200180 <cprintf>
        }
        assert(vma_below_5 == NULL);
ffffffffc0203c14:	00003697          	auipc	a3,0x3
ffffffffc0203c18:	97468693          	addi	a3,a3,-1676 # ffffffffc0206588 <default_pmm_manager+0xd70>
ffffffffc0203c1c:	00002617          	auipc	a2,0x2
ffffffffc0203c20:	84c60613          	addi	a2,a2,-1972 # ffffffffc0205468 <commands+0x738>
ffffffffc0203c24:	0f100593          	li	a1,241
ffffffffc0203c28:	00002517          	auipc	a0,0x2
ffffffffc0203c2c:	7c850513          	addi	a0,a0,1992 # ffffffffc02063f0 <default_pmm_manager+0xbd8>
ffffffffc0203c30:	817fc0ef          	jal	ra,ffffffffc0200446 <__panic>
    for (i =4; i>=0; i--) {
ffffffffc0203c34:	147d                	addi	s0,s0,-1
ffffffffc0203c36:	fd2410e3          	bne	s0,s2,ffffffffc0203bf6 <vmm_init+0x17a>
ffffffffc0203c3a:	a801                	j	ffffffffc0203c4a <vmm_init+0x1ce>
    __list_del(listelm->prev, listelm->next);
ffffffffc0203c3c:	6118                	ld	a4,0(a0)
ffffffffc0203c3e:	651c                	ld	a5,8(a0)
        kfree(le2vma(le, list_link));  //kfree vma        
ffffffffc0203c40:	1501                	addi	a0,a0,-32
    prev->next = next;
ffffffffc0203c42:	e71c                	sd	a5,8(a4)
    next->prev = prev;
ffffffffc0203c44:	e398                	sd	a4,0(a5)
ffffffffc0203c46:	ccbfd0ef          	jal	ra,ffffffffc0201910 <kfree>
    return listelm->next;
ffffffffc0203c4a:	6488                	ld	a0,8(s1)
    while ((le = list_next(list)) != list) {
ffffffffc0203c4c:	fea498e3          	bne	s1,a0,ffffffffc0203c3c <vmm_init+0x1c0>
    kfree(mm); //kfree mm
ffffffffc0203c50:	8526                	mv	a0,s1
ffffffffc0203c52:	cbffd0ef          	jal	ra,ffffffffc0201910 <kfree>
    }

    mm_destroy(mm);

    cprintf("check_vma_struct() succeeded!\n");
ffffffffc0203c56:	00003517          	auipc	a0,0x3
ffffffffc0203c5a:	94a50513          	addi	a0,a0,-1718 # ffffffffc02065a0 <default_pmm_manager+0xd88>
ffffffffc0203c5e:	d22fc0ef          	jal	ra,ffffffffc0200180 <cprintf>
struct mm_struct *check_mm_struct;

// check_pgfault - check correctness of pgfault handler
static void
check_pgfault(void) {
    size_t nr_free_pages_store = nr_free_pages();
ffffffffc0203c62:	eb5fd0ef          	jal	ra,ffffffffc0201b16 <nr_free_pages>
ffffffffc0203c66:	84aa                	mv	s1,a0
    struct mm_struct *mm = kmalloc(sizeof(struct mm_struct));
ffffffffc0203c68:	03000513          	li	a0,48
ffffffffc0203c6c:	bf5fd0ef          	jal	ra,ffffffffc0201860 <kmalloc>
ffffffffc0203c70:	842a                	mv	s0,a0
    if (mm != NULL) {
ffffffffc0203c72:	2e050263          	beqz	a0,ffffffffc0203f56 <vmm_init+0x4da>
        if (swap_init_ok) swap_init_mm(mm);
ffffffffc0203c76:	00012797          	auipc	a5,0x12
ffffffffc0203c7a:	91a7a783          	lw	a5,-1766(a5) # ffffffffc0215590 <swap_init_ok>
    elm->prev = elm->next = elm;
ffffffffc0203c7e:	e508                	sd	a0,8(a0)
ffffffffc0203c80:	e108                	sd	a0,0(a0)
        mm->mmap_cache = NULL;
ffffffffc0203c82:	00053823          	sd	zero,16(a0)
        mm->pgdir = NULL;
ffffffffc0203c86:	00053c23          	sd	zero,24(a0)
        mm->map_count = 0;
ffffffffc0203c8a:	02052023          	sw	zero,32(a0)
        if (swap_init_ok) swap_init_mm(mm);
ffffffffc0203c8e:	1a079163          	bnez	a5,ffffffffc0203e30 <vmm_init+0x3b4>
        else mm->sm_priv = NULL;
ffffffffc0203c92:	02053423          	sd	zero,40(a0)

    check_mm_struct = mm_create();
    assert(check_mm_struct != NULL);

    struct mm_struct *mm = check_mm_struct;
    pde_t *pgdir = mm->pgdir = boot_pgdir;
ffffffffc0203c96:	00012917          	auipc	s2,0x12
ffffffffc0203c9a:	8c293903          	ld	s2,-1854(s2) # ffffffffc0215558 <boot_pgdir>
    assert(pgdir[0] == 0);
ffffffffc0203c9e:	00093783          	ld	a5,0(s2)
    check_mm_struct = mm_create();
ffffffffc0203ca2:	00012717          	auipc	a4,0x12
ffffffffc0203ca6:	8e873b23          	sd	s0,-1802(a4) # ffffffffc0215598 <check_mm_struct>
    pde_t *pgdir = mm->pgdir = boot_pgdir;
ffffffffc0203caa:	01243c23          	sd	s2,24(s0)
    assert(pgdir[0] == 0);
ffffffffc0203cae:	38079063          	bnez	a5,ffffffffc020402e <vmm_init+0x5b2>
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
ffffffffc0203cb2:	03000513          	li	a0,48
ffffffffc0203cb6:	babfd0ef          	jal	ra,ffffffffc0201860 <kmalloc>
ffffffffc0203cba:	89aa                	mv	s3,a0
    if (vma != NULL) {
ffffffffc0203cbc:	2c050163          	beqz	a0,ffffffffc0203f7e <vmm_init+0x502>
        vma->vm_end = vm_end;
ffffffffc0203cc0:	002007b7          	lui	a5,0x200
ffffffffc0203cc4:	00f9b823          	sd	a5,16(s3)
        vma->vm_flags = vm_flags;
ffffffffc0203cc8:	4789                	li	a5,2

    struct vma_struct *vma = vma_create(0, PTSIZE, VM_WRITE);
    assert(vma != NULL);

    insert_vma_struct(mm, vma);
ffffffffc0203cca:	85aa                	mv	a1,a0
        vma->vm_flags = vm_flags;
ffffffffc0203ccc:	00f9ac23          	sw	a5,24(s3)
    insert_vma_struct(mm, vma);
ffffffffc0203cd0:	8522                	mv	a0,s0
        vma->vm_start = vm_start;
ffffffffc0203cd2:	0009b423          	sd	zero,8(s3)
    insert_vma_struct(mm, vma);
ffffffffc0203cd6:	ca9ff0ef          	jal	ra,ffffffffc020397e <insert_vma_struct>

    uintptr_t addr = 0x100;
    assert(find_vma(mm, addr) == vma);
ffffffffc0203cda:	10000593          	li	a1,256
ffffffffc0203cde:	8522                	mv	a0,s0
ffffffffc0203ce0:	c5fff0ef          	jal	ra,ffffffffc020393e <find_vma>
ffffffffc0203ce4:	10000793          	li	a5,256

    int i, sum = 0;
    for (i = 0; i < 100; i ++) {
ffffffffc0203ce8:	16400713          	li	a4,356
    assert(find_vma(mm, addr) == vma);
ffffffffc0203cec:	2aa99963          	bne	s3,a0,ffffffffc0203f9e <vmm_init+0x522>
        *(char *)(addr + i) = i;
ffffffffc0203cf0:	00f78023          	sb	a5,0(a5) # 200000 <kern_entry-0xffffffffc0000000>
    for (i = 0; i < 100; i ++) {
ffffffffc0203cf4:	0785                	addi	a5,a5,1
ffffffffc0203cf6:	fee79de3          	bne	a5,a4,ffffffffc0203cf0 <vmm_init+0x274>
        sum += i;
ffffffffc0203cfa:	6705                	lui	a4,0x1
ffffffffc0203cfc:	10000793          	li	a5,256
ffffffffc0203d00:	35670713          	addi	a4,a4,854 # 1356 <kern_entry-0xffffffffc01fecaa>
    }
    for (i = 0; i < 100; i ++) {
ffffffffc0203d04:	16400613          	li	a2,356
        sum -= *(char *)(addr + i);
ffffffffc0203d08:	0007c683          	lbu	a3,0(a5)
    for (i = 0; i < 100; i ++) {
ffffffffc0203d0c:	0785                	addi	a5,a5,1
        sum -= *(char *)(addr + i);
ffffffffc0203d0e:	9f15                	subw	a4,a4,a3
    for (i = 0; i < 100; i ++) {
ffffffffc0203d10:	fec79ce3          	bne	a5,a2,ffffffffc0203d08 <vmm_init+0x28c>
    }
    assert(sum == 0);
ffffffffc0203d14:	2a071563          	bnez	a4,ffffffffc0203fbe <vmm_init+0x542>
    return pa2page(PDE_ADDR(pde));
ffffffffc0203d18:	00093783          	ld	a5,0(s2)
    if (PPN(pa) >= npage) {
ffffffffc0203d1c:	00012a97          	auipc	s5,0x12
ffffffffc0203d20:	844a8a93          	addi	s5,s5,-1980 # ffffffffc0215560 <npage>
ffffffffc0203d24:	000ab603          	ld	a2,0(s5)
    return pa2page(PDE_ADDR(pde));
ffffffffc0203d28:	078a                	slli	a5,a5,0x2
ffffffffc0203d2a:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage) {
ffffffffc0203d2c:	2ac7f963          	bgeu	a5,a2,ffffffffc0203fde <vmm_init+0x562>
    return &pages[PPN(pa) - nbase];
ffffffffc0203d30:	00003a17          	auipc	s4,0x3
ffffffffc0203d34:	dc0a3a03          	ld	s4,-576(s4) # ffffffffc0206af0 <nbase>
ffffffffc0203d38:	41478733          	sub	a4,a5,s4
ffffffffc0203d3c:	00371793          	slli	a5,a4,0x3
ffffffffc0203d40:	97ba                	add	a5,a5,a4
ffffffffc0203d42:	078e                	slli	a5,a5,0x3
    return page - pages + nbase;
ffffffffc0203d44:	00003717          	auipc	a4,0x3
ffffffffc0203d48:	da473703          	ld	a4,-604(a4) # ffffffffc0206ae8 <error_string+0x38>
ffffffffc0203d4c:	878d                	srai	a5,a5,0x3
ffffffffc0203d4e:	02e787b3          	mul	a5,a5,a4
ffffffffc0203d52:	97d2                	add	a5,a5,s4
    return KADDR(page2pa(page));
ffffffffc0203d54:	00c79713          	slli	a4,a5,0xc
ffffffffc0203d58:	8331                	srli	a4,a4,0xc
    return page2ppn(page) << PGSHIFT;
ffffffffc0203d5a:	00c79693          	slli	a3,a5,0xc
    return KADDR(page2pa(page));
ffffffffc0203d5e:	28c77c63          	bgeu	a4,a2,ffffffffc0203ff6 <vmm_init+0x57a>
ffffffffc0203d62:	00012997          	auipc	s3,0x12
ffffffffc0203d66:	8169b983          	ld	s3,-2026(s3) # ffffffffc0215578 <va_pa_offset>

    pde_t *pd1=pgdir,*pd0=page2kva(pde2page(pgdir[0]));
    page_remove(pgdir, ROUNDDOWN(addr, PGSIZE));
ffffffffc0203d6a:	4581                	li	a1,0
ffffffffc0203d6c:	854a                	mv	a0,s2
ffffffffc0203d6e:	99b6                	add	s3,s3,a3
ffffffffc0203d70:	830fe0ef          	jal	ra,ffffffffc0201da0 <page_remove>
    return pa2page(PDE_ADDR(pde));
ffffffffc0203d74:	0009b783          	ld	a5,0(s3)
    if (PPN(pa) >= npage) {
ffffffffc0203d78:	000ab703          	ld	a4,0(s5)
    return pa2page(PDE_ADDR(pde));
ffffffffc0203d7c:	078a                	slli	a5,a5,0x2
ffffffffc0203d7e:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage) {
ffffffffc0203d80:	24e7ff63          	bgeu	a5,a4,ffffffffc0203fde <vmm_init+0x562>
    return &pages[PPN(pa) - nbase];
ffffffffc0203d84:	414787b3          	sub	a5,a5,s4
ffffffffc0203d88:	00011997          	auipc	s3,0x11
ffffffffc0203d8c:	7e098993          	addi	s3,s3,2016 # ffffffffc0215568 <pages>
ffffffffc0203d90:	00379713          	slli	a4,a5,0x3
ffffffffc0203d94:	0009b503          	ld	a0,0(s3)
ffffffffc0203d98:	97ba                	add	a5,a5,a4
ffffffffc0203d9a:	078e                	slli	a5,a5,0x3
    free_page(pde2page(pd0[0]));
ffffffffc0203d9c:	953e                	add	a0,a0,a5
ffffffffc0203d9e:	4585                	li	a1,1
ffffffffc0203da0:	d37fd0ef          	jal	ra,ffffffffc0201ad6 <free_pages>
    return pa2page(PDE_ADDR(pde));
ffffffffc0203da4:	00093783          	ld	a5,0(s2)
    if (PPN(pa) >= npage) {
ffffffffc0203da8:	000ab703          	ld	a4,0(s5)
    return pa2page(PDE_ADDR(pde));
ffffffffc0203dac:	078a                	slli	a5,a5,0x2
ffffffffc0203dae:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage) {
ffffffffc0203db0:	22e7f763          	bgeu	a5,a4,ffffffffc0203fde <vmm_init+0x562>
    return &pages[PPN(pa) - nbase];
ffffffffc0203db4:	414787b3          	sub	a5,a5,s4
ffffffffc0203db8:	0009b503          	ld	a0,0(s3)
ffffffffc0203dbc:	00379713          	slli	a4,a5,0x3
ffffffffc0203dc0:	97ba                	add	a5,a5,a4
ffffffffc0203dc2:	078e                	slli	a5,a5,0x3
    free_page(pde2page(pd1[0]));
ffffffffc0203dc4:	4585                	li	a1,1
ffffffffc0203dc6:	953e                	add	a0,a0,a5
ffffffffc0203dc8:	d0ffd0ef          	jal	ra,ffffffffc0201ad6 <free_pages>
    pgdir[0] = 0;
ffffffffc0203dcc:	00093023          	sd	zero,0(s2)
  asm volatile("sfence.vma");
ffffffffc0203dd0:	12000073          	sfence.vma
    return listelm->next;
ffffffffc0203dd4:	6408                	ld	a0,8(s0)
    flush_tlb();

    mm->pgdir = NULL;
ffffffffc0203dd6:	00043c23          	sd	zero,24(s0)
    while ((le = list_next(list)) != list) {
ffffffffc0203dda:	00a40c63          	beq	s0,a0,ffffffffc0203df2 <vmm_init+0x376>
    __list_del(listelm->prev, listelm->next);
ffffffffc0203dde:	6118                	ld	a4,0(a0)
ffffffffc0203de0:	651c                	ld	a5,8(a0)
        kfree(le2vma(le, list_link));  //kfree vma        
ffffffffc0203de2:	1501                	addi	a0,a0,-32
    prev->next = next;
ffffffffc0203de4:	e71c                	sd	a5,8(a4)
    next->prev = prev;
ffffffffc0203de6:	e398                	sd	a4,0(a5)
ffffffffc0203de8:	b29fd0ef          	jal	ra,ffffffffc0201910 <kfree>
    return listelm->next;
ffffffffc0203dec:	6408                	ld	a0,8(s0)
    while ((le = list_next(list)) != list) {
ffffffffc0203dee:	fea418e3          	bne	s0,a0,ffffffffc0203dde <vmm_init+0x362>
    kfree(mm); //kfree mm
ffffffffc0203df2:	8522                	mv	a0,s0
ffffffffc0203df4:	b1dfd0ef          	jal	ra,ffffffffc0201910 <kfree>
    mm_destroy(mm);
    check_mm_struct = NULL;
ffffffffc0203df8:	00011797          	auipc	a5,0x11
ffffffffc0203dfc:	7a07b023          	sd	zero,1952(a5) # ffffffffc0215598 <check_mm_struct>

    assert(nr_free_pages_store == nr_free_pages());
ffffffffc0203e00:	d17fd0ef          	jal	ra,ffffffffc0201b16 <nr_free_pages>
ffffffffc0203e04:	20a49563          	bne	s1,a0,ffffffffc020400e <vmm_init+0x592>

    cprintf("check_pgfault() succeeded!\n");
ffffffffc0203e08:	00003517          	auipc	a0,0x3
ffffffffc0203e0c:	81050513          	addi	a0,a0,-2032 # ffffffffc0206618 <default_pmm_manager+0xe00>
ffffffffc0203e10:	b70fc0ef          	jal	ra,ffffffffc0200180 <cprintf>
}
ffffffffc0203e14:	7442                	ld	s0,48(sp)
ffffffffc0203e16:	70e2                	ld	ra,56(sp)
ffffffffc0203e18:	74a2                	ld	s1,40(sp)
ffffffffc0203e1a:	7902                	ld	s2,32(sp)
ffffffffc0203e1c:	69e2                	ld	s3,24(sp)
ffffffffc0203e1e:	6a42                	ld	s4,16(sp)
ffffffffc0203e20:	6aa2                	ld	s5,8(sp)
    cprintf("check_vmm() succeeded.\n");
ffffffffc0203e22:	00003517          	auipc	a0,0x3
ffffffffc0203e26:	81650513          	addi	a0,a0,-2026 # ffffffffc0206638 <default_pmm_manager+0xe20>
}
ffffffffc0203e2a:	6121                	addi	sp,sp,64
    cprintf("check_vmm() succeeded.\n");
ffffffffc0203e2c:	b54fc06f          	j	ffffffffc0200180 <cprintf>
        if (swap_init_ok) swap_init_mm(mm);
ffffffffc0203e30:	d5aff0ef          	jal	ra,ffffffffc020338a <swap_init_mm>
ffffffffc0203e34:	b58d                	j	ffffffffc0203c96 <vmm_init+0x21a>
        assert(mmap->vm_start == i * 5 && mmap->vm_end == i * 5 + 2);
ffffffffc0203e36:	00002697          	auipc	a3,0x2
ffffffffc0203e3a:	64268693          	addi	a3,a3,1602 # ffffffffc0206478 <default_pmm_manager+0xc60>
ffffffffc0203e3e:	00001617          	auipc	a2,0x1
ffffffffc0203e42:	62a60613          	addi	a2,a2,1578 # ffffffffc0205468 <commands+0x738>
ffffffffc0203e46:	0d800593          	li	a1,216
ffffffffc0203e4a:	00002517          	auipc	a0,0x2
ffffffffc0203e4e:	5a650513          	addi	a0,a0,1446 # ffffffffc02063f0 <default_pmm_manager+0xbd8>
ffffffffc0203e52:	df4fc0ef          	jal	ra,ffffffffc0200446 <__panic>
        assert(vma1->vm_start == i  && vma1->vm_end == i  + 2);
ffffffffc0203e56:	00002697          	auipc	a3,0x2
ffffffffc0203e5a:	6aa68693          	addi	a3,a3,1706 # ffffffffc0206500 <default_pmm_manager+0xce8>
ffffffffc0203e5e:	00001617          	auipc	a2,0x1
ffffffffc0203e62:	60a60613          	addi	a2,a2,1546 # ffffffffc0205468 <commands+0x738>
ffffffffc0203e66:	0e800593          	li	a1,232
ffffffffc0203e6a:	00002517          	auipc	a0,0x2
ffffffffc0203e6e:	58650513          	addi	a0,a0,1414 # ffffffffc02063f0 <default_pmm_manager+0xbd8>
ffffffffc0203e72:	dd4fc0ef          	jal	ra,ffffffffc0200446 <__panic>
        assert(vma2->vm_start == i  && vma2->vm_end == i  + 2);
ffffffffc0203e76:	00002697          	auipc	a3,0x2
ffffffffc0203e7a:	6ba68693          	addi	a3,a3,1722 # ffffffffc0206530 <default_pmm_manager+0xd18>
ffffffffc0203e7e:	00001617          	auipc	a2,0x1
ffffffffc0203e82:	5ea60613          	addi	a2,a2,1514 # ffffffffc0205468 <commands+0x738>
ffffffffc0203e86:	0e900593          	li	a1,233
ffffffffc0203e8a:	00002517          	auipc	a0,0x2
ffffffffc0203e8e:	56650513          	addi	a0,a0,1382 # ffffffffc02063f0 <default_pmm_manager+0xbd8>
ffffffffc0203e92:	db4fc0ef          	jal	ra,ffffffffc0200446 <__panic>
        assert(le != &(mm->mmap_list));
ffffffffc0203e96:	00002697          	auipc	a3,0x2
ffffffffc0203e9a:	5ca68693          	addi	a3,a3,1482 # ffffffffc0206460 <default_pmm_manager+0xc48>
ffffffffc0203e9e:	00001617          	auipc	a2,0x1
ffffffffc0203ea2:	5ca60613          	addi	a2,a2,1482 # ffffffffc0205468 <commands+0x738>
ffffffffc0203ea6:	0d600593          	li	a1,214
ffffffffc0203eaa:	00002517          	auipc	a0,0x2
ffffffffc0203eae:	54650513          	addi	a0,a0,1350 # ffffffffc02063f0 <default_pmm_manager+0xbd8>
ffffffffc0203eb2:	d94fc0ef          	jal	ra,ffffffffc0200446 <__panic>
        assert(vma4 == NULL);
ffffffffc0203eb6:	00002697          	auipc	a3,0x2
ffffffffc0203eba:	62a68693          	addi	a3,a3,1578 # ffffffffc02064e0 <default_pmm_manager+0xcc8>
ffffffffc0203ebe:	00001617          	auipc	a2,0x1
ffffffffc0203ec2:	5aa60613          	addi	a2,a2,1450 # ffffffffc0205468 <commands+0x738>
ffffffffc0203ec6:	0e400593          	li	a1,228
ffffffffc0203eca:	00002517          	auipc	a0,0x2
ffffffffc0203ece:	52650513          	addi	a0,a0,1318 # ffffffffc02063f0 <default_pmm_manager+0xbd8>
ffffffffc0203ed2:	d74fc0ef          	jal	ra,ffffffffc0200446 <__panic>
        assert(vma5 == NULL);
ffffffffc0203ed6:	00002697          	auipc	a3,0x2
ffffffffc0203eda:	61a68693          	addi	a3,a3,1562 # ffffffffc02064f0 <default_pmm_manager+0xcd8>
ffffffffc0203ede:	00001617          	auipc	a2,0x1
ffffffffc0203ee2:	58a60613          	addi	a2,a2,1418 # ffffffffc0205468 <commands+0x738>
ffffffffc0203ee6:	0e600593          	li	a1,230
ffffffffc0203eea:	00002517          	auipc	a0,0x2
ffffffffc0203eee:	50650513          	addi	a0,a0,1286 # ffffffffc02063f0 <default_pmm_manager+0xbd8>
ffffffffc0203ef2:	d54fc0ef          	jal	ra,ffffffffc0200446 <__panic>
        assert(vma1 != NULL);
ffffffffc0203ef6:	00002697          	auipc	a3,0x2
ffffffffc0203efa:	5ba68693          	addi	a3,a3,1466 # ffffffffc02064b0 <default_pmm_manager+0xc98>
ffffffffc0203efe:	00001617          	auipc	a2,0x1
ffffffffc0203f02:	56a60613          	addi	a2,a2,1386 # ffffffffc0205468 <commands+0x738>
ffffffffc0203f06:	0de00593          	li	a1,222
ffffffffc0203f0a:	00002517          	auipc	a0,0x2
ffffffffc0203f0e:	4e650513          	addi	a0,a0,1254 # ffffffffc02063f0 <default_pmm_manager+0xbd8>
ffffffffc0203f12:	d34fc0ef          	jal	ra,ffffffffc0200446 <__panic>
        assert(vma2 != NULL);
ffffffffc0203f16:	00002697          	auipc	a3,0x2
ffffffffc0203f1a:	5aa68693          	addi	a3,a3,1450 # ffffffffc02064c0 <default_pmm_manager+0xca8>
ffffffffc0203f1e:	00001617          	auipc	a2,0x1
ffffffffc0203f22:	54a60613          	addi	a2,a2,1354 # ffffffffc0205468 <commands+0x738>
ffffffffc0203f26:	0e000593          	li	a1,224
ffffffffc0203f2a:	00002517          	auipc	a0,0x2
ffffffffc0203f2e:	4c650513          	addi	a0,a0,1222 # ffffffffc02063f0 <default_pmm_manager+0xbd8>
ffffffffc0203f32:	d14fc0ef          	jal	ra,ffffffffc0200446 <__panic>
        assert(vma3 == NULL);
ffffffffc0203f36:	00002697          	auipc	a3,0x2
ffffffffc0203f3a:	59a68693          	addi	a3,a3,1434 # ffffffffc02064d0 <default_pmm_manager+0xcb8>
ffffffffc0203f3e:	00001617          	auipc	a2,0x1
ffffffffc0203f42:	52a60613          	addi	a2,a2,1322 # ffffffffc0205468 <commands+0x738>
ffffffffc0203f46:	0e200593          	li	a1,226
ffffffffc0203f4a:	00002517          	auipc	a0,0x2
ffffffffc0203f4e:	4a650513          	addi	a0,a0,1190 # ffffffffc02063f0 <default_pmm_manager+0xbd8>
ffffffffc0203f52:	cf4fc0ef          	jal	ra,ffffffffc0200446 <__panic>
    assert(check_mm_struct != NULL);
ffffffffc0203f56:	00002697          	auipc	a3,0x2
ffffffffc0203f5a:	6fa68693          	addi	a3,a3,1786 # ffffffffc0206650 <default_pmm_manager+0xe38>
ffffffffc0203f5e:	00001617          	auipc	a2,0x1
ffffffffc0203f62:	50a60613          	addi	a2,a2,1290 # ffffffffc0205468 <commands+0x738>
ffffffffc0203f66:	10100593          	li	a1,257
ffffffffc0203f6a:	00002517          	auipc	a0,0x2
ffffffffc0203f6e:	48650513          	addi	a0,a0,1158 # ffffffffc02063f0 <default_pmm_manager+0xbd8>
    check_mm_struct = mm_create();
ffffffffc0203f72:	00011797          	auipc	a5,0x11
ffffffffc0203f76:	6207b323          	sd	zero,1574(a5) # ffffffffc0215598 <check_mm_struct>
    assert(check_mm_struct != NULL);
ffffffffc0203f7a:	cccfc0ef          	jal	ra,ffffffffc0200446 <__panic>
    assert(vma != NULL);
ffffffffc0203f7e:	00002697          	auipc	a3,0x2
ffffffffc0203f82:	fe268693          	addi	a3,a3,-30 # ffffffffc0205f60 <default_pmm_manager+0x748>
ffffffffc0203f86:	00001617          	auipc	a2,0x1
ffffffffc0203f8a:	4e260613          	addi	a2,a2,1250 # ffffffffc0205468 <commands+0x738>
ffffffffc0203f8e:	10800593          	li	a1,264
ffffffffc0203f92:	00002517          	auipc	a0,0x2
ffffffffc0203f96:	45e50513          	addi	a0,a0,1118 # ffffffffc02063f0 <default_pmm_manager+0xbd8>
ffffffffc0203f9a:	cacfc0ef          	jal	ra,ffffffffc0200446 <__panic>
    assert(find_vma(mm, addr) == vma);
ffffffffc0203f9e:	00002697          	auipc	a3,0x2
ffffffffc0203fa2:	62268693          	addi	a3,a3,1570 # ffffffffc02065c0 <default_pmm_manager+0xda8>
ffffffffc0203fa6:	00001617          	auipc	a2,0x1
ffffffffc0203faa:	4c260613          	addi	a2,a2,1218 # ffffffffc0205468 <commands+0x738>
ffffffffc0203fae:	10d00593          	li	a1,269
ffffffffc0203fb2:	00002517          	auipc	a0,0x2
ffffffffc0203fb6:	43e50513          	addi	a0,a0,1086 # ffffffffc02063f0 <default_pmm_manager+0xbd8>
ffffffffc0203fba:	c8cfc0ef          	jal	ra,ffffffffc0200446 <__panic>
    assert(sum == 0);
ffffffffc0203fbe:	00002697          	auipc	a3,0x2
ffffffffc0203fc2:	62268693          	addi	a3,a3,1570 # ffffffffc02065e0 <default_pmm_manager+0xdc8>
ffffffffc0203fc6:	00001617          	auipc	a2,0x1
ffffffffc0203fca:	4a260613          	addi	a2,a2,1186 # ffffffffc0205468 <commands+0x738>
ffffffffc0203fce:	11700593          	li	a1,279
ffffffffc0203fd2:	00002517          	auipc	a0,0x2
ffffffffc0203fd6:	41e50513          	addi	a0,a0,1054 # ffffffffc02063f0 <default_pmm_manager+0xbd8>
ffffffffc0203fda:	c6cfc0ef          	jal	ra,ffffffffc0200446 <__panic>
        panic("pa2page called with invalid pa");
ffffffffc0203fde:	00002617          	auipc	a2,0x2
ffffffffc0203fe2:	94260613          	addi	a2,a2,-1726 # ffffffffc0205920 <default_pmm_manager+0x108>
ffffffffc0203fe6:	06200593          	li	a1,98
ffffffffc0203fea:	00002517          	auipc	a0,0x2
ffffffffc0203fee:	88e50513          	addi	a0,a0,-1906 # ffffffffc0205878 <default_pmm_manager+0x60>
ffffffffc0203ff2:	c54fc0ef          	jal	ra,ffffffffc0200446 <__panic>
    return KADDR(page2pa(page));
ffffffffc0203ff6:	00002617          	auipc	a2,0x2
ffffffffc0203ffa:	85a60613          	addi	a2,a2,-1958 # ffffffffc0205850 <default_pmm_manager+0x38>
ffffffffc0203ffe:	06900593          	li	a1,105
ffffffffc0204002:	00002517          	auipc	a0,0x2
ffffffffc0204006:	87650513          	addi	a0,a0,-1930 # ffffffffc0205878 <default_pmm_manager+0x60>
ffffffffc020400a:	c3cfc0ef          	jal	ra,ffffffffc0200446 <__panic>
    assert(nr_free_pages_store == nr_free_pages());
ffffffffc020400e:	00002697          	auipc	a3,0x2
ffffffffc0204012:	5e268693          	addi	a3,a3,1506 # ffffffffc02065f0 <default_pmm_manager+0xdd8>
ffffffffc0204016:	00001617          	auipc	a2,0x1
ffffffffc020401a:	45260613          	addi	a2,a2,1106 # ffffffffc0205468 <commands+0x738>
ffffffffc020401e:	12400593          	li	a1,292
ffffffffc0204022:	00002517          	auipc	a0,0x2
ffffffffc0204026:	3ce50513          	addi	a0,a0,974 # ffffffffc02063f0 <default_pmm_manager+0xbd8>
ffffffffc020402a:	c1cfc0ef          	jal	ra,ffffffffc0200446 <__panic>
    assert(pgdir[0] == 0);
ffffffffc020402e:	00002697          	auipc	a3,0x2
ffffffffc0204032:	f2268693          	addi	a3,a3,-222 # ffffffffc0205f50 <default_pmm_manager+0x738>
ffffffffc0204036:	00001617          	auipc	a2,0x1
ffffffffc020403a:	43260613          	addi	a2,a2,1074 # ffffffffc0205468 <commands+0x738>
ffffffffc020403e:	10500593          	li	a1,261
ffffffffc0204042:	00002517          	auipc	a0,0x2
ffffffffc0204046:	3ae50513          	addi	a0,a0,942 # ffffffffc02063f0 <default_pmm_manager+0xbd8>
ffffffffc020404a:	bfcfc0ef          	jal	ra,ffffffffc0200446 <__panic>
    assert(mm != NULL);
ffffffffc020404e:	00002697          	auipc	a3,0x2
ffffffffc0204052:	eda68693          	addi	a3,a3,-294 # ffffffffc0205f28 <default_pmm_manager+0x710>
ffffffffc0204056:	00001617          	auipc	a2,0x1
ffffffffc020405a:	41260613          	addi	a2,a2,1042 # ffffffffc0205468 <commands+0x738>
ffffffffc020405e:	0c200593          	li	a1,194
ffffffffc0204062:	00002517          	auipc	a0,0x2
ffffffffc0204066:	38e50513          	addi	a0,a0,910 # ffffffffc02063f0 <default_pmm_manager+0xbd8>
ffffffffc020406a:	bdcfc0ef          	jal	ra,ffffffffc0200446 <__panic>

ffffffffc020406e <do_pgfault>:
 *            was a read (0) or write (1).
 *         -- The U/S flag (bit 2) indicates whether the processor was executing at user mode (1)
 *            or supervisor mode (0) at the time of the exception.
 */
int
do_pgfault(struct mm_struct *mm, uint32_t error_code, uintptr_t addr) {
ffffffffc020406e:	1101                	addi	sp,sp,-32
    int ret = -E_INVAL;
    //try to find a vma which include addr
    struct vma_struct *vma = find_vma(mm, addr);
ffffffffc0204070:	85b2                	mv	a1,a2
do_pgfault(struct mm_struct *mm, uint32_t error_code, uintptr_t addr) {
ffffffffc0204072:	e822                	sd	s0,16(sp)
ffffffffc0204074:	e426                	sd	s1,8(sp)
ffffffffc0204076:	ec06                	sd	ra,24(sp)
ffffffffc0204078:	e04a                	sd	s2,0(sp)
ffffffffc020407a:	8432                	mv	s0,a2
ffffffffc020407c:	84aa                	mv	s1,a0
    struct vma_struct *vma = find_vma(mm, addr);
ffffffffc020407e:	8c1ff0ef          	jal	ra,ffffffffc020393e <find_vma>

    pgfault_num++;
ffffffffc0204082:	00011797          	auipc	a5,0x11
ffffffffc0204086:	51e7a783          	lw	a5,1310(a5) # ffffffffc02155a0 <pgfault_num>
ffffffffc020408a:	2785                	addiw	a5,a5,1
ffffffffc020408c:	00011717          	auipc	a4,0x11
ffffffffc0204090:	50f72a23          	sw	a5,1300(a4) # ffffffffc02155a0 <pgfault_num>
    //If the addr is in the range of a mm's vma?
    if (vma == NULL || vma->vm_start > addr) {
ffffffffc0204094:	c931                	beqz	a0,ffffffffc02040e8 <do_pgfault+0x7a>
ffffffffc0204096:	651c                	ld	a5,8(a0)
ffffffffc0204098:	04f46863          	bltu	s0,a5,ffffffffc02040e8 <do_pgfault+0x7a>
     *    (read  an non_existed addr && addr is readable)
     * THEN
     *    continue process
     */
    uint32_t perm = PTE_U;
    if (vma->vm_flags & VM_WRITE) {
ffffffffc020409c:	4d1c                	lw	a5,24(a0)
    uint32_t perm = PTE_U;
ffffffffc020409e:	4941                	li	s2,16
    if (vma->vm_flags & VM_WRITE) {
ffffffffc02040a0:	8b89                	andi	a5,a5,2
ffffffffc02040a2:	e39d                	bnez	a5,ffffffffc02040c8 <do_pgfault+0x5a>
        perm |= READ_WRITE;
    }
    addr = ROUNDDOWN(addr, PGSIZE);
ffffffffc02040a4:	75fd                	lui	a1,0xfffff

    pte_t *ptep=NULL;
  
    // try to find a pte, if pte's PT(Page Table) isn't existed, then create a PT.
    // (notice the 3th parameter '1')
    if ((ptep = get_pte(mm->pgdir, addr, 1)) == NULL) {
ffffffffc02040a6:	6c88                	ld	a0,24(s1)
    addr = ROUNDDOWN(addr, PGSIZE);
ffffffffc02040a8:	8c6d                	and	s0,s0,a1
    if ((ptep = get_pte(mm->pgdir, addr, 1)) == NULL) {
ffffffffc02040aa:	4605                	li	a2,1
ffffffffc02040ac:	85a2                	mv	a1,s0
ffffffffc02040ae:	aa3fd0ef          	jal	ra,ffffffffc0201b50 <get_pte>
ffffffffc02040b2:	cd21                	beqz	a0,ffffffffc020410a <do_pgfault+0x9c>
        cprintf("get_pte in do_pgfault failed\n");
        goto failed;
    }
    if (*ptep == 0) { // if the phy addr isn't exist, then alloc a page & map the phy addr with logical addr
ffffffffc02040b4:	610c                	ld	a1,0(a0)
ffffffffc02040b6:	c999                	beqz	a1,ffffffffc02040cc <do_pgfault+0x5e>
        *    swap_in(mm, addr, &page) : 分配一个内存页，然后根据
        *    PTE中的swap条目的addr，找到磁盘页的地址，将磁盘页的内容读入这个内存页
        *    page_insert ： 建立一个Page的phy addr与线性addr la的映射
        *    swap_map_swappable ： 设置页面可交换
        */
        if (swap_init_ok) {
ffffffffc02040b8:	00011797          	auipc	a5,0x11
ffffffffc02040bc:	4d87a783          	lw	a5,1240(a5) # ffffffffc0215590 <swap_init_ok>
ffffffffc02040c0:	cf8d                	beqz	a5,ffffffffc02040fa <do_pgfault+0x8c>
            //(2) According to the mm,
            //addr AND page, setup the
            //map of phy addr <--->
            //logical addr
            //(3) make the page swappable.
            page->pra_vaddr = addr;
ffffffffc02040c2:	04003023          	sd	zero,64(zero) # 40 <kern_entry-0xffffffffc01fffc0>
ffffffffc02040c6:	9002                	ebreak
        perm |= READ_WRITE;
ffffffffc02040c8:	495d                	li	s2,23
ffffffffc02040ca:	bfe9                	j	ffffffffc02040a4 <do_pgfault+0x36>
        if (pgdir_alloc_page(mm->pgdir, addr, perm) == NULL) {
ffffffffc02040cc:	6c88                	ld	a0,24(s1)
ffffffffc02040ce:	864a                	mv	a2,s2
ffffffffc02040d0:	85a2                	mv	a1,s0
ffffffffc02040d2:	a85fe0ef          	jal	ra,ffffffffc0202b56 <pgdir_alloc_page>
ffffffffc02040d6:	87aa                	mv	a5,a0
            cprintf("no swap_init_ok but ptep is %x, failed\n", *ptep);
            goto failed;
        }
   }

   ret = 0;
ffffffffc02040d8:	4501                	li	a0,0
        if (pgdir_alloc_page(mm->pgdir, addr, perm) == NULL) {
ffffffffc02040da:	c3a1                	beqz	a5,ffffffffc020411a <do_pgfault+0xac>
failed:
    return ret;
}
ffffffffc02040dc:	60e2                	ld	ra,24(sp)
ffffffffc02040de:	6442                	ld	s0,16(sp)
ffffffffc02040e0:	64a2                	ld	s1,8(sp)
ffffffffc02040e2:	6902                	ld	s2,0(sp)
ffffffffc02040e4:	6105                	addi	sp,sp,32
ffffffffc02040e6:	8082                	ret
        cprintf("not valid addr %x, and  can not find it in vma\n", addr);
ffffffffc02040e8:	85a2                	mv	a1,s0
ffffffffc02040ea:	00002517          	auipc	a0,0x2
ffffffffc02040ee:	57e50513          	addi	a0,a0,1406 # ffffffffc0206668 <default_pmm_manager+0xe50>
ffffffffc02040f2:	88efc0ef          	jal	ra,ffffffffc0200180 <cprintf>
    int ret = -E_INVAL;
ffffffffc02040f6:	5575                	li	a0,-3
        goto failed;
ffffffffc02040f8:	b7d5                	j	ffffffffc02040dc <do_pgfault+0x6e>
            cprintf("no swap_init_ok but ptep is %x, failed\n", *ptep);
ffffffffc02040fa:	00002517          	auipc	a0,0x2
ffffffffc02040fe:	5e650513          	addi	a0,a0,1510 # ffffffffc02066e0 <default_pmm_manager+0xec8>
ffffffffc0204102:	87efc0ef          	jal	ra,ffffffffc0200180 <cprintf>
    ret = -E_NO_MEM;
ffffffffc0204106:	5571                	li	a0,-4
            goto failed;
ffffffffc0204108:	bfd1                	j	ffffffffc02040dc <do_pgfault+0x6e>
        cprintf("get_pte in do_pgfault failed\n");
ffffffffc020410a:	00002517          	auipc	a0,0x2
ffffffffc020410e:	58e50513          	addi	a0,a0,1422 # ffffffffc0206698 <default_pmm_manager+0xe80>
ffffffffc0204112:	86efc0ef          	jal	ra,ffffffffc0200180 <cprintf>
    ret = -E_NO_MEM;
ffffffffc0204116:	5571                	li	a0,-4
        goto failed;
ffffffffc0204118:	b7d1                	j	ffffffffc02040dc <do_pgfault+0x6e>
            cprintf("pgdir_alloc_page in do_pgfault failed\n");
ffffffffc020411a:	00002517          	auipc	a0,0x2
ffffffffc020411e:	59e50513          	addi	a0,a0,1438 # ffffffffc02066b8 <default_pmm_manager+0xea0>
ffffffffc0204122:	85efc0ef          	jal	ra,ffffffffc0200180 <cprintf>
    ret = -E_NO_MEM;
ffffffffc0204126:	5571                	li	a0,-4
            goto failed;
ffffffffc0204128:	bf55                	j	ffffffffc02040dc <do_pgfault+0x6e>

ffffffffc020412a <swapfs_init>:
#include <ide.h>
#include <pmm.h>
#include <assert.h>

void
swapfs_init(void) {
ffffffffc020412a:	1141                	addi	sp,sp,-16
    static_assert((PGSIZE % SECTSIZE) == 0);
    if (!ide_device_valid(SWAP_DEV_NO)) {
ffffffffc020412c:	4505                	li	a0,1
swapfs_init(void) {
ffffffffc020412e:	e406                	sd	ra,8(sp)
    if (!ide_device_valid(SWAP_DEV_NO)) {
ffffffffc0204130:	c38fc0ef          	jal	ra,ffffffffc0200568 <ide_device_valid>
ffffffffc0204134:	cd01                	beqz	a0,ffffffffc020414c <swapfs_init+0x22>
        panic("swap fs isn't available.\n");
    }
    max_swap_offset = ide_device_size(SWAP_DEV_NO) / (PGSIZE / SECTSIZE);
ffffffffc0204136:	4505                	li	a0,1
ffffffffc0204138:	c36fc0ef          	jal	ra,ffffffffc020056e <ide_device_size>
}
ffffffffc020413c:	60a2                	ld	ra,8(sp)
    max_swap_offset = ide_device_size(SWAP_DEV_NO) / (PGSIZE / SECTSIZE);
ffffffffc020413e:	810d                	srli	a0,a0,0x3
ffffffffc0204140:	00011797          	auipc	a5,0x11
ffffffffc0204144:	44a7b023          	sd	a0,1088(a5) # ffffffffc0215580 <max_swap_offset>
}
ffffffffc0204148:	0141                	addi	sp,sp,16
ffffffffc020414a:	8082                	ret
        panic("swap fs isn't available.\n");
ffffffffc020414c:	00002617          	auipc	a2,0x2
ffffffffc0204150:	5bc60613          	addi	a2,a2,1468 # ffffffffc0206708 <default_pmm_manager+0xef0>
ffffffffc0204154:	45b5                	li	a1,13
ffffffffc0204156:	00002517          	auipc	a0,0x2
ffffffffc020415a:	5d250513          	addi	a0,a0,1490 # ffffffffc0206728 <default_pmm_manager+0xf10>
ffffffffc020415e:	ae8fc0ef          	jal	ra,ffffffffc0200446 <__panic>

ffffffffc0204162 <swapfs_write>:
swapfs_read(swap_entry_t entry, struct Page *page) {
    return ide_read_secs(SWAP_DEV_NO, swap_offset(entry) * PAGE_NSECT, page2kva(page), PAGE_NSECT);
}

int
swapfs_write(swap_entry_t entry, struct Page *page) {
ffffffffc0204162:	1141                	addi	sp,sp,-16
ffffffffc0204164:	e406                	sd	ra,8(sp)
    return ide_write_secs(SWAP_DEV_NO, swap_offset(entry) * PAGE_NSECT, page2kva(page), PAGE_NSECT);
ffffffffc0204166:	00855793          	srli	a5,a0,0x8
ffffffffc020416a:	c3a5                	beqz	a5,ffffffffc02041ca <swapfs_write+0x68>
ffffffffc020416c:	00011717          	auipc	a4,0x11
ffffffffc0204170:	41473703          	ld	a4,1044(a4) # ffffffffc0215580 <max_swap_offset>
ffffffffc0204174:	04e7fb63          	bgeu	a5,a4,ffffffffc02041ca <swapfs_write+0x68>
    return page - pages + nbase;
ffffffffc0204178:	00011617          	auipc	a2,0x11
ffffffffc020417c:	3f063603          	ld	a2,1008(a2) # ffffffffc0215568 <pages>
ffffffffc0204180:	8d91                	sub	a1,a1,a2
ffffffffc0204182:	4035d613          	srai	a2,a1,0x3
ffffffffc0204186:	00003597          	auipc	a1,0x3
ffffffffc020418a:	9625b583          	ld	a1,-1694(a1) # ffffffffc0206ae8 <error_string+0x38>
ffffffffc020418e:	02b60633          	mul	a2,a2,a1
ffffffffc0204192:	0037959b          	slliw	a1,a5,0x3
ffffffffc0204196:	00003797          	auipc	a5,0x3
ffffffffc020419a:	95a7b783          	ld	a5,-1702(a5) # ffffffffc0206af0 <nbase>
    return KADDR(page2pa(page));
ffffffffc020419e:	00011717          	auipc	a4,0x11
ffffffffc02041a2:	3c273703          	ld	a4,962(a4) # ffffffffc0215560 <npage>
    return page - pages + nbase;
ffffffffc02041a6:	963e                	add	a2,a2,a5
    return KADDR(page2pa(page));
ffffffffc02041a8:	00c61793          	slli	a5,a2,0xc
ffffffffc02041ac:	83b1                	srli	a5,a5,0xc
    return page2ppn(page) << PGSHIFT;
ffffffffc02041ae:	0632                	slli	a2,a2,0xc
    return KADDR(page2pa(page));
ffffffffc02041b0:	02e7f963          	bgeu	a5,a4,ffffffffc02041e2 <swapfs_write+0x80>
}
ffffffffc02041b4:	60a2                	ld	ra,8(sp)
    return ide_write_secs(SWAP_DEV_NO, swap_offset(entry) * PAGE_NSECT, page2kva(page), PAGE_NSECT);
ffffffffc02041b6:	00011797          	auipc	a5,0x11
ffffffffc02041ba:	3c27b783          	ld	a5,962(a5) # ffffffffc0215578 <va_pa_offset>
ffffffffc02041be:	46a1                	li	a3,8
ffffffffc02041c0:	963e                	add	a2,a2,a5
ffffffffc02041c2:	4505                	li	a0,1
}
ffffffffc02041c4:	0141                	addi	sp,sp,16
    return ide_write_secs(SWAP_DEV_NO, swap_offset(entry) * PAGE_NSECT, page2kva(page), PAGE_NSECT);
ffffffffc02041c6:	baefc06f          	j	ffffffffc0200574 <ide_write_secs>
ffffffffc02041ca:	86aa                	mv	a3,a0
ffffffffc02041cc:	00002617          	auipc	a2,0x2
ffffffffc02041d0:	57460613          	addi	a2,a2,1396 # ffffffffc0206740 <default_pmm_manager+0xf28>
ffffffffc02041d4:	45e5                	li	a1,25
ffffffffc02041d6:	00002517          	auipc	a0,0x2
ffffffffc02041da:	55250513          	addi	a0,a0,1362 # ffffffffc0206728 <default_pmm_manager+0xf10>
ffffffffc02041de:	a68fc0ef          	jal	ra,ffffffffc0200446 <__panic>
ffffffffc02041e2:	86b2                	mv	a3,a2
ffffffffc02041e4:	06900593          	li	a1,105
ffffffffc02041e8:	00001617          	auipc	a2,0x1
ffffffffc02041ec:	66860613          	addi	a2,a2,1640 # ffffffffc0205850 <default_pmm_manager+0x38>
ffffffffc02041f0:	00001517          	auipc	a0,0x1
ffffffffc02041f4:	68850513          	addi	a0,a0,1672 # ffffffffc0205878 <default_pmm_manager+0x60>
ffffffffc02041f8:	a4efc0ef          	jal	ra,ffffffffc0200446 <__panic>

ffffffffc02041fc <init_main>:
    panic("process exit!!.\n");
}

// init_main - the second kernel thread used to create user_main kernel threads
static int
init_main(void *arg) {
ffffffffc02041fc:	7179                	addi	sp,sp,-48
ffffffffc02041fe:	ec26                	sd	s1,24(sp)
    memset(name, 0, sizeof(name));
ffffffffc0204200:	00011497          	auipc	s1,0x11
ffffffffc0204204:	31048493          	addi	s1,s1,784 # ffffffffc0215510 <name.0>
init_main(void *arg) {
ffffffffc0204208:	f022                	sd	s0,32(sp)
ffffffffc020420a:	e84a                	sd	s2,16(sp)
ffffffffc020420c:	842a                	mv	s0,a0
    cprintf("this initproc, pid = %d, name = \"%s\"\n", current->pid, get_proc_name(current));
ffffffffc020420e:	00011917          	auipc	s2,0x11
ffffffffc0204212:	39a93903          	ld	s2,922(s2) # ffffffffc02155a8 <current>
    memset(name, 0, sizeof(name));
ffffffffc0204216:	4641                	li	a2,16
ffffffffc0204218:	4581                	li	a1,0
ffffffffc020421a:	8526                	mv	a0,s1
init_main(void *arg) {
ffffffffc020421c:	f406                	sd	ra,40(sp)
ffffffffc020421e:	e44e                	sd	s3,8(sp)
    cprintf("this initproc, pid = %d, name = \"%s\"\n", current->pid, get_proc_name(current));
ffffffffc0204220:	00492983          	lw	s3,4(s2)
    memset(name, 0, sizeof(name));
ffffffffc0204224:	051000ef          	jal	ra,ffffffffc0204a74 <memset>
    return memcpy(name, proc->name, PROC_NAME_LEN);
ffffffffc0204228:	0b490593          	addi	a1,s2,180
ffffffffc020422c:	463d                	li	a2,15
ffffffffc020422e:	8526                	mv	a0,s1
ffffffffc0204230:	057000ef          	jal	ra,ffffffffc0204a86 <memcpy>
ffffffffc0204234:	862a                	mv	a2,a0
    cprintf("this initproc, pid = %d, name = \"%s\"\n", current->pid, get_proc_name(current));
ffffffffc0204236:	85ce                	mv	a1,s3
ffffffffc0204238:	00002517          	auipc	a0,0x2
ffffffffc020423c:	52850513          	addi	a0,a0,1320 # ffffffffc0206760 <default_pmm_manager+0xf48>
ffffffffc0204240:	f41fb0ef          	jal	ra,ffffffffc0200180 <cprintf>
    cprintf("To U: \"%s\".\n", (const char *)arg);
ffffffffc0204244:	85a2                	mv	a1,s0
ffffffffc0204246:	00002517          	auipc	a0,0x2
ffffffffc020424a:	54250513          	addi	a0,a0,1346 # ffffffffc0206788 <default_pmm_manager+0xf70>
ffffffffc020424e:	f33fb0ef          	jal	ra,ffffffffc0200180 <cprintf>
    cprintf("To U: \"en.., Bye, Bye. :)\"\n");
ffffffffc0204252:	00002517          	auipc	a0,0x2
ffffffffc0204256:	54650513          	addi	a0,a0,1350 # ffffffffc0206798 <default_pmm_manager+0xf80>
ffffffffc020425a:	f27fb0ef          	jal	ra,ffffffffc0200180 <cprintf>
    return 0;
}
ffffffffc020425e:	70a2                	ld	ra,40(sp)
ffffffffc0204260:	7402                	ld	s0,32(sp)
ffffffffc0204262:	64e2                	ld	s1,24(sp)
ffffffffc0204264:	6942                	ld	s2,16(sp)
ffffffffc0204266:	69a2                	ld	s3,8(sp)
ffffffffc0204268:	4501                	li	a0,0
ffffffffc020426a:	6145                	addi	sp,sp,48
ffffffffc020426c:	8082                	ret

ffffffffc020426e <proc_run>:
}
ffffffffc020426e:	8082                	ret

ffffffffc0204270 <kernel_thread>:
kernel_thread(int (*fn)(void *), void *arg, uint32_t clone_flags) {
ffffffffc0204270:	7169                	addi	sp,sp,-304
    memset(&tf, 0, sizeof(struct trapframe));
ffffffffc0204272:	12000613          	li	a2,288
ffffffffc0204276:	4581                	li	a1,0
ffffffffc0204278:	850a                	mv	a0,sp
kernel_thread(int (*fn)(void *), void *arg, uint32_t clone_flags) {
ffffffffc020427a:	f606                	sd	ra,296(sp)
    memset(&tf, 0, sizeof(struct trapframe));
ffffffffc020427c:	7f8000ef          	jal	ra,ffffffffc0204a74 <memset>
    tf.status = (read_csr(sstatus) | SSTATUS_SPP | SSTATUS_SPIE) & ~SSTATUS_SIE;
ffffffffc0204280:	100027f3          	csrr	a5,sstatus
}
ffffffffc0204284:	70b2                	ld	ra,296(sp)
    if (nr_process >= MAX_PROCESS) {
ffffffffc0204286:	00011517          	auipc	a0,0x11
ffffffffc020428a:	33a52503          	lw	a0,826(a0) # ffffffffc02155c0 <nr_process>
ffffffffc020428e:	6785                	lui	a5,0x1
    int ret = -E_NO_FREE_PROC;
ffffffffc0204290:	00f52533          	slt	a0,a0,a5
}
ffffffffc0204294:	156d                	addi	a0,a0,-5
ffffffffc0204296:	6155                	addi	sp,sp,304
ffffffffc0204298:	8082                	ret

ffffffffc020429a <proc_init>:

// proc_init - set up the first kernel thread idleproc "idle" by itself and 
//           - create the second kernel thread init_main
void
proc_init(void) {
ffffffffc020429a:	7139                	addi	sp,sp,-64
ffffffffc020429c:	f426                	sd	s1,40(sp)
    elm->prev = elm->next = elm;
ffffffffc020429e:	00011797          	auipc	a5,0x11
ffffffffc02042a2:	28278793          	addi	a5,a5,642 # ffffffffc0215520 <proc_list>
ffffffffc02042a6:	fc06                	sd	ra,56(sp)
ffffffffc02042a8:	f822                	sd	s0,48(sp)
ffffffffc02042aa:	f04a                	sd	s2,32(sp)
ffffffffc02042ac:	ec4e                	sd	s3,24(sp)
ffffffffc02042ae:	e852                	sd	s4,16(sp)
ffffffffc02042b0:	e456                	sd	s5,8(sp)
ffffffffc02042b2:	0000d497          	auipc	s1,0xd
ffffffffc02042b6:	25e48493          	addi	s1,s1,606 # ffffffffc0211510 <hash_list>
ffffffffc02042ba:	e79c                	sd	a5,8(a5)
ffffffffc02042bc:	e39c                	sd	a5,0(a5)
    int i;

    list_init(&proc_list);
    for (i = 0; i < HASH_LIST_SIZE; i ++) {
ffffffffc02042be:	00011717          	auipc	a4,0x11
ffffffffc02042c2:	25270713          	addi	a4,a4,594 # ffffffffc0215510 <name.0>
ffffffffc02042c6:	87a6                	mv	a5,s1
ffffffffc02042c8:	e79c                	sd	a5,8(a5)
ffffffffc02042ca:	e39c                	sd	a5,0(a5)
ffffffffc02042cc:	07c1                	addi	a5,a5,16
ffffffffc02042ce:	fef71de3          	bne	a4,a5,ffffffffc02042c8 <proc_init+0x2e>
    struct proc_struct *proc = kmalloc(sizeof(struct proc_struct));
ffffffffc02042d2:	0e800513          	li	a0,232
ffffffffc02042d6:	d8afd0ef          	jal	ra,ffffffffc0201860 <kmalloc>
ffffffffc02042da:	842a                	mv	s0,a0
    if (proc != NULL) {
ffffffffc02042dc:	1e050863          	beqz	a0,ffffffffc02044cc <proc_init+0x232>
     proc->state=PROC_UNINIT;
ffffffffc02042e0:	59fd                	li	s3,-1
ffffffffc02042e2:	1982                	slli	s3,s3,0x20
     memset(&(proc->context),0,sizeof(struct context));
ffffffffc02042e4:	07000613          	li	a2,112
ffffffffc02042e8:	4581                	li	a1,0
     proc->state=PROC_UNINIT;
ffffffffc02042ea:	01353023          	sd	s3,0(a0)
     proc->runs=0;
ffffffffc02042ee:	00052423          	sw	zero,8(a0)
     proc->kstack=0;
ffffffffc02042f2:	00053823          	sd	zero,16(a0)
     proc->need_resched=NULL;
ffffffffc02042f6:	00052c23          	sw	zero,24(a0)
     proc->parent=NULL;
ffffffffc02042fa:	02053023          	sd	zero,32(a0)
     proc->mm=NULL;
ffffffffc02042fe:	02053423          	sd	zero,40(a0)
     memset(&(proc->context),0,sizeof(struct context));
ffffffffc0204302:	03050513          	addi	a0,a0,48
ffffffffc0204306:	76e000ef          	jal	ra,ffffffffc0204a74 <memset>
     proc->cr3=boot_cr3;
ffffffffc020430a:	00011a97          	auipc	s5,0x11
ffffffffc020430e:	246a8a93          	addi	s5,s5,582 # ffffffffc0215550 <boot_cr3>
ffffffffc0204312:	000ab783          	ld	a5,0(s5)
     memset(proc->name,0,PROC_NAME_LEN);
ffffffffc0204316:	463d                	li	a2,15
ffffffffc0204318:	4581                	li	a1,0
     proc->cr3=boot_cr3;
ffffffffc020431a:	f45c                	sd	a5,168(s0)
     proc->tf=NULL;
ffffffffc020431c:	0a043023          	sd	zero,160(s0)
     proc->flags=0;
ffffffffc0204320:	0a042823          	sw	zero,176(s0)
     memset(proc->name,0,PROC_NAME_LEN);
ffffffffc0204324:	0b440513          	addi	a0,s0,180
ffffffffc0204328:	74c000ef          	jal	ra,ffffffffc0204a74 <memset>
        list_init(hash_list + i);
    }

    if ((idleproc = alloc_proc()) == NULL) {
ffffffffc020432c:	00011917          	auipc	s2,0x11
ffffffffc0204330:	28490913          	addi	s2,s2,644 # ffffffffc02155b0 <idleproc>
        panic("cannot alloc idleproc.\n");
    }

    // check the proc structure
    int *context_mem = (int*) kmalloc(sizeof(struct context));
ffffffffc0204334:	07000513          	li	a0,112
    if ((idleproc = alloc_proc()) == NULL) {
ffffffffc0204338:	00893023          	sd	s0,0(s2)
    int *context_mem = (int*) kmalloc(sizeof(struct context));
ffffffffc020433c:	d24fd0ef          	jal	ra,ffffffffc0201860 <kmalloc>
    memset(context_mem, 0, sizeof(struct context));
ffffffffc0204340:	07000613          	li	a2,112
ffffffffc0204344:	4581                	li	a1,0
    int *context_mem = (int*) kmalloc(sizeof(struct context));
ffffffffc0204346:	842a                	mv	s0,a0
    memset(context_mem, 0, sizeof(struct context));
ffffffffc0204348:	72c000ef          	jal	ra,ffffffffc0204a74 <memset>
    int context_init_flag = memcmp(&(idleproc->context), context_mem, sizeof(struct context));
ffffffffc020434c:	00093503          	ld	a0,0(s2)
ffffffffc0204350:	85a2                	mv	a1,s0
ffffffffc0204352:	07000613          	li	a2,112
ffffffffc0204356:	03050513          	addi	a0,a0,48
ffffffffc020435a:	744000ef          	jal	ra,ffffffffc0204a9e <memcmp>
ffffffffc020435e:	8a2a                	mv	s4,a0

    int *proc_name_mem = (int*) kmalloc(PROC_NAME_LEN);
ffffffffc0204360:	453d                	li	a0,15
ffffffffc0204362:	cfefd0ef          	jal	ra,ffffffffc0201860 <kmalloc>
    memset(proc_name_mem, 0, PROC_NAME_LEN);
ffffffffc0204366:	463d                	li	a2,15
ffffffffc0204368:	4581                	li	a1,0
    int *proc_name_mem = (int*) kmalloc(PROC_NAME_LEN);
ffffffffc020436a:	842a                	mv	s0,a0
    memset(proc_name_mem, 0, PROC_NAME_LEN);
ffffffffc020436c:	708000ef          	jal	ra,ffffffffc0204a74 <memset>
    int proc_name_flag = memcmp(&(idleproc->name), proc_name_mem, PROC_NAME_LEN);
ffffffffc0204370:	00093503          	ld	a0,0(s2)
ffffffffc0204374:	463d                	li	a2,15
ffffffffc0204376:	85a2                	mv	a1,s0
ffffffffc0204378:	0b450513          	addi	a0,a0,180
ffffffffc020437c:	722000ef          	jal	ra,ffffffffc0204a9e <memcmp>

    if(idleproc->cr3 == boot_cr3 && idleproc->tf == NULL && !context_init_flag
ffffffffc0204380:	00093783          	ld	a5,0(s2)
ffffffffc0204384:	000ab703          	ld	a4,0(s5)
ffffffffc0204388:	77d4                	ld	a3,168(a5)
ffffffffc020438a:	0ee68663          	beq	a3,a4,ffffffffc0204476 <proc_init+0x1dc>
        cprintf("alloc_proc() correct!\n");

    }
    
    idleproc->pid = 0;
    idleproc->state = PROC_RUNNABLE;
ffffffffc020438e:	4709                	li	a4,2
ffffffffc0204390:	e398                	sd	a4,0(a5)
    idleproc->kstack = (uintptr_t)bootstack;
ffffffffc0204392:	00003717          	auipc	a4,0x3
ffffffffc0204396:	c6e70713          	addi	a4,a4,-914 # ffffffffc0207000 <bootstack>
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc020439a:	0b478413          	addi	s0,a5,180
    idleproc->kstack = (uintptr_t)bootstack;
ffffffffc020439e:	eb98                	sd	a4,16(a5)
    idleproc->need_resched = 1;
ffffffffc02043a0:	4705                	li	a4,1
ffffffffc02043a2:	cf98                	sw	a4,24(a5)
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc02043a4:	4641                	li	a2,16
ffffffffc02043a6:	4581                	li	a1,0
ffffffffc02043a8:	8522                	mv	a0,s0
ffffffffc02043aa:	6ca000ef          	jal	ra,ffffffffc0204a74 <memset>
    return memcpy(proc->name, name, PROC_NAME_LEN);
ffffffffc02043ae:	463d                	li	a2,15
ffffffffc02043b0:	00002597          	auipc	a1,0x2
ffffffffc02043b4:	45058593          	addi	a1,a1,1104 # ffffffffc0206800 <default_pmm_manager+0xfe8>
ffffffffc02043b8:	8522                	mv	a0,s0
ffffffffc02043ba:	6cc000ef          	jal	ra,ffffffffc0204a86 <memcpy>
    set_proc_name(idleproc, "idle");
    nr_process ++;
ffffffffc02043be:	00011717          	auipc	a4,0x11
ffffffffc02043c2:	20270713          	addi	a4,a4,514 # ffffffffc02155c0 <nr_process>
ffffffffc02043c6:	431c                	lw	a5,0(a4)

    current = idleproc;
ffffffffc02043c8:	00093683          	ld	a3,0(s2)

    int pid = kernel_thread(init_main, "Hello world!!", 0);
ffffffffc02043cc:	4601                	li	a2,0
    nr_process ++;
ffffffffc02043ce:	2785                	addiw	a5,a5,1
    int pid = kernel_thread(init_main, "Hello world!!", 0);
ffffffffc02043d0:	00002597          	auipc	a1,0x2
ffffffffc02043d4:	43858593          	addi	a1,a1,1080 # ffffffffc0206808 <default_pmm_manager+0xff0>
ffffffffc02043d8:	00000517          	auipc	a0,0x0
ffffffffc02043dc:	e2450513          	addi	a0,a0,-476 # ffffffffc02041fc <init_main>
    nr_process ++;
ffffffffc02043e0:	c31c                	sw	a5,0(a4)
    current = idleproc;
ffffffffc02043e2:	00011797          	auipc	a5,0x11
ffffffffc02043e6:	1cd7b323          	sd	a3,454(a5) # ffffffffc02155a8 <current>
    int pid = kernel_thread(init_main, "Hello world!!", 0);
ffffffffc02043ea:	e87ff0ef          	jal	ra,ffffffffc0204270 <kernel_thread>
ffffffffc02043ee:	842a                	mv	s0,a0
    if (pid <= 0) {
ffffffffc02043f0:	0ea05e63          	blez	a0,ffffffffc02044ec <proc_init+0x252>
    if (0 < pid && pid < MAX_PID) {
ffffffffc02043f4:	6789                	lui	a5,0x2
ffffffffc02043f6:	fff5071b          	addiw	a4,a0,-1
ffffffffc02043fa:	17f9                	addi	a5,a5,-2
ffffffffc02043fc:	2501                	sext.w	a0,a0
ffffffffc02043fe:	02e7e363          	bltu	a5,a4,ffffffffc0204424 <proc_init+0x18a>
        list_entry_t *list = hash_list + pid_hashfn(pid), *le = list;
ffffffffc0204402:	45a9                	li	a1,10
ffffffffc0204404:	1f0000ef          	jal	ra,ffffffffc02045f4 <hash32>
ffffffffc0204408:	02051793          	slli	a5,a0,0x20
ffffffffc020440c:	01c7d693          	srli	a3,a5,0x1c
ffffffffc0204410:	96a6                	add	a3,a3,s1
ffffffffc0204412:	87b6                	mv	a5,a3
        while ((le = list_next(le)) != list) {
ffffffffc0204414:	a029                	j	ffffffffc020441e <proc_init+0x184>
            if (proc->pid == pid) {
ffffffffc0204416:	f2c7a703          	lw	a4,-212(a5) # 1f2c <kern_entry-0xffffffffc01fe0d4>
ffffffffc020441a:	0a870663          	beq	a4,s0,ffffffffc02044c6 <proc_init+0x22c>
    return listelm->next;
ffffffffc020441e:	679c                	ld	a5,8(a5)
        while ((le = list_next(le)) != list) {
ffffffffc0204420:	fef69be3          	bne	a3,a5,ffffffffc0204416 <proc_init+0x17c>
    return NULL;
ffffffffc0204424:	4781                	li	a5,0
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc0204426:	0b478493          	addi	s1,a5,180
ffffffffc020442a:	4641                	li	a2,16
ffffffffc020442c:	4581                	li	a1,0
        panic("create init_main failed.\n");
    }

    initproc = find_proc(pid);
ffffffffc020442e:	00011417          	auipc	s0,0x11
ffffffffc0204432:	18a40413          	addi	s0,s0,394 # ffffffffc02155b8 <initproc>
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc0204436:	8526                	mv	a0,s1
    initproc = find_proc(pid);
ffffffffc0204438:	e01c                	sd	a5,0(s0)
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc020443a:	63a000ef          	jal	ra,ffffffffc0204a74 <memset>
    return memcpy(proc->name, name, PROC_NAME_LEN);
ffffffffc020443e:	463d                	li	a2,15
ffffffffc0204440:	00002597          	auipc	a1,0x2
ffffffffc0204444:	3f858593          	addi	a1,a1,1016 # ffffffffc0206838 <default_pmm_manager+0x1020>
ffffffffc0204448:	8526                	mv	a0,s1
ffffffffc020444a:	63c000ef          	jal	ra,ffffffffc0204a86 <memcpy>
    set_proc_name(initproc, "init");

    assert(idleproc != NULL && idleproc->pid == 0);
ffffffffc020444e:	00093783          	ld	a5,0(s2)
ffffffffc0204452:	cbe9                	beqz	a5,ffffffffc0204524 <proc_init+0x28a>
ffffffffc0204454:	43dc                	lw	a5,4(a5)
ffffffffc0204456:	e7f9                	bnez	a5,ffffffffc0204524 <proc_init+0x28a>
    assert(initproc != NULL && initproc->pid == 1);
ffffffffc0204458:	601c                	ld	a5,0(s0)
ffffffffc020445a:	c7cd                	beqz	a5,ffffffffc0204504 <proc_init+0x26a>
ffffffffc020445c:	43d8                	lw	a4,4(a5)
ffffffffc020445e:	4785                	li	a5,1
ffffffffc0204460:	0af71263          	bne	a4,a5,ffffffffc0204504 <proc_init+0x26a>
}
ffffffffc0204464:	70e2                	ld	ra,56(sp)
ffffffffc0204466:	7442                	ld	s0,48(sp)
ffffffffc0204468:	74a2                	ld	s1,40(sp)
ffffffffc020446a:	7902                	ld	s2,32(sp)
ffffffffc020446c:	69e2                	ld	s3,24(sp)
ffffffffc020446e:	6a42                	ld	s4,16(sp)
ffffffffc0204470:	6aa2                	ld	s5,8(sp)
ffffffffc0204472:	6121                	addi	sp,sp,64
ffffffffc0204474:	8082                	ret
    if(idleproc->cr3 == boot_cr3 && idleproc->tf == NULL && !context_init_flag
ffffffffc0204476:	73d8                	ld	a4,160(a5)
ffffffffc0204478:	f0071be3          	bnez	a4,ffffffffc020438e <proc_init+0xf4>
ffffffffc020447c:	f00a19e3          	bnez	s4,ffffffffc020438e <proc_init+0xf4>
        && idleproc->state == PROC_UNINIT && idleproc->pid == -1 && idleproc->runs == 0
ffffffffc0204480:	6398                	ld	a4,0(a5)
ffffffffc0204482:	f13716e3          	bne	a4,s3,ffffffffc020438e <proc_init+0xf4>
ffffffffc0204486:	4798                	lw	a4,8(a5)
ffffffffc0204488:	f00713e3          	bnez	a4,ffffffffc020438e <proc_init+0xf4>
        && idleproc->kstack == 0 && idleproc->need_resched == 0 && idleproc->parent == NULL
ffffffffc020448c:	6b98                	ld	a4,16(a5)
ffffffffc020448e:	f00710e3          	bnez	a4,ffffffffc020438e <proc_init+0xf4>
ffffffffc0204492:	4f98                	lw	a4,24(a5)
ffffffffc0204494:	2701                	sext.w	a4,a4
ffffffffc0204496:	ee071ce3          	bnez	a4,ffffffffc020438e <proc_init+0xf4>
ffffffffc020449a:	7398                	ld	a4,32(a5)
ffffffffc020449c:	ee0719e3          	bnez	a4,ffffffffc020438e <proc_init+0xf4>
        && idleproc->mm == NULL && idleproc->flags == 0 && !proc_name_flag
ffffffffc02044a0:	7798                	ld	a4,40(a5)
ffffffffc02044a2:	ee0716e3          	bnez	a4,ffffffffc020438e <proc_init+0xf4>
ffffffffc02044a6:	0b07a703          	lw	a4,176(a5)
ffffffffc02044aa:	8d59                	or	a0,a0,a4
ffffffffc02044ac:	0005071b          	sext.w	a4,a0
ffffffffc02044b0:	ec071fe3          	bnez	a4,ffffffffc020438e <proc_init+0xf4>
        cprintf("alloc_proc() correct!\n");
ffffffffc02044b4:	00002517          	auipc	a0,0x2
ffffffffc02044b8:	33450513          	addi	a0,a0,820 # ffffffffc02067e8 <default_pmm_manager+0xfd0>
ffffffffc02044bc:	cc5fb0ef          	jal	ra,ffffffffc0200180 <cprintf>
    idleproc->pid = 0;
ffffffffc02044c0:	00093783          	ld	a5,0(s2)
ffffffffc02044c4:	b5e9                	j	ffffffffc020438e <proc_init+0xf4>
            struct proc_struct *proc = le2proc(le, hash_link);
ffffffffc02044c6:	f2878793          	addi	a5,a5,-216
ffffffffc02044ca:	bfb1                	j	ffffffffc0204426 <proc_init+0x18c>
        panic("cannot alloc idleproc.\n");
ffffffffc02044cc:	00002617          	auipc	a2,0x2
ffffffffc02044d0:	3c460613          	addi	a2,a2,964 # ffffffffc0206890 <default_pmm_manager+0x1078>
ffffffffc02044d4:	16400593          	li	a1,356
ffffffffc02044d8:	00002517          	auipc	a0,0x2
ffffffffc02044dc:	2f850513          	addi	a0,a0,760 # ffffffffc02067d0 <default_pmm_manager+0xfb8>
    if ((idleproc = alloc_proc()) == NULL) {
ffffffffc02044e0:	00011797          	auipc	a5,0x11
ffffffffc02044e4:	0c07b823          	sd	zero,208(a5) # ffffffffc02155b0 <idleproc>
        panic("cannot alloc idleproc.\n");
ffffffffc02044e8:	f5ffb0ef          	jal	ra,ffffffffc0200446 <__panic>
        panic("create init_main failed.\n");
ffffffffc02044ec:	00002617          	auipc	a2,0x2
ffffffffc02044f0:	32c60613          	addi	a2,a2,812 # ffffffffc0206818 <default_pmm_manager+0x1000>
ffffffffc02044f4:	18400593          	li	a1,388
ffffffffc02044f8:	00002517          	auipc	a0,0x2
ffffffffc02044fc:	2d850513          	addi	a0,a0,728 # ffffffffc02067d0 <default_pmm_manager+0xfb8>
ffffffffc0204500:	f47fb0ef          	jal	ra,ffffffffc0200446 <__panic>
    assert(initproc != NULL && initproc->pid == 1);
ffffffffc0204504:	00002697          	auipc	a3,0x2
ffffffffc0204508:	36468693          	addi	a3,a3,868 # ffffffffc0206868 <default_pmm_manager+0x1050>
ffffffffc020450c:	00001617          	auipc	a2,0x1
ffffffffc0204510:	f5c60613          	addi	a2,a2,-164 # ffffffffc0205468 <commands+0x738>
ffffffffc0204514:	18b00593          	li	a1,395
ffffffffc0204518:	00002517          	auipc	a0,0x2
ffffffffc020451c:	2b850513          	addi	a0,a0,696 # ffffffffc02067d0 <default_pmm_manager+0xfb8>
ffffffffc0204520:	f27fb0ef          	jal	ra,ffffffffc0200446 <__panic>
    assert(idleproc != NULL && idleproc->pid == 0);
ffffffffc0204524:	00002697          	auipc	a3,0x2
ffffffffc0204528:	31c68693          	addi	a3,a3,796 # ffffffffc0206840 <default_pmm_manager+0x1028>
ffffffffc020452c:	00001617          	auipc	a2,0x1
ffffffffc0204530:	f3c60613          	addi	a2,a2,-196 # ffffffffc0205468 <commands+0x738>
ffffffffc0204534:	18a00593          	li	a1,394
ffffffffc0204538:	00002517          	auipc	a0,0x2
ffffffffc020453c:	29850513          	addi	a0,a0,664 # ffffffffc02067d0 <default_pmm_manager+0xfb8>
ffffffffc0204540:	f07fb0ef          	jal	ra,ffffffffc0200446 <__panic>

ffffffffc0204544 <cpu_idle>:

// cpu_idle - at the end of kern_init, the first kernel thread idleproc will do below works
void
cpu_idle(void) {
ffffffffc0204544:	1141                	addi	sp,sp,-16
ffffffffc0204546:	e022                	sd	s0,0(sp)
ffffffffc0204548:	e406                	sd	ra,8(sp)
ffffffffc020454a:	00011417          	auipc	s0,0x11
ffffffffc020454e:	05e40413          	addi	s0,s0,94 # ffffffffc02155a8 <current>
    while (1) {
        if (current->need_resched) {
ffffffffc0204552:	6018                	ld	a4,0(s0)
ffffffffc0204554:	4f1c                	lw	a5,24(a4)
ffffffffc0204556:	2781                	sext.w	a5,a5
ffffffffc0204558:	dff5                	beqz	a5,ffffffffc0204554 <cpu_idle+0x10>
            schedule();
ffffffffc020455a:	006000ef          	jal	ra,ffffffffc0204560 <schedule>
ffffffffc020455e:	bfd5                	j	ffffffffc0204552 <cpu_idle+0xe>

ffffffffc0204560 <schedule>:
    assert(proc->state != PROC_ZOMBIE && proc->state != PROC_RUNNABLE);
    proc->state = PROC_RUNNABLE;
}

void
schedule(void) {
ffffffffc0204560:	1141                	addi	sp,sp,-16
ffffffffc0204562:	e406                	sd	ra,8(sp)
ffffffffc0204564:	e022                	sd	s0,0(sp)
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0204566:	100027f3          	csrr	a5,sstatus
ffffffffc020456a:	8b89                	andi	a5,a5,2
ffffffffc020456c:	4401                	li	s0,0
ffffffffc020456e:	efbd                	bnez	a5,ffffffffc02045ec <schedule+0x8c>
    bool intr_flag;
    list_entry_t *le, *last;
    struct proc_struct *next = NULL;
    local_intr_save(intr_flag);
    {
        current->need_resched = 0;
ffffffffc0204570:	00011897          	auipc	a7,0x11
ffffffffc0204574:	0388b883          	ld	a7,56(a7) # ffffffffc02155a8 <current>
ffffffffc0204578:	0008ac23          	sw	zero,24(a7)
        last = (current == idleproc) ? &proc_list : &(current->list_link);
ffffffffc020457c:	00011517          	auipc	a0,0x11
ffffffffc0204580:	03453503          	ld	a0,52(a0) # ffffffffc02155b0 <idleproc>
ffffffffc0204584:	04a88e63          	beq	a7,a0,ffffffffc02045e0 <schedule+0x80>
ffffffffc0204588:	0c888693          	addi	a3,a7,200
ffffffffc020458c:	00011617          	auipc	a2,0x11
ffffffffc0204590:	f9460613          	addi	a2,a2,-108 # ffffffffc0215520 <proc_list>
        le = last;
ffffffffc0204594:	87b6                	mv	a5,a3
    struct proc_struct *next = NULL;
ffffffffc0204596:	4581                	li	a1,0
        do {
            if ((le = list_next(le)) != &proc_list) {
                next = le2proc(le, list_link);
                if (next->state == PROC_RUNNABLE) {
ffffffffc0204598:	4809                	li	a6,2
ffffffffc020459a:	679c                	ld	a5,8(a5)
            if ((le = list_next(le)) != &proc_list) {
ffffffffc020459c:	00c78863          	beq	a5,a2,ffffffffc02045ac <schedule+0x4c>
                if (next->state == PROC_RUNNABLE) {
ffffffffc02045a0:	f387a703          	lw	a4,-200(a5)
                next = le2proc(le, list_link);
ffffffffc02045a4:	f3878593          	addi	a1,a5,-200
                if (next->state == PROC_RUNNABLE) {
ffffffffc02045a8:	03070163          	beq	a4,a6,ffffffffc02045ca <schedule+0x6a>
                    break;
                }
            }
        } while (le != last);
ffffffffc02045ac:	fef697e3          	bne	a3,a5,ffffffffc020459a <schedule+0x3a>
        if (next == NULL || next->state != PROC_RUNNABLE) {
ffffffffc02045b0:	ed89                	bnez	a1,ffffffffc02045ca <schedule+0x6a>
            next = idleproc;
        }
        next->runs ++;
ffffffffc02045b2:	451c                	lw	a5,8(a0)
ffffffffc02045b4:	2785                	addiw	a5,a5,1
ffffffffc02045b6:	c51c                	sw	a5,8(a0)
        if (next != current) {
ffffffffc02045b8:	00a88463          	beq	a7,a0,ffffffffc02045c0 <schedule+0x60>
            proc_run(next);
ffffffffc02045bc:	cb3ff0ef          	jal	ra,ffffffffc020426e <proc_run>
    if (flag) {
ffffffffc02045c0:	e819                	bnez	s0,ffffffffc02045d6 <schedule+0x76>
        }
    }
    local_intr_restore(intr_flag);
}
ffffffffc02045c2:	60a2                	ld	ra,8(sp)
ffffffffc02045c4:	6402                	ld	s0,0(sp)
ffffffffc02045c6:	0141                	addi	sp,sp,16
ffffffffc02045c8:	8082                	ret
        if (next == NULL || next->state != PROC_RUNNABLE) {
ffffffffc02045ca:	4198                	lw	a4,0(a1)
ffffffffc02045cc:	4789                	li	a5,2
ffffffffc02045ce:	fef712e3          	bne	a4,a5,ffffffffc02045b2 <schedule+0x52>
ffffffffc02045d2:	852e                	mv	a0,a1
ffffffffc02045d4:	bff9                	j	ffffffffc02045b2 <schedule+0x52>
}
ffffffffc02045d6:	6402                	ld	s0,0(sp)
ffffffffc02045d8:	60a2                	ld	ra,8(sp)
ffffffffc02045da:	0141                	addi	sp,sp,16
        intr_enable();
ffffffffc02045dc:	fbdfb06f          	j	ffffffffc0200598 <intr_enable>
        last = (current == idleproc) ? &proc_list : &(current->list_link);
ffffffffc02045e0:	00011617          	auipc	a2,0x11
ffffffffc02045e4:	f4060613          	addi	a2,a2,-192 # ffffffffc0215520 <proc_list>
ffffffffc02045e8:	86b2                	mv	a3,a2
ffffffffc02045ea:	b76d                	j	ffffffffc0204594 <schedule+0x34>
        intr_disable();
ffffffffc02045ec:	fb3fb0ef          	jal	ra,ffffffffc020059e <intr_disable>
        return 1;
ffffffffc02045f0:	4405                	li	s0,1
ffffffffc02045f2:	bfbd                	j	ffffffffc0204570 <schedule+0x10>

ffffffffc02045f4 <hash32>:
 *
 * High bits are more random, so we use them.
 * */
uint32_t
hash32(uint32_t val, unsigned int bits) {
    uint32_t hash = val * GOLDEN_RATIO_PRIME_32;
ffffffffc02045f4:	9e3707b7          	lui	a5,0x9e370
ffffffffc02045f8:	2785                	addiw	a5,a5,1
ffffffffc02045fa:	02a7853b          	mulw	a0,a5,a0
    return (hash >> (32 - bits));
ffffffffc02045fe:	02000793          	li	a5,32
ffffffffc0204602:	9f8d                	subw	a5,a5,a1
}
ffffffffc0204604:	00f5553b          	srlw	a0,a0,a5
ffffffffc0204608:	8082                	ret

ffffffffc020460a <printnum>:
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
    unsigned long long result = num;
    unsigned mod = do_div(result, base);
ffffffffc020460a:	02069813          	slli	a6,a3,0x20
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc020460e:	7179                	addi	sp,sp,-48
    unsigned mod = do_div(result, base);
ffffffffc0204610:	02085813          	srli	a6,a6,0x20
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc0204614:	e052                	sd	s4,0(sp)
    unsigned mod = do_div(result, base);
ffffffffc0204616:	03067a33          	remu	s4,a2,a6
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc020461a:	f022                	sd	s0,32(sp)
ffffffffc020461c:	ec26                	sd	s1,24(sp)
ffffffffc020461e:	e84a                	sd	s2,16(sp)
ffffffffc0204620:	f406                	sd	ra,40(sp)
ffffffffc0204622:	e44e                	sd	s3,8(sp)
ffffffffc0204624:	84aa                	mv	s1,a0
ffffffffc0204626:	892e                	mv	s2,a1
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
ffffffffc0204628:	fff7041b          	addiw	s0,a4,-1
    unsigned mod = do_div(result, base);
ffffffffc020462c:	2a01                	sext.w	s4,s4
    if (num >= base) {
ffffffffc020462e:	03067e63          	bgeu	a2,a6,ffffffffc020466a <printnum+0x60>
ffffffffc0204632:	89be                	mv	s3,a5
        while (-- width > 0)
ffffffffc0204634:	00805763          	blez	s0,ffffffffc0204642 <printnum+0x38>
ffffffffc0204638:	347d                	addiw	s0,s0,-1
            putch(padc, putdat);
ffffffffc020463a:	85ca                	mv	a1,s2
ffffffffc020463c:	854e                	mv	a0,s3
ffffffffc020463e:	9482                	jalr	s1
        while (-- width > 0)
ffffffffc0204640:	fc65                	bnez	s0,ffffffffc0204638 <printnum+0x2e>
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
ffffffffc0204642:	1a02                	slli	s4,s4,0x20
ffffffffc0204644:	00002797          	auipc	a5,0x2
ffffffffc0204648:	26478793          	addi	a5,a5,612 # ffffffffc02068a8 <default_pmm_manager+0x1090>
ffffffffc020464c:	020a5a13          	srli	s4,s4,0x20
ffffffffc0204650:	9a3e                	add	s4,s4,a5
}
ffffffffc0204652:	7402                	ld	s0,32(sp)
    putch("0123456789abcdef"[mod], putdat);
ffffffffc0204654:	000a4503          	lbu	a0,0(s4)
}
ffffffffc0204658:	70a2                	ld	ra,40(sp)
ffffffffc020465a:	69a2                	ld	s3,8(sp)
ffffffffc020465c:	6a02                	ld	s4,0(sp)
    putch("0123456789abcdef"[mod], putdat);
ffffffffc020465e:	85ca                	mv	a1,s2
ffffffffc0204660:	87a6                	mv	a5,s1
}
ffffffffc0204662:	6942                	ld	s2,16(sp)
ffffffffc0204664:	64e2                	ld	s1,24(sp)
ffffffffc0204666:	6145                	addi	sp,sp,48
    putch("0123456789abcdef"[mod], putdat);
ffffffffc0204668:	8782                	jr	a5
        printnum(putch, putdat, result, base, width - 1, padc);
ffffffffc020466a:	03065633          	divu	a2,a2,a6
ffffffffc020466e:	8722                	mv	a4,s0
ffffffffc0204670:	f9bff0ef          	jal	ra,ffffffffc020460a <printnum>
ffffffffc0204674:	b7f9                	j	ffffffffc0204642 <printnum+0x38>

ffffffffc0204676 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
ffffffffc0204676:	7119                	addi	sp,sp,-128
ffffffffc0204678:	f4a6                	sd	s1,104(sp)
ffffffffc020467a:	f0ca                	sd	s2,96(sp)
ffffffffc020467c:	ecce                	sd	s3,88(sp)
ffffffffc020467e:	e8d2                	sd	s4,80(sp)
ffffffffc0204680:	e4d6                	sd	s5,72(sp)
ffffffffc0204682:	e0da                	sd	s6,64(sp)
ffffffffc0204684:	fc5e                	sd	s7,56(sp)
ffffffffc0204686:	f06a                	sd	s10,32(sp)
ffffffffc0204688:	fc86                	sd	ra,120(sp)
ffffffffc020468a:	f8a2                	sd	s0,112(sp)
ffffffffc020468c:	f862                	sd	s8,48(sp)
ffffffffc020468e:	f466                	sd	s9,40(sp)
ffffffffc0204690:	ec6e                	sd	s11,24(sp)
ffffffffc0204692:	892a                	mv	s2,a0
ffffffffc0204694:	84ae                	mv	s1,a1
ffffffffc0204696:	8d32                	mv	s10,a2
ffffffffc0204698:	8a36                	mv	s4,a3
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc020469a:	02500993          	li	s3,37
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
        width = precision = -1;
ffffffffc020469e:	5b7d                	li	s6,-1
ffffffffc02046a0:	00002a97          	auipc	s5,0x2
ffffffffc02046a4:	234a8a93          	addi	s5,s5,564 # ffffffffc02068d4 <default_pmm_manager+0x10bc>
        case 'e':
            err = va_arg(ap, int);
            if (err < 0) {
                err = -err;
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
ffffffffc02046a8:	00002b97          	auipc	s7,0x2
ffffffffc02046ac:	408b8b93          	addi	s7,s7,1032 # ffffffffc0206ab0 <error_string>
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc02046b0:	000d4503          	lbu	a0,0(s10) # 80000 <kern_entry-0xffffffffc0180000>
ffffffffc02046b4:	001d0413          	addi	s0,s10,1
ffffffffc02046b8:	01350a63          	beq	a0,s3,ffffffffc02046cc <vprintfmt+0x56>
            if (ch == '\0') {
ffffffffc02046bc:	c121                	beqz	a0,ffffffffc02046fc <vprintfmt+0x86>
            putch(ch, putdat);
ffffffffc02046be:	85a6                	mv	a1,s1
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc02046c0:	0405                	addi	s0,s0,1
            putch(ch, putdat);
ffffffffc02046c2:	9902                	jalr	s2
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc02046c4:	fff44503          	lbu	a0,-1(s0)
ffffffffc02046c8:	ff351ae3          	bne	a0,s3,ffffffffc02046bc <vprintfmt+0x46>
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc02046cc:	00044603          	lbu	a2,0(s0)
        char padc = ' ';
ffffffffc02046d0:	02000793          	li	a5,32
        lflag = altflag = 0;
ffffffffc02046d4:	4c81                	li	s9,0
ffffffffc02046d6:	4881                	li	a7,0
        width = precision = -1;
ffffffffc02046d8:	5c7d                	li	s8,-1
ffffffffc02046da:	5dfd                	li	s11,-1
ffffffffc02046dc:	05500513          	li	a0,85
                if (ch < '0' || ch > '9') {
ffffffffc02046e0:	4825                	li	a6,9
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc02046e2:	fdd6059b          	addiw	a1,a2,-35
ffffffffc02046e6:	0ff5f593          	zext.b	a1,a1
ffffffffc02046ea:	00140d13          	addi	s10,s0,1
ffffffffc02046ee:	04b56263          	bltu	a0,a1,ffffffffc0204732 <vprintfmt+0xbc>
ffffffffc02046f2:	058a                	slli	a1,a1,0x2
ffffffffc02046f4:	95d6                	add	a1,a1,s5
ffffffffc02046f6:	4194                	lw	a3,0(a1)
ffffffffc02046f8:	96d6                	add	a3,a3,s5
ffffffffc02046fa:	8682                	jr	a3
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
ffffffffc02046fc:	70e6                	ld	ra,120(sp)
ffffffffc02046fe:	7446                	ld	s0,112(sp)
ffffffffc0204700:	74a6                	ld	s1,104(sp)
ffffffffc0204702:	7906                	ld	s2,96(sp)
ffffffffc0204704:	69e6                	ld	s3,88(sp)
ffffffffc0204706:	6a46                	ld	s4,80(sp)
ffffffffc0204708:	6aa6                	ld	s5,72(sp)
ffffffffc020470a:	6b06                	ld	s6,64(sp)
ffffffffc020470c:	7be2                	ld	s7,56(sp)
ffffffffc020470e:	7c42                	ld	s8,48(sp)
ffffffffc0204710:	7ca2                	ld	s9,40(sp)
ffffffffc0204712:	7d02                	ld	s10,32(sp)
ffffffffc0204714:	6de2                	ld	s11,24(sp)
ffffffffc0204716:	6109                	addi	sp,sp,128
ffffffffc0204718:	8082                	ret
            padc = '0';
ffffffffc020471a:	87b2                	mv	a5,a2
            goto reswitch;
ffffffffc020471c:	00144603          	lbu	a2,1(s0)
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0204720:	846a                	mv	s0,s10
ffffffffc0204722:	00140d13          	addi	s10,s0,1
ffffffffc0204726:	fdd6059b          	addiw	a1,a2,-35
ffffffffc020472a:	0ff5f593          	zext.b	a1,a1
ffffffffc020472e:	fcb572e3          	bgeu	a0,a1,ffffffffc02046f2 <vprintfmt+0x7c>
            putch('%', putdat);
ffffffffc0204732:	85a6                	mv	a1,s1
ffffffffc0204734:	02500513          	li	a0,37
ffffffffc0204738:	9902                	jalr	s2
            for (fmt --; fmt[-1] != '%'; fmt --)
ffffffffc020473a:	fff44783          	lbu	a5,-1(s0)
ffffffffc020473e:	8d22                	mv	s10,s0
ffffffffc0204740:	f73788e3          	beq	a5,s3,ffffffffc02046b0 <vprintfmt+0x3a>
ffffffffc0204744:	ffed4783          	lbu	a5,-2(s10)
ffffffffc0204748:	1d7d                	addi	s10,s10,-1
ffffffffc020474a:	ff379de3          	bne	a5,s3,ffffffffc0204744 <vprintfmt+0xce>
ffffffffc020474e:	b78d                	j	ffffffffc02046b0 <vprintfmt+0x3a>
                precision = precision * 10 + ch - '0';
ffffffffc0204750:	fd060c1b          	addiw	s8,a2,-48
                ch = *fmt;
ffffffffc0204754:	00144603          	lbu	a2,1(s0)
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0204758:	846a                	mv	s0,s10
                if (ch < '0' || ch > '9') {
ffffffffc020475a:	fd06069b          	addiw	a3,a2,-48
                ch = *fmt;
ffffffffc020475e:	0006059b          	sext.w	a1,a2
                if (ch < '0' || ch > '9') {
ffffffffc0204762:	02d86463          	bltu	a6,a3,ffffffffc020478a <vprintfmt+0x114>
                ch = *fmt;
ffffffffc0204766:	00144603          	lbu	a2,1(s0)
                precision = precision * 10 + ch - '0';
ffffffffc020476a:	002c169b          	slliw	a3,s8,0x2
ffffffffc020476e:	0186873b          	addw	a4,a3,s8
ffffffffc0204772:	0017171b          	slliw	a4,a4,0x1
ffffffffc0204776:	9f2d                	addw	a4,a4,a1
                if (ch < '0' || ch > '9') {
ffffffffc0204778:	fd06069b          	addiw	a3,a2,-48
            for (precision = 0; ; ++ fmt) {
ffffffffc020477c:	0405                	addi	s0,s0,1
                precision = precision * 10 + ch - '0';
ffffffffc020477e:	fd070c1b          	addiw	s8,a4,-48
                ch = *fmt;
ffffffffc0204782:	0006059b          	sext.w	a1,a2
                if (ch < '0' || ch > '9') {
ffffffffc0204786:	fed870e3          	bgeu	a6,a3,ffffffffc0204766 <vprintfmt+0xf0>
            if (width < 0)
ffffffffc020478a:	f40ddce3          	bgez	s11,ffffffffc02046e2 <vprintfmt+0x6c>
                width = precision, precision = -1;
ffffffffc020478e:	8de2                	mv	s11,s8
ffffffffc0204790:	5c7d                	li	s8,-1
ffffffffc0204792:	bf81                	j	ffffffffc02046e2 <vprintfmt+0x6c>
            if (width < 0)
ffffffffc0204794:	fffdc693          	not	a3,s11
ffffffffc0204798:	96fd                	srai	a3,a3,0x3f
ffffffffc020479a:	00ddfdb3          	and	s11,s11,a3
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc020479e:	00144603          	lbu	a2,1(s0)
ffffffffc02047a2:	2d81                	sext.w	s11,s11
ffffffffc02047a4:	846a                	mv	s0,s10
            goto reswitch;
ffffffffc02047a6:	bf35                	j	ffffffffc02046e2 <vprintfmt+0x6c>
            precision = va_arg(ap, int);
ffffffffc02047a8:	000a2c03          	lw	s8,0(s4)
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc02047ac:	00144603          	lbu	a2,1(s0)
            precision = va_arg(ap, int);
ffffffffc02047b0:	0a21                	addi	s4,s4,8
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc02047b2:	846a                	mv	s0,s10
            goto process_precision;
ffffffffc02047b4:	bfd9                	j	ffffffffc020478a <vprintfmt+0x114>
    if (lflag >= 2) {
ffffffffc02047b6:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc02047b8:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
ffffffffc02047bc:	01174463          	blt	a4,a7,ffffffffc02047c4 <vprintfmt+0x14e>
    else if (lflag) {
ffffffffc02047c0:	1a088e63          	beqz	a7,ffffffffc020497c <vprintfmt+0x306>
        return va_arg(*ap, unsigned long);
ffffffffc02047c4:	000a3603          	ld	a2,0(s4)
ffffffffc02047c8:	46c1                	li	a3,16
ffffffffc02047ca:	8a2e                	mv	s4,a1
            printnum(putch, putdat, num, base, width, padc);
ffffffffc02047cc:	2781                	sext.w	a5,a5
ffffffffc02047ce:	876e                	mv	a4,s11
ffffffffc02047d0:	85a6                	mv	a1,s1
ffffffffc02047d2:	854a                	mv	a0,s2
ffffffffc02047d4:	e37ff0ef          	jal	ra,ffffffffc020460a <printnum>
            break;
ffffffffc02047d8:	bde1                	j	ffffffffc02046b0 <vprintfmt+0x3a>
            putch(va_arg(ap, int), putdat);
ffffffffc02047da:	000a2503          	lw	a0,0(s4)
ffffffffc02047de:	85a6                	mv	a1,s1
ffffffffc02047e0:	0a21                	addi	s4,s4,8
ffffffffc02047e2:	9902                	jalr	s2
            break;
ffffffffc02047e4:	b5f1                	j	ffffffffc02046b0 <vprintfmt+0x3a>
    if (lflag >= 2) {
ffffffffc02047e6:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc02047e8:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
ffffffffc02047ec:	01174463          	blt	a4,a7,ffffffffc02047f4 <vprintfmt+0x17e>
    else if (lflag) {
ffffffffc02047f0:	18088163          	beqz	a7,ffffffffc0204972 <vprintfmt+0x2fc>
        return va_arg(*ap, unsigned long);
ffffffffc02047f4:	000a3603          	ld	a2,0(s4)
ffffffffc02047f8:	46a9                	li	a3,10
ffffffffc02047fa:	8a2e                	mv	s4,a1
ffffffffc02047fc:	bfc1                	j	ffffffffc02047cc <vprintfmt+0x156>
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc02047fe:	00144603          	lbu	a2,1(s0)
            altflag = 1;
ffffffffc0204802:	4c85                	li	s9,1
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0204804:	846a                	mv	s0,s10
            goto reswitch;
ffffffffc0204806:	bdf1                	j	ffffffffc02046e2 <vprintfmt+0x6c>
            putch(ch, putdat);
ffffffffc0204808:	85a6                	mv	a1,s1
ffffffffc020480a:	02500513          	li	a0,37
ffffffffc020480e:	9902                	jalr	s2
            break;
ffffffffc0204810:	b545                	j	ffffffffc02046b0 <vprintfmt+0x3a>
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0204812:	00144603          	lbu	a2,1(s0)
            lflag ++;
ffffffffc0204816:	2885                	addiw	a7,a7,1
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0204818:	846a                	mv	s0,s10
            goto reswitch;
ffffffffc020481a:	b5e1                	j	ffffffffc02046e2 <vprintfmt+0x6c>
    if (lflag >= 2) {
ffffffffc020481c:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc020481e:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
ffffffffc0204822:	01174463          	blt	a4,a7,ffffffffc020482a <vprintfmt+0x1b4>
    else if (lflag) {
ffffffffc0204826:	14088163          	beqz	a7,ffffffffc0204968 <vprintfmt+0x2f2>
        return va_arg(*ap, unsigned long);
ffffffffc020482a:	000a3603          	ld	a2,0(s4)
ffffffffc020482e:	46a1                	li	a3,8
ffffffffc0204830:	8a2e                	mv	s4,a1
ffffffffc0204832:	bf69                	j	ffffffffc02047cc <vprintfmt+0x156>
            putch('0', putdat);
ffffffffc0204834:	03000513          	li	a0,48
ffffffffc0204838:	85a6                	mv	a1,s1
ffffffffc020483a:	e03e                	sd	a5,0(sp)
ffffffffc020483c:	9902                	jalr	s2
            putch('x', putdat);
ffffffffc020483e:	85a6                	mv	a1,s1
ffffffffc0204840:	07800513          	li	a0,120
ffffffffc0204844:	9902                	jalr	s2
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
ffffffffc0204846:	0a21                	addi	s4,s4,8
            goto number;
ffffffffc0204848:	6782                	ld	a5,0(sp)
ffffffffc020484a:	46c1                	li	a3,16
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
ffffffffc020484c:	ff8a3603          	ld	a2,-8(s4)
            goto number;
ffffffffc0204850:	bfb5                	j	ffffffffc02047cc <vprintfmt+0x156>
            if ((p = va_arg(ap, char *)) == NULL) {
ffffffffc0204852:	000a3403          	ld	s0,0(s4)
ffffffffc0204856:	008a0713          	addi	a4,s4,8
ffffffffc020485a:	e03a                	sd	a4,0(sp)
ffffffffc020485c:	14040263          	beqz	s0,ffffffffc02049a0 <vprintfmt+0x32a>
            if (width > 0 && padc != '-') {
ffffffffc0204860:	0fb05763          	blez	s11,ffffffffc020494e <vprintfmt+0x2d8>
ffffffffc0204864:	02d00693          	li	a3,45
ffffffffc0204868:	0cd79163          	bne	a5,a3,ffffffffc020492a <vprintfmt+0x2b4>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc020486c:	00044783          	lbu	a5,0(s0)
ffffffffc0204870:	0007851b          	sext.w	a0,a5
ffffffffc0204874:	cf85                	beqz	a5,ffffffffc02048ac <vprintfmt+0x236>
ffffffffc0204876:	00140a13          	addi	s4,s0,1
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc020487a:	05e00413          	li	s0,94
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc020487e:	000c4563          	bltz	s8,ffffffffc0204888 <vprintfmt+0x212>
ffffffffc0204882:	3c7d                	addiw	s8,s8,-1
ffffffffc0204884:	036c0263          	beq	s8,s6,ffffffffc02048a8 <vprintfmt+0x232>
                    putch('?', putdat);
ffffffffc0204888:	85a6                	mv	a1,s1
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc020488a:	0e0c8e63          	beqz	s9,ffffffffc0204986 <vprintfmt+0x310>
ffffffffc020488e:	3781                	addiw	a5,a5,-32
ffffffffc0204890:	0ef47b63          	bgeu	s0,a5,ffffffffc0204986 <vprintfmt+0x310>
                    putch('?', putdat);
ffffffffc0204894:	03f00513          	li	a0,63
ffffffffc0204898:	9902                	jalr	s2
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc020489a:	000a4783          	lbu	a5,0(s4)
ffffffffc020489e:	3dfd                	addiw	s11,s11,-1
ffffffffc02048a0:	0a05                	addi	s4,s4,1
ffffffffc02048a2:	0007851b          	sext.w	a0,a5
ffffffffc02048a6:	ffe1                	bnez	a5,ffffffffc020487e <vprintfmt+0x208>
            for (; width > 0; width --) {
ffffffffc02048a8:	01b05963          	blez	s11,ffffffffc02048ba <vprintfmt+0x244>
ffffffffc02048ac:	3dfd                	addiw	s11,s11,-1
                putch(' ', putdat);
ffffffffc02048ae:	85a6                	mv	a1,s1
ffffffffc02048b0:	02000513          	li	a0,32
ffffffffc02048b4:	9902                	jalr	s2
            for (; width > 0; width --) {
ffffffffc02048b6:	fe0d9be3          	bnez	s11,ffffffffc02048ac <vprintfmt+0x236>
            if ((p = va_arg(ap, char *)) == NULL) {
ffffffffc02048ba:	6a02                	ld	s4,0(sp)
ffffffffc02048bc:	bbd5                	j	ffffffffc02046b0 <vprintfmt+0x3a>
    if (lflag >= 2) {
ffffffffc02048be:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc02048c0:	008a0c93          	addi	s9,s4,8
    if (lflag >= 2) {
ffffffffc02048c4:	01174463          	blt	a4,a7,ffffffffc02048cc <vprintfmt+0x256>
    else if (lflag) {
ffffffffc02048c8:	08088d63          	beqz	a7,ffffffffc0204962 <vprintfmt+0x2ec>
        return va_arg(*ap, long);
ffffffffc02048cc:	000a3403          	ld	s0,0(s4)
            if ((long long)num < 0) {
ffffffffc02048d0:	0a044d63          	bltz	s0,ffffffffc020498a <vprintfmt+0x314>
            num = getint(&ap, lflag);
ffffffffc02048d4:	8622                	mv	a2,s0
ffffffffc02048d6:	8a66                	mv	s4,s9
ffffffffc02048d8:	46a9                	li	a3,10
ffffffffc02048da:	bdcd                	j	ffffffffc02047cc <vprintfmt+0x156>
            err = va_arg(ap, int);
ffffffffc02048dc:	000a2783          	lw	a5,0(s4)
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
ffffffffc02048e0:	4719                	li	a4,6
            err = va_arg(ap, int);
ffffffffc02048e2:	0a21                	addi	s4,s4,8
            if (err < 0) {
ffffffffc02048e4:	41f7d69b          	sraiw	a3,a5,0x1f
ffffffffc02048e8:	8fb5                	xor	a5,a5,a3
ffffffffc02048ea:	40d786bb          	subw	a3,a5,a3
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
ffffffffc02048ee:	02d74163          	blt	a4,a3,ffffffffc0204910 <vprintfmt+0x29a>
ffffffffc02048f2:	00369793          	slli	a5,a3,0x3
ffffffffc02048f6:	97de                	add	a5,a5,s7
ffffffffc02048f8:	639c                	ld	a5,0(a5)
ffffffffc02048fa:	cb99                	beqz	a5,ffffffffc0204910 <vprintfmt+0x29a>
                printfmt(putch, putdat, "%s", p);
ffffffffc02048fc:	86be                	mv	a3,a5
ffffffffc02048fe:	00000617          	auipc	a2,0x0
ffffffffc0204902:	1f260613          	addi	a2,a2,498 # ffffffffc0204af0 <etext+0x2e>
ffffffffc0204906:	85a6                	mv	a1,s1
ffffffffc0204908:	854a                	mv	a0,s2
ffffffffc020490a:	0ce000ef          	jal	ra,ffffffffc02049d8 <printfmt>
ffffffffc020490e:	b34d                	j	ffffffffc02046b0 <vprintfmt+0x3a>
                printfmt(putch, putdat, "error %d", err);
ffffffffc0204910:	00002617          	auipc	a2,0x2
ffffffffc0204914:	fb860613          	addi	a2,a2,-72 # ffffffffc02068c8 <default_pmm_manager+0x10b0>
ffffffffc0204918:	85a6                	mv	a1,s1
ffffffffc020491a:	854a                	mv	a0,s2
ffffffffc020491c:	0bc000ef          	jal	ra,ffffffffc02049d8 <printfmt>
ffffffffc0204920:	bb41                	j	ffffffffc02046b0 <vprintfmt+0x3a>
                p = "(null)";
ffffffffc0204922:	00002417          	auipc	s0,0x2
ffffffffc0204926:	f9e40413          	addi	s0,s0,-98 # ffffffffc02068c0 <default_pmm_manager+0x10a8>
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc020492a:	85e2                	mv	a1,s8
ffffffffc020492c:	8522                	mv	a0,s0
ffffffffc020492e:	e43e                	sd	a5,8(sp)
ffffffffc0204930:	0e2000ef          	jal	ra,ffffffffc0204a12 <strnlen>
ffffffffc0204934:	40ad8dbb          	subw	s11,s11,a0
ffffffffc0204938:	01b05b63          	blez	s11,ffffffffc020494e <vprintfmt+0x2d8>
                    putch(padc, putdat);
ffffffffc020493c:	67a2                	ld	a5,8(sp)
ffffffffc020493e:	00078a1b          	sext.w	s4,a5
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc0204942:	3dfd                	addiw	s11,s11,-1
                    putch(padc, putdat);
ffffffffc0204944:	85a6                	mv	a1,s1
ffffffffc0204946:	8552                	mv	a0,s4
ffffffffc0204948:	9902                	jalr	s2
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc020494a:	fe0d9ce3          	bnez	s11,ffffffffc0204942 <vprintfmt+0x2cc>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc020494e:	00044783          	lbu	a5,0(s0)
ffffffffc0204952:	00140a13          	addi	s4,s0,1
ffffffffc0204956:	0007851b          	sext.w	a0,a5
ffffffffc020495a:	d3a5                	beqz	a5,ffffffffc02048ba <vprintfmt+0x244>
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc020495c:	05e00413          	li	s0,94
ffffffffc0204960:	bf39                	j	ffffffffc020487e <vprintfmt+0x208>
        return va_arg(*ap, int);
ffffffffc0204962:	000a2403          	lw	s0,0(s4)
ffffffffc0204966:	b7ad                	j	ffffffffc02048d0 <vprintfmt+0x25a>
        return va_arg(*ap, unsigned int);
ffffffffc0204968:	000a6603          	lwu	a2,0(s4)
ffffffffc020496c:	46a1                	li	a3,8
ffffffffc020496e:	8a2e                	mv	s4,a1
ffffffffc0204970:	bdb1                	j	ffffffffc02047cc <vprintfmt+0x156>
ffffffffc0204972:	000a6603          	lwu	a2,0(s4)
ffffffffc0204976:	46a9                	li	a3,10
ffffffffc0204978:	8a2e                	mv	s4,a1
ffffffffc020497a:	bd89                	j	ffffffffc02047cc <vprintfmt+0x156>
ffffffffc020497c:	000a6603          	lwu	a2,0(s4)
ffffffffc0204980:	46c1                	li	a3,16
ffffffffc0204982:	8a2e                	mv	s4,a1
ffffffffc0204984:	b5a1                	j	ffffffffc02047cc <vprintfmt+0x156>
                    putch(ch, putdat);
ffffffffc0204986:	9902                	jalr	s2
ffffffffc0204988:	bf09                	j	ffffffffc020489a <vprintfmt+0x224>
                putch('-', putdat);
ffffffffc020498a:	85a6                	mv	a1,s1
ffffffffc020498c:	02d00513          	li	a0,45
ffffffffc0204990:	e03e                	sd	a5,0(sp)
ffffffffc0204992:	9902                	jalr	s2
                num = -(long long)num;
ffffffffc0204994:	6782                	ld	a5,0(sp)
ffffffffc0204996:	8a66                	mv	s4,s9
ffffffffc0204998:	40800633          	neg	a2,s0
ffffffffc020499c:	46a9                	li	a3,10
ffffffffc020499e:	b53d                	j	ffffffffc02047cc <vprintfmt+0x156>
            if (width > 0 && padc != '-') {
ffffffffc02049a0:	03b05163          	blez	s11,ffffffffc02049c2 <vprintfmt+0x34c>
ffffffffc02049a4:	02d00693          	li	a3,45
ffffffffc02049a8:	f6d79de3          	bne	a5,a3,ffffffffc0204922 <vprintfmt+0x2ac>
                p = "(null)";
ffffffffc02049ac:	00002417          	auipc	s0,0x2
ffffffffc02049b0:	f1440413          	addi	s0,s0,-236 # ffffffffc02068c0 <default_pmm_manager+0x10a8>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc02049b4:	02800793          	li	a5,40
ffffffffc02049b8:	02800513          	li	a0,40
ffffffffc02049bc:	00140a13          	addi	s4,s0,1
ffffffffc02049c0:	bd6d                	j	ffffffffc020487a <vprintfmt+0x204>
ffffffffc02049c2:	00002a17          	auipc	s4,0x2
ffffffffc02049c6:	effa0a13          	addi	s4,s4,-257 # ffffffffc02068c1 <default_pmm_manager+0x10a9>
ffffffffc02049ca:	02800513          	li	a0,40
ffffffffc02049ce:	02800793          	li	a5,40
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc02049d2:	05e00413          	li	s0,94
ffffffffc02049d6:	b565                	j	ffffffffc020487e <vprintfmt+0x208>

ffffffffc02049d8 <printfmt>:
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
ffffffffc02049d8:	715d                	addi	sp,sp,-80
    va_start(ap, fmt);
ffffffffc02049da:	02810313          	addi	t1,sp,40
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
ffffffffc02049de:	f436                	sd	a3,40(sp)
    vprintfmt(putch, putdat, fmt, ap);
ffffffffc02049e0:	869a                	mv	a3,t1
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
ffffffffc02049e2:	ec06                	sd	ra,24(sp)
ffffffffc02049e4:	f83a                	sd	a4,48(sp)
ffffffffc02049e6:	fc3e                	sd	a5,56(sp)
ffffffffc02049e8:	e0c2                	sd	a6,64(sp)
ffffffffc02049ea:	e4c6                	sd	a7,72(sp)
    va_start(ap, fmt);
ffffffffc02049ec:	e41a                	sd	t1,8(sp)
    vprintfmt(putch, putdat, fmt, ap);
ffffffffc02049ee:	c89ff0ef          	jal	ra,ffffffffc0204676 <vprintfmt>
}
ffffffffc02049f2:	60e2                	ld	ra,24(sp)
ffffffffc02049f4:	6161                	addi	sp,sp,80
ffffffffc02049f6:	8082                	ret

ffffffffc02049f8 <strlen>:
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
ffffffffc02049f8:	00054783          	lbu	a5,0(a0)
strlen(const char *s) {
ffffffffc02049fc:	872a                	mv	a4,a0
    size_t cnt = 0;
ffffffffc02049fe:	4501                	li	a0,0
    while (*s ++ != '\0') {
ffffffffc0204a00:	cb81                	beqz	a5,ffffffffc0204a10 <strlen+0x18>
        cnt ++;
ffffffffc0204a02:	0505                	addi	a0,a0,1
    while (*s ++ != '\0') {
ffffffffc0204a04:	00a707b3          	add	a5,a4,a0
ffffffffc0204a08:	0007c783          	lbu	a5,0(a5)
ffffffffc0204a0c:	fbfd                	bnez	a5,ffffffffc0204a02 <strlen+0xa>
ffffffffc0204a0e:	8082                	ret
    }
    return cnt;
}
ffffffffc0204a10:	8082                	ret

ffffffffc0204a12 <strnlen>:
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
ffffffffc0204a12:	4781                	li	a5,0
    while (cnt < len && *s ++ != '\0') {
ffffffffc0204a14:	e589                	bnez	a1,ffffffffc0204a1e <strnlen+0xc>
ffffffffc0204a16:	a811                	j	ffffffffc0204a2a <strnlen+0x18>
        cnt ++;
ffffffffc0204a18:	0785                	addi	a5,a5,1
    while (cnt < len && *s ++ != '\0') {
ffffffffc0204a1a:	00f58863          	beq	a1,a5,ffffffffc0204a2a <strnlen+0x18>
ffffffffc0204a1e:	00f50733          	add	a4,a0,a5
ffffffffc0204a22:	00074703          	lbu	a4,0(a4)
ffffffffc0204a26:	fb6d                	bnez	a4,ffffffffc0204a18 <strnlen+0x6>
ffffffffc0204a28:	85be                	mv	a1,a5
    }
    return cnt;
}
ffffffffc0204a2a:	852e                	mv	a0,a1
ffffffffc0204a2c:	8082                	ret

ffffffffc0204a2e <strcpy>:
char *
strcpy(char *dst, const char *src) {
#ifdef __HAVE_ARCH_STRCPY
    return __strcpy(dst, src);
#else
    char *p = dst;
ffffffffc0204a2e:	87aa                	mv	a5,a0
    while ((*p ++ = *src ++) != '\0')
ffffffffc0204a30:	0005c703          	lbu	a4,0(a1)
ffffffffc0204a34:	0785                	addi	a5,a5,1
ffffffffc0204a36:	0585                	addi	a1,a1,1
ffffffffc0204a38:	fee78fa3          	sb	a4,-1(a5)
ffffffffc0204a3c:	fb75                	bnez	a4,ffffffffc0204a30 <strcpy+0x2>
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
ffffffffc0204a3e:	8082                	ret

ffffffffc0204a40 <strcmp>:
int
strcmp(const char *s1, const char *s2) {
#ifdef __HAVE_ARCH_STRCMP
    return __strcmp(s1, s2);
#else
    while (*s1 != '\0' && *s1 == *s2) {
ffffffffc0204a40:	00054783          	lbu	a5,0(a0)
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc0204a44:	0005c703          	lbu	a4,0(a1)
    while (*s1 != '\0' && *s1 == *s2) {
ffffffffc0204a48:	cb89                	beqz	a5,ffffffffc0204a5a <strcmp+0x1a>
        s1 ++, s2 ++;
ffffffffc0204a4a:	0505                	addi	a0,a0,1
ffffffffc0204a4c:	0585                	addi	a1,a1,1
    while (*s1 != '\0' && *s1 == *s2) {
ffffffffc0204a4e:	fee789e3          	beq	a5,a4,ffffffffc0204a40 <strcmp>
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc0204a52:	0007851b          	sext.w	a0,a5
#endif /* __HAVE_ARCH_STRCMP */
}
ffffffffc0204a56:	9d19                	subw	a0,a0,a4
ffffffffc0204a58:	8082                	ret
ffffffffc0204a5a:	4501                	li	a0,0
ffffffffc0204a5c:	bfed                	j	ffffffffc0204a56 <strcmp+0x16>

ffffffffc0204a5e <strchr>:
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
ffffffffc0204a5e:	00054783          	lbu	a5,0(a0)
ffffffffc0204a62:	c799                	beqz	a5,ffffffffc0204a70 <strchr+0x12>
        if (*s == c) {
ffffffffc0204a64:	00f58763          	beq	a1,a5,ffffffffc0204a72 <strchr+0x14>
    while (*s != '\0') {
ffffffffc0204a68:	00154783          	lbu	a5,1(a0)
            return (char *)s;
        }
        s ++;
ffffffffc0204a6c:	0505                	addi	a0,a0,1
    while (*s != '\0') {
ffffffffc0204a6e:	fbfd                	bnez	a5,ffffffffc0204a64 <strchr+0x6>
    }
    return NULL;
ffffffffc0204a70:	4501                	li	a0,0
}
ffffffffc0204a72:	8082                	ret

ffffffffc0204a74 <memset>:
memset(void *s, char c, size_t n) {
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
#else
    char *p = s;
    while (n -- > 0) {
ffffffffc0204a74:	ca01                	beqz	a2,ffffffffc0204a84 <memset+0x10>
ffffffffc0204a76:	962a                	add	a2,a2,a0
    char *p = s;
ffffffffc0204a78:	87aa                	mv	a5,a0
        *p ++ = c;
ffffffffc0204a7a:	0785                	addi	a5,a5,1
ffffffffc0204a7c:	feb78fa3          	sb	a1,-1(a5)
    while (n -- > 0) {
ffffffffc0204a80:	fec79de3          	bne	a5,a2,ffffffffc0204a7a <memset+0x6>
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
ffffffffc0204a84:	8082                	ret

ffffffffc0204a86 <memcpy>:
#ifdef __HAVE_ARCH_MEMCPY
    return __memcpy(dst, src, n);
#else
    const char *s = src;
    char *d = dst;
    while (n -- > 0) {
ffffffffc0204a86:	ca19                	beqz	a2,ffffffffc0204a9c <memcpy+0x16>
ffffffffc0204a88:	962e                	add	a2,a2,a1
    char *d = dst;
ffffffffc0204a8a:	87aa                	mv	a5,a0
        *d ++ = *s ++;
ffffffffc0204a8c:	0005c703          	lbu	a4,0(a1)
ffffffffc0204a90:	0585                	addi	a1,a1,1
ffffffffc0204a92:	0785                	addi	a5,a5,1
ffffffffc0204a94:	fee78fa3          	sb	a4,-1(a5)
    while (n -- > 0) {
ffffffffc0204a98:	fec59ae3          	bne	a1,a2,ffffffffc0204a8c <memcpy+0x6>
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
ffffffffc0204a9c:	8082                	ret

ffffffffc0204a9e <memcmp>:
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
    const char *s1 = (const char *)v1;
    const char *s2 = (const char *)v2;
    while (n -- > 0) {
ffffffffc0204a9e:	c205                	beqz	a2,ffffffffc0204abe <memcmp+0x20>
ffffffffc0204aa0:	962e                	add	a2,a2,a1
ffffffffc0204aa2:	a019                	j	ffffffffc0204aa8 <memcmp+0xa>
ffffffffc0204aa4:	00c58d63          	beq	a1,a2,ffffffffc0204abe <memcmp+0x20>
        if (*s1 != *s2) {
ffffffffc0204aa8:	00054783          	lbu	a5,0(a0)
ffffffffc0204aac:	0005c703          	lbu	a4,0(a1)
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
        }
        s1 ++, s2 ++;
ffffffffc0204ab0:	0505                	addi	a0,a0,1
ffffffffc0204ab2:	0585                	addi	a1,a1,1
        if (*s1 != *s2) {
ffffffffc0204ab4:	fee788e3          	beq	a5,a4,ffffffffc0204aa4 <memcmp+0x6>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc0204ab8:	40e7853b          	subw	a0,a5,a4
ffffffffc0204abc:	8082                	ret
    }
    return 0;
ffffffffc0204abe:	4501                	li	a0,0
}
ffffffffc0204ac0:	8082                	ret
