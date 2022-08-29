import 'dart:developer';

import 'package:flutter/material.dart';
import '../../services/web3/models.dart';
import './service/service.dart';

class Pocket extends StatefulWidget {
  const Pocket({Key? key}) : super(key: key);

  @override
  State<Pocket> createState() => _PocketState();
}

class _PocketState extends State<Pocket> {
  WServies wallet = WServies.fromPrivateKey();

  var token = Token(
    address: '0x1a106986c0b44b48a03a30d278a06ae7717f54a8',
    coin: Coin.ethereum,
  );

  @override
  void initState() {
    getBalance();
    super.initState();
  }

  Future getBalance() async {
    var balance =
        await token.balanceOf('0xa4F5c5666D74962D7f52F7Ea7b32eE969Ca59664');
    log('balance : $balance , address : ${wallet.address}');
  }

  Future send() async {
    token.send('0x77daf031e517efcdfe8a3d1b2dd52e33baaadb56', 0.5);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pocket'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Text('Pocket'),
            TextButton(
              onPressed: () {
                getBalance();
              },
              child: Text('Get Balance'),
            ),
            TextButton(
              onPressed: () {
                send();
              },
              child: Text('Send'),
            ),
          ],
        ),
      ),
    );
  }
}
