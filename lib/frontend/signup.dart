import 'package:Hichat/backend/auth.dart';
import 'package:Hichat/backend/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
class Not{
  static bool nothing=false;
}
class Signup extends StatefulWidget {
  final Function toggle;
    Signup(this.toggle);
  @override
  _SignupState createState() => _SignupState();
}
class _SignupState extends State<Signup> {
bool isLoading=false;
final formkey=GlobalKey<FormState>();
 TextEditingController usernameTextEditingController=new TextEditingController();
 TextEditingController emailTextEditingController=new TextEditingController();
 TextEditingController passwordTextEditingController=new TextEditingController();
AuthService authService=new AuthService();
Database database=new Database();
signupuser() async{
  if(formkey.currentState.validate()){
    setState(() {
      isLoading=true;
    });
     final QuerySnapshot result = await Firestore.instance.collection('users').where('name', isEqualTo: usernameTextEditingController.text).getDocuments();
     final List < DocumentSnapshot > documents = result.documents;
     final QuerySnapshot result1 = await Firestore.instance.collection('users').where('email', isEqualTo:emailTextEditingController.text).getDocuments();
     final List < DocumentSnapshot > documents1 = result1.documents;
    if(documents.length==0){
        if(documents1.length==0){ 
         Map<String,String> userMap={
      "email":emailTextEditingController.text,
      "name":usernameTextEditingController.text,
      "password":passwordTextEditingController.text
    }; 
         database.uploaduserinfo(userMap);
    }}
    else{
        setState(() {
            Not.nothing=true;
          });
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Error"),
              content: Text("Username Already Exists.\nPlease use another username."),
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
    authService.signUpWithEmailAndPassword(emailTextEditingController.text, passwordTextEditingController.text,context).then((val){
      if(val!=null){
           widget.toggle();
      }
      else{
        setState(() {
          isLoading=false;
        });
      }
    });
  }
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      return (val.isEmpty || val.length < 3 )? "Enter Username 3+ characters" : null;
                    },
                               controller: usernameTextEditingController,
                              style:TextStyle(color: Colors.black, fontSize: 16),
                              decoration: InputDecoration(
      hintText: "username",
      hintStyle: TextStyle(color: Colors.black),
      focusedBorder:
          UnderlineInputBorder(borderSide: BorderSide(color: Colors.black)),
      enabledBorder:
          UnderlineInputBorder(borderSide: BorderSide(color: Colors.black)
          )
          )
                            ),
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
                               controller: passwordTextEditingController,
                              style:TextStyle(color: Colors.black, fontSize: 16),
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
                      SizedBox(
                        height: 16,
                      ),
                      GestureDetector(
                        onTap: () {
                          signupuser();
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                               color: Colors.black
                              ),
                          width: MediaQuery.of(context).size.width,
                          child: Text(
                            "Sign Up",
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
                  "Already have an account? ",
              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,)
                                  ),
                GestureDetector(
                  onTap: () {
                    widget.toggle();
                  },
                  child: Text(
                    "SignIn now",
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
      )
    );
  }
}