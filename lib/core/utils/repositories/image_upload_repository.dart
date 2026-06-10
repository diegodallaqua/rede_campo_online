import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';

import '../../global/constants/api_constants.dart';
import '../models/image_upload_response.dart';
import 'token_repository.dart';

class ImageUploadRepository {
  Future<ImageUploadResponse> uploadImage({
    required XFile file,
    required String entityType,
    required int entityId,
  }) async {
    try {
      final token = await TokenRepository().getToken();
      final url = Uri.parse('$baseURL$imagesUploadURL');
      final bytes = await file.readAsBytes();

      final request = http.MultipartRequest('POST', url)
        ..headers['Authorization'] = 'Bearer $token'
        ..fields['entityType'] = entityType
        ..fields['entityId'] = entityId.toString()
        ..files.add(http.MultipartFile.fromBytes(
          'file',
          bytes,
          filename: file.name,
          contentType: MediaType.parse(_mimeType(file.name)),
        ));

      final streamed = await request.send();
      final response = await http.Response.fromStream(streamed);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return ImageUploadResponse.fromMap(
            jsonDecode(response.body) as Map<String, dynamic>);
      }
      return Future.error(
          'Erro ao fazer upload da imagem (${response.statusCode}): ${response.body}');
    } catch (e, s) {
      log('ImageUploadRepository: erro no upload',
          error: e.toString(), stackTrace: s);
      return Future.error('Erro ao fazer upload da imagem: $e');
    }
  }

  String _mimeType(String fileName) {
    final ext = fileName.split('.').last.toLowerCase();
    switch (ext) {
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'png':
        return 'image/png';
      case 'webp':
        return 'image/webp';
      default:
        return 'image/jpeg';
    }
  }
}
