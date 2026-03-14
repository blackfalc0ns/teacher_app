import 'package:flutter/material.dart';

/// Smart responsive system:
/// - Breakpoints (small phone / phone / tablet / desktop)
/// - Tokens (padding/radius/font/icon/button/avatar)
/// - Grid helpers:
///    ✅ fixed tile height using mainAxisExtent (root fix for all screens)
///    ✅ adaptive columns helpers if needed later

// =============================================================================
// BREAKPOINTS
// =============================================================================

class Breakpoints {
  Breakpoints._();

  static const double smallPhone = 360;
  static const double phone = 600;
  static const double tablet = 1024;

  static double width(BuildContext c) => MediaQuery.of(c).size.width;

  static bool isSmallPhone(BuildContext c) => width(c) < smallPhone;
  static bool isPhone(BuildContext c) =>
      width(c) >= smallPhone && width(c) < phone;
  static bool isTablet(BuildContext c) =>
      width(c) >= phone && width(c) < tablet;
  static bool isDesktop(BuildContext c) => width(c) >= tablet;

  static DeviceType getDeviceType(BuildContext c) {
    final w = width(c);
    if (w < phone) return DeviceType.mobile;
    if (w < tablet) return DeviceType.tablet;
    return DeviceType.desktop;
  }
}

enum DeviceType { mobile, tablet, desktop }

// =============================================================================
// SUBTLE SCALE (optional but very useful)
// =============================================================================

class ScreenScale {
  ScreenScale._();

  /// Base width: 390 (iPhone 12/13/14)
  /// clamp keeps it subtle.
  static double widthScale(BuildContext c, {double base = 390}) {
    final w = MediaQuery.of(c).size.width;
    return (w / base).clamp(0.90, 1.15);
  }

  /// Text scale (accessibility) — affects overflow a lot on iOS
  static double textScale(BuildContext c) {
    final t = MediaQuery.textScalerOf(c).scale(1.0);
    return t.clamp(1.0, 1.2);
  }
}

// =============================================================================
// TOKENS
// =============================================================================

class AppTokens {
  AppTokens._();

  static double screenPadding(BuildContext c) {
    // small phones need slightly less padding
    if (Breakpoints.isSmallPhone(c)) return 8;
    if (Breakpoints.isTablet(c)) return 12;
    if (Breakpoints.isDesktop(c)) return 16;
    return 16;
  }

  static double paddingXs(BuildContext c) => _scale(c, 4, 6, 8);
  static double paddingSm(BuildContext c) => _scale(c, 8, 10, 12);
  static double paddingMd(BuildContext c) => _scale(c, 12, 14, 16);
  static double paddingLg(BuildContext c) => _scale(c, 16, 18, 20);
  static double paddingXl(BuildContext c) => _scale(c, 20, 24, 28);
  static double paddingXxl(BuildContext c) => _scale(c, 24, 28, 32);

  static double radiusSm(BuildContext c) => _scale(c, 8, 10, 12);
  static double radiusMd(BuildContext c) => _scale(c, 12, 14, 16);
  static double radiusLg(BuildContext c) => _scale(c, 16, 18, 20);
  static double radiusXl(BuildContext c) => _scale(c, 20, 22, 24);
  static double radiusFull(BuildContext c) => 999;

  static double fontSm(BuildContext c) => _scale(c, 12, 13, 14);
  static double fontMd(BuildContext c) => _scale(c, 13, 15, 15);
  static double fontLg(BuildContext c) => _scale(c, 16, 17, 18);
  static double fontXs(BuildContext c) => _scale(c, 10, 13, 14);
  static double fontXl(BuildContext c) => _scale(c, 18, 20, 22);

  // Icon Sizes
  static double iconSm(BuildContext c) => _scale(c, 16, 18, 20);
  static double iconMd(BuildContext c) => _scale(c, 20, 22, 24);
  static double iconLg(BuildContext c) => _scale(c, 24, 26, 28);
  static double iconXl(BuildContext c) => _scale(c, 32, 36, 40);

  // Button Heights
  static double buttonSm(BuildContext c) => _scale(c, 36, 40, 44);
  static double buttonMd(BuildContext c) => _scale(c, 44, 48, 52);
  static double buttonLg(BuildContext c) => _scale(c, 52, 56, 60);

  static double _scale(BuildContext c, double m, double t, double d) {
    if (Breakpoints.isDesktop(c)) return d;
    if (Breakpoints.isTablet(c)) return t;
    return m;
  }
}

