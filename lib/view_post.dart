import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:socialapp/nav_bar.dart';
import 'package:socialapp/profilePage.dart';
import 'home_feed.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'add_content.dart';

class Comment {
  final String commentName;
  final String commentProfileImageUrl;
  final String commentContent;
  final String commentHandle;
  final String commentImageUrl;
  DateTime commentTimeStamp;
  final String commentedBy;
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
      {required this.commentName,
      required this.commentProfileImageUrl,
      required this.commentContent,
      required this.commentHandle,
      required this.commentImageUrl,
      required Timestamp commentTimeStamp,
      required this.commentedBy,
      required this.commentLikes})
      : commentTimeStamp = commentTimeStamp.toDate();
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
  String userID = FirebaseAuth.instance.currentUser!.uid;

  void initState() {
    super.initState();
    isCommentLiked = false;
  }

  Future<void> toggleCommentLike() async {
    setState(() {
      isCommentLiked = !isCommentLiked;
      if (isCommentLiked) {
        widget.comment.commentLikes++;
      } else {
        widget.comment.commentLikes--;
      }
    });

    try {
      DocumentReference commentRef = FirebaseFirestore.instance
          .collection('posts')
          .doc('postID')
          .collection('comments')
          .doc('commentID');
      await commentRef.update({'numLikes': widget.comment.commentLikes});
    } catch (e) {
      print('Error updating comment likes: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => UserProfile(userID: userID),
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
              Text(widget.comment.commentName),
              Text(' • '),
              Text(widget.comment.getCommentedTime()),
            ]),
            subtitle: Text("@${widget.comment.commentHandle}"),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8.0),
              if (widget.comment.commentImageUrl.isNotEmpty)
                ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Image.network(widget.comment.commentImageUrl,
                      width: double.infinity, fit: BoxFit.cover),
                ),
              Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(5, 10, 0, 0),
                    child: Text(widget.comment.commentContent),
                  )),
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
                  onPressed: () async {
                    setState(() {
                      isCommentLiked = !isCommentLiked;
                      if (isCommentLiked) {
                        widget.comment.commentLikes++;
                      } else {
                        widget.comment.commentLikes--;
                      }
                    });

                    try {
                      DocumentReference commentRef = FirebaseFirestore.instance
                          .collection('posts')
                          .doc('postID')
                          .collection('comments')
                          .doc('commentID');
                      await commentRef
                          .update({'numLikes': widget.comment.commentLikes});
                    } catch (e) {
                      print('Error updating comment likes: $e');
                    }
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

class SocialMediaPostScreen extends StatefulWidget {
  final SocialMediaPost post;
  final String postId;
  final bool? isLiked;
  final Function togglePostLike;
  const SocialMediaPostScreen(
      {Key? key,
      required this.post,
      required this.postId,
      this.isLiked,
      required this.togglePostLike})
      : super(key: key);

  @override
  State<SocialMediaPostScreen> createState() => _SocialMediaPostScreenState();
}

class _SocialMediaPostScreenState extends State<SocialMediaPostScreen> {
  late bool isPostLiked;
  late String currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';
  Icon unLikedIcon = const Icon(Icons.star_border_rounded);
  Icon likedIcon = const Icon(Icons.star, color: Colors.yellow);
  String userID = FirebaseAuth.instance.currentUser!.uid;
  late String pfpUrl = '';

  late Stream<QuerySnapshot> _commentStream;

  @override
  void initState() {
    super.initState();
    isPostLiked = widget.isLiked ?? false;
    _commentStream = FirebaseFirestore.instance
        .collection('posts')
        .doc(widget.postId)
        .collection('comments')
        .snapshots();
  }

  Future<void> togglePostLike() async {
    try {
      final postRef =
          FirebaseFirestore.instance.collection('posts').doc(widget.postId);
      final userRef =
          FirebaseFirestore.instance.collection('users').doc(userID);

      setState(() {
        isPostLiked = !isPostLiked;
        if (isPostLiked) {
          widget.post.numLikes = widget.post.numLikes! + 1;
        } else {
          if (widget.post.numLikes! > 0) {
            widget.post.numLikes = widget.post.numLikes! - 1;
          }
        }
      });

      if (isPostLiked) {
        await postRef.update({'numLikes': FieldValue.increment(1)});
      } else {
        await postRef.update({'numLikes': FieldValue.increment(-1)});
      }

      //await userRef.update({'likedList': userData['likedList']});
    } catch (e) {
      print('Error updating likes: $e');
    }
  }

  Future<Comment?> fetchCommenterData(
      String userId, Map<String, dynamic> commentData) async {
    try {
      final commenterSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();
      if (commenterSnapshot.exists) {
        final commenterData = commenterSnapshot.data();
        return Comment(
          commentName: commenterSnapshot['firstName'] +
              ' ' +
              commenterSnapshot['lastName'],
          commentProfileImageUrl: commenterSnapshot['pfpURL'] ?? '',
          commentContent: commentData['textContent'] ?? '',
          commentHandle: commenterSnapshot['handle'] ?? '',
          commentImageUrl: commentData['imageContentURL'] ?? '',
          commentTimeStamp: commentData['timeCommented'] ?? DateTime.now(),
          commentedBy: commentData['commentedBy'] ?? '',
          commentLikes: 0,
        );
      } else {
        print('Commenter data does not exist');
        return null;
      }
    } catch (e) {
      print('Error fetching commenter data: $e');
      return null;
    }
  }

  Future<void> setUsePfpUrl() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      FirebaseFirestore.instance
          .collection('users')
          .doc(userID)
          .get()
          .then((DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.exists) {
          pfpUrl = documentSnapshot['pfpURL'];
        } else {
          print('Document does not exist on the database');
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: centralAppBar(context, 'Post', pfpUrl),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: 0,
        onTap: (index) {
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => UserProfile(
                  userID: userID,
                ),
              ),
            );
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const HomeFeedScreen(),
              ),
            );
          }
        },
      ),
      body: StreamBuilder(
          stream: _commentStream,
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return const Center(child: Text('Error'));
            }

            final comments = snapshot.data!.docs;

            return ListView.builder(
              itemCount: 2 + comments.length,
              itemBuilder: (context, index) {
                if (index == 0) {
                  // Display original post
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                          // dense: true,
                          leading: CircleAvatar(
                            backgroundImage:
                                NetworkImage(widget.post.profileImageUrl),
                          ),
                          title: Text(widget.post.name),
                          subtitle: Text('@${widget.post.handle}'),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (widget.post.postContent.isNotEmpty)
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10.0),
                                child: widget.post.postImageUrl.isEmpty
                                    ? const SizedBox.shrink()
                                    : Image.network(widget.post.postImageUrl,
                                        width: double.infinity,
                                        fit: BoxFit.cover),
                              ),
                            const SizedBox(height: 8.0),
                            Text(widget.post.postContent),
                            const SizedBox(height: 8.0),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          //const SizedBox(width: 8.0),
                          Row(
                            children: [
                              IconButton(
                                icon: isPostLiked ? likedIcon : unLikedIcon,
                                color: isPostLiked ? Colors.red : null,
                                onPressed: togglePostLike,
                              ),
                              Text(widget.post.numLikes.toString()),
                            ],
                          ),
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(
                                    Icons.chat_bubble_outline_rounded),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => AddContentScreen(
                                        post: widget.post,
                                        postId: widget.postId,
                                        type: "Comment",
                                        togglePostLike: widget.togglePostLike,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                        child: Row(
                          children: [
                            Text(widget.post.getTimeMMHH()),
                            Text(' • '),
                            Text(widget.post.getDateMMDDYY()),
                          ],
                        ),
                      ),
                    ],
                  );
                } else if (index == 1) {
                  // Displays the divider
                  return Divider(thickness: 1.0, color: Colors.grey[500]);
                } else {
                  // Comments section
                  final commentIndex = index - 2;
                  final commentData =
                      comments[commentIndex].data() as Map<String, dynamic>?;

                  if (commentData == null) {
                    return const SizedBox.shrink();
                  }

                  final commenterID = commentData['commentedBy'] as String;

                  return FutureBuilder<Comment?>(
                    future: fetchCommenterData(commenterID, commentData),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const SizedBox.shrink();
                      }
                      if (snapshot.hasError) {
                        return const Center(child: Text('Error'));
                      }

                      final commenterData = snapshot.data;

                      if (commenterData != null) {
                        return CommentTile(comment: commenterData);
                      } else {
                        return const SizedBox.shrink();
                      }
                    },
                  );
                }
              },
            );
          }),
    );
  }
}
