import 'package:flutter/material.dart';

class SitesPage extends StatefulWidget {
  const SitesPage({Key? key}) : super(key: key);

  @override
  State<SitesPage> createState() => _SitesPageState();
}

class _SitesPageState extends State<SitesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('站点')),
      body: Column(
        children: <Widget>[
          Center(
            child: Text('站点'),
          ),
        ],
      ),
    );
  }
}