// =============================================================================
// GRID CONFIG (ROOT FIX HERE)
// =============================================================================

class GridConfig {
  GridConfig._();

  static double spacing(BuildContext c) {
    if (Breakpoints.isDesktop(c)) return 16;
    if (Breakpoints.isTablet(c)) return 14;
    return 12;
  }

  static double maxContentWidth(BuildContext c) {
    if (Breakpoints.isDesktop(c)) return 1200;
    if (Breakpoints.isTablet(c)) return 900;
    return double.infinity;
  }

  /// ✅ Root solution:
  /// Give grid items a stable height (mainAxisExtent) so wide phones don’t create gaps.
  /// This uses:
  /// - subtle width scale
  /// - text scale (prevents overflow on iOS when font bigger)
  static double cardTileExtent(BuildContext c) {
    // Base “visual height” for your current cards
    // (You can tweak 235..250 once, and it will stay consistent everywhere)
    final base = Breakpoints.isSmallPhone(c)
        ? 238.0
        : (Breakpoints.isTablet(c)
              ? 238.9
              : (Breakpoints.isDesktop(c) ? 240.0 : 243.0));

    final s = ScreenScale.widthScale(c);
    final ts = ScreenScale.textScale(c);

    // Slightly scale, but clamp hard so it never gets too small/large
    final extent = base * s * ts;
    return extent.clamp(215.0, 290.0);
  }

  /// ✅ Project card tile extent - for favourite projects and similar cards
  /// Handles different screen sizes including large iPads
  static double projectCardTileExtent(BuildContext c) {
    final width = MediaQuery.of(c).size.width;

    // Base heights for different screen sizes
    // Project cards have: image (180) + name + location + prices section + footer
    double base;

    if (Breakpoints.isDesktop(c)) {
      // Large screens (iPad Pro, Desktop) - need more height for content
      base = width > 1100 ? 460.0 : 445.0;
    } else if (Breakpoints.isTablet(c)) {
      // Regular tablets - medium height
      base = 430.0;
    } else {
      // Mobile - list view, not used in grid but fallback
      base = 420.0;
    }

    final ts = ScreenScale.textScale(c);

    // Scale with text but clamp to prevent extremes
    return (base * ts).clamp(400.0, 500.0);
  }

  /// ✅ Recommended columns
  static int vendorCardsColumns(BuildContext c) {
    // Keep same idea, but you can later make large phones = 3 if you want
    if (Breakpoints.isDesktop(c)) return 4;
    if (Breakpoints.isTablet(c)) return 3;
    return 2;
  }

  /// ✅ Grid delegate ready to use (no aspect ratio headaches)
  static SliverGridDelegate vendorCardsDelegate(BuildContext c) {
    final spacing = GridConfig.spacing(c);
    return SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: vendorCardsColumns(c),
      crossAxisSpacing: spacing,
      mainAxisSpacing: spacing,
      mainAxisExtent: cardTileExtent(c), // ✅ THE FIX
    );
  }

  /// ✅ Job cards columns - based on actual content width
  static int jobCardsColumns(BuildContext c, double contentWidth) {
    if (contentWidth >= 1200) return 3;
    if (contentWidth >= 700) return 2;
    return 1; // Mobile: List
  }

  /// ✅ Job card tile extent - calculates from real content width
  static double jobCardTileExtent(
    BuildContext c, {
    required double contentWidth,
    required int columns,
  }) {
    final spacingVal = spacing(c);
    final padding = AppTokens.screenPadding(c);

    // العرض الحقيقي المتاح داخل الجريد
    final availableWidth = (contentWidth - (padding * 2)).clamp(
      1.0,
      double.infinity,
    );
    final totalSpacing = spacingVal * (columns - 1);
    final cardWidth = (availableWidth - totalSpacing) / columns;

    // ✅ بعد ما هنثبت الـ tags كسطر واحد، الارتفاع بقى شبه ثابت
    double base = 300.0;

    if (cardWidth < 330) base += 18; // narrow
    if (cardWidth < 300) base += 28; // very narrow

    // text scale (iOS accessibility)
    final ts = ScreenScale.textScale(c);

    return (base * ts).clamp(180.0, 299.0);
  }

  /// ✅ Job cards grid delegate - uses content width
  static SliverGridDelegate jobCardsDelegate(
    BuildContext c, {
    required double contentWidth,
  }) {
    final cols = jobCardsColumns(c, contentWidth);
    final spacingVal = spacing(c);

    // لو موبايل list - مش هيتستخدم
    if (cols == 1) {
      return const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 1,
        mainAxisSpacing: 0,
        crossAxisSpacing: 0,
        childAspectRatio: 1,
      );
    }

    return SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: cols,
      crossAxisSpacing: spacingVal,
      mainAxisSpacing: spacingVal,
      mainAxisExtent: jobCardTileExtent(
        c,
        contentWidth: contentWidth,
        columns: cols,
      ),
    );
  }

  /// Helper if you need dynamic columns in future
  static int adaptiveColumns({
    required double availableWidth,
    required double minItemWidth,
    int minColumns = 2,
    int maxColumns = 4,
  }) {
    final raw = (availableWidth / minItemWidth).floor();
    return raw.clamp(minColumns, maxColumns);
  }
}

