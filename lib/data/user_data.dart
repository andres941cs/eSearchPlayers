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
  );
  return userData;
}

class UserData {
  final String username;
  final String email;
  final String tag;

  UserData({
    required this.username,
    required this.email,
    required this.tag,
  });

  factory UserData.fromDocument(DocumentSnapshot doc) {
    return UserData(
      username: doc['username'],
      email: doc['email'],
      tag: doc['tag'],
    );
  }
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
