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
#include "hardware/arm_intr.h"
#include "hardware/arm_edgeic.h"
.include "asm/include.h"

.text

.global handle_irq
.global handle_fiq
.global _arm_data_abort_handler
.global _arm_prefetch_abort_handler
.global _arm_reserved_handler
.global _arm_syscall_handler
.global _arm_undefined_handler

.code 16

/* irq */

handle_irq:
    push    {r4,r5,r6,lr}
    ldr     r3, =(VIC0 + VICIRQSTATUS)
    ldr     r3, [r3]
    cmp     r3, #0
    beq     check_vic_1

check_vic_1:
    ldr     r3, =(VIC1 + VICIRQSTATUS)
    ldr     r3, [r3]
    cmp     r3, #0
    beq     check_vic_2
    ldr     r5, =(VIC1 + VICADDRESS)
    b       lookup_handler

check_vic_2:
    ldr     r3, =(VIC2 + VICIRQSTATUS)
    ldr     r3, [r3]
    cmp     r3, #0
    beq     check_vic_3
    ldr     r5, =(VIC2 + VICADDRESS)
    b       lookup_handler

check_vic_3:
    ldr     r3, =(VIC3 + VICIRQSTATUS)
    ldr     r3, [r3]
    cmp     r3, #0
    beq     return
    ldr     r5, =(VIC3 + VICADDRESS)
    b       lookup_handler

lookup_handler:
    ldr     r2, [r5]
    cmp     r2, #VIC_MaxInterrupt
    bhi     call_handler
    lsl     r0, r2, #1
    add     r3, r0, r2
    lsl     r6, r3, #2
    add     r6, r6, r1
    ldr     r3, [r6,#InterruptHandler.useEdgeIC]
    cmp     r3, #0
    beq     prepare_handler
    cmp     r2, #VIC_InterruptSeparator
    bhi     edge_ic_high_interrupt
    ldr     r4, =(EDGEIC + EDGEICLOWSTATUS)
    mov     r3, #1
    lsl     r3, #2
    b       edge_ic_reset

edge_ic_high_interrupt:
    ldr     r4, =(EDGEIC + EDGEICHIGHSTATUS)
    sub     r2, #VIC_InterruptSeparator
    mov     r3, #1
    lsl     r3, r2

edge_ic_reset:
    str     r3, [r4]

prepare_handler:
    ldr     r2, [r6,#InterruptHandler.handler]
    cmp     r2, #0
    beq     end_of_interrupt
    ldr     r0, [r6,#InterruptHandler.token]

call_handler:
    ldr     r6, =current_running
    ldr     r1, [r6]
    ldr     r6, =_irq_shadow_task
    str     r1, [r6]

    ldr     r6, =_irq_handler_task
    ldr     r1, [r6]
    ldr     r6, =current_running
    str     r1, [r6]

    blx     r2

    ldr     r6, =_irq_shadow_task
    ldr     r1, [r6]
    ldr     r6, =current_running
    str     r1, [r6]

end_of_interrupt:
    mov     r3, #1
    str     r3, [r5]

return:
    pop     {r4,r5,r6,pc}

/* fiq */

handle_fiq:
    push    {r4,lr}
    ldr     r0, =(VIC0 + VICIRQSTATUS)
    ldr     r0, [r0]
    cmp     r0, #0
    beq     _check_vic_1
    mov     r4, #0
    b       _call_handler

_check_vic_1:
    ldr     r0, =(VIC1 + VICIRQSTATUS)
    ldr     r0, [r0]
    cmp     r0, #0
    beq     _return
    mov     r4, #VIC_InterruptSeparator

_call_handler:
    bl      __ctzsi2
    ldr     r2, =_s5l_interrupt_handler_table
    add     r0, r0, r4
    lsl     r3, r0, #1
    add     r0, r3, r0
    lsl     r0, r0, #2
    add     r0, r0, r2
    ldr     r3, [r0,#InterruptHandler.handler]
    cmp     r3, #0
    beq     _return
    ldr     r0, [r0,#InterruptHandler.token]
    blx     r3

_return:
    pop     {r4,pc}

/*
 * 32BIT CODE FINALLY
 */

.code 32
_arm_undefined_handler:
    stmfd   sp!, {r0-r12,lr}
    mov     r0, sp
    blx     _thumb_undefined_handler
    ldmfd   sp!, {r0-r12,pc}^

_arm_reserved_handler:
    stmfd   sp!, {r0-r12,lr}
    mov     r0, sp
    blx     _thumb_reserved_handler
    ldmfd   sp!, {r0-r12,pc}^

_arm_syscall_handler:
    stmfd   sp!, {r0-r12,lr}
    mrs     r0, spsr
    stmfd   sp!, {r0}
    mov     r0, sp
    blx     _thumb_syscall_handler
    ldmfd   sp!, {r0}
    msr     spsr_cf, r0
    ldmfd   sp!, {r0-r12,pc}^

_arm_prefetch_abort_handler:
    sub     lr, lr, #4
    stmfd   sp!, {r0-r12,lr}
    mrs     r0, spsr
    stmfd   sp!, {r0}
    mov     r0, sp
    blx     _thumb_prefetch_abort_handler
    ldmfd   sp!, {r0}
    msr     spsr_cf, r0
    ldmfd   sp!, {r0-r12,pc}^

_arm_data_abort_handler:
    sub     lr, lr, #8
    stmfd   sp!, {r0-r12,lr}
    mrs     r0, spsr
    stmfd   sp!, {r0}
    mov     r0, sp
    blx     _thumb_data_abort_handler
    ldmfd   sp!, {r0}
    msr     spsr_cf, r0
    ldmfd   sp!, {r0-r12,pc}^

/* 
 * back to 16 bit.
 */

.code 16
_thumb_syscall_handler:
    bl      spin
    bx      lr

_thumb_reserved_handler:
    bl      spin
    bx      lr

_thumb_undefined_handler:
    bl      spin
    bx      lr

_thumb_prefetch_abort_handler:
    bl      spin
    bx      lr

_thumb_data_abort_handler:
    bl      spin
    bx      lr

spin:
    b       spin

