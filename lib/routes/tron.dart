import 'dart:convert';
import 'dart:developer';

import 'package:bs58/bs58.dart';
import 'package:flutter/material.dart';
import 'package:hex/hex.dart';
import 'package:http/http.dart';
import 'package:web3dart/credentials.dart';
import 'package:web3dart/crypto.dart' as crypto;
import "package:dio/dio.dart";
import 'package:web3dart/crypto.dart';
import 'package:web3dart/web3dart.dart';
import "./tron/token.g.dart";
import './tron/tron_node.dart';

final api = Dio(
  BaseOptions(baseUrl: 'https://nile.trongrid.io'),
);

var ownerAddress = 'TYA2pyNP6Xf9VAd7w12P66vFNSSaXvVsQj';
var toAddress = 'TKaUvCJBEEbJX35ZJzuULnvYL8bsXS9aB6';
var privatekey = 'eda1f4bcb5e6c80cef3d520e5d27cf1195c3f1b829b63dd44b75f2c9d4992ce9';

class TronTransactionPage extends StatefulWidget {
  const TronTransactionPage({super.key});

  @override
  State<TronTransactionPage> createState() => _TronTransactionPageState();
}

class _TronTransactionPageState extends State<TronTransactionPage> {
  @override
  void initState() {
    super.initState();
    // print("res: $res");
    // encode();
    sendToken();
  }

  String contractAddres = 'TXLAQ63Xg1NAzckPwKHvzw7CSEmLMEqcdj';
  String ownerAddress = 'TYA2pyNP6Xf9VAd7w12P66vFNSSaXvVsQj';
  String toAddress = 'TKaUvCJBEEbJX35ZJzuULnvYL8bsXS9aB6';

  String encode() {
    var token = Token(
      address:
          EthereumAddress.fromHex('0x1A106986C0B44B48A03a30d278a06AE7717f54a8'),
      client: Web3Client(
        "https://nile.trongrid.io/jsonrpc",
        Client(),
      ),
    );
    String co = getBase58Address(contractAddres);
    log('co: $co');
    String from = getBase58Address(ownerAddress);
    log('fr $from');
    String to = getBase58Address(toAddress);
    log('to: $to');
    var parameters = [
      EthereumAddress.fromHex(to.replaceFirst(r'41', '0x')),
      BigInt.from(50000000000)
    ];

    var func = token.self.function('transfer');

    var encode = func.encodeCall(parameters);
    var selector = func.encodeName();
    var str = bytesToHex(encode).replaceAll('a9059cbb', '');
    // utf8.encode
    log('selector: ${bytesToHex(utf8.encode('transfer'))} $selector');
    log('gen: $str');
    log('tar: 0000000000000000000000006964fa12b2a9f542e4eaf382416862824c1f72800000000000000000000000000000000000000000000000000000000ba43b7400');

    return str;
  }

  sendToken() async {
    // trigger contract
    var payload = {
      "owner_address": getBase58Address(ownerAddress),
      "contract_address": getBase58Address(contractAddres),
      "function_selector": "transfer(address,uint256)",
      "call_value": 0,
      "visible": false,
      'parameter': encode() + HEX.encode(utf8.encode('test')) 
    };

    var response = await api.post('/wallet/triggersmartcontract', data: payload);
    var transaction = response.data['transaction'];
    log('transaction: $transaction');

    var node = TronNode(privateKey: privatekey, ownerAddress: ownerAddress);
    var sig = node.sign(transaction['txID']);
    transaction['signature'] = [sig];

    var send = await api.post("/wallet/broadcasttransaction", data: transaction);
    log('send: $send');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign Tron"),
      ),
      body: Center(
        child: Column(
          children: [
            TextButton(
              child: Text('ok'),
              onPressed: () {
                sendToken();

              },
            ),
            TextButton(
              child: Text('Send'),
              onPressed: () {
                sendToken();
              },
            ),
          ],
        ),
      ),
    );
  }

  getBase58Address(String hex) {
    // 返回41开头的地址
    var decoded = base58.decode(hex);
    return '41${HEX.encode(decoded).substring(2, 42)}';
  }
}
