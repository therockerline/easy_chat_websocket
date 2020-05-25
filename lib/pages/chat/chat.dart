
import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:easychat/models/socket_message.dart';
import 'package:easychat/models/user.dart';
import 'package:easychat/services/shared.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class Chat extends StatefulWidget {
  static String routeName = '/';

  Chat({Key key}) : super(key: key);

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  TextEditingController _controller = TextEditingController();
  User user;
  @override
  void initState() {

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if(user==null)
      user = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text('${user.nickname}'),
      ),
      bottomSheet: Form(
        child: TextFormField(
          controller: _controller,
          decoration: InputDecoration(
            icon: Column(
              children: [
                Icon(Icons.person),
                Text('${user.messages.length}')
              ],
            ),
            labelText: 'Send a message to ${user.nickname}',
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _sendMessage,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: user.messages.map((e) {
            return(
              Text(e)
            );
          }).toList(),
        ),
      ),
    );
  }

  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      var mess = {
        'type':'message',
        'target':user,
        'message':_controller.text
      };
      Shared.webSocketChannel.sink.add(jsonEncode(mess));
    }
  }
}
