import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/anime.dart';

class WatchingEntry {
  final Anime anime;
  final int progress;
  final int id; // The entry ID, not media ID

  WatchingEntry({
    required this.anime,
    required this.progress,
    required this.id,
  });
}

class MockDataService {
  Future<List<WatchingEntry>> getWatchingList() async {
    final jsonString = await rootBundle.loadString(
      'assets/anilist_data/user_watching_list.json',
    );
    final Map<String, dynamic> json = jsonDecode(jsonString);
    final List<dynamic> lists = json['data']['MediaListCollection']['lists'];

    // Find the "Watching" list
    final watchingList = lists.firstWhere(
      (list) => list['name'] == 'Watching',
      orElse: () => {'entries': []},
    );

    final List<dynamic> entries = watchingList['entries'];
    return entries.map((e) {
      return WatchingEntry(
        id: e['id'],
        progress: e['progress'],
        anime: Anime.fromJson(e['media']),
      );
    }).toList();
  }

  Future<List<Anime>> getTrendingAnime() async {
    final jsonString = await rootBundle.loadString(
      'assets/anilist_data/home_feed.json',
    );
    final Map<String, dynamic> json = jsonDecode(jsonString);
    final List<dynamic> media = json['data']['trending']['media'];
    return media.map((e) => Anime.fromJson(e)).toList();
  }

  Future<List<Anime>> getPopularAnime() async {
    final jsonString = await rootBundle.loadString(
      'assets/anilist_data/home_feed.json',
    );
    final Map<String, dynamic> json = jsonDecode(jsonString);
    final List<dynamic> media = json['data']['popular']['media'];
    return media.map((e) => Anime.fromJson(e)).toList();
  }

  Future<Anime?> getAnimeDetails(int id) async {
    // Determine which file to load based on the ID
    String fileName = 'media_details_aot.json'; // Default
    if (id == 186794) {
      fileName = 'media_details_frieren.json'; // Just for testing
    }
    // In a real app, we'd have a mapping or fetch from API

    try {
      final jsonString = await rootBundle.loadString(
        'assets/anilist_data/$fileName',
      );
      final Map<String, dynamic> json = jsonDecode(jsonString);
      return Anime.fromJson(json['data']['Media']);
    } catch (e) {
      return null;
    }
  }

  Future<List<Anime>> searchAnime(String query) async {
    // Only mocks Naruto results for now
    final jsonString = await rootBundle.loadString(
      'assets/anilist_data/search_results_naruto.json',
    );
    final Map<String, dynamic> json = jsonDecode(jsonString);
    final List<dynamic> media = json['data']['Page']['media'];
    return media.map((e) => Anime.fromJson(e)).toList();
  }
}
