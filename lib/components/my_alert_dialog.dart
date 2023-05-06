import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyAlertDialog extends StatelessWidget {
  String? guildName;
  final user = FirebaseAuth.instance.currentUser;
  MyAlertDialog({super.key, this.guildName});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(guildName!),
      content: const Text(
          'Are you sure you want to join?'), //Estas seguro de que quieres unirte?
      actions: [
        CupertinoDialogAction(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel')),
        CupertinoDialogAction(
            onPressed: () {
              _addUserToClan(guildName!);
              Navigator.of(context).pop();
            },
            child: const Text('Join'))
      ],
    );
  }

  void _addUserToClan(String clanId) async {
    final userId = user!.email;
    final querySnapshot = await FirebaseFirestore.instance
        .collection('guilds')
        .where('name', isEqualTo: clanId)
        .get();
    final guildRef = querySnapshot.docs.first.reference;
    //final guildData = querySnapshot.docs.first.data();
    await guildRef.update({
      'members': FieldValue.arrayUnion([userId])
    });
    //Peniente cambiar el booleano de guilds a true
  }
}
