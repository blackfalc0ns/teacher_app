import 'package:flutter/material.dart';

enum PropertyFieldType { title, address, description }

class PropertyValidators {
  PropertyValidators._();

  // -----------------------------
  //  Digits normalization
  // -----------------------------
  static const Map<String, String> _arabicToEnglishDigits = {
    '٠': '0',
    '١': '1',
    '٢': '2',
    '٣': '3',
    '٤': '4',
    '٥': '5',
    '٦': '6',
    '٧': '7',
    '٨': '8',
    '٩': '9',
  };

  static String normalizeDigits(String input) {
    var out = input;
    _arabicToEnglishDigits.forEach((ar, en) {
      out = out.replaceAll(ar, en);
    });
    return out;
  }

  /// Remove separators and keep + only at the beginning
  /// This ensures + is only preserved if it's at the start of the string
  static String digitsOnlyWithOptionalLeadingPlus(String input) {
    final normalized = normalizeDigits(input).trim();
    final hasPlus = normalized.startsWith('+');
    final digits = normalized.replaceAll(RegExp(r'\D'), '');
    return hasPlus ? '+$digits' : digits;
  }

  // -----------------------------
  //  Language checks
  // -----------------------------
  static bool containsArabic(String text) {
    return RegExp(r'[\u0600-\u06FF\u0750-\u077F]').hasMatch(text);
  }

  static bool containsEnglish(String text) {
    return RegExp(r'[a-zA-Z]').hasMatch(text);
  }

  // -----------------------------
  //  Suspicious keywords detection
  // -----------------------------
  /// Keywords that indicate user is trying to share contact info
  static const List<String> _suspiciousKeywordsAr = [
    'واتساب',
    'واتس',
    'وتساب',
    'رقم',
    'رقمي',
    'تواصل',
    'اتصل',
    'اتصال',
    'موبايل',
    'جوال',
    'تليفون',
    'هاتف',
    'فون',
    'كلمني',
    'كلمنى',
    'اتصلي',
    'اتصلى',
  ];

  static const List<String> _suspiciousKeywordsEn = [
    'whatsapp',
    'whats app',
    'whatsup',
    'phone',
    'mobile',
    'call',
    'contact',
    'number',
    'tel',
    'telephone',
    'reach',
    'text',
    'message',
    'msg',
  ];

  /// Check if text contains suspicious keywords
  static bool containsSuspiciousKeywords(String text) {
    final lowerText = text.toLowerCase();
    
    // Check Arabic keywords
    for (final keyword in _suspiciousKeywordsAr) {
      if (lowerText.contains(keyword)) return true;
    }
    
    // Check English keywords
    for (final keyword in _suspiciousKeywordsEn) {
      if (lowerText.contains(keyword)) return true;
    }
    
    return false;
  }

  // -----------------------------
  //  Phone detection
  // -----------------------------
  /// Detects likely phone numbers even if separated by spaces/dashes/etc.
  /// Strategy:
  /// 1) Normalize digits (Arabic → English)
  /// 2) Strip separators (keep + only at start)
  /// 3) Look for patterns:
  ///    - Egyptian mobile: 01[0|1|2|5] + 8 digits
  ///    - International: +20/20/0020 then 1[0125]xxxxxxxx (fixed regex)
  ///    - Any long digit run >= 8 (optional fallback)
  /// 4) Check for suspicious keywords + digits combination
  static bool containsPhoneNumber(String text, {bool strict = true}) {
    final cleaned = digitsOnlyWithOptionalLeadingPlus(text);

    // International: +20 or 20 or 0020 followed by 1[0125]xxxxxxxx
    // Fixed regex: (?:\+20|20|0020) ensures proper matching of international prefix
    final egInternational = RegExp(r'(?:\+20|20|0020)1[0125]\d{8}');
    if (egInternational.hasMatch(cleaned)) return true;

    // Local Egypt: 01[0/1/2/5]xxxxxxxx
    final egLocal = RegExp(r'01[0125]\d{8}');
    if (egLocal.hasMatch(cleaned)) return true;

    if (!strict) {
      // Fallback: any run >= 8 digits
      final anyLong = RegExp(r'\d{8,}');
      if (anyLong.hasMatch(cleaned)) return true;
      
      // Check for suspicious keywords + any digits (even if < 8)
      // This catches: "واتساب: 010 123" or "call me 010" or "رقمي 010"
      if (containsSuspiciousKeywords(text)) {
        final hasAnyDigits = RegExp(r'\d{3,}').hasMatch(cleaned);
        if (hasAnyDigits) return true;
      }
    }

    return false;
  }

