import argparse


def get_argument_parser():

    parser = argparse.ArgumentParser(
        description='Arch Linux Installer')

    parser.add_argument('file',
                        help='YAML configuration file')

    parser.add_argument('--tasks',  action="store_true",
                        help='Print available tasks')

    parser.add_argument('--apptypes',  action="store_true",
                        help='Print available application types')

    parser.add_argument('-t', '--task',
                        help='Task to execute ([all] for executing all tasks)')

    parser.add_argument('-at', '--apptype',
                        help='Application type ([all] for all application types)')

    parser.add_argument('-a', '--app',
                        help='Application to install ([all] for executing all application types)')

    return parser


def parse_arguments():
    parser = get_argument_parser()
    args = parser.parse_args()
    return args
