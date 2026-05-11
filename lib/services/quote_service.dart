import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class QuoteService {
  static const String _url = 'https://zenquotes.io/api/random';

  // Fallback in case API is down
  static const Map<String, String> _fallback = {
    'content': 'The secret of getting ahead is getting started.',
    'author': 'Mark Twain',
  };

  Future<Map<String, String>> fetchQuote() async {
    try {
      final response = await http
          .get(Uri.parse(_url))
          .timeout(const Duration(seconds: 10));
      
      debugPrint('Quote API Status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);
        if (data.isNotEmpty) {
          final quoteData = data[0];
          return {
            'content': quoteData['q'] ?? _fallback['content']!,
            'author': quoteData['a'] ?? _fallback['author']!,
          };
        }
      }
      return _fallback;
    } catch (e) {
      debugPrint('Quote API Exception: $e');
      return _fallback;
    }
  }
}
