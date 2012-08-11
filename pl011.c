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

#ifdef INTEGRATORCP

#warning This file will go away once real S5L uart support is done, only for bringup and debug via QEMU
#warning Use qemu-system-arm -M cortex-a8 -kernel iBoot-SecureROM -S -s for debugging.

#include "system/iboot.h"
#include "system/types.h"

#define UART_PL01x_DR            (uart_base + 0x00)
#define UART_PL01x_RSR           (uart_base + 0x04)
#define UART_PL01x_ECR           (uart_base + 0x04)
#define UART_PL01x_FR            (uart_base + 0x18)
#define UART_PL011_IBRD          (uart_base + 0x24)
#define UART_PL011_FBRD          (uart_base + 0x28)
#define UART_PL011_LCRH          (uart_base + 0x2C)
#define UART_PL011_CR            (uart_base + 0x30)
#define UART_PL011_IMSC          (uart_base + 0x38)
#define UART_PL011_LCRH_WLEN_8   0x60
#define UART_PL011_LCRH_FEN      0x10
#define UART_PL011_CR_UARTEN     0x01
#define UART_PL011_CR_TXE        0x100
#define UART_PL011_CR_RXE        0x200
#define UART_PL01x_FR_RXFE       0x10
#define UART_PL01x_FR_TXFF       0x20

uint32_t uart_base = 0x16000000;

void pl011_uart_send_char(uint8_t c) {
	(*(volatile uint32_t*)(UART_PL01x_DR)) = c;
}

int pl011_uart_is_ready(void) {
	return (((*(volatile uint32_t*)(UART_PL01x_FR)) & UART_PL01x_FR_TXFF) == 0);
}

void puts(char* buffer) {
	while(*buffer) 
		pl011_uart_send_char(*buffer++);
}

#endif
