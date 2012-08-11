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

/* Thumb code */

.text
    /****************/
    /* Code section */
    /****************/

/* Exception handlers */

.code 32
.global _arm_irq_handler
_arm_irq_handler:
    sub     lr, lr, #4
    stmfd   sp!, {r0-r3,r12,lr}
    blx     _thumb_irq_handler
    ldmfd   sp!, {r0-r3,r12,pc}^
    b       _arm_reset

.global _arm_fiq_handler
_arm_fiq_handler:
    sub     lr, lr, #4
    stmfd   sp!, {r0-r3,r12,lr}
    blx     _thumb_fiq_handler
    ldmfd   sp!, {r0-r3,r12,pc}^

.code 16
_thumb_irq_handler:
    push    {lr}
    bl      increment_critical_lock
    bl      handle_irq
    bl      decrement_critical_lock
    pop     {pc}

_thumb_fiq_handler:
    push    {lr}
    bl      increment_critical_lock
    bl      handle_fiq
    bl      decrement_critical_lock
    pop     {pc}

.global increment_critical_lock
.global decrement_critical_lock
.global current_running

.code 32
.global __divide_error
__divide_error:
    b       __divide_error

.code 16
.thumb_func
increment_critical_lock:
    ldr     r3, =current_running
    ldr     r2, [r3]
    ldr     r3, [r2,#TaskDescriptor.criticalSectionNestCount]
    add     r3, #1
    str     r3, [r2,#TaskDescriptor.criticalSectionNestCount]
    bx      lr

.thumb_func
decrement_critical_lock:
    ldr     r3, =current_running
    ldr     r2, [r3]
    ldr     r3, [r2,#TaskDescriptor.criticalSectionNestCount]
    sub     r3, #1
    str     r3, [r2,#TaskDescriptor.criticalSectionNestCount]
    bx      lr

.data

    /****************/
    /* Data section */
    /****************/
current_running:
    .word	0x0
