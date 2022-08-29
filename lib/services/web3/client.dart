import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart' show Web3Client;

const String rpcUrl =
    'https://rinkeby.infura.io/v3/9aa3d95b3bc440fa88ea12eaa4456161';
Web3Client client = Web3Client(rpcUrl, Client());
