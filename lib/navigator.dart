import 'package:flutter/cupertino.dart';

class MNavigator {
  static NavigatorState of(BuildContext context) {
    return Navigator.of(context);
  }

  static push(
    BuildContext context,
    Widget Function(BuildContext ctx, dynamic arguments) create,
  ) {
    Navigator.of(context).push(
      CupertinoPageRoute(builder: (context) {
        return create(context, {});
      }),
    );
  }
}
