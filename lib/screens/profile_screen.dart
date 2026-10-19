// ============================================================
// profile_screen.dart
// ============================================================
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
// map_screen.dart يحتاج أيضًا:
import '../data/monuments_data.dart';
import '../models/monument_model.dart';
import 'monument_detail_screen.dart';
import 'about_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgColor,
      appBar: AppBar(
        title: const Text('الملف الشخصي'),
        backgroundColor: AppTheme.primaryBrown,
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 8),
            // Avatar
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppTheme.goldAccent, width: 3),
                color: AppTheme.lightCream,
              ),
              child: const Icon(Icons.person_rounded,
                  size: 60, color: AppTheme.primaryBrown),
            ),
            const SizedBox(height: 12),
            const Text('زائر القاهرة',
                style: TextStyle(
                    fontFamily: 'Cairo',
                    fontWeight: FontWeight.bold,
                    fontSize: 20)),
            const Text('مستكشف التراث الإسلامي',
                style:
                    TextStyle(fontFamily: 'Cairo', color: AppTheme.textGray)),
            const SizedBox(height: 24),
            // Stats
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _StatCard(
                    label: 'زيارات', value: '0', icon: Icons.place_rounded),
                _StatCard(
                    label: 'مفضلة', value: '0', icon: Icons.favorite_rounded),
                _StatCard(label: 'جولات', value: '0', icon: Icons.tour_rounded),
              ],
            ),
            const SizedBox(height: 24),
            // Menu Items
            _MenuItem(
                icon: Icons.language_rounded,
                title: 'اللغة',
                subtitle: 'العربية - عربي',
                onTap: () {}),
            _MenuItem(
                icon: Icons.notifications_rounded,
                title: 'الإشعارات',
                subtitle: 'مفعّلة',
                onTap: () {}),
            _MenuItem(
                icon: Icons.info_rounded,
                title: 'عن التطبيق',
                subtitle: 'آثار القاهرة v1.0.0',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const AboutScreen(),
                    ),
                  );
                }),
            _MenuItem(
                icon: Icons.share_rounded,
                title: 'شارك التطبيق',
                subtitle: 'ادعُ أصدقاءك لاكتشاف القاهرة',
                onTap: () {}),
            _MenuItem(
                icon: Icons.star_rounded,
                title: 'قيّم التطبيق',
                subtitle: 'أعطنا رأيك',
                onTap: () {}),
            const SizedBox(height: 40),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.primaryBrown.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.dividerColor),
              ),
              child: Row(
                children: [
                  const Icon(Icons.mosque_rounded,
                      color: AppTheme.primaryBrown),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('آثار القاهرة',
                            style: TextStyle(
                                fontFamily: 'Cairo',
                                fontWeight: FontWeight.bold)),
                        Text('دليل شامل للآثار الإسلامية والقبطية في القاهرة',
                            style: TextStyle(
                                fontFamily: 'Cairo',
                                fontSize: 11,
                                color: AppTheme.textGray)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  const _StatCard(
      {required this.label, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8)
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: AppTheme.primaryBrown),
          const SizedBox(height: 8),
          Text(value,
              style: const TextStyle(
                  fontFamily: 'Cairo',
                  fontWeight: FontWeight.bold,
                  fontSize: 22)),
          Text(label,
              style: const TextStyle(
                  fontFamily: 'Cairo', fontSize: 12, color: AppTheme.textGray)),
        ],
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  const _MenuItem(
      {required this.icon,
      required this.title,
      required this.subtitle,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 6)
        ],
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppTheme.primaryBrown.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: AppTheme.primaryBrown, size: 20),
        ),
        title: Text(title,
            style: const TextStyle(
                fontFamily: 'Cairo', fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle,
            style: const TextStyle(
                fontFamily: 'Cairo', fontSize: 12, color: AppTheme.textGray)),
        trailing: const Icon(Icons.arrow_back_ios_rounded,
            size: 14, color: AppTheme.textGray),
        onTap: onTap,
      ),
    );
  }
}
