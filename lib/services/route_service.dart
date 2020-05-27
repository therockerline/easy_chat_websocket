import 'package:easychat/models/user.dart';
import 'package:easychat/services/shared.dart';
import 'package:flutter/material.dart';

class RouteService{

  static String getCurrentPage(){
    return history.last;
  }
  static List<String> history = [];

  static void add(String routeName){
    history.add(routeName);
    print(['add',routeName, history]);
  }

  static void remove(String routeName) {
    history.remove(routeName);
    print(['remove',routeName, history]);
  }

}

class RouteController extends StatefulWidget {
  final Widget child;
  final String routeName;
  RouteController({Key key, @required this.child, @required this.routeName}) : super(key: key);

  @override
  _RouteControllerState createState() {
    return _RouteControllerState();
  }
}

class _RouteControllerState extends State<RouteController> {
  List<User> users = [];
  @override
  void initState() {
    RouteService.add(widget.routeName);
    super.initState();
  }

  @override
  void dispose() {
    RouteService.remove(widget.routeName);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Stack(
        alignment: Alignment.topLeft,
        fit: StackFit.expand,
        children:[
          widget.child ?? Text(widget.routeName),
          if(false)Positioned(
            bottom: 10,
            right: 10,
            child: StreamBuilder<List<User>>(
              stream: Shared.onlineUsers.stream,
              initialData: [],
              builder: (context, snapshot){
                if(snapshot.hasData){
                  print(snapshot.data);
                  users = snapshot.data;
                }
                return Column(
                  children: users.isNotEmpty ? users.map((e) {
                    return Text(e.nickname);
                  }).toList() : []
                );
              },
            ),
          )
        ]
      ),
    );
  }
}
