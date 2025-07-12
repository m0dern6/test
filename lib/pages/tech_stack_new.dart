import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:portfolio/constants/skills.dart';
import 'package:portfolio/utils/responsive.dart';
import 'package:portfolio/utils/app_colors.dart';
import 'package:portfolio/widgets/glass_card.dart';

class TechStack extends StatefulWidget {
  const TechStack({super.key});

  @override
  State<TechStack> createState() => _TechStackState();
}

class _TechStackState extends State<TechStack> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late List<AnimationController> _itemControllers;
  late List<Animation<double>> _scaleAnimations;
  late List<Animation<double>> _fadeAnimations;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _itemControllers = List.generate(
      skills.length,
      (index) => AnimationController(
        duration: Duration(milliseconds: 600 + (index * 100)),
        vsync: this,
      ),
    );

    _scaleAnimations = _itemControllers.map((controller) {
      return Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: controller, curve: Curves.elasticOut),
      );
    }).toList();

    _fadeAnimations = _itemControllers.map((controller) {
      return Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: controller, curve: Curves.easeIn),
      );
    }).toList();

    _animationController.forward();

    // Start item animations with staggered delay
    for (int i = 0; i < _itemControllers.length; i++) {
      Future.delayed(Duration(milliseconds: 200 + (i * 100)), () {
        if (mounted) _itemControllers[i].forward();
      });
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    for (final controller in _itemControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      padding: EdgeInsets.symmetric(
        horizontal: Responsive.isMobile(context) ? 20 : 40,
        vertical: 40,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Section
          _buildHeader(),

          const Gap(60),

          // Tech Stack Grid
          _buildTechGrid(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    final isMobile = Responsive.isMobile(context);

    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0, -0.5),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutCubic,
      )),
      child: FadeTransition(
        opacity: _animationController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section title with gradient
            Row(
              children: [
                Container(
                  width: 4,
                  height: isMobile ? 30 : 40,
                  decoration: const BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.all(Radius.circular(2)),
                  ),
                ),
                const Gap(15),
                ShaderMask(
                  shaderCallback: (bounds) =>
                      AppColors.primaryGradient.createShader(bounds),
                  child: Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: isMobile ? 28 : 42,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),

            const Gap(20),

            // Description
            Container(
              constraints: BoxConstraints(
                maxWidth: isMobile ? double.infinity : 600,
              ),
              child: Text(
                description,
                style: GoogleFonts.dmSans(
                  fontSize: isMobile ? 16 : 20,
                  color: Theme.of(context).colorScheme.secondary,
                  height: 1.6,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTechGrid() {
    final isMobile = Responsive.isMobile(context);
    final isTablet = Responsive.isTablet(context);

    int crossAxisCount;
    if (isMobile) {
      crossAxisCount = 2;
    } else if (isTablet) {
      crossAxisCount = 3;
    } else {
      crossAxisCount = 4;
    }

    return GridView.builder(
      padding: const EdgeInsets.symmetric(vertical: 20),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: 20,
        crossAxisSpacing: 20,
        childAspectRatio: 1.0,
      ),
      itemCount: skills.length,
      itemBuilder: (context, index) {
        return _buildTechCard(skills[index], index);
      },
    );
  }

  Widget _buildTechCard(Map<String, dynamic> skill, int index) {
    final isMobile = Responsive.isMobile(context);

    return AnimatedBuilder(
      animation: _itemControllers[index],
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimations[index].value,
          child: FadeTransition(
            opacity: _fadeAnimations[index],
            child: _TechStackCard(
              skill: skill,
              isMobile: isMobile,
              onTap: () => _showSkillDetail(skill),
            ),
          ),
        );
      },
    );
  }

  void _showSkillDetail(Map<String, dynamic> skill) {
    showDialog(
      context: context,
      builder: (context) => _SkillDetailDialog(skill: skill),
    );
  }
}

class _TechStackCard extends StatefulWidget {
  final Map<String, dynamic> skill;
  final bool isMobile;
  final VoidCallback onTap;

  const _TechStackCard({
    required this.skill,
    required this.isMobile,
    required this.onTap,
  });

  @override
  State<_TechStackCard> createState() => __TechStackCardState();
}

class __TechStackCardState extends State<_TechStackCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _hoverController;
  late Animation<double> _hoverAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _hoverController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _hoverAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _hoverController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _hoverController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        setState(() => _isHovered = true);
        _hoverController.forward();
      },
      onExit: (_) {
        setState(() => _isHovered = false);
        _hoverController.reverse();
      },
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedBuilder(
          animation: _hoverAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _hoverAnimation.value,
              child: GlassCard(
                padding: EdgeInsets.all(widget.isMobile ? 16 : 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Tech icon with glow effect
                    Container(
                      width: widget.isMobile ? 60 : 80,
                      height: widget.isMobile ? 60 : 80,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        gradient: _isHovered
                            ? AppColors.primaryGradient
                            : LinearGradient(
                                colors: [
                                  AppColors.primaryBlue.withOpacity(0.1),
                                  AppColors.primaryPurple.withOpacity(0.1),
                                ],
                              ),
                        boxShadow: _isHovered
                            ? [
                                BoxShadow(
                                  color: AppColors.primaryBlue.withOpacity(0.4),
                                  blurRadius: 20,
                                  spreadRadius: 2,
                                ),
                              ]
                            : [],
                      ),
                      child: Image.asset(
                        widget.skill['image'],
                        fit: BoxFit.contain,
                        color: _isHovered ? Colors.white : null,
                      ),
                    ),

                    const Gap(15),

                    // Tech name
                    Text(
                      widget.skill['name'],
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: widget.isMobile ? 14 : 16,
                        fontWeight: FontWeight.w600,
                        color: _isHovered
                            ? AppColors.primaryBlue
                            : Theme.of(context).colorScheme.primary,
                      ),
                    ),

                    const Gap(8),

                    // Experience level indicator
                    _buildExperienceIndicator(),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildExperienceIndicator() {
    // Mock experience levels for each tech
    final experienceLevels = {
      'Flutter': 0.9,
      'Dart': 0.85,
      'Firebase': 0.8,
      'SQ Lite': 0.75,
      'Android Studio': 0.9,
      'Vs Code': 0.95,
      'Git Bash': 0.8,
      'Git Hub': 0.85,
    };

    final level = experienceLevels[widget.skill['name']] ?? 0.7;

    return Container(
      width: 60,
      height: 4,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(2),
        color: AppColors.primaryBlue.withOpacity(0.2),
      ),
      child: FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: level,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(2),
            gradient: AppColors.primaryGradient,
          ),
        ),
      ),
    );
  }
}

