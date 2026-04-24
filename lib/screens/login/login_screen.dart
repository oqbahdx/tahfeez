import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFf9f9f8),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth >= 768;
          return Row(
            children: [
              if (isWide) _buildBrandingPanel(),
              Expanded(child: _buildLoginForm(isWide)),
            ],
          );
        },
      ),
    );
  }

  Widget _buildBrandingPanel() {
    return Container(
      width: double.infinity,
      color: const Color(0xFF1b5e60),
      child: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(color: Color(0xFF004647)),
            ),
          ),
          Positioned.fill(
            child: Opacity(
              opacity: 0.4,
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF004647).withValues(alpha: 0.4),
                  backgroundBlendMode: BlendMode.overlay,
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: CustomPaint(painter: _GeometricPatternPainter()),
          ),
          Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.auto_stories,
                        color: Color(0xFF004647),
                        size: 28,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'تحفيظ',
                      style: TextStyle(
                        fontFamily: 'Lexend',
                        fontSize: 57,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                        height: 1,
                      ),
                    ),
                    const Text(
                      'Tahfeez',
                      style: TextStyle(
                        fontFamily: 'Lexend',
                        fontSize: 57,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                        height: 1,
                        letterSpacing: -0.25,
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: 280,
                      child: Text(
                        'Sacred tradition meets modern management. Streamlining Quranic education for institutions.',
                        style: TextStyle(
                          fontFamily: 'Lexend',
                          fontSize: 16,
                          color: const Color(0xFFafeeef).withValues(alpha: 0.7),
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF004647).withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.1),
                    ),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.security, color: Color(0xFFfed977), size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Secure access for administrators, teachers, and staff.',
                        style: TextStyle(
                          fontFamily: 'Lexend',
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFFafeeef),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginForm(bool isWide) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isWide) ...[
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1b5e60),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.auto_stories,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'تحفيظ / Tahfeez',
                  style: TextStyle(
                    fontFamily: 'Lexend',
                    fontSize: 28,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF004647),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
          ],
          const Text(
            'Welcome Back',
            style: TextStyle(
              fontFamily: 'Lexend',
              fontSize: 32,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1a1c1c),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Please sign in to access your institutional dashboard.',
            style: TextStyle(
              fontFamily: 'Lexend',
              fontSize: 14,
              color: const Color(0xFF3f4849),
            ),
          ),
          const SizedBox(height: 24),
          TextField(
            controller: _emailController,
            decoration: InputDecoration(
              labelText: 'Email Address',
              labelStyle: const TextStyle(
                fontFamily: 'Lexend',
                fontSize: 12,
                color: Color(0xFF3f4849),
              ),
              prefixIcon: const Icon(
                Icons.mail_outline,
                color: Color(0xFF6f7979),
              ),
              filled: true,
              fillColor: const Color(0xFFf9f9f8),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFF6f7979)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFF6f7979)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(
                  color: Color(0xFF755b00),
                  width: 2,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _passwordController,
            obscureText: _obscurePassword,
            decoration: InputDecoration(
              labelText: 'Password',
              labelStyle: const TextStyle(
                fontFamily: 'Lexend',
                fontSize: 12,
                color: Color(0xFF3f4849),
              ),
              prefixIcon: const Icon(
                Icons.lock_outline,
                color: Color(0xFF6f7979),
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword ? Icons.visibility_off : Icons.visibility,
                  color: const Color(0xFF6f7979),
                ),
                onPressed: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
              ),
              filled: true,
              fillColor: const Color(0xFFf9f9f8),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFF6f7979)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFF6f7979)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(
                  color: Color(0xFF755b00),
                  width: 2,
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {},
              child: const Text(
                'Forgot Password?',
                style: TextStyle(
                  fontFamily: 'Lexend',
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF004647),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF004647),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(9999),
                ),
                elevation: 1,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    'Sign In',
                    style: TextStyle(
                      fontFamily: 'Lexend',
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(width: 8),
                  Icon(Icons.arrow_forward, size: 18),
                ],
              ),
            ),
          ),
          const SizedBox(height: 32),
          Center(
            child: Text(
              'Need help accessing your account? \nContact Administrator',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Lexend',
                fontSize: 14,
                color: const Color(0xFF3f4849),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GeometricPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.05)
      ..strokeWidth = 1;

    const spacing = 24.0;
    for (var x = 0.0; x < size.width; x += spacing) {
      for (var y = 0.0; y < size.height; y += spacing) {
        canvas.drawCircle(Offset(x, y), 1, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
