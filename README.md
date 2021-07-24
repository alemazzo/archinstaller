[![Contributors][contributors-shield]][contributors-url]
[![Forks][forks-shield]][forks-url]
[![Stargazers][stars-shield]][stars-url]
[![Issues][issues-shield]][issues-url]
[![MIT License][license-shield]][license-url]



<!-- PROJECT LOGO -->
<br />
<p align="center">
  <a href="https://github.com/alemazzo/ArchInstaller">
    <img src="images/logo.png" alt="Logo" width="80" height="80">
  </a>

  <h3 align="center">Arch-Installer</h3>

  <p align="center">
    An easy-to-use Arch-Linux installer written in Python
    <br />
    <a href="https://github.com/alemazzo/ArchInstaller"><strong>Explore the docs »</strong></a>
    <br />
    <br />
    <a href="https://github.com/alemazzo/ArchInstaller">View Demo</a>
    ·
    <a href="https://github.com/alemazzo/ArchInstaller">Report Bug</a>
    ·
    <a href="https://github.com/alemazzo/ArchInstaller">Request Feature</a>
  </p>
</p>



<!-- TABLE OF CONTENTS -->
## Table of Contents

- [Table of Contents](#table-of-contents)
- [About The Project](#about-the-project)
  - [Built With](#built-with)
- [Getting Started](#getting-started)
  - [Prerequisites](#prerequisites)
  - [Installation](#installation)
- [Configuration](#configuration)
- [Usage](#usage)
- [Roadmap](#roadmap)
- [Contributing](#contributing)
- [License](#license)
- [Contact](#contact)



<!-- ABOUT THE PROJECT -->
## About The Project

[![Product Name Screen Shot][product-screenshot]](https://example.com)

There are many great README templates available on GitHub, however, I didn't find one that really suit my needs so I created this enhanced one. I want to create a README template so amazing that it'll be the last one you ever need.

Here's why:
* Your time should be focused on creating something amazing. A project that solves a problem and helps others
* You shouldn't be doing the same tasks over and over like creating a README from scratch
* You should element DRY principles to the rest of your life :smile:

Of course, no one template will serve all projects since your needs may be different. So I'll be adding more in the near future. You may also suggest changes by forking this repo and creating a pull request or opening an issue.

A list of commonly used resources that I find helpful are listed in the acknowledgements.

### Built With

* [Python3](https://www.python.org)
* [PyYAML](https://pyyaml.org)


<!-- GETTING STARTED -->
## Getting Started

This is an example of how you may give instructions on setting up your project locally.
To get a local copy up and running follow these simple example steps.

### Prerequisites

1. Download the Arch-Linux ISO from the [official website](https://archlinux.org/download/)
2. Make a [bootable USB](https://wiki.archlinux.org/title/USB_flash_installation_medium) with the ISO
3. Boot the ISO
### Installation

1. Install git
```sh
pacman -Sy git
```
2. Clone the repo
```sh
git clone https://github.com/alemazzo/archinstaller
```
3. Change directory
```sh
cd archinstaller
```
## Configuration

1. If you want to make the partitions by yourself this is the moment. Otherwise use the `format.sh` script for erase all the disk and create a unique partition for the os.
```sh
# This will delete all your data
chmod +x format.sh
./format.sh
```
2. Start editing the configuration
```sh
nano config.yml
```
3. Manage the settings in the `accounts` section and set the root's password and the data for the base account.
```yaml
accounts:
  root-password: root
  username: alessandro
  password: password
```
4. Manage the `settings` section for your system setup.
```yaml
settings:
  ntp: true
  keymap: it
  locale: en_US.UTF-8 UTF-8
  lang: en_US.UTF-8
  region: Europe
  location: Rome
  hostname: Matebook
```
5. Manage the `packages` section (do not touch the required packages). <br>
You can add the packages that you want in your system but i suggest you to install them once the system is already installed and not during the installation.
```yaml
packages:
  # Required packages
  ...

  # Window Managment
  - xorg
  - kde-applications
  - plasma
  - plasma-wayland-session

  # You can add other stuff here

```


<!-- USAGE EXAMPLES -->
## Usage



4.  Execute the installer
```sh
chmod +x installer.py
./installer.py config.yml
```


<!-- ROADMAP -->
## Roadmap

See the [open issues](https://github.com/alemazzo/ArchInstaller/issues) for a list of proposed features (and known issues).

<!-- CONTRIBUTING -->
## Contributing

Contributions are what make the open source community such an amazing place to be learn, inspire, and create. Any contributions you make are **greatly appreciated**.

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request



<!-- LICENSE -->
## License

Distributed under the MIT License. See `LICENSE` for more information.

<!-- CONTACT -->
## Contact

Alessandro Mazzoli - [@alessandro.py](https://instagram.com/alessandro.py) - developer.alessandro.mazzoli@gmail.com

Project Link: [https://github.com/alemazzo/ArchInstaller](https://github.com/alemazzo/ArchInstaller)

<!-- MARKDOWN LINKS & IMAGES -->
<!-- https://www.markdownguide.org/basic-syntax/#reference-style-links -->
[contributors-shield]: https://img.shields.io/github/contributors/alemazzo/ArchInstaller.svg?style=flat-square
[contributors-url]: https://github.com/alemazzo/ArchInstaller/graphs/contributors
[forks-shield]: https://img.shields.io/github/forks/alemazzo/ArchInstaller.svg?style=flat-square
[forks-url]: https://github.com/alemazzo/ArchInstaller/network/members
[stars-shield]: https://img.shields.io/github/stars/alemazzo/ArchInstaller.svg?style=flat-square
[stars-url]: https://github.com/alemazzo/ArchInstaller/stargazers
[issues-shield]: https://img.shields.io/github/issues/alemazzo/ArchInstaller.svg?style=flat-square
[issues-url]: https://github.com/alemazzo/ArchInstaller/issues
[license-shield]: https://img.shields.io/github/license/alemazzo/ArchInstaller.svg?style=flat-square
[license-url]: https://github.com/alemazzo/ArchInstaller/blob/master/LICENSE.txt
[product-screenshot]: images/screenshot.png