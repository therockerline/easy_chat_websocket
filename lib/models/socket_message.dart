
import 'package:easychat/models/user.dart';

class SocketMessage {
  String type;
  String message;
  User user;
  List<User> userCollection;
  SocketMessage({this.type, this.user, this.userCollection, this.message});

  factory SocketMessage.fromJson(Map<String, dynamic> json) {
    print(json);
    switch (json['type']){
      case 'login': return SocketMessage.fromLoginJson(json);
      case 'userUpdate': return SocketMessage.fromUserUpdateJson(json);
      case 'message': return SocketMessage.fromMessageJson(json);
      default: return null;
    }
  }

  factory SocketMessage.fromLoginJson(Map<String, dynamic> json){
    return SocketMessage(
        type: json['type'],
        user: User.fromJson(json['user'] as Map<String, dynamic>)
    );
  }

  factory SocketMessage.fromUserUpdateJson(Map<String, dynamic> json){
    List<User> users = (json['userCollection'] as List).map((e) => User.fromJson(e as Map<String, dynamic>)).toList();
    //print(users);
    return SocketMessage(
        type: json['type'],
        userCollection: users
    );
  }

  factory SocketMessage.fromMessageJson(Map<String, dynamic> json){
    return SocketMessage(
      type: json['type'],
      message: json['message'] as String,
      user: User.fromJson(json['user'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['type'] = type;
    return data;
  }
}