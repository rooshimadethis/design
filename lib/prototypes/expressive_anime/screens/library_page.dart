import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/mock_data_service.dart';
import '../anime_details_page.dart';
import '../widgets/watching_card.dart';

class LibraryPage extends StatefulWidget {
  const LibraryPage({super.key});

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  late Future<Map<String, List<WatchingEntry>>> _libraryFuture;

  @override
  void initState() {
    super.initState();
    _libraryFuture = MockDataService().getLibraryLists();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, List<WatchingEntry>>>(
      future: _libraryFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator(color: Colors.black)),
          );
        }

        if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
          return const Scaffold(
            backgroundColor: Colors.white,
            body: _EmptyLibraryState(),
          );
        }

        final library = snapshot.data!;
        final listNames = library.keys.toList();

        return DefaultTabController(
          length: listNames.length,
          child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              title: Text(
                'YOUR LIBRARY',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                  fontSize: 32,
                ),
              ),
              bottom: TabBar(
                isScrollable: true,
                indicatorColor: Colors.black,
                indicatorWeight: 4,
                labelColor: Colors.black,
                unselectedLabelColor: Colors.grey,
                labelStyle: GoogleFonts.teko(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
                tabs: listNames
                    .map((name) => Tab(text: name.toUpperCase()))
                    .toList(),
              ),
            ),
            body: TabBarView(
              children: listNames.map((name) {
                final entries = library[name]!;
                return _buildListContent(context, name, entries);
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  Widget _buildListContent(
    BuildContext context,
    String listName,
    List<WatchingEntry> entries,
  ) {
    if (entries.isEmpty) {
      return const _EmptyLibraryState();
    }

    if (listName == 'Watching' || listName == 'Current') {
      return ListView.builder(
        padding: const EdgeInsets.all(24),
        itemCount: entries.length,
        itemBuilder: (context, index) {
          final entry = entries[index];
          return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: WatchingCard(
                  entry: entry,
                  progress: entry.progress,
                  onIncrement: () {
                    // In a real app, this would update state/API
                  },
                  width: double.infinity,
                ),
              )
              .animate(delay: (index * 100).ms)
              .fadeIn()
              .slideX(begin: 0.1, end: 0);
        },
      );
    }
    return GridView.builder(
      padding: const EdgeInsets.all(24),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 24,
        crossAxisSpacing: 24,
        childAspectRatio: 0.65,
      ),
      itemCount: entries.length,
      itemBuilder: (context, index) {
        final entry = entries[index];
        return _buildLibraryCard(context, entry)
            .animate(delay: (index * 50).ms)
            .fadeIn()
            .scale(begin: const Offset(0.9, 0.9), end: const Offset(1, 1));
      },
    );
  }

  Widget _buildLibraryCard(BuildContext context, WatchingEntry entry) {
    final anime = entry.anime;
    Color shadowColor = Colors.black;
    if (anime.color != null) {
      try {
        shadowColor = Color(int.parse(anime.color!.replaceAll('#', '0xFF')));
      } catch (_) {}
    }

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => AnimeDetailsPage(anime: anime),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(width: 3, color: Colors.black),
          boxShadow: [
            BoxShadow(color: shadowColor, offset: const Offset(6, 6)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  anime.coverImage != null
                      ? Image.network(
                          anime.coverImage!,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) =>
                              Container(color: Colors.grey[200]),
                        )
                      : Container(color: Colors.grey[200]),
                  // Progress Badge if watching
                  if (entry.progress > 0)
                    Positioned(
                      bottom: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: Text(
                          'EP ${entry.progress}',
                          style: GoogleFonts.robotoMono(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  // Score Badge
                  if (entry.userScore > 0)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.black, width: 2),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black,
                              offset: Offset(3, 3),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.star,
                              size: 12,
                              color: Colors.black,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${entry.userScore}',
                              style: GoogleFonts.robotoMono(
                                color: Colors.black,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8.0),
              decoration: const BoxDecoration(
                border: Border(top: BorderSide(width: 3, color: Colors.black)),
              ),
              child: Text(
                anime.title.toUpperCase(),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.teko(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  height: 0.9,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyLibraryState extends StatelessWidget {
  const _EmptyLibraryState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: 4),
              color: Colors.white,
              boxShadow: const [
                BoxShadow(color: Colors.black, offset: Offset(8, 8)),
              ],
            ),
            child: Column(
              children: [
                Icon(Icons.auto_stories_outlined, size: 64, color: Colors.black)
                    .animate(onPlay: (controller) => controller.repeat())
                    .shimmer(duration: 2.seconds, color: Colors.grey[200]),
                const SizedBox(height: 16),
                Text(
                  'SCRAPBOOK IS EMPTY',
                  style: GoogleFonts.teko(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'GO EXPLORE AND FIND SOME PEAK FICTION!',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.teko(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ).animate().scale(delay: 200.ms, curve: Curves.elasticOut),
        ],
      ),
    );
  }
}
