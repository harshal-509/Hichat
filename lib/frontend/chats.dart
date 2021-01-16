import 'package:Hichat/backend/auth.dart';
import 'package:Hichat/backend/database.dart';
import 'package:Hichat/frontend/message.dart';
import 'package:Hichat/frontend/search.dart';
import 'package:Hichat/helper/functions.dart';
import 'package:Hichat/model/myname.dart';
import 'package:flutter/material.dart';
import 'package:Hichat/helper/toggle.dart';

class Chats extends StatefulWidget {
  @override
  _ChatsState createState() => _ChatsState();
}

class _ChatsState extends State<Chats> {
  AuthService authService = new AuthService();
  Database database = new Database();
  Stream chatroomstream;
  Widget chatroomList() {
    return StreamBuilder(
      stream: chatroomstream,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data.documents.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return ChatRoomsTile(
                    snapshot.data.documents[index].data["chatroomID"]
                        .toString()
                        .replaceAll("_", "")
                        .replaceAll(Name.myname, ""),
                    snapshot.data.documents[index].data["chatroomID"],
                  );
                })
            : Container();
      },
    );
  }

  @override
  void initState() {
    getuserinfo();
    super.initState();
  }

  getuserinfo() async {
    Name.myname = await SPFunctions.getUserNameSharedPreference();
    database.getchatroom(Name.myname).then((val) {
      setState(() {
        chatroomstream = val;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Center(child: Text("Hi Chat")),
        backgroundColor: Colors.black,
        actions: [
          GestureDetector(
            onTap: () {
              SPFunctions.saveUserLoggedInSharedPreference(false);
              AuthService().signOut();
              AuthService().signoutgoogle();
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => Authenticate()));
            },
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Icon(Icons.exit_to_app)),
          )
        ],
      ),
      body: chatroomList(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        child: Icon(Icons.search),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Search()));
        },
      ),
    );
  }
}

class ChatRoomsTile extends StatelessWidget {
  final String userName;
  final String chatRoomId;
  ChatRoomsTile(this.userName, this.chatRoomId);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => Message(chatRoomId)));
      },
      child: Container(
        color: Colors.black26,
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Row(
          children: [
            Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                  color: Colors.black, borderRadius: BorderRadius.circular(30)),
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Text(userName.substring(0, 1),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontFamily: 'OverpassRegular',
                        fontWeight: FontWeight.w300)),
              ),
            ),
            SizedBox(
              width: 12,
            ),
            Text(userName,
                textAlign: TextAlign.start,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontFamily: 'OverpassRegular',
                    fontWeight: FontWeight.w300))
          ],
        ),
      ),
    );
  }
}
