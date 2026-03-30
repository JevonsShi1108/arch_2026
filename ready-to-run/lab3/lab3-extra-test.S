
lab3-extra-test.elf:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_start>:
    80000000:	00009117          	auipc	sp,0x9
    80000004:	67010113          	addi	sp,sp,1648 # 80009670 <_stack_top>
    80000008:	00001297          	auipc	t0,0x1
    8000000c:	66828293          	addi	t0,t0,1640 # 80001670 <__bss_end>
    80000010:	00001317          	auipc	t1,0x1
    80000014:	66030313          	addi	t1,t1,1632 # 80001670 <__bss_end>
    80000018:	00628863          	beq	t0,t1,80000028 <_start+0x28>
    8000001c:	0002b023          	sd	zero,0(t0)
    80000020:	00828293          	addi	t0,t0,8
    80000024:	fe62ece3          	bltu	t0,t1,8000001c <_start+0x1c>
    80000028:	585000ef          	jal	80000dac <main>
    8000002c:	00000513          	li	a0,0
    80000030:	0005006b          	.insn	4, 0x0005006b
    80000034:	0000006f          	j	80000034 <_start+0x34>

0000000080000038 <_Z5put_iIyEvT_>:
    80000038:	fe010113          	addi	sp,sp,-32
    8000003c:	00810613          	addi	a2,sp,8
    80000040:	00000693          	li	a3,0
    80000044:	00a00593          	li	a1,10
    80000048:	00900893          	li	a7,9
    8000004c:	02b57733          	remu	a4,a0,a1
    80000050:	00160613          	addi	a2,a2,1
    80000054:	00050813          	mv	a6,a0
    80000058:	00068793          	mv	a5,a3
    8000005c:	0016869b          	addiw	a3,a3,1
    80000060:	0307071b          	addiw	a4,a4,48
    80000064:	fee60fa3          	sb	a4,-1(a2)
    80000068:	02b55533          	divu	a0,a0,a1
    8000006c:	ff08e0e3          	bltu	a7,a6,8000004c <_Z5put_iIyEvT_+0x14>
    80000070:	00810713          	addi	a4,sp,8
    80000074:	40600637          	lui	a2,0x40600
    80000078:	00f707b3          	add	a5,a4,a5
    8000007c:	fff70693          	addi	a3,a4,-1
    80000080:	00460613          	addi	a2,a2,4 # 40600004 <STACK_SIZE+0x405f8004>
    80000084:	0007c703          	lbu	a4,0(a5)
    80000088:	fff78793          	addi	a5,a5,-1
    8000008c:	00e60023          	sb	a4,0(a2)
    80000090:	fed79ae3          	bne	a5,a3,80000084 <_Z5put_iIyEvT_+0x4c>
    80000094:	02010113          	addi	sp,sp,32
    80000098:	00008067          	ret

000000008000009c <_Z14loadStateArrayPA4_cPKc>:
    8000009c:	00458593          	addi	a1,a1,4
    800000a0:	00450613          	addi	a2,a0,4
    800000a4:	ffc58793          	addi	a5,a1,-4
    800000a8:	00050713          	mv	a4,a0
    800000ac:	0007c683          	lbu	a3,0(a5)
    800000b0:	00178793          	addi	a5,a5,1
    800000b4:	00470713          	addi	a4,a4,4
    800000b8:	fed70e23          	sb	a3,-4(a4)
    800000bc:	feb798e3          	bne	a5,a1,800000ac <_Z14loadStateArrayPA4_cPKc+0x10>
    800000c0:	00150513          	addi	a0,a0,1
    800000c4:	00478593          	addi	a1,a5,4
    800000c8:	fcc51ee3          	bne	a0,a2,800000a4 <_Z14loadStateArrayPA4_cPKc+0x8>
    800000cc:	00000513          	li	a0,0
    800000d0:	00008067          	ret

00000000800000d4 <_Z15storeStateArrayPA4_cPc>:
    800000d4:	00458593          	addi	a1,a1,4
    800000d8:	00450613          	addi	a2,a0,4
    800000dc:	ffc58793          	addi	a5,a1,-4
    800000e0:	00050713          	mv	a4,a0
    800000e4:	00074683          	lbu	a3,0(a4)
    800000e8:	00178793          	addi	a5,a5,1
    800000ec:	00470713          	addi	a4,a4,4
    800000f0:	fed78fa3          	sb	a3,-1(a5)
    800000f4:	feb798e3          	bne	a5,a1,800000e4 <_Z15storeStateArrayPA4_cPc+0x10>
    800000f8:	00150513          	addi	a0,a0,1
    800000fc:	00478593          	addi	a1,a5,4
    80000100:	fcc51ee3          	bne	a0,a2,800000dc <_Z15storeStateArrayPA4_cPc+0x8>
    80000104:	00000513          	li	a0,0
    80000108:	00008067          	ret

000000008000010c <_Z12keyExpansionPKcjP6AesKey>:
    8000010c:	14050663          	beqz	a0,80000258 <_Z12keyExpansionPKcjP6AesKey+0x14c>
    80000110:	14060463          	beqz	a2,80000258 <_Z12keyExpansionPKcjP6AesKey+0x14c>
    80000114:	01000793          	li	a5,16
    80000118:	14f59063          	bne	a1,a5,80000258 <_Z12keyExpansionPKcjP6AesKey+0x14c>
    8000011c:	01050893          	addi	a7,a0,16
    80000120:	00060593          	mv	a1,a2
    80000124:	00054783          	lbu	a5,0(a0)
    80000128:	00154683          	lbu	a3,1(a0)
    8000012c:	00354803          	lbu	a6,3(a0)
    80000130:	00254703          	lbu	a4,2(a0)
    80000134:	0187979b          	slliw	a5,a5,0x18
    80000138:	0106969b          	slliw	a3,a3,0x10
    8000013c:	00d7e7b3          	or	a5,a5,a3
    80000140:	0107e7b3          	or	a5,a5,a6
    80000144:	0087171b          	slliw	a4,a4,0x8
    80000148:	00e7e7b3          	or	a5,a5,a4
    8000014c:	00f5a023          	sw	a5,0(a1)
    80000150:	00450513          	addi	a0,a0,4
    80000154:	00458593          	addi	a1,a1,4
    80000158:	fca896e3          	bne	a7,a0,80000124 <_Z12keyExpansionPKcjP6AesKey+0x18>
    8000015c:	00862583          	lw	a1,8(a2)
    80000160:	00462e83          	lw	t4,4(a2)
    80000164:	00c62703          	lw	a4,12(a2)
    80000168:	00062e03          	lw	t3,0(a2)
    8000016c:	01060693          	addi	a3,a2,16
    80000170:	00001317          	auipc	t1,0x1
    80000174:	28830313          	addi	t1,t1,648 # 800013f8 <_ZL4rcon>
    80000178:	00001f97          	auipc	t6,0x1
    8000017c:	2a8f8f93          	addi	t6,t6,680 # 80001420 <_ZZL20runCorrectnessChecksvE2pt>
    80000180:	00001897          	auipc	a7,0x1
    80000184:	2f088893          	addi	a7,a7,752 # 80001470 <S>
    80000188:	0ff77793          	zext.b	a5,a4
    8000018c:	0107581b          	srliw	a6,a4,0x10
    80000190:	01875f1b          	srliw	t5,a4,0x18
    80000194:	0087551b          	srliw	a0,a4,0x8
    80000198:	00f887b3          	add	a5,a7,a5
    8000019c:	0ff87813          	zext.b	a6,a6
    800001a0:	0007c783          	lbu	a5,0(a5)
    800001a4:	01e88f33          	add	t5,a7,t5
    800001a8:	01088833          	add	a6,a7,a6
    800001ac:	0ff57513          	zext.b	a0,a0
    800001b0:	000f4283          	lbu	t0,0(t5)
    800001b4:	00084803          	lbu	a6,0(a6)
    800001b8:	00a88533          	add	a0,a7,a0
    800001bc:	00054503          	lbu	a0,0(a0)
    800001c0:	0087979b          	slliw	a5,a5,0x8
    800001c4:	00032f03          	lw	t5,0(t1)
    800001c8:	0057c7b3          	xor	a5,a5,t0
    800001cc:	0188181b          	slliw	a6,a6,0x18
    800001d0:	0107c7b3          	xor	a5,a5,a6
    800001d4:	0105151b          	slliw	a0,a0,0x10
    800001d8:	00a7c7b3          	xor	a5,a5,a0
    800001dc:	01e7c7b3          	xor	a5,a5,t5
    800001e0:	01c7c7b3          	xor	a5,a5,t3
    800001e4:	00078e1b          	sext.w	t3,a5
    800001e8:	01de4eb3          	xor	t4,t3,t4
    800001ec:	00bec5b3          	xor	a1,t4,a1
    800001f0:	0005859b          	sext.w	a1,a1
    800001f4:	00b74733          	xor	a4,a4,a1
    800001f8:	01c6a023          	sw	t3,0(a3)
    800001fc:	01d6a223          	sw	t4,4(a3)
    80000200:	00b6a423          	sw	a1,8(a3)
    80000204:	00e6a623          	sw	a4,12(a3)
    80000208:	00430313          	addi	t1,t1,4
    8000020c:	01068693          	addi	a3,a3,16
    80000210:	f66f9ce3          	bne	t6,t1,80000188 <_Z12keyExpansionPKcjP6AesKey+0x7c>
    80000214:	00161893          	slli	a7,a2,0x1
    80000218:	0a060713          	addi	a4,a2,160
    8000021c:	15088893          	addi	a7,a7,336
    80000220:	ff060613          	addi	a2,a2,-16
    80000224:	01000813          	li	a6,16
    80000228:	40e88533          	sub	a0,a7,a4
    8000022c:	00000793          	li	a5,0
    80000230:	00f706b3          	add	a3,a4,a5
    80000234:	0006a583          	lw	a1,0(a3)
    80000238:	00f506b3          	add	a3,a0,a5
    8000023c:	00478793          	addi	a5,a5,4
    80000240:	00b6a023          	sw	a1,0(a3)
    80000244:	ff0796e3          	bne	a5,a6,80000230 <_Z12keyExpansionPKcjP6AesKey+0x124>
    80000248:	ff070713          	addi	a4,a4,-16
    8000024c:	fcc71ee3          	bne	a4,a2,80000228 <_Z12keyExpansionPKcjP6AesKey+0x11c>
    80000250:	00000513          	li	a0,0
    80000254:	00008067          	ret
    80000258:	fff00513          	li	a0,-1
    8000025c:	00008067          	ret

