#!/bin/bash

# Function to display usage
usage() {
    echo "Usage: $0 <directory_path>"
    echo "Copies all file paths and their content from the specified directory recursively to clipboard"
    exit 1
}

# Function to check if required commands exist
check_dependencies() {
    if ! command -v xclip &> /dev/null && ! command -v pbcopy &> /dev/null; then
        echo "Error: Neither xclip (Linux) nor pbcopy (macOS) found."
        echo "Please install xclip (Linux) or use macOS for pbcopy"
        exit 1
    fi
}

# Function to copy to clipboard based on OS
copy_to_clipboard() {
    if [[ "$(uname)" == "Darwin" ]]; then
        # macOS
        pbcopy
    else
        # Linux
        xclip -selection clipboard
    fi
}

# Check if directory argument is provided
if [ $# -ne 1 ]; then
    usage
fi

# Check if dependencies are installed
check_dependencies

# Check if directory exists
if [ ! -d "$1" ]; then
    echo "Error: '$1' is not a valid directory"
    exit 1
fi

# Get absolute path of directory and cd into it
cd "$1" || exit 1

# Create temporary file for output
temp_file=$(mktemp)

# Find all files recursively and process each one
while IFS= read -r file; do
    # Skip the temporary file itself
    if [[ "$file" == "$temp_file" ]]; then
        continue
    fi

    # Get relative path by removing './' prefix
    relative_path=${file#./}
    
    # Print file separator and path
    echo "=== File: $relative_path ===" >> "$temp_file"
    
    # Check if file is binary
    if file "$file" | grep -q "text"; then
        # Print file content for text files
        cat "$file" >> "$temp_file"
    else
        echo "[Binary file - content not shown]" >> "$temp_file"
    fi
    
    # Add separator after file
    echo -e "\n=== End: $relative_path ===\n" >> "$temp_file"
    
done < <(find . -type f | sort)

# Check if any files were found
if [ ! -s "$temp_file" ]; then
    echo "No files found in directory"
    rm "$temp_file"
    exit 0
fi

# Copy to clipboard and count files
cat "$temp_file" | copy_to_clipboard
file_count=$(find . -type f | wc -l)
echo "Successfully copied $file_count files (paths and content) to clipboard"

# Preview the first few lines
echo -e "\nPreview of first few lines:"
head -n 10 "$temp_file"
echo "..."

# Cleanup
rm "$temp_file"
