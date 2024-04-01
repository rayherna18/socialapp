import 'package:flutter/material.dart';
import 'package:socialapp/add_content.dart';
import 'user_profile.dart';
import 'view_post.dart';
import 'add_content.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Map<String, dynamic> userData = {
  'nameFirst': 'Raymond',
  'nameLast': 'Hernandez',
  'handle': 'rayherna01',
  'pfpURL':
      'https://i.pinimg.com/originals/77/81/dd/7781dde14911b9440dc865b94aba0af1.jpg',
  'email': 'raymondhr12@gmail.com',
  'id': '9q79mUimSSYMB6TaXsBgQUapJUv2',
};

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
    required Timestamp postTimeStamp,
    required this.postContent,
    required this.postImageUrl,
    this.numLikes = 0,
    this.numComments = 0,
  }) : postTimeStamp = DateTime.fromMillisecondsSinceEpoch(
          postTimeStamp.millisecondsSinceEpoch,
        );
}

class SocialMediaPostCard extends StatefulWidget {
  final SocialMediaPost post;
  final String postId;
  final bool isLiked;
  final VoidCallback onLikePressed;

  const SocialMediaPostCard(
      {Key? key,
      required this.post,
      required this.postId,
      required this.isLiked,
      required this.onLikePressed})
      : super(key: key);

  @override
  State<SocialMediaPostCard> createState() => _SocialMediaPostCardState();
}

class _SocialMediaPostCardState extends State<SocialMediaPostCard> {
  bool isLiked = false;
  Icon unLikedIcon = const Icon(Icons.star_border_rounded);
  Icon likedIcon = const Icon(Icons.star, color: Colors.yellow);

  TextEditingController _commentController = TextEditingController();

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
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(widget.post.postContent),
              ),
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
                    });
                    widget.onLikePressed();
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
                        builder: (context) => SocialMediaPostScreen(
                            post: widget.post, postId: widget.postId),
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
                    'commentedBy': userData['id'],
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
                          post: widget.post, postId: widget.postId),
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
  const HomeFeedScreen({Key? key}) : super(key: key);

  @override
  _HomeFeedState createState() => _HomeFeedState();
}

class _HomeFeedState extends State<HomeFeedScreen> {
  late Stream<QuerySnapshot> _postStream;
  Map<String, bool> likedPosts = {};

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

  Future<void> toggleLike(String postId) async {
    setState(() {
      likedPosts[postId] = !likedPosts[postId]!;
    });

    try {
      DocumentReference postRef =
          FirebaseFirestore.instance.collection('posts').doc(postId);

      await postRef.update(
          {'numLikes': FieldValue.increment(likedPosts[postId]! ? 1 : -1)});
    } catch (e) {
      print('Error updating likes: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: centralAppBar(context, 'Home Feed'),
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
                    final userData = userDataSnapshot.data ?? {};
                    final username =
                        '${userData['nameFirst']} ${userData['nameLast']}';
                    final handle = userData['handle'];
                    final profileImageUrl = userData['pfpURL'];

                    final post = SocialMediaPost(
                      name: username,
                      handle: handle ?? '',
                      profileImageUrl: profileImageUrl ?? '',
                      postTimeStamp: postData['timePosted'],
                      postContent: postData['textContent'] ?? '',
                      postImageUrl: postData['imageContentURL'] ?? '',
                      numLikes: postData['numLikes'] ?? 0,
                      numComments: postData['numComments'] ?? 0,
                    );

                    final postId = posts[index].id;
                    final isLiked = likedPosts[postId] ?? false;

                    return SocialMediaPostCard(
                        post: post,
                        postId: posts[index].id,
                        isLiked: isLiked,
                        onLikePressed: () => toggleLike(postId));
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
                builder: (context) => const AddContentScreen(type: "Post"),
              ),
            );
          },
          child: const Icon(Icons.add),
        ));
  }
}

AppBar centralAppBar(BuildContext context, String title) {
  return AppBar(
    title: Text(title),
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
        child: CircleAvatar(
          backgroundImage: NetworkImage(userData['pfpURL']),
        ),
      ),
      const SizedBox(width: 16.0),
    ],
  );
}
