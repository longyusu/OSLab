
bin/kernel:     file format elf64-littleriscv


Disassembly of section .text:

ffffffffc0200000 <kern_entry>:
ffffffffc0200000:	c02052b7          	lui	t0,0xc0205
ffffffffc0200004:	ffd0031b          	addiw	t1,zero,-3
ffffffffc0200008:	037a                	slli	t1,t1,0x1e
ffffffffc020000a:	406282b3          	sub	t0,t0,t1
ffffffffc020000e:	00c2d293          	srli	t0,t0,0xc
ffffffffc0200012:	fff0031b          	addiw	t1,zero,-1
ffffffffc0200016:	137e                	slli	t1,t1,0x3f
ffffffffc0200018:	0062e2b3          	or	t0,t0,t1
ffffffffc020001c:	18029073          	csrw	satp,t0
ffffffffc0200020:	12000073          	sfence.vma
ffffffffc0200024:	c0205137          	lui	sp,0xc0205
ffffffffc0200028:	c02002b7          	lui	t0,0xc0200
ffffffffc020002c:	03228293          	addi	t0,t0,50 # ffffffffc0200032 <kern_init>
ffffffffc0200030:	8282                	jr	t0

ffffffffc0200032 <kern_init>:
ffffffffc0200032:	00006517          	auipc	a0,0x6
ffffffffc0200036:	fde50513          	addi	a0,a0,-34 # ffffffffc0206010 <bffree_area>
ffffffffc020003a:	00006617          	auipc	a2,0x6
ffffffffc020003e:	43660613          	addi	a2,a2,1078 # ffffffffc0206470 <end>
ffffffffc0200042:	1141                	addi	sp,sp,-16
ffffffffc0200044:	8e09                	sub	a2,a2,a0
ffffffffc0200046:	4581                	li	a1,0
ffffffffc0200048:	e406                	sd	ra,8(sp)
ffffffffc020004a:	464010ef          	jal	ra,ffffffffc02014ae <memset>
ffffffffc020004e:	3fc000ef          	jal	ra,ffffffffc020044a <cons_init>
ffffffffc0200052:	00002517          	auipc	a0,0x2
ffffffffc0200056:	96650513          	addi	a0,a0,-1690 # ffffffffc02019b8 <etext+0x6>
ffffffffc020005a:	090000ef          	jal	ra,ffffffffc02000ea <cputs>
ffffffffc020005e:	138000ef          	jal	ra,ffffffffc0200196 <print_kerninfo>
ffffffffc0200062:	402000ef          	jal	ra,ffffffffc0200464 <idt_init>
ffffffffc0200066:	053000ef          	jal	ra,ffffffffc02008b8 <pmm_init>
ffffffffc020006a:	3fa000ef          	jal	ra,ffffffffc0200464 <idt_init>
ffffffffc020006e:	39a000ef          	jal	ra,ffffffffc0200408 <clock_init>
ffffffffc0200072:	3e6000ef          	jal	ra,ffffffffc0200458 <intr_enable>
ffffffffc0200076:	a001                	j	ffffffffc0200076 <kern_init+0x44>

ffffffffc0200078 <cputch>:
ffffffffc0200078:	1141                	addi	sp,sp,-16
ffffffffc020007a:	e022                	sd	s0,0(sp)
ffffffffc020007c:	e406                	sd	ra,8(sp)
ffffffffc020007e:	842e                	mv	s0,a1
ffffffffc0200080:	3cc000ef          	jal	ra,ffffffffc020044c <cons_putc>
ffffffffc0200084:	401c                	lw	a5,0(s0)
ffffffffc0200086:	60a2                	ld	ra,8(sp)
ffffffffc0200088:	2785                	addiw	a5,a5,1
ffffffffc020008a:	c01c                	sw	a5,0(s0)
ffffffffc020008c:	6402                	ld	s0,0(sp)
ffffffffc020008e:	0141                	addi	sp,sp,16
ffffffffc0200090:	8082                	ret

ffffffffc0200092 <vcprintf>:
ffffffffc0200092:	1101                	addi	sp,sp,-32
ffffffffc0200094:	862a                	mv	a2,a0
ffffffffc0200096:	86ae                	mv	a3,a1
ffffffffc0200098:	00000517          	auipc	a0,0x0
ffffffffc020009c:	fe050513          	addi	a0,a0,-32 # ffffffffc0200078 <cputch>
ffffffffc02000a0:	006c                	addi	a1,sp,12
ffffffffc02000a2:	ec06                	sd	ra,24(sp)
ffffffffc02000a4:	c602                	sw	zero,12(sp)
ffffffffc02000a6:	486010ef          	jal	ra,ffffffffc020152c <vprintfmt>
ffffffffc02000aa:	60e2                	ld	ra,24(sp)
ffffffffc02000ac:	4532                	lw	a0,12(sp)
ffffffffc02000ae:	6105                	addi	sp,sp,32
ffffffffc02000b0:	8082                	ret

ffffffffc02000b2 <cprintf>:
ffffffffc02000b2:	711d                	addi	sp,sp,-96
ffffffffc02000b4:	02810313          	addi	t1,sp,40 # ffffffffc0205028 <boot_page_table_sv39+0x28>
ffffffffc02000b8:	8e2a                	mv	t3,a0
ffffffffc02000ba:	f42e                	sd	a1,40(sp)
ffffffffc02000bc:	f832                	sd	a2,48(sp)
ffffffffc02000be:	fc36                	sd	a3,56(sp)
ffffffffc02000c0:	00000517          	auipc	a0,0x0
ffffffffc02000c4:	fb850513          	addi	a0,a0,-72 # ffffffffc0200078 <cputch>
ffffffffc02000c8:	004c                	addi	a1,sp,4
ffffffffc02000ca:	869a                	mv	a3,t1
ffffffffc02000cc:	8672                	mv	a2,t3
ffffffffc02000ce:	ec06                	sd	ra,24(sp)
ffffffffc02000d0:	e0ba                	sd	a4,64(sp)
ffffffffc02000d2:	e4be                	sd	a5,72(sp)
ffffffffc02000d4:	e8c2                	sd	a6,80(sp)
ffffffffc02000d6:	ecc6                	sd	a7,88(sp)
ffffffffc02000d8:	e41a                	sd	t1,8(sp)
ffffffffc02000da:	c202                	sw	zero,4(sp)
ffffffffc02000dc:	450010ef          	jal	ra,ffffffffc020152c <vprintfmt>
ffffffffc02000e0:	60e2                	ld	ra,24(sp)
ffffffffc02000e2:	4512                	lw	a0,4(sp)
ffffffffc02000e4:	6125                	addi	sp,sp,96
ffffffffc02000e6:	8082                	ret

ffffffffc02000e8 <cputchar>:
ffffffffc02000e8:	a695                	j	ffffffffc020044c <cons_putc>

ffffffffc02000ea <cputs>:
ffffffffc02000ea:	1101                	addi	sp,sp,-32
ffffffffc02000ec:	e822                	sd	s0,16(sp)
ffffffffc02000ee:	ec06                	sd	ra,24(sp)
ffffffffc02000f0:	e426                	sd	s1,8(sp)
ffffffffc02000f2:	842a                	mv	s0,a0
ffffffffc02000f4:	00054503          	lbu	a0,0(a0)
ffffffffc02000f8:	c51d                	beqz	a0,ffffffffc0200126 <cputs+0x3c>
ffffffffc02000fa:	0405                	addi	s0,s0,1
ffffffffc02000fc:	4485                	li	s1,1
ffffffffc02000fe:	9c81                	subw	s1,s1,s0
ffffffffc0200100:	34c000ef          	jal	ra,ffffffffc020044c <cons_putc>
ffffffffc0200104:	00044503          	lbu	a0,0(s0)
ffffffffc0200108:	008487bb          	addw	a5,s1,s0
ffffffffc020010c:	0405                	addi	s0,s0,1
ffffffffc020010e:	f96d                	bnez	a0,ffffffffc0200100 <cputs+0x16>
ffffffffc0200110:	0017841b          	addiw	s0,a5,1
ffffffffc0200114:	4529                	li	a0,10
ffffffffc0200116:	336000ef          	jal	ra,ffffffffc020044c <cons_putc>
ffffffffc020011a:	60e2                	ld	ra,24(sp)
ffffffffc020011c:	8522                	mv	a0,s0
ffffffffc020011e:	6442                	ld	s0,16(sp)
ffffffffc0200120:	64a2                	ld	s1,8(sp)
ffffffffc0200122:	6105                	addi	sp,sp,32
ffffffffc0200124:	8082                	ret
ffffffffc0200126:	4405                	li	s0,1
ffffffffc0200128:	b7f5                	j	ffffffffc0200114 <cputs+0x2a>

ffffffffc020012a <getchar>:
ffffffffc020012a:	1141                	addi	sp,sp,-16
ffffffffc020012c:	e406                	sd	ra,8(sp)
ffffffffc020012e:	326000ef          	jal	ra,ffffffffc0200454 <cons_getc>
ffffffffc0200132:	dd75                	beqz	a0,ffffffffc020012e <getchar+0x4>
ffffffffc0200134:	60a2                	ld	ra,8(sp)
ffffffffc0200136:	0141                	addi	sp,sp,16
ffffffffc0200138:	8082                	ret

ffffffffc020013a <__panic>:
ffffffffc020013a:	00006317          	auipc	t1,0x6
ffffffffc020013e:	2ee30313          	addi	t1,t1,750 # ffffffffc0206428 <is_panic>
ffffffffc0200142:	00032e03          	lw	t3,0(t1)
ffffffffc0200146:	715d                	addi	sp,sp,-80
ffffffffc0200148:	ec06                	sd	ra,24(sp)
ffffffffc020014a:	e822                	sd	s0,16(sp)
ffffffffc020014c:	f436                	sd	a3,40(sp)
ffffffffc020014e:	f83a                	sd	a4,48(sp)
ffffffffc0200150:	fc3e                	sd	a5,56(sp)
ffffffffc0200152:	e0c2                	sd	a6,64(sp)
ffffffffc0200154:	e4c6                	sd	a7,72(sp)
ffffffffc0200156:	020e1a63          	bnez	t3,ffffffffc020018a <__panic+0x50>
ffffffffc020015a:	4785                	li	a5,1
ffffffffc020015c:	00f32023          	sw	a5,0(t1)
ffffffffc0200160:	8432                	mv	s0,a2
ffffffffc0200162:	103c                	addi	a5,sp,40
ffffffffc0200164:	862e                	mv	a2,a1
ffffffffc0200166:	85aa                	mv	a1,a0
ffffffffc0200168:	00002517          	auipc	a0,0x2
ffffffffc020016c:	87050513          	addi	a0,a0,-1936 # ffffffffc02019d8 <etext+0x26>
ffffffffc0200170:	e43e                	sd	a5,8(sp)
ffffffffc0200172:	f41ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc0200176:	65a2                	ld	a1,8(sp)
ffffffffc0200178:	8522                	mv	a0,s0
ffffffffc020017a:	f19ff0ef          	jal	ra,ffffffffc0200092 <vcprintf>
ffffffffc020017e:	00002517          	auipc	a0,0x2
ffffffffc0200182:	94250513          	addi	a0,a0,-1726 # ffffffffc0201ac0 <etext+0x10e>
ffffffffc0200186:	f2dff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc020018a:	2d4000ef          	jal	ra,ffffffffc020045e <intr_disable>
ffffffffc020018e:	4501                	li	a0,0
ffffffffc0200190:	130000ef          	jal	ra,ffffffffc02002c0 <kmonitor>
ffffffffc0200194:	bfed                	j	ffffffffc020018e <__panic+0x54>

ffffffffc0200196 <print_kerninfo>:
ffffffffc0200196:	1141                	addi	sp,sp,-16
ffffffffc0200198:	00002517          	auipc	a0,0x2
ffffffffc020019c:	86050513          	addi	a0,a0,-1952 # ffffffffc02019f8 <etext+0x46>
ffffffffc02001a0:	e406                	sd	ra,8(sp)
ffffffffc02001a2:	f11ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc02001a6:	00000597          	auipc	a1,0x0
ffffffffc02001aa:	e8c58593          	addi	a1,a1,-372 # ffffffffc0200032 <kern_init>
ffffffffc02001ae:	00002517          	auipc	a0,0x2
ffffffffc02001b2:	86a50513          	addi	a0,a0,-1942 # ffffffffc0201a18 <etext+0x66>
ffffffffc02001b6:	efdff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc02001ba:	00001597          	auipc	a1,0x1
ffffffffc02001be:	7f858593          	addi	a1,a1,2040 # ffffffffc02019b2 <etext>
ffffffffc02001c2:	00002517          	auipc	a0,0x2
ffffffffc02001c6:	87650513          	addi	a0,a0,-1930 # ffffffffc0201a38 <etext+0x86>
ffffffffc02001ca:	ee9ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc02001ce:	00006597          	auipc	a1,0x6
ffffffffc02001d2:	e4258593          	addi	a1,a1,-446 # ffffffffc0206010 <bffree_area>
ffffffffc02001d6:	00002517          	auipc	a0,0x2
ffffffffc02001da:	88250513          	addi	a0,a0,-1918 # ffffffffc0201a58 <etext+0xa6>
ffffffffc02001de:	ed5ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc02001e2:	00006597          	auipc	a1,0x6
ffffffffc02001e6:	28e58593          	addi	a1,a1,654 # ffffffffc0206470 <end>
ffffffffc02001ea:	00002517          	auipc	a0,0x2
ffffffffc02001ee:	88e50513          	addi	a0,a0,-1906 # ffffffffc0201a78 <etext+0xc6>
ffffffffc02001f2:	ec1ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc02001f6:	00006597          	auipc	a1,0x6
ffffffffc02001fa:	67958593          	addi	a1,a1,1657 # ffffffffc020686f <end+0x3ff>
ffffffffc02001fe:	00000797          	auipc	a5,0x0
ffffffffc0200202:	e3478793          	addi	a5,a5,-460 # ffffffffc0200032 <kern_init>
ffffffffc0200206:	40f587b3          	sub	a5,a1,a5
ffffffffc020020a:	43f7d593          	srai	a1,a5,0x3f
ffffffffc020020e:	60a2                	ld	ra,8(sp)
ffffffffc0200210:	3ff5f593          	andi	a1,a1,1023
ffffffffc0200214:	95be                	add	a1,a1,a5
ffffffffc0200216:	85a9                	srai	a1,a1,0xa
ffffffffc0200218:	00002517          	auipc	a0,0x2
ffffffffc020021c:	88050513          	addi	a0,a0,-1920 # ffffffffc0201a98 <etext+0xe6>
ffffffffc0200220:	0141                	addi	sp,sp,16
ffffffffc0200222:	bd41                	j	ffffffffc02000b2 <cprintf>

ffffffffc0200224 <print_stackframe>:
ffffffffc0200224:	1141                	addi	sp,sp,-16
ffffffffc0200226:	00002617          	auipc	a2,0x2
ffffffffc020022a:	8a260613          	addi	a2,a2,-1886 # ffffffffc0201ac8 <etext+0x116>
ffffffffc020022e:	04e00593          	li	a1,78
ffffffffc0200232:	00002517          	auipc	a0,0x2
ffffffffc0200236:	8ae50513          	addi	a0,a0,-1874 # ffffffffc0201ae0 <etext+0x12e>
ffffffffc020023a:	e406                	sd	ra,8(sp)
ffffffffc020023c:	effff0ef          	jal	ra,ffffffffc020013a <__panic>

ffffffffc0200240 <mon_help>:
ffffffffc0200240:	1141                	addi	sp,sp,-16
ffffffffc0200242:	00002617          	auipc	a2,0x2
ffffffffc0200246:	8b660613          	addi	a2,a2,-1866 # ffffffffc0201af8 <etext+0x146>
ffffffffc020024a:	00002597          	auipc	a1,0x2
ffffffffc020024e:	8ce58593          	addi	a1,a1,-1842 # ffffffffc0201b18 <etext+0x166>
ffffffffc0200252:	00002517          	auipc	a0,0x2
ffffffffc0200256:	8ce50513          	addi	a0,a0,-1842 # ffffffffc0201b20 <etext+0x16e>
ffffffffc020025a:	e406                	sd	ra,8(sp)
ffffffffc020025c:	e57ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc0200260:	00002617          	auipc	a2,0x2
ffffffffc0200264:	8d060613          	addi	a2,a2,-1840 # ffffffffc0201b30 <etext+0x17e>
ffffffffc0200268:	00002597          	auipc	a1,0x2
ffffffffc020026c:	8f058593          	addi	a1,a1,-1808 # ffffffffc0201b58 <etext+0x1a6>
ffffffffc0200270:	00002517          	auipc	a0,0x2
ffffffffc0200274:	8b050513          	addi	a0,a0,-1872 # ffffffffc0201b20 <etext+0x16e>
ffffffffc0200278:	e3bff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc020027c:	00002617          	auipc	a2,0x2
ffffffffc0200280:	8ec60613          	addi	a2,a2,-1812 # ffffffffc0201b68 <etext+0x1b6>
ffffffffc0200284:	00002597          	auipc	a1,0x2
ffffffffc0200288:	90458593          	addi	a1,a1,-1788 # ffffffffc0201b88 <etext+0x1d6>
ffffffffc020028c:	00002517          	auipc	a0,0x2
ffffffffc0200290:	89450513          	addi	a0,a0,-1900 # ffffffffc0201b20 <etext+0x16e>
ffffffffc0200294:	e1fff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc0200298:	60a2                	ld	ra,8(sp)
ffffffffc020029a:	4501                	li	a0,0
ffffffffc020029c:	0141                	addi	sp,sp,16
ffffffffc020029e:	8082                	ret

ffffffffc02002a0 <mon_kerninfo>:
ffffffffc02002a0:	1141                	addi	sp,sp,-16
ffffffffc02002a2:	e406                	sd	ra,8(sp)
ffffffffc02002a4:	ef3ff0ef          	jal	ra,ffffffffc0200196 <print_kerninfo>
ffffffffc02002a8:	60a2                	ld	ra,8(sp)
ffffffffc02002aa:	4501                	li	a0,0
ffffffffc02002ac:	0141                	addi	sp,sp,16
ffffffffc02002ae:	8082                	ret

ffffffffc02002b0 <mon_backtrace>:
ffffffffc02002b0:	1141                	addi	sp,sp,-16
ffffffffc02002b2:	e406                	sd	ra,8(sp)
ffffffffc02002b4:	f71ff0ef          	jal	ra,ffffffffc0200224 <print_stackframe>
ffffffffc02002b8:	60a2                	ld	ra,8(sp)
ffffffffc02002ba:	4501                	li	a0,0
ffffffffc02002bc:	0141                	addi	sp,sp,16
ffffffffc02002be:	8082                	ret

