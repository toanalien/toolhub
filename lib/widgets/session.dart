import 'package:flutter/material.dart';
import 'package:local_session_timeout/local_session_timeout.dart';
import "dart:async";

class Session {
  static start(BuildContext context, Function onSessionTimeout) {
    final sessionConfig = SessionConfig(
        invalidateSessionForAppLostFocus: const Duration(seconds: 15),
        invalidateSessionForUserInactiviity: const Duration(seconds: 30));

    sessionConfig.stream.listen((SessionTimeoutState event) {
      if (event == SessionTimeoutState.userInactivityTimeout) {
        onSessionTimeout();
      } else if (event == SessionTimeoutState.appFocusTimeout) {
        onSessionTimeout();
      }
    });
  }
}

// const _inactivityTimeout = Duration(seconds: 10);
// Timer _keepAliveTimer;

// void _keepAlive(bool visible) {
//   _keepAliveTimer?.cancel();
//   if (visible) {
//     _keepAliveTimer = null;
//   } else {
//     _keepAliveTimer = Timer(_inactivityTimeout, () => exit(0));
//   }
// }

// class _KeepAliveObserver extends WidgetsBindingObserver {
//   @override
//   didChangeAppLifecycleState(AppLifecycleState state) {
//     switch (state) {
//       case AppLifecycleState.resumed:
//         _keepAlive(true);
//         break;
//       case AppLifecycleState.inactive:
//       case AppLifecycleState.paused:
//       case AppLifecycleState.detached:
//         _keepAlive(false); // Conservatively set a timer on all three
//         break;
//     }
//   }
// }

// /// Must be called only when app is visible, and exactly once
// void startKeepAlive() {
//   assert(_keepAliveTimer == null);
//   _keepAlive(true);
//   WidgetsBinding.instance.addObserver(_KeepAliveObserver());
// }
