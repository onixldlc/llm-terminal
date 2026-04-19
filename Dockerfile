
FROM node:22-bookworm-slim
 
# deps: git for repos, ripgrep for claude search, curl/ca-certs for net
RUN apt-get update && apt-get install -y --no-install-recommends \
        git \
        ca-certificates \
        curl \
        ripgrep \
        less \
    && rm -rf /var/lib/apt/lists/*
 
# install claude code globally
RUN npm install -g @anthropic-ai/claude-code
 
# node:22-bookworm-slim already has 'node' user at UID 1000.
# reuse it, just rehome to /home/dev for clean mount path.
ENV HOME=/home/dev
RUN usermod -d $HOME -m node \
 && mkdir -p $HOME/work \
 && chown -R node:node $HOME
 
USER node
WORKDIR $HOME/work
 
ENTRYPOINT ["claude"]
