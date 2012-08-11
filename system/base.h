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

#ifndef _BASE_H_
#define _BASE_H_

typedef struct EVENT EVENT;

typedef
void
(*PEVENT_HANDLER)(
    EVENT* event,
    void* opaque
    );

typedef struct _LIST_HEAD {
    void* previous;
    void* next;
} __attribute__((packed)) LIST_HEAD;

struct EVENT {
    LIST_HEAD list;
    uint64_t deadline;
    uint64_t interval;
    PEVENT_HANDLER handler;
    void* opaque;
};

#endif
