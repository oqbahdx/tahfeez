import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../theme/tahfeez_theme.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TahfeezColors.primary,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: TahfeezColors.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.auto_stories,
                color: TahfeezColors.primary,
                size: 44,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'تحفيظ\nTahfeez',
              style: GoogleFonts.lexend(
                fontSize: 40,
                fontWeight: FontWeight.w600,
                color: TahfeezColors.onPrimary,
                height: 1.2,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 48),
            const SizedBox(
              width: 28,
              height: 28,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                valueColor: AlwaysStoppedAnimation<Color>(
                  TahfeezColors.primaryFixedDim,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
