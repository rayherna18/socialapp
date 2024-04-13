import 'package:flutter/material.dart';
import 'package:socialapp/direct_messages.dart';
import 'package:socialapp/home_feed.dart';
import 'nav_bar.dart';

class UserProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: centralAppBar(context, 'User Profile'),
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
      body: Center(
        child: Text('User Profile'),
      ),
    );
  }
}
