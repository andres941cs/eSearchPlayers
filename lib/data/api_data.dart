import 'package:http/http.dart' as http;

Future<String> getUrlImage() async {
  var url = Uri.https('example.com');
  var response = await http.get(url);
  if (response.statusCode == 200) {
    return response.body;
  } else {
    return 'Error';
  }
}



//print(await http.read(Uri.https('example.com', 'foobar.txt')));