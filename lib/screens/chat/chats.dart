import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:health_app1/screens/chat/chat_dao.dart';
import 'package:health_app1/screens/chat/chat_room.dart';

class Chats extends StatefulWidget {
  const Chats({Key? key}) : super(key: key);

  @override
  State<Chats> createState() => _ChatsState();
}

class _ChatsState extends State<Chats> {
  final ScrollController _scrollController = ScrollController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  ChatDao? chatDao;
  User? user;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _getUser();
  }

  Future<void> _getUser() async {
    user = _auth.currentUser;
    if (user != null) {
      chatDao = ChatDao(user!.uid);
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading || chatDao == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [_getChatList()],
        ),
      ),
    );
  }

  Widget _getChatList() {
    return Expanded(
      child: FirebaseAnimatedList(
        controller: _scrollController,
        query: chatDao!.getChatQuery(),
        itemBuilder: (context, snapshot, animation, index) {
          if (snapshot.value == null || snapshot.value is! Map) {
            return const SizedBox.shrink();
          }

          final json = Map<String, dynamic>.from(snapshot.value as Map);

          return ChatCard(
            userId: json['uid'] ?? 'No id',
            profileUrl: json['photo'] ?? '',
            userName: json['name'] ?? 'Not Set',
          );
        },
      ),
    );
  }
}

class ChatCard extends StatelessWidget {
  final String userId;
  final String profileUrl;
  final String userName;

  const ChatCard({
    Key? key,
    required this.userId,
    required this.profileUrl,
    required this.userName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 14),
      child: Card(
        color: Colors.blue[50],
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Container(
          padding: const EdgeInsets.only(left: 10, right: 10),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height / 9,
          child: TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatRoom(
                    user2Id: userId,
                    user2Name: userName,
                    profileUrl: profileUrl,
                  ),
                ),
              );
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(profileUrl),
                  backgroundColor: Colors.grey[300],
                  radius: 30,
                ),
                const SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      userName,
                      style: GoogleFonts.lato(
                        fontWeight: FontWeight.bold,
                        fontSize: 19,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
