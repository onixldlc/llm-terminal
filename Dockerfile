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
 
# match host user. pass at build: --build-arg UID=$(id -u) --build-arg GID=$(id -g)
ARG UID=1000
ARG GID=1000
 
# nuke existing 'node' user (UID 1000) to avoid collision, then create 'dev' at host UID
ENV HOME=/home/dev
RUN userdel -r node 2>/dev/null || true \
 && (getent group $GID >/dev/null || groupadd -g $GID dev) \
 && useradd -m -u $UID -g $GID -d $HOME -s /bin/bash dev \
 && mkdir -p $HOME/work \
 && chown -R $UID:$GID $HOME
 
USER dev
WORKDIR $HOME/work
 
ENTRYPOINT ["claude"]