0000000080000260 <_Z11addRoundKeyPA4_cPKj>:
    80000260:	01800313          	li	t1,24
    80000264:	01058893          	addi	a7,a1,16
    80000268:	ff800e13          	li	t3,-8
    8000026c:	0003081b          	sext.w	a6,t1
    80000270:	00058713          	mv	a4,a1
    80000274:	00050793          	mv	a5,a0
    80000278:	00072603          	lw	a2,0(a4)
    8000027c:	0007c683          	lbu	a3,0(a5)
    80000280:	00470713          	addi	a4,a4,4
    80000284:	0106563b          	srlw	a2,a2,a6
    80000288:	00c6c6b3          	xor	a3,a3,a2
    8000028c:	00d78023          	sb	a3,0(a5)
    80000290:	00178793          	addi	a5,a5,1
    80000294:	fee892e3          	bne	a7,a4,80000278 <_Z11addRoundKeyPA4_cPKj+0x18>
    80000298:	ff83031b          	addiw	t1,t1,-8
    8000029c:	00450513          	addi	a0,a0,4
    800002a0:	fdc316e3          	bne	t1,t3,8000026c <_Z11addRoundKeyPA4_cPKj+0xc>
    800002a4:	00000513          	li	a0,0
    800002a8:	00008067          	ret

00000000800002ac <_Z8subBytesPA4_c>:
    800002ac:	00450693          	addi	a3,a0,4
    800002b0:	01450593          	addi	a1,a0,20
    800002b4:	00001617          	auipc	a2,0x1
    800002b8:	1bc60613          	addi	a2,a2,444 # 80001470 <S>
    800002bc:	ffc68793          	addi	a5,a3,-4
    800002c0:	0007c703          	lbu	a4,0(a5)
    800002c4:	00178793          	addi	a5,a5,1
    800002c8:	00e60733          	add	a4,a2,a4
    800002cc:	00074703          	lbu	a4,0(a4)
    800002d0:	fee78fa3          	sb	a4,-1(a5)
    800002d4:	fed796e3          	bne	a5,a3,800002c0 <_Z8subBytesPA4_c+0x14>
    800002d8:	00478693          	addi	a3,a5,4
    800002dc:	feb690e3          	bne	a3,a1,800002bc <_Z8subBytesPA4_c+0x10>
    800002e0:	00000513          	li	a0,0
    800002e4:	00008067          	ret

00000000800002e8 <_Z11invSubBytesPA4_c>:
    800002e8:	00450693          	addi	a3,a0,4
    800002ec:	01450593          	addi	a1,a0,20
    800002f0:	00001617          	auipc	a2,0x1
    800002f4:	18060613          	addi	a2,a2,384 # 80001470 <S>
    800002f8:	ffc68793          	addi	a5,a3,-4
    800002fc:	0007c703          	lbu	a4,0(a5)
    80000300:	00178793          	addi	a5,a5,1
    80000304:	00e60733          	add	a4,a2,a4
    80000308:	10074703          	lbu	a4,256(a4)
    8000030c:	fee78fa3          	sb	a4,-1(a5)
    80000310:	fed796e3          	bne	a5,a3,800002fc <_Z11invSubBytesPA4_c+0x14>
    80000314:	00478693          	addi	a3,a5,4
    80000318:	feb690e3          	bne	a3,a1,800002f8 <_Z11invSubBytesPA4_c+0x10>
    8000031c:	00000513          	li	a0,0
    80000320:	00008067          	ret

0000000080000324 <_Z9shiftRowsPA4_c>:
    80000324:	02000693          	li	a3,32
    80000328:	00054783          	lbu	a5,0(a0)
    8000032c:	00154603          	lbu	a2,1(a0)
    80000330:	00354583          	lbu	a1,3(a0)
    80000334:	00254703          	lbu	a4,2(a0)
    80000338:	0106161b          	slliw	a2,a2,0x10
    8000033c:	0187979b          	slliw	a5,a5,0x18
    80000340:	00c7e7b3          	or	a5,a5,a2
    80000344:	00b7e7b3          	or	a5,a5,a1
    80000348:	0087171b          	slliw	a4,a4,0x8
    8000034c:	40d0063b          	negw	a2,a3
    80000350:	00e7e7b3          	or	a5,a5,a4
    80000354:	00d7d73b          	srlw	a4,a5,a3
    80000358:	00c797bb          	sllw	a5,a5,a2
    8000035c:	00f767b3          	or	a5,a4,a5
    80000360:	0187d59b          	srliw	a1,a5,0x18
    80000364:	0107d61b          	srliw	a2,a5,0x10
    80000368:	0087d71b          	srliw	a4,a5,0x8
    8000036c:	00b50023          	sb	a1,0(a0)
    80000370:	00c500a3          	sb	a2,1(a0)
    80000374:	00e50123          	sb	a4,2(a0)
    80000378:	00f501a3          	sb	a5,3(a0)
    8000037c:	ff86869b          	addiw	a3,a3,-8
    80000380:	00450513          	addi	a0,a0,4
    80000384:	fa0692e3          	bnez	a3,80000328 <_Z9shiftRowsPA4_c+0x4>
    80000388:	00000513          	li	a0,0
    8000038c:	00008067          	ret

0000000080000390 <_Z12invShiftRowsPA4_c>:
    80000390:	02000693          	li	a3,32
    80000394:	00054783          	lbu	a5,0(a0)
    80000398:	00154603          	lbu	a2,1(a0)
    8000039c:	00354583          	lbu	a1,3(a0)
    800003a0:	00254703          	lbu	a4,2(a0)
    800003a4:	0106161b          	slliw	a2,a2,0x10
    800003a8:	0187979b          	slliw	a5,a5,0x18
    800003ac:	00c7e7b3          	or	a5,a5,a2
    800003b0:	00b7e7b3          	or	a5,a5,a1
    800003b4:	0087171b          	slliw	a4,a4,0x8
    800003b8:	40d0063b          	negw	a2,a3
    800003bc:	00e7e7b3          	or	a5,a5,a4
    800003c0:	00d7973b          	sllw	a4,a5,a3
    800003c4:	00c7d7bb          	srlw	a5,a5,a2
    800003c8:	00f767b3          	or	a5,a4,a5
    800003cc:	0187d59b          	srliw	a1,a5,0x18
    800003d0:	0107d61b          	srliw	a2,a5,0x10
    800003d4:	0087d71b          	srliw	a4,a5,0x8
    800003d8:	00b50023          	sb	a1,0(a0)
    800003dc:	00c500a3          	sb	a2,1(a0)
    800003e0:	00e50123          	sb	a4,2(a0)
    800003e4:	00f501a3          	sb	a5,3(a0)
    800003e8:	ff86869b          	addiw	a3,a3,-8
    800003ec:	00450513          	addi	a0,a0,4
    800003f0:	fa0692e3          	bnez	a3,80000394 <_Z12invShiftRowsPA4_c+0x4>
    800003f4:	00000513          	li	a0,0
    800003f8:	00008067          	ret

00000000800003fc <_Z4GMulcc>:
    800003fc:	00050713          	mv	a4,a0
    80000400:	00800693          	li	a3,8
    80000404:	00000513          	li	a0,0
    80000408:	00177793          	andi	a5,a4,1
    8000040c:	0185961b          	slliw	a2,a1,0x18
    80000410:	40f007bb          	negw	a5,a5
    80000414:	00f5f7b3          	and	a5,a1,a5
    80000418:	0015981b          	slliw	a6,a1,0x1
    8000041c:	4186561b          	sraiw	a2,a2,0x18
    80000420:	fff6869b          	addiw	a3,a3,-1
    80000424:	0fe87593          	andi	a1,a6,254
    80000428:	00f54533          	xor	a0,a0,a5
    8000042c:	00065463          	bgez	a2,80000434 <_Z4GMulcc+0x38>
    80000430:	01b5c593          	xori	a1,a1,27
    80000434:	00175713          	srli	a4,a4,0x1
    80000438:	fc0698e3          	bnez	a3,80000408 <_Z4GMulcc+0xc>
    8000043c:	00008067          	ret

