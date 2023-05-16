import 'package:esearchplayers/components/my_dialog_eval.dart';
import 'package:esearchplayers/data/user_data.dart';
import 'package:esearchplayers/pages/chat_page.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';

class MyPlayerList extends StatefulWidget {
  const MyPlayerList({super.key});

  @override
  State<MyPlayerList> createState() => _MyPlayerListState();
}

class _MyPlayerListState extends State<MyPlayerList> {
  String _name = 'Loading...';
  String _tag = 'Loading...';
  Widget _icon = const Icon(Icons.search);
  String _nameButton = 'Search';
  bool _searching = false;
  Map<String, dynamic> _myData = {};
  List<UserData> myTeam = [];
  //UserData(username: 'Loading...', email: 'Loading...', tag: 'Loading...'),
  List<String> namePlayers = [];
  void _loadData() async {
    if (_nameButton == 'Search') {
      _nameButton = 'Cancel';
      _searching = true;
      updateSearching(_myData['email'], _searching);
      isTeamCreated().then((value) => showTeamCreated(value));
    } else if (_nameButton == 'Cancel') {
      _nameButton = 'Search';
      _searching = false;
      updateSearching(_myData['email'], _searching);
    } else {
      //En caso de que el boton sea 'Finalizar equipo'
      deleteTeam();
      _nameButton = 'Search';
      myTeam.clear();
      //Pediente actualizar el icono
    }
    setState(() {
      _name = 'My Team';
      _tag = '#1234';
      //_icon = myMenu(myTeam[0]); //check
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
            leading: const Icon(Icons.person, size: 50.0, color: Colors.black),
            title: Text('Name: ${_myData['username']}',
                style: GoogleFonts.getFont(
                    'Righteous')), //"Name: $_myData['username']"
            subtitle: Text('Tag: ${_myData['tag']}'),
          )),
      Card(
          color: Colors.red,
          child: ListTile(
              leading: const Icon(Icons.person, size: 50.0),
              title: Text(
                'Name: ${myTeam.isNotEmpty ? myTeam[0].username : 'Loading...'}',
              ),
              subtitle: Text(
                  'Tag:  ${myTeam.isNotEmpty ? myTeam[0].tag : 'Loading...'}'),
              trailing: myTeam.isNotEmpty ? myMenu(myTeam[0]) : _icon)),
      Card(
        color: Colors.red,
        child: ListTile(
          leading: const Icon(Icons.person, size: 50.0),
          title: Text(
              'Name: ${myTeam.length > 1 ? myTeam[1].username : 'Loading...'}'),
          subtitle:
              Text('Tag:  ${myTeam.length > 1 ? myTeam[1].tag : 'Loading...'}'),
          trailing: myTeam.isNotEmpty ? myMenu(myTeam[1]) : _icon,
        ),
      ),
      Card(
          color: Colors.red,
          child: ListTile(
              leading: const Icon(Icons.person, size: 50.0),
              title: Text(
                  'Name: ${myTeam.length > 2 ? myTeam[2].username : 'Loading...'}'),
              subtitle: Text(
                  'Tag:  ${myTeam.length > 2 ? myTeam[2].tag : 'Loading...'}'),
              trailing: myTeam.isNotEmpty ? myMenu(myTeam[2]) : _icon)),
      Card(
          color: Colors.red,
          child: ListTile(
              leading: const Icon(Icons.person, size: 50.0),
              title: Text(
                  'Name: ${myTeam.length > 3 ? myTeam[3].username : 'Loading...'}'),
              subtitle: Text(
                  'Tag:  ${myTeam.length > 3 ? myTeam[3].tag : 'Loading...'}'),
              trailing: myTeam.isNotEmpty ? myMenu(myTeam[3]) : _icon)),
      ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red, // background
            foregroundColor: Colors.white, // foreground
          ),
          onPressed: () {
            setState(() {
              _icon = const CircularProgressIndicator(
                color: Colors.white,
              );
            });
            _loadData();
            //getUserProfile();
          },
          child: Text(_nameButton))
    ]);
  }

  Widget myMenu(UserData player) {
    return PopupMenuButton<String>(
      onSelected: (String result) {
        // Manejar la opción seleccionada
        switch (result) {
          case 'send_message':
            String id = '';
            getUserID(player.email).then((value) => id = value);
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ChatPage(
                          friendId: id,
                        ))); //
            break;
          case 'evaluate_player':
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return EvaluateDialog(
                    teamMate: player,
                  );
                });
            break;
        }
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        const PopupMenuItem<String>(
          value: 'send_message',
          child: Text('Send message'),
        ),
        const PopupMenuItem<String>(
          value: 'evaluate_player',
          child: Text('Evaluate player'),
        ),
      ],
    );
  }

  void searchPlayer() async {
    db = FirebaseFirestore.instance;
    QuerySnapshot querySnapshot = await db
        .collection('users')
        .where('search', isEqualTo: true)
        .where('email', isNotEqualTo: _myData['email'])
        .limit(4)
        .get(); //Modificar - Que filtre por rango
    if (querySnapshot.docs.isEmpty || querySnapshot.docs.length < 4) {
      print('No hay jugadores buscando equipo');
      //El booleano para que siga buscando
      //await Future.delayed(const Duration(seconds: 10)); Esto es como un sleep
    } else {
      myTeam.clear();
      for (int i = 0; i < querySnapshot.docs.length; i++) {
        var data = querySnapshot.docs[i].data();
        if (data is Map<String, dynamic>) {
          Map<String, dynamic> myData = data;
          UserData user = UserData(
            username: myData['username'],
            tag: myData['tag'],
            email: myData['email'],
          );
          setState(() {
            myTeam.add(user);
          });
          //Agrega el email del jugador al equipo
          namePlayers.add(myData['email']);
        }
      }
      namePlayers.add(_myData['email']); //Agrega el email del creador al equipo
      //Actualiza el booleano al crear un equipo
      updateSearching(_myData['email'], false);
      createTeam(namePlayers);
      setState(() {
        _nameButton = 'Finish';
      });
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
            myTeam.add(user);
          });
        }
      });
      //Actualiza el booleano al encontrar equipo
      updateSearching(_myData['email'], false);
      setState(() {
        _nameButton = 'Finish';
      });
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

  void deleteTeam() async {
    final teamsCollection = FirebaseFirestore.instance.collection('teams');
    QuerySnapshot querySnapshot = await teamsCollection
        .where('players', arrayContains: _myData['email'])
        .limit(1)
        .get();
    querySnapshot.docs.first.reference.delete();
  }
}
