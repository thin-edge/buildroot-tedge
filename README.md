# buildroot-tedge
Buildroot thin-edge.io package

## Quick Start
> Before you start using Buildroot check [official Buildroot guide](https://buildroot.org/downloads/manual/manual.html#_getting_started) to make sure all dependencies are installed.

### Build image using default config
Currently `buildroot-tedge` supports default config for the following boards:
* Raspberry pi 3 64-bit
* Raspberry pi 4

You can apply one of the existing configs to provide all necessary packages and modifications to run image with `thin-edge` on desired board:

```bash
make BR2_EXTERNAL=$PWD/br-external -C buildroot thin_edge_<boardname>_defconfig
```

e.g:

```bash
make BR2_EXTERNAL=$PWD/br-external -C buildroot thin_edge_rpi3_64_defconfig
```

>Note: You need to provide BR2_EXTERNAL location only once as it gets cached for further invocations of `make` command.

You can check available configs under `br-external/configs` directory or with `list-defconfigs` command:

```bash
make -C buildroot list-defconfigs
```

All the configs provided by the `tedge-buildroot` will be located under `External configs in "Thin-edge external tree"` module. 

Once you apply config, build the image
```bash
make -C buildroot all
```

Your image will be stored under `buildroot/output/images` directory.

### Build image using default config

If thin-edge config is not available for your board, you can add all necessary packages using default configs and Buildroot's `menuconfig`

First, apply one of the board configs that are delivered by Buildroot. You can find them under `buildroot/configs` directory or with `list-defconfigs` command:

```bash
make -C buildroot list-defconfigs 
```

Then do all necessary changes to run `thin-edge` using `menuconfig`:
```bash
make -C buildroot menuconfig
```

Change init system to systemd:
```
System configuration -> Init system -> systemd
```

Install glibc utilities:
```
Toolchain -> Install glibc utilities
```

Install sudo:
```
Target packages -> Shell and utilities -> sudo
```

Install mosquitto:
```
Target packages -> Networking applications -> mosquitto
```

Install CA certificates library:
```
Target packages -> Libraries -> Crypto -> Ca_certificates
```

Install libxcrypt library:
```
Target packages -> Libraries -> Crypto -> libxcrypt
```

Once all necessary packages are installed, you will be able to add `thin-edge`:
```
External options -> thin-edge
```

You can leave `menuconfig` using `Exit` and build the image:
```bash
make -C buildroot all
```

Your image will be stored under `buildroot/output/images` directory.

### Additional packages
If you want to connect to your device via SSH, you need to provide one of the SSH package, e.g `dropbear`. You can find it in `menuconfig`:
```
Target packages -> Networking appliocations -> dropbear
```

> Note: the dropbear package is not attached to thin-edge configs! You need to add it manually.
