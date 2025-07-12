import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:portfolio/constants/about_me.dart';
import 'package:portfolio/utils/responsive.dart';
import 'package:portfolio/utils/app_colors.dart';
import 'package:portfolio/widgets/glass_card.dart';

class AboutMe extends StatefulWidget {
  const AboutMe({super.key});

  @override
  State<AboutMe> createState() => _AboutMeState();
}

class _AboutMeState extends State<AboutMe> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
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
      child: Responsive.responsiveWidget(
        context: context,
        mobile: _buildMobileLayout(),
        tablet: _buildTabletLayout(),
        desktop: _buildDesktopLayout(),
      ),
    );
  }

  Widget _buildDesktopLayout() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left side - About content
        Expanded(
          flex: 3,
          child: _buildAboutContent(),
        ),

        const Gap(60),

        // Right side - Experience and Education
        Expanded(
          flex: 2,
          child: _buildExperienceEducation(),
        ),
      ],
    );
  }

  Widget _buildTabletLayout() {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildAboutContent(),
          const Gap(40),
          _buildExperienceEducation(),
        ],
      ),
    );
  }

  Widget _buildMobileLayout() {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildAboutContent(),
          const Gap(30),
          _buildExperienceEducation(),
        ],
      ),
    );
  }

  Widget _buildAboutContent() {
    final isMobile = Responsive.isMobile(context);

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Section title
                _buildSectionTitle('About Me', isMobile),
                const Gap(30),

                // Profile stats row
                if (!isMobile) _buildStatsRow(),
                if (!isMobile) const Gap(40),

                // About description
                GlassCard(
                  padding: EdgeInsets.all(isMobile ? 20 : 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Who I Am',
                        style: GoogleFonts.poppins(
                          fontSize: isMobile ? 20 : 24,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      const Gap(15),
                      Text(
                        aboutMe,
                        style: GoogleFonts.dmSans(
                          fontSize: isMobile ? 14 : 16,
                          color: Theme.of(context).colorScheme.secondary,
                          height: 1.6,
                        ),
                      ),
                    ],
                  ),
                ),

                if (isMobile) ...[
                  const Gap(30),
                  _buildStatsRow(),
                ],

                const Gap(30),

                // Skills section
                _buildSkillsSection(isMobile),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildExperienceEducation() {
    final isMobile = Responsive.isMobile(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Work Experience
        _buildSectionTitle('Experience', isMobile),
        const Gap(20),

        for (int i = 0; i < workExp.length; i++)
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: _buildExperienceCard(workExp[i], isMobile),
          ),

        const Gap(30),

        // Education
        _buildSectionTitle('Education', isMobile),
        const Gap(20),

        for (int i = 0; i < education.length; i++)
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: _buildEducationCard(education[i], isMobile),
          ),
      ],
    );
  }

  Widget _buildSectionTitle(String title, bool isMobile) {
    return Row(
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
        Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: isMobile ? 28 : 36,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ],
    );
  }

  Widget _buildStatsRow() {
    final isMobile = Responsive.isMobile(context);
    final stats = [
      {'number': '3+', 'label': 'Months Experience'},
      {'number': '5+', 'label': 'Projects Completed'},
      {'number': '100%', 'label': 'Client Satisfaction'},
    ];

    return Row(
      children: stats.map((stat) {
        final index = stats.indexOf(stat);
        return Expanded(
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: Duration(milliseconds: 800 + (index * 200)),
            curve: Curves.elasticOut,
            builder: (context, value, child) {
              return Transform.scale(
                scale: value,
                child: GlassCard(
                  margin:
                      EdgeInsets.only(right: index < stats.length - 1 ? 15 : 0),
                  padding: EdgeInsets.all(isMobile ? 15 : 20),
                  child: Column(
                    children: [
                      ShaderMask(
                        shaderCallback: (bounds) =>
                            AppColors.primaryGradient.createShader(bounds),
                        child: Text(
                          stat['number']!,
                          style: GoogleFonts.poppins(
                            fontSize: isMobile ? 24 : 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const Gap(5),
                      Text(
                        stat['label']!,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.dmSans(
                          fontSize: isMobile ? 12 : 14,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSkillsSection(bool isMobile) {
    final skills = [
      {'name': 'Flutter Development', 'level': 0.9},
      {'name': 'Dart Programming', 'level': 0.85},
      {'name': 'Firebase Integration', 'level': 0.8},
      {'name': 'API Integration', 'level': 0.75},
      {'name': 'UI/UX Design', 'level': 0.7},
    ];

    return GlassCard(
      padding: EdgeInsets.all(isMobile ? 20 : 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Technical Skills',
            style: GoogleFonts.poppins(
              fontSize: isMobile ? 20 : 24,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const Gap(20),
          for (int i = 0; i < skills.length; i++)
            Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: _buildSkillBar(skills[i], i),
            ),
        ],
      ),
    );
  }

  Widget _buildSkillBar(Map<String, dynamic> skill, int index) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: skill['level']),
      duration: Duration(milliseconds: 1000 + (index * 200)),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  skill['name'],
                  style: GoogleFonts.dmSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                Text(
                  '${(value * 100).toInt()}%',
                  style: GoogleFonts.dmSans(
                    fontSize: 12,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
              ],
            ),
            const Gap(8),
            Container(
              height: 6,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3),
                color: AppColors.primaryBlue.withOpacity(0.1),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: value,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3),
                    gradient: AppColors.primaryGradient,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildExperienceCard(Map<String, dynamic> experience, bool isMobile) {
    return GlassCard(
      padding: EdgeInsets.all(isMobile ? 15 : 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.work,
                  color: Colors.white,
                  size: 16,
                ),
              ),
              const Gap(12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      experience['title'],
                      style: GoogleFonts.poppins(
                        fontSize: isMobile ? 14 : 16,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const Gap(4),
                    Text(
                      experience['company'],
                      style: GoogleFonts.dmSans(
                        fontSize: isMobile ? 12 : 14,
                        color: AppColors.primaryBlue,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Gap(4),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          size: 14,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                        const Gap(4),
                        Text(
                          experience['location'],
                          style: GoogleFonts.dmSans(
                            fontSize: isMobile ? 11 : 13,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primaryBlue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  experience['category'],
                  style: GoogleFonts.dmSans(
                    fontSize: 10,
                    color: AppColors.primaryBlue,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const Gap(8),
          Row(
            children: [
              Icon(
                Icons.calendar_today,
                size: 14,
                color: Theme.of(context).colorScheme.secondary,
              ),
              const Gap(4),
              Text(
                experience['duration'],
                style: GoogleFonts.dmSans(
                  fontSize: isMobile ? 11 : 13,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEducationCard(Map<String, dynamic> edu, bool isMobile) {
    return GlassCard(
      padding: EdgeInsets.all(isMobile ? 15 : 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: AppColors.secondaryGradient,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.school,
                  color: Colors.white,
                  size: 16,
                ),
              ),
              const Gap(12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      edu['degree'],
                      style: GoogleFonts.poppins(
                        fontSize: isMobile ? 14 : 16,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const Gap(4),
                    Text(
                      edu['institution'],
                      style: GoogleFonts.dmSans(
                        fontSize: isMobile ? 12 : 14,
                        color: AppColors.primaryPurple,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Gap(4),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          size: 14,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                        const Gap(4),
                        Text(
                          edu['location'],
                          style: GoogleFonts.dmSans(
                            fontSize: isMobile ? 11 : 13,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primaryPurple.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  edu['status'],
                  style: GoogleFonts.dmSans(
                    fontSize: 10,
                    color: AppColors.primaryPurple,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const Gap(8),
          Row(
            children: [
              Icon(
                Icons.calendar_today,
                size: 14,
                color: Theme.of(context).colorScheme.secondary,
              ),
              const Gap(4),
              Text(
                edu['duration'],
                style: GoogleFonts.dmSans(
                  fontSize: isMobile ? 11 : 13,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
