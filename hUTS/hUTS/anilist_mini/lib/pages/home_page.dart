import 'package:flutter/material.dart';

import '../main.dart';
import '../models/anime_model.dart';
import '../services/anime_service.dart';
import 'detail_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, this.service});
  final AnimeService? service;
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final AnimeService _service;
  late Future<List<AnimeModel>> _animeFuture;
  final _searchController = TextEditingController();
  String _sectionTitle = 'Top Anime';

  @override
  void initState() {
    super.initState();
    _service = widget.service ?? AnimeService();
    _animeFuture = _service.fetchTopAnime();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _search() {
    FocusScope.of(context).unfocus();
    final query = _searchController.text.trim();
    setState(() {
      _sectionTitle = query.isEmpty ? 'Top Anime' : 'Hasil Pencarian: $query';
      _animeFuture = query.isEmpty
          ? _service.fetchTopAnime()
          : _service.searchAnime(query);
    });
  }

  void _showTopAnime() {
    _searchController.clear();
    setState(() {
      _sectionTitle = 'Top Anime';
      _animeFuture = _service.fetchTopAnime();
    });
  }

  void _retry() {
    final query = _searchController.text.trim();
    setState(
      () => _animeFuture = query.isEmpty
          ? _service.fetchTopAnime()
          : _service.searchAnime(query),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.auto_awesome, color: appLavender),
            SizedBox(width: 10),
            Text('AniList Mini', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        actions: [
          IconButton(
            onPressed: _showTopAnime,
            tooltip: 'Refresh anime populer',
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 900),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Temukan anime favoritmu',
                    style: Theme.of(context).textTheme.headlineSmall
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    'Jelajahi anime populer atau cari berdasarkan judul.',
                    style: TextStyle(color: appMuted),
                  ),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          textInputAction: TextInputAction.search,
                          onSubmitted: (_) => _search(),
                          decoration: const InputDecoration(
                            hintText: 'Cari anime, misalnya Naruto...',
                            prefixIcon: Icon(Icons.search),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      SizedBox(
                        height: 56,
                        child: FilledButton(
                          onPressed: _search,
                          child: const Text('Cari'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 22),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          _sectionTitle,
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                      if (_sectionTitle != 'Top Anime')
                        TextButton(
                          onPressed: _showTopAnime,
                          child: const Text('Kembali ke Top Anime'),
                        ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: FutureBuilder<List<AnimeModel>>(
                      future: _animeFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (snapshot.hasError) {
                          return _MessageState(
                            icon: Icons.cloud_off,
                            title: 'Data gagal dimuat',
                            message: '${snapshot.error}',
                            buttonText: 'Coba Lagi',
                            onPressed: _retry,
                          );
                        }
                        final animeList = snapshot.data ?? [];
                        if (animeList.isEmpty) {
                          return _MessageState(
                            icon: Icons.search_off,
                            title: 'Anime tidak ditemukan',
                            message: 'Coba gunakan judul atau kata kunci lain.',
                            buttonText: 'Tampilkan Top Anime',
                            onPressed: _showTopAnime,
                          );
                        }
                        return LayoutBuilder(
                          builder: (context, constraints) {
                            final columns = constraints.maxWidth >= 760
                                ? 4
                                : constraints.maxWidth >= 520
                                ? 3
                                : 2;
                            return GridView.builder(
                              padding: const EdgeInsets.only(bottom: 24),
                              itemCount: animeList.length,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: columns,
                                    crossAxisSpacing: 13,
                                    mainAxisSpacing: 13,
                                    childAspectRatio: .59,
                                  ),
                              itemBuilder: (context, index) =>
                                  _AnimeCard(anime: animeList[index]),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AnimeCard extends StatelessWidget {
  const _AnimeCard({required this.anime});
  final AnimeModel anime;
  @override
  Widget build(BuildContext context) => Material(
    color: appSurface,
    borderRadius: BorderRadius.circular(16),
    clipBehavior: Clip.antiAlias,
    child: InkWell(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => DetailPage(anime: anime)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: SizedBox(
              width: double.infinity,
              child: anime.imageUrl.isEmpty
                  ? const _ImageFallback()
                  : Image.network(
                      anime.imageUrl,
                      fit: BoxFit.cover,
                      webHtmlElementStrategy: WebHtmlElementStrategy.fallback,
                      errorBuilder: (_, _, _) => const _ImageFallback(),
                    ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(11, 10, 11, 4),
            child: Text(
              anime.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.w600, height: 1.2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(11, 3, 11, 11),
            child: Row(
              children: [
                const Icon(Icons.star, color: appGold, size: 17),
                const SizedBox(width: 4),
                Text(
                  anime.score == 0 ? '-' : anime.score.toStringAsFixed(1),
                  style: const TextStyle(
                    color: appGold,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Text(
                  anime.type,
                  style: const TextStyle(color: appMuted, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

class _ImageFallback extends StatelessWidget {
  const _ImageFallback();
  @override
  Widget build(BuildContext context) => Container(
    color: const Color(0xFF27253A),
    child: const Center(
      child: Icon(Icons.broken_image_outlined, color: appMuted, size: 42),
    ),
  );
}

class _MessageState extends StatelessWidget {
  const _MessageState({
    required this.icon,
    required this.title,
    required this.message,
    required this.buttonText,
    required this.onPressed,
  });
  final IconData icon;
  final String title;
  final String message;
  final String buttonText;
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: appLavender, size: 56),
          const SizedBox(height: 14),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(color: appMuted),
          ),
          const SizedBox(height: 18),
          FilledButton.icon(
            onPressed: onPressed,
            icon: const Icon(Icons.refresh),
            label: Text(buttonText),
          ),
        ],
      ),
    ),
  );
}
