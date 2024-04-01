import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:socialapp/home_feed.dart';
import 'view_post.dart';
import 'home_feed.dart';

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

  const AddContentScreen({Key? key, this.post, this.postId, required this.type})
      : super(key: key);

  @override
  _AddContentScreenState createState() => _AddContentScreenState();
}

class _AddContentScreenState extends State<AddContentScreen> {
  TextEditingController _urlController = TextEditingController();
  TextEditingController _descController = TextEditingController();

  @override
  void dispose() {
    _urlController.dispose();
    _descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New ${widget.type}'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(20.0, 0, 20.0, 0.0),
          child: Column(
            children: [
              if (widget.type == "Comment" && widget.post != null)
                _buildPostPreview(widget.post!),
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
                  CollectionReference commentsRef = FirebaseFirestore.instance
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

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SocialMediaPostScreen(
                          post: widget.post!, postId: widget.postId!),
                    ),
                  );

                  try {
                    DocumentReference postRef = FirebaseFirestore.instance
                        .collection('posts')
                        .doc(widget.postId);

                    await postRef
                        .update({'numComments': FieldValue.increment(1)});
                  } catch (e) {
                    print('Error updating comments: $e');
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
    );
  }
}

Widget _buildPostPreview(SocialMediaPost post) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      GestureDetector(
        onTap: () {
          // Navigate to user profile
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
          if (post.postContent.isNotEmpty)
            ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: Image.network(
                post.postImageUrl,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          SizedBox(height: 8.0),
          Text(post.postContent),
          SizedBox(height: 8.0),
          Row(
            children: [
              Text(post.getTimeMMHH()),
              Text(' • '),
              Text(post.getDateMMDDYY()),
            ],
          ),
        ],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.favorite_border),
                onPressed: () {
                  // Handle like button press
                },
              ),
              Text(post.numLikes.toString()),
            ],
          ),
        ],
      ),
    ],
  );
}
