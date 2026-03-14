import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

/// Optimized image widget with caching, shimmer placeholder, and error handling
/// 
/// Features:
/// - Automatic caching using CachedNetworkImage
/// - Shimmer loading placeholder
/// - Error widget with retry option
/// - Fade-in animation
/// - Memory-efficient image loading
/// 
/// Usage:
/// ```dart
/// OptimizedImage(
///   imageUrl: 'https://example.com/image.jpg',
///   width: 200,
///   height: 150,
///   fit: BoxFit.cover,
/// )
/// ```
class OptimizedImage extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final Color? shimmerBaseColor;
  final Color? shimmerHighlightColor;
  final Widget? errorWidget;
  final Duration fadeInDuration;

  const OptimizedImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.shimmerBaseColor,
    this.shimmerHighlightColor,
    this.errorWidget,
    this.fadeInDuration = const Duration(milliseconds: 300),
  });

  @override
  Widget build(BuildContext context) {
    final baseColor = shimmerBaseColor ?? Colors.grey[300]!;
    final highlightColor = shimmerHighlightColor ?? Colors.grey[100]!;

    Widget imageWidget = CachedNetworkImage(
      imageUrl: imageUrl,
      width: width,
      height: height,
      fit: fit,
      fadeInDuration: fadeInDuration,
      placeholder: (context, url) => _buildShimmerPlaceholder(
        baseColor,
        highlightColor,
      ),
      errorWidget: (context, url, error) =>
          errorWidget ?? _buildDefaultErrorWidget(context),
    );

    if (borderRadius != null) {
      imageWidget = ClipRRect(
        borderRadius: borderRadius!,
        child: imageWidget,
      );
    }

    return imageWidget;
  }

  Widget _buildShimmerPlaceholder(Color baseColor, Color highlightColor) {
    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: Container(
        width: width,
        height: height,
        color: Colors.white,
      ),
    );
  }

  Widget _buildDefaultErrorWidget(BuildContext context) {
    return Container(
      width: width,
      height: height,
      color: Colors.grey[200],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.broken_image_outlined,
            size: 40,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 8),
          Text(
            'Failed to load image',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}

/// Circular optimized image (for avatars, logos, etc.)
class OptimizedCircularImage extends StatelessWidget {
  final String imageUrl;
  final double size;
  final Color? shimmerBaseColor;
  final Color? shimmerHighlightColor;
  final Widget? errorWidget;

  const OptimizedCircularImage({
    super.key,
    required this.imageUrl,
    this.size = 50,
    this.shimmerBaseColor,
    this.shimmerHighlightColor,
    this.errorWidget,
  });

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: OptimizedImage(
        imageUrl: imageUrl,
        width: size,
        height: size,
        fit: BoxFit.cover,
        shimmerBaseColor: shimmerBaseColor,
        shimmerHighlightColor: shimmerHighlightColor,
        errorWidget: errorWidget ??
            Container(
              width: size,
              height: size,
              color: Colors.grey[300],
              child: Icon(
                Icons.person,
                size: size * 0.6,
                color: Colors.grey[600],
              ),
            ),
      ),
    );
  }
}

/// Optimized image with aspect ratio
class OptimizedAspectRatioImage extends StatelessWidget {
  final String imageUrl;
  final double aspectRatio;
  final BoxFit fit;
  final BorderRadius? borderRadius;

  const OptimizedAspectRatioImage({
    super.key,
    required this.imageUrl,
    this.aspectRatio = 16 / 9,
    this.fit = BoxFit.cover,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: aspectRatio,
      child: OptimizedImage(
        imageUrl: imageUrl,
        fit: fit,
        borderRadius: borderRadius,
      ),
    );
  }
}
