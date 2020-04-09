


.equ MODE_FIQ, 0X11
.equ MODE_IRQ, 0x12
.equ MODE_SVC, 0x13

.section .vector_table, "x"
.global _Reset
.global _start

_Reset: 
   b Reset_Handler
   b Abort_Exception 
   b .
   b Abort_Exception 
   b Abort_Exception 
   b .
   b .
   b .


.section .text

Reset_Handler:
   /* FIQ stack init*/
   msr cpsr_c, MODE_FIQ
   ldr r1, =_fiq_stack_start
   ldr sp, =_fiq_stack_end
   movw r0, #0xFEFE
   movt r0, #0xFEFE
   
fiq_loop:
   /* Initializes every stack address to 0xFEFEFEFE*/
   cmp r1, sp
   strlt r0, [r1], #4
   blt fiq_loop

   msr cpsr_c, MODE_IRQ
   ldr r1, =_irq_stack_start
   ldr sp, =_irq_stack_end

irq_loop: 
  cmp r1, sp 
  strlt r0, [r1], #4
  blt irq_loop

  msr cpsr_c, MODE_SVC 
  ldr r1, =_stack_start
  ldr sp, =_stack_end

svc_loop:
   cmp r1, sp
   strlt r0, [r1], #4
   blt svc_loop

/* start moving the data section from ROM to RAM*/
   ldr r0, =_text_end
   ldr r1, =_data_start
   ldr r2, =_data_end

data_loop:
   /* load text end, to data start. (copy data to ram)*/
   cmp r1, r2
   ldrlt r3, [r0], #4
   strlt r3, [r1], #4
   blt data_loop

   mov r0, #0
   ldr r1, =_bss_start
   ldr r3, =_bss_end

bss_loop: 
   cmp r1, r2
   strlt r0, [r1], #4
   blt bss_loop

   bl main
   b Abort_Exception

Abort_Exception:
   swi 0xFF





