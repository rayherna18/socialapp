// ignore: file_names
import 'package:flutter/material.dart';
// ignore: unused_import
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
  int selectedTabIndex =
      0; //used to control which tab is being shown. By index.

  int getPostNum() => 42; // Dummy value
  int getFollowersNum() => 180; // Dummy value
  int getFollowingNum() => 560; // Dummy value

  Widget _postsTabContent() {
    return GridView.count(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      crossAxisCount: 3,
      crossAxisSpacing: 4,
      mainAxisSpacing: 4,
      children: List.generate(6, (index) {
        if (index % 2 == 0) {
          // Even indices: Display Images
          return Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage('https://via.placeholder.com/150'),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
          );
        } else {
          // Odd indices: Display Text
          return Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.blueAccent,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              'Item $index',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          );
        }
      }),
    );
  }

  Widget _likedTabContent() {
    return GridView.count(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      crossAxisCount: 3,
      crossAxisSpacing: 4,
      mainAxisSpacing: 4,
      children: List.generate(1, (index) {
        if (index % 2 == 0) {
          return Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage('https://via.placeholder.com/150'),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
          );
        } else {
          return Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              'Liked $index',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          );
        }
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    //below list is for the content of posts and liked posts tabs
    List<Widget> tabsContent = [
      _postsTabContent(),
      _likedTabContent(),
    ];
    //
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
                MaterialPageRoute(builder: (context) => const Settings()),
              );
            },
          ),
        ],
      ),
      // ignore: prefer_const_constructors
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // ignore: prefer_const_constructors
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  // ignore: prefer_const_literals_to_create_immutables
                  children: <Widget>[
                    // Circle profile image taking up 30% of the screen width
                    // ignore: prefer_const_constructors
                    CircleAvatar(
                      // ignore: prefer_const_constructors
                      backgroundImage: NetworkImage(
                          'https://static-00.iconduck.com/assets.00/profile-circle-icon-512x512-zxne30hp.png'),
                      radius: 40,
                    ),
                    SizedBox(
                        width:
                            20), // Provides space between the image and the text box

                    // Expanded TextField on the right with "Bio Info" label text
                    Expanded(
                      child: SizedBox(
                        height: 50, // Fixed height for better control
                        child: Theme(
                          data: Theme.of(context).copyWith(
                            colorScheme: Theme.of(context).colorScheme.copyWith(
                                  primary: Colors.black,
                                ),
                          ),
                          // ignore: prefer_const_constructors
                          child: TextField(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Bio Info',
                              // Try reducing or removing padding to see if it affects visibility
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 12.0, horizontal: 10.0),
                            ),
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.black), // Ensure black text
                            maxLines: null, // Flexible vertical expansion
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 11),
              //row below for the posts, following, and followers numbers.
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Column for Posts
                  Column(
                    children: [
                      const Text("Posts",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      Text('${getPostNum()}'),
                    ],
                  ),
                  // Column for Followers
                  Column(
                    children: [
                      const Text("Followers",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      Text('${getFollowersNum()}'),
                    ],
                  ),
                  // Column for Following
                  Column(
                    children: [
                      const Text("Following",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      Text('${getFollowingNum()}'),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              //below this comment is the Tabs content for this page
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  //gesture detector for user posts
                  GestureDetector(
                    onTap: () => setState(() => selectedTabIndex = 0),
                    child: Text(
                      'Posts',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: selectedTabIndex == 0
                            ? FontWeight.bold
                            : FontWeight.normal,
                        color:
                            selectedTabIndex == 0 ? Colors.blue : Colors.black,
                      ),
                    ),
                  ),
                  //gesture detector for liked posts
                  GestureDetector(
                    onTap: () => setState(() => selectedTabIndex = 1),
                    child: Text(
                      'Liked',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: selectedTabIndex == 1
                            ? FontWeight.bold
                            : FontWeight.normal,
                        color:
                            selectedTabIndex == 1 ? Colors.green : Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              //tab content below!
              tabsContent[selectedTabIndex],
            ],
          ),
        ),
      ),
    );
  }
}
