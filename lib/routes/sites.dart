import 'package:flutter/material.dart';
import 'package:toolhub/theme.dart';
import '../widgets/site.dart';

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
      backgroundColor: Colors.white,
      body: Column(
        children: <Widget>[
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: TextField(
              decoration: MTheme.input,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          SizedBox(
            height: 200,
            child: SiteList(),
          ),
        ],
      ),
    );
  }
}
