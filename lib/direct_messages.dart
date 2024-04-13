import 'package:flutter/material.dart';
import 'package:socialapp/pages/chat_screen.dart';
import 'package:socialapp/user_profile.dart';
import 'package:socialapp/widgets/loading_widget.dart';
import 'nav_bar.dart';
import 'home_feed.dart';

class DirectMessagesScreen extends StatefulWidget {
  const DirectMessagesScreen({super.key});

  @override
  State<DirectMessagesScreen> createState() => _DirectMessagesScreenState();
}

class _DirectMessagesScreenState extends State<DirectMessagesScreen> {
  bool _isLoading = true;
  final List<String> _demoList = [
    "Demo 1",
    "Demo 2",
    "Demo 3",
    "Demo 4",
    "Demo 5",
    "Demo 6",
    "Demo 7",
    "Demo 8",
  ];

  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 1000), () {
      setState(() {
        _isLoading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: centralAppBarTabs(context, 'Direct Messages'),
      bottomNavigationBar: CustomBottomNavigationBar(
          currentIndex: 2,
          onTap: (index) {
            if (index == 1) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UserProfileScreen(),
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
          }),
      body: _isLoading
          ? const LoadingPage()
          : SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
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
                  const Padding(
                    padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: Text(
                      'Active user - (${8})',
                      style: TextStyle(
                        color: Color.fromARGB(255, 72, 72, 72),
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 20),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 25),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.elliptical(30, 25),
                        topRight: Radius.elliptical(30, 25),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey,
                          blurRadius: 10,
                          spreadRadius: 2,
                          offset: Offset(0, 0),
                        ),
                      ],
                    ),
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _demoList.length,
                      itemBuilder: (ctx, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                ctx,
                                MaterialPageRoute(
                                  builder: (ctx) => ChatPage(
                                    userName: 'Demo ${index + 1}',
                                  ),
                                ),
                              );
                            },
                            child: SizedBox(
                              height: 70,
                              // User display
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const CircleAvatar(
                                    radius: 30,
                                    backgroundImage:
                                        AssetImage('assets/images/profile.png'),
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
                                            "Demo ${index + 1}",
                                            style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const Text(
                                            "Latest Messadjfodsjoasdasdasdafddfdsfdsfsewqwasdsae",
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
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
                      },
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
