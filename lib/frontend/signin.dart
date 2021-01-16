import 'package:Hichat/backend/auth.dart';
import 'package:Hichat/backend/database.dart';
import 'package:Hichat/frontend/forgetpassword.dart';
import 'package:Hichat/helper/functions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'chats.dart';
class Signin extends StatefulWidget {
    final Function toggle;
    Signin(this.toggle);
  @override
  _SigninState createState() => _SigninState();
}
class _SigninState extends State<Signin> {
  Database database=new Database();
  AuthService authService=new AuthService();
  final formkey=GlobalKey<FormState>();
 TextEditingController emailTextEditingController=new TextEditingController();
 TextEditingController passwordTextEditingController=new TextEditingController();
  bool isLoading=false;
  QuerySnapshot snapshot;
 signinUser() async{
   if(formkey.currentState.validate()){
     setState(() {
       isLoading=true;
     });  
    await authService.signInWithEmailAndPassword(emailTextEditingController.text, passwordTextEditingController.text,context).then((val) async{
      if(val!=null){
         snapshot = await database.getuseremailinfo(emailTextEditingController.text);
         SPFunctions.saveUserLoggedInSharedPreference(true);
         SPFunctions.saveUserNameSharedPreference(snapshot.documents[0].data["name"]);
         SPFunctions.saveUserEmailSharedPreference(snapshot.documents[0].data["email"]);
         Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => Chats()));
     }  
    else{
       setState(() {
         isLoading=false;
       });
     }} 
     );
 }
 }
  signinUserGoogle() async{
   await authService.signInWithGoogle(context).then((val) async{
     Navigator.of(context).popUntil((route) => route.isFirst);
      if(val!=null){
        final QuerySnapshot result = await Firestore.instance.collection('users').where('name', isEqualTo: val.displayName).getDocuments();
        final List < DocumentSnapshot > documents = result.documents;
        final QuerySnapshot result1 = await Firestore.instance.collection('users').where('email', isEqualTo:val.email).getDocuments();
        final List < DocumentSnapshot > documents1 = result1.documents;
        if(documents.length==0){ 
          if(documents1.length==0){ 
          Map<String,String> userMap={
          "email":val.email,
          "name":val.displayName,
          "image":val.photoUrl,
          "phone":val.phoneNumber
        };
         database.uploaduserinfo(userMap);
        }
        }
         snapshot =await database.getuseremailinfo(val.email);
         SPFunctions.saveUserLoggedInSharedPreference(true);
         SPFunctions.saveUserNameSharedPreference(snapshot.documents[0].data["name"]);
         SPFunctions.saveUserEmailSharedPreference(snapshot.documents[0].data["email"]);
         Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => Chats()));
     }  
    else{
       setState(() {
         isLoading=false;
       });
     }}
     );
 }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        appBar:AppBar( 
          title: Center(child: Text("Hi Chat")),
          backgroundColor: Colors.black,
      ),
      body: isLoading? Container(
        child: Center(child: CircularProgressIndicator()),
      ): SingleChildScrollView(
              child: Container(
                  color: Colors.white,
                  height: MediaQuery.of(context).size.height-85,
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      Spacer(),
                      Form(
                        key: formkey,
                        child: Column(
                          children: [
                            TextFormField(
                               validator: (val){
                      return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(val) ?
                          null : "Enter correct email";
                    },
                              controller: emailTextEditingController,
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
                             TextFormField(
                              style:TextStyle(color: Colors.black, fontSize: 16),
                              controller: passwordTextEditingController,
                              obscureText: true,
                              validator: (val) {
                                return val.length > 6
                                    ? null
                                    : "Enter Password 6+ characters";
                              },
                              decoration: InputDecoration(
      hintText: "password",
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: (){
                              Navigator.push(context,MaterialPageRoute(builder: (context)=>Forgetpassword()));
                            },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 8),
                                  child: Text(
                                    "Forgot Password?",
                                  style:TextStyle(color: Colors.black, fontSize: 13),)
                                  ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      GestureDetector(
                        onTap: () {
                            signinUser();
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                               color: Colors.black,
                            ),
                          width: MediaQuery.of(context).size.width,
                          child: Text(
                            "Sign In",
                            style:
                              TextStyle(fontSize: 17,color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      GestureDetector(
                        onTap: (){
                          signinUserGoogle();
                        },
                      child: Container(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: Colors.black),
                          width: MediaQuery.of(context).size.width,
                          child: Text(
                            "Sign In with Google",
                            style:
                                TextStyle(fontSize: 17,color: Colors.white),
                            textAlign: TextAlign.center, 
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Don't have account? ",
                            style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,))
                                  ,
                         GestureDetector(
                           onTap: (){
                              widget.toggle();
                           },
                              child: Text(
                                "Register now",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    decoration: TextDecoration.underline),
                              ),
                          ),
                          ],
                      ),
                      SizedBox(
                      height: 50,
                      )
                    ],
                  ),
                ),
      ),
    );
  }
}

