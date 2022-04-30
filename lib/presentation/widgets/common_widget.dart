import 'package:chat_app/constants/assets.dart';
import 'package:flutter/material.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      kLogo,
      height: 200,
      // height: 200,
    );
  }
}
