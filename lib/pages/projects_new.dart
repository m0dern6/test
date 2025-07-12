import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:portfolio/constants/project_items.dart';
import 'package:portfolio/utils/responsive.dart';
import 'package:portfolio/utils/app_colors.dart';
import 'package:portfolio/widgets/glass_card.dart';
import 'package:portfolio/widgets/custom_button.dart';
import 'package:url_launcher/url_launcher.dart';

class Projects extends StatefulWidget {
  const Projects({super.key});

  @override
  State<Projects> createState() => _ProjectsState();
}

class _ProjectsState extends State<Projects> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late List<AnimationController> _projectControllers;
  late PageController _pageController;

  int _currentPage = 0;
  int _selectedProject = 0;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _projectControllers = List.generate(
      projects.length,
      (index) => AnimationController(
        duration: Duration(milliseconds: 600 + (index * 100)),
        vsync: this,
      ),
    );

    _pageController = PageController();

    _animationController.forward();

    // Start project animations with staggered delay
    for (int i = 0; i < _projectControllers.length; i++) {
      Future.delayed(Duration(milliseconds: 300 + (i * 150)), () {
        if (mounted) _projectControllers[i].forward();
      });
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _pageController.dispose();
    for (final controller in _projectControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);

    return Container(
      height: MediaQuery.of(context).size.height,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 20 : 40,
        vertical: 40,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          _buildHeader(isMobile),

          const Gap(60),

          // Projects content
          Expanded(
            child: isMobile
                ? _buildMobileProjectsView()
                : _buildDesktopProjectsView(),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(bool isMobile) {
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
            const Gap(15),
            Text(
              description,
              style: GoogleFonts.dmSans(
                fontSize: isMobile ? 16 : 20,
                color: Theme.of(context).colorScheme.secondary,
                height: 1.6,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMobileProjectsView() {
    return Column(
      children: [
        // Project cards carousel
        Expanded(
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() => _currentPage = index);
            },
            itemCount: projects.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: _buildProjectCard(projects[index], index, true),
              );
            },
          ),
        ),

        const Gap(20),

        // Page indicators
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            projects.length,
            (index) => Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: _currentPage == index ? 24 : 8,
              height: 8,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: _currentPage == index
                    ? AppColors.primaryBlue
                    : AppColors.primaryBlue.withOpacity(0.3),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDesktopProjectsView() {
    return Row(
      children: [
        // Featured project display
        Expanded(
          flex: 3,
          child: _buildFeaturedProject(),
        ),

        const Gap(40),

        // Project list
        Expanded(
          flex: 2,
          child: _buildProjectsList(),
        ),
      ],
    );
  }

  Widget _buildFeaturedProject() {
    final project = projects[_selectedProject];

    return AnimatedBuilder(
      animation: _projectControllers[_selectedProject],
      builder: (context, child) {
        return FadeTransition(
          opacity: _projectControllers[_selectedProject],
          child: GlassCard(
            padding: const EdgeInsets.all(30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Project images carousel
                Expanded(
                  flex: 3,
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: AppColors.primaryBlue.withOpacity(0.1),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: PageView.builder(
                        itemCount: project['img'].length,
                        itemBuilder: (context, index) {
                          return Image.asset(
                            project['img'][index],
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  gradient: AppColors.primaryGradient,
                                ),
                                child: const Center(
                                  child: Icon(
                                    Icons.image,
                                    size: 60,
                                    color: Colors.white,
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ),
                ),

                const Gap(25),

                // Project details
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        project['title'],
                        style: GoogleFonts.poppins(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),

                      const Gap(15),

                      Expanded(
                        child: Text(
                          project['description'],
                          style: GoogleFonts.dmSans(
                            fontSize: 16,
                            color: Theme.of(context).colorScheme.secondary,
                            height: 1.6,
                          ),
                        ),
                      ),

                      const Gap(20),

                      // Tech stack
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children:
                            project['tech'].split(', ').map<Widget>((tech) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              color: AppColors.primaryBlue.withOpacity(0.1),
                              border: Border.all(
                                color: AppColors.primaryBlue.withOpacity(0.3),
                              ),
                            ),
                            child: Text(
                              tech,
                              style: GoogleFonts.dmSans(
                                fontSize: 12,
                                color: AppColors.primaryBlue,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          );
                        }).toList(),
                      ),

                      const Gap(25),

                      // Action buttons
                      Row(
                        children: [
                          Expanded(
                            child: CustomButton(
                              text: 'View Demo',
                              isGradient: true,
                              icon: Icons.play_arrow,
                              onPressed: () => _launchURL(project['videoUrl']),
                            ),
                          ),
                          const Gap(15),
                          Expanded(
                            child: CustomButton(
                              text: 'Source Code',
                              isOutlined: true,
                              icon: Icons.code,
                              onPressed: () => _launchURL(project['gitLink']),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildProjectsList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'All Projects',
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        const Gap(20),
        Expanded(
          child: ListView.builder(
            itemCount: projects.length,
            itemBuilder: (context, index) {
              return AnimatedBuilder(
                animation: _projectControllers[index],
                builder: (context, child) {
                  return FadeTransition(
                    opacity: _projectControllers[index],
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0.3, 0),
                        end: Offset.zero,
                      ).animate(_projectControllers[index]),
                      child: _buildProjectListItem(projects[index], index),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildProjectListItem(Map<String, dynamic> project, int index) {
    final isSelected = _selectedProject == index;

    return GestureDetector(
      onTap: () {
        setState(() => _selectedProject = index);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: isSelected
              ? AppColors.primaryBlue.withOpacity(0.1)
              : Colors.transparent,
          border: Border.all(
            color: isSelected ? AppColors.primaryBlue : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            // Project thumbnail
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                gradient: AppColors.primaryGradient,
              ),
              child: const Icon(
                Icons.web,
                color: Colors.white,
                size: 30,
              ),
            ),

            const Gap(15),

            // Project info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    project['title'],
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isSelected
                          ? AppColors.primaryBlue
                          : Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const Gap(5),
                  Text(
                    project['tech'].split(', ').take(2).join(', '),
                    style: GoogleFonts.dmSans(
                      fontSize: 14,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                ],
              ),
            ),

            if (isSelected)
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: AppColors.primaryBlue,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildProjectCard(
      Map<String, dynamic> project, int index, bool isMobile) {
    return AnimatedBuilder(
      animation: _projectControllers[index],
      builder: (context, child) {
        return FadeTransition(
          opacity: _projectControllers[index],
          child: GlassCard(
            padding: EdgeInsets.all(isMobile ? 20 : 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Project image
                Expanded(
                  flex: 2,
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient: AppColors.primaryGradient,
                    ),
                    child: const Icon(
                      Icons.web,
                      color: Colors.white,
                      size: 60,
                    ),
                  ),
                ),

                const Gap(20),

                // Project details
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        project['title'],
                        style: GoogleFonts.poppins(
                          fontSize: isMobile ? 20 : 24,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),

                      const Gap(10),

                      Expanded(
                        child: Text(
                          project['description'],
                          style: GoogleFonts.dmSans(
                            fontSize: isMobile ? 14 : 16,
                            color: Theme.of(context).colorScheme.secondary,
                            height: 1.5,
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),

                      const Gap(15),

                      // Tech stack
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: project['tech']
                            .split(', ')
                            .take(3)
                            .map<Widget>((tech) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: AppColors.primaryBlue.withOpacity(0.1),
                            ),
                            child: Text(
                              tech,
                              style: GoogleFonts.dmSans(
                                fontSize: 10,
                                color: AppColors.primaryBlue,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          );
                        }).toList(),
                      ),

                      const Gap(20),

                      // Action buttons
                      Row(
                        children: [
                          Expanded(
                            child: CustomButton(
                              text: 'Demo',
                              isGradient: true,
                              height: 40,
                              onPressed: () => _launchURL(project['videoUrl']),
                            ),
                          ),
                          const Gap(10),
                          Expanded(
                            child: CustomButton(
                              text: 'Code',
                              isOutlined: true,
                              height: 40,
                              onPressed: () => _launchURL(project['gitLink']),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      launchUrl(uri);
    }
  }
}
