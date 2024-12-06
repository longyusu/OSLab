
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
ffffffffc0200036:	fee50513          	addi	a0,a0,-18 # ffffffffc020a020 <buf>
ffffffffc020003a:	00015617          	auipc	a2,0x15
ffffffffc020003e:	4b260613          	addi	a2,a2,1202 # ffffffffc02154ec <end>
kern_init(void) {
ffffffffc0200042:	1141                	addi	sp,sp,-16
    memset(edata, 0, end - edata);
ffffffffc0200044:	8e09                	sub	a2,a2,a0
ffffffffc0200046:	4581                	li	a1,0
kern_init(void) {
ffffffffc0200048:	e406                	sd	ra,8(sp)
    memset(edata, 0, end - edata);
ffffffffc020004a:	134040ef          	jal	ra,ffffffffc020417e <memset>

    cons_init();                // init the console
ffffffffc020004e:	4a2000ef          	jal	ra,ffffffffc02004f0 <cons_init>

    const char *message = "(THU.CST) os is loading ...";
    cprintf("%s\n\n", message);
ffffffffc0200052:	00004597          	auipc	a1,0x4
ffffffffc0200056:	17e58593          	addi	a1,a1,382 # ffffffffc02041d0 <etext+0x4>
ffffffffc020005a:	00004517          	auipc	a0,0x4
ffffffffc020005e:	19650513          	addi	a0,a0,406 # ffffffffc02041f0 <etext+0x24>
ffffffffc0200062:	11a000ef          	jal	ra,ffffffffc020017c <cprintf>

    print_kerninfo();
ffffffffc0200066:	15e000ef          	jal	ra,ffffffffc02001c4 <print_kerninfo>

    // grade_backtrace();

    pmm_init();                 // init physical memory management
ffffffffc020006a:	6d5010ef          	jal	ra,ffffffffc0201f3e <pmm_init>

    pic_init();                 // init interrupt controller
ffffffffc020006e:	526000ef          	jal	ra,ffffffffc0200594 <pic_init>
    idt_init();                 // init interrupt descriptor table
ffffffffc0200072:	594000ef          	jal	ra,ffffffffc0200606 <idt_init>

    vmm_init();                 // init virtual memory management
ffffffffc0200076:	5e9020ef          	jal	ra,ffffffffc0202e5e <vmm_init>
    proc_init();                // init process table
ffffffffc020007a:	11f030ef          	jal	ra,ffffffffc0203998 <proc_init>
    
    ide_init();                 // init ide devices
ffffffffc020007e:	4e4000ef          	jal	ra,ffffffffc0200562 <ide_init>
    //swap_init();                // init swap

    clock_init();               // init clock interrupt
ffffffffc0200082:	41c000ef          	jal	ra,ffffffffc020049e <clock_init>
    intr_enable();              // enable irq interrupt
ffffffffc0200086:	502000ef          	jal	ra,ffffffffc0200588 <intr_enable>

    cpu_idle();                 // run idle process
ffffffffc020008a:	35b030ef          	jal	ra,ffffffffc0203be4 <cpu_idle>

ffffffffc020008e <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
ffffffffc020008e:	715d                	addi	sp,sp,-80
ffffffffc0200090:	e486                	sd	ra,72(sp)
ffffffffc0200092:	e0a6                	sd	s1,64(sp)
ffffffffc0200094:	fc4a                	sd	s2,56(sp)
ffffffffc0200096:	f84e                	sd	s3,48(sp)
ffffffffc0200098:	f452                	sd	s4,40(sp)
ffffffffc020009a:	f056                	sd	s5,32(sp)
ffffffffc020009c:	ec5a                	sd	s6,24(sp)
ffffffffc020009e:	e85e                	sd	s7,16(sp)
    if (prompt != NULL) {
ffffffffc02000a0:	c901                	beqz	a0,ffffffffc02000b0 <readline+0x22>
ffffffffc02000a2:	85aa                	mv	a1,a0
        cprintf("%s", prompt);
ffffffffc02000a4:	00004517          	auipc	a0,0x4
ffffffffc02000a8:	15450513          	addi	a0,a0,340 # ffffffffc02041f8 <etext+0x2c>
ffffffffc02000ac:	0d0000ef          	jal	ra,ffffffffc020017c <cprintf>
readline(const char *prompt) {
ffffffffc02000b0:	4481                	li	s1,0
    while (1) {
        c = getchar();
        if (c < 0) {
            return NULL;
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
ffffffffc02000b2:	497d                	li	s2,31
            cputchar(c);
            buf[i ++] = c;
        }
        else if (c == '\b' && i > 0) {
ffffffffc02000b4:	49a1                	li	s3,8
            cputchar(c);
            i --;
        }
        else if (c == '\n' || c == '\r') {
ffffffffc02000b6:	4aa9                	li	s5,10
ffffffffc02000b8:	4b35                	li	s6,13
            buf[i ++] = c;
ffffffffc02000ba:	0000ab97          	auipc	s7,0xa
ffffffffc02000be:	f66b8b93          	addi	s7,s7,-154 # ffffffffc020a020 <buf>
        else if (c >= ' ' && i < BUFSIZE - 1) {
ffffffffc02000c2:	3fe00a13          	li	s4,1022
        c = getchar();
ffffffffc02000c6:	0ee000ef          	jal	ra,ffffffffc02001b4 <getchar>
        if (c < 0) {
ffffffffc02000ca:	00054a63          	bltz	a0,ffffffffc02000de <readline+0x50>
        else if (c >= ' ' && i < BUFSIZE - 1) {
ffffffffc02000ce:	00a95a63          	bge	s2,a0,ffffffffc02000e2 <readline+0x54>
ffffffffc02000d2:	029a5263          	bge	s4,s1,ffffffffc02000f6 <readline+0x68>
        c = getchar();
ffffffffc02000d6:	0de000ef          	jal	ra,ffffffffc02001b4 <getchar>
        if (c < 0) {
ffffffffc02000da:	fe055ae3          	bgez	a0,ffffffffc02000ce <readline+0x40>
            return NULL;
ffffffffc02000de:	4501                	li	a0,0
ffffffffc02000e0:	a091                	j	ffffffffc0200124 <readline+0x96>
        else if (c == '\b' && i > 0) {
ffffffffc02000e2:	03351463          	bne	a0,s3,ffffffffc020010a <readline+0x7c>
ffffffffc02000e6:	e8a9                	bnez	s1,ffffffffc0200138 <readline+0xaa>
        c = getchar();
ffffffffc02000e8:	0cc000ef          	jal	ra,ffffffffc02001b4 <getchar>
        if (c < 0) {
ffffffffc02000ec:	fe0549e3          	bltz	a0,ffffffffc02000de <readline+0x50>
        else if (c >= ' ' && i < BUFSIZE - 1) {
ffffffffc02000f0:	fea959e3          	bge	s2,a0,ffffffffc02000e2 <readline+0x54>
ffffffffc02000f4:	4481                	li	s1,0
            cputchar(c);
ffffffffc02000f6:	e42a                	sd	a0,8(sp)
ffffffffc02000f8:	0ba000ef          	jal	ra,ffffffffc02001b2 <cputchar>
            buf[i ++] = c;
ffffffffc02000fc:	6522                	ld	a0,8(sp)
ffffffffc02000fe:	009b87b3          	add	a5,s7,s1
ffffffffc0200102:	2485                	addiw	s1,s1,1
ffffffffc0200104:	00a78023          	sb	a0,0(a5)
ffffffffc0200108:	bf7d                	j	ffffffffc02000c6 <readline+0x38>
        else if (c == '\n' || c == '\r') {
ffffffffc020010a:	01550463          	beq	a0,s5,ffffffffc0200112 <readline+0x84>
ffffffffc020010e:	fb651ce3          	bne	a0,s6,ffffffffc02000c6 <readline+0x38>
            cputchar(c);
ffffffffc0200112:	0a0000ef          	jal	ra,ffffffffc02001b2 <cputchar>
            buf[i] = '\0';
ffffffffc0200116:	0000a517          	auipc	a0,0xa
ffffffffc020011a:	f0a50513          	addi	a0,a0,-246 # ffffffffc020a020 <buf>
ffffffffc020011e:	94aa                	add	s1,s1,a0
ffffffffc0200120:	00048023          	sb	zero,0(s1)
            return buf;
        }
    }
}
ffffffffc0200124:	60a6                	ld	ra,72(sp)
ffffffffc0200126:	6486                	ld	s1,64(sp)
ffffffffc0200128:	7962                	ld	s2,56(sp)
ffffffffc020012a:	79c2                	ld	s3,48(sp)
ffffffffc020012c:	7a22                	ld	s4,40(sp)
ffffffffc020012e:	7a82                	ld	s5,32(sp)
ffffffffc0200130:	6b62                	ld	s6,24(sp)
ffffffffc0200132:	6bc2                	ld	s7,16(sp)
ffffffffc0200134:	6161                	addi	sp,sp,80
ffffffffc0200136:	8082                	ret
            cputchar(c);
ffffffffc0200138:	4521                	li	a0,8
ffffffffc020013a:	078000ef          	jal	ra,ffffffffc02001b2 <cputchar>
            i --;
ffffffffc020013e:	34fd                	addiw	s1,s1,-1
ffffffffc0200140:	b759                	j	ffffffffc02000c6 <readline+0x38>

ffffffffc0200142 <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
ffffffffc0200142:	1141                	addi	sp,sp,-16
ffffffffc0200144:	e022                	sd	s0,0(sp)
ffffffffc0200146:	e406                	sd	ra,8(sp)
ffffffffc0200148:	842e                	mv	s0,a1
    cons_putc(c);
ffffffffc020014a:	3a8000ef          	jal	ra,ffffffffc02004f2 <cons_putc>
    (*cnt) ++;
ffffffffc020014e:	401c                	lw	a5,0(s0)
}
ffffffffc0200150:	60a2                	ld	ra,8(sp)
    (*cnt) ++;
ffffffffc0200152:	2785                	addiw	a5,a5,1
ffffffffc0200154:	c01c                	sw	a5,0(s0)
}
ffffffffc0200156:	6402                	ld	s0,0(sp)
ffffffffc0200158:	0141                	addi	sp,sp,16
ffffffffc020015a:	8082                	ret

ffffffffc020015c <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
ffffffffc020015c:	1101                	addi	sp,sp,-32
ffffffffc020015e:	862a                	mv	a2,a0
ffffffffc0200160:	86ae                	mv	a3,a1
    int cnt = 0;
    vprintfmt((void*)cputch, &cnt, fmt, ap);
ffffffffc0200162:	00000517          	auipc	a0,0x0
ffffffffc0200166:	fe050513          	addi	a0,a0,-32 # ffffffffc0200142 <cputch>
ffffffffc020016a:	006c                	addi	a1,sp,12
vcprintf(const char *fmt, va_list ap) {
ffffffffc020016c:	ec06                	sd	ra,24(sp)
    int cnt = 0;
ffffffffc020016e:	c602                	sw	zero,12(sp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
ffffffffc0200170:	411030ef          	jal	ra,ffffffffc0203d80 <vprintfmt>
    return cnt;
}
ffffffffc0200174:	60e2                	ld	ra,24(sp)
ffffffffc0200176:	4532                	lw	a0,12(sp)
ffffffffc0200178:	6105                	addi	sp,sp,32
ffffffffc020017a:	8082                	ret

ffffffffc020017c <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
ffffffffc020017c:	711d                	addi	sp,sp,-96
    va_list ap;
    int cnt;
    va_start(ap, fmt);
ffffffffc020017e:	02810313          	addi	t1,sp,40 # ffffffffc0209028 <boot_page_table_sv39+0x28>
cprintf(const char *fmt, ...) {
ffffffffc0200182:	8e2a                	mv	t3,a0
ffffffffc0200184:	f42e                	sd	a1,40(sp)
ffffffffc0200186:	f832                	sd	a2,48(sp)
ffffffffc0200188:	fc36                	sd	a3,56(sp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
ffffffffc020018a:	00000517          	auipc	a0,0x0
ffffffffc020018e:	fb850513          	addi	a0,a0,-72 # ffffffffc0200142 <cputch>
ffffffffc0200192:	004c                	addi	a1,sp,4
ffffffffc0200194:	869a                	mv	a3,t1
ffffffffc0200196:	8672                	mv	a2,t3
cprintf(const char *fmt, ...) {
ffffffffc0200198:	ec06                	sd	ra,24(sp)
ffffffffc020019a:	e0ba                	sd	a4,64(sp)
ffffffffc020019c:	e4be                	sd	a5,72(sp)
ffffffffc020019e:	e8c2                	sd	a6,80(sp)
ffffffffc02001a0:	ecc6                	sd	a7,88(sp)
    va_start(ap, fmt);
ffffffffc02001a2:	e41a                	sd	t1,8(sp)
    int cnt = 0;
ffffffffc02001a4:	c202                	sw	zero,4(sp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
ffffffffc02001a6:	3db030ef          	jal	ra,ffffffffc0203d80 <vprintfmt>
    cnt = vcprintf(fmt, ap);
    va_end(ap);
    return cnt;
}
ffffffffc02001aa:	60e2                	ld	ra,24(sp)
ffffffffc02001ac:	4512                	lw	a0,4(sp)
ffffffffc02001ae:	6125                	addi	sp,sp,96
ffffffffc02001b0:	8082                	ret

ffffffffc02001b2 <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
    cons_putc(c);
ffffffffc02001b2:	a681                	j	ffffffffc02004f2 <cons_putc>

ffffffffc02001b4 <getchar>:
    return cnt;
}

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
ffffffffc02001b4:	1141                	addi	sp,sp,-16
ffffffffc02001b6:	e406                	sd	ra,8(sp)
    int c;
    while ((c = cons_getc()) == 0)
ffffffffc02001b8:	36e000ef          	jal	ra,ffffffffc0200526 <cons_getc>
ffffffffc02001bc:	dd75                	beqz	a0,ffffffffc02001b8 <getchar+0x4>
        /* do nothing */;
    return c;
}
ffffffffc02001be:	60a2                	ld	ra,8(sp)
ffffffffc02001c0:	0141                	addi	sp,sp,16
ffffffffc02001c2:	8082                	ret

ffffffffc02001c4 <print_kerninfo>:
/* *
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void print_kerninfo(void) {
ffffffffc02001c4:	1141                	addi	sp,sp,-16
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
ffffffffc02001c6:	00004517          	auipc	a0,0x4
ffffffffc02001ca:	03a50513          	addi	a0,a0,58 # ffffffffc0204200 <etext+0x34>
void print_kerninfo(void) {
ffffffffc02001ce:	e406                	sd	ra,8(sp)
    cprintf("Special kernel symbols:\n");
ffffffffc02001d0:	fadff0ef          	jal	ra,ffffffffc020017c <cprintf>
    cprintf("  entry  0x%08x (virtual)\n", kern_init);
ffffffffc02001d4:	00000597          	auipc	a1,0x0
ffffffffc02001d8:	e5e58593          	addi	a1,a1,-418 # ffffffffc0200032 <kern_init>
ffffffffc02001dc:	00004517          	auipc	a0,0x4
ffffffffc02001e0:	04450513          	addi	a0,a0,68 # ffffffffc0204220 <etext+0x54>
ffffffffc02001e4:	f99ff0ef          	jal	ra,ffffffffc020017c <cprintf>
    cprintf("  etext  0x%08x (virtual)\n", etext);
ffffffffc02001e8:	00004597          	auipc	a1,0x4
ffffffffc02001ec:	fe458593          	addi	a1,a1,-28 # ffffffffc02041cc <etext>
ffffffffc02001f0:	00004517          	auipc	a0,0x4
ffffffffc02001f4:	05050513          	addi	a0,a0,80 # ffffffffc0204240 <etext+0x74>
ffffffffc02001f8:	f85ff0ef          	jal	ra,ffffffffc020017c <cprintf>
    cprintf("  edata  0x%08x (virtual)\n", edata);
ffffffffc02001fc:	0000a597          	auipc	a1,0xa
ffffffffc0200200:	e2458593          	addi	a1,a1,-476 # ffffffffc020a020 <buf>
ffffffffc0200204:	00004517          	auipc	a0,0x4
ffffffffc0200208:	05c50513          	addi	a0,a0,92 # ffffffffc0204260 <etext+0x94>
ffffffffc020020c:	f71ff0ef          	jal	ra,ffffffffc020017c <cprintf>
    cprintf("  end    0x%08x (virtual)\n", end);
ffffffffc0200210:	00015597          	auipc	a1,0x15
ffffffffc0200214:	2dc58593          	addi	a1,a1,732 # ffffffffc02154ec <end>
ffffffffc0200218:	00004517          	auipc	a0,0x4
ffffffffc020021c:	06850513          	addi	a0,a0,104 # ffffffffc0204280 <etext+0xb4>
ffffffffc0200220:	f5dff0ef          	jal	ra,ffffffffc020017c <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n",
            (end - kern_init + 1023) / 1024);
ffffffffc0200224:	00015597          	auipc	a1,0x15
ffffffffc0200228:	6c758593          	addi	a1,a1,1735 # ffffffffc02158eb <end+0x3ff>
ffffffffc020022c:	00000797          	auipc	a5,0x0
ffffffffc0200230:	e0678793          	addi	a5,a5,-506 # ffffffffc0200032 <kern_init>
ffffffffc0200234:	40f587b3          	sub	a5,a1,a5
    cprintf("Kernel executable memory footprint: %dKB\n",
ffffffffc0200238:	43f7d593          	srai	a1,a5,0x3f
}
ffffffffc020023c:	60a2                	ld	ra,8(sp)
    cprintf("Kernel executable memory footprint: %dKB\n",
ffffffffc020023e:	3ff5f593          	andi	a1,a1,1023
ffffffffc0200242:	95be                	add	a1,a1,a5
ffffffffc0200244:	85a9                	srai	a1,a1,0xa
ffffffffc0200246:	00004517          	auipc	a0,0x4
ffffffffc020024a:	05a50513          	addi	a0,a0,90 # ffffffffc02042a0 <etext+0xd4>
}
ffffffffc020024e:	0141                	addi	sp,sp,16
    cprintf("Kernel executable memory footprint: %dKB\n",
ffffffffc0200250:	b735                	j	ffffffffc020017c <cprintf>

ffffffffc0200252 <print_stackframe>:
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before
 * jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the
 * boundary.
 * */
void print_stackframe(void) {
ffffffffc0200252:	1141                	addi	sp,sp,-16
    panic("Not Implemented!");
ffffffffc0200254:	00004617          	auipc	a2,0x4
ffffffffc0200258:	07c60613          	addi	a2,a2,124 # ffffffffc02042d0 <etext+0x104>
ffffffffc020025c:	04d00593          	li	a1,77
ffffffffc0200260:	00004517          	auipc	a0,0x4
ffffffffc0200264:	08850513          	addi	a0,a0,136 # ffffffffc02042e8 <etext+0x11c>
void print_stackframe(void) {
ffffffffc0200268:	e406                	sd	ra,8(sp)
    panic("Not Implemented!");
ffffffffc020026a:	1d8000ef          	jal	ra,ffffffffc0200442 <__panic>

ffffffffc020026e <mon_help>:
    }
}

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
ffffffffc020026e:	1141                	addi	sp,sp,-16
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
ffffffffc0200270:	00004617          	auipc	a2,0x4
ffffffffc0200274:	09060613          	addi	a2,a2,144 # ffffffffc0204300 <etext+0x134>
ffffffffc0200278:	00004597          	auipc	a1,0x4
ffffffffc020027c:	0a858593          	addi	a1,a1,168 # ffffffffc0204320 <etext+0x154>
ffffffffc0200280:	00004517          	auipc	a0,0x4
ffffffffc0200284:	0a850513          	addi	a0,a0,168 # ffffffffc0204328 <etext+0x15c>
mon_help(int argc, char **argv, struct trapframe *tf) {
ffffffffc0200288:	e406                	sd	ra,8(sp)
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
ffffffffc020028a:	ef3ff0ef          	jal	ra,ffffffffc020017c <cprintf>
ffffffffc020028e:	00004617          	auipc	a2,0x4
ffffffffc0200292:	0aa60613          	addi	a2,a2,170 # ffffffffc0204338 <etext+0x16c>
ffffffffc0200296:	00004597          	auipc	a1,0x4
ffffffffc020029a:	0ca58593          	addi	a1,a1,202 # ffffffffc0204360 <etext+0x194>
ffffffffc020029e:	00004517          	auipc	a0,0x4
ffffffffc02002a2:	08a50513          	addi	a0,a0,138 # ffffffffc0204328 <etext+0x15c>
ffffffffc02002a6:	ed7ff0ef          	jal	ra,ffffffffc020017c <cprintf>
ffffffffc02002aa:	00004617          	auipc	a2,0x4
ffffffffc02002ae:	0c660613          	addi	a2,a2,198 # ffffffffc0204370 <etext+0x1a4>
ffffffffc02002b2:	00004597          	auipc	a1,0x4
ffffffffc02002b6:	0de58593          	addi	a1,a1,222 # ffffffffc0204390 <etext+0x1c4>
ffffffffc02002ba:	00004517          	auipc	a0,0x4
ffffffffc02002be:	06e50513          	addi	a0,a0,110 # ffffffffc0204328 <etext+0x15c>
ffffffffc02002c2:	ebbff0ef          	jal	ra,ffffffffc020017c <cprintf>
    }
    return 0;
}
ffffffffc02002c6:	60a2                	ld	ra,8(sp)
ffffffffc02002c8:	4501                	li	a0,0
ffffffffc02002ca:	0141                	addi	sp,sp,16
ffffffffc02002cc:	8082                	ret

ffffffffc02002ce <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
ffffffffc02002ce:	1141                	addi	sp,sp,-16
ffffffffc02002d0:	e406                	sd	ra,8(sp)
    print_kerninfo();
ffffffffc02002d2:	ef3ff0ef          	jal	ra,ffffffffc02001c4 <print_kerninfo>
    return 0;
}
ffffffffc02002d6:	60a2                	ld	ra,8(sp)
ffffffffc02002d8:	4501                	li	a0,0
ffffffffc02002da:	0141                	addi	sp,sp,16
ffffffffc02002dc:	8082                	ret

ffffffffc02002de <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
ffffffffc02002de:	1141                	addi	sp,sp,-16
ffffffffc02002e0:	e406                	sd	ra,8(sp)
    print_stackframe();
ffffffffc02002e2:	f71ff0ef          	jal	ra,ffffffffc0200252 <print_stackframe>
    return 0;
}
ffffffffc02002e6:	60a2                	ld	ra,8(sp)
ffffffffc02002e8:	4501                	li	a0,0
ffffffffc02002ea:	0141                	addi	sp,sp,16
ffffffffc02002ec:	8082                	ret

ffffffffc02002ee <kmonitor>:
kmonitor(struct trapframe *tf) {
ffffffffc02002ee:	7115                	addi	sp,sp,-224
ffffffffc02002f0:	ed5e                	sd	s7,152(sp)
ffffffffc02002f2:	8baa                	mv	s7,a0
    cprintf("Welcome to the kernel debug monitor!!\n");
ffffffffc02002f4:	00004517          	auipc	a0,0x4
ffffffffc02002f8:	0ac50513          	addi	a0,a0,172 # ffffffffc02043a0 <etext+0x1d4>
kmonitor(struct trapframe *tf) {
ffffffffc02002fc:	ed86                	sd	ra,216(sp)
ffffffffc02002fe:	e9a2                	sd	s0,208(sp)
ffffffffc0200300:	e5a6                	sd	s1,200(sp)
ffffffffc0200302:	e1ca                	sd	s2,192(sp)
ffffffffc0200304:	fd4e                	sd	s3,184(sp)
ffffffffc0200306:	f952                	sd	s4,176(sp)
ffffffffc0200308:	f556                	sd	s5,168(sp)
ffffffffc020030a:	f15a                	sd	s6,160(sp)
ffffffffc020030c:	e962                	sd	s8,144(sp)
ffffffffc020030e:	e566                	sd	s9,136(sp)
ffffffffc0200310:	e16a                	sd	s10,128(sp)
    cprintf("Welcome to the kernel debug monitor!!\n");
ffffffffc0200312:	e6bff0ef          	jal	ra,ffffffffc020017c <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
ffffffffc0200316:	00004517          	auipc	a0,0x4
ffffffffc020031a:	0b250513          	addi	a0,a0,178 # ffffffffc02043c8 <etext+0x1fc>
ffffffffc020031e:	e5fff0ef          	jal	ra,ffffffffc020017c <cprintf>
    if (tf != NULL) {
ffffffffc0200322:	000b8563          	beqz	s7,ffffffffc020032c <kmonitor+0x3e>
        print_trapframe(tf);
ffffffffc0200326:	855e                	mv	a0,s7
ffffffffc0200328:	4c4000ef          	jal	ra,ffffffffc02007ec <print_trapframe>
#endif
}

static inline void sbi_shutdown(void)
{
	SBI_CALL_0(SBI_SHUTDOWN);
ffffffffc020032c:	4501                	li	a0,0
ffffffffc020032e:	4581                	li	a1,0
ffffffffc0200330:	4601                	li	a2,0
ffffffffc0200332:	48a1                	li	a7,8
ffffffffc0200334:	00000073          	ecall
ffffffffc0200338:	00004c17          	auipc	s8,0x4
ffffffffc020033c:	100c0c13          	addi	s8,s8,256 # ffffffffc0204438 <commands>
        if ((buf = readline("K> ")) != NULL) {
ffffffffc0200340:	00004917          	auipc	s2,0x4
ffffffffc0200344:	0b090913          	addi	s2,s2,176 # ffffffffc02043f0 <etext+0x224>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
ffffffffc0200348:	00004497          	auipc	s1,0x4
ffffffffc020034c:	0b048493          	addi	s1,s1,176 # ffffffffc02043f8 <etext+0x22c>
        if (argc == MAXARGS - 1) {
ffffffffc0200350:	49bd                	li	s3,15
            cprintf("Too many arguments (max %d).\n", MAXARGS);
ffffffffc0200352:	00004b17          	auipc	s6,0x4
ffffffffc0200356:	0aeb0b13          	addi	s6,s6,174 # ffffffffc0204400 <etext+0x234>
        argv[argc ++] = buf;
ffffffffc020035a:	00004a17          	auipc	s4,0x4
ffffffffc020035e:	fc6a0a13          	addi	s4,s4,-58 # ffffffffc0204320 <etext+0x154>
    for (i = 0; i < NCOMMANDS; i ++) {
ffffffffc0200362:	4a8d                	li	s5,3
        if ((buf = readline("K> ")) != NULL) {
ffffffffc0200364:	854a                	mv	a0,s2
ffffffffc0200366:	d29ff0ef          	jal	ra,ffffffffc020008e <readline>
ffffffffc020036a:	842a                	mv	s0,a0
ffffffffc020036c:	dd65                	beqz	a0,ffffffffc0200364 <kmonitor+0x76>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
ffffffffc020036e:	00054583          	lbu	a1,0(a0)
    int argc = 0;
ffffffffc0200372:	4c81                	li	s9,0
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
ffffffffc0200374:	e1bd                	bnez	a1,ffffffffc02003da <kmonitor+0xec>
    if (argc == 0) {
ffffffffc0200376:	fe0c87e3          	beqz	s9,ffffffffc0200364 <kmonitor+0x76>
        if (strcmp(commands[i].name, argv[0]) == 0) {
ffffffffc020037a:	6582                	ld	a1,0(sp)
ffffffffc020037c:	00004d17          	auipc	s10,0x4
ffffffffc0200380:	0bcd0d13          	addi	s10,s10,188 # ffffffffc0204438 <commands>
        argv[argc ++] = buf;
ffffffffc0200384:	8552                	mv	a0,s4
    for (i = 0; i < NCOMMANDS; i ++) {
ffffffffc0200386:	4401                	li	s0,0
ffffffffc0200388:	0d61                	addi	s10,s10,24
        if (strcmp(commands[i].name, argv[0]) == 0) {
ffffffffc020038a:	5c1030ef          	jal	ra,ffffffffc020414a <strcmp>
ffffffffc020038e:	c919                	beqz	a0,ffffffffc02003a4 <kmonitor+0xb6>
    for (i = 0; i < NCOMMANDS; i ++) {
ffffffffc0200390:	2405                	addiw	s0,s0,1
ffffffffc0200392:	0b540063          	beq	s0,s5,ffffffffc0200432 <kmonitor+0x144>
        if (strcmp(commands[i].name, argv[0]) == 0) {
ffffffffc0200396:	000d3503          	ld	a0,0(s10)
ffffffffc020039a:	6582                	ld	a1,0(sp)
    for (i = 0; i < NCOMMANDS; i ++) {
ffffffffc020039c:	0d61                	addi	s10,s10,24
        if (strcmp(commands[i].name, argv[0]) == 0) {
ffffffffc020039e:	5ad030ef          	jal	ra,ffffffffc020414a <strcmp>
ffffffffc02003a2:	f57d                	bnez	a0,ffffffffc0200390 <kmonitor+0xa2>
            return commands[i].func(argc - 1, argv + 1, tf);
ffffffffc02003a4:	00141793          	slli	a5,s0,0x1
ffffffffc02003a8:	97a2                	add	a5,a5,s0
ffffffffc02003aa:	078e                	slli	a5,a5,0x3
ffffffffc02003ac:	97e2                	add	a5,a5,s8
ffffffffc02003ae:	6b9c                	ld	a5,16(a5)
ffffffffc02003b0:	865e                	mv	a2,s7
ffffffffc02003b2:	002c                	addi	a1,sp,8
ffffffffc02003b4:	fffc851b          	addiw	a0,s9,-1
ffffffffc02003b8:	9782                	jalr	a5
            if (runcmd(buf, tf) < 0) {
ffffffffc02003ba:	fa0555e3          	bgez	a0,ffffffffc0200364 <kmonitor+0x76>
}
ffffffffc02003be:	60ee                	ld	ra,216(sp)
ffffffffc02003c0:	644e                	ld	s0,208(sp)
ffffffffc02003c2:	64ae                	ld	s1,200(sp)
ffffffffc02003c4:	690e                	ld	s2,192(sp)
ffffffffc02003c6:	79ea                	ld	s3,184(sp)
ffffffffc02003c8:	7a4a                	ld	s4,176(sp)
ffffffffc02003ca:	7aaa                	ld	s5,168(sp)
ffffffffc02003cc:	7b0a                	ld	s6,160(sp)
ffffffffc02003ce:	6bea                	ld	s7,152(sp)
ffffffffc02003d0:	6c4a                	ld	s8,144(sp)
ffffffffc02003d2:	6caa                	ld	s9,136(sp)
ffffffffc02003d4:	6d0a                	ld	s10,128(sp)
ffffffffc02003d6:	612d                	addi	sp,sp,224
ffffffffc02003d8:	8082                	ret
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
ffffffffc02003da:	8526                	mv	a0,s1
ffffffffc02003dc:	58d030ef          	jal	ra,ffffffffc0204168 <strchr>
ffffffffc02003e0:	c901                	beqz	a0,ffffffffc02003f0 <kmonitor+0x102>
ffffffffc02003e2:	00144583          	lbu	a1,1(s0)
            *buf ++ = '\0';
ffffffffc02003e6:	00040023          	sb	zero,0(s0)
ffffffffc02003ea:	0405                	addi	s0,s0,1
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
ffffffffc02003ec:	d5c9                	beqz	a1,ffffffffc0200376 <kmonitor+0x88>
ffffffffc02003ee:	b7f5                	j	ffffffffc02003da <kmonitor+0xec>
        if (*buf == '\0') {
ffffffffc02003f0:	00044783          	lbu	a5,0(s0)
ffffffffc02003f4:	d3c9                	beqz	a5,ffffffffc0200376 <kmonitor+0x88>
        if (argc == MAXARGS - 1) {
ffffffffc02003f6:	033c8963          	beq	s9,s3,ffffffffc0200428 <kmonitor+0x13a>
        argv[argc ++] = buf;
ffffffffc02003fa:	003c9793          	slli	a5,s9,0x3
ffffffffc02003fe:	0118                	addi	a4,sp,128
ffffffffc0200400:	97ba                	add	a5,a5,a4
ffffffffc0200402:	f887b023          	sd	s0,-128(a5)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
ffffffffc0200406:	00044583          	lbu	a1,0(s0)
        argv[argc ++] = buf;
ffffffffc020040a:	2c85                	addiw	s9,s9,1
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
ffffffffc020040c:	e591                	bnez	a1,ffffffffc0200418 <kmonitor+0x12a>
ffffffffc020040e:	b7b5                	j	ffffffffc020037a <kmonitor+0x8c>
ffffffffc0200410:	00144583          	lbu	a1,1(s0)
            buf ++;
ffffffffc0200414:	0405                	addi	s0,s0,1
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
ffffffffc0200416:	d1a5                	beqz	a1,ffffffffc0200376 <kmonitor+0x88>
ffffffffc0200418:	8526                	mv	a0,s1
ffffffffc020041a:	54f030ef          	jal	ra,ffffffffc0204168 <strchr>
ffffffffc020041e:	d96d                	beqz	a0,ffffffffc0200410 <kmonitor+0x122>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
ffffffffc0200420:	00044583          	lbu	a1,0(s0)
ffffffffc0200424:	d9a9                	beqz	a1,ffffffffc0200376 <kmonitor+0x88>
ffffffffc0200426:	bf55                	j	ffffffffc02003da <kmonitor+0xec>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
ffffffffc0200428:	45c1                	li	a1,16
ffffffffc020042a:	855a                	mv	a0,s6
ffffffffc020042c:	d51ff0ef          	jal	ra,ffffffffc020017c <cprintf>
ffffffffc0200430:	b7e9                	j	ffffffffc02003fa <kmonitor+0x10c>
    cprintf("Unknown command '%s'\n", argv[0]);
ffffffffc0200432:	6582                	ld	a1,0(sp)
ffffffffc0200434:	00004517          	auipc	a0,0x4
ffffffffc0200438:	fec50513          	addi	a0,a0,-20 # ffffffffc0204420 <etext+0x254>
ffffffffc020043c:	d41ff0ef          	jal	ra,ffffffffc020017c <cprintf>
    return 0;
ffffffffc0200440:	b715                	j	ffffffffc0200364 <kmonitor+0x76>

ffffffffc0200442 <__panic>:
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
    if (is_panic) {
ffffffffc0200442:	00015317          	auipc	t1,0x15
ffffffffc0200446:	01630313          	addi	t1,t1,22 # ffffffffc0215458 <is_panic>
ffffffffc020044a:	00032e03          	lw	t3,0(t1)
__panic(const char *file, int line, const char *fmt, ...) {
ffffffffc020044e:	715d                	addi	sp,sp,-80
ffffffffc0200450:	ec06                	sd	ra,24(sp)
ffffffffc0200452:	e822                	sd	s0,16(sp)
ffffffffc0200454:	f436                	sd	a3,40(sp)
ffffffffc0200456:	f83a                	sd	a4,48(sp)
ffffffffc0200458:	fc3e                	sd	a5,56(sp)
ffffffffc020045a:	e0c2                	sd	a6,64(sp)
ffffffffc020045c:	e4c6                	sd	a7,72(sp)
    if (is_panic) {
ffffffffc020045e:	020e1a63          	bnez	t3,ffffffffc0200492 <__panic+0x50>
        goto panic_dead;
    }
    is_panic = 1;
ffffffffc0200462:	4785                	li	a5,1
ffffffffc0200464:	00f32023          	sw	a5,0(t1)

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
ffffffffc0200468:	8432                	mv	s0,a2
ffffffffc020046a:	103c                	addi	a5,sp,40
    cprintf("kernel panic at %s:%d:\n    ", file, line);
ffffffffc020046c:	862e                	mv	a2,a1
ffffffffc020046e:	85aa                	mv	a1,a0
ffffffffc0200470:	00004517          	auipc	a0,0x4
ffffffffc0200474:	01050513          	addi	a0,a0,16 # ffffffffc0204480 <commands+0x48>
    va_start(ap, fmt);
ffffffffc0200478:	e43e                	sd	a5,8(sp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
ffffffffc020047a:	d03ff0ef          	jal	ra,ffffffffc020017c <cprintf>
    vcprintf(fmt, ap);
ffffffffc020047e:	65a2                	ld	a1,8(sp)
ffffffffc0200480:	8522                	mv	a0,s0
ffffffffc0200482:	cdbff0ef          	jal	ra,ffffffffc020015c <vcprintf>
    cprintf("\n");
ffffffffc0200486:	00005517          	auipc	a0,0x5
ffffffffc020048a:	f6a50513          	addi	a0,a0,-150 # ffffffffc02053f0 <default_pmm_manager+0x4d0>
ffffffffc020048e:	cefff0ef          	jal	ra,ffffffffc020017c <cprintf>
    va_end(ap);

panic_dead:
    intr_disable();
ffffffffc0200492:	0fc000ef          	jal	ra,ffffffffc020058e <intr_disable>
    while (1) {
        kmonitor(NULL);
ffffffffc0200496:	4501                	li	a0,0
ffffffffc0200498:	e57ff0ef          	jal	ra,ffffffffc02002ee <kmonitor>
    while (1) {
ffffffffc020049c:	bfed                	j	ffffffffc0200496 <__panic+0x54>

ffffffffc020049e <clock_init>:
 * and then enable IRQ_TIMER.
 * */
void clock_init(void) {
    // divided by 500 when using Spike(2MHz)
    // divided by 100 when using QEMU(10MHz)
    timebase = 1e7 / 100;
ffffffffc020049e:	67e1                	lui	a5,0x18
ffffffffc02004a0:	6a078793          	addi	a5,a5,1696 # 186a0 <kern_entry-0xffffffffc01e7960>
ffffffffc02004a4:	00015717          	auipc	a4,0x15
ffffffffc02004a8:	fcf73223          	sd	a5,-60(a4) # ffffffffc0215468 <timebase>
    __asm__ __volatile__("rdtime %0" : "=r"(n));
ffffffffc02004ac:	c0102573          	rdtime	a0
	SBI_CALL_1(SBI_SET_TIMER, stime_value);
ffffffffc02004b0:	4581                	li	a1,0
    ticks = 0;

    cprintf("++ setup timer interrupts\n");
}

void clock_set_next_event(void) { sbi_set_timer(get_cycles() + timebase); }
ffffffffc02004b2:	953e                	add	a0,a0,a5
ffffffffc02004b4:	4601                	li	a2,0
ffffffffc02004b6:	4881                	li	a7,0
ffffffffc02004b8:	00000073          	ecall
    set_csr(sie, MIP_STIP);
ffffffffc02004bc:	02000793          	li	a5,32
ffffffffc02004c0:	1047a7f3          	csrrs	a5,sie,a5
    cprintf("++ setup timer interrupts\n");
ffffffffc02004c4:	00004517          	auipc	a0,0x4
ffffffffc02004c8:	fdc50513          	addi	a0,a0,-36 # ffffffffc02044a0 <commands+0x68>
    ticks = 0;
ffffffffc02004cc:	00015797          	auipc	a5,0x15
ffffffffc02004d0:	f807ba23          	sd	zero,-108(a5) # ffffffffc0215460 <ticks>
    cprintf("++ setup timer interrupts\n");
ffffffffc02004d4:	b165                	j	ffffffffc020017c <cprintf>

ffffffffc02004d6 <clock_set_next_event>:
    __asm__ __volatile__("rdtime %0" : "=r"(n));
ffffffffc02004d6:	c0102573          	rdtime	a0
void clock_set_next_event(void) { sbi_set_timer(get_cycles() + timebase); }
ffffffffc02004da:	00015797          	auipc	a5,0x15
ffffffffc02004de:	f8e7b783          	ld	a5,-114(a5) # ffffffffc0215468 <timebase>
ffffffffc02004e2:	953e                	add	a0,a0,a5
ffffffffc02004e4:	4581                	li	a1,0
ffffffffc02004e6:	4601                	li	a2,0
ffffffffc02004e8:	4881                	li	a7,0
ffffffffc02004ea:	00000073          	ecall
ffffffffc02004ee:	8082                	ret

ffffffffc02004f0 <cons_init>:

/* serial_intr - try to feed input characters from serial port */
void serial_intr(void) {}

/* cons_init - initializes the console devices */
void cons_init(void) {}
ffffffffc02004f0:	8082                	ret

ffffffffc02004f2 <cons_putc>:
#include <defs.h>
#include <intr.h>
#include <riscv.h>

static inline bool __intr_save(void) {
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc02004f2:	100027f3          	csrr	a5,sstatus
ffffffffc02004f6:	8b89                	andi	a5,a5,2
	SBI_CALL_1(SBI_CONSOLE_PUTCHAR, ch);
ffffffffc02004f8:	0ff57513          	andi	a0,a0,255
ffffffffc02004fc:	e799                	bnez	a5,ffffffffc020050a <cons_putc+0x18>
ffffffffc02004fe:	4581                	li	a1,0
ffffffffc0200500:	4601                	li	a2,0
ffffffffc0200502:	4885                	li	a7,1
ffffffffc0200504:	00000073          	ecall
    }
    return 0;
}

static inline void __intr_restore(bool flag) {
    if (flag) {
ffffffffc0200508:	8082                	ret

/* cons_putc - print a single character @c to console devices */
void cons_putc(int c) {
ffffffffc020050a:	1101                	addi	sp,sp,-32
ffffffffc020050c:	ec06                	sd	ra,24(sp)
ffffffffc020050e:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc0200510:	07e000ef          	jal	ra,ffffffffc020058e <intr_disable>
ffffffffc0200514:	6522                	ld	a0,8(sp)
ffffffffc0200516:	4581                	li	a1,0
ffffffffc0200518:	4601                	li	a2,0
ffffffffc020051a:	4885                	li	a7,1
ffffffffc020051c:	00000073          	ecall
    local_intr_save(intr_flag);
    {
        sbi_console_putchar((unsigned char)c);
    }
    local_intr_restore(intr_flag);
}
ffffffffc0200520:	60e2                	ld	ra,24(sp)
ffffffffc0200522:	6105                	addi	sp,sp,32
        intr_enable();
ffffffffc0200524:	a095                	j	ffffffffc0200588 <intr_enable>

ffffffffc0200526 <cons_getc>:
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0200526:	100027f3          	csrr	a5,sstatus
ffffffffc020052a:	8b89                	andi	a5,a5,2
ffffffffc020052c:	eb89                	bnez	a5,ffffffffc020053e <cons_getc+0x18>
	return SBI_CALL_0(SBI_CONSOLE_GETCHAR);
ffffffffc020052e:	4501                	li	a0,0
ffffffffc0200530:	4581                	li	a1,0
ffffffffc0200532:	4601                	li	a2,0
ffffffffc0200534:	4889                	li	a7,2
ffffffffc0200536:	00000073          	ecall
ffffffffc020053a:	2501                	sext.w	a0,a0
    {
        c = sbi_console_getchar();
    }
    local_intr_restore(intr_flag);
    return c;
}
ffffffffc020053c:	8082                	ret
int cons_getc(void) {
ffffffffc020053e:	1101                	addi	sp,sp,-32
ffffffffc0200540:	ec06                	sd	ra,24(sp)
        intr_disable();
ffffffffc0200542:	04c000ef          	jal	ra,ffffffffc020058e <intr_disable>
ffffffffc0200546:	4501                	li	a0,0
ffffffffc0200548:	4581                	li	a1,0
ffffffffc020054a:	4601                	li	a2,0
ffffffffc020054c:	4889                	li	a7,2
ffffffffc020054e:	00000073          	ecall
ffffffffc0200552:	2501                	sext.w	a0,a0
ffffffffc0200554:	e42a                	sd	a0,8(sp)
        intr_enable();
ffffffffc0200556:	032000ef          	jal	ra,ffffffffc0200588 <intr_enable>
}
ffffffffc020055a:	60e2                	ld	ra,24(sp)
ffffffffc020055c:	6522                	ld	a0,8(sp)
ffffffffc020055e:	6105                	addi	sp,sp,32
ffffffffc0200560:	8082                	ret

ffffffffc0200562 <ide_init>:
#include <stdio.h>
#include <string.h>
#include <trap.h>
#include <riscv.h>

void ide_init(void) {}
ffffffffc0200562:	8082                	ret

ffffffffc0200564 <ide_write_secs>:
    return 0;
}

int ide_write_secs(unsigned short ideno, uint32_t secno, const void *src,
                   size_t nsecs) {
    int iobase = secno * SECTSIZE;
ffffffffc0200564:	0095979b          	slliw	a5,a1,0x9
    memcpy(&ide[iobase], src, nsecs * SECTSIZE);
ffffffffc0200568:	0000a517          	auipc	a0,0xa
ffffffffc020056c:	eb850513          	addi	a0,a0,-328 # ffffffffc020a420 <ide>
                   size_t nsecs) {
ffffffffc0200570:	1141                	addi	sp,sp,-16
ffffffffc0200572:	85b2                	mv	a1,a2
    memcpy(&ide[iobase], src, nsecs * SECTSIZE);
ffffffffc0200574:	953e                	add	a0,a0,a5
ffffffffc0200576:	00969613          	slli	a2,a3,0x9
                   size_t nsecs) {
ffffffffc020057a:	e406                	sd	ra,8(sp)
    memcpy(&ide[iobase], src, nsecs * SECTSIZE);
ffffffffc020057c:	415030ef          	jal	ra,ffffffffc0204190 <memcpy>
    return 0;
}
ffffffffc0200580:	60a2                	ld	ra,8(sp)
ffffffffc0200582:	4501                	li	a0,0
ffffffffc0200584:	0141                	addi	sp,sp,16
ffffffffc0200586:	8082                	ret

ffffffffc0200588 <intr_enable>:
#include <intr.h>
#include <riscv.h>

/* intr_enable - enable irq interrupt */
void intr_enable(void) { set_csr(sstatus, SSTATUS_SIE); }
ffffffffc0200588:	100167f3          	csrrsi	a5,sstatus,2
ffffffffc020058c:	8082                	ret

ffffffffc020058e <intr_disable>:

/* intr_disable - disable irq interrupt */
void intr_disable(void) { clear_csr(sstatus, SSTATUS_SIE); }
ffffffffc020058e:	100177f3          	csrrci	a5,sstatus,2
ffffffffc0200592:	8082                	ret

ffffffffc0200594 <pic_init>:
#include <picirq.h>

void pic_enable(unsigned int irq) {}

/* pic_init - initialize the 8259A interrupt controllers */
void pic_init(void) {}
ffffffffc0200594:	8082                	ret

ffffffffc0200596 <pgfault_handler>:
    set_csr(sstatus, SSTATUS_SUM);
}

/* trap_in_kernel - test if trap happened in kernel */
bool trap_in_kernel(struct trapframe *tf) {
    return (tf->status & SSTATUS_SPP) != 0;
ffffffffc0200596:	10053783          	ld	a5,256(a0)
    cprintf("page falut at 0x%08x: %c/%c\n", tf->badvaddr,
            trap_in_kernel(tf) ? 'K' : 'U',
            tf->cause == CAUSE_STORE_PAGE_FAULT ? 'W' : 'R');
}

static int pgfault_handler(struct trapframe *tf) {
ffffffffc020059a:	1141                	addi	sp,sp,-16
ffffffffc020059c:	e022                	sd	s0,0(sp)
ffffffffc020059e:	e406                	sd	ra,8(sp)
    return (tf->status & SSTATUS_SPP) != 0;
ffffffffc02005a0:	1007f793          	andi	a5,a5,256
    cprintf("page falut at 0x%08x: %c/%c\n", tf->badvaddr,
ffffffffc02005a4:	11053583          	ld	a1,272(a0)
static int pgfault_handler(struct trapframe *tf) {
ffffffffc02005a8:	842a                	mv	s0,a0
    cprintf("page falut at 0x%08x: %c/%c\n", tf->badvaddr,
ffffffffc02005aa:	05500613          	li	a2,85
ffffffffc02005ae:	c399                	beqz	a5,ffffffffc02005b4 <pgfault_handler+0x1e>
ffffffffc02005b0:	04b00613          	li	a2,75
ffffffffc02005b4:	11843703          	ld	a4,280(s0)
ffffffffc02005b8:	47bd                	li	a5,15
ffffffffc02005ba:	05700693          	li	a3,87
ffffffffc02005be:	00f70463          	beq	a4,a5,ffffffffc02005c6 <pgfault_handler+0x30>
ffffffffc02005c2:	05200693          	li	a3,82
ffffffffc02005c6:	00004517          	auipc	a0,0x4
ffffffffc02005ca:	efa50513          	addi	a0,a0,-262 # ffffffffc02044c0 <commands+0x88>
ffffffffc02005ce:	bafff0ef          	jal	ra,ffffffffc020017c <cprintf>
    extern struct mm_struct *check_mm_struct;
    print_pgfault(tf);
    if (check_mm_struct != NULL) {
ffffffffc02005d2:	00015517          	auipc	a0,0x15
ffffffffc02005d6:	eee53503          	ld	a0,-274(a0) # ffffffffc02154c0 <check_mm_struct>
ffffffffc02005da:	c911                	beqz	a0,ffffffffc02005ee <pgfault_handler+0x58>
        return do_pgfault(check_mm_struct, tf->cause, tf->badvaddr);
ffffffffc02005dc:	11043603          	ld	a2,272(s0)
ffffffffc02005e0:	11842583          	lw	a1,280(s0)
    }
    panic("unhandled page fault.\n");
}
ffffffffc02005e4:	6402                	ld	s0,0(sp)
ffffffffc02005e6:	60a2                	ld	ra,8(sp)
ffffffffc02005e8:	0141                	addi	sp,sp,16
        return do_pgfault(check_mm_struct, tf->cause, tf->badvaddr);
ffffffffc02005ea:	6670206f          	j	ffffffffc0203450 <do_pgfault>
    panic("unhandled page fault.\n");
ffffffffc02005ee:	00004617          	auipc	a2,0x4
ffffffffc02005f2:	ef260613          	addi	a2,a2,-270 # ffffffffc02044e0 <commands+0xa8>
ffffffffc02005f6:	06200593          	li	a1,98
ffffffffc02005fa:	00004517          	auipc	a0,0x4
ffffffffc02005fe:	efe50513          	addi	a0,a0,-258 # ffffffffc02044f8 <commands+0xc0>
ffffffffc0200602:	e41ff0ef          	jal	ra,ffffffffc0200442 <__panic>

ffffffffc0200606 <idt_init>:
    write_csr(sscratch, 0);
ffffffffc0200606:	14005073          	csrwi	sscratch,0
    write_csr(stvec, &__alltraps);
ffffffffc020060a:	00000797          	auipc	a5,0x0
ffffffffc020060e:	47a78793          	addi	a5,a5,1146 # ffffffffc0200a84 <__alltraps>
ffffffffc0200612:	10579073          	csrw	stvec,a5
    set_csr(sstatus, SSTATUS_SUM);
ffffffffc0200616:	000407b7          	lui	a5,0x40
ffffffffc020061a:	1007a7f3          	csrrs	a5,sstatus,a5
}
ffffffffc020061e:	8082                	ret

ffffffffc0200620 <print_regs>:
    cprintf("  zero     0x%08x\n", gpr->zero);
ffffffffc0200620:	610c                	ld	a1,0(a0)
void print_regs(struct pushregs *gpr) {
ffffffffc0200622:	1141                	addi	sp,sp,-16
ffffffffc0200624:	e022                	sd	s0,0(sp)
ffffffffc0200626:	842a                	mv	s0,a0
    cprintf("  zero     0x%08x\n", gpr->zero);
ffffffffc0200628:	00004517          	auipc	a0,0x4
ffffffffc020062c:	ee850513          	addi	a0,a0,-280 # ffffffffc0204510 <commands+0xd8>
void print_regs(struct pushregs *gpr) {
ffffffffc0200630:	e406                	sd	ra,8(sp)
    cprintf("  zero     0x%08x\n", gpr->zero);
ffffffffc0200632:	b4bff0ef          	jal	ra,ffffffffc020017c <cprintf>
    cprintf("  ra       0x%08x\n", gpr->ra);
ffffffffc0200636:	640c                	ld	a1,8(s0)
ffffffffc0200638:	00004517          	auipc	a0,0x4
ffffffffc020063c:	ef050513          	addi	a0,a0,-272 # ffffffffc0204528 <commands+0xf0>
ffffffffc0200640:	b3dff0ef          	jal	ra,ffffffffc020017c <cprintf>
    cprintf("  sp       0x%08x\n", gpr->sp);
ffffffffc0200644:	680c                	ld	a1,16(s0)
ffffffffc0200646:	00004517          	auipc	a0,0x4
ffffffffc020064a:	efa50513          	addi	a0,a0,-262 # ffffffffc0204540 <commands+0x108>
ffffffffc020064e:	b2fff0ef          	jal	ra,ffffffffc020017c <cprintf>
    cprintf("  gp       0x%08x\n", gpr->gp);
ffffffffc0200652:	6c0c                	ld	a1,24(s0)
ffffffffc0200654:	00004517          	auipc	a0,0x4
ffffffffc0200658:	f0450513          	addi	a0,a0,-252 # ffffffffc0204558 <commands+0x120>
ffffffffc020065c:	b21ff0ef          	jal	ra,ffffffffc020017c <cprintf>
    cprintf("  tp       0x%08x\n", gpr->tp);
ffffffffc0200660:	700c                	ld	a1,32(s0)
ffffffffc0200662:	00004517          	auipc	a0,0x4
ffffffffc0200666:	f0e50513          	addi	a0,a0,-242 # ffffffffc0204570 <commands+0x138>
ffffffffc020066a:	b13ff0ef          	jal	ra,ffffffffc020017c <cprintf>
    cprintf("  t0       0x%08x\n", gpr->t0);
ffffffffc020066e:	740c                	ld	a1,40(s0)
ffffffffc0200670:	00004517          	auipc	a0,0x4
ffffffffc0200674:	f1850513          	addi	a0,a0,-232 # ffffffffc0204588 <commands+0x150>
ffffffffc0200678:	b05ff0ef          	jal	ra,ffffffffc020017c <cprintf>
    cprintf("  t1       0x%08x\n", gpr->t1);
ffffffffc020067c:	780c                	ld	a1,48(s0)
ffffffffc020067e:	00004517          	auipc	a0,0x4
ffffffffc0200682:	f2250513          	addi	a0,a0,-222 # ffffffffc02045a0 <commands+0x168>
ffffffffc0200686:	af7ff0ef          	jal	ra,ffffffffc020017c <cprintf>
    cprintf("  t2       0x%08x\n", gpr->t2);
ffffffffc020068a:	7c0c                	ld	a1,56(s0)
ffffffffc020068c:	00004517          	auipc	a0,0x4
ffffffffc0200690:	f2c50513          	addi	a0,a0,-212 # ffffffffc02045b8 <commands+0x180>
ffffffffc0200694:	ae9ff0ef          	jal	ra,ffffffffc020017c <cprintf>
    cprintf("  s0       0x%08x\n", gpr->s0);
ffffffffc0200698:	602c                	ld	a1,64(s0)
ffffffffc020069a:	00004517          	auipc	a0,0x4
ffffffffc020069e:	f3650513          	addi	a0,a0,-202 # ffffffffc02045d0 <commands+0x198>
ffffffffc02006a2:	adbff0ef          	jal	ra,ffffffffc020017c <cprintf>
    cprintf("  s1       0x%08x\n", gpr->s1);
ffffffffc02006a6:	642c                	ld	a1,72(s0)
ffffffffc02006a8:	00004517          	auipc	a0,0x4
ffffffffc02006ac:	f4050513          	addi	a0,a0,-192 # ffffffffc02045e8 <commands+0x1b0>
ffffffffc02006b0:	acdff0ef          	jal	ra,ffffffffc020017c <cprintf>
    cprintf("  a0       0x%08x\n", gpr->a0);
ffffffffc02006b4:	682c                	ld	a1,80(s0)
ffffffffc02006b6:	00004517          	auipc	a0,0x4
ffffffffc02006ba:	f4a50513          	addi	a0,a0,-182 # ffffffffc0204600 <commands+0x1c8>
ffffffffc02006be:	abfff0ef          	jal	ra,ffffffffc020017c <cprintf>
    cprintf("  a1       0x%08x\n", gpr->a1);
ffffffffc02006c2:	6c2c                	ld	a1,88(s0)
ffffffffc02006c4:	00004517          	auipc	a0,0x4
ffffffffc02006c8:	f5450513          	addi	a0,a0,-172 # ffffffffc0204618 <commands+0x1e0>
ffffffffc02006cc:	ab1ff0ef          	jal	ra,ffffffffc020017c <cprintf>
    cprintf("  a2       0x%08x\n", gpr->a2);
ffffffffc02006d0:	702c                	ld	a1,96(s0)
ffffffffc02006d2:	00004517          	auipc	a0,0x4
ffffffffc02006d6:	f5e50513          	addi	a0,a0,-162 # ffffffffc0204630 <commands+0x1f8>
ffffffffc02006da:	aa3ff0ef          	jal	ra,ffffffffc020017c <cprintf>
    cprintf("  a3       0x%08x\n", gpr->a3);
ffffffffc02006de:	742c                	ld	a1,104(s0)
ffffffffc02006e0:	00004517          	auipc	a0,0x4
ffffffffc02006e4:	f6850513          	addi	a0,a0,-152 # ffffffffc0204648 <commands+0x210>
ffffffffc02006e8:	a95ff0ef          	jal	ra,ffffffffc020017c <cprintf>
    cprintf("  a4       0x%08x\n", gpr->a4);
ffffffffc02006ec:	782c                	ld	a1,112(s0)
ffffffffc02006ee:	00004517          	auipc	a0,0x4
ffffffffc02006f2:	f7250513          	addi	a0,a0,-142 # ffffffffc0204660 <commands+0x228>
ffffffffc02006f6:	a87ff0ef          	jal	ra,ffffffffc020017c <cprintf>
    cprintf("  a5       0x%08x\n", gpr->a5);
ffffffffc02006fa:	7c2c                	ld	a1,120(s0)
ffffffffc02006fc:	00004517          	auipc	a0,0x4
ffffffffc0200700:	f7c50513          	addi	a0,a0,-132 # ffffffffc0204678 <commands+0x240>
ffffffffc0200704:	a79ff0ef          	jal	ra,ffffffffc020017c <cprintf>
    cprintf("  a6       0x%08x\n", gpr->a6);
ffffffffc0200708:	604c                	ld	a1,128(s0)
ffffffffc020070a:	00004517          	auipc	a0,0x4
ffffffffc020070e:	f8650513          	addi	a0,a0,-122 # ffffffffc0204690 <commands+0x258>
ffffffffc0200712:	a6bff0ef          	jal	ra,ffffffffc020017c <cprintf>
    cprintf("  a7       0x%08x\n", gpr->a7);
ffffffffc0200716:	644c                	ld	a1,136(s0)
ffffffffc0200718:	00004517          	auipc	a0,0x4
ffffffffc020071c:	f9050513          	addi	a0,a0,-112 # ffffffffc02046a8 <commands+0x270>
ffffffffc0200720:	a5dff0ef          	jal	ra,ffffffffc020017c <cprintf>
    cprintf("  s2       0x%08x\n", gpr->s2);
ffffffffc0200724:	684c                	ld	a1,144(s0)
ffffffffc0200726:	00004517          	auipc	a0,0x4
ffffffffc020072a:	f9a50513          	addi	a0,a0,-102 # ffffffffc02046c0 <commands+0x288>
ffffffffc020072e:	a4fff0ef          	jal	ra,ffffffffc020017c <cprintf>
    cprintf("  s3       0x%08x\n", gpr->s3);
ffffffffc0200732:	6c4c                	ld	a1,152(s0)
ffffffffc0200734:	00004517          	auipc	a0,0x4
ffffffffc0200738:	fa450513          	addi	a0,a0,-92 # ffffffffc02046d8 <commands+0x2a0>
ffffffffc020073c:	a41ff0ef          	jal	ra,ffffffffc020017c <cprintf>
    cprintf("  s4       0x%08x\n", gpr->s4);
ffffffffc0200740:	704c                	ld	a1,160(s0)
ffffffffc0200742:	00004517          	auipc	a0,0x4
ffffffffc0200746:	fae50513          	addi	a0,a0,-82 # ffffffffc02046f0 <commands+0x2b8>
ffffffffc020074a:	a33ff0ef          	jal	ra,ffffffffc020017c <cprintf>
    cprintf("  s5       0x%08x\n", gpr->s5);
ffffffffc020074e:	744c                	ld	a1,168(s0)
ffffffffc0200750:	00004517          	auipc	a0,0x4
ffffffffc0200754:	fb850513          	addi	a0,a0,-72 # ffffffffc0204708 <commands+0x2d0>
ffffffffc0200758:	a25ff0ef          	jal	ra,ffffffffc020017c <cprintf>
    cprintf("  s6       0x%08x\n", gpr->s6);
ffffffffc020075c:	784c                	ld	a1,176(s0)
ffffffffc020075e:	00004517          	auipc	a0,0x4
ffffffffc0200762:	fc250513          	addi	a0,a0,-62 # ffffffffc0204720 <commands+0x2e8>
ffffffffc0200766:	a17ff0ef          	jal	ra,ffffffffc020017c <cprintf>
    cprintf("  s7       0x%08x\n", gpr->s7);
ffffffffc020076a:	7c4c                	ld	a1,184(s0)
ffffffffc020076c:	00004517          	auipc	a0,0x4
ffffffffc0200770:	fcc50513          	addi	a0,a0,-52 # ffffffffc0204738 <commands+0x300>
ffffffffc0200774:	a09ff0ef          	jal	ra,ffffffffc020017c <cprintf>
    cprintf("  s8       0x%08x\n", gpr->s8);
ffffffffc0200778:	606c                	ld	a1,192(s0)
ffffffffc020077a:	00004517          	auipc	a0,0x4
ffffffffc020077e:	fd650513          	addi	a0,a0,-42 # ffffffffc0204750 <commands+0x318>
ffffffffc0200782:	9fbff0ef          	jal	ra,ffffffffc020017c <cprintf>
    cprintf("  s9       0x%08x\n", gpr->s9);
ffffffffc0200786:	646c                	ld	a1,200(s0)
ffffffffc0200788:	00004517          	auipc	a0,0x4
ffffffffc020078c:	fe050513          	addi	a0,a0,-32 # ffffffffc0204768 <commands+0x330>
ffffffffc0200790:	9edff0ef          	jal	ra,ffffffffc020017c <cprintf>
    cprintf("  s10      0x%08x\n", gpr->s10);
ffffffffc0200794:	686c                	ld	a1,208(s0)
ffffffffc0200796:	00004517          	auipc	a0,0x4
ffffffffc020079a:	fea50513          	addi	a0,a0,-22 # ffffffffc0204780 <commands+0x348>
ffffffffc020079e:	9dfff0ef          	jal	ra,ffffffffc020017c <cprintf>
    cprintf("  s11      0x%08x\n", gpr->s11);
ffffffffc02007a2:	6c6c                	ld	a1,216(s0)
ffffffffc02007a4:	00004517          	auipc	a0,0x4
ffffffffc02007a8:	ff450513          	addi	a0,a0,-12 # ffffffffc0204798 <commands+0x360>
ffffffffc02007ac:	9d1ff0ef          	jal	ra,ffffffffc020017c <cprintf>
    cprintf("  t3       0x%08x\n", gpr->t3);
ffffffffc02007b0:	706c                	ld	a1,224(s0)
ffffffffc02007b2:	00004517          	auipc	a0,0x4
ffffffffc02007b6:	ffe50513          	addi	a0,a0,-2 # ffffffffc02047b0 <commands+0x378>
ffffffffc02007ba:	9c3ff0ef          	jal	ra,ffffffffc020017c <cprintf>
    cprintf("  t4       0x%08x\n", gpr->t4);
ffffffffc02007be:	746c                	ld	a1,232(s0)
ffffffffc02007c0:	00004517          	auipc	a0,0x4
ffffffffc02007c4:	00850513          	addi	a0,a0,8 # ffffffffc02047c8 <commands+0x390>
ffffffffc02007c8:	9b5ff0ef          	jal	ra,ffffffffc020017c <cprintf>
    cprintf("  t5       0x%08x\n", gpr->t5);
ffffffffc02007cc:	786c                	ld	a1,240(s0)
ffffffffc02007ce:	00004517          	auipc	a0,0x4
ffffffffc02007d2:	01250513          	addi	a0,a0,18 # ffffffffc02047e0 <commands+0x3a8>
ffffffffc02007d6:	9a7ff0ef          	jal	ra,ffffffffc020017c <cprintf>
    cprintf("  t6       0x%08x\n", gpr->t6);
ffffffffc02007da:	7c6c                	ld	a1,248(s0)
}
ffffffffc02007dc:	6402                	ld	s0,0(sp)
ffffffffc02007de:	60a2                	ld	ra,8(sp)
    cprintf("  t6       0x%08x\n", gpr->t6);
ffffffffc02007e0:	00004517          	auipc	a0,0x4
ffffffffc02007e4:	01850513          	addi	a0,a0,24 # ffffffffc02047f8 <commands+0x3c0>
}
ffffffffc02007e8:	0141                	addi	sp,sp,16
    cprintf("  t6       0x%08x\n", gpr->t6);
ffffffffc02007ea:	ba49                	j	ffffffffc020017c <cprintf>

ffffffffc02007ec <print_trapframe>:
void print_trapframe(struct trapframe *tf) {
ffffffffc02007ec:	1141                	addi	sp,sp,-16
ffffffffc02007ee:	e022                	sd	s0,0(sp)
    cprintf("trapframe at %p\n", tf);
ffffffffc02007f0:	85aa                	mv	a1,a0
void print_trapframe(struct trapframe *tf) {
ffffffffc02007f2:	842a                	mv	s0,a0
    cprintf("trapframe at %p\n", tf);
ffffffffc02007f4:	00004517          	auipc	a0,0x4
ffffffffc02007f8:	01c50513          	addi	a0,a0,28 # ffffffffc0204810 <commands+0x3d8>
void print_trapframe(struct trapframe *tf) {
ffffffffc02007fc:	e406                	sd	ra,8(sp)
    cprintf("trapframe at %p\n", tf);
ffffffffc02007fe:	97fff0ef          	jal	ra,ffffffffc020017c <cprintf>
    print_regs(&tf->gpr);
ffffffffc0200802:	8522                	mv	a0,s0
ffffffffc0200804:	e1dff0ef          	jal	ra,ffffffffc0200620 <print_regs>
    cprintf("  status   0x%08x\n", tf->status);
ffffffffc0200808:	10043583          	ld	a1,256(s0)
ffffffffc020080c:	00004517          	auipc	a0,0x4
ffffffffc0200810:	01c50513          	addi	a0,a0,28 # ffffffffc0204828 <commands+0x3f0>
ffffffffc0200814:	969ff0ef          	jal	ra,ffffffffc020017c <cprintf>
    cprintf("  epc      0x%08x\n", tf->epc);
ffffffffc0200818:	10843583          	ld	a1,264(s0)
ffffffffc020081c:	00004517          	auipc	a0,0x4
ffffffffc0200820:	02450513          	addi	a0,a0,36 # ffffffffc0204840 <commands+0x408>
ffffffffc0200824:	959ff0ef          	jal	ra,ffffffffc020017c <cprintf>
    cprintf("  badvaddr 0x%08x\n", tf->badvaddr);
ffffffffc0200828:	11043583          	ld	a1,272(s0)
ffffffffc020082c:	00004517          	auipc	a0,0x4
ffffffffc0200830:	02c50513          	addi	a0,a0,44 # ffffffffc0204858 <commands+0x420>
ffffffffc0200834:	949ff0ef          	jal	ra,ffffffffc020017c <cprintf>
    cprintf("  cause    0x%08x\n", tf->cause);
ffffffffc0200838:	11843583          	ld	a1,280(s0)
}
ffffffffc020083c:	6402                	ld	s0,0(sp)
ffffffffc020083e:	60a2                	ld	ra,8(sp)
    cprintf("  cause    0x%08x\n", tf->cause);
ffffffffc0200840:	00004517          	auipc	a0,0x4
ffffffffc0200844:	03050513          	addi	a0,a0,48 # ffffffffc0204870 <commands+0x438>
}
ffffffffc0200848:	0141                	addi	sp,sp,16
    cprintf("  cause    0x%08x\n", tf->cause);
ffffffffc020084a:	933ff06f          	j	ffffffffc020017c <cprintf>

ffffffffc020084e <interrupt_handler>:

static volatile int in_swap_tick_event = 0;
extern struct mm_struct *check_mm_struct;

void interrupt_handler(struct trapframe *tf) {
    intptr_t cause = (tf->cause << 1) >> 1;
ffffffffc020084e:	11853783          	ld	a5,280(a0)
ffffffffc0200852:	472d                	li	a4,11
ffffffffc0200854:	0786                	slli	a5,a5,0x1
ffffffffc0200856:	8385                	srli	a5,a5,0x1
ffffffffc0200858:	06f76c63          	bltu	a4,a5,ffffffffc02008d0 <interrupt_handler+0x82>
ffffffffc020085c:	00004717          	auipc	a4,0x4
ffffffffc0200860:	0dc70713          	addi	a4,a4,220 # ffffffffc0204938 <commands+0x500>
ffffffffc0200864:	078a                	slli	a5,a5,0x2
ffffffffc0200866:	97ba                	add	a5,a5,a4
ffffffffc0200868:	439c                	lw	a5,0(a5)
ffffffffc020086a:	97ba                	add	a5,a5,a4
ffffffffc020086c:	8782                	jr	a5
            break;
        case IRQ_H_SOFT:
            cprintf("Hypervisor software interrupt\n");
            break;
        case IRQ_M_SOFT:
            cprintf("Machine software interrupt\n");
ffffffffc020086e:	00004517          	auipc	a0,0x4
ffffffffc0200872:	07a50513          	addi	a0,a0,122 # ffffffffc02048e8 <commands+0x4b0>
ffffffffc0200876:	907ff06f          	j	ffffffffc020017c <cprintf>
            cprintf("Hypervisor software interrupt\n");
ffffffffc020087a:	00004517          	auipc	a0,0x4
ffffffffc020087e:	04e50513          	addi	a0,a0,78 # ffffffffc02048c8 <commands+0x490>
ffffffffc0200882:	8fbff06f          	j	ffffffffc020017c <cprintf>
            cprintf("User software interrupt\n");
ffffffffc0200886:	00004517          	auipc	a0,0x4
ffffffffc020088a:	00250513          	addi	a0,a0,2 # ffffffffc0204888 <commands+0x450>
ffffffffc020088e:	8efff06f          	j	ffffffffc020017c <cprintf>
            cprintf("Supervisor software interrupt\n");
ffffffffc0200892:	00004517          	auipc	a0,0x4
ffffffffc0200896:	01650513          	addi	a0,a0,22 # ffffffffc02048a8 <commands+0x470>
ffffffffc020089a:	8e3ff06f          	j	ffffffffc020017c <cprintf>
void interrupt_handler(struct trapframe *tf) {
ffffffffc020089e:	1141                	addi	sp,sp,-16
ffffffffc02008a0:	e406                	sd	ra,8(sp)
            // "All bits besides SSIP and USIP in the sip register are
            // read-only." -- privileged spec1.9.1, 4.1.4, p59
            // In fact, Call sbi_set_timer will clear STIP, or you can clear it
            // directly.
            // clear_csr(sip, SIP_STIP);
            clock_set_next_event();
ffffffffc02008a2:	c35ff0ef          	jal	ra,ffffffffc02004d6 <clock_set_next_event>
            if (++ticks % TICK_NUM == 0) {
ffffffffc02008a6:	00015697          	auipc	a3,0x15
ffffffffc02008aa:	bba68693          	addi	a3,a3,-1094 # ffffffffc0215460 <ticks>
ffffffffc02008ae:	629c                	ld	a5,0(a3)
ffffffffc02008b0:	06400713          	li	a4,100
ffffffffc02008b4:	0785                	addi	a5,a5,1
ffffffffc02008b6:	02e7f733          	remu	a4,a5,a4
ffffffffc02008ba:	e29c                	sd	a5,0(a3)
ffffffffc02008bc:	cb19                	beqz	a4,ffffffffc02008d2 <interrupt_handler+0x84>
            break;
        default:
            print_trapframe(tf);
            break;
    }
}
ffffffffc02008be:	60a2                	ld	ra,8(sp)
ffffffffc02008c0:	0141                	addi	sp,sp,16
ffffffffc02008c2:	8082                	ret
            cprintf("Supervisor external interrupt\n");
ffffffffc02008c4:	00004517          	auipc	a0,0x4
ffffffffc02008c8:	05450513          	addi	a0,a0,84 # ffffffffc0204918 <commands+0x4e0>
ffffffffc02008cc:	8b1ff06f          	j	ffffffffc020017c <cprintf>
            print_trapframe(tf);
ffffffffc02008d0:	bf31                	j	ffffffffc02007ec <print_trapframe>
}
ffffffffc02008d2:	60a2                	ld	ra,8(sp)
    cprintf("%d ticks\n", TICK_NUM);
ffffffffc02008d4:	06400593          	li	a1,100
ffffffffc02008d8:	00004517          	auipc	a0,0x4
ffffffffc02008dc:	03050513          	addi	a0,a0,48 # ffffffffc0204908 <commands+0x4d0>
}
ffffffffc02008e0:	0141                	addi	sp,sp,16
    cprintf("%d ticks\n", TICK_NUM);
ffffffffc02008e2:	89bff06f          	j	ffffffffc020017c <cprintf>

ffffffffc02008e6 <exception_handler>:

void exception_handler(struct trapframe *tf) {
    int ret;
    switch (tf->cause) {
ffffffffc02008e6:	11853783          	ld	a5,280(a0)
void exception_handler(struct trapframe *tf) {
ffffffffc02008ea:	1101                	addi	sp,sp,-32
ffffffffc02008ec:	e822                	sd	s0,16(sp)
ffffffffc02008ee:	ec06                	sd	ra,24(sp)
ffffffffc02008f0:	e426                	sd	s1,8(sp)
ffffffffc02008f2:	473d                	li	a4,15
ffffffffc02008f4:	842a                	mv	s0,a0
ffffffffc02008f6:	14f76a63          	bltu	a4,a5,ffffffffc0200a4a <exception_handler+0x164>
ffffffffc02008fa:	00004717          	auipc	a4,0x4
ffffffffc02008fe:	22670713          	addi	a4,a4,550 # ffffffffc0204b20 <commands+0x6e8>
ffffffffc0200902:	078a                	slli	a5,a5,0x2
ffffffffc0200904:	97ba                	add	a5,a5,a4
ffffffffc0200906:	439c                	lw	a5,0(a5)
ffffffffc0200908:	97ba                	add	a5,a5,a4
ffffffffc020090a:	8782                	jr	a5
                print_trapframe(tf);
                panic("handle pgfault failed. %e\n", ret);
            }
            break;
        case CAUSE_STORE_PAGE_FAULT:
            cprintf("Store/AMO page fault\n");
ffffffffc020090c:	00004517          	auipc	a0,0x4
ffffffffc0200910:	1fc50513          	addi	a0,a0,508 # ffffffffc0204b08 <commands+0x6d0>
ffffffffc0200914:	869ff0ef          	jal	ra,ffffffffc020017c <cprintf>
            if ((ret = pgfault_handler(tf)) != 0) {
ffffffffc0200918:	8522                	mv	a0,s0
ffffffffc020091a:	c7dff0ef          	jal	ra,ffffffffc0200596 <pgfault_handler>
ffffffffc020091e:	84aa                	mv	s1,a0
ffffffffc0200920:	12051b63          	bnez	a0,ffffffffc0200a56 <exception_handler+0x170>
            break;
        default:
            print_trapframe(tf);
            break;
    }
}
ffffffffc0200924:	60e2                	ld	ra,24(sp)
ffffffffc0200926:	6442                	ld	s0,16(sp)
ffffffffc0200928:	64a2                	ld	s1,8(sp)
ffffffffc020092a:	6105                	addi	sp,sp,32
ffffffffc020092c:	8082                	ret
            cprintf("Instruction address misaligned\n");
ffffffffc020092e:	00004517          	auipc	a0,0x4
ffffffffc0200932:	03a50513          	addi	a0,a0,58 # ffffffffc0204968 <commands+0x530>
}
ffffffffc0200936:	6442                	ld	s0,16(sp)
ffffffffc0200938:	60e2                	ld	ra,24(sp)
ffffffffc020093a:	64a2                	ld	s1,8(sp)
ffffffffc020093c:	6105                	addi	sp,sp,32
            cprintf("Instruction access fault\n");
ffffffffc020093e:	83fff06f          	j	ffffffffc020017c <cprintf>
ffffffffc0200942:	00004517          	auipc	a0,0x4
ffffffffc0200946:	04650513          	addi	a0,a0,70 # ffffffffc0204988 <commands+0x550>
ffffffffc020094a:	b7f5                	j	ffffffffc0200936 <exception_handler+0x50>
            cprintf("Illegal instruction\n");
ffffffffc020094c:	00004517          	auipc	a0,0x4
ffffffffc0200950:	05c50513          	addi	a0,a0,92 # ffffffffc02049a8 <commands+0x570>
ffffffffc0200954:	b7cd                	j	ffffffffc0200936 <exception_handler+0x50>
            cprintf("Breakpoint\n");
ffffffffc0200956:	00004517          	auipc	a0,0x4
ffffffffc020095a:	06a50513          	addi	a0,a0,106 # ffffffffc02049c0 <commands+0x588>
ffffffffc020095e:	bfe1                	j	ffffffffc0200936 <exception_handler+0x50>
            cprintf("Load address misaligned\n");
ffffffffc0200960:	00004517          	auipc	a0,0x4
ffffffffc0200964:	07050513          	addi	a0,a0,112 # ffffffffc02049d0 <commands+0x598>
ffffffffc0200968:	b7f9                	j	ffffffffc0200936 <exception_handler+0x50>
            cprintf("Load access fault\n");
ffffffffc020096a:	00004517          	auipc	a0,0x4
ffffffffc020096e:	08650513          	addi	a0,a0,134 # ffffffffc02049f0 <commands+0x5b8>
ffffffffc0200972:	80bff0ef          	jal	ra,ffffffffc020017c <cprintf>
            if ((ret = pgfault_handler(tf)) != 0) {
ffffffffc0200976:	8522                	mv	a0,s0
ffffffffc0200978:	c1fff0ef          	jal	ra,ffffffffc0200596 <pgfault_handler>
ffffffffc020097c:	84aa                	mv	s1,a0
ffffffffc020097e:	d15d                	beqz	a0,ffffffffc0200924 <exception_handler+0x3e>
                print_trapframe(tf);
ffffffffc0200980:	8522                	mv	a0,s0
ffffffffc0200982:	e6bff0ef          	jal	ra,ffffffffc02007ec <print_trapframe>
                panic("handle pgfault failed. %e\n", ret);
ffffffffc0200986:	86a6                	mv	a3,s1
ffffffffc0200988:	00004617          	auipc	a2,0x4
ffffffffc020098c:	08060613          	addi	a2,a2,128 # ffffffffc0204a08 <commands+0x5d0>
ffffffffc0200990:	0b300593          	li	a1,179
ffffffffc0200994:	00004517          	auipc	a0,0x4
ffffffffc0200998:	b6450513          	addi	a0,a0,-1180 # ffffffffc02044f8 <commands+0xc0>
ffffffffc020099c:	aa7ff0ef          	jal	ra,ffffffffc0200442 <__panic>
            cprintf("AMO address misaligned\n");
ffffffffc02009a0:	00004517          	auipc	a0,0x4
ffffffffc02009a4:	08850513          	addi	a0,a0,136 # ffffffffc0204a28 <commands+0x5f0>
ffffffffc02009a8:	b779                	j	ffffffffc0200936 <exception_handler+0x50>
            cprintf("Store/AMO access fault\n");
ffffffffc02009aa:	00004517          	auipc	a0,0x4
ffffffffc02009ae:	09650513          	addi	a0,a0,150 # ffffffffc0204a40 <commands+0x608>
ffffffffc02009b2:	fcaff0ef          	jal	ra,ffffffffc020017c <cprintf>
            if ((ret = pgfault_handler(tf)) != 0) {
ffffffffc02009b6:	8522                	mv	a0,s0
ffffffffc02009b8:	bdfff0ef          	jal	ra,ffffffffc0200596 <pgfault_handler>
ffffffffc02009bc:	84aa                	mv	s1,a0
ffffffffc02009be:	d13d                	beqz	a0,ffffffffc0200924 <exception_handler+0x3e>
                print_trapframe(tf);
ffffffffc02009c0:	8522                	mv	a0,s0
ffffffffc02009c2:	e2bff0ef          	jal	ra,ffffffffc02007ec <print_trapframe>
                panic("handle pgfault failed. %e\n", ret);
ffffffffc02009c6:	86a6                	mv	a3,s1
ffffffffc02009c8:	00004617          	auipc	a2,0x4
ffffffffc02009cc:	04060613          	addi	a2,a2,64 # ffffffffc0204a08 <commands+0x5d0>
ffffffffc02009d0:	0bd00593          	li	a1,189
ffffffffc02009d4:	00004517          	auipc	a0,0x4
ffffffffc02009d8:	b2450513          	addi	a0,a0,-1244 # ffffffffc02044f8 <commands+0xc0>
ffffffffc02009dc:	a67ff0ef          	jal	ra,ffffffffc0200442 <__panic>
            cprintf("Environment call from U-mode\n");
ffffffffc02009e0:	00004517          	auipc	a0,0x4
ffffffffc02009e4:	07850513          	addi	a0,a0,120 # ffffffffc0204a58 <commands+0x620>
ffffffffc02009e8:	b7b9                	j	ffffffffc0200936 <exception_handler+0x50>
            cprintf("Environment call from S-mode\n");
ffffffffc02009ea:	00004517          	auipc	a0,0x4
ffffffffc02009ee:	08e50513          	addi	a0,a0,142 # ffffffffc0204a78 <commands+0x640>
ffffffffc02009f2:	b791                	j	ffffffffc0200936 <exception_handler+0x50>
            cprintf("Environment call from H-mode\n");
ffffffffc02009f4:	00004517          	auipc	a0,0x4
ffffffffc02009f8:	0a450513          	addi	a0,a0,164 # ffffffffc0204a98 <commands+0x660>
ffffffffc02009fc:	bf2d                	j	ffffffffc0200936 <exception_handler+0x50>
            cprintf("Environment call from M-mode\n");
ffffffffc02009fe:	00004517          	auipc	a0,0x4
ffffffffc0200a02:	0ba50513          	addi	a0,a0,186 # ffffffffc0204ab8 <commands+0x680>
ffffffffc0200a06:	bf05                	j	ffffffffc0200936 <exception_handler+0x50>
            cprintf("Instruction page fault\n");
ffffffffc0200a08:	00004517          	auipc	a0,0x4
ffffffffc0200a0c:	0d050513          	addi	a0,a0,208 # ffffffffc0204ad8 <commands+0x6a0>
ffffffffc0200a10:	b71d                	j	ffffffffc0200936 <exception_handler+0x50>
            cprintf("Load page fault\n");
ffffffffc0200a12:	00004517          	auipc	a0,0x4
ffffffffc0200a16:	0de50513          	addi	a0,a0,222 # ffffffffc0204af0 <commands+0x6b8>
ffffffffc0200a1a:	f62ff0ef          	jal	ra,ffffffffc020017c <cprintf>
            if ((ret = pgfault_handler(tf)) != 0) {
ffffffffc0200a1e:	8522                	mv	a0,s0
ffffffffc0200a20:	b77ff0ef          	jal	ra,ffffffffc0200596 <pgfault_handler>
ffffffffc0200a24:	84aa                	mv	s1,a0
ffffffffc0200a26:	ee050fe3          	beqz	a0,ffffffffc0200924 <exception_handler+0x3e>
                print_trapframe(tf);
ffffffffc0200a2a:	8522                	mv	a0,s0
ffffffffc0200a2c:	dc1ff0ef          	jal	ra,ffffffffc02007ec <print_trapframe>
                panic("handle pgfault failed. %e\n", ret);
ffffffffc0200a30:	86a6                	mv	a3,s1
ffffffffc0200a32:	00004617          	auipc	a2,0x4
ffffffffc0200a36:	fd660613          	addi	a2,a2,-42 # ffffffffc0204a08 <commands+0x5d0>
ffffffffc0200a3a:	0d300593          	li	a1,211
ffffffffc0200a3e:	00004517          	auipc	a0,0x4
ffffffffc0200a42:	aba50513          	addi	a0,a0,-1350 # ffffffffc02044f8 <commands+0xc0>
ffffffffc0200a46:	9fdff0ef          	jal	ra,ffffffffc0200442 <__panic>
            print_trapframe(tf);
ffffffffc0200a4a:	8522                	mv	a0,s0
}
ffffffffc0200a4c:	6442                	ld	s0,16(sp)
ffffffffc0200a4e:	60e2                	ld	ra,24(sp)
ffffffffc0200a50:	64a2                	ld	s1,8(sp)
ffffffffc0200a52:	6105                	addi	sp,sp,32
            print_trapframe(tf);
ffffffffc0200a54:	bb61                	j	ffffffffc02007ec <print_trapframe>
                print_trapframe(tf);
ffffffffc0200a56:	8522                	mv	a0,s0
ffffffffc0200a58:	d95ff0ef          	jal	ra,ffffffffc02007ec <print_trapframe>
                panic("handle pgfault failed. %e\n", ret);
ffffffffc0200a5c:	86a6                	mv	a3,s1
ffffffffc0200a5e:	00004617          	auipc	a2,0x4
ffffffffc0200a62:	faa60613          	addi	a2,a2,-86 # ffffffffc0204a08 <commands+0x5d0>
ffffffffc0200a66:	0da00593          	li	a1,218
ffffffffc0200a6a:	00004517          	auipc	a0,0x4
ffffffffc0200a6e:	a8e50513          	addi	a0,a0,-1394 # ffffffffc02044f8 <commands+0xc0>
ffffffffc0200a72:	9d1ff0ef          	jal	ra,ffffffffc0200442 <__panic>

ffffffffc0200a76 <trap>:
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void trap(struct trapframe *tf) {
    // dispatch based on what type of trap occurred
    if ((intptr_t)tf->cause < 0) {
ffffffffc0200a76:	11853783          	ld	a5,280(a0)
ffffffffc0200a7a:	0007c363          	bltz	a5,ffffffffc0200a80 <trap+0xa>
        // interrupts
        interrupt_handler(tf);
    } else {
        // exceptions
        exception_handler(tf);
ffffffffc0200a7e:	b5a5                	j	ffffffffc02008e6 <exception_handler>
        interrupt_handler(tf);
ffffffffc0200a80:	b3f9                	j	ffffffffc020084e <interrupt_handler>
	...

ffffffffc0200a84 <__alltraps>:
    LOAD  x2,2*REGBYTES(sp)
    .endm

    .globl __alltraps
__alltraps:
    SAVE_ALL
ffffffffc0200a84:	14011073          	csrw	sscratch,sp
ffffffffc0200a88:	712d                	addi	sp,sp,-288
ffffffffc0200a8a:	e406                	sd	ra,8(sp)
ffffffffc0200a8c:	ec0e                	sd	gp,24(sp)
ffffffffc0200a8e:	f012                	sd	tp,32(sp)
ffffffffc0200a90:	f416                	sd	t0,40(sp)
ffffffffc0200a92:	f81a                	sd	t1,48(sp)
ffffffffc0200a94:	fc1e                	sd	t2,56(sp)
ffffffffc0200a96:	e0a2                	sd	s0,64(sp)
ffffffffc0200a98:	e4a6                	sd	s1,72(sp)
ffffffffc0200a9a:	e8aa                	sd	a0,80(sp)
ffffffffc0200a9c:	ecae                	sd	a1,88(sp)
ffffffffc0200a9e:	f0b2                	sd	a2,96(sp)
ffffffffc0200aa0:	f4b6                	sd	a3,104(sp)
ffffffffc0200aa2:	f8ba                	sd	a4,112(sp)
ffffffffc0200aa4:	fcbe                	sd	a5,120(sp)
ffffffffc0200aa6:	e142                	sd	a6,128(sp)
ffffffffc0200aa8:	e546                	sd	a7,136(sp)
ffffffffc0200aaa:	e94a                	sd	s2,144(sp)
ffffffffc0200aac:	ed4e                	sd	s3,152(sp)
ffffffffc0200aae:	f152                	sd	s4,160(sp)
ffffffffc0200ab0:	f556                	sd	s5,168(sp)
ffffffffc0200ab2:	f95a                	sd	s6,176(sp)
ffffffffc0200ab4:	fd5e                	sd	s7,184(sp)
ffffffffc0200ab6:	e1e2                	sd	s8,192(sp)
ffffffffc0200ab8:	e5e6                	sd	s9,200(sp)
ffffffffc0200aba:	e9ea                	sd	s10,208(sp)
ffffffffc0200abc:	edee                	sd	s11,216(sp)
ffffffffc0200abe:	f1f2                	sd	t3,224(sp)
ffffffffc0200ac0:	f5f6                	sd	t4,232(sp)
ffffffffc0200ac2:	f9fa                	sd	t5,240(sp)
ffffffffc0200ac4:	fdfe                	sd	t6,248(sp)
ffffffffc0200ac6:	14002473          	csrr	s0,sscratch
ffffffffc0200aca:	100024f3          	csrr	s1,sstatus
ffffffffc0200ace:	14102973          	csrr	s2,sepc
ffffffffc0200ad2:	143029f3          	csrr	s3,stval
ffffffffc0200ad6:	14202a73          	csrr	s4,scause
ffffffffc0200ada:	e822                	sd	s0,16(sp)
ffffffffc0200adc:	e226                	sd	s1,256(sp)
ffffffffc0200ade:	e64a                	sd	s2,264(sp)
ffffffffc0200ae0:	ea4e                	sd	s3,272(sp)
ffffffffc0200ae2:	ee52                	sd	s4,280(sp)

    move  a0, sp
ffffffffc0200ae4:	850a                	mv	a0,sp
    jal trap
ffffffffc0200ae6:	f91ff0ef          	jal	ra,ffffffffc0200a76 <trap>

ffffffffc0200aea <__trapret>:
    # sp should be the same as before "jal trap"

    .globl __trapret
__trapret:
    RESTORE_ALL
ffffffffc0200aea:	6492                	ld	s1,256(sp)
ffffffffc0200aec:	6932                	ld	s2,264(sp)
ffffffffc0200aee:	10049073          	csrw	sstatus,s1
ffffffffc0200af2:	14191073          	csrw	sepc,s2
ffffffffc0200af6:	60a2                	ld	ra,8(sp)
ffffffffc0200af8:	61e2                	ld	gp,24(sp)
ffffffffc0200afa:	7202                	ld	tp,32(sp)
ffffffffc0200afc:	72a2                	ld	t0,40(sp)
ffffffffc0200afe:	7342                	ld	t1,48(sp)
ffffffffc0200b00:	73e2                	ld	t2,56(sp)
ffffffffc0200b02:	6406                	ld	s0,64(sp)
ffffffffc0200b04:	64a6                	ld	s1,72(sp)
ffffffffc0200b06:	6546                	ld	a0,80(sp)
ffffffffc0200b08:	65e6                	ld	a1,88(sp)
ffffffffc0200b0a:	7606                	ld	a2,96(sp)
ffffffffc0200b0c:	76a6                	ld	a3,104(sp)
ffffffffc0200b0e:	7746                	ld	a4,112(sp)
ffffffffc0200b10:	77e6                	ld	a5,120(sp)
ffffffffc0200b12:	680a                	ld	a6,128(sp)
ffffffffc0200b14:	68aa                	ld	a7,136(sp)
ffffffffc0200b16:	694a                	ld	s2,144(sp)
ffffffffc0200b18:	69ea                	ld	s3,152(sp)
ffffffffc0200b1a:	7a0a                	ld	s4,160(sp)
ffffffffc0200b1c:	7aaa                	ld	s5,168(sp)
ffffffffc0200b1e:	7b4a                	ld	s6,176(sp)
ffffffffc0200b20:	7bea                	ld	s7,184(sp)
ffffffffc0200b22:	6c0e                	ld	s8,192(sp)
ffffffffc0200b24:	6cae                	ld	s9,200(sp)
ffffffffc0200b26:	6d4e                	ld	s10,208(sp)
ffffffffc0200b28:	6dee                	ld	s11,216(sp)
ffffffffc0200b2a:	7e0e                	ld	t3,224(sp)
ffffffffc0200b2c:	7eae                	ld	t4,232(sp)
ffffffffc0200b2e:	7f4e                	ld	t5,240(sp)
ffffffffc0200b30:	7fee                	ld	t6,248(sp)
ffffffffc0200b32:	6142                	ld	sp,16(sp)
    # go back from supervisor call
    sret
ffffffffc0200b34:	10200073          	sret

ffffffffc0200b38 <forkrets>:
 
    .globl forkrets
forkrets:
    # set stack to this new process's trapframe
    move sp, a0
ffffffffc0200b38:	812a                	mv	sp,a0
    j __trapret
ffffffffc0200b3a:	bf45                	j	ffffffffc0200aea <__trapret>
	...

ffffffffc0200b3e <default_init>:
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
ffffffffc0200b3e:	00011797          	auipc	a5,0x11
ffffffffc0200b42:	8e278793          	addi	a5,a5,-1822 # ffffffffc0211420 <free_area>
ffffffffc0200b46:	e79c                	sd	a5,8(a5)
ffffffffc0200b48:	e39c                	sd	a5,0(a5)
#define nr_free (free_area.nr_free)

static void
default_init(void) {
    list_init(&free_list);
    nr_free = 0;
ffffffffc0200b4a:	0007a823          	sw	zero,16(a5)
}
ffffffffc0200b4e:	8082                	ret

ffffffffc0200b50 <default_nr_free_pages>:
}

static size_t
default_nr_free_pages(void) {
    return nr_free;
}
ffffffffc0200b50:	00011517          	auipc	a0,0x11
ffffffffc0200b54:	8e056503          	lwu	a0,-1824(a0) # ffffffffc0211430 <free_area+0x10>
ffffffffc0200b58:	8082                	ret

ffffffffc0200b5a <default_check>:
}

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1) 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
ffffffffc0200b5a:	715d                	addi	sp,sp,-80
ffffffffc0200b5c:	e0a2                	sd	s0,64(sp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
ffffffffc0200b5e:	00011417          	auipc	s0,0x11
ffffffffc0200b62:	8c240413          	addi	s0,s0,-1854 # ffffffffc0211420 <free_area>
ffffffffc0200b66:	641c                	ld	a5,8(s0)
ffffffffc0200b68:	e486                	sd	ra,72(sp)
ffffffffc0200b6a:	fc26                	sd	s1,56(sp)
ffffffffc0200b6c:	f84a                	sd	s2,48(sp)
ffffffffc0200b6e:	f44e                	sd	s3,40(sp)
ffffffffc0200b70:	f052                	sd	s4,32(sp)
ffffffffc0200b72:	ec56                	sd	s5,24(sp)
ffffffffc0200b74:	e85a                	sd	s6,16(sp)
ffffffffc0200b76:	e45e                	sd	s7,8(sp)
ffffffffc0200b78:	e062                	sd	s8,0(sp)
    int count = 0, total = 0;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
ffffffffc0200b7a:	2c878763          	beq	a5,s0,ffffffffc0200e48 <default_check+0x2ee>
    int count = 0, total = 0;
ffffffffc0200b7e:	4481                	li	s1,0
ffffffffc0200b80:	4901                	li	s2,0
 * test_bit - Determine whether a bit is set
 * @nr:     the bit to test
 * @addr:   the address to count from
 * */
static inline bool test_bit(int nr, volatile void *addr) {
    return (((*(volatile unsigned long *)addr) >> nr) & 1);
ffffffffc0200b82:	fe87b703          	ld	a4,-24(a5)
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
ffffffffc0200b86:	8b09                	andi	a4,a4,2
ffffffffc0200b88:	2c070463          	beqz	a4,ffffffffc0200e50 <default_check+0x2f6>
        count ++, total += p->property;
ffffffffc0200b8c:	ff87a703          	lw	a4,-8(a5)
ffffffffc0200b90:	679c                	ld	a5,8(a5)
ffffffffc0200b92:	2905                	addiw	s2,s2,1
ffffffffc0200b94:	9cb9                	addw	s1,s1,a4
    while ((le = list_next(le)) != &free_list) {
ffffffffc0200b96:	fe8796e3          	bne	a5,s0,ffffffffc0200b82 <default_check+0x28>
    }
    assert(total == nr_free_pages());
ffffffffc0200b9a:	89a6                	mv	s3,s1
ffffffffc0200b9c:	76b000ef          	jal	ra,ffffffffc0201b06 <nr_free_pages>
ffffffffc0200ba0:	71351863          	bne	a0,s3,ffffffffc02012b0 <default_check+0x756>
    assert((p0 = alloc_page()) != NULL);
ffffffffc0200ba4:	4505                	li	a0,1
ffffffffc0200ba6:	68f000ef          	jal	ra,ffffffffc0201a34 <alloc_pages>
ffffffffc0200baa:	8a2a                	mv	s4,a0
ffffffffc0200bac:	44050263          	beqz	a0,ffffffffc0200ff0 <default_check+0x496>
    assert((p1 = alloc_page()) != NULL);
ffffffffc0200bb0:	4505                	li	a0,1
ffffffffc0200bb2:	683000ef          	jal	ra,ffffffffc0201a34 <alloc_pages>
ffffffffc0200bb6:	89aa                	mv	s3,a0
ffffffffc0200bb8:	70050c63          	beqz	a0,ffffffffc02012d0 <default_check+0x776>
    assert((p2 = alloc_page()) != NULL);
ffffffffc0200bbc:	4505                	li	a0,1
ffffffffc0200bbe:	677000ef          	jal	ra,ffffffffc0201a34 <alloc_pages>
ffffffffc0200bc2:	8aaa                	mv	s5,a0
ffffffffc0200bc4:	4a050663          	beqz	a0,ffffffffc0201070 <default_check+0x516>
    assert(p0 != p1 && p0 != p2 && p1 != p2);
ffffffffc0200bc8:	2b3a0463          	beq	s4,s3,ffffffffc0200e70 <default_check+0x316>
ffffffffc0200bcc:	2aaa0263          	beq	s4,a0,ffffffffc0200e70 <default_check+0x316>
ffffffffc0200bd0:	2aa98063          	beq	s3,a0,ffffffffc0200e70 <default_check+0x316>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
ffffffffc0200bd4:	000a2783          	lw	a5,0(s4)
ffffffffc0200bd8:	2a079c63          	bnez	a5,ffffffffc0200e90 <default_check+0x336>
ffffffffc0200bdc:	0009a783          	lw	a5,0(s3)
ffffffffc0200be0:	2a079863          	bnez	a5,ffffffffc0200e90 <default_check+0x336>
ffffffffc0200be4:	411c                	lw	a5,0(a0)
ffffffffc0200be6:	2a079563          	bnez	a5,ffffffffc0200e90 <default_check+0x336>
extern size_t npage;
extern uint_t va_pa_offset;

static inline ppn_t
page2ppn(struct Page *page) {
    return page - pages + nbase;
ffffffffc0200bea:	00015797          	auipc	a5,0x15
ffffffffc0200bee:	8a67b783          	ld	a5,-1882(a5) # ffffffffc0215490 <pages>
ffffffffc0200bf2:	40fa0733          	sub	a4,s4,a5
ffffffffc0200bf6:	870d                	srai	a4,a4,0x3
ffffffffc0200bf8:	00005597          	auipc	a1,0x5
ffffffffc0200bfc:	4405b583          	ld	a1,1088(a1) # ffffffffc0206038 <error_string+0x38>
ffffffffc0200c00:	02b70733          	mul	a4,a4,a1
ffffffffc0200c04:	00005617          	auipc	a2,0x5
ffffffffc0200c08:	43c63603          	ld	a2,1084(a2) # ffffffffc0206040 <nbase>
    assert(page2pa(p0) < npage * PGSIZE);
ffffffffc0200c0c:	00015697          	auipc	a3,0x15
ffffffffc0200c10:	87c6b683          	ld	a3,-1924(a3) # ffffffffc0215488 <npage>
ffffffffc0200c14:	06b2                	slli	a3,a3,0xc
ffffffffc0200c16:	9732                	add	a4,a4,a2
}

static inline uintptr_t
page2pa(struct Page *page) {
    return page2ppn(page) << PGSHIFT;
ffffffffc0200c18:	0732                	slli	a4,a4,0xc
ffffffffc0200c1a:	28d77b63          	bgeu	a4,a3,ffffffffc0200eb0 <default_check+0x356>
    return page - pages + nbase;
ffffffffc0200c1e:	40f98733          	sub	a4,s3,a5
ffffffffc0200c22:	870d                	srai	a4,a4,0x3
ffffffffc0200c24:	02b70733          	mul	a4,a4,a1
ffffffffc0200c28:	9732                	add	a4,a4,a2
    return page2ppn(page) << PGSHIFT;
ffffffffc0200c2a:	0732                	slli	a4,a4,0xc
    assert(page2pa(p1) < npage * PGSIZE);
ffffffffc0200c2c:	4cd77263          	bgeu	a4,a3,ffffffffc02010f0 <default_check+0x596>
    return page - pages + nbase;
ffffffffc0200c30:	40f507b3          	sub	a5,a0,a5
ffffffffc0200c34:	878d                	srai	a5,a5,0x3
ffffffffc0200c36:	02b787b3          	mul	a5,a5,a1
ffffffffc0200c3a:	97b2                	add	a5,a5,a2
    return page2ppn(page) << PGSHIFT;
ffffffffc0200c3c:	07b2                	slli	a5,a5,0xc
    assert(page2pa(p2) < npage * PGSIZE);
ffffffffc0200c3e:	30d7f963          	bgeu	a5,a3,ffffffffc0200f50 <default_check+0x3f6>
    assert(alloc_page() == NULL);
ffffffffc0200c42:	4505                	li	a0,1
    list_entry_t free_list_store = free_list;
ffffffffc0200c44:	00043c03          	ld	s8,0(s0)
ffffffffc0200c48:	00843b83          	ld	s7,8(s0)
    unsigned int nr_free_store = nr_free;
ffffffffc0200c4c:	01042b03          	lw	s6,16(s0)
    elm->prev = elm->next = elm;
ffffffffc0200c50:	e400                	sd	s0,8(s0)
ffffffffc0200c52:	e000                	sd	s0,0(s0)
    nr_free = 0;
ffffffffc0200c54:	00010797          	auipc	a5,0x10
ffffffffc0200c58:	7c07ae23          	sw	zero,2012(a5) # ffffffffc0211430 <free_area+0x10>
    assert(alloc_page() == NULL);
ffffffffc0200c5c:	5d9000ef          	jal	ra,ffffffffc0201a34 <alloc_pages>
ffffffffc0200c60:	2c051863          	bnez	a0,ffffffffc0200f30 <default_check+0x3d6>
    free_page(p0);
ffffffffc0200c64:	4585                	li	a1,1
ffffffffc0200c66:	8552                	mv	a0,s4
ffffffffc0200c68:	65f000ef          	jal	ra,ffffffffc0201ac6 <free_pages>
    free_page(p1);
ffffffffc0200c6c:	4585                	li	a1,1
ffffffffc0200c6e:	854e                	mv	a0,s3
ffffffffc0200c70:	657000ef          	jal	ra,ffffffffc0201ac6 <free_pages>
    free_page(p2);
ffffffffc0200c74:	4585                	li	a1,1
ffffffffc0200c76:	8556                	mv	a0,s5
ffffffffc0200c78:	64f000ef          	jal	ra,ffffffffc0201ac6 <free_pages>
    assert(nr_free == 3);
ffffffffc0200c7c:	4818                	lw	a4,16(s0)
ffffffffc0200c7e:	478d                	li	a5,3
ffffffffc0200c80:	28f71863          	bne	a4,a5,ffffffffc0200f10 <default_check+0x3b6>
    assert((p0 = alloc_page()) != NULL);
ffffffffc0200c84:	4505                	li	a0,1
ffffffffc0200c86:	5af000ef          	jal	ra,ffffffffc0201a34 <alloc_pages>
ffffffffc0200c8a:	89aa                	mv	s3,a0
ffffffffc0200c8c:	26050263          	beqz	a0,ffffffffc0200ef0 <default_check+0x396>
    assert((p1 = alloc_page()) != NULL);
ffffffffc0200c90:	4505                	li	a0,1
ffffffffc0200c92:	5a3000ef          	jal	ra,ffffffffc0201a34 <alloc_pages>
ffffffffc0200c96:	8aaa                	mv	s5,a0
ffffffffc0200c98:	3a050c63          	beqz	a0,ffffffffc0201050 <default_check+0x4f6>
    assert((p2 = alloc_page()) != NULL);
ffffffffc0200c9c:	4505                	li	a0,1
ffffffffc0200c9e:	597000ef          	jal	ra,ffffffffc0201a34 <alloc_pages>
ffffffffc0200ca2:	8a2a                	mv	s4,a0
ffffffffc0200ca4:	38050663          	beqz	a0,ffffffffc0201030 <default_check+0x4d6>
    assert(alloc_page() == NULL);
ffffffffc0200ca8:	4505                	li	a0,1
ffffffffc0200caa:	58b000ef          	jal	ra,ffffffffc0201a34 <alloc_pages>
ffffffffc0200cae:	36051163          	bnez	a0,ffffffffc0201010 <default_check+0x4b6>
    free_page(p0);
ffffffffc0200cb2:	4585                	li	a1,1
ffffffffc0200cb4:	854e                	mv	a0,s3
ffffffffc0200cb6:	611000ef          	jal	ra,ffffffffc0201ac6 <free_pages>
    assert(!list_empty(&free_list));
ffffffffc0200cba:	641c                	ld	a5,8(s0)
ffffffffc0200cbc:	20878a63          	beq	a5,s0,ffffffffc0200ed0 <default_check+0x376>
    assert((p = alloc_page()) == p0);
ffffffffc0200cc0:	4505                	li	a0,1
ffffffffc0200cc2:	573000ef          	jal	ra,ffffffffc0201a34 <alloc_pages>
ffffffffc0200cc6:	30a99563          	bne	s3,a0,ffffffffc0200fd0 <default_check+0x476>
    assert(alloc_page() == NULL);
ffffffffc0200cca:	4505                	li	a0,1
ffffffffc0200ccc:	569000ef          	jal	ra,ffffffffc0201a34 <alloc_pages>
ffffffffc0200cd0:	2e051063          	bnez	a0,ffffffffc0200fb0 <default_check+0x456>
    assert(nr_free == 0);
ffffffffc0200cd4:	481c                	lw	a5,16(s0)
ffffffffc0200cd6:	2a079d63          	bnez	a5,ffffffffc0200f90 <default_check+0x436>
    free_page(p);
ffffffffc0200cda:	854e                	mv	a0,s3
ffffffffc0200cdc:	4585                	li	a1,1
    free_list = free_list_store;
ffffffffc0200cde:	01843023          	sd	s8,0(s0)
ffffffffc0200ce2:	01743423          	sd	s7,8(s0)
    nr_free = nr_free_store;
ffffffffc0200ce6:	01642823          	sw	s6,16(s0)
    free_page(p);
ffffffffc0200cea:	5dd000ef          	jal	ra,ffffffffc0201ac6 <free_pages>
    free_page(p1);
ffffffffc0200cee:	4585                	li	a1,1
ffffffffc0200cf0:	8556                	mv	a0,s5
ffffffffc0200cf2:	5d5000ef          	jal	ra,ffffffffc0201ac6 <free_pages>
    free_page(p2);
ffffffffc0200cf6:	4585                	li	a1,1
ffffffffc0200cf8:	8552                	mv	a0,s4
ffffffffc0200cfa:	5cd000ef          	jal	ra,ffffffffc0201ac6 <free_pages>

    basic_check();

    struct Page *p0 = alloc_pages(5), *p1, *p2;
ffffffffc0200cfe:	4515                	li	a0,5
ffffffffc0200d00:	535000ef          	jal	ra,ffffffffc0201a34 <alloc_pages>
ffffffffc0200d04:	89aa                	mv	s3,a0
    assert(p0 != NULL);
ffffffffc0200d06:	26050563          	beqz	a0,ffffffffc0200f70 <default_check+0x416>
ffffffffc0200d0a:	651c                	ld	a5,8(a0)
ffffffffc0200d0c:	8385                	srli	a5,a5,0x1
    assert(!PageProperty(p0));
ffffffffc0200d0e:	8b85                	andi	a5,a5,1
ffffffffc0200d10:	54079063          	bnez	a5,ffffffffc0201250 <default_check+0x6f6>

    list_entry_t free_list_store = free_list;
    list_init(&free_list);
    assert(list_empty(&free_list));
    assert(alloc_page() == NULL);
ffffffffc0200d14:	4505                	li	a0,1
    list_entry_t free_list_store = free_list;
ffffffffc0200d16:	00043b03          	ld	s6,0(s0)
ffffffffc0200d1a:	00843a83          	ld	s5,8(s0)
ffffffffc0200d1e:	e000                	sd	s0,0(s0)
ffffffffc0200d20:	e400                	sd	s0,8(s0)
    assert(alloc_page() == NULL);
ffffffffc0200d22:	513000ef          	jal	ra,ffffffffc0201a34 <alloc_pages>
ffffffffc0200d26:	50051563          	bnez	a0,ffffffffc0201230 <default_check+0x6d6>

    unsigned int nr_free_store = nr_free;
    nr_free = 0;

    free_pages(p0 + 2, 3);
ffffffffc0200d2a:	09098a13          	addi	s4,s3,144
ffffffffc0200d2e:	8552                	mv	a0,s4
ffffffffc0200d30:	458d                	li	a1,3
    unsigned int nr_free_store = nr_free;
ffffffffc0200d32:	01042b83          	lw	s7,16(s0)
    nr_free = 0;
ffffffffc0200d36:	00010797          	auipc	a5,0x10
ffffffffc0200d3a:	6e07ad23          	sw	zero,1786(a5) # ffffffffc0211430 <free_area+0x10>
    free_pages(p0 + 2, 3);
ffffffffc0200d3e:	589000ef          	jal	ra,ffffffffc0201ac6 <free_pages>
    assert(alloc_pages(4) == NULL);
ffffffffc0200d42:	4511                	li	a0,4
ffffffffc0200d44:	4f1000ef          	jal	ra,ffffffffc0201a34 <alloc_pages>
ffffffffc0200d48:	4c051463          	bnez	a0,ffffffffc0201210 <default_check+0x6b6>
ffffffffc0200d4c:	0989b783          	ld	a5,152(s3)
ffffffffc0200d50:	8385                	srli	a5,a5,0x1
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
ffffffffc0200d52:	8b85                	andi	a5,a5,1
ffffffffc0200d54:	48078e63          	beqz	a5,ffffffffc02011f0 <default_check+0x696>
ffffffffc0200d58:	0a89a703          	lw	a4,168(s3)
ffffffffc0200d5c:	478d                	li	a5,3
ffffffffc0200d5e:	48f71963          	bne	a4,a5,ffffffffc02011f0 <default_check+0x696>
    assert((p1 = alloc_pages(3)) != NULL);
ffffffffc0200d62:	450d                	li	a0,3
ffffffffc0200d64:	4d1000ef          	jal	ra,ffffffffc0201a34 <alloc_pages>
ffffffffc0200d68:	8c2a                	mv	s8,a0
ffffffffc0200d6a:	46050363          	beqz	a0,ffffffffc02011d0 <default_check+0x676>
    assert(alloc_page() == NULL);
ffffffffc0200d6e:	4505                	li	a0,1
ffffffffc0200d70:	4c5000ef          	jal	ra,ffffffffc0201a34 <alloc_pages>
ffffffffc0200d74:	42051e63          	bnez	a0,ffffffffc02011b0 <default_check+0x656>
    assert(p0 + 2 == p1);
ffffffffc0200d78:	418a1c63          	bne	s4,s8,ffffffffc0201190 <default_check+0x636>

    p2 = p0 + 1;
    free_page(p0);
ffffffffc0200d7c:	4585                	li	a1,1
ffffffffc0200d7e:	854e                	mv	a0,s3
ffffffffc0200d80:	547000ef          	jal	ra,ffffffffc0201ac6 <free_pages>
    free_pages(p1, 3);
ffffffffc0200d84:	458d                	li	a1,3
ffffffffc0200d86:	8552                	mv	a0,s4
ffffffffc0200d88:	53f000ef          	jal	ra,ffffffffc0201ac6 <free_pages>
ffffffffc0200d8c:	0089b783          	ld	a5,8(s3)
    p2 = p0 + 1;
ffffffffc0200d90:	04898c13          	addi	s8,s3,72
ffffffffc0200d94:	8385                	srli	a5,a5,0x1
    assert(PageProperty(p0) && p0->property == 1);
ffffffffc0200d96:	8b85                	andi	a5,a5,1
ffffffffc0200d98:	3c078c63          	beqz	a5,ffffffffc0201170 <default_check+0x616>
ffffffffc0200d9c:	0189a703          	lw	a4,24(s3)
ffffffffc0200da0:	4785                	li	a5,1
ffffffffc0200da2:	3cf71763          	bne	a4,a5,ffffffffc0201170 <default_check+0x616>
ffffffffc0200da6:	008a3783          	ld	a5,8(s4)
ffffffffc0200daa:	8385                	srli	a5,a5,0x1
    assert(PageProperty(p1) && p1->property == 3);
ffffffffc0200dac:	8b85                	andi	a5,a5,1
ffffffffc0200dae:	3a078163          	beqz	a5,ffffffffc0201150 <default_check+0x5f6>
ffffffffc0200db2:	018a2703          	lw	a4,24(s4)
ffffffffc0200db6:	478d                	li	a5,3
ffffffffc0200db8:	38f71c63          	bne	a4,a5,ffffffffc0201150 <default_check+0x5f6>

    assert((p0 = alloc_page()) == p2 - 1);
ffffffffc0200dbc:	4505                	li	a0,1
ffffffffc0200dbe:	477000ef          	jal	ra,ffffffffc0201a34 <alloc_pages>
ffffffffc0200dc2:	36a99763          	bne	s3,a0,ffffffffc0201130 <default_check+0x5d6>
    free_page(p0);
ffffffffc0200dc6:	4585                	li	a1,1
ffffffffc0200dc8:	4ff000ef          	jal	ra,ffffffffc0201ac6 <free_pages>
    assert((p0 = alloc_pages(2)) == p2 + 1);
ffffffffc0200dcc:	4509                	li	a0,2
ffffffffc0200dce:	467000ef          	jal	ra,ffffffffc0201a34 <alloc_pages>
ffffffffc0200dd2:	32aa1f63          	bne	s4,a0,ffffffffc0201110 <default_check+0x5b6>

    free_pages(p0, 2);
ffffffffc0200dd6:	4589                	li	a1,2
ffffffffc0200dd8:	4ef000ef          	jal	ra,ffffffffc0201ac6 <free_pages>
    free_page(p2);
ffffffffc0200ddc:	4585                	li	a1,1
ffffffffc0200dde:	8562                	mv	a0,s8
ffffffffc0200de0:	4e7000ef          	jal	ra,ffffffffc0201ac6 <free_pages>

    assert((p0 = alloc_pages(5)) != NULL);
ffffffffc0200de4:	4515                	li	a0,5
ffffffffc0200de6:	44f000ef          	jal	ra,ffffffffc0201a34 <alloc_pages>
ffffffffc0200dea:	89aa                	mv	s3,a0
ffffffffc0200dec:	48050263          	beqz	a0,ffffffffc0201270 <default_check+0x716>
    assert(alloc_page() == NULL);
ffffffffc0200df0:	4505                	li	a0,1
ffffffffc0200df2:	443000ef          	jal	ra,ffffffffc0201a34 <alloc_pages>
ffffffffc0200df6:	2c051d63          	bnez	a0,ffffffffc02010d0 <default_check+0x576>

    assert(nr_free == 0);
ffffffffc0200dfa:	481c                	lw	a5,16(s0)
ffffffffc0200dfc:	2a079a63          	bnez	a5,ffffffffc02010b0 <default_check+0x556>
    nr_free = nr_free_store;

    free_list = free_list_store;
    free_pages(p0, 5);
ffffffffc0200e00:	4595                	li	a1,5
ffffffffc0200e02:	854e                	mv	a0,s3
    nr_free = nr_free_store;
ffffffffc0200e04:	01742823          	sw	s7,16(s0)
    free_list = free_list_store;
ffffffffc0200e08:	01643023          	sd	s6,0(s0)
ffffffffc0200e0c:	01543423          	sd	s5,8(s0)
    free_pages(p0, 5);
ffffffffc0200e10:	4b7000ef          	jal	ra,ffffffffc0201ac6 <free_pages>
    return listelm->next;
ffffffffc0200e14:	641c                	ld	a5,8(s0)

    le = &free_list;
    while ((le = list_next(le)) != &free_list) {
ffffffffc0200e16:	00878963          	beq	a5,s0,ffffffffc0200e28 <default_check+0x2ce>
        struct Page *p = le2page(le, page_link);
        count --, total -= p->property;
ffffffffc0200e1a:	ff87a703          	lw	a4,-8(a5)
ffffffffc0200e1e:	679c                	ld	a5,8(a5)
ffffffffc0200e20:	397d                	addiw	s2,s2,-1
ffffffffc0200e22:	9c99                	subw	s1,s1,a4
    while ((le = list_next(le)) != &free_list) {
ffffffffc0200e24:	fe879be3          	bne	a5,s0,ffffffffc0200e1a <default_check+0x2c0>
    }
    assert(count == 0);
ffffffffc0200e28:	26091463          	bnez	s2,ffffffffc0201090 <default_check+0x536>
    assert(total == 0);
ffffffffc0200e2c:	46049263          	bnez	s1,ffffffffc0201290 <default_check+0x736>
}
ffffffffc0200e30:	60a6                	ld	ra,72(sp)
ffffffffc0200e32:	6406                	ld	s0,64(sp)
ffffffffc0200e34:	74e2                	ld	s1,56(sp)
ffffffffc0200e36:	7942                	ld	s2,48(sp)
ffffffffc0200e38:	79a2                	ld	s3,40(sp)
ffffffffc0200e3a:	7a02                	ld	s4,32(sp)
ffffffffc0200e3c:	6ae2                	ld	s5,24(sp)
ffffffffc0200e3e:	6b42                	ld	s6,16(sp)
ffffffffc0200e40:	6ba2                	ld	s7,8(sp)
ffffffffc0200e42:	6c02                	ld	s8,0(sp)
ffffffffc0200e44:	6161                	addi	sp,sp,80
ffffffffc0200e46:	8082                	ret
    while ((le = list_next(le)) != &free_list) {
ffffffffc0200e48:	4981                	li	s3,0
    int count = 0, total = 0;
ffffffffc0200e4a:	4481                	li	s1,0
ffffffffc0200e4c:	4901                	li	s2,0
ffffffffc0200e4e:	b3b9                	j	ffffffffc0200b9c <default_check+0x42>
        assert(PageProperty(p));
ffffffffc0200e50:	00004697          	auipc	a3,0x4
ffffffffc0200e54:	d1068693          	addi	a3,a3,-752 # ffffffffc0204b60 <commands+0x728>
ffffffffc0200e58:	00004617          	auipc	a2,0x4
ffffffffc0200e5c:	d1860613          	addi	a2,a2,-744 # ffffffffc0204b70 <commands+0x738>
ffffffffc0200e60:	0f000593          	li	a1,240
ffffffffc0200e64:	00004517          	auipc	a0,0x4
ffffffffc0200e68:	d2450513          	addi	a0,a0,-732 # ffffffffc0204b88 <commands+0x750>
ffffffffc0200e6c:	dd6ff0ef          	jal	ra,ffffffffc0200442 <__panic>
    assert(p0 != p1 && p0 != p2 && p1 != p2);
ffffffffc0200e70:	00004697          	auipc	a3,0x4
ffffffffc0200e74:	db068693          	addi	a3,a3,-592 # ffffffffc0204c20 <commands+0x7e8>
ffffffffc0200e78:	00004617          	auipc	a2,0x4
ffffffffc0200e7c:	cf860613          	addi	a2,a2,-776 # ffffffffc0204b70 <commands+0x738>
ffffffffc0200e80:	0bd00593          	li	a1,189
ffffffffc0200e84:	00004517          	auipc	a0,0x4
ffffffffc0200e88:	d0450513          	addi	a0,a0,-764 # ffffffffc0204b88 <commands+0x750>
ffffffffc0200e8c:	db6ff0ef          	jal	ra,ffffffffc0200442 <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
ffffffffc0200e90:	00004697          	auipc	a3,0x4
ffffffffc0200e94:	db868693          	addi	a3,a3,-584 # ffffffffc0204c48 <commands+0x810>
ffffffffc0200e98:	00004617          	auipc	a2,0x4
ffffffffc0200e9c:	cd860613          	addi	a2,a2,-808 # ffffffffc0204b70 <commands+0x738>
ffffffffc0200ea0:	0be00593          	li	a1,190
ffffffffc0200ea4:	00004517          	auipc	a0,0x4
ffffffffc0200ea8:	ce450513          	addi	a0,a0,-796 # ffffffffc0204b88 <commands+0x750>
ffffffffc0200eac:	d96ff0ef          	jal	ra,ffffffffc0200442 <__panic>
    assert(page2pa(p0) < npage * PGSIZE);
ffffffffc0200eb0:	00004697          	auipc	a3,0x4
ffffffffc0200eb4:	dd868693          	addi	a3,a3,-552 # ffffffffc0204c88 <commands+0x850>
ffffffffc0200eb8:	00004617          	auipc	a2,0x4
ffffffffc0200ebc:	cb860613          	addi	a2,a2,-840 # ffffffffc0204b70 <commands+0x738>
ffffffffc0200ec0:	0c000593          	li	a1,192
ffffffffc0200ec4:	00004517          	auipc	a0,0x4
ffffffffc0200ec8:	cc450513          	addi	a0,a0,-828 # ffffffffc0204b88 <commands+0x750>
ffffffffc0200ecc:	d76ff0ef          	jal	ra,ffffffffc0200442 <__panic>
    assert(!list_empty(&free_list));
ffffffffc0200ed0:	00004697          	auipc	a3,0x4
ffffffffc0200ed4:	e4068693          	addi	a3,a3,-448 # ffffffffc0204d10 <commands+0x8d8>
ffffffffc0200ed8:	00004617          	auipc	a2,0x4
ffffffffc0200edc:	c9860613          	addi	a2,a2,-872 # ffffffffc0204b70 <commands+0x738>
ffffffffc0200ee0:	0d900593          	li	a1,217
ffffffffc0200ee4:	00004517          	auipc	a0,0x4
ffffffffc0200ee8:	ca450513          	addi	a0,a0,-860 # ffffffffc0204b88 <commands+0x750>
ffffffffc0200eec:	d56ff0ef          	jal	ra,ffffffffc0200442 <__panic>
    assert((p0 = alloc_page()) != NULL);
ffffffffc0200ef0:	00004697          	auipc	a3,0x4
ffffffffc0200ef4:	cd068693          	addi	a3,a3,-816 # ffffffffc0204bc0 <commands+0x788>
ffffffffc0200ef8:	00004617          	auipc	a2,0x4
ffffffffc0200efc:	c7860613          	addi	a2,a2,-904 # ffffffffc0204b70 <commands+0x738>
ffffffffc0200f00:	0d200593          	li	a1,210
ffffffffc0200f04:	00004517          	auipc	a0,0x4
ffffffffc0200f08:	c8450513          	addi	a0,a0,-892 # ffffffffc0204b88 <commands+0x750>
ffffffffc0200f0c:	d36ff0ef          	jal	ra,ffffffffc0200442 <__panic>
    assert(nr_free == 3);
ffffffffc0200f10:	00004697          	auipc	a3,0x4
ffffffffc0200f14:	df068693          	addi	a3,a3,-528 # ffffffffc0204d00 <commands+0x8c8>
ffffffffc0200f18:	00004617          	auipc	a2,0x4
ffffffffc0200f1c:	c5860613          	addi	a2,a2,-936 # ffffffffc0204b70 <commands+0x738>
ffffffffc0200f20:	0d000593          	li	a1,208
ffffffffc0200f24:	00004517          	auipc	a0,0x4
ffffffffc0200f28:	c6450513          	addi	a0,a0,-924 # ffffffffc0204b88 <commands+0x750>
ffffffffc0200f2c:	d16ff0ef          	jal	ra,ffffffffc0200442 <__panic>
    assert(alloc_page() == NULL);
ffffffffc0200f30:	00004697          	auipc	a3,0x4
ffffffffc0200f34:	db868693          	addi	a3,a3,-584 # ffffffffc0204ce8 <commands+0x8b0>
ffffffffc0200f38:	00004617          	auipc	a2,0x4
ffffffffc0200f3c:	c3860613          	addi	a2,a2,-968 # ffffffffc0204b70 <commands+0x738>
ffffffffc0200f40:	0cb00593          	li	a1,203
ffffffffc0200f44:	00004517          	auipc	a0,0x4
ffffffffc0200f48:	c4450513          	addi	a0,a0,-956 # ffffffffc0204b88 <commands+0x750>
ffffffffc0200f4c:	cf6ff0ef          	jal	ra,ffffffffc0200442 <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
ffffffffc0200f50:	00004697          	auipc	a3,0x4
ffffffffc0200f54:	d7868693          	addi	a3,a3,-648 # ffffffffc0204cc8 <commands+0x890>
ffffffffc0200f58:	00004617          	auipc	a2,0x4
ffffffffc0200f5c:	c1860613          	addi	a2,a2,-1000 # ffffffffc0204b70 <commands+0x738>
ffffffffc0200f60:	0c200593          	li	a1,194
ffffffffc0200f64:	00004517          	auipc	a0,0x4
ffffffffc0200f68:	c2450513          	addi	a0,a0,-988 # ffffffffc0204b88 <commands+0x750>
ffffffffc0200f6c:	cd6ff0ef          	jal	ra,ffffffffc0200442 <__panic>
    assert(p0 != NULL);
ffffffffc0200f70:	00004697          	auipc	a3,0x4
ffffffffc0200f74:	de868693          	addi	a3,a3,-536 # ffffffffc0204d58 <commands+0x920>
ffffffffc0200f78:	00004617          	auipc	a2,0x4
ffffffffc0200f7c:	bf860613          	addi	a2,a2,-1032 # ffffffffc0204b70 <commands+0x738>
ffffffffc0200f80:	0f800593          	li	a1,248
ffffffffc0200f84:	00004517          	auipc	a0,0x4
ffffffffc0200f88:	c0450513          	addi	a0,a0,-1020 # ffffffffc0204b88 <commands+0x750>
ffffffffc0200f8c:	cb6ff0ef          	jal	ra,ffffffffc0200442 <__panic>
    assert(nr_free == 0);
ffffffffc0200f90:	00004697          	auipc	a3,0x4
ffffffffc0200f94:	db868693          	addi	a3,a3,-584 # ffffffffc0204d48 <commands+0x910>
ffffffffc0200f98:	00004617          	auipc	a2,0x4
ffffffffc0200f9c:	bd860613          	addi	a2,a2,-1064 # ffffffffc0204b70 <commands+0x738>
ffffffffc0200fa0:	0df00593          	li	a1,223
ffffffffc0200fa4:	00004517          	auipc	a0,0x4
ffffffffc0200fa8:	be450513          	addi	a0,a0,-1052 # ffffffffc0204b88 <commands+0x750>
ffffffffc0200fac:	c96ff0ef          	jal	ra,ffffffffc0200442 <__panic>
    assert(alloc_page() == NULL);
ffffffffc0200fb0:	00004697          	auipc	a3,0x4
ffffffffc0200fb4:	d3868693          	addi	a3,a3,-712 # ffffffffc0204ce8 <commands+0x8b0>
ffffffffc0200fb8:	00004617          	auipc	a2,0x4
ffffffffc0200fbc:	bb860613          	addi	a2,a2,-1096 # ffffffffc0204b70 <commands+0x738>
ffffffffc0200fc0:	0dd00593          	li	a1,221
ffffffffc0200fc4:	00004517          	auipc	a0,0x4
ffffffffc0200fc8:	bc450513          	addi	a0,a0,-1084 # ffffffffc0204b88 <commands+0x750>
ffffffffc0200fcc:	c76ff0ef          	jal	ra,ffffffffc0200442 <__panic>
    assert((p = alloc_page()) == p0);
ffffffffc0200fd0:	00004697          	auipc	a3,0x4
ffffffffc0200fd4:	d5868693          	addi	a3,a3,-680 # ffffffffc0204d28 <commands+0x8f0>
ffffffffc0200fd8:	00004617          	auipc	a2,0x4
ffffffffc0200fdc:	b9860613          	addi	a2,a2,-1128 # ffffffffc0204b70 <commands+0x738>
ffffffffc0200fe0:	0dc00593          	li	a1,220
ffffffffc0200fe4:	00004517          	auipc	a0,0x4
ffffffffc0200fe8:	ba450513          	addi	a0,a0,-1116 # ffffffffc0204b88 <commands+0x750>
ffffffffc0200fec:	c56ff0ef          	jal	ra,ffffffffc0200442 <__panic>
    assert((p0 = alloc_page()) != NULL);
ffffffffc0200ff0:	00004697          	auipc	a3,0x4
ffffffffc0200ff4:	bd068693          	addi	a3,a3,-1072 # ffffffffc0204bc0 <commands+0x788>
ffffffffc0200ff8:	00004617          	auipc	a2,0x4
ffffffffc0200ffc:	b7860613          	addi	a2,a2,-1160 # ffffffffc0204b70 <commands+0x738>
ffffffffc0201000:	0b900593          	li	a1,185
ffffffffc0201004:	00004517          	auipc	a0,0x4
ffffffffc0201008:	b8450513          	addi	a0,a0,-1148 # ffffffffc0204b88 <commands+0x750>
ffffffffc020100c:	c36ff0ef          	jal	ra,ffffffffc0200442 <__panic>
    assert(alloc_page() == NULL);
ffffffffc0201010:	00004697          	auipc	a3,0x4
ffffffffc0201014:	cd868693          	addi	a3,a3,-808 # ffffffffc0204ce8 <commands+0x8b0>
ffffffffc0201018:	00004617          	auipc	a2,0x4
ffffffffc020101c:	b5860613          	addi	a2,a2,-1192 # ffffffffc0204b70 <commands+0x738>
ffffffffc0201020:	0d600593          	li	a1,214
ffffffffc0201024:	00004517          	auipc	a0,0x4
ffffffffc0201028:	b6450513          	addi	a0,a0,-1180 # ffffffffc0204b88 <commands+0x750>
ffffffffc020102c:	c16ff0ef          	jal	ra,ffffffffc0200442 <__panic>
    assert((p2 = alloc_page()) != NULL);
ffffffffc0201030:	00004697          	auipc	a3,0x4
ffffffffc0201034:	bd068693          	addi	a3,a3,-1072 # ffffffffc0204c00 <commands+0x7c8>
ffffffffc0201038:	00004617          	auipc	a2,0x4
ffffffffc020103c:	b3860613          	addi	a2,a2,-1224 # ffffffffc0204b70 <commands+0x738>
ffffffffc0201040:	0d400593          	li	a1,212
ffffffffc0201044:	00004517          	auipc	a0,0x4
ffffffffc0201048:	b4450513          	addi	a0,a0,-1212 # ffffffffc0204b88 <commands+0x750>
ffffffffc020104c:	bf6ff0ef          	jal	ra,ffffffffc0200442 <__panic>
    assert((p1 = alloc_page()) != NULL);
ffffffffc0201050:	00004697          	auipc	a3,0x4
ffffffffc0201054:	b9068693          	addi	a3,a3,-1136 # ffffffffc0204be0 <commands+0x7a8>
ffffffffc0201058:	00004617          	auipc	a2,0x4
ffffffffc020105c:	b1860613          	addi	a2,a2,-1256 # ffffffffc0204b70 <commands+0x738>
ffffffffc0201060:	0d300593          	li	a1,211
ffffffffc0201064:	00004517          	auipc	a0,0x4
ffffffffc0201068:	b2450513          	addi	a0,a0,-1244 # ffffffffc0204b88 <commands+0x750>
ffffffffc020106c:	bd6ff0ef          	jal	ra,ffffffffc0200442 <__panic>
    assert((p2 = alloc_page()) != NULL);
ffffffffc0201070:	00004697          	auipc	a3,0x4
ffffffffc0201074:	b9068693          	addi	a3,a3,-1136 # ffffffffc0204c00 <commands+0x7c8>
ffffffffc0201078:	00004617          	auipc	a2,0x4
ffffffffc020107c:	af860613          	addi	a2,a2,-1288 # ffffffffc0204b70 <commands+0x738>
ffffffffc0201080:	0bb00593          	li	a1,187
ffffffffc0201084:	00004517          	auipc	a0,0x4
ffffffffc0201088:	b0450513          	addi	a0,a0,-1276 # ffffffffc0204b88 <commands+0x750>
ffffffffc020108c:	bb6ff0ef          	jal	ra,ffffffffc0200442 <__panic>
    assert(count == 0);
ffffffffc0201090:	00004697          	auipc	a3,0x4
ffffffffc0201094:	e1868693          	addi	a3,a3,-488 # ffffffffc0204ea8 <commands+0xa70>
ffffffffc0201098:	00004617          	auipc	a2,0x4
ffffffffc020109c:	ad860613          	addi	a2,a2,-1320 # ffffffffc0204b70 <commands+0x738>
ffffffffc02010a0:	12500593          	li	a1,293
ffffffffc02010a4:	00004517          	auipc	a0,0x4
ffffffffc02010a8:	ae450513          	addi	a0,a0,-1308 # ffffffffc0204b88 <commands+0x750>
ffffffffc02010ac:	b96ff0ef          	jal	ra,ffffffffc0200442 <__panic>
    assert(nr_free == 0);
ffffffffc02010b0:	00004697          	auipc	a3,0x4
ffffffffc02010b4:	c9868693          	addi	a3,a3,-872 # ffffffffc0204d48 <commands+0x910>
ffffffffc02010b8:	00004617          	auipc	a2,0x4
ffffffffc02010bc:	ab860613          	addi	a2,a2,-1352 # ffffffffc0204b70 <commands+0x738>
ffffffffc02010c0:	11a00593          	li	a1,282
ffffffffc02010c4:	00004517          	auipc	a0,0x4
ffffffffc02010c8:	ac450513          	addi	a0,a0,-1340 # ffffffffc0204b88 <commands+0x750>
ffffffffc02010cc:	b76ff0ef          	jal	ra,ffffffffc0200442 <__panic>
    assert(alloc_page() == NULL);
ffffffffc02010d0:	00004697          	auipc	a3,0x4
ffffffffc02010d4:	c1868693          	addi	a3,a3,-1000 # ffffffffc0204ce8 <commands+0x8b0>
ffffffffc02010d8:	00004617          	auipc	a2,0x4
ffffffffc02010dc:	a9860613          	addi	a2,a2,-1384 # ffffffffc0204b70 <commands+0x738>
ffffffffc02010e0:	11800593          	li	a1,280
ffffffffc02010e4:	00004517          	auipc	a0,0x4
ffffffffc02010e8:	aa450513          	addi	a0,a0,-1372 # ffffffffc0204b88 <commands+0x750>
ffffffffc02010ec:	b56ff0ef          	jal	ra,ffffffffc0200442 <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
ffffffffc02010f0:	00004697          	auipc	a3,0x4
ffffffffc02010f4:	bb868693          	addi	a3,a3,-1096 # ffffffffc0204ca8 <commands+0x870>
ffffffffc02010f8:	00004617          	auipc	a2,0x4
ffffffffc02010fc:	a7860613          	addi	a2,a2,-1416 # ffffffffc0204b70 <commands+0x738>
ffffffffc0201100:	0c100593          	li	a1,193
ffffffffc0201104:	00004517          	auipc	a0,0x4
ffffffffc0201108:	a8450513          	addi	a0,a0,-1404 # ffffffffc0204b88 <commands+0x750>
ffffffffc020110c:	b36ff0ef          	jal	ra,ffffffffc0200442 <__panic>
    assert((p0 = alloc_pages(2)) == p2 + 1);
ffffffffc0201110:	00004697          	auipc	a3,0x4
ffffffffc0201114:	d5868693          	addi	a3,a3,-680 # ffffffffc0204e68 <commands+0xa30>
ffffffffc0201118:	00004617          	auipc	a2,0x4
ffffffffc020111c:	a5860613          	addi	a2,a2,-1448 # ffffffffc0204b70 <commands+0x738>
ffffffffc0201120:	11200593          	li	a1,274
ffffffffc0201124:	00004517          	auipc	a0,0x4
ffffffffc0201128:	a6450513          	addi	a0,a0,-1436 # ffffffffc0204b88 <commands+0x750>
ffffffffc020112c:	b16ff0ef          	jal	ra,ffffffffc0200442 <__panic>
    assert((p0 = alloc_page()) == p2 - 1);
ffffffffc0201130:	00004697          	auipc	a3,0x4
ffffffffc0201134:	d1868693          	addi	a3,a3,-744 # ffffffffc0204e48 <commands+0xa10>
ffffffffc0201138:	00004617          	auipc	a2,0x4
ffffffffc020113c:	a3860613          	addi	a2,a2,-1480 # ffffffffc0204b70 <commands+0x738>
ffffffffc0201140:	11000593          	li	a1,272
ffffffffc0201144:	00004517          	auipc	a0,0x4
ffffffffc0201148:	a4450513          	addi	a0,a0,-1468 # ffffffffc0204b88 <commands+0x750>
ffffffffc020114c:	af6ff0ef          	jal	ra,ffffffffc0200442 <__panic>
    assert(PageProperty(p1) && p1->property == 3);
ffffffffc0201150:	00004697          	auipc	a3,0x4
ffffffffc0201154:	cd068693          	addi	a3,a3,-816 # ffffffffc0204e20 <commands+0x9e8>
ffffffffc0201158:	00004617          	auipc	a2,0x4
ffffffffc020115c:	a1860613          	addi	a2,a2,-1512 # ffffffffc0204b70 <commands+0x738>
ffffffffc0201160:	10e00593          	li	a1,270
ffffffffc0201164:	00004517          	auipc	a0,0x4
ffffffffc0201168:	a2450513          	addi	a0,a0,-1500 # ffffffffc0204b88 <commands+0x750>
ffffffffc020116c:	ad6ff0ef          	jal	ra,ffffffffc0200442 <__panic>
    assert(PageProperty(p0) && p0->property == 1);
ffffffffc0201170:	00004697          	auipc	a3,0x4
ffffffffc0201174:	c8868693          	addi	a3,a3,-888 # ffffffffc0204df8 <commands+0x9c0>
ffffffffc0201178:	00004617          	auipc	a2,0x4
ffffffffc020117c:	9f860613          	addi	a2,a2,-1544 # ffffffffc0204b70 <commands+0x738>
ffffffffc0201180:	10d00593          	li	a1,269
ffffffffc0201184:	00004517          	auipc	a0,0x4
ffffffffc0201188:	a0450513          	addi	a0,a0,-1532 # ffffffffc0204b88 <commands+0x750>
ffffffffc020118c:	ab6ff0ef          	jal	ra,ffffffffc0200442 <__panic>
    assert(p0 + 2 == p1);
ffffffffc0201190:	00004697          	auipc	a3,0x4
ffffffffc0201194:	c5868693          	addi	a3,a3,-936 # ffffffffc0204de8 <commands+0x9b0>
ffffffffc0201198:	00004617          	auipc	a2,0x4
ffffffffc020119c:	9d860613          	addi	a2,a2,-1576 # ffffffffc0204b70 <commands+0x738>
ffffffffc02011a0:	10800593          	li	a1,264
ffffffffc02011a4:	00004517          	auipc	a0,0x4
ffffffffc02011a8:	9e450513          	addi	a0,a0,-1564 # ffffffffc0204b88 <commands+0x750>
ffffffffc02011ac:	a96ff0ef          	jal	ra,ffffffffc0200442 <__panic>
    assert(alloc_page() == NULL);
ffffffffc02011b0:	00004697          	auipc	a3,0x4
ffffffffc02011b4:	b3868693          	addi	a3,a3,-1224 # ffffffffc0204ce8 <commands+0x8b0>
ffffffffc02011b8:	00004617          	auipc	a2,0x4
ffffffffc02011bc:	9b860613          	addi	a2,a2,-1608 # ffffffffc0204b70 <commands+0x738>
ffffffffc02011c0:	10700593          	li	a1,263
ffffffffc02011c4:	00004517          	auipc	a0,0x4
ffffffffc02011c8:	9c450513          	addi	a0,a0,-1596 # ffffffffc0204b88 <commands+0x750>
ffffffffc02011cc:	a76ff0ef          	jal	ra,ffffffffc0200442 <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
ffffffffc02011d0:	00004697          	auipc	a3,0x4
ffffffffc02011d4:	bf868693          	addi	a3,a3,-1032 # ffffffffc0204dc8 <commands+0x990>
ffffffffc02011d8:	00004617          	auipc	a2,0x4
ffffffffc02011dc:	99860613          	addi	a2,a2,-1640 # ffffffffc0204b70 <commands+0x738>
ffffffffc02011e0:	10600593          	li	a1,262
ffffffffc02011e4:	00004517          	auipc	a0,0x4
ffffffffc02011e8:	9a450513          	addi	a0,a0,-1628 # ffffffffc0204b88 <commands+0x750>
ffffffffc02011ec:	a56ff0ef          	jal	ra,ffffffffc0200442 <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
ffffffffc02011f0:	00004697          	auipc	a3,0x4
ffffffffc02011f4:	ba868693          	addi	a3,a3,-1112 # ffffffffc0204d98 <commands+0x960>
ffffffffc02011f8:	00004617          	auipc	a2,0x4
ffffffffc02011fc:	97860613          	addi	a2,a2,-1672 # ffffffffc0204b70 <commands+0x738>
ffffffffc0201200:	10500593          	li	a1,261
ffffffffc0201204:	00004517          	auipc	a0,0x4
ffffffffc0201208:	98450513          	addi	a0,a0,-1660 # ffffffffc0204b88 <commands+0x750>
ffffffffc020120c:	a36ff0ef          	jal	ra,ffffffffc0200442 <__panic>
    assert(alloc_pages(4) == NULL);
ffffffffc0201210:	00004697          	auipc	a3,0x4
ffffffffc0201214:	b7068693          	addi	a3,a3,-1168 # ffffffffc0204d80 <commands+0x948>
ffffffffc0201218:	00004617          	auipc	a2,0x4
ffffffffc020121c:	95860613          	addi	a2,a2,-1704 # ffffffffc0204b70 <commands+0x738>
ffffffffc0201220:	10400593          	li	a1,260
ffffffffc0201224:	00004517          	auipc	a0,0x4
ffffffffc0201228:	96450513          	addi	a0,a0,-1692 # ffffffffc0204b88 <commands+0x750>
ffffffffc020122c:	a16ff0ef          	jal	ra,ffffffffc0200442 <__panic>
    assert(alloc_page() == NULL);
ffffffffc0201230:	00004697          	auipc	a3,0x4
ffffffffc0201234:	ab868693          	addi	a3,a3,-1352 # ffffffffc0204ce8 <commands+0x8b0>
ffffffffc0201238:	00004617          	auipc	a2,0x4
ffffffffc020123c:	93860613          	addi	a2,a2,-1736 # ffffffffc0204b70 <commands+0x738>
ffffffffc0201240:	0fe00593          	li	a1,254
ffffffffc0201244:	00004517          	auipc	a0,0x4
ffffffffc0201248:	94450513          	addi	a0,a0,-1724 # ffffffffc0204b88 <commands+0x750>
ffffffffc020124c:	9f6ff0ef          	jal	ra,ffffffffc0200442 <__panic>
    assert(!PageProperty(p0));
ffffffffc0201250:	00004697          	auipc	a3,0x4
ffffffffc0201254:	b1868693          	addi	a3,a3,-1256 # ffffffffc0204d68 <commands+0x930>
ffffffffc0201258:	00004617          	auipc	a2,0x4
ffffffffc020125c:	91860613          	addi	a2,a2,-1768 # ffffffffc0204b70 <commands+0x738>
ffffffffc0201260:	0f900593          	li	a1,249
ffffffffc0201264:	00004517          	auipc	a0,0x4
ffffffffc0201268:	92450513          	addi	a0,a0,-1756 # ffffffffc0204b88 <commands+0x750>
ffffffffc020126c:	9d6ff0ef          	jal	ra,ffffffffc0200442 <__panic>
    assert((p0 = alloc_pages(5)) != NULL);
ffffffffc0201270:	00004697          	auipc	a3,0x4
ffffffffc0201274:	c1868693          	addi	a3,a3,-1000 # ffffffffc0204e88 <commands+0xa50>
ffffffffc0201278:	00004617          	auipc	a2,0x4
ffffffffc020127c:	8f860613          	addi	a2,a2,-1800 # ffffffffc0204b70 <commands+0x738>
ffffffffc0201280:	11700593          	li	a1,279
ffffffffc0201284:	00004517          	auipc	a0,0x4
ffffffffc0201288:	90450513          	addi	a0,a0,-1788 # ffffffffc0204b88 <commands+0x750>
ffffffffc020128c:	9b6ff0ef          	jal	ra,ffffffffc0200442 <__panic>
    assert(total == 0);
ffffffffc0201290:	00004697          	auipc	a3,0x4
ffffffffc0201294:	c2868693          	addi	a3,a3,-984 # ffffffffc0204eb8 <commands+0xa80>
ffffffffc0201298:	00004617          	auipc	a2,0x4
ffffffffc020129c:	8d860613          	addi	a2,a2,-1832 # ffffffffc0204b70 <commands+0x738>
ffffffffc02012a0:	12600593          	li	a1,294
ffffffffc02012a4:	00004517          	auipc	a0,0x4
ffffffffc02012a8:	8e450513          	addi	a0,a0,-1820 # ffffffffc0204b88 <commands+0x750>
ffffffffc02012ac:	996ff0ef          	jal	ra,ffffffffc0200442 <__panic>
    assert(total == nr_free_pages());
ffffffffc02012b0:	00004697          	auipc	a3,0x4
ffffffffc02012b4:	8f068693          	addi	a3,a3,-1808 # ffffffffc0204ba0 <commands+0x768>
ffffffffc02012b8:	00004617          	auipc	a2,0x4
ffffffffc02012bc:	8b860613          	addi	a2,a2,-1864 # ffffffffc0204b70 <commands+0x738>
ffffffffc02012c0:	0f300593          	li	a1,243
ffffffffc02012c4:	00004517          	auipc	a0,0x4
ffffffffc02012c8:	8c450513          	addi	a0,a0,-1852 # ffffffffc0204b88 <commands+0x750>
ffffffffc02012cc:	976ff0ef          	jal	ra,ffffffffc0200442 <__panic>
    assert((p1 = alloc_page()) != NULL);
ffffffffc02012d0:	00004697          	auipc	a3,0x4
ffffffffc02012d4:	91068693          	addi	a3,a3,-1776 # ffffffffc0204be0 <commands+0x7a8>
ffffffffc02012d8:	00004617          	auipc	a2,0x4
ffffffffc02012dc:	89860613          	addi	a2,a2,-1896 # ffffffffc0204b70 <commands+0x738>
ffffffffc02012e0:	0ba00593          	li	a1,186
ffffffffc02012e4:	00004517          	auipc	a0,0x4
ffffffffc02012e8:	8a450513          	addi	a0,a0,-1884 # ffffffffc0204b88 <commands+0x750>
ffffffffc02012ec:	956ff0ef          	jal	ra,ffffffffc0200442 <__panic>

ffffffffc02012f0 <default_free_pages>:
default_free_pages(struct Page *base, size_t n) {
ffffffffc02012f0:	1141                	addi	sp,sp,-16
ffffffffc02012f2:	e406                	sd	ra,8(sp)
    assert(n > 0);
ffffffffc02012f4:	14058a63          	beqz	a1,ffffffffc0201448 <default_free_pages+0x158>
    for (; p != base + n; p ++) {
ffffffffc02012f8:	00359693          	slli	a3,a1,0x3
ffffffffc02012fc:	96ae                	add	a3,a3,a1
ffffffffc02012fe:	068e                	slli	a3,a3,0x3
ffffffffc0201300:	96aa                	add	a3,a3,a0
ffffffffc0201302:	87aa                	mv	a5,a0
ffffffffc0201304:	02d50263          	beq	a0,a3,ffffffffc0201328 <default_free_pages+0x38>
ffffffffc0201308:	6798                	ld	a4,8(a5)
        assert(!PageReserved(p) && !PageProperty(p));
ffffffffc020130a:	8b05                	andi	a4,a4,1
ffffffffc020130c:	10071e63          	bnez	a4,ffffffffc0201428 <default_free_pages+0x138>
ffffffffc0201310:	6798                	ld	a4,8(a5)
ffffffffc0201312:	8b09                	andi	a4,a4,2
ffffffffc0201314:	10071a63          	bnez	a4,ffffffffc0201428 <default_free_pages+0x138>
        p->flags = 0;
ffffffffc0201318:	0007b423          	sd	zero,8(a5)
    return page->ref;
}

static inline void
set_page_ref(struct Page *page, int val) {
    page->ref = val;
ffffffffc020131c:	0007a023          	sw	zero,0(a5)
    for (; p != base + n; p ++) {
ffffffffc0201320:	04878793          	addi	a5,a5,72
ffffffffc0201324:	fed792e3          	bne	a5,a3,ffffffffc0201308 <default_free_pages+0x18>
    base->property = n;
ffffffffc0201328:	2581                	sext.w	a1,a1
ffffffffc020132a:	cd0c                	sw	a1,24(a0)
    SetPageProperty(base);
ffffffffc020132c:	00850893          	addi	a7,a0,8
    __op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc0201330:	4789                	li	a5,2
ffffffffc0201332:	40f8b02f          	amoor.d	zero,a5,(a7)
    nr_free += n;
ffffffffc0201336:	00010697          	auipc	a3,0x10
ffffffffc020133a:	0ea68693          	addi	a3,a3,234 # ffffffffc0211420 <free_area>
ffffffffc020133e:	4a98                	lw	a4,16(a3)
    return list->next == list;
ffffffffc0201340:	669c                	ld	a5,8(a3)
        list_add(&free_list, &(base->page_link));
ffffffffc0201342:	02050613          	addi	a2,a0,32
    nr_free += n;
ffffffffc0201346:	9db9                	addw	a1,a1,a4
ffffffffc0201348:	ca8c                	sw	a1,16(a3)
    if (list_empty(&free_list)) {
ffffffffc020134a:	0ad78863          	beq	a5,a3,ffffffffc02013fa <default_free_pages+0x10a>
            struct Page* page = le2page(le, page_link);
ffffffffc020134e:	fe078713          	addi	a4,a5,-32
ffffffffc0201352:	0006b803          	ld	a6,0(a3)
    if (list_empty(&free_list)) {
ffffffffc0201356:	4581                	li	a1,0
            if (base < page) {
ffffffffc0201358:	00e56a63          	bltu	a0,a4,ffffffffc020136c <default_free_pages+0x7c>
    return listelm->next;
ffffffffc020135c:	6798                	ld	a4,8(a5)
            } else if (list_next(le) == &free_list) {
ffffffffc020135e:	06d70263          	beq	a4,a3,ffffffffc02013c2 <default_free_pages+0xd2>
    for (; p != base + n; p ++) {
ffffffffc0201362:	87ba                	mv	a5,a4
            struct Page* page = le2page(le, page_link);
ffffffffc0201364:	fe078713          	addi	a4,a5,-32
            if (base < page) {
ffffffffc0201368:	fee57ae3          	bgeu	a0,a4,ffffffffc020135c <default_free_pages+0x6c>
ffffffffc020136c:	c199                	beqz	a1,ffffffffc0201372 <default_free_pages+0x82>
ffffffffc020136e:	0106b023          	sd	a6,0(a3)
    __list_add(elm, listelm->prev, listelm);
ffffffffc0201372:	6398                	ld	a4,0(a5)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
ffffffffc0201374:	e390                	sd	a2,0(a5)
ffffffffc0201376:	e710                	sd	a2,8(a4)
    elm->next = next;
ffffffffc0201378:	f51c                	sd	a5,40(a0)
    elm->prev = prev;
ffffffffc020137a:	f118                	sd	a4,32(a0)
    if (le != &free_list) {
ffffffffc020137c:	02d70063          	beq	a4,a3,ffffffffc020139c <default_free_pages+0xac>
        if (p + p->property == base) {
ffffffffc0201380:	ff872803          	lw	a6,-8(a4)
        p = le2page(le, page_link);
ffffffffc0201384:	fe070593          	addi	a1,a4,-32
        if (p + p->property == base) {
ffffffffc0201388:	02081613          	slli	a2,a6,0x20
ffffffffc020138c:	9201                	srli	a2,a2,0x20
ffffffffc020138e:	00361793          	slli	a5,a2,0x3
ffffffffc0201392:	97b2                	add	a5,a5,a2
ffffffffc0201394:	078e                	slli	a5,a5,0x3
ffffffffc0201396:	97ae                	add	a5,a5,a1
ffffffffc0201398:	02f50f63          	beq	a0,a5,ffffffffc02013d6 <default_free_pages+0xe6>
    return listelm->next;
ffffffffc020139c:	7518                	ld	a4,40(a0)
    if (le != &free_list) {
ffffffffc020139e:	00d70f63          	beq	a4,a3,ffffffffc02013bc <default_free_pages+0xcc>
        if (base + base->property == p) {
ffffffffc02013a2:	4d0c                	lw	a1,24(a0)
        p = le2page(le, page_link);
ffffffffc02013a4:	fe070693          	addi	a3,a4,-32
        if (base + base->property == p) {
ffffffffc02013a8:	02059613          	slli	a2,a1,0x20
ffffffffc02013ac:	9201                	srli	a2,a2,0x20
ffffffffc02013ae:	00361793          	slli	a5,a2,0x3
ffffffffc02013b2:	97b2                	add	a5,a5,a2
ffffffffc02013b4:	078e                	slli	a5,a5,0x3
ffffffffc02013b6:	97aa                	add	a5,a5,a0
ffffffffc02013b8:	04f68863          	beq	a3,a5,ffffffffc0201408 <default_free_pages+0x118>
}
ffffffffc02013bc:	60a2                	ld	ra,8(sp)
ffffffffc02013be:	0141                	addi	sp,sp,16
ffffffffc02013c0:	8082                	ret
    prev->next = next->prev = elm;
ffffffffc02013c2:	e790                	sd	a2,8(a5)
    elm->next = next;
ffffffffc02013c4:	f514                	sd	a3,40(a0)
    return listelm->next;
ffffffffc02013c6:	6798                	ld	a4,8(a5)
    elm->prev = prev;
ffffffffc02013c8:	f11c                	sd	a5,32(a0)
        while ((le = list_next(le)) != &free_list) {
ffffffffc02013ca:	02d70563          	beq	a4,a3,ffffffffc02013f4 <default_free_pages+0x104>
    prev->next = next->prev = elm;
ffffffffc02013ce:	8832                	mv	a6,a2
ffffffffc02013d0:	4585                	li	a1,1
    for (; p != base + n; p ++) {
ffffffffc02013d2:	87ba                	mv	a5,a4
ffffffffc02013d4:	bf41                	j	ffffffffc0201364 <default_free_pages+0x74>
            p->property += base->property;
ffffffffc02013d6:	4d1c                	lw	a5,24(a0)
ffffffffc02013d8:	0107883b          	addw	a6,a5,a6
ffffffffc02013dc:	ff072c23          	sw	a6,-8(a4)
    __op_bit(and, __NOT, nr, ((volatile unsigned long *)addr));
ffffffffc02013e0:	57f5                	li	a5,-3
ffffffffc02013e2:	60f8b02f          	amoand.d	zero,a5,(a7)
    __list_del(listelm->prev, listelm->next);
ffffffffc02013e6:	7110                	ld	a2,32(a0)
ffffffffc02013e8:	751c                	ld	a5,40(a0)
            base = p;
ffffffffc02013ea:	852e                	mv	a0,a1
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
ffffffffc02013ec:	e61c                	sd	a5,8(a2)
    return listelm->next;
ffffffffc02013ee:	6718                	ld	a4,8(a4)
    next->prev = prev;
ffffffffc02013f0:	e390                	sd	a2,0(a5)
ffffffffc02013f2:	b775                	j	ffffffffc020139e <default_free_pages+0xae>
ffffffffc02013f4:	e290                	sd	a2,0(a3)
        while ((le = list_next(le)) != &free_list) {
ffffffffc02013f6:	873e                	mv	a4,a5
ffffffffc02013f8:	b761                	j	ffffffffc0201380 <default_free_pages+0x90>
}
ffffffffc02013fa:	60a2                	ld	ra,8(sp)
    prev->next = next->prev = elm;
ffffffffc02013fc:	e390                	sd	a2,0(a5)
ffffffffc02013fe:	e790                	sd	a2,8(a5)
    elm->next = next;
ffffffffc0201400:	f51c                	sd	a5,40(a0)
    elm->prev = prev;
ffffffffc0201402:	f11c                	sd	a5,32(a0)
ffffffffc0201404:	0141                	addi	sp,sp,16
ffffffffc0201406:	8082                	ret
            base->property += p->property;
ffffffffc0201408:	ff872783          	lw	a5,-8(a4)
ffffffffc020140c:	fe870693          	addi	a3,a4,-24
ffffffffc0201410:	9dbd                	addw	a1,a1,a5
ffffffffc0201412:	cd0c                	sw	a1,24(a0)
ffffffffc0201414:	57f5                	li	a5,-3
ffffffffc0201416:	60f6b02f          	amoand.d	zero,a5,(a3)
    __list_del(listelm->prev, listelm->next);
ffffffffc020141a:	6314                	ld	a3,0(a4)
ffffffffc020141c:	671c                	ld	a5,8(a4)
}
ffffffffc020141e:	60a2                	ld	ra,8(sp)
    prev->next = next;
ffffffffc0201420:	e69c                	sd	a5,8(a3)
    next->prev = prev;
ffffffffc0201422:	e394                	sd	a3,0(a5)
ffffffffc0201424:	0141                	addi	sp,sp,16
ffffffffc0201426:	8082                	ret
        assert(!PageReserved(p) && !PageProperty(p));
ffffffffc0201428:	00004697          	auipc	a3,0x4
ffffffffc020142c:	aa868693          	addi	a3,a3,-1368 # ffffffffc0204ed0 <commands+0xa98>
ffffffffc0201430:	00003617          	auipc	a2,0x3
ffffffffc0201434:	74060613          	addi	a2,a2,1856 # ffffffffc0204b70 <commands+0x738>
ffffffffc0201438:	08300593          	li	a1,131
ffffffffc020143c:	00003517          	auipc	a0,0x3
ffffffffc0201440:	74c50513          	addi	a0,a0,1868 # ffffffffc0204b88 <commands+0x750>
ffffffffc0201444:	ffffe0ef          	jal	ra,ffffffffc0200442 <__panic>
    assert(n > 0);
ffffffffc0201448:	00004697          	auipc	a3,0x4
ffffffffc020144c:	a8068693          	addi	a3,a3,-1408 # ffffffffc0204ec8 <commands+0xa90>
ffffffffc0201450:	00003617          	auipc	a2,0x3
ffffffffc0201454:	72060613          	addi	a2,a2,1824 # ffffffffc0204b70 <commands+0x738>
ffffffffc0201458:	08000593          	li	a1,128
ffffffffc020145c:	00003517          	auipc	a0,0x3
ffffffffc0201460:	72c50513          	addi	a0,a0,1836 # ffffffffc0204b88 <commands+0x750>
ffffffffc0201464:	fdffe0ef          	jal	ra,ffffffffc0200442 <__panic>

ffffffffc0201468 <default_alloc_pages>:
    assert(n > 0);
ffffffffc0201468:	c959                	beqz	a0,ffffffffc02014fe <default_alloc_pages+0x96>
    if (n > nr_free) {
ffffffffc020146a:	00010597          	auipc	a1,0x10
ffffffffc020146e:	fb658593          	addi	a1,a1,-74 # ffffffffc0211420 <free_area>
ffffffffc0201472:	0105a803          	lw	a6,16(a1)
ffffffffc0201476:	862a                	mv	a2,a0
ffffffffc0201478:	02081793          	slli	a5,a6,0x20
ffffffffc020147c:	9381                	srli	a5,a5,0x20
ffffffffc020147e:	00a7ee63          	bltu	a5,a0,ffffffffc020149a <default_alloc_pages+0x32>
    list_entry_t *le = &free_list;
ffffffffc0201482:	87ae                	mv	a5,a1
ffffffffc0201484:	a801                	j	ffffffffc0201494 <default_alloc_pages+0x2c>
        if (p->property >= n) {
ffffffffc0201486:	ff87a703          	lw	a4,-8(a5)
ffffffffc020148a:	02071693          	slli	a3,a4,0x20
ffffffffc020148e:	9281                	srli	a3,a3,0x20
ffffffffc0201490:	00c6f763          	bgeu	a3,a2,ffffffffc020149e <default_alloc_pages+0x36>
    return listelm->next;
ffffffffc0201494:	679c                	ld	a5,8(a5)
    while ((le = list_next(le)) != &free_list) {
ffffffffc0201496:	feb798e3          	bne	a5,a1,ffffffffc0201486 <default_alloc_pages+0x1e>
        return NULL;
ffffffffc020149a:	4501                	li	a0,0
}
ffffffffc020149c:	8082                	ret
    return listelm->prev;
ffffffffc020149e:	0007b883          	ld	a7,0(a5)
    __list_del(listelm->prev, listelm->next);
ffffffffc02014a2:	0087b303          	ld	t1,8(a5)
        struct Page *p = le2page(le, page_link);
ffffffffc02014a6:	fe078513          	addi	a0,a5,-32
            p->property = page->property - n;
ffffffffc02014aa:	00060e1b          	sext.w	t3,a2
    prev->next = next;
ffffffffc02014ae:	0068b423          	sd	t1,8(a7)
    next->prev = prev;
ffffffffc02014b2:	01133023          	sd	a7,0(t1)
        if (page->property > n) {
ffffffffc02014b6:	02d67b63          	bgeu	a2,a3,ffffffffc02014ec <default_alloc_pages+0x84>
            struct Page *p = page + n;
ffffffffc02014ba:	00361693          	slli	a3,a2,0x3
ffffffffc02014be:	96b2                	add	a3,a3,a2
ffffffffc02014c0:	068e                	slli	a3,a3,0x3
ffffffffc02014c2:	96aa                	add	a3,a3,a0
            p->property = page->property - n;
ffffffffc02014c4:	41c7073b          	subw	a4,a4,t3
ffffffffc02014c8:	ce98                	sw	a4,24(a3)
    __op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc02014ca:	00868613          	addi	a2,a3,8
ffffffffc02014ce:	4709                	li	a4,2
ffffffffc02014d0:	40e6302f          	amoor.d	zero,a4,(a2)
    __list_add(elm, listelm, listelm->next);
ffffffffc02014d4:	0088b703          	ld	a4,8(a7)
            list_add(prev, &(p->page_link));
ffffffffc02014d8:	02068613          	addi	a2,a3,32
        nr_free -= n;
ffffffffc02014dc:	0105a803          	lw	a6,16(a1)
    prev->next = next->prev = elm;
ffffffffc02014e0:	e310                	sd	a2,0(a4)
ffffffffc02014e2:	00c8b423          	sd	a2,8(a7)
    elm->next = next;
ffffffffc02014e6:	f698                	sd	a4,40(a3)
    elm->prev = prev;
ffffffffc02014e8:	0316b023          	sd	a7,32(a3)
ffffffffc02014ec:	41c8083b          	subw	a6,a6,t3
ffffffffc02014f0:	0105a823          	sw	a6,16(a1)
    __op_bit(and, __NOT, nr, ((volatile unsigned long *)addr));
ffffffffc02014f4:	5775                	li	a4,-3
ffffffffc02014f6:	17a1                	addi	a5,a5,-24
ffffffffc02014f8:	60e7b02f          	amoand.d	zero,a4,(a5)
}
ffffffffc02014fc:	8082                	ret
default_alloc_pages(size_t n) {
ffffffffc02014fe:	1141                	addi	sp,sp,-16
    assert(n > 0);
ffffffffc0201500:	00004697          	auipc	a3,0x4
ffffffffc0201504:	9c868693          	addi	a3,a3,-1592 # ffffffffc0204ec8 <commands+0xa90>
ffffffffc0201508:	00003617          	auipc	a2,0x3
ffffffffc020150c:	66860613          	addi	a2,a2,1640 # ffffffffc0204b70 <commands+0x738>
ffffffffc0201510:	06200593          	li	a1,98
ffffffffc0201514:	00003517          	auipc	a0,0x3
ffffffffc0201518:	67450513          	addi	a0,a0,1652 # ffffffffc0204b88 <commands+0x750>
default_alloc_pages(size_t n) {
ffffffffc020151c:	e406                	sd	ra,8(sp)
    assert(n > 0);
ffffffffc020151e:	f25fe0ef          	jal	ra,ffffffffc0200442 <__panic>

ffffffffc0201522 <default_init_memmap>:
default_init_memmap(struct Page *base, size_t n) {
ffffffffc0201522:	1141                	addi	sp,sp,-16
ffffffffc0201524:	e406                	sd	ra,8(sp)
    assert(n > 0);
ffffffffc0201526:	c9e1                	beqz	a1,ffffffffc02015f6 <default_init_memmap+0xd4>
    for (; p != base + n; p ++) {
ffffffffc0201528:	00359693          	slli	a3,a1,0x3
ffffffffc020152c:	96ae                	add	a3,a3,a1
ffffffffc020152e:	068e                	slli	a3,a3,0x3
ffffffffc0201530:	96aa                	add	a3,a3,a0
ffffffffc0201532:	87aa                	mv	a5,a0
ffffffffc0201534:	00d50f63          	beq	a0,a3,ffffffffc0201552 <default_init_memmap+0x30>
    return (((*(volatile unsigned long *)addr) >> nr) & 1);
ffffffffc0201538:	6798                	ld	a4,8(a5)
        assert(PageReserved(p));
ffffffffc020153a:	8b05                	andi	a4,a4,1
ffffffffc020153c:	cf49                	beqz	a4,ffffffffc02015d6 <default_init_memmap+0xb4>
        p->flags = p->property = 0;
ffffffffc020153e:	0007ac23          	sw	zero,24(a5)
ffffffffc0201542:	0007b423          	sd	zero,8(a5)
ffffffffc0201546:	0007a023          	sw	zero,0(a5)
    for (; p != base + n; p ++) {
ffffffffc020154a:	04878793          	addi	a5,a5,72
ffffffffc020154e:	fed795e3          	bne	a5,a3,ffffffffc0201538 <default_init_memmap+0x16>
    base->property = n;
ffffffffc0201552:	2581                	sext.w	a1,a1
ffffffffc0201554:	cd0c                	sw	a1,24(a0)
    __op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc0201556:	4789                	li	a5,2
ffffffffc0201558:	00850713          	addi	a4,a0,8
ffffffffc020155c:	40f7302f          	amoor.d	zero,a5,(a4)
    nr_free += n;
ffffffffc0201560:	00010697          	auipc	a3,0x10
ffffffffc0201564:	ec068693          	addi	a3,a3,-320 # ffffffffc0211420 <free_area>
ffffffffc0201568:	4a98                	lw	a4,16(a3)
    return list->next == list;
ffffffffc020156a:	669c                	ld	a5,8(a3)
        list_add(&free_list, &(base->page_link));
ffffffffc020156c:	02050613          	addi	a2,a0,32
    nr_free += n;
ffffffffc0201570:	9db9                	addw	a1,a1,a4
ffffffffc0201572:	ca8c                	sw	a1,16(a3)
    if (list_empty(&free_list)) {
ffffffffc0201574:	04d78a63          	beq	a5,a3,ffffffffc02015c8 <default_init_memmap+0xa6>
            struct Page* page = le2page(le, page_link);
ffffffffc0201578:	fe078713          	addi	a4,a5,-32
ffffffffc020157c:	0006b803          	ld	a6,0(a3)
    if (list_empty(&free_list)) {
ffffffffc0201580:	4581                	li	a1,0
            if (base < page) {
ffffffffc0201582:	00e56a63          	bltu	a0,a4,ffffffffc0201596 <default_init_memmap+0x74>
    return listelm->next;
ffffffffc0201586:	6798                	ld	a4,8(a5)
            } else if (list_next(le) == &free_list) {
ffffffffc0201588:	02d70263          	beq	a4,a3,ffffffffc02015ac <default_init_memmap+0x8a>
    for (; p != base + n; p ++) {
ffffffffc020158c:	87ba                	mv	a5,a4
            struct Page* page = le2page(le, page_link);
ffffffffc020158e:	fe078713          	addi	a4,a5,-32
            if (base < page) {
ffffffffc0201592:	fee57ae3          	bgeu	a0,a4,ffffffffc0201586 <default_init_memmap+0x64>
ffffffffc0201596:	c199                	beqz	a1,ffffffffc020159c <default_init_memmap+0x7a>
ffffffffc0201598:	0106b023          	sd	a6,0(a3)
    __list_add(elm, listelm->prev, listelm);
ffffffffc020159c:	6398                	ld	a4,0(a5)
}
ffffffffc020159e:	60a2                	ld	ra,8(sp)
    prev->next = next->prev = elm;
ffffffffc02015a0:	e390                	sd	a2,0(a5)
ffffffffc02015a2:	e710                	sd	a2,8(a4)
    elm->next = next;
ffffffffc02015a4:	f51c                	sd	a5,40(a0)
    elm->prev = prev;
ffffffffc02015a6:	f118                	sd	a4,32(a0)
ffffffffc02015a8:	0141                	addi	sp,sp,16
ffffffffc02015aa:	8082                	ret
    prev->next = next->prev = elm;
ffffffffc02015ac:	e790                	sd	a2,8(a5)
    elm->next = next;
ffffffffc02015ae:	f514                	sd	a3,40(a0)
    return listelm->next;
ffffffffc02015b0:	6798                	ld	a4,8(a5)
    elm->prev = prev;
ffffffffc02015b2:	f11c                	sd	a5,32(a0)
        while ((le = list_next(le)) != &free_list) {
ffffffffc02015b4:	00d70663          	beq	a4,a3,ffffffffc02015c0 <default_init_memmap+0x9e>
    prev->next = next->prev = elm;
ffffffffc02015b8:	8832                	mv	a6,a2
ffffffffc02015ba:	4585                	li	a1,1
    for (; p != base + n; p ++) {
ffffffffc02015bc:	87ba                	mv	a5,a4
ffffffffc02015be:	bfc1                	j	ffffffffc020158e <default_init_memmap+0x6c>
}
ffffffffc02015c0:	60a2                	ld	ra,8(sp)
ffffffffc02015c2:	e290                	sd	a2,0(a3)
ffffffffc02015c4:	0141                	addi	sp,sp,16
ffffffffc02015c6:	8082                	ret
ffffffffc02015c8:	60a2                	ld	ra,8(sp)
ffffffffc02015ca:	e390                	sd	a2,0(a5)
ffffffffc02015cc:	e790                	sd	a2,8(a5)
    elm->next = next;
ffffffffc02015ce:	f51c                	sd	a5,40(a0)
    elm->prev = prev;
ffffffffc02015d0:	f11c                	sd	a5,32(a0)
ffffffffc02015d2:	0141                	addi	sp,sp,16
ffffffffc02015d4:	8082                	ret
        assert(PageReserved(p));
ffffffffc02015d6:	00004697          	auipc	a3,0x4
ffffffffc02015da:	92268693          	addi	a3,a3,-1758 # ffffffffc0204ef8 <commands+0xac0>
ffffffffc02015de:	00003617          	auipc	a2,0x3
ffffffffc02015e2:	59260613          	addi	a2,a2,1426 # ffffffffc0204b70 <commands+0x738>
ffffffffc02015e6:	04900593          	li	a1,73
ffffffffc02015ea:	00003517          	auipc	a0,0x3
ffffffffc02015ee:	59e50513          	addi	a0,a0,1438 # ffffffffc0204b88 <commands+0x750>
ffffffffc02015f2:	e51fe0ef          	jal	ra,ffffffffc0200442 <__panic>
    assert(n > 0);
ffffffffc02015f6:	00004697          	auipc	a3,0x4
ffffffffc02015fa:	8d268693          	addi	a3,a3,-1838 # ffffffffc0204ec8 <commands+0xa90>
ffffffffc02015fe:	00003617          	auipc	a2,0x3
ffffffffc0201602:	57260613          	addi	a2,a2,1394 # ffffffffc0204b70 <commands+0x738>
ffffffffc0201606:	04600593          	li	a1,70
ffffffffc020160a:	00003517          	auipc	a0,0x3
ffffffffc020160e:	57e50513          	addi	a0,a0,1406 # ffffffffc0204b88 <commands+0x750>
ffffffffc0201612:	e31fe0ef          	jal	ra,ffffffffc0200442 <__panic>

ffffffffc0201616 <slob_free>:
static void slob_free(void *block, int size)
{
	slob_t *cur, *b = (slob_t *)block;
	unsigned long flags;

	if (!block)
ffffffffc0201616:	c94d                	beqz	a0,ffffffffc02016c8 <slob_free+0xb2>
{
ffffffffc0201618:	1141                	addi	sp,sp,-16
ffffffffc020161a:	e022                	sd	s0,0(sp)
ffffffffc020161c:	e406                	sd	ra,8(sp)
ffffffffc020161e:	842a                	mv	s0,a0
		return;

	if (size)
ffffffffc0201620:	e9c1                	bnez	a1,ffffffffc02016b0 <slob_free+0x9a>
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0201622:	100027f3          	csrr	a5,sstatus
ffffffffc0201626:	8b89                	andi	a5,a5,2
    return 0;
ffffffffc0201628:	4501                	li	a0,0
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc020162a:	ebd9                	bnez	a5,ffffffffc02016c0 <slob_free+0xaa>
		b->units = SLOB_UNITS(size);

	/* Find reinsertion point */
	spin_lock_irqsave(&slob_lock, flags);
	for (cur = slobfree; !(b > cur && b < cur->next); cur = cur->next)
ffffffffc020162c:	00009617          	auipc	a2,0x9
ffffffffc0201630:	9e460613          	addi	a2,a2,-1564 # ffffffffc020a010 <slobfree>
ffffffffc0201634:	621c                	ld	a5,0(a2)
		if (cur >= cur->next && (b > cur || b < cur->next))
ffffffffc0201636:	873e                	mv	a4,a5
	for (cur = slobfree; !(b > cur && b < cur->next); cur = cur->next)
ffffffffc0201638:	679c                	ld	a5,8(a5)
ffffffffc020163a:	02877a63          	bgeu	a4,s0,ffffffffc020166e <slob_free+0x58>
ffffffffc020163e:	00f46463          	bltu	s0,a5,ffffffffc0201646 <slob_free+0x30>
		if (cur >= cur->next && (b > cur || b < cur->next))
ffffffffc0201642:	fef76ae3          	bltu	a4,a5,ffffffffc0201636 <slob_free+0x20>
			break;

	if (b + b->units == cur->next) {
ffffffffc0201646:	400c                	lw	a1,0(s0)
ffffffffc0201648:	00459693          	slli	a3,a1,0x4
ffffffffc020164c:	96a2                	add	a3,a3,s0
ffffffffc020164e:	02d78a63          	beq	a5,a3,ffffffffc0201682 <slob_free+0x6c>
		b->units += cur->next->units;
		b->next = cur->next->next;
	} else
		b->next = cur->next;

	if (cur + cur->units == b) {
ffffffffc0201652:	4314                	lw	a3,0(a4)
		b->next = cur->next;
ffffffffc0201654:	e41c                	sd	a5,8(s0)
	if (cur + cur->units == b) {
ffffffffc0201656:	00469793          	slli	a5,a3,0x4
ffffffffc020165a:	97ba                	add	a5,a5,a4
ffffffffc020165c:	02f40e63          	beq	s0,a5,ffffffffc0201698 <slob_free+0x82>
		cur->units += b->units;
		cur->next = b->next;
	} else
		cur->next = b;
ffffffffc0201660:	e700                	sd	s0,8(a4)

	slobfree = cur;
ffffffffc0201662:	e218                	sd	a4,0(a2)
    if (flag) {
ffffffffc0201664:	e129                	bnez	a0,ffffffffc02016a6 <slob_free+0x90>

	spin_unlock_irqrestore(&slob_lock, flags);
}
ffffffffc0201666:	60a2                	ld	ra,8(sp)
ffffffffc0201668:	6402                	ld	s0,0(sp)
ffffffffc020166a:	0141                	addi	sp,sp,16
ffffffffc020166c:	8082                	ret
		if (cur >= cur->next && (b > cur || b < cur->next))
ffffffffc020166e:	fcf764e3          	bltu	a4,a5,ffffffffc0201636 <slob_free+0x20>
ffffffffc0201672:	fcf472e3          	bgeu	s0,a5,ffffffffc0201636 <slob_free+0x20>
	if (b + b->units == cur->next) {
ffffffffc0201676:	400c                	lw	a1,0(s0)
ffffffffc0201678:	00459693          	slli	a3,a1,0x4
ffffffffc020167c:	96a2                	add	a3,a3,s0
ffffffffc020167e:	fcd79ae3          	bne	a5,a3,ffffffffc0201652 <slob_free+0x3c>
		b->units += cur->next->units;
ffffffffc0201682:	4394                	lw	a3,0(a5)
		b->next = cur->next->next;
ffffffffc0201684:	679c                	ld	a5,8(a5)
		b->units += cur->next->units;
ffffffffc0201686:	9db5                	addw	a1,a1,a3
ffffffffc0201688:	c00c                	sw	a1,0(s0)
	if (cur + cur->units == b) {
ffffffffc020168a:	4314                	lw	a3,0(a4)
		b->next = cur->next->next;
ffffffffc020168c:	e41c                	sd	a5,8(s0)
	if (cur + cur->units == b) {
ffffffffc020168e:	00469793          	slli	a5,a3,0x4
ffffffffc0201692:	97ba                	add	a5,a5,a4
ffffffffc0201694:	fcf416e3          	bne	s0,a5,ffffffffc0201660 <slob_free+0x4a>
		cur->units += b->units;
ffffffffc0201698:	401c                	lw	a5,0(s0)
		cur->next = b->next;
ffffffffc020169a:	640c                	ld	a1,8(s0)
	slobfree = cur;
ffffffffc020169c:	e218                	sd	a4,0(a2)
		cur->units += b->units;
ffffffffc020169e:	9ebd                	addw	a3,a3,a5
ffffffffc02016a0:	c314                	sw	a3,0(a4)
		cur->next = b->next;
ffffffffc02016a2:	e70c                	sd	a1,8(a4)
ffffffffc02016a4:	d169                	beqz	a0,ffffffffc0201666 <slob_free+0x50>
}
ffffffffc02016a6:	6402                	ld	s0,0(sp)
ffffffffc02016a8:	60a2                	ld	ra,8(sp)
ffffffffc02016aa:	0141                	addi	sp,sp,16
        intr_enable();
ffffffffc02016ac:	eddfe06f          	j	ffffffffc0200588 <intr_enable>
		b->units = SLOB_UNITS(size);
ffffffffc02016b0:	25bd                	addiw	a1,a1,15
ffffffffc02016b2:	8191                	srli	a1,a1,0x4
ffffffffc02016b4:	c10c                	sw	a1,0(a0)
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc02016b6:	100027f3          	csrr	a5,sstatus
ffffffffc02016ba:	8b89                	andi	a5,a5,2
    return 0;
ffffffffc02016bc:	4501                	li	a0,0
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc02016be:	d7bd                	beqz	a5,ffffffffc020162c <slob_free+0x16>
        intr_disable();
ffffffffc02016c0:	ecffe0ef          	jal	ra,ffffffffc020058e <intr_disable>
        return 1;
ffffffffc02016c4:	4505                	li	a0,1
ffffffffc02016c6:	b79d                	j	ffffffffc020162c <slob_free+0x16>
ffffffffc02016c8:	8082                	ret

ffffffffc02016ca <__slob_get_free_pages.constprop.0>:
  struct Page * page = alloc_pages(1 << order);
ffffffffc02016ca:	4785                	li	a5,1
static void* __slob_get_free_pages(gfp_t gfp, int order)
ffffffffc02016cc:	1141                	addi	sp,sp,-16
  struct Page * page = alloc_pages(1 << order);
ffffffffc02016ce:	00a7953b          	sllw	a0,a5,a0
static void* __slob_get_free_pages(gfp_t gfp, int order)
ffffffffc02016d2:	e406                	sd	ra,8(sp)
  struct Page * page = alloc_pages(1 << order);
ffffffffc02016d4:	360000ef          	jal	ra,ffffffffc0201a34 <alloc_pages>
  if(!page)
ffffffffc02016d8:	c129                	beqz	a0,ffffffffc020171a <__slob_get_free_pages.constprop.0+0x50>
    return page - pages + nbase;
ffffffffc02016da:	00014697          	auipc	a3,0x14
ffffffffc02016de:	db66b683          	ld	a3,-586(a3) # ffffffffc0215490 <pages>
ffffffffc02016e2:	8d15                	sub	a0,a0,a3
ffffffffc02016e4:	850d                	srai	a0,a0,0x3
ffffffffc02016e6:	00005697          	auipc	a3,0x5
ffffffffc02016ea:	9526b683          	ld	a3,-1710(a3) # ffffffffc0206038 <error_string+0x38>
ffffffffc02016ee:	02d50533          	mul	a0,a0,a3
ffffffffc02016f2:	00005697          	auipc	a3,0x5
ffffffffc02016f6:	94e6b683          	ld	a3,-1714(a3) # ffffffffc0206040 <nbase>
    return KADDR(page2pa(page));
ffffffffc02016fa:	00014717          	auipc	a4,0x14
ffffffffc02016fe:	d8e73703          	ld	a4,-626(a4) # ffffffffc0215488 <npage>
    return page - pages + nbase;
ffffffffc0201702:	9536                	add	a0,a0,a3
    return KADDR(page2pa(page));
ffffffffc0201704:	00c51793          	slli	a5,a0,0xc
ffffffffc0201708:	83b1                	srli	a5,a5,0xc
    return page2ppn(page) << PGSHIFT;
ffffffffc020170a:	0532                	slli	a0,a0,0xc
    return KADDR(page2pa(page));
ffffffffc020170c:	00e7fa63          	bgeu	a5,a4,ffffffffc0201720 <__slob_get_free_pages.constprop.0+0x56>
ffffffffc0201710:	00014697          	auipc	a3,0x14
ffffffffc0201714:	d906b683          	ld	a3,-624(a3) # ffffffffc02154a0 <va_pa_offset>
ffffffffc0201718:	9536                	add	a0,a0,a3
}
ffffffffc020171a:	60a2                	ld	ra,8(sp)
ffffffffc020171c:	0141                	addi	sp,sp,16
ffffffffc020171e:	8082                	ret
ffffffffc0201720:	86aa                	mv	a3,a0
ffffffffc0201722:	00004617          	auipc	a2,0x4
ffffffffc0201726:	83660613          	addi	a2,a2,-1994 # ffffffffc0204f58 <default_pmm_manager+0x38>
ffffffffc020172a:	06900593          	li	a1,105
ffffffffc020172e:	00004517          	auipc	a0,0x4
ffffffffc0201732:	85250513          	addi	a0,a0,-1966 # ffffffffc0204f80 <default_pmm_manager+0x60>
ffffffffc0201736:	d0dfe0ef          	jal	ra,ffffffffc0200442 <__panic>

ffffffffc020173a <slob_alloc.constprop.0>:
static void *slob_alloc(size_t size, gfp_t gfp, int align)
ffffffffc020173a:	1101                	addi	sp,sp,-32
ffffffffc020173c:	ec06                	sd	ra,24(sp)
ffffffffc020173e:	e822                	sd	s0,16(sp)
ffffffffc0201740:	e426                	sd	s1,8(sp)
ffffffffc0201742:	e04a                	sd	s2,0(sp)
	assert( (size + SLOB_UNIT) < PAGE_SIZE );
ffffffffc0201744:	01050713          	addi	a4,a0,16
ffffffffc0201748:	6785                	lui	a5,0x1
ffffffffc020174a:	0cf77363          	bgeu	a4,a5,ffffffffc0201810 <slob_alloc.constprop.0+0xd6>
	int delta = 0, units = SLOB_UNITS(size);
ffffffffc020174e:	00f50493          	addi	s1,a0,15
ffffffffc0201752:	8091                	srli	s1,s1,0x4
ffffffffc0201754:	2481                	sext.w	s1,s1
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0201756:	10002673          	csrr	a2,sstatus
ffffffffc020175a:	8a09                	andi	a2,a2,2
ffffffffc020175c:	e25d                	bnez	a2,ffffffffc0201802 <slob_alloc.constprop.0+0xc8>
	prev = slobfree;
ffffffffc020175e:	00009917          	auipc	s2,0x9
ffffffffc0201762:	8b290913          	addi	s2,s2,-1870 # ffffffffc020a010 <slobfree>
ffffffffc0201766:	00093683          	ld	a3,0(s2)
	for (cur = prev->next; ; prev = cur, cur = cur->next) {
ffffffffc020176a:	669c                	ld	a5,8(a3)
		if (cur->units >= units + delta) { /* room enough? */
ffffffffc020176c:	4398                	lw	a4,0(a5)
ffffffffc020176e:	08975e63          	bge	a4,s1,ffffffffc020180a <slob_alloc.constprop.0+0xd0>
		if (cur == slobfree) {
ffffffffc0201772:	00d78b63          	beq	a5,a3,ffffffffc0201788 <slob_alloc.constprop.0+0x4e>
	for (cur = prev->next; ; prev = cur, cur = cur->next) {
ffffffffc0201776:	6780                	ld	s0,8(a5)
		if (cur->units >= units + delta) { /* room enough? */
ffffffffc0201778:	4018                	lw	a4,0(s0)
ffffffffc020177a:	02975a63          	bge	a4,s1,ffffffffc02017ae <slob_alloc.constprop.0+0x74>
		if (cur == slobfree) {
ffffffffc020177e:	00093683          	ld	a3,0(s2)
ffffffffc0201782:	87a2                	mv	a5,s0
ffffffffc0201784:	fed799e3          	bne	a5,a3,ffffffffc0201776 <slob_alloc.constprop.0+0x3c>
    if (flag) {
ffffffffc0201788:	ee31                	bnez	a2,ffffffffc02017e4 <slob_alloc.constprop.0+0xaa>
			cur = (slob_t *)__slob_get_free_page(gfp);
ffffffffc020178a:	4501                	li	a0,0
ffffffffc020178c:	f3fff0ef          	jal	ra,ffffffffc02016ca <__slob_get_free_pages.constprop.0>
ffffffffc0201790:	842a                	mv	s0,a0
			if (!cur)
ffffffffc0201792:	cd05                	beqz	a0,ffffffffc02017ca <slob_alloc.constprop.0+0x90>
			slob_free(cur, PAGE_SIZE);
ffffffffc0201794:	6585                	lui	a1,0x1
ffffffffc0201796:	e81ff0ef          	jal	ra,ffffffffc0201616 <slob_free>
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc020179a:	10002673          	csrr	a2,sstatus
ffffffffc020179e:	8a09                	andi	a2,a2,2
ffffffffc02017a0:	ee05                	bnez	a2,ffffffffc02017d8 <slob_alloc.constprop.0+0x9e>
			cur = slobfree;
ffffffffc02017a2:	00093783          	ld	a5,0(s2)
	for (cur = prev->next; ; prev = cur, cur = cur->next) {
ffffffffc02017a6:	6780                	ld	s0,8(a5)
		if (cur->units >= units + delta) { /* room enough? */
ffffffffc02017a8:	4018                	lw	a4,0(s0)
ffffffffc02017aa:	fc974ae3          	blt	a4,s1,ffffffffc020177e <slob_alloc.constprop.0+0x44>
			if (cur->units == units) /* exact fit? */
ffffffffc02017ae:	04e48763          	beq	s1,a4,ffffffffc02017fc <slob_alloc.constprop.0+0xc2>
				prev->next = cur + units;
ffffffffc02017b2:	00449693          	slli	a3,s1,0x4
ffffffffc02017b6:	96a2                	add	a3,a3,s0
ffffffffc02017b8:	e794                	sd	a3,8(a5)
				prev->next->next = cur->next;
ffffffffc02017ba:	640c                	ld	a1,8(s0)
				prev->next->units = cur->units - units;
ffffffffc02017bc:	9f05                	subw	a4,a4,s1
ffffffffc02017be:	c298                	sw	a4,0(a3)
				prev->next->next = cur->next;
ffffffffc02017c0:	e68c                	sd	a1,8(a3)
				cur->units = units;
ffffffffc02017c2:	c004                	sw	s1,0(s0)
			slobfree = prev;
ffffffffc02017c4:	00f93023          	sd	a5,0(s2)
    if (flag) {
ffffffffc02017c8:	e20d                	bnez	a2,ffffffffc02017ea <slob_alloc.constprop.0+0xb0>
}
ffffffffc02017ca:	60e2                	ld	ra,24(sp)
ffffffffc02017cc:	8522                	mv	a0,s0
ffffffffc02017ce:	6442                	ld	s0,16(sp)
ffffffffc02017d0:	64a2                	ld	s1,8(sp)
ffffffffc02017d2:	6902                	ld	s2,0(sp)
ffffffffc02017d4:	6105                	addi	sp,sp,32
ffffffffc02017d6:	8082                	ret
        intr_disable();
ffffffffc02017d8:	db7fe0ef          	jal	ra,ffffffffc020058e <intr_disable>
			cur = slobfree;
ffffffffc02017dc:	00093783          	ld	a5,0(s2)
        return 1;
ffffffffc02017e0:	4605                	li	a2,1
ffffffffc02017e2:	b7d1                	j	ffffffffc02017a6 <slob_alloc.constprop.0+0x6c>
        intr_enable();
ffffffffc02017e4:	da5fe0ef          	jal	ra,ffffffffc0200588 <intr_enable>
ffffffffc02017e8:	b74d                	j	ffffffffc020178a <slob_alloc.constprop.0+0x50>
ffffffffc02017ea:	d9ffe0ef          	jal	ra,ffffffffc0200588 <intr_enable>
}
ffffffffc02017ee:	60e2                	ld	ra,24(sp)
ffffffffc02017f0:	8522                	mv	a0,s0
ffffffffc02017f2:	6442                	ld	s0,16(sp)
ffffffffc02017f4:	64a2                	ld	s1,8(sp)
ffffffffc02017f6:	6902                	ld	s2,0(sp)
ffffffffc02017f8:	6105                	addi	sp,sp,32
ffffffffc02017fa:	8082                	ret
				prev->next = cur->next; /* unlink */
ffffffffc02017fc:	6418                	ld	a4,8(s0)
ffffffffc02017fe:	e798                	sd	a4,8(a5)
ffffffffc0201800:	b7d1                	j	ffffffffc02017c4 <slob_alloc.constprop.0+0x8a>
        intr_disable();
ffffffffc0201802:	d8dfe0ef          	jal	ra,ffffffffc020058e <intr_disable>
        return 1;
ffffffffc0201806:	4605                	li	a2,1
ffffffffc0201808:	bf99                	j	ffffffffc020175e <slob_alloc.constprop.0+0x24>
		if (cur->units >= units + delta) { /* room enough? */
ffffffffc020180a:	843e                	mv	s0,a5
ffffffffc020180c:	87b6                	mv	a5,a3
ffffffffc020180e:	b745                	j	ffffffffc02017ae <slob_alloc.constprop.0+0x74>
	assert( (size + SLOB_UNIT) < PAGE_SIZE );
ffffffffc0201810:	00003697          	auipc	a3,0x3
ffffffffc0201814:	78068693          	addi	a3,a3,1920 # ffffffffc0204f90 <default_pmm_manager+0x70>
ffffffffc0201818:	00003617          	auipc	a2,0x3
ffffffffc020181c:	35860613          	addi	a2,a2,856 # ffffffffc0204b70 <commands+0x738>
ffffffffc0201820:	06300593          	li	a1,99
ffffffffc0201824:	00003517          	auipc	a0,0x3
ffffffffc0201828:	78c50513          	addi	a0,a0,1932 # ffffffffc0204fb0 <default_pmm_manager+0x90>
ffffffffc020182c:	c17fe0ef          	jal	ra,ffffffffc0200442 <__panic>

ffffffffc0201830 <kmalloc_init>:
slob_init(void) {
  cprintf("use SLOB allocator\n");
}

inline void 
kmalloc_init(void) {
ffffffffc0201830:	1141                	addi	sp,sp,-16
  cprintf("use SLOB allocator\n");
ffffffffc0201832:	00003517          	auipc	a0,0x3
ffffffffc0201836:	79650513          	addi	a0,a0,1942 # ffffffffc0204fc8 <default_pmm_manager+0xa8>
kmalloc_init(void) {
ffffffffc020183a:	e406                	sd	ra,8(sp)
  cprintf("use SLOB allocator\n");
ffffffffc020183c:	941fe0ef          	jal	ra,ffffffffc020017c <cprintf>
    slob_init();
    cprintf("kmalloc_init() succeeded!\n");
}
ffffffffc0201840:	60a2                	ld	ra,8(sp)
    cprintf("kmalloc_init() succeeded!\n");
ffffffffc0201842:	00003517          	auipc	a0,0x3
ffffffffc0201846:	79e50513          	addi	a0,a0,1950 # ffffffffc0204fe0 <default_pmm_manager+0xc0>
}
ffffffffc020184a:	0141                	addi	sp,sp,16
    cprintf("kmalloc_init() succeeded!\n");
ffffffffc020184c:	931fe06f          	j	ffffffffc020017c <cprintf>

ffffffffc0201850 <kmalloc>:
	return 0;
}

void *
kmalloc(size_t size)
{
ffffffffc0201850:	1101                	addi	sp,sp,-32
ffffffffc0201852:	e04a                	sd	s2,0(sp)
	if (size < PAGE_SIZE - SLOB_UNIT) {
ffffffffc0201854:	6905                	lui	s2,0x1
{
ffffffffc0201856:	e822                	sd	s0,16(sp)
ffffffffc0201858:	ec06                	sd	ra,24(sp)
ffffffffc020185a:	e426                	sd	s1,8(sp)
	if (size < PAGE_SIZE - SLOB_UNIT) {
ffffffffc020185c:	fef90793          	addi	a5,s2,-17 # fef <kern_entry-0xffffffffc01ff011>
{
ffffffffc0201860:	842a                	mv	s0,a0
	if (size < PAGE_SIZE - SLOB_UNIT) {
ffffffffc0201862:	04a7f963          	bgeu	a5,a0,ffffffffc02018b4 <kmalloc+0x64>
	bb = slob_alloc(sizeof(bigblock_t), gfp, 0);
ffffffffc0201866:	4561                	li	a0,24
ffffffffc0201868:	ed3ff0ef          	jal	ra,ffffffffc020173a <slob_alloc.constprop.0>
ffffffffc020186c:	84aa                	mv	s1,a0
	if (!bb)
ffffffffc020186e:	c929                	beqz	a0,ffffffffc02018c0 <kmalloc+0x70>
	bb->order = find_order(size);
ffffffffc0201870:	0004079b          	sext.w	a5,s0
	int order = 0;
ffffffffc0201874:	4501                	li	a0,0
	for ( ; size > 4096 ; size >>=1)
ffffffffc0201876:	00f95763          	bge	s2,a5,ffffffffc0201884 <kmalloc+0x34>
ffffffffc020187a:	6705                	lui	a4,0x1
ffffffffc020187c:	8785                	srai	a5,a5,0x1
		order++;
ffffffffc020187e:	2505                	addiw	a0,a0,1
	for ( ; size > 4096 ; size >>=1)
ffffffffc0201880:	fef74ee3          	blt	a4,a5,ffffffffc020187c <kmalloc+0x2c>
	bb->order = find_order(size);
ffffffffc0201884:	c088                	sw	a0,0(s1)
	bb->pages = (void *)__slob_get_free_pages(gfp, bb->order);
ffffffffc0201886:	e45ff0ef          	jal	ra,ffffffffc02016ca <__slob_get_free_pages.constprop.0>
ffffffffc020188a:	e488                	sd	a0,8(s1)
ffffffffc020188c:	842a                	mv	s0,a0
	if (bb->pages) {
ffffffffc020188e:	c525                	beqz	a0,ffffffffc02018f6 <kmalloc+0xa6>
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0201890:	100027f3          	csrr	a5,sstatus
ffffffffc0201894:	8b89                	andi	a5,a5,2
ffffffffc0201896:	ef8d                	bnez	a5,ffffffffc02018d0 <kmalloc+0x80>
		bb->next = bigblocks;
ffffffffc0201898:	00014797          	auipc	a5,0x14
ffffffffc020189c:	bd878793          	addi	a5,a5,-1064 # ffffffffc0215470 <bigblocks>
ffffffffc02018a0:	6398                	ld	a4,0(a5)
		bigblocks = bb;
ffffffffc02018a2:	e384                	sd	s1,0(a5)
		bb->next = bigblocks;
ffffffffc02018a4:	e898                	sd	a4,16(s1)
  return __kmalloc(size, 0);
}
ffffffffc02018a6:	60e2                	ld	ra,24(sp)
ffffffffc02018a8:	8522                	mv	a0,s0
ffffffffc02018aa:	6442                	ld	s0,16(sp)
ffffffffc02018ac:	64a2                	ld	s1,8(sp)
ffffffffc02018ae:	6902                	ld	s2,0(sp)
ffffffffc02018b0:	6105                	addi	sp,sp,32
ffffffffc02018b2:	8082                	ret
		m = slob_alloc(size + SLOB_UNIT, gfp, 0);
ffffffffc02018b4:	0541                	addi	a0,a0,16
ffffffffc02018b6:	e85ff0ef          	jal	ra,ffffffffc020173a <slob_alloc.constprop.0>
		return m ? (void *)(m + 1) : 0;
ffffffffc02018ba:	01050413          	addi	s0,a0,16
ffffffffc02018be:	f565                	bnez	a0,ffffffffc02018a6 <kmalloc+0x56>
ffffffffc02018c0:	4401                	li	s0,0
}
ffffffffc02018c2:	60e2                	ld	ra,24(sp)
ffffffffc02018c4:	8522                	mv	a0,s0
ffffffffc02018c6:	6442                	ld	s0,16(sp)
ffffffffc02018c8:	64a2                	ld	s1,8(sp)
ffffffffc02018ca:	6902                	ld	s2,0(sp)
ffffffffc02018cc:	6105                	addi	sp,sp,32
ffffffffc02018ce:	8082                	ret
        intr_disable();
ffffffffc02018d0:	cbffe0ef          	jal	ra,ffffffffc020058e <intr_disable>
		bb->next = bigblocks;
ffffffffc02018d4:	00014797          	auipc	a5,0x14
ffffffffc02018d8:	b9c78793          	addi	a5,a5,-1124 # ffffffffc0215470 <bigblocks>
ffffffffc02018dc:	6398                	ld	a4,0(a5)
		bigblocks = bb;
ffffffffc02018de:	e384                	sd	s1,0(a5)
		bb->next = bigblocks;
ffffffffc02018e0:	e898                	sd	a4,16(s1)
        intr_enable();
ffffffffc02018e2:	ca7fe0ef          	jal	ra,ffffffffc0200588 <intr_enable>
		return bb->pages;
ffffffffc02018e6:	6480                	ld	s0,8(s1)
}
ffffffffc02018e8:	60e2                	ld	ra,24(sp)
ffffffffc02018ea:	64a2                	ld	s1,8(sp)
ffffffffc02018ec:	8522                	mv	a0,s0
ffffffffc02018ee:	6442                	ld	s0,16(sp)
ffffffffc02018f0:	6902                	ld	s2,0(sp)
ffffffffc02018f2:	6105                	addi	sp,sp,32
ffffffffc02018f4:	8082                	ret
	slob_free(bb, sizeof(bigblock_t));
ffffffffc02018f6:	45e1                	li	a1,24
ffffffffc02018f8:	8526                	mv	a0,s1
ffffffffc02018fa:	d1dff0ef          	jal	ra,ffffffffc0201616 <slob_free>
  return __kmalloc(size, 0);
ffffffffc02018fe:	b765                	j	ffffffffc02018a6 <kmalloc+0x56>

ffffffffc0201900 <kfree>:
void kfree(void *block)
{
	bigblock_t *bb, **last = &bigblocks;
	unsigned long flags;

	if (!block)
ffffffffc0201900:	c561                	beqz	a0,ffffffffc02019c8 <kfree+0xc8>
{
ffffffffc0201902:	1101                	addi	sp,sp,-32
ffffffffc0201904:	e822                	sd	s0,16(sp)
ffffffffc0201906:	ec06                	sd	ra,24(sp)
ffffffffc0201908:	e426                	sd	s1,8(sp)
		return;

	if (!((unsigned long)block & (PAGE_SIZE-1))) {
ffffffffc020190a:	03451793          	slli	a5,a0,0x34
ffffffffc020190e:	842a                	mv	s0,a0
ffffffffc0201910:	e7d1                	bnez	a5,ffffffffc020199c <kfree+0x9c>
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0201912:	100027f3          	csrr	a5,sstatus
ffffffffc0201916:	8b89                	andi	a5,a5,2
ffffffffc0201918:	ebd1                	bnez	a5,ffffffffc02019ac <kfree+0xac>
		/* might be on the big block list */
		spin_lock_irqsave(&block_lock, flags);
		for (bb = bigblocks; bb; last = &bb->next, bb = bb->next) {
ffffffffc020191a:	00014797          	auipc	a5,0x14
ffffffffc020191e:	b567b783          	ld	a5,-1194(a5) # ffffffffc0215470 <bigblocks>
    return 0;
ffffffffc0201922:	4601                	li	a2,0
ffffffffc0201924:	cfa5                	beqz	a5,ffffffffc020199c <kfree+0x9c>
	bigblock_t *bb, **last = &bigblocks;
ffffffffc0201926:	00014697          	auipc	a3,0x14
ffffffffc020192a:	b4a68693          	addi	a3,a3,-1206 # ffffffffc0215470 <bigblocks>
ffffffffc020192e:	a021                	j	ffffffffc0201936 <kfree+0x36>
		for (bb = bigblocks; bb; last = &bb->next, bb = bb->next) {
ffffffffc0201930:	01048693          	addi	a3,s1,16
ffffffffc0201934:	c3bd                	beqz	a5,ffffffffc020199a <kfree+0x9a>
			if (bb->pages == block) {
ffffffffc0201936:	6798                	ld	a4,8(a5)
ffffffffc0201938:	84be                	mv	s1,a5
				*last = bb->next;
ffffffffc020193a:	6b9c                	ld	a5,16(a5)
			if (bb->pages == block) {
ffffffffc020193c:	fe871ae3          	bne	a4,s0,ffffffffc0201930 <kfree+0x30>
				*last = bb->next;
ffffffffc0201940:	e29c                	sd	a5,0(a3)
    if (flag) {
ffffffffc0201942:	e241                	bnez	a2,ffffffffc02019c2 <kfree+0xc2>
    return pa2page(PADDR(kva));
ffffffffc0201944:	c02007b7          	lui	a5,0xc0200
				spin_unlock_irqrestore(&block_lock, flags);
				__slob_free_pages((unsigned long)block, bb->order);
ffffffffc0201948:	4098                	lw	a4,0(s1)
ffffffffc020194a:	08f46c63          	bltu	s0,a5,ffffffffc02019e2 <kfree+0xe2>
ffffffffc020194e:	00014697          	auipc	a3,0x14
ffffffffc0201952:	b526b683          	ld	a3,-1198(a3) # ffffffffc02154a0 <va_pa_offset>
ffffffffc0201956:	8c15                	sub	s0,s0,a3
    if (PPN(pa) >= npage) {
ffffffffc0201958:	8031                	srli	s0,s0,0xc
ffffffffc020195a:	00014797          	auipc	a5,0x14
ffffffffc020195e:	b2e7b783          	ld	a5,-1234(a5) # ffffffffc0215488 <npage>
ffffffffc0201962:	06f47463          	bgeu	s0,a5,ffffffffc02019ca <kfree+0xca>
    return &pages[PPN(pa) - nbase];
ffffffffc0201966:	00004797          	auipc	a5,0x4
ffffffffc020196a:	6da7b783          	ld	a5,1754(a5) # ffffffffc0206040 <nbase>
ffffffffc020196e:	8c1d                	sub	s0,s0,a5
ffffffffc0201970:	00341513          	slli	a0,s0,0x3
ffffffffc0201974:	942a                	add	s0,s0,a0
ffffffffc0201976:	040e                	slli	s0,s0,0x3
  free_pages(kva2page(kva), 1 << order);
ffffffffc0201978:	00014517          	auipc	a0,0x14
ffffffffc020197c:	b1853503          	ld	a0,-1256(a0) # ffffffffc0215490 <pages>
ffffffffc0201980:	4585                	li	a1,1
ffffffffc0201982:	9522                	add	a0,a0,s0
ffffffffc0201984:	00e595bb          	sllw	a1,a1,a4
ffffffffc0201988:	13e000ef          	jal	ra,ffffffffc0201ac6 <free_pages>
		spin_unlock_irqrestore(&block_lock, flags);
	}

	slob_free((slob_t *)block - 1, 0);
	return;
}
ffffffffc020198c:	6442                	ld	s0,16(sp)
ffffffffc020198e:	60e2                	ld	ra,24(sp)
				slob_free(bb, sizeof(bigblock_t));
ffffffffc0201990:	8526                	mv	a0,s1
}
ffffffffc0201992:	64a2                	ld	s1,8(sp)
				slob_free(bb, sizeof(bigblock_t));
ffffffffc0201994:	45e1                	li	a1,24
}
ffffffffc0201996:	6105                	addi	sp,sp,32
	slob_free((slob_t *)block - 1, 0);
ffffffffc0201998:	b9bd                	j	ffffffffc0201616 <slob_free>
ffffffffc020199a:	e20d                	bnez	a2,ffffffffc02019bc <kfree+0xbc>
ffffffffc020199c:	ff040513          	addi	a0,s0,-16
}
ffffffffc02019a0:	6442                	ld	s0,16(sp)
ffffffffc02019a2:	60e2                	ld	ra,24(sp)
ffffffffc02019a4:	64a2                	ld	s1,8(sp)
	slob_free((slob_t *)block - 1, 0);
ffffffffc02019a6:	4581                	li	a1,0
}
ffffffffc02019a8:	6105                	addi	sp,sp,32
	slob_free((slob_t *)block - 1, 0);
ffffffffc02019aa:	b1b5                	j	ffffffffc0201616 <slob_free>
        intr_disable();
ffffffffc02019ac:	be3fe0ef          	jal	ra,ffffffffc020058e <intr_disable>
		for (bb = bigblocks; bb; last = &bb->next, bb = bb->next) {
ffffffffc02019b0:	00014797          	auipc	a5,0x14
ffffffffc02019b4:	ac07b783          	ld	a5,-1344(a5) # ffffffffc0215470 <bigblocks>
        return 1;
ffffffffc02019b8:	4605                	li	a2,1
ffffffffc02019ba:	f7b5                	bnez	a5,ffffffffc0201926 <kfree+0x26>
        intr_enable();
ffffffffc02019bc:	bcdfe0ef          	jal	ra,ffffffffc0200588 <intr_enable>
ffffffffc02019c0:	bff1                	j	ffffffffc020199c <kfree+0x9c>
ffffffffc02019c2:	bc7fe0ef          	jal	ra,ffffffffc0200588 <intr_enable>
ffffffffc02019c6:	bfbd                	j	ffffffffc0201944 <kfree+0x44>
ffffffffc02019c8:	8082                	ret
        panic("pa2page called with invalid pa");
ffffffffc02019ca:	00003617          	auipc	a2,0x3
ffffffffc02019ce:	65e60613          	addi	a2,a2,1630 # ffffffffc0205028 <default_pmm_manager+0x108>
ffffffffc02019d2:	06200593          	li	a1,98
ffffffffc02019d6:	00003517          	auipc	a0,0x3
ffffffffc02019da:	5aa50513          	addi	a0,a0,1450 # ffffffffc0204f80 <default_pmm_manager+0x60>
ffffffffc02019de:	a65fe0ef          	jal	ra,ffffffffc0200442 <__panic>
    return pa2page(PADDR(kva));
ffffffffc02019e2:	86a2                	mv	a3,s0
ffffffffc02019e4:	00003617          	auipc	a2,0x3
ffffffffc02019e8:	61c60613          	addi	a2,a2,1564 # ffffffffc0205000 <default_pmm_manager+0xe0>
ffffffffc02019ec:	06e00593          	li	a1,110
ffffffffc02019f0:	00003517          	auipc	a0,0x3
ffffffffc02019f4:	59050513          	addi	a0,a0,1424 # ffffffffc0204f80 <default_pmm_manager+0x60>
ffffffffc02019f8:	a4bfe0ef          	jal	ra,ffffffffc0200442 <__panic>

ffffffffc02019fc <pa2page.part.0>:
pa2page(uintptr_t pa) {
ffffffffc02019fc:	1141                	addi	sp,sp,-16
        panic("pa2page called with invalid pa");
ffffffffc02019fe:	00003617          	auipc	a2,0x3
ffffffffc0201a02:	62a60613          	addi	a2,a2,1578 # ffffffffc0205028 <default_pmm_manager+0x108>
ffffffffc0201a06:	06200593          	li	a1,98
ffffffffc0201a0a:	00003517          	auipc	a0,0x3
ffffffffc0201a0e:	57650513          	addi	a0,a0,1398 # ffffffffc0204f80 <default_pmm_manager+0x60>
pa2page(uintptr_t pa) {
ffffffffc0201a12:	e406                	sd	ra,8(sp)
        panic("pa2page called with invalid pa");
ffffffffc0201a14:	a2ffe0ef          	jal	ra,ffffffffc0200442 <__panic>

ffffffffc0201a18 <pte2page.part.0>:
pte2page(pte_t pte) {
ffffffffc0201a18:	1141                	addi	sp,sp,-16
        panic("pte2page called with invalid pte");
ffffffffc0201a1a:	00003617          	auipc	a2,0x3
ffffffffc0201a1e:	62e60613          	addi	a2,a2,1582 # ffffffffc0205048 <default_pmm_manager+0x128>
ffffffffc0201a22:	07400593          	li	a1,116
ffffffffc0201a26:	00003517          	auipc	a0,0x3
ffffffffc0201a2a:	55a50513          	addi	a0,a0,1370 # ffffffffc0204f80 <default_pmm_manager+0x60>
pte2page(pte_t pte) {
ffffffffc0201a2e:	e406                	sd	ra,8(sp)
        panic("pte2page called with invalid pte");
ffffffffc0201a30:	a13fe0ef          	jal	ra,ffffffffc0200442 <__panic>

ffffffffc0201a34 <alloc_pages>:
    pmm_manager->init_memmap(base, n);
}

// alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE
// memory
struct Page *alloc_pages(size_t n) {
ffffffffc0201a34:	7139                	addi	sp,sp,-64
ffffffffc0201a36:	f426                	sd	s1,40(sp)
ffffffffc0201a38:	f04a                	sd	s2,32(sp)
ffffffffc0201a3a:	ec4e                	sd	s3,24(sp)
ffffffffc0201a3c:	e852                	sd	s4,16(sp)
ffffffffc0201a3e:	e456                	sd	s5,8(sp)
ffffffffc0201a40:	e05a                	sd	s6,0(sp)
ffffffffc0201a42:	fc06                	sd	ra,56(sp)
ffffffffc0201a44:	f822                	sd	s0,48(sp)
ffffffffc0201a46:	84aa                	mv	s1,a0
ffffffffc0201a48:	00014917          	auipc	s2,0x14
ffffffffc0201a4c:	a5090913          	addi	s2,s2,-1456 # ffffffffc0215498 <pmm_manager>
        {
            page = pmm_manager->alloc_pages(n);
        }
        local_intr_restore(intr_flag);

        if (page != NULL || n > 1 || swap_init_ok == 0) break;
ffffffffc0201a50:	4a05                	li	s4,1
ffffffffc0201a52:	00014a97          	auipc	s5,0x14
ffffffffc0201a56:	a66a8a93          	addi	s5,s5,-1434 # ffffffffc02154b8 <swap_init_ok>

        extern struct mm_struct *check_mm_struct;
        // cprintf("page %x, call swap_out in alloc_pages %d\n",page, n);
        swap_out(check_mm_struct, n, 0);
ffffffffc0201a5a:	0005099b          	sext.w	s3,a0
ffffffffc0201a5e:	00014b17          	auipc	s6,0x14
ffffffffc0201a62:	a62b0b13          	addi	s6,s6,-1438 # ffffffffc02154c0 <check_mm_struct>
ffffffffc0201a66:	a01d                	j	ffffffffc0201a8c <alloc_pages+0x58>
            page = pmm_manager->alloc_pages(n);
ffffffffc0201a68:	00093783          	ld	a5,0(s2)
ffffffffc0201a6c:	6f9c                	ld	a5,24(a5)
ffffffffc0201a6e:	9782                	jalr	a5
ffffffffc0201a70:	842a                	mv	s0,a0
        swap_out(check_mm_struct, n, 0);
ffffffffc0201a72:	4601                	li	a2,0
ffffffffc0201a74:	85ce                	mv	a1,s3
        if (page != NULL || n > 1 || swap_init_ok == 0) break;
ffffffffc0201a76:	ec0d                	bnez	s0,ffffffffc0201ab0 <alloc_pages+0x7c>
ffffffffc0201a78:	029a6c63          	bltu	s4,s1,ffffffffc0201ab0 <alloc_pages+0x7c>
ffffffffc0201a7c:	000aa783          	lw	a5,0(s5)
ffffffffc0201a80:	2781                	sext.w	a5,a5
ffffffffc0201a82:	c79d                	beqz	a5,ffffffffc0201ab0 <alloc_pages+0x7c>
        swap_out(check_mm_struct, n, 0);
ffffffffc0201a84:	000b3503          	ld	a0,0(s6)
ffffffffc0201a88:	18e010ef          	jal	ra,ffffffffc0202c16 <swap_out>
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0201a8c:	100027f3          	csrr	a5,sstatus
ffffffffc0201a90:	8b89                	andi	a5,a5,2
            page = pmm_manager->alloc_pages(n);
ffffffffc0201a92:	8526                	mv	a0,s1
ffffffffc0201a94:	dbf1                	beqz	a5,ffffffffc0201a68 <alloc_pages+0x34>
        intr_disable();
ffffffffc0201a96:	af9fe0ef          	jal	ra,ffffffffc020058e <intr_disable>
ffffffffc0201a9a:	00093783          	ld	a5,0(s2)
ffffffffc0201a9e:	8526                	mv	a0,s1
ffffffffc0201aa0:	6f9c                	ld	a5,24(a5)
ffffffffc0201aa2:	9782                	jalr	a5
ffffffffc0201aa4:	842a                	mv	s0,a0
        intr_enable();
ffffffffc0201aa6:	ae3fe0ef          	jal	ra,ffffffffc0200588 <intr_enable>
        swap_out(check_mm_struct, n, 0);
ffffffffc0201aaa:	4601                	li	a2,0
ffffffffc0201aac:	85ce                	mv	a1,s3
        if (page != NULL || n > 1 || swap_init_ok == 0) break;
ffffffffc0201aae:	d469                	beqz	s0,ffffffffc0201a78 <alloc_pages+0x44>
    }
    // cprintf("n %d,get page %x, No %d in alloc_pages\n",n,page,(page-pages));
    return page;
}
ffffffffc0201ab0:	70e2                	ld	ra,56(sp)
ffffffffc0201ab2:	8522                	mv	a0,s0
ffffffffc0201ab4:	7442                	ld	s0,48(sp)
ffffffffc0201ab6:	74a2                	ld	s1,40(sp)
ffffffffc0201ab8:	7902                	ld	s2,32(sp)
ffffffffc0201aba:	69e2                	ld	s3,24(sp)
ffffffffc0201abc:	6a42                	ld	s4,16(sp)
ffffffffc0201abe:	6aa2                	ld	s5,8(sp)
ffffffffc0201ac0:	6b02                	ld	s6,0(sp)
ffffffffc0201ac2:	6121                	addi	sp,sp,64
ffffffffc0201ac4:	8082                	ret

ffffffffc0201ac6 <free_pages>:
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0201ac6:	100027f3          	csrr	a5,sstatus
ffffffffc0201aca:	8b89                	andi	a5,a5,2
ffffffffc0201acc:	e799                	bnez	a5,ffffffffc0201ada <free_pages+0x14>
// free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory
void free_pages(struct Page *base, size_t n) {
    bool intr_flag;
    local_intr_save(intr_flag);
    {
        pmm_manager->free_pages(base, n);
ffffffffc0201ace:	00014797          	auipc	a5,0x14
ffffffffc0201ad2:	9ca7b783          	ld	a5,-1590(a5) # ffffffffc0215498 <pmm_manager>
ffffffffc0201ad6:	739c                	ld	a5,32(a5)
ffffffffc0201ad8:	8782                	jr	a5
void free_pages(struct Page *base, size_t n) {
ffffffffc0201ada:	1101                	addi	sp,sp,-32
ffffffffc0201adc:	ec06                	sd	ra,24(sp)
ffffffffc0201ade:	e822                	sd	s0,16(sp)
ffffffffc0201ae0:	e426                	sd	s1,8(sp)
ffffffffc0201ae2:	842a                	mv	s0,a0
ffffffffc0201ae4:	84ae                	mv	s1,a1
        intr_disable();
ffffffffc0201ae6:	aa9fe0ef          	jal	ra,ffffffffc020058e <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc0201aea:	00014797          	auipc	a5,0x14
ffffffffc0201aee:	9ae7b783          	ld	a5,-1618(a5) # ffffffffc0215498 <pmm_manager>
ffffffffc0201af2:	739c                	ld	a5,32(a5)
ffffffffc0201af4:	85a6                	mv	a1,s1
ffffffffc0201af6:	8522                	mv	a0,s0
ffffffffc0201af8:	9782                	jalr	a5
    }
    local_intr_restore(intr_flag);
}
ffffffffc0201afa:	6442                	ld	s0,16(sp)
ffffffffc0201afc:	60e2                	ld	ra,24(sp)
ffffffffc0201afe:	64a2                	ld	s1,8(sp)
ffffffffc0201b00:	6105                	addi	sp,sp,32
        intr_enable();
ffffffffc0201b02:	a87fe06f          	j	ffffffffc0200588 <intr_enable>

ffffffffc0201b06 <nr_free_pages>:
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0201b06:	100027f3          	csrr	a5,sstatus
ffffffffc0201b0a:	8b89                	andi	a5,a5,2
ffffffffc0201b0c:	e799                	bnez	a5,ffffffffc0201b1a <nr_free_pages+0x14>
size_t nr_free_pages(void) {
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
    {
        ret = pmm_manager->nr_free_pages();
ffffffffc0201b0e:	00014797          	auipc	a5,0x14
ffffffffc0201b12:	98a7b783          	ld	a5,-1654(a5) # ffffffffc0215498 <pmm_manager>
ffffffffc0201b16:	779c                	ld	a5,40(a5)
ffffffffc0201b18:	8782                	jr	a5
size_t nr_free_pages(void) {
ffffffffc0201b1a:	1141                	addi	sp,sp,-16
ffffffffc0201b1c:	e406                	sd	ra,8(sp)
ffffffffc0201b1e:	e022                	sd	s0,0(sp)
        intr_disable();
ffffffffc0201b20:	a6ffe0ef          	jal	ra,ffffffffc020058e <intr_disable>
        ret = pmm_manager->nr_free_pages();
ffffffffc0201b24:	00014797          	auipc	a5,0x14
ffffffffc0201b28:	9747b783          	ld	a5,-1676(a5) # ffffffffc0215498 <pmm_manager>
ffffffffc0201b2c:	779c                	ld	a5,40(a5)
ffffffffc0201b2e:	9782                	jalr	a5
ffffffffc0201b30:	842a                	mv	s0,a0
        intr_enable();
ffffffffc0201b32:	a57fe0ef          	jal	ra,ffffffffc0200588 <intr_enable>
    }
    local_intr_restore(intr_flag);
    return ret;
}
ffffffffc0201b36:	60a2                	ld	ra,8(sp)
ffffffffc0201b38:	8522                	mv	a0,s0
ffffffffc0201b3a:	6402                	ld	s0,0(sp)
ffffffffc0201b3c:	0141                	addi	sp,sp,16
ffffffffc0201b3e:	8082                	ret

ffffffffc0201b40 <get_pte>:
//  pgdir:  the kernel virtual base address of PDT
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *get_pte(pde_t *pgdir, uintptr_t la, bool create) {
    pde_t *pdep1 = &pgdir[PDX1(la)];
ffffffffc0201b40:	01e5d793          	srli	a5,a1,0x1e
ffffffffc0201b44:	1ff7f793          	andi	a5,a5,511
pte_t *get_pte(pde_t *pgdir, uintptr_t la, bool create) {
ffffffffc0201b48:	715d                	addi	sp,sp,-80
    pde_t *pdep1 = &pgdir[PDX1(la)];
ffffffffc0201b4a:	078e                	slli	a5,a5,0x3
pte_t *get_pte(pde_t *pgdir, uintptr_t la, bool create) {
ffffffffc0201b4c:	fc26                	sd	s1,56(sp)
    pde_t *pdep1 = &pgdir[PDX1(la)];
ffffffffc0201b4e:	00f504b3          	add	s1,a0,a5
    if (!(*pdep1 & PTE_V)) {
ffffffffc0201b52:	6094                	ld	a3,0(s1)
pte_t *get_pte(pde_t *pgdir, uintptr_t la, bool create) {
ffffffffc0201b54:	f84a                	sd	s2,48(sp)
ffffffffc0201b56:	f44e                	sd	s3,40(sp)
ffffffffc0201b58:	f052                	sd	s4,32(sp)
ffffffffc0201b5a:	e486                	sd	ra,72(sp)
ffffffffc0201b5c:	e0a2                	sd	s0,64(sp)
ffffffffc0201b5e:	ec56                	sd	s5,24(sp)
ffffffffc0201b60:	e85a                	sd	s6,16(sp)
ffffffffc0201b62:	e45e                	sd	s7,8(sp)
    if (!(*pdep1 & PTE_V)) {
ffffffffc0201b64:	0016f793          	andi	a5,a3,1
pte_t *get_pte(pde_t *pgdir, uintptr_t la, bool create) {
ffffffffc0201b68:	892e                	mv	s2,a1
ffffffffc0201b6a:	8a32                	mv	s4,a2
ffffffffc0201b6c:	00014997          	auipc	s3,0x14
ffffffffc0201b70:	91c98993          	addi	s3,s3,-1764 # ffffffffc0215488 <npage>
    if (!(*pdep1 & PTE_V)) {
ffffffffc0201b74:	efb5                	bnez	a5,ffffffffc0201bf0 <get_pte+0xb0>
        struct Page *page;
        if (!create || (page = alloc_page()) == NULL) {
ffffffffc0201b76:	14060c63          	beqz	a2,ffffffffc0201cce <get_pte+0x18e>
ffffffffc0201b7a:	4505                	li	a0,1
ffffffffc0201b7c:	eb9ff0ef          	jal	ra,ffffffffc0201a34 <alloc_pages>
ffffffffc0201b80:	842a                	mv	s0,a0
ffffffffc0201b82:	14050663          	beqz	a0,ffffffffc0201cce <get_pte+0x18e>
    return page - pages + nbase;
ffffffffc0201b86:	00014b97          	auipc	s7,0x14
ffffffffc0201b8a:	90ab8b93          	addi	s7,s7,-1782 # ffffffffc0215490 <pages>
ffffffffc0201b8e:	000bb503          	ld	a0,0(s7)
ffffffffc0201b92:	00004b17          	auipc	s6,0x4
ffffffffc0201b96:	4a6b3b03          	ld	s6,1190(s6) # ffffffffc0206038 <error_string+0x38>
ffffffffc0201b9a:	00080ab7          	lui	s5,0x80
ffffffffc0201b9e:	40a40533          	sub	a0,s0,a0
ffffffffc0201ba2:	850d                	srai	a0,a0,0x3
ffffffffc0201ba4:	03650533          	mul	a0,a0,s6
            return NULL;
        }
        set_page_ref(page, 1);
        uintptr_t pa = page2pa(page);
        memset(KADDR(pa), 0, PGSIZE);
ffffffffc0201ba8:	00014997          	auipc	s3,0x14
ffffffffc0201bac:	8e098993          	addi	s3,s3,-1824 # ffffffffc0215488 <npage>
    page->ref = val;
ffffffffc0201bb0:	4785                	li	a5,1
ffffffffc0201bb2:	0009b703          	ld	a4,0(s3)
ffffffffc0201bb6:	c01c                	sw	a5,0(s0)
    return page - pages + nbase;
ffffffffc0201bb8:	9556                	add	a0,a0,s5
ffffffffc0201bba:	00c51793          	slli	a5,a0,0xc
ffffffffc0201bbe:	83b1                	srli	a5,a5,0xc
    return page2ppn(page) << PGSHIFT;
ffffffffc0201bc0:	0532                	slli	a0,a0,0xc
ffffffffc0201bc2:	14e7fd63          	bgeu	a5,a4,ffffffffc0201d1c <get_pte+0x1dc>
ffffffffc0201bc6:	00014797          	auipc	a5,0x14
ffffffffc0201bca:	8da7b783          	ld	a5,-1830(a5) # ffffffffc02154a0 <va_pa_offset>
ffffffffc0201bce:	6605                	lui	a2,0x1
ffffffffc0201bd0:	4581                	li	a1,0
ffffffffc0201bd2:	953e                	add	a0,a0,a5
ffffffffc0201bd4:	5aa020ef          	jal	ra,ffffffffc020417e <memset>
    return page - pages + nbase;
ffffffffc0201bd8:	000bb683          	ld	a3,0(s7)
ffffffffc0201bdc:	40d406b3          	sub	a3,s0,a3
ffffffffc0201be0:	868d                	srai	a3,a3,0x3
ffffffffc0201be2:	036686b3          	mul	a3,a3,s6
ffffffffc0201be6:	96d6                	add	a3,a3,s5
  asm volatile("sfence.vma");
}

// construct PTE from a page and permission bits
static inline pte_t pte_create(uintptr_t ppn, int type) {
  return (ppn << PTE_PPN_SHIFT) | PTE_V | type;
ffffffffc0201be8:	06aa                	slli	a3,a3,0xa
ffffffffc0201bea:	0116e693          	ori	a3,a3,17
        *pdep1 = pte_create(page2ppn(page), PTE_U | PTE_V);
ffffffffc0201bee:	e094                	sd	a3,0(s1)
    }
    pde_t *pdep0 = &((pte_t *)KADDR(PDE_ADDR(*pdep1)))[PDX0(la)];
ffffffffc0201bf0:	77fd                	lui	a5,0xfffff
ffffffffc0201bf2:	068a                	slli	a3,a3,0x2
ffffffffc0201bf4:	0009b703          	ld	a4,0(s3)
ffffffffc0201bf8:	8efd                	and	a3,a3,a5
ffffffffc0201bfa:	00c6d793          	srli	a5,a3,0xc
ffffffffc0201bfe:	0ce7fa63          	bgeu	a5,a4,ffffffffc0201cd2 <get_pte+0x192>
ffffffffc0201c02:	00014a97          	auipc	s5,0x14
ffffffffc0201c06:	89ea8a93          	addi	s5,s5,-1890 # ffffffffc02154a0 <va_pa_offset>
ffffffffc0201c0a:	000ab403          	ld	s0,0(s5)
ffffffffc0201c0e:	01595793          	srli	a5,s2,0x15
ffffffffc0201c12:	1ff7f793          	andi	a5,a5,511
ffffffffc0201c16:	96a2                	add	a3,a3,s0
ffffffffc0201c18:	00379413          	slli	s0,a5,0x3
ffffffffc0201c1c:	9436                	add	s0,s0,a3
    if (!(*pdep0 & PTE_V)) {
ffffffffc0201c1e:	6014                	ld	a3,0(s0)
ffffffffc0201c20:	0016f793          	andi	a5,a3,1
ffffffffc0201c24:	ebad                	bnez	a5,ffffffffc0201c96 <get_pte+0x156>
        struct Page *page;
        if (!create || (page = alloc_page()) == NULL) {
ffffffffc0201c26:	0a0a0463          	beqz	s4,ffffffffc0201cce <get_pte+0x18e>
ffffffffc0201c2a:	4505                	li	a0,1
ffffffffc0201c2c:	e09ff0ef          	jal	ra,ffffffffc0201a34 <alloc_pages>
ffffffffc0201c30:	84aa                	mv	s1,a0
ffffffffc0201c32:	cd51                	beqz	a0,ffffffffc0201cce <get_pte+0x18e>
    return page - pages + nbase;
ffffffffc0201c34:	00014b97          	auipc	s7,0x14
ffffffffc0201c38:	85cb8b93          	addi	s7,s7,-1956 # ffffffffc0215490 <pages>
ffffffffc0201c3c:	000bb503          	ld	a0,0(s7)
ffffffffc0201c40:	00004b17          	auipc	s6,0x4
ffffffffc0201c44:	3f8b3b03          	ld	s6,1016(s6) # ffffffffc0206038 <error_string+0x38>
ffffffffc0201c48:	00080a37          	lui	s4,0x80
ffffffffc0201c4c:	40a48533          	sub	a0,s1,a0
ffffffffc0201c50:	850d                	srai	a0,a0,0x3
ffffffffc0201c52:	03650533          	mul	a0,a0,s6
    page->ref = val;
ffffffffc0201c56:	4785                	li	a5,1
            return NULL;
        }
        set_page_ref(page, 1);
        uintptr_t pa = page2pa(page);
        memset(KADDR(pa), 0, PGSIZE);
ffffffffc0201c58:	0009b703          	ld	a4,0(s3)
ffffffffc0201c5c:	c09c                	sw	a5,0(s1)
    return page - pages + nbase;
ffffffffc0201c5e:	9552                	add	a0,a0,s4
ffffffffc0201c60:	00c51793          	slli	a5,a0,0xc
ffffffffc0201c64:	83b1                	srli	a5,a5,0xc
    return page2ppn(page) << PGSHIFT;
ffffffffc0201c66:	0532                	slli	a0,a0,0xc
ffffffffc0201c68:	08e7fd63          	bgeu	a5,a4,ffffffffc0201d02 <get_pte+0x1c2>
ffffffffc0201c6c:	000ab783          	ld	a5,0(s5)
ffffffffc0201c70:	6605                	lui	a2,0x1
ffffffffc0201c72:	4581                	li	a1,0
ffffffffc0201c74:	953e                	add	a0,a0,a5
ffffffffc0201c76:	508020ef          	jal	ra,ffffffffc020417e <memset>
    return page - pages + nbase;
ffffffffc0201c7a:	000bb683          	ld	a3,0(s7)
ffffffffc0201c7e:	40d486b3          	sub	a3,s1,a3
ffffffffc0201c82:	868d                	srai	a3,a3,0x3
ffffffffc0201c84:	036686b3          	mul	a3,a3,s6
ffffffffc0201c88:	96d2                	add	a3,a3,s4
  return (ppn << PTE_PPN_SHIFT) | PTE_V | type;
ffffffffc0201c8a:	06aa                	slli	a3,a3,0xa
ffffffffc0201c8c:	0116e693          	ori	a3,a3,17
        *pdep0 = pte_create(page2ppn(page), PTE_U | PTE_V);
ffffffffc0201c90:	e014                	sd	a3,0(s0)
    }
    return &((pte_t *)KADDR(PDE_ADDR(*pdep0)))[PTX(la)];
ffffffffc0201c92:	0009b703          	ld	a4,0(s3)
ffffffffc0201c96:	068a                	slli	a3,a3,0x2
ffffffffc0201c98:	757d                	lui	a0,0xfffff
ffffffffc0201c9a:	8ee9                	and	a3,a3,a0
ffffffffc0201c9c:	00c6d793          	srli	a5,a3,0xc
ffffffffc0201ca0:	04e7f563          	bgeu	a5,a4,ffffffffc0201cea <get_pte+0x1aa>
ffffffffc0201ca4:	000ab503          	ld	a0,0(s5)
ffffffffc0201ca8:	00c95913          	srli	s2,s2,0xc
ffffffffc0201cac:	1ff97913          	andi	s2,s2,511
ffffffffc0201cb0:	96aa                	add	a3,a3,a0
ffffffffc0201cb2:	00391513          	slli	a0,s2,0x3
ffffffffc0201cb6:	9536                	add	a0,a0,a3
}
ffffffffc0201cb8:	60a6                	ld	ra,72(sp)
ffffffffc0201cba:	6406                	ld	s0,64(sp)
ffffffffc0201cbc:	74e2                	ld	s1,56(sp)
ffffffffc0201cbe:	7942                	ld	s2,48(sp)
ffffffffc0201cc0:	79a2                	ld	s3,40(sp)
ffffffffc0201cc2:	7a02                	ld	s4,32(sp)
ffffffffc0201cc4:	6ae2                	ld	s5,24(sp)
ffffffffc0201cc6:	6b42                	ld	s6,16(sp)
ffffffffc0201cc8:	6ba2                	ld	s7,8(sp)
ffffffffc0201cca:	6161                	addi	sp,sp,80
ffffffffc0201ccc:	8082                	ret
            return NULL;
ffffffffc0201cce:	4501                	li	a0,0
ffffffffc0201cd0:	b7e5                	j	ffffffffc0201cb8 <get_pte+0x178>
    pde_t *pdep0 = &((pte_t *)KADDR(PDE_ADDR(*pdep1)))[PDX0(la)];
ffffffffc0201cd2:	00003617          	auipc	a2,0x3
ffffffffc0201cd6:	28660613          	addi	a2,a2,646 # ffffffffc0204f58 <default_pmm_manager+0x38>
ffffffffc0201cda:	0e400593          	li	a1,228
ffffffffc0201cde:	00003517          	auipc	a0,0x3
ffffffffc0201ce2:	39250513          	addi	a0,a0,914 # ffffffffc0205070 <default_pmm_manager+0x150>
ffffffffc0201ce6:	f5cfe0ef          	jal	ra,ffffffffc0200442 <__panic>
    return &((pte_t *)KADDR(PDE_ADDR(*pdep0)))[PTX(la)];
ffffffffc0201cea:	00003617          	auipc	a2,0x3
ffffffffc0201cee:	26e60613          	addi	a2,a2,622 # ffffffffc0204f58 <default_pmm_manager+0x38>
ffffffffc0201cf2:	0ef00593          	li	a1,239
ffffffffc0201cf6:	00003517          	auipc	a0,0x3
ffffffffc0201cfa:	37a50513          	addi	a0,a0,890 # ffffffffc0205070 <default_pmm_manager+0x150>
ffffffffc0201cfe:	f44fe0ef          	jal	ra,ffffffffc0200442 <__panic>
        memset(KADDR(pa), 0, PGSIZE);
ffffffffc0201d02:	86aa                	mv	a3,a0
ffffffffc0201d04:	00003617          	auipc	a2,0x3
ffffffffc0201d08:	25460613          	addi	a2,a2,596 # ffffffffc0204f58 <default_pmm_manager+0x38>
ffffffffc0201d0c:	0ec00593          	li	a1,236
ffffffffc0201d10:	00003517          	auipc	a0,0x3
ffffffffc0201d14:	36050513          	addi	a0,a0,864 # ffffffffc0205070 <default_pmm_manager+0x150>
ffffffffc0201d18:	f2afe0ef          	jal	ra,ffffffffc0200442 <__panic>
        memset(KADDR(pa), 0, PGSIZE);
ffffffffc0201d1c:	86aa                	mv	a3,a0
ffffffffc0201d1e:	00003617          	auipc	a2,0x3
ffffffffc0201d22:	23a60613          	addi	a2,a2,570 # ffffffffc0204f58 <default_pmm_manager+0x38>
ffffffffc0201d26:	0e100593          	li	a1,225
ffffffffc0201d2a:	00003517          	auipc	a0,0x3
ffffffffc0201d2e:	34650513          	addi	a0,a0,838 # ffffffffc0205070 <default_pmm_manager+0x150>
ffffffffc0201d32:	f10fe0ef          	jal	ra,ffffffffc0200442 <__panic>

ffffffffc0201d36 <get_page>:

// get_page - get related Page struct for linear address la using PDT pgdir
struct Page *get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store) {
ffffffffc0201d36:	1141                	addi	sp,sp,-16
ffffffffc0201d38:	e022                	sd	s0,0(sp)
ffffffffc0201d3a:	8432                	mv	s0,a2
    pte_t *ptep = get_pte(pgdir, la, 0);
ffffffffc0201d3c:	4601                	li	a2,0
struct Page *get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store) {
ffffffffc0201d3e:	e406                	sd	ra,8(sp)
    pte_t *ptep = get_pte(pgdir, la, 0);
ffffffffc0201d40:	e01ff0ef          	jal	ra,ffffffffc0201b40 <get_pte>
    if (ptep_store != NULL) {
ffffffffc0201d44:	c011                	beqz	s0,ffffffffc0201d48 <get_page+0x12>
        *ptep_store = ptep;
ffffffffc0201d46:	e008                	sd	a0,0(s0)
    }
    if (ptep != NULL && *ptep & PTE_V) {
ffffffffc0201d48:	c511                	beqz	a0,ffffffffc0201d54 <get_page+0x1e>
ffffffffc0201d4a:	611c                	ld	a5,0(a0)
        return pte2page(*ptep);
    }
    return NULL;
ffffffffc0201d4c:	4501                	li	a0,0
    if (ptep != NULL && *ptep & PTE_V) {
ffffffffc0201d4e:	0017f713          	andi	a4,a5,1
ffffffffc0201d52:	e709                	bnez	a4,ffffffffc0201d5c <get_page+0x26>
}
ffffffffc0201d54:	60a2                	ld	ra,8(sp)
ffffffffc0201d56:	6402                	ld	s0,0(sp)
ffffffffc0201d58:	0141                	addi	sp,sp,16
ffffffffc0201d5a:	8082                	ret
    return pa2page(PTE_ADDR(pte));
ffffffffc0201d5c:	078a                	slli	a5,a5,0x2
ffffffffc0201d5e:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage) {
ffffffffc0201d60:	00013717          	auipc	a4,0x13
ffffffffc0201d64:	72873703          	ld	a4,1832(a4) # ffffffffc0215488 <npage>
ffffffffc0201d68:	02e7f263          	bgeu	a5,a4,ffffffffc0201d8c <get_page+0x56>
    return &pages[PPN(pa) - nbase];
ffffffffc0201d6c:	fff80537          	lui	a0,0xfff80
ffffffffc0201d70:	97aa                	add	a5,a5,a0
ffffffffc0201d72:	60a2                	ld	ra,8(sp)
ffffffffc0201d74:	6402                	ld	s0,0(sp)
ffffffffc0201d76:	00379513          	slli	a0,a5,0x3
ffffffffc0201d7a:	97aa                	add	a5,a5,a0
ffffffffc0201d7c:	078e                	slli	a5,a5,0x3
ffffffffc0201d7e:	00013517          	auipc	a0,0x13
ffffffffc0201d82:	71253503          	ld	a0,1810(a0) # ffffffffc0215490 <pages>
ffffffffc0201d86:	953e                	add	a0,a0,a5
ffffffffc0201d88:	0141                	addi	sp,sp,16
ffffffffc0201d8a:	8082                	ret
ffffffffc0201d8c:	c71ff0ef          	jal	ra,ffffffffc02019fc <pa2page.part.0>

ffffffffc0201d90 <page_remove>:
    }
}

// page_remove - free an Page which is related linear address la and has an
// validated pte
void page_remove(pde_t *pgdir, uintptr_t la) {
ffffffffc0201d90:	7179                	addi	sp,sp,-48
    pte_t *ptep = get_pte(pgdir, la, 0);
ffffffffc0201d92:	4601                	li	a2,0
void page_remove(pde_t *pgdir, uintptr_t la) {
ffffffffc0201d94:	ec26                	sd	s1,24(sp)
ffffffffc0201d96:	f406                	sd	ra,40(sp)
ffffffffc0201d98:	f022                	sd	s0,32(sp)
ffffffffc0201d9a:	84ae                	mv	s1,a1
    pte_t *ptep = get_pte(pgdir, la, 0);
ffffffffc0201d9c:	da5ff0ef          	jal	ra,ffffffffc0201b40 <get_pte>
    if (ptep != NULL) {
ffffffffc0201da0:	c511                	beqz	a0,ffffffffc0201dac <page_remove+0x1c>
    if (*ptep & PTE_V) {  //(1) check if this page table entry is
ffffffffc0201da2:	611c                	ld	a5,0(a0)
ffffffffc0201da4:	842a                	mv	s0,a0
ffffffffc0201da6:	0017f713          	andi	a4,a5,1
ffffffffc0201daa:	e711                	bnez	a4,ffffffffc0201db6 <page_remove+0x26>
        page_remove_pte(pgdir, la, ptep);
    }
}
ffffffffc0201dac:	70a2                	ld	ra,40(sp)
ffffffffc0201dae:	7402                	ld	s0,32(sp)
ffffffffc0201db0:	64e2                	ld	s1,24(sp)
ffffffffc0201db2:	6145                	addi	sp,sp,48
ffffffffc0201db4:	8082                	ret
    return pa2page(PTE_ADDR(pte));
ffffffffc0201db6:	078a                	slli	a5,a5,0x2
ffffffffc0201db8:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage) {
ffffffffc0201dba:	00013717          	auipc	a4,0x13
ffffffffc0201dbe:	6ce73703          	ld	a4,1742(a4) # ffffffffc0215488 <npage>
ffffffffc0201dc2:	06e7f663          	bgeu	a5,a4,ffffffffc0201e2e <page_remove+0x9e>
    return &pages[PPN(pa) - nbase];
ffffffffc0201dc6:	fff80737          	lui	a4,0xfff80
ffffffffc0201dca:	97ba                	add	a5,a5,a4
ffffffffc0201dcc:	00379513          	slli	a0,a5,0x3
ffffffffc0201dd0:	97aa                	add	a5,a5,a0
ffffffffc0201dd2:	078e                	slli	a5,a5,0x3
ffffffffc0201dd4:	00013517          	auipc	a0,0x13
ffffffffc0201dd8:	6bc53503          	ld	a0,1724(a0) # ffffffffc0215490 <pages>
ffffffffc0201ddc:	953e                	add	a0,a0,a5
    page->ref -= 1;
ffffffffc0201dde:	411c                	lw	a5,0(a0)
ffffffffc0201de0:	fff7871b          	addiw	a4,a5,-1
ffffffffc0201de4:	c118                	sw	a4,0(a0)
        if (page_ref(page) ==
ffffffffc0201de6:	cb11                	beqz	a4,ffffffffc0201dfa <page_remove+0x6a>
        *ptep = 0;                  //(5) clear second page table entry
ffffffffc0201de8:	00043023          	sd	zero,0(s0)
// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void tlb_invalidate(pde_t *pgdir, uintptr_t la) {
    // flush_tlb();
    // The flush_tlb flush the entire TLB, is there any better way?
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc0201dec:	12048073          	sfence.vma	s1
}
ffffffffc0201df0:	70a2                	ld	ra,40(sp)
ffffffffc0201df2:	7402                	ld	s0,32(sp)
ffffffffc0201df4:	64e2                	ld	s1,24(sp)
ffffffffc0201df6:	6145                	addi	sp,sp,48
ffffffffc0201df8:	8082                	ret
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0201dfa:	100027f3          	csrr	a5,sstatus
ffffffffc0201dfe:	8b89                	andi	a5,a5,2
ffffffffc0201e00:	eb89                	bnez	a5,ffffffffc0201e12 <page_remove+0x82>
        pmm_manager->free_pages(base, n);
ffffffffc0201e02:	00013797          	auipc	a5,0x13
ffffffffc0201e06:	6967b783          	ld	a5,1686(a5) # ffffffffc0215498 <pmm_manager>
ffffffffc0201e0a:	739c                	ld	a5,32(a5)
ffffffffc0201e0c:	4585                	li	a1,1
ffffffffc0201e0e:	9782                	jalr	a5
    if (flag) {
ffffffffc0201e10:	bfe1                	j	ffffffffc0201de8 <page_remove+0x58>
        intr_disable();
ffffffffc0201e12:	e42a                	sd	a0,8(sp)
ffffffffc0201e14:	f7afe0ef          	jal	ra,ffffffffc020058e <intr_disable>
ffffffffc0201e18:	00013797          	auipc	a5,0x13
ffffffffc0201e1c:	6807b783          	ld	a5,1664(a5) # ffffffffc0215498 <pmm_manager>
ffffffffc0201e20:	739c                	ld	a5,32(a5)
ffffffffc0201e22:	6522                	ld	a0,8(sp)
ffffffffc0201e24:	4585                	li	a1,1
ffffffffc0201e26:	9782                	jalr	a5
        intr_enable();
ffffffffc0201e28:	f60fe0ef          	jal	ra,ffffffffc0200588 <intr_enable>
ffffffffc0201e2c:	bf75                	j	ffffffffc0201de8 <page_remove+0x58>
ffffffffc0201e2e:	bcfff0ef          	jal	ra,ffffffffc02019fc <pa2page.part.0>

ffffffffc0201e32 <page_insert>:
int page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
ffffffffc0201e32:	7139                	addi	sp,sp,-64
ffffffffc0201e34:	ec4e                	sd	s3,24(sp)
ffffffffc0201e36:	89b2                	mv	s3,a2
ffffffffc0201e38:	f822                	sd	s0,48(sp)
    pte_t *ptep = get_pte(pgdir, la, 1);
ffffffffc0201e3a:	4605                	li	a2,1
int page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
ffffffffc0201e3c:	842e                	mv	s0,a1
    pte_t *ptep = get_pte(pgdir, la, 1);
ffffffffc0201e3e:	85ce                	mv	a1,s3
int page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
ffffffffc0201e40:	f426                	sd	s1,40(sp)
ffffffffc0201e42:	fc06                	sd	ra,56(sp)
ffffffffc0201e44:	f04a                	sd	s2,32(sp)
ffffffffc0201e46:	e852                	sd	s4,16(sp)
ffffffffc0201e48:	e456                	sd	s5,8(sp)
ffffffffc0201e4a:	84b6                	mv	s1,a3
    pte_t *ptep = get_pte(pgdir, la, 1);
ffffffffc0201e4c:	cf5ff0ef          	jal	ra,ffffffffc0201b40 <get_pte>
    if (ptep == NULL) {
ffffffffc0201e50:	c17d                	beqz	a0,ffffffffc0201f36 <page_insert+0x104>
    page->ref += 1;
ffffffffc0201e52:	4014                	lw	a3,0(s0)
    if (*ptep & PTE_V) {
ffffffffc0201e54:	611c                	ld	a5,0(a0)
ffffffffc0201e56:	8a2a                	mv	s4,a0
ffffffffc0201e58:	0016871b          	addiw	a4,a3,1
ffffffffc0201e5c:	c018                	sw	a4,0(s0)
ffffffffc0201e5e:	0017f713          	andi	a4,a5,1
ffffffffc0201e62:	e339                	bnez	a4,ffffffffc0201ea8 <page_insert+0x76>
    return page - pages + nbase;
ffffffffc0201e64:	00013797          	auipc	a5,0x13
ffffffffc0201e68:	62c7b783          	ld	a5,1580(a5) # ffffffffc0215490 <pages>
ffffffffc0201e6c:	40f407b3          	sub	a5,s0,a5
ffffffffc0201e70:	878d                	srai	a5,a5,0x3
ffffffffc0201e72:	00004417          	auipc	s0,0x4
ffffffffc0201e76:	1c643403          	ld	s0,454(s0) # ffffffffc0206038 <error_string+0x38>
ffffffffc0201e7a:	028787b3          	mul	a5,a5,s0
ffffffffc0201e7e:	00080437          	lui	s0,0x80
ffffffffc0201e82:	97a2                	add	a5,a5,s0
  return (ppn << PTE_PPN_SHIFT) | PTE_V | type;
ffffffffc0201e84:	07aa                	slli	a5,a5,0xa
ffffffffc0201e86:	8cdd                	or	s1,s1,a5
ffffffffc0201e88:	0014e493          	ori	s1,s1,1
    *ptep = pte_create(page2ppn(page), PTE_V | perm);
ffffffffc0201e8c:	009a3023          	sd	s1,0(s4) # 80000 <kern_entry-0xffffffffc0180000>
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc0201e90:	12098073          	sfence.vma	s3
    return 0;
ffffffffc0201e94:	4501                	li	a0,0
}
ffffffffc0201e96:	70e2                	ld	ra,56(sp)
ffffffffc0201e98:	7442                	ld	s0,48(sp)
ffffffffc0201e9a:	74a2                	ld	s1,40(sp)
ffffffffc0201e9c:	7902                	ld	s2,32(sp)
ffffffffc0201e9e:	69e2                	ld	s3,24(sp)
ffffffffc0201ea0:	6a42                	ld	s4,16(sp)
ffffffffc0201ea2:	6aa2                	ld	s5,8(sp)
ffffffffc0201ea4:	6121                	addi	sp,sp,64
ffffffffc0201ea6:	8082                	ret
    return pa2page(PTE_ADDR(pte));
ffffffffc0201ea8:	00279713          	slli	a4,a5,0x2
ffffffffc0201eac:	8331                	srli	a4,a4,0xc
    if (PPN(pa) >= npage) {
ffffffffc0201eae:	00013797          	auipc	a5,0x13
ffffffffc0201eb2:	5da7b783          	ld	a5,1498(a5) # ffffffffc0215488 <npage>
ffffffffc0201eb6:	08f77263          	bgeu	a4,a5,ffffffffc0201f3a <page_insert+0x108>
    return &pages[PPN(pa) - nbase];
ffffffffc0201eba:	fff807b7          	lui	a5,0xfff80
ffffffffc0201ebe:	973e                	add	a4,a4,a5
ffffffffc0201ec0:	00013a97          	auipc	s5,0x13
ffffffffc0201ec4:	5d0a8a93          	addi	s5,s5,1488 # ffffffffc0215490 <pages>
ffffffffc0201ec8:	000ab783          	ld	a5,0(s5)
ffffffffc0201ecc:	00371913          	slli	s2,a4,0x3
ffffffffc0201ed0:	993a                	add	s2,s2,a4
ffffffffc0201ed2:	090e                	slli	s2,s2,0x3
ffffffffc0201ed4:	993e                	add	s2,s2,a5
        if (p == page) {
ffffffffc0201ed6:	01240c63          	beq	s0,s2,ffffffffc0201eee <page_insert+0xbc>
    page->ref -= 1;
ffffffffc0201eda:	00092703          	lw	a4,0(s2)
ffffffffc0201ede:	fff7069b          	addiw	a3,a4,-1
ffffffffc0201ee2:	00d92023          	sw	a3,0(s2)
        if (page_ref(page) ==
ffffffffc0201ee6:	c691                	beqz	a3,ffffffffc0201ef2 <page_insert+0xc0>
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc0201ee8:	12098073          	sfence.vma	s3
}
ffffffffc0201eec:	b741                	j	ffffffffc0201e6c <page_insert+0x3a>
ffffffffc0201eee:	c014                	sw	a3,0(s0)
    return page->ref;
ffffffffc0201ef0:	bfb5                	j	ffffffffc0201e6c <page_insert+0x3a>
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0201ef2:	100027f3          	csrr	a5,sstatus
ffffffffc0201ef6:	8b89                	andi	a5,a5,2
ffffffffc0201ef8:	ef91                	bnez	a5,ffffffffc0201f14 <page_insert+0xe2>
        pmm_manager->free_pages(base, n);
ffffffffc0201efa:	00013797          	auipc	a5,0x13
ffffffffc0201efe:	59e7b783          	ld	a5,1438(a5) # ffffffffc0215498 <pmm_manager>
ffffffffc0201f02:	739c                	ld	a5,32(a5)
ffffffffc0201f04:	4585                	li	a1,1
ffffffffc0201f06:	854a                	mv	a0,s2
ffffffffc0201f08:	9782                	jalr	a5
    return page - pages + nbase;
ffffffffc0201f0a:	000ab783          	ld	a5,0(s5)
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc0201f0e:	12098073          	sfence.vma	s3
ffffffffc0201f12:	bfa9                	j	ffffffffc0201e6c <page_insert+0x3a>
        intr_disable();
ffffffffc0201f14:	e7afe0ef          	jal	ra,ffffffffc020058e <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc0201f18:	00013797          	auipc	a5,0x13
ffffffffc0201f1c:	5807b783          	ld	a5,1408(a5) # ffffffffc0215498 <pmm_manager>
ffffffffc0201f20:	739c                	ld	a5,32(a5)
ffffffffc0201f22:	4585                	li	a1,1
ffffffffc0201f24:	854a                	mv	a0,s2
ffffffffc0201f26:	9782                	jalr	a5
        intr_enable();
ffffffffc0201f28:	e60fe0ef          	jal	ra,ffffffffc0200588 <intr_enable>
ffffffffc0201f2c:	000ab783          	ld	a5,0(s5)
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc0201f30:	12098073          	sfence.vma	s3
ffffffffc0201f34:	bf25                	j	ffffffffc0201e6c <page_insert+0x3a>
        return -E_NO_MEM;
ffffffffc0201f36:	5571                	li	a0,-4
ffffffffc0201f38:	bfb9                	j	ffffffffc0201e96 <page_insert+0x64>
ffffffffc0201f3a:	ac3ff0ef          	jal	ra,ffffffffc02019fc <pa2page.part.0>

ffffffffc0201f3e <pmm_init>:
    pmm_manager = &default_pmm_manager;
ffffffffc0201f3e:	00003797          	auipc	a5,0x3
ffffffffc0201f42:	fe278793          	addi	a5,a5,-30 # ffffffffc0204f20 <default_pmm_manager>
    cprintf("memory management: %s\n", pmm_manager->name);
ffffffffc0201f46:	638c                	ld	a1,0(a5)
void pmm_init(void) {
ffffffffc0201f48:	7159                	addi	sp,sp,-112
ffffffffc0201f4a:	f45e                	sd	s7,40(sp)
    cprintf("memory management: %s\n", pmm_manager->name);
ffffffffc0201f4c:	00003517          	auipc	a0,0x3
ffffffffc0201f50:	13450513          	addi	a0,a0,308 # ffffffffc0205080 <default_pmm_manager+0x160>
    pmm_manager = &default_pmm_manager;
ffffffffc0201f54:	00013b97          	auipc	s7,0x13
ffffffffc0201f58:	544b8b93          	addi	s7,s7,1348 # ffffffffc0215498 <pmm_manager>
void pmm_init(void) {
ffffffffc0201f5c:	f486                	sd	ra,104(sp)
ffffffffc0201f5e:	eca6                	sd	s1,88(sp)
ffffffffc0201f60:	e4ce                	sd	s3,72(sp)
ffffffffc0201f62:	f85a                	sd	s6,48(sp)
    pmm_manager = &default_pmm_manager;
ffffffffc0201f64:	00fbb023          	sd	a5,0(s7)
void pmm_init(void) {
ffffffffc0201f68:	f0a2                	sd	s0,96(sp)
ffffffffc0201f6a:	e8ca                	sd	s2,80(sp)
ffffffffc0201f6c:	e0d2                	sd	s4,64(sp)
ffffffffc0201f6e:	fc56                	sd	s5,56(sp)
ffffffffc0201f70:	f062                	sd	s8,32(sp)
ffffffffc0201f72:	ec66                	sd	s9,24(sp)
ffffffffc0201f74:	e86a                	sd	s10,16(sp)
    cprintf("memory management: %s\n", pmm_manager->name);
ffffffffc0201f76:	a06fe0ef          	jal	ra,ffffffffc020017c <cprintf>
    pmm_manager->init();
ffffffffc0201f7a:	000bb783          	ld	a5,0(s7)
    va_pa_offset = KERNBASE - 0x80200000;
ffffffffc0201f7e:	00013997          	auipc	s3,0x13
ffffffffc0201f82:	52298993          	addi	s3,s3,1314 # ffffffffc02154a0 <va_pa_offset>
    npage = maxpa / PGSIZE;
ffffffffc0201f86:	00013497          	auipc	s1,0x13
ffffffffc0201f8a:	50248493          	addi	s1,s1,1282 # ffffffffc0215488 <npage>
    pmm_manager->init();
ffffffffc0201f8e:	679c                	ld	a5,8(a5)
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
ffffffffc0201f90:	00013b17          	auipc	s6,0x13
ffffffffc0201f94:	500b0b13          	addi	s6,s6,1280 # ffffffffc0215490 <pages>
    pmm_manager->init();
ffffffffc0201f98:	9782                	jalr	a5
    va_pa_offset = KERNBASE - 0x80200000;
ffffffffc0201f9a:	57f5                	li	a5,-3
ffffffffc0201f9c:	07fa                	slli	a5,a5,0x1e
    cprintf("physcial memory map:\n");
ffffffffc0201f9e:	00003517          	auipc	a0,0x3
ffffffffc0201fa2:	0fa50513          	addi	a0,a0,250 # ffffffffc0205098 <default_pmm_manager+0x178>
    va_pa_offset = KERNBASE - 0x80200000;
ffffffffc0201fa6:	00f9b023          	sd	a5,0(s3)
    cprintf("physcial memory map:\n");
ffffffffc0201faa:	9d2fe0ef          	jal	ra,ffffffffc020017c <cprintf>
    cprintf("  memory: 0x%08lx, [0x%08lx, 0x%08lx].\n", mem_size, mem_begin,
ffffffffc0201fae:	46c5                	li	a3,17
ffffffffc0201fb0:	06ee                	slli	a3,a3,0x1b
ffffffffc0201fb2:	40100613          	li	a2,1025
ffffffffc0201fb6:	16fd                	addi	a3,a3,-1
ffffffffc0201fb8:	07e005b7          	lui	a1,0x7e00
ffffffffc0201fbc:	0656                	slli	a2,a2,0x15
ffffffffc0201fbe:	00003517          	auipc	a0,0x3
ffffffffc0201fc2:	0f250513          	addi	a0,a0,242 # ffffffffc02050b0 <default_pmm_manager+0x190>
ffffffffc0201fc6:	9b6fe0ef          	jal	ra,ffffffffc020017c <cprintf>
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
ffffffffc0201fca:	777d                	lui	a4,0xfffff
ffffffffc0201fcc:	00014797          	auipc	a5,0x14
ffffffffc0201fd0:	51f78793          	addi	a5,a5,1311 # ffffffffc02164eb <end+0xfff>
ffffffffc0201fd4:	8ff9                	and	a5,a5,a4
    npage = maxpa / PGSIZE;
ffffffffc0201fd6:	00088737          	lui	a4,0x88
ffffffffc0201fda:	e098                	sd	a4,0(s1)
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
ffffffffc0201fdc:	00fb3023          	sd	a5,0(s6)
ffffffffc0201fe0:	4681                	li	a3,0
    for (size_t i = 0; i < npage - nbase; i++) {
ffffffffc0201fe2:	4701                	li	a4,0
ffffffffc0201fe4:	4585                	li	a1,1
ffffffffc0201fe6:	fff80837          	lui	a6,0xfff80
ffffffffc0201fea:	a019                	j	ffffffffc0201ff0 <pmm_init+0xb2>
        SetPageReserved(pages + i);
ffffffffc0201fec:	000b3783          	ld	a5,0(s6)
ffffffffc0201ff0:	97b6                	add	a5,a5,a3
ffffffffc0201ff2:	07a1                	addi	a5,a5,8
ffffffffc0201ff4:	40b7b02f          	amoor.d	zero,a1,(a5)
    for (size_t i = 0; i < npage - nbase; i++) {
ffffffffc0201ff8:	609c                	ld	a5,0(s1)
ffffffffc0201ffa:	0705                	addi	a4,a4,1
ffffffffc0201ffc:	04868693          	addi	a3,a3,72
ffffffffc0202000:	01078633          	add	a2,a5,a6
ffffffffc0202004:	fec764e3          	bltu	a4,a2,ffffffffc0201fec <pmm_init+0xae>
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc0202008:	000b3503          	ld	a0,0(s6)
ffffffffc020200c:	00379693          	slli	a3,a5,0x3
ffffffffc0202010:	96be                	add	a3,a3,a5
ffffffffc0202012:	fdc00737          	lui	a4,0xfdc00
ffffffffc0202016:	972a                	add	a4,a4,a0
ffffffffc0202018:	068e                	slli	a3,a3,0x3
ffffffffc020201a:	96ba                	add	a3,a3,a4
ffffffffc020201c:	c0200737          	lui	a4,0xc0200
ffffffffc0202020:	66e6e163          	bltu	a3,a4,ffffffffc0202682 <pmm_init+0x744>
ffffffffc0202024:	0009b583          	ld	a1,0(s3)
    if (freemem < mem_end) {
ffffffffc0202028:	4645                	li	a2,17
ffffffffc020202a:	066e                	slli	a2,a2,0x1b
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc020202c:	8e8d                	sub	a3,a3,a1
    if (freemem < mem_end) {
ffffffffc020202e:	4ec6ee63          	bltu	a3,a2,ffffffffc020252a <pmm_init+0x5ec>
    cprintf("vapaofset is %llu\n",va_pa_offset);
ffffffffc0202032:	00003517          	auipc	a0,0x3
ffffffffc0202036:	0a650513          	addi	a0,a0,166 # ffffffffc02050d8 <default_pmm_manager+0x1b8>
ffffffffc020203a:	942fe0ef          	jal	ra,ffffffffc020017c <cprintf>

    return page;
}

static void check_alloc_page(void) {
    pmm_manager->check();
ffffffffc020203e:	000bb783          	ld	a5,0(s7)
    boot_pgdir = (pte_t*)boot_page_table_sv39;
ffffffffc0202042:	00013917          	auipc	s2,0x13
ffffffffc0202046:	43e90913          	addi	s2,s2,1086 # ffffffffc0215480 <boot_pgdir>
    pmm_manager->check();
ffffffffc020204a:	7b9c                	ld	a5,48(a5)
ffffffffc020204c:	9782                	jalr	a5
    cprintf("check_alloc_page() succeeded!\n");
ffffffffc020204e:	00003517          	auipc	a0,0x3
ffffffffc0202052:	0a250513          	addi	a0,a0,162 # ffffffffc02050f0 <default_pmm_manager+0x1d0>
ffffffffc0202056:	926fe0ef          	jal	ra,ffffffffc020017c <cprintf>
    boot_pgdir = (pte_t*)boot_page_table_sv39;
ffffffffc020205a:	00007697          	auipc	a3,0x7
ffffffffc020205e:	fa668693          	addi	a3,a3,-90 # ffffffffc0209000 <boot_page_table_sv39>
ffffffffc0202062:	00d93023          	sd	a3,0(s2)
    boot_cr3 = PADDR(boot_pgdir);
ffffffffc0202066:	c02007b7          	lui	a5,0xc0200
ffffffffc020206a:	62f6e863          	bltu	a3,a5,ffffffffc020269a <pmm_init+0x75c>
ffffffffc020206e:	0009b783          	ld	a5,0(s3)
ffffffffc0202072:	8e9d                	sub	a3,a3,a5
ffffffffc0202074:	00013797          	auipc	a5,0x13
ffffffffc0202078:	40d7b223          	sd	a3,1028(a5) # ffffffffc0215478 <boot_cr3>
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc020207c:	100027f3          	csrr	a5,sstatus
ffffffffc0202080:	8b89                	andi	a5,a5,2
ffffffffc0202082:	4c079e63          	bnez	a5,ffffffffc020255e <pmm_init+0x620>
        ret = pmm_manager->nr_free_pages();
ffffffffc0202086:	000bb783          	ld	a5,0(s7)
ffffffffc020208a:	779c                	ld	a5,40(a5)
ffffffffc020208c:	9782                	jalr	a5
ffffffffc020208e:	842a                	mv	s0,a0
    // so npage is always larger than KMEMSIZE / PGSIZE
    size_t nr_free_store;

    nr_free_store=nr_free_pages();

    assert(npage <= KERNTOP / PGSIZE);
ffffffffc0202090:	6098                	ld	a4,0(s1)
ffffffffc0202092:	c80007b7          	lui	a5,0xc8000
ffffffffc0202096:	83b1                	srli	a5,a5,0xc
ffffffffc0202098:	62e7ed63          	bltu	a5,a4,ffffffffc02026d2 <pmm_init+0x794>
    assert(boot_pgdir != NULL && (uint32_t)PGOFF(boot_pgdir) == 0);
ffffffffc020209c:	00093503          	ld	a0,0(s2)
ffffffffc02020a0:	60050963          	beqz	a0,ffffffffc02026b2 <pmm_init+0x774>
ffffffffc02020a4:	03451793          	slli	a5,a0,0x34
ffffffffc02020a8:	60079563          	bnez	a5,ffffffffc02026b2 <pmm_init+0x774>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
ffffffffc02020ac:	4601                	li	a2,0
ffffffffc02020ae:	4581                	li	a1,0
ffffffffc02020b0:	c87ff0ef          	jal	ra,ffffffffc0201d36 <get_page>
ffffffffc02020b4:	68051163          	bnez	a0,ffffffffc0202736 <pmm_init+0x7f8>

    struct Page *p1, *p2;
    p1 = alloc_page();
ffffffffc02020b8:	4505                	li	a0,1
ffffffffc02020ba:	97bff0ef          	jal	ra,ffffffffc0201a34 <alloc_pages>
ffffffffc02020be:	8a2a                	mv	s4,a0
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
ffffffffc02020c0:	00093503          	ld	a0,0(s2)
ffffffffc02020c4:	4681                	li	a3,0
ffffffffc02020c6:	4601                	li	a2,0
ffffffffc02020c8:	85d2                	mv	a1,s4
ffffffffc02020ca:	d69ff0ef          	jal	ra,ffffffffc0201e32 <page_insert>
ffffffffc02020ce:	64051463          	bnez	a0,ffffffffc0202716 <pmm_init+0x7d8>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
ffffffffc02020d2:	00093503          	ld	a0,0(s2)
ffffffffc02020d6:	4601                	li	a2,0
ffffffffc02020d8:	4581                	li	a1,0
ffffffffc02020da:	a67ff0ef          	jal	ra,ffffffffc0201b40 <get_pte>
ffffffffc02020de:	60050c63          	beqz	a0,ffffffffc02026f6 <pmm_init+0x7b8>
    assert(pte2page(*ptep) == p1);
ffffffffc02020e2:	611c                	ld	a5,0(a0)
    if (!(pte & PTE_V)) {
ffffffffc02020e4:	0017f713          	andi	a4,a5,1
ffffffffc02020e8:	60070563          	beqz	a4,ffffffffc02026f2 <pmm_init+0x7b4>
    if (PPN(pa) >= npage) {
ffffffffc02020ec:	6090                	ld	a2,0(s1)
    return pa2page(PTE_ADDR(pte));
ffffffffc02020ee:	078a                	slli	a5,a5,0x2
ffffffffc02020f0:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage) {
ffffffffc02020f2:	58c7f663          	bgeu	a5,a2,ffffffffc020267e <pmm_init+0x740>
    return &pages[PPN(pa) - nbase];
ffffffffc02020f6:	fff80737          	lui	a4,0xfff80
ffffffffc02020fa:	97ba                	add	a5,a5,a4
ffffffffc02020fc:	000b3683          	ld	a3,0(s6)
ffffffffc0202100:	00379713          	slli	a4,a5,0x3
ffffffffc0202104:	97ba                	add	a5,a5,a4
ffffffffc0202106:	078e                	slli	a5,a5,0x3
ffffffffc0202108:	97b6                	add	a5,a5,a3
ffffffffc020210a:	14fa1fe3          	bne	s4,a5,ffffffffc0202a68 <pmm_init+0xb2a>
    assert(page_ref(p1) == 1);
ffffffffc020210e:	000a2703          	lw	a4,0(s4)
ffffffffc0202112:	4785                	li	a5,1
ffffffffc0202114:	18f716e3          	bne	a4,a5,ffffffffc0202aa0 <pmm_init+0xb62>

    ptep = (pte_t *)KADDR(PDE_ADDR(boot_pgdir[0]));
ffffffffc0202118:	00093503          	ld	a0,0(s2)
ffffffffc020211c:	77fd                	lui	a5,0xfffff
ffffffffc020211e:	6114                	ld	a3,0(a0)
ffffffffc0202120:	068a                	slli	a3,a3,0x2
ffffffffc0202122:	8efd                	and	a3,a3,a5
ffffffffc0202124:	00c6d713          	srli	a4,a3,0xc
ffffffffc0202128:	16c770e3          	bgeu	a4,a2,ffffffffc0202a88 <pmm_init+0xb4a>
ffffffffc020212c:	0009bc03          	ld	s8,0(s3)
    ptep = (pte_t *)KADDR(PDE_ADDR(ptep[0])) + 1;
ffffffffc0202130:	96e2                	add	a3,a3,s8
ffffffffc0202132:	0006ba83          	ld	s5,0(a3)
ffffffffc0202136:	0a8a                	slli	s5,s5,0x2
ffffffffc0202138:	00fafab3          	and	s5,s5,a5
ffffffffc020213c:	00cad793          	srli	a5,s5,0xc
ffffffffc0202140:	66c7fb63          	bgeu	a5,a2,ffffffffc02027b6 <pmm_init+0x878>
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
ffffffffc0202144:	4601                	li	a2,0
ffffffffc0202146:	6585                	lui	a1,0x1
    ptep = (pte_t *)KADDR(PDE_ADDR(ptep[0])) + 1;
ffffffffc0202148:	9ae2                	add	s5,s5,s8
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
ffffffffc020214a:	9f7ff0ef          	jal	ra,ffffffffc0201b40 <get_pte>
    ptep = (pte_t *)KADDR(PDE_ADDR(ptep[0])) + 1;
ffffffffc020214e:	0aa1                	addi	s5,s5,8
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
ffffffffc0202150:	65551363          	bne	a0,s5,ffffffffc0202796 <pmm_init+0x858>

    p2 = alloc_page();
ffffffffc0202154:	4505                	li	a0,1
ffffffffc0202156:	8dfff0ef          	jal	ra,ffffffffc0201a34 <alloc_pages>
ffffffffc020215a:	8aaa                	mv	s5,a0
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
ffffffffc020215c:	00093503          	ld	a0,0(s2)
ffffffffc0202160:	46d1                	li	a3,20
ffffffffc0202162:	6605                	lui	a2,0x1
ffffffffc0202164:	85d6                	mv	a1,s5
ffffffffc0202166:	ccdff0ef          	jal	ra,ffffffffc0201e32 <page_insert>
ffffffffc020216a:	5e051663          	bnez	a0,ffffffffc0202756 <pmm_init+0x818>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
ffffffffc020216e:	00093503          	ld	a0,0(s2)
ffffffffc0202172:	4601                	li	a2,0
ffffffffc0202174:	6585                	lui	a1,0x1
ffffffffc0202176:	9cbff0ef          	jal	ra,ffffffffc0201b40 <get_pte>
ffffffffc020217a:	140503e3          	beqz	a0,ffffffffc0202ac0 <pmm_init+0xb82>
    assert(*ptep & PTE_U);
ffffffffc020217e:	611c                	ld	a5,0(a0)
ffffffffc0202180:	0107f713          	andi	a4,a5,16
ffffffffc0202184:	74070663          	beqz	a4,ffffffffc02028d0 <pmm_init+0x992>
    assert(*ptep & PTE_W);
ffffffffc0202188:	8b91                	andi	a5,a5,4
ffffffffc020218a:	70078363          	beqz	a5,ffffffffc0202890 <pmm_init+0x952>
    assert(boot_pgdir[0] & PTE_U);
ffffffffc020218e:	00093503          	ld	a0,0(s2)
ffffffffc0202192:	611c                	ld	a5,0(a0)
ffffffffc0202194:	8bc1                	andi	a5,a5,16
ffffffffc0202196:	6c078d63          	beqz	a5,ffffffffc0202870 <pmm_init+0x932>
    assert(page_ref(p2) == 1);
ffffffffc020219a:	000aa703          	lw	a4,0(s5)
ffffffffc020219e:	4785                	li	a5,1
ffffffffc02021a0:	5cf71b63          	bne	a4,a5,ffffffffc0202776 <pmm_init+0x838>

    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
ffffffffc02021a4:	4681                	li	a3,0
ffffffffc02021a6:	6605                	lui	a2,0x1
ffffffffc02021a8:	85d2                	mv	a1,s4
ffffffffc02021aa:	c89ff0ef          	jal	ra,ffffffffc0201e32 <page_insert>
ffffffffc02021ae:	68051163          	bnez	a0,ffffffffc0202830 <pmm_init+0x8f2>
    assert(page_ref(p1) == 2);
ffffffffc02021b2:	000a2703          	lw	a4,0(s4)
ffffffffc02021b6:	4789                	li	a5,2
ffffffffc02021b8:	64f71c63          	bne	a4,a5,ffffffffc0202810 <pmm_init+0x8d2>
    assert(page_ref(p2) == 0);
ffffffffc02021bc:	000aa783          	lw	a5,0(s5)
ffffffffc02021c0:	62079863          	bnez	a5,ffffffffc02027f0 <pmm_init+0x8b2>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
ffffffffc02021c4:	00093503          	ld	a0,0(s2)
ffffffffc02021c8:	4601                	li	a2,0
ffffffffc02021ca:	6585                	lui	a1,0x1
ffffffffc02021cc:	975ff0ef          	jal	ra,ffffffffc0201b40 <get_pte>
ffffffffc02021d0:	60050063          	beqz	a0,ffffffffc02027d0 <pmm_init+0x892>
    assert(pte2page(*ptep) == p1);
ffffffffc02021d4:	6118                	ld	a4,0(a0)
    if (!(pte & PTE_V)) {
ffffffffc02021d6:	00177793          	andi	a5,a4,1
ffffffffc02021da:	50078c63          	beqz	a5,ffffffffc02026f2 <pmm_init+0x7b4>
    if (PPN(pa) >= npage) {
ffffffffc02021de:	6094                	ld	a3,0(s1)
    return pa2page(PTE_ADDR(pte));
ffffffffc02021e0:	00271793          	slli	a5,a4,0x2
ffffffffc02021e4:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage) {
ffffffffc02021e6:	48d7fc63          	bgeu	a5,a3,ffffffffc020267e <pmm_init+0x740>
    return &pages[PPN(pa) - nbase];
ffffffffc02021ea:	fff806b7          	lui	a3,0xfff80
ffffffffc02021ee:	97b6                	add	a5,a5,a3
ffffffffc02021f0:	000b3603          	ld	a2,0(s6)
ffffffffc02021f4:	00379693          	slli	a3,a5,0x3
ffffffffc02021f8:	97b6                	add	a5,a5,a3
ffffffffc02021fa:	078e                	slli	a5,a5,0x3
ffffffffc02021fc:	97b2                	add	a5,a5,a2
ffffffffc02021fe:	72fa1963          	bne	s4,a5,ffffffffc0202930 <pmm_init+0x9f2>
    assert((*ptep & PTE_U) == 0);
ffffffffc0202202:	8b41                	andi	a4,a4,16
ffffffffc0202204:	70071663          	bnez	a4,ffffffffc0202910 <pmm_init+0x9d2>

    page_remove(boot_pgdir, 0x0);
ffffffffc0202208:	00093503          	ld	a0,0(s2)
ffffffffc020220c:	4581                	li	a1,0
ffffffffc020220e:	b83ff0ef          	jal	ra,ffffffffc0201d90 <page_remove>
    assert(page_ref(p1) == 1);
ffffffffc0202212:	000a2703          	lw	a4,0(s4)
ffffffffc0202216:	4785                	li	a5,1
ffffffffc0202218:	6cf71c63          	bne	a4,a5,ffffffffc02028f0 <pmm_init+0x9b2>
    assert(page_ref(p2) == 0);
ffffffffc020221c:	000aa783          	lw	a5,0(s5)
ffffffffc0202220:	7a079463          	bnez	a5,ffffffffc02029c8 <pmm_init+0xa8a>

    page_remove(boot_pgdir, PGSIZE);
ffffffffc0202224:	00093503          	ld	a0,0(s2)
ffffffffc0202228:	6585                	lui	a1,0x1
ffffffffc020222a:	b67ff0ef          	jal	ra,ffffffffc0201d90 <page_remove>
    assert(page_ref(p1) == 0);
ffffffffc020222e:	000a2783          	lw	a5,0(s4)
ffffffffc0202232:	76079b63          	bnez	a5,ffffffffc02029a8 <pmm_init+0xa6a>
    assert(page_ref(p2) == 0);
ffffffffc0202236:	000aa783          	lw	a5,0(s5)
ffffffffc020223a:	74079763          	bnez	a5,ffffffffc0202988 <pmm_init+0xa4a>

    assert(page_ref(pde2page(boot_pgdir[0])) == 1);
ffffffffc020223e:	00093a03          	ld	s4,0(s2)
    if (PPN(pa) >= npage) {
ffffffffc0202242:	6090                	ld	a2,0(s1)
    return pa2page(PDE_ADDR(pde));
ffffffffc0202244:	000a3783          	ld	a5,0(s4)
ffffffffc0202248:	078a                	slli	a5,a5,0x2
ffffffffc020224a:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage) {
ffffffffc020224c:	42c7f963          	bgeu	a5,a2,ffffffffc020267e <pmm_init+0x740>
    return &pages[PPN(pa) - nbase];
ffffffffc0202250:	fff80737          	lui	a4,0xfff80
ffffffffc0202254:	973e                	add	a4,a4,a5
ffffffffc0202256:	00371793          	slli	a5,a4,0x3
ffffffffc020225a:	000b3503          	ld	a0,0(s6)
ffffffffc020225e:	97ba                	add	a5,a5,a4
ffffffffc0202260:	078e                	slli	a5,a5,0x3
    return page->ref;
ffffffffc0202262:	00f50733          	add	a4,a0,a5
ffffffffc0202266:	4314                	lw	a3,0(a4)
ffffffffc0202268:	4705                	li	a4,1
ffffffffc020226a:	6ee69f63          	bne	a3,a4,ffffffffc0202968 <pmm_init+0xa2a>
    return page - pages + nbase;
ffffffffc020226e:	4037d693          	srai	a3,a5,0x3
ffffffffc0202272:	00004c97          	auipc	s9,0x4
ffffffffc0202276:	dc6cbc83          	ld	s9,-570(s9) # ffffffffc0206038 <error_string+0x38>
ffffffffc020227a:	039686b3          	mul	a3,a3,s9
ffffffffc020227e:	000805b7          	lui	a1,0x80
ffffffffc0202282:	96ae                	add	a3,a3,a1
    return KADDR(page2pa(page));
ffffffffc0202284:	00c69713          	slli	a4,a3,0xc
ffffffffc0202288:	8331                	srli	a4,a4,0xc
    return page2ppn(page) << PGSHIFT;
ffffffffc020228a:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc020228c:	6cc77263          	bgeu	a4,a2,ffffffffc0202950 <pmm_init+0xa12>

    pde_t *pd1=boot_pgdir,*pd0=page2kva(pde2page(boot_pgdir[0]));
    free_page(pde2page(pd0[0]));
ffffffffc0202290:	0009b703          	ld	a4,0(s3)
ffffffffc0202294:	96ba                	add	a3,a3,a4
    return pa2page(PDE_ADDR(pde));
ffffffffc0202296:	629c                	ld	a5,0(a3)
ffffffffc0202298:	078a                	slli	a5,a5,0x2
ffffffffc020229a:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage) {
ffffffffc020229c:	3ec7f163          	bgeu	a5,a2,ffffffffc020267e <pmm_init+0x740>
    return &pages[PPN(pa) - nbase];
ffffffffc02022a0:	8f8d                	sub	a5,a5,a1
ffffffffc02022a2:	00379713          	slli	a4,a5,0x3
ffffffffc02022a6:	97ba                	add	a5,a5,a4
ffffffffc02022a8:	078e                	slli	a5,a5,0x3
ffffffffc02022aa:	953e                	add	a0,a0,a5
ffffffffc02022ac:	100027f3          	csrr	a5,sstatus
ffffffffc02022b0:	8b89                	andi	a5,a5,2
ffffffffc02022b2:	30079063          	bnez	a5,ffffffffc02025b2 <pmm_init+0x674>
        pmm_manager->free_pages(base, n);
ffffffffc02022b6:	000bb783          	ld	a5,0(s7)
ffffffffc02022ba:	4585                	li	a1,1
ffffffffc02022bc:	739c                	ld	a5,32(a5)
ffffffffc02022be:	9782                	jalr	a5
    return pa2page(PDE_ADDR(pde));
ffffffffc02022c0:	000a3783          	ld	a5,0(s4)
    if (PPN(pa) >= npage) {
ffffffffc02022c4:	6098                	ld	a4,0(s1)
    return pa2page(PDE_ADDR(pde));
ffffffffc02022c6:	078a                	slli	a5,a5,0x2
ffffffffc02022c8:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage) {
ffffffffc02022ca:	3ae7fa63          	bgeu	a5,a4,ffffffffc020267e <pmm_init+0x740>
    return &pages[PPN(pa) - nbase];
ffffffffc02022ce:	fff80737          	lui	a4,0xfff80
ffffffffc02022d2:	97ba                	add	a5,a5,a4
ffffffffc02022d4:	000b3503          	ld	a0,0(s6)
ffffffffc02022d8:	00379713          	slli	a4,a5,0x3
ffffffffc02022dc:	97ba                	add	a5,a5,a4
ffffffffc02022de:	078e                	slli	a5,a5,0x3
ffffffffc02022e0:	953e                	add	a0,a0,a5
ffffffffc02022e2:	100027f3          	csrr	a5,sstatus
ffffffffc02022e6:	8b89                	andi	a5,a5,2
ffffffffc02022e8:	2a079963          	bnez	a5,ffffffffc020259a <pmm_init+0x65c>
ffffffffc02022ec:	000bb783          	ld	a5,0(s7)
ffffffffc02022f0:	4585                	li	a1,1
ffffffffc02022f2:	739c                	ld	a5,32(a5)
ffffffffc02022f4:	9782                	jalr	a5
    free_page(pde2page(pd1[0]));
    boot_pgdir[0] = 0;
ffffffffc02022f6:	00093783          	ld	a5,0(s2)
ffffffffc02022fa:	0007b023          	sd	zero,0(a5) # fffffffffffff000 <end+0x3fde9b14>
  asm volatile("sfence.vma");
ffffffffc02022fe:	12000073          	sfence.vma
ffffffffc0202302:	100027f3          	csrr	a5,sstatus
ffffffffc0202306:	8b89                	andi	a5,a5,2
ffffffffc0202308:	26079f63          	bnez	a5,ffffffffc0202586 <pmm_init+0x648>
        ret = pmm_manager->nr_free_pages();
ffffffffc020230c:	000bb783          	ld	a5,0(s7)
ffffffffc0202310:	779c                	ld	a5,40(a5)
ffffffffc0202312:	9782                	jalr	a5
ffffffffc0202314:	8a2a                	mv	s4,a0
    flush_tlb();

    assert(nr_free_store==nr_free_pages());
ffffffffc0202316:	73441963          	bne	s0,s4,ffffffffc0202a48 <pmm_init+0xb0a>

    cprintf("check_pgdir() succeeded!\n");
ffffffffc020231a:	00003517          	auipc	a0,0x3
ffffffffc020231e:	0be50513          	addi	a0,a0,190 # ffffffffc02053d8 <default_pmm_manager+0x4b8>
ffffffffc0202322:	e5bfd0ef          	jal	ra,ffffffffc020017c <cprintf>
ffffffffc0202326:	100027f3          	csrr	a5,sstatus
ffffffffc020232a:	8b89                	andi	a5,a5,2
ffffffffc020232c:	24079363          	bnez	a5,ffffffffc0202572 <pmm_init+0x634>
        ret = pmm_manager->nr_free_pages();
ffffffffc0202330:	000bb783          	ld	a5,0(s7)
ffffffffc0202334:	779c                	ld	a5,40(a5)
ffffffffc0202336:	9782                	jalr	a5
ffffffffc0202338:	8c2a                	mv	s8,a0
    pte_t *ptep;
    int i;

    nr_free_store=nr_free_pages();

    for (i = ROUNDDOWN(KERNBASE, PGSIZE); i < npage * PGSIZE; i += PGSIZE) {
ffffffffc020233a:	6098                	ld	a4,0(s1)
ffffffffc020233c:	c0200437          	lui	s0,0xc0200
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
        assert(PTE_ADDR(*ptep) == i);
ffffffffc0202340:	7afd                	lui	s5,0xfffff
    for (i = ROUNDDOWN(KERNBASE, PGSIZE); i < npage * PGSIZE; i += PGSIZE) {
ffffffffc0202342:	00c71793          	slli	a5,a4,0xc
ffffffffc0202346:	6a05                	lui	s4,0x1
ffffffffc0202348:	02f47c63          	bgeu	s0,a5,ffffffffc0202380 <pmm_init+0x442>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
ffffffffc020234c:	00c45793          	srli	a5,s0,0xc
ffffffffc0202350:	00093503          	ld	a0,0(s2)
ffffffffc0202354:	30e7f863          	bgeu	a5,a4,ffffffffc0202664 <pmm_init+0x726>
ffffffffc0202358:	0009b583          	ld	a1,0(s3)
ffffffffc020235c:	4601                	li	a2,0
ffffffffc020235e:	95a2                	add	a1,a1,s0
ffffffffc0202360:	fe0ff0ef          	jal	ra,ffffffffc0201b40 <get_pte>
ffffffffc0202364:	2e050063          	beqz	a0,ffffffffc0202644 <pmm_init+0x706>
        assert(PTE_ADDR(*ptep) == i);
ffffffffc0202368:	611c                	ld	a5,0(a0)
ffffffffc020236a:	078a                	slli	a5,a5,0x2
ffffffffc020236c:	0157f7b3          	and	a5,a5,s5
ffffffffc0202370:	2a879a63          	bne	a5,s0,ffffffffc0202624 <pmm_init+0x6e6>
    for (i = ROUNDDOWN(KERNBASE, PGSIZE); i < npage * PGSIZE; i += PGSIZE) {
ffffffffc0202374:	6098                	ld	a4,0(s1)
ffffffffc0202376:	9452                	add	s0,s0,s4
ffffffffc0202378:	00c71793          	slli	a5,a4,0xc
ffffffffc020237c:	fcf468e3          	bltu	s0,a5,ffffffffc020234c <pmm_init+0x40e>
    }

    assert(boot_pgdir[0] == 0);
ffffffffc0202380:	00093783          	ld	a5,0(s2)
ffffffffc0202384:	639c                	ld	a5,0(a5)
ffffffffc0202386:	6a079163          	bnez	a5,ffffffffc0202a28 <pmm_init+0xaea>

    struct Page *p;
    p = alloc_page();
ffffffffc020238a:	4505                	li	a0,1
ffffffffc020238c:	ea8ff0ef          	jal	ra,ffffffffc0201a34 <alloc_pages>
ffffffffc0202390:	8aaa                	mv	s5,a0
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W | PTE_R) == 0);
ffffffffc0202392:	00093503          	ld	a0,0(s2)
ffffffffc0202396:	4699                	li	a3,6
ffffffffc0202398:	10000613          	li	a2,256
ffffffffc020239c:	85d6                	mv	a1,s5
ffffffffc020239e:	a95ff0ef          	jal	ra,ffffffffc0201e32 <page_insert>
ffffffffc02023a2:	66051363          	bnez	a0,ffffffffc0202a08 <pmm_init+0xaca>
    assert(page_ref(p) == 1);
ffffffffc02023a6:	000aa703          	lw	a4,0(s5) # fffffffffffff000 <end+0x3fde9b14>
ffffffffc02023aa:	4785                	li	a5,1
ffffffffc02023ac:	62f71e63          	bne	a4,a5,ffffffffc02029e8 <pmm_init+0xaaa>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W | PTE_R) == 0);
ffffffffc02023b0:	00093503          	ld	a0,0(s2)
ffffffffc02023b4:	6405                	lui	s0,0x1
ffffffffc02023b6:	4699                	li	a3,6
ffffffffc02023b8:	10040613          	addi	a2,s0,256 # 1100 <kern_entry-0xffffffffc01fef00>
ffffffffc02023bc:	85d6                	mv	a1,s5
ffffffffc02023be:	a75ff0ef          	jal	ra,ffffffffc0201e32 <page_insert>
ffffffffc02023c2:	48051763          	bnez	a0,ffffffffc0202850 <pmm_init+0x912>
    assert(page_ref(p) == 2);
ffffffffc02023c6:	000aa703          	lw	a4,0(s5)
ffffffffc02023ca:	4789                	li	a5,2
ffffffffc02023cc:	74f71a63          	bne	a4,a5,ffffffffc0202b20 <pmm_init+0xbe2>

    const char *str = "ucore: Hello world!!";
    strcpy((void *)0x100, str);
ffffffffc02023d0:	00003597          	auipc	a1,0x3
ffffffffc02023d4:	14058593          	addi	a1,a1,320 # ffffffffc0205510 <default_pmm_manager+0x5f0>
ffffffffc02023d8:	10000513          	li	a0,256
ffffffffc02023dc:	55d010ef          	jal	ra,ffffffffc0204138 <strcpy>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
ffffffffc02023e0:	10040593          	addi	a1,s0,256
ffffffffc02023e4:	10000513          	li	a0,256
ffffffffc02023e8:	563010ef          	jal	ra,ffffffffc020414a <strcmp>
ffffffffc02023ec:	70051a63          	bnez	a0,ffffffffc0202b00 <pmm_init+0xbc2>
    return page - pages + nbase;
ffffffffc02023f0:	000b3683          	ld	a3,0(s6)
ffffffffc02023f4:	00080d37          	lui	s10,0x80
    return KADDR(page2pa(page));
ffffffffc02023f8:	547d                	li	s0,-1
    return page - pages + nbase;
ffffffffc02023fa:	40da86b3          	sub	a3,s5,a3
ffffffffc02023fe:	868d                	srai	a3,a3,0x3
ffffffffc0202400:	039686b3          	mul	a3,a3,s9
    return KADDR(page2pa(page));
ffffffffc0202404:	609c                	ld	a5,0(s1)
ffffffffc0202406:	8031                	srli	s0,s0,0xc
    return page - pages + nbase;
ffffffffc0202408:	96ea                	add	a3,a3,s10
    return KADDR(page2pa(page));
ffffffffc020240a:	0086f733          	and	a4,a3,s0
    return page2ppn(page) << PGSHIFT;
ffffffffc020240e:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0202410:	54f77063          	bgeu	a4,a5,ffffffffc0202950 <pmm_init+0xa12>

    *(char *)(page2kva(p) + 0x100) = '\0';
ffffffffc0202414:	0009b783          	ld	a5,0(s3)
    assert(strlen((const char *)0x100) == 0);
ffffffffc0202418:	10000513          	li	a0,256
    *(char *)(page2kva(p) + 0x100) = '\0';
ffffffffc020241c:	96be                	add	a3,a3,a5
ffffffffc020241e:	10068023          	sb	zero,256(a3) # fffffffffff80100 <end+0x3fd6ac14>
    assert(strlen((const char *)0x100) == 0);
ffffffffc0202422:	4e1010ef          	jal	ra,ffffffffc0204102 <strlen>
ffffffffc0202426:	6a051d63          	bnez	a0,ffffffffc0202ae0 <pmm_init+0xba2>

    pde_t *pd1=boot_pgdir,*pd0=page2kva(pde2page(boot_pgdir[0]));
ffffffffc020242a:	00093a03          	ld	s4,0(s2)
    if (PPN(pa) >= npage) {
ffffffffc020242e:	6098                	ld	a4,0(s1)
    return pa2page(PDE_ADDR(pde));
ffffffffc0202430:	000a3783          	ld	a5,0(s4) # 1000 <kern_entry-0xffffffffc01ff000>
ffffffffc0202434:	078a                	slli	a5,a5,0x2
ffffffffc0202436:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage) {
ffffffffc0202438:	24e7f363          	bgeu	a5,a4,ffffffffc020267e <pmm_init+0x740>
    return &pages[PPN(pa) - nbase];
ffffffffc020243c:	41a787b3          	sub	a5,a5,s10
ffffffffc0202440:	00379693          	slli	a3,a5,0x3
    return page - pages + nbase;
ffffffffc0202444:	96be                	add	a3,a3,a5
ffffffffc0202446:	03968cb3          	mul	s9,a3,s9
ffffffffc020244a:	01ac86b3          	add	a3,s9,s10
    return KADDR(page2pa(page));
ffffffffc020244e:	8c75                	and	s0,s0,a3
    return page2ppn(page) << PGSHIFT;
ffffffffc0202450:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0202452:	4ee47f63          	bgeu	s0,a4,ffffffffc0202950 <pmm_init+0xa12>
ffffffffc0202456:	0009b403          	ld	s0,0(s3)
ffffffffc020245a:	9436                	add	s0,s0,a3
ffffffffc020245c:	100027f3          	csrr	a5,sstatus
ffffffffc0202460:	8b89                	andi	a5,a5,2
ffffffffc0202462:	1a079663          	bnez	a5,ffffffffc020260e <pmm_init+0x6d0>
        pmm_manager->free_pages(base, n);
ffffffffc0202466:	000bb783          	ld	a5,0(s7)
ffffffffc020246a:	4585                	li	a1,1
ffffffffc020246c:	8556                	mv	a0,s5
ffffffffc020246e:	739c                	ld	a5,32(a5)
ffffffffc0202470:	9782                	jalr	a5
    return pa2page(PDE_ADDR(pde));
ffffffffc0202472:	601c                	ld	a5,0(s0)
    if (PPN(pa) >= npage) {
ffffffffc0202474:	6098                	ld	a4,0(s1)
    return pa2page(PDE_ADDR(pde));
ffffffffc0202476:	078a                	slli	a5,a5,0x2
ffffffffc0202478:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage) {
ffffffffc020247a:	20e7f263          	bgeu	a5,a4,ffffffffc020267e <pmm_init+0x740>
    return &pages[PPN(pa) - nbase];
ffffffffc020247e:	fff80737          	lui	a4,0xfff80
ffffffffc0202482:	97ba                	add	a5,a5,a4
ffffffffc0202484:	000b3503          	ld	a0,0(s6)
ffffffffc0202488:	00379713          	slli	a4,a5,0x3
ffffffffc020248c:	97ba                	add	a5,a5,a4
ffffffffc020248e:	078e                	slli	a5,a5,0x3
ffffffffc0202490:	953e                	add	a0,a0,a5
ffffffffc0202492:	100027f3          	csrr	a5,sstatus
ffffffffc0202496:	8b89                	andi	a5,a5,2
ffffffffc0202498:	14079f63          	bnez	a5,ffffffffc02025f6 <pmm_init+0x6b8>
ffffffffc020249c:	000bb783          	ld	a5,0(s7)
ffffffffc02024a0:	4585                	li	a1,1
ffffffffc02024a2:	739c                	ld	a5,32(a5)
ffffffffc02024a4:	9782                	jalr	a5
    return pa2page(PDE_ADDR(pde));
ffffffffc02024a6:	000a3783          	ld	a5,0(s4)
    if (PPN(pa) >= npage) {
ffffffffc02024aa:	6098                	ld	a4,0(s1)
    return pa2page(PDE_ADDR(pde));
ffffffffc02024ac:	078a                	slli	a5,a5,0x2
ffffffffc02024ae:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage) {
ffffffffc02024b0:	1ce7f763          	bgeu	a5,a4,ffffffffc020267e <pmm_init+0x740>
    return &pages[PPN(pa) - nbase];
ffffffffc02024b4:	fff80737          	lui	a4,0xfff80
ffffffffc02024b8:	97ba                	add	a5,a5,a4
ffffffffc02024ba:	000b3503          	ld	a0,0(s6)
ffffffffc02024be:	00379713          	slli	a4,a5,0x3
ffffffffc02024c2:	97ba                	add	a5,a5,a4
ffffffffc02024c4:	078e                	slli	a5,a5,0x3
ffffffffc02024c6:	953e                	add	a0,a0,a5
ffffffffc02024c8:	100027f3          	csrr	a5,sstatus
ffffffffc02024cc:	8b89                	andi	a5,a5,2
ffffffffc02024ce:	10079863          	bnez	a5,ffffffffc02025de <pmm_init+0x6a0>
ffffffffc02024d2:	000bb783          	ld	a5,0(s7)
ffffffffc02024d6:	4585                	li	a1,1
ffffffffc02024d8:	739c                	ld	a5,32(a5)
ffffffffc02024da:	9782                	jalr	a5
    free_page(p);
    free_page(pde2page(pd0[0]));
    free_page(pde2page(pd1[0]));
    boot_pgdir[0] = 0;
ffffffffc02024dc:	00093783          	ld	a5,0(s2)
ffffffffc02024e0:	0007b023          	sd	zero,0(a5)
  asm volatile("sfence.vma");
ffffffffc02024e4:	12000073          	sfence.vma
ffffffffc02024e8:	100027f3          	csrr	a5,sstatus
ffffffffc02024ec:	8b89                	andi	a5,a5,2
ffffffffc02024ee:	0c079e63          	bnez	a5,ffffffffc02025ca <pmm_init+0x68c>
        ret = pmm_manager->nr_free_pages();
ffffffffc02024f2:	000bb783          	ld	a5,0(s7)
ffffffffc02024f6:	779c                	ld	a5,40(a5)
ffffffffc02024f8:	9782                	jalr	a5
ffffffffc02024fa:	842a                	mv	s0,a0
    flush_tlb();

    assert(nr_free_store==nr_free_pages());
ffffffffc02024fc:	3a8c1a63          	bne	s8,s0,ffffffffc02028b0 <pmm_init+0x972>

    cprintf("check_boot_pgdir() succeeded!\n");
ffffffffc0202500:	00003517          	auipc	a0,0x3
ffffffffc0202504:	08850513          	addi	a0,a0,136 # ffffffffc0205588 <default_pmm_manager+0x668>
ffffffffc0202508:	c75fd0ef          	jal	ra,ffffffffc020017c <cprintf>
}
ffffffffc020250c:	7406                	ld	s0,96(sp)
ffffffffc020250e:	70a6                	ld	ra,104(sp)
ffffffffc0202510:	64e6                	ld	s1,88(sp)
ffffffffc0202512:	6946                	ld	s2,80(sp)
ffffffffc0202514:	69a6                	ld	s3,72(sp)
ffffffffc0202516:	6a06                	ld	s4,64(sp)
ffffffffc0202518:	7ae2                	ld	s5,56(sp)
ffffffffc020251a:	7b42                	ld	s6,48(sp)
ffffffffc020251c:	7ba2                	ld	s7,40(sp)
ffffffffc020251e:	7c02                	ld	s8,32(sp)
ffffffffc0202520:	6ce2                	ld	s9,24(sp)
ffffffffc0202522:	6d42                	ld	s10,16(sp)
ffffffffc0202524:	6165                	addi	sp,sp,112
    kmalloc_init();
ffffffffc0202526:	b0aff06f          	j	ffffffffc0201830 <kmalloc_init>
    mem_begin = ROUNDUP(freemem, PGSIZE);
ffffffffc020252a:	6705                	lui	a4,0x1
ffffffffc020252c:	177d                	addi	a4,a4,-1
ffffffffc020252e:	96ba                	add	a3,a3,a4
ffffffffc0202530:	777d                	lui	a4,0xfffff
ffffffffc0202532:	8f75                	and	a4,a4,a3
    if (PPN(pa) >= npage) {
ffffffffc0202534:	00c75693          	srli	a3,a4,0xc
ffffffffc0202538:	14f6f363          	bgeu	a3,a5,ffffffffc020267e <pmm_init+0x740>
    pmm_manager->init_memmap(base, n);
ffffffffc020253c:	000bb583          	ld	a1,0(s7)
    return &pages[PPN(pa) - nbase];
ffffffffc0202540:	9836                	add	a6,a6,a3
ffffffffc0202542:	00381793          	slli	a5,a6,0x3
ffffffffc0202546:	6994                	ld	a3,16(a1)
ffffffffc0202548:	97c2                	add	a5,a5,a6
        init_memmap(pa2page(mem_begin), (mem_end - mem_begin) / PGSIZE);
ffffffffc020254a:	40e60733          	sub	a4,a2,a4
ffffffffc020254e:	078e                	slli	a5,a5,0x3
    pmm_manager->init_memmap(base, n);
ffffffffc0202550:	00c75593          	srli	a1,a4,0xc
ffffffffc0202554:	953e                	add	a0,a0,a5
ffffffffc0202556:	9682                	jalr	a3
    cprintf("vapaofset is %llu\n",va_pa_offset);
ffffffffc0202558:	0009b583          	ld	a1,0(s3)
}
ffffffffc020255c:	bcd9                	j	ffffffffc0202032 <pmm_init+0xf4>
        intr_disable();
ffffffffc020255e:	830fe0ef          	jal	ra,ffffffffc020058e <intr_disable>
        ret = pmm_manager->nr_free_pages();
ffffffffc0202562:	000bb783          	ld	a5,0(s7)
ffffffffc0202566:	779c                	ld	a5,40(a5)
ffffffffc0202568:	9782                	jalr	a5
ffffffffc020256a:	842a                	mv	s0,a0
        intr_enable();
ffffffffc020256c:	81cfe0ef          	jal	ra,ffffffffc0200588 <intr_enable>
ffffffffc0202570:	b605                	j	ffffffffc0202090 <pmm_init+0x152>
        intr_disable();
ffffffffc0202572:	81cfe0ef          	jal	ra,ffffffffc020058e <intr_disable>
ffffffffc0202576:	000bb783          	ld	a5,0(s7)
ffffffffc020257a:	779c                	ld	a5,40(a5)
ffffffffc020257c:	9782                	jalr	a5
ffffffffc020257e:	8c2a                	mv	s8,a0
        intr_enable();
ffffffffc0202580:	808fe0ef          	jal	ra,ffffffffc0200588 <intr_enable>
ffffffffc0202584:	bb5d                	j	ffffffffc020233a <pmm_init+0x3fc>
        intr_disable();
ffffffffc0202586:	808fe0ef          	jal	ra,ffffffffc020058e <intr_disable>
ffffffffc020258a:	000bb783          	ld	a5,0(s7)
ffffffffc020258e:	779c                	ld	a5,40(a5)
ffffffffc0202590:	9782                	jalr	a5
ffffffffc0202592:	8a2a                	mv	s4,a0
        intr_enable();
ffffffffc0202594:	ff5fd0ef          	jal	ra,ffffffffc0200588 <intr_enable>
ffffffffc0202598:	bbbd                	j	ffffffffc0202316 <pmm_init+0x3d8>
ffffffffc020259a:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc020259c:	ff3fd0ef          	jal	ra,ffffffffc020058e <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc02025a0:	000bb783          	ld	a5,0(s7)
ffffffffc02025a4:	6522                	ld	a0,8(sp)
ffffffffc02025a6:	4585                	li	a1,1
ffffffffc02025a8:	739c                	ld	a5,32(a5)
ffffffffc02025aa:	9782                	jalr	a5
        intr_enable();
ffffffffc02025ac:	fddfd0ef          	jal	ra,ffffffffc0200588 <intr_enable>
ffffffffc02025b0:	b399                	j	ffffffffc02022f6 <pmm_init+0x3b8>
ffffffffc02025b2:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc02025b4:	fdbfd0ef          	jal	ra,ffffffffc020058e <intr_disable>
ffffffffc02025b8:	000bb783          	ld	a5,0(s7)
ffffffffc02025bc:	6522                	ld	a0,8(sp)
ffffffffc02025be:	4585                	li	a1,1
ffffffffc02025c0:	739c                	ld	a5,32(a5)
ffffffffc02025c2:	9782                	jalr	a5
        intr_enable();
ffffffffc02025c4:	fc5fd0ef          	jal	ra,ffffffffc0200588 <intr_enable>
ffffffffc02025c8:	b9e5                	j	ffffffffc02022c0 <pmm_init+0x382>
        intr_disable();
ffffffffc02025ca:	fc5fd0ef          	jal	ra,ffffffffc020058e <intr_disable>
        ret = pmm_manager->nr_free_pages();
ffffffffc02025ce:	000bb783          	ld	a5,0(s7)
ffffffffc02025d2:	779c                	ld	a5,40(a5)
ffffffffc02025d4:	9782                	jalr	a5
ffffffffc02025d6:	842a                	mv	s0,a0
        intr_enable();
ffffffffc02025d8:	fb1fd0ef          	jal	ra,ffffffffc0200588 <intr_enable>
ffffffffc02025dc:	b705                	j	ffffffffc02024fc <pmm_init+0x5be>
ffffffffc02025de:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc02025e0:	faffd0ef          	jal	ra,ffffffffc020058e <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc02025e4:	000bb783          	ld	a5,0(s7)
ffffffffc02025e8:	6522                	ld	a0,8(sp)
ffffffffc02025ea:	4585                	li	a1,1
ffffffffc02025ec:	739c                	ld	a5,32(a5)
ffffffffc02025ee:	9782                	jalr	a5
        intr_enable();
ffffffffc02025f0:	f99fd0ef          	jal	ra,ffffffffc0200588 <intr_enable>
ffffffffc02025f4:	b5e5                	j	ffffffffc02024dc <pmm_init+0x59e>
ffffffffc02025f6:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc02025f8:	f97fd0ef          	jal	ra,ffffffffc020058e <intr_disable>
ffffffffc02025fc:	000bb783          	ld	a5,0(s7)
ffffffffc0202600:	6522                	ld	a0,8(sp)
ffffffffc0202602:	4585                	li	a1,1
ffffffffc0202604:	739c                	ld	a5,32(a5)
ffffffffc0202606:	9782                	jalr	a5
        intr_enable();
ffffffffc0202608:	f81fd0ef          	jal	ra,ffffffffc0200588 <intr_enable>
ffffffffc020260c:	bd69                	j	ffffffffc02024a6 <pmm_init+0x568>
        intr_disable();
ffffffffc020260e:	f81fd0ef          	jal	ra,ffffffffc020058e <intr_disable>
ffffffffc0202612:	000bb783          	ld	a5,0(s7)
ffffffffc0202616:	4585                	li	a1,1
ffffffffc0202618:	8556                	mv	a0,s5
ffffffffc020261a:	739c                	ld	a5,32(a5)
ffffffffc020261c:	9782                	jalr	a5
        intr_enable();
ffffffffc020261e:	f6bfd0ef          	jal	ra,ffffffffc0200588 <intr_enable>
ffffffffc0202622:	bd81                	j	ffffffffc0202472 <pmm_init+0x534>
        assert(PTE_ADDR(*ptep) == i);
ffffffffc0202624:	00003697          	auipc	a3,0x3
ffffffffc0202628:	e1468693          	addi	a3,a3,-492 # ffffffffc0205438 <default_pmm_manager+0x518>
ffffffffc020262c:	00002617          	auipc	a2,0x2
ffffffffc0202630:	54460613          	addi	a2,a2,1348 # ffffffffc0204b70 <commands+0x738>
ffffffffc0202634:	19e00593          	li	a1,414
ffffffffc0202638:	00003517          	auipc	a0,0x3
ffffffffc020263c:	a3850513          	addi	a0,a0,-1480 # ffffffffc0205070 <default_pmm_manager+0x150>
ffffffffc0202640:	e03fd0ef          	jal	ra,ffffffffc0200442 <__panic>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
ffffffffc0202644:	00003697          	auipc	a3,0x3
ffffffffc0202648:	db468693          	addi	a3,a3,-588 # ffffffffc02053f8 <default_pmm_manager+0x4d8>
ffffffffc020264c:	00002617          	auipc	a2,0x2
ffffffffc0202650:	52460613          	addi	a2,a2,1316 # ffffffffc0204b70 <commands+0x738>
ffffffffc0202654:	19d00593          	li	a1,413
ffffffffc0202658:	00003517          	auipc	a0,0x3
ffffffffc020265c:	a1850513          	addi	a0,a0,-1512 # ffffffffc0205070 <default_pmm_manager+0x150>
ffffffffc0202660:	de3fd0ef          	jal	ra,ffffffffc0200442 <__panic>
ffffffffc0202664:	86a2                	mv	a3,s0
ffffffffc0202666:	00003617          	auipc	a2,0x3
ffffffffc020266a:	8f260613          	addi	a2,a2,-1806 # ffffffffc0204f58 <default_pmm_manager+0x38>
ffffffffc020266e:	19d00593          	li	a1,413
ffffffffc0202672:	00003517          	auipc	a0,0x3
ffffffffc0202676:	9fe50513          	addi	a0,a0,-1538 # ffffffffc0205070 <default_pmm_manager+0x150>
ffffffffc020267a:	dc9fd0ef          	jal	ra,ffffffffc0200442 <__panic>
ffffffffc020267e:	b7eff0ef          	jal	ra,ffffffffc02019fc <pa2page.part.0>
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc0202682:	00003617          	auipc	a2,0x3
ffffffffc0202686:	97e60613          	addi	a2,a2,-1666 # ffffffffc0205000 <default_pmm_manager+0xe0>
ffffffffc020268a:	07f00593          	li	a1,127
ffffffffc020268e:	00003517          	auipc	a0,0x3
ffffffffc0202692:	9e250513          	addi	a0,a0,-1566 # ffffffffc0205070 <default_pmm_manager+0x150>
ffffffffc0202696:	dadfd0ef          	jal	ra,ffffffffc0200442 <__panic>
    boot_cr3 = PADDR(boot_pgdir);
ffffffffc020269a:	00003617          	auipc	a2,0x3
ffffffffc020269e:	96660613          	addi	a2,a2,-1690 # ffffffffc0205000 <default_pmm_manager+0xe0>
ffffffffc02026a2:	0c300593          	li	a1,195
ffffffffc02026a6:	00003517          	auipc	a0,0x3
ffffffffc02026aa:	9ca50513          	addi	a0,a0,-1590 # ffffffffc0205070 <default_pmm_manager+0x150>
ffffffffc02026ae:	d95fd0ef          	jal	ra,ffffffffc0200442 <__panic>
    assert(boot_pgdir != NULL && (uint32_t)PGOFF(boot_pgdir) == 0);
ffffffffc02026b2:	00003697          	auipc	a3,0x3
ffffffffc02026b6:	a7e68693          	addi	a3,a3,-1410 # ffffffffc0205130 <default_pmm_manager+0x210>
ffffffffc02026ba:	00002617          	auipc	a2,0x2
ffffffffc02026be:	4b660613          	addi	a2,a2,1206 # ffffffffc0204b70 <commands+0x738>
ffffffffc02026c2:	16100593          	li	a1,353
ffffffffc02026c6:	00003517          	auipc	a0,0x3
ffffffffc02026ca:	9aa50513          	addi	a0,a0,-1622 # ffffffffc0205070 <default_pmm_manager+0x150>
ffffffffc02026ce:	d75fd0ef          	jal	ra,ffffffffc0200442 <__panic>
    assert(npage <= KERNTOP / PGSIZE);
ffffffffc02026d2:	00003697          	auipc	a3,0x3
ffffffffc02026d6:	a3e68693          	addi	a3,a3,-1474 # ffffffffc0205110 <default_pmm_manager+0x1f0>
ffffffffc02026da:	00002617          	auipc	a2,0x2
ffffffffc02026de:	49660613          	addi	a2,a2,1174 # ffffffffc0204b70 <commands+0x738>
ffffffffc02026e2:	16000593          	li	a1,352
ffffffffc02026e6:	00003517          	auipc	a0,0x3
ffffffffc02026ea:	98a50513          	addi	a0,a0,-1654 # ffffffffc0205070 <default_pmm_manager+0x150>
ffffffffc02026ee:	d55fd0ef          	jal	ra,ffffffffc0200442 <__panic>
ffffffffc02026f2:	b26ff0ef          	jal	ra,ffffffffc0201a18 <pte2page.part.0>
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
ffffffffc02026f6:	00003697          	auipc	a3,0x3
ffffffffc02026fa:	aca68693          	addi	a3,a3,-1334 # ffffffffc02051c0 <default_pmm_manager+0x2a0>
ffffffffc02026fe:	00002617          	auipc	a2,0x2
ffffffffc0202702:	47260613          	addi	a2,a2,1138 # ffffffffc0204b70 <commands+0x738>
ffffffffc0202706:	16900593          	li	a1,361
ffffffffc020270a:	00003517          	auipc	a0,0x3
ffffffffc020270e:	96650513          	addi	a0,a0,-1690 # ffffffffc0205070 <default_pmm_manager+0x150>
ffffffffc0202712:	d31fd0ef          	jal	ra,ffffffffc0200442 <__panic>
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
ffffffffc0202716:	00003697          	auipc	a3,0x3
ffffffffc020271a:	a7a68693          	addi	a3,a3,-1414 # ffffffffc0205190 <default_pmm_manager+0x270>
ffffffffc020271e:	00002617          	auipc	a2,0x2
ffffffffc0202722:	45260613          	addi	a2,a2,1106 # ffffffffc0204b70 <commands+0x738>
ffffffffc0202726:	16600593          	li	a1,358
ffffffffc020272a:	00003517          	auipc	a0,0x3
ffffffffc020272e:	94650513          	addi	a0,a0,-1722 # ffffffffc0205070 <default_pmm_manager+0x150>
ffffffffc0202732:	d11fd0ef          	jal	ra,ffffffffc0200442 <__panic>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
ffffffffc0202736:	00003697          	auipc	a3,0x3
ffffffffc020273a:	a3268693          	addi	a3,a3,-1486 # ffffffffc0205168 <default_pmm_manager+0x248>
ffffffffc020273e:	00002617          	auipc	a2,0x2
ffffffffc0202742:	43260613          	addi	a2,a2,1074 # ffffffffc0204b70 <commands+0x738>
ffffffffc0202746:	16200593          	li	a1,354
ffffffffc020274a:	00003517          	auipc	a0,0x3
ffffffffc020274e:	92650513          	addi	a0,a0,-1754 # ffffffffc0205070 <default_pmm_manager+0x150>
ffffffffc0202752:	cf1fd0ef          	jal	ra,ffffffffc0200442 <__panic>
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
ffffffffc0202756:	00003697          	auipc	a3,0x3
ffffffffc020275a:	af268693          	addi	a3,a3,-1294 # ffffffffc0205248 <default_pmm_manager+0x328>
ffffffffc020275e:	00002617          	auipc	a2,0x2
ffffffffc0202762:	41260613          	addi	a2,a2,1042 # ffffffffc0204b70 <commands+0x738>
ffffffffc0202766:	17200593          	li	a1,370
ffffffffc020276a:	00003517          	auipc	a0,0x3
ffffffffc020276e:	90650513          	addi	a0,a0,-1786 # ffffffffc0205070 <default_pmm_manager+0x150>
ffffffffc0202772:	cd1fd0ef          	jal	ra,ffffffffc0200442 <__panic>
    assert(page_ref(p2) == 1);
ffffffffc0202776:	00003697          	auipc	a3,0x3
ffffffffc020277a:	b7268693          	addi	a3,a3,-1166 # ffffffffc02052e8 <default_pmm_manager+0x3c8>
ffffffffc020277e:	00002617          	auipc	a2,0x2
ffffffffc0202782:	3f260613          	addi	a2,a2,1010 # ffffffffc0204b70 <commands+0x738>
ffffffffc0202786:	17700593          	li	a1,375
ffffffffc020278a:	00003517          	auipc	a0,0x3
ffffffffc020278e:	8e650513          	addi	a0,a0,-1818 # ffffffffc0205070 <default_pmm_manager+0x150>
ffffffffc0202792:	cb1fd0ef          	jal	ra,ffffffffc0200442 <__panic>
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
ffffffffc0202796:	00003697          	auipc	a3,0x3
ffffffffc020279a:	a8a68693          	addi	a3,a3,-1398 # ffffffffc0205220 <default_pmm_manager+0x300>
ffffffffc020279e:	00002617          	auipc	a2,0x2
ffffffffc02027a2:	3d260613          	addi	a2,a2,978 # ffffffffc0204b70 <commands+0x738>
ffffffffc02027a6:	16f00593          	li	a1,367
ffffffffc02027aa:	00003517          	auipc	a0,0x3
ffffffffc02027ae:	8c650513          	addi	a0,a0,-1850 # ffffffffc0205070 <default_pmm_manager+0x150>
ffffffffc02027b2:	c91fd0ef          	jal	ra,ffffffffc0200442 <__panic>
    ptep = (pte_t *)KADDR(PDE_ADDR(ptep[0])) + 1;
ffffffffc02027b6:	86d6                	mv	a3,s5
ffffffffc02027b8:	00002617          	auipc	a2,0x2
ffffffffc02027bc:	7a060613          	addi	a2,a2,1952 # ffffffffc0204f58 <default_pmm_manager+0x38>
ffffffffc02027c0:	16e00593          	li	a1,366
ffffffffc02027c4:	00003517          	auipc	a0,0x3
ffffffffc02027c8:	8ac50513          	addi	a0,a0,-1876 # ffffffffc0205070 <default_pmm_manager+0x150>
ffffffffc02027cc:	c77fd0ef          	jal	ra,ffffffffc0200442 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
ffffffffc02027d0:	00003697          	auipc	a3,0x3
ffffffffc02027d4:	ab068693          	addi	a3,a3,-1360 # ffffffffc0205280 <default_pmm_manager+0x360>
ffffffffc02027d8:	00002617          	auipc	a2,0x2
ffffffffc02027dc:	39860613          	addi	a2,a2,920 # ffffffffc0204b70 <commands+0x738>
ffffffffc02027e0:	17c00593          	li	a1,380
ffffffffc02027e4:	00003517          	auipc	a0,0x3
ffffffffc02027e8:	88c50513          	addi	a0,a0,-1908 # ffffffffc0205070 <default_pmm_manager+0x150>
ffffffffc02027ec:	c57fd0ef          	jal	ra,ffffffffc0200442 <__panic>
    assert(page_ref(p2) == 0);
ffffffffc02027f0:	00003697          	auipc	a3,0x3
ffffffffc02027f4:	b5868693          	addi	a3,a3,-1192 # ffffffffc0205348 <default_pmm_manager+0x428>
ffffffffc02027f8:	00002617          	auipc	a2,0x2
ffffffffc02027fc:	37860613          	addi	a2,a2,888 # ffffffffc0204b70 <commands+0x738>
ffffffffc0202800:	17b00593          	li	a1,379
ffffffffc0202804:	00003517          	auipc	a0,0x3
ffffffffc0202808:	86c50513          	addi	a0,a0,-1940 # ffffffffc0205070 <default_pmm_manager+0x150>
ffffffffc020280c:	c37fd0ef          	jal	ra,ffffffffc0200442 <__panic>
    assert(page_ref(p1) == 2);
ffffffffc0202810:	00003697          	auipc	a3,0x3
ffffffffc0202814:	b2068693          	addi	a3,a3,-1248 # ffffffffc0205330 <default_pmm_manager+0x410>
ffffffffc0202818:	00002617          	auipc	a2,0x2
ffffffffc020281c:	35860613          	addi	a2,a2,856 # ffffffffc0204b70 <commands+0x738>
ffffffffc0202820:	17a00593          	li	a1,378
ffffffffc0202824:	00003517          	auipc	a0,0x3
ffffffffc0202828:	84c50513          	addi	a0,a0,-1972 # ffffffffc0205070 <default_pmm_manager+0x150>
ffffffffc020282c:	c17fd0ef          	jal	ra,ffffffffc0200442 <__panic>
    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
ffffffffc0202830:	00003697          	auipc	a3,0x3
ffffffffc0202834:	ad068693          	addi	a3,a3,-1328 # ffffffffc0205300 <default_pmm_manager+0x3e0>
ffffffffc0202838:	00002617          	auipc	a2,0x2
ffffffffc020283c:	33860613          	addi	a2,a2,824 # ffffffffc0204b70 <commands+0x738>
ffffffffc0202840:	17900593          	li	a1,377
ffffffffc0202844:	00003517          	auipc	a0,0x3
ffffffffc0202848:	82c50513          	addi	a0,a0,-2004 # ffffffffc0205070 <default_pmm_manager+0x150>
ffffffffc020284c:	bf7fd0ef          	jal	ra,ffffffffc0200442 <__panic>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W | PTE_R) == 0);
ffffffffc0202850:	00003697          	auipc	a3,0x3
ffffffffc0202854:	c6868693          	addi	a3,a3,-920 # ffffffffc02054b8 <default_pmm_manager+0x598>
ffffffffc0202858:	00002617          	auipc	a2,0x2
ffffffffc020285c:	31860613          	addi	a2,a2,792 # ffffffffc0204b70 <commands+0x738>
ffffffffc0202860:	1a700593          	li	a1,423
ffffffffc0202864:	00003517          	auipc	a0,0x3
ffffffffc0202868:	80c50513          	addi	a0,a0,-2036 # ffffffffc0205070 <default_pmm_manager+0x150>
ffffffffc020286c:	bd7fd0ef          	jal	ra,ffffffffc0200442 <__panic>
    assert(boot_pgdir[0] & PTE_U);
ffffffffc0202870:	00003697          	auipc	a3,0x3
ffffffffc0202874:	a6068693          	addi	a3,a3,-1440 # ffffffffc02052d0 <default_pmm_manager+0x3b0>
ffffffffc0202878:	00002617          	auipc	a2,0x2
ffffffffc020287c:	2f860613          	addi	a2,a2,760 # ffffffffc0204b70 <commands+0x738>
ffffffffc0202880:	17600593          	li	a1,374
ffffffffc0202884:	00002517          	auipc	a0,0x2
ffffffffc0202888:	7ec50513          	addi	a0,a0,2028 # ffffffffc0205070 <default_pmm_manager+0x150>
ffffffffc020288c:	bb7fd0ef          	jal	ra,ffffffffc0200442 <__panic>
    assert(*ptep & PTE_W);
ffffffffc0202890:	00003697          	auipc	a3,0x3
ffffffffc0202894:	a3068693          	addi	a3,a3,-1488 # ffffffffc02052c0 <default_pmm_manager+0x3a0>
ffffffffc0202898:	00002617          	auipc	a2,0x2
ffffffffc020289c:	2d860613          	addi	a2,a2,728 # ffffffffc0204b70 <commands+0x738>
ffffffffc02028a0:	17500593          	li	a1,373
ffffffffc02028a4:	00002517          	auipc	a0,0x2
ffffffffc02028a8:	7cc50513          	addi	a0,a0,1996 # ffffffffc0205070 <default_pmm_manager+0x150>
ffffffffc02028ac:	b97fd0ef          	jal	ra,ffffffffc0200442 <__panic>
    assert(nr_free_store==nr_free_pages());
ffffffffc02028b0:	00003697          	auipc	a3,0x3
ffffffffc02028b4:	b0868693          	addi	a3,a3,-1272 # ffffffffc02053b8 <default_pmm_manager+0x498>
ffffffffc02028b8:	00002617          	auipc	a2,0x2
ffffffffc02028bc:	2b860613          	addi	a2,a2,696 # ffffffffc0204b70 <commands+0x738>
ffffffffc02028c0:	1b800593          	li	a1,440
ffffffffc02028c4:	00002517          	auipc	a0,0x2
ffffffffc02028c8:	7ac50513          	addi	a0,a0,1964 # ffffffffc0205070 <default_pmm_manager+0x150>
ffffffffc02028cc:	b77fd0ef          	jal	ra,ffffffffc0200442 <__panic>
    assert(*ptep & PTE_U);
ffffffffc02028d0:	00003697          	auipc	a3,0x3
ffffffffc02028d4:	9e068693          	addi	a3,a3,-1568 # ffffffffc02052b0 <default_pmm_manager+0x390>
ffffffffc02028d8:	00002617          	auipc	a2,0x2
ffffffffc02028dc:	29860613          	addi	a2,a2,664 # ffffffffc0204b70 <commands+0x738>
ffffffffc02028e0:	17400593          	li	a1,372
ffffffffc02028e4:	00002517          	auipc	a0,0x2
ffffffffc02028e8:	78c50513          	addi	a0,a0,1932 # ffffffffc0205070 <default_pmm_manager+0x150>
ffffffffc02028ec:	b57fd0ef          	jal	ra,ffffffffc0200442 <__panic>
    assert(page_ref(p1) == 1);
ffffffffc02028f0:	00003697          	auipc	a3,0x3
ffffffffc02028f4:	91868693          	addi	a3,a3,-1768 # ffffffffc0205208 <default_pmm_manager+0x2e8>
ffffffffc02028f8:	00002617          	auipc	a2,0x2
ffffffffc02028fc:	27860613          	addi	a2,a2,632 # ffffffffc0204b70 <commands+0x738>
ffffffffc0202900:	18100593          	li	a1,385
ffffffffc0202904:	00002517          	auipc	a0,0x2
ffffffffc0202908:	76c50513          	addi	a0,a0,1900 # ffffffffc0205070 <default_pmm_manager+0x150>
ffffffffc020290c:	b37fd0ef          	jal	ra,ffffffffc0200442 <__panic>
    assert((*ptep & PTE_U) == 0);
ffffffffc0202910:	00003697          	auipc	a3,0x3
ffffffffc0202914:	a5068693          	addi	a3,a3,-1456 # ffffffffc0205360 <default_pmm_manager+0x440>
ffffffffc0202918:	00002617          	auipc	a2,0x2
ffffffffc020291c:	25860613          	addi	a2,a2,600 # ffffffffc0204b70 <commands+0x738>
ffffffffc0202920:	17e00593          	li	a1,382
ffffffffc0202924:	00002517          	auipc	a0,0x2
ffffffffc0202928:	74c50513          	addi	a0,a0,1868 # ffffffffc0205070 <default_pmm_manager+0x150>
ffffffffc020292c:	b17fd0ef          	jal	ra,ffffffffc0200442 <__panic>
    assert(pte2page(*ptep) == p1);
ffffffffc0202930:	00003697          	auipc	a3,0x3
ffffffffc0202934:	8c068693          	addi	a3,a3,-1856 # ffffffffc02051f0 <default_pmm_manager+0x2d0>
ffffffffc0202938:	00002617          	auipc	a2,0x2
ffffffffc020293c:	23860613          	addi	a2,a2,568 # ffffffffc0204b70 <commands+0x738>
ffffffffc0202940:	17d00593          	li	a1,381
ffffffffc0202944:	00002517          	auipc	a0,0x2
ffffffffc0202948:	72c50513          	addi	a0,a0,1836 # ffffffffc0205070 <default_pmm_manager+0x150>
ffffffffc020294c:	af7fd0ef          	jal	ra,ffffffffc0200442 <__panic>
    return KADDR(page2pa(page));
ffffffffc0202950:	00002617          	auipc	a2,0x2
ffffffffc0202954:	60860613          	addi	a2,a2,1544 # ffffffffc0204f58 <default_pmm_manager+0x38>
ffffffffc0202958:	06900593          	li	a1,105
ffffffffc020295c:	00002517          	auipc	a0,0x2
ffffffffc0202960:	62450513          	addi	a0,a0,1572 # ffffffffc0204f80 <default_pmm_manager+0x60>
ffffffffc0202964:	adffd0ef          	jal	ra,ffffffffc0200442 <__panic>
    assert(page_ref(pde2page(boot_pgdir[0])) == 1);
ffffffffc0202968:	00003697          	auipc	a3,0x3
ffffffffc020296c:	a2868693          	addi	a3,a3,-1496 # ffffffffc0205390 <default_pmm_manager+0x470>
ffffffffc0202970:	00002617          	auipc	a2,0x2
ffffffffc0202974:	20060613          	addi	a2,a2,512 # ffffffffc0204b70 <commands+0x738>
ffffffffc0202978:	18800593          	li	a1,392
ffffffffc020297c:	00002517          	auipc	a0,0x2
ffffffffc0202980:	6f450513          	addi	a0,a0,1780 # ffffffffc0205070 <default_pmm_manager+0x150>
ffffffffc0202984:	abffd0ef          	jal	ra,ffffffffc0200442 <__panic>
    assert(page_ref(p2) == 0);
ffffffffc0202988:	00003697          	auipc	a3,0x3
ffffffffc020298c:	9c068693          	addi	a3,a3,-1600 # ffffffffc0205348 <default_pmm_manager+0x428>
ffffffffc0202990:	00002617          	auipc	a2,0x2
ffffffffc0202994:	1e060613          	addi	a2,a2,480 # ffffffffc0204b70 <commands+0x738>
ffffffffc0202998:	18600593          	li	a1,390
ffffffffc020299c:	00002517          	auipc	a0,0x2
ffffffffc02029a0:	6d450513          	addi	a0,a0,1748 # ffffffffc0205070 <default_pmm_manager+0x150>
ffffffffc02029a4:	a9ffd0ef          	jal	ra,ffffffffc0200442 <__panic>
    assert(page_ref(p1) == 0);
ffffffffc02029a8:	00003697          	auipc	a3,0x3
ffffffffc02029ac:	9d068693          	addi	a3,a3,-1584 # ffffffffc0205378 <default_pmm_manager+0x458>
ffffffffc02029b0:	00002617          	auipc	a2,0x2
ffffffffc02029b4:	1c060613          	addi	a2,a2,448 # ffffffffc0204b70 <commands+0x738>
ffffffffc02029b8:	18500593          	li	a1,389
ffffffffc02029bc:	00002517          	auipc	a0,0x2
ffffffffc02029c0:	6b450513          	addi	a0,a0,1716 # ffffffffc0205070 <default_pmm_manager+0x150>
ffffffffc02029c4:	a7ffd0ef          	jal	ra,ffffffffc0200442 <__panic>
    assert(page_ref(p2) == 0);
ffffffffc02029c8:	00003697          	auipc	a3,0x3
ffffffffc02029cc:	98068693          	addi	a3,a3,-1664 # ffffffffc0205348 <default_pmm_manager+0x428>
ffffffffc02029d0:	00002617          	auipc	a2,0x2
ffffffffc02029d4:	1a060613          	addi	a2,a2,416 # ffffffffc0204b70 <commands+0x738>
ffffffffc02029d8:	18200593          	li	a1,386
ffffffffc02029dc:	00002517          	auipc	a0,0x2
ffffffffc02029e0:	69450513          	addi	a0,a0,1684 # ffffffffc0205070 <default_pmm_manager+0x150>
ffffffffc02029e4:	a5ffd0ef          	jal	ra,ffffffffc0200442 <__panic>
    assert(page_ref(p) == 1);
ffffffffc02029e8:	00003697          	auipc	a3,0x3
ffffffffc02029ec:	ab868693          	addi	a3,a3,-1352 # ffffffffc02054a0 <default_pmm_manager+0x580>
ffffffffc02029f0:	00002617          	auipc	a2,0x2
ffffffffc02029f4:	18060613          	addi	a2,a2,384 # ffffffffc0204b70 <commands+0x738>
ffffffffc02029f8:	1a600593          	li	a1,422
ffffffffc02029fc:	00002517          	auipc	a0,0x2
ffffffffc0202a00:	67450513          	addi	a0,a0,1652 # ffffffffc0205070 <default_pmm_manager+0x150>
ffffffffc0202a04:	a3ffd0ef          	jal	ra,ffffffffc0200442 <__panic>
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W | PTE_R) == 0);
ffffffffc0202a08:	00003697          	auipc	a3,0x3
ffffffffc0202a0c:	a6068693          	addi	a3,a3,-1440 # ffffffffc0205468 <default_pmm_manager+0x548>
ffffffffc0202a10:	00002617          	auipc	a2,0x2
ffffffffc0202a14:	16060613          	addi	a2,a2,352 # ffffffffc0204b70 <commands+0x738>
ffffffffc0202a18:	1a500593          	li	a1,421
ffffffffc0202a1c:	00002517          	auipc	a0,0x2
ffffffffc0202a20:	65450513          	addi	a0,a0,1620 # ffffffffc0205070 <default_pmm_manager+0x150>
ffffffffc0202a24:	a1ffd0ef          	jal	ra,ffffffffc0200442 <__panic>
    assert(boot_pgdir[0] == 0);
ffffffffc0202a28:	00003697          	auipc	a3,0x3
ffffffffc0202a2c:	a2868693          	addi	a3,a3,-1496 # ffffffffc0205450 <default_pmm_manager+0x530>
ffffffffc0202a30:	00002617          	auipc	a2,0x2
ffffffffc0202a34:	14060613          	addi	a2,a2,320 # ffffffffc0204b70 <commands+0x738>
ffffffffc0202a38:	1a100593          	li	a1,417
ffffffffc0202a3c:	00002517          	auipc	a0,0x2
ffffffffc0202a40:	63450513          	addi	a0,a0,1588 # ffffffffc0205070 <default_pmm_manager+0x150>
ffffffffc0202a44:	9fffd0ef          	jal	ra,ffffffffc0200442 <__panic>
    assert(nr_free_store==nr_free_pages());
ffffffffc0202a48:	00003697          	auipc	a3,0x3
ffffffffc0202a4c:	97068693          	addi	a3,a3,-1680 # ffffffffc02053b8 <default_pmm_manager+0x498>
ffffffffc0202a50:	00002617          	auipc	a2,0x2
ffffffffc0202a54:	12060613          	addi	a2,a2,288 # ffffffffc0204b70 <commands+0x738>
ffffffffc0202a58:	19000593          	li	a1,400
ffffffffc0202a5c:	00002517          	auipc	a0,0x2
ffffffffc0202a60:	61450513          	addi	a0,a0,1556 # ffffffffc0205070 <default_pmm_manager+0x150>
ffffffffc0202a64:	9dffd0ef          	jal	ra,ffffffffc0200442 <__panic>
    assert(pte2page(*ptep) == p1);
ffffffffc0202a68:	00002697          	auipc	a3,0x2
ffffffffc0202a6c:	78868693          	addi	a3,a3,1928 # ffffffffc02051f0 <default_pmm_manager+0x2d0>
ffffffffc0202a70:	00002617          	auipc	a2,0x2
ffffffffc0202a74:	10060613          	addi	a2,a2,256 # ffffffffc0204b70 <commands+0x738>
ffffffffc0202a78:	16a00593          	li	a1,362
ffffffffc0202a7c:	00002517          	auipc	a0,0x2
ffffffffc0202a80:	5f450513          	addi	a0,a0,1524 # ffffffffc0205070 <default_pmm_manager+0x150>
ffffffffc0202a84:	9bffd0ef          	jal	ra,ffffffffc0200442 <__panic>
    ptep = (pte_t *)KADDR(PDE_ADDR(boot_pgdir[0]));
ffffffffc0202a88:	00002617          	auipc	a2,0x2
ffffffffc0202a8c:	4d060613          	addi	a2,a2,1232 # ffffffffc0204f58 <default_pmm_manager+0x38>
ffffffffc0202a90:	16d00593          	li	a1,365
ffffffffc0202a94:	00002517          	auipc	a0,0x2
ffffffffc0202a98:	5dc50513          	addi	a0,a0,1500 # ffffffffc0205070 <default_pmm_manager+0x150>
ffffffffc0202a9c:	9a7fd0ef          	jal	ra,ffffffffc0200442 <__panic>
    assert(page_ref(p1) == 1);
ffffffffc0202aa0:	00002697          	auipc	a3,0x2
ffffffffc0202aa4:	76868693          	addi	a3,a3,1896 # ffffffffc0205208 <default_pmm_manager+0x2e8>
ffffffffc0202aa8:	00002617          	auipc	a2,0x2
ffffffffc0202aac:	0c860613          	addi	a2,a2,200 # ffffffffc0204b70 <commands+0x738>
ffffffffc0202ab0:	16b00593          	li	a1,363
ffffffffc0202ab4:	00002517          	auipc	a0,0x2
ffffffffc0202ab8:	5bc50513          	addi	a0,a0,1468 # ffffffffc0205070 <default_pmm_manager+0x150>
ffffffffc0202abc:	987fd0ef          	jal	ra,ffffffffc0200442 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
ffffffffc0202ac0:	00002697          	auipc	a3,0x2
ffffffffc0202ac4:	7c068693          	addi	a3,a3,1984 # ffffffffc0205280 <default_pmm_manager+0x360>
ffffffffc0202ac8:	00002617          	auipc	a2,0x2
ffffffffc0202acc:	0a860613          	addi	a2,a2,168 # ffffffffc0204b70 <commands+0x738>
ffffffffc0202ad0:	17300593          	li	a1,371
ffffffffc0202ad4:	00002517          	auipc	a0,0x2
ffffffffc0202ad8:	59c50513          	addi	a0,a0,1436 # ffffffffc0205070 <default_pmm_manager+0x150>
ffffffffc0202adc:	967fd0ef          	jal	ra,ffffffffc0200442 <__panic>
    assert(strlen((const char *)0x100) == 0);
ffffffffc0202ae0:	00003697          	auipc	a3,0x3
ffffffffc0202ae4:	a8068693          	addi	a3,a3,-1408 # ffffffffc0205560 <default_pmm_manager+0x640>
ffffffffc0202ae8:	00002617          	auipc	a2,0x2
ffffffffc0202aec:	08860613          	addi	a2,a2,136 # ffffffffc0204b70 <commands+0x738>
ffffffffc0202af0:	1af00593          	li	a1,431
ffffffffc0202af4:	00002517          	auipc	a0,0x2
ffffffffc0202af8:	57c50513          	addi	a0,a0,1404 # ffffffffc0205070 <default_pmm_manager+0x150>
ffffffffc0202afc:	947fd0ef          	jal	ra,ffffffffc0200442 <__panic>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
ffffffffc0202b00:	00003697          	auipc	a3,0x3
ffffffffc0202b04:	a2868693          	addi	a3,a3,-1496 # ffffffffc0205528 <default_pmm_manager+0x608>
ffffffffc0202b08:	00002617          	auipc	a2,0x2
ffffffffc0202b0c:	06860613          	addi	a2,a2,104 # ffffffffc0204b70 <commands+0x738>
ffffffffc0202b10:	1ac00593          	li	a1,428
ffffffffc0202b14:	00002517          	auipc	a0,0x2
ffffffffc0202b18:	55c50513          	addi	a0,a0,1372 # ffffffffc0205070 <default_pmm_manager+0x150>
ffffffffc0202b1c:	927fd0ef          	jal	ra,ffffffffc0200442 <__panic>
    assert(page_ref(p) == 2);
ffffffffc0202b20:	00003697          	auipc	a3,0x3
ffffffffc0202b24:	9d868693          	addi	a3,a3,-1576 # ffffffffc02054f8 <default_pmm_manager+0x5d8>
ffffffffc0202b28:	00002617          	auipc	a2,0x2
ffffffffc0202b2c:	04860613          	addi	a2,a2,72 # ffffffffc0204b70 <commands+0x738>
ffffffffc0202b30:	1a800593          	li	a1,424
ffffffffc0202b34:	00002517          	auipc	a0,0x2
ffffffffc0202b38:	53c50513          	addi	a0,a0,1340 # ffffffffc0205070 <default_pmm_manager+0x150>
ffffffffc0202b3c:	907fd0ef          	jal	ra,ffffffffc0200442 <__panic>

ffffffffc0202b40 <tlb_invalidate>:
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc0202b40:	12058073          	sfence.vma	a1
}
ffffffffc0202b44:	8082                	ret

ffffffffc0202b46 <pgdir_alloc_page>:
struct Page *pgdir_alloc_page(pde_t *pgdir, uintptr_t la, uint32_t perm) {
ffffffffc0202b46:	7179                	addi	sp,sp,-48
ffffffffc0202b48:	e84a                	sd	s2,16(sp)
ffffffffc0202b4a:	892a                	mv	s2,a0
    struct Page *page = alloc_page();
ffffffffc0202b4c:	4505                	li	a0,1
struct Page *pgdir_alloc_page(pde_t *pgdir, uintptr_t la, uint32_t perm) {
ffffffffc0202b4e:	f022                	sd	s0,32(sp)
ffffffffc0202b50:	ec26                	sd	s1,24(sp)
ffffffffc0202b52:	e44e                	sd	s3,8(sp)
ffffffffc0202b54:	f406                	sd	ra,40(sp)
ffffffffc0202b56:	84ae                	mv	s1,a1
ffffffffc0202b58:	89b2                	mv	s3,a2
    struct Page *page = alloc_page();
ffffffffc0202b5a:	edbfe0ef          	jal	ra,ffffffffc0201a34 <alloc_pages>
ffffffffc0202b5e:	842a                	mv	s0,a0
    if (page != NULL) {
ffffffffc0202b60:	cd09                	beqz	a0,ffffffffc0202b7a <pgdir_alloc_page+0x34>
        if (page_insert(pgdir, page, la, perm) != 0) {
ffffffffc0202b62:	85aa                	mv	a1,a0
ffffffffc0202b64:	86ce                	mv	a3,s3
ffffffffc0202b66:	8626                	mv	a2,s1
ffffffffc0202b68:	854a                	mv	a0,s2
ffffffffc0202b6a:	ac8ff0ef          	jal	ra,ffffffffc0201e32 <page_insert>
ffffffffc0202b6e:	ed21                	bnez	a0,ffffffffc0202bc6 <pgdir_alloc_page+0x80>
        if (swap_init_ok) {
ffffffffc0202b70:	00013797          	auipc	a5,0x13
ffffffffc0202b74:	9487a783          	lw	a5,-1720(a5) # ffffffffc02154b8 <swap_init_ok>
ffffffffc0202b78:	eb89                	bnez	a5,ffffffffc0202b8a <pgdir_alloc_page+0x44>
}
ffffffffc0202b7a:	70a2                	ld	ra,40(sp)
ffffffffc0202b7c:	8522                	mv	a0,s0
ffffffffc0202b7e:	7402                	ld	s0,32(sp)
ffffffffc0202b80:	64e2                	ld	s1,24(sp)
ffffffffc0202b82:	6942                	ld	s2,16(sp)
ffffffffc0202b84:	69a2                	ld	s3,8(sp)
ffffffffc0202b86:	6145                	addi	sp,sp,48
ffffffffc0202b88:	8082                	ret
            swap_map_swappable(check_mm_struct, la, page, 0);
ffffffffc0202b8a:	4681                	li	a3,0
ffffffffc0202b8c:	8622                	mv	a2,s0
ffffffffc0202b8e:	85a6                	mv	a1,s1
ffffffffc0202b90:	00013517          	auipc	a0,0x13
ffffffffc0202b94:	93053503          	ld	a0,-1744(a0) # ffffffffc02154c0 <check_mm_struct>
ffffffffc0202b98:	072000ef          	jal	ra,ffffffffc0202c0a <swap_map_swappable>
            assert(page_ref(page) == 1);
ffffffffc0202b9c:	4018                	lw	a4,0(s0)
            page->pra_vaddr = la;
ffffffffc0202b9e:	e024                	sd	s1,64(s0)
            assert(page_ref(page) == 1);
ffffffffc0202ba0:	4785                	li	a5,1
ffffffffc0202ba2:	fcf70ce3          	beq	a4,a5,ffffffffc0202b7a <pgdir_alloc_page+0x34>
ffffffffc0202ba6:	00003697          	auipc	a3,0x3
ffffffffc0202baa:	a0268693          	addi	a3,a3,-1534 # ffffffffc02055a8 <default_pmm_manager+0x688>
ffffffffc0202bae:	00002617          	auipc	a2,0x2
ffffffffc0202bb2:	fc260613          	addi	a2,a2,-62 # ffffffffc0204b70 <commands+0x738>
ffffffffc0202bb6:	14800593          	li	a1,328
ffffffffc0202bba:	00002517          	auipc	a0,0x2
ffffffffc0202bbe:	4b650513          	addi	a0,a0,1206 # ffffffffc0205070 <default_pmm_manager+0x150>
ffffffffc0202bc2:	881fd0ef          	jal	ra,ffffffffc0200442 <__panic>
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0202bc6:	100027f3          	csrr	a5,sstatus
ffffffffc0202bca:	8b89                	andi	a5,a5,2
ffffffffc0202bcc:	eb99                	bnez	a5,ffffffffc0202be2 <pgdir_alloc_page+0x9c>
        pmm_manager->free_pages(base, n);
ffffffffc0202bce:	00013797          	auipc	a5,0x13
ffffffffc0202bd2:	8ca7b783          	ld	a5,-1846(a5) # ffffffffc0215498 <pmm_manager>
ffffffffc0202bd6:	739c                	ld	a5,32(a5)
ffffffffc0202bd8:	8522                	mv	a0,s0
ffffffffc0202bda:	4585                	li	a1,1
ffffffffc0202bdc:	9782                	jalr	a5
            return NULL;
ffffffffc0202bde:	4401                	li	s0,0
ffffffffc0202be0:	bf69                	j	ffffffffc0202b7a <pgdir_alloc_page+0x34>
        intr_disable();
ffffffffc0202be2:	9adfd0ef          	jal	ra,ffffffffc020058e <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc0202be6:	00013797          	auipc	a5,0x13
ffffffffc0202bea:	8b27b783          	ld	a5,-1870(a5) # ffffffffc0215498 <pmm_manager>
ffffffffc0202bee:	739c                	ld	a5,32(a5)
ffffffffc0202bf0:	8522                	mv	a0,s0
ffffffffc0202bf2:	4585                	li	a1,1
ffffffffc0202bf4:	9782                	jalr	a5
            return NULL;
ffffffffc0202bf6:	4401                	li	s0,0
        intr_enable();
ffffffffc0202bf8:	991fd0ef          	jal	ra,ffffffffc0200588 <intr_enable>
ffffffffc0202bfc:	bfbd                	j	ffffffffc0202b7a <pgdir_alloc_page+0x34>

ffffffffc0202bfe <swap_init_mm>:
}

int
swap_init_mm(struct mm_struct *mm)
{
     return sm->init_mm(mm);
ffffffffc0202bfe:	00013797          	auipc	a5,0x13
ffffffffc0202c02:	8b27b783          	ld	a5,-1870(a5) # ffffffffc02154b0 <sm>
ffffffffc0202c06:	6b9c                	ld	a5,16(a5)
ffffffffc0202c08:	8782                	jr	a5

ffffffffc0202c0a <swap_map_swappable>:
}

int
swap_map_swappable(struct mm_struct *mm, uintptr_t addr, struct Page *page, int swap_in)
{
     return sm->map_swappable(mm, addr, page, swap_in);
ffffffffc0202c0a:	00013797          	auipc	a5,0x13
ffffffffc0202c0e:	8a67b783          	ld	a5,-1882(a5) # ffffffffc02154b0 <sm>
ffffffffc0202c12:	739c                	ld	a5,32(a5)
ffffffffc0202c14:	8782                	jr	a5

ffffffffc0202c16 <swap_out>:

volatile unsigned int swap_out_num=0;

int
swap_out(struct mm_struct *mm, int n, int in_tick)
{
ffffffffc0202c16:	711d                	addi	sp,sp,-96
ffffffffc0202c18:	ec86                	sd	ra,88(sp)
ffffffffc0202c1a:	e8a2                	sd	s0,80(sp)
ffffffffc0202c1c:	e4a6                	sd	s1,72(sp)
ffffffffc0202c1e:	e0ca                	sd	s2,64(sp)
ffffffffc0202c20:	fc4e                	sd	s3,56(sp)
ffffffffc0202c22:	f852                	sd	s4,48(sp)
ffffffffc0202c24:	f456                	sd	s5,40(sp)
ffffffffc0202c26:	f05a                	sd	s6,32(sp)
ffffffffc0202c28:	ec5e                	sd	s7,24(sp)
ffffffffc0202c2a:	e862                	sd	s8,16(sp)
     int i;
     for (i = 0; i != n; ++ i)
ffffffffc0202c2c:	cde9                	beqz	a1,ffffffffc0202d06 <swap_out+0xf0>
ffffffffc0202c2e:	8a2e                	mv	s4,a1
ffffffffc0202c30:	892a                	mv	s2,a0
ffffffffc0202c32:	8ab2                	mv	s5,a2
ffffffffc0202c34:	4401                	li	s0,0
ffffffffc0202c36:	00013997          	auipc	s3,0x13
ffffffffc0202c3a:	87a98993          	addi	s3,s3,-1926 # ffffffffc02154b0 <sm>
                    cprintf("SWAP: failed to save\n");
                    sm->map_swappable(mm, v, page, 0);
                    continue;
          }
          else {
                    cprintf("swap_out: i %d, store page in vaddr 0x%x to disk swap entry %d\n", i, v, page->pra_vaddr/PGSIZE+1);
ffffffffc0202c3e:	00003b17          	auipc	s6,0x3
ffffffffc0202c42:	c8ab0b13          	addi	s6,s6,-886 # ffffffffc02058c8 <default_pmm_manager+0x9a8>
                    cprintf("SWAP: failed to save\n");
ffffffffc0202c46:	00003b97          	auipc	s7,0x3
ffffffffc0202c4a:	c6ab8b93          	addi	s7,s7,-918 # ffffffffc02058b0 <default_pmm_manager+0x990>
ffffffffc0202c4e:	a825                	j	ffffffffc0202c86 <swap_out+0x70>
                    cprintf("swap_out: i %d, store page in vaddr 0x%x to disk swap entry %d\n", i, v, page->pra_vaddr/PGSIZE+1);
ffffffffc0202c50:	67a2                	ld	a5,8(sp)
ffffffffc0202c52:	8626                	mv	a2,s1
ffffffffc0202c54:	85a2                	mv	a1,s0
ffffffffc0202c56:	63b4                	ld	a3,64(a5)
ffffffffc0202c58:	855a                	mv	a0,s6
     for (i = 0; i != n; ++ i)
ffffffffc0202c5a:	2405                	addiw	s0,s0,1
                    cprintf("swap_out: i %d, store page in vaddr 0x%x to disk swap entry %d\n", i, v, page->pra_vaddr/PGSIZE+1);
ffffffffc0202c5c:	82b1                	srli	a3,a3,0xc
ffffffffc0202c5e:	0685                	addi	a3,a3,1
ffffffffc0202c60:	d1cfd0ef          	jal	ra,ffffffffc020017c <cprintf>
                    *ptep = (page->pra_vaddr/PGSIZE+1)<<8;
ffffffffc0202c64:	6522                	ld	a0,8(sp)
                    free_page(page);
ffffffffc0202c66:	4585                	li	a1,1
                    *ptep = (page->pra_vaddr/PGSIZE+1)<<8;
ffffffffc0202c68:	613c                	ld	a5,64(a0)
ffffffffc0202c6a:	83b1                	srli	a5,a5,0xc
ffffffffc0202c6c:	0785                	addi	a5,a5,1
ffffffffc0202c6e:	07a2                	slli	a5,a5,0x8
ffffffffc0202c70:	00fc3023          	sd	a5,0(s8)
                    free_page(page);
ffffffffc0202c74:	e53fe0ef          	jal	ra,ffffffffc0201ac6 <free_pages>
          }
          
          tlb_invalidate(mm->pgdir, v);
ffffffffc0202c78:	01893503          	ld	a0,24(s2)
ffffffffc0202c7c:	85a6                	mv	a1,s1
ffffffffc0202c7e:	ec3ff0ef          	jal	ra,ffffffffc0202b40 <tlb_invalidate>
     for (i = 0; i != n; ++ i)
ffffffffc0202c82:	048a0d63          	beq	s4,s0,ffffffffc0202cdc <swap_out+0xc6>
          int r = sm->swap_out_victim(mm, &page, in_tick);
ffffffffc0202c86:	0009b783          	ld	a5,0(s3)
ffffffffc0202c8a:	8656                	mv	a2,s5
ffffffffc0202c8c:	002c                	addi	a1,sp,8
ffffffffc0202c8e:	7b9c                	ld	a5,48(a5)
ffffffffc0202c90:	854a                	mv	a0,s2
ffffffffc0202c92:	9782                	jalr	a5
          if (r != 0) {
ffffffffc0202c94:	e12d                	bnez	a0,ffffffffc0202cf6 <swap_out+0xe0>
          v=page->pra_vaddr; 
ffffffffc0202c96:	67a2                	ld	a5,8(sp)
          pte_t *ptep = get_pte(mm->pgdir, v, 0);
ffffffffc0202c98:	01893503          	ld	a0,24(s2)
ffffffffc0202c9c:	4601                	li	a2,0
          v=page->pra_vaddr; 
ffffffffc0202c9e:	63a4                	ld	s1,64(a5)
          pte_t *ptep = get_pte(mm->pgdir, v, 0);
ffffffffc0202ca0:	85a6                	mv	a1,s1
ffffffffc0202ca2:	e9ffe0ef          	jal	ra,ffffffffc0201b40 <get_pte>
          assert((*ptep & PTE_V) != 0);
ffffffffc0202ca6:	611c                	ld	a5,0(a0)
          pte_t *ptep = get_pte(mm->pgdir, v, 0);
ffffffffc0202ca8:	8c2a                	mv	s8,a0
          assert((*ptep & PTE_V) != 0);
ffffffffc0202caa:	8b85                	andi	a5,a5,1
ffffffffc0202cac:	cfb9                	beqz	a5,ffffffffc0202d0a <swap_out+0xf4>
          if (swapfs_write( (page->pra_vaddr/PGSIZE+1)<<8, page) != 0) {
ffffffffc0202cae:	65a2                	ld	a1,8(sp)
ffffffffc0202cb0:	61bc                	ld	a5,64(a1)
ffffffffc0202cb2:	83b1                	srli	a5,a5,0xc
ffffffffc0202cb4:	0785                	addi	a5,a5,1
ffffffffc0202cb6:	00879513          	slli	a0,a5,0x8
ffffffffc0202cba:	053000ef          	jal	ra,ffffffffc020350c <swapfs_write>
ffffffffc0202cbe:	d949                	beqz	a0,ffffffffc0202c50 <swap_out+0x3a>
                    cprintf("SWAP: failed to save\n");
ffffffffc0202cc0:	855e                	mv	a0,s7
ffffffffc0202cc2:	cbafd0ef          	jal	ra,ffffffffc020017c <cprintf>
                    sm->map_swappable(mm, v, page, 0);
ffffffffc0202cc6:	0009b783          	ld	a5,0(s3)
ffffffffc0202cca:	6622                	ld	a2,8(sp)
ffffffffc0202ccc:	4681                	li	a3,0
ffffffffc0202cce:	739c                	ld	a5,32(a5)
ffffffffc0202cd0:	85a6                	mv	a1,s1
ffffffffc0202cd2:	854a                	mv	a0,s2
     for (i = 0; i != n; ++ i)
ffffffffc0202cd4:	2405                	addiw	s0,s0,1
                    sm->map_swappable(mm, v, page, 0);
ffffffffc0202cd6:	9782                	jalr	a5
     for (i = 0; i != n; ++ i)
ffffffffc0202cd8:	fa8a17e3          	bne	s4,s0,ffffffffc0202c86 <swap_out+0x70>
     }
     return i;
}
ffffffffc0202cdc:	60e6                	ld	ra,88(sp)
ffffffffc0202cde:	8522                	mv	a0,s0
ffffffffc0202ce0:	6446                	ld	s0,80(sp)
ffffffffc0202ce2:	64a6                	ld	s1,72(sp)
ffffffffc0202ce4:	6906                	ld	s2,64(sp)
ffffffffc0202ce6:	79e2                	ld	s3,56(sp)
ffffffffc0202ce8:	7a42                	ld	s4,48(sp)
ffffffffc0202cea:	7aa2                	ld	s5,40(sp)
ffffffffc0202cec:	7b02                	ld	s6,32(sp)
ffffffffc0202cee:	6be2                	ld	s7,24(sp)
ffffffffc0202cf0:	6c42                	ld	s8,16(sp)
ffffffffc0202cf2:	6125                	addi	sp,sp,96
ffffffffc0202cf4:	8082                	ret
                    cprintf("i %d, swap_out: call swap_out_victim failed\n",i);
ffffffffc0202cf6:	85a2                	mv	a1,s0
ffffffffc0202cf8:	00003517          	auipc	a0,0x3
ffffffffc0202cfc:	b7050513          	addi	a0,a0,-1168 # ffffffffc0205868 <default_pmm_manager+0x948>
ffffffffc0202d00:	c7cfd0ef          	jal	ra,ffffffffc020017c <cprintf>
                  break;
ffffffffc0202d04:	bfe1                	j	ffffffffc0202cdc <swap_out+0xc6>
     for (i = 0; i != n; ++ i)
ffffffffc0202d06:	4401                	li	s0,0
ffffffffc0202d08:	bfd1                	j	ffffffffc0202cdc <swap_out+0xc6>
          assert((*ptep & PTE_V) != 0);
ffffffffc0202d0a:	00003697          	auipc	a3,0x3
ffffffffc0202d0e:	b8e68693          	addi	a3,a3,-1138 # ffffffffc0205898 <default_pmm_manager+0x978>
ffffffffc0202d12:	00002617          	auipc	a2,0x2
ffffffffc0202d16:	e5e60613          	addi	a2,a2,-418 # ffffffffc0204b70 <commands+0x738>
ffffffffc0202d1a:	06900593          	li	a1,105
ffffffffc0202d1e:	00003517          	auipc	a0,0x3
ffffffffc0202d22:	8c250513          	addi	a0,a0,-1854 # ffffffffc02055e0 <default_pmm_manager+0x6c0>
ffffffffc0202d26:	f1cfd0ef          	jal	ra,ffffffffc0200442 <__panic>

ffffffffc0202d2a <check_vma_overlap.part.0>:
}


// check_vma_overlap - check if vma1 overlaps vma2 ?
static inline void
check_vma_overlap(struct vma_struct *prev, struct vma_struct *next) {
ffffffffc0202d2a:	1141                	addi	sp,sp,-16
    assert(prev->vm_start < prev->vm_end);
    assert(prev->vm_end <= next->vm_start);
    assert(next->vm_start < next->vm_end);
ffffffffc0202d2c:	00003697          	auipc	a3,0x3
ffffffffc0202d30:	bdc68693          	addi	a3,a3,-1060 # ffffffffc0205908 <default_pmm_manager+0x9e8>
ffffffffc0202d34:	00002617          	auipc	a2,0x2
ffffffffc0202d38:	e3c60613          	addi	a2,a2,-452 # ffffffffc0204b70 <commands+0x738>
ffffffffc0202d3c:	07e00593          	li	a1,126
ffffffffc0202d40:	00003517          	auipc	a0,0x3
ffffffffc0202d44:	be850513          	addi	a0,a0,-1048 # ffffffffc0205928 <default_pmm_manager+0xa08>
check_vma_overlap(struct vma_struct *prev, struct vma_struct *next) {
ffffffffc0202d48:	e406                	sd	ra,8(sp)
    assert(next->vm_start < next->vm_end);
ffffffffc0202d4a:	ef8fd0ef          	jal	ra,ffffffffc0200442 <__panic>

ffffffffc0202d4e <find_vma>:
find_vma(struct mm_struct *mm, uintptr_t addr) {
ffffffffc0202d4e:	86aa                	mv	a3,a0
    if (mm != NULL) {
ffffffffc0202d50:	c505                	beqz	a0,ffffffffc0202d78 <find_vma+0x2a>
        vma = mm->mmap_cache;
ffffffffc0202d52:	6908                	ld	a0,16(a0)
        if (!(vma != NULL && vma->vm_start <= addr && vma->vm_end > addr)) {
ffffffffc0202d54:	c501                	beqz	a0,ffffffffc0202d5c <find_vma+0xe>
ffffffffc0202d56:	651c                	ld	a5,8(a0)
ffffffffc0202d58:	02f5f263          	bgeu	a1,a5,ffffffffc0202d7c <find_vma+0x2e>
    return listelm->next;
ffffffffc0202d5c:	669c                	ld	a5,8(a3)
                while ((le = list_next(le)) != list) {
ffffffffc0202d5e:	00f68d63          	beq	a3,a5,ffffffffc0202d78 <find_vma+0x2a>
                    if (vma->vm_start<=addr && addr < vma->vm_end) {
ffffffffc0202d62:	fe87b703          	ld	a4,-24(a5)
ffffffffc0202d66:	00e5e663          	bltu	a1,a4,ffffffffc0202d72 <find_vma+0x24>
ffffffffc0202d6a:	ff07b703          	ld	a4,-16(a5)
ffffffffc0202d6e:	00e5ec63          	bltu	a1,a4,ffffffffc0202d86 <find_vma+0x38>
ffffffffc0202d72:	679c                	ld	a5,8(a5)
                while ((le = list_next(le)) != list) {
ffffffffc0202d74:	fef697e3          	bne	a3,a5,ffffffffc0202d62 <find_vma+0x14>
    struct vma_struct *vma = NULL;
ffffffffc0202d78:	4501                	li	a0,0
}
ffffffffc0202d7a:	8082                	ret
        if (!(vma != NULL && vma->vm_start <= addr && vma->vm_end > addr)) {
ffffffffc0202d7c:	691c                	ld	a5,16(a0)
ffffffffc0202d7e:	fcf5ffe3          	bgeu	a1,a5,ffffffffc0202d5c <find_vma+0xe>
            mm->mmap_cache = vma;
ffffffffc0202d82:	ea88                	sd	a0,16(a3)
ffffffffc0202d84:	8082                	ret
                    vma = le2vma(le, list_link);
ffffffffc0202d86:	fe078513          	addi	a0,a5,-32
            mm->mmap_cache = vma;
ffffffffc0202d8a:	ea88                	sd	a0,16(a3)
ffffffffc0202d8c:	8082                	ret

ffffffffc0202d8e <insert_vma_struct>:


// insert_vma_struct -insert vma in mm's list link
void
insert_vma_struct(struct mm_struct *mm, struct vma_struct *vma) {
    assert(vma->vm_start < vma->vm_end);
ffffffffc0202d8e:	6590                	ld	a2,8(a1)
ffffffffc0202d90:	0105b803          	ld	a6,16(a1)
insert_vma_struct(struct mm_struct *mm, struct vma_struct *vma) {
ffffffffc0202d94:	1141                	addi	sp,sp,-16
ffffffffc0202d96:	e406                	sd	ra,8(sp)
ffffffffc0202d98:	87aa                	mv	a5,a0
    assert(vma->vm_start < vma->vm_end);
ffffffffc0202d9a:	01066763          	bltu	a2,a6,ffffffffc0202da8 <insert_vma_struct+0x1a>
ffffffffc0202d9e:	a085                	j	ffffffffc0202dfe <insert_vma_struct+0x70>
    list_entry_t *le_prev = list, *le_next;

        list_entry_t *le = list;
        while ((le = list_next(le)) != list) {
            struct vma_struct *mmap_prev = le2vma(le, list_link);
            if (mmap_prev->vm_start > vma->vm_start) {
ffffffffc0202da0:	fe87b703          	ld	a4,-24(a5)
ffffffffc0202da4:	04e66863          	bltu	a2,a4,ffffffffc0202df4 <insert_vma_struct+0x66>
ffffffffc0202da8:	86be                	mv	a3,a5
ffffffffc0202daa:	679c                	ld	a5,8(a5)
        while ((le = list_next(le)) != list) {
ffffffffc0202dac:	fef51ae3          	bne	a0,a5,ffffffffc0202da0 <insert_vma_struct+0x12>
        }

    le_next = list_next(le_prev);

    /* check overlap */
    if (le_prev != list) {
ffffffffc0202db0:	02a68463          	beq	a3,a0,ffffffffc0202dd8 <insert_vma_struct+0x4a>
        check_vma_overlap(le2vma(le_prev, list_link), vma);
ffffffffc0202db4:	ff06b703          	ld	a4,-16(a3)
    assert(prev->vm_start < prev->vm_end);
ffffffffc0202db8:	fe86b883          	ld	a7,-24(a3)
ffffffffc0202dbc:	08e8f163          	bgeu	a7,a4,ffffffffc0202e3e <insert_vma_struct+0xb0>
    assert(prev->vm_end <= next->vm_start);
ffffffffc0202dc0:	04e66f63          	bltu	a2,a4,ffffffffc0202e1e <insert_vma_struct+0x90>
    }
    if (le_next != list) {
ffffffffc0202dc4:	00f50a63          	beq	a0,a5,ffffffffc0202dd8 <insert_vma_struct+0x4a>
            if (mmap_prev->vm_start > vma->vm_start) {
ffffffffc0202dc8:	fe87b703          	ld	a4,-24(a5)
    assert(prev->vm_end <= next->vm_start);
ffffffffc0202dcc:	05076963          	bltu	a4,a6,ffffffffc0202e1e <insert_vma_struct+0x90>
    assert(next->vm_start < next->vm_end);
ffffffffc0202dd0:	ff07b603          	ld	a2,-16(a5)
ffffffffc0202dd4:	02c77363          	bgeu	a4,a2,ffffffffc0202dfa <insert_vma_struct+0x6c>
    }

    vma->vm_mm = mm;
    list_add_after(le_prev, &(vma->list_link));

    mm->map_count ++;
ffffffffc0202dd8:	5118                	lw	a4,32(a0)
    vma->vm_mm = mm;
ffffffffc0202dda:	e188                	sd	a0,0(a1)
    list_add_after(le_prev, &(vma->list_link));
ffffffffc0202ddc:	02058613          	addi	a2,a1,32
    prev->next = next->prev = elm;
ffffffffc0202de0:	e390                	sd	a2,0(a5)
ffffffffc0202de2:	e690                	sd	a2,8(a3)
}
ffffffffc0202de4:	60a2                	ld	ra,8(sp)
    elm->next = next;
ffffffffc0202de6:	f59c                	sd	a5,40(a1)
    elm->prev = prev;
ffffffffc0202de8:	f194                	sd	a3,32(a1)
    mm->map_count ++;
ffffffffc0202dea:	0017079b          	addiw	a5,a4,1
ffffffffc0202dee:	d11c                	sw	a5,32(a0)
}
ffffffffc0202df0:	0141                	addi	sp,sp,16
ffffffffc0202df2:	8082                	ret
    if (le_prev != list) {
ffffffffc0202df4:	fca690e3          	bne	a3,a0,ffffffffc0202db4 <insert_vma_struct+0x26>
ffffffffc0202df8:	bfd1                	j	ffffffffc0202dcc <insert_vma_struct+0x3e>
ffffffffc0202dfa:	f31ff0ef          	jal	ra,ffffffffc0202d2a <check_vma_overlap.part.0>
    assert(vma->vm_start < vma->vm_end);
ffffffffc0202dfe:	00003697          	auipc	a3,0x3
ffffffffc0202e02:	b3a68693          	addi	a3,a3,-1222 # ffffffffc0205938 <default_pmm_manager+0xa18>
ffffffffc0202e06:	00002617          	auipc	a2,0x2
ffffffffc0202e0a:	d6a60613          	addi	a2,a2,-662 # ffffffffc0204b70 <commands+0x738>
ffffffffc0202e0e:	08500593          	li	a1,133
ffffffffc0202e12:	00003517          	auipc	a0,0x3
ffffffffc0202e16:	b1650513          	addi	a0,a0,-1258 # ffffffffc0205928 <default_pmm_manager+0xa08>
ffffffffc0202e1a:	e28fd0ef          	jal	ra,ffffffffc0200442 <__panic>
    assert(prev->vm_end <= next->vm_start);
ffffffffc0202e1e:	00003697          	auipc	a3,0x3
ffffffffc0202e22:	b5a68693          	addi	a3,a3,-1190 # ffffffffc0205978 <default_pmm_manager+0xa58>
ffffffffc0202e26:	00002617          	auipc	a2,0x2
ffffffffc0202e2a:	d4a60613          	addi	a2,a2,-694 # ffffffffc0204b70 <commands+0x738>
ffffffffc0202e2e:	07d00593          	li	a1,125
ffffffffc0202e32:	00003517          	auipc	a0,0x3
ffffffffc0202e36:	af650513          	addi	a0,a0,-1290 # ffffffffc0205928 <default_pmm_manager+0xa08>
ffffffffc0202e3a:	e08fd0ef          	jal	ra,ffffffffc0200442 <__panic>
    assert(prev->vm_start < prev->vm_end);
ffffffffc0202e3e:	00003697          	auipc	a3,0x3
ffffffffc0202e42:	b1a68693          	addi	a3,a3,-1254 # ffffffffc0205958 <default_pmm_manager+0xa38>
ffffffffc0202e46:	00002617          	auipc	a2,0x2
ffffffffc0202e4a:	d2a60613          	addi	a2,a2,-726 # ffffffffc0204b70 <commands+0x738>
ffffffffc0202e4e:	07c00593          	li	a1,124
ffffffffc0202e52:	00003517          	auipc	a0,0x3
ffffffffc0202e56:	ad650513          	addi	a0,a0,-1322 # ffffffffc0205928 <default_pmm_manager+0xa08>
ffffffffc0202e5a:	de8fd0ef          	jal	ra,ffffffffc0200442 <__panic>

ffffffffc0202e5e <vmm_init>:
}

// vmm_init - initialize virtual memory management
//          - now just call check_vmm to check correctness of vmm
void
vmm_init(void) {
ffffffffc0202e5e:	7139                	addi	sp,sp,-64
    struct mm_struct *mm = kmalloc(sizeof(struct mm_struct));
ffffffffc0202e60:	03000513          	li	a0,48
vmm_init(void) {
ffffffffc0202e64:	fc06                	sd	ra,56(sp)
ffffffffc0202e66:	f822                	sd	s0,48(sp)
ffffffffc0202e68:	f426                	sd	s1,40(sp)
ffffffffc0202e6a:	f04a                	sd	s2,32(sp)
ffffffffc0202e6c:	ec4e                	sd	s3,24(sp)
ffffffffc0202e6e:	e852                	sd	s4,16(sp)
ffffffffc0202e70:	e456                	sd	s5,8(sp)
    struct mm_struct *mm = kmalloc(sizeof(struct mm_struct));
ffffffffc0202e72:	9dffe0ef          	jal	ra,ffffffffc0201850 <kmalloc>
    if (mm != NULL) {
ffffffffc0202e76:	5a050d63          	beqz	a0,ffffffffc0203430 <vmm_init+0x5d2>
    elm->prev = elm->next = elm;
ffffffffc0202e7a:	e508                	sd	a0,8(a0)
ffffffffc0202e7c:	e108                	sd	a0,0(a0)
        mm->mmap_cache = NULL;
ffffffffc0202e7e:	00053823          	sd	zero,16(a0)
        mm->pgdir = NULL;
ffffffffc0202e82:	00053c23          	sd	zero,24(a0)
        mm->map_count = 0;
ffffffffc0202e86:	02052023          	sw	zero,32(a0)
        if (swap_init_ok) swap_init_mm(mm);
ffffffffc0202e8a:	00012797          	auipc	a5,0x12
ffffffffc0202e8e:	62e7a783          	lw	a5,1582(a5) # ffffffffc02154b8 <swap_init_ok>
ffffffffc0202e92:	84aa                	mv	s1,a0
ffffffffc0202e94:	e7b9                	bnez	a5,ffffffffc0202ee2 <vmm_init+0x84>
        else mm->sm_priv = NULL;
ffffffffc0202e96:	02053423          	sd	zero,40(a0)
vmm_init(void) {
ffffffffc0202e9a:	03200413          	li	s0,50
ffffffffc0202e9e:	a811                	j	ffffffffc0202eb2 <vmm_init+0x54>
        vma->vm_start = vm_start;
ffffffffc0202ea0:	e500                	sd	s0,8(a0)
        vma->vm_end = vm_end;
ffffffffc0202ea2:	e91c                	sd	a5,16(a0)
        vma->vm_flags = vm_flags;
ffffffffc0202ea4:	00052c23          	sw	zero,24(a0)
    assert(mm != NULL);

    int step1 = 10, step2 = step1 * 10;

    int i;
    for (i = step1; i >= 1; i --) {
ffffffffc0202ea8:	146d                	addi	s0,s0,-5
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
        assert(vma != NULL);
        insert_vma_struct(mm, vma);
ffffffffc0202eaa:	8526                	mv	a0,s1
ffffffffc0202eac:	ee3ff0ef          	jal	ra,ffffffffc0202d8e <insert_vma_struct>
    for (i = step1; i >= 1; i --) {
ffffffffc0202eb0:	cc05                	beqz	s0,ffffffffc0202ee8 <vmm_init+0x8a>
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
ffffffffc0202eb2:	03000513          	li	a0,48
ffffffffc0202eb6:	99bfe0ef          	jal	ra,ffffffffc0201850 <kmalloc>
ffffffffc0202eba:	85aa                	mv	a1,a0
ffffffffc0202ebc:	00240793          	addi	a5,s0,2
    if (vma != NULL) {
ffffffffc0202ec0:	f165                	bnez	a0,ffffffffc0202ea0 <vmm_init+0x42>
        assert(vma != NULL);
ffffffffc0202ec2:	00002697          	auipc	a3,0x2
ffffffffc0202ec6:	7a668693          	addi	a3,a3,1958 # ffffffffc0205668 <default_pmm_manager+0x748>
ffffffffc0202eca:	00002617          	auipc	a2,0x2
ffffffffc0202ece:	ca660613          	addi	a2,a2,-858 # ffffffffc0204b70 <commands+0x738>
ffffffffc0202ed2:	0c900593          	li	a1,201
ffffffffc0202ed6:	00003517          	auipc	a0,0x3
ffffffffc0202eda:	a5250513          	addi	a0,a0,-1454 # ffffffffc0205928 <default_pmm_manager+0xa08>
ffffffffc0202ede:	d64fd0ef          	jal	ra,ffffffffc0200442 <__panic>
        if (swap_init_ok) swap_init_mm(mm);
ffffffffc0202ee2:	d1dff0ef          	jal	ra,ffffffffc0202bfe <swap_init_mm>
ffffffffc0202ee6:	bf55                	j	ffffffffc0202e9a <vmm_init+0x3c>
ffffffffc0202ee8:	03700413          	li	s0,55
    }

    for (i = step1 + 1; i <= step2; i ++) {
ffffffffc0202eec:	1f900913          	li	s2,505
ffffffffc0202ef0:	a819                	j	ffffffffc0202f06 <vmm_init+0xa8>
        vma->vm_start = vm_start;
ffffffffc0202ef2:	e500                	sd	s0,8(a0)
        vma->vm_end = vm_end;
ffffffffc0202ef4:	e91c                	sd	a5,16(a0)
        vma->vm_flags = vm_flags;
ffffffffc0202ef6:	00052c23          	sw	zero,24(a0)
    for (i = step1 + 1; i <= step2; i ++) {
ffffffffc0202efa:	0415                	addi	s0,s0,5
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
        assert(vma != NULL);
        insert_vma_struct(mm, vma);
ffffffffc0202efc:	8526                	mv	a0,s1
ffffffffc0202efe:	e91ff0ef          	jal	ra,ffffffffc0202d8e <insert_vma_struct>
    for (i = step1 + 1; i <= step2; i ++) {
ffffffffc0202f02:	03240a63          	beq	s0,s2,ffffffffc0202f36 <vmm_init+0xd8>
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
ffffffffc0202f06:	03000513          	li	a0,48
ffffffffc0202f0a:	947fe0ef          	jal	ra,ffffffffc0201850 <kmalloc>
ffffffffc0202f0e:	85aa                	mv	a1,a0
ffffffffc0202f10:	00240793          	addi	a5,s0,2
    if (vma != NULL) {
ffffffffc0202f14:	fd79                	bnez	a0,ffffffffc0202ef2 <vmm_init+0x94>
        assert(vma != NULL);
ffffffffc0202f16:	00002697          	auipc	a3,0x2
ffffffffc0202f1a:	75268693          	addi	a3,a3,1874 # ffffffffc0205668 <default_pmm_manager+0x748>
ffffffffc0202f1e:	00002617          	auipc	a2,0x2
ffffffffc0202f22:	c5260613          	addi	a2,a2,-942 # ffffffffc0204b70 <commands+0x738>
ffffffffc0202f26:	0cf00593          	li	a1,207
ffffffffc0202f2a:	00003517          	auipc	a0,0x3
ffffffffc0202f2e:	9fe50513          	addi	a0,a0,-1538 # ffffffffc0205928 <default_pmm_manager+0xa08>
ffffffffc0202f32:	d10fd0ef          	jal	ra,ffffffffc0200442 <__panic>
    return listelm->next;
ffffffffc0202f36:	649c                	ld	a5,8(s1)
ffffffffc0202f38:	471d                	li	a4,7
    }

    list_entry_t *le = list_next(&(mm->mmap_list));

    for (i = 1; i <= step2; i ++) {
ffffffffc0202f3a:	1fb00593          	li	a1,507
        assert(le != &(mm->mmap_list));
ffffffffc0202f3e:	32f48d63          	beq	s1,a5,ffffffffc0203278 <vmm_init+0x41a>
        struct vma_struct *mmap = le2vma(le, list_link);
        assert(mmap->vm_start == i * 5 && mmap->vm_end == i * 5 + 2);
ffffffffc0202f42:	fe87b683          	ld	a3,-24(a5)
ffffffffc0202f46:	ffe70613          	addi	a2,a4,-2 # ffffffffffffeffe <end+0x3fde9b12>
ffffffffc0202f4a:	2cd61763          	bne	a2,a3,ffffffffc0203218 <vmm_init+0x3ba>
ffffffffc0202f4e:	ff07b683          	ld	a3,-16(a5)
ffffffffc0202f52:	2ce69363          	bne	a3,a4,ffffffffc0203218 <vmm_init+0x3ba>
    for (i = 1; i <= step2; i ++) {
ffffffffc0202f56:	0715                	addi	a4,a4,5
ffffffffc0202f58:	679c                	ld	a5,8(a5)
ffffffffc0202f5a:	feb712e3          	bne	a4,a1,ffffffffc0202f3e <vmm_init+0xe0>
ffffffffc0202f5e:	4a1d                	li	s4,7
ffffffffc0202f60:	4415                	li	s0,5
        le = list_next(le);
    }

    for (i = 5; i <= 5 * step2; i +=5) {
ffffffffc0202f62:	1f900a93          	li	s5,505
        struct vma_struct *vma1 = find_vma(mm, i);
ffffffffc0202f66:	85a2                	mv	a1,s0
ffffffffc0202f68:	8526                	mv	a0,s1
ffffffffc0202f6a:	de5ff0ef          	jal	ra,ffffffffc0202d4e <find_vma>
ffffffffc0202f6e:	892a                	mv	s2,a0
        assert(vma1 != NULL);
ffffffffc0202f70:	36050463          	beqz	a0,ffffffffc02032d8 <vmm_init+0x47a>
        struct vma_struct *vma2 = find_vma(mm, i+1);
ffffffffc0202f74:	00140593          	addi	a1,s0,1
ffffffffc0202f78:	8526                	mv	a0,s1
ffffffffc0202f7a:	dd5ff0ef          	jal	ra,ffffffffc0202d4e <find_vma>
ffffffffc0202f7e:	89aa                	mv	s3,a0
        assert(vma2 != NULL);
ffffffffc0202f80:	36050c63          	beqz	a0,ffffffffc02032f8 <vmm_init+0x49a>
        struct vma_struct *vma3 = find_vma(mm, i+2);
ffffffffc0202f84:	85d2                	mv	a1,s4
ffffffffc0202f86:	8526                	mv	a0,s1
ffffffffc0202f88:	dc7ff0ef          	jal	ra,ffffffffc0202d4e <find_vma>
        assert(vma3 == NULL);
ffffffffc0202f8c:	38051663          	bnez	a0,ffffffffc0203318 <vmm_init+0x4ba>
        struct vma_struct *vma4 = find_vma(mm, i+3);
ffffffffc0202f90:	00340593          	addi	a1,s0,3
ffffffffc0202f94:	8526                	mv	a0,s1
ffffffffc0202f96:	db9ff0ef          	jal	ra,ffffffffc0202d4e <find_vma>
        assert(vma4 == NULL);
ffffffffc0202f9a:	2e051f63          	bnez	a0,ffffffffc0203298 <vmm_init+0x43a>
        struct vma_struct *vma5 = find_vma(mm, i+4);
ffffffffc0202f9e:	00440593          	addi	a1,s0,4
ffffffffc0202fa2:	8526                	mv	a0,s1
ffffffffc0202fa4:	dabff0ef          	jal	ra,ffffffffc0202d4e <find_vma>
        assert(vma5 == NULL);
ffffffffc0202fa8:	30051863          	bnez	a0,ffffffffc02032b8 <vmm_init+0x45a>

        assert(vma1->vm_start == i  && vma1->vm_end == i  + 2);
ffffffffc0202fac:	00893783          	ld	a5,8(s2)
ffffffffc0202fb0:	28879463          	bne	a5,s0,ffffffffc0203238 <vmm_init+0x3da>
ffffffffc0202fb4:	01093783          	ld	a5,16(s2)
ffffffffc0202fb8:	29479063          	bne	a5,s4,ffffffffc0203238 <vmm_init+0x3da>
        assert(vma2->vm_start == i  && vma2->vm_end == i  + 2);
ffffffffc0202fbc:	0089b783          	ld	a5,8(s3)
ffffffffc0202fc0:	28879c63          	bne	a5,s0,ffffffffc0203258 <vmm_init+0x3fa>
ffffffffc0202fc4:	0109b783          	ld	a5,16(s3)
ffffffffc0202fc8:	29479863          	bne	a5,s4,ffffffffc0203258 <vmm_init+0x3fa>
    for (i = 5; i <= 5 * step2; i +=5) {
ffffffffc0202fcc:	0415                	addi	s0,s0,5
ffffffffc0202fce:	0a15                	addi	s4,s4,5
ffffffffc0202fd0:	f9541be3          	bne	s0,s5,ffffffffc0202f66 <vmm_init+0x108>
ffffffffc0202fd4:	4411                	li	s0,4
    }

    for (i =4; i>=0; i--) {
ffffffffc0202fd6:	597d                	li	s2,-1
        struct vma_struct *vma_below_5= find_vma(mm,i);
ffffffffc0202fd8:	85a2                	mv	a1,s0
ffffffffc0202fda:	8526                	mv	a0,s1
ffffffffc0202fdc:	d73ff0ef          	jal	ra,ffffffffc0202d4e <find_vma>
ffffffffc0202fe0:	0004059b          	sext.w	a1,s0
        if (vma_below_5 != NULL ) {
ffffffffc0202fe4:	c90d                	beqz	a0,ffffffffc0203016 <vmm_init+0x1b8>
           cprintf("vma_below_5: i %x, start %x, end %x\n",i, vma_below_5->vm_start, vma_below_5->vm_end); 
ffffffffc0202fe6:	6914                	ld	a3,16(a0)
ffffffffc0202fe8:	6510                	ld	a2,8(a0)
ffffffffc0202fea:	00003517          	auipc	a0,0x3
ffffffffc0202fee:	aae50513          	addi	a0,a0,-1362 # ffffffffc0205a98 <default_pmm_manager+0xb78>
ffffffffc0202ff2:	98afd0ef          	jal	ra,ffffffffc020017c <cprintf>
        }
        assert(vma_below_5 == NULL);
ffffffffc0202ff6:	00003697          	auipc	a3,0x3
ffffffffc0202ffa:	aca68693          	addi	a3,a3,-1334 # ffffffffc0205ac0 <default_pmm_manager+0xba0>
ffffffffc0202ffe:	00002617          	auipc	a2,0x2
ffffffffc0203002:	b7260613          	addi	a2,a2,-1166 # ffffffffc0204b70 <commands+0x738>
ffffffffc0203006:	0f100593          	li	a1,241
ffffffffc020300a:	00003517          	auipc	a0,0x3
ffffffffc020300e:	91e50513          	addi	a0,a0,-1762 # ffffffffc0205928 <default_pmm_manager+0xa08>
ffffffffc0203012:	c30fd0ef          	jal	ra,ffffffffc0200442 <__panic>
    for (i =4; i>=0; i--) {
ffffffffc0203016:	147d                	addi	s0,s0,-1
ffffffffc0203018:	fd2410e3          	bne	s0,s2,ffffffffc0202fd8 <vmm_init+0x17a>
ffffffffc020301c:	a801                	j	ffffffffc020302c <vmm_init+0x1ce>
    __list_del(listelm->prev, listelm->next);
ffffffffc020301e:	6118                	ld	a4,0(a0)
ffffffffc0203020:	651c                	ld	a5,8(a0)
        kfree(le2vma(le, list_link));  //kfree vma        
ffffffffc0203022:	1501                	addi	a0,a0,-32
    prev->next = next;
ffffffffc0203024:	e71c                	sd	a5,8(a4)
    next->prev = prev;
ffffffffc0203026:	e398                	sd	a4,0(a5)
ffffffffc0203028:	8d9fe0ef          	jal	ra,ffffffffc0201900 <kfree>
    return listelm->next;
ffffffffc020302c:	6488                	ld	a0,8(s1)
    while ((le = list_next(list)) != list) {
ffffffffc020302e:	fea498e3          	bne	s1,a0,ffffffffc020301e <vmm_init+0x1c0>
    kfree(mm); //kfree mm
ffffffffc0203032:	8526                	mv	a0,s1
ffffffffc0203034:	8cdfe0ef          	jal	ra,ffffffffc0201900 <kfree>
    }

    mm_destroy(mm);

    cprintf("check_vma_struct() succeeded!\n");
ffffffffc0203038:	00003517          	auipc	a0,0x3
ffffffffc020303c:	aa050513          	addi	a0,a0,-1376 # ffffffffc0205ad8 <default_pmm_manager+0xbb8>
ffffffffc0203040:	93cfd0ef          	jal	ra,ffffffffc020017c <cprintf>
struct mm_struct *check_mm_struct;

// check_pgfault - check correctness of pgfault handler
static void
check_pgfault(void) {
    size_t nr_free_pages_store = nr_free_pages();
ffffffffc0203044:	ac3fe0ef          	jal	ra,ffffffffc0201b06 <nr_free_pages>
ffffffffc0203048:	84aa                	mv	s1,a0
    struct mm_struct *mm = kmalloc(sizeof(struct mm_struct));
ffffffffc020304a:	03000513          	li	a0,48
ffffffffc020304e:	803fe0ef          	jal	ra,ffffffffc0201850 <kmalloc>
ffffffffc0203052:	842a                	mv	s0,a0
    if (mm != NULL) {
ffffffffc0203054:	2e050263          	beqz	a0,ffffffffc0203338 <vmm_init+0x4da>
        if (swap_init_ok) swap_init_mm(mm);
ffffffffc0203058:	00012797          	auipc	a5,0x12
ffffffffc020305c:	4607a783          	lw	a5,1120(a5) # ffffffffc02154b8 <swap_init_ok>
    elm->prev = elm->next = elm;
ffffffffc0203060:	e508                	sd	a0,8(a0)
ffffffffc0203062:	e108                	sd	a0,0(a0)
        mm->mmap_cache = NULL;
ffffffffc0203064:	00053823          	sd	zero,16(a0)
        mm->pgdir = NULL;
ffffffffc0203068:	00053c23          	sd	zero,24(a0)
        mm->map_count = 0;
ffffffffc020306c:	02052023          	sw	zero,32(a0)
        if (swap_init_ok) swap_init_mm(mm);
ffffffffc0203070:	1a079163          	bnez	a5,ffffffffc0203212 <vmm_init+0x3b4>
        else mm->sm_priv = NULL;
ffffffffc0203074:	02053423          	sd	zero,40(a0)

    check_mm_struct = mm_create();
    assert(check_mm_struct != NULL);

    struct mm_struct *mm = check_mm_struct;
    pde_t *pgdir = mm->pgdir = boot_pgdir;
ffffffffc0203078:	00012917          	auipc	s2,0x12
ffffffffc020307c:	40893903          	ld	s2,1032(s2) # ffffffffc0215480 <boot_pgdir>
    assert(pgdir[0] == 0);
ffffffffc0203080:	00093783          	ld	a5,0(s2)
    check_mm_struct = mm_create();
ffffffffc0203084:	00012717          	auipc	a4,0x12
ffffffffc0203088:	42873e23          	sd	s0,1084(a4) # ffffffffc02154c0 <check_mm_struct>
    pde_t *pgdir = mm->pgdir = boot_pgdir;
ffffffffc020308c:	01243c23          	sd	s2,24(s0)
    assert(pgdir[0] == 0);
ffffffffc0203090:	38079063          	bnez	a5,ffffffffc0203410 <vmm_init+0x5b2>
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
ffffffffc0203094:	03000513          	li	a0,48
ffffffffc0203098:	fb8fe0ef          	jal	ra,ffffffffc0201850 <kmalloc>
ffffffffc020309c:	89aa                	mv	s3,a0
    if (vma != NULL) {
ffffffffc020309e:	2c050163          	beqz	a0,ffffffffc0203360 <vmm_init+0x502>
        vma->vm_end = vm_end;
ffffffffc02030a2:	002007b7          	lui	a5,0x200
ffffffffc02030a6:	00f9b823          	sd	a5,16(s3)
        vma->vm_flags = vm_flags;
ffffffffc02030aa:	4789                	li	a5,2

    struct vma_struct *vma = vma_create(0, PTSIZE, VM_WRITE);
    assert(vma != NULL);

    insert_vma_struct(mm, vma);
ffffffffc02030ac:	85aa                	mv	a1,a0
        vma->vm_flags = vm_flags;
ffffffffc02030ae:	00f9ac23          	sw	a5,24(s3)
    insert_vma_struct(mm, vma);
ffffffffc02030b2:	8522                	mv	a0,s0
        vma->vm_start = vm_start;
ffffffffc02030b4:	0009b423          	sd	zero,8(s3)
    insert_vma_struct(mm, vma);
ffffffffc02030b8:	cd7ff0ef          	jal	ra,ffffffffc0202d8e <insert_vma_struct>

    uintptr_t addr = 0x100;
    assert(find_vma(mm, addr) == vma);
ffffffffc02030bc:	10000593          	li	a1,256
ffffffffc02030c0:	8522                	mv	a0,s0
ffffffffc02030c2:	c8dff0ef          	jal	ra,ffffffffc0202d4e <find_vma>
ffffffffc02030c6:	10000793          	li	a5,256

    int i, sum = 0;
    for (i = 0; i < 100; i ++) {
ffffffffc02030ca:	16400713          	li	a4,356
    assert(find_vma(mm, addr) == vma);
ffffffffc02030ce:	2aa99963          	bne	s3,a0,ffffffffc0203380 <vmm_init+0x522>
        *(char *)(addr + i) = i;
ffffffffc02030d2:	00f78023          	sb	a5,0(a5) # 200000 <kern_entry-0xffffffffc0000000>
    for (i = 0; i < 100; i ++) {
ffffffffc02030d6:	0785                	addi	a5,a5,1
ffffffffc02030d8:	fee79de3          	bne	a5,a4,ffffffffc02030d2 <vmm_init+0x274>
        sum += i;
ffffffffc02030dc:	6705                	lui	a4,0x1
ffffffffc02030de:	10000793          	li	a5,256
ffffffffc02030e2:	35670713          	addi	a4,a4,854 # 1356 <kern_entry-0xffffffffc01fecaa>
    }
    for (i = 0; i < 100; i ++) {
ffffffffc02030e6:	16400613          	li	a2,356
        sum -= *(char *)(addr + i);
ffffffffc02030ea:	0007c683          	lbu	a3,0(a5)
    for (i = 0; i < 100; i ++) {
ffffffffc02030ee:	0785                	addi	a5,a5,1
        sum -= *(char *)(addr + i);
ffffffffc02030f0:	9f15                	subw	a4,a4,a3
    for (i = 0; i < 100; i ++) {
ffffffffc02030f2:	fec79ce3          	bne	a5,a2,ffffffffc02030ea <vmm_init+0x28c>
    }
    assert(sum == 0);
ffffffffc02030f6:	2a071563          	bnez	a4,ffffffffc02033a0 <vmm_init+0x542>
    return pa2page(PDE_ADDR(pde));
ffffffffc02030fa:	00093783          	ld	a5,0(s2)
    if (PPN(pa) >= npage) {
ffffffffc02030fe:	00012a97          	auipc	s5,0x12
ffffffffc0203102:	38aa8a93          	addi	s5,s5,906 # ffffffffc0215488 <npage>
ffffffffc0203106:	000ab603          	ld	a2,0(s5)
    return pa2page(PDE_ADDR(pde));
ffffffffc020310a:	078a                	slli	a5,a5,0x2
ffffffffc020310c:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage) {
ffffffffc020310e:	2ac7f963          	bgeu	a5,a2,ffffffffc02033c0 <vmm_init+0x562>
    return &pages[PPN(pa) - nbase];
ffffffffc0203112:	00003a17          	auipc	s4,0x3
ffffffffc0203116:	f2ea3a03          	ld	s4,-210(s4) # ffffffffc0206040 <nbase>
ffffffffc020311a:	41478733          	sub	a4,a5,s4
ffffffffc020311e:	00371793          	slli	a5,a4,0x3
ffffffffc0203122:	97ba                	add	a5,a5,a4
ffffffffc0203124:	078e                	slli	a5,a5,0x3
    return page - pages + nbase;
ffffffffc0203126:	00003717          	auipc	a4,0x3
ffffffffc020312a:	f1273703          	ld	a4,-238(a4) # ffffffffc0206038 <error_string+0x38>
ffffffffc020312e:	878d                	srai	a5,a5,0x3
ffffffffc0203130:	02e787b3          	mul	a5,a5,a4
ffffffffc0203134:	97d2                	add	a5,a5,s4
    return KADDR(page2pa(page));
ffffffffc0203136:	00c79713          	slli	a4,a5,0xc
ffffffffc020313a:	8331                	srli	a4,a4,0xc
    return page2ppn(page) << PGSHIFT;
ffffffffc020313c:	00c79693          	slli	a3,a5,0xc
    return KADDR(page2pa(page));
ffffffffc0203140:	28c77c63          	bgeu	a4,a2,ffffffffc02033d8 <vmm_init+0x57a>
ffffffffc0203144:	00012997          	auipc	s3,0x12
ffffffffc0203148:	35c9b983          	ld	s3,860(s3) # ffffffffc02154a0 <va_pa_offset>

    pde_t *pd1=pgdir,*pd0=page2kva(pde2page(pgdir[0]));
    page_remove(pgdir, ROUNDDOWN(addr, PGSIZE));
ffffffffc020314c:	4581                	li	a1,0
ffffffffc020314e:	854a                	mv	a0,s2
ffffffffc0203150:	99b6                	add	s3,s3,a3
ffffffffc0203152:	c3ffe0ef          	jal	ra,ffffffffc0201d90 <page_remove>
    return pa2page(PDE_ADDR(pde));
ffffffffc0203156:	0009b783          	ld	a5,0(s3)
    if (PPN(pa) >= npage) {
ffffffffc020315a:	000ab703          	ld	a4,0(s5)
    return pa2page(PDE_ADDR(pde));
ffffffffc020315e:	078a                	slli	a5,a5,0x2
ffffffffc0203160:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage) {
ffffffffc0203162:	24e7ff63          	bgeu	a5,a4,ffffffffc02033c0 <vmm_init+0x562>
    return &pages[PPN(pa) - nbase];
ffffffffc0203166:	414787b3          	sub	a5,a5,s4
ffffffffc020316a:	00012997          	auipc	s3,0x12
ffffffffc020316e:	32698993          	addi	s3,s3,806 # ffffffffc0215490 <pages>
ffffffffc0203172:	00379713          	slli	a4,a5,0x3
ffffffffc0203176:	0009b503          	ld	a0,0(s3)
ffffffffc020317a:	97ba                	add	a5,a5,a4
ffffffffc020317c:	078e                	slli	a5,a5,0x3
    free_page(pde2page(pd0[0]));
ffffffffc020317e:	953e                	add	a0,a0,a5
ffffffffc0203180:	4585                	li	a1,1
ffffffffc0203182:	945fe0ef          	jal	ra,ffffffffc0201ac6 <free_pages>
    return pa2page(PDE_ADDR(pde));
ffffffffc0203186:	00093783          	ld	a5,0(s2)
    if (PPN(pa) >= npage) {
ffffffffc020318a:	000ab703          	ld	a4,0(s5)
    return pa2page(PDE_ADDR(pde));
ffffffffc020318e:	078a                	slli	a5,a5,0x2
ffffffffc0203190:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage) {
ffffffffc0203192:	22e7f763          	bgeu	a5,a4,ffffffffc02033c0 <vmm_init+0x562>
    return &pages[PPN(pa) - nbase];
ffffffffc0203196:	414787b3          	sub	a5,a5,s4
ffffffffc020319a:	0009b503          	ld	a0,0(s3)
ffffffffc020319e:	00379713          	slli	a4,a5,0x3
ffffffffc02031a2:	97ba                	add	a5,a5,a4
ffffffffc02031a4:	078e                	slli	a5,a5,0x3
    free_page(pde2page(pd1[0]));
ffffffffc02031a6:	4585                	li	a1,1
ffffffffc02031a8:	953e                	add	a0,a0,a5
ffffffffc02031aa:	91dfe0ef          	jal	ra,ffffffffc0201ac6 <free_pages>
    pgdir[0] = 0;
ffffffffc02031ae:	00093023          	sd	zero,0(s2)
  asm volatile("sfence.vma");
ffffffffc02031b2:	12000073          	sfence.vma
    return listelm->next;
ffffffffc02031b6:	6408                	ld	a0,8(s0)
    flush_tlb();

    mm->pgdir = NULL;
ffffffffc02031b8:	00043c23          	sd	zero,24(s0)
    while ((le = list_next(list)) != list) {
ffffffffc02031bc:	00a40c63          	beq	s0,a0,ffffffffc02031d4 <vmm_init+0x376>
    __list_del(listelm->prev, listelm->next);
ffffffffc02031c0:	6118                	ld	a4,0(a0)
ffffffffc02031c2:	651c                	ld	a5,8(a0)
        kfree(le2vma(le, list_link));  //kfree vma        
ffffffffc02031c4:	1501                	addi	a0,a0,-32
    prev->next = next;
ffffffffc02031c6:	e71c                	sd	a5,8(a4)
    next->prev = prev;
ffffffffc02031c8:	e398                	sd	a4,0(a5)
ffffffffc02031ca:	f36fe0ef          	jal	ra,ffffffffc0201900 <kfree>
    return listelm->next;
ffffffffc02031ce:	6408                	ld	a0,8(s0)
    while ((le = list_next(list)) != list) {
ffffffffc02031d0:	fea418e3          	bne	s0,a0,ffffffffc02031c0 <vmm_init+0x362>
    kfree(mm); //kfree mm
ffffffffc02031d4:	8522                	mv	a0,s0
ffffffffc02031d6:	f2afe0ef          	jal	ra,ffffffffc0201900 <kfree>
    mm_destroy(mm);
    check_mm_struct = NULL;
ffffffffc02031da:	00012797          	auipc	a5,0x12
ffffffffc02031de:	2e07b323          	sd	zero,742(a5) # ffffffffc02154c0 <check_mm_struct>

    assert(nr_free_pages_store == nr_free_pages());
ffffffffc02031e2:	925fe0ef          	jal	ra,ffffffffc0201b06 <nr_free_pages>
ffffffffc02031e6:	20a49563          	bne	s1,a0,ffffffffc02033f0 <vmm_init+0x592>

    cprintf("check_pgfault() succeeded!\n");
ffffffffc02031ea:	00003517          	auipc	a0,0x3
ffffffffc02031ee:	96650513          	addi	a0,a0,-1690 # ffffffffc0205b50 <default_pmm_manager+0xc30>
ffffffffc02031f2:	f8bfc0ef          	jal	ra,ffffffffc020017c <cprintf>
}
ffffffffc02031f6:	7442                	ld	s0,48(sp)
ffffffffc02031f8:	70e2                	ld	ra,56(sp)
ffffffffc02031fa:	74a2                	ld	s1,40(sp)
ffffffffc02031fc:	7902                	ld	s2,32(sp)
ffffffffc02031fe:	69e2                	ld	s3,24(sp)
ffffffffc0203200:	6a42                	ld	s4,16(sp)
ffffffffc0203202:	6aa2                	ld	s5,8(sp)
    cprintf("check_vmm() succeeded.\n");
ffffffffc0203204:	00003517          	auipc	a0,0x3
ffffffffc0203208:	96c50513          	addi	a0,a0,-1684 # ffffffffc0205b70 <default_pmm_manager+0xc50>
}
ffffffffc020320c:	6121                	addi	sp,sp,64
    cprintf("check_vmm() succeeded.\n");
ffffffffc020320e:	f6ffc06f          	j	ffffffffc020017c <cprintf>
        if (swap_init_ok) swap_init_mm(mm);
ffffffffc0203212:	9edff0ef          	jal	ra,ffffffffc0202bfe <swap_init_mm>
ffffffffc0203216:	b58d                	j	ffffffffc0203078 <vmm_init+0x21a>
        assert(mmap->vm_start == i * 5 && mmap->vm_end == i * 5 + 2);
ffffffffc0203218:	00002697          	auipc	a3,0x2
ffffffffc020321c:	79868693          	addi	a3,a3,1944 # ffffffffc02059b0 <default_pmm_manager+0xa90>
ffffffffc0203220:	00002617          	auipc	a2,0x2
ffffffffc0203224:	95060613          	addi	a2,a2,-1712 # ffffffffc0204b70 <commands+0x738>
ffffffffc0203228:	0d800593          	li	a1,216
ffffffffc020322c:	00002517          	auipc	a0,0x2
ffffffffc0203230:	6fc50513          	addi	a0,a0,1788 # ffffffffc0205928 <default_pmm_manager+0xa08>
ffffffffc0203234:	a0efd0ef          	jal	ra,ffffffffc0200442 <__panic>
        assert(vma1->vm_start == i  && vma1->vm_end == i  + 2);
ffffffffc0203238:	00003697          	auipc	a3,0x3
ffffffffc020323c:	80068693          	addi	a3,a3,-2048 # ffffffffc0205a38 <default_pmm_manager+0xb18>
ffffffffc0203240:	00002617          	auipc	a2,0x2
ffffffffc0203244:	93060613          	addi	a2,a2,-1744 # ffffffffc0204b70 <commands+0x738>
ffffffffc0203248:	0e800593          	li	a1,232
ffffffffc020324c:	00002517          	auipc	a0,0x2
ffffffffc0203250:	6dc50513          	addi	a0,a0,1756 # ffffffffc0205928 <default_pmm_manager+0xa08>
ffffffffc0203254:	9eefd0ef          	jal	ra,ffffffffc0200442 <__panic>
        assert(vma2->vm_start == i  && vma2->vm_end == i  + 2);
ffffffffc0203258:	00003697          	auipc	a3,0x3
ffffffffc020325c:	81068693          	addi	a3,a3,-2032 # ffffffffc0205a68 <default_pmm_manager+0xb48>
ffffffffc0203260:	00002617          	auipc	a2,0x2
ffffffffc0203264:	91060613          	addi	a2,a2,-1776 # ffffffffc0204b70 <commands+0x738>
ffffffffc0203268:	0e900593          	li	a1,233
ffffffffc020326c:	00002517          	auipc	a0,0x2
ffffffffc0203270:	6bc50513          	addi	a0,a0,1724 # ffffffffc0205928 <default_pmm_manager+0xa08>
ffffffffc0203274:	9cefd0ef          	jal	ra,ffffffffc0200442 <__panic>
        assert(le != &(mm->mmap_list));
ffffffffc0203278:	00002697          	auipc	a3,0x2
ffffffffc020327c:	72068693          	addi	a3,a3,1824 # ffffffffc0205998 <default_pmm_manager+0xa78>
ffffffffc0203280:	00002617          	auipc	a2,0x2
ffffffffc0203284:	8f060613          	addi	a2,a2,-1808 # ffffffffc0204b70 <commands+0x738>
ffffffffc0203288:	0d600593          	li	a1,214
ffffffffc020328c:	00002517          	auipc	a0,0x2
ffffffffc0203290:	69c50513          	addi	a0,a0,1692 # ffffffffc0205928 <default_pmm_manager+0xa08>
ffffffffc0203294:	9aefd0ef          	jal	ra,ffffffffc0200442 <__panic>
        assert(vma4 == NULL);
ffffffffc0203298:	00002697          	auipc	a3,0x2
ffffffffc020329c:	78068693          	addi	a3,a3,1920 # ffffffffc0205a18 <default_pmm_manager+0xaf8>
ffffffffc02032a0:	00002617          	auipc	a2,0x2
ffffffffc02032a4:	8d060613          	addi	a2,a2,-1840 # ffffffffc0204b70 <commands+0x738>
ffffffffc02032a8:	0e400593          	li	a1,228
ffffffffc02032ac:	00002517          	auipc	a0,0x2
ffffffffc02032b0:	67c50513          	addi	a0,a0,1660 # ffffffffc0205928 <default_pmm_manager+0xa08>
ffffffffc02032b4:	98efd0ef          	jal	ra,ffffffffc0200442 <__panic>
        assert(vma5 == NULL);
ffffffffc02032b8:	00002697          	auipc	a3,0x2
ffffffffc02032bc:	77068693          	addi	a3,a3,1904 # ffffffffc0205a28 <default_pmm_manager+0xb08>
ffffffffc02032c0:	00002617          	auipc	a2,0x2
ffffffffc02032c4:	8b060613          	addi	a2,a2,-1872 # ffffffffc0204b70 <commands+0x738>
ffffffffc02032c8:	0e600593          	li	a1,230
ffffffffc02032cc:	00002517          	auipc	a0,0x2
ffffffffc02032d0:	65c50513          	addi	a0,a0,1628 # ffffffffc0205928 <default_pmm_manager+0xa08>
ffffffffc02032d4:	96efd0ef          	jal	ra,ffffffffc0200442 <__panic>
        assert(vma1 != NULL);
ffffffffc02032d8:	00002697          	auipc	a3,0x2
ffffffffc02032dc:	71068693          	addi	a3,a3,1808 # ffffffffc02059e8 <default_pmm_manager+0xac8>
ffffffffc02032e0:	00002617          	auipc	a2,0x2
ffffffffc02032e4:	89060613          	addi	a2,a2,-1904 # ffffffffc0204b70 <commands+0x738>
ffffffffc02032e8:	0de00593          	li	a1,222
ffffffffc02032ec:	00002517          	auipc	a0,0x2
ffffffffc02032f0:	63c50513          	addi	a0,a0,1596 # ffffffffc0205928 <default_pmm_manager+0xa08>
ffffffffc02032f4:	94efd0ef          	jal	ra,ffffffffc0200442 <__panic>
        assert(vma2 != NULL);
ffffffffc02032f8:	00002697          	auipc	a3,0x2
ffffffffc02032fc:	70068693          	addi	a3,a3,1792 # ffffffffc02059f8 <default_pmm_manager+0xad8>
ffffffffc0203300:	00002617          	auipc	a2,0x2
ffffffffc0203304:	87060613          	addi	a2,a2,-1936 # ffffffffc0204b70 <commands+0x738>
ffffffffc0203308:	0e000593          	li	a1,224
ffffffffc020330c:	00002517          	auipc	a0,0x2
ffffffffc0203310:	61c50513          	addi	a0,a0,1564 # ffffffffc0205928 <default_pmm_manager+0xa08>
ffffffffc0203314:	92efd0ef          	jal	ra,ffffffffc0200442 <__panic>
        assert(vma3 == NULL);
ffffffffc0203318:	00002697          	auipc	a3,0x2
ffffffffc020331c:	6f068693          	addi	a3,a3,1776 # ffffffffc0205a08 <default_pmm_manager+0xae8>
ffffffffc0203320:	00002617          	auipc	a2,0x2
ffffffffc0203324:	85060613          	addi	a2,a2,-1968 # ffffffffc0204b70 <commands+0x738>
ffffffffc0203328:	0e200593          	li	a1,226
ffffffffc020332c:	00002517          	auipc	a0,0x2
ffffffffc0203330:	5fc50513          	addi	a0,a0,1532 # ffffffffc0205928 <default_pmm_manager+0xa08>
ffffffffc0203334:	90efd0ef          	jal	ra,ffffffffc0200442 <__panic>
    assert(check_mm_struct != NULL);
ffffffffc0203338:	00003697          	auipc	a3,0x3
ffffffffc020333c:	85068693          	addi	a3,a3,-1968 # ffffffffc0205b88 <default_pmm_manager+0xc68>
ffffffffc0203340:	00002617          	auipc	a2,0x2
ffffffffc0203344:	83060613          	addi	a2,a2,-2000 # ffffffffc0204b70 <commands+0x738>
ffffffffc0203348:	10100593          	li	a1,257
ffffffffc020334c:	00002517          	auipc	a0,0x2
ffffffffc0203350:	5dc50513          	addi	a0,a0,1500 # ffffffffc0205928 <default_pmm_manager+0xa08>
    check_mm_struct = mm_create();
ffffffffc0203354:	00012797          	auipc	a5,0x12
ffffffffc0203358:	1607b623          	sd	zero,364(a5) # ffffffffc02154c0 <check_mm_struct>
    assert(check_mm_struct != NULL);
ffffffffc020335c:	8e6fd0ef          	jal	ra,ffffffffc0200442 <__panic>
    assert(vma != NULL);
ffffffffc0203360:	00002697          	auipc	a3,0x2
ffffffffc0203364:	30868693          	addi	a3,a3,776 # ffffffffc0205668 <default_pmm_manager+0x748>
ffffffffc0203368:	00002617          	auipc	a2,0x2
ffffffffc020336c:	80860613          	addi	a2,a2,-2040 # ffffffffc0204b70 <commands+0x738>
ffffffffc0203370:	10800593          	li	a1,264
ffffffffc0203374:	00002517          	auipc	a0,0x2
ffffffffc0203378:	5b450513          	addi	a0,a0,1460 # ffffffffc0205928 <default_pmm_manager+0xa08>
ffffffffc020337c:	8c6fd0ef          	jal	ra,ffffffffc0200442 <__panic>
    assert(find_vma(mm, addr) == vma);
ffffffffc0203380:	00002697          	auipc	a3,0x2
ffffffffc0203384:	77868693          	addi	a3,a3,1912 # ffffffffc0205af8 <default_pmm_manager+0xbd8>
ffffffffc0203388:	00001617          	auipc	a2,0x1
ffffffffc020338c:	7e860613          	addi	a2,a2,2024 # ffffffffc0204b70 <commands+0x738>
ffffffffc0203390:	10d00593          	li	a1,269
ffffffffc0203394:	00002517          	auipc	a0,0x2
ffffffffc0203398:	59450513          	addi	a0,a0,1428 # ffffffffc0205928 <default_pmm_manager+0xa08>
ffffffffc020339c:	8a6fd0ef          	jal	ra,ffffffffc0200442 <__panic>
    assert(sum == 0);
ffffffffc02033a0:	00002697          	auipc	a3,0x2
ffffffffc02033a4:	77868693          	addi	a3,a3,1912 # ffffffffc0205b18 <default_pmm_manager+0xbf8>
ffffffffc02033a8:	00001617          	auipc	a2,0x1
ffffffffc02033ac:	7c860613          	addi	a2,a2,1992 # ffffffffc0204b70 <commands+0x738>
ffffffffc02033b0:	11700593          	li	a1,279
ffffffffc02033b4:	00002517          	auipc	a0,0x2
ffffffffc02033b8:	57450513          	addi	a0,a0,1396 # ffffffffc0205928 <default_pmm_manager+0xa08>
ffffffffc02033bc:	886fd0ef          	jal	ra,ffffffffc0200442 <__panic>
        panic("pa2page called with invalid pa");
ffffffffc02033c0:	00002617          	auipc	a2,0x2
ffffffffc02033c4:	c6860613          	addi	a2,a2,-920 # ffffffffc0205028 <default_pmm_manager+0x108>
ffffffffc02033c8:	06200593          	li	a1,98
ffffffffc02033cc:	00002517          	auipc	a0,0x2
ffffffffc02033d0:	bb450513          	addi	a0,a0,-1100 # ffffffffc0204f80 <default_pmm_manager+0x60>
ffffffffc02033d4:	86efd0ef          	jal	ra,ffffffffc0200442 <__panic>
    return KADDR(page2pa(page));
ffffffffc02033d8:	00002617          	auipc	a2,0x2
ffffffffc02033dc:	b8060613          	addi	a2,a2,-1152 # ffffffffc0204f58 <default_pmm_manager+0x38>
ffffffffc02033e0:	06900593          	li	a1,105
ffffffffc02033e4:	00002517          	auipc	a0,0x2
ffffffffc02033e8:	b9c50513          	addi	a0,a0,-1124 # ffffffffc0204f80 <default_pmm_manager+0x60>
ffffffffc02033ec:	856fd0ef          	jal	ra,ffffffffc0200442 <__panic>
    assert(nr_free_pages_store == nr_free_pages());
ffffffffc02033f0:	00002697          	auipc	a3,0x2
ffffffffc02033f4:	73868693          	addi	a3,a3,1848 # ffffffffc0205b28 <default_pmm_manager+0xc08>
ffffffffc02033f8:	00001617          	auipc	a2,0x1
ffffffffc02033fc:	77860613          	addi	a2,a2,1912 # ffffffffc0204b70 <commands+0x738>
ffffffffc0203400:	12400593          	li	a1,292
ffffffffc0203404:	00002517          	auipc	a0,0x2
ffffffffc0203408:	52450513          	addi	a0,a0,1316 # ffffffffc0205928 <default_pmm_manager+0xa08>
ffffffffc020340c:	836fd0ef          	jal	ra,ffffffffc0200442 <__panic>
    assert(pgdir[0] == 0);
ffffffffc0203410:	00002697          	auipc	a3,0x2
ffffffffc0203414:	24868693          	addi	a3,a3,584 # ffffffffc0205658 <default_pmm_manager+0x738>
ffffffffc0203418:	00001617          	auipc	a2,0x1
ffffffffc020341c:	75860613          	addi	a2,a2,1880 # ffffffffc0204b70 <commands+0x738>
ffffffffc0203420:	10500593          	li	a1,261
ffffffffc0203424:	00002517          	auipc	a0,0x2
ffffffffc0203428:	50450513          	addi	a0,a0,1284 # ffffffffc0205928 <default_pmm_manager+0xa08>
ffffffffc020342c:	816fd0ef          	jal	ra,ffffffffc0200442 <__panic>
    assert(mm != NULL);
ffffffffc0203430:	00002697          	auipc	a3,0x2
ffffffffc0203434:	20068693          	addi	a3,a3,512 # ffffffffc0205630 <default_pmm_manager+0x710>
ffffffffc0203438:	00001617          	auipc	a2,0x1
ffffffffc020343c:	73860613          	addi	a2,a2,1848 # ffffffffc0204b70 <commands+0x738>
ffffffffc0203440:	0c200593          	li	a1,194
ffffffffc0203444:	00002517          	auipc	a0,0x2
ffffffffc0203448:	4e450513          	addi	a0,a0,1252 # ffffffffc0205928 <default_pmm_manager+0xa08>
ffffffffc020344c:	ff7fc0ef          	jal	ra,ffffffffc0200442 <__panic>

ffffffffc0203450 <do_pgfault>:
 *            was a read (0) or write (1).
 *         -- The U/S flag (bit 2) indicates whether the processor was executing at user mode (1)
 *            or supervisor mode (0) at the time of the exception.
 */
int
do_pgfault(struct mm_struct *mm, uint32_t error_code, uintptr_t addr) {
ffffffffc0203450:	1101                	addi	sp,sp,-32
    int ret = -E_INVAL;
    //try to find a vma which include addr
    struct vma_struct *vma = find_vma(mm, addr);
ffffffffc0203452:	85b2                	mv	a1,a2
do_pgfault(struct mm_struct *mm, uint32_t error_code, uintptr_t addr) {
ffffffffc0203454:	e822                	sd	s0,16(sp)
ffffffffc0203456:	e426                	sd	s1,8(sp)
ffffffffc0203458:	ec06                	sd	ra,24(sp)
ffffffffc020345a:	e04a                	sd	s2,0(sp)
ffffffffc020345c:	8432                	mv	s0,a2
ffffffffc020345e:	84aa                	mv	s1,a0
    struct vma_struct *vma = find_vma(mm, addr);
ffffffffc0203460:	8efff0ef          	jal	ra,ffffffffc0202d4e <find_vma>

    pgfault_num++;
ffffffffc0203464:	00012797          	auipc	a5,0x12
ffffffffc0203468:	0647a783          	lw	a5,100(a5) # ffffffffc02154c8 <pgfault_num>
ffffffffc020346c:	2785                	addiw	a5,a5,1
ffffffffc020346e:	00012717          	auipc	a4,0x12
ffffffffc0203472:	04f72d23          	sw	a5,90(a4) # ffffffffc02154c8 <pgfault_num>
    //If the addr is in the range of a mm's vma?
    if (vma == NULL || vma->vm_start > addr) {
ffffffffc0203476:	c931                	beqz	a0,ffffffffc02034ca <do_pgfault+0x7a>
ffffffffc0203478:	651c                	ld	a5,8(a0)
ffffffffc020347a:	04f46863          	bltu	s0,a5,ffffffffc02034ca <do_pgfault+0x7a>
     *    (read  an non_existed addr && addr is readable)
     * THEN
     *    continue process
     */
    uint32_t perm = PTE_U;
    if (vma->vm_flags & VM_WRITE) {
ffffffffc020347e:	4d1c                	lw	a5,24(a0)
    uint32_t perm = PTE_U;
ffffffffc0203480:	4941                	li	s2,16
    if (vma->vm_flags & VM_WRITE) {
ffffffffc0203482:	8b89                	andi	a5,a5,2
ffffffffc0203484:	e39d                	bnez	a5,ffffffffc02034aa <do_pgfault+0x5a>
        perm |= READ_WRITE;
    }
    addr = ROUNDDOWN(addr, PGSIZE);
ffffffffc0203486:	75fd                	lui	a1,0xfffff

    pte_t *ptep=NULL;
  
    // try to find a pte, if pte's PT(Page Table) isn't existed, then create a PT.
    // (notice the 3th parameter '1')
    if ((ptep = get_pte(mm->pgdir, addr, 1)) == NULL) {
ffffffffc0203488:	6c88                	ld	a0,24(s1)
    addr = ROUNDDOWN(addr, PGSIZE);
ffffffffc020348a:	8c6d                	and	s0,s0,a1
    if ((ptep = get_pte(mm->pgdir, addr, 1)) == NULL) {
ffffffffc020348c:	4605                	li	a2,1
ffffffffc020348e:	85a2                	mv	a1,s0
ffffffffc0203490:	eb0fe0ef          	jal	ra,ffffffffc0201b40 <get_pte>
ffffffffc0203494:	cd21                	beqz	a0,ffffffffc02034ec <do_pgfault+0x9c>
        cprintf("get_pte in do_pgfault failed\n");
        goto failed;
    }
    if (*ptep == 0) { // if the phy addr isn't exist, then alloc a page & map the phy addr with logical addr
ffffffffc0203496:	610c                	ld	a1,0(a0)
ffffffffc0203498:	c999                	beqz	a1,ffffffffc02034ae <do_pgfault+0x5e>
        *    swap_in(mm, addr, &page) : 分配一个内存页，然后根据
        *    PTE中的swap条目的addr，找到磁盘页的地址，将磁盘页的内容读入这个内存页
        *    page_insert ： 建立一个Page的phy addr与线性addr la的映射
        *    swap_map_swappable ： 设置页面可交换
        */
        if (swap_init_ok) {
ffffffffc020349a:	00012797          	auipc	a5,0x12
ffffffffc020349e:	01e7a783          	lw	a5,30(a5) # ffffffffc02154b8 <swap_init_ok>
ffffffffc02034a2:	cf8d                	beqz	a5,ffffffffc02034dc <do_pgfault+0x8c>
            //(2) According to the mm,
            //addr AND page, setup the
            //map of phy addr <--->
            //logical addr
            //(3) make the page swappable.
            page->pra_vaddr = addr;
ffffffffc02034a4:	04003023          	sd	zero,64(zero) # 40 <kern_entry-0xffffffffc01fffc0>
ffffffffc02034a8:	9002                	ebreak
        perm |= READ_WRITE;
ffffffffc02034aa:	495d                	li	s2,23
ffffffffc02034ac:	bfe9                	j	ffffffffc0203486 <do_pgfault+0x36>
        if (pgdir_alloc_page(mm->pgdir, addr, perm) == NULL) {
ffffffffc02034ae:	6c88                	ld	a0,24(s1)
ffffffffc02034b0:	864a                	mv	a2,s2
ffffffffc02034b2:	85a2                	mv	a1,s0
ffffffffc02034b4:	e92ff0ef          	jal	ra,ffffffffc0202b46 <pgdir_alloc_page>
ffffffffc02034b8:	87aa                	mv	a5,a0
            cprintf("no swap_init_ok but ptep is %x, failed\n", *ptep);
            goto failed;
        }
   }

   ret = 0;
ffffffffc02034ba:	4501                	li	a0,0
        if (pgdir_alloc_page(mm->pgdir, addr, perm) == NULL) {
ffffffffc02034bc:	c3a1                	beqz	a5,ffffffffc02034fc <do_pgfault+0xac>
failed:
    return ret;
}
ffffffffc02034be:	60e2                	ld	ra,24(sp)
ffffffffc02034c0:	6442                	ld	s0,16(sp)
ffffffffc02034c2:	64a2                	ld	s1,8(sp)
ffffffffc02034c4:	6902                	ld	s2,0(sp)
ffffffffc02034c6:	6105                	addi	sp,sp,32
ffffffffc02034c8:	8082                	ret
        cprintf("not valid addr %x, and  can not find it in vma\n", addr);
ffffffffc02034ca:	85a2                	mv	a1,s0
ffffffffc02034cc:	00002517          	auipc	a0,0x2
ffffffffc02034d0:	6d450513          	addi	a0,a0,1748 # ffffffffc0205ba0 <default_pmm_manager+0xc80>
ffffffffc02034d4:	ca9fc0ef          	jal	ra,ffffffffc020017c <cprintf>
    int ret = -E_INVAL;
ffffffffc02034d8:	5575                	li	a0,-3
        goto failed;
ffffffffc02034da:	b7d5                	j	ffffffffc02034be <do_pgfault+0x6e>
            cprintf("no swap_init_ok but ptep is %x, failed\n", *ptep);
ffffffffc02034dc:	00002517          	auipc	a0,0x2
ffffffffc02034e0:	73c50513          	addi	a0,a0,1852 # ffffffffc0205c18 <default_pmm_manager+0xcf8>
ffffffffc02034e4:	c99fc0ef          	jal	ra,ffffffffc020017c <cprintf>
    ret = -E_NO_MEM;
ffffffffc02034e8:	5571                	li	a0,-4
            goto failed;
ffffffffc02034ea:	bfd1                	j	ffffffffc02034be <do_pgfault+0x6e>
        cprintf("get_pte in do_pgfault failed\n");
ffffffffc02034ec:	00002517          	auipc	a0,0x2
ffffffffc02034f0:	6e450513          	addi	a0,a0,1764 # ffffffffc0205bd0 <default_pmm_manager+0xcb0>
ffffffffc02034f4:	c89fc0ef          	jal	ra,ffffffffc020017c <cprintf>
    ret = -E_NO_MEM;
ffffffffc02034f8:	5571                	li	a0,-4
        goto failed;
ffffffffc02034fa:	b7d1                	j	ffffffffc02034be <do_pgfault+0x6e>
            cprintf("pgdir_alloc_page in do_pgfault failed\n");
ffffffffc02034fc:	00002517          	auipc	a0,0x2
ffffffffc0203500:	6f450513          	addi	a0,a0,1780 # ffffffffc0205bf0 <default_pmm_manager+0xcd0>
ffffffffc0203504:	c79fc0ef          	jal	ra,ffffffffc020017c <cprintf>
    ret = -E_NO_MEM;
ffffffffc0203508:	5571                	li	a0,-4
            goto failed;
ffffffffc020350a:	bf55                	j	ffffffffc02034be <do_pgfault+0x6e>

ffffffffc020350c <swapfs_write>:
swapfs_read(swap_entry_t entry, struct Page *page) {
    return ide_read_secs(SWAP_DEV_NO, swap_offset(entry) * PAGE_NSECT, page2kva(page), PAGE_NSECT);
}

int
swapfs_write(swap_entry_t entry, struct Page *page) {
ffffffffc020350c:	1141                	addi	sp,sp,-16
ffffffffc020350e:	e406                	sd	ra,8(sp)
    return ide_write_secs(SWAP_DEV_NO, swap_offset(entry) * PAGE_NSECT, page2kva(page), PAGE_NSECT);
ffffffffc0203510:	00855793          	srli	a5,a0,0x8
ffffffffc0203514:	c3a5                	beqz	a5,ffffffffc0203574 <swapfs_write+0x68>
ffffffffc0203516:	00012717          	auipc	a4,0x12
ffffffffc020351a:	f9273703          	ld	a4,-110(a4) # ffffffffc02154a8 <max_swap_offset>
ffffffffc020351e:	04e7fb63          	bgeu	a5,a4,ffffffffc0203574 <swapfs_write+0x68>
    return page - pages + nbase;
ffffffffc0203522:	00012617          	auipc	a2,0x12
ffffffffc0203526:	f6e63603          	ld	a2,-146(a2) # ffffffffc0215490 <pages>
ffffffffc020352a:	8d91                	sub	a1,a1,a2
ffffffffc020352c:	4035d613          	srai	a2,a1,0x3
ffffffffc0203530:	00003597          	auipc	a1,0x3
ffffffffc0203534:	b085b583          	ld	a1,-1272(a1) # ffffffffc0206038 <error_string+0x38>
ffffffffc0203538:	02b60633          	mul	a2,a2,a1
ffffffffc020353c:	0037959b          	slliw	a1,a5,0x3
ffffffffc0203540:	00003797          	auipc	a5,0x3
ffffffffc0203544:	b007b783          	ld	a5,-1280(a5) # ffffffffc0206040 <nbase>
    return KADDR(page2pa(page));
ffffffffc0203548:	00012717          	auipc	a4,0x12
ffffffffc020354c:	f4073703          	ld	a4,-192(a4) # ffffffffc0215488 <npage>
    return page - pages + nbase;
ffffffffc0203550:	963e                	add	a2,a2,a5
    return KADDR(page2pa(page));
ffffffffc0203552:	00c61793          	slli	a5,a2,0xc
ffffffffc0203556:	83b1                	srli	a5,a5,0xc
    return page2ppn(page) << PGSHIFT;
ffffffffc0203558:	0632                	slli	a2,a2,0xc
    return KADDR(page2pa(page));
ffffffffc020355a:	02e7f963          	bgeu	a5,a4,ffffffffc020358c <swapfs_write+0x80>
}
ffffffffc020355e:	60a2                	ld	ra,8(sp)
    return ide_write_secs(SWAP_DEV_NO, swap_offset(entry) * PAGE_NSECT, page2kva(page), PAGE_NSECT);
ffffffffc0203560:	00012797          	auipc	a5,0x12
ffffffffc0203564:	f407b783          	ld	a5,-192(a5) # ffffffffc02154a0 <va_pa_offset>
ffffffffc0203568:	46a1                	li	a3,8
ffffffffc020356a:	963e                	add	a2,a2,a5
ffffffffc020356c:	4505                	li	a0,1
}
ffffffffc020356e:	0141                	addi	sp,sp,16
    return ide_write_secs(SWAP_DEV_NO, swap_offset(entry) * PAGE_NSECT, page2kva(page), PAGE_NSECT);
ffffffffc0203570:	ff5fc06f          	j	ffffffffc0200564 <ide_write_secs>
ffffffffc0203574:	86aa                	mv	a3,a0
ffffffffc0203576:	00002617          	auipc	a2,0x2
ffffffffc020357a:	70260613          	addi	a2,a2,1794 # ffffffffc0205c78 <default_pmm_manager+0xd58>
ffffffffc020357e:	45e5                	li	a1,25
ffffffffc0203580:	00002517          	auipc	a0,0x2
ffffffffc0203584:	6e050513          	addi	a0,a0,1760 # ffffffffc0205c60 <default_pmm_manager+0xd40>
ffffffffc0203588:	ebbfc0ef          	jal	ra,ffffffffc0200442 <__panic>
ffffffffc020358c:	86b2                	mv	a3,a2
ffffffffc020358e:	06900593          	li	a1,105
ffffffffc0203592:	00002617          	auipc	a2,0x2
ffffffffc0203596:	9c660613          	addi	a2,a2,-1594 # ffffffffc0204f58 <default_pmm_manager+0x38>
ffffffffc020359a:	00002517          	auipc	a0,0x2
ffffffffc020359e:	9e650513          	addi	a0,a0,-1562 # ffffffffc0204f80 <default_pmm_manager+0x60>
ffffffffc02035a2:	ea1fc0ef          	jal	ra,ffffffffc0200442 <__panic>

ffffffffc02035a6 <kernel_thread_entry>:
.text
.globl kernel_thread_entry
kernel_thread_entry:        # void kernel_thread(void)
	move a0, s1
ffffffffc02035a6:	8526                	mv	a0,s1
	jalr s0
ffffffffc02035a8:	9402                	jalr	s0

	jal do_exit
ffffffffc02035aa:	3d2000ef          	jal	ra,ffffffffc020397c <do_exit>

ffffffffc02035ae <alloc_proc>:
//恢复中断帧中的所有寄存器
//进行上下文切换，主要是结构体proc_struct中的东西，进程上下文

// alloc_proc - alloc a proc_struct and init all fields of proc_struct
static struct proc_struct *
alloc_proc(void) {
ffffffffc02035ae:	1141                	addi	sp,sp,-16
    struct proc_struct *proc = kmalloc(sizeof(struct proc_struct));
ffffffffc02035b0:	0e800513          	li	a0,232
alloc_proc(void) {
ffffffffc02035b4:	e022                	sd	s0,0(sp)
ffffffffc02035b6:	e406                	sd	ra,8(sp)
    struct proc_struct *proc = kmalloc(sizeof(struct proc_struct));
ffffffffc02035b8:	a98fe0ef          	jal	ra,ffffffffc0201850 <kmalloc>
ffffffffc02035bc:	842a                	mv	s0,a0
    if (proc != NULL) {
ffffffffc02035be:	c521                	beqz	a0,ffffffffc0203606 <alloc_proc+0x58>
     *       struct trapframe *tf;                       // Trap frame for current interrupt
     *       uintptr_t cr3;                              // CR3 register: the base addr of Page Directroy Table(PDT)
     *       uint32_t flags;                             // Process flag
     *       char name[PROC_NAME_LEN + 1];               // Process name
     */
     proc->state=PROC_UNINIT;
ffffffffc02035c0:	57fd                	li	a5,-1
ffffffffc02035c2:	1782                	slli	a5,a5,0x20
ffffffffc02035c4:	e11c                	sd	a5,0(a0)
     proc->runs=0;
     proc->kstack=0;
     proc->need_resched=0;
     proc->parent=NULL;
     proc->mm=NULL;
     memset(&(proc->context),0,sizeof(struct context));
ffffffffc02035c6:	07000613          	li	a2,112
ffffffffc02035ca:	4581                	li	a1,0
     proc->runs=0;
ffffffffc02035cc:	00052423          	sw	zero,8(a0)
     proc->kstack=0;
ffffffffc02035d0:	00053823          	sd	zero,16(a0)
     proc->need_resched=0;
ffffffffc02035d4:	00052c23          	sw	zero,24(a0)
     proc->parent=NULL;
ffffffffc02035d8:	02053023          	sd	zero,32(a0)
     proc->mm=NULL;
ffffffffc02035dc:	02053423          	sd	zero,40(a0)
     memset(&(proc->context),0,sizeof(struct context));
ffffffffc02035e0:	03050513          	addi	a0,a0,48
ffffffffc02035e4:	39b000ef          	jal	ra,ffffffffc020417e <memset>
     proc->tf=NULL;
     proc->cr3=boot_cr3;
ffffffffc02035e8:	00012797          	auipc	a5,0x12
ffffffffc02035ec:	e907b783          	ld	a5,-368(a5) # ffffffffc0215478 <boot_cr3>
     proc->tf=NULL;
ffffffffc02035f0:	0a043023          	sd	zero,160(s0)
     proc->cr3=boot_cr3;
ffffffffc02035f4:	f45c                	sd	a5,168(s0)
     proc->flags=0;
ffffffffc02035f6:	0a042823          	sw	zero,176(s0)
     memset(proc->name,0,PROC_NAME_LEN);
ffffffffc02035fa:	463d                	li	a2,15
ffffffffc02035fc:	4581                	li	a1,0
ffffffffc02035fe:	0b440513          	addi	a0,s0,180
ffffffffc0203602:	37d000ef          	jal	ra,ffffffffc020417e <memset>
    }
    return proc;
}
ffffffffc0203606:	60a2                	ld	ra,8(sp)
ffffffffc0203608:	8522                	mv	a0,s0
ffffffffc020360a:	6402                	ld	s0,0(sp)
ffffffffc020360c:	0141                	addi	sp,sp,16
ffffffffc020360e:	8082                	ret

ffffffffc0203610 <forkret>:
// forkret -- the first kernel entry point of a new thread/process
// NOTE: the addr of forkret is setted in copy_thread function
//       after switch_to, the current proc will execute here.
static void
forkret(void) {
    forkrets(current->tf);
ffffffffc0203610:	00012797          	auipc	a5,0x12
ffffffffc0203614:	ec07b783          	ld	a5,-320(a5) # ffffffffc02154d0 <current>
ffffffffc0203618:	73c8                	ld	a0,160(a5)
ffffffffc020361a:	d1efd06f          	j	ffffffffc0200b38 <forkrets>

ffffffffc020361e <init_main>:
int do_exit(int error_code) {
    panic("process exit!!.\n");
}

// init_main - the second kernel thread used to create user_main kernel threads
static int init_main(void *arg) {
ffffffffc020361e:	7179                	addi	sp,sp,-48
ffffffffc0203620:	ec26                	sd	s1,24(sp)
    memset(name, 0, sizeof(name));
ffffffffc0203622:	00012497          	auipc	s1,0x12
ffffffffc0203626:	e1648493          	addi	s1,s1,-490 # ffffffffc0215438 <name.2>
static int init_main(void *arg) {
ffffffffc020362a:	f022                	sd	s0,32(sp)
ffffffffc020362c:	e84a                	sd	s2,16(sp)
ffffffffc020362e:	842a                	mv	s0,a0
    cprintf("this initproc, pid = %d, name = \"%s\"\n", current->pid, get_proc_name(current));
ffffffffc0203630:	00012917          	auipc	s2,0x12
ffffffffc0203634:	ea093903          	ld	s2,-352(s2) # ffffffffc02154d0 <current>
    memset(name, 0, sizeof(name));
ffffffffc0203638:	4641                	li	a2,16
ffffffffc020363a:	4581                	li	a1,0
ffffffffc020363c:	8526                	mv	a0,s1
static int init_main(void *arg) {
ffffffffc020363e:	f406                	sd	ra,40(sp)
ffffffffc0203640:	e44e                	sd	s3,8(sp)
    cprintf("this initproc, pid = %d, name = \"%s\"\n", current->pid, get_proc_name(current));
ffffffffc0203642:	00492983          	lw	s3,4(s2)
    memset(name, 0, sizeof(name));
ffffffffc0203646:	339000ef          	jal	ra,ffffffffc020417e <memset>
    return memcpy(name, proc->name, PROC_NAME_LEN);
ffffffffc020364a:	0b490593          	addi	a1,s2,180
ffffffffc020364e:	463d                	li	a2,15
ffffffffc0203650:	8526                	mv	a0,s1
ffffffffc0203652:	33f000ef          	jal	ra,ffffffffc0204190 <memcpy>
ffffffffc0203656:	862a                	mv	a2,a0
    cprintf("this initproc, pid = %d, name = \"%s\"\n", current->pid, get_proc_name(current));
ffffffffc0203658:	85ce                	mv	a1,s3
ffffffffc020365a:	00002517          	auipc	a0,0x2
ffffffffc020365e:	63e50513          	addi	a0,a0,1598 # ffffffffc0205c98 <default_pmm_manager+0xd78>
ffffffffc0203662:	b1bfc0ef          	jal	ra,ffffffffc020017c <cprintf>
    cprintf("To U: \"%s\".\n", (const char *)arg);
ffffffffc0203666:	85a2                	mv	a1,s0
ffffffffc0203668:	00002517          	auipc	a0,0x2
ffffffffc020366c:	65850513          	addi	a0,a0,1624 # ffffffffc0205cc0 <default_pmm_manager+0xda0>
ffffffffc0203670:	b0dfc0ef          	jal	ra,ffffffffc020017c <cprintf>
    cprintf("To U: \"en.., Bye, Bye. :)\"\n");
ffffffffc0203674:	00002517          	auipc	a0,0x2
ffffffffc0203678:	65c50513          	addi	a0,a0,1628 # ffffffffc0205cd0 <default_pmm_manager+0xdb0>
ffffffffc020367c:	b01fc0ef          	jal	ra,ffffffffc020017c <cprintf>
    return 0;
}
ffffffffc0203680:	70a2                	ld	ra,40(sp)
ffffffffc0203682:	7402                	ld	s0,32(sp)
ffffffffc0203684:	64e2                	ld	s1,24(sp)
ffffffffc0203686:	6942                	ld	s2,16(sp)
ffffffffc0203688:	69a2                	ld	s3,8(sp)
ffffffffc020368a:	4501                	li	a0,0
ffffffffc020368c:	6145                	addi	sp,sp,48
ffffffffc020368e:	8082                	ret

ffffffffc0203690 <proc_run>:
proc_run(struct proc_struct *proc) {
ffffffffc0203690:	7179                	addi	sp,sp,-48
ffffffffc0203692:	ec4a                	sd	s2,24(sp)
    if (proc != current) {
ffffffffc0203694:	00012917          	auipc	s2,0x12
ffffffffc0203698:	e3c90913          	addi	s2,s2,-452 # ffffffffc02154d0 <current>
proc_run(struct proc_struct *proc) {
ffffffffc020369c:	f026                	sd	s1,32(sp)
    if (proc != current) {
ffffffffc020369e:	00093483          	ld	s1,0(s2)
proc_run(struct proc_struct *proc) {
ffffffffc02036a2:	f406                	sd	ra,40(sp)
ffffffffc02036a4:	e84e                	sd	s3,16(sp)
    if (proc != current) {
ffffffffc02036a6:	02a48963          	beq	s1,a0,ffffffffc02036d8 <proc_run+0x48>
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc02036aa:	100027f3          	csrr	a5,sstatus
ffffffffc02036ae:	8b89                	andi	a5,a5,2
    return 0;
ffffffffc02036b0:	4981                	li	s3,0
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc02036b2:	e3a1                	bnez	a5,ffffffffc02036f2 <proc_run+0x62>
        lcr3(next->cr3);
ffffffffc02036b4:	755c                	ld	a5,168(a0)

#define barrier() __asm__ __volatile__ ("fence" ::: "memory")

static inline void
lcr3(unsigned int cr3) {
    write_csr(sptbr, SATP32_MODE | (cr3 >> RISCV_PGSHIFT));
ffffffffc02036b6:	80000737          	lui	a4,0x80000
        current = proc;
ffffffffc02036ba:	00a93023          	sd	a0,0(s2)
ffffffffc02036be:	00c7d79b          	srliw	a5,a5,0xc
ffffffffc02036c2:	8fd9                	or	a5,a5,a4
ffffffffc02036c4:	18079073          	csrw	satp,a5
        switch_to(&(prev->context), &(next->context));
ffffffffc02036c8:	03050593          	addi	a1,a0,48
ffffffffc02036cc:	03048513          	addi	a0,s1,48
ffffffffc02036d0:	530000ef          	jal	ra,ffffffffc0203c00 <switch_to>
    if (flag) {
ffffffffc02036d4:	00099863          	bnez	s3,ffffffffc02036e4 <proc_run+0x54>
}
ffffffffc02036d8:	70a2                	ld	ra,40(sp)
ffffffffc02036da:	7482                	ld	s1,32(sp)
ffffffffc02036dc:	6962                	ld	s2,24(sp)
ffffffffc02036de:	69c2                	ld	s3,16(sp)
ffffffffc02036e0:	6145                	addi	sp,sp,48
ffffffffc02036e2:	8082                	ret
ffffffffc02036e4:	70a2                	ld	ra,40(sp)
ffffffffc02036e6:	7482                	ld	s1,32(sp)
ffffffffc02036e8:	6962                	ld	s2,24(sp)
ffffffffc02036ea:	69c2                	ld	s3,16(sp)
ffffffffc02036ec:	6145                	addi	sp,sp,48
        intr_enable();
ffffffffc02036ee:	e9bfc06f          	j	ffffffffc0200588 <intr_enable>
ffffffffc02036f2:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc02036f4:	e9bfc0ef          	jal	ra,ffffffffc020058e <intr_disable>
        return 1;
ffffffffc02036f8:	6522                	ld	a0,8(sp)
ffffffffc02036fa:	4985                	li	s3,1
ffffffffc02036fc:	bf65                	j	ffffffffc02036b4 <proc_run+0x24>

ffffffffc02036fe <do_fork>:
int do_fork(uint32_t clone_flags, uintptr_t stack, struct trapframe *tf) {
ffffffffc02036fe:	7179                	addi	sp,sp,-48
ffffffffc0203700:	e84a                	sd	s2,16(sp)
    if (nr_process >= MAX_PROCESS) {
ffffffffc0203702:	00012917          	auipc	s2,0x12
ffffffffc0203706:	de690913          	addi	s2,s2,-538 # ffffffffc02154e8 <nr_process>
ffffffffc020370a:	00092703          	lw	a4,0(s2)
int do_fork(uint32_t clone_flags, uintptr_t stack, struct trapframe *tf) {
ffffffffc020370e:	f406                	sd	ra,40(sp)
ffffffffc0203710:	f022                	sd	s0,32(sp)
ffffffffc0203712:	ec26                	sd	s1,24(sp)
ffffffffc0203714:	e44e                	sd	s3,8(sp)
ffffffffc0203716:	e052                	sd	s4,0(sp)
    if (nr_process >= MAX_PROCESS) {
ffffffffc0203718:	6785                	lui	a5,0x1
ffffffffc020371a:	1cf75863          	bge	a4,a5,ffffffffc02038ea <do_fork+0x1ec>
ffffffffc020371e:	84ae                	mv	s1,a1
ffffffffc0203720:	8a32                	mv	s4,a2
    proc->parent = current;
ffffffffc0203722:	00012997          	auipc	s3,0x12
ffffffffc0203726:	dae98993          	addi	s3,s3,-594 # ffffffffc02154d0 <current>
    proc = alloc_proc();
ffffffffc020372a:	e85ff0ef          	jal	ra,ffffffffc02035ae <alloc_proc>
    proc->parent = current;
ffffffffc020372e:	0009b783          	ld	a5,0(s3)
    proc = alloc_proc();
ffffffffc0203732:	842a                	mv	s0,a0
    struct Page *page = alloc_pages(KSTACKPAGE);
ffffffffc0203734:	4509                	li	a0,2
    proc->parent = current;
ffffffffc0203736:	f01c                	sd	a5,32(s0)
    struct Page *page = alloc_pages(KSTACKPAGE);
ffffffffc0203738:	afcfe0ef          	jal	ra,ffffffffc0201a34 <alloc_pages>
    if (page != NULL) {
ffffffffc020373c:	c139                	beqz	a0,ffffffffc0203782 <do_fork+0x84>
    return page - pages + nbase;
ffffffffc020373e:	00012697          	auipc	a3,0x12
ffffffffc0203742:	d526b683          	ld	a3,-686(a3) # ffffffffc0215490 <pages>
ffffffffc0203746:	40d506b3          	sub	a3,a0,a3
ffffffffc020374a:	868d                	srai	a3,a3,0x3
ffffffffc020374c:	00003517          	auipc	a0,0x3
ffffffffc0203750:	8ec53503          	ld	a0,-1812(a0) # ffffffffc0206038 <error_string+0x38>
ffffffffc0203754:	02a686b3          	mul	a3,a3,a0
ffffffffc0203758:	00003797          	auipc	a5,0x3
ffffffffc020375c:	8e87b783          	ld	a5,-1816(a5) # ffffffffc0206040 <nbase>
    return KADDR(page2pa(page));
ffffffffc0203760:	00012717          	auipc	a4,0x12
ffffffffc0203764:	d2873703          	ld	a4,-728(a4) # ffffffffc0215488 <npage>
    return page - pages + nbase;
ffffffffc0203768:	96be                	add	a3,a3,a5
    return KADDR(page2pa(page));
ffffffffc020376a:	00c69793          	slli	a5,a3,0xc
ffffffffc020376e:	83b1                	srli	a5,a5,0xc
    return page2ppn(page) << PGSHIFT;
ffffffffc0203770:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0203772:	1ae7f163          	bgeu	a5,a4,ffffffffc0203914 <do_fork+0x216>
ffffffffc0203776:	00012797          	auipc	a5,0x12
ffffffffc020377a:	d2a7b783          	ld	a5,-726(a5) # ffffffffc02154a0 <va_pa_offset>
ffffffffc020377e:	96be                	add	a3,a3,a5
        proc->kstack = (uintptr_t)page2kva(page);
ffffffffc0203780:	e814                	sd	a3,16(s0)
    assert(current->mm == NULL);
ffffffffc0203782:	0009b783          	ld	a5,0(s3)
ffffffffc0203786:	779c                	ld	a5,40(a5)
ffffffffc0203788:	16079663          	bnez	a5,ffffffffc02038f4 <do_fork+0x1f6>
    proc->tf = (struct trapframe *)(proc->kstack + KSTACKSIZE - sizeof(struct trapframe));
ffffffffc020378c:	6818                	ld	a4,16(s0)
ffffffffc020378e:	6789                	lui	a5,0x2
ffffffffc0203790:	ee078793          	addi	a5,a5,-288 # 1ee0 <kern_entry-0xffffffffc01fe120>
ffffffffc0203794:	973e                	add	a4,a4,a5
    *(proc->tf) = *tf;
ffffffffc0203796:	8652                	mv	a2,s4
    proc->tf = (struct trapframe *)(proc->kstack + KSTACKSIZE - sizeof(struct trapframe));
ffffffffc0203798:	f058                	sd	a4,160(s0)
    *(proc->tf) = *tf;
ffffffffc020379a:	87ba                	mv	a5,a4
ffffffffc020379c:	120a0593          	addi	a1,s4,288
ffffffffc02037a0:	00063883          	ld	a7,0(a2)
ffffffffc02037a4:	00863803          	ld	a6,8(a2)
ffffffffc02037a8:	6a08                	ld	a0,16(a2)
ffffffffc02037aa:	6e14                	ld	a3,24(a2)
ffffffffc02037ac:	0117b023          	sd	a7,0(a5)
ffffffffc02037b0:	0107b423          	sd	a6,8(a5)
ffffffffc02037b4:	eb88                	sd	a0,16(a5)
ffffffffc02037b6:	ef94                	sd	a3,24(a5)
ffffffffc02037b8:	02060613          	addi	a2,a2,32
ffffffffc02037bc:	02078793          	addi	a5,a5,32
ffffffffc02037c0:	feb610e3          	bne	a2,a1,ffffffffc02037a0 <do_fork+0xa2>
    proc->tf->gpr.a0 = 0;
ffffffffc02037c4:	04073823          	sd	zero,80(a4)
    proc->tf->gpr.sp = (esp == 0) ? (uintptr_t)proc->tf : esp;
ffffffffc02037c8:	10048563          	beqz	s1,ffffffffc02038d2 <do_fork+0x1d4>
    if (++ last_pid >= MAX_PID) {
ffffffffc02037cc:	00007817          	auipc	a6,0x7
ffffffffc02037d0:	84c80813          	addi	a6,a6,-1972 # ffffffffc020a018 <last_pid.1>
ffffffffc02037d4:	00082783          	lw	a5,0(a6)
    proc->tf->gpr.sp = (esp == 0) ? (uintptr_t)proc->tf : esp;
ffffffffc02037d8:	eb04                	sd	s1,16(a4)
    proc->context.ra = (uintptr_t)forkret;
ffffffffc02037da:	00000697          	auipc	a3,0x0
ffffffffc02037de:	e3668693          	addi	a3,a3,-458 # ffffffffc0203610 <forkret>
    if (++ last_pid >= MAX_PID) {
ffffffffc02037e2:	0017851b          	addiw	a0,a5,1
    proc->context.ra = (uintptr_t)forkret;
ffffffffc02037e6:	f814                	sd	a3,48(s0)
    proc->context.sp = (uintptr_t)(proc->tf);
ffffffffc02037e8:	fc18                	sd	a4,56(s0)
    if (++ last_pid >= MAX_PID) {
ffffffffc02037ea:	00a82023          	sw	a0,0(a6)
ffffffffc02037ee:	6789                	lui	a5,0x2
ffffffffc02037f0:	06f55a63          	bge	a0,a5,ffffffffc0203864 <do_fork+0x166>
    if (last_pid >= next_safe) {
ffffffffc02037f4:	00007317          	auipc	t1,0x7
ffffffffc02037f8:	82830313          	addi	t1,t1,-2008 # ffffffffc020a01c <next_safe.0>
ffffffffc02037fc:	00032783          	lw	a5,0(t1)
ffffffffc0203800:	00012497          	auipc	s1,0x12
ffffffffc0203804:	c4848493          	addi	s1,s1,-952 # ffffffffc0215448 <proc_list>
ffffffffc0203808:	06f55663          	bge	a0,a5,ffffffffc0203874 <do_fork+0x176>
    proc->pid = pid;
ffffffffc020380c:	c048                	sw	a0,4(s0)
    list_add(hash_list + pid_hashfn(proc->pid), &(proc->hash_link));
ffffffffc020380e:	45a9                	li	a1,10
ffffffffc0203810:	2501                	sext.w	a0,a0
ffffffffc0203812:	4ec000ef          	jal	ra,ffffffffc0203cfe <hash32>
ffffffffc0203816:	02051793          	slli	a5,a0,0x20
ffffffffc020381a:	0000e717          	auipc	a4,0xe
ffffffffc020381e:	c1e70713          	addi	a4,a4,-994 # ffffffffc0211438 <hash_list>
ffffffffc0203822:	83f1                	srli	a5,a5,0x1c
ffffffffc0203824:	97ba                	add	a5,a5,a4
    __list_add(elm, listelm, listelm->next);
ffffffffc0203826:	678c                	ld	a1,8(a5)
ffffffffc0203828:	0d840713          	addi	a4,s0,216
ffffffffc020382c:	6494                	ld	a3,8(s1)
    prev->next = next->prev = elm;
ffffffffc020382e:	e198                	sd	a4,0(a1)
ffffffffc0203830:	e798                	sd	a4,8(a5)
    nr_process++;
ffffffffc0203832:	00092703          	lw	a4,0(s2)
    list_add(&proc_list, &(proc->list_link));
ffffffffc0203836:	0c840613          	addi	a2,s0,200
    elm->prev = prev;
ffffffffc020383a:	ec7c                	sd	a5,216(s0)
    elm->next = next;
ffffffffc020383c:	f06c                	sd	a1,224(s0)
    prev->next = next->prev = elm;
ffffffffc020383e:	e290                	sd	a2,0(a3)
    nr_process++;
ffffffffc0203840:	0017079b          	addiw	a5,a4,1
    ret = proc->pid; 
ffffffffc0203844:	4048                	lw	a0,4(s0)
ffffffffc0203846:	e490                	sd	a2,8(s1)
    nr_process++;
ffffffffc0203848:	00f92023          	sw	a5,0(s2)
    proc->state = PROC_RUNNABLE;
ffffffffc020384c:	4789                	li	a5,2
    elm->next = next;
ffffffffc020384e:	e874                	sd	a3,208(s0)
    elm->prev = prev;
ffffffffc0203850:	e464                	sd	s1,200(s0)
ffffffffc0203852:	c01c                	sw	a5,0(s0)
}
ffffffffc0203854:	70a2                	ld	ra,40(sp)
ffffffffc0203856:	7402                	ld	s0,32(sp)
ffffffffc0203858:	64e2                	ld	s1,24(sp)
ffffffffc020385a:	6942                	ld	s2,16(sp)
ffffffffc020385c:	69a2                	ld	s3,8(sp)
ffffffffc020385e:	6a02                	ld	s4,0(sp)
ffffffffc0203860:	6145                	addi	sp,sp,48
ffffffffc0203862:	8082                	ret
        last_pid = 1;
ffffffffc0203864:	4785                	li	a5,1
ffffffffc0203866:	00f82023          	sw	a5,0(a6)
        goto inside;
ffffffffc020386a:	4505                	li	a0,1
ffffffffc020386c:	00006317          	auipc	t1,0x6
ffffffffc0203870:	7b030313          	addi	t1,t1,1968 # ffffffffc020a01c <next_safe.0>
    return listelm->next;
ffffffffc0203874:	00012497          	auipc	s1,0x12
ffffffffc0203878:	bd448493          	addi	s1,s1,-1068 # ffffffffc0215448 <proc_list>
ffffffffc020387c:	0084be03          	ld	t3,8(s1)
        next_safe = MAX_PID;
ffffffffc0203880:	6789                	lui	a5,0x2
ffffffffc0203882:	00f32023          	sw	a5,0(t1)
ffffffffc0203886:	86aa                	mv	a3,a0
ffffffffc0203888:	4581                	li	a1,0
        while ((le = list_next(le)) != list) {
ffffffffc020388a:	6e89                	lui	t4,0x2
ffffffffc020388c:	049e0a63          	beq	t3,s1,ffffffffc02038e0 <do_fork+0x1e2>
ffffffffc0203890:	88ae                	mv	a7,a1
ffffffffc0203892:	87f2                	mv	a5,t3
ffffffffc0203894:	6609                	lui	a2,0x2
ffffffffc0203896:	a811                	j	ffffffffc02038aa <do_fork+0x1ac>
            else if (proc->pid > last_pid && next_safe > proc->pid) {
ffffffffc0203898:	00e6d663          	bge	a3,a4,ffffffffc02038a4 <do_fork+0x1a6>
ffffffffc020389c:	00c75463          	bge	a4,a2,ffffffffc02038a4 <do_fork+0x1a6>
ffffffffc02038a0:	863a                	mv	a2,a4
ffffffffc02038a2:	4885                	li	a7,1
ffffffffc02038a4:	679c                	ld	a5,8(a5)
        while ((le = list_next(le)) != list) {
ffffffffc02038a6:	00978d63          	beq	a5,s1,ffffffffc02038c0 <do_fork+0x1c2>
            if (proc->pid == last_pid) {
ffffffffc02038aa:	f3c7a703          	lw	a4,-196(a5) # 1f3c <kern_entry-0xffffffffc01fe0c4>
ffffffffc02038ae:	fed715e3          	bne	a4,a3,ffffffffc0203898 <do_fork+0x19a>
                if (++ last_pid >= next_safe) {
ffffffffc02038b2:	2685                	addiw	a3,a3,1
ffffffffc02038b4:	02c6d163          	bge	a3,a2,ffffffffc02038d6 <do_fork+0x1d8>
ffffffffc02038b8:	679c                	ld	a5,8(a5)
ffffffffc02038ba:	4585                	li	a1,1
        while ((le = list_next(le)) != list) {
ffffffffc02038bc:	fe9797e3          	bne	a5,s1,ffffffffc02038aa <do_fork+0x1ac>
ffffffffc02038c0:	c581                	beqz	a1,ffffffffc02038c8 <do_fork+0x1ca>
ffffffffc02038c2:	00d82023          	sw	a3,0(a6)
ffffffffc02038c6:	8536                	mv	a0,a3
ffffffffc02038c8:	f40882e3          	beqz	a7,ffffffffc020380c <do_fork+0x10e>
ffffffffc02038cc:	00c32023          	sw	a2,0(t1)
ffffffffc02038d0:	bf35                	j	ffffffffc020380c <do_fork+0x10e>
    proc->tf->gpr.sp = (esp == 0) ? (uintptr_t)proc->tf : esp;
ffffffffc02038d2:	84ba                	mv	s1,a4
ffffffffc02038d4:	bde5                	j	ffffffffc02037cc <do_fork+0xce>
                    if (last_pid >= MAX_PID) {
ffffffffc02038d6:	01d6c363          	blt	a3,t4,ffffffffc02038dc <do_fork+0x1de>
                        last_pid = 1;
ffffffffc02038da:	4685                	li	a3,1
                    goto repeat;
ffffffffc02038dc:	4585                	li	a1,1
ffffffffc02038de:	b77d                	j	ffffffffc020388c <do_fork+0x18e>
ffffffffc02038e0:	c599                	beqz	a1,ffffffffc02038ee <do_fork+0x1f0>
ffffffffc02038e2:	00d82023          	sw	a3,0(a6)
    return last_pid;
ffffffffc02038e6:	8536                	mv	a0,a3
ffffffffc02038e8:	b715                	j	ffffffffc020380c <do_fork+0x10e>
    int ret = -E_NO_FREE_PROC;
ffffffffc02038ea:	556d                	li	a0,-5
    return ret;
ffffffffc02038ec:	b7a5                	j	ffffffffc0203854 <do_fork+0x156>
    return last_pid;
ffffffffc02038ee:	00082503          	lw	a0,0(a6)
ffffffffc02038f2:	bf29                	j	ffffffffc020380c <do_fork+0x10e>
    assert(current->mm == NULL);
ffffffffc02038f4:	00002697          	auipc	a3,0x2
ffffffffc02038f8:	3fc68693          	addi	a3,a3,1020 # ffffffffc0205cf0 <default_pmm_manager+0xdd0>
ffffffffc02038fc:	00001617          	auipc	a2,0x1
ffffffffc0203900:	27460613          	addi	a2,a2,628 # ffffffffc0204b70 <commands+0x738>
ffffffffc0203904:	10300593          	li	a1,259
ffffffffc0203908:	00002517          	auipc	a0,0x2
ffffffffc020390c:	40050513          	addi	a0,a0,1024 # ffffffffc0205d08 <default_pmm_manager+0xde8>
ffffffffc0203910:	b33fc0ef          	jal	ra,ffffffffc0200442 <__panic>
ffffffffc0203914:	00001617          	auipc	a2,0x1
ffffffffc0203918:	64460613          	addi	a2,a2,1604 # ffffffffc0204f58 <default_pmm_manager+0x38>
ffffffffc020391c:	06900593          	li	a1,105
ffffffffc0203920:	00001517          	auipc	a0,0x1
ffffffffc0203924:	66050513          	addi	a0,a0,1632 # ffffffffc0204f80 <default_pmm_manager+0x60>
ffffffffc0203928:	b1bfc0ef          	jal	ra,ffffffffc0200442 <__panic>

ffffffffc020392c <kernel_thread>:
kernel_thread(int (*fn)(void *), void *arg, uint32_t clone_flags) {
ffffffffc020392c:	7129                	addi	sp,sp,-320
ffffffffc020392e:	fa22                	sd	s0,304(sp)
ffffffffc0203930:	f626                	sd	s1,296(sp)
ffffffffc0203932:	f24a                	sd	s2,288(sp)
ffffffffc0203934:	84ae                	mv	s1,a1
ffffffffc0203936:	892a                	mv	s2,a0
ffffffffc0203938:	8432                	mv	s0,a2
    memset(&tf, 0, sizeof(struct trapframe));
ffffffffc020393a:	4581                	li	a1,0
ffffffffc020393c:	12000613          	li	a2,288
ffffffffc0203940:	850a                	mv	a0,sp
kernel_thread(int (*fn)(void *), void *arg, uint32_t clone_flags) {
ffffffffc0203942:	fe06                	sd	ra,312(sp)
    memset(&tf, 0, sizeof(struct trapframe));
ffffffffc0203944:	03b000ef          	jal	ra,ffffffffc020417e <memset>
    tf.gpr.s0 = (uintptr_t)fn;
ffffffffc0203948:	e0ca                	sd	s2,64(sp)
    tf.gpr.s1 = (uintptr_t)arg;
ffffffffc020394a:	e4a6                	sd	s1,72(sp)
    tf.status = (read_csr(sstatus) | SSTATUS_SPP | SSTATUS_SPIE) & ~SSTATUS_SIE;
ffffffffc020394c:	100027f3          	csrr	a5,sstatus
ffffffffc0203950:	edd7f793          	andi	a5,a5,-291
ffffffffc0203954:	1207e793          	ori	a5,a5,288
ffffffffc0203958:	e23e                	sd	a5,256(sp)
    return do_fork(clone_flags | CLONE_VM, 0, &tf);
ffffffffc020395a:	860a                	mv	a2,sp
ffffffffc020395c:	10046513          	ori	a0,s0,256
    tf.epc = (uintptr_t)kernel_thread_entry;
ffffffffc0203960:	00000797          	auipc	a5,0x0
ffffffffc0203964:	c4678793          	addi	a5,a5,-954 # ffffffffc02035a6 <kernel_thread_entry>
    return do_fork(clone_flags | CLONE_VM, 0, &tf);
ffffffffc0203968:	4581                	li	a1,0
    tf.epc = (uintptr_t)kernel_thread_entry;
ffffffffc020396a:	e63e                	sd	a5,264(sp)
    return do_fork(clone_flags | CLONE_VM, 0, &tf);
ffffffffc020396c:	d93ff0ef          	jal	ra,ffffffffc02036fe <do_fork>
}
ffffffffc0203970:	70f2                	ld	ra,312(sp)
ffffffffc0203972:	7452                	ld	s0,304(sp)
ffffffffc0203974:	74b2                	ld	s1,296(sp)
ffffffffc0203976:	7912                	ld	s2,288(sp)
ffffffffc0203978:	6131                	addi	sp,sp,320
ffffffffc020397a:	8082                	ret

ffffffffc020397c <do_exit>:
int do_exit(int error_code) {
ffffffffc020397c:	1141                	addi	sp,sp,-16
    panic("process exit!!.\n");
ffffffffc020397e:	00002617          	auipc	a2,0x2
ffffffffc0203982:	3a260613          	addi	a2,a2,930 # ffffffffc0205d20 <default_pmm_manager+0xe00>
ffffffffc0203986:	13f00593          	li	a1,319
ffffffffc020398a:	00002517          	auipc	a0,0x2
ffffffffc020398e:	37e50513          	addi	a0,a0,894 # ffffffffc0205d08 <default_pmm_manager+0xde8>
int do_exit(int error_code) {
ffffffffc0203992:	e406                	sd	ra,8(sp)
    panic("process exit!!.\n");
ffffffffc0203994:	aaffc0ef          	jal	ra,ffffffffc0200442 <__panic>

ffffffffc0203998 <proc_init>:

// proc_init - set up the first kernel thread idleproc "idle" by itself and 
//           - create the second kernel thread init_main
void proc_init(void) {
ffffffffc0203998:	7179                	addi	sp,sp,-48
ffffffffc020399a:	ec26                	sd	s1,24(sp)
    elm->prev = elm->next = elm;
ffffffffc020399c:	00012797          	auipc	a5,0x12
ffffffffc02039a0:	aac78793          	addi	a5,a5,-1364 # ffffffffc0215448 <proc_list>
ffffffffc02039a4:	f406                	sd	ra,40(sp)
ffffffffc02039a6:	f022                	sd	s0,32(sp)
ffffffffc02039a8:	e84a                	sd	s2,16(sp)
ffffffffc02039aa:	e44e                	sd	s3,8(sp)
ffffffffc02039ac:	0000e497          	auipc	s1,0xe
ffffffffc02039b0:	a8c48493          	addi	s1,s1,-1396 # ffffffffc0211438 <hash_list>
ffffffffc02039b4:	e79c                	sd	a5,8(a5)
ffffffffc02039b6:	e39c                	sd	a5,0(a5)
    int i;

    list_init(&proc_list);
    for (i = 0; i < HASH_LIST_SIZE; i ++) {
ffffffffc02039b8:	00012717          	auipc	a4,0x12
ffffffffc02039bc:	a8070713          	addi	a4,a4,-1408 # ffffffffc0215438 <name.2>
ffffffffc02039c0:	87a6                	mv	a5,s1
ffffffffc02039c2:	e79c                	sd	a5,8(a5)
ffffffffc02039c4:	e39c                	sd	a5,0(a5)
ffffffffc02039c6:	07c1                	addi	a5,a5,16
ffffffffc02039c8:	fef71de3          	bne	a4,a5,ffffffffc02039c2 <proc_init+0x2a>
        list_init(hash_list + i);
    }

    if ((idleproc = alloc_proc()) == NULL) {
ffffffffc02039cc:	be3ff0ef          	jal	ra,ffffffffc02035ae <alloc_proc>
ffffffffc02039d0:	00012917          	auipc	s2,0x12
ffffffffc02039d4:	b0890913          	addi	s2,s2,-1272 # ffffffffc02154d8 <idleproc>
ffffffffc02039d8:	00a93023          	sd	a0,0(s2)
ffffffffc02039dc:	18050c63          	beqz	a0,ffffffffc0203b74 <proc_init+0x1dc>
        panic("cannot alloc idleproc.\n");
    }

    // check the proc structure
    int *context_mem = (int*) kmalloc(sizeof(struct context));
ffffffffc02039e0:	07000513          	li	a0,112
ffffffffc02039e4:	e6dfd0ef          	jal	ra,ffffffffc0201850 <kmalloc>
    memset(context_mem, 0, sizeof(struct context));
ffffffffc02039e8:	07000613          	li	a2,112
ffffffffc02039ec:	4581                	li	a1,0
    int *context_mem = (int*) kmalloc(sizeof(struct context));
ffffffffc02039ee:	842a                	mv	s0,a0
    memset(context_mem, 0, sizeof(struct context));
ffffffffc02039f0:	78e000ef          	jal	ra,ffffffffc020417e <memset>
    int context_init_flag = memcmp(&(idleproc->context), context_mem, sizeof(struct context));
ffffffffc02039f4:	00093503          	ld	a0,0(s2)
ffffffffc02039f8:	85a2                	mv	a1,s0
ffffffffc02039fa:	07000613          	li	a2,112
ffffffffc02039fe:	03050513          	addi	a0,a0,48
ffffffffc0203a02:	7a6000ef          	jal	ra,ffffffffc02041a8 <memcmp>
ffffffffc0203a06:	89aa                	mv	s3,a0

    int *proc_name_mem = (int*) kmalloc(PROC_NAME_LEN);
ffffffffc0203a08:	453d                	li	a0,15
ffffffffc0203a0a:	e47fd0ef          	jal	ra,ffffffffc0201850 <kmalloc>
    memset(proc_name_mem, 0, PROC_NAME_LEN);
ffffffffc0203a0e:	463d                	li	a2,15
ffffffffc0203a10:	4581                	li	a1,0
    int *proc_name_mem = (int*) kmalloc(PROC_NAME_LEN);
ffffffffc0203a12:	842a                	mv	s0,a0
    memset(proc_name_mem, 0, PROC_NAME_LEN);
ffffffffc0203a14:	76a000ef          	jal	ra,ffffffffc020417e <memset>
    int proc_name_flag = memcmp(&(idleproc->name), proc_name_mem, PROC_NAME_LEN);
ffffffffc0203a18:	00093503          	ld	a0,0(s2)
ffffffffc0203a1c:	463d                	li	a2,15
ffffffffc0203a1e:	85a2                	mv	a1,s0
ffffffffc0203a20:	0b450513          	addi	a0,a0,180
ffffffffc0203a24:	784000ef          	jal	ra,ffffffffc02041a8 <memcmp>

    if(idleproc->cr3 == boot_cr3 && idleproc->tf == NULL && !context_init_flag
ffffffffc0203a28:	00093783          	ld	a5,0(s2)
ffffffffc0203a2c:	00012717          	auipc	a4,0x12
ffffffffc0203a30:	a4c73703          	ld	a4,-1460(a4) # ffffffffc0215478 <boot_cr3>
ffffffffc0203a34:	77d4                	ld	a3,168(a5)
ffffffffc0203a36:	0ee68363          	beq	a3,a4,ffffffffc0203b1c <proc_init+0x184>
        cprintf("alloc_proc() correct!\n");

    }
    
    idleproc->pid = 0;
    idleproc->state = PROC_RUNNABLE;
ffffffffc0203a3a:	4709                	li	a4,2
ffffffffc0203a3c:	e398                	sd	a4,0(a5)
    idleproc->kstack = (uintptr_t)bootstack;
ffffffffc0203a3e:	00003717          	auipc	a4,0x3
ffffffffc0203a42:	5c270713          	addi	a4,a4,1474 # ffffffffc0207000 <bootstack>
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc0203a46:	0b478413          	addi	s0,a5,180
    idleproc->kstack = (uintptr_t)bootstack;
ffffffffc0203a4a:	eb98                	sd	a4,16(a5)
    idleproc->need_resched = 1;
ffffffffc0203a4c:	4705                	li	a4,1
ffffffffc0203a4e:	cf98                	sw	a4,24(a5)
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc0203a50:	4641                	li	a2,16
ffffffffc0203a52:	4581                	li	a1,0
ffffffffc0203a54:	8522                	mv	a0,s0
ffffffffc0203a56:	728000ef          	jal	ra,ffffffffc020417e <memset>
    return memcpy(proc->name, name, PROC_NAME_LEN);
ffffffffc0203a5a:	463d                	li	a2,15
ffffffffc0203a5c:	00002597          	auipc	a1,0x2
ffffffffc0203a60:	30c58593          	addi	a1,a1,780 # ffffffffc0205d68 <default_pmm_manager+0xe48>
ffffffffc0203a64:	8522                	mv	a0,s0
ffffffffc0203a66:	72a000ef          	jal	ra,ffffffffc0204190 <memcpy>
    set_proc_name(idleproc, "idle");
    nr_process ++;
ffffffffc0203a6a:	00012717          	auipc	a4,0x12
ffffffffc0203a6e:	a7e70713          	addi	a4,a4,-1410 # ffffffffc02154e8 <nr_process>
ffffffffc0203a72:	431c                	lw	a5,0(a4)
    current = idleproc;
ffffffffc0203a74:	00093683          	ld	a3,0(s2)
    

    int pid = kernel_thread(init_main, "Hello world!!", 0);
ffffffffc0203a78:	4601                	li	a2,0
    nr_process ++;
ffffffffc0203a7a:	2785                	addiw	a5,a5,1
    int pid = kernel_thread(init_main, "Hello world!!", 0);
ffffffffc0203a7c:	00002597          	auipc	a1,0x2
ffffffffc0203a80:	2f458593          	addi	a1,a1,756 # ffffffffc0205d70 <default_pmm_manager+0xe50>
ffffffffc0203a84:	00000517          	auipc	a0,0x0
ffffffffc0203a88:	b9a50513          	addi	a0,a0,-1126 # ffffffffc020361e <init_main>
    nr_process ++;
ffffffffc0203a8c:	c31c                	sw	a5,0(a4)
    current = idleproc;
ffffffffc0203a8e:	00012797          	auipc	a5,0x12
ffffffffc0203a92:	a4d7b123          	sd	a3,-1470(a5) # ffffffffc02154d0 <current>
    int pid = kernel_thread(init_main, "Hello world!!", 0);
ffffffffc0203a96:	e97ff0ef          	jal	ra,ffffffffc020392c <kernel_thread>
ffffffffc0203a9a:	842a                	mv	s0,a0
    if (pid <= 0) {
ffffffffc0203a9c:	0ea05863          	blez	a0,ffffffffc0203b8c <proc_init+0x1f4>
    if (0 < pid && pid < MAX_PID) {
ffffffffc0203aa0:	6789                	lui	a5,0x2
ffffffffc0203aa2:	fff5071b          	addiw	a4,a0,-1
ffffffffc0203aa6:	17f9                	addi	a5,a5,-2
ffffffffc0203aa8:	2501                	sext.w	a0,a0
ffffffffc0203aaa:	02e7e263          	bltu	a5,a4,ffffffffc0203ace <proc_init+0x136>
        list_entry_t *list = hash_list + pid_hashfn(pid), *le = list;
ffffffffc0203aae:	45a9                	li	a1,10
ffffffffc0203ab0:	24e000ef          	jal	ra,ffffffffc0203cfe <hash32>
ffffffffc0203ab4:	02051693          	slli	a3,a0,0x20
ffffffffc0203ab8:	82f1                	srli	a3,a3,0x1c
ffffffffc0203aba:	96a6                	add	a3,a3,s1
ffffffffc0203abc:	87b6                	mv	a5,a3
        while ((le = list_next(le)) != list) {
ffffffffc0203abe:	a029                	j	ffffffffc0203ac8 <proc_init+0x130>
            if (proc->pid == pid) {
ffffffffc0203ac0:	f2c7a703          	lw	a4,-212(a5) # 1f2c <kern_entry-0xffffffffc01fe0d4>
ffffffffc0203ac4:	0a870563          	beq	a4,s0,ffffffffc0203b6e <proc_init+0x1d6>
    return listelm->next;
ffffffffc0203ac8:	679c                	ld	a5,8(a5)
        while ((le = list_next(le)) != list) {
ffffffffc0203aca:	fef69be3          	bne	a3,a5,ffffffffc0203ac0 <proc_init+0x128>
    return NULL;
ffffffffc0203ace:	4781                	li	a5,0
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc0203ad0:	0b478493          	addi	s1,a5,180
ffffffffc0203ad4:	4641                	li	a2,16
ffffffffc0203ad6:	4581                	li	a1,0
        panic("create init_main failed.\n");
    }
    
    initproc = find_proc(pid);
ffffffffc0203ad8:	00012417          	auipc	s0,0x12
ffffffffc0203adc:	a0840413          	addi	s0,s0,-1528 # ffffffffc02154e0 <initproc>
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc0203ae0:	8526                	mv	a0,s1
    initproc = find_proc(pid);
ffffffffc0203ae2:	e01c                	sd	a5,0(s0)
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc0203ae4:	69a000ef          	jal	ra,ffffffffc020417e <memset>
    return memcpy(proc->name, name, PROC_NAME_LEN);
ffffffffc0203ae8:	463d                	li	a2,15
ffffffffc0203aea:	00002597          	auipc	a1,0x2
ffffffffc0203aee:	2b658593          	addi	a1,a1,694 # ffffffffc0205da0 <default_pmm_manager+0xe80>
ffffffffc0203af2:	8526                	mv	a0,s1
ffffffffc0203af4:	69c000ef          	jal	ra,ffffffffc0204190 <memcpy>
    set_proc_name(initproc, "init");

    assert(idleproc != NULL && idleproc->pid == 0);
ffffffffc0203af8:	00093783          	ld	a5,0(s2)
ffffffffc0203afc:	c7e1                	beqz	a5,ffffffffc0203bc4 <proc_init+0x22c>
ffffffffc0203afe:	43dc                	lw	a5,4(a5)
ffffffffc0203b00:	e3f1                	bnez	a5,ffffffffc0203bc4 <proc_init+0x22c>
    assert(initproc != NULL && initproc->pid == 1);
ffffffffc0203b02:	601c                	ld	a5,0(s0)
ffffffffc0203b04:	c3c5                	beqz	a5,ffffffffc0203ba4 <proc_init+0x20c>
ffffffffc0203b06:	43d8                	lw	a4,4(a5)
ffffffffc0203b08:	4785                	li	a5,1
ffffffffc0203b0a:	08f71d63          	bne	a4,a5,ffffffffc0203ba4 <proc_init+0x20c>
}
ffffffffc0203b0e:	70a2                	ld	ra,40(sp)
ffffffffc0203b10:	7402                	ld	s0,32(sp)
ffffffffc0203b12:	64e2                	ld	s1,24(sp)
ffffffffc0203b14:	6942                	ld	s2,16(sp)
ffffffffc0203b16:	69a2                	ld	s3,8(sp)
ffffffffc0203b18:	6145                	addi	sp,sp,48
ffffffffc0203b1a:	8082                	ret
    if(idleproc->cr3 == boot_cr3 && idleproc->tf == NULL && !context_init_flag
ffffffffc0203b1c:	73d8                	ld	a4,160(a5)
ffffffffc0203b1e:	ff11                	bnez	a4,ffffffffc0203a3a <proc_init+0xa2>
ffffffffc0203b20:	f0099de3          	bnez	s3,ffffffffc0203a3a <proc_init+0xa2>
        && idleproc->state == PROC_UNINIT && idleproc->pid == -1 && idleproc->runs == 0
ffffffffc0203b24:	6394                	ld	a3,0(a5)
ffffffffc0203b26:	577d                	li	a4,-1
ffffffffc0203b28:	1702                	slli	a4,a4,0x20
ffffffffc0203b2a:	f0e698e3          	bne	a3,a4,ffffffffc0203a3a <proc_init+0xa2>
ffffffffc0203b2e:	4798                	lw	a4,8(a5)
ffffffffc0203b30:	f00715e3          	bnez	a4,ffffffffc0203a3a <proc_init+0xa2>
        && idleproc->kstack == 0 && idleproc->need_resched == 0 && idleproc->parent == NULL
ffffffffc0203b34:	6b98                	ld	a4,16(a5)
ffffffffc0203b36:	f00712e3          	bnez	a4,ffffffffc0203a3a <proc_init+0xa2>
ffffffffc0203b3a:	4f98                	lw	a4,24(a5)
ffffffffc0203b3c:	2701                	sext.w	a4,a4
ffffffffc0203b3e:	ee071ee3          	bnez	a4,ffffffffc0203a3a <proc_init+0xa2>
ffffffffc0203b42:	7398                	ld	a4,32(a5)
ffffffffc0203b44:	ee071be3          	bnez	a4,ffffffffc0203a3a <proc_init+0xa2>
        && idleproc->mm == NULL && idleproc->flags == 0 && !proc_name_flag
ffffffffc0203b48:	7798                	ld	a4,40(a5)
ffffffffc0203b4a:	ee0718e3          	bnez	a4,ffffffffc0203a3a <proc_init+0xa2>
ffffffffc0203b4e:	0b07a703          	lw	a4,176(a5)
ffffffffc0203b52:	8d59                	or	a0,a0,a4
ffffffffc0203b54:	0005071b          	sext.w	a4,a0
ffffffffc0203b58:	ee0711e3          	bnez	a4,ffffffffc0203a3a <proc_init+0xa2>
        cprintf("alloc_proc() correct!\n");
ffffffffc0203b5c:	00002517          	auipc	a0,0x2
ffffffffc0203b60:	1f450513          	addi	a0,a0,500 # ffffffffc0205d50 <default_pmm_manager+0xe30>
ffffffffc0203b64:	e18fc0ef          	jal	ra,ffffffffc020017c <cprintf>
    idleproc->pid = 0;
ffffffffc0203b68:	00093783          	ld	a5,0(s2)
ffffffffc0203b6c:	b5f9                	j	ffffffffc0203a3a <proc_init+0xa2>
            struct proc_struct *proc = le2proc(le, hash_link);
ffffffffc0203b6e:	f2878793          	addi	a5,a5,-216
ffffffffc0203b72:	bfb9                	j	ffffffffc0203ad0 <proc_init+0x138>
        panic("cannot alloc idleproc.\n");
ffffffffc0203b74:	00002617          	auipc	a2,0x2
ffffffffc0203b78:	1c460613          	addi	a2,a2,452 # ffffffffc0205d38 <default_pmm_manager+0xe18>
ffffffffc0203b7c:	15500593          	li	a1,341
ffffffffc0203b80:	00002517          	auipc	a0,0x2
ffffffffc0203b84:	18850513          	addi	a0,a0,392 # ffffffffc0205d08 <default_pmm_manager+0xde8>
ffffffffc0203b88:	8bbfc0ef          	jal	ra,ffffffffc0200442 <__panic>
        panic("create init_main failed.\n");
ffffffffc0203b8c:	00002617          	auipc	a2,0x2
ffffffffc0203b90:	1f460613          	addi	a2,a2,500 # ffffffffc0205d80 <default_pmm_manager+0xe60>
ffffffffc0203b94:	17500593          	li	a1,373
ffffffffc0203b98:	00002517          	auipc	a0,0x2
ffffffffc0203b9c:	17050513          	addi	a0,a0,368 # ffffffffc0205d08 <default_pmm_manager+0xde8>
ffffffffc0203ba0:	8a3fc0ef          	jal	ra,ffffffffc0200442 <__panic>
    assert(initproc != NULL && initproc->pid == 1);
ffffffffc0203ba4:	00002697          	auipc	a3,0x2
ffffffffc0203ba8:	22c68693          	addi	a3,a3,556 # ffffffffc0205dd0 <default_pmm_manager+0xeb0>
ffffffffc0203bac:	00001617          	auipc	a2,0x1
ffffffffc0203bb0:	fc460613          	addi	a2,a2,-60 # ffffffffc0204b70 <commands+0x738>
ffffffffc0203bb4:	17c00593          	li	a1,380
ffffffffc0203bb8:	00002517          	auipc	a0,0x2
ffffffffc0203bbc:	15050513          	addi	a0,a0,336 # ffffffffc0205d08 <default_pmm_manager+0xde8>
ffffffffc0203bc0:	883fc0ef          	jal	ra,ffffffffc0200442 <__panic>
    assert(idleproc != NULL && idleproc->pid == 0);
ffffffffc0203bc4:	00002697          	auipc	a3,0x2
ffffffffc0203bc8:	1e468693          	addi	a3,a3,484 # ffffffffc0205da8 <default_pmm_manager+0xe88>
ffffffffc0203bcc:	00001617          	auipc	a2,0x1
ffffffffc0203bd0:	fa460613          	addi	a2,a2,-92 # ffffffffc0204b70 <commands+0x738>
ffffffffc0203bd4:	17b00593          	li	a1,379
ffffffffc0203bd8:	00002517          	auipc	a0,0x2
ffffffffc0203bdc:	13050513          	addi	a0,a0,304 # ffffffffc0205d08 <default_pmm_manager+0xde8>
ffffffffc0203be0:	863fc0ef          	jal	ra,ffffffffc0200442 <__panic>

ffffffffc0203be4 <cpu_idle>:

// cpu_idle - at the end of kern_init, the first kernel thread idleproc will do below works
void cpu_idle(void) {
ffffffffc0203be4:	1141                	addi	sp,sp,-16
ffffffffc0203be6:	e022                	sd	s0,0(sp)
ffffffffc0203be8:	e406                	sd	ra,8(sp)
ffffffffc0203bea:	00012417          	auipc	s0,0x12
ffffffffc0203bee:	8e640413          	addi	s0,s0,-1818 # ffffffffc02154d0 <current>
    while (1) {
        if (current->need_resched) {
ffffffffc0203bf2:	6018                	ld	a4,0(s0)
ffffffffc0203bf4:	4f1c                	lw	a5,24(a4)
ffffffffc0203bf6:	2781                	sext.w	a5,a5
ffffffffc0203bf8:	dff5                	beqz	a5,ffffffffc0203bf4 <cpu_idle+0x10>
            schedule();
ffffffffc0203bfa:	070000ef          	jal	ra,ffffffffc0203c6a <schedule>
ffffffffc0203bfe:	bfd5                	j	ffffffffc0203bf2 <cpu_idle+0xe>

ffffffffc0203c00 <switch_to>:
.text
# void switch_to(struct proc_struct* from, struct proc_struct* to)
.globl switch_to
switch_to:
    # save from's registers
    STORE ra, 0*REGBYTES(a0)
ffffffffc0203c00:	00153023          	sd	ra,0(a0)
    STORE sp, 1*REGBYTES(a0)
ffffffffc0203c04:	00253423          	sd	sp,8(a0)
    STORE s0, 2*REGBYTES(a0)
ffffffffc0203c08:	e900                	sd	s0,16(a0)
    STORE s1, 3*REGBYTES(a0)
ffffffffc0203c0a:	ed04                	sd	s1,24(a0)
    STORE s2, 4*REGBYTES(a0)
ffffffffc0203c0c:	03253023          	sd	s2,32(a0)
    STORE s3, 5*REGBYTES(a0)
ffffffffc0203c10:	03353423          	sd	s3,40(a0)
    STORE s4, 6*REGBYTES(a0)
ffffffffc0203c14:	03453823          	sd	s4,48(a0)
    STORE s5, 7*REGBYTES(a0)
ffffffffc0203c18:	03553c23          	sd	s5,56(a0)
    STORE s6, 8*REGBYTES(a0)
ffffffffc0203c1c:	05653023          	sd	s6,64(a0)
    STORE s7, 9*REGBYTES(a0)
ffffffffc0203c20:	05753423          	sd	s7,72(a0)
    STORE s8, 10*REGBYTES(a0)
ffffffffc0203c24:	05853823          	sd	s8,80(a0)
    STORE s9, 11*REGBYTES(a0)
ffffffffc0203c28:	05953c23          	sd	s9,88(a0)
    STORE s10, 12*REGBYTES(a0)
ffffffffc0203c2c:	07a53023          	sd	s10,96(a0)
    STORE s11, 13*REGBYTES(a0)
ffffffffc0203c30:	07b53423          	sd	s11,104(a0)

    # restore to's registers
    LOAD ra, 0*REGBYTES(a1)
ffffffffc0203c34:	0005b083          	ld	ra,0(a1)
    LOAD sp, 1*REGBYTES(a1)
ffffffffc0203c38:	0085b103          	ld	sp,8(a1)
    LOAD s0, 2*REGBYTES(a1)
ffffffffc0203c3c:	6980                	ld	s0,16(a1)
    LOAD s1, 3*REGBYTES(a1)
ffffffffc0203c3e:	6d84                	ld	s1,24(a1)
    LOAD s2, 4*REGBYTES(a1)
ffffffffc0203c40:	0205b903          	ld	s2,32(a1)
    LOAD s3, 5*REGBYTES(a1)
ffffffffc0203c44:	0285b983          	ld	s3,40(a1)
    LOAD s4, 6*REGBYTES(a1)
ffffffffc0203c48:	0305ba03          	ld	s4,48(a1)
    LOAD s5, 7*REGBYTES(a1)
ffffffffc0203c4c:	0385ba83          	ld	s5,56(a1)
    LOAD s6, 8*REGBYTES(a1)
ffffffffc0203c50:	0405bb03          	ld	s6,64(a1)
    LOAD s7, 9*REGBYTES(a1)
ffffffffc0203c54:	0485bb83          	ld	s7,72(a1)
    LOAD s8, 10*REGBYTES(a1)
ffffffffc0203c58:	0505bc03          	ld	s8,80(a1)
    LOAD s9, 11*REGBYTES(a1)
ffffffffc0203c5c:	0585bc83          	ld	s9,88(a1)
    LOAD s10, 12*REGBYTES(a1)
ffffffffc0203c60:	0605bd03          	ld	s10,96(a1)
    LOAD s11, 13*REGBYTES(a1)
ffffffffc0203c64:	0685bd83          	ld	s11,104(a1)

    ret
ffffffffc0203c68:	8082                	ret

ffffffffc0203c6a <schedule>:
    assert(proc->state != PROC_ZOMBIE && proc->state != PROC_RUNNABLE);
    proc->state = PROC_RUNNABLE;
}

void
schedule(void) {
ffffffffc0203c6a:	1141                	addi	sp,sp,-16
ffffffffc0203c6c:	e406                	sd	ra,8(sp)
ffffffffc0203c6e:	e022                	sd	s0,0(sp)
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0203c70:	100027f3          	csrr	a5,sstatus
ffffffffc0203c74:	8b89                	andi	a5,a5,2
ffffffffc0203c76:	4401                	li	s0,0
ffffffffc0203c78:	efbd                	bnez	a5,ffffffffc0203cf6 <schedule+0x8c>
    bool intr_flag;
    list_entry_t *le, *last;
    struct proc_struct *next = NULL;
    local_intr_save(intr_flag);
    {
        current->need_resched = 0;
ffffffffc0203c7a:	00012897          	auipc	a7,0x12
ffffffffc0203c7e:	8568b883          	ld	a7,-1962(a7) # ffffffffc02154d0 <current>
ffffffffc0203c82:	0008ac23          	sw	zero,24(a7)
        last = (current == idleproc) ? &proc_list : &(current->list_link);
ffffffffc0203c86:	00012517          	auipc	a0,0x12
ffffffffc0203c8a:	85253503          	ld	a0,-1966(a0) # ffffffffc02154d8 <idleproc>
ffffffffc0203c8e:	04a88e63          	beq	a7,a0,ffffffffc0203cea <schedule+0x80>
ffffffffc0203c92:	0c888693          	addi	a3,a7,200
ffffffffc0203c96:	00011617          	auipc	a2,0x11
ffffffffc0203c9a:	7b260613          	addi	a2,a2,1970 # ffffffffc0215448 <proc_list>
        le = last;
ffffffffc0203c9e:	87b6                	mv	a5,a3
    struct proc_struct *next = NULL;
ffffffffc0203ca0:	4581                	li	a1,0
        do {
            if ((le = list_next(le)) != &proc_list) {
                next = le2proc(le, list_link);
                if (next->state == PROC_RUNNABLE) {
ffffffffc0203ca2:	4809                	li	a6,2
ffffffffc0203ca4:	679c                	ld	a5,8(a5)
            if ((le = list_next(le)) != &proc_list) {
ffffffffc0203ca6:	00c78863          	beq	a5,a2,ffffffffc0203cb6 <schedule+0x4c>
                if (next->state == PROC_RUNNABLE) {
ffffffffc0203caa:	f387a703          	lw	a4,-200(a5)
                next = le2proc(le, list_link);
ffffffffc0203cae:	f3878593          	addi	a1,a5,-200
                if (next->state == PROC_RUNNABLE) {
ffffffffc0203cb2:	03070163          	beq	a4,a6,ffffffffc0203cd4 <schedule+0x6a>
                    break;
                }
            }
        } while (le != last);
ffffffffc0203cb6:	fef697e3          	bne	a3,a5,ffffffffc0203ca4 <schedule+0x3a>
        if (next == NULL || next->state != PROC_RUNNABLE) {
ffffffffc0203cba:	ed89                	bnez	a1,ffffffffc0203cd4 <schedule+0x6a>
            next = idleproc;
        }
        next->runs ++;
ffffffffc0203cbc:	451c                	lw	a5,8(a0)
ffffffffc0203cbe:	2785                	addiw	a5,a5,1
ffffffffc0203cc0:	c51c                	sw	a5,8(a0)
        if (next != current) {
ffffffffc0203cc2:	00a88463          	beq	a7,a0,ffffffffc0203cca <schedule+0x60>
            proc_run(next);
ffffffffc0203cc6:	9cbff0ef          	jal	ra,ffffffffc0203690 <proc_run>
    if (flag) {
ffffffffc0203cca:	e819                	bnez	s0,ffffffffc0203ce0 <schedule+0x76>
        }
    }
    local_intr_restore(intr_flag);
}
ffffffffc0203ccc:	60a2                	ld	ra,8(sp)
ffffffffc0203cce:	6402                	ld	s0,0(sp)
ffffffffc0203cd0:	0141                	addi	sp,sp,16
ffffffffc0203cd2:	8082                	ret
        if (next == NULL || next->state != PROC_RUNNABLE) {
ffffffffc0203cd4:	4198                	lw	a4,0(a1)
ffffffffc0203cd6:	4789                	li	a5,2
ffffffffc0203cd8:	fef712e3          	bne	a4,a5,ffffffffc0203cbc <schedule+0x52>
ffffffffc0203cdc:	852e                	mv	a0,a1
ffffffffc0203cde:	bff9                	j	ffffffffc0203cbc <schedule+0x52>
}
ffffffffc0203ce0:	6402                	ld	s0,0(sp)
ffffffffc0203ce2:	60a2                	ld	ra,8(sp)
ffffffffc0203ce4:	0141                	addi	sp,sp,16
        intr_enable();
ffffffffc0203ce6:	8a3fc06f          	j	ffffffffc0200588 <intr_enable>
        last = (current == idleproc) ? &proc_list : &(current->list_link);
ffffffffc0203cea:	00011617          	auipc	a2,0x11
ffffffffc0203cee:	75e60613          	addi	a2,a2,1886 # ffffffffc0215448 <proc_list>
ffffffffc0203cf2:	86b2                	mv	a3,a2
ffffffffc0203cf4:	b76d                	j	ffffffffc0203c9e <schedule+0x34>
        intr_disable();
ffffffffc0203cf6:	899fc0ef          	jal	ra,ffffffffc020058e <intr_disable>
        return 1;
ffffffffc0203cfa:	4405                	li	s0,1
ffffffffc0203cfc:	bfbd                	j	ffffffffc0203c7a <schedule+0x10>

ffffffffc0203cfe <hash32>:
 *
 * High bits are more random, so we use them.
 * */
uint32_t
hash32(uint32_t val, unsigned int bits) {
    uint32_t hash = val * GOLDEN_RATIO_PRIME_32;
ffffffffc0203cfe:	9e3707b7          	lui	a5,0x9e370
ffffffffc0203d02:	2785                	addiw	a5,a5,1
ffffffffc0203d04:	02a7853b          	mulw	a0,a5,a0
    return (hash >> (32 - bits));
ffffffffc0203d08:	02000793          	li	a5,32
ffffffffc0203d0c:	9f8d                	subw	a5,a5,a1
}
ffffffffc0203d0e:	00f5553b          	srlw	a0,a0,a5
ffffffffc0203d12:	8082                	ret

ffffffffc0203d14 <printnum>:
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
    unsigned long long result = num;
    unsigned mod = do_div(result, base);
ffffffffc0203d14:	02069813          	slli	a6,a3,0x20
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc0203d18:	7179                	addi	sp,sp,-48
    unsigned mod = do_div(result, base);
ffffffffc0203d1a:	02085813          	srli	a6,a6,0x20
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc0203d1e:	e052                	sd	s4,0(sp)
    unsigned mod = do_div(result, base);
ffffffffc0203d20:	03067a33          	remu	s4,a2,a6
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc0203d24:	f022                	sd	s0,32(sp)
ffffffffc0203d26:	ec26                	sd	s1,24(sp)
ffffffffc0203d28:	e84a                	sd	s2,16(sp)
ffffffffc0203d2a:	f406                	sd	ra,40(sp)
ffffffffc0203d2c:	e44e                	sd	s3,8(sp)
ffffffffc0203d2e:	84aa                	mv	s1,a0
ffffffffc0203d30:	892e                	mv	s2,a1
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
ffffffffc0203d32:	fff7041b          	addiw	s0,a4,-1
    unsigned mod = do_div(result, base);
ffffffffc0203d36:	2a01                	sext.w	s4,s4
    if (num >= base) {
ffffffffc0203d38:	03067e63          	bgeu	a2,a6,ffffffffc0203d74 <printnum+0x60>
ffffffffc0203d3c:	89be                	mv	s3,a5
        while (-- width > 0)
ffffffffc0203d3e:	00805763          	blez	s0,ffffffffc0203d4c <printnum+0x38>
ffffffffc0203d42:	347d                	addiw	s0,s0,-1
            putch(padc, putdat);
ffffffffc0203d44:	85ca                	mv	a1,s2
ffffffffc0203d46:	854e                	mv	a0,s3
ffffffffc0203d48:	9482                	jalr	s1
        while (-- width > 0)
ffffffffc0203d4a:	fc65                	bnez	s0,ffffffffc0203d42 <printnum+0x2e>
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
ffffffffc0203d4c:	1a02                	slli	s4,s4,0x20
ffffffffc0203d4e:	00002797          	auipc	a5,0x2
ffffffffc0203d52:	0aa78793          	addi	a5,a5,170 # ffffffffc0205df8 <default_pmm_manager+0xed8>
ffffffffc0203d56:	020a5a13          	srli	s4,s4,0x20
ffffffffc0203d5a:	9a3e                	add	s4,s4,a5
}
ffffffffc0203d5c:	7402                	ld	s0,32(sp)
    putch("0123456789abcdef"[mod], putdat);
ffffffffc0203d5e:	000a4503          	lbu	a0,0(s4)
}
ffffffffc0203d62:	70a2                	ld	ra,40(sp)
ffffffffc0203d64:	69a2                	ld	s3,8(sp)
ffffffffc0203d66:	6a02                	ld	s4,0(sp)
    putch("0123456789abcdef"[mod], putdat);
ffffffffc0203d68:	85ca                	mv	a1,s2
ffffffffc0203d6a:	87a6                	mv	a5,s1
}
ffffffffc0203d6c:	6942                	ld	s2,16(sp)
ffffffffc0203d6e:	64e2                	ld	s1,24(sp)
ffffffffc0203d70:	6145                	addi	sp,sp,48
    putch("0123456789abcdef"[mod], putdat);
ffffffffc0203d72:	8782                	jr	a5
        printnum(putch, putdat, result, base, width - 1, padc);
ffffffffc0203d74:	03065633          	divu	a2,a2,a6
ffffffffc0203d78:	8722                	mv	a4,s0
ffffffffc0203d7a:	f9bff0ef          	jal	ra,ffffffffc0203d14 <printnum>
ffffffffc0203d7e:	b7f9                	j	ffffffffc0203d4c <printnum+0x38>

ffffffffc0203d80 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
ffffffffc0203d80:	7119                	addi	sp,sp,-128
ffffffffc0203d82:	f4a6                	sd	s1,104(sp)
ffffffffc0203d84:	f0ca                	sd	s2,96(sp)
ffffffffc0203d86:	ecce                	sd	s3,88(sp)
ffffffffc0203d88:	e8d2                	sd	s4,80(sp)
ffffffffc0203d8a:	e4d6                	sd	s5,72(sp)
ffffffffc0203d8c:	e0da                	sd	s6,64(sp)
ffffffffc0203d8e:	fc5e                	sd	s7,56(sp)
ffffffffc0203d90:	f06a                	sd	s10,32(sp)
ffffffffc0203d92:	fc86                	sd	ra,120(sp)
ffffffffc0203d94:	f8a2                	sd	s0,112(sp)
ffffffffc0203d96:	f862                	sd	s8,48(sp)
ffffffffc0203d98:	f466                	sd	s9,40(sp)
ffffffffc0203d9a:	ec6e                	sd	s11,24(sp)
ffffffffc0203d9c:	892a                	mv	s2,a0
ffffffffc0203d9e:	84ae                	mv	s1,a1
ffffffffc0203da0:	8d32                	mv	s10,a2
ffffffffc0203da2:	8a36                	mv	s4,a3
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc0203da4:	02500993          	li	s3,37
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
        width = precision = -1;
ffffffffc0203da8:	5b7d                	li	s6,-1
ffffffffc0203daa:	00002a97          	auipc	s5,0x2
ffffffffc0203dae:	07aa8a93          	addi	s5,s5,122 # ffffffffc0205e24 <default_pmm_manager+0xf04>
        case 'e':
            err = va_arg(ap, int);
            if (err < 0) {
                err = -err;
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
ffffffffc0203db2:	00002b97          	auipc	s7,0x2
ffffffffc0203db6:	24eb8b93          	addi	s7,s7,590 # ffffffffc0206000 <error_string>
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc0203dba:	000d4503          	lbu	a0,0(s10) # 80000 <kern_entry-0xffffffffc0180000>
ffffffffc0203dbe:	001d0413          	addi	s0,s10,1
ffffffffc0203dc2:	01350a63          	beq	a0,s3,ffffffffc0203dd6 <vprintfmt+0x56>
            if (ch == '\0') {
ffffffffc0203dc6:	c121                	beqz	a0,ffffffffc0203e06 <vprintfmt+0x86>
            putch(ch, putdat);
ffffffffc0203dc8:	85a6                	mv	a1,s1
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc0203dca:	0405                	addi	s0,s0,1
            putch(ch, putdat);
ffffffffc0203dcc:	9902                	jalr	s2
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc0203dce:	fff44503          	lbu	a0,-1(s0)
ffffffffc0203dd2:	ff351ae3          	bne	a0,s3,ffffffffc0203dc6 <vprintfmt+0x46>
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0203dd6:	00044603          	lbu	a2,0(s0)
        char padc = ' ';
ffffffffc0203dda:	02000793          	li	a5,32
        lflag = altflag = 0;
ffffffffc0203dde:	4c81                	li	s9,0
ffffffffc0203de0:	4881                	li	a7,0
        width = precision = -1;
ffffffffc0203de2:	5c7d                	li	s8,-1
ffffffffc0203de4:	5dfd                	li	s11,-1
ffffffffc0203de6:	05500513          	li	a0,85
                if (ch < '0' || ch > '9') {
ffffffffc0203dea:	4825                	li	a6,9
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0203dec:	fdd6059b          	addiw	a1,a2,-35
ffffffffc0203df0:	0ff5f593          	andi	a1,a1,255
ffffffffc0203df4:	00140d13          	addi	s10,s0,1
ffffffffc0203df8:	04b56263          	bltu	a0,a1,ffffffffc0203e3c <vprintfmt+0xbc>
ffffffffc0203dfc:	058a                	slli	a1,a1,0x2
ffffffffc0203dfe:	95d6                	add	a1,a1,s5
ffffffffc0203e00:	4194                	lw	a3,0(a1)
ffffffffc0203e02:	96d6                	add	a3,a3,s5
ffffffffc0203e04:	8682                	jr	a3
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
ffffffffc0203e06:	70e6                	ld	ra,120(sp)
ffffffffc0203e08:	7446                	ld	s0,112(sp)
ffffffffc0203e0a:	74a6                	ld	s1,104(sp)
ffffffffc0203e0c:	7906                	ld	s2,96(sp)
ffffffffc0203e0e:	69e6                	ld	s3,88(sp)
ffffffffc0203e10:	6a46                	ld	s4,80(sp)
ffffffffc0203e12:	6aa6                	ld	s5,72(sp)
ffffffffc0203e14:	6b06                	ld	s6,64(sp)
ffffffffc0203e16:	7be2                	ld	s7,56(sp)
ffffffffc0203e18:	7c42                	ld	s8,48(sp)
ffffffffc0203e1a:	7ca2                	ld	s9,40(sp)
ffffffffc0203e1c:	7d02                	ld	s10,32(sp)
ffffffffc0203e1e:	6de2                	ld	s11,24(sp)
ffffffffc0203e20:	6109                	addi	sp,sp,128
ffffffffc0203e22:	8082                	ret
            padc = '0';
ffffffffc0203e24:	87b2                	mv	a5,a2
            goto reswitch;
ffffffffc0203e26:	00144603          	lbu	a2,1(s0)
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0203e2a:	846a                	mv	s0,s10
ffffffffc0203e2c:	00140d13          	addi	s10,s0,1
ffffffffc0203e30:	fdd6059b          	addiw	a1,a2,-35
ffffffffc0203e34:	0ff5f593          	andi	a1,a1,255
ffffffffc0203e38:	fcb572e3          	bgeu	a0,a1,ffffffffc0203dfc <vprintfmt+0x7c>
            putch('%', putdat);
ffffffffc0203e3c:	85a6                	mv	a1,s1
ffffffffc0203e3e:	02500513          	li	a0,37
ffffffffc0203e42:	9902                	jalr	s2
            for (fmt --; fmt[-1] != '%'; fmt --)
ffffffffc0203e44:	fff44783          	lbu	a5,-1(s0)
ffffffffc0203e48:	8d22                	mv	s10,s0
ffffffffc0203e4a:	f73788e3          	beq	a5,s3,ffffffffc0203dba <vprintfmt+0x3a>
ffffffffc0203e4e:	ffed4783          	lbu	a5,-2(s10)
ffffffffc0203e52:	1d7d                	addi	s10,s10,-1
ffffffffc0203e54:	ff379de3          	bne	a5,s3,ffffffffc0203e4e <vprintfmt+0xce>
ffffffffc0203e58:	b78d                	j	ffffffffc0203dba <vprintfmt+0x3a>
                precision = precision * 10 + ch - '0';
ffffffffc0203e5a:	fd060c1b          	addiw	s8,a2,-48
                ch = *fmt;
ffffffffc0203e5e:	00144603          	lbu	a2,1(s0)
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0203e62:	846a                	mv	s0,s10
                if (ch < '0' || ch > '9') {
ffffffffc0203e64:	fd06069b          	addiw	a3,a2,-48
                ch = *fmt;
ffffffffc0203e68:	0006059b          	sext.w	a1,a2
                if (ch < '0' || ch > '9') {
ffffffffc0203e6c:	02d86463          	bltu	a6,a3,ffffffffc0203e94 <vprintfmt+0x114>
                ch = *fmt;
ffffffffc0203e70:	00144603          	lbu	a2,1(s0)
                precision = precision * 10 + ch - '0';
ffffffffc0203e74:	002c169b          	slliw	a3,s8,0x2
ffffffffc0203e78:	0186873b          	addw	a4,a3,s8
ffffffffc0203e7c:	0017171b          	slliw	a4,a4,0x1
ffffffffc0203e80:	9f2d                	addw	a4,a4,a1
                if (ch < '0' || ch > '9') {
ffffffffc0203e82:	fd06069b          	addiw	a3,a2,-48
            for (precision = 0; ; ++ fmt) {
ffffffffc0203e86:	0405                	addi	s0,s0,1
                precision = precision * 10 + ch - '0';
ffffffffc0203e88:	fd070c1b          	addiw	s8,a4,-48
                ch = *fmt;
ffffffffc0203e8c:	0006059b          	sext.w	a1,a2
                if (ch < '0' || ch > '9') {
ffffffffc0203e90:	fed870e3          	bgeu	a6,a3,ffffffffc0203e70 <vprintfmt+0xf0>
            if (width < 0)
ffffffffc0203e94:	f40ddce3          	bgez	s11,ffffffffc0203dec <vprintfmt+0x6c>
                width = precision, precision = -1;
ffffffffc0203e98:	8de2                	mv	s11,s8
ffffffffc0203e9a:	5c7d                	li	s8,-1
ffffffffc0203e9c:	bf81                	j	ffffffffc0203dec <vprintfmt+0x6c>
            if (width < 0)
ffffffffc0203e9e:	fffdc693          	not	a3,s11
ffffffffc0203ea2:	96fd                	srai	a3,a3,0x3f
ffffffffc0203ea4:	00ddfdb3          	and	s11,s11,a3
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0203ea8:	00144603          	lbu	a2,1(s0)
ffffffffc0203eac:	2d81                	sext.w	s11,s11
ffffffffc0203eae:	846a                	mv	s0,s10
            goto reswitch;
ffffffffc0203eb0:	bf35                	j	ffffffffc0203dec <vprintfmt+0x6c>
            precision = va_arg(ap, int);
ffffffffc0203eb2:	000a2c03          	lw	s8,0(s4)
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0203eb6:	00144603          	lbu	a2,1(s0)
            precision = va_arg(ap, int);
ffffffffc0203eba:	0a21                	addi	s4,s4,8
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0203ebc:	846a                	mv	s0,s10
            goto process_precision;
ffffffffc0203ebe:	bfd9                	j	ffffffffc0203e94 <vprintfmt+0x114>
    if (lflag >= 2) {
ffffffffc0203ec0:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc0203ec2:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
ffffffffc0203ec6:	01174463          	blt	a4,a7,ffffffffc0203ece <vprintfmt+0x14e>
    else if (lflag) {
ffffffffc0203eca:	1a088e63          	beqz	a7,ffffffffc0204086 <vprintfmt+0x306>
        return va_arg(*ap, unsigned long);
ffffffffc0203ece:	000a3603          	ld	a2,0(s4)
ffffffffc0203ed2:	46c1                	li	a3,16
ffffffffc0203ed4:	8a2e                	mv	s4,a1
            printnum(putch, putdat, num, base, width, padc);
ffffffffc0203ed6:	2781                	sext.w	a5,a5
ffffffffc0203ed8:	876e                	mv	a4,s11
ffffffffc0203eda:	85a6                	mv	a1,s1
ffffffffc0203edc:	854a                	mv	a0,s2
ffffffffc0203ede:	e37ff0ef          	jal	ra,ffffffffc0203d14 <printnum>
            break;
ffffffffc0203ee2:	bde1                	j	ffffffffc0203dba <vprintfmt+0x3a>
            putch(va_arg(ap, int), putdat);
ffffffffc0203ee4:	000a2503          	lw	a0,0(s4)
ffffffffc0203ee8:	85a6                	mv	a1,s1
ffffffffc0203eea:	0a21                	addi	s4,s4,8
ffffffffc0203eec:	9902                	jalr	s2
            break;
ffffffffc0203eee:	b5f1                	j	ffffffffc0203dba <vprintfmt+0x3a>
    if (lflag >= 2) {
ffffffffc0203ef0:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc0203ef2:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
ffffffffc0203ef6:	01174463          	blt	a4,a7,ffffffffc0203efe <vprintfmt+0x17e>
    else if (lflag) {
ffffffffc0203efa:	18088163          	beqz	a7,ffffffffc020407c <vprintfmt+0x2fc>
        return va_arg(*ap, unsigned long);
ffffffffc0203efe:	000a3603          	ld	a2,0(s4)
ffffffffc0203f02:	46a9                	li	a3,10
ffffffffc0203f04:	8a2e                	mv	s4,a1
ffffffffc0203f06:	bfc1                	j	ffffffffc0203ed6 <vprintfmt+0x156>
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0203f08:	00144603          	lbu	a2,1(s0)
            altflag = 1;
ffffffffc0203f0c:	4c85                	li	s9,1
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0203f0e:	846a                	mv	s0,s10
            goto reswitch;
ffffffffc0203f10:	bdf1                	j	ffffffffc0203dec <vprintfmt+0x6c>
            putch(ch, putdat);
ffffffffc0203f12:	85a6                	mv	a1,s1
ffffffffc0203f14:	02500513          	li	a0,37
ffffffffc0203f18:	9902                	jalr	s2
            break;
ffffffffc0203f1a:	b545                	j	ffffffffc0203dba <vprintfmt+0x3a>
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0203f1c:	00144603          	lbu	a2,1(s0)
            lflag ++;
ffffffffc0203f20:	2885                	addiw	a7,a7,1
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0203f22:	846a                	mv	s0,s10
            goto reswitch;
ffffffffc0203f24:	b5e1                	j	ffffffffc0203dec <vprintfmt+0x6c>
    if (lflag >= 2) {
ffffffffc0203f26:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc0203f28:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
ffffffffc0203f2c:	01174463          	blt	a4,a7,ffffffffc0203f34 <vprintfmt+0x1b4>
    else if (lflag) {
ffffffffc0203f30:	14088163          	beqz	a7,ffffffffc0204072 <vprintfmt+0x2f2>
        return va_arg(*ap, unsigned long);
ffffffffc0203f34:	000a3603          	ld	a2,0(s4)
ffffffffc0203f38:	46a1                	li	a3,8
ffffffffc0203f3a:	8a2e                	mv	s4,a1
ffffffffc0203f3c:	bf69                	j	ffffffffc0203ed6 <vprintfmt+0x156>
            putch('0', putdat);
ffffffffc0203f3e:	03000513          	li	a0,48
ffffffffc0203f42:	85a6                	mv	a1,s1
ffffffffc0203f44:	e03e                	sd	a5,0(sp)
ffffffffc0203f46:	9902                	jalr	s2
            putch('x', putdat);
ffffffffc0203f48:	85a6                	mv	a1,s1
ffffffffc0203f4a:	07800513          	li	a0,120
ffffffffc0203f4e:	9902                	jalr	s2
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
ffffffffc0203f50:	0a21                	addi	s4,s4,8
            goto number;
ffffffffc0203f52:	6782                	ld	a5,0(sp)
ffffffffc0203f54:	46c1                	li	a3,16
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
ffffffffc0203f56:	ff8a3603          	ld	a2,-8(s4)
            goto number;
ffffffffc0203f5a:	bfb5                	j	ffffffffc0203ed6 <vprintfmt+0x156>
            if ((p = va_arg(ap, char *)) == NULL) {
ffffffffc0203f5c:	000a3403          	ld	s0,0(s4)
ffffffffc0203f60:	008a0713          	addi	a4,s4,8
ffffffffc0203f64:	e03a                	sd	a4,0(sp)
ffffffffc0203f66:	14040263          	beqz	s0,ffffffffc02040aa <vprintfmt+0x32a>
            if (width > 0 && padc != '-') {
ffffffffc0203f6a:	0fb05763          	blez	s11,ffffffffc0204058 <vprintfmt+0x2d8>
ffffffffc0203f6e:	02d00693          	li	a3,45
ffffffffc0203f72:	0cd79163          	bne	a5,a3,ffffffffc0204034 <vprintfmt+0x2b4>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0203f76:	00044783          	lbu	a5,0(s0)
ffffffffc0203f7a:	0007851b          	sext.w	a0,a5
ffffffffc0203f7e:	cf85                	beqz	a5,ffffffffc0203fb6 <vprintfmt+0x236>
ffffffffc0203f80:	00140a13          	addi	s4,s0,1
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc0203f84:	05e00413          	li	s0,94
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0203f88:	000c4563          	bltz	s8,ffffffffc0203f92 <vprintfmt+0x212>
ffffffffc0203f8c:	3c7d                	addiw	s8,s8,-1
ffffffffc0203f8e:	036c0263          	beq	s8,s6,ffffffffc0203fb2 <vprintfmt+0x232>
                    putch('?', putdat);
ffffffffc0203f92:	85a6                	mv	a1,s1
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc0203f94:	0e0c8e63          	beqz	s9,ffffffffc0204090 <vprintfmt+0x310>
ffffffffc0203f98:	3781                	addiw	a5,a5,-32
ffffffffc0203f9a:	0ef47b63          	bgeu	s0,a5,ffffffffc0204090 <vprintfmt+0x310>
                    putch('?', putdat);
ffffffffc0203f9e:	03f00513          	li	a0,63
ffffffffc0203fa2:	9902                	jalr	s2
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0203fa4:	000a4783          	lbu	a5,0(s4)
ffffffffc0203fa8:	3dfd                	addiw	s11,s11,-1
ffffffffc0203faa:	0a05                	addi	s4,s4,1
ffffffffc0203fac:	0007851b          	sext.w	a0,a5
ffffffffc0203fb0:	ffe1                	bnez	a5,ffffffffc0203f88 <vprintfmt+0x208>
            for (; width > 0; width --) {
ffffffffc0203fb2:	01b05963          	blez	s11,ffffffffc0203fc4 <vprintfmt+0x244>
ffffffffc0203fb6:	3dfd                	addiw	s11,s11,-1
                putch(' ', putdat);
ffffffffc0203fb8:	85a6                	mv	a1,s1
ffffffffc0203fba:	02000513          	li	a0,32
ffffffffc0203fbe:	9902                	jalr	s2
            for (; width > 0; width --) {
ffffffffc0203fc0:	fe0d9be3          	bnez	s11,ffffffffc0203fb6 <vprintfmt+0x236>
            if ((p = va_arg(ap, char *)) == NULL) {
ffffffffc0203fc4:	6a02                	ld	s4,0(sp)
ffffffffc0203fc6:	bbd5                	j	ffffffffc0203dba <vprintfmt+0x3a>
    if (lflag >= 2) {
ffffffffc0203fc8:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc0203fca:	008a0c93          	addi	s9,s4,8
    if (lflag >= 2) {
ffffffffc0203fce:	01174463          	blt	a4,a7,ffffffffc0203fd6 <vprintfmt+0x256>
    else if (lflag) {
ffffffffc0203fd2:	08088d63          	beqz	a7,ffffffffc020406c <vprintfmt+0x2ec>
        return va_arg(*ap, long);
ffffffffc0203fd6:	000a3403          	ld	s0,0(s4)
            if ((long long)num < 0) {
ffffffffc0203fda:	0a044d63          	bltz	s0,ffffffffc0204094 <vprintfmt+0x314>
            num = getint(&ap, lflag);
ffffffffc0203fde:	8622                	mv	a2,s0
ffffffffc0203fe0:	8a66                	mv	s4,s9
ffffffffc0203fe2:	46a9                	li	a3,10
ffffffffc0203fe4:	bdcd                	j	ffffffffc0203ed6 <vprintfmt+0x156>
            err = va_arg(ap, int);
ffffffffc0203fe6:	000a2783          	lw	a5,0(s4)
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
ffffffffc0203fea:	4719                	li	a4,6
            err = va_arg(ap, int);
ffffffffc0203fec:	0a21                	addi	s4,s4,8
            if (err < 0) {
ffffffffc0203fee:	41f7d69b          	sraiw	a3,a5,0x1f
ffffffffc0203ff2:	8fb5                	xor	a5,a5,a3
ffffffffc0203ff4:	40d786bb          	subw	a3,a5,a3
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
ffffffffc0203ff8:	02d74163          	blt	a4,a3,ffffffffc020401a <vprintfmt+0x29a>
ffffffffc0203ffc:	00369793          	slli	a5,a3,0x3
ffffffffc0204000:	97de                	add	a5,a5,s7
ffffffffc0204002:	639c                	ld	a5,0(a5)
ffffffffc0204004:	cb99                	beqz	a5,ffffffffc020401a <vprintfmt+0x29a>
                printfmt(putch, putdat, "%s", p);
ffffffffc0204006:	86be                	mv	a3,a5
ffffffffc0204008:	00000617          	auipc	a2,0x0
ffffffffc020400c:	1f060613          	addi	a2,a2,496 # ffffffffc02041f8 <etext+0x2c>
ffffffffc0204010:	85a6                	mv	a1,s1
ffffffffc0204012:	854a                	mv	a0,s2
ffffffffc0204014:	0ce000ef          	jal	ra,ffffffffc02040e2 <printfmt>
ffffffffc0204018:	b34d                	j	ffffffffc0203dba <vprintfmt+0x3a>
                printfmt(putch, putdat, "error %d", err);
ffffffffc020401a:	00002617          	auipc	a2,0x2
ffffffffc020401e:	dfe60613          	addi	a2,a2,-514 # ffffffffc0205e18 <default_pmm_manager+0xef8>
ffffffffc0204022:	85a6                	mv	a1,s1
ffffffffc0204024:	854a                	mv	a0,s2
ffffffffc0204026:	0bc000ef          	jal	ra,ffffffffc02040e2 <printfmt>
ffffffffc020402a:	bb41                	j	ffffffffc0203dba <vprintfmt+0x3a>
                p = "(null)";
ffffffffc020402c:	00002417          	auipc	s0,0x2
ffffffffc0204030:	de440413          	addi	s0,s0,-540 # ffffffffc0205e10 <default_pmm_manager+0xef0>
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc0204034:	85e2                	mv	a1,s8
ffffffffc0204036:	8522                	mv	a0,s0
ffffffffc0204038:	e43e                	sd	a5,8(sp)
ffffffffc020403a:	0e2000ef          	jal	ra,ffffffffc020411c <strnlen>
ffffffffc020403e:	40ad8dbb          	subw	s11,s11,a0
ffffffffc0204042:	01b05b63          	blez	s11,ffffffffc0204058 <vprintfmt+0x2d8>
                    putch(padc, putdat);
ffffffffc0204046:	67a2                	ld	a5,8(sp)
ffffffffc0204048:	00078a1b          	sext.w	s4,a5
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc020404c:	3dfd                	addiw	s11,s11,-1
                    putch(padc, putdat);
ffffffffc020404e:	85a6                	mv	a1,s1
ffffffffc0204050:	8552                	mv	a0,s4
ffffffffc0204052:	9902                	jalr	s2
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc0204054:	fe0d9ce3          	bnez	s11,ffffffffc020404c <vprintfmt+0x2cc>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0204058:	00044783          	lbu	a5,0(s0)
ffffffffc020405c:	00140a13          	addi	s4,s0,1
ffffffffc0204060:	0007851b          	sext.w	a0,a5
ffffffffc0204064:	d3a5                	beqz	a5,ffffffffc0203fc4 <vprintfmt+0x244>
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc0204066:	05e00413          	li	s0,94
ffffffffc020406a:	bf39                	j	ffffffffc0203f88 <vprintfmt+0x208>
        return va_arg(*ap, int);
ffffffffc020406c:	000a2403          	lw	s0,0(s4)
ffffffffc0204070:	b7ad                	j	ffffffffc0203fda <vprintfmt+0x25a>
        return va_arg(*ap, unsigned int);
ffffffffc0204072:	000a6603          	lwu	a2,0(s4)
ffffffffc0204076:	46a1                	li	a3,8
ffffffffc0204078:	8a2e                	mv	s4,a1
ffffffffc020407a:	bdb1                	j	ffffffffc0203ed6 <vprintfmt+0x156>
ffffffffc020407c:	000a6603          	lwu	a2,0(s4)
ffffffffc0204080:	46a9                	li	a3,10
ffffffffc0204082:	8a2e                	mv	s4,a1
ffffffffc0204084:	bd89                	j	ffffffffc0203ed6 <vprintfmt+0x156>
ffffffffc0204086:	000a6603          	lwu	a2,0(s4)
ffffffffc020408a:	46c1                	li	a3,16
ffffffffc020408c:	8a2e                	mv	s4,a1
ffffffffc020408e:	b5a1                	j	ffffffffc0203ed6 <vprintfmt+0x156>
                    putch(ch, putdat);
ffffffffc0204090:	9902                	jalr	s2
ffffffffc0204092:	bf09                	j	ffffffffc0203fa4 <vprintfmt+0x224>
                putch('-', putdat);
ffffffffc0204094:	85a6                	mv	a1,s1
ffffffffc0204096:	02d00513          	li	a0,45
ffffffffc020409a:	e03e                	sd	a5,0(sp)
ffffffffc020409c:	9902                	jalr	s2
                num = -(long long)num;
ffffffffc020409e:	6782                	ld	a5,0(sp)
ffffffffc02040a0:	8a66                	mv	s4,s9
ffffffffc02040a2:	40800633          	neg	a2,s0
ffffffffc02040a6:	46a9                	li	a3,10
ffffffffc02040a8:	b53d                	j	ffffffffc0203ed6 <vprintfmt+0x156>
            if (width > 0 && padc != '-') {
ffffffffc02040aa:	03b05163          	blez	s11,ffffffffc02040cc <vprintfmt+0x34c>
ffffffffc02040ae:	02d00693          	li	a3,45
ffffffffc02040b2:	f6d79de3          	bne	a5,a3,ffffffffc020402c <vprintfmt+0x2ac>
                p = "(null)";
ffffffffc02040b6:	00002417          	auipc	s0,0x2
ffffffffc02040ba:	d5a40413          	addi	s0,s0,-678 # ffffffffc0205e10 <default_pmm_manager+0xef0>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc02040be:	02800793          	li	a5,40
ffffffffc02040c2:	02800513          	li	a0,40
ffffffffc02040c6:	00140a13          	addi	s4,s0,1
ffffffffc02040ca:	bd6d                	j	ffffffffc0203f84 <vprintfmt+0x204>
ffffffffc02040cc:	00002a17          	auipc	s4,0x2
ffffffffc02040d0:	d45a0a13          	addi	s4,s4,-699 # ffffffffc0205e11 <default_pmm_manager+0xef1>
ffffffffc02040d4:	02800513          	li	a0,40
ffffffffc02040d8:	02800793          	li	a5,40
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc02040dc:	05e00413          	li	s0,94
ffffffffc02040e0:	b565                	j	ffffffffc0203f88 <vprintfmt+0x208>

ffffffffc02040e2 <printfmt>:
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
ffffffffc02040e2:	715d                	addi	sp,sp,-80
    va_start(ap, fmt);
ffffffffc02040e4:	02810313          	addi	t1,sp,40
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
ffffffffc02040e8:	f436                	sd	a3,40(sp)
    vprintfmt(putch, putdat, fmt, ap);
ffffffffc02040ea:	869a                	mv	a3,t1
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
ffffffffc02040ec:	ec06                	sd	ra,24(sp)
ffffffffc02040ee:	f83a                	sd	a4,48(sp)
ffffffffc02040f0:	fc3e                	sd	a5,56(sp)
ffffffffc02040f2:	e0c2                	sd	a6,64(sp)
ffffffffc02040f4:	e4c6                	sd	a7,72(sp)
    va_start(ap, fmt);
ffffffffc02040f6:	e41a                	sd	t1,8(sp)
    vprintfmt(putch, putdat, fmt, ap);
ffffffffc02040f8:	c89ff0ef          	jal	ra,ffffffffc0203d80 <vprintfmt>
}
ffffffffc02040fc:	60e2                	ld	ra,24(sp)
ffffffffc02040fe:	6161                	addi	sp,sp,80
ffffffffc0204100:	8082                	ret

ffffffffc0204102 <strlen>:
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
ffffffffc0204102:	00054783          	lbu	a5,0(a0)
strlen(const char *s) {
ffffffffc0204106:	872a                	mv	a4,a0
    size_t cnt = 0;
ffffffffc0204108:	4501                	li	a0,0
    while (*s ++ != '\0') {
ffffffffc020410a:	cb81                	beqz	a5,ffffffffc020411a <strlen+0x18>
        cnt ++;
ffffffffc020410c:	0505                	addi	a0,a0,1
    while (*s ++ != '\0') {
ffffffffc020410e:	00a707b3          	add	a5,a4,a0
ffffffffc0204112:	0007c783          	lbu	a5,0(a5)
ffffffffc0204116:	fbfd                	bnez	a5,ffffffffc020410c <strlen+0xa>
ffffffffc0204118:	8082                	ret
    }
    return cnt;
}
ffffffffc020411a:	8082                	ret

ffffffffc020411c <strnlen>:
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
ffffffffc020411c:	4781                	li	a5,0
    while (cnt < len && *s ++ != '\0') {
ffffffffc020411e:	e589                	bnez	a1,ffffffffc0204128 <strnlen+0xc>
ffffffffc0204120:	a811                	j	ffffffffc0204134 <strnlen+0x18>
        cnt ++;
ffffffffc0204122:	0785                	addi	a5,a5,1
    while (cnt < len && *s ++ != '\0') {
ffffffffc0204124:	00f58863          	beq	a1,a5,ffffffffc0204134 <strnlen+0x18>
ffffffffc0204128:	00f50733          	add	a4,a0,a5
ffffffffc020412c:	00074703          	lbu	a4,0(a4)
ffffffffc0204130:	fb6d                	bnez	a4,ffffffffc0204122 <strnlen+0x6>
ffffffffc0204132:	85be                	mv	a1,a5
    }
    return cnt;
}
ffffffffc0204134:	852e                	mv	a0,a1
ffffffffc0204136:	8082                	ret

ffffffffc0204138 <strcpy>:
char *
strcpy(char *dst, const char *src) {
#ifdef __HAVE_ARCH_STRCPY
    return __strcpy(dst, src);
#else
    char *p = dst;
ffffffffc0204138:	87aa                	mv	a5,a0
    while ((*p ++ = *src ++) != '\0')
ffffffffc020413a:	0005c703          	lbu	a4,0(a1)
ffffffffc020413e:	0785                	addi	a5,a5,1
ffffffffc0204140:	0585                	addi	a1,a1,1
ffffffffc0204142:	fee78fa3          	sb	a4,-1(a5)
ffffffffc0204146:	fb75                	bnez	a4,ffffffffc020413a <strcpy+0x2>
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
ffffffffc0204148:	8082                	ret

ffffffffc020414a <strcmp>:
int
strcmp(const char *s1, const char *s2) {
#ifdef __HAVE_ARCH_STRCMP
    return __strcmp(s1, s2);
#else
    while (*s1 != '\0' && *s1 == *s2) {
ffffffffc020414a:	00054783          	lbu	a5,0(a0)
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc020414e:	0005c703          	lbu	a4,0(a1)
    while (*s1 != '\0' && *s1 == *s2) {
ffffffffc0204152:	cb89                	beqz	a5,ffffffffc0204164 <strcmp+0x1a>
        s1 ++, s2 ++;
ffffffffc0204154:	0505                	addi	a0,a0,1
ffffffffc0204156:	0585                	addi	a1,a1,1
    while (*s1 != '\0' && *s1 == *s2) {
ffffffffc0204158:	fee789e3          	beq	a5,a4,ffffffffc020414a <strcmp>
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc020415c:	0007851b          	sext.w	a0,a5
#endif /* __HAVE_ARCH_STRCMP */
}
ffffffffc0204160:	9d19                	subw	a0,a0,a4
ffffffffc0204162:	8082                	ret
ffffffffc0204164:	4501                	li	a0,0
ffffffffc0204166:	bfed                	j	ffffffffc0204160 <strcmp+0x16>

ffffffffc0204168 <strchr>:
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
ffffffffc0204168:	00054783          	lbu	a5,0(a0)
ffffffffc020416c:	c799                	beqz	a5,ffffffffc020417a <strchr+0x12>
        if (*s == c) {
ffffffffc020416e:	00f58763          	beq	a1,a5,ffffffffc020417c <strchr+0x14>
    while (*s != '\0') {
ffffffffc0204172:	00154783          	lbu	a5,1(a0)
            return (char *)s;
        }
        s ++;
ffffffffc0204176:	0505                	addi	a0,a0,1
    while (*s != '\0') {
ffffffffc0204178:	fbfd                	bnez	a5,ffffffffc020416e <strchr+0x6>
    }
    return NULL;
ffffffffc020417a:	4501                	li	a0,0
}
ffffffffc020417c:	8082                	ret

ffffffffc020417e <memset>:
memset(void *s, char c, size_t n) {
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
#else
    char *p = s;
    while (n -- > 0) {
ffffffffc020417e:	ca01                	beqz	a2,ffffffffc020418e <memset+0x10>
ffffffffc0204180:	962a                	add	a2,a2,a0
    char *p = s;
ffffffffc0204182:	87aa                	mv	a5,a0
        *p ++ = c;
ffffffffc0204184:	0785                	addi	a5,a5,1
ffffffffc0204186:	feb78fa3          	sb	a1,-1(a5)
    while (n -- > 0) {
ffffffffc020418a:	fec79de3          	bne	a5,a2,ffffffffc0204184 <memset+0x6>
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
ffffffffc020418e:	8082                	ret

ffffffffc0204190 <memcpy>:
#ifdef __HAVE_ARCH_MEMCPY
    return __memcpy(dst, src, n);
#else
    const char *s = src;
    char *d = dst;
    while (n -- > 0) {
ffffffffc0204190:	ca19                	beqz	a2,ffffffffc02041a6 <memcpy+0x16>
ffffffffc0204192:	962e                	add	a2,a2,a1
    char *d = dst;
ffffffffc0204194:	87aa                	mv	a5,a0
        *d ++ = *s ++;
ffffffffc0204196:	0005c703          	lbu	a4,0(a1)
ffffffffc020419a:	0585                	addi	a1,a1,1
ffffffffc020419c:	0785                	addi	a5,a5,1
ffffffffc020419e:	fee78fa3          	sb	a4,-1(a5)
    while (n -- > 0) {
ffffffffc02041a2:	fec59ae3          	bne	a1,a2,ffffffffc0204196 <memcpy+0x6>
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
ffffffffc02041a6:	8082                	ret

ffffffffc02041a8 <memcmp>:
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
    const char *s1 = (const char *)v1;
    const char *s2 = (const char *)v2;
    while (n -- > 0) {
ffffffffc02041a8:	c205                	beqz	a2,ffffffffc02041c8 <memcmp+0x20>
ffffffffc02041aa:	962e                	add	a2,a2,a1
ffffffffc02041ac:	a019                	j	ffffffffc02041b2 <memcmp+0xa>
ffffffffc02041ae:	00c58d63          	beq	a1,a2,ffffffffc02041c8 <memcmp+0x20>
        if (*s1 != *s2) {
ffffffffc02041b2:	00054783          	lbu	a5,0(a0)
ffffffffc02041b6:	0005c703          	lbu	a4,0(a1)
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
        }
        s1 ++, s2 ++;
ffffffffc02041ba:	0505                	addi	a0,a0,1
ffffffffc02041bc:	0585                	addi	a1,a1,1
        if (*s1 != *s2) {
ffffffffc02041be:	fee788e3          	beq	a5,a4,ffffffffc02041ae <memcmp+0x6>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc02041c2:	40e7853b          	subw	a0,a5,a4
ffffffffc02041c6:	8082                	ret
    }
    return 0;
ffffffffc02041c8:	4501                	li	a0,0
}
ffffffffc02041ca:	8082                	ret
