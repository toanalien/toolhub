import 'package:flutter/material.dart';
import 'package:web3dart/web3dart.dart';
import './service/service.dart';

class Pocket extends StatefulWidget {
  const Pocket({Key? key}) : super(key: key);

  @override
  State<Pocket> createState() => _PocketState();
}

class _PocketState extends State<Pocket> {
  WServies wallet = WServies.fromPrivateKey();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Credentials fromHex = EthPrivateKey.fromHex(wallet.pk);
    fromHex.extractAddress().then((value) => print("address: $value"));

    // print('address ${wallet.address}');
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
          ],
        ),
      ),
    );
  }
}
