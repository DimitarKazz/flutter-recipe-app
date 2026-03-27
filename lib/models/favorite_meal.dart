class FavoriteMeal {
  final String id;
  final String name;
  final String thumbnail;
  final DateTime addedAt;

  FavoriteMeal({
    required this.id,
    required this.name,
    required this.thumbnail,
    required this.addedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'thumbnail': thumbnail,
      'addedAt': addedAt.toIso8601String(),
    };
  }

  factory FavoriteMeal.fromMap(Map<String, dynamic> map) {
    return FavoriteMeal(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      thumbnail: map['thumbnail'] ?? '',
      addedAt: DateTime.parse(map['addedAt']),
    );
  }
}