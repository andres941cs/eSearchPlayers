import 'package:esearchplayers/components/my_drawer.dart';
import 'package:esearchplayers/data/get_user_data.dart';
import 'package:esearchplayers/data/user_data.dart';
import 'package:esearchplayers/pages/login_or_register_page.dart';
import 'package:esearchplayers/pages/login_page.dart';
import 'package:esearchplayers/pages/profile_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Map<String, dynamic> _myData = {};
  String myRank = '';
  void logoutUser() {
    FirebaseAuth.instance.signOut();
  }

  @override
  void initState() {
    getUserProfile();
    super.initState();
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
                color: Colors.blue,
                child: ElevatedButton(
                    onPressed: getRankGame, child: Text('Get Rank')),
                // contenido de la segunda columna
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

  void getUserProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final querySnapshot = await db
          .collection('users')
          .where("email", isEqualTo: user.email)
          .get();

      if (querySnapshot.docs.length > 0) {
        final doc = querySnapshot.docs[0];
        final data = doc.data();
        // Usa los datos como desees
        print(data);
        setState(() {
          _myData = data;
        });
      } else {
        // No se encontró ningún documento
      }
      // El usuario no está conectado
    }
  }

  Widget headerHome() {
    return Container(
      decoration: BoxDecoration(
          color: Colors.blue, borderRadius: BorderRadius.circular(10)),
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            children: [
              const Text('Rango Game: '),
              SizedBox(
                height: 40,
                width: 40,
                child: Image.network(
                    _myData['rankImage'] ??
                        'https://media2.giphy.com/media/3o7bu3XilJ5BOiSGic/giphy.gif?cid=ecf05e47u7h4yuqnida1idvnrnfw520s8mpp8hcqmfjb9pjs&ep=v1_gifs_search&rid=giphy.gif&ct=g',
                    fit: BoxFit.cover),
              ),
              Text(
                  _myData['rank'] ?? 'Valor por defecto') //_myData['rankImage']
            ],
          ),
          Column(
            children: [Text('Rango App: '), Icon(Icons.games)],
          ),
        ],
      ),
    );
  }

  //Metodos
  Future getRankGame() async {
    var url = Uri.parse('http://192.168.1.135:5000/user/andres941%23EUW');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      String rank = jsonResponse['Rango'];
      String rankImage = jsonResponse['Icono'];
      //myRank = rank;
      // Realizar una consulta para obtener una referencia al documento basándote en el correo electrónico
      final user = FirebaseAuth.instance.currentUser;
      print(user!.email);
      final querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: user.email)
          .get();
      if (querySnapshot.size == 1) {
        final documentSnapshot = querySnapshot.docs[0];
        final documentReference = documentSnapshot.reference;
        // Actualizar los datos del documento
        documentReference.update({
          'rank': rank,
          'rankImage': rankImage,
        }).then((value) {
          print('Datos actualizados correctamente.');
        }).catchError((error) {
          print('Error al actualizar los datos: $error');
        });
      } else {
        print(
            'No se encontró ningún documento o se encontró más de un documento con el correo electrónico $user!.email');
      }
    }
  }

  //Fin de la clase
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

