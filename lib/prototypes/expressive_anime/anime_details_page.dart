import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../common/models/anime.dart';

class AnimeDetailsPage extends StatelessWidget {
  final Anime anime;

  const AnimeDetailsPage({super.key, required this.anime});

  @override
  Widget build(BuildContext context) {
    // Parse color or use default
    final primaryColor = anime.color != null
        ? Color(int.parse(anime.color!.replaceAll('#', '0xFF')))
        : const Color(0xFFFF4081);

    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F8),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            stretch: true,
            backgroundColor: primaryColor,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_rounded),
              onPressed: () => Navigator.pop(context),
              style: IconButton.styleFrom(
                backgroundColor: Colors.black26,
                foregroundColor: Colors.white,
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              stretchModes: const [
                StretchMode.zoomBackground,
                StretchMode.blurBackground,
              ],
              background: Stack(
                fit: StackFit.expand,
                children: [
                  if (anime.bannerImage != null || anime.coverImage != null)
                    Hero(
                      tag: 'anime_cover_${anime.id}',
                      child: Image.network(
                        anime.bannerImage ?? anime.coverImage!,
                        fit: BoxFit.cover,
                      ),
                    )
                  else
                    Container(color: primaryColor),
                  // Gradient overlay for text readability
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Colors.black45],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(
                color: Color(0xFFF0F4F8),
                borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title and Score
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            anime.title,
                            style: Theme.of(context).textTheme.headlineSmall
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                          ).animate().fadeIn().slideY(begin: 0.2, end: 0),
                        ),
                        if (anime.averageScore != null)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.amber.shade100,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.star_rounded,
                                  size: 18,
                                  color: Colors.amber,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '${anime.averageScore}%',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.amber,
                                  ),
                                ),
                              ],
                            ),
                          ).animate().scale(delay: 200.ms),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Metadata Pills
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        if (anime.episodes != null)
                          _buildMetadataChip(
                            context,
                            '${anime.episodes} Episodes',
                            Icons.movie_filter_rounded,
                          ),
                        ...anime.genres
                            .take(3)
                            .map(
                              (genre) => _buildMetadataChip(
                                context,
                                genre,
                                Icons.tag_rounded,
                              ),
                            ),
                      ],
                    ).animate().fadeIn(delay: 300.ms),
                    const SizedBox(height: 24),
                    // Action Buttons (Add to List)
                    Row(
                      children: [
                        Expanded(
                          child:
                              ElevatedButton.icon(
                                onPressed: () {},
                                icon: const Icon(Icons.add_rounded),
                                label: const Text('Add to Library'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: primaryColor,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                  elevation: 4,
                                  shadowColor: primaryColor.withValues(
                                    alpha: 0.4,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                              ).animate().shimmer(
                                delay: 1000.ms,
                                duration: 1200.ms,
                              ),
                        ),
                        const SizedBox(width: 12),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.favorite_rounded),
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.redAccent,
                            padding: const EdgeInsets.all(16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    // Synopsis
                    Text(
                      'Synopsis',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      anime.description ??
                          "This anime follows an exciting journey filled with action, drama, and unforgettable moments. Join the characters as they navigate through challenges and discover their true potential. (Placeholder description)",
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.black54,
                        height: 1.5,
                      ),
                    ).animate().fadeIn(delay: 400.ms),
                    const SizedBox(height: 100), // Bottom padding
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetadataChip(BuildContext context, String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.grey[600]),
          const SizedBox(width: 4),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: Colors.grey[800],
            ),
          ),
        ],
      ),
    );
  }
}
