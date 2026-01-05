# PeaZip Anylinux AppImage 🐧

## Build status

[![GitHub Downloads](https://img.shields.io/github/downloads/carlos-a-g-h/peazip-anylinux-appimage/total?logo=github&label=GitHub%20Downloads)](https://github.com/carlos-a-g-h/peazip-anylinux-appimage/releases/latest)

[![CI Build Status](https://github.com//carlos-a-g-h/peazip-anylinux-appimage/actions/workflows/appimage.yml/badge.svg)](https://github.com/carlos-a-g-h/peazip-anylinux-appimage/releases/latest)

* [Latest Stable Release](https://github.com/carlos-a-g-h/peazip-anylinux-appimage/releases/latest)

## About this AppImage

PeaZip does not provide any appimages, they only provide a portable version of PeaZip. However, this portable version requires a relatively new system, but my system is older than that, so that's why I'm building not just AppImages, but AppImages that RUN EVERYWHERE

<details>
  <summary><b><i>IT RUNS ON THIS OLD-ASS DISTRO</i></b></summary>
    <strong>PICTURE GOES HERE, IF YOU DON'T SEE IT, THIS THING IS STILL WIP</strong>
    <strong><i>System: Debian 11, libc6 2.31</i></strong>
</details>

### Variants/Versions

The variants are based on the portable variants that are available at the [download section](https://peazip.github.io/peazip-linux.html) of PeaZip's website and/or the [releases](https://github.com/peazip/PeaZip/releases) of the official repository

| Version | Variant name | Status | Description |
|-|-|-|-|
| Any | QT | WIP | Qt variant |
| Any | GTK | WIP | GTK variant |

### Internal scripts and programs

These AppImages have internal scripts and programs, that can be launched by calling them as commandline arguments

```
./PeaZip.AppImage [program]
```

This AppImage has internal scripts and programs that can be launched by calling them as commandline arguments

|Program or script|Description|
|-|-|
| pea | Runs "pea" |
| setup | An "installation" script for the appimage. It provides a nice config, a DESKTOP file in /usr/share/applications and an icon |
| details | Extracts the "details" directory from the AppImage |

### About the setup script

This script can help you integrate the appimage to your system

```
./PeaZip.AppImage setup [FLAGS]
```

| Flag | Description |
|-|-|
| --install | Performs the installation, integrating the appimage to your system |
| --no-config | Will not copy the recommended config to your system |
| --no-links | Will not create symlinks that go from /usr/bin/ to the AppImage |
| --no-desktop | Will not create the application desktop file and its icon |
| --force | Overwrites in case that there are files or paths that already exist |

Use the command without any arguments for more details

## What is AnyLinux ?

These AppImages are made using [sharun](https://github.com/VHSgunzo/sharun), which makes it extremely easy to turn any binary into a portable package without using containers or similar tricks.

**These AppImages bundle everything and should work on any linux distro, even on musl based ones.**

These AppImages can work **without FUSE** at all thanks to the [uruntime](https://github.com/VHSgunzo/uruntime)

More at: [AnyLinux-AppImages](https://pkgforge-dev.github.io/Anylinux-AppImages/)

<details>
  <summary><b><i>raison d'être</i></b></summary>
    <img src="https://github.com/user-attachments/assets/d40067a6-37d2-4784-927c-2c7f7cc6104b" alt="Inspiration Image">
</details>
