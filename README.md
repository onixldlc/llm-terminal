# llm-terminal
a simple dockerized claude code for ease of use whilst still isolated from the entire machine

## usage
to use just run the docker image like so:
```bash
docker run -it --rm \
  -v "$PWD/config":/home/dev \
  -v "$PWD":/home/dev/work \
  -w /home/dev/work \
  llm-terminal
```

