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
  bool isEditingUsername = false;
  bool isEditingTag = false;
  String _imageUrl = '';
  File? _imageUpload;
  //UserData? user;
  User? user = FirebaseAuth.instance.currentUser;
  TextEditingController usernameController = TextEditingController();
  TextEditingController tagController = TextEditingController();
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
            usernameController.text = snapshot.data!.username;
            tagController.text = snapshot.data!.tag;
            return Column(
              children: [
                ListTile(
                    title: textFormWidget(
                        usernameController, 'Username', isEditingUsername),
                    trailing: IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          setState(() {
                            isEditingUsername = true;
                          });
                        })),
                ListTile(
                    title: Text(snapshot.data?.email ?? '',
                        style: const TextStyle(color: Colors.white)),
                    trailing: IconButton(
                        icon: const Icon(Icons.lock),
                        onPressed: () {
                          setState(() {});
                        })),
                ListTile(
                    title: textFormWidget(tagController, 'Tag', isEditingTag),
                    trailing: IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          setState(() {
                            isEditingTag = true;
                          });
                        })),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).primaryColor),
                        onPressed: () {
                          setState(() {
                            isEditingUsername = false;
                            isEditingTag = false;
                          });
                        },
                        child: const Text("Cancel")),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).primaryColor),
                        onPressed: () {
                          editUserProfile(
                              tag: tagController.text,
                              username: usernameController.text);

                          setState(() {
                            isEditingUsername = false;
                            isEditingTag = false;
                          });
                        },
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

  Widget textFormWidget(
      TextEditingController controller, String labelText, bool isEditing) {
    return SizedBox(
      height: 50,
      //width: 200,
      child: TextFormField(
        controller: controller,
        enabled: isEditing,
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: const TextStyle(
              fontSize: 14, color: Colors.red, fontWeight: FontWeight.bold),
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.red), // Cambia el color aquí
          ),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.red), // Cambia el color aquí
          ),
          filled: true,
          fillColor: Colors.red[50],
        ),
      ),
    );
  }
}

Future<UserData> futureUserData = getUserData(user!.email);
