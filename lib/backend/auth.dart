import 'package:Hichat/frontend/chats.dart';
import 'package:Hichat/frontend/signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:Hichat/model/user.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User _userFromFirebaseUser(FirebaseUser user) {
    return user != null ? User(uid: user.uid) : null;
  }
  Future signInWithEmailAndPassword(String email, String password,BuildContext context) async {
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = result.user;
      if(user.isEmailVerified && user!=null){
     return _userFromFirebaseUser(user);
      }
     else{
       showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Error"),
              content: Text("Please Verify Your Email First"),
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
      catch(err) {
          showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Error"),
              content: Text(err.toString()),
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
    }}
  Future signUpWithEmailAndPassword(String email, String password,BuildContext context) async {
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = result.user;
      if(Not.nothing!=true){
      try{
        await user.sendEmailVerification();
         showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Confirmation"),
              content: Text("Confirmation mail has been sent to your Email address\nPlease check your mail"),
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
        return _userFromFirebaseUser(user);
      }
     catch(err) {
          showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Error"),
              content: Text(err.toString()),
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
    }}
    } catch(err) {
          showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Error"),
              content: Text(err.toString()),
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
  Future forgetPassword(String email,BuildContext context) async {
    try {
      return await _auth.sendPasswordResetEmail(email: email);
    } catch(err) {
          showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Error"),
              content: Text(err.message),
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
  Future<FirebaseUser> signInWithGoogle(BuildContext context) async {
    try{final GoogleSignIn _googleSignIn = new GoogleSignIn();

    final GoogleSignInAccount googleSignInAccount =
        await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken);

    AuthResult result = await _auth.signInWithCredential(credential);
    FirebaseUser userDetails = result.user;
    if (result == null) {
    } else {
      Navigator.push(context, MaterialPageRoute(builder: (context) => Chats()));
    }
    return userDetails;
  }catch(err){
          showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Error"),
              content: Text(err.toString()),
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
      return null;
    }
  }
  
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
  Future signoutgoogle() async{
    final GoogleSignIn _googleSignIn = new GoogleSignIn();
    try {
      return await _googleSignIn.signOut();      
    }
    catch(e){
      print(e.toString());
      return null;
    }
  }
}