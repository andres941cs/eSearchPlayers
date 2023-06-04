import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

FirebaseFirestore db = FirebaseFirestore.instance;

//Edita el perfil del usuario
void editUserProfile({
  required String username,
  required String tag,
  //required String profileImageUrl
}) async {
  User? user = FirebaseAuth.instance.currentUser;
  final querySnapshot =
      await FirebaseFirestore.instance.collection('users').doc(user!.uid).get();

  querySnapshot.reference.update({
    'username': username,
    'tag': tag,
    //'profileImageUrl': profileImageUrl,
  });
}

//  Un metodo que devuelve el tag de un usuario
// Future<String> getUserTag(email) async {
//   QuerySnapshot querySnapshot =
//       await db.collection('users').where('email', isEqualTo: email).get();
//   //if (querySnapshot.docs.isNotEmpty) {}
//   String user = querySnapshot.docs[0].get('tag');
//   return user;
// }

// Future<String> getUserName(email) async {
//   QuerySnapshot querySnapshot =
//       await db.collection('users').where('email', isEqualTo: email).get();
//   //if (querySnapshot.docs.isNotEmpty) {}
//   String user = querySnapshot.docs[0].get('username');
//   return user;
// }

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

//Clase que contiene los datos de un usuario
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

// Cambia el booleano del estado de busqueda
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

// Obtiene  el id de un usuario con el email
Future<String> getUserID(email) async {
  QuerySnapshot querySnapshot =
      await db.collection('users').where('email', isEqualTo: email).get();
  //if (querySnapshot.docs.isNotEmpty) {}
  String userID = querySnapshot.docs[0].id;
  return userID;
}
