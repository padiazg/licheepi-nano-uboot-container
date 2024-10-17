# licheepi-nano-uboot-container

 
https://github.com/u-boot/u-boot
# Project Name
# LicheePi Nano U-Boot Project

## Introduction
This project provides a U-Boot build configuration for the LicheePi Nano, a small and affordable development board based on the Allwinner F1C100s SoC. U-Boot is a popular open-source bootloader used in embedded systems. This project aims to facilitate the building and customization of U-Boot for the LicheePi Nano.

## Installation

### Prerequisites
Ensure you have Docker installed on your system to build the project in a containerized environment.

### Building U-Boot
1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/licheepi-nano-u-boot.git
   cd licheepi-nano-u-boot
   ```

2. Build the Docker image and compile U-Boot:
   ```bash
   docker build -t licheepi-nano-u-boot .
   ```

3. Extract the built U-Boot binaries:
   ```bash
   docker create --name extract licheepi-nano-u-boot
   docker cp extract:/u-boot.bin ./dist/
   docker rm extract
   ```

## Usage
Flash the U-Boot binary to your LicheePi Nano using your preferred method (e.g., via USB or SD card). Refer to the LicheePi Nano documentation for detailed instructions.

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
