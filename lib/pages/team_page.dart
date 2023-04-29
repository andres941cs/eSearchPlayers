import 'package:esearchplayers/components/my_drawer.dart';
import 'package:esearchplayers/components/my_player_list.dart';
import 'package:flutter/material.dart';

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
        body: Column(
          children: [
            const Expanded(
              flex: 1,
              child: Text("Team Page"),
            ),
            Expanded(
              flex: 3,
              child: Container(color: Colors.blue, child: const MyPlayerList()),
            ),
          ],
        ));
  }
}
