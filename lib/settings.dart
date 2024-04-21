import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:provider/provider.dart';
import 'package:socialapp/direct_messages.dart';
import 'package:socialapp/home_feed.dart';
import 'package:socialapp/message/widgets/loading_widget.dart';
import 'package:socialapp/nav_bar.dart';
import 'package:socialapp/profilePage.dart';
import 'package:socialapp/settingsPages/changeF.dart';
import 'package:socialapp/settingsPages/changeL.dart';
import 'package:socialapp/settingsPages/changeName.dart';
import 'package:socialapp/settingsPages/changeP.dart';
import 'package:socialapp/settingsPages/changeUser.dart';
import 'package:socialapp/theme/themePro.dart';

class CustomSettings extends StatefulWidget {
  const CustomSettings({super.key});

  @override
  State<CustomSettings> createState() => _SettingsState();
}

class _SettingsState extends State<CustomSettings> {
  bool status = false;
  bool _isLoading = true;
  FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 1000), () {
      setState(() {
        _isLoading = false;
      });
    });
    super.initState();
  }

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
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: 3,
        onTap: (index) {
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    UserProfile(userID: _auth.currentUser!.uid),
              ),
            );
          } else if (index == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const HomeFeedScreen(),
              ),
            );
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const DirectMessagesScreen(),
              ),
            );
          }
        },
      ),
      body: _isLoading
          ? const LoadingPage()
          : Center(
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
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
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
                              Text("Change Email"),
                              Spacer(
                                flex: 1,
                              ),
                              ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                chanegUser()));
                                  },
                                  child: Text("Change"))
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
                              Text("Change First Name"),
                              Spacer(
                                flex: 1,
                              ),
                              ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => changeF()));
                                  },
                                  child: Text("Change"))
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
                              Text("Change Last Name"),
                              Spacer(
                                flex: 1,
                              ),
                              ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => changeL()));
                                  },
                                  child: Text("Change"))
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
                              ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => changeP()));
                                  },
                                  child: Text("Change"))
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
                              Text("Change UserName"),
                              Spacer(
                                flex: 1,
                              ),
                              ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                chanegName()));
                                  },
                                  child: Text("Change"))
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
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
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
                                      Provider.of<Themeprovider>(context,
                                              listen: false)
                                          .toggle();
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
