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
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: TextField(
              decoration: MTheme.input,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          const SizedBox(
            height: 80,
            child: SiteList(title: '常用', sites: [
              {'url': 'https://zapper.fi/zh', 'title': "Zapper"}
            ]),
          ),
          const SizedBox(
            height: 200,
            child: SiteList(title: '推荐', sites: [
              {'url': 'https://localcryptos.com', 'title': "LocalCryptos"},
              {
                'url': 'https://unstoppabledomains.com/auth',
                "title": "unstopable"
              }
            ]),
          ),
        ],
      ),
    );
  }
}
