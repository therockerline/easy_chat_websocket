import 'package:easychat/pages/chat/chat.dart';
import 'package:easychat/pages/chat_list/chat_list.dart';
import 'package:easychat/pages/login/login.dart';
import 'package:easychat/services/route_service.dart';
import 'package:easychat/services/session_service.dart';
import 'package:easychat/services/shared.dart';
import 'package:easychat/services/web_socket_service.dart';
import 'package:flutter/material.dart';

void main() async{
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: LoadingPage(),
      routes: {
        LoadingPage.routeName: (context) => RouteController(child: LoadingPage(), routeName: LoadingPage.routeName,),
        Login.routeName: (context) => RouteController(child: Login(), routeName: Login.routeName,),
        ChatList.routeName: (context) => RouteController(child: ChatList(), routeName: ChatList.routeName,),
        Chat.routeName: (context) => RouteController(child: Chat(), routeName: Chat.routeName,),
      },
    );
  }
}

class LoadingPage extends StatefulWidget {
  static String routeName= '/loadingPage';
  LoadingPage({Key key}) : super(key: key);

  @override
  _LoadingPageState createState() {
    return _LoadingPageState();
  }
}

class _LoadingPageState extends State<LoadingPage> {

  Future<void> initialize() async {
    await SessionService.init();
    print(['before run main',Shared.currentUser?.nickname]);
    String initRoute = ChatList.routeName;
    WebSocketService.init();
    if(Shared.currentUser == null){
      initRoute = Login.routeName;
    }else {
      WebSocketService.login(Shared.currentUser);
    }
    Navigator.pushReplacementNamed(context, initRoute);
    print(['main',Shared.currentUser?.nickname, initRoute]);
  }
  @override
  void initState() {
    initialize();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        body: Align(
          alignment: Alignment.center,
          child: Container(
                width: 80,
                height: 80,
                child: CircularProgressIndicator())
          )
    );
  }
}