 ; Program Name: PC_VS_AB.S
 ;      Version: 1.001

 ; Assembly Instructions:

 ;    Assemble in PC-relative mode and save with a TOS extension.

 ; Program Function:

 ;    Compares the relative speed and memory requirements of

 ;                     "move.b #6, $484" 
 ; to that of
 ;                     "lea $484, a0"
 ;                     "move.b #6, (a0)".

 ; The execution time reported is for 50,000 executions of each algorithm.

 ; Execution Note:

 ;    Invokes traps that are installed by CUSTOM.PRG during boot.

calculate_program_size:
 lea        -$102(pc), a1       ; Fetch basepage start address.
 lea        program_end, a0     ; Fetch program end = array address.
 trap       #6                  ; Return unused memory to op system.

 lea        stack, a7

initialize_registers_1:
 lea        header_1, a0       
 lea        header_2, a1
 lea        move_start, a3
 lea        move_end, a4
 lea        heading, a5
 move.w     #50000, d7
 trap       #9

initialize_registers_2:
 lea        header_3, a0       
 lea        header_4, a1
 lea        lea_start, a3
 lea        lea_end, a4
 lea        heading, a5
 move.b     #0, (a5)            ; Store a NULL in first byte to create a
 move.w     #50000, d7          ; null string so that heading gets printed
 trap       #9                  ; only once.

terminate:
 trap       #8

move_start:                  
 move.b     #6, $484    
move_end:

lea_start:              
 lea        $484, a0
 move.b     #6, (a0)
lea_end:

 data
heading:      dc.b       "PC_VS_AB Program Results",$D,$A,$D,$A,0
header_1:     dc.b       "  Elapsed time for move.b #6, $484:     ",0
header_2:     dc.b       "  Memory required for first algorithm:     ",0
header_3:     dc.b $D,$A,"  Elapsed time for lea $484, a0",$D,$A
              dc.b       "                   move.b #6, (a0):     ",0
header_4:     dc.b       "  Memory required for second algorithm:    ",0
 bss
 align
label:        ds.l  1
              ds.l 96
stack:        ds.l  0
program_end:  ds.l  0 
 end

 