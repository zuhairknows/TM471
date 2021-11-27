import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../../routes.dart';
import '../../../widget/loading_view.dart';
import '../controller/login_controller.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => LoginController(context),
      builder: (context, _) {
        return buildLayout(context);
      },
    );
  }

  Widget buildLayout(
    BuildContext context,
  ) {
    final controller = context.watch<LoginController>();

    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: const Text('Login'),
          ),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  suffixIcon: Icon(Icons.email),
                  hintText: 'example@example.com',
                  labelText: 'E-Mail',
                ),
                validator: (text) {
                  if (text == null) return null;

                  if (text.isEmpty) {
                    return 'Email is Required';
                  } else if (!RegExp(r"^([a-zA-Z0-9_\-\.]+)@([a-zA-Z0-9_\-\.]+)\.([a-zA-Z]{2,5})$").hasMatch(text)) {
                    return 'Please enter a valid Email';
                  } else {
                    return null;
                  }
                },
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                onChanged: (text) {
                  controller.emailText = text;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  suffixIcon: Icon(Icons.lock),
                  hintText: 'Password',
                  labelText: 'Password',
                ),
                obscureText: true,
                textInputAction: TextInputAction.done,
                onChanged: (text) {
                  controller.passwordText = text;
                },
                onFieldSubmitted: (text) {
                  controller.login();
                },
              ),
              const SizedBox(height: 16),
              OutlinedButton.icon(
                onPressed: controller.loginWithGoogle,
                label: Text('Login with Google'.toUpperCase()),
                icon: SvgPicture.asset(
                  'assets/icons/google.svg',
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: controller.login,
                child: Text('Login'.toUpperCase()),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(Routes.FORGOT_PASSWORD);
                },
                child: Text('Forgot Password'.toUpperCase()),
              ),
            ],
          ),
        ),
        if (controller.loading) const LoadingView(),
      ],
    );
  }
}
