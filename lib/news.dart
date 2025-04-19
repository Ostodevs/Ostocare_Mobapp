import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:timeago/timeago.dart' as timeago;

class NewsPage extends StatefulWidget {
  @override
  _NewsPageState createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _likePost(String postId) async {
    String userId = _auth.currentUser?.uid ?? "";
    if (userId.isEmpty) return;

    DocumentReference postRef = FirebaseFirestore.instance.collection('posts').doc(postId);
    DocumentSnapshot postSnapshot = await postRef.get();

    if (postSnapshot.exists) {
      List likedUsers = List.from(postSnapshot['likedUsers'] ?? []);
      if (likedUsers.contains(userId)) {
        likedUsers.remove(userId);
      } else {
        likedUsers.add(userId);
      }

      // Update the post immediately
      await postRef.update({'likedUsers': likedUsers});
      setState(() {});  // Force UI update for the like status
    }
  }


  Future<void> _savePost(String postId) async {
    String userId = _auth.currentUser?.uid ?? "";
    if (userId.isEmpty) return;

    DocumentReference postRef = FirebaseFirestore.instance.collection('posts').doc(postId);
    DocumentSnapshot postSnapshot = await postRef.get();

    if (postSnapshot.exists) {
      List savedBy = List.from(postSnapshot['savedBy'] ?? []);
      if (savedBy.contains(userId)) {
        savedBy.remove(userId);
      } else {
        savedBy.add(userId);
      }
      await postRef.update({'savedBy': savedBy});
    }
  }
  Future<void> _softDeleteComment(String postId, String commentId) async {
    String userId = _auth.currentUser?.uid ?? "";
    DocumentSnapshot commentSnapshot = await FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .doc(commentId)
        .get();

    if (commentSnapshot.exists) {
      String commentOwner = commentSnapshot['userId'];
      if (commentOwner == userId) {
        await FirebaseFirestore.instance
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .update({'deleted': true});
      } else {
        // Optionally, show a message if the user is not the owner
        print("You can only delete your own comments.");
      }
    }
  }

