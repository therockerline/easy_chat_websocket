
import 'dart:async';

import 'package:easychat/models/message.dart';
import 'package:easychat/models/user.dart';
import 'package:easychat/services/shared.dart';
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
  StreamSubscription stream;
  User userTarget;

  @override
  void initState() {
    userTarget = Shared.targetUser;
    stream = userTarget.updater.stream.listen((event) {
      print(['update',_scrollController.offset, _scrollController.position.maxScrollExtent]);
      //_scrollController.animateTo(_scrollController.position.maxScrollExtent + 18, duration: Duration(milliseconds: 500), curve: Curves.bounceInOut);
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if(userTarget==null){
      return CircularProgressIndicator();
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('${userTarget.nickname}'),
      ),
      bottomSheet: Form(
        child: TextFormField(
          controller: _controller,
          onEditingComplete: _sendMessage,
          decoration: InputDecoration(
            icon: Stack(
              alignment: Alignment.center,
              fit: StackFit.loose,
              children: [
                Icon(Icons.person),
                Positioned(
                    left: 25,
                    child: Text('${userTarget.messages.length}')
                )
              ],
            ),
            labelText: 'Send a message to ${userTarget.nickname}',
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _sendMessage,
        child: Icon(
          Icons.send
        ),
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
              children: userTarget.messages.map((e) {
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
    String message = _controller.text;
    if (message.isNotEmpty) {
      setState(() {
        userTarget.addMessage(Message(message: message, type: MessageType.sended));
      });
      WebSocketService.sendMessage(userTarget, message);
    }
  }

  @override
  void dispose() {
    stream.cancel();
    Shared.setTargetUser(null);
    super.dispose();
  }
}
