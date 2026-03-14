import 'dart:io';
import 'package:teacher_app/core/utils/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_svg/flutter_svg.dart';

extension ImageTypeExtension on String {
  ImageType get imageType {
    if (startsWith('http') || startsWith('https')) {
      if (endsWith('.svg')) {
        return ImageType.networkSvg;
      }
      return ImageType.network;
    } else if (endsWith('.svg')) {
      return ImageType.svg;
    } else if (startsWith('file://')) {
      return ImageType.file;
    } else {
      return ImageType.png;
    }
  }
}

enum ImageType { svg, png, network, networkSvg, file, unknown }

class CustomImageView extends StatelessWidget {
  const CustomImageView({
    super.key,
    this.imagePath,
    this.height,
    this.width,
    this.color,
    this.fit,
    this.alignment,
    this.onTap,
    this.radius,
    this.margin,
    this.border,
    this.placeHolder,
    this.placeholderIcon,
    this.placeholderIconSize,
    this.placeholderIconColor,
    this.placeholderBackgroundColor,
  });

  ///[imagePath] is required parameter for showing image
  final String? imagePath;

  final double? height;

  final double? width;

  final Color? color;

  final BoxFit? fit;

  final String? placeHolder;

  /// Icon to show when image is not available
  final IconData? placeholderIcon;

  /// Size of the placeholder icon
  final double? placeholderIconSize;

  /// Color of the placeholder icon
  final Color? placeholderIconColor;

  /// Background color for placeholder
  final Color? placeholderBackgroundColor;

  final Alignment? alignment;

  final VoidCallback? onTap;

  final EdgeInsetsGeometry? margin;

  final BorderRadius? radius;

  final BoxBorder? border;

  /// Check if image path is valid
  bool get _hasValidImage =>
      imagePath != null &&
      imagePath!.isNotEmpty &&
      imagePath != 'null' &&
      !imagePath!.contains('null');

  @override
  Widget build(BuildContext context) {
    return alignment != null
        ? Align(alignment: alignment!, child: _buildWidget())
        : _buildWidget();
  }

  Widget _buildWidget() {
    return Padding(
      padding: margin ?? EdgeInsets.zero,
      child: InkWell(onTap: onTap, child: _buildCircleImage()),
    );
  }

  ///build the image with border radius
  dynamic _buildCircleImage() {
    if (radius != null) {
      return ClipRRect(
        borderRadius: radius ?? BorderRadius.zero,
        child: _buildImageWithBorder(),
      );
    } else {
      return _buildImageWithBorder();
    }
  }

  ///build the image with border and border radius style
  Widget _buildImageWithBorder() {
    if (border != null) {
      return Container(
        decoration: BoxDecoration(border: border, borderRadius: radius),
        child: _buildImageView(),
      );
    } else {
      return _buildImageView();
    }
  }

  /// Build placeholder widget with icon
  Widget _buildPlaceholderWidget() {
    // Calculate icon size safely
    double iconSize = placeholderIconSize ?? 40;
    if (placeholderIconSize == null && height != null && height!.isFinite) {
      iconSize = height! * 0.5;
    }

    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color:
            placeholderBackgroundColor ??
            AppColors.primary.withValues(alpha: 0.1),
        borderRadius: radius,
      ),
      child: Center(
        child: Icon(
          placeholderIcon ?? Icons.business,
          size: iconSize,
          color:
              placeholderIconColor ?? AppColors.primary.withValues(alpha: 0.5),
        ),
      ),
    );
  }

  Widget _buildImageView() {
    // If no valid image, show placeholder
    if (!_hasValidImage) {
      return _buildPlaceholderWidget();
    }

    switch (imagePath!.imageType) {
      case ImageType.svg:
        return SizedBox(
          height: height,
          width: width,
          child: SvgPicture.asset(
            imagePath!,
            height: height,
            width: width,
            fit: fit ?? BoxFit.contain,
            colorFilter: color != null
                ? ColorFilter.mode(color ?? Colors.transparent, BlendMode.srcIn)
                : null,
          ),
        );
      case ImageType.file:
        return Image.file(
          File(imagePath!),
          height: height,
          width: width,
          fit: fit ?? BoxFit.cover,
          color: color,
        );
      case ImageType.networkSvg:
        return SvgPicture.network(
          imagePath!,
          height: height,
          width: width,
          fit: fit ?? BoxFit.contain,
          colorFilter: color != null
              ? ColorFilter.mode(color ?? Colors.transparent, BlendMode.srcIn)
              : null,
        );
      case ImageType.network:
        return CachedNetworkImage(
          height: height,
          width: width,
          fit: fit,
          imageUrl: imagePath!,
          color: color,
          placeholder: (context, url) => SizedBox(
            height: 30,
            width: 30,
            child: LinearProgressIndicator(
              color: AppColors.primary.withValues(alpha: 0.1),
              backgroundColor: AppColors.primary.withValues(alpha: 0.1),
            ),
          ),
          errorWidget: (context, url, error) => _buildPlaceholderWidget(),
        );
      case ImageType.png:
      default:
        return Image.asset(
          imagePath!,
          height: height,
          width: width,
          fit: fit ?? BoxFit.cover,
          color: color,
        );
    }
  }
}
