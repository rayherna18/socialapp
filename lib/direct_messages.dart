import 'package:flutter/material.dart';
import 'package:socialapp/user_profile.dart';
import 'nav_bar.dart';
import 'home_feed.dart';

class DirectMessagesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: centralAppBar(context, 'Direct Messages'),
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
      body: Center(
        child: Text('Direct Messages Screen'),
      ),
    );
  }
}
