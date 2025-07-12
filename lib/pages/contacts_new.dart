import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:portfolio/constants/header_items.dart';
import 'package:portfolio/utils/responsive.dart';
import 'package:portfolio/utils/app_colors.dart';
import 'package:portfolio/widgets/glass_card.dart';
import 'package:portfolio/widgets/custom_button.dart';
import 'package:url_launcher/url_launcher.dart';

class Contacts extends StatefulWidget {
  const Contacts({super.key});

  @override
  State<Contacts> createState() => _ContactsState();
}

class _ContactsState extends State<Contacts> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _formController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _messageController = TextEditingController();

  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _formController = AnimationController(
      duration: const Duration(milliseconds: 800),
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
    Future.delayed(const Duration(milliseconds: 300), () {
      _formController.forward();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _formController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    final isTablet = Responsive.isTablet(context);

    return Container(
      height: MediaQuery.of(context).size.height,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 20 : 40,
        vertical: 40,
      ),
      child: Column(
        children: [
          // Header
          _buildHeader(isMobile),

          const Gap(60),

          // Content
          Expanded(
            child: isMobile
                ? _buildMobileLayout()
                : isTablet
                    ? _buildTabletLayout()
                    : _buildDesktopLayout(),
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
        opacity: _fadeAnimation,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
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
                  'Get In Touch',
                  style: GoogleFonts.poppins(
                    fontSize: isMobile ? 28 : 42,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
            const Gap(20),
            Text(
              'Have a project in mind? Let\'s work together to bring your ideas to life!',
              textAlign: TextAlign.center,
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

  Widget _buildMobileLayout() {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildContactInfo(true),
          const Gap(40),
          _buildContactForm(true),
        ],
      ),
    );
  }

  Widget _buildTabletLayout() {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildContactInfo(false),
          const Gap(40),
          _buildContactForm(false),
        ],
      ),
    );
  }

  Widget _buildDesktopLayout() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Contact info
        Expanded(
          flex: 2,
          child: _buildContactInfo(false),
        ),

        const Gap(60),

        // Contact form
        Expanded(
          flex: 3,
          child: _buildContactForm(false),
        ),
      ],
    );
  }

  Widget _buildContactInfo(bool isMobile) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: Column(
              crossAxisAlignment: isMobile
                  ? CrossAxisAlignment.center
                  : CrossAxisAlignment.start,
              children: [
                if (!isMobile) ...[
                  Text(
                    'Let\'s Connect',
                    style: GoogleFonts.poppins(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const Gap(20),
                  Text(
                    'I\'m always open to discussing new opportunities and interesting projects.',
                    style: GoogleFonts.dmSans(
                      fontSize: 16,
                      color: Theme.of(context).colorScheme.secondary,
                      height: 1.6,
                    ),
                  ),
                  const Gap(40),
                ],

                // Contact methods
                _buildContactMethod(
                  icon: Icons.email,
                  title: 'Email',
                  subtitle: 'modrn153@gmail.com',
                  onTap: () => _launchEmail(),
                  isMobile: isMobile,
                ),

                const Gap(20),

                _buildContactMethod(
                  icon: Icons.phone,
                  title: 'Phone',
                  subtitle: '+977 98XXXXXXXX',
                  onTap: () => _showPhoneDialog(),
                  isMobile: isMobile,
                ),

                const Gap(20),

                _buildContactMethod(
                  icon: Icons.location_on,
                  title: 'Location',
                  subtitle: 'Pokhara, Nepal',
                  onTap: () {},
                  isMobile: isMobile,
                ),

                const Gap(40),

                // Social links
                Text(
                  'Follow Me',
                  style: GoogleFonts.poppins(
                    fontSize: isMobile ? 18 : 20,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),

                const Gap(20),

                Row(
                  mainAxisAlignment: isMobile
                      ? MainAxisAlignment.center
                      : MainAxisAlignment.start,
                  children: [
                    for (int i = 0; i < navIcons.length; i++) ...[
                      _buildSocialIcon(navIcons[i], isMobile),
                      if (i < navIcons.length - 1) const Gap(15),
                    ],
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildContactMethod({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    required bool isMobile,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: GlassCard(
        padding: EdgeInsets.all(isMobile ? 16 : 20),
        child: Row(
          children: [
            Container(
              width: isMobile ? 50 : 60,
              height: isMobile ? 50 : 60,
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: Colors.white,
                size: isMobile ? 24 : 28,
              ),
            ),
            const Gap(20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: isMobile ? 16 : 18,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const Gap(4),
                  Text(
                    subtitle,
                    style: GoogleFonts.dmSans(
                      fontSize: isMobile ? 14 : 16,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                ],
              ),
            ),
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

  Widget _buildSocialIcon(Map<String, dynamic> iconData, bool isMobile) {
    return GestureDetector(
      onTap: () => _launchURL(iconData['link']),
      child: Container(
        width: isMobile ? 50 : 60,
        height: isMobile ? 50 : 60,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.primaryBlue.withOpacity(0.1),
          border: Border.all(
            color: AppColors.primaryBlue.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Center(
          child: Image.asset(
            iconData['icon'].toString(),
            width: isMobile ? 24 : 28,
            height: isMobile ? 24 : 28,
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
      ),
    );
  }

  Widget _buildContactForm(bool isMobile) {
    return AnimatedBuilder(
      animation: _formController,
      builder: (context, child) {
        return FadeTransition(
          opacity: _formController,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.3, 0),
              end: Offset.zero,
            ).animate(_formController),
            child: GlassCard(
              padding: EdgeInsets.all(isMobile ? 20 : 30),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Send me a message',
                      style: GoogleFonts.poppins(
                        fontSize: isMobile ? 20 : 24,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),

                    const Gap(30),

                    // Name field
                    _buildFormField(
                      controller: _nameController,
                      label: 'Your Name',
                      hint: 'Enter your full name',
                      icon: Icons.person,
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'Please enter your name';
                        }
                        return null;
                      },
                    ),

                    const Gap(20),

                    // Email field
                    _buildFormField(
                      controller: _emailController,
                      label: 'Email Address',
                      hint: 'Enter your email',
                      icon: Icons.email,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'Please enter your email';
                        }
                        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                            .hasMatch(value!)) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),

                    const Gap(20),

                    // Message field
                    _buildFormField(
                      controller: _messageController,
                      label: 'Message',
                      hint: 'Tell me about your project...',
                      icon: Icons.message,
                      maxLines: 5,
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'Please enter your message';
                        }
                        if (value!.length < 10) {
                          return 'Message should be at least 10 characters';
                        }
                        return null;
                      },
                    ),

                    const Gap(30),

                    // Submit button
                    SizedBox(
                      width: double.infinity,
                      child: CustomButton(
                        text: _isSubmitting ? 'Sending...' : 'Send Message',
                        isGradient: true,
                        height: 50,
                        icon: _isSubmitting ? null : Icons.send,
                        onPressed: _isSubmitting ? null : _submitForm,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildFormField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        const Gap(8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, color: AppColors.primaryBlue),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: AppColors.primaryBlue.withOpacity(0.3),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: AppColors.primaryBlue.withOpacity(0.3),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: AppColors.primaryBlue,
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: AppColors.error,
              ),
            ),
            filled: true,
            fillColor: Theme.of(context).colorScheme.surface.withOpacity(0.5),
            hintStyle: GoogleFonts.dmSans(
              color: Theme.of(context).colorScheme.secondary.withOpacity(0.7),
            ),
          ),
          style: GoogleFonts.dmSans(
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ],
    );
  }

  void _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isSubmitting = true);

      // Simulate form submission
      await Future.delayed(const Duration(seconds: 2));

      setState(() => _isSubmitting = false);

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Message sent successfully! I\'ll get back to you soon.',
            style: GoogleFonts.dmSans(color: Colors.white),
          ),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );

      // Clear form
      _nameController.clear();
      _emailController.clear();
      _messageController.clear();
    }
  }

  void _launchEmail() async {
    final uri = Uri.parse('mailto:modrn153@gmail.com');
    if (await canLaunchUrl(uri)) {
      launchUrl(uri);
    }
  }

  void _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      launchUrl(uri);
    }
  }

  void _showPhoneDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Contact Information',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Phone: +977 98XXXXXXXX',
              style: GoogleFonts.dmSans(),
            ),
            const Gap(10),
            Text(
              'You can also reach me via email for faster response.',
              style: GoogleFonts.dmSans(
                color: Theme.of(context).colorScheme.secondary,
                fontSize: 14,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Clipboard.setData(const ClipboardData(text: '+977 98XXXXXXXX'));
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Phone number copied to clipboard')),
              );
            },
            child: const Text('Copy'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