0000000080000440 <_Z10mixColumnsPA4_c>:
    80000440:	fc010113          	addi	sp,sp,-64
    80000444:	00001797          	auipc	a5,0x1
    80000448:	00c7b783          	ld	a5,12(a5) # 80001450 <_ZZL20runCorrectnessChecksvE10expectedCt+0x10>
    8000044c:	00f13823          	sd	a5,16(sp)
    80000450:	010008b7          	lui	a7,0x1000
    80000454:	00001797          	auipc	a5,0x1
    80000458:	0047b783          	ld	a5,4(a5) # 80001458 <_ZZL20runCorrectnessChecksvE10expectedCt+0x18>
    8000045c:	02813c23          	sd	s0,56(sp)
    80000460:	02913823          	sd	s1,48(sp)
    80000464:	03213423          	sd	s2,40(sp)
    80000468:	00f13c23          	sd	a5,24(sp)
    8000046c:	01050313          	addi	t1,a0,16
    80000470:	00010813          	mv	a6,sp
    80000474:	00050713          	mv	a4,a0
    80000478:	fff88893          	addi	a7,a7,-1 # ffffff <STACK_SIZE+0xff7fff>
    8000047c:	00174583          	lbu	a1,1(a4)
    80000480:	00274603          	lbu	a2,2(a4)
    80000484:	00074783          	lbu	a5,0(a4)
    80000488:	00374683          	lbu	a3,3(a4)
    8000048c:	0085959b          	slliw	a1,a1,0x8
    80000490:	00b7e7b3          	or	a5,a5,a1
    80000494:	0106161b          	slliw	a2,a2,0x10
    80000498:	00c7e7b3          	or	a5,a5,a2
    8000049c:	0186969b          	slliw	a3,a3,0x18
    800004a0:	0117f7b3          	and	a5,a5,a7
    800004a4:	00d7e7b3          	or	a5,a5,a3
    800004a8:	00f82023          	sw	a5,0(a6)
    800004ac:	00470713          	addi	a4,a4,4
    800004b0:	00480813          	addi	a6,a6,4
    800004b4:	fce314e3          	bne	t1,a4,8000047c <_Z10mixColumnsPA4_c+0x3c>
    800004b8:	01010593          	addi	a1,sp,16
    800004bc:	02010f13          	addi	t5,sp,32
    800004c0:	00410e93          	addi	t4,sp,4
    800004c4:	0005ce03          	lbu	t3,0(a1)
    800004c8:	0015c303          	lbu	t1,1(a1)
    800004cc:	0025c883          	lbu	a7,2(a1)
    800004d0:	0035c803          	lbu	a6,3(a1)
    800004d4:	00050613          	mv	a2,a0
    800004d8:	00010693          	mv	a3,sp
    800004dc:	0006cf83          	lbu	t6,0(a3)
    800004e0:	000e0713          	mv	a4,t3
    800004e4:	00800293          	li	t0,8
    800004e8:	00000413          	li	s0,0
    800004ec:	00177793          	andi	a5,a4,1
    800004f0:	018f939b          	slliw	t2,t6,0x18
    800004f4:	40f007bb          	negw	a5,a5
    800004f8:	00fff7b3          	and	a5,t6,a5
    800004fc:	001f949b          	slliw	s1,t6,0x1
    80000500:	4183d39b          	sraiw	t2,t2,0x18
    80000504:	0017571b          	srliw	a4,a4,0x1
    80000508:	fff2829b          	addiw	t0,t0,-1
    8000050c:	0fe4ff93          	andi	t6,s1,254
    80000510:	00f44433          	xor	s0,s0,a5
    80000514:	0003d463          	bgez	t2,8000051c <_Z10mixColumnsPA4_c+0xdc>
    80000518:	01bfcf93          	xori	t6,t6,27
    8000051c:	0ff77713          	zext.b	a4,a4
    80000520:	fc0296e3          	bnez	t0,800004ec <_Z10mixColumnsPA4_c+0xac>
    80000524:	0046cf83          	lbu	t6,4(a3)
    80000528:	00030713          	mv	a4,t1
    8000052c:	00800393          	li	t2,8
    80000530:	00177793          	andi	a5,a4,1
    80000534:	018f949b          	slliw	s1,t6,0x18
    80000538:	40f007bb          	negw	a5,a5
    8000053c:	00fff7b3          	and	a5,t6,a5
    80000540:	001f991b          	slliw	s2,t6,0x1
    80000544:	4184d49b          	sraiw	s1,s1,0x18
    80000548:	0017571b          	srliw	a4,a4,0x1
    8000054c:	fff3839b          	addiw	t2,t2,-1
    80000550:	0fe97f93          	andi	t6,s2,254
    80000554:	00f2c2b3          	xor	t0,t0,a5
    80000558:	0004d463          	bgez	s1,80000560 <_Z10mixColumnsPA4_c+0x120>
    8000055c:	01bfcf93          	xori	t6,t6,27
    80000560:	0ff77713          	zext.b	a4,a4
    80000564:	fc0396e3          	bnez	t2,80000530 <_Z10mixColumnsPA4_c+0xf0>
    80000568:	0086cf83          	lbu	t6,8(a3)
    8000056c:	0082c2b3          	xor	t0,t0,s0
    80000570:	00088713          	mv	a4,a7
    80000574:	00800393          	li	t2,8
    80000578:	00000413          	li	s0,0
    8000057c:	00177793          	andi	a5,a4,1
    80000580:	018f949b          	slliw	s1,t6,0x18
    80000584:	40f007bb          	negw	a5,a5
    80000588:	00fff7b3          	and	a5,t6,a5
    8000058c:	001f991b          	slliw	s2,t6,0x1
    80000590:	4184d49b          	sraiw	s1,s1,0x18
    80000594:	0017571b          	srliw	a4,a4,0x1
    80000598:	fff3839b          	addiw	t2,t2,-1
    8000059c:	0fe97f93          	andi	t6,s2,254
    800005a0:	00f44433          	xor	s0,s0,a5
    800005a4:	0004d463          	bgez	s1,800005ac <_Z10mixColumnsPA4_c+0x16c>
    800005a8:	01bfcf93          	xori	t6,t6,27
    800005ac:	0ff77713          	zext.b	a4,a4
    800005b0:	fc0396e3          	bnez	t2,8000057c <_Z10mixColumnsPA4_c+0x13c>
    800005b4:	00c6cf83          	lbu	t6,12(a3)
    800005b8:	0082c2b3          	xor	t0,t0,s0
    800005bc:	0ff2f293          	zext.b	t0,t0
    800005c0:	00080713          	mv	a4,a6
    800005c4:	00800393          	li	t2,8
    800005c8:	00000413          	li	s0,0
    800005cc:	00177793          	andi	a5,a4,1
    800005d0:	018f949b          	slliw	s1,t6,0x18
    800005d4:	40f007bb          	negw	a5,a5
    800005d8:	00fff7b3          	and	a5,t6,a5
    800005dc:	001f991b          	slliw	s2,t6,0x1
    800005e0:	4184d49b          	sraiw	s1,s1,0x18
    800005e4:	0017571b          	srliw	a4,a4,0x1
    800005e8:	fff3839b          	addiw	t2,t2,-1
    800005ec:	0fe97f93          	andi	t6,s2,254
    800005f0:	00f44433          	xor	s0,s0,a5
    800005f4:	0004d463          	bgez	s1,800005fc <_Z10mixColumnsPA4_c+0x1bc>
    800005f8:	01bfcf93          	xori	t6,t6,27
    800005fc:	0ff77713          	zext.b	a4,a4
    80000600:	fc0396e3          	bnez	t2,800005cc <_Z10mixColumnsPA4_c+0x18c>
    80000604:	0082c7b3          	xor	a5,t0,s0
    80000608:	00f60023          	sb	a5,0(a2)
    8000060c:	00168693          	addi	a3,a3,1
    80000610:	00160613          	addi	a2,a2,1
    80000614:	ecde94e3          	bne	t4,a3,800004dc <_Z10mixColumnsPA4_c+0x9c>
    80000618:	00458593          	addi	a1,a1,4
    8000061c:	00450513          	addi	a0,a0,4
    80000620:	ebe592e3          	bne	a1,t5,800004c4 <_Z10mixColumnsPA4_c+0x84>
    80000624:	03813403          	ld	s0,56(sp)
    80000628:	03013483          	ld	s1,48(sp)
    8000062c:	02813903          	ld	s2,40(sp)
    80000630:	00000513          	li	a0,0
    80000634:	04010113          	addi	sp,sp,64
    80000638:	00008067          	ret

