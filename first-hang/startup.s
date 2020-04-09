 .section .vector_table, "x"
 .global _Reset
 _Reset: 
    b Reset_Handler
    b .
    b .
    b .
    b .
    b .
    b .
    b .


 .section .text
 Reset_Handler:
    ldr r2, str1
    b .
    str1: .word 0xDEADBEEF

