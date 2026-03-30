
lab3-test.elf:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_start>:
    80000000:	0000a117          	auipc	sp,0xa
    80000004:	9e010113          	addi	sp,sp,-1568 # 800099e0 <_stack_top>
    80000008:	00002297          	auipc	t0,0x2
    8000000c:	9d828293          	addi	t0,t0,-1576 # 800019e0 <__bss_end>
    80000010:	00002317          	auipc	t1,0x2
    80000014:	9d030313          	addi	t1,t1,-1584 # 800019e0 <__bss_end>
    80000018:	00628863          	beq	t0,t1,80000028 <_start+0x28>
    8000001c:	0002b023          	sd	zero,0(t0)
    80000020:	00828293          	addi	t0,t0,8
    80000024:	fe62ece3          	bltu	t0,t1,8000001c <_start+0x1c>
    80000028:	781000ef          	jal	80000fa8 <main>
    8000002c:	00000513          	li	a0,0
    80000030:	0005006b          	.insn	4, 0x0005006b
    80000034:	0000006f          	j	80000034 <_start+0x34>

0000000080000038 <_Z5put_iIyEvT_>:
    80000038:	fa010113          	addi	sp,sp,-96
    8000003c:	04813823          	sd	s0,80(sp)
    80000040:	05213023          	sd	s2,64(sp)
    80000044:	03313c23          	sd	s3,56(sp)
    80000048:	03513423          	sd	s5,40(sp)
    8000004c:	04113c23          	sd	ra,88(sp)
    80000050:	04913423          	sd	s1,72(sp)
    80000054:	03413823          	sd	s4,48(sp)
    80000058:	00050413          	mv	s0,a0
    8000005c:	00810993          	addi	s3,sp,8
    80000060:	00000913          	li	s2,0
    80000064:	00900a93          	li	s5,9
    80000068:	00a00593          	li	a1,10
    8000006c:	00040513          	mv	a0,s0
    80000070:	440010ef          	jal	800014b0 <__umoddi3>
    80000074:	0305079b          	addiw	a5,a0,48
    80000078:	00f98023          	sb	a5,0(s3)
    8000007c:	00040513          	mv	a0,s0
    80000080:	00a00593          	li	a1,10
    80000084:	00040a13          	mv	s4,s0
    80000088:	3e0010ef          	jal	80001468 <__hidden___udivdi3>
    8000008c:	00090493          	mv	s1,s2
    80000090:	00050413          	mv	s0,a0
    80000094:	0019091b          	addiw	s2,s2,1
    80000098:	00198993          	addi	s3,s3,1
    8000009c:	fd4ae6e3          	bltu	s5,s4,80000068 <_Z5put_iIyEvT_+0x30>
    800000a0:	40600637          	lui	a2,0x40600
    800000a4:	00810793          	addi	a5,sp,8
    800000a8:	009787b3          	add	a5,a5,s1
    800000ac:	00710693          	addi	a3,sp,7
    800000b0:	00460613          	addi	a2,a2,4 # 40600004 <STACK_SIZE+0x405f8004>
    800000b4:	0007c703          	lbu	a4,0(a5)
    800000b8:	fff78793          	addi	a5,a5,-1
    800000bc:	00e60023          	sb	a4,0(a2)
    800000c0:	fed79ae3          	bne	a5,a3,800000b4 <_Z5put_iIyEvT_+0x7c>
    800000c4:	05813083          	ld	ra,88(sp)
    800000c8:	05013403          	ld	s0,80(sp)
    800000cc:	04813483          	ld	s1,72(sp)
    800000d0:	04013903          	ld	s2,64(sp)
    800000d4:	03813983          	ld	s3,56(sp)
    800000d8:	03013a03          	ld	s4,48(sp)
    800000dc:	02813a83          	ld	s5,40(sp)
    800000e0:	06010113          	addi	sp,sp,96
    800000e4:	00008067          	ret

00000000800000e8 <_Z14loadStateArrayPA4_cPKc>:
    800000e8:	00458593          	addi	a1,a1,4
    800000ec:	00450613          	addi	a2,a0,4
    800000f0:	ffc58793          	addi	a5,a1,-4
    800000f4:	00050713          	mv	a4,a0
    800000f8:	0007c683          	lbu	a3,0(a5)
    800000fc:	00178793          	addi	a5,a5,1
    80000100:	00470713          	addi	a4,a4,4
    80000104:	fed70e23          	sb	a3,-4(a4)
    80000108:	feb798e3          	bne	a5,a1,800000f8 <_Z14loadStateArrayPA4_cPKc+0x10>
    8000010c:	00150513          	addi	a0,a0,1
    80000110:	00478593          	addi	a1,a5,4
    80000114:	fcc51ee3          	bne	a0,a2,800000f0 <_Z14loadStateArrayPA4_cPKc+0x8>
    80000118:	00000513          	li	a0,0
    8000011c:	00008067          	ret

0000000080000120 <_Z15storeStateArrayPA4_cPc>:
    80000120:	00458593          	addi	a1,a1,4
    80000124:	00450613          	addi	a2,a0,4
    80000128:	ffc58793          	addi	a5,a1,-4
    8000012c:	00050713          	mv	a4,a0
    80000130:	00074683          	lbu	a3,0(a4)
    80000134:	00178793          	addi	a5,a5,1
    80000138:	00470713          	addi	a4,a4,4
    8000013c:	fed78fa3          	sb	a3,-1(a5)
    80000140:	feb798e3          	bne	a5,a1,80000130 <_Z15storeStateArrayPA4_cPc+0x10>
    80000144:	00150513          	addi	a0,a0,1
    80000148:	00478593          	addi	a1,a5,4
    8000014c:	fcc51ee3          	bne	a0,a2,80000128 <_Z15storeStateArrayPA4_cPc+0x8>
    80000150:	00000513          	li	a0,0
    80000154:	00008067          	ret

0000000080000158 <_Z12keyExpansionPKcjP6AesKey>:
    80000158:	14050663          	beqz	a0,800002a4 <_Z12keyExpansionPKcjP6AesKey+0x14c>
    8000015c:	14060463          	beqz	a2,800002a4 <_Z12keyExpansionPKcjP6AesKey+0x14c>
    80000160:	01000793          	li	a5,16
    80000164:	14f59063          	bne	a1,a5,800002a4 <_Z12keyExpansionPKcjP6AesKey+0x14c>
    80000168:	01050893          	addi	a7,a0,16
    8000016c:	00060593          	mv	a1,a2
    80000170:	00054783          	lbu	a5,0(a0)
    80000174:	00154683          	lbu	a3,1(a0)
    80000178:	00354803          	lbu	a6,3(a0)
    8000017c:	00254703          	lbu	a4,2(a0)
    80000180:	0187979b          	slliw	a5,a5,0x18
    80000184:	0106969b          	slliw	a3,a3,0x10
    80000188:	00d7e7b3          	or	a5,a5,a3
    8000018c:	0107e7b3          	or	a5,a5,a6
    80000190:	0087171b          	slliw	a4,a4,0x8
    80000194:	00e7e7b3          	or	a5,a5,a4
    80000198:	00f5a023          	sw	a5,0(a1)
    8000019c:	00450513          	addi	a0,a0,4
    800001a0:	00458593          	addi	a1,a1,4
    800001a4:	fca896e3          	bne	a7,a0,80000170 <_Z12keyExpansionPKcjP6AesKey+0x18>
    800001a8:	00862583          	lw	a1,8(a2)
    800001ac:	00462e83          	lw	t4,4(a2)
    800001b0:	00c62703          	lw	a4,12(a2)
    800001b4:	00062e03          	lw	t3,0(a2)
    800001b8:	01060693          	addi	a3,a2,16
    800001bc:	00001317          	auipc	t1,0x1
    800001c0:	5ac30313          	addi	t1,t1,1452 # 80001768 <_ZL4rcon>
    800001c4:	00001f97          	auipc	t6,0x1
    800001c8:	5ccf8f93          	addi	t6,t6,1484 # 80001790 <_ZZL20runCorrectnessChecksvE2pt>
    800001cc:	00001897          	auipc	a7,0x1
    800001d0:	61488893          	addi	a7,a7,1556 # 800017e0 <S>
    800001d4:	0ff77793          	zext.b	a5,a4
    800001d8:	0107581b          	srliw	a6,a4,0x10
    800001dc:	01875f1b          	srliw	t5,a4,0x18
    800001e0:	0087551b          	srliw	a0,a4,0x8
    800001e4:	00f887b3          	add	a5,a7,a5
    800001e8:	0ff87813          	zext.b	a6,a6
    800001ec:	0007c783          	lbu	a5,0(a5)
    800001f0:	01e88f33          	add	t5,a7,t5
    800001f4:	01088833          	add	a6,a7,a6
    800001f8:	0ff57513          	zext.b	a0,a0
    800001fc:	000f4283          	lbu	t0,0(t5)
    80000200:	00084803          	lbu	a6,0(a6)
    80000204:	00a88533          	add	a0,a7,a0
    80000208:	00054503          	lbu	a0,0(a0)
    8000020c:	0087979b          	slliw	a5,a5,0x8
    80000210:	00032f03          	lw	t5,0(t1)
    80000214:	0057c7b3          	xor	a5,a5,t0
    80000218:	0188181b          	slliw	a6,a6,0x18
    8000021c:	0107c7b3          	xor	a5,a5,a6
    80000220:	0105151b          	slliw	a0,a0,0x10
    80000224:	00a7c7b3          	xor	a5,a5,a0
    80000228:	01e7c7b3          	xor	a5,a5,t5
    8000022c:	01c7c7b3          	xor	a5,a5,t3
    80000230:	00078e1b          	sext.w	t3,a5
    80000234:	01de4eb3          	xor	t4,t3,t4
    80000238:	00bec5b3          	xor	a1,t4,a1
    8000023c:	0005859b          	sext.w	a1,a1
    80000240:	00b74733          	xor	a4,a4,a1
    80000244:	01c6a023          	sw	t3,0(a3)
    80000248:	01d6a223          	sw	t4,4(a3)
    8000024c:	00b6a423          	sw	a1,8(a3)
    80000250:	00e6a623          	sw	a4,12(a3)
    80000254:	00430313          	addi	t1,t1,4
    80000258:	01068693          	addi	a3,a3,16
    8000025c:	f66f9ce3          	bne	t6,t1,800001d4 <_Z12keyExpansionPKcjP6AesKey+0x7c>
    80000260:	00161893          	slli	a7,a2,0x1
    80000264:	0a060713          	addi	a4,a2,160
    80000268:	15088893          	addi	a7,a7,336
    8000026c:	ff060613          	addi	a2,a2,-16
    80000270:	01000813          	li	a6,16
    80000274:	40e88533          	sub	a0,a7,a4
    80000278:	00000793          	li	a5,0
    8000027c:	00f706b3          	add	a3,a4,a5
    80000280:	0006a583          	lw	a1,0(a3)
    80000284:	00f506b3          	add	a3,a0,a5
    80000288:	00478793          	addi	a5,a5,4
    8000028c:	00b6a023          	sw	a1,0(a3)
    80000290:	ff0796e3          	bne	a5,a6,8000027c <_Z12keyExpansionPKcjP6AesKey+0x124>
    80000294:	ff070713          	addi	a4,a4,-16
    80000298:	fcc71ee3          	bne	a4,a2,80000274 <_Z12keyExpansionPKcjP6AesKey+0x11c>
    8000029c:	00000513          	li	a0,0
    800002a0:	00008067          	ret
    800002a4:	fff00513          	li	a0,-1
    800002a8:	00008067          	ret