000000008000063c <_Z13invMixColumnsPA4_c>:
    8000063c:	fc010113          	addi	sp,sp,-64
    80000640:	00001797          	auipc	a5,0x1
    80000644:	e207b783          	ld	a5,-480(a5) # 80001460 <_ZZL20runCorrectnessChecksvE10expectedCt+0x20>
    80000648:	00f13823          	sd	a5,16(sp)
    8000064c:	010008b7          	lui	a7,0x1000
    80000650:	00001797          	auipc	a5,0x1
    80000654:	e187b783          	ld	a5,-488(a5) # 80001468 <_ZZL20runCorrectnessChecksvE10expectedCt+0x28>
    80000658:	02813c23          	sd	s0,56(sp)
    8000065c:	02913823          	sd	s1,48(sp)
    80000660:	03213423          	sd	s2,40(sp)
    80000664:	00f13c23          	sd	a5,24(sp)
    80000668:	01050313          	addi	t1,a0,16
    8000066c:	00010813          	mv	a6,sp
    80000670:	00050713          	mv	a4,a0
    80000674:	fff88893          	addi	a7,a7,-1 # ffffff <STACK_SIZE+0xff7fff>
    80000678:	00174583          	lbu	a1,1(a4)
    8000067c:	00274603          	lbu	a2,2(a4)
    80000680:	00074783          	lbu	a5,0(a4)
    80000684:	00374683          	lbu	a3,3(a4)
    80000688:	0085959b          	slliw	a1,a1,0x8
    8000068c:	00b7e7b3          	or	a5,a5,a1
    80000690:	0106161b          	slliw	a2,a2,0x10
    80000694:	00c7e7b3          	or	a5,a5,a2
    80000698:	0186969b          	slliw	a3,a3,0x18
    8000069c:	0117f7b3          	and	a5,a5,a7
    800006a0:	00d7e7b3          	or	a5,a5,a3
    800006a4:	00f82023          	sw	a5,0(a6)
    800006a8:	00470713          	addi	a4,a4,4
    800006ac:	00480813          	addi	a6,a6,4
    800006b0:	fce314e3          	bne	t1,a4,80000678 <_Z13invMixColumnsPA4_c+0x3c>
    800006b4:	01010593          	addi	a1,sp,16
    800006b8:	02010f13          	addi	t5,sp,32
    800006bc:	00410e93          	addi	t4,sp,4
    800006c0:	0005ce03          	lbu	t3,0(a1)
    800006c4:	0015c303          	lbu	t1,1(a1)
    800006c8:	0025c883          	lbu	a7,2(a1)
    800006cc:	0035c803          	lbu	a6,3(a1)
    800006d0:	00050613          	mv	a2,a0
    800006d4:	00010693          	mv	a3,sp
    800006d8:	0006cf83          	lbu	t6,0(a3)
    800006dc:	000e0713          	mv	a4,t3
    800006e0:	00800293          	li	t0,8
    800006e4:	00000413          	li	s0,0
    800006e8:	00177793          	andi	a5,a4,1
    800006ec:	018f939b          	slliw	t2,t6,0x18
    800006f0:	40f007bb          	negw	a5,a5
    800006f4:	00fff7b3          	and	a5,t6,a5
    800006f8:	001f949b          	slliw	s1,t6,0x1
    800006fc:	4183d39b          	sraiw	t2,t2,0x18
    80000700:	0017571b          	srliw	a4,a4,0x1
    80000704:	fff2829b          	addiw	t0,t0,-1
    80000708:	0fe4ff93          	andi	t6,s1,254
    8000070c:	00f44433          	xor	s0,s0,a5
    80000710:	0003d463          	bgez	t2,80000718 <_Z13invMixColumnsPA4_c+0xdc>
    80000714:	01bfcf93          	xori	t6,t6,27
    80000718:	0ff77713          	zext.b	a4,a4
    8000071c:	fc0296e3          	bnez	t0,800006e8 <_Z13invMixColumnsPA4_c+0xac>
    80000720:	0046cf83          	lbu	t6,4(a3)
    80000724:	00030713          	mv	a4,t1
    80000728:	00800393          	li	t2,8
    8000072c:	00177793          	andi	a5,a4,1
    80000730:	018f949b          	slliw	s1,t6,0x18
    80000734:	40f007bb          	negw	a5,a5
    80000738:	00fff7b3          	and	a5,t6,a5
    8000073c:	001f991b          	slliw	s2,t6,0x1
    80000740:	4184d49b          	sraiw	s1,s1,0x18
    80000744:	0017571b          	srliw	a4,a4,0x1
    80000748:	fff3839b          	addiw	t2,t2,-1
    8000074c:	0fe97f93          	andi	t6,s2,254
    80000750:	00f2c2b3          	xor	t0,t0,a5
    80000754:	0004d463          	bgez	s1,8000075c <_Z13invMixColumnsPA4_c+0x120>
    80000758:	01bfcf93          	xori	t6,t6,27
    8000075c:	0ff77713          	zext.b	a4,a4
    80000760:	fc0396e3          	bnez	t2,8000072c <_Z13invMixColumnsPA4_c+0xf0>
    80000764:	0086cf83          	lbu	t6,8(a3)
    80000768:	0082c2b3          	xor	t0,t0,s0
    8000076c:	00088713          	mv	a4,a7
    80000770:	00800393          	li	t2,8
    80000774:	00000413          	li	s0,0
    80000778:	00177793          	andi	a5,a4,1
    8000077c:	018f949b          	slliw	s1,t6,0x18
    80000780:	40f007bb          	negw	a5,a5
    80000784:	00fff7b3          	and	a5,t6,a5
    80000788:	001f991b          	slliw	s2,t6,0x1
    8000078c:	4184d49b          	sraiw	s1,s1,0x18
    80000790:	0017571b          	srliw	a4,a4,0x1
    80000794:	fff3839b          	addiw	t2,t2,-1
    80000798:	0fe97f93          	andi	t6,s2,254
    8000079c:	00f44433          	xor	s0,s0,a5
    800007a0:	0004d463          	bgez	s1,800007a8 <_Z13invMixColumnsPA4_c+0x16c>
    800007a4:	01bfcf93          	xori	t6,t6,27
    800007a8:	0ff77713          	zext.b	a4,a4
    800007ac:	fc0396e3          	bnez	t2,80000778 <_Z13invMixColumnsPA4_c+0x13c>
    800007b0:	00c6cf83          	lbu	t6,12(a3)
    800007b4:	0082c2b3          	xor	t0,t0,s0
    800007b8:	0ff2f293          	zext.b	t0,t0
    800007bc:	00080713          	mv	a4,a6
    800007c0:	00800393          	li	t2,8
    800007c4:	00000413          	li	s0,0
    800007c8:	00177793          	andi	a5,a4,1
    800007cc:	018f949b          	slliw	s1,t6,0x18
    800007d0:	40f007bb          	negw	a5,a5
    800007d4:	00fff7b3          	and	a5,t6,a5
    800007d8:	001f991b          	slliw	s2,t6,0x1
    800007dc:	4184d49b          	sraiw	s1,s1,0x18
    800007e0:	0017571b          	srliw	a4,a4,0x1
    800007e4:	fff3839b          	addiw	t2,t2,-1
    800007e8:	0fe97f93          	andi	t6,s2,254
    800007ec:	00f44433          	xor	s0,s0,a5
    800007f0:	0004d463          	bgez	s1,800007f8 <_Z13invMixColumnsPA4_c+0x1bc>
    800007f4:	01bfcf93          	xori	t6,t6,27
    800007f8:	0ff77713          	zext.b	a4,a4
    800007fc:	fc0396e3          	bnez	t2,800007c8 <_Z13invMixColumnsPA4_c+0x18c>
    80000800:	0082c7b3          	xor	a5,t0,s0
    80000804:	00f60023          	sb	a5,0(a2)
    80000808:	00168693          	addi	a3,a3,1
    8000080c:	00160613          	addi	a2,a2,1
    80000810:	ecde94e3          	bne	t4,a3,800006d8 <_Z13invMixColumnsPA4_c+0x9c>
    80000814:	00458593          	addi	a1,a1,4
    80000818:	00450513          	addi	a0,a0,4
    8000081c:	ebe592e3          	bne	a1,t5,800006c0 <_Z13invMixColumnsPA4_c+0x84>
    80000820:	03813403          	ld	s0,56(sp)
    80000824:	03013483          	ld	s1,48(sp)
    80000828:	02813903          	ld	s2,40(sp)
    8000082c:	00000513          	li	a0,0
    80000830:	04010113          	addi	sp,sp,64
    80000834:	00008067          	ret

