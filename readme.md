# LicheePi Nano U-Boot Project

## Introduction
This project provides a U-Boot build configuration for the LicheePi Nano, a small and affordable development board based on the Allwinner F1C100s SoC. U-Boot is a popular open-source bootloader used in embedded systems. This project aims to facilitate the building and customization of U-Boot for the LicheePi Nano.

## Installation

### Prerequisites
Ensure you have Docker installed on your system to build the project in a containerized environment. If your Docker is older than v23, ensure that you have [BuildKit enabled](https://docs.docker.com/build/buildkit/#getting-started).

### Building U-Boot
1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/licheepi-nano-u-boot.git
   cd licheepi-nano-u-boot
   ```

2. Build the image:
   ```bash
   docker buildx build -t u-boot-build:20241005 --output type=tar,dest=- . \
   | (mkdir -p dist && tar x -C dist)
   ```
   The files and images will be stored in the `dist` directory.

## Usage
Flash the U-Boot binary to your LicheePi Nano using your preferred method (e.g., via USB or SD card). Refer to the LicheePi Nano documentation for detailed instructions.

## Customization and tools
You can build the images inside the container, perhaps with some customizations, or maybe you want to use the sunxi-tools inside the images.
```shell
# build a temporary image
docker buildx build --target main -t u-boot-temp .

# run a container
docker run \
   -it \
   --rm \
   --name u-boot-temp \
   u-boot-temp

# customize the u-boot
make menuconfig
make
```

### sunxi-tools
The __sunxi-tools__ are available in the `/usr/local/bin/` directory, and needs `/dev/bus/usb` mounted inside the container to access the USB devices, therefore also needs `--privileged` to access the USB devices.  
```shell
# run a container with the image (linux)
docker run \
   -it \
   --rm \
   --privileged \
   -v /dev/bus/usb:/dev/bus/usb \
   --name u-boot-temp \
   u-boot-temp

# customize the u-boot
make menuconfig
make

# run the sunxi-tools (linux)
sunxi-fel list
sunxi-fel -p spiflash-write 0x40000000 u-boot-sunxi-with-spl.bin
```

MacOS has a different driver model and there's no way to pass the USB bus to the container, so the __sunxi-tools__ won't find the USB bus and wont work.
If Docker is running on a VM it might work, just use the instructions for linux and it probably would work, but I didn't tryied it as my Mac runs Docker Desktop native.


## Sources
U-Boot: https://github.com/u-boot/u-boot  
Sunxi tools: https://github.com/linux-sunxi/sunxi-tools  

## Contributing
Contributions are welcome! Please follow these steps to contribute:
1. Fork the repository.
2. Create a new branch for your feature or bugfix.
3. Commit your changes with clear and descriptive messages.
4. Push your changes to your fork.
5. Submit a pull request to the main repository.

## License
This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

## Contact
For questions or feedback, please contact [padiazg@gmail.com](mailto:padiazg@gmail.com) or [patricio@patodiaz.io](patricio@patodiaz.io).
