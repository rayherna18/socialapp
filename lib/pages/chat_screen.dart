import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({
    super.key,
    required this.userName,
  });

  final String userName;

  @override
  State<StatefulWidget> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 4,
        toolbarHeight: 60,
        shadowColor: const Color.fromARGB(255, 53, 52, 52),
        leading: IconButton(
          iconSize: 32,
          onPressed: () {
            FocusScope.of(context).unfocus();
            Future.delayed(const Duration(milliseconds: 300), () {
              Navigator.of(context).pop();
            });
          },
          icon: const Icon(Icons.arrow_back),
        ),
        title: Row(
          children: [
            const CircleAvatar(
              radius: 24,
              backgroundImage: AssetImage('assets/images/profile.png'),
              backgroundColor: Colors.green,
            ),
            const SizedBox(
              width: 16,
            ),
            Text(
              widget.userName,
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Text(widget.userName),
        ],
      ),
      bottomSheet: Container(
        height: 56,
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              blurRadius: 10,
              spreadRadius: 2,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              alignment: Alignment.centerRight,
              width: 300,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  autofocus: true,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    hintText: "Aa",
                    isDense: true,
                    contentPadding: const EdgeInsets.all(12.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                  ),
                ),
              ),
            ),
            IconButton(
              iconSize: 32,
              icon: const Icon(Icons.send),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
