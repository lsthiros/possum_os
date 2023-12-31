# possum_os: Just another operating system.
Writing this for fun after making a joke about an operating system that
supports ipv6 exclusively. Not sure if thats possible.

## The name
An exercise left to the reader.

## Target
I'm deciding to target the qemu arm "virt" target for the A53. I think this
makes it aarch64 instead of arm but whatever. If I need to get set up again I
need to go to arm.com's website and download gcc-arm for aarch64-none-elf.

For the time being, I got it from [here](https://developer.arm.com/downloads/-/gnu-a)

And the qemu target is described [here](https://qemu.readthedocs.io/en/latest/system/arm/virt.html)

### Rust Target
Rust, specifically, will be told to use this target: `aarch64-unknown-none-softfloat`
That means, I may have to run:
```bash
rustup target add aarch64-unknown-none-softfloat
```

xbuild is being used to manage the build environment, as such, the build command is
```bash
cargo xbuild --target=aarch64-unknown-none-softfloat.json
```

### Running
This can be run on QEMU by using the included run_qemu script. If the env variable
`KERNEL_DEBUG` is set to 1, qemu will run with an open debug port on port 1234.

#### Notes on debugging with QEMU
Something very odd is happening: When I run with the options in the run script, the
qemu system is not putting a device tree at the [base of ram](https://www.qemu.org/docs/master/system/arm/virt.html#hardware-configuration-information-for-bare-metal-programming)
. This could be because we're technically running an ELF file with the `-kernel`
argument which has its [own insinuations](https://stackoverflow.com/questions/58420670/qemu-bios-vs-kernel-vs-device-loader-file)

## Bootloader
At some point, I might want to use u-boot to boot this instead of the baremetal boot
we're doing now. To build u-boot for the virt target, we need to do the following:
```bash
CROSS_COMPILE=aarch64-none-elf-
export CROSS_COMPILE
make qemu_arm64_defconfig
make
```

## License
GNU GPL v3