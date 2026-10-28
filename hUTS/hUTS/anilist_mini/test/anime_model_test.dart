import 'package:anilist_mini/models/anime_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AnimeModel.fromJson', () {
    test('mengubah JSON bertingkat menjadi objek Dart', () {
      final anime = AnimeModel.fromJson({
        'mal_id': 5114,
        'title': 'Fullmetal Alchemist: Brotherhood',
        'images': {
          'jpg': {'image_url': 'https://example.com/poster.jpg'},
        },
        'score': 9.1,
        'episodes': 64,
        'synopsis': 'Dua bersaudara mencari Philosopher Stone.',
        'status': 'Finished Airing',
        'genres': [
          {'name': 'Action'},
          {'name': 'Adventure'},
        ],
        'type': 'TV',
        'year': 2009,
      });

      expect(anime.id, 5114);
      expect(anime.title, 'Fullmetal Alchemist: Brotherhood');
      expect(anime.imageUrl, 'https://example.com/poster.jpg');
      expect(anime.score, 9.1);
      expect(anime.episodes, 64);
      expect(anime.genres, ['Action', 'Adventure']);
      expect(anime.year, 2009);
    });

    test('memberikan nilai aman ketika atribut opsional null', () {
      final anime = AnimeModel.fromJson({
        'mal_id': 1,
        'title': null,
        'images': null,
        'score': null,
        'episodes': null,
        'synopsis': null,
        'status': null,
        'genres': null,
        'type': null,
        'year': null,
      });

      expect(anime.title, 'Judul tidak tersedia');
      expect(anime.imageUrl, '');
      expect(anime.score, 0);
      expect(anime.genres, isEmpty);
      expect(anime.synopsis, 'Sinopsis belum tersedia.');
    });
  });
}
