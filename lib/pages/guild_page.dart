import 'package:flutter/material.dart';

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
      body: const Center(
        child: Text("Guild Page"),
      ),
    );
  }
}
