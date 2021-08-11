"""
HPMS main entry point.

"""

import os
import shutil
import sys
import datetime
import hpms_batch
import hpms_utils as utils


def main():
    try:
        starting = datetime.datetime.now()
        utils.system('HPMS Batch started')
        batch = hpms_batch.Batch()
        batch.run()
        ending = datetime.datetime.now() - starting
        utils.system('HPMS Batch finished in ' + str(ending.total_seconds()) + ' seconds')
    except Exception as e:
        utils.severe('Unexpected error: ' + str(e))
        utils.system('HPMS Batch aborted')
    pass


if __name__ == '__main__':
    main()
