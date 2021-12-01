import '../../widget/loading_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'controller/register_controller.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => RegisterController(context),
      builder: (context, _) {
        return buildLayout(context);
      },
    );
  }

  Widget buildLayout(
    BuildContext context,
  ) {
    final controller = context.watch<RegisterController>();

    return WillPopScope(
      onWillPop: () async {
        if (controller.stage == 1) {
          return true;
        } else {
          controller.stage = 1;

          controller.notifyListeners();

          return false;
        }
      },
      child: Stack(
        children: [
          Scaffold(
            appBar: AppBar(
              title: const Text('Register'),
            ),
            body: controller.stage == 1 ? stageOne(context, controller) : stageTwo(context, controller),
          ),
          if (controller.loading) const LoadingView(),
        ],
      ),
    );
  }

  stageOne(
    BuildContext context,
    RegisterController controller,
  ) {
    return ListView(
      key: const ValueKey(1),
      padding: const EdgeInsets.all(16),
      children: [
        TextFormField(
          decoration: const InputDecoration(
            suffixIcon: Icon(Icons.email),
            hintText: 'example@example.com',
            labelText: 'E-Mail',
          ),
          initialValue: controller.emailText,
          onChanged: (text) {
            controller.emailText = text;
          },
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(height: 16),
        TextFormField(
          decoration: const InputDecoration(
            suffixIcon: Icon(Icons.phone),
            prefixText: '+966',
            hintText: '012 XXX XXXX',
            labelText: 'Phone Number',
          ),
          initialValue: controller.phoneNumberText,
          onChanged: (text) {
            controller.phoneNumberText = text;
          },
          keyboardType: TextInputType.phone,
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(height: 16),
        TextFormField(
          decoration: const InputDecoration(
            suffixIcon: Icon(Icons.lock),
            hintText: 'Password',
            labelText: 'Password',
          ),
          initialValue: controller.passwordText,
          onChanged: (text) {
            controller.passwordText = text;
          },
          obscureText: true,
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(height: 16),
        TextFormField(
          decoration: const InputDecoration(
            suffixIcon: Icon(Icons.lock),
            hintText: 'Confirm Password',
            labelText: 'Confirm Password',
          ),
          initialValue: controller.confirmPasswordText,
          onChanged: (text) {
            controller.confirmPasswordText = text;
          },
          obscureText: true,
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: controller.validateStepOne,
          child: Text('Next'.toUpperCase()),
        ),
      ],
    );
  }

  stageTwo(
    BuildContext context,
    RegisterController controller,
  ) {
    return ListView(
      key: const ValueKey(2),
      padding: const EdgeInsets.all(16),
      children: [
        TextFormField(
          decoration: const InputDecoration(
            suffixIcon: Icon(Icons.person),
            hintText: 'Ammar',
            labelText: 'First Name',
          ),
          initialValue: controller.firstNameText,
          onChanged: (text) {
            controller.firstNameText = text;
          },
          keyboardType: TextInputType.name,
          textCapitalization: TextCapitalization.words,
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(height: 16),
        TextFormField(
          decoration: const InputDecoration(
            suffixIcon: Icon(Icons.person),
            hintText: 'Ammar',
            labelText: 'Last Name',
          ),
          initialValue: controller.lastNameText,
          onChanged: (text) {
            controller.lastNameText = text;
          },
          keyboardType: TextInputType.name,
          textCapitalization: TextCapitalization.words,
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField<String>(
          decoration: const InputDecoration(
            labelText: 'City',
          ),
          onChanged: (text) {
            controller.city = text ?? '';
          },
          items: addressValues.map((e) {
            return DropdownMenuItem(child: Text(e), value: e);
          }).toList(),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: controller.register,
          child: Text('Register'.toUpperCase()),
        ),
      ],
    );
  }
}
