import 'package:chat_app/data/repositories/team_repository.dart';
import 'package:chat_app/logic/blocs/team/team_bloc.dart';
import 'package:chat_app/utils/static_data.dart';
import 'package:chat_app/utils/validation.dart';
import 'package:flutter/material.dart';

class NewTeamScreen extends StatefulWidget {
  final TeamBloc teamBloc;
  const NewTeamScreen({Key? key, required this.teamBloc}) : super(key: key);

  @override
  State<NewTeamScreen> createState() => _NewTeamScreenState();
}

class _NewTeamScreenState extends State<NewTeamScreen> {
  String? error;
  final TextEditingController _textEditingController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Team name',
            ),
            controller: _textEditingController,
            validator: (value) {
              if (!validateRoomName(value)) {
                return StaticData.languageDisplay.invalidTeamName;
              }
              return null;
            },
          ),
          if (error != null)
            Text(
              error!,
              style: const TextStyle(color: Colors.red),
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      final status = await widget.teamBloc
                          .createTeam(name: _textEditingController.text);
                      if (status == CreateTeamStatus.success) {
                        widget.teamBloc.add(LoadTeam());
                        Navigator.pop(context);
                      } else if (status == CreateTeamStatus.duplicateName) {
                        setState(() {
                          error = StaticData.languageDisplay.kTeamNameExist;
                        });
                      } else {
                        setState(() {
                          error = StaticData.languageDisplay.kUnknown;
                        });
                      }
                    }
                  },
                  child: const Text('Create')),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Cancel'),
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.grey),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
