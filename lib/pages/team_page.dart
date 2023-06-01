import 'package:esearchplayers/components/my_drawer.dart';
import 'package:esearchplayers/components/my_player_list.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TeamPage extends StatefulWidget {
  const TeamPage({super.key});

  @override
  State<TeamPage> createState() => _TeamPageState();
}

class _TeamPageState extends State<TeamPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text("Team"),
            backgroundColor: Theme.of(context).primaryColor),
        drawer: const MyDrawer(),
        backgroundColor: const Color.fromRGBO(52, 53, 65, 1),
        body: Column(
          children: [
            Expanded(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    "Team Page",
                    style: GoogleFonts.getFont('Righteous',
                        textStyle: const TextStyle(fontSize: 30),
                        color: Colors.white),
                  ),
                  Text(
                    "On this page, you can search for companions to play games, but remember that you must respect the rules of behavior",
                    style:
                        GoogleFonts.getFont('Righteous', color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 3,
              child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const MyPlayerList()),
            ),
          ],
        ));
  }
}