ffffffffc02002c0 <kmonitor>:
ffffffffc02002c0:	7115                	addi	sp,sp,-224
ffffffffc02002c2:	ed5e                	sd	s7,152(sp)
ffffffffc02002c4:	8baa                	mv	s7,a0
ffffffffc02002c6:	00002517          	auipc	a0,0x2
ffffffffc02002ca:	8d250513          	addi	a0,a0,-1838 # ffffffffc0201b98 <etext+0x1e6>
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
ffffffffc02002e4:	dcfff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc02002e8:	00002517          	auipc	a0,0x2
ffffffffc02002ec:	8d850513          	addi	a0,a0,-1832 # ffffffffc0201bc0 <etext+0x20e>
ffffffffc02002f0:	dc3ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc02002f4:	000b8563          	beqz	s7,ffffffffc02002fe <kmonitor+0x3e>
ffffffffc02002f8:	855e                	mv	a0,s7
ffffffffc02002fa:	348000ef          	jal	ra,ffffffffc0200642 <print_trapframe>
ffffffffc02002fe:	00002c17          	auipc	s8,0x2
ffffffffc0200302:	932c0c13          	addi	s8,s8,-1742 # ffffffffc0201c30 <commands>
ffffffffc0200306:	00002917          	auipc	s2,0x2
ffffffffc020030a:	8e290913          	addi	s2,s2,-1822 # ffffffffc0201be8 <etext+0x236>
ffffffffc020030e:	00002497          	auipc	s1,0x2
ffffffffc0200312:	8e248493          	addi	s1,s1,-1822 # ffffffffc0201bf0 <etext+0x23e>
ffffffffc0200316:	49bd                	li	s3,15
ffffffffc0200318:	00002b17          	auipc	s6,0x2
ffffffffc020031c:	8e0b0b13          	addi	s6,s6,-1824 # ffffffffc0201bf8 <etext+0x246>
ffffffffc0200320:	00001a17          	auipc	s4,0x1
ffffffffc0200324:	7f8a0a13          	addi	s4,s4,2040 # ffffffffc0201b18 <etext+0x166>
ffffffffc0200328:	4a8d                	li	s5,3
ffffffffc020032a:	854a                	mv	a0,s2
ffffffffc020032c:	5d2010ef          	jal	ra,ffffffffc02018fe <readline>
ffffffffc0200330:	842a                	mv	s0,a0
ffffffffc0200332:	dd65                	beqz	a0,ffffffffc020032a <kmonitor+0x6a>
ffffffffc0200334:	00054583          	lbu	a1,0(a0)
ffffffffc0200338:	4c81                	li	s9,0
ffffffffc020033a:	e1bd                	bnez	a1,ffffffffc02003a0 <kmonitor+0xe0>
ffffffffc020033c:	fe0c87e3          	beqz	s9,ffffffffc020032a <kmonitor+0x6a>
ffffffffc0200340:	6582                	ld	a1,0(sp)
ffffffffc0200342:	00002d17          	auipc	s10,0x2
ffffffffc0200346:	8eed0d13          	addi	s10,s10,-1810 # ffffffffc0201c30 <commands>
ffffffffc020034a:	8552                	mv	a0,s4
ffffffffc020034c:	4401                	li	s0,0
ffffffffc020034e:	0d61                	addi	s10,s10,24
ffffffffc0200350:	12a010ef          	jal	ra,ffffffffc020147a <strcmp>
ffffffffc0200354:	c919                	beqz	a0,ffffffffc020036a <kmonitor+0xaa>
ffffffffc0200356:	2405                	addiw	s0,s0,1
ffffffffc0200358:	0b540063          	beq	s0,s5,ffffffffc02003f8 <kmonitor+0x138>
ffffffffc020035c:	000d3503          	ld	a0,0(s10)
ffffffffc0200360:	6582                	ld	a1,0(sp)
ffffffffc0200362:	0d61                	addi	s10,s10,24
ffffffffc0200364:	116010ef          	jal	ra,ffffffffc020147a <strcmp>
ffffffffc0200368:	f57d                	bnez	a0,ffffffffc0200356 <kmonitor+0x96>
ffffffffc020036a:	00141793          	slli	a5,s0,0x1
ffffffffc020036e:	97a2                	add	a5,a5,s0
ffffffffc0200370:	078e                	slli	a5,a5,0x3
ffffffffc0200372:	97e2                	add	a5,a5,s8
ffffffffc0200374:	6b9c                	ld	a5,16(a5)
ffffffffc0200376:	865e                	mv	a2,s7
ffffffffc0200378:	002c                	addi	a1,sp,8
ffffffffc020037a:	fffc851b          	addiw	a0,s9,-1
ffffffffc020037e:	9782                	jalr	a5
ffffffffc0200380:	fa0555e3          	bgez	a0,ffffffffc020032a <kmonitor+0x6a>
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
ffffffffc02003a0:	8526                	mv	a0,s1
ffffffffc02003a2:	0f6010ef          	jal	ra,ffffffffc0201498 <strchr>
ffffffffc02003a6:	c901                	beqz	a0,ffffffffc02003b6 <kmonitor+0xf6>
ffffffffc02003a8:	00144583          	lbu	a1,1(s0)
ffffffffc02003ac:	00040023          	sb	zero,0(s0)
ffffffffc02003b0:	0405                	addi	s0,s0,1
ffffffffc02003b2:	d5c9                	beqz	a1,ffffffffc020033c <kmonitor+0x7c>
ffffffffc02003b4:	b7f5                	j	ffffffffc02003a0 <kmonitor+0xe0>
ffffffffc02003b6:	00044783          	lbu	a5,0(s0)
ffffffffc02003ba:	d3c9                	beqz	a5,ffffffffc020033c <kmonitor+0x7c>
ffffffffc02003bc:	033c8963          	beq	s9,s3,ffffffffc02003ee <kmonitor+0x12e>
ffffffffc02003c0:	003c9793          	slli	a5,s9,0x3
ffffffffc02003c4:	0118                	addi	a4,sp,128
ffffffffc02003c6:	97ba                	add	a5,a5,a4
ffffffffc02003c8:	f887b023          	sd	s0,-128(a5)
ffffffffc02003cc:	00044583          	lbu	a1,0(s0)
ffffffffc02003d0:	2c85                	addiw	s9,s9,1
ffffffffc02003d2:	e591                	bnez	a1,ffffffffc02003de <kmonitor+0x11e>
ffffffffc02003d4:	b7b5                	j	ffffffffc0200340 <kmonitor+0x80>
ffffffffc02003d6:	00144583          	lbu	a1,1(s0)
ffffffffc02003da:	0405                	addi	s0,s0,1
ffffffffc02003dc:	d1a5                	beqz	a1,ffffffffc020033c <kmonitor+0x7c>
ffffffffc02003de:	8526                	mv	a0,s1
ffffffffc02003e0:	0b8010ef          	jal	ra,ffffffffc0201498 <strchr>
ffffffffc02003e4:	d96d                	beqz	a0,ffffffffc02003d6 <kmonitor+0x116>
ffffffffc02003e6:	00044583          	lbu	a1,0(s0)
ffffffffc02003ea:	d9a9                	beqz	a1,ffffffffc020033c <kmonitor+0x7c>
ffffffffc02003ec:	bf55                	j	ffffffffc02003a0 <kmonitor+0xe0>
ffffffffc02003ee:	45c1                	li	a1,16
ffffffffc02003f0:	855a                	mv	a0,s6
ffffffffc02003f2:	cc1ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc02003f6:	b7e9                	j	ffffffffc02003c0 <kmonitor+0x100>
ffffffffc02003f8:	6582                	ld	a1,0(sp)
ffffffffc02003fa:	00002517          	auipc	a0,0x2
ffffffffc02003fe:	81e50513          	addi	a0,a0,-2018 # ffffffffc0201c18 <etext+0x266>
ffffffffc0200402:	cb1ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc0200406:	b715                	j	ffffffffc020032a <kmonitor+0x6a>

ffffffffc0200408 <clock_init>:
ffffffffc0200408:	1141                	addi	sp,sp,-16
ffffffffc020040a:	e406                	sd	ra,8(sp)
ffffffffc020040c:	02000793          	li	a5,32
ffffffffc0200410:	1047a7f3          	csrrs	a5,sie,a5
ffffffffc0200414:	c0102573          	rdtime	a0
ffffffffc0200418:	67e1                	lui	a5,0x18
ffffffffc020041a:	6a078793          	addi	a5,a5,1696 # 186a0 <kern_entry-0xffffffffc01e7960>
ffffffffc020041e:	953e                	add	a0,a0,a5
ffffffffc0200420:	4a8010ef          	jal	ra,ffffffffc02018c8 <sbi_set_timer>
ffffffffc0200424:	60a2                	ld	ra,8(sp)
ffffffffc0200426:	00006797          	auipc	a5,0x6
ffffffffc020042a:	0007b523          	sd	zero,10(a5) # ffffffffc0206430 <ticks>
ffffffffc020042e:	00002517          	auipc	a0,0x2
ffffffffc0200432:	84a50513          	addi	a0,a0,-1974 # ffffffffc0201c78 <commands+0x48>
ffffffffc0200436:	0141                	addi	sp,sp,16
ffffffffc0200438:	b9ad                	j	ffffffffc02000b2 <cprintf>

ffffffffc020043a <clock_set_next_event>:
ffffffffc020043a:	c0102573          	rdtime	a0
ffffffffc020043e:	67e1                	lui	a5,0x18
ffffffffc0200440:	6a078793          	addi	a5,a5,1696 # 186a0 <kern_entry-0xffffffffc01e7960>
ffffffffc0200444:	953e                	add	a0,a0,a5
ffffffffc0200446:	4820106f          	j	ffffffffc02018c8 <sbi_set_timer>

ffffffffc020044a <cons_init>:
ffffffffc020044a:	8082                	ret

ffffffffc020044c <cons_putc>:
ffffffffc020044c:	0ff57513          	zext.b	a0,a0
ffffffffc0200450:	45e0106f          	j	ffffffffc02018ae <sbi_console_putchar>

ffffffffc0200454 <cons_getc>:
ffffffffc0200454:	48e0106f          	j	ffffffffc02018e2 <sbi_console_getchar>

ffffffffc0200458 <intr_enable>:
ffffffffc0200458:	100167f3          	csrrsi	a5,sstatus,2
ffffffffc020045c:	8082                	ret

ffffffffc020045e <intr_disable>:
ffffffffc020045e:	100177f3          	csrrci	a5,sstatus,2
ffffffffc0200462:	8082                	ret

ffffffffc0200464 <idt_init>:
ffffffffc0200464:	14005073          	csrwi	sscratch,0
ffffffffc0200468:	00000797          	auipc	a5,0x0
ffffffffc020046c:	2e478793          	addi	a5,a5,740 # ffffffffc020074c <__alltraps>
ffffffffc0200470:	10579073          	csrw	stvec,a5
ffffffffc0200474:	8082                	ret

ffffffffc0200476 <print_regs>:
ffffffffc0200476:	610c                	ld	a1,0(a0)
ffffffffc0200478:	1141                	addi	sp,sp,-16
ffffffffc020047a:	e022                	sd	s0,0(sp)
ffffffffc020047c:	842a                	mv	s0,a0
ffffffffc020047e:	00002517          	auipc	a0,0x2
ffffffffc0200482:	81a50513          	addi	a0,a0,-2022 # ffffffffc0201c98 <commands+0x68>
ffffffffc0200486:	e406                	sd	ra,8(sp)
ffffffffc0200488:	c2bff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc020048c:	640c                	ld	a1,8(s0)
ffffffffc020048e:	00002517          	auipc	a0,0x2
ffffffffc0200492:	82250513          	addi	a0,a0,-2014 # ffffffffc0201cb0 <commands+0x80>
ffffffffc0200496:	c1dff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc020049a:	680c                	ld	a1,16(s0)
ffffffffc020049c:	00002517          	auipc	a0,0x2
ffffffffc02004a0:	82c50513          	addi	a0,a0,-2004 # ffffffffc0201cc8 <commands+0x98>
ffffffffc02004a4:	c0fff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc02004a8:	6c0c                	ld	a1,24(s0)
ffffffffc02004aa:	00002517          	auipc	a0,0x2
ffffffffc02004ae:	83650513          	addi	a0,a0,-1994 # ffffffffc0201ce0 <commands+0xb0>
ffffffffc02004b2:	c01ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc02004b6:	700c                	ld	a1,32(s0)
ffffffffc02004b8:	00002517          	auipc	a0,0x2
ffffffffc02004bc:	84050513          	addi	a0,a0,-1984 # ffffffffc0201cf8 <commands+0xc8>
ffffffffc02004c0:	bf3ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc02004c4:	740c                	ld	a1,40(s0)
ffffffffc02004c6:	00002517          	auipc	a0,0x2
ffffffffc02004ca:	84a50513          	addi	a0,a0,-1974 # ffffffffc0201d10 <commands+0xe0>
ffffffffc02004ce:	be5ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc02004d2:	780c                	ld	a1,48(s0)
ffffffffc02004d4:	00002517          	auipc	a0,0x2
ffffffffc02004d8:	85450513          	addi	a0,a0,-1964 # ffffffffc0201d28 <commands+0xf8>
ffffffffc02004dc:	bd7ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc02004e0:	7c0c                	ld	a1,56(s0)
ffffffffc02004e2:	00002517          	auipc	a0,0x2
ffffffffc02004e6:	85e50513          	addi	a0,a0,-1954 # ffffffffc0201d40 <commands+0x110>
ffffffffc02004ea:	bc9ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc02004ee:	602c                	ld	a1,64(s0)
ffffffffc02004f0:	00002517          	auipc	a0,0x2
ffffffffc02004f4:	86850513          	addi	a0,a0,-1944 # ffffffffc0201d58 <commands+0x128>
ffffffffc02004f8:	bbbff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc02004fc:	642c                	ld	a1,72(s0)
ffffffffc02004fe:	00002517          	auipc	a0,0x2
ffffffffc0200502:	87250513          	addi	a0,a0,-1934 # ffffffffc0201d70 <commands+0x140>
ffffffffc0200506:	badff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc020050a:	682c                	ld	a1,80(s0)
ffffffffc020050c:	00002517          	auipc	a0,0x2
ffffffffc0200510:	87c50513          	addi	a0,a0,-1924 # ffffffffc0201d88 <commands+0x158>
ffffffffc0200514:	b9fff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc0200518:	6c2c                	ld	a1,88(s0)
ffffffffc020051a:	00002517          	auipc	a0,0x2
ffffffffc020051e:	88650513          	addi	a0,a0,-1914 # ffffffffc0201da0 <commands+0x170>
ffffffffc0200522:	b91ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc0200526:	702c                	ld	a1,96(s0)
ffffffffc0200528:	00002517          	auipc	a0,0x2
ffffffffc020052c:	89050513          	addi	a0,a0,-1904 # ffffffffc0201db8 <commands+0x188>
ffffffffc0200530:	b83ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc0200534:	742c                	ld	a1,104(s0)
ffffffffc0200536:	00002517          	auipc	a0,0x2
ffffffffc020053a:	89a50513          	addi	a0,a0,-1894 # ffffffffc0201dd0 <commands+0x1a0>
ffffffffc020053e:	b75ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc0200542:	782c                	ld	a1,112(s0)
ffffffffc0200544:	00002517          	auipc	a0,0x2
ffffffffc0200548:	8a450513          	addi	a0,a0,-1884 # ffffffffc0201de8 <commands+0x1b8>
ffffffffc020054c:	b67ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc0200550:	7c2c                	ld	a1,120(s0)
ffffffffc0200552:	00002517          	auipc	a0,0x2
ffffffffc0200556:	8ae50513          	addi	a0,a0,-1874 # ffffffffc0201e00 <commands+0x1d0>
ffffffffc020055a:	b59ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc020055e:	604c                	ld	a1,128(s0)
ffffffffc0200560:	00002517          	auipc	a0,0x2
ffffffffc0200564:	8b850513          	addi	a0,a0,-1864 # ffffffffc0201e18 <commands+0x1e8>
ffffffffc0200568:	b4bff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc020056c:	644c                	ld	a1,136(s0)
ffffffffc020056e:	00002517          	auipc	a0,0x2
ffffffffc0200572:	8c250513          	addi	a0,a0,-1854 # ffffffffc0201e30 <commands+0x200>
ffffffffc0200576:	b3dff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc020057a:	684c                	ld	a1,144(s0)
ffffffffc020057c:	00002517          	auipc	a0,0x2
ffffffffc0200580:	8cc50513          	addi	a0,a0,-1844 # ffffffffc0201e48 <commands+0x218>
ffffffffc0200584:	b2fff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc0200588:	6c4c                	ld	a1,152(s0)
ffffffffc020058a:	00002517          	auipc	a0,0x2
ffffffffc020058e:	8d650513          	addi	a0,a0,-1834 # ffffffffc0201e60 <commands+0x230>
ffffffffc0200592:	b21ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc0200596:	704c                	ld	a1,160(s0)
ffffffffc0200598:	00002517          	auipc	a0,0x2
ffffffffc020059c:	8e050513          	addi	a0,a0,-1824 # ffffffffc0201e78 <commands+0x248>
ffffffffc02005a0:	b13ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc02005a4:	744c                	ld	a1,168(s0)
ffffffffc02005a6:	00002517          	auipc	a0,0x2
ffffffffc02005aa:	8ea50513          	addi	a0,a0,-1814 # ffffffffc0201e90 <commands+0x260>
ffffffffc02005ae:	b05ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc02005b2:	784c                	ld	a1,176(s0)
ffffffffc02005b4:	00002517          	auipc	a0,0x2
ffffffffc02005b8:	8f450513          	addi	a0,a0,-1804 # ffffffffc0201ea8 <commands+0x278>
ffffffffc02005bc:	af7ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc02005c0:	7c4c                	ld	a1,184(s0)
ffffffffc02005c2:	00002517          	auipc	a0,0x2
ffffffffc02005c6:	8fe50513          	addi	a0,a0,-1794 # ffffffffc0201ec0 <commands+0x290>
ffffffffc02005ca:	ae9ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc02005ce:	606c                	ld	a1,192(s0)
ffffffffc02005d0:	00002517          	auipc	a0,0x2
ffffffffc02005d4:	90850513          	addi	a0,a0,-1784 # ffffffffc0201ed8 <commands+0x2a8>
ffffffffc02005d8:	adbff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc02005dc:	646c                	ld	a1,200(s0)
ffffffffc02005de:	00002517          	auipc	a0,0x2
ffffffffc02005e2:	91250513          	addi	a0,a0,-1774 # ffffffffc0201ef0 <commands+0x2c0>
ffffffffc02005e6:	acdff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc02005ea:	686c                	ld	a1,208(s0)
ffffffffc02005ec:	00002517          	auipc	a0,0x2
ffffffffc02005f0:	91c50513          	addi	a0,a0,-1764 # ffffffffc0201f08 <commands+0x2d8>
ffffffffc02005f4:	abfff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc02005f8:	6c6c                	ld	a1,216(s0)
ffffffffc02005fa:	00002517          	auipc	a0,0x2
ffffffffc02005fe:	92650513          	addi	a0,a0,-1754 # ffffffffc0201f20 <commands+0x2f0>
ffffffffc0200602:	ab1ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc0200606:	706c                	ld	a1,224(s0)
ffffffffc0200608:	00002517          	auipc	a0,0x2
ffffffffc020060c:	93050513          	addi	a0,a0,-1744 # ffffffffc0201f38 <commands+0x308>
ffffffffc0200610:	aa3ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc0200614:	746c                	ld	a1,232(s0)
ffffffffc0200616:	00002517          	auipc	a0,0x2
ffffffffc020061a:	93a50513          	addi	a0,a0,-1734 # ffffffffc0201f50 <commands+0x320>
ffffffffc020061e:	a95ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc0200622:	786c                	ld	a1,240(s0)
ffffffffc0200624:	00002517          	auipc	a0,0x2
ffffffffc0200628:	94450513          	addi	a0,a0,-1724 # ffffffffc0201f68 <commands+0x338>
ffffffffc020062c:	a87ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc0200630:	7c6c                	ld	a1,248(s0)
ffffffffc0200632:	6402                	ld	s0,0(sp)
ffffffffc0200634:	60a2                	ld	ra,8(sp)
ffffffffc0200636:	00002517          	auipc	a0,0x2
ffffffffc020063a:	94a50513          	addi	a0,a0,-1718 # ffffffffc0201f80 <commands+0x350>
ffffffffc020063e:	0141                	addi	sp,sp,16
ffffffffc0200640:	bc8d                	j	ffffffffc02000b2 <cprintf>

ffffffffc0200642 <print_trapframe>:
ffffffffc0200642:	1141                	addi	sp,sp,-16
ffffffffc0200644:	e022                	sd	s0,0(sp)
ffffffffc0200646:	85aa                	mv	a1,a0
ffffffffc0200648:	842a                	mv	s0,a0
ffffffffc020064a:	00002517          	auipc	a0,0x2
ffffffffc020064e:	94e50513          	addi	a0,a0,-1714 # ffffffffc0201f98 <commands+0x368>
ffffffffc0200652:	e406                	sd	ra,8(sp)
ffffffffc0200654:	a5fff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc0200658:	8522                	mv	a0,s0
ffffffffc020065a:	e1dff0ef          	jal	ra,ffffffffc0200476 <print_regs>
ffffffffc020065e:	10043583          	ld	a1,256(s0)
ffffffffc0200662:	00002517          	auipc	a0,0x2
ffffffffc0200666:	94e50513          	addi	a0,a0,-1714 # ffffffffc0201fb0 <commands+0x380>
ffffffffc020066a:	a49ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc020066e:	10843583          	ld	a1,264(s0)
ffffffffc0200672:	00002517          	auipc	a0,0x2
ffffffffc0200676:	95650513          	addi	a0,a0,-1706 # ffffffffc0201fc8 <commands+0x398>
ffffffffc020067a:	a39ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc020067e:	11043583          	ld	a1,272(s0)
ffffffffc0200682:	00002517          	auipc	a0,0x2
ffffffffc0200686:	95e50513          	addi	a0,a0,-1698 # ffffffffc0201fe0 <commands+0x3b0>
ffffffffc020068a:	a29ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc020068e:	11843583          	ld	a1,280(s0)
ffffffffc0200692:	6402                	ld	s0,0(sp)
ffffffffc0200694:	60a2                	ld	ra,8(sp)
ffffffffc0200696:	00002517          	auipc	a0,0x2
ffffffffc020069a:	96250513          	addi	a0,a0,-1694 # ffffffffc0201ff8 <commands+0x3c8>
ffffffffc020069e:	0141                	addi	sp,sp,16
ffffffffc02006a0:	bc09                	j	ffffffffc02000b2 <cprintf>

ffffffffc02006a2 <interrupt_handler>:
ffffffffc02006a2:	11853783          	ld	a5,280(a0)
ffffffffc02006a6:	472d                	li	a4,11
ffffffffc02006a8:	0786                	slli	a5,a5,0x1
ffffffffc02006aa:	8385                	srli	a5,a5,0x1
ffffffffc02006ac:	06f76c63          	bltu	a4,a5,ffffffffc0200724 <interrupt_handler+0x82>
ffffffffc02006b0:	00002717          	auipc	a4,0x2
ffffffffc02006b4:	a2870713          	addi	a4,a4,-1496 # ffffffffc02020d8 <commands+0x4a8>
ffffffffc02006b8:	078a                	slli	a5,a5,0x2
ffffffffc02006ba:	97ba                	add	a5,a5,a4
ffffffffc02006bc:	439c                	lw	a5,0(a5)
ffffffffc02006be:	97ba                	add	a5,a5,a4
ffffffffc02006c0:	8782                	jr	a5
ffffffffc02006c2:	00002517          	auipc	a0,0x2
ffffffffc02006c6:	9ae50513          	addi	a0,a0,-1618 # ffffffffc0202070 <commands+0x440>
ffffffffc02006ca:	b2e5                	j	ffffffffc02000b2 <cprintf>
ffffffffc02006cc:	00002517          	auipc	a0,0x2
ffffffffc02006d0:	98450513          	addi	a0,a0,-1660 # ffffffffc0202050 <commands+0x420>
ffffffffc02006d4:	baf9                	j	ffffffffc02000b2 <cprintf>
ffffffffc02006d6:	00002517          	auipc	a0,0x2
ffffffffc02006da:	93a50513          	addi	a0,a0,-1734 # ffffffffc0202010 <commands+0x3e0>
ffffffffc02006de:	bad1                	j	ffffffffc02000b2 <cprintf>
ffffffffc02006e0:	00002517          	auipc	a0,0x2
ffffffffc02006e4:	9b050513          	addi	a0,a0,-1616 # ffffffffc0202090 <commands+0x460>
ffffffffc02006e8:	b2e9                	j	ffffffffc02000b2 <cprintf>
ffffffffc02006ea:	1141                	addi	sp,sp,-16
ffffffffc02006ec:	e406                	sd	ra,8(sp)
ffffffffc02006ee:	d4dff0ef          	jal	ra,ffffffffc020043a <clock_set_next_event>
ffffffffc02006f2:	00006697          	auipc	a3,0x6
ffffffffc02006f6:	d3e68693          	addi	a3,a3,-706 # ffffffffc0206430 <ticks>
ffffffffc02006fa:	629c                	ld	a5,0(a3)
ffffffffc02006fc:	06400713          	li	a4,100
ffffffffc0200700:	0785                	addi	a5,a5,1
ffffffffc0200702:	02e7f733          	remu	a4,a5,a4
ffffffffc0200706:	e29c                	sd	a5,0(a3)
ffffffffc0200708:	cf19                	beqz	a4,ffffffffc0200726 <interrupt_handler+0x84>
ffffffffc020070a:	60a2                	ld	ra,8(sp)
ffffffffc020070c:	0141                	addi	sp,sp,16
ffffffffc020070e:	8082                	ret
ffffffffc0200710:	00002517          	auipc	a0,0x2
ffffffffc0200714:	9a850513          	addi	a0,a0,-1624 # ffffffffc02020b8 <commands+0x488>
ffffffffc0200718:	ba69                	j	ffffffffc02000b2 <cprintf>
ffffffffc020071a:	00002517          	auipc	a0,0x2
ffffffffc020071e:	91650513          	addi	a0,a0,-1770 # ffffffffc0202030 <commands+0x400>
ffffffffc0200722:	ba41                	j	ffffffffc02000b2 <cprintf>
ffffffffc0200724:	bf39                	j	ffffffffc0200642 <print_trapframe>
ffffffffc0200726:	60a2                	ld	ra,8(sp)
ffffffffc0200728:	06400593          	li	a1,100
ffffffffc020072c:	00002517          	auipc	a0,0x2
ffffffffc0200730:	97c50513          	addi	a0,a0,-1668 # ffffffffc02020a8 <commands+0x478>
ffffffffc0200734:	0141                	addi	sp,sp,16
ffffffffc0200736:	bab5                	j	ffffffffc02000b2 <cprintf>

