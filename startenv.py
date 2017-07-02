#!/usr/bin/env python

from __future__ import absolute_import, division, print_function

import argparse
import subprocess
import sys


class HelpOnFailArgumentParser(argparse.ArgumentParser):
    """
    Prints help whenever the command-line arguments could not be parsed.
    """

    def error(self, message):
        sys.stderr.write('error: %s\n\n' % message)
        self.print_help()
        sys.exit(2)


def parse_command_line_args(args):
    """
    Parse command-line arguments and organize them into a single structured object.
    """
    parser = HelpOnFailArgumentParser(
        formatter_class=argparse.RawTextHelpFormatter,
        epilog='Example: startenv.py ~/my-notebooks\n'
               'Example: startenv.py --jupyter-host-port 8989 --docker-args "--memory 3g" ~/my-notebooks'
    )

    parser.add_argument(
        'data_dir',
        type=str,
        help='Local data/code directory to mount inside the container.'
    )
    parser.add_argument(
        '--jupyter-host-port',
        required=False,
        default=8888,
        help='The host port to use for Jupyter server',
    )
    parser.add_argument(
        '--ssh-host-port',
        required=False,
        default=2222,
        help='The host port to use for SSH access to the container.',
    )
    parser.add_argument(
        '--docker-args',
        required=False,
        default='',
        help='Additional arguments to pass to "docker run".',
    )

    # Try parsing the arguments and fail properly if that didn't succeed.
    parsed_args = parser.parse_args(args)
    if parsed_args.data_dir is None:
        parser.print_help()
        sys.exit(2)

    return parsed_args


def main():
    args = parse_command_line_args(sys.argv[1:])
    docker_cmdline = 'docker run -it --rm ' \
                     '-p {ssh_host_port}:22 -p {jupyter_host_port}:8888 ' \
                     '-v "{data_dir}":/mnt/data ' \
                     '{docker_args} ' \
                     'yuriyguts/ucu-nlp-workshop ' \
                     '/sbin/my_init -- jupyter notebook --allow-root'
    docker_cmdline = docker_cmdline.format(
        ssh_host_port=args.ssh_host_port,
        jupyter_host_port=args.jupyter_host_port,
        data_dir=args.data_dir,
        docker_args=args.docker_args,
    )

    print('-' * 75)
    print('Running command:')
    print(docker_cmdline)
    print('-' * 75)

    subprocess.call(docker_cmdline, shell=True)


if __name__ == '__main__':
    main()