00000000800002ac <_Z11addRoundKeyPA4_cPKj>:
    800002ac:	01800313          	li	t1,24
    800002b0:	01058893          	addi	a7,a1,16
    800002b4:	ff800e13          	li	t3,-8
    800002b8:	0003081b          	sext.w	a6,t1
    800002bc:	00058713          	mv	a4,a1
    800002c0:	00050793          	mv	a5,a0
    800002c4:	00072603          	lw	a2,0(a4)
    800002c8:	0007c683          	lbu	a3,0(a5)
    800002cc:	00470713          	addi	a4,a4,4
    800002d0:	0106563b          	srlw	a2,a2,a6
    800002d4:	00c6c6b3          	xor	a3,a3,a2
    800002d8:	00d78023          	sb	a3,0(a5)
    800002dc:	00178793          	addi	a5,a5,1
    800002e0:	fee892e3          	bne	a7,a4,800002c4 <_Z11addRoundKeyPA4_cPKj+0x18>
    800002e4:	ff83031b          	addiw	t1,t1,-8
    800002e8:	00450513          	addi	a0,a0,4
    800002ec:	fdc316e3          	bne	t1,t3,800002b8 <_Z11addRoundKeyPA4_cPKj+0xc>
    800002f0:	00000513          	li	a0,0
    800002f4:	00008067          	ret

00000000800002f8 <_Z8subBytesPA4_c>:
    800002f8:	00450693          	addi	a3,a0,4
    800002fc:	01450593          	addi	a1,a0,20
    80000300:	00001617          	auipc	a2,0x1
    80000304:	4e060613          	addi	a2,a2,1248 # 800017e0 <S>
    80000308:	ffc68793          	addi	a5,a3,-4
    8000030c:	0007c703          	lbu	a4,0(a5)
    80000310:	00178793          	addi	a5,a5,1
    80000314:	00e60733          	add	a4,a2,a4
    80000318:	00074703          	lbu	a4,0(a4)
    8000031c:	fee78fa3          	sb	a4,-1(a5)
    80000320:	fed796e3          	bne	a5,a3,8000030c <_Z8subBytesPA4_c+0x14>
    80000324:	00478693          	addi	a3,a5,4
    80000328:	feb690e3          	bne	a3,a1,80000308 <_Z8subBytesPA4_c+0x10>
    8000032c:	00000513          	li	a0,0
    80000330:	00008067          	ret

0000000080000334 <_Z11invSubBytesPA4_c>:
    80000334:	00450693          	addi	a3,a0,4
    80000338:	01450593          	addi	a1,a0,20
    8000033c:	00001617          	auipc	a2,0x1
    80000340:	4a460613          	addi	a2,a2,1188 # 800017e0 <S>
    80000344:	ffc68793          	addi	a5,a3,-4
    80000348:	0007c703          	lbu	a4,0(a5)
    8000034c:	00178793          	addi	a5,a5,1
    80000350:	00e60733          	add	a4,a2,a4
    80000354:	10074703          	lbu	a4,256(a4)
    80000358:	fee78fa3          	sb	a4,-1(a5)
    8000035c:	fed796e3          	bne	a5,a3,80000348 <_Z11invSubBytesPA4_c+0x14>
    80000360:	00478693          	addi	a3,a5,4
    80000364:	feb690e3          	bne	a3,a1,80000344 <_Z11invSubBytesPA4_c+0x10>
    80000368:	00000513          	li	a0,0
    8000036c:	00008067          	ret

0000000080000370 <_Z9shiftRowsPA4_c>:
    80000370:	02000693          	li	a3,32
    80000374:	00054783          	lbu	a5,0(a0)
    80000378:	00154603          	lbu	a2,1(a0)
    8000037c:	00354583          	lbu	a1,3(a0)
    80000380:	00254703          	lbu	a4,2(a0)
    80000384:	0106161b          	slliw	a2,a2,0x10
    80000388:	0187979b          	slliw	a5,a5,0x18
    8000038c:	00c7e7b3          	or	a5,a5,a2
    80000390:	00b7e7b3          	or	a5,a5,a1
    80000394:	0087171b          	slliw	a4,a4,0x8
    80000398:	40d0063b          	negw	a2,a3
    8000039c:	00e7e7b3          	or	a5,a5,a4
    800003a0:	00d7d73b          	srlw	a4,a5,a3
    800003a4:	00c797bb          	sllw	a5,a5,a2
    800003a8:	00f767b3          	or	a5,a4,a5
    800003ac:	0187d59b          	srliw	a1,a5,0x18
    800003b0:	0107d61b          	srliw	a2,a5,0x10
    800003b4:	0087d71b          	srliw	a4,a5,0x8
    800003b8:	00b50023          	sb	a1,0(a0)
    800003bc:	00c500a3          	sb	a2,1(a0)
    800003c0:	00e50123          	sb	a4,2(a0)
    800003c4:	00f501a3          	sb	a5,3(a0)
    800003c8:	ff86869b          	addiw	a3,a3,-8
    800003cc:	00450513          	addi	a0,a0,4
    800003d0:	fa0692e3          	bnez	a3,80000374 <_Z9shiftRowsPA4_c+0x4>
    800003d4:	00000513          	li	a0,0
    800003d8:	00008067          	ret

00000000800003dc <_Z12invShiftRowsPA4_c>:
    800003dc:	02000693          	li	a3,32
    800003e0:	00054783          	lbu	a5,0(a0)
    800003e4:	00154603          	lbu	a2,1(a0)
    800003e8:	00354583          	lbu	a1,3(a0)
    800003ec:	00254703          	lbu	a4,2(a0)
    800003f0:	0106161b          	slliw	a2,a2,0x10
    800003f4:	0187979b          	slliw	a5,a5,0x18
    800003f8:	00c7e7b3          	or	a5,a5,a2
    800003fc:	00b7e7b3          	or	a5,a5,a1
    80000400:	0087171b          	slliw	a4,a4,0x8
    80000404:	40d0063b          	negw	a2,a3
    80000408:	00e7e7b3          	or	a5,a5,a4
    8000040c:	00d7973b          	sllw	a4,a5,a3
    80000410:	00c7d7bb          	srlw	a5,a5,a2
    80000414:	00f767b3          	or	a5,a4,a5
    80000418:	0187d59b          	srliw	a1,a5,0x18
    8000041c:	0107d61b          	srliw	a2,a5,0x10
    80000420:	0087d71b          	srliw	a4,a5,0x8
    80000424:	00b50023          	sb	a1,0(a0)
    80000428:	00c500a3          	sb	a2,1(a0)
    8000042c:	00e50123          	sb	a4,2(a0)
    80000430:	00f501a3          	sb	a5,3(a0)
    80000434:	ff86869b          	addiw	a3,a3,-8
    80000438:	00450513          	addi	a0,a0,4
    8000043c:	fa0692e3          	bnez	a3,800003e0 <_Z12invShiftRowsPA4_c+0x4>
    80000440:	00000513          	li	a0,0
    80000444:	00008067          	ret

0000000080000448 <_Z4GMulcc>:
    80000448:	00050713          	mv	a4,a0
    8000044c:	00800693          	li	a3,8
    80000450:	00000513          	li	a0,0
    80000454:	00177793          	andi	a5,a4,1
    80000458:	0185961b          	slliw	a2,a1,0x18
    8000045c:	40f007bb          	negw	a5,a5
    80000460:	00f5f7b3          	and	a5,a1,a5
    80000464:	0015981b          	slliw	a6,a1,0x1
    80000468:	4186561b          	sraiw	a2,a2,0x18
    8000046c:	fff6869b          	addiw	a3,a3,-1
    80000470:	0fe87593          	andi	a1,a6,254
    80000474:	00f54533          	xor	a0,a0,a5
    80000478:	00065463          	bgez	a2,80000480 <_Z4GMulcc+0x38>
    8000047c:	01b5c593          	xori	a1,a1,27
    80000480:	00175713          	srli	a4,a4,0x1
    80000484:	fc0698e3          	bnez	a3,80000454 <_Z4GMulcc+0xc>
    80000488:	00008067          	ret

