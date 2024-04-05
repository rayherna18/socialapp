import 'package:flutter/material.dart';
import 'package:profilepage/settings.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        centerTitle: true,
        //below will be the actions widget. Handles icons/buttons we will put in appBar.
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsPage()),
              );
            },
          ),
        ],
      ),
      // ignore: prefer_const_constructors
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
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
          ],
        ),
      ),
    );
  }
}