ffffffffc0200738 <trap>:
ffffffffc0200738:	11853783          	ld	a5,280(a0)
ffffffffc020073c:	0007c763          	bltz	a5,ffffffffc020074a <trap+0x12>
ffffffffc0200740:	472d                	li	a4,11
ffffffffc0200742:	00f76363          	bltu	a4,a5,ffffffffc0200748 <trap+0x10>
ffffffffc0200746:	8082                	ret
ffffffffc0200748:	bded                	j	ffffffffc0200642 <print_trapframe>
ffffffffc020074a:	bfa1                	j	ffffffffc02006a2 <interrupt_handler>

ffffffffc020074c <__alltraps>:
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
ffffffffc02007ae:	850a                	mv	a0,sp
ffffffffc02007b0:	f89ff0ef          	jal	ra,ffffffffc0200738 <trap>

ffffffffc02007b4 <__trapret>:
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
ffffffffc02007fe:	10200073          	sret

ffffffffc0200802 <alloc_pages>:
ffffffffc0200802:	100027f3          	csrr	a5,sstatus
ffffffffc0200806:	8b89                	andi	a5,a5,2
ffffffffc0200808:	e799                	bnez	a5,ffffffffc0200816 <alloc_pages+0x14>
ffffffffc020080a:	00006797          	auipc	a5,0x6
ffffffffc020080e:	c3e7b783          	ld	a5,-962(a5) # ffffffffc0206448 <pmm_manager>
ffffffffc0200812:	6f9c                	ld	a5,24(a5)
ffffffffc0200814:	8782                	jr	a5
ffffffffc0200816:	1141                	addi	sp,sp,-16
ffffffffc0200818:	e406                	sd	ra,8(sp)
ffffffffc020081a:	e022                	sd	s0,0(sp)
ffffffffc020081c:	842a                	mv	s0,a0
ffffffffc020081e:	c41ff0ef          	jal	ra,ffffffffc020045e <intr_disable>
ffffffffc0200822:	00006797          	auipc	a5,0x6
ffffffffc0200826:	c267b783          	ld	a5,-986(a5) # ffffffffc0206448 <pmm_manager>
ffffffffc020082a:	6f9c                	ld	a5,24(a5)
ffffffffc020082c:	8522                	mv	a0,s0
ffffffffc020082e:	9782                	jalr	a5
ffffffffc0200830:	842a                	mv	s0,a0
ffffffffc0200832:	c27ff0ef          	jal	ra,ffffffffc0200458 <intr_enable>
ffffffffc0200836:	60a2                	ld	ra,8(sp)
ffffffffc0200838:	8522                	mv	a0,s0
ffffffffc020083a:	6402                	ld	s0,0(sp)
ffffffffc020083c:	0141                	addi	sp,sp,16
ffffffffc020083e:	8082                	ret

ffffffffc0200840 <free_pages>:
ffffffffc0200840:	100027f3          	csrr	a5,sstatus
ffffffffc0200844:	8b89                	andi	a5,a5,2
ffffffffc0200846:	e799                	bnez	a5,ffffffffc0200854 <free_pages+0x14>
ffffffffc0200848:	00006797          	auipc	a5,0x6
ffffffffc020084c:	c007b783          	ld	a5,-1024(a5) # ffffffffc0206448 <pmm_manager>
ffffffffc0200850:	739c                	ld	a5,32(a5)
ffffffffc0200852:	8782                	jr	a5
ffffffffc0200854:	1101                	addi	sp,sp,-32
ffffffffc0200856:	ec06                	sd	ra,24(sp)
ffffffffc0200858:	e822                	sd	s0,16(sp)
ffffffffc020085a:	e426                	sd	s1,8(sp)
ffffffffc020085c:	842a                	mv	s0,a0
ffffffffc020085e:	84ae                	mv	s1,a1
ffffffffc0200860:	bffff0ef          	jal	ra,ffffffffc020045e <intr_disable>
ffffffffc0200864:	00006797          	auipc	a5,0x6
ffffffffc0200868:	be47b783          	ld	a5,-1052(a5) # ffffffffc0206448 <pmm_manager>
ffffffffc020086c:	739c                	ld	a5,32(a5)
ffffffffc020086e:	85a6                	mv	a1,s1
ffffffffc0200870:	8522                	mv	a0,s0
ffffffffc0200872:	9782                	jalr	a5
ffffffffc0200874:	6442                	ld	s0,16(sp)
ffffffffc0200876:	60e2                	ld	ra,24(sp)
ffffffffc0200878:	64a2                	ld	s1,8(sp)
ffffffffc020087a:	6105                	addi	sp,sp,32
ffffffffc020087c:	bef1                	j	ffffffffc0200458 <intr_enable>

ffffffffc020087e <nr_free_pages>:
ffffffffc020087e:	100027f3          	csrr	a5,sstatus
ffffffffc0200882:	8b89                	andi	a5,a5,2
ffffffffc0200884:	e799                	bnez	a5,ffffffffc0200892 <nr_free_pages+0x14>
ffffffffc0200886:	00006797          	auipc	a5,0x6
ffffffffc020088a:	bc27b783          	ld	a5,-1086(a5) # ffffffffc0206448 <pmm_manager>
ffffffffc020088e:	779c                	ld	a5,40(a5)
ffffffffc0200890:	8782                	jr	a5
ffffffffc0200892:	1141                	addi	sp,sp,-16
ffffffffc0200894:	e406                	sd	ra,8(sp)
ffffffffc0200896:	e022                	sd	s0,0(sp)
ffffffffc0200898:	bc7ff0ef          	jal	ra,ffffffffc020045e <intr_disable>
ffffffffc020089c:	00006797          	auipc	a5,0x6
ffffffffc02008a0:	bac7b783          	ld	a5,-1108(a5) # ffffffffc0206448 <pmm_manager>
ffffffffc02008a4:	779c                	ld	a5,40(a5)
ffffffffc02008a6:	9782                	jalr	a5
ffffffffc02008a8:	842a                	mv	s0,a0
ffffffffc02008aa:	bafff0ef          	jal	ra,ffffffffc0200458 <intr_enable>
ffffffffc02008ae:	60a2                	ld	ra,8(sp)
ffffffffc02008b0:	8522                	mv	a0,s0
ffffffffc02008b2:	6402                	ld	s0,0(sp)
ffffffffc02008b4:	0141                	addi	sp,sp,16
ffffffffc02008b6:	8082                	ret

ffffffffc02008b8 <pmm_init>:
ffffffffc02008b8:	00002797          	auipc	a5,0x2
ffffffffc02008bc:	cc078793          	addi	a5,a5,-832 # ffffffffc0202578 <best_fit_pmm_manager>
ffffffffc02008c0:	638c                	ld	a1,0(a5)
ffffffffc02008c2:	1101                	addi	sp,sp,-32
ffffffffc02008c4:	e426                	sd	s1,8(sp)
ffffffffc02008c6:	00002517          	auipc	a0,0x2
ffffffffc02008ca:	84250513          	addi	a0,a0,-1982 # ffffffffc0202108 <commands+0x4d8>
ffffffffc02008ce:	00006497          	auipc	s1,0x6
ffffffffc02008d2:	b7a48493          	addi	s1,s1,-1158 # ffffffffc0206448 <pmm_manager>
ffffffffc02008d6:	ec06                	sd	ra,24(sp)
ffffffffc02008d8:	e822                	sd	s0,16(sp)
ffffffffc02008da:	e09c                	sd	a5,0(s1)
ffffffffc02008dc:	fd6ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc02008e0:	609c                	ld	a5,0(s1)
ffffffffc02008e2:	00006417          	auipc	s0,0x6
ffffffffc02008e6:	b7e40413          	addi	s0,s0,-1154 # ffffffffc0206460 <va_pa_offset>
ffffffffc02008ea:	679c                	ld	a5,8(a5)
ffffffffc02008ec:	9782                	jalr	a5
ffffffffc02008ee:	57f5                	li	a5,-3
ffffffffc02008f0:	07fa                	slli	a5,a5,0x1e
ffffffffc02008f2:	00002517          	auipc	a0,0x2
ffffffffc02008f6:	82e50513          	addi	a0,a0,-2002 # ffffffffc0202120 <commands+0x4f0>
ffffffffc02008fa:	e01c                	sd	a5,0(s0)
ffffffffc02008fc:	fb6ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc0200900:	46c5                	li	a3,17
ffffffffc0200902:	06ee                	slli	a3,a3,0x1b
ffffffffc0200904:	40100613          	li	a2,1025
ffffffffc0200908:	16fd                	addi	a3,a3,-1
ffffffffc020090a:	07e005b7          	lui	a1,0x7e00
ffffffffc020090e:	0656                	slli	a2,a2,0x15
ffffffffc0200910:	00002517          	auipc	a0,0x2
ffffffffc0200914:	82850513          	addi	a0,a0,-2008 # ffffffffc0202138 <commands+0x508>
ffffffffc0200918:	f9aff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc020091c:	777d                	lui	a4,0xfffff
ffffffffc020091e:	00007797          	auipc	a5,0x7
ffffffffc0200922:	b5178793          	addi	a5,a5,-1199 # ffffffffc020746f <end+0xfff>
ffffffffc0200926:	8ff9                	and	a5,a5,a4
ffffffffc0200928:	00006517          	auipc	a0,0x6
ffffffffc020092c:	b1050513          	addi	a0,a0,-1264 # ffffffffc0206438 <npage>
ffffffffc0200930:	00088737          	lui	a4,0x88
ffffffffc0200934:	00006597          	auipc	a1,0x6
ffffffffc0200938:	b0c58593          	addi	a1,a1,-1268 # ffffffffc0206440 <pages>
ffffffffc020093c:	e118                	sd	a4,0(a0)
ffffffffc020093e:	e19c                	sd	a5,0(a1)
ffffffffc0200940:	4681                	li	a3,0
ffffffffc0200942:	4701                	li	a4,0
ffffffffc0200944:	4885                	li	a7,1
ffffffffc0200946:	fff80837          	lui	a6,0xfff80
ffffffffc020094a:	a011                	j	ffffffffc020094e <pmm_init+0x96>
ffffffffc020094c:	619c                	ld	a5,0(a1)
ffffffffc020094e:	97b6                	add	a5,a5,a3
ffffffffc0200950:	07a1                	addi	a5,a5,8
ffffffffc0200952:	4117b02f          	amoor.d	zero,a7,(a5)
ffffffffc0200956:	611c                	ld	a5,0(a0)
ffffffffc0200958:	0705                	addi	a4,a4,1
ffffffffc020095a:	02868693          	addi	a3,a3,40
ffffffffc020095e:	01078633          	add	a2,a5,a6
ffffffffc0200962:	fec765e3          	bltu	a4,a2,ffffffffc020094c <pmm_init+0x94>
ffffffffc0200966:	6190                	ld	a2,0(a1)
ffffffffc0200968:	00279713          	slli	a4,a5,0x2
ffffffffc020096c:	973e                	add	a4,a4,a5
ffffffffc020096e:	fec006b7          	lui	a3,0xfec00
ffffffffc0200972:	070e                	slli	a4,a4,0x3
ffffffffc0200974:	96b2                	add	a3,a3,a2
ffffffffc0200976:	96ba                	add	a3,a3,a4
ffffffffc0200978:	c0200737          	lui	a4,0xc0200
ffffffffc020097c:	08e6ef63          	bltu	a3,a4,ffffffffc0200a1a <pmm_init+0x162>
ffffffffc0200980:	6018                	ld	a4,0(s0)
ffffffffc0200982:	45c5                	li	a1,17
ffffffffc0200984:	05ee                	slli	a1,a1,0x1b
ffffffffc0200986:	8e99                	sub	a3,a3,a4
ffffffffc0200988:	04b6e863          	bltu	a3,a1,ffffffffc02009d8 <pmm_init+0x120>
ffffffffc020098c:	609c                	ld	a5,0(s1)
ffffffffc020098e:	7b9c                	ld	a5,48(a5)
ffffffffc0200990:	9782                	jalr	a5
ffffffffc0200992:	00002517          	auipc	a0,0x2
ffffffffc0200996:	83e50513          	addi	a0,a0,-1986 # ffffffffc02021d0 <commands+0x5a0>
ffffffffc020099a:	f18ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc020099e:	00004597          	auipc	a1,0x4
ffffffffc02009a2:	66258593          	addi	a1,a1,1634 # ffffffffc0205000 <boot_page_table_sv39>
ffffffffc02009a6:	00006797          	auipc	a5,0x6
ffffffffc02009aa:	aab7b923          	sd	a1,-1358(a5) # ffffffffc0206458 <satp_virtual>
ffffffffc02009ae:	c02007b7          	lui	a5,0xc0200
ffffffffc02009b2:	08f5e063          	bltu	a1,a5,ffffffffc0200a32 <pmm_init+0x17a>
ffffffffc02009b6:	6010                	ld	a2,0(s0)
ffffffffc02009b8:	6442                	ld	s0,16(sp)
ffffffffc02009ba:	60e2                	ld	ra,24(sp)
ffffffffc02009bc:	64a2                	ld	s1,8(sp)
ffffffffc02009be:	40c58633          	sub	a2,a1,a2
ffffffffc02009c2:	00006797          	auipc	a5,0x6
ffffffffc02009c6:	a8c7b723          	sd	a2,-1394(a5) # ffffffffc0206450 <satp_physical>
ffffffffc02009ca:	00002517          	auipc	a0,0x2
ffffffffc02009ce:	82650513          	addi	a0,a0,-2010 # ffffffffc02021f0 <commands+0x5c0>
ffffffffc02009d2:	6105                	addi	sp,sp,32
ffffffffc02009d4:	edeff06f          	j	ffffffffc02000b2 <cprintf>
ffffffffc02009d8:	6705                	lui	a4,0x1
ffffffffc02009da:	177d                	addi	a4,a4,-1
ffffffffc02009dc:	96ba                	add	a3,a3,a4
ffffffffc02009de:	777d                	lui	a4,0xfffff
ffffffffc02009e0:	8ef9                	and	a3,a3,a4
ffffffffc02009e2:	00c6d513          	srli	a0,a3,0xc
ffffffffc02009e6:	00f57e63          	bgeu	a0,a5,ffffffffc0200a02 <pmm_init+0x14a>
ffffffffc02009ea:	609c                	ld	a5,0(s1)
ffffffffc02009ec:	982a                	add	a6,a6,a0
ffffffffc02009ee:	00281513          	slli	a0,a6,0x2
ffffffffc02009f2:	9542                	add	a0,a0,a6
ffffffffc02009f4:	6b9c                	ld	a5,16(a5)
ffffffffc02009f6:	8d95                	sub	a1,a1,a3
ffffffffc02009f8:	050e                	slli	a0,a0,0x3
ffffffffc02009fa:	81b1                	srli	a1,a1,0xc
ffffffffc02009fc:	9532                	add	a0,a0,a2
ffffffffc02009fe:	9782                	jalr	a5
ffffffffc0200a00:	b771                	j	ffffffffc020098c <pmm_init+0xd4>
ffffffffc0200a02:	00001617          	auipc	a2,0x1
ffffffffc0200a06:	79e60613          	addi	a2,a2,1950 # ffffffffc02021a0 <commands+0x570>
ffffffffc0200a0a:	06c00593          	li	a1,108
ffffffffc0200a0e:	00001517          	auipc	a0,0x1
ffffffffc0200a12:	7b250513          	addi	a0,a0,1970 # ffffffffc02021c0 <commands+0x590>
ffffffffc0200a16:	f24ff0ef          	jal	ra,ffffffffc020013a <__panic>
ffffffffc0200a1a:	00001617          	auipc	a2,0x1
ffffffffc0200a1e:	74e60613          	addi	a2,a2,1870 # ffffffffc0202168 <commands+0x538>
ffffffffc0200a22:	08600593          	li	a1,134
ffffffffc0200a26:	00001517          	auipc	a0,0x1
ffffffffc0200a2a:	76a50513          	addi	a0,a0,1898 # ffffffffc0202190 <commands+0x560>
ffffffffc0200a2e:	f0cff0ef          	jal	ra,ffffffffc020013a <__panic>
ffffffffc0200a32:	86ae                	mv	a3,a1
ffffffffc0200a34:	00001617          	auipc	a2,0x1
ffffffffc0200a38:	73460613          	addi	a2,a2,1844 # ffffffffc0202168 <commands+0x538>
ffffffffc0200a3c:	0a300593          	li	a1,163
ffffffffc0200a40:	00001517          	auipc	a0,0x1
ffffffffc0200a44:	75050513          	addi	a0,a0,1872 # ffffffffc0202190 <commands+0x560>
ffffffffc0200a48:	ef2ff0ef          	jal	ra,ffffffffc020013a <__panic>

ffffffffc0200a4c <best_fit_init>:
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
ffffffffc0200a4c:	00005797          	auipc	a5,0x5
ffffffffc0200a50:	5c478793          	addi	a5,a5,1476 # ffffffffc0206010 <bffree_area>
ffffffffc0200a54:	e79c                	sd	a5,8(a5)
ffffffffc0200a56:	e39c                	sd	a5,0(a5)
#define nr_free (bffree_area.nr_free)

static void
best_fit_init(void) {
    list_init(&free_list);
    nr_free = 0;
ffffffffc0200a58:	0007a823          	sw	zero,16(a5)
}
ffffffffc0200a5c:	8082                	ret

ffffffffc0200a5e <best_fit_nr_free_pages>:
}

static size_t
best_fit_nr_free_pages(void) {
    return nr_free;
}
ffffffffc0200a5e:	00005517          	auipc	a0,0x5
ffffffffc0200a62:	5c256503          	lwu	a0,1474(a0) # ffffffffc0206020 <bffree_area+0x10>
ffffffffc0200a66:	8082                	ret

ffffffffc0200a68 <best_fit_check>:
}