000000008000048c <_Z10mixColumnsPA4_c>:
    8000048c:	fc010113          	addi	sp,sp,-64
    80000490:	00001797          	auipc	a5,0x1
    80000494:	3307b783          	ld	a5,816(a5) # 800017c0 <_ZZL20runCorrectnessChecksvE10expectedCt+0x10>
    80000498:	00f13823          	sd	a5,16(sp)
    8000049c:	010008b7          	lui	a7,0x1000
    800004a0:	00001797          	auipc	a5,0x1
    800004a4:	3287b783          	ld	a5,808(a5) # 800017c8 <_ZZL20runCorrectnessChecksvE10expectedCt+0x18>
    800004a8:	02813c23          	sd	s0,56(sp)
    800004ac:	02913823          	sd	s1,48(sp)
    800004b0:	03213423          	sd	s2,40(sp)
    800004b4:	00f13c23          	sd	a5,24(sp)
    800004b8:	01050313          	addi	t1,a0,16
    800004bc:	00010813          	mv	a6,sp
    800004c0:	00050713          	mv	a4,a0
    800004c4:	fff88893          	addi	a7,a7,-1 # ffffff <STACK_SIZE+0xff7fff>
    800004c8:	00174583          	lbu	a1,1(a4)
    800004cc:	00274603          	lbu	a2,2(a4)
    800004d0:	00074783          	lbu	a5,0(a4)
    800004d4:	00374683          	lbu	a3,3(a4)
    800004d8:	0085959b          	slliw	a1,a1,0x8
    800004dc:	00b7e7b3          	or	a5,a5,a1
    800004e0:	0106161b          	slliw	a2,a2,0x10
    800004e4:	00c7e7b3          	or	a5,a5,a2
    800004e8:	0186969b          	slliw	a3,a3,0x18
    800004ec:	0117f7b3          	and	a5,a5,a7
    800004f0:	00d7e7b3          	or	a5,a5,a3
    800004f4:	00f82023          	sw	a5,0(a6)
    800004f8:	00470713          	addi	a4,a4,4
    800004fc:	00480813          	addi	a6,a6,4
    80000500:	fce314e3          	bne	t1,a4,800004c8 <_Z10mixColumnsPA4_c+0x3c>
    80000504:	01010593          	addi	a1,sp,16
    80000508:	02010f13          	addi	t5,sp,32
    8000050c:	00410e93          	addi	t4,sp,4
    80000510:	0005ce03          	lbu	t3,0(a1)
    80000514:	0015c303          	lbu	t1,1(a1)
    80000518:	0025c883          	lbu	a7,2(a1)
    8000051c:	0035c803          	lbu	a6,3(a1)
    80000520:	00050613          	mv	a2,a0
    80000524:	00010693          	mv	a3,sp
    80000528:	0006cf83          	lbu	t6,0(a3)
    8000052c:	000e0713          	mv	a4,t3
    80000530:	00800293          	li	t0,8
    80000534:	00000413          	li	s0,0
    80000538:	00177793          	andi	a5,a4,1
    8000053c:	018f939b          	slliw	t2,t6,0x18
    80000540:	40f007bb          	negw	a5,a5
    80000544:	00fff7b3          	and	a5,t6,a5
    80000548:	001f949b          	slliw	s1,t6,0x1
    8000054c:	4183d39b          	sraiw	t2,t2,0x18
    80000550:	0017571b          	srliw	a4,a4,0x1
    80000554:	fff2829b          	addiw	t0,t0,-1
    80000558:	0fe4ff93          	andi	t6,s1,254
    8000055c:	00f44433          	xor	s0,s0,a5
    80000560:	0003d463          	bgez	t2,80000568 <_Z10mixColumnsPA4_c+0xdc>
    80000564:	01bfcf93          	xori	t6,t6,27
    80000568:	0ff77713          	zext.b	a4,a4
    8000056c:	fc0296e3          	bnez	t0,80000538 <_Z10mixColumnsPA4_c+0xac>
    80000570:	0046cf83          	lbu	t6,4(a3)
    80000574:	00030713          	mv	a4,t1
    80000578:	00800393          	li	t2,8
    8000057c:	00177793          	andi	a5,a4,1
    80000580:	018f949b          	slliw	s1,t6,0x18
    80000584:	40f007bb          	negw	a5,a5
    80000588:	00fff7b3          	and	a5,t6,a5
    8000058c:	001f991b          	slliw	s2,t6,0x1
    80000590:	4184d49b          	sraiw	s1,s1,0x18
    80000594:	0017571b          	srliw	a4,a4,0x1
    80000598:	fff3839b          	addiw	t2,t2,-1
    8000059c:	0fe97f93          	andi	t6,s2,254
    800005a0:	00f2c2b3          	xor	t0,t0,a5
    800005a4:	0004d463          	bgez	s1,800005ac <_Z10mixColumnsPA4_c+0x120>
    800005a8:	01bfcf93          	xori	t6,t6,27
    800005ac:	0ff77713          	zext.b	a4,a4
    800005b0:	fc0396e3          	bnez	t2,8000057c <_Z10mixColumnsPA4_c+0xf0>
    800005b4:	0086cf83          	lbu	t6,8(a3)
    800005b8:	0082c2b3          	xor	t0,t0,s0
    800005bc:	00088713          	mv	a4,a7
    800005c0:	00800393          	li	t2,8
    800005c4:	00000413          	li	s0,0
    800005c8:	00177793          	andi	a5,a4,1
    800005cc:	018f949b          	slliw	s1,t6,0x18
    800005d0:	40f007bb          	negw	a5,a5
    800005d4:	00fff7b3          	and	a5,t6,a5
    800005d8:	001f991b          	slliw	s2,t6,0x1
    800005dc:	4184d49b          	sraiw	s1,s1,0x18
    800005e0:	0017571b          	srliw	a4,a4,0x1
    800005e4:	fff3839b          	addiw	t2,t2,-1
    800005e8:	0fe97f93          	andi	t6,s2,254
    800005ec:	00f44433          	xor	s0,s0,a5
    800005f0:	0004d463          	bgez	s1,800005f8 <_Z10mixColumnsPA4_c+0x16c>
    800005f4:	01bfcf93          	xori	t6,t6,27
    800005f8:	0ff77713          	zext.b	a4,a4
    800005fc:	fc0396e3          	bnez	t2,800005c8 <_Z10mixColumnsPA4_c+0x13c>
    80000600:	00c6cf83          	lbu	t6,12(a3)
    80000604:	0082c2b3          	xor	t0,t0,s0
    80000608:	0ff2f293          	zext.b	t0,t0
    8000060c:	00080713          	mv	a4,a6
    80000610:	00800393          	li	t2,8
    80000614:	00000413          	li	s0,0
    80000618:	00177793          	andi	a5,a4,1
    8000061c:	018f949b          	slliw	s1,t6,0x18
    80000620:	40f007bb          	negw	a5,a5
    80000624:	00fff7b3          	and	a5,t6,a5
    80000628:	001f991b          	slliw	s2,t6,0x1
    8000062c:	4184d49b          	sraiw	s1,s1,0x18
    80000630:	0017571b          	srliw	a4,a4,0x1
    80000634:	fff3839b          	addiw	t2,t2,-1
    80000638:	0fe97f93          	andi	t6,s2,254
    8000063c:	00f44433          	xor	s0,s0,a5
    80000640:	0004d463          	bgez	s1,80000648 <_Z10mixColumnsPA4_c+0x1bc>
    80000644:	01bfcf93          	xori	t6,t6,27
    80000648:	0ff77713          	zext.b	a4,a4
    8000064c:	fc0396e3          	bnez	t2,80000618 <_Z10mixColumnsPA4_c+0x18c>
    80000650:	0082c7b3          	xor	a5,t0,s0
    80000654:	00f60023          	sb	a5,0(a2)
    80000658:	00168693          	addi	a3,a3,1
    8000065c:	00160613          	addi	a2,a2,1
    80000660:	ecde94e3          	bne	t4,a3,80000528 <_Z10mixColumnsPA4_c+0x9c>
    80000664:	00458593          	addi	a1,a1,4
    80000668:	00450513          	addi	a0,a0,4
    8000066c:	ebe592e3          	bne	a1,t5,80000510 <_Z10mixColumnsPA4_c+0x84>
    80000670:	03813403          	ld	s0,56(sp)
    80000674:	03013483          	ld	s1,48(sp)
    80000678:	02813903          	ld	s2,40(sp)
    8000067c:	00000513          	li	a0,0
    80000680:	04010113          	addi	sp,sp,64
    80000684:	00008067          	ret

0000000080000688 <_Z13invMixColumnsPA4_c>:
    80000688:	fc010113          	addi	sp,sp,-64
    8000068c:	00001797          	auipc	a5,0x1
    80000690:	1447b783          	ld	a5,324(a5) # 800017d0 <_ZZL20runCorrectnessChecksvE10expectedCt+0x20>
    80000694:	00f13823          	sd	a5,16(sp)
    80000698:	010008b7          	lui	a7,0x1000
    8000069c:	00001797          	auipc	a5,0x1
    800006a0:	13c7b783          	ld	a5,316(a5) # 800017d8 <_ZZL20runCorrectnessChecksvE10expectedCt+0x28>
    800006a4:	02813c23          	sd	s0,56(sp)
    800006a8:	02913823          	sd	s1,48(sp)
    800006ac:	03213423          	sd	s2,40(sp)
    800006b0:	00f13c23          	sd	a5,24(sp)
    800006b4:	01050313          	addi	t1,a0,16
    800006b8:	00010813          	mv	a6,sp
    800006bc:	00050713          	mv	a4,a0
    800006c0:	fff88893          	addi	a7,a7,-1 # ffffff <STACK_SIZE+0xff7fff>
    800006c4:	00174583          	lbu	a1,1(a4)
    800006c8:	00274603          	lbu	a2,2(a4)
    800006cc:	00074783          	lbu	a5,0(a4)
    800006d0:	00374683          	lbu	a3,3(a4)
    800006d4:	0085959b          	slliw	a1,a1,0x8
    800006d8:	00b7e7b3          	or	a5,a5,a1
    800006dc:	0106161b          	slliw	a2,a2,0x10
    800006e0:	00c7e7b3          	or	a5,a5,a2
    800006e4:	0186969b          	slliw	a3,a3,0x18
    800006e8:	0117f7b3          	and	a5,a5,a7
    800006ec:	00d7e7b3          	or	a5,a5,a3
    800006f0:	00f82023          	sw	a5,0(a6)
    800006f4:	00470713          	addi	a4,a4,4
    800006f8:	00480813          	addi	a6,a6,4
    800006fc:	fce314e3          	bne	t1,a4,800006c4 <_Z13invMixColumnsPA4_c+0x3c>
    80000700:	01010593          	addi	a1,sp,16
    80000704:	02010f13          	addi	t5,sp,32
    80000708:	00410e93          	addi	t4,sp,4
    8000070c:	0005ce03          	lbu	t3,0(a1)
    80000710:	0015c303          	lbu	t1,1(a1)
    80000714:	0025c883          	lbu	a7,2(a1)
    80000718:	0035c803          	lbu	a6,3(a1)
    8000071c:	00050613          	mv	a2,a0
    80000720:	00010693          	mv	a3,sp
    80000724:	0006cf83          	lbu	t6,0(a3)
    80000728:	000e0713          	mv	a4,t3
    8000072c:	00800293          	li	t0,8
    80000730:	00000413          	li	s0,0
    80000734:	00177793          	andi	a5,a4,1
    80000738:	018f939b          	slliw	t2,t6,0x18
    8000073c:	40f007bb          	negw	a5,a5
    80000740:	00fff7b3          	and	a5,t6,a5
    80000744:	001f949b          	slliw	s1,t6,0x1
    80000748:	4183d39b          	sraiw	t2,t2,0x18
    8000074c:	0017571b          	srliw	a4,a4,0x1
    80000750:	fff2829b          	addiw	t0,t0,-1
    80000754:	0fe4ff93          	andi	t6,s1,254
    80000758:	00f44433          	xor	s0,s0,a5
    8000075c:	0003d463          	bgez	t2,80000764 <_Z13invMixColumnsPA4_c+0xdc>
    80000760:	01bfcf93          	xori	t6,t6,27
    80000764:	0ff77713          	zext.b	a4,a4
    80000768:	fc0296e3          	bnez	t0,80000734 <_Z13invMixColumnsPA4_c+0xac>
    8000076c:	0046cf83          	lbu	t6,4(a3)
    80000770:	00030713          	mv	a4,t1
    80000774:	00800393          	li	t2,8
    80000778:	00177793          	andi	a5,a4,1
    8000077c:	018f949b          	slliw	s1,t6,0x18
    80000780:	40f007bb          	negw	a5,a5
    80000784:	00fff7b3          	and	a5,t6,a5
    80000788:	001f991b          	slliw	s2,t6,0x1
    8000078c:	4184d49b          	sraiw	s1,s1,0x18
    80000790:	0017571b          	srliw	a4,a4,0x1
    80000794:	fff3839b          	addiw	t2,t2,-1
    80000798:	0fe97f93          	andi	t6,s2,254
    8000079c:	00f2c2b3          	xor	t0,t0,a5
    800007a0:	0004d463          	bgez	s1,800007a8 <_Z13invMixColumnsPA4_c+0x120>
    800007a4:	01bfcf93          	xori	t6,t6,27
    800007a8:	0ff77713          	zext.b	a4,a4
    800007ac:	fc0396e3          	bnez	t2,80000778 <_Z13invMixColumnsPA4_c+0xf0>
    800007b0:	0086cf83          	lbu	t6,8(a3)
    800007b4:	0082c2b3          	xor	t0,t0,s0
    800007b8:	00088713          	mv	a4,a7
    800007bc:	00800393          	li	t2,8
    800007c0:	00000413          	li	s0,0
    800007c4:	00177793          	andi	a5,a4,1
    800007c8:	018f949b          	slliw	s1,t6,0x18
    800007cc:	40f007bb          	negw	a5,a5
    800007d0:	00fff7b3          	and	a5,t6,a5
    800007d4:	001f991b          	slliw	s2,t6,0x1
    800007d8:	4184d49b          	sraiw	s1,s1,0x18
    800007dc:	0017571b          	srliw	a4,a4,0x1
    800007e0:	fff3839b          	addiw	t2,t2,-1
    800007e4:	0fe97f93          	andi	t6,s2,254
    800007e8:	00f44433          	xor	s0,s0,a5
    800007ec:	0004d463          	bgez	s1,800007f4 <_Z13invMixColumnsPA4_c+0x16c>
    800007f0:	01bfcf93          	xori	t6,t6,27
    800007f4:	0ff77713          	zext.b	a4,a4
    800007f8:	fc0396e3          	bnez	t2,800007c4 <_Z13invMixColumnsPA4_c+0x13c>
    800007fc:	00c6cf83          	lbu	t6,12(a3)
    80000800:	0082c2b3          	xor	t0,t0,s0
    80000804:	0ff2f293          	zext.b	t0,t0
    80000808:	00080713          	mv	a4,a6
    8000080c:	00800393          	li	t2,8
    80000810:	00000413          	li	s0,0
    80000814:	00177793          	andi	a5,a4,1
    80000818:	018f949b          	slliw	s1,t6,0x18
    8000081c:	40f007bb          	negw	a5,a5
    80000820:	00fff7b3          	and	a5,t6,a5
    80000824:	001f991b          	slliw	s2,t6,0x1
    80000828:	4184d49b          	sraiw	s1,s1,0x18
    8000082c:	0017571b          	srliw	a4,a4,0x1
    80000830:	fff3839b          	addiw	t2,t2,-1
    80000834:	0fe97f93          	andi	t6,s2,254
    80000838:	00f44433          	xor	s0,s0,a5
    8000083c:	0004d463          	bgez	s1,80000844 <_Z13invMixColumnsPA4_c+0x1bc>
    80000840:	01bfcf93          	xori	t6,t6,27
    80000844:	0ff77713          	zext.b	a4,a4
    80000848:	fc0396e3          	bnez	t2,80000814 <_Z13invMixColumnsPA4_c+0x18c>
    8000084c:	0082c7b3          	xor	a5,t0,s0
    80000850:	00f60023          	sb	a5,0(a2)
    80000854:	00168693          	addi	a3,a3,1
    80000858:	00160613          	addi	a2,a2,1
    8000085c:	ecde94e3          	bne	t4,a3,80000724 <_Z13invMixColumnsPA4_c+0x9c>
    80000860:	00458593          	addi	a1,a1,4
    80000864:	00450513          	addi	a0,a0,4
    80000868:	ebe592e3          	bne	a1,t5,8000070c <_Z13invMixColumnsPA4_c+0x84>
    8000086c:	03813403          	ld	s0,56(sp)
    80000870:	03013483          	ld	s1,48(sp)
    80000874:	02813903          	ld	s2,40(sp)
    80000878:	00000513          	li	a0,0
    8000087c:	04010113          	addi	sp,sp,64
    80000880:	00008067          	ret

