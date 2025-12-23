import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/anime.dart';

class MockDataService {
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
}
