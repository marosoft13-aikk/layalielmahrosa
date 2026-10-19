import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme/app_theme.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..forward();
    _fadeAnim = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _launch(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) launchUrl(uri);
  }

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('تم النسخ!', style: TextStyle(fontFamily: 'Cairo')),
        backgroundColor: AppTheme.primaryBrown,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.darkBrown,
      body: Stack(
        children: [
          // Background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF1A0800),
                  Color(0xFF2C1200),
                  Color(0xFF0D0500)
                ],
              ),
            ),
          ),

          // Glow
          Positioned(
            top: -60,
            right: -60,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppTheme.goldAccent.withOpacity(0.07),
              ),
            ),
          ),

          SafeArea(
            child: FadeTransition(
              opacity: _fadeAnim,
              child: CustomScrollView(
                slivers: [
                  // App Bar
                  SliverAppBar(
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    leading: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        margin: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                              color: AppTheme.goldAccent.withOpacity(0.2)),
                        ),
                        child: const Icon(Icons.arrow_forward_ios_rounded,
                            color: Colors.white, size: 16),
                      ),
                    ),
                    title: const Text(
                      'عن التطبيق',
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    centerTitle: true,
                    pinned: true,
                  ),

                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          const SizedBox(height: 20),

                          // ── App Hero Section
                          _AppHeroCard(),

                          const SizedBox(height: 24),

                          // ── App Description
                          _SectionCard(
                            title: 'عن التطبيق',
                            subtitle: 'About the App',
                            child: Column(
                              children: [
                                _InfoText(
                                  'تطبيق **ليالي المحروسة** هو دليلك الشامل لاستكشاف الآثار الإسلامية والقبطية في القاهرة التاريخية. يضم أكثر من 80 معلماً أثرياً مع معلومات تاريخية دقيقة وصور عالية الجودة وخرائط تفاعلية.',
                                ),
                                const SizedBox(height: 12),
                                _InfoText(
                                  '**Layali Al-Mahrosa** is your comprehensive guide to explore Islamic and Coptic monuments in historic Cairo. Featuring 80+ landmarks with detailed historical info, photos, and interactive maps.',
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 16),

                          // ── Features
                          _SectionCard(
                            title: 'مميزات التطبيق',
                            subtitle: 'App Features',
                            child: Column(
                              children: const [
                                _FeatureRow(
                                    icon: Icons.place_rounded,
                                    text:
                                        'أكثر من 80 معلم أثري موثق / 80+ Documented Landmarks'),
                                _FeatureRow(
                                    icon: Icons.map_rounded,
                                    text:
                                        'خرائط تفاعلية وإرشادات / Interactive Maps & Navigation'),
                                _FeatureRow(
                                    icon: Icons.tour_rounded,
                                    text:
                                        'جولات سياحية منظمة / Organized Tours'),
                                _FeatureRow(
                                    icon: Icons.volume_up_rounded,
                                    text: 'دليل صوتي / Audio Guide'),
                                _FeatureRow(
                                    icon: Icons.favorite_rounded,
                                    text: 'حفظ المفضلة / Save Favorites'),
                                _FeatureRow(
                                    icon: Icons.language_rounded,
                                    text:
                                        'دعم العربية والإنجليزية / Arabic & English Support'),
                              ],
                            ),
                          ),

                          const SizedBox(height: 16),

                          // ── Developer Card
                          _PersonCard(
                            name: 'مروان أحمد',
                            nameEn: 'Mrwan Ahmed',
                            role: 'مطور التطبيق',
                            roleEn: 'App Developer',
                            icon: Icons.code_rounded,
                            color: const Color(0xFF1565C0),
                            contacts: [
                              _ContactItem(
                                icon: Icons.phone_rounded,
                                label: '01026842005',
                                value: 'tel:+201026842005',
                                onCopy: '01026842005',
                              ),
                              _ContactItem(
                                icon: Icons.camera_alt_rounded,
                                label: '@mrwan-ahmed-1',
                                value: 'https://instagram.com/mrwan-ahmed-1',
                                onCopy: '@mrwan-ahmed-1',
                              ),
                              _ContactItem(
                                icon: Icons.email_rounded,
                                label: 'marosot13@gmail.com',
                                value: 'mailto:marosot13@gmail.com',
                                onCopy: 'marosot13@gmail.com',
                              ),
                            ],
                            onContact: _launch,
                            onCopy: _copyToClipboard,
                          ),

                          const SizedBox(height: 16),

                          // ── Founder Card
                          _PersonCard(
                            name: 'محمد السيد',
                            nameEn: 'Mohamed El-Sayed',
                            role: 'مؤسس ليالي المحروسة',
                            roleEn: 'Founder of Layali Al-Mahrosa',
                            icon: Icons.history_edu_rounded,
                            color: const Color(0xFF6D4C41),
                            contacts: [],
                            onContact: _launch,
                            onCopy: _copyToClipboard,
                            extraBadge:
                                'باحث في التراث المصري\nEgyptian Heritage Researcher',
                          ),

                          const SizedBox(height: 16),

                          // ── App version & copyright
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.05),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                  color: AppTheme.goldAccent.withOpacity(0.1)),
                            ),
                            child: Column(
                              children: [
                                Container(
                                  width: 48,
                                  height: 48,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: const RadialGradient(
                                      colors: [
                                        Color(0xFF8B6914),
                                        Color(0xFFC8A96E),
                                      ],
                                    ),
                                  ),
                                  child: const Icon(Icons.mosque_rounded,
                                      color: Colors.white, size: 26),
                                ),
                                const SizedBox(height: 10),
                                ShaderMask(
                                  shaderCallback: (b) => const LinearGradient(
                                    colors: [
                                      Color(0xFFE8C97A),
                                      Color(0xFFC8A96E)
                                    ],
                                  ).createShader(b),
                                  child: const Text(
                                    'ليالي المحروسة',
                                    style: TextStyle(
                                      fontFamily: 'Cairo',
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'الإصدار 1.0.0  /  Version 1.0.0',
                                  style: TextStyle(
                                    fontFamily: 'Cairo',
                                    fontSize: 12,
                                    color: Colors.white.withOpacity(0.4),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '© 2026 ليالي المحروسة — جميع الحقوق محفوظة\nAll Rights Reserved',
                                  style: TextStyle(
                                    fontFamily: 'Cairo',
                                    fontSize: 11,
                                    color: Colors.white.withOpacity(0.3),
                                    height: 1.6,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 40),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── App Hero Card ───
class _AppHeroCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            AppTheme.primaryBrown.withOpacity(0.6),
            AppTheme.darkBrown.withOpacity(0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppTheme.goldAccent.withOpacity(0.25)),
        boxShadow: [
          BoxShadow(
            color: AppTheme.goldAccent.withOpacity(0.15),
            blurRadius: 30,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const RadialGradient(
                colors: [Color(0xFF8B6914), Color(0xFFC8A96E)],
              ),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.goldAccent.withOpacity(0.5),
                  blurRadius: 24,
                  spreadRadius: 4,
                ),
              ],
            ),
            child:
                const Icon(Icons.mosque_rounded, size: 44, color: Colors.white),
          ),
          const SizedBox(height: 16),
          ShaderMask(
            shaderCallback: (b) => const LinearGradient(
              colors: [Color(0xFFE8C97A), Color(0xFFF0D898), Color(0xFFC8A96E)],
            ).createShader(b),
            child: const Text(
              'ليالي المحروسة',
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 1,
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Layali Al-Mahrosa',
            style: TextStyle(
              fontSize: 13,
              letterSpacing: 3,
              color: AppTheme.goldAccent.withOpacity(0.65),
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: AppTheme.goldAccent.withOpacity(0.12),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppTheme.goldAccent.withOpacity(0.3)),
            ),
            child: const Text(
              'دليل آثار القاهرة التاريخية',
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 12,
                color: AppTheme.goldAccent,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Section Card ───
class _SectionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget child;

  const _SectionCard({
    required this.title,
    required this.subtitle,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.goldAccent.withOpacity(0.12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
            child: Row(
              children: [
                Container(
                  width: 3,
                  height: 20,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xFFE8C97A), Color(0xFFC8A96E)],
                    ),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 11,
                        color: AppTheme.goldAccent.withOpacity(0.6),
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Divider(color: AppTheme.goldAccent.withOpacity(0.1), height: 1),
          Padding(
            padding: const EdgeInsets.all(20),
            child: child,
          ),
        ],
      ),
    );
  }
}

// ─── Person Card ───
class _PersonCard extends StatelessWidget {
  final String name;
  final String nameEn;
  final String role;
  final String roleEn;
  final IconData icon;
  final Color color;
  final List<_ContactItem> contacts;
  final Function(String) onContact;
  final Function(String) onCopy;
  final String? extraBadge;

  const _PersonCard({
    required this.name,
    required this.nameEn,
    required this.role,
    required this.roleEn,
    required this.icon,
    required this.color,
    required this.contacts,
    required this.onContact,
    required this.onCopy,
    this.extraBadge,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.25)),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [color.withOpacity(0.2), color.withOpacity(0.05)],
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.15),
                    shape: BoxShape.circle,
                    border: Border.all(color: color.withOpacity(0.4)),
                  ),
                  child: Icon(icon, color: color, size: 28),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        nameEn,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white.withOpacity(0.45),
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 3),
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          role,
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 11,
                            color: color.withOpacity(0.9),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          if (extraBadge != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: color.withOpacity(0.2)),
                ),
                child: Text(
                  extraBadge!,
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 12,
                    color: Colors.white.withOpacity(0.7),
                    height: 1.6,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),

          if (contacts.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: contacts
                    .map((c) => Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: _ContactRow(
                            item: c,
                            onTap: () => onContact(c.value),
                            onCopy: () => onCopy(c.onCopy),
                          ),
                        ))
                    .toList(),
              ),
            )
          else
            const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _ContactRow extends StatelessWidget {
  final _ContactItem item;
  final VoidCallback onTap;
  final VoidCallback onCopy;

  const _ContactRow({
    required this.item,
    required this.onTap,
    required this.onCopy,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.goldAccent.withOpacity(0.12)),
        ),
        child: Row(
          children: [
            Icon(item.icon, color: AppTheme.goldAccent, size: 18),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                item.label,
                style: const TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 13,
                  color: Colors.white,
                ),
              ),
            ),
            GestureDetector(
              onTap: onCopy,
              child: Icon(
                Icons.copy_rounded,
                color: AppTheme.goldAccent.withOpacity(0.5),
                size: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ContactItem {
  final IconData icon;
  final String label;
  final String value;
  final String onCopy;

  const _ContactItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.onCopy,
  });
}

class _FeatureRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _FeatureRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: AppTheme.goldAccent.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: AppTheme.goldAccent, size: 16),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 12,
                color: Colors.white.withOpacity(0.75),
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoText extends StatelessWidget {
  final String text;
  const _InfoText(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text.replaceAll('**', ''),
      style: TextStyle(
        fontFamily: 'Cairo',
        fontSize: 13,
        color: Colors.white.withOpacity(0.65),
        height: 1.7,
      ),
      textAlign: TextAlign.justify,
    );
  }
}
