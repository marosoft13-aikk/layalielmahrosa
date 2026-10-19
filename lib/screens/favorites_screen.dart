import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../data/monuments_data.dart';
import '../providers/favorites_provider.dart';
import 'monument_detail_screen.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final fav = Provider.of<FavoritesProvider>(context);
    final monuments =
        MonumentsData.all.where((m) => fav.isFavorite(m.id)).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('المفضلة'),
        backgroundColor: AppTheme.primaryBrown,
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
      ),
      body: monuments.isEmpty
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.favorite_border_rounded,
                      size: 80, color: AppTheme.textGray),
                  const SizedBox(height: 16),
                  const Text(
                    'لا توجد أماكن مفضلة بعد',
                    style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 18,
                        color: AppTheme.textGray),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'احفظ الأماكن التي تريد زيارتها',
                    style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 14,
                        color: AppTheme.textGray),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: monuments.length,
              itemBuilder: (ctx, i) {
                final m = monuments[i];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => MonumentDetailScreen(monument: m)),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(0.06),
                              blurRadius: 8)
                        ],
                      ),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(16),
                              bottomRight: Radius.circular(16),
                            ),
                            child: CachedNetworkImage(
                              imageUrl: m.imageUrl,
                              width: 90,
                              height: 90,
                              fit: BoxFit.cover,
                              errorWidget: (_, __, ___) => Container(
                                width: 90,
                                height: 90,
                                color: AppTheme.lightCream,
                                child: const Icon(Icons.mosque_rounded,
                                    color: AppTheme.textGray),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(m.name,
                                    style: const TextStyle(
                                        fontFamily: 'Cairo',
                                        fontWeight: FontWeight.bold)),
                                const SizedBox(height: 4),
                                Text(m.era,
                                    style: const TextStyle(
                                        fontFamily: 'Cairo',
                                        color: AppTheme.textGray,
                                        fontSize: 12)),
                                const SizedBox(height: 4),
                                Text(m.category,
                                    style: const TextStyle(
                                        fontFamily: 'Cairo',
                                        color: AppTheme.primaryBrown,
                                        fontSize: 11)),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.favorite_rounded,
                                color: Colors.red),
                            onPressed: () => fav.toggleFavorite(m.id),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
