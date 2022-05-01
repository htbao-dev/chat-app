import 'package:chat_app/constants/enums.dart';
import 'package:chat_app/constants/routes.dart';
import 'package:chat_app/logic/blocs/auth/auth_bloc.dart';
import 'package:chat_app/presentation/widgets/auth_wiget.dart';
import 'package:chat_app/presentation/widgets/common_widget.dart';
import 'package:chat_app/utils/static_data.dart';
import 'package:chat_app/utils/strings.dart';
import 'package:chat_app/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );
    controller.forward();
    _usernameController.text = '18T1021011';
    _passwordController.text = '18T1021011';
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            Navigator.of(context).pushNamedAndRemoveUntil(
              AppRoutes.home,
              (route) => false,
            );
          }
        },
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          // backgroundColor: kPrimaryColor,
          body: SafeArea(
            child: Padding(
              padding: kScaffoldPadding,
              child: FadeTransition(
                opacity: controller,
                child: Form(
                  key: _formKey,
                  child: Stack(
                    children: [
                      const Align(
                          child: AppLogo(), alignment: Alignment.topCenter),
                      Align(
                        child: _loginForm(),
                        alignment: Alignment.center,
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _loginForm() {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            UsernameField(
              controller: _usernameController,
            ),
            PasswordField(
              controller: _passwordController,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: _notifyError(),
            ),
            SizedBox(
              child: _loginButton(),
              width: double.infinity,
            ),
            _registerButton()
          ],
        );
      },
    );
  }

  Widget _notifyError() {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthError && state.status != AuthStatus.checkAuthFailed) {
          String message =
              getAuthDisplayString(state.status, state.errorMessage);
          return Text(
            message,
            style: const TextStyle(
              color: Colors.red,
            ),
          );
        }
        return const SizedBox();
      },
    );
  }

  Widget _loginButton() {
    return ElevatedButton(
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          BlocProvider.of<AuthBloc>(context).add(
            LoginSubmited(
              username: _usernameController.text,
              password: _passwordController.text,
            ),
          );
        }
      },
      child: Text(StaticData.languageDisplay.kLogin),
    );
  }

  Widget _registerButton() {
    return TextButton(
        onPressed: () {
          Navigator.of(context).pushNamed(AppRoutes.register);
        },
        child: Text(StaticData.languageDisplay.kRegister));
  }
}
