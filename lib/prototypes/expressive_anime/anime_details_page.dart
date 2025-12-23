import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'models/anime.dart';
import 'services/mock_data_service.dart';
import 'widgets/expressive_image.dart';

class AnimeDetailsPage extends StatefulWidget {
  final Anime anime;

  const AnimeDetailsPage({super.key, required this.anime});

  @override
  State<AnimeDetailsPage> createState() => _AnimeDetailsPageState();
}

class _AnimeDetailsPageState extends State<AnimeDetailsPage> {
  late Future<Anime?> _fullDetailsFuture;

  @override
  void initState() {
    super.initState();
    _fullDetailsFuture = MockDataService().getAnimeDetails(widget.anime.id);
  }

  @override
  Widget build(BuildContext context) {
    // Parse color or use default black for Manga style
    // final primaryColor = widget.anime.color != null
    //     ? Color(int.parse(widget.anime.color!.replaceAll('#', '0xFF')))
    //     : Colors.black;

    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder<Anime?>(
        future: _fullDetailsFuture,
        builder: (context, snapshot) {
          final anime = snapshot.data ?? widget.anime;

          Color shadowColor = Colors.black;
          if (anime.color != null) {
            try {
              shadowColor = Color(
                int.parse(anime.color!.replaceAll('#', '0xFF')),
              );
            } catch (_) {}
          }

          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 300, // Increased height for the covering effect
                pinned: true,
                stretch: true,
                backgroundColor: Colors.black,
                leading: Container(
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.black, width: 2),
                    boxShadow: const [
                      BoxShadow(color: Colors.black, offset: Offset(2, 2)),
                    ],
                  ),
                  child: IconButton(
                    icon: const Icon(
                      Icons.arrow_back_rounded,
                      color: Colors.black,
                    ),
                    onPressed: () => Navigator.pop(context),
                    padding: EdgeInsets.zero,
                  ),
                ),
                flexibleSpace: FlexibleSpaceBar(
                  stretchModes: const [
                    StretchMode.zoomBackground,
                    StretchMode.blurBackground,
                  ],
                  background: Stack(
                    fit: StackFit.expand,
                    alignment: Alignment.bottomCenter,
                    children: [
                      // Banner Background
                      if (anime.bannerImage != null || anime.coverImage != null)
                        ColorFiltered(
                          colorFilter: const ColorFilter.mode(
                            Colors.grey, // Desaturate banner to make cover pop
                            BlendMode.saturation,
                          ),
                          child: ShaderMask(
                            shaderCallback: (rect) {
                              return LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.black.withValues(alpha: 0.3),
                                  Colors.black.withValues(alpha: 0.8),
                                ],
                              ).createShader(rect);
                            },
                            blendMode: BlendMode.srcOver,
                            child: ExpressiveImage(
                              imageUrl: anime.bannerImage ?? anime.coverImage,
                              fit: BoxFit.cover,
                              skeletonColor: anime.parsedColor,
                            ),
                          ),
                        )
                      else
                        Container(color: Colors.black),

                      // Decoration / Border
                      const DecoratedBox(
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: Colors.black, width: 4),
                          ),
                        ),
                      ),

                      // Hovering Cover Image
                      Positioned(
                        bottom: 40,
                        child: Hero(
                          tag: 'anime_cover_${anime.id}',
                          child: Container(
                            width: 180, // Larger Poster size
                            height: 270,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.white, width: 4),
                              boxShadow: [
                                BoxShadow(
                                  color: shadowColor,
                                  offset: const Offset(8, 8),
                                  blurRadius: 0,
                                ),
                              ],
                            ),
                            child: ExpressiveImage(
                              imageUrl: anime.coverImage,
                              fit: BoxFit.cover,
                              skeletonColor: anime.parsedColor,
                            ),
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
                    color: Colors.white,
                    // No rounded top, maybe just a hard separation
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title and Score
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child:
                                        Text(
                                          anime.title.toUpperCase(),
                                          style: GoogleFonts.teko(
                                            fontSize: 42,
                                            fontWeight: FontWeight.bold,
                                            height: 0.9,
                                            color: Colors.black,
                                          ),
                                        ).animate().fadeIn().slideY(
                                          begin: 0.2,
                                          end: 0,
                                        ),
                                  ),
                                  if (anime.averageScore != null)
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 8,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(
                                          color: Colors.black,
                                          width: 2,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: shadowColor,
                                            offset: const Offset(4, 4),
                                            blurRadius: 0,
                                          ),
                                        ],
                                      ),
                                      child: Row(
                                        children: [
                                          _buildOutlinedStar(18),
                                          const SizedBox(width: 4),
                                          Text(
                                            '${anime.averageScore}%',
                                            style: GoogleFonts.robotoMono(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
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
                                  if (anime.season != null &&
                                      anime.seasonYear != null)
                                    _buildMetadataChip(
                                      context,
                                      '${anime.season} ${anime.seasonYear}',
                                      Icons.calendar_today_rounded,
                                      shadowColor,
                                    ),
                                  if (anime.status != null)
                                    _buildMetadataChip(
                                      context,
                                      anime.status!,
                                      Icons.info_outline_rounded,
                                      shadowColor,
                                    ),
                                  if (anime.studios.isNotEmpty)
                                    _buildMetadataChip(
                                      context,
                                      anime.studios.first.name,
                                      Icons.business_rounded,
                                      shadowColor,
                                    ),
                                  if (anime.episodes != null)
                                    _buildMetadataChip(
                                      context,
                                      '${anime.episodes} Episodes',
                                      Icons.movie_filter_rounded,
                                      shadowColor,
                                    ),
                                  ...anime.genres
                                      .take(3)
                                      .map(
                                        (genre) => _buildMetadataChip(
                                          context,
                                          genre,
                                          Icons.tag_rounded,
                                          shadowColor,
                                        ),
                                      ),
                                ],
                              ).animate().fadeIn(delay: 300.ms),
                              const SizedBox(height: 24),
                              // Action Buttons
                              Row(
                                children: [
                                  Expanded(
                                    child:
                                        ElevatedButton.icon(
                                          onPressed: () {},
                                          icon: const Icon(
                                            Icons.add,
                                            color: Colors.white,
                                          ),
                                          label: Text(
                                            'ADD TO LIBRARY',
                                            style: GoogleFonts.teko(
                                              fontSize: 24,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.black,
                                            foregroundColor: Colors.white,
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 16,
                                            ),
                                            elevation: 0,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.zero, // Sharp
                                              side: const BorderSide(
                                                color: Colors.black,
                                                width: 3,
                                              ),
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
                                    icon: const Icon(Icons.favorite),
                                    style: IconButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      foregroundColor: Colors.black,
                                      padding: const EdgeInsets.all(16),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.zero, // Sharp
                                        side: const BorderSide(
                                          color: Colors.black,
                                          width: 3,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 32),
                              // Synopsis
                              Text(
                                'SYNOPSIS',
                                style: GoogleFonts.teko(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  border: Border(
                                    left: BorderSide(
                                      color: Colors.black,
                                      width: 4,
                                    ),
                                  ),
                                ),
                                child: Text(
                                  anime.description?.replaceAll('<br>', '\n') ??
                                      "No description available.",
                                  style: Theme.of(context).textTheme.bodyLarge
                                      ?.copyWith(
                                        color: Colors.black87,
                                        height: 1.5,
                                        fontFamily:
                                            GoogleFonts.robotoMono().fontFamily,
                                      ),
                                ).animate().fadeIn(delay: 400.ms),
                              ),
                            ],
                          ),
                        ),
                        // Characters Section
                        if (anime.characters.isNotEmpty) ...[
                          const SizedBox(height: 32),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24.0,
                            ),
                            child: Text(
                              'CHARACTERS',
                              style: GoogleFonts.teko(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            height: 180, // Taller for square cards
                            child: ListView.separated(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                              ),
                              scrollDirection: Axis.horizontal,
                              itemCount: anime.characters.length,
                              separatorBuilder: (_, __) =>
                                  const SizedBox(width: 16),
                              itemBuilder: (context, index) {
                                final character = anime.characters[index];
                                return Column(
                                  children: [
                                    Container(
                                      width: 100,
                                      height: 100,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.black,
                                          width: 2,
                                        ),
                                        boxShadow: const [
                                          BoxShadow(
                                            color: Colors.black,
                                            offset: Offset(4, 4),
                                          ),
                                        ],
                                      ),
                                      child: ExpressiveImage(
                                        imageUrl: character.image,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      character.name
                                          .split(' ')
                                          .first
                                          .toUpperCase(),
                                      style: GoogleFonts.teko(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        color: Colors.black,
                                      ),
                                    ),
                                    Text(
                                      character.role.toUpperCase(),
                                      style: GoogleFonts.robotoMono(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey[700],
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                        ],
                        // Relations Section
                        if (anime.relations.isNotEmpty) ...[
                          const SizedBox(height: 32),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24.0,
                            ),
                            child: Text(
                              'RELATIONS',
                              style: GoogleFonts.teko(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            height: 220,
                            child: ListView.separated(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                              ),
                              scrollDirection: Axis.horizontal,
                              itemCount: anime.relations.length,
                              separatorBuilder: (_, __) =>
                                  const SizedBox(width: 16),
                              itemBuilder: (context, index) {
                                final relation = anime.relations[index];
                                final relAnime = relation.anime;
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            AnimeDetailsPage(anime: relAnime),
                                      ),
                                    );
                                  },
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Stack(
                                        children: [
                                          Container(
                                            width: 100,
                                            height: 140,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.zero,
                                              border: Border.all(
                                                color: Colors.black,
                                                width: 3,
                                              ),
                                              boxShadow: const [
                                                BoxShadow(
                                                  color: Colors.black,
                                                  offset: Offset(4, 4),
                                                ),
                                              ],
                                            ),
                                            child: ExpressiveImage(
                                              imageUrl:
                                                  relAnime.coverImage ?? '',
                                              fit: BoxFit.cover,
                                              skeletonColor:
                                                  relAnime.parsedColor,
                                            ),
                                          ),
                                          Positioned(
                                            top: 0,
                                            left: 0,
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 6,
                                                    vertical: 3,
                                                  ),
                                              decoration: BoxDecoration(
                                                color: Colors.black,
                                                borderRadius:
                                                    BorderRadius.zero, // Sharp
                                              ),
                                              child: Text(
                                                relation.relationType
                                                    .replaceAll('_', ' ')
                                                    .toUpperCase(),
                                                style: GoogleFonts.teko(
                                                  color: Colors.white,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      SizedBox(
                                        width: 100,
                                        child: Text(
                                          relAnime.title,
                                          maxLines: 3,
                                          overflow: TextOverflow.ellipsis,
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelSmall
                                              ?.copyWith(
                                                fontWeight: FontWeight.bold,
                                              ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ], // Recommendations Section
                        if (anime.recommendations.isNotEmpty) ...[
                          const SizedBox(height: 32),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24.0,
                            ),
                            child: Text(
                              'RECOMMENDATIONS',
                              style: GoogleFonts.teko(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            height: 200,
                            child: ListView.separated(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                              ),
                              scrollDirection: Axis.horizontal,
                              itemCount: anime.recommendations.length,
                              separatorBuilder: (_, __) =>
                                  const SizedBox(width: 16),
                              itemBuilder: (context, index) {
                                final rec = anime.recommendations[index];
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 100,
                                      height: 140,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.zero,
                                        border: Border.all(
                                          color: Colors.black,
                                          width: 3,
                                        ),
                                        boxShadow: const [
                                          BoxShadow(
                                            color: Colors.black,
                                            offset: Offset(4, 4),
                                          ),
                                        ],
                                      ),
                                      child: ExpressiveImage(
                                        imageUrl: rec.coverImage ?? '',
                                        fit: BoxFit.cover,
                                        skeletonColor: rec.parsedColor,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    SizedBox(
                                      width: 100,
                                      child: Text(
                                        rec.title,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelSmall
                                            ?.copyWith(
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                        ],
                        const SizedBox(height: 50),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildMetadataChip(
    BuildContext context,
    String label,
    IconData icon,
    Color shadowColor,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.zero,
        border: Border.all(color: Colors.black, width: 2),
        boxShadow: [
          BoxShadow(
            color: shadowColor,
            offset: const Offset(2, 2),
            blurRadius: 0,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.black),
          const SizedBox(width: 4),
          Text(
            label.toUpperCase(),
            style: GoogleFonts.robotoMono(
              fontWeight: FontWeight.bold,
              fontSize: 12,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOutlinedStar(double size) {
    return Stack(
      children: [
        Icon(Icons.star, size: size, color: Colors.black),
        Icon(Icons.star_border, size: size, color: Colors.black),
        Positioned(
          top: 1,
          left: 1,
          bottom: 1,
          right: 1,
          child: Icon(Icons.star, size: size - 2, color: Colors.yellow),
        ),
      ],
    );
  }
}
