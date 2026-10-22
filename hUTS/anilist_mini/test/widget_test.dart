import 'package:anilist_mini/models/anime_model.dart';
import 'package:anilist_mini/pages/home_page.dart';
import 'package:anilist_mini/services/anime_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

const sampleAnime = AnimeModel(
  id: 5114,
  title: 'Fullmetal Alchemist: Brotherhood',
  imageUrl: '',
  score: 9.1,
  episodes: 64,
  synopsis: 'Sinopsis contoh.',
  status: 'Finished Airing',
  genres: ['Action'],
  type: 'TV',
  year: 2009,
);

class FakeAnimeService extends AnimeService {
  FakeAnimeService({this.top = const [sampleAnime], this.search = const []})
    : super(requestInterval: Duration.zero);
  final List<AnimeModel> top;
  final List<AnimeModel> search;

  @override
  Future<List<AnimeModel>> fetchTopAnime() async => top;

  @override
  Future<List<AnimeModel>> searchAnime(String query) async => search;
}

Widget testApp(AnimeService service) =>
    MaterialApp(home: HomePage(service: service));

void main() {
  testWidgets('menampilkan anime populer dari Future', (tester) async {
    await tester.pumpWidget(testApp(FakeAnimeService()));
    await tester.pumpAndSettle();
    expect(find.text('Top Anime'), findsOneWidget);
    expect(find.text('Fullmetal Alchemist: Brotherhood'), findsOneWidget);
    expect(find.text('9.1'), findsOneWidget);
  });

  testWidgets('pencarian kosong menampilkan empty state', (tester) async {
    await tester.pumpWidget(testApp(FakeAnimeService()));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'tidakada');
    await tester.tap(find.text('Cari'));
    await tester.pumpAndSettle();
    expect(find.text('Anime tidak ditemukan'), findsOneWidget);
  });
}
