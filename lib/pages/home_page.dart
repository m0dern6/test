import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:portfolio/constants/body_items.dart';
import 'package:portfolio/constants/header_items.dart';
import 'package:portfolio/pages/home.dart';
import 'package:portfolio/theme/theme_provider.dart';
import 'package:portfolio/utils/responsive.dart';
import 'package:portfolio/utils/app_colors.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final List<GlobalKey> _sectionKeys = List.generate(5, (index) => GlobalKey());

  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  int _currentIndex = 0;
  var modeImg = 'assets/sun.png';

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    _fadeController.forward();
    _slideController.forward();

    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final scrollOffset = _scrollController.offset;
    int newIndex = 0;

    for (int i = 0; i < _sectionKeys.length; i++) {
      final keyContext = _sectionKeys[i].currentContext;
      if (keyContext != null) {
        final RenderBox renderBox = keyContext.findRenderObject() as RenderBox;
        final position = renderBox.localToGlobal(Offset.zero);
        final sectionTop = position.dy + scrollOffset;
        final sectionHeight = renderBox.size.height;

        if (scrollOffset >= sectionTop - 100 &&
            scrollOffset < sectionTop + sectionHeight - 100) {
          newIndex = i;
          break;
        }
      }
    }

    if (newIndex != _currentIndex) {
      setState(() {
        _currentIndex = newIndex;
      });
    }
  }

  _scrollToIndex(int index) {
    if (index >= 0 && index < _sectionKeys.length) {
      final keyContext = _sectionKeys[index].currentContext;
      if (keyContext != null) {
        final RenderBox renderBox = keyContext.findRenderObject() as RenderBox;
        final position = renderBox.localToGlobal(Offset.zero);
        final targetOffset =
            _scrollController.offset + position.dy - 80; // Account for app bar

        _scrollController.animateTo(
          targetOffset,
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOutCubic,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    final isTablet = Responsive.isTablet(context);

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Theme.of(context).colorScheme.surface,
      drawer: isMobile ? _buildMobileDrawer() : null,
      body: Stack(
        children: [
          // Background gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Theme.of(context).colorScheme.surface,
                  Theme.of(context).colorScheme.surface.withOpacity(0.8),
                  AppColors.primaryBlue.withOpacity(0.1),
                ],
              ),
            ),
          ),

          // Floating particles background
          ...List.generate(20, (index) => _buildFloatingParticle(index)),

          // Main content
          Column(
            children: [
              // Custom App Bar
              _buildCustomAppBar(isMobile, isTablet),

              // Body content
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  itemCount: bodyItems.length,
                  itemBuilder: (context, index) {
                    return AnimatedBuilder(
                      animation: _fadeAnimation,
                      builder: (context, child) {
                        return FadeTransition(
                          opacity: _fadeAnimation,
                          child: SlideTransition(
                            position: _slideAnimation,
                            child: Container(
                              key: _sectionKeys[index],
                              constraints: BoxConstraints(
                                minHeight:
                                    MediaQuery.of(context).size.height - 80,
                              ),
                              margin: EdgeInsets.only(
                                bottom: index < bodyItems.length - 1 ? 60 : 0,
                              ),
                              padding: EdgeInsets.symmetric(
                                horizontal: isMobile
                                    ? 20
                                    : isTablet
                                        ? 40
                                        : 80,
                                vertical: 40,
                              ),
                              child: _buildBodyWidget(index),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),

          // Floating navigation indicator
          if (!isMobile) _buildNavigationIndicator(),

          // Floating action button
          _buildFloatingThemeToggle(isMobile),
        ],
      ),
    );
  }

  Widget _buildCustomAppBar(bool isMobile, bool isTablet) {
    return Container(
      height: 80,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 20 : 40,
        vertical: 10,
      ),
      child: Row(
        children: [
          // Logo/Name
          Expanded(
            child: Row(
              children: [
                if (isMobile)
                  IconButton(
                    icon: Icon(
                      Icons.menu,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    onPressed: () => _scaffoldKey.currentState?.openDrawer(),
                  )
                else
                  ShaderMask(
                    shaderCallback: (bounds) =>
                        AppColors.primaryGradient.createShader(bounds),
                    child: Text(
                      'Nabin Adhikari',
                      style: TextStyle(
                        fontSize: isMobile ? 20 : 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // Navigation items (desktop/tablet only)
          if (!isMobile) ...[
            for (int i = 0; i < headerItems.length; i++)
              _buildNavItem(headerItems[i], i),
            const Gap(30),
          ],

          // Social icons
          Row(
            children: [
              for (int i = 0; i < navIcons.length; i++)
                _buildSocialIcon(navIcons[i], isMobile),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(String title, int index) {
    final isActive = _currentIndex == index;

    return GestureDetector(
      onTap: () => _scrollToIndex(index),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: isActive
              ? AppColors.primaryBlue.withOpacity(0.1)
              : Colors.transparent,
        ),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
            color: isActive
                ? AppColors.primaryBlue
                : Theme.of(context).colorScheme.secondary,
          ),
        ),
      ),
    );
  }

  Widget _buildSocialIcon(Map<String, dynamic> iconData, bool isMobile) {
    return GestureDetector(
      onTap: () async {
        final url = Uri.parse(iconData['link']);
        if (await canLaunchUrl(url)) {
          launchUrl(url);
        }
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: isMobile ? 8 : 12),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.primaryBlue.withOpacity(0.1),
        ),
        child: Image.asset(
          iconData['icon'].toString(),
          width: isMobile ? 20 : 24,
          height: isMobile ? 20 : 24,
          color: Theme.of(context).colorScheme.secondary,
        ),
      ),
    );
  }

  Widget _buildMobileDrawer() {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: SafeArea(
        child: Column(
          children: [
            // Drawer header
            Container(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 25,
                    backgroundImage: AssetImage('assets/profile.png'),
                  ),
                  const Gap(15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Nabin Adhikari',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        Text(
                          'Flutter Developer',
                          style: TextStyle(
                            fontSize: 14,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const Divider(),

            // Navigation items
            for (int i = 0; i < headerItems.length; i++)
              ListTile(
                leading: Icon(
                  _getIconForIndex(i),
                  color: _currentIndex == i
                      ? AppColors.primaryBlue
                      : Theme.of(context).colorScheme.secondary,
                ),
                title: Text(
                  headerItems[i],
                  style: TextStyle(
                    color: _currentIndex == i
                        ? AppColors.primaryBlue
                        : Theme.of(context).colorScheme.primary,
                    fontWeight:
                        _currentIndex == i ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
                selected: _currentIndex == i,
                onTap: () {
                  _scrollToIndex(i);
                  Navigator.pop(context);
                },
              ),
          ],
        ),
      ),
    );
  }

  IconData _getIconForIndex(int index) {
    switch (index) {
      case 0:
        return Icons.home;
      case 1:
        return Icons.person;
      case 2:
        return Icons.code;
      case 3:
        return Icons.work;
      case 4:
        return Icons.contact_mail;
      default:
        return Icons.circle;
    }
  }

  Widget _buildNavigationIndicator() {
    return Positioned(
      right: 30,
      top: MediaQuery.of(context).size.height * 0.4,
      child: Column(
        children: [
          for (int i = 0; i < bodyItems.length; i++)
            GestureDetector(
              onTap: () => _scrollToIndex(i),
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 4),
                width: _currentIndex == i ? 30 : 12,
                height: 12,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  color: _currentIndex == i
                      ? AppColors.primaryBlue
                      : AppColors.primaryBlue.withOpacity(0.3),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildFloatingParticle(int index) {
    final random = (index * 73) % 100;
    final size = 4.0 + (random % 8);
    final left = (random * 7) % MediaQuery.of(context).size.width;
    final animationDuration = 3000 + (random * 20);

    return Positioned(
      left: left,
      top: (random * 13) % MediaQuery.of(context).size.height,
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.0, end: 1.0),
        duration: Duration(milliseconds: animationDuration),
        builder: (context, value, child) {
          return Transform.translate(
            offset: Offset(0, -value * 100),
            child: Opacity(
              opacity: (1.0 - value) * 0.6,
              child: Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primaryBlue.withOpacity(0.3),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFloatingThemeToggle(bool isMobile) {
    return Positioned(
      bottom: 30,
      right: 30,
      child: GestureDetector(
        onTap: () {
          Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
          setState(() {
            modeImg = modeImg == 'assets/sun.png'
                ? 'assets/moon.png'
                : 'assets/sun.png';
          });
        },
        child: Container(
          width: isMobile ? 50 : 60,
          height: isMobile ? 50 : 60,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: AppColors.primaryGradient,
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryBlue.withOpacity(0.3),
                blurRadius: 15,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Center(
            child: Image.asset(
              modeImg,
              width: isMobile ? 24 : 28,
              height: isMobile ? 24 : 28,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBodyWidget(int index) {
    switch (index) {
      case 0: // Home section
        return Home(
            onContactPressed: () => _scrollToIndex(4)); // 4 is contacts section
      case 1: // About Me
        return bodyItems[1];
      case 2: // Tech Stack
        return bodyItems[2];
      case 3: // Projects
        return bodyItems[3];
      case 4: // Contacts
        return bodyItems[4];
      default:
        return bodyItems[index];
    }
  }
}
