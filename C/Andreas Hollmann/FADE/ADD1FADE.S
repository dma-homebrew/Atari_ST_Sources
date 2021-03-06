;******************************************************************************
;*       ADD1FADE - pixelwise fading between two screens                      *
;*       with Constants-Addition                  by Andreas Hollmann         *
;*       (c) 1992 MAXON Computer GmbH                                         *
;******************************************************************************
GLOBL  add1fade;

add1fade:   movea.l   4(sp),a0        ;get src_Address 
            movea.l   8(sp),a1        ;get dst_Address 
            move.l    12(sp),d1       ;get Add-value 
;------------------------------------------------------------------------------
            move.l    #255999,d0      ;how many Pixels(+1) must be copied
            moveq     #0,d2           ;Counter is 0 at the start
            move.l    #255999,d5      ;for comparison (faster !)
            moveq     #7,d6           ;for AND-Bit (faster !)
            move.l    #256000,d7      ;for SUB (faster !)
;------------------------------------------------------------------------------
px_loop:    move.l    d2,d3           ;Counter in d3 copy
            asr.l     #3,d3           ;d3/8 = Byte-Adr
            move.b    d2,d4           ;Counter in d4 copy
            and.b     d6,d4           ;Calculate Pixel
            eor.b     d6,d4           ;Calculate Bit
            btst      d4,0(a0,d3.w)   ;test corresponding Bit
            bne.s     bit_1           ;S_Bit is 1 => branch
            bclr      d4,0(a1,d3.w)   ;S_Bit is 0 => delete D_Bit 
            bra.s     inc_count       ;->

bit_1:      bset      d4,0(a1,d3.w)   ;D_Bit set

inc_count:  add.l     d1,d2           ;Add-value added to the Counter
            cmp.l     d5,d2           ;Counter with 255999 comparisons
            bhi.s     dec_count       ;Counter larger ->
            bra.s     loop_end        ;to the end of the loop

dec_count:  sub.l     d7,d2           ;Decrease Counter by 256000 
loop_end:   subq.l    #1,d0           ;1 Pixel copied
            bpl.s     px_loop
;------------------------------------------------------------------------------
            rts
            END

