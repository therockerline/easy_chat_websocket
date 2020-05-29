import 'dart:async';

import 'package:easychat/constants.dart';
import 'package:easychat/models/message.dart';
import 'package:easychat/models/user.dart';
import 'package:easychat/services/storage_service.dart';

class Shared{
  // ignore: close_sinks
  static StreamController onlineUsers = StreamController<List<User>>.broadcast();
  static User targetUser;
  static User currentUser;

  static Future<void> setTargetUser(User user) async {
    if(user!=null) {
      dynamic res = await Storage(Constants.boxMessagesSuffix + user.nickname).get() ?? [];
      res.forEach((message) {
        user.addMessage(Message.fromJson(message));
      });
    }
    targetUser = user;
  }

  static void closeStream(){
    onlineUsers.sink.close();
  }
}