import 'package:ens_dart/ens_dart.dart';
import 'package:http/http.dart';
import 'package:web3dart/credentials.dart';
import 'package:web3dart/crypto.dart';
import 'package:web3dart/web3dart.dart' show Web3Client;
import 'package:convert/convert.dart';
import 'package:trust_wallet_core_lib/trust_wallet_core_lib.dart';

const String privateKey =
    'a2fd51b96dc55aeb14b30d55a6b3121c7b9c599500c1beb92a389c3377adc86e';
const String rpcUrl =
    'https://rinkeby.infura.io/v3/9aa3d95b3bc440fa88ea12eaa4456161';

enum IToken { ethereum }

const tokenTypes = {
  'ethereum': 60,
};

const ethereum = 60;

class WServies {
  late String name;
  late String address;
  late String amount;
  late String pk;

  static Web3Client client = Web3Client(rpcUrl, Client());

  WServies(this.name, this.pk, this.amount);

  WServies.fromPrivateKey() {
    var key = const String.fromEnvironment('PRIVATE_KEY',
        defaultValue:
            '755c0a266859b03eab22b2a4800e85766b5c0224da75db06562b806d917d803b');
    // List<int> data = hex.decode(key);
    var data = hexToBytes(key);
    // 创建有误， 需要修改
    var wallet = HDWallet.createWithData(data);
    // wallet.getAddressForCoin(60);
    address = wallet.getAddressForCoin(ethereum);

    pk = key;
    name = 'name';
    amount = '0';
  }
}
