#%load_ext autoreload
#%autoreload 2
import argparse

# =BEGIN SCRIPT ARGUMENTS=

import tqdm
parser = argparse.ArgumentParser()

parser.add_argument('--batch_size', type=int, default=32)

args = parser.parse_args()
notebook = False

# =END SCRIPT ARGUMENTS=

## =BEGIN NOTEBOOK ARGUMENTS=
#
#import tqdm.notebook as tqdm
#args = argparse.Namespace()
#
#args.batch_size = 32
#
#notebook = True
#
## =END NOTEBOOK ARGUMENTS=

print('batch_size:', args.batch_size)
