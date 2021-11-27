import 'package:flutter/material.dart';

import '../../../routes.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              FlutterLogo(size: 196),
              const SizedBox(height: 36),
              OutlinedButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(Routes.LOGIN);
                },
                child: Text('Login'.toUpperCase()),
              ),
              const SizedBox(height: 16),
              OutlinedButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(Routes.REGISTER);
                },
                child: Text('Register'.toUpperCase()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
