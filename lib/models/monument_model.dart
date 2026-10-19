class Monument {
  final String id;
  final String name;
  final String category;
  final String era;
  final String builtYear;
  final String builder;
  final String description;
  final String shortDesc;
  final String imageUrl;
  final List<String> gallery;
  final double lat;
  final double lng;
  final String address;
  final String openHours;
  final double entryFee;
  final double rating;
  final int reviewCount;
  final List<String> tags;
  final String audioGuideText;
  final bool isFeatured;
  final String type; // mosque, church, palace, gate, etc.

  const Monument({
    required this.id,
    required this.name,
    required this.category,
    required this.era,
    required this.builtYear,
    required this.builder,
    required this.description,
    required this.shortDesc,
    required this.imageUrl,
    this.gallery = const [],
    required this.lat,
    required this.lng,
    required this.address,
    required this.openHours,
    this.entryFee = 0,
    this.rating = 4.5,
    this.reviewCount = 100,
    this.tags = const [],
    this.audioGuideText = '',
    this.isFeatured = false,
    required this.type,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'isFeatured': isFeatured,
    };
  }
}

class TourRoute {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final int monumentCount;
  final int durationHours;
  final String category;
  final List<String> monumentIds;

  const TourRoute({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.monumentCount,
    required this.durationHours,
    required this.category,
    required this.monumentIds,
  });
}
