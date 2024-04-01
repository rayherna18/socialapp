import 'package:flutter/material.dart';
import 'user_profile.dart';
import 'view_post.dart';
import 'add_post.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SocialMediaPost {
  final String name;
  final String handle;
  final String profileImageUrl;
  DateTime postTimeStamp;
  final String postContent;
  final String postImageUrl;
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
    required this.postTimeStamp,
    required this.postContent,
    required this.postImageUrl,
    this.numLikes = 0,
    this.numComments = 0,
  });
}

class SocialMediaPostCard extends StatefulWidget {
  final SocialMediaPost post;

  const SocialMediaPostCard({Key? key, required this.post}) : super(key: key);

  @override
  State<SocialMediaPostCard> createState() => _SocialMediaPostCardState();
}

class _SocialMediaPostCardState extends State<SocialMediaPostCard> {
  bool isLiked = false;
  Icon unLikedIcon = const Icon(Icons.star_border_rounded);
  Icon likedIcon = const Icon(Icons.star, color: Colors.yellow);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => UserProfile(),
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
                child: Image.network(widget.post.postImageUrl,
                    width: double.infinity, fit: BoxFit.cover),
              ),
              const SizedBox(height: 8.0),
              Text(widget.post.postContent),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Row(
              children: [
                IconButton(
                  icon: isLiked ? likedIcon : unLikedIcon,
                  color: isLiked ? Colors.red : null,
                  onPressed: () {
                    setState(() {
                      isLiked = !isLiked;
                      if (isLiked) {
                        widget.post.numLikes = widget.post.numLikes! + 1;
                      } else {
                        widget.post.numLikes = widget.post.numLikes! - 1;
                      }
                    });
                  },
                ),
                Text(widget.post.numLikes.toString()),
              ],
            ),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.comment_outlined),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            SocialMediaPostScreen(post: widget.post),
                      ),
                    );
                  },
                ),
                widget.post.numComments! >= 0
                    ? Text(widget.post.numComments.toString())
                    : const Text(''),
              ],
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              const Expanded(
                  child: TextField(
                autocorrect: true,
                decoration: InputDecoration(
                  hintText: 'Add a comment...',
                  border: InputBorder.none,
                ),
              )),
              const SizedBox(width: 8.0),
              ElevatedButton(
                onPressed: () {
                  // Add code that uploads comment to DB.

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          SocialMediaPostScreen(post: widget.post),
                    ),
                  );
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
  const HomeFeedScreen({Key? key}) : super(key: key);

  @override
  _HomeFeedState createState() => _HomeFeedState();
}

class _HomeFeedState extends State<HomeFeedScreen> {
  late Stream<QuerySnapshot> _postStream;

  @override
  void initState() {
    super.initState();
    _postStream = FirebaseFirestore.instance.collection('posts').snapshots();
  }

  Future<Map<String, dynamic>> getUserData(String userID) async {
    final userDoc =
        await FirebaseFirestore.instance.collection('users').doc(userID).get();
    if (userDoc.exists) {
      return userDoc.data() as Map<String, dynamic>;
    } else {
      return {};
    }
  }

  /* final List<SocialMediaPost> feedContent = [
    // to be replaced with actual data from DB
    SocialMediaPost(
      name: 'Alice',
      handle: '@alice',
      profileImageUrl: 'https://via.placeholder.com/150',
      postTimeStamp: DateTime.now(),
      postContent: 'This is my first post!',
      postImageUrl: 'https://via.placeholder.com/300',
    ),
    SocialMediaPost(
      name: 'Bob',
      handle: '@bob',
      profileImageUrl: 'https://via.placeholder.com/150',
      postTimeStamp: DateTime.now(),
      postContent: 'This is my first post!',
      postImageUrl: 'https://via.placeholder.com/300',
    ),
  ]; */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: centralAppBar(context),
        body: StreamBuilder(
          stream: _postStream,
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return const Center(child: Text('Error loading posts'));
            }

            final posts = snapshot.data!.docs ?? [];

            return ListView.builder(
              itemCount: posts.length,
              itemBuilder: (context, index) {
                final postData = posts[index].data() as Map<String, dynamic>;

                return FutureBuilder(
                  future: getUserData(postData['postedBy']),
                  builder: (context,
                      AsyncSnapshot<Map<String, dynamic>> userDataSnapshot) {
                    if (userDataSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (userDataSnapshot.hasError) {
                      return const Center(
                          child: Text('Error loading user data'));
                    }

                    final userData = userDataSnapshot.data ?? {};
                    final username =
                        '${userData['nameFirst']} ${userData['nameLast']}';
                    final handle = userData['handle'];
                    final profileImageUrl = userData['pfpURL'];

                    final post = SocialMediaPost(
                      name: username,
                      handle: handle ?? '',
                      profileImageUrl: profileImageUrl ?? '',
                      postTimeStamp:
                          (postData['timePosted'] as Timestamp).toDate(),
                      postContent: postData['textContent'] ?? '',
                      postImageUrl: postData['imageContentURL'] ?? '',
                      numLikes: postData['numLikes'] ?? 0,
                      numComments: postData['numComments'] ?? 0,
                    );

                    return SocialMediaPostCard(post: post);
                  },
                );
              },
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddPostScreen(),
              ),
            );
          },
          child: const Icon(Icons.add),
        ));
  }
}

/*
Widget build(BuildContext context) {
    return Scaffold(
        appBar: centralAppBar(context),
        body: ListView.builder(
          itemCount: feedContent.length,
          itemBuilder: (context, index) {
            return SocialMediaPostCard(post: feedContent[index]);
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddPostScreen(),
              ),
            );
          },
          child: const Icon(Icons.add),
        ));
  }
}

*/

AppBar centralAppBar(BuildContext context) {
  return AppBar(
    title: const Text('Feed'),
    centerTitle: true,
    actions: [
      GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => UserProfile(),
            ),
          );
        },
        child: const CircleAvatar(
          backgroundImage: NetworkImage('https://via.placeholder.com/150'),
        ),
      ),
      const SizedBox(width: 16.0),
    ],
  );
}
