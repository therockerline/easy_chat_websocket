

import 'dart:async';

import 'package:easychat/main.dart';
import 'package:easychat/models/user.dart';
import 'package:easychat/pages/chat/chat.dart';
import 'package:easychat/pages/chat_list/widgets/chat_list_item.dart';
import 'package:easychat/services/session_service.dart';
import 'package:easychat/services/shared.dart';
import 'package:easychat/services/web_socket_service.dart';
import 'package:flutter/material.dart';

class ChatList extends StatefulWidget {
  static String routeName = '/chatList';
  ChatList({Key key}) : super(key: key);

  @override
  _ChatListState createState() {
    return _ChatListState();
  }
}

class _ChatListState extends State<ChatList> {
  List<User> users = [];
  StreamSubscription onlineUserSubscription;
  @override
  void initState() {
    print('init chat_list');

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('build chat_list');
    if(onlineUserSubscription==null){
      onlineUserSubscription = Shared.onlineUsers.stream.listen((event) {
        evaluateNewUsers(event);
      });
    }
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('EasyChat, hello ${Shared.currentUser?.nickname}!'),
        actions: [
          FlatButton(
            child: Icon(
              Icons.exit_to_app
            ),
            onPressed: logout,
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24.0),
        child: Column(
          children: users.isEmpty ? [Text('no user online')] : users.map((e) {
            return ChatListItem(user: e, click: () {
              openChat(e);
            });
          }).toList(),
        )
      )
    );
  }

  Future<void> logout() async {
    onlineUserSubscription.cancel();
    await SessionService.logout();
    Navigator.pushReplacementNamed(context, LoadingPage.routeName);
  }

  void openChat(User user) {
    Shared.setTargetUser(user);
    Navigator.of(context).pushNamed(Chat.routeName);
  }

  void evaluateNewUsers(List<User> data) {
    data.forEach((newUser) {
      int indexOf = users.indexWhere((user) => user.nickname == newUser.nickname);
      if(indexOf == -1){
        setState(() {
          users.add(newUser);
        });
      }else{
        setState(() {
          users[indexOf].isOnline = newUser.isOnline;
        });
      }
    });
  }
}
