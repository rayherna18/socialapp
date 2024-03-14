import 'package:flutter/material.dart';

class HomeFeedScreen extends StatefulWidget {
  @override
  _HomeFeedState createState() => _HomeFeedState();
}

class _HomeFeedState extends State<HomeFeedScreen> {
  Map<String, Map<String, String>> feedContent = {
    'Wilting': {'Causes': "d"},
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Feed'),
      ),
      body: ListView.builder(
        itemCount: feedContent.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(feedContent[index]),
          );
        },
      ),
    );
  }
}

class SocialMediaPost {
  final String username;
  final String profileImageUrl;
  final DateTime postTimeStamp;
  final String postContent;
  final String postImageUrl;

  SocialMediaPost({
    required this.username,
    required this.profileImageUrl,
    required this.postTimeStamp,
    required this.postContent,
    required this.postImageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Image.network(imageUrl),
          ListTile(
            title: Text(title),
            subtitle: Text(subtitle),
          ),
        ],
      ),
    );
  }
}
