import 'package:image_picker/image_picker.dart';

final ImagePicker picker = ImagePicker();

Future<XFile?> pickImage() async {
  final XFile? image = await picker.pickImage(source: ImageSource.gallery);
  return image;
}
