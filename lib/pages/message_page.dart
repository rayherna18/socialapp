import 'package:flutter/material.dart';
import 'package:socialapp/widgets/search_widget.dart';

class MessagePage extends StatefulWidget {
  const MessagePage({super.key});

  @override
  State<StatefulWidget> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        elevation: 3,
        shadowColor: const Color.fromARGB(255, 53, 52, 52),
        title: const Text('Search people'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: SearchUser(_demoList),
                useRootNavigator: true,
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
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
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Text(
                'Active user - (${_demoList.length})',
                style: const TextStyle(
                  color: Color.fromARGB(255, 72, 72, 72),
                  fontSize: 16,
                ),
              ),
            ),
            // ActiveUser(
            //   currentActive: _demoList.length,
            // ),
            // CurrentChat(
            //   currentActive: _demoList.length,
            // ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  const SizedBox(width: 16),
                  Column(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundImage:
                            AssetImage('assets/images/profile.png'),
                        backgroundColor: Colors.blue,
                      ),
                      Text("Demo"),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
