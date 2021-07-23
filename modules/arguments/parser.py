import argparse


def get_argument_parser():

    parser = argparse.ArgumentParser(
        description='Arch Linux Installer')

    parser.add_argument('file',
                        help='YAML configuration file')

    parser.add_argument('--chroot',  action="store_true",
                        help='Execute the chroot install')

    return parser


def parse_arguments():
    parser = get_argument_parser()
    args = parser.parse_args()
    return args