  void _showAllCommentsDialog(BuildContext context, String postId) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Container(
            height: 400,
            padding: EdgeInsets.all(12),
            child: Column(
              children: [
                Text('All Comments', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Divider(),
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('posts')
                        .doc(postId)
                        .collection('comments')
                        .orderBy('timestamp')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Center(child: CircularProgressIndicator());
                      }

                      final allComments = snapshot.data!.docs
                          .where((doc) => !(doc['deleted'] ?? false))
                          .toList();

                      return ListView.builder(
                        itemCount: allComments.length,
                        itemBuilder: (context, index) {
                          final commentDoc = allComments[index];
                          final commentData = commentDoc.data() as Map<String, dynamic>;
                          final isCommentOwner = commentData['userId'] == _auth.currentUser?.uid;

                          return ListTile(
                            title: RichText(
                              text: TextSpan(
                                style: DefaultTextStyle.of(context).style,
                                children: [
                                  TextSpan(
                                    text: '${commentData['username'] ?? 'User'}: ',
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  TextSpan(text: commentData['comment'] ?? ''),
                                ],
                              ),
                            ),
                            trailing: isCommentOwner
                                ? IconButton(
                              icon: Icon(Icons.delete_outline, color: Colors.grey),
                              onPressed: () {
                                _softDeleteComment(postId, commentDoc.id);
                              },
                            )
                                : null,
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _commentOnPost(String postId, String comment) async {
    String userId = _auth.currentUser?.uid ?? "";
    if (userId.isEmpty || comment.isEmpty) return;

    DocumentSnapshot userSnapshot = await FirebaseFirestore.instance.collection('users').doc(userId).get();
    String username = userSnapshot.exists ? (userSnapshot.data() as Map<String, dynamic>)['username'] ?? 'User' : 'User';

    DocumentReference postRef = FirebaseFirestore.instance.collection('posts').doc(postId);
    await postRef.collection('comments').add({
      'userId': userId,
      'username': username,
      'comment': comment,
      'timestamp': FieldValue.serverTimestamp(),
      'deleted': false,
    });
  }

  Widget _buildPostImage(String imageUrl, String assetImage) {
    if (assetImage.isNotEmpty) {
      return Image.asset('assets/$assetImage', fit: BoxFit.cover);
    } else if (imageUrl.isNotEmpty) {
      return Image.network(imageUrl, fit: BoxFit.cover);
    } else {
      return Container(
        color: Colors.grey[300],
        child: Center(child: Icon(Icons.image_outlined)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Osto News'),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('posts')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Something went wrong.'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No posts available.'));
          }

          final posts = snapshot.data!.docs;

          return ListView.builder(
            physics: BouncingScrollPhysics(),
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final post = posts[index];
              final postId = post.id;
              final username = post['username'] ?? 'User';
              final assetImage = post['assetImage'] ?? '';
              final imageUrl = post['imageUrl'] ?? '';
              final caption = post['caption'] ?? '';
              final likes = post['likedUsers']?.length ?? 0;
              final savedBy = post['savedBy']?.length ?? 0;
              final timestamp = post['timestamp'];
              final timeAgo = timestamp != null
                  ? timeago.format((timestamp as Timestamp).toDate())
                  : 'Unknown time';

              return _buildPostCard(
                context: context,
                postId: postId,
                username: username,
                imageUrl: imageUrl,
                assetImage: assetImage,
                caption: caption,
                likes: likes,
                savedBy: savedBy,
                timeAgo: timeAgo,
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildPostCard({
    required BuildContext context,
    required String postId,
    required String username,
    required String imageUrl,
    required String assetImage,
    required String caption,
    required int likes,
    required int savedBy,
    required String timeAgo,
  }) {
    String currentUser = _auth.currentUser?.uid ?? "";

    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance.collection('posts').doc(postId).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return SizedBox();

        final post = snapshot.data!;
        final likedUsers = List.from(post['likedUsers'] ?? []);
        final isLiked = likedUsers.contains(currentUser);

        return Container(
          margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.2), spreadRadius: 3, blurRadius: 5)],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: AssetImage('assets/${post['userAvatar'] ?? 'Avatar1.png'}'),
                      radius: 20,
                    ),
                    SizedBox(width: 10),
                    Text(username, style: TextStyle(fontWeight: FontWeight.bold)),
                    Spacer(),
                    IconButton(icon: Icon(Icons.more_vert), onPressed: () {}),
                  ],
                ),
              ),

              // Post Image with double tap
              GestureDetector(
                onDoubleTap: () => _likePost(postId),
                child: AspectRatio(
                  aspectRatio: 1,
                  child: _buildPostImage(imageUrl, assetImage),
                ),
              ),

              // Footer Section
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Action Buttons
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(
                            isLiked ? Icons.favorite : Icons.favorite_border,
                            color: isLiked ? Colors.red : null,
                          ),
                          onPressed: () => _likePost(postId),
                        ),
                        IconButton(
                          icon: Icon(Icons.mode_comment_outlined),
                          onPressed: () => _showCommentDialog(postId),
                        ),
                        Spacer(),
                        IconButton(
                          icon: Icon(Icons.bookmark_border),
                          onPressed: () => _savePost(postId),
                        ),
                      ],
                    ),

                    Text('${likedUsers.length} likes', style: TextStyle(fontWeight: FontWeight.bold)),

                    // Caption
                    RichText(
                      text: TextSpan(
                        style: DefaultTextStyle.of(context).style,
                        children: [
                          TextSpan(text: '$username ', style: TextStyle(fontWeight: FontWeight.bold)),
                          TextSpan(text: caption),
                        ],
                      ),
                    ),

                    SizedBox(height: 4),

                    // Comments Preview
                    StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('posts')
                          .doc(postId)
                          .collection('comments')
                          .orderBy('timestamp')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                          return Text('No comments yet', style: TextStyle(color: Colors.grey));
                        }

                        final allComments = snapshot.data!.docs
                            .where((doc) => !(doc['deleted'] ?? false))
                            .toList();

                        final visibleComments = allComments.take(2).toList();
                        final hasMoreComments = allComments.length > 2;

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ...visibleComments.map((commentDoc) {
                              final commentData = commentDoc.data() as Map<String, dynamic>;
                              final isCommentOwner = commentData['userId'] == _auth.currentUser?.uid;

                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 2),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: RichText(
                                        text: TextSpan(
                                          style: DefaultTextStyle.of(context).style,
                                          children: [
                                            TextSpan(
                                              text: '${commentData['username'] ?? 'User'}: ',
                                              style: TextStyle(fontWeight: FontWeight.bold),
                                            ),
                                            TextSpan(text: commentData['comment'] ?? ''),
                                          ],
                                        ),
                                      ),
                                    ),
                                    if (isCommentOwner)
                                      IconButton(
                                        icon: Icon(Icons.delete_outline, size: 18, color: Colors.grey),
                                        onPressed: () {
                                          _softDeleteComment(postId, commentDoc.id);
                                        },
                                      ),
                                  ],
                                ),
                              );
                            }),

                            if (hasMoreComments)
                              GestureDetector(
                                onTap: () => _showAllCommentsDialog(context, postId),
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 4),
                                  child: Text(
                                    'View all comments',
                                    style: TextStyle(color: Colors.grey[600], fontSize: 13),
                                  ),
                                ),
                              ),
                          ],
                        );
                      },
                    ),

                    SizedBox(height: 4),
                    Text(timeAgo, style: TextStyle(color: Colors.grey, fontSize: 10)),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  _showCommentDialog(String postId) {
    TextEditingController commentController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add a comment'),
          content: TextField(
            controller: commentController,
            decoration: InputDecoration(hintText: 'Write your comment...'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _commentOnPost(postId, commentController.text);
                Navigator.pop(context);
              },
              child: Text('Post'),
            ),
          ],
        );
      },
    );
  }
}
