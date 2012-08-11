/*
 * SecureROM for s5l8930xsi
 * iBoot-574.4
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 */

#include "hardware/arm_cpu.h"
.include "asm/include.h"

.global _start
.global _s5l_interrupt_handler_table
.global _s5l_exception_stack
.global _s5l_exception_stack_end

.global _current_task
.global _irq_handler_task
.global _irq_shadow_task

.text
.extern c_main

    /****************/
    /* Code section */
    /****************/
.section .reset,"ax"

    /* ROM Start */

.code 32
_start:
    b       _arm_reset
    ldr     pc, =_off_arm_undefined_handler
    ldr     pc, =_off_arm_syscall_handler
    ldr     pc, =_off_arm_prefetch_abort_handler
    ldr     pc, =_off_arm_data_abort_handler
    ldr     pc, =_off_arm_reserved_handler
    ldr     pc, =_off_arm_irq_handler
    ldr     pc, =_off_arm_fiq_handler

    /* Main */
_off_arm_reset:
    .long   _arm_reset
_off_arm_undefined_handler:
    .long   _arm_undefined_handler
_off_arm_syscall_handler:
    .long   _arm_syscall_handler
_off_arm_prefetch_abort_handler:
    .long   _arm_prefetch_abort_handler
_off_arm_data_abort_handler:
    .long   _arm_data_abort_handler
_off_arm_reserved_handler:
    .long   _arm_reserved_handler
_off_arm_irq_handler:
    .long   _arm_irq_handler
_off_arm_fiq_handler:
    .long   _arm_fiq_handler


.code 32
.global _arm_reset
_arm_reset:
    
    /* Check if addresses are sane */

    adr     r0, _start
    ldr     r1, =_start

    cmp     r0, r1
    beq     _processor_setup

    /* Insane! spin. */
    ldr     r1, =_start
    bx      r1

_processor_setup:

    /* Set up ARM exceptions and all that stuff */

    mrs     r0, cpsr
    bic     r0, r0, #ARM11_CPSR_MODEMASK

    orr     r1, r0, #ARM11_CPSR_IRQMODE
    msr     cpsr_c, r1
    ldr     sp, =_s5l_exception_stack

    orr     r1, r0, #ARM11_CPSR_FIQMODE
    msr     cpsr_c, r1
    ldr     sp, =_s5l_exception_stack

    orr     r1, r0, #ARM11_CPSR_ABORTMODE
    msr     cpsr_c, r1
    ldr     sp, =_s5l_exception_stack

    orr     r1, r0, #ARM11_CPSR_UNDEFINEDMODE
    msr     cpsr_c, r1
    ldr     sp, =_s5l_exception_stack

    orr     r1, r0, #ARM11_CPSR_SUPERVISORMODE
    msr     cpsr_c, r1
    ldr     sp, =_s5l_general_stack
    ldr     r0, =c_main
    mov     lr, pc
    bx      r0

_spin:
    b       _spin

.data

_s5l_interrupt_handler_table:
    .rept   0x80
    .word   0
    .word   0
    .endr

_s5l_exception_stack:
    .rept   0x800
    .byte   0x0
    .endr
_s5l_exception_stack_end:

_s5l_general_stack:
    .rept   0x800
    .byte   0x0
    .endr
_s5l_general_stack_end:

.bss

_iboot_end:
