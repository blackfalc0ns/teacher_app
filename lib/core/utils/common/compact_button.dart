import 'package:flutter/material.dart';
import '../constant/font_manger.dart';
import '../constant/styles_manger.dart';
import '../theme/app_colors.dart';

class CompactButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isOutlined;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? borderColor;
  final double? width;
  final double? height;
  final Widget? prefix;
  final Widget? suffix;
  final double? fontSize;
  final EdgeInsetsGeometry? padding;

  const CompactButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.isOutlined = false,
    this.backgroundColor,
    this.textColor,
    this.borderColor,
    this.width,
    this.height,
    this.prefix,
    this.suffix,
    this.fontSize,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveBackgroundColor = backgroundColor ?? AppColors.primary;
    final effectiveTextColor = textColor ?? (isOutlined ? effectiveBackgroundColor : Colors.white);
    final effectiveBorderColor = borderColor ?? effectiveBackgroundColor;

    return SizedBox(
      width: width,
      height: height ?? 36,
      child: isOutlined
          ? OutlinedButton(
              onPressed: isLoading ? null : onPressed,
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: effectiveBorderColor),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: padding ?? const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
              child: _buildButtonChild(effectiveTextColor),
            )
          : ElevatedButton(
              onPressed: isLoading ? null : onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: effectiveBackgroundColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: padding ?? const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                elevation: 0,
              ),
              child: _buildButtonChild(effectiveTextColor),
            ),
    );
  }

  Widget _buildButtonChild(Color textColor) {
    if (isLoading) {
      return SizedBox(
        height: 16,
        width: 16,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(textColor),
        ),
      );
    }

    final children = <Widget>[];
    
    if (prefix != null) {
      children.add(prefix!);
      children.add(const SizedBox(width: 6));
    }
    
    children.add(
      Text(
        text,
        style: getBoldStyle(
          fontFamily: FontConstant.cairo,
          fontSize: fontSize ?? FontSize.size11,
          color: textColor,
        ),
      ),
    );
    
    if (suffix != null) {
      children.add(const SizedBox(width: 6));
      children.add(suffix!);
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: children,
    );
  }
}