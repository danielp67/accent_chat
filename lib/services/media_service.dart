import 'dart:io';

import 'package:image_picker/image_picker.dart';

class MediaService {
  static MediaService instance = MediaService();

  Future<File?> getImageFromLibrary() async {
    XFile? xFile = await ImagePicker().pickImage(source: ImageSource.gallery);
  if (xFile != null) {
    // Create a new File object using the path from the XFile
    File file = File(xFile.path);
    return file;
  }
  return null; // Return null if no image is selected
}
  
}