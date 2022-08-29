import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart' show Web3Client;
import './coin.dart';

Web3Client client = Web3Client(Coin.ethereum.rpc, Client());
