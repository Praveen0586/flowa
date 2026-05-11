import 'dart:convert';
import 'package:http/http.dart' as http;

class QuoteService {
  static const String _url = 'https://api.quotable.io/random';

  // Fallback in case API is down
  static const Map<String, String> _fallback = {
    'content': 'The secret of getting ahead is getting started.',
    'author': 'Mark Twain',
  };

  Future<Map<String, String>> fetchQuote() async {
    try {
      // Adding a timestamp to bypass any potential caching
      final response = await http
          .get(Uri.parse('$_url?t=${DateTime.now().millisecondsSinceEpoch}'))
          .timeout(const Duration(seconds: 8));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'content': data['content'] ?? _fallback['content']!,
          'author': data['author'] ?? _fallback['author']!,
        };
      }
      return _fallback;
    } catch (e) {
      return _fallback; // silently fallback
    }
  }
}