// =============================================================================
// CAROUSEL CONFIG (Projects Cards)
// =============================================================================

class CarouselConfig {
  CarouselConfig._();

  // ✅ Carousel Height - based on screen size
  static double projectCarouselHeight(BuildContext c) {
    final w = MediaQuery.of(c).size.width;
    if (w < Breakpoints.smallPhone) return 260;
    if (w < Breakpoints.phone) return 290;
    if (w < Breakpoints.tablet) return 340;
    return 380; // Desktop
  }

  // ✅ Viewport Fraction - how much of the card is visible
  // زودنا النسبة عشان الكاردات تاخد مساحة أكبر
  static double viewportFraction(BuildContext c) {
    final w = MediaQuery.of(c).size.width;
    if (w < Breakpoints.smallPhone) return 0.78; // Show edges
    if (w < Breakpoints.phone) return 0.80; // Show edges
    if (w < Breakpoints.tablet) return 0.70; // Tablet
    return 0.60; // Desktop
  }

  // ✅ Card Margins - قللنا المسافات
  static EdgeInsets cardMargin(BuildContext c) {
    final w = MediaQuery.of(c).size.width;
    if (w < Breakpoints.smallPhone) {
      return const EdgeInsets.symmetric(horizontal: 0, vertical: 4);
    }
    if (w < Breakpoints.phone) {
      return const EdgeInsets.symmetric(horizontal: 0, vertical: 6);
    }
    if (w < Breakpoints.tablet) {
      return const EdgeInsets.symmetric(horizontal: 0, vertical: 8);
    }
    return const EdgeInsets.symmetric(horizontal: 0, vertical: 10);
  }

  // ✅ Card Border Radius
  static double cardRadius(BuildContext c) {
    final w = MediaQuery.of(c).size.width;
    if (w < Breakpoints.smallPhone) return 14;
    if (w < Breakpoints.phone) return 16;
    if (w < Breakpoints.tablet) return 20;
    return 24;
  }

  // ✅ Bottom Content Padding - ضبطناها
  static EdgeInsets bottomContentPadding(BuildContext c) {
    final w = MediaQuery.of(c).size.width;
    if (w < Breakpoints.smallPhone) {
      return const EdgeInsets.only(left: 10, right: 10, bottom: 10);
    }
    if (w < Breakpoints.phone) {
      return const EdgeInsets.only(left: 12, right: 12, bottom: 12);
    }
    if (w < Breakpoints.tablet) {
      return const EdgeInsets.only(left: 14, right: 14, bottom: 14);
    }
    return const EdgeInsets.only(left: 16, right: 16, bottom: 16);
  }

  // ✅ Top Positioned Elements
  static double topPosition(BuildContext c) {
    final w = MediaQuery.of(c).size.width;
    if (w < Breakpoints.smallPhone) return 10;
    if (w < Breakpoints.phone) return 12;
    if (w < Breakpoints.tablet) return 14;
    return 16;
  }

  static double leftPosition(BuildContext c) {
    return topPosition(c);
  }

  static double rightPosition(BuildContext c) {
    return topPosition(c);
  }

  // ✅ Favorite Button Size
  static double favoriteButtonPadding(BuildContext c) {
    final w = MediaQuery.of(c).size.width;
    if (w < Breakpoints.smallPhone) return 6;
    if (w < Breakpoints.phone) return 8;
    if (w < Breakpoints.tablet) return 10;
    return 12;
  }

  static double favoriteIconSize(BuildContext c) {
    final w = MediaQuery.of(c).size.width;
    if (w < Breakpoints.smallPhone) return 18;
    if (w < Breakpoints.phone) return 20;
    if (w < Breakpoints.tablet) return 22;
    return 24;
  }

