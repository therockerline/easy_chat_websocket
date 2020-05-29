import 'dart:async';
import 'dart:convert';
import 'package:easychat/models/message.dart';
import 'package:easychat/models/socket_message.dart';
import 'package:easychat/models/user.dart';
import 'package:easychat/services/session_service.dart';
import 'package:easychat/services/shared.dart';
import 'package:flutter/cupertino.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketService{
  static bool isConnected = false;
  static WebSocketChannel webSocketChannel;
  static StreamController<SocketMessage> _streamController = StreamController.broadcast();
  static List<User> _users;
  static Future<void> init() async {
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
    try {
      Uri server;
      print(server);
      if (UniversalPlatform.isWeb){
        server = Uri.parse('ws://localhost:8080');
        webSocketChannel = WebSocketChannel.connect(server);
      }else{
        server = Uri.parse('ws://10.0.2.2:8080');
        webSocketChannel = IOWebSocketChannel.connect(server);
      }
    }catch(error){
      print([error, webSocketChannel]);
      _streamController.add(SocketMessage(type: SocketMessageTypes.login));
    }
    print(['activate listener', ]);
    webSocketChannel.stream.listen(
      (message) {
        SocketMessage sm = SocketMessage.fromJson(jsonDecode(message) as Map<String,dynamic>);
        if(sm!=null){
          switch(sm.type){
            case SocketMessageTypes.userUpdate: users = sm.userCollection; break;
            case SocketMessageTypes.message: {
              int indexOf = _users.indexWhere((element) {
                return element.nickname == sm.user.nickname;
              });
              if(indexOf!= -1)
                _users[indexOf].addMessage(Message(message: sm.message, type: MessageType.received));
              break;
            }
            case SocketMessageTypes.received: print(message); _streamController.add(sm); break;
            case SocketMessageTypes.login:
              // TODO: Handle this case.
              break;
            case SocketMessageTypes.logout:
              // TODO: Handle this case.
              break;
          }
          if(Shared.currentUser!=null) {
            try {
              users.removeWhere((element) =>
              element.nickname == Shared.currentUser?.nickname
              );
            }catch(e){
              print('probably logged out');
            }
            print(['users', users.length]);
            Shared.onlineUsers.add(users);
          }else{
            print('probably logged out');
          }
        }else{
          print(['error',message]);
          _streamController.add(SocketMessage(type: SocketMessageTypes.login));
        }
      },
      onError: (error){
        print(['error socket',error]);
        isConnected = false;
      },
      onDone: (){
        print('done');
      }
    );
    isConnected = true;
  }

  static Future<bool> login(User user) async {
    if(user != null && isConnected) {
      var login = {
        'type': SocketMessageTypes.login.index,
        'user': user.toJson(),
      };
      var message = jsonEncode(login);
      print(['login', message]);
      webSocketChannel.sink.add(message);
      SocketMessage event = await _streamController.stream.first;
      print(['event',event]);
      if (event?.type == SocketMessageTypes.received){
        if (event.responseForType == SocketMessageTypes.login) {
          return true;
        }
      }
    }
    return false;
  }

  static Future<void> logout() async {
    User user = Shared.currentUser;
    if(user!= null){
      var login = {
        'type':SocketMessageTypes.logout.index,
        'user':user,
      };
      var message = jsonEncode(login);
      print(['logout',SocketMessageTypes.logout, message]);
      await _streamController.close();
      webSocketChannel.sink.add(message);
    }
    return;
  }

  static void sendMessage(User target, String text) {
    var mess = {
      'type':SocketMessageTypes.message.index,
      'target':target,
      'message':text
    };
    _send(mess);
  }

  static void _send(Object mess) {
    String jsonEncoded = jsonEncode(mess);
    print(['send',jsonEncoded]);
    webSocketChannel.sink.add(jsonEncoded);
  }
}