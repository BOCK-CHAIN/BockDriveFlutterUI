import 'dart:ui';
import 'package:flutter/material.dart';

class HeroPage extends StatefulWidget {
  const HeroPage({super.key});

  @override
  State<HeroPage> createState() => _HeroPageState();
}

class _HeroPageState extends State<HeroPage> {
  bool isDarkMode = true;
  bool isHovered = false;

  void toggleDarkMode() {
    setState(() {
      isDarkMode = !isDarkMode;
    });
  }

  void handleTryFree() {
    print('Navigate to signup');
  }

  void handleSignIn() {
    print('Navigate to login');
  }

  @override
  Widget build(BuildContext context) {
    final theme = isDarkMode ? ThemeData.dark() : ThemeData.light();
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 768;

    return Theme(
      data: theme,
      child: Scaffold(
        backgroundColor: isDarkMode ? const Color(0xFF111827) : Colors.white,
        body: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: SingleChildScrollView(
                child: _buildHeroContent(isSmallScreen),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      decoration: BoxDecoration(
        color: isDarkMode
            ? const Color(0xFF111827).withOpacity(0.8)
            : Colors.white.withOpacity(0.8),
        border: Border(
          bottom: BorderSide(
            color: isDarkMode
                ? const Color(0xFF374151)
                : const Color(0xFFF3F4F6),
            width: 1,
          ),
        ),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.cloud_upload,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Bock Drive',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode
                          ? const Color(0xFF60A5FA)
                          : const Color(0xFF2563EB),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: toggleDarkMode,
                    icon: Icon(
                      isDarkMode ? Icons.wb_sunny : Icons.nightlight_round,
                      color: isDarkMode
                          ? const Color(0xFFFBBF24)
                          : const Color(0xFF374151),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: handleSignIn,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isDarkMode
                          ? const Color(0xFF3B82F6)
                          : const Color(0xFF2563EB),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    child: const Text(
                      'Sign In',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeroContent(bool isSmallScreen) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 1200),
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: EdgeInsets.only(
        top: isSmallScreen ? 32 : 64,
        bottom: isSmallScreen ? 32 : 80,
      ),
      child: isSmallScreen
          ? Column(
              children: [
                _buildLeftColumn(),
                const SizedBox(height: 64),
                _buildRightColumn(),
              ],
            )
          : Row(
              children: [
                Expanded(child: _buildLeftColumn()),
                const SizedBox(width: 64),
                Expanded(child: _buildRightColumn()),
              ],
            ),
    );
  }

  Widget _buildLeftColumn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.width < 768 ? 40 : 64,
              fontWeight: FontWeight.bold,
              height: 1.1,
              color: isDarkMode
                  ? Colors.white
                  : const Color(0xFF1E1919),
            ),
            children: [
              const TextSpan(text: 'Welcome to '),
              TextSpan(
                text: 'Bock Drive',
                style: TextStyle(
                  background: Paint()
                    ..shader = const LinearGradient(
                      colors: [Color(0xFF2563EB), Color(0xFF7C3AED)],
                    ).createShader(const Rect.fromLTWH(0, 0, 200, 70)),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Secure and accessible storage, anytime, anywhere. Experience seamless file management designed for modern work.',
          style: TextStyle(
            fontSize: 20,
            color: isDarkMode
                ? const Color(0xFFD1D5DB)
                : const Color(0xFF6B7280),
            height: 1.5,
          ),
        ),
        const SizedBox(height: 32),
        _buildFeaturesGrid(),
        const SizedBox(height: 32),
        _buildCTAButton(),
      ],
    );
  }

  Widget _buildFeaturesGrid() {
    final features = [
      {'icon': Icons.cloud_upload, 'text': 'Easy Upload', 'color': Colors.blue},
      {'icon': Icons.lock, 'text': 'Secure Storage', 'color': Colors.green},
      {'icon': Icons.share, 'text': 'Simple Sharing', 'color': Colors.purple},
      {'icon': Icons.storage, 'text': 'Unlimited Space', 'color': Colors.red},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: MediaQuery.of(context).size.width < 640 ? 1 : 2,
        childAspectRatio: 4,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: features.length,
      itemBuilder: (context, index) {
        final feature = features[index];
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDarkMode
                ? const Color(0xFF1F2937)
                : const Color(0xFFF9FAFB),
            border: Border.all(
              color: isDarkMode
                  ? const Color(0xFF374151)
                  : const Color(0xFFF3F4F6),
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(
                feature['icon'] as IconData,
                color: feature['color'] as Color,
                size: 20,
              ),
              const SizedBox(width: 12),
              Text(
                feature['text'] as String,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: isDarkMode
                      ? const Color(0xFFE5E7EB)
                      : const Color(0xFF374151),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCTAButton() {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        transform: Matrix4.identity()
          ..translate(0.0, isHovered ? -2.0 : 0.0),
        child: ElevatedButton(
          onPressed: handleTryFree,
          style: ElevatedButton.styleFrom(
            backgroundColor: isDarkMode
                ? const Color(0xFF3B82F6)
                : const Color(0xFF2563EB),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(
              horizontal: 32,
              vertical: 16,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(32),
            ),
            elevation: isHovered ? 12 : 4,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Text(
                'Try it for free',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
              SizedBox(width: 8),
              Icon(Icons.arrow_forward, size: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRightColumn() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDarkMode
              ? [
                  const Color(0xFF1E3A8A).withOpacity(0.2),
                  const Color(0xFF581C87).withOpacity(0.2),
                ]
              : [
                  const Color(0xFFDBEAFE),
                  const Color(0xFFF3E8FF),
                ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDarkMode
              ? const Color(0xFF374151)
              : const Color(0xFFE5E7EB),
        ),
      ),
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: Center(
          child: Container(
            width: 128,
            height: 128,
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.cloud_upload,
              color: Colors.white,
              size: 64,
            ),
          ),
        ),
      ),
    );
  }
}