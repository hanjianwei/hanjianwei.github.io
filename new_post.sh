#!/bin/bash

# Script to create a new blog post with date-based directory structure

# Check if a title was provided
if [ $# -eq 0 ]; then
  echo "Usage: $0 \"Your Post Title\""
  exit 1
fi

# Get the post title from command line argument
title="$1"

# Convert the title to a URL-friendly slug
slug=$(echo "$title" | tr '[:upper:]' '[:lower:]' | tr ' ' '-' | tr -cd 'a-z0-9-')

# Create current date in YYYY-MM-DD format
date=$(date +"%Y-%m-%d")
year=$(date +"%Y")
month=$(date +"%m")
day=$(date +"%d")

# Create the directory for the new post
post_dir="posts/$year/$month/$day/$slug"
mkdir -p "$post_dir"

# Create the index.qmd file with frontmatter
cat > "$post_dir/index.qmd" << EOF
---
title: "$title"
date: "$date"
categories: []
---

Write your post content here.
EOF

echo "Created new post at $post_dir/index.qmd"
echo "Edit it with your favorite editor!" 