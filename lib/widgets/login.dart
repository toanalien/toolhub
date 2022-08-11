import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import "../storage.dart";

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(Icons.lock, size: size.width * 0.3),
              const SizedBox(height: 20),
              const Text(
                  'Tap on the button to authenticate with the device\'s local authentication system.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 21,
                    color: Colors.black,
                  )),
              const SizedBox(height: 30),
              SizedBox(
                width: size.width,
                child: TextButton(
                  onPressed: () {
                    //implement biometric auth here
                  },
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.all(20),
                    backgroundColor: Colors.blue,
                    shadowColor: const Color(0xFF323247),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        'LOGIN WITH BIOMETRICS',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          wordSpacing: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class EnableLocalAuthModalBottomSheet extends StatelessWidget {
  final void Function() action;

  const EnableLocalAuthModalBottomSheet({Key? key, required this.action})
      : super(key: key);

  static const Color primaryColor = Color(0xFF13B5A2);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Icon(
            Icons.fingerprint_outlined,
            size: 100,
            color: primaryColor,
          ),
          const SizedBox(
            height: 10,
          ),
          const Text(
            'Do you want to enable fingerprint login?',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(
            height: 5,
          ),
          const Text(
              'The next time you log in, you will not be prompted for your login credentials.',
              textAlign: TextAlign.center),
          const SizedBox(
            height: 10,
          ),
          ElevatedButton(
            child: const Text("Yes, cool!"),
            onPressed: () {
              action();
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
                primary: primaryColor,
                textStyle:
                    const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          ),
          ElevatedButton(
              child: const Text(
                "No, thanks!",
                style: TextStyle(color: Colors.black54),
              ),
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                primary: Colors.grey[200],
                textStyle: const TextStyle(fontSize: 18),
              ))
        ],
      ),
    );
  }
}

const key = 'LOCAL_AUTH_ENABLED';

class AuthService {
  start() {
    bool enabled = Preference.prefs.getBool(key) ?? false;
    print('key: $key, enabled: $enabled');
  }

  static enable() {
    Preference.prefs.setBool(key, true);
  }

  static disable() {
    Preference.prefs.setBool(key, false);
  }

  static Future<bool> authenticateUser(BuildContext context) async {
    //initialize Local Authentication plugin.
    final LocalAuthentication localAuthentication = LocalAuthentication();
    //status of authentication.
    bool isAuthenticated = false;
    //check if device supports biometrics authentication.
    bool isBiometricSupported = await localAuthentication.isDeviceSupported();
    //check if user has enabled biometrics.
    //check
    bool canCheckBiometrics = await localAuthentication.canCheckBiometrics;

    //if device supports biometrics and user has enabled biometrics, then authenticate.
    if (isBiometricSupported && canCheckBiometrics) {
      try {
        isAuthenticated = await localAuthentication.authenticate(
          localizedReason: 'Scan your fingerprint to authenticate',
          options: const AuthenticationOptions(
            biometricOnly: true,
            useErrorDialogs: true,
            stickyAuth: true,
          ),
        );
      } on PlatformException catch (e) {
        print(e);
      }
    }

    if (!isAuthenticated) {
      showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context) {
          return const EnableLocalAuthModalBottomSheet(action: enable);
        },
      );
    }
    return isAuthenticated;
  }
}
