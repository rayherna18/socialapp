import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:socialapp/direct_messages.dart';
import 'package:socialapp/home_feed.dart';
import 'package:socialapp/nav_bar.dart';
// ignore: unused_import
import 'settings.dart';
import 'view_post.dart';

class UserProfile extends StatefulWidget {
  final String userID;

  const UserProfile({super.key, required this.userID});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  late String bio = '';
  late String firstName = '';
  late String lastName = '';
  late String pfpURL = '';
  late String handle = '';
  bool isLoading = true;
  late List<dynamic> postList = [];
  late List<dynamic> likedList = [];
  late String currentUserId;
  late String currentPfpURL;

  //TextEditingController for bio text field
  final TextEditingController bioController = TextEditingController();

  int selectedTabIndex =
      0; //used to control which tab is being shown. By index.

  //int getFollowersNum() => 180; // Dummy value
  // int getFollowingNum() => 560; // Dummy value

  @override
  void initState() {
    super.initState();
    currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';
    getUserData();
    getCurrentUserData();
    bioController.addListener(() {
      updateBio(bioController.text);
    });
  }

  @override
  void dispose() {
    //disposes the controller when the widget gets removed from the widget tree
    bioController.dispose();
    super.dispose();
  }

  void getUserData() {
    FirebaseFirestore.instance
        .collection('users')
        .doc(widget.userID)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        final userData = documentSnapshot.data() as Map<String, dynamic>;
        setState(() {
          firstName = userData['firstName'];
          lastName = userData['lastName'];
          handle = userData['handle'];
          pfpURL = userData['pfpURL'];
          // Check if 'likedList' exists before accessing it
          likedList = userData.containsKey('likedList')
              ? List<String>.from(userData['likedList'])
              : [];
          // Check if 'postList' exists before accessing it
          postList = userData.containsKey('postList')
              ? List<String>.from(userData['postList'])
              : [];
          isLoading = false;

          // Check if 'bio' exists, if not, initialize it as empty string
          if (userData.containsKey('bio')) {
            bio = userData['bio'];
          } else {
            bio = '';
            // Update Firestore to add 'bio' field with empty string
            FirebaseFirestore.instance
                .collection('users')
                .doc(widget.userID)
                .update({'bio': ''});
          }

          bioController.text = bio; //sets initial value for the biocontroller!
          bioController.addListener(() {
            if (widget.userID == currentUserId) {
              updateBio(bioController.text);
            }
          });
        });
      } else {
        print('Document does not exist on the database');
      }
    });
  }

  void getCurrentUserData() async {
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUserId)
        .get();

    if (userDoc.exists) {
      final currentUserData = userDoc.data() as Map<String, dynamic>;
      setState(() {
        currentPfpURL = currentUserData['pfpURL'];
      });
    } else {
      print('Document does not exist on the database');
    }
  }

  //method for updating bio below!
  void updateBio(String newBio) {
    FirebaseFirestore.instance.collection('users').doc(widget.userID).update({
      'bio': newBio,
    }).then((_) {
      print('Bio updated successfully!');
    }).catchError((error) {
      print('Error updating bio: $error');
    });
  }

  Future<List<Map<String, dynamic>>> _fetchPosts() async {
    final List<dynamic> postKeys =
        postList; // Assuming postList contains primary keys
    final List<Map<String, dynamic>> posts = [];
    try {
      for (final key in postKeys) {
        final DocumentSnapshot postSnapshot =
            await FirebaseFirestore.instance.collection('posts').doc(key).get();
        if (postSnapshot.exists) {
          final post = postSnapshot.data() as Map<String, dynamic>;
          posts.add(post);
        }
      }
    } catch (e) {
      print('Error fetching posts: $e');
    }
    return posts;
  }

  Future<List<Map<String, dynamic>>> _fetchLiked() async {
    final List<dynamic> postKeys =
        likedList; // Assuming postList contains primary keys
    final List<Map<String, dynamic>> posts = [];
    try {
      for (final key in postKeys) {
        final DocumentSnapshot postSnapshot =
            await FirebaseFirestore.instance.collection('posts').doc(key).get();
        if (postSnapshot.exists) {
          final likedPost = postSnapshot.data() as Map<String, dynamic>;
          posts.add(likedPost);
        }
      }
    } catch (e) {
      print('Error fetching posts: $e');
    }
    return posts;
  }

  Widget _postsTabContent() {
    return FutureBuilder(
      future:
          _fetchPosts(), // Implement this method to fetch post data from Firebase
      builder: (context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error loading posts'));
        }
        final posts = snapshot.data ?? [];
        return GridView.count(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          crossAxisCount: 3,
          crossAxisSpacing: 4,
          mainAxisSpacing: 4,
          children: posts.map((post) {
            final imageUrl = post['imageContentURL'];
            final text = post['textContent'];
            if (imageUrl != null && imageUrl.isNotEmpty) {
              // Display Images
              return Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(imageUrl),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
              );
            } else if (text != null && text.isNotEmpty) {
              // Display Text
              return Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.blueAccent,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    text,
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              );
            } else {
              // Invalid post format
              return SizedBox.shrink();
            }
          }).toList(),
        );
      },
    );
  }

  Widget _likedTabContent() {
    return FutureBuilder(
      future:
          _fetchLiked(), // Implement this method to fetch post data from Firebase
      builder: (context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error loading posts'));
        }
        final posts = snapshot.data ?? [];
        return GridView.count(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          crossAxisCount: 3,
          crossAxisSpacing: 4,
          mainAxisSpacing: 4,
          children: posts.map((post) {
            final imageUrl = post['imageContentURL'];
            final text = post['textContent'];
            if (imageUrl != null && imageUrl.isNotEmpty) {
              // Display Images
              return Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(imageUrl),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
              );
            } else if (text != null && text.isNotEmpty) {
              // Display Text
              return Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    text,
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              );
            } else {
              // Invalid post format
              return SizedBox.shrink();
            }
          }).toList(),
        );
      },
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
    if (isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return Scaffold(
      appBar: centralAppBarTabs(context, ("$firstName $lastName"),
          currentPfpURL), //centralAppBar(context, 'Profile', pfpURL
      // ignore: prefer_const_constructors
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: 1,
        onTap: (index) {
          if (index == 0) {
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
          } else if (index == 3) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const CustomSettings(),
              ),
            );
          }
        },
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 50, 0),
                child: Text(
                  "@$handle",
                  style: TextStyle(color: Colors.black, fontSize: 20),
                ),
              ),
              // ignore: prefer_const_constructors
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
                child: Row(
                  // ignore: prefer_const_literals_to_create_immutables
                  children: <Widget>[
                    // Circle profile image taking up 30% of the screen width
                    // ignore: prefer_const_constructors
                    CircleAvatar(
                      // ignore: prefer_const_constructors
                      backgroundImage: NetworkImage(pfpURL),
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
                            controller:
                                bioController, //using the bioController for the bio field!
                            readOnly: widget.userID !=
                                currentUserId, //disables option to edit the bio of another user that is not the currently logged in user
                            // ignore: prefer_const_constructors
                            decoration: InputDecoration(
                              // ignore: prefer_const_constructors
                              border: OutlineInputBorder(),
                              labelText: 'Bio Info',
                              // Try reducing or removing padding to see if it affects visibility
                              // ignore: prefer_const_constructors
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 12.0, horizontal: 10.0),
                            ),
                            style: const TextStyle(
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
                      Text(postList.length.toString()), //Text('${getPostNum()
                    ],
                  ),
                  //Column for Posts Liked
                  Column(
                    children: [
                      const Text("Posts Liked",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      Text(likedList.length.toString()), //Text('${getPostNum()
                    ],
                  ),
                  // Column for Followers
                  /*
                  Column(
                    children: [
                      const Text("Followers",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      Text('${getFollowersNum()}'),
                    ],
                  ), */
                  // Column for Following
                  /*
                  Column(
                    children: [
                      const Text("Following",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      Text('${getFollowingNum()}'),
                    ],
                  ), */
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
