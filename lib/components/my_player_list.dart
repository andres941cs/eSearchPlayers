import 'package:esearchplayers/data/user_data.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/retry.dart';

class MyPlayerList extends StatefulWidget {
  const MyPlayerList({super.key});

  @override
  State<MyPlayerList> createState() => _MyPlayerListState();
}

class _MyPlayerListState extends State<MyPlayerList> {
  String _name = 'Loading...';
  String _tag = 'Loading...';
  Widget _icon = const Icon(Icons.more_vert);
  String _nameButton = 'Search';
  bool _searching = false;
  Map<String, dynamic> _myData = {};
  List<UserData> myTeam = [];
  //UserData(username: 'Loading...', email: 'Loading...', tag: 'Loading...'),
  List<String> namePlayers = [];
  void _loadData() async {
    // Aquí puede agregar código para cargar los datos del equipo.
    // En este ejemplo, simplemente simularemos una carga de datos de 2 segundos
    if (_nameButton == 'Search') {
      _nameButton = 'Cancel';
      _searching = true;
      updateSearching("user@gmail.com", _searching);
    } else {
      _nameButton = 'Search';
      _searching = false;
      updateSearching("user@gmail.com", _searching);
    }

    await Future.delayed(const Duration(seconds: 10));

    setState(() {
      _name = 'My Team';
      _tag = '#1234';
      _icon = const Icon(Icons.check);
    });
  }

  @override
  void initState() {
    super.initState();
    getUserProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Card(
          color: Colors.red,
          child: ListTile(
              leading: const Icon(Icons.person, size: 50.0),
              title: Text(
                  'Name: ${_myData['username']}'), //"Name: $_myData['username']"
              subtitle: Text('Tag: ${_myData['tag']}'),
              trailing: _icon)),
      Card(
          color: Colors.red,
          child: ListTile(
              leading: const Icon(Icons.person, size: 50.0),
              title: Text(
                  'Name: ${myTeam.isNotEmpty ? myTeam[0].username : 'Loading...'}'),
              subtitle: Text(
                  'Tag:  ${myTeam.isNotEmpty ? myTeam[0].tag : 'Loading...'}'),
              trailing: _icon)),
      Card(
          color: Colors.red,
          child: ListTile(
              leading: const Icon(Icons.person, size: 50.0),
              title: Text(
                  'Name: ${myTeam.length > 1 ? myTeam[1].username : 'Loading...'}'),
              subtitle: Text(
                  'Tag:  ${myTeam.length > 1 ? myTeam[1].tag : 'Loading...'}'),
              trailing: _icon)),
      Card(
          color: Colors.red,
          child: ListTile(
              leading: const Icon(Icons.person, size: 50.0),
              title: Text(
                  'Name: ${myTeam.length > 2 ? myTeam[2].username : 'Loading...'}'),
              subtitle: Text(
                  'Tag:  ${myTeam.length > 2 ? myTeam[2].tag : 'Loading...'}'),
              trailing: _icon)),
      Card(
          color: Colors.red,
          child: ListTile(
              leading: const Icon(Icons.person, size: 50.0),
              title: Text(
                  'Name: ${myTeam.length > 3 ? myTeam[3].username : 'Loading...'}'),
              subtitle: Text(
                  'Tag:  ${myTeam.length > 3 ? myTeam[3].tag : 'Loading...'}'),
              trailing: _icon)),
      ElevatedButton(
          onPressed: () {
            isTeamCreated().then((value) => showTeamCreated(value));

            setState(() {
              _icon = const CircularProgressIndicator();
            });
            //_loadData();
            //getUserProfile();
          },
          child: Text(_nameButton))
    ]);
  }

  void searchPlayer() async {
    db = FirebaseFirestore.instance;
    QuerySnapshot querySnapshot = await db
        .collection('users')
        .where('search', isEqualTo: true)
        .where('email', isNotEqualTo: _myData['email'])
        .limit(4)
        .get(); //Modificar - Al final buscara a 4 jugadores
    //List<UserData> listUsers = [];
    if (querySnapshot.docs.isEmpty) {
      print('No hay jugadores buscando equipo');
    } else {
      myTeam.clear();
      for (int i = 0; i < querySnapshot.docs.length; i++) {
        print(querySnapshot.docs[i].data());
        var data = querySnapshot.docs[i].data();
        if (data is Map<String, dynamic>) {
          Map<String, dynamic> myData = data;
          UserData user = UserData(
            username: myData['username'],
            tag: myData['tag'],
            email: myData['email'],
          );
          // Haz lo que necesites con myData

          setState(() {
            myTeam.add(user); //querySnapshot.docs[i].data()
          });
          namePlayers.add(myData['email']);
          //print(myTeam[0].username);
        }

        //createTeam(teamPlayers);
      }
      namePlayers.add(_myData['email']);
      createTeam(namePlayers);
    }
  }

  Future<List<dynamic>?> isTeamCreated() async {
    //Para saber si el equipo ya fue creado
    db = FirebaseFirestore.instance;
    QuerySnapshot querySnapshot = await db
        .collection('teams')
        .where('players', arrayContains: _myData['email'])
        .limit(1)
        .get();
    if (querySnapshot.docs.isEmpty) {
      //print('No hay equipos creados');
      return null;
    } else {
      List<dynamic> teamPlayersC = querySnapshot.docs.first.get(('players'));
      return teamPlayersC;
    }
  }

  void showTeamCreated(List<dynamic>? teamCreate) async {
    //List<dynamic>? teamPlayers = await isTeamCreated();
    if (teamCreate == null) {
      //Se crear el equipo
      searchPlayer();
    } else {
      //Se muestra el equipo
      print(myTeam);
      myTeam.clear();
      teamCreate.forEach((element) async {
        print(_myData['email']);
        if (element != _myData['email']) {
          db = FirebaseFirestore.instance;
          QuerySnapshot querySnapshot = await db
              .collection('users')
              .where('email', isEqualTo: element)
              .limit(1)
              .get();
          final doc = querySnapshot.docs[0];
          final user = UserData.fromDocument(doc);
          setState(() {
            myTeam.add(user); //querySnapshot.docs[i].data()
          });
          print(user.username);
        }
      });

      print(myTeam);
      /*
      setState(() {
        myTeam.add(user); //querySnapshot.docs[i].data()
      });
      */
    }
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

  void createTeam(List<String> namePlayers) async {
    final teamsCollection = FirebaseFirestore.instance.collection('teams');
    // Crea un nuevo documento en la colección y guarda los valores del clan.
    teamsCollection.add({'players': namePlayers});
  }
}
