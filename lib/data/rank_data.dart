import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future setRankApp(int newRank) async {
  User? user = FirebaseAuth.instance.currentUser;
  final querySnapshot =
      await FirebaseFirestore.instance.collection('users').doc(user!.uid).get();

  querySnapshot.reference.update({
    'RankApp': newRank,
  }).then((value) {
    print('Datos actualizados correctamente.');
  }).catchError((error) {
    print('Error al actualizar los datos: $error');
  });
}

Future<int> getRankNumber() async {
  User? user = FirebaseAuth.instance.currentUser;
  final querySnapshot =
      await FirebaseFirestore.instance.collection('users').doc(user!.uid).get();
  String nombreRango = querySnapshot['rank'];

  //Usar la collecion de los rangos
  final snapshot = await FirebaseFirestore.instance
      .collection('ranksValorant')
      .where('name', isEqualTo: nombreRango)
      .get();
  int rankNumber = snapshot.docs.first['id'];
  return rankNumber;
}
