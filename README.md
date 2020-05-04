# RustyRaspy-OS

## Introduction

I will be developing and improving the documentation as the project progressed. For now the documentation is very rough and minimal. 

## Dev Setup

I develop on a windows machine and use WSL usually. However, because of the requirements of the project WSL does notwork with the device drivers required for UART communication. So, I used an Ubuntu VM in which I installed rust, docker and mounted the UART usb.

## USB to TTL (UART) Setup

I used the [SH-U09C](https://www.amazon.com/DSD-TECH-Adapter-FT232RL-Compatible/dp/B07BBPX8B8) for my serial output.

The image below describes the specific USB to TTL setup I used.

![Specific device setup for USB to TTL](assets/ttl_setup.jpg 'SH-U09C connections')

The image below will show a generic description to connect with using any other USB to TTL device models.

![Generic device setup for USB to TTL](assets/generic_wiring.png 'Generic setup for UART devices')

## Acknowledgments

This original project started off as a learning experiment from [Andre Richter](https://www.andre-richter.com/)'s tutorial on OS programming
for the Raspberry Pi 3. The original source code can be found on his [github](https://github.com/rust-embedded/rust-raspberrypi-OS-tutorials).
