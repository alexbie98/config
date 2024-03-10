Use to start a jupyter notebook on slurm

    $ chmod +x nb.sh
    $ ./nb.sh gpu
    > | URL:
    > http://localhost... # paste into browser
    > | SSH COMMAND:
    > ssh -t -t user@cluster.ai -L... # run in new terminal window

For cpu notebook:

    $ ./nb.sh cpu
    > ...

Thanks to GPT-4 for the helpful script.
