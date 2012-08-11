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
#define xstr(s) str(s)
#define str(s) #s
.include "asm/include.h"


.section .srom_title,"aS"
.global _securerom_title
_securerom_title:                                
	.asciz "SecureROM for ARMv7, Copyright 2012, The Little BeigeBox"
	.align 4

.section .srom_build,"aS"
.global _securerom_build
_securerom_build:
	.asciz "RELEASE"
	.align 4

.section .srom_revision,"aS"
.global _securerom_revision
_securerom_revision:
	.asciz "iBoot-574.4"
	.align 4

.section .srom_revision_offset,"aS"
.global _securerom_revision_offset
_securerom_revision_offset:
	.long	_securerom_title
	.long	_securerom_build
	.long	_securerom_revision
