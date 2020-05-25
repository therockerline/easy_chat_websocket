
class User {
  String nickname;
  int port;
  List<String> messages = [];
  List<String> readedMessages = [];

  User({this.nickname, this.port});

  addMessage(String message){
    messages.add(message);
    readedMessages.add(message);
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
