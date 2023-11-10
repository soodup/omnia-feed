pullOracleTime () {
	local _assetPair="$1"
	local _address
	_address=$(getOracleContract "$_assetPair")
	if ! [[ "$_address" =~ ^(0x){1}[0-9a-fA-F]{40}$ ]]; then
		error "Error - Invalid Oracle contract"
		return 1
	fi

	timeout -s9 10 ethereum call "$_address" "age()(uint32)" --rpc-url "$ETH_RPC_URL"
}

pullOracleQuorum () {
	local _assetPair="$1"
	local _address
	_address=$(getOracleContract "$_assetPair")
	if ! [[ "$_address" =~ ^(0x){1}[0-9a-fA-F]{40}$ ]]; then
		error "Error - Invalid Oracle contract"
		return 1
	fi

	timeout -s9 10 ethereum call "$_address" "bar()(uint256)" --rpc-url "$ETH_RPC_URL"
}

pullOraclePrice () {
	local _assetPair="$1"
	local _address
	local _rawStorage
	_address=$(getOracleContract "$_assetPair")
	if ! [[ "$_address" =~ ^(0x){1}[0-9a-fA-F]{40}$ ]]; then
			error "Error - Invalid Oracle contract"
			return 1
	fi

	_rawStorage=$(timeout -s9 10 ethereum storage "$_address" 0x1 --rpc-url "$ETH_RPC_URL")

	[[ "${#_rawStorage}" -ne 66 ]] && error "oracle contract storage query failed" && return

	ethereum --from-wei "$(ethereum --to-dec "${_rawStorage:34:32}")"
}
