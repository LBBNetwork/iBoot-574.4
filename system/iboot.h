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

#ifndef _IBOOT_H_
#define _IBOOT_H_

#include <stddef.h>
#include "system/types.h"
#include "system/base.h"
#include "system/task.h"
#include "system/string.h"
#include "system/stdio.h"
#include "system/arm.h"

#define WRITE_REGISTER_ULONG(reg, data) (*((volatile uint32_t*)(reg)) = data)
#define READ_REGISTER_ULONG(reg) (*((volatile uint32_t*)(reg)))
#define WRITE_REGISTER_USHORT(reg, data) (*((volatile uint16_t*)(reg)) = data)
#define READ_REGISTER_USHORT(reg) (*((volatile uint16_t*)(reg)))
#define WRITE_REGISTER_UCHAR(reg, data) (*((volatile uint8_t*)(reg)) = data)
#define READ_REGISTER_UCHAR(reg) (*((volatile uint8_t*)(reg)))
#define GET_BITS(x, start, length) ((((uint32_t)(x)) << (32 - ((start) + (length)))) >> (32 - (length)))

void arm_setup(void);
int image3_load(unsigned char* image3);
void s5l8900_uart_init();
void s5l_uart_send_char(uint8_t c);

extern char _securerom_title[];
extern char _securerom_build[];
extern char _securerom_revision[];
extern char* _securerom_revision_offset;

#endif
