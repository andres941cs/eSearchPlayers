import 'package:cloud_firestore/cloud_firestore.dart';

FirebaseFirestore db = FirebaseFirestore.instance;

class Guild {
  final String id;
  final String name;
  final String description;
  //final String leader;
  final List<String> members;

  Guild({
    required this.id,
    required this.name,
    required this.description,
    //required this.leader,
    required this.members,
  });

  factory Guild.fromFirestore(QueryDocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();
    return Guild(
      id: doc.id,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      //leader: data['leader'] ?? '',
      members: List<String>.from(data['members'] ?? []),
    );
  }
}

Future<Guild> getGuildData(String nameGuild) async {
  final querySnapshot =
      await db.collection('guilds').where('name', isEqualTo: nameGuild).get();
  QueryDocumentSnapshot<Map<String, dynamic>> guildDoc =
      querySnapshot.docs.first;
  return Guild.fromFirestore(guildDoc);
}
