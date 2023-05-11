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
      body: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.grey[800],
              ),
              child: Column(
                children: [
                  const SizedBox(height: 100),
                  Center(
                    child: Text(
                      guild?.name ?? 'Loading...',
                      style: GoogleFonts.getFont('Righteous'),
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
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red),
                          onPressed: () => leaveGuild(),
                          child: Text('Leave'))
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: guild == null
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      itemCount: guild?.members.length, //memberCount
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.white,
                              child:
                                  const Icon(Icons.person, color: Colors.black),
                            ),
                            title: Text('Miembro ${guild?.members[index]}'),
                            tileColor: Colors.grey[400],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ));
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
}