class _SkillDetailDialog extends StatelessWidget {
  final Map<String, dynamic> skill;

  const _SkillDetailDialog({required this.skill});

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);

    return Dialog(
      backgroundColor: Colors.transparent,
      child: GlassCard(
        width: isMobile ? MediaQuery.of(context).size.width * 0.9 : 400,
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Skill icon
            Container(
              width: 100,
              height: 100,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: AppColors.primaryGradient,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryBlue.withOpacity(0.3),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Image.asset(
                skill['image'],
                fit: BoxFit.contain,
                color: Colors.white,
              ),
            ),

            const Gap(20),

            // Skill name
            Text(
              skill['name'],
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),

            const Gap(15),

            // Description
            Text(
              _getSkillDescription(skill['name']),
              textAlign: TextAlign.center,
              style: GoogleFonts.dmSans(
                fontSize: 16,
                color: Theme.of(context).colorScheme.secondary,
                height: 1.5,
              ),
            ),

            const Gap(25),

            // Close button
            SizedBox(
              width: 120,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryBlue,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Close'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getSkillDescription(String skillName) {
    final descriptions = {
      'Flutter':
          'Google\'s UI toolkit for building beautiful, natively compiled applications for mobile, web, and desktop from a single codebase.',
      'Dart':
          'A client-optimized programming language for apps on multiple platforms. It is developed by Google and is used to build mobile, desktop, server, and web applications.',
      'Firebase':
          'A platform developed by Google for creating mobile and web applications. It provides a real-time database, authentication, analytics, and more.',
      'SQ Lite':
          'A C-language library that implements a small, fast, self-contained, high-reliability, full-featured, SQL database engine.',
      'Android Studio':
          'The official integrated development environment (IDE) for Google\'s Android operating system, built on JetBrains\' IntelliJ IDEA software.',
      'Vs Code':
          'A lightweight but powerful source code editor which runs on your desktop and is available for Windows, macOS and Linux.',
      'Git Bash':
          'A command-line tool that provides a Unix-like environment for Windows users to interact with Git repositories.',
      'Git Hub':
          'A web-based platform for version control using Git. It provides hosting for software development and version control.',
    };

    return descriptions[skillName] ??
        'A powerful technology used in modern software development.';
  }
}
