import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:toolhub/navigator.dart';
import 'package:toolhub/routes/crypto/home.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Toolhub',
        ),
      ),
      body: Wrap(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: IconButton(
              onPressed: () {
                MNavigator.push(context, (ctx, arguments) => const Pocket());
              },
              icon: Icon(Icons.wallet),
            ),
          )
        ],
      ),
    );
  }
}
