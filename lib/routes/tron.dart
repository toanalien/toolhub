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

final api = Dio(
  BaseOptions(baseUrl: 'https://nile.trongrid.io'),
);

var ownerAddress = 'TYA2pyNP6Xf9VAd7w12P66vFNSSaXvVsQj';
var toAddress = 'TKaUvCJBEEbJX35ZJzuULnvYL8bsXS9aB6';
// var privatekey = 'eda1f4bcb5e6c80cef3d520e5d27cf1195c3f1b829b63dd44b75f2c9d4992ce9';

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
  }

  encode() {
    var token = Token(
      address:
          EthereumAddress.fromHex('0x1A106986C0B44B48A03a30d278a06AE7717f54a8'),
      client: Web3Client(
        "https://nile.trongrid.io/jsonrpc",
        Client(),
      ),
    );

    var parameters = [
      EthereumAddress.fromHex('2ed5dd8a98aea00ae32517742ea5289761b2710e'),
      BigInt.from(50000000000)
    ];
  
    var func = token.self.function('transfer');

    var encode = func.encodeCall(parameters);
    var selector = func.encodeName();
    var str = bytesToHex(encode).substring(2);
    log('selector: $selector');
    log('gen: $str');
    log('tar: 0000000000000000000000002ed5dd8a98aea00ae32517742ea5289761b2710e0000000000000000000000000000000000000000000000000000000000000ba43b7400');
  }

  sendToken() async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign Tron"),
      ),
      body: Center(
        child: TextButton(
          child: Text('ok'),
          onPressed: () {
            encode();
          },
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
