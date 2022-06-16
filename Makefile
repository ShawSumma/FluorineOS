
OPT = -O3

SRCS = source/kernel.c
OBJS = $(SRCS:%.c=%.o)

default: all

all: bin/kernel.iso

bin/kernel.iso: tmp/kernel.bin
	mkdir -p tmp/iso
	mkdir -p tmp/iso/boot
	cp limine.cfg tmp/iso/limine.cfg
	cp tmp/kernel.bin tmp/iso/kernel.bin
	cp limine/limine.sys tmp/iso/boot/limine.sys
	cp limine/limine-eltorito-efi.bin tmp/iso/limine-eltorito-efi.bin
	cp limine/limine.sys tmp/iso/boot/limine.sys
	cp limine/limine-cd.bin tmp/iso/limine-cd.bin
	xorriso -as mkisofs -b limine-cd.bin \
			-no-emul-boot -boot-load-size 4 -boot-info-table \
			--efi-boot limine-eltorito-efi.bin \
			-efi-boot-part --efi-boot-image --protective-msdos-label \
			tmp/iso -o tmp/kerne.iso
	./limine/limine-install-linux-x86_64 bin/kernel.iso

tmp/kernel.bin: $(OBJS)
	mkdir -p tmp
	$(CC) -T linker.ld -o tmp/kernel.bin -ffreestanding $(OPT) -nostdlib $(OBJS) -lgcc

$(OBJS): $(@:%.o=%.c)
	$(CC) -Istivale -c $(@:%.o=%.c) -o $@ -std=gnu11 -ffreestanding $(OPT) -fPIC -fno-builtin $(INCLUDE) $(CFLAGS) $(OS_CFLAGS)

.dummy:
