import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/quote_service.dart';

class QuoteCard extends StatefulWidget {
  const QuoteCard({super.key});

  @override
  State<QuoteCard> createState() => _QuoteCardState();
}

class _QuoteCardState extends State<QuoteCard> {
  final QuoteService _quoteService = QuoteService();
  String _quote = 'The secret of getting ahead is getting started.';
  String _author = 'Mark Twain';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadQuote();
  }

  Future<void> _loadQuote() async {
    if (!mounted) return;
    setState(() => _isLoading = true);
    
    final result = await _quoteService.fetchQuote();
    
    if (!mounted) return;
    setState(() {
      _quote = result['content']!;
      _author = result['author']!;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 120),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1e1b38), Color(0xFF1a2640)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFF2a3a55)),
      ),
      padding: const EdgeInsets.all(16),
      child: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF06B6D4),
                strokeWidth: 2,
              ),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '✦ DAILY INSPIRATION',
                      style: GoogleFonts.dmSans(
                        fontSize: 10,
                        color: const Color(0xFF06B6D4),
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1,
                      ),
                    ),
                    GestureDetector(
                      onTap: _loadQuote,
                      child: const Icon(
                        Icons.refresh_rounded,
                        size: 18,
                        color: Color(0xFF06B6D4),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  '"$_quote"',
                  style: GoogleFonts.dmSans(
                    fontSize: 13,
                    color: const Color(0xFFF1F0FF),
                    fontStyle: FontStyle.italic,
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '— $_author',
                  style: GoogleFonts.dmSans(
                    fontSize: 11,
                    color: const Color(0xFF8B87B0),
                  ),
                ),
              ],
            ),
    );
  }
}
