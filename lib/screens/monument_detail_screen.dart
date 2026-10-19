import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';
import '../theme/app_theme.dart';
import '../models/monument_model.dart';
import '../providers/favorites_provider.dart';

class MonumentDetailScreen extends StatefulWidget {
  final Monument monument;
  const MonumentDetailScreen({super.key, required this.monument});

  @override
  State<MonumentDetailScreen> createState() => _MonumentDetailScreenState();
}

class _MonumentDetailScreenState extends State<MonumentDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _launchMaps() async {
    final m = widget.monument;
    final url = Uri.parse(
        'https://www.google.com/maps/dir/?api=1&destination=${m.lat},${m.lng}');
    if (await canLaunchUrl(url)) launchUrl(url);
  }

  void _share() {
    Share.share(
      'اكتشف ${widget.monument.name} - ${widget.monument.shortDesc}\n${widget.monument.address}',
    );
  }

  @override
  Widget build(BuildContext context) {
    final m = widget.monument;
    final fav = Provider.of<FavoritesProvider>(context);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor: AppTheme.primaryBrown,
            foregroundColor: Colors.white,
            actions: [
              IconButton(
                icon: const Icon(Icons.share_rounded),
                onPressed: _share,
              ),
              IconButton(
                icon: Icon(
                  fav.isFavorite(m.id)
                      ? Icons.favorite_rounded
                      : Icons.favorite_border_rounded,
                  color: fav.isFavorite(m.id) ? Colors.red : Colors.white,
                ),
                onPressed: () => fav.toggleFavorite(m.id),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                m.name,
                style: const TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  shadows: [Shadow(color: Colors.black, blurRadius: 8)],
                ),
              ),
              background: MonumentImage(
                imageUrl: m.imageUrl,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                // Quick Info Row
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _InfoChip(
                          icon: Icons.history_edu_rounded,
                          label: m.era,
                          color: AppTheme.primaryBrown),
                      _InfoChip(
                          icon: Icons.calendar_today_rounded,
                          label: m.builtYear,
                          color: const Color(0xFF4A7C59)),
                      _InfoChip(
                        icon: Icons.attach_money_rounded,
                        label: m.entryFee == 0
                            ? 'مجاني'
                            : '${m.entryFee.toInt()} جنيه',
                        color: m.entryFee == 0
                            ? Colors.green
                            : AppTheme.goldAccent,
                      ),
                    ],
                  ),
                ),
                // Rating + Hours
                Container(
                  color: AppTheme.lightCream,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    children: [
                      const Icon(Icons.star_rounded,
                          color: AppTheme.goldAccent),
                      Text(
                        ' ${m.rating} (${m.reviewCount} تقييم)',
                        style: const TextStyle(
                            fontFamily: 'Cairo', fontWeight: FontWeight.bold),
                      ),
                      const Spacer(),
                      const Icon(Icons.access_time_rounded,
                          color: AppTheme.textGray, size: 16),
                      Text(
                        ' ${m.openHours}',
                        style: const TextStyle(
                            fontFamily: 'Cairo',
                            color: AppTheme.textGray,
                            fontSize: 13),
                      ),
                    ],
                  ),
                ),
                // Tabs
                Container(
                  color: Colors.white,
                  child: TabBar(
                    controller: _tabController,
                    labelColor: AppTheme.primaryBrown,
                    unselectedLabelColor: AppTheme.textGray,
                    indicatorColor: AppTheme.primaryBrown,
                    labelStyle: const TextStyle(
                        fontFamily: 'Cairo', fontWeight: FontWeight.bold),
                    tabs: const [
                      Tab(text: 'نبذة'),
                      Tab(text: 'الصور'),
                      Tab(text: 'تمرن'),
                    ],
                  ),
                ),
                SizedBox(
                  height: 400,
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _OverviewTab(monument: m),
                      _PhotosTab(monument: m),
                      _AudioTab(monument: m),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.bookmark_border_rounded),
                  label: const Text('احفظ كمفضل',
                      style: TextStyle(fontFamily: 'Cairo')),
                  onPressed: () => fav.toggleFavorite(m.id),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppTheme.primaryBrown,
                    side: const BorderSide(color: AppTheme.primaryBrown),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.directions_rounded),
                  label: const Text('اتجاهات',
                      style: TextStyle(fontFamily: 'Cairo')),
                  onPressed: _launchMaps,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryBrown,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  const _InfoChip(
      {required this.icon, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 22),
        ),
        const SizedBox(height: 4),
        Text(label,
            style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 12,
                color: color,
                fontWeight: FontWeight.bold)),
      ],
    );
  }
}