0000000080000884 <_Z10aesEncryptPKcjS0_Pcj>:
    80000884:	e2010113          	addi	sp,sp,-480
    80000888:	1c113c23          	sd	ra,472(sp)
    8000088c:	00013423          	sd	zero,8(sp)
    80000890:	00013823          	sd	zero,16(sp)
    80000894:	00013c23          	sd	zero,24(sp)
    80000898:	02013023          	sd	zero,32(sp)
    8000089c:	1e050e63          	beqz	a0,80000a98 <_Z10aesEncryptPKcjS0_Pcj+0x214>
    800008a0:	1c813823          	sd	s0,464(sp)
    800008a4:	00060413          	mv	s0,a2
    800008a8:	20060e63          	beqz	a2,80000ac4 <_Z10aesEncryptPKcjS0_Pcj+0x240>
    800008ac:	1b413823          	sd	s4,432(sp)
    800008b0:	00068a13          	mv	s4,a3
    800008b4:	20068063          	beqz	a3,80000ab4 <_Z10aesEncryptPKcjS0_Pcj+0x230>
    800008b8:	1c913423          	sd	s1,456(sp)
    800008bc:	00070493          	mv	s1,a4
    800008c0:	01000713          	li	a4,16
    800008c4:	1cb76e63          	bltu	a4,a1,80000aa0 <_Z10aesEncryptPKcjS0_Pcj+0x21c>
    800008c8:	00f4f713          	andi	a4,s1,15
    800008cc:	1c071a63          	bnez	a4,80000aa0 <_Z10aesEncryptPKcjS0_Pcj+0x21c>
    800008d0:	1c058063          	beqz	a1,80000a90 <_Z10aesEncryptPKcjS0_Pcj+0x20c>
    800008d4:	02059693          	slli	a3,a1,0x20
    800008d8:	00050793          	mv	a5,a0
    800008dc:	0206d693          	srli	a3,a3,0x20
    800008e0:	00810513          	addi	a0,sp,8
    800008e4:	00078713          	mv	a4,a5
    800008e8:	00d506b3          	add	a3,a0,a3
    800008ec:	00050793          	mv	a5,a0
    800008f0:	00074603          	lbu	a2,0(a4)
    800008f4:	00178793          	addi	a5,a5,1
    800008f8:	00170713          	addi	a4,a4,1
    800008fc:	fec78fa3          	sb	a2,-1(a5)
    80000900:	fed798e3          	bne	a5,a3,800008f0 <_Z10aesEncryptPKcjS0_Pcj+0x6c>
    80000904:	02810613          	addi	a2,sp,40
    80000908:	01000593          	li	a1,16
    8000090c:	84dff0ef          	jal	80000158 <_Z12keyExpansionPKcjP6AesKey>
    80000910:	16048263          	beqz	s1,80000a74 <_Z10aesEncryptPKcjS0_Pcj+0x1f0>
    80000914:	fff4879b          	addiw	a5,s1,-1
    80000918:	0047d79b          	srliw	a5,a5,0x4
    8000091c:	00479793          	slli	a5,a5,0x4
    80000920:	01478793          	addi	a5,a5,20
    80000924:	1d213023          	sd	s2,448(sp)
    80000928:	1b513423          	sd	s5,424(sp)
    8000092c:	1b613023          	sd	s6,416(sp)
    80000930:	004a0a93          	addi	s5,s4,4
    80000934:	00440693          	addi	a3,s0,4
    80000938:	1b313c23          	sd	s3,440(sp)
    8000093c:	19713c23          	sd	s7,408(sp)
    80000940:	19813823          	sd	s8,400(sp)
    80000944:	00fa0a33          	add	s4,s4,a5
    80000948:	00001417          	auipc	s0,0x1
    8000094c:	e9840413          	addi	s0,s0,-360 # 800017e0 <S>
    80000950:	0b810913          	addi	s2,sp,184
    80000954:	02c10b13          	addi	s6,sp,44
    80000958:	01810493          	addi	s1,sp,24
    8000095c:	00048593          	mv	a1,s1
    80000960:	01068993          	addi	s3,a3,16
    80000964:	ffc68793          	addi	a5,a3,-4
    80000968:	00058713          	mv	a4,a1
    8000096c:	0007c603          	lbu	a2,0(a5)
    80000970:	00178793          	addi	a5,a5,1
    80000974:	00470713          	addi	a4,a4,4
    80000978:	fec70e23          	sb	a2,-4(a4)
    8000097c:	fed798e3          	bne	a5,a3,8000096c <_Z10aesEncryptPKcjS0_Pcj+0xe8>
    80000980:	00478693          	addi	a3,a5,4
    80000984:	00158593          	addi	a1,a1,1
    80000988:	fd369ee3          	bne	a3,s3,80000964 <_Z10aesEncryptPKcjS0_Pcj+0xe0>
    8000098c:	02810593          	addi	a1,sp,40
    80000990:	01810513          	addi	a0,sp,24
    80000994:	919ff0ef          	jal	800002ac <_Z11addRoundKeyPA4_cPKj>
    80000998:	02810b93          	addi	s7,sp,40
    8000099c:	01c10c13          	addi	s8,sp,28
    800009a0:	010b8b93          	addi	s7,s7,16
    800009a4:	000c0693          	mv	a3,s8
    800009a8:	ffc68793          	addi	a5,a3,-4
    800009ac:	0007c703          	lbu	a4,0(a5)
    800009b0:	00178793          	addi	a5,a5,1
    800009b4:	00e40733          	add	a4,s0,a4
    800009b8:	00074703          	lbu	a4,0(a4)
    800009bc:	fee78fa3          	sb	a4,-1(a5)
    800009c0:	fed796e3          	bne	a5,a3,800009ac <_Z10aesEncryptPKcjS0_Pcj+0x128>
    800009c4:	00478693          	addi	a3,a5,4
    800009c8:	ff6690e3          	bne	a3,s6,800009a8 <_Z10aesEncryptPKcjS0_Pcj+0x124>
    800009cc:	01810513          	addi	a0,sp,24
    800009d0:	9a1ff0ef          	jal	80000370 <_Z9shiftRowsPA4_c>
    800009d4:	01810513          	addi	a0,sp,24
    800009d8:	ab5ff0ef          	jal	8000048c <_Z10mixColumnsPA4_c>
    800009dc:	000b8593          	mv	a1,s7
    800009e0:	01810513          	addi	a0,sp,24
    800009e4:	8c9ff0ef          	jal	800002ac <_Z11addRoundKeyPA4_cPKj>
    800009e8:	fb2b9ae3          	bne	s7,s2,8000099c <_Z10aesEncryptPKcjS0_Pcj+0x118>
    800009ec:	ffcc0793          	addi	a5,s8,-4
    800009f0:	0007c703          	lbu	a4,0(a5)
    800009f4:	00178793          	addi	a5,a5,1
    800009f8:	00e40733          	add	a4,s0,a4
    800009fc:	00074703          	lbu	a4,0(a4)
    80000a00:	fee78fa3          	sb	a4,-1(a5)
    80000a04:	ff8796e3          	bne	a5,s8,800009f0 <_Z10aesEncryptPKcjS0_Pcj+0x16c>
    80000a08:	00478c13          	addi	s8,a5,4
    80000a0c:	ff6c10e3          	bne	s8,s6,800009ec <_Z10aesEncryptPKcjS0_Pcj+0x168>
    80000a10:	01810513          	addi	a0,sp,24
    80000a14:	95dff0ef          	jal	80000370 <_Z9shiftRowsPA4_c>
    80000a18:	0c810593          	addi	a1,sp,200
    80000a1c:	01810513          	addi	a0,sp,24
    80000a20:	88dff0ef          	jal	800002ac <_Z11addRoundKeyPA4_cPKj>
    80000a24:	010a8613          	addi	a2,s5,16
    80000a28:	ffca8793          	addi	a5,s5,-4
    80000a2c:	00048713          	mv	a4,s1
    80000a30:	00074683          	lbu	a3,0(a4)
    80000a34:	00178793          	addi	a5,a5,1
    80000a38:	00470713          	addi	a4,a4,4
    80000a3c:	fed78fa3          	sb	a3,-1(a5)
    80000a40:	ff5798e3          	bne	a5,s5,80000a30 <_Z10aesEncryptPKcjS0_Pcj+0x1ac>
    80000a44:	00478a93          	addi	s5,a5,4
    80000a48:	00148493          	addi	s1,s1,1
    80000a4c:	fcca9ee3          	bne	s5,a2,80000a28 <_Z10aesEncryptPKcjS0_Pcj+0x1a4>
    80000a50:	015a0663          	beq	s4,s5,80000a5c <_Z10aesEncryptPKcjS0_Pcj+0x1d8>
    80000a54:	00098693          	mv	a3,s3
    80000a58:	f01ff06f          	j	80000958 <_Z10aesEncryptPKcjS0_Pcj+0xd4>
    80000a5c:	1c013903          	ld	s2,448(sp)
    80000a60:	1b813983          	ld	s3,440(sp)
    80000a64:	1a813a83          	ld	s5,424(sp)
    80000a68:	1a013b03          	ld	s6,416(sp)
    80000a6c:	19813b83          	ld	s7,408(sp)
    80000a70:	19013c03          	ld	s8,400(sp)
    80000a74:	1d013403          	ld	s0,464(sp)
    80000a78:	1c813483          	ld	s1,456(sp)
    80000a7c:	1b013a03          	ld	s4,432(sp)
    80000a80:	00000513          	li	a0,0
    80000a84:	1d813083          	ld	ra,472(sp)
    80000a88:	1e010113          	addi	sp,sp,480
    80000a8c:	00008067          	ret
    80000a90:	00810513          	addi	a0,sp,8
    80000a94:	e71ff06f          	j	80000904 <_Z10aesEncryptPKcjS0_Pcj+0x80>
    80000a98:	fff00513          	li	a0,-1
    80000a9c:	fe9ff06f          	j	80000a84 <_Z10aesEncryptPKcjS0_Pcj+0x200>
    80000aa0:	1d013403          	ld	s0,464(sp)
    80000aa4:	1c813483          	ld	s1,456(sp)
    80000aa8:	1b013a03          	ld	s4,432(sp)
    80000aac:	fff00513          	li	a0,-1
    80000ab0:	fd5ff06f          	j	80000a84 <_Z10aesEncryptPKcjS0_Pcj+0x200>
    80000ab4:	1d013403          	ld	s0,464(sp)
    80000ab8:	1b013a03          	ld	s4,432(sp)
    80000abc:	fff00513          	li	a0,-1
    80000ac0:	fc5ff06f          	j	80000a84 <_Z10aesEncryptPKcjS0_Pcj+0x200>
    80000ac4:	1d013403          	ld	s0,464(sp)
    80000ac8:	fff00513          	li	a0,-1
    80000acc:	fb9ff06f          	j	80000a84 <_Z10aesEncryptPKcjS0_Pcj+0x200>

