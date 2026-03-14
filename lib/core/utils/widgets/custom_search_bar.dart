import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../theme/app_colors.dart';
import '../constant/styles_manger.dart';
import '../constant/font_manger.dart';
import '../../responsive/app_responsive.dart';

/// A reusable search bar widget with consistent styling
class CustomSearchBar extends StatelessWidget {
  final TextEditingController? controller;
  final String hintText;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onTap;
  final VoidCallback? onFilterTap;
  final VoidCallback? onMapTap;
  final VoidCallback? onClear;
  final bool showFilterButton;
  final bool readOnly;
  final bool showClearButton;
  final bool animateHint;

  const CustomSearchBar({
    super.key,
    this.controller,
    required this.hintText,
    this.onChanged,
    this.onTap,
    this.onFilterTap,
    this.onMapTap,
    this.onClear,
    this.showFilterButton = true,
    this.readOnly = false,
    this.showClearButton = true,
    this.animateHint = true,
  });

  @override
  Widget build(BuildContext context) {
    final isRtl = Directionality.of(context) == TextDirection.rtl;
    final hasText = controller?.text.isNotEmpty ?? false;

    // Responsive values
    final padding = AppTokens.paddingMd(context);
    final searchHeight = AppTokens.buttonMd(context);
    final radius = AppTokens.radiusMd(context);
    final spacing = AppTokens.paddingSm(context);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: padding, vertical: 4),
      child: Row(
        children: [
          // Search Field
          Expanded(
            child: GestureDetector(
              onTap: readOnly ? onTap : null,
              child: Container(
                height: searchHeight,
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(radius),
                  border: Border.all(
                    color: Colors.grey.withValues(alpha: 0.2),
                    width: 1,
                  ),
                ),
                child: readOnly
                    ? _buildReadOnlyContent(context, isRtl)
                    : _buildTextField(context, isRtl, hasText),
              ),
            ),
          ),
          // Filter Button (split into two halves if onMapTap is provided)
          if (showFilterButton) ...[
            SizedBox(width: spacing),
            if (onMapTap != null)
              _buildSplitFilterButton(context)
            else
              _buildSingleFilterButton(context),
          ],
        ],
      ),
    );
  }

  Widget _buildSingleFilterButton(BuildContext context) {
    final buttonSize = AppTokens.buttonMd(context);
    final radius = AppTokens.radiusMd(context);
    final iconSize = AppTokens.iconMd(context);

    return GestureDetector(
      onTap: onFilterTap,
      child: Container(
        height: buttonSize,
        width: buttonSize,
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(radius),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.2),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(Icons.tune, color: Colors.white, size: iconSize),
      ),
    );
  }

  Widget _buildSplitFilterButton(BuildContext context) {
    final buttonHeight = AppTokens.buttonMd(context);
    final buttonWidth =
        AppTokens.buttonMd(context) + AppTokens.paddingSm(context);
    final radius = AppTokens.radiusMd(context);
    final iconSize = AppTokens.iconMd(context);

    return Container(
      height: buttonHeight,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Filter icon (left side) - Primary color
          GestureDetector(
            onTap: onFilterTap,
            child: Container(
              width: buttonWidth,
              height: buttonHeight,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadiusDirectional.only(
                  topStart: Radius.circular(radius),
                  bottomStart: Radius.circular(radius),
                ),
              ),
              alignment: Alignment.center,
              child: Icon(Icons.tune, color: Colors.white, size: iconSize),
            ),
          ),
          // Map icon (right side) - Red color
          GestureDetector(
            onTap: onMapTap,
            child: Container(
              width: buttonWidth,
              height: buttonHeight,
              decoration: BoxDecoration(
                color: AppColors.errorRed,
                borderRadius: BorderRadiusDirectional.only(
                  topEnd: Radius.circular(radius),
                  bottomEnd: Radius.circular(radius),
                ),
              ),
              alignment: Alignment.center,
              child: Icon(
                Icons.map_outlined,
                color: Colors.white,
                size: iconSize,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReadOnlyContent(BuildContext context, bool isRtl) {
    final fontSize = AppTokens.fontMd(context);
    final iconPadding = AppTokens.paddingSm(context);

    return AbsorbPointer(
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.all(iconPadding),
            child: SvgPicture.asset(
              "assets/icons/search-normal.svg",
              colorFilter: ColorFilter.mode(Colors.grey[500]!, BlendMode.srcIn),
            ),
          ),
          Expanded(
            child: animateHint
                ? _AnimatedSearchHint(isRtl: isRtl, fontSize: fontSize)
                : Text(
                    '$hintText 🌙',
                    style: getRegularStyle(
                      fontSize: fontSize,
                      fontFamily: FontConstant.cairo,
                      color: Colors.grey[500],
                    ),
                    textAlign: isRtl ? TextAlign.right : TextAlign.left,
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(BuildContext context, bool isRtl, bool hasText) {
    final fontSize = AppTokens.fontMd(context);
    final iconPadding = AppTokens.paddingSm(context);
    final iconSize = AppTokens.iconMd(context);

    return Stack(
      children: [
        if (!hasText && animateHint)
          PositionedDirectional(
            start: 48,
            top: 0,
            bottom: 0,
            child: IgnorePointer(
              child: Center(
                child: _AnimatedSearchHint(isRtl: isRtl, fontSize: fontSize),
              ),
            ),
          ),
        TextField(
          controller: controller,
          textAlign: isRtl ? TextAlign.right : TextAlign.left,
          textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
          onChanged: onChanged,
          textInputAction: TextInputAction.search,
          style: getMediumStyle(
            fontSize: fontSize,
            fontFamily: FontConstant.cairo,
            color: AppColors.textPrimary,
          ),
          decoration: InputDecoration(
            hintText: animateHint ? null : '$hintText 🌙',
            hintStyle: getRegularStyle(
              fontSize: fontSize,
              fontFamily: FontConstant.cairo,
              color: Colors.grey[500],
            ),
            prefixIcon: Padding(
              padding: EdgeInsets.all(iconPadding),
              child: SvgPicture.asset(
                "assets/icons/search-normal.svg",
                colorFilter: ColorFilter.mode(
                  Colors.grey[500]!,
                  BlendMode.srcIn,
                ),
              ),
            ),
            suffixIcon: showClearButton && hasText
                ? IconButton(
                    onPressed: () {
                      controller?.clear();
                      onClear?.call();
                    },
                    icon: Icon(
                      Icons.close_rounded,
                      color: Colors.grey[400],
                      size: iconSize,
                    ),
                  )
                : null,
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              vertical: 8,
              horizontal: 12,
            ),
          ),
        ),
      ],
    );
  }
}

class _AnimatedSearchHint extends StatefulWidget {
  final bool isRtl;
  final double fontSize;
  final Color? color;

  const _AnimatedSearchHint({
    required this.isRtl,
    required this.fontSize,
    this.color,
  });

  @override
  State<_AnimatedSearchHint> createState() => _AnimatedSearchHintState();
}

class _AnimatedSearchHintState extends State<_AnimatedSearchHint> {
  int _index = 0;
  Timer? _timer;

  final List<String> _hintsAr = [
    "ابحث عن عقار.. 🌙",
    "ابحث عن مشروع 🌙",
    "ابحث عن كومبوند 🌙",
    "ابحث عن شقق للايجار 🌙",
    "ابحث عن شقق للبيع 🌙",
    "ابحث عن فيلا بحديقة 🌙",
    "ابحث عن دوبلكس فاخر 🌙",
    "ابحث عن محلات تجارية 🌙",
    "ابحث عن مكاتب إدارية 🌙",
    "ابحث عن شاليهات عالبحر 🌙",
    "ابحث عن أراضي للبناء 🌙",
    "ابحث عن عقارات مميزة 🌙",
  ];

  final List<String> _hintsEn = [
    "Search for property.. 🌙",
    "Search for project 🌙",
    "Search for compound 🌙",
    "Search for apartments for rent 🌙",
    "Search for apartments for sale 🌙",
    "Search for villa with garden 🌙",
    "Search for luxury duplex 🌙",
    "Search for commercial shops 🌙",
    "Search for administrative offices 🌙",
    "Search for sea side chalets 🌙",
    "Search for lands for construction 🌙",
    "Search for featured properties 🌙",
  ];

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (mounted) {
        setState(() {
          _index = (_index + 1) % _hintsAr.length;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final hints = isArabic ? _hintsAr : _hintsEn;

    return ClipRect(
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 600),
        switchInCurve: Curves.easeInOut,
        switchOutCurve: Curves.easeInOut,
        layoutBuilder: (currentChild, previousChildren) {
          return Stack(
            alignment: widget.isRtl
                ? Alignment.centerRight
                : Alignment.centerLeft,
            children: <Widget>[
              ...previousChildren,
              if (currentChild != null) currentChild,
            ],
          );
        },
        transitionBuilder: (Widget child, Animation<double> animation) {
          final isIncoming = child.key == ValueKey(_index);

          return FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: isIncoming
                  ? Tween<Offset>(
                      begin: const Offset(0.0, -1.0),
                      end: Offset.zero,
                    ).animate(animation)
                  : Tween<Offset>(
                      begin: const Offset(0.0, 1.0),
                      end: Offset.zero,
                    ).animate(animation),
              child: child,
            ),
          );
        },
        child: SizedBox(
          key: ValueKey(_index),
          width: double.infinity,
          child: Text(
            hints[_index],
            style: getSemiBoldStyle(
              fontSize: widget.fontSize,
              fontFamily: FontConstant.cairo,
              color: widget.color ?? Colors.grey[500],
            ),
            textAlign: widget.isRtl ? TextAlign.right : TextAlign.left,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }
}
