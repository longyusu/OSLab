
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
ffffffffc0200036:	fde50513          	addi	a0,a0,-34 # ffffffffc0206010 <bsfree_area>
ffffffffc020003a:	00006617          	auipc	a2,0x6
ffffffffc020003e:	44e60613          	addi	a2,a2,1102 # ffffffffc0206488 <end>
ffffffffc0200042:	1141                	addi	sp,sp,-16
ffffffffc0200044:	8e09                	sub	a2,a2,a0
ffffffffc0200046:	4581                	li	a1,0
ffffffffc0200048:	e406                	sd	ra,8(sp)
ffffffffc020004a:	3ba010ef          	jal	ra,ffffffffc0201404 <memset>
ffffffffc020004e:	3fc000ef          	jal	ra,ffffffffc020044a <cons_init>
ffffffffc0200052:	00002517          	auipc	a0,0x2
ffffffffc0200056:	8b650513          	addi	a0,a0,-1866 # ffffffffc0201908 <etext>
ffffffffc020005a:	090000ef          	jal	ra,ffffffffc02000ea <cputs>
ffffffffc020005e:	138000ef          	jal	ra,ffffffffc0200196 <print_kerninfo>
ffffffffc0200062:	402000ef          	jal	ra,ffffffffc0200464 <idt_init>
ffffffffc0200066:	1a2010ef          	jal	ra,ffffffffc0201208 <pmm_init>
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
ffffffffc02000a6:	3dc010ef          	jal	ra,ffffffffc0201482 <vprintfmt>
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
ffffffffc02000dc:	3a6010ef          	jal	ra,ffffffffc0201482 <vprintfmt>
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
ffffffffc0200168:	00001517          	auipc	a0,0x1
ffffffffc020016c:	7c050513          	addi	a0,a0,1984 # ffffffffc0201928 <etext+0x20>
ffffffffc0200170:	e43e                	sd	a5,8(sp)
ffffffffc0200172:	f41ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc0200176:	65a2                	ld	a1,8(sp)
ffffffffc0200178:	8522                	mv	a0,s0
ffffffffc020017a:	f19ff0ef          	jal	ra,ffffffffc0200092 <vcprintf>
ffffffffc020017e:	00002517          	auipc	a0,0x2
ffffffffc0200182:	89250513          	addi	a0,a0,-1902 # ffffffffc0201a10 <etext+0x108>
ffffffffc0200186:	f2dff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc020018a:	2d4000ef          	jal	ra,ffffffffc020045e <intr_disable>
ffffffffc020018e:	4501                	li	a0,0
ffffffffc0200190:	130000ef          	jal	ra,ffffffffc02002c0 <kmonitor>
ffffffffc0200194:	bfed                	j	ffffffffc020018e <__panic+0x54>

ffffffffc0200196 <print_kerninfo>:
ffffffffc0200196:	1141                	addi	sp,sp,-16
ffffffffc0200198:	00001517          	auipc	a0,0x1
ffffffffc020019c:	7b050513          	addi	a0,a0,1968 # ffffffffc0201948 <etext+0x40>
ffffffffc02001a0:	e406                	sd	ra,8(sp)
ffffffffc02001a2:	f11ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc02001a6:	00000597          	auipc	a1,0x0
ffffffffc02001aa:	e8c58593          	addi	a1,a1,-372 # ffffffffc0200032 <kern_init>
ffffffffc02001ae:	00001517          	auipc	a0,0x1
ffffffffc02001b2:	7ba50513          	addi	a0,a0,1978 # ffffffffc0201968 <etext+0x60>
ffffffffc02001b6:	efdff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc02001ba:	00001597          	auipc	a1,0x1
ffffffffc02001be:	74e58593          	addi	a1,a1,1870 # ffffffffc0201908 <etext>
ffffffffc02001c2:	00001517          	auipc	a0,0x1
ffffffffc02001c6:	7c650513          	addi	a0,a0,1990 # ffffffffc0201988 <etext+0x80>
ffffffffc02001ca:	ee9ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc02001ce:	00006597          	auipc	a1,0x6
ffffffffc02001d2:	e4258593          	addi	a1,a1,-446 # ffffffffc0206010 <bsfree_area>
ffffffffc02001d6:	00001517          	auipc	a0,0x1
ffffffffc02001da:	7d250513          	addi	a0,a0,2002 # ffffffffc02019a8 <etext+0xa0>
ffffffffc02001de:	ed5ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc02001e2:	00006597          	auipc	a1,0x6
ffffffffc02001e6:	2a658593          	addi	a1,a1,678 # ffffffffc0206488 <end>
ffffffffc02001ea:	00001517          	auipc	a0,0x1
ffffffffc02001ee:	7de50513          	addi	a0,a0,2014 # ffffffffc02019c8 <etext+0xc0>
ffffffffc02001f2:	ec1ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc02001f6:	00006597          	auipc	a1,0x6
ffffffffc02001fa:	69158593          	addi	a1,a1,1681 # ffffffffc0206887 <end+0x3ff>
ffffffffc02001fe:	00000797          	auipc	a5,0x0
ffffffffc0200202:	e3478793          	addi	a5,a5,-460 # ffffffffc0200032 <kern_init>
ffffffffc0200206:	40f587b3          	sub	a5,a1,a5
ffffffffc020020a:	43f7d593          	srai	a1,a5,0x3f
ffffffffc020020e:	60a2                	ld	ra,8(sp)
ffffffffc0200210:	3ff5f593          	andi	a1,a1,1023
ffffffffc0200214:	95be                	add	a1,a1,a5
ffffffffc0200216:	85a9                	srai	a1,a1,0xa
ffffffffc0200218:	00001517          	auipc	a0,0x1
ffffffffc020021c:	7d050513          	addi	a0,a0,2000 # ffffffffc02019e8 <etext+0xe0>
ffffffffc0200220:	0141                	addi	sp,sp,16
ffffffffc0200222:	bd41                	j	ffffffffc02000b2 <cprintf>

ffffffffc0200224 <print_stackframe>:
ffffffffc0200224:	1141                	addi	sp,sp,-16
ffffffffc0200226:	00001617          	auipc	a2,0x1
ffffffffc020022a:	7f260613          	addi	a2,a2,2034 # ffffffffc0201a18 <etext+0x110>
ffffffffc020022e:	04e00593          	li	a1,78
ffffffffc0200232:	00001517          	auipc	a0,0x1
ffffffffc0200236:	7fe50513          	addi	a0,a0,2046 # ffffffffc0201a30 <etext+0x128>
ffffffffc020023a:	e406                	sd	ra,8(sp)
ffffffffc020023c:	effff0ef          	jal	ra,ffffffffc020013a <__panic>

