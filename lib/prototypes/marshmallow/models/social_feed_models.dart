import 'package:flutter/material.dart';

enum PostType { rating, forum }

class SocialUser {
  final String name;
  final String handle;
  final IconData icon; // Placeholder for avatar image
  final Color color;

  SocialUser({
    required this.name,
    required this.handle,
    required this.icon,
    required this.color,
  });
}

abstract class FeedItem {
  final String id;
  final SocialUser author;
  final DateTime timestamp;

  FeedItem({required this.id, required this.author, required this.timestamp});
}

class RatingPost extends FeedItem {
  final String placeName;
  final String imageUrl; // For prototype we can use a color or icon if no URL
  final double rating; // 1.0 to 10.0
  final String reviewText;

  RatingPost({
    required super.id,
    required super.author,
    required super.timestamp,
    required this.placeName,
    required this.imageUrl,
    required this.rating,
    required this.reviewText,
  });
}

class ForumPost extends FeedItem {
  final String title;
  final String description;
  final String topic; // e.g., "Meta", "Discussion", "Question"
  final int replyCount;
  final int upvoteCount;

  ForumPost({
    required super.id,
    required super.author,
    required super.timestamp,
    required this.title,
    required this.description,
    required this.topic,
    required this.replyCount,
    required this.upvoteCount,
  });
}

class MockSocialData {
  static final SocialUser _userAlice = SocialUser(
    name: 'Alice M.',
    handle: '@alicem',
    icon: Icons.face_3,
    color: Colors.pink.shade100,
  );

  static final SocialUser _userBob = SocialUser(
    name: 'Bob Ross',
    handle: '@happytrees',
    icon: Icons.face_6,
    color: Colors.blue.shade100,
  );

  static final SocialUser _userCharlie = SocialUser(
    name: 'Charlie',
    handle: '@charlie_eats',
    icon: Icons.face_4,
    color: Colors.green.shade100,
  );

  static List<FeedItem> get feedItems => [
    RatingPost(
      id: '1',
      author: _userAlice,
      timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
      placeName: 'The Fluffy Cloud Cafe',
      imageUrl: '', // Placeholder
      rating: 9.5,
      reviewText:
          'Absolutely divine! The marshmallows were homemade and tasted like vanilla clouds.',
    ),
    ForumPost(
      id: '2',
      author: _userBob,
      timestamp: DateTime.now().subtract(const Duration(hours: 1)),
      title: 'Best cocoa powder brand?',
      description:
          'I\'m trying to up my homemade hot chocolate game. Does anyone have recommendations for a rich, dark cocoa powder that isn\'t too bitter?',
      topic: 'Discussion',
      replyCount: 12,
      upvoteCount: 45,
    ),
    RatingPost(
      id: '3',
      author: _userCharlie,
      timestamp: DateTime.now().subtract(const Duration(hours: 3)),
      placeName: 'Downtown Grind',
      imageUrl: '',
      rating: 6.0,
      reviewText:
          'It was okay. The cocoa was a bit watery, but the atmosphere was nice.',
    ),
    ForumPost(
      id: '4',
      author: _userAlice,
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
      title: 'Recipe: Spicy Mexican Hot Chocolate',
      description:
          'Just discovered adding a pinch of cayenne pepper makes all the difference! Here is my secret recipe...',
      topic: 'Recipe',
      replyCount: 8,
      upvoteCount: 32,
    ),
  ];
}
