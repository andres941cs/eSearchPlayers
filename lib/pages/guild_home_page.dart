import 'package:esearchplayers/data/user_data.dart';
import 'package:esearchplayers/pages/guild_page.dart';
import 'package:esearchplayers/pages/my_guild.dart';
import 'package:esearchplayers/pages/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GuildHomePage extends StatefulWidget {
  const GuildHomePage({super.key});

  @override
  State<GuildHomePage> createState() => _GuildHomePageState();
}

class _GuildHomePageState extends State<GuildHomePage> {
  bool? isGuild;
  @override
  void initState() {
    super.initState();
    getUserProfile();
  }

  @override
  Widget build(BuildContext context) {
    if (isGuild == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else if (isGuild!) {
      return const MyGuildPage();
    } else {
      return const GuildPage();
    }
  }

  void getUserProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    FirebaseFirestore db = FirebaseFirestore.instance;
    if (user != null) {
      final querySnapshot = await db
          .collection('users')
          .where("email", isEqualTo: user.email)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        final doc = querySnapshot.docs[0];
        final data = doc.data();
        // Usa los datos como desees
        setState(() {
          isGuild = data['guild'];
        });
      }
    }
  }
}
