import 'package:flutter/material.dart';

import '../main.dart';
import '../models/anime_model.dart';
import '../services/anime_service.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({super.key, required this.anime});
  final AnimeModel anime;
  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late Future<AnimeModel> _detailFuture;
  final _service = AnimeService();

  @override
  void initState() {
    super.initState();
    _detailFuture = _service.fetchAnimeDetail(widget.anime.id);
  }

  void _retry() => setState(
    () => _detailFuture = _service.fetchAnimeDetail(widget.anime.id),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detail Anime')),
      body: FutureBuilder<AnimeModel>(
        future: _detailFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return _MessageState(
              icon: Icons.cloud_off,
              title: 'Gagal memuat detail',
              message: '${snapshot.error}',
              onRetry: _retry,
            );
          }
          return _DetailContent(anime: snapshot.data ?? widget.anime);
        },
      ),
    );
  }
}

class _DetailContent extends StatelessWidget {
  const _DetailContent({required this.anime});
  final AnimeModel anime;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 760),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _Poster(url: anime.imageUrl, width: 145, height: 205),
                  const SizedBox(width: 18),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          anime.title,
                          style: Theme.of(context).textTheme.headlineSmall
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 14),
                        _Rating(score: anime.score),
                        const SizedBox(height: 14),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            _Badge(
                              icon: Icons.movie_outlined,
                              text: anime.type,
                            ),
                            _Badge(
                              icon: Icons.playlist_play,
                              text: '${anime.episodes ?? '-'} episode',
                            ),
                            _Badge(
                              icon: Icons.calendar_month,
                              text: '${anime.year ?? '-'}',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Text(
                'Status',
                style: Theme.of(context).textTheme.titleMedium
                    ?.copyWith(color: appLavender, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              Text(anime.status),
              if (anime.genres.isNotEmpty) ...[
                const SizedBox(height: 20),
                Text(
                  'Genre',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: appLavender,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: anime.genres
                      .map((genre) => Chip(label: Text(genre)))
                      .toList(),
                ),
              ],
              const SizedBox(height: 20),
              Text(
                'Sinopsis',
                style: Theme.of(context).textTheme.titleMedium
                    ?.copyWith(color: appLavender, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                anime.synopsis,
                style: const TextStyle(color: appMuted, height: 1.55),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Poster extends StatelessWidget {
  const _Poster({required this.url, required this.width, required this.height});
  final String url;
  final double width;
  final double height;
  @override
  Widget build(BuildContext context) => ClipRRect(
    borderRadius: BorderRadius.circular(14),
    child: url.isEmpty
        ? _imageFallback(width, height)
        : Image.network(
            url,
            width: width,
            height: height,
            fit: BoxFit.cover,
            webHtmlElementStrategy: WebHtmlElementStrategy.fallback,
            errorBuilder: (_, _, _) => _imageFallback(width, height),
          ),
  );
  Widget _imageFallback(double w, double h) => Container(
    width: w,
    height: h,
    color: appSurface,
    child: const Icon(Icons.broken_image_outlined, color: appMuted, size: 40),
  );
}

class _Rating extends StatelessWidget {
  const _Rating({required this.score});
  final double score;
  @override
  Widget build(BuildContext context) => Row(
    children: [
      const Icon(Icons.star, color: appGold, size: 20),
      const SizedBox(width: 5),
      Text(
        score == 0 ? 'Belum ada rating' : score.toStringAsFixed(1),
        style: const TextStyle(color: appGold, fontWeight: FontWeight.bold),
      ),
    ],
  );
}

class _Badge extends StatelessWidget {
  const _Badge({required this.icon, required this.text});
  final IconData icon;
  final String text;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
    decoration: BoxDecoration(
      color: appSurface,
      borderRadius: BorderRadius.circular(10),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 15, color: appLavender),
        const SizedBox(width: 5),
        Text(text, style: const TextStyle(fontSize: 12)),
      ],
    ),
  );
}

class _MessageState extends StatelessWidget {
  const _MessageState({
    required this.icon,
    required this.title,
    required this.message,
    required this.onRetry,
  });
  final IconData icon;
  final String title;
  final String message;
  final VoidCallback onRetry;
  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: appLavender, size: 54),
          const SizedBox(height: 14),
          Text(
            title,
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
            onPressed: onRetry,
            icon: const Icon(Icons.refresh),
            label: const Text('Coba Lagi'),
          ),
        ],
      ),
    ),
  );
}
