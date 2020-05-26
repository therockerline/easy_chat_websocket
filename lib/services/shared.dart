import 'dart:async';

import 'package:easychat/models/user.dart';

class Shared{
  static StreamController onlineUsers = StreamController<List<User>>.broadcast();
  static User targetUser = null;
  static User currentUser;

  static void setTargetUser(User user) {
    targetUser = user;
  }
}