
import 'dart:async';
import 'dart:convert';

import 'package:easychat/constants.dart';
import 'package:easychat/models/message.dart';
import 'package:easychat/models/user.dart';
import 'package:easychat/services/shared.dart';
import 'package:easychat/services/storage_service.dart';
import 'package:easychat/services/web_socket_service.dart';
import 'package:flutter/material.dart';

class Chat extends StatefulWidget {
  static String routeName = '/chat';

  Chat({Key key}) : super(key: key);

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  TextEditingController _controller = TextEditingController();
  ScrollController _scrollController = ScrollController();
  StreamSubscription stream = null;
  User user;

  @override
  void initState() {
    user = Shared.targetUser;
    stream = user.updater.stream.listen((event) {
      print(['update',_scrollController.offset, _scrollController.position.maxScrollExtent]);
      //_scrollController.animateTo(_scrollController.position.maxScrollExtent + 18, duration: Duration(milliseconds: 500), curve: Curves.bounceInOut);
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if(user==null){
      return CircularProgressIndicator();
    }
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
      body: Container(
        height: MediaQuery.of(context).size.height - 200,
        child: SafeArea(
          bottom: true,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: ListView(
              reverse: true,
              controller: _scrollController,
              scrollDirection: Axis.vertical,
              children: user.messages.map((e) {
                return(
                   Text(e.message, style: TextStyle(color: e.type == MessageType.sended? Colors.green: Colors.red),)
                );
              }).toList().reversed.toList(),
            ),
          ),
        ),
      ),
    );
  }

  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      setState(() {
        user.addMessage(Message(message: _controller.text, type: MessageType.sended));
      });
      WebSocketService.send(user, _controller.text);
    }
  }

  @override
  void dispose() {
    stream.cancel();
    Shared.setTargetUser(null);
    super.dispose();
  }
}
