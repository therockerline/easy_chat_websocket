import 'dart:convert';

import 'package:easychat/models/message.dart';
import 'package:easychat/models/socket_message.dart';
import 'package:easychat/models/user.dart';
import 'package:easychat/services/shared.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketService{
  static WebSocketChannel webSocketChannel;
  static List<User> _users;
  static void init(){
    Shared.onlineUsers.stream.listen((users) {
      _users = users;
      if(Shared.targetUser!= null) {
        User u = _users.firstWhere((element) => Shared.targetUser.nickname == element.nickname);
        /*Shared.targetUser.messages.forEach((element) {
          u.addMessage(element);
        });*/
        Shared.targetUser = u;
        Shared.targetUser.updater.add(null);
      }
    });
    List<User> users = [];
    if(UniversalPlatform.isWeb)
      webSocketChannel =  WebSocketChannel.connect(Uri.parse('ws://localhost:8080'),);
    else
      webSocketChannel =  IOWebSocketChannel.connect(Uri.parse('ws://192.168.1.98:8080'));
    webSocketChannel.stream.listen((message) {
      SocketMessage sm = SocketMessage.fromJson(jsonDecode(message) as Map<String,dynamic>);
      if(sm!=null){
        switch(sm.type){
          case 'userUpdate': users = sm.userCollection; break;
          case 'message': {
            int indexOf = _users.indexWhere((element) {
              return element.nickname == sm.user.nickname;
            });
            if(indexOf!= -1)
              _users[indexOf].addMessage(Message(message: sm.message, type: MessageType.received));
            break;
          }
        }
        users.removeWhere((element) => element.nickname == Shared.currentUser.nickname);
        print(users.length);
        Shared.onlineUsers.add(users);
      }else{
        print(['error',message]);
      }
    }, onError: (error){
      print(error);
    },
    onDone: (){
      print('done');
    });
  }

  static void login(User user) {
    if(user!= null){
      var login = {
        'type':'login',
        'user':user.toJson()
      };
      var message = jsonEncode(login);
      print(['login', message]);
      webSocketChannel.sink.add(message);
    }
  }

  static void send(String jsonEncoded) {
    print(['send', jsonEncoded]);
    webSocketChannel.sink.add(jsonEncoded);
  }
}