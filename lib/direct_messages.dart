import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:socialapp/message/pages/chat_screen.dart';
import 'package:socialapp/message/widgets/loading_widget.dart';
import 'package:socialapp/profilePage.dart';
import 'nav_bar.dart';
import 'home_feed.dart';

class DirectMessagesScreen extends StatefulWidget {
  const DirectMessagesScreen({Key? key}) : super(key: key);

  @override
  State<DirectMessagesScreen> createState() => _DirectMessagesScreenState();
}

class _DirectMessagesScreenState extends State<DirectMessagesScreen> {
  bool _isLoading = true;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late String pfpURL = "";

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  void getUserData() async {
    final user = _auth.currentUser;
    if (user != null) {
      final DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection("users")
          .doc(user.uid)
          .get();
      setState(() {
        pfpURL = doc["pfpURL"];
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: centralAppBarTabs(context, 'Direct Messages', pfpURL),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: 2,
        onTap: (index) {
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    UserProfile(userID: _auth.currentUser!.uid),
              ),
            );
          } else if (index == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const HomeFeedScreen(),
              ),
            );
          }
        },
      ),
      body: _isLoading
          ? const LoadingPage()
          : SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Text(
                      'Messages',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection("users")
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return const Text("Error");
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const LoadingPage();
                      }
                      final currentDocs = snapshot.data?.docs;
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: currentDocs!.length,
                        itemBuilder: (context, index) {
                          final doc = currentDocs[index];
                          final currentUser = _auth.currentUser;
                          if (currentUser != null &&
                              currentUser.uid != doc.id) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (ctx) => ChatPage(
                                        userName: doc["firstName"],
                                        receiverId: doc.id,
                                      ),
                                    ),
                                  );
                                },
                                child: SizedBox(
                                  height: 70,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      CircleAvatar(
                                        radius: 30,
                                        backgroundImage: AssetImage(
                                            'assets/images/profile.png'),
                                        backgroundColor: Colors.blue,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20, vertical: 0),
                                        child: SizedBox(
                                          width: 200,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                doc["firstName"],
                                                style: const TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Text(
                                                doc["email"],
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w300,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          } else {
                            return const SizedBox();
                          }
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
    );
  }
}
