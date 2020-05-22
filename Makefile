# Makefile is written only for the Raspberry Pi 3
KERNEL_BIN = kernel8.img
QEMU_BINARY = qemu-system-aarch64
QEMU_MACHINE_TYPE = raspi3
QEMU_RELEASE_ARGS = -d in_asm -display none
LINKER_FILE = src/bsp/raspberrypi/link.ld
RUSTC_MISC_ARGS = -C target-cpu = cortex-a53

export LINKER_FILE

RUSTFLAGS = -C link-arg = -T$(LINKER_FILE) $(RUSTC_MISC_ARGS)
RUSTFLAGS_PEDANTIC = $(RUSTFLAGS) -D warnings -D missing_docs

COMPILER_ARGS = --target = $(TARGET) --features bsp_$(BSP) --release

RUSTC_CMD = cargo rustc $(COMPILER_ARGS)
CLIPPY_CMD = cargo clippy $(COMPILER_ARGS)
CHECK_CMD = cargo check $(COMPILER_ARGS)
OBJCOPY_CMD = rust-objcopy --strip-all -O binary

KERNEL_ELF = target/$(TARGET)/release/kernel

DOCKER_IMAGE = rustembedded/osdev-utils
DOCKER_CMD = docker run -it --rm -v $(shell pwd):/work/tutorial -w /work/tutorial

DOCKER_QEMU = $(DOCKER_CMD) $(DOCKER_IMAGE)
EXEC_QEMU = $(QEMU_BINARY) -M $(QEMU_MACHINE_TYPE)

.PHONY: all $(KERNEL_ELF) $(KERNEL_BIN) qemu clippy clean readelf objdump nm check

all: $(KERNEL_BIN)

$(KERNEL_ELF): RUSTFLAGS="$(RUSTFLAGS_PEDANTIC)" $(RUSTC_CMD)
$(KERNEL_BIN): $(KERNEL_ELF) @$(OBJCOPY_CMD) $(KERNEL_ELF) $(KERNEL_BIN)


qemu: $(KERNEL_BIN)
    @$(DOCKER_QEMU) $(EXEC_QEMU) $(QEMU_RELEASE_ARGS) -kernel $(KERNEL_BIN)

clippy: RUSTFLAGS="$(RUSTFLAGS_PEDANTIC)" $(CLIPPY_CMD)

clean: rm -rf target $(KERNEL_BIN)

readelf: $(KERNEL_ELF) readelf -a $(KERNEL_ELF)

objdump: $(KERNEL_ELF) rust-objdump --arch-name aarch64 --disassemble --demangle --no-show-raw-insn --print-imm-hex $(KERNEL_ELF)

nm: $(KERNEL_ELF) rust-nm --demangle --print-size $(KERNEL_ELF) | sort

check: @RUSTFLAGS="$(RUSTFLAGS)" $(CHECK_CMD) --message-format=json
