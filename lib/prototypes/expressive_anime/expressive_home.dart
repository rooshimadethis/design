import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'models/anime.dart';
import 'models/user_profile.dart';
import 'services/mock_data_service.dart';
import 'anime_details_page.dart';

class ExpressiveApp extends StatelessWidget {
  const ExpressiveApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFFF4081), // Vibrant Pink
          brightness: Brightness.light,
        ),
        textTheme: GoogleFonts.outfitTextTheme(),
      ),
      home: const ExpressiveHomePage(),
    );
  }
}

class ExpressiveHomePage extends StatefulWidget {
  const ExpressiveHomePage({super.key});

  @override
  State<ExpressiveHomePage> createState() => _ExpressiveHomePageState();
}

class _ExpressiveHomePageState extends State<ExpressiveHomePage> {
  int _selectedIndex = 0;
  final Map<int, int> _progressOverrides = {};
  String _searchQuery = 'naruto';
  final TextEditingController _searchController = TextEditingController(
    text: 'naruto',
  );

  late Future<UserProfile> _profileFuture;
  late Future<List<WatchingEntry>> _watchingFuture;
  late Future<List<Anime>> _trendingFuture;
  late Future<List<Anime>> _searchFuture;

  @override
  void initState() {
    super.initState();
    _profileFuture = MockDataService().getUserProfile();
    _watchingFuture = MockDataService().getWatchingList();
    _trendingFuture = MockDataService().getTrendingAnime();
    _searchFuture = MockDataService().searchAnime(_searchQuery);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _incrementProgress(int entryId, int currentProgress) {
    // TODO: Stub - In a real app, this would call an API to update progress
    setState(() {
      _progressOverrides[entryId] = currentProgress + 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F8),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: FutureBuilder<UserProfile>(
                      future: _profileFuture,
                      builder: (context, snapshot) {
                        final user = snapshot.data;
                        final name = user?.name ?? 'Guest';
                        final avatarUrl = user?.avatarLarge;

                        final hour = DateTime.now().hour;
                        final greeting = hour < 12
                            ? 'Good Morning'
                            : hour < 17
                            ? 'Good Afternoon'
                            : 'Good Evening';

                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 20),
                                Text(
                                  '$greeting, $name!',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                        fontSize: 24,
                                      ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Let\'s find some anime.',
                                  style: Theme.of(context).textTheme.titleMedium
                                      ?.copyWith(color: Colors.black54),
                                ),
                              ],
                            ),
                            if (avatarUrl != null && avatarUrl.isNotEmpty)
                              Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 2,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(
                                        alpha: 0.1,
                                      ),
                                      blurRadius: 8,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: CircleAvatar(
                                  radius: 24,
                                  backgroundImage: NetworkImage(avatarUrl),
                                  backgroundColor: Colors.grey[200],
                                ),
                              ),
                          ],
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 32),
                  // Watching Section
                  _buildSectionTitle(
                    context,
                    'Continue Watching',
                  ).animate().fadeIn(delay: 100.ms).slideX(begin: -0.2, end: 0),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 220, // Slightly shorter for watching cards
                    child: FutureBuilder<List<WatchingEntry>>(
                      future: _watchingFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        final entries = snapshot.data ?? [];
                        return ListView.separated(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          scrollDirection: Axis.horizontal,
                          itemCount: entries.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(width: 16),
                          itemBuilder: (context, index) {
                            final entry = entries[index];
                            final progress =
                                _progressOverrides[entry.id] ?? entry.progress;
                            return WatchingCard(
                                  entry: entry,
                                  progress: progress,
                                  onIncrement: () =>
                                      _incrementProgress(entry.id, progress),
                                )
                                .animate(delay: (index * 100).ms)
                                .fadeIn()
                                .slideX(begin: 0.2, end: 0);
                          },
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 32),
                  // Trending Section
                  _buildSectionTitle(
                    context,
                    'Trending Now',
                  ).animate().fadeIn(delay: 200.ms).slideX(begin: -0.2, end: 0),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 280,
                    child: FutureBuilder<List<Anime>>(
                      future: _trendingFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        final animeList = snapshot.data ?? [];
                        return ListView.separated(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          scrollDirection: Axis.horizontal,
                          itemCount: animeList.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(width: 16),
                          itemBuilder: (context, index) {
                            return _buildAnimeCard(context, animeList[index])
                                .animate(delay: (300 + index * 100).ms)
                                .fadeIn()
                                .slideX(begin: 0.2, end: 0);
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Search Page
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Search',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _searchController,
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value.isEmpty ? 'naruto' : value;
                        _searchFuture = MockDataService().searchAnime(
                          _searchQuery,
                        );
                      });
                    },
                    decoration: InputDecoration(
                      hintText: 'Search anime...',
                      prefixIcon: const Icon(Icons.search_rounded),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Expanded(
                    child: FutureBuilder<List<Anime>>(
                      future: _searchFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        final animeList = snapshot.data ?? [];
                        return GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: 16,
                                crossAxisSpacing: 16,
                                childAspectRatio: 0.7,
                              ),
                          itemCount: animeList.length,
                          itemBuilder: (context, index) {
                            return _buildAnimeCard(context, animeList[index]);
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Center(child: Text("Library Page")),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) =>
            setState(() => _selectedIndex = index),
        elevation: 0,
        backgroundColor: Colors.white,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.search_outlined),
            selectedIcon: Icon(Icons.search_rounded),
            label: 'Explore',
          ),
          NavigationDestination(
            icon: Icon(Icons.video_library_outlined),
            selectedIcon: Icon(Icons.video_library_rounded),
            label: 'Library',
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          TextButton(onPressed: () {}, child: const Text('See All')),
        ],
      ),
    );
  }

  Widget _buildAnimeCard(BuildContext context, Anime anime) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => AnimeDetailsPage(anime: anime),
          ),
        );
      },
      child: Container(
        width: 160,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color:
                  (anime.color != null
                          ? Color(
                              int.parse(anime.color!.replaceAll('#', '0xFF')),
                            )
                          : Colors.grey)
                      .withValues(alpha: 0.2),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(24),
                ),
                child: Hero(
                  tag: 'anime_cover_${anime.id}',
                  child: anime.coverImage != null
                      ? Image.network(
                          anime.coverImage!,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            color: Colors.grey[200],
                            child: const Icon(Icons.broken_image),
                          ),
                        )
                      : Container(color: Colors.grey[200]),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    anime.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (anime.averageScore != null) ...[
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.star_rounded,
                          size: 16,
                          color: Colors.amber,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${anime.averageScore}%',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: Colors.grey[600],
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class WatchingCard extends StatefulWidget {
  final WatchingEntry entry;
  final int progress;
  final VoidCallback onIncrement;

  const WatchingCard({
    super.key,
    required this.entry,
    required this.progress,
    required this.onIncrement,
  });

  @override
  State<WatchingCard> createState() => _WatchingCardState();
}

class _WatchingCardState extends State<WatchingCard> {
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 1),
    );
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Calculate progress as a fraction (assuming 12, 24, etc episodes if available,
    // else just show a bar that fills up somewhat arbitrarily or based on strict logic)
    // The JSON provided has 'episodes', so we can use that.
    final totalEpisodes = widget.entry.anime.episodes ?? 12; // fallback
    final progressFraction = (widget.progress / totalEpisodes).clamp(0.0, 1.0);

    // Check if there is a next episode
    final hasNext = widget.progress < totalEpisodes;

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => AnimeDetailsPage(anime: widget.entry.anime),
          ),
        );
      },
      child: Container(
        width: 280, // Wider card for watching status
        margin: const EdgeInsets.only(bottom: 8), // For shadow
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color:
                  (widget.entry.anime.color != null
                          ? Color(
                              int.parse(
                                widget.entry.anime.color!.replaceAll(
                                  '#',
                                  '0xFF',
                                ),
                              ),
                            )
                          : Colors.grey)
                      .withValues(alpha: 0.2),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            // Image Section
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(24),
                bottomLeft: Radius.circular(24),
              ),
              child: Hero(
                tag: 'watching_${widget.entry.id}',
                child: SizedBox(
                  width: 100,
                  height: double.infinity,
                  child: widget.entry.anime.coverImage != null
                      ? Image.network(
                          widget.entry.anime.coverImage!,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            color: Colors.grey[200],
                            child: const Icon(Icons.broken_image),
                          ),
                        )
                      : Container(color: Colors.grey[200]),
                ),
              ),
            ),
            // Info Section
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.entry.anime.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Episode ${widget.progress + 1}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Progress Bar
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: progressFraction,
                        backgroundColor: Colors.grey[100],
                        color: Theme.of(context).colorScheme.primary,
                        minHeight: 6,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Plus Button
            if (hasNext)
              Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    ConfettiWidget(
                      confettiController: _confettiController,
                      blastDirectionality: BlastDirectionality.explosive,
                      shouldLoop: false,
                      gravity: 0.2, // Float down slowly
                      numberOfParticles: 10,
                      maxBlastForce: 5,
                      minBlastForce: 2,
                      colors: const [
                        Colors.green,
                        Colors.blue,
                        Colors.pink,
                        Colors.orange,
                        Colors.purple,
                      ], // manually specify colors
                    ),
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          widget.onIncrement();
                          _confettiController.play();
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Theme.of(
                              context,
                            ).colorScheme.primaryContainer,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.add_rounded,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
