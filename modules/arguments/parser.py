import argparse


def get_argument_parser():

    parser = argparse.ArgumentParser(
        description='Arch Linux Installer')

    parser.add_argument('file',
                        help='YAML configuration file')

    parser.add_argument('--chroot',  action="store_true",
                        help='Execute the chroot install')

    parser.add_argument('--ultralog',  action="store_true",
                        help='Log everything and execute in the same process')

    parser.add_argument('--logerror',  action="store_true",
                        help='Log errors and warnings')

    return parser


def parse_arguments():
    parser = get_argument_parser()
    args = parser.parse_args()
    return args
