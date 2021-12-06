import '../../widget/loading_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'controller/forgot_password_controller.dart';

class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ForgotPasswordController(context),
      builder: (context, _) {
        return buildLayout(context);
      },
    );
  }

  Widget buildLayout(
    BuildContext context,
  ) {
    final controller = context.watch<ForgotPasswordController>();

    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: const Text('Forgot Password'),
          ),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const Text(
                'You can set a new password using the link sent via an email',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
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
                textInputAction: TextInputAction.done,
                onChanged: (text) {
                  controller.emailText = text;
                },
                onFieldSubmitted: (text) {
                  controller.resetPassword();
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: controller.resetPassword,
                child: Text('Reset Password'.toUpperCase()),
              ),
            ],
          ),
        ),
        if (controller.loading) const LoadingView(),
      ],
    );
  }
}
