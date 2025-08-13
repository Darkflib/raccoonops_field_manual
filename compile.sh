# Script to transform the mermaid files into SVG files (in an output folder) and then compile the markdown, images and SVG files into a PDF file and a HTML file.
#!/bin/bash

# Define the output directory
OUTPUT_DIR="output"

# Create the output directory if it doesn't exist
mkdir -p $OUTPUT_DIR

######################### Check Dependencies #########################
# Ensure that mmdc (Mermaid CLI) and pandoc are installed
# Ensure that the output directory is writable
# Ensure that there are markdown files to compile
# Ensure that the output directory is writable
######################################################################

if ! command -v mmdc &> /dev/null; then
    echo "mmdc (Mermaid CLI) could not be found. Please install it to convert mermaid files."
    exit 1
fi
if ! command -v pandoc &> /dev/null; then
    echo "pandoc could not be found. Please install it to compile markdown files."
    exit 1
fi
# Check if the output directory is writable
if [ ! -w "$OUTPUT_DIR" ]; then
    echo "Output directory '$OUTPUT_DIR' is not writable. Please check permissions."
    exit 1
fi
# Check if there are any markdown files to compile
if [ -z "$(ls docs/*.md 2>/dev/null)" ]; then
    echo "No markdown files found to compile."
    exit 1
fi

####################### Convert Mermaid Files to SVG and Compile Markdown Files ##############

# Check if there are any mermaid files to convert
if [ -z "$(ls assets/diagrams/*.mmd 2>/dev/null)" ]; then
    echo "No mermaid files found to convert."
    exit 1
fi

# Convert mermaid files to SVG
for file in assets/diagrams/*.mmd; do
    echo "Converting $file to SVG..."
    mmdc -i "$file" -o "$OUTPUT_DIR/${file%.mmd}.svg"
done

# Compile the markdown files into a PDF based on the book.txt file (allows ordering of the markdown files and appendix separation)
pandoc -s -o "$OUTPUT_DIR/output.pdf" \
    --toc --toc-depth=2 --pdf-engine=xelatex \
    -V documentclass=book \
    -V geometry:a5paper -V geometry:margin=1in \
    -V fontsize=11pt \
    -V mainfont="DejaVu Serif" \
    -V monofont="DejaVu Sans Mono" \
    -V date="$(date +%Y-%m-%d)" assets/cover.tex \
    docs/*.md

## Compile the markdown files into a HTML file
#pandoc -s -o "$OUTPUT_DIR/output.html" \
#    --toc --toc-depth=2 \
#    book.txt docs/*.md

# Copy the generated SVG files to the output directory
cp assets/diagrams/*.svg "$OUTPUT_DIR/"
# Copy the images to the output directory
cp assets/images/* "$OUTPUT_DIR/"


# Notify the user of successful conversion and compilation
echo "Mermaid files converted to SVG and markdown files compiled successfully."
echo "Output files are located in the '$OUTPUT_DIR' directory."