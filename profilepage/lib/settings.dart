import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      // ignore: prefer_const_constructors
      body: Center(
        child: Text('Settings content will go here!'),
      ),
    );
  }
}
