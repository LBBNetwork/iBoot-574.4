PREFIX=arm-elf-
BUILD ?= s5l8930x
OBJCOPY=$(PREFIX)objcopy
CC=$(PREFIX)gcc
CFLAGS=-I. -mlittle-endian -ffreestanding -nostdlib -nostdlib -Wall -mfpu=vfp -Isystem -ffunction-sections -fdata-sections -mthumb-interwork  \
	-mapcs-frame -mcpu=arm1176jzf-s -D$(BUILD)=1 -D__BUILD_BOARD__=$(BUILD)
OS_TARGET=iBoot-SecureROM
LDFLAGS=-nostdlib -nodefaultlibs -nostartfiles -Wl,-T,iboot.ld
LIBS=
OBJS=boot.o helper.o handlers.o except.o version.o __ashldi3.o __ashrdi3.o __clzsi2.o __ctzsi2.o __divdi3.o __divsi3.o __lshrdi3.o __moddi3.o __modsi3.o __udivdi3.o __udivmoddi4.o __udivmodsi4.o __udivsi3.o __umoddi3.o __umodsi3.o atoi.o atol.o atoll.o  main.o memccpy.o memchr.o memmem.o memmove.o memrchr.o memswap.o pl011.o snprintf.o sscanf.o strnlen.o strtol.o strtoll.o strtoul.o strtoull.o strxspn.o tasks.o vsnprintf.o vsscanf.o strntoimax.o strntoumax.o  string.o platform.o s5l_uart.c
all: iBoot-SecureROM iBoot-SecureROM.raw_image

iBoot-SecureROM.raw_image: iBoot-SecureROM
	$(OBJCOPY) iBoot-SecureROM -O binary iBoot-SecureROM.raw_image
	
iBoot-SecureROM: $(OBJS)
	$(CC) $(CFLAGS) $(OBJS) -o $(OS_TARGET) $(LDFLAGS)  $(LIBS)

%.o: %.c
	$(CC) $(CFLAGS) -c $<

%.o: %.S
	$(CC) $(CFLAGS) -c $<

clean:
	rm -rf *.o iBoot-SecureROM*
