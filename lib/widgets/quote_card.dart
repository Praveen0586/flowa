import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class QuoteCard extends StatelessWidget {
  final String quote;
  final String author;
  final bool isLoading;
  final VoidCallback onRefresh;

  const QuoteCard({
    super.key,
    required this.quote,
    required this.author,
    required this.isLoading,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: isLoading
          ? const Center(
              child: SizedBox(
                height: 40,
                child: CircularProgressIndicator(
                  color: Color(0xFF06B6D4),
                  strokeWidth: 2,
                ),
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
                      onTap: onRefresh,
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
                  '"$quote"',
                  style: GoogleFonts.dmSans(
                    fontSize: 13,
                    color: const Color(0xFFF1F0FF),
                    fontStyle: FontStyle.italic,
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '— $author',
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
