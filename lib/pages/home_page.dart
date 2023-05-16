import 'package:esearchplayers/components/my_drawer.dart';
import 'package:esearchplayers/data/api_data.dart';
import 'package:esearchplayers/data/rank_data.dart';
import 'package:esearchplayers/data/user_data.dart';
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
  List<Character>? _myDataList = [];
  String myRank = '';
  int myRankApp = 0;
  String myRankAppImg = '';
  String myRankName = '';
  void logoutUser() {
    FirebaseAuth.instance.signOut();
  }

  @override
  void initState() {
    getAppRank();
    updateRankApp();
    getUserProfile();
    getRankGame();
    getCharactersList().then((value) => setState(() {
          _myDataList = value;
        }));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Home'),
          backgroundColor: Theme.of(context).primaryColor,
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: logoutUser,
            ),
          ],
        ),
        drawer: const MyDrawer(),
        backgroundColor: Color.fromRGBO(52, 53, 65, 1),
        body: Column(
          children: [
            Expanded(
              flex: 1,
              child: headerHome(),
            ),
            Expanded(
              flex: 2,
              child: Card(
                color: Colors.red,
                child: _myDataList == null
                    ? const CircularProgressIndicator()
                    : SingleChildScrollView(
                        child: DataTable(
                          columns: const [
                            DataColumn(label: Text('Name')),
                            DataColumn(label: Text('Role')),
                            //DataColumn(label: Text('Pick Rate')),
                            DataColumn(label: Text('Win Rate')),
                          ],
                          rows: _myDataList!
                              .map((data) => DataRow(cells: [
                                    DataCell(Text(data.name)),
                                    DataCell(Text(data.role)),
                                    DataCell(Text(data.winRate)),
                                  ]))
                              .toList(),
                        ),
                      ),

                // contenido de la segunda columna
              ),
            ),
            Expanded(
              flex: 3,
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.red, borderRadius: BorderRadius.circular(10)),
                padding: const EdgeInsets.all(5),
                child: Image.asset('lib/images/mapa_ascend.png'),
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
      }
    }
  }

  Widget headerHome() {
    return Container(
      decoration: BoxDecoration(
          color: Colors.red, borderRadius: BorderRadius.circular(10)),
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            children: [
              Text('Rango Game: ', style: TextStyle(color: Colors.grey[200])),
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
            children: [
              const Text('Rango App: '),
              SizedBox(
                height: 40,
                width: 40,
                child: myRankAppImg.isEmpty
                    ? const CircularProgressIndicator()
                    : Image.network(myRankAppImg, fit: BoxFit.cover),
              ),
              Text(myRankName ?? 'Valor por defecto')
            ],
          ),
        ],
      ),
    );
  }

  //Metodos
  Future getRankGame() async {
    final user = FirebaseAuth.instance.currentUser;
    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get();
    String tag = snapshot['tag'];
    tag = tag.replaceAll('#', '%23');
    var url = Uri.parse('http://192.168.1.135:3000/user/$tag');
    // Para python 5000 y para node 3000
    var response = await http.get(url);
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      String rank = jsonResponse['Rango'];
      String rankImage = jsonResponse['Icono'];
      //myRank = rank;
      // Realizar una consulta para obtener una referencia al documento basándote en el correo electrónico

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
      }
    }
  }

  void getAppRank() async {
    User? user = FirebaseAuth.instance.currentUser;
    final querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get();
    // Map<String, dynamic> userData =
    //     querySnapshot.data() as Map<String, dynamic>;
    //print(querySnapshot['RankApp']);
    //Usar la collecion de los rangos
    final snapshot = await FirebaseFirestore.instance
        .collection('ranksValorant')
        .doc(querySnapshot['RankApp'].toString())
        .get();
    setState(() {
      myRankApp = snapshot['id'];
      myRankName = snapshot['name'];
      myRankAppImg = snapshot['image'];
    });
  }

  void updateRankApp() async {
    User? user = FirebaseAuth.instance.currentUser;
    final querySnapshot = await FirebaseFirestore.instance
        .collection('rankSystem')
        .doc(user!.email)
        .get();
    if (querySnapshot['evaluation'].length > 9) {
      List<dynamic> evaluationList = querySnapshot['evaluation']
          .sublist(querySnapshot['evaluation'].length - 10);
      print(evaluationList.length);
      int lowerCount =
          evaluationList.where((element) => element == 'Lower_Rank').length;
      int equalCount =
          evaluationList.where((element) => element == 'Equal_Rank').length;
      int higherCount =
          evaluationList.where((element) => element == 'Higher_Rank').length;

      if (lowerCount > equalCount && lowerCount > higherCount) {
        // Realizar método para 'Lower_Rank'
        print('Realizando método para Lower_Rank');
        getRankNumber().then((value) => setRankApp(value - 1));
      } else if (equalCount > lowerCount && equalCount > higherCount) {
        // Realizar método para 'Equal_Rank'
        print('Realizando método para Equal_Rank');
        getRankNumber().then((value) => setRankApp(value));
      } else if (higherCount > lowerCount && higherCount > equalCount) {
        // Realizar método para 'Higher_Rank'
        print('Realizando método para Higher_Rank');
        getRankNumber().then((value) => setRankApp(value + 1));
        //setRankApp(snapshot['RankApp'] + 1);
      } else {
        // Si hay un empate o la lista está vacía, maneja el caso según tus necesidades
        getRankNumber().then((value) => setRankApp(value));
      }
      print('Lower: $lowerCount, Equal: $equalCount, Higher: $higherCount');
    } else {
      print('No se puede actualizar');
    }
    //'Lower_Rank', 'Equal_Rank', 'Higher_Rank'
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

