import 'package:chat_app/utils/static_data.dart';
import 'package:chat_app/utils/validation.dart';
import 'package:flutter/material.dart';

class UsernameField extends StatelessWidget {
  final TextEditingController? controller;
  const UsernameField({Key? key, this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      onEditingComplete: () {
        FocusScope.of(context).nextFocus();
      },
      decoration: InputDecoration(
        labelText: StaticData.languageDisplay.kUsername,
        prefixIcon: const Icon(Icons.email),
      ),
      validator: (value) {
        if (!validateUsername(value)) {
          return StaticData.languageDisplay.kInvalidUsername;
        }
        return null;
      },
    );
  }
}

class PasswordField extends StatelessWidget {
  final TextEditingController? controller;
  const PasswordField({Key? key, this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: true,
      decoration: InputDecoration(
        labelText: StaticData.languageDisplay.kPassword,
        prefixIcon: const Icon(Icons.key),
      ),
      validator: (value) {
        if (!validatePassword(value)) {
          return StaticData.languageDisplay.kInvalidPassword;
        }
        return null;
      },
    );
  }
}