0000000080000838 <_Z10aesEncryptPKcjS0_Pcj>:
    80000838:	e2010113          	addi	sp,sp,-480
    8000083c:	1c113c23          	sd	ra,472(sp)
    80000840:	00013423          	sd	zero,8(sp)
    80000844:	00013823          	sd	zero,16(sp)
    80000848:	00013c23          	sd	zero,24(sp)
    8000084c:	02013023          	sd	zero,32(sp)
    80000850:	1e050e63          	beqz	a0,80000a4c <_Z10aesEncryptPKcjS0_Pcj+0x214>
    80000854:	1c813823          	sd	s0,464(sp)
    80000858:	00060413          	mv	s0,a2
    8000085c:	20060e63          	beqz	a2,80000a78 <_Z10aesEncryptPKcjS0_Pcj+0x240>
    80000860:	1b413823          	sd	s4,432(sp)
    80000864:	00068a13          	mv	s4,a3
    80000868:	20068063          	beqz	a3,80000a68 <_Z10aesEncryptPKcjS0_Pcj+0x230>
    8000086c:	1c913423          	sd	s1,456(sp)
    80000870:	00070493          	mv	s1,a4
    80000874:	01000713          	li	a4,16
    80000878:	1cb76e63          	bltu	a4,a1,80000a54 <_Z10aesEncryptPKcjS0_Pcj+0x21c>
    8000087c:	00f4f713          	andi	a4,s1,15
    80000880:	1c071a63          	bnez	a4,80000a54 <_Z10aesEncryptPKcjS0_Pcj+0x21c>
    80000884:	1c058063          	beqz	a1,80000a44 <_Z10aesEncryptPKcjS0_Pcj+0x20c>
    80000888:	02059693          	slli	a3,a1,0x20
    8000088c:	00050793          	mv	a5,a0
    80000890:	0206d693          	srli	a3,a3,0x20
    80000894:	00810513          	addi	a0,sp,8
    80000898:	00078713          	mv	a4,a5
    8000089c:	00d506b3          	add	a3,a0,a3
    800008a0:	00050793          	mv	a5,a0
    800008a4:	00074603          	lbu	a2,0(a4)
    800008a8:	00178793          	addi	a5,a5,1
    800008ac:	00170713          	addi	a4,a4,1
    800008b0:	fec78fa3          	sb	a2,-1(a5)
    800008b4:	fed798e3          	bne	a5,a3,800008a4 <_Z10aesEncryptPKcjS0_Pcj+0x6c>
    800008b8:	02810613          	addi	a2,sp,40
    800008bc:	01000593          	li	a1,16
    800008c0:	84dff0ef          	jal	8000010c <_Z12keyExpansionPKcjP6AesKey>
    800008c4:	16048263          	beqz	s1,80000a28 <_Z10aesEncryptPKcjS0_Pcj+0x1f0>
    800008c8:	fff4879b          	addiw	a5,s1,-1
    800008cc:	0047d79b          	srliw	a5,a5,0x4
    800008d0:	00479793          	slli	a5,a5,0x4
    800008d4:	01478793          	addi	a5,a5,20
    800008d8:	1d213023          	sd	s2,448(sp)
    800008dc:	1b513423          	sd	s5,424(sp)
    800008e0:	1b613023          	sd	s6,416(sp)
    800008e4:	004a0a93          	addi	s5,s4,4
    800008e8:	00440693          	addi	a3,s0,4
    800008ec:	1b313c23          	sd	s3,440(sp)
    800008f0:	19713c23          	sd	s7,408(sp)
    800008f4:	19813823          	sd	s8,400(sp)
    800008f8:	00fa0a33          	add	s4,s4,a5
    800008fc:	00001417          	auipc	s0,0x1
    80000900:	b7440413          	addi	s0,s0,-1164 # 80001470 <S>
    80000904:	0b810913          	addi	s2,sp,184
    80000908:	02c10b13          	addi	s6,sp,44
    8000090c:	01810493          	addi	s1,sp,24
    80000910:	00048593          	mv	a1,s1
    80000914:	01068993          	addi	s3,a3,16
    80000918:	ffc68793          	addi	a5,a3,-4
    8000091c:	00058713          	mv	a4,a1
    80000920:	0007c603          	lbu	a2,0(a5)
    80000924:	00178793          	addi	a5,a5,1
    80000928:	00470713          	addi	a4,a4,4
    8000092c:	fec70e23          	sb	a2,-4(a4)
    80000930:	fed798e3          	bne	a5,a3,80000920 <_Z10aesEncryptPKcjS0_Pcj+0xe8>
    80000934:	00478693          	addi	a3,a5,4
    80000938:	00158593          	addi	a1,a1,1
    8000093c:	fd369ee3          	bne	a3,s3,80000918 <_Z10aesEncryptPKcjS0_Pcj+0xe0>
    80000940:	02810593          	addi	a1,sp,40
    80000944:	01810513          	addi	a0,sp,24
    80000948:	919ff0ef          	jal	80000260 <_Z11addRoundKeyPA4_cPKj>
    8000094c:	02810b93          	addi	s7,sp,40
    80000950:	01c10c13          	addi	s8,sp,28
    80000954:	010b8b93          	addi	s7,s7,16
    80000958:	000c0693          	mv	a3,s8
    8000095c:	ffc68793          	addi	a5,a3,-4
    80000960:	0007c703          	lbu	a4,0(a5)
    80000964:	00178793          	addi	a5,a5,1
    80000968:	00e40733          	add	a4,s0,a4
    8000096c:	00074703          	lbu	a4,0(a4)
    80000970:	fee78fa3          	sb	a4,-1(a5)
    80000974:	fed796e3          	bne	a5,a3,80000960 <_Z10aesEncryptPKcjS0_Pcj+0x128>
    80000978:	00478693          	addi	a3,a5,4
    8000097c:	ff6690e3          	bne	a3,s6,8000095c <_Z10aesEncryptPKcjS0_Pcj+0x124>
    80000980:	01810513          	addi	a0,sp,24
    80000984:	9a1ff0ef          	jal	80000324 <_Z9shiftRowsPA4_c>
    80000988:	01810513          	addi	a0,sp,24
    8000098c:	ab5ff0ef          	jal	80000440 <_Z10mixColumnsPA4_c>
    80000990:	000b8593          	mv	a1,s7
    80000994:	01810513          	addi	a0,sp,24
    80000998:	8c9ff0ef          	jal	80000260 <_Z11addRoundKeyPA4_cPKj>
    8000099c:	fb2b9ae3          	bne	s7,s2,80000950 <_Z10aesEncryptPKcjS0_Pcj+0x118>
    800009a0:	ffcc0793          	addi	a5,s8,-4
    800009a4:	0007c703          	lbu	a4,0(a5)
    800009a8:	00178793          	addi	a5,a5,1
    800009ac:	00e40733          	add	a4,s0,a4
    800009b0:	00074703          	lbu	a4,0(a4)
    800009b4:	fee78fa3          	sb	a4,-1(a5)
    800009b8:	ff8796e3          	bne	a5,s8,800009a4 <_Z10aesEncryptPKcjS0_Pcj+0x16c>
    800009bc:	00478c13          	addi	s8,a5,4
    800009c0:	ff6c10e3          	bne	s8,s6,800009a0 <_Z10aesEncryptPKcjS0_Pcj+0x168>
    800009c4:	01810513          	addi	a0,sp,24
    800009c8:	95dff0ef          	jal	80000324 <_Z9shiftRowsPA4_c>
    800009cc:	0c810593          	addi	a1,sp,200
    800009d0:	01810513          	addi	a0,sp,24
    800009d4:	88dff0ef          	jal	80000260 <_Z11addRoundKeyPA4_cPKj>
    800009d8:	010a8613          	addi	a2,s5,16
    800009dc:	ffca8793          	addi	a5,s5,-4
    800009e0:	00048713          	mv	a4,s1
    800009e4:	00074683          	lbu	a3,0(a4)
    800009e8:	00178793          	addi	a5,a5,1
    800009ec:	00470713          	addi	a4,a4,4
    800009f0:	fed78fa3          	sb	a3,-1(a5)
    800009f4:	ff5798e3          	bne	a5,s5,800009e4 <_Z10aesEncryptPKcjS0_Pcj+0x1ac>
    800009f8:	00478a93          	addi	s5,a5,4
    800009fc:	00148493          	addi	s1,s1,1
    80000a00:	fcca9ee3          	bne	s5,a2,800009dc <_Z10aesEncryptPKcjS0_Pcj+0x1a4>
    80000a04:	015a0663          	beq	s4,s5,80000a10 <_Z10aesEncryptPKcjS0_Pcj+0x1d8>
    80000a08:	00098693          	mv	a3,s3
    80000a0c:	f01ff06f          	j	8000090c <_Z10aesEncryptPKcjS0_Pcj+0xd4>
    80000a10:	1c013903          	ld	s2,448(sp)
    80000a14:	1b813983          	ld	s3,440(sp)
    80000a18:	1a813a83          	ld	s5,424(sp)
    80000a1c:	1a013b03          	ld	s6,416(sp)
    80000a20:	19813b83          	ld	s7,408(sp)
    80000a24:	19013c03          	ld	s8,400(sp)
    80000a28:	1d013403          	ld	s0,464(sp)
    80000a2c:	1c813483          	ld	s1,456(sp)
    80000a30:	1b013a03          	ld	s4,432(sp)
    80000a34:	00000513          	li	a0,0
    80000a38:	1d813083          	ld	ra,472(sp)
    80000a3c:	1e010113          	addi	sp,sp,480
    80000a40:	00008067          	ret
    80000a44:	00810513          	addi	a0,sp,8
    80000a48:	e71ff06f          	j	800008b8 <_Z10aesEncryptPKcjS0_Pcj+0x80>
    80000a4c:	fff00513          	li	a0,-1
    80000a50:	fe9ff06f          	j	80000a38 <_Z10aesEncryptPKcjS0_Pcj+0x200>
    80000a54:	1d013403          	ld	s0,464(sp)
    80000a58:	1c813483          	ld	s1,456(sp)
    80000a5c:	1b013a03          	ld	s4,432(sp)
    80000a60:	fff00513          	li	a0,-1
    80000a64:	fd5ff06f          	j	80000a38 <_Z10aesEncryptPKcjS0_Pcj+0x200>
    80000a68:	1d013403          	ld	s0,464(sp)
    80000a6c:	1b013a03          	ld	s4,432(sp)
    80000a70:	fff00513          	li	a0,-1
    80000a74:	fc5ff06f          	j	80000a38 <_Z10aesEncryptPKcjS0_Pcj+0x200>
    80000a78:	1d013403          	ld	s0,464(sp)
    80000a7c:	fff00513          	li	a0,-1
    80000a80:	fb9ff06f          	j	80000a38 <_Z10aesEncryptPKcjS0_Pcj+0x200>

