import 'package:flutter/material.dart';
import '../routes/browser.dart';
import '../navigator.dart';

class SiteWidget extends StatelessWidget {
  const SiteWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Image(image: NetworkImage("")),
        Container(
          width: 20,
          height: 20,
        ),
        Text('123'),
      ],
    );
  }
}

class SiteList extends StatelessWidget {
  final String title;
  final List<Map<String, String>> sites;
  const SiteList({Key? key, required this.title, required this.sites})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(
              left: 20.0,
            ),
            child: Text(title),
          ),
        ),
        Expanded(
          child: GridView(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 5, //横轴三个子widget
              childAspectRatio: 1.3, //宽高比为1时，子widget
            ),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: sites
                .map(
                  (e) => GestureDetector(
                    onTap: () {
                      MNavigator.push(
                        context,
                        (ctx, arguments) => Browser(url: e['url']!),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Icon(Icons.ac_unit),
                          Text(
                            e['title']!,
                            maxLines: 1,
                          )
                        ],
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }
}
