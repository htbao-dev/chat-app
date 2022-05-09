import 'dart:ui';

import 'package:chat_app/logic/blocs/auth/auth_bloc.dart';
import 'package:chat_app/constants/assets.dart';
import 'package:chat_app/constants/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<AuthBloc>(context).add(CheckAuth());
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        await controller.forward();
        if (state is AuthError) {
          Navigator.of(context).popAndPushNamed(AppRoutes.login);
        } else if (state is AuthSuccess) {
          Navigator.of(context).popAndPushNamed(AppRoutes.home);
        }
      },
      child: Stack(children: [
        Align(
          child: AnimatedLogo(
            controller: controller,
          ),
          alignment: const Alignment(0, 0.5),
        ),
      ]),
    ));
  }
}

class AnimatedLogo extends AnimatedWidget {
  AnimatedLogo({
    Key? key,
    required Animation<double> controller,
  }) : super(key: key, listenable: controller) {
    translate = _initTranslate(controller);
  }
  late final Animation<Offset> translate;
  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: translate.value,
      child: Image.asset(
        kLogo,
      ),
    );
  }

  Animation<Offset> _initTranslate(Animation<double> controller) {
    var h = MediaQueryData.fromWindow(window).size.height;

    return Tween<Offset>(
      begin: Offset.zero,
      end: Offset(0, -h),
    ).animate(CurvedAnimation(
      parent: controller,
      curve: Curves.decelerate,
    ));
  }
}
