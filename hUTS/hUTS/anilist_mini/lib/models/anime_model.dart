class AnimeModel {
  final int id;
  final String title;
  final String imageUrl;
  final double score;
  final int? episodes;
  final String synopsis;
  final String status;
  final List<String> genres;
  final String type;
  final int? year;

  const AnimeModel({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.score,
    required this.episodes,
    required this.synopsis,
    required this.status,
    required this.genres,
    required this.type,
    required this.year,
  });

  factory AnimeModel.fromJson(Map<String, dynamic> json) {
    final images = json['images'] as Map<String, dynamic>?;
    final jpg = images?['jpg'] as Map<String, dynamic>?;
    final genresJson = json['genres'] as List<dynamic>? ?? [];

    return AnimeModel(
      id: (json['mal_id'] as num?)?.toInt() ?? 0,
      title: json['title'] as String? ?? 'Judul tidak tersedia',
      imageUrl: jpg?['image_url'] as String? ?? '',
      score: (json['score'] as num?)?.toDouble() ?? 0,
      episodes: (json['episodes'] as num?)?.toInt(),
      synopsis: json['synopsis'] as String? ?? 'Sinopsis belum tersedia.',
      status: json['status'] as String? ?? 'Status tidak tersedia',
      genres: genresJson
          .map((genre) => (genre as Map<String, dynamic>)['name'] as String?)
          .whereType<String>()
          .toList(),
      type: json['type'] as String? ?? 'Tipe tidak tersedia',
      year: (json['year'] as num?)?.toInt(),
    );
  }
}
