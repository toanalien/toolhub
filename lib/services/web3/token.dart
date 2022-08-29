import 'dart:developer';

import 'package:web3dart/web3dart.dart';
import './client.dart';
import './token.g.dart' as itoken;
import './coin.dart';

class Token {
  final String address;
  late final Coin coin;
  late final itoken.Token instance;

  Token({
    required this.address,
    required this.coin,
  }) {
    instance =
        itoken.Token(address: EthereumAddress.fromHex(address), client: client);
  }

  Future<String> balanceOf(String address) async {
    final balance = await instance.balanceOf(EthereumAddress.fromHex(address));
    return EtherAmount.inWei(balance)
        .getValueInUnit(EtherUnit.ether)
        .toString();
  }

  Future send(String to, double amount) async {
    final amountWei = BigInt.from(0.5323 * 10e17);

    var amountBig = EtherAmount.fromUnitAndValue(
      EtherUnit.wei,
      amountWei,
    ).getValueInUnitBI(EtherUnit.ether).toString();

    print('amount:  $amountWei $amountBig');

    // var res = await instance.transfer(
    //   EthereumAddress.fromHex('0x77daf031e517efcdfe8a3d1b2dd52e33baaadb56'),
    //   amountBig,
    //   credentials: EthPrivateKey.fromHex(
    //     '755c0a266859b03eab22b2a4800e85766b5c0224da75db06562b806d917d803b',
    //   ),
    // );
    // log('res: $res');
  }
}
