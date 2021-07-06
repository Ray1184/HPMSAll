"""
HPMS batch manager.

"""
import argparse
import sys
import os
import shutil
import datetime
import hpms_project_builder
import hpms_utils as utils


class Batch:
    @staticmethod
    def parse_params():
        argv = sys.argv

        if '--' not in argv:
            argv = []
        else:
            argv = argv[argv.index('--') + 1:]

        usage_text = (
                'Run HPMS project builder with this script:'
                '  blender --background --python ' + __file__ + ' -- [options]'
        )

        parser = argparse.ArgumentParser(description=usage_text)

        parser.add_argument(
            '-v', '--logging-level', dest='logging',
            help='Setting logging level (severe if not specified)',
        )

        parser.add_argument(
            '-o', '--output', dest='output_path', metavar='FILE',
            help='Generate HPMS into specified output path',
        )

        parser.add_argument(
            '-c', '--cleanup', dest='cleanup',
            help='Cleanup the output directory (update otherwise)',
        )

        parser.add_argument(
            '-r', '--render', dest='render',
            help='Render missing screens and masks',
        )

        parser.add_argument(
            '-l', '--roomupdate-list', dest='room_update_list',
            help='Force update for rooms in given list (comma separated)',
        )

        parser.add_argument(
            '-a', '--roomupdate-all', dest='roomupdate_all',
            help='Force update for all rooms',
        )

        parser.add_argument(
            '-p', '--preview', dest='preview',
            help='Improve rendering speed with only 16 samples',
        )

        args = parser.parse_args(argv)

        if not argv:
            raise Exception('All parameters are missing')

        if not args.output_path:
            raise Exception('Parameter \'--outputpath\' is missing, aborting')

        return args

    def __init__(self):
        args = self.parse_params()
        self.output_path = args.output_path
        self.cleanup = args.cleanup is not None and args.cleanup.lower() in ["t", "true", "y", "yes"]
        self.update_all = args.roomupdate_all is not None and args.roomupdate_all.lower() in ["t", "true", "y", "yes"]
        self.do_render = args.render is not None and args.render.lower() in ["t", "true", "y", "yes"]
        self.preview = args.preview is not None and args.preview.lower() in ["t", "true", "y", "yes"]
        self.room_update_list = []
        if args.room_update_list is not None:
            self.room_update_list = args.room_update_list.split(",")

    def backup(self):
        today = str(datetime.datetime.today().strftime('%Y%m%d%H%M%S'))
        bak_scripts_path = self.output_path + "_" + today
        shutil.make_archive(bak_scripts_path, 'zip', self.output_path)
        utils.info('Created backup ' + bak_scripts_path)

    def unzip_templates(self):
        shutil.unpack_archive(utils.get_current_dir() + "/templates/data.zip", self.output_path, 'zip')

    def create_empty_project(self):
        if os.path.isdir(self.output_path):
            shutil.rmtree(self.output_path, ignore_errors=True)
        os.makedirs(self.output_path)
        self.unzip_templates()
        utils.info('Created new project from template')

    def check_project(self):
        if not os.path.isdir(self.output_path) or self.cleanup:
            utils.info('Creating empty project...')
            self.create_empty_project()
        else:
            utils.info('Creating backup...')
            self.backup()

    def run(self):
        self.check_project()
        builder = hpms_project_builder.ProjectBuilder(self.output_path, self.room_update_list, self.update_all, self.do_render, self.preview)
        utils.info('Preparing build...')
        builder.build()
        utils.info('Build done')