  // -----------------------------
  //  Length rules
  // -----------------------------
  static ({int min, int max}) limits(PropertyFieldType type) {
    switch (type) {
      case PropertyFieldType.title:
        return (min: 5, max: 100);
      case PropertyFieldType.address:
        return (min: 5, max: 200);
      case PropertyFieldType.description:
        return (min: 20, max: 2000);
    }
  }

  // -----------------------------
  //  Error messages
  // -----------------------------
  static String msgArabicOnly(String locale) =>
      locale == 'ar' ? 'هذا الحقل يقبل اللغة العربية فقط' : 'This field accepts Arabic only';

  static String msgEnglishOnly(String locale) =>
      locale == 'ar' ? 'هذا الحقل يقبل اللغة الإنجليزية فقط' : 'This field accepts English only';

  static String msgPhoneNotAllowed(String locale) => locale == 'ar'
      ? 'ممنوع كتابة رقم هاتف/واتساب داخل هذا الحقل'
      : 'Phone/WhatsApp numbers are not allowed in this field';

  static String msgMin(PropertyFieldType type, String locale, int min) {
    final fieldAr = switch (type) {
      PropertyFieldType.title => 'العنوان',
      PropertyFieldType.address => 'العنوان',
      PropertyFieldType.description => 'الوصف',
    };

    final fieldEn = switch (type) {
      PropertyFieldType.title => 'Title',
      PropertyFieldType.address => 'Address',
      PropertyFieldType.description => 'Description',
    };

    return locale == 'ar'
        ? '$fieldAr يجب أن يكون $min أحرف على الأقل'
        : '$fieldEn must be at least $min characters';
  }

  static String msgMax(PropertyFieldType type, String locale, int max) {
    final fieldAr = switch (type) {
      PropertyFieldType.title => 'العنوان',
      PropertyFieldType.address => 'العنوان',
      PropertyFieldType.description => 'الوصف',
    };

    final fieldEn = switch (type) {
      PropertyFieldType.title => 'Title',
      PropertyFieldType.address => 'Address',
      PropertyFieldType.description => 'Description',
    };

    return locale == 'ar'
        ? '$fieldAr يجب ألا يتجاوز $max حرف'
        : '$fieldEn must not exceed $max characters';
  }

  // -----------------------------
  //  Public Validators
  // -----------------------------
  static String? validateArabicField(
    BuildContext context,
    String? value, {
    required PropertyFieldType type,
    bool blockPhones = false,
  }) {
    final text = (value ?? '').trim();
    if (text.isEmpty) return null;

    final locale = Localizations.localeOf(context).languageCode;

    if (containsEnglish(text)) return msgArabicOnly(locale);

    if (blockPhones && containsPhoneNumber(text, strict: false)) {
      return msgPhoneNotAllowed(locale);
    }

    return validateLength(context, text, type: type);
  }

  static String? validateEnglishField(
    BuildContext context,
    String? value, {
    required PropertyFieldType type,
    bool blockPhones = false,
  }) {
    final text = (value ?? '').trim();
    if (text.isEmpty) return null;

    final locale = Localizations.localeOf(context).languageCode;

    if (containsArabic(text)) return msgEnglishOnly(locale);

    if (blockPhones && containsPhoneNumber(text, strict: false)) {
      return msgPhoneNotAllowed(locale);
    }

    return validateLength(context, text, type: type);
  }

  static String? validateLength(
    BuildContext context,
    String value, {
    required PropertyFieldType type,
  }) {
    final locale = Localizations.localeOf(context).languageCode;
    final l = value.trim().length;
    final lim = limits(type);

    if (l < lim.min) return msgMin(type, locale, lim.min);
    if (l > lim.max) return msgMax(type, locale, lim.max);
    return null;
  }
}
