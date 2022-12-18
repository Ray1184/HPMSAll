"""
HPMS resources deploy module.
"""

import argparse
import os
import ntpath
import shutil
import sys


def echo(msg):
    print('-- ' + str(msg))


def add_resource(res, resources, bin_path):
    res_name = ntpath.basename(res).capitalize()
    entry = 'Zip=data/packs/' + res_name + '.zip'
    resources.append(entry)
    shutil.make_archive(bin_path + '/bin/rt/data/packs/' + res_name, 'zip', res)
    os.rename(bin_path + '/bin/rt/data/packs/' + res_name + '.zip', bin_path + '/bin/rt/data/packs/' + res_name + '.zip')
    echo('Adding ' + res + ' to data/packs/' + res_name + '.zip')


def deploy():
    echo('Resource deploy started.')

    parser = argparse.ArgumentParser(description='HPMS deploy args')
    parser.add_argument('paths', metavar='N', type=str,
                        nargs='+', help='Deploy paths')

    args = parser.parse_args()

    src_path = args.paths[0]
    bin_path = args.paths[1]

    echo('Source path: ' + src_path)
    echo('Binary path: ' + bin_path)

    # Collect each folder in resources and zip
    resources = [f.path for f in os.scandir(
        src_path + '/resources') if f.is_dir()]
    res_entries = ['# HPMS Resources', '[General]']
    for res in resources:
        add_resource(res, res_entries, bin_path)

    res_ini = bin_path + '/bin/rt/data/resources.ini'
    if os.path.exists(res_ini):
        os.remove(res_ini)
    with open(res_ini, 'w') as f:
        for res_entry in res_entries:
            f.write(res_entry)
            f.write('\n')
        f.write('\n')
    echo('Resource deploy finished')


try:
    deploy()
    sys.exit(0)
except Exception as e:
    echo(str(e))
    sys.exit(1)
