import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../theme/app_theme.dart';
import 'home_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  late PageController _controller;
  late AnimationController _fadeController;
  late AnimationController _slideController;
  int _currentPage = 0;

  final List<_OnboardingPage> _pages = const [
    _OnboardingPage(
      title: 'اكتشف آثار القاهرة',
      subtitle: 'تاريخ عريق وحضارة متجددة',
      description:
          'تجوّل في أعرق شوارع العالم الإسلامي واكتشف كنوز القاهرة التاريخية',
      icon: Icons.mosque_rounded,
      color: AppTheme.primaryBrown,
    ),
    _OnboardingPage(
      title: 'خرائط تفاعلية',
      subtitle: 'ابحث عن الأماكن بسهولة',
      description:
          'احصل على اتجاهات مباشرة لكل معلم أثري مع تفاصيل شاملة وصور عالية الجودة',
      icon: Icons.map_rounded,
      color: Color(0xFF4A7C59),
    ),
    _OnboardingPage(
      title: 'جولات سياحية',
      subtitle: 'مسارات منظمة ومُعدّة',
      description:
          'اختر من بين جولات متنوعة تأخذك في رحلة متكاملة عبر حقب تاريخية مختلفة',
      icon: Icons.tour_rounded,
      color: Color(0xFF8B4513),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _controller = PageController();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  void _goToHome() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const HomeScreen()),
    );
  }

  void _nextPage() {
    if (_currentPage == _pages.length - 1) {
      _goToHome();
    } else {
      _controller.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  void _skipOnboarding() {
    _goToHome();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // الخلفية المتدرجة (اختياري)
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.white,
                  _pages[_currentPage].color.withOpacity(0.03),
                ],
              ),
            ),
          ),

          // صفحات الـ Onboarding
          PageView.builder(
            controller: _controller,
            itemCount: _pages.length,
            onPageChanged: (i) {
              setState(() => _currentPage = i);
              _fadeController.forward(from: 0.0);
              _slideController.forward(from: 0.0);
            },
            itemBuilder: (context, i) => FadeTransition(
              opacity: _fadeController,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0.3, 0),
                  end: Offset.zero,
                ).animate(CurvedAnimation(
                  parent: _slideController,
                  curve: Curves.easeOut,
                )),
                child: _buildPage(_pages[i]),
              ),
            ),
          ),

          // الـ Indicator والـ Buttons
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.white.withOpacity(0.0),
                    Colors.white.withOpacity(1.0),
                  ],
                ),
              ),
              child: Padding(
                padding: EdgeInsets.only(
                  left: 24,
                  right: 24,
                  bottom: MediaQuery.of(context).padding.bottom + 24,
                  top: 40,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Page Indicator
                    SmoothPageIndicator(
                      controller: _controller,
                      count: _pages.length,
                      effect: ExpandingDotsEffect(
                        dotColor: Colors.grey.shade300,
                        activeDotColor: _pages[_currentPage].color,
                        dotHeight: 8,
                        dotWidth: 8,
                        spacing: 6,
                        expansionFactor: 3,
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Buttons Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Skip Button
                        if (_currentPage < _pages.length - 1)
                          GestureDetector(
                            onTap: _skipOnboarding,
                            child: Text(
                              'تخطي',
                              style: TextStyle(
                                fontFamily: 'Cairo',
                                color: Colors.grey.shade400,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          )
                        else
                          const SizedBox(width: 60),

                        // Next/Start Button
                        Material(
                          color: Colors.transparent,
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  _pages[_currentPage].color,
                                  _pages[_currentPage].color.withOpacity(0.8),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(50),
                              boxShadow: [
                                BoxShadow(
                                  color: _pages[_currentPage]
                                      .color
                                      .withOpacity(0.3),
                                  blurRadius: 16,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: _nextPage,
                                borderRadius: BorderRadius.circular(50),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 32,
                                    vertical: 12,
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        _currentPage == _pages.length - 1
                                            ? 'ابدأ الاستكشاف'
                                            : 'التالي',
                                        style: const TextStyle(
                                          fontFamily: 'Cairo',
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Icon(
                                        _currentPage == _pages.length - 1
                                            ? Icons.check_rounded
                                            : Icons.arrow_forward_rounded,
                                        color: Colors.white,
                                        size: 18,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPage(_OnboardingPage page) {
    return Container(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon Container with Animation
          ScaleTransition(
            scale: Tween<double>(begin: 0.8, end: 1.0).animate(
              CurvedAnimation(parent: _slideController, curve: Curves.easeOut),
            ),
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    page.color.withOpacity(0.15),
                    page.color.withOpacity(0.05),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: page.color.withOpacity(0.2),
                    blurRadius: 30,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Icon(
                page.icon,
                size: 110,
                color: page.color,
              ),
            ),
          ),
          const SizedBox(height: 48),

          // Title
          Text(
            page.title,
            style: TextStyle(
              fontSize: 28,
              fontFamily: 'Cairo',
              fontWeight: FontWeight.bold,
              color: page.color,
              height: 1.3,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),

          // Subtitle
          Text(
            page.subtitle,
            style: TextStyle(
              fontSize: 18,
              fontFamily: 'Cairo',
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),

          // Description
          Text(
            page.description,
            style: const TextStyle(
              fontSize: 15,
              fontFamily: 'Cairo',
              color: AppTheme.textGray,
              height: 1.7,
              fontWeight: FontWeight.w400,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _OnboardingPage {
  final String title;
  final String subtitle;
  final String description;
  final IconData icon;
  final Color color;

  const _OnboardingPage({
    required this.title,
    required this.subtitle,
    required this.description,
    required this.icon,
    required this.color,
  });
}
