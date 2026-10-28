import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/anime_model.dart';

class AnimeException implements Exception {
  final String message;
  const AnimeException(this.message);
  @override
  String toString() => message;
}

class AnimeService {
  AnimeService({http.Client? client, Duration? requestInterval})
    : _client = client ?? http.Client(),
      _requestInterval = requestInterval ?? const Duration(milliseconds: 400);

  final http.Client _client;
  final Duration _requestInterval;
  DateTime? _lastRequest;
  Future<void> _requestQueue = Future<void>.value();
  static const _baseUrl = 'https://api.tenrai.org/v1';

  Future<void> _waitForRequestSlot() {
    final next = _requestQueue.then((_) async {
      final previous = _lastRequest;
      if (previous != null) {
        final remaining =
            _requestInterval - DateTime.now().difference(previous);
        if (remaining > Duration.zero) await Future<void>.delayed(remaining);
      }
      _lastRequest = DateTime.now();
    });
    _requestQueue = next.catchError((Object _) {});
    return next;
  }

  Future<http.Response> _get(Uri uri) async {
    try {
      await _waitForRequestSlot();
      final response = await _client
          .get(uri)
          .timeout(const Duration(seconds: 20));
      if (response.statusCode < 200 || response.statusCode >= 300) {
        final message = response.statusCode == 429
            ? 'Terlalu banyak permintaan ke server. Tunggu sebentar, lalu coba lagi.'
            : 'Server mengembalikan kesalahan (HTTP ${response.statusCode}).';
        throw AnimeException(message);
      }
      return response;
    } on AnimeException {
      rethrow;
    } on TimeoutException {
      throw const AnimeException(
        'Permintaan terlalu lama. Periksa koneksi internet Anda.',
      );
    } on http.ClientException {
      throw const AnimeException(
        'Tidak dapat terhubung ke server. Periksa koneksi internet Anda.',
      );
    } catch (_) {
      throw const AnimeException(
        'Terjadi kesalahan saat mengambil data anime.',
      );
    }
  }

  Future<List<AnimeModel>> _fetchList(Uri uri) async {
    final response = await _get(uri);
    try {
      final decoded = jsonDecode(response.body) as Map<String, dynamic>;
      final data = decoded['data'] as List<dynamic>?;
      if (data == null) {
        throw const AnimeException('Format data dari server tidak sesuai.');
      }
      return data
          .map((item) => AnimeModel.fromJson(item as Map<String, dynamic>))
          .toList();
    } on AnimeException {
      rethrow;
    } catch (_) {
      throw const AnimeException('Data dari server tidak dapat dibaca.');
    }
  }

  Future<List<AnimeModel>> fetchTopAnime() =>
      _fetchList(Uri.parse('$_baseUrl/top/anime?limit=24'));

  Future<List<AnimeModel>> searchAnime(String query) {
    final trimmed = query.trim();
    if (trimmed.isEmpty) return fetchTopAnime();
    final uri = Uri.parse('$_baseUrl/anime')
        .replace(queryParameters: {'q': trimmed, 'limit': '24'});
    return _fetchList(uri);
  }

  Future<AnimeModel> fetchAnimeDetail(int id) async {
    final response = await _get(Uri.parse('$_baseUrl/anime/$id'));
    try {
      final decoded = jsonDecode(response.body) as Map<String, dynamic>;
      final data = decoded['data'] as Map<String, dynamic>?;
      if (data == null) {
        throw const AnimeException('Detail anime tidak ditemukan.');
      }
      return AnimeModel.fromJson(data);
    } on AnimeException {
      rethrow;
    } catch (_) {
      throw const AnimeException('Data detail dari server tidak dapat dibaca.');
    }
  }
}
