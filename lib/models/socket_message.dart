
import 'package:easychat/models/user.dart';
enum SocketMessageTypes {
  login,
  logout,
  userUpdate,
  message,
  received
}
class SocketMessage {
  SocketMessageTypes type;
  SocketMessageTypes responseForType;
  String message;
  User user;
  List<User> userCollection;
  SocketMessage({this.type, this.user, this.userCollection, this.message, this.responseForType});

  factory SocketMessage.fromJson(Map<String, dynamic> json) {
    print(json);
    switch (SocketMessageTypes.values[json['type']]){
      case SocketMessageTypes.login: return SocketMessage.fromLoginJson(json);
      case SocketMessageTypes.userUpdate: return SocketMessage.fromUserUpdateJson(json);
      case SocketMessageTypes.message: return SocketMessage.fromMessageJson(json);
      case SocketMessageTypes.received: return SocketMessage.fromReceivedJson(json);
      default: return null;
    }
  }

  factory SocketMessage.fromLoginJson(Map<String, dynamic> json){
    return SocketMessage(
        type: SocketMessageTypes.values[json['type']],
        user: User.fromJson(json['user'] as Map<String, dynamic>)
    );
  }

  factory SocketMessage.fromUserUpdateJson(Map<String, dynamic> json){
    List<User> users = (json['userCollection'] as List).map((e) => User.fromJson(e as Map<String, dynamic>)).toList();
    //print(users);
    return SocketMessage(
        type: SocketMessageTypes.values[json['type']],
        userCollection: users
    );
  }

  factory SocketMessage.fromMessageJson(Map<String, dynamic> json){
    return SocketMessage(
      type: SocketMessageTypes.values[json['type']],
      message: json['message'] as String,
      user: User.fromJson(json['user'] as Map<String, dynamic>),
    );
  }

  factory SocketMessage.fromReceivedJson(Map<String, dynamic> json) {
    return SocketMessage(
      type: SocketMessageTypes.values[json['type']],
      responseForType: SocketMessageTypes.values[json['responseForType']],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['type'] = type.index;
    return data;
  }


}