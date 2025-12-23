import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class ExpressiveImage extends StatelessWidget {
  final String? imageUrl;
  final BoxFit fit;
  final double? width;
  final double? height;
  final Color? skeletonColor;

  const ExpressiveImage({
    super.key,
    this.imageUrl,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
    this.skeletonColor,
  });

  @override
  Widget build(BuildContext context) {
    if (imageUrl == null || imageUrl!.isEmpty) {
      return _buildSkeleton();
    }

    return Image.network(
      imageUrl!,
      width: width,
      height: height,
      fit: fit,
      alignment: Alignment.center,
      frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
        if (wasSynchronouslyLoaded) {
          return child;
        }
        return AnimatedSwitcher(
          duration: 500.ms,
          child: frame != null
              ? SizedBox(
                  width: width,
                  height: height,
                  child: child.animate().fadeIn(
                    duration: 500.ms,
                    curve: Curves.easeOut,
                  ),
                )
              : _buildSkeleton(key: const ValueKey('skeleton')),
        );
      },
      errorBuilder: (context, error, stackTrace) {
        return _buildSkeleton();
      },
    );
  }

  Widget _buildSkeleton({Key? key}) {
    final baseColor = skeletonColor ?? Colors.grey[300]!;
    return Container(
          key: key,
          width: width,
          height: height,
          color: baseColor,
          alignment: Alignment.center,
        )
        .animate(onPlay: (controller) => controller.repeat())
        .shimmer(duration: 1500.ms, color: Colors.white.withValues(alpha: 0.3));
  }
}
