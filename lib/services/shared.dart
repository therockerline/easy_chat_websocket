import 'dart:async';

import 'package:easychat/models/user.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class Shared{
  static int appKey;
  static WebSocketChannel webSocketChannel;
  static StreamController onlineUsers = StreamController<List<User>>.broadcast();
}