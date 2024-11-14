
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
ffffffffc0200036:	00e50513          	addi	a0,a0,14 # ffffffffc020a040 <ide>
ffffffffc020003a:	00011617          	auipc	a2,0x11
ffffffffc020003e:	52a60613          	addi	a2,a2,1322 # ffffffffc0211564 <end>
ffffffffc0200042:	1141                	addi	sp,sp,-16
ffffffffc0200044:	8e09                	sub	a2,a2,a0
ffffffffc0200046:	4581                	li	a1,0
ffffffffc0200048:	e406                	sd	ra,8(sp)
ffffffffc020004a:	686040ef          	jal	ra,ffffffffc02046d0 <memset>
ffffffffc020004e:	00004597          	auipc	a1,0x4
ffffffffc0200052:	6b258593          	addi	a1,a1,1714 # ffffffffc0204700 <etext+0x6>
ffffffffc0200056:	00004517          	auipc	a0,0x4
ffffffffc020005a:	6ca50513          	addi	a0,a0,1738 # ffffffffc0204720 <etext+0x26>
ffffffffc020005e:	05c000ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc0200062:	0a0000ef          	jal	ra,ffffffffc0200102 <print_kerninfo>
ffffffffc0200066:	251010ef          	jal	ra,ffffffffc0201ab6 <pmm_init>
ffffffffc020006a:	4fa000ef          	jal	ra,ffffffffc0200564 <idt_init>
ffffffffc020006e:	121030ef          	jal	ra,ffffffffc020398e <vmm_init>
ffffffffc0200072:	420000ef          	jal	ra,ffffffffc0200492 <ide_init>
ffffffffc0200076:	0a5020ef          	jal	ra,ffffffffc020291a <swap_init>
ffffffffc020007a:	356000ef          	jal	ra,ffffffffc02003d0 <clock_init>
ffffffffc020007e:	a001                	j	ffffffffc020007e <kern_init+0x4c>

ffffffffc0200080 <cputch>:
ffffffffc0200080:	1141                	addi	sp,sp,-16
ffffffffc0200082:	e022                	sd	s0,0(sp)
ffffffffc0200084:	e406                	sd	ra,8(sp)
ffffffffc0200086:	842e                	mv	s0,a1
ffffffffc0200088:	39a000ef          	jal	ra,ffffffffc0200422 <cons_putc>
ffffffffc020008c:	401c                	lw	a5,0(s0)
ffffffffc020008e:	60a2                	ld	ra,8(sp)
ffffffffc0200090:	2785                	addiw	a5,a5,1
ffffffffc0200092:	c01c                	sw	a5,0(s0)
ffffffffc0200094:	6402                	ld	s0,0(sp)
ffffffffc0200096:	0141                	addi	sp,sp,16
ffffffffc0200098:	8082                	ret

ffffffffc020009a <vcprintf>:
ffffffffc020009a:	1101                	addi	sp,sp,-32
ffffffffc020009c:	862a                	mv	a2,a0
ffffffffc020009e:	86ae                	mv	a3,a1
ffffffffc02000a0:	00000517          	auipc	a0,0x0
ffffffffc02000a4:	fe050513          	addi	a0,a0,-32 # ffffffffc0200080 <cputch>
ffffffffc02000a8:	006c                	addi	a1,sp,12
ffffffffc02000aa:	ec06                	sd	ra,24(sp)
ffffffffc02000ac:	c602                	sw	zero,12(sp)
ffffffffc02000ae:	170040ef          	jal	ra,ffffffffc020421e <vprintfmt>
ffffffffc02000b2:	60e2                	ld	ra,24(sp)
ffffffffc02000b4:	4532                	lw	a0,12(sp)
ffffffffc02000b6:	6105                	addi	sp,sp,32
ffffffffc02000b8:	8082                	ret

ffffffffc02000ba <cprintf>:
ffffffffc02000ba:	711d                	addi	sp,sp,-96
ffffffffc02000bc:	02810313          	addi	t1,sp,40 # ffffffffc0209028 <boot_page_table_sv39+0x28>
ffffffffc02000c0:	8e2a                	mv	t3,a0
ffffffffc02000c2:	f42e                	sd	a1,40(sp)
ffffffffc02000c4:	f832                	sd	a2,48(sp)
ffffffffc02000c6:	fc36                	sd	a3,56(sp)
ffffffffc02000c8:	00000517          	auipc	a0,0x0
ffffffffc02000cc:	fb850513          	addi	a0,a0,-72 # ffffffffc0200080 <cputch>
ffffffffc02000d0:	004c                	addi	a1,sp,4
ffffffffc02000d2:	869a                	mv	a3,t1
ffffffffc02000d4:	8672                	mv	a2,t3
ffffffffc02000d6:	ec06                	sd	ra,24(sp)
ffffffffc02000d8:	e0ba                	sd	a4,64(sp)
ffffffffc02000da:	e4be                	sd	a5,72(sp)
ffffffffc02000dc:	e8c2                	sd	a6,80(sp)
ffffffffc02000de:	ecc6                	sd	a7,88(sp)
ffffffffc02000e0:	e41a                	sd	t1,8(sp)
ffffffffc02000e2:	c202                	sw	zero,4(sp)
ffffffffc02000e4:	13a040ef          	jal	ra,ffffffffc020421e <vprintfmt>
ffffffffc02000e8:	60e2                	ld	ra,24(sp)
ffffffffc02000ea:	4512                	lw	a0,4(sp)
ffffffffc02000ec:	6125                	addi	sp,sp,96
ffffffffc02000ee:	8082                	ret

ffffffffc02000f0 <cputchar>:
ffffffffc02000f0:	ae0d                	j	ffffffffc0200422 <cons_putc>

ffffffffc02000f2 <getchar>:
ffffffffc02000f2:	1141                	addi	sp,sp,-16
ffffffffc02000f4:	e406                	sd	ra,8(sp)
ffffffffc02000f6:	360000ef          	jal	ra,ffffffffc0200456 <cons_getc>
ffffffffc02000fa:	dd75                	beqz	a0,ffffffffc02000f6 <getchar+0x4>
ffffffffc02000fc:	60a2                	ld	ra,8(sp)
ffffffffc02000fe:	0141                	addi	sp,sp,16
ffffffffc0200100:	8082                	ret

ffffffffc0200102 <print_kerninfo>:
ffffffffc0200102:	1141                	addi	sp,sp,-16
ffffffffc0200104:	00004517          	auipc	a0,0x4
ffffffffc0200108:	62450513          	addi	a0,a0,1572 # ffffffffc0204728 <etext+0x2e>
ffffffffc020010c:	e406                	sd	ra,8(sp)
ffffffffc020010e:	fadff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc0200112:	00000597          	auipc	a1,0x0
ffffffffc0200116:	f2058593          	addi	a1,a1,-224 # ffffffffc0200032 <kern_init>
ffffffffc020011a:	00004517          	auipc	a0,0x4
ffffffffc020011e:	62e50513          	addi	a0,a0,1582 # ffffffffc0204748 <etext+0x4e>
ffffffffc0200122:	f99ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc0200126:	00004597          	auipc	a1,0x4
ffffffffc020012a:	5d458593          	addi	a1,a1,1492 # ffffffffc02046fa <etext>
ffffffffc020012e:	00004517          	auipc	a0,0x4
ffffffffc0200132:	63a50513          	addi	a0,a0,1594 # ffffffffc0204768 <etext+0x6e>
ffffffffc0200136:	f85ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc020013a:	0000a597          	auipc	a1,0xa
ffffffffc020013e:	f0658593          	addi	a1,a1,-250 # ffffffffc020a040 <ide>
ffffffffc0200142:	00004517          	auipc	a0,0x4
ffffffffc0200146:	64650513          	addi	a0,a0,1606 # ffffffffc0204788 <etext+0x8e>
ffffffffc020014a:	f71ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc020014e:	00011597          	auipc	a1,0x11
ffffffffc0200152:	41658593          	addi	a1,a1,1046 # ffffffffc0211564 <end>
ffffffffc0200156:	00004517          	auipc	a0,0x4
ffffffffc020015a:	65250513          	addi	a0,a0,1618 # ffffffffc02047a8 <etext+0xae>
ffffffffc020015e:	f5dff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc0200162:	00012597          	auipc	a1,0x12
ffffffffc0200166:	80158593          	addi	a1,a1,-2047 # ffffffffc0211963 <end+0x3ff>
ffffffffc020016a:	00000797          	auipc	a5,0x0
ffffffffc020016e:	ec878793          	addi	a5,a5,-312 # ffffffffc0200032 <kern_init>
ffffffffc0200172:	40f587b3          	sub	a5,a1,a5
ffffffffc0200176:	43f7d593          	srai	a1,a5,0x3f
ffffffffc020017a:	60a2                	ld	ra,8(sp)
ffffffffc020017c:	3ff5f593          	andi	a1,a1,1023
ffffffffc0200180:	95be                	add	a1,a1,a5
ffffffffc0200182:	85a9                	srai	a1,a1,0xa
ffffffffc0200184:	00004517          	auipc	a0,0x4
ffffffffc0200188:	64450513          	addi	a0,a0,1604 # ffffffffc02047c8 <etext+0xce>
ffffffffc020018c:	0141                	addi	sp,sp,16
ffffffffc020018e:	b735                	j	ffffffffc02000ba <cprintf>

ffffffffc0200190 <print_stackframe>:
ffffffffc0200190:	1141                	addi	sp,sp,-16
ffffffffc0200192:	00004617          	auipc	a2,0x4
ffffffffc0200196:	66660613          	addi	a2,a2,1638 # ffffffffc02047f8 <etext+0xfe>
ffffffffc020019a:	04e00593          	li	a1,78
ffffffffc020019e:	00004517          	auipc	a0,0x4
ffffffffc02001a2:	67250513          	addi	a0,a0,1650 # ffffffffc0204810 <etext+0x116>
ffffffffc02001a6:	e406                	sd	ra,8(sp)
ffffffffc02001a8:	1cc000ef          	jal	ra,ffffffffc0200374 <__panic>

ffffffffc02001ac <mon_help>:
ffffffffc02001ac:	1141                	addi	sp,sp,-16
ffffffffc02001ae:	00004617          	auipc	a2,0x4
ffffffffc02001b2:	67a60613          	addi	a2,a2,1658 # ffffffffc0204828 <etext+0x12e>
ffffffffc02001b6:	00004597          	auipc	a1,0x4
ffffffffc02001ba:	69258593          	addi	a1,a1,1682 # ffffffffc0204848 <etext+0x14e>
ffffffffc02001be:	00004517          	auipc	a0,0x4
ffffffffc02001c2:	69250513          	addi	a0,a0,1682 # ffffffffc0204850 <etext+0x156>
ffffffffc02001c6:	e406                	sd	ra,8(sp)
ffffffffc02001c8:	ef3ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc02001cc:	00004617          	auipc	a2,0x4
ffffffffc02001d0:	69460613          	addi	a2,a2,1684 # ffffffffc0204860 <etext+0x166>
ffffffffc02001d4:	00004597          	auipc	a1,0x4
ffffffffc02001d8:	6b458593          	addi	a1,a1,1716 # ffffffffc0204888 <etext+0x18e>
ffffffffc02001dc:	00004517          	auipc	a0,0x4
ffffffffc02001e0:	67450513          	addi	a0,a0,1652 # ffffffffc0204850 <etext+0x156>
ffffffffc02001e4:	ed7ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc02001e8:	00004617          	auipc	a2,0x4
ffffffffc02001ec:	6b060613          	addi	a2,a2,1712 # ffffffffc0204898 <etext+0x19e>
ffffffffc02001f0:	00004597          	auipc	a1,0x4
ffffffffc02001f4:	6c858593          	addi	a1,a1,1736 # ffffffffc02048b8 <etext+0x1be>
ffffffffc02001f8:	00004517          	auipc	a0,0x4
ffffffffc02001fc:	65850513          	addi	a0,a0,1624 # ffffffffc0204850 <etext+0x156>
ffffffffc0200200:	ebbff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc0200204:	60a2                	ld	ra,8(sp)
ffffffffc0200206:	4501                	li	a0,0
ffffffffc0200208:	0141                	addi	sp,sp,16
ffffffffc020020a:	8082                	ret

ffffffffc020020c <mon_kerninfo>:
ffffffffc020020c:	1141                	addi	sp,sp,-16
ffffffffc020020e:	e406                	sd	ra,8(sp)
ffffffffc0200210:	ef3ff0ef          	jal	ra,ffffffffc0200102 <print_kerninfo>
ffffffffc0200214:	60a2                	ld	ra,8(sp)
ffffffffc0200216:	4501                	li	a0,0
ffffffffc0200218:	0141                	addi	sp,sp,16
ffffffffc020021a:	8082                	ret

ffffffffc020021c <mon_backtrace>:
ffffffffc020021c:	1141                	addi	sp,sp,-16
ffffffffc020021e:	e406                	sd	ra,8(sp)
ffffffffc0200220:	f71ff0ef          	jal	ra,ffffffffc0200190 <print_stackframe>
ffffffffc0200224:	60a2                	ld	ra,8(sp)
ffffffffc0200226:	4501                	li	a0,0
ffffffffc0200228:	0141                	addi	sp,sp,16
ffffffffc020022a:	8082                	ret

ffffffffc020022c <kmonitor>:
ffffffffc020022c:	7115                	addi	sp,sp,-224
ffffffffc020022e:	ed5e                	sd	s7,152(sp)
ffffffffc0200230:	8baa                	mv	s7,a0
ffffffffc0200232:	00004517          	auipc	a0,0x4
ffffffffc0200236:	69650513          	addi	a0,a0,1686 # ffffffffc02048c8 <etext+0x1ce>
ffffffffc020023a:	ed86                	sd	ra,216(sp)
ffffffffc020023c:	e9a2                	sd	s0,208(sp)
ffffffffc020023e:	e5a6                	sd	s1,200(sp)
ffffffffc0200240:	e1ca                	sd	s2,192(sp)
ffffffffc0200242:	fd4e                	sd	s3,184(sp)
ffffffffc0200244:	f952                	sd	s4,176(sp)
ffffffffc0200246:	f556                	sd	s5,168(sp)
ffffffffc0200248:	f15a                	sd	s6,160(sp)
ffffffffc020024a:	e962                	sd	s8,144(sp)
ffffffffc020024c:	e566                	sd	s9,136(sp)
ffffffffc020024e:	e16a                	sd	s10,128(sp)
ffffffffc0200250:	e6bff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc0200254:	00004517          	auipc	a0,0x4
ffffffffc0200258:	69c50513          	addi	a0,a0,1692 # ffffffffc02048f0 <etext+0x1f6>
ffffffffc020025c:	e5fff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc0200260:	000b8563          	beqz	s7,ffffffffc020026a <kmonitor+0x3e>
ffffffffc0200264:	855e                	mv	a0,s7
ffffffffc0200266:	4e8000ef          	jal	ra,ffffffffc020074e <print_trapframe>
ffffffffc020026a:	00004c17          	auipc	s8,0x4
ffffffffc020026e:	6eec0c13          	addi	s8,s8,1774 # ffffffffc0204958 <commands>
ffffffffc0200272:	00006917          	auipc	s2,0x6
ffffffffc0200276:	af690913          	addi	s2,s2,-1290 # ffffffffc0205d68 <default_pmm_manager+0x928>
ffffffffc020027a:	00004497          	auipc	s1,0x4
ffffffffc020027e:	69e48493          	addi	s1,s1,1694 # ffffffffc0204918 <etext+0x21e>
ffffffffc0200282:	49bd                	li	s3,15
ffffffffc0200284:	00004b17          	auipc	s6,0x4
ffffffffc0200288:	69cb0b13          	addi	s6,s6,1692 # ffffffffc0204920 <etext+0x226>
ffffffffc020028c:	00004a17          	auipc	s4,0x4
ffffffffc0200290:	5bca0a13          	addi	s4,s4,1468 # ffffffffc0204848 <etext+0x14e>
ffffffffc0200294:	4a8d                	li	s5,3
ffffffffc0200296:	854a                	mv	a0,s2
ffffffffc0200298:	308040ef          	jal	ra,ffffffffc02045a0 <readline>
ffffffffc020029c:	842a                	mv	s0,a0
ffffffffc020029e:	dd65                	beqz	a0,ffffffffc0200296 <kmonitor+0x6a>
ffffffffc02002a0:	00054583          	lbu	a1,0(a0)
ffffffffc02002a4:	4c81                	li	s9,0
ffffffffc02002a6:	e1bd                	bnez	a1,ffffffffc020030c <kmonitor+0xe0>
ffffffffc02002a8:	fe0c87e3          	beqz	s9,ffffffffc0200296 <kmonitor+0x6a>
ffffffffc02002ac:	6582                	ld	a1,0(sp)
ffffffffc02002ae:	00004d17          	auipc	s10,0x4
ffffffffc02002b2:	6aad0d13          	addi	s10,s10,1706 # ffffffffc0204958 <commands>
ffffffffc02002b6:	8552                	mv	a0,s4
ffffffffc02002b8:	4401                	li	s0,0
ffffffffc02002ba:	0d61                	addi	s10,s10,24
ffffffffc02002bc:	3e0040ef          	jal	ra,ffffffffc020469c <strcmp>
ffffffffc02002c0:	c919                	beqz	a0,ffffffffc02002d6 <kmonitor+0xaa>
ffffffffc02002c2:	2405                	addiw	s0,s0,1
ffffffffc02002c4:	0b540063          	beq	s0,s5,ffffffffc0200364 <kmonitor+0x138>
ffffffffc02002c8:	000d3503          	ld	a0,0(s10)
ffffffffc02002cc:	6582                	ld	a1,0(sp)
ffffffffc02002ce:	0d61                	addi	s10,s10,24
ffffffffc02002d0:	3cc040ef          	jal	ra,ffffffffc020469c <strcmp>
ffffffffc02002d4:	f57d                	bnez	a0,ffffffffc02002c2 <kmonitor+0x96>
ffffffffc02002d6:	00141793          	slli	a5,s0,0x1
ffffffffc02002da:	97a2                	add	a5,a5,s0
ffffffffc02002dc:	078e                	slli	a5,a5,0x3
ffffffffc02002de:	97e2                	add	a5,a5,s8
ffffffffc02002e0:	6b9c                	ld	a5,16(a5)
ffffffffc02002e2:	865e                	mv	a2,s7
ffffffffc02002e4:	002c                	addi	a1,sp,8
ffffffffc02002e6:	fffc851b          	addiw	a0,s9,-1
ffffffffc02002ea:	9782                	jalr	a5
ffffffffc02002ec:	fa0555e3          	bgez	a0,ffffffffc0200296 <kmonitor+0x6a>
ffffffffc02002f0:	60ee                	ld	ra,216(sp)
ffffffffc02002f2:	644e                	ld	s0,208(sp)
ffffffffc02002f4:	64ae                	ld	s1,200(sp)
ffffffffc02002f6:	690e                	ld	s2,192(sp)
ffffffffc02002f8:	79ea                	ld	s3,184(sp)
ffffffffc02002fa:	7a4a                	ld	s4,176(sp)
ffffffffc02002fc:	7aaa                	ld	s5,168(sp)
ffffffffc02002fe:	7b0a                	ld	s6,160(sp)
ffffffffc0200300:	6bea                	ld	s7,152(sp)
ffffffffc0200302:	6c4a                	ld	s8,144(sp)
ffffffffc0200304:	6caa                	ld	s9,136(sp)
ffffffffc0200306:	6d0a                	ld	s10,128(sp)
ffffffffc0200308:	612d                	addi	sp,sp,224
ffffffffc020030a:	8082                	ret
ffffffffc020030c:	8526                	mv	a0,s1
ffffffffc020030e:	3ac040ef          	jal	ra,ffffffffc02046ba <strchr>
ffffffffc0200312:	c901                	beqz	a0,ffffffffc0200322 <kmonitor+0xf6>
ffffffffc0200314:	00144583          	lbu	a1,1(s0)
ffffffffc0200318:	00040023          	sb	zero,0(s0)
ffffffffc020031c:	0405                	addi	s0,s0,1
ffffffffc020031e:	d5c9                	beqz	a1,ffffffffc02002a8 <kmonitor+0x7c>
ffffffffc0200320:	b7f5                	j	ffffffffc020030c <kmonitor+0xe0>
ffffffffc0200322:	00044783          	lbu	a5,0(s0)
ffffffffc0200326:	d3c9                	beqz	a5,ffffffffc02002a8 <kmonitor+0x7c>
ffffffffc0200328:	033c8963          	beq	s9,s3,ffffffffc020035a <kmonitor+0x12e>
ffffffffc020032c:	003c9793          	slli	a5,s9,0x3
ffffffffc0200330:	0118                	addi	a4,sp,128
ffffffffc0200332:	97ba                	add	a5,a5,a4
ffffffffc0200334:	f887b023          	sd	s0,-128(a5)
ffffffffc0200338:	00044583          	lbu	a1,0(s0)
ffffffffc020033c:	2c85                	addiw	s9,s9,1
ffffffffc020033e:	e591                	bnez	a1,ffffffffc020034a <kmonitor+0x11e>
ffffffffc0200340:	b7b5                	j	ffffffffc02002ac <kmonitor+0x80>
ffffffffc0200342:	00144583          	lbu	a1,1(s0)
ffffffffc0200346:	0405                	addi	s0,s0,1
ffffffffc0200348:	d1a5                	beqz	a1,ffffffffc02002a8 <kmonitor+0x7c>
ffffffffc020034a:	8526                	mv	a0,s1
ffffffffc020034c:	36e040ef          	jal	ra,ffffffffc02046ba <strchr>
ffffffffc0200350:	d96d                	beqz	a0,ffffffffc0200342 <kmonitor+0x116>
ffffffffc0200352:	00044583          	lbu	a1,0(s0)
ffffffffc0200356:	d9a9                	beqz	a1,ffffffffc02002a8 <kmonitor+0x7c>
ffffffffc0200358:	bf55                	j	ffffffffc020030c <kmonitor+0xe0>
ffffffffc020035a:	45c1                	li	a1,16
ffffffffc020035c:	855a                	mv	a0,s6
ffffffffc020035e:	d5dff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc0200362:	b7e9                	j	ffffffffc020032c <kmonitor+0x100>
ffffffffc0200364:	6582                	ld	a1,0(sp)
ffffffffc0200366:	00004517          	auipc	a0,0x4
ffffffffc020036a:	5da50513          	addi	a0,a0,1498 # ffffffffc0204940 <etext+0x246>
ffffffffc020036e:	d4dff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc0200372:	b715                	j	ffffffffc0200296 <kmonitor+0x6a>

ffffffffc0200374 <__panic>:
ffffffffc0200374:	00011317          	auipc	t1,0x11
ffffffffc0200378:	18430313          	addi	t1,t1,388 # ffffffffc02114f8 <is_panic>
ffffffffc020037c:	00032e03          	lw	t3,0(t1)
ffffffffc0200380:	715d                	addi	sp,sp,-80
ffffffffc0200382:	ec06                	sd	ra,24(sp)
ffffffffc0200384:	e822                	sd	s0,16(sp)
ffffffffc0200386:	f436                	sd	a3,40(sp)
ffffffffc0200388:	f83a                	sd	a4,48(sp)
ffffffffc020038a:	fc3e                	sd	a5,56(sp)
ffffffffc020038c:	e0c2                	sd	a6,64(sp)
ffffffffc020038e:	e4c6                	sd	a7,72(sp)
ffffffffc0200390:	020e1a63          	bnez	t3,ffffffffc02003c4 <__panic+0x50>
ffffffffc0200394:	4785                	li	a5,1
ffffffffc0200396:	00f32023          	sw	a5,0(t1)
ffffffffc020039a:	8432                	mv	s0,a2
ffffffffc020039c:	103c                	addi	a5,sp,40
ffffffffc020039e:	862e                	mv	a2,a1
ffffffffc02003a0:	85aa                	mv	a1,a0
ffffffffc02003a2:	00004517          	auipc	a0,0x4
ffffffffc02003a6:	5fe50513          	addi	a0,a0,1534 # ffffffffc02049a0 <commands+0x48>
ffffffffc02003aa:	e43e                	sd	a5,8(sp)
ffffffffc02003ac:	d0fff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc02003b0:	65a2                	ld	a1,8(sp)
ffffffffc02003b2:	8522                	mv	a0,s0
ffffffffc02003b4:	ce7ff0ef          	jal	ra,ffffffffc020009a <vcprintf>
ffffffffc02003b8:	00005517          	auipc	a0,0x5
ffffffffc02003bc:	50050513          	addi	a0,a0,1280 # ffffffffc02058b8 <default_pmm_manager+0x478>
ffffffffc02003c0:	cfbff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc02003c4:	12a000ef          	jal	ra,ffffffffc02004ee <intr_disable>
ffffffffc02003c8:	4501                	li	a0,0
ffffffffc02003ca:	e63ff0ef          	jal	ra,ffffffffc020022c <kmonitor>
ffffffffc02003ce:	bfed                	j	ffffffffc02003c8 <__panic+0x54>

ffffffffc02003d0 <clock_init>:
ffffffffc02003d0:	67e1                	lui	a5,0x18
ffffffffc02003d2:	6a078793          	addi	a5,a5,1696 # 186a0 <kern_entry-0xffffffffc01e7960>
ffffffffc02003d6:	00011717          	auipc	a4,0x11
ffffffffc02003da:	12f73923          	sd	a5,306(a4) # ffffffffc0211508 <timebase>
ffffffffc02003de:	c0102573          	rdtime	a0
ffffffffc02003e2:	4581                	li	a1,0
ffffffffc02003e4:	953e                	add	a0,a0,a5
ffffffffc02003e6:	4601                	li	a2,0
ffffffffc02003e8:	4881                	li	a7,0
ffffffffc02003ea:	00000073          	ecall
ffffffffc02003ee:	02000793          	li	a5,32
ffffffffc02003f2:	1047a7f3          	csrrs	a5,sie,a5
ffffffffc02003f6:	00004517          	auipc	a0,0x4
ffffffffc02003fa:	5ca50513          	addi	a0,a0,1482 # ffffffffc02049c0 <commands+0x68>
ffffffffc02003fe:	00011797          	auipc	a5,0x11
ffffffffc0200402:	1007b123          	sd	zero,258(a5) # ffffffffc0211500 <ticks>
ffffffffc0200406:	b955                	j	ffffffffc02000ba <cprintf>

ffffffffc0200408 <clock_set_next_event>:
ffffffffc0200408:	c0102573          	rdtime	a0
ffffffffc020040c:	00011797          	auipc	a5,0x11
ffffffffc0200410:	0fc7b783          	ld	a5,252(a5) # ffffffffc0211508 <timebase>
ffffffffc0200414:	953e                	add	a0,a0,a5
ffffffffc0200416:	4581                	li	a1,0
ffffffffc0200418:	4601                	li	a2,0
ffffffffc020041a:	4881                	li	a7,0
ffffffffc020041c:	00000073          	ecall
ffffffffc0200420:	8082                	ret

ffffffffc0200422 <cons_putc>:
ffffffffc0200422:	100027f3          	csrr	a5,sstatus
ffffffffc0200426:	8b89                	andi	a5,a5,2
ffffffffc0200428:	0ff57513          	zext.b	a0,a0
ffffffffc020042c:	e799                	bnez	a5,ffffffffc020043a <cons_putc+0x18>
ffffffffc020042e:	4581                	li	a1,0
ffffffffc0200430:	4601                	li	a2,0
ffffffffc0200432:	4885                	li	a7,1
ffffffffc0200434:	00000073          	ecall
ffffffffc0200438:	8082                	ret
ffffffffc020043a:	1101                	addi	sp,sp,-32
ffffffffc020043c:	ec06                	sd	ra,24(sp)
ffffffffc020043e:	e42a                	sd	a0,8(sp)
ffffffffc0200440:	0ae000ef          	jal	ra,ffffffffc02004ee <intr_disable>
ffffffffc0200444:	6522                	ld	a0,8(sp)
ffffffffc0200446:	4581                	li	a1,0
ffffffffc0200448:	4601                	li	a2,0
ffffffffc020044a:	4885                	li	a7,1
ffffffffc020044c:	00000073          	ecall
ffffffffc0200450:	60e2                	ld	ra,24(sp)
ffffffffc0200452:	6105                	addi	sp,sp,32
ffffffffc0200454:	a851                	j	ffffffffc02004e8 <intr_enable>

ffffffffc0200456 <cons_getc>:
ffffffffc0200456:	100027f3          	csrr	a5,sstatus
ffffffffc020045a:	8b89                	andi	a5,a5,2
ffffffffc020045c:	eb89                	bnez	a5,ffffffffc020046e <cons_getc+0x18>
ffffffffc020045e:	4501                	li	a0,0
ffffffffc0200460:	4581                	li	a1,0
ffffffffc0200462:	4601                	li	a2,0
ffffffffc0200464:	4889                	li	a7,2
ffffffffc0200466:	00000073          	ecall
ffffffffc020046a:	2501                	sext.w	a0,a0
ffffffffc020046c:	8082                	ret
ffffffffc020046e:	1101                	addi	sp,sp,-32
ffffffffc0200470:	ec06                	sd	ra,24(sp)
ffffffffc0200472:	07c000ef          	jal	ra,ffffffffc02004ee <intr_disable>
ffffffffc0200476:	4501                	li	a0,0
ffffffffc0200478:	4581                	li	a1,0
ffffffffc020047a:	4601                	li	a2,0
ffffffffc020047c:	4889                	li	a7,2
ffffffffc020047e:	00000073          	ecall
ffffffffc0200482:	2501                	sext.w	a0,a0
ffffffffc0200484:	e42a                	sd	a0,8(sp)
ffffffffc0200486:	062000ef          	jal	ra,ffffffffc02004e8 <intr_enable>
ffffffffc020048a:	60e2                	ld	ra,24(sp)
ffffffffc020048c:	6522                	ld	a0,8(sp)
ffffffffc020048e:	6105                	addi	sp,sp,32
ffffffffc0200490:	8082                	ret

ffffffffc0200492 <ide_init>:
ffffffffc0200492:	8082                	ret

ffffffffc0200494 <ide_device_valid>:
ffffffffc0200494:	00253513          	sltiu	a0,a0,2
ffffffffc0200498:	8082                	ret

ffffffffc020049a <ide_device_size>:
ffffffffc020049a:	03800513          	li	a0,56
ffffffffc020049e:	8082                	ret

ffffffffc02004a0 <ide_read_secs>:
ffffffffc02004a0:	0000a797          	auipc	a5,0xa
ffffffffc02004a4:	ba078793          	addi	a5,a5,-1120 # ffffffffc020a040 <ide>
ffffffffc02004a8:	0095959b          	slliw	a1,a1,0x9
ffffffffc02004ac:	1141                	addi	sp,sp,-16
ffffffffc02004ae:	8532                	mv	a0,a2
ffffffffc02004b0:	95be                	add	a1,a1,a5
ffffffffc02004b2:	00969613          	slli	a2,a3,0x9
ffffffffc02004b6:	e406                	sd	ra,8(sp)
ffffffffc02004b8:	22a040ef          	jal	ra,ffffffffc02046e2 <memcpy>
ffffffffc02004bc:	60a2                	ld	ra,8(sp)
ffffffffc02004be:	4501                	li	a0,0
ffffffffc02004c0:	0141                	addi	sp,sp,16
ffffffffc02004c2:	8082                	ret

ffffffffc02004c4 <ide_write_secs>:
ffffffffc02004c4:	0095979b          	slliw	a5,a1,0x9
ffffffffc02004c8:	0000a517          	auipc	a0,0xa
ffffffffc02004cc:	b7850513          	addi	a0,a0,-1160 # ffffffffc020a040 <ide>
ffffffffc02004d0:	1141                	addi	sp,sp,-16
ffffffffc02004d2:	85b2                	mv	a1,a2
ffffffffc02004d4:	953e                	add	a0,a0,a5
ffffffffc02004d6:	00969613          	slli	a2,a3,0x9
ffffffffc02004da:	e406                	sd	ra,8(sp)
ffffffffc02004dc:	206040ef          	jal	ra,ffffffffc02046e2 <memcpy>
ffffffffc02004e0:	60a2                	ld	ra,8(sp)
ffffffffc02004e2:	4501                	li	a0,0
ffffffffc02004e4:	0141                	addi	sp,sp,16
ffffffffc02004e6:	8082                	ret

ffffffffc02004e8 <intr_enable>:
ffffffffc02004e8:	100167f3          	csrrsi	a5,sstatus,2
ffffffffc02004ec:	8082                	ret

ffffffffc02004ee <intr_disable>:
ffffffffc02004ee:	100177f3          	csrrci	a5,sstatus,2
ffffffffc02004f2:	8082                	ret

ffffffffc02004f4 <pgfault_handler>:
ffffffffc02004f4:	10053783          	ld	a5,256(a0)
ffffffffc02004f8:	1141                	addi	sp,sp,-16
ffffffffc02004fa:	e022                	sd	s0,0(sp)
ffffffffc02004fc:	e406                	sd	ra,8(sp)
ffffffffc02004fe:	1007f793          	andi	a5,a5,256
ffffffffc0200502:	11053583          	ld	a1,272(a0)
ffffffffc0200506:	842a                	mv	s0,a0
ffffffffc0200508:	05500613          	li	a2,85
ffffffffc020050c:	c399                	beqz	a5,ffffffffc0200512 <pgfault_handler+0x1e>
ffffffffc020050e:	04b00613          	li	a2,75
ffffffffc0200512:	11843703          	ld	a4,280(s0)
ffffffffc0200516:	47bd                	li	a5,15
ffffffffc0200518:	05700693          	li	a3,87
ffffffffc020051c:	00f70463          	beq	a4,a5,ffffffffc0200524 <pgfault_handler+0x30>
ffffffffc0200520:	05200693          	li	a3,82
ffffffffc0200524:	00004517          	auipc	a0,0x4
ffffffffc0200528:	4bc50513          	addi	a0,a0,1212 # ffffffffc02049e0 <commands+0x88>
ffffffffc020052c:	b8fff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc0200530:	00011517          	auipc	a0,0x11
ffffffffc0200534:	02853503          	ld	a0,40(a0) # ffffffffc0211558 <check_mm_struct>
ffffffffc0200538:	c911                	beqz	a0,ffffffffc020054c <pgfault_handler+0x58>
ffffffffc020053a:	11043603          	ld	a2,272(s0)
ffffffffc020053e:	11843583          	ld	a1,280(s0)
ffffffffc0200542:	6402                	ld	s0,0(sp)
ffffffffc0200544:	60a2                	ld	ra,8(sp)
ffffffffc0200546:	0141                	addi	sp,sp,16
ffffffffc0200548:	21f0306f          	j	ffffffffc0203f66 <do_pgfault>
ffffffffc020054c:	00004617          	auipc	a2,0x4
ffffffffc0200550:	4b460613          	addi	a2,a2,1204 # ffffffffc0204a00 <commands+0xa8>
ffffffffc0200554:	07800593          	li	a1,120
ffffffffc0200558:	00004517          	auipc	a0,0x4
ffffffffc020055c:	4c050513          	addi	a0,a0,1216 # ffffffffc0204a18 <commands+0xc0>
ffffffffc0200560:	e15ff0ef          	jal	ra,ffffffffc0200374 <__panic>

ffffffffc0200564 <idt_init>:
ffffffffc0200564:	14005073          	csrwi	sscratch,0
ffffffffc0200568:	00000797          	auipc	a5,0x0
ffffffffc020056c:	48878793          	addi	a5,a5,1160 # ffffffffc02009f0 <__alltraps>
ffffffffc0200570:	10579073          	csrw	stvec,a5
ffffffffc0200574:	100167f3          	csrrsi	a5,sstatus,2
ffffffffc0200578:	000407b7          	lui	a5,0x40
ffffffffc020057c:	1007a7f3          	csrrs	a5,sstatus,a5
ffffffffc0200580:	8082                	ret

ffffffffc0200582 <print_regs>:
ffffffffc0200582:	610c                	ld	a1,0(a0)
ffffffffc0200584:	1141                	addi	sp,sp,-16
ffffffffc0200586:	e022                	sd	s0,0(sp)
ffffffffc0200588:	842a                	mv	s0,a0
ffffffffc020058a:	00004517          	auipc	a0,0x4
ffffffffc020058e:	4a650513          	addi	a0,a0,1190 # ffffffffc0204a30 <commands+0xd8>
ffffffffc0200592:	e406                	sd	ra,8(sp)
ffffffffc0200594:	b27ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc0200598:	640c                	ld	a1,8(s0)
ffffffffc020059a:	00004517          	auipc	a0,0x4
ffffffffc020059e:	4ae50513          	addi	a0,a0,1198 # ffffffffc0204a48 <commands+0xf0>
ffffffffc02005a2:	b19ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc02005a6:	680c                	ld	a1,16(s0)
ffffffffc02005a8:	00004517          	auipc	a0,0x4
ffffffffc02005ac:	4b850513          	addi	a0,a0,1208 # ffffffffc0204a60 <commands+0x108>
ffffffffc02005b0:	b0bff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc02005b4:	6c0c                	ld	a1,24(s0)
ffffffffc02005b6:	00004517          	auipc	a0,0x4
ffffffffc02005ba:	4c250513          	addi	a0,a0,1218 # ffffffffc0204a78 <commands+0x120>
ffffffffc02005be:	afdff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc02005c2:	700c                	ld	a1,32(s0)
ffffffffc02005c4:	00004517          	auipc	a0,0x4
ffffffffc02005c8:	4cc50513          	addi	a0,a0,1228 # ffffffffc0204a90 <commands+0x138>
ffffffffc02005cc:	aefff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc02005d0:	740c                	ld	a1,40(s0)
ffffffffc02005d2:	00004517          	auipc	a0,0x4
ffffffffc02005d6:	4d650513          	addi	a0,a0,1238 # ffffffffc0204aa8 <commands+0x150>
ffffffffc02005da:	ae1ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc02005de:	780c                	ld	a1,48(s0)
ffffffffc02005e0:	00004517          	auipc	a0,0x4
ffffffffc02005e4:	4e050513          	addi	a0,a0,1248 # ffffffffc0204ac0 <commands+0x168>
ffffffffc02005e8:	ad3ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc02005ec:	7c0c                	ld	a1,56(s0)
ffffffffc02005ee:	00004517          	auipc	a0,0x4
ffffffffc02005f2:	4ea50513          	addi	a0,a0,1258 # ffffffffc0204ad8 <commands+0x180>
ffffffffc02005f6:	ac5ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc02005fa:	602c                	ld	a1,64(s0)
ffffffffc02005fc:	00004517          	auipc	a0,0x4
ffffffffc0200600:	4f450513          	addi	a0,a0,1268 # ffffffffc0204af0 <commands+0x198>
ffffffffc0200604:	ab7ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc0200608:	642c                	ld	a1,72(s0)
ffffffffc020060a:	00004517          	auipc	a0,0x4
ffffffffc020060e:	4fe50513          	addi	a0,a0,1278 # ffffffffc0204b08 <commands+0x1b0>
ffffffffc0200612:	aa9ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc0200616:	682c                	ld	a1,80(s0)
ffffffffc0200618:	00004517          	auipc	a0,0x4
ffffffffc020061c:	50850513          	addi	a0,a0,1288 # ffffffffc0204b20 <commands+0x1c8>
ffffffffc0200620:	a9bff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc0200624:	6c2c                	ld	a1,88(s0)
ffffffffc0200626:	00004517          	auipc	a0,0x4
ffffffffc020062a:	51250513          	addi	a0,a0,1298 # ffffffffc0204b38 <commands+0x1e0>
ffffffffc020062e:	a8dff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc0200632:	702c                	ld	a1,96(s0)
ffffffffc0200634:	00004517          	auipc	a0,0x4
ffffffffc0200638:	51c50513          	addi	a0,a0,1308 # ffffffffc0204b50 <commands+0x1f8>
ffffffffc020063c:	a7fff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc0200640:	742c                	ld	a1,104(s0)
ffffffffc0200642:	00004517          	auipc	a0,0x4
ffffffffc0200646:	52650513          	addi	a0,a0,1318 # ffffffffc0204b68 <commands+0x210>
ffffffffc020064a:	a71ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc020064e:	782c                	ld	a1,112(s0)
ffffffffc0200650:	00004517          	auipc	a0,0x4
ffffffffc0200654:	53050513          	addi	a0,a0,1328 # ffffffffc0204b80 <commands+0x228>
ffffffffc0200658:	a63ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc020065c:	7c2c                	ld	a1,120(s0)
ffffffffc020065e:	00004517          	auipc	a0,0x4
ffffffffc0200662:	53a50513          	addi	a0,a0,1338 # ffffffffc0204b98 <commands+0x240>
ffffffffc0200666:	a55ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc020066a:	604c                	ld	a1,128(s0)
ffffffffc020066c:	00004517          	auipc	a0,0x4
ffffffffc0200670:	54450513          	addi	a0,a0,1348 # ffffffffc0204bb0 <commands+0x258>
ffffffffc0200674:	a47ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc0200678:	644c                	ld	a1,136(s0)
ffffffffc020067a:	00004517          	auipc	a0,0x4
ffffffffc020067e:	54e50513          	addi	a0,a0,1358 # ffffffffc0204bc8 <commands+0x270>
ffffffffc0200682:	a39ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc0200686:	684c                	ld	a1,144(s0)
ffffffffc0200688:	00004517          	auipc	a0,0x4
ffffffffc020068c:	55850513          	addi	a0,a0,1368 # ffffffffc0204be0 <commands+0x288>
ffffffffc0200690:	a2bff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc0200694:	6c4c                	ld	a1,152(s0)
ffffffffc0200696:	00004517          	auipc	a0,0x4
ffffffffc020069a:	56250513          	addi	a0,a0,1378 # ffffffffc0204bf8 <commands+0x2a0>
ffffffffc020069e:	a1dff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc02006a2:	704c                	ld	a1,160(s0)
ffffffffc02006a4:	00004517          	auipc	a0,0x4
ffffffffc02006a8:	56c50513          	addi	a0,a0,1388 # ffffffffc0204c10 <commands+0x2b8>
ffffffffc02006ac:	a0fff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc02006b0:	744c                	ld	a1,168(s0)
ffffffffc02006b2:	00004517          	auipc	a0,0x4
ffffffffc02006b6:	57650513          	addi	a0,a0,1398 # ffffffffc0204c28 <commands+0x2d0>
ffffffffc02006ba:	a01ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc02006be:	784c                	ld	a1,176(s0)
ffffffffc02006c0:	00004517          	auipc	a0,0x4
ffffffffc02006c4:	58050513          	addi	a0,a0,1408 # ffffffffc0204c40 <commands+0x2e8>
ffffffffc02006c8:	9f3ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc02006cc:	7c4c                	ld	a1,184(s0)
ffffffffc02006ce:	00004517          	auipc	a0,0x4
ffffffffc02006d2:	58a50513          	addi	a0,a0,1418 # ffffffffc0204c58 <commands+0x300>
ffffffffc02006d6:	9e5ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc02006da:	606c                	ld	a1,192(s0)
ffffffffc02006dc:	00004517          	auipc	a0,0x4
ffffffffc02006e0:	59450513          	addi	a0,a0,1428 # ffffffffc0204c70 <commands+0x318>
ffffffffc02006e4:	9d7ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc02006e8:	646c                	ld	a1,200(s0)
ffffffffc02006ea:	00004517          	auipc	a0,0x4
ffffffffc02006ee:	59e50513          	addi	a0,a0,1438 # ffffffffc0204c88 <commands+0x330>
ffffffffc02006f2:	9c9ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc02006f6:	686c                	ld	a1,208(s0)
ffffffffc02006f8:	00004517          	auipc	a0,0x4
ffffffffc02006fc:	5a850513          	addi	a0,a0,1448 # ffffffffc0204ca0 <commands+0x348>
ffffffffc0200700:	9bbff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc0200704:	6c6c                	ld	a1,216(s0)
ffffffffc0200706:	00004517          	auipc	a0,0x4
ffffffffc020070a:	5b250513          	addi	a0,a0,1458 # ffffffffc0204cb8 <commands+0x360>
ffffffffc020070e:	9adff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc0200712:	706c                	ld	a1,224(s0)
ffffffffc0200714:	00004517          	auipc	a0,0x4
ffffffffc0200718:	5bc50513          	addi	a0,a0,1468 # ffffffffc0204cd0 <commands+0x378>
ffffffffc020071c:	99fff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc0200720:	746c                	ld	a1,232(s0)
ffffffffc0200722:	00004517          	auipc	a0,0x4
ffffffffc0200726:	5c650513          	addi	a0,a0,1478 # ffffffffc0204ce8 <commands+0x390>
ffffffffc020072a:	991ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc020072e:	786c                	ld	a1,240(s0)
ffffffffc0200730:	00004517          	auipc	a0,0x4
ffffffffc0200734:	5d050513          	addi	a0,a0,1488 # ffffffffc0204d00 <commands+0x3a8>
ffffffffc0200738:	983ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc020073c:	7c6c                	ld	a1,248(s0)
ffffffffc020073e:	6402                	ld	s0,0(sp)
ffffffffc0200740:	60a2                	ld	ra,8(sp)
ffffffffc0200742:	00004517          	auipc	a0,0x4
ffffffffc0200746:	5d650513          	addi	a0,a0,1494 # ffffffffc0204d18 <commands+0x3c0>
ffffffffc020074a:	0141                	addi	sp,sp,16
ffffffffc020074c:	b2bd                	j	ffffffffc02000ba <cprintf>

ffffffffc020074e <print_trapframe>:
ffffffffc020074e:	1141                	addi	sp,sp,-16
ffffffffc0200750:	e022                	sd	s0,0(sp)
ffffffffc0200752:	85aa                	mv	a1,a0
ffffffffc0200754:	842a                	mv	s0,a0
ffffffffc0200756:	00004517          	auipc	a0,0x4
ffffffffc020075a:	5da50513          	addi	a0,a0,1498 # ffffffffc0204d30 <commands+0x3d8>
ffffffffc020075e:	e406                	sd	ra,8(sp)
ffffffffc0200760:	95bff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc0200764:	8522                	mv	a0,s0
ffffffffc0200766:	e1dff0ef          	jal	ra,ffffffffc0200582 <print_regs>
ffffffffc020076a:	10043583          	ld	a1,256(s0)
ffffffffc020076e:	00004517          	auipc	a0,0x4
ffffffffc0200772:	5da50513          	addi	a0,a0,1498 # ffffffffc0204d48 <commands+0x3f0>
ffffffffc0200776:	945ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc020077a:	10843583          	ld	a1,264(s0)
ffffffffc020077e:	00004517          	auipc	a0,0x4
ffffffffc0200782:	5e250513          	addi	a0,a0,1506 # ffffffffc0204d60 <commands+0x408>
ffffffffc0200786:	935ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc020078a:	11043583          	ld	a1,272(s0)
ffffffffc020078e:	00004517          	auipc	a0,0x4
ffffffffc0200792:	5ea50513          	addi	a0,a0,1514 # ffffffffc0204d78 <commands+0x420>
ffffffffc0200796:	925ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc020079a:	11843583          	ld	a1,280(s0)
ffffffffc020079e:	6402                	ld	s0,0(sp)
ffffffffc02007a0:	60a2                	ld	ra,8(sp)
ffffffffc02007a2:	00004517          	auipc	a0,0x4
ffffffffc02007a6:	5ee50513          	addi	a0,a0,1518 # ffffffffc0204d90 <commands+0x438>
ffffffffc02007aa:	0141                	addi	sp,sp,16
ffffffffc02007ac:	90fff06f          	j	ffffffffc02000ba <cprintf>

ffffffffc02007b0 <interrupt_handler>:
ffffffffc02007b0:	11853783          	ld	a5,280(a0)
ffffffffc02007b4:	472d                	li	a4,11
ffffffffc02007b6:	0786                	slli	a5,a5,0x1
ffffffffc02007b8:	8385                	srli	a5,a5,0x1
ffffffffc02007ba:	06f76c63          	bltu	a4,a5,ffffffffc0200832 <interrupt_handler+0x82>
ffffffffc02007be:	00004717          	auipc	a4,0x4
ffffffffc02007c2:	69a70713          	addi	a4,a4,1690 # ffffffffc0204e58 <commands+0x500>
ffffffffc02007c6:	078a                	slli	a5,a5,0x2
ffffffffc02007c8:	97ba                	add	a5,a5,a4
ffffffffc02007ca:	439c                	lw	a5,0(a5)
ffffffffc02007cc:	97ba                	add	a5,a5,a4
ffffffffc02007ce:	8782                	jr	a5
ffffffffc02007d0:	00004517          	auipc	a0,0x4
ffffffffc02007d4:	63850513          	addi	a0,a0,1592 # ffffffffc0204e08 <commands+0x4b0>
ffffffffc02007d8:	8e3ff06f          	j	ffffffffc02000ba <cprintf>
ffffffffc02007dc:	00004517          	auipc	a0,0x4
ffffffffc02007e0:	60c50513          	addi	a0,a0,1548 # ffffffffc0204de8 <commands+0x490>
ffffffffc02007e4:	8d7ff06f          	j	ffffffffc02000ba <cprintf>
ffffffffc02007e8:	00004517          	auipc	a0,0x4
ffffffffc02007ec:	5c050513          	addi	a0,a0,1472 # ffffffffc0204da8 <commands+0x450>
ffffffffc02007f0:	8cbff06f          	j	ffffffffc02000ba <cprintf>
ffffffffc02007f4:	00004517          	auipc	a0,0x4
ffffffffc02007f8:	5d450513          	addi	a0,a0,1492 # ffffffffc0204dc8 <commands+0x470>
ffffffffc02007fc:	8bfff06f          	j	ffffffffc02000ba <cprintf>
ffffffffc0200800:	1141                	addi	sp,sp,-16
ffffffffc0200802:	e406                	sd	ra,8(sp)
ffffffffc0200804:	c05ff0ef          	jal	ra,ffffffffc0200408 <clock_set_next_event>
ffffffffc0200808:	00011697          	auipc	a3,0x11
ffffffffc020080c:	cf868693          	addi	a3,a3,-776 # ffffffffc0211500 <ticks>
ffffffffc0200810:	629c                	ld	a5,0(a3)
ffffffffc0200812:	06400713          	li	a4,100
ffffffffc0200816:	0785                	addi	a5,a5,1
ffffffffc0200818:	02e7f733          	remu	a4,a5,a4
ffffffffc020081c:	e29c                	sd	a5,0(a3)
ffffffffc020081e:	cb19                	beqz	a4,ffffffffc0200834 <interrupt_handler+0x84>
ffffffffc0200820:	60a2                	ld	ra,8(sp)
ffffffffc0200822:	0141                	addi	sp,sp,16
ffffffffc0200824:	8082                	ret
ffffffffc0200826:	00004517          	auipc	a0,0x4
ffffffffc020082a:	61250513          	addi	a0,a0,1554 # ffffffffc0204e38 <commands+0x4e0>
ffffffffc020082e:	88dff06f          	j	ffffffffc02000ba <cprintf>
ffffffffc0200832:	bf31                	j	ffffffffc020074e <print_trapframe>
ffffffffc0200834:	60a2                	ld	ra,8(sp)
ffffffffc0200836:	06400593          	li	a1,100
ffffffffc020083a:	00004517          	auipc	a0,0x4
ffffffffc020083e:	5ee50513          	addi	a0,a0,1518 # ffffffffc0204e28 <commands+0x4d0>
ffffffffc0200842:	0141                	addi	sp,sp,16
ffffffffc0200844:	877ff06f          	j	ffffffffc02000ba <cprintf>

ffffffffc0200848 <exception_handler>:
ffffffffc0200848:	11853783          	ld	a5,280(a0)
ffffffffc020084c:	1101                	addi	sp,sp,-32
ffffffffc020084e:	e822                	sd	s0,16(sp)
ffffffffc0200850:	ec06                	sd	ra,24(sp)
ffffffffc0200852:	e426                	sd	s1,8(sp)
ffffffffc0200854:	473d                	li	a4,15
ffffffffc0200856:	842a                	mv	s0,a0
ffffffffc0200858:	14f76a63          	bltu	a4,a5,ffffffffc02009ac <exception_handler+0x164>
ffffffffc020085c:	00004717          	auipc	a4,0x4
ffffffffc0200860:	7e470713          	addi	a4,a4,2020 # ffffffffc0205040 <commands+0x6e8>
ffffffffc0200864:	078a                	slli	a5,a5,0x2
ffffffffc0200866:	97ba                	add	a5,a5,a4
ffffffffc0200868:	439c                	lw	a5,0(a5)
ffffffffc020086a:	97ba                	add	a5,a5,a4
ffffffffc020086c:	8782                	jr	a5
ffffffffc020086e:	00004517          	auipc	a0,0x4
ffffffffc0200872:	7ba50513          	addi	a0,a0,1978 # ffffffffc0205028 <commands+0x6d0>
ffffffffc0200876:	845ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc020087a:	8522                	mv	a0,s0
ffffffffc020087c:	c79ff0ef          	jal	ra,ffffffffc02004f4 <pgfault_handler>
ffffffffc0200880:	84aa                	mv	s1,a0
ffffffffc0200882:	12051b63          	bnez	a0,ffffffffc02009b8 <exception_handler+0x170>
ffffffffc0200886:	60e2                	ld	ra,24(sp)
ffffffffc0200888:	6442                	ld	s0,16(sp)
ffffffffc020088a:	64a2                	ld	s1,8(sp)
ffffffffc020088c:	6105                	addi	sp,sp,32
ffffffffc020088e:	8082                	ret
ffffffffc0200890:	00004517          	auipc	a0,0x4
ffffffffc0200894:	5f850513          	addi	a0,a0,1528 # ffffffffc0204e88 <commands+0x530>
ffffffffc0200898:	6442                	ld	s0,16(sp)
ffffffffc020089a:	60e2                	ld	ra,24(sp)
ffffffffc020089c:	64a2                	ld	s1,8(sp)
ffffffffc020089e:	6105                	addi	sp,sp,32
ffffffffc02008a0:	81bff06f          	j	ffffffffc02000ba <cprintf>
ffffffffc02008a4:	00004517          	auipc	a0,0x4
ffffffffc02008a8:	60450513          	addi	a0,a0,1540 # ffffffffc0204ea8 <commands+0x550>
ffffffffc02008ac:	b7f5                	j	ffffffffc0200898 <exception_handler+0x50>
ffffffffc02008ae:	00004517          	auipc	a0,0x4
ffffffffc02008b2:	61a50513          	addi	a0,a0,1562 # ffffffffc0204ec8 <commands+0x570>
ffffffffc02008b6:	b7cd                	j	ffffffffc0200898 <exception_handler+0x50>
ffffffffc02008b8:	00004517          	auipc	a0,0x4
ffffffffc02008bc:	62850513          	addi	a0,a0,1576 # ffffffffc0204ee0 <commands+0x588>
ffffffffc02008c0:	bfe1                	j	ffffffffc0200898 <exception_handler+0x50>
ffffffffc02008c2:	00004517          	auipc	a0,0x4
ffffffffc02008c6:	62e50513          	addi	a0,a0,1582 # ffffffffc0204ef0 <commands+0x598>
ffffffffc02008ca:	b7f9                	j	ffffffffc0200898 <exception_handler+0x50>
ffffffffc02008cc:	00004517          	auipc	a0,0x4
ffffffffc02008d0:	64450513          	addi	a0,a0,1604 # ffffffffc0204f10 <commands+0x5b8>
ffffffffc02008d4:	fe6ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc02008d8:	8522                	mv	a0,s0
ffffffffc02008da:	c1bff0ef          	jal	ra,ffffffffc02004f4 <pgfault_handler>
ffffffffc02008de:	84aa                	mv	s1,a0
ffffffffc02008e0:	d15d                	beqz	a0,ffffffffc0200886 <exception_handler+0x3e>
ffffffffc02008e2:	8522                	mv	a0,s0
ffffffffc02008e4:	e6bff0ef          	jal	ra,ffffffffc020074e <print_trapframe>
ffffffffc02008e8:	86a6                	mv	a3,s1
ffffffffc02008ea:	00004617          	auipc	a2,0x4
ffffffffc02008ee:	63e60613          	addi	a2,a2,1598 # ffffffffc0204f28 <commands+0x5d0>
ffffffffc02008f2:	0ca00593          	li	a1,202
ffffffffc02008f6:	00004517          	auipc	a0,0x4
ffffffffc02008fa:	12250513          	addi	a0,a0,290 # ffffffffc0204a18 <commands+0xc0>
ffffffffc02008fe:	a77ff0ef          	jal	ra,ffffffffc0200374 <__panic>
ffffffffc0200902:	00004517          	auipc	a0,0x4
ffffffffc0200906:	64650513          	addi	a0,a0,1606 # ffffffffc0204f48 <commands+0x5f0>
ffffffffc020090a:	b779                	j	ffffffffc0200898 <exception_handler+0x50>
ffffffffc020090c:	00004517          	auipc	a0,0x4
ffffffffc0200910:	65450513          	addi	a0,a0,1620 # ffffffffc0204f60 <commands+0x608>
ffffffffc0200914:	fa6ff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc0200918:	8522                	mv	a0,s0
ffffffffc020091a:	bdbff0ef          	jal	ra,ffffffffc02004f4 <pgfault_handler>
ffffffffc020091e:	84aa                	mv	s1,a0
ffffffffc0200920:	d13d                	beqz	a0,ffffffffc0200886 <exception_handler+0x3e>
ffffffffc0200922:	8522                	mv	a0,s0
ffffffffc0200924:	e2bff0ef          	jal	ra,ffffffffc020074e <print_trapframe>
ffffffffc0200928:	86a6                	mv	a3,s1
ffffffffc020092a:	00004617          	auipc	a2,0x4
ffffffffc020092e:	5fe60613          	addi	a2,a2,1534 # ffffffffc0204f28 <commands+0x5d0>
ffffffffc0200932:	0d400593          	li	a1,212
ffffffffc0200936:	00004517          	auipc	a0,0x4
ffffffffc020093a:	0e250513          	addi	a0,a0,226 # ffffffffc0204a18 <commands+0xc0>
ffffffffc020093e:	a37ff0ef          	jal	ra,ffffffffc0200374 <__panic>
ffffffffc0200942:	00004517          	auipc	a0,0x4
ffffffffc0200946:	63650513          	addi	a0,a0,1590 # ffffffffc0204f78 <commands+0x620>
ffffffffc020094a:	b7b9                	j	ffffffffc0200898 <exception_handler+0x50>
ffffffffc020094c:	00004517          	auipc	a0,0x4
ffffffffc0200950:	64c50513          	addi	a0,a0,1612 # ffffffffc0204f98 <commands+0x640>
ffffffffc0200954:	b791                	j	ffffffffc0200898 <exception_handler+0x50>
ffffffffc0200956:	00004517          	auipc	a0,0x4
ffffffffc020095a:	66250513          	addi	a0,a0,1634 # ffffffffc0204fb8 <commands+0x660>
ffffffffc020095e:	bf2d                	j	ffffffffc0200898 <exception_handler+0x50>
ffffffffc0200960:	00004517          	auipc	a0,0x4
ffffffffc0200964:	67850513          	addi	a0,a0,1656 # ffffffffc0204fd8 <commands+0x680>
ffffffffc0200968:	bf05                	j	ffffffffc0200898 <exception_handler+0x50>
ffffffffc020096a:	00004517          	auipc	a0,0x4
ffffffffc020096e:	68e50513          	addi	a0,a0,1678 # ffffffffc0204ff8 <commands+0x6a0>
ffffffffc0200972:	b71d                	j	ffffffffc0200898 <exception_handler+0x50>
ffffffffc0200974:	00004517          	auipc	a0,0x4
ffffffffc0200978:	69c50513          	addi	a0,a0,1692 # ffffffffc0205010 <commands+0x6b8>
ffffffffc020097c:	f3eff0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc0200980:	8522                	mv	a0,s0
ffffffffc0200982:	b73ff0ef          	jal	ra,ffffffffc02004f4 <pgfault_handler>
ffffffffc0200986:	84aa                	mv	s1,a0
ffffffffc0200988:	ee050fe3          	beqz	a0,ffffffffc0200886 <exception_handler+0x3e>
ffffffffc020098c:	8522                	mv	a0,s0
ffffffffc020098e:	dc1ff0ef          	jal	ra,ffffffffc020074e <print_trapframe>
ffffffffc0200992:	86a6                	mv	a3,s1
ffffffffc0200994:	00004617          	auipc	a2,0x4
ffffffffc0200998:	59460613          	addi	a2,a2,1428 # ffffffffc0204f28 <commands+0x5d0>
ffffffffc020099c:	0ea00593          	li	a1,234
ffffffffc02009a0:	00004517          	auipc	a0,0x4
ffffffffc02009a4:	07850513          	addi	a0,a0,120 # ffffffffc0204a18 <commands+0xc0>
ffffffffc02009a8:	9cdff0ef          	jal	ra,ffffffffc0200374 <__panic>
ffffffffc02009ac:	8522                	mv	a0,s0
ffffffffc02009ae:	6442                	ld	s0,16(sp)
ffffffffc02009b0:	60e2                	ld	ra,24(sp)
ffffffffc02009b2:	64a2                	ld	s1,8(sp)
ffffffffc02009b4:	6105                	addi	sp,sp,32
ffffffffc02009b6:	bb61                	j	ffffffffc020074e <print_trapframe>
ffffffffc02009b8:	8522                	mv	a0,s0
ffffffffc02009ba:	d95ff0ef          	jal	ra,ffffffffc020074e <print_trapframe>
ffffffffc02009be:	86a6                	mv	a3,s1
ffffffffc02009c0:	00004617          	auipc	a2,0x4
ffffffffc02009c4:	56860613          	addi	a2,a2,1384 # ffffffffc0204f28 <commands+0x5d0>
ffffffffc02009c8:	0f100593          	li	a1,241
ffffffffc02009cc:	00004517          	auipc	a0,0x4
ffffffffc02009d0:	04c50513          	addi	a0,a0,76 # ffffffffc0204a18 <commands+0xc0>
ffffffffc02009d4:	9a1ff0ef          	jal	ra,ffffffffc0200374 <__panic>

ffffffffc02009d8 <trap>:
ffffffffc02009d8:	11853783          	ld	a5,280(a0)
ffffffffc02009dc:	0007c363          	bltz	a5,ffffffffc02009e2 <trap+0xa>
ffffffffc02009e0:	b5a5                	j	ffffffffc0200848 <exception_handler>
ffffffffc02009e2:	b3f9                	j	ffffffffc02007b0 <interrupt_handler>
	...

ffffffffc02009f0 <__alltraps>:
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
ffffffffc0200a50:	850a                	mv	a0,sp
ffffffffc0200a52:	f87ff0ef          	jal	ra,ffffffffc02009d8 <trap>

ffffffffc0200a56 <__trapret>:
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
ffffffffc0200aa0:	10200073          	sret
	...

ffffffffc0200ab0 <default_init>:
ffffffffc0200ab0:	00010797          	auipc	a5,0x10
ffffffffc0200ab4:	59078793          	addi	a5,a5,1424 # ffffffffc0211040 <free_area>
ffffffffc0200ab8:	e79c                	sd	a5,8(a5)
ffffffffc0200aba:	e39c                	sd	a5,0(a5)
ffffffffc0200abc:	0007a823          	sw	zero,16(a5)
ffffffffc0200ac0:	8082                	ret

ffffffffc0200ac2 <default_nr_free_pages>:
ffffffffc0200ac2:	00010517          	auipc	a0,0x10
ffffffffc0200ac6:	58e56503          	lwu	a0,1422(a0) # ffffffffc0211050 <free_area+0x10>
ffffffffc0200aca:	8082                	ret

ffffffffc0200acc <default_check>:
ffffffffc0200acc:	715d                	addi	sp,sp,-80
ffffffffc0200ace:	e0a2                	sd	s0,64(sp)
ffffffffc0200ad0:	00010417          	auipc	s0,0x10
ffffffffc0200ad4:	57040413          	addi	s0,s0,1392 # ffffffffc0211040 <free_area>
ffffffffc0200ad8:	641c                	ld	a5,8(s0)
ffffffffc0200ada:	e486                	sd	ra,72(sp)
ffffffffc0200adc:	fc26                	sd	s1,56(sp)
ffffffffc0200ade:	f84a                	sd	s2,48(sp)
ffffffffc0200ae0:	f44e                	sd	s3,40(sp)
ffffffffc0200ae2:	f052                	sd	s4,32(sp)
ffffffffc0200ae4:	ec56                	sd	s5,24(sp)
ffffffffc0200ae6:	e85a                	sd	s6,16(sp)
ffffffffc0200ae8:	e45e                	sd	s7,8(sp)
ffffffffc0200aea:	e062                	sd	s8,0(sp)
ffffffffc0200aec:	2c878763          	beq	a5,s0,ffffffffc0200dba <default_check+0x2ee>
ffffffffc0200af0:	4481                	li	s1,0
ffffffffc0200af2:	4901                	li	s2,0
ffffffffc0200af4:	fe87b703          	ld	a4,-24(a5)
ffffffffc0200af8:	8b09                	andi	a4,a4,2
ffffffffc0200afa:	2c070463          	beqz	a4,ffffffffc0200dc2 <default_check+0x2f6>
ffffffffc0200afe:	ff87a703          	lw	a4,-8(a5)
ffffffffc0200b02:	679c                	ld	a5,8(a5)
ffffffffc0200b04:	2905                	addiw	s2,s2,1
ffffffffc0200b06:	9cb9                	addw	s1,s1,a4
ffffffffc0200b08:	fe8796e3          	bne	a5,s0,ffffffffc0200af4 <default_check+0x28>
ffffffffc0200b0c:	89a6                	mv	s3,s1
ffffffffc0200b0e:	385000ef          	jal	ra,ffffffffc0201692 <nr_free_pages>
ffffffffc0200b12:	71351863          	bne	a0,s3,ffffffffc0201222 <default_check+0x756>
ffffffffc0200b16:	4505                	li	a0,1
ffffffffc0200b18:	2a9000ef          	jal	ra,ffffffffc02015c0 <alloc_pages>
ffffffffc0200b1c:	8a2a                	mv	s4,a0
ffffffffc0200b1e:	44050263          	beqz	a0,ffffffffc0200f62 <default_check+0x496>
ffffffffc0200b22:	4505                	li	a0,1
ffffffffc0200b24:	29d000ef          	jal	ra,ffffffffc02015c0 <alloc_pages>
ffffffffc0200b28:	89aa                	mv	s3,a0
ffffffffc0200b2a:	70050c63          	beqz	a0,ffffffffc0201242 <default_check+0x776>
ffffffffc0200b2e:	4505                	li	a0,1
ffffffffc0200b30:	291000ef          	jal	ra,ffffffffc02015c0 <alloc_pages>
ffffffffc0200b34:	8aaa                	mv	s5,a0
ffffffffc0200b36:	4a050663          	beqz	a0,ffffffffc0200fe2 <default_check+0x516>
ffffffffc0200b3a:	2b3a0463          	beq	s4,s3,ffffffffc0200de2 <default_check+0x316>
ffffffffc0200b3e:	2aaa0263          	beq	s4,a0,ffffffffc0200de2 <default_check+0x316>
ffffffffc0200b42:	2aa98063          	beq	s3,a0,ffffffffc0200de2 <default_check+0x316>
ffffffffc0200b46:	000a2783          	lw	a5,0(s4)
ffffffffc0200b4a:	2a079c63          	bnez	a5,ffffffffc0200e02 <default_check+0x336>
ffffffffc0200b4e:	0009a783          	lw	a5,0(s3)
ffffffffc0200b52:	2a079863          	bnez	a5,ffffffffc0200e02 <default_check+0x336>
ffffffffc0200b56:	411c                	lw	a5,0(a0)
ffffffffc0200b58:	2a079563          	bnez	a5,ffffffffc0200e02 <default_check+0x336>
ffffffffc0200b5c:	00011797          	auipc	a5,0x11
ffffffffc0200b60:	9cc7b783          	ld	a5,-1588(a5) # ffffffffc0211528 <pages>
ffffffffc0200b64:	40fa0733          	sub	a4,s4,a5
ffffffffc0200b68:	870d                	srai	a4,a4,0x3
ffffffffc0200b6a:	00006597          	auipc	a1,0x6
ffffffffc0200b6e:	b665b583          	ld	a1,-1178(a1) # ffffffffc02066d0 <error_string+0x38>
ffffffffc0200b72:	02b70733          	mul	a4,a4,a1
ffffffffc0200b76:	00006617          	auipc	a2,0x6
ffffffffc0200b7a:	b6263603          	ld	a2,-1182(a2) # ffffffffc02066d8 <nbase>
ffffffffc0200b7e:	00011697          	auipc	a3,0x11
ffffffffc0200b82:	9a26b683          	ld	a3,-1630(a3) # ffffffffc0211520 <npage>
ffffffffc0200b86:	06b2                	slli	a3,a3,0xc
ffffffffc0200b88:	9732                	add	a4,a4,a2
ffffffffc0200b8a:	0732                	slli	a4,a4,0xc
ffffffffc0200b8c:	28d77b63          	bgeu	a4,a3,ffffffffc0200e22 <default_check+0x356>
ffffffffc0200b90:	40f98733          	sub	a4,s3,a5
ffffffffc0200b94:	870d                	srai	a4,a4,0x3
ffffffffc0200b96:	02b70733          	mul	a4,a4,a1
ffffffffc0200b9a:	9732                	add	a4,a4,a2
ffffffffc0200b9c:	0732                	slli	a4,a4,0xc
ffffffffc0200b9e:	4cd77263          	bgeu	a4,a3,ffffffffc0201062 <default_check+0x596>
ffffffffc0200ba2:	40f507b3          	sub	a5,a0,a5
ffffffffc0200ba6:	878d                	srai	a5,a5,0x3
ffffffffc0200ba8:	02b787b3          	mul	a5,a5,a1
ffffffffc0200bac:	97b2                	add	a5,a5,a2
ffffffffc0200bae:	07b2                	slli	a5,a5,0xc
ffffffffc0200bb0:	30d7f963          	bgeu	a5,a3,ffffffffc0200ec2 <default_check+0x3f6>
ffffffffc0200bb4:	4505                	li	a0,1
ffffffffc0200bb6:	00043c03          	ld	s8,0(s0)
ffffffffc0200bba:	00843b83          	ld	s7,8(s0)
ffffffffc0200bbe:	01042b03          	lw	s6,16(s0)
ffffffffc0200bc2:	e400                	sd	s0,8(s0)
ffffffffc0200bc4:	e000                	sd	s0,0(s0)
ffffffffc0200bc6:	00010797          	auipc	a5,0x10
ffffffffc0200bca:	4807a523          	sw	zero,1162(a5) # ffffffffc0211050 <free_area+0x10>
ffffffffc0200bce:	1f3000ef          	jal	ra,ffffffffc02015c0 <alloc_pages>
ffffffffc0200bd2:	2c051863          	bnez	a0,ffffffffc0200ea2 <default_check+0x3d6>
ffffffffc0200bd6:	4585                	li	a1,1
ffffffffc0200bd8:	8552                	mv	a0,s4
ffffffffc0200bda:	279000ef          	jal	ra,ffffffffc0201652 <free_pages>
ffffffffc0200bde:	4585                	li	a1,1
ffffffffc0200be0:	854e                	mv	a0,s3
ffffffffc0200be2:	271000ef          	jal	ra,ffffffffc0201652 <free_pages>
ffffffffc0200be6:	4585                	li	a1,1
ffffffffc0200be8:	8556                	mv	a0,s5
ffffffffc0200bea:	269000ef          	jal	ra,ffffffffc0201652 <free_pages>
ffffffffc0200bee:	4818                	lw	a4,16(s0)
ffffffffc0200bf0:	478d                	li	a5,3
ffffffffc0200bf2:	28f71863          	bne	a4,a5,ffffffffc0200e82 <default_check+0x3b6>
ffffffffc0200bf6:	4505                	li	a0,1
ffffffffc0200bf8:	1c9000ef          	jal	ra,ffffffffc02015c0 <alloc_pages>
ffffffffc0200bfc:	89aa                	mv	s3,a0
ffffffffc0200bfe:	26050263          	beqz	a0,ffffffffc0200e62 <default_check+0x396>
ffffffffc0200c02:	4505                	li	a0,1
ffffffffc0200c04:	1bd000ef          	jal	ra,ffffffffc02015c0 <alloc_pages>
ffffffffc0200c08:	8aaa                	mv	s5,a0
ffffffffc0200c0a:	3a050c63          	beqz	a0,ffffffffc0200fc2 <default_check+0x4f6>
ffffffffc0200c0e:	4505                	li	a0,1
ffffffffc0200c10:	1b1000ef          	jal	ra,ffffffffc02015c0 <alloc_pages>
ffffffffc0200c14:	8a2a                	mv	s4,a0
ffffffffc0200c16:	38050663          	beqz	a0,ffffffffc0200fa2 <default_check+0x4d6>
ffffffffc0200c1a:	4505                	li	a0,1
ffffffffc0200c1c:	1a5000ef          	jal	ra,ffffffffc02015c0 <alloc_pages>
ffffffffc0200c20:	36051163          	bnez	a0,ffffffffc0200f82 <default_check+0x4b6>
ffffffffc0200c24:	4585                	li	a1,1
ffffffffc0200c26:	854e                	mv	a0,s3
ffffffffc0200c28:	22b000ef          	jal	ra,ffffffffc0201652 <free_pages>
ffffffffc0200c2c:	641c                	ld	a5,8(s0)
ffffffffc0200c2e:	20878a63          	beq	a5,s0,ffffffffc0200e42 <default_check+0x376>
ffffffffc0200c32:	4505                	li	a0,1
ffffffffc0200c34:	18d000ef          	jal	ra,ffffffffc02015c0 <alloc_pages>
ffffffffc0200c38:	30a99563          	bne	s3,a0,ffffffffc0200f42 <default_check+0x476>
ffffffffc0200c3c:	4505                	li	a0,1
ffffffffc0200c3e:	183000ef          	jal	ra,ffffffffc02015c0 <alloc_pages>
ffffffffc0200c42:	2e051063          	bnez	a0,ffffffffc0200f22 <default_check+0x456>
ffffffffc0200c46:	481c                	lw	a5,16(s0)
ffffffffc0200c48:	2a079d63          	bnez	a5,ffffffffc0200f02 <default_check+0x436>
ffffffffc0200c4c:	854e                	mv	a0,s3
ffffffffc0200c4e:	4585                	li	a1,1
ffffffffc0200c50:	01843023          	sd	s8,0(s0)
ffffffffc0200c54:	01743423          	sd	s7,8(s0)
ffffffffc0200c58:	01642823          	sw	s6,16(s0)
ffffffffc0200c5c:	1f7000ef          	jal	ra,ffffffffc0201652 <free_pages>
ffffffffc0200c60:	4585                	li	a1,1
ffffffffc0200c62:	8556                	mv	a0,s5
ffffffffc0200c64:	1ef000ef          	jal	ra,ffffffffc0201652 <free_pages>
ffffffffc0200c68:	4585                	li	a1,1
ffffffffc0200c6a:	8552                	mv	a0,s4
ffffffffc0200c6c:	1e7000ef          	jal	ra,ffffffffc0201652 <free_pages>
ffffffffc0200c70:	4515                	li	a0,5
ffffffffc0200c72:	14f000ef          	jal	ra,ffffffffc02015c0 <alloc_pages>
ffffffffc0200c76:	89aa                	mv	s3,a0
ffffffffc0200c78:	26050563          	beqz	a0,ffffffffc0200ee2 <default_check+0x416>
ffffffffc0200c7c:	651c                	ld	a5,8(a0)
ffffffffc0200c7e:	8385                	srli	a5,a5,0x1
ffffffffc0200c80:	8b85                	andi	a5,a5,1
ffffffffc0200c82:	54079063          	bnez	a5,ffffffffc02011c2 <default_check+0x6f6>
ffffffffc0200c86:	4505                	li	a0,1
ffffffffc0200c88:	00043b03          	ld	s6,0(s0)
ffffffffc0200c8c:	00843a83          	ld	s5,8(s0)
ffffffffc0200c90:	e000                	sd	s0,0(s0)
ffffffffc0200c92:	e400                	sd	s0,8(s0)
ffffffffc0200c94:	12d000ef          	jal	ra,ffffffffc02015c0 <alloc_pages>
ffffffffc0200c98:	50051563          	bnez	a0,ffffffffc02011a2 <default_check+0x6d6>
ffffffffc0200c9c:	09098a13          	addi	s4,s3,144
ffffffffc0200ca0:	8552                	mv	a0,s4
ffffffffc0200ca2:	458d                	li	a1,3
ffffffffc0200ca4:	01042b83          	lw	s7,16(s0)
ffffffffc0200ca8:	00010797          	auipc	a5,0x10
ffffffffc0200cac:	3a07a423          	sw	zero,936(a5) # ffffffffc0211050 <free_area+0x10>
ffffffffc0200cb0:	1a3000ef          	jal	ra,ffffffffc0201652 <free_pages>
ffffffffc0200cb4:	4511                	li	a0,4
ffffffffc0200cb6:	10b000ef          	jal	ra,ffffffffc02015c0 <alloc_pages>
ffffffffc0200cba:	4c051463          	bnez	a0,ffffffffc0201182 <default_check+0x6b6>
ffffffffc0200cbe:	0989b783          	ld	a5,152(s3)
ffffffffc0200cc2:	8385                	srli	a5,a5,0x1
ffffffffc0200cc4:	8b85                	andi	a5,a5,1
ffffffffc0200cc6:	48078e63          	beqz	a5,ffffffffc0201162 <default_check+0x696>
ffffffffc0200cca:	0a89a703          	lw	a4,168(s3)
ffffffffc0200cce:	478d                	li	a5,3
ffffffffc0200cd0:	48f71963          	bne	a4,a5,ffffffffc0201162 <default_check+0x696>
ffffffffc0200cd4:	450d                	li	a0,3
ffffffffc0200cd6:	0eb000ef          	jal	ra,ffffffffc02015c0 <alloc_pages>
ffffffffc0200cda:	8c2a                	mv	s8,a0
ffffffffc0200cdc:	46050363          	beqz	a0,ffffffffc0201142 <default_check+0x676>
ffffffffc0200ce0:	4505                	li	a0,1
ffffffffc0200ce2:	0df000ef          	jal	ra,ffffffffc02015c0 <alloc_pages>
ffffffffc0200ce6:	42051e63          	bnez	a0,ffffffffc0201122 <default_check+0x656>
ffffffffc0200cea:	418a1c63          	bne	s4,s8,ffffffffc0201102 <default_check+0x636>
ffffffffc0200cee:	4585                	li	a1,1
ffffffffc0200cf0:	854e                	mv	a0,s3
ffffffffc0200cf2:	161000ef          	jal	ra,ffffffffc0201652 <free_pages>
ffffffffc0200cf6:	458d                	li	a1,3
ffffffffc0200cf8:	8552                	mv	a0,s4
ffffffffc0200cfa:	159000ef          	jal	ra,ffffffffc0201652 <free_pages>
ffffffffc0200cfe:	0089b783          	ld	a5,8(s3)
ffffffffc0200d02:	04898c13          	addi	s8,s3,72
ffffffffc0200d06:	8385                	srli	a5,a5,0x1
ffffffffc0200d08:	8b85                	andi	a5,a5,1
ffffffffc0200d0a:	3c078c63          	beqz	a5,ffffffffc02010e2 <default_check+0x616>
ffffffffc0200d0e:	0189a703          	lw	a4,24(s3)
ffffffffc0200d12:	4785                	li	a5,1
ffffffffc0200d14:	3cf71763          	bne	a4,a5,ffffffffc02010e2 <default_check+0x616>
ffffffffc0200d18:	008a3783          	ld	a5,8(s4)
ffffffffc0200d1c:	8385                	srli	a5,a5,0x1
ffffffffc0200d1e:	8b85                	andi	a5,a5,1
ffffffffc0200d20:	3a078163          	beqz	a5,ffffffffc02010c2 <default_check+0x5f6>
ffffffffc0200d24:	018a2703          	lw	a4,24(s4)
ffffffffc0200d28:	478d                	li	a5,3
ffffffffc0200d2a:	38f71c63          	bne	a4,a5,ffffffffc02010c2 <default_check+0x5f6>
ffffffffc0200d2e:	4505                	li	a0,1
ffffffffc0200d30:	091000ef          	jal	ra,ffffffffc02015c0 <alloc_pages>
ffffffffc0200d34:	36a99763          	bne	s3,a0,ffffffffc02010a2 <default_check+0x5d6>
ffffffffc0200d38:	4585                	li	a1,1
ffffffffc0200d3a:	119000ef          	jal	ra,ffffffffc0201652 <free_pages>
ffffffffc0200d3e:	4509                	li	a0,2
ffffffffc0200d40:	081000ef          	jal	ra,ffffffffc02015c0 <alloc_pages>
ffffffffc0200d44:	32aa1f63          	bne	s4,a0,ffffffffc0201082 <default_check+0x5b6>
ffffffffc0200d48:	4589                	li	a1,2
ffffffffc0200d4a:	109000ef          	jal	ra,ffffffffc0201652 <free_pages>
ffffffffc0200d4e:	4585                	li	a1,1
ffffffffc0200d50:	8562                	mv	a0,s8
ffffffffc0200d52:	101000ef          	jal	ra,ffffffffc0201652 <free_pages>
ffffffffc0200d56:	4515                	li	a0,5
ffffffffc0200d58:	069000ef          	jal	ra,ffffffffc02015c0 <alloc_pages>
ffffffffc0200d5c:	89aa                	mv	s3,a0
ffffffffc0200d5e:	48050263          	beqz	a0,ffffffffc02011e2 <default_check+0x716>
ffffffffc0200d62:	4505                	li	a0,1
ffffffffc0200d64:	05d000ef          	jal	ra,ffffffffc02015c0 <alloc_pages>
ffffffffc0200d68:	2c051d63          	bnez	a0,ffffffffc0201042 <default_check+0x576>
ffffffffc0200d6c:	481c                	lw	a5,16(s0)
ffffffffc0200d6e:	2a079a63          	bnez	a5,ffffffffc0201022 <default_check+0x556>
ffffffffc0200d72:	4595                	li	a1,5
ffffffffc0200d74:	854e                	mv	a0,s3
ffffffffc0200d76:	01742823          	sw	s7,16(s0)
ffffffffc0200d7a:	01643023          	sd	s6,0(s0)
ffffffffc0200d7e:	01543423          	sd	s5,8(s0)
ffffffffc0200d82:	0d1000ef          	jal	ra,ffffffffc0201652 <free_pages>
ffffffffc0200d86:	641c                	ld	a5,8(s0)
ffffffffc0200d88:	00878963          	beq	a5,s0,ffffffffc0200d9a <default_check+0x2ce>
ffffffffc0200d8c:	ff87a703          	lw	a4,-8(a5)
ffffffffc0200d90:	679c                	ld	a5,8(a5)
ffffffffc0200d92:	397d                	addiw	s2,s2,-1
ffffffffc0200d94:	9c99                	subw	s1,s1,a4
ffffffffc0200d96:	fe879be3          	bne	a5,s0,ffffffffc0200d8c <default_check+0x2c0>
ffffffffc0200d9a:	26091463          	bnez	s2,ffffffffc0201002 <default_check+0x536>
ffffffffc0200d9e:	46049263          	bnez	s1,ffffffffc0201202 <default_check+0x736>
ffffffffc0200da2:	60a6                	ld	ra,72(sp)
ffffffffc0200da4:	6406                	ld	s0,64(sp)
ffffffffc0200da6:	74e2                	ld	s1,56(sp)
ffffffffc0200da8:	7942                	ld	s2,48(sp)
ffffffffc0200daa:	79a2                	ld	s3,40(sp)
ffffffffc0200dac:	7a02                	ld	s4,32(sp)
ffffffffc0200dae:	6ae2                	ld	s5,24(sp)
ffffffffc0200db0:	6b42                	ld	s6,16(sp)
ffffffffc0200db2:	6ba2                	ld	s7,8(sp)
ffffffffc0200db4:	6c02                	ld	s8,0(sp)
ffffffffc0200db6:	6161                	addi	sp,sp,80
ffffffffc0200db8:	8082                	ret
ffffffffc0200dba:	4981                	li	s3,0
ffffffffc0200dbc:	4481                	li	s1,0
ffffffffc0200dbe:	4901                	li	s2,0
ffffffffc0200dc0:	b3b9                	j	ffffffffc0200b0e <default_check+0x42>
ffffffffc0200dc2:	00004697          	auipc	a3,0x4
ffffffffc0200dc6:	2be68693          	addi	a3,a3,702 # ffffffffc0205080 <commands+0x728>
ffffffffc0200dca:	00004617          	auipc	a2,0x4
ffffffffc0200dce:	2c660613          	addi	a2,a2,710 # ffffffffc0205090 <commands+0x738>
ffffffffc0200dd2:	0f000593          	li	a1,240
ffffffffc0200dd6:	00004517          	auipc	a0,0x4
ffffffffc0200dda:	2d250513          	addi	a0,a0,722 # ffffffffc02050a8 <commands+0x750>
ffffffffc0200dde:	d96ff0ef          	jal	ra,ffffffffc0200374 <__panic>
ffffffffc0200de2:	00004697          	auipc	a3,0x4
ffffffffc0200de6:	35e68693          	addi	a3,a3,862 # ffffffffc0205140 <commands+0x7e8>
ffffffffc0200dea:	00004617          	auipc	a2,0x4
ffffffffc0200dee:	2a660613          	addi	a2,a2,678 # ffffffffc0205090 <commands+0x738>
ffffffffc0200df2:	0bd00593          	li	a1,189
ffffffffc0200df6:	00004517          	auipc	a0,0x4
ffffffffc0200dfa:	2b250513          	addi	a0,a0,690 # ffffffffc02050a8 <commands+0x750>
ffffffffc0200dfe:	d76ff0ef          	jal	ra,ffffffffc0200374 <__panic>
ffffffffc0200e02:	00004697          	auipc	a3,0x4
ffffffffc0200e06:	36668693          	addi	a3,a3,870 # ffffffffc0205168 <commands+0x810>
ffffffffc0200e0a:	00004617          	auipc	a2,0x4
ffffffffc0200e0e:	28660613          	addi	a2,a2,646 # ffffffffc0205090 <commands+0x738>
ffffffffc0200e12:	0be00593          	li	a1,190
ffffffffc0200e16:	00004517          	auipc	a0,0x4
ffffffffc0200e1a:	29250513          	addi	a0,a0,658 # ffffffffc02050a8 <commands+0x750>
ffffffffc0200e1e:	d56ff0ef          	jal	ra,ffffffffc0200374 <__panic>
ffffffffc0200e22:	00004697          	auipc	a3,0x4
ffffffffc0200e26:	38668693          	addi	a3,a3,902 # ffffffffc02051a8 <commands+0x850>
ffffffffc0200e2a:	00004617          	auipc	a2,0x4
ffffffffc0200e2e:	26660613          	addi	a2,a2,614 # ffffffffc0205090 <commands+0x738>
ffffffffc0200e32:	0c000593          	li	a1,192
ffffffffc0200e36:	00004517          	auipc	a0,0x4
ffffffffc0200e3a:	27250513          	addi	a0,a0,626 # ffffffffc02050a8 <commands+0x750>
ffffffffc0200e3e:	d36ff0ef          	jal	ra,ffffffffc0200374 <__panic>
ffffffffc0200e42:	00004697          	auipc	a3,0x4
ffffffffc0200e46:	3ee68693          	addi	a3,a3,1006 # ffffffffc0205230 <commands+0x8d8>
ffffffffc0200e4a:	00004617          	auipc	a2,0x4
ffffffffc0200e4e:	24660613          	addi	a2,a2,582 # ffffffffc0205090 <commands+0x738>
ffffffffc0200e52:	0d900593          	li	a1,217
ffffffffc0200e56:	00004517          	auipc	a0,0x4
ffffffffc0200e5a:	25250513          	addi	a0,a0,594 # ffffffffc02050a8 <commands+0x750>
ffffffffc0200e5e:	d16ff0ef          	jal	ra,ffffffffc0200374 <__panic>
ffffffffc0200e62:	00004697          	auipc	a3,0x4
ffffffffc0200e66:	27e68693          	addi	a3,a3,638 # ffffffffc02050e0 <commands+0x788>
ffffffffc0200e6a:	00004617          	auipc	a2,0x4
ffffffffc0200e6e:	22660613          	addi	a2,a2,550 # ffffffffc0205090 <commands+0x738>
ffffffffc0200e72:	0d200593          	li	a1,210
ffffffffc0200e76:	00004517          	auipc	a0,0x4
ffffffffc0200e7a:	23250513          	addi	a0,a0,562 # ffffffffc02050a8 <commands+0x750>
ffffffffc0200e7e:	cf6ff0ef          	jal	ra,ffffffffc0200374 <__panic>
ffffffffc0200e82:	00004697          	auipc	a3,0x4
ffffffffc0200e86:	39e68693          	addi	a3,a3,926 # ffffffffc0205220 <commands+0x8c8>
ffffffffc0200e8a:	00004617          	auipc	a2,0x4
ffffffffc0200e8e:	20660613          	addi	a2,a2,518 # ffffffffc0205090 <commands+0x738>
ffffffffc0200e92:	0d000593          	li	a1,208
ffffffffc0200e96:	00004517          	auipc	a0,0x4
ffffffffc0200e9a:	21250513          	addi	a0,a0,530 # ffffffffc02050a8 <commands+0x750>
ffffffffc0200e9e:	cd6ff0ef          	jal	ra,ffffffffc0200374 <__panic>
ffffffffc0200ea2:	00004697          	auipc	a3,0x4
ffffffffc0200ea6:	36668693          	addi	a3,a3,870 # ffffffffc0205208 <commands+0x8b0>
ffffffffc0200eaa:	00004617          	auipc	a2,0x4
ffffffffc0200eae:	1e660613          	addi	a2,a2,486 # ffffffffc0205090 <commands+0x738>
ffffffffc0200eb2:	0cb00593          	li	a1,203
ffffffffc0200eb6:	00004517          	auipc	a0,0x4
ffffffffc0200eba:	1f250513          	addi	a0,a0,498 # ffffffffc02050a8 <commands+0x750>
ffffffffc0200ebe:	cb6ff0ef          	jal	ra,ffffffffc0200374 <__panic>
ffffffffc0200ec2:	00004697          	auipc	a3,0x4
ffffffffc0200ec6:	32668693          	addi	a3,a3,806 # ffffffffc02051e8 <commands+0x890>
ffffffffc0200eca:	00004617          	auipc	a2,0x4
ffffffffc0200ece:	1c660613          	addi	a2,a2,454 # ffffffffc0205090 <commands+0x738>
ffffffffc0200ed2:	0c200593          	li	a1,194
ffffffffc0200ed6:	00004517          	auipc	a0,0x4
ffffffffc0200eda:	1d250513          	addi	a0,a0,466 # ffffffffc02050a8 <commands+0x750>
ffffffffc0200ede:	c96ff0ef          	jal	ra,ffffffffc0200374 <__panic>
ffffffffc0200ee2:	00004697          	auipc	a3,0x4
ffffffffc0200ee6:	39668693          	addi	a3,a3,918 # ffffffffc0205278 <commands+0x920>
ffffffffc0200eea:	00004617          	auipc	a2,0x4
ffffffffc0200eee:	1a660613          	addi	a2,a2,422 # ffffffffc0205090 <commands+0x738>
ffffffffc0200ef2:	0f800593          	li	a1,248
ffffffffc0200ef6:	00004517          	auipc	a0,0x4
ffffffffc0200efa:	1b250513          	addi	a0,a0,434 # ffffffffc02050a8 <commands+0x750>
ffffffffc0200efe:	c76ff0ef          	jal	ra,ffffffffc0200374 <__panic>
ffffffffc0200f02:	00004697          	auipc	a3,0x4
ffffffffc0200f06:	36668693          	addi	a3,a3,870 # ffffffffc0205268 <commands+0x910>
ffffffffc0200f0a:	00004617          	auipc	a2,0x4
ffffffffc0200f0e:	18660613          	addi	a2,a2,390 # ffffffffc0205090 <commands+0x738>
ffffffffc0200f12:	0df00593          	li	a1,223
ffffffffc0200f16:	00004517          	auipc	a0,0x4
ffffffffc0200f1a:	19250513          	addi	a0,a0,402 # ffffffffc02050a8 <commands+0x750>
ffffffffc0200f1e:	c56ff0ef          	jal	ra,ffffffffc0200374 <__panic>
ffffffffc0200f22:	00004697          	auipc	a3,0x4
ffffffffc0200f26:	2e668693          	addi	a3,a3,742 # ffffffffc0205208 <commands+0x8b0>
ffffffffc0200f2a:	00004617          	auipc	a2,0x4
ffffffffc0200f2e:	16660613          	addi	a2,a2,358 # ffffffffc0205090 <commands+0x738>
ffffffffc0200f32:	0dd00593          	li	a1,221
ffffffffc0200f36:	00004517          	auipc	a0,0x4
ffffffffc0200f3a:	17250513          	addi	a0,a0,370 # ffffffffc02050a8 <commands+0x750>
ffffffffc0200f3e:	c36ff0ef          	jal	ra,ffffffffc0200374 <__panic>
ffffffffc0200f42:	00004697          	auipc	a3,0x4
ffffffffc0200f46:	30668693          	addi	a3,a3,774 # ffffffffc0205248 <commands+0x8f0>
ffffffffc0200f4a:	00004617          	auipc	a2,0x4
ffffffffc0200f4e:	14660613          	addi	a2,a2,326 # ffffffffc0205090 <commands+0x738>
ffffffffc0200f52:	0dc00593          	li	a1,220
ffffffffc0200f56:	00004517          	auipc	a0,0x4
ffffffffc0200f5a:	15250513          	addi	a0,a0,338 # ffffffffc02050a8 <commands+0x750>
ffffffffc0200f5e:	c16ff0ef          	jal	ra,ffffffffc0200374 <__panic>
ffffffffc0200f62:	00004697          	auipc	a3,0x4
ffffffffc0200f66:	17e68693          	addi	a3,a3,382 # ffffffffc02050e0 <commands+0x788>
ffffffffc0200f6a:	00004617          	auipc	a2,0x4
ffffffffc0200f6e:	12660613          	addi	a2,a2,294 # ffffffffc0205090 <commands+0x738>
ffffffffc0200f72:	0b900593          	li	a1,185
ffffffffc0200f76:	00004517          	auipc	a0,0x4
ffffffffc0200f7a:	13250513          	addi	a0,a0,306 # ffffffffc02050a8 <commands+0x750>
ffffffffc0200f7e:	bf6ff0ef          	jal	ra,ffffffffc0200374 <__panic>
ffffffffc0200f82:	00004697          	auipc	a3,0x4
ffffffffc0200f86:	28668693          	addi	a3,a3,646 # ffffffffc0205208 <commands+0x8b0>
ffffffffc0200f8a:	00004617          	auipc	a2,0x4
ffffffffc0200f8e:	10660613          	addi	a2,a2,262 # ffffffffc0205090 <commands+0x738>
ffffffffc0200f92:	0d600593          	li	a1,214
ffffffffc0200f96:	00004517          	auipc	a0,0x4
ffffffffc0200f9a:	11250513          	addi	a0,a0,274 # ffffffffc02050a8 <commands+0x750>
ffffffffc0200f9e:	bd6ff0ef          	jal	ra,ffffffffc0200374 <__panic>
ffffffffc0200fa2:	00004697          	auipc	a3,0x4
ffffffffc0200fa6:	17e68693          	addi	a3,a3,382 # ffffffffc0205120 <commands+0x7c8>
ffffffffc0200faa:	00004617          	auipc	a2,0x4
ffffffffc0200fae:	0e660613          	addi	a2,a2,230 # ffffffffc0205090 <commands+0x738>
ffffffffc0200fb2:	0d400593          	li	a1,212
ffffffffc0200fb6:	00004517          	auipc	a0,0x4
ffffffffc0200fba:	0f250513          	addi	a0,a0,242 # ffffffffc02050a8 <commands+0x750>
ffffffffc0200fbe:	bb6ff0ef          	jal	ra,ffffffffc0200374 <__panic>
ffffffffc0200fc2:	00004697          	auipc	a3,0x4
ffffffffc0200fc6:	13e68693          	addi	a3,a3,318 # ffffffffc0205100 <commands+0x7a8>
ffffffffc0200fca:	00004617          	auipc	a2,0x4
ffffffffc0200fce:	0c660613          	addi	a2,a2,198 # ffffffffc0205090 <commands+0x738>
ffffffffc0200fd2:	0d300593          	li	a1,211
ffffffffc0200fd6:	00004517          	auipc	a0,0x4
ffffffffc0200fda:	0d250513          	addi	a0,a0,210 # ffffffffc02050a8 <commands+0x750>
ffffffffc0200fde:	b96ff0ef          	jal	ra,ffffffffc0200374 <__panic>
ffffffffc0200fe2:	00004697          	auipc	a3,0x4
ffffffffc0200fe6:	13e68693          	addi	a3,a3,318 # ffffffffc0205120 <commands+0x7c8>
ffffffffc0200fea:	00004617          	auipc	a2,0x4
ffffffffc0200fee:	0a660613          	addi	a2,a2,166 # ffffffffc0205090 <commands+0x738>
ffffffffc0200ff2:	0bb00593          	li	a1,187
ffffffffc0200ff6:	00004517          	auipc	a0,0x4
ffffffffc0200ffa:	0b250513          	addi	a0,a0,178 # ffffffffc02050a8 <commands+0x750>
ffffffffc0200ffe:	b76ff0ef          	jal	ra,ffffffffc0200374 <__panic>
ffffffffc0201002:	00004697          	auipc	a3,0x4
ffffffffc0201006:	3c668693          	addi	a3,a3,966 # ffffffffc02053c8 <commands+0xa70>
ffffffffc020100a:	00004617          	auipc	a2,0x4
ffffffffc020100e:	08660613          	addi	a2,a2,134 # ffffffffc0205090 <commands+0x738>
ffffffffc0201012:	12500593          	li	a1,293
ffffffffc0201016:	00004517          	auipc	a0,0x4
ffffffffc020101a:	09250513          	addi	a0,a0,146 # ffffffffc02050a8 <commands+0x750>
ffffffffc020101e:	b56ff0ef          	jal	ra,ffffffffc0200374 <__panic>
ffffffffc0201022:	00004697          	auipc	a3,0x4
ffffffffc0201026:	24668693          	addi	a3,a3,582 # ffffffffc0205268 <commands+0x910>
ffffffffc020102a:	00004617          	auipc	a2,0x4
ffffffffc020102e:	06660613          	addi	a2,a2,102 # ffffffffc0205090 <commands+0x738>
ffffffffc0201032:	11a00593          	li	a1,282
ffffffffc0201036:	00004517          	auipc	a0,0x4
ffffffffc020103a:	07250513          	addi	a0,a0,114 # ffffffffc02050a8 <commands+0x750>
ffffffffc020103e:	b36ff0ef          	jal	ra,ffffffffc0200374 <__panic>
ffffffffc0201042:	00004697          	auipc	a3,0x4
ffffffffc0201046:	1c668693          	addi	a3,a3,454 # ffffffffc0205208 <commands+0x8b0>
ffffffffc020104a:	00004617          	auipc	a2,0x4
ffffffffc020104e:	04660613          	addi	a2,a2,70 # ffffffffc0205090 <commands+0x738>
ffffffffc0201052:	11800593          	li	a1,280
ffffffffc0201056:	00004517          	auipc	a0,0x4
ffffffffc020105a:	05250513          	addi	a0,a0,82 # ffffffffc02050a8 <commands+0x750>
ffffffffc020105e:	b16ff0ef          	jal	ra,ffffffffc0200374 <__panic>
ffffffffc0201062:	00004697          	auipc	a3,0x4
ffffffffc0201066:	16668693          	addi	a3,a3,358 # ffffffffc02051c8 <commands+0x870>
ffffffffc020106a:	00004617          	auipc	a2,0x4
ffffffffc020106e:	02660613          	addi	a2,a2,38 # ffffffffc0205090 <commands+0x738>
ffffffffc0201072:	0c100593          	li	a1,193
ffffffffc0201076:	00004517          	auipc	a0,0x4
ffffffffc020107a:	03250513          	addi	a0,a0,50 # ffffffffc02050a8 <commands+0x750>
ffffffffc020107e:	af6ff0ef          	jal	ra,ffffffffc0200374 <__panic>
ffffffffc0201082:	00004697          	auipc	a3,0x4
ffffffffc0201086:	30668693          	addi	a3,a3,774 # ffffffffc0205388 <commands+0xa30>
ffffffffc020108a:	00004617          	auipc	a2,0x4
ffffffffc020108e:	00660613          	addi	a2,a2,6 # ffffffffc0205090 <commands+0x738>
ffffffffc0201092:	11200593          	li	a1,274
ffffffffc0201096:	00004517          	auipc	a0,0x4
ffffffffc020109a:	01250513          	addi	a0,a0,18 # ffffffffc02050a8 <commands+0x750>
ffffffffc020109e:	ad6ff0ef          	jal	ra,ffffffffc0200374 <__panic>
ffffffffc02010a2:	00004697          	auipc	a3,0x4
ffffffffc02010a6:	2c668693          	addi	a3,a3,710 # ffffffffc0205368 <commands+0xa10>
ffffffffc02010aa:	00004617          	auipc	a2,0x4
ffffffffc02010ae:	fe660613          	addi	a2,a2,-26 # ffffffffc0205090 <commands+0x738>
ffffffffc02010b2:	11000593          	li	a1,272
ffffffffc02010b6:	00004517          	auipc	a0,0x4
ffffffffc02010ba:	ff250513          	addi	a0,a0,-14 # ffffffffc02050a8 <commands+0x750>
ffffffffc02010be:	ab6ff0ef          	jal	ra,ffffffffc0200374 <__panic>
ffffffffc02010c2:	00004697          	auipc	a3,0x4
ffffffffc02010c6:	27e68693          	addi	a3,a3,638 # ffffffffc0205340 <commands+0x9e8>
ffffffffc02010ca:	00004617          	auipc	a2,0x4
ffffffffc02010ce:	fc660613          	addi	a2,a2,-58 # ffffffffc0205090 <commands+0x738>
ffffffffc02010d2:	10e00593          	li	a1,270
ffffffffc02010d6:	00004517          	auipc	a0,0x4
ffffffffc02010da:	fd250513          	addi	a0,a0,-46 # ffffffffc02050a8 <commands+0x750>
ffffffffc02010de:	a96ff0ef          	jal	ra,ffffffffc0200374 <__panic>
ffffffffc02010e2:	00004697          	auipc	a3,0x4
ffffffffc02010e6:	23668693          	addi	a3,a3,566 # ffffffffc0205318 <commands+0x9c0>
ffffffffc02010ea:	00004617          	auipc	a2,0x4
ffffffffc02010ee:	fa660613          	addi	a2,a2,-90 # ffffffffc0205090 <commands+0x738>
ffffffffc02010f2:	10d00593          	li	a1,269
ffffffffc02010f6:	00004517          	auipc	a0,0x4
ffffffffc02010fa:	fb250513          	addi	a0,a0,-78 # ffffffffc02050a8 <commands+0x750>
ffffffffc02010fe:	a76ff0ef          	jal	ra,ffffffffc0200374 <__panic>
ffffffffc0201102:	00004697          	auipc	a3,0x4
ffffffffc0201106:	20668693          	addi	a3,a3,518 # ffffffffc0205308 <commands+0x9b0>
ffffffffc020110a:	00004617          	auipc	a2,0x4
ffffffffc020110e:	f8660613          	addi	a2,a2,-122 # ffffffffc0205090 <commands+0x738>
ffffffffc0201112:	10800593          	li	a1,264
ffffffffc0201116:	00004517          	auipc	a0,0x4
ffffffffc020111a:	f9250513          	addi	a0,a0,-110 # ffffffffc02050a8 <commands+0x750>
ffffffffc020111e:	a56ff0ef          	jal	ra,ffffffffc0200374 <__panic>
ffffffffc0201122:	00004697          	auipc	a3,0x4
ffffffffc0201126:	0e668693          	addi	a3,a3,230 # ffffffffc0205208 <commands+0x8b0>
ffffffffc020112a:	00004617          	auipc	a2,0x4
ffffffffc020112e:	f6660613          	addi	a2,a2,-154 # ffffffffc0205090 <commands+0x738>
ffffffffc0201132:	10700593          	li	a1,263
ffffffffc0201136:	00004517          	auipc	a0,0x4
ffffffffc020113a:	f7250513          	addi	a0,a0,-142 # ffffffffc02050a8 <commands+0x750>
ffffffffc020113e:	a36ff0ef          	jal	ra,ffffffffc0200374 <__panic>
ffffffffc0201142:	00004697          	auipc	a3,0x4
ffffffffc0201146:	1a668693          	addi	a3,a3,422 # ffffffffc02052e8 <commands+0x990>
ffffffffc020114a:	00004617          	auipc	a2,0x4
ffffffffc020114e:	f4660613          	addi	a2,a2,-186 # ffffffffc0205090 <commands+0x738>
ffffffffc0201152:	10600593          	li	a1,262
ffffffffc0201156:	00004517          	auipc	a0,0x4
ffffffffc020115a:	f5250513          	addi	a0,a0,-174 # ffffffffc02050a8 <commands+0x750>
ffffffffc020115e:	a16ff0ef          	jal	ra,ffffffffc0200374 <__panic>
ffffffffc0201162:	00004697          	auipc	a3,0x4
ffffffffc0201166:	15668693          	addi	a3,a3,342 # ffffffffc02052b8 <commands+0x960>
ffffffffc020116a:	00004617          	auipc	a2,0x4
ffffffffc020116e:	f2660613          	addi	a2,a2,-218 # ffffffffc0205090 <commands+0x738>
ffffffffc0201172:	10500593          	li	a1,261
ffffffffc0201176:	00004517          	auipc	a0,0x4
ffffffffc020117a:	f3250513          	addi	a0,a0,-206 # ffffffffc02050a8 <commands+0x750>
ffffffffc020117e:	9f6ff0ef          	jal	ra,ffffffffc0200374 <__panic>
ffffffffc0201182:	00004697          	auipc	a3,0x4
ffffffffc0201186:	11e68693          	addi	a3,a3,286 # ffffffffc02052a0 <commands+0x948>
ffffffffc020118a:	00004617          	auipc	a2,0x4
ffffffffc020118e:	f0660613          	addi	a2,a2,-250 # ffffffffc0205090 <commands+0x738>
ffffffffc0201192:	10400593          	li	a1,260
ffffffffc0201196:	00004517          	auipc	a0,0x4
ffffffffc020119a:	f1250513          	addi	a0,a0,-238 # ffffffffc02050a8 <commands+0x750>
ffffffffc020119e:	9d6ff0ef          	jal	ra,ffffffffc0200374 <__panic>
ffffffffc02011a2:	00004697          	auipc	a3,0x4
ffffffffc02011a6:	06668693          	addi	a3,a3,102 # ffffffffc0205208 <commands+0x8b0>
ffffffffc02011aa:	00004617          	auipc	a2,0x4
ffffffffc02011ae:	ee660613          	addi	a2,a2,-282 # ffffffffc0205090 <commands+0x738>
ffffffffc02011b2:	0fe00593          	li	a1,254
ffffffffc02011b6:	00004517          	auipc	a0,0x4
ffffffffc02011ba:	ef250513          	addi	a0,a0,-270 # ffffffffc02050a8 <commands+0x750>
ffffffffc02011be:	9b6ff0ef          	jal	ra,ffffffffc0200374 <__panic>
ffffffffc02011c2:	00004697          	auipc	a3,0x4
ffffffffc02011c6:	0c668693          	addi	a3,a3,198 # ffffffffc0205288 <commands+0x930>
ffffffffc02011ca:	00004617          	auipc	a2,0x4
ffffffffc02011ce:	ec660613          	addi	a2,a2,-314 # ffffffffc0205090 <commands+0x738>
ffffffffc02011d2:	0f900593          	li	a1,249
ffffffffc02011d6:	00004517          	auipc	a0,0x4
ffffffffc02011da:	ed250513          	addi	a0,a0,-302 # ffffffffc02050a8 <commands+0x750>
ffffffffc02011de:	996ff0ef          	jal	ra,ffffffffc0200374 <__panic>
ffffffffc02011e2:	00004697          	auipc	a3,0x4
ffffffffc02011e6:	1c668693          	addi	a3,a3,454 # ffffffffc02053a8 <commands+0xa50>
ffffffffc02011ea:	00004617          	auipc	a2,0x4
ffffffffc02011ee:	ea660613          	addi	a2,a2,-346 # ffffffffc0205090 <commands+0x738>
ffffffffc02011f2:	11700593          	li	a1,279
ffffffffc02011f6:	00004517          	auipc	a0,0x4
ffffffffc02011fa:	eb250513          	addi	a0,a0,-334 # ffffffffc02050a8 <commands+0x750>
ffffffffc02011fe:	976ff0ef          	jal	ra,ffffffffc0200374 <__panic>
ffffffffc0201202:	00004697          	auipc	a3,0x4
ffffffffc0201206:	1d668693          	addi	a3,a3,470 # ffffffffc02053d8 <commands+0xa80>
ffffffffc020120a:	00004617          	auipc	a2,0x4
ffffffffc020120e:	e8660613          	addi	a2,a2,-378 # ffffffffc0205090 <commands+0x738>
ffffffffc0201212:	12600593          	li	a1,294
ffffffffc0201216:	00004517          	auipc	a0,0x4
ffffffffc020121a:	e9250513          	addi	a0,a0,-366 # ffffffffc02050a8 <commands+0x750>
ffffffffc020121e:	956ff0ef          	jal	ra,ffffffffc0200374 <__panic>
ffffffffc0201222:	00004697          	auipc	a3,0x4
ffffffffc0201226:	e9e68693          	addi	a3,a3,-354 # ffffffffc02050c0 <commands+0x768>
ffffffffc020122a:	00004617          	auipc	a2,0x4
ffffffffc020122e:	e6660613          	addi	a2,a2,-410 # ffffffffc0205090 <commands+0x738>
ffffffffc0201232:	0f300593          	li	a1,243
ffffffffc0201236:	00004517          	auipc	a0,0x4
ffffffffc020123a:	e7250513          	addi	a0,a0,-398 # ffffffffc02050a8 <commands+0x750>
ffffffffc020123e:	936ff0ef          	jal	ra,ffffffffc0200374 <__panic>
ffffffffc0201242:	00004697          	auipc	a3,0x4
ffffffffc0201246:	ebe68693          	addi	a3,a3,-322 # ffffffffc0205100 <commands+0x7a8>
ffffffffc020124a:	00004617          	auipc	a2,0x4
ffffffffc020124e:	e4660613          	addi	a2,a2,-442 # ffffffffc0205090 <commands+0x738>
ffffffffc0201252:	0ba00593          	li	a1,186
ffffffffc0201256:	00004517          	auipc	a0,0x4
ffffffffc020125a:	e5250513          	addi	a0,a0,-430 # ffffffffc02050a8 <commands+0x750>
ffffffffc020125e:	916ff0ef          	jal	ra,ffffffffc0200374 <__panic>

ffffffffc0201262 <default_free_pages>:
ffffffffc0201262:	1141                	addi	sp,sp,-16
ffffffffc0201264:	e406                	sd	ra,8(sp)
ffffffffc0201266:	14058a63          	beqz	a1,ffffffffc02013ba <default_free_pages+0x158>
ffffffffc020126a:	00359693          	slli	a3,a1,0x3
ffffffffc020126e:	96ae                	add	a3,a3,a1
ffffffffc0201270:	068e                	slli	a3,a3,0x3
ffffffffc0201272:	96aa                	add	a3,a3,a0
ffffffffc0201274:	87aa                	mv	a5,a0
ffffffffc0201276:	02d50263          	beq	a0,a3,ffffffffc020129a <default_free_pages+0x38>
ffffffffc020127a:	6798                	ld	a4,8(a5)
ffffffffc020127c:	8b05                	andi	a4,a4,1
ffffffffc020127e:	10071e63          	bnez	a4,ffffffffc020139a <default_free_pages+0x138>
ffffffffc0201282:	6798                	ld	a4,8(a5)
ffffffffc0201284:	8b09                	andi	a4,a4,2
ffffffffc0201286:	10071a63          	bnez	a4,ffffffffc020139a <default_free_pages+0x138>
ffffffffc020128a:	0007b423          	sd	zero,8(a5)
ffffffffc020128e:	0007a023          	sw	zero,0(a5)
ffffffffc0201292:	04878793          	addi	a5,a5,72
ffffffffc0201296:	fed792e3          	bne	a5,a3,ffffffffc020127a <default_free_pages+0x18>
ffffffffc020129a:	2581                	sext.w	a1,a1
ffffffffc020129c:	cd0c                	sw	a1,24(a0)
ffffffffc020129e:	00850893          	addi	a7,a0,8
ffffffffc02012a2:	4789                	li	a5,2
ffffffffc02012a4:	40f8b02f          	amoor.d	zero,a5,(a7)
ffffffffc02012a8:	00010697          	auipc	a3,0x10
ffffffffc02012ac:	d9868693          	addi	a3,a3,-616 # ffffffffc0211040 <free_area>
ffffffffc02012b0:	4a98                	lw	a4,16(a3)
ffffffffc02012b2:	669c                	ld	a5,8(a3)
ffffffffc02012b4:	02050613          	addi	a2,a0,32
ffffffffc02012b8:	9db9                	addw	a1,a1,a4
ffffffffc02012ba:	ca8c                	sw	a1,16(a3)
ffffffffc02012bc:	0ad78863          	beq	a5,a3,ffffffffc020136c <default_free_pages+0x10a>
ffffffffc02012c0:	fe078713          	addi	a4,a5,-32
ffffffffc02012c4:	0006b803          	ld	a6,0(a3)
ffffffffc02012c8:	4581                	li	a1,0
ffffffffc02012ca:	00e56a63          	bltu	a0,a4,ffffffffc02012de <default_free_pages+0x7c>
ffffffffc02012ce:	6798                	ld	a4,8(a5)
ffffffffc02012d0:	06d70263          	beq	a4,a3,ffffffffc0201334 <default_free_pages+0xd2>
ffffffffc02012d4:	87ba                	mv	a5,a4
ffffffffc02012d6:	fe078713          	addi	a4,a5,-32
ffffffffc02012da:	fee57ae3          	bgeu	a0,a4,ffffffffc02012ce <default_free_pages+0x6c>
ffffffffc02012de:	c199                	beqz	a1,ffffffffc02012e4 <default_free_pages+0x82>
ffffffffc02012e0:	0106b023          	sd	a6,0(a3)
ffffffffc02012e4:	6398                	ld	a4,0(a5)
ffffffffc02012e6:	e390                	sd	a2,0(a5)
ffffffffc02012e8:	e710                	sd	a2,8(a4)
ffffffffc02012ea:	f51c                	sd	a5,40(a0)
ffffffffc02012ec:	f118                	sd	a4,32(a0)
ffffffffc02012ee:	02d70063          	beq	a4,a3,ffffffffc020130e <default_free_pages+0xac>
ffffffffc02012f2:	ff872803          	lw	a6,-8(a4)
ffffffffc02012f6:	fe070593          	addi	a1,a4,-32
ffffffffc02012fa:	02081613          	slli	a2,a6,0x20
ffffffffc02012fe:	9201                	srli	a2,a2,0x20
ffffffffc0201300:	00361793          	slli	a5,a2,0x3
ffffffffc0201304:	97b2                	add	a5,a5,a2
ffffffffc0201306:	078e                	slli	a5,a5,0x3
ffffffffc0201308:	97ae                	add	a5,a5,a1
ffffffffc020130a:	02f50f63          	beq	a0,a5,ffffffffc0201348 <default_free_pages+0xe6>
ffffffffc020130e:	7518                	ld	a4,40(a0)
ffffffffc0201310:	00d70f63          	beq	a4,a3,ffffffffc020132e <default_free_pages+0xcc>
ffffffffc0201314:	4d0c                	lw	a1,24(a0)
ffffffffc0201316:	fe070693          	addi	a3,a4,-32
ffffffffc020131a:	02059613          	slli	a2,a1,0x20
ffffffffc020131e:	9201                	srli	a2,a2,0x20
ffffffffc0201320:	00361793          	slli	a5,a2,0x3
ffffffffc0201324:	97b2                	add	a5,a5,a2
ffffffffc0201326:	078e                	slli	a5,a5,0x3
ffffffffc0201328:	97aa                	add	a5,a5,a0
ffffffffc020132a:	04f68863          	beq	a3,a5,ffffffffc020137a <default_free_pages+0x118>
ffffffffc020132e:	60a2                	ld	ra,8(sp)
ffffffffc0201330:	0141                	addi	sp,sp,16
ffffffffc0201332:	8082                	ret
ffffffffc0201334:	e790                	sd	a2,8(a5)
ffffffffc0201336:	f514                	sd	a3,40(a0)
ffffffffc0201338:	6798                	ld	a4,8(a5)
ffffffffc020133a:	f11c                	sd	a5,32(a0)
ffffffffc020133c:	02d70563          	beq	a4,a3,ffffffffc0201366 <default_free_pages+0x104>
ffffffffc0201340:	8832                	mv	a6,a2
ffffffffc0201342:	4585                	li	a1,1
ffffffffc0201344:	87ba                	mv	a5,a4
ffffffffc0201346:	bf41                	j	ffffffffc02012d6 <default_free_pages+0x74>
ffffffffc0201348:	4d1c                	lw	a5,24(a0)
ffffffffc020134a:	0107883b          	addw	a6,a5,a6
ffffffffc020134e:	ff072c23          	sw	a6,-8(a4)
ffffffffc0201352:	57f5                	li	a5,-3
ffffffffc0201354:	60f8b02f          	amoand.d	zero,a5,(a7)
ffffffffc0201358:	7110                	ld	a2,32(a0)
ffffffffc020135a:	751c                	ld	a5,40(a0)
ffffffffc020135c:	852e                	mv	a0,a1
ffffffffc020135e:	e61c                	sd	a5,8(a2)
ffffffffc0201360:	6718                	ld	a4,8(a4)
ffffffffc0201362:	e390                	sd	a2,0(a5)
ffffffffc0201364:	b775                	j	ffffffffc0201310 <default_free_pages+0xae>
ffffffffc0201366:	e290                	sd	a2,0(a3)
ffffffffc0201368:	873e                	mv	a4,a5
ffffffffc020136a:	b761                	j	ffffffffc02012f2 <default_free_pages+0x90>
ffffffffc020136c:	60a2                	ld	ra,8(sp)
ffffffffc020136e:	e390                	sd	a2,0(a5)
ffffffffc0201370:	e790                	sd	a2,8(a5)
ffffffffc0201372:	f51c                	sd	a5,40(a0)
ffffffffc0201374:	f11c                	sd	a5,32(a0)
ffffffffc0201376:	0141                	addi	sp,sp,16
ffffffffc0201378:	8082                	ret
ffffffffc020137a:	ff872783          	lw	a5,-8(a4)
ffffffffc020137e:	fe870693          	addi	a3,a4,-24
ffffffffc0201382:	9dbd                	addw	a1,a1,a5
ffffffffc0201384:	cd0c                	sw	a1,24(a0)
ffffffffc0201386:	57f5                	li	a5,-3
ffffffffc0201388:	60f6b02f          	amoand.d	zero,a5,(a3)
ffffffffc020138c:	6314                	ld	a3,0(a4)
ffffffffc020138e:	671c                	ld	a5,8(a4)
ffffffffc0201390:	60a2                	ld	ra,8(sp)
ffffffffc0201392:	e69c                	sd	a5,8(a3)
ffffffffc0201394:	e394                	sd	a3,0(a5)
ffffffffc0201396:	0141                	addi	sp,sp,16
ffffffffc0201398:	8082                	ret
ffffffffc020139a:	00004697          	auipc	a3,0x4
ffffffffc020139e:	05668693          	addi	a3,a3,86 # ffffffffc02053f0 <commands+0xa98>
ffffffffc02013a2:	00004617          	auipc	a2,0x4
ffffffffc02013a6:	cee60613          	addi	a2,a2,-786 # ffffffffc0205090 <commands+0x738>
ffffffffc02013aa:	08300593          	li	a1,131
ffffffffc02013ae:	00004517          	auipc	a0,0x4
ffffffffc02013b2:	cfa50513          	addi	a0,a0,-774 # ffffffffc02050a8 <commands+0x750>
ffffffffc02013b6:	fbffe0ef          	jal	ra,ffffffffc0200374 <__panic>
ffffffffc02013ba:	00004697          	auipc	a3,0x4
ffffffffc02013be:	02e68693          	addi	a3,a3,46 # ffffffffc02053e8 <commands+0xa90>
ffffffffc02013c2:	00004617          	auipc	a2,0x4
ffffffffc02013c6:	cce60613          	addi	a2,a2,-818 # ffffffffc0205090 <commands+0x738>
ffffffffc02013ca:	08000593          	li	a1,128
ffffffffc02013ce:	00004517          	auipc	a0,0x4
ffffffffc02013d2:	cda50513          	addi	a0,a0,-806 # ffffffffc02050a8 <commands+0x750>
ffffffffc02013d6:	f9ffe0ef          	jal	ra,ffffffffc0200374 <__panic>

ffffffffc02013da <default_alloc_pages>:
ffffffffc02013da:	c959                	beqz	a0,ffffffffc0201470 <default_alloc_pages+0x96>
ffffffffc02013dc:	00010597          	auipc	a1,0x10
ffffffffc02013e0:	c6458593          	addi	a1,a1,-924 # ffffffffc0211040 <free_area>
ffffffffc02013e4:	0105a803          	lw	a6,16(a1)
ffffffffc02013e8:	862a                	mv	a2,a0
ffffffffc02013ea:	02081793          	slli	a5,a6,0x20
ffffffffc02013ee:	9381                	srli	a5,a5,0x20
ffffffffc02013f0:	00a7ee63          	bltu	a5,a0,ffffffffc020140c <default_alloc_pages+0x32>
ffffffffc02013f4:	87ae                	mv	a5,a1
ffffffffc02013f6:	a801                	j	ffffffffc0201406 <default_alloc_pages+0x2c>
ffffffffc02013f8:	ff87a703          	lw	a4,-8(a5)
ffffffffc02013fc:	02071693          	slli	a3,a4,0x20
ffffffffc0201400:	9281                	srli	a3,a3,0x20
ffffffffc0201402:	00c6f763          	bgeu	a3,a2,ffffffffc0201410 <default_alloc_pages+0x36>
ffffffffc0201406:	679c                	ld	a5,8(a5)
ffffffffc0201408:	feb798e3          	bne	a5,a1,ffffffffc02013f8 <default_alloc_pages+0x1e>
ffffffffc020140c:	4501                	li	a0,0
ffffffffc020140e:	8082                	ret
ffffffffc0201410:	0007b883          	ld	a7,0(a5)
ffffffffc0201414:	0087b303          	ld	t1,8(a5)
ffffffffc0201418:	fe078513          	addi	a0,a5,-32
ffffffffc020141c:	00060e1b          	sext.w	t3,a2
ffffffffc0201420:	0068b423          	sd	t1,8(a7)
ffffffffc0201424:	01133023          	sd	a7,0(t1)
ffffffffc0201428:	02d67b63          	bgeu	a2,a3,ffffffffc020145e <default_alloc_pages+0x84>
ffffffffc020142c:	00361693          	slli	a3,a2,0x3
ffffffffc0201430:	96b2                	add	a3,a3,a2
ffffffffc0201432:	068e                	slli	a3,a3,0x3
ffffffffc0201434:	96aa                	add	a3,a3,a0
ffffffffc0201436:	41c7073b          	subw	a4,a4,t3
ffffffffc020143a:	ce98                	sw	a4,24(a3)
ffffffffc020143c:	00868613          	addi	a2,a3,8
ffffffffc0201440:	4709                	li	a4,2
ffffffffc0201442:	40e6302f          	amoor.d	zero,a4,(a2)
ffffffffc0201446:	0088b703          	ld	a4,8(a7)
ffffffffc020144a:	02068613          	addi	a2,a3,32
ffffffffc020144e:	0105a803          	lw	a6,16(a1)
ffffffffc0201452:	e310                	sd	a2,0(a4)
ffffffffc0201454:	00c8b423          	sd	a2,8(a7)
ffffffffc0201458:	f698                	sd	a4,40(a3)
ffffffffc020145a:	0316b023          	sd	a7,32(a3)
ffffffffc020145e:	41c8083b          	subw	a6,a6,t3
ffffffffc0201462:	0105a823          	sw	a6,16(a1)
ffffffffc0201466:	5775                	li	a4,-3
ffffffffc0201468:	17a1                	addi	a5,a5,-24
ffffffffc020146a:	60e7b02f          	amoand.d	zero,a4,(a5)
ffffffffc020146e:	8082                	ret
ffffffffc0201470:	1141                	addi	sp,sp,-16
ffffffffc0201472:	00004697          	auipc	a3,0x4
ffffffffc0201476:	f7668693          	addi	a3,a3,-138 # ffffffffc02053e8 <commands+0xa90>
ffffffffc020147a:	00004617          	auipc	a2,0x4
ffffffffc020147e:	c1660613          	addi	a2,a2,-1002 # ffffffffc0205090 <commands+0x738>
ffffffffc0201482:	06200593          	li	a1,98
ffffffffc0201486:	00004517          	auipc	a0,0x4
ffffffffc020148a:	c2250513          	addi	a0,a0,-990 # ffffffffc02050a8 <commands+0x750>
ffffffffc020148e:	e406                	sd	ra,8(sp)
ffffffffc0201490:	ee5fe0ef          	jal	ra,ffffffffc0200374 <__panic>

ffffffffc0201494 <default_init_memmap>:
ffffffffc0201494:	1141                	addi	sp,sp,-16
ffffffffc0201496:	e406                	sd	ra,8(sp)
ffffffffc0201498:	c9e1                	beqz	a1,ffffffffc0201568 <default_init_memmap+0xd4>
ffffffffc020149a:	00359693          	slli	a3,a1,0x3
ffffffffc020149e:	96ae                	add	a3,a3,a1
ffffffffc02014a0:	068e                	slli	a3,a3,0x3
ffffffffc02014a2:	96aa                	add	a3,a3,a0
ffffffffc02014a4:	87aa                	mv	a5,a0
ffffffffc02014a6:	00d50f63          	beq	a0,a3,ffffffffc02014c4 <default_init_memmap+0x30>
ffffffffc02014aa:	6798                	ld	a4,8(a5)
ffffffffc02014ac:	8b05                	andi	a4,a4,1
ffffffffc02014ae:	cf49                	beqz	a4,ffffffffc0201548 <default_init_memmap+0xb4>
ffffffffc02014b0:	0007ac23          	sw	zero,24(a5)
ffffffffc02014b4:	0007b423          	sd	zero,8(a5)
ffffffffc02014b8:	0007a023          	sw	zero,0(a5)
ffffffffc02014bc:	04878793          	addi	a5,a5,72
ffffffffc02014c0:	fed795e3          	bne	a5,a3,ffffffffc02014aa <default_init_memmap+0x16>
ffffffffc02014c4:	2581                	sext.w	a1,a1
ffffffffc02014c6:	cd0c                	sw	a1,24(a0)
ffffffffc02014c8:	4789                	li	a5,2
ffffffffc02014ca:	00850713          	addi	a4,a0,8
ffffffffc02014ce:	40f7302f          	amoor.d	zero,a5,(a4)
ffffffffc02014d2:	00010697          	auipc	a3,0x10
ffffffffc02014d6:	b6e68693          	addi	a3,a3,-1170 # ffffffffc0211040 <free_area>
ffffffffc02014da:	4a98                	lw	a4,16(a3)
ffffffffc02014dc:	669c                	ld	a5,8(a3)
ffffffffc02014de:	02050613          	addi	a2,a0,32
ffffffffc02014e2:	9db9                	addw	a1,a1,a4
ffffffffc02014e4:	ca8c                	sw	a1,16(a3)
ffffffffc02014e6:	04d78a63          	beq	a5,a3,ffffffffc020153a <default_init_memmap+0xa6>
ffffffffc02014ea:	fe078713          	addi	a4,a5,-32
ffffffffc02014ee:	0006b803          	ld	a6,0(a3)
ffffffffc02014f2:	4581                	li	a1,0
ffffffffc02014f4:	00e56a63          	bltu	a0,a4,ffffffffc0201508 <default_init_memmap+0x74>
ffffffffc02014f8:	6798                	ld	a4,8(a5)
ffffffffc02014fa:	02d70263          	beq	a4,a3,ffffffffc020151e <default_init_memmap+0x8a>
ffffffffc02014fe:	87ba                	mv	a5,a4
ffffffffc0201500:	fe078713          	addi	a4,a5,-32
ffffffffc0201504:	fee57ae3          	bgeu	a0,a4,ffffffffc02014f8 <default_init_memmap+0x64>
ffffffffc0201508:	c199                	beqz	a1,ffffffffc020150e <default_init_memmap+0x7a>
ffffffffc020150a:	0106b023          	sd	a6,0(a3)
ffffffffc020150e:	6398                	ld	a4,0(a5)
ffffffffc0201510:	60a2                	ld	ra,8(sp)
ffffffffc0201512:	e390                	sd	a2,0(a5)
ffffffffc0201514:	e710                	sd	a2,8(a4)
ffffffffc0201516:	f51c                	sd	a5,40(a0)
ffffffffc0201518:	f118                	sd	a4,32(a0)
ffffffffc020151a:	0141                	addi	sp,sp,16
ffffffffc020151c:	8082                	ret
ffffffffc020151e:	e790                	sd	a2,8(a5)
ffffffffc0201520:	f514                	sd	a3,40(a0)
ffffffffc0201522:	6798                	ld	a4,8(a5)
ffffffffc0201524:	f11c                	sd	a5,32(a0)
ffffffffc0201526:	00d70663          	beq	a4,a3,ffffffffc0201532 <default_init_memmap+0x9e>
ffffffffc020152a:	8832                	mv	a6,a2
ffffffffc020152c:	4585                	li	a1,1
ffffffffc020152e:	87ba                	mv	a5,a4
ffffffffc0201530:	bfc1                	j	ffffffffc0201500 <default_init_memmap+0x6c>
ffffffffc0201532:	60a2                	ld	ra,8(sp)
ffffffffc0201534:	e290                	sd	a2,0(a3)
ffffffffc0201536:	0141                	addi	sp,sp,16
ffffffffc0201538:	8082                	ret
ffffffffc020153a:	60a2                	ld	ra,8(sp)
ffffffffc020153c:	e390                	sd	a2,0(a5)
ffffffffc020153e:	e790                	sd	a2,8(a5)
ffffffffc0201540:	f51c                	sd	a5,40(a0)
ffffffffc0201542:	f11c                	sd	a5,32(a0)
ffffffffc0201544:	0141                	addi	sp,sp,16
ffffffffc0201546:	8082                	ret
ffffffffc0201548:	00004697          	auipc	a3,0x4
ffffffffc020154c:	ed068693          	addi	a3,a3,-304 # ffffffffc0205418 <commands+0xac0>
ffffffffc0201550:	00004617          	auipc	a2,0x4
ffffffffc0201554:	b4060613          	addi	a2,a2,-1216 # ffffffffc0205090 <commands+0x738>
ffffffffc0201558:	04900593          	li	a1,73
ffffffffc020155c:	00004517          	auipc	a0,0x4
ffffffffc0201560:	b4c50513          	addi	a0,a0,-1204 # ffffffffc02050a8 <commands+0x750>
ffffffffc0201564:	e11fe0ef          	jal	ra,ffffffffc0200374 <__panic>
ffffffffc0201568:	00004697          	auipc	a3,0x4
ffffffffc020156c:	e8068693          	addi	a3,a3,-384 # ffffffffc02053e8 <commands+0xa90>
ffffffffc0201570:	00004617          	auipc	a2,0x4
ffffffffc0201574:	b2060613          	addi	a2,a2,-1248 # ffffffffc0205090 <commands+0x738>
ffffffffc0201578:	04600593          	li	a1,70
ffffffffc020157c:	00004517          	auipc	a0,0x4
ffffffffc0201580:	b2c50513          	addi	a0,a0,-1236 # ffffffffc02050a8 <commands+0x750>
ffffffffc0201584:	df1fe0ef          	jal	ra,ffffffffc0200374 <__panic>

ffffffffc0201588 <pa2page.part.0>:
ffffffffc0201588:	1141                	addi	sp,sp,-16
ffffffffc020158a:	00004617          	auipc	a2,0x4
ffffffffc020158e:	eee60613          	addi	a2,a2,-274 # ffffffffc0205478 <default_pmm_manager+0x38>
ffffffffc0201592:	06500593          	li	a1,101
ffffffffc0201596:	00004517          	auipc	a0,0x4
ffffffffc020159a:	f0250513          	addi	a0,a0,-254 # ffffffffc0205498 <default_pmm_manager+0x58>
ffffffffc020159e:	e406                	sd	ra,8(sp)
ffffffffc02015a0:	dd5fe0ef          	jal	ra,ffffffffc0200374 <__panic>

ffffffffc02015a4 <pte2page.part.0>:
ffffffffc02015a4:	1141                	addi	sp,sp,-16
ffffffffc02015a6:	00004617          	auipc	a2,0x4
ffffffffc02015aa:	f0260613          	addi	a2,a2,-254 # ffffffffc02054a8 <default_pmm_manager+0x68>
ffffffffc02015ae:	07000593          	li	a1,112
ffffffffc02015b2:	00004517          	auipc	a0,0x4
ffffffffc02015b6:	ee650513          	addi	a0,a0,-282 # ffffffffc0205498 <default_pmm_manager+0x58>
ffffffffc02015ba:	e406                	sd	ra,8(sp)
ffffffffc02015bc:	db9fe0ef          	jal	ra,ffffffffc0200374 <__panic>

ffffffffc02015c0 <alloc_pages>:
ffffffffc02015c0:	7139                	addi	sp,sp,-64
ffffffffc02015c2:	f426                	sd	s1,40(sp)
ffffffffc02015c4:	f04a                	sd	s2,32(sp)
ffffffffc02015c6:	ec4e                	sd	s3,24(sp)
ffffffffc02015c8:	e852                	sd	s4,16(sp)
ffffffffc02015ca:	e456                	sd	s5,8(sp)
ffffffffc02015cc:	e05a                	sd	s6,0(sp)
ffffffffc02015ce:	fc06                	sd	ra,56(sp)
ffffffffc02015d0:	f822                	sd	s0,48(sp)
ffffffffc02015d2:	84aa                	mv	s1,a0
ffffffffc02015d4:	00010917          	auipc	s2,0x10
ffffffffc02015d8:	f5c90913          	addi	s2,s2,-164 # ffffffffc0211530 <pmm_manager>
ffffffffc02015dc:	4a05                	li	s4,1
ffffffffc02015de:	00010a97          	auipc	s5,0x10
ffffffffc02015e2:	f72a8a93          	addi	s5,s5,-142 # ffffffffc0211550 <swap_init_ok>
ffffffffc02015e6:	0005099b          	sext.w	s3,a0
ffffffffc02015ea:	00010b17          	auipc	s6,0x10
ffffffffc02015ee:	f6eb0b13          	addi	s6,s6,-146 # ffffffffc0211558 <check_mm_struct>
ffffffffc02015f2:	a01d                	j	ffffffffc0201618 <alloc_pages+0x58>
ffffffffc02015f4:	00093783          	ld	a5,0(s2)
ffffffffc02015f8:	6f9c                	ld	a5,24(a5)
ffffffffc02015fa:	9782                	jalr	a5
ffffffffc02015fc:	842a                	mv	s0,a0
ffffffffc02015fe:	4601                	li	a2,0
ffffffffc0201600:	85ce                	mv	a1,s3
ffffffffc0201602:	ec0d                	bnez	s0,ffffffffc020163c <alloc_pages+0x7c>
ffffffffc0201604:	029a6c63          	bltu	s4,s1,ffffffffc020163c <alloc_pages+0x7c>
ffffffffc0201608:	000aa783          	lw	a5,0(s5)
ffffffffc020160c:	2781                	sext.w	a5,a5
ffffffffc020160e:	c79d                	beqz	a5,ffffffffc020163c <alloc_pages+0x7c>
ffffffffc0201610:	000b3503          	ld	a0,0(s6)
ffffffffc0201614:	189010ef          	jal	ra,ffffffffc0202f9c <swap_out>
ffffffffc0201618:	100027f3          	csrr	a5,sstatus
ffffffffc020161c:	8b89                	andi	a5,a5,2
ffffffffc020161e:	8526                	mv	a0,s1
ffffffffc0201620:	dbf1                	beqz	a5,ffffffffc02015f4 <alloc_pages+0x34>
ffffffffc0201622:	ecdfe0ef          	jal	ra,ffffffffc02004ee <intr_disable>
ffffffffc0201626:	00093783          	ld	a5,0(s2)
ffffffffc020162a:	8526                	mv	a0,s1
ffffffffc020162c:	6f9c                	ld	a5,24(a5)
ffffffffc020162e:	9782                	jalr	a5
ffffffffc0201630:	842a                	mv	s0,a0
ffffffffc0201632:	eb7fe0ef          	jal	ra,ffffffffc02004e8 <intr_enable>
ffffffffc0201636:	4601                	li	a2,0
ffffffffc0201638:	85ce                	mv	a1,s3
ffffffffc020163a:	d469                	beqz	s0,ffffffffc0201604 <alloc_pages+0x44>
ffffffffc020163c:	70e2                	ld	ra,56(sp)
ffffffffc020163e:	8522                	mv	a0,s0
ffffffffc0201640:	7442                	ld	s0,48(sp)
ffffffffc0201642:	74a2                	ld	s1,40(sp)
ffffffffc0201644:	7902                	ld	s2,32(sp)
ffffffffc0201646:	69e2                	ld	s3,24(sp)
ffffffffc0201648:	6a42                	ld	s4,16(sp)
ffffffffc020164a:	6aa2                	ld	s5,8(sp)
ffffffffc020164c:	6b02                	ld	s6,0(sp)
ffffffffc020164e:	6121                	addi	sp,sp,64
ffffffffc0201650:	8082                	ret

ffffffffc0201652 <free_pages>:
ffffffffc0201652:	100027f3          	csrr	a5,sstatus
ffffffffc0201656:	8b89                	andi	a5,a5,2
ffffffffc0201658:	e799                	bnez	a5,ffffffffc0201666 <free_pages+0x14>
ffffffffc020165a:	00010797          	auipc	a5,0x10
ffffffffc020165e:	ed67b783          	ld	a5,-298(a5) # ffffffffc0211530 <pmm_manager>
ffffffffc0201662:	739c                	ld	a5,32(a5)
ffffffffc0201664:	8782                	jr	a5
ffffffffc0201666:	1101                	addi	sp,sp,-32
ffffffffc0201668:	ec06                	sd	ra,24(sp)
ffffffffc020166a:	e822                	sd	s0,16(sp)
ffffffffc020166c:	e426                	sd	s1,8(sp)
ffffffffc020166e:	842a                	mv	s0,a0
ffffffffc0201670:	84ae                	mv	s1,a1
ffffffffc0201672:	e7dfe0ef          	jal	ra,ffffffffc02004ee <intr_disable>
ffffffffc0201676:	00010797          	auipc	a5,0x10
ffffffffc020167a:	eba7b783          	ld	a5,-326(a5) # ffffffffc0211530 <pmm_manager>
ffffffffc020167e:	739c                	ld	a5,32(a5)
ffffffffc0201680:	85a6                	mv	a1,s1
ffffffffc0201682:	8522                	mv	a0,s0
ffffffffc0201684:	9782                	jalr	a5
ffffffffc0201686:	6442                	ld	s0,16(sp)
ffffffffc0201688:	60e2                	ld	ra,24(sp)
ffffffffc020168a:	64a2                	ld	s1,8(sp)
ffffffffc020168c:	6105                	addi	sp,sp,32
ffffffffc020168e:	e5bfe06f          	j	ffffffffc02004e8 <intr_enable>

ffffffffc0201692 <nr_free_pages>:
ffffffffc0201692:	100027f3          	csrr	a5,sstatus
ffffffffc0201696:	8b89                	andi	a5,a5,2
ffffffffc0201698:	e799                	bnez	a5,ffffffffc02016a6 <nr_free_pages+0x14>
ffffffffc020169a:	00010797          	auipc	a5,0x10
ffffffffc020169e:	e967b783          	ld	a5,-362(a5) # ffffffffc0211530 <pmm_manager>
ffffffffc02016a2:	779c                	ld	a5,40(a5)
ffffffffc02016a4:	8782                	jr	a5
ffffffffc02016a6:	1141                	addi	sp,sp,-16
ffffffffc02016a8:	e406                	sd	ra,8(sp)
ffffffffc02016aa:	e022                	sd	s0,0(sp)
ffffffffc02016ac:	e43fe0ef          	jal	ra,ffffffffc02004ee <intr_disable>
ffffffffc02016b0:	00010797          	auipc	a5,0x10
ffffffffc02016b4:	e807b783          	ld	a5,-384(a5) # ffffffffc0211530 <pmm_manager>
ffffffffc02016b8:	779c                	ld	a5,40(a5)
ffffffffc02016ba:	9782                	jalr	a5
ffffffffc02016bc:	842a                	mv	s0,a0
ffffffffc02016be:	e2bfe0ef          	jal	ra,ffffffffc02004e8 <intr_enable>
ffffffffc02016c2:	60a2                	ld	ra,8(sp)
ffffffffc02016c4:	8522                	mv	a0,s0
ffffffffc02016c6:	6402                	ld	s0,0(sp)
ffffffffc02016c8:	0141                	addi	sp,sp,16
ffffffffc02016ca:	8082                	ret

ffffffffc02016cc <get_pte>:
ffffffffc02016cc:	01e5d793          	srli	a5,a1,0x1e
ffffffffc02016d0:	1ff7f793          	andi	a5,a5,511
ffffffffc02016d4:	715d                	addi	sp,sp,-80
ffffffffc02016d6:	078e                	slli	a5,a5,0x3
ffffffffc02016d8:	fc26                	sd	s1,56(sp)
ffffffffc02016da:	00f504b3          	add	s1,a0,a5
ffffffffc02016de:	6094                	ld	a3,0(s1)
ffffffffc02016e0:	f84a                	sd	s2,48(sp)
ffffffffc02016e2:	f44e                	sd	s3,40(sp)
ffffffffc02016e4:	f052                	sd	s4,32(sp)
ffffffffc02016e6:	e486                	sd	ra,72(sp)
ffffffffc02016e8:	e0a2                	sd	s0,64(sp)
ffffffffc02016ea:	ec56                	sd	s5,24(sp)
ffffffffc02016ec:	e85a                	sd	s6,16(sp)
ffffffffc02016ee:	e45e                	sd	s7,8(sp)
ffffffffc02016f0:	0016f793          	andi	a5,a3,1
ffffffffc02016f4:	892e                	mv	s2,a1
ffffffffc02016f6:	8a32                	mv	s4,a2
ffffffffc02016f8:	00010997          	auipc	s3,0x10
ffffffffc02016fc:	e2898993          	addi	s3,s3,-472 # ffffffffc0211520 <npage>
ffffffffc0201700:	efb5                	bnez	a5,ffffffffc020177c <get_pte+0xb0>
ffffffffc0201702:	14060c63          	beqz	a2,ffffffffc020185a <get_pte+0x18e>
ffffffffc0201706:	4505                	li	a0,1
ffffffffc0201708:	eb9ff0ef          	jal	ra,ffffffffc02015c0 <alloc_pages>
ffffffffc020170c:	842a                	mv	s0,a0
ffffffffc020170e:	14050663          	beqz	a0,ffffffffc020185a <get_pte+0x18e>
ffffffffc0201712:	00010b97          	auipc	s7,0x10
ffffffffc0201716:	e16b8b93          	addi	s7,s7,-490 # ffffffffc0211528 <pages>
ffffffffc020171a:	000bb503          	ld	a0,0(s7)
ffffffffc020171e:	00005b17          	auipc	s6,0x5
ffffffffc0201722:	fb2b3b03          	ld	s6,-78(s6) # ffffffffc02066d0 <error_string+0x38>
ffffffffc0201726:	00080ab7          	lui	s5,0x80
ffffffffc020172a:	40a40533          	sub	a0,s0,a0
ffffffffc020172e:	850d                	srai	a0,a0,0x3
ffffffffc0201730:	03650533          	mul	a0,a0,s6
ffffffffc0201734:	00010997          	auipc	s3,0x10
ffffffffc0201738:	dec98993          	addi	s3,s3,-532 # ffffffffc0211520 <npage>
ffffffffc020173c:	4785                	li	a5,1
ffffffffc020173e:	0009b703          	ld	a4,0(s3)
ffffffffc0201742:	c01c                	sw	a5,0(s0)
ffffffffc0201744:	9556                	add	a0,a0,s5
ffffffffc0201746:	00c51793          	slli	a5,a0,0xc
ffffffffc020174a:	83b1                	srli	a5,a5,0xc
ffffffffc020174c:	0532                	slli	a0,a0,0xc
ffffffffc020174e:	14e7fd63          	bgeu	a5,a4,ffffffffc02018a8 <get_pte+0x1dc>
ffffffffc0201752:	00010797          	auipc	a5,0x10
ffffffffc0201756:	de67b783          	ld	a5,-538(a5) # ffffffffc0211538 <va_pa_offset>
ffffffffc020175a:	6605                	lui	a2,0x1
ffffffffc020175c:	4581                	li	a1,0
ffffffffc020175e:	953e                	add	a0,a0,a5
ffffffffc0201760:	771020ef          	jal	ra,ffffffffc02046d0 <memset>
ffffffffc0201764:	000bb683          	ld	a3,0(s7)
ffffffffc0201768:	40d406b3          	sub	a3,s0,a3
ffffffffc020176c:	868d                	srai	a3,a3,0x3
ffffffffc020176e:	036686b3          	mul	a3,a3,s6
ffffffffc0201772:	96d6                	add	a3,a3,s5
ffffffffc0201774:	06aa                	slli	a3,a3,0xa
ffffffffc0201776:	0116e693          	ori	a3,a3,17
ffffffffc020177a:	e094                	sd	a3,0(s1)
ffffffffc020177c:	77fd                	lui	a5,0xfffff
ffffffffc020177e:	068a                	slli	a3,a3,0x2
ffffffffc0201780:	0009b703          	ld	a4,0(s3)
ffffffffc0201784:	8efd                	and	a3,a3,a5
ffffffffc0201786:	00c6d793          	srli	a5,a3,0xc
ffffffffc020178a:	0ce7fa63          	bgeu	a5,a4,ffffffffc020185e <get_pte+0x192>
ffffffffc020178e:	00010a97          	auipc	s5,0x10
ffffffffc0201792:	daaa8a93          	addi	s5,s5,-598 # ffffffffc0211538 <va_pa_offset>
ffffffffc0201796:	000ab403          	ld	s0,0(s5)
ffffffffc020179a:	01595793          	srli	a5,s2,0x15
ffffffffc020179e:	1ff7f793          	andi	a5,a5,511
ffffffffc02017a2:	96a2                	add	a3,a3,s0
ffffffffc02017a4:	00379413          	slli	s0,a5,0x3
ffffffffc02017a8:	9436                	add	s0,s0,a3
ffffffffc02017aa:	6014                	ld	a3,0(s0)
ffffffffc02017ac:	0016f793          	andi	a5,a3,1
ffffffffc02017b0:	ebad                	bnez	a5,ffffffffc0201822 <get_pte+0x156>
ffffffffc02017b2:	0a0a0463          	beqz	s4,ffffffffc020185a <get_pte+0x18e>
ffffffffc02017b6:	4505                	li	a0,1
ffffffffc02017b8:	e09ff0ef          	jal	ra,ffffffffc02015c0 <alloc_pages>
ffffffffc02017bc:	84aa                	mv	s1,a0
ffffffffc02017be:	cd51                	beqz	a0,ffffffffc020185a <get_pte+0x18e>
ffffffffc02017c0:	00010b97          	auipc	s7,0x10
ffffffffc02017c4:	d68b8b93          	addi	s7,s7,-664 # ffffffffc0211528 <pages>
ffffffffc02017c8:	000bb503          	ld	a0,0(s7)
ffffffffc02017cc:	00005b17          	auipc	s6,0x5
ffffffffc02017d0:	f04b3b03          	ld	s6,-252(s6) # ffffffffc02066d0 <error_string+0x38>
ffffffffc02017d4:	00080a37          	lui	s4,0x80
ffffffffc02017d8:	40a48533          	sub	a0,s1,a0
ffffffffc02017dc:	850d                	srai	a0,a0,0x3
ffffffffc02017de:	03650533          	mul	a0,a0,s6
ffffffffc02017e2:	4785                	li	a5,1
ffffffffc02017e4:	0009b703          	ld	a4,0(s3)
ffffffffc02017e8:	c09c                	sw	a5,0(s1)
ffffffffc02017ea:	9552                	add	a0,a0,s4
ffffffffc02017ec:	00c51793          	slli	a5,a0,0xc
ffffffffc02017f0:	83b1                	srli	a5,a5,0xc
ffffffffc02017f2:	0532                	slli	a0,a0,0xc
ffffffffc02017f4:	08e7fd63          	bgeu	a5,a4,ffffffffc020188e <get_pte+0x1c2>
ffffffffc02017f8:	000ab783          	ld	a5,0(s5)
ffffffffc02017fc:	6605                	lui	a2,0x1
ffffffffc02017fe:	4581                	li	a1,0
ffffffffc0201800:	953e                	add	a0,a0,a5
ffffffffc0201802:	6cf020ef          	jal	ra,ffffffffc02046d0 <memset>
ffffffffc0201806:	000bb683          	ld	a3,0(s7)
ffffffffc020180a:	40d486b3          	sub	a3,s1,a3
ffffffffc020180e:	868d                	srai	a3,a3,0x3
ffffffffc0201810:	036686b3          	mul	a3,a3,s6
ffffffffc0201814:	96d2                	add	a3,a3,s4
ffffffffc0201816:	06aa                	slli	a3,a3,0xa
ffffffffc0201818:	0116e693          	ori	a3,a3,17
ffffffffc020181c:	e014                	sd	a3,0(s0)
ffffffffc020181e:	0009b703          	ld	a4,0(s3)
ffffffffc0201822:	068a                	slli	a3,a3,0x2
ffffffffc0201824:	757d                	lui	a0,0xfffff
ffffffffc0201826:	8ee9                	and	a3,a3,a0
ffffffffc0201828:	00c6d793          	srli	a5,a3,0xc
ffffffffc020182c:	04e7f563          	bgeu	a5,a4,ffffffffc0201876 <get_pte+0x1aa>
ffffffffc0201830:	000ab503          	ld	a0,0(s5)
ffffffffc0201834:	00c95913          	srli	s2,s2,0xc
ffffffffc0201838:	1ff97913          	andi	s2,s2,511
ffffffffc020183c:	96aa                	add	a3,a3,a0
ffffffffc020183e:	00391513          	slli	a0,s2,0x3
ffffffffc0201842:	9536                	add	a0,a0,a3
ffffffffc0201844:	60a6                	ld	ra,72(sp)
ffffffffc0201846:	6406                	ld	s0,64(sp)
ffffffffc0201848:	74e2                	ld	s1,56(sp)
ffffffffc020184a:	7942                	ld	s2,48(sp)
ffffffffc020184c:	79a2                	ld	s3,40(sp)
ffffffffc020184e:	7a02                	ld	s4,32(sp)
ffffffffc0201850:	6ae2                	ld	s5,24(sp)
ffffffffc0201852:	6b42                	ld	s6,16(sp)
ffffffffc0201854:	6ba2                	ld	s7,8(sp)
ffffffffc0201856:	6161                	addi	sp,sp,80
ffffffffc0201858:	8082                	ret
ffffffffc020185a:	4501                	li	a0,0
ffffffffc020185c:	b7e5                	j	ffffffffc0201844 <get_pte+0x178>
ffffffffc020185e:	00004617          	auipc	a2,0x4
ffffffffc0201862:	c7260613          	addi	a2,a2,-910 # ffffffffc02054d0 <default_pmm_manager+0x90>
ffffffffc0201866:	10200593          	li	a1,258
ffffffffc020186a:	00004517          	auipc	a0,0x4
ffffffffc020186e:	c8e50513          	addi	a0,a0,-882 # ffffffffc02054f8 <default_pmm_manager+0xb8>
ffffffffc0201872:	b03fe0ef          	jal	ra,ffffffffc0200374 <__panic>
ffffffffc0201876:	00004617          	auipc	a2,0x4
ffffffffc020187a:	c5a60613          	addi	a2,a2,-934 # ffffffffc02054d0 <default_pmm_manager+0x90>
ffffffffc020187e:	10f00593          	li	a1,271
ffffffffc0201882:	00004517          	auipc	a0,0x4
ffffffffc0201886:	c7650513          	addi	a0,a0,-906 # ffffffffc02054f8 <default_pmm_manager+0xb8>
ffffffffc020188a:	aebfe0ef          	jal	ra,ffffffffc0200374 <__panic>
ffffffffc020188e:	86aa                	mv	a3,a0
ffffffffc0201890:	00004617          	auipc	a2,0x4
ffffffffc0201894:	c4060613          	addi	a2,a2,-960 # ffffffffc02054d0 <default_pmm_manager+0x90>
ffffffffc0201898:	10b00593          	li	a1,267
ffffffffc020189c:	00004517          	auipc	a0,0x4
ffffffffc02018a0:	c5c50513          	addi	a0,a0,-932 # ffffffffc02054f8 <default_pmm_manager+0xb8>
ffffffffc02018a4:	ad1fe0ef          	jal	ra,ffffffffc0200374 <__panic>
ffffffffc02018a8:	86aa                	mv	a3,a0
ffffffffc02018aa:	00004617          	auipc	a2,0x4
ffffffffc02018ae:	c2660613          	addi	a2,a2,-986 # ffffffffc02054d0 <default_pmm_manager+0x90>
ffffffffc02018b2:	0ff00593          	li	a1,255
ffffffffc02018b6:	00004517          	auipc	a0,0x4
ffffffffc02018ba:	c4250513          	addi	a0,a0,-958 # ffffffffc02054f8 <default_pmm_manager+0xb8>
ffffffffc02018be:	ab7fe0ef          	jal	ra,ffffffffc0200374 <__panic>

ffffffffc02018c2 <get_page>:
ffffffffc02018c2:	1141                	addi	sp,sp,-16
ffffffffc02018c4:	e022                	sd	s0,0(sp)
ffffffffc02018c6:	8432                	mv	s0,a2
ffffffffc02018c8:	4601                	li	a2,0
ffffffffc02018ca:	e406                	sd	ra,8(sp)
ffffffffc02018cc:	e01ff0ef          	jal	ra,ffffffffc02016cc <get_pte>
ffffffffc02018d0:	c011                	beqz	s0,ffffffffc02018d4 <get_page+0x12>
ffffffffc02018d2:	e008                	sd	a0,0(s0)
ffffffffc02018d4:	c511                	beqz	a0,ffffffffc02018e0 <get_page+0x1e>
ffffffffc02018d6:	611c                	ld	a5,0(a0)
ffffffffc02018d8:	4501                	li	a0,0
ffffffffc02018da:	0017f713          	andi	a4,a5,1
ffffffffc02018de:	e709                	bnez	a4,ffffffffc02018e8 <get_page+0x26>
ffffffffc02018e0:	60a2                	ld	ra,8(sp)
ffffffffc02018e2:	6402                	ld	s0,0(sp)
ffffffffc02018e4:	0141                	addi	sp,sp,16
ffffffffc02018e6:	8082                	ret
ffffffffc02018e8:	078a                	slli	a5,a5,0x2
ffffffffc02018ea:	83b1                	srli	a5,a5,0xc
ffffffffc02018ec:	00010717          	auipc	a4,0x10
ffffffffc02018f0:	c3473703          	ld	a4,-972(a4) # ffffffffc0211520 <npage>
ffffffffc02018f4:	02e7f263          	bgeu	a5,a4,ffffffffc0201918 <get_page+0x56>
ffffffffc02018f8:	fff80537          	lui	a0,0xfff80
ffffffffc02018fc:	97aa                	add	a5,a5,a0
ffffffffc02018fe:	60a2                	ld	ra,8(sp)
ffffffffc0201900:	6402                	ld	s0,0(sp)
ffffffffc0201902:	00379513          	slli	a0,a5,0x3
ffffffffc0201906:	97aa                	add	a5,a5,a0
ffffffffc0201908:	078e                	slli	a5,a5,0x3
ffffffffc020190a:	00010517          	auipc	a0,0x10
ffffffffc020190e:	c1e53503          	ld	a0,-994(a0) # ffffffffc0211528 <pages>
ffffffffc0201912:	953e                	add	a0,a0,a5
ffffffffc0201914:	0141                	addi	sp,sp,16
ffffffffc0201916:	8082                	ret
ffffffffc0201918:	c71ff0ef          	jal	ra,ffffffffc0201588 <pa2page.part.0>

ffffffffc020191c <page_remove>:
ffffffffc020191c:	1101                	addi	sp,sp,-32
ffffffffc020191e:	4601                	li	a2,0
ffffffffc0201920:	ec06                	sd	ra,24(sp)
ffffffffc0201922:	e822                	sd	s0,16(sp)
ffffffffc0201924:	da9ff0ef          	jal	ra,ffffffffc02016cc <get_pte>
ffffffffc0201928:	c511                	beqz	a0,ffffffffc0201934 <page_remove+0x18>
ffffffffc020192a:	611c                	ld	a5,0(a0)
ffffffffc020192c:	842a                	mv	s0,a0
ffffffffc020192e:	0017f713          	andi	a4,a5,1
ffffffffc0201932:	e709                	bnez	a4,ffffffffc020193c <page_remove+0x20>
ffffffffc0201934:	60e2                	ld	ra,24(sp)
ffffffffc0201936:	6442                	ld	s0,16(sp)
ffffffffc0201938:	6105                	addi	sp,sp,32
ffffffffc020193a:	8082                	ret
ffffffffc020193c:	078a                	slli	a5,a5,0x2
ffffffffc020193e:	83b1                	srli	a5,a5,0xc
ffffffffc0201940:	00010717          	auipc	a4,0x10
ffffffffc0201944:	be073703          	ld	a4,-1056(a4) # ffffffffc0211520 <npage>
ffffffffc0201948:	06e7f563          	bgeu	a5,a4,ffffffffc02019b2 <page_remove+0x96>
ffffffffc020194c:	fff80737          	lui	a4,0xfff80
ffffffffc0201950:	97ba                	add	a5,a5,a4
ffffffffc0201952:	00379513          	slli	a0,a5,0x3
ffffffffc0201956:	97aa                	add	a5,a5,a0
ffffffffc0201958:	078e                	slli	a5,a5,0x3
ffffffffc020195a:	00010517          	auipc	a0,0x10
ffffffffc020195e:	bce53503          	ld	a0,-1074(a0) # ffffffffc0211528 <pages>
ffffffffc0201962:	953e                	add	a0,a0,a5
ffffffffc0201964:	411c                	lw	a5,0(a0)
ffffffffc0201966:	fff7871b          	addiw	a4,a5,-1
ffffffffc020196a:	c118                	sw	a4,0(a0)
ffffffffc020196c:	cb09                	beqz	a4,ffffffffc020197e <page_remove+0x62>
ffffffffc020196e:	00043023          	sd	zero,0(s0)
ffffffffc0201972:	12000073          	sfence.vma
ffffffffc0201976:	60e2                	ld	ra,24(sp)
ffffffffc0201978:	6442                	ld	s0,16(sp)
ffffffffc020197a:	6105                	addi	sp,sp,32
ffffffffc020197c:	8082                	ret
ffffffffc020197e:	100027f3          	csrr	a5,sstatus
ffffffffc0201982:	8b89                	andi	a5,a5,2
ffffffffc0201984:	eb89                	bnez	a5,ffffffffc0201996 <page_remove+0x7a>
ffffffffc0201986:	00010797          	auipc	a5,0x10
ffffffffc020198a:	baa7b783          	ld	a5,-1110(a5) # ffffffffc0211530 <pmm_manager>
ffffffffc020198e:	739c                	ld	a5,32(a5)
ffffffffc0201990:	4585                	li	a1,1
ffffffffc0201992:	9782                	jalr	a5
ffffffffc0201994:	bfe9                	j	ffffffffc020196e <page_remove+0x52>
ffffffffc0201996:	e42a                	sd	a0,8(sp)
ffffffffc0201998:	b57fe0ef          	jal	ra,ffffffffc02004ee <intr_disable>
ffffffffc020199c:	00010797          	auipc	a5,0x10
ffffffffc02019a0:	b947b783          	ld	a5,-1132(a5) # ffffffffc0211530 <pmm_manager>
ffffffffc02019a4:	739c                	ld	a5,32(a5)
ffffffffc02019a6:	6522                	ld	a0,8(sp)
ffffffffc02019a8:	4585                	li	a1,1
ffffffffc02019aa:	9782                	jalr	a5
ffffffffc02019ac:	b3dfe0ef          	jal	ra,ffffffffc02004e8 <intr_enable>
ffffffffc02019b0:	bf7d                	j	ffffffffc020196e <page_remove+0x52>
ffffffffc02019b2:	bd7ff0ef          	jal	ra,ffffffffc0201588 <pa2page.part.0>

ffffffffc02019b6 <page_insert>:
ffffffffc02019b6:	7179                	addi	sp,sp,-48
ffffffffc02019b8:	87b2                	mv	a5,a2
ffffffffc02019ba:	f022                	sd	s0,32(sp)
ffffffffc02019bc:	4605                	li	a2,1
ffffffffc02019be:	842e                	mv	s0,a1
ffffffffc02019c0:	85be                	mv	a1,a5
ffffffffc02019c2:	ec26                	sd	s1,24(sp)
ffffffffc02019c4:	f406                	sd	ra,40(sp)
ffffffffc02019c6:	e84a                	sd	s2,16(sp)
ffffffffc02019c8:	e44e                	sd	s3,8(sp)
ffffffffc02019ca:	e052                	sd	s4,0(sp)
ffffffffc02019cc:	84b6                	mv	s1,a3
ffffffffc02019ce:	cffff0ef          	jal	ra,ffffffffc02016cc <get_pte>
ffffffffc02019d2:	cd71                	beqz	a0,ffffffffc0201aae <page_insert+0xf8>
ffffffffc02019d4:	4014                	lw	a3,0(s0)
ffffffffc02019d6:	611c                	ld	a5,0(a0)
ffffffffc02019d8:	89aa                	mv	s3,a0
ffffffffc02019da:	0016871b          	addiw	a4,a3,1
ffffffffc02019de:	c018                	sw	a4,0(s0)
ffffffffc02019e0:	0017f713          	andi	a4,a5,1
ffffffffc02019e4:	e331                	bnez	a4,ffffffffc0201a28 <page_insert+0x72>
ffffffffc02019e6:	00010797          	auipc	a5,0x10
ffffffffc02019ea:	b427b783          	ld	a5,-1214(a5) # ffffffffc0211528 <pages>
ffffffffc02019ee:	40f407b3          	sub	a5,s0,a5
ffffffffc02019f2:	878d                	srai	a5,a5,0x3
ffffffffc02019f4:	00005417          	auipc	s0,0x5
ffffffffc02019f8:	cdc43403          	ld	s0,-804(s0) # ffffffffc02066d0 <error_string+0x38>
ffffffffc02019fc:	028787b3          	mul	a5,a5,s0
ffffffffc0201a00:	00080437          	lui	s0,0x80
ffffffffc0201a04:	97a2                	add	a5,a5,s0
ffffffffc0201a06:	07aa                	slli	a5,a5,0xa
ffffffffc0201a08:	8cdd                	or	s1,s1,a5
ffffffffc0201a0a:	0014e493          	ori	s1,s1,1
ffffffffc0201a0e:	0099b023          	sd	s1,0(s3)
ffffffffc0201a12:	12000073          	sfence.vma
ffffffffc0201a16:	4501                	li	a0,0
ffffffffc0201a18:	70a2                	ld	ra,40(sp)
ffffffffc0201a1a:	7402                	ld	s0,32(sp)
ffffffffc0201a1c:	64e2                	ld	s1,24(sp)
ffffffffc0201a1e:	6942                	ld	s2,16(sp)
ffffffffc0201a20:	69a2                	ld	s3,8(sp)
ffffffffc0201a22:	6a02                	ld	s4,0(sp)
ffffffffc0201a24:	6145                	addi	sp,sp,48
ffffffffc0201a26:	8082                	ret
ffffffffc0201a28:	00279713          	slli	a4,a5,0x2
ffffffffc0201a2c:	8331                	srli	a4,a4,0xc
ffffffffc0201a2e:	00010797          	auipc	a5,0x10
ffffffffc0201a32:	af27b783          	ld	a5,-1294(a5) # ffffffffc0211520 <npage>
ffffffffc0201a36:	06f77e63          	bgeu	a4,a5,ffffffffc0201ab2 <page_insert+0xfc>
ffffffffc0201a3a:	fff807b7          	lui	a5,0xfff80
ffffffffc0201a3e:	973e                	add	a4,a4,a5
ffffffffc0201a40:	00010a17          	auipc	s4,0x10
ffffffffc0201a44:	ae8a0a13          	addi	s4,s4,-1304 # ffffffffc0211528 <pages>
ffffffffc0201a48:	000a3783          	ld	a5,0(s4)
ffffffffc0201a4c:	00371913          	slli	s2,a4,0x3
ffffffffc0201a50:	993a                	add	s2,s2,a4
ffffffffc0201a52:	090e                	slli	s2,s2,0x3
ffffffffc0201a54:	993e                	add	s2,s2,a5
ffffffffc0201a56:	03240063          	beq	s0,s2,ffffffffc0201a76 <page_insert+0xc0>
ffffffffc0201a5a:	00092783          	lw	a5,0(s2)
ffffffffc0201a5e:	fff7871b          	addiw	a4,a5,-1
ffffffffc0201a62:	00e92023          	sw	a4,0(s2)
ffffffffc0201a66:	cb11                	beqz	a4,ffffffffc0201a7a <page_insert+0xc4>
ffffffffc0201a68:	0009b023          	sd	zero,0(s3)
ffffffffc0201a6c:	12000073          	sfence.vma
ffffffffc0201a70:	000a3783          	ld	a5,0(s4)
ffffffffc0201a74:	bfad                	j	ffffffffc02019ee <page_insert+0x38>
ffffffffc0201a76:	c014                	sw	a3,0(s0)
ffffffffc0201a78:	bf9d                	j	ffffffffc02019ee <page_insert+0x38>
ffffffffc0201a7a:	100027f3          	csrr	a5,sstatus
ffffffffc0201a7e:	8b89                	andi	a5,a5,2
ffffffffc0201a80:	eb91                	bnez	a5,ffffffffc0201a94 <page_insert+0xde>
ffffffffc0201a82:	00010797          	auipc	a5,0x10
ffffffffc0201a86:	aae7b783          	ld	a5,-1362(a5) # ffffffffc0211530 <pmm_manager>
ffffffffc0201a8a:	739c                	ld	a5,32(a5)
ffffffffc0201a8c:	4585                	li	a1,1
ffffffffc0201a8e:	854a                	mv	a0,s2
ffffffffc0201a90:	9782                	jalr	a5
ffffffffc0201a92:	bfd9                	j	ffffffffc0201a68 <page_insert+0xb2>
ffffffffc0201a94:	a5bfe0ef          	jal	ra,ffffffffc02004ee <intr_disable>
ffffffffc0201a98:	00010797          	auipc	a5,0x10
ffffffffc0201a9c:	a987b783          	ld	a5,-1384(a5) # ffffffffc0211530 <pmm_manager>
ffffffffc0201aa0:	739c                	ld	a5,32(a5)
ffffffffc0201aa2:	4585                	li	a1,1
ffffffffc0201aa4:	854a                	mv	a0,s2
ffffffffc0201aa6:	9782                	jalr	a5
ffffffffc0201aa8:	a41fe0ef          	jal	ra,ffffffffc02004e8 <intr_enable>
ffffffffc0201aac:	bf75                	j	ffffffffc0201a68 <page_insert+0xb2>
ffffffffc0201aae:	5571                	li	a0,-4
ffffffffc0201ab0:	b7a5                	j	ffffffffc0201a18 <page_insert+0x62>
ffffffffc0201ab2:	ad7ff0ef          	jal	ra,ffffffffc0201588 <pa2page.part.0>

ffffffffc0201ab6 <pmm_init>:
ffffffffc0201ab6:	00004797          	auipc	a5,0x4
ffffffffc0201aba:	98a78793          	addi	a5,a5,-1654 # ffffffffc0205440 <default_pmm_manager>
ffffffffc0201abe:	638c                	ld	a1,0(a5)
ffffffffc0201ac0:	7159                	addi	sp,sp,-112
ffffffffc0201ac2:	f45e                	sd	s7,40(sp)
ffffffffc0201ac4:	00004517          	auipc	a0,0x4
ffffffffc0201ac8:	a4450513          	addi	a0,a0,-1468 # ffffffffc0205508 <default_pmm_manager+0xc8>
ffffffffc0201acc:	00010b97          	auipc	s7,0x10
ffffffffc0201ad0:	a64b8b93          	addi	s7,s7,-1436 # ffffffffc0211530 <pmm_manager>
ffffffffc0201ad4:	f486                	sd	ra,104(sp)
ffffffffc0201ad6:	f0a2                	sd	s0,96(sp)
ffffffffc0201ad8:	eca6                	sd	s1,88(sp)
ffffffffc0201ada:	e8ca                	sd	s2,80(sp)
ffffffffc0201adc:	e4ce                	sd	s3,72(sp)
ffffffffc0201ade:	f85a                	sd	s6,48(sp)
ffffffffc0201ae0:	00fbb023          	sd	a5,0(s7)
ffffffffc0201ae4:	e0d2                	sd	s4,64(sp)
ffffffffc0201ae6:	fc56                	sd	s5,56(sp)
ffffffffc0201ae8:	f062                	sd	s8,32(sp)
ffffffffc0201aea:	ec66                	sd	s9,24(sp)
ffffffffc0201aec:	e86a                	sd	s10,16(sp)
ffffffffc0201aee:	dccfe0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc0201af2:	000bb783          	ld	a5,0(s7)
ffffffffc0201af6:	4445                	li	s0,17
ffffffffc0201af8:	40100913          	li	s2,1025
ffffffffc0201afc:	679c                	ld	a5,8(a5)
ffffffffc0201afe:	00010997          	auipc	s3,0x10
ffffffffc0201b02:	a3a98993          	addi	s3,s3,-1478 # ffffffffc0211538 <va_pa_offset>
ffffffffc0201b06:	00010497          	auipc	s1,0x10
ffffffffc0201b0a:	a1a48493          	addi	s1,s1,-1510 # ffffffffc0211520 <npage>
ffffffffc0201b0e:	9782                	jalr	a5
ffffffffc0201b10:	57f5                	li	a5,-3
ffffffffc0201b12:	07fa                	slli	a5,a5,0x1e
ffffffffc0201b14:	07e006b7          	lui	a3,0x7e00
ffffffffc0201b18:	01b41613          	slli	a2,s0,0x1b
ffffffffc0201b1c:	01591593          	slli	a1,s2,0x15
ffffffffc0201b20:	00004517          	auipc	a0,0x4
ffffffffc0201b24:	a0050513          	addi	a0,a0,-1536 # ffffffffc0205520 <default_pmm_manager+0xe0>
ffffffffc0201b28:	00f9b023          	sd	a5,0(s3)
ffffffffc0201b2c:	d8efe0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc0201b30:	00004517          	auipc	a0,0x4
ffffffffc0201b34:	a2050513          	addi	a0,a0,-1504 # ffffffffc0205550 <default_pmm_manager+0x110>
ffffffffc0201b38:	d82fe0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc0201b3c:	01b41693          	slli	a3,s0,0x1b
ffffffffc0201b40:	16fd                	addi	a3,a3,-1
ffffffffc0201b42:	07e005b7          	lui	a1,0x7e00
ffffffffc0201b46:	01591613          	slli	a2,s2,0x15
ffffffffc0201b4a:	00004517          	auipc	a0,0x4
ffffffffc0201b4e:	a1e50513          	addi	a0,a0,-1506 # ffffffffc0205568 <default_pmm_manager+0x128>
ffffffffc0201b52:	d68fe0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc0201b56:	777d                	lui	a4,0xfffff
ffffffffc0201b58:	00011797          	auipc	a5,0x11
ffffffffc0201b5c:	a0b78793          	addi	a5,a5,-1525 # ffffffffc0212563 <end+0xfff>
ffffffffc0201b60:	8ff9                	and	a5,a5,a4
ffffffffc0201b62:	00010b17          	auipc	s6,0x10
ffffffffc0201b66:	9c6b0b13          	addi	s6,s6,-1594 # ffffffffc0211528 <pages>
ffffffffc0201b6a:	00088737          	lui	a4,0x88
ffffffffc0201b6e:	e098                	sd	a4,0(s1)
ffffffffc0201b70:	00fb3023          	sd	a5,0(s6)
ffffffffc0201b74:	4681                	li	a3,0
ffffffffc0201b76:	4701                	li	a4,0
ffffffffc0201b78:	4505                	li	a0,1
ffffffffc0201b7a:	fff805b7          	lui	a1,0xfff80
ffffffffc0201b7e:	a019                	j	ffffffffc0201b84 <pmm_init+0xce>
ffffffffc0201b80:	000b3783          	ld	a5,0(s6)
ffffffffc0201b84:	97b6                	add	a5,a5,a3
ffffffffc0201b86:	07a1                	addi	a5,a5,8
ffffffffc0201b88:	40a7b02f          	amoor.d	zero,a0,(a5)
ffffffffc0201b8c:	609c                	ld	a5,0(s1)
ffffffffc0201b8e:	0705                	addi	a4,a4,1
ffffffffc0201b90:	04868693          	addi	a3,a3,72 # 7e00048 <kern_entry-0xffffffffb83fffb8>
ffffffffc0201b94:	00b78633          	add	a2,a5,a1
ffffffffc0201b98:	fec764e3          	bltu	a4,a2,ffffffffc0201b80 <pmm_init+0xca>
ffffffffc0201b9c:	000b3503          	ld	a0,0(s6)
ffffffffc0201ba0:	00379693          	slli	a3,a5,0x3
ffffffffc0201ba4:	96be                	add	a3,a3,a5
ffffffffc0201ba6:	fdc00737          	lui	a4,0xfdc00
ffffffffc0201baa:	972a                	add	a4,a4,a0
ffffffffc0201bac:	068e                	slli	a3,a3,0x3
ffffffffc0201bae:	96ba                	add	a3,a3,a4
ffffffffc0201bb0:	c0200737          	lui	a4,0xc0200
ffffffffc0201bb4:	64e6e463          	bltu	a3,a4,ffffffffc02021fc <pmm_init+0x746>
ffffffffc0201bb8:	0009b703          	ld	a4,0(s3)
ffffffffc0201bbc:	4645                	li	a2,17
ffffffffc0201bbe:	066e                	slli	a2,a2,0x1b
ffffffffc0201bc0:	8e99                	sub	a3,a3,a4
ffffffffc0201bc2:	4ec6e263          	bltu	a3,a2,ffffffffc02020a6 <pmm_init+0x5f0>
ffffffffc0201bc6:	000bb783          	ld	a5,0(s7)
ffffffffc0201bca:	00010917          	auipc	s2,0x10
ffffffffc0201bce:	94e90913          	addi	s2,s2,-1714 # ffffffffc0211518 <boot_pgdir>
ffffffffc0201bd2:	7b9c                	ld	a5,48(a5)
ffffffffc0201bd4:	9782                	jalr	a5
ffffffffc0201bd6:	00004517          	auipc	a0,0x4
ffffffffc0201bda:	9e250513          	addi	a0,a0,-1566 # ffffffffc02055b8 <default_pmm_manager+0x178>
ffffffffc0201bde:	cdcfe0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc0201be2:	00007697          	auipc	a3,0x7
ffffffffc0201be6:	41e68693          	addi	a3,a3,1054 # ffffffffc0209000 <boot_page_table_sv39>
ffffffffc0201bea:	00d93023          	sd	a3,0(s2)
ffffffffc0201bee:	c02007b7          	lui	a5,0xc0200
ffffffffc0201bf2:	62f6e163          	bltu	a3,a5,ffffffffc0202214 <pmm_init+0x75e>
ffffffffc0201bf6:	0009b783          	ld	a5,0(s3)
ffffffffc0201bfa:	8e9d                	sub	a3,a3,a5
ffffffffc0201bfc:	00010797          	auipc	a5,0x10
ffffffffc0201c00:	90d7ba23          	sd	a3,-1772(a5) # ffffffffc0211510 <boot_cr3>
ffffffffc0201c04:	100027f3          	csrr	a5,sstatus
ffffffffc0201c08:	8b89                	andi	a5,a5,2
ffffffffc0201c0a:	4c079763          	bnez	a5,ffffffffc02020d8 <pmm_init+0x622>
ffffffffc0201c0e:	000bb783          	ld	a5,0(s7)
ffffffffc0201c12:	779c                	ld	a5,40(a5)
ffffffffc0201c14:	9782                	jalr	a5
ffffffffc0201c16:	842a                	mv	s0,a0
ffffffffc0201c18:	6098                	ld	a4,0(s1)
ffffffffc0201c1a:	c80007b7          	lui	a5,0xc8000
ffffffffc0201c1e:	83b1                	srli	a5,a5,0xc
ffffffffc0201c20:	62e7e663          	bltu	a5,a4,ffffffffc020224c <pmm_init+0x796>
ffffffffc0201c24:	00093503          	ld	a0,0(s2)
ffffffffc0201c28:	60050263          	beqz	a0,ffffffffc020222c <pmm_init+0x776>
ffffffffc0201c2c:	03451793          	slli	a5,a0,0x34
ffffffffc0201c30:	5e079e63          	bnez	a5,ffffffffc020222c <pmm_init+0x776>
ffffffffc0201c34:	4601                	li	a2,0
ffffffffc0201c36:	4581                	li	a1,0
ffffffffc0201c38:	c8bff0ef          	jal	ra,ffffffffc02018c2 <get_page>
ffffffffc0201c3c:	66051a63          	bnez	a0,ffffffffc02022b0 <pmm_init+0x7fa>
ffffffffc0201c40:	4505                	li	a0,1
ffffffffc0201c42:	97fff0ef          	jal	ra,ffffffffc02015c0 <alloc_pages>
ffffffffc0201c46:	8a2a                	mv	s4,a0
ffffffffc0201c48:	00093503          	ld	a0,0(s2)
ffffffffc0201c4c:	4681                	li	a3,0
ffffffffc0201c4e:	4601                	li	a2,0
ffffffffc0201c50:	85d2                	mv	a1,s4
ffffffffc0201c52:	d65ff0ef          	jal	ra,ffffffffc02019b6 <page_insert>
ffffffffc0201c56:	62051d63          	bnez	a0,ffffffffc0202290 <pmm_init+0x7da>
ffffffffc0201c5a:	00093503          	ld	a0,0(s2)
ffffffffc0201c5e:	4601                	li	a2,0
ffffffffc0201c60:	4581                	li	a1,0
ffffffffc0201c62:	a6bff0ef          	jal	ra,ffffffffc02016cc <get_pte>
ffffffffc0201c66:	60050563          	beqz	a0,ffffffffc0202270 <pmm_init+0x7ba>
ffffffffc0201c6a:	611c                	ld	a5,0(a0)
ffffffffc0201c6c:	0017f713          	andi	a4,a5,1
ffffffffc0201c70:	5e070e63          	beqz	a4,ffffffffc020226c <pmm_init+0x7b6>
ffffffffc0201c74:	6090                	ld	a2,0(s1)
ffffffffc0201c76:	078a                	slli	a5,a5,0x2
ffffffffc0201c78:	83b1                	srli	a5,a5,0xc
ffffffffc0201c7a:	56c7ff63          	bgeu	a5,a2,ffffffffc02021f8 <pmm_init+0x742>
ffffffffc0201c7e:	fff80737          	lui	a4,0xfff80
ffffffffc0201c82:	97ba                	add	a5,a5,a4
ffffffffc0201c84:	000b3683          	ld	a3,0(s6)
ffffffffc0201c88:	00379713          	slli	a4,a5,0x3
ffffffffc0201c8c:	97ba                	add	a5,a5,a4
ffffffffc0201c8e:	078e                	slli	a5,a5,0x3
ffffffffc0201c90:	97b6                	add	a5,a5,a3
ffffffffc0201c92:	14fa18e3          	bne	s4,a5,ffffffffc02025e2 <pmm_init+0xb2c>
ffffffffc0201c96:	000a2703          	lw	a4,0(s4)
ffffffffc0201c9a:	4785                	li	a5,1
ffffffffc0201c9c:	16f71fe3          	bne	a4,a5,ffffffffc020261a <pmm_init+0xb64>
ffffffffc0201ca0:	00093503          	ld	a0,0(s2)
ffffffffc0201ca4:	77fd                	lui	a5,0xfffff
ffffffffc0201ca6:	6114                	ld	a3,0(a0)
ffffffffc0201ca8:	068a                	slli	a3,a3,0x2
ffffffffc0201caa:	8efd                	and	a3,a3,a5
ffffffffc0201cac:	00c6d713          	srli	a4,a3,0xc
ffffffffc0201cb0:	14c779e3          	bgeu	a4,a2,ffffffffc0202602 <pmm_init+0xb4c>
ffffffffc0201cb4:	0009bc03          	ld	s8,0(s3)
ffffffffc0201cb8:	96e2                	add	a3,a3,s8
ffffffffc0201cba:	0006ba83          	ld	s5,0(a3)
ffffffffc0201cbe:	0a8a                	slli	s5,s5,0x2
ffffffffc0201cc0:	00fafab3          	and	s5,s5,a5
ffffffffc0201cc4:	00cad793          	srli	a5,s5,0xc
ffffffffc0201cc8:	66c7f463          	bgeu	a5,a2,ffffffffc0202330 <pmm_init+0x87a>
ffffffffc0201ccc:	4601                	li	a2,0
ffffffffc0201cce:	6585                	lui	a1,0x1
ffffffffc0201cd0:	9ae2                	add	s5,s5,s8
ffffffffc0201cd2:	9fbff0ef          	jal	ra,ffffffffc02016cc <get_pte>
ffffffffc0201cd6:	0aa1                	addi	s5,s5,8
ffffffffc0201cd8:	63551c63          	bne	a0,s5,ffffffffc0202310 <pmm_init+0x85a>
ffffffffc0201cdc:	4505                	li	a0,1
ffffffffc0201cde:	8e3ff0ef          	jal	ra,ffffffffc02015c0 <alloc_pages>
ffffffffc0201ce2:	8aaa                	mv	s5,a0
ffffffffc0201ce4:	00093503          	ld	a0,0(s2)
ffffffffc0201ce8:	46d1                	li	a3,20
ffffffffc0201cea:	6605                	lui	a2,0x1
ffffffffc0201cec:	85d6                	mv	a1,s5
ffffffffc0201cee:	cc9ff0ef          	jal	ra,ffffffffc02019b6 <page_insert>
ffffffffc0201cf2:	5c051f63          	bnez	a0,ffffffffc02022d0 <pmm_init+0x81a>
ffffffffc0201cf6:	00093503          	ld	a0,0(s2)
ffffffffc0201cfa:	4601                	li	a2,0
ffffffffc0201cfc:	6585                	lui	a1,0x1
ffffffffc0201cfe:	9cfff0ef          	jal	ra,ffffffffc02016cc <get_pte>
ffffffffc0201d02:	12050ce3          	beqz	a0,ffffffffc020263a <pmm_init+0xb84>
ffffffffc0201d06:	611c                	ld	a5,0(a0)
ffffffffc0201d08:	0107f713          	andi	a4,a5,16
ffffffffc0201d0c:	72070f63          	beqz	a4,ffffffffc020244a <pmm_init+0x994>
ffffffffc0201d10:	8b91                	andi	a5,a5,4
ffffffffc0201d12:	6e078c63          	beqz	a5,ffffffffc020240a <pmm_init+0x954>
ffffffffc0201d16:	00093503          	ld	a0,0(s2)
ffffffffc0201d1a:	611c                	ld	a5,0(a0)
ffffffffc0201d1c:	8bc1                	andi	a5,a5,16
ffffffffc0201d1e:	6c078663          	beqz	a5,ffffffffc02023ea <pmm_init+0x934>
ffffffffc0201d22:	000aa703          	lw	a4,0(s5)
ffffffffc0201d26:	4785                	li	a5,1
ffffffffc0201d28:	5cf71463          	bne	a4,a5,ffffffffc02022f0 <pmm_init+0x83a>
ffffffffc0201d2c:	4681                	li	a3,0
ffffffffc0201d2e:	6605                	lui	a2,0x1
ffffffffc0201d30:	85d2                	mv	a1,s4
ffffffffc0201d32:	c85ff0ef          	jal	ra,ffffffffc02019b6 <page_insert>
ffffffffc0201d36:	66051a63          	bnez	a0,ffffffffc02023aa <pmm_init+0x8f4>
ffffffffc0201d3a:	000a2703          	lw	a4,0(s4)
ffffffffc0201d3e:	4789                	li	a5,2
ffffffffc0201d40:	64f71563          	bne	a4,a5,ffffffffc020238a <pmm_init+0x8d4>
ffffffffc0201d44:	000aa783          	lw	a5,0(s5)
ffffffffc0201d48:	62079163          	bnez	a5,ffffffffc020236a <pmm_init+0x8b4>
ffffffffc0201d4c:	00093503          	ld	a0,0(s2)
ffffffffc0201d50:	4601                	li	a2,0
ffffffffc0201d52:	6585                	lui	a1,0x1
ffffffffc0201d54:	979ff0ef          	jal	ra,ffffffffc02016cc <get_pte>
ffffffffc0201d58:	5e050963          	beqz	a0,ffffffffc020234a <pmm_init+0x894>
ffffffffc0201d5c:	6118                	ld	a4,0(a0)
ffffffffc0201d5e:	00177793          	andi	a5,a4,1
ffffffffc0201d62:	50078563          	beqz	a5,ffffffffc020226c <pmm_init+0x7b6>
ffffffffc0201d66:	6094                	ld	a3,0(s1)
ffffffffc0201d68:	00271793          	slli	a5,a4,0x2
ffffffffc0201d6c:	83b1                	srli	a5,a5,0xc
ffffffffc0201d6e:	48d7f563          	bgeu	a5,a3,ffffffffc02021f8 <pmm_init+0x742>
ffffffffc0201d72:	fff806b7          	lui	a3,0xfff80
ffffffffc0201d76:	97b6                	add	a5,a5,a3
ffffffffc0201d78:	000b3603          	ld	a2,0(s6)
ffffffffc0201d7c:	00379693          	slli	a3,a5,0x3
ffffffffc0201d80:	97b6                	add	a5,a5,a3
ffffffffc0201d82:	078e                	slli	a5,a5,0x3
ffffffffc0201d84:	97b2                	add	a5,a5,a2
ffffffffc0201d86:	72fa1263          	bne	s4,a5,ffffffffc02024aa <pmm_init+0x9f4>
ffffffffc0201d8a:	8b41                	andi	a4,a4,16
ffffffffc0201d8c:	6e071f63          	bnez	a4,ffffffffc020248a <pmm_init+0x9d4>
ffffffffc0201d90:	00093503          	ld	a0,0(s2)
ffffffffc0201d94:	4581                	li	a1,0
ffffffffc0201d96:	b87ff0ef          	jal	ra,ffffffffc020191c <page_remove>
ffffffffc0201d9a:	000a2703          	lw	a4,0(s4)
ffffffffc0201d9e:	4785                	li	a5,1
ffffffffc0201da0:	6cf71563          	bne	a4,a5,ffffffffc020246a <pmm_init+0x9b4>
ffffffffc0201da4:	000aa783          	lw	a5,0(s5)
ffffffffc0201da8:	78079d63          	bnez	a5,ffffffffc0202542 <pmm_init+0xa8c>
ffffffffc0201dac:	00093503          	ld	a0,0(s2)
ffffffffc0201db0:	6585                	lui	a1,0x1
ffffffffc0201db2:	b6bff0ef          	jal	ra,ffffffffc020191c <page_remove>
ffffffffc0201db6:	000a2783          	lw	a5,0(s4)
ffffffffc0201dba:	76079463          	bnez	a5,ffffffffc0202522 <pmm_init+0xa6c>
ffffffffc0201dbe:	000aa783          	lw	a5,0(s5)
ffffffffc0201dc2:	74079063          	bnez	a5,ffffffffc0202502 <pmm_init+0xa4c>
ffffffffc0201dc6:	00093a03          	ld	s4,0(s2)
ffffffffc0201dca:	6090                	ld	a2,0(s1)
ffffffffc0201dcc:	000a3783          	ld	a5,0(s4)
ffffffffc0201dd0:	078a                	slli	a5,a5,0x2
ffffffffc0201dd2:	83b1                	srli	a5,a5,0xc
ffffffffc0201dd4:	42c7f263          	bgeu	a5,a2,ffffffffc02021f8 <pmm_init+0x742>
ffffffffc0201dd8:	fff80737          	lui	a4,0xfff80
ffffffffc0201ddc:	973e                	add	a4,a4,a5
ffffffffc0201dde:	00371793          	slli	a5,a4,0x3
ffffffffc0201de2:	000b3503          	ld	a0,0(s6)
ffffffffc0201de6:	97ba                	add	a5,a5,a4
ffffffffc0201de8:	078e                	slli	a5,a5,0x3
ffffffffc0201dea:	00f50733          	add	a4,a0,a5
ffffffffc0201dee:	4314                	lw	a3,0(a4)
ffffffffc0201df0:	4705                	li	a4,1
ffffffffc0201df2:	6ee69863          	bne	a3,a4,ffffffffc02024e2 <pmm_init+0xa2c>
ffffffffc0201df6:	4037d693          	srai	a3,a5,0x3
ffffffffc0201dfa:	00005c97          	auipc	s9,0x5
ffffffffc0201dfe:	8d6cbc83          	ld	s9,-1834(s9) # ffffffffc02066d0 <error_string+0x38>
ffffffffc0201e02:	039686b3          	mul	a3,a3,s9
ffffffffc0201e06:	000805b7          	lui	a1,0x80
ffffffffc0201e0a:	96ae                	add	a3,a3,a1
ffffffffc0201e0c:	00c69713          	slli	a4,a3,0xc
ffffffffc0201e10:	8331                	srli	a4,a4,0xc
ffffffffc0201e12:	06b2                	slli	a3,a3,0xc
ffffffffc0201e14:	6ac77b63          	bgeu	a4,a2,ffffffffc02024ca <pmm_init+0xa14>
ffffffffc0201e18:	0009b703          	ld	a4,0(s3)
ffffffffc0201e1c:	96ba                	add	a3,a3,a4
ffffffffc0201e1e:	629c                	ld	a5,0(a3)
ffffffffc0201e20:	078a                	slli	a5,a5,0x2
ffffffffc0201e22:	83b1                	srli	a5,a5,0xc
ffffffffc0201e24:	3cc7fa63          	bgeu	a5,a2,ffffffffc02021f8 <pmm_init+0x742>
ffffffffc0201e28:	8f8d                	sub	a5,a5,a1
ffffffffc0201e2a:	00379713          	slli	a4,a5,0x3
ffffffffc0201e2e:	97ba                	add	a5,a5,a4
ffffffffc0201e30:	078e                	slli	a5,a5,0x3
ffffffffc0201e32:	953e                	add	a0,a0,a5
ffffffffc0201e34:	100027f3          	csrr	a5,sstatus
ffffffffc0201e38:	8b89                	andi	a5,a5,2
ffffffffc0201e3a:	2e079963          	bnez	a5,ffffffffc020212c <pmm_init+0x676>
ffffffffc0201e3e:	000bb783          	ld	a5,0(s7)
ffffffffc0201e42:	4585                	li	a1,1
ffffffffc0201e44:	739c                	ld	a5,32(a5)
ffffffffc0201e46:	9782                	jalr	a5
ffffffffc0201e48:	000a3783          	ld	a5,0(s4)
ffffffffc0201e4c:	6098                	ld	a4,0(s1)
ffffffffc0201e4e:	078a                	slli	a5,a5,0x2
ffffffffc0201e50:	83b1                	srli	a5,a5,0xc
ffffffffc0201e52:	3ae7f363          	bgeu	a5,a4,ffffffffc02021f8 <pmm_init+0x742>
ffffffffc0201e56:	fff80737          	lui	a4,0xfff80
ffffffffc0201e5a:	97ba                	add	a5,a5,a4
ffffffffc0201e5c:	000b3503          	ld	a0,0(s6)
ffffffffc0201e60:	00379713          	slli	a4,a5,0x3
ffffffffc0201e64:	97ba                	add	a5,a5,a4
ffffffffc0201e66:	078e                	slli	a5,a5,0x3
ffffffffc0201e68:	953e                	add	a0,a0,a5
ffffffffc0201e6a:	100027f3          	csrr	a5,sstatus
ffffffffc0201e6e:	8b89                	andi	a5,a5,2
ffffffffc0201e70:	2a079263          	bnez	a5,ffffffffc0202114 <pmm_init+0x65e>
ffffffffc0201e74:	000bb783          	ld	a5,0(s7)
ffffffffc0201e78:	4585                	li	a1,1
ffffffffc0201e7a:	739c                	ld	a5,32(a5)
ffffffffc0201e7c:	9782                	jalr	a5
ffffffffc0201e7e:	00093783          	ld	a5,0(s2)
ffffffffc0201e82:	0007b023          	sd	zero,0(a5) # fffffffffffff000 <end+0x3fdeda9c>
ffffffffc0201e86:	100027f3          	csrr	a5,sstatus
ffffffffc0201e8a:	8b89                	andi	a5,a5,2
ffffffffc0201e8c:	26079a63          	bnez	a5,ffffffffc0202100 <pmm_init+0x64a>
ffffffffc0201e90:	000bb783          	ld	a5,0(s7)
ffffffffc0201e94:	779c                	ld	a5,40(a5)
ffffffffc0201e96:	9782                	jalr	a5
ffffffffc0201e98:	8a2a                	mv	s4,a0
ffffffffc0201e9a:	73441463          	bne	s0,s4,ffffffffc02025c2 <pmm_init+0xb0c>
ffffffffc0201e9e:	00004517          	auipc	a0,0x4
ffffffffc0201ea2:	a0250513          	addi	a0,a0,-1534 # ffffffffc02058a0 <default_pmm_manager+0x460>
ffffffffc0201ea6:	a14fe0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc0201eaa:	100027f3          	csrr	a5,sstatus
ffffffffc0201eae:	8b89                	andi	a5,a5,2
ffffffffc0201eb0:	22079e63          	bnez	a5,ffffffffc02020ec <pmm_init+0x636>
ffffffffc0201eb4:	000bb783          	ld	a5,0(s7)
ffffffffc0201eb8:	779c                	ld	a5,40(a5)
ffffffffc0201eba:	9782                	jalr	a5
ffffffffc0201ebc:	8c2a                	mv	s8,a0
ffffffffc0201ebe:	6098                	ld	a4,0(s1)
ffffffffc0201ec0:	c0200437          	lui	s0,0xc0200
ffffffffc0201ec4:	7afd                	lui	s5,0xfffff
ffffffffc0201ec6:	00c71793          	slli	a5,a4,0xc
ffffffffc0201eca:	6a05                	lui	s4,0x1
ffffffffc0201ecc:	02f47c63          	bgeu	s0,a5,ffffffffc0201f04 <pmm_init+0x44e>
ffffffffc0201ed0:	00c45793          	srli	a5,s0,0xc
ffffffffc0201ed4:	00093503          	ld	a0,0(s2)
ffffffffc0201ed8:	30e7f363          	bgeu	a5,a4,ffffffffc02021de <pmm_init+0x728>
ffffffffc0201edc:	0009b583          	ld	a1,0(s3)
ffffffffc0201ee0:	4601                	li	a2,0
ffffffffc0201ee2:	95a2                	add	a1,a1,s0
ffffffffc0201ee4:	fe8ff0ef          	jal	ra,ffffffffc02016cc <get_pte>
ffffffffc0201ee8:	2c050b63          	beqz	a0,ffffffffc02021be <pmm_init+0x708>
ffffffffc0201eec:	611c                	ld	a5,0(a0)
ffffffffc0201eee:	078a                	slli	a5,a5,0x2
ffffffffc0201ef0:	0157f7b3          	and	a5,a5,s5
ffffffffc0201ef4:	2a879563          	bne	a5,s0,ffffffffc020219e <pmm_init+0x6e8>
ffffffffc0201ef8:	6098                	ld	a4,0(s1)
ffffffffc0201efa:	9452                	add	s0,s0,s4
ffffffffc0201efc:	00c71793          	slli	a5,a4,0xc
ffffffffc0201f00:	fcf468e3          	bltu	s0,a5,ffffffffc0201ed0 <pmm_init+0x41a>
ffffffffc0201f04:	00093783          	ld	a5,0(s2)
ffffffffc0201f08:	639c                	ld	a5,0(a5)
ffffffffc0201f0a:	68079c63          	bnez	a5,ffffffffc02025a2 <pmm_init+0xaec>
ffffffffc0201f0e:	4505                	li	a0,1
ffffffffc0201f10:	eb0ff0ef          	jal	ra,ffffffffc02015c0 <alloc_pages>
ffffffffc0201f14:	8aaa                	mv	s5,a0
ffffffffc0201f16:	00093503          	ld	a0,0(s2)
ffffffffc0201f1a:	4699                	li	a3,6
ffffffffc0201f1c:	10000613          	li	a2,256
ffffffffc0201f20:	85d6                	mv	a1,s5
ffffffffc0201f22:	a95ff0ef          	jal	ra,ffffffffc02019b6 <page_insert>
ffffffffc0201f26:	64051e63          	bnez	a0,ffffffffc0202582 <pmm_init+0xacc>
ffffffffc0201f2a:	000aa703          	lw	a4,0(s5) # fffffffffffff000 <end+0x3fdeda9c>
ffffffffc0201f2e:	4785                	li	a5,1
ffffffffc0201f30:	62f71963          	bne	a4,a5,ffffffffc0202562 <pmm_init+0xaac>
ffffffffc0201f34:	00093503          	ld	a0,0(s2)
ffffffffc0201f38:	6405                	lui	s0,0x1
ffffffffc0201f3a:	4699                	li	a3,6
ffffffffc0201f3c:	10040613          	addi	a2,s0,256 # 1100 <kern_entry-0xffffffffc01fef00>
ffffffffc0201f40:	85d6                	mv	a1,s5
ffffffffc0201f42:	a75ff0ef          	jal	ra,ffffffffc02019b6 <page_insert>
ffffffffc0201f46:	48051263          	bnez	a0,ffffffffc02023ca <pmm_init+0x914>
ffffffffc0201f4a:	000aa703          	lw	a4,0(s5)
ffffffffc0201f4e:	4789                	li	a5,2
ffffffffc0201f50:	74f71563          	bne	a4,a5,ffffffffc020269a <pmm_init+0xbe4>
ffffffffc0201f54:	00004597          	auipc	a1,0x4
ffffffffc0201f58:	a8458593          	addi	a1,a1,-1404 # ffffffffc02059d8 <default_pmm_manager+0x598>
ffffffffc0201f5c:	10000513          	li	a0,256
ffffffffc0201f60:	72a020ef          	jal	ra,ffffffffc020468a <strcpy>
ffffffffc0201f64:	10040593          	addi	a1,s0,256
ffffffffc0201f68:	10000513          	li	a0,256
ffffffffc0201f6c:	730020ef          	jal	ra,ffffffffc020469c <strcmp>
ffffffffc0201f70:	70051563          	bnez	a0,ffffffffc020267a <pmm_init+0xbc4>
ffffffffc0201f74:	000b3683          	ld	a3,0(s6)
ffffffffc0201f78:	00080d37          	lui	s10,0x80
ffffffffc0201f7c:	547d                	li	s0,-1
ffffffffc0201f7e:	40da86b3          	sub	a3,s5,a3
ffffffffc0201f82:	868d                	srai	a3,a3,0x3
ffffffffc0201f84:	039686b3          	mul	a3,a3,s9
ffffffffc0201f88:	609c                	ld	a5,0(s1)
ffffffffc0201f8a:	8031                	srli	s0,s0,0xc
ffffffffc0201f8c:	96ea                	add	a3,a3,s10
ffffffffc0201f8e:	0086f733          	and	a4,a3,s0
ffffffffc0201f92:	06b2                	slli	a3,a3,0xc
ffffffffc0201f94:	52f77b63          	bgeu	a4,a5,ffffffffc02024ca <pmm_init+0xa14>
ffffffffc0201f98:	0009b783          	ld	a5,0(s3)
ffffffffc0201f9c:	10000513          	li	a0,256
ffffffffc0201fa0:	96be                	add	a3,a3,a5
ffffffffc0201fa2:	10068023          	sb	zero,256(a3) # fffffffffff80100 <end+0x3fd6eb9c>
ffffffffc0201fa6:	6ae020ef          	jal	ra,ffffffffc0204654 <strlen>
ffffffffc0201faa:	6a051863          	bnez	a0,ffffffffc020265a <pmm_init+0xba4>
ffffffffc0201fae:	00093a03          	ld	s4,0(s2)
ffffffffc0201fb2:	6098                	ld	a4,0(s1)
ffffffffc0201fb4:	000a3783          	ld	a5,0(s4) # 1000 <kern_entry-0xffffffffc01ff000>
ffffffffc0201fb8:	078a                	slli	a5,a5,0x2
ffffffffc0201fba:	83b1                	srli	a5,a5,0xc
ffffffffc0201fbc:	22e7fe63          	bgeu	a5,a4,ffffffffc02021f8 <pmm_init+0x742>
ffffffffc0201fc0:	41a787b3          	sub	a5,a5,s10
ffffffffc0201fc4:	00379693          	slli	a3,a5,0x3
ffffffffc0201fc8:	96be                	add	a3,a3,a5
ffffffffc0201fca:	03968cb3          	mul	s9,a3,s9
ffffffffc0201fce:	01ac86b3          	add	a3,s9,s10
ffffffffc0201fd2:	8c75                	and	s0,s0,a3
ffffffffc0201fd4:	06b2                	slli	a3,a3,0xc
ffffffffc0201fd6:	4ee47a63          	bgeu	s0,a4,ffffffffc02024ca <pmm_init+0xa14>
ffffffffc0201fda:	0009b403          	ld	s0,0(s3)
ffffffffc0201fde:	9436                	add	s0,s0,a3
ffffffffc0201fe0:	100027f3          	csrr	a5,sstatus
ffffffffc0201fe4:	8b89                	andi	a5,a5,2
ffffffffc0201fe6:	1a079163          	bnez	a5,ffffffffc0202188 <pmm_init+0x6d2>
ffffffffc0201fea:	000bb783          	ld	a5,0(s7)
ffffffffc0201fee:	4585                	li	a1,1
ffffffffc0201ff0:	8556                	mv	a0,s5
ffffffffc0201ff2:	739c                	ld	a5,32(a5)
ffffffffc0201ff4:	9782                	jalr	a5
ffffffffc0201ff6:	601c                	ld	a5,0(s0)
ffffffffc0201ff8:	6098                	ld	a4,0(s1)
ffffffffc0201ffa:	078a                	slli	a5,a5,0x2
ffffffffc0201ffc:	83b1                	srli	a5,a5,0xc
ffffffffc0201ffe:	1ee7fd63          	bgeu	a5,a4,ffffffffc02021f8 <pmm_init+0x742>
ffffffffc0202002:	fff80737          	lui	a4,0xfff80
ffffffffc0202006:	97ba                	add	a5,a5,a4
ffffffffc0202008:	000b3503          	ld	a0,0(s6)
ffffffffc020200c:	00379713          	slli	a4,a5,0x3
ffffffffc0202010:	97ba                	add	a5,a5,a4
ffffffffc0202012:	078e                	slli	a5,a5,0x3
ffffffffc0202014:	953e                	add	a0,a0,a5
ffffffffc0202016:	100027f3          	csrr	a5,sstatus
ffffffffc020201a:	8b89                	andi	a5,a5,2
ffffffffc020201c:	14079a63          	bnez	a5,ffffffffc0202170 <pmm_init+0x6ba>
ffffffffc0202020:	000bb783          	ld	a5,0(s7)
ffffffffc0202024:	4585                	li	a1,1
ffffffffc0202026:	739c                	ld	a5,32(a5)
ffffffffc0202028:	9782                	jalr	a5
ffffffffc020202a:	000a3783          	ld	a5,0(s4)
ffffffffc020202e:	6098                	ld	a4,0(s1)
ffffffffc0202030:	078a                	slli	a5,a5,0x2
ffffffffc0202032:	83b1                	srli	a5,a5,0xc
ffffffffc0202034:	1ce7f263          	bgeu	a5,a4,ffffffffc02021f8 <pmm_init+0x742>
ffffffffc0202038:	fff80737          	lui	a4,0xfff80
ffffffffc020203c:	97ba                	add	a5,a5,a4
ffffffffc020203e:	000b3503          	ld	a0,0(s6)
ffffffffc0202042:	00379713          	slli	a4,a5,0x3
ffffffffc0202046:	97ba                	add	a5,a5,a4
ffffffffc0202048:	078e                	slli	a5,a5,0x3
ffffffffc020204a:	953e                	add	a0,a0,a5
ffffffffc020204c:	100027f3          	csrr	a5,sstatus
ffffffffc0202050:	8b89                	andi	a5,a5,2
ffffffffc0202052:	10079363          	bnez	a5,ffffffffc0202158 <pmm_init+0x6a2>
ffffffffc0202056:	000bb783          	ld	a5,0(s7)
ffffffffc020205a:	4585                	li	a1,1
ffffffffc020205c:	739c                	ld	a5,32(a5)
ffffffffc020205e:	9782                	jalr	a5
ffffffffc0202060:	00093783          	ld	a5,0(s2)
ffffffffc0202064:	0007b023          	sd	zero,0(a5)
ffffffffc0202068:	100027f3          	csrr	a5,sstatus
ffffffffc020206c:	8b89                	andi	a5,a5,2
ffffffffc020206e:	0c079b63          	bnez	a5,ffffffffc0202144 <pmm_init+0x68e>
ffffffffc0202072:	000bb783          	ld	a5,0(s7)
ffffffffc0202076:	779c                	ld	a5,40(a5)
ffffffffc0202078:	9782                	jalr	a5
ffffffffc020207a:	842a                	mv	s0,a0
ffffffffc020207c:	3a8c1763          	bne	s8,s0,ffffffffc020242a <pmm_init+0x974>
ffffffffc0202080:	7406                	ld	s0,96(sp)
ffffffffc0202082:	70a6                	ld	ra,104(sp)
ffffffffc0202084:	64e6                	ld	s1,88(sp)
ffffffffc0202086:	6946                	ld	s2,80(sp)
ffffffffc0202088:	69a6                	ld	s3,72(sp)
ffffffffc020208a:	6a06                	ld	s4,64(sp)
ffffffffc020208c:	7ae2                	ld	s5,56(sp)
ffffffffc020208e:	7b42                	ld	s6,48(sp)
ffffffffc0202090:	7ba2                	ld	s7,40(sp)
ffffffffc0202092:	7c02                	ld	s8,32(sp)
ffffffffc0202094:	6ce2                	ld	s9,24(sp)
ffffffffc0202096:	6d42                	ld	s10,16(sp)
ffffffffc0202098:	00004517          	auipc	a0,0x4
ffffffffc020209c:	9b850513          	addi	a0,a0,-1608 # ffffffffc0205a50 <default_pmm_manager+0x610>
ffffffffc02020a0:	6165                	addi	sp,sp,112
ffffffffc02020a2:	818fe06f          	j	ffffffffc02000ba <cprintf>
ffffffffc02020a6:	6705                	lui	a4,0x1
ffffffffc02020a8:	177d                	addi	a4,a4,-1
ffffffffc02020aa:	96ba                	add	a3,a3,a4
ffffffffc02020ac:	777d                	lui	a4,0xfffff
ffffffffc02020ae:	8f75                	and	a4,a4,a3
ffffffffc02020b0:	00c75693          	srli	a3,a4,0xc
ffffffffc02020b4:	14f6f263          	bgeu	a3,a5,ffffffffc02021f8 <pmm_init+0x742>
ffffffffc02020b8:	000bb803          	ld	a6,0(s7)
ffffffffc02020bc:	95b6                	add	a1,a1,a3
ffffffffc02020be:	00359793          	slli	a5,a1,0x3
ffffffffc02020c2:	97ae                	add	a5,a5,a1
ffffffffc02020c4:	01083683          	ld	a3,16(a6)
ffffffffc02020c8:	40e60733          	sub	a4,a2,a4
ffffffffc02020cc:	078e                	slli	a5,a5,0x3
ffffffffc02020ce:	00c75593          	srli	a1,a4,0xc
ffffffffc02020d2:	953e                	add	a0,a0,a5
ffffffffc02020d4:	9682                	jalr	a3
ffffffffc02020d6:	bcc5                	j	ffffffffc0201bc6 <pmm_init+0x110>
ffffffffc02020d8:	c16fe0ef          	jal	ra,ffffffffc02004ee <intr_disable>
ffffffffc02020dc:	000bb783          	ld	a5,0(s7)
ffffffffc02020e0:	779c                	ld	a5,40(a5)
ffffffffc02020e2:	9782                	jalr	a5
ffffffffc02020e4:	842a                	mv	s0,a0
ffffffffc02020e6:	c02fe0ef          	jal	ra,ffffffffc02004e8 <intr_enable>
ffffffffc02020ea:	b63d                	j	ffffffffc0201c18 <pmm_init+0x162>
ffffffffc02020ec:	c02fe0ef          	jal	ra,ffffffffc02004ee <intr_disable>
ffffffffc02020f0:	000bb783          	ld	a5,0(s7)
ffffffffc02020f4:	779c                	ld	a5,40(a5)
ffffffffc02020f6:	9782                	jalr	a5
ffffffffc02020f8:	8c2a                	mv	s8,a0
ffffffffc02020fa:	beefe0ef          	jal	ra,ffffffffc02004e8 <intr_enable>
ffffffffc02020fe:	b3c1                	j	ffffffffc0201ebe <pmm_init+0x408>
ffffffffc0202100:	beefe0ef          	jal	ra,ffffffffc02004ee <intr_disable>
ffffffffc0202104:	000bb783          	ld	a5,0(s7)
ffffffffc0202108:	779c                	ld	a5,40(a5)
ffffffffc020210a:	9782                	jalr	a5
ffffffffc020210c:	8a2a                	mv	s4,a0
ffffffffc020210e:	bdafe0ef          	jal	ra,ffffffffc02004e8 <intr_enable>
ffffffffc0202112:	b361                	j	ffffffffc0201e9a <pmm_init+0x3e4>
ffffffffc0202114:	e42a                	sd	a0,8(sp)
ffffffffc0202116:	bd8fe0ef          	jal	ra,ffffffffc02004ee <intr_disable>
ffffffffc020211a:	000bb783          	ld	a5,0(s7)
ffffffffc020211e:	6522                	ld	a0,8(sp)
ffffffffc0202120:	4585                	li	a1,1
ffffffffc0202122:	739c                	ld	a5,32(a5)
ffffffffc0202124:	9782                	jalr	a5
ffffffffc0202126:	bc2fe0ef          	jal	ra,ffffffffc02004e8 <intr_enable>
ffffffffc020212a:	bb91                	j	ffffffffc0201e7e <pmm_init+0x3c8>
ffffffffc020212c:	e42a                	sd	a0,8(sp)
ffffffffc020212e:	bc0fe0ef          	jal	ra,ffffffffc02004ee <intr_disable>
ffffffffc0202132:	000bb783          	ld	a5,0(s7)
ffffffffc0202136:	6522                	ld	a0,8(sp)
ffffffffc0202138:	4585                	li	a1,1
ffffffffc020213a:	739c                	ld	a5,32(a5)
ffffffffc020213c:	9782                	jalr	a5
ffffffffc020213e:	baafe0ef          	jal	ra,ffffffffc02004e8 <intr_enable>
ffffffffc0202142:	b319                	j	ffffffffc0201e48 <pmm_init+0x392>
ffffffffc0202144:	baafe0ef          	jal	ra,ffffffffc02004ee <intr_disable>
ffffffffc0202148:	000bb783          	ld	a5,0(s7)
ffffffffc020214c:	779c                	ld	a5,40(a5)
ffffffffc020214e:	9782                	jalr	a5
ffffffffc0202150:	842a                	mv	s0,a0
ffffffffc0202152:	b96fe0ef          	jal	ra,ffffffffc02004e8 <intr_enable>
ffffffffc0202156:	b71d                	j	ffffffffc020207c <pmm_init+0x5c6>
ffffffffc0202158:	e42a                	sd	a0,8(sp)
ffffffffc020215a:	b94fe0ef          	jal	ra,ffffffffc02004ee <intr_disable>
ffffffffc020215e:	000bb783          	ld	a5,0(s7)
ffffffffc0202162:	6522                	ld	a0,8(sp)
ffffffffc0202164:	4585                	li	a1,1
ffffffffc0202166:	739c                	ld	a5,32(a5)
ffffffffc0202168:	9782                	jalr	a5
ffffffffc020216a:	b7efe0ef          	jal	ra,ffffffffc02004e8 <intr_enable>
ffffffffc020216e:	bdcd                	j	ffffffffc0202060 <pmm_init+0x5aa>
ffffffffc0202170:	e42a                	sd	a0,8(sp)
ffffffffc0202172:	b7cfe0ef          	jal	ra,ffffffffc02004ee <intr_disable>
ffffffffc0202176:	000bb783          	ld	a5,0(s7)
ffffffffc020217a:	6522                	ld	a0,8(sp)
ffffffffc020217c:	4585                	li	a1,1
ffffffffc020217e:	739c                	ld	a5,32(a5)
ffffffffc0202180:	9782                	jalr	a5
ffffffffc0202182:	b66fe0ef          	jal	ra,ffffffffc02004e8 <intr_enable>
ffffffffc0202186:	b555                	j	ffffffffc020202a <pmm_init+0x574>
ffffffffc0202188:	b66fe0ef          	jal	ra,ffffffffc02004ee <intr_disable>
ffffffffc020218c:	000bb783          	ld	a5,0(s7)
ffffffffc0202190:	4585                	li	a1,1
ffffffffc0202192:	8556                	mv	a0,s5
ffffffffc0202194:	739c                	ld	a5,32(a5)
ffffffffc0202196:	9782                	jalr	a5
ffffffffc0202198:	b50fe0ef          	jal	ra,ffffffffc02004e8 <intr_enable>
ffffffffc020219c:	bda9                	j	ffffffffc0201ff6 <pmm_init+0x540>
ffffffffc020219e:	00003697          	auipc	a3,0x3
ffffffffc02021a2:	76268693          	addi	a3,a3,1890 # ffffffffc0205900 <default_pmm_manager+0x4c0>
ffffffffc02021a6:	00003617          	auipc	a2,0x3
ffffffffc02021aa:	eea60613          	addi	a2,a2,-278 # ffffffffc0205090 <commands+0x738>
ffffffffc02021ae:	1ce00593          	li	a1,462
ffffffffc02021b2:	00003517          	auipc	a0,0x3
ffffffffc02021b6:	34650513          	addi	a0,a0,838 # ffffffffc02054f8 <default_pmm_manager+0xb8>
ffffffffc02021ba:	9bafe0ef          	jal	ra,ffffffffc0200374 <__panic>
ffffffffc02021be:	00003697          	auipc	a3,0x3
ffffffffc02021c2:	70268693          	addi	a3,a3,1794 # ffffffffc02058c0 <default_pmm_manager+0x480>
ffffffffc02021c6:	00003617          	auipc	a2,0x3
ffffffffc02021ca:	eca60613          	addi	a2,a2,-310 # ffffffffc0205090 <commands+0x738>
ffffffffc02021ce:	1cd00593          	li	a1,461
ffffffffc02021d2:	00003517          	auipc	a0,0x3
ffffffffc02021d6:	32650513          	addi	a0,a0,806 # ffffffffc02054f8 <default_pmm_manager+0xb8>
ffffffffc02021da:	99afe0ef          	jal	ra,ffffffffc0200374 <__panic>
ffffffffc02021de:	86a2                	mv	a3,s0
ffffffffc02021e0:	00003617          	auipc	a2,0x3
ffffffffc02021e4:	2f060613          	addi	a2,a2,752 # ffffffffc02054d0 <default_pmm_manager+0x90>
ffffffffc02021e8:	1cd00593          	li	a1,461
ffffffffc02021ec:	00003517          	auipc	a0,0x3
ffffffffc02021f0:	30c50513          	addi	a0,a0,780 # ffffffffc02054f8 <default_pmm_manager+0xb8>
ffffffffc02021f4:	980fe0ef          	jal	ra,ffffffffc0200374 <__panic>
ffffffffc02021f8:	b90ff0ef          	jal	ra,ffffffffc0201588 <pa2page.part.0>
ffffffffc02021fc:	00003617          	auipc	a2,0x3
ffffffffc0202200:	39460613          	addi	a2,a2,916 # ffffffffc0205590 <default_pmm_manager+0x150>
ffffffffc0202204:	07700593          	li	a1,119
ffffffffc0202208:	00003517          	auipc	a0,0x3
ffffffffc020220c:	2f050513          	addi	a0,a0,752 # ffffffffc02054f8 <default_pmm_manager+0xb8>
ffffffffc0202210:	964fe0ef          	jal	ra,ffffffffc0200374 <__panic>
ffffffffc0202214:	00003617          	auipc	a2,0x3
ffffffffc0202218:	37c60613          	addi	a2,a2,892 # ffffffffc0205590 <default_pmm_manager+0x150>
ffffffffc020221c:	0bd00593          	li	a1,189
ffffffffc0202220:	00003517          	auipc	a0,0x3
ffffffffc0202224:	2d850513          	addi	a0,a0,728 # ffffffffc02054f8 <default_pmm_manager+0xb8>
ffffffffc0202228:	94cfe0ef          	jal	ra,ffffffffc0200374 <__panic>
ffffffffc020222c:	00003697          	auipc	a3,0x3
ffffffffc0202230:	3cc68693          	addi	a3,a3,972 # ffffffffc02055f8 <default_pmm_manager+0x1b8>
ffffffffc0202234:	00003617          	auipc	a2,0x3
ffffffffc0202238:	e5c60613          	addi	a2,a2,-420 # ffffffffc0205090 <commands+0x738>
ffffffffc020223c:	19300593          	li	a1,403
ffffffffc0202240:	00003517          	auipc	a0,0x3
ffffffffc0202244:	2b850513          	addi	a0,a0,696 # ffffffffc02054f8 <default_pmm_manager+0xb8>
ffffffffc0202248:	92cfe0ef          	jal	ra,ffffffffc0200374 <__panic>
ffffffffc020224c:	00003697          	auipc	a3,0x3
ffffffffc0202250:	38c68693          	addi	a3,a3,908 # ffffffffc02055d8 <default_pmm_manager+0x198>
ffffffffc0202254:	00003617          	auipc	a2,0x3
ffffffffc0202258:	e3c60613          	addi	a2,a2,-452 # ffffffffc0205090 <commands+0x738>
ffffffffc020225c:	19200593          	li	a1,402
ffffffffc0202260:	00003517          	auipc	a0,0x3
ffffffffc0202264:	29850513          	addi	a0,a0,664 # ffffffffc02054f8 <default_pmm_manager+0xb8>
ffffffffc0202268:	90cfe0ef          	jal	ra,ffffffffc0200374 <__panic>
ffffffffc020226c:	b38ff0ef          	jal	ra,ffffffffc02015a4 <pte2page.part.0>
ffffffffc0202270:	00003697          	auipc	a3,0x3
ffffffffc0202274:	41868693          	addi	a3,a3,1048 # ffffffffc0205688 <default_pmm_manager+0x248>
ffffffffc0202278:	00003617          	auipc	a2,0x3
ffffffffc020227c:	e1860613          	addi	a2,a2,-488 # ffffffffc0205090 <commands+0x738>
ffffffffc0202280:	19a00593          	li	a1,410
ffffffffc0202284:	00003517          	auipc	a0,0x3
ffffffffc0202288:	27450513          	addi	a0,a0,628 # ffffffffc02054f8 <default_pmm_manager+0xb8>
ffffffffc020228c:	8e8fe0ef          	jal	ra,ffffffffc0200374 <__panic>
ffffffffc0202290:	00003697          	auipc	a3,0x3
ffffffffc0202294:	3c868693          	addi	a3,a3,968 # ffffffffc0205658 <default_pmm_manager+0x218>
ffffffffc0202298:	00003617          	auipc	a2,0x3
ffffffffc020229c:	df860613          	addi	a2,a2,-520 # ffffffffc0205090 <commands+0x738>
ffffffffc02022a0:	19800593          	li	a1,408
ffffffffc02022a4:	00003517          	auipc	a0,0x3
ffffffffc02022a8:	25450513          	addi	a0,a0,596 # ffffffffc02054f8 <default_pmm_manager+0xb8>
ffffffffc02022ac:	8c8fe0ef          	jal	ra,ffffffffc0200374 <__panic>
ffffffffc02022b0:	00003697          	auipc	a3,0x3
ffffffffc02022b4:	38068693          	addi	a3,a3,896 # ffffffffc0205630 <default_pmm_manager+0x1f0>
ffffffffc02022b8:	00003617          	auipc	a2,0x3
ffffffffc02022bc:	dd860613          	addi	a2,a2,-552 # ffffffffc0205090 <commands+0x738>
ffffffffc02022c0:	19400593          	li	a1,404
ffffffffc02022c4:	00003517          	auipc	a0,0x3
ffffffffc02022c8:	23450513          	addi	a0,a0,564 # ffffffffc02054f8 <default_pmm_manager+0xb8>
ffffffffc02022cc:	8a8fe0ef          	jal	ra,ffffffffc0200374 <__panic>
ffffffffc02022d0:	00003697          	auipc	a3,0x3
ffffffffc02022d4:	44068693          	addi	a3,a3,1088 # ffffffffc0205710 <default_pmm_manager+0x2d0>
ffffffffc02022d8:	00003617          	auipc	a2,0x3
ffffffffc02022dc:	db860613          	addi	a2,a2,-584 # ffffffffc0205090 <commands+0x738>
ffffffffc02022e0:	1a300593          	li	a1,419
ffffffffc02022e4:	00003517          	auipc	a0,0x3
ffffffffc02022e8:	21450513          	addi	a0,a0,532 # ffffffffc02054f8 <default_pmm_manager+0xb8>
ffffffffc02022ec:	888fe0ef          	jal	ra,ffffffffc0200374 <__panic>
ffffffffc02022f0:	00003697          	auipc	a3,0x3
ffffffffc02022f4:	4c068693          	addi	a3,a3,1216 # ffffffffc02057b0 <default_pmm_manager+0x370>
ffffffffc02022f8:	00003617          	auipc	a2,0x3
ffffffffc02022fc:	d9860613          	addi	a2,a2,-616 # ffffffffc0205090 <commands+0x738>
ffffffffc0202300:	1a800593          	li	a1,424
ffffffffc0202304:	00003517          	auipc	a0,0x3
ffffffffc0202308:	1f450513          	addi	a0,a0,500 # ffffffffc02054f8 <default_pmm_manager+0xb8>
ffffffffc020230c:	868fe0ef          	jal	ra,ffffffffc0200374 <__panic>
ffffffffc0202310:	00003697          	auipc	a3,0x3
ffffffffc0202314:	3d868693          	addi	a3,a3,984 # ffffffffc02056e8 <default_pmm_manager+0x2a8>
ffffffffc0202318:	00003617          	auipc	a2,0x3
ffffffffc020231c:	d7860613          	addi	a2,a2,-648 # ffffffffc0205090 <commands+0x738>
ffffffffc0202320:	1a000593          	li	a1,416
ffffffffc0202324:	00003517          	auipc	a0,0x3
ffffffffc0202328:	1d450513          	addi	a0,a0,468 # ffffffffc02054f8 <default_pmm_manager+0xb8>
ffffffffc020232c:	848fe0ef          	jal	ra,ffffffffc0200374 <__panic>
ffffffffc0202330:	86d6                	mv	a3,s5
ffffffffc0202332:	00003617          	auipc	a2,0x3
ffffffffc0202336:	19e60613          	addi	a2,a2,414 # ffffffffc02054d0 <default_pmm_manager+0x90>
ffffffffc020233a:	19f00593          	li	a1,415
ffffffffc020233e:	00003517          	auipc	a0,0x3
ffffffffc0202342:	1ba50513          	addi	a0,a0,442 # ffffffffc02054f8 <default_pmm_manager+0xb8>
ffffffffc0202346:	82efe0ef          	jal	ra,ffffffffc0200374 <__panic>
ffffffffc020234a:	00003697          	auipc	a3,0x3
ffffffffc020234e:	3fe68693          	addi	a3,a3,1022 # ffffffffc0205748 <default_pmm_manager+0x308>
ffffffffc0202352:	00003617          	auipc	a2,0x3
ffffffffc0202356:	d3e60613          	addi	a2,a2,-706 # ffffffffc0205090 <commands+0x738>
ffffffffc020235a:	1ad00593          	li	a1,429
ffffffffc020235e:	00003517          	auipc	a0,0x3
ffffffffc0202362:	19a50513          	addi	a0,a0,410 # ffffffffc02054f8 <default_pmm_manager+0xb8>
ffffffffc0202366:	80efe0ef          	jal	ra,ffffffffc0200374 <__panic>
ffffffffc020236a:	00003697          	auipc	a3,0x3
ffffffffc020236e:	4a668693          	addi	a3,a3,1190 # ffffffffc0205810 <default_pmm_manager+0x3d0>
ffffffffc0202372:	00003617          	auipc	a2,0x3
ffffffffc0202376:	d1e60613          	addi	a2,a2,-738 # ffffffffc0205090 <commands+0x738>
ffffffffc020237a:	1ac00593          	li	a1,428
ffffffffc020237e:	00003517          	auipc	a0,0x3
ffffffffc0202382:	17a50513          	addi	a0,a0,378 # ffffffffc02054f8 <default_pmm_manager+0xb8>
ffffffffc0202386:	feffd0ef          	jal	ra,ffffffffc0200374 <__panic>
ffffffffc020238a:	00003697          	auipc	a3,0x3
ffffffffc020238e:	46e68693          	addi	a3,a3,1134 # ffffffffc02057f8 <default_pmm_manager+0x3b8>
ffffffffc0202392:	00003617          	auipc	a2,0x3
ffffffffc0202396:	cfe60613          	addi	a2,a2,-770 # ffffffffc0205090 <commands+0x738>
ffffffffc020239a:	1ab00593          	li	a1,427
ffffffffc020239e:	00003517          	auipc	a0,0x3
ffffffffc02023a2:	15a50513          	addi	a0,a0,346 # ffffffffc02054f8 <default_pmm_manager+0xb8>
ffffffffc02023a6:	fcffd0ef          	jal	ra,ffffffffc0200374 <__panic>
ffffffffc02023aa:	00003697          	auipc	a3,0x3
ffffffffc02023ae:	41e68693          	addi	a3,a3,1054 # ffffffffc02057c8 <default_pmm_manager+0x388>
ffffffffc02023b2:	00003617          	auipc	a2,0x3
ffffffffc02023b6:	cde60613          	addi	a2,a2,-802 # ffffffffc0205090 <commands+0x738>
ffffffffc02023ba:	1aa00593          	li	a1,426
ffffffffc02023be:	00003517          	auipc	a0,0x3
ffffffffc02023c2:	13a50513          	addi	a0,a0,314 # ffffffffc02054f8 <default_pmm_manager+0xb8>
ffffffffc02023c6:	faffd0ef          	jal	ra,ffffffffc0200374 <__panic>
ffffffffc02023ca:	00003697          	auipc	a3,0x3
ffffffffc02023ce:	5b668693          	addi	a3,a3,1462 # ffffffffc0205980 <default_pmm_manager+0x540>
ffffffffc02023d2:	00003617          	auipc	a2,0x3
ffffffffc02023d6:	cbe60613          	addi	a2,a2,-834 # ffffffffc0205090 <commands+0x738>
ffffffffc02023da:	1d800593          	li	a1,472
ffffffffc02023de:	00003517          	auipc	a0,0x3
ffffffffc02023e2:	11a50513          	addi	a0,a0,282 # ffffffffc02054f8 <default_pmm_manager+0xb8>
ffffffffc02023e6:	f8ffd0ef          	jal	ra,ffffffffc0200374 <__panic>
ffffffffc02023ea:	00003697          	auipc	a3,0x3
ffffffffc02023ee:	3ae68693          	addi	a3,a3,942 # ffffffffc0205798 <default_pmm_manager+0x358>
ffffffffc02023f2:	00003617          	auipc	a2,0x3
ffffffffc02023f6:	c9e60613          	addi	a2,a2,-866 # ffffffffc0205090 <commands+0x738>
ffffffffc02023fa:	1a700593          	li	a1,423
ffffffffc02023fe:	00003517          	auipc	a0,0x3
ffffffffc0202402:	0fa50513          	addi	a0,a0,250 # ffffffffc02054f8 <default_pmm_manager+0xb8>
ffffffffc0202406:	f6ffd0ef          	jal	ra,ffffffffc0200374 <__panic>
ffffffffc020240a:	00003697          	auipc	a3,0x3
ffffffffc020240e:	37e68693          	addi	a3,a3,894 # ffffffffc0205788 <default_pmm_manager+0x348>
ffffffffc0202412:	00003617          	auipc	a2,0x3
ffffffffc0202416:	c7e60613          	addi	a2,a2,-898 # ffffffffc0205090 <commands+0x738>
ffffffffc020241a:	1a600593          	li	a1,422
ffffffffc020241e:	00003517          	auipc	a0,0x3
ffffffffc0202422:	0da50513          	addi	a0,a0,218 # ffffffffc02054f8 <default_pmm_manager+0xb8>
ffffffffc0202426:	f4ffd0ef          	jal	ra,ffffffffc0200374 <__panic>
ffffffffc020242a:	00003697          	auipc	a3,0x3
ffffffffc020242e:	45668693          	addi	a3,a3,1110 # ffffffffc0205880 <default_pmm_manager+0x440>
ffffffffc0202432:	00003617          	auipc	a2,0x3
ffffffffc0202436:	c5e60613          	addi	a2,a2,-930 # ffffffffc0205090 <commands+0x738>
ffffffffc020243a:	1e800593          	li	a1,488
ffffffffc020243e:	00003517          	auipc	a0,0x3
ffffffffc0202442:	0ba50513          	addi	a0,a0,186 # ffffffffc02054f8 <default_pmm_manager+0xb8>
ffffffffc0202446:	f2ffd0ef          	jal	ra,ffffffffc0200374 <__panic>
ffffffffc020244a:	00003697          	auipc	a3,0x3
ffffffffc020244e:	32e68693          	addi	a3,a3,814 # ffffffffc0205778 <default_pmm_manager+0x338>
ffffffffc0202452:	00003617          	auipc	a2,0x3
ffffffffc0202456:	c3e60613          	addi	a2,a2,-962 # ffffffffc0205090 <commands+0x738>
ffffffffc020245a:	1a500593          	li	a1,421
ffffffffc020245e:	00003517          	auipc	a0,0x3
ffffffffc0202462:	09a50513          	addi	a0,a0,154 # ffffffffc02054f8 <default_pmm_manager+0xb8>
ffffffffc0202466:	f0ffd0ef          	jal	ra,ffffffffc0200374 <__panic>
ffffffffc020246a:	00003697          	auipc	a3,0x3
ffffffffc020246e:	26668693          	addi	a3,a3,614 # ffffffffc02056d0 <default_pmm_manager+0x290>
ffffffffc0202472:	00003617          	auipc	a2,0x3
ffffffffc0202476:	c1e60613          	addi	a2,a2,-994 # ffffffffc0205090 <commands+0x738>
ffffffffc020247a:	1b200593          	li	a1,434
ffffffffc020247e:	00003517          	auipc	a0,0x3
ffffffffc0202482:	07a50513          	addi	a0,a0,122 # ffffffffc02054f8 <default_pmm_manager+0xb8>
ffffffffc0202486:	eeffd0ef          	jal	ra,ffffffffc0200374 <__panic>
ffffffffc020248a:	00003697          	auipc	a3,0x3
ffffffffc020248e:	39e68693          	addi	a3,a3,926 # ffffffffc0205828 <default_pmm_manager+0x3e8>
ffffffffc0202492:	00003617          	auipc	a2,0x3
ffffffffc0202496:	bfe60613          	addi	a2,a2,-1026 # ffffffffc0205090 <commands+0x738>
ffffffffc020249a:	1af00593          	li	a1,431
ffffffffc020249e:	00003517          	auipc	a0,0x3
ffffffffc02024a2:	05a50513          	addi	a0,a0,90 # ffffffffc02054f8 <default_pmm_manager+0xb8>
ffffffffc02024a6:	ecffd0ef          	jal	ra,ffffffffc0200374 <__panic>
ffffffffc02024aa:	00003697          	auipc	a3,0x3
ffffffffc02024ae:	20e68693          	addi	a3,a3,526 # ffffffffc02056b8 <default_pmm_manager+0x278>
ffffffffc02024b2:	00003617          	auipc	a2,0x3
ffffffffc02024b6:	bde60613          	addi	a2,a2,-1058 # ffffffffc0205090 <commands+0x738>
ffffffffc02024ba:	1ae00593          	li	a1,430
ffffffffc02024be:	00003517          	auipc	a0,0x3
ffffffffc02024c2:	03a50513          	addi	a0,a0,58 # ffffffffc02054f8 <default_pmm_manager+0xb8>
ffffffffc02024c6:	eaffd0ef          	jal	ra,ffffffffc0200374 <__panic>
ffffffffc02024ca:	00003617          	auipc	a2,0x3
ffffffffc02024ce:	00660613          	addi	a2,a2,6 # ffffffffc02054d0 <default_pmm_manager+0x90>
ffffffffc02024d2:	06a00593          	li	a1,106
ffffffffc02024d6:	00003517          	auipc	a0,0x3
ffffffffc02024da:	fc250513          	addi	a0,a0,-62 # ffffffffc0205498 <default_pmm_manager+0x58>
ffffffffc02024de:	e97fd0ef          	jal	ra,ffffffffc0200374 <__panic>
ffffffffc02024e2:	00003697          	auipc	a3,0x3
ffffffffc02024e6:	37668693          	addi	a3,a3,886 # ffffffffc0205858 <default_pmm_manager+0x418>
ffffffffc02024ea:	00003617          	auipc	a2,0x3
ffffffffc02024ee:	ba660613          	addi	a2,a2,-1114 # ffffffffc0205090 <commands+0x738>
ffffffffc02024f2:	1b900593          	li	a1,441
ffffffffc02024f6:	00003517          	auipc	a0,0x3
ffffffffc02024fa:	00250513          	addi	a0,a0,2 # ffffffffc02054f8 <default_pmm_manager+0xb8>
ffffffffc02024fe:	e77fd0ef          	jal	ra,ffffffffc0200374 <__panic>
ffffffffc0202502:	00003697          	auipc	a3,0x3
ffffffffc0202506:	30e68693          	addi	a3,a3,782 # ffffffffc0205810 <default_pmm_manager+0x3d0>
ffffffffc020250a:	00003617          	auipc	a2,0x3
ffffffffc020250e:	b8660613          	addi	a2,a2,-1146 # ffffffffc0205090 <commands+0x738>
ffffffffc0202512:	1b700593          	li	a1,439
ffffffffc0202516:	00003517          	auipc	a0,0x3
ffffffffc020251a:	fe250513          	addi	a0,a0,-30 # ffffffffc02054f8 <default_pmm_manager+0xb8>
ffffffffc020251e:	e57fd0ef          	jal	ra,ffffffffc0200374 <__panic>
ffffffffc0202522:	00003697          	auipc	a3,0x3
ffffffffc0202526:	31e68693          	addi	a3,a3,798 # ffffffffc0205840 <default_pmm_manager+0x400>
ffffffffc020252a:	00003617          	auipc	a2,0x3
ffffffffc020252e:	b6660613          	addi	a2,a2,-1178 # ffffffffc0205090 <commands+0x738>
ffffffffc0202532:	1b600593          	li	a1,438
ffffffffc0202536:	00003517          	auipc	a0,0x3
ffffffffc020253a:	fc250513          	addi	a0,a0,-62 # ffffffffc02054f8 <default_pmm_manager+0xb8>
ffffffffc020253e:	e37fd0ef          	jal	ra,ffffffffc0200374 <__panic>
ffffffffc0202542:	00003697          	auipc	a3,0x3
ffffffffc0202546:	2ce68693          	addi	a3,a3,718 # ffffffffc0205810 <default_pmm_manager+0x3d0>
ffffffffc020254a:	00003617          	auipc	a2,0x3
ffffffffc020254e:	b4660613          	addi	a2,a2,-1210 # ffffffffc0205090 <commands+0x738>
ffffffffc0202552:	1b300593          	li	a1,435
ffffffffc0202556:	00003517          	auipc	a0,0x3
ffffffffc020255a:	fa250513          	addi	a0,a0,-94 # ffffffffc02054f8 <default_pmm_manager+0xb8>
ffffffffc020255e:	e17fd0ef          	jal	ra,ffffffffc0200374 <__panic>
ffffffffc0202562:	00003697          	auipc	a3,0x3
ffffffffc0202566:	40668693          	addi	a3,a3,1030 # ffffffffc0205968 <default_pmm_manager+0x528>
ffffffffc020256a:	00003617          	auipc	a2,0x3
ffffffffc020256e:	b2660613          	addi	a2,a2,-1242 # ffffffffc0205090 <commands+0x738>
ffffffffc0202572:	1d700593          	li	a1,471
ffffffffc0202576:	00003517          	auipc	a0,0x3
ffffffffc020257a:	f8250513          	addi	a0,a0,-126 # ffffffffc02054f8 <default_pmm_manager+0xb8>
ffffffffc020257e:	df7fd0ef          	jal	ra,ffffffffc0200374 <__panic>
ffffffffc0202582:	00003697          	auipc	a3,0x3
ffffffffc0202586:	3ae68693          	addi	a3,a3,942 # ffffffffc0205930 <default_pmm_manager+0x4f0>
ffffffffc020258a:	00003617          	auipc	a2,0x3
ffffffffc020258e:	b0660613          	addi	a2,a2,-1274 # ffffffffc0205090 <commands+0x738>
ffffffffc0202592:	1d600593          	li	a1,470
ffffffffc0202596:	00003517          	auipc	a0,0x3
ffffffffc020259a:	f6250513          	addi	a0,a0,-158 # ffffffffc02054f8 <default_pmm_manager+0xb8>
ffffffffc020259e:	dd7fd0ef          	jal	ra,ffffffffc0200374 <__panic>
ffffffffc02025a2:	00003697          	auipc	a3,0x3
ffffffffc02025a6:	37668693          	addi	a3,a3,886 # ffffffffc0205918 <default_pmm_manager+0x4d8>
ffffffffc02025aa:	00003617          	auipc	a2,0x3
ffffffffc02025ae:	ae660613          	addi	a2,a2,-1306 # ffffffffc0205090 <commands+0x738>
ffffffffc02025b2:	1d200593          	li	a1,466
ffffffffc02025b6:	00003517          	auipc	a0,0x3
ffffffffc02025ba:	f4250513          	addi	a0,a0,-190 # ffffffffc02054f8 <default_pmm_manager+0xb8>
ffffffffc02025be:	db7fd0ef          	jal	ra,ffffffffc0200374 <__panic>
ffffffffc02025c2:	00003697          	auipc	a3,0x3
ffffffffc02025c6:	2be68693          	addi	a3,a3,702 # ffffffffc0205880 <default_pmm_manager+0x440>
ffffffffc02025ca:	00003617          	auipc	a2,0x3
ffffffffc02025ce:	ac660613          	addi	a2,a2,-1338 # ffffffffc0205090 <commands+0x738>
ffffffffc02025d2:	1c000593          	li	a1,448
ffffffffc02025d6:	00003517          	auipc	a0,0x3
ffffffffc02025da:	f2250513          	addi	a0,a0,-222 # ffffffffc02054f8 <default_pmm_manager+0xb8>
ffffffffc02025de:	d97fd0ef          	jal	ra,ffffffffc0200374 <__panic>
ffffffffc02025e2:	00003697          	auipc	a3,0x3
ffffffffc02025e6:	0d668693          	addi	a3,a3,214 # ffffffffc02056b8 <default_pmm_manager+0x278>
ffffffffc02025ea:	00003617          	auipc	a2,0x3
ffffffffc02025ee:	aa660613          	addi	a2,a2,-1370 # ffffffffc0205090 <commands+0x738>
ffffffffc02025f2:	19b00593          	li	a1,411
ffffffffc02025f6:	00003517          	auipc	a0,0x3
ffffffffc02025fa:	f0250513          	addi	a0,a0,-254 # ffffffffc02054f8 <default_pmm_manager+0xb8>
ffffffffc02025fe:	d77fd0ef          	jal	ra,ffffffffc0200374 <__panic>
ffffffffc0202602:	00003617          	auipc	a2,0x3
ffffffffc0202606:	ece60613          	addi	a2,a2,-306 # ffffffffc02054d0 <default_pmm_manager+0x90>
ffffffffc020260a:	19e00593          	li	a1,414
ffffffffc020260e:	00003517          	auipc	a0,0x3
ffffffffc0202612:	eea50513          	addi	a0,a0,-278 # ffffffffc02054f8 <default_pmm_manager+0xb8>
ffffffffc0202616:	d5ffd0ef          	jal	ra,ffffffffc0200374 <__panic>
ffffffffc020261a:	00003697          	auipc	a3,0x3
ffffffffc020261e:	0b668693          	addi	a3,a3,182 # ffffffffc02056d0 <default_pmm_manager+0x290>
ffffffffc0202622:	00003617          	auipc	a2,0x3
ffffffffc0202626:	a6e60613          	addi	a2,a2,-1426 # ffffffffc0205090 <commands+0x738>
ffffffffc020262a:	19c00593          	li	a1,412
ffffffffc020262e:	00003517          	auipc	a0,0x3
ffffffffc0202632:	eca50513          	addi	a0,a0,-310 # ffffffffc02054f8 <default_pmm_manager+0xb8>
ffffffffc0202636:	d3ffd0ef          	jal	ra,ffffffffc0200374 <__panic>
ffffffffc020263a:	00003697          	auipc	a3,0x3
ffffffffc020263e:	10e68693          	addi	a3,a3,270 # ffffffffc0205748 <default_pmm_manager+0x308>
ffffffffc0202642:	00003617          	auipc	a2,0x3
ffffffffc0202646:	a4e60613          	addi	a2,a2,-1458 # ffffffffc0205090 <commands+0x738>
ffffffffc020264a:	1a400593          	li	a1,420
ffffffffc020264e:	00003517          	auipc	a0,0x3
ffffffffc0202652:	eaa50513          	addi	a0,a0,-342 # ffffffffc02054f8 <default_pmm_manager+0xb8>
ffffffffc0202656:	d1ffd0ef          	jal	ra,ffffffffc0200374 <__panic>
ffffffffc020265a:	00003697          	auipc	a3,0x3
ffffffffc020265e:	3ce68693          	addi	a3,a3,974 # ffffffffc0205a28 <default_pmm_manager+0x5e8>
ffffffffc0202662:	00003617          	auipc	a2,0x3
ffffffffc0202666:	a2e60613          	addi	a2,a2,-1490 # ffffffffc0205090 <commands+0x738>
ffffffffc020266a:	1e000593          	li	a1,480
ffffffffc020266e:	00003517          	auipc	a0,0x3
ffffffffc0202672:	e8a50513          	addi	a0,a0,-374 # ffffffffc02054f8 <default_pmm_manager+0xb8>
ffffffffc0202676:	cfffd0ef          	jal	ra,ffffffffc0200374 <__panic>
ffffffffc020267a:	00003697          	auipc	a3,0x3
ffffffffc020267e:	37668693          	addi	a3,a3,886 # ffffffffc02059f0 <default_pmm_manager+0x5b0>
ffffffffc0202682:	00003617          	auipc	a2,0x3
ffffffffc0202686:	a0e60613          	addi	a2,a2,-1522 # ffffffffc0205090 <commands+0x738>
ffffffffc020268a:	1dd00593          	li	a1,477
ffffffffc020268e:	00003517          	auipc	a0,0x3
ffffffffc0202692:	e6a50513          	addi	a0,a0,-406 # ffffffffc02054f8 <default_pmm_manager+0xb8>
ffffffffc0202696:	cdffd0ef          	jal	ra,ffffffffc0200374 <__panic>
ffffffffc020269a:	00003697          	auipc	a3,0x3
ffffffffc020269e:	32668693          	addi	a3,a3,806 # ffffffffc02059c0 <default_pmm_manager+0x580>
ffffffffc02026a2:	00003617          	auipc	a2,0x3
ffffffffc02026a6:	9ee60613          	addi	a2,a2,-1554 # ffffffffc0205090 <commands+0x738>
ffffffffc02026aa:	1d900593          	li	a1,473
ffffffffc02026ae:	00003517          	auipc	a0,0x3
ffffffffc02026b2:	e4a50513          	addi	a0,a0,-438 # ffffffffc02054f8 <default_pmm_manager+0xb8>
ffffffffc02026b6:	cbffd0ef          	jal	ra,ffffffffc0200374 <__panic>

ffffffffc02026ba <tlb_invalidate>:
ffffffffc02026ba:	12000073          	sfence.vma
ffffffffc02026be:	8082                	ret

ffffffffc02026c0 <pgdir_alloc_page>:
ffffffffc02026c0:	7179                	addi	sp,sp,-48
ffffffffc02026c2:	e84a                	sd	s2,16(sp)
ffffffffc02026c4:	892a                	mv	s2,a0
ffffffffc02026c6:	4505                	li	a0,1
ffffffffc02026c8:	f022                	sd	s0,32(sp)
ffffffffc02026ca:	ec26                	sd	s1,24(sp)
ffffffffc02026cc:	e44e                	sd	s3,8(sp)
ffffffffc02026ce:	f406                	sd	ra,40(sp)
ffffffffc02026d0:	84ae                	mv	s1,a1
ffffffffc02026d2:	89b2                	mv	s3,a2
ffffffffc02026d4:	eedfe0ef          	jal	ra,ffffffffc02015c0 <alloc_pages>
ffffffffc02026d8:	842a                	mv	s0,a0
ffffffffc02026da:	cd09                	beqz	a0,ffffffffc02026f4 <pgdir_alloc_page+0x34>
ffffffffc02026dc:	85aa                	mv	a1,a0
ffffffffc02026de:	86ce                	mv	a3,s3
ffffffffc02026e0:	8626                	mv	a2,s1
ffffffffc02026e2:	854a                	mv	a0,s2
ffffffffc02026e4:	ad2ff0ef          	jal	ra,ffffffffc02019b6 <page_insert>
ffffffffc02026e8:	ed21                	bnez	a0,ffffffffc0202740 <pgdir_alloc_page+0x80>
ffffffffc02026ea:	0000f797          	auipc	a5,0xf
ffffffffc02026ee:	e667a783          	lw	a5,-410(a5) # ffffffffc0211550 <swap_init_ok>
ffffffffc02026f2:	eb89                	bnez	a5,ffffffffc0202704 <pgdir_alloc_page+0x44>
ffffffffc02026f4:	70a2                	ld	ra,40(sp)
ffffffffc02026f6:	8522                	mv	a0,s0
ffffffffc02026f8:	7402                	ld	s0,32(sp)
ffffffffc02026fa:	64e2                	ld	s1,24(sp)
ffffffffc02026fc:	6942                	ld	s2,16(sp)
ffffffffc02026fe:	69a2                	ld	s3,8(sp)
ffffffffc0202700:	6145                	addi	sp,sp,48
ffffffffc0202702:	8082                	ret
ffffffffc0202704:	4681                	li	a3,0
ffffffffc0202706:	8622                	mv	a2,s0
ffffffffc0202708:	85a6                	mv	a1,s1
ffffffffc020270a:	0000f517          	auipc	a0,0xf
ffffffffc020270e:	e4e53503          	ld	a0,-434(a0) # ffffffffc0211558 <check_mm_struct>
ffffffffc0202712:	07f000ef          	jal	ra,ffffffffc0202f90 <swap_map_swappable>
ffffffffc0202716:	4018                	lw	a4,0(s0)
ffffffffc0202718:	e024                	sd	s1,64(s0)
ffffffffc020271a:	4785                	li	a5,1
ffffffffc020271c:	fcf70ce3          	beq	a4,a5,ffffffffc02026f4 <pgdir_alloc_page+0x34>
ffffffffc0202720:	00003697          	auipc	a3,0x3
ffffffffc0202724:	35068693          	addi	a3,a3,848 # ffffffffc0205a70 <default_pmm_manager+0x630>
ffffffffc0202728:	00003617          	auipc	a2,0x3
ffffffffc020272c:	96860613          	addi	a2,a2,-1688 # ffffffffc0205090 <commands+0x738>
ffffffffc0202730:	17a00593          	li	a1,378
ffffffffc0202734:	00003517          	auipc	a0,0x3
ffffffffc0202738:	dc450513          	addi	a0,a0,-572 # ffffffffc02054f8 <default_pmm_manager+0xb8>
ffffffffc020273c:	c39fd0ef          	jal	ra,ffffffffc0200374 <__panic>
ffffffffc0202740:	100027f3          	csrr	a5,sstatus
ffffffffc0202744:	8b89                	andi	a5,a5,2
ffffffffc0202746:	eb99                	bnez	a5,ffffffffc020275c <pgdir_alloc_page+0x9c>
ffffffffc0202748:	0000f797          	auipc	a5,0xf
ffffffffc020274c:	de87b783          	ld	a5,-536(a5) # ffffffffc0211530 <pmm_manager>
ffffffffc0202750:	739c                	ld	a5,32(a5)
ffffffffc0202752:	8522                	mv	a0,s0
ffffffffc0202754:	4585                	li	a1,1
ffffffffc0202756:	9782                	jalr	a5
ffffffffc0202758:	4401                	li	s0,0
ffffffffc020275a:	bf69                	j	ffffffffc02026f4 <pgdir_alloc_page+0x34>
ffffffffc020275c:	d93fd0ef          	jal	ra,ffffffffc02004ee <intr_disable>
ffffffffc0202760:	0000f797          	auipc	a5,0xf
ffffffffc0202764:	dd07b783          	ld	a5,-560(a5) # ffffffffc0211530 <pmm_manager>
ffffffffc0202768:	739c                	ld	a5,32(a5)
ffffffffc020276a:	8522                	mv	a0,s0
ffffffffc020276c:	4585                	li	a1,1
ffffffffc020276e:	9782                	jalr	a5
ffffffffc0202770:	4401                	li	s0,0
ffffffffc0202772:	d77fd0ef          	jal	ra,ffffffffc02004e8 <intr_enable>
ffffffffc0202776:	bfbd                	j	ffffffffc02026f4 <pgdir_alloc_page+0x34>

ffffffffc0202778 <kmalloc>:
ffffffffc0202778:	1141                	addi	sp,sp,-16
ffffffffc020277a:	67d5                	lui	a5,0x15
ffffffffc020277c:	e406                	sd	ra,8(sp)
ffffffffc020277e:	fff50713          	addi	a4,a0,-1
ffffffffc0202782:	17f9                	addi	a5,a5,-2
ffffffffc0202784:	04e7ea63          	bltu	a5,a4,ffffffffc02027d8 <kmalloc+0x60>
ffffffffc0202788:	6785                	lui	a5,0x1
ffffffffc020278a:	17fd                	addi	a5,a5,-1
ffffffffc020278c:	953e                	add	a0,a0,a5
ffffffffc020278e:	8131                	srli	a0,a0,0xc
ffffffffc0202790:	e31fe0ef          	jal	ra,ffffffffc02015c0 <alloc_pages>
ffffffffc0202794:	cd3d                	beqz	a0,ffffffffc0202812 <kmalloc+0x9a>
ffffffffc0202796:	0000f797          	auipc	a5,0xf
ffffffffc020279a:	d927b783          	ld	a5,-622(a5) # ffffffffc0211528 <pages>
ffffffffc020279e:	8d1d                	sub	a0,a0,a5
ffffffffc02027a0:	00004697          	auipc	a3,0x4
ffffffffc02027a4:	f306b683          	ld	a3,-208(a3) # ffffffffc02066d0 <error_string+0x38>
ffffffffc02027a8:	850d                	srai	a0,a0,0x3
ffffffffc02027aa:	02d50533          	mul	a0,a0,a3
ffffffffc02027ae:	000806b7          	lui	a3,0x80
ffffffffc02027b2:	0000f717          	auipc	a4,0xf
ffffffffc02027b6:	d6e73703          	ld	a4,-658(a4) # ffffffffc0211520 <npage>
ffffffffc02027ba:	9536                	add	a0,a0,a3
ffffffffc02027bc:	00c51793          	slli	a5,a0,0xc
ffffffffc02027c0:	83b1                	srli	a5,a5,0xc
ffffffffc02027c2:	0532                	slli	a0,a0,0xc
ffffffffc02027c4:	02e7fa63          	bgeu	a5,a4,ffffffffc02027f8 <kmalloc+0x80>
ffffffffc02027c8:	60a2                	ld	ra,8(sp)
ffffffffc02027ca:	0000f797          	auipc	a5,0xf
ffffffffc02027ce:	d6e7b783          	ld	a5,-658(a5) # ffffffffc0211538 <va_pa_offset>
ffffffffc02027d2:	953e                	add	a0,a0,a5
ffffffffc02027d4:	0141                	addi	sp,sp,16
ffffffffc02027d6:	8082                	ret
ffffffffc02027d8:	00003697          	auipc	a3,0x3
ffffffffc02027dc:	2b068693          	addi	a3,a3,688 # ffffffffc0205a88 <default_pmm_manager+0x648>
ffffffffc02027e0:	00003617          	auipc	a2,0x3
ffffffffc02027e4:	8b060613          	addi	a2,a2,-1872 # ffffffffc0205090 <commands+0x738>
ffffffffc02027e8:	1f000593          	li	a1,496
ffffffffc02027ec:	00003517          	auipc	a0,0x3
ffffffffc02027f0:	d0c50513          	addi	a0,a0,-756 # ffffffffc02054f8 <default_pmm_manager+0xb8>
ffffffffc02027f4:	b81fd0ef          	jal	ra,ffffffffc0200374 <__panic>
ffffffffc02027f8:	86aa                	mv	a3,a0
ffffffffc02027fa:	00003617          	auipc	a2,0x3
ffffffffc02027fe:	cd660613          	addi	a2,a2,-810 # ffffffffc02054d0 <default_pmm_manager+0x90>
ffffffffc0202802:	06a00593          	li	a1,106
ffffffffc0202806:	00003517          	auipc	a0,0x3
ffffffffc020280a:	c9250513          	addi	a0,a0,-878 # ffffffffc0205498 <default_pmm_manager+0x58>
ffffffffc020280e:	b67fd0ef          	jal	ra,ffffffffc0200374 <__panic>
ffffffffc0202812:	00003697          	auipc	a3,0x3
ffffffffc0202816:	29668693          	addi	a3,a3,662 # ffffffffc0205aa8 <default_pmm_manager+0x668>
ffffffffc020281a:	00003617          	auipc	a2,0x3
ffffffffc020281e:	87660613          	addi	a2,a2,-1930 # ffffffffc0205090 <commands+0x738>
ffffffffc0202822:	1f300593          	li	a1,499
ffffffffc0202826:	00003517          	auipc	a0,0x3
ffffffffc020282a:	cd250513          	addi	a0,a0,-814 # ffffffffc02054f8 <default_pmm_manager+0xb8>
ffffffffc020282e:	b47fd0ef          	jal	ra,ffffffffc0200374 <__panic>

ffffffffc0202832 <kfree>:
ffffffffc0202832:	1101                	addi	sp,sp,-32
ffffffffc0202834:	67d5                	lui	a5,0x15
ffffffffc0202836:	ec06                	sd	ra,24(sp)
ffffffffc0202838:	fff58713          	addi	a4,a1,-1
ffffffffc020283c:	17f9                	addi	a5,a5,-2
ffffffffc020283e:	0ae7ee63          	bltu	a5,a4,ffffffffc02028fa <kfree+0xc8>
ffffffffc0202842:	cd41                	beqz	a0,ffffffffc02028da <kfree+0xa8>
ffffffffc0202844:	6785                	lui	a5,0x1
ffffffffc0202846:	17fd                	addi	a5,a5,-1
ffffffffc0202848:	95be                	add	a1,a1,a5
ffffffffc020284a:	c02007b7          	lui	a5,0xc0200
ffffffffc020284e:	81b1                	srli	a1,a1,0xc
ffffffffc0202850:	06f56863          	bltu	a0,a5,ffffffffc02028c0 <kfree+0x8e>
ffffffffc0202854:	0000f697          	auipc	a3,0xf
ffffffffc0202858:	ce46b683          	ld	a3,-796(a3) # ffffffffc0211538 <va_pa_offset>
ffffffffc020285c:	8d15                	sub	a0,a0,a3
ffffffffc020285e:	8131                	srli	a0,a0,0xc
ffffffffc0202860:	0000f797          	auipc	a5,0xf
ffffffffc0202864:	cc07b783          	ld	a5,-832(a5) # ffffffffc0211520 <npage>
ffffffffc0202868:	04f57a63          	bgeu	a0,a5,ffffffffc02028bc <kfree+0x8a>
ffffffffc020286c:	fff806b7          	lui	a3,0xfff80
ffffffffc0202870:	9536                	add	a0,a0,a3
ffffffffc0202872:	00351793          	slli	a5,a0,0x3
ffffffffc0202876:	953e                	add	a0,a0,a5
ffffffffc0202878:	050e                	slli	a0,a0,0x3
ffffffffc020287a:	0000f797          	auipc	a5,0xf
ffffffffc020287e:	cae7b783          	ld	a5,-850(a5) # ffffffffc0211528 <pages>
ffffffffc0202882:	953e                	add	a0,a0,a5
ffffffffc0202884:	100027f3          	csrr	a5,sstatus
ffffffffc0202888:	8b89                	andi	a5,a5,2
ffffffffc020288a:	eb89                	bnez	a5,ffffffffc020289c <kfree+0x6a>
ffffffffc020288c:	0000f797          	auipc	a5,0xf
ffffffffc0202890:	ca47b783          	ld	a5,-860(a5) # ffffffffc0211530 <pmm_manager>
ffffffffc0202894:	60e2                	ld	ra,24(sp)
ffffffffc0202896:	739c                	ld	a5,32(a5)
ffffffffc0202898:	6105                	addi	sp,sp,32
ffffffffc020289a:	8782                	jr	a5
ffffffffc020289c:	e42a                	sd	a0,8(sp)
ffffffffc020289e:	e02e                	sd	a1,0(sp)
ffffffffc02028a0:	c4ffd0ef          	jal	ra,ffffffffc02004ee <intr_disable>
ffffffffc02028a4:	0000f797          	auipc	a5,0xf
ffffffffc02028a8:	c8c7b783          	ld	a5,-884(a5) # ffffffffc0211530 <pmm_manager>
ffffffffc02028ac:	6582                	ld	a1,0(sp)
ffffffffc02028ae:	6522                	ld	a0,8(sp)
ffffffffc02028b0:	739c                	ld	a5,32(a5)
ffffffffc02028b2:	9782                	jalr	a5
ffffffffc02028b4:	60e2                	ld	ra,24(sp)
ffffffffc02028b6:	6105                	addi	sp,sp,32
ffffffffc02028b8:	c31fd06f          	j	ffffffffc02004e8 <intr_enable>
ffffffffc02028bc:	ccdfe0ef          	jal	ra,ffffffffc0201588 <pa2page.part.0>
ffffffffc02028c0:	86aa                	mv	a3,a0
ffffffffc02028c2:	00003617          	auipc	a2,0x3
ffffffffc02028c6:	cce60613          	addi	a2,a2,-818 # ffffffffc0205590 <default_pmm_manager+0x150>
ffffffffc02028ca:	06c00593          	li	a1,108
ffffffffc02028ce:	00003517          	auipc	a0,0x3
ffffffffc02028d2:	bca50513          	addi	a0,a0,-1078 # ffffffffc0205498 <default_pmm_manager+0x58>
ffffffffc02028d6:	a9ffd0ef          	jal	ra,ffffffffc0200374 <__panic>
ffffffffc02028da:	00003697          	auipc	a3,0x3
ffffffffc02028de:	1de68693          	addi	a3,a3,478 # ffffffffc0205ab8 <default_pmm_manager+0x678>
ffffffffc02028e2:	00002617          	auipc	a2,0x2
ffffffffc02028e6:	7ae60613          	addi	a2,a2,1966 # ffffffffc0205090 <commands+0x738>
ffffffffc02028ea:	1fa00593          	li	a1,506
ffffffffc02028ee:	00003517          	auipc	a0,0x3
ffffffffc02028f2:	c0a50513          	addi	a0,a0,-1014 # ffffffffc02054f8 <default_pmm_manager+0xb8>
ffffffffc02028f6:	a7ffd0ef          	jal	ra,ffffffffc0200374 <__panic>
ffffffffc02028fa:	00003697          	auipc	a3,0x3
ffffffffc02028fe:	18e68693          	addi	a3,a3,398 # ffffffffc0205a88 <default_pmm_manager+0x648>
ffffffffc0202902:	00002617          	auipc	a2,0x2
ffffffffc0202906:	78e60613          	addi	a2,a2,1934 # ffffffffc0205090 <commands+0x738>
ffffffffc020290a:	1f900593          	li	a1,505
ffffffffc020290e:	00003517          	auipc	a0,0x3
ffffffffc0202912:	bea50513          	addi	a0,a0,-1046 # ffffffffc02054f8 <default_pmm_manager+0xb8>
ffffffffc0202916:	a5ffd0ef          	jal	ra,ffffffffc0200374 <__panic>

ffffffffc020291a <swap_init>:

static void check_swap(void);

int
swap_init(void)
{
ffffffffc020291a:	7135                	addi	sp,sp,-160
ffffffffc020291c:	ed06                	sd	ra,152(sp)
ffffffffc020291e:	e922                	sd	s0,144(sp)
ffffffffc0202920:	e526                	sd	s1,136(sp)
ffffffffc0202922:	e14a                	sd	s2,128(sp)
ffffffffc0202924:	fcce                	sd	s3,120(sp)
ffffffffc0202926:	f8d2                	sd	s4,112(sp)
ffffffffc0202928:	f4d6                	sd	s5,104(sp)
ffffffffc020292a:	f0da                	sd	s6,96(sp)
ffffffffc020292c:	ecde                	sd	s7,88(sp)
ffffffffc020292e:	e8e2                	sd	s8,80(sp)
ffffffffc0202930:	e4e6                	sd	s9,72(sp)
ffffffffc0202932:	e0ea                	sd	s10,64(sp)
ffffffffc0202934:	fc6e                	sd	s11,56(sp)
     swapfs_init();
ffffffffc0202936:	710010ef          	jal	ra,ffffffffc0204046 <swapfs_init>

     // Since the IDE is faked, it can only store 7 pages at most to pass the test
     if (!(7 <= max_swap_offset &&
ffffffffc020293a:	0000f697          	auipc	a3,0xf
ffffffffc020293e:	c066b683          	ld	a3,-1018(a3) # ffffffffc0211540 <max_swap_offset>
ffffffffc0202942:	010007b7          	lui	a5,0x1000
ffffffffc0202946:	ff968713          	addi	a4,a3,-7
ffffffffc020294a:	17e1                	addi	a5,a5,-8
ffffffffc020294c:	3ee7e063          	bltu	a5,a4,ffffffffc0202d2c <swap_init+0x412>
        max_swap_offset < MAX_SWAP_OFFSET_LIMIT)) {
        panic("bad max_swap_offset %08x.\n", max_swap_offset);
     }

     sm = &swap_manager_lru;//use first in first out Page Replacement Algorithm
ffffffffc0202950:	00007797          	auipc	a5,0x7
ffffffffc0202954:	6b078793          	addi	a5,a5,1712 # ffffffffc020a000 <swap_manager_lru>
     int r = sm->init();
ffffffffc0202958:	6798                	ld	a4,8(a5)
     sm = &swap_manager_lru;//use first in first out Page Replacement Algorithm
ffffffffc020295a:	0000fb17          	auipc	s6,0xf
ffffffffc020295e:	beeb0b13          	addi	s6,s6,-1042 # ffffffffc0211548 <sm>
ffffffffc0202962:	00fb3023          	sd	a5,0(s6)
     int r = sm->init();
ffffffffc0202966:	9702                	jalr	a4
ffffffffc0202968:	89aa                	mv	s3,a0
     
     if (r == 0)
ffffffffc020296a:	c10d                	beqz	a0,ffffffffc020298c <swap_init+0x72>
          cprintf("SWAP: manager = %s\n", sm->name);
          check_swap();
     }

     return r;
}
ffffffffc020296c:	60ea                	ld	ra,152(sp)
ffffffffc020296e:	644a                	ld	s0,144(sp)
ffffffffc0202970:	64aa                	ld	s1,136(sp)
ffffffffc0202972:	690a                	ld	s2,128(sp)
ffffffffc0202974:	7a46                	ld	s4,112(sp)
ffffffffc0202976:	7aa6                	ld	s5,104(sp)
ffffffffc0202978:	7b06                	ld	s6,96(sp)
ffffffffc020297a:	6be6                	ld	s7,88(sp)
ffffffffc020297c:	6c46                	ld	s8,80(sp)
ffffffffc020297e:	6ca6                	ld	s9,72(sp)
ffffffffc0202980:	6d06                	ld	s10,64(sp)
ffffffffc0202982:	7de2                	ld	s11,56(sp)
ffffffffc0202984:	854e                	mv	a0,s3
ffffffffc0202986:	79e6                	ld	s3,120(sp)
ffffffffc0202988:	610d                	addi	sp,sp,160
ffffffffc020298a:	8082                	ret
          cprintf("SWAP: manager = %s\n", sm->name);
ffffffffc020298c:	000b3783          	ld	a5,0(s6)
ffffffffc0202990:	00003517          	auipc	a0,0x3
ffffffffc0202994:	16850513          	addi	a0,a0,360 # ffffffffc0205af8 <default_pmm_manager+0x6b8>
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
ffffffffc0202998:	0000e497          	auipc	s1,0xe
ffffffffc020299c:	6a848493          	addi	s1,s1,1704 # ffffffffc0211040 <free_area>
ffffffffc02029a0:	638c                	ld	a1,0(a5)
          swap_init_ok = 1;
ffffffffc02029a2:	4785                	li	a5,1
ffffffffc02029a4:	0000f717          	auipc	a4,0xf
ffffffffc02029a8:	baf72623          	sw	a5,-1108(a4) # ffffffffc0211550 <swap_init_ok>
          cprintf("SWAP: manager = %s\n", sm->name);
ffffffffc02029ac:	f0efd0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc02029b0:	649c                	ld	a5,8(s1)

static void
check_swap(void)
{
    //backup mem env
     int ret, count = 0, total = 0, i;
ffffffffc02029b2:	4401                	li	s0,0
ffffffffc02029b4:	4d01                	li	s10,0
     list_entry_t *le = &free_list;
     while ((le = list_next(le)) != &free_list) {
ffffffffc02029b6:	2c978163          	beq	a5,s1,ffffffffc0202c78 <swap_init+0x35e>
 * test_bit - Determine whether a bit is set
 * @nr:     the bit to test
 * @addr:   the address to count from
 * */
static inline bool test_bit(int nr, volatile void *addr) {
    return (((*(volatile unsigned long *)addr) >> nr) & 1);
ffffffffc02029ba:	fe87b703          	ld	a4,-24(a5)
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
ffffffffc02029be:	8b09                	andi	a4,a4,2
ffffffffc02029c0:	2a070e63          	beqz	a4,ffffffffc0202c7c <swap_init+0x362>
        count ++, total += p->property;
ffffffffc02029c4:	ff87a703          	lw	a4,-8(a5)
ffffffffc02029c8:	679c                	ld	a5,8(a5)
ffffffffc02029ca:	2d05                	addiw	s10,s10,1
ffffffffc02029cc:	9c39                	addw	s0,s0,a4
     while ((le = list_next(le)) != &free_list) {
ffffffffc02029ce:	fe9796e3          	bne	a5,s1,ffffffffc02029ba <swap_init+0xa0>
     }
     assert(total == nr_free_pages());
ffffffffc02029d2:	8922                	mv	s2,s0
ffffffffc02029d4:	cbffe0ef          	jal	ra,ffffffffc0201692 <nr_free_pages>
ffffffffc02029d8:	47251663          	bne	a0,s2,ffffffffc0202e44 <swap_init+0x52a>
     cprintf("BEGIN check_swap: count %d, total %d\n",count,total);
ffffffffc02029dc:	8622                	mv	a2,s0
ffffffffc02029de:	85ea                	mv	a1,s10
ffffffffc02029e0:	00003517          	auipc	a0,0x3
ffffffffc02029e4:	13050513          	addi	a0,a0,304 # ffffffffc0205b10 <default_pmm_manager+0x6d0>
ffffffffc02029e8:	ed2fd0ef          	jal	ra,ffffffffc02000ba <cprintf>
     
     //now we set the phy pages env     
     struct mm_struct *mm = mm_create();
ffffffffc02029ec:	5e7000ef          	jal	ra,ffffffffc02037d2 <mm_create>
ffffffffc02029f0:	8aaa                	mv	s5,a0
     assert(mm != NULL);
ffffffffc02029f2:	52050963          	beqz	a0,ffffffffc0202f24 <swap_init+0x60a>

     extern struct mm_struct *check_mm_struct;
     assert(check_mm_struct == NULL);
ffffffffc02029f6:	0000f797          	auipc	a5,0xf
ffffffffc02029fa:	b6278793          	addi	a5,a5,-1182 # ffffffffc0211558 <check_mm_struct>
ffffffffc02029fe:	6398                	ld	a4,0(a5)
ffffffffc0202a00:	54071263          	bnez	a4,ffffffffc0202f44 <swap_init+0x62a>

     check_mm_struct = mm;

     pde_t *pgdir = mm->pgdir = boot_pgdir;
ffffffffc0202a04:	0000fb97          	auipc	s7,0xf
ffffffffc0202a08:	b14bbb83          	ld	s7,-1260(s7) # ffffffffc0211518 <boot_pgdir>
     assert(pgdir[0] == 0);
ffffffffc0202a0c:	000bb703          	ld	a4,0(s7)
     check_mm_struct = mm;
ffffffffc0202a10:	e388                	sd	a0,0(a5)
     pde_t *pgdir = mm->pgdir = boot_pgdir;
ffffffffc0202a12:	01753c23          	sd	s7,24(a0)
     assert(pgdir[0] == 0);
ffffffffc0202a16:	3c071763          	bnez	a4,ffffffffc0202de4 <swap_init+0x4ca>

     struct vma_struct *vma = vma_create(BEING_CHECK_VALID_VADDR, CHECK_VALID_VADDR, VM_WRITE | VM_READ);
ffffffffc0202a1a:	6599                	lui	a1,0x6
ffffffffc0202a1c:	460d                	li	a2,3
ffffffffc0202a1e:	6505                	lui	a0,0x1
ffffffffc0202a20:	5fb000ef          	jal	ra,ffffffffc020381a <vma_create>
ffffffffc0202a24:	85aa                	mv	a1,a0
     assert(vma != NULL);
ffffffffc0202a26:	3c050f63          	beqz	a0,ffffffffc0202e04 <swap_init+0x4ea>

     insert_vma_struct(mm, vma);//初始化一块大的虚拟内存
ffffffffc0202a2a:	8556                	mv	a0,s5
ffffffffc0202a2c:	65d000ef          	jal	ra,ffffffffc0203888 <insert_vma_struct>

     //setup the temp Page Table vaddr 0~4MB
     cprintf("setup Page Table for vaddr 0X1000, so alloc a page\n");
ffffffffc0202a30:	00003517          	auipc	a0,0x3
ffffffffc0202a34:	15050513          	addi	a0,a0,336 # ffffffffc0205b80 <default_pmm_manager+0x740>
ffffffffc0202a38:	e82fd0ef          	jal	ra,ffffffffc02000ba <cprintf>
     pte_t *temp_ptep=NULL;
     temp_ptep = get_pte(mm->pgdir, BEING_CHECK_VALID_VADDR, 1);
ffffffffc0202a3c:	018ab503          	ld	a0,24(s5)
ffffffffc0202a40:	4605                	li	a2,1
ffffffffc0202a42:	6585                	lui	a1,0x1
ffffffffc0202a44:	c89fe0ef          	jal	ra,ffffffffc02016cc <get_pte>
     assert(temp_ptep!= NULL);
ffffffffc0202a48:	3c050e63          	beqz	a0,ffffffffc0202e24 <swap_init+0x50a>
     cprintf("setup Page Table vaddr 0~4MB OVER!\n");
ffffffffc0202a4c:	00003517          	auipc	a0,0x3
ffffffffc0202a50:	18450513          	addi	a0,a0,388 # ffffffffc0205bd0 <default_pmm_manager+0x790>
ffffffffc0202a54:	0000e917          	auipc	s2,0xe
ffffffffc0202a58:	62490913          	addi	s2,s2,1572 # ffffffffc0211078 <check_rp>
ffffffffc0202a5c:	e5efd0ef          	jal	ra,ffffffffc02000ba <cprintf>
     
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
ffffffffc0202a60:	0000ea17          	auipc	s4,0xe
ffffffffc0202a64:	638a0a13          	addi	s4,s4,1592 # ffffffffc0211098 <swap_in_seq_no>
     cprintf("setup Page Table vaddr 0~4MB OVER!\n");
ffffffffc0202a68:	8c4a                	mv	s8,s2
          check_rp[i] = alloc_page();
ffffffffc0202a6a:	4505                	li	a0,1
ffffffffc0202a6c:	b55fe0ef          	jal	ra,ffffffffc02015c0 <alloc_pages>
ffffffffc0202a70:	00ac3023          	sd	a0,0(s8)
          assert(check_rp[i] != NULL );
ffffffffc0202a74:	28050c63          	beqz	a0,ffffffffc0202d0c <swap_init+0x3f2>
ffffffffc0202a78:	651c                	ld	a5,8(a0)
          assert(!PageProperty(check_rp[i]));
ffffffffc0202a7a:	8b89                	andi	a5,a5,2
ffffffffc0202a7c:	26079863          	bnez	a5,ffffffffc0202cec <swap_init+0x3d2>
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
ffffffffc0202a80:	0c21                	addi	s8,s8,8
ffffffffc0202a82:	ff4c14e3          	bne	s8,s4,ffffffffc0202a6a <swap_init+0x150>
     }
     list_entry_t free_list_store = free_list;
ffffffffc0202a86:	609c                	ld	a5,0(s1)
ffffffffc0202a88:	0084bd83          	ld	s11,8(s1)
    elm->prev = elm->next = elm;
ffffffffc0202a8c:	e084                	sd	s1,0(s1)
ffffffffc0202a8e:	f03e                	sd	a5,32(sp)
     list_init(&free_list);
     assert(list_empty(&free_list));
     
     //assert(alloc_page() == NULL);
     
     unsigned int nr_free_store = nr_free;
ffffffffc0202a90:	489c                	lw	a5,16(s1)
ffffffffc0202a92:	e484                	sd	s1,8(s1)
     nr_free = 0;
ffffffffc0202a94:	0000ec17          	auipc	s8,0xe
ffffffffc0202a98:	5e4c0c13          	addi	s8,s8,1508 # ffffffffc0211078 <check_rp>
     unsigned int nr_free_store = nr_free;
ffffffffc0202a9c:	f43e                	sd	a5,40(sp)
     nr_free = 0;
ffffffffc0202a9e:	0000e797          	auipc	a5,0xe
ffffffffc0202aa2:	5a07a923          	sw	zero,1458(a5) # ffffffffc0211050 <free_area+0x10>
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
        free_pages(check_rp[i],1);
ffffffffc0202aa6:	000c3503          	ld	a0,0(s8)
ffffffffc0202aaa:	4585                	li	a1,1
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
ffffffffc0202aac:	0c21                	addi	s8,s8,8
        free_pages(check_rp[i],1);
ffffffffc0202aae:	ba5fe0ef          	jal	ra,ffffffffc0201652 <free_pages>
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
ffffffffc0202ab2:	ff4c1ae3          	bne	s8,s4,ffffffffc0202aa6 <swap_init+0x18c>
     }
     assert(nr_free==CHECK_VALID_PHY_PAGE_NUM);
ffffffffc0202ab6:	0104ac03          	lw	s8,16(s1)
ffffffffc0202aba:	4791                	li	a5,4
ffffffffc0202abc:	4afc1463          	bne	s8,a5,ffffffffc0202f64 <swap_init+0x64a>
     
     cprintf("set up init env for check_swap begin!\n");
ffffffffc0202ac0:	00003517          	auipc	a0,0x3
ffffffffc0202ac4:	19850513          	addi	a0,a0,408 # ffffffffc0205c58 <default_pmm_manager+0x818>
ffffffffc0202ac8:	df2fd0ef          	jal	ra,ffffffffc02000ba <cprintf>
     *(unsigned char *)0x1000 = 0x0a;
ffffffffc0202acc:	6605                	lui	a2,0x1
     //setup initial vir_page<->phy_page environment for page relpacement algorithm 

     
     pgfault_num=0;
ffffffffc0202ace:	0000f797          	auipc	a5,0xf
ffffffffc0202ad2:	a807a923          	sw	zero,-1390(a5) # ffffffffc0211560 <pgfault_num>
     *(unsigned char *)0x1000 = 0x0a;
ffffffffc0202ad6:	4529                	li	a0,10
ffffffffc0202ad8:	00a60023          	sb	a0,0(a2) # 1000 <kern_entry-0xffffffffc01ff000>
     assert(pgfault_num==1);
ffffffffc0202adc:	0000f597          	auipc	a1,0xf
ffffffffc0202ae0:	a845a583          	lw	a1,-1404(a1) # ffffffffc0211560 <pgfault_num>
ffffffffc0202ae4:	4805                	li	a6,1
ffffffffc0202ae6:	0000f797          	auipc	a5,0xf
ffffffffc0202aea:	a7a78793          	addi	a5,a5,-1414 # ffffffffc0211560 <pgfault_num>
ffffffffc0202aee:	3f059b63          	bne	a1,a6,ffffffffc0202ee4 <swap_init+0x5ca>
     *(unsigned char *)0x1010 = 0x0a;
ffffffffc0202af2:	00a60823          	sb	a0,16(a2)
     assert(pgfault_num==1);
ffffffffc0202af6:	4390                	lw	a2,0(a5)
ffffffffc0202af8:	2601                	sext.w	a2,a2
ffffffffc0202afa:	40b61563          	bne	a2,a1,ffffffffc0202f04 <swap_init+0x5ea>
     *(unsigned char *)0x2000 = 0x0b;
ffffffffc0202afe:	6589                	lui	a1,0x2
ffffffffc0202b00:	452d                	li	a0,11
ffffffffc0202b02:	00a58023          	sb	a0,0(a1) # 2000 <kern_entry-0xffffffffc01fe000>
     assert(pgfault_num==2);
ffffffffc0202b06:	4390                	lw	a2,0(a5)
ffffffffc0202b08:	4809                	li	a6,2
ffffffffc0202b0a:	2601                	sext.w	a2,a2
ffffffffc0202b0c:	35061c63          	bne	a2,a6,ffffffffc0202e64 <swap_init+0x54a>
     *(unsigned char *)0x2010 = 0x0b;
ffffffffc0202b10:	00a58823          	sb	a0,16(a1)
     assert(pgfault_num==2);
ffffffffc0202b14:	438c                	lw	a1,0(a5)
ffffffffc0202b16:	2581                	sext.w	a1,a1
ffffffffc0202b18:	36c59663          	bne	a1,a2,ffffffffc0202e84 <swap_init+0x56a>
     *(unsigned char *)0x3000 = 0x0c;
ffffffffc0202b1c:	658d                	lui	a1,0x3
ffffffffc0202b1e:	4531                	li	a0,12
ffffffffc0202b20:	00a58023          	sb	a0,0(a1) # 3000 <kern_entry-0xffffffffc01fd000>
     assert(pgfault_num==3);
ffffffffc0202b24:	4390                	lw	a2,0(a5)
ffffffffc0202b26:	480d                	li	a6,3
ffffffffc0202b28:	2601                	sext.w	a2,a2
ffffffffc0202b2a:	37061d63          	bne	a2,a6,ffffffffc0202ea4 <swap_init+0x58a>
     *(unsigned char *)0x3010 = 0x0c;
ffffffffc0202b2e:	00a58823          	sb	a0,16(a1)
     assert(pgfault_num==3);
ffffffffc0202b32:	438c                	lw	a1,0(a5)
ffffffffc0202b34:	2581                	sext.w	a1,a1
ffffffffc0202b36:	38c59763          	bne	a1,a2,ffffffffc0202ec4 <swap_init+0x5aa>
     *(unsigned char *)0x4000 = 0x0d;
ffffffffc0202b3a:	6591                	lui	a1,0x4
ffffffffc0202b3c:	4535                	li	a0,13
ffffffffc0202b3e:	00a58023          	sb	a0,0(a1) # 4000 <kern_entry-0xffffffffc01fc000>
     assert(pgfault_num==4);
ffffffffc0202b42:	4390                	lw	a2,0(a5)
ffffffffc0202b44:	2601                	sext.w	a2,a2
ffffffffc0202b46:	21861f63          	bne	a2,s8,ffffffffc0202d64 <swap_init+0x44a>
     *(unsigned char *)0x4010 = 0x0d;
ffffffffc0202b4a:	00a58823          	sb	a0,16(a1)
     assert(pgfault_num==4);
ffffffffc0202b4e:	439c                	lw	a5,0(a5)
ffffffffc0202b50:	2781                	sext.w	a5,a5
ffffffffc0202b52:	22c79963          	bne	a5,a2,ffffffffc0202d84 <swap_init+0x46a>
     
     check_content_set();
     assert( nr_free == 0);         
ffffffffc0202b56:	489c                	lw	a5,16(s1)
ffffffffc0202b58:	24079663          	bnez	a5,ffffffffc0202da4 <swap_init+0x48a>
ffffffffc0202b5c:	0000e797          	auipc	a5,0xe
ffffffffc0202b60:	53c78793          	addi	a5,a5,1340 # ffffffffc0211098 <swap_in_seq_no>
ffffffffc0202b64:	0000e617          	auipc	a2,0xe
ffffffffc0202b68:	55c60613          	addi	a2,a2,1372 # ffffffffc02110c0 <swap_out_seq_no>
ffffffffc0202b6c:	0000e517          	auipc	a0,0xe
ffffffffc0202b70:	55450513          	addi	a0,a0,1364 # ffffffffc02110c0 <swap_out_seq_no>
     for(i = 0; i<MAX_SEQ_NO ; i++) 
         swap_out_seq_no[i]=swap_in_seq_no[i]=-1;
ffffffffc0202b74:	55fd                	li	a1,-1
ffffffffc0202b76:	c38c                	sw	a1,0(a5)
ffffffffc0202b78:	c20c                	sw	a1,0(a2)
     for(i = 0; i<MAX_SEQ_NO ; i++) 
ffffffffc0202b7a:	0791                	addi	a5,a5,4
ffffffffc0202b7c:	0611                	addi	a2,a2,4
ffffffffc0202b7e:	fef51ce3          	bne	a0,a5,ffffffffc0202b76 <swap_init+0x25c>
ffffffffc0202b82:	0000e817          	auipc	a6,0xe
ffffffffc0202b86:	4d680813          	addi	a6,a6,1238 # ffffffffc0211058 <check_ptep>
ffffffffc0202b8a:	0000e897          	auipc	a7,0xe
ffffffffc0202b8e:	4ee88893          	addi	a7,a7,1262 # ffffffffc0211078 <check_rp>
ffffffffc0202b92:	6585                	lui	a1,0x1

static inline struct Page *pa2page(uintptr_t pa) {
    if (PPN(pa) >= npage) {
        panic("pa2page called with invalid pa");
    }
    return &pages[PPN(pa) - nbase];
ffffffffc0202b94:	0000fc97          	auipc	s9,0xf
ffffffffc0202b98:	994c8c93          	addi	s9,s9,-1644 # ffffffffc0211528 <pages>
ffffffffc0202b9c:	00004c17          	auipc	s8,0x4
ffffffffc0202ba0:	b3cc0c13          	addi	s8,s8,-1220 # ffffffffc02066d8 <nbase>
     
     for (i= 0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
         check_ptep[i]=0;
ffffffffc0202ba4:	00083023          	sd	zero,0(a6)
         check_ptep[i] = get_pte(pgdir, (i+1)*0x1000, 0);
ffffffffc0202ba8:	4601                	li	a2,0
ffffffffc0202baa:	855e                	mv	a0,s7
ffffffffc0202bac:	ec46                	sd	a7,24(sp)
ffffffffc0202bae:	e82e                	sd	a1,16(sp)
         check_ptep[i]=0;
ffffffffc0202bb0:	e442                	sd	a6,8(sp)
         check_ptep[i] = get_pte(pgdir, (i+1)*0x1000, 0);
ffffffffc0202bb2:	b1bfe0ef          	jal	ra,ffffffffc02016cc <get_pte>
ffffffffc0202bb6:	6822                	ld	a6,8(sp)
         //cprintf("i %d, check_ptep addr %x, value %x\n", i, check_ptep[i], *check_ptep[i]);
         //cprintf("%d\n",i);
         assert(check_ptep[i] != NULL);
ffffffffc0202bb8:	65c2                	ld	a1,16(sp)
ffffffffc0202bba:	68e2                	ld	a7,24(sp)
         check_ptep[i] = get_pte(pgdir, (i+1)*0x1000, 0);
ffffffffc0202bbc:	00a83023          	sd	a0,0(a6)
         assert(check_ptep[i] != NULL);
ffffffffc0202bc0:	0000f317          	auipc	t1,0xf
ffffffffc0202bc4:	96030313          	addi	t1,t1,-1696 # ffffffffc0211520 <npage>
ffffffffc0202bc8:	16050e63          	beqz	a0,ffffffffc0202d44 <swap_init+0x42a>
         assert(pte2page(*check_ptep[i]) == check_rp[i]);
ffffffffc0202bcc:	611c                	ld	a5,0(a0)
static inline void *page2kva(struct Page *page) { return KADDR(page2pa(page)); }

static inline struct Page *kva2page(void *kva) { return pa2page(PADDR(kva)); }

static inline struct Page *pte2page(pte_t pte) {
    if (!(pte & PTE_V)) {
ffffffffc0202bce:	0017f613          	andi	a2,a5,1
ffffffffc0202bd2:	0e060563          	beqz	a2,ffffffffc0202cbc <swap_init+0x3a2>
    if (PPN(pa) >= npage) {
ffffffffc0202bd6:	00033603          	ld	a2,0(t1)
        panic("pte2page called with invalid pte");
    }
    return pa2page(PTE_ADDR(pte));
ffffffffc0202bda:	078a                	slli	a5,a5,0x2
ffffffffc0202bdc:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage) {
ffffffffc0202bde:	0ec7fb63          	bgeu	a5,a2,ffffffffc0202cd4 <swap_init+0x3ba>
    return &pages[PPN(pa) - nbase];
ffffffffc0202be2:	000c3603          	ld	a2,0(s8)
ffffffffc0202be6:	000cb503          	ld	a0,0(s9)
ffffffffc0202bea:	0008bf03          	ld	t5,0(a7)
ffffffffc0202bee:	8f91                	sub	a5,a5,a2
ffffffffc0202bf0:	00379613          	slli	a2,a5,0x3
ffffffffc0202bf4:	97b2                	add	a5,a5,a2
ffffffffc0202bf6:	078e                	slli	a5,a5,0x3
ffffffffc0202bf8:	97aa                	add	a5,a5,a0
ffffffffc0202bfa:	0aff1163          	bne	t5,a5,ffffffffc0202c9c <swap_init+0x382>
     for (i= 0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
ffffffffc0202bfe:	6785                	lui	a5,0x1
ffffffffc0202c00:	95be                	add	a1,a1,a5
ffffffffc0202c02:	6795                	lui	a5,0x5
ffffffffc0202c04:	0821                	addi	a6,a6,8
ffffffffc0202c06:	08a1                	addi	a7,a7,8
ffffffffc0202c08:	f8f59ee3          	bne	a1,a5,ffffffffc0202ba4 <swap_init+0x28a>
         assert((*check_ptep[i] & PTE_V));          
     }
     cprintf("set up init env for check_swap over!\n");
ffffffffc0202c0c:	00003517          	auipc	a0,0x3
ffffffffc0202c10:	0f450513          	addi	a0,a0,244 # ffffffffc0205d00 <default_pmm_manager+0x8c0>
ffffffffc0202c14:	ca6fd0ef          	jal	ra,ffffffffc02000ba <cprintf>
    int ret = sm->check_swap();
ffffffffc0202c18:	000b3783          	ld	a5,0(s6)
ffffffffc0202c1c:	7f9c                	ld	a5,56(a5)
ffffffffc0202c1e:	9782                	jalr	a5
     // now access the virt pages to test  page relpacement algorithm 
     ret=check_content_access();
     //cprintf("here2\n");
     assert(ret==0);
ffffffffc0202c20:	1a051263          	bnez	a0,ffffffffc0202dc4 <swap_init+0x4aa>
     
     //restore kernel mem env
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
         //cprintf("here1\n");
         free_pages(check_rp[i],1);
ffffffffc0202c24:	00093503          	ld	a0,0(s2)
ffffffffc0202c28:	4585                	li	a1,1
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
ffffffffc0202c2a:	0921                	addi	s2,s2,8
         free_pages(check_rp[i],1);
ffffffffc0202c2c:	a27fe0ef          	jal	ra,ffffffffc0201652 <free_pages>
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
ffffffffc0202c30:	ff491ae3          	bne	s2,s4,ffffffffc0202c24 <swap_init+0x30a>
     } 

     //free_page(pte2page(*temp_ptep));
     //cprintf("here\n");
     mm_destroy(mm);
ffffffffc0202c34:	8556                	mv	a0,s5
ffffffffc0202c36:	523000ef          	jal	ra,ffffffffc0203958 <mm_destroy>
         
     nr_free = nr_free_store;
ffffffffc0202c3a:	77a2                	ld	a5,40(sp)
     free_list = free_list_store;
ffffffffc0202c3c:	01b4b423          	sd	s11,8(s1)
     nr_free = nr_free_store;
ffffffffc0202c40:	c89c                	sw	a5,16(s1)
     free_list = free_list_store;
ffffffffc0202c42:	7782                	ld	a5,32(sp)
ffffffffc0202c44:	e09c                	sd	a5,0(s1)

     
     le = &free_list;
     while ((le = list_next(le)) != &free_list) {
ffffffffc0202c46:	009d8a63          	beq	s11,s1,ffffffffc0202c5a <swap_init+0x340>
         struct Page *p = le2page(le, page_link);
         count --, total -= p->property;
ffffffffc0202c4a:	ff8da783          	lw	a5,-8(s11)
    return listelm->next;
ffffffffc0202c4e:	008dbd83          	ld	s11,8(s11)
ffffffffc0202c52:	3d7d                	addiw	s10,s10,-1
ffffffffc0202c54:	9c1d                	subw	s0,s0,a5
     while ((le = list_next(le)) != &free_list) {
ffffffffc0202c56:	fe9d9ae3          	bne	s11,s1,ffffffffc0202c4a <swap_init+0x330>
     }
     cprintf("count is %d, total is %d\n",count,total);
ffffffffc0202c5a:	8622                	mv	a2,s0
ffffffffc0202c5c:	85ea                	mv	a1,s10
ffffffffc0202c5e:	00003517          	auipc	a0,0x3
ffffffffc0202c62:	0d250513          	addi	a0,a0,210 # ffffffffc0205d30 <default_pmm_manager+0x8f0>
ffffffffc0202c66:	c54fd0ef          	jal	ra,ffffffffc02000ba <cprintf>
     //assert(count == 0);
     
     cprintf("check_swap() succeeded!\n");
ffffffffc0202c6a:	00003517          	auipc	a0,0x3
ffffffffc0202c6e:	0e650513          	addi	a0,a0,230 # ffffffffc0205d50 <default_pmm_manager+0x910>
ffffffffc0202c72:	c48fd0ef          	jal	ra,ffffffffc02000ba <cprintf>
}
ffffffffc0202c76:	b9dd                	j	ffffffffc020296c <swap_init+0x52>
     while ((le = list_next(le)) != &free_list) {
ffffffffc0202c78:	4901                	li	s2,0
ffffffffc0202c7a:	bba9                	j	ffffffffc02029d4 <swap_init+0xba>
        assert(PageProperty(p));
ffffffffc0202c7c:	00002697          	auipc	a3,0x2
ffffffffc0202c80:	40468693          	addi	a3,a3,1028 # ffffffffc0205080 <commands+0x728>
ffffffffc0202c84:	00002617          	auipc	a2,0x2
ffffffffc0202c88:	40c60613          	addi	a2,a2,1036 # ffffffffc0205090 <commands+0x738>
ffffffffc0202c8c:	0bb00593          	li	a1,187
ffffffffc0202c90:	00003517          	auipc	a0,0x3
ffffffffc0202c94:	e5850513          	addi	a0,a0,-424 # ffffffffc0205ae8 <default_pmm_manager+0x6a8>
ffffffffc0202c98:	edcfd0ef          	jal	ra,ffffffffc0200374 <__panic>
         assert(pte2page(*check_ptep[i]) == check_rp[i]);
ffffffffc0202c9c:	00003697          	auipc	a3,0x3
ffffffffc0202ca0:	03c68693          	addi	a3,a3,60 # ffffffffc0205cd8 <default_pmm_manager+0x898>
ffffffffc0202ca4:	00002617          	auipc	a2,0x2
ffffffffc0202ca8:	3ec60613          	addi	a2,a2,1004 # ffffffffc0205090 <commands+0x738>
ffffffffc0202cac:	0fc00593          	li	a1,252
ffffffffc0202cb0:	00003517          	auipc	a0,0x3
ffffffffc0202cb4:	e3850513          	addi	a0,a0,-456 # ffffffffc0205ae8 <default_pmm_manager+0x6a8>
ffffffffc0202cb8:	ebcfd0ef          	jal	ra,ffffffffc0200374 <__panic>
        panic("pte2page called with invalid pte");
ffffffffc0202cbc:	00002617          	auipc	a2,0x2
ffffffffc0202cc0:	7ec60613          	addi	a2,a2,2028 # ffffffffc02054a8 <default_pmm_manager+0x68>
ffffffffc0202cc4:	07000593          	li	a1,112
ffffffffc0202cc8:	00002517          	auipc	a0,0x2
ffffffffc0202ccc:	7d050513          	addi	a0,a0,2000 # ffffffffc0205498 <default_pmm_manager+0x58>
ffffffffc0202cd0:	ea4fd0ef          	jal	ra,ffffffffc0200374 <__panic>
        panic("pa2page called with invalid pa");
ffffffffc0202cd4:	00002617          	auipc	a2,0x2
ffffffffc0202cd8:	7a460613          	addi	a2,a2,1956 # ffffffffc0205478 <default_pmm_manager+0x38>
ffffffffc0202cdc:	06500593          	li	a1,101
ffffffffc0202ce0:	00002517          	auipc	a0,0x2
ffffffffc0202ce4:	7b850513          	addi	a0,a0,1976 # ffffffffc0205498 <default_pmm_manager+0x58>
ffffffffc0202ce8:	e8cfd0ef          	jal	ra,ffffffffc0200374 <__panic>
          assert(!PageProperty(check_rp[i]));
ffffffffc0202cec:	00003697          	auipc	a3,0x3
ffffffffc0202cf0:	f2468693          	addi	a3,a3,-220 # ffffffffc0205c10 <default_pmm_manager+0x7d0>
ffffffffc0202cf4:	00002617          	auipc	a2,0x2
ffffffffc0202cf8:	39c60613          	addi	a2,a2,924 # ffffffffc0205090 <commands+0x738>
ffffffffc0202cfc:	0dc00593          	li	a1,220
ffffffffc0202d00:	00003517          	auipc	a0,0x3
ffffffffc0202d04:	de850513          	addi	a0,a0,-536 # ffffffffc0205ae8 <default_pmm_manager+0x6a8>
ffffffffc0202d08:	e6cfd0ef          	jal	ra,ffffffffc0200374 <__panic>
          assert(check_rp[i] != NULL );
ffffffffc0202d0c:	00003697          	auipc	a3,0x3
ffffffffc0202d10:	eec68693          	addi	a3,a3,-276 # ffffffffc0205bf8 <default_pmm_manager+0x7b8>
ffffffffc0202d14:	00002617          	auipc	a2,0x2
ffffffffc0202d18:	37c60613          	addi	a2,a2,892 # ffffffffc0205090 <commands+0x738>
ffffffffc0202d1c:	0db00593          	li	a1,219
ffffffffc0202d20:	00003517          	auipc	a0,0x3
ffffffffc0202d24:	dc850513          	addi	a0,a0,-568 # ffffffffc0205ae8 <default_pmm_manager+0x6a8>
ffffffffc0202d28:	e4cfd0ef          	jal	ra,ffffffffc0200374 <__panic>
        panic("bad max_swap_offset %08x.\n", max_swap_offset);
ffffffffc0202d2c:	00003617          	auipc	a2,0x3
ffffffffc0202d30:	d9c60613          	addi	a2,a2,-612 # ffffffffc0205ac8 <default_pmm_manager+0x688>
ffffffffc0202d34:	02800593          	li	a1,40
ffffffffc0202d38:	00003517          	auipc	a0,0x3
ffffffffc0202d3c:	db050513          	addi	a0,a0,-592 # ffffffffc0205ae8 <default_pmm_manager+0x6a8>
ffffffffc0202d40:	e34fd0ef          	jal	ra,ffffffffc0200374 <__panic>
         assert(check_ptep[i] != NULL);
ffffffffc0202d44:	00003697          	auipc	a3,0x3
ffffffffc0202d48:	f7c68693          	addi	a3,a3,-132 # ffffffffc0205cc0 <default_pmm_manager+0x880>
ffffffffc0202d4c:	00002617          	auipc	a2,0x2
ffffffffc0202d50:	34460613          	addi	a2,a2,836 # ffffffffc0205090 <commands+0x738>
ffffffffc0202d54:	0fb00593          	li	a1,251
ffffffffc0202d58:	00003517          	auipc	a0,0x3
ffffffffc0202d5c:	d9050513          	addi	a0,a0,-624 # ffffffffc0205ae8 <default_pmm_manager+0x6a8>
ffffffffc0202d60:	e14fd0ef          	jal	ra,ffffffffc0200374 <__panic>
     assert(pgfault_num==4);
ffffffffc0202d64:	00003697          	auipc	a3,0x3
ffffffffc0202d68:	f4c68693          	addi	a3,a3,-180 # ffffffffc0205cb0 <default_pmm_manager+0x870>
ffffffffc0202d6c:	00002617          	auipc	a2,0x2
ffffffffc0202d70:	32460613          	addi	a2,a2,804 # ffffffffc0205090 <commands+0x738>
ffffffffc0202d74:	09e00593          	li	a1,158
ffffffffc0202d78:	00003517          	auipc	a0,0x3
ffffffffc0202d7c:	d7050513          	addi	a0,a0,-656 # ffffffffc0205ae8 <default_pmm_manager+0x6a8>
ffffffffc0202d80:	df4fd0ef          	jal	ra,ffffffffc0200374 <__panic>
     assert(pgfault_num==4);
ffffffffc0202d84:	00003697          	auipc	a3,0x3
ffffffffc0202d88:	f2c68693          	addi	a3,a3,-212 # ffffffffc0205cb0 <default_pmm_manager+0x870>
ffffffffc0202d8c:	00002617          	auipc	a2,0x2
ffffffffc0202d90:	30460613          	addi	a2,a2,772 # ffffffffc0205090 <commands+0x738>
ffffffffc0202d94:	0a000593          	li	a1,160
ffffffffc0202d98:	00003517          	auipc	a0,0x3
ffffffffc0202d9c:	d5050513          	addi	a0,a0,-688 # ffffffffc0205ae8 <default_pmm_manager+0x6a8>
ffffffffc0202da0:	dd4fd0ef          	jal	ra,ffffffffc0200374 <__panic>
     assert( nr_free == 0);         
ffffffffc0202da4:	00002697          	auipc	a3,0x2
ffffffffc0202da8:	4c468693          	addi	a3,a3,1220 # ffffffffc0205268 <commands+0x910>
ffffffffc0202dac:	00002617          	auipc	a2,0x2
ffffffffc0202db0:	2e460613          	addi	a2,a2,740 # ffffffffc0205090 <commands+0x738>
ffffffffc0202db4:	0f200593          	li	a1,242
ffffffffc0202db8:	00003517          	auipc	a0,0x3
ffffffffc0202dbc:	d3050513          	addi	a0,a0,-720 # ffffffffc0205ae8 <default_pmm_manager+0x6a8>
ffffffffc0202dc0:	db4fd0ef          	jal	ra,ffffffffc0200374 <__panic>
     assert(ret==0);
ffffffffc0202dc4:	00003697          	auipc	a3,0x3
ffffffffc0202dc8:	f6468693          	addi	a3,a3,-156 # ffffffffc0205d28 <default_pmm_manager+0x8e8>
ffffffffc0202dcc:	00002617          	auipc	a2,0x2
ffffffffc0202dd0:	2c460613          	addi	a2,a2,708 # ffffffffc0205090 <commands+0x738>
ffffffffc0202dd4:	10300593          	li	a1,259
ffffffffc0202dd8:	00003517          	auipc	a0,0x3
ffffffffc0202ddc:	d1050513          	addi	a0,a0,-752 # ffffffffc0205ae8 <default_pmm_manager+0x6a8>
ffffffffc0202de0:	d94fd0ef          	jal	ra,ffffffffc0200374 <__panic>
     assert(pgdir[0] == 0);
ffffffffc0202de4:	00003697          	auipc	a3,0x3
ffffffffc0202de8:	d7c68693          	addi	a3,a3,-644 # ffffffffc0205b60 <default_pmm_manager+0x720>
ffffffffc0202dec:	00002617          	auipc	a2,0x2
ffffffffc0202df0:	2a460613          	addi	a2,a2,676 # ffffffffc0205090 <commands+0x738>
ffffffffc0202df4:	0cb00593          	li	a1,203
ffffffffc0202df8:	00003517          	auipc	a0,0x3
ffffffffc0202dfc:	cf050513          	addi	a0,a0,-784 # ffffffffc0205ae8 <default_pmm_manager+0x6a8>
ffffffffc0202e00:	d74fd0ef          	jal	ra,ffffffffc0200374 <__panic>
     assert(vma != NULL);
ffffffffc0202e04:	00003697          	auipc	a3,0x3
ffffffffc0202e08:	d6c68693          	addi	a3,a3,-660 # ffffffffc0205b70 <default_pmm_manager+0x730>
ffffffffc0202e0c:	00002617          	auipc	a2,0x2
ffffffffc0202e10:	28460613          	addi	a2,a2,644 # ffffffffc0205090 <commands+0x738>
ffffffffc0202e14:	0ce00593          	li	a1,206
ffffffffc0202e18:	00003517          	auipc	a0,0x3
ffffffffc0202e1c:	cd050513          	addi	a0,a0,-816 # ffffffffc0205ae8 <default_pmm_manager+0x6a8>
ffffffffc0202e20:	d54fd0ef          	jal	ra,ffffffffc0200374 <__panic>
     assert(temp_ptep!= NULL);
ffffffffc0202e24:	00003697          	auipc	a3,0x3
ffffffffc0202e28:	d9468693          	addi	a3,a3,-620 # ffffffffc0205bb8 <default_pmm_manager+0x778>
ffffffffc0202e2c:	00002617          	auipc	a2,0x2
ffffffffc0202e30:	26460613          	addi	a2,a2,612 # ffffffffc0205090 <commands+0x738>
ffffffffc0202e34:	0d600593          	li	a1,214
ffffffffc0202e38:	00003517          	auipc	a0,0x3
ffffffffc0202e3c:	cb050513          	addi	a0,a0,-848 # ffffffffc0205ae8 <default_pmm_manager+0x6a8>
ffffffffc0202e40:	d34fd0ef          	jal	ra,ffffffffc0200374 <__panic>
     assert(total == nr_free_pages());
ffffffffc0202e44:	00002697          	auipc	a3,0x2
ffffffffc0202e48:	27c68693          	addi	a3,a3,636 # ffffffffc02050c0 <commands+0x768>
ffffffffc0202e4c:	00002617          	auipc	a2,0x2
ffffffffc0202e50:	24460613          	addi	a2,a2,580 # ffffffffc0205090 <commands+0x738>
ffffffffc0202e54:	0be00593          	li	a1,190
ffffffffc0202e58:	00003517          	auipc	a0,0x3
ffffffffc0202e5c:	c9050513          	addi	a0,a0,-880 # ffffffffc0205ae8 <default_pmm_manager+0x6a8>
ffffffffc0202e60:	d14fd0ef          	jal	ra,ffffffffc0200374 <__panic>
     assert(pgfault_num==2);
ffffffffc0202e64:	00003697          	auipc	a3,0x3
ffffffffc0202e68:	e2c68693          	addi	a3,a3,-468 # ffffffffc0205c90 <default_pmm_manager+0x850>
ffffffffc0202e6c:	00002617          	auipc	a2,0x2
ffffffffc0202e70:	22460613          	addi	a2,a2,548 # ffffffffc0205090 <commands+0x738>
ffffffffc0202e74:	09600593          	li	a1,150
ffffffffc0202e78:	00003517          	auipc	a0,0x3
ffffffffc0202e7c:	c7050513          	addi	a0,a0,-912 # ffffffffc0205ae8 <default_pmm_manager+0x6a8>
ffffffffc0202e80:	cf4fd0ef          	jal	ra,ffffffffc0200374 <__panic>
     assert(pgfault_num==2);
ffffffffc0202e84:	00003697          	auipc	a3,0x3
ffffffffc0202e88:	e0c68693          	addi	a3,a3,-500 # ffffffffc0205c90 <default_pmm_manager+0x850>
ffffffffc0202e8c:	00002617          	auipc	a2,0x2
ffffffffc0202e90:	20460613          	addi	a2,a2,516 # ffffffffc0205090 <commands+0x738>
ffffffffc0202e94:	09800593          	li	a1,152
ffffffffc0202e98:	00003517          	auipc	a0,0x3
ffffffffc0202e9c:	c5050513          	addi	a0,a0,-944 # ffffffffc0205ae8 <default_pmm_manager+0x6a8>
ffffffffc0202ea0:	cd4fd0ef          	jal	ra,ffffffffc0200374 <__panic>
     assert(pgfault_num==3);
ffffffffc0202ea4:	00003697          	auipc	a3,0x3
ffffffffc0202ea8:	dfc68693          	addi	a3,a3,-516 # ffffffffc0205ca0 <default_pmm_manager+0x860>
ffffffffc0202eac:	00002617          	auipc	a2,0x2
ffffffffc0202eb0:	1e460613          	addi	a2,a2,484 # ffffffffc0205090 <commands+0x738>
ffffffffc0202eb4:	09a00593          	li	a1,154
ffffffffc0202eb8:	00003517          	auipc	a0,0x3
ffffffffc0202ebc:	c3050513          	addi	a0,a0,-976 # ffffffffc0205ae8 <default_pmm_manager+0x6a8>
ffffffffc0202ec0:	cb4fd0ef          	jal	ra,ffffffffc0200374 <__panic>
     assert(pgfault_num==3);
ffffffffc0202ec4:	00003697          	auipc	a3,0x3
ffffffffc0202ec8:	ddc68693          	addi	a3,a3,-548 # ffffffffc0205ca0 <default_pmm_manager+0x860>
ffffffffc0202ecc:	00002617          	auipc	a2,0x2
ffffffffc0202ed0:	1c460613          	addi	a2,a2,452 # ffffffffc0205090 <commands+0x738>
ffffffffc0202ed4:	09c00593          	li	a1,156
ffffffffc0202ed8:	00003517          	auipc	a0,0x3
ffffffffc0202edc:	c1050513          	addi	a0,a0,-1008 # ffffffffc0205ae8 <default_pmm_manager+0x6a8>
ffffffffc0202ee0:	c94fd0ef          	jal	ra,ffffffffc0200374 <__panic>
     assert(pgfault_num==1);
ffffffffc0202ee4:	00003697          	auipc	a3,0x3
ffffffffc0202ee8:	d9c68693          	addi	a3,a3,-612 # ffffffffc0205c80 <default_pmm_manager+0x840>
ffffffffc0202eec:	00002617          	auipc	a2,0x2
ffffffffc0202ef0:	1a460613          	addi	a2,a2,420 # ffffffffc0205090 <commands+0x738>
ffffffffc0202ef4:	09200593          	li	a1,146
ffffffffc0202ef8:	00003517          	auipc	a0,0x3
ffffffffc0202efc:	bf050513          	addi	a0,a0,-1040 # ffffffffc0205ae8 <default_pmm_manager+0x6a8>
ffffffffc0202f00:	c74fd0ef          	jal	ra,ffffffffc0200374 <__panic>
     assert(pgfault_num==1);
ffffffffc0202f04:	00003697          	auipc	a3,0x3
ffffffffc0202f08:	d7c68693          	addi	a3,a3,-644 # ffffffffc0205c80 <default_pmm_manager+0x840>
ffffffffc0202f0c:	00002617          	auipc	a2,0x2
ffffffffc0202f10:	18460613          	addi	a2,a2,388 # ffffffffc0205090 <commands+0x738>
ffffffffc0202f14:	09400593          	li	a1,148
ffffffffc0202f18:	00003517          	auipc	a0,0x3
ffffffffc0202f1c:	bd050513          	addi	a0,a0,-1072 # ffffffffc0205ae8 <default_pmm_manager+0x6a8>
ffffffffc0202f20:	c54fd0ef          	jal	ra,ffffffffc0200374 <__panic>
     assert(mm != NULL);
ffffffffc0202f24:	00003697          	auipc	a3,0x3
ffffffffc0202f28:	c1468693          	addi	a3,a3,-1004 # ffffffffc0205b38 <default_pmm_manager+0x6f8>
ffffffffc0202f2c:	00002617          	auipc	a2,0x2
ffffffffc0202f30:	16460613          	addi	a2,a2,356 # ffffffffc0205090 <commands+0x738>
ffffffffc0202f34:	0c300593          	li	a1,195
ffffffffc0202f38:	00003517          	auipc	a0,0x3
ffffffffc0202f3c:	bb050513          	addi	a0,a0,-1104 # ffffffffc0205ae8 <default_pmm_manager+0x6a8>
ffffffffc0202f40:	c34fd0ef          	jal	ra,ffffffffc0200374 <__panic>
     assert(check_mm_struct == NULL);
ffffffffc0202f44:	00003697          	auipc	a3,0x3
ffffffffc0202f48:	c0468693          	addi	a3,a3,-1020 # ffffffffc0205b48 <default_pmm_manager+0x708>
ffffffffc0202f4c:	00002617          	auipc	a2,0x2
ffffffffc0202f50:	14460613          	addi	a2,a2,324 # ffffffffc0205090 <commands+0x738>
ffffffffc0202f54:	0c600593          	li	a1,198
ffffffffc0202f58:	00003517          	auipc	a0,0x3
ffffffffc0202f5c:	b9050513          	addi	a0,a0,-1136 # ffffffffc0205ae8 <default_pmm_manager+0x6a8>
ffffffffc0202f60:	c14fd0ef          	jal	ra,ffffffffc0200374 <__panic>
     assert(nr_free==CHECK_VALID_PHY_PAGE_NUM);
ffffffffc0202f64:	00003697          	auipc	a3,0x3
ffffffffc0202f68:	ccc68693          	addi	a3,a3,-820 # ffffffffc0205c30 <default_pmm_manager+0x7f0>
ffffffffc0202f6c:	00002617          	auipc	a2,0x2
ffffffffc0202f70:	12460613          	addi	a2,a2,292 # ffffffffc0205090 <commands+0x738>
ffffffffc0202f74:	0e900593          	li	a1,233
ffffffffc0202f78:	00003517          	auipc	a0,0x3
ffffffffc0202f7c:	b7050513          	addi	a0,a0,-1168 # ffffffffc0205ae8 <default_pmm_manager+0x6a8>
ffffffffc0202f80:	bf4fd0ef          	jal	ra,ffffffffc0200374 <__panic>

ffffffffc0202f84 <swap_init_mm>:
     return sm->init_mm(mm);
ffffffffc0202f84:	0000e797          	auipc	a5,0xe
ffffffffc0202f88:	5c47b783          	ld	a5,1476(a5) # ffffffffc0211548 <sm>
ffffffffc0202f8c:	6b9c                	ld	a5,16(a5)
ffffffffc0202f8e:	8782                	jr	a5

ffffffffc0202f90 <swap_map_swappable>:
     return sm->map_swappable(mm, addr, page, swap_in);
ffffffffc0202f90:	0000e797          	auipc	a5,0xe
ffffffffc0202f94:	5b87b783          	ld	a5,1464(a5) # ffffffffc0211548 <sm>
ffffffffc0202f98:	739c                	ld	a5,32(a5)
ffffffffc0202f9a:	8782                	jr	a5

ffffffffc0202f9c <swap_out>:
{
ffffffffc0202f9c:	711d                	addi	sp,sp,-96
ffffffffc0202f9e:	ec86                	sd	ra,88(sp)
ffffffffc0202fa0:	e8a2                	sd	s0,80(sp)
ffffffffc0202fa2:	e4a6                	sd	s1,72(sp)
ffffffffc0202fa4:	e0ca                	sd	s2,64(sp)
ffffffffc0202fa6:	fc4e                	sd	s3,56(sp)
ffffffffc0202fa8:	f852                	sd	s4,48(sp)
ffffffffc0202faa:	f456                	sd	s5,40(sp)
ffffffffc0202fac:	f05a                	sd	s6,32(sp)
ffffffffc0202fae:	ec5e                	sd	s7,24(sp)
ffffffffc0202fb0:	e862                	sd	s8,16(sp)
     for (i = 0; i != n; ++ i)
ffffffffc0202fb2:	cde9                	beqz	a1,ffffffffc020308c <swap_out+0xf0>
ffffffffc0202fb4:	8a2e                	mv	s4,a1
ffffffffc0202fb6:	892a                	mv	s2,a0
ffffffffc0202fb8:	8ab2                	mv	s5,a2
ffffffffc0202fba:	4401                	li	s0,0
ffffffffc0202fbc:	0000e997          	auipc	s3,0xe
ffffffffc0202fc0:	58c98993          	addi	s3,s3,1420 # ffffffffc0211548 <sm>
                    cprintf("swap_out: i %d, store page in vaddr 0x%x to disk swap entry %d\n", i, v, page->pra_vaddr/PGSIZE+1);
ffffffffc0202fc4:	00003b17          	auipc	s6,0x3
ffffffffc0202fc8:	e0cb0b13          	addi	s6,s6,-500 # ffffffffc0205dd0 <default_pmm_manager+0x990>
                    cprintf("SWAP: failed to save\n");
ffffffffc0202fcc:	00003b97          	auipc	s7,0x3
ffffffffc0202fd0:	decb8b93          	addi	s7,s7,-532 # ffffffffc0205db8 <default_pmm_manager+0x978>
ffffffffc0202fd4:	a825                	j	ffffffffc020300c <swap_out+0x70>
                    cprintf("swap_out: i %d, store page in vaddr 0x%x to disk swap entry %d\n", i, v, page->pra_vaddr/PGSIZE+1);
ffffffffc0202fd6:	67a2                	ld	a5,8(sp)
ffffffffc0202fd8:	8626                	mv	a2,s1
ffffffffc0202fda:	85a2                	mv	a1,s0
ffffffffc0202fdc:	63b4                	ld	a3,64(a5)
ffffffffc0202fde:	855a                	mv	a0,s6
     for (i = 0; i != n; ++ i)
ffffffffc0202fe0:	2405                	addiw	s0,s0,1
                    cprintf("swap_out: i %d, store page in vaddr 0x%x to disk swap entry %d\n", i, v, page->pra_vaddr/PGSIZE+1);
ffffffffc0202fe2:	82b1                	srli	a3,a3,0xc
ffffffffc0202fe4:	0685                	addi	a3,a3,1
ffffffffc0202fe6:	8d4fd0ef          	jal	ra,ffffffffc02000ba <cprintf>
                    *ptep = (page->pra_vaddr/PGSIZE+1)<<8;
ffffffffc0202fea:	6522                	ld	a0,8(sp)
                    free_page(page);
ffffffffc0202fec:	4585                	li	a1,1
                    *ptep = (page->pra_vaddr/PGSIZE+1)<<8;
ffffffffc0202fee:	613c                	ld	a5,64(a0)
ffffffffc0202ff0:	83b1                	srli	a5,a5,0xc
ffffffffc0202ff2:	0785                	addi	a5,a5,1
ffffffffc0202ff4:	07a2                	slli	a5,a5,0x8
ffffffffc0202ff6:	00fc3023          	sd	a5,0(s8)
                    free_page(page);
ffffffffc0202ffa:	e58fe0ef          	jal	ra,ffffffffc0201652 <free_pages>
          tlb_invalidate(mm->pgdir, v);
ffffffffc0202ffe:	01893503          	ld	a0,24(s2)
ffffffffc0203002:	85a6                	mv	a1,s1
ffffffffc0203004:	eb6ff0ef          	jal	ra,ffffffffc02026ba <tlb_invalidate>
     for (i = 0; i != n; ++ i)
ffffffffc0203008:	048a0d63          	beq	s4,s0,ffffffffc0203062 <swap_out+0xc6>
          int r = sm->swap_out_victim(mm, &page, in_tick);
ffffffffc020300c:	0009b783          	ld	a5,0(s3)
ffffffffc0203010:	8656                	mv	a2,s5
ffffffffc0203012:	002c                	addi	a1,sp,8
ffffffffc0203014:	7b9c                	ld	a5,48(a5)
ffffffffc0203016:	854a                	mv	a0,s2
ffffffffc0203018:	9782                	jalr	a5
          if (r != 0) {
ffffffffc020301a:	e12d                	bnez	a0,ffffffffc020307c <swap_out+0xe0>
          v=page->pra_vaddr; 
ffffffffc020301c:	67a2                	ld	a5,8(sp)
          pte_t *ptep = get_pte(mm->pgdir, v, 0);
ffffffffc020301e:	01893503          	ld	a0,24(s2)
ffffffffc0203022:	4601                	li	a2,0
          v=page->pra_vaddr; 
ffffffffc0203024:	63a4                	ld	s1,64(a5)
          pte_t *ptep = get_pte(mm->pgdir, v, 0);
ffffffffc0203026:	85a6                	mv	a1,s1
ffffffffc0203028:	ea4fe0ef          	jal	ra,ffffffffc02016cc <get_pte>
          assert((*ptep & PTE_V) != 0);
ffffffffc020302c:	611c                	ld	a5,0(a0)
          pte_t *ptep = get_pte(mm->pgdir, v, 0);
ffffffffc020302e:	8c2a                	mv	s8,a0
          assert((*ptep & PTE_V) != 0);
ffffffffc0203030:	8b85                	andi	a5,a5,1
ffffffffc0203032:	cfb9                	beqz	a5,ffffffffc0203090 <swap_out+0xf4>
          if (swapfs_write( (page->pra_vaddr/PGSIZE+1)<<8, page) != 0) {
ffffffffc0203034:	65a2                	ld	a1,8(sp)
ffffffffc0203036:	61bc                	ld	a5,64(a1)
ffffffffc0203038:	83b1                	srli	a5,a5,0xc
ffffffffc020303a:	0785                	addi	a5,a5,1
ffffffffc020303c:	00879513          	slli	a0,a5,0x8
ffffffffc0203040:	0d8010ef          	jal	ra,ffffffffc0204118 <swapfs_write>
ffffffffc0203044:	d949                	beqz	a0,ffffffffc0202fd6 <swap_out+0x3a>
                    cprintf("SWAP: failed to save\n");
ffffffffc0203046:	855e                	mv	a0,s7
ffffffffc0203048:	872fd0ef          	jal	ra,ffffffffc02000ba <cprintf>
                    sm->map_swappable(mm, v, page, 0);
ffffffffc020304c:	0009b783          	ld	a5,0(s3)
ffffffffc0203050:	6622                	ld	a2,8(sp)
ffffffffc0203052:	4681                	li	a3,0
ffffffffc0203054:	739c                	ld	a5,32(a5)
ffffffffc0203056:	85a6                	mv	a1,s1
ffffffffc0203058:	854a                	mv	a0,s2
     for (i = 0; i != n; ++ i)
ffffffffc020305a:	2405                	addiw	s0,s0,1
                    sm->map_swappable(mm, v, page, 0);
ffffffffc020305c:	9782                	jalr	a5
     for (i = 0; i != n; ++ i)
ffffffffc020305e:	fa8a17e3          	bne	s4,s0,ffffffffc020300c <swap_out+0x70>
}
ffffffffc0203062:	60e6                	ld	ra,88(sp)
ffffffffc0203064:	8522                	mv	a0,s0
ffffffffc0203066:	6446                	ld	s0,80(sp)
ffffffffc0203068:	64a6                	ld	s1,72(sp)
ffffffffc020306a:	6906                	ld	s2,64(sp)
ffffffffc020306c:	79e2                	ld	s3,56(sp)
ffffffffc020306e:	7a42                	ld	s4,48(sp)
ffffffffc0203070:	7aa2                	ld	s5,40(sp)
ffffffffc0203072:	7b02                	ld	s6,32(sp)
ffffffffc0203074:	6be2                	ld	s7,24(sp)
ffffffffc0203076:	6c42                	ld	s8,16(sp)
ffffffffc0203078:	6125                	addi	sp,sp,96
ffffffffc020307a:	8082                	ret
                    cprintf("i %d, swap_out: call swap_out_victim failed\n",i);
ffffffffc020307c:	85a2                	mv	a1,s0
ffffffffc020307e:	00003517          	auipc	a0,0x3
ffffffffc0203082:	cf250513          	addi	a0,a0,-782 # ffffffffc0205d70 <default_pmm_manager+0x930>
ffffffffc0203086:	834fd0ef          	jal	ra,ffffffffc02000ba <cprintf>
                  break;
ffffffffc020308a:	bfe1                	j	ffffffffc0203062 <swap_out+0xc6>
     for (i = 0; i != n; ++ i)
ffffffffc020308c:	4401                	li	s0,0
ffffffffc020308e:	bfd1                	j	ffffffffc0203062 <swap_out+0xc6>
          assert((*ptep & PTE_V) != 0);
ffffffffc0203090:	00003697          	auipc	a3,0x3
ffffffffc0203094:	d1068693          	addi	a3,a3,-752 # ffffffffc0205da0 <default_pmm_manager+0x960>
ffffffffc0203098:	00002617          	auipc	a2,0x2
ffffffffc020309c:	ff860613          	addi	a2,a2,-8 # ffffffffc0205090 <commands+0x738>
ffffffffc02030a0:	06700593          	li	a1,103
ffffffffc02030a4:	00003517          	auipc	a0,0x3
ffffffffc02030a8:	a4450513          	addi	a0,a0,-1468 # ffffffffc0205ae8 <default_pmm_manager+0x6a8>
ffffffffc02030ac:	ac8fd0ef          	jal	ra,ffffffffc0200374 <__panic>

ffffffffc02030b0 <swap_in>:
{
ffffffffc02030b0:	7179                	addi	sp,sp,-48
ffffffffc02030b2:	e84a                	sd	s2,16(sp)
ffffffffc02030b4:	892a                	mv	s2,a0
     struct Page *result = alloc_page();
ffffffffc02030b6:	4505                	li	a0,1
{
ffffffffc02030b8:	ec26                	sd	s1,24(sp)
ffffffffc02030ba:	e44e                	sd	s3,8(sp)
ffffffffc02030bc:	f406                	sd	ra,40(sp)
ffffffffc02030be:	f022                	sd	s0,32(sp)
ffffffffc02030c0:	84ae                	mv	s1,a1
ffffffffc02030c2:	89b2                	mv	s3,a2
     struct Page *result = alloc_page();
ffffffffc02030c4:	cfcfe0ef          	jal	ra,ffffffffc02015c0 <alloc_pages>
     assert(result!=NULL);
ffffffffc02030c8:	c129                	beqz	a0,ffffffffc020310a <swap_in+0x5a>
     pte_t *ptep = get_pte(mm->pgdir, addr, 0);
ffffffffc02030ca:	842a                	mv	s0,a0
ffffffffc02030cc:	01893503          	ld	a0,24(s2)
ffffffffc02030d0:	4601                	li	a2,0
ffffffffc02030d2:	85a6                	mv	a1,s1
ffffffffc02030d4:	df8fe0ef          	jal	ra,ffffffffc02016cc <get_pte>
ffffffffc02030d8:	892a                	mv	s2,a0
     if ((r = swapfs_read((*ptep), result)) != 0)
ffffffffc02030da:	6108                	ld	a0,0(a0)
ffffffffc02030dc:	85a2                	mv	a1,s0
ffffffffc02030de:	7a1000ef          	jal	ra,ffffffffc020407e <swapfs_read>
     cprintf("swap_in: load disk swap entry %d with swap_page in vadr 0x%x\n", (*ptep)>>8, addr);
ffffffffc02030e2:	00093583          	ld	a1,0(s2)
ffffffffc02030e6:	8626                	mv	a2,s1
ffffffffc02030e8:	00003517          	auipc	a0,0x3
ffffffffc02030ec:	d3850513          	addi	a0,a0,-712 # ffffffffc0205e20 <default_pmm_manager+0x9e0>
ffffffffc02030f0:	81a1                	srli	a1,a1,0x8
ffffffffc02030f2:	fc9fc0ef          	jal	ra,ffffffffc02000ba <cprintf>
}
ffffffffc02030f6:	70a2                	ld	ra,40(sp)
     *ptr_result=result;
ffffffffc02030f8:	0089b023          	sd	s0,0(s3)
}
ffffffffc02030fc:	7402                	ld	s0,32(sp)
ffffffffc02030fe:	64e2                	ld	s1,24(sp)
ffffffffc0203100:	6942                	ld	s2,16(sp)
ffffffffc0203102:	69a2                	ld	s3,8(sp)
ffffffffc0203104:	4501                	li	a0,0
ffffffffc0203106:	6145                	addi	sp,sp,48
ffffffffc0203108:	8082                	ret
     assert(result!=NULL);
ffffffffc020310a:	00003697          	auipc	a3,0x3
ffffffffc020310e:	d0668693          	addi	a3,a3,-762 # ffffffffc0205e10 <default_pmm_manager+0x9d0>
ffffffffc0203112:	00002617          	auipc	a2,0x2
ffffffffc0203116:	f7e60613          	addi	a2,a2,-130 # ffffffffc0205090 <commands+0x738>
ffffffffc020311a:	07d00593          	li	a1,125
ffffffffc020311e:	00003517          	auipc	a0,0x3
ffffffffc0203122:	9ca50513          	addi	a0,a0,-1590 # ffffffffc0205ae8 <default_pmm_manager+0x6a8>
ffffffffc0203126:	a4efd0ef          	jal	ra,ffffffffc0200374 <__panic>

ffffffffc020312a <_lru_init_mm>:
    elm->prev = elm->next = elm;
ffffffffc020312a:	0000e797          	auipc	a5,0xe
ffffffffc020312e:	fbe78793          	addi	a5,a5,-66 # ffffffffc02110e8 <pra_list_head>
//初始化内存管理结构mm_struct
static int 
_lru_init_mm(struct mm_struct *mm)
{
    list_init(&pra_list_head);//初始化按最近一次访问时间排序的双向的页面链表
    mm->sm_priv = &pra_list_head;//使用链表结构用于页面置换管理器
ffffffffc0203132:	f51c                	sd	a5,40(a0)
ffffffffc0203134:	e79c                	sd	a5,8(a5)
ffffffffc0203136:	e39c                	sd	a5,0(a5)
    return 0;
}
ffffffffc0203138:	4501                	li	a0,0
ffffffffc020313a:	8082                	ret

ffffffffc020313c <_lru_init>:
}

static int _lru_init(void)
{
    return 0;
}
ffffffffc020313c:	4501                	li	a0,0
ffffffffc020313e:	8082                	ret

ffffffffc0203140 <_lru_set_unswappable>:

static int _lru_set_unswappable(struct mm_struct *mm, uintptr_t addr)
{
    return 0;
}
ffffffffc0203140:	4501                	li	a0,0
ffffffffc0203142:	8082                	ret

ffffffffc0203144 <_lru_tick_event>:

static int _lru_tick_event(struct mm_struct *mm)
{
    return 0;
}
ffffffffc0203144:	4501                	li	a0,0
ffffffffc0203146:	8082                	ret

ffffffffc0203148 <_lru_swap_out_victim>:
    list_entry_t *head = (list_entry_t *)mm->sm_priv;//从内存管理结构 mm_struct 中获取链表头
ffffffffc0203148:	7518                	ld	a4,40(a0)
{
ffffffffc020314a:	1141                	addi	sp,sp,-16
ffffffffc020314c:	e406                	sd	ra,8(sp)
    assert(head != NULL);//确保 head 都不是空指针
ffffffffc020314e:	c731                	beqz	a4,ffffffffc020319a <_lru_swap_out_victim+0x52>
    assert(in_tick == 0);
ffffffffc0203150:	e60d                	bnez	a2,ffffffffc020317a <_lru_swap_out_victim+0x32>
 * list_prev - get the previous entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_prev(list_entry_t *listelm) {
    return listelm->prev;
ffffffffc0203152:	631c                	ld	a5,0(a4)
    if (entry != head)
ffffffffc0203154:	00f70d63          	beq	a4,a5,ffffffffc020316e <_lru_swap_out_victim+0x26>
    __list_del(listelm->prev, listelm->next);
ffffffffc0203158:	6394                	ld	a3,0(a5)
ffffffffc020315a:	6798                	ld	a4,8(a5)
}
ffffffffc020315c:	60a2                	ld	ra,8(sp)
        *ptr_page = le2page(entry, pra_page_link);//将链表项转换回页面结构，并将其地址赋值给 ptr_page 指针指向的变量
ffffffffc020315e:	fd078793          	addi	a5,a5,-48
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
ffffffffc0203162:	e698                	sd	a4,8(a3)
    next->prev = prev;
ffffffffc0203164:	e314                	sd	a3,0(a4)
ffffffffc0203166:	e19c                	sd	a5,0(a1)
}
ffffffffc0203168:	4501                	li	a0,0
ffffffffc020316a:	0141                	addi	sp,sp,16
ffffffffc020316c:	8082                	ret
ffffffffc020316e:	60a2                	ld	ra,8(sp)
        *ptr_page = NULL;
ffffffffc0203170:	0005b023          	sd	zero,0(a1) # 1000 <kern_entry-0xffffffffc01ff000>
}
ffffffffc0203174:	4501                	li	a0,0
ffffffffc0203176:	0141                	addi	sp,sp,16
ffffffffc0203178:	8082                	ret
    assert(in_tick == 0);
ffffffffc020317a:	00003697          	auipc	a3,0x3
ffffffffc020317e:	d0e68693          	addi	a3,a3,-754 # ffffffffc0205e88 <default_pmm_manager+0xa48>
ffffffffc0203182:	00002617          	auipc	a2,0x2
ffffffffc0203186:	f0e60613          	addi	a2,a2,-242 # ffffffffc0205090 <commands+0x738>
ffffffffc020318a:	03100593          	li	a1,49
ffffffffc020318e:	00003517          	auipc	a0,0x3
ffffffffc0203192:	ce250513          	addi	a0,a0,-798 # ffffffffc0205e70 <default_pmm_manager+0xa30>
ffffffffc0203196:	9defd0ef          	jal	ra,ffffffffc0200374 <__panic>
    assert(head != NULL);//确保 head 都不是空指针
ffffffffc020319a:	00003697          	auipc	a3,0x3
ffffffffc020319e:	cc668693          	addi	a3,a3,-826 # ffffffffc0205e60 <default_pmm_manager+0xa20>
ffffffffc02031a2:	00002617          	auipc	a2,0x2
ffffffffc02031a6:	eee60613          	addi	a2,a2,-274 # ffffffffc0205090 <commands+0x738>
ffffffffc02031aa:	03000593          	li	a1,48
ffffffffc02031ae:	00003517          	auipc	a0,0x3
ffffffffc02031b2:	cc250513          	addi	a0,a0,-830 # ffffffffc0205e70 <default_pmm_manager+0xa30>
ffffffffc02031b6:	9befd0ef          	jal	ra,ffffffffc0200374 <__panic>

ffffffffc02031ba <_lru_map_swappable>:
    list_entry_t *head = (list_entry_t *)mm->sm_priv;//从内存管理结构 mm_struct 中获取链表头
ffffffffc02031ba:	7518                	ld	a4,40(a0)
    assert(entry != NULL && head != NULL);//确保 entry 和 head 都不是空指针
ffffffffc02031bc:	c329                	beqz	a4,ffffffffc02031fe <_lru_map_swappable+0x44>
    for (list_entry_t *tmp = head->next; tmp != head; tmp = tmp->next) {
ffffffffc02031be:	670c                	ld	a1,8(a4)
ffffffffc02031c0:	03060693          	addi	a3,a2,48
ffffffffc02031c4:	00b70b63          	beq	a4,a1,ffffffffc02031da <_lru_map_swappable+0x20>
        if (tmp == entry) {
ffffffffc02031c8:	00b68f63          	beq	a3,a1,ffffffffc02031e6 <_lru_map_swappable+0x2c>
ffffffffc02031cc:	87ae                	mv	a5,a1
ffffffffc02031ce:	a019                	j	ffffffffc02031d4 <_lru_map_swappable+0x1a>
ffffffffc02031d0:	00f68c63          	beq	a3,a5,ffffffffc02031e8 <_lru_map_swappable+0x2e>
    for (list_entry_t *tmp = head->next; tmp != head; tmp = tmp->next) {
ffffffffc02031d4:	679c                	ld	a5,8(a5)
ffffffffc02031d6:	fef71de3          	bne	a4,a5,ffffffffc02031d0 <_lru_map_swappable+0x16>
    prev->next = next->prev = elm;
ffffffffc02031da:	e194                	sd	a3,0(a1)
ffffffffc02031dc:	e714                	sd	a3,8(a4)
    elm->next = next;
ffffffffc02031de:	fe0c                	sd	a1,56(a2)
    elm->prev = prev;
ffffffffc02031e0:	fa18                	sd	a4,48(a2)
}
ffffffffc02031e2:	4501                	li	a0,0
ffffffffc02031e4:	8082                	ret
        if (tmp == entry) {
ffffffffc02031e6:	87b6                	mv	a5,a3
    __list_del(listelm->prev, listelm->next);
ffffffffc02031e8:	6388                	ld	a0,0(a5)
ffffffffc02031ea:	679c                	ld	a5,8(a5)
    prev->next = next;
ffffffffc02031ec:	e51c                	sd	a5,8(a0)
    __list_add(elm, listelm, listelm->next);
ffffffffc02031ee:	670c                	ld	a1,8(a4)
    next->prev = prev;
ffffffffc02031f0:	e388                	sd	a0,0(a5)
}
ffffffffc02031f2:	4501                	li	a0,0
    prev->next = next->prev = elm;
ffffffffc02031f4:	e194                	sd	a3,0(a1)
ffffffffc02031f6:	e714                	sd	a3,8(a4)
    elm->next = next;
ffffffffc02031f8:	fe0c                	sd	a1,56(a2)
    elm->prev = prev;
ffffffffc02031fa:	fa18                	sd	a4,48(a2)
ffffffffc02031fc:	8082                	ret
{
ffffffffc02031fe:	1141                	addi	sp,sp,-16
    assert(entry != NULL && head != NULL);//确保 entry 和 head 都不是空指针
ffffffffc0203200:	00003697          	auipc	a3,0x3
ffffffffc0203204:	c9868693          	addi	a3,a3,-872 # ffffffffc0205e98 <default_pmm_manager+0xa58>
ffffffffc0203208:	00002617          	auipc	a2,0x2
ffffffffc020320c:	e8860613          	addi	a2,a2,-376 # ffffffffc0205090 <commands+0x738>
ffffffffc0203210:	45fd                	li	a1,31
ffffffffc0203212:	00003517          	auipc	a0,0x3
ffffffffc0203216:	c5e50513          	addi	a0,a0,-930 # ffffffffc0205e70 <default_pmm_manager+0xa30>
{
ffffffffc020321a:	e406                	sd	ra,8(sp)
    assert(entry != NULL && head != NULL);//确保 entry 和 head 都不是空指针
ffffffffc020321c:	958fd0ef          	jal	ra,ffffffffc0200374 <__panic>

ffffffffc0203220 <write_page>:
{
ffffffffc0203220:	1101                	addi	sp,sp,-32
ffffffffc0203222:	e822                	sd	s0,16(sp)
ffffffffc0203224:	842a                	mv	s0,a0
    pte_t *ptep = get_pte(mm->pgdir, (uintptr_t)a, 0);//使用get_pte函数获取内存地址为a的页表项
ffffffffc0203226:	6d08                	ld	a0,24(a0)
{
ffffffffc0203228:	e04a                	sd	s2,0(sp)
ffffffffc020322a:	8932                	mv	s2,a2
    pte_t *ptep = get_pte(mm->pgdir, (uintptr_t)a, 0);//使用get_pte函数获取内存地址为a的页表项
ffffffffc020322c:	4601                	li	a2,0
{
ffffffffc020322e:	e426                	sd	s1,8(sp)
ffffffffc0203230:	ec06                	sd	ra,24(sp)
ffffffffc0203232:	84ae                	mv	s1,a1
    pte_t *ptep = get_pte(mm->pgdir, (uintptr_t)a, 0);//使用get_pte函数获取内存地址为a的页表项
ffffffffc0203234:	c98fe0ef          	jal	ra,ffffffffc02016cc <get_pte>
    if ((ptep != NULL) && (*ptep & PTE_V))//检查PTE_V是否被设置，当页表项存在且有效时 说，明改地址已映射到屋里内存 执行
ffffffffc0203238:	c509                	beqz	a0,ffffffffc0203242 <write_page+0x22>
ffffffffc020323a:	611c                	ld	a5,0(a0)
ffffffffc020323c:	0017f713          	andi	a4,a5,1
ffffffffc0203240:	eb09                	bnez	a4,ffffffffc0203252 <write_page+0x32>
    *a = b;//修改页面链表
ffffffffc0203242:	01248023          	sb	s2,0(s1)
}
ffffffffc0203246:	60e2                	ld	ra,24(sp)
ffffffffc0203248:	6442                	ld	s0,16(sp)
ffffffffc020324a:	64a2                	ld	s1,8(sp)
ffffffffc020324c:	6902                	ld	s2,0(sp)
ffffffffc020324e:	6105                	addi	sp,sp,32
ffffffffc0203250:	8082                	ret
    return pa2page(PTE_ADDR(pte));
ffffffffc0203252:	078a                	slli	a5,a5,0x2
ffffffffc0203254:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage) {
ffffffffc0203256:	0000e717          	auipc	a4,0xe
ffffffffc020325a:	2ca73703          	ld	a4,714(a4) # ffffffffc0211520 <npage>
ffffffffc020325e:	02e7fd63          	bgeu	a5,a4,ffffffffc0203298 <write_page+0x78>
    return &pages[PPN(pa) - nbase];
ffffffffc0203262:	00003617          	auipc	a2,0x3
ffffffffc0203266:	47663603          	ld	a2,1142(a2) # ffffffffc02066d8 <nbase>
ffffffffc020326a:	8f91                	sub	a5,a5,a2
ffffffffc020326c:	00379613          	slli	a2,a5,0x3
ffffffffc0203270:	97b2                	add	a5,a5,a2
ffffffffc0203272:	078e                	slli	a5,a5,0x3
        _lru_map_swappable(mm, (uintptr_t)a, page, 1);//调用_lru_map_swappable 函数，将页面标记为可交换
ffffffffc0203274:	0000e617          	auipc	a2,0xe
ffffffffc0203278:	2b463603          	ld	a2,692(a2) # ffffffffc0211528 <pages>
ffffffffc020327c:	85a6                	mv	a1,s1
ffffffffc020327e:	8522                	mv	a0,s0
ffffffffc0203280:	4685                	li	a3,1
ffffffffc0203282:	963e                	add	a2,a2,a5
ffffffffc0203284:	f37ff0ef          	jal	ra,ffffffffc02031ba <_lru_map_swappable>
    *a = b;//修改页面链表
ffffffffc0203288:	01248023          	sb	s2,0(s1)
}
ffffffffc020328c:	60e2                	ld	ra,24(sp)
ffffffffc020328e:	6442                	ld	s0,16(sp)
ffffffffc0203290:	64a2                	ld	s1,8(sp)
ffffffffc0203292:	6902                	ld	s2,0(sp)
ffffffffc0203294:	6105                	addi	sp,sp,32
ffffffffc0203296:	8082                	ret
        panic("pa2page called with invalid pa");
ffffffffc0203298:	00002617          	auipc	a2,0x2
ffffffffc020329c:	1e060613          	addi	a2,a2,480 # ffffffffc0205478 <default_pmm_manager+0x38>
ffffffffc02032a0:	06500593          	li	a1,101
ffffffffc02032a4:	00002517          	auipc	a0,0x2
ffffffffc02032a8:	1f450513          	addi	a0,a0,500 # ffffffffc0205498 <default_pmm_manager+0x58>
ffffffffc02032ac:	8c8fd0ef          	jal	ra,ffffffffc0200374 <__panic>

ffffffffc02032b0 <read_page>:
{
ffffffffc02032b0:	1101                	addi	sp,sp,-32
ffffffffc02032b2:	e822                	sd	s0,16(sp)
ffffffffc02032b4:	842a                	mv	s0,a0
    pte_t *ptep = get_pte(mm->pgdir, (uintptr_t)a, 0);//使用get_pte函数获取内存地址为a的页表项
ffffffffc02032b6:	6d08                	ld	a0,24(a0)
ffffffffc02032b8:	4601                	li	a2,0
{
ffffffffc02032ba:	e426                	sd	s1,8(sp)
ffffffffc02032bc:	ec06                	sd	ra,24(sp)
ffffffffc02032be:	84ae                	mv	s1,a1
    pte_t *ptep = get_pte(mm->pgdir, (uintptr_t)a, 0);//使用get_pte函数获取内存地址为a的页表项
ffffffffc02032c0:	c0cfe0ef          	jal	ra,ffffffffc02016cc <get_pte>
    if ((ptep != NULL) && (*ptep & PTE_V))//检查PTE_V是否被设置，当页表项存在且有效时 说，明改地址已映射到屋里内存 执行
ffffffffc02032c4:	c509                	beqz	a0,ffffffffc02032ce <read_page+0x1e>
ffffffffc02032c6:	611c                	ld	a5,0(a0)
ffffffffc02032c8:	0017f713          	andi	a4,a5,1
ffffffffc02032cc:	eb01                	bnez	a4,ffffffffc02032dc <read_page+0x2c>
}
ffffffffc02032ce:	60e2                	ld	ra,24(sp)
ffffffffc02032d0:	6442                	ld	s0,16(sp)
ffffffffc02032d2:	0004c503          	lbu	a0,0(s1)
ffffffffc02032d6:	64a2                	ld	s1,8(sp)
ffffffffc02032d8:	6105                	addi	sp,sp,32
ffffffffc02032da:	8082                	ret
    return pa2page(PTE_ADDR(pte));
ffffffffc02032dc:	078a                	slli	a5,a5,0x2
ffffffffc02032de:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage) {
ffffffffc02032e0:	0000e717          	auipc	a4,0xe
ffffffffc02032e4:	24073703          	ld	a4,576(a4) # ffffffffc0211520 <npage>
ffffffffc02032e8:	02e7fc63          	bgeu	a5,a4,ffffffffc0203320 <read_page+0x70>
    return &pages[PPN(pa) - nbase];
ffffffffc02032ec:	00003617          	auipc	a2,0x3
ffffffffc02032f0:	3ec63603          	ld	a2,1004(a2) # ffffffffc02066d8 <nbase>
ffffffffc02032f4:	8f91                	sub	a5,a5,a2
ffffffffc02032f6:	00379613          	slli	a2,a5,0x3
ffffffffc02032fa:	97b2                	add	a5,a5,a2
ffffffffc02032fc:	078e                	slli	a5,a5,0x3
        _lru_map_swappable(mm, (uintptr_t)a, page, 1);//调用_lru_map_swappable 函数，将页面标记为可交换
ffffffffc02032fe:	0000e617          	auipc	a2,0xe
ffffffffc0203302:	22a63603          	ld	a2,554(a2) # ffffffffc0211528 <pages>
ffffffffc0203306:	85a6                	mv	a1,s1
ffffffffc0203308:	8522                	mv	a0,s0
ffffffffc020330a:	4685                	li	a3,1
ffffffffc020330c:	963e                	add	a2,a2,a5
ffffffffc020330e:	eadff0ef          	jal	ra,ffffffffc02031ba <_lru_map_swappable>
}
ffffffffc0203312:	60e2                	ld	ra,24(sp)
ffffffffc0203314:	6442                	ld	s0,16(sp)
ffffffffc0203316:	0004c503          	lbu	a0,0(s1)
ffffffffc020331a:	64a2                	ld	s1,8(sp)
ffffffffc020331c:	6105                	addi	sp,sp,32
ffffffffc020331e:	8082                	ret
        panic("pa2page called with invalid pa");
ffffffffc0203320:	00002617          	auipc	a2,0x2
ffffffffc0203324:	15860613          	addi	a2,a2,344 # ffffffffc0205478 <default_pmm_manager+0x38>
ffffffffc0203328:	06500593          	li	a1,101
ffffffffc020332c:	00002517          	auipc	a0,0x2
ffffffffc0203330:	16c50513          	addi	a0,a0,364 # ffffffffc0205498 <default_pmm_manager+0x58>
ffffffffc0203334:	840fd0ef          	jal	ra,ffffffffc0200374 <__panic>

ffffffffc0203338 <_lru_check_swap>:
{
ffffffffc0203338:	7179                	addi	sp,sp,-48
    cprintf("write Virt Page c in lru_check_swap\n");
ffffffffc020333a:	00003517          	auipc	a0,0x3
ffffffffc020333e:	b7e50513          	addi	a0,a0,-1154 # ffffffffc0205eb8 <default_pmm_manager+0xa78>
{
ffffffffc0203342:	f406                	sd	ra,40(sp)
ffffffffc0203344:	f022                	sd	s0,32(sp)
ffffffffc0203346:	e44e                	sd	s3,8(sp)
ffffffffc0203348:	ec26                	sd	s1,24(sp)
ffffffffc020334a:	e84a                	sd	s2,16(sp)
    write_page(check_mm_struct, (unsigned char *)0x3000, 0x0c);
ffffffffc020334c:	0000e417          	auipc	s0,0xe
ffffffffc0203350:	20c40413          	addi	s0,s0,524 # ffffffffc0211558 <check_mm_struct>
    cprintf("write Virt Page c in lru_check_swap\n");
ffffffffc0203354:	d67fc0ef          	jal	ra,ffffffffc02000ba <cprintf>
    write_page(check_mm_struct, (unsigned char *)0x3000, 0x0c);
ffffffffc0203358:	6008                	ld	a0,0(s0)
ffffffffc020335a:	4631                	li	a2,12
ffffffffc020335c:	658d                	lui	a1,0x3
ffffffffc020335e:	ec3ff0ef          	jal	ra,ffffffffc0203220 <write_page>
    assert(pgfault_num == 4);
ffffffffc0203362:	4791                	li	a5,4
ffffffffc0203364:	0000e997          	auipc	s3,0xe
ffffffffc0203368:	1fc9a983          	lw	s3,508(s3) # ffffffffc0211560 <pgfault_num>
ffffffffc020336c:	1ef99163          	bne	s3,a5,ffffffffc020354e <_lru_check_swap+0x216>
    cprintf("write Virt Page a in lru_check_swap\n");
ffffffffc0203370:	00003517          	auipc	a0,0x3
ffffffffc0203374:	b8850513          	addi	a0,a0,-1144 # ffffffffc0205ef8 <default_pmm_manager+0xab8>
ffffffffc0203378:	d43fc0ef          	jal	ra,ffffffffc02000ba <cprintf>
    write_page(check_mm_struct, (unsigned char *)0x1000, 0x0a);
ffffffffc020337c:	6008                	ld	a0,0(s0)
ffffffffc020337e:	0000e497          	auipc	s1,0xe
ffffffffc0203382:	1e248493          	addi	s1,s1,482 # ffffffffc0211560 <pgfault_num>
ffffffffc0203386:	4629                	li	a2,10
ffffffffc0203388:	6585                	lui	a1,0x1
ffffffffc020338a:	e97ff0ef          	jal	ra,ffffffffc0203220 <write_page>
    assert(pgfault_num == 4);
ffffffffc020338e:	0004a903          	lw	s2,0(s1)
ffffffffc0203392:	2901                	sext.w	s2,s2
ffffffffc0203394:	3f391d63          	bne	s2,s3,ffffffffc020378e <_lru_check_swap+0x456>
    cprintf("write Virt Page d in lru_check_swap\n");
ffffffffc0203398:	00003517          	auipc	a0,0x3
ffffffffc020339c:	b8850513          	addi	a0,a0,-1144 # ffffffffc0205f20 <default_pmm_manager+0xae0>
ffffffffc02033a0:	d1bfc0ef          	jal	ra,ffffffffc02000ba <cprintf>
    write_page(check_mm_struct, (unsigned char *)0x4000, 0x0d);
ffffffffc02033a4:	6008                	ld	a0,0(s0)
ffffffffc02033a6:	4635                	li	a2,13
ffffffffc02033a8:	6591                	lui	a1,0x4
ffffffffc02033aa:	e77ff0ef          	jal	ra,ffffffffc0203220 <write_page>
    assert(pgfault_num == 4);
ffffffffc02033ae:	0004a983          	lw	s3,0(s1)
ffffffffc02033b2:	2981                	sext.w	s3,s3
ffffffffc02033b4:	3b299d63          	bne	s3,s2,ffffffffc020376e <_lru_check_swap+0x436>
    cprintf("write Virt Page b in lru_check_swap\n");
ffffffffc02033b8:	00003517          	auipc	a0,0x3
ffffffffc02033bc:	b9050513          	addi	a0,a0,-1136 # ffffffffc0205f48 <default_pmm_manager+0xb08>
ffffffffc02033c0:	cfbfc0ef          	jal	ra,ffffffffc02000ba <cprintf>
    write_page(check_mm_struct, (unsigned char *)0x2000, 0x0b);
ffffffffc02033c4:	6008                	ld	a0,0(s0)
ffffffffc02033c6:	462d                	li	a2,11
ffffffffc02033c8:	6589                	lui	a1,0x2
ffffffffc02033ca:	e57ff0ef          	jal	ra,ffffffffc0203220 <write_page>
    assert(pgfault_num == 4);
ffffffffc02033ce:	409c                	lw	a5,0(s1)
ffffffffc02033d0:	2781                	sext.w	a5,a5
ffffffffc02033d2:	37379e63          	bne	a5,s3,ffffffffc020374e <_lru_check_swap+0x416>
    cprintf("write Virt Page e in lru_check_swap\n");
ffffffffc02033d6:	00003517          	auipc	a0,0x3
ffffffffc02033da:	b9a50513          	addi	a0,a0,-1126 # ffffffffc0205f70 <default_pmm_manager+0xb30>
ffffffffc02033de:	cddfc0ef          	jal	ra,ffffffffc02000ba <cprintf>
    write_page(check_mm_struct, (unsigned char *)0x5000, 0x0e);
ffffffffc02033e2:	6008                	ld	a0,0(s0)
ffffffffc02033e4:	4639                	li	a2,14
ffffffffc02033e6:	6595                	lui	a1,0x5
ffffffffc02033e8:	e39ff0ef          	jal	ra,ffffffffc0203220 <write_page>
    assert(pgfault_num == 5); // 替换3
ffffffffc02033ec:	0004a903          	lw	s2,0(s1)
ffffffffc02033f0:	4795                	li	a5,5
ffffffffc02033f2:	2901                	sext.w	s2,s2
ffffffffc02033f4:	32f91d63          	bne	s2,a5,ffffffffc020372e <_lru_check_swap+0x3f6>
    cprintf("write Virt Page b in lru_check_swap\n");
ffffffffc02033f8:	00003517          	auipc	a0,0x3
ffffffffc02033fc:	b5050513          	addi	a0,a0,-1200 # ffffffffc0205f48 <default_pmm_manager+0xb08>
ffffffffc0203400:	cbbfc0ef          	jal	ra,ffffffffc02000ba <cprintf>
    write_page(check_mm_struct, (unsigned char *)0x2000, 0x0b);
ffffffffc0203404:	6008                	ld	a0,0(s0)
ffffffffc0203406:	462d                	li	a2,11
ffffffffc0203408:	6589                	lui	a1,0x2
ffffffffc020340a:	e17ff0ef          	jal	ra,ffffffffc0203220 <write_page>
    assert(pgfault_num == 5);
ffffffffc020340e:	0004a983          	lw	s3,0(s1)
ffffffffc0203412:	2981                	sext.w	s3,s3
ffffffffc0203414:	2f299d63          	bne	s3,s2,ffffffffc020370e <_lru_check_swap+0x3d6>
    cprintf("write Virt Page a in lru_check_swap\n");
ffffffffc0203418:	00003517          	auipc	a0,0x3
ffffffffc020341c:	ae050513          	addi	a0,a0,-1312 # ffffffffc0205ef8 <default_pmm_manager+0xab8>
ffffffffc0203420:	c9bfc0ef          	jal	ra,ffffffffc02000ba <cprintf>
    write_page(check_mm_struct, (unsigned char *)0x1000, 0x0a);
ffffffffc0203424:	6008                	ld	a0,0(s0)
ffffffffc0203426:	4629                	li	a2,10
ffffffffc0203428:	6585                	lui	a1,0x1
ffffffffc020342a:	df7ff0ef          	jal	ra,ffffffffc0203220 <write_page>
    assert(pgfault_num == 5);
ffffffffc020342e:	409c                	lw	a5,0(s1)
ffffffffc0203430:	2781                	sext.w	a5,a5
ffffffffc0203432:	2b379e63          	bne	a5,s3,ffffffffc02036ee <_lru_check_swap+0x3b6>
    cprintf("write Virt Page c in lru_check_swap\n");
ffffffffc0203436:	00003517          	auipc	a0,0x3
ffffffffc020343a:	a8250513          	addi	a0,a0,-1406 # ffffffffc0205eb8 <default_pmm_manager+0xa78>
ffffffffc020343e:	c7dfc0ef          	jal	ra,ffffffffc02000ba <cprintf>
    write_page(check_mm_struct, (unsigned char *)0x3000, 0x0c);
ffffffffc0203442:	6008                	ld	a0,0(s0)
ffffffffc0203444:	4631                	li	a2,12
ffffffffc0203446:	658d                	lui	a1,0x3
ffffffffc0203448:	dd9ff0ef          	jal	ra,ffffffffc0203220 <write_page>
    assert(pgfault_num == 6); // 替换4
ffffffffc020344c:	409c                	lw	a5,0(s1)
ffffffffc020344e:	4719                	li	a4,6
ffffffffc0203450:	2781                	sext.w	a5,a5
ffffffffc0203452:	26e79e63          	bne	a5,a4,ffffffffc02036ce <_lru_check_swap+0x396>
    cprintf("write Virt Page d in lru_check_swap\n");
ffffffffc0203456:	00003517          	auipc	a0,0x3
ffffffffc020345a:	aca50513          	addi	a0,a0,-1334 # ffffffffc0205f20 <default_pmm_manager+0xae0>
ffffffffc020345e:	c5dfc0ef          	jal	ra,ffffffffc02000ba <cprintf>
    write_page(check_mm_struct, (unsigned char *)0x4000, 0x0d);
ffffffffc0203462:	6008                	ld	a0,0(s0)
ffffffffc0203464:	4635                	li	a2,13
ffffffffc0203466:	6591                	lui	a1,0x4
ffffffffc0203468:	db9ff0ef          	jal	ra,ffffffffc0203220 <write_page>
    assert(pgfault_num == 7); // 替换5
ffffffffc020346c:	0004a903          	lw	s2,0(s1)
ffffffffc0203470:	479d                	li	a5,7
ffffffffc0203472:	2901                	sext.w	s2,s2
ffffffffc0203474:	22f91d63          	bne	s2,a5,ffffffffc02036ae <_lru_check_swap+0x376>
    cprintf("write Virt Page b in lru_check_swap\n");
ffffffffc0203478:	00003517          	auipc	a0,0x3
ffffffffc020347c:	ad050513          	addi	a0,a0,-1328 # ffffffffc0205f48 <default_pmm_manager+0xb08>
ffffffffc0203480:	c3bfc0ef          	jal	ra,ffffffffc02000ba <cprintf>
    write_page(check_mm_struct, (unsigned char *)0x2000, 0x0b);
ffffffffc0203484:	6008                	ld	a0,0(s0)
ffffffffc0203486:	462d                	li	a2,11
ffffffffc0203488:	6589                	lui	a1,0x2
ffffffffc020348a:	d97ff0ef          	jal	ra,ffffffffc0203220 <write_page>
    assert(pgfault_num == 7);
ffffffffc020348e:	409c                	lw	a5,0(s1)
ffffffffc0203490:	2781                	sext.w	a5,a5
ffffffffc0203492:	1f279e63          	bne	a5,s2,ffffffffc020368e <_lru_check_swap+0x356>
    cprintf("write Virt Page e in lru_check_swap\n");
ffffffffc0203496:	00003517          	auipc	a0,0x3
ffffffffc020349a:	ada50513          	addi	a0,a0,-1318 # ffffffffc0205f70 <default_pmm_manager+0xb30>
ffffffffc020349e:	c1dfc0ef          	jal	ra,ffffffffc02000ba <cprintf>
    write_page(check_mm_struct, (unsigned char *)0x5000, 0x0e);
ffffffffc02034a2:	6008                	ld	a0,0(s0)
ffffffffc02034a4:	4639                	li	a2,14
ffffffffc02034a6:	6595                	lui	a1,0x5
ffffffffc02034a8:	d79ff0ef          	jal	ra,ffffffffc0203220 <write_page>
    assert(pgfault_num == 8); // 替换 1
ffffffffc02034ac:	409c                	lw	a5,0(s1)
ffffffffc02034ae:	4721                	li	a4,8
ffffffffc02034b0:	2781                	sext.w	a5,a5
ffffffffc02034b2:	1ae79e63          	bne	a5,a4,ffffffffc020366e <_lru_check_swap+0x336>
    cprintf("write Virt Page a in lru_check_swap\n");
ffffffffc02034b6:	00003517          	auipc	a0,0x3
ffffffffc02034ba:	a4250513          	addi	a0,a0,-1470 # ffffffffc0205ef8 <default_pmm_manager+0xab8>
ffffffffc02034be:	bfdfc0ef          	jal	ra,ffffffffc02000ba <cprintf>
    write_page(check_mm_struct, (unsigned char *)0x1000, 0x0a);
ffffffffc02034c2:	6008                	ld	a0,0(s0)
ffffffffc02034c4:	4629                	li	a2,10
ffffffffc02034c6:	6585                	lui	a1,0x1
ffffffffc02034c8:	d59ff0ef          	jal	ra,ffffffffc0203220 <write_page>
    assert(pgfault_num == 9); // 替换3
ffffffffc02034cc:	409c                	lw	a5,0(s1)
ffffffffc02034ce:	4725                	li	a4,9
ffffffffc02034d0:	2781                	sext.w	a5,a5
ffffffffc02034d2:	16e79e63          	bne	a5,a4,ffffffffc020364e <_lru_check_swap+0x316>
    assert(read_page(check_mm_struct, (unsigned char *)0x3000) == 0x0c);
ffffffffc02034d6:	6008                	ld	a0,0(s0)
ffffffffc02034d8:	658d                	lui	a1,0x3
ffffffffc02034da:	dd7ff0ef          	jal	ra,ffffffffc02032b0 <read_page>
ffffffffc02034de:	47b1                	li	a5,12
ffffffffc02034e0:	14f51763          	bne	a0,a5,ffffffffc020362e <_lru_check_swap+0x2f6>
    assert(pgfault_num == 10); // 替换4
ffffffffc02034e4:	0004a903          	lw	s2,0(s1)
ffffffffc02034e8:	47a9                	li	a5,10
ffffffffc02034ea:	2901                	sext.w	s2,s2
ffffffffc02034ec:	12f91163          	bne	s2,a5,ffffffffc020360e <_lru_check_swap+0x2d6>
    assert(read_page(check_mm_struct, (unsigned char *)0x2000) == 0x0b);
ffffffffc02034f0:	6008                	ld	a0,0(s0)
ffffffffc02034f2:	6589                	lui	a1,0x2
ffffffffc02034f4:	dbdff0ef          	jal	ra,ffffffffc02032b0 <read_page>
ffffffffc02034f8:	47ad                	li	a5,11
ffffffffc02034fa:	89aa                	mv	s3,a0
ffffffffc02034fc:	0ef51963          	bne	a0,a5,ffffffffc02035ee <_lru_check_swap+0x2b6>
    assert(pgfault_num == 10);
ffffffffc0203500:	409c                	lw	a5,0(s1)
ffffffffc0203502:	2781                	sext.w	a5,a5
ffffffffc0203504:	0d279563          	bne	a5,s2,ffffffffc02035ce <_lru_check_swap+0x296>
    assert(read_page(check_mm_struct, (unsigned char *)0x4000) == 0x0d);
ffffffffc0203508:	6008                	ld	a0,0(s0)
ffffffffc020350a:	6591                	lui	a1,0x4
ffffffffc020350c:	da5ff0ef          	jal	ra,ffffffffc02032b0 <read_page>
ffffffffc0203510:	47b5                	li	a5,13
ffffffffc0203512:	08f51e63          	bne	a0,a5,ffffffffc02035ae <_lru_check_swap+0x276>
    assert(pgfault_num == 11); // 替换5
ffffffffc0203516:	0004a903          	lw	s2,0(s1)
ffffffffc020351a:	2901                	sext.w	s2,s2
ffffffffc020351c:	07391963          	bne	s2,s3,ffffffffc020358e <_lru_check_swap+0x256>
    cprintf("write Virt Page a in lru_check_swap\n");
ffffffffc0203520:	00003517          	auipc	a0,0x3
ffffffffc0203524:	9d850513          	addi	a0,a0,-1576 # ffffffffc0205ef8 <default_pmm_manager+0xab8>
ffffffffc0203528:	b93fc0ef          	jal	ra,ffffffffc02000ba <cprintf>
    write_page(check_mm_struct, (unsigned char *)0x1000, 0x0a);
ffffffffc020352c:	6008                	ld	a0,0(s0)
ffffffffc020352e:	4629                	li	a2,10
ffffffffc0203530:	6585                	lui	a1,0x1
ffffffffc0203532:	cefff0ef          	jal	ra,ffffffffc0203220 <write_page>
    assert(pgfault_num == 11);
ffffffffc0203536:	409c                	lw	a5,0(s1)
ffffffffc0203538:	2781                	sext.w	a5,a5
ffffffffc020353a:	03279a63          	bne	a5,s2,ffffffffc020356e <_lru_check_swap+0x236>
}
ffffffffc020353e:	70a2                	ld	ra,40(sp)
ffffffffc0203540:	7402                	ld	s0,32(sp)
ffffffffc0203542:	64e2                	ld	s1,24(sp)
ffffffffc0203544:	6942                	ld	s2,16(sp)
ffffffffc0203546:	69a2                	ld	s3,8(sp)
ffffffffc0203548:	4501                	li	a0,0
ffffffffc020354a:	6145                	addi	sp,sp,48
ffffffffc020354c:	8082                	ret
    assert(pgfault_num == 4);
ffffffffc020354e:	00003697          	auipc	a3,0x3
ffffffffc0203552:	99268693          	addi	a3,a3,-1646 # ffffffffc0205ee0 <default_pmm_manager+0xaa0>
ffffffffc0203556:	00002617          	auipc	a2,0x2
ffffffffc020355a:	b3a60613          	addi	a2,a2,-1222 # ffffffffc0205090 <commands+0x738>
ffffffffc020355e:	05d00593          	li	a1,93
ffffffffc0203562:	00003517          	auipc	a0,0x3
ffffffffc0203566:	90e50513          	addi	a0,a0,-1778 # ffffffffc0205e70 <default_pmm_manager+0xa30>
ffffffffc020356a:	e0bfc0ef          	jal	ra,ffffffffc0200374 <__panic>
    assert(pgfault_num == 11);
ffffffffc020356e:	00003697          	auipc	a3,0x3
ffffffffc0203572:	b7a68693          	addi	a3,a3,-1158 # ffffffffc02060e8 <default_pmm_manager+0xca8>
ffffffffc0203576:	00002617          	auipc	a2,0x2
ffffffffc020357a:	b1a60613          	addi	a2,a2,-1254 # ffffffffc0205090 <commands+0x738>
ffffffffc020357e:	08800593          	li	a1,136
ffffffffc0203582:	00003517          	auipc	a0,0x3
ffffffffc0203586:	8ee50513          	addi	a0,a0,-1810 # ffffffffc0205e70 <default_pmm_manager+0xa30>
ffffffffc020358a:	debfc0ef          	jal	ra,ffffffffc0200374 <__panic>
    assert(pgfault_num == 11); // 替换5
ffffffffc020358e:	00003697          	auipc	a3,0x3
ffffffffc0203592:	b5a68693          	addi	a3,a3,-1190 # ffffffffc02060e8 <default_pmm_manager+0xca8>
ffffffffc0203596:	00002617          	auipc	a2,0x2
ffffffffc020359a:	afa60613          	addi	a2,a2,-1286 # ffffffffc0205090 <commands+0x738>
ffffffffc020359e:	08500593          	li	a1,133
ffffffffc02035a2:	00003517          	auipc	a0,0x3
ffffffffc02035a6:	8ce50513          	addi	a0,a0,-1842 # ffffffffc0205e70 <default_pmm_manager+0xa30>
ffffffffc02035aa:	dcbfc0ef          	jal	ra,ffffffffc0200374 <__panic>
    assert(read_page(check_mm_struct, (unsigned char *)0x4000) == 0x0d);
ffffffffc02035ae:	00003697          	auipc	a3,0x3
ffffffffc02035b2:	afa68693          	addi	a3,a3,-1286 # ffffffffc02060a8 <default_pmm_manager+0xc68>
ffffffffc02035b6:	00002617          	auipc	a2,0x2
ffffffffc02035ba:	ada60613          	addi	a2,a2,-1318 # ffffffffc0205090 <commands+0x738>
ffffffffc02035be:	08400593          	li	a1,132
ffffffffc02035c2:	00003517          	auipc	a0,0x3
ffffffffc02035c6:	8ae50513          	addi	a0,a0,-1874 # ffffffffc0205e70 <default_pmm_manager+0xa30>
ffffffffc02035ca:	dabfc0ef          	jal	ra,ffffffffc0200374 <__panic>
    assert(pgfault_num == 10);
ffffffffc02035ce:	00003697          	auipc	a3,0x3
ffffffffc02035d2:	a8268693          	addi	a3,a3,-1406 # ffffffffc0206050 <default_pmm_manager+0xc10>
ffffffffc02035d6:	00002617          	auipc	a2,0x2
ffffffffc02035da:	aba60613          	addi	a2,a2,-1350 # ffffffffc0205090 <commands+0x738>
ffffffffc02035de:	08300593          	li	a1,131
ffffffffc02035e2:	00003517          	auipc	a0,0x3
ffffffffc02035e6:	88e50513          	addi	a0,a0,-1906 # ffffffffc0205e70 <default_pmm_manager+0xa30>
ffffffffc02035ea:	d8bfc0ef          	jal	ra,ffffffffc0200374 <__panic>
    assert(read_page(check_mm_struct, (unsigned char *)0x2000) == 0x0b);
ffffffffc02035ee:	00003697          	auipc	a3,0x3
ffffffffc02035f2:	a7a68693          	addi	a3,a3,-1414 # ffffffffc0206068 <default_pmm_manager+0xc28>
ffffffffc02035f6:	00002617          	auipc	a2,0x2
ffffffffc02035fa:	a9a60613          	addi	a2,a2,-1382 # ffffffffc0205090 <commands+0x738>
ffffffffc02035fe:	08200593          	li	a1,130
ffffffffc0203602:	00003517          	auipc	a0,0x3
ffffffffc0203606:	86e50513          	addi	a0,a0,-1938 # ffffffffc0205e70 <default_pmm_manager+0xa30>
ffffffffc020360a:	d6bfc0ef          	jal	ra,ffffffffc0200374 <__panic>
    assert(pgfault_num == 10); // 替换4
ffffffffc020360e:	00003697          	auipc	a3,0x3
ffffffffc0203612:	a4268693          	addi	a3,a3,-1470 # ffffffffc0206050 <default_pmm_manager+0xc10>
ffffffffc0203616:	00002617          	auipc	a2,0x2
ffffffffc020361a:	a7a60613          	addi	a2,a2,-1414 # ffffffffc0205090 <commands+0x738>
ffffffffc020361e:	08100593          	li	a1,129
ffffffffc0203622:	00003517          	auipc	a0,0x3
ffffffffc0203626:	84e50513          	addi	a0,a0,-1970 # ffffffffc0205e70 <default_pmm_manager+0xa30>
ffffffffc020362a:	d4bfc0ef          	jal	ra,ffffffffc0200374 <__panic>
    assert(read_page(check_mm_struct, (unsigned char *)0x3000) == 0x0c);
ffffffffc020362e:	00003697          	auipc	a3,0x3
ffffffffc0203632:	9e268693          	addi	a3,a3,-1566 # ffffffffc0206010 <default_pmm_manager+0xbd0>
ffffffffc0203636:	00002617          	auipc	a2,0x2
ffffffffc020363a:	a5a60613          	addi	a2,a2,-1446 # ffffffffc0205090 <commands+0x738>
ffffffffc020363e:	08000593          	li	a1,128
ffffffffc0203642:	00003517          	auipc	a0,0x3
ffffffffc0203646:	82e50513          	addi	a0,a0,-2002 # ffffffffc0205e70 <default_pmm_manager+0xa30>
ffffffffc020364a:	d2bfc0ef          	jal	ra,ffffffffc0200374 <__panic>
    assert(pgfault_num == 9); // 替换3
ffffffffc020364e:	00003697          	auipc	a3,0x3
ffffffffc0203652:	9aa68693          	addi	a3,a3,-1622 # ffffffffc0205ff8 <default_pmm_manager+0xbb8>
ffffffffc0203656:	00002617          	auipc	a2,0x2
ffffffffc020365a:	a3a60613          	addi	a2,a2,-1478 # ffffffffc0205090 <commands+0x738>
ffffffffc020365e:	07e00593          	li	a1,126
ffffffffc0203662:	00003517          	auipc	a0,0x3
ffffffffc0203666:	80e50513          	addi	a0,a0,-2034 # ffffffffc0205e70 <default_pmm_manager+0xa30>
ffffffffc020366a:	d0bfc0ef          	jal	ra,ffffffffc0200374 <__panic>
    assert(pgfault_num == 8); // 替换 1
ffffffffc020366e:	00003697          	auipc	a3,0x3
ffffffffc0203672:	97268693          	addi	a3,a3,-1678 # ffffffffc0205fe0 <default_pmm_manager+0xba0>
ffffffffc0203676:	00002617          	auipc	a2,0x2
ffffffffc020367a:	a1a60613          	addi	a2,a2,-1510 # ffffffffc0205090 <commands+0x738>
ffffffffc020367e:	07b00593          	li	a1,123
ffffffffc0203682:	00002517          	auipc	a0,0x2
ffffffffc0203686:	7ee50513          	addi	a0,a0,2030 # ffffffffc0205e70 <default_pmm_manager+0xa30>
ffffffffc020368a:	cebfc0ef          	jal	ra,ffffffffc0200374 <__panic>
    assert(pgfault_num == 7);
ffffffffc020368e:	00003697          	auipc	a3,0x3
ffffffffc0203692:	93a68693          	addi	a3,a3,-1734 # ffffffffc0205fc8 <default_pmm_manager+0xb88>
ffffffffc0203696:	00002617          	auipc	a2,0x2
ffffffffc020369a:	9fa60613          	addi	a2,a2,-1542 # ffffffffc0205090 <commands+0x738>
ffffffffc020369e:	07800593          	li	a1,120
ffffffffc02036a2:	00002517          	auipc	a0,0x2
ffffffffc02036a6:	7ce50513          	addi	a0,a0,1998 # ffffffffc0205e70 <default_pmm_manager+0xa30>
ffffffffc02036aa:	ccbfc0ef          	jal	ra,ffffffffc0200374 <__panic>
    assert(pgfault_num == 7); // 替换5
ffffffffc02036ae:	00003697          	auipc	a3,0x3
ffffffffc02036b2:	91a68693          	addi	a3,a3,-1766 # ffffffffc0205fc8 <default_pmm_manager+0xb88>
ffffffffc02036b6:	00002617          	auipc	a2,0x2
ffffffffc02036ba:	9da60613          	addi	a2,a2,-1574 # ffffffffc0205090 <commands+0x738>
ffffffffc02036be:	07500593          	li	a1,117
ffffffffc02036c2:	00002517          	auipc	a0,0x2
ffffffffc02036c6:	7ae50513          	addi	a0,a0,1966 # ffffffffc0205e70 <default_pmm_manager+0xa30>
ffffffffc02036ca:	cabfc0ef          	jal	ra,ffffffffc0200374 <__panic>
    assert(pgfault_num == 6); // 替换4
ffffffffc02036ce:	00003697          	auipc	a3,0x3
ffffffffc02036d2:	8e268693          	addi	a3,a3,-1822 # ffffffffc0205fb0 <default_pmm_manager+0xb70>
ffffffffc02036d6:	00002617          	auipc	a2,0x2
ffffffffc02036da:	9ba60613          	addi	a2,a2,-1606 # ffffffffc0205090 <commands+0x738>
ffffffffc02036de:	07200593          	li	a1,114
ffffffffc02036e2:	00002517          	auipc	a0,0x2
ffffffffc02036e6:	78e50513          	addi	a0,a0,1934 # ffffffffc0205e70 <default_pmm_manager+0xa30>
ffffffffc02036ea:	c8bfc0ef          	jal	ra,ffffffffc0200374 <__panic>
    assert(pgfault_num == 5);
ffffffffc02036ee:	00003697          	auipc	a3,0x3
ffffffffc02036f2:	8aa68693          	addi	a3,a3,-1878 # ffffffffc0205f98 <default_pmm_manager+0xb58>
ffffffffc02036f6:	00002617          	auipc	a2,0x2
ffffffffc02036fa:	99a60613          	addi	a2,a2,-1638 # ffffffffc0205090 <commands+0x738>
ffffffffc02036fe:	06f00593          	li	a1,111
ffffffffc0203702:	00002517          	auipc	a0,0x2
ffffffffc0203706:	76e50513          	addi	a0,a0,1902 # ffffffffc0205e70 <default_pmm_manager+0xa30>
ffffffffc020370a:	c6bfc0ef          	jal	ra,ffffffffc0200374 <__panic>
    assert(pgfault_num == 5);
ffffffffc020370e:	00003697          	auipc	a3,0x3
ffffffffc0203712:	88a68693          	addi	a3,a3,-1910 # ffffffffc0205f98 <default_pmm_manager+0xb58>
ffffffffc0203716:	00002617          	auipc	a2,0x2
ffffffffc020371a:	97a60613          	addi	a2,a2,-1670 # ffffffffc0205090 <commands+0x738>
ffffffffc020371e:	06c00593          	li	a1,108
ffffffffc0203722:	00002517          	auipc	a0,0x2
ffffffffc0203726:	74e50513          	addi	a0,a0,1870 # ffffffffc0205e70 <default_pmm_manager+0xa30>
ffffffffc020372a:	c4bfc0ef          	jal	ra,ffffffffc0200374 <__panic>
    assert(pgfault_num == 5); // 替换3
ffffffffc020372e:	00003697          	auipc	a3,0x3
ffffffffc0203732:	86a68693          	addi	a3,a3,-1942 # ffffffffc0205f98 <default_pmm_manager+0xb58>
ffffffffc0203736:	00002617          	auipc	a2,0x2
ffffffffc020373a:	95a60613          	addi	a2,a2,-1702 # ffffffffc0205090 <commands+0x738>
ffffffffc020373e:	06900593          	li	a1,105
ffffffffc0203742:	00002517          	auipc	a0,0x2
ffffffffc0203746:	72e50513          	addi	a0,a0,1838 # ffffffffc0205e70 <default_pmm_manager+0xa30>
ffffffffc020374a:	c2bfc0ef          	jal	ra,ffffffffc0200374 <__panic>
    assert(pgfault_num == 4);
ffffffffc020374e:	00002697          	auipc	a3,0x2
ffffffffc0203752:	79268693          	addi	a3,a3,1938 # ffffffffc0205ee0 <default_pmm_manager+0xaa0>
ffffffffc0203756:	00002617          	auipc	a2,0x2
ffffffffc020375a:	93a60613          	addi	a2,a2,-1734 # ffffffffc0205090 <commands+0x738>
ffffffffc020375e:	06600593          	li	a1,102
ffffffffc0203762:	00002517          	auipc	a0,0x2
ffffffffc0203766:	70e50513          	addi	a0,a0,1806 # ffffffffc0205e70 <default_pmm_manager+0xa30>
ffffffffc020376a:	c0bfc0ef          	jal	ra,ffffffffc0200374 <__panic>
    assert(pgfault_num == 4);
ffffffffc020376e:	00002697          	auipc	a3,0x2
ffffffffc0203772:	77268693          	addi	a3,a3,1906 # ffffffffc0205ee0 <default_pmm_manager+0xaa0>
ffffffffc0203776:	00002617          	auipc	a2,0x2
ffffffffc020377a:	91a60613          	addi	a2,a2,-1766 # ffffffffc0205090 <commands+0x738>
ffffffffc020377e:	06300593          	li	a1,99
ffffffffc0203782:	00002517          	auipc	a0,0x2
ffffffffc0203786:	6ee50513          	addi	a0,a0,1774 # ffffffffc0205e70 <default_pmm_manager+0xa30>
ffffffffc020378a:	bebfc0ef          	jal	ra,ffffffffc0200374 <__panic>
    assert(pgfault_num == 4);
ffffffffc020378e:	00002697          	auipc	a3,0x2
ffffffffc0203792:	75268693          	addi	a3,a3,1874 # ffffffffc0205ee0 <default_pmm_manager+0xaa0>
ffffffffc0203796:	00002617          	auipc	a2,0x2
ffffffffc020379a:	8fa60613          	addi	a2,a2,-1798 # ffffffffc0205090 <commands+0x738>
ffffffffc020379e:	06000593          	li	a1,96
ffffffffc02037a2:	00002517          	auipc	a0,0x2
ffffffffc02037a6:	6ce50513          	addi	a0,a0,1742 # ffffffffc0205e70 <default_pmm_manager+0xa30>
ffffffffc02037aa:	bcbfc0ef          	jal	ra,ffffffffc0200374 <__panic>

ffffffffc02037ae <check_vma_overlap.part.0>:
ffffffffc02037ae:	1141                	addi	sp,sp,-16
ffffffffc02037b0:	00003697          	auipc	a3,0x3
ffffffffc02037b4:	96868693          	addi	a3,a3,-1688 # ffffffffc0206118 <default_pmm_manager+0xcd8>
ffffffffc02037b8:	00002617          	auipc	a2,0x2
ffffffffc02037bc:	8d860613          	addi	a2,a2,-1832 # ffffffffc0205090 <commands+0x738>
ffffffffc02037c0:	07d00593          	li	a1,125
ffffffffc02037c4:	00003517          	auipc	a0,0x3
ffffffffc02037c8:	97450513          	addi	a0,a0,-1676 # ffffffffc0206138 <default_pmm_manager+0xcf8>
ffffffffc02037cc:	e406                	sd	ra,8(sp)
ffffffffc02037ce:	ba7fc0ef          	jal	ra,ffffffffc0200374 <__panic>

ffffffffc02037d2 <mm_create>:
ffffffffc02037d2:	1141                	addi	sp,sp,-16
ffffffffc02037d4:	03000513          	li	a0,48
ffffffffc02037d8:	e022                	sd	s0,0(sp)
ffffffffc02037da:	e406                	sd	ra,8(sp)
ffffffffc02037dc:	f9dfe0ef          	jal	ra,ffffffffc0202778 <kmalloc>
ffffffffc02037e0:	842a                	mv	s0,a0
ffffffffc02037e2:	c105                	beqz	a0,ffffffffc0203802 <mm_create+0x30>
ffffffffc02037e4:	e408                	sd	a0,8(s0)
ffffffffc02037e6:	e008                	sd	a0,0(s0)
ffffffffc02037e8:	00053823          	sd	zero,16(a0)
ffffffffc02037ec:	00053c23          	sd	zero,24(a0)
ffffffffc02037f0:	02052023          	sw	zero,32(a0)
ffffffffc02037f4:	0000e797          	auipc	a5,0xe
ffffffffc02037f8:	d5c7a783          	lw	a5,-676(a5) # ffffffffc0211550 <swap_init_ok>
ffffffffc02037fc:	eb81                	bnez	a5,ffffffffc020380c <mm_create+0x3a>
ffffffffc02037fe:	02053423          	sd	zero,40(a0)
ffffffffc0203802:	60a2                	ld	ra,8(sp)
ffffffffc0203804:	8522                	mv	a0,s0
ffffffffc0203806:	6402                	ld	s0,0(sp)
ffffffffc0203808:	0141                	addi	sp,sp,16
ffffffffc020380a:	8082                	ret
ffffffffc020380c:	f78ff0ef          	jal	ra,ffffffffc0202f84 <swap_init_mm>
ffffffffc0203810:	60a2                	ld	ra,8(sp)
ffffffffc0203812:	8522                	mv	a0,s0
ffffffffc0203814:	6402                	ld	s0,0(sp)
ffffffffc0203816:	0141                	addi	sp,sp,16
ffffffffc0203818:	8082                	ret

ffffffffc020381a <vma_create>:
ffffffffc020381a:	1101                	addi	sp,sp,-32
ffffffffc020381c:	e04a                	sd	s2,0(sp)
ffffffffc020381e:	892a                	mv	s2,a0
ffffffffc0203820:	03000513          	li	a0,48
ffffffffc0203824:	e822                	sd	s0,16(sp)
ffffffffc0203826:	e426                	sd	s1,8(sp)
ffffffffc0203828:	ec06                	sd	ra,24(sp)
ffffffffc020382a:	84ae                	mv	s1,a1
ffffffffc020382c:	8432                	mv	s0,a2
ffffffffc020382e:	f4bfe0ef          	jal	ra,ffffffffc0202778 <kmalloc>
ffffffffc0203832:	c509                	beqz	a0,ffffffffc020383c <vma_create+0x22>
ffffffffc0203834:	01253423          	sd	s2,8(a0)
ffffffffc0203838:	e904                	sd	s1,16(a0)
ffffffffc020383a:	ed00                	sd	s0,24(a0)
ffffffffc020383c:	60e2                	ld	ra,24(sp)
ffffffffc020383e:	6442                	ld	s0,16(sp)
ffffffffc0203840:	64a2                	ld	s1,8(sp)
ffffffffc0203842:	6902                	ld	s2,0(sp)
ffffffffc0203844:	6105                	addi	sp,sp,32
ffffffffc0203846:	8082                	ret

ffffffffc0203848 <find_vma>:
ffffffffc0203848:	86aa                	mv	a3,a0
ffffffffc020384a:	c505                	beqz	a0,ffffffffc0203872 <find_vma+0x2a>
ffffffffc020384c:	6908                	ld	a0,16(a0)
ffffffffc020384e:	c501                	beqz	a0,ffffffffc0203856 <find_vma+0xe>
ffffffffc0203850:	651c                	ld	a5,8(a0)
ffffffffc0203852:	02f5f263          	bgeu	a1,a5,ffffffffc0203876 <find_vma+0x2e>
ffffffffc0203856:	669c                	ld	a5,8(a3)
ffffffffc0203858:	00f68d63          	beq	a3,a5,ffffffffc0203872 <find_vma+0x2a>
ffffffffc020385c:	fe87b703          	ld	a4,-24(a5)
ffffffffc0203860:	00e5e663          	bltu	a1,a4,ffffffffc020386c <find_vma+0x24>
ffffffffc0203864:	ff07b703          	ld	a4,-16(a5)
ffffffffc0203868:	00e5ec63          	bltu	a1,a4,ffffffffc0203880 <find_vma+0x38>
ffffffffc020386c:	679c                	ld	a5,8(a5)
ffffffffc020386e:	fef697e3          	bne	a3,a5,ffffffffc020385c <find_vma+0x14>
ffffffffc0203872:	4501                	li	a0,0
ffffffffc0203874:	8082                	ret
ffffffffc0203876:	691c                	ld	a5,16(a0)
ffffffffc0203878:	fcf5ffe3          	bgeu	a1,a5,ffffffffc0203856 <find_vma+0xe>
ffffffffc020387c:	ea88                	sd	a0,16(a3)
ffffffffc020387e:	8082                	ret
ffffffffc0203880:	fe078513          	addi	a0,a5,-32
ffffffffc0203884:	ea88                	sd	a0,16(a3)
ffffffffc0203886:	8082                	ret

ffffffffc0203888 <insert_vma_struct>:
ffffffffc0203888:	6590                	ld	a2,8(a1)
ffffffffc020388a:	0105b803          	ld	a6,16(a1) # 1010 <kern_entry-0xffffffffc01feff0>
ffffffffc020388e:	1141                	addi	sp,sp,-16
ffffffffc0203890:	e406                	sd	ra,8(sp)
ffffffffc0203892:	87aa                	mv	a5,a0
ffffffffc0203894:	01066763          	bltu	a2,a6,ffffffffc02038a2 <insert_vma_struct+0x1a>
ffffffffc0203898:	a085                	j	ffffffffc02038f8 <insert_vma_struct+0x70>
ffffffffc020389a:	fe87b703          	ld	a4,-24(a5)
ffffffffc020389e:	04e66863          	bltu	a2,a4,ffffffffc02038ee <insert_vma_struct+0x66>
ffffffffc02038a2:	86be                	mv	a3,a5
ffffffffc02038a4:	679c                	ld	a5,8(a5)
ffffffffc02038a6:	fef51ae3          	bne	a0,a5,ffffffffc020389a <insert_vma_struct+0x12>
ffffffffc02038aa:	02a68463          	beq	a3,a0,ffffffffc02038d2 <insert_vma_struct+0x4a>
ffffffffc02038ae:	ff06b703          	ld	a4,-16(a3)
ffffffffc02038b2:	fe86b883          	ld	a7,-24(a3)
ffffffffc02038b6:	08e8f163          	bgeu	a7,a4,ffffffffc0203938 <insert_vma_struct+0xb0>
ffffffffc02038ba:	04e66f63          	bltu	a2,a4,ffffffffc0203918 <insert_vma_struct+0x90>
ffffffffc02038be:	00f50a63          	beq	a0,a5,ffffffffc02038d2 <insert_vma_struct+0x4a>
ffffffffc02038c2:	fe87b703          	ld	a4,-24(a5)
ffffffffc02038c6:	05076963          	bltu	a4,a6,ffffffffc0203918 <insert_vma_struct+0x90>
ffffffffc02038ca:	ff07b603          	ld	a2,-16(a5)
ffffffffc02038ce:	02c77363          	bgeu	a4,a2,ffffffffc02038f4 <insert_vma_struct+0x6c>
ffffffffc02038d2:	5118                	lw	a4,32(a0)
ffffffffc02038d4:	e188                	sd	a0,0(a1)
ffffffffc02038d6:	02058613          	addi	a2,a1,32
ffffffffc02038da:	e390                	sd	a2,0(a5)
ffffffffc02038dc:	e690                	sd	a2,8(a3)
ffffffffc02038de:	60a2                	ld	ra,8(sp)
ffffffffc02038e0:	f59c                	sd	a5,40(a1)
ffffffffc02038e2:	f194                	sd	a3,32(a1)
ffffffffc02038e4:	0017079b          	addiw	a5,a4,1
ffffffffc02038e8:	d11c                	sw	a5,32(a0)
ffffffffc02038ea:	0141                	addi	sp,sp,16
ffffffffc02038ec:	8082                	ret
ffffffffc02038ee:	fca690e3          	bne	a3,a0,ffffffffc02038ae <insert_vma_struct+0x26>
ffffffffc02038f2:	bfd1                	j	ffffffffc02038c6 <insert_vma_struct+0x3e>
ffffffffc02038f4:	ebbff0ef          	jal	ra,ffffffffc02037ae <check_vma_overlap.part.0>
ffffffffc02038f8:	00003697          	auipc	a3,0x3
ffffffffc02038fc:	85068693          	addi	a3,a3,-1968 # ffffffffc0206148 <default_pmm_manager+0xd08>
ffffffffc0203900:	00001617          	auipc	a2,0x1
ffffffffc0203904:	79060613          	addi	a2,a2,1936 # ffffffffc0205090 <commands+0x738>
ffffffffc0203908:	08400593          	li	a1,132
ffffffffc020390c:	00003517          	auipc	a0,0x3
ffffffffc0203910:	82c50513          	addi	a0,a0,-2004 # ffffffffc0206138 <default_pmm_manager+0xcf8>
ffffffffc0203914:	a61fc0ef          	jal	ra,ffffffffc0200374 <__panic>
ffffffffc0203918:	00003697          	auipc	a3,0x3
ffffffffc020391c:	87068693          	addi	a3,a3,-1936 # ffffffffc0206188 <default_pmm_manager+0xd48>
ffffffffc0203920:	00001617          	auipc	a2,0x1
ffffffffc0203924:	77060613          	addi	a2,a2,1904 # ffffffffc0205090 <commands+0x738>
ffffffffc0203928:	07c00593          	li	a1,124
ffffffffc020392c:	00003517          	auipc	a0,0x3
ffffffffc0203930:	80c50513          	addi	a0,a0,-2036 # ffffffffc0206138 <default_pmm_manager+0xcf8>
ffffffffc0203934:	a41fc0ef          	jal	ra,ffffffffc0200374 <__panic>
ffffffffc0203938:	00003697          	auipc	a3,0x3
ffffffffc020393c:	83068693          	addi	a3,a3,-2000 # ffffffffc0206168 <default_pmm_manager+0xd28>
ffffffffc0203940:	00001617          	auipc	a2,0x1
ffffffffc0203944:	75060613          	addi	a2,a2,1872 # ffffffffc0205090 <commands+0x738>
ffffffffc0203948:	07b00593          	li	a1,123
ffffffffc020394c:	00002517          	auipc	a0,0x2
ffffffffc0203950:	7ec50513          	addi	a0,a0,2028 # ffffffffc0206138 <default_pmm_manager+0xcf8>
ffffffffc0203954:	a21fc0ef          	jal	ra,ffffffffc0200374 <__panic>

ffffffffc0203958 <mm_destroy>:
ffffffffc0203958:	1141                	addi	sp,sp,-16
ffffffffc020395a:	e022                	sd	s0,0(sp)
ffffffffc020395c:	842a                	mv	s0,a0
ffffffffc020395e:	6508                	ld	a0,8(a0)
ffffffffc0203960:	e406                	sd	ra,8(sp)
ffffffffc0203962:	00a40e63          	beq	s0,a0,ffffffffc020397e <mm_destroy+0x26>
ffffffffc0203966:	6118                	ld	a4,0(a0)
ffffffffc0203968:	651c                	ld	a5,8(a0)
ffffffffc020396a:	03000593          	li	a1,48
ffffffffc020396e:	1501                	addi	a0,a0,-32
ffffffffc0203970:	e71c                	sd	a5,8(a4)
ffffffffc0203972:	e398                	sd	a4,0(a5)
ffffffffc0203974:	ebffe0ef          	jal	ra,ffffffffc0202832 <kfree>
ffffffffc0203978:	6408                	ld	a0,8(s0)
ffffffffc020397a:	fea416e3          	bne	s0,a0,ffffffffc0203966 <mm_destroy+0xe>
ffffffffc020397e:	8522                	mv	a0,s0
ffffffffc0203980:	6402                	ld	s0,0(sp)
ffffffffc0203982:	60a2                	ld	ra,8(sp)
ffffffffc0203984:	03000593          	li	a1,48
ffffffffc0203988:	0141                	addi	sp,sp,16
ffffffffc020398a:	ea9fe06f          	j	ffffffffc0202832 <kfree>

ffffffffc020398e <vmm_init>:
ffffffffc020398e:	715d                	addi	sp,sp,-80
ffffffffc0203990:	e486                	sd	ra,72(sp)
ffffffffc0203992:	f44e                	sd	s3,40(sp)
ffffffffc0203994:	f052                	sd	s4,32(sp)
ffffffffc0203996:	e0a2                	sd	s0,64(sp)
ffffffffc0203998:	fc26                	sd	s1,56(sp)
ffffffffc020399a:	f84a                	sd	s2,48(sp)
ffffffffc020399c:	ec56                	sd	s5,24(sp)
ffffffffc020399e:	e85a                	sd	s6,16(sp)
ffffffffc02039a0:	e45e                	sd	s7,8(sp)
ffffffffc02039a2:	cf1fd0ef          	jal	ra,ffffffffc0201692 <nr_free_pages>
ffffffffc02039a6:	89aa                	mv	s3,a0
ffffffffc02039a8:	cebfd0ef          	jal	ra,ffffffffc0201692 <nr_free_pages>
ffffffffc02039ac:	8a2a                	mv	s4,a0
ffffffffc02039ae:	03000513          	li	a0,48
ffffffffc02039b2:	dc7fe0ef          	jal	ra,ffffffffc0202778 <kmalloc>
ffffffffc02039b6:	56050863          	beqz	a0,ffffffffc0203f26 <vmm_init+0x598>
ffffffffc02039ba:	e508                	sd	a0,8(a0)
ffffffffc02039bc:	e108                	sd	a0,0(a0)
ffffffffc02039be:	00053823          	sd	zero,16(a0)
ffffffffc02039c2:	00053c23          	sd	zero,24(a0)
ffffffffc02039c6:	02052023          	sw	zero,32(a0)
ffffffffc02039ca:	0000e797          	auipc	a5,0xe
ffffffffc02039ce:	b867a783          	lw	a5,-1146(a5) # ffffffffc0211550 <swap_init_ok>
ffffffffc02039d2:	84aa                	mv	s1,a0
ffffffffc02039d4:	e7b9                	bnez	a5,ffffffffc0203a22 <vmm_init+0x94>
ffffffffc02039d6:	02053423          	sd	zero,40(a0)
ffffffffc02039da:	03200413          	li	s0,50
ffffffffc02039de:	a811                	j	ffffffffc02039f2 <vmm_init+0x64>
ffffffffc02039e0:	e500                	sd	s0,8(a0)
ffffffffc02039e2:	e91c                	sd	a5,16(a0)
ffffffffc02039e4:	00053c23          	sd	zero,24(a0)
ffffffffc02039e8:	146d                	addi	s0,s0,-5
ffffffffc02039ea:	8526                	mv	a0,s1
ffffffffc02039ec:	e9dff0ef          	jal	ra,ffffffffc0203888 <insert_vma_struct>
ffffffffc02039f0:	cc05                	beqz	s0,ffffffffc0203a28 <vmm_init+0x9a>
ffffffffc02039f2:	03000513          	li	a0,48
ffffffffc02039f6:	d83fe0ef          	jal	ra,ffffffffc0202778 <kmalloc>
ffffffffc02039fa:	85aa                	mv	a1,a0
ffffffffc02039fc:	00240793          	addi	a5,s0,2
ffffffffc0203a00:	f165                	bnez	a0,ffffffffc02039e0 <vmm_init+0x52>
ffffffffc0203a02:	00002697          	auipc	a3,0x2
ffffffffc0203a06:	16e68693          	addi	a3,a3,366 # ffffffffc0205b70 <default_pmm_manager+0x730>
ffffffffc0203a0a:	00001617          	auipc	a2,0x1
ffffffffc0203a0e:	68660613          	addi	a2,a2,1670 # ffffffffc0205090 <commands+0x738>
ffffffffc0203a12:	0ce00593          	li	a1,206
ffffffffc0203a16:	00002517          	auipc	a0,0x2
ffffffffc0203a1a:	72250513          	addi	a0,a0,1826 # ffffffffc0206138 <default_pmm_manager+0xcf8>
ffffffffc0203a1e:	957fc0ef          	jal	ra,ffffffffc0200374 <__panic>
ffffffffc0203a22:	d62ff0ef          	jal	ra,ffffffffc0202f84 <swap_init_mm>
ffffffffc0203a26:	bf55                	j	ffffffffc02039da <vmm_init+0x4c>
ffffffffc0203a28:	03700413          	li	s0,55
ffffffffc0203a2c:	1f900913          	li	s2,505
ffffffffc0203a30:	a819                	j	ffffffffc0203a46 <vmm_init+0xb8>
ffffffffc0203a32:	e500                	sd	s0,8(a0)
ffffffffc0203a34:	e91c                	sd	a5,16(a0)
ffffffffc0203a36:	00053c23          	sd	zero,24(a0)
ffffffffc0203a3a:	0415                	addi	s0,s0,5
ffffffffc0203a3c:	8526                	mv	a0,s1
ffffffffc0203a3e:	e4bff0ef          	jal	ra,ffffffffc0203888 <insert_vma_struct>
ffffffffc0203a42:	03240a63          	beq	s0,s2,ffffffffc0203a76 <vmm_init+0xe8>
ffffffffc0203a46:	03000513          	li	a0,48
ffffffffc0203a4a:	d2ffe0ef          	jal	ra,ffffffffc0202778 <kmalloc>
ffffffffc0203a4e:	85aa                	mv	a1,a0
ffffffffc0203a50:	00240793          	addi	a5,s0,2
ffffffffc0203a54:	fd79                	bnez	a0,ffffffffc0203a32 <vmm_init+0xa4>
ffffffffc0203a56:	00002697          	auipc	a3,0x2
ffffffffc0203a5a:	11a68693          	addi	a3,a3,282 # ffffffffc0205b70 <default_pmm_manager+0x730>
ffffffffc0203a5e:	00001617          	auipc	a2,0x1
ffffffffc0203a62:	63260613          	addi	a2,a2,1586 # ffffffffc0205090 <commands+0x738>
ffffffffc0203a66:	0d400593          	li	a1,212
ffffffffc0203a6a:	00002517          	auipc	a0,0x2
ffffffffc0203a6e:	6ce50513          	addi	a0,a0,1742 # ffffffffc0206138 <default_pmm_manager+0xcf8>
ffffffffc0203a72:	903fc0ef          	jal	ra,ffffffffc0200374 <__panic>
ffffffffc0203a76:	649c                	ld	a5,8(s1)
ffffffffc0203a78:	471d                	li	a4,7
ffffffffc0203a7a:	1fb00593          	li	a1,507
ffffffffc0203a7e:	2ef48463          	beq	s1,a5,ffffffffc0203d66 <vmm_init+0x3d8>
ffffffffc0203a82:	fe87b603          	ld	a2,-24(a5)
ffffffffc0203a86:	ffe70693          	addi	a3,a4,-2
ffffffffc0203a8a:	26d61e63          	bne	a2,a3,ffffffffc0203d06 <vmm_init+0x378>
ffffffffc0203a8e:	ff07b683          	ld	a3,-16(a5)
ffffffffc0203a92:	26e69a63          	bne	a3,a4,ffffffffc0203d06 <vmm_init+0x378>
ffffffffc0203a96:	0715                	addi	a4,a4,5
ffffffffc0203a98:	679c                	ld	a5,8(a5)
ffffffffc0203a9a:	feb712e3          	bne	a4,a1,ffffffffc0203a7e <vmm_init+0xf0>
ffffffffc0203a9e:	4b1d                	li	s6,7
ffffffffc0203aa0:	4415                	li	s0,5
ffffffffc0203aa2:	1f900b93          	li	s7,505
ffffffffc0203aa6:	85a2                	mv	a1,s0
ffffffffc0203aa8:	8526                	mv	a0,s1
ffffffffc0203aaa:	d9fff0ef          	jal	ra,ffffffffc0203848 <find_vma>
ffffffffc0203aae:	892a                	mv	s2,a0
ffffffffc0203ab0:	2c050b63          	beqz	a0,ffffffffc0203d86 <vmm_init+0x3f8>
ffffffffc0203ab4:	00140593          	addi	a1,s0,1
ffffffffc0203ab8:	8526                	mv	a0,s1
ffffffffc0203aba:	d8fff0ef          	jal	ra,ffffffffc0203848 <find_vma>
ffffffffc0203abe:	8aaa                	mv	s5,a0
ffffffffc0203ac0:	2e050363          	beqz	a0,ffffffffc0203da6 <vmm_init+0x418>
ffffffffc0203ac4:	85da                	mv	a1,s6
ffffffffc0203ac6:	8526                	mv	a0,s1
ffffffffc0203ac8:	d81ff0ef          	jal	ra,ffffffffc0203848 <find_vma>
ffffffffc0203acc:	2e051d63          	bnez	a0,ffffffffc0203dc6 <vmm_init+0x438>
ffffffffc0203ad0:	00340593          	addi	a1,s0,3
ffffffffc0203ad4:	8526                	mv	a0,s1
ffffffffc0203ad6:	d73ff0ef          	jal	ra,ffffffffc0203848 <find_vma>
ffffffffc0203ada:	30051663          	bnez	a0,ffffffffc0203de6 <vmm_init+0x458>
ffffffffc0203ade:	00440593          	addi	a1,s0,4
ffffffffc0203ae2:	8526                	mv	a0,s1
ffffffffc0203ae4:	d65ff0ef          	jal	ra,ffffffffc0203848 <find_vma>
ffffffffc0203ae8:	30051f63          	bnez	a0,ffffffffc0203e06 <vmm_init+0x478>
ffffffffc0203aec:	00893783          	ld	a5,8(s2)
ffffffffc0203af0:	24879b63          	bne	a5,s0,ffffffffc0203d46 <vmm_init+0x3b8>
ffffffffc0203af4:	01093783          	ld	a5,16(s2)
ffffffffc0203af8:	25679763          	bne	a5,s6,ffffffffc0203d46 <vmm_init+0x3b8>
ffffffffc0203afc:	008ab783          	ld	a5,8(s5)
ffffffffc0203b00:	22879363          	bne	a5,s0,ffffffffc0203d26 <vmm_init+0x398>
ffffffffc0203b04:	010ab783          	ld	a5,16(s5)
ffffffffc0203b08:	21679f63          	bne	a5,s6,ffffffffc0203d26 <vmm_init+0x398>
ffffffffc0203b0c:	0415                	addi	s0,s0,5
ffffffffc0203b0e:	0b15                	addi	s6,s6,5
ffffffffc0203b10:	f9741be3          	bne	s0,s7,ffffffffc0203aa6 <vmm_init+0x118>
ffffffffc0203b14:	4411                	li	s0,4
ffffffffc0203b16:	597d                	li	s2,-1
ffffffffc0203b18:	85a2                	mv	a1,s0
ffffffffc0203b1a:	8526                	mv	a0,s1
ffffffffc0203b1c:	d2dff0ef          	jal	ra,ffffffffc0203848 <find_vma>
ffffffffc0203b20:	0004059b          	sext.w	a1,s0
ffffffffc0203b24:	c90d                	beqz	a0,ffffffffc0203b56 <vmm_init+0x1c8>
ffffffffc0203b26:	6914                	ld	a3,16(a0)
ffffffffc0203b28:	6510                	ld	a2,8(a0)
ffffffffc0203b2a:	00002517          	auipc	a0,0x2
ffffffffc0203b2e:	77e50513          	addi	a0,a0,1918 # ffffffffc02062a8 <default_pmm_manager+0xe68>
ffffffffc0203b32:	d88fc0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc0203b36:	00002697          	auipc	a3,0x2
ffffffffc0203b3a:	79a68693          	addi	a3,a3,1946 # ffffffffc02062d0 <default_pmm_manager+0xe90>
ffffffffc0203b3e:	00001617          	auipc	a2,0x1
ffffffffc0203b42:	55260613          	addi	a2,a2,1362 # ffffffffc0205090 <commands+0x738>
ffffffffc0203b46:	0f600593          	li	a1,246
ffffffffc0203b4a:	00002517          	auipc	a0,0x2
ffffffffc0203b4e:	5ee50513          	addi	a0,a0,1518 # ffffffffc0206138 <default_pmm_manager+0xcf8>
ffffffffc0203b52:	823fc0ef          	jal	ra,ffffffffc0200374 <__panic>
ffffffffc0203b56:	147d                	addi	s0,s0,-1
ffffffffc0203b58:	fd2410e3          	bne	s0,s2,ffffffffc0203b18 <vmm_init+0x18a>
ffffffffc0203b5c:	a811                	j	ffffffffc0203b70 <vmm_init+0x1e2>
ffffffffc0203b5e:	6118                	ld	a4,0(a0)
ffffffffc0203b60:	651c                	ld	a5,8(a0)
ffffffffc0203b62:	03000593          	li	a1,48
ffffffffc0203b66:	1501                	addi	a0,a0,-32
ffffffffc0203b68:	e71c                	sd	a5,8(a4)
ffffffffc0203b6a:	e398                	sd	a4,0(a5)
ffffffffc0203b6c:	cc7fe0ef          	jal	ra,ffffffffc0202832 <kfree>
ffffffffc0203b70:	6488                	ld	a0,8(s1)
ffffffffc0203b72:	fea496e3          	bne	s1,a0,ffffffffc0203b5e <vmm_init+0x1d0>
ffffffffc0203b76:	03000593          	li	a1,48
ffffffffc0203b7a:	8526                	mv	a0,s1
ffffffffc0203b7c:	cb7fe0ef          	jal	ra,ffffffffc0202832 <kfree>
ffffffffc0203b80:	b13fd0ef          	jal	ra,ffffffffc0201692 <nr_free_pages>
ffffffffc0203b84:	3caa1163          	bne	s4,a0,ffffffffc0203f46 <vmm_init+0x5b8>
ffffffffc0203b88:	00002517          	auipc	a0,0x2
ffffffffc0203b8c:	78850513          	addi	a0,a0,1928 # ffffffffc0206310 <default_pmm_manager+0xed0>
ffffffffc0203b90:	d2afc0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc0203b94:	afffd0ef          	jal	ra,ffffffffc0201692 <nr_free_pages>
ffffffffc0203b98:	84aa                	mv	s1,a0
ffffffffc0203b9a:	03000513          	li	a0,48
ffffffffc0203b9e:	bdbfe0ef          	jal	ra,ffffffffc0202778 <kmalloc>
ffffffffc0203ba2:	842a                	mv	s0,a0
ffffffffc0203ba4:	2a050163          	beqz	a0,ffffffffc0203e46 <vmm_init+0x4b8>
ffffffffc0203ba8:	0000e797          	auipc	a5,0xe
ffffffffc0203bac:	9a87a783          	lw	a5,-1624(a5) # ffffffffc0211550 <swap_init_ok>
ffffffffc0203bb0:	e508                	sd	a0,8(a0)
ffffffffc0203bb2:	e108                	sd	a0,0(a0)
ffffffffc0203bb4:	00053823          	sd	zero,16(a0)
ffffffffc0203bb8:	00053c23          	sd	zero,24(a0)
ffffffffc0203bbc:	02052023          	sw	zero,32(a0)
ffffffffc0203bc0:	14079063          	bnez	a5,ffffffffc0203d00 <vmm_init+0x372>
ffffffffc0203bc4:	02053423          	sd	zero,40(a0)
ffffffffc0203bc8:	0000e917          	auipc	s2,0xe
ffffffffc0203bcc:	95093903          	ld	s2,-1712(s2) # ffffffffc0211518 <boot_pgdir>
ffffffffc0203bd0:	00093783          	ld	a5,0(s2)
ffffffffc0203bd4:	0000e717          	auipc	a4,0xe
ffffffffc0203bd8:	98873223          	sd	s0,-1660(a4) # ffffffffc0211558 <check_mm_struct>
ffffffffc0203bdc:	01243c23          	sd	s2,24(s0)
ffffffffc0203be0:	24079363          	bnez	a5,ffffffffc0203e26 <vmm_init+0x498>
ffffffffc0203be4:	03000513          	li	a0,48
ffffffffc0203be8:	b91fe0ef          	jal	ra,ffffffffc0202778 <kmalloc>
ffffffffc0203bec:	8a2a                	mv	s4,a0
ffffffffc0203bee:	28050063          	beqz	a0,ffffffffc0203e6e <vmm_init+0x4e0>
ffffffffc0203bf2:	002007b7          	lui	a5,0x200
ffffffffc0203bf6:	00fa3823          	sd	a5,16(s4)
ffffffffc0203bfa:	4789                	li	a5,2
ffffffffc0203bfc:	85aa                	mv	a1,a0
ffffffffc0203bfe:	00fa3c23          	sd	a5,24(s4)
ffffffffc0203c02:	8522                	mv	a0,s0
ffffffffc0203c04:	000a3423          	sd	zero,8(s4)
ffffffffc0203c08:	c81ff0ef          	jal	ra,ffffffffc0203888 <insert_vma_struct>
ffffffffc0203c0c:	10000593          	li	a1,256
ffffffffc0203c10:	8522                	mv	a0,s0
ffffffffc0203c12:	c37ff0ef          	jal	ra,ffffffffc0203848 <find_vma>
ffffffffc0203c16:	10000793          	li	a5,256
ffffffffc0203c1a:	16400713          	li	a4,356
ffffffffc0203c1e:	26aa1863          	bne	s4,a0,ffffffffc0203e8e <vmm_init+0x500>
ffffffffc0203c22:	00f78023          	sb	a5,0(a5) # 200000 <kern_entry-0xffffffffc0000000>
ffffffffc0203c26:	0785                	addi	a5,a5,1
ffffffffc0203c28:	fee79de3          	bne	a5,a4,ffffffffc0203c22 <vmm_init+0x294>
ffffffffc0203c2c:	6705                	lui	a4,0x1
ffffffffc0203c2e:	10000793          	li	a5,256
ffffffffc0203c32:	35670713          	addi	a4,a4,854 # 1356 <kern_entry-0xffffffffc01fecaa>
ffffffffc0203c36:	16400613          	li	a2,356
ffffffffc0203c3a:	0007c683          	lbu	a3,0(a5)
ffffffffc0203c3e:	0785                	addi	a5,a5,1
ffffffffc0203c40:	9f15                	subw	a4,a4,a3
ffffffffc0203c42:	fec79ce3          	bne	a5,a2,ffffffffc0203c3a <vmm_init+0x2ac>
ffffffffc0203c46:	26071463          	bnez	a4,ffffffffc0203eae <vmm_init+0x520>
ffffffffc0203c4a:	4581                	li	a1,0
ffffffffc0203c4c:	854a                	mv	a0,s2
ffffffffc0203c4e:	ccffd0ef          	jal	ra,ffffffffc020191c <page_remove>
ffffffffc0203c52:	00093783          	ld	a5,0(s2)
ffffffffc0203c56:	0000e717          	auipc	a4,0xe
ffffffffc0203c5a:	8ca73703          	ld	a4,-1846(a4) # ffffffffc0211520 <npage>
ffffffffc0203c5e:	078a                	slli	a5,a5,0x2
ffffffffc0203c60:	83b1                	srli	a5,a5,0xc
ffffffffc0203c62:	26e7f663          	bgeu	a5,a4,ffffffffc0203ece <vmm_init+0x540>
ffffffffc0203c66:	00003717          	auipc	a4,0x3
ffffffffc0203c6a:	a7273703          	ld	a4,-1422(a4) # ffffffffc02066d8 <nbase>
ffffffffc0203c6e:	8f99                	sub	a5,a5,a4
ffffffffc0203c70:	00379713          	slli	a4,a5,0x3
ffffffffc0203c74:	97ba                	add	a5,a5,a4
ffffffffc0203c76:	078e                	slli	a5,a5,0x3
ffffffffc0203c78:	0000e517          	auipc	a0,0xe
ffffffffc0203c7c:	8b053503          	ld	a0,-1872(a0) # ffffffffc0211528 <pages>
ffffffffc0203c80:	953e                	add	a0,a0,a5
ffffffffc0203c82:	4585                	li	a1,1
ffffffffc0203c84:	9cffd0ef          	jal	ra,ffffffffc0201652 <free_pages>
ffffffffc0203c88:	6408                	ld	a0,8(s0)
ffffffffc0203c8a:	00093023          	sd	zero,0(s2)
ffffffffc0203c8e:	00043c23          	sd	zero,24(s0)
ffffffffc0203c92:	00a40e63          	beq	s0,a0,ffffffffc0203cae <vmm_init+0x320>
ffffffffc0203c96:	6118                	ld	a4,0(a0)
ffffffffc0203c98:	651c                	ld	a5,8(a0)
ffffffffc0203c9a:	03000593          	li	a1,48
ffffffffc0203c9e:	1501                	addi	a0,a0,-32
ffffffffc0203ca0:	e71c                	sd	a5,8(a4)
ffffffffc0203ca2:	e398                	sd	a4,0(a5)
ffffffffc0203ca4:	b8ffe0ef          	jal	ra,ffffffffc0202832 <kfree>
ffffffffc0203ca8:	6408                	ld	a0,8(s0)
ffffffffc0203caa:	fea416e3          	bne	s0,a0,ffffffffc0203c96 <vmm_init+0x308>
ffffffffc0203cae:	03000593          	li	a1,48
ffffffffc0203cb2:	8522                	mv	a0,s0
ffffffffc0203cb4:	b7ffe0ef          	jal	ra,ffffffffc0202832 <kfree>
ffffffffc0203cb8:	14fd                	addi	s1,s1,-1
ffffffffc0203cba:	0000e797          	auipc	a5,0xe
ffffffffc0203cbe:	8807bf23          	sd	zero,-1890(a5) # ffffffffc0211558 <check_mm_struct>
ffffffffc0203cc2:	9d1fd0ef          	jal	ra,ffffffffc0201692 <nr_free_pages>
ffffffffc0203cc6:	22a49063          	bne	s1,a0,ffffffffc0203ee6 <vmm_init+0x558>
ffffffffc0203cca:	00002517          	auipc	a0,0x2
ffffffffc0203cce:	69650513          	addi	a0,a0,1686 # ffffffffc0206360 <default_pmm_manager+0xf20>
ffffffffc0203cd2:	be8fc0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc0203cd6:	9bdfd0ef          	jal	ra,ffffffffc0201692 <nr_free_pages>
ffffffffc0203cda:	19fd                	addi	s3,s3,-1
ffffffffc0203cdc:	22a99563          	bne	s3,a0,ffffffffc0203f06 <vmm_init+0x578>
ffffffffc0203ce0:	6406                	ld	s0,64(sp)
ffffffffc0203ce2:	60a6                	ld	ra,72(sp)
ffffffffc0203ce4:	74e2                	ld	s1,56(sp)
ffffffffc0203ce6:	7942                	ld	s2,48(sp)
ffffffffc0203ce8:	79a2                	ld	s3,40(sp)
ffffffffc0203cea:	7a02                	ld	s4,32(sp)
ffffffffc0203cec:	6ae2                	ld	s5,24(sp)
ffffffffc0203cee:	6b42                	ld	s6,16(sp)
ffffffffc0203cf0:	6ba2                	ld	s7,8(sp)
ffffffffc0203cf2:	00002517          	auipc	a0,0x2
ffffffffc0203cf6:	68e50513          	addi	a0,a0,1678 # ffffffffc0206380 <default_pmm_manager+0xf40>
ffffffffc0203cfa:	6161                	addi	sp,sp,80
ffffffffc0203cfc:	bbefc06f          	j	ffffffffc02000ba <cprintf>
ffffffffc0203d00:	a84ff0ef          	jal	ra,ffffffffc0202f84 <swap_init_mm>
ffffffffc0203d04:	b5d1                	j	ffffffffc0203bc8 <vmm_init+0x23a>
ffffffffc0203d06:	00002697          	auipc	a3,0x2
ffffffffc0203d0a:	4ba68693          	addi	a3,a3,1210 # ffffffffc02061c0 <default_pmm_manager+0xd80>
ffffffffc0203d0e:	00001617          	auipc	a2,0x1
ffffffffc0203d12:	38260613          	addi	a2,a2,898 # ffffffffc0205090 <commands+0x738>
ffffffffc0203d16:	0dd00593          	li	a1,221
ffffffffc0203d1a:	00002517          	auipc	a0,0x2
ffffffffc0203d1e:	41e50513          	addi	a0,a0,1054 # ffffffffc0206138 <default_pmm_manager+0xcf8>
ffffffffc0203d22:	e52fc0ef          	jal	ra,ffffffffc0200374 <__panic>
ffffffffc0203d26:	00002697          	auipc	a3,0x2
ffffffffc0203d2a:	55268693          	addi	a3,a3,1362 # ffffffffc0206278 <default_pmm_manager+0xe38>
ffffffffc0203d2e:	00001617          	auipc	a2,0x1
ffffffffc0203d32:	36260613          	addi	a2,a2,866 # ffffffffc0205090 <commands+0x738>
ffffffffc0203d36:	0ee00593          	li	a1,238
ffffffffc0203d3a:	00002517          	auipc	a0,0x2
ffffffffc0203d3e:	3fe50513          	addi	a0,a0,1022 # ffffffffc0206138 <default_pmm_manager+0xcf8>
ffffffffc0203d42:	e32fc0ef          	jal	ra,ffffffffc0200374 <__panic>
ffffffffc0203d46:	00002697          	auipc	a3,0x2
ffffffffc0203d4a:	50268693          	addi	a3,a3,1282 # ffffffffc0206248 <default_pmm_manager+0xe08>
ffffffffc0203d4e:	00001617          	auipc	a2,0x1
ffffffffc0203d52:	34260613          	addi	a2,a2,834 # ffffffffc0205090 <commands+0x738>
ffffffffc0203d56:	0ed00593          	li	a1,237
ffffffffc0203d5a:	00002517          	auipc	a0,0x2
ffffffffc0203d5e:	3de50513          	addi	a0,a0,990 # ffffffffc0206138 <default_pmm_manager+0xcf8>
ffffffffc0203d62:	e12fc0ef          	jal	ra,ffffffffc0200374 <__panic>
ffffffffc0203d66:	00002697          	auipc	a3,0x2
ffffffffc0203d6a:	44268693          	addi	a3,a3,1090 # ffffffffc02061a8 <default_pmm_manager+0xd68>
ffffffffc0203d6e:	00001617          	auipc	a2,0x1
ffffffffc0203d72:	32260613          	addi	a2,a2,802 # ffffffffc0205090 <commands+0x738>
ffffffffc0203d76:	0db00593          	li	a1,219
ffffffffc0203d7a:	00002517          	auipc	a0,0x2
ffffffffc0203d7e:	3be50513          	addi	a0,a0,958 # ffffffffc0206138 <default_pmm_manager+0xcf8>
ffffffffc0203d82:	df2fc0ef          	jal	ra,ffffffffc0200374 <__panic>
ffffffffc0203d86:	00002697          	auipc	a3,0x2
ffffffffc0203d8a:	47268693          	addi	a3,a3,1138 # ffffffffc02061f8 <default_pmm_manager+0xdb8>
ffffffffc0203d8e:	00001617          	auipc	a2,0x1
ffffffffc0203d92:	30260613          	addi	a2,a2,770 # ffffffffc0205090 <commands+0x738>
ffffffffc0203d96:	0e300593          	li	a1,227
ffffffffc0203d9a:	00002517          	auipc	a0,0x2
ffffffffc0203d9e:	39e50513          	addi	a0,a0,926 # ffffffffc0206138 <default_pmm_manager+0xcf8>
ffffffffc0203da2:	dd2fc0ef          	jal	ra,ffffffffc0200374 <__panic>
ffffffffc0203da6:	00002697          	auipc	a3,0x2
ffffffffc0203daa:	46268693          	addi	a3,a3,1122 # ffffffffc0206208 <default_pmm_manager+0xdc8>
ffffffffc0203dae:	00001617          	auipc	a2,0x1
ffffffffc0203db2:	2e260613          	addi	a2,a2,738 # ffffffffc0205090 <commands+0x738>
ffffffffc0203db6:	0e500593          	li	a1,229
ffffffffc0203dba:	00002517          	auipc	a0,0x2
ffffffffc0203dbe:	37e50513          	addi	a0,a0,894 # ffffffffc0206138 <default_pmm_manager+0xcf8>
ffffffffc0203dc2:	db2fc0ef          	jal	ra,ffffffffc0200374 <__panic>
ffffffffc0203dc6:	00002697          	auipc	a3,0x2
ffffffffc0203dca:	45268693          	addi	a3,a3,1106 # ffffffffc0206218 <default_pmm_manager+0xdd8>
ffffffffc0203dce:	00001617          	auipc	a2,0x1
ffffffffc0203dd2:	2c260613          	addi	a2,a2,706 # ffffffffc0205090 <commands+0x738>
ffffffffc0203dd6:	0e700593          	li	a1,231
ffffffffc0203dda:	00002517          	auipc	a0,0x2
ffffffffc0203dde:	35e50513          	addi	a0,a0,862 # ffffffffc0206138 <default_pmm_manager+0xcf8>
ffffffffc0203de2:	d92fc0ef          	jal	ra,ffffffffc0200374 <__panic>
ffffffffc0203de6:	00002697          	auipc	a3,0x2
ffffffffc0203dea:	44268693          	addi	a3,a3,1090 # ffffffffc0206228 <default_pmm_manager+0xde8>
ffffffffc0203dee:	00001617          	auipc	a2,0x1
ffffffffc0203df2:	2a260613          	addi	a2,a2,674 # ffffffffc0205090 <commands+0x738>
ffffffffc0203df6:	0e900593          	li	a1,233
ffffffffc0203dfa:	00002517          	auipc	a0,0x2
ffffffffc0203dfe:	33e50513          	addi	a0,a0,830 # ffffffffc0206138 <default_pmm_manager+0xcf8>
ffffffffc0203e02:	d72fc0ef          	jal	ra,ffffffffc0200374 <__panic>
ffffffffc0203e06:	00002697          	auipc	a3,0x2
ffffffffc0203e0a:	43268693          	addi	a3,a3,1074 # ffffffffc0206238 <default_pmm_manager+0xdf8>
ffffffffc0203e0e:	00001617          	auipc	a2,0x1
ffffffffc0203e12:	28260613          	addi	a2,a2,642 # ffffffffc0205090 <commands+0x738>
ffffffffc0203e16:	0eb00593          	li	a1,235
ffffffffc0203e1a:	00002517          	auipc	a0,0x2
ffffffffc0203e1e:	31e50513          	addi	a0,a0,798 # ffffffffc0206138 <default_pmm_manager+0xcf8>
ffffffffc0203e22:	d52fc0ef          	jal	ra,ffffffffc0200374 <__panic>
ffffffffc0203e26:	00002697          	auipc	a3,0x2
ffffffffc0203e2a:	d3a68693          	addi	a3,a3,-710 # ffffffffc0205b60 <default_pmm_manager+0x720>
ffffffffc0203e2e:	00001617          	auipc	a2,0x1
ffffffffc0203e32:	26260613          	addi	a2,a2,610 # ffffffffc0205090 <commands+0x738>
ffffffffc0203e36:	10d00593          	li	a1,269
ffffffffc0203e3a:	00002517          	auipc	a0,0x2
ffffffffc0203e3e:	2fe50513          	addi	a0,a0,766 # ffffffffc0206138 <default_pmm_manager+0xcf8>
ffffffffc0203e42:	d32fc0ef          	jal	ra,ffffffffc0200374 <__panic>
ffffffffc0203e46:	00002697          	auipc	a3,0x2
ffffffffc0203e4a:	55268693          	addi	a3,a3,1362 # ffffffffc0206398 <default_pmm_manager+0xf58>
ffffffffc0203e4e:	00001617          	auipc	a2,0x1
ffffffffc0203e52:	24260613          	addi	a2,a2,578 # ffffffffc0205090 <commands+0x738>
ffffffffc0203e56:	10a00593          	li	a1,266
ffffffffc0203e5a:	00002517          	auipc	a0,0x2
ffffffffc0203e5e:	2de50513          	addi	a0,a0,734 # ffffffffc0206138 <default_pmm_manager+0xcf8>
ffffffffc0203e62:	0000d797          	auipc	a5,0xd
ffffffffc0203e66:	6e07bb23          	sd	zero,1782(a5) # ffffffffc0211558 <check_mm_struct>
ffffffffc0203e6a:	d0afc0ef          	jal	ra,ffffffffc0200374 <__panic>
ffffffffc0203e6e:	00002697          	auipc	a3,0x2
ffffffffc0203e72:	d0268693          	addi	a3,a3,-766 # ffffffffc0205b70 <default_pmm_manager+0x730>
ffffffffc0203e76:	00001617          	auipc	a2,0x1
ffffffffc0203e7a:	21a60613          	addi	a2,a2,538 # ffffffffc0205090 <commands+0x738>
ffffffffc0203e7e:	11100593          	li	a1,273
ffffffffc0203e82:	00002517          	auipc	a0,0x2
ffffffffc0203e86:	2b650513          	addi	a0,a0,694 # ffffffffc0206138 <default_pmm_manager+0xcf8>
ffffffffc0203e8a:	ceafc0ef          	jal	ra,ffffffffc0200374 <__panic>
ffffffffc0203e8e:	00002697          	auipc	a3,0x2
ffffffffc0203e92:	4a268693          	addi	a3,a3,1186 # ffffffffc0206330 <default_pmm_manager+0xef0>
ffffffffc0203e96:	00001617          	auipc	a2,0x1
ffffffffc0203e9a:	1fa60613          	addi	a2,a2,506 # ffffffffc0205090 <commands+0x738>
ffffffffc0203e9e:	11600593          	li	a1,278
ffffffffc0203ea2:	00002517          	auipc	a0,0x2
ffffffffc0203ea6:	29650513          	addi	a0,a0,662 # ffffffffc0206138 <default_pmm_manager+0xcf8>
ffffffffc0203eaa:	ccafc0ef          	jal	ra,ffffffffc0200374 <__panic>
ffffffffc0203eae:	00002697          	auipc	a3,0x2
ffffffffc0203eb2:	4a268693          	addi	a3,a3,1186 # ffffffffc0206350 <default_pmm_manager+0xf10>
ffffffffc0203eb6:	00001617          	auipc	a2,0x1
ffffffffc0203eba:	1da60613          	addi	a2,a2,474 # ffffffffc0205090 <commands+0x738>
ffffffffc0203ebe:	12000593          	li	a1,288
ffffffffc0203ec2:	00002517          	auipc	a0,0x2
ffffffffc0203ec6:	27650513          	addi	a0,a0,630 # ffffffffc0206138 <default_pmm_manager+0xcf8>
ffffffffc0203eca:	caafc0ef          	jal	ra,ffffffffc0200374 <__panic>
ffffffffc0203ece:	00001617          	auipc	a2,0x1
ffffffffc0203ed2:	5aa60613          	addi	a2,a2,1450 # ffffffffc0205478 <default_pmm_manager+0x38>
ffffffffc0203ed6:	06500593          	li	a1,101
ffffffffc0203eda:	00001517          	auipc	a0,0x1
ffffffffc0203ede:	5be50513          	addi	a0,a0,1470 # ffffffffc0205498 <default_pmm_manager+0x58>
ffffffffc0203ee2:	c92fc0ef          	jal	ra,ffffffffc0200374 <__panic>
ffffffffc0203ee6:	00002697          	auipc	a3,0x2
ffffffffc0203eea:	40268693          	addi	a3,a3,1026 # ffffffffc02062e8 <default_pmm_manager+0xea8>
ffffffffc0203eee:	00001617          	auipc	a2,0x1
ffffffffc0203ef2:	1a260613          	addi	a2,a2,418 # ffffffffc0205090 <commands+0x738>
ffffffffc0203ef6:	12e00593          	li	a1,302
ffffffffc0203efa:	00002517          	auipc	a0,0x2
ffffffffc0203efe:	23e50513          	addi	a0,a0,574 # ffffffffc0206138 <default_pmm_manager+0xcf8>
ffffffffc0203f02:	c72fc0ef          	jal	ra,ffffffffc0200374 <__panic>
ffffffffc0203f06:	00002697          	auipc	a3,0x2
ffffffffc0203f0a:	3e268693          	addi	a3,a3,994 # ffffffffc02062e8 <default_pmm_manager+0xea8>
ffffffffc0203f0e:	00001617          	auipc	a2,0x1
ffffffffc0203f12:	18260613          	addi	a2,a2,386 # ffffffffc0205090 <commands+0x738>
ffffffffc0203f16:	0bd00593          	li	a1,189
ffffffffc0203f1a:	00002517          	auipc	a0,0x2
ffffffffc0203f1e:	21e50513          	addi	a0,a0,542 # ffffffffc0206138 <default_pmm_manager+0xcf8>
ffffffffc0203f22:	c52fc0ef          	jal	ra,ffffffffc0200374 <__panic>
ffffffffc0203f26:	00002697          	auipc	a3,0x2
ffffffffc0203f2a:	c1268693          	addi	a3,a3,-1006 # ffffffffc0205b38 <default_pmm_manager+0x6f8>
ffffffffc0203f2e:	00001617          	auipc	a2,0x1
ffffffffc0203f32:	16260613          	addi	a2,a2,354 # ffffffffc0205090 <commands+0x738>
ffffffffc0203f36:	0c700593          	li	a1,199
ffffffffc0203f3a:	00002517          	auipc	a0,0x2
ffffffffc0203f3e:	1fe50513          	addi	a0,a0,510 # ffffffffc0206138 <default_pmm_manager+0xcf8>
ffffffffc0203f42:	c32fc0ef          	jal	ra,ffffffffc0200374 <__panic>
ffffffffc0203f46:	00002697          	auipc	a3,0x2
ffffffffc0203f4a:	3a268693          	addi	a3,a3,930 # ffffffffc02062e8 <default_pmm_manager+0xea8>
ffffffffc0203f4e:	00001617          	auipc	a2,0x1
ffffffffc0203f52:	14260613          	addi	a2,a2,322 # ffffffffc0205090 <commands+0x738>
ffffffffc0203f56:	0fb00593          	li	a1,251
ffffffffc0203f5a:	00002517          	auipc	a0,0x2
ffffffffc0203f5e:	1de50513          	addi	a0,a0,478 # ffffffffc0206138 <default_pmm_manager+0xcf8>
ffffffffc0203f62:	c12fc0ef          	jal	ra,ffffffffc0200374 <__panic>

ffffffffc0203f66 <do_pgfault>:
ffffffffc0203f66:	7179                	addi	sp,sp,-48
ffffffffc0203f68:	85b2                	mv	a1,a2
ffffffffc0203f6a:	f022                	sd	s0,32(sp)
ffffffffc0203f6c:	ec26                	sd	s1,24(sp)
ffffffffc0203f6e:	f406                	sd	ra,40(sp)
ffffffffc0203f70:	e84a                	sd	s2,16(sp)
ffffffffc0203f72:	8432                	mv	s0,a2
ffffffffc0203f74:	84aa                	mv	s1,a0
ffffffffc0203f76:	8d3ff0ef          	jal	ra,ffffffffc0203848 <find_vma>
ffffffffc0203f7a:	0000d797          	auipc	a5,0xd
ffffffffc0203f7e:	5e67a783          	lw	a5,1510(a5) # ffffffffc0211560 <pgfault_num>
ffffffffc0203f82:	2785                	addiw	a5,a5,1
ffffffffc0203f84:	0000d717          	auipc	a4,0xd
ffffffffc0203f88:	5cf72e23          	sw	a5,1500(a4) # ffffffffc0211560 <pgfault_num>
ffffffffc0203f8c:	cd41                	beqz	a0,ffffffffc0204024 <do_pgfault+0xbe>
ffffffffc0203f8e:	651c                	ld	a5,8(a0)
ffffffffc0203f90:	08f46a63          	bltu	s0,a5,ffffffffc0204024 <do_pgfault+0xbe>
ffffffffc0203f94:	6d1c                	ld	a5,24(a0)
ffffffffc0203f96:	4941                	li	s2,16
ffffffffc0203f98:	8b89                	andi	a5,a5,2
ffffffffc0203f9a:	e7a9                	bnez	a5,ffffffffc0203fe4 <do_pgfault+0x7e>
ffffffffc0203f9c:	75fd                	lui	a1,0xfffff
ffffffffc0203f9e:	6c88                	ld	a0,24(s1)
ffffffffc0203fa0:	8c6d                	and	s0,s0,a1
ffffffffc0203fa2:	85a2                	mv	a1,s0
ffffffffc0203fa4:	4605                	li	a2,1
ffffffffc0203fa6:	f26fd0ef          	jal	ra,ffffffffc02016cc <get_pte>
ffffffffc0203faa:	610c                	ld	a1,0(a0)
ffffffffc0203fac:	cda9                	beqz	a1,ffffffffc0204006 <do_pgfault+0xa0>
ffffffffc0203fae:	0000d797          	auipc	a5,0xd
ffffffffc0203fb2:	5a27a783          	lw	a5,1442(a5) # ffffffffc0211550 <swap_init_ok>
ffffffffc0203fb6:	c3c1                	beqz	a5,ffffffffc0204036 <do_pgfault+0xd0>
ffffffffc0203fb8:	85a2                	mv	a1,s0
ffffffffc0203fba:	0030                	addi	a2,sp,8
ffffffffc0203fbc:	8526                	mv	a0,s1
ffffffffc0203fbe:	e402                	sd	zero,8(sp)
ffffffffc0203fc0:	8f0ff0ef          	jal	ra,ffffffffc02030b0 <swap_in>
ffffffffc0203fc4:	65a2                	ld	a1,8(sp)
ffffffffc0203fc6:	6c88                	ld	a0,24(s1)
ffffffffc0203fc8:	86ca                	mv	a3,s2
ffffffffc0203fca:	8622                	mv	a2,s0
ffffffffc0203fcc:	9ebfd0ef          	jal	ra,ffffffffc02019b6 <page_insert>
ffffffffc0203fd0:	892a                	mv	s2,a0
ffffffffc0203fd2:	c919                	beqz	a0,ffffffffc0203fe8 <do_pgfault+0x82>
ffffffffc0203fd4:	4905                	li	s2,1
ffffffffc0203fd6:	70a2                	ld	ra,40(sp)
ffffffffc0203fd8:	7402                	ld	s0,32(sp)
ffffffffc0203fda:	64e2                	ld	s1,24(sp)
ffffffffc0203fdc:	854a                	mv	a0,s2
ffffffffc0203fde:	6942                	ld	s2,16(sp)
ffffffffc0203fe0:	6145                	addi	sp,sp,48
ffffffffc0203fe2:	8082                	ret
ffffffffc0203fe4:	4959                	li	s2,22
ffffffffc0203fe6:	bf5d                	j	ffffffffc0203f9c <do_pgfault+0x36>
ffffffffc0203fe8:	6622                	ld	a2,8(sp)
ffffffffc0203fea:	85a2                	mv	a1,s0
ffffffffc0203fec:	8526                	mv	a0,s1
ffffffffc0203fee:	4681                	li	a3,0
ffffffffc0203ff0:	fa1fe0ef          	jal	ra,ffffffffc0202f90 <swap_map_swappable>
ffffffffc0203ff4:	67a2                	ld	a5,8(sp)
ffffffffc0203ff6:	70a2                	ld	ra,40(sp)
ffffffffc0203ff8:	64e2                	ld	s1,24(sp)
ffffffffc0203ffa:	e3a0                	sd	s0,64(a5)
ffffffffc0203ffc:	7402                	ld	s0,32(sp)
ffffffffc0203ffe:	854a                	mv	a0,s2
ffffffffc0204000:	6942                	ld	s2,16(sp)
ffffffffc0204002:	6145                	addi	sp,sp,48
ffffffffc0204004:	8082                	ret
ffffffffc0204006:	6c88                	ld	a0,24(s1)
ffffffffc0204008:	864a                	mv	a2,s2
ffffffffc020400a:	85a2                	mv	a1,s0
ffffffffc020400c:	eb4fe0ef          	jal	ra,ffffffffc02026c0 <pgdir_alloc_page>
ffffffffc0204010:	4901                	li	s2,0
ffffffffc0204012:	f171                	bnez	a0,ffffffffc0203fd6 <do_pgfault+0x70>
ffffffffc0204014:	00002517          	auipc	a0,0x2
ffffffffc0204018:	3cc50513          	addi	a0,a0,972 # ffffffffc02063e0 <default_pmm_manager+0xfa0>
ffffffffc020401c:	89efc0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc0204020:	5971                	li	s2,-4
ffffffffc0204022:	bf55                	j	ffffffffc0203fd6 <do_pgfault+0x70>
ffffffffc0204024:	85a2                	mv	a1,s0
ffffffffc0204026:	00002517          	auipc	a0,0x2
ffffffffc020402a:	38a50513          	addi	a0,a0,906 # ffffffffc02063b0 <default_pmm_manager+0xf70>
ffffffffc020402e:	88cfc0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc0204032:	5975                	li	s2,-3
ffffffffc0204034:	b74d                	j	ffffffffc0203fd6 <do_pgfault+0x70>
ffffffffc0204036:	00002517          	auipc	a0,0x2
ffffffffc020403a:	3d250513          	addi	a0,a0,978 # ffffffffc0206408 <default_pmm_manager+0xfc8>
ffffffffc020403e:	87cfc0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc0204042:	5971                	li	s2,-4
ffffffffc0204044:	bf49                	j	ffffffffc0203fd6 <do_pgfault+0x70>

ffffffffc0204046 <swapfs_init>:
ffffffffc0204046:	1141                	addi	sp,sp,-16
ffffffffc0204048:	4505                	li	a0,1
ffffffffc020404a:	e406                	sd	ra,8(sp)
ffffffffc020404c:	c48fc0ef          	jal	ra,ffffffffc0200494 <ide_device_valid>
ffffffffc0204050:	cd01                	beqz	a0,ffffffffc0204068 <swapfs_init+0x22>
ffffffffc0204052:	4505                	li	a0,1
ffffffffc0204054:	c46fc0ef          	jal	ra,ffffffffc020049a <ide_device_size>
ffffffffc0204058:	60a2                	ld	ra,8(sp)
ffffffffc020405a:	810d                	srli	a0,a0,0x3
ffffffffc020405c:	0000d797          	auipc	a5,0xd
ffffffffc0204060:	4ea7b223          	sd	a0,1252(a5) # ffffffffc0211540 <max_swap_offset>
ffffffffc0204064:	0141                	addi	sp,sp,16
ffffffffc0204066:	8082                	ret
ffffffffc0204068:	00002617          	auipc	a2,0x2
ffffffffc020406c:	3c860613          	addi	a2,a2,968 # ffffffffc0206430 <default_pmm_manager+0xff0>
ffffffffc0204070:	45b5                	li	a1,13
ffffffffc0204072:	00002517          	auipc	a0,0x2
ffffffffc0204076:	3de50513          	addi	a0,a0,990 # ffffffffc0206450 <default_pmm_manager+0x1010>
ffffffffc020407a:	afafc0ef          	jal	ra,ffffffffc0200374 <__panic>

ffffffffc020407e <swapfs_read>:
ffffffffc020407e:	1141                	addi	sp,sp,-16
ffffffffc0204080:	e406                	sd	ra,8(sp)
ffffffffc0204082:	00855793          	srli	a5,a0,0x8
ffffffffc0204086:	c3a5                	beqz	a5,ffffffffc02040e6 <swapfs_read+0x68>
ffffffffc0204088:	0000d717          	auipc	a4,0xd
ffffffffc020408c:	4b873703          	ld	a4,1208(a4) # ffffffffc0211540 <max_swap_offset>
ffffffffc0204090:	04e7fb63          	bgeu	a5,a4,ffffffffc02040e6 <swapfs_read+0x68>
ffffffffc0204094:	0000d617          	auipc	a2,0xd
ffffffffc0204098:	49463603          	ld	a2,1172(a2) # ffffffffc0211528 <pages>
ffffffffc020409c:	8d91                	sub	a1,a1,a2
ffffffffc020409e:	4035d613          	srai	a2,a1,0x3
ffffffffc02040a2:	00002597          	auipc	a1,0x2
ffffffffc02040a6:	62e5b583          	ld	a1,1582(a1) # ffffffffc02066d0 <error_string+0x38>
ffffffffc02040aa:	02b60633          	mul	a2,a2,a1
ffffffffc02040ae:	0037959b          	slliw	a1,a5,0x3
ffffffffc02040b2:	00002797          	auipc	a5,0x2
ffffffffc02040b6:	6267b783          	ld	a5,1574(a5) # ffffffffc02066d8 <nbase>
ffffffffc02040ba:	0000d717          	auipc	a4,0xd
ffffffffc02040be:	46673703          	ld	a4,1126(a4) # ffffffffc0211520 <npage>
ffffffffc02040c2:	963e                	add	a2,a2,a5
ffffffffc02040c4:	00c61793          	slli	a5,a2,0xc
ffffffffc02040c8:	83b1                	srli	a5,a5,0xc
ffffffffc02040ca:	0632                	slli	a2,a2,0xc
ffffffffc02040cc:	02e7f963          	bgeu	a5,a4,ffffffffc02040fe <swapfs_read+0x80>
ffffffffc02040d0:	60a2                	ld	ra,8(sp)
ffffffffc02040d2:	0000d797          	auipc	a5,0xd
ffffffffc02040d6:	4667b783          	ld	a5,1126(a5) # ffffffffc0211538 <va_pa_offset>
ffffffffc02040da:	46a1                	li	a3,8
ffffffffc02040dc:	963e                	add	a2,a2,a5
ffffffffc02040de:	4505                	li	a0,1
ffffffffc02040e0:	0141                	addi	sp,sp,16
ffffffffc02040e2:	bbefc06f          	j	ffffffffc02004a0 <ide_read_secs>
ffffffffc02040e6:	86aa                	mv	a3,a0
ffffffffc02040e8:	00002617          	auipc	a2,0x2
ffffffffc02040ec:	38060613          	addi	a2,a2,896 # ffffffffc0206468 <default_pmm_manager+0x1028>
ffffffffc02040f0:	45d1                	li	a1,20
ffffffffc02040f2:	00002517          	auipc	a0,0x2
ffffffffc02040f6:	35e50513          	addi	a0,a0,862 # ffffffffc0206450 <default_pmm_manager+0x1010>
ffffffffc02040fa:	a7afc0ef          	jal	ra,ffffffffc0200374 <__panic>
ffffffffc02040fe:	86b2                	mv	a3,a2
ffffffffc0204100:	06a00593          	li	a1,106
ffffffffc0204104:	00001617          	auipc	a2,0x1
ffffffffc0204108:	3cc60613          	addi	a2,a2,972 # ffffffffc02054d0 <default_pmm_manager+0x90>
ffffffffc020410c:	00001517          	auipc	a0,0x1
ffffffffc0204110:	38c50513          	addi	a0,a0,908 # ffffffffc0205498 <default_pmm_manager+0x58>
ffffffffc0204114:	a60fc0ef          	jal	ra,ffffffffc0200374 <__panic>

ffffffffc0204118 <swapfs_write>:
ffffffffc0204118:	1141                	addi	sp,sp,-16
ffffffffc020411a:	e406                	sd	ra,8(sp)
ffffffffc020411c:	00855793          	srli	a5,a0,0x8
ffffffffc0204120:	c3a5                	beqz	a5,ffffffffc0204180 <swapfs_write+0x68>
ffffffffc0204122:	0000d717          	auipc	a4,0xd
ffffffffc0204126:	41e73703          	ld	a4,1054(a4) # ffffffffc0211540 <max_swap_offset>
ffffffffc020412a:	04e7fb63          	bgeu	a5,a4,ffffffffc0204180 <swapfs_write+0x68>
ffffffffc020412e:	0000d617          	auipc	a2,0xd
ffffffffc0204132:	3fa63603          	ld	a2,1018(a2) # ffffffffc0211528 <pages>
ffffffffc0204136:	8d91                	sub	a1,a1,a2
ffffffffc0204138:	4035d613          	srai	a2,a1,0x3
ffffffffc020413c:	00002597          	auipc	a1,0x2
ffffffffc0204140:	5945b583          	ld	a1,1428(a1) # ffffffffc02066d0 <error_string+0x38>
ffffffffc0204144:	02b60633          	mul	a2,a2,a1
ffffffffc0204148:	0037959b          	slliw	a1,a5,0x3
ffffffffc020414c:	00002797          	auipc	a5,0x2
ffffffffc0204150:	58c7b783          	ld	a5,1420(a5) # ffffffffc02066d8 <nbase>
ffffffffc0204154:	0000d717          	auipc	a4,0xd
ffffffffc0204158:	3cc73703          	ld	a4,972(a4) # ffffffffc0211520 <npage>
ffffffffc020415c:	963e                	add	a2,a2,a5
ffffffffc020415e:	00c61793          	slli	a5,a2,0xc
ffffffffc0204162:	83b1                	srli	a5,a5,0xc
ffffffffc0204164:	0632                	slli	a2,a2,0xc
ffffffffc0204166:	02e7f963          	bgeu	a5,a4,ffffffffc0204198 <swapfs_write+0x80>
ffffffffc020416a:	60a2                	ld	ra,8(sp)
ffffffffc020416c:	0000d797          	auipc	a5,0xd
ffffffffc0204170:	3cc7b783          	ld	a5,972(a5) # ffffffffc0211538 <va_pa_offset>
ffffffffc0204174:	46a1                	li	a3,8
ffffffffc0204176:	963e                	add	a2,a2,a5
ffffffffc0204178:	4505                	li	a0,1
ffffffffc020417a:	0141                	addi	sp,sp,16
ffffffffc020417c:	b48fc06f          	j	ffffffffc02004c4 <ide_write_secs>
ffffffffc0204180:	86aa                	mv	a3,a0
ffffffffc0204182:	00002617          	auipc	a2,0x2
ffffffffc0204186:	2e660613          	addi	a2,a2,742 # ffffffffc0206468 <default_pmm_manager+0x1028>
ffffffffc020418a:	45e5                	li	a1,25
ffffffffc020418c:	00002517          	auipc	a0,0x2
ffffffffc0204190:	2c450513          	addi	a0,a0,708 # ffffffffc0206450 <default_pmm_manager+0x1010>
ffffffffc0204194:	9e0fc0ef          	jal	ra,ffffffffc0200374 <__panic>
ffffffffc0204198:	86b2                	mv	a3,a2
ffffffffc020419a:	06a00593          	li	a1,106
ffffffffc020419e:	00001617          	auipc	a2,0x1
ffffffffc02041a2:	33260613          	addi	a2,a2,818 # ffffffffc02054d0 <default_pmm_manager+0x90>
ffffffffc02041a6:	00001517          	auipc	a0,0x1
ffffffffc02041aa:	2f250513          	addi	a0,a0,754 # ffffffffc0205498 <default_pmm_manager+0x58>
ffffffffc02041ae:	9c6fc0ef          	jal	ra,ffffffffc0200374 <__panic>

ffffffffc02041b2 <printnum>:
ffffffffc02041b2:	02069813          	slli	a6,a3,0x20
ffffffffc02041b6:	7179                	addi	sp,sp,-48
ffffffffc02041b8:	02085813          	srli	a6,a6,0x20
ffffffffc02041bc:	e052                	sd	s4,0(sp)
ffffffffc02041be:	03067a33          	remu	s4,a2,a6
ffffffffc02041c2:	f022                	sd	s0,32(sp)
ffffffffc02041c4:	ec26                	sd	s1,24(sp)
ffffffffc02041c6:	e84a                	sd	s2,16(sp)
ffffffffc02041c8:	f406                	sd	ra,40(sp)
ffffffffc02041ca:	e44e                	sd	s3,8(sp)
ffffffffc02041cc:	84aa                	mv	s1,a0
ffffffffc02041ce:	892e                	mv	s2,a1
ffffffffc02041d0:	fff7041b          	addiw	s0,a4,-1
ffffffffc02041d4:	2a01                	sext.w	s4,s4
ffffffffc02041d6:	03067e63          	bgeu	a2,a6,ffffffffc0204212 <printnum+0x60>
ffffffffc02041da:	89be                	mv	s3,a5
ffffffffc02041dc:	00805763          	blez	s0,ffffffffc02041ea <printnum+0x38>
ffffffffc02041e0:	347d                	addiw	s0,s0,-1
ffffffffc02041e2:	85ca                	mv	a1,s2
ffffffffc02041e4:	854e                	mv	a0,s3
ffffffffc02041e6:	9482                	jalr	s1
ffffffffc02041e8:	fc65                	bnez	s0,ffffffffc02041e0 <printnum+0x2e>
ffffffffc02041ea:	1a02                	slli	s4,s4,0x20
ffffffffc02041ec:	00002797          	auipc	a5,0x2
ffffffffc02041f0:	29c78793          	addi	a5,a5,668 # ffffffffc0206488 <default_pmm_manager+0x1048>
ffffffffc02041f4:	020a5a13          	srli	s4,s4,0x20
ffffffffc02041f8:	9a3e                	add	s4,s4,a5
ffffffffc02041fa:	7402                	ld	s0,32(sp)
ffffffffc02041fc:	000a4503          	lbu	a0,0(s4)
ffffffffc0204200:	70a2                	ld	ra,40(sp)
ffffffffc0204202:	69a2                	ld	s3,8(sp)
ffffffffc0204204:	6a02                	ld	s4,0(sp)
ffffffffc0204206:	85ca                	mv	a1,s2
ffffffffc0204208:	87a6                	mv	a5,s1
ffffffffc020420a:	6942                	ld	s2,16(sp)
ffffffffc020420c:	64e2                	ld	s1,24(sp)
ffffffffc020420e:	6145                	addi	sp,sp,48
ffffffffc0204210:	8782                	jr	a5
ffffffffc0204212:	03065633          	divu	a2,a2,a6
ffffffffc0204216:	8722                	mv	a4,s0
ffffffffc0204218:	f9bff0ef          	jal	ra,ffffffffc02041b2 <printnum>
ffffffffc020421c:	b7f9                	j	ffffffffc02041ea <printnum+0x38>

ffffffffc020421e <vprintfmt>:
ffffffffc020421e:	7119                	addi	sp,sp,-128
ffffffffc0204220:	f4a6                	sd	s1,104(sp)
ffffffffc0204222:	f0ca                	sd	s2,96(sp)
ffffffffc0204224:	ecce                	sd	s3,88(sp)
ffffffffc0204226:	e8d2                	sd	s4,80(sp)
ffffffffc0204228:	e4d6                	sd	s5,72(sp)
ffffffffc020422a:	e0da                	sd	s6,64(sp)
ffffffffc020422c:	fc5e                	sd	s7,56(sp)
ffffffffc020422e:	f06a                	sd	s10,32(sp)
ffffffffc0204230:	fc86                	sd	ra,120(sp)
ffffffffc0204232:	f8a2                	sd	s0,112(sp)
ffffffffc0204234:	f862                	sd	s8,48(sp)
ffffffffc0204236:	f466                	sd	s9,40(sp)
ffffffffc0204238:	ec6e                	sd	s11,24(sp)
ffffffffc020423a:	892a                	mv	s2,a0
ffffffffc020423c:	84ae                	mv	s1,a1
ffffffffc020423e:	8d32                	mv	s10,a2
ffffffffc0204240:	8a36                	mv	s4,a3
ffffffffc0204242:	02500993          	li	s3,37
ffffffffc0204246:	5b7d                	li	s6,-1
ffffffffc0204248:	00002a97          	auipc	s5,0x2
ffffffffc020424c:	274a8a93          	addi	s5,s5,628 # ffffffffc02064bc <default_pmm_manager+0x107c>
ffffffffc0204250:	00002b97          	auipc	s7,0x2
ffffffffc0204254:	448b8b93          	addi	s7,s7,1096 # ffffffffc0206698 <error_string>
ffffffffc0204258:	000d4503          	lbu	a0,0(s10) # 80000 <kern_entry-0xffffffffc0180000>
ffffffffc020425c:	001d0413          	addi	s0,s10,1
ffffffffc0204260:	01350a63          	beq	a0,s3,ffffffffc0204274 <vprintfmt+0x56>
ffffffffc0204264:	c121                	beqz	a0,ffffffffc02042a4 <vprintfmt+0x86>
ffffffffc0204266:	85a6                	mv	a1,s1
ffffffffc0204268:	0405                	addi	s0,s0,1
ffffffffc020426a:	9902                	jalr	s2
ffffffffc020426c:	fff44503          	lbu	a0,-1(s0)
ffffffffc0204270:	ff351ae3          	bne	a0,s3,ffffffffc0204264 <vprintfmt+0x46>
ffffffffc0204274:	00044603          	lbu	a2,0(s0)
ffffffffc0204278:	02000793          	li	a5,32
ffffffffc020427c:	4c81                	li	s9,0
ffffffffc020427e:	4881                	li	a7,0
ffffffffc0204280:	5c7d                	li	s8,-1
ffffffffc0204282:	5dfd                	li	s11,-1
ffffffffc0204284:	05500513          	li	a0,85
ffffffffc0204288:	4825                	li	a6,9
ffffffffc020428a:	fdd6059b          	addiw	a1,a2,-35
ffffffffc020428e:	0ff5f593          	zext.b	a1,a1
ffffffffc0204292:	00140d13          	addi	s10,s0,1
ffffffffc0204296:	04b56263          	bltu	a0,a1,ffffffffc02042da <vprintfmt+0xbc>
ffffffffc020429a:	058a                	slli	a1,a1,0x2
ffffffffc020429c:	95d6                	add	a1,a1,s5
ffffffffc020429e:	4194                	lw	a3,0(a1)
ffffffffc02042a0:	96d6                	add	a3,a3,s5
ffffffffc02042a2:	8682                	jr	a3
ffffffffc02042a4:	70e6                	ld	ra,120(sp)
ffffffffc02042a6:	7446                	ld	s0,112(sp)
ffffffffc02042a8:	74a6                	ld	s1,104(sp)
ffffffffc02042aa:	7906                	ld	s2,96(sp)
ffffffffc02042ac:	69e6                	ld	s3,88(sp)
ffffffffc02042ae:	6a46                	ld	s4,80(sp)
ffffffffc02042b0:	6aa6                	ld	s5,72(sp)
ffffffffc02042b2:	6b06                	ld	s6,64(sp)
ffffffffc02042b4:	7be2                	ld	s7,56(sp)
ffffffffc02042b6:	7c42                	ld	s8,48(sp)
ffffffffc02042b8:	7ca2                	ld	s9,40(sp)
ffffffffc02042ba:	7d02                	ld	s10,32(sp)
ffffffffc02042bc:	6de2                	ld	s11,24(sp)
ffffffffc02042be:	6109                	addi	sp,sp,128
ffffffffc02042c0:	8082                	ret
ffffffffc02042c2:	87b2                	mv	a5,a2
ffffffffc02042c4:	00144603          	lbu	a2,1(s0)
ffffffffc02042c8:	846a                	mv	s0,s10
ffffffffc02042ca:	00140d13          	addi	s10,s0,1
ffffffffc02042ce:	fdd6059b          	addiw	a1,a2,-35
ffffffffc02042d2:	0ff5f593          	zext.b	a1,a1
ffffffffc02042d6:	fcb572e3          	bgeu	a0,a1,ffffffffc020429a <vprintfmt+0x7c>
ffffffffc02042da:	85a6                	mv	a1,s1
ffffffffc02042dc:	02500513          	li	a0,37
ffffffffc02042e0:	9902                	jalr	s2
ffffffffc02042e2:	fff44783          	lbu	a5,-1(s0)
ffffffffc02042e6:	8d22                	mv	s10,s0
ffffffffc02042e8:	f73788e3          	beq	a5,s3,ffffffffc0204258 <vprintfmt+0x3a>
ffffffffc02042ec:	ffed4783          	lbu	a5,-2(s10)
ffffffffc02042f0:	1d7d                	addi	s10,s10,-1
ffffffffc02042f2:	ff379de3          	bne	a5,s3,ffffffffc02042ec <vprintfmt+0xce>
ffffffffc02042f6:	b78d                	j	ffffffffc0204258 <vprintfmt+0x3a>
ffffffffc02042f8:	fd060c1b          	addiw	s8,a2,-48
ffffffffc02042fc:	00144603          	lbu	a2,1(s0)
ffffffffc0204300:	846a                	mv	s0,s10
ffffffffc0204302:	fd06069b          	addiw	a3,a2,-48
ffffffffc0204306:	0006059b          	sext.w	a1,a2
ffffffffc020430a:	02d86463          	bltu	a6,a3,ffffffffc0204332 <vprintfmt+0x114>
ffffffffc020430e:	00144603          	lbu	a2,1(s0)
ffffffffc0204312:	002c169b          	slliw	a3,s8,0x2
ffffffffc0204316:	0186873b          	addw	a4,a3,s8
ffffffffc020431a:	0017171b          	slliw	a4,a4,0x1
ffffffffc020431e:	9f2d                	addw	a4,a4,a1
ffffffffc0204320:	fd06069b          	addiw	a3,a2,-48
ffffffffc0204324:	0405                	addi	s0,s0,1
ffffffffc0204326:	fd070c1b          	addiw	s8,a4,-48
ffffffffc020432a:	0006059b          	sext.w	a1,a2
ffffffffc020432e:	fed870e3          	bgeu	a6,a3,ffffffffc020430e <vprintfmt+0xf0>
ffffffffc0204332:	f40ddce3          	bgez	s11,ffffffffc020428a <vprintfmt+0x6c>
ffffffffc0204336:	8de2                	mv	s11,s8
ffffffffc0204338:	5c7d                	li	s8,-1
ffffffffc020433a:	bf81                	j	ffffffffc020428a <vprintfmt+0x6c>
ffffffffc020433c:	fffdc693          	not	a3,s11
ffffffffc0204340:	96fd                	srai	a3,a3,0x3f
ffffffffc0204342:	00ddfdb3          	and	s11,s11,a3
ffffffffc0204346:	00144603          	lbu	a2,1(s0)
ffffffffc020434a:	2d81                	sext.w	s11,s11
ffffffffc020434c:	846a                	mv	s0,s10
ffffffffc020434e:	bf35                	j	ffffffffc020428a <vprintfmt+0x6c>
ffffffffc0204350:	000a2c03          	lw	s8,0(s4)
ffffffffc0204354:	00144603          	lbu	a2,1(s0)
ffffffffc0204358:	0a21                	addi	s4,s4,8
ffffffffc020435a:	846a                	mv	s0,s10
ffffffffc020435c:	bfd9                	j	ffffffffc0204332 <vprintfmt+0x114>
ffffffffc020435e:	4705                	li	a4,1
ffffffffc0204360:	008a0593          	addi	a1,s4,8
ffffffffc0204364:	01174463          	blt	a4,a7,ffffffffc020436c <vprintfmt+0x14e>
ffffffffc0204368:	1a088e63          	beqz	a7,ffffffffc0204524 <vprintfmt+0x306>
ffffffffc020436c:	000a3603          	ld	a2,0(s4)
ffffffffc0204370:	46c1                	li	a3,16
ffffffffc0204372:	8a2e                	mv	s4,a1
ffffffffc0204374:	2781                	sext.w	a5,a5
ffffffffc0204376:	876e                	mv	a4,s11
ffffffffc0204378:	85a6                	mv	a1,s1
ffffffffc020437a:	854a                	mv	a0,s2
ffffffffc020437c:	e37ff0ef          	jal	ra,ffffffffc02041b2 <printnum>
ffffffffc0204380:	bde1                	j	ffffffffc0204258 <vprintfmt+0x3a>
ffffffffc0204382:	000a2503          	lw	a0,0(s4)
ffffffffc0204386:	85a6                	mv	a1,s1
ffffffffc0204388:	0a21                	addi	s4,s4,8
ffffffffc020438a:	9902                	jalr	s2
ffffffffc020438c:	b5f1                	j	ffffffffc0204258 <vprintfmt+0x3a>
ffffffffc020438e:	4705                	li	a4,1
ffffffffc0204390:	008a0593          	addi	a1,s4,8
ffffffffc0204394:	01174463          	blt	a4,a7,ffffffffc020439c <vprintfmt+0x17e>
ffffffffc0204398:	18088163          	beqz	a7,ffffffffc020451a <vprintfmt+0x2fc>
ffffffffc020439c:	000a3603          	ld	a2,0(s4)
ffffffffc02043a0:	46a9                	li	a3,10
ffffffffc02043a2:	8a2e                	mv	s4,a1
ffffffffc02043a4:	bfc1                	j	ffffffffc0204374 <vprintfmt+0x156>
ffffffffc02043a6:	00144603          	lbu	a2,1(s0)
ffffffffc02043aa:	4c85                	li	s9,1
ffffffffc02043ac:	846a                	mv	s0,s10
ffffffffc02043ae:	bdf1                	j	ffffffffc020428a <vprintfmt+0x6c>
ffffffffc02043b0:	85a6                	mv	a1,s1
ffffffffc02043b2:	02500513          	li	a0,37
ffffffffc02043b6:	9902                	jalr	s2
ffffffffc02043b8:	b545                	j	ffffffffc0204258 <vprintfmt+0x3a>
ffffffffc02043ba:	00144603          	lbu	a2,1(s0)
ffffffffc02043be:	2885                	addiw	a7,a7,1
ffffffffc02043c0:	846a                	mv	s0,s10
ffffffffc02043c2:	b5e1                	j	ffffffffc020428a <vprintfmt+0x6c>
ffffffffc02043c4:	4705                	li	a4,1
ffffffffc02043c6:	008a0593          	addi	a1,s4,8
ffffffffc02043ca:	01174463          	blt	a4,a7,ffffffffc02043d2 <vprintfmt+0x1b4>
ffffffffc02043ce:	14088163          	beqz	a7,ffffffffc0204510 <vprintfmt+0x2f2>
ffffffffc02043d2:	000a3603          	ld	a2,0(s4)
ffffffffc02043d6:	46a1                	li	a3,8
ffffffffc02043d8:	8a2e                	mv	s4,a1
ffffffffc02043da:	bf69                	j	ffffffffc0204374 <vprintfmt+0x156>
ffffffffc02043dc:	03000513          	li	a0,48
ffffffffc02043e0:	85a6                	mv	a1,s1
ffffffffc02043e2:	e03e                	sd	a5,0(sp)
ffffffffc02043e4:	9902                	jalr	s2
ffffffffc02043e6:	85a6                	mv	a1,s1
ffffffffc02043e8:	07800513          	li	a0,120
ffffffffc02043ec:	9902                	jalr	s2
ffffffffc02043ee:	0a21                	addi	s4,s4,8
ffffffffc02043f0:	6782                	ld	a5,0(sp)
ffffffffc02043f2:	46c1                	li	a3,16
ffffffffc02043f4:	ff8a3603          	ld	a2,-8(s4)
ffffffffc02043f8:	bfb5                	j	ffffffffc0204374 <vprintfmt+0x156>
ffffffffc02043fa:	000a3403          	ld	s0,0(s4)
ffffffffc02043fe:	008a0713          	addi	a4,s4,8
ffffffffc0204402:	e03a                	sd	a4,0(sp)
ffffffffc0204404:	14040263          	beqz	s0,ffffffffc0204548 <vprintfmt+0x32a>
ffffffffc0204408:	0fb05763          	blez	s11,ffffffffc02044f6 <vprintfmt+0x2d8>
ffffffffc020440c:	02d00693          	li	a3,45
ffffffffc0204410:	0cd79163          	bne	a5,a3,ffffffffc02044d2 <vprintfmt+0x2b4>
ffffffffc0204414:	00044783          	lbu	a5,0(s0)
ffffffffc0204418:	0007851b          	sext.w	a0,a5
ffffffffc020441c:	cf85                	beqz	a5,ffffffffc0204454 <vprintfmt+0x236>
ffffffffc020441e:	00140a13          	addi	s4,s0,1
ffffffffc0204422:	05e00413          	li	s0,94
ffffffffc0204426:	000c4563          	bltz	s8,ffffffffc0204430 <vprintfmt+0x212>
ffffffffc020442a:	3c7d                	addiw	s8,s8,-1
ffffffffc020442c:	036c0263          	beq	s8,s6,ffffffffc0204450 <vprintfmt+0x232>
ffffffffc0204430:	85a6                	mv	a1,s1
ffffffffc0204432:	0e0c8e63          	beqz	s9,ffffffffc020452e <vprintfmt+0x310>
ffffffffc0204436:	3781                	addiw	a5,a5,-32
ffffffffc0204438:	0ef47b63          	bgeu	s0,a5,ffffffffc020452e <vprintfmt+0x310>
ffffffffc020443c:	03f00513          	li	a0,63
ffffffffc0204440:	9902                	jalr	s2
ffffffffc0204442:	000a4783          	lbu	a5,0(s4)
ffffffffc0204446:	3dfd                	addiw	s11,s11,-1
ffffffffc0204448:	0a05                	addi	s4,s4,1
ffffffffc020444a:	0007851b          	sext.w	a0,a5
ffffffffc020444e:	ffe1                	bnez	a5,ffffffffc0204426 <vprintfmt+0x208>
ffffffffc0204450:	01b05963          	blez	s11,ffffffffc0204462 <vprintfmt+0x244>
ffffffffc0204454:	3dfd                	addiw	s11,s11,-1
ffffffffc0204456:	85a6                	mv	a1,s1
ffffffffc0204458:	02000513          	li	a0,32
ffffffffc020445c:	9902                	jalr	s2
ffffffffc020445e:	fe0d9be3          	bnez	s11,ffffffffc0204454 <vprintfmt+0x236>
ffffffffc0204462:	6a02                	ld	s4,0(sp)
ffffffffc0204464:	bbd5                	j	ffffffffc0204258 <vprintfmt+0x3a>
ffffffffc0204466:	4705                	li	a4,1
ffffffffc0204468:	008a0c93          	addi	s9,s4,8
ffffffffc020446c:	01174463          	blt	a4,a7,ffffffffc0204474 <vprintfmt+0x256>
ffffffffc0204470:	08088d63          	beqz	a7,ffffffffc020450a <vprintfmt+0x2ec>
ffffffffc0204474:	000a3403          	ld	s0,0(s4)
ffffffffc0204478:	0a044d63          	bltz	s0,ffffffffc0204532 <vprintfmt+0x314>
ffffffffc020447c:	8622                	mv	a2,s0
ffffffffc020447e:	8a66                	mv	s4,s9
ffffffffc0204480:	46a9                	li	a3,10
ffffffffc0204482:	bdcd                	j	ffffffffc0204374 <vprintfmt+0x156>
ffffffffc0204484:	000a2783          	lw	a5,0(s4)
ffffffffc0204488:	4719                	li	a4,6
ffffffffc020448a:	0a21                	addi	s4,s4,8
ffffffffc020448c:	41f7d69b          	sraiw	a3,a5,0x1f
ffffffffc0204490:	8fb5                	xor	a5,a5,a3
ffffffffc0204492:	40d786bb          	subw	a3,a5,a3
ffffffffc0204496:	02d74163          	blt	a4,a3,ffffffffc02044b8 <vprintfmt+0x29a>
ffffffffc020449a:	00369793          	slli	a5,a3,0x3
ffffffffc020449e:	97de                	add	a5,a5,s7
ffffffffc02044a0:	639c                	ld	a5,0(a5)
ffffffffc02044a2:	cb99                	beqz	a5,ffffffffc02044b8 <vprintfmt+0x29a>
ffffffffc02044a4:	86be                	mv	a3,a5
ffffffffc02044a6:	00002617          	auipc	a2,0x2
ffffffffc02044aa:	01260613          	addi	a2,a2,18 # ffffffffc02064b8 <default_pmm_manager+0x1078>
ffffffffc02044ae:	85a6                	mv	a1,s1
ffffffffc02044b0:	854a                	mv	a0,s2
ffffffffc02044b2:	0ce000ef          	jal	ra,ffffffffc0204580 <printfmt>
ffffffffc02044b6:	b34d                	j	ffffffffc0204258 <vprintfmt+0x3a>
ffffffffc02044b8:	00002617          	auipc	a2,0x2
ffffffffc02044bc:	ff060613          	addi	a2,a2,-16 # ffffffffc02064a8 <default_pmm_manager+0x1068>
ffffffffc02044c0:	85a6                	mv	a1,s1
ffffffffc02044c2:	854a                	mv	a0,s2
ffffffffc02044c4:	0bc000ef          	jal	ra,ffffffffc0204580 <printfmt>
ffffffffc02044c8:	bb41                	j	ffffffffc0204258 <vprintfmt+0x3a>
ffffffffc02044ca:	00002417          	auipc	s0,0x2
ffffffffc02044ce:	fd640413          	addi	s0,s0,-42 # ffffffffc02064a0 <default_pmm_manager+0x1060>
ffffffffc02044d2:	85e2                	mv	a1,s8
ffffffffc02044d4:	8522                	mv	a0,s0
ffffffffc02044d6:	e43e                	sd	a5,8(sp)
ffffffffc02044d8:	196000ef          	jal	ra,ffffffffc020466e <strnlen>
ffffffffc02044dc:	40ad8dbb          	subw	s11,s11,a0
ffffffffc02044e0:	01b05b63          	blez	s11,ffffffffc02044f6 <vprintfmt+0x2d8>
ffffffffc02044e4:	67a2                	ld	a5,8(sp)
ffffffffc02044e6:	00078a1b          	sext.w	s4,a5
ffffffffc02044ea:	3dfd                	addiw	s11,s11,-1
ffffffffc02044ec:	85a6                	mv	a1,s1
ffffffffc02044ee:	8552                	mv	a0,s4
ffffffffc02044f0:	9902                	jalr	s2
ffffffffc02044f2:	fe0d9ce3          	bnez	s11,ffffffffc02044ea <vprintfmt+0x2cc>
ffffffffc02044f6:	00044783          	lbu	a5,0(s0)
ffffffffc02044fa:	00140a13          	addi	s4,s0,1
ffffffffc02044fe:	0007851b          	sext.w	a0,a5
ffffffffc0204502:	d3a5                	beqz	a5,ffffffffc0204462 <vprintfmt+0x244>
ffffffffc0204504:	05e00413          	li	s0,94
ffffffffc0204508:	bf39                	j	ffffffffc0204426 <vprintfmt+0x208>
ffffffffc020450a:	000a2403          	lw	s0,0(s4)
ffffffffc020450e:	b7ad                	j	ffffffffc0204478 <vprintfmt+0x25a>
ffffffffc0204510:	000a6603          	lwu	a2,0(s4)
ffffffffc0204514:	46a1                	li	a3,8
ffffffffc0204516:	8a2e                	mv	s4,a1
ffffffffc0204518:	bdb1                	j	ffffffffc0204374 <vprintfmt+0x156>
ffffffffc020451a:	000a6603          	lwu	a2,0(s4)
ffffffffc020451e:	46a9                	li	a3,10
ffffffffc0204520:	8a2e                	mv	s4,a1
ffffffffc0204522:	bd89                	j	ffffffffc0204374 <vprintfmt+0x156>
ffffffffc0204524:	000a6603          	lwu	a2,0(s4)
ffffffffc0204528:	46c1                	li	a3,16
ffffffffc020452a:	8a2e                	mv	s4,a1
ffffffffc020452c:	b5a1                	j	ffffffffc0204374 <vprintfmt+0x156>
ffffffffc020452e:	9902                	jalr	s2
ffffffffc0204530:	bf09                	j	ffffffffc0204442 <vprintfmt+0x224>
ffffffffc0204532:	85a6                	mv	a1,s1
ffffffffc0204534:	02d00513          	li	a0,45
ffffffffc0204538:	e03e                	sd	a5,0(sp)
ffffffffc020453a:	9902                	jalr	s2
ffffffffc020453c:	6782                	ld	a5,0(sp)
ffffffffc020453e:	8a66                	mv	s4,s9
ffffffffc0204540:	40800633          	neg	a2,s0
ffffffffc0204544:	46a9                	li	a3,10
ffffffffc0204546:	b53d                	j	ffffffffc0204374 <vprintfmt+0x156>
ffffffffc0204548:	03b05163          	blez	s11,ffffffffc020456a <vprintfmt+0x34c>
ffffffffc020454c:	02d00693          	li	a3,45
ffffffffc0204550:	f6d79de3          	bne	a5,a3,ffffffffc02044ca <vprintfmt+0x2ac>
ffffffffc0204554:	00002417          	auipc	s0,0x2
ffffffffc0204558:	f4c40413          	addi	s0,s0,-180 # ffffffffc02064a0 <default_pmm_manager+0x1060>
ffffffffc020455c:	02800793          	li	a5,40
ffffffffc0204560:	02800513          	li	a0,40
ffffffffc0204564:	00140a13          	addi	s4,s0,1
ffffffffc0204568:	bd6d                	j	ffffffffc0204422 <vprintfmt+0x204>
ffffffffc020456a:	00002a17          	auipc	s4,0x2
ffffffffc020456e:	f37a0a13          	addi	s4,s4,-201 # ffffffffc02064a1 <default_pmm_manager+0x1061>
ffffffffc0204572:	02800513          	li	a0,40
ffffffffc0204576:	02800793          	li	a5,40
ffffffffc020457a:	05e00413          	li	s0,94
ffffffffc020457e:	b565                	j	ffffffffc0204426 <vprintfmt+0x208>

ffffffffc0204580 <printfmt>:
ffffffffc0204580:	715d                	addi	sp,sp,-80
ffffffffc0204582:	02810313          	addi	t1,sp,40
ffffffffc0204586:	f436                	sd	a3,40(sp)
ffffffffc0204588:	869a                	mv	a3,t1
ffffffffc020458a:	ec06                	sd	ra,24(sp)
ffffffffc020458c:	f83a                	sd	a4,48(sp)
ffffffffc020458e:	fc3e                	sd	a5,56(sp)
ffffffffc0204590:	e0c2                	sd	a6,64(sp)
ffffffffc0204592:	e4c6                	sd	a7,72(sp)
ffffffffc0204594:	e41a                	sd	t1,8(sp)
ffffffffc0204596:	c89ff0ef          	jal	ra,ffffffffc020421e <vprintfmt>
ffffffffc020459a:	60e2                	ld	ra,24(sp)
ffffffffc020459c:	6161                	addi	sp,sp,80
ffffffffc020459e:	8082                	ret

ffffffffc02045a0 <readline>:
ffffffffc02045a0:	715d                	addi	sp,sp,-80
ffffffffc02045a2:	e486                	sd	ra,72(sp)
ffffffffc02045a4:	e0a6                	sd	s1,64(sp)
ffffffffc02045a6:	fc4a                	sd	s2,56(sp)
ffffffffc02045a8:	f84e                	sd	s3,48(sp)
ffffffffc02045aa:	f452                	sd	s4,40(sp)
ffffffffc02045ac:	f056                	sd	s5,32(sp)
ffffffffc02045ae:	ec5a                	sd	s6,24(sp)
ffffffffc02045b0:	e85e                	sd	s7,16(sp)
ffffffffc02045b2:	c901                	beqz	a0,ffffffffc02045c2 <readline+0x22>
ffffffffc02045b4:	85aa                	mv	a1,a0
ffffffffc02045b6:	00002517          	auipc	a0,0x2
ffffffffc02045ba:	f0250513          	addi	a0,a0,-254 # ffffffffc02064b8 <default_pmm_manager+0x1078>
ffffffffc02045be:	afdfb0ef          	jal	ra,ffffffffc02000ba <cprintf>
ffffffffc02045c2:	4481                	li	s1,0
ffffffffc02045c4:	497d                	li	s2,31
ffffffffc02045c6:	49a1                	li	s3,8
ffffffffc02045c8:	4aa9                	li	s5,10
ffffffffc02045ca:	4b35                	li	s6,13
ffffffffc02045cc:	0000db97          	auipc	s7,0xd
ffffffffc02045d0:	b2cb8b93          	addi	s7,s7,-1236 # ffffffffc02110f8 <buf>
ffffffffc02045d4:	3fe00a13          	li	s4,1022
ffffffffc02045d8:	b1bfb0ef          	jal	ra,ffffffffc02000f2 <getchar>
ffffffffc02045dc:	00054a63          	bltz	a0,ffffffffc02045f0 <readline+0x50>
ffffffffc02045e0:	00a95a63          	bge	s2,a0,ffffffffc02045f4 <readline+0x54>
ffffffffc02045e4:	029a5263          	bge	s4,s1,ffffffffc0204608 <readline+0x68>
ffffffffc02045e8:	b0bfb0ef          	jal	ra,ffffffffc02000f2 <getchar>
ffffffffc02045ec:	fe055ae3          	bgez	a0,ffffffffc02045e0 <readline+0x40>
ffffffffc02045f0:	4501                	li	a0,0
ffffffffc02045f2:	a091                	j	ffffffffc0204636 <readline+0x96>
ffffffffc02045f4:	03351463          	bne	a0,s3,ffffffffc020461c <readline+0x7c>
ffffffffc02045f8:	e8a9                	bnez	s1,ffffffffc020464a <readline+0xaa>
ffffffffc02045fa:	af9fb0ef          	jal	ra,ffffffffc02000f2 <getchar>
ffffffffc02045fe:	fe0549e3          	bltz	a0,ffffffffc02045f0 <readline+0x50>
ffffffffc0204602:	fea959e3          	bge	s2,a0,ffffffffc02045f4 <readline+0x54>
ffffffffc0204606:	4481                	li	s1,0
ffffffffc0204608:	e42a                	sd	a0,8(sp)
ffffffffc020460a:	ae7fb0ef          	jal	ra,ffffffffc02000f0 <cputchar>
ffffffffc020460e:	6522                	ld	a0,8(sp)
ffffffffc0204610:	009b87b3          	add	a5,s7,s1
ffffffffc0204614:	2485                	addiw	s1,s1,1
ffffffffc0204616:	00a78023          	sb	a0,0(a5)
ffffffffc020461a:	bf7d                	j	ffffffffc02045d8 <readline+0x38>
ffffffffc020461c:	01550463          	beq	a0,s5,ffffffffc0204624 <readline+0x84>
ffffffffc0204620:	fb651ce3          	bne	a0,s6,ffffffffc02045d8 <readline+0x38>
ffffffffc0204624:	acdfb0ef          	jal	ra,ffffffffc02000f0 <cputchar>
ffffffffc0204628:	0000d517          	auipc	a0,0xd
ffffffffc020462c:	ad050513          	addi	a0,a0,-1328 # ffffffffc02110f8 <buf>
ffffffffc0204630:	94aa                	add	s1,s1,a0
ffffffffc0204632:	00048023          	sb	zero,0(s1)
ffffffffc0204636:	60a6                	ld	ra,72(sp)
ffffffffc0204638:	6486                	ld	s1,64(sp)
ffffffffc020463a:	7962                	ld	s2,56(sp)
ffffffffc020463c:	79c2                	ld	s3,48(sp)
ffffffffc020463e:	7a22                	ld	s4,40(sp)
ffffffffc0204640:	7a82                	ld	s5,32(sp)
ffffffffc0204642:	6b62                	ld	s6,24(sp)
ffffffffc0204644:	6bc2                	ld	s7,16(sp)
ffffffffc0204646:	6161                	addi	sp,sp,80
ffffffffc0204648:	8082                	ret
ffffffffc020464a:	4521                	li	a0,8
ffffffffc020464c:	aa5fb0ef          	jal	ra,ffffffffc02000f0 <cputchar>
ffffffffc0204650:	34fd                	addiw	s1,s1,-1
ffffffffc0204652:	b759                	j	ffffffffc02045d8 <readline+0x38>

ffffffffc0204654 <strlen>:
ffffffffc0204654:	00054783          	lbu	a5,0(a0)
ffffffffc0204658:	872a                	mv	a4,a0
ffffffffc020465a:	4501                	li	a0,0
ffffffffc020465c:	cb81                	beqz	a5,ffffffffc020466c <strlen+0x18>
ffffffffc020465e:	0505                	addi	a0,a0,1
ffffffffc0204660:	00a707b3          	add	a5,a4,a0
ffffffffc0204664:	0007c783          	lbu	a5,0(a5)
ffffffffc0204668:	fbfd                	bnez	a5,ffffffffc020465e <strlen+0xa>
ffffffffc020466a:	8082                	ret
ffffffffc020466c:	8082                	ret

ffffffffc020466e <strnlen>:
ffffffffc020466e:	4781                	li	a5,0
ffffffffc0204670:	e589                	bnez	a1,ffffffffc020467a <strnlen+0xc>
ffffffffc0204672:	a811                	j	ffffffffc0204686 <strnlen+0x18>
ffffffffc0204674:	0785                	addi	a5,a5,1
ffffffffc0204676:	00f58863          	beq	a1,a5,ffffffffc0204686 <strnlen+0x18>
ffffffffc020467a:	00f50733          	add	a4,a0,a5
ffffffffc020467e:	00074703          	lbu	a4,0(a4)
ffffffffc0204682:	fb6d                	bnez	a4,ffffffffc0204674 <strnlen+0x6>
ffffffffc0204684:	85be                	mv	a1,a5
ffffffffc0204686:	852e                	mv	a0,a1
ffffffffc0204688:	8082                	ret

ffffffffc020468a <strcpy>:
ffffffffc020468a:	87aa                	mv	a5,a0
ffffffffc020468c:	0005c703          	lbu	a4,0(a1)
ffffffffc0204690:	0785                	addi	a5,a5,1
ffffffffc0204692:	0585                	addi	a1,a1,1
ffffffffc0204694:	fee78fa3          	sb	a4,-1(a5)
ffffffffc0204698:	fb75                	bnez	a4,ffffffffc020468c <strcpy+0x2>
ffffffffc020469a:	8082                	ret

ffffffffc020469c <strcmp>:
ffffffffc020469c:	00054783          	lbu	a5,0(a0)
ffffffffc02046a0:	0005c703          	lbu	a4,0(a1)
ffffffffc02046a4:	cb89                	beqz	a5,ffffffffc02046b6 <strcmp+0x1a>
ffffffffc02046a6:	0505                	addi	a0,a0,1
ffffffffc02046a8:	0585                	addi	a1,a1,1
ffffffffc02046aa:	fee789e3          	beq	a5,a4,ffffffffc020469c <strcmp>
ffffffffc02046ae:	0007851b          	sext.w	a0,a5
ffffffffc02046b2:	9d19                	subw	a0,a0,a4
ffffffffc02046b4:	8082                	ret
ffffffffc02046b6:	4501                	li	a0,0
ffffffffc02046b8:	bfed                	j	ffffffffc02046b2 <strcmp+0x16>

ffffffffc02046ba <strchr>:
ffffffffc02046ba:	00054783          	lbu	a5,0(a0)
ffffffffc02046be:	c799                	beqz	a5,ffffffffc02046cc <strchr+0x12>
ffffffffc02046c0:	00f58763          	beq	a1,a5,ffffffffc02046ce <strchr+0x14>
ffffffffc02046c4:	00154783          	lbu	a5,1(a0)
ffffffffc02046c8:	0505                	addi	a0,a0,1
ffffffffc02046ca:	fbfd                	bnez	a5,ffffffffc02046c0 <strchr+0x6>
ffffffffc02046cc:	4501                	li	a0,0
ffffffffc02046ce:	8082                	ret

ffffffffc02046d0 <memset>:
ffffffffc02046d0:	ca01                	beqz	a2,ffffffffc02046e0 <memset+0x10>
ffffffffc02046d2:	962a                	add	a2,a2,a0
ffffffffc02046d4:	87aa                	mv	a5,a0
ffffffffc02046d6:	0785                	addi	a5,a5,1
ffffffffc02046d8:	feb78fa3          	sb	a1,-1(a5)
ffffffffc02046dc:	fec79de3          	bne	a5,a2,ffffffffc02046d6 <memset+0x6>
ffffffffc02046e0:	8082                	ret

ffffffffc02046e2 <memcpy>:
ffffffffc02046e2:	ca19                	beqz	a2,ffffffffc02046f8 <memcpy+0x16>
ffffffffc02046e4:	962e                	add	a2,a2,a1
ffffffffc02046e6:	87aa                	mv	a5,a0
ffffffffc02046e8:	0005c703          	lbu	a4,0(a1)
ffffffffc02046ec:	0585                	addi	a1,a1,1
ffffffffc02046ee:	0785                	addi	a5,a5,1
ffffffffc02046f0:	fee78fa3          	sb	a4,-1(a5)
ffffffffc02046f4:	fec59ae3          	bne	a1,a2,ffffffffc02046e8 <memcpy+0x6>
ffffffffc02046f8:	8082                	ret
