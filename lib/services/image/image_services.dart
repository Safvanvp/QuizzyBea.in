import 'dart:convert';
import 'dart:io' show File;
import 'dart:typed_data';

import 'package:http/http.dart' as http;

class ImgbbService {
  final String _apiKey = 'YOUR_IMGBB_API_KEY';

  // Upload image on mobile (File)
  Future<String> uploadImage(File imageFile) async {
    final bytes = await imageFile.readAsBytes();
    return _uploadBase64Image(bytes, imageFile.path.split('/').last);
  }

  // Upload image on web (bytes + filename)
  Future<String> uploadImageWeb(Uint8List bytes, String filename) async {
    return _uploadBase64Image(bytes, filename);
  }

  // Shared internal method for upload
  Future<String> _uploadBase64Image(Uint8List bytes, String filename) async {
    final base64Image = base64Encode(bytes);

    final uri = Uri.parse('https://api.imgbb.com/1/upload?key=$_apiKey');

    final response = await http.post(uri, body: {
      'image': base64Image,
      'name': filename,
    });

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['success'] == true) {
        return data['data']['url'] as String;
      } else {
        throw Exception('Image upload failed: ${data['error']['message']}');
      }
    } else {
      throw Exception('Failed to upload image. Status code: ${response.statusCode}');
    }
  }
}
