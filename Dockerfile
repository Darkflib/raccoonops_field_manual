      
# Dockerfile for Pandoc, XeTeX, and Mermaid CLI on Debian

# Use a recent stable Debian image
FROM debian:bookworm-slim

# Set environment variables (optional but good practice for non-interactive installs)
ENV DEBIAN_FRONTEND=noninteractive

# Update apt, install necessary packages, and clean up
RUN apt update && apt upgrade -y && \
    apt install -y \
    # Core build tools and utilities (optional, but sometimes useful)
    build-essential \
    git \
    wget \
    ca-certificates \
    # Pandoc itself
    pandoc \
    # TeX Live for XeTeX (required for PDF output via Pandoc)
    # This set provides a good balance for most use cases without being texlive-full (which is huge)
    # TeX Live base packages
    texlive-xetex \
    texlive-latex-extra \
    texlive-fonts-recommended \
    texlive-pictures \
    texlive-bibtex-extra \
    # Base fonts for general LaTeX use
    fonts-recommended \
    # Node.js and npm for Mermaid CLI
    nodejs \
    npm \
    # Chromium is required by mmdc (Mermaid CLI) to render diagrams
    chromium \
    qpdf \
    # Clean up APT cache to reduce image size
    && apt autoremove -y \
    && apt clean \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /tmp/* /var/tmp/*

# Install Mermaid CLI globally using npm
# The --unsafe-perm is often needed when installing global packages with npm as root
# The --no-sandbox is often needed when running mmdc (Chromium) inside Docker
RUN npm install -g @mermaid-js/mermaid-cli --unsafe-perm=true --allow-root

# Set a working directory for convenience
WORKDIR /data

# Default command if no other command is specified.
# This makes it easy to drop into a shell, or you can override it with your commands.
CMD ["bash"]

# You can add labels for metadata (optional)
LABEL maintainer="Your Name <your.email@example.com>"
LABEL description="Debian container with Pandoc, XeTeX, and Mermaid CLI for Markdown to PDF conversion."

# Example of how to use this container:
# Build: docker build -t markdown-pdf-converter .
# Run (to convert a markdown file to PDF):
# docker run --rm -v "$(pwd):/data" markdown-pdf-converter \
#     pandoc your_document.md -o your_document.pdf \
#     --pdf-engine=xelatex \
#     --template=eisvogel # (example, you'd need to add this template if you want it)

# Run (to convert a Mermaid file to PNG/SVG):
# docker run --rm -v "$(pwd):/data" markdown-pdf-converter \
#     mmdc -i input.mermaid -o output.png

# Run (interactive shell):
# docker run -it --rm -v "$(pwd):/data" markdown-pdf-converter bash

# Note: You may want to add additional TeX Live packages depending on your specific needs.
# For example, if you need specific fonts or packages, you can add them to the apt install line.
# You can also add more tools or configurations as needed.
