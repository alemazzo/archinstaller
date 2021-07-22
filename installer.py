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


def execute(command: str, description: str):
    message = f'{STATUS.PROGRESS} {description}'
    print(message, end='', flush=True)
    process = subprocess.Popen(
        command, shell=True, stdout=subprocess.PIPE)
    process.wait()
    if process.returncode == 0:
        message = f'{STATUS.OK} {description}'
    else:
        message = f'{STATUS.ERROR} {description}'
    print(f'\r{message}')


def setKeyMap(keyMap: str):
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
    description = f'Mounting Efi Partition from {linux_partition} to {path}'
    command = f'mkdir -p /mnt{path}; mount {efi_partition} /mnt{path}'
    execute(command, description)


def installPackage(package: str):
    description = f'Installing {package}'
    command = f'pacstrap /mnt {package}'
    execute(command, description)


if __name__ == "__main__":
    args = parse_arguments()
    configurationFilePath = args.file
    data = loadYamlFromFile(configurationFilePath)

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
