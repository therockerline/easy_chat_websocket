

import 'package:easychat/models/user.dart';
import 'package:easychat/pages/chat/chat.dart';
import 'package:easychat/pages/chat_list/widgets/chat_list_item.dart';
import 'package:easychat/pages/login/login.dart';
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

  @override
  void initState() {
    print('init chat_list');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('build chat_list');
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('EasyChat, hello ${Shared.currentUser?.nickname}!'),
      ),
      body: StreamBuilder<List<User>>(
        initialData: [],
        stream: Shared.onlineUsers.stream,
        builder: (context, snapshot) {
          if(snapshot.hasData) {
            evaluateNewUsers(snapshot.data);
          }
          return Padding(
              padding: const EdgeInsets.symmetric(vertical: 24.0),
              child: Column(
                children: users.isEmpty ? [Text('no user online')] : users.map((e) {
                  return ChatListItem(user: e, click: () {
                    openChat(e);
                  });
                }).toList(),
              )
          );
        },
      )
    );
  }

  void openChat(User user) {
    Shared.setTargetUser(user);
    Navigator.of(context).pushNamed(Chat.routeName);
  }

  void evaluateNewUsers(List<User> data) {
    data.forEach((newUser) {
      int indexOf = users.indexWhere((user) => user.nickname == newUser.nickname);
      if(indexOf == -1){
        users.add(newUser);
      }
    });
  }
}
