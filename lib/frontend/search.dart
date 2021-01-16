import 'package:Hichat/backend/database.dart';
import 'package:Hichat/frontend/message.dart';
import 'package:Hichat/helper/functions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

String name;

class _SearchState extends State<Search> {
  QuerySnapshot snapshot;
  Database database = new Database();
  TextEditingController searchTextEditingController =
      new TextEditingController();
  bool haveUserSearched = false;
  bool isLoading = false;
  initiateSearch() async {
    if (searchTextEditingController.text.isNotEmpty) {
      setState(() {
        isLoading = true;
      });
      await database.getuserinfo(searchTextEditingController.text).then((val) {
        snapshot = val;
        print("$snapshot");
        setState(() {
          isLoading = false;
          haveUserSearched = true;
        });
      });
    }
  }

  createChatroom({String username}) {
    if (username != name) {
      String chatroomID = getchatroomid(username, name);
      List<String> users = [username, name];
      Map<String, dynamic> chatroomMap = {
        "users": users,
        "chatroomID": chatroomID
      };
      database.createChatRoom(chatroomID, chatroomMap);
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => Message(chatroomID)));
    } else {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Oops!!"),
              content: Text("Why You want to talk to yourself!"),
              actions: [
                FlatButton(
                  child: Text("Ok"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          });
    }
  }

  Widget userList() {
    return haveUserSearched
        ? ListView.builder(
            shrinkWrap: true,
            itemCount: snapshot.documents.length,
            itemBuilder: (context, index) {
              return userTile(
                snapshot.documents[index].data["name"],
                snapshot.documents[index].data["email"],
              );
            })
        : Container();
  }

  Widget userTile(String userName, String userEmail) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(userName,
                  style: TextStyle(color: Colors.black, fontSize: 16)),
              Text(
                userEmail,
                style: TextStyle(color: Colors.black, fontSize: 11),
              )
            ],
          ),
          Spacer(),
          GestureDetector(
            onTap: () {
              createChatroom(username: userName);
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                  color: Colors.black, borderRadius: BorderRadius.circular(24)),
              child: Text(
                "Message",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  void initState() {
    getuserinfo();
    super.initState();
  }

  getuserinfo() async {
    name = await SPFunctions.getUserNameSharedPreference();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Center(child: Text("Hi Chat")),
          backgroundColor: Colors.black,
        ),
        body: Container(
            color: Colors.white,
            child: Column(children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                color: Colors.blueGrey,
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: searchTextEditingController,
                        decoration: InputDecoration(
                            hintText: "search username ...",
                            hintStyle: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                            ),
                            border: InputBorder.none),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        initiateSearch();
                      },
                      child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  colors: [
                                    const Color(0x36FFFFFF),
                                    const Color(0x0FFFFFFF)
                                  ],
                                  begin: FractionalOffset.topLeft,
                                  end: FractionalOffset.bottomRight),
                              borderRadius: BorderRadius.circular(50)),
                          padding: EdgeInsets.all(10),
                          child: Icon(Icons.search)),
                    )
                  ],
                ),
              ),
              userList()
            ])));
  }
}

getchatroomid(String a, String b) {
  if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
    return "$b\_$a";
  } else {
    return "$a\_$b";
  }
}
