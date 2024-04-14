import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:socialapp/add_content.dart';
import 'package:socialapp/authentication/auth_page.dart';
import 'package:socialapp/direct_messages.dart';
import 'profilePage.dart';
import 'view_post.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'nav_bar.dart';

class SocialMediaPost {
  final String name;
  final String handle;
  final String profileImageUrl;
  DateTime postTimeStamp;
  final String postContent;
  final String postImageUrl;
  final String createdBy;
  int? numLikes;
  int? numComments;

  String getPostedTime() {
    final timeDifference = DateTime.now().difference(postTimeStamp);
    if (timeDifference.inDays > 0) {
      return '${timeDifference.inDays}d';
    } else if (timeDifference.inHours > 0) {
      return '${timeDifference.inHours}h';
    } else if (timeDifference.inMinutes > 0) {
      return '${timeDifference.inMinutes}m';
    } else {
      return '${timeDifference.inSeconds}s';
    }
  }

  String getAMPM() {
    return postTimeStamp.hour < 12 ? 'AM' : 'PM';
  }

  String getTimeMMHH() {
    return '${postTimeStamp.hour}:${postTimeStamp.minute}${getAMPM()}';
  }

  String getDateMMDDYY() {
    return '${postTimeStamp.month}/${postTimeStamp.day}/${postTimeStamp.year}';
  }

  SocialMediaPost({
    required this.name,
    required this.handle,
    required this.profileImageUrl,
    required Timestamp postTimeStamp,
    required this.postContent,
    required this.postImageUrl,
    required this.createdBy,
    this.numLikes = 0,
    this.numComments = 0,
  }) : postTimeStamp = postTimeStamp.toDate();
}

class SocialMediaPostCard extends StatefulWidget {
  final SocialMediaPost post;
  final String postId;
  final bool isLiked;
  final int numComments;
  final VoidCallback onLikePressed;
  final Function(String) togglePostLike;

  const SocialMediaPostCard({
    Key? key,
    required this.post,
    required this.postId,
    required this.isLiked,
    required this.numComments,
    required this.onLikePressed,
    required this.togglePostLike,
  }) : super(key: key);

  @override
  State<SocialMediaPostCard> createState() => _SocialMediaPostCardState();
}

class _SocialMediaPostCardState extends State<SocialMediaPostCard> {
  late bool isLiked;
  bool isButtonDisabled = false;
  Icon unLikedIcon = const Icon(Icons.star_border_rounded);
  Icon likedIcon = const Icon(Icons.star, color: Colors.yellow);

  @override
  void initState() {
    super.initState();
    isLiked = widget.isLiked;
  }

  String _validateUrl(String url) {
    if (url.startsWith('http://') || url.startsWith('https://')) {
      return url;
    } else {
      return 'https://' + url;
    }
  }

  TextEditingController _commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    bool isLiked = widget.isLiked;
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => UserProfile(
                  userID: widget.post.createdBy,
                ),
              ),
            );
          },
          child: ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(widget.post.profileImageUrl),
              ),
              title: Row(
                children: [
                  Text(widget.post.name),
                  Text(' • '),
                  Text(widget.post.getPostedTime()),
                ],
              ),
              subtitle: Text("@${widget.post.handle}")),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: widget.post.postImageUrl.isNotEmpty
                    ? Image.network(_validateUrl(widget.post.postImageUrl),
                        width: MediaQuery.of(context).size.width - 16,
                        height: MediaQuery.of(context).size.width - 16,
                        fit: BoxFit.cover)
                    : const SizedBox.shrink(),
              ),
              const SizedBox(height: 8.0),
              Padding(
                padding: const EdgeInsets.fromLTRB(5, 5, 0, 0),
                child: Text(widget.post.postContent),
              ),
            ],
          ),
        ),
        Container(
          constraints:
              BoxConstraints(maxWidth: MediaQuery.of(context).size.width),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  icon: isLiked ? likedIcon : unLikedIcon,
                  color: isLiked ? Colors.red : null,
                  onPressed: () async {
                    if (isButtonDisabled) {
                      return;
                    }

                    setState(() {
                      isButtonDisabled = true;
                    });

                    setState(() {
                      isLiked = !isLiked;
                    });

                    Future.delayed(const Duration(milliseconds: 500), () {
                      setState(() {
                        isButtonDisabled = false;
                      });
                    });

                    widget.onLikePressed();
                  },
                ),
                Text(widget.post.numLikes.toString()),
                IconButton(
                  icon: const Icon(Icons.comment_outlined),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SocialMediaPostScreen(
                          post: widget.post,
                          postId: widget.postId,
                          isLiked: isLiked,
                          togglePostLike: widget.togglePostLike,
                        ),
                      ),
                    );
                  },
                ),
                StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('posts')
                        .doc(widget.postId)
                        .collection('comments')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError)
                        return Text('Error: ${snapshot.error}');
                      switch (snapshot.connectionState) {
                        case ConnectionState.waiting:
                          return const Text(" ");
                        default:
                          return Text(snapshot.data!.docs.length.toString());
                      }
                    })
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              Expanded(
                  child: TextField(
                autocorrect: true,
                controller: _commentController,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                textAlign: TextAlign.start,
                decoration: const InputDecoration(
                  hintText: 'Add a comment...',
                  border: InputBorder.none,
                ),
              )),
              const SizedBox(width: 8.0),
              ElevatedButton(
                onPressed: () async {
                  CollectionReference commentsRef = FirebaseFirestore.instance
                      .collection('posts')
                      .doc(widget.postId)
                      .collection('comments');

                  await commentsRef.add({
                    'commentedBy': FirebaseAuth.instance.currentUser!.uid,
                    'textContent': _commentController.text,
                    'imageContentURL': '',
                    'numLikes': 0,
                    'relatedPost': widget.postId,
                    'timeCommented': Timestamp.now(),
                  });

                  widget.post.numComments = widget.post.numComments! + 1;

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SocialMediaPostScreen(
                        post: widget.post,
                        postId: widget.postId,
                        isLiked: isLiked,
                        togglePostLike: widget.togglePostLike,
                      ),
                    ),
                  );

                  try {
                    DocumentReference postRef = FirebaseFirestore.instance
                        .collection('posts')
                        .doc(widget.postId);

                    await postRef
                        .update({'numComments': widget.post.numComments});
                  } catch (e) {
                    print('Error updating comments: $e');
                  }

                  _commentController.clear();
                },
                child: const Text('Comment'),
              ),
            ],
          ),
        ),
      ]),
    );
  }
}

