enum MessageType{
  received,
  sended,
}

class Message{
  String message;
  MessageType type;

  Message({this.message, this.type});

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      message: json['message'],
      type: MessageType.values[json['type'] as int],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['type'] = this.type.index;
    return data;
  }
}