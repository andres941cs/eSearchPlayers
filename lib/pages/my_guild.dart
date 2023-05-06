import 'package:flutter/material.dart';

class MyGuildPage extends StatefulWidget {
  const MyGuildPage({super.key});

  @override
  State<MyGuildPage> createState() => _MyGuildPageState();
}

class _MyGuildPageState extends State<MyGuildPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 200,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage("null"),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Descripción',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              "description",
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            Text(
              'Members ()', //$memberCount
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: 10, //memberCount
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.grey[400],
                      child: const Icon(Icons.person),
                    ),
                    title: Text('Miembro $index'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