  // ✅ Project Name Font Size
  static double projectNameFontSize(BuildContext c) {
    final w = MediaQuery.of(c).size.width;
    if (w < Breakpoints.smallPhone) return 13;
    if (w < Breakpoints.phone) return 15;
    if (w < Breakpoints.tablet) return 17;
    return 20;
  }

  // ✅ Location Font Size
  static double locationFontSize(BuildContext c) {
    final w = MediaQuery.of(c).size.width;
    if (w < Breakpoints.smallPhone) return 10;
    if (w < Breakpoints.phone) return 11;
    if (w < Breakpoints.tablet) return 12;
    return 14;
  }

  // ✅ Location Icon Size
  static double locationIconSize(BuildContext c) {
    final w = MediaQuery.of(c).size.width;
    if (w < Breakpoints.smallPhone) return 12;
    if (w < Breakpoints.phone) return 14;
    if (w < Breakpoints.tablet) return 16;
    return 18;
  }

  // ✅ Price Font Size
  static double priceFontSize(BuildContext c) {
    final w = MediaQuery.of(c).size.width;
    if (w < Breakpoints.smallPhone) return 14;
    if (w < Breakpoints.phone) return 16;
    if (w < Breakpoints.tablet) return 18;
    return 16;
  }

  // ✅ Developer Card
  static double developerCardRadius(BuildContext c) {
    final w = MediaQuery.of(c).size.width;
    if (w < Breakpoints.smallPhone) return 18;
    if (w < Breakpoints.phone) return 22;
    if (w < Breakpoints.tablet) return 24;
    return 26;
  }

  static EdgeInsets developerCardPadding(BuildContext c) {
    final w = MediaQuery.of(c).size.width;
    if (w < Breakpoints.smallPhone) {
      return const EdgeInsets.symmetric(horizontal: 8, vertical: 5);
    }
    if (w < Breakpoints.phone) {
      return const EdgeInsets.symmetric(horizontal: 10, vertical: 6);
    }
    if (w < Breakpoints.tablet) {
      return const EdgeInsets.symmetric(horizontal: 12, vertical: 8);
    }
    return const EdgeInsets.symmetric(horizontal: 14, vertical: 10);
  }

  static double developerLogoSize(BuildContext c) {
    final w = MediaQuery.of(c).size.width;
    if (w < Breakpoints.smallPhone) return 22;
    if (w < Breakpoints.phone) return 26;
    if (w < Breakpoints.tablet) return 30;
    return 34;
  }

  static double developerNameFontSize(BuildContext c) {
    final w = MediaQuery.of(c).size.width;
    if (w < Breakpoints.smallPhone) return 9;
    if (w < Breakpoints.phone) return 10;
    if (w < Breakpoints.tablet) return 12;
    return 14;
  }

  static double developerNameMaxWidth(BuildContext c) {
    final w = MediaQuery.of(c).size.width;
    if (w < Breakpoints.smallPhone) return 80;
    if (w < Breakpoints.phone) return 100;
    if (w < Breakpoints.tablet) return 140;
    return 180;
  }

  // ✅ Vertical Spacing
  static double spacingXs(BuildContext c) {
    final w = MediaQuery.of(c).size.width;
    if (w < Breakpoints.smallPhone) return 3;
    if (w < Breakpoints.phone) return 4;
    return 6;
  }

  static double spacingMd(BuildContext c) {
    final w = MediaQuery.of(c).size.width;
    if (w < Breakpoints.smallPhone) return 5;
    if (w < Breakpoints.phone) return 6;
    if (w < Breakpoints.tablet) return 8;
    return 10;
  }

  // ✅ Shadow Blur
  static double shadowBlur(BuildContext c) {
    final w = MediaQuery.of(c).size.width;
    if (w < Breakpoints.smallPhone) return 10;
    if (w < Breakpoints.phone) return 12;
    if (w < Breakpoints.tablet) return 16;
    return 20;
  }

  static Offset shadowOffset(BuildContext c) {
    final w = MediaQuery.of(c).size.width;
    if (w < Breakpoints.smallPhone) return const Offset(0, 3);
    if (w < Breakpoints.phone) return const Offset(0, 4);
    if (w < Breakpoints.tablet) return const Offset(0, 5);
    return const Offset(0, 6);
  }
}

// =============================================================================
// HORIZONTAL CARD CONFIG (for dynamic property sections)
// =============================================================================

class HorizontalCardConfig {
  HorizontalCardConfig._();

