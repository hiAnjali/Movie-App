
class Movie {
  final String title;
  final String backDropDepth;
  final List<int> genreIds;
  final String overview;
  final String releaseDate;

  Movie({
    required this.title,
    required this.backDropDepth,
    required this.genreIds,
    required this.overview,
    required this.releaseDate,
  });

  factory Movie.fromMap(Map<String, dynamic> map) {
    return Movie(
      title: map['title'] ?? '',
      backDropDepth: map['backdrop_path'] ?? '',
      genreIds: List<int>.from(map['genre_ids'] ?? []),
      overview: map['overview'] ?? '',
      releaseDate: map['release_date'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'backdrop_path': backDropDepth,
      'genre_ids': genreIds,
      'overview': overview,
      'release_date': releaseDate,
    };
  }

  // Optional: convert genre IDs to names using a static map
  static const Map<int, String> genreMap = {
    28: 'Action',
    12: 'Adventure',
    16: 'Animation',
    35: 'Comedy',
    80: 'Crime',
    99: 'Documentary',
    18: 'Drama',
    10751: 'Family',
    14: 'Fantasy',
    36: 'History',
    27: 'Horror',
    10402: 'Music',
    9648: 'Mystery',
    10749: 'Romance',
    878: 'Science Fiction',
    10770: 'TV Movie',
    53: 'Thriller',
    10752: 'War',
    37: 'Western',
  };

  String get genreNames =>
      genreIds.map((id) => genreMap[id] ?? 'Unknown').join(', ');
}