0000000080000ad0 <_Z10aesDecryptPKcjS0_Pcj>:
    80000ad0:	e2010113          	addi	sp,sp,-480
    80000ad4:	1c113c23          	sd	ra,472(sp)
    80000ad8:	00013423          	sd	zero,8(sp)
    80000adc:	00013823          	sd	zero,16(sp)
    80000ae0:	00013c23          	sd	zero,24(sp)
    80000ae4:	02013023          	sd	zero,32(sp)
    80000ae8:	1e050e63          	beqz	a0,80000ce4 <_Z10aesDecryptPKcjS0_Pcj+0x214>
    80000aec:	1c813823          	sd	s0,464(sp)
    80000af0:	00060413          	mv	s0,a2
    80000af4:	20060e63          	beqz	a2,80000d10 <_Z10aesDecryptPKcjS0_Pcj+0x240>
    80000af8:	1b413823          	sd	s4,432(sp)
    80000afc:	00068a13          	mv	s4,a3
    80000b00:	20068063          	beqz	a3,80000d00 <_Z10aesDecryptPKcjS0_Pcj+0x230>
    80000b04:	1c913423          	sd	s1,456(sp)
    80000b08:	00070493          	mv	s1,a4
    80000b0c:	01000713          	li	a4,16
    80000b10:	1cb76e63          	bltu	a4,a1,80000cec <_Z10aesDecryptPKcjS0_Pcj+0x21c>
    80000b14:	00f4f713          	andi	a4,s1,15
    80000b18:	1c071a63          	bnez	a4,80000cec <_Z10aesDecryptPKcjS0_Pcj+0x21c>
    80000b1c:	1c058063          	beqz	a1,80000cdc <_Z10aesDecryptPKcjS0_Pcj+0x20c>
    80000b20:	02059693          	slli	a3,a1,0x20
    80000b24:	00050793          	mv	a5,a0
    80000b28:	0206d693          	srli	a3,a3,0x20
    80000b2c:	00810513          	addi	a0,sp,8
    80000b30:	00078713          	mv	a4,a5
    80000b34:	00d506b3          	add	a3,a0,a3
    80000b38:	00050793          	mv	a5,a0
    80000b3c:	00074603          	lbu	a2,0(a4)
    80000b40:	00178793          	addi	a5,a5,1
    80000b44:	00170713          	addi	a4,a4,1
    80000b48:	fec78fa3          	sb	a2,-1(a5)
    80000b4c:	fed798e3          	bne	a5,a3,80000b3c <_Z10aesDecryptPKcjS0_Pcj+0x6c>
    80000b50:	02810613          	addi	a2,sp,40
    80000b54:	01000593          	li	a1,16
    80000b58:	e00ff0ef          	jal	80000158 <_Z12keyExpansionPKcjP6AesKey>
    80000b5c:	16048263          	beqz	s1,80000cc0 <_Z10aesDecryptPKcjS0_Pcj+0x1f0>
    80000b60:	fff4879b          	addiw	a5,s1,-1
    80000b64:	0047d79b          	srliw	a5,a5,0x4
    80000b68:	00479793          	slli	a5,a5,0x4
    80000b6c:	01478793          	addi	a5,a5,20
    80000b70:	1d213023          	sd	s2,448(sp)
    80000b74:	1b513423          	sd	s5,424(sp)
    80000b78:	1b613023          	sd	s6,416(sp)
    80000b7c:	004a0a93          	addi	s5,s4,4
    80000b80:	00440693          	addi	a3,s0,4
    80000b84:	1b313c23          	sd	s3,440(sp)
    80000b88:	19713c23          	sd	s7,408(sp)
    80000b8c:	19813823          	sd	s8,400(sp)
    80000b90:	00fa0a33          	add	s4,s4,a5
    80000b94:	00001417          	auipc	s0,0x1
    80000b98:	c4c40413          	addi	s0,s0,-948 # 800017e0 <S>
    80000b9c:	16810913          	addi	s2,sp,360
    80000ba0:	02c10b13          	addi	s6,sp,44
    80000ba4:	01810493          	addi	s1,sp,24
    80000ba8:	00048593          	mv	a1,s1
    80000bac:	01068993          	addi	s3,a3,16
    80000bb0:	ffc68793          	addi	a5,a3,-4
    80000bb4:	00058713          	mv	a4,a1
    80000bb8:	0007c603          	lbu	a2,0(a5)
    80000bbc:	00178793          	addi	a5,a5,1
    80000bc0:	00470713          	addi	a4,a4,4
    80000bc4:	fec70e23          	sb	a2,-4(a4)
    80000bc8:	fed798e3          	bne	a5,a3,80000bb8 <_Z10aesDecryptPKcjS0_Pcj+0xe8>
    80000bcc:	00478693          	addi	a3,a5,4
    80000bd0:	00158593          	addi	a1,a1,1
    80000bd4:	fd369ee3          	bne	a3,s3,80000bb0 <_Z10aesDecryptPKcjS0_Pcj+0xe0>
    80000bd8:	0d810593          	addi	a1,sp,216
    80000bdc:	01810513          	addi	a0,sp,24
    80000be0:	eccff0ef          	jal	800002ac <_Z11addRoundKeyPA4_cPKj>
    80000be4:	0d810b93          	addi	s7,sp,216
    80000be8:	01810513          	addi	a0,sp,24
    80000bec:	ff0ff0ef          	jal	800003dc <_Z12invShiftRowsPA4_c>
    80000bf0:	01c10c13          	addi	s8,sp,28
    80000bf4:	010b8b93          	addi	s7,s7,16
    80000bf8:	000c0693          	mv	a3,s8
    80000bfc:	ffc68793          	addi	a5,a3,-4
    80000c00:	0007c703          	lbu	a4,0(a5)
    80000c04:	00178793          	addi	a5,a5,1
    80000c08:	00e40733          	add	a4,s0,a4
    80000c0c:	10074703          	lbu	a4,256(a4)
    80000c10:	fee78fa3          	sb	a4,-1(a5)
    80000c14:	fed796e3          	bne	a5,a3,80000c00 <_Z10aesDecryptPKcjS0_Pcj+0x130>
    80000c18:	00478693          	addi	a3,a5,4
    80000c1c:	ff6690e3          	bne	a3,s6,80000bfc <_Z10aesDecryptPKcjS0_Pcj+0x12c>
    80000c20:	000b8593          	mv	a1,s7
    80000c24:	01810513          	addi	a0,sp,24
    80000c28:	e84ff0ef          	jal	800002ac <_Z11addRoundKeyPA4_cPKj>
    80000c2c:	01810513          	addi	a0,sp,24
    80000c30:	a59ff0ef          	jal	80000688 <_Z13invMixColumnsPA4_c>
    80000c34:	fb2b9ae3          	bne	s7,s2,80000be8 <_Z10aesDecryptPKcjS0_Pcj+0x118>
    80000c38:	ffcc0793          	addi	a5,s8,-4
    80000c3c:	0007c703          	lbu	a4,0(a5)
    80000c40:	00178793          	addi	a5,a5,1
    80000c44:	00e40733          	add	a4,s0,a4
    80000c48:	10074703          	lbu	a4,256(a4)
    80000c4c:	fee78fa3          	sb	a4,-1(a5)
    80000c50:	ff8796e3          	bne	a5,s8,80000c3c <_Z10aesDecryptPKcjS0_Pcj+0x16c>
    80000c54:	00478c13          	addi	s8,a5,4
    80000c58:	ff6c10e3          	bne	s8,s6,80000c38 <_Z10aesDecryptPKcjS0_Pcj+0x168>
    80000c5c:	01810513          	addi	a0,sp,24
    80000c60:	f7cff0ef          	jal	800003dc <_Z12invShiftRowsPA4_c>
    80000c64:	17810593          	addi	a1,sp,376
    80000c68:	01810513          	addi	a0,sp,24
    80000c6c:	e40ff0ef          	jal	800002ac <_Z11addRoundKeyPA4_cPKj>
    80000c70:	010a8613          	addi	a2,s5,16
    80000c74:	ffca8793          	addi	a5,s5,-4
    80000c78:	00048713          	mv	a4,s1
    80000c7c:	00074683          	lbu	a3,0(a4)
    80000c80:	00178793          	addi	a5,a5,1
    80000c84:	00470713          	addi	a4,a4,4
    80000c88:	fed78fa3          	sb	a3,-1(a5)
    80000c8c:	ff5798e3          	bne	a5,s5,80000c7c <_Z10aesDecryptPKcjS0_Pcj+0x1ac>
    80000c90:	00478a93          	addi	s5,a5,4
    80000c94:	00148493          	addi	s1,s1,1
    80000c98:	fcca9ee3          	bne	s5,a2,80000c74 <_Z10aesDecryptPKcjS0_Pcj+0x1a4>
    80000c9c:	015a0663          	beq	s4,s5,80000ca8 <_Z10aesDecryptPKcjS0_Pcj+0x1d8>
    80000ca0:	00098693          	mv	a3,s3
    80000ca4:	f01ff06f          	j	80000ba4 <_Z10aesDecryptPKcjS0_Pcj+0xd4>
    80000ca8:	1c013903          	ld	s2,448(sp)
    80000cac:	1b813983          	ld	s3,440(sp)
    80000cb0:	1a813a83          	ld	s5,424(sp)
    80000cb4:	1a013b03          	ld	s6,416(sp)
    80000cb8:	19813b83          	ld	s7,408(sp)
    80000cbc:	19013c03          	ld	s8,400(sp)
    80000cc0:	1d013403          	ld	s0,464(sp)
    80000cc4:	1c813483          	ld	s1,456(sp)
    80000cc8:	1b013a03          	ld	s4,432(sp)
    80000ccc:	00000513          	li	a0,0
    80000cd0:	1d813083          	ld	ra,472(sp)
    80000cd4:	1e010113          	addi	sp,sp,480
    80000cd8:	00008067          	ret
    80000cdc:	00810513          	addi	a0,sp,8
    80000ce0:	e71ff06f          	j	80000b50 <_Z10aesDecryptPKcjS0_Pcj+0x80>
    80000ce4:	fff00513          	li	a0,-1
    80000ce8:	fe9ff06f          	j	80000cd0 <_Z10aesDecryptPKcjS0_Pcj+0x200>
    80000cec:	1d013403          	ld	s0,464(sp)
    80000cf0:	1c813483          	ld	s1,456(sp)
    80000cf4:	1b013a03          	ld	s4,432(sp)
    80000cf8:	fff00513          	li	a0,-1
    80000cfc:	fd5ff06f          	j	80000cd0 <_Z10aesDecryptPKcjS0_Pcj+0x200>
    80000d00:	1d013403          	ld	s0,464(sp)
    80000d04:	1b013a03          	ld	s4,432(sp)
    80000d08:	fff00513          	li	a0,-1
    80000d0c:	fc5ff06f          	j	80000cd0 <_Z10aesDecryptPKcjS0_Pcj+0x200>
    80000d10:	1d013403          	ld	s0,464(sp)
    80000d14:	fff00513          	li	a0,-1
    80000d18:	fb9ff06f          	j	80000cd0 <_Z10aesDecryptPKcjS0_Pcj+0x200>

