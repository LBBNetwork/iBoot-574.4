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
#include "hardware/arm_pl011.h"

void c_main(void) {
    /* platform init */
    arm_setup();

#ifdef s5l8930x
    if((READ_REGISTER_ULONG(0xBF100000 + 0x6000) >> 24) != GET_BITS(READ_REGISTER_ULONG(0xBF500000), 9, 7))
        while(1);

    /* spin if bad epoch id */
#endif

    s5l8900_uart_init();
    _printf("Hello world\n");
    arm_reboot();
    /* todo: implement */
    while(1);
}
