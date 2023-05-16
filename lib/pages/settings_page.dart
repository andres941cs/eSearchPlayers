import 'package:esearchplayers/components/my_drawer.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text("Settings"),
            backgroundColor: Theme.of(context).primaryColor),
        drawer: const MyDrawer(),
        backgroundColor: Color.fromRGBO(52, 53, 65, 1),
        body: Column(
          children: [
            ListTile(
                leading: const Icon(
                  Icons.language,
                  color: Colors.white,
                ),
                title: Text('Language',
                    style: TextStyle(
                      color: Colors.white,
                    )),
                onTap: () {
                  print('object');
                }),
            ListTile(
                leading: const Icon(
                  Icons.sunny,
                  color: Colors.white,
                ),
                title: Text('Theme',
                    style: TextStyle(
                      color: Colors.white,
                    )),
                onTap: () {
                  print('object');
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
                print('object');
              },
            )
          ],
        ));
  }
}