0000000080000d1c <_Z13heavy_rng_modji>:
    80000d1c:	fb010113          	addi	sp,sp,-80
    80000d20:	a5a5a7b7          	lui	a5,0xa5a5a
    80000d24:	01513c23          	sd	s5,24(sp)
    80000d28:	01613823          	sd	s6,16(sp)
    80000d2c:	5a578793          	addi	a5,a5,1445 # ffffffffa5a5a5a5 <_stack_top+0xffffffff25a50bc5>
    80000d30:	04113423          	sd	ra,72(sp)
    80000d34:	00f54b33          	xor	s6,a0,a5
    80000d38:	00156a93          	ori	s5,a0,1
    80000d3c:	24b05863          	blez	a1,80000f8c <_Z13heavy_rng_modji+0x270>
    80000d40:	02913c23          	sd	s1,56(sp)
    80000d44:	03213823          	sd	s2,48(sp)
    80000d48:	000034b7          	lui	s1,0x3
    80000d4c:	3c6ef937          	lui	s2,0x3c6ef
    80000d50:	04813023          	sd	s0,64(sp)
    80000d54:	03313423          	sd	s3,40(sp)
    80000d58:	03413023          	sd	s4,32(sp)
    80000d5c:	01713423          	sd	s7,8(sp)
    80000d60:	01813023          	sd	s8,0(sp)
    80000d64:	00050b93          	mv	s7,a0
    80000d68:	00058413          	mv	s0,a1
    80000d6c:	00000993          	li	s3,0
    80000d70:	001b6a13          	ori	s4,s6,1
    80000d74:	35f9091b          	addiw	s2,s2,863 # 3c6ef35f <STACK_SIZE+0x3c6e735f>
    80000d78:	0394849b          	addiw	s1,s1,57 # 3039 <STACK_SIZE-0x4fc7>
    80000d7c:	002b971b          	slliw	a4,s7,0x2
    80000d80:	0177073b          	addw	a4,a4,s7
    80000d84:	0067179b          	slliw	a5,a4,0x6
    80000d88:	40e787bb          	subw	a5,a5,a4
    80000d8c:	0027979b          	slliw	a5,a5,0x2
    80000d90:	017787bb          	addw	a5,a5,s7
    80000d94:	0057971b          	slliw	a4,a5,0x5
    80000d98:	00e787bb          	addw	a5,a5,a4
    80000d9c:	0037979b          	slliw	a5,a5,0x3
    80000da0:	017787bb          	addw	a5,a5,s7
    80000da4:	0027971b          	slliw	a4,a5,0x2
    80000da8:	00e787bb          	addw	a5,a5,a4
    80000dac:	001aec13          	ori	s8,s5,1
    80000db0:	0127853b          	addw	a0,a5,s2
    80000db4:	020c1c13          	slli	s8,s8,0x20
    80000db8:	020c5c13          	srli	s8,s8,0x20
    80000dbc:	02051513          	slli	a0,a0,0x20
    80000dc0:	000c0593          	mv	a1,s8
    80000dc4:	02055513          	srli	a0,a0,0x20
    80000dc8:	6a0000ef          	jal	80001468 <__hidden___udivdi3>
    80000dcc:	020a1593          	slli	a1,s4,0x20
    80000dd0:	02051513          	slli	a0,a0,0x20
    80000dd4:	0205d593          	srli	a1,a1,0x20
    80000dd8:	02055513          	srli	a0,a0,0x20
    80000ddc:	6d4000ef          	jal	800014b0 <__umoddi3>
    80000de0:	002b171b          	slliw	a4,s6,0x2
    80000de4:	0167073b          	addw	a4,a4,s6
    80000de8:	0037171b          	slliw	a4,a4,0x3
    80000dec:	0167073b          	addw	a4,a4,s6
    80000df0:	0047171b          	slliw	a4,a4,0x4
    80000df4:	0167073b          	addw	a4,a4,s6
    80000df8:	0077179b          	slliw	a5,a4,0x7
    80000dfc:	40e787bb          	subw	a5,a5,a4
    80000e00:	0027979b          	slliw	a5,a5,0x2
    80000e04:	016787bb          	addw	a5,a5,s6
    80000e08:	0047971b          	slliw	a4,a5,0x4
    80000e0c:	00e787bb          	addw	a5,a5,a4
    80000e10:	00050a1b          	sext.w	s4,a0
    80000e14:	0027979b          	slliw	a5,a5,0x2
    80000e18:	0167853b          	addw	a0,a5,s6
    80000e1c:	001a6b93          	ori	s7,s4,1
    80000e20:	0015051b          	addiw	a0,a0,1
    80000e24:	020b9b93          	slli	s7,s7,0x20
    80000e28:	020bdb93          	srli	s7,s7,0x20
    80000e2c:	02051513          	slli	a0,a0,0x20
    80000e30:	000b8593          	mv	a1,s7
    80000e34:	02055513          	srli	a0,a0,0x20
    80000e38:	630000ef          	jal	80001468 <__hidden___udivdi3>
    80000e3c:	02051513          	slli	a0,a0,0x20
    80000e40:	000c0593          	mv	a1,s8
    80000e44:	02055513          	srli	a0,a0,0x20
    80000e48:	668000ef          	jal	800014b0 <__umoddi3>
    80000e4c:	008a979b          	slliw	a5,s5,0x8
    80000e50:	415787bb          	subw	a5,a5,s5
    80000e54:	0037979b          	slliw	a5,a5,0x3
    80000e58:	015787bb          	addw	a5,a5,s5
    80000e5c:	0077979b          	slliw	a5,a5,0x7
    80000e60:	015787bb          	addw	a5,a5,s5
    80000e64:	0037979b          	slliw	a5,a5,0x3
    80000e68:	415787bb          	subw	a5,a5,s5
    80000e6c:	0057971b          	slliw	a4,a5,0x5
    80000e70:	00e787bb          	addw	a5,a5,a4
    80000e74:	0027979b          	slliw	a5,a5,0x2
    80000e78:	415787bb          	subw	a5,a5,s5
    80000e7c:	0027979b          	slliw	a5,a5,0x2
    80000e80:	00050b1b          	sext.w	s6,a0
    80000e84:	0157853b          	addw	a0,a5,s5
    80000e88:	001b6593          	ori	a1,s6,1
    80000e8c:	0095053b          	addw	a0,a0,s1
    80000e90:	02059593          	slli	a1,a1,0x20
    80000e94:	02051513          	slli	a0,a0,0x20
    80000e98:	0205d593          	srli	a1,a1,0x20
    80000e9c:	02055513          	srli	a0,a0,0x20
    80000ea0:	5c8000ef          	jal	80001468 <__hidden___udivdi3>
    80000ea4:	02051513          	slli	a0,a0,0x20
    80000ea8:	000b8593          	mv	a1,s7
    80000eac:	02055513          	srli	a0,a0,0x20
    80000eb0:	600000ef          	jal	800014b0 <__umoddi3>
    80000eb4:	016a45b3          	xor	a1,s4,s6
    80000eb8:	0035d79b          	srliw	a5,a1,0x3
    80000ebc:	00f54a33          	xor	s4,a0,a5
    80000ec0:	01650b3b          	addw	s6,a0,s6
    80000ec4:	000a0a1b          	sext.w	s4,s4
    80000ec8:	001b6513          	ori	a0,s6,1
    80000ecc:	001a6a93          	ori	s5,s4,1
    80000ed0:	52c000ef          	jal	800013fc <__muldi3>
    80000ed4:	020a9a93          	slli	s5,s5,0x20
    80000ed8:	020ada93          	srli	s5,s5,0x20
    80000edc:	02051513          	slli	a0,a0,0x20
    80000ee0:	000a8593          	mv	a1,s5
    80000ee4:	02055513          	srli	a0,a0,0x20
    80000ee8:	5c8000ef          	jal	800014b0 <__umoddi3>
    80000eec:	00050b93          	mv	s7,a0
    80000ef0:	020b1513          	slli	a0,s6,0x20
    80000ef4:	000a8593          	mv	a1,s5
    80000ef8:	02055513          	srli	a0,a0,0x20
    80000efc:	000b8b9b          	sext.w	s7,s7
    80000f00:	568000ef          	jal	80001468 <__hidden___udivdi3>
    80000f04:	001bea93          	ori	s5,s7,1
    80000f08:	020a9593          	slli	a1,s5,0x20
    80000f0c:	02051513          	slli	a0,a0,0x20
    80000f10:	0205d593          	srli	a1,a1,0x20
    80000f14:	02055513          	srli	a0,a0,0x20
    80000f18:	598000ef          	jal	800014b0 <__umoddi3>
    80000f1c:	00050b13          	mv	s6,a0
    80000f20:	000a0593          	mv	a1,s4
    80000f24:	000a8513          	mv	a0,s5
    80000f28:	000b0b1b          	sext.w	s6,s6
    80000f2c:	4d0000ef          	jal	800013fc <__muldi3>
    80000f30:	001b6a13          	ori	s4,s6,1
    80000f34:	020a1593          	slli	a1,s4,0x20
    80000f38:	02051513          	slli	a0,a0,0x20
    80000f3c:	0205d593          	srli	a1,a1,0x20
    80000f40:	02055513          	srli	a0,a0,0x20
    80000f44:	56c000ef          	jal	800014b0 <__umoddi3>
    80000f48:	0019899b          	addiw	s3,s3,1
    80000f4c:	00050a9b          	sext.w	s5,a0
    80000f50:	e33416e3          	bne	s0,s3,80000d7c <_Z13heavy_rng_modji+0x60>
    80000f54:	04013403          	ld	s0,64(sp)
    80000f58:	04813083          	ld	ra,72(sp)
    80000f5c:	016bc533          	xor	a0,s7,s6
    80000f60:	03813483          	ld	s1,56(sp)
    80000f64:	03013903          	ld	s2,48(sp)
    80000f68:	02813983          	ld	s3,40(sp)
    80000f6c:	02013a03          	ld	s4,32(sp)
    80000f70:	00813b83          	ld	s7,8(sp)
    80000f74:	00013c03          	ld	s8,0(sp)
    80000f78:	01013b03          	ld	s6,16(sp)
    80000f7c:	00aac533          	xor	a0,s5,a0
    80000f80:	01813a83          	ld	s5,24(sp)
    80000f84:	05010113          	addi	sp,sp,80
    80000f88:	00008067          	ret
    80000f8c:	04813083          	ld	ra,72(sp)
    80000f90:	00078513          	mv	a0,a5
    80000f94:	01013b03          	ld	s6,16(sp)
    80000f98:	00aac533          	xor	a0,s5,a0
    80000f9c:	01813a83          	ld	s5,24(sp)
    80000fa0:	05010113          	addi	sp,sp,80
    80000fa4:	00008067          	ret

