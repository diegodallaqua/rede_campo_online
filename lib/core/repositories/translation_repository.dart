import 'dart:convert';

import 'package:http/http.dart' as http;

abstract class TranslationRepository {
  static Future<String?> translateToEnglish(String text) async {
    if (text.isEmpty) return null;

    try {
      final uri = Uri.parse(
        'https://translate.googleapis.com/translate_a/single'
        '?client=gtx&sl=pt&tl=en&dt=t&q=${Uri.encodeComponent(text)}',
      );
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final List<dynamic> body = json.decode(response.body) as List<dynamic>;
        final List<dynamic> segments = body[0] as List<dynamic>;
        final translated = segments
            .map((s) => ((s as List<dynamic>)[0] as String?) ?? '')
            .join();
        return translated.isNotEmpty ? translated : null;
      }
    } catch (_) {
      // Silently omit the translation if the request fails
    }

    return null;
  }
}
