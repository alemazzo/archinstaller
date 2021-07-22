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


def execute(command: str):
    message = f'{STATUS.PROGRESS} {command}'
    print(message, end='', flush=True)
    process = subprocess.Popen(
        command, shell=True, stdout=subprocess.PIPE, stderr=subprocess.DEVNULL)
    process.wait()
    if process.returncode == 0:
        message = f'{STATUS.OK} {command}'
    else:
        message = f'{STATUS.ERROR} {command}'
    print(f'\r{message}')


def setKeyMap(keyMap: str):
    print(f'Settings keymap to {keymap}')
    command = f'loadkeys {keymap}'
    execute(command)

if __name__ == "__main__":
    args = parse_arguments()
    configurationFilePath = args.file
    data = loadYamlFromFile(configurationFilePath)

    partitions = data['partitions']
    boot = data['boot']
    settings = data['settings']
    packages = data['packages']

    keymap = settings['keymap']

    print(f'Packages = {packages}')
