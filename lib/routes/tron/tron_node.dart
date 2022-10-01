import 'dart:convert';
import 'dart:developer';

import 'package:bs58/bs58.dart';
import 'package:hex/hex.dart';
import 'package:web3dart/credentials.dart';
import 'package:web3dart/contracts.dart';
import "package:dio/dio.dart";
import 'package:web3dart/crypto.dart';

final _contractAbi = ContractAbi.fromJson(
    '[{"inputs":[],"stateMutability":"nonpayable","type":"constructor"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"owner","type":"address"},{"indexed":true,"internalType":"address","name":"spender","type":"address"},{"indexed":false,"internalType":"uint256","name":"value","type":"uint256"}],"name":"Approval","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"previousOwner","type":"address"},{"indexed":true,"internalType":"address","name":"newOwner","type":"address"}],"name":"OwnershipTransferred","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"from","type":"address"},{"indexed":true,"internalType":"address","name":"to","type":"address"},{"indexed":false,"internalType":"uint256","name":"value","type":"uint256"}],"name":"Transfer","type":"event"},{"inputs":[],"name":"_decimals","outputs":[{"internalType":"uint8","name":"","type":"uint8"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"_name","outputs":[{"internalType":"string","name":"","type":"string"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"_symbol","outputs":[{"internalType":"string","name":"","type":"string"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"address","name":"owner","type":"address"},{"internalType":"address","name":"spender","type":"address"}],"name":"allowance","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"address","name":"spender","type":"address"},{"internalType":"uint256","name":"amount","type":"uint256"}],"name":"approve","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"address","name":"account","type":"address"}],"name":"balanceOf","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"uint256","name":"amount","type":"uint256"}],"name":"burn","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"nonpayable","type":"function"},{"inputs":[],"name":"decimals","outputs":[{"internalType":"uint8","name":"","type":"uint8"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"address","name":"spender","type":"address"},{"internalType":"uint256","name":"subtractedValue","type":"uint256"}],"name":"decreaseAllowance","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"nonpayable","type":"function"},{"inputs":[],"name":"getOwner","outputs":[{"internalType":"address","name":"","type":"address"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"address","name":"spender","type":"address"},{"internalType":"uint256","name":"addedValue","type":"uint256"}],"name":"increaseAllowance","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"uint256","name":"amount","type":"uint256"}],"name":"mint","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"nonpayable","type":"function"},{"inputs":[],"name":"name","outputs":[{"internalType":"string","name":"","type":"string"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"owner","outputs":[{"internalType":"address","name":"","type":"address"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"renounceOwnership","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[],"name":"symbol","outputs":[{"internalType":"string","name":"","type":"string"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"totalSupply","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"address","name":"recipient","type":"address"},{"internalType":"uint256","name":"amount","type":"uint256"}],"name":"transfer","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"address","name":"sender","type":"address"},{"internalType":"address","name":"recipient","type":"address"},{"internalType":"uint256","name":"amount","type":"uint256"}],"name":"transferFrom","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"address","name":"newOwner","type":"address"}],"name":"transferOwnership","outputs":[],"stateMutability":"nonpayable","type":"function"}]',
    'Token');

final api = Dio(
  BaseOptions(baseUrl: 'https://nile.trongrid.io'),
);

// var ownerAddress = 'TYA2pyNP6Xf9VAd7w12P66vFNSSaXvVsQj';
// var toAddress = 'TKaUvCJBEEbJX35ZJzuULnvYL8bsXS9aB6';

class TronNode {
  final String privateKey;
  final String ownerAddress;

  TronNode({required this.privateKey, required this.ownerAddress});

  signTransaction(String txID) {
    var key = EthPrivateKey.fromHex(privateKey);

    final list = hexToBytes(txID);
    var signed = sign(list, key.privateKey);
    var signature = signatureToString(signed);

    return signature;
  }

  /// 根据sig 生成 signature
  signatureToString(MsgSignature sig) {
    var hr = sig.r.toRadixString(16);
    var hs = sig.s.toRadixString(16);
    var recover = sig.v.toRadixString(16) == '1c' ? 1 : 0;
    return '$hr${hs}0$recover';
  }

  send({required int amount, required String toAddress, String? extra}) async {
    var createPayload = {
      "to_address": getBase58Address(toAddress),
      "owner_address": getBase58Address(ownerAddress),
      "amount": amount,
    };

    if (extra != null) {
      createPayload['extra_data'] = HEX.encode(utf8.encode(extra));
    }

    var transaction =
        await api.post("/wallet/createtransaction", data: createPayload);

    log('transaction: ${transaction.data}');
    var data = transaction.data;
    var payload = data['raw_data'];
    var txID = data['txID'];

    var signature = signTransaction(txID);

    var broadcast = await api.post('/wallet/broadcasttransaction', data: {
      'raw_data': json.encode(payload),
      'txID': txID,
      'signature': [signature]
    });

    log("broadcast: $broadcast");
    return broadcast.data['txID'];
  }

  String encode(String contractAddres, String toAddress, amount) {
    var contract =
        DeployedContract(_contractAbi, EthereumAddress.fromHex(contractAddres.replaceFirst(r'41', '0x')));

    String to = getBase58Address(toAddress);
    var parameters = [
      EthereumAddress.fromHex(to.replaceFirst(r'41', '0x')),
      BigInt.from(amount)
    ];

    var func = contract.function('transfer');
    var encode = func.encodeCall(parameters);
    var str = bytesToHex(encode).replaceAll('a9059cbb', '');

    return str;
  }

  sendToken({required String contractAddres, required String toAddress, required int amount, String? extra}) async {
    // trigger contract
    var contractBase58 = getBase58Address(contractAddres);
    var payload = {
      "owner_address": getBase58Address(ownerAddress),
      "contract_address":contractBase58 ,
      "function_selector": "transfer(address,uint256)",
      "call_value": 0,
      "visible": false,
      'parameter': encode(contractBase58, toAddress, 500000) +
          HEX.encode(utf8.encode(extra ?? ""))
    };

    var response =
        await api.post('/wallet/triggersmartcontract', data: payload);
    var transaction = response.data['transaction'];
    log('transaction: $transaction');

    var node = TronNode(privateKey: privateKey, ownerAddress: ownerAddress);
    var sig = signTransaction(transaction['txID']);
    transaction['signature'] = [sig];

    var send =
        await api.post("/wallet/broadcasttransaction", data: transaction);
    log('send: $send');
  }

  getBase58Address(String hex) {
    // 返回41开头的地址
    var decoded = base58.decode(hex);
    return '41${HEX.encode(decoded).substring(2, 42)}';
  }
}