class HomeFeedScreen extends StatefulWidget {
  const HomeFeedScreen({
    Key? key,
  }) : super(key: key);

  @override
  _HomeFeedState createState() => _HomeFeedState();
}

class _HomeFeedState extends State<HomeFeedScreen> {
  late Stream<QuerySnapshot> _postStream;
  late Map<String, bool> likedPosts = {};

  late String firstName = "";
  late String lastName = "";
  late String pfpURL = "";
  late String handle = "";
  late String email = "";
  late String userID = "";

  @override
  void initState() {
    super.initState();
    _getUserData();
    _fetchLikedPosts();
    _postStream = FirebaseFirestore.instance.collection('posts').snapshots();
  }

  Future<void> _fetchLikedPosts() async {
    String userID = FirebaseAuth.instance.currentUser!.uid;
    try {
      // Ensure user is logged in
      if (userID.isEmpty) {
        print('Error: User ID is empty');
        return;
      }

      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userID)
          .get();

      // Check if the document exists and has data
      if (!userSnapshot.exists || userSnapshot.data() == null) {
        print('Error: Liked posts data not found');
        return;
      }

      // Retrieve liked posts data
      Map<String, dynamic> userData =
          userSnapshot.data() as Map<String, dynamic>;

      if (userData.containsKey('likedList')) {
        // Assuming 'likedList' is a list of post IDs
        List<dynamic> likedList = userData['likedList'] ?? [];
        // Convert the list to a map for easier lookup
        Map<String, bool> likedPostsMap = {};
        likedList.forEach((postId) {
          likedPostsMap[postId] = true;
        });
        setState(() {
          likedPosts = likedPostsMap;
        });
      } else {
        print('Error: Liked posts data not found');
      }
    } catch (e) {
      print('Error fetching liked posts: $e');
    }
  }

  /* Future<void> resetAllPostLikes() async {
    // For resetting all post likes
    try {
      likedPosts.forEach((postId, _) {
        likedPosts[postId] = false;
        _prefs.setBool(postId, false);
      });
    } catch (e) {
      print('Error resetting post likes: $e');
    }
  } */

  Future<Map<String, dynamic>> getPosterData(String userID) async {
    final userDoc =
        await FirebaseFirestore.instance.collection('users').doc(userID).get();
    if (userDoc.exists) {
      return userDoc.data() as Map<String, dynamic>;
    } else {
      return {};
    }
  }

  Future<void> _getUserData() async {
    final user = FirebaseAuth.instance.currentUser!;
    final userUID = user.uid;

    try {
      // Access the user's document in Firestore
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userUID)
          .get();

      if (userDoc.exists) {
        // Extract the data
        Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
        firstName = userData['firstName'] ?? 'N/A';
        lastName = userData['lastName'] ?? 'N/A';
        pfpURL = userData['pfpURL'] ?? '';
        handle = userData['handle'] ?? 'N/A';
        email = userData['email'] ?? 'N/A';
        userID = userUID;
      } else {
        print('No user data available');
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  Future<int> getNumPostComments(String postId) async {
    CollectionReference postsRef =
        FirebaseFirestore.instance.collection('posts');
    QuerySnapshot commentSnapshot =
        await postsRef.doc(postId).collection('comments').get();
    int numberOfComments = commentSnapshot.docs.length;
    return numberOfComments;
  }

  Future<void> togglePostLike(String postId) async {
    try {
      DocumentReference postRef =
          FirebaseFirestore.instance.collection('posts').doc(postId);

      DocumentSnapshot postSnapshot = await postRef.get();
      Map<String, dynamic> postData =
          postSnapshot.data() as Map<String, dynamic>;

      // int currentLikes = postData['numLikes'] ?? 0;
      bool isCurrentlyLiked = likedPosts.containsKey(postId);

      if (!isCurrentlyLiked) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userID)
            .update({
          'likedList': FieldValue.arrayUnion([postId])
        });
      } else {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userID)
            .update({
          'likedList': FieldValue.arrayRemove([postId])
        });
      }

      setState(() {
        if (!isCurrentlyLiked) {
          likedPosts[postId] = true;
        } else {
          likedPosts.remove(postId);
        }
      });

      if (!isCurrentlyLiked) {
        await postRef.update({'numLikes': FieldValue.increment(1)});
      } else {
        if (postData['numLikes'] > 0) {
          await postRef.update({'numLikes': FieldValue.increment(-1)});
        }
      }
    } catch (e) {
      print('Error updating likes: $e');
    }
  }

  //Grabbing the user's data

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: centralAppBarTabs(context, 'Home Feed', pfpURL),
        bottomNavigationBar: CustomBottomNavigationBar(
            currentIndex: 0,
            onTap: (index) {
              if (index == 1) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UserProfile(userID: userID),
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
            }),
        body: StreamBuilder(
          stream: _postStream,
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: Text('Loading...'));
            }
            if (snapshot.hasError) {
              return const Center(child: Text('Error loading posts'));
            }

            final posts = snapshot.data!.docs;

            return SingleChildScrollView(
              child: Column(
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: posts.length,
                    itemBuilder: (context, index) {
                      final postData =
                          posts[index].data() as Map<String, dynamic>;

                      final isLiked = likedPosts[posts[index].id] ?? false;

                      return FutureBuilder(
                        future: getPosterData(postData['postedBy']),
                        builder: (context,
                            AsyncSnapshot<Map<String, dynamic>>
                                userDataSnapshot) {
                          final userData = userDataSnapshot.data ?? {};
                          final username =
                              '${userData['firstName']} ${userData['lastName']}';
                          final handle = userData['handle'];
                          final profileImageUrl = userData['pfpURL'];

                          final post = SocialMediaPost(
                            name: username ?? '',
                            handle: handle ?? '',
                            profileImageUrl: profileImageUrl ?? '',
                            postTimeStamp: postData['timePosted'],
                            postContent: postData['textContent'] ?? '',
                            postImageUrl: postData['imageContentURL'] ?? '',
                            numLikes: postData['numLikes'] ?? 0,
                            numComments: postData['numComments'] ?? 0,
                            createdBy: postData['postedBy'] ?? '',
                          );

                          final commentsRef = FirebaseFirestore.instance
                              .collection('posts')
                              .doc(posts[index].id)
                              .collection('comments');

                          return FutureBuilder<QuerySnapshot>(
                            future: commentsRef.get(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                      ConnectionState.waiting &&
                                  !snapshot.hasData) {
                                return const Center(child: Text(' '));
                              }
                              if (snapshot.hasError) {
                                return Text('Error loading comments');
                              }

                              // Calculate the number of comments
                              final numComments = snapshot.data!.docs.length;

                              return SocialMediaPostCard(
                                post: post,
                                postId: posts[index].id,
                                isLiked: likedPosts[posts[index].id] ?? false,
                                numComments: numComments,
                                onLikePressed: () =>
                                    togglePostLike(posts[index].id),
                                togglePostLike: togglePostLike,
                              );
                            },
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AddContentScreen(type: "Post"),
              ),
            );
          },
          child: const Icon(Icons.add),
        ));
  }
}

