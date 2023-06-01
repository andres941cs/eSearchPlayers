import 'package:cloud_firestore/cloud_firestore.dart';

class MessageChat {
  final String idFrom;
  final String idTo;
  final String timestamp;
  final String content;
  final int type;

  const MessageChat({
    required this.idFrom,
    required this.idTo,
    required this.timestamp,
    required this.content,
    required this.type,
  });

  Map<String, dynamic> toJson() {
    return {
      "idFrom": idFrom,
      "idTo": idTo,
      "timestamp": timestamp,
      "content": content,
      "type": type,
    };
  }

  factory MessageChat.fromDocument(DocumentSnapshot doc) {
    String idFrom = doc.get("idFrom");
    String idTo = doc.get("idTo");
    String timestamp = doc.get("timestamp");
    String content = doc.get("content");
    int type = doc.get("type");
    return MessageChat(
        idFrom: idFrom,
        idTo: idTo,
        timestamp: timestamp,
        content: content,
        type: type);
  }
}

//Clase TypeMessage
class TypeMessage {
  static const text = 0;
  static const image = 1;
}

//METODOS
Stream<QuerySnapshot> getChatStream(String groupChatId, int limit) {
  return FirebaseFirestore.instance
      .collection('messages')
      .doc(groupChatId)
      .collection(groupChatId)
      .orderBy('timestamp', descending: true)
      .limit(limit)
      .snapshots();
}

void sendMessage(String content, int type, String groupChatId,
    String currentUserId, String peerId) {
  DocumentReference documentReference = FirebaseFirestore.instance
      .collection('messages')
      .doc(groupChatId)
      .collection(groupChatId)
      .doc(DateTime.now().millisecondsSinceEpoch.toString());

  MessageChat messageChat = MessageChat(
    idFrom: currentUserId,
    idTo: peerId,
    timestamp: DateTime.now().millisecondsSinceEpoch.toString(),
    content: content,
    type: type,
  );

  FirebaseFirestore.instance.runTransaction((transaction) async {
    transaction.set(
      documentReference,
      messageChat.toJson(),
    );
  });
}
