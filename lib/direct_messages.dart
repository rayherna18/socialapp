import 'package:flutter/material.dart';
import 'nav_bar.dart';
import 'home_feed.dart';

class DirectMessagesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Direct Messages'),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
          currentIndex: 2,
          onTap: (index) {
            if (index == 1) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DirectMessagesScreen(),
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
