FROM ubuntu:22.04 AS base

ARG BUILDROOT_BASE=/root
ARG CONFIGFILE=licheepi_nano_spiflash_defconfig

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && \
	apt upgrade && \
	apt install -qy \
	gcc \
	gcc-arm-linux-gnueabi \
	git \
	locales \
	bc \
	bison \
	build-essential \
	python3-dev \
    python3-distutils \
    python3-setuptools \
	libssl-dev \
	libncurses-dev \
	libusb-1.0-0-dev \
	libfdt-dev \
	device-tree-compiler \
	flex \
	swig \
	uuid-dev \
	pkg-config 

RUN update-locale LC_ALL=C

# Build sunxi-tools
FROM base AS tools
ARG BUILDROOT_BASE
WORKDIR $BUILDROOT_BASE
RUN git clone --depth 1 https://github.com/linux-sunxi/sunxi-tools.git && \
cd sunxi-tools && \
make && \
make install

# Build u-boot files
FROM base AS main
ARG BUILDROOT_BASE
ARG CONFIGFILE

COPY --from=tools /usr/local/bin/ /usr/local/bin/
COPY --from=tools /usr/local/share/man/man1/ /usr/local/share/man/man1/

WORKDIR $BUILDROOT_BASE

# RUN git clone --depth 1 --branch v2023.10 https://source.denx.de/u-boot/u-boot.git
RUN git clone --depth 1 https://github.com/u-boot/u-boot.git

WORKDIR $BUILDROOT_BASE/u-boot
COPY licheepi-nano licheepi-nano
RUN ln -fs $PWD/licheepi-nano/licheepi_nano_defconfig configs/licheepi_nano_defconfig \
 && ln -fs $PWD/licheepi-nano/licheepi_nano_spiflash_defconfig configs/licheepi_nano_spiflash_defconfig \
 && ln -fs $PWD/licheepi-nano/suniv-f1c100s-licheepi-nano-spiflash.dtsi arch/arm/dts/suniv-f1c100s-licheepi-nano-spiflash.dtsi

 # configure default config for the board
RUN make ARCH=arm CROSS_COMPILE=arm-linux-gnueabi- $CONFIGFILE

# run the build
RUN make ARCH=arm CROSS_COMPILE=arm-linux-gnueabi- -j4

# expose built image files in standalone root folder
FROM scratch AS dist
COPY --from=main /root/u-boot/u-boot* .
