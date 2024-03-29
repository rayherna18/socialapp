import 'package:flutter/material.dart';
import 'user_profile.dart';
import 'view_post.dart';
import 'add_post.dart';

class SocialMediaPost {
  final String username;
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
    required this.username,
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

  const SocialMediaPostCard({super.key, required this.post});

  @override
  State<SocialMediaPostCard> createState() => _SocialMediaPostCardState();
}

class _SocialMediaPostCardState extends State<SocialMediaPostCard> {
  bool isLiked = false;
  Icon unLikedIcon = const Icon(Icons.favorite_border);
  Icon likedIcon = const Icon(Icons.favorite, color: Colors.red);

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
                  Text(widget.post.username),
                  Text(' • '),
                  Text(widget.post.getPostedTime()),
                ],
              ),
              subtitle: Text(widget.post.handle)),
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
  const HomeFeedScreen({super.key});

  @override
  _HomeFeedState createState() => _HomeFeedState();
}

class _HomeFeedState extends State<HomeFeedScreen> {
  final List<SocialMediaPost> feedContent = [
    // to be replaced with actual data from DB
    SocialMediaPost(
      username: 'Alice',
      handle: '@alice',
      profileImageUrl: 'https://via.placeholder.com/150',
      postTimeStamp: DateTime.now(),
      postContent: 'This is my first post!',
      postImageUrl: 'https://via.placeholder.com/300',
    ),
    SocialMediaPost(
      username: 'Bob',
      handle: '@bob',
      profileImageUrl: 'https://via.placeholder.com/150',
      postTimeStamp: DateTime.now(),
      postContent: 'This is my first post!',
      postImageUrl: 'https://via.placeholder.com/300',
    ),
  ];

  @override
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
