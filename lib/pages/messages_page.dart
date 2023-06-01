import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:esearchplayers/pages/chat_page.dart';
import 'package:flutter/material.dart';

class MessagesPage extends StatefulWidget {
  const MessagesPage({super.key});

  @override
  State<MessagesPage> createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  final Color themeColor = const Color.fromRGBO(52, 53, 65, 1);
  final int _limit = 7;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text("Messages"),
          backgroundColor: Theme.of(context).primaryColor),
      backgroundColor: const Color.fromRGBO(52, 53, 65, 1),
      body: Container(
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('users')
              .limit(_limit)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(themeColor),
                ),
              );
            } else {
              return ListView.builder(
                padding: const EdgeInsets.all(10.0),
                itemCount: snapshot.data?.docs.length,
                itemBuilder: (context, index) =>
                    buildItem(context, snapshot.data?.docs[index]),
              );
            }
          },
        ),
      ),
    );
  }

  Widget buildItem(BuildContext context,
      QueryDocumentSnapshot<Map<String, dynamic>>? document) {
    return ListTile(
        leading: const Icon(
          Icons.account_circle,
          size: 50,
          color: Colors.white,
        ),
        title: Text(document!['username'],
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            )),
        subtitle: Text('Tag: ${document['tag']}',
            style: const TextStyle(color: Colors.grey)),
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ChatPage(
                        friendId: document.id,
                      )));
        });
  }
}
