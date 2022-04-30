import 'package:chat_app/constants/values.dart';
import 'package:chat_app/data/repositories/auth_repository.dart';
import 'package:chat_app/logic/blocs/register/register_bloc.dart';
import 'package:chat_app/presentation/widgets/auth_wiget.dart';
import 'package:chat_app/utils/static_data.dart';
import 'package:chat_app/utils/theme.dart';
import 'package:chat_app/utils/validation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({Key? key}) : super(key: key);
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailController = TextEditingController();
  final _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    const space = SizedBox(height: 10);
    return BlocProvider(
      create: (context) => RegisterBloc(
        authRepo: RepositoryProvider.of<AuthRepository>(context),
      ),
      child: BlocListener<RegisterBloc, RegisterState>(
        listener: (context, state) {
          if (state is RegisterLoading) {
            showDialog(
                useRootNavigator: false,
                barrierDismissible: false,
                context: context,
                builder: (context) => const Center(
                      child: SizedBox(
                        child: CircularProgressIndicator(),
                        width: 50,
                        height: 50,
                      ),
                    ));
          } else if (state is RegisterSuccess || state is RegisterError) {
            Navigator.of(context).pop();
          }
        },
        child: Builder(builder: (context) {
          // _showLoadingDialog(context);
          return Scaffold(
              // resizeToAvoidBottomInset: false,
              body: SafeArea(
            child: Center(
              child: Padding(
                padding: kScaffoldPadding,
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(children: [
                      UsernameField(
                        controller: _usernameController,
                      ),
                      space,
                      PasswordField(
                        controller: _passwordController,
                      ),
                      space,
                      _nameField(_nameController),
                      space,
                      _emailField(_emailController),
                      const SizedBox(height: 10),
                      _nofityError(),
                      const SizedBox(height: 10),
                      _registerButton(context),
                      space,
                      _cancelButton(context),
                    ]),
                  ),
                ),
              ),
            ),
          ));
        }),
      ),
    );
  }

  Widget _nameField(TextEditingController controller) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: StaticData.languageDisplay.kName,
        prefixIcon: const Icon(Icons.person),
      ),
      validator: (value) {
        if (!validateName(value)) {
          return StaticData.languageDisplay.kInvalidName;
        }
        return null;
      },
    );
  }

  Widget _emailField(TextEditingController controller) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: StaticData.languageDisplay.kEmail,
        prefixIcon: const Icon(Icons.person),
      ),
      validator: (value) {
        if (!validateEmail(value)) {
          return StaticData.languageDisplay.kInvalidEmail;
        }
        return null;
      },
    );
  }

  Widget _registerButton(BuildContext context) {
    return ElevatedButton(
      child: Text(StaticData.languageDisplay.kRegister),
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          BlocProvider.of<RegisterBloc>(context).add(
            RegisterSubmited(
              username: _usernameController.text,
              password: _passwordController.text,
              name: _nameController.text,
              email: _emailController.text,
            ),
          );
        }
      },
    );
  }

  Widget _cancelButton(BuildContext context) {
    return TextButton(
      child: Text(StaticData.languageDisplay.kCancel),
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }

  Widget _nofityError() {
    return BlocBuilder<RegisterBloc, RegisterState>(
      builder: (context, state) {
        if (state is RegisterSuccess) {
          return Text(StaticData.languageDisplay.kRegisterSuccess);
        } else if (state is RegisterError) {
          String msg = '';
          switch (state.status) {
            case RegisterStatus.emailExists:
              msg = StaticData.languageDisplay.kEmailExists;
              break;
            case RegisterStatus.usernameExists:
              msg = StaticData.languageDisplay.kUsernameExists;
              break;
            case RegisterStatus.retry:
              msg = StaticData.languageDisplay.kRetry;
              break;
            default:
              msg = StaticData.languageDisplay.kUnknown;
          }
          return Text(msg,
              style: const TextStyle(
                color: Colors.red,
              ));
        }
        return Container();
      },
    );
  }
}
