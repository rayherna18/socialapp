import 'package:flutter/material.dart';
import 'package:socialapp/direct_messages.dart';
import 'package:socialapp/home_feed.dart';
import 'package:socialapp/nav_bar.dart';
import 'package:socialapp/settings.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key, required this.title});

  final String title;

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  /* int _counter = 0;
  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  } */

  int getPostNum() => 42; // Dummy value
  int getFollowersNum() => 180; // Dummy value
  int getFollowingNum() => 560; // Dummy value

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: centralAppBarTabs(context, widget.title),
      bottomNavigationBar: CustomBottomNavigationBar(
          currentIndex: 1,
          onTap: (index) {
            if (index == 0) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const HomeFeedScreen(),
                ),
              );
            } else if (index == 2) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DirectMessagesScreen(),
                ),
              );
            }
          }),
      // ignore: prefer_const_constructors
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: <Widget>[
                  // Circle profile image
                  ClipOval(
                    child: Image.network(
                      'https://via.placeholder.com/150', // Placeholder image URL
                      width: MediaQuery.of(context).size.width *
                          0.2, // 30% of screen width
                      height: MediaQuery.of(context).size.width *
                          0.2, // Same as width to keep it a circle
                      fit: BoxFit.cover, // Cover bounds of the widget
                    ),
                  ),
                  const SizedBox(width: 10), // Space between image & textbox
                  // Textbox
                  // ignore: prefer_const_constructors
                  Expanded(
                    // ignore: prefer_const_constructors
                    child: TextField(
                      // ignore: prefer_const_constructors
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Bio Info Goes Here',
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 8.5, horizontal: 10.0),
                      ),
                      // Adjusts height to match the image
                      // ignore: prefer_const_constructors
                      style: TextStyle(
                        fontSize: 16, //smaller so it doesn't look too big.
                      ),
                      maxLines: 2, //only want to so two rows of text!
                    ),
                  ),
                  const SizedBox(width: 10),
                ],
              ),
              const SizedBox(height: 11),
              //row below for the posts, following, and followers numbers.
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Column for Posts
                  Column(
                    children: [
                      const Text("Posts",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      Text('${getPostNum()}'),
                    ],
                  ),
                  // Column for Followers
                  Column(
                    children: [
                      const Text("Followers",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      Text('${getFollowersNum()}'),
                    ],
                  ),
                  // Column for Following
                  Column(
                    children: [
                      const Text("Following",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      Text('${getFollowingNum()}'),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
