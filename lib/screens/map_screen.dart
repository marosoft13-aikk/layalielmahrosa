// ============================================================
// map_screen.dart
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../theme/app_theme.dart';
import '../data/monuments_data.dart';
import '../models/monument_model.dart';
import 'monument_detail_screen.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapController _mapController = MapController();

  String? _selectedCategory;

  List<Monument> get _monuments {
    if (_selectedCategory == null) {
      return MonumentsData.all;
    }

    return MonumentsData.byCategory(_selectedCategory!);
  }

  void _selectCategory(String? category) {
    setState(() {
      _selectedCategory = category;
    });

    // تحريك الخريطة إلى القاهرة
    _mapController.move(
      const LatLng(30.0444, 31.2357),
      13,
    );
  }

  void _openMonument(Monument monument) {
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
    final monuments = _monuments;

    return Scaffold(
      appBar: AppBar(
        title: const Text('الخريطة'),
        backgroundColor: AppTheme.primaryBrown,
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          // =====================================================
          // Categories
          // =====================================================
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 8,
            ),
            child: SizedBox(
              height: 40,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _FilterChip(
                    label: 'الكل',
                    selected: _selectedCategory == null,
                    onTap: () => _selectCategory(null),
                  ),
                  ...MonumentsData.categories.map(
                    (category) => _FilterChip(
                      label: category,
                      selected: _selectedCategory == category,
                      onTap: () => _selectCategory(category),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // =====================================================
          // OpenStreetMap
          // =====================================================
          Expanded(
            child: FlutterMap(
              mapController: _mapController,
              options: const MapOptions(
                initialCenter: LatLng(
                  30.0444,
                  31.2357,
                ),
                initialZoom: 13,
                minZoom: 8,
                maxZoom: 19,
              ),
              children: [
                // =================================================
                // OpenStreetMap tiles
                // =================================================
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.layalielmahrosa',
                ),

                // =================================================
                // Monument markers
                // =================================================
                MarkerLayer(
                  markers: monuments.map((monument) {
                    return Marker(
                      point: LatLng(
                        monument.lat,
                        monument.lng,
                      ),
                      width: 50,
                      height: 60,
                      child: GestureDetector(
                        onTap: () => _openMonument(monument),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 42,
                              height: 42,
                              decoration: BoxDecoration(
                                color: AppTheme.primaryBrown,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 3,
                                ),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 5,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.location_on,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),

                            // نقطة صغيرة أسفل الـ Marker
                            Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),

                // =================================================
                // Attribution
                // =================================================
                const RichAttributionWidget(
                  attributions: [
                    TextSourceAttribution(
                      'OpenStreetMap contributors',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),

      // =========================================================
      // زر إعادة الخريطة للقاهرة
      // =========================================================
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppTheme.primaryBrown,
        foregroundColor: Colors.white,
        onPressed: () {
          _mapController.move(
            const LatLng(
              30.0444,
              31.2357,
            ),
            13,
          );
        },
        child: const Icon(Icons.my_location),
      ),
    );
  }
}

// ============================================================
// Filter Chip
// ============================================================

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 8,
          ),
          decoration: BoxDecoration(
            color: selected ? AppTheme.primaryBrown : AppTheme.lightCream,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 12,
              color: selected ? Colors.white : AppTheme.textDark,
              fontWeight: selected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}
