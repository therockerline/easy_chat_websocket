
import 'dart:convert';
import 'dart:math';

import 'package:easychat/models/socket_message.dart';
import 'package:easychat/models/user.dart';
import 'package:easychat/pages/chat/chat.dart';
import 'package:easychat/pages/chat_list/widgets/chat_list_item.dart';
import 'package:easychat/services/shared.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:universal_platform/universal_platform.dart';


class ChatList extends StatefulWidget {
  static String routeName = '/chatList';
  ChatList({Key key}) : super(key: key);

  @override
  _ChatListState createState() {
    return _ChatListState();
  }
}

class _ChatListState extends State<ChatList> {
  List<User> users;
  @override
  void initState() {
    Shared.webSocketChannel.stream.listen((message) {
      SocketMessage sm = SocketMessage.fromJson(jsonDecode(message) as Map<String,dynamic>);
      if(sm!=null){
        switch(sm.type){
          case 'userUpdate': users = sm.userCollection; break;
          case 'message': users.firstWhere((element) => element.nickname == sm.user.nickname).addMessage(sm.message); break;
        }
        users.removeWhere((element) => element.port == Shared.appKey);
        Shared.onlineUsers.add(users);
      }else{
        print(['error',message]);
        //channel.sink.add('unable to parse message');
      }
      //users = (jsonDecode(data) as List<dynamic>).map((e) => User.fromJson(e as Map<String, dynamic>)).toList();
    });
    login();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('EasyChat ${Shared.appKey}'),
      ),
      body: StreamBuilder<List<User>>(
        initialData: [],
        stream: Shared.onlineUsers.stream,
        builder: (context, snapshot) {
          return Padding(
              padding: const EdgeInsets.symmetric(vertical: 24.0),
              child: Column(
                children: snapshot.data.isEmpty ? [Text('no user online')] : snapshot.data.map((e) {
                  return Flex(
                    direction: Axis.horizontal,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width - 180,
                        height: 100,
                        child: Column(
                          children: users.map((e) {
                            return ChatListItem(user: e, click: () {
                              openChat(e);
                            });
                          }).toList(),
                        ),
                      ),
                    ],
                  );
                }).toList()
              )
          );
        },
      )
    );
  }

  void openChat(User user) {
    Navigator.of(context).pushNamed(Chat.routeName, arguments: user);
  }

  void login() {

    var login = {
      'type':'login',
      'user':User(nickname: 'user_${Shared.appKey}', port: Shared.appKey).toJson()
    };
    var message = jsonEncode(login);
    print(['login', message]);
    Shared.webSocketChannel.sink.add(message);

  }
}
