# Omnia

[![Omnia Tests](https://github.com/chronicleprotocol/omnia/actions/workflows/test.yml/badge.svg)](https://github.com/chronicleprotocol/omnia/actions/workflows/test.yml)
[![Build & Push Docker Image](https://github.com/chronicleprotocol/omnia/actions/workflows/docker.yml/badge.svg)](https://github.com/chronicleprotocol/omnia/actions/workflows/docker.yml)

For more information on running oracles see: https://github.com/chronicleprotocol/oracles


# Spire
A peer-to-peer network of nodes for broadcasting signed asset prices over libp2p.


## Quickstart
### Current docker-compose starts an omnia feed container and 2 spire nodes.

- `omnia_feed` uses a static JSON defined in "omnia/exec/source-gofer" for now 
and signs and sends it to `spire_feed` via rpc. 

- `spire_feed` then broadcasts this message over the p2p network (tcp) and `spire_relay` receives it.

First, we need to build spire image, which can be found here -
https://github.com/soodup/oracle-suite/blob/v0.10.0/docker-compose-spire.yaml
(Use Dockerfile-spire)

Then just `docker-compose build` and `docker-compose up -d`



### Omnia Configuration
Current environment variables used are defined in the docker-compose.yml.

Dockerized Omnia default configuration:

| Env Var        | Default value            | Description                        |
|----------------|--------------------------|------------------------------------|
| `OMNIA_CONFIG` | `/home/omnia/omnia.json` | Omnia configuration file           |
| `SPIRE_CONFIG` | `/home/omnia/spire.json` | Spire configuration file           |
| `GOFER_CONFIG` | `/home/omnia/gofer.json` | Gofer configuration file           |
| `ETH_GAS`      | `7000000`                | Gofer configuration file           |


To set custom configuration values use [ENV (environment variables)](https://docs.docker.com/engine/reference/run/#env-environment-variables)

Example:

```bash
$ docker run -e "ETH_GAS=28282828282" -e "OMNIA_INTERVAL=15" ghcr.io/chronicleprotocol/omnia:latest
```

Configuration files might be provided by mounting it into Docker container. 

Example: 

Replacing existing file:

```bash
$ docker run -v $(pwd)/omnia_config.json:/home/omnia/omnia.json ghcr.io/chronicleprotocol/omnia:latest
```

Setting new configuration file:
You will have to rewrite `OMNIA_CONFIG` env var.

```bash
$ docker run -v $(pwd)/omnia_config.json:/home/omnia/omnia_config.json -e OMNIA_CONFIG=/home/omnia/omnia_config.json ghcr.io/chronicleprotocol/omnia:latest
```
