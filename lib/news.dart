import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NewsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('News'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.add_box_outlined),
            onPressed: () {
              Navigator.pushNamed(context, '/upload');
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('posts').orderBy('timestamp', descending: true).snapshots(),
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
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final post = posts[index];
              final username = post['username'] ?? 'User';
              final imageUrl = post['imageUrl'] ?? '';
              final caption = post['caption'] ?? '';
              final likes = post['likes'] ?? 0;
              final timeAgo = post['timestamp'] != null
                  ? '${(DateTime.now().millisecondsSinceEpoch - post['timestamp'].millisecondsSinceEpoch) ~/ 1000} seconds ago'
                  : 'Unknown time';

              return _buildPostCard(
                context: context,
                username: username,
                imageUrl: imageUrl,
                caption: caption,
                likes: likes,
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
    required String username,
    required String imageUrl,
    required String caption,
    required int likes,
    required String timeAgo,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 3,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
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
                  backgroundImage: NetworkImage('https://example.com/profile_placeholder.jpg'),
                  radius: 20,
                ),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(username, style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
                Spacer(),
                IconButton(
                  icon: Icon(Icons.more_vert),
                  onPressed: () {},
                ),
              ],
            ),
          ),

          // Post Image
          Container(
            height: 250, // Adjusted height for more flexibility
            width: double.infinity,
            child: imageUrl.isNotEmpty
                ? Image.network(
              imageUrl,
              width: double.infinity,
              height: 250,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                        : null,
                  ),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey[200],
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.broken_image, size: 50),
                        Text('Failed to load image'),
                      ],
                    ),
                  ),
                );
              },
            )
                : Container(
              color: Colors.grey[300],
              child: Center(child: Icon(Icons.image_outlined)),
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
                    IconButton(icon: Icon(Icons.favorite_border), onPressed: () {}),
                    IconButton(icon: Icon(Icons.mode_comment_outlined), onPressed: () {}),
                    IconButton(icon: Icon(Icons.send_outlined), onPressed: () {}),
                    Spacer(),
                    IconButton(icon: Icon(Icons.bookmark_border), onPressed: () {}),
                  ],
                ),

                // Likes count
                Text('$likes likes', style: TextStyle(fontWeight: FontWeight.bold)),

                // Caption
                RichText(
                  text: TextSpan(
                    style: DefaultTextStyle.of(context).style,
                    children: [
                      TextSpan(
                        text: '$username ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(text: caption),
                    ],
                  ),
                ),

                // Timestamp
                Text(timeAgo, style: TextStyle(color: Colors.grey, fontSize: 10)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
