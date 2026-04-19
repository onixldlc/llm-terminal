FROM node:22-bookworm-slim

RUN apt-get update && apt-get install -y --no-install-recommends \
    git ca-certificates curl ripgrep \
 && rm -rf /var/lib/apt/lists/*

RUN npm install -g @anthropic-ai/claude-code

ENV HOME=/home/dev
RUN useradd -m -u 1000 -d $HOME -s /bin/bash dev
USER dev
WORKDIR $HOME

ENTRYPOINT ["claude"]
