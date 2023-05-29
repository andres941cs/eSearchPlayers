import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:esearchplayers/components/my_drawer.dart';
import 'package:esearchplayers/data/guild_data.dart';
import 'package:esearchplayers/data/user_data.dart' as user_data;
import 'package:esearchplayers/pages/guild_home_page.dart';
import 'package:esearchplayers/pages/guild_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';

class MyGuildPage extends StatefulWidget {
  const MyGuildPage({super.key});

  @override
  State<MyGuildPage> createState() => _MyGuildPageState();
}

class _MyGuildPageState extends State<MyGuildPage> {
  final user = FirebaseAuth.instance.currentUser;
  //User? currentUser;
  String clanName = '';
  Guild? guild;
  @override
  void initState() {
    super.initState();

    user_data
        .getUserClanName(user!.email)
        .then((value) {
          setState(() {
            clanName = value;
          });
        })
        .then((_) => getGuildData(clanName))
        .then((value) {
          setState(() {
            guild = value;
          });
        });

    print(clanName);
    /*
    getGuildData(clanName).then((value) {
      setState(() {
        guild = value;
      });
    });
    */
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      drawer: const MyDrawer(),
      appBar: AppBar(
        title: const Text('My Guild'),
        centerTitle: true,
        backgroundColor: Colors.grey[850],
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(6.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.grey[500],
              ),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Center(
                    child: Text(
                      guild?.name ?? 'Loading...',
                      style: GoogleFonts.getFont('Righteous', fontSize: 30),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          const SizedBox(height: 16),
                          Text(
                            'Description',
                            style:
                                GoogleFonts.getFont('Righteous', fontSize: 20),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            guild?.description ?? 'Loading...',
                            style: GoogleFonts.getFont('Ubuntu', fontSize: 16),
                          ),
                        ],
                      ),
                      const Icon(Icons.shield, color: Colors.white)
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Members', //$memberCount
                        style: GoogleFonts.getFont('Kanit', fontSize: 14),
                      ),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).primaryColor),
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return showAlertDialog(context);
                                });
                          },
                          child: Text('Leave'))
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 4),
            Expanded(
              child: guild == null
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      itemCount: guild?.members.length, //memberCount
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                          leading: const CircleAvatar(
                            backgroundColor: Colors.white,
                            child: Icon(Icons.person, color: Colors.black),
                          ),
                          title: Text(
                            'Miembro: ${guild?.members[index]}',
                            style: GoogleFonts.getFont('Ubuntu',
                                fontSize: 14, color: Colors.white),
                          ),
                          tileColor: Theme.of(context).primaryColor,
                        );
                        //shape: RoundedRectangleBorder(
                        //borderRadius: BorderRadius.circular(8),
                        //)
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  void leaveGuild() {
    db
        .collection('guilds')
        .where('name', isEqualTo: guild?.name)
        .get()
        .then((value) => db.collection('guilds').doc(value.docs[0].id).update({
              'members': FieldValue.arrayRemove([user?.email])
            }));
    db
        .collection('users')
        .where('email', isEqualTo: user?.email)
        .get()
        .then((value) {
      if (value.size == 1) {
        // Verifica si solo se encuentra un documento
        db.collection('users').doc(value.docs[0].id).update({'guild': false});
      }
    });

    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const GuildPage()));
  }

  showAlertDialog(BuildContext context) {
    // Configuración del AlertDialog
    return AlertDialog(
      title: const Text("WARNING"),
      content: const Text("Are you sure you want to leave the clan?"),
      actions: [
        // Botón 1
        TextButton(
          child: const Text("YES", style: TextStyle(color: Colors.red)),
          onPressed: () {
            leaveGuild();
          },
        ),
        // Botón 2
        TextButton(
          child: const Text(
            "NO",
            style: TextStyle(color: Colors.red),
          ),
          onPressed: () {
            // Lógica a ejecutar al presionar el Botón 2
            Navigator.of(context).pop(); // Cerrar el AlertDialog
          },
        ),
      ],
    );
  }
}
