import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'view_post.dart';
import 'home_feed.dart';
import 'user_profile.dart';

Map<String, dynamic> userData = {
  // Replace with Firebase Auth user data
  'nameFirst': 'Raymond',
  'nameLast': 'Hernandez',
  'handle': 'rayherna01',
  'pfpURL':
      'https://i.pinimg.com/originals/77/81/dd/7781dde14911b9440dc865b94aba0af1.jpg',
  'email': 'raymondhr12@gmail.com',
  'id': '9q79mUimSSYMB6TaXsBgQUapJUv2',
};

class AddContentScreen extends StatefulWidget {
  final SocialMediaPost? post;
  final String? postId;
  final String type;
  final bool? isLiked;

  const AddContentScreen({
    Key? key,
    this.post,
    this.postId,
    required this.type,
    this.isLiked,
  }) : super(key: key);

  @override
  _AddContentScreenState createState() => _AddContentScreenState();
}

class _AddContentScreenState extends State<AddContentScreen> {
  TextEditingController _urlController = TextEditingController();
  TextEditingController _descController = TextEditingController();
  late bool isLiked;

  @override
  void initState() {
    super.initState();
    isLiked = widget.isLiked ?? false;
  }

  void dispose() {
    _urlController.dispose();
    _descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          centralAppBar(context, 'New ${widget.type}'), // centralAppBar(context
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 20.0),
            child: Column(
              children: [
                if (widget.type == "Comment" && widget.post != null)
                  _buildPostPreview(widget.post!, isLiked, context: context),
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
                        'commentedBy': userData['id'],
                        'textContent': _descController.text,
                        'imageContentURL': _urlController.text,
                        'numLikes': 0,
                        'relatedPost': widget.postId,
                        'timeCommented': Timestamp.now(),
                      });

                      /*      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SocialMediaPostScreen(
                            post: widget.post!,
                            postId: widget.postId!,
                            isLiked: isLiked,
                            togglePostLike: ,
                          ),
                        ),
                      ); */
                    } else {
                      CollectionReference postsRef =
                          FirebaseFirestore.instance.collection('posts');

                      DocumentReference newPostRef = await postsRef.add({
                        'postedBy': userData['id'],
                        'textContent': _descController.text,
                        'imageContentURL': _urlController.text,
                        'numLikes': 0,
                        'numComments': 0,
                        'timePosted': Timestamp.now(),
                      });

                      String newPostId = newPostRef.id;

                      await FirebaseFirestore.instance
                          .collection('users')
                          .doc(userData['id'])
                          .update({
                        'postList': FieldValue.arrayUnion([newPostId])
                      });

                      /*     Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HomeFeedScreen(goToUserProfile: ,),
                        ),
                      ); */
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
    {BuildContext? context}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      GestureDetector(
        onTap: () {
          Navigator.push(
            context!,
            MaterialPageRoute(
              builder: (context) => UserProfileScreen(),
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
