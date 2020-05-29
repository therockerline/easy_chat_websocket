import 'package:easychat/constants.dart';
import 'package:easychat/pages/chat_list/chat_list.dart';
import 'package:easychat/services/session_service.dart';
import 'package:easychat/services/shared.dart';
import 'package:easychat/services/storage_service.dart';
import 'package:easychat/services/web_socket_service.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  static String routeName = '/login';

  Login({Key key}) : super(key: key);

  @override
  _LoginState createState() {
    return _LoginState();
  }
}

class _LoginState extends State<Login> {
  TextEditingController _controller = TextEditingController();
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login on EasyChat'),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: 100,
        child: Column(
          children: [
            Form(
              child: TextFormField(
                controller: _controller,
                decoration: InputDecoration(
                  icon: Column(
                    children: [
                      Icon(Icons.person),
                    ],
                  ),
                  labelText: 'Username',
                ),
                onEditingComplete: login,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void login() {
    if(_controller.text.isNotEmpty) {
      Navigator.pop(context, _controller.text);
    }
  }
}