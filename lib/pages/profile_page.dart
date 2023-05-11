import 'dart:io';

import 'package:esearchplayers/data/user_data.dart';
import 'package:esearchplayers/services/cloud_storage.dart';
import 'package:esearchplayers/services/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool isEditing = false;
  String _imageUrl = '';
  File? _imageUpload;
  UserData? user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Profile"),
          backgroundColor: Theme.of(context).primaryColor,
        ),
        backgroundColor: const Color.fromRGBO(52, 53, 65, 1),
        body: Column(
          children: [
            Expanded(
                flex: 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FutureBuilder(
                      future: futureUserData,
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (snapshot.hasData) {
                          _imageUrl = snapshot.data.profileImageUrl;
                        }
                        return CircleAvatar(
                          radius: 60,
                          backgroundImage: _imageUrl.isNotEmpty
                              ? NetworkImage(_imageUrl)
                              : null,
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor,
                          foregroundColor: Colors.white),
                      onPressed: () async {
                        // obtén el usuario actual
                        final imageFile = await pickImage();
                        if (imageFile == null) return;
                        _imageUpload = File(imageFile.path);
                        await uploadImage(_imageUpload!);
                        setState(() {
                          _imageUrl = imageFile.path;
                        });
                      },
                      child: const Text('Pick Image'),
                    ),
                  ],
                )),
            Expanded(
              flex: 3,
              child: Container(
                child: columnWidget(),
              ),
            )
          ],
        ));
  }

  Widget columnWidget() {
    return FutureBuilder(
        future: futureUserData,
        builder: (BuildContext context, AsyncSnapshot<UserData> snapshot) {
          if (snapshot.hasData) {
            return Column(
              children: [
                ListTile(
                    title: textFormWidget('Username', snapshot.data?.username),
                    trailing: IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          setState(() {
                            isEditing = true;
                          });
                        })),
                ListTile(
                    title: textFormWidget('Email', snapshot.data?.email),
                    trailing: IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          setState(() {
                            isEditing = true;
                          });
                        })),
                ListTile(
                    title: textFormWidget('Tag', snapshot.data?.tag),
                    trailing: IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          setState(() {
                            isEditing = true;
                          });
                        })),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).primaryColor),
                        onPressed: () => print("CANCEL"),
                        child: const Text("Cancel")),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).primaryColor),
                        onPressed: () => print("CANCEL"),
                        child: const Text("Save")),
                  ],
                )
              ],
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }

  Widget textFormWidget(String labelText, String? snapData) {
    return SizedBox(
      height: 50,
      //width: 200,
      child: TextFormField(
        initialValue: snapData, //snapshot.data?.username
        enabled: isEditing,
        decoration: InputDecoration(
          labelText: labelText,
          border: const OutlineInputBorder(),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
    );
  }
}

String userEmail() {
  FirebaseAuth auth = FirebaseAuth.instance;
  User? user = auth.currentUser;
  if (user != null) {
    // Aquí puede obtener los datos del usuario, como su nombre, correo electrónico, etc.
    String email = user.email ?? '';
    return email;
  }
  return "";
}

UserData? user;
//Cuando obtenga los datos del usuario, puede usarlos en cualquier lugar de su aplicación.
Future<UserData> futureUserData =
    getUserData(userEmail()).then((value) => user = value);
