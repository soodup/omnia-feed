
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

gofer {
  rpc_agent_addr = try(env.CFG_GOFER_RPC_ADDR, "127.0.0.1:9000")
  rpc_listen_addr = try(env.CFG_GOFER_RPC_ADDR, "127.0.0.1:9000")
  origin "openexchangerates" {
    type   = "openexchangerates"
    params = {
      api_key = try(env.GOFER_OPENEXCHANGERATES_API_KEY, "")
    }
  }

  origin "upshot" {
    type   = "upshot"
    params = {
      api_key = "UP-0d9ed54694abdac60fd23b74"
    }
  }

  price_model "ETH/USD" "median" {
    source "ETH/USD" "origin" { origin = "openexchangerates" }
    min_sources = 1
  }

  price_model "cryptopunks/appraisal" "median" {
    source "cryptopunks/appraisal" "origin" { origin = "upshot" }
    min_sources = 1
  }

}