import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'models/anime.dart';
import 'models/user_profile.dart';
import 'services/mock_data_service.dart';
import 'anime_details_page.dart';
import 'screens/library_page.dart';
import 'widgets/watching_card.dart';

class ExpressiveApp extends StatelessWidget {
  const ExpressiveApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.black,
          primary: Colors.black,
          secondary: Colors.red[900], // Manga blood red
          surface: Colors.white,
          brightness: Brightness.light,
        ),
        textTheme: GoogleFonts.bangersTextTheme().copyWith(
          // Using Teko for that "Shonen Jump" title feel
          headlineMedium: GoogleFonts.teko(
            fontSize: 36, // Larger for drama
            fontWeight: FontWeight.w700,
            letterSpacing: 1.2,
            color: Colors.black,
          ),
          titleLarge: GoogleFonts.teko(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontStyle: FontStyle.italic, // Action-y
          ),
          titleMedium: GoogleFonts.roboto(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
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
  String? _libraryInitialTab;
  Key _libraryKey = const PageStorageKey('library_page');

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
      backgroundColor: Colors.white,
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
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 20),
                                  Text(
                                    '$greeting, $name',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineMedium
                                        ?.copyWith(
                                          color: Colors.black,
                                          fontSize: 32,
                                          fontStyle: FontStyle.italic,
                                        ),
                                  ),
                                  const SizedBox(height: 4),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 2,
                                    ),
                                    color: Colors.black,
                                    child: Text(
                                      'Let\'s find some anime.',
                                      style: GoogleFonts.teko(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 2.0,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              width: 16,
                            ), // Spacing between text and avatar
                            if (avatarUrl != null && avatarUrl.isNotEmpty)
                              Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.rectangle, // Square avatar
                                  border: Border.all(
                                    color: Colors.black,
                                    width: 3,
                                  ),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.black,
                                      blurRadius: 0,
                                      offset: Offset(4, 4),
                                    ),
                                  ],
                                ),
                                child: Image.network(
                                  avatarUrl,
                                  width: 56,
                                  height: 56,
                                  fit: BoxFit.cover,
                                ),
                              ),
                          ],
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 32),
                  // Watching Section
                  // Watching Section
                  _buildSectionTitle(
                    context,
                    'Continue Watching',
                    onPressed: () {
                      setState(() {
                        _libraryInitialTab = 'Watching';
                        _selectedIndex = 2;
                        _libraryKey = UniqueKey();
                      });
                    },
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
                            child: CircularProgressIndicator(
                              color: Colors.black,
                            ),
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
                  // Trending Section
                  _buildSectionTitle(
                    context,
                    'Trending Now',
                    // Button removed as per request
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
                            child: CircularProgressIndicator(
                              color: Colors.black,
                            ),
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
                    'SEARCH',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
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
                    style: GoogleFonts.robotoMono(fontWeight: FontWeight.bold),
                    decoration: InputDecoration(
                      hintText: 'FIND MANGA...',
                      hintStyle: GoogleFonts.teko(
                        fontSize: 20,
                        color: Colors.grey,
                      ),
                      prefixIcon: const Icon(
                        Icons.search_rounded,
                        color: Colors.black,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.zero,
                        borderSide: const BorderSide(
                          color: Colors.black,
                          width: 3,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.zero,
                        borderSide: const BorderSide(
                          color: Colors.black,
                          width: 4,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 16,
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
                            child: CircularProgressIndicator(
                              color: Colors.black,
                            ),
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
          LibraryPage(key: _libraryKey, initialTabName: _libraryInitialTab),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: NavigationBarTheme(
          data: NavigationBarThemeData(
            labelTextStyle: WidgetStateProperty.all(
              GoogleFonts.teko(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
                color: Colors.black,
              ),
            ),
            iconTheme: WidgetStateProperty.all(
              IconThemeData(color: Colors.black),
            ),
          ),
          child: NavigationBar(
            // height: 50,
            selectedIndex: _selectedIndex,
            onDestinationSelected: (index) => setState(() {
              _selectedIndex = index;
              if (index != 2) {
                _libraryInitialTab = null;
              }
            }),
            elevation: 0,
            backgroundColor: Colors.white,
            indicatorColor:
                Colors.grey[300], // Softer indicator for manga style
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.home_outlined),
                selectedIcon: Icon(Icons.home_filled),
                label: 'HOME',
              ),
              NavigationDestination(
                icon: Icon(Icons.search_outlined),
                selectedIcon: Icon(Icons.search),
                label: 'EXPLORE',
              ),
              NavigationDestination(
                icon: Icon(Icons.video_library_outlined),
                selectedIcon: Icon(Icons.video_library),
                label: 'LIBRARY',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(
    BuildContext context,
    String title, {
    VoidCallback? onPressed,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.black,
              border: Border.all(color: Colors.black, width: 2),
            ),
            child: Text(
              title.toUpperCase(),
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Colors.white,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
          if (onPressed != null)
            TextButton(
              onPressed: onPressed,
              child: Text(
                'See All >',
                style: GoogleFonts.teko(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.black,
                ),
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

  Widget _buildAnimeCard(BuildContext context, Anime anime) {
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
        width: 180,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(width: 3, color: Colors.black),
          borderRadius: BorderRadius.zero,
          boxShadow: [
            BoxShadow(
              color: shadowColor,
              blurRadius: 0,
              offset: const Offset(8, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Hero(
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
                  if (anime.averageScore != null)
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black,
                          border: Border.all(color: Colors.white, width: 2),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black,
                              offset: Offset(2, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _buildOutlinedStar(12),
                            const SizedBox(width: 4),
                            Text(
                              '${anime.averageScore}%',
                              style: GoogleFonts.robotoMono(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                color: Colors.white,
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
              padding: const EdgeInsets.all(12.0),
              decoration: const BoxDecoration(
                border: Border(top: BorderSide(width: 3, color: Colors.black)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    anime.title.toUpperCase(),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.teko(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      height: 0.9,
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
