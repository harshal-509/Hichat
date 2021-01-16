import 'package:cloud_firestore/cloud_firestore.dart';

class Database {
  uploaduserinfo(userMap) {
    Firestore.instance.collection("users").add(userMap);
  }

  getuserinfo(String username) async {
    return await Firestore.instance
        .collection("users")
        .where("name", isEqualTo: username)
        .getDocuments();
  }

  getuseremailinfo(String useremail) async {
    return await Firestore.instance
        .collection("users")
        .where("email", isEqualTo: useremail)
        .getDocuments();
  }

  createChatRoom(String chatroomID, chatroommap) {
    Firestore.instance
        .collection("Chatroom")
        .document(chatroomID)
        .setData(chatroommap)
        .catchError((e) {
      print(e);
    });
  }

  addconversation(String chatroomID, chatMap) {
    Firestore.instance
        .collection("Chatroom")
        .document(chatroomID)
        .collection("chats")
        .add(chatMap)
        .catchError((e) {
      print(e.toString());
    });
  }

  getconversation(String chatroomID) async {
    return Firestore.instance
        .collection("Chatroom")
        .document(chatroomID)
        .collection("chats")
        .orderBy("time", descending: true)
        .snapshots();
  }

  getchatroom(String username) async {
    return Firestore.instance
        .collection("Chatroom")
        .where("users", arrayContains: username)
        .snapshots();
  }
}
