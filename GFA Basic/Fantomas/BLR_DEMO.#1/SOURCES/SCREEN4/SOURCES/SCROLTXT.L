 movea.l 4(sp),a0       ; a0 = adresse buffer caractere
 movea.l 8(sp),a1       ; a1 = ecran travail

 move.w #13,d0
loop:
 move.b 1(a1),(a1)
 move.b 8(a1),1(a1)
 move.b 9(a1),8(a1)
 move.b 16(a1),9(a1)
 move.b 17(a1),16(a1)
 move.b 24(a1),17(a1)
 move.b 25(a1),24(a1)
 move.b 32(a1),25(a1)
 move.b 33(a1),32(a1)
 move.b 40(a1),33(a1)
 move.b 41(a1),40(a1)
 move.b 48(a1),41(a1)
 move.b 49(a1),48(a1)
 move.b 56(a1),49(a1)
 move.b 57(a1),56(a1)
 move.b 64(a1),57(a1)
 move.b 65(a1),64(a1)
 move.b 72(a1),65(a1)
 move.b 73(a1),72(a1)
 move.b 80(a1),73(a1)
 move.b 81(a1),80(a1)
 move.b 88(a1),81(a1)
 move.b 89(a1),88(a1)
 move.b 96(a1),89(a1)
 move.b 97(a1),96(a1)
 move.b 104(a1),97(a1)
 move.b 105(a1),104(a1)
 move.b 112(a1),105(a1)
 move.b 113(a1),112(a1)
 move.b 120(a1),113(a1)
 move.b 121(a1),120(a1)
 move.b 128(a1),121(a1)
 move.b 129(a1),128(a1)
 move.b 136(a1),129(a1)
 move.b 137(a1),136(a1)
 move.b (a0),137(a1)
 move.b 1(a0),(a0)
 lea 160(a1),a1
 lea 2(a0),a0
 dbra d0,loop
 rts
 end
 