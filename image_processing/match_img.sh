#!/usr/bin/env bash
# This scripts checks for missing images (channels) in keyence output
# Check if the correct number of arguments is provided
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <directory> <expected_group_size>"
    exit 1
fi

# Directory containing the files
directory="$1"

# Expected number of files in each group
expected_group_size="$2"

# Create an associative array to store file counts for each group
declare -A group_counts

# Loop through all .tif files in the directory
for file in "$directory"/*.tif; do
    # Check if the file exists (in case no .tif files are found)
    [ -e "$file" ] || continue

    # Extract the group identifier (everything before _DAPI, _smmhc, or _yfp)
    group=$(basename "$file" | sed -E 's/_(DAPI|smmhc|yfp)\.tif$//')

    # Increment the count for this group
    ((group_counts[$group]++))
done

# Check each group
for group in "${!group_counts[@]}"; do
    count=${group_counts[$group]}
    if [ "$count" -ne "$expected_group_size" ]; then
        echo "Group $group has $count file(s) instead of $expected_group_size"
    fi
done

# Report if no groups were found
if [ ${#group_counts[@]} -eq 0 ]; then
    echo "No .tif files found in the specified directory."
fi