AppBar centralAppBarTabs(BuildContext context, String title, String pfpURL) {
  final user = FirebaseAuth.instance.currentUser!;
  final userID = user.uid;

  return AppBar(
    title: Text(title),
    automaticallyImplyLeading: false,
    centerTitle: true,
    actions: [
      GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => UserProfile(userID: userID),
            ),
          );
        },
        child: CircleAvatar(
          backgroundImage: NetworkImage(pfpURL),
          backgroundColor: Colors.grey.shade200, // Fallback color
        ),
      ),
      const SizedBox(width: 16.0),
      IconButton(
        onPressed: () {
          FirebaseAuth.instance.signOut();
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => const AuthPage(),
          ));
        },
        icon: Icon(Icons.logout),
      ),
    ],
  );
}

AppBar centralAppBar(BuildContext context, String title, String pfpURL) {
  final user = FirebaseAuth.instance.currentUser!;
  final userID = user.uid;

  return AppBar(
    title: Text(title),
    centerTitle: true,
    actions: [
      GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => UserProfile(userID: userID),
            ),
          );
        },
        child: CircleAvatar(
          backgroundImage: NetworkImage(pfpURL),
          backgroundColor: Colors.grey.shade200, // Fallback color
        ),
      ),
      const SizedBox(width: 16.0),
      IconButton(
        onPressed: () {
          FirebaseAuth.instance.signOut();
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => const AuthPage(),
          ));
        },
        icon: Icon(Icons.logout),
      ),
    ],
  );
}
