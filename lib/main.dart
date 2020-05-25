import 'dart:convert';
import 'dart:math';

import 'package:easychat/pages/chat/chat.dart';
import 'package:easychat/pages/chat_list/chat_list.dart';
import 'package:easychat/services/route_service.dart';
import 'package:easychat/services/shared.dart';
import 'package:flutter/material.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    Shared.appKey = 8000 + Random.secure().nextInt(200);
    if(UniversalPlatform.isWeb)
      Shared.webSocketChannel =  WebSocketChannel.connect(Uri.parse('ws://localhost:8080'));
    else
      Shared.webSocketChannel =  IOWebSocketChannel.connect(Uri.parse('ws://localhost:8080'));
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: ChatList.routeName,
      routes: {
        Chat.routeName: (context) => RouteController(child: Chat(), routeName: Chat.routeName,),
        ChatList.routeName: (context) => RouteController(child: ChatList(), routeName: ChatList.routeName,),
      },
    );
  }
}
