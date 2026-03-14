# 📁 Core Module - Amtalek Real Estate App

> **الوحدة الأساسية** التي تحتوي على جميع الأدوات والخدمات المشتركة في التطبيق

---

## 📋 فهرس المحتويات

1. [هيكل المجلد](#-هيكل-المجلد)
2. [Constants](#-constants)
3. [Cubit](#-cubit)
4. [Errors](#-errors)
5. [Error Widgets](#-error-widgets)
6. [Interceptors](#-interceptors)
7. [Mixins](#-mixins)
8. [Models](#-models)
9. [Network](#-network)
10. [Responsive](#-responsive)
11. [Services](#-services)
12. [Utils](#-utils)

---

## 📂 هيكل المجلد

```
lib/core/
├── constants/          # الثوابت العامة
├── cubit/              # إدارة حالة اللغة
├── errors/             # معالجة الأخطاء
├── error_widgets/      # واجهات عرض الأخطاء
├── interceptors/       # Dio Interceptors
├── mixins/             # Mixins للتحديث التلقائي
├── models/             # النماذج المشتركة
├── network/            # طبقة الشبكة
├── responsive/         # نظام التجاوب
├── services/           # الخدمات الأساسية
└── utils/              # الأدوات المساعدة
```

---

## 📌 Constants

### `app_constants.dart`
ثوابت التطبيق الأساسية للمسافات والأبعاد.

```dart
class AppConstants {
  // Spacing
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;
  
  // Border Radius
  static const double radiusSmall = 8.0;
  static const double radiusMedium = 12.0;
  static const double radiusLarge = 16.0;
  
  // Animation Duration
  static const Duration animationDuration = Duration(milliseconds: 300);
  static const Duration shimmerDuration = Duration(milliseconds: 1500);
}
```

---

## 🌐 Cubit

### `language_cubit.dart` & `language_state.dart`
إدارة حالة اللغة في التطبيق (عربي/إنجليزي).

**الميزات:**
- حفظ اللغة في SharedPreferences
- تحديث DioClient عند تغيير اللغة
- إشعار جميع الـ Cubits المسجلة بتغيير اللغة

```dart
// الاستخدام
final languageCubit = context.read<LanguageCubit>();

// تغيير اللغة
await languageCubit.changeLanguage('en');

// التبديل بين اللغات
await languageCubit.toggleLanguage();

// التحقق من اللغة الحالية
if (languageCubit.isArabic) { ... }
```

---

## ⚠️ Errors

### `api_error_type.dart`
تعريف جميع أنواع أخطاء API.

```dart
enum ApiErrorType {
  // Network errors
  noInternetConnection,
  connectionTimeout,
  receiveTimeout,
  sendTimeout,
  
  // Server errors (5xx)
  serverError,
  internalServerError,
  badGateway,
  serviceUnavailable,
  
  // Client errors (4xx)
  badRequest,
  unauthorized,
  forbidden,
  notFound,
  tooManyRequests,
  // ... المزيد
}
```

### `api_exception.dart`
Exception موحد لجميع أخطاء API.

```dart
class ApiException implements Exception {
  final ApiErrorType errorType;
  final String message;
  final int? statusCode;
  final dynamic response;
  final bool isTranslationKey;
}
```

### `dio_exception_handler.dart`
معالج أخطاء Dio - يحول DioException إلى ApiException.

```dart
// الاستخدام التلقائي في ApiHelper
final exception = DioExceptionHandler.handleDioException(dioException);
```

---

## 🎨 Error Widgets

واجهات عرض الأخطاء المخصصة لكل نوع خطأ.

| الملف | الوصف |
|-------|-------|
| `api_error_widget.dart` | Widget رئيسي يختار Widget المناسب حسب نوع الخطأ |
| `base_error_widget.dart` | Widget أساسي تُبنى عليه باقي الـ Widgets |
| `no_internet_error_widget.dart` | عرض خطأ عدم الاتصال بالإنترنت |
| `timeout_error_widget.dart` | عرض أخطاء انتهاء المهلة |
| `server_error_widget.dart` | عرض أخطاء السيرفر (5xx) |
| `client_error_widget.dart` | عرض أخطاء العميل (4xx) |
| `generic_error_widget.dart` | عرض الأخطاء العامة |

```dart
// الاستخدام
ApiErrorWidget(
  exception: apiException,
  onRetry: () => cubit.loadData(),
  onGoBack: () => Navigator.pop(context),
);

// أو من أي Exception
ApiErrorWidget.fromException(
  exception,
  onRetry: () => cubit.loadData(),
);
```

---

## 🔌 Interceptors

### `language_interceptor.dart`
يضيف header اللغة لكل طلب API.

```dart
// يضيف تلقائياً:
options.headers['lang'] = 'ar'; // أو 'en'
options.headers['Accept-Language'] = 'ar';
```

### `logging_interceptor.dart`
تسجيل جميع الطلبات والاستجابات للـ debugging.

### `retry_interceptor.dart`
إعادة المحاولة التلقائية للطلبات الفاشلة.

```dart
RetryInterceptor(
  maxRetries: 3,
  retryDelay: Duration(seconds: 2),
  retryStatusCodes: [500, 502, 503, 504, 408, 429],
);
```

**الميزات:**
- Exponential backoff (2s, 4s, 8s)
- إعادة المحاولة لأخطاء الشبكة والـ timeout
- إعادة المحاولة لـ status codes محددة

---

## 🔄 Mixins

### `language_refresh_mixin.dart`
Mixin للتحديث التلقائي عند تغيير اللغة.

```dart
class MyCubit extends Cubit<MyState> with LanguageRefreshMixin {
  MyCubit() : super(MyInitialState()) {
    initLanguageRefresh('my_cubit_id');
  }
  
  @override
  void onLanguageRefresh() {
    loadData(); // إعادة تحميل البيانات
  }
  
  @override
  Future<void> close() {
    disposeLanguageRefresh();
    return super.close();
  }
}
```

### `location_refresh_mixin.dart`
Mixin للتحديث التلقائي عند تغيير الموقع.

```dart
class MyCubit extends Cubit<MyState> with LocationRefreshMixin {
  @override
  void onLocationRefresh(LocationChangeEvent event) {
    loadData(countryId: event.countryId, cityId: event.cityId);
  }
}
```

---

## 📦 Models

### `property_card_model.dart`
Model موحد لعرض كروت العقارات في جميع أنحاء التطبيق.

**الميزات:**
- Safe parsing مع fallback values
- دعم مصادر بيانات متعددة (JSON, CompanyProperty, PropertyModel)
- Computed getters للموقع والسعر
- Validation للبيانات

```dart
// من JSON
final property = PropertyCardModel.fromJson(json);

// من قائمة JSON
final properties = PropertyCardModel.fromJsonList(jsonList);

// من CompanyProperty
final property = PropertyCardModel.fromCompanyProperty(companyProperty);

// Computed properties
property.location      // "المنطقة، المدينة"
property.displayPrice  // السعر حسب نوع العرض
property.isValid       // هل البيانات صالحة للعرض
```

---

## 🌐 Network

### `api_endpoints.dart`
جميع endpoints الـ API.

```dart
class ApiEndpoints {
  static const String baseUrl = 'https://newdashboard.amtalek.com/public/api/v1/mobile';
  
  // Auth
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  
  // Properties
  static String getPropertyDetails(int id) => '/property/$id';
  
  // Projects
  static String getProjectDetails(int id) => '/project/$id';
  // ... المزيد
}
```

### `api_service.dart`
خدمة API الرئيسية مع دعم جميع أنواع الطلبات.

```dart
final apiService = getIt<ApiService>();

// GET request
final data = await apiService.get<Map<String, dynamic>>(
  '/endpoint',
  queryParameters: {'page': 1},
);

// POST request
final result = await apiService.post<Map<String, dynamic>>(
  '/endpoint',
  data: {'name': 'value'},
);

// Safe API call (returns ApiResult)
final result = await apiService.safeGet<Map<String, dynamic>>('/endpoint');
result.when(
  success: (data) => //print('Success: $data'),
  failure: (error) => //print('Error: ${error.message}'),
);

// Multipart upload
final result = await apiService.safePostMultipart<Map<String, dynamic>>(
  '/upload',
  data: {'title': 'My File'},
  files: {'image': imageFile},
);
```

### `api_helper.dart`
Helper functions لتنفيذ API calls مع معالجة الأخطاء.

```dart
// تنفيذ مع exception handling
final result = await ApiHelper.executeApiCall(() async {
  return await dio.get('/endpoint');
});

// تنفيذ مع ApiResult wrapper
final result = await ApiHelper.safeApiCall(() async {
  return await dio.get('/endpoint');
});
```

### `dio_client.dart`
Dio client مُحسّن مع caching و interceptors.

**الميزات:**
- Connection pooling
- Response caching (30 دقيقة)
- Automatic retry
- Language header
- Auth token management

```dart
// التهيئة (في service_locator)
await DioClient.initialize(appStateService);

// الاستخدام
final response = await DioClient.instance.get(
  '/endpoint',
  cacheDuration: Duration(hours: 1),
  forceRefresh: false,
);

// مسح الـ cache
await DioClient.instance.clearCache();
```

### `app_state_service.dart`
إدارة حالة التطبيق (تسجيل الدخول، التوكنات، المفضلة).

```dart
final appState = getIt<AppStateService>();

// حالة تسجيل الدخول
appState.isLoggedIn();
appState.setLoggedIn(true);

// إدارة التوكنات (Secure Storage)
await appState.saveTokens(
  accessToken: token,
  refreshToken: refreshToken,
  accessTokenExpiresAt: expiresAt,
  refreshTokenExpiresAt: refreshExpiresAt,
);
appState.getAccessToken();

// مفضلة الضيف
appState.addGuestFavoriteProperty(propertyId);
appState.isGuestFavoriteProperty(propertyId);

// نوع المستخدم
appState.isDeveloperOrBroker();
appState.isCurrentUser(ownerId);
```

### `token_refresh_helper.dart`
Helper لتجديد التوكنات تلقائياً.

```dart
final helper = TokenRefreshHelper(authRepository, appStateService);
final isValid = await helper.ensureValidToken();
```

### Network Interceptors (`network/interceptors/`)

| الملف | الوصف |
|-------|-------|
| `auth_interceptor.dart` | يضيف Authorization header |
| `language_interceptor.dart` | يضيف Language header |
| `logging_interceptor.dart` | تسجيل الطلبات |
| `retry_interceptor.dart` | إعادة المحاولة |

---

## 📱 Responsive

### `app_responsive.dart`
نظام تجاوب ذكي للتطبيق.

#### Breakpoints
```dart
class Breakpoints {
  static const double smallPhone = 360;
  static const double phone = 600;
  static const double tablet = 1024;
  
  // التحقق من نوع الجهاز
  Breakpoints.isSmallPhone(context);
  Breakpoints.isPhone(context);
  Breakpoints.isTablet(context);
  Breakpoints.isDesktop(context);
}
```

#### AppTokens
قيم متجاوبة للـ padding, radius, fonts, icons, buttons.

```dart
// Padding
AppTokens.paddingXs(context);  // 4-8
AppTokens.paddingSm(context);  // 8-12
AppTokens.paddingMd(context);  // 12-16
AppTokens.paddingLg(context);  // 16-20

// Radius
AppTokens.radiusSm(context);   // 8-12
AppTokens.radiusMd(context);   // 12-16

// Fonts
AppTokens.fontSm(context);     // 12-14
AppTokens.fontMd(context);     // 13-15
AppTokens.fontLg(context);     // 16-18

// Icons
AppTokens.iconSm(context);     // 16-20
AppTokens.iconMd(context);     // 20-24

// Buttons
AppTokens.buttonSm(context);   // 36-44
AppTokens.buttonMd(context);   // 44-52
```

#### GridConfig
إعدادات الـ Grid للكروت.

```dart
// عدد الأعمدة
GridConfig.vendorCardsColumns(context);  // 2-4

// ارتفاع الكارت (mainAxisExtent)
GridConfig.cardTileExtent(context);

// Grid delegate جاهز
GridConfig.vendorCardsDelegate(context);

// Job cards (يعتمد على عرض المحتوى)
GridConfig.jobCardsColumns(context, contentWidth);
GridConfig.jobCardTileExtent(context, contentWidth: w, columns: cols);
```

#### CarouselConfig
إعدادات الـ Carousel للمشاريع.

```dart
CarouselConfig.projectCarouselHeight(context);
CarouselConfig.viewportFraction(context);
CarouselConfig.cardMargin(context);
CarouselConfig.cardRadius(context);
```

#### Extensions
```dart
// على BuildContext
context.isSmallPhone;
context.isMobile;
context.isTablet;
context.isDesktop;
context.screenPadding;

context.responsive<int>(
  mobile: 2,
  tablet: 3,
  desktop: 4,
);
```

---

## 🔧 Services

### `service_locator.dart`
تسجيل جميع الـ dependencies باستخدام GetIt.

```dart
// التهيئة (في main.dart)
await setupServiceLocator();

// الاستخدام
final apiService = getIt<ApiService>();
final languageCubit = getIt<LanguageCubit>();
```

**المسجلات:**
- Core Services (AppStateService, DioClient, ApiService)
- Repositories (جميع الـ repositories)
- Cubits (جميع الـ cubits)

### `language_refresh_service.dart`
خدمة إشعار الـ Cubits بتغيير اللغة.

```dart
// التسجيل (يتم تلقائياً مع LanguageRefreshMixin)
LanguageRefreshService.instance.register(
  id: 'my_cubit',
  onRefresh: () => loadData(),
);

// الإشعار (يتم من LanguageCubit)
LanguageRefreshService.instance.notifyLanguageChanged('en');
```

### `location_refresh_service.dart`
خدمة إشعار الـ Cubits بتغيير الموقع.

```dart
LocationRefreshService.instance.notifyLocationChanged(
  countryId: 1,
  cityId: 5,
  countryName: 'مصر',
  cityName: 'القاهرة',
);
```

### `lead_management_service.dart`
إدارة إرسال الـ Leads للشركات والعقارات.

```dart
final leadService = getIt<LeadManagementService>();

// التحقق من إرسال سابق
final hasSent = await leadService.hasUserSentLeadToCompany(vendorId);

// إرسال lead للشركة
final result = await leadService.sendLeadToCompany(
  vendorId: 123,
  context: context,
  name: 'أحمد',
  countryCode: '+20',
  mobile: '1012345678',
);

// إرسال lead للعقار
final result = await leadService.sendPropertyLeadToCompany(
  propertyId: 456,
  context: context,
);
```

---

## 🛠️ Utils

### 📁 utils/animations/

| الملف | الوصف |
|-------|-------|
| `custom_animations.dart` | Animations جاهزة (slideFromBottom, fadeIn, scaleIn, etc.) |
| `custom_progress_indcator.dart` | Loading indicator مخصص مع GIF |
| `scroll_animation_widget.dart` | Widget للـ animations مع الـ scroll |

```dart
// Custom Animations
CustomAnimations.slideFromBottom(child: myWidget);
CustomAnimations.fadeIn(child: myWidget);

// Scroll Animation
ScrollAnimationWidget(
  animationType: AnimationType.fadeSlideUp,
  delay: 100,
  child: myWidget,
);

// Staggered Animation
StaggeredScrollAnimation(
  children: [widget1, widget2, widget3],
  itemDelay: 100,
);
```

### 📁 utils/common/

| الملف | الوصف |
|-------|-------|
| `custom_app_bar.dart` | AppBar مخصص مع factory constructors |
| `custom_button.dart` | زر مخصص مع gradient و loading state |
| `custom_dialog_button.dart` | زر للـ dialogs |
| `custom_dropdown.dart` | Dropdown مخصص |
| `custom_text_field.dart` | TextField مخصص |
| `image_viewer.dart` | عارض صور مع zoom و gallery |

```dart
// Custom AppBar
CustomAppBar.simple(title: 'العنوان');
CustomAppBar.withSubtitle(title: 'العنوان', subtitle: 'العنوان الفرعي');
CustomAppBar.gradient(title: 'العنوان');

// Custom Button
CustomButton(
  text: 'إرسال',
  onPressed: () {},
  isLoading: false,
  prefix: Icon(Icons.send),
);

// Image Viewer
ImageViewer(
  imageUrls: ['url1', 'url2'],
  initialIndex: 0,
);
```

### 📁 utils/constant/

| الملف | الوصف |
|-------|-------|
| `api_endpoints.dart` | Endpoints قديمة (غير مستخدمة) |
| `app_assets.dart` | مسارات الـ assets |
| `app_dimensions.dart` | أبعاد ثابتة |
| `font_manger.dart` | إدارة الخطوط |
| `image_constant.dart` | ثوابت الصور |
| `styles_manger.dart` | دوال إنشاء TextStyle |

```dart
// Font Manager
FontConstant.cairo;
FontWeightManger.bold;
FontSize.size16;

// Styles Manager
getBoldStyle(
  fontFamily: FontConstant.cairo,
  fontSize: FontSize.size18,
  color: Colors.black,
);
getRegularStyle(...);
getMediumStyle(...);
getSemiBoldStyle(...);
```

### 📁 utils/error/

| الملف | الوصف |
|-------|-------|
| `error_handler.dart` | معالج الأخطاء (معطل حالياً) |
| `error_message_translator.dart` | مترجم رسائل الأخطاء (معطل حالياً) |

### 📁 utils/formatters/

### `price_formatter.dart`
تنسيق الأسعار.

```dart
PriceFormatter.formatPrice(5000000);           // "5,000,000"
PriceFormatter.formatPrice(1500.6);            // "1,500.60"
PriceFormatter.formatPriceWithCurrency(1500, 'EGP');  // "1,500 EGP"
```

### 📁 utils/helper/

| الملف | الوصف |
|-------|-------|
| `location_helper.dart` | استخراج lat/lng من Google Maps iframe |
| `on_genrated_routes.dart` | إدارة الـ routes |

```dart
// Location Helper
final coords = LocationHelper.extractLatLngFromIframe(iframeString);
// Returns: {'lat': 30.0444, 'lng': 31.2357}

// Routes
Navigator.pushNamed(context, AppRoutes.home);
Navigator.pushNamed(context, AppRoutes.profile);
```

### 📁 utils/navigation/

### `custom_page_route.dart`
Page transitions مخصصة.

```dart
// Slide transitions
Navigator.push(context, PageRoutes.slideRight(page: MyPage()));
Navigator.push(context, PageRoutes.slideLeft(page: MyPage()));
Navigator.push(context, PageRoutes.slideUp(page: MyPage()));

// Fade & Scale
Navigator.push(context, PageRoutes.fade(page: MyPage()));
Navigator.push(context, PageRoutes.fadeScale(page: MyPage()));

// Auto (يتكيف مع RTL/LTR)
Navigator.push(context, PageRoutes.slideAuto(page: MyPage(), context: context));

// Helper functions
navigateTo(context, MyPage());
navigateBack(context, result);
```

---

### 📁 utils/theme/

### `app_colors.dart`
ألوان التطبيق.

```dart
// Primary
AppColors.primary;           // #005879
AppColors.primarySecondary;  // #01425A

// Status
AppColors.success;
AppColors.error;
AppColors.warning;
AppColors.info;

// Text
AppColors.textPrimary;
AppColors.textSecondary;
AppColors.textLight;

// Background
AppColors.scaffoldBackground;
AppColors.cardBackground;
```

### `app_theme.dart`
إعدادات الـ Theme (Light & Dark).

```dart
// في MaterialApp
MaterialApp(
  theme: AppTheme.lightTheme,
  darkTheme: AppTheme.darkTheme,
);

// Custom Colors Extension
final customColors = Theme.of(context).extension<CustomColors>()!;
customColors.cardHeaderBg;
customColors.textPrimary;
```

### 📁 utils/theme/custom_themes/

| الملف | الوصف |
|-------|-------|
| `appbar_theme.dart` | إعدادات AppBar |
| `bottom_sheet_theme.dart` | إعدادات BottomSheet |
| `checkbox_theme.dart` | إعدادات Checkbox |
| `chip_theme.dart` | إعدادات Chip |
| `elevated_button_theme.dart` | إعدادات ElevatedButton |
| `outline_button_theme.dart` | إعدادات OutlinedButton |
| `text_field_theme.dart` | إعدادات TextField |
| `text_theme.dart` | إعدادات النصوص |

### 📁 utils/widgets/

| الملف | الوصف |
|-------|-------|
| `custom_icon_button.dart` | زر أيقونة مخصص |
| `custom_image_view.dart` | عرض صور (SVG, PNG, Network) |
| `custom_search_bar.dart` | شريط بحث مخصص |
| `custom_snackbar.dart` | Snackbar مخصص (success, error, warning, info) |
| `empty_state_widget_property.dart` | Widget للحالة الفارغة |
| `lead_contact_dialog.dart` | Dialog إرسال بيانات التواصل |
| `login_prompt_widget.dart` | Widget طلب تسجيل الدخول |
| `login_required_dialog.dart` | Dialog تسجيل الدخول مطلوب |
| `logout_confirmation_dialog.dart` | Dialog تأكيد تسجيل الخروج |
| `network_image_widget.dart` | عرض صور من الشبكة مع معالجة |
| `premium_contact_bar.dart` | شريط التواصل المميز |
| `property_card_shimmer.dart` | Shimmer loading للكروت |

```dart
// Custom Snackbar
CustomSnackbar.showSuccess(context: context, message: 'تم بنجاح');
CustomSnackbar.showError(context: context, message: 'حدث خطأ');
CustomSnackbar.showWarning(context: context, message: 'تحذير');
CustomSnackbar.showInfo(context: context, message: 'معلومة');

// Custom Image View
CustomImageView(
  imagePath: 'assets/images/logo.png',
  height: 100,
  width: 100,
  fit: BoxFit.cover,
  placeholderIcon: Icons.business,
);

// Custom Search Bar
CustomSearchBar(
  hintText: 'ابحث...',
  controller: searchController,
  onChanged: (value) {},
  onFilterTap: () {},
  onMapTap: () {},
);

// Premium Contact Bar
PremiumContactBar(
  phone: '+201234567890',
  email: 'info@company.com',
  whatsapp: '+201234567890',
  vendorId: 123,
  companyName: 'اسم الشركة',
  title: 'تواصل معنا',
);

// Empty State
EmptyStateWidget(
  icon: FontAwesomeIcons.building,
  title: 'لا توجد عقارات',
  message: 'لم يتم العثور على عقارات',
);

// Shimmer Loading
PropertyCardShimmer();
PropertyCardShimmerList(itemCount: 3);
PropertyCardShimmerGrid(itemCount: 4, crossAxisCount: 2);
```

---

## 🚀 كيفية الاستخدام

### 1. التهيئة في `main.dart`
```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupServiceLocator();
  runApp(MyApp());
}
```

### 2. استخدام الـ Services
```dart
// في أي مكان
final apiService = getIt<ApiService>();
final appState = getIt<AppStateService>();
final languageCubit = getIt<LanguageCubit>();
```

### 3. استخدام الـ Responsive
```dart
Padding(
  padding: EdgeInsets.all(AppTokens.paddingMd(context)),
  child: GridView.builder(
    gridDelegate: GridConfig.vendorCardsDelegate(context),
    itemBuilder: (context, index) => PropertyCard(),
  ),
);
```

### 4. معالجة الأخطاء
```dart
final result = await apiService.safeGet<Map>('/endpoint');
result.when(
  success: (data) => emit(SuccessState(data)),
  failure: (error) => emit(ErrorState(error)),
);

// في الـ UI
if (state is ErrorState) {
  return ApiErrorWidget(
    exception: state.error,
    onRetry: () => cubit.loadData(),
  );
}
```

---

## 📝 ملاحظات مهمة

1. **الـ Responsive**: استخدم `AppTokens` و `GridConfig` بدلاً من القيم الثابتة
2. **الأخطاء**: استخدم `ApiErrorWidget` لعرض الأخطاء بشكل موحد
3. **الـ Caching**: DioClient يقوم بـ cache الـ responses لمدة 30 دقيقة
4. **الـ Tokens**: يتم تخزينها في Secure Storage
5. **اللغة**: تغيير اللغة يُحدث جميع الـ Cubits المسجلة تلقائياً

---

> **آخر تحديث**: يناير 2026