ffffffffc0200240 <mon_help>:
ffffffffc0200240:	1141                	addi	sp,sp,-16
ffffffffc0200242:	00002617          	auipc	a2,0x2
ffffffffc0200246:	80660613          	addi	a2,a2,-2042 # ffffffffc0201a48 <etext+0x140>
ffffffffc020024a:	00002597          	auipc	a1,0x2
ffffffffc020024e:	81e58593          	addi	a1,a1,-2018 # ffffffffc0201a68 <etext+0x160>
ffffffffc0200252:	00002517          	auipc	a0,0x2
ffffffffc0200256:	81e50513          	addi	a0,a0,-2018 # ffffffffc0201a70 <etext+0x168>
ffffffffc020025a:	e406                	sd	ra,8(sp)
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
ffffffffc02002ca:	82250513          	addi	a0,a0,-2014 # ffffffffc0201ae8 <etext+0x1e0>
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
ffffffffc02002ec:	82850513          	addi	a0,a0,-2008 # ffffffffc0201b10 <etext+0x208>
ffffffffc02002f0:	dc3ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc02002f4:	000b8563          	beqz	s7,ffffffffc02002fe <kmonitor+0x3e>
ffffffffc02002f8:	855e                	mv	a0,s7
ffffffffc02002fa:	348000ef          	jal	ra,ffffffffc0200642 <print_trapframe>
ffffffffc02002fe:	00002c17          	auipc	s8,0x2
ffffffffc0200302:	882c0c13          	addi	s8,s8,-1918 # ffffffffc0201b80 <commands>
ffffffffc0200306:	00002917          	auipc	s2,0x2
ffffffffc020030a:	83290913          	addi	s2,s2,-1998 # ffffffffc0201b38 <etext+0x230>
ffffffffc020030e:	00002497          	auipc	s1,0x2
ffffffffc0200312:	83248493          	addi	s1,s1,-1998 # ffffffffc0201b40 <etext+0x238>
ffffffffc0200316:	49bd                	li	s3,15
ffffffffc0200318:	00002b17          	auipc	s6,0x2
ffffffffc020031c:	830b0b13          	addi	s6,s6,-2000 # ffffffffc0201b48 <etext+0x240>
ffffffffc0200320:	00001a17          	auipc	s4,0x1
ffffffffc0200324:	748a0a13          	addi	s4,s4,1864 # ffffffffc0201a68 <etext+0x160>
ffffffffc0200328:	4a8d                	li	s5,3
ffffffffc020032a:	854a                	mv	a0,s2
ffffffffc020032c:	528010ef          	jal	ra,ffffffffc0201854 <readline>
ffffffffc0200330:	842a                	mv	s0,a0
ffffffffc0200332:	dd65                	beqz	a0,ffffffffc020032a <kmonitor+0x6a>
ffffffffc0200334:	00054583          	lbu	a1,0(a0)
ffffffffc0200338:	4c81                	li	s9,0
ffffffffc020033a:	e1bd                	bnez	a1,ffffffffc02003a0 <kmonitor+0xe0>
ffffffffc020033c:	fe0c87e3          	beqz	s9,ffffffffc020032a <kmonitor+0x6a>
ffffffffc0200340:	6582                	ld	a1,0(sp)
ffffffffc0200342:	00002d17          	auipc	s10,0x2
ffffffffc0200346:	83ed0d13          	addi	s10,s10,-1986 # ffffffffc0201b80 <commands>
ffffffffc020034a:	8552                	mv	a0,s4
ffffffffc020034c:	4401                	li	s0,0
ffffffffc020034e:	0d61                	addi	s10,s10,24
ffffffffc0200350:	080010ef          	jal	ra,ffffffffc02013d0 <strcmp>
ffffffffc0200354:	c919                	beqz	a0,ffffffffc020036a <kmonitor+0xaa>
ffffffffc0200356:	2405                	addiw	s0,s0,1
ffffffffc0200358:	0b540063          	beq	s0,s5,ffffffffc02003f8 <kmonitor+0x138>
ffffffffc020035c:	000d3503          	ld	a0,0(s10)
ffffffffc0200360:	6582                	ld	a1,0(sp)
ffffffffc0200362:	0d61                	addi	s10,s10,24
ffffffffc0200364:	06c010ef          	jal	ra,ffffffffc02013d0 <strcmp>
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
ffffffffc02003a2:	04c010ef          	jal	ra,ffffffffc02013ee <strchr>
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
ffffffffc02003e0:	00e010ef          	jal	ra,ffffffffc02013ee <strchr>
ffffffffc02003e4:	d96d                	beqz	a0,ffffffffc02003d6 <kmonitor+0x116>
ffffffffc02003e6:	00044583          	lbu	a1,0(s0)
ffffffffc02003ea:	d9a9                	beqz	a1,ffffffffc020033c <kmonitor+0x7c>
ffffffffc02003ec:	bf55                	j	ffffffffc02003a0 <kmonitor+0xe0>
ffffffffc02003ee:	45c1                	li	a1,16
ffffffffc02003f0:	855a                	mv	a0,s6
ffffffffc02003f2:	cc1ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc02003f6:	b7e9                	j	ffffffffc02003c0 <kmonitor+0x100>
ffffffffc02003f8:	6582                	ld	a1,0(sp)
ffffffffc02003fa:	00001517          	auipc	a0,0x1
ffffffffc02003fe:	76e50513          	addi	a0,a0,1902 # ffffffffc0201b68 <etext+0x260>
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
ffffffffc0200420:	3fe010ef          	jal	ra,ffffffffc020181e <sbi_set_timer>
ffffffffc0200424:	60a2                	ld	ra,8(sp)
ffffffffc0200426:	00006797          	auipc	a5,0x6
ffffffffc020042a:	0007b523          	sd	zero,10(a5) # ffffffffc0206430 <ticks>
ffffffffc020042e:	00001517          	auipc	a0,0x1
ffffffffc0200432:	79a50513          	addi	a0,a0,1946 # ffffffffc0201bc8 <commands+0x48>
ffffffffc0200436:	0141                	addi	sp,sp,16
ffffffffc0200438:	b9ad                	j	ffffffffc02000b2 <cprintf>

ffffffffc020043a <clock_set_next_event>:
ffffffffc020043a:	c0102573          	rdtime	a0
ffffffffc020043e:	67e1                	lui	a5,0x18
ffffffffc0200440:	6a078793          	addi	a5,a5,1696 # 186a0 <kern_entry-0xffffffffc01e7960>
ffffffffc0200444:	953e                	add	a0,a0,a5
ffffffffc0200446:	3d80106f          	j	ffffffffc020181e <sbi_set_timer>

ffffffffc020044a <cons_init>:
ffffffffc020044a:	8082                	ret

ffffffffc020044c <cons_putc>:
ffffffffc020044c:	0ff57513          	zext.b	a0,a0
ffffffffc0200450:	3b40106f          	j	ffffffffc0201804 <sbi_console_putchar>

