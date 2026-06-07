import 'dart:math' as Math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../theme/tahfeez_theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _logoController;
  late final AnimationController _dotsController;
  late final Animation<double> _logoFade;
  late final Animation<Offset> _logoSlide;

  @override
  void initState() {
    super.initState();
    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _dotsController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();

    _logoFade = CurvedAnimation(
      parent: _logoController,
      curve: Curves.easeOut,
    );
    _logoSlide = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: Curves.easeOutCubic,
    ));

    _logoController.forward();
  }

  @override
  void dispose() {
    _logoController.dispose();
    _dotsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A3A2A),
      body: Stack(
        children: [
          // Geometric ornament background
          Positioned.fill(
            child: CustomPaint(
              painter: _GeometricOrnamentPainter(),
            ),
          ),
          // Main content
          Center(
            child: FadeTransition(
              opacity: _logoFade,
              child: SlideTransition(
                position: _logoSlide,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Logo mark
                    _LogoMark(),
                    const SizedBox(height: 32),
                    // Arabic title
                    Text(
                      'تحفيظ',
                      style: GoogleFonts.amiri(
                        fontSize: 44,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFFE8D5A3),
                        height: 1.0,
                      ),
                      textDirection: TextDirection.rtl,
                    ),
                    const SizedBox(height: 10),
                    // Divider
                    Container(
                      width: 40,
                      height: 1,
                      color: const Color(0xFFD4AF7A).withOpacity(0.4),
                    ),
                    const SizedBox(height: 10),
                    // Latin subtitle
                    Text(
                      'T A H F E E Z',
                      style: GoogleFonts.lexend(
                        fontSize: 11,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFFD4AF7A).withOpacity(0.65),
                        letterSpacing: 4.5,
                      ),
                    ),
                    const SizedBox(height: 52),
                    // Animated dots
                    _PulsingDots(controller: _dotsController),
                  ],
                ),
              ),
            ),
          ),
          // Basmala footer
          Positioned(
            bottom: 52,
            left: 0,
            right: 0,
            child: Text(
              'بِسْمِ ٱللَّٰهِ',
              textAlign: TextAlign.center,
              style: GoogleFonts.amiri(
                fontSize: 13,
                color: const Color(0xFFD4AF7A).withOpacity(0.3),
                letterSpacing: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Logo mark ──────────────────────────────────────────────────────────────

class _LogoMark extends StatelessWidget {
  const _LogoMark();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 88,
      height: 88,
      decoration: BoxDecoration(
        color: const Color(0xFFD4AF7A).withOpacity(0.10),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: const Color(0xFFD4AF7A).withOpacity(0.32),
          width: 1,
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          const Icon(
            Icons.menu_book_rounded,
            color: Color(0xFFD4AF7A),
            size: 40,
          ),
          // Accent dot
          Positioned(
            top: 14,
            right: 14,
            child: Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: const Color(0xFFD4AF7A),
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xFF1A3A2A),
                  width: 2,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Pulsing dots ───────────────────────────────────────────────────────────

class _PulsingDots extends StatelessWidget {
  final AnimationController controller;
  const _PulsingDots({required this.controller});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final t = controller.value;
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (i) {
            final phase = ((t - i * 0.2) % 1.0).clamp(0.0, 1.0);
            final opacity = 0.25 + 0.75 * (1 - (phase < 0.5
                ? 2 * phase
                : 2 * (1 - phase)));
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 4),
              child: Opacity(
                opacity: opacity.clamp(0.25, 1.0),
                child: Container(
                  width: 5,
                  height: 5,
                  decoration: const BoxDecoration(
                    color: Color(0xFFD4AF7A),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }
}

// ── Geometric background painter ───────────────────────────────────────────

class _GeometricOrnamentPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFD4AF7A).withOpacity(0.06)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8;

    final cx = size.width / 2;
    final cy = size.height * 0.38;

    // Concentric octagons
    for (final r in [40.0, 60.0, 80.0, 105.0]) {
      _drawOctagon(canvas, paint, cx, cy, r);
    }

    // Center circle rings
    final ringPaint = Paint()
      ..color = const Color(0xFFD4AF7A).withOpacity(0.08)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.6;
    for (final r in [8.0, 18.0, 28.0]) {
      canvas.drawCircle(Offset(cx, cy), r, ringPaint);
    }

    // Diagonal hair lines
    final linePaint = Paint()
      ..color = const Color(0xFFD4AF7A).withOpacity(0.04)
      ..strokeWidth = 0.5;
    canvas.drawLine(Offset(0, 0), Offset(size.width, size.height), linePaint);
    canvas.drawLine(Offset(size.width, 0), Offset(0, size.height), linePaint);
  }

  void _drawOctagon(
      Canvas canvas, Paint paint, double cx, double cy, double r) {
    final path = Path();
    for (int i = 0; i < 8; i++) {
      final angle = (i * 45 - 22.5) * (3.14159 / 180);
      final x = cx + r * Math.cos(angle);
      final y = cy + r * Math.sin(angle);
      i == 0 ? path.moveTo(x, y) : path.lineTo(x, y);
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_GeometricOrnamentPainter oldDelegate) => false;
}