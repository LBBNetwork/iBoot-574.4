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

#include "system/iboot.h"
//#include "hardware/arm_pl011.h"

void arm_setup(void) {

    /* initialize arm processors */
    arm_clear_all_cache();
    arm_write_control_register_data(arm_read_control_register_data() & ~(0x1000));
    arm_write_control_register_data(arm_read_control_register_data() & ~(0x4));
    arm_enable_vfp();
    arm_clear_all_cache();
    arm_write_control_register_data(arm_read_control_register_data() | (0x1000));
    arm_write_control_register_data(arm_read_control_register_data() | (0x4));
    arm_write_control_register_data(arm_read_control_register_data() | (0x2));
    arm_write_control_register_data(arm_read_control_register_data() | (0x800));
    
}