0000000080000a84 <_Z10aesDecryptPKcjS0_Pcj>:
    80000a84:	e2010113          	addi	sp,sp,-480
    80000a88:	1c113c23          	sd	ra,472(sp)
    80000a8c:	00013423          	sd	zero,8(sp)
    80000a90:	00013823          	sd	zero,16(sp)
    80000a94:	00013c23          	sd	zero,24(sp)
    80000a98:	02013023          	sd	zero,32(sp)
    80000a9c:	1e050e63          	beqz	a0,80000c98 <_Z10aesDecryptPKcjS0_Pcj+0x214>
    80000aa0:	1c813823          	sd	s0,464(sp)
    80000aa4:	00060413          	mv	s0,a2
    80000aa8:	20060e63          	beqz	a2,80000cc4 <_Z10aesDecryptPKcjS0_Pcj+0x240>
    80000aac:	1b413823          	sd	s4,432(sp)
    80000ab0:	00068a13          	mv	s4,a3
    80000ab4:	20068063          	beqz	a3,80000cb4 <_Z10aesDecryptPKcjS0_Pcj+0x230>
    80000ab8:	1c913423          	sd	s1,456(sp)
    80000abc:	00070493          	mv	s1,a4
    80000ac0:	01000713          	li	a4,16
    80000ac4:	1cb76e63          	bltu	a4,a1,80000ca0 <_Z10aesDecryptPKcjS0_Pcj+0x21c>
    80000ac8:	00f4f713          	andi	a4,s1,15
    80000acc:	1c071a63          	bnez	a4,80000ca0 <_Z10aesDecryptPKcjS0_Pcj+0x21c>
    80000ad0:	1c058063          	beqz	a1,80000c90 <_Z10aesDecryptPKcjS0_Pcj+0x20c>
    80000ad4:	02059693          	slli	a3,a1,0x20
    80000ad8:	00050793          	mv	a5,a0
    80000adc:	0206d693          	srli	a3,a3,0x20
    80000ae0:	00810513          	addi	a0,sp,8
    80000ae4:	00078713          	mv	a4,a5
    80000ae8:	00d506b3          	add	a3,a0,a3
    80000aec:	00050793          	mv	a5,a0
    80000af0:	00074603          	lbu	a2,0(a4)
    80000af4:	00178793          	addi	a5,a5,1
    80000af8:	00170713          	addi	a4,a4,1
    80000afc:	fec78fa3          	sb	a2,-1(a5)
    80000b00:	fed798e3          	bne	a5,a3,80000af0 <_Z10aesDecryptPKcjS0_Pcj+0x6c>
    80000b04:	02810613          	addi	a2,sp,40
    80000b08:	01000593          	li	a1,16
    80000b0c:	e00ff0ef          	jal	8000010c <_Z12keyExpansionPKcjP6AesKey>
    80000b10:	16048263          	beqz	s1,80000c74 <_Z10aesDecryptPKcjS0_Pcj+0x1f0>
    80000b14:	fff4879b          	addiw	a5,s1,-1
    80000b18:	0047d79b          	srliw	a5,a5,0x4
    80000b1c:	00479793          	slli	a5,a5,0x4
    80000b20:	01478793          	addi	a5,a5,20
    80000b24:	1d213023          	sd	s2,448(sp)
    80000b28:	1b513423          	sd	s5,424(sp)
    80000b2c:	1b613023          	sd	s6,416(sp)
    80000b30:	004a0a93          	addi	s5,s4,4
    80000b34:	00440693          	addi	a3,s0,4
    80000b38:	1b313c23          	sd	s3,440(sp)
    80000b3c:	19713c23          	sd	s7,408(sp)
    80000b40:	19813823          	sd	s8,400(sp)
    80000b44:	00fa0a33          	add	s4,s4,a5
    80000b48:	00001417          	auipc	s0,0x1
    80000b4c:	92840413          	addi	s0,s0,-1752 # 80001470 <S>
    80000b50:	16810913          	addi	s2,sp,360
    80000b54:	02c10b13          	addi	s6,sp,44
    80000b58:	01810493          	addi	s1,sp,24
    80000b5c:	00048593          	mv	a1,s1
    80000b60:	01068993          	addi	s3,a3,16
    80000b64:	ffc68793          	addi	a5,a3,-4
    80000b68:	00058713          	mv	a4,a1
    80000b6c:	0007c603          	lbu	a2,0(a5)
    80000b70:	00178793          	addi	a5,a5,1
    80000b74:	00470713          	addi	a4,a4,4
    80000b78:	fec70e23          	sb	a2,-4(a4)
    80000b7c:	fed798e3          	bne	a5,a3,80000b6c <_Z10aesDecryptPKcjS0_Pcj+0xe8>
    80000b80:	00478693          	addi	a3,a5,4
    80000b84:	00158593          	addi	a1,a1,1
    80000b88:	fd369ee3          	bne	a3,s3,80000b64 <_Z10aesDecryptPKcjS0_Pcj+0xe0>
    80000b8c:	0d810593          	addi	a1,sp,216
    80000b90:	01810513          	addi	a0,sp,24
    80000b94:	eccff0ef          	jal	80000260 <_Z11addRoundKeyPA4_cPKj>
    80000b98:	0d810b93          	addi	s7,sp,216
    80000b9c:	01810513          	addi	a0,sp,24
    80000ba0:	ff0ff0ef          	jal	80000390 <_Z12invShiftRowsPA4_c>
    80000ba4:	01c10c13          	addi	s8,sp,28
    80000ba8:	010b8b93          	addi	s7,s7,16
    80000bac:	000c0693          	mv	a3,s8
    80000bb0:	ffc68793          	addi	a5,a3,-4
    80000bb4:	0007c703          	lbu	a4,0(a5)
    80000bb8:	00178793          	addi	a5,a5,1
    80000bbc:	00e40733          	add	a4,s0,a4
    80000bc0:	10074703          	lbu	a4,256(a4)
    80000bc4:	fee78fa3          	sb	a4,-1(a5)
    80000bc8:	fed796e3          	bne	a5,a3,80000bb4 <_Z10aesDecryptPKcjS0_Pcj+0x130>
    80000bcc:	00478693          	addi	a3,a5,4
    80000bd0:	ff6690e3          	bne	a3,s6,80000bb0 <_Z10aesDecryptPKcjS0_Pcj+0x12c>
    80000bd4:	000b8593          	mv	a1,s7
    80000bd8:	01810513          	addi	a0,sp,24
    80000bdc:	e84ff0ef          	jal	80000260 <_Z11addRoundKeyPA4_cPKj>
    80000be0:	01810513          	addi	a0,sp,24
    80000be4:	a59ff0ef          	jal	8000063c <_Z13invMixColumnsPA4_c>
    80000be8:	fb2b9ae3          	bne	s7,s2,80000b9c <_Z10aesDecryptPKcjS0_Pcj+0x118>
    80000bec:	ffcc0793          	addi	a5,s8,-4
    80000bf0:	0007c703          	lbu	a4,0(a5)
    80000bf4:	00178793          	addi	a5,a5,1
    80000bf8:	00e40733          	add	a4,s0,a4
    80000bfc:	10074703          	lbu	a4,256(a4)
    80000c00:	fee78fa3          	sb	a4,-1(a5)
    80000c04:	ff8796e3          	bne	a5,s8,80000bf0 <_Z10aesDecryptPKcjS0_Pcj+0x16c>
    80000c08:	00478c13          	addi	s8,a5,4
    80000c0c:	ff6c10e3          	bne	s8,s6,80000bec <_Z10aesDecryptPKcjS0_Pcj+0x168>
    80000c10:	01810513          	addi	a0,sp,24
    80000c14:	f7cff0ef          	jal	80000390 <_Z12invShiftRowsPA4_c>
    80000c18:	17810593          	addi	a1,sp,376
    80000c1c:	01810513          	addi	a0,sp,24
    80000c20:	e40ff0ef          	jal	80000260 <_Z11addRoundKeyPA4_cPKj>
    80000c24:	010a8613          	addi	a2,s5,16
    80000c28:	ffca8793          	addi	a5,s5,-4
    80000c2c:	00048713          	mv	a4,s1
    80000c30:	00074683          	lbu	a3,0(a4)
    80000c34:	00178793          	addi	a5,a5,1
    80000c38:	00470713          	addi	a4,a4,4
    80000c3c:	fed78fa3          	sb	a3,-1(a5)
    80000c40:	ff5798e3          	bne	a5,s5,80000c30 <_Z10aesDecryptPKcjS0_Pcj+0x1ac>
    80000c44:	00478a93          	addi	s5,a5,4
    80000c48:	00148493          	addi	s1,s1,1
    80000c4c:	fcca9ee3          	bne	s5,a2,80000c28 <_Z10aesDecryptPKcjS0_Pcj+0x1a4>
    80000c50:	015a0663          	beq	s4,s5,80000c5c <_Z10aesDecryptPKcjS0_Pcj+0x1d8>
    80000c54:	00098693          	mv	a3,s3
    80000c58:	f01ff06f          	j	80000b58 <_Z10aesDecryptPKcjS0_Pcj+0xd4>
    80000c5c:	1c013903          	ld	s2,448(sp)
    80000c60:	1b813983          	ld	s3,440(sp)
    80000c64:	1a813a83          	ld	s5,424(sp)
    80000c68:	1a013b03          	ld	s6,416(sp)
    80000c6c:	19813b83          	ld	s7,408(sp)
    80000c70:	19013c03          	ld	s8,400(sp)
    80000c74:	1d013403          	ld	s0,464(sp)
    80000c78:	1c813483          	ld	s1,456(sp)
    80000c7c:	1b013a03          	ld	s4,432(sp)
    80000c80:	00000513          	li	a0,0
    80000c84:	1d813083          	ld	ra,472(sp)
    80000c88:	1e010113          	addi	sp,sp,480
    80000c8c:	00008067          	ret
    80000c90:	00810513          	addi	a0,sp,8
    80000c94:	e71ff06f          	j	80000b04 <_Z10aesDecryptPKcjS0_Pcj+0x80>
    80000c98:	fff00513          	li	a0,-1
    80000c9c:	fe9ff06f          	j	80000c84 <_Z10aesDecryptPKcjS0_Pcj+0x200>
    80000ca0:	1d013403          	ld	s0,464(sp)
    80000ca4:	1c813483          	ld	s1,456(sp)
    80000ca8:	1b013a03          	ld	s4,432(sp)
    80000cac:	fff00513          	li	a0,-1
    80000cb0:	fd5ff06f          	j	80000c84 <_Z10aesDecryptPKcjS0_Pcj+0x200>
    80000cb4:	1d013403          	ld	s0,464(sp)
    80000cb8:	1b013a03          	ld	s4,432(sp)
    80000cbc:	fff00513          	li	a0,-1
    80000cc0:	fc5ff06f          	j	80000c84 <_Z10aesDecryptPKcjS0_Pcj+0x200>
    80000cc4:	1d013403          	ld	s0,464(sp)
    80000cc8:	fff00513          	li	a0,-1
    80000ccc:	fb9ff06f          	j	80000c84 <_Z10aesDecryptPKcjS0_Pcj+0x200>

0000000080000cd0 <_Z13heavy_rng_modji>:
    80000cd0:	a5a5a6b7          	lui	a3,0xa5a5a
    80000cd4:	5a568693          	addi	a3,a3,1445 # ffffffffa5a5a5a5 <_stack_top+0xffffffff25a50f35>
    80000cd8:	00d547b3          	xor	a5,a0,a3
    80000cdc:	00156713          	ori	a4,a0,1
    80000ce0:	0cb05263          	blez	a1,80000da4 <_Z13heavy_rng_modji+0xd4>
    80000ce4:	00196eb7          	lui	t4,0x196
    80000ce8:	3c6efe37          	lui	t3,0x3c6ef
    80000cec:	015a5337          	lui	t1,0x15a5
    80000cf0:	41c658b7          	lui	a7,0x41c65
    80000cf4:	00003837          	lui	a6,0x3
    80000cf8:	00000613          	li	a2,0
    80000cfc:	60de8e9b          	addiw	t4,t4,1549 # 19660d <STACK_SIZE+0x18e60d>
    80000d00:	35fe0e1b          	addiw	t3,t3,863 # 3c6ef35f <STACK_SIZE+0x3c6e735f>
    80000d04:	e353031b          	addiw	t1,t1,-459 # 15a4e35 <STACK_SIZE+0x159ce35>
    80000d08:	e6d8889b          	addiw	a7,a7,-403 # 41c64e6d <STACK_SIZE+0x41c5ce6d>
    80000d0c:	0398081b          	addiw	a6,a6,57 # 3039 <STACK_SIZE-0x4fc7>
    80000d10:	03d506bb          	mulw	a3,a0,t4
    80000d14:	00176f13          	ori	t5,a4,1
    80000d18:	0017e513          	ori	a0,a5,1
    80000d1c:	0016061b          	addiw	a2,a2,1
    80000d20:	01c686bb          	addw	a3,a3,t3
    80000d24:	03e6d6bb          	divuw	a3,a3,t5
    80000d28:	02a6f6bb          	remuw	a3,a3,a0
    80000d2c:	026787bb          	mulw	a5,a5,t1
    80000d30:	0016e513          	ori	a0,a3,1
    80000d34:	0017879b          	addiw	a5,a5,1
    80000d38:	02a7d7bb          	divuw	a5,a5,a0
    80000d3c:	03e7f7bb          	remuw	a5,a5,t5
    80000d40:	0317073b          	mulw	a4,a4,a7
    80000d44:	0017ef93          	ori	t6,a5,1
    80000d48:	00f6c6b3          	xor	a3,a3,a5
    80000d4c:	0036df1b          	srliw	t5,a3,0x3
    80000d50:	0107073b          	addw	a4,a4,a6
    80000d54:	03f7573b          	divuw	a4,a4,t6
    80000d58:	02a7773b          	remuw	a4,a4,a0
    80000d5c:	00e787bb          	addw	a5,a5,a4
    80000d60:	0017e513          	ori	a0,a5,1
    80000d64:	02a686bb          	mulw	a3,a3,a0
    80000d68:	00ef4f33          	xor	t5,t5,a4
    80000d6c:	000f0f1b          	sext.w	t5,t5
    80000d70:	001f6713          	ori	a4,t5,1
    80000d74:	02e6f6bb          	remuw	a3,a3,a4
    80000d78:	02e7d7bb          	divuw	a5,a5,a4
    80000d7c:	0016e713          	ori	a4,a3,1
    80000d80:	0006851b          	sext.w	a0,a3
    80000d84:	02e7ffbb          	remuw	t6,a5,a4
    80000d88:	03e7073b          	mulw	a4,a4,t5
    80000d8c:	001fef13          	ori	t5,t6,1
    80000d90:	000f879b          	sext.w	a5,t6
    80000d94:	03e7773b          	remuw	a4,a4,t5
    80000d98:	f6c59ce3          	bne	a1,a2,80000d10 <_Z13heavy_rng_modji+0x40>
    80000d9c:	01f6c6b3          	xor	a3,a3,t6
    80000da0:	0006869b          	sext.w	a3,a3
    80000da4:	00d74533          	xor	a0,a4,a3
    80000da8:	00008067          	ret