ffffffffc0200454 <cons_getc>:
ffffffffc0200454:	3e40106f          	j	ffffffffc0201838 <sbi_console_getchar>

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
ffffffffc020047e:	00001517          	auipc	a0,0x1
ffffffffc0200482:	76a50513          	addi	a0,a0,1898 # ffffffffc0201be8 <commands+0x68>
ffffffffc0200486:	e406                	sd	ra,8(sp)
ffffffffc0200488:	c2bff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc020048c:	640c                	ld	a1,8(s0)
ffffffffc020048e:	00001517          	auipc	a0,0x1
ffffffffc0200492:	77250513          	addi	a0,a0,1906 # ffffffffc0201c00 <commands+0x80>
ffffffffc0200496:	c1dff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc020049a:	680c                	ld	a1,16(s0)
ffffffffc020049c:	00001517          	auipc	a0,0x1
ffffffffc02004a0:	77c50513          	addi	a0,a0,1916 # ffffffffc0201c18 <commands+0x98>
ffffffffc02004a4:	c0fff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc02004a8:	6c0c                	ld	a1,24(s0)
ffffffffc02004aa:	00001517          	auipc	a0,0x1
ffffffffc02004ae:	78650513          	addi	a0,a0,1926 # ffffffffc0201c30 <commands+0xb0>
ffffffffc02004b2:	c01ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc02004b6:	700c                	ld	a1,32(s0)
ffffffffc02004b8:	00001517          	auipc	a0,0x1
ffffffffc02004bc:	79050513          	addi	a0,a0,1936 # ffffffffc0201c48 <commands+0xc8>
ffffffffc02004c0:	bf3ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc02004c4:	740c                	ld	a1,40(s0)
ffffffffc02004c6:	00001517          	auipc	a0,0x1
ffffffffc02004ca:	79a50513          	addi	a0,a0,1946 # ffffffffc0201c60 <commands+0xe0>
ffffffffc02004ce:	be5ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc02004d2:	780c                	ld	a1,48(s0)
ffffffffc02004d4:	00001517          	auipc	a0,0x1
ffffffffc02004d8:	7a450513          	addi	a0,a0,1956 # ffffffffc0201c78 <commands+0xf8>
ffffffffc02004dc:	bd7ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc02004e0:	7c0c                	ld	a1,56(s0)
ffffffffc02004e2:	00001517          	auipc	a0,0x1
ffffffffc02004e6:	7ae50513          	addi	a0,a0,1966 # ffffffffc0201c90 <commands+0x110>
ffffffffc02004ea:	bc9ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc02004ee:	602c                	ld	a1,64(s0)
ffffffffc02004f0:	00001517          	auipc	a0,0x1
ffffffffc02004f4:	7b850513          	addi	a0,a0,1976 # ffffffffc0201ca8 <commands+0x128>
ffffffffc02004f8:	bbbff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc02004fc:	642c                	ld	a1,72(s0)
ffffffffc02004fe:	00001517          	auipc	a0,0x1
ffffffffc0200502:	7c250513          	addi	a0,a0,1986 # ffffffffc0201cc0 <commands+0x140>
ffffffffc0200506:	badff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc020050a:	682c                	ld	a1,80(s0)
ffffffffc020050c:	00001517          	auipc	a0,0x1
ffffffffc0200510:	7cc50513          	addi	a0,a0,1996 # ffffffffc0201cd8 <commands+0x158>
ffffffffc0200514:	b9fff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc0200518:	6c2c                	ld	a1,88(s0)
ffffffffc020051a:	00001517          	auipc	a0,0x1
ffffffffc020051e:	7d650513          	addi	a0,a0,2006 # ffffffffc0201cf0 <commands+0x170>
ffffffffc0200522:	b91ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc0200526:	702c                	ld	a1,96(s0)
ffffffffc0200528:	00001517          	auipc	a0,0x1
ffffffffc020052c:	7e050513          	addi	a0,a0,2016 # ffffffffc0201d08 <commands+0x188>
ffffffffc0200530:	b83ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc0200534:	742c                	ld	a1,104(s0)
ffffffffc0200536:	00001517          	auipc	a0,0x1
ffffffffc020053a:	7ea50513          	addi	a0,a0,2026 # ffffffffc0201d20 <commands+0x1a0>
ffffffffc020053e:	b75ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc0200542:	782c                	ld	a1,112(s0)
ffffffffc0200544:	00001517          	auipc	a0,0x1
ffffffffc0200548:	7f450513          	addi	a0,a0,2036 # ffffffffc0201d38 <commands+0x1b8>
ffffffffc020054c:	b67ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc0200550:	7c2c                	ld	a1,120(s0)
ffffffffc0200552:	00001517          	auipc	a0,0x1
ffffffffc0200556:	7fe50513          	addi	a0,a0,2046 # ffffffffc0201d50 <commands+0x1d0>
ffffffffc020055a:	b59ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc020055e:	604c                	ld	a1,128(s0)
ffffffffc0200560:	00002517          	auipc	a0,0x2
ffffffffc0200564:	80850513          	addi	a0,a0,-2040 # ffffffffc0201d68 <commands+0x1e8>
ffffffffc0200568:	b4bff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc020056c:	644c                	ld	a1,136(s0)
ffffffffc020056e:	00002517          	auipc	a0,0x2
ffffffffc0200572:	81250513          	addi	a0,a0,-2030 # ffffffffc0201d80 <commands+0x200>
ffffffffc0200576:	b3dff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc020057a:	684c                	ld	a1,144(s0)
ffffffffc020057c:	00002517          	auipc	a0,0x2
ffffffffc0200580:	81c50513          	addi	a0,a0,-2020 # ffffffffc0201d98 <commands+0x218>
ffffffffc0200584:	b2fff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc0200588:	6c4c                	ld	a1,152(s0)
ffffffffc020058a:	00002517          	auipc	a0,0x2
ffffffffc020058e:	82650513          	addi	a0,a0,-2010 # ffffffffc0201db0 <commands+0x230>
ffffffffc0200592:	b21ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc0200596:	704c                	ld	a1,160(s0)
ffffffffc0200598:	00002517          	auipc	a0,0x2
ffffffffc020059c:	83050513          	addi	a0,a0,-2000 # ffffffffc0201dc8 <commands+0x248>
ffffffffc02005a0:	b13ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc02005a4:	744c                	ld	a1,168(s0)
ffffffffc02005a6:	00002517          	auipc	a0,0x2
ffffffffc02005aa:	83a50513          	addi	a0,a0,-1990 # ffffffffc0201de0 <commands+0x260>
ffffffffc02005ae:	b05ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc02005b2:	784c                	ld	a1,176(s0)
ffffffffc02005b4:	00002517          	auipc	a0,0x2
ffffffffc02005b8:	84450513          	addi	a0,a0,-1980 # ffffffffc0201df8 <commands+0x278>
ffffffffc02005bc:	af7ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc02005c0:	7c4c                	ld	a1,184(s0)
ffffffffc02005c2:	00002517          	auipc	a0,0x2
ffffffffc02005c6:	84e50513          	addi	a0,a0,-1970 # ffffffffc0201e10 <commands+0x290>
ffffffffc02005ca:	ae9ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc02005ce:	606c                	ld	a1,192(s0)
ffffffffc02005d0:	00002517          	auipc	a0,0x2
ffffffffc02005d4:	85850513          	addi	a0,a0,-1960 # ffffffffc0201e28 <commands+0x2a8>
ffffffffc02005d8:	adbff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc02005dc:	646c                	ld	a1,200(s0)
ffffffffc02005de:	00002517          	auipc	a0,0x2
ffffffffc02005e2:	86250513          	addi	a0,a0,-1950 # ffffffffc0201e40 <commands+0x2c0>
ffffffffc02005e6:	acdff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc02005ea:	686c                	ld	a1,208(s0)
ffffffffc02005ec:	00002517          	auipc	a0,0x2
ffffffffc02005f0:	86c50513          	addi	a0,a0,-1940 # ffffffffc0201e58 <commands+0x2d8>
ffffffffc02005f4:	abfff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc02005f8:	6c6c                	ld	a1,216(s0)
ffffffffc02005fa:	00002517          	auipc	a0,0x2
ffffffffc02005fe:	87650513          	addi	a0,a0,-1930 # ffffffffc0201e70 <commands+0x2f0>
ffffffffc0200602:	ab1ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc0200606:	706c                	ld	a1,224(s0)
ffffffffc0200608:	00002517          	auipc	a0,0x2
ffffffffc020060c:	88050513          	addi	a0,a0,-1920 # ffffffffc0201e88 <commands+0x308>
ffffffffc0200610:	aa3ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc0200614:	746c                	ld	a1,232(s0)
ffffffffc0200616:	00002517          	auipc	a0,0x2
ffffffffc020061a:	88a50513          	addi	a0,a0,-1910 # ffffffffc0201ea0 <commands+0x320>
ffffffffc020061e:	a95ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc0200622:	786c                	ld	a1,240(s0)
ffffffffc0200624:	00002517          	auipc	a0,0x2
ffffffffc0200628:	89450513          	addi	a0,a0,-1900 # ffffffffc0201eb8 <commands+0x338>
ffffffffc020062c:	a87ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc0200630:	7c6c                	ld	a1,248(s0)
ffffffffc0200632:	6402                	ld	s0,0(sp)
ffffffffc0200634:	60a2                	ld	ra,8(sp)
ffffffffc0200636:	00002517          	auipc	a0,0x2
ffffffffc020063a:	89a50513          	addi	a0,a0,-1894 # ffffffffc0201ed0 <commands+0x350>
ffffffffc020063e:	0141                	addi	sp,sp,16
ffffffffc0200640:	bc8d                	j	ffffffffc02000b2 <cprintf>

