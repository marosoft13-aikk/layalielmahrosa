import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../data/monuments_data.dart';
import '../models/monument_model.dart';
import '../providers/favorites_provider.dart';
import 'monument_detail_screen.dart';
import 'category_screen.dart';
import 'video_player_screen.dart';

class MainTab extends StatefulWidget {
  const MainTab({super.key});

  @override
  State<MainTab> createState() => _MainTabState();
}

class _MainTabState extends State<MainTab> with SingleTickerProviderStateMixin {
  final _searchController = TextEditingController();
  List<Monument> _searchResults = [];
  bool _isSearching = false;

  late AnimationController _entrance;

  // بيانات الفيديوهات
  final List<Map<String, dynamic>> videos = [
    {
      'title': 'جولة في المسجد الأزهر',
      'thumbnail': 'assets/images/al_azhar.jpg',
      'url': 'https://youtu.be/XOum01YTRY4?si=9hJ2zDlGeC8lw2gQ',
      'duration': '12:45',
      'views': '15.2K',
    },
    {
      'title': 'معالم القاهرة الإسلامية',
      'thumbnail': 'assets/images/malem_cairo.jpg',
      'url': 'https://example.com/video2.mp4',
      'duration': '8:30',
      'views': '8.9K',
    },
    {
      'title': 'تاريخ الأهرامات',
      'thumbnail': 'assets/images/pyramids.jpg',
      'url': 'https://example.com/video3.mp4',
      'duration': '15:20',
      'views': '42.1K',
    },
    {
      'title': 'المتحف المصري الكبير',
      'thumbnail': 'assets/images/egyptian_museum.jpg',
      'url': 'https://example.com/video4.mp4',
      'duration': '10:15',
      'views': '12.5K',
    },
  ];

  @override
  void initState() {
    super.initState();
    _entrance = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..forward();
  }

