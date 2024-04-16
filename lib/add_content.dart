import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:socialapp/nav_bar.dart';
import 'package:socialapp/profilePage.dart';
import 'package:socialapp/settings.dart';
import 'view_post.dart';
import 'home_feed.dart';

class AddContentScreen extends StatefulWidget {
  final SocialMediaPost? post;
  final String? postId;
  final String type;
  final bool? isLiked;
  final Function? togglePostLike;

  const AddContentScreen(
      {Key? key,
      this.post,
      this.postId,
      required this.type,
      this.isLiked,
      this.togglePostLike})
      : super(key: key);

  @override
  _AddContentScreenState createState() => _AddContentScreenState();
}

class _AddContentScreenState extends State<AddContentScreen> {
  TextEditingController _urlController = TextEditingController();
  TextEditingController _descController = TextEditingController();
  late bool isLiked;
  late String pfpURL = "";
  late String firstName = "";
  late String lastName = "";
  late String userID = "";
  @override
  void initState() {
    super.initState();
    _getUserData();
    isLiked = widget.isLiked ?? false;
  }

  void dispose() {
    _urlController.dispose();
    _descController.dispose();
    super.dispose();
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
        pfpURL = userData['pfpURL'] ?? 'N/A';
        firstName = userData['firstName'] ?? 'N/A';
        lastName = userData['lastName'] ?? 'N/A';
        userID = userUID;
      } else {
        print('No user data available');
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: centralAppBar(context, 'New ${widget.type}', pfpURL),
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
                builder: (context) => const HomeFeedScreen(),
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
      ), // centralAppBar(context
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 20.0),
            child: Column(
              children: [
                if (widget.type == "Comment" && widget.post != null)
                  _buildPostPreview(widget.post!, isLiked,
                      context: context, userID: userID),
                Divider(
                  // Add a divider between the post preview and the form
                  thickness: 1.0,
                  color: Colors.grey[500],
                ),
                const SizedBox(height: 20.0),
                TextField(
                  controller: _urlController,
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  textAlign: TextAlign.start,
                  decoration: InputDecoration(
                    labelText: 'Image URL',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
                  ),
                ),
                SizedBox(height: 25.0),
                TextField(
                  controller: _descController,
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  textAlign: TextAlign.start,
                  decoration: InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
                  ),
                ),
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () async {
                    if (widget.type == "Comment") {
                      CollectionReference commentsRef = FirebaseFirestore
                          .instance
                          .collection('posts')
                          .doc(widget.postId)
                          .collection('comments');

                      await commentsRef.add({
                        'commentedBy': userID,
                        'textContent': _descController.text,
                        'imageContentURL': _urlController.text,
                        'numLikes': 0,
                        'relatedPost': widget.postId,
                        'timeCommented': Timestamp.now(),
                      });

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SocialMediaPostScreen(
                            post: widget.post!,
                            postId: widget.postId!,
                            isLiked: isLiked,
                            togglePostLike: widget.togglePostLike!,
                          ),
                        ),
                      );
                    } else {
                      CollectionReference postsRef =
                          FirebaseFirestore.instance.collection('posts');

                      DocumentReference newPostRef = await postsRef.add({
                        'postedBy': userID,
                        'textContent': _descController.text,
                        'imageContentURL': _urlController.text,
                        'numLikes': 0,
                        'numComments': 0,
                        'timePosted': Timestamp.now(),
                      });

                      String newPostId = newPostRef.id;

                      await FirebaseFirestore.instance
                          .collection('users')
                          .doc(userID)
                          .update({
                        'postList': FieldValue.arrayUnion([newPostId])
                      });

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HomeFeedScreen(),
                        ),
                      );
                    }
                    _urlController.clear();
                    _descController.clear();
                  },
                  child: Text('Add ${widget.type}'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget _buildPostPreview(SocialMediaPost post, bool isLiked,
    {BuildContext? context, String? userID}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      GestureDetector(
        onTap: () {
          Navigator.push(
            context!,
            MaterialPageRoute(
              builder: (context) => UserProfile(
                userID: userID!,
              ),
            ),
          );
        },
        child: ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(post.profileImageUrl),
          ),
          title: Text(post.name),
          subtitle: Text('@${post.handle}'),
        ),
      ),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (post.postImageUrl.isNotEmpty)
            ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: Image.network(
                post.postImageUrl,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          SizedBox(height: 8.0),
          Padding(
            padding: const EdgeInsets.fromLTRB(5, 5, 5, 0),
            child: Text(post.postContent),
          ),
          SizedBox(height: 8.0),
        ],
      ),
      Padding(
        padding: const EdgeInsets.fromLTRB(5, 5, 5, 0),
        child: Row(
          children: [
            Text(post.getTimeMMHH()),
            Text(' • '),
            Text(post.getDateMMDDYY()),
          ],
        ),
      ),
    ],
  );
}
