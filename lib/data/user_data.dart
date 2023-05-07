import 'package:cloud_firestore/cloud_firestore.dart';

FirebaseFirestore db = FirebaseFirestore.instance;

// Un metodo que devuelve el tag de un usuario
Future<String> getUserTag(email) async {
  QuerySnapshot querySnapshot =
      await db.collection('users').where('email', isEqualTo: email).get();
  //if (querySnapshot.docs.isNotEmpty) {}
  String user = querySnapshot.docs[0].get('tag');
  return user;
}

Future<String> getUserName(email) async {
  QuerySnapshot querySnapshot =
      await db.collection('users').where('email', isEqualTo: email).get();
  //if (querySnapshot.docs.isNotEmpty) {}
  String user = querySnapshot.docs[0].get('username');
  return user;
}

Future<UserData> getUserData(email) async {
  QuerySnapshot querySnapshot =
      await db.collection('users').where('email', isEqualTo: email).get();
  //if (querySnapshot.docs.isNotEmpty) {}
  UserData userData = UserData(
    username: querySnapshot.docs[0].get('username'),
    email: querySnapshot.docs[0].get('email'),
    tag: querySnapshot.docs[0].get('tag'),
    profileImageUrl: querySnapshot.docs[0].get('profileImageUrl'),
  );
  return userData;
}

Future<String> getUserClanName(email) async {
  QuerySnapshot querySnapshot =
      await db.collection('users').where('email', isEqualTo: email).get();
  //if (querySnapshot.docs.isNotEmpty) {}
  String clanName = querySnapshot.docs[0].get('guildName');
  return clanName;
}

class UserData {
  final String username;
  final String email;
  final String tag;
  final String? profileImageUrl;

  UserData({
    required this.username,
    required this.email,
    required this.tag,
    this.profileImageUrl,
  });

  factory UserData.fromDocument(DocumentSnapshot doc) {
    return UserData(
      username: doc['username'],
      email: doc['email'],
      tag: doc['tag'],
      profileImageUrl: doc['profileImageUrl'],
    );
  }

  UserData.fromMap(Map<String, dynamic> map)
      : username = map['name'],
        email = map['email'],
        tag = map['tag'],
        profileImageUrl = map['profileImageUrl'];
}

// Un metodo que actualiza el booleano de un usuario
Future<void> updateSearching(email, boolValue) async {
  await db
      .collection('users')
      .where('email', isEqualTo: email)
      .get()
      .then((snapshot) => {
            if (snapshot.docs.isNotEmpty)
              {
                snapshot.docs[0].reference.update({"search": boolValue})
              }
          });
}
