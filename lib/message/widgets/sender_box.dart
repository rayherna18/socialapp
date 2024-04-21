import 'package:flutter/material.dart';

class SenderBox extends StatelessWidget {
  const SenderBox({
    super.key,
    required this.currentUserId,
    required this.senderId,
    required this.message,
    required this.name,
  });

  final String currentUserId;
  final String senderId;
  final String name;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            decoration: BoxDecoration(
                color: Colors.blue[600],
                border: Border.all(color: Colors.black),
                borderRadius: const BorderRadius.all(Radius.circular(12))),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(message,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  )),
            ),
          ),
          const SizedBox(width: 8),
          CircleAvatar(
            radius: 18,
            backgroundColor: Colors.blue[600],
            child: Image.asset(
              'assets/images/profile.png',
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }
}
