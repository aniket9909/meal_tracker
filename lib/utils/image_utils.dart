import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class ImageUtils {
  static Future<String> saveImageToLocalDir(File imageFile) async {
    final dir = await getApplicationDocumentsDirectory();
    final fileName = 'meal_${DateTime.now().millisecondsSinceEpoch}${p.extension(imageFile.path)}';
    final savedImage = await imageFile.copy('${dir.path}/$fileName');
    return savedImage.path;
  }
}