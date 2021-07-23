#!/bin/python3

# Modules import

# My imports
from modules import parse_arguments, loadYamlFromFile
import subprocess


class colors:
    HEADER = '\033[95m'
    OKBLUE = '\033[94m'
    OKCYAN = '\033[96m'
    OKGREEN = '\033[92m'
    WARNING = '\033[93m'
    FAIL = '\033[91m'
    ENDC = '\033[0m'
    BOLD = '\033[1m'
    UNDERLINE = '\033[4m'


class STATUS:
    PROGRESS = '[.]'
    OK = f'[{colors.OKGREEN}\u2714{colors.ENDC}]'
    ERROR = f'[{colors.FAIL}\u2714{colors.ENDC}]'


class Executor:

    LOGERROR = False

    @staticmethod
    def execute(command: str):
        if Executor.LOGERROR:
            process = subprocess.Popen(
                command, shell=True, stdout=subprocess.PIPE)
        else:
            process = subprocess.Popen(
                command, shell=True, stdout=subprocess.PIPE, stderr=subprocess.DEVNULL)
        process.wait()
        return process.returncode


def execute(command: str, description: str):
    message = f'{STATUS.PROGRESS} {description}'
    print(message, end='', flush=True)
    returncode = Executor.execute(command)
    if returncode == 0:
        message = f'{STATUS.OK} {description}'
    else:
        message = f'{STATUS.ERROR} {description}'
    print(f'\r{message}')


def setKeyMap(keymap: str):
    description = f'Settings keymap to {keymap}'
    command = f'loadkeys {keymap}'
    execute(command, description)


def setTimeProtocol(ntp: bool):
    description = f'Settings NTP to {ntp}'
    command = f'timedatectl set-ntp {ntp}'
    execute(command, description)


def mountLinuxPartition(linux_partition: str):
    description = f'Mounting Linux Partition from {linux_partition}'
    command = f'mount {linux_partition} /mnt'
    execute(command, description)


def mountEfiPartition(efi_partition: str, path: str):
    description = f'Mounting Efi Partition from {efi_partition} to {path}'
    command = f'mkdir -p /mnt{path}; mount {efi_partition} /mnt{path}'
    execute(command, description)


def installPackage(package: str):
    description = f'Installing {package}'
    command = f'pacstrap /mnt {package} --noconfirm'
    execute(command, description)


def generateFstab():
    description = 'Generating fstab'
    command = 'genfstab -U /mnt >> /mnt/etc/fstab'
    execute(command, description)


def copyInstallerInMNT():
    description = 'Copying installer to /mnt'
    command = 'cp -r ../archinstaller /mnt'
    execute(command, description)


def installPyaml():
    description = 'Installing PyYaml'
    command = 'pacstrap /mnt python-yaml'
    execute(command, description)


def chrootAndExecute():
    description = 'Running chroot'
    command = 'arch-chroot /mnt /archinstaller/installer.py /archinstaller/config.yml --chroot' + \
        (' --logerror' if Executor.LOGERROR else '')
    execute(command, description)


def archiso(data):
    partitions = data['partitions']
    boot = data['boot']
    settings = data['settings']
    packages = data['packages']

    # Set keymap
    keymap = settings['keymap']
    setKeyMap(keymap)

    # Set time protocol
    ntp = settings['ntp']
    setTimeProtocol(ntp)

    # Mounting partitions
    linux_partition = partitions['linux']
    efi_partition = partitions['efi']
    efi_directory = boot['efi-directory']
    mountLinuxPartition(linux_partition)
    mountEfiPartition(efi_partition, efi_directory)

    # Installing packages
    for package in packages:
        installPackage(package)

    # Generate fstab
    generateFstab()

    # Copying installer to /mnt
    copyInstallerInMNT()

    # Installing PyYaml
    installPyaml()

    # Chroot and execute
    chrootAndExecute()


