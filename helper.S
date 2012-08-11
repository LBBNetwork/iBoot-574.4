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

.global enter_critical_section
.global leave_critical_section
.global arm_disable_cpu_fiq
.global arm_disable_cpu_irq
.global arm_enable_cpu_fiq
.global arm_enable_cpu_irq
.global arm_read_control_register_data
.global arm_write_control_register_data
.global arm_read_aux_register_data
.global arm_write_aux_register_data
.global arm_read_domain_register_data
.global arm_write_domain_register_data
.global arm_enable_vfp
.global arm_wait_for_interrupt
.global arm_write_tlb0
.global arm_read_tlb0
.global arm_invalidate_tlb
.global arm_clear_icache
.global arm_clear_dcache
.global arm_clear_all_cache
.global arm_reboot

.code 16
.thumb_func
enter_critical_section:
    push    {lr}
    ldr     r0, =arm_disable_cpu_irq
    blx     r0
    ldr     r0, =arm_disable_cpu_fiq
    blx     r0
    ldr     r1, =current_running
    ldr     r2, [r1]
    ldr     r0, [r2,#TaskDescriptor.criticalSectionNestCount]
    add     r0, #1
    str     r0, [r2,#TaskDescriptor.criticalSectionNestCount]
    pop     {pc}
    
.thumb_func
leave_critical_section:
    push    {lr}

    ldr     r1, =current_running
    ldr     r2, [r1]
    ldr     r0, [r2,#TaskDescriptor.criticalSectionNestCount]
    sub     r0, #1
    str     r0, [r2,#TaskDescriptor.criticalSectionNestCount]
    bne     ret

    ldr     r0, =arm_disable_cpu_irq
    blx     r0
    ldr     r0, =arm_disable_cpu_fiq
    blx     r0
    
ret:
    pop     {pc}

.code 32
arm_disable_cpu_irq:
    mrs     r0, cpsr
    bic     r0, r0, #ARM11_CPSR_IRQDISABLE
    msr     cpsr_c, r0
    bx      lr
    
arm_disable_cpu_fiq:
    mrs     r0, cpsr
    bic     r0, r0, #ARM11_CPSR_FIQDISABLE
    msr     cpsr_c, r0
    bx      lr
    
arm_enable_cpu_irq:
    mrs     r0, cpsr
    orr     r0, r0, #ARM11_CPSR_IRQDISABLE
    msr     cpsr_c, r0
    bx      lr

arm_enable_cpu_fiq:
    mrs     r0, cpsr
    orr     r0, r0, #ARM11_CPSR_IRQDISABLE
    msr     cpsr_c, r0
    bx      lr


arm_read_control_register_data:
    mrc     p15, 0, r0, c1, c0, 0
    bx      lr
    
arm_write_control_register_data:
    mcr     p15, 0, r0, c1, c0, 0
    bx      lr
    
arm_read_aux_register_data:
    mrc     p15, 0, r0, c1, c0, 1
    bx      lr
    
arm_write_aux_register_data:
    mcr     p15, 0, r0, c1, c0, 1
    bx      lr
    
arm_read_domain_register_data:
    mrc     p15, 0, r0, c3, c0
    bx      lr
    
arm_write_domain_register_data:
    mcr     p15, 0, r0, c3, c0
    bx      lr

arm_enable_vfp:
    fmrx    r2, fpexc
    orr     r2, r2, #0x40000000
    fmxr    fpexc, r2
    bx      lr
    
arm_wait_for_interrupt:
    wfi

arm_write_tlb0:
    mcr     p15, 0, r0, c2, c0
    bx      lr

arm_read_tlb0:
    mrc     p15, 0, r0, c2, c0
    bx      lr

arm_invalidate_tlb:
    mov     r0, #0
    mcr     p15, 0, r0, c8, c7
    bx      lr

arm_clear_icache:
    mov     r0, #0
    mcr     p15, 0, r0, c7, c5
    nop
    nop
    nop
    nop
    blx     lr

arm_clear_dcache:
    mov     r2, #0x2000
loc1:
    sub     r2, r2, #0x40
    mov     r1, #0
loc2:
    subs    r1, r1, #0x40000000
    orr     r0, r1, r2
    mcr     p15, 0, r0, c7, c10, 2
    bne     loc2
    cmp     r2, #0
    bne     loc1
    mov     r0, #0
    mcr     p15, 0, r0, c7, c10, 4
    bx      lr

arm_clear_all_cache:
    stmfd   sp!, {lr}
    bl      arm_clear_icache
    bl      arm_clear_dcache
    ldmfd   sp!, {lr}
    bx      lr
    
arm_reboot:
    ldr     r1, =0xBF10202C
    ldr     r3, =0xBF102024
    movs    r0, #0
    movs    r2, #1
    str     r0, [r1]
    str     r2, [r3]
    ldr     r2, =0xBF102020
    mov     r3, #0x80000000
    str     r3, [r2]
    movs    r3, #4
    str     r3, [r1]
    str     r0, [r2]
spin:
    b       spin
    
