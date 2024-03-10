#!/bin/bash

# Check for the correct number of arguments
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <path to notebook>"
    exit 1
fi

NOTEBOOK_PATH="$1"
NOTEBOOK_DIR=$(dirname "$NOTEBOOK_PATH")
NOTEBOOK_NAME=$(basename "$NOTEBOOK_PATH" .ipynb)
TXT_PATH="$NOTEBOOK_DIR/$NOTEBOOK_NAME.txt"
PY_SCRIPT_PATH="scripts/$NOTEBOOK_NAME.py"

# Step 1: Convert the notebook to a .txt file
jupyter nbconvert --to script "$NOTEBOOK_PATH"

# Ensure the scripts directory exists
mkdir -p scripts

# Step 2: Move and rename the .txt file to a .py file in the scripts directory
mv "$TXT_PATH" "$PY_SCRIPT_PATH"

# Process the .py script to comment out specific lines
{
in_notebook_args=0

while IFS= read -r line || [[ -n "$line" ]]; do
    # Check for notebook arguments section markers
    if [[ $line == "# =BEGIN NOTEBOOK ARGUMENTS=" ]]; then
        in_notebook_args=1
    fi

    if [[ $in_notebook_args -eq 1 ]]; then
        echo "#$line"
    elif [[ $line =~ ^%.* ]]; then
        # Comment out lines starting with %
        echo "#$line"
    else
        echo "$line"
    fi

    if [[ $line == "# =END NOTEBOOK ARGUMENTS=" ]]; then
        in_notebook_args=0
    fi

done < "$PY_SCRIPT_PATH"
} > "$PY_SCRIPT_PATH.tmp" 

# Replace the original script with the processed one
mv "$PY_SCRIPT_PATH.tmp" "$PY_SCRIPT_PATH"

echo "Conversion and processing completed: $NOTEBOOK_PATH -> $PY_SCRIPT_PATH"
