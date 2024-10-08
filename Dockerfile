FROM ubuntu:22.04 AS base

ARG BUILDROOT_BASE=/root
ARG CONFIGFILE=licheepi_nano_spiflash_defconfig

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && \
	apt upgrade && \
	apt install -qy \
	gcc \
	gcc-arm-linux-gnueabi \
	# gcc-aarch64-linux-gnu \
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
	device-tree-compiler \
	flex \
# 	coccinelle \
# 	dfu-util \
# 	efitools \
# 	gdisk \
# 	graphviz \
# 	imagemagick \
#   liblz4-tool libgnutls28-dev libguestfs-tools \
#   libpython3-dev libsdl2-dev lz4 lzma lzma-alone openssl \
#   pkg-config python3 python3-asteval python3-coverage python3-filelock \
#   python3-pkg-resources python3-pycryptodome python3-pyelftools \
#   python3-pytest python3-pytest-xdist python3-sphinxcontrib.apidoc \
#   python3-sphinx-rtd-theme python3-subunit python3-testtools \
#   python3-virtualenv \
	swig \
	uuid-dev

RUN update-locale LC_ALL=C

WORKDIR $BUILDROOT_BASE
# RUN git clone --depth 1 --branch v2023.10 https://source.denx.de/u-boot/u-boot.git
RUN git clone --depth 1 https://github.com/u-boot/u-boot.git

FROM base AS build
ARG BUILDROOT_BASE
ARG CONFIGFILE

WORKDIR $BUILDROOT_BASE/u-boot
COPY licheepi-nano/licheepi_nano_defconfig configs/
COPY licheepi-nano/licheepi_nano_spiflash_defconfig configs/

# configure default config for the board
RUN make $CONFIGFILE

# run the build
RUN make ARCH=arm CROSS_COMPILE=arm-linux-gnueabi- -j8

# expose built image files in standalone root folder
FROM scratch AS dist
COPY --from=build /root/u-boot/u-boot* .
