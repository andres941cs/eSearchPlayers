import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MyFormGuild extends StatefulWidget {
  const MyFormGuild({super.key});

  @override
  State<MyFormGuild> createState() => _MyFormGuildState();
}

class _MyFormGuildState extends State<MyFormGuild> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  //final _ImageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                  labelText: 'Name',
                  labelStyle: TextStyle(color: Colors.grey),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.red))),
              validator: (value) {
                if (value?.isEmpty ?? true) {
                  return 'Please enter some text';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                labelStyle: TextStyle(color: Colors.grey),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.red),
                ),
              ),
              validator: (value) {
                if (value?.isEmpty ?? true) {
                  return 'Please enter some text';
                }
                return null;
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  child: const Text('Cancelar'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  child: const Text('Create'),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _saveGuild();
                      Navigator.of(context).pop();
                    }
                  },
                )
              ],
            )
          ],
        ));
  }

  void _saveGuild() {
    // Accede a la colección 'guilds' en Firebase.
    final guildsCollection = FirebaseFirestore.instance.collection('guilds');
    final user = FirebaseAuth.instance.currentUser;
    // Crea un nuevo documento en la colección y guarda los valores del clan.
    guildsCollection.add({
      'name': _nameController.text,
      'description': _descriptionController.text,
      'members': [user!.email],
    });
  }
}
