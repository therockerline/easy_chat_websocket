import 'package:easychat/models/user.dart';
import 'package:flutter/material.dart';

class ChatListItem extends StatefulWidget {
  final User user;
  final Function click;
  ChatListItem({Key key, this.user,this.click}) : super(key: key);

  @override
  _ChatListItemState createState() {
    return _ChatListItemState();
  }
}

class _ChatListItemState extends State<ChatListItem> {
  List<User> users = [];
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
    // TODO: implement build
    return Container(
      child: FlatButton(
        onPressed: widget.click,
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: CircleAvatar(
                backgroundColor: Colors.green,
              ),
            ),
            Text(widget.user.nickname),
            Spacer(),
            Text("${widget.user.messages.length}")
          ],
        ),
      ),
    );
  }
}