class _OverviewTab extends StatelessWidget {
  final Monument monument;
  const _OverviewTab({required this.monument});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('نبذة تاريخية',
              style: TextStyle(
                  fontFamily: 'Cairo',
                  fontWeight: FontWeight.bold,
                  fontSize: 16)),
          const SizedBox(height: 8),
          Text(monument.description,
              style: const TextStyle(
                  fontFamily: 'Cairo',
                  color: AppTheme.textDark,
                  fontSize: 14,
                  height: 1.8)),
          const SizedBox(height: 20),
          const Divider(color: AppTheme.dividerColor),
          const SizedBox(height: 12),
          _DetailRow(
              icon: Icons.architecture_rounded,
              label: 'النوع',
              value: monument.type),
          _DetailRow(
              icon: Icons.account_balance_rounded,
              label: 'الدولة',
              value: monument.era),
          _DetailRow(
              icon: Icons.calendar_today_rounded,
              label: 'سنة الإنشاء',
              value: monument.builtYear),
          _DetailRow(
              icon: Icons.person_rounded,
              label: 'المُنشئ',
              value: monument.builder),
          _DetailRow(
              icon: Icons.location_on_rounded,
              label: 'العنوان',
              value: monument.address),
          _DetailRow(
              icon: Icons.access_time_rounded,
              label: 'مواعيد العمل',
              value: monument.openHours),
          _DetailRow(
            icon: Icons.attach_money_rounded,
            label: 'رسوم الدخول',
            value: monument.entryFee == 0
                ? 'مجاني'
                : '${monument.entryFee.toInt()} جنيه',
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: monument.tags
                .map((tag) => Chip(
                      label: Text(tag,
                          style: const TextStyle(
                              fontFamily: 'Cairo', fontSize: 12)),
                      backgroundColor: AppTheme.lightCream,
                      side: BorderSide.none,
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _DetailRow(
      {required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: AppTheme.primaryBrown),
          const SizedBox(width: 10),
          SizedBox(
            width: 80,
            child: Text(label,
                style: const TextStyle(
                    fontFamily: 'Cairo',
                    fontWeight: FontWeight.bold,
                    fontSize: 13)),
          ),
          Expanded(
            child: Text(value,
                style: const TextStyle(
                    fontFamily: 'Cairo',
                    color: AppTheme.textGray,
                    fontSize: 13)),
          ),
        ],
      ),
    );
  }
}

class _PhotosTab extends StatelessWidget {
  final Monument monument;
  const _PhotosTab({required this.monument});

  @override
  Widget build(BuildContext context) {
    final images = [monument.imageUrl, ...monument.gallery];
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: images.length,
      itemBuilder: (ctx, i) => ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: MonumentImage(
          imageUrl: images[i],
        ),
      ),
    );
  }
}

class _AudioTab extends StatelessWidget {
  final Monument monument;
  const _AudioTab({required this.monument});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppTheme.primaryBrown.withOpacity(0.1),
            ),
            child: const Icon(Icons.volume_up_rounded,
                size: 64, color: AppTheme.primaryBrown),
          ),
          const SizedBox(height: 20),
          Text(
            monument.name,
            style: const TextStyle(
                fontFamily: 'Cairo', fontWeight: FontWeight.bold, fontSize: 18),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          const Text(
            'دليل صوتي',
            style: TextStyle(fontFamily: 'Cairo', color: AppTheme.textGray),
          ),
          const SizedBox(height: 32),
          Slider(
            value: 0,
            onChanged: (_) {},
            activeColor: AppTheme.primaryBrown,
            inactiveColor: AppTheme.dividerColor,
          ),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('0:00',
                  style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 12,
                      color: AppTheme.textGray)),
              Text('3:45',
                  style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 12,
                      color: AppTheme.textGray)),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.skip_previous_rounded, size: 36),
                color: AppTheme.textGray,
                onPressed: () {},
              ),
              const SizedBox(width: 16),
              Container(
                width: 64,
                height: 64,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppTheme.primaryBrown,
                ),
                child: const Icon(Icons.play_arrow_rounded,
                    color: Colors.white, size: 36),
              ),
              const SizedBox(width: 16),
              IconButton(
                icon: const Icon(Icons.skip_next_rounded, size: 36),
                color: AppTheme.textGray,
                onPressed: () {},
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            monument.audioGuideText.isNotEmpty
                ? monument.audioGuideText
                : 'استمع إلى نبذة تاريخية صوتية عن ${monument.name}',
            style: const TextStyle(
                fontFamily: 'Cairo',
                color: AppTheme.textGray,
                fontSize: 13,
                height: 1.6),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class MonumentImage extends StatelessWidget {
  final String imageUrl;
  final BoxFit fit;

  const MonumentImage({
    super.key,
    required this.imageUrl,
    this.fit = BoxFit.cover,
  });

  bool get isNetworkImage {
    return imageUrl.startsWith('http://') || imageUrl.startsWith('https://');
  }

  @override
  Widget build(BuildContext context) {
    if (isNetworkImage) {
      return CachedNetworkImage(
        imageUrl: imageUrl,
        fit: fit,
        placeholder: (context, url) => Container(
          color: AppTheme.lightCream,
          child: const Center(
            child: CircularProgressIndicator(
              color: AppTheme.primaryBrown,
            ),
          ),
        ),
        errorWidget: (context, url, error) {
          debugPrint('NETWORK IMAGE ERROR: $error');
          debugPrint('URL: $url');

          return Container(
            color: AppTheme.lightCream,
            child: const Center(
              child: Icon(
                Icons.broken_image_rounded,
                size: 50,
                color: AppTheme.textGray,
              ),
            ),
          );
        },
      );
    }

    return Image.asset(
      imageUrl,
      fit: fit,
      errorBuilder: (context, error, stackTrace) {
        debugPrint('ASSET IMAGE ERROR: $error');
        debugPrint('PATH: $imageUrl');

        return Container(
          color: AppTheme.lightCream,
          child: const Center(
            child: Icon(
              Icons.broken_image_rounded,
              size: 50,
              color: AppTheme.textGray,
            ),
          ),
        );
      },
    );
  }
}