  static double cardWidth(BuildContext c) {
    final w = MediaQuery.of(c).size.width;
    if (w < Breakpoints.smallPhone) return 260;
    if (w < Breakpoints.phone) return 340;
    if (w < Breakpoints.tablet) return 390;
    return 420;
  }

  static double cardHeight(BuildContext c) {
    final w = MediaQuery.of(c).size.width;
    if (w < Breakpoints.smallPhone) return 110;
    if (w < Breakpoints.phone) return 120;
    if (w < Breakpoints.tablet) return 130;
    return 140;
  }

  static double imageWidth(BuildContext c) {
    final w = MediaQuery.of(c).size.width;
    if (w < Breakpoints.smallPhone) return 110;
    if (w < Breakpoints.phone) return 130;
    if (w < Breakpoints.tablet) return 140;
    return 150;
  }

  static double borderRadius(BuildContext c) {
    final w = MediaQuery.of(c).size.width;
    if (w < Breakpoints.smallPhone) return 12;
    if (w < Breakpoints.phone) return 16;
    return 18;
  }

  static double padding(BuildContext c) {
    final w = MediaQuery.of(c).size.width;
    if (w < Breakpoints.smallPhone) return 8;
    if (w < Breakpoints.phone) return 10;
    return 12;
  }

  static double titleSize(BuildContext c) {
    final w = MediaQuery.of(c).size.width;
    if (w < Breakpoints.smallPhone) return 11;
    if (w < Breakpoints.phone) return 13;
    return 14;
  }

  static double locationSize(BuildContext c) {
    final w = MediaQuery.of(c).size.width;
    if (w < Breakpoints.smallPhone) return 9;
    if (w < Breakpoints.phone) return 10;
    return 11;
  }

  static double priceSize(BuildContext c) {
    final w = MediaQuery.of(c).size.width;
    if (w < Breakpoints.smallPhone) return 13;
    if (w < Breakpoints.phone) return 15;
    return 16;
  }

  static double badgeSize(BuildContext c) {
    final w = MediaQuery.of(c).size.width;
    if (w < Breakpoints.smallPhone) return 6;
    if (w < Breakpoints.phone) return 8;
    return 10;
  }

  /// Grid section height (3 rows * card height + spacing)
  static double gridSectionHeight(BuildContext c) {
    return cardHeight(c) * 3 + 24; // 3 rows + 12px spacing each
  }
}

// =============================================================================
// GRID CARD CONFIG (for Theme 2 & PropertyCardGridDynamic)
// =============================================================================

class GridCardConfig {
  GridCardConfig._();

  /// Calculates the visual height of the property card based on content
  static double propertyCardExtent(BuildContext c) {
    // Base height elements:
    // Image: 160
    // Padding: 20 (approx top/bottom)
    // Title: ~45
    // Location: ~20
    // Details: ~60 (row + spacing)
    // Agency: ~30
    // Spacing gaps: ~20
    // Total approx: ~355

    // We scale slightly for larger screens to accommodate larger fonts
    final w = MediaQuery.of(c).size.width;

    if (w < Breakpoints.smallPhone) return 330;
    if (w < Breakpoints.phone) return 350;
    if (w < Breakpoints.tablet) return 360;
    return 380;
  }

  /// Columns for property grid
  static int propertyGridColumns(BuildContext c) {
    if (Breakpoints.isDesktop(c)) return 4;
    if (Breakpoints.isTablet(c)) return 3; // Tablet gets 3 columns
    return 2; // Phone gets 2
  }

  /// Grid Delegate for Property Cards
  static SliverGridDelegate propertyGridDelegate(BuildContext c) {
    return SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: propertyGridColumns(c),
      crossAxisSpacing: GridConfig.spacing(c),
      mainAxisSpacing: GridConfig.spacing(c),
      mainAxisExtent: propertyCardExtent(c),
    );
  }
}

// =============================================================================
// EXTENSIONS
// =============================================================================

extension ResponsiveContext on BuildContext {
  bool get isSmallPhone => Breakpoints.isSmallPhone(this);
  bool get isMobile => Breakpoints.getDeviceType(this) == DeviceType.mobile;
  bool get isTablet => Breakpoints.isTablet(this);
  bool get isDesktop => Breakpoints.isDesktop(this);

  T responsive<T>({required T mobile, T? tablet, T? desktop}) {
    if (isDesktop && desktop != null) return desktop;
    if (isTablet && tablet != null) return tablet;
    return mobile;
  }

  double get screenPadding => AppTokens.screenPadding(this);
}
