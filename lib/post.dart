import 'package:flutter/material.dart';
import 'home_feed.dart';

class Comment {
  final String commentUserName;
  final String commentProfileImageUrl;
  final String commentContent;
  final String commentHandle;
  final String commentImageUrl;
  final DateTime commentTimeStamp;
  final int commentLikes;

  Comment(
      {required this.commentUserName,
      required this.commentProfileImageUrl,
      required this.commentContent,
      required this.commentHandle,
      required this.commentImageUrl,
      required this.commentTimeStamp,
      required this.commentLikes});
}

class CommentTile extends StatelessWidget {
  final Comment comment;

  const CommentTile({Key? key, required this.comment}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(comment.commentProfileImageUrl),
          ),
          title: Text(comment.commentUserName),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(comment.commentContent),
              Image.network(comment.commentImageUrl),
              Text(comment.commentTimeStamp.toString()),
            ],
          ),
        ),
        const Divider(thickness: 1.0, color: Colors.grey),
      ],
    );
  }
}

class SocialMediaPostScreen extends StatefulWidget {
  final SocialMediaPost post;

  const SocialMediaPostScreen({Key? key, required this.post}) : super(key: key);

  @override
  State<SocialMediaPostScreen> createState() => _SocialMediaPostScreenState();
}

class _SocialMediaPostScreenState extends State<SocialMediaPostScreen> {
  bool isLiked = false;
  Icon unLikedIcon = const Icon(Icons.favorite_border);
  Icon likedIcon = const Icon(Icons.favorite, color: Colors.red);

  final List<Comment> commentsConent = [
    Comment(
        commentUserName: 'John Doe',
        commentProfileImageUrl:
            'https://i.pinimg.com/originals/ac/8a/86/ac8a86e44ae4fac4e36a54d805e83eb8.jpg',
        commentContent: 'This is a comment',
        commentHandle: '@johndoe',
        commentImageUrl:
            'https://th.bing.com/th/id/OIP.xNmHVmGh6h-YMTSalWZIAAHaEK?rs=1&pid=ImgDetMain',
        commentTimeStamp: DateTime.now(),
        commentLikes: 0),
    Comment(
        commentUserName: 'John Doe',
        commentProfileImageUrl:
            'https://i.pinimg.com/originals/ac/8a/86/ac8a86e44ae4fac4e36a54d805e83eb8.jpg',
        commentContent: 'This is a comment',
        commentHandle: '@johndoe',
        commentImageUrl:
            'https://th.bing.com/th/id/OIP.xNmHVmGh6h-YMTSalWZIAAHaEK?rs=1&pid=ImgDetMain',
        commentTimeStamp: DateTime.now(),
        commentLikes: 0)
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Post'),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: 2 + commentsConent.length,
        itemBuilder: (context, index) {
          if (index == 0) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(widget.post.profileImageUrl),
                  ),
                  title: Text(widget.post.username),
                  subtitle: Text(widget.post.postTimeStamp.toString()),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.post.postContent),
                      const SizedBox(height: 8.0),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: Image.network(widget.post.postImageUrl,
                            width: double.infinity, fit: BoxFit.cover),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(width: 8.0),
                    Row(
                      children: [
                        IconButton(
                          icon: isLiked ? likedIcon : unLikedIcon,
                          color: isLiked ? Colors.red : null,
                          onPressed: () {
                            setState(() {
                              isLiked = !isLiked;
                              if (isLiked) {
                                widget.post.numLikes =
                                    widget.post.numLikes! + 1;
                              } else {
                                widget.post.numLikes =
                                    widget.post.numLikes! - 1;
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
                          icon: const Icon(Icons.chat_bubble_outline_rounded),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            );
          } else if (index == 1) {
            return Divider(thickness: 1.0, color: Colors.grey[500]);
          } else {
            final commentIndex = index - 2;
            return CommentTile(comment: commentsConent[commentIndex]);
          }
        },
      ),
    );
  }
}
