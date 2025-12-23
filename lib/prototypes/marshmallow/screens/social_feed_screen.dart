import 'package:flutter_design_tool/prototypes/marshmallow/models/social_feed_models.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SocialFeedScreen extends StatelessWidget {
  const SocialFeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Community',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 32),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(24),
              itemCount: MockSocialData.feedItems.length,
              separatorBuilder: (context, index) => const SizedBox(height: 24),
              itemBuilder: (context, index) {
                final item = MockSocialData.feedItems[index];
                print('Building item $index: ${item.runtimeType}');

                if (item is RatingPost) {
                  return RatingPostCard(post: item);
                } else if (item is ForumPost) {
                  return ForumPostCard(post: item);
                }
                return const Text('Unknown Item Type');
              },
            ),
          ),
        ],
      ),
    );
  }
}

class RatingPostCard extends StatelessWidget {
  final RatingPost post;

  const RatingPostCard({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            offset: const Offset(0, 4),
            blurRadius: 12,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                _buildAvatar(post.author),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      post.author.name,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      'rated ${post.placeName}',
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                    ),
                  ],
                ),
                const Spacer(),
                _buildRatingBadge(context),
              ],
            ),
          ),

          // Image Placeholder (Polaroid Style)
          Container(
            height: 200,
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: Icon(Icons.image, size: 48, color: Colors.grey[400]),
            ),
          ),

          // Review Text
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              post.reviewText,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),

          // Action Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                _buildAction(Icons.favorite_border, 'Like'),
                const SizedBox(width: 16),
                _buildAction(Icons.chat_bubble_outline, 'Comment'),
                const Spacer(),
                Icon(Icons.bookmark_border, color: Colors.grey[400]),
              ],
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildAvatar(SocialUser user) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(color: user.color, shape: BoxShape.circle),
      child: Icon(user.icon, color: Colors.white),
    );
  }

  Widget _buildRatingBadge(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        '${post.rating}/10',
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildAction(IconData icon, String label) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey[600]),
        const SizedBox(width: 4),
        Text(label, style: GoogleFonts.patrickHand(color: Colors.grey[600])),
      ],
    );
  }
}

class ForumPostCard extends StatelessWidget {
  final ForumPost post;

  const ForumPostCard({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF9C4), // Pale yellow sticky note color
        borderRadius: BorderRadius.circular(4), // Sharp corners like paper
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            offset: const Offset(2, 2),
            blurRadius: 4,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Topic Tag
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              post.topic.toUpperCase(),
              style: GoogleFonts.patrickHand(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.0,
                color: Colors.grey[800],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            post.title,
            style: GoogleFonts.patrickHand(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            post.description,
            style: GoogleFonts.patrickHand(
              fontSize: 16,
              color: Colors.grey[800],
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Text(
                '@${post.author.handle.replaceAll('@', '')}',
                style: GoogleFonts.patrickHand(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
              const Spacer(),
              Icon(Icons.arrow_upward, size: 16, color: Colors.grey[600]),
              const SizedBox(width: 4),
              Text(
                '${post.upvoteCount}',
                style: GoogleFonts.patrickHand(color: Colors.grey[600]),
              ),
              const SizedBox(width: 16),
              Icon(
                Icons.chat_bubble_outline,
                size: 16,
                color: Colors.grey[600],
              ),
              const SizedBox(width: 4),
              Text(
                '${post.replyCount}',
                style: GoogleFonts.patrickHand(color: Colors.grey[600]),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
