Convert a jupyter notebook  `path/name.ipynb` to a runnable script `scripts/name.py`

Does some postprocessing: (1) comments out % lines, as well as (2) sections enclosed by

    # =BEGIN NOTEBOOK ARGUMENTS=
    ...
    args.batch_size = 32
    notebook = True
    ...
    # =END NOTEBOOK ARGUMENTS=

Example

    $ chmod +x nb2script.sh
    $ ./nb2script.sh test.ipynb
    $ python scripts/test.py --batch_size 64

Thanks to GPT-4 for the helpful script.