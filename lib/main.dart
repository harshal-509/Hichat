import 'package:Hichat/Helper/toggle.dart';
import 'package:Hichat/frontend/chats.dart';
import 'package:Hichat/helper/functions.dart';
import 'package:flutter/material.dart';
void main() {
  runApp(MyApp());
}
class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}
class _MyAppState extends State<MyApp> {
  bool isUserloggedin=false;
  @override
  void initState(){
    getloggedinstate();
    super.initState();
  }
  getloggedinstate() async{
    await SPFunctions.getUserLoggedInSharedPreference().then((value) {
      setState(() {
        isUserloggedin=value;
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
     debugShowCheckedModeBanner: false,
      home: isUserloggedin != null ?  isUserloggedin ? Chats() : Authenticate()
          : Container(
        child: Center(
          child: Authenticate(),
        ),
      ),
    );
  }
}