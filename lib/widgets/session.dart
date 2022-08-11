import 'package:flutter/material.dart';
import 'package:local_session_timeout/local_session_timeout.dart';

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
