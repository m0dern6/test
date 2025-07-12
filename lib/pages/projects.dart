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
  late TabController _tabController;

  int _selectedCategory = 0;
  List<String> categories = ['Company', 'UI/UX', 'Academic'];

  List<List<Map<String, dynamic>>> projectCategories = [
    companyProjects,
    uiuxProjects,
    academicProjects,
  ];

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _tabController = TabController(length: 3, vsync: this);

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 20 : 40,
        vertical: 40,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          _buildHeader(isMobile),

          const Gap(40),

          // Category Tabs
          _buildCategoryTabs(isMobile),

          const Gap(40),

          // Projects Grid
          _buildProjectsGrid(isMobile),
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

  Widget _buildCategoryTabs(bool isMobile) {
    return FadeTransition(
      opacity: _animationController,
      child: Container(
        height: 50,
        child: Row(
          children: List.generate(categories.length, (index) {
            final isSelected = _selectedCategory == index;
            return Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedCategory = index;
                  });
                  _tabController.animateTo(index);
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    gradient: isSelected ? AppColors.primaryGradient : null,
                    border: isSelected
                        ? null
                        : Border.all(
                            color: AppColors.primaryBlue.withOpacity(0.3),
                          ),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Center(
                    child: Text(
                      '${categories[index]} Projects',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.dmSans(
                        fontSize: isMobile ? 12 : 16,
                        fontWeight: FontWeight.w600,
                        color: isSelected
                            ? Colors.white
                            : Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildProjectsGrid(bool isMobile) {
    final currentProjects = projectCategories[_selectedCategory];

    return FadeTransition(
      opacity: _animationController,
      child: isMobile
          ? _buildMobileProjectsGrid(currentProjects)
          : _buildDesktopProjectsGrid(currentProjects),
    );
  }

  Widget _buildMobileProjectsGrid(List<Map<String, dynamic>> projects) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 1,
        childAspectRatio: 1.2,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
      ),
      itemCount: projects.length,
      itemBuilder: (context, index) => _buildProjectCard(projects[index], true),
    );
  }

  Widget _buildDesktopProjectsGrid(List<Map<String, dynamic>> projects) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: projects.length >= 3 ? 3 : 2,
        childAspectRatio: 1.1,
        crossAxisSpacing: 25,
        mainAxisSpacing: 25,
      ),
      itemCount: projects.length,
      itemBuilder: (context, index) =>
          _buildProjectCard(projects[index], false),
    );
  }

  Widget _buildProjectCard(Map<String, dynamic> project, bool isMobile) {
    return GlassCard(
      padding: EdgeInsets.all(isMobile ? 15 : 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Project Image
          Expanded(
            flex: 3,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: AppColors.primaryBlue.withOpacity(0.1),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: project['img'] != null && project['img'].isNotEmpty
                    ? Stack(
                        children: [
                          Image.asset(
                            project['img'][0],
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  gradient: AppColors.primaryGradient,
                                ),
                                child: const Center(
                                  child: Icon(
                                    Icons.image,
                                    size: 40,
                                    color: Colors.white,
                                  ),
                                ),
                              );
                            },
                          ),
                          // View Images Button
                          if (project['img'].length > 1)
                            Positioned(
                              top: 8,
                              right: 8,
                              child: GestureDetector(
                                onTap: () =>
                                    _showImageGallery(context, project),
                                child: Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.7),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(
                                        Icons.photo_library,
                                        color: Colors.white,
                                        size: 14,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        '${project['img'].length}',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                        ],
                      )
                    : Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          gradient: AppColors.primaryGradient,
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.image,
                            size: 40,
                            color: Colors.white,
                          ),
                        ),
                      ),
              ),
            ),
          ),

          const Gap(12),

          // Project Title
          Text(
            project['title'],
            style: GoogleFonts.poppins(
              fontSize: isMobile ? 16 : 18,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),

          const Gap(6),

          // Project Description
          Expanded(
            flex: 2,
            child: Text(
              project['description'],
              style: GoogleFonts.dmSans(
                fontSize: isMobile ? 12 : 14,
                color: Theme.of(context).colorScheme.secondary,
                height: 1.4,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          const Gap(8),

          // Tech Stack
          Wrap(
            spacing: 4,
            runSpacing: 4,
            children: project['tech'].split(', ').take(3).map<Widget>((tech) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primaryBlue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.primaryBlue.withOpacity(0.3),
                  ),
                ),
                child: Text(
                  tech,
                  style: GoogleFonts.dmSans(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: AppColors.primaryBlue,
                  ),
                ),
              );
            }).toList(),
          ),

          const Gap(12),

          // Action Buttons
          Row(
            children: [
              // GitHub Button
              if (project['gitLink'] != null && project['gitLink'].isNotEmpty)
                Expanded(
                  child: SizedBox(
                    height: 32,
                    child: CustomButton(
                      text: 'Source Code',
                      onPressed: () => _launchUrl(project['gitLink']),
                      backgroundColor: AppColors.primaryBlue,
                      textColor: AppColors.primaryBlue,
                      isOutlined: true,
                    ),
                  ),
                ),

              // Demo Button (only for Service Pro)
              if (project['hasDemo'] == true) ...[
                const Gap(8),
                Expanded(
                  child: SizedBox(
                    height: 32,
                    child: CustomButton(
                      text: 'Demo',
                      onPressed: () => _launchUrl(project['videoUrl'] ?? ''),
                      backgroundColor: AppColors.primaryBlue,
                      textColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    if (url.isNotEmpty) {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    }
  }

  void _showImageGallery(BuildContext context, Map<String, dynamic> project) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            height: MediaQuery.of(context).size.height * 0.8,
            width: MediaQuery.of(context).size.width * 0.9,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Theme.of(context).dividerColor,
                        width: 1,
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          project['title'] + ' - Gallery',
                          style: GoogleFonts.poppins(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),
                ),
                // Image Grid
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: Responsive.isMobile(context) ? 2 : 3,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 0.8,
                      ),
                      itemCount: project['img'].length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            // Show full screen image
                            _showFullScreenImage(
                                context, project['img'], index);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.asset(
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
                                        color: Colors.white,
                                        size: 40,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showFullScreenImage(
      BuildContext context, List<String> images, int initialIndex) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.black.withOpacity(0.9),
          insetPadding: EdgeInsets.zero,
          child: Stack(
            children: [
              PageView.builder(
                controller: PageController(initialPage: initialIndex),
                itemCount: images.length,
                itemBuilder: (context, index) {
                  return Center(
                    child: InteractiveViewer(
                      child: Image.asset(
                        images[index],
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return const Center(
                            child: Icon(
                              Icons.image,
                              color: Colors.white,
                              size: 100,
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
              Positioned(
                top: 40,
                right: 20,
                child: IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
