import 'package:esearchplayers/components/my_alert_dialog.dart';
import 'package:esearchplayers/components/my_form_guild.dart';
import 'package:esearchplayers/pages/my_guild.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';

class GuildPage extends StatefulWidget {
  const GuildPage({super.key});

  @override
  State<GuildPage> createState() => _GuildPageState();
}

class _GuildPageState extends State<GuildPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text("Guild"),
          backgroundColor: Theme.of(context).primaryColor),
      backgroundColor: Color.fromRGBO(52, 53, 65, 1),
      body: Column(children: [
        Expanded(
            flex: 2,
            child: Center(
                child: Text(
              "List Of Guilds",
              style: GoogleFonts.getFont('Righteous',
                  fontSize: 30, color: Colors.white),
            ))),
        Expanded(
            flex: 8,
            child: Container(
              color: Colors.red,
              padding: const EdgeInsets.all(10),
              child: listGuilds(),
            )),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor),
                onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const MyGuildPage(),
                    )),
                child: const Text("Search")),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return const AlertDialog(
                        title: Text('Create Guild'),
                        content: MyFormGuild(),
                      );
                    });
              },
              child: const Text("Create Guild"),
            )
          ],
        )
      ]),
    );
  }

  Widget listGuilds() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('guilds').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return ListView(
          children: snapshot.data!.docs.map((document) {
            return Container(
              margin: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: Colors.red[100],
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: ListTile(
                title: Text(document['name']),
                subtitle: Text(document['description']),
                trailing: Text('${document['members'].length} /30'),
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (_) => MyAlertDialog(
                            guildName: document['name'],
                          ));
                  //document['name']
                },
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
