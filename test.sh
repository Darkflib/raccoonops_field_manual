#!/bin/bash

### Note: This script won't work on Windows (even git bash) due to the use of `$(pwd)` in the docker command.
# It will work on Linux and MacOS, or you can use WSL on Windows.
docker run --rm -it -v "$(pwd):/data" darkflib/book-compiler \
    pandoc docs/*.md -o output-book.pdf \
    --pdf-engine=xelatex \
    --toc --toc-depth=2 --number-sections --top-level-division=chapter \
    -V documentclass=book \
    -V geometry:a5paper -V geometry:margin=2cm \
    -V fontsize=11pt \
    -V mainfont="DejaVu Serif" \
    -V monofont="DejaVu Sans Mono" \
    -V date="$(date +%Y-%m-%d)" 

# Note: The above command assumes that the Docker image `darkflib/book-compiler` is available.
# If you want to compile the cover separately, you can use the following command:
docker run --rm -it -v "$(pwd):/data" darkflib/book-compiler \
    pandoc assets/cover.md --pdf-engine=xelatex -o output-cover.pdf

# Prepend the cover page to the main document
qpdf cover.pdf --pages output-cover.pdf output-book.pdf -- combined-book.pdf