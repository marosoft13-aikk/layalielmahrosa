import 'package:flutter/material.dart';
import 'dart:async';
import 'onboarding_screen.dart';
import '../theme/app_theme.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _scaleController;
  late AnimationController _rotateController;
  late AnimationController _particleController;

  late Animation<double> _fadeAnim;
  late Animation<double> _scaleAnim;
  late Animation<double> _rotateAnim;
  late Animation<double> _particleAnim;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _navigateToOnboarding();
  }

  void _initializeAnimations() {
    // Fade Animation
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _fadeAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _fadeController, curve: const Interval(0, 0.5)),
    );

    // Scale Animation
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _scaleAnim = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeOutCubic),
    );

    // Rotation Animation
    _rotateController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );
    _rotateAnim = Tween<double>(begin: -0.1, end: 0.1).animate(
      CurvedAnimation(parent: _rotateController, curve: Curves.easeInOutSine),
    );
    _rotateController.repeat(reverse: true);

    // Particle Animation
    _particleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    );
    _particleAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _particleController, curve: Curves.easeInOut),
    );
    _particleController.repeat(reverse: true);

    // Start animations
    _fadeController.forward();
    _scaleController.forward();
  }

  void _navigateToOnboarding() {
    Timer(const Duration(seconds: 4), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                const LoginScreen(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
            transitionDuration: const Duration(milliseconds: 800),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _scaleController.dispose();
    _rotateController.dispose();
    _particleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryBrown,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppTheme.darkBrown,
              AppTheme.primaryBrown,
              AppTheme.primaryBrown.withOpacity(0.95),
            ],
            stops: const [0.0, 0.5, 1.0],
          ),
        ),
        child: Stack(
          children: [
            // Animated Background Particles
            _buildParticleBackground(),

            // Main Content
            Center(
              child: FadeTransition(
                opacity: _fadeAnim,
                child: ScaleTransition(
                  scale: _scaleAnim,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Logo with animations
                      _buildAnimatedLogo(),
                      const SizedBox(height: 32),

                      // Title with staggered animation
                      _buildTitle(),
                      const SizedBox(height: 12),

                      // Subtitle
                      _buildSubtitle(),
                      const SizedBox(height: 64),

                      // Loading indicator
                      _buildLoadingIndicator(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildParticleBackground() {
    return AnimatedBuilder(
      animation: _particleAnim,
      builder: (context, child) {
        return Opacity(
          opacity: 0.1,
          child: Stack(
            children: [
              Positioned(
                top: 50 + (_particleAnim.value * 30),
                left: 30,
                child: Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppTheme.goldAccent,
                  ),
                ),
              ),
              Positioned(
                top: 100 - (_particleAnim.value * 40),
                right: 60,
                child: Container(
                  width: 4,
                  height: 4,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppTheme.goldAccent,
                  ),
                ),
              ),
              Positioned(
                bottom: 150 + (_particleAnim.value * 50),
                left: 80,
                child: Container(
                  width: 5,
                  height: 5,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppTheme.goldAccent,
                  ),
                ),
              ),
              Positioned(
                bottom: 200 - (_particleAnim.value * 60),
                right: 40,
                child: Container(
                  width: 4,
                  height: 4,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppTheme.goldAccent,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAnimatedLogo() {
    return AnimatedBuilder(
      animation: _rotateAnim,
      builder: (context, child) {
        return Transform.rotate(
          angle: _rotateAnim.value,
          child: Container(
            width: 140,
            height: 140,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppTheme.goldAccent.withOpacity(0.3),
                  AppTheme.goldAccent.withOpacity(0.1),
                ],
              ),
              border: Border.all(
                color: AppTheme.goldAccent.withOpacity(0.8),
                width: 2.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.goldAccent.withOpacity(0.4),
                  blurRadius: 30,
                  spreadRadius: 2,
                ),
                BoxShadow(
                  color: AppTheme.goldAccent.withOpacity(0.2),
                  blurRadius: 60,
                  spreadRadius: 8,
                ),
              ],
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Inner circle border
                Container(
                  width: 110,
                  height: 110,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppTheme.goldAccent.withOpacity(0.4),
                      width: 1,
                    ),
                  ),
                ),
                // Icon
                Icon(
                  Icons.mosque_rounded,
                  size: 80,
                  color: AppTheme.goldAccent,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTitle() {
    return Column(
      children: [
        ShaderMask(
          shaderCallback: (bounds) => LinearGradient(
            colors: [
              Colors.white,
              AppTheme.goldAccent.withOpacity(0.8),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ).createShader(bounds),
          child: const Text(
            'آثار القاهرة',
            style: TextStyle(
              fontSize: 42,
              fontFamily: 'Cairo',
              fontWeight: FontWeight.w900,
              color: Colors.white,
              letterSpacing: 0.5,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSubtitle() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.goldAccent.withOpacity(0.2),
            AppTheme.goldAccent.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppTheme.goldAccent.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Text(
        'اكتشف تاريخ أمجادك',
        style: TextStyle(
          fontSize: 17,
          fontFamily: 'Cairo',
          color: AppTheme.goldAccent.withOpacity(0.95),
          fontWeight: FontWeight.w500,
          letterSpacing: 0.3,
        ),
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Column(
      children: [
        // Animated circular progress with gradient
        SizedBox(
          width: 56,
          height: 56,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Outer rotating circle
              RotationTransition(
                turns: Tween(begin: 0.0, end: 1.0).animate(
                  CurvedAnimation(
                      parent: _rotateController, curve: Curves.linear),
                ),
                child: Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: SweepGradient(
                      colors: [
                        AppTheme.goldAccent.withOpacity(0.8),
                        AppTheme.goldAccent.withOpacity(0.2),
                        AppTheme.goldAccent.withOpacity(0.8),
                      ],
                    ),
                  ),
                ),
              ),
              // Inner circle (background)
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppTheme.primaryBrown,
                ),
              ),
              // Center icon
              Icon(
                Icons.hourglass_bottom_rounded,
                color: AppTheme.goldAccent.withOpacity(0.7),
                size: 24,
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        // Loading text
        Text(
          'جاري التحميل...',
          style: TextStyle(
            fontFamily: 'Cairo',
            fontSize: 14,
            color: AppTheme.goldAccent.withOpacity(0.7),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
