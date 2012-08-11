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

const TASK_DESCRIPTOR bootstrapTaskInit = {
	TASK_IDENTIFIER_1,
	{0, 0},
	{0, 0},
	TASK_RUNNING,
	1,
	{0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
	{{0, 0}, 0, 0, 0, 0},
	{0, 0},
	0,
	0,
	0,
	0,
	0,
	"bootstrap",
	TASK_IDENTIFIER_2
};

const TASK_DESCRIPTOR irqTaskInit = {
	TASK_IDENTIFIER_2,
	{0, 0},
	{0, 0},
	TASK_RUNNING,
	1,
	{0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
	{{0, 0}, 0, 0, 0, 0},
	{0, 0},
	0,
	0,
	0,
	0,
	0,
	"irq",
	TASK_IDENTIFIER_2
};

static TASK_DESCRIPTOR bootstrapTask;
static TASK_DESCRIPTOR irqTask;

TASK_DESCRIPTOR *_irq_handler_task = &irqTask;
TASK_DESCRIPTOR *_irq_shadow_task = NULL;
