import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:socialapp/message/widgets/loading_widget.dart';
import 'package:socialapp/message/widgets/receiver_box.dart';
import 'package:socialapp/message/widgets/sender_box.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({
    super.key,
    required this.userName,
    required this.receiverId,
  });

  final String userName;
  final String receiverId;

  @override
  State<StatefulWidget> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final TextEditingController messageController = TextEditingController();

  Future<void> messageMethod(String receiverID, String message) async {
    final Timestamp timestamp = Timestamp.now();
    final String senderID = _auth.currentUser!.uid;
    late String email;
    late String firstName;
    Stream<QuerySnapshot> snapshot = _db.collection("users").snapshots();
    snapshot.listen((event) async {
      for (var doc in event.docs) {
        if (senderID == await doc.get("id")) {
          email = await doc.get("email");
          firstName = await doc.get("nameFirst");
          break;
        }
      }

      // Add message to database
      List<String> chatID = [senderID, receiverID];
      chatID.sort();
      String chatRoom = chatID.join("-");
      await _db
          .collection("chatRoom")
          .doc(chatRoom)
          .collection("messages")
          .add({
        "senderID": senderID,
        "senderEmail": email,
        "senderName": firstName,
        "receiverID": receiverID,
        "time": timestamp,
        "message": message,
      });
      return;
    });
  }

  void sendMessage(String message) async {
    if (message.isNotEmpty) {
      await messageMethod(widget.receiverId, message);
      messageController.clear();
    }
  }

  Stream<QuerySnapshot<Object?>> getMessage(
      String senderID, String receiverID) {
    List<String> chatID = [senderID, receiverID];
    chatID.sort();
    String chatRoom = chatID.join("-");
    Stream<QuerySnapshot> snapshot = _db
        .collection("chatRoom")
        .doc(chatRoom)
        .collection("messages")
        .orderBy("time", descending: false)
        .snapshots();
    return snapshot;
  }

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 4,
        toolbarHeight: 60,
        shadowColor: const Color.fromARGB(255, 53, 52, 52),
        leading: IconButton(
          iconSize: 32,
          onPressed: () {
            FocusScope.of(context).unfocus();
            Future.delayed(const Duration(milliseconds: 300), () {
              Navigator.of(context).pop();
            });
          },
          icon: const Icon(Icons.arrow_back),
        ),
        title: Row(
          children: [
            const CircleAvatar(
              radius: 24,
              backgroundImage: AssetImage('assets/images/profile.png'),
              backgroundColor: Colors.blue,
            ),
            const SizedBox(
              width: 16,
            ),
            Text(
              widget.userName,
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                stream: getMessage(_auth.currentUser!.uid, widget.receiverId),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Text("Error");
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const LoadingPage();
                  }
                  return ListView(
                    children: snapshot.data!.docs
                        .map((DocumentSnapshot document) {
                          Map<String, dynamic> data =
                              document.data() as Map<String, dynamic>;
                          if (_auth.currentUser!.uid == data["senderID"]) {
                            return SenderBox(
                              currentUserId: _auth.currentUser!.uid,
                              senderId: data["senderID"],
                              message: data["message"],
                              name: data["senderName"],
                            );
                          } else {
                            return ReceiverBox(
                              currentUserId: _auth.currentUser!.uid,
                              senderId: data["senderID"],
                              message: data["message"],
                              name: data["senderName"],
                            );
                          }
                        })
                        .toList()
                        .cast(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomSheet: Container(
        height: 56,
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              blurRadius: 10,
              spreadRadius: 2,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              alignment: Alignment.centerRight,
              width: 300,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: messageController,
                  autofocus: true,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    hintText: "Enter Message",
                    isDense: true,
                    contentPadding: const EdgeInsets.all(12.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                  ),
                ),
              ),
            ),
            IconButton(
              iconSize: 32,
              icon: const Icon(Icons.send),
              onPressed: () => sendMessage(messageController.text),
            ),
          ],
        ),
      ),
    );
  }
}
