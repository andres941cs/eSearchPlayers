import 'dart:convert';
import 'package:http/http.dart' as http;

class Character {
  final String name;
  final String role;
  final String image;
  final String pickRate;
  final String winRate;
  Character(
      {required this.name,
      required this.role,
      required this.image,
      required this.pickRate,
      required this.winRate});

  factory Character.fromJson(Map<String, dynamic> json) {
    return Character(
        name: json['name'],
        role: json['role'],
        image: json['image'],
        pickRate: json['pickRate'],
        winRate: json['WinRate']);
  }
}

Future<List<Character>?> getCharactersList() async {
  var url = Uri.parse(
      'https://esearchplayer-api.onrender.com'); //http://192.168.1.135:3000/
  var response = await http.get(url);
  if (response.statusCode == 200) {
    final jsonResponse = jsonDecode(response.body);
    //String name = jsonResponse['name'];
    //String role = jsonResponse['role'];
    List<Character> characters =
        List<Character>.from(jsonResponse.map((x) => Character.fromJson(x)));
    return characters;
  } else {
    return null;
  }
}
