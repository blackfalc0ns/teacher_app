// import 'package:teacher_app/core/cubit/language_cubit.dart';
// import 'package:teacher_app/core/services/service_locator.dart';
// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'dart:ui' as ui;

// class LanguageInterceptor extends Interceptor {
//   @override
//   void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
//     // الحصول على اللغة الحالية من النظام
//     final currentLocale = _getCurrentLocale();

//     // إضافة header اللغة
//     options.headers['lang'] = currentLocale.languageCode;

//     // يمكن أيضاً إضافة Accept-Language header
//     options.headers['Accept-Language'] = currentLocale.languageCode;

//     // Log the language being sent
//     ////////print('🌐 LanguageInterceptor: Sending request with language: ${currentLocale.languageCode}');
//     ////////print('🌐 Request URL: ${options.uri}');

//     super.onRequest(options, handler);
//   }

//   Locale _getCurrentLocale() {
//     // محاولة الحصول على اللغة من LanguageCubit أولاً
//     try {
//       final languageCubit = getIt<LanguageCubit>();
//       final locale = languageCubit.state.locale;
//       ////////print('✅ Got language from LanguageCubit: ${locale.languageCode}');
//       return locale;
//     } catch (e) {
//       ////////print('❌ Error getting language from LanguageCubit: $e');
//     }

//     // محاولة الحصول على اللغة من BuildContext إذا كان متاحاً
//     try {
//       final context = _getContext();
//       if (context != null) {
//         return Localizations.localeOf(context);
//       }
//     } catch (e) {
//       // في حالة عدم توفر context
//     }

//     // الرجوع إلى اللغة الافتراضية من النظام
//     final systemLocale = ui.PlatformDispatcher.instance.locale;

//     // التأكد من أن اللغة مدعومة (عربي أو إنجليزي)
//     if (systemLocale.languageCode == 'ar') {
//       return const Locale('ar');
//     } else {
//       return const Locale('en');
//     }
//   }

//   BuildContext? _getContext() {
//     // محاولة الحصول على context من NavigatorKey إذا كان متاحاً
//     try {
//       return NavigatorKey.currentContext;
//     } catch (e) {
//       return null;
//     }
//   }
// }

// // Global NavigatorKey للوصول إلى context
// class NavigatorKey {
//   static final GlobalKey<NavigatorState> _key = GlobalKey<NavigatorState>();

//   static GlobalKey<NavigatorState> get key => _key;

//   static BuildContext? get currentContext => _key.currentContext;
// }
