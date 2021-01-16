import 'package:Hichat/frontend/signin.dart';
import 'package:Hichat/frontend/signup.dart';
import 'package:flutter/material.dart';
class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
    bool showsignin=true;
  void toggle(){
    setState(() {
      showsignin=!showsignin;
    });
  }  
  @override
  Widget build(BuildContext context) {
    if(showsignin==true){
      return Signin(toggle);
    }
    else{
      return Signup(toggle);
    }
  }
}