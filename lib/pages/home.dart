import 'dart:math';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:portfolio/utils/responsive.dart';
import 'package:portfolio/utils/app_colors.dart';
import 'package:portfolio/widgets/glass_card.dart';
import 'package:portfolio/widgets/custom_button.dart';
import 'package:gap/gap.dart';
import 'package:url_launcher/url_launcher.dart';

class Home extends StatefulWidget {
  final VoidCallback? onContactPressed;

  const Home({super.key, this.onContactPressed});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  late AnimationController _textAnimationController;
  late AnimationController _imageAnimationController;
  late Animation<double> _textFadeAnimation;
  late Animation<Offset> _textSlideAnimation;
  late Animation<double> _imageScaleAnimation;
  late Animation<double> _imageRotateAnimation;

  @override
  void initState() {
    super.initState();

    _textAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _imageAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _textFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _textAnimationController,
      curve: const Interval(0.0, 0.8, curve: Curves.easeOut),
    ));

    _textSlideAnimation = Tween<Offset>(
      begin: const Offset(-0.5, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _textAnimationController,
      curve: const Interval(0.2, 1.0, curve: Curves.easeOutCubic),
    ));

    _imageScaleAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _imageAnimationController,
      curve: Curves.elasticOut,
    ));

    _imageRotateAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _imageAnimationController,
      curve: Curves.easeInOut,
    ));

    // Start animations
    _textAnimationController.forward();
    Future.delayed(const Duration(milliseconds: 300), () {
      _imageAnimationController.forward();
    });
  }

  @override
  void dispose() {
    _textAnimationController.dispose();
    _imageAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Responsive.responsiveWidget(
      context: context,
      mobile: _buildMobileLayout(),
      tablet: _buildTabletLayout(),
      desktop: _buildDesktopLayout(),
    );
  }

  Widget _buildDesktopLayout() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Row(
        children: [
          // Left side - Text content
          Expanded(
            flex: 6,
            child: _buildTextContent(
              fontSize: 64,
              subtitleSize: 24,
              descriptionSize: 18,
            ),
          ),

          const Gap(60),

          // Right side - Image and profile
          Expanded(
            flex: 4,
            child: _buildImageSection(300),
          ),
        ],
      ),
    );
  }

  Widget _buildTabletLayout() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: _buildTextContent(
              fontSize: 48,
              subtitleSize: 20,
              descriptionSize: 16,
            ),
          ),
          const Gap(40),
          Expanded(
            flex: 2,
            child: _buildImageSection(250),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileLayout() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Profile image first on mobile
          _buildImageSection(200),

          const Gap(40),

          // Text content
          _buildTextContent(
            fontSize: 32,
            subtitleSize: 18,
            descriptionSize: 14,
            isMobile: true,
          ),
        ],
      ),
    );
  }

  Widget _buildTextContent({
    required double fontSize,
    required double subtitleSize,
    required double descriptionSize,
    bool isMobile = false,
  }) {
    return AnimatedBuilder(
      animation: _textAnimationController,
      builder: (context, child) {
        return FadeTransition(
          opacity: _textFadeAnimation,
          child: SlideTransition(
            position: _textSlideAnimation,
            child: Column(
              crossAxisAlignment: isMobile
                  ? CrossAxisAlignment.center
                  : CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Greeting with wave animation
                Row(
                  mainAxisAlignment: isMobile
                      ? MainAxisAlignment.center
                      : MainAxisAlignment.start,
                  children: [
                    Text(
                      'Hello',
                      style: TextStyle(
                        fontSize: fontSize,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    Lottie.asset(
                      'assets/wave.json',
                      width: fontSize * 0.8,
                      height: fontSize * 0.8,
                      repeat: true,
                    ),
                  ],
                ),

                // Name with gradient
                Row(
                  mainAxisAlignment: isMobile
                      ? MainAxisAlignment.center
                      : MainAxisAlignment.start,
                  children: [
                    Text(
                      "I'm ",
                      style: TextStyle(
                        fontSize: fontSize,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    ShaderMask(
                      shaderCallback: (bounds) =>
                          AppColors.primaryGradient.createShader(bounds),
                      child: Text(
                        'Nabin',
                        style: TextStyle(
                          fontSize: fontSize,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),

                const Gap(10),

                // Title with typing effect
                ShaderMask(
                  shaderCallback: (bounds) =>
                      AppColors.secondaryGradient.createShader(bounds),
                  child: Text(
                    'Flutter Developer',
                    style: TextStyle(
                      fontSize: fontSize * 0.8,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: isMobile ? TextAlign.center : TextAlign.start,
                  ),
                ),

                const Gap(20),

                // Description
                Container(
                  constraints: BoxConstraints(
                    maxWidth: isMobile ? double.infinity : 500,
                  ),
                  child: Text(
                    'Passionate mobile app developer with expertise in Flutter. I create beautiful, performant, and user-friendly applications that bring ideas to life.',
                    style: TextStyle(
                      fontSize: descriptionSize,
                      color: Theme.of(context).colorScheme.secondary,
                      height: 1.6,
                    ),
                    textAlign: isMobile ? TextAlign.center : TextAlign.start,
                  ),
                ),

                const Gap(40),

                // Action buttons
                Wrap(
                  alignment:
                      isMobile ? WrapAlignment.center : WrapAlignment.start,
                  spacing: 20,
                  runSpacing: 15,
                  children: [
                    CustomButton(
                      text: 'Download CV',
                      isGradient: true,
                      width: isMobile ? 150 : 180,
                      icon: Icons.download,
                      onPressed: () {
                        _downloadCV();
                      },
                    ),
                    CustomButton(
                      text: 'Contact Me',
                      isOutlined: true,
                      width: isMobile ? 150 : 180,
                      icon: Icons.mail_outline,
                      onPressed: () {
                        widget.onContactPressed?.call();
                      },
                    ),
                  ],
                ),

                const Gap(30),

                // Social media quick links
                if (!isMobile) _buildSocialLinks(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildImageSection(double size) {
    return AnimatedBuilder(
      animation: _imageAnimationController,
      builder: (context, child) {
        return Center(
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Animated background circle
              Transform.rotate(
                angle: _imageRotateAnimation.value * 2 * 3.14159,
                child: Container(
                  width: size + 60,
                  height: size + 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: AppColors.primaryGradient,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryBlue.withOpacity(0.3),
                        blurRadius: 30,
                        spreadRadius: 10,
                      ),
                    ],
                  ),
                ),
              ),

              // Profile image container
              ScaleTransition(
                scale: _imageScaleAnimation,
                child: GlassCard(
                  width: size,
                  height: size,
                  borderRadius: BorderRadius.circular(size / 2),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(size / 2),
                    child: Stack(
                      children: [
                        // Profile image
                        Image.asset(
                          'assets/profile.png',
                          width: size,
                          height: size,
                          fit: BoxFit.cover,
                        ),

                        // Overlay effect
                        Container(
                          width: size,
                          height: size,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Colors.transparent,
                                AppColors.primaryBlue.withOpacity(0.1),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Floating skill badges
              ..._buildFloatingSkills(size),
            ],
          ),
        );
      },
    );
  }

  List<Widget> _buildFloatingSkills(double containerSize) {
    final skills = ['Flutter', 'Dart', 'Firebase', 'API'];
    final radius = containerSize / 2 + 40;

    return List.generate(skills.length, (index) {
      final angle = (index * 2 * 3.14159) / skills.length;
      final x = radius * cos(angle);
      final y = radius * sin(angle);

      return Positioned(
        left: containerSize / 2 + x - 30,
        top: containerSize / 2 + y - 15,
        child: TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: 1.0),
          duration: Duration(milliseconds: 1000 + (index * 200)),
          curve: Curves.elasticOut,
          builder: (context, value, child) {
            return Transform.scale(
              scale: value,
              child: GlassCard(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: Text(
                  skills[index],
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            );
          },
        ),
      );
    });
  }

  Widget _buildSocialLinks() {
    return Row(
      children: [
        Text(
          'Follow me:',
          style: TextStyle(
            fontSize: 14,
            color: Theme.of(context).colorScheme.secondary,
            fontWeight: FontWeight.w500,
          ),
        ),
        const Gap(15),
        _buildSocialIcon('assets/gitIcon.png', 'https://github.com/m0dern6'),
        const Gap(10),
        _buildSocialIcon('assets/linkedIn.png',
            'https://www.linkedin.com/in/nabin-adhikari-73a937318/'),
      ],
    );
  }

  Widget _buildSocialIcon(String iconPath, String url) {
    return GestureDetector(
      onTap: () {
        // Add URL launch functionality
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.primaryBlue.withOpacity(0.1),
          border: Border.all(
            color: AppColors.primaryBlue.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Image.asset(
          iconPath,
          width: 20,
          height: 20,
          color: Theme.of(context).colorScheme.secondary,
        ),
      ),
    );
  }

  void _downloadCV() async {
    const url = 'assets/my_cv.pdf';
    final uri = Uri.parse(url);

    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        // Fallback: try to open the file directly
        await launchUrl(Uri.parse('my_cv.pdf'),
            mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      // Show a snackbar or error message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Unable to download CV. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
