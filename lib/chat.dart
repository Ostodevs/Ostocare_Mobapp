import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class ChatScreen extends StatefulWidget {
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? _editingMessageId;
  int daysLeft = 0;
  bool isOverdue = false;

  @override
  void initState() {
    super.initState();
    _sendInitialMessage();
    _fetchLastBagChangeDate();
  }

  Future<void> _fetchLastBagChangeDate() async {
    final user = _auth.currentUser;
    if (user == null) return;

    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    if (userDoc.exists && userDoc.data() != null) {
      Timestamp? lastChangeTimestamp = userDoc.get('lastBagChangeDate');
      if (lastChangeTimestamp != null) {
        DateTime lastChangeDate = lastChangeTimestamp.toDate();
        int difference = DateTime.now().difference(lastChangeDate).inDays;
        setState(() {
          daysLeft = 7 - difference;
          isOverdue = daysLeft < 0;
        });
      }
    }
  }

  void _sendInitialMessage() async {
    final user = _auth.currentUser;
    if (user == null) return;

    final ref = FirebaseFirestore.instance
        .collection('chat_history')
        .doc(user.uid)
        .collection('messages');

    final snapshot = await ref.get();

    if (snapshot.docs.isEmpty) {
      await ref.add({
        'sender': 'system',
        'message': "Hi there, what's up with you today?",
        'timestamp': FieldValue.serverTimestamp(),
      });
    }
  }

  void _sendMessage() async {
    final user = _auth.currentUser;
    final message = _messageController.text.trim();

    if (message.isEmpty || user == null) return;

    if (_editingMessageId != null) {
      await FirebaseFirestore.instance
          .collection('chat_history')
          .doc(user.uid)
          .collection('messages')
          .doc(_editingMessageId)
          .update({'message': message});
      _editingMessageId = null;
    } else {
      await FirebaseFirestore.instance
          .collection('chat_history')
          .doc(user.uid)
          .collection('messages')
          .add({
        'sender': 'user',
        'message': message,
        'timestamp': FieldValue.serverTimestamp(),
      });

      Future.delayed(Duration(milliseconds: 300), () {
        _generateSystemReply(message);
      });
    }

    _messageController.clear();
    _scrollToBottom();
  }

  void _generateSystemReply(String userMessage) async {
    final user = _auth.currentUser;
    if (user == null) return;

    String reply = "I'm here to help you!";
    final lowerMessage = userMessage.toLowerCase();

    if (lowerMessage.contains("name")) {
      reply = "Your name is ${user.displayName ?? 'User'}.";
    } else if (lowerMessage.contains("bag change") ||
        lowerMessage.contains("days left")) {
      await _fetchLastBagChangeDate();
      reply = isOverdue
          ? "You are overdue by ${-daysLeft} days for your bag change."
          : "You have $daysLeft days left for your next bag change.";
    } else if (lowerMessage.contains("settings")) {
      reply =
      "You can manage your preferences in the Settings page. Tap the button below to go to the Settings page.";
      _sendRouteReply(reply, '/settings');
      return;
    } else if (lowerMessage.contains("profile")) {
      reply = "Here is your profile. Tap the button to view it.";
      _sendRouteReply(reply, '/profile');
      return;
    } else if (lowerMessage.contains("upload")) {
      reply = "You can upload a new post from the Upload page.";
      _sendRouteReply(reply, '/upload');
      return;
    } else if (lowerMessage.contains("search")) {
      reply = "Looking for something? Try the search page!";
      _sendRouteReply(reply, '/search');
      return;
    } else if (lowerMessage.contains("supply")) {
      reply = "You can choose between government and private hospitals here.";
      _sendRouteReply(reply, '/supplyselect');
      return;
    } else if (lowerMessage.contains("home")) {
      reply = "You can go to the Home.";
      _sendRouteReply(reply, '/');
      return;
    }

    await FirebaseFirestore.instance
        .collection('chat_history')
        .doc(user.uid)
        .collection('messages')
        .add({
      'sender': 'system',
      'message': reply,
      'timestamp': FieldValue.serverTimestamp(),
    });

    _scrollToBottom();
  }

  void _sendRouteReply(String message, String routeName) async {
    final user = _auth.currentUser;
    if (user == null) return;

    await FirebaseFirestore.instance
        .collection('chat_history')
        .doc(user.uid)
        .collection('messages')
        .add({
      'sender': 'system',
      'message': message,
      'timestamp': FieldValue.serverTimestamp(),
      'route': routeName,
    });

    _scrollToBottom();
  }

  void _deleteMessage(String docId) async {
    final user = _auth.currentUser;
    if (user == null) return;

    await FirebaseFirestore.instance
        .collection('chat_history')
        .doc(user.uid)
        .collection('messages')
        .doc(docId)
        .delete();
  }

  void _editMessage(String docId, String currentMessage) {
    setState(() {
      _editingMessageId = docId;
      _messageController.text = currentMessage;
    });
  }

  void _scrollToBottom() {
    Future.delayed(Duration(milliseconds: 300), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          0.0,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }
  // Function to clear chat history
  void _clearChatHistory() async {
    final user = _auth.currentUser;
    if (user == null) return;

    final messagesRef = FirebaseFirestore.instance
        .collection('chat_history')
        .doc(user.uid)
        .collection('messages');

    // Delete all messages
    final querySnapshot = await messagesRef.get();
    for (var doc in querySnapshot.docs) {
      await doc.reference.delete();
    }
  }

  Widget _buildMessageBubble(String text, String sender, Timestamp timestamp,
      String docId, [String? route]) {
    final isUser = sender == 'user';
    final timeString = DateFormat('hh:mm a').format(timestamp.toDate());

    return GestureDetector(
      onTap: isUser ? () => _editMessage(docId, text) : null,
      onLongPress: isUser
          ? () => showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text("Delete this message?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                _deleteMessage(docId);
                Navigator.pop(context);
              },
              child: Text("Delete", style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
      )
          : null,
      child: Align(
        alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 6, horizontal: 10),
          padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: isUser ? Colors.deepPurple[200] : Colors.grey[300],
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(18),
              topRight: Radius.circular(18),
              bottomLeft: Radius.circular(isUser ? 18 : 0),
              bottomRight: Radius.circular(isUser ? 0 : 18),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(text, style: TextStyle(fontSize: 16, color: Colors.black87)),
              SizedBox(height: 4),
              Text(timeString, style: TextStyle(fontSize: 12, color: Colors.black54)),
              if (route != null)
                TextButton(
                  onPressed: () => Navigator.pushNamed(context, route),
                  child: Text("Go to page", style: TextStyle(color: Colors.deepPurple)),
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = _auth.currentUser;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.deepPurple, Colors.purpleAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.vertical(
              bottom: Radius.elliptical(300, 50),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 15,
                offset: Offset(0, 6),
              )
            ],
          ),
          child: SafeArea(
            child: Column(
              children: [
                // Back button section, aligned closer to the top
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Align(
                    alignment: Alignment(-0.94, 0),
                    child: IconButton(
                      icon: Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ),
                // Title in the center
                Expanded(
                  child: Center(
                    child: Text(
                      'Chat with Ostocare',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            color: Colors.black26,
                            blurRadius: 4,
                            offset: Offset(1, 2),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('chat_history')
                  .doc(user?.uid)
                  .collection('messages')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return Center(child: CircularProgressIndicator());

                final messages = snapshot.data!.docs;

                return ListView.builder(
                  controller: _scrollController,
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final data = messages[index].data() as Map<String, dynamic>;
                    return _buildMessageBubble(
                      data['message'] ?? '',
                      data['sender'] ?? '',
                      data['timestamp'] ?? Timestamp.now(),
                      messages[index].id,
                      data['route'],
                    );
                  },
                );
              },
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            color: Colors.grey[100],
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: _editingMessageId != null
                          ? "Editing message..."
                          : "Type your message...",
                      border: InputBorder.none,
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send, color: Colors.deepPurple),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: Align(
        alignment: Alignment.topRight,
        child: Padding(
          padding: const EdgeInsets.only(top: 25.0, right: 5.0),
          child: PopupMenuButton(
            icon: Icon(
              Icons.more_vert,
              color: Colors.white,
            ),
            onSelected: (value) {
              if (value == 'clear') {
                _clearChatHistory();
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'clear',
                child: Text("Clear All Chat History"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
