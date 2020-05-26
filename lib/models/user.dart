
import 'dart:async';

import 'package:easychat/models/message.dart';

class User {
  String nickname;
  int port;
  List<Message> messages = [];
  StreamController<void> updater = StreamController<void>.broadcast();

  User({this.nickname, this.port = 8080});

  addMessage(Message message){
    messages.add(message);
    updater.add(null);
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      nickname: json['nickname'],
      port: json['port'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['nickname'] = this.nickname;
    data['port'] = this.port;
    return data;
  }
}
