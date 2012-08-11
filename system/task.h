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

#ifndef _TASK_H_
#define _TASK_H_

#define TASK_IDENTIFIER_1   0x7461736b  /* 'task' */
#define TASK_IDENTIFIER_2   0x74736b32  /* 'tsk2' */

typedef
void
(*PTASK_FUNCTION_ROUTINE)(
    void* opaque
    );

typedef struct _TASK_REGISTER_STATE {
    uint32_t	r4;
	uint32_t	r5;
	uint32_t	r6;
	uint32_t	r7;
	uint32_t	r8;
	uint32_t	r9;
	uint32_t	r10;
	uint32_t	r11;
	uint32_t	sp;
	uint32_t	lr;
} __attribute__((packed)) TASK_REGISTER_STATE;

typedef enum _TASK_STATE {
	TASK_READY = 1,
	TASK_RUNNING = 2,
	TASK_SLEEPING = 4,
	TASK_STOPPED = 5
} TASK_STATE;

typedef struct _TASK_DESCRIPTOR {
    uint32_t    identifier_1;
    LIST_HEAD   task_list;
    LIST_HEAD   runqueue_list;
    TASK_STATE  state;
    uint32_t    criticalSectionNestCount;
    TASK_REGISTER_STATE savedRegisters;
    EVENT       sleepEvent;
    LIST_HEAD   unknown;
    uint32_t    exitState;
    PTASK_FUNCTION_ROUTINE routine;
    void*       unknown_val0;
    void*       storage;
    uint32_t    storageSize;
    char        taskName[16];
    uint32_t    identifier_2;
    uint32_t    wasWoken;
} __attribute__((packed)) TASK_DESCRIPTOR;

extern TASK_DESCRIPTOR *current_running;
#endif
