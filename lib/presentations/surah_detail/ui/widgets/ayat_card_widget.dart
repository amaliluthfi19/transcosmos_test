import 'package:flutter/material.dart';
import '../../../../domain/entities/ayat.dart';

class AyatCardWidget extends StatelessWidget {
  final Ayat ayat;
  final bool isLast;

  const AyatCardWidget({super.key, required this.ayat, this.isLast = false});

  String _cleanHtmlText(String htmlText) {
    // Simple HTML tag removal
    return htmlText
        .replaceAll(RegExp(r'<[^>]*>'), '')
        .replaceAll('&nbsp;', ' ')
        .trim();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Ayat Number
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  ayat.nomor.toString(),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Arabic Text
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                ayat.ar,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  height: 2.0,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                textAlign: TextAlign.right,
                textDirection: TextDirection.rtl,
              ),
            ),

            const SizedBox(height: 16),

            // Transliteration
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                _cleanHtmlText(ayat.tr),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Indonesian Translation
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(
                  context,
                ).colorScheme.primaryContainer.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                _cleanHtmlText(ayat.idn),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                  height: 1.5,
                ),
              ),
            ),

            if (!isLast) ...[
              const SizedBox(height: 16),
              Divider(color: Colors.grey[300], height: 1),
            ],
          ],
        ),
      ),
    );
  }
}
