import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class ImageService {
  static final _picker = ImagePicker();

  // Pilih gambar dari gallery dan simpan ke folder app docs
  static Future<String?> pickAndSaveImage() async {
    try {
      final XFile? picked = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1200,
      );
      if (picked == null) return null;

      final dir = await getApplicationDocumentsDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final ext = picked.name.contains('.')
          ? picked.name.substring(picked.name.lastIndexOf('.'))
          : '.jpg';
      final fileName = 'img_$timestamp$ext';

      final saved = await File(picked.path).copy('${dir.path}/$fileName');
      return saved.path;
    } catch (e) {
      return null;
    }
  }
}
