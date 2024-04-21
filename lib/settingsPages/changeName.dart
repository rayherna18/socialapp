import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class chanegName extends StatefulWidget {
  chanegName({super.key});

  @override
  State<chanegName> createState() => _chanegNameState();
}

class _chanegNameState extends State<chanegName> {
  final TextEditingController _newCon = TextEditingController();

  final currentUser = FirebaseAuth.instance.currentUser!;
  final usercol = FirebaseFirestore.instance.collection("users");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 300,
              width: 400,
              decoration: BoxDecoration(
                  color: Colors.blueGrey,
                  borderRadius: BorderRadius.circular(25)),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  children: [
                    TextField(
                      controller: _newCon,
                      decoration: InputDecoration(
                        hintText: 'Enter new Username',
                        border: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.black, width: 2.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.black, width: 2.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.black, width: 2.0),
                        ),
                      ),
                    ),
                    Container(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text("cancel")),
                        ElevatedButton(
                            onPressed: () async {
                              await FirebaseFirestore.instance
                                  .collection("users")
                                  .doc(currentUser!.uid)
                                  .update({'handle': _newCon.text});
                              Navigator.pop(context);
                            },
                            child: Text("change")),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
