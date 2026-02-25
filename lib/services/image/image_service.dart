import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:http/http.dart' as http;

/// Wraps ImgBB image upload API.
/// Replace [_apiKey] with your real key before shipping to production.
class ImageService {
  static const String _apiKey = 'YOUR_IMGBB_API_KEY';

  Future<String> uploadFile(File file) async {
    final bytes = await file.readAsBytes();
    return _upload(bytes, file.path.split('/').last);
  }

  Future<String> uploadBytes(Uint8List bytes, String filename) async {
    return _upload(bytes, filename);
  }

  Future<String> _upload(Uint8List bytes, String name) async {
    final uri = Uri.parse('https://api.imgbb.com/1/upload?key=$_apiKey');
    final response = await http.post(
      uri,
      body: {'image': base64Encode(bytes), 'name': name},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body) as Map<String, dynamic>;
      if (data['success'] == true) {
        return data['data']['url'] as String;
      }
      throw Exception('Upload failed: ${data['error']['message']}');
    }
    throw Exception('Upload failed with status ${response.statusCode}');
  }
}
