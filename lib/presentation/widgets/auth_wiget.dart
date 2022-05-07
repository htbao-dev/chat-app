import 'package:chat_app/utils/static_data.dart';
import 'package:chat_app/utils/validation.dart';
import 'package:flutter/material.dart';

class UsernameField extends StatelessWidget {
  final Function(String)? onChanged;
  final TextEditingController? controller;
  const UsernameField({Key? key, this.controller, this.onChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: onChanged,
      controller: controller,
      onEditingComplete: () {
        FocusScope.of(context).nextFocus();
      },
      decoration: InputDecoration(
        labelText: StaticData.languageDisplay.kUsername,
        prefixIcon: const Icon(Icons.person),
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

class NameField extends StatelessWidget {
  final TextEditingController controller;
  final Function(String)? onChanged;
  const NameField({Key? key, required this.controller, this.onChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: onChanged,
      controller: controller,
      decoration: InputDecoration(
        labelText: StaticData.languageDisplay.kName,
        prefixIcon: const Icon(Icons.perm_contact_cal_rounded),
      ),
      validator: (value) {
        if (!validateName(value)) {
          return StaticData.languageDisplay.kInvalidName;
        }
        return null;
      },
    );
  }
}

class EmailField extends StatelessWidget {
  final Function(String)? onChanged;
  final TextEditingController? controller;
  const EmailField({Key? key, this.controller, this.onChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: onChanged,
      controller: controller,
      decoration: InputDecoration(
        labelText: StaticData.languageDisplay.kEmail,
        prefixIcon: const Icon(Icons.email),
      ),
      validator: (value) {
        if (!validateEmail(value)) {
          return StaticData.languageDisplay.kInvalidEmail;
        }
        return null;
      },
    );
  }
}

class PasswordField extends StatelessWidget {
  final TextEditingController? controller;
  final Function(String)? onChanged;
  final String? labelText;
  const PasswordField(
      {Key? key, this.controller, this.labelText, this.onChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: true,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: labelText ?? StaticData.languageDisplay.kPassword,
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
