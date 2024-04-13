import 'package:flutter/material.dart';
import 'package:socialapp/pages/chat_screen.dart';

class CurrentChat extends StatelessWidget {
  const CurrentChat({
    super.key,
    required this.currentActive,
  });

  final int currentActive;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 25),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.elliptical(30, 25),
          topRight: Radius.elliptical(30, 25),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 10,
            spreadRadius: 2,
            offset: Offset(0, 0),
          ),
        ],
      ),
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: currentActive,
        itemBuilder: (ctx, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: InkWell(
              onTap: () {
                Navigator.push(
                  ctx,
                  MaterialPageRoute(
                    builder: (ctx) => ChatPage(
                      userName: 'Demo ${index + 1}',
                    ),
                  ),
                );
              },
              enableFeedback: true,
              child: SizedBox(
                height: 70,

// User display
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const CircleAvatar(
                      radius: 30,
                      backgroundImage: AssetImage('assets/images/profile.png'),
                      backgroundColor: Colors.blue,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 0),
                      child: SizedBox(
                        width: 200,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Demo ${index + 1}",
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Text(
                              "Latest Messadjfodsjoasdasdasdafddfdsfdsfsewqwasdsae",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
