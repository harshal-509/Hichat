import 'package:Hichat/backend/auth.dart';
import 'package:flutter/material.dart';
class Forgetpassword extends StatefulWidget {
  @override
  _ForgetpasswordState createState() => _ForgetpasswordState();
}

class _ForgetpasswordState extends State<Forgetpassword> {
  AuthService authService=new AuthService();
  final formkey=GlobalKey<FormState>();
  TextEditingController emailTexteditingcontroller=new TextEditingController();
  
  forgetpassword() async{
    if(formkey.currentState.validate()){
      await authService.forgetPassword(emailTexteditingcontroller.text,context);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar:AppBar( 
          title: Center(child: Text("Hi Chat")),
          backgroundColor: Colors.black,
      ),
      body:SingleChildScrollView(
              child: Container(
                  color: Colors.white,
                  height: MediaQuery.of(context).size.height-85,
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      Spacer(),
                      Form(key: formkey,
                        child: Column(
                          children: [
                            Text("FORGOTTEN PASSWORD",
                            style:TextStyle(color: Colors.black, fontSize: 26,fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text("We will send you a password reset link on this email",
                            style:TextStyle(color: Colors.black, fontSize: 13)),
                            TextFormField(
                               validator: (val){
                      return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(val) ?
                          null : "Enter correct email";
                    },
                           controller:emailTexteditingcontroller,
                          style:TextStyle(color: Colors.black, fontSize: 16),
                          decoration:InputDecoration(
      hintText: "email",
      hintStyle: TextStyle(color: Colors.black),
      focusedBorder:
          UnderlineInputBorder(borderSide: BorderSide(color: Colors.black)),
      enabledBorder:
          UnderlineInputBorder(borderSide: BorderSide(color: Colors.black)
          )
          )
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      GestureDetector(
                        onTap: () {
                          forgetpassword();
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                                color:Colors.black
                              ),
                          width: MediaQuery.of(context).size.width/2,
                          child: Text(
                            "Send Email",
                            style:
                              TextStyle(fontSize: 17,color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      SizedBox(
                      height: 150,
                      )
                    ],
                  ),
                ),
      ),
    );
  }
}