// LAB2: below code is used to check the best fit allocation algorithm 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
best_fit_check(void) {
ffffffffc0200a68:	715d                	addi	sp,sp,-80
ffffffffc0200a6a:	e0a2                	sd	s0,64(sp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
ffffffffc0200a6c:	00005417          	auipc	s0,0x5
ffffffffc0200a70:	5a440413          	addi	s0,s0,1444 # ffffffffc0206010 <bffree_area>
ffffffffc0200a74:	641c                	ld	a5,8(s0)
ffffffffc0200a76:	e486                	sd	ra,72(sp)
ffffffffc0200a78:	fc26                	sd	s1,56(sp)
ffffffffc0200a7a:	f84a                	sd	s2,48(sp)
ffffffffc0200a7c:	f44e                	sd	s3,40(sp)
ffffffffc0200a7e:	f052                	sd	s4,32(sp)
ffffffffc0200a80:	ec56                	sd	s5,24(sp)
ffffffffc0200a82:	e85a                	sd	s6,16(sp)
ffffffffc0200a84:	e45e                	sd	s7,8(sp)
ffffffffc0200a86:	e062                	sd	s8,0(sp)
    int score = 0 ,sumscore = 6;
    int count = 0, total = 0;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
ffffffffc0200a88:	26878b63          	beq	a5,s0,ffffffffc0200cfe <best_fit_check+0x296>
    int count = 0, total = 0;
ffffffffc0200a8c:	4481                	li	s1,0
ffffffffc0200a8e:	4901                	li	s2,0
 * test_bit - Determine whether a bit is set
 * @nr:     the bit to test
 * @addr:   the address to count from
 * */
static inline bool test_bit(int nr, volatile void *addr) {
    return (((*(volatile unsigned long *)addr) >> nr) & 1);
ffffffffc0200a90:	ff07b703          	ld	a4,-16(a5)
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
ffffffffc0200a94:	8b09                	andi	a4,a4,2
ffffffffc0200a96:	26070863          	beqz	a4,ffffffffc0200d06 <best_fit_check+0x29e>
        count ++, total += p->property;
ffffffffc0200a9a:	ff87a703          	lw	a4,-8(a5)
ffffffffc0200a9e:	679c                	ld	a5,8(a5)
ffffffffc0200aa0:	2905                	addiw	s2,s2,1
ffffffffc0200aa2:	9cb9                	addw	s1,s1,a4
    while ((le = list_next(le)) != &free_list) {
ffffffffc0200aa4:	fe8796e3          	bne	a5,s0,ffffffffc0200a90 <best_fit_check+0x28>
    }
    assert(total == nr_free_pages());
ffffffffc0200aa8:	89a6                	mv	s3,s1
ffffffffc0200aaa:	dd5ff0ef          	jal	ra,ffffffffc020087e <nr_free_pages>
ffffffffc0200aae:	33351c63          	bne	a0,s3,ffffffffc0200de6 <best_fit_check+0x37e>
    assert((p0 = alloc_page()) != NULL);
ffffffffc0200ab2:	4505                	li	a0,1
ffffffffc0200ab4:	d4fff0ef          	jal	ra,ffffffffc0200802 <alloc_pages>
ffffffffc0200ab8:	8a2a                	mv	s4,a0
ffffffffc0200aba:	36050663          	beqz	a0,ffffffffc0200e26 <best_fit_check+0x3be>
    assert((p1 = alloc_page()) != NULL);
ffffffffc0200abe:	4505                	li	a0,1
ffffffffc0200ac0:	d43ff0ef          	jal	ra,ffffffffc0200802 <alloc_pages>
ffffffffc0200ac4:	89aa                	mv	s3,a0
ffffffffc0200ac6:	34050063          	beqz	a0,ffffffffc0200e06 <best_fit_check+0x39e>
    assert((p2 = alloc_page()) != NULL);
ffffffffc0200aca:	4505                	li	a0,1
ffffffffc0200acc:	d37ff0ef          	jal	ra,ffffffffc0200802 <alloc_pages>
ffffffffc0200ad0:	8aaa                	mv	s5,a0
ffffffffc0200ad2:	2c050a63          	beqz	a0,ffffffffc0200da6 <best_fit_check+0x33e>
    assert(p0 != p1 && p0 != p2 && p1 != p2);
ffffffffc0200ad6:	253a0863          	beq	s4,s3,ffffffffc0200d26 <best_fit_check+0x2be>
ffffffffc0200ada:	24aa0663          	beq	s4,a0,ffffffffc0200d26 <best_fit_check+0x2be>
ffffffffc0200ade:	24a98463          	beq	s3,a0,ffffffffc0200d26 <best_fit_check+0x2be>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
ffffffffc0200ae2:	000a2783          	lw	a5,0(s4)
ffffffffc0200ae6:	26079063          	bnez	a5,ffffffffc0200d46 <best_fit_check+0x2de>
ffffffffc0200aea:	0009a783          	lw	a5,0(s3)
ffffffffc0200aee:	24079c63          	bnez	a5,ffffffffc0200d46 <best_fit_check+0x2de>
ffffffffc0200af2:	411c                	lw	a5,0(a0)
ffffffffc0200af4:	24079963          	bnez	a5,ffffffffc0200d46 <best_fit_check+0x2de>
extern size_t npage;
extern const size_t nbase;
extern uintptr_t freemem;
extern uint64_t va_pa_offset;

static inline ppn_t page2ppn(struct Page *page) { return page - pages + nbase; }
ffffffffc0200af8:	00006797          	auipc	a5,0x6
ffffffffc0200afc:	9487b783          	ld	a5,-1720(a5) # ffffffffc0206440 <pages>
ffffffffc0200b00:	40fa0733          	sub	a4,s4,a5
ffffffffc0200b04:	870d                	srai	a4,a4,0x3
ffffffffc0200b06:	00002597          	auipc	a1,0x2
ffffffffc0200b0a:	cfa5b583          	ld	a1,-774(a1) # ffffffffc0202800 <nbase+0x8>
ffffffffc0200b0e:	02b70733          	mul	a4,a4,a1
ffffffffc0200b12:	00002617          	auipc	a2,0x2
ffffffffc0200b16:	ce663603          	ld	a2,-794(a2) # ffffffffc02027f8 <nbase>
    assert(page2pa(p0) < npage * PGSIZE);
ffffffffc0200b1a:	00006697          	auipc	a3,0x6
ffffffffc0200b1e:	91e6b683          	ld	a3,-1762(a3) # ffffffffc0206438 <npage>
ffffffffc0200b22:	06b2                	slli	a3,a3,0xc
ffffffffc0200b24:	9732                	add	a4,a4,a2
//将page类型的指针转化为物理页号
static inline uintptr_t page2pa(struct Page *page) {
    return page2ppn(page) << PGSHIFT;
ffffffffc0200b26:	0732                	slli	a4,a4,0xc
ffffffffc0200b28:	22d77f63          	bgeu	a4,a3,ffffffffc0200d66 <best_fit_check+0x2fe>
static inline ppn_t page2ppn(struct Page *page) { return page - pages + nbase; }
ffffffffc0200b2c:	40f98733          	sub	a4,s3,a5
ffffffffc0200b30:	870d                	srai	a4,a4,0x3
ffffffffc0200b32:	02b70733          	mul	a4,a4,a1
ffffffffc0200b36:	9732                	add	a4,a4,a2
    return page2ppn(page) << PGSHIFT;
ffffffffc0200b38:	0732                	slli	a4,a4,0xc
    assert(page2pa(p1) < npage * PGSIZE);
ffffffffc0200b3a:	3ed77663          	bgeu	a4,a3,ffffffffc0200f26 <best_fit_check+0x4be>
static inline ppn_t page2ppn(struct Page *page) { return page - pages + nbase; }
ffffffffc0200b3e:	40f507b3          	sub	a5,a0,a5
ffffffffc0200b42:	878d                	srai	a5,a5,0x3
ffffffffc0200b44:	02b787b3          	mul	a5,a5,a1
ffffffffc0200b48:	97b2                	add	a5,a5,a2
    return page2ppn(page) << PGSHIFT;
ffffffffc0200b4a:	07b2                	slli	a5,a5,0xc
    assert(page2pa(p2) < npage * PGSIZE);
ffffffffc0200b4c:	3ad7fd63          	bgeu	a5,a3,ffffffffc0200f06 <best_fit_check+0x49e>
    assert(alloc_page() == NULL);
ffffffffc0200b50:	4505                	li	a0,1
    list_entry_t free_list_store = free_list;
ffffffffc0200b52:	00043c03          	ld	s8,0(s0)
ffffffffc0200b56:	00843b83          	ld	s7,8(s0)
    unsigned int nr_free_store = nr_free;
ffffffffc0200b5a:	01042b03          	lw	s6,16(s0)
    elm->prev = elm->next = elm;
ffffffffc0200b5e:	e400                	sd	s0,8(s0)
ffffffffc0200b60:	e000                	sd	s0,0(s0)
    nr_free = 0;
ffffffffc0200b62:	00005797          	auipc	a5,0x5
ffffffffc0200b66:	4a07af23          	sw	zero,1214(a5) # ffffffffc0206020 <bffree_area+0x10>
    assert(alloc_page() == NULL);
ffffffffc0200b6a:	c99ff0ef          	jal	ra,ffffffffc0200802 <alloc_pages>
ffffffffc0200b6e:	36051c63          	bnez	a0,ffffffffc0200ee6 <best_fit_check+0x47e>
    free_page(p0);
ffffffffc0200b72:	4585                	li	a1,1
ffffffffc0200b74:	8552                	mv	a0,s4
ffffffffc0200b76:	ccbff0ef          	jal	ra,ffffffffc0200840 <free_pages>
    free_page(p1);
ffffffffc0200b7a:	4585                	li	a1,1
ffffffffc0200b7c:	854e                	mv	a0,s3
ffffffffc0200b7e:	cc3ff0ef          	jal	ra,ffffffffc0200840 <free_pages>
    free_page(p2);
ffffffffc0200b82:	4585                	li	a1,1
ffffffffc0200b84:	8556                	mv	a0,s5
ffffffffc0200b86:	cbbff0ef          	jal	ra,ffffffffc0200840 <free_pages>
    assert(nr_free == 3);
ffffffffc0200b8a:	4818                	lw	a4,16(s0)
ffffffffc0200b8c:	478d                	li	a5,3
ffffffffc0200b8e:	32f71c63          	bne	a4,a5,ffffffffc0200ec6 <best_fit_check+0x45e>
    assert((p0 = alloc_page()) != NULL);
ffffffffc0200b92:	4505                	li	a0,1
ffffffffc0200b94:	c6fff0ef          	jal	ra,ffffffffc0200802 <alloc_pages>
ffffffffc0200b98:	89aa                	mv	s3,a0
ffffffffc0200b9a:	30050663          	beqz	a0,ffffffffc0200ea6 <best_fit_check+0x43e>
    assert((p1 = alloc_page()) != NULL);
ffffffffc0200b9e:	4505                	li	a0,1
ffffffffc0200ba0:	c63ff0ef          	jal	ra,ffffffffc0200802 <alloc_pages>
ffffffffc0200ba4:	8aaa                	mv	s5,a0
ffffffffc0200ba6:	2e050063          	beqz	a0,ffffffffc0200e86 <best_fit_check+0x41e>
    assert((p2 = alloc_page()) != NULL);
ffffffffc0200baa:	4505                	li	a0,1
ffffffffc0200bac:	c57ff0ef          	jal	ra,ffffffffc0200802 <alloc_pages>
ffffffffc0200bb0:	8a2a                	mv	s4,a0
ffffffffc0200bb2:	2a050a63          	beqz	a0,ffffffffc0200e66 <best_fit_check+0x3fe>
    assert(alloc_page() == NULL);
ffffffffc0200bb6:	4505                	li	a0,1
ffffffffc0200bb8:	c4bff0ef          	jal	ra,ffffffffc0200802 <alloc_pages>
ffffffffc0200bbc:	28051563          	bnez	a0,ffffffffc0200e46 <best_fit_check+0x3de>
    free_page(p0);
ffffffffc0200bc0:	4585                	li	a1,1
ffffffffc0200bc2:	854e                	mv	a0,s3
ffffffffc0200bc4:	c7dff0ef          	jal	ra,ffffffffc0200840 <free_pages>
    assert(!list_empty(&free_list));
ffffffffc0200bc8:	641c                	ld	a5,8(s0)
ffffffffc0200bca:	1a878e63          	beq	a5,s0,ffffffffc0200d86 <best_fit_check+0x31e>
    assert((p = alloc_page()) == p0);
ffffffffc0200bce:	4505                	li	a0,1
ffffffffc0200bd0:	c33ff0ef          	jal	ra,ffffffffc0200802 <alloc_pages>
ffffffffc0200bd4:	52a99963          	bne	s3,a0,ffffffffc0201106 <best_fit_check+0x69e>
    assert(alloc_page() == NULL);
ffffffffc0200bd8:	4505                	li	a0,1
ffffffffc0200bda:	c29ff0ef          	jal	ra,ffffffffc0200802 <alloc_pages>
ffffffffc0200bde:	50051463          	bnez	a0,ffffffffc02010e6 <best_fit_check+0x67e>
    assert(nr_free == 0);
ffffffffc0200be2:	481c                	lw	a5,16(s0)
ffffffffc0200be4:	4e079163          	bnez	a5,ffffffffc02010c6 <best_fit_check+0x65e>
    free_page(p);
ffffffffc0200be8:	854e                	mv	a0,s3
ffffffffc0200bea:	4585                	li	a1,1
    free_list = free_list_store;
ffffffffc0200bec:	01843023          	sd	s8,0(s0)
ffffffffc0200bf0:	01743423          	sd	s7,8(s0)
    nr_free = nr_free_store;
ffffffffc0200bf4:	01642823          	sw	s6,16(s0)
    free_page(p);
ffffffffc0200bf8:	c49ff0ef          	jal	ra,ffffffffc0200840 <free_pages>
    free_page(p1);
ffffffffc0200bfc:	4585                	li	a1,1
ffffffffc0200bfe:	8556                	mv	a0,s5
ffffffffc0200c00:	c41ff0ef          	jal	ra,ffffffffc0200840 <free_pages>
    free_page(p2);
ffffffffc0200c04:	4585                	li	a1,1
ffffffffc0200c06:	8552                	mv	a0,s4
ffffffffc0200c08:	c39ff0ef          	jal	ra,ffffffffc0200840 <free_pages>

    #ifdef ucore_test
    score += 1;
    cprintf("grading: %d / %d points\n",score, sumscore);
    #endif
    struct Page *p0 = alloc_pages(5), *p1, *p2;
ffffffffc0200c0c:	4515                	li	a0,5
ffffffffc0200c0e:	bf5ff0ef          	jal	ra,ffffffffc0200802 <alloc_pages>
ffffffffc0200c12:	89aa                	mv	s3,a0
    assert(p0 != NULL);
ffffffffc0200c14:	48050963          	beqz	a0,ffffffffc02010a6 <best_fit_check+0x63e>
ffffffffc0200c18:	651c                	ld	a5,8(a0)
ffffffffc0200c1a:	8385                	srli	a5,a5,0x1
    assert(!PageProperty(p0));
ffffffffc0200c1c:	8b85                	andi	a5,a5,1
ffffffffc0200c1e:	46079463          	bnez	a5,ffffffffc0201086 <best_fit_check+0x61e>
    cprintf("grading: %d / %d points\n",score, sumscore);
    #endif
    list_entry_t free_list_store = free_list;
    list_init(&free_list);
    assert(list_empty(&free_list));
    assert(alloc_page() == NULL);
ffffffffc0200c22:	4505                	li	a0,1
    list_entry_t free_list_store = free_list;
ffffffffc0200c24:	00043a83          	ld	s5,0(s0)
ffffffffc0200c28:	00843a03          	ld	s4,8(s0)
ffffffffc0200c2c:	e000                	sd	s0,0(s0)
ffffffffc0200c2e:	e400                	sd	s0,8(s0)
    assert(alloc_page() == NULL);
ffffffffc0200c30:	bd3ff0ef          	jal	ra,ffffffffc0200802 <alloc_pages>
ffffffffc0200c34:	42051963          	bnez	a0,ffffffffc0201066 <best_fit_check+0x5fe>
    #endif
    unsigned int nr_free_store = nr_free;
    nr_free = 0;

    // * - - * -
    free_pages(p0 + 1, 2);
ffffffffc0200c38:	4589                	li	a1,2
ffffffffc0200c3a:	02898513          	addi	a0,s3,40
    unsigned int nr_free_store = nr_free;
ffffffffc0200c3e:	01042b03          	lw	s6,16(s0)
    free_pages(p0 + 4, 1);
ffffffffc0200c42:	0a098c13          	addi	s8,s3,160
    nr_free = 0;
ffffffffc0200c46:	00005797          	auipc	a5,0x5
ffffffffc0200c4a:	3c07ad23          	sw	zero,986(a5) # ffffffffc0206020 <bffree_area+0x10>
    free_pages(p0 + 1, 2);
ffffffffc0200c4e:	bf3ff0ef          	jal	ra,ffffffffc0200840 <free_pages>
    free_pages(p0 + 4, 1);
ffffffffc0200c52:	8562                	mv	a0,s8
ffffffffc0200c54:	4585                	li	a1,1
ffffffffc0200c56:	bebff0ef          	jal	ra,ffffffffc0200840 <free_pages>
    assert(alloc_pages(4) == NULL);
ffffffffc0200c5a:	4511                	li	a0,4
ffffffffc0200c5c:	ba7ff0ef          	jal	ra,ffffffffc0200802 <alloc_pages>
ffffffffc0200c60:	3e051363          	bnez	a0,ffffffffc0201046 <best_fit_check+0x5de>
ffffffffc0200c64:	0309b783          	ld	a5,48(s3)
ffffffffc0200c68:	8385                	srli	a5,a5,0x1
    assert(PageProperty(p0 + 1) && p0[1].property == 2);
ffffffffc0200c6a:	8b85                	andi	a5,a5,1
ffffffffc0200c6c:	3a078d63          	beqz	a5,ffffffffc0201026 <best_fit_check+0x5be>
ffffffffc0200c70:	0389a703          	lw	a4,56(s3)
ffffffffc0200c74:	4789                	li	a5,2
ffffffffc0200c76:	3af71863          	bne	a4,a5,ffffffffc0201026 <best_fit_check+0x5be>
    // * - - * *
    assert((p1 = alloc_pages(1)) != NULL);
ffffffffc0200c7a:	4505                	li	a0,1
ffffffffc0200c7c:	b87ff0ef          	jal	ra,ffffffffc0200802 <alloc_pages>
ffffffffc0200c80:	8baa                	mv	s7,a0
ffffffffc0200c82:	38050263          	beqz	a0,ffffffffc0201006 <best_fit_check+0x59e>
    assert(alloc_pages(2) != NULL);      // best fit feature
ffffffffc0200c86:	4509                	li	a0,2
ffffffffc0200c88:	b7bff0ef          	jal	ra,ffffffffc0200802 <alloc_pages>
ffffffffc0200c8c:	34050d63          	beqz	a0,ffffffffc0200fe6 <best_fit_check+0x57e>
    assert(p0 + 4 == p1);
ffffffffc0200c90:	337c1b63          	bne	s8,s7,ffffffffc0200fc6 <best_fit_check+0x55e>
    #ifdef ucore_test
    score += 1;
    cprintf("grading: %d / %d points\n",score, sumscore);
    #endif
    p2 = p0 + 1;
    free_pages(p0, 5);
ffffffffc0200c94:	854e                	mv	a0,s3
ffffffffc0200c96:	4595                	li	a1,5
ffffffffc0200c98:	ba9ff0ef          	jal	ra,ffffffffc0200840 <free_pages>
    assert((p0 = alloc_pages(5)) != NULL);
ffffffffc0200c9c:	4515                	li	a0,5
ffffffffc0200c9e:	b65ff0ef          	jal	ra,ffffffffc0200802 <alloc_pages>
ffffffffc0200ca2:	89aa                	mv	s3,a0
ffffffffc0200ca4:	30050163          	beqz	a0,ffffffffc0200fa6 <best_fit_check+0x53e>
    assert(alloc_page() == NULL);
ffffffffc0200ca8:	4505                	li	a0,1
ffffffffc0200caa:	b59ff0ef          	jal	ra,ffffffffc0200802 <alloc_pages>
ffffffffc0200cae:	2c051c63          	bnez	a0,ffffffffc0200f86 <best_fit_check+0x51e>

    #ifdef ucore_test
    score += 1;
    cprintf("grading: %d / %d points\n",score, sumscore);
    #endif
    assert(nr_free == 0);
ffffffffc0200cb2:	481c                	lw	a5,16(s0)
ffffffffc0200cb4:	2a079963          	bnez	a5,ffffffffc0200f66 <best_fit_check+0x4fe>
    nr_free = nr_free_store;

    free_list = free_list_store;
    free_pages(p0, 5);
ffffffffc0200cb8:	4595                	li	a1,5
ffffffffc0200cba:	854e                	mv	a0,s3
    nr_free = nr_free_store;
ffffffffc0200cbc:	01642823          	sw	s6,16(s0)
    free_list = free_list_store;
ffffffffc0200cc0:	01543023          	sd	s5,0(s0)
ffffffffc0200cc4:	01443423          	sd	s4,8(s0)
    free_pages(p0, 5);
ffffffffc0200cc8:	b79ff0ef          	jal	ra,ffffffffc0200840 <free_pages>
    return listelm->next;
ffffffffc0200ccc:	641c                	ld	a5,8(s0)

    le = &free_list;
    while ((le = list_next(le)) != &free_list) {
ffffffffc0200cce:	00878963          	beq	a5,s0,ffffffffc0200ce0 <best_fit_check+0x278>
        struct Page *p = le2page(le, page_link);
        count --, total -= p->property;
ffffffffc0200cd2:	ff87a703          	lw	a4,-8(a5)
ffffffffc0200cd6:	679c                	ld	a5,8(a5)
ffffffffc0200cd8:	397d                	addiw	s2,s2,-1
ffffffffc0200cda:	9c99                	subw	s1,s1,a4
    while ((le = list_next(le)) != &free_list) {
ffffffffc0200cdc:	fe879be3          	bne	a5,s0,ffffffffc0200cd2 <best_fit_check+0x26a>
    }
    assert(count == 0);
ffffffffc0200ce0:	26091363          	bnez	s2,ffffffffc0200f46 <best_fit_check+0x4de>
    assert(total == 0);
ffffffffc0200ce4:	e0ed                	bnez	s1,ffffffffc0200dc6 <best_fit_check+0x35e>
    #ifdef ucore_test
    score += 1;
    cprintf("grading: %d / %d points\n",score, sumscore);
    #endif
}
ffffffffc0200ce6:	60a6                	ld	ra,72(sp)
ffffffffc0200ce8:	6406                	ld	s0,64(sp)
ffffffffc0200cea:	74e2                	ld	s1,56(sp)
ffffffffc0200cec:	7942                	ld	s2,48(sp)
ffffffffc0200cee:	79a2                	ld	s3,40(sp)
ffffffffc0200cf0:	7a02                	ld	s4,32(sp)
ffffffffc0200cf2:	6ae2                	ld	s5,24(sp)
ffffffffc0200cf4:	6b42                	ld	s6,16(sp)
ffffffffc0200cf6:	6ba2                	ld	s7,8(sp)
ffffffffc0200cf8:	6c02                	ld	s8,0(sp)
ffffffffc0200cfa:	6161                	addi	sp,sp,80
ffffffffc0200cfc:	8082                	ret
    while ((le = list_next(le)) != &free_list) {
ffffffffc0200cfe:	4981                	li	s3,0
    int count = 0, total = 0;
ffffffffc0200d00:	4481                	li	s1,0
ffffffffc0200d02:	4901                	li	s2,0
ffffffffc0200d04:	b35d                	j	ffffffffc0200aaa <best_fit_check+0x42>
        assert(PageProperty(p));
ffffffffc0200d06:	00001697          	auipc	a3,0x1
ffffffffc0200d0a:	52a68693          	addi	a3,a3,1322 # ffffffffc0202230 <commands+0x600>
ffffffffc0200d0e:	00001617          	auipc	a2,0x1
ffffffffc0200d12:	53260613          	addi	a2,a2,1330 # ffffffffc0202240 <commands+0x610>
ffffffffc0200d16:	10a00593          	li	a1,266
ffffffffc0200d1a:	00001517          	auipc	a0,0x1
ffffffffc0200d1e:	53e50513          	addi	a0,a0,1342 # ffffffffc0202258 <commands+0x628>
ffffffffc0200d22:	c18ff0ef          	jal	ra,ffffffffc020013a <__panic>
    assert(p0 != p1 && p0 != p2 && p1 != p2);
ffffffffc0200d26:	00001697          	auipc	a3,0x1
ffffffffc0200d2a:	5ca68693          	addi	a3,a3,1482 # ffffffffc02022f0 <commands+0x6c0>
ffffffffc0200d2e:	00001617          	auipc	a2,0x1
ffffffffc0200d32:	51260613          	addi	a2,a2,1298 # ffffffffc0202240 <commands+0x610>
ffffffffc0200d36:	0d600593          	li	a1,214
ffffffffc0200d3a:	00001517          	auipc	a0,0x1
ffffffffc0200d3e:	51e50513          	addi	a0,a0,1310 # ffffffffc0202258 <commands+0x628>
ffffffffc0200d42:	bf8ff0ef          	jal	ra,ffffffffc020013a <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
ffffffffc0200d46:	00001697          	auipc	a3,0x1
ffffffffc0200d4a:	5d268693          	addi	a3,a3,1490 # ffffffffc0202318 <commands+0x6e8>
ffffffffc0200d4e:	00001617          	auipc	a2,0x1
ffffffffc0200d52:	4f260613          	addi	a2,a2,1266 # ffffffffc0202240 <commands+0x610>
ffffffffc0200d56:	0d700593          	li	a1,215
ffffffffc0200d5a:	00001517          	auipc	a0,0x1
ffffffffc0200d5e:	4fe50513          	addi	a0,a0,1278 # ffffffffc0202258 <commands+0x628>
ffffffffc0200d62:	bd8ff0ef          	jal	ra,ffffffffc020013a <__panic>
    assert(page2pa(p0) < npage * PGSIZE);
ffffffffc0200d66:	00001697          	auipc	a3,0x1
ffffffffc0200d6a:	5f268693          	addi	a3,a3,1522 # ffffffffc0202358 <commands+0x728>
ffffffffc0200d6e:	00001617          	auipc	a2,0x1
ffffffffc0200d72:	4d260613          	addi	a2,a2,1234 # ffffffffc0202240 <commands+0x610>
ffffffffc0200d76:	0d900593          	li	a1,217
ffffffffc0200d7a:	00001517          	auipc	a0,0x1
ffffffffc0200d7e:	4de50513          	addi	a0,a0,1246 # ffffffffc0202258 <commands+0x628>
ffffffffc0200d82:	bb8ff0ef          	jal	ra,ffffffffc020013a <__panic>
    assert(!list_empty(&free_list));
ffffffffc0200d86:	00001697          	auipc	a3,0x1
ffffffffc0200d8a:	65a68693          	addi	a3,a3,1626 # ffffffffc02023e0 <commands+0x7b0>
ffffffffc0200d8e:	00001617          	auipc	a2,0x1
ffffffffc0200d92:	4b260613          	addi	a2,a2,1202 # ffffffffc0202240 <commands+0x610>
ffffffffc0200d96:	0f200593          	li	a1,242
ffffffffc0200d9a:	00001517          	auipc	a0,0x1
ffffffffc0200d9e:	4be50513          	addi	a0,a0,1214 # ffffffffc0202258 <commands+0x628>
ffffffffc0200da2:	b98ff0ef          	jal	ra,ffffffffc020013a <__panic>
    assert((p2 = alloc_page()) != NULL);
ffffffffc0200da6:	00001697          	auipc	a3,0x1
ffffffffc0200daa:	52a68693          	addi	a3,a3,1322 # ffffffffc02022d0 <commands+0x6a0>
ffffffffc0200dae:	00001617          	auipc	a2,0x1
ffffffffc0200db2:	49260613          	addi	a2,a2,1170 # ffffffffc0202240 <commands+0x610>
ffffffffc0200db6:	0d400593          	li	a1,212
ffffffffc0200dba:	00001517          	auipc	a0,0x1
ffffffffc0200dbe:	49e50513          	addi	a0,a0,1182 # ffffffffc0202258 <commands+0x628>
ffffffffc0200dc2:	b78ff0ef          	jal	ra,ffffffffc020013a <__panic>
    assert(total == 0);
ffffffffc0200dc6:	00001697          	auipc	a3,0x1
ffffffffc0200dca:	74a68693          	addi	a3,a3,1866 # ffffffffc0202510 <commands+0x8e0>
ffffffffc0200dce:	00001617          	auipc	a2,0x1
ffffffffc0200dd2:	47260613          	addi	a2,a2,1138 # ffffffffc0202240 <commands+0x610>
ffffffffc0200dd6:	14c00593          	li	a1,332
ffffffffc0200dda:	00001517          	auipc	a0,0x1
ffffffffc0200dde:	47e50513          	addi	a0,a0,1150 # ffffffffc0202258 <commands+0x628>
ffffffffc0200de2:	b58ff0ef          	jal	ra,ffffffffc020013a <__panic>
    assert(total == nr_free_pages());
ffffffffc0200de6:	00001697          	auipc	a3,0x1
ffffffffc0200dea:	48a68693          	addi	a3,a3,1162 # ffffffffc0202270 <commands+0x640>
ffffffffc0200dee:	00001617          	auipc	a2,0x1
ffffffffc0200df2:	45260613          	addi	a2,a2,1106 # ffffffffc0202240 <commands+0x610>
ffffffffc0200df6:	10d00593          	li	a1,269
ffffffffc0200dfa:	00001517          	auipc	a0,0x1
ffffffffc0200dfe:	45e50513          	addi	a0,a0,1118 # ffffffffc0202258 <commands+0x628>
ffffffffc0200e02:	b38ff0ef          	jal	ra,ffffffffc020013a <__panic>
    assert((p1 = alloc_page()) != NULL);
ffffffffc0200e06:	00001697          	auipc	a3,0x1
ffffffffc0200e0a:	4aa68693          	addi	a3,a3,1194 # ffffffffc02022b0 <commands+0x680>
ffffffffc0200e0e:	00001617          	auipc	a2,0x1
ffffffffc0200e12:	43260613          	addi	a2,a2,1074 # ffffffffc0202240 <commands+0x610>
ffffffffc0200e16:	0d300593          	li	a1,211
ffffffffc0200e1a:	00001517          	auipc	a0,0x1
ffffffffc0200e1e:	43e50513          	addi	a0,a0,1086 # ffffffffc0202258 <commands+0x628>
ffffffffc0200e22:	b18ff0ef          	jal	ra,ffffffffc020013a <__panic>
    assert((p0 = alloc_page()) != NULL);
ffffffffc0200e26:	00001697          	auipc	a3,0x1
ffffffffc0200e2a:	46a68693          	addi	a3,a3,1130 # ffffffffc0202290 <commands+0x660>
ffffffffc0200e2e:	00001617          	auipc	a2,0x1
ffffffffc0200e32:	41260613          	addi	a2,a2,1042 # ffffffffc0202240 <commands+0x610>
ffffffffc0200e36:	0d200593          	li	a1,210
ffffffffc0200e3a:	00001517          	auipc	a0,0x1
ffffffffc0200e3e:	41e50513          	addi	a0,a0,1054 # ffffffffc0202258 <commands+0x628>
ffffffffc0200e42:	af8ff0ef          	jal	ra,ffffffffc020013a <__panic>
    assert(alloc_page() == NULL);
ffffffffc0200e46:	00001697          	auipc	a3,0x1
ffffffffc0200e4a:	57268693          	addi	a3,a3,1394 # ffffffffc02023b8 <commands+0x788>
ffffffffc0200e4e:	00001617          	auipc	a2,0x1
ffffffffc0200e52:	3f260613          	addi	a2,a2,1010 # ffffffffc0202240 <commands+0x610>
ffffffffc0200e56:	0ef00593          	li	a1,239
ffffffffc0200e5a:	00001517          	auipc	a0,0x1
ffffffffc0200e5e:	3fe50513          	addi	a0,a0,1022 # ffffffffc0202258 <commands+0x628>
ffffffffc0200e62:	ad8ff0ef          	jal	ra,ffffffffc020013a <__panic>
    assert((p2 = alloc_page()) != NULL);
ffffffffc0200e66:	00001697          	auipc	a3,0x1
ffffffffc0200e6a:	46a68693          	addi	a3,a3,1130 # ffffffffc02022d0 <commands+0x6a0>
ffffffffc0200e6e:	00001617          	auipc	a2,0x1
ffffffffc0200e72:	3d260613          	addi	a2,a2,978 # ffffffffc0202240 <commands+0x610>
ffffffffc0200e76:	0ed00593          	li	a1,237
ffffffffc0200e7a:	00001517          	auipc	a0,0x1
ffffffffc0200e7e:	3de50513          	addi	a0,a0,990 # ffffffffc0202258 <commands+0x628>
ffffffffc0200e82:	ab8ff0ef          	jal	ra,ffffffffc020013a <__panic>
    assert((p1 = alloc_page()) != NULL);
ffffffffc0200e86:	00001697          	auipc	a3,0x1
ffffffffc0200e8a:	42a68693          	addi	a3,a3,1066 # ffffffffc02022b0 <commands+0x680>
ffffffffc0200e8e:	00001617          	auipc	a2,0x1
ffffffffc0200e92:	3b260613          	addi	a2,a2,946 # ffffffffc0202240 <commands+0x610>
ffffffffc0200e96:	0ec00593          	li	a1,236
ffffffffc0200e9a:	00001517          	auipc	a0,0x1
ffffffffc0200e9e:	3be50513          	addi	a0,a0,958 # ffffffffc0202258 <commands+0x628>
ffffffffc0200ea2:	a98ff0ef          	jal	ra,ffffffffc020013a <__panic>
    assert((p0 = alloc_page()) != NULL);
ffffffffc0200ea6:	00001697          	auipc	a3,0x1
ffffffffc0200eaa:	3ea68693          	addi	a3,a3,1002 # ffffffffc0202290 <commands+0x660>
ffffffffc0200eae:	00001617          	auipc	a2,0x1
ffffffffc0200eb2:	39260613          	addi	a2,a2,914 # ffffffffc0202240 <commands+0x610>
ffffffffc0200eb6:	0eb00593          	li	a1,235
ffffffffc0200eba:	00001517          	auipc	a0,0x1
ffffffffc0200ebe:	39e50513          	addi	a0,a0,926 # ffffffffc0202258 <commands+0x628>
ffffffffc0200ec2:	a78ff0ef          	jal	ra,ffffffffc020013a <__panic>
    assert(nr_free == 3);
ffffffffc0200ec6:	00001697          	auipc	a3,0x1
ffffffffc0200eca:	50a68693          	addi	a3,a3,1290 # ffffffffc02023d0 <commands+0x7a0>
ffffffffc0200ece:	00001617          	auipc	a2,0x1
ffffffffc0200ed2:	37260613          	addi	a2,a2,882 # ffffffffc0202240 <commands+0x610>
ffffffffc0200ed6:	0e900593          	li	a1,233
ffffffffc0200eda:	00001517          	auipc	a0,0x1
ffffffffc0200ede:	37e50513          	addi	a0,a0,894 # ffffffffc0202258 <commands+0x628>
ffffffffc0200ee2:	a58ff0ef          	jal	ra,ffffffffc020013a <__panic>
    assert(alloc_page() == NULL);
ffffffffc0200ee6:	00001697          	auipc	a3,0x1
ffffffffc0200eea:	4d268693          	addi	a3,a3,1234 # ffffffffc02023b8 <commands+0x788>
ffffffffc0200eee:	00001617          	auipc	a2,0x1
ffffffffc0200ef2:	35260613          	addi	a2,a2,850 # ffffffffc0202240 <commands+0x610>
ffffffffc0200ef6:	0e400593          	li	a1,228
ffffffffc0200efa:	00001517          	auipc	a0,0x1
ffffffffc0200efe:	35e50513          	addi	a0,a0,862 # ffffffffc0202258 <commands+0x628>
ffffffffc0200f02:	a38ff0ef          	jal	ra,ffffffffc020013a <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
ffffffffc0200f06:	00001697          	auipc	a3,0x1
ffffffffc0200f0a:	49268693          	addi	a3,a3,1170 # ffffffffc0202398 <commands+0x768>
ffffffffc0200f0e:	00001617          	auipc	a2,0x1
ffffffffc0200f12:	33260613          	addi	a2,a2,818 # ffffffffc0202240 <commands+0x610>
ffffffffc0200f16:	0db00593          	li	a1,219
ffffffffc0200f1a:	00001517          	auipc	a0,0x1
ffffffffc0200f1e:	33e50513          	addi	a0,a0,830 # ffffffffc0202258 <commands+0x628>
ffffffffc0200f22:	a18ff0ef          	jal	ra,ffffffffc020013a <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
ffffffffc0200f26:	00001697          	auipc	a3,0x1
ffffffffc0200f2a:	45268693          	addi	a3,a3,1106 # ffffffffc0202378 <commands+0x748>
ffffffffc0200f2e:	00001617          	auipc	a2,0x1
ffffffffc0200f32:	31260613          	addi	a2,a2,786 # ffffffffc0202240 <commands+0x610>
ffffffffc0200f36:	0da00593          	li	a1,218
ffffffffc0200f3a:	00001517          	auipc	a0,0x1
ffffffffc0200f3e:	31e50513          	addi	a0,a0,798 # ffffffffc0202258 <commands+0x628>
ffffffffc0200f42:	9f8ff0ef          	jal	ra,ffffffffc020013a <__panic>
    assert(count == 0);
ffffffffc0200f46:	00001697          	auipc	a3,0x1
ffffffffc0200f4a:	5ba68693          	addi	a3,a3,1466 # ffffffffc0202500 <commands+0x8d0>
ffffffffc0200f4e:	00001617          	auipc	a2,0x1
ffffffffc0200f52:	2f260613          	addi	a2,a2,754 # ffffffffc0202240 <commands+0x610>
ffffffffc0200f56:	14b00593          	li	a1,331
ffffffffc0200f5a:	00001517          	auipc	a0,0x1
ffffffffc0200f5e:	2fe50513          	addi	a0,a0,766 # ffffffffc0202258 <commands+0x628>
ffffffffc0200f62:	9d8ff0ef          	jal	ra,ffffffffc020013a <__panic>
    assert(nr_free == 0);
ffffffffc0200f66:	00001697          	auipc	a3,0x1
ffffffffc0200f6a:	4b268693          	addi	a3,a3,1202 # ffffffffc0202418 <commands+0x7e8>
ffffffffc0200f6e:	00001617          	auipc	a2,0x1
ffffffffc0200f72:	2d260613          	addi	a2,a2,722 # ffffffffc0202240 <commands+0x610>
ffffffffc0200f76:	14000593          	li	a1,320
ffffffffc0200f7a:	00001517          	auipc	a0,0x1
ffffffffc0200f7e:	2de50513          	addi	a0,a0,734 # ffffffffc0202258 <commands+0x628>
ffffffffc0200f82:	9b8ff0ef          	jal	ra,ffffffffc020013a <__panic>
    assert(alloc_page() == NULL);
ffffffffc0200f86:	00001697          	auipc	a3,0x1
ffffffffc0200f8a:	43268693          	addi	a3,a3,1074 # ffffffffc02023b8 <commands+0x788>
ffffffffc0200f8e:	00001617          	auipc	a2,0x1
ffffffffc0200f92:	2b260613          	addi	a2,a2,690 # ffffffffc0202240 <commands+0x610>
ffffffffc0200f96:	13a00593          	li	a1,314
ffffffffc0200f9a:	00001517          	auipc	a0,0x1
ffffffffc0200f9e:	2be50513          	addi	a0,a0,702 # ffffffffc0202258 <commands+0x628>
ffffffffc0200fa2:	998ff0ef          	jal	ra,ffffffffc020013a <__panic>
    assert((p0 = alloc_pages(5)) != NULL);
ffffffffc0200fa6:	00001697          	auipc	a3,0x1
ffffffffc0200faa:	53a68693          	addi	a3,a3,1338 # ffffffffc02024e0 <commands+0x8b0>
ffffffffc0200fae:	00001617          	auipc	a2,0x1
ffffffffc0200fb2:	29260613          	addi	a2,a2,658 # ffffffffc0202240 <commands+0x610>
ffffffffc0200fb6:	13900593          	li	a1,313
ffffffffc0200fba:	00001517          	auipc	a0,0x1
ffffffffc0200fbe:	29e50513          	addi	a0,a0,670 # ffffffffc0202258 <commands+0x628>
ffffffffc0200fc2:	978ff0ef          	jal	ra,ffffffffc020013a <__panic>
    assert(p0 + 4 == p1);
ffffffffc0200fc6:	00001697          	auipc	a3,0x1
ffffffffc0200fca:	50a68693          	addi	a3,a3,1290 # ffffffffc02024d0 <commands+0x8a0>
ffffffffc0200fce:	00001617          	auipc	a2,0x1
ffffffffc0200fd2:	27260613          	addi	a2,a2,626 # ffffffffc0202240 <commands+0x610>
ffffffffc0200fd6:	13100593          	li	a1,305
ffffffffc0200fda:	00001517          	auipc	a0,0x1
ffffffffc0200fde:	27e50513          	addi	a0,a0,638 # ffffffffc0202258 <commands+0x628>
ffffffffc0200fe2:	958ff0ef          	jal	ra,ffffffffc020013a <__panic>
    assert(alloc_pages(2) != NULL);      // best fit feature
ffffffffc0200fe6:	00001697          	auipc	a3,0x1
ffffffffc0200fea:	4d268693          	addi	a3,a3,1234 # ffffffffc02024b8 <commands+0x888>
ffffffffc0200fee:	00001617          	auipc	a2,0x1
ffffffffc0200ff2:	25260613          	addi	a2,a2,594 # ffffffffc0202240 <commands+0x610>
ffffffffc0200ff6:	13000593          	li	a1,304
ffffffffc0200ffa:	00001517          	auipc	a0,0x1
ffffffffc0200ffe:	25e50513          	addi	a0,a0,606 # ffffffffc0202258 <commands+0x628>
ffffffffc0201002:	938ff0ef          	jal	ra,ffffffffc020013a <__panic>
    assert((p1 = alloc_pages(1)) != NULL);
ffffffffc0201006:	00001697          	auipc	a3,0x1
ffffffffc020100a:	49268693          	addi	a3,a3,1170 # ffffffffc0202498 <commands+0x868>
ffffffffc020100e:	00001617          	auipc	a2,0x1
ffffffffc0201012:	23260613          	addi	a2,a2,562 # ffffffffc0202240 <commands+0x610>
ffffffffc0201016:	12f00593          	li	a1,303
ffffffffc020101a:	00001517          	auipc	a0,0x1
ffffffffc020101e:	23e50513          	addi	a0,a0,574 # ffffffffc0202258 <commands+0x628>
ffffffffc0201022:	918ff0ef          	jal	ra,ffffffffc020013a <__panic>
    assert(PageProperty(p0 + 1) && p0[1].property == 2);
ffffffffc0201026:	00001697          	auipc	a3,0x1
ffffffffc020102a:	44268693          	addi	a3,a3,1090 # ffffffffc0202468 <commands+0x838>
ffffffffc020102e:	00001617          	auipc	a2,0x1
ffffffffc0201032:	21260613          	addi	a2,a2,530 # ffffffffc0202240 <commands+0x610>
ffffffffc0201036:	12d00593          	li	a1,301
ffffffffc020103a:	00001517          	auipc	a0,0x1
ffffffffc020103e:	21e50513          	addi	a0,a0,542 # ffffffffc0202258 <commands+0x628>
ffffffffc0201042:	8f8ff0ef          	jal	ra,ffffffffc020013a <__panic>
    assert(alloc_pages(4) == NULL);
ffffffffc0201046:	00001697          	auipc	a3,0x1
ffffffffc020104a:	40a68693          	addi	a3,a3,1034 # ffffffffc0202450 <commands+0x820>
ffffffffc020104e:	00001617          	auipc	a2,0x1
ffffffffc0201052:	1f260613          	addi	a2,a2,498 # ffffffffc0202240 <commands+0x610>
ffffffffc0201056:	12c00593          	li	a1,300
ffffffffc020105a:	00001517          	auipc	a0,0x1
ffffffffc020105e:	1fe50513          	addi	a0,a0,510 # ffffffffc0202258 <commands+0x628>
ffffffffc0201062:	8d8ff0ef          	jal	ra,ffffffffc020013a <__panic>
    assert(alloc_page() == NULL);
ffffffffc0201066:	00001697          	auipc	a3,0x1
ffffffffc020106a:	35268693          	addi	a3,a3,850 # ffffffffc02023b8 <commands+0x788>
ffffffffc020106e:	00001617          	auipc	a2,0x1
ffffffffc0201072:	1d260613          	addi	a2,a2,466 # ffffffffc0202240 <commands+0x610>
ffffffffc0201076:	12000593          	li	a1,288
ffffffffc020107a:	00001517          	auipc	a0,0x1
ffffffffc020107e:	1de50513          	addi	a0,a0,478 # ffffffffc0202258 <commands+0x628>
ffffffffc0201082:	8b8ff0ef          	jal	ra,ffffffffc020013a <__panic>
    assert(!PageProperty(p0));
ffffffffc0201086:	00001697          	auipc	a3,0x1
ffffffffc020108a:	3b268693          	addi	a3,a3,946 # ffffffffc0202438 <commands+0x808>
ffffffffc020108e:	00001617          	auipc	a2,0x1
ffffffffc0201092:	1b260613          	addi	a2,a2,434 # ffffffffc0202240 <commands+0x610>
ffffffffc0201096:	11700593          	li	a1,279
ffffffffc020109a:	00001517          	auipc	a0,0x1
ffffffffc020109e:	1be50513          	addi	a0,a0,446 # ffffffffc0202258 <commands+0x628>
ffffffffc02010a2:	898ff0ef          	jal	ra,ffffffffc020013a <__panic>
    assert(p0 != NULL);
ffffffffc02010a6:	00001697          	auipc	a3,0x1
ffffffffc02010aa:	38268693          	addi	a3,a3,898 # ffffffffc0202428 <commands+0x7f8>
ffffffffc02010ae:	00001617          	auipc	a2,0x1
ffffffffc02010b2:	19260613          	addi	a2,a2,402 # ffffffffc0202240 <commands+0x610>
ffffffffc02010b6:	11600593          	li	a1,278
ffffffffc02010ba:	00001517          	auipc	a0,0x1
ffffffffc02010be:	19e50513          	addi	a0,a0,414 # ffffffffc0202258 <commands+0x628>
ffffffffc02010c2:	878ff0ef          	jal	ra,ffffffffc020013a <__panic>
    assert(nr_free == 0);
ffffffffc02010c6:	00001697          	auipc	a3,0x1
ffffffffc02010ca:	35268693          	addi	a3,a3,850 # ffffffffc0202418 <commands+0x7e8>
ffffffffc02010ce:	00001617          	auipc	a2,0x1
ffffffffc02010d2:	17260613          	addi	a2,a2,370 # ffffffffc0202240 <commands+0x610>
ffffffffc02010d6:	0f800593          	li	a1,248
ffffffffc02010da:	00001517          	auipc	a0,0x1
ffffffffc02010de:	17e50513          	addi	a0,a0,382 # ffffffffc0202258 <commands+0x628>
ffffffffc02010e2:	858ff0ef          	jal	ra,ffffffffc020013a <__panic>
    assert(alloc_page() == NULL);
ffffffffc02010e6:	00001697          	auipc	a3,0x1
ffffffffc02010ea:	2d268693          	addi	a3,a3,722 # ffffffffc02023b8 <commands+0x788>
ffffffffc02010ee:	00001617          	auipc	a2,0x1
ffffffffc02010f2:	15260613          	addi	a2,a2,338 # ffffffffc0202240 <commands+0x610>
ffffffffc02010f6:	0f600593          	li	a1,246
ffffffffc02010fa:	00001517          	auipc	a0,0x1
ffffffffc02010fe:	15e50513          	addi	a0,a0,350 # ffffffffc0202258 <commands+0x628>
ffffffffc0201102:	838ff0ef          	jal	ra,ffffffffc020013a <__panic>
    assert((p = alloc_page()) == p0);
ffffffffc0201106:	00001697          	auipc	a3,0x1
ffffffffc020110a:	2f268693          	addi	a3,a3,754 # ffffffffc02023f8 <commands+0x7c8>
ffffffffc020110e:	00001617          	auipc	a2,0x1
ffffffffc0201112:	13260613          	addi	a2,a2,306 # ffffffffc0202240 <commands+0x610>
ffffffffc0201116:	0f500593          	li	a1,245
ffffffffc020111a:	00001517          	auipc	a0,0x1
ffffffffc020111e:	13e50513          	addi	a0,a0,318 # ffffffffc0202258 <commands+0x628>
ffffffffc0201122:	818ff0ef          	jal	ra,ffffffffc020013a <__panic>

ffffffffc0201126 <best_fit_free_pages>:
best_fit_free_pages(struct Page *base, size_t n) {
ffffffffc0201126:	1141                	addi	sp,sp,-16
ffffffffc0201128:	e406                	sd	ra,8(sp)
    assert(n > 0);
ffffffffc020112a:	14058a63          	beqz	a1,ffffffffc020127e <best_fit_free_pages+0x158>
    for (; p != base + n; p ++) {
ffffffffc020112e:	00259693          	slli	a3,a1,0x2
ffffffffc0201132:	96ae                	add	a3,a3,a1
ffffffffc0201134:	068e                	slli	a3,a3,0x3
ffffffffc0201136:	96aa                	add	a3,a3,a0
ffffffffc0201138:	87aa                	mv	a5,a0
ffffffffc020113a:	02d50263          	beq	a0,a3,ffffffffc020115e <best_fit_free_pages+0x38>
ffffffffc020113e:	6798                	ld	a4,8(a5)
        assert(!PageReserved(p) && !PageProperty(p));
ffffffffc0201140:	8b05                	andi	a4,a4,1
ffffffffc0201142:	10071e63          	bnez	a4,ffffffffc020125e <best_fit_free_pages+0x138>
ffffffffc0201146:	6798                	ld	a4,8(a5)
ffffffffc0201148:	8b09                	andi	a4,a4,2
ffffffffc020114a:	10071a63          	bnez	a4,ffffffffc020125e <best_fit_free_pages+0x138>
        p->flags = 0;
ffffffffc020114e:	0007b423          	sd	zero,8(a5)
//将page指针转化为物理地址


static inline int page_ref(struct Page *page) { return page->ref; }
//返回页面的引用计数
static inline void set_page_ref(struct Page *page, int val) { page->ref = val; }
ffffffffc0201152:	0007a023          	sw	zero,0(a5)
    for (; p != base + n; p ++) {
ffffffffc0201156:	02878793          	addi	a5,a5,40
ffffffffc020115a:	fed792e3          	bne	a5,a3,ffffffffc020113e <best_fit_free_pages+0x18>
    base->property = n;
ffffffffc020115e:	2581                	sext.w	a1,a1
ffffffffc0201160:	c90c                	sw	a1,16(a0)
    SetPageProperty(base);
ffffffffc0201162:	00850893          	addi	a7,a0,8
    __op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc0201166:	4789                	li	a5,2
ffffffffc0201168:	40f8b02f          	amoor.d	zero,a5,(a7)
    nr_free += n;
ffffffffc020116c:	00005697          	auipc	a3,0x5
ffffffffc0201170:	ea468693          	addi	a3,a3,-348 # ffffffffc0206010 <bffree_area>
ffffffffc0201174:	4a98                	lw	a4,16(a3)
    return list->next == list;
ffffffffc0201176:	669c                	ld	a5,8(a3)
        list_add(&free_list, &(base->page_link));
ffffffffc0201178:	01850613          	addi	a2,a0,24
    nr_free += n;
ffffffffc020117c:	9db9                	addw	a1,a1,a4
ffffffffc020117e:	ca8c                	sw	a1,16(a3)
    if (list_empty(&free_list)) {
ffffffffc0201180:	0ad78863          	beq	a5,a3,ffffffffc0201230 <best_fit_free_pages+0x10a>
            struct Page* page = le2page(le, page_link);
ffffffffc0201184:	fe878713          	addi	a4,a5,-24
ffffffffc0201188:	0006b803          	ld	a6,0(a3)
    if (list_empty(&free_list)) {
ffffffffc020118c:	4581                	li	a1,0
            if (base < page) {
ffffffffc020118e:	00e56a63          	bltu	a0,a4,ffffffffc02011a2 <best_fit_free_pages+0x7c>
    return listelm->next;
ffffffffc0201192:	6798                	ld	a4,8(a5)
            } else if (list_next(le) == &free_list) {
ffffffffc0201194:	06d70263          	beq	a4,a3,ffffffffc02011f8 <best_fit_free_pages+0xd2>
    for (; p != base + n; p ++) {
ffffffffc0201198:	87ba                	mv	a5,a4
            struct Page* page = le2page(le, page_link);
ffffffffc020119a:	fe878713          	addi	a4,a5,-24
            if (base < page) {
ffffffffc020119e:	fee57ae3          	bgeu	a0,a4,ffffffffc0201192 <best_fit_free_pages+0x6c>
ffffffffc02011a2:	c199                	beqz	a1,ffffffffc02011a8 <best_fit_free_pages+0x82>
ffffffffc02011a4:	0106b023          	sd	a6,0(a3)
    __list_add(elm, listelm->prev, listelm);
ffffffffc02011a8:	6398                	ld	a4,0(a5)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
ffffffffc02011aa:	e390                	sd	a2,0(a5)
ffffffffc02011ac:	e710                	sd	a2,8(a4)
    elm->next = next;
ffffffffc02011ae:	f11c                	sd	a5,32(a0)
    elm->prev = prev;
ffffffffc02011b0:	ed18                	sd	a4,24(a0)
    if (le != &free_list) {
ffffffffc02011b2:	02d70063          	beq	a4,a3,ffffffffc02011d2 <best_fit_free_pages+0xac>
         if (p + p->property == base) {
ffffffffc02011b6:	ff872803          	lw	a6,-8(a4) # ffffffffffffeff8 <end+0x3fdf8b88>
        p = le2page(le, page_link);
ffffffffc02011ba:	fe870593          	addi	a1,a4,-24
         if (p + p->property == base) {
ffffffffc02011be:	02081613          	slli	a2,a6,0x20
ffffffffc02011c2:	9201                	srli	a2,a2,0x20
ffffffffc02011c4:	00261793          	slli	a5,a2,0x2
ffffffffc02011c8:	97b2                	add	a5,a5,a2
ffffffffc02011ca:	078e                	slli	a5,a5,0x3
ffffffffc02011cc:	97ae                	add	a5,a5,a1
ffffffffc02011ce:	02f50f63          	beq	a0,a5,ffffffffc020120c <best_fit_free_pages+0xe6>
    return listelm->next;
ffffffffc02011d2:	7118                	ld	a4,32(a0)
    if (le != &free_list) {
ffffffffc02011d4:	00d70f63          	beq	a4,a3,ffffffffc02011f2 <best_fit_free_pages+0xcc>
        if (base + base->property == p) {
ffffffffc02011d8:	490c                	lw	a1,16(a0)
        p = le2page(le, page_link);
ffffffffc02011da:	fe870693          	addi	a3,a4,-24
        if (base + base->property == p) {
ffffffffc02011de:	02059613          	slli	a2,a1,0x20
ffffffffc02011e2:	9201                	srli	a2,a2,0x20
ffffffffc02011e4:	00261793          	slli	a5,a2,0x2
ffffffffc02011e8:	97b2                	add	a5,a5,a2
ffffffffc02011ea:	078e                	slli	a5,a5,0x3
ffffffffc02011ec:	97aa                	add	a5,a5,a0
ffffffffc02011ee:	04f68863          	beq	a3,a5,ffffffffc020123e <best_fit_free_pages+0x118>
}
ffffffffc02011f2:	60a2                	ld	ra,8(sp)
ffffffffc02011f4:	0141                	addi	sp,sp,16
ffffffffc02011f6:	8082                	ret
    prev->next = next->prev = elm;
ffffffffc02011f8:	e790                	sd	a2,8(a5)
    elm->next = next;
ffffffffc02011fa:	f114                	sd	a3,32(a0)
    return listelm->next;
ffffffffc02011fc:	6798                	ld	a4,8(a5)
    elm->prev = prev;
ffffffffc02011fe:	ed1c                	sd	a5,24(a0)
        while ((le = list_next(le)) != &free_list) {
ffffffffc0201200:	02d70563          	beq	a4,a3,ffffffffc020122a <best_fit_free_pages+0x104>
    prev->next = next->prev = elm;
ffffffffc0201204:	8832                	mv	a6,a2
ffffffffc0201206:	4585                	li	a1,1
    for (; p != base + n; p ++) {
ffffffffc0201208:	87ba                	mv	a5,a4
ffffffffc020120a:	bf41                	j	ffffffffc020119a <best_fit_free_pages+0x74>
            p->property += base->property;
ffffffffc020120c:	491c                	lw	a5,16(a0)
ffffffffc020120e:	0107883b          	addw	a6,a5,a6
ffffffffc0201212:	ff072c23          	sw	a6,-8(a4)
    __op_bit(and, __NOT, nr, ((volatile unsigned long *)addr));
ffffffffc0201216:	57f5                	li	a5,-3
ffffffffc0201218:	60f8b02f          	amoand.d	zero,a5,(a7)
    __list_del(listelm->prev, listelm->next);
ffffffffc020121c:	6d10                	ld	a2,24(a0)
ffffffffc020121e:	711c                	ld	a5,32(a0)
            base = p;
ffffffffc0201220:	852e                	mv	a0,a1
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
ffffffffc0201222:	e61c                	sd	a5,8(a2)
    return listelm->next;
ffffffffc0201224:	6718                	ld	a4,8(a4)
    next->prev = prev;
ffffffffc0201226:	e390                	sd	a2,0(a5)
ffffffffc0201228:	b775                	j	ffffffffc02011d4 <best_fit_free_pages+0xae>
ffffffffc020122a:	e290                	sd	a2,0(a3)
        while ((le = list_next(le)) != &free_list) {
ffffffffc020122c:	873e                	mv	a4,a5
ffffffffc020122e:	b761                	j	ffffffffc02011b6 <best_fit_free_pages+0x90>
}
ffffffffc0201230:	60a2                	ld	ra,8(sp)
    prev->next = next->prev = elm;
ffffffffc0201232:	e390                	sd	a2,0(a5)
ffffffffc0201234:	e790                	sd	a2,8(a5)
    elm->next = next;
ffffffffc0201236:	f11c                	sd	a5,32(a0)
    elm->prev = prev;
ffffffffc0201238:	ed1c                	sd	a5,24(a0)
ffffffffc020123a:	0141                	addi	sp,sp,16
ffffffffc020123c:	8082                	ret
            base->property += p->property;
ffffffffc020123e:	ff872783          	lw	a5,-8(a4)
ffffffffc0201242:	ff070693          	addi	a3,a4,-16
ffffffffc0201246:	9dbd                	addw	a1,a1,a5
ffffffffc0201248:	c90c                	sw	a1,16(a0)
ffffffffc020124a:	57f5                	li	a5,-3
ffffffffc020124c:	60f6b02f          	amoand.d	zero,a5,(a3)
    __list_del(listelm->prev, listelm->next);
ffffffffc0201250:	6314                	ld	a3,0(a4)
ffffffffc0201252:	671c                	ld	a5,8(a4)
}
ffffffffc0201254:	60a2                	ld	ra,8(sp)
    prev->next = next;
ffffffffc0201256:	e69c                	sd	a5,8(a3)
    next->prev = prev;
ffffffffc0201258:	e394                	sd	a3,0(a5)
ffffffffc020125a:	0141                	addi	sp,sp,16
ffffffffc020125c:	8082                	ret
        assert(!PageReserved(p) && !PageProperty(p));
ffffffffc020125e:	00001697          	auipc	a3,0x1
ffffffffc0201262:	2ca68693          	addi	a3,a3,714 # ffffffffc0202528 <commands+0x8f8>
ffffffffc0201266:	00001617          	auipc	a2,0x1
ffffffffc020126a:	fda60613          	addi	a2,a2,-38 # ffffffffc0202240 <commands+0x610>
ffffffffc020126e:	09300593          	li	a1,147
ffffffffc0201272:	00001517          	auipc	a0,0x1
ffffffffc0201276:	fe650513          	addi	a0,a0,-26 # ffffffffc0202258 <commands+0x628>
ffffffffc020127a:	ec1fe0ef          	jal	ra,ffffffffc020013a <__panic>
    assert(n > 0);
ffffffffc020127e:	00001697          	auipc	a3,0x1
ffffffffc0201282:	2a268693          	addi	a3,a3,674 # ffffffffc0202520 <commands+0x8f0>
ffffffffc0201286:	00001617          	auipc	a2,0x1
ffffffffc020128a:	fba60613          	addi	a2,a2,-70 # ffffffffc0202240 <commands+0x610>
ffffffffc020128e:	09000593          	li	a1,144
ffffffffc0201292:	00001517          	auipc	a0,0x1
ffffffffc0201296:	fc650513          	addi	a0,a0,-58 # ffffffffc0202258 <commands+0x628>
ffffffffc020129a:	ea1fe0ef          	jal	ra,ffffffffc020013a <__panic>

ffffffffc020129e <best_fit_alloc_pages>:
    assert(n > 0);
ffffffffc020129e:	c545                	beqz	a0,ffffffffc0201346 <best_fit_alloc_pages+0xa8>
    if (n > nr_free) {
ffffffffc02012a0:	00005597          	auipc	a1,0x5
ffffffffc02012a4:	d7058593          	addi	a1,a1,-656 # ffffffffc0206010 <bffree_area>
ffffffffc02012a8:	0105a883          	lw	a7,16(a1)
ffffffffc02012ac:	86aa                	mv	a3,a0
ffffffffc02012ae:	02089793          	slli	a5,a7,0x20
ffffffffc02012b2:	9381                	srli	a5,a5,0x20
ffffffffc02012b4:	08a7e763          	bltu	a5,a0,ffffffffc0201342 <best_fit_alloc_pages+0xa4>
    return listelm->next;
ffffffffc02012b8:	659c                	ld	a5,8(a1)
    struct Page *best_page=NULL;
ffffffffc02012ba:	4501                	li	a0,0
    while ((le = list_next(le)) != &free_list) {
ffffffffc02012bc:	08b78263          	beq	a5,a1,ffffffffc0201340 <best_fit_alloc_pages+0xa2>
    int min= PHYSICAL_MEMORY_END/ PGSIZE;
ffffffffc02012c0:	00088837          	lui	a6,0x88
        if (p->property >= n &&(p->property-n)<min) {
ffffffffc02012c4:	ff87a603          	lw	a2,-8(a5)
ffffffffc02012c8:	02061713          	slli	a4,a2,0x20
ffffffffc02012cc:	9301                	srli	a4,a4,0x20
ffffffffc02012ce:	00d76963          	bltu	a4,a3,ffffffffc02012e0 <best_fit_alloc_pages+0x42>
ffffffffc02012d2:	8f15                	sub	a4,a4,a3
ffffffffc02012d4:	01077663          	bgeu	a4,a6,ffffffffc02012e0 <best_fit_alloc_pages+0x42>
        struct Page *p = le2page(le, page_link);
ffffffffc02012d8:	fe878513          	addi	a0,a5,-24
            min=(p->property-n);
ffffffffc02012dc:	40d6083b          	subw	a6,a2,a3
ffffffffc02012e0:	679c                	ld	a5,8(a5)
    while ((le = list_next(le)) != &free_list) {
ffffffffc02012e2:	feb791e3          	bne	a5,a1,ffffffffc02012c4 <best_fit_alloc_pages+0x26>
    if (page != NULL) {
ffffffffc02012e6:	cd29                	beqz	a0,ffffffffc0201340 <best_fit_alloc_pages+0xa2>
    __list_del(listelm->prev, listelm->next);
ffffffffc02012e8:	711c                	ld	a5,32(a0)
    return listelm->prev;
ffffffffc02012ea:	6d18                	ld	a4,24(a0)
        if (page->property > n) {
ffffffffc02012ec:	4910                	lw	a2,16(a0)
            min=(p->property-n);
ffffffffc02012ee:	0006881b          	sext.w	a6,a3
    prev->next = next;
ffffffffc02012f2:	e71c                	sd	a5,8(a4)
    next->prev = prev;
ffffffffc02012f4:	e398                	sd	a4,0(a5)
        if (page->property > n) {
ffffffffc02012f6:	02061793          	slli	a5,a2,0x20
ffffffffc02012fa:	9381                	srli	a5,a5,0x20
ffffffffc02012fc:	02f6f863          	bgeu	a3,a5,ffffffffc020132c <best_fit_alloc_pages+0x8e>
            struct Page *p = page + n;
ffffffffc0201300:	00269793          	slli	a5,a3,0x2
ffffffffc0201304:	97b6                	add	a5,a5,a3
ffffffffc0201306:	078e                	slli	a5,a5,0x3
ffffffffc0201308:	97aa                	add	a5,a5,a0
            p->property = page->property - n;
ffffffffc020130a:	4106063b          	subw	a2,a2,a6
ffffffffc020130e:	cb90                	sw	a2,16(a5)
    __op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc0201310:	4689                	li	a3,2
ffffffffc0201312:	00878613          	addi	a2,a5,8
ffffffffc0201316:	40d6302f          	amoor.d	zero,a3,(a2)
    __list_add(elm, listelm, listelm->next);
ffffffffc020131a:	6714                	ld	a3,8(a4)
            list_add(prev, &(p->page_link));
ffffffffc020131c:	01878613          	addi	a2,a5,24
        nr_free -= n;
ffffffffc0201320:	0105a883          	lw	a7,16(a1)
    prev->next = next->prev = elm;
ffffffffc0201324:	e290                	sd	a2,0(a3)
ffffffffc0201326:	e710                	sd	a2,8(a4)
    elm->next = next;
ffffffffc0201328:	f394                	sd	a3,32(a5)
    elm->prev = prev;
ffffffffc020132a:	ef98                	sd	a4,24(a5)
ffffffffc020132c:	410888bb          	subw	a7,a7,a6
ffffffffc0201330:	0115a823          	sw	a7,16(a1)
    __op_bit(and, __NOT, nr, ((volatile unsigned long *)addr));
ffffffffc0201334:	57f5                	li	a5,-3
ffffffffc0201336:	00850713          	addi	a4,a0,8
ffffffffc020133a:	60f7302f          	amoand.d	zero,a5,(a4)
}
ffffffffc020133e:	8082                	ret
}
ffffffffc0201340:	8082                	ret
        return NULL;
ffffffffc0201342:	4501                	li	a0,0
ffffffffc0201344:	8082                	ret
best_fit_alloc_pages(size_t n) {
ffffffffc0201346:	1141                	addi	sp,sp,-16
    assert(n > 0);
ffffffffc0201348:	00001697          	auipc	a3,0x1
ffffffffc020134c:	1d868693          	addi	a3,a3,472 # ffffffffc0202520 <commands+0x8f0>
ffffffffc0201350:	00001617          	auipc	a2,0x1
ffffffffc0201354:	ef060613          	addi	a2,a2,-272 # ffffffffc0202240 <commands+0x610>
ffffffffc0201358:	06900593          	li	a1,105
ffffffffc020135c:	00001517          	auipc	a0,0x1
ffffffffc0201360:	efc50513          	addi	a0,a0,-260 # ffffffffc0202258 <commands+0x628>
best_fit_alloc_pages(size_t n) {
ffffffffc0201364:	e406                	sd	ra,8(sp)
    assert(n > 0);
ffffffffc0201366:	dd5fe0ef          	jal	ra,ffffffffc020013a <__panic>

ffffffffc020136a <best_fit_init_memmap>:
best_fit_init_memmap(struct Page *base, size_t n) {
ffffffffc020136a:	1141                	addi	sp,sp,-16
ffffffffc020136c:	e406                	sd	ra,8(sp)
    assert(n > 0);
ffffffffc020136e:	c9e1                	beqz	a1,ffffffffc020143e <best_fit_init_memmap+0xd4>
    for (; p != base + n; p ++) {
ffffffffc0201370:	00259693          	slli	a3,a1,0x2
ffffffffc0201374:	96ae                	add	a3,a3,a1
ffffffffc0201376:	068e                	slli	a3,a3,0x3
ffffffffc0201378:	96aa                	add	a3,a3,a0
ffffffffc020137a:	87aa                	mv	a5,a0
ffffffffc020137c:	00d50f63          	beq	a0,a3,ffffffffc020139a <best_fit_init_memmap+0x30>
    return (((*(volatile unsigned long *)addr) >> nr) & 1);
ffffffffc0201380:	6798                	ld	a4,8(a5)
        assert(PageReserved(p));
ffffffffc0201382:	8b05                	andi	a4,a4,1
ffffffffc0201384:	cf49                	beqz	a4,ffffffffc020141e <best_fit_init_memmap+0xb4>
        p->flags = p->property = 0;
ffffffffc0201386:	0007a823          	sw	zero,16(a5)
ffffffffc020138a:	0007b423          	sd	zero,8(a5)
ffffffffc020138e:	0007a023          	sw	zero,0(a5)
    for (; p != base + n; p ++) {
ffffffffc0201392:	02878793          	addi	a5,a5,40
ffffffffc0201396:	fed795e3          	bne	a5,a3,ffffffffc0201380 <best_fit_init_memmap+0x16>
    base->property = n;
ffffffffc020139a:	2581                	sext.w	a1,a1
ffffffffc020139c:	c90c                	sw	a1,16(a0)
    __op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc020139e:	4789                	li	a5,2
ffffffffc02013a0:	00850713          	addi	a4,a0,8
ffffffffc02013a4:	40f7302f          	amoor.d	zero,a5,(a4)
    nr_free += n;
ffffffffc02013a8:	00005697          	auipc	a3,0x5
ffffffffc02013ac:	c6868693          	addi	a3,a3,-920 # ffffffffc0206010 <bffree_area>
ffffffffc02013b0:	4a98                	lw	a4,16(a3)
    return list->next == list;
ffffffffc02013b2:	669c                	ld	a5,8(a3)
        list_add(&free_list, &(base->page_link));
ffffffffc02013b4:	01850613          	addi	a2,a0,24
    nr_free += n;
ffffffffc02013b8:	9db9                	addw	a1,a1,a4
ffffffffc02013ba:	ca8c                	sw	a1,16(a3)
    if (list_empty(&free_list)) {
ffffffffc02013bc:	04d78a63          	beq	a5,a3,ffffffffc0201410 <best_fit_init_memmap+0xa6>
            struct Page* page = le2page(le, page_link);
ffffffffc02013c0:	fe878713          	addi	a4,a5,-24
ffffffffc02013c4:	0006b803          	ld	a6,0(a3)
    if (list_empty(&free_list)) {
ffffffffc02013c8:	4581                	li	a1,0
            if (base < page) {
ffffffffc02013ca:	00e56a63          	bltu	a0,a4,ffffffffc02013de <best_fit_init_memmap+0x74>
    return listelm->next;
ffffffffc02013ce:	6798                	ld	a4,8(a5)
            } else if (list_next(le) == &free_list) {
ffffffffc02013d0:	02d70263          	beq	a4,a3,ffffffffc02013f4 <best_fit_init_memmap+0x8a>
    for (; p != base + n; p ++) {
ffffffffc02013d4:	87ba                	mv	a5,a4
            struct Page* page = le2page(le, page_link);
ffffffffc02013d6:	fe878713          	addi	a4,a5,-24
            if (base < page) {
ffffffffc02013da:	fee57ae3          	bgeu	a0,a4,ffffffffc02013ce <best_fit_init_memmap+0x64>
ffffffffc02013de:	c199                	beqz	a1,ffffffffc02013e4 <best_fit_init_memmap+0x7a>
ffffffffc02013e0:	0106b023          	sd	a6,0(a3)
    __list_add(elm, listelm->prev, listelm);
ffffffffc02013e4:	6398                	ld	a4,0(a5)
}
ffffffffc02013e6:	60a2                	ld	ra,8(sp)
    prev->next = next->prev = elm;
ffffffffc02013e8:	e390                	sd	a2,0(a5)
ffffffffc02013ea:	e710                	sd	a2,8(a4)
    elm->next = next;
ffffffffc02013ec:	f11c                	sd	a5,32(a0)
    elm->prev = prev;
ffffffffc02013ee:	ed18                	sd	a4,24(a0)
ffffffffc02013f0:	0141                	addi	sp,sp,16
ffffffffc02013f2:	8082                	ret
    prev->next = next->prev = elm;
ffffffffc02013f4:	e790                	sd	a2,8(a5)
    elm->next = next;
ffffffffc02013f6:	f114                	sd	a3,32(a0)
    return listelm->next;
ffffffffc02013f8:	6798                	ld	a4,8(a5)
    elm->prev = prev;
ffffffffc02013fa:	ed1c                	sd	a5,24(a0)
        while ((le = list_next(le)) != &free_list) {
ffffffffc02013fc:	00d70663          	beq	a4,a3,ffffffffc0201408 <best_fit_init_memmap+0x9e>
    prev->next = next->prev = elm;
ffffffffc0201400:	8832                	mv	a6,a2
ffffffffc0201402:	4585                	li	a1,1
    for (; p != base + n; p ++) {
ffffffffc0201404:	87ba                	mv	a5,a4
ffffffffc0201406:	bfc1                	j	ffffffffc02013d6 <best_fit_init_memmap+0x6c>
}
ffffffffc0201408:	60a2                	ld	ra,8(sp)
ffffffffc020140a:	e290                	sd	a2,0(a3)
ffffffffc020140c:	0141                	addi	sp,sp,16
ffffffffc020140e:	8082                	ret
ffffffffc0201410:	60a2                	ld	ra,8(sp)
ffffffffc0201412:	e390                	sd	a2,0(a5)
ffffffffc0201414:	e790                	sd	a2,8(a5)
    elm->next = next;
ffffffffc0201416:	f11c                	sd	a5,32(a0)
    elm->prev = prev;
ffffffffc0201418:	ed1c                	sd	a5,24(a0)
ffffffffc020141a:	0141                	addi	sp,sp,16
ffffffffc020141c:	8082                	ret
        assert(PageReserved(p));
ffffffffc020141e:	00001697          	auipc	a3,0x1
ffffffffc0201422:	13268693          	addi	a3,a3,306 # ffffffffc0202550 <commands+0x920>
ffffffffc0201426:	00001617          	auipc	a2,0x1
ffffffffc020142a:	e1a60613          	addi	a2,a2,-486 # ffffffffc0202240 <commands+0x610>
ffffffffc020142e:	04a00593          	li	a1,74
ffffffffc0201432:	00001517          	auipc	a0,0x1
ffffffffc0201436:	e2650513          	addi	a0,a0,-474 # ffffffffc0202258 <commands+0x628>
ffffffffc020143a:	d01fe0ef          	jal	ra,ffffffffc020013a <__panic>
    assert(n > 0);
ffffffffc020143e:	00001697          	auipc	a3,0x1
ffffffffc0201442:	0e268693          	addi	a3,a3,226 # ffffffffc0202520 <commands+0x8f0>
ffffffffc0201446:	00001617          	auipc	a2,0x1
ffffffffc020144a:	dfa60613          	addi	a2,a2,-518 # ffffffffc0202240 <commands+0x610>
ffffffffc020144e:	04700593          	li	a1,71
ffffffffc0201452:	00001517          	auipc	a0,0x1
ffffffffc0201456:	e0650513          	addi	a0,a0,-506 # ffffffffc0202258 <commands+0x628>
ffffffffc020145a:	ce1fe0ef          	jal	ra,ffffffffc020013a <__panic>

ffffffffc020145e <strnlen>:
ffffffffc020145e:	4781                	li	a5,0
ffffffffc0201460:	e589                	bnez	a1,ffffffffc020146a <strnlen+0xc>
ffffffffc0201462:	a811                	j	ffffffffc0201476 <strnlen+0x18>
ffffffffc0201464:	0785                	addi	a5,a5,1
ffffffffc0201466:	00f58863          	beq	a1,a5,ffffffffc0201476 <strnlen+0x18>
ffffffffc020146a:	00f50733          	add	a4,a0,a5
ffffffffc020146e:	00074703          	lbu	a4,0(a4)
ffffffffc0201472:	fb6d                	bnez	a4,ffffffffc0201464 <strnlen+0x6>
ffffffffc0201474:	85be                	mv	a1,a5
ffffffffc0201476:	852e                	mv	a0,a1
ffffffffc0201478:	8082                	ret

ffffffffc020147a <strcmp>:
ffffffffc020147a:	00054783          	lbu	a5,0(a0)
ffffffffc020147e:	0005c703          	lbu	a4,0(a1)
ffffffffc0201482:	cb89                	beqz	a5,ffffffffc0201494 <strcmp+0x1a>
ffffffffc0201484:	0505                	addi	a0,a0,1
ffffffffc0201486:	0585                	addi	a1,a1,1
ffffffffc0201488:	fee789e3          	beq	a5,a4,ffffffffc020147a <strcmp>
ffffffffc020148c:	0007851b          	sext.w	a0,a5
ffffffffc0201490:	9d19                	subw	a0,a0,a4
ffffffffc0201492:	8082                	ret
ffffffffc0201494:	4501                	li	a0,0
ffffffffc0201496:	bfed                	j	ffffffffc0201490 <strcmp+0x16>

ffffffffc0201498 <strchr>:
ffffffffc0201498:	00054783          	lbu	a5,0(a0)
ffffffffc020149c:	c799                	beqz	a5,ffffffffc02014aa <strchr+0x12>
ffffffffc020149e:	00f58763          	beq	a1,a5,ffffffffc02014ac <strchr+0x14>
ffffffffc02014a2:	00154783          	lbu	a5,1(a0)
ffffffffc02014a6:	0505                	addi	a0,a0,1
ffffffffc02014a8:	fbfd                	bnez	a5,ffffffffc020149e <strchr+0x6>
ffffffffc02014aa:	4501                	li	a0,0
ffffffffc02014ac:	8082                	ret

ffffffffc02014ae <memset>:
ffffffffc02014ae:	ca01                	beqz	a2,ffffffffc02014be <memset+0x10>
ffffffffc02014b0:	962a                	add	a2,a2,a0
ffffffffc02014b2:	87aa                	mv	a5,a0
ffffffffc02014b4:	0785                	addi	a5,a5,1
ffffffffc02014b6:	feb78fa3          	sb	a1,-1(a5)
ffffffffc02014ba:	fec79de3          	bne	a5,a2,ffffffffc02014b4 <memset+0x6>
ffffffffc02014be:	8082                	ret

ffffffffc02014c0 <printnum>:
ffffffffc02014c0:	02069813          	slli	a6,a3,0x20
ffffffffc02014c4:	7179                	addi	sp,sp,-48
ffffffffc02014c6:	02085813          	srli	a6,a6,0x20
ffffffffc02014ca:	e052                	sd	s4,0(sp)
ffffffffc02014cc:	03067a33          	remu	s4,a2,a6
ffffffffc02014d0:	f022                	sd	s0,32(sp)
ffffffffc02014d2:	ec26                	sd	s1,24(sp)
ffffffffc02014d4:	e84a                	sd	s2,16(sp)
ffffffffc02014d6:	f406                	sd	ra,40(sp)
ffffffffc02014d8:	e44e                	sd	s3,8(sp)
ffffffffc02014da:	84aa                	mv	s1,a0
ffffffffc02014dc:	892e                	mv	s2,a1
ffffffffc02014de:	fff7041b          	addiw	s0,a4,-1
ffffffffc02014e2:	2a01                	sext.w	s4,s4
ffffffffc02014e4:	03067e63          	bgeu	a2,a6,ffffffffc0201520 <printnum+0x60>
ffffffffc02014e8:	89be                	mv	s3,a5
ffffffffc02014ea:	00805763          	blez	s0,ffffffffc02014f8 <printnum+0x38>
ffffffffc02014ee:	347d                	addiw	s0,s0,-1
ffffffffc02014f0:	85ca                	mv	a1,s2
ffffffffc02014f2:	854e                	mv	a0,s3
ffffffffc02014f4:	9482                	jalr	s1
ffffffffc02014f6:	fc65                	bnez	s0,ffffffffc02014ee <printnum+0x2e>
ffffffffc02014f8:	1a02                	slli	s4,s4,0x20
ffffffffc02014fa:	00001797          	auipc	a5,0x1
ffffffffc02014fe:	0b678793          	addi	a5,a5,182 # ffffffffc02025b0 <best_fit_pmm_manager+0x38>
ffffffffc0201502:	020a5a13          	srli	s4,s4,0x20
ffffffffc0201506:	9a3e                	add	s4,s4,a5
ffffffffc0201508:	7402                	ld	s0,32(sp)
ffffffffc020150a:	000a4503          	lbu	a0,0(s4)
ffffffffc020150e:	70a2                	ld	ra,40(sp)
ffffffffc0201510:	69a2                	ld	s3,8(sp)
ffffffffc0201512:	6a02                	ld	s4,0(sp)
ffffffffc0201514:	85ca                	mv	a1,s2
ffffffffc0201516:	87a6                	mv	a5,s1
ffffffffc0201518:	6942                	ld	s2,16(sp)
ffffffffc020151a:	64e2                	ld	s1,24(sp)
ffffffffc020151c:	6145                	addi	sp,sp,48
ffffffffc020151e:	8782                	jr	a5
ffffffffc0201520:	03065633          	divu	a2,a2,a6
ffffffffc0201524:	8722                	mv	a4,s0
ffffffffc0201526:	f9bff0ef          	jal	ra,ffffffffc02014c0 <printnum>
ffffffffc020152a:	b7f9                	j	ffffffffc02014f8 <printnum+0x38>

ffffffffc020152c <vprintfmt>:
ffffffffc020152c:	7119                	addi	sp,sp,-128
ffffffffc020152e:	f4a6                	sd	s1,104(sp)
ffffffffc0201530:	f0ca                	sd	s2,96(sp)
ffffffffc0201532:	ecce                	sd	s3,88(sp)
ffffffffc0201534:	e8d2                	sd	s4,80(sp)
ffffffffc0201536:	e4d6                	sd	s5,72(sp)
ffffffffc0201538:	e0da                	sd	s6,64(sp)
ffffffffc020153a:	fc5e                	sd	s7,56(sp)
ffffffffc020153c:	f06a                	sd	s10,32(sp)
ffffffffc020153e:	fc86                	sd	ra,120(sp)
ffffffffc0201540:	f8a2                	sd	s0,112(sp)
ffffffffc0201542:	f862                	sd	s8,48(sp)
ffffffffc0201544:	f466                	sd	s9,40(sp)
ffffffffc0201546:	ec6e                	sd	s11,24(sp)
ffffffffc0201548:	892a                	mv	s2,a0
ffffffffc020154a:	84ae                	mv	s1,a1
ffffffffc020154c:	8d32                	mv	s10,a2
ffffffffc020154e:	8a36                	mv	s4,a3
ffffffffc0201550:	02500993          	li	s3,37
ffffffffc0201554:	5b7d                	li	s6,-1
ffffffffc0201556:	00001a97          	auipc	s5,0x1
ffffffffc020155a:	08ea8a93          	addi	s5,s5,142 # ffffffffc02025e4 <best_fit_pmm_manager+0x6c>
ffffffffc020155e:	00001b97          	auipc	s7,0x1
ffffffffc0201562:	262b8b93          	addi	s7,s7,610 # ffffffffc02027c0 <error_string>
ffffffffc0201566:	000d4503          	lbu	a0,0(s10)
ffffffffc020156a:	001d0413          	addi	s0,s10,1
ffffffffc020156e:	01350a63          	beq	a0,s3,ffffffffc0201582 <vprintfmt+0x56>
ffffffffc0201572:	c121                	beqz	a0,ffffffffc02015b2 <vprintfmt+0x86>
ffffffffc0201574:	85a6                	mv	a1,s1
ffffffffc0201576:	0405                	addi	s0,s0,1
ffffffffc0201578:	9902                	jalr	s2
ffffffffc020157a:	fff44503          	lbu	a0,-1(s0)
ffffffffc020157e:	ff351ae3          	bne	a0,s3,ffffffffc0201572 <vprintfmt+0x46>
ffffffffc0201582:	00044603          	lbu	a2,0(s0)
ffffffffc0201586:	02000793          	li	a5,32
ffffffffc020158a:	4c81                	li	s9,0
ffffffffc020158c:	4881                	li	a7,0
ffffffffc020158e:	5c7d                	li	s8,-1
ffffffffc0201590:	5dfd                	li	s11,-1
ffffffffc0201592:	05500513          	li	a0,85
ffffffffc0201596:	4825                	li	a6,9
ffffffffc0201598:	fdd6059b          	addiw	a1,a2,-35
ffffffffc020159c:	0ff5f593          	zext.b	a1,a1
ffffffffc02015a0:	00140d13          	addi	s10,s0,1
ffffffffc02015a4:	04b56263          	bltu	a0,a1,ffffffffc02015e8 <vprintfmt+0xbc>
ffffffffc02015a8:	058a                	slli	a1,a1,0x2
ffffffffc02015aa:	95d6                	add	a1,a1,s5
ffffffffc02015ac:	4194                	lw	a3,0(a1)
ffffffffc02015ae:	96d6                	add	a3,a3,s5
ffffffffc02015b0:	8682                	jr	a3
ffffffffc02015b2:	70e6                	ld	ra,120(sp)
ffffffffc02015b4:	7446                	ld	s0,112(sp)
ffffffffc02015b6:	74a6                	ld	s1,104(sp)
ffffffffc02015b8:	7906                	ld	s2,96(sp)
ffffffffc02015ba:	69e6                	ld	s3,88(sp)
ffffffffc02015bc:	6a46                	ld	s4,80(sp)
ffffffffc02015be:	6aa6                	ld	s5,72(sp)
ffffffffc02015c0:	6b06                	ld	s6,64(sp)
ffffffffc02015c2:	7be2                	ld	s7,56(sp)
ffffffffc02015c4:	7c42                	ld	s8,48(sp)
ffffffffc02015c6:	7ca2                	ld	s9,40(sp)
ffffffffc02015c8:	7d02                	ld	s10,32(sp)
ffffffffc02015ca:	6de2                	ld	s11,24(sp)
ffffffffc02015cc:	6109                	addi	sp,sp,128
ffffffffc02015ce:	8082                	ret
ffffffffc02015d0:	87b2                	mv	a5,a2
ffffffffc02015d2:	00144603          	lbu	a2,1(s0)
ffffffffc02015d6:	846a                	mv	s0,s10
ffffffffc02015d8:	00140d13          	addi	s10,s0,1
ffffffffc02015dc:	fdd6059b          	addiw	a1,a2,-35
ffffffffc02015e0:	0ff5f593          	zext.b	a1,a1
ffffffffc02015e4:	fcb572e3          	bgeu	a0,a1,ffffffffc02015a8 <vprintfmt+0x7c>
ffffffffc02015e8:	85a6                	mv	a1,s1
ffffffffc02015ea:	02500513          	li	a0,37
ffffffffc02015ee:	9902                	jalr	s2
ffffffffc02015f0:	fff44783          	lbu	a5,-1(s0)
ffffffffc02015f4:	8d22                	mv	s10,s0
ffffffffc02015f6:	f73788e3          	beq	a5,s3,ffffffffc0201566 <vprintfmt+0x3a>
ffffffffc02015fa:	ffed4783          	lbu	a5,-2(s10)
ffffffffc02015fe:	1d7d                	addi	s10,s10,-1
ffffffffc0201600:	ff379de3          	bne	a5,s3,ffffffffc02015fa <vprintfmt+0xce>
ffffffffc0201604:	b78d                	j	ffffffffc0201566 <vprintfmt+0x3a>
ffffffffc0201606:	fd060c1b          	addiw	s8,a2,-48
ffffffffc020160a:	00144603          	lbu	a2,1(s0)
ffffffffc020160e:	846a                	mv	s0,s10
ffffffffc0201610:	fd06069b          	addiw	a3,a2,-48
ffffffffc0201614:	0006059b          	sext.w	a1,a2
ffffffffc0201618:	02d86463          	bltu	a6,a3,ffffffffc0201640 <vprintfmt+0x114>
ffffffffc020161c:	00144603          	lbu	a2,1(s0)
ffffffffc0201620:	002c169b          	slliw	a3,s8,0x2
ffffffffc0201624:	0186873b          	addw	a4,a3,s8
ffffffffc0201628:	0017171b          	slliw	a4,a4,0x1
ffffffffc020162c:	9f2d                	addw	a4,a4,a1
ffffffffc020162e:	fd06069b          	addiw	a3,a2,-48
ffffffffc0201632:	0405                	addi	s0,s0,1
ffffffffc0201634:	fd070c1b          	addiw	s8,a4,-48
ffffffffc0201638:	0006059b          	sext.w	a1,a2
ffffffffc020163c:	fed870e3          	bgeu	a6,a3,ffffffffc020161c <vprintfmt+0xf0>
ffffffffc0201640:	f40ddce3          	bgez	s11,ffffffffc0201598 <vprintfmt+0x6c>
ffffffffc0201644:	8de2                	mv	s11,s8
ffffffffc0201646:	5c7d                	li	s8,-1
ffffffffc0201648:	bf81                	j	ffffffffc0201598 <vprintfmt+0x6c>
ffffffffc020164a:	fffdc693          	not	a3,s11
ffffffffc020164e:	96fd                	srai	a3,a3,0x3f
ffffffffc0201650:	00ddfdb3          	and	s11,s11,a3
ffffffffc0201654:	00144603          	lbu	a2,1(s0)
ffffffffc0201658:	2d81                	sext.w	s11,s11
ffffffffc020165a:	846a                	mv	s0,s10
ffffffffc020165c:	bf35                	j	ffffffffc0201598 <vprintfmt+0x6c>
ffffffffc020165e:	000a2c03          	lw	s8,0(s4)
ffffffffc0201662:	00144603          	lbu	a2,1(s0)
ffffffffc0201666:	0a21                	addi	s4,s4,8
ffffffffc0201668:	846a                	mv	s0,s10
ffffffffc020166a:	bfd9                	j	ffffffffc0201640 <vprintfmt+0x114>
ffffffffc020166c:	4705                	li	a4,1
ffffffffc020166e:	008a0593          	addi	a1,s4,8
ffffffffc0201672:	01174463          	blt	a4,a7,ffffffffc020167a <vprintfmt+0x14e>
ffffffffc0201676:	1a088e63          	beqz	a7,ffffffffc0201832 <vprintfmt+0x306>
ffffffffc020167a:	000a3603          	ld	a2,0(s4)
ffffffffc020167e:	46c1                	li	a3,16
ffffffffc0201680:	8a2e                	mv	s4,a1
ffffffffc0201682:	2781                	sext.w	a5,a5
ffffffffc0201684:	876e                	mv	a4,s11
ffffffffc0201686:	85a6                	mv	a1,s1
ffffffffc0201688:	854a                	mv	a0,s2
ffffffffc020168a:	e37ff0ef          	jal	ra,ffffffffc02014c0 <printnum>
ffffffffc020168e:	bde1                	j	ffffffffc0201566 <vprintfmt+0x3a>
ffffffffc0201690:	000a2503          	lw	a0,0(s4)
ffffffffc0201694:	85a6                	mv	a1,s1
ffffffffc0201696:	0a21                	addi	s4,s4,8
ffffffffc0201698:	9902                	jalr	s2
ffffffffc020169a:	b5f1                	j	ffffffffc0201566 <vprintfmt+0x3a>
ffffffffc020169c:	4705                	li	a4,1
ffffffffc020169e:	008a0593          	addi	a1,s4,8
ffffffffc02016a2:	01174463          	blt	a4,a7,ffffffffc02016aa <vprintfmt+0x17e>
ffffffffc02016a6:	18088163          	beqz	a7,ffffffffc0201828 <vprintfmt+0x2fc>
ffffffffc02016aa:	000a3603          	ld	a2,0(s4)
ffffffffc02016ae:	46a9                	li	a3,10
ffffffffc02016b0:	8a2e                	mv	s4,a1
ffffffffc02016b2:	bfc1                	j	ffffffffc0201682 <vprintfmt+0x156>
ffffffffc02016b4:	00144603          	lbu	a2,1(s0)
ffffffffc02016b8:	4c85                	li	s9,1
ffffffffc02016ba:	846a                	mv	s0,s10
ffffffffc02016bc:	bdf1                	j	ffffffffc0201598 <vprintfmt+0x6c>
ffffffffc02016be:	85a6                	mv	a1,s1
ffffffffc02016c0:	02500513          	li	a0,37
ffffffffc02016c4:	9902                	jalr	s2
ffffffffc02016c6:	b545                	j	ffffffffc0201566 <vprintfmt+0x3a>
ffffffffc02016c8:	00144603          	lbu	a2,1(s0)
ffffffffc02016cc:	2885                	addiw	a7,a7,1
ffffffffc02016ce:	846a                	mv	s0,s10
ffffffffc02016d0:	b5e1                	j	ffffffffc0201598 <vprintfmt+0x6c>
ffffffffc02016d2:	4705                	li	a4,1
ffffffffc02016d4:	008a0593          	addi	a1,s4,8
ffffffffc02016d8:	01174463          	blt	a4,a7,ffffffffc02016e0 <vprintfmt+0x1b4>
ffffffffc02016dc:	14088163          	beqz	a7,ffffffffc020181e <vprintfmt+0x2f2>
ffffffffc02016e0:	000a3603          	ld	a2,0(s4)
ffffffffc02016e4:	46a1                	li	a3,8
ffffffffc02016e6:	8a2e                	mv	s4,a1
ffffffffc02016e8:	bf69                	j	ffffffffc0201682 <vprintfmt+0x156>
ffffffffc02016ea:	03000513          	li	a0,48
ffffffffc02016ee:	85a6                	mv	a1,s1
ffffffffc02016f0:	e03e                	sd	a5,0(sp)
ffffffffc02016f2:	9902                	jalr	s2
ffffffffc02016f4:	85a6                	mv	a1,s1
ffffffffc02016f6:	07800513          	li	a0,120
ffffffffc02016fa:	9902                	jalr	s2
ffffffffc02016fc:	0a21                	addi	s4,s4,8
ffffffffc02016fe:	6782                	ld	a5,0(sp)
ffffffffc0201700:	46c1                	li	a3,16
ffffffffc0201702:	ff8a3603          	ld	a2,-8(s4)
ffffffffc0201706:	bfb5                	j	ffffffffc0201682 <vprintfmt+0x156>
ffffffffc0201708:	000a3403          	ld	s0,0(s4)
ffffffffc020170c:	008a0713          	addi	a4,s4,8
ffffffffc0201710:	e03a                	sd	a4,0(sp)
ffffffffc0201712:	14040263          	beqz	s0,ffffffffc0201856 <vprintfmt+0x32a>
ffffffffc0201716:	0fb05763          	blez	s11,ffffffffc0201804 <vprintfmt+0x2d8>
ffffffffc020171a:	02d00693          	li	a3,45
ffffffffc020171e:	0cd79163          	bne	a5,a3,ffffffffc02017e0 <vprintfmt+0x2b4>
ffffffffc0201722:	00044783          	lbu	a5,0(s0)
ffffffffc0201726:	0007851b          	sext.w	a0,a5
ffffffffc020172a:	cf85                	beqz	a5,ffffffffc0201762 <vprintfmt+0x236>
ffffffffc020172c:	00140a13          	addi	s4,s0,1
ffffffffc0201730:	05e00413          	li	s0,94
ffffffffc0201734:	000c4563          	bltz	s8,ffffffffc020173e <vprintfmt+0x212>
ffffffffc0201738:	3c7d                	addiw	s8,s8,-1
ffffffffc020173a:	036c0263          	beq	s8,s6,ffffffffc020175e <vprintfmt+0x232>
ffffffffc020173e:	85a6                	mv	a1,s1
ffffffffc0201740:	0e0c8e63          	beqz	s9,ffffffffc020183c <vprintfmt+0x310>
ffffffffc0201744:	3781                	addiw	a5,a5,-32
ffffffffc0201746:	0ef47b63          	bgeu	s0,a5,ffffffffc020183c <vprintfmt+0x310>
ffffffffc020174a:	03f00513          	li	a0,63
ffffffffc020174e:	9902                	jalr	s2
ffffffffc0201750:	000a4783          	lbu	a5,0(s4)
ffffffffc0201754:	3dfd                	addiw	s11,s11,-1
ffffffffc0201756:	0a05                	addi	s4,s4,1
ffffffffc0201758:	0007851b          	sext.w	a0,a5
ffffffffc020175c:	ffe1                	bnez	a5,ffffffffc0201734 <vprintfmt+0x208>
ffffffffc020175e:	01b05963          	blez	s11,ffffffffc0201770 <vprintfmt+0x244>
ffffffffc0201762:	3dfd                	addiw	s11,s11,-1
ffffffffc0201764:	85a6                	mv	a1,s1
ffffffffc0201766:	02000513          	li	a0,32
ffffffffc020176a:	9902                	jalr	s2
ffffffffc020176c:	fe0d9be3          	bnez	s11,ffffffffc0201762 <vprintfmt+0x236>
ffffffffc0201770:	6a02                	ld	s4,0(sp)
ffffffffc0201772:	bbd5                	j	ffffffffc0201566 <vprintfmt+0x3a>
ffffffffc0201774:	4705                	li	a4,1
ffffffffc0201776:	008a0c93          	addi	s9,s4,8
ffffffffc020177a:	01174463          	blt	a4,a7,ffffffffc0201782 <vprintfmt+0x256>
ffffffffc020177e:	08088d63          	beqz	a7,ffffffffc0201818 <vprintfmt+0x2ec>
ffffffffc0201782:	000a3403          	ld	s0,0(s4)
ffffffffc0201786:	0a044d63          	bltz	s0,ffffffffc0201840 <vprintfmt+0x314>
ffffffffc020178a:	8622                	mv	a2,s0
ffffffffc020178c:	8a66                	mv	s4,s9
ffffffffc020178e:	46a9                	li	a3,10
ffffffffc0201790:	bdcd                	j	ffffffffc0201682 <vprintfmt+0x156>
ffffffffc0201792:	000a2783          	lw	a5,0(s4)
ffffffffc0201796:	4719                	li	a4,6
ffffffffc0201798:	0a21                	addi	s4,s4,8
ffffffffc020179a:	41f7d69b          	sraiw	a3,a5,0x1f
ffffffffc020179e:	8fb5                	xor	a5,a5,a3
ffffffffc02017a0:	40d786bb          	subw	a3,a5,a3
ffffffffc02017a4:	02d74163          	blt	a4,a3,ffffffffc02017c6 <vprintfmt+0x29a>
ffffffffc02017a8:	00369793          	slli	a5,a3,0x3
ffffffffc02017ac:	97de                	add	a5,a5,s7
ffffffffc02017ae:	639c                	ld	a5,0(a5)
ffffffffc02017b0:	cb99                	beqz	a5,ffffffffc02017c6 <vprintfmt+0x29a>
ffffffffc02017b2:	86be                	mv	a3,a5
ffffffffc02017b4:	00001617          	auipc	a2,0x1
ffffffffc02017b8:	e2c60613          	addi	a2,a2,-468 # ffffffffc02025e0 <best_fit_pmm_manager+0x68>
ffffffffc02017bc:	85a6                	mv	a1,s1
ffffffffc02017be:	854a                	mv	a0,s2
ffffffffc02017c0:	0ce000ef          	jal	ra,ffffffffc020188e <printfmt>
ffffffffc02017c4:	b34d                	j	ffffffffc0201566 <vprintfmt+0x3a>
ffffffffc02017c6:	00001617          	auipc	a2,0x1
ffffffffc02017ca:	e0a60613          	addi	a2,a2,-502 # ffffffffc02025d0 <best_fit_pmm_manager+0x58>
ffffffffc02017ce:	85a6                	mv	a1,s1
ffffffffc02017d0:	854a                	mv	a0,s2
ffffffffc02017d2:	0bc000ef          	jal	ra,ffffffffc020188e <printfmt>
ffffffffc02017d6:	bb41                	j	ffffffffc0201566 <vprintfmt+0x3a>
ffffffffc02017d8:	00001417          	auipc	s0,0x1
ffffffffc02017dc:	df040413          	addi	s0,s0,-528 # ffffffffc02025c8 <best_fit_pmm_manager+0x50>
ffffffffc02017e0:	85e2                	mv	a1,s8
ffffffffc02017e2:	8522                	mv	a0,s0
ffffffffc02017e4:	e43e                	sd	a5,8(sp)
ffffffffc02017e6:	c79ff0ef          	jal	ra,ffffffffc020145e <strnlen>
ffffffffc02017ea:	40ad8dbb          	subw	s11,s11,a0
ffffffffc02017ee:	01b05b63          	blez	s11,ffffffffc0201804 <vprintfmt+0x2d8>
ffffffffc02017f2:	67a2                	ld	a5,8(sp)
ffffffffc02017f4:	00078a1b          	sext.w	s4,a5
ffffffffc02017f8:	3dfd                	addiw	s11,s11,-1
ffffffffc02017fa:	85a6                	mv	a1,s1
ffffffffc02017fc:	8552                	mv	a0,s4
ffffffffc02017fe:	9902                	jalr	s2
ffffffffc0201800:	fe0d9ce3          	bnez	s11,ffffffffc02017f8 <vprintfmt+0x2cc>
ffffffffc0201804:	00044783          	lbu	a5,0(s0)
ffffffffc0201808:	00140a13          	addi	s4,s0,1
ffffffffc020180c:	0007851b          	sext.w	a0,a5
ffffffffc0201810:	d3a5                	beqz	a5,ffffffffc0201770 <vprintfmt+0x244>
ffffffffc0201812:	05e00413          	li	s0,94
ffffffffc0201816:	bf39                	j	ffffffffc0201734 <vprintfmt+0x208>
ffffffffc0201818:	000a2403          	lw	s0,0(s4)
ffffffffc020181c:	b7ad                	j	ffffffffc0201786 <vprintfmt+0x25a>
ffffffffc020181e:	000a6603          	lwu	a2,0(s4)
ffffffffc0201822:	46a1                	li	a3,8
ffffffffc0201824:	8a2e                	mv	s4,a1
ffffffffc0201826:	bdb1                	j	ffffffffc0201682 <vprintfmt+0x156>
ffffffffc0201828:	000a6603          	lwu	a2,0(s4)
ffffffffc020182c:	46a9                	li	a3,10
ffffffffc020182e:	8a2e                	mv	s4,a1
ffffffffc0201830:	bd89                	j	ffffffffc0201682 <vprintfmt+0x156>
ffffffffc0201832:	000a6603          	lwu	a2,0(s4)
ffffffffc0201836:	46c1                	li	a3,16
ffffffffc0201838:	8a2e                	mv	s4,a1
ffffffffc020183a:	b5a1                	j	ffffffffc0201682 <vprintfmt+0x156>
ffffffffc020183c:	9902                	jalr	s2
ffffffffc020183e:	bf09                	j	ffffffffc0201750 <vprintfmt+0x224>
ffffffffc0201840:	85a6                	mv	a1,s1
ffffffffc0201842:	02d00513          	li	a0,45
ffffffffc0201846:	e03e                	sd	a5,0(sp)
ffffffffc0201848:	9902                	jalr	s2
ffffffffc020184a:	6782                	ld	a5,0(sp)
ffffffffc020184c:	8a66                	mv	s4,s9
ffffffffc020184e:	40800633          	neg	a2,s0
ffffffffc0201852:	46a9                	li	a3,10
ffffffffc0201854:	b53d                	j	ffffffffc0201682 <vprintfmt+0x156>
ffffffffc0201856:	03b05163          	blez	s11,ffffffffc0201878 <vprintfmt+0x34c>
ffffffffc020185a:	02d00693          	li	a3,45
ffffffffc020185e:	f6d79de3          	bne	a5,a3,ffffffffc02017d8 <vprintfmt+0x2ac>
ffffffffc0201862:	00001417          	auipc	s0,0x1
ffffffffc0201866:	d6640413          	addi	s0,s0,-666 # ffffffffc02025c8 <best_fit_pmm_manager+0x50>
ffffffffc020186a:	02800793          	li	a5,40
ffffffffc020186e:	02800513          	li	a0,40
ffffffffc0201872:	00140a13          	addi	s4,s0,1
ffffffffc0201876:	bd6d                	j	ffffffffc0201730 <vprintfmt+0x204>
ffffffffc0201878:	00001a17          	auipc	s4,0x1
ffffffffc020187c:	d51a0a13          	addi	s4,s4,-687 # ffffffffc02025c9 <best_fit_pmm_manager+0x51>
ffffffffc0201880:	02800513          	li	a0,40
ffffffffc0201884:	02800793          	li	a5,40
ffffffffc0201888:	05e00413          	li	s0,94
ffffffffc020188c:	b565                	j	ffffffffc0201734 <vprintfmt+0x208>

ffffffffc020188e <printfmt>:
ffffffffc020188e:	715d                	addi	sp,sp,-80
ffffffffc0201890:	02810313          	addi	t1,sp,40
ffffffffc0201894:	f436                	sd	a3,40(sp)
ffffffffc0201896:	869a                	mv	a3,t1
ffffffffc0201898:	ec06                	sd	ra,24(sp)
ffffffffc020189a:	f83a                	sd	a4,48(sp)
ffffffffc020189c:	fc3e                	sd	a5,56(sp)
ffffffffc020189e:	e0c2                	sd	a6,64(sp)
ffffffffc02018a0:	e4c6                	sd	a7,72(sp)
ffffffffc02018a2:	e41a                	sd	t1,8(sp)
ffffffffc02018a4:	c89ff0ef          	jal	ra,ffffffffc020152c <vprintfmt>
ffffffffc02018a8:	60e2                	ld	ra,24(sp)
ffffffffc02018aa:	6161                	addi	sp,sp,80
ffffffffc02018ac:	8082                	ret

ffffffffc02018ae <sbi_console_putchar>:
ffffffffc02018ae:	4781                	li	a5,0
ffffffffc02018b0:	00004717          	auipc	a4,0x4
ffffffffc02018b4:	75873703          	ld	a4,1880(a4) # ffffffffc0206008 <SBI_CONSOLE_PUTCHAR>
ffffffffc02018b8:	88ba                	mv	a7,a4
ffffffffc02018ba:	852a                	mv	a0,a0
ffffffffc02018bc:	85be                	mv	a1,a5
ffffffffc02018be:	863e                	mv	a2,a5
ffffffffc02018c0:	00000073          	ecall
ffffffffc02018c4:	87aa                	mv	a5,a0
ffffffffc02018c6:	8082                	ret

ffffffffc02018c8 <sbi_set_timer>:
ffffffffc02018c8:	4781                	li	a5,0
ffffffffc02018ca:	00005717          	auipc	a4,0x5
ffffffffc02018ce:	b9e73703          	ld	a4,-1122(a4) # ffffffffc0206468 <SBI_SET_TIMER>
ffffffffc02018d2:	88ba                	mv	a7,a4
ffffffffc02018d4:	852a                	mv	a0,a0
ffffffffc02018d6:	85be                	mv	a1,a5
ffffffffc02018d8:	863e                	mv	a2,a5
ffffffffc02018da:	00000073          	ecall
ffffffffc02018de:	87aa                	mv	a5,a0
ffffffffc02018e0:	8082                	ret

ffffffffc02018e2 <sbi_console_getchar>:
ffffffffc02018e2:	4501                	li	a0,0
ffffffffc02018e4:	00004797          	auipc	a5,0x4
ffffffffc02018e8:	71c7b783          	ld	a5,1820(a5) # ffffffffc0206000 <SBI_CONSOLE_GETCHAR>
ffffffffc02018ec:	88be                	mv	a7,a5
ffffffffc02018ee:	852a                	mv	a0,a0
ffffffffc02018f0:	85aa                	mv	a1,a0
ffffffffc02018f2:	862a                	mv	a2,a0
ffffffffc02018f4:	00000073          	ecall
ffffffffc02018f8:	852a                	mv	a0,a0
ffffffffc02018fa:	2501                	sext.w	a0,a0
ffffffffc02018fc:	8082                	ret

ffffffffc02018fe <readline>:
ffffffffc02018fe:	715d                	addi	sp,sp,-80
ffffffffc0201900:	e486                	sd	ra,72(sp)
ffffffffc0201902:	e0a6                	sd	s1,64(sp)
ffffffffc0201904:	fc4a                	sd	s2,56(sp)
ffffffffc0201906:	f84e                	sd	s3,48(sp)
ffffffffc0201908:	f452                	sd	s4,40(sp)
ffffffffc020190a:	f056                	sd	s5,32(sp)
ffffffffc020190c:	ec5a                	sd	s6,24(sp)
ffffffffc020190e:	e85e                	sd	s7,16(sp)
ffffffffc0201910:	c901                	beqz	a0,ffffffffc0201920 <readline+0x22>
ffffffffc0201912:	85aa                	mv	a1,a0
ffffffffc0201914:	00001517          	auipc	a0,0x1
ffffffffc0201918:	ccc50513          	addi	a0,a0,-820 # ffffffffc02025e0 <best_fit_pmm_manager+0x68>
ffffffffc020191c:	f96fe0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc0201920:	4481                	li	s1,0
ffffffffc0201922:	497d                	li	s2,31
ffffffffc0201924:	49a1                	li	s3,8
ffffffffc0201926:	4aa9                	li	s5,10
ffffffffc0201928:	4b35                	li	s6,13
ffffffffc020192a:	00004b97          	auipc	s7,0x4
ffffffffc020192e:	6feb8b93          	addi	s7,s7,1790 # ffffffffc0206028 <buf>
ffffffffc0201932:	3fe00a13          	li	s4,1022
ffffffffc0201936:	ff4fe0ef          	jal	ra,ffffffffc020012a <getchar>
ffffffffc020193a:	00054a63          	bltz	a0,ffffffffc020194e <readline+0x50>
ffffffffc020193e:	00a95a63          	bge	s2,a0,ffffffffc0201952 <readline+0x54>
ffffffffc0201942:	029a5263          	bge	s4,s1,ffffffffc0201966 <readline+0x68>
ffffffffc0201946:	fe4fe0ef          	jal	ra,ffffffffc020012a <getchar>
ffffffffc020194a:	fe055ae3          	bgez	a0,ffffffffc020193e <readline+0x40>
ffffffffc020194e:	4501                	li	a0,0
ffffffffc0201950:	a091                	j	ffffffffc0201994 <readline+0x96>
ffffffffc0201952:	03351463          	bne	a0,s3,ffffffffc020197a <readline+0x7c>
ffffffffc0201956:	e8a9                	bnez	s1,ffffffffc02019a8 <readline+0xaa>
ffffffffc0201958:	fd2fe0ef          	jal	ra,ffffffffc020012a <getchar>
ffffffffc020195c:	fe0549e3          	bltz	a0,ffffffffc020194e <readline+0x50>
ffffffffc0201960:	fea959e3          	bge	s2,a0,ffffffffc0201952 <readline+0x54>
ffffffffc0201964:	4481                	li	s1,0
ffffffffc0201966:	e42a                	sd	a0,8(sp)
ffffffffc0201968:	f80fe0ef          	jal	ra,ffffffffc02000e8 <cputchar>
ffffffffc020196c:	6522                	ld	a0,8(sp)
ffffffffc020196e:	009b87b3          	add	a5,s7,s1
ffffffffc0201972:	2485                	addiw	s1,s1,1
ffffffffc0201974:	00a78023          	sb	a0,0(a5)
ffffffffc0201978:	bf7d                	j	ffffffffc0201936 <readline+0x38>
ffffffffc020197a:	01550463          	beq	a0,s5,ffffffffc0201982 <readline+0x84>
ffffffffc020197e:	fb651ce3          	bne	a0,s6,ffffffffc0201936 <readline+0x38>
ffffffffc0201982:	f66fe0ef          	jal	ra,ffffffffc02000e8 <cputchar>
ffffffffc0201986:	00004517          	auipc	a0,0x4
ffffffffc020198a:	6a250513          	addi	a0,a0,1698 # ffffffffc0206028 <buf>
ffffffffc020198e:	94aa                	add	s1,s1,a0
ffffffffc0201990:	00048023          	sb	zero,0(s1)
ffffffffc0201994:	60a6                	ld	ra,72(sp)
ffffffffc0201996:	6486                	ld	s1,64(sp)
ffffffffc0201998:	7962                	ld	s2,56(sp)
ffffffffc020199a:	79c2                	ld	s3,48(sp)
ffffffffc020199c:	7a22                	ld	s4,40(sp)
ffffffffc020199e:	7a82                	ld	s5,32(sp)
ffffffffc02019a0:	6b62                	ld	s6,24(sp)
ffffffffc02019a2:	6bc2                	ld	s7,16(sp)
ffffffffc02019a4:	6161                	addi	sp,sp,80
ffffffffc02019a6:	8082                	ret
ffffffffc02019a8:	4521                	li	a0,8
ffffffffc02019aa:	f3efe0ef          	jal	ra,ffffffffc02000e8 <cputchar>
ffffffffc02019ae:	34fd                	addiw	s1,s1,-1
ffffffffc02019b0:	b759                	j	ffffffffc0201936 <readline+0x38>