0000000080000fa8 <main>:
    80000fa8:	f1010113          	addi	sp,sp,-240
    80000fac:	1357a737          	lui	a4,0x1357a
    80000fb0:	3c6ef5b7          	lui	a1,0x3c6ef
    80000fb4:	0e113423          	sd	ra,232(sp)
    80000fb8:	0e813023          	sd	s0,224(sp)
    80000fbc:	0d413023          	sd	s4,192(sp)
    80000fc0:	03010613          	addi	a2,sp,48
    80000fc4:	0b010513          	addi	a0,sp,176
    80000fc8:	bdf70713          	addi	a4,a4,-1057 # 13579bdf <STACK_SIZE+0x13571bdf>
    80000fcc:	35f5859b          	addiw	a1,a1,863 # 3c6ef35f <STACK_SIZE+0x3c6e735f>
    80000fd0:	0027169b          	slliw	a3,a4,0x2
    80000fd4:	00e686bb          	addw	a3,a3,a4
    80000fd8:	0066979b          	slliw	a5,a3,0x6
    80000fdc:	40d787bb          	subw	a5,a5,a3
    80000fe0:	0027979b          	slliw	a5,a5,0x2
    80000fe4:	00e787bb          	addw	a5,a5,a4
    80000fe8:	0057969b          	slliw	a3,a5,0x5
    80000fec:	00d787bb          	addw	a5,a5,a3
    80000ff0:	0037979b          	slliw	a5,a5,0x3
    80000ff4:	00e787bb          	addw	a5,a5,a4
    80000ff8:	0027971b          	slliw	a4,a5,0x2
    80000ffc:	00e787bb          	addw	a5,a5,a4
    80001000:	00b787bb          	addw	a5,a5,a1
    80001004:	0187d71b          	srliw	a4,a5,0x18
    80001008:	00e60023          	sb	a4,0(a2)
    8000100c:	00160613          	addi	a2,a2,1
    80001010:	0007871b          	sext.w	a4,a5
    80001014:	fac51ee3          	bne	a0,a2,80000fd0 <main+0x28>
    80001018:	406006b7          	lui	a3,0x40600
    8000101c:	04100713          	li	a4,65
    80001020:	00000797          	auipc	a5,0x0
    80001024:	50078793          	addi	a5,a5,1280 # 80001520 <__moddi3+0x3c>
    80001028:	00468693          	addi	a3,a3,4 # 40600004 <STACK_SIZE+0x405f8004>
    8000102c:	00178793          	addi	a5,a5,1
    80001030:	00e68023          	sb	a4,0(a3)
    80001034:	0007c703          	lbu	a4,0(a5)
    80001038:	fe071ae3          	bnez	a4,8000102c <main+0x84>
    8000103c:	406006b7          	lui	a3,0x40600
    80001040:	00013423          	sd	zero,8(sp)
    80001044:	00013823          	sd	zero,16(sp)
    80001048:	00013c23          	sd	zero,24(sp)
    8000104c:	02013023          	sd	zero,32(sp)
    80001050:	05200713          	li	a4,82
    80001054:	00000797          	auipc	a5,0x0
    80001058:	4f478793          	addi	a5,a5,1268 # 80001548 <__moddi3+0x64>
    8000105c:	00468693          	addi	a3,a3,4 # 40600004 <STACK_SIZE+0x405f8004>
    80001060:	00178793          	addi	a5,a5,1
    80001064:	00e68023          	sb	a4,0(a3)
    80001068:	0007c703          	lbu	a4,0(a5)
    8000106c:	fe071ae3          	bnez	a4,80001060 <main+0xb8>
    80001070:	406006b7          	lui	a3,0x40600
    80001074:	05b00713          	li	a4,91
    80001078:	00000797          	auipc	a5,0x0
    8000107c:	4f878793          	addi	a5,a5,1272 # 80001570 <__moddi3+0x8c>
    80001080:	00468693          	addi	a3,a3,4 # 40600004 <STACK_SIZE+0x405f8004>
    80001084:	00178793          	addi	a5,a5,1
    80001088:	00e68023          	sb	a4,0(a3)
    8000108c:	0007c703          	lbu	a4,0(a5)
    80001090:	fe071ae3          	bnez	a4,80001084 <main+0xdc>
    80001094:	01000713          	li	a4,16
    80001098:	00810693          	addi	a3,sp,8
    8000109c:	00000617          	auipc	a2,0x0
    800010a0:	6f460613          	addi	a2,a2,1780 # 80001790 <_ZZL20runCorrectnessChecksvE2pt>
    800010a4:	01000593          	li	a1,16
    800010a8:	00000517          	auipc	a0,0x0
    800010ac:	6f850513          	addi	a0,a0,1784 # 800017a0 <_ZZL20runCorrectnessChecksvE3key>
    800010b0:	fd4ff0ef          	jal	80000884 <_Z10aesEncryptPKcjS0_Pcj>
    800010b4:	32051063          	bnez	a0,800013d4 <main+0x42c>
    800010b8:	00810793          	addi	a5,sp,8
    800010bc:	00000717          	auipc	a4,0x0
    800010c0:	6f470713          	addi	a4,a4,1780 # 800017b0 <_ZZL20runCorrectnessChecksvE10expectedCt>
    800010c4:	01810a13          	addi	s4,sp,24
    800010c8:	0080006f          	j	800010d0 <main+0x128>
    800010cc:	02fa0e63          	beq	s4,a5,80001108 <main+0x160>
    800010d0:	0007c603          	lbu	a2,0(a5)
    800010d4:	00074683          	lbu	a3,0(a4)
    800010d8:	00178793          	addi	a5,a5,1
    800010dc:	00170713          	addi	a4,a4,1
    800010e0:	fed606e3          	beq	a2,a3,800010cc <main+0x124>
    800010e4:	00000797          	auipc	a5,0x0
    800010e8:	4dc78793          	addi	a5,a5,1244 # 800015c0 <__moddi3+0xdc>
    800010ec:	0007c683          	lbu	a3,0(a5)
    800010f0:	40600737          	lui	a4,0x40600
    800010f4:	00470713          	addi	a4,a4,4 # 40600004 <STACK_SIZE+0x405f8004>
    800010f8:	2a068863          	beqz	a3,800013a8 <main+0x400>
    800010fc:	00178793          	addi	a5,a5,1
    80001100:	00d70023          	sb	a3,0(a4)
    80001104:	fe9ff06f          	j	800010ec <main+0x144>
    80001108:	406006b7          	lui	a3,0x40600
    8000110c:	0d213823          	sd	s2,208(sp)
    80001110:	05b00713          	li	a4,91
    80001114:	00000797          	auipc	a5,0x0
    80001118:	4d478793          	addi	a5,a5,1236 # 800015e8 <__moddi3+0x104>
    8000111c:	00468693          	addi	a3,a3,4 # 40600004 <STACK_SIZE+0x405f8004>
    80001120:	00178793          	addi	a5,a5,1
    80001124:	00e68023          	sb	a4,0(a3)
    80001128:	0007c703          	lbu	a4,0(a5)
    8000112c:	fe071ae3          	bnez	a4,80001120 <main+0x178>
    80001130:	406006b7          	lui	a3,0x40600
    80001134:	05b00713          	li	a4,91
    80001138:	00000797          	auipc	a5,0x0
    8000113c:	4e078793          	addi	a5,a5,1248 # 80001618 <__moddi3+0x134>
    80001140:	00468693          	addi	a3,a3,4 # 40600004 <STACK_SIZE+0x405f8004>
    80001144:	00178793          	addi	a5,a5,1
    80001148:	00e68023          	sb	a4,0(a3)
    8000114c:	0007c703          	lbu	a4,0(a5)
    80001150:	fe071ae3          	bnez	a4,80001144 <main+0x19c>
    80001154:	01000713          	li	a4,16
    80001158:	000a0693          	mv	a3,s4
    8000115c:	00810613          	addi	a2,sp,8
    80001160:	01000593          	li	a1,16
    80001164:	00000517          	auipc	a0,0x0
    80001168:	63c50513          	addi	a0,a0,1596 # 800017a0 <_ZZL20runCorrectnessChecksvE3key>
    8000116c:	965ff0ef          	jal	80000ad0 <_Z10aesDecryptPKcjS0_Pcj>
    80001170:	00050913          	mv	s2,a0
    80001174:	20051663          	bnez	a0,80001380 <main+0x3d8>
    80001178:	000a0793          	mv	a5,s4
    8000117c:	00000717          	auipc	a4,0x0
    80001180:	61470713          	addi	a4,a4,1556 # 80001790 <_ZZL20runCorrectnessChecksvE2pt>
    80001184:	02810593          	addi	a1,sp,40
    80001188:	0080006f          	j	80001190 <main+0x1e8>
    8000118c:	02f58e63          	beq	a1,a5,800011c8 <main+0x220>
    80001190:	0007c603          	lbu	a2,0(a5)
    80001194:	00074683          	lbu	a3,0(a4)
    80001198:	00178793          	addi	a5,a5,1
    8000119c:	00170713          	addi	a4,a4,1
    800011a0:	fed606e3          	beq	a2,a3,8000118c <main+0x1e4>
    800011a4:	00000797          	auipc	a5,0x0
    800011a8:	4c478793          	addi	a5,a5,1220 # 80001668 <__moddi3+0x184>
    800011ac:	0007c683          	lbu	a3,0(a5)
    800011b0:	40600737          	lui	a4,0x40600
    800011b4:	00470713          	addi	a4,a4,4 # 40600004 <STACK_SIZE+0x405f8004>
    800011b8:	1e068663          	beqz	a3,800013a4 <main+0x3fc>
    800011bc:	00178793          	addi	a5,a5,1
    800011c0:	00d70023          	sb	a3,0(a4)
    800011c4:	fe9ff06f          	j	800011ac <main+0x204>
    800011c8:	406006b7          	lui	a3,0x40600
    800011cc:	0c913c23          	sd	s1,216(sp)
    800011d0:	0d313423          	sd	s3,200(sp)
    800011d4:	0b513c23          	sd	s5,184(sp)
    800011d8:	0b613823          	sd	s6,176(sp)
    800011dc:	05b00713          	li	a4,91
    800011e0:	00000797          	auipc	a5,0x0
    800011e4:	4b078793          	addi	a5,a5,1200 # 80001690 <__moddi3+0x1ac>
    800011e8:	00468693          	addi	a3,a3,4 # 40600004 <STACK_SIZE+0x405f8004>
    800011ec:	00178793          	addi	a5,a5,1
    800011f0:	00e68023          	sb	a4,0(a3)
    800011f4:	0007c703          	lbu	a4,0(a5)
    800011f8:	fe071ae3          	bnez	a4,800011ec <main+0x244>
    800011fc:	406006b7          	lui	a3,0x40600
    80001200:	05b00713          	li	a4,91
    80001204:	00000797          	auipc	a5,0x0
    80001208:	4bc78793          	addi	a5,a5,1212 # 800016c0 <__moddi3+0x1dc>
    8000120c:	00468693          	addi	a3,a3,4 # 40600004 <STACK_SIZE+0x405f8004>
    80001210:	00178793          	addi	a5,a5,1
    80001214:	00e68023          	sb	a4,0(a3)
    80001218:	0007c703          	lbu	a4,0(a5)
    8000121c:	fe071ae3          	bnez	a4,80001210 <main+0x268>
    80001220:	200034b7          	lui	s1,0x20003
    80001224:	0004bb03          	ld	s6,0(s1) # 20003000 <STACK_SIZE+0x1fffb000>
    80001228:	0004b503          	ld	a0,0(s1)
    8000122c:	3e800593          	li	a1,1000
    80001230:	0005051b          	sext.w	a0,a0
    80001234:	ae9ff0ef          	jal	80000d1c <_Z13heavy_rng_modji>
    80001238:	0004ba83          	ld	s5,0(s1)
    8000123c:	406006b7          	lui	a3,0x40600
    80001240:	0005041b          	sext.w	s0,a0
    80001244:	05b00713          	li	a4,91
    80001248:	00000797          	auipc	a5,0x0
    8000124c:	4d078793          	addi	a5,a5,1232 # 80001718 <__moddi3+0x234>
    80001250:	00468693          	addi	a3,a3,4 # 40600004 <STACK_SIZE+0x405f8004>
    80001254:	00178793          	addi	a5,a5,1
    80001258:	00e68023          	sb	a4,0(a3)
    8000125c:	0007c703          	lbu	a4,0(a5)
    80001260:	fe071ae3          	bnez	a4,80001254 <main+0x2ac>
    80001264:	10044663          	bltz	s0,80001370 <main+0x3c8>
    80001268:	000a0993          	mv	s3,s4
    8000126c:	00a00593          	li	a1,10
    80001270:	00040513          	mv	a0,s0
    80001274:	270000ef          	jal	800014e4 <__moddi3>
    80001278:	0305079b          	addiw	a5,a0,48
    8000127c:	00f98023          	sb	a5,0(s3)
    80001280:	00040513          	mv	a0,s0
    80001284:	00a00593          	li	a1,10
    80001288:	1d8000ef          	jal	80001460 <__divdi3>
    8000128c:	0005041b          	sext.w	s0,a0
    80001290:	00090493          	mv	s1,s2
    80001294:	00198993          	addi	s3,s3,1
    80001298:	0019091b          	addiw	s2,s2,1
    8000129c:	fc0418e3          	bnez	s0,8000126c <main+0x2c4>
    800012a0:	406006b7          	lui	a3,0x40600
    800012a4:	009a07b3          	add	a5,s4,s1
    800012a8:	00468693          	addi	a3,a3,4 # 40600004 <STACK_SIZE+0x405f8004>
    800012ac:	fffa0a13          	addi	s4,s4,-1
    800012b0:	0007c703          	lbu	a4,0(a5)
    800012b4:	fff78793          	addi	a5,a5,-1
    800012b8:	00e68023          	sb	a4,0(a3)
    800012bc:	ff479ae3          	bne	a5,s4,800012b0 <main+0x308>
    800012c0:	40600937          	lui	s2,0x40600
    800012c4:	02c00713          	li	a4,44
    800012c8:	00000797          	auipc	a5,0x0
    800012cc:	47078793          	addi	a5,a5,1136 # 80001738 <__moddi3+0x254>
    800012d0:	00490913          	addi	s2,s2,4 # 40600004 <STACK_SIZE+0x405f8004>
    800012d4:	00178793          	addi	a5,a5,1
    800012d8:	00e90023          	sb	a4,0(s2)
    800012dc:	0007c703          	lbu	a4,0(a5)
    800012e0:	fe071ae3          	bnez	a4,800012d4 <main+0x32c>
    800012e4:	416a8ab3          	sub	s5,s5,s6
    800012e8:	000a8513          	mv	a0,s5
    800012ec:	d4dfe0ef          	jal	80000038 <_Z5put_iIyEvT_>
    800012f0:	00a00793          	li	a5,10
    800012f4:	406004b7          	lui	s1,0x40600
    800012f8:	00f90023          	sb	a5,0(s2)
    800012fc:	05b00713          	li	a4,91
    80001300:	00000797          	auipc	a5,0x0
    80001304:	44878793          	addi	a5,a5,1096 # 80001748 <__moddi3+0x264>
    80001308:	00448493          	addi	s1,s1,4 # 40600004 <STACK_SIZE+0x405f8004>
    8000130c:	00178793          	addi	a5,a5,1
    80001310:	00e48023          	sb	a4,0(s1)
    80001314:	0007c703          	lbu	a4,0(a5)
    80001318:	fe071ae3          	bnez	a4,8000130c <main+0x364>
    8000131c:	3e800593          	li	a1,1000
    80001320:	000a8513          	mv	a0,s5
    80001324:	144000ef          	jal	80001468 <__hidden___udivdi3>
    80001328:	00050593          	mv	a1,a0
    8000132c:	000f4537          	lui	a0,0xf4
    80001330:	24050513          	addi	a0,a0,576 # f4240 <STACK_SIZE+0xec240>
    80001334:	134000ef          	jal	80001468 <__hidden___udivdi3>
    80001338:	d01fe0ef          	jal	80000038 <_Z5put_iIyEvT_>
    8000133c:	00a00793          	li	a5,10
    80001340:	00f48023          	sb	a5,0(s1)
    80001344:	0d813483          	ld	s1,216(sp)
    80001348:	0d013903          	ld	s2,208(sp)
    8000134c:	0c813983          	ld	s3,200(sp)
    80001350:	0b813a83          	ld	s5,184(sp)
    80001354:	0b013b03          	ld	s6,176(sp)
    80001358:	0e813083          	ld	ra,232(sp)
    8000135c:	00040513          	mv	a0,s0
    80001360:	0e013403          	ld	s0,224(sp)
    80001364:	0c013a03          	ld	s4,192(sp)
    80001368:	0f010113          	addi	sp,sp,240
    8000136c:	00008067          	ret
    80001370:	02d00793          	li	a5,45
    80001374:	00f68023          	sb	a5,0(a3)
    80001378:	4080043b          	negw	s0,s0
    8000137c:	eedff06f          	j	80001268 <main+0x2c0>
    80001380:	406006b7          	lui	a3,0x40600
    80001384:	00000797          	auipc	a5,0x0
    80001388:	2bc78793          	addi	a5,a5,700 # 80001640 <__moddi3+0x15c>
    8000138c:	00468693          	addi	a3,a3,4 # 40600004 <STACK_SIZE+0x405f8004>
    80001390:	0080006f          	j	80001398 <main+0x3f0>
    80001394:	00e68023          	sb	a4,0(a3)
    80001398:	0007c703          	lbu	a4,0(a5)
    8000139c:	00178793          	addi	a5,a5,1
    800013a0:	fe071ae3          	bnez	a4,80001394 <main+0x3ec>
    800013a4:	0d013903          	ld	s2,208(sp)
    800013a8:	406006b7          	lui	a3,0x40600
    800013ac:	00000797          	auipc	a5,0x0
    800013b0:	33c78793          	addi	a5,a5,828 # 800016e8 <__moddi3+0x204>
    800013b4:	00468693          	addi	a3,a3,4 # 40600004 <STACK_SIZE+0x405f8004>
    800013b8:	0080006f          	j	800013c0 <main+0x418>
    800013bc:	00e68023          	sb	a4,0(a3)
    800013c0:	0007c703          	lbu	a4,0(a5)
    800013c4:	00178793          	addi	a5,a5,1
    800013c8:	fe071ae3          	bnez	a4,800013bc <main+0x414>
    800013cc:	fff00413          	li	s0,-1
    800013d0:	f89ff06f          	j	80001358 <main+0x3b0>
    800013d4:	406006b7          	lui	a3,0x40600
    800013d8:	00000797          	auipc	a5,0x0
    800013dc:	1c078793          	addi	a5,a5,448 # 80001598 <__moddi3+0xb4>
    800013e0:	00468693          	addi	a3,a3,4 # 40600004 <STACK_SIZE+0x405f8004>
    800013e4:	0080006f          	j	800013ec <main+0x444>
    800013e8:	00e68023          	sb	a4,0(a3)
    800013ec:	0007c703          	lbu	a4,0(a5)
    800013f0:	00178793          	addi	a5,a5,1
    800013f4:	fe071ae3          	bnez	a4,800013e8 <main+0x440>
    800013f8:	fb1ff06f          	j	800013a8 <main+0x400>

