variables {
  feeds = ["0x16655369eb59f3e1cafbcfac6d3dd4001328f747","0xfadad77b3a7e5a84a1f7ded081e785585d4ffaf3","0x3980aa37f838bec2e457445d943feb3af98ff036","0x2d800d93b065ce011af83f316cef9f0d005b0aa4"]
}

spire {

#  feeds     = var.feeds

  # Ethereum key to use for signing messages. The key must be present in the `ethereum` section.
  # This field may be omitted if there is no need to sign messages.
  # Optional.
#  ethereum_key = "default"

  # RPC listen address for the Spire agent. The address must be in the format `host:port`.
  rpc_listen_addr = try(env.CFG_SPIRE_RPC_ADDR, "spire_feed.local:9100")

  # RPC agent address for the Spire agent to connect to. The address must be in the format `host:port`.
  rpc_agent_addr  = try(env.CFG_SPIRE_RPC_ADDR, "spire_feed.local:9100")

  # List of price pairs to be monitored. Only pairs in this list will be available using the "pull" command.
  pairs = [
    "BTCUSD",
    "ETHBTC",
  ]
}

transport {
  # Configuration for the LibP2P transport. LibP2P transport uses peer-to-peer communication.
  # Optional.
  libp2p {
    # List of feed addresses. Only messages signed by these addresses are accepted.
    feeds = var.feeds

    # Seed used to generate the private key for the LibP2P node.
    # Optional. If not specified, the private key is generated randomly.
    priv_key_seed = "d382e2b16d8a2e770dd8e0b65554a2ce7a072ac67d4ca6f34052771dfdcdac07"

    # Listen addresses for the LibP2P node. The addresses are encoded using multiaddr format.
    listen_addrs = ["/ip4/0.0.0.0/tcp/8000"]

    # Addresses of bootstrap nodes. The addresses are encoded using multiaddr format.
    bootstrap_addrs = [
      "/dns/spire-bootstrap1.makerops.services/tcp/8000/p2p/12D3KooWRfYU5FaY9SmJcRD5Ku7c1XMBRqV6oM4nsnGQ1QRakSJi",
      "/dns/spire-bootstrap2.makerops.services/tcp/8000/p2p/12D3KooWBGqjW4LuHUoYZUhbWW1PnDVRUvUEpc4qgWE3Yg9z1MoR"
    ]

    # Addresses of direct peers to connect to. The addresses are encoded using multiaddr format.
    # This option must be configured symmetrically on both ends.
    direct_peers_addrs = []

    # Addresses of peers to block. The addresses are encoded using multiaddr format.
    blocked_addrs = []

    # Disables node discovery. If disabled, the IP address of a node will not be broadcast to other peers. This option
    # should be used together with direct_peers_addrs.
    disable_discovery = false

    # Ethereum key to sign messages that are sent to other nodes. The key must be present in the `ethereum` section.
    # Other nodes only accept messages that are signed by the key that is on the feeds list.
    ethereum_key = "default"
  }
}

ethereum {
  rand_keys = try(env.CFG_ETH_FROM, "") == "" ? ["default"] : []

  dynamic "key" {
    for_each = try(env.CFG_ETH_FROM, "") == "" ? [] : [1]
    labels   = ["default"]
    content {
      address         = try(env.CFG_ETH_FROM, "")
      keystore_path   = try(env.CFG_ETH_KEYS, "")
      passphrase_file = try(env.CFG_ETH_PASS, "")
    }
  }

  client "default" {
    rpc_urls     = try(split(env.CFG_ETH_RPC_URLS, ","), ["https://eth.public-rpc.com"])
    chain_id     = try(parseint(env.CFG_ETH_CHAIN_ID, 10), 1)
    ethereum_key = "default"
  }

  client "arbitrum" {
    rpc_urls     = try(split(env.CFG_ETH_ARB_RPC_URLS, ","), ["https://arbitrum.public-rpc.com"])
    chain_id     = try(parseint(env.CFG_ETH_ARB_CHAIN_ID, 10), 42161)
    ethereum_key = "default"
  }

  client "optimism" {
    rpc_urls     = try(split(env.CFG_ETH_OPT_RPC_URLS, ","), ["https://mainnet.optimism.io"])
    chain_id     = try(parseint(env.CFG_ETH_OPT_CHAIN_ID, 10), 10)
    ethereum_key = "default"
  }
}