ffffffffc0200642 <print_trapframe>:
ffffffffc0200642:	1141                	addi	sp,sp,-16
ffffffffc0200644:	e022                	sd	s0,0(sp)
ffffffffc0200646:	85aa                	mv	a1,a0
ffffffffc0200648:	842a                	mv	s0,a0
ffffffffc020064a:	00002517          	auipc	a0,0x2
ffffffffc020064e:	89e50513          	addi	a0,a0,-1890 # ffffffffc0201ee8 <commands+0x368>
ffffffffc0200652:	e406                	sd	ra,8(sp)
ffffffffc0200654:	a5fff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc0200658:	8522                	mv	a0,s0
ffffffffc020065a:	e1dff0ef          	jal	ra,ffffffffc0200476 <print_regs>
ffffffffc020065e:	10043583          	ld	a1,256(s0)
ffffffffc0200662:	00002517          	auipc	a0,0x2
ffffffffc0200666:	89e50513          	addi	a0,a0,-1890 # ffffffffc0201f00 <commands+0x380>
ffffffffc020066a:	a49ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc020066e:	10843583          	ld	a1,264(s0)
ffffffffc0200672:	00002517          	auipc	a0,0x2
ffffffffc0200676:	8a650513          	addi	a0,a0,-1882 # ffffffffc0201f18 <commands+0x398>
ffffffffc020067a:	a39ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc020067e:	11043583          	ld	a1,272(s0)
ffffffffc0200682:	00002517          	auipc	a0,0x2
ffffffffc0200686:	8ae50513          	addi	a0,a0,-1874 # ffffffffc0201f30 <commands+0x3b0>
ffffffffc020068a:	a29ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc020068e:	11843583          	ld	a1,280(s0)
ffffffffc0200692:	6402                	ld	s0,0(sp)
ffffffffc0200694:	60a2                	ld	ra,8(sp)
ffffffffc0200696:	00002517          	auipc	a0,0x2
ffffffffc020069a:	8b250513          	addi	a0,a0,-1870 # ffffffffc0201f48 <commands+0x3c8>
ffffffffc020069e:	0141                	addi	sp,sp,16
ffffffffc02006a0:	bc09                	j	ffffffffc02000b2 <cprintf>

ffffffffc02006a2 <interrupt_handler>:
ffffffffc02006a2:	11853783          	ld	a5,280(a0)
ffffffffc02006a6:	472d                	li	a4,11
ffffffffc02006a8:	0786                	slli	a5,a5,0x1
ffffffffc02006aa:	8385                	srli	a5,a5,0x1
ffffffffc02006ac:	06f76c63          	bltu	a4,a5,ffffffffc0200724 <interrupt_handler+0x82>
ffffffffc02006b0:	00002717          	auipc	a4,0x2
ffffffffc02006b4:	97870713          	addi	a4,a4,-1672 # ffffffffc0202028 <commands+0x4a8>
ffffffffc02006b8:	078a                	slli	a5,a5,0x2
ffffffffc02006ba:	97ba                	add	a5,a5,a4
ffffffffc02006bc:	439c                	lw	a5,0(a5)
ffffffffc02006be:	97ba                	add	a5,a5,a4
ffffffffc02006c0:	8782                	jr	a5
ffffffffc02006c2:	00002517          	auipc	a0,0x2
ffffffffc02006c6:	8fe50513          	addi	a0,a0,-1794 # ffffffffc0201fc0 <commands+0x440>
ffffffffc02006ca:	b2e5                	j	ffffffffc02000b2 <cprintf>
ffffffffc02006cc:	00002517          	auipc	a0,0x2
ffffffffc02006d0:	8d450513          	addi	a0,a0,-1836 # ffffffffc0201fa0 <commands+0x420>
ffffffffc02006d4:	baf9                	j	ffffffffc02000b2 <cprintf>
ffffffffc02006d6:	00002517          	auipc	a0,0x2
ffffffffc02006da:	88a50513          	addi	a0,a0,-1910 # ffffffffc0201f60 <commands+0x3e0>
ffffffffc02006de:	bad1                	j	ffffffffc02000b2 <cprintf>
ffffffffc02006e0:	00002517          	auipc	a0,0x2
ffffffffc02006e4:	90050513          	addi	a0,a0,-1792 # ffffffffc0201fe0 <commands+0x460>
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
ffffffffc0200714:	8f850513          	addi	a0,a0,-1800 # ffffffffc0202008 <commands+0x488>
ffffffffc0200718:	ba69                	j	ffffffffc02000b2 <cprintf>
ffffffffc020071a:	00002517          	auipc	a0,0x2
ffffffffc020071e:	86650513          	addi	a0,a0,-1946 # ffffffffc0201f80 <commands+0x400>
ffffffffc0200722:	ba41                	j	ffffffffc02000b2 <cprintf>
ffffffffc0200724:	bf39                	j	ffffffffc0200642 <print_trapframe>
ffffffffc0200726:	60a2                	ld	ra,8(sp)
ffffffffc0200728:	06400593          	li	a1,100
ffffffffc020072c:	00002517          	auipc	a0,0x2
ffffffffc0200730:	8cc50513          	addi	a0,a0,-1844 # ffffffffc0201ff8 <commands+0x478>
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
 * test_bit - Determine whether a bit is set
 * @nr:     the bit to test
 * @addr:   the address to count from
 * */
