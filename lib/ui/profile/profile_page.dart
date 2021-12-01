import 'package:barber_salon/widget/icon_popup_menu.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../routes.dart';
import '../../widget/error_item.dart';
import '../../widget/loading_item.dart';
import '../register/controller/register_controller.dart';
import 'controller/profile_controller.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ProfileController(context),
      builder: (context, _) {
        return buildLayout(context);
      },
    );
  }

  Widget buildLayout(
    BuildContext context,
  ) {
    final controller = context.watch<ProfileController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
        actions: [
          IconPopupMenuButton(
            itemBuilder: (context) => [
              const PopupMenuItem(
                child: Text('Change Password'),
                value: 1,
              )
            ],
            onSelected: (index) {
              controller.requestPasswordChange();
            },
          )
        ],
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        child: selectView(context, controller),
      ),
    );
  }

  Widget selectView(
    BuildContext context,
    ProfileController controller,
  ) {
    if (controller.error != null) {
      return ErrorItem(
        error: controller.error!,
        onRetry: controller.getUserData(),
      );
    } else if (controller.userData == null) {
      return const LoadingItem();
    } else {
      return ListView(
        key: const ValueKey(1),
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            decoration: const InputDecoration(
              suffixIcon: Icon(Icons.email),
              hintText: 'example@example.com',
              labelText: 'E-Mail',
            ),
            controller: controller.emailText,
            enabled: false,
            style: Theme.of(context).textTheme.subtitle1!.copyWith(
                  color:
                      Theme.of(context).colorScheme.onSurface.withAlpha(0x66),
                ),
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: 16),
          TextField(
            enabled: controller.editing,
            decoration: const InputDecoration(
              suffixIcon: Icon(Icons.person),
              hintText: 'Ammar',
              labelText: 'First Name',
            ),
            controller: controller.firstNameText,
            keyboardType: TextInputType.name,
            textCapitalization: TextCapitalization.words,
            textInputAction: TextInputAction.next,
            style: _getTextColor(context, controller.editing),
          ),
          const SizedBox(height: 16),
          TextField(
            enabled: controller.editing,
            decoration: const InputDecoration(
              suffixIcon: Icon(Icons.person),
              hintText: 'Ammar',
              labelText: 'Last Name',
            ),
            controller: controller.lastNameText,
            keyboardType: TextInputType.name,
            textCapitalization: TextCapitalization.words,
            textInputAction: TextInputAction.next,
            style: _getTextColor(context, controller.editing),
          ),
          const SizedBox(height: 16),
          TextField(
            enabled: controller.editing,
            decoration: const InputDecoration(
              suffixIcon: Icon(Icons.phone),
              prefixText: '+966',
              hintText: '012 XXX XXXX',
              labelText: 'Phone Number',
            ),
            controller: controller.phoneNumberText,
            keyboardType: TextInputType.phone,
            textInputAction: TextInputAction.next,
            style: _getTextColor(context, controller.editing),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            decoration:
                InputDecoration(labelText: 'City', enabled: controller.editing),
            value: controller.city,
            onChanged: controller.editing
                ? (text) {
                    controller.city = text ?? '';
                  }
                : null,
            items: addressValues.map((e) {
              return DropdownMenuItem(child: Text(e), value: e);
            }).toList(),
            style: _getTextColor(context, controller.editing),
          ),
          const SizedBox(height: 16),
          if (!controller.editing)
            ElevatedButton(
              onPressed: () {
                controller.startEdit();
              },
              child: Text('Edit'.toUpperCase()),
            ),
          if (controller.editing) ...[
            ElevatedButton(
              onPressed: controller.updateProfile,
              child: Text('Update Profile'.toUpperCase()),
            ),
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: controller.cancelEdit,
              child: Text('Cancel'.toUpperCase()),
            ),
          ],
        ],
      );
    }
  }

  _getTextColor(BuildContext context, bool editing) {
    return editing
        ? Theme.of(context).textTheme.subtitle1
        : Theme.of(context).textTheme.subtitle1!.copyWith(
            color: Theme.of(context).colorScheme.onSurface.withAlpha(0x66));
  }
}
