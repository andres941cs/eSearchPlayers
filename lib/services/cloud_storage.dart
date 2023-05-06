import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final FirebaseStorage storage = FirebaseStorage.instance;
final FirebaseFirestore db = FirebaseFirestore.instance;
final user = FirebaseAuth.instance.currentUser;
Future<void> uploadImage(File imageFile) async {
  final String namemfile = imageFile.path.split("/").last;
  final Reference storageRef =
      storage.ref().child('user_profile_images').child(namemfile);
  final UploadTask uploadTask = storageRef.putFile(imageFile);
  final TaskSnapshot downloadUrl = await uploadTask.whenComplete(() => null);
  final String url = await downloadUrl.ref.getDownloadURL();
  //final userRef = db.collection('users').doc(user!.uid);
  //await userRef.update({'profileImageUrl': url});
  final userRef = await db
      .collection('users')
      .where('email', isEqualTo: user!.email)
      .get()
      .then((querySnapshot) {
    return querySnapshot.docs.first.reference;
  });
  await userRef.update({'profileImageUrl': url});
}
// setState(() {
//     _imageUrl = url;
//   });