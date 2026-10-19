// ============================================================
// tours_screen.dart
// ============================================================
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../theme/app_theme.dart';
import '../data/monuments_data.dart';
import '../models/monument_model.dart';

class ToursScreen extends StatelessWidget {
  const ToursScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الجولات المقترحة'),
        backgroundColor: AppTheme.primaryBrown,
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: MonumentsData.tours.length,
        itemBuilder: (ctx, i) {
          final tour = MonumentsData.tours[i];
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: _TourCard(tour: tour),
          );
        },
      ),
    );
  }
}

class _TourCard extends StatelessWidget {
  final TourRoute tour;
  const _TourCard({required this.tour});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 12)
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                child: CachedNetworkImage(
                  imageUrl: tour.imageUrl,
                  width: double.infinity,
                  height: 160,
                  fit: BoxFit.cover,
                  errorWidget: (_, __, ___) => Container(
                    height: 160,
                    color: AppTheme.lightCream,
                    child: const Icon(Icons.tour_rounded,
                        size: 64, color: AppTheme.textGray),
                  ),
                ),
              ),
              Container(
                height: 160,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Colors.black.withOpacity(0.6)],
                  ),
                ),
              ),
              Positioned(
                bottom: 12,
                right: 16,
                child: Text(
                  tour.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontFamily: 'Cairo',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(tour.description,
                    style: const TextStyle(
                        fontFamily: 'Cairo',
                        color: AppTheme.textGray,
                        height: 1.5)),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _TourStat(
                      icon: Icons.place_rounded,
                      value: '${tour.monumentCount} مكان أثري',
                      color: AppTheme.primaryBrown,
                    ),
                    const SizedBox(width: 16),
                    _TourStat(
                      icon: Icons.access_time_rounded,
                      value:
                          '${tour.durationHours} - ${tour.durationHours + 1} ساعات',
                      color: AppTheme.goldAccent,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.play_circle_rounded),
                    label: const Text('ابدأ الجولة',
                        style: TextStyle(fontFamily: 'Cairo', fontSize: 15)),
                    onPressed: () {},
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
        ],
      ),
    );
  }
}

class _TourStat extends StatelessWidget {
  final IconData icon;
  final String value;
  final Color color;
  const _TourStat(
      {required this.icon, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 4),
        Text(value,
            style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 12,
                color: color,
                fontWeight: FontWeight.bold)),
      ],
    );
  }
}
