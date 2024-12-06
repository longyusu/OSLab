
bin/kernel:     file format elf64-littleriscv


Disassembly of section .text:

ffffffffc0200000 <kern_entry>:
ffffffffc0200000:	c02092b7          	lui	t0,0xc0209
ffffffffc0200004:	ffd0031b          	addiw	t1,zero,-3
ffffffffc0200008:	037a                	slli	t1,t1,0x1e
ffffffffc020000a:	406282b3          	sub	t0,t0,t1
ffffffffc020000e:	00c2d293          	srli	t0,t0,0xc
ffffffffc0200012:	fff0031b          	addiw	t1,zero,-1
ffffffffc0200016:	137e                	slli	t1,t1,0x3f
ffffffffc0200018:	0062e2b3          	or	t0,t0,t1
ffffffffc020001c:	18029073          	csrw	satp,t0
ffffffffc0200020:	12000073          	sfence.vma
ffffffffc0200024:	c0209137          	lui	sp,0xc0209
ffffffffc0200028:	c02002b7          	lui	t0,0xc0200
ffffffffc020002c:	03228293          	addi	t0,t0,50 # ffffffffc0200032 <kern_init>
ffffffffc0200030:	8282                	jr	t0

ffffffffc0200032 <kern_init>:
ffffffffc0200032:	0000a517          	auipc	a0,0xa
ffffffffc0200036:	02e50513          	addi	a0,a0,46 # ffffffffc020a060 <buf>
ffffffffc020003a:	00015617          	auipc	a2,0x15
ffffffffc020003e:	59260613          	addi	a2,a2,1426 # ffffffffc02155cc <end>
ffffffffc0200042:	1141                	addi	sp,sp,-16
ffffffffc0200044:	8e09                	sub	a2,a2,a0
ffffffffc0200046:	4581                	li	a1,0
ffffffffc0200048:	e406                	sd	ra,8(sp)
ffffffffc020004a:	58b040ef          	jal	ra,ffffffffc0204dd4 <memset>
ffffffffc020004e:	4a6000ef          	jal	ra,ffffffffc02004f4 <cons_init>
ffffffffc0200052:	00005597          	auipc	a1,0x5
ffffffffc0200056:	dd658593          	addi	a1,a1,-554 # ffffffffc0204e28 <etext+0x6>
ffffffffc020005a:	00005517          	auipc	a0,0x5
ffffffffc020005e:	dee50513          	addi	a0,a0,-530 # ffffffffc0204e48 <etext+0x26>
ffffffffc0200062:	11e000ef          	jal	ra,ffffffffc0200180 <cprintf>
ffffffffc0200066:	162000ef          	jal	ra,ffffffffc02001c8 <print_kerninfo>
ffffffffc020006a:	6e5010ef          	jal	ra,ffffffffc0201f4e <pmm_init>
ffffffffc020006e:	536000ef          	jal	ra,ffffffffc02005a4 <pic_init>
ffffffffc0200072:	5a4000ef          	jal	ra,ffffffffc0200616 <idt_init>
ffffffffc0200076:	207030ef          	jal	ra,ffffffffc0203a7c <vmm_init>
ffffffffc020007a:	574040ef          	jal	ra,ffffffffc02045ee <proc_init>
ffffffffc020007e:	4e8000ef          	jal	ra,ffffffffc0200566 <ide_init>
ffffffffc0200082:	3a9020ef          	jal	ra,ffffffffc0202c2a <swap_init>
ffffffffc0200086:	41c000ef          	jal	ra,ffffffffc02004a2 <clock_init>
ffffffffc020008a:	50e000ef          	jal	ra,ffffffffc0200598 <intr_enable>
ffffffffc020008e:	7ac040ef          	jal	ra,ffffffffc020483a <cpu_idle>

ffffffffc0200092 <readline>:
ffffffffc0200092:	715d                	addi	sp,sp,-80
ffffffffc0200094:	e486                	sd	ra,72(sp)
ffffffffc0200096:	e0a6                	sd	s1,64(sp)
ffffffffc0200098:	fc4a                	sd	s2,56(sp)
ffffffffc020009a:	f84e                	sd	s3,48(sp)
ffffffffc020009c:	f452                	sd	s4,40(sp)
ffffffffc020009e:	f056                	sd	s5,32(sp)
ffffffffc02000a0:	ec5a                	sd	s6,24(sp)
ffffffffc02000a2:	e85e                	sd	s7,16(sp)
ffffffffc02000a4:	c901                	beqz	a0,ffffffffc02000b4 <readline+0x22>
ffffffffc02000a6:	85aa                	mv	a1,a0
ffffffffc02000a8:	00005517          	auipc	a0,0x5
ffffffffc02000ac:	da850513          	addi	a0,a0,-600 # ffffffffc0204e50 <etext+0x2e>
ffffffffc02000b0:	0d0000ef          	jal	ra,ffffffffc0200180 <cprintf>
ffffffffc02000b4:	4481                	li	s1,0
ffffffffc02000b6:	497d                	li	s2,31
ffffffffc02000b8:	49a1                	li	s3,8
ffffffffc02000ba:	4aa9                	li	s5,10
ffffffffc02000bc:	4b35                	li	s6,13
ffffffffc02000be:	0000ab97          	auipc	s7,0xa
ffffffffc02000c2:	fa2b8b93          	addi	s7,s7,-94 # ffffffffc020a060 <buf>
ffffffffc02000c6:	3fe00a13          	li	s4,1022
ffffffffc02000ca:	0ee000ef          	jal	ra,ffffffffc02001b8 <getchar>
ffffffffc02000ce:	00054a63          	bltz	a0,ffffffffc02000e2 <readline+0x50>
ffffffffc02000d2:	00a95a63          	bge	s2,a0,ffffffffc02000e6 <readline+0x54>
ffffffffc02000d6:	029a5263          	bge	s4,s1,ffffffffc02000fa <readline+0x68>
ffffffffc02000da:	0de000ef          	jal	ra,ffffffffc02001b8 <getchar>
ffffffffc02000de:	fe055ae3          	bgez	a0,ffffffffc02000d2 <readline+0x40>
ffffffffc02000e2:	4501                	li	a0,0
ffffffffc02000e4:	a091                	j	ffffffffc0200128 <readline+0x96>
ffffffffc02000e6:	03351463          	bne	a0,s3,ffffffffc020010e <readline+0x7c>
ffffffffc02000ea:	e8a9                	bnez	s1,ffffffffc020013c <readline+0xaa>
ffffffffc02000ec:	0cc000ef          	jal	ra,ffffffffc02001b8 <getchar>
ffffffffc02000f0:	fe0549e3          	bltz	a0,ffffffffc02000e2 <readline+0x50>
ffffffffc02000f4:	fea959e3          	bge	s2,a0,ffffffffc02000e6 <readline+0x54>
ffffffffc02000f8:	4481                	li	s1,0
ffffffffc02000fa:	e42a                	sd	a0,8(sp)
ffffffffc02000fc:	0ba000ef          	jal	ra,ffffffffc02001b6 <cputchar>
ffffffffc0200100:	6522                	ld	a0,8(sp)
ffffffffc0200102:	009b87b3          	add	a5,s7,s1
ffffffffc0200106:	2485                	addiw	s1,s1,1
ffffffffc0200108:	00a78023          	sb	a0,0(a5)
ffffffffc020010c:	bf7d                	j	ffffffffc02000ca <readline+0x38>
ffffffffc020010e:	01550463          	beq	a0,s5,ffffffffc0200116 <readline+0x84>
ffffffffc0200112:	fb651ce3          	bne	a0,s6,ffffffffc02000ca <readline+0x38>
ffffffffc0200116:	0a0000ef          	jal	ra,ffffffffc02001b6 <cputchar>
ffffffffc020011a:	0000a517          	auipc	a0,0xa
ffffffffc020011e:	f4650513          	addi	a0,a0,-186 # ffffffffc020a060 <buf>
ffffffffc0200122:	94aa                	add	s1,s1,a0
ffffffffc0200124:	00048023          	sb	zero,0(s1)
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
ffffffffc020013c:	4521                	li	a0,8
ffffffffc020013e:	078000ef          	jal	ra,ffffffffc02001b6 <cputchar>
ffffffffc0200142:	34fd                	addiw	s1,s1,-1
ffffffffc0200144:	b759                	j	ffffffffc02000ca <readline+0x38>

ffffffffc0200146 <cputch>:
ffffffffc0200146:	1141                	addi	sp,sp,-16
ffffffffc0200148:	e022                	sd	s0,0(sp)
ffffffffc020014a:	e406                	sd	ra,8(sp)
ffffffffc020014c:	842e                	mv	s0,a1
ffffffffc020014e:	3a8000ef          	jal	ra,ffffffffc02004f6 <cons_putc>
ffffffffc0200152:	401c                	lw	a5,0(s0)
ffffffffc0200154:	60a2                	ld	ra,8(sp)
ffffffffc0200156:	2785                	addiw	a5,a5,1
ffffffffc0200158:	c01c                	sw	a5,0(s0)
ffffffffc020015a:	6402                	ld	s0,0(sp)
ffffffffc020015c:	0141                	addi	sp,sp,16
ffffffffc020015e:	8082                	ret

ffffffffc0200160 <vcprintf>:
ffffffffc0200160:	1101                	addi	sp,sp,-32
ffffffffc0200162:	862a                	mv	a2,a0
ffffffffc0200164:	86ae                	mv	a3,a1
ffffffffc0200166:	00000517          	auipc	a0,0x0
ffffffffc020016a:	fe050513          	addi	a0,a0,-32 # ffffffffc0200146 <cputch>
ffffffffc020016e:	006c                	addi	a1,sp,12
ffffffffc0200170:	ec06                	sd	ra,24(sp)
ffffffffc0200172:	c602                	sw	zero,12(sp)
ffffffffc0200174:	063040ef          	jal	ra,ffffffffc02049d6 <vprintfmt>
ffffffffc0200178:	60e2                	ld	ra,24(sp)
ffffffffc020017a:	4532                	lw	a0,12(sp)
ffffffffc020017c:	6105                	addi	sp,sp,32
ffffffffc020017e:	8082                	ret

ffffffffc0200180 <cprintf>:
ffffffffc0200180:	711d                	addi	sp,sp,-96
ffffffffc0200182:	02810313          	addi	t1,sp,40 # ffffffffc0209028 <boot_page_table_sv39+0x28>
ffffffffc0200186:	8e2a                	mv	t3,a0
ffffffffc0200188:	f42e                	sd	a1,40(sp)
ffffffffc020018a:	f832                	sd	a2,48(sp)
ffffffffc020018c:	fc36                	sd	a3,56(sp)
ffffffffc020018e:	00000517          	auipc	a0,0x0
ffffffffc0200192:	fb850513          	addi	a0,a0,-72 # ffffffffc0200146 <cputch>
ffffffffc0200196:	004c                	addi	a1,sp,4
ffffffffc0200198:	869a                	mv	a3,t1
ffffffffc020019a:	8672                	mv	a2,t3
ffffffffc020019c:	ec06                	sd	ra,24(sp)
ffffffffc020019e:	e0ba                	sd	a4,64(sp)
ffffffffc02001a0:	e4be                	sd	a5,72(sp)
ffffffffc02001a2:	e8c2                	sd	a6,80(sp)
ffffffffc02001a4:	ecc6                	sd	a7,88(sp)
ffffffffc02001a6:	e41a                	sd	t1,8(sp)
ffffffffc02001a8:	c202                	sw	zero,4(sp)
ffffffffc02001aa:	02d040ef          	jal	ra,ffffffffc02049d6 <vprintfmt>
ffffffffc02001ae:	60e2                	ld	ra,24(sp)
ffffffffc02001b0:	4512                	lw	a0,4(sp)
ffffffffc02001b2:	6125                	addi	sp,sp,96
ffffffffc02001b4:	8082                	ret

ffffffffc02001b6 <cputchar>:
ffffffffc02001b6:	a681                	j	ffffffffc02004f6 <cons_putc>

ffffffffc02001b8 <getchar>:
ffffffffc02001b8:	1141                	addi	sp,sp,-16
ffffffffc02001ba:	e406                	sd	ra,8(sp)
ffffffffc02001bc:	36e000ef          	jal	ra,ffffffffc020052a <cons_getc>
ffffffffc02001c0:	dd75                	beqz	a0,ffffffffc02001bc <getchar+0x4>
ffffffffc02001c2:	60a2                	ld	ra,8(sp)
ffffffffc02001c4:	0141                	addi	sp,sp,16
ffffffffc02001c6:	8082                	ret

ffffffffc02001c8 <print_kerninfo>:
ffffffffc02001c8:	1141                	addi	sp,sp,-16
ffffffffc02001ca:	00005517          	auipc	a0,0x5
ffffffffc02001ce:	c8e50513          	addi	a0,a0,-882 # ffffffffc0204e58 <etext+0x36>
ffffffffc02001d2:	e406                	sd	ra,8(sp)
ffffffffc02001d4:	fadff0ef          	jal	ra,ffffffffc0200180 <cprintf>
ffffffffc02001d8:	00000597          	auipc	a1,0x0
ffffffffc02001dc:	e5a58593          	addi	a1,a1,-422 # ffffffffc0200032 <kern_init>
ffffffffc02001e0:	00005517          	auipc	a0,0x5
ffffffffc02001e4:	c9850513          	addi	a0,a0,-872 # ffffffffc0204e78 <etext+0x56>
ffffffffc02001e8:	f99ff0ef          	jal	ra,ffffffffc0200180 <cprintf>
ffffffffc02001ec:	00005597          	auipc	a1,0x5
ffffffffc02001f0:	c3658593          	addi	a1,a1,-970 # ffffffffc0204e22 <etext>
ffffffffc02001f4:	00005517          	auipc	a0,0x5
ffffffffc02001f8:	ca450513          	addi	a0,a0,-860 # ffffffffc0204e98 <etext+0x76>
ffffffffc02001fc:	f85ff0ef          	jal	ra,ffffffffc0200180 <cprintf>
ffffffffc0200200:	0000a597          	auipc	a1,0xa
ffffffffc0200204:	e6058593          	addi	a1,a1,-416 # ffffffffc020a060 <buf>
ffffffffc0200208:	00005517          	auipc	a0,0x5
ffffffffc020020c:	cb050513          	addi	a0,a0,-848 # ffffffffc0204eb8 <etext+0x96>
ffffffffc0200210:	f71ff0ef          	jal	ra,ffffffffc0200180 <cprintf>
ffffffffc0200214:	00015597          	auipc	a1,0x15
ffffffffc0200218:	3b858593          	addi	a1,a1,952 # ffffffffc02155cc <end>
ffffffffc020021c:	00005517          	auipc	a0,0x5
ffffffffc0200220:	cbc50513          	addi	a0,a0,-836 # ffffffffc0204ed8 <etext+0xb6>
ffffffffc0200224:	f5dff0ef          	jal	ra,ffffffffc0200180 <cprintf>
ffffffffc0200228:	00015597          	auipc	a1,0x15
ffffffffc020022c:	7a358593          	addi	a1,a1,1955 # ffffffffc02159cb <end+0x3ff>
ffffffffc0200230:	00000797          	auipc	a5,0x0
ffffffffc0200234:	e0278793          	addi	a5,a5,-510 # ffffffffc0200032 <kern_init>
ffffffffc0200238:	40f587b3          	sub	a5,a1,a5
ffffffffc020023c:	43f7d593          	srai	a1,a5,0x3f
ffffffffc0200240:	60a2                	ld	ra,8(sp)
ffffffffc0200242:	3ff5f593          	andi	a1,a1,1023
ffffffffc0200246:	95be                	add	a1,a1,a5
ffffffffc0200248:	85a9                	srai	a1,a1,0xa
ffffffffc020024a:	00005517          	auipc	a0,0x5
ffffffffc020024e:	cae50513          	addi	a0,a0,-850 # ffffffffc0204ef8 <etext+0xd6>
ffffffffc0200252:	0141                	addi	sp,sp,16
ffffffffc0200254:	b735                	j	ffffffffc0200180 <cprintf>

ffffffffc0200256 <print_stackframe>:
ffffffffc0200256:	1141                	addi	sp,sp,-16
ffffffffc0200258:	00005617          	auipc	a2,0x5
ffffffffc020025c:	cd060613          	addi	a2,a2,-816 # ffffffffc0204f28 <etext+0x106>
ffffffffc0200260:	04d00593          	li	a1,77
ffffffffc0200264:	00005517          	auipc	a0,0x5
ffffffffc0200268:	cdc50513          	addi	a0,a0,-804 # ffffffffc0204f40 <etext+0x11e>
ffffffffc020026c:	e406                	sd	ra,8(sp)
ffffffffc020026e:	1d8000ef          	jal	ra,ffffffffc0200446 <__panic>

ffffffffc0200272 <mon_help>:
ffffffffc0200272:	1141                	addi	sp,sp,-16
ffffffffc0200274:	00005617          	auipc	a2,0x5
ffffffffc0200278:	ce460613          	addi	a2,a2,-796 # ffffffffc0204f58 <etext+0x136>
ffffffffc020027c:	00005597          	auipc	a1,0x5
ffffffffc0200280:	cfc58593          	addi	a1,a1,-772 # ffffffffc0204f78 <etext+0x156>
ffffffffc0200284:	00005517          	auipc	a0,0x5
ffffffffc0200288:	cfc50513          	addi	a0,a0,-772 # ffffffffc0204f80 <etext+0x15e>
ffffffffc020028c:	e406                	sd	ra,8(sp)
ffffffffc020028e:	ef3ff0ef          	jal	ra,ffffffffc0200180 <cprintf>
ffffffffc0200292:	00005617          	auipc	a2,0x5
ffffffffc0200296:	cfe60613          	addi	a2,a2,-770 # ffffffffc0204f90 <etext+0x16e>
ffffffffc020029a:	00005597          	auipc	a1,0x5
ffffffffc020029e:	d1e58593          	addi	a1,a1,-738 # ffffffffc0204fb8 <etext+0x196>
ffffffffc02002a2:	00005517          	auipc	a0,0x5
ffffffffc02002a6:	cde50513          	addi	a0,a0,-802 # ffffffffc0204f80 <etext+0x15e>
ffffffffc02002aa:	ed7ff0ef          	jal	ra,ffffffffc0200180 <cprintf>
ffffffffc02002ae:	00005617          	auipc	a2,0x5
ffffffffc02002b2:	d1a60613          	addi	a2,a2,-742 # ffffffffc0204fc8 <etext+0x1a6>
ffffffffc02002b6:	00005597          	auipc	a1,0x5
ffffffffc02002ba:	d3258593          	addi	a1,a1,-718 # ffffffffc0204fe8 <etext+0x1c6>
ffffffffc02002be:	00005517          	auipc	a0,0x5
ffffffffc02002c2:	cc250513          	addi	a0,a0,-830 # ffffffffc0204f80 <etext+0x15e>
ffffffffc02002c6:	ebbff0ef          	jal	ra,ffffffffc0200180 <cprintf>
ffffffffc02002ca:	60a2                	ld	ra,8(sp)
ffffffffc02002cc:	4501                	li	a0,0
ffffffffc02002ce:	0141                	addi	sp,sp,16
ffffffffc02002d0:	8082                	ret

ffffffffc02002d2 <mon_kerninfo>:
ffffffffc02002d2:	1141                	addi	sp,sp,-16
ffffffffc02002d4:	e406                	sd	ra,8(sp)
ffffffffc02002d6:	ef3ff0ef          	jal	ra,ffffffffc02001c8 <print_kerninfo>
ffffffffc02002da:	60a2                	ld	ra,8(sp)
ffffffffc02002dc:	4501                	li	a0,0
ffffffffc02002de:	0141                	addi	sp,sp,16
ffffffffc02002e0:	8082                	ret

ffffffffc02002e2 <mon_backtrace>:
ffffffffc02002e2:	1141                	addi	sp,sp,-16
ffffffffc02002e4:	e406                	sd	ra,8(sp)
ffffffffc02002e6:	f71ff0ef          	jal	ra,ffffffffc0200256 <print_stackframe>
ffffffffc02002ea:	60a2                	ld	ra,8(sp)
ffffffffc02002ec:	4501                	li	a0,0
ffffffffc02002ee:	0141                	addi	sp,sp,16
ffffffffc02002f0:	8082                	ret

ffffffffc02002f2 <kmonitor>:
ffffffffc02002f2:	7115                	addi	sp,sp,-224
ffffffffc02002f4:	ed5e                	sd	s7,152(sp)
ffffffffc02002f6:	8baa                	mv	s7,a0
ffffffffc02002f8:	00005517          	auipc	a0,0x5
ffffffffc02002fc:	d0050513          	addi	a0,a0,-768 # ffffffffc0204ff8 <etext+0x1d6>
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
ffffffffc0200316:	e6bff0ef          	jal	ra,ffffffffc0200180 <cprintf>
ffffffffc020031a:	00005517          	auipc	a0,0x5
ffffffffc020031e:	d0650513          	addi	a0,a0,-762 # ffffffffc0205020 <etext+0x1fe>
ffffffffc0200322:	e5fff0ef          	jal	ra,ffffffffc0200180 <cprintf>
ffffffffc0200326:	000b8563          	beqz	s7,ffffffffc0200330 <kmonitor+0x3e>
ffffffffc020032a:	855e                	mv	a0,s7
ffffffffc020032c:	4d0000ef          	jal	ra,ffffffffc02007fc <print_trapframe>
ffffffffc0200330:	4501                	li	a0,0
ffffffffc0200332:	4581                	li	a1,0
ffffffffc0200334:	4601                	li	a2,0
ffffffffc0200336:	48a1                	li	a7,8
ffffffffc0200338:	00000073          	ecall
ffffffffc020033c:	00005c17          	auipc	s8,0x5
ffffffffc0200340:	d54c0c13          	addi	s8,s8,-684 # ffffffffc0205090 <commands>
ffffffffc0200344:	00005917          	auipc	s2,0x5
ffffffffc0200348:	d0490913          	addi	s2,s2,-764 # ffffffffc0205048 <etext+0x226>
ffffffffc020034c:	00005497          	auipc	s1,0x5
ffffffffc0200350:	d0448493          	addi	s1,s1,-764 # ffffffffc0205050 <etext+0x22e>
ffffffffc0200354:	49bd                	li	s3,15
ffffffffc0200356:	00005b17          	auipc	s6,0x5
ffffffffc020035a:	d02b0b13          	addi	s6,s6,-766 # ffffffffc0205058 <etext+0x236>
ffffffffc020035e:	00005a17          	auipc	s4,0x5
ffffffffc0200362:	c1aa0a13          	addi	s4,s4,-998 # ffffffffc0204f78 <etext+0x156>
ffffffffc0200366:	4a8d                	li	s5,3
ffffffffc0200368:	854a                	mv	a0,s2
ffffffffc020036a:	d29ff0ef          	jal	ra,ffffffffc0200092 <readline>
ffffffffc020036e:	842a                	mv	s0,a0
ffffffffc0200370:	dd65                	beqz	a0,ffffffffc0200368 <kmonitor+0x76>
ffffffffc0200372:	00054583          	lbu	a1,0(a0)
ffffffffc0200376:	4c81                	li	s9,0
ffffffffc0200378:	e1bd                	bnez	a1,ffffffffc02003de <kmonitor+0xec>
ffffffffc020037a:	fe0c87e3          	beqz	s9,ffffffffc0200368 <kmonitor+0x76>
ffffffffc020037e:	6582                	ld	a1,0(sp)
ffffffffc0200380:	00005d17          	auipc	s10,0x5
ffffffffc0200384:	d10d0d13          	addi	s10,s10,-752 # ffffffffc0205090 <commands>
ffffffffc0200388:	8552                	mv	a0,s4
ffffffffc020038a:	4401                	li	s0,0
ffffffffc020038c:	0d61                	addi	s10,s10,24
ffffffffc020038e:	213040ef          	jal	ra,ffffffffc0204da0 <strcmp>
ffffffffc0200392:	c919                	beqz	a0,ffffffffc02003a8 <kmonitor+0xb6>
ffffffffc0200394:	2405                	addiw	s0,s0,1
ffffffffc0200396:	0b540063          	beq	s0,s5,ffffffffc0200436 <kmonitor+0x144>
ffffffffc020039a:	000d3503          	ld	a0,0(s10)
ffffffffc020039e:	6582                	ld	a1,0(sp)
ffffffffc02003a0:	0d61                	addi	s10,s10,24
ffffffffc02003a2:	1ff040ef          	jal	ra,ffffffffc0204da0 <strcmp>
ffffffffc02003a6:	f57d                	bnez	a0,ffffffffc0200394 <kmonitor+0xa2>
ffffffffc02003a8:	00141793          	slli	a5,s0,0x1
ffffffffc02003ac:	97a2                	add	a5,a5,s0
ffffffffc02003ae:	078e                	slli	a5,a5,0x3
ffffffffc02003b0:	97e2                	add	a5,a5,s8
ffffffffc02003b2:	6b9c                	ld	a5,16(a5)
ffffffffc02003b4:	865e                	mv	a2,s7
ffffffffc02003b6:	002c                	addi	a1,sp,8
ffffffffc02003b8:	fffc851b          	addiw	a0,s9,-1
ffffffffc02003bc:	9782                	jalr	a5
ffffffffc02003be:	fa0555e3          	bgez	a0,ffffffffc0200368 <kmonitor+0x76>
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
ffffffffc02003de:	8526                	mv	a0,s1
ffffffffc02003e0:	1df040ef          	jal	ra,ffffffffc0204dbe <strchr>
ffffffffc02003e4:	c901                	beqz	a0,ffffffffc02003f4 <kmonitor+0x102>
ffffffffc02003e6:	00144583          	lbu	a1,1(s0)
ffffffffc02003ea:	00040023          	sb	zero,0(s0)
ffffffffc02003ee:	0405                	addi	s0,s0,1
ffffffffc02003f0:	d5c9                	beqz	a1,ffffffffc020037a <kmonitor+0x88>
ffffffffc02003f2:	b7f5                	j	ffffffffc02003de <kmonitor+0xec>
ffffffffc02003f4:	00044783          	lbu	a5,0(s0)
ffffffffc02003f8:	d3c9                	beqz	a5,ffffffffc020037a <kmonitor+0x88>
ffffffffc02003fa:	033c8963          	beq	s9,s3,ffffffffc020042c <kmonitor+0x13a>
ffffffffc02003fe:	003c9793          	slli	a5,s9,0x3
ffffffffc0200402:	0118                	addi	a4,sp,128
ffffffffc0200404:	97ba                	add	a5,a5,a4
ffffffffc0200406:	f887b023          	sd	s0,-128(a5)
ffffffffc020040a:	00044583          	lbu	a1,0(s0)
ffffffffc020040e:	2c85                	addiw	s9,s9,1
ffffffffc0200410:	e591                	bnez	a1,ffffffffc020041c <kmonitor+0x12a>
ffffffffc0200412:	b7b5                	j	ffffffffc020037e <kmonitor+0x8c>
ffffffffc0200414:	00144583          	lbu	a1,1(s0)
ffffffffc0200418:	0405                	addi	s0,s0,1
ffffffffc020041a:	d1a5                	beqz	a1,ffffffffc020037a <kmonitor+0x88>
ffffffffc020041c:	8526                	mv	a0,s1
ffffffffc020041e:	1a1040ef          	jal	ra,ffffffffc0204dbe <strchr>
ffffffffc0200422:	d96d                	beqz	a0,ffffffffc0200414 <kmonitor+0x122>
ffffffffc0200424:	00044583          	lbu	a1,0(s0)
ffffffffc0200428:	d9a9                	beqz	a1,ffffffffc020037a <kmonitor+0x88>
ffffffffc020042a:	bf55                	j	ffffffffc02003de <kmonitor+0xec>
ffffffffc020042c:	45c1                	li	a1,16
ffffffffc020042e:	855a                	mv	a0,s6
ffffffffc0200430:	d51ff0ef          	jal	ra,ffffffffc0200180 <cprintf>
ffffffffc0200434:	b7e9                	j	ffffffffc02003fe <kmonitor+0x10c>
ffffffffc0200436:	6582                	ld	a1,0(sp)
ffffffffc0200438:	00005517          	auipc	a0,0x5
ffffffffc020043c:	c4050513          	addi	a0,a0,-960 # ffffffffc0205078 <etext+0x256>
ffffffffc0200440:	d41ff0ef          	jal	ra,ffffffffc0200180 <cprintf>
ffffffffc0200444:	b715                	j	ffffffffc0200368 <kmonitor+0x76>

ffffffffc0200446 <__panic>:
ffffffffc0200446:	00015317          	auipc	t1,0x15
ffffffffc020044a:	0f230313          	addi	t1,t1,242 # ffffffffc0215538 <is_panic>
ffffffffc020044e:	00032e03          	lw	t3,0(t1)
ffffffffc0200452:	715d                	addi	sp,sp,-80
ffffffffc0200454:	ec06                	sd	ra,24(sp)
ffffffffc0200456:	e822                	sd	s0,16(sp)
ffffffffc0200458:	f436                	sd	a3,40(sp)
ffffffffc020045a:	f83a                	sd	a4,48(sp)
ffffffffc020045c:	fc3e                	sd	a5,56(sp)
ffffffffc020045e:	e0c2                	sd	a6,64(sp)
ffffffffc0200460:	e4c6                	sd	a7,72(sp)
ffffffffc0200462:	020e1a63          	bnez	t3,ffffffffc0200496 <__panic+0x50>
ffffffffc0200466:	4785                	li	a5,1
ffffffffc0200468:	00f32023          	sw	a5,0(t1)
ffffffffc020046c:	8432                	mv	s0,a2
ffffffffc020046e:	103c                	addi	a5,sp,40
ffffffffc0200470:	862e                	mv	a2,a1
ffffffffc0200472:	85aa                	mv	a1,a0
ffffffffc0200474:	00005517          	auipc	a0,0x5
ffffffffc0200478:	c6450513          	addi	a0,a0,-924 # ffffffffc02050d8 <commands+0x48>
ffffffffc020047c:	e43e                	sd	a5,8(sp)
ffffffffc020047e:	d03ff0ef          	jal	ra,ffffffffc0200180 <cprintf>
ffffffffc0200482:	65a2                	ld	a1,8(sp)
ffffffffc0200484:	8522                	mv	a0,s0
ffffffffc0200486:	cdbff0ef          	jal	ra,ffffffffc0200160 <vcprintf>
ffffffffc020048a:	00006517          	auipc	a0,0x6
ffffffffc020048e:	bbe50513          	addi	a0,a0,-1090 # ffffffffc0206048 <default_pmm_manager+0x4d0>
ffffffffc0200492:	cefff0ef          	jal	ra,ffffffffc0200180 <cprintf>
ffffffffc0200496:	108000ef          	jal	ra,ffffffffc020059e <intr_disable>
ffffffffc020049a:	4501                	li	a0,0
ffffffffc020049c:	e57ff0ef          	jal	ra,ffffffffc02002f2 <kmonitor>
ffffffffc02004a0:	bfed                	j	ffffffffc020049a <__panic+0x54>

ffffffffc02004a2 <clock_init>:
ffffffffc02004a2:	67e1                	lui	a5,0x18
ffffffffc02004a4:	6a078793          	addi	a5,a5,1696 # 186a0 <kern_entry-0xffffffffc01e7960>
ffffffffc02004a8:	00015717          	auipc	a4,0x15
ffffffffc02004ac:	0af73023          	sd	a5,160(a4) # ffffffffc0215548 <timebase>
ffffffffc02004b0:	c0102573          	rdtime	a0
ffffffffc02004b4:	4581                	li	a1,0
ffffffffc02004b6:	953e                	add	a0,a0,a5
ffffffffc02004b8:	4601                	li	a2,0
ffffffffc02004ba:	4881                	li	a7,0
ffffffffc02004bc:	00000073          	ecall
ffffffffc02004c0:	02000793          	li	a5,32
ffffffffc02004c4:	1047a7f3          	csrrs	a5,sie,a5
ffffffffc02004c8:	00005517          	auipc	a0,0x5
ffffffffc02004cc:	c3050513          	addi	a0,a0,-976 # ffffffffc02050f8 <commands+0x68>
ffffffffc02004d0:	00015797          	auipc	a5,0x15
ffffffffc02004d4:	0607b823          	sd	zero,112(a5) # ffffffffc0215540 <ticks>
ffffffffc02004d8:	b165                	j	ffffffffc0200180 <cprintf>

ffffffffc02004da <clock_set_next_event>:
ffffffffc02004da:	c0102573          	rdtime	a0
ffffffffc02004de:	00015797          	auipc	a5,0x15
ffffffffc02004e2:	06a7b783          	ld	a5,106(a5) # ffffffffc0215548 <timebase>
ffffffffc02004e6:	953e                	add	a0,a0,a5
ffffffffc02004e8:	4581                	li	a1,0
ffffffffc02004ea:	4601                	li	a2,0
ffffffffc02004ec:	4881                	li	a7,0
ffffffffc02004ee:	00000073          	ecall
ffffffffc02004f2:	8082                	ret

ffffffffc02004f4 <cons_init>:
ffffffffc02004f4:	8082                	ret

ffffffffc02004f6 <cons_putc>:
ffffffffc02004f6:	100027f3          	csrr	a5,sstatus
ffffffffc02004fa:	8b89                	andi	a5,a5,2
ffffffffc02004fc:	0ff57513          	andi	a0,a0,255
ffffffffc0200500:	e799                	bnez	a5,ffffffffc020050e <cons_putc+0x18>
ffffffffc0200502:	4581                	li	a1,0
ffffffffc0200504:	4601                	li	a2,0
ffffffffc0200506:	4885                	li	a7,1
ffffffffc0200508:	00000073          	ecall
ffffffffc020050c:	8082                	ret
ffffffffc020050e:	1101                	addi	sp,sp,-32
ffffffffc0200510:	ec06                	sd	ra,24(sp)
ffffffffc0200512:	e42a                	sd	a0,8(sp)
ffffffffc0200514:	08a000ef          	jal	ra,ffffffffc020059e <intr_disable>
ffffffffc0200518:	6522                	ld	a0,8(sp)
ffffffffc020051a:	4581                	li	a1,0
ffffffffc020051c:	4601                	li	a2,0
ffffffffc020051e:	4885                	li	a7,1
ffffffffc0200520:	00000073          	ecall
ffffffffc0200524:	60e2                	ld	ra,24(sp)
ffffffffc0200526:	6105                	addi	sp,sp,32
ffffffffc0200528:	a885                	j	ffffffffc0200598 <intr_enable>

ffffffffc020052a <cons_getc>:
ffffffffc020052a:	100027f3          	csrr	a5,sstatus
ffffffffc020052e:	8b89                	andi	a5,a5,2
ffffffffc0200530:	eb89                	bnez	a5,ffffffffc0200542 <cons_getc+0x18>
ffffffffc0200532:	4501                	li	a0,0
ffffffffc0200534:	4581                	li	a1,0
ffffffffc0200536:	4601                	li	a2,0
ffffffffc0200538:	4889                	li	a7,2
ffffffffc020053a:	00000073          	ecall
ffffffffc020053e:	2501                	sext.w	a0,a0
ffffffffc0200540:	8082                	ret
ffffffffc0200542:	1101                	addi	sp,sp,-32
ffffffffc0200544:	ec06                	sd	ra,24(sp)
ffffffffc0200546:	058000ef          	jal	ra,ffffffffc020059e <intr_disable>
ffffffffc020054a:	4501                	li	a0,0
ffffffffc020054c:	4581                	li	a1,0
ffffffffc020054e:	4601                	li	a2,0
ffffffffc0200550:	4889                	li	a7,2
ffffffffc0200552:	00000073          	ecall
ffffffffc0200556:	2501                	sext.w	a0,a0
ffffffffc0200558:	e42a                	sd	a0,8(sp)
ffffffffc020055a:	03e000ef          	jal	ra,ffffffffc0200598 <intr_enable>
ffffffffc020055e:	60e2                	ld	ra,24(sp)
ffffffffc0200560:	6522                	ld	a0,8(sp)
ffffffffc0200562:	6105                	addi	sp,sp,32
ffffffffc0200564:	8082                	ret

ffffffffc0200566 <ide_init>:
ffffffffc0200566:	8082                	ret

ffffffffc0200568 <ide_device_valid>:
ffffffffc0200568:	00253513          	sltiu	a0,a0,2
ffffffffc020056c:	8082                	ret

ffffffffc020056e <ide_device_size>:
ffffffffc020056e:	03800513          	li	a0,56
ffffffffc0200572:	8082                	ret

ffffffffc0200574 <ide_write_secs>:
ffffffffc0200574:	0095979b          	slliw	a5,a1,0x9
ffffffffc0200578:	0000a517          	auipc	a0,0xa
ffffffffc020057c:	ee850513          	addi	a0,a0,-280 # ffffffffc020a460 <ide>
ffffffffc0200580:	1141                	addi	sp,sp,-16
ffffffffc0200582:	85b2                	mv	a1,a2
ffffffffc0200584:	953e                	add	a0,a0,a5
ffffffffc0200586:	00969613          	slli	a2,a3,0x9
ffffffffc020058a:	e406                	sd	ra,8(sp)
ffffffffc020058c:	05b040ef          	jal	ra,ffffffffc0204de6 <memcpy>
ffffffffc0200590:	60a2                	ld	ra,8(sp)
ffffffffc0200592:	4501                	li	a0,0
ffffffffc0200594:	0141                	addi	sp,sp,16
ffffffffc0200596:	8082                	ret

ffffffffc0200598 <intr_enable>:
ffffffffc0200598:	100167f3          	csrrsi	a5,sstatus,2
ffffffffc020059c:	8082                	ret

ffffffffc020059e <intr_disable>:
ffffffffc020059e:	100177f3          	csrrci	a5,sstatus,2
ffffffffc02005a2:	8082                	ret

ffffffffc02005a4 <pic_init>:
ffffffffc02005a4:	8082                	ret

ffffffffc02005a6 <pgfault_handler>:
ffffffffc02005a6:	10053783          	ld	a5,256(a0)
ffffffffc02005aa:	1141                	addi	sp,sp,-16
ffffffffc02005ac:	e022                	sd	s0,0(sp)
ffffffffc02005ae:	e406                	sd	ra,8(sp)
ffffffffc02005b0:	1007f793          	andi	a5,a5,256
ffffffffc02005b4:	11053583          	ld	a1,272(a0)
ffffffffc02005b8:	842a                	mv	s0,a0
ffffffffc02005ba:	05500613          	li	a2,85
ffffffffc02005be:	c399                	beqz	a5,ffffffffc02005c4 <pgfault_handler+0x1e>
ffffffffc02005c0:	04b00613          	li	a2,75
ffffffffc02005c4:	11843703          	ld	a4,280(s0)
ffffffffc02005c8:	47bd                	li	a5,15
ffffffffc02005ca:	05700693          	li	a3,87
ffffffffc02005ce:	00f70463          	beq	a4,a5,ffffffffc02005d6 <pgfault_handler+0x30>
ffffffffc02005d2:	05200693          	li	a3,82
ffffffffc02005d6:	00005517          	auipc	a0,0x5
ffffffffc02005da:	b4250513          	addi	a0,a0,-1214 # ffffffffc0205118 <commands+0x88>
ffffffffc02005de:	ba3ff0ef          	jal	ra,ffffffffc0200180 <cprintf>
ffffffffc02005e2:	00015517          	auipc	a0,0x15
ffffffffc02005e6:	fbe53503          	ld	a0,-66(a0) # ffffffffc02155a0 <check_mm_struct>
ffffffffc02005ea:	c911                	beqz	a0,ffffffffc02005fe <pgfault_handler+0x58>
ffffffffc02005ec:	11043603          	ld	a2,272(s0)
ffffffffc02005f0:	11842583          	lw	a1,280(s0)
ffffffffc02005f4:	6402                	ld	s0,0(sp)
ffffffffc02005f6:	60a2                	ld	ra,8(sp)
ffffffffc02005f8:	0141                	addi	sp,sp,16
ffffffffc02005fa:	2750306f          	j	ffffffffc020406e <do_pgfault>
ffffffffc02005fe:	00005617          	auipc	a2,0x5
ffffffffc0200602:	b3a60613          	addi	a2,a2,-1222 # ffffffffc0205138 <commands+0xa8>
ffffffffc0200606:	06200593          	li	a1,98
ffffffffc020060a:	00005517          	auipc	a0,0x5
ffffffffc020060e:	b4650513          	addi	a0,a0,-1210 # ffffffffc0205150 <commands+0xc0>
ffffffffc0200612:	e35ff0ef          	jal	ra,ffffffffc0200446 <__panic>

ffffffffc0200616 <idt_init>:
ffffffffc0200616:	14005073          	csrwi	sscratch,0
ffffffffc020061a:	00000797          	auipc	a5,0x0
ffffffffc020061e:	47a78793          	addi	a5,a5,1146 # ffffffffc0200a94 <__alltraps>
ffffffffc0200622:	10579073          	csrw	stvec,a5
ffffffffc0200626:	000407b7          	lui	a5,0x40
ffffffffc020062a:	1007a7f3          	csrrs	a5,sstatus,a5
ffffffffc020062e:	8082                	ret

ffffffffc0200630 <print_regs>:
ffffffffc0200630:	610c                	ld	a1,0(a0)
ffffffffc0200632:	1141                	addi	sp,sp,-16
ffffffffc0200634:	e022                	sd	s0,0(sp)
ffffffffc0200636:	842a                	mv	s0,a0
ffffffffc0200638:	00005517          	auipc	a0,0x5
ffffffffc020063c:	b3050513          	addi	a0,a0,-1232 # ffffffffc0205168 <commands+0xd8>
ffffffffc0200640:	e406                	sd	ra,8(sp)
ffffffffc0200642:	b3fff0ef          	jal	ra,ffffffffc0200180 <cprintf>
ffffffffc0200646:	640c                	ld	a1,8(s0)
ffffffffc0200648:	00005517          	auipc	a0,0x5
ffffffffc020064c:	b3850513          	addi	a0,a0,-1224 # ffffffffc0205180 <commands+0xf0>
ffffffffc0200650:	b31ff0ef          	jal	ra,ffffffffc0200180 <cprintf>
ffffffffc0200654:	680c                	ld	a1,16(s0)
ffffffffc0200656:	00005517          	auipc	a0,0x5
ffffffffc020065a:	b4250513          	addi	a0,a0,-1214 # ffffffffc0205198 <commands+0x108>
ffffffffc020065e:	b23ff0ef          	jal	ra,ffffffffc0200180 <cprintf>
ffffffffc0200662:	6c0c                	ld	a1,24(s0)
ffffffffc0200664:	00005517          	auipc	a0,0x5
ffffffffc0200668:	b4c50513          	addi	a0,a0,-1204 # ffffffffc02051b0 <commands+0x120>
ffffffffc020066c:	b15ff0ef          	jal	ra,ffffffffc0200180 <cprintf>
ffffffffc0200670:	700c                	ld	a1,32(s0)
ffffffffc0200672:	00005517          	auipc	a0,0x5
ffffffffc0200676:	b5650513          	addi	a0,a0,-1194 # ffffffffc02051c8 <commands+0x138>
ffffffffc020067a:	b07ff0ef          	jal	ra,ffffffffc0200180 <cprintf>
ffffffffc020067e:	740c                	ld	a1,40(s0)
ffffffffc0200680:	00005517          	auipc	a0,0x5
ffffffffc0200684:	b6050513          	addi	a0,a0,-1184 # ffffffffc02051e0 <commands+0x150>
ffffffffc0200688:	af9ff0ef          	jal	ra,ffffffffc0200180 <cprintf>
ffffffffc020068c:	780c                	ld	a1,48(s0)
ffffffffc020068e:	00005517          	auipc	a0,0x5
ffffffffc0200692:	b6a50513          	addi	a0,a0,-1174 # ffffffffc02051f8 <commands+0x168>
ffffffffc0200696:	aebff0ef          	jal	ra,ffffffffc0200180 <cprintf>
ffffffffc020069a:	7c0c                	ld	a1,56(s0)
ffffffffc020069c:	00005517          	auipc	a0,0x5
ffffffffc02006a0:	b7450513          	addi	a0,a0,-1164 # ffffffffc0205210 <commands+0x180>
ffffffffc02006a4:	addff0ef          	jal	ra,ffffffffc0200180 <cprintf>
ffffffffc02006a8:	602c                	ld	a1,64(s0)
ffffffffc02006aa:	00005517          	auipc	a0,0x5
ffffffffc02006ae:	b7e50513          	addi	a0,a0,-1154 # ffffffffc0205228 <commands+0x198>
ffffffffc02006b2:	acfff0ef          	jal	ra,ffffffffc0200180 <cprintf>
ffffffffc02006b6:	642c                	ld	a1,72(s0)
ffffffffc02006b8:	00005517          	auipc	a0,0x5
ffffffffc02006bc:	b8850513          	addi	a0,a0,-1144 # ffffffffc0205240 <commands+0x1b0>
ffffffffc02006c0:	ac1ff0ef          	jal	ra,ffffffffc0200180 <cprintf>
ffffffffc02006c4:	682c                	ld	a1,80(s0)
ffffffffc02006c6:	00005517          	auipc	a0,0x5
ffffffffc02006ca:	b9250513          	addi	a0,a0,-1134 # ffffffffc0205258 <commands+0x1c8>
ffffffffc02006ce:	ab3ff0ef          	jal	ra,ffffffffc0200180 <cprintf>
ffffffffc02006d2:	6c2c                	ld	a1,88(s0)
ffffffffc02006d4:	00005517          	auipc	a0,0x5
ffffffffc02006d8:	b9c50513          	addi	a0,a0,-1124 # ffffffffc0205270 <commands+0x1e0>
ffffffffc02006dc:	aa5ff0ef          	jal	ra,ffffffffc0200180 <cprintf>
ffffffffc02006e0:	702c                	ld	a1,96(s0)
ffffffffc02006e2:	00005517          	auipc	a0,0x5
ffffffffc02006e6:	ba650513          	addi	a0,a0,-1114 # ffffffffc0205288 <commands+0x1f8>
ffffffffc02006ea:	a97ff0ef          	jal	ra,ffffffffc0200180 <cprintf>
ffffffffc02006ee:	742c                	ld	a1,104(s0)
ffffffffc02006f0:	00005517          	auipc	a0,0x5
ffffffffc02006f4:	bb050513          	addi	a0,a0,-1104 # ffffffffc02052a0 <commands+0x210>
ffffffffc02006f8:	a89ff0ef          	jal	ra,ffffffffc0200180 <cprintf>
ffffffffc02006fc:	782c                	ld	a1,112(s0)
ffffffffc02006fe:	00005517          	auipc	a0,0x5
ffffffffc0200702:	bba50513          	addi	a0,a0,-1094 # ffffffffc02052b8 <commands+0x228>
ffffffffc0200706:	a7bff0ef          	jal	ra,ffffffffc0200180 <cprintf>
ffffffffc020070a:	7c2c                	ld	a1,120(s0)
ffffffffc020070c:	00005517          	auipc	a0,0x5
ffffffffc0200710:	bc450513          	addi	a0,a0,-1084 # ffffffffc02052d0 <commands+0x240>
ffffffffc0200714:	a6dff0ef          	jal	ra,ffffffffc0200180 <cprintf>
ffffffffc0200718:	604c                	ld	a1,128(s0)
ffffffffc020071a:	00005517          	auipc	a0,0x5
ffffffffc020071e:	bce50513          	addi	a0,a0,-1074 # ffffffffc02052e8 <commands+0x258>
ffffffffc0200722:	a5fff0ef          	jal	ra,ffffffffc0200180 <cprintf>
ffffffffc0200726:	644c                	ld	a1,136(s0)
ffffffffc0200728:	00005517          	auipc	a0,0x5
ffffffffc020072c:	bd850513          	addi	a0,a0,-1064 # ffffffffc0205300 <commands+0x270>
ffffffffc0200730:	a51ff0ef          	jal	ra,ffffffffc0200180 <cprintf>
ffffffffc0200734:	684c                	ld	a1,144(s0)
ffffffffc0200736:	00005517          	auipc	a0,0x5
ffffffffc020073a:	be250513          	addi	a0,a0,-1054 # ffffffffc0205318 <commands+0x288>
ffffffffc020073e:	a43ff0ef          	jal	ra,ffffffffc0200180 <cprintf>
ffffffffc0200742:	6c4c                	ld	a1,152(s0)
ffffffffc0200744:	00005517          	auipc	a0,0x5
ffffffffc0200748:	bec50513          	addi	a0,a0,-1044 # ffffffffc0205330 <commands+0x2a0>
ffffffffc020074c:	a35ff0ef          	jal	ra,ffffffffc0200180 <cprintf>
ffffffffc0200750:	704c                	ld	a1,160(s0)
ffffffffc0200752:	00005517          	auipc	a0,0x5
ffffffffc0200756:	bf650513          	addi	a0,a0,-1034 # ffffffffc0205348 <commands+0x2b8>
ffffffffc020075a:	a27ff0ef          	jal	ra,ffffffffc0200180 <cprintf>
ffffffffc020075e:	744c                	ld	a1,168(s0)
ffffffffc0200760:	00005517          	auipc	a0,0x5
ffffffffc0200764:	c0050513          	addi	a0,a0,-1024 # ffffffffc0205360 <commands+0x2d0>
ffffffffc0200768:	a19ff0ef          	jal	ra,ffffffffc0200180 <cprintf>
ffffffffc020076c:	784c                	ld	a1,176(s0)
ffffffffc020076e:	00005517          	auipc	a0,0x5
ffffffffc0200772:	c0a50513          	addi	a0,a0,-1014 # ffffffffc0205378 <commands+0x2e8>
ffffffffc0200776:	a0bff0ef          	jal	ra,ffffffffc0200180 <cprintf>
ffffffffc020077a:	7c4c                	ld	a1,184(s0)
ffffffffc020077c:	00005517          	auipc	a0,0x5
ffffffffc0200780:	c1450513          	addi	a0,a0,-1004 # ffffffffc0205390 <commands+0x300>
ffffffffc0200784:	9fdff0ef          	jal	ra,ffffffffc0200180 <cprintf>
ffffffffc0200788:	606c                	ld	a1,192(s0)
ffffffffc020078a:	00005517          	auipc	a0,0x5
ffffffffc020078e:	c1e50513          	addi	a0,a0,-994 # ffffffffc02053a8 <commands+0x318>
ffffffffc0200792:	9efff0ef          	jal	ra,ffffffffc0200180 <cprintf>
ffffffffc0200796:	646c                	ld	a1,200(s0)
ffffffffc0200798:	00005517          	auipc	a0,0x5
ffffffffc020079c:	c2850513          	addi	a0,a0,-984 # ffffffffc02053c0 <commands+0x330>
ffffffffc02007a0:	9e1ff0ef          	jal	ra,ffffffffc0200180 <cprintf>
ffffffffc02007a4:	686c                	ld	a1,208(s0)
ffffffffc02007a6:	00005517          	auipc	a0,0x5
ffffffffc02007aa:	c3250513          	addi	a0,a0,-974 # ffffffffc02053d8 <commands+0x348>
ffffffffc02007ae:	9d3ff0ef          	jal	ra,ffffffffc0200180 <cprintf>
ffffffffc02007b2:	6c6c                	ld	a1,216(s0)
ffffffffc02007b4:	00005517          	auipc	a0,0x5
ffffffffc02007b8:	c3c50513          	addi	a0,a0,-964 # ffffffffc02053f0 <commands+0x360>
ffffffffc02007bc:	9c5ff0ef          	jal	ra,ffffffffc0200180 <cprintf>
ffffffffc02007c0:	706c                	ld	a1,224(s0)
ffffffffc02007c2:	00005517          	auipc	a0,0x5
ffffffffc02007c6:	c4650513          	addi	a0,a0,-954 # ffffffffc0205408 <commands+0x378>
ffffffffc02007ca:	9b7ff0ef          	jal	ra,ffffffffc0200180 <cprintf>
ffffffffc02007ce:	746c                	ld	a1,232(s0)
ffffffffc02007d0:	00005517          	auipc	a0,0x5
ffffffffc02007d4:	c5050513          	addi	a0,a0,-944 # ffffffffc0205420 <commands+0x390>
ffffffffc02007d8:	9a9ff0ef          	jal	ra,ffffffffc0200180 <cprintf>
ffffffffc02007dc:	786c                	ld	a1,240(s0)
ffffffffc02007de:	00005517          	auipc	a0,0x5
ffffffffc02007e2:	c5a50513          	addi	a0,a0,-934 # ffffffffc0205438 <commands+0x3a8>
ffffffffc02007e6:	99bff0ef          	jal	ra,ffffffffc0200180 <cprintf>
ffffffffc02007ea:	7c6c                	ld	a1,248(s0)
ffffffffc02007ec:	6402                	ld	s0,0(sp)
ffffffffc02007ee:	60a2                	ld	ra,8(sp)
ffffffffc02007f0:	00005517          	auipc	a0,0x5
ffffffffc02007f4:	c6050513          	addi	a0,a0,-928 # ffffffffc0205450 <commands+0x3c0>
ffffffffc02007f8:	0141                	addi	sp,sp,16
ffffffffc02007fa:	b259                	j	ffffffffc0200180 <cprintf>

ffffffffc02007fc <print_trapframe>:
ffffffffc02007fc:	1141                	addi	sp,sp,-16
ffffffffc02007fe:	e022                	sd	s0,0(sp)
ffffffffc0200800:	85aa                	mv	a1,a0
ffffffffc0200802:	842a                	mv	s0,a0
ffffffffc0200804:	00005517          	auipc	a0,0x5
ffffffffc0200808:	c6450513          	addi	a0,a0,-924 # ffffffffc0205468 <commands+0x3d8>
ffffffffc020080c:	e406                	sd	ra,8(sp)
ffffffffc020080e:	973ff0ef          	jal	ra,ffffffffc0200180 <cprintf>
ffffffffc0200812:	8522                	mv	a0,s0
ffffffffc0200814:	e1dff0ef          	jal	ra,ffffffffc0200630 <print_regs>
ffffffffc0200818:	10043583          	ld	a1,256(s0)
ffffffffc020081c:	00005517          	auipc	a0,0x5
ffffffffc0200820:	c6450513          	addi	a0,a0,-924 # ffffffffc0205480 <commands+0x3f0>
ffffffffc0200824:	95dff0ef          	jal	ra,ffffffffc0200180 <cprintf>
ffffffffc0200828:	10843583          	ld	a1,264(s0)
ffffffffc020082c:	00005517          	auipc	a0,0x5
ffffffffc0200830:	c6c50513          	addi	a0,a0,-916 # ffffffffc0205498 <commands+0x408>
ffffffffc0200834:	94dff0ef          	jal	ra,ffffffffc0200180 <cprintf>
ffffffffc0200838:	11043583          	ld	a1,272(s0)
ffffffffc020083c:	00005517          	auipc	a0,0x5
ffffffffc0200840:	c7450513          	addi	a0,a0,-908 # ffffffffc02054b0 <commands+0x420>
ffffffffc0200844:	93dff0ef          	jal	ra,ffffffffc0200180 <cprintf>
ffffffffc0200848:	11843583          	ld	a1,280(s0)
ffffffffc020084c:	6402                	ld	s0,0(sp)
ffffffffc020084e:	60a2                	ld	ra,8(sp)
ffffffffc0200850:	00005517          	auipc	a0,0x5
ffffffffc0200854:	c7850513          	addi	a0,a0,-904 # ffffffffc02054c8 <commands+0x438>
ffffffffc0200858:	0141                	addi	sp,sp,16
ffffffffc020085a:	927ff06f          	j	ffffffffc0200180 <cprintf>

ffffffffc020085e <interrupt_handler>:
ffffffffc020085e:	11853783          	ld	a5,280(a0)
ffffffffc0200862:	472d                	li	a4,11
ffffffffc0200864:	0786                	slli	a5,a5,0x1
ffffffffc0200866:	8385                	srli	a5,a5,0x1
ffffffffc0200868:	06f76c63          	bltu	a4,a5,ffffffffc02008e0 <interrupt_handler+0x82>
ffffffffc020086c:	00005717          	auipc	a4,0x5
ffffffffc0200870:	d2470713          	addi	a4,a4,-732 # ffffffffc0205590 <commands+0x500>
ffffffffc0200874:	078a                	slli	a5,a5,0x2
ffffffffc0200876:	97ba                	add	a5,a5,a4
ffffffffc0200878:	439c                	lw	a5,0(a5)
ffffffffc020087a:	97ba                	add	a5,a5,a4
ffffffffc020087c:	8782                	jr	a5
ffffffffc020087e:	00005517          	auipc	a0,0x5
ffffffffc0200882:	cc250513          	addi	a0,a0,-830 # ffffffffc0205540 <commands+0x4b0>
ffffffffc0200886:	8fbff06f          	j	ffffffffc0200180 <cprintf>
ffffffffc020088a:	00005517          	auipc	a0,0x5
ffffffffc020088e:	c9650513          	addi	a0,a0,-874 # ffffffffc0205520 <commands+0x490>
ffffffffc0200892:	8efff06f          	j	ffffffffc0200180 <cprintf>
ffffffffc0200896:	00005517          	auipc	a0,0x5
ffffffffc020089a:	c4a50513          	addi	a0,a0,-950 # ffffffffc02054e0 <commands+0x450>
ffffffffc020089e:	8e3ff06f          	j	ffffffffc0200180 <cprintf>
ffffffffc02008a2:	00005517          	auipc	a0,0x5
ffffffffc02008a6:	c5e50513          	addi	a0,a0,-930 # ffffffffc0205500 <commands+0x470>
ffffffffc02008aa:	8d7ff06f          	j	ffffffffc0200180 <cprintf>
ffffffffc02008ae:	1141                	addi	sp,sp,-16
ffffffffc02008b0:	e406                	sd	ra,8(sp)
ffffffffc02008b2:	c29ff0ef          	jal	ra,ffffffffc02004da <clock_set_next_event>
ffffffffc02008b6:	00015697          	auipc	a3,0x15
ffffffffc02008ba:	c8a68693          	addi	a3,a3,-886 # ffffffffc0215540 <ticks>
ffffffffc02008be:	629c                	ld	a5,0(a3)
ffffffffc02008c0:	06400713          	li	a4,100
ffffffffc02008c4:	0785                	addi	a5,a5,1
ffffffffc02008c6:	02e7f733          	remu	a4,a5,a4
ffffffffc02008ca:	e29c                	sd	a5,0(a3)
ffffffffc02008cc:	cb19                	beqz	a4,ffffffffc02008e2 <interrupt_handler+0x84>
ffffffffc02008ce:	60a2                	ld	ra,8(sp)
ffffffffc02008d0:	0141                	addi	sp,sp,16
ffffffffc02008d2:	8082                	ret
ffffffffc02008d4:	00005517          	auipc	a0,0x5
ffffffffc02008d8:	c9c50513          	addi	a0,a0,-868 # ffffffffc0205570 <commands+0x4e0>
ffffffffc02008dc:	8a5ff06f          	j	ffffffffc0200180 <cprintf>
ffffffffc02008e0:	bf31                	j	ffffffffc02007fc <print_trapframe>
ffffffffc02008e2:	60a2                	ld	ra,8(sp)
ffffffffc02008e4:	06400593          	li	a1,100
ffffffffc02008e8:	00005517          	auipc	a0,0x5
ffffffffc02008ec:	c7850513          	addi	a0,a0,-904 # ffffffffc0205560 <commands+0x4d0>
ffffffffc02008f0:	0141                	addi	sp,sp,16
ffffffffc02008f2:	88fff06f          	j	ffffffffc0200180 <cprintf>

ffffffffc02008f6 <exception_handler>:
ffffffffc02008f6:	11853783          	ld	a5,280(a0)
ffffffffc02008fa:	1101                	addi	sp,sp,-32
ffffffffc02008fc:	e822                	sd	s0,16(sp)
ffffffffc02008fe:	ec06                	sd	ra,24(sp)
ffffffffc0200900:	e426                	sd	s1,8(sp)
ffffffffc0200902:	473d                	li	a4,15
ffffffffc0200904:	842a                	mv	s0,a0
ffffffffc0200906:	14f76a63          	bltu	a4,a5,ffffffffc0200a5a <exception_handler+0x164>
ffffffffc020090a:	00005717          	auipc	a4,0x5
ffffffffc020090e:	e6e70713          	addi	a4,a4,-402 # ffffffffc0205778 <commands+0x6e8>
ffffffffc0200912:	078a                	slli	a5,a5,0x2
ffffffffc0200914:	97ba                	add	a5,a5,a4
ffffffffc0200916:	439c                	lw	a5,0(a5)
ffffffffc0200918:	97ba                	add	a5,a5,a4
ffffffffc020091a:	8782                	jr	a5
ffffffffc020091c:	00005517          	auipc	a0,0x5
ffffffffc0200920:	e4450513          	addi	a0,a0,-444 # ffffffffc0205760 <commands+0x6d0>
ffffffffc0200924:	85dff0ef          	jal	ra,ffffffffc0200180 <cprintf>
ffffffffc0200928:	8522                	mv	a0,s0
ffffffffc020092a:	c7dff0ef          	jal	ra,ffffffffc02005a6 <pgfault_handler>
ffffffffc020092e:	84aa                	mv	s1,a0
ffffffffc0200930:	12051b63          	bnez	a0,ffffffffc0200a66 <exception_handler+0x170>
ffffffffc0200934:	60e2                	ld	ra,24(sp)
ffffffffc0200936:	6442                	ld	s0,16(sp)
ffffffffc0200938:	64a2                	ld	s1,8(sp)
ffffffffc020093a:	6105                	addi	sp,sp,32
ffffffffc020093c:	8082                	ret
ffffffffc020093e:	00005517          	auipc	a0,0x5
ffffffffc0200942:	c8250513          	addi	a0,a0,-894 # ffffffffc02055c0 <commands+0x530>
ffffffffc0200946:	6442                	ld	s0,16(sp)
ffffffffc0200948:	60e2                	ld	ra,24(sp)
ffffffffc020094a:	64a2                	ld	s1,8(sp)
ffffffffc020094c:	6105                	addi	sp,sp,32
ffffffffc020094e:	833ff06f          	j	ffffffffc0200180 <cprintf>
ffffffffc0200952:	00005517          	auipc	a0,0x5
ffffffffc0200956:	c8e50513          	addi	a0,a0,-882 # ffffffffc02055e0 <commands+0x550>
ffffffffc020095a:	b7f5                	j	ffffffffc0200946 <exception_handler+0x50>
ffffffffc020095c:	00005517          	auipc	a0,0x5
ffffffffc0200960:	ca450513          	addi	a0,a0,-860 # ffffffffc0205600 <commands+0x570>
ffffffffc0200964:	b7cd                	j	ffffffffc0200946 <exception_handler+0x50>
ffffffffc0200966:	00005517          	auipc	a0,0x5
ffffffffc020096a:	cb250513          	addi	a0,a0,-846 # ffffffffc0205618 <commands+0x588>
ffffffffc020096e:	bfe1                	j	ffffffffc0200946 <exception_handler+0x50>
ffffffffc0200970:	00005517          	auipc	a0,0x5
ffffffffc0200974:	cb850513          	addi	a0,a0,-840 # ffffffffc0205628 <commands+0x598>
ffffffffc0200978:	b7f9                	j	ffffffffc0200946 <exception_handler+0x50>
ffffffffc020097a:	00005517          	auipc	a0,0x5
ffffffffc020097e:	cce50513          	addi	a0,a0,-818 # ffffffffc0205648 <commands+0x5b8>
ffffffffc0200982:	ffeff0ef          	jal	ra,ffffffffc0200180 <cprintf>
ffffffffc0200986:	8522                	mv	a0,s0
ffffffffc0200988:	c1fff0ef          	jal	ra,ffffffffc02005a6 <pgfault_handler>
ffffffffc020098c:	84aa                	mv	s1,a0
ffffffffc020098e:	d15d                	beqz	a0,ffffffffc0200934 <exception_handler+0x3e>
ffffffffc0200990:	8522                	mv	a0,s0
ffffffffc0200992:	e6bff0ef          	jal	ra,ffffffffc02007fc <print_trapframe>
ffffffffc0200996:	86a6                	mv	a3,s1
ffffffffc0200998:	00005617          	auipc	a2,0x5
ffffffffc020099c:	cc860613          	addi	a2,a2,-824 # ffffffffc0205660 <commands+0x5d0>
ffffffffc02009a0:	0b300593          	li	a1,179
ffffffffc02009a4:	00004517          	auipc	a0,0x4
ffffffffc02009a8:	7ac50513          	addi	a0,a0,1964 # ffffffffc0205150 <commands+0xc0>
ffffffffc02009ac:	a9bff0ef          	jal	ra,ffffffffc0200446 <__panic>
ffffffffc02009b0:	00005517          	auipc	a0,0x5
ffffffffc02009b4:	cd050513          	addi	a0,a0,-816 # ffffffffc0205680 <commands+0x5f0>
ffffffffc02009b8:	b779                	j	ffffffffc0200946 <exception_handler+0x50>
ffffffffc02009ba:	00005517          	auipc	a0,0x5
ffffffffc02009be:	cde50513          	addi	a0,a0,-802 # ffffffffc0205698 <commands+0x608>
ffffffffc02009c2:	fbeff0ef          	jal	ra,ffffffffc0200180 <cprintf>
ffffffffc02009c6:	8522                	mv	a0,s0
ffffffffc02009c8:	bdfff0ef          	jal	ra,ffffffffc02005a6 <pgfault_handler>
ffffffffc02009cc:	84aa                	mv	s1,a0
ffffffffc02009ce:	d13d                	beqz	a0,ffffffffc0200934 <exception_handler+0x3e>
ffffffffc02009d0:	8522                	mv	a0,s0
ffffffffc02009d2:	e2bff0ef          	jal	ra,ffffffffc02007fc <print_trapframe>
ffffffffc02009d6:	86a6                	mv	a3,s1
ffffffffc02009d8:	00005617          	auipc	a2,0x5
ffffffffc02009dc:	c8860613          	addi	a2,a2,-888 # ffffffffc0205660 <commands+0x5d0>
ffffffffc02009e0:	0bd00593          	li	a1,189
ffffffffc02009e4:	00004517          	auipc	a0,0x4
ffffffffc02009e8:	76c50513          	addi	a0,a0,1900 # ffffffffc0205150 <commands+0xc0>
ffffffffc02009ec:	a5bff0ef          	jal	ra,ffffffffc0200446 <__panic>
ffffffffc02009f0:	00005517          	auipc	a0,0x5
ffffffffc02009f4:	cc050513          	addi	a0,a0,-832 # ffffffffc02056b0 <commands+0x620>
ffffffffc02009f8:	b7b9                	j	ffffffffc0200946 <exception_handler+0x50>
ffffffffc02009fa:	00005517          	auipc	a0,0x5
ffffffffc02009fe:	cd650513          	addi	a0,a0,-810 # ffffffffc02056d0 <commands+0x640>
ffffffffc0200a02:	b791                	j	ffffffffc0200946 <exception_handler+0x50>
ffffffffc0200a04:	00005517          	auipc	a0,0x5
ffffffffc0200a08:	cec50513          	addi	a0,a0,-788 # ffffffffc02056f0 <commands+0x660>
ffffffffc0200a0c:	bf2d                	j	ffffffffc0200946 <exception_handler+0x50>
ffffffffc0200a0e:	00005517          	auipc	a0,0x5
ffffffffc0200a12:	d0250513          	addi	a0,a0,-766 # ffffffffc0205710 <commands+0x680>
ffffffffc0200a16:	bf05                	j	ffffffffc0200946 <exception_handler+0x50>
ffffffffc0200a18:	00005517          	auipc	a0,0x5
ffffffffc0200a1c:	d1850513          	addi	a0,a0,-744 # ffffffffc0205730 <commands+0x6a0>
ffffffffc0200a20:	b71d                	j	ffffffffc0200946 <exception_handler+0x50>
ffffffffc0200a22:	00005517          	auipc	a0,0x5
ffffffffc0200a26:	d2650513          	addi	a0,a0,-730 # ffffffffc0205748 <commands+0x6b8>
ffffffffc0200a2a:	f56ff0ef          	jal	ra,ffffffffc0200180 <cprintf>
ffffffffc0200a2e:	8522                	mv	a0,s0
ffffffffc0200a30:	b77ff0ef          	jal	ra,ffffffffc02005a6 <pgfault_handler>
ffffffffc0200a34:	84aa                	mv	s1,a0
ffffffffc0200a36:	ee050fe3          	beqz	a0,ffffffffc0200934 <exception_handler+0x3e>
ffffffffc0200a3a:	8522                	mv	a0,s0
ffffffffc0200a3c:	dc1ff0ef          	jal	ra,ffffffffc02007fc <print_trapframe>
ffffffffc0200a40:	86a6                	mv	a3,s1
ffffffffc0200a42:	00005617          	auipc	a2,0x5
ffffffffc0200a46:	c1e60613          	addi	a2,a2,-994 # ffffffffc0205660 <commands+0x5d0>
ffffffffc0200a4a:	0d300593          	li	a1,211
ffffffffc0200a4e:	00004517          	auipc	a0,0x4
ffffffffc0200a52:	70250513          	addi	a0,a0,1794 # ffffffffc0205150 <commands+0xc0>
ffffffffc0200a56:	9f1ff0ef          	jal	ra,ffffffffc0200446 <__panic>
ffffffffc0200a5a:	8522                	mv	a0,s0
ffffffffc0200a5c:	6442                	ld	s0,16(sp)
ffffffffc0200a5e:	60e2                	ld	ra,24(sp)
ffffffffc0200a60:	64a2                	ld	s1,8(sp)
ffffffffc0200a62:	6105                	addi	sp,sp,32
ffffffffc0200a64:	bb61                	j	ffffffffc02007fc <print_trapframe>
ffffffffc0200a66:	8522                	mv	a0,s0
ffffffffc0200a68:	d95ff0ef          	jal	ra,ffffffffc02007fc <print_trapframe>
ffffffffc0200a6c:	86a6                	mv	a3,s1
ffffffffc0200a6e:	00005617          	auipc	a2,0x5
ffffffffc0200a72:	bf260613          	addi	a2,a2,-1038 # ffffffffc0205660 <commands+0x5d0>
ffffffffc0200a76:	0da00593          	li	a1,218
ffffffffc0200a7a:	00004517          	auipc	a0,0x4
ffffffffc0200a7e:	6d650513          	addi	a0,a0,1750 # ffffffffc0205150 <commands+0xc0>
ffffffffc0200a82:	9c5ff0ef          	jal	ra,ffffffffc0200446 <__panic>

ffffffffc0200a86 <trap>:
ffffffffc0200a86:	11853783          	ld	a5,280(a0)
ffffffffc0200a8a:	0007c363          	bltz	a5,ffffffffc0200a90 <trap+0xa>
ffffffffc0200a8e:	b5a5                	j	ffffffffc02008f6 <exception_handler>
ffffffffc0200a90:	b3f9                	j	ffffffffc020085e <interrupt_handler>
	...

ffffffffc0200a94 <__alltraps>:
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
ffffffffc0200af4:	850a                	mv	a0,sp
ffffffffc0200af6:	f91ff0ef          	jal	ra,ffffffffc0200a86 <trap>

ffffffffc0200afa <__trapret>:
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
ffffffffc0200b44:	10200073          	sret

ffffffffc0200b48 <forkrets>:
ffffffffc0200b48:	812a                	mv	sp,a0
ffffffffc0200b4a:	bf45                	j	ffffffffc0200afa <__trapret>
	...

ffffffffc0200b4e <default_init>:
ffffffffc0200b4e:	00011797          	auipc	a5,0x11
ffffffffc0200b52:	91278793          	addi	a5,a5,-1774 # ffffffffc0211460 <free_area>
ffffffffc0200b56:	e79c                	sd	a5,8(a5)
ffffffffc0200b58:	e39c                	sd	a5,0(a5)
ffffffffc0200b5a:	0007a823          	sw	zero,16(a5)
ffffffffc0200b5e:	8082                	ret

ffffffffc0200b60 <default_nr_free_pages>:
ffffffffc0200b60:	00011517          	auipc	a0,0x11
ffffffffc0200b64:	91056503          	lwu	a0,-1776(a0) # ffffffffc0211470 <free_area+0x10>
ffffffffc0200b68:	8082                	ret

ffffffffc0200b6a <default_check>:
ffffffffc0200b6a:	715d                	addi	sp,sp,-80
ffffffffc0200b6c:	e0a2                	sd	s0,64(sp)
ffffffffc0200b6e:	00011417          	auipc	s0,0x11
ffffffffc0200b72:	8f240413          	addi	s0,s0,-1806 # ffffffffc0211460 <free_area>
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
ffffffffc0200b8a:	2c878763          	beq	a5,s0,ffffffffc0200e58 <default_check+0x2ee>
ffffffffc0200b8e:	4481                	li	s1,0
ffffffffc0200b90:	4901                	li	s2,0
ffffffffc0200b92:	fe87b703          	ld	a4,-24(a5)
ffffffffc0200b96:	8b09                	andi	a4,a4,2
ffffffffc0200b98:	2c070463          	beqz	a4,ffffffffc0200e60 <default_check+0x2f6>
ffffffffc0200b9c:	ff87a703          	lw	a4,-8(a5)
ffffffffc0200ba0:	679c                	ld	a5,8(a5)
ffffffffc0200ba2:	2905                	addiw	s2,s2,1
ffffffffc0200ba4:	9cb9                	addw	s1,s1,a4
ffffffffc0200ba6:	fe8796e3          	bne	a5,s0,ffffffffc0200b92 <default_check+0x28>
ffffffffc0200baa:	89a6                	mv	s3,s1
ffffffffc0200bac:	76b000ef          	jal	ra,ffffffffc0201b16 <nr_free_pages>
ffffffffc0200bb0:	71351863          	bne	a0,s3,ffffffffc02012c0 <default_check+0x756>
ffffffffc0200bb4:	4505                	li	a0,1
ffffffffc0200bb6:	68f000ef          	jal	ra,ffffffffc0201a44 <alloc_pages>
ffffffffc0200bba:	8a2a                	mv	s4,a0
ffffffffc0200bbc:	44050263          	beqz	a0,ffffffffc0201000 <default_check+0x496>
ffffffffc0200bc0:	4505                	li	a0,1
ffffffffc0200bc2:	683000ef          	jal	ra,ffffffffc0201a44 <alloc_pages>
ffffffffc0200bc6:	89aa                	mv	s3,a0
ffffffffc0200bc8:	70050c63          	beqz	a0,ffffffffc02012e0 <default_check+0x776>
ffffffffc0200bcc:	4505                	li	a0,1
ffffffffc0200bce:	677000ef          	jal	ra,ffffffffc0201a44 <alloc_pages>
ffffffffc0200bd2:	8aaa                	mv	s5,a0
ffffffffc0200bd4:	4a050663          	beqz	a0,ffffffffc0201080 <default_check+0x516>
ffffffffc0200bd8:	2b3a0463          	beq	s4,s3,ffffffffc0200e80 <default_check+0x316>
ffffffffc0200bdc:	2aaa0263          	beq	s4,a0,ffffffffc0200e80 <default_check+0x316>
ffffffffc0200be0:	2aa98063          	beq	s3,a0,ffffffffc0200e80 <default_check+0x316>
ffffffffc0200be4:	000a2783          	lw	a5,0(s4)
ffffffffc0200be8:	2a079c63          	bnez	a5,ffffffffc0200ea0 <default_check+0x336>
ffffffffc0200bec:	0009a783          	lw	a5,0(s3)
ffffffffc0200bf0:	2a079863          	bnez	a5,ffffffffc0200ea0 <default_check+0x336>
ffffffffc0200bf4:	411c                	lw	a5,0(a0)
ffffffffc0200bf6:	2a079563          	bnez	a5,ffffffffc0200ea0 <default_check+0x336>
ffffffffc0200bfa:	00015797          	auipc	a5,0x15
ffffffffc0200bfe:	9767b783          	ld	a5,-1674(a5) # ffffffffc0215570 <pages>
ffffffffc0200c02:	40fa0733          	sub	a4,s4,a5
ffffffffc0200c06:	870d                	srai	a4,a4,0x3
ffffffffc0200c08:	00006597          	auipc	a1,0x6
ffffffffc0200c0c:	2585b583          	ld	a1,600(a1) # ffffffffc0206e60 <error_string+0x38>
ffffffffc0200c10:	02b70733          	mul	a4,a4,a1
ffffffffc0200c14:	00006617          	auipc	a2,0x6
ffffffffc0200c18:	25463603          	ld	a2,596(a2) # ffffffffc0206e68 <nbase>
ffffffffc0200c1c:	00015697          	auipc	a3,0x15
ffffffffc0200c20:	94c6b683          	ld	a3,-1716(a3) # ffffffffc0215568 <npage>
ffffffffc0200c24:	06b2                	slli	a3,a3,0xc
ffffffffc0200c26:	9732                	add	a4,a4,a2
ffffffffc0200c28:	0732                	slli	a4,a4,0xc
ffffffffc0200c2a:	28d77b63          	bgeu	a4,a3,ffffffffc0200ec0 <default_check+0x356>
ffffffffc0200c2e:	40f98733          	sub	a4,s3,a5
ffffffffc0200c32:	870d                	srai	a4,a4,0x3
ffffffffc0200c34:	02b70733          	mul	a4,a4,a1
ffffffffc0200c38:	9732                	add	a4,a4,a2
ffffffffc0200c3a:	0732                	slli	a4,a4,0xc
ffffffffc0200c3c:	4cd77263          	bgeu	a4,a3,ffffffffc0201100 <default_check+0x596>
ffffffffc0200c40:	40f507b3          	sub	a5,a0,a5
ffffffffc0200c44:	878d                	srai	a5,a5,0x3
ffffffffc0200c46:	02b787b3          	mul	a5,a5,a1
ffffffffc0200c4a:	97b2                	add	a5,a5,a2
ffffffffc0200c4c:	07b2                	slli	a5,a5,0xc
ffffffffc0200c4e:	30d7f963          	bgeu	a5,a3,ffffffffc0200f60 <default_check+0x3f6>
ffffffffc0200c52:	4505                	li	a0,1
ffffffffc0200c54:	00043c03          	ld	s8,0(s0)
ffffffffc0200c58:	00843b83          	ld	s7,8(s0)
ffffffffc0200c5c:	01042b03          	lw	s6,16(s0)
ffffffffc0200c60:	e400                	sd	s0,8(s0)
ffffffffc0200c62:	e000                	sd	s0,0(s0)
ffffffffc0200c64:	00011797          	auipc	a5,0x11
ffffffffc0200c68:	8007a623          	sw	zero,-2036(a5) # ffffffffc0211470 <free_area+0x10>
ffffffffc0200c6c:	5d9000ef          	jal	ra,ffffffffc0201a44 <alloc_pages>
ffffffffc0200c70:	2c051863          	bnez	a0,ffffffffc0200f40 <default_check+0x3d6>
ffffffffc0200c74:	4585                	li	a1,1
ffffffffc0200c76:	8552                	mv	a0,s4
ffffffffc0200c78:	65f000ef          	jal	ra,ffffffffc0201ad6 <free_pages>
ffffffffc0200c7c:	4585                	li	a1,1
ffffffffc0200c7e:	854e                	mv	a0,s3
ffffffffc0200c80:	657000ef          	jal	ra,ffffffffc0201ad6 <free_pages>
ffffffffc0200c84:	4585                	li	a1,1
ffffffffc0200c86:	8556                	mv	a0,s5
ffffffffc0200c88:	64f000ef          	jal	ra,ffffffffc0201ad6 <free_pages>
ffffffffc0200c8c:	4818                	lw	a4,16(s0)
ffffffffc0200c8e:	478d                	li	a5,3
ffffffffc0200c90:	28f71863          	bne	a4,a5,ffffffffc0200f20 <default_check+0x3b6>
ffffffffc0200c94:	4505                	li	a0,1
ffffffffc0200c96:	5af000ef          	jal	ra,ffffffffc0201a44 <alloc_pages>
ffffffffc0200c9a:	89aa                	mv	s3,a0
ffffffffc0200c9c:	26050263          	beqz	a0,ffffffffc0200f00 <default_check+0x396>
ffffffffc0200ca0:	4505                	li	a0,1
ffffffffc0200ca2:	5a3000ef          	jal	ra,ffffffffc0201a44 <alloc_pages>
ffffffffc0200ca6:	8aaa                	mv	s5,a0
ffffffffc0200ca8:	3a050c63          	beqz	a0,ffffffffc0201060 <default_check+0x4f6>
ffffffffc0200cac:	4505                	li	a0,1
ffffffffc0200cae:	597000ef          	jal	ra,ffffffffc0201a44 <alloc_pages>
ffffffffc0200cb2:	8a2a                	mv	s4,a0
ffffffffc0200cb4:	38050663          	beqz	a0,ffffffffc0201040 <default_check+0x4d6>
ffffffffc0200cb8:	4505                	li	a0,1
ffffffffc0200cba:	58b000ef          	jal	ra,ffffffffc0201a44 <alloc_pages>
ffffffffc0200cbe:	36051163          	bnez	a0,ffffffffc0201020 <default_check+0x4b6>
ffffffffc0200cc2:	4585                	li	a1,1
ffffffffc0200cc4:	854e                	mv	a0,s3
ffffffffc0200cc6:	611000ef          	jal	ra,ffffffffc0201ad6 <free_pages>
ffffffffc0200cca:	641c                	ld	a5,8(s0)
ffffffffc0200ccc:	20878a63          	beq	a5,s0,ffffffffc0200ee0 <default_check+0x376>
ffffffffc0200cd0:	4505                	li	a0,1
ffffffffc0200cd2:	573000ef          	jal	ra,ffffffffc0201a44 <alloc_pages>
ffffffffc0200cd6:	30a99563          	bne	s3,a0,ffffffffc0200fe0 <default_check+0x476>
ffffffffc0200cda:	4505                	li	a0,1
ffffffffc0200cdc:	569000ef          	jal	ra,ffffffffc0201a44 <alloc_pages>
ffffffffc0200ce0:	2e051063          	bnez	a0,ffffffffc0200fc0 <default_check+0x456>
ffffffffc0200ce4:	481c                	lw	a5,16(s0)
ffffffffc0200ce6:	2a079d63          	bnez	a5,ffffffffc0200fa0 <default_check+0x436>
ffffffffc0200cea:	854e                	mv	a0,s3
ffffffffc0200cec:	4585                	li	a1,1
ffffffffc0200cee:	01843023          	sd	s8,0(s0)
ffffffffc0200cf2:	01743423          	sd	s7,8(s0)
ffffffffc0200cf6:	01642823          	sw	s6,16(s0)
ffffffffc0200cfa:	5dd000ef          	jal	ra,ffffffffc0201ad6 <free_pages>
ffffffffc0200cfe:	4585                	li	a1,1
ffffffffc0200d00:	8556                	mv	a0,s5
ffffffffc0200d02:	5d5000ef          	jal	ra,ffffffffc0201ad6 <free_pages>
ffffffffc0200d06:	4585                	li	a1,1
ffffffffc0200d08:	8552                	mv	a0,s4
ffffffffc0200d0a:	5cd000ef          	jal	ra,ffffffffc0201ad6 <free_pages>
ffffffffc0200d0e:	4515                	li	a0,5
ffffffffc0200d10:	535000ef          	jal	ra,ffffffffc0201a44 <alloc_pages>
ffffffffc0200d14:	89aa                	mv	s3,a0
ffffffffc0200d16:	26050563          	beqz	a0,ffffffffc0200f80 <default_check+0x416>
ffffffffc0200d1a:	651c                	ld	a5,8(a0)
ffffffffc0200d1c:	8385                	srli	a5,a5,0x1
ffffffffc0200d1e:	8b85                	andi	a5,a5,1
ffffffffc0200d20:	54079063          	bnez	a5,ffffffffc0201260 <default_check+0x6f6>
ffffffffc0200d24:	4505                	li	a0,1
ffffffffc0200d26:	00043b03          	ld	s6,0(s0)
ffffffffc0200d2a:	00843a83          	ld	s5,8(s0)
ffffffffc0200d2e:	e000                	sd	s0,0(s0)
ffffffffc0200d30:	e400                	sd	s0,8(s0)
ffffffffc0200d32:	513000ef          	jal	ra,ffffffffc0201a44 <alloc_pages>
ffffffffc0200d36:	50051563          	bnez	a0,ffffffffc0201240 <default_check+0x6d6>
ffffffffc0200d3a:	09098a13          	addi	s4,s3,144
ffffffffc0200d3e:	8552                	mv	a0,s4
ffffffffc0200d40:	458d                	li	a1,3
ffffffffc0200d42:	01042b83          	lw	s7,16(s0)
ffffffffc0200d46:	00010797          	auipc	a5,0x10
ffffffffc0200d4a:	7207a523          	sw	zero,1834(a5) # ffffffffc0211470 <free_area+0x10>
ffffffffc0200d4e:	589000ef          	jal	ra,ffffffffc0201ad6 <free_pages>
ffffffffc0200d52:	4511                	li	a0,4
ffffffffc0200d54:	4f1000ef          	jal	ra,ffffffffc0201a44 <alloc_pages>
ffffffffc0200d58:	4c051463          	bnez	a0,ffffffffc0201220 <default_check+0x6b6>
ffffffffc0200d5c:	0989b783          	ld	a5,152(s3)
ffffffffc0200d60:	8385                	srli	a5,a5,0x1
ffffffffc0200d62:	8b85                	andi	a5,a5,1
ffffffffc0200d64:	48078e63          	beqz	a5,ffffffffc0201200 <default_check+0x696>
ffffffffc0200d68:	0a89a703          	lw	a4,168(s3)
ffffffffc0200d6c:	478d                	li	a5,3
ffffffffc0200d6e:	48f71963          	bne	a4,a5,ffffffffc0201200 <default_check+0x696>
ffffffffc0200d72:	450d                	li	a0,3
ffffffffc0200d74:	4d1000ef          	jal	ra,ffffffffc0201a44 <alloc_pages>
ffffffffc0200d78:	8c2a                	mv	s8,a0
ffffffffc0200d7a:	46050363          	beqz	a0,ffffffffc02011e0 <default_check+0x676>
ffffffffc0200d7e:	4505                	li	a0,1
ffffffffc0200d80:	4c5000ef          	jal	ra,ffffffffc0201a44 <alloc_pages>
ffffffffc0200d84:	42051e63          	bnez	a0,ffffffffc02011c0 <default_check+0x656>
ffffffffc0200d88:	418a1c63          	bne	s4,s8,ffffffffc02011a0 <default_check+0x636>
ffffffffc0200d8c:	4585                	li	a1,1
ffffffffc0200d8e:	854e                	mv	a0,s3
ffffffffc0200d90:	547000ef          	jal	ra,ffffffffc0201ad6 <free_pages>
ffffffffc0200d94:	458d                	li	a1,3
ffffffffc0200d96:	8552                	mv	a0,s4
ffffffffc0200d98:	53f000ef          	jal	ra,ffffffffc0201ad6 <free_pages>
ffffffffc0200d9c:	0089b783          	ld	a5,8(s3)
ffffffffc0200da0:	04898c13          	addi	s8,s3,72
ffffffffc0200da4:	8385                	srli	a5,a5,0x1
ffffffffc0200da6:	8b85                	andi	a5,a5,1
ffffffffc0200da8:	3c078c63          	beqz	a5,ffffffffc0201180 <default_check+0x616>
ffffffffc0200dac:	0189a703          	lw	a4,24(s3)
ffffffffc0200db0:	4785                	li	a5,1
ffffffffc0200db2:	3cf71763          	bne	a4,a5,ffffffffc0201180 <default_check+0x616>
ffffffffc0200db6:	008a3783          	ld	a5,8(s4)
ffffffffc0200dba:	8385                	srli	a5,a5,0x1
ffffffffc0200dbc:	8b85                	andi	a5,a5,1
ffffffffc0200dbe:	3a078163          	beqz	a5,ffffffffc0201160 <default_check+0x5f6>
ffffffffc0200dc2:	018a2703          	lw	a4,24(s4)
ffffffffc0200dc6:	478d                	li	a5,3
ffffffffc0200dc8:	38f71c63          	bne	a4,a5,ffffffffc0201160 <default_check+0x5f6>
ffffffffc0200dcc:	4505                	li	a0,1
ffffffffc0200dce:	477000ef          	jal	ra,ffffffffc0201a44 <alloc_pages>
ffffffffc0200dd2:	36a99763          	bne	s3,a0,ffffffffc0201140 <default_check+0x5d6>
ffffffffc0200dd6:	4585                	li	a1,1
ffffffffc0200dd8:	4ff000ef          	jal	ra,ffffffffc0201ad6 <free_pages>
ffffffffc0200ddc:	4509                	li	a0,2
ffffffffc0200dde:	467000ef          	jal	ra,ffffffffc0201a44 <alloc_pages>
ffffffffc0200de2:	32aa1f63          	bne	s4,a0,ffffffffc0201120 <default_check+0x5b6>
ffffffffc0200de6:	4589                	li	a1,2
ffffffffc0200de8:	4ef000ef          	jal	ra,ffffffffc0201ad6 <free_pages>
ffffffffc0200dec:	4585                	li	a1,1
ffffffffc0200dee:	8562                	mv	a0,s8
ffffffffc0200df0:	4e7000ef          	jal	ra,ffffffffc0201ad6 <free_pages>
ffffffffc0200df4:	4515                	li	a0,5
ffffffffc0200df6:	44f000ef          	jal	ra,ffffffffc0201a44 <alloc_pages>
ffffffffc0200dfa:	89aa                	mv	s3,a0
ffffffffc0200dfc:	48050263          	beqz	a0,ffffffffc0201280 <default_check+0x716>
ffffffffc0200e00:	4505                	li	a0,1
ffffffffc0200e02:	443000ef          	jal	ra,ffffffffc0201a44 <alloc_pages>
ffffffffc0200e06:	2c051d63          	bnez	a0,ffffffffc02010e0 <default_check+0x576>
ffffffffc0200e0a:	481c                	lw	a5,16(s0)
ffffffffc0200e0c:	2a079a63          	bnez	a5,ffffffffc02010c0 <default_check+0x556>
ffffffffc0200e10:	4595                	li	a1,5
ffffffffc0200e12:	854e                	mv	a0,s3
ffffffffc0200e14:	01742823          	sw	s7,16(s0)
ffffffffc0200e18:	01643023          	sd	s6,0(s0)
ffffffffc0200e1c:	01543423          	sd	s5,8(s0)
ffffffffc0200e20:	4b7000ef          	jal	ra,ffffffffc0201ad6 <free_pages>
ffffffffc0200e24:	641c                	ld	a5,8(s0)
ffffffffc0200e26:	00878963          	beq	a5,s0,ffffffffc0200e38 <default_check+0x2ce>
ffffffffc0200e2a:	ff87a703          	lw	a4,-8(a5)
ffffffffc0200e2e:	679c                	ld	a5,8(a5)
ffffffffc0200e30:	397d                	addiw	s2,s2,-1
ffffffffc0200e32:	9c99                	subw	s1,s1,a4
ffffffffc0200e34:	fe879be3          	bne	a5,s0,ffffffffc0200e2a <default_check+0x2c0>
ffffffffc0200e38:	26091463          	bnez	s2,ffffffffc02010a0 <default_check+0x536>
ffffffffc0200e3c:	46049263          	bnez	s1,ffffffffc02012a0 <default_check+0x736>
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
ffffffffc0200e58:	4981                	li	s3,0
ffffffffc0200e5a:	4481                	li	s1,0
ffffffffc0200e5c:	4901                	li	s2,0
ffffffffc0200e5e:	b3b9                	j	ffffffffc0200bac <default_check+0x42>
ffffffffc0200e60:	00005697          	auipc	a3,0x5
ffffffffc0200e64:	95868693          	addi	a3,a3,-1704 # ffffffffc02057b8 <commands+0x728>
ffffffffc0200e68:	00005617          	auipc	a2,0x5
ffffffffc0200e6c:	96060613          	addi	a2,a2,-1696 # ffffffffc02057c8 <commands+0x738>
ffffffffc0200e70:	0f000593          	li	a1,240
ffffffffc0200e74:	00005517          	auipc	a0,0x5
ffffffffc0200e78:	96c50513          	addi	a0,a0,-1684 # ffffffffc02057e0 <commands+0x750>
ffffffffc0200e7c:	dcaff0ef          	jal	ra,ffffffffc0200446 <__panic>
ffffffffc0200e80:	00005697          	auipc	a3,0x5
ffffffffc0200e84:	9f868693          	addi	a3,a3,-1544 # ffffffffc0205878 <commands+0x7e8>
ffffffffc0200e88:	00005617          	auipc	a2,0x5
ffffffffc0200e8c:	94060613          	addi	a2,a2,-1728 # ffffffffc02057c8 <commands+0x738>
ffffffffc0200e90:	0bd00593          	li	a1,189
ffffffffc0200e94:	00005517          	auipc	a0,0x5
ffffffffc0200e98:	94c50513          	addi	a0,a0,-1716 # ffffffffc02057e0 <commands+0x750>
ffffffffc0200e9c:	daaff0ef          	jal	ra,ffffffffc0200446 <__panic>
ffffffffc0200ea0:	00005697          	auipc	a3,0x5
ffffffffc0200ea4:	a0068693          	addi	a3,a3,-1536 # ffffffffc02058a0 <commands+0x810>
ffffffffc0200ea8:	00005617          	auipc	a2,0x5
ffffffffc0200eac:	92060613          	addi	a2,a2,-1760 # ffffffffc02057c8 <commands+0x738>
ffffffffc0200eb0:	0be00593          	li	a1,190
ffffffffc0200eb4:	00005517          	auipc	a0,0x5
ffffffffc0200eb8:	92c50513          	addi	a0,a0,-1748 # ffffffffc02057e0 <commands+0x750>
ffffffffc0200ebc:	d8aff0ef          	jal	ra,ffffffffc0200446 <__panic>
ffffffffc0200ec0:	00005697          	auipc	a3,0x5
ffffffffc0200ec4:	a2068693          	addi	a3,a3,-1504 # ffffffffc02058e0 <commands+0x850>
ffffffffc0200ec8:	00005617          	auipc	a2,0x5
ffffffffc0200ecc:	90060613          	addi	a2,a2,-1792 # ffffffffc02057c8 <commands+0x738>
ffffffffc0200ed0:	0c000593          	li	a1,192
ffffffffc0200ed4:	00005517          	auipc	a0,0x5
ffffffffc0200ed8:	90c50513          	addi	a0,a0,-1780 # ffffffffc02057e0 <commands+0x750>
ffffffffc0200edc:	d6aff0ef          	jal	ra,ffffffffc0200446 <__panic>
ffffffffc0200ee0:	00005697          	auipc	a3,0x5
ffffffffc0200ee4:	a8868693          	addi	a3,a3,-1400 # ffffffffc0205968 <commands+0x8d8>
ffffffffc0200ee8:	00005617          	auipc	a2,0x5
ffffffffc0200eec:	8e060613          	addi	a2,a2,-1824 # ffffffffc02057c8 <commands+0x738>
ffffffffc0200ef0:	0d900593          	li	a1,217
ffffffffc0200ef4:	00005517          	auipc	a0,0x5
ffffffffc0200ef8:	8ec50513          	addi	a0,a0,-1812 # ffffffffc02057e0 <commands+0x750>
ffffffffc0200efc:	d4aff0ef          	jal	ra,ffffffffc0200446 <__panic>
ffffffffc0200f00:	00005697          	auipc	a3,0x5
ffffffffc0200f04:	91868693          	addi	a3,a3,-1768 # ffffffffc0205818 <commands+0x788>
ffffffffc0200f08:	00005617          	auipc	a2,0x5
ffffffffc0200f0c:	8c060613          	addi	a2,a2,-1856 # ffffffffc02057c8 <commands+0x738>
ffffffffc0200f10:	0d200593          	li	a1,210
ffffffffc0200f14:	00005517          	auipc	a0,0x5
ffffffffc0200f18:	8cc50513          	addi	a0,a0,-1844 # ffffffffc02057e0 <commands+0x750>
ffffffffc0200f1c:	d2aff0ef          	jal	ra,ffffffffc0200446 <__panic>
ffffffffc0200f20:	00005697          	auipc	a3,0x5
ffffffffc0200f24:	a3868693          	addi	a3,a3,-1480 # ffffffffc0205958 <commands+0x8c8>
ffffffffc0200f28:	00005617          	auipc	a2,0x5
ffffffffc0200f2c:	8a060613          	addi	a2,a2,-1888 # ffffffffc02057c8 <commands+0x738>
ffffffffc0200f30:	0d000593          	li	a1,208
ffffffffc0200f34:	00005517          	auipc	a0,0x5
ffffffffc0200f38:	8ac50513          	addi	a0,a0,-1876 # ffffffffc02057e0 <commands+0x750>
ffffffffc0200f3c:	d0aff0ef          	jal	ra,ffffffffc0200446 <__panic>
ffffffffc0200f40:	00005697          	auipc	a3,0x5
ffffffffc0200f44:	a0068693          	addi	a3,a3,-1536 # ffffffffc0205940 <commands+0x8b0>
ffffffffc0200f48:	00005617          	auipc	a2,0x5
ffffffffc0200f4c:	88060613          	addi	a2,a2,-1920 # ffffffffc02057c8 <commands+0x738>
ffffffffc0200f50:	0cb00593          	li	a1,203
ffffffffc0200f54:	00005517          	auipc	a0,0x5
ffffffffc0200f58:	88c50513          	addi	a0,a0,-1908 # ffffffffc02057e0 <commands+0x750>
ffffffffc0200f5c:	ceaff0ef          	jal	ra,ffffffffc0200446 <__panic>
ffffffffc0200f60:	00005697          	auipc	a3,0x5
ffffffffc0200f64:	9c068693          	addi	a3,a3,-1600 # ffffffffc0205920 <commands+0x890>
ffffffffc0200f68:	00005617          	auipc	a2,0x5
ffffffffc0200f6c:	86060613          	addi	a2,a2,-1952 # ffffffffc02057c8 <commands+0x738>
ffffffffc0200f70:	0c200593          	li	a1,194
ffffffffc0200f74:	00005517          	auipc	a0,0x5
ffffffffc0200f78:	86c50513          	addi	a0,a0,-1940 # ffffffffc02057e0 <commands+0x750>
ffffffffc0200f7c:	ccaff0ef          	jal	ra,ffffffffc0200446 <__panic>
ffffffffc0200f80:	00005697          	auipc	a3,0x5
ffffffffc0200f84:	a3068693          	addi	a3,a3,-1488 # ffffffffc02059b0 <commands+0x920>
ffffffffc0200f88:	00005617          	auipc	a2,0x5
ffffffffc0200f8c:	84060613          	addi	a2,a2,-1984 # ffffffffc02057c8 <commands+0x738>
ffffffffc0200f90:	0f800593          	li	a1,248
ffffffffc0200f94:	00005517          	auipc	a0,0x5
ffffffffc0200f98:	84c50513          	addi	a0,a0,-1972 # ffffffffc02057e0 <commands+0x750>
ffffffffc0200f9c:	caaff0ef          	jal	ra,ffffffffc0200446 <__panic>
ffffffffc0200fa0:	00005697          	auipc	a3,0x5
ffffffffc0200fa4:	a0068693          	addi	a3,a3,-1536 # ffffffffc02059a0 <commands+0x910>
ffffffffc0200fa8:	00005617          	auipc	a2,0x5
ffffffffc0200fac:	82060613          	addi	a2,a2,-2016 # ffffffffc02057c8 <commands+0x738>
ffffffffc0200fb0:	0df00593          	li	a1,223
ffffffffc0200fb4:	00005517          	auipc	a0,0x5
ffffffffc0200fb8:	82c50513          	addi	a0,a0,-2004 # ffffffffc02057e0 <commands+0x750>
ffffffffc0200fbc:	c8aff0ef          	jal	ra,ffffffffc0200446 <__panic>
ffffffffc0200fc0:	00005697          	auipc	a3,0x5
ffffffffc0200fc4:	98068693          	addi	a3,a3,-1664 # ffffffffc0205940 <commands+0x8b0>
ffffffffc0200fc8:	00005617          	auipc	a2,0x5
ffffffffc0200fcc:	80060613          	addi	a2,a2,-2048 # ffffffffc02057c8 <commands+0x738>
ffffffffc0200fd0:	0dd00593          	li	a1,221
ffffffffc0200fd4:	00005517          	auipc	a0,0x5
ffffffffc0200fd8:	80c50513          	addi	a0,a0,-2036 # ffffffffc02057e0 <commands+0x750>
ffffffffc0200fdc:	c6aff0ef          	jal	ra,ffffffffc0200446 <__panic>
ffffffffc0200fe0:	00005697          	auipc	a3,0x5
ffffffffc0200fe4:	9a068693          	addi	a3,a3,-1632 # ffffffffc0205980 <commands+0x8f0>
ffffffffc0200fe8:	00004617          	auipc	a2,0x4
ffffffffc0200fec:	7e060613          	addi	a2,a2,2016 # ffffffffc02057c8 <commands+0x738>
ffffffffc0200ff0:	0dc00593          	li	a1,220
ffffffffc0200ff4:	00004517          	auipc	a0,0x4
ffffffffc0200ff8:	7ec50513          	addi	a0,a0,2028 # ffffffffc02057e0 <commands+0x750>
ffffffffc0200ffc:	c4aff0ef          	jal	ra,ffffffffc0200446 <__panic>
ffffffffc0201000:	00005697          	auipc	a3,0x5
ffffffffc0201004:	81868693          	addi	a3,a3,-2024 # ffffffffc0205818 <commands+0x788>
ffffffffc0201008:	00004617          	auipc	a2,0x4
ffffffffc020100c:	7c060613          	addi	a2,a2,1984 # ffffffffc02057c8 <commands+0x738>
ffffffffc0201010:	0b900593          	li	a1,185
ffffffffc0201014:	00004517          	auipc	a0,0x4
ffffffffc0201018:	7cc50513          	addi	a0,a0,1996 # ffffffffc02057e0 <commands+0x750>
ffffffffc020101c:	c2aff0ef          	jal	ra,ffffffffc0200446 <__panic>
ffffffffc0201020:	00005697          	auipc	a3,0x5
ffffffffc0201024:	92068693          	addi	a3,a3,-1760 # ffffffffc0205940 <commands+0x8b0>
ffffffffc0201028:	00004617          	auipc	a2,0x4
ffffffffc020102c:	7a060613          	addi	a2,a2,1952 # ffffffffc02057c8 <commands+0x738>
ffffffffc0201030:	0d600593          	li	a1,214
ffffffffc0201034:	00004517          	auipc	a0,0x4
ffffffffc0201038:	7ac50513          	addi	a0,a0,1964 # ffffffffc02057e0 <commands+0x750>
ffffffffc020103c:	c0aff0ef          	jal	ra,ffffffffc0200446 <__panic>
ffffffffc0201040:	00005697          	auipc	a3,0x5
ffffffffc0201044:	81868693          	addi	a3,a3,-2024 # ffffffffc0205858 <commands+0x7c8>
ffffffffc0201048:	00004617          	auipc	a2,0x4
ffffffffc020104c:	78060613          	addi	a2,a2,1920 # ffffffffc02057c8 <commands+0x738>
ffffffffc0201050:	0d400593          	li	a1,212
ffffffffc0201054:	00004517          	auipc	a0,0x4
ffffffffc0201058:	78c50513          	addi	a0,a0,1932 # ffffffffc02057e0 <commands+0x750>
ffffffffc020105c:	beaff0ef          	jal	ra,ffffffffc0200446 <__panic>
ffffffffc0201060:	00004697          	auipc	a3,0x4
ffffffffc0201064:	7d868693          	addi	a3,a3,2008 # ffffffffc0205838 <commands+0x7a8>
ffffffffc0201068:	00004617          	auipc	a2,0x4
ffffffffc020106c:	76060613          	addi	a2,a2,1888 # ffffffffc02057c8 <commands+0x738>
ffffffffc0201070:	0d300593          	li	a1,211
ffffffffc0201074:	00004517          	auipc	a0,0x4
ffffffffc0201078:	76c50513          	addi	a0,a0,1900 # ffffffffc02057e0 <commands+0x750>
ffffffffc020107c:	bcaff0ef          	jal	ra,ffffffffc0200446 <__panic>
ffffffffc0201080:	00004697          	auipc	a3,0x4
ffffffffc0201084:	7d868693          	addi	a3,a3,2008 # ffffffffc0205858 <commands+0x7c8>
ffffffffc0201088:	00004617          	auipc	a2,0x4
ffffffffc020108c:	74060613          	addi	a2,a2,1856 # ffffffffc02057c8 <commands+0x738>
ffffffffc0201090:	0bb00593          	li	a1,187
ffffffffc0201094:	00004517          	auipc	a0,0x4
ffffffffc0201098:	74c50513          	addi	a0,a0,1868 # ffffffffc02057e0 <commands+0x750>
ffffffffc020109c:	baaff0ef          	jal	ra,ffffffffc0200446 <__panic>
ffffffffc02010a0:	00005697          	auipc	a3,0x5
ffffffffc02010a4:	a6068693          	addi	a3,a3,-1440 # ffffffffc0205b00 <commands+0xa70>
ffffffffc02010a8:	00004617          	auipc	a2,0x4
ffffffffc02010ac:	72060613          	addi	a2,a2,1824 # ffffffffc02057c8 <commands+0x738>
ffffffffc02010b0:	12500593          	li	a1,293
ffffffffc02010b4:	00004517          	auipc	a0,0x4
ffffffffc02010b8:	72c50513          	addi	a0,a0,1836 # ffffffffc02057e0 <commands+0x750>
ffffffffc02010bc:	b8aff0ef          	jal	ra,ffffffffc0200446 <__panic>
ffffffffc02010c0:	00005697          	auipc	a3,0x5
ffffffffc02010c4:	8e068693          	addi	a3,a3,-1824 # ffffffffc02059a0 <commands+0x910>
ffffffffc02010c8:	00004617          	auipc	a2,0x4
ffffffffc02010cc:	70060613          	addi	a2,a2,1792 # ffffffffc02057c8 <commands+0x738>
ffffffffc02010d0:	11a00593          	li	a1,282
ffffffffc02010d4:	00004517          	auipc	a0,0x4
ffffffffc02010d8:	70c50513          	addi	a0,a0,1804 # ffffffffc02057e0 <commands+0x750>
ffffffffc02010dc:	b6aff0ef          	jal	ra,ffffffffc0200446 <__panic>
ffffffffc02010e0:	00005697          	auipc	a3,0x5
ffffffffc02010e4:	86068693          	addi	a3,a3,-1952 # ffffffffc0205940 <commands+0x8b0>
ffffffffc02010e8:	00004617          	auipc	a2,0x4
ffffffffc02010ec:	6e060613          	addi	a2,a2,1760 # ffffffffc02057c8 <commands+0x738>
ffffffffc02010f0:	11800593          	li	a1,280
ffffffffc02010f4:	00004517          	auipc	a0,0x4
ffffffffc02010f8:	6ec50513          	addi	a0,a0,1772 # ffffffffc02057e0 <commands+0x750>
ffffffffc02010fc:	b4aff0ef          	jal	ra,ffffffffc0200446 <__panic>
ffffffffc0201100:	00005697          	auipc	a3,0x5
ffffffffc0201104:	80068693          	addi	a3,a3,-2048 # ffffffffc0205900 <commands+0x870>
ffffffffc0201108:	00004617          	auipc	a2,0x4
ffffffffc020110c:	6c060613          	addi	a2,a2,1728 # ffffffffc02057c8 <commands+0x738>
ffffffffc0201110:	0c100593          	li	a1,193
ffffffffc0201114:	00004517          	auipc	a0,0x4
ffffffffc0201118:	6cc50513          	addi	a0,a0,1740 # ffffffffc02057e0 <commands+0x750>
ffffffffc020111c:	b2aff0ef          	jal	ra,ffffffffc0200446 <__panic>
ffffffffc0201120:	00005697          	auipc	a3,0x5
ffffffffc0201124:	9a068693          	addi	a3,a3,-1632 # ffffffffc0205ac0 <commands+0xa30>
ffffffffc0201128:	00004617          	auipc	a2,0x4
ffffffffc020112c:	6a060613          	addi	a2,a2,1696 # ffffffffc02057c8 <commands+0x738>
ffffffffc0201130:	11200593          	li	a1,274
ffffffffc0201134:	00004517          	auipc	a0,0x4
ffffffffc0201138:	6ac50513          	addi	a0,a0,1708 # ffffffffc02057e0 <commands+0x750>
ffffffffc020113c:	b0aff0ef          	jal	ra,ffffffffc0200446 <__panic>
ffffffffc0201140:	00005697          	auipc	a3,0x5
ffffffffc0201144:	96068693          	addi	a3,a3,-1696 # ffffffffc0205aa0 <commands+0xa10>
ffffffffc0201148:	00004617          	auipc	a2,0x4
ffffffffc020114c:	68060613          	addi	a2,a2,1664 # ffffffffc02057c8 <commands+0x738>
ffffffffc0201150:	11000593          	li	a1,272
ffffffffc0201154:	00004517          	auipc	a0,0x4
ffffffffc0201158:	68c50513          	addi	a0,a0,1676 # ffffffffc02057e0 <commands+0x750>
ffffffffc020115c:	aeaff0ef          	jal	ra,ffffffffc0200446 <__panic>
ffffffffc0201160:	00005697          	auipc	a3,0x5
ffffffffc0201164:	91868693          	addi	a3,a3,-1768 # ffffffffc0205a78 <commands+0x9e8>
ffffffffc0201168:	00004617          	auipc	a2,0x4
ffffffffc020116c:	66060613          	addi	a2,a2,1632 # ffffffffc02057c8 <commands+0x738>
ffffffffc0201170:	10e00593          	li	a1,270
ffffffffc0201174:	00004517          	auipc	a0,0x4
ffffffffc0201178:	66c50513          	addi	a0,a0,1644 # ffffffffc02057e0 <commands+0x750>
ffffffffc020117c:	acaff0ef          	jal	ra,ffffffffc0200446 <__panic>
ffffffffc0201180:	00005697          	auipc	a3,0x5
ffffffffc0201184:	8d068693          	addi	a3,a3,-1840 # ffffffffc0205a50 <commands+0x9c0>
ffffffffc0201188:	00004617          	auipc	a2,0x4
ffffffffc020118c:	64060613          	addi	a2,a2,1600 # ffffffffc02057c8 <commands+0x738>
ffffffffc0201190:	10d00593          	li	a1,269
ffffffffc0201194:	00004517          	auipc	a0,0x4
ffffffffc0201198:	64c50513          	addi	a0,a0,1612 # ffffffffc02057e0 <commands+0x750>
ffffffffc020119c:	aaaff0ef          	jal	ra,ffffffffc0200446 <__panic>
ffffffffc02011a0:	00005697          	auipc	a3,0x5
ffffffffc02011a4:	8a068693          	addi	a3,a3,-1888 # ffffffffc0205a40 <commands+0x9b0>
ffffffffc02011a8:	00004617          	auipc	a2,0x4
ffffffffc02011ac:	62060613          	addi	a2,a2,1568 # ffffffffc02057c8 <commands+0x738>
ffffffffc02011b0:	10800593          	li	a1,264
ffffffffc02011b4:	00004517          	auipc	a0,0x4
ffffffffc02011b8:	62c50513          	addi	a0,a0,1580 # ffffffffc02057e0 <commands+0x750>
ffffffffc02011bc:	a8aff0ef          	jal	ra,ffffffffc0200446 <__panic>
ffffffffc02011c0:	00004697          	auipc	a3,0x4
ffffffffc02011c4:	78068693          	addi	a3,a3,1920 # ffffffffc0205940 <commands+0x8b0>
ffffffffc02011c8:	00004617          	auipc	a2,0x4
ffffffffc02011cc:	60060613          	addi	a2,a2,1536 # ffffffffc02057c8 <commands+0x738>
ffffffffc02011d0:	10700593          	li	a1,263
ffffffffc02011d4:	00004517          	auipc	a0,0x4
ffffffffc02011d8:	60c50513          	addi	a0,a0,1548 # ffffffffc02057e0 <commands+0x750>
ffffffffc02011dc:	a6aff0ef          	jal	ra,ffffffffc0200446 <__panic>
ffffffffc02011e0:	00005697          	auipc	a3,0x5
ffffffffc02011e4:	84068693          	addi	a3,a3,-1984 # ffffffffc0205a20 <commands+0x990>
ffffffffc02011e8:	00004617          	auipc	a2,0x4
ffffffffc02011ec:	5e060613          	addi	a2,a2,1504 # ffffffffc02057c8 <commands+0x738>
ffffffffc02011f0:	10600593          	li	a1,262
ffffffffc02011f4:	00004517          	auipc	a0,0x4
ffffffffc02011f8:	5ec50513          	addi	a0,a0,1516 # ffffffffc02057e0 <commands+0x750>
ffffffffc02011fc:	a4aff0ef          	jal	ra,ffffffffc0200446 <__panic>
ffffffffc0201200:	00004697          	auipc	a3,0x4
ffffffffc0201204:	7f068693          	addi	a3,a3,2032 # ffffffffc02059f0 <commands+0x960>
ffffffffc0201208:	00004617          	auipc	a2,0x4
ffffffffc020120c:	5c060613          	addi	a2,a2,1472 # ffffffffc02057c8 <commands+0x738>
ffffffffc0201210:	10500593          	li	a1,261
ffffffffc0201214:	00004517          	auipc	a0,0x4
ffffffffc0201218:	5cc50513          	addi	a0,a0,1484 # ffffffffc02057e0 <commands+0x750>
ffffffffc020121c:	a2aff0ef          	jal	ra,ffffffffc0200446 <__panic>
ffffffffc0201220:	00004697          	auipc	a3,0x4
ffffffffc0201224:	7b868693          	addi	a3,a3,1976 # ffffffffc02059d8 <commands+0x948>
ffffffffc0201228:	00004617          	auipc	a2,0x4
ffffffffc020122c:	5a060613          	addi	a2,a2,1440 # ffffffffc02057c8 <commands+0x738>
ffffffffc0201230:	10400593          	li	a1,260
ffffffffc0201234:	00004517          	auipc	a0,0x4
ffffffffc0201238:	5ac50513          	addi	a0,a0,1452 # ffffffffc02057e0 <commands+0x750>
ffffffffc020123c:	a0aff0ef          	jal	ra,ffffffffc0200446 <__panic>
ffffffffc0201240:	00004697          	auipc	a3,0x4
ffffffffc0201244:	70068693          	addi	a3,a3,1792 # ffffffffc0205940 <commands+0x8b0>
ffffffffc0201248:	00004617          	auipc	a2,0x4
ffffffffc020124c:	58060613          	addi	a2,a2,1408 # ffffffffc02057c8 <commands+0x738>
ffffffffc0201250:	0fe00593          	li	a1,254
ffffffffc0201254:	00004517          	auipc	a0,0x4
ffffffffc0201258:	58c50513          	addi	a0,a0,1420 # ffffffffc02057e0 <commands+0x750>
ffffffffc020125c:	9eaff0ef          	jal	ra,ffffffffc0200446 <__panic>
ffffffffc0201260:	00004697          	auipc	a3,0x4
ffffffffc0201264:	76068693          	addi	a3,a3,1888 # ffffffffc02059c0 <commands+0x930>
ffffffffc0201268:	00004617          	auipc	a2,0x4
ffffffffc020126c:	56060613          	addi	a2,a2,1376 # ffffffffc02057c8 <commands+0x738>
ffffffffc0201270:	0f900593          	li	a1,249
ffffffffc0201274:	00004517          	auipc	a0,0x4
ffffffffc0201278:	56c50513          	addi	a0,a0,1388 # ffffffffc02057e0 <commands+0x750>
ffffffffc020127c:	9caff0ef          	jal	ra,ffffffffc0200446 <__panic>
ffffffffc0201280:	00005697          	auipc	a3,0x5
ffffffffc0201284:	86068693          	addi	a3,a3,-1952 # ffffffffc0205ae0 <commands+0xa50>
ffffffffc0201288:	00004617          	auipc	a2,0x4
ffffffffc020128c:	54060613          	addi	a2,a2,1344 # ffffffffc02057c8 <commands+0x738>
ffffffffc0201290:	11700593          	li	a1,279
ffffffffc0201294:	00004517          	auipc	a0,0x4
ffffffffc0201298:	54c50513          	addi	a0,a0,1356 # ffffffffc02057e0 <commands+0x750>
ffffffffc020129c:	9aaff0ef          	jal	ra,ffffffffc0200446 <__panic>
ffffffffc02012a0:	00005697          	auipc	a3,0x5
ffffffffc02012a4:	87068693          	addi	a3,a3,-1936 # ffffffffc0205b10 <commands+0xa80>
ffffffffc02012a8:	00004617          	auipc	a2,0x4
ffffffffc02012ac:	52060613          	addi	a2,a2,1312 # ffffffffc02057c8 <commands+0x738>
ffffffffc02012b0:	12600593          	li	a1,294
ffffffffc02012b4:	00004517          	auipc	a0,0x4
ffffffffc02012b8:	52c50513          	addi	a0,a0,1324 # ffffffffc02057e0 <commands+0x750>
ffffffffc02012bc:	98aff0ef          	jal	ra,ffffffffc0200446 <__panic>
ffffffffc02012c0:	00004697          	auipc	a3,0x4
ffffffffc02012c4:	53868693          	addi	a3,a3,1336 # ffffffffc02057f8 <commands+0x768>
ffffffffc02012c8:	00004617          	auipc	a2,0x4
ffffffffc02012cc:	50060613          	addi	a2,a2,1280 # ffffffffc02057c8 <commands+0x738>
ffffffffc02012d0:	0f300593          	li	a1,243
ffffffffc02012d4:	00004517          	auipc	a0,0x4
ffffffffc02012d8:	50c50513          	addi	a0,a0,1292 # ffffffffc02057e0 <commands+0x750>
ffffffffc02012dc:	96aff0ef          	jal	ra,ffffffffc0200446 <__panic>
ffffffffc02012e0:	00004697          	auipc	a3,0x4
ffffffffc02012e4:	55868693          	addi	a3,a3,1368 # ffffffffc0205838 <commands+0x7a8>
ffffffffc02012e8:	00004617          	auipc	a2,0x4
ffffffffc02012ec:	4e060613          	addi	a2,a2,1248 # ffffffffc02057c8 <commands+0x738>
ffffffffc02012f0:	0ba00593          	li	a1,186
ffffffffc02012f4:	00004517          	auipc	a0,0x4
ffffffffc02012f8:	4ec50513          	addi	a0,a0,1260 # ffffffffc02057e0 <commands+0x750>
ffffffffc02012fc:	94aff0ef          	jal	ra,ffffffffc0200446 <__panic>

ffffffffc0201300 <default_free_pages>:
ffffffffc0201300:	1141                	addi	sp,sp,-16
ffffffffc0201302:	e406                	sd	ra,8(sp)
ffffffffc0201304:	14058a63          	beqz	a1,ffffffffc0201458 <default_free_pages+0x158>
ffffffffc0201308:	00359693          	slli	a3,a1,0x3
ffffffffc020130c:	96ae                	add	a3,a3,a1
ffffffffc020130e:	068e                	slli	a3,a3,0x3
ffffffffc0201310:	96aa                	add	a3,a3,a0
ffffffffc0201312:	87aa                	mv	a5,a0
ffffffffc0201314:	02d50263          	beq	a0,a3,ffffffffc0201338 <default_free_pages+0x38>
ffffffffc0201318:	6798                	ld	a4,8(a5)
ffffffffc020131a:	8b05                	andi	a4,a4,1
ffffffffc020131c:	10071e63          	bnez	a4,ffffffffc0201438 <default_free_pages+0x138>
ffffffffc0201320:	6798                	ld	a4,8(a5)
ffffffffc0201322:	8b09                	andi	a4,a4,2
ffffffffc0201324:	10071a63          	bnez	a4,ffffffffc0201438 <default_free_pages+0x138>
ffffffffc0201328:	0007b423          	sd	zero,8(a5)
ffffffffc020132c:	0007a023          	sw	zero,0(a5)
ffffffffc0201330:	04878793          	addi	a5,a5,72
ffffffffc0201334:	fed792e3          	bne	a5,a3,ffffffffc0201318 <default_free_pages+0x18>
ffffffffc0201338:	2581                	sext.w	a1,a1
ffffffffc020133a:	cd0c                	sw	a1,24(a0)
ffffffffc020133c:	00850893          	addi	a7,a0,8
ffffffffc0201340:	4789                	li	a5,2
ffffffffc0201342:	40f8b02f          	amoor.d	zero,a5,(a7)
ffffffffc0201346:	00010697          	auipc	a3,0x10
ffffffffc020134a:	11a68693          	addi	a3,a3,282 # ffffffffc0211460 <free_area>
ffffffffc020134e:	4a98                	lw	a4,16(a3)
ffffffffc0201350:	669c                	ld	a5,8(a3)
ffffffffc0201352:	02050613          	addi	a2,a0,32
ffffffffc0201356:	9db9                	addw	a1,a1,a4
ffffffffc0201358:	ca8c                	sw	a1,16(a3)
ffffffffc020135a:	0ad78863          	beq	a5,a3,ffffffffc020140a <default_free_pages+0x10a>
ffffffffc020135e:	fe078713          	addi	a4,a5,-32
ffffffffc0201362:	0006b803          	ld	a6,0(a3)
ffffffffc0201366:	4581                	li	a1,0
ffffffffc0201368:	00e56a63          	bltu	a0,a4,ffffffffc020137c <default_free_pages+0x7c>
ffffffffc020136c:	6798                	ld	a4,8(a5)
ffffffffc020136e:	06d70263          	beq	a4,a3,ffffffffc02013d2 <default_free_pages+0xd2>
ffffffffc0201372:	87ba                	mv	a5,a4
ffffffffc0201374:	fe078713          	addi	a4,a5,-32
ffffffffc0201378:	fee57ae3          	bgeu	a0,a4,ffffffffc020136c <default_free_pages+0x6c>
ffffffffc020137c:	c199                	beqz	a1,ffffffffc0201382 <default_free_pages+0x82>
ffffffffc020137e:	0106b023          	sd	a6,0(a3)
ffffffffc0201382:	6398                	ld	a4,0(a5)
ffffffffc0201384:	e390                	sd	a2,0(a5)
ffffffffc0201386:	e710                	sd	a2,8(a4)
ffffffffc0201388:	f51c                	sd	a5,40(a0)
ffffffffc020138a:	f118                	sd	a4,32(a0)
ffffffffc020138c:	02d70063          	beq	a4,a3,ffffffffc02013ac <default_free_pages+0xac>
ffffffffc0201390:	ff872803          	lw	a6,-8(a4)
ffffffffc0201394:	fe070593          	addi	a1,a4,-32
ffffffffc0201398:	02081613          	slli	a2,a6,0x20
ffffffffc020139c:	9201                	srli	a2,a2,0x20
ffffffffc020139e:	00361793          	slli	a5,a2,0x3
ffffffffc02013a2:	97b2                	add	a5,a5,a2
ffffffffc02013a4:	078e                	slli	a5,a5,0x3
ffffffffc02013a6:	97ae                	add	a5,a5,a1
ffffffffc02013a8:	02f50f63          	beq	a0,a5,ffffffffc02013e6 <default_free_pages+0xe6>
ffffffffc02013ac:	7518                	ld	a4,40(a0)
ffffffffc02013ae:	00d70f63          	beq	a4,a3,ffffffffc02013cc <default_free_pages+0xcc>
ffffffffc02013b2:	4d0c                	lw	a1,24(a0)
ffffffffc02013b4:	fe070693          	addi	a3,a4,-32
ffffffffc02013b8:	02059613          	slli	a2,a1,0x20
ffffffffc02013bc:	9201                	srli	a2,a2,0x20
ffffffffc02013be:	00361793          	slli	a5,a2,0x3
ffffffffc02013c2:	97b2                	add	a5,a5,a2
ffffffffc02013c4:	078e                	slli	a5,a5,0x3
ffffffffc02013c6:	97aa                	add	a5,a5,a0
ffffffffc02013c8:	04f68863          	beq	a3,a5,ffffffffc0201418 <default_free_pages+0x118>
ffffffffc02013cc:	60a2                	ld	ra,8(sp)
ffffffffc02013ce:	0141                	addi	sp,sp,16
ffffffffc02013d0:	8082                	ret
ffffffffc02013d2:	e790                	sd	a2,8(a5)
ffffffffc02013d4:	f514                	sd	a3,40(a0)
ffffffffc02013d6:	6798                	ld	a4,8(a5)
ffffffffc02013d8:	f11c                	sd	a5,32(a0)
ffffffffc02013da:	02d70563          	beq	a4,a3,ffffffffc0201404 <default_free_pages+0x104>
ffffffffc02013de:	8832                	mv	a6,a2
ffffffffc02013e0:	4585                	li	a1,1
ffffffffc02013e2:	87ba                	mv	a5,a4
ffffffffc02013e4:	bf41                	j	ffffffffc0201374 <default_free_pages+0x74>
ffffffffc02013e6:	4d1c                	lw	a5,24(a0)
ffffffffc02013e8:	0107883b          	addw	a6,a5,a6
ffffffffc02013ec:	ff072c23          	sw	a6,-8(a4)
ffffffffc02013f0:	57f5                	li	a5,-3
ffffffffc02013f2:	60f8b02f          	amoand.d	zero,a5,(a7)
ffffffffc02013f6:	7110                	ld	a2,32(a0)
ffffffffc02013f8:	751c                	ld	a5,40(a0)
ffffffffc02013fa:	852e                	mv	a0,a1
ffffffffc02013fc:	e61c                	sd	a5,8(a2)
ffffffffc02013fe:	6718                	ld	a4,8(a4)
ffffffffc0201400:	e390                	sd	a2,0(a5)
ffffffffc0201402:	b775                	j	ffffffffc02013ae <default_free_pages+0xae>
ffffffffc0201404:	e290                	sd	a2,0(a3)
ffffffffc0201406:	873e                	mv	a4,a5
ffffffffc0201408:	b761                	j	ffffffffc0201390 <default_free_pages+0x90>
ffffffffc020140a:	60a2                	ld	ra,8(sp)
ffffffffc020140c:	e390                	sd	a2,0(a5)
ffffffffc020140e:	e790                	sd	a2,8(a5)
ffffffffc0201410:	f51c                	sd	a5,40(a0)
ffffffffc0201412:	f11c                	sd	a5,32(a0)
ffffffffc0201414:	0141                	addi	sp,sp,16
ffffffffc0201416:	8082                	ret
ffffffffc0201418:	ff872783          	lw	a5,-8(a4)
ffffffffc020141c:	fe870693          	addi	a3,a4,-24
ffffffffc0201420:	9dbd                	addw	a1,a1,a5
ffffffffc0201422:	cd0c                	sw	a1,24(a0)
ffffffffc0201424:	57f5                	li	a5,-3
ffffffffc0201426:	60f6b02f          	amoand.d	zero,a5,(a3)
ffffffffc020142a:	6314                	ld	a3,0(a4)
ffffffffc020142c:	671c                	ld	a5,8(a4)
ffffffffc020142e:	60a2                	ld	ra,8(sp)
ffffffffc0201430:	e69c                	sd	a5,8(a3)
ffffffffc0201432:	e394                	sd	a3,0(a5)
ffffffffc0201434:	0141                	addi	sp,sp,16
ffffffffc0201436:	8082                	ret
ffffffffc0201438:	00004697          	auipc	a3,0x4
ffffffffc020143c:	6f068693          	addi	a3,a3,1776 # ffffffffc0205b28 <commands+0xa98>
ffffffffc0201440:	00004617          	auipc	a2,0x4
ffffffffc0201444:	38860613          	addi	a2,a2,904 # ffffffffc02057c8 <commands+0x738>
ffffffffc0201448:	08300593          	li	a1,131
ffffffffc020144c:	00004517          	auipc	a0,0x4
ffffffffc0201450:	39450513          	addi	a0,a0,916 # ffffffffc02057e0 <commands+0x750>
ffffffffc0201454:	ff3fe0ef          	jal	ra,ffffffffc0200446 <__panic>
ffffffffc0201458:	00004697          	auipc	a3,0x4
ffffffffc020145c:	6c868693          	addi	a3,a3,1736 # ffffffffc0205b20 <commands+0xa90>
ffffffffc0201460:	00004617          	auipc	a2,0x4
ffffffffc0201464:	36860613          	addi	a2,a2,872 # ffffffffc02057c8 <commands+0x738>
ffffffffc0201468:	08000593          	li	a1,128
ffffffffc020146c:	00004517          	auipc	a0,0x4
ffffffffc0201470:	37450513          	addi	a0,a0,884 # ffffffffc02057e0 <commands+0x750>
ffffffffc0201474:	fd3fe0ef          	jal	ra,ffffffffc0200446 <__panic>

ffffffffc0201478 <default_alloc_pages>:
ffffffffc0201478:	c959                	beqz	a0,ffffffffc020150e <default_alloc_pages+0x96>
ffffffffc020147a:	00010597          	auipc	a1,0x10
ffffffffc020147e:	fe658593          	addi	a1,a1,-26 # ffffffffc0211460 <free_area>
ffffffffc0201482:	0105a803          	lw	a6,16(a1)
ffffffffc0201486:	862a                	mv	a2,a0
ffffffffc0201488:	02081793          	slli	a5,a6,0x20
ffffffffc020148c:	9381                	srli	a5,a5,0x20
ffffffffc020148e:	00a7ee63          	bltu	a5,a0,ffffffffc02014aa <default_alloc_pages+0x32>
ffffffffc0201492:	87ae                	mv	a5,a1
ffffffffc0201494:	a801                	j	ffffffffc02014a4 <default_alloc_pages+0x2c>
ffffffffc0201496:	ff87a703          	lw	a4,-8(a5)
ffffffffc020149a:	02071693          	slli	a3,a4,0x20
ffffffffc020149e:	9281                	srli	a3,a3,0x20
ffffffffc02014a0:	00c6f763          	bgeu	a3,a2,ffffffffc02014ae <default_alloc_pages+0x36>
ffffffffc02014a4:	679c                	ld	a5,8(a5)
ffffffffc02014a6:	feb798e3          	bne	a5,a1,ffffffffc0201496 <default_alloc_pages+0x1e>
ffffffffc02014aa:	4501                	li	a0,0
ffffffffc02014ac:	8082                	ret
ffffffffc02014ae:	0007b883          	ld	a7,0(a5)
ffffffffc02014b2:	0087b303          	ld	t1,8(a5)
ffffffffc02014b6:	fe078513          	addi	a0,a5,-32
ffffffffc02014ba:	00060e1b          	sext.w	t3,a2
ffffffffc02014be:	0068b423          	sd	t1,8(a7)
ffffffffc02014c2:	01133023          	sd	a7,0(t1)
ffffffffc02014c6:	02d67b63          	bgeu	a2,a3,ffffffffc02014fc <default_alloc_pages+0x84>
ffffffffc02014ca:	00361693          	slli	a3,a2,0x3
ffffffffc02014ce:	96b2                	add	a3,a3,a2
ffffffffc02014d0:	068e                	slli	a3,a3,0x3
ffffffffc02014d2:	96aa                	add	a3,a3,a0
ffffffffc02014d4:	41c7073b          	subw	a4,a4,t3
ffffffffc02014d8:	ce98                	sw	a4,24(a3)
ffffffffc02014da:	00868613          	addi	a2,a3,8
ffffffffc02014de:	4709                	li	a4,2
ffffffffc02014e0:	40e6302f          	amoor.d	zero,a4,(a2)
ffffffffc02014e4:	0088b703          	ld	a4,8(a7)
ffffffffc02014e8:	02068613          	addi	a2,a3,32
ffffffffc02014ec:	0105a803          	lw	a6,16(a1)
ffffffffc02014f0:	e310                	sd	a2,0(a4)
ffffffffc02014f2:	00c8b423          	sd	a2,8(a7)
ffffffffc02014f6:	f698                	sd	a4,40(a3)
ffffffffc02014f8:	0316b023          	sd	a7,32(a3)
ffffffffc02014fc:	41c8083b          	subw	a6,a6,t3
ffffffffc0201500:	0105a823          	sw	a6,16(a1)
ffffffffc0201504:	5775                	li	a4,-3
ffffffffc0201506:	17a1                	addi	a5,a5,-24
ffffffffc0201508:	60e7b02f          	amoand.d	zero,a4,(a5)
ffffffffc020150c:	8082                	ret
ffffffffc020150e:	1141                	addi	sp,sp,-16
ffffffffc0201510:	00004697          	auipc	a3,0x4
ffffffffc0201514:	61068693          	addi	a3,a3,1552 # ffffffffc0205b20 <commands+0xa90>
ffffffffc0201518:	00004617          	auipc	a2,0x4
ffffffffc020151c:	2b060613          	addi	a2,a2,688 # ffffffffc02057c8 <commands+0x738>
ffffffffc0201520:	06200593          	li	a1,98
ffffffffc0201524:	00004517          	auipc	a0,0x4
ffffffffc0201528:	2bc50513          	addi	a0,a0,700 # ffffffffc02057e0 <commands+0x750>
ffffffffc020152c:	e406                	sd	ra,8(sp)
ffffffffc020152e:	f19fe0ef          	jal	ra,ffffffffc0200446 <__panic>

ffffffffc0201532 <default_init_memmap>:
ffffffffc0201532:	1141                	addi	sp,sp,-16
ffffffffc0201534:	e406                	sd	ra,8(sp)
ffffffffc0201536:	c9e1                	beqz	a1,ffffffffc0201606 <default_init_memmap+0xd4>
ffffffffc0201538:	00359693          	slli	a3,a1,0x3
ffffffffc020153c:	96ae                	add	a3,a3,a1
ffffffffc020153e:	068e                	slli	a3,a3,0x3
ffffffffc0201540:	96aa                	add	a3,a3,a0
ffffffffc0201542:	87aa                	mv	a5,a0
ffffffffc0201544:	00d50f63          	beq	a0,a3,ffffffffc0201562 <default_init_memmap+0x30>
ffffffffc0201548:	6798                	ld	a4,8(a5)
ffffffffc020154a:	8b05                	andi	a4,a4,1
ffffffffc020154c:	cf49                	beqz	a4,ffffffffc02015e6 <default_init_memmap+0xb4>
ffffffffc020154e:	0007ac23          	sw	zero,24(a5)
ffffffffc0201552:	0007b423          	sd	zero,8(a5)
ffffffffc0201556:	0007a023          	sw	zero,0(a5)
ffffffffc020155a:	04878793          	addi	a5,a5,72
ffffffffc020155e:	fed795e3          	bne	a5,a3,ffffffffc0201548 <default_init_memmap+0x16>
ffffffffc0201562:	2581                	sext.w	a1,a1
ffffffffc0201564:	cd0c                	sw	a1,24(a0)
ffffffffc0201566:	4789                	li	a5,2
ffffffffc0201568:	00850713          	addi	a4,a0,8
ffffffffc020156c:	40f7302f          	amoor.d	zero,a5,(a4)
ffffffffc0201570:	00010697          	auipc	a3,0x10
ffffffffc0201574:	ef068693          	addi	a3,a3,-272 # ffffffffc0211460 <free_area>
ffffffffc0201578:	4a98                	lw	a4,16(a3)
ffffffffc020157a:	669c                	ld	a5,8(a3)
ffffffffc020157c:	02050613          	addi	a2,a0,32
ffffffffc0201580:	9db9                	addw	a1,a1,a4
ffffffffc0201582:	ca8c                	sw	a1,16(a3)
ffffffffc0201584:	04d78a63          	beq	a5,a3,ffffffffc02015d8 <default_init_memmap+0xa6>
ffffffffc0201588:	fe078713          	addi	a4,a5,-32
ffffffffc020158c:	0006b803          	ld	a6,0(a3)
ffffffffc0201590:	4581                	li	a1,0
ffffffffc0201592:	00e56a63          	bltu	a0,a4,ffffffffc02015a6 <default_init_memmap+0x74>
ffffffffc0201596:	6798                	ld	a4,8(a5)
ffffffffc0201598:	02d70263          	beq	a4,a3,ffffffffc02015bc <default_init_memmap+0x8a>
ffffffffc020159c:	87ba                	mv	a5,a4
ffffffffc020159e:	fe078713          	addi	a4,a5,-32
ffffffffc02015a2:	fee57ae3          	bgeu	a0,a4,ffffffffc0201596 <default_init_memmap+0x64>
ffffffffc02015a6:	c199                	beqz	a1,ffffffffc02015ac <default_init_memmap+0x7a>
ffffffffc02015a8:	0106b023          	sd	a6,0(a3)
ffffffffc02015ac:	6398                	ld	a4,0(a5)
ffffffffc02015ae:	60a2                	ld	ra,8(sp)
ffffffffc02015b0:	e390                	sd	a2,0(a5)
ffffffffc02015b2:	e710                	sd	a2,8(a4)
ffffffffc02015b4:	f51c                	sd	a5,40(a0)
ffffffffc02015b6:	f118                	sd	a4,32(a0)
ffffffffc02015b8:	0141                	addi	sp,sp,16
ffffffffc02015ba:	8082                	ret
ffffffffc02015bc:	e790                	sd	a2,8(a5)
ffffffffc02015be:	f514                	sd	a3,40(a0)
ffffffffc02015c0:	6798                	ld	a4,8(a5)
ffffffffc02015c2:	f11c                	sd	a5,32(a0)
ffffffffc02015c4:	00d70663          	beq	a4,a3,ffffffffc02015d0 <default_init_memmap+0x9e>
ffffffffc02015c8:	8832                	mv	a6,a2
ffffffffc02015ca:	4585                	li	a1,1
ffffffffc02015cc:	87ba                	mv	a5,a4
ffffffffc02015ce:	bfc1                	j	ffffffffc020159e <default_init_memmap+0x6c>
ffffffffc02015d0:	60a2                	ld	ra,8(sp)
ffffffffc02015d2:	e290                	sd	a2,0(a3)
ffffffffc02015d4:	0141                	addi	sp,sp,16
ffffffffc02015d6:	8082                	ret
ffffffffc02015d8:	60a2                	ld	ra,8(sp)
ffffffffc02015da:	e390                	sd	a2,0(a5)
ffffffffc02015dc:	e790                	sd	a2,8(a5)
ffffffffc02015de:	f51c                	sd	a5,40(a0)
ffffffffc02015e0:	f11c                	sd	a5,32(a0)
ffffffffc02015e2:	0141                	addi	sp,sp,16
ffffffffc02015e4:	8082                	ret
ffffffffc02015e6:	00004697          	auipc	a3,0x4
ffffffffc02015ea:	56a68693          	addi	a3,a3,1386 # ffffffffc0205b50 <commands+0xac0>
ffffffffc02015ee:	00004617          	auipc	a2,0x4
ffffffffc02015f2:	1da60613          	addi	a2,a2,474 # ffffffffc02057c8 <commands+0x738>
ffffffffc02015f6:	04900593          	li	a1,73
ffffffffc02015fa:	00004517          	auipc	a0,0x4
ffffffffc02015fe:	1e650513          	addi	a0,a0,486 # ffffffffc02057e0 <commands+0x750>
ffffffffc0201602:	e45fe0ef          	jal	ra,ffffffffc0200446 <__panic>
ffffffffc0201606:	00004697          	auipc	a3,0x4
ffffffffc020160a:	51a68693          	addi	a3,a3,1306 # ffffffffc0205b20 <commands+0xa90>
ffffffffc020160e:	00004617          	auipc	a2,0x4
ffffffffc0201612:	1ba60613          	addi	a2,a2,442 # ffffffffc02057c8 <commands+0x738>
ffffffffc0201616:	04600593          	li	a1,70
ffffffffc020161a:	00004517          	auipc	a0,0x4
ffffffffc020161e:	1c650513          	addi	a0,a0,454 # ffffffffc02057e0 <commands+0x750>
ffffffffc0201622:	e25fe0ef          	jal	ra,ffffffffc0200446 <__panic>

ffffffffc0201626 <slob_free>:
ffffffffc0201626:	c94d                	beqz	a0,ffffffffc02016d8 <slob_free+0xb2>
ffffffffc0201628:	1141                	addi	sp,sp,-16
ffffffffc020162a:	e022                	sd	s0,0(sp)
ffffffffc020162c:	e406                	sd	ra,8(sp)
ffffffffc020162e:	842a                	mv	s0,a0
ffffffffc0201630:	e9c1                	bnez	a1,ffffffffc02016c0 <slob_free+0x9a>
ffffffffc0201632:	100027f3          	csrr	a5,sstatus
ffffffffc0201636:	8b89                	andi	a5,a5,2
ffffffffc0201638:	4501                	li	a0,0
ffffffffc020163a:	ebd9                	bnez	a5,ffffffffc02016d0 <slob_free+0xaa>
ffffffffc020163c:	00009617          	auipc	a2,0x9
ffffffffc0201640:	a1460613          	addi	a2,a2,-1516 # ffffffffc020a050 <slobfree>
ffffffffc0201644:	621c                	ld	a5,0(a2)
ffffffffc0201646:	873e                	mv	a4,a5
ffffffffc0201648:	679c                	ld	a5,8(a5)
ffffffffc020164a:	02877a63          	bgeu	a4,s0,ffffffffc020167e <slob_free+0x58>
ffffffffc020164e:	00f46463          	bltu	s0,a5,ffffffffc0201656 <slob_free+0x30>
ffffffffc0201652:	fef76ae3          	bltu	a4,a5,ffffffffc0201646 <slob_free+0x20>
ffffffffc0201656:	400c                	lw	a1,0(s0)
ffffffffc0201658:	00459693          	slli	a3,a1,0x4
ffffffffc020165c:	96a2                	add	a3,a3,s0
ffffffffc020165e:	02d78a63          	beq	a5,a3,ffffffffc0201692 <slob_free+0x6c>
ffffffffc0201662:	4314                	lw	a3,0(a4)
ffffffffc0201664:	e41c                	sd	a5,8(s0)
ffffffffc0201666:	00469793          	slli	a5,a3,0x4
ffffffffc020166a:	97ba                	add	a5,a5,a4
ffffffffc020166c:	02f40e63          	beq	s0,a5,ffffffffc02016a8 <slob_free+0x82>
ffffffffc0201670:	e700                	sd	s0,8(a4)
ffffffffc0201672:	e218                	sd	a4,0(a2)
ffffffffc0201674:	e129                	bnez	a0,ffffffffc02016b6 <slob_free+0x90>
ffffffffc0201676:	60a2                	ld	ra,8(sp)
ffffffffc0201678:	6402                	ld	s0,0(sp)
ffffffffc020167a:	0141                	addi	sp,sp,16
ffffffffc020167c:	8082                	ret
ffffffffc020167e:	fcf764e3          	bltu	a4,a5,ffffffffc0201646 <slob_free+0x20>
ffffffffc0201682:	fcf472e3          	bgeu	s0,a5,ffffffffc0201646 <slob_free+0x20>
ffffffffc0201686:	400c                	lw	a1,0(s0)
ffffffffc0201688:	00459693          	slli	a3,a1,0x4
ffffffffc020168c:	96a2                	add	a3,a3,s0
ffffffffc020168e:	fcd79ae3          	bne	a5,a3,ffffffffc0201662 <slob_free+0x3c>
ffffffffc0201692:	4394                	lw	a3,0(a5)
ffffffffc0201694:	679c                	ld	a5,8(a5)
ffffffffc0201696:	9db5                	addw	a1,a1,a3
ffffffffc0201698:	c00c                	sw	a1,0(s0)
ffffffffc020169a:	4314                	lw	a3,0(a4)
ffffffffc020169c:	e41c                	sd	a5,8(s0)
ffffffffc020169e:	00469793          	slli	a5,a3,0x4
ffffffffc02016a2:	97ba                	add	a5,a5,a4
ffffffffc02016a4:	fcf416e3          	bne	s0,a5,ffffffffc0201670 <slob_free+0x4a>
ffffffffc02016a8:	401c                	lw	a5,0(s0)
ffffffffc02016aa:	640c                	ld	a1,8(s0)
ffffffffc02016ac:	e218                	sd	a4,0(a2)
ffffffffc02016ae:	9ebd                	addw	a3,a3,a5
ffffffffc02016b0:	c314                	sw	a3,0(a4)
ffffffffc02016b2:	e70c                	sd	a1,8(a4)
ffffffffc02016b4:	d169                	beqz	a0,ffffffffc0201676 <slob_free+0x50>
ffffffffc02016b6:	6402                	ld	s0,0(sp)
ffffffffc02016b8:	60a2                	ld	ra,8(sp)
ffffffffc02016ba:	0141                	addi	sp,sp,16
ffffffffc02016bc:	eddfe06f          	j	ffffffffc0200598 <intr_enable>
ffffffffc02016c0:	25bd                	addiw	a1,a1,15
ffffffffc02016c2:	8191                	srli	a1,a1,0x4
ffffffffc02016c4:	c10c                	sw	a1,0(a0)
ffffffffc02016c6:	100027f3          	csrr	a5,sstatus
ffffffffc02016ca:	8b89                	andi	a5,a5,2
ffffffffc02016cc:	4501                	li	a0,0
ffffffffc02016ce:	d7bd                	beqz	a5,ffffffffc020163c <slob_free+0x16>
ffffffffc02016d0:	ecffe0ef          	jal	ra,ffffffffc020059e <intr_disable>
ffffffffc02016d4:	4505                	li	a0,1
ffffffffc02016d6:	b79d                	j	ffffffffc020163c <slob_free+0x16>
ffffffffc02016d8:	8082                	ret

ffffffffc02016da <__slob_get_free_pages.constprop.0>:
ffffffffc02016da:	4785                	li	a5,1
ffffffffc02016dc:	1141                	addi	sp,sp,-16
ffffffffc02016de:	00a7953b          	sllw	a0,a5,a0
ffffffffc02016e2:	e406                	sd	ra,8(sp)
ffffffffc02016e4:	360000ef          	jal	ra,ffffffffc0201a44 <alloc_pages>
ffffffffc02016e8:	c129                	beqz	a0,ffffffffc020172a <__slob_get_free_pages.constprop.0+0x50>
ffffffffc02016ea:	00014697          	auipc	a3,0x14
ffffffffc02016ee:	e866b683          	ld	a3,-378(a3) # ffffffffc0215570 <pages>
ffffffffc02016f2:	8d15                	sub	a0,a0,a3
ffffffffc02016f4:	850d                	srai	a0,a0,0x3
ffffffffc02016f6:	00005697          	auipc	a3,0x5
ffffffffc02016fa:	76a6b683          	ld	a3,1898(a3) # ffffffffc0206e60 <error_string+0x38>
ffffffffc02016fe:	02d50533          	mul	a0,a0,a3
ffffffffc0201702:	00005697          	auipc	a3,0x5
ffffffffc0201706:	7666b683          	ld	a3,1894(a3) # ffffffffc0206e68 <nbase>
ffffffffc020170a:	00014717          	auipc	a4,0x14
ffffffffc020170e:	e5e73703          	ld	a4,-418(a4) # ffffffffc0215568 <npage>
ffffffffc0201712:	9536                	add	a0,a0,a3
ffffffffc0201714:	00c51793          	slli	a5,a0,0xc
ffffffffc0201718:	83b1                	srli	a5,a5,0xc
ffffffffc020171a:	0532                	slli	a0,a0,0xc
ffffffffc020171c:	00e7fa63          	bgeu	a5,a4,ffffffffc0201730 <__slob_get_free_pages.constprop.0+0x56>
ffffffffc0201720:	00014697          	auipc	a3,0x14
ffffffffc0201724:	e606b683          	ld	a3,-416(a3) # ffffffffc0215580 <va_pa_offset>
ffffffffc0201728:	9536                	add	a0,a0,a3
ffffffffc020172a:	60a2                	ld	ra,8(sp)
ffffffffc020172c:	0141                	addi	sp,sp,16
ffffffffc020172e:	8082                	ret
ffffffffc0201730:	86aa                	mv	a3,a0
ffffffffc0201732:	00004617          	auipc	a2,0x4
ffffffffc0201736:	47e60613          	addi	a2,a2,1150 # ffffffffc0205bb0 <default_pmm_manager+0x38>
ffffffffc020173a:	06900593          	li	a1,105
ffffffffc020173e:	00004517          	auipc	a0,0x4
ffffffffc0201742:	49a50513          	addi	a0,a0,1178 # ffffffffc0205bd8 <default_pmm_manager+0x60>
ffffffffc0201746:	d01fe0ef          	jal	ra,ffffffffc0200446 <__panic>

ffffffffc020174a <slob_alloc.constprop.0>:
ffffffffc020174a:	1101                	addi	sp,sp,-32
ffffffffc020174c:	ec06                	sd	ra,24(sp)
ffffffffc020174e:	e822                	sd	s0,16(sp)
ffffffffc0201750:	e426                	sd	s1,8(sp)
ffffffffc0201752:	e04a                	sd	s2,0(sp)
ffffffffc0201754:	01050713          	addi	a4,a0,16
ffffffffc0201758:	6785                	lui	a5,0x1
ffffffffc020175a:	0cf77363          	bgeu	a4,a5,ffffffffc0201820 <slob_alloc.constprop.0+0xd6>
ffffffffc020175e:	00f50493          	addi	s1,a0,15
ffffffffc0201762:	8091                	srli	s1,s1,0x4
ffffffffc0201764:	2481                	sext.w	s1,s1
ffffffffc0201766:	10002673          	csrr	a2,sstatus
ffffffffc020176a:	8a09                	andi	a2,a2,2
ffffffffc020176c:	e25d                	bnez	a2,ffffffffc0201812 <slob_alloc.constprop.0+0xc8>
ffffffffc020176e:	00009917          	auipc	s2,0x9
ffffffffc0201772:	8e290913          	addi	s2,s2,-1822 # ffffffffc020a050 <slobfree>
ffffffffc0201776:	00093683          	ld	a3,0(s2)
ffffffffc020177a:	669c                	ld	a5,8(a3)
ffffffffc020177c:	4398                	lw	a4,0(a5)
ffffffffc020177e:	08975e63          	bge	a4,s1,ffffffffc020181a <slob_alloc.constprop.0+0xd0>
ffffffffc0201782:	00d78b63          	beq	a5,a3,ffffffffc0201798 <slob_alloc.constprop.0+0x4e>
ffffffffc0201786:	6780                	ld	s0,8(a5)
ffffffffc0201788:	4018                	lw	a4,0(s0)
ffffffffc020178a:	02975a63          	bge	a4,s1,ffffffffc02017be <slob_alloc.constprop.0+0x74>
ffffffffc020178e:	00093683          	ld	a3,0(s2)
ffffffffc0201792:	87a2                	mv	a5,s0
ffffffffc0201794:	fed799e3          	bne	a5,a3,ffffffffc0201786 <slob_alloc.constprop.0+0x3c>
ffffffffc0201798:	ee31                	bnez	a2,ffffffffc02017f4 <slob_alloc.constprop.0+0xaa>
ffffffffc020179a:	4501                	li	a0,0
ffffffffc020179c:	f3fff0ef          	jal	ra,ffffffffc02016da <__slob_get_free_pages.constprop.0>
ffffffffc02017a0:	842a                	mv	s0,a0
ffffffffc02017a2:	cd05                	beqz	a0,ffffffffc02017da <slob_alloc.constprop.0+0x90>
ffffffffc02017a4:	6585                	lui	a1,0x1
ffffffffc02017a6:	e81ff0ef          	jal	ra,ffffffffc0201626 <slob_free>
ffffffffc02017aa:	10002673          	csrr	a2,sstatus
ffffffffc02017ae:	8a09                	andi	a2,a2,2
ffffffffc02017b0:	ee05                	bnez	a2,ffffffffc02017e8 <slob_alloc.constprop.0+0x9e>
ffffffffc02017b2:	00093783          	ld	a5,0(s2)
ffffffffc02017b6:	6780                	ld	s0,8(a5)
ffffffffc02017b8:	4018                	lw	a4,0(s0)
ffffffffc02017ba:	fc974ae3          	blt	a4,s1,ffffffffc020178e <slob_alloc.constprop.0+0x44>
ffffffffc02017be:	04e48763          	beq	s1,a4,ffffffffc020180c <slob_alloc.constprop.0+0xc2>
ffffffffc02017c2:	00449693          	slli	a3,s1,0x4
ffffffffc02017c6:	96a2                	add	a3,a3,s0
ffffffffc02017c8:	e794                	sd	a3,8(a5)
ffffffffc02017ca:	640c                	ld	a1,8(s0)
ffffffffc02017cc:	9f05                	subw	a4,a4,s1
ffffffffc02017ce:	c298                	sw	a4,0(a3)
ffffffffc02017d0:	e68c                	sd	a1,8(a3)
ffffffffc02017d2:	c004                	sw	s1,0(s0)
ffffffffc02017d4:	00f93023          	sd	a5,0(s2)
ffffffffc02017d8:	e20d                	bnez	a2,ffffffffc02017fa <slob_alloc.constprop.0+0xb0>
ffffffffc02017da:	60e2                	ld	ra,24(sp)
ffffffffc02017dc:	8522                	mv	a0,s0
ffffffffc02017de:	6442                	ld	s0,16(sp)
ffffffffc02017e0:	64a2                	ld	s1,8(sp)
ffffffffc02017e2:	6902                	ld	s2,0(sp)
ffffffffc02017e4:	6105                	addi	sp,sp,32
ffffffffc02017e6:	8082                	ret
ffffffffc02017e8:	db7fe0ef          	jal	ra,ffffffffc020059e <intr_disable>
ffffffffc02017ec:	00093783          	ld	a5,0(s2)
ffffffffc02017f0:	4605                	li	a2,1
ffffffffc02017f2:	b7d1                	j	ffffffffc02017b6 <slob_alloc.constprop.0+0x6c>
ffffffffc02017f4:	da5fe0ef          	jal	ra,ffffffffc0200598 <intr_enable>
ffffffffc02017f8:	b74d                	j	ffffffffc020179a <slob_alloc.constprop.0+0x50>
ffffffffc02017fa:	d9ffe0ef          	jal	ra,ffffffffc0200598 <intr_enable>
ffffffffc02017fe:	60e2                	ld	ra,24(sp)
ffffffffc0201800:	8522                	mv	a0,s0
ffffffffc0201802:	6442                	ld	s0,16(sp)
ffffffffc0201804:	64a2                	ld	s1,8(sp)
ffffffffc0201806:	6902                	ld	s2,0(sp)
ffffffffc0201808:	6105                	addi	sp,sp,32
ffffffffc020180a:	8082                	ret
ffffffffc020180c:	6418                	ld	a4,8(s0)
ffffffffc020180e:	e798                	sd	a4,8(a5)
ffffffffc0201810:	b7d1                	j	ffffffffc02017d4 <slob_alloc.constprop.0+0x8a>
ffffffffc0201812:	d8dfe0ef          	jal	ra,ffffffffc020059e <intr_disable>
ffffffffc0201816:	4605                	li	a2,1
ffffffffc0201818:	bf99                	j	ffffffffc020176e <slob_alloc.constprop.0+0x24>
ffffffffc020181a:	843e                	mv	s0,a5
ffffffffc020181c:	87b6                	mv	a5,a3
ffffffffc020181e:	b745                	j	ffffffffc02017be <slob_alloc.constprop.0+0x74>
ffffffffc0201820:	00004697          	auipc	a3,0x4
ffffffffc0201824:	3c868693          	addi	a3,a3,968 # ffffffffc0205be8 <default_pmm_manager+0x70>
ffffffffc0201828:	00004617          	auipc	a2,0x4
ffffffffc020182c:	fa060613          	addi	a2,a2,-96 # ffffffffc02057c8 <commands+0x738>
ffffffffc0201830:	06300593          	li	a1,99
ffffffffc0201834:	00004517          	auipc	a0,0x4
ffffffffc0201838:	3d450513          	addi	a0,a0,980 # ffffffffc0205c08 <default_pmm_manager+0x90>
ffffffffc020183c:	c0bfe0ef          	jal	ra,ffffffffc0200446 <__panic>

ffffffffc0201840 <kmalloc_init>:
ffffffffc0201840:	1141                	addi	sp,sp,-16
ffffffffc0201842:	00004517          	auipc	a0,0x4
ffffffffc0201846:	3de50513          	addi	a0,a0,990 # ffffffffc0205c20 <default_pmm_manager+0xa8>
ffffffffc020184a:	e406                	sd	ra,8(sp)
ffffffffc020184c:	935fe0ef          	jal	ra,ffffffffc0200180 <cprintf>
ffffffffc0201850:	60a2                	ld	ra,8(sp)
ffffffffc0201852:	00004517          	auipc	a0,0x4
ffffffffc0201856:	3e650513          	addi	a0,a0,998 # ffffffffc0205c38 <default_pmm_manager+0xc0>
ffffffffc020185a:	0141                	addi	sp,sp,16
ffffffffc020185c:	925fe06f          	j	ffffffffc0200180 <cprintf>

ffffffffc0201860 <kmalloc>:
ffffffffc0201860:	1101                	addi	sp,sp,-32
ffffffffc0201862:	e04a                	sd	s2,0(sp)
ffffffffc0201864:	6905                	lui	s2,0x1
ffffffffc0201866:	e822                	sd	s0,16(sp)
ffffffffc0201868:	ec06                	sd	ra,24(sp)
ffffffffc020186a:	e426                	sd	s1,8(sp)
ffffffffc020186c:	fef90793          	addi	a5,s2,-17 # fef <kern_entry-0xffffffffc01ff011>
ffffffffc0201870:	842a                	mv	s0,a0
ffffffffc0201872:	04a7f963          	bgeu	a5,a0,ffffffffc02018c4 <kmalloc+0x64>
ffffffffc0201876:	4561                	li	a0,24
ffffffffc0201878:	ed3ff0ef          	jal	ra,ffffffffc020174a <slob_alloc.constprop.0>
ffffffffc020187c:	84aa                	mv	s1,a0
ffffffffc020187e:	c929                	beqz	a0,ffffffffc02018d0 <kmalloc+0x70>
ffffffffc0201880:	0004079b          	sext.w	a5,s0
ffffffffc0201884:	4501                	li	a0,0
ffffffffc0201886:	00f95763          	bge	s2,a5,ffffffffc0201894 <kmalloc+0x34>
ffffffffc020188a:	6705                	lui	a4,0x1
ffffffffc020188c:	8785                	srai	a5,a5,0x1
ffffffffc020188e:	2505                	addiw	a0,a0,1
ffffffffc0201890:	fef74ee3          	blt	a4,a5,ffffffffc020188c <kmalloc+0x2c>
ffffffffc0201894:	c088                	sw	a0,0(s1)
ffffffffc0201896:	e45ff0ef          	jal	ra,ffffffffc02016da <__slob_get_free_pages.constprop.0>
ffffffffc020189a:	e488                	sd	a0,8(s1)
ffffffffc020189c:	842a                	mv	s0,a0
ffffffffc020189e:	c525                	beqz	a0,ffffffffc0201906 <kmalloc+0xa6>
ffffffffc02018a0:	100027f3          	csrr	a5,sstatus
ffffffffc02018a4:	8b89                	andi	a5,a5,2
ffffffffc02018a6:	ef8d                	bnez	a5,ffffffffc02018e0 <kmalloc+0x80>
ffffffffc02018a8:	00014797          	auipc	a5,0x14
ffffffffc02018ac:	ca878793          	addi	a5,a5,-856 # ffffffffc0215550 <bigblocks>
ffffffffc02018b0:	6398                	ld	a4,0(a5)
ffffffffc02018b2:	e384                	sd	s1,0(a5)
ffffffffc02018b4:	e898                	sd	a4,16(s1)
ffffffffc02018b6:	60e2                	ld	ra,24(sp)
ffffffffc02018b8:	8522                	mv	a0,s0
ffffffffc02018ba:	6442                	ld	s0,16(sp)
ffffffffc02018bc:	64a2                	ld	s1,8(sp)
ffffffffc02018be:	6902                	ld	s2,0(sp)
ffffffffc02018c0:	6105                	addi	sp,sp,32
ffffffffc02018c2:	8082                	ret
ffffffffc02018c4:	0541                	addi	a0,a0,16
ffffffffc02018c6:	e85ff0ef          	jal	ra,ffffffffc020174a <slob_alloc.constprop.0>
ffffffffc02018ca:	01050413          	addi	s0,a0,16
ffffffffc02018ce:	f565                	bnez	a0,ffffffffc02018b6 <kmalloc+0x56>
ffffffffc02018d0:	4401                	li	s0,0
ffffffffc02018d2:	60e2                	ld	ra,24(sp)
ffffffffc02018d4:	8522                	mv	a0,s0
ffffffffc02018d6:	6442                	ld	s0,16(sp)
ffffffffc02018d8:	64a2                	ld	s1,8(sp)
ffffffffc02018da:	6902                	ld	s2,0(sp)
ffffffffc02018dc:	6105                	addi	sp,sp,32
ffffffffc02018de:	8082                	ret
ffffffffc02018e0:	cbffe0ef          	jal	ra,ffffffffc020059e <intr_disable>
ffffffffc02018e4:	00014797          	auipc	a5,0x14
ffffffffc02018e8:	c6c78793          	addi	a5,a5,-916 # ffffffffc0215550 <bigblocks>
ffffffffc02018ec:	6398                	ld	a4,0(a5)
ffffffffc02018ee:	e384                	sd	s1,0(a5)
ffffffffc02018f0:	e898                	sd	a4,16(s1)
ffffffffc02018f2:	ca7fe0ef          	jal	ra,ffffffffc0200598 <intr_enable>
ffffffffc02018f6:	6480                	ld	s0,8(s1)
ffffffffc02018f8:	60e2                	ld	ra,24(sp)
ffffffffc02018fa:	64a2                	ld	s1,8(sp)
ffffffffc02018fc:	8522                	mv	a0,s0
ffffffffc02018fe:	6442                	ld	s0,16(sp)
ffffffffc0201900:	6902                	ld	s2,0(sp)
ffffffffc0201902:	6105                	addi	sp,sp,32
ffffffffc0201904:	8082                	ret
ffffffffc0201906:	45e1                	li	a1,24
ffffffffc0201908:	8526                	mv	a0,s1
ffffffffc020190a:	d1dff0ef          	jal	ra,ffffffffc0201626 <slob_free>
ffffffffc020190e:	b765                	j	ffffffffc02018b6 <kmalloc+0x56>

ffffffffc0201910 <kfree>:
ffffffffc0201910:	c561                	beqz	a0,ffffffffc02019d8 <kfree+0xc8>
ffffffffc0201912:	1101                	addi	sp,sp,-32
ffffffffc0201914:	e822                	sd	s0,16(sp)
ffffffffc0201916:	ec06                	sd	ra,24(sp)
ffffffffc0201918:	e426                	sd	s1,8(sp)
ffffffffc020191a:	03451793          	slli	a5,a0,0x34
ffffffffc020191e:	842a                	mv	s0,a0
ffffffffc0201920:	e7d1                	bnez	a5,ffffffffc02019ac <kfree+0x9c>
ffffffffc0201922:	100027f3          	csrr	a5,sstatus
ffffffffc0201926:	8b89                	andi	a5,a5,2
ffffffffc0201928:	ebd1                	bnez	a5,ffffffffc02019bc <kfree+0xac>
ffffffffc020192a:	00014797          	auipc	a5,0x14
ffffffffc020192e:	c267b783          	ld	a5,-986(a5) # ffffffffc0215550 <bigblocks>
ffffffffc0201932:	4601                	li	a2,0
ffffffffc0201934:	cfa5                	beqz	a5,ffffffffc02019ac <kfree+0x9c>
ffffffffc0201936:	00014697          	auipc	a3,0x14
ffffffffc020193a:	c1a68693          	addi	a3,a3,-998 # ffffffffc0215550 <bigblocks>
ffffffffc020193e:	a021                	j	ffffffffc0201946 <kfree+0x36>
ffffffffc0201940:	01048693          	addi	a3,s1,16
ffffffffc0201944:	c3bd                	beqz	a5,ffffffffc02019aa <kfree+0x9a>
ffffffffc0201946:	6798                	ld	a4,8(a5)
ffffffffc0201948:	84be                	mv	s1,a5
ffffffffc020194a:	6b9c                	ld	a5,16(a5)
ffffffffc020194c:	fe871ae3          	bne	a4,s0,ffffffffc0201940 <kfree+0x30>
ffffffffc0201950:	e29c                	sd	a5,0(a3)
ffffffffc0201952:	e241                	bnez	a2,ffffffffc02019d2 <kfree+0xc2>
ffffffffc0201954:	c02007b7          	lui	a5,0xc0200
ffffffffc0201958:	4098                	lw	a4,0(s1)
ffffffffc020195a:	08f46c63          	bltu	s0,a5,ffffffffc02019f2 <kfree+0xe2>
ffffffffc020195e:	00014697          	auipc	a3,0x14
ffffffffc0201962:	c226b683          	ld	a3,-990(a3) # ffffffffc0215580 <va_pa_offset>
ffffffffc0201966:	8c15                	sub	s0,s0,a3
ffffffffc0201968:	8031                	srli	s0,s0,0xc
ffffffffc020196a:	00014797          	auipc	a5,0x14
ffffffffc020196e:	bfe7b783          	ld	a5,-1026(a5) # ffffffffc0215568 <npage>
ffffffffc0201972:	06f47463          	bgeu	s0,a5,ffffffffc02019da <kfree+0xca>
ffffffffc0201976:	00005797          	auipc	a5,0x5
ffffffffc020197a:	4f27b783          	ld	a5,1266(a5) # ffffffffc0206e68 <nbase>
ffffffffc020197e:	8c1d                	sub	s0,s0,a5
ffffffffc0201980:	00341513          	slli	a0,s0,0x3
ffffffffc0201984:	942a                	add	s0,s0,a0
ffffffffc0201986:	040e                	slli	s0,s0,0x3
ffffffffc0201988:	00014517          	auipc	a0,0x14
ffffffffc020198c:	be853503          	ld	a0,-1048(a0) # ffffffffc0215570 <pages>
ffffffffc0201990:	4585                	li	a1,1
ffffffffc0201992:	9522                	add	a0,a0,s0
ffffffffc0201994:	00e595bb          	sllw	a1,a1,a4
ffffffffc0201998:	13e000ef          	jal	ra,ffffffffc0201ad6 <free_pages>
ffffffffc020199c:	6442                	ld	s0,16(sp)
ffffffffc020199e:	60e2                	ld	ra,24(sp)
ffffffffc02019a0:	8526                	mv	a0,s1
ffffffffc02019a2:	64a2                	ld	s1,8(sp)
ffffffffc02019a4:	45e1                	li	a1,24
ffffffffc02019a6:	6105                	addi	sp,sp,32
ffffffffc02019a8:	b9bd                	j	ffffffffc0201626 <slob_free>
ffffffffc02019aa:	e20d                	bnez	a2,ffffffffc02019cc <kfree+0xbc>
ffffffffc02019ac:	ff040513          	addi	a0,s0,-16
ffffffffc02019b0:	6442                	ld	s0,16(sp)
ffffffffc02019b2:	60e2                	ld	ra,24(sp)
ffffffffc02019b4:	64a2                	ld	s1,8(sp)
ffffffffc02019b6:	4581                	li	a1,0
ffffffffc02019b8:	6105                	addi	sp,sp,32
ffffffffc02019ba:	b1b5                	j	ffffffffc0201626 <slob_free>
ffffffffc02019bc:	be3fe0ef          	jal	ra,ffffffffc020059e <intr_disable>
ffffffffc02019c0:	00014797          	auipc	a5,0x14
ffffffffc02019c4:	b907b783          	ld	a5,-1136(a5) # ffffffffc0215550 <bigblocks>
ffffffffc02019c8:	4605                	li	a2,1
ffffffffc02019ca:	f7b5                	bnez	a5,ffffffffc0201936 <kfree+0x26>
ffffffffc02019cc:	bcdfe0ef          	jal	ra,ffffffffc0200598 <intr_enable>
ffffffffc02019d0:	bff1                	j	ffffffffc02019ac <kfree+0x9c>
ffffffffc02019d2:	bc7fe0ef          	jal	ra,ffffffffc0200598 <intr_enable>
ffffffffc02019d6:	bfbd                	j	ffffffffc0201954 <kfree+0x44>
ffffffffc02019d8:	8082                	ret
ffffffffc02019da:	00004617          	auipc	a2,0x4
ffffffffc02019de:	2a660613          	addi	a2,a2,678 # ffffffffc0205c80 <default_pmm_manager+0x108>
ffffffffc02019e2:	06200593          	li	a1,98
ffffffffc02019e6:	00004517          	auipc	a0,0x4
ffffffffc02019ea:	1f250513          	addi	a0,a0,498 # ffffffffc0205bd8 <default_pmm_manager+0x60>
ffffffffc02019ee:	a59fe0ef          	jal	ra,ffffffffc0200446 <__panic>
ffffffffc02019f2:	86a2                	mv	a3,s0
ffffffffc02019f4:	00004617          	auipc	a2,0x4
ffffffffc02019f8:	26460613          	addi	a2,a2,612 # ffffffffc0205c58 <default_pmm_manager+0xe0>
ffffffffc02019fc:	06e00593          	li	a1,110
ffffffffc0201a00:	00004517          	auipc	a0,0x4
ffffffffc0201a04:	1d850513          	addi	a0,a0,472 # ffffffffc0205bd8 <default_pmm_manager+0x60>
ffffffffc0201a08:	a3ffe0ef          	jal	ra,ffffffffc0200446 <__panic>

ffffffffc0201a0c <pa2page.part.0>:
ffffffffc0201a0c:	1141                	addi	sp,sp,-16
ffffffffc0201a0e:	00004617          	auipc	a2,0x4
ffffffffc0201a12:	27260613          	addi	a2,a2,626 # ffffffffc0205c80 <default_pmm_manager+0x108>
ffffffffc0201a16:	06200593          	li	a1,98
ffffffffc0201a1a:	00004517          	auipc	a0,0x4
ffffffffc0201a1e:	1be50513          	addi	a0,a0,446 # ffffffffc0205bd8 <default_pmm_manager+0x60>
ffffffffc0201a22:	e406                	sd	ra,8(sp)
ffffffffc0201a24:	a23fe0ef          	jal	ra,ffffffffc0200446 <__panic>

ffffffffc0201a28 <pte2page.part.0>:
ffffffffc0201a28:	1141                	addi	sp,sp,-16
ffffffffc0201a2a:	00004617          	auipc	a2,0x4
ffffffffc0201a2e:	27660613          	addi	a2,a2,630 # ffffffffc0205ca0 <default_pmm_manager+0x128>
ffffffffc0201a32:	07400593          	li	a1,116
ffffffffc0201a36:	00004517          	auipc	a0,0x4
ffffffffc0201a3a:	1a250513          	addi	a0,a0,418 # ffffffffc0205bd8 <default_pmm_manager+0x60>
ffffffffc0201a3e:	e406                	sd	ra,8(sp)
ffffffffc0201a40:	a07fe0ef          	jal	ra,ffffffffc0200446 <__panic>

ffffffffc0201a44 <alloc_pages>:
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
ffffffffc0201a5c:	b2090913          	addi	s2,s2,-1248 # ffffffffc0215578 <pmm_manager>
ffffffffc0201a60:	4a05                	li	s4,1
ffffffffc0201a62:	00014a97          	auipc	s5,0x14
ffffffffc0201a66:	b36a8a93          	addi	s5,s5,-1226 # ffffffffc0215598 <swap_init_ok>
ffffffffc0201a6a:	0005099b          	sext.w	s3,a0
ffffffffc0201a6e:	00014b17          	auipc	s6,0x14
ffffffffc0201a72:	b32b0b13          	addi	s6,s6,-1230 # ffffffffc02155a0 <check_mm_struct>
ffffffffc0201a76:	a01d                	j	ffffffffc0201a9c <alloc_pages+0x58>
ffffffffc0201a78:	00093783          	ld	a5,0(s2)
ffffffffc0201a7c:	6f9c                	ld	a5,24(a5)
ffffffffc0201a7e:	9782                	jalr	a5
ffffffffc0201a80:	842a                	mv	s0,a0
ffffffffc0201a82:	4601                	li	a2,0
ffffffffc0201a84:	85ce                	mv	a1,s3
ffffffffc0201a86:	ec0d                	bnez	s0,ffffffffc0201ac0 <alloc_pages+0x7c>
ffffffffc0201a88:	029a6c63          	bltu	s4,s1,ffffffffc0201ac0 <alloc_pages+0x7c>
ffffffffc0201a8c:	000aa783          	lw	a5,0(s5)
ffffffffc0201a90:	2781                	sext.w	a5,a5
ffffffffc0201a92:	c79d                	beqz	a5,ffffffffc0201ac0 <alloc_pages+0x7c>
ffffffffc0201a94:	000b3503          	ld	a0,0(s6)
ffffffffc0201a98:	10b010ef          	jal	ra,ffffffffc02033a2 <swap_out>
ffffffffc0201a9c:	100027f3          	csrr	a5,sstatus
ffffffffc0201aa0:	8b89                	andi	a5,a5,2
ffffffffc0201aa2:	8526                	mv	a0,s1
ffffffffc0201aa4:	dbf1                	beqz	a5,ffffffffc0201a78 <alloc_pages+0x34>
ffffffffc0201aa6:	af9fe0ef          	jal	ra,ffffffffc020059e <intr_disable>
ffffffffc0201aaa:	00093783          	ld	a5,0(s2)
ffffffffc0201aae:	8526                	mv	a0,s1
ffffffffc0201ab0:	6f9c                	ld	a5,24(a5)
ffffffffc0201ab2:	9782                	jalr	a5
ffffffffc0201ab4:	842a                	mv	s0,a0
ffffffffc0201ab6:	ae3fe0ef          	jal	ra,ffffffffc0200598 <intr_enable>
ffffffffc0201aba:	4601                	li	a2,0
ffffffffc0201abc:	85ce                	mv	a1,s3
ffffffffc0201abe:	d469                	beqz	s0,ffffffffc0201a88 <alloc_pages+0x44>
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
ffffffffc0201ad6:	100027f3          	csrr	a5,sstatus
ffffffffc0201ada:	8b89                	andi	a5,a5,2
ffffffffc0201adc:	e799                	bnez	a5,ffffffffc0201aea <free_pages+0x14>
ffffffffc0201ade:	00014797          	auipc	a5,0x14
ffffffffc0201ae2:	a9a7b783          	ld	a5,-1382(a5) # ffffffffc0215578 <pmm_manager>
ffffffffc0201ae6:	739c                	ld	a5,32(a5)
ffffffffc0201ae8:	8782                	jr	a5
ffffffffc0201aea:	1101                	addi	sp,sp,-32
ffffffffc0201aec:	ec06                	sd	ra,24(sp)
ffffffffc0201aee:	e822                	sd	s0,16(sp)
ffffffffc0201af0:	e426                	sd	s1,8(sp)
ffffffffc0201af2:	842a                	mv	s0,a0
ffffffffc0201af4:	84ae                	mv	s1,a1
ffffffffc0201af6:	aa9fe0ef          	jal	ra,ffffffffc020059e <intr_disable>
ffffffffc0201afa:	00014797          	auipc	a5,0x14
ffffffffc0201afe:	a7e7b783          	ld	a5,-1410(a5) # ffffffffc0215578 <pmm_manager>
ffffffffc0201b02:	739c                	ld	a5,32(a5)
ffffffffc0201b04:	85a6                	mv	a1,s1
ffffffffc0201b06:	8522                	mv	a0,s0
ffffffffc0201b08:	9782                	jalr	a5
ffffffffc0201b0a:	6442                	ld	s0,16(sp)
ffffffffc0201b0c:	60e2                	ld	ra,24(sp)
ffffffffc0201b0e:	64a2                	ld	s1,8(sp)
ffffffffc0201b10:	6105                	addi	sp,sp,32
ffffffffc0201b12:	a87fe06f          	j	ffffffffc0200598 <intr_enable>

ffffffffc0201b16 <nr_free_pages>:
ffffffffc0201b16:	100027f3          	csrr	a5,sstatus
ffffffffc0201b1a:	8b89                	andi	a5,a5,2
ffffffffc0201b1c:	e799                	bnez	a5,ffffffffc0201b2a <nr_free_pages+0x14>
ffffffffc0201b1e:	00014797          	auipc	a5,0x14
ffffffffc0201b22:	a5a7b783          	ld	a5,-1446(a5) # ffffffffc0215578 <pmm_manager>
ffffffffc0201b26:	779c                	ld	a5,40(a5)
ffffffffc0201b28:	8782                	jr	a5
ffffffffc0201b2a:	1141                	addi	sp,sp,-16
ffffffffc0201b2c:	e406                	sd	ra,8(sp)
ffffffffc0201b2e:	e022                	sd	s0,0(sp)
ffffffffc0201b30:	a6ffe0ef          	jal	ra,ffffffffc020059e <intr_disable>
ffffffffc0201b34:	00014797          	auipc	a5,0x14
ffffffffc0201b38:	a447b783          	ld	a5,-1468(a5) # ffffffffc0215578 <pmm_manager>
ffffffffc0201b3c:	779c                	ld	a5,40(a5)
ffffffffc0201b3e:	9782                	jalr	a5
ffffffffc0201b40:	842a                	mv	s0,a0
ffffffffc0201b42:	a57fe0ef          	jal	ra,ffffffffc0200598 <intr_enable>
ffffffffc0201b46:	60a2                	ld	ra,8(sp)
ffffffffc0201b48:	8522                	mv	a0,s0
ffffffffc0201b4a:	6402                	ld	s0,0(sp)
ffffffffc0201b4c:	0141                	addi	sp,sp,16
ffffffffc0201b4e:	8082                	ret

ffffffffc0201b50 <get_pte>:
ffffffffc0201b50:	01e5d793          	srli	a5,a1,0x1e
ffffffffc0201b54:	1ff7f793          	andi	a5,a5,511
ffffffffc0201b58:	715d                	addi	sp,sp,-80
ffffffffc0201b5a:	078e                	slli	a5,a5,0x3
ffffffffc0201b5c:	fc26                	sd	s1,56(sp)
ffffffffc0201b5e:	00f504b3          	add	s1,a0,a5
ffffffffc0201b62:	6094                	ld	a3,0(s1)
ffffffffc0201b64:	f84a                	sd	s2,48(sp)
ffffffffc0201b66:	f44e                	sd	s3,40(sp)
ffffffffc0201b68:	f052                	sd	s4,32(sp)
ffffffffc0201b6a:	e486                	sd	ra,72(sp)
ffffffffc0201b6c:	e0a2                	sd	s0,64(sp)
ffffffffc0201b6e:	ec56                	sd	s5,24(sp)
ffffffffc0201b70:	e85a                	sd	s6,16(sp)
ffffffffc0201b72:	e45e                	sd	s7,8(sp)
ffffffffc0201b74:	0016f793          	andi	a5,a3,1
ffffffffc0201b78:	892e                	mv	s2,a1
ffffffffc0201b7a:	8a32                	mv	s4,a2
ffffffffc0201b7c:	00014997          	auipc	s3,0x14
ffffffffc0201b80:	9ec98993          	addi	s3,s3,-1556 # ffffffffc0215568 <npage>
ffffffffc0201b84:	efb5                	bnez	a5,ffffffffc0201c00 <get_pte+0xb0>
ffffffffc0201b86:	14060c63          	beqz	a2,ffffffffc0201cde <get_pte+0x18e>
ffffffffc0201b8a:	4505                	li	a0,1
ffffffffc0201b8c:	eb9ff0ef          	jal	ra,ffffffffc0201a44 <alloc_pages>
ffffffffc0201b90:	842a                	mv	s0,a0
ffffffffc0201b92:	14050663          	beqz	a0,ffffffffc0201cde <get_pte+0x18e>
ffffffffc0201b96:	00014b97          	auipc	s7,0x14
ffffffffc0201b9a:	9dab8b93          	addi	s7,s7,-1574 # ffffffffc0215570 <pages>
ffffffffc0201b9e:	000bb503          	ld	a0,0(s7)
ffffffffc0201ba2:	00005b17          	auipc	s6,0x5
ffffffffc0201ba6:	2beb3b03          	ld	s6,702(s6) # ffffffffc0206e60 <error_string+0x38>
ffffffffc0201baa:	00080ab7          	lui	s5,0x80
ffffffffc0201bae:	40a40533          	sub	a0,s0,a0
ffffffffc0201bb2:	850d                	srai	a0,a0,0x3
ffffffffc0201bb4:	03650533          	mul	a0,a0,s6
ffffffffc0201bb8:	00014997          	auipc	s3,0x14
ffffffffc0201bbc:	9b098993          	addi	s3,s3,-1616 # ffffffffc0215568 <npage>
ffffffffc0201bc0:	4785                	li	a5,1
ffffffffc0201bc2:	0009b703          	ld	a4,0(s3)
ffffffffc0201bc6:	c01c                	sw	a5,0(s0)
ffffffffc0201bc8:	9556                	add	a0,a0,s5
ffffffffc0201bca:	00c51793          	slli	a5,a0,0xc
ffffffffc0201bce:	83b1                	srli	a5,a5,0xc
ffffffffc0201bd0:	0532                	slli	a0,a0,0xc
ffffffffc0201bd2:	14e7fd63          	bgeu	a5,a4,ffffffffc0201d2c <get_pte+0x1dc>
ffffffffc0201bd6:	00014797          	auipc	a5,0x14
ffffffffc0201bda:	9aa7b783          	ld	a5,-1622(a5) # ffffffffc0215580 <va_pa_offset>
ffffffffc0201bde:	6605                	lui	a2,0x1
ffffffffc0201be0:	4581                	li	a1,0
ffffffffc0201be2:	953e                	add	a0,a0,a5
ffffffffc0201be4:	1f0030ef          	jal	ra,ffffffffc0204dd4 <memset>
ffffffffc0201be8:	000bb683          	ld	a3,0(s7)
ffffffffc0201bec:	40d406b3          	sub	a3,s0,a3
ffffffffc0201bf0:	868d                	srai	a3,a3,0x3
ffffffffc0201bf2:	036686b3          	mul	a3,a3,s6
ffffffffc0201bf6:	96d6                	add	a3,a3,s5
ffffffffc0201bf8:	06aa                	slli	a3,a3,0xa
ffffffffc0201bfa:	0116e693          	ori	a3,a3,17
ffffffffc0201bfe:	e094                	sd	a3,0(s1)
ffffffffc0201c00:	77fd                	lui	a5,0xfffff
ffffffffc0201c02:	068a                	slli	a3,a3,0x2
ffffffffc0201c04:	0009b703          	ld	a4,0(s3)
ffffffffc0201c08:	8efd                	and	a3,a3,a5
ffffffffc0201c0a:	00c6d793          	srli	a5,a3,0xc
ffffffffc0201c0e:	0ce7fa63          	bgeu	a5,a4,ffffffffc0201ce2 <get_pte+0x192>
ffffffffc0201c12:	00014a97          	auipc	s5,0x14
ffffffffc0201c16:	96ea8a93          	addi	s5,s5,-1682 # ffffffffc0215580 <va_pa_offset>
ffffffffc0201c1a:	000ab403          	ld	s0,0(s5)
ffffffffc0201c1e:	01595793          	srli	a5,s2,0x15
ffffffffc0201c22:	1ff7f793          	andi	a5,a5,511
ffffffffc0201c26:	96a2                	add	a3,a3,s0
ffffffffc0201c28:	00379413          	slli	s0,a5,0x3
ffffffffc0201c2c:	9436                	add	s0,s0,a3
ffffffffc0201c2e:	6014                	ld	a3,0(s0)
ffffffffc0201c30:	0016f793          	andi	a5,a3,1
ffffffffc0201c34:	ebad                	bnez	a5,ffffffffc0201ca6 <get_pte+0x156>
ffffffffc0201c36:	0a0a0463          	beqz	s4,ffffffffc0201cde <get_pte+0x18e>
ffffffffc0201c3a:	4505                	li	a0,1
ffffffffc0201c3c:	e09ff0ef          	jal	ra,ffffffffc0201a44 <alloc_pages>
ffffffffc0201c40:	84aa                	mv	s1,a0
ffffffffc0201c42:	cd51                	beqz	a0,ffffffffc0201cde <get_pte+0x18e>
ffffffffc0201c44:	00014b97          	auipc	s7,0x14
ffffffffc0201c48:	92cb8b93          	addi	s7,s7,-1748 # ffffffffc0215570 <pages>
ffffffffc0201c4c:	000bb503          	ld	a0,0(s7)
ffffffffc0201c50:	00005b17          	auipc	s6,0x5
ffffffffc0201c54:	210b3b03          	ld	s6,528(s6) # ffffffffc0206e60 <error_string+0x38>
ffffffffc0201c58:	00080a37          	lui	s4,0x80
ffffffffc0201c5c:	40a48533          	sub	a0,s1,a0
ffffffffc0201c60:	850d                	srai	a0,a0,0x3
ffffffffc0201c62:	03650533          	mul	a0,a0,s6
ffffffffc0201c66:	4785                	li	a5,1
ffffffffc0201c68:	0009b703          	ld	a4,0(s3)
ffffffffc0201c6c:	c09c                	sw	a5,0(s1)
ffffffffc0201c6e:	9552                	add	a0,a0,s4
ffffffffc0201c70:	00c51793          	slli	a5,a0,0xc
ffffffffc0201c74:	83b1                	srli	a5,a5,0xc
ffffffffc0201c76:	0532                	slli	a0,a0,0xc
ffffffffc0201c78:	08e7fd63          	bgeu	a5,a4,ffffffffc0201d12 <get_pte+0x1c2>
ffffffffc0201c7c:	000ab783          	ld	a5,0(s5)
ffffffffc0201c80:	6605                	lui	a2,0x1
ffffffffc0201c82:	4581                	li	a1,0
ffffffffc0201c84:	953e                	add	a0,a0,a5
ffffffffc0201c86:	14e030ef          	jal	ra,ffffffffc0204dd4 <memset>
ffffffffc0201c8a:	000bb683          	ld	a3,0(s7)
ffffffffc0201c8e:	40d486b3          	sub	a3,s1,a3
ffffffffc0201c92:	868d                	srai	a3,a3,0x3
ffffffffc0201c94:	036686b3          	mul	a3,a3,s6
ffffffffc0201c98:	96d2                	add	a3,a3,s4
ffffffffc0201c9a:	06aa                	slli	a3,a3,0xa
ffffffffc0201c9c:	0116e693          	ori	a3,a3,17
ffffffffc0201ca0:	e014                	sd	a3,0(s0)
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
ffffffffc0201cde:	4501                	li	a0,0
ffffffffc0201ce0:	b7e5                	j	ffffffffc0201cc8 <get_pte+0x178>
ffffffffc0201ce2:	00004617          	auipc	a2,0x4
ffffffffc0201ce6:	ece60613          	addi	a2,a2,-306 # ffffffffc0205bb0 <default_pmm_manager+0x38>
ffffffffc0201cea:	0e400593          	li	a1,228
ffffffffc0201cee:	00004517          	auipc	a0,0x4
ffffffffc0201cf2:	fda50513          	addi	a0,a0,-38 # ffffffffc0205cc8 <default_pmm_manager+0x150>
ffffffffc0201cf6:	f50fe0ef          	jal	ra,ffffffffc0200446 <__panic>
ffffffffc0201cfa:	00004617          	auipc	a2,0x4
ffffffffc0201cfe:	eb660613          	addi	a2,a2,-330 # ffffffffc0205bb0 <default_pmm_manager+0x38>
ffffffffc0201d02:	0ef00593          	li	a1,239
ffffffffc0201d06:	00004517          	auipc	a0,0x4
ffffffffc0201d0a:	fc250513          	addi	a0,a0,-62 # ffffffffc0205cc8 <default_pmm_manager+0x150>
ffffffffc0201d0e:	f38fe0ef          	jal	ra,ffffffffc0200446 <__panic>
ffffffffc0201d12:	86aa                	mv	a3,a0
ffffffffc0201d14:	00004617          	auipc	a2,0x4
ffffffffc0201d18:	e9c60613          	addi	a2,a2,-356 # ffffffffc0205bb0 <default_pmm_manager+0x38>
ffffffffc0201d1c:	0ec00593          	li	a1,236
ffffffffc0201d20:	00004517          	auipc	a0,0x4
ffffffffc0201d24:	fa850513          	addi	a0,a0,-88 # ffffffffc0205cc8 <default_pmm_manager+0x150>
ffffffffc0201d28:	f1efe0ef          	jal	ra,ffffffffc0200446 <__panic>
ffffffffc0201d2c:	86aa                	mv	a3,a0
ffffffffc0201d2e:	00004617          	auipc	a2,0x4
ffffffffc0201d32:	e8260613          	addi	a2,a2,-382 # ffffffffc0205bb0 <default_pmm_manager+0x38>
ffffffffc0201d36:	0e100593          	li	a1,225
ffffffffc0201d3a:	00004517          	auipc	a0,0x4
ffffffffc0201d3e:	f8e50513          	addi	a0,a0,-114 # ffffffffc0205cc8 <default_pmm_manager+0x150>
ffffffffc0201d42:	f04fe0ef          	jal	ra,ffffffffc0200446 <__panic>

ffffffffc0201d46 <get_page>:
ffffffffc0201d46:	1141                	addi	sp,sp,-16
ffffffffc0201d48:	e022                	sd	s0,0(sp)
ffffffffc0201d4a:	8432                	mv	s0,a2
ffffffffc0201d4c:	4601                	li	a2,0
ffffffffc0201d4e:	e406                	sd	ra,8(sp)
ffffffffc0201d50:	e01ff0ef          	jal	ra,ffffffffc0201b50 <get_pte>
ffffffffc0201d54:	c011                	beqz	s0,ffffffffc0201d58 <get_page+0x12>
ffffffffc0201d56:	e008                	sd	a0,0(s0)
ffffffffc0201d58:	c511                	beqz	a0,ffffffffc0201d64 <get_page+0x1e>
ffffffffc0201d5a:	611c                	ld	a5,0(a0)
ffffffffc0201d5c:	4501                	li	a0,0
ffffffffc0201d5e:	0017f713          	andi	a4,a5,1
ffffffffc0201d62:	e709                	bnez	a4,ffffffffc0201d6c <get_page+0x26>
ffffffffc0201d64:	60a2                	ld	ra,8(sp)
ffffffffc0201d66:	6402                	ld	s0,0(sp)
ffffffffc0201d68:	0141                	addi	sp,sp,16
ffffffffc0201d6a:	8082                	ret
ffffffffc0201d6c:	078a                	slli	a5,a5,0x2
ffffffffc0201d6e:	83b1                	srli	a5,a5,0xc
ffffffffc0201d70:	00013717          	auipc	a4,0x13
ffffffffc0201d74:	7f873703          	ld	a4,2040(a4) # ffffffffc0215568 <npage>
ffffffffc0201d78:	02e7f263          	bgeu	a5,a4,ffffffffc0201d9c <get_page+0x56>
ffffffffc0201d7c:	fff80537          	lui	a0,0xfff80
ffffffffc0201d80:	97aa                	add	a5,a5,a0
ffffffffc0201d82:	60a2                	ld	ra,8(sp)
ffffffffc0201d84:	6402                	ld	s0,0(sp)
ffffffffc0201d86:	00379513          	slli	a0,a5,0x3
ffffffffc0201d8a:	97aa                	add	a5,a5,a0
ffffffffc0201d8c:	078e                	slli	a5,a5,0x3
ffffffffc0201d8e:	00013517          	auipc	a0,0x13
ffffffffc0201d92:	7e253503          	ld	a0,2018(a0) # ffffffffc0215570 <pages>
ffffffffc0201d96:	953e                	add	a0,a0,a5
ffffffffc0201d98:	0141                	addi	sp,sp,16
ffffffffc0201d9a:	8082                	ret
ffffffffc0201d9c:	c71ff0ef          	jal	ra,ffffffffc0201a0c <pa2page.part.0>

ffffffffc0201da0 <page_remove>:
ffffffffc0201da0:	7179                	addi	sp,sp,-48
ffffffffc0201da2:	4601                	li	a2,0
ffffffffc0201da4:	ec26                	sd	s1,24(sp)
ffffffffc0201da6:	f406                	sd	ra,40(sp)
ffffffffc0201da8:	f022                	sd	s0,32(sp)
ffffffffc0201daa:	84ae                	mv	s1,a1
ffffffffc0201dac:	da5ff0ef          	jal	ra,ffffffffc0201b50 <get_pte>
ffffffffc0201db0:	c511                	beqz	a0,ffffffffc0201dbc <page_remove+0x1c>
ffffffffc0201db2:	611c                	ld	a5,0(a0)
ffffffffc0201db4:	842a                	mv	s0,a0
ffffffffc0201db6:	0017f713          	andi	a4,a5,1
ffffffffc0201dba:	e711                	bnez	a4,ffffffffc0201dc6 <page_remove+0x26>
ffffffffc0201dbc:	70a2                	ld	ra,40(sp)
ffffffffc0201dbe:	7402                	ld	s0,32(sp)
ffffffffc0201dc0:	64e2                	ld	s1,24(sp)
ffffffffc0201dc2:	6145                	addi	sp,sp,48
ffffffffc0201dc4:	8082                	ret
ffffffffc0201dc6:	078a                	slli	a5,a5,0x2
ffffffffc0201dc8:	83b1                	srli	a5,a5,0xc
ffffffffc0201dca:	00013717          	auipc	a4,0x13
ffffffffc0201dce:	79e73703          	ld	a4,1950(a4) # ffffffffc0215568 <npage>
ffffffffc0201dd2:	06e7f663          	bgeu	a5,a4,ffffffffc0201e3e <page_remove+0x9e>
ffffffffc0201dd6:	fff80737          	lui	a4,0xfff80
ffffffffc0201dda:	97ba                	add	a5,a5,a4
ffffffffc0201ddc:	00379513          	slli	a0,a5,0x3
ffffffffc0201de0:	97aa                	add	a5,a5,a0
ffffffffc0201de2:	078e                	slli	a5,a5,0x3
ffffffffc0201de4:	00013517          	auipc	a0,0x13
ffffffffc0201de8:	78c53503          	ld	a0,1932(a0) # ffffffffc0215570 <pages>
ffffffffc0201dec:	953e                	add	a0,a0,a5
ffffffffc0201dee:	411c                	lw	a5,0(a0)
ffffffffc0201df0:	fff7871b          	addiw	a4,a5,-1
ffffffffc0201df4:	c118                	sw	a4,0(a0)
ffffffffc0201df6:	cb11                	beqz	a4,ffffffffc0201e0a <page_remove+0x6a>
ffffffffc0201df8:	00043023          	sd	zero,0(s0)
ffffffffc0201dfc:	12048073          	sfence.vma	s1
ffffffffc0201e00:	70a2                	ld	ra,40(sp)
ffffffffc0201e02:	7402                	ld	s0,32(sp)
ffffffffc0201e04:	64e2                	ld	s1,24(sp)
ffffffffc0201e06:	6145                	addi	sp,sp,48
ffffffffc0201e08:	8082                	ret
ffffffffc0201e0a:	100027f3          	csrr	a5,sstatus
ffffffffc0201e0e:	8b89                	andi	a5,a5,2
ffffffffc0201e10:	eb89                	bnez	a5,ffffffffc0201e22 <page_remove+0x82>
ffffffffc0201e12:	00013797          	auipc	a5,0x13
ffffffffc0201e16:	7667b783          	ld	a5,1894(a5) # ffffffffc0215578 <pmm_manager>
ffffffffc0201e1a:	739c                	ld	a5,32(a5)
ffffffffc0201e1c:	4585                	li	a1,1
ffffffffc0201e1e:	9782                	jalr	a5
ffffffffc0201e20:	bfe1                	j	ffffffffc0201df8 <page_remove+0x58>
ffffffffc0201e22:	e42a                	sd	a0,8(sp)
ffffffffc0201e24:	f7afe0ef          	jal	ra,ffffffffc020059e <intr_disable>
ffffffffc0201e28:	00013797          	auipc	a5,0x13
ffffffffc0201e2c:	7507b783          	ld	a5,1872(a5) # ffffffffc0215578 <pmm_manager>
ffffffffc0201e30:	739c                	ld	a5,32(a5)
ffffffffc0201e32:	6522                	ld	a0,8(sp)
ffffffffc0201e34:	4585                	li	a1,1
ffffffffc0201e36:	9782                	jalr	a5
ffffffffc0201e38:	f60fe0ef          	jal	ra,ffffffffc0200598 <intr_enable>
ffffffffc0201e3c:	bf75                	j	ffffffffc0201df8 <page_remove+0x58>
ffffffffc0201e3e:	bcfff0ef          	jal	ra,ffffffffc0201a0c <pa2page.part.0>

ffffffffc0201e42 <page_insert>:
ffffffffc0201e42:	7139                	addi	sp,sp,-64
ffffffffc0201e44:	ec4e                	sd	s3,24(sp)
ffffffffc0201e46:	89b2                	mv	s3,a2
ffffffffc0201e48:	f822                	sd	s0,48(sp)
ffffffffc0201e4a:	4605                	li	a2,1
ffffffffc0201e4c:	842e                	mv	s0,a1
ffffffffc0201e4e:	85ce                	mv	a1,s3
ffffffffc0201e50:	f426                	sd	s1,40(sp)
ffffffffc0201e52:	fc06                	sd	ra,56(sp)
ffffffffc0201e54:	f04a                	sd	s2,32(sp)
ffffffffc0201e56:	e852                	sd	s4,16(sp)
ffffffffc0201e58:	e456                	sd	s5,8(sp)
ffffffffc0201e5a:	84b6                	mv	s1,a3
ffffffffc0201e5c:	cf5ff0ef          	jal	ra,ffffffffc0201b50 <get_pte>
ffffffffc0201e60:	c17d                	beqz	a0,ffffffffc0201f46 <page_insert+0x104>
ffffffffc0201e62:	4014                	lw	a3,0(s0)
ffffffffc0201e64:	611c                	ld	a5,0(a0)
ffffffffc0201e66:	8a2a                	mv	s4,a0
ffffffffc0201e68:	0016871b          	addiw	a4,a3,1
ffffffffc0201e6c:	c018                	sw	a4,0(s0)
ffffffffc0201e6e:	0017f713          	andi	a4,a5,1
ffffffffc0201e72:	e339                	bnez	a4,ffffffffc0201eb8 <page_insert+0x76>
ffffffffc0201e74:	00013797          	auipc	a5,0x13
ffffffffc0201e78:	6fc7b783          	ld	a5,1788(a5) # ffffffffc0215570 <pages>
ffffffffc0201e7c:	40f407b3          	sub	a5,s0,a5
ffffffffc0201e80:	878d                	srai	a5,a5,0x3
ffffffffc0201e82:	00005417          	auipc	s0,0x5
ffffffffc0201e86:	fde43403          	ld	s0,-34(s0) # ffffffffc0206e60 <error_string+0x38>
ffffffffc0201e8a:	028787b3          	mul	a5,a5,s0
ffffffffc0201e8e:	00080437          	lui	s0,0x80
ffffffffc0201e92:	97a2                	add	a5,a5,s0
ffffffffc0201e94:	07aa                	slli	a5,a5,0xa
ffffffffc0201e96:	8cdd                	or	s1,s1,a5
ffffffffc0201e98:	0014e493          	ori	s1,s1,1
ffffffffc0201e9c:	009a3023          	sd	s1,0(s4) # 80000 <kern_entry-0xffffffffc0180000>
ffffffffc0201ea0:	12098073          	sfence.vma	s3
ffffffffc0201ea4:	4501                	li	a0,0
ffffffffc0201ea6:	70e2                	ld	ra,56(sp)
ffffffffc0201ea8:	7442                	ld	s0,48(sp)
ffffffffc0201eaa:	74a2                	ld	s1,40(sp)
ffffffffc0201eac:	7902                	ld	s2,32(sp)
ffffffffc0201eae:	69e2                	ld	s3,24(sp)
ffffffffc0201eb0:	6a42                	ld	s4,16(sp)
ffffffffc0201eb2:	6aa2                	ld	s5,8(sp)
ffffffffc0201eb4:	6121                	addi	sp,sp,64
ffffffffc0201eb6:	8082                	ret
ffffffffc0201eb8:	00279713          	slli	a4,a5,0x2
ffffffffc0201ebc:	8331                	srli	a4,a4,0xc
ffffffffc0201ebe:	00013797          	auipc	a5,0x13
ffffffffc0201ec2:	6aa7b783          	ld	a5,1706(a5) # ffffffffc0215568 <npage>
ffffffffc0201ec6:	08f77263          	bgeu	a4,a5,ffffffffc0201f4a <page_insert+0x108>
ffffffffc0201eca:	fff807b7          	lui	a5,0xfff80
ffffffffc0201ece:	973e                	add	a4,a4,a5
ffffffffc0201ed0:	00013a97          	auipc	s5,0x13
ffffffffc0201ed4:	6a0a8a93          	addi	s5,s5,1696 # ffffffffc0215570 <pages>
ffffffffc0201ed8:	000ab783          	ld	a5,0(s5)
ffffffffc0201edc:	00371913          	slli	s2,a4,0x3
ffffffffc0201ee0:	993a                	add	s2,s2,a4
ffffffffc0201ee2:	090e                	slli	s2,s2,0x3
ffffffffc0201ee4:	993e                	add	s2,s2,a5
ffffffffc0201ee6:	01240c63          	beq	s0,s2,ffffffffc0201efe <page_insert+0xbc>
ffffffffc0201eea:	00092703          	lw	a4,0(s2)
ffffffffc0201eee:	fff7069b          	addiw	a3,a4,-1
ffffffffc0201ef2:	00d92023          	sw	a3,0(s2)
ffffffffc0201ef6:	c691                	beqz	a3,ffffffffc0201f02 <page_insert+0xc0>
ffffffffc0201ef8:	12098073          	sfence.vma	s3
ffffffffc0201efc:	b741                	j	ffffffffc0201e7c <page_insert+0x3a>
ffffffffc0201efe:	c014                	sw	a3,0(s0)
ffffffffc0201f00:	bfb5                	j	ffffffffc0201e7c <page_insert+0x3a>
ffffffffc0201f02:	100027f3          	csrr	a5,sstatus
ffffffffc0201f06:	8b89                	andi	a5,a5,2
ffffffffc0201f08:	ef91                	bnez	a5,ffffffffc0201f24 <page_insert+0xe2>
ffffffffc0201f0a:	00013797          	auipc	a5,0x13
ffffffffc0201f0e:	66e7b783          	ld	a5,1646(a5) # ffffffffc0215578 <pmm_manager>
ffffffffc0201f12:	739c                	ld	a5,32(a5)
ffffffffc0201f14:	4585                	li	a1,1
ffffffffc0201f16:	854a                	mv	a0,s2
ffffffffc0201f18:	9782                	jalr	a5
ffffffffc0201f1a:	000ab783          	ld	a5,0(s5)
ffffffffc0201f1e:	12098073          	sfence.vma	s3
ffffffffc0201f22:	bfa9                	j	ffffffffc0201e7c <page_insert+0x3a>
ffffffffc0201f24:	e7afe0ef          	jal	ra,ffffffffc020059e <intr_disable>
ffffffffc0201f28:	00013797          	auipc	a5,0x13
ffffffffc0201f2c:	6507b783          	ld	a5,1616(a5) # ffffffffc0215578 <pmm_manager>
ffffffffc0201f30:	739c                	ld	a5,32(a5)
ffffffffc0201f32:	4585                	li	a1,1
ffffffffc0201f34:	854a                	mv	a0,s2
ffffffffc0201f36:	9782                	jalr	a5
ffffffffc0201f38:	e60fe0ef          	jal	ra,ffffffffc0200598 <intr_enable>
ffffffffc0201f3c:	000ab783          	ld	a5,0(s5)
ffffffffc0201f40:	12098073          	sfence.vma	s3
ffffffffc0201f44:	bf25                	j	ffffffffc0201e7c <page_insert+0x3a>
ffffffffc0201f46:	5571                	li	a0,-4
ffffffffc0201f48:	bfb9                	j	ffffffffc0201ea6 <page_insert+0x64>
ffffffffc0201f4a:	ac3ff0ef          	jal	ra,ffffffffc0201a0c <pa2page.part.0>

ffffffffc0201f4e <pmm_init>:
ffffffffc0201f4e:	00004797          	auipc	a5,0x4
ffffffffc0201f52:	c2a78793          	addi	a5,a5,-982 # ffffffffc0205b78 <default_pmm_manager>
ffffffffc0201f56:	638c                	ld	a1,0(a5)
ffffffffc0201f58:	7159                	addi	sp,sp,-112
ffffffffc0201f5a:	f45e                	sd	s7,40(sp)
ffffffffc0201f5c:	00004517          	auipc	a0,0x4
ffffffffc0201f60:	d7c50513          	addi	a0,a0,-644 # ffffffffc0205cd8 <default_pmm_manager+0x160>
ffffffffc0201f64:	00013b97          	auipc	s7,0x13
ffffffffc0201f68:	614b8b93          	addi	s7,s7,1556 # ffffffffc0215578 <pmm_manager>
ffffffffc0201f6c:	f486                	sd	ra,104(sp)
ffffffffc0201f6e:	eca6                	sd	s1,88(sp)
ffffffffc0201f70:	e4ce                	sd	s3,72(sp)
ffffffffc0201f72:	f85a                	sd	s6,48(sp)
ffffffffc0201f74:	00fbb023          	sd	a5,0(s7)
ffffffffc0201f78:	f0a2                	sd	s0,96(sp)
ffffffffc0201f7a:	e8ca                	sd	s2,80(sp)
ffffffffc0201f7c:	e0d2                	sd	s4,64(sp)
ffffffffc0201f7e:	fc56                	sd	s5,56(sp)
ffffffffc0201f80:	f062                	sd	s8,32(sp)
ffffffffc0201f82:	ec66                	sd	s9,24(sp)
ffffffffc0201f84:	e86a                	sd	s10,16(sp)
ffffffffc0201f86:	9fafe0ef          	jal	ra,ffffffffc0200180 <cprintf>
ffffffffc0201f8a:	000bb783          	ld	a5,0(s7)
ffffffffc0201f8e:	00013997          	auipc	s3,0x13
ffffffffc0201f92:	5f298993          	addi	s3,s3,1522 # ffffffffc0215580 <va_pa_offset>
ffffffffc0201f96:	00013497          	auipc	s1,0x13
ffffffffc0201f9a:	5d248493          	addi	s1,s1,1490 # ffffffffc0215568 <npage>
ffffffffc0201f9e:	679c                	ld	a5,8(a5)
ffffffffc0201fa0:	00013b17          	auipc	s6,0x13
ffffffffc0201fa4:	5d0b0b13          	addi	s6,s6,1488 # ffffffffc0215570 <pages>
ffffffffc0201fa8:	9782                	jalr	a5
ffffffffc0201faa:	57f5                	li	a5,-3
ffffffffc0201fac:	07fa                	slli	a5,a5,0x1e
ffffffffc0201fae:	00004517          	auipc	a0,0x4
ffffffffc0201fb2:	d4250513          	addi	a0,a0,-702 # ffffffffc0205cf0 <default_pmm_manager+0x178>
ffffffffc0201fb6:	00f9b023          	sd	a5,0(s3)
ffffffffc0201fba:	9c6fe0ef          	jal	ra,ffffffffc0200180 <cprintf>
ffffffffc0201fbe:	46c5                	li	a3,17
ffffffffc0201fc0:	06ee                	slli	a3,a3,0x1b
ffffffffc0201fc2:	40100613          	li	a2,1025
ffffffffc0201fc6:	16fd                	addi	a3,a3,-1
ffffffffc0201fc8:	07e005b7          	lui	a1,0x7e00
ffffffffc0201fcc:	0656                	slli	a2,a2,0x15
ffffffffc0201fce:	00004517          	auipc	a0,0x4
ffffffffc0201fd2:	d3a50513          	addi	a0,a0,-710 # ffffffffc0205d08 <default_pmm_manager+0x190>
ffffffffc0201fd6:	9aafe0ef          	jal	ra,ffffffffc0200180 <cprintf>
ffffffffc0201fda:	777d                	lui	a4,0xfffff
ffffffffc0201fdc:	00014797          	auipc	a5,0x14
ffffffffc0201fe0:	5ef78793          	addi	a5,a5,1519 # ffffffffc02165cb <end+0xfff>
ffffffffc0201fe4:	8ff9                	and	a5,a5,a4
ffffffffc0201fe6:	00088737          	lui	a4,0x88
ffffffffc0201fea:	e098                	sd	a4,0(s1)
ffffffffc0201fec:	00fb3023          	sd	a5,0(s6)
ffffffffc0201ff0:	4681                	li	a3,0
ffffffffc0201ff2:	4701                	li	a4,0
ffffffffc0201ff4:	4585                	li	a1,1
ffffffffc0201ff6:	fff80837          	lui	a6,0xfff80
ffffffffc0201ffa:	a019                	j	ffffffffc0202000 <pmm_init+0xb2>
ffffffffc0201ffc:	000b3783          	ld	a5,0(s6)
ffffffffc0202000:	97b6                	add	a5,a5,a3
ffffffffc0202002:	07a1                	addi	a5,a5,8
ffffffffc0202004:	40b7b02f          	amoor.d	zero,a1,(a5)
ffffffffc0202008:	609c                	ld	a5,0(s1)
ffffffffc020200a:	0705                	addi	a4,a4,1
ffffffffc020200c:	04868693          	addi	a3,a3,72
ffffffffc0202010:	01078633          	add	a2,a5,a6
ffffffffc0202014:	fec764e3          	bltu	a4,a2,ffffffffc0201ffc <pmm_init+0xae>
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
ffffffffc0202038:	4645                	li	a2,17
ffffffffc020203a:	066e                	slli	a2,a2,0x1b
ffffffffc020203c:	8e8d                	sub	a3,a3,a1
ffffffffc020203e:	4ec6ee63          	bltu	a3,a2,ffffffffc020253a <pmm_init+0x5ec>
ffffffffc0202042:	00004517          	auipc	a0,0x4
ffffffffc0202046:	cee50513          	addi	a0,a0,-786 # ffffffffc0205d30 <default_pmm_manager+0x1b8>
ffffffffc020204a:	936fe0ef          	jal	ra,ffffffffc0200180 <cprintf>
ffffffffc020204e:	000bb783          	ld	a5,0(s7)
ffffffffc0202052:	00013917          	auipc	s2,0x13
ffffffffc0202056:	50e90913          	addi	s2,s2,1294 # ffffffffc0215560 <boot_pgdir>
ffffffffc020205a:	7b9c                	ld	a5,48(a5)
ffffffffc020205c:	9782                	jalr	a5
ffffffffc020205e:	00004517          	auipc	a0,0x4
ffffffffc0202062:	cea50513          	addi	a0,a0,-790 # ffffffffc0205d48 <default_pmm_manager+0x1d0>
ffffffffc0202066:	91afe0ef          	jal	ra,ffffffffc0200180 <cprintf>
ffffffffc020206a:	00007697          	auipc	a3,0x7
ffffffffc020206e:	f9668693          	addi	a3,a3,-106 # ffffffffc0209000 <boot_page_table_sv39>
ffffffffc0202072:	00d93023          	sd	a3,0(s2)
ffffffffc0202076:	c02007b7          	lui	a5,0xc0200
ffffffffc020207a:	62f6e863          	bltu	a3,a5,ffffffffc02026aa <pmm_init+0x75c>
ffffffffc020207e:	0009b783          	ld	a5,0(s3)
ffffffffc0202082:	8e9d                	sub	a3,a3,a5
ffffffffc0202084:	00013797          	auipc	a5,0x13
ffffffffc0202088:	4cd7ba23          	sd	a3,1236(a5) # ffffffffc0215558 <boot_cr3>
ffffffffc020208c:	100027f3          	csrr	a5,sstatus
ffffffffc0202090:	8b89                	andi	a5,a5,2
ffffffffc0202092:	4c079e63          	bnez	a5,ffffffffc020256e <pmm_init+0x620>
ffffffffc0202096:	000bb783          	ld	a5,0(s7)
ffffffffc020209a:	779c                	ld	a5,40(a5)
ffffffffc020209c:	9782                	jalr	a5
ffffffffc020209e:	842a                	mv	s0,a0
ffffffffc02020a0:	6098                	ld	a4,0(s1)
ffffffffc02020a2:	c80007b7          	lui	a5,0xc8000
ffffffffc02020a6:	83b1                	srli	a5,a5,0xc
ffffffffc02020a8:	62e7ed63          	bltu	a5,a4,ffffffffc02026e2 <pmm_init+0x794>
ffffffffc02020ac:	00093503          	ld	a0,0(s2)
ffffffffc02020b0:	60050963          	beqz	a0,ffffffffc02026c2 <pmm_init+0x774>
ffffffffc02020b4:	03451793          	slli	a5,a0,0x34
ffffffffc02020b8:	60079563          	bnez	a5,ffffffffc02026c2 <pmm_init+0x774>
ffffffffc02020bc:	4601                	li	a2,0
ffffffffc02020be:	4581                	li	a1,0
ffffffffc02020c0:	c87ff0ef          	jal	ra,ffffffffc0201d46 <get_page>
ffffffffc02020c4:	68051163          	bnez	a0,ffffffffc0202746 <pmm_init+0x7f8>
ffffffffc02020c8:	4505                	li	a0,1
ffffffffc02020ca:	97bff0ef          	jal	ra,ffffffffc0201a44 <alloc_pages>
ffffffffc02020ce:	8a2a                	mv	s4,a0
ffffffffc02020d0:	00093503          	ld	a0,0(s2)
ffffffffc02020d4:	4681                	li	a3,0
ffffffffc02020d6:	4601                	li	a2,0
ffffffffc02020d8:	85d2                	mv	a1,s4
ffffffffc02020da:	d69ff0ef          	jal	ra,ffffffffc0201e42 <page_insert>
ffffffffc02020de:	64051463          	bnez	a0,ffffffffc0202726 <pmm_init+0x7d8>
ffffffffc02020e2:	00093503          	ld	a0,0(s2)
ffffffffc02020e6:	4601                	li	a2,0
ffffffffc02020e8:	4581                	li	a1,0
ffffffffc02020ea:	a67ff0ef          	jal	ra,ffffffffc0201b50 <get_pte>
ffffffffc02020ee:	60050c63          	beqz	a0,ffffffffc0202706 <pmm_init+0x7b8>
ffffffffc02020f2:	611c                	ld	a5,0(a0)
ffffffffc02020f4:	0017f713          	andi	a4,a5,1
ffffffffc02020f8:	60070563          	beqz	a4,ffffffffc0202702 <pmm_init+0x7b4>
ffffffffc02020fc:	6090                	ld	a2,0(s1)
ffffffffc02020fe:	078a                	slli	a5,a5,0x2
ffffffffc0202100:	83b1                	srli	a5,a5,0xc
ffffffffc0202102:	58c7f663          	bgeu	a5,a2,ffffffffc020268e <pmm_init+0x740>
ffffffffc0202106:	fff80737          	lui	a4,0xfff80
ffffffffc020210a:	97ba                	add	a5,a5,a4
ffffffffc020210c:	000b3683          	ld	a3,0(s6)
ffffffffc0202110:	00379713          	slli	a4,a5,0x3
ffffffffc0202114:	97ba                	add	a5,a5,a4
ffffffffc0202116:	078e                	slli	a5,a5,0x3
ffffffffc0202118:	97b6                	add	a5,a5,a3
ffffffffc020211a:	14fa1fe3          	bne	s4,a5,ffffffffc0202a78 <pmm_init+0xb2a>
ffffffffc020211e:	000a2703          	lw	a4,0(s4)
ffffffffc0202122:	4785                	li	a5,1
ffffffffc0202124:	18f716e3          	bne	a4,a5,ffffffffc0202ab0 <pmm_init+0xb62>
ffffffffc0202128:	00093503          	ld	a0,0(s2)
ffffffffc020212c:	77fd                	lui	a5,0xfffff
ffffffffc020212e:	6114                	ld	a3,0(a0)
ffffffffc0202130:	068a                	slli	a3,a3,0x2
ffffffffc0202132:	8efd                	and	a3,a3,a5
ffffffffc0202134:	00c6d713          	srli	a4,a3,0xc
ffffffffc0202138:	16c770e3          	bgeu	a4,a2,ffffffffc0202a98 <pmm_init+0xb4a>
ffffffffc020213c:	0009bc03          	ld	s8,0(s3)
ffffffffc0202140:	96e2                	add	a3,a3,s8
ffffffffc0202142:	0006ba83          	ld	s5,0(a3)
ffffffffc0202146:	0a8a                	slli	s5,s5,0x2
ffffffffc0202148:	00fafab3          	and	s5,s5,a5
ffffffffc020214c:	00cad793          	srli	a5,s5,0xc
ffffffffc0202150:	66c7fb63          	bgeu	a5,a2,ffffffffc02027c6 <pmm_init+0x878>
ffffffffc0202154:	4601                	li	a2,0
ffffffffc0202156:	6585                	lui	a1,0x1
ffffffffc0202158:	9ae2                	add	s5,s5,s8
ffffffffc020215a:	9f7ff0ef          	jal	ra,ffffffffc0201b50 <get_pte>
ffffffffc020215e:	0aa1                	addi	s5,s5,8
ffffffffc0202160:	65551363          	bne	a0,s5,ffffffffc02027a6 <pmm_init+0x858>
ffffffffc0202164:	4505                	li	a0,1
ffffffffc0202166:	8dfff0ef          	jal	ra,ffffffffc0201a44 <alloc_pages>
ffffffffc020216a:	8aaa                	mv	s5,a0
ffffffffc020216c:	00093503          	ld	a0,0(s2)
ffffffffc0202170:	46d1                	li	a3,20
ffffffffc0202172:	6605                	lui	a2,0x1
ffffffffc0202174:	85d6                	mv	a1,s5
ffffffffc0202176:	ccdff0ef          	jal	ra,ffffffffc0201e42 <page_insert>
ffffffffc020217a:	5e051663          	bnez	a0,ffffffffc0202766 <pmm_init+0x818>
ffffffffc020217e:	00093503          	ld	a0,0(s2)
ffffffffc0202182:	4601                	li	a2,0
ffffffffc0202184:	6585                	lui	a1,0x1
ffffffffc0202186:	9cbff0ef          	jal	ra,ffffffffc0201b50 <get_pte>
ffffffffc020218a:	140503e3          	beqz	a0,ffffffffc0202ad0 <pmm_init+0xb82>
ffffffffc020218e:	611c                	ld	a5,0(a0)
ffffffffc0202190:	0107f713          	andi	a4,a5,16
ffffffffc0202194:	74070663          	beqz	a4,ffffffffc02028e0 <pmm_init+0x992>
ffffffffc0202198:	8b91                	andi	a5,a5,4
ffffffffc020219a:	70078363          	beqz	a5,ffffffffc02028a0 <pmm_init+0x952>
ffffffffc020219e:	00093503          	ld	a0,0(s2)
ffffffffc02021a2:	611c                	ld	a5,0(a0)
ffffffffc02021a4:	8bc1                	andi	a5,a5,16
ffffffffc02021a6:	6c078d63          	beqz	a5,ffffffffc0202880 <pmm_init+0x932>
ffffffffc02021aa:	000aa703          	lw	a4,0(s5)
ffffffffc02021ae:	4785                	li	a5,1
ffffffffc02021b0:	5cf71b63          	bne	a4,a5,ffffffffc0202786 <pmm_init+0x838>
ffffffffc02021b4:	4681                	li	a3,0
ffffffffc02021b6:	6605                	lui	a2,0x1
ffffffffc02021b8:	85d2                	mv	a1,s4
ffffffffc02021ba:	c89ff0ef          	jal	ra,ffffffffc0201e42 <page_insert>
ffffffffc02021be:	68051163          	bnez	a0,ffffffffc0202840 <pmm_init+0x8f2>
ffffffffc02021c2:	000a2703          	lw	a4,0(s4)
ffffffffc02021c6:	4789                	li	a5,2
ffffffffc02021c8:	64f71c63          	bne	a4,a5,ffffffffc0202820 <pmm_init+0x8d2>
ffffffffc02021cc:	000aa783          	lw	a5,0(s5)
ffffffffc02021d0:	62079863          	bnez	a5,ffffffffc0202800 <pmm_init+0x8b2>
ffffffffc02021d4:	00093503          	ld	a0,0(s2)
ffffffffc02021d8:	4601                	li	a2,0
ffffffffc02021da:	6585                	lui	a1,0x1
ffffffffc02021dc:	975ff0ef          	jal	ra,ffffffffc0201b50 <get_pte>
ffffffffc02021e0:	60050063          	beqz	a0,ffffffffc02027e0 <pmm_init+0x892>
ffffffffc02021e4:	6118                	ld	a4,0(a0)
ffffffffc02021e6:	00177793          	andi	a5,a4,1
ffffffffc02021ea:	50078c63          	beqz	a5,ffffffffc0202702 <pmm_init+0x7b4>
ffffffffc02021ee:	6094                	ld	a3,0(s1)
ffffffffc02021f0:	00271793          	slli	a5,a4,0x2
ffffffffc02021f4:	83b1                	srli	a5,a5,0xc
ffffffffc02021f6:	48d7fc63          	bgeu	a5,a3,ffffffffc020268e <pmm_init+0x740>
ffffffffc02021fa:	fff806b7          	lui	a3,0xfff80
ffffffffc02021fe:	97b6                	add	a5,a5,a3
ffffffffc0202200:	000b3603          	ld	a2,0(s6)
ffffffffc0202204:	00379693          	slli	a3,a5,0x3
ffffffffc0202208:	97b6                	add	a5,a5,a3
ffffffffc020220a:	078e                	slli	a5,a5,0x3
ffffffffc020220c:	97b2                	add	a5,a5,a2
ffffffffc020220e:	72fa1963          	bne	s4,a5,ffffffffc0202940 <pmm_init+0x9f2>
ffffffffc0202212:	8b41                	andi	a4,a4,16
ffffffffc0202214:	70071663          	bnez	a4,ffffffffc0202920 <pmm_init+0x9d2>
ffffffffc0202218:	00093503          	ld	a0,0(s2)
ffffffffc020221c:	4581                	li	a1,0
ffffffffc020221e:	b83ff0ef          	jal	ra,ffffffffc0201da0 <page_remove>
ffffffffc0202222:	000a2703          	lw	a4,0(s4)
ffffffffc0202226:	4785                	li	a5,1
ffffffffc0202228:	6cf71c63          	bne	a4,a5,ffffffffc0202900 <pmm_init+0x9b2>
ffffffffc020222c:	000aa783          	lw	a5,0(s5)
ffffffffc0202230:	7a079463          	bnez	a5,ffffffffc02029d8 <pmm_init+0xa8a>
ffffffffc0202234:	00093503          	ld	a0,0(s2)
ffffffffc0202238:	6585                	lui	a1,0x1
ffffffffc020223a:	b67ff0ef          	jal	ra,ffffffffc0201da0 <page_remove>
ffffffffc020223e:	000a2783          	lw	a5,0(s4)
ffffffffc0202242:	76079b63          	bnez	a5,ffffffffc02029b8 <pmm_init+0xa6a>
ffffffffc0202246:	000aa783          	lw	a5,0(s5)
ffffffffc020224a:	74079763          	bnez	a5,ffffffffc0202998 <pmm_init+0xa4a>
ffffffffc020224e:	00093a03          	ld	s4,0(s2)
ffffffffc0202252:	6090                	ld	a2,0(s1)
ffffffffc0202254:	000a3783          	ld	a5,0(s4)
ffffffffc0202258:	078a                	slli	a5,a5,0x2
ffffffffc020225a:	83b1                	srli	a5,a5,0xc
ffffffffc020225c:	42c7f963          	bgeu	a5,a2,ffffffffc020268e <pmm_init+0x740>
ffffffffc0202260:	fff80737          	lui	a4,0xfff80
ffffffffc0202264:	973e                	add	a4,a4,a5
ffffffffc0202266:	00371793          	slli	a5,a4,0x3
ffffffffc020226a:	000b3503          	ld	a0,0(s6)
ffffffffc020226e:	97ba                	add	a5,a5,a4
ffffffffc0202270:	078e                	slli	a5,a5,0x3
ffffffffc0202272:	00f50733          	add	a4,a0,a5
ffffffffc0202276:	4314                	lw	a3,0(a4)
ffffffffc0202278:	4705                	li	a4,1
ffffffffc020227a:	6ee69f63          	bne	a3,a4,ffffffffc0202978 <pmm_init+0xa2a>
ffffffffc020227e:	4037d693          	srai	a3,a5,0x3
ffffffffc0202282:	00005c97          	auipc	s9,0x5
ffffffffc0202286:	bdecbc83          	ld	s9,-1058(s9) # ffffffffc0206e60 <error_string+0x38>
ffffffffc020228a:	039686b3          	mul	a3,a3,s9
ffffffffc020228e:	000805b7          	lui	a1,0x80
ffffffffc0202292:	96ae                	add	a3,a3,a1
ffffffffc0202294:	00c69713          	slli	a4,a3,0xc
ffffffffc0202298:	8331                	srli	a4,a4,0xc
ffffffffc020229a:	06b2                	slli	a3,a3,0xc
ffffffffc020229c:	6cc77263          	bgeu	a4,a2,ffffffffc0202960 <pmm_init+0xa12>
ffffffffc02022a0:	0009b703          	ld	a4,0(s3)
ffffffffc02022a4:	96ba                	add	a3,a3,a4
ffffffffc02022a6:	629c                	ld	a5,0(a3)
ffffffffc02022a8:	078a                	slli	a5,a5,0x2
ffffffffc02022aa:	83b1                	srli	a5,a5,0xc
ffffffffc02022ac:	3ec7f163          	bgeu	a5,a2,ffffffffc020268e <pmm_init+0x740>
ffffffffc02022b0:	8f8d                	sub	a5,a5,a1
ffffffffc02022b2:	00379713          	slli	a4,a5,0x3
ffffffffc02022b6:	97ba                	add	a5,a5,a4
ffffffffc02022b8:	078e                	slli	a5,a5,0x3
ffffffffc02022ba:	953e                	add	a0,a0,a5
ffffffffc02022bc:	100027f3          	csrr	a5,sstatus
ffffffffc02022c0:	8b89                	andi	a5,a5,2
ffffffffc02022c2:	30079063          	bnez	a5,ffffffffc02025c2 <pmm_init+0x674>
ffffffffc02022c6:	000bb783          	ld	a5,0(s7)
ffffffffc02022ca:	4585                	li	a1,1
ffffffffc02022cc:	739c                	ld	a5,32(a5)
ffffffffc02022ce:	9782                	jalr	a5
ffffffffc02022d0:	000a3783          	ld	a5,0(s4)
ffffffffc02022d4:	6098                	ld	a4,0(s1)
ffffffffc02022d6:	078a                	slli	a5,a5,0x2
ffffffffc02022d8:	83b1                	srli	a5,a5,0xc
ffffffffc02022da:	3ae7fa63          	bgeu	a5,a4,ffffffffc020268e <pmm_init+0x740>
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
ffffffffc0202306:	00093783          	ld	a5,0(s2)
ffffffffc020230a:	0007b023          	sd	zero,0(a5) # fffffffffffff000 <end+0x3fde9a34>
ffffffffc020230e:	12000073          	sfence.vma
ffffffffc0202312:	100027f3          	csrr	a5,sstatus
ffffffffc0202316:	8b89                	andi	a5,a5,2
ffffffffc0202318:	26079f63          	bnez	a5,ffffffffc0202596 <pmm_init+0x648>
ffffffffc020231c:	000bb783          	ld	a5,0(s7)
ffffffffc0202320:	779c                	ld	a5,40(a5)
ffffffffc0202322:	9782                	jalr	a5
ffffffffc0202324:	8a2a                	mv	s4,a0
ffffffffc0202326:	73441963          	bne	s0,s4,ffffffffc0202a58 <pmm_init+0xb0a>
ffffffffc020232a:	00004517          	auipc	a0,0x4
ffffffffc020232e:	d0650513          	addi	a0,a0,-762 # ffffffffc0206030 <default_pmm_manager+0x4b8>
ffffffffc0202332:	e4ffd0ef          	jal	ra,ffffffffc0200180 <cprintf>
ffffffffc0202336:	100027f3          	csrr	a5,sstatus
ffffffffc020233a:	8b89                	andi	a5,a5,2
ffffffffc020233c:	24079363          	bnez	a5,ffffffffc0202582 <pmm_init+0x634>
ffffffffc0202340:	000bb783          	ld	a5,0(s7)
ffffffffc0202344:	779c                	ld	a5,40(a5)
ffffffffc0202346:	9782                	jalr	a5
ffffffffc0202348:	8c2a                	mv	s8,a0
ffffffffc020234a:	6098                	ld	a4,0(s1)
ffffffffc020234c:	c0200437          	lui	s0,0xc0200
ffffffffc0202350:	7afd                	lui	s5,0xfffff
ffffffffc0202352:	00c71793          	slli	a5,a4,0xc
ffffffffc0202356:	6a05                	lui	s4,0x1
ffffffffc0202358:	02f47c63          	bgeu	s0,a5,ffffffffc0202390 <pmm_init+0x442>
ffffffffc020235c:	00c45793          	srli	a5,s0,0xc
ffffffffc0202360:	00093503          	ld	a0,0(s2)
ffffffffc0202364:	30e7f863          	bgeu	a5,a4,ffffffffc0202674 <pmm_init+0x726>
ffffffffc0202368:	0009b583          	ld	a1,0(s3)
ffffffffc020236c:	4601                	li	a2,0
ffffffffc020236e:	95a2                	add	a1,a1,s0
ffffffffc0202370:	fe0ff0ef          	jal	ra,ffffffffc0201b50 <get_pte>
ffffffffc0202374:	2e050063          	beqz	a0,ffffffffc0202654 <pmm_init+0x706>
ffffffffc0202378:	611c                	ld	a5,0(a0)
ffffffffc020237a:	078a                	slli	a5,a5,0x2
ffffffffc020237c:	0157f7b3          	and	a5,a5,s5
ffffffffc0202380:	2a879a63          	bne	a5,s0,ffffffffc0202634 <pmm_init+0x6e6>
ffffffffc0202384:	6098                	ld	a4,0(s1)
ffffffffc0202386:	9452                	add	s0,s0,s4
ffffffffc0202388:	00c71793          	slli	a5,a4,0xc
ffffffffc020238c:	fcf468e3          	bltu	s0,a5,ffffffffc020235c <pmm_init+0x40e>
ffffffffc0202390:	00093783          	ld	a5,0(s2)
ffffffffc0202394:	639c                	ld	a5,0(a5)
ffffffffc0202396:	6a079163          	bnez	a5,ffffffffc0202a38 <pmm_init+0xaea>
ffffffffc020239a:	4505                	li	a0,1
ffffffffc020239c:	ea8ff0ef          	jal	ra,ffffffffc0201a44 <alloc_pages>
ffffffffc02023a0:	8aaa                	mv	s5,a0
ffffffffc02023a2:	00093503          	ld	a0,0(s2)
ffffffffc02023a6:	4699                	li	a3,6
ffffffffc02023a8:	10000613          	li	a2,256
ffffffffc02023ac:	85d6                	mv	a1,s5
ffffffffc02023ae:	a95ff0ef          	jal	ra,ffffffffc0201e42 <page_insert>
ffffffffc02023b2:	66051363          	bnez	a0,ffffffffc0202a18 <pmm_init+0xaca>
ffffffffc02023b6:	000aa703          	lw	a4,0(s5) # fffffffffffff000 <end+0x3fde9a34>
ffffffffc02023ba:	4785                	li	a5,1
ffffffffc02023bc:	62f71e63          	bne	a4,a5,ffffffffc02029f8 <pmm_init+0xaaa>
ffffffffc02023c0:	00093503          	ld	a0,0(s2)
ffffffffc02023c4:	6405                	lui	s0,0x1
ffffffffc02023c6:	4699                	li	a3,6
ffffffffc02023c8:	10040613          	addi	a2,s0,256 # 1100 <kern_entry-0xffffffffc01fef00>
ffffffffc02023cc:	85d6                	mv	a1,s5
ffffffffc02023ce:	a75ff0ef          	jal	ra,ffffffffc0201e42 <page_insert>
ffffffffc02023d2:	48051763          	bnez	a0,ffffffffc0202860 <pmm_init+0x912>
ffffffffc02023d6:	000aa703          	lw	a4,0(s5)
ffffffffc02023da:	4789                	li	a5,2
ffffffffc02023dc:	74f71a63          	bne	a4,a5,ffffffffc0202b30 <pmm_init+0xbe2>
ffffffffc02023e0:	00004597          	auipc	a1,0x4
ffffffffc02023e4:	d8858593          	addi	a1,a1,-632 # ffffffffc0206168 <default_pmm_manager+0x5f0>
ffffffffc02023e8:	10000513          	li	a0,256
ffffffffc02023ec:	1a3020ef          	jal	ra,ffffffffc0204d8e <strcpy>
ffffffffc02023f0:	10040593          	addi	a1,s0,256
ffffffffc02023f4:	10000513          	li	a0,256
ffffffffc02023f8:	1a9020ef          	jal	ra,ffffffffc0204da0 <strcmp>
ffffffffc02023fc:	70051a63          	bnez	a0,ffffffffc0202b10 <pmm_init+0xbc2>
ffffffffc0202400:	000b3683          	ld	a3,0(s6)
ffffffffc0202404:	00080d37          	lui	s10,0x80
ffffffffc0202408:	547d                	li	s0,-1
ffffffffc020240a:	40da86b3          	sub	a3,s5,a3
ffffffffc020240e:	868d                	srai	a3,a3,0x3
ffffffffc0202410:	039686b3          	mul	a3,a3,s9
ffffffffc0202414:	609c                	ld	a5,0(s1)
ffffffffc0202416:	8031                	srli	s0,s0,0xc
ffffffffc0202418:	96ea                	add	a3,a3,s10
ffffffffc020241a:	0086f733          	and	a4,a3,s0
ffffffffc020241e:	06b2                	slli	a3,a3,0xc
ffffffffc0202420:	54f77063          	bgeu	a4,a5,ffffffffc0202960 <pmm_init+0xa12>
ffffffffc0202424:	0009b783          	ld	a5,0(s3)
ffffffffc0202428:	10000513          	li	a0,256
ffffffffc020242c:	96be                	add	a3,a3,a5
ffffffffc020242e:	10068023          	sb	zero,256(a3) # fffffffffff80100 <end+0x3fd6ab34>
ffffffffc0202432:	127020ef          	jal	ra,ffffffffc0204d58 <strlen>
ffffffffc0202436:	6a051d63          	bnez	a0,ffffffffc0202af0 <pmm_init+0xba2>
ffffffffc020243a:	00093a03          	ld	s4,0(s2)
ffffffffc020243e:	6098                	ld	a4,0(s1)
ffffffffc0202440:	000a3783          	ld	a5,0(s4) # 1000 <kern_entry-0xffffffffc01ff000>
ffffffffc0202444:	078a                	slli	a5,a5,0x2
ffffffffc0202446:	83b1                	srli	a5,a5,0xc
ffffffffc0202448:	24e7f363          	bgeu	a5,a4,ffffffffc020268e <pmm_init+0x740>
ffffffffc020244c:	41a787b3          	sub	a5,a5,s10
ffffffffc0202450:	00379693          	slli	a3,a5,0x3
ffffffffc0202454:	96be                	add	a3,a3,a5
ffffffffc0202456:	03968cb3          	mul	s9,a3,s9
ffffffffc020245a:	01ac86b3          	add	a3,s9,s10
ffffffffc020245e:	8c75                	and	s0,s0,a3
ffffffffc0202460:	06b2                	slli	a3,a3,0xc
ffffffffc0202462:	4ee47f63          	bgeu	s0,a4,ffffffffc0202960 <pmm_init+0xa12>
ffffffffc0202466:	0009b403          	ld	s0,0(s3)
ffffffffc020246a:	9436                	add	s0,s0,a3
ffffffffc020246c:	100027f3          	csrr	a5,sstatus
ffffffffc0202470:	8b89                	andi	a5,a5,2
ffffffffc0202472:	1a079663          	bnez	a5,ffffffffc020261e <pmm_init+0x6d0>
ffffffffc0202476:	000bb783          	ld	a5,0(s7)
ffffffffc020247a:	4585                	li	a1,1
ffffffffc020247c:	8556                	mv	a0,s5
ffffffffc020247e:	739c                	ld	a5,32(a5)
ffffffffc0202480:	9782                	jalr	a5
ffffffffc0202482:	601c                	ld	a5,0(s0)
ffffffffc0202484:	6098                	ld	a4,0(s1)
ffffffffc0202486:	078a                	slli	a5,a5,0x2
ffffffffc0202488:	83b1                	srli	a5,a5,0xc
ffffffffc020248a:	20e7f263          	bgeu	a5,a4,ffffffffc020268e <pmm_init+0x740>
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
ffffffffc02024b6:	000a3783          	ld	a5,0(s4)
ffffffffc02024ba:	6098                	ld	a4,0(s1)
ffffffffc02024bc:	078a                	slli	a5,a5,0x2
ffffffffc02024be:	83b1                	srli	a5,a5,0xc
ffffffffc02024c0:	1ce7f763          	bgeu	a5,a4,ffffffffc020268e <pmm_init+0x740>
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
ffffffffc02024ec:	00093783          	ld	a5,0(s2)
ffffffffc02024f0:	0007b023          	sd	zero,0(a5)
ffffffffc02024f4:	12000073          	sfence.vma
ffffffffc02024f8:	100027f3          	csrr	a5,sstatus
ffffffffc02024fc:	8b89                	andi	a5,a5,2
ffffffffc02024fe:	0c079e63          	bnez	a5,ffffffffc02025da <pmm_init+0x68c>
ffffffffc0202502:	000bb783          	ld	a5,0(s7)
ffffffffc0202506:	779c                	ld	a5,40(a5)
ffffffffc0202508:	9782                	jalr	a5
ffffffffc020250a:	842a                	mv	s0,a0
ffffffffc020250c:	3a8c1a63          	bne	s8,s0,ffffffffc02028c0 <pmm_init+0x972>
ffffffffc0202510:	00004517          	auipc	a0,0x4
ffffffffc0202514:	cd050513          	addi	a0,a0,-816 # ffffffffc02061e0 <default_pmm_manager+0x668>
ffffffffc0202518:	c69fd0ef          	jal	ra,ffffffffc0200180 <cprintf>
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
ffffffffc0202536:	b0aff06f          	j	ffffffffc0201840 <kmalloc_init>
ffffffffc020253a:	6705                	lui	a4,0x1
ffffffffc020253c:	177d                	addi	a4,a4,-1
ffffffffc020253e:	96ba                	add	a3,a3,a4
ffffffffc0202540:	777d                	lui	a4,0xfffff
ffffffffc0202542:	8f75                	and	a4,a4,a3
ffffffffc0202544:	00c75693          	srli	a3,a4,0xc
ffffffffc0202548:	14f6f363          	bgeu	a3,a5,ffffffffc020268e <pmm_init+0x740>
ffffffffc020254c:	000bb583          	ld	a1,0(s7)
ffffffffc0202550:	9836                	add	a6,a6,a3
ffffffffc0202552:	00381793          	slli	a5,a6,0x3
ffffffffc0202556:	6994                	ld	a3,16(a1)
ffffffffc0202558:	97c2                	add	a5,a5,a6
ffffffffc020255a:	40e60733          	sub	a4,a2,a4
ffffffffc020255e:	078e                	slli	a5,a5,0x3
ffffffffc0202560:	00c75593          	srli	a1,a4,0xc
ffffffffc0202564:	953e                	add	a0,a0,a5
ffffffffc0202566:	9682                	jalr	a3
ffffffffc0202568:	0009b583          	ld	a1,0(s3)
ffffffffc020256c:	bcd9                	j	ffffffffc0202042 <pmm_init+0xf4>
ffffffffc020256e:	830fe0ef          	jal	ra,ffffffffc020059e <intr_disable>
ffffffffc0202572:	000bb783          	ld	a5,0(s7)
ffffffffc0202576:	779c                	ld	a5,40(a5)
ffffffffc0202578:	9782                	jalr	a5
ffffffffc020257a:	842a                	mv	s0,a0
ffffffffc020257c:	81cfe0ef          	jal	ra,ffffffffc0200598 <intr_enable>
ffffffffc0202580:	b605                	j	ffffffffc02020a0 <pmm_init+0x152>
ffffffffc0202582:	81cfe0ef          	jal	ra,ffffffffc020059e <intr_disable>
ffffffffc0202586:	000bb783          	ld	a5,0(s7)
ffffffffc020258a:	779c                	ld	a5,40(a5)
ffffffffc020258c:	9782                	jalr	a5
ffffffffc020258e:	8c2a                	mv	s8,a0
ffffffffc0202590:	808fe0ef          	jal	ra,ffffffffc0200598 <intr_enable>
ffffffffc0202594:	bb5d                	j	ffffffffc020234a <pmm_init+0x3fc>
ffffffffc0202596:	808fe0ef          	jal	ra,ffffffffc020059e <intr_disable>
ffffffffc020259a:	000bb783          	ld	a5,0(s7)
ffffffffc020259e:	779c                	ld	a5,40(a5)
ffffffffc02025a0:	9782                	jalr	a5
ffffffffc02025a2:	8a2a                	mv	s4,a0
ffffffffc02025a4:	ff5fd0ef          	jal	ra,ffffffffc0200598 <intr_enable>
ffffffffc02025a8:	bbbd                	j	ffffffffc0202326 <pmm_init+0x3d8>
ffffffffc02025aa:	e42a                	sd	a0,8(sp)
ffffffffc02025ac:	ff3fd0ef          	jal	ra,ffffffffc020059e <intr_disable>
ffffffffc02025b0:	000bb783          	ld	a5,0(s7)
ffffffffc02025b4:	6522                	ld	a0,8(sp)
ffffffffc02025b6:	4585                	li	a1,1
ffffffffc02025b8:	739c                	ld	a5,32(a5)
ffffffffc02025ba:	9782                	jalr	a5
ffffffffc02025bc:	fddfd0ef          	jal	ra,ffffffffc0200598 <intr_enable>
ffffffffc02025c0:	b399                	j	ffffffffc0202306 <pmm_init+0x3b8>
ffffffffc02025c2:	e42a                	sd	a0,8(sp)
ffffffffc02025c4:	fdbfd0ef          	jal	ra,ffffffffc020059e <intr_disable>
ffffffffc02025c8:	000bb783          	ld	a5,0(s7)
ffffffffc02025cc:	6522                	ld	a0,8(sp)
ffffffffc02025ce:	4585                	li	a1,1
ffffffffc02025d0:	739c                	ld	a5,32(a5)
ffffffffc02025d2:	9782                	jalr	a5
ffffffffc02025d4:	fc5fd0ef          	jal	ra,ffffffffc0200598 <intr_enable>
ffffffffc02025d8:	b9e5                	j	ffffffffc02022d0 <pmm_init+0x382>
ffffffffc02025da:	fc5fd0ef          	jal	ra,ffffffffc020059e <intr_disable>
ffffffffc02025de:	000bb783          	ld	a5,0(s7)
ffffffffc02025e2:	779c                	ld	a5,40(a5)
ffffffffc02025e4:	9782                	jalr	a5
ffffffffc02025e6:	842a                	mv	s0,a0
ffffffffc02025e8:	fb1fd0ef          	jal	ra,ffffffffc0200598 <intr_enable>
ffffffffc02025ec:	b705                	j	ffffffffc020250c <pmm_init+0x5be>
ffffffffc02025ee:	e42a                	sd	a0,8(sp)
ffffffffc02025f0:	faffd0ef          	jal	ra,ffffffffc020059e <intr_disable>
ffffffffc02025f4:	000bb783          	ld	a5,0(s7)
ffffffffc02025f8:	6522                	ld	a0,8(sp)
ffffffffc02025fa:	4585                	li	a1,1
ffffffffc02025fc:	739c                	ld	a5,32(a5)
ffffffffc02025fe:	9782                	jalr	a5
ffffffffc0202600:	f99fd0ef          	jal	ra,ffffffffc0200598 <intr_enable>
ffffffffc0202604:	b5e5                	j	ffffffffc02024ec <pmm_init+0x59e>
ffffffffc0202606:	e42a                	sd	a0,8(sp)
ffffffffc0202608:	f97fd0ef          	jal	ra,ffffffffc020059e <intr_disable>
ffffffffc020260c:	000bb783          	ld	a5,0(s7)
ffffffffc0202610:	6522                	ld	a0,8(sp)
ffffffffc0202612:	4585                	li	a1,1
ffffffffc0202614:	739c                	ld	a5,32(a5)
ffffffffc0202616:	9782                	jalr	a5
ffffffffc0202618:	f81fd0ef          	jal	ra,ffffffffc0200598 <intr_enable>
ffffffffc020261c:	bd69                	j	ffffffffc02024b6 <pmm_init+0x568>
ffffffffc020261e:	f81fd0ef          	jal	ra,ffffffffc020059e <intr_disable>
ffffffffc0202622:	000bb783          	ld	a5,0(s7)
ffffffffc0202626:	4585                	li	a1,1
ffffffffc0202628:	8556                	mv	a0,s5
ffffffffc020262a:	739c                	ld	a5,32(a5)
ffffffffc020262c:	9782                	jalr	a5
ffffffffc020262e:	f6bfd0ef          	jal	ra,ffffffffc0200598 <intr_enable>
ffffffffc0202632:	bd81                	j	ffffffffc0202482 <pmm_init+0x534>
ffffffffc0202634:	00004697          	auipc	a3,0x4
ffffffffc0202638:	a5c68693          	addi	a3,a3,-1444 # ffffffffc0206090 <default_pmm_manager+0x518>
ffffffffc020263c:	00003617          	auipc	a2,0x3
ffffffffc0202640:	18c60613          	addi	a2,a2,396 # ffffffffc02057c8 <commands+0x738>
ffffffffc0202644:	19e00593          	li	a1,414
ffffffffc0202648:	00003517          	auipc	a0,0x3
ffffffffc020264c:	68050513          	addi	a0,a0,1664 # ffffffffc0205cc8 <default_pmm_manager+0x150>
ffffffffc0202650:	df7fd0ef          	jal	ra,ffffffffc0200446 <__panic>
ffffffffc0202654:	00004697          	auipc	a3,0x4
ffffffffc0202658:	9fc68693          	addi	a3,a3,-1540 # ffffffffc0206050 <default_pmm_manager+0x4d8>
ffffffffc020265c:	00003617          	auipc	a2,0x3
ffffffffc0202660:	16c60613          	addi	a2,a2,364 # ffffffffc02057c8 <commands+0x738>
ffffffffc0202664:	19d00593          	li	a1,413
ffffffffc0202668:	00003517          	auipc	a0,0x3
ffffffffc020266c:	66050513          	addi	a0,a0,1632 # ffffffffc0205cc8 <default_pmm_manager+0x150>
ffffffffc0202670:	dd7fd0ef          	jal	ra,ffffffffc0200446 <__panic>
ffffffffc0202674:	86a2                	mv	a3,s0
ffffffffc0202676:	00003617          	auipc	a2,0x3
ffffffffc020267a:	53a60613          	addi	a2,a2,1338 # ffffffffc0205bb0 <default_pmm_manager+0x38>
ffffffffc020267e:	19d00593          	li	a1,413
ffffffffc0202682:	00003517          	auipc	a0,0x3
ffffffffc0202686:	64650513          	addi	a0,a0,1606 # ffffffffc0205cc8 <default_pmm_manager+0x150>
ffffffffc020268a:	dbdfd0ef          	jal	ra,ffffffffc0200446 <__panic>
ffffffffc020268e:	b7eff0ef          	jal	ra,ffffffffc0201a0c <pa2page.part.0>
ffffffffc0202692:	00003617          	auipc	a2,0x3
ffffffffc0202696:	5c660613          	addi	a2,a2,1478 # ffffffffc0205c58 <default_pmm_manager+0xe0>
ffffffffc020269a:	07f00593          	li	a1,127
ffffffffc020269e:	00003517          	auipc	a0,0x3
ffffffffc02026a2:	62a50513          	addi	a0,a0,1578 # ffffffffc0205cc8 <default_pmm_manager+0x150>
ffffffffc02026a6:	da1fd0ef          	jal	ra,ffffffffc0200446 <__panic>
ffffffffc02026aa:	00003617          	auipc	a2,0x3
ffffffffc02026ae:	5ae60613          	addi	a2,a2,1454 # ffffffffc0205c58 <default_pmm_manager+0xe0>
ffffffffc02026b2:	0c300593          	li	a1,195
ffffffffc02026b6:	00003517          	auipc	a0,0x3
ffffffffc02026ba:	61250513          	addi	a0,a0,1554 # ffffffffc0205cc8 <default_pmm_manager+0x150>
ffffffffc02026be:	d89fd0ef          	jal	ra,ffffffffc0200446 <__panic>
ffffffffc02026c2:	00003697          	auipc	a3,0x3
ffffffffc02026c6:	6c668693          	addi	a3,a3,1734 # ffffffffc0205d88 <default_pmm_manager+0x210>
ffffffffc02026ca:	00003617          	auipc	a2,0x3
ffffffffc02026ce:	0fe60613          	addi	a2,a2,254 # ffffffffc02057c8 <commands+0x738>
ffffffffc02026d2:	16100593          	li	a1,353
ffffffffc02026d6:	00003517          	auipc	a0,0x3
ffffffffc02026da:	5f250513          	addi	a0,a0,1522 # ffffffffc0205cc8 <default_pmm_manager+0x150>
ffffffffc02026de:	d69fd0ef          	jal	ra,ffffffffc0200446 <__panic>
ffffffffc02026e2:	00003697          	auipc	a3,0x3
ffffffffc02026e6:	68668693          	addi	a3,a3,1670 # ffffffffc0205d68 <default_pmm_manager+0x1f0>
ffffffffc02026ea:	00003617          	auipc	a2,0x3
ffffffffc02026ee:	0de60613          	addi	a2,a2,222 # ffffffffc02057c8 <commands+0x738>
ffffffffc02026f2:	16000593          	li	a1,352
ffffffffc02026f6:	00003517          	auipc	a0,0x3
ffffffffc02026fa:	5d250513          	addi	a0,a0,1490 # ffffffffc0205cc8 <default_pmm_manager+0x150>
ffffffffc02026fe:	d49fd0ef          	jal	ra,ffffffffc0200446 <__panic>
ffffffffc0202702:	b26ff0ef          	jal	ra,ffffffffc0201a28 <pte2page.part.0>
ffffffffc0202706:	00003697          	auipc	a3,0x3
ffffffffc020270a:	71268693          	addi	a3,a3,1810 # ffffffffc0205e18 <default_pmm_manager+0x2a0>
ffffffffc020270e:	00003617          	auipc	a2,0x3
ffffffffc0202712:	0ba60613          	addi	a2,a2,186 # ffffffffc02057c8 <commands+0x738>
ffffffffc0202716:	16900593          	li	a1,361
ffffffffc020271a:	00003517          	auipc	a0,0x3
ffffffffc020271e:	5ae50513          	addi	a0,a0,1454 # ffffffffc0205cc8 <default_pmm_manager+0x150>
ffffffffc0202722:	d25fd0ef          	jal	ra,ffffffffc0200446 <__panic>
ffffffffc0202726:	00003697          	auipc	a3,0x3
ffffffffc020272a:	6c268693          	addi	a3,a3,1730 # ffffffffc0205de8 <default_pmm_manager+0x270>
ffffffffc020272e:	00003617          	auipc	a2,0x3
ffffffffc0202732:	09a60613          	addi	a2,a2,154 # ffffffffc02057c8 <commands+0x738>
ffffffffc0202736:	16600593          	li	a1,358
ffffffffc020273a:	00003517          	auipc	a0,0x3
ffffffffc020273e:	58e50513          	addi	a0,a0,1422 # ffffffffc0205cc8 <default_pmm_manager+0x150>
ffffffffc0202742:	d05fd0ef          	jal	ra,ffffffffc0200446 <__panic>
ffffffffc0202746:	00003697          	auipc	a3,0x3
ffffffffc020274a:	67a68693          	addi	a3,a3,1658 # ffffffffc0205dc0 <default_pmm_manager+0x248>
ffffffffc020274e:	00003617          	auipc	a2,0x3
ffffffffc0202752:	07a60613          	addi	a2,a2,122 # ffffffffc02057c8 <commands+0x738>
ffffffffc0202756:	16200593          	li	a1,354
ffffffffc020275a:	00003517          	auipc	a0,0x3
ffffffffc020275e:	56e50513          	addi	a0,a0,1390 # ffffffffc0205cc8 <default_pmm_manager+0x150>
ffffffffc0202762:	ce5fd0ef          	jal	ra,ffffffffc0200446 <__panic>
ffffffffc0202766:	00003697          	auipc	a3,0x3
ffffffffc020276a:	73a68693          	addi	a3,a3,1850 # ffffffffc0205ea0 <default_pmm_manager+0x328>
ffffffffc020276e:	00003617          	auipc	a2,0x3
ffffffffc0202772:	05a60613          	addi	a2,a2,90 # ffffffffc02057c8 <commands+0x738>
ffffffffc0202776:	17200593          	li	a1,370
ffffffffc020277a:	00003517          	auipc	a0,0x3
ffffffffc020277e:	54e50513          	addi	a0,a0,1358 # ffffffffc0205cc8 <default_pmm_manager+0x150>
ffffffffc0202782:	cc5fd0ef          	jal	ra,ffffffffc0200446 <__panic>
ffffffffc0202786:	00003697          	auipc	a3,0x3
ffffffffc020278a:	7ba68693          	addi	a3,a3,1978 # ffffffffc0205f40 <default_pmm_manager+0x3c8>
ffffffffc020278e:	00003617          	auipc	a2,0x3
ffffffffc0202792:	03a60613          	addi	a2,a2,58 # ffffffffc02057c8 <commands+0x738>
ffffffffc0202796:	17700593          	li	a1,375
ffffffffc020279a:	00003517          	auipc	a0,0x3
ffffffffc020279e:	52e50513          	addi	a0,a0,1326 # ffffffffc0205cc8 <default_pmm_manager+0x150>
ffffffffc02027a2:	ca5fd0ef          	jal	ra,ffffffffc0200446 <__panic>
ffffffffc02027a6:	00003697          	auipc	a3,0x3
ffffffffc02027aa:	6d268693          	addi	a3,a3,1746 # ffffffffc0205e78 <default_pmm_manager+0x300>
ffffffffc02027ae:	00003617          	auipc	a2,0x3
ffffffffc02027b2:	01a60613          	addi	a2,a2,26 # ffffffffc02057c8 <commands+0x738>
ffffffffc02027b6:	16f00593          	li	a1,367
ffffffffc02027ba:	00003517          	auipc	a0,0x3
ffffffffc02027be:	50e50513          	addi	a0,a0,1294 # ffffffffc0205cc8 <default_pmm_manager+0x150>
ffffffffc02027c2:	c85fd0ef          	jal	ra,ffffffffc0200446 <__panic>
ffffffffc02027c6:	86d6                	mv	a3,s5
ffffffffc02027c8:	00003617          	auipc	a2,0x3
ffffffffc02027cc:	3e860613          	addi	a2,a2,1000 # ffffffffc0205bb0 <default_pmm_manager+0x38>
ffffffffc02027d0:	16e00593          	li	a1,366
ffffffffc02027d4:	00003517          	auipc	a0,0x3
ffffffffc02027d8:	4f450513          	addi	a0,a0,1268 # ffffffffc0205cc8 <default_pmm_manager+0x150>
ffffffffc02027dc:	c6bfd0ef          	jal	ra,ffffffffc0200446 <__panic>
ffffffffc02027e0:	00003697          	auipc	a3,0x3
ffffffffc02027e4:	6f868693          	addi	a3,a3,1784 # ffffffffc0205ed8 <default_pmm_manager+0x360>
ffffffffc02027e8:	00003617          	auipc	a2,0x3
ffffffffc02027ec:	fe060613          	addi	a2,a2,-32 # ffffffffc02057c8 <commands+0x738>
ffffffffc02027f0:	17c00593          	li	a1,380
ffffffffc02027f4:	00003517          	auipc	a0,0x3
ffffffffc02027f8:	4d450513          	addi	a0,a0,1236 # ffffffffc0205cc8 <default_pmm_manager+0x150>
ffffffffc02027fc:	c4bfd0ef          	jal	ra,ffffffffc0200446 <__panic>
ffffffffc0202800:	00003697          	auipc	a3,0x3
ffffffffc0202804:	7a068693          	addi	a3,a3,1952 # ffffffffc0205fa0 <default_pmm_manager+0x428>
ffffffffc0202808:	00003617          	auipc	a2,0x3
ffffffffc020280c:	fc060613          	addi	a2,a2,-64 # ffffffffc02057c8 <commands+0x738>
ffffffffc0202810:	17b00593          	li	a1,379
ffffffffc0202814:	00003517          	auipc	a0,0x3
ffffffffc0202818:	4b450513          	addi	a0,a0,1204 # ffffffffc0205cc8 <default_pmm_manager+0x150>
ffffffffc020281c:	c2bfd0ef          	jal	ra,ffffffffc0200446 <__panic>
ffffffffc0202820:	00003697          	auipc	a3,0x3
ffffffffc0202824:	76868693          	addi	a3,a3,1896 # ffffffffc0205f88 <default_pmm_manager+0x410>
ffffffffc0202828:	00003617          	auipc	a2,0x3
ffffffffc020282c:	fa060613          	addi	a2,a2,-96 # ffffffffc02057c8 <commands+0x738>
ffffffffc0202830:	17a00593          	li	a1,378
ffffffffc0202834:	00003517          	auipc	a0,0x3
ffffffffc0202838:	49450513          	addi	a0,a0,1172 # ffffffffc0205cc8 <default_pmm_manager+0x150>
ffffffffc020283c:	c0bfd0ef          	jal	ra,ffffffffc0200446 <__panic>
ffffffffc0202840:	00003697          	auipc	a3,0x3
ffffffffc0202844:	71868693          	addi	a3,a3,1816 # ffffffffc0205f58 <default_pmm_manager+0x3e0>
ffffffffc0202848:	00003617          	auipc	a2,0x3
ffffffffc020284c:	f8060613          	addi	a2,a2,-128 # ffffffffc02057c8 <commands+0x738>
ffffffffc0202850:	17900593          	li	a1,377
ffffffffc0202854:	00003517          	auipc	a0,0x3
ffffffffc0202858:	47450513          	addi	a0,a0,1140 # ffffffffc0205cc8 <default_pmm_manager+0x150>
ffffffffc020285c:	bebfd0ef          	jal	ra,ffffffffc0200446 <__panic>
ffffffffc0202860:	00004697          	auipc	a3,0x4
ffffffffc0202864:	8b068693          	addi	a3,a3,-1872 # ffffffffc0206110 <default_pmm_manager+0x598>
ffffffffc0202868:	00003617          	auipc	a2,0x3
ffffffffc020286c:	f6060613          	addi	a2,a2,-160 # ffffffffc02057c8 <commands+0x738>
ffffffffc0202870:	1a700593          	li	a1,423
ffffffffc0202874:	00003517          	auipc	a0,0x3
ffffffffc0202878:	45450513          	addi	a0,a0,1108 # ffffffffc0205cc8 <default_pmm_manager+0x150>
ffffffffc020287c:	bcbfd0ef          	jal	ra,ffffffffc0200446 <__panic>
ffffffffc0202880:	00003697          	auipc	a3,0x3
ffffffffc0202884:	6a868693          	addi	a3,a3,1704 # ffffffffc0205f28 <default_pmm_manager+0x3b0>
ffffffffc0202888:	00003617          	auipc	a2,0x3
ffffffffc020288c:	f4060613          	addi	a2,a2,-192 # ffffffffc02057c8 <commands+0x738>
ffffffffc0202890:	17600593          	li	a1,374
ffffffffc0202894:	00003517          	auipc	a0,0x3
ffffffffc0202898:	43450513          	addi	a0,a0,1076 # ffffffffc0205cc8 <default_pmm_manager+0x150>
ffffffffc020289c:	babfd0ef          	jal	ra,ffffffffc0200446 <__panic>
ffffffffc02028a0:	00003697          	auipc	a3,0x3
ffffffffc02028a4:	67868693          	addi	a3,a3,1656 # ffffffffc0205f18 <default_pmm_manager+0x3a0>
ffffffffc02028a8:	00003617          	auipc	a2,0x3
ffffffffc02028ac:	f2060613          	addi	a2,a2,-224 # ffffffffc02057c8 <commands+0x738>
ffffffffc02028b0:	17500593          	li	a1,373
ffffffffc02028b4:	00003517          	auipc	a0,0x3
ffffffffc02028b8:	41450513          	addi	a0,a0,1044 # ffffffffc0205cc8 <default_pmm_manager+0x150>
ffffffffc02028bc:	b8bfd0ef          	jal	ra,ffffffffc0200446 <__panic>
ffffffffc02028c0:	00003697          	auipc	a3,0x3
ffffffffc02028c4:	75068693          	addi	a3,a3,1872 # ffffffffc0206010 <default_pmm_manager+0x498>
ffffffffc02028c8:	00003617          	auipc	a2,0x3
ffffffffc02028cc:	f0060613          	addi	a2,a2,-256 # ffffffffc02057c8 <commands+0x738>
ffffffffc02028d0:	1b800593          	li	a1,440
ffffffffc02028d4:	00003517          	auipc	a0,0x3
ffffffffc02028d8:	3f450513          	addi	a0,a0,1012 # ffffffffc0205cc8 <default_pmm_manager+0x150>
ffffffffc02028dc:	b6bfd0ef          	jal	ra,ffffffffc0200446 <__panic>
ffffffffc02028e0:	00003697          	auipc	a3,0x3
ffffffffc02028e4:	62868693          	addi	a3,a3,1576 # ffffffffc0205f08 <default_pmm_manager+0x390>
ffffffffc02028e8:	00003617          	auipc	a2,0x3
ffffffffc02028ec:	ee060613          	addi	a2,a2,-288 # ffffffffc02057c8 <commands+0x738>
ffffffffc02028f0:	17400593          	li	a1,372
ffffffffc02028f4:	00003517          	auipc	a0,0x3
ffffffffc02028f8:	3d450513          	addi	a0,a0,980 # ffffffffc0205cc8 <default_pmm_manager+0x150>
ffffffffc02028fc:	b4bfd0ef          	jal	ra,ffffffffc0200446 <__panic>
ffffffffc0202900:	00003697          	auipc	a3,0x3
ffffffffc0202904:	56068693          	addi	a3,a3,1376 # ffffffffc0205e60 <default_pmm_manager+0x2e8>
ffffffffc0202908:	00003617          	auipc	a2,0x3
ffffffffc020290c:	ec060613          	addi	a2,a2,-320 # ffffffffc02057c8 <commands+0x738>
ffffffffc0202910:	18100593          	li	a1,385
ffffffffc0202914:	00003517          	auipc	a0,0x3
ffffffffc0202918:	3b450513          	addi	a0,a0,948 # ffffffffc0205cc8 <default_pmm_manager+0x150>
ffffffffc020291c:	b2bfd0ef          	jal	ra,ffffffffc0200446 <__panic>
ffffffffc0202920:	00003697          	auipc	a3,0x3
ffffffffc0202924:	69868693          	addi	a3,a3,1688 # ffffffffc0205fb8 <default_pmm_manager+0x440>
ffffffffc0202928:	00003617          	auipc	a2,0x3
ffffffffc020292c:	ea060613          	addi	a2,a2,-352 # ffffffffc02057c8 <commands+0x738>
ffffffffc0202930:	17e00593          	li	a1,382
ffffffffc0202934:	00003517          	auipc	a0,0x3
ffffffffc0202938:	39450513          	addi	a0,a0,916 # ffffffffc0205cc8 <default_pmm_manager+0x150>
ffffffffc020293c:	b0bfd0ef          	jal	ra,ffffffffc0200446 <__panic>
ffffffffc0202940:	00003697          	auipc	a3,0x3
ffffffffc0202944:	50868693          	addi	a3,a3,1288 # ffffffffc0205e48 <default_pmm_manager+0x2d0>
ffffffffc0202948:	00003617          	auipc	a2,0x3
ffffffffc020294c:	e8060613          	addi	a2,a2,-384 # ffffffffc02057c8 <commands+0x738>
ffffffffc0202950:	17d00593          	li	a1,381
ffffffffc0202954:	00003517          	auipc	a0,0x3
ffffffffc0202958:	37450513          	addi	a0,a0,884 # ffffffffc0205cc8 <default_pmm_manager+0x150>
ffffffffc020295c:	aebfd0ef          	jal	ra,ffffffffc0200446 <__panic>
ffffffffc0202960:	00003617          	auipc	a2,0x3
ffffffffc0202964:	25060613          	addi	a2,a2,592 # ffffffffc0205bb0 <default_pmm_manager+0x38>
ffffffffc0202968:	06900593          	li	a1,105
ffffffffc020296c:	00003517          	auipc	a0,0x3
ffffffffc0202970:	26c50513          	addi	a0,a0,620 # ffffffffc0205bd8 <default_pmm_manager+0x60>
ffffffffc0202974:	ad3fd0ef          	jal	ra,ffffffffc0200446 <__panic>
ffffffffc0202978:	00003697          	auipc	a3,0x3
ffffffffc020297c:	67068693          	addi	a3,a3,1648 # ffffffffc0205fe8 <default_pmm_manager+0x470>
ffffffffc0202980:	00003617          	auipc	a2,0x3
ffffffffc0202984:	e4860613          	addi	a2,a2,-440 # ffffffffc02057c8 <commands+0x738>
ffffffffc0202988:	18800593          	li	a1,392
ffffffffc020298c:	00003517          	auipc	a0,0x3
ffffffffc0202990:	33c50513          	addi	a0,a0,828 # ffffffffc0205cc8 <default_pmm_manager+0x150>
ffffffffc0202994:	ab3fd0ef          	jal	ra,ffffffffc0200446 <__panic>
ffffffffc0202998:	00003697          	auipc	a3,0x3
ffffffffc020299c:	60868693          	addi	a3,a3,1544 # ffffffffc0205fa0 <default_pmm_manager+0x428>
ffffffffc02029a0:	00003617          	auipc	a2,0x3
ffffffffc02029a4:	e2860613          	addi	a2,a2,-472 # ffffffffc02057c8 <commands+0x738>
ffffffffc02029a8:	18600593          	li	a1,390
ffffffffc02029ac:	00003517          	auipc	a0,0x3
ffffffffc02029b0:	31c50513          	addi	a0,a0,796 # ffffffffc0205cc8 <default_pmm_manager+0x150>
ffffffffc02029b4:	a93fd0ef          	jal	ra,ffffffffc0200446 <__panic>
ffffffffc02029b8:	00003697          	auipc	a3,0x3
ffffffffc02029bc:	61868693          	addi	a3,a3,1560 # ffffffffc0205fd0 <default_pmm_manager+0x458>
ffffffffc02029c0:	00003617          	auipc	a2,0x3
ffffffffc02029c4:	e0860613          	addi	a2,a2,-504 # ffffffffc02057c8 <commands+0x738>
ffffffffc02029c8:	18500593          	li	a1,389
ffffffffc02029cc:	00003517          	auipc	a0,0x3
ffffffffc02029d0:	2fc50513          	addi	a0,a0,764 # ffffffffc0205cc8 <default_pmm_manager+0x150>
ffffffffc02029d4:	a73fd0ef          	jal	ra,ffffffffc0200446 <__panic>
ffffffffc02029d8:	00003697          	auipc	a3,0x3
ffffffffc02029dc:	5c868693          	addi	a3,a3,1480 # ffffffffc0205fa0 <default_pmm_manager+0x428>
ffffffffc02029e0:	00003617          	auipc	a2,0x3
ffffffffc02029e4:	de860613          	addi	a2,a2,-536 # ffffffffc02057c8 <commands+0x738>
ffffffffc02029e8:	18200593          	li	a1,386
ffffffffc02029ec:	00003517          	auipc	a0,0x3
ffffffffc02029f0:	2dc50513          	addi	a0,a0,732 # ffffffffc0205cc8 <default_pmm_manager+0x150>
ffffffffc02029f4:	a53fd0ef          	jal	ra,ffffffffc0200446 <__panic>
ffffffffc02029f8:	00003697          	auipc	a3,0x3
ffffffffc02029fc:	70068693          	addi	a3,a3,1792 # ffffffffc02060f8 <default_pmm_manager+0x580>
ffffffffc0202a00:	00003617          	auipc	a2,0x3
ffffffffc0202a04:	dc860613          	addi	a2,a2,-568 # ffffffffc02057c8 <commands+0x738>
ffffffffc0202a08:	1a600593          	li	a1,422
ffffffffc0202a0c:	00003517          	auipc	a0,0x3
ffffffffc0202a10:	2bc50513          	addi	a0,a0,700 # ffffffffc0205cc8 <default_pmm_manager+0x150>
ffffffffc0202a14:	a33fd0ef          	jal	ra,ffffffffc0200446 <__panic>
ffffffffc0202a18:	00003697          	auipc	a3,0x3
ffffffffc0202a1c:	6a868693          	addi	a3,a3,1704 # ffffffffc02060c0 <default_pmm_manager+0x548>
ffffffffc0202a20:	00003617          	auipc	a2,0x3
ffffffffc0202a24:	da860613          	addi	a2,a2,-600 # ffffffffc02057c8 <commands+0x738>
ffffffffc0202a28:	1a500593          	li	a1,421
ffffffffc0202a2c:	00003517          	auipc	a0,0x3
ffffffffc0202a30:	29c50513          	addi	a0,a0,668 # ffffffffc0205cc8 <default_pmm_manager+0x150>
ffffffffc0202a34:	a13fd0ef          	jal	ra,ffffffffc0200446 <__panic>
ffffffffc0202a38:	00003697          	auipc	a3,0x3
ffffffffc0202a3c:	67068693          	addi	a3,a3,1648 # ffffffffc02060a8 <default_pmm_manager+0x530>
ffffffffc0202a40:	00003617          	auipc	a2,0x3
ffffffffc0202a44:	d8860613          	addi	a2,a2,-632 # ffffffffc02057c8 <commands+0x738>
ffffffffc0202a48:	1a100593          	li	a1,417
ffffffffc0202a4c:	00003517          	auipc	a0,0x3
ffffffffc0202a50:	27c50513          	addi	a0,a0,636 # ffffffffc0205cc8 <default_pmm_manager+0x150>
ffffffffc0202a54:	9f3fd0ef          	jal	ra,ffffffffc0200446 <__panic>
ffffffffc0202a58:	00003697          	auipc	a3,0x3
ffffffffc0202a5c:	5b868693          	addi	a3,a3,1464 # ffffffffc0206010 <default_pmm_manager+0x498>
ffffffffc0202a60:	00003617          	auipc	a2,0x3
ffffffffc0202a64:	d6860613          	addi	a2,a2,-664 # ffffffffc02057c8 <commands+0x738>
ffffffffc0202a68:	19000593          	li	a1,400
ffffffffc0202a6c:	00003517          	auipc	a0,0x3
ffffffffc0202a70:	25c50513          	addi	a0,a0,604 # ffffffffc0205cc8 <default_pmm_manager+0x150>
ffffffffc0202a74:	9d3fd0ef          	jal	ra,ffffffffc0200446 <__panic>
ffffffffc0202a78:	00003697          	auipc	a3,0x3
ffffffffc0202a7c:	3d068693          	addi	a3,a3,976 # ffffffffc0205e48 <default_pmm_manager+0x2d0>
ffffffffc0202a80:	00003617          	auipc	a2,0x3
ffffffffc0202a84:	d4860613          	addi	a2,a2,-696 # ffffffffc02057c8 <commands+0x738>
ffffffffc0202a88:	16a00593          	li	a1,362
ffffffffc0202a8c:	00003517          	auipc	a0,0x3
ffffffffc0202a90:	23c50513          	addi	a0,a0,572 # ffffffffc0205cc8 <default_pmm_manager+0x150>
ffffffffc0202a94:	9b3fd0ef          	jal	ra,ffffffffc0200446 <__panic>
ffffffffc0202a98:	00003617          	auipc	a2,0x3
ffffffffc0202a9c:	11860613          	addi	a2,a2,280 # ffffffffc0205bb0 <default_pmm_manager+0x38>
ffffffffc0202aa0:	16d00593          	li	a1,365
ffffffffc0202aa4:	00003517          	auipc	a0,0x3
ffffffffc0202aa8:	22450513          	addi	a0,a0,548 # ffffffffc0205cc8 <default_pmm_manager+0x150>
ffffffffc0202aac:	99bfd0ef          	jal	ra,ffffffffc0200446 <__panic>
ffffffffc0202ab0:	00003697          	auipc	a3,0x3
ffffffffc0202ab4:	3b068693          	addi	a3,a3,944 # ffffffffc0205e60 <default_pmm_manager+0x2e8>
ffffffffc0202ab8:	00003617          	auipc	a2,0x3
ffffffffc0202abc:	d1060613          	addi	a2,a2,-752 # ffffffffc02057c8 <commands+0x738>
ffffffffc0202ac0:	16b00593          	li	a1,363
ffffffffc0202ac4:	00003517          	auipc	a0,0x3
ffffffffc0202ac8:	20450513          	addi	a0,a0,516 # ffffffffc0205cc8 <default_pmm_manager+0x150>
ffffffffc0202acc:	97bfd0ef          	jal	ra,ffffffffc0200446 <__panic>
ffffffffc0202ad0:	00003697          	auipc	a3,0x3
ffffffffc0202ad4:	40868693          	addi	a3,a3,1032 # ffffffffc0205ed8 <default_pmm_manager+0x360>
ffffffffc0202ad8:	00003617          	auipc	a2,0x3
ffffffffc0202adc:	cf060613          	addi	a2,a2,-784 # ffffffffc02057c8 <commands+0x738>
ffffffffc0202ae0:	17300593          	li	a1,371
ffffffffc0202ae4:	00003517          	auipc	a0,0x3
ffffffffc0202ae8:	1e450513          	addi	a0,a0,484 # ffffffffc0205cc8 <default_pmm_manager+0x150>
ffffffffc0202aec:	95bfd0ef          	jal	ra,ffffffffc0200446 <__panic>
ffffffffc0202af0:	00003697          	auipc	a3,0x3
ffffffffc0202af4:	6c868693          	addi	a3,a3,1736 # ffffffffc02061b8 <default_pmm_manager+0x640>
ffffffffc0202af8:	00003617          	auipc	a2,0x3
ffffffffc0202afc:	cd060613          	addi	a2,a2,-816 # ffffffffc02057c8 <commands+0x738>
ffffffffc0202b00:	1af00593          	li	a1,431
ffffffffc0202b04:	00003517          	auipc	a0,0x3
ffffffffc0202b08:	1c450513          	addi	a0,a0,452 # ffffffffc0205cc8 <default_pmm_manager+0x150>
ffffffffc0202b0c:	93bfd0ef          	jal	ra,ffffffffc0200446 <__panic>
ffffffffc0202b10:	00003697          	auipc	a3,0x3
ffffffffc0202b14:	67068693          	addi	a3,a3,1648 # ffffffffc0206180 <default_pmm_manager+0x608>
ffffffffc0202b18:	00003617          	auipc	a2,0x3
ffffffffc0202b1c:	cb060613          	addi	a2,a2,-848 # ffffffffc02057c8 <commands+0x738>
ffffffffc0202b20:	1ac00593          	li	a1,428
ffffffffc0202b24:	00003517          	auipc	a0,0x3
ffffffffc0202b28:	1a450513          	addi	a0,a0,420 # ffffffffc0205cc8 <default_pmm_manager+0x150>
ffffffffc0202b2c:	91bfd0ef          	jal	ra,ffffffffc0200446 <__panic>
ffffffffc0202b30:	00003697          	auipc	a3,0x3
ffffffffc0202b34:	62068693          	addi	a3,a3,1568 # ffffffffc0206150 <default_pmm_manager+0x5d8>
ffffffffc0202b38:	00003617          	auipc	a2,0x3
ffffffffc0202b3c:	c9060613          	addi	a2,a2,-880 # ffffffffc02057c8 <commands+0x738>
ffffffffc0202b40:	1a800593          	li	a1,424
ffffffffc0202b44:	00003517          	auipc	a0,0x3
ffffffffc0202b48:	18450513          	addi	a0,a0,388 # ffffffffc0205cc8 <default_pmm_manager+0x150>
ffffffffc0202b4c:	8fbfd0ef          	jal	ra,ffffffffc0200446 <__panic>

ffffffffc0202b50 <tlb_invalidate>:
ffffffffc0202b50:	12058073          	sfence.vma	a1
ffffffffc0202b54:	8082                	ret

ffffffffc0202b56 <pgdir_alloc_page>:
ffffffffc0202b56:	7179                	addi	sp,sp,-48
ffffffffc0202b58:	e84a                	sd	s2,16(sp)
ffffffffc0202b5a:	892a                	mv	s2,a0
ffffffffc0202b5c:	4505                	li	a0,1
ffffffffc0202b5e:	f022                	sd	s0,32(sp)
ffffffffc0202b60:	ec26                	sd	s1,24(sp)
ffffffffc0202b62:	e44e                	sd	s3,8(sp)
ffffffffc0202b64:	f406                	sd	ra,40(sp)
ffffffffc0202b66:	84ae                	mv	s1,a1
ffffffffc0202b68:	89b2                	mv	s3,a2
ffffffffc0202b6a:	edbfe0ef          	jal	ra,ffffffffc0201a44 <alloc_pages>
ffffffffc0202b6e:	842a                	mv	s0,a0
ffffffffc0202b70:	cd09                	beqz	a0,ffffffffc0202b8a <pgdir_alloc_page+0x34>
ffffffffc0202b72:	85aa                	mv	a1,a0
ffffffffc0202b74:	86ce                	mv	a3,s3
ffffffffc0202b76:	8626                	mv	a2,s1
ffffffffc0202b78:	854a                	mv	a0,s2
ffffffffc0202b7a:	ac8ff0ef          	jal	ra,ffffffffc0201e42 <page_insert>
ffffffffc0202b7e:	ed21                	bnez	a0,ffffffffc0202bd6 <pgdir_alloc_page+0x80>
ffffffffc0202b80:	00013797          	auipc	a5,0x13
ffffffffc0202b84:	a187a783          	lw	a5,-1512(a5) # ffffffffc0215598 <swap_init_ok>
ffffffffc0202b88:	eb89                	bnez	a5,ffffffffc0202b9a <pgdir_alloc_page+0x44>
ffffffffc0202b8a:	70a2                	ld	ra,40(sp)
ffffffffc0202b8c:	8522                	mv	a0,s0
ffffffffc0202b8e:	7402                	ld	s0,32(sp)
ffffffffc0202b90:	64e2                	ld	s1,24(sp)
ffffffffc0202b92:	6942                	ld	s2,16(sp)
ffffffffc0202b94:	69a2                	ld	s3,8(sp)
ffffffffc0202b96:	6145                	addi	sp,sp,48
ffffffffc0202b98:	8082                	ret
ffffffffc0202b9a:	4681                	li	a3,0
ffffffffc0202b9c:	8622                	mv	a2,s0
ffffffffc0202b9e:	85a6                	mv	a1,s1
ffffffffc0202ba0:	00013517          	auipc	a0,0x13
ffffffffc0202ba4:	a0053503          	ld	a0,-1536(a0) # ffffffffc02155a0 <check_mm_struct>
ffffffffc0202ba8:	7ee000ef          	jal	ra,ffffffffc0203396 <swap_map_swappable>
ffffffffc0202bac:	4018                	lw	a4,0(s0)
ffffffffc0202bae:	e024                	sd	s1,64(s0)
ffffffffc0202bb0:	4785                	li	a5,1
ffffffffc0202bb2:	fcf70ce3          	beq	a4,a5,ffffffffc0202b8a <pgdir_alloc_page+0x34>
ffffffffc0202bb6:	00003697          	auipc	a3,0x3
ffffffffc0202bba:	64a68693          	addi	a3,a3,1610 # ffffffffc0206200 <default_pmm_manager+0x688>
ffffffffc0202bbe:	00003617          	auipc	a2,0x3
ffffffffc0202bc2:	c0a60613          	addi	a2,a2,-1014 # ffffffffc02057c8 <commands+0x738>
ffffffffc0202bc6:	14800593          	li	a1,328
ffffffffc0202bca:	00003517          	auipc	a0,0x3
ffffffffc0202bce:	0fe50513          	addi	a0,a0,254 # ffffffffc0205cc8 <default_pmm_manager+0x150>
ffffffffc0202bd2:	875fd0ef          	jal	ra,ffffffffc0200446 <__panic>
ffffffffc0202bd6:	100027f3          	csrr	a5,sstatus
ffffffffc0202bda:	8b89                	andi	a5,a5,2
ffffffffc0202bdc:	eb99                	bnez	a5,ffffffffc0202bf2 <pgdir_alloc_page+0x9c>
ffffffffc0202bde:	00013797          	auipc	a5,0x13
ffffffffc0202be2:	99a7b783          	ld	a5,-1638(a5) # ffffffffc0215578 <pmm_manager>
ffffffffc0202be6:	739c                	ld	a5,32(a5)
ffffffffc0202be8:	8522                	mv	a0,s0
ffffffffc0202bea:	4585                	li	a1,1
ffffffffc0202bec:	9782                	jalr	a5
ffffffffc0202bee:	4401                	li	s0,0
ffffffffc0202bf0:	bf69                	j	ffffffffc0202b8a <pgdir_alloc_page+0x34>
ffffffffc0202bf2:	9adfd0ef          	jal	ra,ffffffffc020059e <intr_disable>
ffffffffc0202bf6:	00013797          	auipc	a5,0x13
ffffffffc0202bfa:	9827b783          	ld	a5,-1662(a5) # ffffffffc0215578 <pmm_manager>
ffffffffc0202bfe:	739c                	ld	a5,32(a5)
ffffffffc0202c00:	8522                	mv	a0,s0
ffffffffc0202c02:	4585                	li	a1,1
ffffffffc0202c04:	9782                	jalr	a5
ffffffffc0202c06:	4401                	li	s0,0
ffffffffc0202c08:	991fd0ef          	jal	ra,ffffffffc0200598 <intr_enable>
ffffffffc0202c0c:	bfbd                	j	ffffffffc0202b8a <pgdir_alloc_page+0x34>

ffffffffc0202c0e <pa2page.part.0>:
ffffffffc0202c0e:	1141                	addi	sp,sp,-16
ffffffffc0202c10:	00003617          	auipc	a2,0x3
ffffffffc0202c14:	07060613          	addi	a2,a2,112 # ffffffffc0205c80 <default_pmm_manager+0x108>
ffffffffc0202c18:	06200593          	li	a1,98
ffffffffc0202c1c:	00003517          	auipc	a0,0x3
ffffffffc0202c20:	fbc50513          	addi	a0,a0,-68 # ffffffffc0205bd8 <default_pmm_manager+0x60>
ffffffffc0202c24:	e406                	sd	ra,8(sp)
ffffffffc0202c26:	821fd0ef          	jal	ra,ffffffffc0200446 <__panic>

ffffffffc0202c2a <swap_init>:
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
ffffffffc0202c46:	4e4010ef          	jal	ra,ffffffffc020412a <swapfs_init>
ffffffffc0202c4a:	00013697          	auipc	a3,0x13
ffffffffc0202c4e:	93e6b683          	ld	a3,-1730(a3) # ffffffffc0215588 <max_swap_offset>
ffffffffc0202c52:	010007b7          	lui	a5,0x1000
ffffffffc0202c56:	ff968713          	addi	a4,a3,-7
ffffffffc0202c5a:	17e1                	addi	a5,a5,-8
ffffffffc0202c5c:	44e7e363          	bltu	a5,a4,ffffffffc02030a2 <swap_init+0x478>
ffffffffc0202c60:	00007797          	auipc	a5,0x7
ffffffffc0202c64:	3b078793          	addi	a5,a5,944 # ffffffffc020a010 <swap_manager_fifo>
ffffffffc0202c68:	6798                	ld	a4,8(a5)
ffffffffc0202c6a:	00013b97          	auipc	s7,0x13
ffffffffc0202c6e:	926b8b93          	addi	s7,s7,-1754 # ffffffffc0215590 <sm>
ffffffffc0202c72:	00fbb023          	sd	a5,0(s7)
ffffffffc0202c76:	9702                	jalr	a4
ffffffffc0202c78:	892a                	mv	s2,a0
ffffffffc0202c7a:	c10d                	beqz	a0,ffffffffc0202c9c <swap_init+0x72>
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
ffffffffc0202c9c:	000bb783          	ld	a5,0(s7)
ffffffffc0202ca0:	00003517          	auipc	a0,0x3
ffffffffc0202ca4:	5a850513          	addi	a0,a0,1448 # ffffffffc0206248 <default_pmm_manager+0x6d0>
ffffffffc0202ca8:	0000e417          	auipc	s0,0xe
ffffffffc0202cac:	7b840413          	addi	s0,s0,1976 # ffffffffc0211460 <free_area>
ffffffffc0202cb0:	638c                	ld	a1,0(a5)
ffffffffc0202cb2:	4785                	li	a5,1
ffffffffc0202cb4:	00013717          	auipc	a4,0x13
ffffffffc0202cb8:	8ef72223          	sw	a5,-1820(a4) # ffffffffc0215598 <swap_init_ok>
ffffffffc0202cbc:	cc4fd0ef          	jal	ra,ffffffffc0200180 <cprintf>
ffffffffc0202cc0:	641c                	ld	a5,8(s0)
ffffffffc0202cc2:	4d01                	li	s10,0
ffffffffc0202cc4:	4d81                	li	s11,0
ffffffffc0202cc6:	34878e63          	beq	a5,s0,ffffffffc0203022 <swap_init+0x3f8>
ffffffffc0202cca:	fe87b703          	ld	a4,-24(a5)
ffffffffc0202cce:	8b09                	andi	a4,a4,2
ffffffffc0202cd0:	34070b63          	beqz	a4,ffffffffc0203026 <swap_init+0x3fc>
ffffffffc0202cd4:	ff87a703          	lw	a4,-8(a5)
ffffffffc0202cd8:	679c                	ld	a5,8(a5)
ffffffffc0202cda:	2d85                	addiw	s11,s11,1
ffffffffc0202cdc:	01a70d3b          	addw	s10,a4,s10
ffffffffc0202ce0:	fe8795e3          	bne	a5,s0,ffffffffc0202cca <swap_init+0xa0>
ffffffffc0202ce4:	84ea                	mv	s1,s10
ffffffffc0202ce6:	e31fe0ef          	jal	ra,ffffffffc0201b16 <nr_free_pages>
ffffffffc0202cea:	44951463          	bne	a0,s1,ffffffffc0203132 <swap_init+0x508>
ffffffffc0202cee:	866a                	mv	a2,s10
ffffffffc0202cf0:	85ee                	mv	a1,s11
ffffffffc0202cf2:	00003517          	auipc	a0,0x3
ffffffffc0202cf6:	56e50513          	addi	a0,a0,1390 # ffffffffc0206260 <default_pmm_manager+0x6e8>
ffffffffc0202cfa:	c86fd0ef          	jal	ra,ffffffffc0200180 <cprintf>
ffffffffc0202cfe:	3cb000ef          	jal	ra,ffffffffc02038c8 <mm_create>
ffffffffc0202d02:	8aaa                	mv	s5,a0
ffffffffc0202d04:	48050763          	beqz	a0,ffffffffc0203192 <swap_init+0x568>
ffffffffc0202d08:	00013797          	auipc	a5,0x13
ffffffffc0202d0c:	89878793          	addi	a5,a5,-1896 # ffffffffc02155a0 <check_mm_struct>
ffffffffc0202d10:	6398                	ld	a4,0(a5)
ffffffffc0202d12:	40071063          	bnez	a4,ffffffffc0203112 <swap_init+0x4e8>
ffffffffc0202d16:	00013717          	auipc	a4,0x13
ffffffffc0202d1a:	84a70713          	addi	a4,a4,-1974 # ffffffffc0215560 <boot_pgdir>
ffffffffc0202d1e:	00073b03          	ld	s6,0(a4)
ffffffffc0202d22:	e388                	sd	a0,0(a5)
ffffffffc0202d24:	000b3783          	ld	a5,0(s6)
ffffffffc0202d28:	01653c23          	sd	s6,24(a0)
ffffffffc0202d2c:	44079363          	bnez	a5,ffffffffc0203172 <swap_init+0x548>
ffffffffc0202d30:	6599                	lui	a1,0x6
ffffffffc0202d32:	460d                	li	a2,3
ffffffffc0202d34:	6505                	lui	a0,0x1
ffffffffc0202d36:	3db000ef          	jal	ra,ffffffffc0203910 <vma_create>
ffffffffc0202d3a:	85aa                	mv	a1,a0
ffffffffc0202d3c:	54050763          	beqz	a0,ffffffffc020328a <swap_init+0x660>
ffffffffc0202d40:	8556                	mv	a0,s5
ffffffffc0202d42:	43d000ef          	jal	ra,ffffffffc020397e <insert_vma_struct>
ffffffffc0202d46:	00003517          	auipc	a0,0x3
ffffffffc0202d4a:	58a50513          	addi	a0,a0,1418 # ffffffffc02062d0 <default_pmm_manager+0x758>
ffffffffc0202d4e:	c32fd0ef          	jal	ra,ffffffffc0200180 <cprintf>
ffffffffc0202d52:	018ab503          	ld	a0,24(s5)
ffffffffc0202d56:	4605                	li	a2,1
ffffffffc0202d58:	6585                	lui	a1,0x1
ffffffffc0202d5a:	df7fe0ef          	jal	ra,ffffffffc0201b50 <get_pte>
ffffffffc0202d5e:	4e050663          	beqz	a0,ffffffffc020324a <swap_init+0x620>
ffffffffc0202d62:	00003517          	auipc	a0,0x3
ffffffffc0202d66:	5be50513          	addi	a0,a0,1470 # ffffffffc0206320 <default_pmm_manager+0x7a8>
ffffffffc0202d6a:	0000e497          	auipc	s1,0xe
ffffffffc0202d6e:	72e48493          	addi	s1,s1,1838 # ffffffffc0211498 <check_rp>
ffffffffc0202d72:	c0efd0ef          	jal	ra,ffffffffc0200180 <cprintf>
ffffffffc0202d76:	0000e997          	auipc	s3,0xe
ffffffffc0202d7a:	74298993          	addi	s3,s3,1858 # ffffffffc02114b8 <swap_in_seq_no>
ffffffffc0202d7e:	8a26                	mv	s4,s1
ffffffffc0202d80:	4505                	li	a0,1
ffffffffc0202d82:	cc3fe0ef          	jal	ra,ffffffffc0201a44 <alloc_pages>
ffffffffc0202d86:	00aa3023          	sd	a0,0(s4)
ffffffffc0202d8a:	2e050c63          	beqz	a0,ffffffffc0203082 <swap_init+0x458>
ffffffffc0202d8e:	651c                	ld	a5,8(a0)
ffffffffc0202d90:	8b89                	andi	a5,a5,2
ffffffffc0202d92:	36079063          	bnez	a5,ffffffffc02030f2 <swap_init+0x4c8>
ffffffffc0202d96:	0a21                	addi	s4,s4,8
ffffffffc0202d98:	ff3a14e3          	bne	s4,s3,ffffffffc0202d80 <swap_init+0x156>
ffffffffc0202d9c:	601c                	ld	a5,0(s0)
ffffffffc0202d9e:	0000ea17          	auipc	s4,0xe
ffffffffc0202da2:	6faa0a13          	addi	s4,s4,1786 # ffffffffc0211498 <check_rp>
ffffffffc0202da6:	e000                	sd	s0,0(s0)
ffffffffc0202da8:	ec3e                	sd	a5,24(sp)
ffffffffc0202daa:	641c                	ld	a5,8(s0)
ffffffffc0202dac:	e400                	sd	s0,8(s0)
ffffffffc0202dae:	f03e                	sd	a5,32(sp)
ffffffffc0202db0:	481c                	lw	a5,16(s0)
ffffffffc0202db2:	f43e                	sd	a5,40(sp)
ffffffffc0202db4:	0000e797          	auipc	a5,0xe
ffffffffc0202db8:	6a07ae23          	sw	zero,1724(a5) # ffffffffc0211470 <free_area+0x10>
ffffffffc0202dbc:	000a3503          	ld	a0,0(s4)
ffffffffc0202dc0:	4585                	li	a1,1
ffffffffc0202dc2:	0a21                	addi	s4,s4,8
ffffffffc0202dc4:	d13fe0ef          	jal	ra,ffffffffc0201ad6 <free_pages>
ffffffffc0202dc8:	ff3a1ae3          	bne	s4,s3,ffffffffc0202dbc <swap_init+0x192>
ffffffffc0202dcc:	01042a03          	lw	s4,16(s0)
ffffffffc0202dd0:	4791                	li	a5,4
ffffffffc0202dd2:	44fa1c63          	bne	s4,a5,ffffffffc020322a <swap_init+0x600>
ffffffffc0202dd6:	00003517          	auipc	a0,0x3
ffffffffc0202dda:	5d250513          	addi	a0,a0,1490 # ffffffffc02063a8 <default_pmm_manager+0x830>
ffffffffc0202dde:	ba2fd0ef          	jal	ra,ffffffffc0200180 <cprintf>
ffffffffc0202de2:	6705                	lui	a4,0x1
ffffffffc0202de4:	00012797          	auipc	a5,0x12
ffffffffc0202de8:	7c07a223          	sw	zero,1988(a5) # ffffffffc02155a8 <pgfault_num>
ffffffffc0202dec:	4629                	li	a2,10
ffffffffc0202dee:	00c70023          	sb	a2,0(a4) # 1000 <kern_entry-0xffffffffc01ff000>
ffffffffc0202df2:	00012697          	auipc	a3,0x12
ffffffffc0202df6:	7b66a683          	lw	a3,1974(a3) # ffffffffc02155a8 <pgfault_num>
ffffffffc0202dfa:	4585                	li	a1,1
ffffffffc0202dfc:	00012797          	auipc	a5,0x12
ffffffffc0202e00:	7ac78793          	addi	a5,a5,1964 # ffffffffc02155a8 <pgfault_num>
ffffffffc0202e04:	56b69363          	bne	a3,a1,ffffffffc020336a <swap_init+0x740>
ffffffffc0202e08:	00c70823          	sb	a2,16(a4)
ffffffffc0202e0c:	4398                	lw	a4,0(a5)
ffffffffc0202e0e:	2701                	sext.w	a4,a4
ffffffffc0202e10:	3ed71d63          	bne	a4,a3,ffffffffc020320a <swap_init+0x5e0>
ffffffffc0202e14:	6689                	lui	a3,0x2
ffffffffc0202e16:	462d                	li	a2,11
ffffffffc0202e18:	00c68023          	sb	a2,0(a3) # 2000 <kern_entry-0xffffffffc01fe000>
ffffffffc0202e1c:	4398                	lw	a4,0(a5)
ffffffffc0202e1e:	4589                	li	a1,2
ffffffffc0202e20:	2701                	sext.w	a4,a4
ffffffffc0202e22:	4cb71463          	bne	a4,a1,ffffffffc02032ea <swap_init+0x6c0>
ffffffffc0202e26:	00c68823          	sb	a2,16(a3)
ffffffffc0202e2a:	4394                	lw	a3,0(a5)
ffffffffc0202e2c:	2681                	sext.w	a3,a3
ffffffffc0202e2e:	4ce69e63          	bne	a3,a4,ffffffffc020330a <swap_init+0x6e0>
ffffffffc0202e32:	668d                	lui	a3,0x3
ffffffffc0202e34:	4631                	li	a2,12
ffffffffc0202e36:	00c68023          	sb	a2,0(a3) # 3000 <kern_entry-0xffffffffc01fd000>
ffffffffc0202e3a:	4398                	lw	a4,0(a5)
ffffffffc0202e3c:	458d                	li	a1,3
ffffffffc0202e3e:	2701                	sext.w	a4,a4
ffffffffc0202e40:	4eb71563          	bne	a4,a1,ffffffffc020332a <swap_init+0x700>
ffffffffc0202e44:	00c68823          	sb	a2,16(a3)
ffffffffc0202e48:	4394                	lw	a3,0(a5)
ffffffffc0202e4a:	2681                	sext.w	a3,a3
ffffffffc0202e4c:	4ee69f63          	bne	a3,a4,ffffffffc020334a <swap_init+0x720>
ffffffffc0202e50:	6691                	lui	a3,0x4
ffffffffc0202e52:	4635                	li	a2,13
ffffffffc0202e54:	00c68023          	sb	a2,0(a3) # 4000 <kern_entry-0xffffffffc01fc000>
ffffffffc0202e58:	4398                	lw	a4,0(a5)
ffffffffc0202e5a:	2701                	sext.w	a4,a4
ffffffffc0202e5c:	45471763          	bne	a4,s4,ffffffffc02032aa <swap_init+0x680>
ffffffffc0202e60:	00c68823          	sb	a2,16(a3)
ffffffffc0202e64:	439c                	lw	a5,0(a5)
ffffffffc0202e66:	2781                	sext.w	a5,a5
ffffffffc0202e68:	46e79163          	bne	a5,a4,ffffffffc02032ca <swap_init+0x6a0>
ffffffffc0202e6c:	481c                	lw	a5,16(s0)
ffffffffc0202e6e:	2e079263          	bnez	a5,ffffffffc0203152 <swap_init+0x528>
ffffffffc0202e72:	0000e797          	auipc	a5,0xe
ffffffffc0202e76:	64678793          	addi	a5,a5,1606 # ffffffffc02114b8 <swap_in_seq_no>
ffffffffc0202e7a:	0000e717          	auipc	a4,0xe
ffffffffc0202e7e:	66670713          	addi	a4,a4,1638 # ffffffffc02114e0 <swap_out_seq_no>
ffffffffc0202e82:	0000e617          	auipc	a2,0xe
ffffffffc0202e86:	65e60613          	addi	a2,a2,1630 # ffffffffc02114e0 <swap_out_seq_no>
ffffffffc0202e8a:	56fd                	li	a3,-1
ffffffffc0202e8c:	c394                	sw	a3,0(a5)
ffffffffc0202e8e:	c314                	sw	a3,0(a4)
ffffffffc0202e90:	0791                	addi	a5,a5,4
ffffffffc0202e92:	0711                	addi	a4,a4,4
ffffffffc0202e94:	fec79ce3          	bne	a5,a2,ffffffffc0202e8c <swap_init+0x262>
ffffffffc0202e98:	0000e717          	auipc	a4,0xe
ffffffffc0202e9c:	5e070713          	addi	a4,a4,1504 # ffffffffc0211478 <check_ptep>
ffffffffc0202ea0:	0000e697          	auipc	a3,0xe
ffffffffc0202ea4:	5f868693          	addi	a3,a3,1528 # ffffffffc0211498 <check_rp>
ffffffffc0202ea8:	6585                	lui	a1,0x1
ffffffffc0202eaa:	00012c17          	auipc	s8,0x12
ffffffffc0202eae:	6bec0c13          	addi	s8,s8,1726 # ffffffffc0215568 <npage>
ffffffffc0202eb2:	00012c97          	auipc	s9,0x12
ffffffffc0202eb6:	6bec8c93          	addi	s9,s9,1726 # ffffffffc0215570 <pages>
ffffffffc0202eba:	00073023          	sd	zero,0(a4)
ffffffffc0202ebe:	4601                	li	a2,0
ffffffffc0202ec0:	855a                	mv	a0,s6
ffffffffc0202ec2:	e836                	sd	a3,16(sp)
ffffffffc0202ec4:	e42e                	sd	a1,8(sp)
ffffffffc0202ec6:	e03a                	sd	a4,0(sp)
ffffffffc0202ec8:	c89fe0ef          	jal	ra,ffffffffc0201b50 <get_pte>
ffffffffc0202ecc:	6702                	ld	a4,0(sp)
ffffffffc0202ece:	65a2                	ld	a1,8(sp)
ffffffffc0202ed0:	66c2                	ld	a3,16(sp)
ffffffffc0202ed2:	e308                	sd	a0,0(a4)
ffffffffc0202ed4:	1e050363          	beqz	a0,ffffffffc02030ba <swap_init+0x490>
ffffffffc0202ed8:	611c                	ld	a5,0(a0)
ffffffffc0202eda:	0017f613          	andi	a2,a5,1
ffffffffc0202ede:	1e060e63          	beqz	a2,ffffffffc02030da <swap_init+0x4b0>
ffffffffc0202ee2:	000c3603          	ld	a2,0(s8)
ffffffffc0202ee6:	078a                	slli	a5,a5,0x2
ffffffffc0202ee8:	83b1                	srli	a5,a5,0xc
ffffffffc0202eea:	16c7f063          	bgeu	a5,a2,ffffffffc020304a <swap_init+0x420>
ffffffffc0202eee:	00004617          	auipc	a2,0x4
ffffffffc0202ef2:	f7a60613          	addi	a2,a2,-134 # ffffffffc0206e68 <nbase>
ffffffffc0202ef6:	00063a03          	ld	s4,0(a2)
ffffffffc0202efa:	000cb503          	ld	a0,0(s9)
ffffffffc0202efe:	0006b303          	ld	t1,0(a3)
ffffffffc0202f02:	414787b3          	sub	a5,a5,s4
ffffffffc0202f06:	00379613          	slli	a2,a5,0x3
ffffffffc0202f0a:	97b2                	add	a5,a5,a2
ffffffffc0202f0c:	078e                	slli	a5,a5,0x3
ffffffffc0202f0e:	97aa                	add	a5,a5,a0
ffffffffc0202f10:	14f31963          	bne	t1,a5,ffffffffc0203062 <swap_init+0x438>
ffffffffc0202f14:	6785                	lui	a5,0x1
ffffffffc0202f16:	95be                	add	a1,a1,a5
ffffffffc0202f18:	6795                	lui	a5,0x5
ffffffffc0202f1a:	0721                	addi	a4,a4,8
ffffffffc0202f1c:	06a1                	addi	a3,a3,8
ffffffffc0202f1e:	f8f59ee3          	bne	a1,a5,ffffffffc0202eba <swap_init+0x290>
ffffffffc0202f22:	00003517          	auipc	a0,0x3
ffffffffc0202f26:	52e50513          	addi	a0,a0,1326 # ffffffffc0206450 <default_pmm_manager+0x8d8>
ffffffffc0202f2a:	a56fd0ef          	jal	ra,ffffffffc0200180 <cprintf>
ffffffffc0202f2e:	000bb783          	ld	a5,0(s7)
ffffffffc0202f32:	7f9c                	ld	a5,56(a5)
ffffffffc0202f34:	9782                	jalr	a5
ffffffffc0202f36:	32051a63          	bnez	a0,ffffffffc020326a <swap_init+0x640>
ffffffffc0202f3a:	77a2                	ld	a5,40(sp)
ffffffffc0202f3c:	c81c                	sw	a5,16(s0)
ffffffffc0202f3e:	67e2                	ld	a5,24(sp)
ffffffffc0202f40:	e01c                	sd	a5,0(s0)
ffffffffc0202f42:	7782                	ld	a5,32(sp)
ffffffffc0202f44:	e41c                	sd	a5,8(s0)
ffffffffc0202f46:	6088                	ld	a0,0(s1)
ffffffffc0202f48:	4585                	li	a1,1
ffffffffc0202f4a:	04a1                	addi	s1,s1,8
ffffffffc0202f4c:	b8bfe0ef          	jal	ra,ffffffffc0201ad6 <free_pages>
ffffffffc0202f50:	ff349be3          	bne	s1,s3,ffffffffc0202f46 <swap_init+0x31c>
ffffffffc0202f54:	8556                	mv	a0,s5
ffffffffc0202f56:	2f9000ef          	jal	ra,ffffffffc0203a4e <mm_destroy>
ffffffffc0202f5a:	00012797          	auipc	a5,0x12
ffffffffc0202f5e:	60678793          	addi	a5,a5,1542 # ffffffffc0215560 <boot_pgdir>
ffffffffc0202f62:	639c                	ld	a5,0(a5)
ffffffffc0202f64:	000c3703          	ld	a4,0(s8)
ffffffffc0202f68:	6394                	ld	a3,0(a5)
ffffffffc0202f6a:	068a                	slli	a3,a3,0x2
ffffffffc0202f6c:	82b1                	srli	a3,a3,0xc
ffffffffc0202f6e:	0ce6fc63          	bgeu	a3,a4,ffffffffc0203046 <swap_init+0x41c>
ffffffffc0202f72:	414687b3          	sub	a5,a3,s4
ffffffffc0202f76:	00379693          	slli	a3,a5,0x3
ffffffffc0202f7a:	96be                	add	a3,a3,a5
ffffffffc0202f7c:	068e                	slli	a3,a3,0x3
ffffffffc0202f7e:	00004797          	auipc	a5,0x4
ffffffffc0202f82:	ee27b783          	ld	a5,-286(a5) # ffffffffc0206e60 <error_string+0x38>
ffffffffc0202f86:	868d                	srai	a3,a3,0x3
ffffffffc0202f88:	02f686b3          	mul	a3,a3,a5
ffffffffc0202f8c:	000cb503          	ld	a0,0(s9)
ffffffffc0202f90:	96d2                	add	a3,a3,s4
ffffffffc0202f92:	00c69793          	slli	a5,a3,0xc
ffffffffc0202f96:	83b1                	srli	a5,a5,0xc
ffffffffc0202f98:	06b2                	slli	a3,a3,0xc
ffffffffc0202f9a:	22e7fc63          	bgeu	a5,a4,ffffffffc02031d2 <swap_init+0x5a8>
ffffffffc0202f9e:	00012797          	auipc	a5,0x12
ffffffffc0202fa2:	5e27b783          	ld	a5,1506(a5) # ffffffffc0215580 <va_pa_offset>
ffffffffc0202fa6:	96be                	add	a3,a3,a5
ffffffffc0202fa8:	629c                	ld	a5,0(a3)
ffffffffc0202faa:	078a                	slli	a5,a5,0x2
ffffffffc0202fac:	83b1                	srli	a5,a5,0xc
ffffffffc0202fae:	08e7fc63          	bgeu	a5,a4,ffffffffc0203046 <swap_init+0x41c>
ffffffffc0202fb2:	414787b3          	sub	a5,a5,s4
ffffffffc0202fb6:	00379713          	slli	a4,a5,0x3
ffffffffc0202fba:	97ba                	add	a5,a5,a4
ffffffffc0202fbc:	078e                	slli	a5,a5,0x3
ffffffffc0202fbe:	953e                	add	a0,a0,a5
ffffffffc0202fc0:	4585                	li	a1,1
ffffffffc0202fc2:	b15fe0ef          	jal	ra,ffffffffc0201ad6 <free_pages>
ffffffffc0202fc6:	000b3783          	ld	a5,0(s6)
ffffffffc0202fca:	000c3703          	ld	a4,0(s8)
ffffffffc0202fce:	078a                	slli	a5,a5,0x2
ffffffffc0202fd0:	83b1                	srli	a5,a5,0xc
ffffffffc0202fd2:	06e7fa63          	bgeu	a5,a4,ffffffffc0203046 <swap_init+0x41c>
ffffffffc0202fd6:	414787b3          	sub	a5,a5,s4
ffffffffc0202fda:	000cb503          	ld	a0,0(s9)
ffffffffc0202fde:	00379a13          	slli	s4,a5,0x3
ffffffffc0202fe2:	97d2                	add	a5,a5,s4
ffffffffc0202fe4:	078e                	slli	a5,a5,0x3
ffffffffc0202fe6:	4585                	li	a1,1
ffffffffc0202fe8:	953e                	add	a0,a0,a5
ffffffffc0202fea:	aedfe0ef          	jal	ra,ffffffffc0201ad6 <free_pages>
ffffffffc0202fee:	000b3023          	sd	zero,0(s6)
ffffffffc0202ff2:	12000073          	sfence.vma
ffffffffc0202ff6:	641c                	ld	a5,8(s0)
ffffffffc0202ff8:	00878a63          	beq	a5,s0,ffffffffc020300c <swap_init+0x3e2>
ffffffffc0202ffc:	ff87a703          	lw	a4,-8(a5)
ffffffffc0203000:	679c                	ld	a5,8(a5)
ffffffffc0203002:	3dfd                	addiw	s11,s11,-1
ffffffffc0203004:	40ed0d3b          	subw	s10,s10,a4
ffffffffc0203008:	fe879ae3          	bne	a5,s0,ffffffffc0202ffc <swap_init+0x3d2>
ffffffffc020300c:	1c0d9f63          	bnez	s11,ffffffffc02031ea <swap_init+0x5c0>
ffffffffc0203010:	1a0d1163          	bnez	s10,ffffffffc02031b2 <swap_init+0x588>
ffffffffc0203014:	00003517          	auipc	a0,0x3
ffffffffc0203018:	48c50513          	addi	a0,a0,1164 # ffffffffc02064a0 <default_pmm_manager+0x928>
ffffffffc020301c:	964fd0ef          	jal	ra,ffffffffc0200180 <cprintf>
ffffffffc0203020:	b9b1                	j	ffffffffc0202c7c <swap_init+0x52>
ffffffffc0203022:	4481                	li	s1,0
ffffffffc0203024:	b1c9                	j	ffffffffc0202ce6 <swap_init+0xbc>
ffffffffc0203026:	00002697          	auipc	a3,0x2
ffffffffc020302a:	79268693          	addi	a3,a3,1938 # ffffffffc02057b8 <commands+0x728>
ffffffffc020302e:	00002617          	auipc	a2,0x2
ffffffffc0203032:	79a60613          	addi	a2,a2,1946 # ffffffffc02057c8 <commands+0x738>
ffffffffc0203036:	0bd00593          	li	a1,189
ffffffffc020303a:	00003517          	auipc	a0,0x3
ffffffffc020303e:	1fe50513          	addi	a0,a0,510 # ffffffffc0206238 <default_pmm_manager+0x6c0>
ffffffffc0203042:	c04fd0ef          	jal	ra,ffffffffc0200446 <__panic>
ffffffffc0203046:	bc9ff0ef          	jal	ra,ffffffffc0202c0e <pa2page.part.0>
ffffffffc020304a:	00003617          	auipc	a2,0x3
ffffffffc020304e:	c3660613          	addi	a2,a2,-970 # ffffffffc0205c80 <default_pmm_manager+0x108>
ffffffffc0203052:	06200593          	li	a1,98
ffffffffc0203056:	00003517          	auipc	a0,0x3
ffffffffc020305a:	b8250513          	addi	a0,a0,-1150 # ffffffffc0205bd8 <default_pmm_manager+0x60>
ffffffffc020305e:	be8fd0ef          	jal	ra,ffffffffc0200446 <__panic>
ffffffffc0203062:	00003697          	auipc	a3,0x3
ffffffffc0203066:	3c668693          	addi	a3,a3,966 # ffffffffc0206428 <default_pmm_manager+0x8b0>
ffffffffc020306a:	00002617          	auipc	a2,0x2
ffffffffc020306e:	75e60613          	addi	a2,a2,1886 # ffffffffc02057c8 <commands+0x738>
ffffffffc0203072:	0fd00593          	li	a1,253
ffffffffc0203076:	00003517          	auipc	a0,0x3
ffffffffc020307a:	1c250513          	addi	a0,a0,450 # ffffffffc0206238 <default_pmm_manager+0x6c0>
ffffffffc020307e:	bc8fd0ef          	jal	ra,ffffffffc0200446 <__panic>
ffffffffc0203082:	00003697          	auipc	a3,0x3
ffffffffc0203086:	2c668693          	addi	a3,a3,710 # ffffffffc0206348 <default_pmm_manager+0x7d0>
ffffffffc020308a:	00002617          	auipc	a2,0x2
ffffffffc020308e:	73e60613          	addi	a2,a2,1854 # ffffffffc02057c8 <commands+0x738>
ffffffffc0203092:	0dd00593          	li	a1,221
ffffffffc0203096:	00003517          	auipc	a0,0x3
ffffffffc020309a:	1a250513          	addi	a0,a0,418 # ffffffffc0206238 <default_pmm_manager+0x6c0>
ffffffffc020309e:	ba8fd0ef          	jal	ra,ffffffffc0200446 <__panic>
ffffffffc02030a2:	00003617          	auipc	a2,0x3
ffffffffc02030a6:	17660613          	addi	a2,a2,374 # ffffffffc0206218 <default_pmm_manager+0x6a0>
ffffffffc02030aa:	02a00593          	li	a1,42
ffffffffc02030ae:	00003517          	auipc	a0,0x3
ffffffffc02030b2:	18a50513          	addi	a0,a0,394 # ffffffffc0206238 <default_pmm_manager+0x6c0>
ffffffffc02030b6:	b90fd0ef          	jal	ra,ffffffffc0200446 <__panic>
ffffffffc02030ba:	00003697          	auipc	a3,0x3
ffffffffc02030be:	35668693          	addi	a3,a3,854 # ffffffffc0206410 <default_pmm_manager+0x898>
ffffffffc02030c2:	00002617          	auipc	a2,0x2
ffffffffc02030c6:	70660613          	addi	a2,a2,1798 # ffffffffc02057c8 <commands+0x738>
ffffffffc02030ca:	0fc00593          	li	a1,252
ffffffffc02030ce:	00003517          	auipc	a0,0x3
ffffffffc02030d2:	16a50513          	addi	a0,a0,362 # ffffffffc0206238 <default_pmm_manager+0x6c0>
ffffffffc02030d6:	b70fd0ef          	jal	ra,ffffffffc0200446 <__panic>
ffffffffc02030da:	00003617          	auipc	a2,0x3
ffffffffc02030de:	bc660613          	addi	a2,a2,-1082 # ffffffffc0205ca0 <default_pmm_manager+0x128>
ffffffffc02030e2:	07400593          	li	a1,116
ffffffffc02030e6:	00003517          	auipc	a0,0x3
ffffffffc02030ea:	af250513          	addi	a0,a0,-1294 # ffffffffc0205bd8 <default_pmm_manager+0x60>
ffffffffc02030ee:	b58fd0ef          	jal	ra,ffffffffc0200446 <__panic>
ffffffffc02030f2:	00003697          	auipc	a3,0x3
ffffffffc02030f6:	26e68693          	addi	a3,a3,622 # ffffffffc0206360 <default_pmm_manager+0x7e8>
ffffffffc02030fa:	00002617          	auipc	a2,0x2
ffffffffc02030fe:	6ce60613          	addi	a2,a2,1742 # ffffffffc02057c8 <commands+0x738>
ffffffffc0203102:	0de00593          	li	a1,222
ffffffffc0203106:	00003517          	auipc	a0,0x3
ffffffffc020310a:	13250513          	addi	a0,a0,306 # ffffffffc0206238 <default_pmm_manager+0x6c0>
ffffffffc020310e:	b38fd0ef          	jal	ra,ffffffffc0200446 <__panic>
ffffffffc0203112:	00003697          	auipc	a3,0x3
ffffffffc0203116:	18668693          	addi	a3,a3,390 # ffffffffc0206298 <default_pmm_manager+0x720>
ffffffffc020311a:	00002617          	auipc	a2,0x2
ffffffffc020311e:	6ae60613          	addi	a2,a2,1710 # ffffffffc02057c8 <commands+0x738>
ffffffffc0203122:	0c800593          	li	a1,200
ffffffffc0203126:	00003517          	auipc	a0,0x3
ffffffffc020312a:	11250513          	addi	a0,a0,274 # ffffffffc0206238 <default_pmm_manager+0x6c0>
ffffffffc020312e:	b18fd0ef          	jal	ra,ffffffffc0200446 <__panic>
ffffffffc0203132:	00002697          	auipc	a3,0x2
ffffffffc0203136:	6c668693          	addi	a3,a3,1734 # ffffffffc02057f8 <commands+0x768>
ffffffffc020313a:	00002617          	auipc	a2,0x2
ffffffffc020313e:	68e60613          	addi	a2,a2,1678 # ffffffffc02057c8 <commands+0x738>
ffffffffc0203142:	0c000593          	li	a1,192
ffffffffc0203146:	00003517          	auipc	a0,0x3
ffffffffc020314a:	0f250513          	addi	a0,a0,242 # ffffffffc0206238 <default_pmm_manager+0x6c0>
ffffffffc020314e:	af8fd0ef          	jal	ra,ffffffffc0200446 <__panic>
ffffffffc0203152:	00003697          	auipc	a3,0x3
ffffffffc0203156:	84e68693          	addi	a3,a3,-1970 # ffffffffc02059a0 <commands+0x910>
ffffffffc020315a:	00002617          	auipc	a2,0x2
ffffffffc020315e:	66e60613          	addi	a2,a2,1646 # ffffffffc02057c8 <commands+0x738>
ffffffffc0203162:	0f400593          	li	a1,244
ffffffffc0203166:	00003517          	auipc	a0,0x3
ffffffffc020316a:	0d250513          	addi	a0,a0,210 # ffffffffc0206238 <default_pmm_manager+0x6c0>
ffffffffc020316e:	ad8fd0ef          	jal	ra,ffffffffc0200446 <__panic>
ffffffffc0203172:	00003697          	auipc	a3,0x3
ffffffffc0203176:	13e68693          	addi	a3,a3,318 # ffffffffc02062b0 <default_pmm_manager+0x738>
ffffffffc020317a:	00002617          	auipc	a2,0x2
ffffffffc020317e:	64e60613          	addi	a2,a2,1614 # ffffffffc02057c8 <commands+0x738>
ffffffffc0203182:	0cd00593          	li	a1,205
ffffffffc0203186:	00003517          	auipc	a0,0x3
ffffffffc020318a:	0b250513          	addi	a0,a0,178 # ffffffffc0206238 <default_pmm_manager+0x6c0>
ffffffffc020318e:	ab8fd0ef          	jal	ra,ffffffffc0200446 <__panic>
ffffffffc0203192:	00003697          	auipc	a3,0x3
ffffffffc0203196:	0f668693          	addi	a3,a3,246 # ffffffffc0206288 <default_pmm_manager+0x710>
ffffffffc020319a:	00002617          	auipc	a2,0x2
ffffffffc020319e:	62e60613          	addi	a2,a2,1582 # ffffffffc02057c8 <commands+0x738>
ffffffffc02031a2:	0c500593          	li	a1,197
ffffffffc02031a6:	00003517          	auipc	a0,0x3
ffffffffc02031aa:	09250513          	addi	a0,a0,146 # ffffffffc0206238 <default_pmm_manager+0x6c0>
ffffffffc02031ae:	a98fd0ef          	jal	ra,ffffffffc0200446 <__panic>
ffffffffc02031b2:	00003697          	auipc	a3,0x3
ffffffffc02031b6:	2de68693          	addi	a3,a3,734 # ffffffffc0206490 <default_pmm_manager+0x918>
ffffffffc02031ba:	00002617          	auipc	a2,0x2
ffffffffc02031be:	60e60613          	addi	a2,a2,1550 # ffffffffc02057c8 <commands+0x738>
ffffffffc02031c2:	11d00593          	li	a1,285
ffffffffc02031c6:	00003517          	auipc	a0,0x3
ffffffffc02031ca:	07250513          	addi	a0,a0,114 # ffffffffc0206238 <default_pmm_manager+0x6c0>
ffffffffc02031ce:	a78fd0ef          	jal	ra,ffffffffc0200446 <__panic>
ffffffffc02031d2:	00003617          	auipc	a2,0x3
ffffffffc02031d6:	9de60613          	addi	a2,a2,-1570 # ffffffffc0205bb0 <default_pmm_manager+0x38>
ffffffffc02031da:	06900593          	li	a1,105
ffffffffc02031de:	00003517          	auipc	a0,0x3
ffffffffc02031e2:	9fa50513          	addi	a0,a0,-1542 # ffffffffc0205bd8 <default_pmm_manager+0x60>
ffffffffc02031e6:	a60fd0ef          	jal	ra,ffffffffc0200446 <__panic>
ffffffffc02031ea:	00003697          	auipc	a3,0x3
ffffffffc02031ee:	29668693          	addi	a3,a3,662 # ffffffffc0206480 <default_pmm_manager+0x908>
ffffffffc02031f2:	00002617          	auipc	a2,0x2
ffffffffc02031f6:	5d660613          	addi	a2,a2,1494 # ffffffffc02057c8 <commands+0x738>
ffffffffc02031fa:	11c00593          	li	a1,284
ffffffffc02031fe:	00003517          	auipc	a0,0x3
ffffffffc0203202:	03a50513          	addi	a0,a0,58 # ffffffffc0206238 <default_pmm_manager+0x6c0>
ffffffffc0203206:	a40fd0ef          	jal	ra,ffffffffc0200446 <__panic>
ffffffffc020320a:	00003697          	auipc	a3,0x3
ffffffffc020320e:	1c668693          	addi	a3,a3,454 # ffffffffc02063d0 <default_pmm_manager+0x858>
ffffffffc0203212:	00002617          	auipc	a2,0x2
ffffffffc0203216:	5b660613          	addi	a2,a2,1462 # ffffffffc02057c8 <commands+0x738>
ffffffffc020321a:	09600593          	li	a1,150
ffffffffc020321e:	00003517          	auipc	a0,0x3
ffffffffc0203222:	01a50513          	addi	a0,a0,26 # ffffffffc0206238 <default_pmm_manager+0x6c0>
ffffffffc0203226:	a20fd0ef          	jal	ra,ffffffffc0200446 <__panic>
ffffffffc020322a:	00003697          	auipc	a3,0x3
ffffffffc020322e:	15668693          	addi	a3,a3,342 # ffffffffc0206380 <default_pmm_manager+0x808>
ffffffffc0203232:	00002617          	auipc	a2,0x2
ffffffffc0203236:	59660613          	addi	a2,a2,1430 # ffffffffc02057c8 <commands+0x738>
ffffffffc020323a:	0eb00593          	li	a1,235
ffffffffc020323e:	00003517          	auipc	a0,0x3
ffffffffc0203242:	ffa50513          	addi	a0,a0,-6 # ffffffffc0206238 <default_pmm_manager+0x6c0>
ffffffffc0203246:	a00fd0ef          	jal	ra,ffffffffc0200446 <__panic>
ffffffffc020324a:	00003697          	auipc	a3,0x3
ffffffffc020324e:	0be68693          	addi	a3,a3,190 # ffffffffc0206308 <default_pmm_manager+0x790>
ffffffffc0203252:	00002617          	auipc	a2,0x2
ffffffffc0203256:	57660613          	addi	a2,a2,1398 # ffffffffc02057c8 <commands+0x738>
ffffffffc020325a:	0d800593          	li	a1,216
ffffffffc020325e:	00003517          	auipc	a0,0x3
ffffffffc0203262:	fda50513          	addi	a0,a0,-38 # ffffffffc0206238 <default_pmm_manager+0x6c0>
ffffffffc0203266:	9e0fd0ef          	jal	ra,ffffffffc0200446 <__panic>
ffffffffc020326a:	00003697          	auipc	a3,0x3
ffffffffc020326e:	20e68693          	addi	a3,a3,526 # ffffffffc0206478 <default_pmm_manager+0x900>
ffffffffc0203272:	00002617          	auipc	a2,0x2
ffffffffc0203276:	55660613          	addi	a2,a2,1366 # ffffffffc02057c8 <commands+0x738>
ffffffffc020327a:	10300593          	li	a1,259
ffffffffc020327e:	00003517          	auipc	a0,0x3
ffffffffc0203282:	fba50513          	addi	a0,a0,-70 # ffffffffc0206238 <default_pmm_manager+0x6c0>
ffffffffc0203286:	9c0fd0ef          	jal	ra,ffffffffc0200446 <__panic>
ffffffffc020328a:	00003697          	auipc	a3,0x3
ffffffffc020328e:	03668693          	addi	a3,a3,54 # ffffffffc02062c0 <default_pmm_manager+0x748>
ffffffffc0203292:	00002617          	auipc	a2,0x2
ffffffffc0203296:	53660613          	addi	a2,a2,1334 # ffffffffc02057c8 <commands+0x738>
ffffffffc020329a:	0d000593          	li	a1,208
ffffffffc020329e:	00003517          	auipc	a0,0x3
ffffffffc02032a2:	f9a50513          	addi	a0,a0,-102 # ffffffffc0206238 <default_pmm_manager+0x6c0>
ffffffffc02032a6:	9a0fd0ef          	jal	ra,ffffffffc0200446 <__panic>
ffffffffc02032aa:	00003697          	auipc	a3,0x3
ffffffffc02032ae:	15668693          	addi	a3,a3,342 # ffffffffc0206400 <default_pmm_manager+0x888>
ffffffffc02032b2:	00002617          	auipc	a2,0x2
ffffffffc02032b6:	51660613          	addi	a2,a2,1302 # ffffffffc02057c8 <commands+0x738>
ffffffffc02032ba:	0a000593          	li	a1,160
ffffffffc02032be:	00003517          	auipc	a0,0x3
ffffffffc02032c2:	f7a50513          	addi	a0,a0,-134 # ffffffffc0206238 <default_pmm_manager+0x6c0>
ffffffffc02032c6:	980fd0ef          	jal	ra,ffffffffc0200446 <__panic>
ffffffffc02032ca:	00003697          	auipc	a3,0x3
ffffffffc02032ce:	13668693          	addi	a3,a3,310 # ffffffffc0206400 <default_pmm_manager+0x888>
ffffffffc02032d2:	00002617          	auipc	a2,0x2
ffffffffc02032d6:	4f660613          	addi	a2,a2,1270 # ffffffffc02057c8 <commands+0x738>
ffffffffc02032da:	0a200593          	li	a1,162
ffffffffc02032de:	00003517          	auipc	a0,0x3
ffffffffc02032e2:	f5a50513          	addi	a0,a0,-166 # ffffffffc0206238 <default_pmm_manager+0x6c0>
ffffffffc02032e6:	960fd0ef          	jal	ra,ffffffffc0200446 <__panic>
ffffffffc02032ea:	00003697          	auipc	a3,0x3
ffffffffc02032ee:	0f668693          	addi	a3,a3,246 # ffffffffc02063e0 <default_pmm_manager+0x868>
ffffffffc02032f2:	00002617          	auipc	a2,0x2
ffffffffc02032f6:	4d660613          	addi	a2,a2,1238 # ffffffffc02057c8 <commands+0x738>
ffffffffc02032fa:	09800593          	li	a1,152
ffffffffc02032fe:	00003517          	auipc	a0,0x3
ffffffffc0203302:	f3a50513          	addi	a0,a0,-198 # ffffffffc0206238 <default_pmm_manager+0x6c0>
ffffffffc0203306:	940fd0ef          	jal	ra,ffffffffc0200446 <__panic>
ffffffffc020330a:	00003697          	auipc	a3,0x3
ffffffffc020330e:	0d668693          	addi	a3,a3,214 # ffffffffc02063e0 <default_pmm_manager+0x868>
ffffffffc0203312:	00002617          	auipc	a2,0x2
ffffffffc0203316:	4b660613          	addi	a2,a2,1206 # ffffffffc02057c8 <commands+0x738>
ffffffffc020331a:	09a00593          	li	a1,154
ffffffffc020331e:	00003517          	auipc	a0,0x3
ffffffffc0203322:	f1a50513          	addi	a0,a0,-230 # ffffffffc0206238 <default_pmm_manager+0x6c0>
ffffffffc0203326:	920fd0ef          	jal	ra,ffffffffc0200446 <__panic>
ffffffffc020332a:	00003697          	auipc	a3,0x3
ffffffffc020332e:	0c668693          	addi	a3,a3,198 # ffffffffc02063f0 <default_pmm_manager+0x878>
ffffffffc0203332:	00002617          	auipc	a2,0x2
ffffffffc0203336:	49660613          	addi	a2,a2,1174 # ffffffffc02057c8 <commands+0x738>
ffffffffc020333a:	09c00593          	li	a1,156
ffffffffc020333e:	00003517          	auipc	a0,0x3
ffffffffc0203342:	efa50513          	addi	a0,a0,-262 # ffffffffc0206238 <default_pmm_manager+0x6c0>
ffffffffc0203346:	900fd0ef          	jal	ra,ffffffffc0200446 <__panic>
ffffffffc020334a:	00003697          	auipc	a3,0x3
ffffffffc020334e:	0a668693          	addi	a3,a3,166 # ffffffffc02063f0 <default_pmm_manager+0x878>
ffffffffc0203352:	00002617          	auipc	a2,0x2
ffffffffc0203356:	47660613          	addi	a2,a2,1142 # ffffffffc02057c8 <commands+0x738>
ffffffffc020335a:	09e00593          	li	a1,158
ffffffffc020335e:	00003517          	auipc	a0,0x3
ffffffffc0203362:	eda50513          	addi	a0,a0,-294 # ffffffffc0206238 <default_pmm_manager+0x6c0>
ffffffffc0203366:	8e0fd0ef          	jal	ra,ffffffffc0200446 <__panic>
ffffffffc020336a:	00003697          	auipc	a3,0x3
ffffffffc020336e:	06668693          	addi	a3,a3,102 # ffffffffc02063d0 <default_pmm_manager+0x858>
ffffffffc0203372:	00002617          	auipc	a2,0x2
ffffffffc0203376:	45660613          	addi	a2,a2,1110 # ffffffffc02057c8 <commands+0x738>
ffffffffc020337a:	09400593          	li	a1,148
ffffffffc020337e:	00003517          	auipc	a0,0x3
ffffffffc0203382:	eba50513          	addi	a0,a0,-326 # ffffffffc0206238 <default_pmm_manager+0x6c0>
ffffffffc0203386:	8c0fd0ef          	jal	ra,ffffffffc0200446 <__panic>

ffffffffc020338a <swap_init_mm>:
ffffffffc020338a:	00012797          	auipc	a5,0x12
ffffffffc020338e:	2067b783          	ld	a5,518(a5) # ffffffffc0215590 <sm>
ffffffffc0203392:	6b9c                	ld	a5,16(a5)
ffffffffc0203394:	8782                	jr	a5

ffffffffc0203396 <swap_map_swappable>:
ffffffffc0203396:	00012797          	auipc	a5,0x12
ffffffffc020339a:	1fa7b783          	ld	a5,506(a5) # ffffffffc0215590 <sm>
ffffffffc020339e:	739c                	ld	a5,32(a5)
ffffffffc02033a0:	8782                	jr	a5

ffffffffc02033a2 <swap_out>:
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
ffffffffc02033b8:	cde9                	beqz	a1,ffffffffc0203492 <swap_out+0xf0>
ffffffffc02033ba:	8a2e                	mv	s4,a1
ffffffffc02033bc:	892a                	mv	s2,a0
ffffffffc02033be:	8ab2                	mv	s5,a2
ffffffffc02033c0:	4401                	li	s0,0
ffffffffc02033c2:	00012997          	auipc	s3,0x12
ffffffffc02033c6:	1ce98993          	addi	s3,s3,462 # ffffffffc0215590 <sm>
ffffffffc02033ca:	00003b17          	auipc	s6,0x3
ffffffffc02033ce:	156b0b13          	addi	s6,s6,342 # ffffffffc0206520 <default_pmm_manager+0x9a8>
ffffffffc02033d2:	00003b97          	auipc	s7,0x3
ffffffffc02033d6:	136b8b93          	addi	s7,s7,310 # ffffffffc0206508 <default_pmm_manager+0x990>
ffffffffc02033da:	a825                	j	ffffffffc0203412 <swap_out+0x70>
ffffffffc02033dc:	67a2                	ld	a5,8(sp)
ffffffffc02033de:	8626                	mv	a2,s1
ffffffffc02033e0:	85a2                	mv	a1,s0
ffffffffc02033e2:	63b4                	ld	a3,64(a5)
ffffffffc02033e4:	855a                	mv	a0,s6
ffffffffc02033e6:	2405                	addiw	s0,s0,1
ffffffffc02033e8:	82b1                	srli	a3,a3,0xc
ffffffffc02033ea:	0685                	addi	a3,a3,1
ffffffffc02033ec:	d95fc0ef          	jal	ra,ffffffffc0200180 <cprintf>
ffffffffc02033f0:	6522                	ld	a0,8(sp)
ffffffffc02033f2:	4585                	li	a1,1
ffffffffc02033f4:	613c                	ld	a5,64(a0)
ffffffffc02033f6:	83b1                	srli	a5,a5,0xc
ffffffffc02033f8:	0785                	addi	a5,a5,1
ffffffffc02033fa:	07a2                	slli	a5,a5,0x8
ffffffffc02033fc:	00fc3023          	sd	a5,0(s8)
ffffffffc0203400:	ed6fe0ef          	jal	ra,ffffffffc0201ad6 <free_pages>
ffffffffc0203404:	01893503          	ld	a0,24(s2)
ffffffffc0203408:	85a6                	mv	a1,s1
ffffffffc020340a:	f46ff0ef          	jal	ra,ffffffffc0202b50 <tlb_invalidate>
ffffffffc020340e:	048a0d63          	beq	s4,s0,ffffffffc0203468 <swap_out+0xc6>
ffffffffc0203412:	0009b783          	ld	a5,0(s3)
ffffffffc0203416:	8656                	mv	a2,s5
ffffffffc0203418:	002c                	addi	a1,sp,8
ffffffffc020341a:	7b9c                	ld	a5,48(a5)
ffffffffc020341c:	854a                	mv	a0,s2
ffffffffc020341e:	9782                	jalr	a5
ffffffffc0203420:	e12d                	bnez	a0,ffffffffc0203482 <swap_out+0xe0>
ffffffffc0203422:	67a2                	ld	a5,8(sp)
ffffffffc0203424:	01893503          	ld	a0,24(s2)
ffffffffc0203428:	4601                	li	a2,0
ffffffffc020342a:	63a4                	ld	s1,64(a5)
ffffffffc020342c:	85a6                	mv	a1,s1
ffffffffc020342e:	f22fe0ef          	jal	ra,ffffffffc0201b50 <get_pte>
ffffffffc0203432:	611c                	ld	a5,0(a0)
ffffffffc0203434:	8c2a                	mv	s8,a0
ffffffffc0203436:	8b85                	andi	a5,a5,1
ffffffffc0203438:	cfb9                	beqz	a5,ffffffffc0203496 <swap_out+0xf4>
ffffffffc020343a:	65a2                	ld	a1,8(sp)
ffffffffc020343c:	61bc                	ld	a5,64(a1)
ffffffffc020343e:	83b1                	srli	a5,a5,0xc
ffffffffc0203440:	0785                	addi	a5,a5,1
ffffffffc0203442:	00879513          	slli	a0,a5,0x8
ffffffffc0203446:	51d000ef          	jal	ra,ffffffffc0204162 <swapfs_write>
ffffffffc020344a:	d949                	beqz	a0,ffffffffc02033dc <swap_out+0x3a>
ffffffffc020344c:	855e                	mv	a0,s7
ffffffffc020344e:	d33fc0ef          	jal	ra,ffffffffc0200180 <cprintf>
ffffffffc0203452:	0009b783          	ld	a5,0(s3)
ffffffffc0203456:	6622                	ld	a2,8(sp)
ffffffffc0203458:	4681                	li	a3,0
ffffffffc020345a:	739c                	ld	a5,32(a5)
ffffffffc020345c:	85a6                	mv	a1,s1
ffffffffc020345e:	854a                	mv	a0,s2
ffffffffc0203460:	2405                	addiw	s0,s0,1
ffffffffc0203462:	9782                	jalr	a5
ffffffffc0203464:	fa8a17e3          	bne	s4,s0,ffffffffc0203412 <swap_out+0x70>
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
ffffffffc0203482:	85a2                	mv	a1,s0
ffffffffc0203484:	00003517          	auipc	a0,0x3
ffffffffc0203488:	03c50513          	addi	a0,a0,60 # ffffffffc02064c0 <default_pmm_manager+0x948>
ffffffffc020348c:	cf5fc0ef          	jal	ra,ffffffffc0200180 <cprintf>
ffffffffc0203490:	bfe1                	j	ffffffffc0203468 <swap_out+0xc6>
ffffffffc0203492:	4401                	li	s0,0
ffffffffc0203494:	bfd1                	j	ffffffffc0203468 <swap_out+0xc6>
ffffffffc0203496:	00003697          	auipc	a3,0x3
ffffffffc020349a:	05a68693          	addi	a3,a3,90 # ffffffffc02064f0 <default_pmm_manager+0x978>
ffffffffc020349e:	00002617          	auipc	a2,0x2
ffffffffc02034a2:	32a60613          	addi	a2,a2,810 # ffffffffc02057c8 <commands+0x738>
ffffffffc02034a6:	06900593          	li	a1,105
ffffffffc02034aa:	00003517          	auipc	a0,0x3
ffffffffc02034ae:	d8e50513          	addi	a0,a0,-626 # ffffffffc0206238 <default_pmm_manager+0x6c0>
ffffffffc02034b2:	f95fc0ef          	jal	ra,ffffffffc0200446 <__panic>

ffffffffc02034b6 <_fifo_init_mm>:
ffffffffc02034b6:	0000e797          	auipc	a5,0xe
ffffffffc02034ba:	05278793          	addi	a5,a5,82 # ffffffffc0211508 <pra_list_head>
ffffffffc02034be:	f51c                	sd	a5,40(a0)
ffffffffc02034c0:	e79c                	sd	a5,8(a5)
ffffffffc02034c2:	e39c                	sd	a5,0(a5)
ffffffffc02034c4:	4501                	li	a0,0
ffffffffc02034c6:	8082                	ret

ffffffffc02034c8 <_fifo_init>:
ffffffffc02034c8:	4501                	li	a0,0
ffffffffc02034ca:	8082                	ret

ffffffffc02034cc <_fifo_set_unswappable>:
ffffffffc02034cc:	4501                	li	a0,0
ffffffffc02034ce:	8082                	ret

ffffffffc02034d0 <_fifo_tick_event>:
ffffffffc02034d0:	4501                	li	a0,0
ffffffffc02034d2:	8082                	ret

ffffffffc02034d4 <_fifo_check_swap>:
ffffffffc02034d4:	711d                	addi	sp,sp,-96
ffffffffc02034d6:	fc4e                	sd	s3,56(sp)
ffffffffc02034d8:	f852                	sd	s4,48(sp)
ffffffffc02034da:	00003517          	auipc	a0,0x3
ffffffffc02034de:	08650513          	addi	a0,a0,134 # ffffffffc0206560 <default_pmm_manager+0x9e8>
ffffffffc02034e2:	698d                	lui	s3,0x3
ffffffffc02034e4:	4a31                	li	s4,12
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
ffffffffc02034fa:	c87fc0ef          	jal	ra,ffffffffc0200180 <cprintf>
ffffffffc02034fe:	01498023          	sb	s4,0(s3) # 3000 <kern_entry-0xffffffffc01fd000>
ffffffffc0203502:	00012917          	auipc	s2,0x12
ffffffffc0203506:	0a692903          	lw	s2,166(s2) # ffffffffc02155a8 <pgfault_num>
ffffffffc020350a:	4791                	li	a5,4
ffffffffc020350c:	14f91e63          	bne	s2,a5,ffffffffc0203668 <_fifo_check_swap+0x194>
ffffffffc0203510:	00003517          	auipc	a0,0x3
ffffffffc0203514:	09050513          	addi	a0,a0,144 # ffffffffc02065a0 <default_pmm_manager+0xa28>
ffffffffc0203518:	6a85                	lui	s5,0x1
ffffffffc020351a:	4b29                	li	s6,10
ffffffffc020351c:	c65fc0ef          	jal	ra,ffffffffc0200180 <cprintf>
ffffffffc0203520:	00012417          	auipc	s0,0x12
ffffffffc0203524:	08840413          	addi	s0,s0,136 # ffffffffc02155a8 <pgfault_num>
ffffffffc0203528:	016a8023          	sb	s6,0(s5) # 1000 <kern_entry-0xffffffffc01ff000>
ffffffffc020352c:	4004                	lw	s1,0(s0)
ffffffffc020352e:	2481                	sext.w	s1,s1
ffffffffc0203530:	2b249c63          	bne	s1,s2,ffffffffc02037e8 <_fifo_check_swap+0x314>
ffffffffc0203534:	00003517          	auipc	a0,0x3
ffffffffc0203538:	09450513          	addi	a0,a0,148 # ffffffffc02065c8 <default_pmm_manager+0xa50>
ffffffffc020353c:	6b91                	lui	s7,0x4
ffffffffc020353e:	4c35                	li	s8,13
ffffffffc0203540:	c41fc0ef          	jal	ra,ffffffffc0200180 <cprintf>
ffffffffc0203544:	018b8023          	sb	s8,0(s7) # 4000 <kern_entry-0xffffffffc01fc000>
ffffffffc0203548:	00042903          	lw	s2,0(s0)
ffffffffc020354c:	2901                	sext.w	s2,s2
ffffffffc020354e:	26991d63          	bne	s2,s1,ffffffffc02037c8 <_fifo_check_swap+0x2f4>
ffffffffc0203552:	00003517          	auipc	a0,0x3
ffffffffc0203556:	09e50513          	addi	a0,a0,158 # ffffffffc02065f0 <default_pmm_manager+0xa78>
ffffffffc020355a:	6c89                	lui	s9,0x2
ffffffffc020355c:	4d2d                	li	s10,11
ffffffffc020355e:	c23fc0ef          	jal	ra,ffffffffc0200180 <cprintf>
ffffffffc0203562:	01ac8023          	sb	s10,0(s9) # 2000 <kern_entry-0xffffffffc01fe000>
ffffffffc0203566:	401c                	lw	a5,0(s0)
ffffffffc0203568:	2781                	sext.w	a5,a5
ffffffffc020356a:	23279f63          	bne	a5,s2,ffffffffc02037a8 <_fifo_check_swap+0x2d4>
ffffffffc020356e:	00003517          	auipc	a0,0x3
ffffffffc0203572:	0aa50513          	addi	a0,a0,170 # ffffffffc0206618 <default_pmm_manager+0xaa0>
ffffffffc0203576:	c0bfc0ef          	jal	ra,ffffffffc0200180 <cprintf>
ffffffffc020357a:	6795                	lui	a5,0x5
ffffffffc020357c:	4739                	li	a4,14
ffffffffc020357e:	00e78023          	sb	a4,0(a5) # 5000 <kern_entry-0xffffffffc01fb000>
ffffffffc0203582:	4004                	lw	s1,0(s0)
ffffffffc0203584:	4795                	li	a5,5
ffffffffc0203586:	2481                	sext.w	s1,s1
ffffffffc0203588:	20f49063          	bne	s1,a5,ffffffffc0203788 <_fifo_check_swap+0x2b4>
ffffffffc020358c:	00003517          	auipc	a0,0x3
ffffffffc0203590:	06450513          	addi	a0,a0,100 # ffffffffc02065f0 <default_pmm_manager+0xa78>
ffffffffc0203594:	bedfc0ef          	jal	ra,ffffffffc0200180 <cprintf>
ffffffffc0203598:	01ac8023          	sb	s10,0(s9)
ffffffffc020359c:	401c                	lw	a5,0(s0)
ffffffffc020359e:	2781                	sext.w	a5,a5
ffffffffc02035a0:	1c979463          	bne	a5,s1,ffffffffc0203768 <_fifo_check_swap+0x294>
ffffffffc02035a4:	00003517          	auipc	a0,0x3
ffffffffc02035a8:	ffc50513          	addi	a0,a0,-4 # ffffffffc02065a0 <default_pmm_manager+0xa28>
ffffffffc02035ac:	bd5fc0ef          	jal	ra,ffffffffc0200180 <cprintf>
ffffffffc02035b0:	016a8023          	sb	s6,0(s5)
ffffffffc02035b4:	401c                	lw	a5,0(s0)
ffffffffc02035b6:	4719                	li	a4,6
ffffffffc02035b8:	2781                	sext.w	a5,a5
ffffffffc02035ba:	18e79763          	bne	a5,a4,ffffffffc0203748 <_fifo_check_swap+0x274>
ffffffffc02035be:	00003517          	auipc	a0,0x3
ffffffffc02035c2:	03250513          	addi	a0,a0,50 # ffffffffc02065f0 <default_pmm_manager+0xa78>
ffffffffc02035c6:	bbbfc0ef          	jal	ra,ffffffffc0200180 <cprintf>
ffffffffc02035ca:	01ac8023          	sb	s10,0(s9)
ffffffffc02035ce:	401c                	lw	a5,0(s0)
ffffffffc02035d0:	471d                	li	a4,7
ffffffffc02035d2:	2781                	sext.w	a5,a5
ffffffffc02035d4:	14e79a63          	bne	a5,a4,ffffffffc0203728 <_fifo_check_swap+0x254>
ffffffffc02035d8:	00003517          	auipc	a0,0x3
ffffffffc02035dc:	f8850513          	addi	a0,a0,-120 # ffffffffc0206560 <default_pmm_manager+0x9e8>
ffffffffc02035e0:	ba1fc0ef          	jal	ra,ffffffffc0200180 <cprintf>
ffffffffc02035e4:	01498023          	sb	s4,0(s3)
ffffffffc02035e8:	401c                	lw	a5,0(s0)
ffffffffc02035ea:	4721                	li	a4,8
ffffffffc02035ec:	2781                	sext.w	a5,a5
ffffffffc02035ee:	10e79d63          	bne	a5,a4,ffffffffc0203708 <_fifo_check_swap+0x234>
ffffffffc02035f2:	00003517          	auipc	a0,0x3
ffffffffc02035f6:	fd650513          	addi	a0,a0,-42 # ffffffffc02065c8 <default_pmm_manager+0xa50>
ffffffffc02035fa:	b87fc0ef          	jal	ra,ffffffffc0200180 <cprintf>
ffffffffc02035fe:	018b8023          	sb	s8,0(s7)
ffffffffc0203602:	401c                	lw	a5,0(s0)
ffffffffc0203604:	4725                	li	a4,9
ffffffffc0203606:	2781                	sext.w	a5,a5
ffffffffc0203608:	0ee79063          	bne	a5,a4,ffffffffc02036e8 <_fifo_check_swap+0x214>
ffffffffc020360c:	00003517          	auipc	a0,0x3
ffffffffc0203610:	00c50513          	addi	a0,a0,12 # ffffffffc0206618 <default_pmm_manager+0xaa0>
ffffffffc0203614:	b6dfc0ef          	jal	ra,ffffffffc0200180 <cprintf>
ffffffffc0203618:	6795                	lui	a5,0x5
ffffffffc020361a:	4739                	li	a4,14
ffffffffc020361c:	00e78023          	sb	a4,0(a5) # 5000 <kern_entry-0xffffffffc01fb000>
ffffffffc0203620:	4004                	lw	s1,0(s0)
ffffffffc0203622:	47a9                	li	a5,10
ffffffffc0203624:	2481                	sext.w	s1,s1
ffffffffc0203626:	0af49163          	bne	s1,a5,ffffffffc02036c8 <_fifo_check_swap+0x1f4>
ffffffffc020362a:	00003517          	auipc	a0,0x3
ffffffffc020362e:	f7650513          	addi	a0,a0,-138 # ffffffffc02065a0 <default_pmm_manager+0xa28>
ffffffffc0203632:	b4ffc0ef          	jal	ra,ffffffffc0200180 <cprintf>
ffffffffc0203636:	6785                	lui	a5,0x1
ffffffffc0203638:	0007c783          	lbu	a5,0(a5) # 1000 <kern_entry-0xffffffffc01ff000>
ffffffffc020363c:	06979663          	bne	a5,s1,ffffffffc02036a8 <_fifo_check_swap+0x1d4>
ffffffffc0203640:	401c                	lw	a5,0(s0)
ffffffffc0203642:	472d                	li	a4,11
ffffffffc0203644:	2781                	sext.w	a5,a5
ffffffffc0203646:	04e79163          	bne	a5,a4,ffffffffc0203688 <_fifo_check_swap+0x1b4>
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
ffffffffc0203668:	00003697          	auipc	a3,0x3
ffffffffc020366c:	d9868693          	addi	a3,a3,-616 # ffffffffc0206400 <default_pmm_manager+0x888>
ffffffffc0203670:	00002617          	auipc	a2,0x2
ffffffffc0203674:	15860613          	addi	a2,a2,344 # ffffffffc02057c8 <commands+0x738>
ffffffffc0203678:	05100593          	li	a1,81
ffffffffc020367c:	00003517          	auipc	a0,0x3
ffffffffc0203680:	f0c50513          	addi	a0,a0,-244 # ffffffffc0206588 <default_pmm_manager+0xa10>
ffffffffc0203684:	dc3fc0ef          	jal	ra,ffffffffc0200446 <__panic>
ffffffffc0203688:	00003697          	auipc	a3,0x3
ffffffffc020368c:	04068693          	addi	a3,a3,64 # ffffffffc02066c8 <default_pmm_manager+0xb50>
ffffffffc0203690:	00002617          	auipc	a2,0x2
ffffffffc0203694:	13860613          	addi	a2,a2,312 # ffffffffc02057c8 <commands+0x738>
ffffffffc0203698:	07300593          	li	a1,115
ffffffffc020369c:	00003517          	auipc	a0,0x3
ffffffffc02036a0:	eec50513          	addi	a0,a0,-276 # ffffffffc0206588 <default_pmm_manager+0xa10>
ffffffffc02036a4:	da3fc0ef          	jal	ra,ffffffffc0200446 <__panic>
ffffffffc02036a8:	00003697          	auipc	a3,0x3
ffffffffc02036ac:	ff868693          	addi	a3,a3,-8 # ffffffffc02066a0 <default_pmm_manager+0xb28>
ffffffffc02036b0:	00002617          	auipc	a2,0x2
ffffffffc02036b4:	11860613          	addi	a2,a2,280 # ffffffffc02057c8 <commands+0x738>
ffffffffc02036b8:	07100593          	li	a1,113
ffffffffc02036bc:	00003517          	auipc	a0,0x3
ffffffffc02036c0:	ecc50513          	addi	a0,a0,-308 # ffffffffc0206588 <default_pmm_manager+0xa10>
ffffffffc02036c4:	d83fc0ef          	jal	ra,ffffffffc0200446 <__panic>
ffffffffc02036c8:	00003697          	auipc	a3,0x3
ffffffffc02036cc:	fc868693          	addi	a3,a3,-56 # ffffffffc0206690 <default_pmm_manager+0xb18>
ffffffffc02036d0:	00002617          	auipc	a2,0x2
ffffffffc02036d4:	0f860613          	addi	a2,a2,248 # ffffffffc02057c8 <commands+0x738>
ffffffffc02036d8:	06f00593          	li	a1,111
ffffffffc02036dc:	00003517          	auipc	a0,0x3
ffffffffc02036e0:	eac50513          	addi	a0,a0,-340 # ffffffffc0206588 <default_pmm_manager+0xa10>
ffffffffc02036e4:	d63fc0ef          	jal	ra,ffffffffc0200446 <__panic>
ffffffffc02036e8:	00003697          	auipc	a3,0x3
ffffffffc02036ec:	f9868693          	addi	a3,a3,-104 # ffffffffc0206680 <default_pmm_manager+0xb08>
ffffffffc02036f0:	00002617          	auipc	a2,0x2
ffffffffc02036f4:	0d860613          	addi	a2,a2,216 # ffffffffc02057c8 <commands+0x738>
ffffffffc02036f8:	06c00593          	li	a1,108
ffffffffc02036fc:	00003517          	auipc	a0,0x3
ffffffffc0203700:	e8c50513          	addi	a0,a0,-372 # ffffffffc0206588 <default_pmm_manager+0xa10>
ffffffffc0203704:	d43fc0ef          	jal	ra,ffffffffc0200446 <__panic>
ffffffffc0203708:	00003697          	auipc	a3,0x3
ffffffffc020370c:	f6868693          	addi	a3,a3,-152 # ffffffffc0206670 <default_pmm_manager+0xaf8>
ffffffffc0203710:	00002617          	auipc	a2,0x2
ffffffffc0203714:	0b860613          	addi	a2,a2,184 # ffffffffc02057c8 <commands+0x738>
ffffffffc0203718:	06900593          	li	a1,105
ffffffffc020371c:	00003517          	auipc	a0,0x3
ffffffffc0203720:	e6c50513          	addi	a0,a0,-404 # ffffffffc0206588 <default_pmm_manager+0xa10>
ffffffffc0203724:	d23fc0ef          	jal	ra,ffffffffc0200446 <__panic>
ffffffffc0203728:	00003697          	auipc	a3,0x3
ffffffffc020372c:	f3868693          	addi	a3,a3,-200 # ffffffffc0206660 <default_pmm_manager+0xae8>
ffffffffc0203730:	00002617          	auipc	a2,0x2
ffffffffc0203734:	09860613          	addi	a2,a2,152 # ffffffffc02057c8 <commands+0x738>
ffffffffc0203738:	06600593          	li	a1,102
ffffffffc020373c:	00003517          	auipc	a0,0x3
ffffffffc0203740:	e4c50513          	addi	a0,a0,-436 # ffffffffc0206588 <default_pmm_manager+0xa10>
ffffffffc0203744:	d03fc0ef          	jal	ra,ffffffffc0200446 <__panic>
ffffffffc0203748:	00003697          	auipc	a3,0x3
ffffffffc020374c:	f0868693          	addi	a3,a3,-248 # ffffffffc0206650 <default_pmm_manager+0xad8>
ffffffffc0203750:	00002617          	auipc	a2,0x2
ffffffffc0203754:	07860613          	addi	a2,a2,120 # ffffffffc02057c8 <commands+0x738>
ffffffffc0203758:	06300593          	li	a1,99
ffffffffc020375c:	00003517          	auipc	a0,0x3
ffffffffc0203760:	e2c50513          	addi	a0,a0,-468 # ffffffffc0206588 <default_pmm_manager+0xa10>
ffffffffc0203764:	ce3fc0ef          	jal	ra,ffffffffc0200446 <__panic>
ffffffffc0203768:	00003697          	auipc	a3,0x3
ffffffffc020376c:	ed868693          	addi	a3,a3,-296 # ffffffffc0206640 <default_pmm_manager+0xac8>
ffffffffc0203770:	00002617          	auipc	a2,0x2
ffffffffc0203774:	05860613          	addi	a2,a2,88 # ffffffffc02057c8 <commands+0x738>
ffffffffc0203778:	06000593          	li	a1,96
ffffffffc020377c:	00003517          	auipc	a0,0x3
ffffffffc0203780:	e0c50513          	addi	a0,a0,-500 # ffffffffc0206588 <default_pmm_manager+0xa10>
ffffffffc0203784:	cc3fc0ef          	jal	ra,ffffffffc0200446 <__panic>
ffffffffc0203788:	00003697          	auipc	a3,0x3
ffffffffc020378c:	eb868693          	addi	a3,a3,-328 # ffffffffc0206640 <default_pmm_manager+0xac8>
ffffffffc0203790:	00002617          	auipc	a2,0x2
ffffffffc0203794:	03860613          	addi	a2,a2,56 # ffffffffc02057c8 <commands+0x738>
ffffffffc0203798:	05d00593          	li	a1,93
ffffffffc020379c:	00003517          	auipc	a0,0x3
ffffffffc02037a0:	dec50513          	addi	a0,a0,-532 # ffffffffc0206588 <default_pmm_manager+0xa10>
ffffffffc02037a4:	ca3fc0ef          	jal	ra,ffffffffc0200446 <__panic>
ffffffffc02037a8:	00003697          	auipc	a3,0x3
ffffffffc02037ac:	c5868693          	addi	a3,a3,-936 # ffffffffc0206400 <default_pmm_manager+0x888>
ffffffffc02037b0:	00002617          	auipc	a2,0x2
ffffffffc02037b4:	01860613          	addi	a2,a2,24 # ffffffffc02057c8 <commands+0x738>
ffffffffc02037b8:	05a00593          	li	a1,90
ffffffffc02037bc:	00003517          	auipc	a0,0x3
ffffffffc02037c0:	dcc50513          	addi	a0,a0,-564 # ffffffffc0206588 <default_pmm_manager+0xa10>
ffffffffc02037c4:	c83fc0ef          	jal	ra,ffffffffc0200446 <__panic>
ffffffffc02037c8:	00003697          	auipc	a3,0x3
ffffffffc02037cc:	c3868693          	addi	a3,a3,-968 # ffffffffc0206400 <default_pmm_manager+0x888>
ffffffffc02037d0:	00002617          	auipc	a2,0x2
ffffffffc02037d4:	ff860613          	addi	a2,a2,-8 # ffffffffc02057c8 <commands+0x738>
ffffffffc02037d8:	05700593          	li	a1,87
ffffffffc02037dc:	00003517          	auipc	a0,0x3
ffffffffc02037e0:	dac50513          	addi	a0,a0,-596 # ffffffffc0206588 <default_pmm_manager+0xa10>
ffffffffc02037e4:	c63fc0ef          	jal	ra,ffffffffc0200446 <__panic>
ffffffffc02037e8:	00003697          	auipc	a3,0x3
ffffffffc02037ec:	c1868693          	addi	a3,a3,-1000 # ffffffffc0206400 <default_pmm_manager+0x888>
ffffffffc02037f0:	00002617          	auipc	a2,0x2
ffffffffc02037f4:	fd860613          	addi	a2,a2,-40 # ffffffffc02057c8 <commands+0x738>
ffffffffc02037f8:	05400593          	li	a1,84
ffffffffc02037fc:	00003517          	auipc	a0,0x3
ffffffffc0203800:	d8c50513          	addi	a0,a0,-628 # ffffffffc0206588 <default_pmm_manager+0xa10>
ffffffffc0203804:	c43fc0ef          	jal	ra,ffffffffc0200446 <__panic>

ffffffffc0203808 <_fifo_swap_out_victim>:
ffffffffc0203808:	751c                	ld	a5,40(a0)
ffffffffc020380a:	1141                	addi	sp,sp,-16
ffffffffc020380c:	e406                	sd	ra,8(sp)
ffffffffc020380e:	cf91                	beqz	a5,ffffffffc020382a <_fifo_swap_out_victim+0x22>
ffffffffc0203810:	ee0d                	bnez	a2,ffffffffc020384a <_fifo_swap_out_victim+0x42>
ffffffffc0203812:	679c                	ld	a5,8(a5)
ffffffffc0203814:	60a2                	ld	ra,8(sp)
ffffffffc0203816:	4501                	li	a0,0
ffffffffc0203818:	6394                	ld	a3,0(a5)
ffffffffc020381a:	6798                	ld	a4,8(a5)
ffffffffc020381c:	fd078793          	addi	a5,a5,-48
ffffffffc0203820:	e698                	sd	a4,8(a3)
ffffffffc0203822:	e314                	sd	a3,0(a4)
ffffffffc0203824:	e19c                	sd	a5,0(a1)
ffffffffc0203826:	0141                	addi	sp,sp,16
ffffffffc0203828:	8082                	ret
ffffffffc020382a:	00003697          	auipc	a3,0x3
ffffffffc020382e:	eae68693          	addi	a3,a3,-338 # ffffffffc02066d8 <default_pmm_manager+0xb60>
ffffffffc0203832:	00002617          	auipc	a2,0x2
ffffffffc0203836:	f9660613          	addi	a2,a2,-106 # ffffffffc02057c8 <commands+0x738>
ffffffffc020383a:	04100593          	li	a1,65
ffffffffc020383e:	00003517          	auipc	a0,0x3
ffffffffc0203842:	d4a50513          	addi	a0,a0,-694 # ffffffffc0206588 <default_pmm_manager+0xa10>
ffffffffc0203846:	c01fc0ef          	jal	ra,ffffffffc0200446 <__panic>
ffffffffc020384a:	00003697          	auipc	a3,0x3
ffffffffc020384e:	e9e68693          	addi	a3,a3,-354 # ffffffffc02066e8 <default_pmm_manager+0xb70>
ffffffffc0203852:	00002617          	auipc	a2,0x2
ffffffffc0203856:	f7660613          	addi	a2,a2,-138 # ffffffffc02057c8 <commands+0x738>
ffffffffc020385a:	04200593          	li	a1,66
ffffffffc020385e:	00003517          	auipc	a0,0x3
ffffffffc0203862:	d2a50513          	addi	a0,a0,-726 # ffffffffc0206588 <default_pmm_manager+0xa10>
ffffffffc0203866:	be1fc0ef          	jal	ra,ffffffffc0200446 <__panic>

ffffffffc020386a <_fifo_map_swappable>:
ffffffffc020386a:	751c                	ld	a5,40(a0)
ffffffffc020386c:	cb91                	beqz	a5,ffffffffc0203880 <_fifo_map_swappable+0x16>
ffffffffc020386e:	6394                	ld	a3,0(a5)
ffffffffc0203870:	03060713          	addi	a4,a2,48
ffffffffc0203874:	e398                	sd	a4,0(a5)
ffffffffc0203876:	e698                	sd	a4,8(a3)
ffffffffc0203878:	4501                	li	a0,0
ffffffffc020387a:	fe1c                	sd	a5,56(a2)
ffffffffc020387c:	fa14                	sd	a3,48(a2)
ffffffffc020387e:	8082                	ret
ffffffffc0203880:	1141                	addi	sp,sp,-16
ffffffffc0203882:	00003697          	auipc	a3,0x3
ffffffffc0203886:	e7668693          	addi	a3,a3,-394 # ffffffffc02066f8 <default_pmm_manager+0xb80>
ffffffffc020388a:	00002617          	auipc	a2,0x2
ffffffffc020388e:	f3e60613          	addi	a2,a2,-194 # ffffffffc02057c8 <commands+0x738>
ffffffffc0203892:	03200593          	li	a1,50
ffffffffc0203896:	00003517          	auipc	a0,0x3
ffffffffc020389a:	cf250513          	addi	a0,a0,-782 # ffffffffc0206588 <default_pmm_manager+0xa10>
ffffffffc020389e:	e406                	sd	ra,8(sp)
ffffffffc02038a0:	ba7fc0ef          	jal	ra,ffffffffc0200446 <__panic>

ffffffffc02038a4 <check_vma_overlap.part.0>:
ffffffffc02038a4:	1141                	addi	sp,sp,-16
ffffffffc02038a6:	00003697          	auipc	a3,0x3
ffffffffc02038aa:	e8a68693          	addi	a3,a3,-374 # ffffffffc0206730 <default_pmm_manager+0xbb8>
ffffffffc02038ae:	00002617          	auipc	a2,0x2
ffffffffc02038b2:	f1a60613          	addi	a2,a2,-230 # ffffffffc02057c8 <commands+0x738>
ffffffffc02038b6:	07e00593          	li	a1,126
ffffffffc02038ba:	00003517          	auipc	a0,0x3
ffffffffc02038be:	e9650513          	addi	a0,a0,-362 # ffffffffc0206750 <default_pmm_manager+0xbd8>
ffffffffc02038c2:	e406                	sd	ra,8(sp)
ffffffffc02038c4:	b83fc0ef          	jal	ra,ffffffffc0200446 <__panic>

ffffffffc02038c8 <mm_create>:
ffffffffc02038c8:	1141                	addi	sp,sp,-16
ffffffffc02038ca:	03000513          	li	a0,48
ffffffffc02038ce:	e022                	sd	s0,0(sp)
ffffffffc02038d0:	e406                	sd	ra,8(sp)
ffffffffc02038d2:	f8ffd0ef          	jal	ra,ffffffffc0201860 <kmalloc>
ffffffffc02038d6:	842a                	mv	s0,a0
ffffffffc02038d8:	c105                	beqz	a0,ffffffffc02038f8 <mm_create+0x30>
ffffffffc02038da:	e408                	sd	a0,8(s0)
ffffffffc02038dc:	e008                	sd	a0,0(s0)
ffffffffc02038de:	00053823          	sd	zero,16(a0)
ffffffffc02038e2:	00053c23          	sd	zero,24(a0)
ffffffffc02038e6:	02052023          	sw	zero,32(a0)
ffffffffc02038ea:	00012797          	auipc	a5,0x12
ffffffffc02038ee:	cae7a783          	lw	a5,-850(a5) # ffffffffc0215598 <swap_init_ok>
ffffffffc02038f2:	eb81                	bnez	a5,ffffffffc0203902 <mm_create+0x3a>
ffffffffc02038f4:	02053423          	sd	zero,40(a0)
ffffffffc02038f8:	60a2                	ld	ra,8(sp)
ffffffffc02038fa:	8522                	mv	a0,s0
ffffffffc02038fc:	6402                	ld	s0,0(sp)
ffffffffc02038fe:	0141                	addi	sp,sp,16
ffffffffc0203900:	8082                	ret
ffffffffc0203902:	a89ff0ef          	jal	ra,ffffffffc020338a <swap_init_mm>
ffffffffc0203906:	60a2                	ld	ra,8(sp)
ffffffffc0203908:	8522                	mv	a0,s0
ffffffffc020390a:	6402                	ld	s0,0(sp)
ffffffffc020390c:	0141                	addi	sp,sp,16
ffffffffc020390e:	8082                	ret

ffffffffc0203910 <vma_create>:
ffffffffc0203910:	1101                	addi	sp,sp,-32
ffffffffc0203912:	e04a                	sd	s2,0(sp)
ffffffffc0203914:	892a                	mv	s2,a0
ffffffffc0203916:	03000513          	li	a0,48
ffffffffc020391a:	e822                	sd	s0,16(sp)
ffffffffc020391c:	e426                	sd	s1,8(sp)
ffffffffc020391e:	ec06                	sd	ra,24(sp)
ffffffffc0203920:	84ae                	mv	s1,a1
ffffffffc0203922:	8432                	mv	s0,a2
ffffffffc0203924:	f3dfd0ef          	jal	ra,ffffffffc0201860 <kmalloc>
ffffffffc0203928:	c509                	beqz	a0,ffffffffc0203932 <vma_create+0x22>
ffffffffc020392a:	01253423          	sd	s2,8(a0)
ffffffffc020392e:	e904                	sd	s1,16(a0)
ffffffffc0203930:	cd00                	sw	s0,24(a0)
ffffffffc0203932:	60e2                	ld	ra,24(sp)
ffffffffc0203934:	6442                	ld	s0,16(sp)
ffffffffc0203936:	64a2                	ld	s1,8(sp)
ffffffffc0203938:	6902                	ld	s2,0(sp)
ffffffffc020393a:	6105                	addi	sp,sp,32
ffffffffc020393c:	8082                	ret

ffffffffc020393e <find_vma>:
ffffffffc020393e:	86aa                	mv	a3,a0
ffffffffc0203940:	c505                	beqz	a0,ffffffffc0203968 <find_vma+0x2a>
ffffffffc0203942:	6908                	ld	a0,16(a0)
ffffffffc0203944:	c501                	beqz	a0,ffffffffc020394c <find_vma+0xe>
ffffffffc0203946:	651c                	ld	a5,8(a0)
ffffffffc0203948:	02f5f263          	bgeu	a1,a5,ffffffffc020396c <find_vma+0x2e>
ffffffffc020394c:	669c                	ld	a5,8(a3)
ffffffffc020394e:	00f68d63          	beq	a3,a5,ffffffffc0203968 <find_vma+0x2a>
ffffffffc0203952:	fe87b703          	ld	a4,-24(a5)
ffffffffc0203956:	00e5e663          	bltu	a1,a4,ffffffffc0203962 <find_vma+0x24>
ffffffffc020395a:	ff07b703          	ld	a4,-16(a5)
ffffffffc020395e:	00e5ec63          	bltu	a1,a4,ffffffffc0203976 <find_vma+0x38>
ffffffffc0203962:	679c                	ld	a5,8(a5)
ffffffffc0203964:	fef697e3          	bne	a3,a5,ffffffffc0203952 <find_vma+0x14>
ffffffffc0203968:	4501                	li	a0,0
ffffffffc020396a:	8082                	ret
ffffffffc020396c:	691c                	ld	a5,16(a0)
ffffffffc020396e:	fcf5ffe3          	bgeu	a1,a5,ffffffffc020394c <find_vma+0xe>
ffffffffc0203972:	ea88                	sd	a0,16(a3)
ffffffffc0203974:	8082                	ret
ffffffffc0203976:	fe078513          	addi	a0,a5,-32
ffffffffc020397a:	ea88                	sd	a0,16(a3)
ffffffffc020397c:	8082                	ret

ffffffffc020397e <insert_vma_struct>:
ffffffffc020397e:	6590                	ld	a2,8(a1)
ffffffffc0203980:	0105b803          	ld	a6,16(a1) # 1010 <kern_entry-0xffffffffc01feff0>
ffffffffc0203984:	1141                	addi	sp,sp,-16
ffffffffc0203986:	e406                	sd	ra,8(sp)
ffffffffc0203988:	87aa                	mv	a5,a0
ffffffffc020398a:	01066763          	bltu	a2,a6,ffffffffc0203998 <insert_vma_struct+0x1a>
ffffffffc020398e:	a085                	j	ffffffffc02039ee <insert_vma_struct+0x70>
ffffffffc0203990:	fe87b703          	ld	a4,-24(a5)
ffffffffc0203994:	04e66863          	bltu	a2,a4,ffffffffc02039e4 <insert_vma_struct+0x66>
ffffffffc0203998:	86be                	mv	a3,a5
ffffffffc020399a:	679c                	ld	a5,8(a5)
ffffffffc020399c:	fef51ae3          	bne	a0,a5,ffffffffc0203990 <insert_vma_struct+0x12>
ffffffffc02039a0:	02a68463          	beq	a3,a0,ffffffffc02039c8 <insert_vma_struct+0x4a>
ffffffffc02039a4:	ff06b703          	ld	a4,-16(a3)
ffffffffc02039a8:	fe86b883          	ld	a7,-24(a3)
ffffffffc02039ac:	08e8f163          	bgeu	a7,a4,ffffffffc0203a2e <insert_vma_struct+0xb0>
ffffffffc02039b0:	04e66f63          	bltu	a2,a4,ffffffffc0203a0e <insert_vma_struct+0x90>
ffffffffc02039b4:	00f50a63          	beq	a0,a5,ffffffffc02039c8 <insert_vma_struct+0x4a>
ffffffffc02039b8:	fe87b703          	ld	a4,-24(a5)
ffffffffc02039bc:	05076963          	bltu	a4,a6,ffffffffc0203a0e <insert_vma_struct+0x90>
ffffffffc02039c0:	ff07b603          	ld	a2,-16(a5)
ffffffffc02039c4:	02c77363          	bgeu	a4,a2,ffffffffc02039ea <insert_vma_struct+0x6c>
ffffffffc02039c8:	5118                	lw	a4,32(a0)
ffffffffc02039ca:	e188                	sd	a0,0(a1)
ffffffffc02039cc:	02058613          	addi	a2,a1,32
ffffffffc02039d0:	e390                	sd	a2,0(a5)
ffffffffc02039d2:	e690                	sd	a2,8(a3)
ffffffffc02039d4:	60a2                	ld	ra,8(sp)
ffffffffc02039d6:	f59c                	sd	a5,40(a1)
ffffffffc02039d8:	f194                	sd	a3,32(a1)
ffffffffc02039da:	0017079b          	addiw	a5,a4,1
ffffffffc02039de:	d11c                	sw	a5,32(a0)
ffffffffc02039e0:	0141                	addi	sp,sp,16
ffffffffc02039e2:	8082                	ret
ffffffffc02039e4:	fca690e3          	bne	a3,a0,ffffffffc02039a4 <insert_vma_struct+0x26>
ffffffffc02039e8:	bfd1                	j	ffffffffc02039bc <insert_vma_struct+0x3e>
ffffffffc02039ea:	ebbff0ef          	jal	ra,ffffffffc02038a4 <check_vma_overlap.part.0>
ffffffffc02039ee:	00003697          	auipc	a3,0x3
ffffffffc02039f2:	d7268693          	addi	a3,a3,-654 # ffffffffc0206760 <default_pmm_manager+0xbe8>
ffffffffc02039f6:	00002617          	auipc	a2,0x2
ffffffffc02039fa:	dd260613          	addi	a2,a2,-558 # ffffffffc02057c8 <commands+0x738>
ffffffffc02039fe:	08500593          	li	a1,133
ffffffffc0203a02:	00003517          	auipc	a0,0x3
ffffffffc0203a06:	d4e50513          	addi	a0,a0,-690 # ffffffffc0206750 <default_pmm_manager+0xbd8>
ffffffffc0203a0a:	a3dfc0ef          	jal	ra,ffffffffc0200446 <__panic>
ffffffffc0203a0e:	00003697          	auipc	a3,0x3
ffffffffc0203a12:	d9268693          	addi	a3,a3,-622 # ffffffffc02067a0 <default_pmm_manager+0xc28>
ffffffffc0203a16:	00002617          	auipc	a2,0x2
ffffffffc0203a1a:	db260613          	addi	a2,a2,-590 # ffffffffc02057c8 <commands+0x738>
ffffffffc0203a1e:	07d00593          	li	a1,125
ffffffffc0203a22:	00003517          	auipc	a0,0x3
ffffffffc0203a26:	d2e50513          	addi	a0,a0,-722 # ffffffffc0206750 <default_pmm_manager+0xbd8>
ffffffffc0203a2a:	a1dfc0ef          	jal	ra,ffffffffc0200446 <__panic>
ffffffffc0203a2e:	00003697          	auipc	a3,0x3
ffffffffc0203a32:	d5268693          	addi	a3,a3,-686 # ffffffffc0206780 <default_pmm_manager+0xc08>
ffffffffc0203a36:	00002617          	auipc	a2,0x2
ffffffffc0203a3a:	d9260613          	addi	a2,a2,-622 # ffffffffc02057c8 <commands+0x738>
ffffffffc0203a3e:	07c00593          	li	a1,124
ffffffffc0203a42:	00003517          	auipc	a0,0x3
ffffffffc0203a46:	d0e50513          	addi	a0,a0,-754 # ffffffffc0206750 <default_pmm_manager+0xbd8>
ffffffffc0203a4a:	9fdfc0ef          	jal	ra,ffffffffc0200446 <__panic>

ffffffffc0203a4e <mm_destroy>:
ffffffffc0203a4e:	1141                	addi	sp,sp,-16
ffffffffc0203a50:	e022                	sd	s0,0(sp)
ffffffffc0203a52:	842a                	mv	s0,a0
ffffffffc0203a54:	6508                	ld	a0,8(a0)
ffffffffc0203a56:	e406                	sd	ra,8(sp)
ffffffffc0203a58:	00a40c63          	beq	s0,a0,ffffffffc0203a70 <mm_destroy+0x22>
ffffffffc0203a5c:	6118                	ld	a4,0(a0)
ffffffffc0203a5e:	651c                	ld	a5,8(a0)
ffffffffc0203a60:	1501                	addi	a0,a0,-32
ffffffffc0203a62:	e71c                	sd	a5,8(a4)
ffffffffc0203a64:	e398                	sd	a4,0(a5)
ffffffffc0203a66:	eabfd0ef          	jal	ra,ffffffffc0201910 <kfree>
ffffffffc0203a6a:	6408                	ld	a0,8(s0)
ffffffffc0203a6c:	fea418e3          	bne	s0,a0,ffffffffc0203a5c <mm_destroy+0xe>
ffffffffc0203a70:	8522                	mv	a0,s0
ffffffffc0203a72:	6402                	ld	s0,0(sp)
ffffffffc0203a74:	60a2                	ld	ra,8(sp)
ffffffffc0203a76:	0141                	addi	sp,sp,16
ffffffffc0203a78:	e99fd06f          	j	ffffffffc0201910 <kfree>

ffffffffc0203a7c <vmm_init>:
ffffffffc0203a7c:	7139                	addi	sp,sp,-64
ffffffffc0203a7e:	03000513          	li	a0,48
ffffffffc0203a82:	fc06                	sd	ra,56(sp)
ffffffffc0203a84:	f822                	sd	s0,48(sp)
ffffffffc0203a86:	f426                	sd	s1,40(sp)
ffffffffc0203a88:	f04a                	sd	s2,32(sp)
ffffffffc0203a8a:	ec4e                	sd	s3,24(sp)
ffffffffc0203a8c:	e852                	sd	s4,16(sp)
ffffffffc0203a8e:	e456                	sd	s5,8(sp)
ffffffffc0203a90:	dd1fd0ef          	jal	ra,ffffffffc0201860 <kmalloc>
ffffffffc0203a94:	5a050d63          	beqz	a0,ffffffffc020404e <vmm_init+0x5d2>
ffffffffc0203a98:	e508                	sd	a0,8(a0)
ffffffffc0203a9a:	e108                	sd	a0,0(a0)
ffffffffc0203a9c:	00053823          	sd	zero,16(a0)
ffffffffc0203aa0:	00053c23          	sd	zero,24(a0)
ffffffffc0203aa4:	02052023          	sw	zero,32(a0)
ffffffffc0203aa8:	00012797          	auipc	a5,0x12
ffffffffc0203aac:	af07a783          	lw	a5,-1296(a5) # ffffffffc0215598 <swap_init_ok>
ffffffffc0203ab0:	84aa                	mv	s1,a0
ffffffffc0203ab2:	e7b9                	bnez	a5,ffffffffc0203b00 <vmm_init+0x84>
ffffffffc0203ab4:	02053423          	sd	zero,40(a0)
ffffffffc0203ab8:	03200413          	li	s0,50
ffffffffc0203abc:	a811                	j	ffffffffc0203ad0 <vmm_init+0x54>
ffffffffc0203abe:	e500                	sd	s0,8(a0)
ffffffffc0203ac0:	e91c                	sd	a5,16(a0)
ffffffffc0203ac2:	00052c23          	sw	zero,24(a0)
ffffffffc0203ac6:	146d                	addi	s0,s0,-5
ffffffffc0203ac8:	8526                	mv	a0,s1
ffffffffc0203aca:	eb5ff0ef          	jal	ra,ffffffffc020397e <insert_vma_struct>
ffffffffc0203ace:	cc05                	beqz	s0,ffffffffc0203b06 <vmm_init+0x8a>
ffffffffc0203ad0:	03000513          	li	a0,48
ffffffffc0203ad4:	d8dfd0ef          	jal	ra,ffffffffc0201860 <kmalloc>
ffffffffc0203ad8:	85aa                	mv	a1,a0
ffffffffc0203ada:	00240793          	addi	a5,s0,2
ffffffffc0203ade:	f165                	bnez	a0,ffffffffc0203abe <vmm_init+0x42>
ffffffffc0203ae0:	00002697          	auipc	a3,0x2
ffffffffc0203ae4:	7e068693          	addi	a3,a3,2016 # ffffffffc02062c0 <default_pmm_manager+0x748>
ffffffffc0203ae8:	00002617          	auipc	a2,0x2
ffffffffc0203aec:	ce060613          	addi	a2,a2,-800 # ffffffffc02057c8 <commands+0x738>
ffffffffc0203af0:	0c900593          	li	a1,201
ffffffffc0203af4:	00003517          	auipc	a0,0x3
ffffffffc0203af8:	c5c50513          	addi	a0,a0,-932 # ffffffffc0206750 <default_pmm_manager+0xbd8>
ffffffffc0203afc:	94bfc0ef          	jal	ra,ffffffffc0200446 <__panic>
ffffffffc0203b00:	88bff0ef          	jal	ra,ffffffffc020338a <swap_init_mm>
ffffffffc0203b04:	bf55                	j	ffffffffc0203ab8 <vmm_init+0x3c>
ffffffffc0203b06:	03700413          	li	s0,55
ffffffffc0203b0a:	1f900913          	li	s2,505
ffffffffc0203b0e:	a819                	j	ffffffffc0203b24 <vmm_init+0xa8>
ffffffffc0203b10:	e500                	sd	s0,8(a0)
ffffffffc0203b12:	e91c                	sd	a5,16(a0)
ffffffffc0203b14:	00052c23          	sw	zero,24(a0)
ffffffffc0203b18:	0415                	addi	s0,s0,5
ffffffffc0203b1a:	8526                	mv	a0,s1
ffffffffc0203b1c:	e63ff0ef          	jal	ra,ffffffffc020397e <insert_vma_struct>
ffffffffc0203b20:	03240a63          	beq	s0,s2,ffffffffc0203b54 <vmm_init+0xd8>
ffffffffc0203b24:	03000513          	li	a0,48
ffffffffc0203b28:	d39fd0ef          	jal	ra,ffffffffc0201860 <kmalloc>
ffffffffc0203b2c:	85aa                	mv	a1,a0
ffffffffc0203b2e:	00240793          	addi	a5,s0,2
ffffffffc0203b32:	fd79                	bnez	a0,ffffffffc0203b10 <vmm_init+0x94>
ffffffffc0203b34:	00002697          	auipc	a3,0x2
ffffffffc0203b38:	78c68693          	addi	a3,a3,1932 # ffffffffc02062c0 <default_pmm_manager+0x748>
ffffffffc0203b3c:	00002617          	auipc	a2,0x2
ffffffffc0203b40:	c8c60613          	addi	a2,a2,-884 # ffffffffc02057c8 <commands+0x738>
ffffffffc0203b44:	0cf00593          	li	a1,207
ffffffffc0203b48:	00003517          	auipc	a0,0x3
ffffffffc0203b4c:	c0850513          	addi	a0,a0,-1016 # ffffffffc0206750 <default_pmm_manager+0xbd8>
ffffffffc0203b50:	8f7fc0ef          	jal	ra,ffffffffc0200446 <__panic>
ffffffffc0203b54:	649c                	ld	a5,8(s1)
ffffffffc0203b56:	471d                	li	a4,7
ffffffffc0203b58:	1fb00593          	li	a1,507
ffffffffc0203b5c:	32f48d63          	beq	s1,a5,ffffffffc0203e96 <vmm_init+0x41a>
ffffffffc0203b60:	fe87b683          	ld	a3,-24(a5)
ffffffffc0203b64:	ffe70613          	addi	a2,a4,-2
ffffffffc0203b68:	2cd61763          	bne	a2,a3,ffffffffc0203e36 <vmm_init+0x3ba>
ffffffffc0203b6c:	ff07b683          	ld	a3,-16(a5)
ffffffffc0203b70:	2ce69363          	bne	a3,a4,ffffffffc0203e36 <vmm_init+0x3ba>
ffffffffc0203b74:	0715                	addi	a4,a4,5
ffffffffc0203b76:	679c                	ld	a5,8(a5)
ffffffffc0203b78:	feb712e3          	bne	a4,a1,ffffffffc0203b5c <vmm_init+0xe0>
ffffffffc0203b7c:	4a1d                	li	s4,7
ffffffffc0203b7e:	4415                	li	s0,5
ffffffffc0203b80:	1f900a93          	li	s5,505
ffffffffc0203b84:	85a2                	mv	a1,s0
ffffffffc0203b86:	8526                	mv	a0,s1
ffffffffc0203b88:	db7ff0ef          	jal	ra,ffffffffc020393e <find_vma>
ffffffffc0203b8c:	892a                	mv	s2,a0
ffffffffc0203b8e:	36050463          	beqz	a0,ffffffffc0203ef6 <vmm_init+0x47a>
ffffffffc0203b92:	00140593          	addi	a1,s0,1
ffffffffc0203b96:	8526                	mv	a0,s1
ffffffffc0203b98:	da7ff0ef          	jal	ra,ffffffffc020393e <find_vma>
ffffffffc0203b9c:	89aa                	mv	s3,a0
ffffffffc0203b9e:	36050c63          	beqz	a0,ffffffffc0203f16 <vmm_init+0x49a>
ffffffffc0203ba2:	85d2                	mv	a1,s4
ffffffffc0203ba4:	8526                	mv	a0,s1
ffffffffc0203ba6:	d99ff0ef          	jal	ra,ffffffffc020393e <find_vma>
ffffffffc0203baa:	38051663          	bnez	a0,ffffffffc0203f36 <vmm_init+0x4ba>
ffffffffc0203bae:	00340593          	addi	a1,s0,3
ffffffffc0203bb2:	8526                	mv	a0,s1
ffffffffc0203bb4:	d8bff0ef          	jal	ra,ffffffffc020393e <find_vma>
ffffffffc0203bb8:	2e051f63          	bnez	a0,ffffffffc0203eb6 <vmm_init+0x43a>
ffffffffc0203bbc:	00440593          	addi	a1,s0,4
ffffffffc0203bc0:	8526                	mv	a0,s1
ffffffffc0203bc2:	d7dff0ef          	jal	ra,ffffffffc020393e <find_vma>
ffffffffc0203bc6:	30051863          	bnez	a0,ffffffffc0203ed6 <vmm_init+0x45a>
ffffffffc0203bca:	00893783          	ld	a5,8(s2)
ffffffffc0203bce:	28879463          	bne	a5,s0,ffffffffc0203e56 <vmm_init+0x3da>
ffffffffc0203bd2:	01093783          	ld	a5,16(s2)
ffffffffc0203bd6:	29479063          	bne	a5,s4,ffffffffc0203e56 <vmm_init+0x3da>
ffffffffc0203bda:	0089b783          	ld	a5,8(s3)
ffffffffc0203bde:	28879c63          	bne	a5,s0,ffffffffc0203e76 <vmm_init+0x3fa>
ffffffffc0203be2:	0109b783          	ld	a5,16(s3)
ffffffffc0203be6:	29479863          	bne	a5,s4,ffffffffc0203e76 <vmm_init+0x3fa>
ffffffffc0203bea:	0415                	addi	s0,s0,5
ffffffffc0203bec:	0a15                	addi	s4,s4,5
ffffffffc0203bee:	f9541be3          	bne	s0,s5,ffffffffc0203b84 <vmm_init+0x108>
ffffffffc0203bf2:	4411                	li	s0,4
ffffffffc0203bf4:	597d                	li	s2,-1
ffffffffc0203bf6:	85a2                	mv	a1,s0
ffffffffc0203bf8:	8526                	mv	a0,s1
ffffffffc0203bfa:	d45ff0ef          	jal	ra,ffffffffc020393e <find_vma>
ffffffffc0203bfe:	0004059b          	sext.w	a1,s0
ffffffffc0203c02:	c90d                	beqz	a0,ffffffffc0203c34 <vmm_init+0x1b8>
ffffffffc0203c04:	6914                	ld	a3,16(a0)
ffffffffc0203c06:	6510                	ld	a2,8(a0)
ffffffffc0203c08:	00003517          	auipc	a0,0x3
ffffffffc0203c0c:	cb850513          	addi	a0,a0,-840 # ffffffffc02068c0 <default_pmm_manager+0xd48>
ffffffffc0203c10:	d70fc0ef          	jal	ra,ffffffffc0200180 <cprintf>
ffffffffc0203c14:	00003697          	auipc	a3,0x3
ffffffffc0203c18:	cd468693          	addi	a3,a3,-812 # ffffffffc02068e8 <default_pmm_manager+0xd70>
ffffffffc0203c1c:	00002617          	auipc	a2,0x2
ffffffffc0203c20:	bac60613          	addi	a2,a2,-1108 # ffffffffc02057c8 <commands+0x738>
ffffffffc0203c24:	0f100593          	li	a1,241
ffffffffc0203c28:	00003517          	auipc	a0,0x3
ffffffffc0203c2c:	b2850513          	addi	a0,a0,-1240 # ffffffffc0206750 <default_pmm_manager+0xbd8>
ffffffffc0203c30:	817fc0ef          	jal	ra,ffffffffc0200446 <__panic>
ffffffffc0203c34:	147d                	addi	s0,s0,-1
ffffffffc0203c36:	fd2410e3          	bne	s0,s2,ffffffffc0203bf6 <vmm_init+0x17a>
ffffffffc0203c3a:	a801                	j	ffffffffc0203c4a <vmm_init+0x1ce>
ffffffffc0203c3c:	6118                	ld	a4,0(a0)
ffffffffc0203c3e:	651c                	ld	a5,8(a0)
ffffffffc0203c40:	1501                	addi	a0,a0,-32
ffffffffc0203c42:	e71c                	sd	a5,8(a4)
ffffffffc0203c44:	e398                	sd	a4,0(a5)
ffffffffc0203c46:	ccbfd0ef          	jal	ra,ffffffffc0201910 <kfree>
ffffffffc0203c4a:	6488                	ld	a0,8(s1)
ffffffffc0203c4c:	fea498e3          	bne	s1,a0,ffffffffc0203c3c <vmm_init+0x1c0>
ffffffffc0203c50:	8526                	mv	a0,s1
ffffffffc0203c52:	cbffd0ef          	jal	ra,ffffffffc0201910 <kfree>
ffffffffc0203c56:	00003517          	auipc	a0,0x3
ffffffffc0203c5a:	caa50513          	addi	a0,a0,-854 # ffffffffc0206900 <default_pmm_manager+0xd88>
ffffffffc0203c5e:	d22fc0ef          	jal	ra,ffffffffc0200180 <cprintf>
ffffffffc0203c62:	eb5fd0ef          	jal	ra,ffffffffc0201b16 <nr_free_pages>
ffffffffc0203c66:	84aa                	mv	s1,a0
ffffffffc0203c68:	03000513          	li	a0,48
ffffffffc0203c6c:	bf5fd0ef          	jal	ra,ffffffffc0201860 <kmalloc>
ffffffffc0203c70:	842a                	mv	s0,a0
ffffffffc0203c72:	2e050263          	beqz	a0,ffffffffc0203f56 <vmm_init+0x4da>
ffffffffc0203c76:	00012797          	auipc	a5,0x12
ffffffffc0203c7a:	9227a783          	lw	a5,-1758(a5) # ffffffffc0215598 <swap_init_ok>
ffffffffc0203c7e:	e508                	sd	a0,8(a0)
ffffffffc0203c80:	e108                	sd	a0,0(a0)
ffffffffc0203c82:	00053823          	sd	zero,16(a0)
ffffffffc0203c86:	00053c23          	sd	zero,24(a0)
ffffffffc0203c8a:	02052023          	sw	zero,32(a0)
ffffffffc0203c8e:	1a079163          	bnez	a5,ffffffffc0203e30 <vmm_init+0x3b4>
ffffffffc0203c92:	02053423          	sd	zero,40(a0)
ffffffffc0203c96:	00012917          	auipc	s2,0x12
ffffffffc0203c9a:	8ca93903          	ld	s2,-1846(s2) # ffffffffc0215560 <boot_pgdir>
ffffffffc0203c9e:	00093783          	ld	a5,0(s2)
ffffffffc0203ca2:	00012717          	auipc	a4,0x12
ffffffffc0203ca6:	8e873f23          	sd	s0,-1794(a4) # ffffffffc02155a0 <check_mm_struct>
ffffffffc0203caa:	01243c23          	sd	s2,24(s0)
ffffffffc0203cae:	38079063          	bnez	a5,ffffffffc020402e <vmm_init+0x5b2>
ffffffffc0203cb2:	03000513          	li	a0,48
ffffffffc0203cb6:	babfd0ef          	jal	ra,ffffffffc0201860 <kmalloc>
ffffffffc0203cba:	89aa                	mv	s3,a0
ffffffffc0203cbc:	2c050163          	beqz	a0,ffffffffc0203f7e <vmm_init+0x502>
ffffffffc0203cc0:	002007b7          	lui	a5,0x200
ffffffffc0203cc4:	00f9b823          	sd	a5,16(s3)
ffffffffc0203cc8:	4789                	li	a5,2
ffffffffc0203cca:	85aa                	mv	a1,a0
ffffffffc0203ccc:	00f9ac23          	sw	a5,24(s3)
ffffffffc0203cd0:	8522                	mv	a0,s0
ffffffffc0203cd2:	0009b423          	sd	zero,8(s3)
ffffffffc0203cd6:	ca9ff0ef          	jal	ra,ffffffffc020397e <insert_vma_struct>
ffffffffc0203cda:	10000593          	li	a1,256
ffffffffc0203cde:	8522                	mv	a0,s0
ffffffffc0203ce0:	c5fff0ef          	jal	ra,ffffffffc020393e <find_vma>
ffffffffc0203ce4:	10000793          	li	a5,256
ffffffffc0203ce8:	16400713          	li	a4,356
ffffffffc0203cec:	2aa99963          	bne	s3,a0,ffffffffc0203f9e <vmm_init+0x522>
ffffffffc0203cf0:	00f78023          	sb	a5,0(a5) # 200000 <kern_entry-0xffffffffc0000000>
ffffffffc0203cf4:	0785                	addi	a5,a5,1
ffffffffc0203cf6:	fee79de3          	bne	a5,a4,ffffffffc0203cf0 <vmm_init+0x274>
ffffffffc0203cfa:	6705                	lui	a4,0x1
ffffffffc0203cfc:	10000793          	li	a5,256
ffffffffc0203d00:	35670713          	addi	a4,a4,854 # 1356 <kern_entry-0xffffffffc01fecaa>
ffffffffc0203d04:	16400613          	li	a2,356
ffffffffc0203d08:	0007c683          	lbu	a3,0(a5)
ffffffffc0203d0c:	0785                	addi	a5,a5,1
ffffffffc0203d0e:	9f15                	subw	a4,a4,a3
ffffffffc0203d10:	fec79ce3          	bne	a5,a2,ffffffffc0203d08 <vmm_init+0x28c>
ffffffffc0203d14:	2a071563          	bnez	a4,ffffffffc0203fbe <vmm_init+0x542>
ffffffffc0203d18:	00093783          	ld	a5,0(s2)
ffffffffc0203d1c:	00012a97          	auipc	s5,0x12
ffffffffc0203d20:	84ca8a93          	addi	s5,s5,-1972 # ffffffffc0215568 <npage>
ffffffffc0203d24:	000ab603          	ld	a2,0(s5)
ffffffffc0203d28:	078a                	slli	a5,a5,0x2
ffffffffc0203d2a:	83b1                	srli	a5,a5,0xc
ffffffffc0203d2c:	2ac7f963          	bgeu	a5,a2,ffffffffc0203fde <vmm_init+0x562>
ffffffffc0203d30:	00003a17          	auipc	s4,0x3
ffffffffc0203d34:	138a3a03          	ld	s4,312(s4) # ffffffffc0206e68 <nbase>
ffffffffc0203d38:	41478733          	sub	a4,a5,s4
ffffffffc0203d3c:	00371793          	slli	a5,a4,0x3
ffffffffc0203d40:	97ba                	add	a5,a5,a4
ffffffffc0203d42:	078e                	slli	a5,a5,0x3
ffffffffc0203d44:	00003717          	auipc	a4,0x3
ffffffffc0203d48:	11c73703          	ld	a4,284(a4) # ffffffffc0206e60 <error_string+0x38>
ffffffffc0203d4c:	878d                	srai	a5,a5,0x3
ffffffffc0203d4e:	02e787b3          	mul	a5,a5,a4
ffffffffc0203d52:	97d2                	add	a5,a5,s4
ffffffffc0203d54:	00c79713          	slli	a4,a5,0xc
ffffffffc0203d58:	8331                	srli	a4,a4,0xc
ffffffffc0203d5a:	00c79693          	slli	a3,a5,0xc
ffffffffc0203d5e:	28c77c63          	bgeu	a4,a2,ffffffffc0203ff6 <vmm_init+0x57a>
ffffffffc0203d62:	00012997          	auipc	s3,0x12
ffffffffc0203d66:	81e9b983          	ld	s3,-2018(s3) # ffffffffc0215580 <va_pa_offset>
ffffffffc0203d6a:	4581                	li	a1,0
ffffffffc0203d6c:	854a                	mv	a0,s2
ffffffffc0203d6e:	99b6                	add	s3,s3,a3
ffffffffc0203d70:	830fe0ef          	jal	ra,ffffffffc0201da0 <page_remove>
ffffffffc0203d74:	0009b783          	ld	a5,0(s3)
ffffffffc0203d78:	000ab703          	ld	a4,0(s5)
ffffffffc0203d7c:	078a                	slli	a5,a5,0x2
ffffffffc0203d7e:	83b1                	srli	a5,a5,0xc
ffffffffc0203d80:	24e7ff63          	bgeu	a5,a4,ffffffffc0203fde <vmm_init+0x562>
ffffffffc0203d84:	414787b3          	sub	a5,a5,s4
ffffffffc0203d88:	00011997          	auipc	s3,0x11
ffffffffc0203d8c:	7e898993          	addi	s3,s3,2024 # ffffffffc0215570 <pages>
ffffffffc0203d90:	00379713          	slli	a4,a5,0x3
ffffffffc0203d94:	0009b503          	ld	a0,0(s3)
ffffffffc0203d98:	97ba                	add	a5,a5,a4
ffffffffc0203d9a:	078e                	slli	a5,a5,0x3
ffffffffc0203d9c:	953e                	add	a0,a0,a5
ffffffffc0203d9e:	4585                	li	a1,1
ffffffffc0203da0:	d37fd0ef          	jal	ra,ffffffffc0201ad6 <free_pages>
ffffffffc0203da4:	00093783          	ld	a5,0(s2)
ffffffffc0203da8:	000ab703          	ld	a4,0(s5)
ffffffffc0203dac:	078a                	slli	a5,a5,0x2
ffffffffc0203dae:	83b1                	srli	a5,a5,0xc
ffffffffc0203db0:	22e7f763          	bgeu	a5,a4,ffffffffc0203fde <vmm_init+0x562>
ffffffffc0203db4:	414787b3          	sub	a5,a5,s4
ffffffffc0203db8:	0009b503          	ld	a0,0(s3)
ffffffffc0203dbc:	00379713          	slli	a4,a5,0x3
ffffffffc0203dc0:	97ba                	add	a5,a5,a4
ffffffffc0203dc2:	078e                	slli	a5,a5,0x3
ffffffffc0203dc4:	4585                	li	a1,1
ffffffffc0203dc6:	953e                	add	a0,a0,a5
ffffffffc0203dc8:	d0ffd0ef          	jal	ra,ffffffffc0201ad6 <free_pages>
ffffffffc0203dcc:	00093023          	sd	zero,0(s2)
ffffffffc0203dd0:	12000073          	sfence.vma
ffffffffc0203dd4:	6408                	ld	a0,8(s0)
ffffffffc0203dd6:	00043c23          	sd	zero,24(s0)
ffffffffc0203dda:	00a40c63          	beq	s0,a0,ffffffffc0203df2 <vmm_init+0x376>
ffffffffc0203dde:	6118                	ld	a4,0(a0)
ffffffffc0203de0:	651c                	ld	a5,8(a0)
ffffffffc0203de2:	1501                	addi	a0,a0,-32
ffffffffc0203de4:	e71c                	sd	a5,8(a4)
ffffffffc0203de6:	e398                	sd	a4,0(a5)
ffffffffc0203de8:	b29fd0ef          	jal	ra,ffffffffc0201910 <kfree>
ffffffffc0203dec:	6408                	ld	a0,8(s0)
ffffffffc0203dee:	fea418e3          	bne	s0,a0,ffffffffc0203dde <vmm_init+0x362>
ffffffffc0203df2:	8522                	mv	a0,s0
ffffffffc0203df4:	b1dfd0ef          	jal	ra,ffffffffc0201910 <kfree>
ffffffffc0203df8:	00011797          	auipc	a5,0x11
ffffffffc0203dfc:	7a07b423          	sd	zero,1960(a5) # ffffffffc02155a0 <check_mm_struct>
ffffffffc0203e00:	d17fd0ef          	jal	ra,ffffffffc0201b16 <nr_free_pages>
ffffffffc0203e04:	20a49563          	bne	s1,a0,ffffffffc020400e <vmm_init+0x592>
ffffffffc0203e08:	00003517          	auipc	a0,0x3
ffffffffc0203e0c:	b7050513          	addi	a0,a0,-1168 # ffffffffc0206978 <default_pmm_manager+0xe00>
ffffffffc0203e10:	b70fc0ef          	jal	ra,ffffffffc0200180 <cprintf>
ffffffffc0203e14:	7442                	ld	s0,48(sp)
ffffffffc0203e16:	70e2                	ld	ra,56(sp)
ffffffffc0203e18:	74a2                	ld	s1,40(sp)
ffffffffc0203e1a:	7902                	ld	s2,32(sp)
ffffffffc0203e1c:	69e2                	ld	s3,24(sp)
ffffffffc0203e1e:	6a42                	ld	s4,16(sp)
ffffffffc0203e20:	6aa2                	ld	s5,8(sp)
ffffffffc0203e22:	00003517          	auipc	a0,0x3
ffffffffc0203e26:	b7650513          	addi	a0,a0,-1162 # ffffffffc0206998 <default_pmm_manager+0xe20>
ffffffffc0203e2a:	6121                	addi	sp,sp,64
ffffffffc0203e2c:	b54fc06f          	j	ffffffffc0200180 <cprintf>
ffffffffc0203e30:	d5aff0ef          	jal	ra,ffffffffc020338a <swap_init_mm>
ffffffffc0203e34:	b58d                	j	ffffffffc0203c96 <vmm_init+0x21a>
ffffffffc0203e36:	00003697          	auipc	a3,0x3
ffffffffc0203e3a:	9a268693          	addi	a3,a3,-1630 # ffffffffc02067d8 <default_pmm_manager+0xc60>
ffffffffc0203e3e:	00002617          	auipc	a2,0x2
ffffffffc0203e42:	98a60613          	addi	a2,a2,-1654 # ffffffffc02057c8 <commands+0x738>
ffffffffc0203e46:	0d800593          	li	a1,216
ffffffffc0203e4a:	00003517          	auipc	a0,0x3
ffffffffc0203e4e:	90650513          	addi	a0,a0,-1786 # ffffffffc0206750 <default_pmm_manager+0xbd8>
ffffffffc0203e52:	df4fc0ef          	jal	ra,ffffffffc0200446 <__panic>
ffffffffc0203e56:	00003697          	auipc	a3,0x3
ffffffffc0203e5a:	a0a68693          	addi	a3,a3,-1526 # ffffffffc0206860 <default_pmm_manager+0xce8>
ffffffffc0203e5e:	00002617          	auipc	a2,0x2
ffffffffc0203e62:	96a60613          	addi	a2,a2,-1686 # ffffffffc02057c8 <commands+0x738>
ffffffffc0203e66:	0e800593          	li	a1,232
ffffffffc0203e6a:	00003517          	auipc	a0,0x3
ffffffffc0203e6e:	8e650513          	addi	a0,a0,-1818 # ffffffffc0206750 <default_pmm_manager+0xbd8>
ffffffffc0203e72:	dd4fc0ef          	jal	ra,ffffffffc0200446 <__panic>
ffffffffc0203e76:	00003697          	auipc	a3,0x3
ffffffffc0203e7a:	a1a68693          	addi	a3,a3,-1510 # ffffffffc0206890 <default_pmm_manager+0xd18>
ffffffffc0203e7e:	00002617          	auipc	a2,0x2
ffffffffc0203e82:	94a60613          	addi	a2,a2,-1718 # ffffffffc02057c8 <commands+0x738>
ffffffffc0203e86:	0e900593          	li	a1,233
ffffffffc0203e8a:	00003517          	auipc	a0,0x3
ffffffffc0203e8e:	8c650513          	addi	a0,a0,-1850 # ffffffffc0206750 <default_pmm_manager+0xbd8>
ffffffffc0203e92:	db4fc0ef          	jal	ra,ffffffffc0200446 <__panic>
ffffffffc0203e96:	00003697          	auipc	a3,0x3
ffffffffc0203e9a:	92a68693          	addi	a3,a3,-1750 # ffffffffc02067c0 <default_pmm_manager+0xc48>
ffffffffc0203e9e:	00002617          	auipc	a2,0x2
ffffffffc0203ea2:	92a60613          	addi	a2,a2,-1750 # ffffffffc02057c8 <commands+0x738>
ffffffffc0203ea6:	0d600593          	li	a1,214
ffffffffc0203eaa:	00003517          	auipc	a0,0x3
ffffffffc0203eae:	8a650513          	addi	a0,a0,-1882 # ffffffffc0206750 <default_pmm_manager+0xbd8>
ffffffffc0203eb2:	d94fc0ef          	jal	ra,ffffffffc0200446 <__panic>
ffffffffc0203eb6:	00003697          	auipc	a3,0x3
ffffffffc0203eba:	98a68693          	addi	a3,a3,-1654 # ffffffffc0206840 <default_pmm_manager+0xcc8>
ffffffffc0203ebe:	00002617          	auipc	a2,0x2
ffffffffc0203ec2:	90a60613          	addi	a2,a2,-1782 # ffffffffc02057c8 <commands+0x738>
ffffffffc0203ec6:	0e400593          	li	a1,228
ffffffffc0203eca:	00003517          	auipc	a0,0x3
ffffffffc0203ece:	88650513          	addi	a0,a0,-1914 # ffffffffc0206750 <default_pmm_manager+0xbd8>
ffffffffc0203ed2:	d74fc0ef          	jal	ra,ffffffffc0200446 <__panic>
ffffffffc0203ed6:	00003697          	auipc	a3,0x3
ffffffffc0203eda:	97a68693          	addi	a3,a3,-1670 # ffffffffc0206850 <default_pmm_manager+0xcd8>
ffffffffc0203ede:	00002617          	auipc	a2,0x2
ffffffffc0203ee2:	8ea60613          	addi	a2,a2,-1814 # ffffffffc02057c8 <commands+0x738>
ffffffffc0203ee6:	0e600593          	li	a1,230
ffffffffc0203eea:	00003517          	auipc	a0,0x3
ffffffffc0203eee:	86650513          	addi	a0,a0,-1946 # ffffffffc0206750 <default_pmm_manager+0xbd8>
ffffffffc0203ef2:	d54fc0ef          	jal	ra,ffffffffc0200446 <__panic>
ffffffffc0203ef6:	00003697          	auipc	a3,0x3
ffffffffc0203efa:	91a68693          	addi	a3,a3,-1766 # ffffffffc0206810 <default_pmm_manager+0xc98>
ffffffffc0203efe:	00002617          	auipc	a2,0x2
ffffffffc0203f02:	8ca60613          	addi	a2,a2,-1846 # ffffffffc02057c8 <commands+0x738>
ffffffffc0203f06:	0de00593          	li	a1,222
ffffffffc0203f0a:	00003517          	auipc	a0,0x3
ffffffffc0203f0e:	84650513          	addi	a0,a0,-1978 # ffffffffc0206750 <default_pmm_manager+0xbd8>
ffffffffc0203f12:	d34fc0ef          	jal	ra,ffffffffc0200446 <__panic>
ffffffffc0203f16:	00003697          	auipc	a3,0x3
ffffffffc0203f1a:	90a68693          	addi	a3,a3,-1782 # ffffffffc0206820 <default_pmm_manager+0xca8>
ffffffffc0203f1e:	00002617          	auipc	a2,0x2
ffffffffc0203f22:	8aa60613          	addi	a2,a2,-1878 # ffffffffc02057c8 <commands+0x738>
ffffffffc0203f26:	0e000593          	li	a1,224
ffffffffc0203f2a:	00003517          	auipc	a0,0x3
ffffffffc0203f2e:	82650513          	addi	a0,a0,-2010 # ffffffffc0206750 <default_pmm_manager+0xbd8>
ffffffffc0203f32:	d14fc0ef          	jal	ra,ffffffffc0200446 <__panic>
ffffffffc0203f36:	00003697          	auipc	a3,0x3
ffffffffc0203f3a:	8fa68693          	addi	a3,a3,-1798 # ffffffffc0206830 <default_pmm_manager+0xcb8>
ffffffffc0203f3e:	00002617          	auipc	a2,0x2
ffffffffc0203f42:	88a60613          	addi	a2,a2,-1910 # ffffffffc02057c8 <commands+0x738>
ffffffffc0203f46:	0e200593          	li	a1,226
ffffffffc0203f4a:	00003517          	auipc	a0,0x3
ffffffffc0203f4e:	80650513          	addi	a0,a0,-2042 # ffffffffc0206750 <default_pmm_manager+0xbd8>
ffffffffc0203f52:	cf4fc0ef          	jal	ra,ffffffffc0200446 <__panic>
ffffffffc0203f56:	00003697          	auipc	a3,0x3
ffffffffc0203f5a:	a5a68693          	addi	a3,a3,-1446 # ffffffffc02069b0 <default_pmm_manager+0xe38>
ffffffffc0203f5e:	00002617          	auipc	a2,0x2
ffffffffc0203f62:	86a60613          	addi	a2,a2,-1942 # ffffffffc02057c8 <commands+0x738>
ffffffffc0203f66:	10100593          	li	a1,257
ffffffffc0203f6a:	00002517          	auipc	a0,0x2
ffffffffc0203f6e:	7e650513          	addi	a0,a0,2022 # ffffffffc0206750 <default_pmm_manager+0xbd8>
ffffffffc0203f72:	00011797          	auipc	a5,0x11
ffffffffc0203f76:	6207b723          	sd	zero,1582(a5) # ffffffffc02155a0 <check_mm_struct>
ffffffffc0203f7a:	cccfc0ef          	jal	ra,ffffffffc0200446 <__panic>
ffffffffc0203f7e:	00002697          	auipc	a3,0x2
ffffffffc0203f82:	34268693          	addi	a3,a3,834 # ffffffffc02062c0 <default_pmm_manager+0x748>
ffffffffc0203f86:	00002617          	auipc	a2,0x2
ffffffffc0203f8a:	84260613          	addi	a2,a2,-1982 # ffffffffc02057c8 <commands+0x738>
ffffffffc0203f8e:	10800593          	li	a1,264
ffffffffc0203f92:	00002517          	auipc	a0,0x2
ffffffffc0203f96:	7be50513          	addi	a0,a0,1982 # ffffffffc0206750 <default_pmm_manager+0xbd8>
ffffffffc0203f9a:	cacfc0ef          	jal	ra,ffffffffc0200446 <__panic>
ffffffffc0203f9e:	00003697          	auipc	a3,0x3
ffffffffc0203fa2:	98268693          	addi	a3,a3,-1662 # ffffffffc0206920 <default_pmm_manager+0xda8>
ffffffffc0203fa6:	00002617          	auipc	a2,0x2
ffffffffc0203faa:	82260613          	addi	a2,a2,-2014 # ffffffffc02057c8 <commands+0x738>
ffffffffc0203fae:	10d00593          	li	a1,269
ffffffffc0203fb2:	00002517          	auipc	a0,0x2
ffffffffc0203fb6:	79e50513          	addi	a0,a0,1950 # ffffffffc0206750 <default_pmm_manager+0xbd8>
ffffffffc0203fba:	c8cfc0ef          	jal	ra,ffffffffc0200446 <__panic>
ffffffffc0203fbe:	00003697          	auipc	a3,0x3
ffffffffc0203fc2:	98268693          	addi	a3,a3,-1662 # ffffffffc0206940 <default_pmm_manager+0xdc8>
ffffffffc0203fc6:	00002617          	auipc	a2,0x2
ffffffffc0203fca:	80260613          	addi	a2,a2,-2046 # ffffffffc02057c8 <commands+0x738>
ffffffffc0203fce:	11700593          	li	a1,279
ffffffffc0203fd2:	00002517          	auipc	a0,0x2
ffffffffc0203fd6:	77e50513          	addi	a0,a0,1918 # ffffffffc0206750 <default_pmm_manager+0xbd8>
ffffffffc0203fda:	c6cfc0ef          	jal	ra,ffffffffc0200446 <__panic>
ffffffffc0203fde:	00002617          	auipc	a2,0x2
ffffffffc0203fe2:	ca260613          	addi	a2,a2,-862 # ffffffffc0205c80 <default_pmm_manager+0x108>
ffffffffc0203fe6:	06200593          	li	a1,98
ffffffffc0203fea:	00002517          	auipc	a0,0x2
ffffffffc0203fee:	bee50513          	addi	a0,a0,-1042 # ffffffffc0205bd8 <default_pmm_manager+0x60>
ffffffffc0203ff2:	c54fc0ef          	jal	ra,ffffffffc0200446 <__panic>
ffffffffc0203ff6:	00002617          	auipc	a2,0x2
ffffffffc0203ffa:	bba60613          	addi	a2,a2,-1094 # ffffffffc0205bb0 <default_pmm_manager+0x38>
ffffffffc0203ffe:	06900593          	li	a1,105
ffffffffc0204002:	00002517          	auipc	a0,0x2
ffffffffc0204006:	bd650513          	addi	a0,a0,-1066 # ffffffffc0205bd8 <default_pmm_manager+0x60>
ffffffffc020400a:	c3cfc0ef          	jal	ra,ffffffffc0200446 <__panic>
ffffffffc020400e:	00003697          	auipc	a3,0x3
ffffffffc0204012:	94268693          	addi	a3,a3,-1726 # ffffffffc0206950 <default_pmm_manager+0xdd8>
ffffffffc0204016:	00001617          	auipc	a2,0x1
ffffffffc020401a:	7b260613          	addi	a2,a2,1970 # ffffffffc02057c8 <commands+0x738>
ffffffffc020401e:	12400593          	li	a1,292
ffffffffc0204022:	00002517          	auipc	a0,0x2
ffffffffc0204026:	72e50513          	addi	a0,a0,1838 # ffffffffc0206750 <default_pmm_manager+0xbd8>
ffffffffc020402a:	c1cfc0ef          	jal	ra,ffffffffc0200446 <__panic>
ffffffffc020402e:	00002697          	auipc	a3,0x2
ffffffffc0204032:	28268693          	addi	a3,a3,642 # ffffffffc02062b0 <default_pmm_manager+0x738>
ffffffffc0204036:	00001617          	auipc	a2,0x1
ffffffffc020403a:	79260613          	addi	a2,a2,1938 # ffffffffc02057c8 <commands+0x738>
ffffffffc020403e:	10500593          	li	a1,261
ffffffffc0204042:	00002517          	auipc	a0,0x2
ffffffffc0204046:	70e50513          	addi	a0,a0,1806 # ffffffffc0206750 <default_pmm_manager+0xbd8>
ffffffffc020404a:	bfcfc0ef          	jal	ra,ffffffffc0200446 <__panic>
ffffffffc020404e:	00002697          	auipc	a3,0x2
ffffffffc0204052:	23a68693          	addi	a3,a3,570 # ffffffffc0206288 <default_pmm_manager+0x710>
ffffffffc0204056:	00001617          	auipc	a2,0x1
ffffffffc020405a:	77260613          	addi	a2,a2,1906 # ffffffffc02057c8 <commands+0x738>
ffffffffc020405e:	0c200593          	li	a1,194
ffffffffc0204062:	00002517          	auipc	a0,0x2
ffffffffc0204066:	6ee50513          	addi	a0,a0,1774 # ffffffffc0206750 <default_pmm_manager+0xbd8>
ffffffffc020406a:	bdcfc0ef          	jal	ra,ffffffffc0200446 <__panic>

ffffffffc020406e <do_pgfault>:
ffffffffc020406e:	1101                	addi	sp,sp,-32
ffffffffc0204070:	85b2                	mv	a1,a2
ffffffffc0204072:	e822                	sd	s0,16(sp)
ffffffffc0204074:	e426                	sd	s1,8(sp)
ffffffffc0204076:	ec06                	sd	ra,24(sp)
ffffffffc0204078:	e04a                	sd	s2,0(sp)
ffffffffc020407a:	8432                	mv	s0,a2
ffffffffc020407c:	84aa                	mv	s1,a0
ffffffffc020407e:	8c1ff0ef          	jal	ra,ffffffffc020393e <find_vma>
ffffffffc0204082:	00011797          	auipc	a5,0x11
ffffffffc0204086:	5267a783          	lw	a5,1318(a5) # ffffffffc02155a8 <pgfault_num>
ffffffffc020408a:	2785                	addiw	a5,a5,1
ffffffffc020408c:	00011717          	auipc	a4,0x11
ffffffffc0204090:	50f72e23          	sw	a5,1308(a4) # ffffffffc02155a8 <pgfault_num>
ffffffffc0204094:	c931                	beqz	a0,ffffffffc02040e8 <do_pgfault+0x7a>
ffffffffc0204096:	651c                	ld	a5,8(a0)
ffffffffc0204098:	04f46863          	bltu	s0,a5,ffffffffc02040e8 <do_pgfault+0x7a>
ffffffffc020409c:	4d1c                	lw	a5,24(a0)
ffffffffc020409e:	4941                	li	s2,16
ffffffffc02040a0:	8b89                	andi	a5,a5,2
ffffffffc02040a2:	e39d                	bnez	a5,ffffffffc02040c8 <do_pgfault+0x5a>
ffffffffc02040a4:	75fd                	lui	a1,0xfffff
ffffffffc02040a6:	6c88                	ld	a0,24(s1)
ffffffffc02040a8:	8c6d                	and	s0,s0,a1
ffffffffc02040aa:	4605                	li	a2,1
ffffffffc02040ac:	85a2                	mv	a1,s0
ffffffffc02040ae:	aa3fd0ef          	jal	ra,ffffffffc0201b50 <get_pte>
ffffffffc02040b2:	cd21                	beqz	a0,ffffffffc020410a <do_pgfault+0x9c>
ffffffffc02040b4:	610c                	ld	a1,0(a0)
ffffffffc02040b6:	c999                	beqz	a1,ffffffffc02040cc <do_pgfault+0x5e>
ffffffffc02040b8:	00011797          	auipc	a5,0x11
ffffffffc02040bc:	4e07a783          	lw	a5,1248(a5) # ffffffffc0215598 <swap_init_ok>
ffffffffc02040c0:	cf8d                	beqz	a5,ffffffffc02040fa <do_pgfault+0x8c>
ffffffffc02040c2:	04003023          	sd	zero,64(zero) # 40 <kern_entry-0xffffffffc01fffc0>
ffffffffc02040c6:	9002                	ebreak
ffffffffc02040c8:	495d                	li	s2,23
ffffffffc02040ca:	bfe9                	j	ffffffffc02040a4 <do_pgfault+0x36>
ffffffffc02040cc:	6c88                	ld	a0,24(s1)
ffffffffc02040ce:	864a                	mv	a2,s2
ffffffffc02040d0:	85a2                	mv	a1,s0
ffffffffc02040d2:	a85fe0ef          	jal	ra,ffffffffc0202b56 <pgdir_alloc_page>
ffffffffc02040d6:	87aa                	mv	a5,a0
ffffffffc02040d8:	4501                	li	a0,0
ffffffffc02040da:	c3a1                	beqz	a5,ffffffffc020411a <do_pgfault+0xac>
ffffffffc02040dc:	60e2                	ld	ra,24(sp)
ffffffffc02040de:	6442                	ld	s0,16(sp)
ffffffffc02040e0:	64a2                	ld	s1,8(sp)
ffffffffc02040e2:	6902                	ld	s2,0(sp)
ffffffffc02040e4:	6105                	addi	sp,sp,32
ffffffffc02040e6:	8082                	ret
ffffffffc02040e8:	85a2                	mv	a1,s0
ffffffffc02040ea:	00003517          	auipc	a0,0x3
ffffffffc02040ee:	8de50513          	addi	a0,a0,-1826 # ffffffffc02069c8 <default_pmm_manager+0xe50>
ffffffffc02040f2:	88efc0ef          	jal	ra,ffffffffc0200180 <cprintf>
ffffffffc02040f6:	5575                	li	a0,-3
ffffffffc02040f8:	b7d5                	j	ffffffffc02040dc <do_pgfault+0x6e>
ffffffffc02040fa:	00003517          	auipc	a0,0x3
ffffffffc02040fe:	94650513          	addi	a0,a0,-1722 # ffffffffc0206a40 <default_pmm_manager+0xec8>
ffffffffc0204102:	87efc0ef          	jal	ra,ffffffffc0200180 <cprintf>
ffffffffc0204106:	5571                	li	a0,-4
ffffffffc0204108:	bfd1                	j	ffffffffc02040dc <do_pgfault+0x6e>
ffffffffc020410a:	00003517          	auipc	a0,0x3
ffffffffc020410e:	8ee50513          	addi	a0,a0,-1810 # ffffffffc02069f8 <default_pmm_manager+0xe80>
ffffffffc0204112:	86efc0ef          	jal	ra,ffffffffc0200180 <cprintf>
ffffffffc0204116:	5571                	li	a0,-4
ffffffffc0204118:	b7d1                	j	ffffffffc02040dc <do_pgfault+0x6e>
ffffffffc020411a:	00003517          	auipc	a0,0x3
ffffffffc020411e:	8fe50513          	addi	a0,a0,-1794 # ffffffffc0206a18 <default_pmm_manager+0xea0>
ffffffffc0204122:	85efc0ef          	jal	ra,ffffffffc0200180 <cprintf>
ffffffffc0204126:	5571                	li	a0,-4
ffffffffc0204128:	bf55                	j	ffffffffc02040dc <do_pgfault+0x6e>

ffffffffc020412a <swapfs_init>:
ffffffffc020412a:	1141                	addi	sp,sp,-16
ffffffffc020412c:	4505                	li	a0,1
ffffffffc020412e:	e406                	sd	ra,8(sp)
ffffffffc0204130:	c38fc0ef          	jal	ra,ffffffffc0200568 <ide_device_valid>
ffffffffc0204134:	cd01                	beqz	a0,ffffffffc020414c <swapfs_init+0x22>
ffffffffc0204136:	4505                	li	a0,1
ffffffffc0204138:	c36fc0ef          	jal	ra,ffffffffc020056e <ide_device_size>
ffffffffc020413c:	60a2                	ld	ra,8(sp)
ffffffffc020413e:	810d                	srli	a0,a0,0x3
ffffffffc0204140:	00011797          	auipc	a5,0x11
ffffffffc0204144:	44a7b423          	sd	a0,1096(a5) # ffffffffc0215588 <max_swap_offset>
ffffffffc0204148:	0141                	addi	sp,sp,16
ffffffffc020414a:	8082                	ret
ffffffffc020414c:	00003617          	auipc	a2,0x3
ffffffffc0204150:	91c60613          	addi	a2,a2,-1764 # ffffffffc0206a68 <default_pmm_manager+0xef0>
ffffffffc0204154:	45b5                	li	a1,13
ffffffffc0204156:	00003517          	auipc	a0,0x3
ffffffffc020415a:	93250513          	addi	a0,a0,-1742 # ffffffffc0206a88 <default_pmm_manager+0xf10>
ffffffffc020415e:	ae8fc0ef          	jal	ra,ffffffffc0200446 <__panic>

ffffffffc0204162 <swapfs_write>:
ffffffffc0204162:	1141                	addi	sp,sp,-16
ffffffffc0204164:	e406                	sd	ra,8(sp)
ffffffffc0204166:	00855793          	srli	a5,a0,0x8
ffffffffc020416a:	c3a5                	beqz	a5,ffffffffc02041ca <swapfs_write+0x68>
ffffffffc020416c:	00011717          	auipc	a4,0x11
ffffffffc0204170:	41c73703          	ld	a4,1052(a4) # ffffffffc0215588 <max_swap_offset>
ffffffffc0204174:	04e7fb63          	bgeu	a5,a4,ffffffffc02041ca <swapfs_write+0x68>
ffffffffc0204178:	00011617          	auipc	a2,0x11
ffffffffc020417c:	3f863603          	ld	a2,1016(a2) # ffffffffc0215570 <pages>
ffffffffc0204180:	8d91                	sub	a1,a1,a2
ffffffffc0204182:	4035d613          	srai	a2,a1,0x3
ffffffffc0204186:	00003597          	auipc	a1,0x3
ffffffffc020418a:	cda5b583          	ld	a1,-806(a1) # ffffffffc0206e60 <error_string+0x38>
ffffffffc020418e:	02b60633          	mul	a2,a2,a1
ffffffffc0204192:	0037959b          	slliw	a1,a5,0x3
ffffffffc0204196:	00003797          	auipc	a5,0x3
ffffffffc020419a:	cd27b783          	ld	a5,-814(a5) # ffffffffc0206e68 <nbase>
ffffffffc020419e:	00011717          	auipc	a4,0x11
ffffffffc02041a2:	3ca73703          	ld	a4,970(a4) # ffffffffc0215568 <npage>
ffffffffc02041a6:	963e                	add	a2,a2,a5
ffffffffc02041a8:	00c61793          	slli	a5,a2,0xc
ffffffffc02041ac:	83b1                	srli	a5,a5,0xc
ffffffffc02041ae:	0632                	slli	a2,a2,0xc
ffffffffc02041b0:	02e7f963          	bgeu	a5,a4,ffffffffc02041e2 <swapfs_write+0x80>
ffffffffc02041b4:	60a2                	ld	ra,8(sp)
ffffffffc02041b6:	00011797          	auipc	a5,0x11
ffffffffc02041ba:	3ca7b783          	ld	a5,970(a5) # ffffffffc0215580 <va_pa_offset>
ffffffffc02041be:	46a1                	li	a3,8
ffffffffc02041c0:	963e                	add	a2,a2,a5
ffffffffc02041c2:	4505                	li	a0,1
ffffffffc02041c4:	0141                	addi	sp,sp,16
ffffffffc02041c6:	baefc06f          	j	ffffffffc0200574 <ide_write_secs>
ffffffffc02041ca:	86aa                	mv	a3,a0
ffffffffc02041cc:	00003617          	auipc	a2,0x3
ffffffffc02041d0:	8d460613          	addi	a2,a2,-1836 # ffffffffc0206aa0 <default_pmm_manager+0xf28>
ffffffffc02041d4:	45e5                	li	a1,25
ffffffffc02041d6:	00003517          	auipc	a0,0x3
ffffffffc02041da:	8b250513          	addi	a0,a0,-1870 # ffffffffc0206a88 <default_pmm_manager+0xf10>
ffffffffc02041de:	a68fc0ef          	jal	ra,ffffffffc0200446 <__panic>
ffffffffc02041e2:	86b2                	mv	a3,a2
ffffffffc02041e4:	06900593          	li	a1,105
ffffffffc02041e8:	00002617          	auipc	a2,0x2
ffffffffc02041ec:	9c860613          	addi	a2,a2,-1592 # ffffffffc0205bb0 <default_pmm_manager+0x38>
ffffffffc02041f0:	00002517          	auipc	a0,0x2
ffffffffc02041f4:	9e850513          	addi	a0,a0,-1560 # ffffffffc0205bd8 <default_pmm_manager+0x60>
ffffffffc02041f8:	a4efc0ef          	jal	ra,ffffffffc0200446 <__panic>

ffffffffc02041fc <kernel_thread_entry>:
ffffffffc02041fc:	8526                	mv	a0,s1
ffffffffc02041fe:	9402                	jalr	s0
ffffffffc0204200:	3d2000ef          	jal	ra,ffffffffc02045d2 <do_exit>

ffffffffc0204204 <alloc_proc>:
//恢复中断帧中的所有寄存器
//进行上下文切换，主要是结构体proc_struct中的东西，进程上下文

// alloc_proc - alloc a proc_struct and init all fields of proc_struct
static struct proc_struct *
alloc_proc(void) {
ffffffffc0204204:	1141                	addi	sp,sp,-16
    struct proc_struct *proc = kmalloc(sizeof(struct proc_struct));
ffffffffc0204206:	0e800513          	li	a0,232
alloc_proc(void) {
ffffffffc020420a:	e022                	sd	s0,0(sp)
ffffffffc020420c:	e406                	sd	ra,8(sp)
    struct proc_struct *proc = kmalloc(sizeof(struct proc_struct));
ffffffffc020420e:	e52fd0ef          	jal	ra,ffffffffc0201860 <kmalloc>
ffffffffc0204212:	842a                	mv	s0,a0
    if (proc != NULL) {
ffffffffc0204214:	c521                	beqz	a0,ffffffffc020425c <alloc_proc+0x58>
     *       struct trapframe *tf;                       // Trap frame for current interrupt
     *       uintptr_t cr3;                              // CR3 register: the base addr of Page Directroy Table(PDT)
     *       uint32_t flags;                             // Process flag
     *       char name[PROC_NAME_LEN + 1];               // Process name
     */
     proc->state=PROC_UNINIT;
ffffffffc0204216:	57fd                	li	a5,-1
ffffffffc0204218:	1782                	slli	a5,a5,0x20
ffffffffc020421a:	e11c                	sd	a5,0(a0)
     proc->runs=0;
     proc->kstack=0;
     proc->need_resched=0;
     proc->parent=NULL;
     proc->mm=NULL;
     memset(&(proc->context),0,sizeof(struct context));
ffffffffc020421c:	07000613          	li	a2,112
ffffffffc0204220:	4581                	li	a1,0
     proc->runs=0;
ffffffffc0204222:	00052423          	sw	zero,8(a0)
     proc->kstack=0;
ffffffffc0204226:	00053823          	sd	zero,16(a0)
     proc->need_resched=0;
ffffffffc020422a:	00052c23          	sw	zero,24(a0)
     proc->parent=NULL;
ffffffffc020422e:	02053023          	sd	zero,32(a0)
     proc->mm=NULL;
ffffffffc0204232:	02053423          	sd	zero,40(a0)
     memset(&(proc->context),0,sizeof(struct context));
ffffffffc0204236:	03050513          	addi	a0,a0,48
ffffffffc020423a:	39b000ef          	jal	ra,ffffffffc0204dd4 <memset>
     proc->tf=NULL;
     proc->cr3=boot_cr3;
ffffffffc020423e:	00011797          	auipc	a5,0x11
ffffffffc0204242:	31a7b783          	ld	a5,794(a5) # ffffffffc0215558 <boot_cr3>
     proc->tf=NULL;
ffffffffc0204246:	0a043023          	sd	zero,160(s0)
     proc->cr3=boot_cr3;
ffffffffc020424a:	f45c                	sd	a5,168(s0)
     proc->flags=0;
ffffffffc020424c:	0a042823          	sw	zero,176(s0)
     memset(proc->name,0,PROC_NAME_LEN);
ffffffffc0204250:	463d                	li	a2,15
ffffffffc0204252:	4581                	li	a1,0
ffffffffc0204254:	0b440513          	addi	a0,s0,180
ffffffffc0204258:	37d000ef          	jal	ra,ffffffffc0204dd4 <memset>
    }
    return proc;
}
ffffffffc020425c:	60a2                	ld	ra,8(sp)
ffffffffc020425e:	8522                	mv	a0,s0
ffffffffc0204260:	6402                	ld	s0,0(sp)
ffffffffc0204262:	0141                	addi	sp,sp,16
ffffffffc0204264:	8082                	ret

ffffffffc0204266 <forkret>:
// forkret -- the first kernel entry point of a new thread/process
// NOTE: the addr of forkret is setted in copy_thread function
//       after switch_to, the current proc will execute here.
static void
forkret(void) {
    forkrets(current->tf);
ffffffffc0204266:	00011797          	auipc	a5,0x11
ffffffffc020426a:	34a7b783          	ld	a5,842(a5) # ffffffffc02155b0 <current>
ffffffffc020426e:	73c8                	ld	a0,160(a5)
ffffffffc0204270:	8d9fc06f          	j	ffffffffc0200b48 <forkrets>

ffffffffc0204274 <init_main>:
int do_exit(int error_code) {
    panic("process exit!!.\n");
}

// init_main - the second kernel thread used to create user_main kernel threads
static int init_main(void *arg) {
ffffffffc0204274:	7179                	addi	sp,sp,-48
ffffffffc0204276:	ec26                	sd	s1,24(sp)
    memset(name, 0, sizeof(name));
ffffffffc0204278:	00011497          	auipc	s1,0x11
ffffffffc020427c:	2a048493          	addi	s1,s1,672 # ffffffffc0215518 <name.2>
static int init_main(void *arg) {
ffffffffc0204280:	f022                	sd	s0,32(sp)
ffffffffc0204282:	e84a                	sd	s2,16(sp)
ffffffffc0204284:	842a                	mv	s0,a0
    cprintf("this initproc, pid = %d, name = \"%s\"\n", current->pid, get_proc_name(current));
ffffffffc0204286:	00011917          	auipc	s2,0x11
ffffffffc020428a:	32a93903          	ld	s2,810(s2) # ffffffffc02155b0 <current>
    memset(name, 0, sizeof(name));
ffffffffc020428e:	4641                	li	a2,16
ffffffffc0204290:	4581                	li	a1,0
ffffffffc0204292:	8526                	mv	a0,s1
static int init_main(void *arg) {
ffffffffc0204294:	f406                	sd	ra,40(sp)
ffffffffc0204296:	e44e                	sd	s3,8(sp)
    cprintf("this initproc, pid = %d, name = \"%s\"\n", current->pid, get_proc_name(current));
ffffffffc0204298:	00492983          	lw	s3,4(s2)
    memset(name, 0, sizeof(name));
ffffffffc020429c:	339000ef          	jal	ra,ffffffffc0204dd4 <memset>
    return memcpy(name, proc->name, PROC_NAME_LEN);
ffffffffc02042a0:	0b490593          	addi	a1,s2,180
ffffffffc02042a4:	463d                	li	a2,15
ffffffffc02042a6:	8526                	mv	a0,s1
ffffffffc02042a8:	33f000ef          	jal	ra,ffffffffc0204de6 <memcpy>
ffffffffc02042ac:	862a                	mv	a2,a0
    cprintf("this initproc, pid = %d, name = \"%s\"\n", current->pid, get_proc_name(current));
ffffffffc02042ae:	85ce                	mv	a1,s3
ffffffffc02042b0:	00003517          	auipc	a0,0x3
ffffffffc02042b4:	81050513          	addi	a0,a0,-2032 # ffffffffc0206ac0 <default_pmm_manager+0xf48>
ffffffffc02042b8:	ec9fb0ef          	jal	ra,ffffffffc0200180 <cprintf>
    cprintf("To U: \"%s\".\n", (const char *)arg);
ffffffffc02042bc:	85a2                	mv	a1,s0
ffffffffc02042be:	00003517          	auipc	a0,0x3
ffffffffc02042c2:	82a50513          	addi	a0,a0,-2006 # ffffffffc0206ae8 <default_pmm_manager+0xf70>
ffffffffc02042c6:	ebbfb0ef          	jal	ra,ffffffffc0200180 <cprintf>
    cprintf("To U: \"en.., Bye, Bye. :)\"\n");
ffffffffc02042ca:	00003517          	auipc	a0,0x3
ffffffffc02042ce:	82e50513          	addi	a0,a0,-2002 # ffffffffc0206af8 <default_pmm_manager+0xf80>
ffffffffc02042d2:	eaffb0ef          	jal	ra,ffffffffc0200180 <cprintf>
    return 0;
}
ffffffffc02042d6:	70a2                	ld	ra,40(sp)
ffffffffc02042d8:	7402                	ld	s0,32(sp)
ffffffffc02042da:	64e2                	ld	s1,24(sp)
ffffffffc02042dc:	6942                	ld	s2,16(sp)
ffffffffc02042de:	69a2                	ld	s3,8(sp)
ffffffffc02042e0:	4501                	li	a0,0
ffffffffc02042e2:	6145                	addi	sp,sp,48
ffffffffc02042e4:	8082                	ret

ffffffffc02042e6 <proc_run>:
proc_run(struct proc_struct *proc) {
ffffffffc02042e6:	7179                	addi	sp,sp,-48
ffffffffc02042e8:	ec4a                	sd	s2,24(sp)
    if (proc != current) {
ffffffffc02042ea:	00011917          	auipc	s2,0x11
ffffffffc02042ee:	2c690913          	addi	s2,s2,710 # ffffffffc02155b0 <current>
proc_run(struct proc_struct *proc) {
ffffffffc02042f2:	f026                	sd	s1,32(sp)
    if (proc != current) {
ffffffffc02042f4:	00093483          	ld	s1,0(s2)
proc_run(struct proc_struct *proc) {
ffffffffc02042f8:	f406                	sd	ra,40(sp)
ffffffffc02042fa:	e84e                	sd	s3,16(sp)
    if (proc != current) {
ffffffffc02042fc:	02a48963          	beq	s1,a0,ffffffffc020432e <proc_run+0x48>
#include <defs.h>
#include <intr.h>
#include <riscv.h>

static inline bool __intr_save(void) {
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0204300:	100027f3          	csrr	a5,sstatus
ffffffffc0204304:	8b89                	andi	a5,a5,2
        intr_disable();
        return 1;
    }
    return 0;
ffffffffc0204306:	4981                	li	s3,0
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0204308:	e3a1                	bnez	a5,ffffffffc0204348 <proc_run+0x62>
        lcr3(next->cr3);
ffffffffc020430a:	755c                	ld	a5,168(a0)

#define barrier() __asm__ __volatile__ ("fence" ::: "memory")

static inline void
lcr3(unsigned int cr3) {
    write_csr(sptbr, SATP32_MODE | (cr3 >> RISCV_PGSHIFT));
ffffffffc020430c:	80000737          	lui	a4,0x80000
        current = proc;
ffffffffc0204310:	00a93023          	sd	a0,0(s2)
ffffffffc0204314:	00c7d79b          	srliw	a5,a5,0xc
ffffffffc0204318:	8fd9                	or	a5,a5,a4
ffffffffc020431a:	18079073          	csrw	satp,a5
        switch_to(&(prev->context), &(next->context));
ffffffffc020431e:	03050593          	addi	a1,a0,48
ffffffffc0204322:	03048513          	addi	a0,s1,48
ffffffffc0204326:	530000ef          	jal	ra,ffffffffc0204856 <switch_to>
}

static inline void __intr_restore(bool flag) {
    if (flag) {
ffffffffc020432a:	00099863          	bnez	s3,ffffffffc020433a <proc_run+0x54>
}
ffffffffc020432e:	70a2                	ld	ra,40(sp)
ffffffffc0204330:	7482                	ld	s1,32(sp)
ffffffffc0204332:	6962                	ld	s2,24(sp)
ffffffffc0204334:	69c2                	ld	s3,16(sp)
ffffffffc0204336:	6145                	addi	sp,sp,48
ffffffffc0204338:	8082                	ret
ffffffffc020433a:	70a2                	ld	ra,40(sp)
ffffffffc020433c:	7482                	ld	s1,32(sp)
ffffffffc020433e:	6962                	ld	s2,24(sp)
ffffffffc0204340:	69c2                	ld	s3,16(sp)
ffffffffc0204342:	6145                	addi	sp,sp,48
        intr_enable();
ffffffffc0204344:	a54fc06f          	j	ffffffffc0200598 <intr_enable>
ffffffffc0204348:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc020434a:	a54fc0ef          	jal	ra,ffffffffc020059e <intr_disable>
        return 1;
ffffffffc020434e:	6522                	ld	a0,8(sp)
ffffffffc0204350:	4985                	li	s3,1
ffffffffc0204352:	bf65                	j	ffffffffc020430a <proc_run+0x24>

ffffffffc0204354 <do_fork>:
int do_fork(uint32_t clone_flags, uintptr_t stack, struct trapframe *tf) {
ffffffffc0204354:	7179                	addi	sp,sp,-48
ffffffffc0204356:	e84a                	sd	s2,16(sp)
    if (nr_process >= MAX_PROCESS) {
ffffffffc0204358:	00011917          	auipc	s2,0x11
ffffffffc020435c:	27090913          	addi	s2,s2,624 # ffffffffc02155c8 <nr_process>
ffffffffc0204360:	00092703          	lw	a4,0(s2)
int do_fork(uint32_t clone_flags, uintptr_t stack, struct trapframe *tf) {
ffffffffc0204364:	f406                	sd	ra,40(sp)
ffffffffc0204366:	f022                	sd	s0,32(sp)
ffffffffc0204368:	ec26                	sd	s1,24(sp)
ffffffffc020436a:	e44e                	sd	s3,8(sp)
ffffffffc020436c:	e052                	sd	s4,0(sp)
    if (nr_process >= MAX_PROCESS) {
ffffffffc020436e:	6785                	lui	a5,0x1
ffffffffc0204370:	1cf75863          	bge	a4,a5,ffffffffc0204540 <do_fork+0x1ec>
ffffffffc0204374:	84ae                	mv	s1,a1
ffffffffc0204376:	8a32                	mv	s4,a2
    proc->parent = current;
ffffffffc0204378:	00011997          	auipc	s3,0x11
ffffffffc020437c:	23898993          	addi	s3,s3,568 # ffffffffc02155b0 <current>
    proc = alloc_proc();
ffffffffc0204380:	e85ff0ef          	jal	ra,ffffffffc0204204 <alloc_proc>
    proc->parent = current;
ffffffffc0204384:	0009b783          	ld	a5,0(s3)
    proc = alloc_proc();
ffffffffc0204388:	842a                	mv	s0,a0
    struct Page *page = alloc_pages(KSTACKPAGE);
ffffffffc020438a:	4509                	li	a0,2
    proc->parent = current;
ffffffffc020438c:	f01c                	sd	a5,32(s0)
    struct Page *page = alloc_pages(KSTACKPAGE);
ffffffffc020438e:	eb6fd0ef          	jal	ra,ffffffffc0201a44 <alloc_pages>
    if (page != NULL) {
ffffffffc0204392:	c139                	beqz	a0,ffffffffc02043d8 <do_fork+0x84>
extern size_t npage;
extern uint_t va_pa_offset;

static inline ppn_t
page2ppn(struct Page *page) {
    return page - pages + nbase;
ffffffffc0204394:	00011697          	auipc	a3,0x11
ffffffffc0204398:	1dc6b683          	ld	a3,476(a3) # ffffffffc0215570 <pages>
ffffffffc020439c:	40d506b3          	sub	a3,a0,a3
ffffffffc02043a0:	868d                	srai	a3,a3,0x3
ffffffffc02043a2:	00003517          	auipc	a0,0x3
ffffffffc02043a6:	abe53503          	ld	a0,-1346(a0) # ffffffffc0206e60 <error_string+0x38>
ffffffffc02043aa:	02a686b3          	mul	a3,a3,a0
ffffffffc02043ae:	00003797          	auipc	a5,0x3
ffffffffc02043b2:	aba7b783          	ld	a5,-1350(a5) # ffffffffc0206e68 <nbase>
    return &pages[PPN(pa) - nbase];
}

static inline void *
page2kva(struct Page *page) {
    return KADDR(page2pa(page));
ffffffffc02043b6:	00011717          	auipc	a4,0x11
ffffffffc02043ba:	1b273703          	ld	a4,434(a4) # ffffffffc0215568 <npage>
    return page - pages + nbase;
ffffffffc02043be:	96be                	add	a3,a3,a5
    return KADDR(page2pa(page));
ffffffffc02043c0:	00c69793          	slli	a5,a3,0xc
ffffffffc02043c4:	83b1                	srli	a5,a5,0xc
    return page2ppn(page) << PGSHIFT;
ffffffffc02043c6:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc02043c8:	1ae7f163          	bgeu	a5,a4,ffffffffc020456a <do_fork+0x216>
ffffffffc02043cc:	00011797          	auipc	a5,0x11
ffffffffc02043d0:	1b47b783          	ld	a5,436(a5) # ffffffffc0215580 <va_pa_offset>
ffffffffc02043d4:	96be                	add	a3,a3,a5
        proc->kstack = (uintptr_t)page2kva(page);
ffffffffc02043d6:	e814                	sd	a3,16(s0)
    assert(current->mm == NULL);
ffffffffc02043d8:	0009b783          	ld	a5,0(s3)
ffffffffc02043dc:	779c                	ld	a5,40(a5)
ffffffffc02043de:	16079663          	bnez	a5,ffffffffc020454a <do_fork+0x1f6>
    proc->tf = (struct trapframe *)(proc->kstack + KSTACKSIZE - sizeof(struct trapframe));
ffffffffc02043e2:	6818                	ld	a4,16(s0)
ffffffffc02043e4:	6789                	lui	a5,0x2
ffffffffc02043e6:	ee078793          	addi	a5,a5,-288 # 1ee0 <kern_entry-0xffffffffc01fe120>
ffffffffc02043ea:	973e                	add	a4,a4,a5
    *(proc->tf) = *tf;
ffffffffc02043ec:	8652                	mv	a2,s4
    proc->tf = (struct trapframe *)(proc->kstack + KSTACKSIZE - sizeof(struct trapframe));
ffffffffc02043ee:	f058                	sd	a4,160(s0)
    *(proc->tf) = *tf;
ffffffffc02043f0:	87ba                	mv	a5,a4
ffffffffc02043f2:	120a0593          	addi	a1,s4,288
ffffffffc02043f6:	00063883          	ld	a7,0(a2)
ffffffffc02043fa:	00863803          	ld	a6,8(a2)
ffffffffc02043fe:	6a08                	ld	a0,16(a2)
ffffffffc0204400:	6e14                	ld	a3,24(a2)
ffffffffc0204402:	0117b023          	sd	a7,0(a5)
ffffffffc0204406:	0107b423          	sd	a6,8(a5)
ffffffffc020440a:	eb88                	sd	a0,16(a5)
ffffffffc020440c:	ef94                	sd	a3,24(a5)
ffffffffc020440e:	02060613          	addi	a2,a2,32
ffffffffc0204412:	02078793          	addi	a5,a5,32
ffffffffc0204416:	feb610e3          	bne	a2,a1,ffffffffc02043f6 <do_fork+0xa2>
    proc->tf->gpr.a0 = 0;
ffffffffc020441a:	04073823          	sd	zero,80(a4)
    proc->tf->gpr.sp = (esp == 0) ? (uintptr_t)proc->tf : esp;
ffffffffc020441e:	10048563          	beqz	s1,ffffffffc0204528 <do_fork+0x1d4>
    if (++ last_pid >= MAX_PID) {
ffffffffc0204422:	00006817          	auipc	a6,0x6
ffffffffc0204426:	c3680813          	addi	a6,a6,-970 # ffffffffc020a058 <last_pid.1>
ffffffffc020442a:	00082783          	lw	a5,0(a6)
    proc->tf->gpr.sp = (esp == 0) ? (uintptr_t)proc->tf : esp;
ffffffffc020442e:	eb04                	sd	s1,16(a4)
    proc->context.ra = (uintptr_t)forkret;
ffffffffc0204430:	00000697          	auipc	a3,0x0
ffffffffc0204434:	e3668693          	addi	a3,a3,-458 # ffffffffc0204266 <forkret>
    if (++ last_pid >= MAX_PID) {
ffffffffc0204438:	0017851b          	addiw	a0,a5,1
    proc->context.ra = (uintptr_t)forkret;
ffffffffc020443c:	f814                	sd	a3,48(s0)
    proc->context.sp = (uintptr_t)(proc->tf);
ffffffffc020443e:	fc18                	sd	a4,56(s0)
    if (++ last_pid >= MAX_PID) {
ffffffffc0204440:	00a82023          	sw	a0,0(a6)
ffffffffc0204444:	6789                	lui	a5,0x2
ffffffffc0204446:	06f55a63          	bge	a0,a5,ffffffffc02044ba <do_fork+0x166>
    if (last_pid >= next_safe) {
ffffffffc020444a:	00006317          	auipc	t1,0x6
ffffffffc020444e:	c1230313          	addi	t1,t1,-1006 # ffffffffc020a05c <next_safe.0>
ffffffffc0204452:	00032783          	lw	a5,0(t1)
ffffffffc0204456:	00011497          	auipc	s1,0x11
ffffffffc020445a:	0d248493          	addi	s1,s1,210 # ffffffffc0215528 <proc_list>
ffffffffc020445e:	06f55663          	bge	a0,a5,ffffffffc02044ca <do_fork+0x176>
    proc->pid = pid;
ffffffffc0204462:	c048                	sw	a0,4(s0)
    list_add(hash_list + pid_hashfn(proc->pid), &(proc->hash_link));
ffffffffc0204464:	45a9                	li	a1,10
ffffffffc0204466:	2501                	sext.w	a0,a0
ffffffffc0204468:	4ec000ef          	jal	ra,ffffffffc0204954 <hash32>
ffffffffc020446c:	02051793          	slli	a5,a0,0x20
ffffffffc0204470:	0000d717          	auipc	a4,0xd
ffffffffc0204474:	0a870713          	addi	a4,a4,168 # ffffffffc0211518 <hash_list>
ffffffffc0204478:	83f1                	srli	a5,a5,0x1c
ffffffffc020447a:	97ba                	add	a5,a5,a4
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
ffffffffc020447c:	678c                	ld	a1,8(a5)
ffffffffc020447e:	0d840713          	addi	a4,s0,216
ffffffffc0204482:	6494                	ld	a3,8(s1)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
ffffffffc0204484:	e198                	sd	a4,0(a1)
ffffffffc0204486:	e798                	sd	a4,8(a5)
    nr_process++;
ffffffffc0204488:	00092703          	lw	a4,0(s2)
    list_add(&proc_list, &(proc->list_link));
ffffffffc020448c:	0c840613          	addi	a2,s0,200
    elm->next = next;
    elm->prev = prev;
ffffffffc0204490:	ec7c                	sd	a5,216(s0)
    elm->next = next;
ffffffffc0204492:	f06c                	sd	a1,224(s0)
    prev->next = next->prev = elm;
ffffffffc0204494:	e290                	sd	a2,0(a3)
    nr_process++;
ffffffffc0204496:	0017079b          	addiw	a5,a4,1
    ret = proc->pid; 
ffffffffc020449a:	4048                	lw	a0,4(s0)
ffffffffc020449c:	e490                	sd	a2,8(s1)
    nr_process++;
ffffffffc020449e:	00f92023          	sw	a5,0(s2)
    proc->state = PROC_RUNNABLE;
ffffffffc02044a2:	4789                	li	a5,2
    elm->next = next;
ffffffffc02044a4:	e874                	sd	a3,208(s0)
    elm->prev = prev;
ffffffffc02044a6:	e464                	sd	s1,200(s0)
ffffffffc02044a8:	c01c                	sw	a5,0(s0)
}
ffffffffc02044aa:	70a2                	ld	ra,40(sp)
ffffffffc02044ac:	7402                	ld	s0,32(sp)
ffffffffc02044ae:	64e2                	ld	s1,24(sp)
ffffffffc02044b0:	6942                	ld	s2,16(sp)
ffffffffc02044b2:	69a2                	ld	s3,8(sp)
ffffffffc02044b4:	6a02                	ld	s4,0(sp)
ffffffffc02044b6:	6145                	addi	sp,sp,48
ffffffffc02044b8:	8082                	ret
        last_pid = 1;
ffffffffc02044ba:	4785                	li	a5,1
ffffffffc02044bc:	00f82023          	sw	a5,0(a6)
        goto inside;
ffffffffc02044c0:	4505                	li	a0,1
ffffffffc02044c2:	00006317          	auipc	t1,0x6
ffffffffc02044c6:	b9a30313          	addi	t1,t1,-1126 # ffffffffc020a05c <next_safe.0>
    return listelm->next;
ffffffffc02044ca:	00011497          	auipc	s1,0x11
ffffffffc02044ce:	05e48493          	addi	s1,s1,94 # ffffffffc0215528 <proc_list>
ffffffffc02044d2:	0084be03          	ld	t3,8(s1)
        next_safe = MAX_PID;
ffffffffc02044d6:	6789                	lui	a5,0x2
ffffffffc02044d8:	00f32023          	sw	a5,0(t1)
ffffffffc02044dc:	86aa                	mv	a3,a0
ffffffffc02044de:	4581                	li	a1,0
        while ((le = list_next(le)) != list) {
ffffffffc02044e0:	6e89                	lui	t4,0x2
ffffffffc02044e2:	049e0a63          	beq	t3,s1,ffffffffc0204536 <do_fork+0x1e2>
ffffffffc02044e6:	88ae                	mv	a7,a1
ffffffffc02044e8:	87f2                	mv	a5,t3
ffffffffc02044ea:	6609                	lui	a2,0x2
ffffffffc02044ec:	a811                	j	ffffffffc0204500 <do_fork+0x1ac>
            else if (proc->pid > last_pid && next_safe > proc->pid) {
ffffffffc02044ee:	00e6d663          	bge	a3,a4,ffffffffc02044fa <do_fork+0x1a6>
ffffffffc02044f2:	00c75463          	bge	a4,a2,ffffffffc02044fa <do_fork+0x1a6>
ffffffffc02044f6:	863a                	mv	a2,a4
ffffffffc02044f8:	4885                	li	a7,1
ffffffffc02044fa:	679c                	ld	a5,8(a5)
        while ((le = list_next(le)) != list) {
ffffffffc02044fc:	00978d63          	beq	a5,s1,ffffffffc0204516 <do_fork+0x1c2>
            if (proc->pid == last_pid) {
ffffffffc0204500:	f3c7a703          	lw	a4,-196(a5) # 1f3c <kern_entry-0xffffffffc01fe0c4>
ffffffffc0204504:	fed715e3          	bne	a4,a3,ffffffffc02044ee <do_fork+0x19a>
                if (++ last_pid >= next_safe) {
ffffffffc0204508:	2685                	addiw	a3,a3,1
ffffffffc020450a:	02c6d163          	bge	a3,a2,ffffffffc020452c <do_fork+0x1d8>
ffffffffc020450e:	679c                	ld	a5,8(a5)
ffffffffc0204510:	4585                	li	a1,1
        while ((le = list_next(le)) != list) {
ffffffffc0204512:	fe9797e3          	bne	a5,s1,ffffffffc0204500 <do_fork+0x1ac>
ffffffffc0204516:	c581                	beqz	a1,ffffffffc020451e <do_fork+0x1ca>
ffffffffc0204518:	00d82023          	sw	a3,0(a6)
ffffffffc020451c:	8536                	mv	a0,a3
ffffffffc020451e:	f40882e3          	beqz	a7,ffffffffc0204462 <do_fork+0x10e>
ffffffffc0204522:	00c32023          	sw	a2,0(t1)
ffffffffc0204526:	bf35                	j	ffffffffc0204462 <do_fork+0x10e>
    proc->tf->gpr.sp = (esp == 0) ? (uintptr_t)proc->tf : esp;
ffffffffc0204528:	84ba                	mv	s1,a4
ffffffffc020452a:	bde5                	j	ffffffffc0204422 <do_fork+0xce>
                    if (last_pid >= MAX_PID) {
ffffffffc020452c:	01d6c363          	blt	a3,t4,ffffffffc0204532 <do_fork+0x1de>
                        last_pid = 1;
ffffffffc0204530:	4685                	li	a3,1
                    goto repeat;
ffffffffc0204532:	4585                	li	a1,1
ffffffffc0204534:	b77d                	j	ffffffffc02044e2 <do_fork+0x18e>
ffffffffc0204536:	c599                	beqz	a1,ffffffffc0204544 <do_fork+0x1f0>
ffffffffc0204538:	00d82023          	sw	a3,0(a6)
    return last_pid;
ffffffffc020453c:	8536                	mv	a0,a3
ffffffffc020453e:	b715                	j	ffffffffc0204462 <do_fork+0x10e>
    int ret = -E_NO_FREE_PROC;
ffffffffc0204540:	556d                	li	a0,-5
    return ret;
ffffffffc0204542:	b7a5                	j	ffffffffc02044aa <do_fork+0x156>
    return last_pid;
ffffffffc0204544:	00082503          	lw	a0,0(a6)
ffffffffc0204548:	bf29                	j	ffffffffc0204462 <do_fork+0x10e>
    assert(current->mm == NULL);
ffffffffc020454a:	00002697          	auipc	a3,0x2
ffffffffc020454e:	5ce68693          	addi	a3,a3,1486 # ffffffffc0206b18 <default_pmm_manager+0xfa0>
ffffffffc0204552:	00001617          	auipc	a2,0x1
ffffffffc0204556:	27660613          	addi	a2,a2,630 # ffffffffc02057c8 <commands+0x738>
ffffffffc020455a:	10300593          	li	a1,259
ffffffffc020455e:	00002517          	auipc	a0,0x2
ffffffffc0204562:	5d250513          	addi	a0,a0,1490 # ffffffffc0206b30 <default_pmm_manager+0xfb8>
ffffffffc0204566:	ee1fb0ef          	jal	ra,ffffffffc0200446 <__panic>
ffffffffc020456a:	00001617          	auipc	a2,0x1
ffffffffc020456e:	64660613          	addi	a2,a2,1606 # ffffffffc0205bb0 <default_pmm_manager+0x38>
ffffffffc0204572:	06900593          	li	a1,105
ffffffffc0204576:	00001517          	auipc	a0,0x1
ffffffffc020457a:	66250513          	addi	a0,a0,1634 # ffffffffc0205bd8 <default_pmm_manager+0x60>
ffffffffc020457e:	ec9fb0ef          	jal	ra,ffffffffc0200446 <__panic>

ffffffffc0204582 <kernel_thread>:
kernel_thread(int (*fn)(void *), void *arg, uint32_t clone_flags) {
ffffffffc0204582:	7129                	addi	sp,sp,-320
ffffffffc0204584:	fa22                	sd	s0,304(sp)
ffffffffc0204586:	f626                	sd	s1,296(sp)
ffffffffc0204588:	f24a                	sd	s2,288(sp)
ffffffffc020458a:	84ae                	mv	s1,a1
ffffffffc020458c:	892a                	mv	s2,a0
ffffffffc020458e:	8432                	mv	s0,a2
    memset(&tf, 0, sizeof(struct trapframe));
ffffffffc0204590:	4581                	li	a1,0
ffffffffc0204592:	12000613          	li	a2,288
ffffffffc0204596:	850a                	mv	a0,sp
kernel_thread(int (*fn)(void *), void *arg, uint32_t clone_flags) {
ffffffffc0204598:	fe06                	sd	ra,312(sp)
    memset(&tf, 0, sizeof(struct trapframe));
ffffffffc020459a:	03b000ef          	jal	ra,ffffffffc0204dd4 <memset>
    tf.gpr.s0 = (uintptr_t)fn;
ffffffffc020459e:	e0ca                	sd	s2,64(sp)
    tf.gpr.s1 = (uintptr_t)arg;
ffffffffc02045a0:	e4a6                	sd	s1,72(sp)
    tf.status = (read_csr(sstatus) | SSTATUS_SPP | SSTATUS_SPIE) & ~SSTATUS_SIE;
ffffffffc02045a2:	100027f3          	csrr	a5,sstatus
ffffffffc02045a6:	edd7f793          	andi	a5,a5,-291
ffffffffc02045aa:	1207e793          	ori	a5,a5,288
ffffffffc02045ae:	e23e                	sd	a5,256(sp)
    return do_fork(clone_flags | CLONE_VM, 0, &tf);
ffffffffc02045b0:	860a                	mv	a2,sp
ffffffffc02045b2:	10046513          	ori	a0,s0,256
    tf.epc = (uintptr_t)kernel_thread_entry;
ffffffffc02045b6:	00000797          	auipc	a5,0x0
ffffffffc02045ba:	c4678793          	addi	a5,a5,-954 # ffffffffc02041fc <kernel_thread_entry>
    return do_fork(clone_flags | CLONE_VM, 0, &tf);
ffffffffc02045be:	4581                	li	a1,0
    tf.epc = (uintptr_t)kernel_thread_entry;
ffffffffc02045c0:	e63e                	sd	a5,264(sp)
    return do_fork(clone_flags | CLONE_VM, 0, &tf);
ffffffffc02045c2:	d93ff0ef          	jal	ra,ffffffffc0204354 <do_fork>
}
ffffffffc02045c6:	70f2                	ld	ra,312(sp)
ffffffffc02045c8:	7452                	ld	s0,304(sp)
ffffffffc02045ca:	74b2                	ld	s1,296(sp)
ffffffffc02045cc:	7912                	ld	s2,288(sp)
ffffffffc02045ce:	6131                	addi	sp,sp,320
ffffffffc02045d0:	8082                	ret

ffffffffc02045d2 <do_exit>:
int do_exit(int error_code) {
ffffffffc02045d2:	1141                	addi	sp,sp,-16
    panic("process exit!!.\n");
ffffffffc02045d4:	00002617          	auipc	a2,0x2
ffffffffc02045d8:	57460613          	addi	a2,a2,1396 # ffffffffc0206b48 <default_pmm_manager+0xfd0>
ffffffffc02045dc:	13f00593          	li	a1,319
ffffffffc02045e0:	00002517          	auipc	a0,0x2
ffffffffc02045e4:	55050513          	addi	a0,a0,1360 # ffffffffc0206b30 <default_pmm_manager+0xfb8>
int do_exit(int error_code) {
ffffffffc02045e8:	e406                	sd	ra,8(sp)
    panic("process exit!!.\n");
ffffffffc02045ea:	e5dfb0ef          	jal	ra,ffffffffc0200446 <__panic>

ffffffffc02045ee <proc_init>:

// proc_init - set up the first kernel thread idleproc "idle" by itself and 
//           - create the second kernel thread init_main
void proc_init(void) {
ffffffffc02045ee:	7179                	addi	sp,sp,-48
ffffffffc02045f0:	ec26                	sd	s1,24(sp)
    elm->prev = elm->next = elm;
ffffffffc02045f2:	00011797          	auipc	a5,0x11
ffffffffc02045f6:	f3678793          	addi	a5,a5,-202 # ffffffffc0215528 <proc_list>
ffffffffc02045fa:	f406                	sd	ra,40(sp)
ffffffffc02045fc:	f022                	sd	s0,32(sp)
ffffffffc02045fe:	e84a                	sd	s2,16(sp)
ffffffffc0204600:	e44e                	sd	s3,8(sp)
ffffffffc0204602:	0000d497          	auipc	s1,0xd
ffffffffc0204606:	f1648493          	addi	s1,s1,-234 # ffffffffc0211518 <hash_list>
ffffffffc020460a:	e79c                	sd	a5,8(a5)
ffffffffc020460c:	e39c                	sd	a5,0(a5)
    int i;

    list_init(&proc_list);
    for (i = 0; i < HASH_LIST_SIZE; i ++) {
ffffffffc020460e:	00011717          	auipc	a4,0x11
ffffffffc0204612:	f0a70713          	addi	a4,a4,-246 # ffffffffc0215518 <name.2>
ffffffffc0204616:	87a6                	mv	a5,s1
ffffffffc0204618:	e79c                	sd	a5,8(a5)
ffffffffc020461a:	e39c                	sd	a5,0(a5)
ffffffffc020461c:	07c1                	addi	a5,a5,16
ffffffffc020461e:	fef71de3          	bne	a4,a5,ffffffffc0204618 <proc_init+0x2a>
        list_init(hash_list + i);
    }

    if ((idleproc = alloc_proc()) == NULL) {
ffffffffc0204622:	be3ff0ef          	jal	ra,ffffffffc0204204 <alloc_proc>
ffffffffc0204626:	00011917          	auipc	s2,0x11
ffffffffc020462a:	f9290913          	addi	s2,s2,-110 # ffffffffc02155b8 <idleproc>
ffffffffc020462e:	00a93023          	sd	a0,0(s2)
ffffffffc0204632:	18050c63          	beqz	a0,ffffffffc02047ca <proc_init+0x1dc>
        panic("cannot alloc idleproc.\n");
    }

    // check the proc structure
    int *context_mem = (int*) kmalloc(sizeof(struct context));
ffffffffc0204636:	07000513          	li	a0,112
ffffffffc020463a:	a26fd0ef          	jal	ra,ffffffffc0201860 <kmalloc>
    memset(context_mem, 0, sizeof(struct context));
ffffffffc020463e:	07000613          	li	a2,112
ffffffffc0204642:	4581                	li	a1,0
    int *context_mem = (int*) kmalloc(sizeof(struct context));
ffffffffc0204644:	842a                	mv	s0,a0
    memset(context_mem, 0, sizeof(struct context));
ffffffffc0204646:	78e000ef          	jal	ra,ffffffffc0204dd4 <memset>
    int context_init_flag = memcmp(&(idleproc->context), context_mem, sizeof(struct context));
ffffffffc020464a:	00093503          	ld	a0,0(s2)
ffffffffc020464e:	85a2                	mv	a1,s0
ffffffffc0204650:	07000613          	li	a2,112
ffffffffc0204654:	03050513          	addi	a0,a0,48
ffffffffc0204658:	7a6000ef          	jal	ra,ffffffffc0204dfe <memcmp>
ffffffffc020465c:	89aa                	mv	s3,a0

    int *proc_name_mem = (int*) kmalloc(PROC_NAME_LEN);
ffffffffc020465e:	453d                	li	a0,15
ffffffffc0204660:	a00fd0ef          	jal	ra,ffffffffc0201860 <kmalloc>
    memset(proc_name_mem, 0, PROC_NAME_LEN);
ffffffffc0204664:	463d                	li	a2,15
ffffffffc0204666:	4581                	li	a1,0
    int *proc_name_mem = (int*) kmalloc(PROC_NAME_LEN);
ffffffffc0204668:	842a                	mv	s0,a0
    memset(proc_name_mem, 0, PROC_NAME_LEN);
ffffffffc020466a:	76a000ef          	jal	ra,ffffffffc0204dd4 <memset>
    int proc_name_flag = memcmp(&(idleproc->name), proc_name_mem, PROC_NAME_LEN);
ffffffffc020466e:	00093503          	ld	a0,0(s2)
ffffffffc0204672:	463d                	li	a2,15
ffffffffc0204674:	85a2                	mv	a1,s0
ffffffffc0204676:	0b450513          	addi	a0,a0,180
ffffffffc020467a:	784000ef          	jal	ra,ffffffffc0204dfe <memcmp>

    if(idleproc->cr3 == boot_cr3 && idleproc->tf == NULL && !context_init_flag
ffffffffc020467e:	00093783          	ld	a5,0(s2)
ffffffffc0204682:	00011717          	auipc	a4,0x11
ffffffffc0204686:	ed673703          	ld	a4,-298(a4) # ffffffffc0215558 <boot_cr3>
ffffffffc020468a:	77d4                	ld	a3,168(a5)
ffffffffc020468c:	0ee68363          	beq	a3,a4,ffffffffc0204772 <proc_init+0x184>
        cprintf("alloc_proc() correct!\n");

    }
    
    idleproc->pid = 0;
    idleproc->state = PROC_RUNNABLE;
ffffffffc0204690:	4709                	li	a4,2
ffffffffc0204692:	e398                	sd	a4,0(a5)
    idleproc->kstack = (uintptr_t)bootstack;
ffffffffc0204694:	00003717          	auipc	a4,0x3
ffffffffc0204698:	96c70713          	addi	a4,a4,-1684 # ffffffffc0207000 <bootstack>
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc020469c:	0b478413          	addi	s0,a5,180
    idleproc->kstack = (uintptr_t)bootstack;
ffffffffc02046a0:	eb98                	sd	a4,16(a5)
    idleproc->need_resched = 1;
ffffffffc02046a2:	4705                	li	a4,1
ffffffffc02046a4:	cf98                	sw	a4,24(a5)
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc02046a6:	4641                	li	a2,16
ffffffffc02046a8:	4581                	li	a1,0
ffffffffc02046aa:	8522                	mv	a0,s0
ffffffffc02046ac:	728000ef          	jal	ra,ffffffffc0204dd4 <memset>
    return memcpy(proc->name, name, PROC_NAME_LEN);
ffffffffc02046b0:	463d                	li	a2,15
ffffffffc02046b2:	00002597          	auipc	a1,0x2
ffffffffc02046b6:	4de58593          	addi	a1,a1,1246 # ffffffffc0206b90 <default_pmm_manager+0x1018>
ffffffffc02046ba:	8522                	mv	a0,s0
ffffffffc02046bc:	72a000ef          	jal	ra,ffffffffc0204de6 <memcpy>
    set_proc_name(idleproc, "idle");
    nr_process ++;
ffffffffc02046c0:	00011717          	auipc	a4,0x11
ffffffffc02046c4:	f0870713          	addi	a4,a4,-248 # ffffffffc02155c8 <nr_process>
ffffffffc02046c8:	431c                	lw	a5,0(a4)
    current = idleproc;
ffffffffc02046ca:	00093683          	ld	a3,0(s2)
    

    int pid = kernel_thread(init_main, "Hello world!!", 0);
ffffffffc02046ce:	4601                	li	a2,0
    nr_process ++;
ffffffffc02046d0:	2785                	addiw	a5,a5,1
    int pid = kernel_thread(init_main, "Hello world!!", 0);
ffffffffc02046d2:	00002597          	auipc	a1,0x2
ffffffffc02046d6:	4c658593          	addi	a1,a1,1222 # ffffffffc0206b98 <default_pmm_manager+0x1020>
ffffffffc02046da:	00000517          	auipc	a0,0x0
ffffffffc02046de:	b9a50513          	addi	a0,a0,-1126 # ffffffffc0204274 <init_main>
    nr_process ++;
ffffffffc02046e2:	c31c                	sw	a5,0(a4)
    current = idleproc;
ffffffffc02046e4:	00011797          	auipc	a5,0x11
ffffffffc02046e8:	ecd7b623          	sd	a3,-308(a5) # ffffffffc02155b0 <current>
    int pid = kernel_thread(init_main, "Hello world!!", 0);
ffffffffc02046ec:	e97ff0ef          	jal	ra,ffffffffc0204582 <kernel_thread>
ffffffffc02046f0:	842a                	mv	s0,a0
    if (pid <= 0) {
ffffffffc02046f2:	0ea05863          	blez	a0,ffffffffc02047e2 <proc_init+0x1f4>
    if (0 < pid && pid < MAX_PID) {
ffffffffc02046f6:	6789                	lui	a5,0x2
ffffffffc02046f8:	fff5071b          	addiw	a4,a0,-1
ffffffffc02046fc:	17f9                	addi	a5,a5,-2
ffffffffc02046fe:	2501                	sext.w	a0,a0
ffffffffc0204700:	02e7e263          	bltu	a5,a4,ffffffffc0204724 <proc_init+0x136>
        list_entry_t *list = hash_list + pid_hashfn(pid), *le = list;
ffffffffc0204704:	45a9                	li	a1,10
ffffffffc0204706:	24e000ef          	jal	ra,ffffffffc0204954 <hash32>
ffffffffc020470a:	02051693          	slli	a3,a0,0x20
ffffffffc020470e:	82f1                	srli	a3,a3,0x1c
ffffffffc0204710:	96a6                	add	a3,a3,s1
ffffffffc0204712:	87b6                	mv	a5,a3
        while ((le = list_next(le)) != list) {
ffffffffc0204714:	a029                	j	ffffffffc020471e <proc_init+0x130>
            if (proc->pid == pid) {
ffffffffc0204716:	f2c7a703          	lw	a4,-212(a5) # 1f2c <kern_entry-0xffffffffc01fe0d4>
ffffffffc020471a:	0a870563          	beq	a4,s0,ffffffffc02047c4 <proc_init+0x1d6>
    return listelm->next;
ffffffffc020471e:	679c                	ld	a5,8(a5)
        while ((le = list_next(le)) != list) {
ffffffffc0204720:	fef69be3          	bne	a3,a5,ffffffffc0204716 <proc_init+0x128>
    return NULL;
ffffffffc0204724:	4781                	li	a5,0
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc0204726:	0b478493          	addi	s1,a5,180
ffffffffc020472a:	4641                	li	a2,16
ffffffffc020472c:	4581                	li	a1,0
        panic("create init_main failed.\n");
    }
    
    initproc = find_proc(pid);
ffffffffc020472e:	00011417          	auipc	s0,0x11
ffffffffc0204732:	e9240413          	addi	s0,s0,-366 # ffffffffc02155c0 <initproc>
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc0204736:	8526                	mv	a0,s1
    initproc = find_proc(pid);
ffffffffc0204738:	e01c                	sd	a5,0(s0)
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc020473a:	69a000ef          	jal	ra,ffffffffc0204dd4 <memset>
    return memcpy(proc->name, name, PROC_NAME_LEN);
ffffffffc020473e:	463d                	li	a2,15
ffffffffc0204740:	00002597          	auipc	a1,0x2
ffffffffc0204744:	48858593          	addi	a1,a1,1160 # ffffffffc0206bc8 <default_pmm_manager+0x1050>
ffffffffc0204748:	8526                	mv	a0,s1
ffffffffc020474a:	69c000ef          	jal	ra,ffffffffc0204de6 <memcpy>
    set_proc_name(initproc, "init");

    assert(idleproc != NULL && idleproc->pid == 0);
ffffffffc020474e:	00093783          	ld	a5,0(s2)
ffffffffc0204752:	c7e1                	beqz	a5,ffffffffc020481a <proc_init+0x22c>
ffffffffc0204754:	43dc                	lw	a5,4(a5)
ffffffffc0204756:	e3f1                	bnez	a5,ffffffffc020481a <proc_init+0x22c>
    assert(initproc != NULL && initproc->pid == 1);
ffffffffc0204758:	601c                	ld	a5,0(s0)
ffffffffc020475a:	c3c5                	beqz	a5,ffffffffc02047fa <proc_init+0x20c>
ffffffffc020475c:	43d8                	lw	a4,4(a5)
ffffffffc020475e:	4785                	li	a5,1
ffffffffc0204760:	08f71d63          	bne	a4,a5,ffffffffc02047fa <proc_init+0x20c>
}
ffffffffc0204764:	70a2                	ld	ra,40(sp)
ffffffffc0204766:	7402                	ld	s0,32(sp)
ffffffffc0204768:	64e2                	ld	s1,24(sp)
ffffffffc020476a:	6942                	ld	s2,16(sp)
ffffffffc020476c:	69a2                	ld	s3,8(sp)
ffffffffc020476e:	6145                	addi	sp,sp,48
ffffffffc0204770:	8082                	ret
    if(idleproc->cr3 == boot_cr3 && idleproc->tf == NULL && !context_init_flag
ffffffffc0204772:	73d8                	ld	a4,160(a5)
ffffffffc0204774:	ff11                	bnez	a4,ffffffffc0204690 <proc_init+0xa2>
ffffffffc0204776:	f0099de3          	bnez	s3,ffffffffc0204690 <proc_init+0xa2>
        && idleproc->state == PROC_UNINIT && idleproc->pid == -1 && idleproc->runs == 0
ffffffffc020477a:	6394                	ld	a3,0(a5)
ffffffffc020477c:	577d                	li	a4,-1
ffffffffc020477e:	1702                	slli	a4,a4,0x20
ffffffffc0204780:	f0e698e3          	bne	a3,a4,ffffffffc0204690 <proc_init+0xa2>
ffffffffc0204784:	4798                	lw	a4,8(a5)
ffffffffc0204786:	f00715e3          	bnez	a4,ffffffffc0204690 <proc_init+0xa2>
        && idleproc->kstack == 0 && idleproc->need_resched == 0 && idleproc->parent == NULL
ffffffffc020478a:	6b98                	ld	a4,16(a5)
ffffffffc020478c:	f00712e3          	bnez	a4,ffffffffc0204690 <proc_init+0xa2>
ffffffffc0204790:	4f98                	lw	a4,24(a5)
ffffffffc0204792:	2701                	sext.w	a4,a4
ffffffffc0204794:	ee071ee3          	bnez	a4,ffffffffc0204690 <proc_init+0xa2>
ffffffffc0204798:	7398                	ld	a4,32(a5)
ffffffffc020479a:	ee071be3          	bnez	a4,ffffffffc0204690 <proc_init+0xa2>
        && idleproc->mm == NULL && idleproc->flags == 0 && !proc_name_flag
ffffffffc020479e:	7798                	ld	a4,40(a5)
ffffffffc02047a0:	ee0718e3          	bnez	a4,ffffffffc0204690 <proc_init+0xa2>
ffffffffc02047a4:	0b07a703          	lw	a4,176(a5)
ffffffffc02047a8:	8d59                	or	a0,a0,a4
ffffffffc02047aa:	0005071b          	sext.w	a4,a0
ffffffffc02047ae:	ee0711e3          	bnez	a4,ffffffffc0204690 <proc_init+0xa2>
        cprintf("alloc_proc() correct!\n");
ffffffffc02047b2:	00002517          	auipc	a0,0x2
ffffffffc02047b6:	3c650513          	addi	a0,a0,966 # ffffffffc0206b78 <default_pmm_manager+0x1000>
ffffffffc02047ba:	9c7fb0ef          	jal	ra,ffffffffc0200180 <cprintf>
    idleproc->pid = 0;
ffffffffc02047be:	00093783          	ld	a5,0(s2)
ffffffffc02047c2:	b5f9                	j	ffffffffc0204690 <proc_init+0xa2>
            struct proc_struct *proc = le2proc(le, hash_link);
ffffffffc02047c4:	f2878793          	addi	a5,a5,-216
ffffffffc02047c8:	bfb9                	j	ffffffffc0204726 <proc_init+0x138>
        panic("cannot alloc idleproc.\n");
ffffffffc02047ca:	00002617          	auipc	a2,0x2
ffffffffc02047ce:	39660613          	addi	a2,a2,918 # ffffffffc0206b60 <default_pmm_manager+0xfe8>
ffffffffc02047d2:	15500593          	li	a1,341
ffffffffc02047d6:	00002517          	auipc	a0,0x2
ffffffffc02047da:	35a50513          	addi	a0,a0,858 # ffffffffc0206b30 <default_pmm_manager+0xfb8>
ffffffffc02047de:	c69fb0ef          	jal	ra,ffffffffc0200446 <__panic>
        panic("create init_main failed.\n");
ffffffffc02047e2:	00002617          	auipc	a2,0x2
ffffffffc02047e6:	3c660613          	addi	a2,a2,966 # ffffffffc0206ba8 <default_pmm_manager+0x1030>
ffffffffc02047ea:	17500593          	li	a1,373
ffffffffc02047ee:	00002517          	auipc	a0,0x2
ffffffffc02047f2:	34250513          	addi	a0,a0,834 # ffffffffc0206b30 <default_pmm_manager+0xfb8>
ffffffffc02047f6:	c51fb0ef          	jal	ra,ffffffffc0200446 <__panic>
    assert(initproc != NULL && initproc->pid == 1);
ffffffffc02047fa:	00002697          	auipc	a3,0x2
ffffffffc02047fe:	3fe68693          	addi	a3,a3,1022 # ffffffffc0206bf8 <default_pmm_manager+0x1080>
ffffffffc0204802:	00001617          	auipc	a2,0x1
ffffffffc0204806:	fc660613          	addi	a2,a2,-58 # ffffffffc02057c8 <commands+0x738>
ffffffffc020480a:	17c00593          	li	a1,380
ffffffffc020480e:	00002517          	auipc	a0,0x2
ffffffffc0204812:	32250513          	addi	a0,a0,802 # ffffffffc0206b30 <default_pmm_manager+0xfb8>
ffffffffc0204816:	c31fb0ef          	jal	ra,ffffffffc0200446 <__panic>
    assert(idleproc != NULL && idleproc->pid == 0);
ffffffffc020481a:	00002697          	auipc	a3,0x2
ffffffffc020481e:	3b668693          	addi	a3,a3,950 # ffffffffc0206bd0 <default_pmm_manager+0x1058>
ffffffffc0204822:	00001617          	auipc	a2,0x1
ffffffffc0204826:	fa660613          	addi	a2,a2,-90 # ffffffffc02057c8 <commands+0x738>
ffffffffc020482a:	17b00593          	li	a1,379
ffffffffc020482e:	00002517          	auipc	a0,0x2
ffffffffc0204832:	30250513          	addi	a0,a0,770 # ffffffffc0206b30 <default_pmm_manager+0xfb8>
ffffffffc0204836:	c11fb0ef          	jal	ra,ffffffffc0200446 <__panic>

ffffffffc020483a <cpu_idle>:

// cpu_idle - at the end of kern_init, the first kernel thread idleproc will do below works
void cpu_idle(void) {
ffffffffc020483a:	1141                	addi	sp,sp,-16
ffffffffc020483c:	e022                	sd	s0,0(sp)
ffffffffc020483e:	e406                	sd	ra,8(sp)
ffffffffc0204840:	00011417          	auipc	s0,0x11
ffffffffc0204844:	d7040413          	addi	s0,s0,-656 # ffffffffc02155b0 <current>
    while (1) {
        if (current->need_resched) {
ffffffffc0204848:	6018                	ld	a4,0(s0)
ffffffffc020484a:	4f1c                	lw	a5,24(a4)
ffffffffc020484c:	2781                	sext.w	a5,a5
ffffffffc020484e:	dff5                	beqz	a5,ffffffffc020484a <cpu_idle+0x10>
            schedule();
ffffffffc0204850:	070000ef          	jal	ra,ffffffffc02048c0 <schedule>
ffffffffc0204854:	bfd5                	j	ffffffffc0204848 <cpu_idle+0xe>

ffffffffc0204856 <switch_to>:
ffffffffc0204856:	00153023          	sd	ra,0(a0)
ffffffffc020485a:	00253423          	sd	sp,8(a0)
ffffffffc020485e:	e900                	sd	s0,16(a0)
ffffffffc0204860:	ed04                	sd	s1,24(a0)
ffffffffc0204862:	03253023          	sd	s2,32(a0)
ffffffffc0204866:	03353423          	sd	s3,40(a0)
ffffffffc020486a:	03453823          	sd	s4,48(a0)
ffffffffc020486e:	03553c23          	sd	s5,56(a0)
ffffffffc0204872:	05653023          	sd	s6,64(a0)
ffffffffc0204876:	05753423          	sd	s7,72(a0)
ffffffffc020487a:	05853823          	sd	s8,80(a0)
ffffffffc020487e:	05953c23          	sd	s9,88(a0)
ffffffffc0204882:	07a53023          	sd	s10,96(a0)
ffffffffc0204886:	07b53423          	sd	s11,104(a0)
ffffffffc020488a:	0005b083          	ld	ra,0(a1)
ffffffffc020488e:	0085b103          	ld	sp,8(a1)
ffffffffc0204892:	6980                	ld	s0,16(a1)
ffffffffc0204894:	6d84                	ld	s1,24(a1)
ffffffffc0204896:	0205b903          	ld	s2,32(a1)
ffffffffc020489a:	0285b983          	ld	s3,40(a1)
ffffffffc020489e:	0305ba03          	ld	s4,48(a1)
ffffffffc02048a2:	0385ba83          	ld	s5,56(a1)
ffffffffc02048a6:	0405bb03          	ld	s6,64(a1)
ffffffffc02048aa:	0485bb83          	ld	s7,72(a1)
ffffffffc02048ae:	0505bc03          	ld	s8,80(a1)
ffffffffc02048b2:	0585bc83          	ld	s9,88(a1)
ffffffffc02048b6:	0605bd03          	ld	s10,96(a1)
ffffffffc02048ba:	0685bd83          	ld	s11,104(a1)
ffffffffc02048be:	8082                	ret

ffffffffc02048c0 <schedule>:
ffffffffc02048c0:	1141                	addi	sp,sp,-16
ffffffffc02048c2:	e406                	sd	ra,8(sp)
ffffffffc02048c4:	e022                	sd	s0,0(sp)
ffffffffc02048c6:	100027f3          	csrr	a5,sstatus
ffffffffc02048ca:	8b89                	andi	a5,a5,2
ffffffffc02048cc:	4401                	li	s0,0
ffffffffc02048ce:	efbd                	bnez	a5,ffffffffc020494c <schedule+0x8c>
ffffffffc02048d0:	00011897          	auipc	a7,0x11
ffffffffc02048d4:	ce08b883          	ld	a7,-800(a7) # ffffffffc02155b0 <current>
ffffffffc02048d8:	0008ac23          	sw	zero,24(a7)
ffffffffc02048dc:	00011517          	auipc	a0,0x11
ffffffffc02048e0:	cdc53503          	ld	a0,-804(a0) # ffffffffc02155b8 <idleproc>
ffffffffc02048e4:	04a88e63          	beq	a7,a0,ffffffffc0204940 <schedule+0x80>
ffffffffc02048e8:	0c888693          	addi	a3,a7,200
ffffffffc02048ec:	00011617          	auipc	a2,0x11
ffffffffc02048f0:	c3c60613          	addi	a2,a2,-964 # ffffffffc0215528 <proc_list>
ffffffffc02048f4:	87b6                	mv	a5,a3
ffffffffc02048f6:	4581                	li	a1,0
ffffffffc02048f8:	4809                	li	a6,2
ffffffffc02048fa:	679c                	ld	a5,8(a5)
ffffffffc02048fc:	00c78863          	beq	a5,a2,ffffffffc020490c <schedule+0x4c>
ffffffffc0204900:	f387a703          	lw	a4,-200(a5)
ffffffffc0204904:	f3878593          	addi	a1,a5,-200
ffffffffc0204908:	03070163          	beq	a4,a6,ffffffffc020492a <schedule+0x6a>
ffffffffc020490c:	fef697e3          	bne	a3,a5,ffffffffc02048fa <schedule+0x3a>
ffffffffc0204910:	ed89                	bnez	a1,ffffffffc020492a <schedule+0x6a>
ffffffffc0204912:	451c                	lw	a5,8(a0)
ffffffffc0204914:	2785                	addiw	a5,a5,1
ffffffffc0204916:	c51c                	sw	a5,8(a0)
ffffffffc0204918:	00a88463          	beq	a7,a0,ffffffffc0204920 <schedule+0x60>
ffffffffc020491c:	9cbff0ef          	jal	ra,ffffffffc02042e6 <proc_run>
ffffffffc0204920:	e819                	bnez	s0,ffffffffc0204936 <schedule+0x76>
ffffffffc0204922:	60a2                	ld	ra,8(sp)
ffffffffc0204924:	6402                	ld	s0,0(sp)
ffffffffc0204926:	0141                	addi	sp,sp,16
ffffffffc0204928:	8082                	ret
ffffffffc020492a:	4198                	lw	a4,0(a1)
ffffffffc020492c:	4789                	li	a5,2
ffffffffc020492e:	fef712e3          	bne	a4,a5,ffffffffc0204912 <schedule+0x52>
ffffffffc0204932:	852e                	mv	a0,a1
ffffffffc0204934:	bff9                	j	ffffffffc0204912 <schedule+0x52>
ffffffffc0204936:	6402                	ld	s0,0(sp)
ffffffffc0204938:	60a2                	ld	ra,8(sp)
ffffffffc020493a:	0141                	addi	sp,sp,16
ffffffffc020493c:	c5dfb06f          	j	ffffffffc0200598 <intr_enable>
ffffffffc0204940:	00011617          	auipc	a2,0x11
ffffffffc0204944:	be860613          	addi	a2,a2,-1048 # ffffffffc0215528 <proc_list>
ffffffffc0204948:	86b2                	mv	a3,a2
ffffffffc020494a:	b76d                	j	ffffffffc02048f4 <schedule+0x34>
ffffffffc020494c:	c53fb0ef          	jal	ra,ffffffffc020059e <intr_disable>
ffffffffc0204950:	4405                	li	s0,1
ffffffffc0204952:	bfbd                	j	ffffffffc02048d0 <schedule+0x10>

ffffffffc0204954 <hash32>:
ffffffffc0204954:	9e3707b7          	lui	a5,0x9e370
ffffffffc0204958:	2785                	addiw	a5,a5,1
ffffffffc020495a:	02a7853b          	mulw	a0,a5,a0
ffffffffc020495e:	02000793          	li	a5,32
ffffffffc0204962:	9f8d                	subw	a5,a5,a1
ffffffffc0204964:	00f5553b          	srlw	a0,a0,a5
ffffffffc0204968:	8082                	ret

ffffffffc020496a <printnum>:
ffffffffc020496a:	02069813          	slli	a6,a3,0x20
ffffffffc020496e:	7179                	addi	sp,sp,-48
ffffffffc0204970:	02085813          	srli	a6,a6,0x20
ffffffffc0204974:	e052                	sd	s4,0(sp)
ffffffffc0204976:	03067a33          	remu	s4,a2,a6
ffffffffc020497a:	f022                	sd	s0,32(sp)
ffffffffc020497c:	ec26                	sd	s1,24(sp)
ffffffffc020497e:	e84a                	sd	s2,16(sp)
ffffffffc0204980:	f406                	sd	ra,40(sp)
ffffffffc0204982:	e44e                	sd	s3,8(sp)
ffffffffc0204984:	84aa                	mv	s1,a0
ffffffffc0204986:	892e                	mv	s2,a1
ffffffffc0204988:	fff7041b          	addiw	s0,a4,-1
ffffffffc020498c:	2a01                	sext.w	s4,s4
ffffffffc020498e:	03067e63          	bgeu	a2,a6,ffffffffc02049ca <printnum+0x60>
ffffffffc0204992:	89be                	mv	s3,a5
ffffffffc0204994:	00805763          	blez	s0,ffffffffc02049a2 <printnum+0x38>
ffffffffc0204998:	347d                	addiw	s0,s0,-1
ffffffffc020499a:	85ca                	mv	a1,s2
ffffffffc020499c:	854e                	mv	a0,s3
ffffffffc020499e:	9482                	jalr	s1
ffffffffc02049a0:	fc65                	bnez	s0,ffffffffc0204998 <printnum+0x2e>
ffffffffc02049a2:	1a02                	slli	s4,s4,0x20
ffffffffc02049a4:	00002797          	auipc	a5,0x2
ffffffffc02049a8:	27c78793          	addi	a5,a5,636 # ffffffffc0206c20 <default_pmm_manager+0x10a8>
ffffffffc02049ac:	020a5a13          	srli	s4,s4,0x20
ffffffffc02049b0:	9a3e                	add	s4,s4,a5
ffffffffc02049b2:	7402                	ld	s0,32(sp)
ffffffffc02049b4:	000a4503          	lbu	a0,0(s4)
ffffffffc02049b8:	70a2                	ld	ra,40(sp)
ffffffffc02049ba:	69a2                	ld	s3,8(sp)
ffffffffc02049bc:	6a02                	ld	s4,0(sp)
ffffffffc02049be:	85ca                	mv	a1,s2
ffffffffc02049c0:	87a6                	mv	a5,s1
ffffffffc02049c2:	6942                	ld	s2,16(sp)
ffffffffc02049c4:	64e2                	ld	s1,24(sp)
ffffffffc02049c6:	6145                	addi	sp,sp,48
ffffffffc02049c8:	8782                	jr	a5
ffffffffc02049ca:	03065633          	divu	a2,a2,a6
ffffffffc02049ce:	8722                	mv	a4,s0
ffffffffc02049d0:	f9bff0ef          	jal	ra,ffffffffc020496a <printnum>
ffffffffc02049d4:	b7f9                	j	ffffffffc02049a2 <printnum+0x38>

ffffffffc02049d6 <vprintfmt>:
ffffffffc02049d6:	7119                	addi	sp,sp,-128
ffffffffc02049d8:	f4a6                	sd	s1,104(sp)
ffffffffc02049da:	f0ca                	sd	s2,96(sp)
ffffffffc02049dc:	ecce                	sd	s3,88(sp)
ffffffffc02049de:	e8d2                	sd	s4,80(sp)
ffffffffc02049e0:	e4d6                	sd	s5,72(sp)
ffffffffc02049e2:	e0da                	sd	s6,64(sp)
ffffffffc02049e4:	fc5e                	sd	s7,56(sp)
ffffffffc02049e6:	f06a                	sd	s10,32(sp)
ffffffffc02049e8:	fc86                	sd	ra,120(sp)
ffffffffc02049ea:	f8a2                	sd	s0,112(sp)
ffffffffc02049ec:	f862                	sd	s8,48(sp)
ffffffffc02049ee:	f466                	sd	s9,40(sp)
ffffffffc02049f0:	ec6e                	sd	s11,24(sp)
ffffffffc02049f2:	892a                	mv	s2,a0
ffffffffc02049f4:	84ae                	mv	s1,a1
ffffffffc02049f6:	8d32                	mv	s10,a2
ffffffffc02049f8:	8a36                	mv	s4,a3
ffffffffc02049fa:	02500993          	li	s3,37
ffffffffc02049fe:	5b7d                	li	s6,-1
ffffffffc0204a00:	00002a97          	auipc	s5,0x2
ffffffffc0204a04:	24ca8a93          	addi	s5,s5,588 # ffffffffc0206c4c <default_pmm_manager+0x10d4>
ffffffffc0204a08:	00002b97          	auipc	s7,0x2
ffffffffc0204a0c:	420b8b93          	addi	s7,s7,1056 # ffffffffc0206e28 <error_string>
ffffffffc0204a10:	000d4503          	lbu	a0,0(s10) # 80000 <kern_entry-0xffffffffc0180000>
ffffffffc0204a14:	001d0413          	addi	s0,s10,1
ffffffffc0204a18:	01350a63          	beq	a0,s3,ffffffffc0204a2c <vprintfmt+0x56>
ffffffffc0204a1c:	c121                	beqz	a0,ffffffffc0204a5c <vprintfmt+0x86>
ffffffffc0204a1e:	85a6                	mv	a1,s1
ffffffffc0204a20:	0405                	addi	s0,s0,1
ffffffffc0204a22:	9902                	jalr	s2
ffffffffc0204a24:	fff44503          	lbu	a0,-1(s0)
ffffffffc0204a28:	ff351ae3          	bne	a0,s3,ffffffffc0204a1c <vprintfmt+0x46>
ffffffffc0204a2c:	00044603          	lbu	a2,0(s0)
ffffffffc0204a30:	02000793          	li	a5,32
ffffffffc0204a34:	4c81                	li	s9,0
ffffffffc0204a36:	4881                	li	a7,0
ffffffffc0204a38:	5c7d                	li	s8,-1
ffffffffc0204a3a:	5dfd                	li	s11,-1
ffffffffc0204a3c:	05500513          	li	a0,85
ffffffffc0204a40:	4825                	li	a6,9
ffffffffc0204a42:	fdd6059b          	addiw	a1,a2,-35
ffffffffc0204a46:	0ff5f593          	andi	a1,a1,255
ffffffffc0204a4a:	00140d13          	addi	s10,s0,1
ffffffffc0204a4e:	04b56263          	bltu	a0,a1,ffffffffc0204a92 <vprintfmt+0xbc>
ffffffffc0204a52:	058a                	slli	a1,a1,0x2
ffffffffc0204a54:	95d6                	add	a1,a1,s5
ffffffffc0204a56:	4194                	lw	a3,0(a1)
ffffffffc0204a58:	96d6                	add	a3,a3,s5
ffffffffc0204a5a:	8682                	jr	a3
ffffffffc0204a5c:	70e6                	ld	ra,120(sp)
ffffffffc0204a5e:	7446                	ld	s0,112(sp)
ffffffffc0204a60:	74a6                	ld	s1,104(sp)
ffffffffc0204a62:	7906                	ld	s2,96(sp)
ffffffffc0204a64:	69e6                	ld	s3,88(sp)
ffffffffc0204a66:	6a46                	ld	s4,80(sp)
ffffffffc0204a68:	6aa6                	ld	s5,72(sp)
ffffffffc0204a6a:	6b06                	ld	s6,64(sp)
ffffffffc0204a6c:	7be2                	ld	s7,56(sp)
ffffffffc0204a6e:	7c42                	ld	s8,48(sp)
ffffffffc0204a70:	7ca2                	ld	s9,40(sp)
ffffffffc0204a72:	7d02                	ld	s10,32(sp)
ffffffffc0204a74:	6de2                	ld	s11,24(sp)
ffffffffc0204a76:	6109                	addi	sp,sp,128
ffffffffc0204a78:	8082                	ret
ffffffffc0204a7a:	87b2                	mv	a5,a2
ffffffffc0204a7c:	00144603          	lbu	a2,1(s0)
ffffffffc0204a80:	846a                	mv	s0,s10
ffffffffc0204a82:	00140d13          	addi	s10,s0,1
ffffffffc0204a86:	fdd6059b          	addiw	a1,a2,-35
ffffffffc0204a8a:	0ff5f593          	andi	a1,a1,255
ffffffffc0204a8e:	fcb572e3          	bgeu	a0,a1,ffffffffc0204a52 <vprintfmt+0x7c>
ffffffffc0204a92:	85a6                	mv	a1,s1
ffffffffc0204a94:	02500513          	li	a0,37
ffffffffc0204a98:	9902                	jalr	s2
ffffffffc0204a9a:	fff44783          	lbu	a5,-1(s0)
ffffffffc0204a9e:	8d22                	mv	s10,s0
ffffffffc0204aa0:	f73788e3          	beq	a5,s3,ffffffffc0204a10 <vprintfmt+0x3a>
ffffffffc0204aa4:	ffed4783          	lbu	a5,-2(s10)
ffffffffc0204aa8:	1d7d                	addi	s10,s10,-1
ffffffffc0204aaa:	ff379de3          	bne	a5,s3,ffffffffc0204aa4 <vprintfmt+0xce>
ffffffffc0204aae:	b78d                	j	ffffffffc0204a10 <vprintfmt+0x3a>
ffffffffc0204ab0:	fd060c1b          	addiw	s8,a2,-48
ffffffffc0204ab4:	00144603          	lbu	a2,1(s0)
ffffffffc0204ab8:	846a                	mv	s0,s10
ffffffffc0204aba:	fd06069b          	addiw	a3,a2,-48
ffffffffc0204abe:	0006059b          	sext.w	a1,a2
ffffffffc0204ac2:	02d86463          	bltu	a6,a3,ffffffffc0204aea <vprintfmt+0x114>
ffffffffc0204ac6:	00144603          	lbu	a2,1(s0)
ffffffffc0204aca:	002c169b          	slliw	a3,s8,0x2
ffffffffc0204ace:	0186873b          	addw	a4,a3,s8
ffffffffc0204ad2:	0017171b          	slliw	a4,a4,0x1
ffffffffc0204ad6:	9f2d                	addw	a4,a4,a1
ffffffffc0204ad8:	fd06069b          	addiw	a3,a2,-48
ffffffffc0204adc:	0405                	addi	s0,s0,1
ffffffffc0204ade:	fd070c1b          	addiw	s8,a4,-48
ffffffffc0204ae2:	0006059b          	sext.w	a1,a2
ffffffffc0204ae6:	fed870e3          	bgeu	a6,a3,ffffffffc0204ac6 <vprintfmt+0xf0>
ffffffffc0204aea:	f40ddce3          	bgez	s11,ffffffffc0204a42 <vprintfmt+0x6c>
ffffffffc0204aee:	8de2                	mv	s11,s8
ffffffffc0204af0:	5c7d                	li	s8,-1
ffffffffc0204af2:	bf81                	j	ffffffffc0204a42 <vprintfmt+0x6c>
ffffffffc0204af4:	fffdc693          	not	a3,s11
ffffffffc0204af8:	96fd                	srai	a3,a3,0x3f
ffffffffc0204afa:	00ddfdb3          	and	s11,s11,a3
ffffffffc0204afe:	00144603          	lbu	a2,1(s0)
ffffffffc0204b02:	2d81                	sext.w	s11,s11
ffffffffc0204b04:	846a                	mv	s0,s10
ffffffffc0204b06:	bf35                	j	ffffffffc0204a42 <vprintfmt+0x6c>
ffffffffc0204b08:	000a2c03          	lw	s8,0(s4)
ffffffffc0204b0c:	00144603          	lbu	a2,1(s0)
ffffffffc0204b10:	0a21                	addi	s4,s4,8
ffffffffc0204b12:	846a                	mv	s0,s10
ffffffffc0204b14:	bfd9                	j	ffffffffc0204aea <vprintfmt+0x114>
ffffffffc0204b16:	4705                	li	a4,1
ffffffffc0204b18:	008a0593          	addi	a1,s4,8
ffffffffc0204b1c:	01174463          	blt	a4,a7,ffffffffc0204b24 <vprintfmt+0x14e>
ffffffffc0204b20:	1a088e63          	beqz	a7,ffffffffc0204cdc <vprintfmt+0x306>
ffffffffc0204b24:	000a3603          	ld	a2,0(s4)
ffffffffc0204b28:	46c1                	li	a3,16
ffffffffc0204b2a:	8a2e                	mv	s4,a1
ffffffffc0204b2c:	2781                	sext.w	a5,a5
ffffffffc0204b2e:	876e                	mv	a4,s11
ffffffffc0204b30:	85a6                	mv	a1,s1
ffffffffc0204b32:	854a                	mv	a0,s2
ffffffffc0204b34:	e37ff0ef          	jal	ra,ffffffffc020496a <printnum>
ffffffffc0204b38:	bde1                	j	ffffffffc0204a10 <vprintfmt+0x3a>
ffffffffc0204b3a:	000a2503          	lw	a0,0(s4)
ffffffffc0204b3e:	85a6                	mv	a1,s1
ffffffffc0204b40:	0a21                	addi	s4,s4,8
ffffffffc0204b42:	9902                	jalr	s2
ffffffffc0204b44:	b5f1                	j	ffffffffc0204a10 <vprintfmt+0x3a>
ffffffffc0204b46:	4705                	li	a4,1
ffffffffc0204b48:	008a0593          	addi	a1,s4,8
ffffffffc0204b4c:	01174463          	blt	a4,a7,ffffffffc0204b54 <vprintfmt+0x17e>
ffffffffc0204b50:	18088163          	beqz	a7,ffffffffc0204cd2 <vprintfmt+0x2fc>
ffffffffc0204b54:	000a3603          	ld	a2,0(s4)
ffffffffc0204b58:	46a9                	li	a3,10
ffffffffc0204b5a:	8a2e                	mv	s4,a1
ffffffffc0204b5c:	bfc1                	j	ffffffffc0204b2c <vprintfmt+0x156>
ffffffffc0204b5e:	00144603          	lbu	a2,1(s0)
ffffffffc0204b62:	4c85                	li	s9,1
ffffffffc0204b64:	846a                	mv	s0,s10
ffffffffc0204b66:	bdf1                	j	ffffffffc0204a42 <vprintfmt+0x6c>
ffffffffc0204b68:	85a6                	mv	a1,s1
ffffffffc0204b6a:	02500513          	li	a0,37
ffffffffc0204b6e:	9902                	jalr	s2
ffffffffc0204b70:	b545                	j	ffffffffc0204a10 <vprintfmt+0x3a>
ffffffffc0204b72:	00144603          	lbu	a2,1(s0)
ffffffffc0204b76:	2885                	addiw	a7,a7,1
ffffffffc0204b78:	846a                	mv	s0,s10
ffffffffc0204b7a:	b5e1                	j	ffffffffc0204a42 <vprintfmt+0x6c>
ffffffffc0204b7c:	4705                	li	a4,1
ffffffffc0204b7e:	008a0593          	addi	a1,s4,8
ffffffffc0204b82:	01174463          	blt	a4,a7,ffffffffc0204b8a <vprintfmt+0x1b4>
ffffffffc0204b86:	14088163          	beqz	a7,ffffffffc0204cc8 <vprintfmt+0x2f2>
ffffffffc0204b8a:	000a3603          	ld	a2,0(s4)
ffffffffc0204b8e:	46a1                	li	a3,8
ffffffffc0204b90:	8a2e                	mv	s4,a1
ffffffffc0204b92:	bf69                	j	ffffffffc0204b2c <vprintfmt+0x156>
ffffffffc0204b94:	03000513          	li	a0,48
ffffffffc0204b98:	85a6                	mv	a1,s1
ffffffffc0204b9a:	e03e                	sd	a5,0(sp)
ffffffffc0204b9c:	9902                	jalr	s2
ffffffffc0204b9e:	85a6                	mv	a1,s1
ffffffffc0204ba0:	07800513          	li	a0,120
ffffffffc0204ba4:	9902                	jalr	s2
ffffffffc0204ba6:	0a21                	addi	s4,s4,8
ffffffffc0204ba8:	6782                	ld	a5,0(sp)
ffffffffc0204baa:	46c1                	li	a3,16
ffffffffc0204bac:	ff8a3603          	ld	a2,-8(s4)
ffffffffc0204bb0:	bfb5                	j	ffffffffc0204b2c <vprintfmt+0x156>
ffffffffc0204bb2:	000a3403          	ld	s0,0(s4)
ffffffffc0204bb6:	008a0713          	addi	a4,s4,8
ffffffffc0204bba:	e03a                	sd	a4,0(sp)
ffffffffc0204bbc:	14040263          	beqz	s0,ffffffffc0204d00 <vprintfmt+0x32a>
ffffffffc0204bc0:	0fb05763          	blez	s11,ffffffffc0204cae <vprintfmt+0x2d8>
ffffffffc0204bc4:	02d00693          	li	a3,45
ffffffffc0204bc8:	0cd79163          	bne	a5,a3,ffffffffc0204c8a <vprintfmt+0x2b4>
ffffffffc0204bcc:	00044783          	lbu	a5,0(s0)
ffffffffc0204bd0:	0007851b          	sext.w	a0,a5
ffffffffc0204bd4:	cf85                	beqz	a5,ffffffffc0204c0c <vprintfmt+0x236>
ffffffffc0204bd6:	00140a13          	addi	s4,s0,1
ffffffffc0204bda:	05e00413          	li	s0,94
ffffffffc0204bde:	000c4563          	bltz	s8,ffffffffc0204be8 <vprintfmt+0x212>
ffffffffc0204be2:	3c7d                	addiw	s8,s8,-1
ffffffffc0204be4:	036c0263          	beq	s8,s6,ffffffffc0204c08 <vprintfmt+0x232>
ffffffffc0204be8:	85a6                	mv	a1,s1
ffffffffc0204bea:	0e0c8e63          	beqz	s9,ffffffffc0204ce6 <vprintfmt+0x310>
ffffffffc0204bee:	3781                	addiw	a5,a5,-32
ffffffffc0204bf0:	0ef47b63          	bgeu	s0,a5,ffffffffc0204ce6 <vprintfmt+0x310>
ffffffffc0204bf4:	03f00513          	li	a0,63
ffffffffc0204bf8:	9902                	jalr	s2
ffffffffc0204bfa:	000a4783          	lbu	a5,0(s4)
ffffffffc0204bfe:	3dfd                	addiw	s11,s11,-1
ffffffffc0204c00:	0a05                	addi	s4,s4,1
ffffffffc0204c02:	0007851b          	sext.w	a0,a5
ffffffffc0204c06:	ffe1                	bnez	a5,ffffffffc0204bde <vprintfmt+0x208>
ffffffffc0204c08:	01b05963          	blez	s11,ffffffffc0204c1a <vprintfmt+0x244>
ffffffffc0204c0c:	3dfd                	addiw	s11,s11,-1
ffffffffc0204c0e:	85a6                	mv	a1,s1
ffffffffc0204c10:	02000513          	li	a0,32
ffffffffc0204c14:	9902                	jalr	s2
ffffffffc0204c16:	fe0d9be3          	bnez	s11,ffffffffc0204c0c <vprintfmt+0x236>
ffffffffc0204c1a:	6a02                	ld	s4,0(sp)
ffffffffc0204c1c:	bbd5                	j	ffffffffc0204a10 <vprintfmt+0x3a>
ffffffffc0204c1e:	4705                	li	a4,1
ffffffffc0204c20:	008a0c93          	addi	s9,s4,8
ffffffffc0204c24:	01174463          	blt	a4,a7,ffffffffc0204c2c <vprintfmt+0x256>
ffffffffc0204c28:	08088d63          	beqz	a7,ffffffffc0204cc2 <vprintfmt+0x2ec>
ffffffffc0204c2c:	000a3403          	ld	s0,0(s4)
ffffffffc0204c30:	0a044d63          	bltz	s0,ffffffffc0204cea <vprintfmt+0x314>
ffffffffc0204c34:	8622                	mv	a2,s0
ffffffffc0204c36:	8a66                	mv	s4,s9
ffffffffc0204c38:	46a9                	li	a3,10
ffffffffc0204c3a:	bdcd                	j	ffffffffc0204b2c <vprintfmt+0x156>
ffffffffc0204c3c:	000a2783          	lw	a5,0(s4)
ffffffffc0204c40:	4719                	li	a4,6
ffffffffc0204c42:	0a21                	addi	s4,s4,8
ffffffffc0204c44:	41f7d69b          	sraiw	a3,a5,0x1f
ffffffffc0204c48:	8fb5                	xor	a5,a5,a3
ffffffffc0204c4a:	40d786bb          	subw	a3,a5,a3
ffffffffc0204c4e:	02d74163          	blt	a4,a3,ffffffffc0204c70 <vprintfmt+0x29a>
ffffffffc0204c52:	00369793          	slli	a5,a3,0x3
ffffffffc0204c56:	97de                	add	a5,a5,s7
ffffffffc0204c58:	639c                	ld	a5,0(a5)
ffffffffc0204c5a:	cb99                	beqz	a5,ffffffffc0204c70 <vprintfmt+0x29a>
ffffffffc0204c5c:	86be                	mv	a3,a5
ffffffffc0204c5e:	00000617          	auipc	a2,0x0
ffffffffc0204c62:	1f260613          	addi	a2,a2,498 # ffffffffc0204e50 <etext+0x2e>
ffffffffc0204c66:	85a6                	mv	a1,s1
ffffffffc0204c68:	854a                	mv	a0,s2
ffffffffc0204c6a:	0ce000ef          	jal	ra,ffffffffc0204d38 <printfmt>
ffffffffc0204c6e:	b34d                	j	ffffffffc0204a10 <vprintfmt+0x3a>
ffffffffc0204c70:	00002617          	auipc	a2,0x2
ffffffffc0204c74:	fd060613          	addi	a2,a2,-48 # ffffffffc0206c40 <default_pmm_manager+0x10c8>
ffffffffc0204c78:	85a6                	mv	a1,s1
ffffffffc0204c7a:	854a                	mv	a0,s2
ffffffffc0204c7c:	0bc000ef          	jal	ra,ffffffffc0204d38 <printfmt>
ffffffffc0204c80:	bb41                	j	ffffffffc0204a10 <vprintfmt+0x3a>
ffffffffc0204c82:	00002417          	auipc	s0,0x2
ffffffffc0204c86:	fb640413          	addi	s0,s0,-74 # ffffffffc0206c38 <default_pmm_manager+0x10c0>
ffffffffc0204c8a:	85e2                	mv	a1,s8
ffffffffc0204c8c:	8522                	mv	a0,s0
ffffffffc0204c8e:	e43e                	sd	a5,8(sp)
ffffffffc0204c90:	0e2000ef          	jal	ra,ffffffffc0204d72 <strnlen>
ffffffffc0204c94:	40ad8dbb          	subw	s11,s11,a0
ffffffffc0204c98:	01b05b63          	blez	s11,ffffffffc0204cae <vprintfmt+0x2d8>
ffffffffc0204c9c:	67a2                	ld	a5,8(sp)
ffffffffc0204c9e:	00078a1b          	sext.w	s4,a5
ffffffffc0204ca2:	3dfd                	addiw	s11,s11,-1
ffffffffc0204ca4:	85a6                	mv	a1,s1
ffffffffc0204ca6:	8552                	mv	a0,s4
ffffffffc0204ca8:	9902                	jalr	s2
ffffffffc0204caa:	fe0d9ce3          	bnez	s11,ffffffffc0204ca2 <vprintfmt+0x2cc>
ffffffffc0204cae:	00044783          	lbu	a5,0(s0)
ffffffffc0204cb2:	00140a13          	addi	s4,s0,1
ffffffffc0204cb6:	0007851b          	sext.w	a0,a5
ffffffffc0204cba:	d3a5                	beqz	a5,ffffffffc0204c1a <vprintfmt+0x244>
ffffffffc0204cbc:	05e00413          	li	s0,94
ffffffffc0204cc0:	bf39                	j	ffffffffc0204bde <vprintfmt+0x208>
ffffffffc0204cc2:	000a2403          	lw	s0,0(s4)
ffffffffc0204cc6:	b7ad                	j	ffffffffc0204c30 <vprintfmt+0x25a>
ffffffffc0204cc8:	000a6603          	lwu	a2,0(s4)
ffffffffc0204ccc:	46a1                	li	a3,8
ffffffffc0204cce:	8a2e                	mv	s4,a1
ffffffffc0204cd0:	bdb1                	j	ffffffffc0204b2c <vprintfmt+0x156>
ffffffffc0204cd2:	000a6603          	lwu	a2,0(s4)
ffffffffc0204cd6:	46a9                	li	a3,10
ffffffffc0204cd8:	8a2e                	mv	s4,a1
ffffffffc0204cda:	bd89                	j	ffffffffc0204b2c <vprintfmt+0x156>
ffffffffc0204cdc:	000a6603          	lwu	a2,0(s4)
ffffffffc0204ce0:	46c1                	li	a3,16
ffffffffc0204ce2:	8a2e                	mv	s4,a1
ffffffffc0204ce4:	b5a1                	j	ffffffffc0204b2c <vprintfmt+0x156>
ffffffffc0204ce6:	9902                	jalr	s2
ffffffffc0204ce8:	bf09                	j	ffffffffc0204bfa <vprintfmt+0x224>
ffffffffc0204cea:	85a6                	mv	a1,s1
ffffffffc0204cec:	02d00513          	li	a0,45
ffffffffc0204cf0:	e03e                	sd	a5,0(sp)
ffffffffc0204cf2:	9902                	jalr	s2
ffffffffc0204cf4:	6782                	ld	a5,0(sp)
ffffffffc0204cf6:	8a66                	mv	s4,s9
ffffffffc0204cf8:	40800633          	neg	a2,s0
ffffffffc0204cfc:	46a9                	li	a3,10
ffffffffc0204cfe:	b53d                	j	ffffffffc0204b2c <vprintfmt+0x156>
ffffffffc0204d00:	03b05163          	blez	s11,ffffffffc0204d22 <vprintfmt+0x34c>
ffffffffc0204d04:	02d00693          	li	a3,45
ffffffffc0204d08:	f6d79de3          	bne	a5,a3,ffffffffc0204c82 <vprintfmt+0x2ac>
ffffffffc0204d0c:	00002417          	auipc	s0,0x2
ffffffffc0204d10:	f2c40413          	addi	s0,s0,-212 # ffffffffc0206c38 <default_pmm_manager+0x10c0>
ffffffffc0204d14:	02800793          	li	a5,40
ffffffffc0204d18:	02800513          	li	a0,40
ffffffffc0204d1c:	00140a13          	addi	s4,s0,1
ffffffffc0204d20:	bd6d                	j	ffffffffc0204bda <vprintfmt+0x204>
ffffffffc0204d22:	00002a17          	auipc	s4,0x2
ffffffffc0204d26:	f17a0a13          	addi	s4,s4,-233 # ffffffffc0206c39 <default_pmm_manager+0x10c1>
ffffffffc0204d2a:	02800513          	li	a0,40
ffffffffc0204d2e:	02800793          	li	a5,40
ffffffffc0204d32:	05e00413          	li	s0,94
ffffffffc0204d36:	b565                	j	ffffffffc0204bde <vprintfmt+0x208>

ffffffffc0204d38 <printfmt>:
ffffffffc0204d38:	715d                	addi	sp,sp,-80
ffffffffc0204d3a:	02810313          	addi	t1,sp,40
ffffffffc0204d3e:	f436                	sd	a3,40(sp)
ffffffffc0204d40:	869a                	mv	a3,t1
ffffffffc0204d42:	ec06                	sd	ra,24(sp)
ffffffffc0204d44:	f83a                	sd	a4,48(sp)
ffffffffc0204d46:	fc3e                	sd	a5,56(sp)
ffffffffc0204d48:	e0c2                	sd	a6,64(sp)
ffffffffc0204d4a:	e4c6                	sd	a7,72(sp)
ffffffffc0204d4c:	e41a                	sd	t1,8(sp)
ffffffffc0204d4e:	c89ff0ef          	jal	ra,ffffffffc02049d6 <vprintfmt>
ffffffffc0204d52:	60e2                	ld	ra,24(sp)
ffffffffc0204d54:	6161                	addi	sp,sp,80
ffffffffc0204d56:	8082                	ret

ffffffffc0204d58 <strlen>:
ffffffffc0204d58:	00054783          	lbu	a5,0(a0)
ffffffffc0204d5c:	872a                	mv	a4,a0
ffffffffc0204d5e:	4501                	li	a0,0
ffffffffc0204d60:	cb81                	beqz	a5,ffffffffc0204d70 <strlen+0x18>
ffffffffc0204d62:	0505                	addi	a0,a0,1
ffffffffc0204d64:	00a707b3          	add	a5,a4,a0
ffffffffc0204d68:	0007c783          	lbu	a5,0(a5)
ffffffffc0204d6c:	fbfd                	bnez	a5,ffffffffc0204d62 <strlen+0xa>
ffffffffc0204d6e:	8082                	ret
ffffffffc0204d70:	8082                	ret

ffffffffc0204d72 <strnlen>:
ffffffffc0204d72:	4781                	li	a5,0
ffffffffc0204d74:	e589                	bnez	a1,ffffffffc0204d7e <strnlen+0xc>
ffffffffc0204d76:	a811                	j	ffffffffc0204d8a <strnlen+0x18>
ffffffffc0204d78:	0785                	addi	a5,a5,1
ffffffffc0204d7a:	00f58863          	beq	a1,a5,ffffffffc0204d8a <strnlen+0x18>
ffffffffc0204d7e:	00f50733          	add	a4,a0,a5
ffffffffc0204d82:	00074703          	lbu	a4,0(a4)
ffffffffc0204d86:	fb6d                	bnez	a4,ffffffffc0204d78 <strnlen+0x6>
ffffffffc0204d88:	85be                	mv	a1,a5
ffffffffc0204d8a:	852e                	mv	a0,a1
ffffffffc0204d8c:	8082                	ret

ffffffffc0204d8e <strcpy>:
ffffffffc0204d8e:	87aa                	mv	a5,a0
ffffffffc0204d90:	0005c703          	lbu	a4,0(a1)
ffffffffc0204d94:	0785                	addi	a5,a5,1
ffffffffc0204d96:	0585                	addi	a1,a1,1
ffffffffc0204d98:	fee78fa3          	sb	a4,-1(a5)
ffffffffc0204d9c:	fb75                	bnez	a4,ffffffffc0204d90 <strcpy+0x2>
ffffffffc0204d9e:	8082                	ret

ffffffffc0204da0 <strcmp>:
ffffffffc0204da0:	00054783          	lbu	a5,0(a0)
ffffffffc0204da4:	0005c703          	lbu	a4,0(a1)
ffffffffc0204da8:	cb89                	beqz	a5,ffffffffc0204dba <strcmp+0x1a>
ffffffffc0204daa:	0505                	addi	a0,a0,1
ffffffffc0204dac:	0585                	addi	a1,a1,1
ffffffffc0204dae:	fee789e3          	beq	a5,a4,ffffffffc0204da0 <strcmp>
ffffffffc0204db2:	0007851b          	sext.w	a0,a5
ffffffffc0204db6:	9d19                	subw	a0,a0,a4
ffffffffc0204db8:	8082                	ret
ffffffffc0204dba:	4501                	li	a0,0
ffffffffc0204dbc:	bfed                	j	ffffffffc0204db6 <strcmp+0x16>

ffffffffc0204dbe <strchr>:
ffffffffc0204dbe:	00054783          	lbu	a5,0(a0)
ffffffffc0204dc2:	c799                	beqz	a5,ffffffffc0204dd0 <strchr+0x12>
ffffffffc0204dc4:	00f58763          	beq	a1,a5,ffffffffc0204dd2 <strchr+0x14>
ffffffffc0204dc8:	00154783          	lbu	a5,1(a0)
ffffffffc0204dcc:	0505                	addi	a0,a0,1
ffffffffc0204dce:	fbfd                	bnez	a5,ffffffffc0204dc4 <strchr+0x6>
ffffffffc0204dd0:	4501                	li	a0,0
ffffffffc0204dd2:	8082                	ret

ffffffffc0204dd4 <memset>:
ffffffffc0204dd4:	ca01                	beqz	a2,ffffffffc0204de4 <memset+0x10>
ffffffffc0204dd6:	962a                	add	a2,a2,a0
ffffffffc0204dd8:	87aa                	mv	a5,a0
ffffffffc0204dda:	0785                	addi	a5,a5,1
ffffffffc0204ddc:	feb78fa3          	sb	a1,-1(a5)
ffffffffc0204de0:	fec79de3          	bne	a5,a2,ffffffffc0204dda <memset+0x6>
ffffffffc0204de4:	8082                	ret

ffffffffc0204de6 <memcpy>:
ffffffffc0204de6:	ca19                	beqz	a2,ffffffffc0204dfc <memcpy+0x16>
ffffffffc0204de8:	962e                	add	a2,a2,a1
ffffffffc0204dea:	87aa                	mv	a5,a0
ffffffffc0204dec:	0005c703          	lbu	a4,0(a1)
ffffffffc0204df0:	0585                	addi	a1,a1,1
ffffffffc0204df2:	0785                	addi	a5,a5,1
ffffffffc0204df4:	fee78fa3          	sb	a4,-1(a5)
ffffffffc0204df8:	fec59ae3          	bne	a1,a2,ffffffffc0204dec <memcpy+0x6>
ffffffffc0204dfc:	8082                	ret

ffffffffc0204dfe <memcmp>:
ffffffffc0204dfe:	c205                	beqz	a2,ffffffffc0204e1e <memcmp+0x20>
ffffffffc0204e00:	962e                	add	a2,a2,a1
ffffffffc0204e02:	a019                	j	ffffffffc0204e08 <memcmp+0xa>
ffffffffc0204e04:	00c58d63          	beq	a1,a2,ffffffffc0204e1e <memcmp+0x20>
ffffffffc0204e08:	00054783          	lbu	a5,0(a0)
ffffffffc0204e0c:	0005c703          	lbu	a4,0(a1)
ffffffffc0204e10:	0505                	addi	a0,a0,1
ffffffffc0204e12:	0585                	addi	a1,a1,1
ffffffffc0204e14:	fee788e3          	beq	a5,a4,ffffffffc0204e04 <memcmp+0x6>
ffffffffc0204e18:	40e7853b          	subw	a0,a5,a4
ffffffffc0204e1c:	8082                	ret
ffffffffc0204e1e:	4501                	li	a0,0
ffffffffc0204e20:	8082                	ret
