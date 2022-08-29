class Provider {
  final String name;
  final String address;

  const Provider({
    required this.name,
    required this.address,
  });
}

// infura
// ankr
// scanio
// getblock

class Coin {
  final String rpc;

  const Coin({required this.rpc});

  static const Coin ethereum = Coin(
    rpc: "https://rpc.ankr.com/eth_rinkeby",
    // rpc: 'https://rinkeby.infura.io/v3/9aa3d95b3bc440fa88ea12eaa4456161',
  );

  static const Coin bsc = Coin(rpc: 'https://rpc.ankr.com/bsc_testnet_chapel');

  static const Coin trx = Coin(rpc: 'https://rpc.ankr.com/http/tron');
}