static inline bool test_bit(int nr, volatile void *addr) {
    return (((*(volatile unsigned long *)addr) >> nr) & 1);
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
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
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
//将page指针转化为物理地址


static inline int page_ref(struct Page *page) { return page->ref; }
//返回页面的引用计数
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
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
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
#include <defs.h>
#include <intr.h>
#include <riscv.h>

static inline bool __intr_save(void) {
    if (read_csr(sstatus) & SSTATUS_SIE) {
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
    return 0;
}

static inline void __intr_restore(bool flag) {
    if (flag) {
        intr_enable();
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
// free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory
void free_pages(struct Page *base, size_t n) {
    bool intr_flag;
    local_intr_save(intr_flag);
    {
        pmm_manager->free_pages(base, n);
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
    }
    local_intr_restore(intr_flag);
    return ret;
}
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
    satp_physical = PADDR(satp_virtual);
    cprintf("satp virtual address: 0x%016lx\nsatp physical address: 0x%016lx\n", satp_virtual, satp_physical);
}

static void check_alloc_page(void) {
    pmm_manager->check();
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
    page->ref -= 1;
    return page->ref;
}
//引用次数减1
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
ffffffffc0201372:	06d00593          	li	a1,109
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
ffffffffc02013b4:	4781                	li	a5,0
ffffffffc02013b6:	e589                	bnez	a1,ffffffffc02013c0 <strnlen+0xc>
ffffffffc02013b8:	a811                	j	ffffffffc02013cc <strnlen+0x18>
ffffffffc02013ba:	0785                	addi	a5,a5,1
ffffffffc02013bc:	00f58863          	beq	a1,a5,ffffffffc02013cc <strnlen+0x18>
ffffffffc02013c0:	00f50733          	add	a4,a0,a5
ffffffffc02013c4:	00074703          	lbu	a4,0(a4) # fffffffffffff000 <end+0x3fdf8b78>
ffffffffc02013c8:	fb6d                	bnez	a4,ffffffffc02013ba <strnlen+0x6>
ffffffffc02013ca:	85be                	mv	a1,a5
ffffffffc02013cc:	852e                	mv	a0,a1
ffffffffc02013ce:	8082                	ret

ffffffffc02013d0 <strcmp>:
ffffffffc02013d0:	00054783          	lbu	a5,0(a0)
ffffffffc02013d4:	0005c703          	lbu	a4,0(a1)
ffffffffc02013d8:	cb89                	beqz	a5,ffffffffc02013ea <strcmp+0x1a>
ffffffffc02013da:	0505                	addi	a0,a0,1
ffffffffc02013dc:	0585                	addi	a1,a1,1
ffffffffc02013de:	fee789e3          	beq	a5,a4,ffffffffc02013d0 <strcmp>
ffffffffc02013e2:	0007851b          	sext.w	a0,a5
ffffffffc02013e6:	9d19                	subw	a0,a0,a4
ffffffffc02013e8:	8082                	ret
ffffffffc02013ea:	4501                	li	a0,0
ffffffffc02013ec:	bfed                	j	ffffffffc02013e6 <strcmp+0x16>

ffffffffc02013ee <strchr>:
ffffffffc02013ee:	00054783          	lbu	a5,0(a0)
ffffffffc02013f2:	c799                	beqz	a5,ffffffffc0201400 <strchr+0x12>
ffffffffc02013f4:	00f58763          	beq	a1,a5,ffffffffc0201402 <strchr+0x14>
ffffffffc02013f8:	00154783          	lbu	a5,1(a0)
ffffffffc02013fc:	0505                	addi	a0,a0,1
ffffffffc02013fe:	fbfd                	bnez	a5,ffffffffc02013f4 <strchr+0x6>
ffffffffc0201400:	4501                	li	a0,0
ffffffffc0201402:	8082                	ret

ffffffffc0201404 <memset>:
ffffffffc0201404:	ca01                	beqz	a2,ffffffffc0201414 <memset+0x10>
ffffffffc0201406:	962a                	add	a2,a2,a0
ffffffffc0201408:	87aa                	mv	a5,a0
ffffffffc020140a:	0785                	addi	a5,a5,1
ffffffffc020140c:	feb78fa3          	sb	a1,-1(a5)
ffffffffc0201410:	fec79de3          	bne	a5,a2,ffffffffc020140a <memset+0x6>
ffffffffc0201414:	8082                	ret

ffffffffc0201416 <printnum>:
ffffffffc0201416:	02069813          	slli	a6,a3,0x20
ffffffffc020141a:	7179                	addi	sp,sp,-48
ffffffffc020141c:	02085813          	srli	a6,a6,0x20
ffffffffc0201420:	e052                	sd	s4,0(sp)
ffffffffc0201422:	03067a33          	remu	s4,a2,a6
ffffffffc0201426:	f022                	sd	s0,32(sp)
ffffffffc0201428:	ec26                	sd	s1,24(sp)
ffffffffc020142a:	e84a                	sd	s2,16(sp)
ffffffffc020142c:	f406                	sd	ra,40(sp)
ffffffffc020142e:	e44e                	sd	s3,8(sp)
ffffffffc0201430:	84aa                	mv	s1,a0
ffffffffc0201432:	892e                	mv	s2,a1
ffffffffc0201434:	fff7041b          	addiw	s0,a4,-1
ffffffffc0201438:	2a01                	sext.w	s4,s4
ffffffffc020143a:	03067e63          	bgeu	a2,a6,ffffffffc0201476 <printnum+0x60>
ffffffffc020143e:	89be                	mv	s3,a5
ffffffffc0201440:	00805763          	blez	s0,ffffffffc020144e <printnum+0x38>
ffffffffc0201444:	347d                	addiw	s0,s0,-1
ffffffffc0201446:	85ca                	mv	a1,s2
ffffffffc0201448:	854e                	mv	a0,s3
ffffffffc020144a:	9482                	jalr	s1
ffffffffc020144c:	fc65                	bnez	s0,ffffffffc0201444 <printnum+0x2e>
ffffffffc020144e:	1a02                	slli	s4,s4,0x20
ffffffffc0201450:	00001797          	auipc	a5,0x1
ffffffffc0201454:	fe878793          	addi	a5,a5,-24 # ffffffffc0202438 <buddy_system_pmm_manager+0x180>
ffffffffc0201458:	020a5a13          	srli	s4,s4,0x20
ffffffffc020145c:	9a3e                	add	s4,s4,a5
ffffffffc020145e:	7402                	ld	s0,32(sp)
ffffffffc0201460:	000a4503          	lbu	a0,0(s4)
ffffffffc0201464:	70a2                	ld	ra,40(sp)
ffffffffc0201466:	69a2                	ld	s3,8(sp)
ffffffffc0201468:	6a02                	ld	s4,0(sp)
ffffffffc020146a:	85ca                	mv	a1,s2
ffffffffc020146c:	87a6                	mv	a5,s1
ffffffffc020146e:	6942                	ld	s2,16(sp)
ffffffffc0201470:	64e2                	ld	s1,24(sp)
ffffffffc0201472:	6145                	addi	sp,sp,48
ffffffffc0201474:	8782                	jr	a5
ffffffffc0201476:	03065633          	divu	a2,a2,a6
ffffffffc020147a:	8722                	mv	a4,s0
ffffffffc020147c:	f9bff0ef          	jal	ra,ffffffffc0201416 <printnum>
ffffffffc0201480:	b7f9                	j	ffffffffc020144e <printnum+0x38>

ffffffffc0201482 <vprintfmt>:
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
ffffffffc02014a6:	02500993          	li	s3,37
ffffffffc02014aa:	5b7d                	li	s6,-1
ffffffffc02014ac:	00001a97          	auipc	s5,0x1
ffffffffc02014b0:	fc0a8a93          	addi	s5,s5,-64 # ffffffffc020246c <buddy_system_pmm_manager+0x1b4>
ffffffffc02014b4:	00001b97          	auipc	s7,0x1
ffffffffc02014b8:	194b8b93          	addi	s7,s7,404 # ffffffffc0202648 <error_string>
ffffffffc02014bc:	000d4503          	lbu	a0,0(s10)
ffffffffc02014c0:	001d0413          	addi	s0,s10,1
ffffffffc02014c4:	01350a63          	beq	a0,s3,ffffffffc02014d8 <vprintfmt+0x56>
ffffffffc02014c8:	c121                	beqz	a0,ffffffffc0201508 <vprintfmt+0x86>
ffffffffc02014ca:	85a6                	mv	a1,s1
ffffffffc02014cc:	0405                	addi	s0,s0,1
ffffffffc02014ce:	9902                	jalr	s2
ffffffffc02014d0:	fff44503          	lbu	a0,-1(s0)
ffffffffc02014d4:	ff351ae3          	bne	a0,s3,ffffffffc02014c8 <vprintfmt+0x46>
ffffffffc02014d8:	00044603          	lbu	a2,0(s0)
ffffffffc02014dc:	02000793          	li	a5,32
ffffffffc02014e0:	4c81                	li	s9,0
ffffffffc02014e2:	4881                	li	a7,0
ffffffffc02014e4:	5c7d                	li	s8,-1
ffffffffc02014e6:	5dfd                	li	s11,-1
ffffffffc02014e8:	05500513          	li	a0,85
ffffffffc02014ec:	4825                	li	a6,9
ffffffffc02014ee:	fdd6059b          	addiw	a1,a2,-35
ffffffffc02014f2:	0ff5f593          	zext.b	a1,a1
ffffffffc02014f6:	00140d13          	addi	s10,s0,1
ffffffffc02014fa:	04b56263          	bltu	a0,a1,ffffffffc020153e <vprintfmt+0xbc>
ffffffffc02014fe:	058a                	slli	a1,a1,0x2
ffffffffc0201500:	95d6                	add	a1,a1,s5
ffffffffc0201502:	4194                	lw	a3,0(a1)
ffffffffc0201504:	96d6                	add	a3,a3,s5
ffffffffc0201506:	8682                	jr	a3
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
ffffffffc0201526:	87b2                	mv	a5,a2
ffffffffc0201528:	00144603          	lbu	a2,1(s0)
ffffffffc020152c:	846a                	mv	s0,s10
ffffffffc020152e:	00140d13          	addi	s10,s0,1
ffffffffc0201532:	fdd6059b          	addiw	a1,a2,-35
ffffffffc0201536:	0ff5f593          	zext.b	a1,a1
ffffffffc020153a:	fcb572e3          	bgeu	a0,a1,ffffffffc02014fe <vprintfmt+0x7c>
ffffffffc020153e:	85a6                	mv	a1,s1
ffffffffc0201540:	02500513          	li	a0,37
ffffffffc0201544:	9902                	jalr	s2
ffffffffc0201546:	fff44783          	lbu	a5,-1(s0)
ffffffffc020154a:	8d22                	mv	s10,s0
ffffffffc020154c:	f73788e3          	beq	a5,s3,ffffffffc02014bc <vprintfmt+0x3a>
ffffffffc0201550:	ffed4783          	lbu	a5,-2(s10)
ffffffffc0201554:	1d7d                	addi	s10,s10,-1
ffffffffc0201556:	ff379de3          	bne	a5,s3,ffffffffc0201550 <vprintfmt+0xce>
ffffffffc020155a:	b78d                	j	ffffffffc02014bc <vprintfmt+0x3a>
ffffffffc020155c:	fd060c1b          	addiw	s8,a2,-48
ffffffffc0201560:	00144603          	lbu	a2,1(s0)
ffffffffc0201564:	846a                	mv	s0,s10
ffffffffc0201566:	fd06069b          	addiw	a3,a2,-48
ffffffffc020156a:	0006059b          	sext.w	a1,a2
ffffffffc020156e:	02d86463          	bltu	a6,a3,ffffffffc0201596 <vprintfmt+0x114>
ffffffffc0201572:	00144603          	lbu	a2,1(s0)
ffffffffc0201576:	002c169b          	slliw	a3,s8,0x2
ffffffffc020157a:	0186873b          	addw	a4,a3,s8
ffffffffc020157e:	0017171b          	slliw	a4,a4,0x1
ffffffffc0201582:	9f2d                	addw	a4,a4,a1
ffffffffc0201584:	fd06069b          	addiw	a3,a2,-48
ffffffffc0201588:	0405                	addi	s0,s0,1
ffffffffc020158a:	fd070c1b          	addiw	s8,a4,-48
ffffffffc020158e:	0006059b          	sext.w	a1,a2
ffffffffc0201592:	fed870e3          	bgeu	a6,a3,ffffffffc0201572 <vprintfmt+0xf0>
ffffffffc0201596:	f40ddce3          	bgez	s11,ffffffffc02014ee <vprintfmt+0x6c>
ffffffffc020159a:	8de2                	mv	s11,s8
ffffffffc020159c:	5c7d                	li	s8,-1
ffffffffc020159e:	bf81                	j	ffffffffc02014ee <vprintfmt+0x6c>
ffffffffc02015a0:	fffdc693          	not	a3,s11
ffffffffc02015a4:	96fd                	srai	a3,a3,0x3f
ffffffffc02015a6:	00ddfdb3          	and	s11,s11,a3
ffffffffc02015aa:	00144603          	lbu	a2,1(s0)
ffffffffc02015ae:	2d81                	sext.w	s11,s11
ffffffffc02015b0:	846a                	mv	s0,s10
ffffffffc02015b2:	bf35                	j	ffffffffc02014ee <vprintfmt+0x6c>
ffffffffc02015b4:	000a2c03          	lw	s8,0(s4)
ffffffffc02015b8:	00144603          	lbu	a2,1(s0)
ffffffffc02015bc:	0a21                	addi	s4,s4,8
ffffffffc02015be:	846a                	mv	s0,s10
ffffffffc02015c0:	bfd9                	j	ffffffffc0201596 <vprintfmt+0x114>
ffffffffc02015c2:	4705                	li	a4,1
ffffffffc02015c4:	008a0593          	addi	a1,s4,8
ffffffffc02015c8:	01174463          	blt	a4,a7,ffffffffc02015d0 <vprintfmt+0x14e>
ffffffffc02015cc:	1a088e63          	beqz	a7,ffffffffc0201788 <vprintfmt+0x306>
ffffffffc02015d0:	000a3603          	ld	a2,0(s4)
ffffffffc02015d4:	46c1                	li	a3,16
ffffffffc02015d6:	8a2e                	mv	s4,a1
ffffffffc02015d8:	2781                	sext.w	a5,a5
ffffffffc02015da:	876e                	mv	a4,s11
ffffffffc02015dc:	85a6                	mv	a1,s1
ffffffffc02015de:	854a                	mv	a0,s2
ffffffffc02015e0:	e37ff0ef          	jal	ra,ffffffffc0201416 <printnum>
ffffffffc02015e4:	bde1                	j	ffffffffc02014bc <vprintfmt+0x3a>
ffffffffc02015e6:	000a2503          	lw	a0,0(s4)
ffffffffc02015ea:	85a6                	mv	a1,s1
ffffffffc02015ec:	0a21                	addi	s4,s4,8
ffffffffc02015ee:	9902                	jalr	s2
ffffffffc02015f0:	b5f1                	j	ffffffffc02014bc <vprintfmt+0x3a>
ffffffffc02015f2:	4705                	li	a4,1
ffffffffc02015f4:	008a0593          	addi	a1,s4,8
ffffffffc02015f8:	01174463          	blt	a4,a7,ffffffffc0201600 <vprintfmt+0x17e>
ffffffffc02015fc:	18088163          	beqz	a7,ffffffffc020177e <vprintfmt+0x2fc>
ffffffffc0201600:	000a3603          	ld	a2,0(s4)
ffffffffc0201604:	46a9                	li	a3,10
ffffffffc0201606:	8a2e                	mv	s4,a1
ffffffffc0201608:	bfc1                	j	ffffffffc02015d8 <vprintfmt+0x156>
ffffffffc020160a:	00144603          	lbu	a2,1(s0)
ffffffffc020160e:	4c85                	li	s9,1
ffffffffc0201610:	846a                	mv	s0,s10
ffffffffc0201612:	bdf1                	j	ffffffffc02014ee <vprintfmt+0x6c>
ffffffffc0201614:	85a6                	mv	a1,s1
ffffffffc0201616:	02500513          	li	a0,37
ffffffffc020161a:	9902                	jalr	s2
ffffffffc020161c:	b545                	j	ffffffffc02014bc <vprintfmt+0x3a>
ffffffffc020161e:	00144603          	lbu	a2,1(s0)
ffffffffc0201622:	2885                	addiw	a7,a7,1
ffffffffc0201624:	846a                	mv	s0,s10
ffffffffc0201626:	b5e1                	j	ffffffffc02014ee <vprintfmt+0x6c>
ffffffffc0201628:	4705                	li	a4,1
ffffffffc020162a:	008a0593          	addi	a1,s4,8
ffffffffc020162e:	01174463          	blt	a4,a7,ffffffffc0201636 <vprintfmt+0x1b4>
ffffffffc0201632:	14088163          	beqz	a7,ffffffffc0201774 <vprintfmt+0x2f2>
ffffffffc0201636:	000a3603          	ld	a2,0(s4)
ffffffffc020163a:	46a1                	li	a3,8
ffffffffc020163c:	8a2e                	mv	s4,a1
ffffffffc020163e:	bf69                	j	ffffffffc02015d8 <vprintfmt+0x156>
ffffffffc0201640:	03000513          	li	a0,48
ffffffffc0201644:	85a6                	mv	a1,s1
ffffffffc0201646:	e03e                	sd	a5,0(sp)
ffffffffc0201648:	9902                	jalr	s2
ffffffffc020164a:	85a6                	mv	a1,s1
ffffffffc020164c:	07800513          	li	a0,120
ffffffffc0201650:	9902                	jalr	s2
ffffffffc0201652:	0a21                	addi	s4,s4,8
ffffffffc0201654:	6782                	ld	a5,0(sp)
ffffffffc0201656:	46c1                	li	a3,16
ffffffffc0201658:	ff8a3603          	ld	a2,-8(s4)
ffffffffc020165c:	bfb5                	j	ffffffffc02015d8 <vprintfmt+0x156>
ffffffffc020165e:	000a3403          	ld	s0,0(s4)
ffffffffc0201662:	008a0713          	addi	a4,s4,8
ffffffffc0201666:	e03a                	sd	a4,0(sp)
ffffffffc0201668:	14040263          	beqz	s0,ffffffffc02017ac <vprintfmt+0x32a>
ffffffffc020166c:	0fb05763          	blez	s11,ffffffffc020175a <vprintfmt+0x2d8>
ffffffffc0201670:	02d00693          	li	a3,45
ffffffffc0201674:	0cd79163          	bne	a5,a3,ffffffffc0201736 <vprintfmt+0x2b4>
ffffffffc0201678:	00044783          	lbu	a5,0(s0)
ffffffffc020167c:	0007851b          	sext.w	a0,a5
ffffffffc0201680:	cf85                	beqz	a5,ffffffffc02016b8 <vprintfmt+0x236>
ffffffffc0201682:	00140a13          	addi	s4,s0,1
ffffffffc0201686:	05e00413          	li	s0,94
ffffffffc020168a:	000c4563          	bltz	s8,ffffffffc0201694 <vprintfmt+0x212>
ffffffffc020168e:	3c7d                	addiw	s8,s8,-1
ffffffffc0201690:	036c0263          	beq	s8,s6,ffffffffc02016b4 <vprintfmt+0x232>
ffffffffc0201694:	85a6                	mv	a1,s1
ffffffffc0201696:	0e0c8e63          	beqz	s9,ffffffffc0201792 <vprintfmt+0x310>
ffffffffc020169a:	3781                	addiw	a5,a5,-32
ffffffffc020169c:	0ef47b63          	bgeu	s0,a5,ffffffffc0201792 <vprintfmt+0x310>
ffffffffc02016a0:	03f00513          	li	a0,63
ffffffffc02016a4:	9902                	jalr	s2
ffffffffc02016a6:	000a4783          	lbu	a5,0(s4)
ffffffffc02016aa:	3dfd                	addiw	s11,s11,-1
ffffffffc02016ac:	0a05                	addi	s4,s4,1
ffffffffc02016ae:	0007851b          	sext.w	a0,a5
ffffffffc02016b2:	ffe1                	bnez	a5,ffffffffc020168a <vprintfmt+0x208>
ffffffffc02016b4:	01b05963          	blez	s11,ffffffffc02016c6 <vprintfmt+0x244>
ffffffffc02016b8:	3dfd                	addiw	s11,s11,-1
ffffffffc02016ba:	85a6                	mv	a1,s1
ffffffffc02016bc:	02000513          	li	a0,32
ffffffffc02016c0:	9902                	jalr	s2
ffffffffc02016c2:	fe0d9be3          	bnez	s11,ffffffffc02016b8 <vprintfmt+0x236>
ffffffffc02016c6:	6a02                	ld	s4,0(sp)
ffffffffc02016c8:	bbd5                	j	ffffffffc02014bc <vprintfmt+0x3a>
ffffffffc02016ca:	4705                	li	a4,1
ffffffffc02016cc:	008a0c93          	addi	s9,s4,8
ffffffffc02016d0:	01174463          	blt	a4,a7,ffffffffc02016d8 <vprintfmt+0x256>
ffffffffc02016d4:	08088d63          	beqz	a7,ffffffffc020176e <vprintfmt+0x2ec>
ffffffffc02016d8:	000a3403          	ld	s0,0(s4)
ffffffffc02016dc:	0a044d63          	bltz	s0,ffffffffc0201796 <vprintfmt+0x314>
ffffffffc02016e0:	8622                	mv	a2,s0
ffffffffc02016e2:	8a66                	mv	s4,s9
ffffffffc02016e4:	46a9                	li	a3,10
ffffffffc02016e6:	bdcd                	j	ffffffffc02015d8 <vprintfmt+0x156>
ffffffffc02016e8:	000a2783          	lw	a5,0(s4)
ffffffffc02016ec:	4719                	li	a4,6
ffffffffc02016ee:	0a21                	addi	s4,s4,8
ffffffffc02016f0:	41f7d69b          	sraiw	a3,a5,0x1f
ffffffffc02016f4:	8fb5                	xor	a5,a5,a3
ffffffffc02016f6:	40d786bb          	subw	a3,a5,a3
ffffffffc02016fa:	02d74163          	blt	a4,a3,ffffffffc020171c <vprintfmt+0x29a>
ffffffffc02016fe:	00369793          	slli	a5,a3,0x3
ffffffffc0201702:	97de                	add	a5,a5,s7
ffffffffc0201704:	639c                	ld	a5,0(a5)
ffffffffc0201706:	cb99                	beqz	a5,ffffffffc020171c <vprintfmt+0x29a>
ffffffffc0201708:	86be                	mv	a3,a5
ffffffffc020170a:	00001617          	auipc	a2,0x1
ffffffffc020170e:	d5e60613          	addi	a2,a2,-674 # ffffffffc0202468 <buddy_system_pmm_manager+0x1b0>
ffffffffc0201712:	85a6                	mv	a1,s1
ffffffffc0201714:	854a                	mv	a0,s2
ffffffffc0201716:	0ce000ef          	jal	ra,ffffffffc02017e4 <printfmt>
ffffffffc020171a:	b34d                	j	ffffffffc02014bc <vprintfmt+0x3a>
ffffffffc020171c:	00001617          	auipc	a2,0x1
ffffffffc0201720:	d3c60613          	addi	a2,a2,-708 # ffffffffc0202458 <buddy_system_pmm_manager+0x1a0>
ffffffffc0201724:	85a6                	mv	a1,s1
ffffffffc0201726:	854a                	mv	a0,s2
ffffffffc0201728:	0bc000ef          	jal	ra,ffffffffc02017e4 <printfmt>
ffffffffc020172c:	bb41                	j	ffffffffc02014bc <vprintfmt+0x3a>
ffffffffc020172e:	00001417          	auipc	s0,0x1
ffffffffc0201732:	d2240413          	addi	s0,s0,-734 # ffffffffc0202450 <buddy_system_pmm_manager+0x198>
ffffffffc0201736:	85e2                	mv	a1,s8
ffffffffc0201738:	8522                	mv	a0,s0
ffffffffc020173a:	e43e                	sd	a5,8(sp)
ffffffffc020173c:	c79ff0ef          	jal	ra,ffffffffc02013b4 <strnlen>
ffffffffc0201740:	40ad8dbb          	subw	s11,s11,a0
ffffffffc0201744:	01b05b63          	blez	s11,ffffffffc020175a <vprintfmt+0x2d8>
ffffffffc0201748:	67a2                	ld	a5,8(sp)
ffffffffc020174a:	00078a1b          	sext.w	s4,a5
ffffffffc020174e:	3dfd                	addiw	s11,s11,-1
ffffffffc0201750:	85a6                	mv	a1,s1
ffffffffc0201752:	8552                	mv	a0,s4
ffffffffc0201754:	9902                	jalr	s2
ffffffffc0201756:	fe0d9ce3          	bnez	s11,ffffffffc020174e <vprintfmt+0x2cc>
ffffffffc020175a:	00044783          	lbu	a5,0(s0)
ffffffffc020175e:	00140a13          	addi	s4,s0,1
ffffffffc0201762:	0007851b          	sext.w	a0,a5
ffffffffc0201766:	d3a5                	beqz	a5,ffffffffc02016c6 <vprintfmt+0x244>
ffffffffc0201768:	05e00413          	li	s0,94
ffffffffc020176c:	bf39                	j	ffffffffc020168a <vprintfmt+0x208>
ffffffffc020176e:	000a2403          	lw	s0,0(s4)
ffffffffc0201772:	b7ad                	j	ffffffffc02016dc <vprintfmt+0x25a>
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
ffffffffc0201792:	9902                	jalr	s2
ffffffffc0201794:	bf09                	j	ffffffffc02016a6 <vprintfmt+0x224>
ffffffffc0201796:	85a6                	mv	a1,s1
ffffffffc0201798:	02d00513          	li	a0,45
ffffffffc020179c:	e03e                	sd	a5,0(sp)
ffffffffc020179e:	9902                	jalr	s2
ffffffffc02017a0:	6782                	ld	a5,0(sp)
ffffffffc02017a2:	8a66                	mv	s4,s9
ffffffffc02017a4:	40800633          	neg	a2,s0
ffffffffc02017a8:	46a9                	li	a3,10
ffffffffc02017aa:	b53d                	j	ffffffffc02015d8 <vprintfmt+0x156>
ffffffffc02017ac:	03b05163          	blez	s11,ffffffffc02017ce <vprintfmt+0x34c>
ffffffffc02017b0:	02d00693          	li	a3,45
ffffffffc02017b4:	f6d79de3          	bne	a5,a3,ffffffffc020172e <vprintfmt+0x2ac>
ffffffffc02017b8:	00001417          	auipc	s0,0x1
ffffffffc02017bc:	c9840413          	addi	s0,s0,-872 # ffffffffc0202450 <buddy_system_pmm_manager+0x198>
ffffffffc02017c0:	02800793          	li	a5,40
ffffffffc02017c4:	02800513          	li	a0,40
ffffffffc02017c8:	00140a13          	addi	s4,s0,1
ffffffffc02017cc:	bd6d                	j	ffffffffc0201686 <vprintfmt+0x204>
ffffffffc02017ce:	00001a17          	auipc	s4,0x1
ffffffffc02017d2:	c83a0a13          	addi	s4,s4,-893 # ffffffffc0202451 <buddy_system_pmm_manager+0x199>
ffffffffc02017d6:	02800513          	li	a0,40
ffffffffc02017da:	02800793          	li	a5,40
ffffffffc02017de:	05e00413          	li	s0,94
ffffffffc02017e2:	b565                	j	ffffffffc020168a <vprintfmt+0x208>

ffffffffc02017e4 <printfmt>:
ffffffffc02017e4:	715d                	addi	sp,sp,-80
ffffffffc02017e6:	02810313          	addi	t1,sp,40
ffffffffc02017ea:	f436                	sd	a3,40(sp)
ffffffffc02017ec:	869a                	mv	a3,t1
ffffffffc02017ee:	ec06                	sd	ra,24(sp)
ffffffffc02017f0:	f83a                	sd	a4,48(sp)
ffffffffc02017f2:	fc3e                	sd	a5,56(sp)
ffffffffc02017f4:	e0c2                	sd	a6,64(sp)
ffffffffc02017f6:	e4c6                	sd	a7,72(sp)
ffffffffc02017f8:	e41a                	sd	t1,8(sp)
ffffffffc02017fa:	c89ff0ef          	jal	ra,ffffffffc0201482 <vprintfmt>
ffffffffc02017fe:	60e2                	ld	ra,24(sp)
ffffffffc0201800:	6161                	addi	sp,sp,80
ffffffffc0201802:	8082                	ret

ffffffffc0201804 <sbi_console_putchar>:
ffffffffc0201804:	4781                	li	a5,0
ffffffffc0201806:	00005717          	auipc	a4,0x5
ffffffffc020180a:	80273703          	ld	a4,-2046(a4) # ffffffffc0206008 <SBI_CONSOLE_PUTCHAR>
ffffffffc020180e:	88ba                	mv	a7,a4
ffffffffc0201810:	852a                	mv	a0,a0
ffffffffc0201812:	85be                	mv	a1,a5
ffffffffc0201814:	863e                	mv	a2,a5
ffffffffc0201816:	00000073          	ecall
ffffffffc020181a:	87aa                	mv	a5,a0
ffffffffc020181c:	8082                	ret

ffffffffc020181e <sbi_set_timer>:
ffffffffc020181e:	4781                	li	a5,0
ffffffffc0201820:	00005717          	auipc	a4,0x5
ffffffffc0201824:	c6073703          	ld	a4,-928(a4) # ffffffffc0206480 <SBI_SET_TIMER>
ffffffffc0201828:	88ba                	mv	a7,a4
ffffffffc020182a:	852a                	mv	a0,a0
ffffffffc020182c:	85be                	mv	a1,a5
ffffffffc020182e:	863e                	mv	a2,a5
ffffffffc0201830:	00000073          	ecall
ffffffffc0201834:	87aa                	mv	a5,a0
ffffffffc0201836:	8082                	ret

ffffffffc0201838 <sbi_console_getchar>:
ffffffffc0201838:	4501                	li	a0,0
ffffffffc020183a:	00004797          	auipc	a5,0x4
ffffffffc020183e:	7c67b783          	ld	a5,1990(a5) # ffffffffc0206000 <SBI_CONSOLE_GETCHAR>
ffffffffc0201842:	88be                	mv	a7,a5
ffffffffc0201844:	852a                	mv	a0,a0
ffffffffc0201846:	85aa                	mv	a1,a0
ffffffffc0201848:	862a                	mv	a2,a0
ffffffffc020184a:	00000073          	ecall
ffffffffc020184e:	852a                	mv	a0,a0
ffffffffc0201850:	2501                	sext.w	a0,a0
ffffffffc0201852:	8082                	ret

ffffffffc0201854 <readline>:
ffffffffc0201854:	715d                	addi	sp,sp,-80
ffffffffc0201856:	e486                	sd	ra,72(sp)
ffffffffc0201858:	e0a6                	sd	s1,64(sp)
ffffffffc020185a:	fc4a                	sd	s2,56(sp)
ffffffffc020185c:	f84e                	sd	s3,48(sp)
ffffffffc020185e:	f452                	sd	s4,40(sp)
ffffffffc0201860:	f056                	sd	s5,32(sp)
ffffffffc0201862:	ec5a                	sd	s6,24(sp)
ffffffffc0201864:	e85e                	sd	s7,16(sp)
ffffffffc0201866:	c901                	beqz	a0,ffffffffc0201876 <readline+0x22>
ffffffffc0201868:	85aa                	mv	a1,a0
ffffffffc020186a:	00001517          	auipc	a0,0x1
ffffffffc020186e:	bfe50513          	addi	a0,a0,-1026 # ffffffffc0202468 <buddy_system_pmm_manager+0x1b0>
ffffffffc0201872:	841fe0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc0201876:	4481                	li	s1,0
ffffffffc0201878:	497d                	li	s2,31
ffffffffc020187a:	49a1                	li	s3,8
ffffffffc020187c:	4aa9                	li	s5,10
ffffffffc020187e:	4b35                	li	s6,13
ffffffffc0201880:	00004b97          	auipc	s7,0x4
ffffffffc0201884:	7a8b8b93          	addi	s7,s7,1960 # ffffffffc0206028 <buf>
ffffffffc0201888:	3fe00a13          	li	s4,1022
ffffffffc020188c:	89ffe0ef          	jal	ra,ffffffffc020012a <getchar>
ffffffffc0201890:	00054a63          	bltz	a0,ffffffffc02018a4 <readline+0x50>
ffffffffc0201894:	00a95a63          	bge	s2,a0,ffffffffc02018a8 <readline+0x54>
ffffffffc0201898:	029a5263          	bge	s4,s1,ffffffffc02018bc <readline+0x68>
ffffffffc020189c:	88ffe0ef          	jal	ra,ffffffffc020012a <getchar>
ffffffffc02018a0:	fe055ae3          	bgez	a0,ffffffffc0201894 <readline+0x40>
ffffffffc02018a4:	4501                	li	a0,0
ffffffffc02018a6:	a091                	j	ffffffffc02018ea <readline+0x96>
ffffffffc02018a8:	03351463          	bne	a0,s3,ffffffffc02018d0 <readline+0x7c>
ffffffffc02018ac:	e8a9                	bnez	s1,ffffffffc02018fe <readline+0xaa>
ffffffffc02018ae:	87dfe0ef          	jal	ra,ffffffffc020012a <getchar>
ffffffffc02018b2:	fe0549e3          	bltz	a0,ffffffffc02018a4 <readline+0x50>
ffffffffc02018b6:	fea959e3          	bge	s2,a0,ffffffffc02018a8 <readline+0x54>
ffffffffc02018ba:	4481                	li	s1,0
ffffffffc02018bc:	e42a                	sd	a0,8(sp)
ffffffffc02018be:	82bfe0ef          	jal	ra,ffffffffc02000e8 <cputchar>
ffffffffc02018c2:	6522                	ld	a0,8(sp)
ffffffffc02018c4:	009b87b3          	add	a5,s7,s1
ffffffffc02018c8:	2485                	addiw	s1,s1,1
ffffffffc02018ca:	00a78023          	sb	a0,0(a5)
ffffffffc02018ce:	bf7d                	j	ffffffffc020188c <readline+0x38>
ffffffffc02018d0:	01550463          	beq	a0,s5,ffffffffc02018d8 <readline+0x84>
ffffffffc02018d4:	fb651ce3          	bne	a0,s6,ffffffffc020188c <readline+0x38>
ffffffffc02018d8:	811fe0ef          	jal	ra,ffffffffc02000e8 <cputchar>
ffffffffc02018dc:	00004517          	auipc	a0,0x4
ffffffffc02018e0:	74c50513          	addi	a0,a0,1868 # ffffffffc0206028 <buf>
ffffffffc02018e4:	94aa                	add	s1,s1,a0
ffffffffc02018e6:	00048023          	sb	zero,0(s1)
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
ffffffffc02018fe:	4521                	li	a0,8
ffffffffc0201900:	fe8fe0ef          	jal	ra,ffffffffc02000e8 <cputchar>
ffffffffc0201904:	34fd                	addiw	s1,s1,-1
ffffffffc0201906:	b759                	j	ffffffffc020188c <readline+0x38>