def linkTime(region: str, location: str):
    description = f'Linking time to {location}/{region}'
    command = f'ln -sf /usr/share/zoneinfo/{region}/{location} /etc/localtime'
    execute(command, description)


def setHwClock():
    description = 'Setting hwclock'
    command = 'hwclock --systohc'
    execute(command, description)


def addLocale(locale: str):
    description = f'Adding locale {locale}'
    command = f'echo {locale} >> /etc/locale.gen; locale-gen'
    execute(command, description)


def addLang(lang: str):
    description = f'Adding lang {lang}'
    command = f'echo "LANG={lang}" >> /etc/locale.conf'
    execute(command, description)


def addKeyMap(keymap: str):
    description = f'Adding keymap {keymap}'
    command = f'echo "KEYMAP={keymap}" >> /etc/vconsole.conf'
    execute(command, description)


def addHostname(hostname: str):
    description = f'Adding hostname {hostname}'
    command = f'echo "{hostname}" > /etc/hostname'
    execute(command, description)


def setupHosts():
    description = 'Setting up hosts'
    command = 'echo "127.0.0.1 localhost.localdomain localhost" > /etc/hosts'
    execute(command, description)


def mkinit():
    description = 'mkinit'
    command = 'mkinitcpio -P'
    execute(command, description)


def grubInstall(target, efi_directory, bootloader_id):
    description = f'Installing GRUB to {target}'
    command = f'grub-install --target={target} --efi-directory={efi_directory} --bootloader-id={bootloader_id} --recheck'
    execute(command, description)


def mkconfig():
    description = 'mkconfig'
    command = 'grub-mkconfig -o /boot/grub/grub.cfg'
    execute(command, description)


def setPasswForRoot(password: str):
    description = f'Setting root password to {password}'
    command = f'echo "{password}" | passwd root'
    execute(command, description)


def createUser(username: str, password: str):
    description = f'Creating user {username} with password {password}'
    command = f'useradd -m -G wheel -s /bin/bash -p {password} {username}'
    execute(command, description)


def addWheelToSudoers():
    description = 'Adding wheel group to sudoers'
    command = 'echo "%wheel ALL=(ALL) ALL" | EDITOR="tee -a" visudo'
    execute(command, description)


def enableSddm():
    description = 'Enabling sddm'
    command = 'systemctl enable sddm.service'
    execute(command, description)


def enableNetworkManager():
    description = 'Enabling NetworkManager'
    command = 'systemctl enable NetworkManager.service'
    execute(command, description)


def chroot(data):
    partitions = data['partitions']
    boot = data['boot']
    settings = data['settings']
    packages = data['packages']
    accounts = data['accounts']

    # Link time
    region = settings['region']
    location = settings['location']
    linkTime(region, location)

    # Set hwclock
    setHwClock()

    # Add locale
    locale = settings['locale']
    addLocale(locale)

    # Add lang
    lang = settings['lang']
    addLang(lang)

    # Add keymap
    keymap = settings['keymap']
    addKeyMap(keymap)

    # Add hostname
    hostname = settings['hostname']
    addHostname(hostname)

    # Setup hosts
    setupHosts()

    # mkinit
    mkinit()

    # Grub install
    target = boot['target']
    efi_directory = boot['efi-directory']
    bootloader_id = boot['bootloader-id']
    grubInstall(target, efi_directory, bootloader_id)

    # mkconfig
    mkconfig()

    # Set root password
    password = accounts['root-password']
    setPasswForRoot(password)

    # Create user
    username = accounts['username']
    password = accounts['password']
    createUser(username, password)

    # Add wheel to sudoers
    addWheelToSudoers()

    # Enable sddm
    enableSddm()

    # Enable NetworkManager
    enableNetworkManager()


if __name__ == "__main__":
    args = parse_arguments()
    configurationFilePath = args.file
    data = loadYamlFromFile(configurationFilePath)

    if args.logerror:
        Executor.LOGERROR = True

    if args.chroot:
        chroot(data)
    else:
        archiso(data)
