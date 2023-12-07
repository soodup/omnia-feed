# Omnia
An oracle client written in bash. It has 2 services feed and relay.

This repository only has the code for omnia feed service.

Feed service will pull prices from Gofer, sign with private key and publish to the p2p transport layer (spire) 

To deploy relay, please go to https://github.com/soodup/omnia-relay

## Quickstart


```
docker-compose up
docker-compose -f docker-compose.yml exec -d omnia_feed sh -c "gofer agent -c '/home/omnia/gofer.hcl'"
docker-compose -f docker-compose.yml exec -d omnia_feed sh -c "spire agent -c '/home/omnia/spire.hcl'"
```

## Config and Deployment

### Config

1) Set the “interval” cron duration (seconds) in `omnia/config/feed.json` that omnia feed service will check for new price updates and publish to the p2p spire network.

For example,
```json
"options": {
    "interval": 60
   }
```
2) Set the supported feed pairs in `omnia/config/feed.json` and `omnia/docker/spire/config/feed_config.hcl` for whitelisting in spire (p2p network)

For example,
```json
  "pairs": {
    "cryptopunks/appraisal":{"msgExpiration":300,"msgSpread":0.5}
  }
```
```hcl
spire {
  # List of pairs that are collected by the spire node. Other pairs are ignored.
  pairs = [
    "cryptopunksappraisal"
  ]
}
```
3) Set the “origin” and “price_model” in gofer config `omnia/docker/gofer/client.hcl` to fetch data for the above feeds.

For example,
```hcl
gofer {
  origin "upshot" {
    type   = "upshot"
    params = {
      api_key = try(env.GOFER_UPSHOT_API_KEY, "UP-0d9ed54694abdac60fd23b74")
    }
  }

  price_model "cryptopunks/appraisal" "median" {
    source "cryptopunks/appraisal" "origin" { origin = "upshot" }
    min_sources = 1
  }

}
```

4) Set the wallet address and password that will be used to sign the messages in `omnia/config/feed.json`
Test wallet keystore and password are present in `omnia/docker/keystore/1.json` and `omnia/docker/keystore/pass`.

For example, 
```json
  "mode": "feed",
  "ethereum": {
    "from": "0x2d800d93b065ce011af83f316cef9f0d005b0aa4",
    "keystore": "/home/omnia/.ethereum/keystore",
    "password": "/home/omnia/.ethereum/keystore/pass"
  }
```


5) Also set the same in env variables `CFG_ETH_FROM`, `CFG_ETH_KEYS`, `CFG_ETH_PASS` in `omnia/docker-compose.yml`.

For example,
```yaml
services:
  omnia_feed:
    image: upshot-omnia-feed
    environment:
      CFG_ETH_FROM: "0x2d800d93b065ce011af83f316cef9f0d005b0aa4"
      CFG_ETH_KEYS: "/home/omnia/.ethereum/keystore"
      CFG_ETH_PASS: "/home/omnia/.ethereum/keystore/pass"
```

### Deployment
- Run Docker compose file `omnia/docker-compose.yml` to start omnia feed service.
- Run `docker-compose -f docker-compose.yml exec -d omnia_feed sh -c "gofer agent -c '/home/omnia/gofer.hcl'”` to start gofer agent process.
- Run `docker-compose -f docker-compose.yml exec -d omnia_feed sh -c "spire agent -c '/home/omnia/spire.hcl'”` to start spire agent process.
---
More config details can be found here - `omnia/README-omnia-dev.md`