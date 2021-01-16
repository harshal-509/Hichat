import 'dart:async';

import 'package:Hichat/backend/database.dart';
import 'package:Hichat/model/myname.dart';
import 'package:flutter/material.dart';

class Message extends StatefulWidget {
  final String chatroomID;
  Message(this.chatroomID);
  @override
  _MessageState createState() => _MessageState();
}

class _MessageState extends State<Message> {
  ScrollController _controller = ScrollController();
  Database database = new Database();
  TextEditingController messagetexteditingcontroller =
      new TextEditingController();
  Stream messagestream;
  Widget messageshow() {
    return Container(
      margin: EdgeInsets.only(bottom: 80),
      child: StreamBuilder(
        stream: messagestream,
        builder: (context, snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  itemCount: snapshot.data.documents.length,
                  shrinkWrap: true,
                  reverse: true,
                  controller: _controller,
                  itemBuilder: (context, index) {
                    return MessageTile(
                        snapshot.data.documents[index].data["message"],
                        Name.myname ==
                            snapshot.data.documents[index].data["sendby"]);
                  })
              : Container();
        },
      ),
    );
  }

  addMessage() {
    if (messagetexteditingcontroller.text.isNotEmpty) {
      Map<String, dynamic> chatMap = {
        "message": messagetexteditingcontroller.text,
        "sendby": Name.myname,
        "time": DateTime.now().microsecondsSinceEpoch
      };
      if (_controller.hasClients) {
        Timer(Duration(milliseconds: 500),
            () => _controller.jumpTo(_controller.position.minScrollExtent));
      }
      database.addconversation(widget.chatroomID, chatMap);
      setState(() {
        messagetexteditingcontroller.text = "";
      });
    }
  }

  @override
  void initState() {
    database.getconversation(widget.chatroomID).then((val) {
      setState(() {
        messagestream = val;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Center(child: Text("Message")),
        backgroundColor: Colors.black,
      ),
      body: Container(
        child: Stack(
          children: [
            messageshow(),
            Container(
              alignment: Alignment.bottomCenter,
              width: MediaQuery.of(context).size.width,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 5),
                color: Colors.black,
                child: Row(
                  children: [
                    Expanded(
                        child: TextField(
                      onTap: () {
                        if (_controller.hasClients) {
                          Timer(
                              Duration(milliseconds: 300),
                              () => _controller.jumpTo(
                                  _controller.position.minScrollExtent));
                        }
                      },
                      controller: messagetexteditingcontroller,
                      style: TextStyle(color: Colors.white, fontSize: 16),
                      decoration: InputDecoration(
                          hintText: "Message ...",
                          hintStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                          border: InputBorder.none),
                    )),
                    SizedBox(
                      width: 16,
                    ),
                    GestureDetector(
                      onTap: () {
                        addMessage();
                      },
                      child: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(40)),
                        padding: EdgeInsets.all(10),
                        child: Icon(Icons.send),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageTile extends StatelessWidget {
  final String message;
  final bool me;
  MessageTile(this.message, this.me);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          top: 8, bottom: 8, left: me ? 0 : 24, right: me ? 24 : 0),
      alignment: me ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: me ? EdgeInsets.only(left: 30) : EdgeInsets.only(right: 30),
        padding: EdgeInsets.only(top: 17, bottom: 17, left: 20, right: 20),
        decoration: BoxDecoration(
          borderRadius: me
              ? BorderRadius.only(
                  topLeft: Radius.circular(23),
                  topRight: Radius.circular(23),
                  bottomLeft: Radius.circular(23))
              : BorderRadius.only(
                  topLeft: Radius.circular(23),
                  topRight: Radius.circular(23),
                  bottomRight: Radius.circular(23)),
          color: Colors.black,
        ),
        child: Text(message,
            textAlign: TextAlign.start,
            style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontFamily: 'OverpassRegular',
                fontWeight: FontWeight.w300)),
      ),
    );
  }
}
