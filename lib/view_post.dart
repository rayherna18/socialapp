import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'home_feed.dart';
import 'user_profile.dart';

class Comment {
  final String commentUserName;
  final String commentProfileImageUrl;
  final String commentContent;
  final String commentHandle;
  final String commentImageUrl;
  final DateTime commentTimeStamp;
  int commentLikes;

  String getCommentedTime() {
    final timeDifference = DateTime.now().difference(commentTimeStamp);
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

  Comment(
      {required this.commentUserName,
      required this.commentProfileImageUrl,
      required this.commentContent,
      required this.commentHandle,
      required this.commentImageUrl,
      required this.commentTimeStamp,
      required this.commentLikes});
}

class CommentTile extends StatefulWidget {
  final Comment comment;

  const CommentTile({Key? key, required this.comment}) : super(key: key);

  @override
  State<CommentTile> createState() => _CommentTileState();
}

class _CommentTileState extends State<CommentTile> {
  bool isCommentLiked = false;
  Icon unLikedCommentIcon = const Icon(Icons.star_border_rounded);
  Icon likedCommentIcon = const Icon(Icons.star, color: Colors.yellow);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
            //  contentPadding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            leading: CircleAvatar(
              backgroundImage:
                  NetworkImage(widget.comment.commentProfileImageUrl),
            ),
            title: Row(children: [
              Text(widget.comment.commentUserName),
              Text(' • '),
              Text(widget.comment.getCommentedTime()),
            ]),
            subtitle: Text(widget.comment.commentHandle),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.comment.commentContent),
              const SizedBox(height: 8.0),
              ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: Image.network(widget.comment.commentImageUrl,
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
                  icon: isCommentLiked ? likedCommentIcon : unLikedCommentIcon,
                  onPressed: () {
                    setState(() {
                      isCommentLiked = !isCommentLiked;
                      if (isCommentLiked) {
                        widget.comment.commentLikes++;
                      } else {
                        widget.comment.commentLikes--;
                      }
                    });
                  },
                ),
                Text(widget.comment.commentLikes.toString()),
              ],
            ),
          ],
        ),
        const Divider(thickness: 1.0, color: Colors.grey),
      ],
    );
  }
}

/*
children: [
              Text(comment.commentContent),
              Image.network(comment.commentImageUrl),
              Text(comment.commentTimeStamp.toString()),
            ],
*/

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
                    // dense: true,
                    leading: CircleAvatar(
                      backgroundImage:
                          NetworkImage(widget.post.profileImageUrl),
                    ),
                    title: Text(widget.post.username),
                    subtitle: Text(widget.post.handle),
                  ),
                ),
                Column(
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
                Row(
                  children: [
                    SizedBox(width: 8.0),
                    Text(widget.post.getTimeMMHH()),
                    Text(' • '),
                    Text(widget.post.getDateMMDDYY()),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    //const SizedBox(width: 8.0),
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
