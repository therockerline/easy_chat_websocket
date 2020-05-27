
import 'dart:async';
import 'dart:convert';
import 'package:easychat/constants.dart';
import 'package:easychat/models/message.dart';
import 'package:easychat/services/storage_service.dart';

class User {
  String nickname;
  List<Message> messages = [];
  StreamController<void> updater = StreamController<void>.broadcast();

  User({this.nickname});

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
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['nickname'] = this.nickname;
    return data;
  }
}
