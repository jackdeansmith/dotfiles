# Golden image for Fly.io dev boxes
#
# Build:
#   docker build -t devbox .
#
# Run locally:
#   docker run -it devbox
#
# Deploy to Fly:
#   fly machine run devbox --shell
#   # or add to fly.toml for persistent dev machines

FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    git \
    neovim \
    fzf \
    zsh \
    ripgrep \
    tmux \
    curl \
    wget \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Create dev user
RUN useradd -m -s /usr/bin/zsh dev
USER dev
WORKDIR /home/dev

# Clone dotfiles and install
RUN git clone https://github.com/jackdeansmith/dotfiles.git /home/dev/src/dotfiles \
    && /home/dev/src/dotfiles/install.sh

CMD ["zsh"]
