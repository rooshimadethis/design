class Anime {
  final int id;
  final String title;
  final String? coverImage;
  final String? bannerImage;
  final int? averageScore;
  final int? episodes;
  final List<String> genres;
  final String? color;
  final String? description;

  Anime({
    required this.id,
    required this.title,
    this.coverImage,
    this.bannerImage,
    this.averageScore,
    this.episodes,
    this.genres = const [],
    this.color,
    this.description,
  });

  factory Anime.fromJson(Map<String, dynamic> json) {
    return Anime(
      id: json['id'],
      title: json['title']['english'] ?? json['title']['romaji'] ?? 'Unknown',
      coverImage: json['coverImage']['large'],
      bannerImage: json['bannerImage'],
      averageScore: json['averageScore'],
      episodes: json['episodes'],
      genres: json['genres'] != null ? List<String>.from(json['genres']) : [],
      color: json['coverImage']['color'],
      description: json['description'],
    );
  }
}
