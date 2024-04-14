import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool status = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.backspace_outlined),
        title: Text(
          "SETTINGS",
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 30),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: [
            Spacer(
              flex: 1,
            ),
            Container(
              padding: EdgeInsets.all(10),
              height: 50,
              width: 400,
              decoration: BoxDecoration(
                borderRadius: new BorderRadius.only(
                  topLeft: const Radius.circular(25.0),
                  topRight: const Radius.circular(25.0),
                ),
                color: Colors.grey.shade500,
              ),
              child: Text(
                "ACCOUNT",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: new BorderRadius.only(
                  bottomLeft: const Radius.circular(25.0),
                  bottomRight: const Radius.circular(25.0),
                ),
                color: Colors.grey.shade500,
              ),
              height: 300,
              width: 400,
              child: Column(
                children: [
                  Spacer(
                    flex: 1,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.grey.shade600,
                        borderRadius: BorderRadius.circular(15)),
                    height: 50,
                    width: 330,
                    child: Row(
                      children: [
                        Text("Change Username"),
                        Spacer(
                          flex: 1,
                        ),
                        ElevatedButton(onPressed: () {}, child: Text("yuh"))
                      ],
                    ),
                  ),
                  Spacer(
                    flex: 1,
                  ),
                  Container(
                    height: 50,
                    width: 330,
                    child: Row(
                      children: [
                        Text("Change First/Last Name"),
                        Spacer(
                          flex: 1,
                        ),
                        ElevatedButton(onPressed: () {}, child: Text("yuh"))
                      ],
                    ),
                    decoration: BoxDecoration(
                        color: Colors.grey.shade600,
                        borderRadius: BorderRadius.circular(15)),
                  ),
                  Spacer(
                    flex: 1,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.grey.shade600,
                        borderRadius: BorderRadius.circular(15)),
                    height: 50,
                    width: 330,
                    child: Row(
                      children: [
                        Text("Change Email"),
                        Spacer(
                          flex: 1,
                        ),
                        ElevatedButton(onPressed: () {}, child: Text("yuh"))
                      ],
                    ),
                  ),
                  Spacer(
                    flex: 1,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.grey.shade600,
                        borderRadius: BorderRadius.circular(15)),
                    height: 50,
                    width: 330,
                    child: Row(
                      children: [
                        Text("Change Password"),
                        Spacer(
                          flex: 1,
                        ),
                        ElevatedButton(onPressed: () {}, child: Text("yuh"))
                      ],
                    ),
                  ),
                  Spacer(
                    flex: 1,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.grey.shade600,
                        borderRadius: BorderRadius.circular(15)),
                    height: 50,
                    width: 330,
                    child: Row(
                      children: [
                        Text("Change Birthdate"),
                        Spacer(
                          flex: 1,
                        ),
                        ElevatedButton(onPressed: () {}, child: Text("yuh"))
                      ],
                    ),
                  ),
                  Spacer(
                    flex: 1,
                  ),
                ],
              ),
            ),
            Padding(padding: EdgeInsets.all(5)),
            Container(
              padding: EdgeInsets.all(10),
              height: 50,
              width: 400,
              child: Text(
                "DISPLAY",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
              decoration: BoxDecoration(
                borderRadius: new BorderRadius.only(
                  topLeft: const Radius.circular(25.0),
                  topRight: const Radius.circular(25.0),
                ),
                color: Colors.grey.shade500,
              ),
            ),
            Container(
              height: 100,
              width: 400,
              decoration: BoxDecoration(
                borderRadius: new BorderRadius.only(
                  bottomLeft: const Radius.circular(25.0),
                  bottomRight: const Radius.circular(25.0),
                ),
                color: Colors.grey.shade500,
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.grey.shade600,
                        borderRadius: BorderRadius.circular(15)),
                    height: 50,
                    width: 330,
                    child: Row(
                      children: [
                        Text("Dark/Light Mode"),
                        Spacer(
                          flex: 1,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: FlutterSwitch(
                              height: 30,
                              width: 60,
                              value: status,
                              onToggle: (val) {
                                setState(() {
                                  status = val;
                                });
                              }),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Spacer(
              flex: 1,
            ),
          ],
        ),
      ),
    );
  }
}
//email, password, 
//display name, light
// mode/dark mode, birthday, 
//first name, last name