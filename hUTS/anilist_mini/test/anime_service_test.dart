import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:anilist_mini/services/anime_service.dart';

void main() {
  test('top anime memeriksa endpoint dan mengolah data', () async {
    final service = AnimeService(
      client: MockClient((uri) async {
        expect(uri.url.host, 'api.tenrai.org');
        expect(uri.url.path, '/v1/top/anime');
        return http.Response(
          jsonEncode({
            'data': [
              {'mal_id': 1, 'title': 'Contoh'},
            ],
          }),
          200,
        );
      }),
      requestInterval: Duration.zero,
    );
    expect((await service.fetchTopAnime()).single.title, 'Contoh');
  });
  test('pencarian mengodekan query dan menerima hasil kosong', () async {
    final service = AnimeService(
      client: MockClient((request) async {
        expect(request.url.host, 'api.tenrai.org');
        expect(request.url.path, '/v1/anime');
        expect(request.url.queryParameters['q'], 'a & b');
        return http.Response('{"data":[]}', 200);
      }),
      requestInterval: Duration.zero,
    );
    expect(await service.searchAnime(' a & b '), isEmpty);
  });
  test('detail mengolah objek tunggal', () async {
    final service = AnimeService(
      client: MockClient((request) async {
        expect(request.url.host, 'api.tenrai.org');
        expect(request.url.path, '/v1/anime/5114');
        return http.Response('{"data":{"mal_id":5114}}', 200);
      }),
      requestInterval: Duration.zero,
    );
    expect((await service.fetchAnimeDetail(5114)).id, 5114);
  });
  for (final code in [429, 500]) {
    test('HTTP $code menghasilkan pesan yang dapat ditampilkan', () async {
      final service = AnimeService(
        client: MockClient((_) async => http.Response('', code)),
        requestInterval: Duration.zero,
      );
      expect(service.fetchTopAnime(), throwsA(isA<AnimeException>()));
    });
  }
  for (final body in ['invalid json', '{}', '{"data":null}']) {
    test('respons tidak valid $body ditangani', () async {
      final service = AnimeService(
        client: MockClient((_) async => http.Response(body, 200)),
        requestInterval: Duration.zero,
      );
      expect(service.fetchTopAnime(), throwsA(isA<AnimeException>()));
    });
  }
  test('kesalahan jaringan ditangani', () async {
    final service = AnimeService(
      client: MockClient((_) async => throw http.ClientException('offline')),
      requestInterval: Duration.zero,
    );
    expect(service.fetchTopAnime(), throwsA(isA<AnimeException>()));
  });
}
