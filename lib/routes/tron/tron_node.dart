import 'dart:convert';
import 'dart:developer';

import 'package:bs58/bs58.dart';
import 'package:flutter/material.dart';
import 'package:hex/hex.dart';
import 'package:web3dart/credentials.dart';
import 'package:web3dart/crypto.dart' as crypto;
// import 'package:elliptic/elliptic.dart';
import "package:dio/dio.dart";

final api = Dio(
  BaseOptions(baseUrl: 'https://nile.trongrid.io'),
);

// var ownerAddress = 'TYA2pyNP6Xf9VAd7w12P66vFNSSaXvVsQj';
var toAddress = 'TKaUvCJBEEbJX35ZJzuULnvYL8bsXS9aB6';

class TronNode {
  // var privatekey = 'eda1f4bcb5e6c80cef3d520e5d27cf1195c3f1b829b63dd44b75f2c9d4992ce9';
  final String privateKey;
  final String ownerAddress;

  TronNode({required this.privateKey, required this.ownerAddress});

  sign(String txID) async {
    var key = EthPrivateKey.fromHex(privateKey);

    final list = crypto.hexToBytes(txID);
    var signed = crypto.sign(list, key.privateKey);
    var signature = signatureToString(signed);

    return signature;
  }

  /// 根据sig 生成 signature
  signatureToString(crypto.MsgSignature sig) {
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

  getBase58Address(String hex) {
    // 返回41开头的地址
    var decoded = base58.decode(hex);
    return '41${HEX.encode(decoded).substring(2, 42)}';
  }
}
