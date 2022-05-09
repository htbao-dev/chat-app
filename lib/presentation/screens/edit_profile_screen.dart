import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/data/models/user.dart';
import 'package:chat_app/logic/blocs/auth/auth_bloc.dart';
import 'package:chat_app/presentation/widgets/auth_wiget.dart';
import 'package:chat_app/presentation/widgets/avt_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditProfileScreen extends StatefulWidget {
  final User user;
  const EditProfileScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  bool isEdit = false;
  String? errMsg;
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _nameController = TextEditingController();

  @override
  void initState() {
    _usernameController.text = widget.user.username;
    _emailController.text = widget.user.emails?.first.address ?? '';
    _nameController.text = widget.user.name ?? '';

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Edit'),
        ),
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: Center(
                    child: AvatarProfile(widget.user.avatarUrl ?? ''),
                  ),
                ),
                //button pick image
                TextButton.icon(
                  onPressed: () async {
                    showDialog(
                      context: context,
                      builder: (context) => const Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                    final success =
                        await BlocProvider.of<AuthBloc>(context).openGallery();
                    if (success) {
                      await CachedNetworkImage.evictFromCache(
                          widget.user.avatarUrl!);
                      setState(() {});

                      await BlocProvider.of<AuthBloc>(context).getUserInfo();
                    }
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.image),
                  label: const Text('Pick image'),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  color: Theme.of(context).backgroundColor,
                  child: Column(
                    children: [
                      NameField(
                        controller: _nameController,
                        onChanged: (value) {
                          isEdit = true;
                        },
                      ),
                      UsernameField(
                        controller: _usernameController,
                        onChanged: (value) {
                          isEdit = true;
                        },
                      ),
                      EmailField(
                        controller: _emailController,
                        onChanged: (value) {
                          isEdit = true;
                        },
                      ),
                      const SizedBox(height: 15),
                      errMsg != null
                          ? Text(
                              errMsg!,
                              style: const TextStyle(color: Colors.red),
                            )
                          : const SizedBox(),
                      _saveButton(context),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _saveButton(BuildContext context) {
    return ElevatedButton(
      child: const Text('save'),
      onPressed: () async {
        if (_formKey.currentState!.validate()) {
          showDialog(
            context: context,
            builder: (context) => const Center(
              child: CircularProgressIndicator(),
            ),
          );
          final success =
              await BlocProvider.of<AuthBloc>(context).updateUserInfo(
            name: _nameController.text,
            email: _emailController.text,
            username: _usernameController.text,
          );
          if (success) {
            await BlocProvider.of<AuthBloc>(context).getUserInfo();
            Navigator.pop(context);
          } else {
            setState(() {
              errMsg = 'Update failed';
            });
          }
          Navigator.pop(context);
        }
      },
    );
  }

  Future<bool> _onWillPop() async {
    if (isEdit) {
      return await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Are you sure?'),
              content: const Text('Do you want to save your changes?'),
              actions: <Widget>[
                TextButton(
                  child: const Text('No'),
                  onPressed: () => Navigator.pop(context, false),
                ),
                TextButton(
                  child: const Text('Yes'),
                  onPressed: () => Navigator.pop(context, true),
                ),
              ],
            ),
          ) ??
          false;
    }
    return true;
  }
}