00000000800013fc <__muldi3>:
    800013fc:	00050613          	mv	a2,a0
    80001400:	00000513          	li	a0,0
    80001404:	0015f693          	andi	a3,a1,1
    80001408:	00068463          	beqz	a3,80001410 <__muldi3+0x14>
    8000140c:	00c50533          	add	a0,a0,a2
    80001410:	0015d593          	srli	a1,a1,0x1
    80001414:	00161613          	slli	a2,a2,0x1
    80001418:	fe0596e3          	bnez	a1,80001404 <__muldi3+0x8>
    8000141c:	00008067          	ret

0000000080001420 <__udivsi3>:
    80001420:	02051513          	slli	a0,a0,0x20
    80001424:	02059593          	slli	a1,a1,0x20
    80001428:	00008293          	mv	t0,ra
    8000142c:	03c000ef          	jal	80001468 <__hidden___udivdi3>
    80001430:	0005051b          	sext.w	a0,a0
    80001434:	00028067          	jr	t0

0000000080001438 <__umodsi3>:
    80001438:	02051513          	slli	a0,a0,0x20
    8000143c:	02059593          	slli	a1,a1,0x20
    80001440:	02055513          	srli	a0,a0,0x20
    80001444:	0205d593          	srli	a1,a1,0x20
    80001448:	00008293          	mv	t0,ra
    8000144c:	01c000ef          	jal	80001468 <__hidden___udivdi3>
    80001450:	0005851b          	sext.w	a0,a1
    80001454:	00028067          	jr	t0

0000000080001458 <__divsi3>:
    80001458:	fff00293          	li	t0,-1
    8000145c:	0a558c63          	beq	a1,t0,80001514 <__moddi3+0x30>

0000000080001460 <__divdi3>:
    80001460:	06054063          	bltz	a0,800014c0 <__umoddi3+0x10>
    80001464:	0605c663          	bltz	a1,800014d0 <__umoddi3+0x20>

0000000080001468 <__hidden___udivdi3>:
    80001468:	00058613          	mv	a2,a1
    8000146c:	00050593          	mv	a1,a0
    80001470:	fff00513          	li	a0,-1
    80001474:	02060c63          	beqz	a2,800014ac <__hidden___udivdi3+0x44>
    80001478:	00100693          	li	a3,1
    8000147c:	00b67a63          	bgeu	a2,a1,80001490 <__hidden___udivdi3+0x28>
    80001480:	00c05863          	blez	a2,80001490 <__hidden___udivdi3+0x28>
    80001484:	00161613          	slli	a2,a2,0x1
    80001488:	00169693          	slli	a3,a3,0x1
    8000148c:	feb66ae3          	bltu	a2,a1,80001480 <__hidden___udivdi3+0x18>
    80001490:	00000513          	li	a0,0
    80001494:	00c5e663          	bltu	a1,a2,800014a0 <__hidden___udivdi3+0x38>
    80001498:	40c585b3          	sub	a1,a1,a2
    8000149c:	00d56533          	or	a0,a0,a3
    800014a0:	0016d693          	srli	a3,a3,0x1
    800014a4:	00165613          	srli	a2,a2,0x1
    800014a8:	fe0696e3          	bnez	a3,80001494 <__hidden___udivdi3+0x2c>
    800014ac:	00008067          	ret

00000000800014b0 <__umoddi3>:
    800014b0:	00008293          	mv	t0,ra
    800014b4:	fb5ff0ef          	jal	80001468 <__hidden___udivdi3>
    800014b8:	00058513          	mv	a0,a1
    800014bc:	00028067          	jr	t0
    800014c0:	40a00533          	neg	a0,a0
    800014c4:	00b04863          	bgtz	a1,800014d4 <__umoddi3+0x24>
    800014c8:	40b005b3          	neg	a1,a1
    800014cc:	f9dff06f          	j	80001468 <__hidden___udivdi3>
    800014d0:	40b005b3          	neg	a1,a1
    800014d4:	00008293          	mv	t0,ra
    800014d8:	f91ff0ef          	jal	80001468 <__hidden___udivdi3>
    800014dc:	40a00533          	neg	a0,a0
    800014e0:	00028067          	jr	t0

00000000800014e4 <__moddi3>:
    800014e4:	00008293          	mv	t0,ra
    800014e8:	0005ca63          	bltz	a1,800014fc <__moddi3+0x18>
    800014ec:	00054c63          	bltz	a0,80001504 <__moddi3+0x20>
    800014f0:	f79ff0ef          	jal	80001468 <__hidden___udivdi3>
    800014f4:	00058513          	mv	a0,a1
    800014f8:	00028067          	jr	t0
    800014fc:	40b005b3          	neg	a1,a1
    80001500:	fe0558e3          	bgez	a0,800014f0 <__moddi3+0xc>
    80001504:	40a00533          	neg	a0,a0
    80001508:	f61ff0ef          	jal	80001468 <__hidden___udivdi3>
    8000150c:	40b00533          	neg	a0,a1
    80001510:	00028067          	jr	t0
    80001514:	01f29293          	slli	t0,t0,0x1f
    80001518:	f45514e3          	bne	a0,t0,80001460 <__divdi3>
    8000151c:	00008067          	ret
