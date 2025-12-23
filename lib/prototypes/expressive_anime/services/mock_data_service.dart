import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import '../models/anime.dart';
import '../models/user_profile.dart';

class WatchingEntry {
  final Anime anime;
  final int progress;
  final int userScore;
  final int id; // The entry ID, not media ID

  WatchingEntry({
    required this.anime,
    required this.progress,
    required this.userScore,
    required this.id,
  });
}

class MockDataService {
  Future<UserProfile> getUserProfile() async {
    final jsonString = await rootBundle.loadString(
      'assets/anilist_data/viewer_data.json',
    );
    final Map<String, dynamic> json = jsonDecode(jsonString);
    return UserProfile.fromJson(json['data']['Viewer']);
  }

  Future<List<WatchingEntry>> getWatchingList() async {
    final jsonString = await rootBundle.loadString(
      'assets/anilist_data/viewer_data.json',
    );
    final Map<String, dynamic> json = jsonDecode(jsonString);
    final List<dynamic> lists = json['data']['MediaListCollection']['lists'];

    // Find the "Watching" list
    final watchingList = lists.firstWhere(
      (list) => list['name'] == 'Watching' || list['name'] == 'Current',
      orElse: () => null,
    );

    if (watchingList == null) return [];

    final List<dynamic> entries = watchingList['entries'];
    return entries.map((e) {
      return WatchingEntry(
        id: e['id'],
        progress: e['progress'] ?? 0,
        userScore: e['score'] ?? 0,
        anime: Anime.fromJson(e['media']),
      );
    }).toList();
  }

  Future<Map<String, List<WatchingEntry>>> getLibraryLists() async {
    final jsonString = await rootBundle.loadString(
      'assets/anilist_data/viewer_data.json',
    );
    final Map<String, dynamic> json = jsonDecode(jsonString);
    final List<dynamic> lists = json['data']['MediaListCollection']['lists'];

    final Map<String, List<WatchingEntry>> library = {};

    for (var list in lists) {
      final String name = list['name'];
      final List<dynamic> entries = list['entries'];
      library[name] = entries.map((e) {
        return WatchingEntry(
          id: e['id'],
          progress: e['progress'] ?? 0,
          userScore: e['score'] ?? 0,
          anime: Anime.fromJson(e['media']),
        );
      }).toList();
    }

    return library;
  }

  Future<List<Anime>> getTrendingAnime() async {
    final jsonString = await rootBundle.loadString(
      'assets/anilist_data/home_data.json',
    );
    final Map<String, dynamic> json = jsonDecode(jsonString);
    final List<dynamic> media = json['data']['trending']['media'];
    return media.map((e) => Anime.fromJson(e)).toList();
  }

  // Popular list removed as requested to reduce load

  Future<Anime?> getAnimeDetails(int id) async {
    // Determine which file to load based on the ID
    String fileName;

    if (id == 20) {
      fileName = 'media_details_naruto.json';
    } else if (id == 1735) {
      fileName = 'media_details_naruto_shippuden.json';
    } else if (id == 154587) {
      fileName = 'media_details_frieren.json';
    } else if (id == 21) {
      fileName = 'media_details_one_piece.json';
    } else {
      // Fallback for testing generic clicks, default to Naruto for robust details
      fileName = 'media_details_naruto.json';
    }

    try {
      final jsonString = await rootBundle.loadString(
        'assets/anilist_data/$fileName',
      );
      final Map<String, dynamic> json = jsonDecode(jsonString);
      return Anime.fromJson(json['data']['Media']);
    } catch (e) {
      debugPrint('Error loading details for ID $id: $e');
      return null;
    }
  }

  Future<List<Anime>> searchAnime(String query) async {
    // Determine which mock file to use based on query
    String fileName = 'search_results_naruto.json';

    // Simple mock logic for testing filters
    if (query.toLowerCase().contains('2023') ||
        query.toLowerCase().contains('winter')) {
      fileName = 'search_results_2023_winter.json';
    }

    try {
      final jsonString = await rootBundle.loadString(
        'assets/anilist_data/$fileName',
      );
      final Map<String, dynamic> json = jsonDecode(jsonString);
      // Handle the slightly different structure if necessary, but usually Page -> media
      final List<dynamic> media = json['data']['Page']['media'];
      return media.map((e) => Anime.fromJson(e)).toList();
    } catch (e) {
      debugPrint('Error searching anime: $e');
      return [];
    }
  }

  /// Get the names of all available lists from the user's library
  Future<List<String>> getAvailableListNames() async {
    final jsonString = await rootBundle.loadString(
      'assets/anilist_data/viewer_data.json',
    );
    final Map<String, dynamic> json = jsonDecode(jsonString);
    final List<dynamic> lists = json['data']['MediaListCollection']['lists'];

    return lists.map((list) => list['name'] as String).toList();
  }

  /// Check if an anime is in the user's library and return the entry
  Future<WatchingEntry?> getMediaListEntry(int animeId) async {
    final jsonString = await rootBundle.loadString(
      'assets/anilist_data/viewer_data.json',
    );
    final Map<String, dynamic> json = jsonDecode(jsonString);
    final List<dynamic> lists = json['data']['MediaListCollection']['lists'];

    for (var list in lists) {
      final List<dynamic> entries = list['entries'];
      for (var entry in entries) {
        if (entry['media']['id'] == animeId) {
          return WatchingEntry(
            id: entry['id'],
            progress: entry['progress'] ?? 0,
            userScore: entry['score'] ?? 0,
            anime: Anime.fromJson(entry['media']),
          );
        }
      }
    }
    return null;
  }

  /// Save or update a media list entry (mock mutation)
  /// In a real app, this would call the AniList API
  Future<void> saveMediaListEntry(
    int animeId,
    String listName,
    int progress,
  ) async {
    debugPrint(
      'Mock mutation: Saving anime $animeId to list "$listName" with progress $progress',
    );
    // In a real implementation, this would make an API call
    // For now, we just log the action
  }

  /// Update episode progress with auto-status logic
  /// Automatically moves to COMPLETED when all episodes are watched
  Future<void> updateEpisodeProgress(
    int animeId,
    int progress,
    int? totalEpisodes,
  ) async {
    String targetList = 'Current';

    // Auto-update to Completed if all episodes are watched
    if (totalEpisodes != null && progress >= totalEpisodes) {
      targetList = 'Completed';
    }

    debugPrint(
      'Mock mutation: Updating anime $animeId progress to $progress (target list: $targetList)',
    );
    // In a real implementation, this would make an API call
  }
}
