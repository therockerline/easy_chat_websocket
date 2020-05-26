enum MessageType{
  received,
  sended,
}

class Message{
  String message;
  MessageType type;

  Message({this.message, this.type});
}