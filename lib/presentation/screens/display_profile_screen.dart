import 'package:chat_app/data/models/user.dart';
import 'package:chat_app/logic/blocs/auth/auth_bloc.dart';
import 'package:chat_app/presentation/screens/edit_profile_screen.dart';
import 'package:chat_app/presentation/widgets/avt_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DisplayProfileScreen extends StatefulWidget {
  const DisplayProfileScreen({
    Key? key,
    required this.user,
  }) : super(key: key);

  final User user;

  @override
  State<DisplayProfileScreen> createState() => _DisplayProfileScreenState();
}

class _DisplayProfileScreenState extends State<DisplayProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () async {
              final bool confirm = await _confirm();
              if (confirm) {
                BlocProvider.of<AuthBloc>(context).add(Logout());
              }
            },
          )
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 30),
            child: Center(
                child: AvatarProfile(
              widget.user.avatarUrl ?? '',
            )),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: Text(
              widget.user.name!,
              style: const TextStyle(
                fontSize: 20,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            decoration: BoxDecoration(color: Theme.of(context).backgroundColor),
            child: Table(
              columnWidths: const <int, TableColumnWidth>{
                0: FixedColumnWidth(120),
              },
              children: [
                _buildTableRow(context, 'Username', widget.user.username),
                _buildTableRow(
                    context, 'Email', widget.user.emails?.first.address ?? ''),
              ],
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => EditProfileScreen(user: widget.user)));
        },
        backgroundColor: Theme.of(context).primaryColor,
        child: const Icon(Icons.edit),
      ),
    );
  }

  TableRow _buildTableRow(BuildContext context, String label, String value) {
    return TableRow(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Theme.of(context).dividerColor),
        ),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 15),
          child: Text(label),
        ),
        TableCell(
            verticalAlignment: TableCellVerticalAlignment.middle,
            child: Text(value,
                style: const TextStyle(fontWeight: FontWeight.w300))),
      ],
    );
  }

  Future<bool> _confirm() async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Are you sure?'),
            content: const Text('Do you want to exit?'),
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
}
