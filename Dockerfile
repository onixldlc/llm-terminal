FROM node:22-bookworm-slim
 
# base deps
RUN --mount=type=cache,target=/var/cache/apt \
    --mount=type=cache,target=/var/lib/apt/lists \
    apt-get update && apt-get install -y --no-install-recommends \
        ca-certificates ripgrep wget curl less git

# python
RUN --mount=type=cache,target=/var/cache/apt \
    --mount=type=cache,target=/var/lib/apt/lists \
    apt-get update && apt-get install -y --no-install-recommends \
        python3 python3-pip python3-venv python3-dev

# go
ARG GO_VERSION=1.26.2
RUN wget -q https://go.dev/dl/go${GO_VERSION}.linux-amd64.tar.gz \
 && tar -C /usr/local -xzf go${GO_VERSION}.linux-amd64.tar.gz \
 && rm go${GO_VERSION}.linux-amd64.tar.gz

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

ENV PATH="/usr/local/go/bin:$HOME/.cargo/bin:$HOME/go/bin:$PATH"
ENV GOPATH="$HOME/go"

# rust
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs \
  | sh -s -- -y --default-toolchain stable --profile minimal

ENTRYPOINT ["claude"]
