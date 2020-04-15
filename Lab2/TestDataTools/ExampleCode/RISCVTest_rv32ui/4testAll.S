# 1 "2testAll.S"
# 1 "<built-in>"
# 1 "<command-line>"
# 1 "2testAll.S"
# See LICENSE for license details.

#*****************************************************************************
# xor.S
#-----------------------------------------------------------------------------

# Test xor instruction.


# 1 "./riscv_test.h" 1





# 1 "././encoding.h" 1
# 7 "./riscv_test.h" 2
# 11 "2testAll.S" 2
# 1 "./test_macros.h" 1






#-----------------------------------------------------------------------
# Helper macros
#-----------------------------------------------------------------------
# 20 "./test_macros.h"
# We use a macro hack to simpify code generation for various numbers
# of bubble cycles.
# 36 "./test_macros.h"
#-----------------------------------------------------------------------
# RV64UI MACROS
#-----------------------------------------------------------------------

#-----------------------------------------------------------------------
# Tests for instructions with immediate operand
#-----------------------------------------------------------------------
# 92 "./test_macros.h"
#-----------------------------------------------------------------------
# Tests for an instruction with register operands
#-----------------------------------------------------------------------
# 120 "./test_macros.h"
#-----------------------------------------------------------------------
# Tests for an instruction with register-register operands
#-----------------------------------------------------------------------
# 214 "./test_macros.h"
#-----------------------------------------------------------------------
# Test memory instructions
#-----------------------------------------------------------------------
# 340 "./test_macros.h"
#-----------------------------------------------------------------------
# Test jump instructions
#-----------------------------------------------------------------------
# 369 "./test_macros.h"
#-----------------------------------------------------------------------
# RV64UF MACROS
#-----------------------------------------------------------------------

#-----------------------------------------------------------------------
# Tests floating-point instructions
#-----------------------------------------------------------------------
# 631 "./test_macros.h"
#-----------------------------------------------------------------------
# Pass and fail code (assumes test num is in gp)
#-----------------------------------------------------------------------
# 643 "./test_macros.h"
#-----------------------------------------------------------------------
# Test data section
#-----------------------------------------------------------------------
# 12 "2testAll.S" 2


.section .text; .align 6; .globl _start; _start: addi zero,zero, 0

 #lb.S
  #-------------------------------------------------------------
  # Basic tests
  #-------------------------------------------------------------
  test2: li x1, 0x0011; li x2, 0x0012; csrrw x2, 0x0a, x1; li gp, 2; bne x2, x0, fail;; 
  test3: csrrw x2, 0x0a, x1; li x30, 0x11; li gp, 3; bne x2, x30, fail;;
  test4: li x1, 0x0011; li x2, 0x0012; csrrw x2, 0x0a, x1; csrrwi x2, 0x0a, 0x13; li gp, 4; bne x1, x2, fail;;
  test5: csrrw x2, 0x0a, x1; li x30, 0x13; li gp, 5; bne x2, x30, fail;;
  
  test6: li x1, 0x0013; li x2, 0x0014; csrrs x2, 0x0b, x1; li gp, 6; bne x2, x0, fail;;
  test7: csrrw x2, 0x0b, x1; li x30, 0x13; li gp,7; bne x2, x30, fail;;
  test8: li x1, 0x0013; li x2, 0x0014; csrrsi x2, 0x0d, 0x1b; li gp, 8; bne x2, x0, fail;;
  test9: csrrw x2, 0x0d, x1; li x30, 0x1b; li gp, 9; bne x2, x30, fail;;

  test10: li x1, 0x0011; li x2, 0x0012; csrrw x2, 0x0a, x1; li x1, 0x0001; csrrc x2, 0x0a, x1; li x30, 0x11; li gp, 10; bne x30, x2, fail;;
  test11: csrrw x2, 0x0a, x1; li x30, 0x10; li gp, 11; bne x30, x2, fail;;
  test12: li x1, 0x0013; li x2, 0x0014; csrrs x2, 0x0b, x1; csrrci x2, 0x0b, 0x02; li x30, 0x13; li gp, 12; bne x30, x2, fail;;
  test13: csrrw x2, 0x0b, x1; li x30, 0x11; li gp, 13; bne x2, x30, fail;;


  #-------------------------------------------------------------

  bne x0, gp, pass; fail: finish2: jal x20,finish2; pass: li gp,1;finish1: jal x20,finish1

unimp

  .data
 .pushsection .tohost,"aw",@progbits; .align 6; .global tohost; tohost: .dword 0; .align 6; .global fromhost; fromhost: .dword 0; .popsection; .align 4; .global begin_signature; begin_signature:

 
.align 1
#lb.S lbu.S
  tdat:
  tdat1: .byte 0xff
  tdat2: .byte 0x00
  tdat3: .byte 0xf0
  tdat4: .byte 0x0f
#sb.S
  sb_tdat:
  sb_tdat1: .byte 0xef
  sb_tdat2: .byte 0xef
  sb_tdat3: .byte 0xef
  sb_tdat4: .byte 0xef
  sb_tdat5: .byte 0xef
  sb_tdat6: .byte 0xef
  sb_tdat7: .byte 0xef
  sb_tdat8: .byte 0xef
  sb_tdat9: .byte 0xef
  sb_tdat10: .byte 0xef
.align 2
#lh.S lhu.S
  lh_tdat:
  lh_tdat1: .half 0x00ff
  lh_tdat2: .half 0xff00
  lh_tdat3: .half 0x0ff0
  lh_tdat4: .half 0xf00f
#sh.S
  sh_tdat:
  sh_tdat1: .half 0xbeef
  sh_tdat2: .half 0xbeef
  sh_tdat3: .half 0xbeef
  sh_tdat4: .half 0xbeef
  sh_tdat5: .half 0xbeef
  sh_tdat6: .half 0xbeef
  sh_tdat7: .half 0xbeef
  sh_tdat8: .half 0xbeef
  sh_tdat9: .half 0xbeef
  sh_tdat10: .half 0xbeef
.align 4
#lw.S
  lw_tdat:
  lw_tdat1: .word 0x00ff00ff
  lw_tdat2: .word 0xff00ff00
  lw_tdat3: .word 0x0ff00ff0
  lw_tdat4: .word 0xf00ff00f
#sw.S
  sw_tdat:
  sw_tdat1: .word 0xdeadbeef
  sw_tdat2: .word 0xdeadbeef
  sw_tdat3: .word 0xdeadbeef
  sw_tdat4: .word 0xdeadbeef
  sw_tdat5: .word 0xdeadbeef
  sw_tdat6: .word 0xdeadbeef
  sw_tdat7: .word 0xdeadbeef
  sw_tdat8: .word 0xdeadbeef
  sw_tdat9: .word 0xdeadbeef
  sw_tdat10: .word 0xdeadbeef
.align 4
#fence_i.S
insn:
  addi a3, a3, 333

.align 4; .global end_signature; end_signature:
