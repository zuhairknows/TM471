import '../controller/login_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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

    return Scaffold(
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
          ElevatedButton(
            onPressed: controller.login,
            child: Text('Login'.toUpperCase()),
          ),
        ],
      ),
    );
  }
}
