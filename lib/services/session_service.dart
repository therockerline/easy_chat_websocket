import 'package:easychat/models/user.dart';
import 'package:easychat/services/shared.dart';
import 'package:easychat/services/storage_service.dart';
import 'package:easychat/services/web_socket_service.dart';

import '../constants.dart';

class SessionService{

  static Future<void> init() async{
    String nickname = await Storage(Constants.boxUserId).get();
    print(['user',nickname]);
    Shared.currentUser = nickname!=null?User(nickname: nickname, isOnline: true): null;
  }

  static Future<void> logout() async{
    await WebSocketService.logout();
    await Storage(Constants.boxUserId).set(null);
  }
}