  @override
  void dispose() {
    _entrance.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearch(String query) {
    if (query.isEmpty) {
      setState(() {
        _isSearching = false;
        _searchResults = [];
      });
    } else {
      setState(() {
        _isSearching = true;
        _searchResults = MonumentsData.search(query);
      });
    }
  }

  String get _greeting {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'اهلا بك في☀️';
    if (hour < 17) return 'نهارك سعيد 🌤️';
    if (hour < 20) return 'مساء الخير 🌇';
    return 'مساء الأنس 🌙';
  }

  Animation<double> _stagger(double start, double end) {
    return CurvedAnimation(
      parent: _entrance,
      curve: Interval(start, end, curve: Curves.easeOutCubic),
    );
  }

  Widget _animatedSection(
      {required double start, required double end, required Widget child}) {
    final anim = _stagger(start, end);
    return AnimatedBuilder(
      animation: anim,
      builder: (context, c) => Opacity(
        opacity: anim.value.clamp(0, 1),
        child: Transform.translate(
          offset: Offset(0, 24 * (1 - anim.value)),
          child: c,
        ),
      ),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgColor,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildAppBar(),
          if (_isSearching)
            _buildSearchResults()
          else ...[
            _buildNearestSection(),
            _buildVideoSection(),
            _buildCategoriesSection(),
            _buildFeaturedSection(),
            const SliverToBoxAdapter(child: SizedBox(height: 24)),
          ],
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────
  // App Bar — Curved navy header + floating search card
  // ─────────────────────────────────────────────
  Widget _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 232,
      floating: false,
      pinned: true,
      backgroundColor: AppTheme.midnightBlue,
      elevation: 0,
      flexibleSpace: FlexibleSpaceBar(
        background: ClipPath(
          clipper: _HeaderClipper(),
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppTheme.deepNavy, AppTheme.midnightBlue],
              ),
            ),
            child: Stack(
              children: [
                // زخارف دائرية شفافة
                Positioned(
                  top: -40,
                  left: -30,
                  child: Container(
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppTheme.goldAccent.withOpacity(0.10),
                    ),
                  ),
                ),
                Positioned(
                  top: 30,
                  right: -50,
                  child: Container(
                    width: 160,
                    height: 160,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppTheme.royalIndigo.withOpacity(0.35),
                    ),
                  ),
                ),
                // نجوم مبعثرة داخل الهيدر
                Positioned.fill(
                  child: IgnorePointer(
                    child: CustomPaint(
                      painter: _HeaderStarsPainter(),
                    ),
                  ),
                ),
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 40),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _greeting,
                                  style: TextStyle(
                                    color:
                                        AppTheme.goldAccent.withOpacity(0.95),
                                    fontFamily: 'Cairo',
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                const Text(
                                  'ليالى المحروسة',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Cairo',
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.2,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: AppTheme.goldAccent.withOpacity(0.4),
                                ),
                              ),
                              padding: const EdgeInsets.all(2),
                              child: CircleAvatar(
                                radius: 20,
                                backgroundColor:
                                    AppTheme.goldAccent.withOpacity(0.15),
                                child: const Icon(
                                  Icons.notifications_rounded,
                                  color: AppTheme.goldAccent,
                                  size: 20,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        title: _isSearching
            ? const Text(
                'نتائج البحث',
                style: TextStyle(
                    fontFamily: 'Cairo', fontSize: 18, color: Colors.white),
              )
            : null,
        titlePadding: const EdgeInsets.only(bottom: 16, right: 16),
        collapseMode: CollapseMode.pin,
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(58),
        child: Transform.translate(
          offset: const Offset(0, 8),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              height: 54,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.deepNavy.withOpacity(0.18),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                onChanged: _onSearch,
                textAlignVertical: TextAlignVertical.center,
                style: const TextStyle(
                  fontFamily: 'Cairo',
                  color: AppTheme.textDark,
                  fontSize: 14,
                ),
                decoration: InputDecoration(
                  hintText: 'ابحث عن مكان أثري...',
                  hintStyle: TextStyle(
                    fontFamily: 'Cairo',
                    color: Colors.grey.shade400,
                    fontSize: 13,
                  ),
                  prefixIcon: Icon(
                    Icons.search_rounded,
                    color: AppTheme.midnightBlue.withOpacity(0.7),
                  ),
                  suffixIcon: _isSearching
                      ? IconButton(
                          icon: const Icon(Icons.close_rounded, size: 20),
                          onPressed: () {
                            _searchController.clear();
                            _onSearch('');
                          },
                        )
                      : Padding(
                          padding: const EdgeInsets.all(10),
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppTheme.goldAccent.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(
                              Icons.tune_rounded,
                              size: 18,
                              color: AppTheme.deepGold,
                            ),
                          ),
                        ),
                  border: InputBorder.none,
                  isCollapsed: true,
                  contentPadding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchResults() {
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      sliver: _searchResults.isEmpty
          ? SliverToBoxAdapter(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(48),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: AppTheme.midnightBlue.withOpacity(0.06),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.search_off_rounded,
                          size: 48,
                          color: AppTheme.textGray,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'لا توجد نتائج',
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          color: AppTheme.textGray,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          : SliverList(
              delegate: SliverChildBuilderDelegate(
                (ctx, i) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _MonumentListTile(monument: _searchResults[i]),
                ),
                childCount: _searchResults.length,
              ),
            ),
    );
  }

  Widget _buildNearestSection() {
    final nearest = MonumentsData.featured.take(3).toList();
    return SliverToBoxAdapter(
      child: _animatedSection(
        start: 0.0,
        end: 0.5,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _SectionHeader(
                  title: 'أقرب الأماكن إليك', icon: Icons.near_me_rounded),
              const SizedBox(height: 14),
              SizedBox(
                height: 230,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  clipBehavior: Clip.none,
                  itemCount: nearest.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 14),
                  itemBuilder: (ctx, i) => _NearbyCard(monument: nearest[i]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVideoSection() {
    return SliverToBoxAdapter(
      child: _animatedSection(
        start: 0.15,
        end: 0.6,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const _SectionHeader(
                        title: 'الفيديوهات المميزة',
                        icon: Icons.play_circle_fill_rounded),
                    GestureDetector(
                      onTap: () {},
                      child: Row(
                        children: [
                          Text(
                            'عرض الكل',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppTheme.midnightBlue,
                              fontFamily: 'Cairo',
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const Icon(Icons.arrow_back_ios_rounded,
                              size: 12, color: AppTheme.midnightBlue),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              SizedBox(
                height: 220,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  clipBehavior: Clip.none,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: videos.length,
                  itemBuilder: (context, index) {
                    return _VideoCard(video: videos[index]);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoriesSection() {
    final icons = [
      Icons.mosque_rounded,
      Icons.store_rounded,
      Icons.account_balance_rounded,
      Icons.castle_rounded,
      Icons.landscape_rounded,
      Icons.star_rounded,
    ];
    // ألوان "جواهر ليلية" — كل قسم بحجر كريم مختلف على نفس روح الباليت
    final gradients = [
      [AppTheme.goldAccent, AppTheme.deepGold],
      [AppTheme.emerald, AppTheme.emeraldDeep],
      [AppTheme.ruby, AppTheme.rubyDeep],
      [AppTheme.sapphire, AppTheme.sapphireDeep],
      [AppTheme.amethyst, AppTheme.amethystDeep],
      [AppTheme.copper, AppTheme.copperDeep],
    ];
    return SliverToBoxAdapter(
      child: _animatedSection(
        start: 0.25,
        end: 0.7,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _SectionHeader(
                  title: 'الأقسام', icon: Icons.grid_view_rounded),
              const SizedBox(height: 14),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 0.95,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: MonumentsData.categories.length,
                itemBuilder: (ctx, i) {
                  final cat = MonumentsData.categories[i];
                  final grad = gradients[i % gradients.length];
                  return _CategoryTile(
                    label: cat,
                    icon: icons[i % icons.length],
                    gradient: grad,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CategoryScreen(category: cat),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeaturedSection() {
    final featured = MonumentsData.featured;
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate((ctx, i) {
          if (i == 0) {
            return const Padding(
              padding: EdgeInsets.only(bottom: 14),
              child: _SectionHeader(
                  title: 'أبرز المعالم', icon: Icons.auto_awesome_rounded),
            );
          }
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _MonumentListTile(monument: featured[i - 1]),
          );
        }, childCount: featured.length + 1),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Header curved clipper
// ─────────────────────────────────────────────
class _HeaderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 36);
    path.quadraticBezierTo(
      size.width / 2,
      size.height,
      size.width,
      size.height - 36,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

// ─────────────────────────────────────────────
// نجوم زخرفية داخل الهيدر الكحلي
// ─────────────────────────────────────────────
class _HeaderStarsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final bigStar = Paint()..color = AppTheme.starGold.withOpacity(0.55);
    final smallStar = Paint()..color = AppTheme.starGold.withOpacity(0.35);

    final bigPoints = [
      Offset(size.width * 0.12, size.height * 0.18),
      Offset(size.width * 0.55, size.height * 0.12),
      Offset(size.width * 0.88, size.height * 0.20),
    ];
    final smallPoints = [
      Offset(size.width * 0.30, size.height * 0.45),
      Offset(size.width * 0.72, size.height * 0.35),
      Offset(size.width * 0.45, size.height * 0.60),
      Offset(size.width * 0.20, size.height * 0.55),
    ];

    for (final p in bigPoints) {
      canvas.drawCircle(p, 1.8, bigStar);
    }
    for (final p in smallPoints) {
      canvas.drawCircle(p, 1.1, smallStar);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ─────────────────────────────────────────────
// Section header with gold accent icon chip
// ─────────────────────────────────────────────
class _SectionHeader extends StatelessWidget {
  final String title;
  final IconData icon;
  const _SectionHeader({required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(7),
          decoration: BoxDecoration(
            color: AppTheme.goldAccent.withOpacity(0.14),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 16, color: AppTheme.deepGold),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            fontFamily: 'Cairo',
            color: AppTheme.textDark,
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
// Category tile — gradient circle icon
// ─────────────────────────────────────────────
class _CategoryTile extends StatelessWidget {
  final String label;
  final IconData icon;
  final List<Color> gradient;
  final VoidCallback onTap;

  const _CategoryTile({
    required this.label,
    required this.icon,
    required this.gradient,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: gradient.first.withOpacity(0.18),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: gradient,
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: gradient.last.withOpacity(0.40),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(icon, color: Colors.white, size: 22),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                label,
                style: const TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textDark,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NearbyCard extends StatefulWidget {
  final Monument monument;
  const _NearbyCard({required this.monument});

  @override
  State<_NearbyCard> createState() => _NearbyCardState();
}

class _NearbyCardState extends State<_NearbyCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.96).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final imageUrl = (widget.monument.imageUrl ?? '').trim();

    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => MonumentDetailScreen(monument: widget.monument),
          ),
        );
      },
      onTapCancel: () => _controller.reverse(),
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          width: 175,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: AppTheme.deepNavy.withOpacity(0.18),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Use MonumentImage to support assets & network
                MonumentImage(imageUrl: imageUrl, fit: BoxFit.cover),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        AppTheme.deepNavy.withOpacity(0.20),
                        AppTheme.deepNavy.withOpacity(0.85),
                      ],
                      stops: const [0.3, 0.6, 1.0],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 14,
                  right: 14,
                  left: 14,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.monument.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontFamily: 'Cairo',
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 3),
                      Row(
                        children: [
                          const Icon(Icons.location_on_rounded,
                              color: Colors.white70, size: 12),
                          const SizedBox(width: 2),
                          Expanded(
                            child: Text(
                              widget.monument.category,
                              style: const TextStyle(
                                color: Colors.white70,
                                fontFamily: 'Cairo',
                                fontSize: 10,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 10,
                  left: 10,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.deepNavy.withOpacity(0.40),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.star_rounded,
                              color: AppTheme.goldAccent,
                              size: 13,
                            ),
                            const SizedBox(width: 2),
                            Text(
                              widget.monument.rating.toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Cairo',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _VideoCard extends StatefulWidget {
  final Map<String, dynamic> video;
  const _VideoCard({required this.video});

  @override
  State<_VideoCard> createState() => _VideoCardState();
}

class _VideoCardState extends State<_VideoCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final thumbnail = (widget.video['thumbnail'] as String? ?? '').trim();

    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => VideoPlayerScreen(video: widget.video),
          ),
        );
      },
      onTapCancel: () => _controller.reverse(),
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          width: 165,
          margin: const EdgeInsets.only(right: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: AppTheme.deepNavy.withOpacity(0.20),
                blurRadius: 14,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: Stack(
              fit: StackFit.expand,
              children: [
                MonumentImage(imageUrl: thumbnail, fit: BoxFit.cover),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        AppTheme.deepNavy.withOpacity(0.15),
                        Colors.transparent,
                        AppTheme.deepNavy.withOpacity(0.80),
                      ],
                      stops: const [0.0, 0.4, 1.0],
                    ),
                  ),
                ),
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                      child: Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.22),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppTheme.starGold.withOpacity(0.7),
                            width: 1.2,
                          ),
                        ),
                        child: const Icon(
                          Icons.play_arrow_rounded,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.video['title'],
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            fontFamily: 'Cairo',
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.remove_red_eye_rounded,
                                color: Colors.white70, size: 11),
                            const SizedBox(width: 3),
                            Text(
                              widget.video['views'],
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.85),
                                fontSize: 10,
                                fontFamily: 'Cairo',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.deepNavy.withOpacity(0.65),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      widget.video['duration'],
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Cairo',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MonumentListTile extends StatelessWidget {
  final Monument monument;
  const _MonumentListTile({required this.monument});

  @override
  Widget build(BuildContext context) {
    final favProvider = Provider.of<FavoritesProvider>(context);
    final isFav = favProvider.isFavorite(monument.id);
    final imageUrl = (monument.imageUrl ?? '').trim();

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => MonumentDetailScreen(monument: monument),
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: AppTheme.deepNavy.withOpacity(0.08),
              blurRadius: 14,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.horizontal(
                right: Radius.circular(18),
              ),
              child: SizedBox(
                width: 104,
                height: 104,
                child: MonumentImage(imageUrl: imageUrl, fit: BoxFit.cover),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      monument.name,
                      style: const TextStyle(
                        fontFamily: 'Cairo',
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: AppTheme.textDark,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      monument.era,
                      style: const TextStyle(
                        fontFamily: 'Cairo',
                        color: AppTheme.textGray,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 7,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.goldAccent.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.star_rounded,
                                color: AppTheme.goldAccent,
                                size: 14,
                              ),
                              Text(
                                ' ${monument.rating}',
                                style: const TextStyle(
                                  fontFamily: 'Cairo',
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.textDark,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Row(
                            children: [
                              const Icon(
                                Icons.location_on_rounded,
                                color: AppTheme.textGray,
                                size: 14,
                              ),
                              Expanded(
                                child: Text(
                                  monument.category,
                                  style: const TextStyle(
                                    fontFamily: 'Cairo',
                                    fontSize: 11,
                                    color: AppTheme.textGray,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 6),
              child: GestureDetector(
                onTap: () => favProvider.toggleFavorite(monument.id),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isFav
                        ? AppTheme.ruby.withOpacity(0.10)
                        : Colors.grey.withOpacity(0.08),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isFav
                        ? Icons.favorite_rounded
                        : Icons.favorite_border_rounded,
                    color: isFav ? AppTheme.ruby : AppTheme.textGray,
                    size: 20,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
