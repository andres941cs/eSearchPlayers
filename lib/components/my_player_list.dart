import 'package:esearchplayers/data/user_data.dart';
import 'package:flutter/material.dart';

class MyPlayerList extends StatefulWidget {
  const MyPlayerList({super.key});

  @override
  State<MyPlayerList> createState() => _MyPlayerListState();
}

class _MyPlayerListState extends State<MyPlayerList> {
  String _name = 'Loading...';
  String _tag = 'Loading...';
  Widget _icon = const Icon(Icons.more_vert);
  String _nameButton = 'Search';
  bool _searching = false;
  void _loadData() async {
    // Aquí puede agregar código para cargar los datos del equipo.
    // En este ejemplo, simplemente simularemos una carga de datos de 2 segundos
    if (_nameButton == 'Search') {
      _nameButton = 'Cancel';
      _searching = true;
      updateSearching("user@gmail.com", _searching);
    } else {
      _nameButton = 'Search';
      _searching = false;
      updateSearching("user@gmail.com", _searching);
    }

    await Future.delayed(const Duration(seconds: 10));

    setState(() {
      _name = 'My Team';
      _tag = '#1234';
      _icon = const Icon(Icons.check);
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Card(
          color: Colors.red,
          child: ListTile(
              leading: const Icon(Icons.person, size: 50.0),
              title: Text('Name: $_name'),
              subtitle: Text('Tag: $_tag'),
              trailing: _icon)),
      Card(
          color: Colors.red,
          child: ListTile(
              leading: const Icon(Icons.person, size: 50.0),
              title: Text('Name: $_name'),
              subtitle: Text('Tag: $_tag'),
              trailing: _icon)),
      Card(
          color: Colors.red,
          child: ListTile(
              leading: const Icon(Icons.person, size: 50.0),
              title: Text('Name: $_name'),
              subtitle: Text('Tag: $_tag'),
              trailing: _icon)),
      Card(
          color: Colors.red,
          child: ListTile(
              leading: const Icon(Icons.person, size: 50.0),
              title: Text('Name: $_name'),
              subtitle: Text('Tag: $_tag'),
              trailing: _icon)),
      Card(
          color: Colors.red,
          child: ListTile(
              leading: const Icon(Icons.person, size: 50.0),
              title: Text('Name: $_name'),
              subtitle: Text('Tag: $_tag'),
              trailing: _icon)),
      ElevatedButton(
          onPressed: () {
            setState(() {
              _icon = const CircularProgressIndicator();
            });
            _loadData();
          },
          child: Text(_nameButton))
    ]);
  }
}
