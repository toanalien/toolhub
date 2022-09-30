import 'dart:convert';
import 'dart:developer';

import 'package:bs58/bs58.dart';
import 'package:flutter/material.dart';
import 'package:hex/hex.dart';
import 'package:web3dart/credentials.dart';
import 'package:web3dart/crypto.dart' as crypto;
import "package:dio/dio.dart";

final api = Dio(
  BaseOptions(baseUrl: 'https://nile.trongrid.io'),
);

var ownerAddress = 'TYA2pyNP6Xf9VAd7w12P66vFNSSaXvVsQj';
var toAddress = 'TKaUvCJBEEbJX35ZJzuULnvYL8bsXS9aB6';

class TronTransactionPage extends StatefulWidget {
  const TronTransactionPage({super.key});

  @override
  State<TronTransactionPage> createState() => _TronTransactionPageState();
}

class _TronTransactionPageState extends State<TronTransactionPage> {
  @override
  void initState() {
    super.initState();
    // target "3c405447532332565844484c453543465f325f3078346236396633633462343161356138636638613435306364336232613338373161333362343237353564623862646565626331393337373763646665336139645f6d73673e"
    // 编码方法
    String data =
        '<@TGS#2VXDHLE5CF_2_0x4b69f3c4b41a5a8cf8a450cd3b2a3871a33b42755db8bdeebc193777cdfe3a9d_msg>';

    // hexToBytes(hex)
    // var res = utf8.decode(HEX.decode(data));
    var res = HEX.encode(utf8.encode(data));
    // print("res: $res");
    send(100000);
  }

  var privatekey = 'eda1f4bcb5e6c80cef3d520e5d27cf1195c3f1b829b63dd44b75f2c9d4992ce9';

  sign(String txID) async {
    var test = EthPrivateKey.fromHex(privatekey);

    final list = crypto.hexToBytes(txID);
    var signed = crypto.sign(list, test.privateKey);
    var signature = signatureToString(signed);

    return signature;
  }

  signatureToString(crypto.MsgSignature sig) {
    var hr = sig.r.toRadixString(16);
    var hs = sig.s.toRadixString(16);
    var recover = sig.v.toRadixString(16) == '1c' ? 1 : 0;
    return '$hr${hs}0$recover';
  }

  String get memo {
    var gid = '@TGS#2VXDHLE5CF';
    var quantity = 2;
    var cover = 'aaa';
    var hash =
        "668eaa1d6ce27a9bb8f36cf008f91a6f55a5567ca231dc9b3ce8d5e51d3fd3c2";
    var memo = '<${gid}_${quantity}_${hash}_$cover>';
    return memo;
  }

  send(int amount) async {
    var transaction = await api.post("/wallet/createtransaction", data: {
      "to_address": getBase58Address(toAddress),
      "owner_address": getBase58Address(ownerAddress),
      "amount": amount,
      'extra_data': HEX.encode(utf8.encode(memo))
    });

    log('transaction: ${transaction.data}');
    var data = transaction.data;
    var payload = data['raw_data'];
    var txID = data['txID'];

    var signature = await sign(txID);

    var broadcast = await api.post('/wallet/broadcasttransaction', data: {
      'raw_data': json.encode(payload),
      'txID': txID,
      'signature': [signature]
    });

    log("broadcast: $broadcast");
    return broadcast.data['txID'];
  }

  sendToken() async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text("Sign Tron")));
  }

  getBase58Address(String hex) {
    // 返回41开头的地址
    var decoded = base58.decode(hex);
    return '41${HEX.encode(decoded).substring(2, 42)}';
  }
}
