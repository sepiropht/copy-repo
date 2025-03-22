# Copy repo 

A bash utility script that recursively copies file paths and their contents from a specified directory to the clipboard.

## Overview

This script traverses through all files in a given directory (including subdirectories), captures both the file paths and contents, and copies everything to your clipboard in a structured format. This is particularly useful for:

- Sharing code or project structures
- Documentation purposes
- Quickly creating backups of text-based files
- Preparing content for large language models

## Requirements

This script requires one of the following clipboard utilities:

- **macOS**: `pbcopy` (pre-installed)
- **Linux**: `xclip` (may need to be installed)

## Installation

Clone the repo then

```bash
chmod +x script.sh
```

## Usage 

```bash
./script.sh <directory_path>
```

## Output Format

The script formats the clipboard content as follows:

```bash
=== File: path/to/file1.txt ===
[Contents of file1.txt here]

=== End: path/to/file1.txt ===

=== File: path/to/file2.js ===
[Contents of file2.js here]

=== End: path/to/file2.js ===
```


## Features

- Handles both text and binary files (binary files are marked but contents not copied)
- Works cross-platform (macOS and Linux)
- Provides a preview of the copied content
- Shows a count of processed files
- Skips the temporary file created during processing
- Sorts files alphabetically for consistent output
