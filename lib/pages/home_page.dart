import 'package:esearchplayers/components/my_drawer.dart';
import 'package:esearchplayers/data/get_user_data.dart';
import 'package:esearchplayers/data/user_data.dart';
import 'package:esearchplayers/pages/login_or_register_page.dart';
import 'package:esearchplayers/pages/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final user = FirebaseAuth.instance.currentUser;

  //LISTA DE IDs
  /*
  List<String> documents = [];

  Future getDocs() async {
    await FirebaseFirestore.instance
        .collection("users")
        .get()
        .then((snapshot) => snapshot.docs.forEach(
              (doc) {
                documents.add(doc.reference.id);
              },
            ));
  }
  */
  void logoutUser() {
    FirebaseAuth.instance.signOut();
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => LoginOrRegisterPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Home Page'),
          backgroundColor: Theme.of(context).primaryColor,
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: logoutUser,
            ),
          ],
        ),
        drawer: const MyDrawer(),
        body: Column(
          children: [
            Expanded(
              flex: 1,
              child: headerHome(),
            ),
            Expanded(
              flex: 2,
              child: Container(
                // contenido de la segunda columna
                color: Colors.blue,
              ),
            ),
            Expanded(
              flex: 3,
              child: Container(
                // contenido de la tercera columna
                color: Colors.green,
              ),
            ),
          ],
        ));
  }
}
/* 
Column(children: [
          Text("Logged In as " + user!.email!),
          
        ])
Expanded(
              child: FutureBuilder(
            future: getUserTag(user!.email!),
            builder: (context, snapshot) {
              return Text(snapshot.data.toString());
            },
          ))
*/

Widget headerHome() {
  return Container(
    decoration: BoxDecoration(
        color: Colors.blue, borderRadius: BorderRadius.circular(10)),
    padding: const EdgeInsets.all(10),
    margin: const EdgeInsets.all(10),
    child: const Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Column(
          children: [Text('Rango Game: '), Icon(Icons.gamepad)],
        ),
        Column(
          children: [Text('Rango App: '), Icon(Icons.games)],
        ),
      ],
    ),
  );
}

//Metodos
