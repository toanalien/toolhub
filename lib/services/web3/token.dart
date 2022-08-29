import 'package:web3dart/web3dart.dart';
import './client.dart';
import './token.g.dart' as itoken;

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

class Token {
  final String address;
  late final Coin coin;
  late final itoken.Token token;

  Token({
    required this.address,
  }) {
    token =
        itoken.Token(address: EthereumAddress.fromHex(address), client: client);
  }

  Future<String> balanceOf(String address) async {
    final balance = await token.balanceOf(EthereumAddress.fromHex(address));
    return balance.toString();
  }
}
