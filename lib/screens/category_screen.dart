import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

import '../theme/app_theme.dart';
import '../data/monuments_data.dart';
import '../models/monument_model.dart';
import '../providers/favorites_provider.dart';
import 'monument_detail_screen.dart';

class CategoryScreen extends StatefulWidget {
  final String category;

  const CategoryScreen({
    super.key,
    required this.category,
  });

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  late final List<Monument> monuments;

  @override
  void initState() {
    super.initState();
    monuments = MonumentsData.byCategory(widget.category);

    // نفّذ الفحص و precache بعد أول إطار حتى يتوفر BuildContext
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _precacheAssets();
    });
  }

  Future<void> _precacheAssets() async {
    for (final m in monuments) {
      final path = (m.imageUrl ?? '').trim();
      if (path.isEmpty) {
        debugPrint('CARD IMAGE: EMPTY path for id=${m.id}');
        continue;
      }

      if (path.startsWith('http://') || path.startsWith('https://')) {
        debugPrint('NETWORK IMAGE URL: $path (id=${m.id})');
        // Optionally: try to precache network images by using CachedNetworkImageProvider
        try {
          await precacheImage(CachedNetworkImageProvider(path), context);
          debugPrint('PRECACHED NETWORK IMAGE: $path (id=${m.id})');
        } catch (e) {
          debugPrint('PRECACHE NETWORK FAILED: $path (id=${m.id}) -> $e');
        }
      } else {
        // Asset image: تحقق من وجوده في الحزمة ثم نفّذ precache
        try {
          await rootBundle.load(path);
          debugPrint('ASSET FOUND: $path (id=${m.id})');
          try {
            await precacheImage(AssetImage(path), context);
            debugPrint('PRECACHED ASSET: $path (id=${m.id})');
          } catch (e) {
            debugPrint('PRECACHE ASSET FAILED: $path (id=${m.id}) -> $e');
          }
        } catch (e) {
          debugPrint('ASSET NOT FOUND: $path (id=${m.id}) -> $e');
        }
      }
    }
  }

  void _navigateToDetail(BuildContext context, Monument monument) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MonumentDetailScreen(
          monument: monument,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.category,
          style: const TextStyle(
            fontFamily: 'Cairo',
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppTheme.primaryBrown,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: monuments.isEmpty
          ? Center(
              child: Text(
                'لا توجد معالم في هذه الفئة',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 16,
                  color: AppTheme.textGray,
                ),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: monuments.length,
              itemBuilder: (ctx, i) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _CategoryCard(
                    monument: monuments[i],
                    onTap: () => _navigateToDetail(context, monuments[i]),
                  ),
                );
              },
            ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final Monument monument;
  final VoidCallback onTap;

  const _CategoryCard({
    required this.monument,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final fav = Provider.of<FavoritesProvider>(context);

    final imageUrlNonNull = (monument.imageUrl ?? '').trim();

    // طباعة لتتبع القيم أثناء البناء
    debugPrint('BUILD CARD: id=${monument.id} image="$imageUrlNonNull"');

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.07),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // الصورة الرئيسية
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
              child: SizedBox(
                width: double.infinity,
                height: 180,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // استخدم نفس MonumentImage مثل صفحة التفاصيل
                    MonumentImage(
                      imageUrl: imageUrlNonNull,
                      fit: BoxFit.cover,
                    ),

                    // زر Favorite
                    Positioned(
                      top: 12,
                      left: 12,
                      child: GestureDetector(
                        onTap: () {
                          Provider.of<FavoritesProvider>(
                            context,
                            listen: false,
                          ).toggleFavorite(monument.id);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 8,
                              ),
                            ],
                          ),
                          child: Icon(
                            fav.isFavorite(monument.id)
                                ? Icons.favorite_rounded
                                : Icons.favorite_border_rounded,
                            color: fav.isFavorite(monument.id)
                                ? Colors.red
                                : AppTheme.textGray,
                            size: 20,
                          ),
                        ),
                      ),
                    ),

                    // التقييم
                    Positioned(
                      top: 12,
                      right: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.goldAccent,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.star_rounded,
                              color: Colors.white,
                              size: 14,
                            ),
                            Text(
                              ' ${monument.rating}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontFamily: 'Cairo',
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // معلومات المعلم
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    monument.name,
                    style: const TextStyle(
                      fontFamily: 'Cairo',
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(
                        Icons.history_edu_rounded,
                        size: 14,
                        color: AppTheme.textGray,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          monument.era,
                          style: const TextStyle(
                            fontFamily: 'Cairo',
                            color: AppTheme.textGray,
                            fontSize: 13,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Icon(
                        Icons.calendar_today_rounded,
                        size: 14,
                        color: AppTheme.textGray,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        monument.builtYear,
                        style: const TextStyle(
                          fontFamily: 'Cairo',
                          color: AppTheme.textGray,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    monument.shortDesc,
                    style: const TextStyle(
                      fontFamily: 'Cairo',
                      color: AppTheme.textGray,
                      fontSize: 13,
                      height: 1.5,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: onTap,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryBrown,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(
                          double.infinity,
                          44,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'عرض التفاصيل',
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
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
