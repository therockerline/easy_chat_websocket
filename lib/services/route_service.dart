import 'package:flutter/material.dart';

class RouteService{

  static String getCurrentPage(){
    return history.last;
  }
  static List<String> history = [];

  static void add(String routeName){
    history.add(routeName);
    //print(history);
  }

  static void remove(String pageName) {
    history.remove(pageName);
    //print(history);
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
    return widget.child;
  }
}
