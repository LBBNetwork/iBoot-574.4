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

#ifndef _ARM_H_
#define _ARM_H_

void enter_critical_section();
void leave_critical_section();
void arm_disable_cpu_fiq();
void arm_disable_cpu_irq();
void arm_enable_cpu_fiq();
void arm_enable_cpu_irq();
uint32_t arm_read_control_register_data();
void arm_write_control_register_data(uint32_t r0);
uint32_t arm_read_aux_register_data();
void arm_write_aux_register_data(uint32_t r0);
uint32_t arm_read_domain_register_data();
void arm_write_domain_register_data(uint32_t r0);
void arm_enable_vfp();
void arm_wait_for_interrupt();
void arm_write_tlb0();
uint32_t arm_read_tlb0(uint32_t r0);
void arm_invalidate_tlb();
void arm_clear_icache();
void arm_clear_dcache();
void arm_clear_all_cache();
void arm_reboot();

#endif
