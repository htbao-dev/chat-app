import 'package:chat_app/data/models/team.dart';
import 'package:chat_app/data/repositories/room_repository.dart';
import 'package:chat_app/logic/blocs/room/room_bloc.dart';
import 'package:chat_app/logic/blocs/team/team_bloc.dart';
import 'package:chat_app/utils/static_data.dart';
import 'package:chat_app/utils/validation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NewRoomScreen extends StatefulWidget {
  final RoomBloc roomBloc;
  final Team team;
  final TeamBloc teamBloc;
  const NewRoomScreen(
      {Key? key,
      required this.roomBloc,
      required this.team,
      required this.teamBloc})
      : super(key: key);

  @override
  State<NewRoomScreen> createState() => _NewRoomScreenState();
}

class _NewRoomScreenState extends State<NewRoomScreen> {
  bool _switchValue = true;
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
              labelText: 'Room name',
              errorMaxLines: 2,
            ),
            controller: _textEditingController,
            validator: (value) {
              if (!validateRoomName(value)) {
                return StaticData.languageDisplay.kInvalidRoomName;
              }
              return null;
            },
          ),
          Row(
            children: [
              const Text('Private room'),
              Switch(
                value: _switchValue,
                onChanged: (bool value) {
                  setState(() {
                    _switchValue = value;
                  });
                },
              ),
            ],
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
                      showDialog(
                        context: context,
                        builder: (context) => const Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                      final status = await widget.roomBloc.createRoom(
                          teamId: widget.team.id,
                          name: _textEditingController.text,
                          isPrivate: _switchValue);
                      Navigator.pop(context);

                      if (status == CreateRoomStatus.success) {
                        widget.teamBloc.loadRooms(team: widget.team);
                        Navigator.pop(context);
                      } else if (status == CreateRoomStatus.duplicateName) {
                        setState(() {
                          error = StaticData.languageDisplay.kRoomNameExist;
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
