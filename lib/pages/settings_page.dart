import 'package:esearchplayers/components/my_drawer.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

List<String> languages = ['es', 'en'];

bool _isDarkMode = false;

class _SettingsPageState extends State<SettingsPage> {
  String selectedLanguage = languages[0];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text("Settings"),
            backgroundColor: Theme.of(context).primaryColor),
        drawer: const MyDrawer(),
        backgroundColor: const Color.fromRGBO(52, 53, 65, 1),
        body: Column(
          children: [
            ListTile(
                leading: const Icon(
                  Icons.language,
                  color: Colors.white,
                ),
                title: const Text('Language',
                    style: TextStyle(
                      color: Colors.white,
                    )),
                onTap: () {
                  showDialog(
                      context: context, builder: (context) => dialogLanguage());
                }),
            ListTile(
                leading: const Icon(
                  Icons.sunny,
                  color: Colors.white,
                ),
                title: const Text('Theme',
                    style: TextStyle(
                      color: Colors.white,
                    )),
                onTap: () {
                  showDialog(
                      context: context, builder: (context) => dialogTheme());
                }),
            ListTile(
              leading: const Icon(
                Icons.info,
                color: Colors.white,
              ),
              title: const Text('About us',
                  style: TextStyle(
                    color: Colors.white,
                  )),
              onTap: () {
                showDialog(context: context, builder: (context) => aboutUs());
              },
            )
          ],
        ));
  }

  Widget aboutUs() {
    return const AlertDialog(
      title: Text('About us'),
      content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [Text('Version: 1.0'), Text('Author: Jose Andres')]),
    );
  }

  Widget dialogLanguage() {
    return AlertDialog(
      title: const Text('Language'),
      content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              title: const Text('Español'),
              leading: Radio(
                value: languages[0],
                groupValue: selectedLanguage,
                onChanged: (value) {
                  setState(() {
                    selectedLanguage = value.toString();
                  });
                },
              ),
            ),
            ListTile(
              title: const Text('English'),
              leading: Radio(
                value: languages[1],
                groupValue: selectedLanguage,
                onChanged: (value) {
                  setState(() {
                    selectedLanguage = value.toString();
                  });
                },
              ),
            )
          ]),
    );
  }

  Widget dialogTheme() {
    return AlertDialog(
      title: const Text('Theme'),
      content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Choose a theme:'),
            Switch(
              // This bool value toggles the switch.
              value: _isDarkMode,
              activeColor: Colors.red,
              onChanged: (bool value) {
                // This is called when the user toggles the switch.
                setState(() {
                  _isDarkMode = value;
                });
              },
            )
          ]),
    );
  }
}
