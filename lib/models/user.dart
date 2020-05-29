
import 'dart:async';
import 'package:easychat/constants.dart';
import 'package:easychat/models/message.dart';
import 'package:easychat/services/storage_service.dart';
import 'package:flutter/cupertino.dart';

class User {
  bool isOnline;
  String nickname;
  List<Message> messages = [];
  StreamController<void> updater = StreamController<void>.broadcast();

  User({@required this.nickname,@required this.isOnline});

  addMessage(Message message) async {
    messages.add(message);
    List<Map<String,dynamic>> jsonMess =  messages.map((e) => e.toJson()).toList();
    print(jsonMess);
    await Storage(Constants.boxMessagesSuffix+nickname).set(jsonMess);
    updater.add(null);
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      nickname: json['nickname'],
      isOnline: json['isOnline']
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['nickname'] = this.nickname;
    data['isOnline'] = this.isOnline;
    return data;
  }
}