0000000080000dac <main>:
    80000dac:	f2010113          	addi	sp,sp,-224
    80000db0:	1357a7b7          	lui	a5,0x1357a
    80000db4:	001965b7          	lui	a1,0x196
    80000db8:	3c6ef637          	lui	a2,0x3c6ef
    80000dbc:	0c113c23          	sd	ra,216(sp)
    80000dc0:	0c813823          	sd	s0,208(sp)
    80000dc4:	0d213023          	sd	s2,192(sp)
    80000dc8:	03010713          	addi	a4,sp,48
    80000dcc:	0b010513          	addi	a0,sp,176
    80000dd0:	bdf78793          	addi	a5,a5,-1057 # 13579bdf <STACK_SIZE+0x13571bdf>
    80000dd4:	60d5859b          	addiw	a1,a1,1549 # 19660d <STACK_SIZE+0x18e60d>
    80000dd8:	35f6061b          	addiw	a2,a2,863 # 3c6ef35f <STACK_SIZE+0x3c6e735f>
    80000ddc:	02b787bb          	mulw	a5,a5,a1
    80000de0:	00170713          	addi	a4,a4,1
    80000de4:	00c787bb          	addw	a5,a5,a2
    80000de8:	0187d69b          	srliw	a3,a5,0x18
    80000dec:	fed70fa3          	sb	a3,-1(a4)
    80000df0:	fee516e3          	bne	a0,a4,80000ddc <main+0x30>
    80000df4:	406006b7          	lui	a3,0x40600
    80000df8:	04100713          	li	a4,65
    80000dfc:	00000797          	auipc	a5,0x0
    80000e00:	3b478793          	addi	a5,a5,948 # 800011b0 <main+0x404>
    80000e04:	00468693          	addi	a3,a3,4 # 40600004 <STACK_SIZE+0x405f8004>
    80000e08:	00178793          	addi	a5,a5,1
    80000e0c:	00e68023          	sb	a4,0(a3)
    80000e10:	0007c703          	lbu	a4,0(a5)
    80000e14:	fe071ae3          	bnez	a4,80000e08 <main+0x5c>
    80000e18:	406006b7          	lui	a3,0x40600
    80000e1c:	00013423          	sd	zero,8(sp)
    80000e20:	00013823          	sd	zero,16(sp)
    80000e24:	00013c23          	sd	zero,24(sp)
    80000e28:	02013023          	sd	zero,32(sp)
    80000e2c:	05200713          	li	a4,82
    80000e30:	00000797          	auipc	a5,0x0
    80000e34:	3a878793          	addi	a5,a5,936 # 800011d8 <main+0x42c>
    80000e38:	00468693          	addi	a3,a3,4 # 40600004 <STACK_SIZE+0x405f8004>
    80000e3c:	00178793          	addi	a5,a5,1
    80000e40:	00e68023          	sb	a4,0(a3)
    80000e44:	0007c703          	lbu	a4,0(a5)
    80000e48:	fe071ae3          	bnez	a4,80000e3c <main+0x90>
    80000e4c:	406006b7          	lui	a3,0x40600
    80000e50:	05b00713          	li	a4,91
    80000e54:	00000797          	auipc	a5,0x0
    80000e58:	3ac78793          	addi	a5,a5,940 # 80001200 <main+0x454>
    80000e5c:	00468693          	addi	a3,a3,4 # 40600004 <STACK_SIZE+0x405f8004>
    80000e60:	00178793          	addi	a5,a5,1
    80000e64:	00e68023          	sb	a4,0(a3)
    80000e68:	0007c703          	lbu	a4,0(a5)
    80000e6c:	fe071ae3          	bnez	a4,80000e60 <main+0xb4>
    80000e70:	01000713          	li	a4,16
    80000e74:	00810693          	addi	a3,sp,8
    80000e78:	00000617          	auipc	a2,0x0
    80000e7c:	5a860613          	addi	a2,a2,1448 # 80001420 <_ZZL20runCorrectnessChecksvE2pt>
    80000e80:	01000593          	li	a1,16
    80000e84:	00000517          	auipc	a0,0x0
    80000e88:	5ac50513          	addi	a0,a0,1452 # 80001430 <_ZZL20runCorrectnessChecksvE3key>
    80000e8c:	9adff0ef          	jal	80000838 <_Z10aesEncryptPKcjS0_Pcj>
    80000e90:	2e051a63          	bnez	a0,80001184 <main+0x3d8>
    80000e94:	00810793          	addi	a5,sp,8
    80000e98:	00000717          	auipc	a4,0x0
    80000e9c:	5a870713          	addi	a4,a4,1448 # 80001440 <_ZZL20runCorrectnessChecksvE10expectedCt>
    80000ea0:	01810913          	addi	s2,sp,24
    80000ea4:	0080006f          	j	80000eac <main+0x100>
    80000ea8:	02f90e63          	beq	s2,a5,80000ee4 <main+0x138>
    80000eac:	0007c603          	lbu	a2,0(a5)
    80000eb0:	00074683          	lbu	a3,0(a4)
    80000eb4:	00178793          	addi	a5,a5,1
    80000eb8:	00170713          	addi	a4,a4,1
    80000ebc:	fed606e3          	beq	a2,a3,80000ea8 <main+0xfc>
    80000ec0:	00000797          	auipc	a5,0x0
    80000ec4:	39078793          	addi	a5,a5,912 # 80001250 <main+0x4a4>
    80000ec8:	0007c683          	lbu	a3,0(a5)
    80000ecc:	40600737          	lui	a4,0x40600
    80000ed0:	00470713          	addi	a4,a4,4 # 40600004 <STACK_SIZE+0x405f8004>
    80000ed4:	28068263          	beqz	a3,80001158 <main+0x3ac>
    80000ed8:	00178793          	addi	a5,a5,1
    80000edc:	00d70023          	sb	a3,0(a4)
    80000ee0:	fe9ff06f          	j	80000ec8 <main+0x11c>
    80000ee4:	406006b7          	lui	a3,0x40600
    80000ee8:	0c913423          	sd	s1,200(sp)
    80000eec:	05b00713          	li	a4,91
    80000ef0:	00000797          	auipc	a5,0x0
    80000ef4:	38878793          	addi	a5,a5,904 # 80001278 <main+0x4cc>
    80000ef8:	00468693          	addi	a3,a3,4 # 40600004 <STACK_SIZE+0x405f8004>
    80000efc:	00178793          	addi	a5,a5,1
    80000f00:	00e68023          	sb	a4,0(a3)
    80000f04:	0007c703          	lbu	a4,0(a5)
    80000f08:	fe071ae3          	bnez	a4,80000efc <main+0x150>
    80000f0c:	406006b7          	lui	a3,0x40600
    80000f10:	05b00713          	li	a4,91
    80000f14:	00000797          	auipc	a5,0x0
    80000f18:	39478793          	addi	a5,a5,916 # 800012a8 <main+0x4fc>
    80000f1c:	00468693          	addi	a3,a3,4 # 40600004 <STACK_SIZE+0x405f8004>
    80000f20:	00178793          	addi	a5,a5,1
    80000f24:	00e68023          	sb	a4,0(a3)
    80000f28:	0007c703          	lbu	a4,0(a5)
    80000f2c:	fe071ae3          	bnez	a4,80000f20 <main+0x174>
    80000f30:	01000713          	li	a4,16
    80000f34:	00090693          	mv	a3,s2
    80000f38:	00810613          	addi	a2,sp,8
    80000f3c:	01000593          	li	a1,16
    80000f40:	00000517          	auipc	a0,0x0
    80000f44:	4f050513          	addi	a0,a0,1264 # 80001430 <_ZZL20runCorrectnessChecksvE3key>
    80000f48:	b3dff0ef          	jal	80000a84 <_Z10aesDecryptPKcjS0_Pcj>
    80000f4c:	00050493          	mv	s1,a0
    80000f50:	1e051063          	bnez	a0,80001130 <main+0x384>
    80000f54:	00090793          	mv	a5,s2
    80000f58:	00000717          	auipc	a4,0x0
    80000f5c:	4c870713          	addi	a4,a4,1224 # 80001420 <_ZZL20runCorrectnessChecksvE2pt>
    80000f60:	02810593          	addi	a1,sp,40
    80000f64:	0080006f          	j	80000f6c <main+0x1c0>
    80000f68:	02f58e63          	beq	a1,a5,80000fa4 <main+0x1f8>
    80000f6c:	0007c603          	lbu	a2,0(a5)
    80000f70:	00074683          	lbu	a3,0(a4)
    80000f74:	00178793          	addi	a5,a5,1
    80000f78:	00170713          	addi	a4,a4,1
    80000f7c:	fed606e3          	beq	a2,a3,80000f68 <main+0x1bc>
    80000f80:	00000797          	auipc	a5,0x0
    80000f84:	37878793          	addi	a5,a5,888 # 800012f8 <main+0x54c>
    80000f88:	0007c683          	lbu	a3,0(a5)
    80000f8c:	40600737          	lui	a4,0x40600
    80000f90:	00470713          	addi	a4,a4,4 # 40600004 <STACK_SIZE+0x405f8004>
    80000f94:	1c068063          	beqz	a3,80001154 <main+0x3a8>
    80000f98:	00178793          	addi	a5,a5,1
    80000f9c:	00d70023          	sb	a3,0(a4)
    80000fa0:	fe9ff06f          	j	80000f88 <main+0x1dc>
    80000fa4:	406006b7          	lui	a3,0x40600
    80000fa8:	0b313c23          	sd	s3,184(sp)
    80000fac:	0b413823          	sd	s4,176(sp)
    80000fb0:	05b00713          	li	a4,91
    80000fb4:	00000797          	auipc	a5,0x0
    80000fb8:	36c78793          	addi	a5,a5,876 # 80001320 <main+0x574>
    80000fbc:	00468693          	addi	a3,a3,4 # 40600004 <STACK_SIZE+0x405f8004>
    80000fc0:	00178793          	addi	a5,a5,1
    80000fc4:	00e68023          	sb	a4,0(a3)
    80000fc8:	0007c703          	lbu	a4,0(a5)
    80000fcc:	fe071ae3          	bnez	a4,80000fc0 <main+0x214>
    80000fd0:	406006b7          	lui	a3,0x40600
    80000fd4:	05b00713          	li	a4,91
    80000fd8:	00000797          	auipc	a5,0x0
    80000fdc:	37878793          	addi	a5,a5,888 # 80001350 <main+0x5a4>
    80000fe0:	00468693          	addi	a3,a3,4 # 40600004 <STACK_SIZE+0x405f8004>
    80000fe4:	00178793          	addi	a5,a5,1
    80000fe8:	00e68023          	sb	a4,0(a3)
    80000fec:	0007c703          	lbu	a4,0(a5)
    80000ff0:	fe071ae3          	bnez	a4,80000fe4 <main+0x238>
    80000ff4:	200039b7          	lui	s3,0x20003
    80000ff8:	0009ba03          	ld	s4,0(s3) # 20003000 <STACK_SIZE+0x1fffb000>
    80000ffc:	0009b503          	ld	a0,0(s3)
    80001000:	3e800593          	li	a1,1000
    80001004:	0005051b          	sext.w	a0,a0
    80001008:	cc9ff0ef          	jal	80000cd0 <_Z13heavy_rng_modji>
    8000100c:	0009b983          	ld	s3,0(s3)
    80001010:	406006b7          	lui	a3,0x40600
    80001014:	0005041b          	sext.w	s0,a0
    80001018:	05b00713          	li	a4,91
    8000101c:	00000797          	auipc	a5,0x0
    80001020:	38c78793          	addi	a5,a5,908 # 800013a8 <main+0x5fc>
    80001024:	00468693          	addi	a3,a3,4 # 40600004 <STACK_SIZE+0x405f8004>
    80001028:	00178793          	addi	a5,a5,1
    8000102c:	00e68023          	sb	a4,0(a3)
    80001030:	0007c703          	lbu	a4,0(a5)
    80001034:	fe071ae3          	bnez	a4,80001028 <main+0x27c>
    80001038:	00045863          	bgez	s0,80001048 <main+0x29c>
    8000103c:	02d00793          	li	a5,45
    80001040:	00f68023          	sb	a5,0(a3)
    80001044:	4080043b          	negw	s0,s0
    80001048:	00090613          	mv	a2,s2
    8000104c:	00a00693          	li	a3,10
    80001050:	02d4673b          	remw	a4,s0,a3
    80001054:	00160613          	addi	a2,a2,1
    80001058:	00048793          	mv	a5,s1
    8000105c:	0014849b          	addiw	s1,s1,1
    80001060:	02d4443b          	divw	s0,s0,a3
    80001064:	0307071b          	addiw	a4,a4,48
    80001068:	fee60fa3          	sb	a4,-1(a2)
    8000106c:	fe0412e3          	bnez	s0,80001050 <main+0x2a4>
    80001070:	406006b7          	lui	a3,0x40600
    80001074:	00f907b3          	add	a5,s2,a5
    80001078:	00468693          	addi	a3,a3,4 # 40600004 <STACK_SIZE+0x405f8004>
    8000107c:	fff90913          	addi	s2,s2,-1
    80001080:	0007c703          	lbu	a4,0(a5)
    80001084:	fff78793          	addi	a5,a5,-1
    80001088:	00e68023          	sb	a4,0(a3)
    8000108c:	fef91ae3          	bne	s2,a5,80001080 <main+0x2d4>
    80001090:	40600937          	lui	s2,0x40600
    80001094:	02c00713          	li	a4,44
    80001098:	00000797          	auipc	a5,0x0
    8000109c:	33078793          	addi	a5,a5,816 # 800013c8 <main+0x61c>
    800010a0:	00490913          	addi	s2,s2,4 # 40600004 <STACK_SIZE+0x405f8004>
    800010a4:	00178793          	addi	a5,a5,1
    800010a8:	00e90023          	sb	a4,0(s2)
    800010ac:	0007c703          	lbu	a4,0(a5)
    800010b0:	fe071ae3          	bnez	a4,800010a4 <main+0x2f8>
    800010b4:	414989b3          	sub	s3,s3,s4
    800010b8:	00098513          	mv	a0,s3
    800010bc:	f7dfe0ef          	jal	80000038 <_Z5put_iIyEvT_>
    800010c0:	00a00793          	li	a5,10
    800010c4:	406004b7          	lui	s1,0x40600
    800010c8:	00f90023          	sb	a5,0(s2)
    800010cc:	05b00713          	li	a4,91
    800010d0:	00000797          	auipc	a5,0x0
    800010d4:	30878793          	addi	a5,a5,776 # 800013d8 <main+0x62c>
    800010d8:	00448493          	addi	s1,s1,4 # 40600004 <STACK_SIZE+0x405f8004>
    800010dc:	00178793          	addi	a5,a5,1
    800010e0:	00e48023          	sb	a4,0(s1)
    800010e4:	0007c703          	lbu	a4,0(a5)
    800010e8:	fe071ae3          	bnez	a4,800010dc <main+0x330>
    800010ec:	3e800793          	li	a5,1000
    800010f0:	02f9d9b3          	divu	s3,s3,a5
    800010f4:	000f4537          	lui	a0,0xf4
    800010f8:	24050513          	addi	a0,a0,576 # f4240 <STACK_SIZE+0xec240>
    800010fc:	03355533          	divu	a0,a0,s3
    80001100:	f39fe0ef          	jal	80000038 <_Z5put_iIyEvT_>
    80001104:	00a00793          	li	a5,10
    80001108:	00f48023          	sb	a5,0(s1)
    8000110c:	0c813483          	ld	s1,200(sp)
    80001110:	0b813983          	ld	s3,184(sp)
    80001114:	0b013a03          	ld	s4,176(sp)
    80001118:	0d813083          	ld	ra,216(sp)
    8000111c:	00040513          	mv	a0,s0
    80001120:	0d013403          	ld	s0,208(sp)
    80001124:	0c013903          	ld	s2,192(sp)
    80001128:	0e010113          	addi	sp,sp,224
    8000112c:	00008067          	ret
    80001130:	406006b7          	lui	a3,0x40600
    80001134:	00000797          	auipc	a5,0x0
    80001138:	19c78793          	addi	a5,a5,412 # 800012d0 <main+0x524>
    8000113c:	00468693          	addi	a3,a3,4 # 40600004 <STACK_SIZE+0x405f8004>
    80001140:	0080006f          	j	80001148 <main+0x39c>
    80001144:	00e68023          	sb	a4,0(a3)
    80001148:	0007c703          	lbu	a4,0(a5)
    8000114c:	00178793          	addi	a5,a5,1
    80001150:	fe071ae3          	bnez	a4,80001144 <main+0x398>
    80001154:	0c813483          	ld	s1,200(sp)
    80001158:	406006b7          	lui	a3,0x40600
    8000115c:	00000797          	auipc	a5,0x0
    80001160:	21c78793          	addi	a5,a5,540 # 80001378 <main+0x5cc>
    80001164:	00468693          	addi	a3,a3,4 # 40600004 <STACK_SIZE+0x405f8004>
    80001168:	0080006f          	j	80001170 <main+0x3c4>
    8000116c:	00e68023          	sb	a4,0(a3)
    80001170:	0007c703          	lbu	a4,0(a5)
    80001174:	00178793          	addi	a5,a5,1
    80001178:	fe071ae3          	bnez	a4,8000116c <main+0x3c0>
    8000117c:	fff00413          	li	s0,-1
    80001180:	f99ff06f          	j	80001118 <main+0x36c>
    80001184:	406006b7          	lui	a3,0x40600
    80001188:	00000797          	auipc	a5,0x0
    8000118c:	0a078793          	addi	a5,a5,160 # 80001228 <main+0x47c>
    80001190:	00468693          	addi	a3,a3,4 # 40600004 <STACK_SIZE+0x405f8004>
    80001194:	0080006f          	j	8000119c <main+0x3f0>
    80001198:	00e68023          	sb	a4,0(a3)
    8000119c:	0007c703          	lbu	a4,0(a5)
    800011a0:	00178793          	addi	a5,a5,1
    800011a4:	fe071ae3          	bnez	a4,80001198 <main+0x3ec>
    800011a8:	fb1ff06f          	j	80001158 <main+0x3ac>
