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
#include "system/types.h"

#define CLOCK_GATE_BASE		0xBF100000 + 0x1010

#define UART0_ULCON	0x82500000 + 0x0
#define UART0_UCON	0x82500000 + 0x4
#define UART0_UFCON	0x82500000 + 0x8	
#define UART0_UMCON	0x82500000 + 0xc	
#define UART0_UTRSTAT	0x82500000 + 0x10	
#define UART0_UERSTAT	0x82500000 + 0x14	
#define UART0_UFSTAT	0x82500000 + 0x18	
#define UART0_UMSTAT	0x82500000 + 0x1c	
#define UART0_UTXH	0x82500000 + 0x20	
#define UART0_UFXH	0x82500000 + 0x24	
#define UART0_UBAUD	0x82500000 + 0x28	
#define UART0_UDIVSLOT	0x82500000 + 0x2c	

void s5l8900_clock_switch(uint32_t gate, int on_off) {
	if(gate > 0x3F)
		return;

	uint32_t reg = CLOCK_GATE_BASE + (gate << 2);

	if(on_off == 1) {
		WRITE_REGISTER_ULONG(reg, READ_REGISTER_ULONG(reg) | 0xF);
	} else {
		WRITE_REGISTER_ULONG(reg, READ_REGISTER_ULONG(reg) & ~0xF);
	}

	while((READ_REGISTER_ULONG(reg) & 0xF) != ((READ_REGISTER_ULONG(reg) >> 4) & 0xF));
}

void s5l8900_uart_init() {
	
	s5l8900_clock_switch(0x34, 1);

	WRITE_REGISTER_ULONG(UART0_ULCON, 3); /* 8 bit */
	WRITE_REGISTER_ULONG(UART0_UCON, (1 << 0) | (1 << 2)); /* defaults */

	WRITE_REGISTER_ULONG(UART0_UMCON, 0x1); /* no flow control */
	WRITE_REGISTER_ULONG(UART0_UFCON, 0x4 | 0x2); /* fifo enable */
	WRITE_REGISTER_ULONG(UART0_UFCON, 0x1); /* fifo enable */

	WRITE_REGISTER_ULONG(UART0_UCON, (READ_REGISTER_ULONG(UART0_UCON) & (~(0x7000)) & (1 << 5)));
	WRITE_REGISTER_ULONG(UART0_UCON, ((READ_REGISTER_ULONG(UART0_UCON) & (~(0x3 << 0)) & (~(0x3 << 2))) | (1 << 0) | (1 << 2)));

	return;
}

void s5l_uart_send_char(uint8_t c) {
	WRITE_REGISTER_ULONG(UART0_UTXH, c);
}

void puts(char* buffer) {
	while(*buffer) 
		s5l_uart_send_char(*buffer++);
}

