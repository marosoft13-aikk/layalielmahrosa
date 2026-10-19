import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_theme.dart';
import 'main_tab.dart';
import 'map_screen.dart';
import 'favorites_screen.dart';
import 'tours_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  int _currentIndex = 0;
  int _previousIndex = 0;
  late AnimationController _transitionController;

  final List<Widget> _screens = const [
    MainTab(),
    MapScreen(),
    FavoritesScreen(),
    ToursScreen(),
    ProfileScreen(),
  ];

  final List<_NavItem> _navItems = const [
    _NavItem(
      icon: Icons.home_rounded,
      activeIcon: Icons.home_rounded,
      label: 'الرئيسية',
      color: AppTheme.primaryBrown,
    ),
    _NavItem(
      icon: Icons.map_outlined,
      activeIcon: Icons.map_rounded,
      label: 'الخريطة',
      color: Color(0xFF2E7D32),
    ),
    _NavItem(
      icon: Icons.favorite_border_rounded,
      activeIcon: Icons.favorite_rounded,
      label: 'المفضلة',
      color: Color(0xFFD32F2F),
    ),
    _NavItem(
      icon: Icons.explore_outlined,
      activeIcon: Icons.explore_rounded,
      label: 'الجولات',
      color: Color(0xFF6D4C41),
    ),
    _NavItem(
      icon: Icons.person_outline_rounded,
      activeIcon: Icons.person_rounded,
      label: 'الملف',
      color: Color(0xFF4527A0),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _transitionController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 380),
    )..forward();
  }

  @override
  void dispose() {
    _transitionController.dispose();
    super.dispose();
  }

  void _onTabTapped(int index) {
    if (index == _currentIndex) return;
    HapticFeedback.lightImpact();
    setState(() {
      _previousIndex = _currentIndex;
      _currentIndex = index;
    });
    _transitionController.forward(from: 0.0);
  }

  @override
  Widget build(BuildContext context) {
    final activeColor = _navItems[_currentIndex].color;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
      ),
      child: Scaffold(
        backgroundColor: AppTheme.bgColor,
        extendBody: true,
        body: Stack(
          children: [
            // خلفية متدرجة بتتغير بهدوء حسب لون التاب النشط
            AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    activeColor.withOpacity(0.06),
                    AppTheme.bgColor,
                    AppTheme.bgColor,
                  ],
                  stops: const [0.0, 0.35, 1.0],
                ),
              ),
            ),
            // شكل زخرفي دائري خفيف في الأعلى
            Positioned(
              top: -80,
              right: -60,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                width: 220,
                height: 220,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      activeColor.withOpacity(0.10),
                      activeColor.withOpacity(0.0),
                    ],
                  ),
                ),
              ),
            ),
            // محتوى الصفحات مع انتقال fade + slide + scale
            AnimatedBuilder(
              animation: _transitionController,
              builder: (context, child) {
                final curved = CurvedAnimation(
                  parent: _transitionController,
                  curve: Curves.easeOutCubic,
                );
                return Opacity(
                  opacity: curved.value,
                  child: Transform.translate(
                    offset: Offset(0, 18 * (1 - curved.value)),
                    child: Transform.scale(
                      scale: 0.98 + (0.02 * curved.value),
                      child: child,
                    ),
                  ),
                );
              },
              child: IndexedStack(
                index: _currentIndex,
                children: _screens,
              ),
            ),
          ],
        ),
        bottomNavigationBar: _FloatingNavBar(
          currentIndex: _currentIndex,
          items: _navItems,
          onTap: _onTabTapped,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Floating Nav Bar — Glassmorphism + Sliding Indicator
// ─────────────────────────────────────────────
class _FloatingNavBar extends StatelessWidget {
  final int currentIndex;
  final List<_NavItem> items;
  final ValueChanged<int> onTap;

  static const double _barHeight = 74;

  const _FloatingNavBar({
    required this.currentIndex,
    required this.items,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).padding.bottom;
    final activeColor = items[currentIndex].color;

    return Container(
      margin: EdgeInsets.only(left: 16, right: 16, bottom: bottom + 12),
      height: _barHeight,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: activeColor.withOpacity(0.22),
            blurRadius: 28,
            spreadRadius: -4,
            offset: const Offset(0, 10),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.82),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: Colors.white.withOpacity(0.6),
                width: 1,
              ),
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final itemWidth = constraints.maxWidth / items.length;
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    AnimatedPositioned(
                      duration: const Duration(milliseconds: 380),
                      curve: Curves.easeOutBack,
                      left: itemWidth * currentIndex + itemWidth * 0.14,
                      top: 10,
                      width: itemWidth * 0.72,
                      height: _barHeight - 20,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              activeColor.withOpacity(0.16),
                              activeColor.withOpacity(0.05),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(22),
                        ),
                      ),
                    ),
                    Row(
                      children: List.generate(
                        items.length,
                        (i) => Expanded(
                          child: _NavBarItem(
                            item: items[i],
                            isActive: i == currentIndex,
                            onTap: () => onTap(i),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Single Nav Item
// ─────────────────────────────────────────────
class _NavBarItem extends StatelessWidget {
  final _NavItem item;
  final bool isActive;
  final VoidCallback onTap;

  const _NavBarItem({
    required this.item,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        height: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: isActive ? 1 : 0),
              duration: const Duration(milliseconds: 320),
              curve: Curves.easeOutBack,
              builder: (context, value, child) {
                return Transform.translate(
                  offset: Offset(0, -4 * value),
                  child: Transform.scale(
                    scale: 1 + (0.18 * value),
                    child: child,
                  ),
                );
              },
              child: Icon(
                isActive ? item.activeIcon : item.icon,
                size: 22,
                color: isActive ? item.color : Colors.grey.shade400,
              ),
            ),
            const SizedBox(height: 4),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 250),
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: isActive ? 10.5 : 9.5,
                fontWeight: isActive ? FontWeight.w800 : FontWeight.w500,
                color: isActive ? item.color : Colors.grey.shade400,
              ),
              child: Text(
                item.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Data class
// ─────────────────────────────────────────────
class _NavItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final Color color;

  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.color,
  });
}
