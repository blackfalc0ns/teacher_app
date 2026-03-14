class ApiEndpoints {
  static String get baseUrl => 'https://teacher_app.com/api/';
  // auth
  static String get login => 'signin';
  static String get register => 'signup';
  static String get logout => 'logout';
  static String get refreshToken => 'refresh-token';
  static String get resendVerifyEmail => 'resend-verify-email';
  static String get forgetPassword => 'forget-password';
  static String get checkOtp => 'forget-password/check-otp';
  static String get changePassword => 'forget-password/change-password';
  static String get termsAndConditions => 'term-and-condition';
  //profile
  static String get myAccount => 'my-account';
  static String get updateProfile => 'update-profile';
  static String get suspendAccount => 'suspend-account';
  static String get pointsSettings => 'points/settings';
  static String get myPoints => 'my-points';
  static String get pointsTransactions => 'my-points/transactions';

  // Orders endpoints
  static String get addresses => 'addresses';
  static String addressById(int addressId) => 'addresses/$addressId';
  static String get checkPromo => 'check-promo';
  static String get checkout => 'order/checkout';
  static String get myOrders => 'my-orders';
  static String orderDetails(int orderId) => 'order-details/$orderId';
  static String cancelOrder(int orderId) => 'cancel-order/$orderId';
  static String returnOrder(int orderId) => 'return-order/$orderId';
  static String shippingCost(int addressId) => 'shipping-cost/$addressId';

  // Blog endpoints
  static String get blogCategories => 'blog-categories';
  static String blogCategoryById(int categoryId) =>
      'blog-categories/$categoryId';
  static String blogById(int blogId) => 'blogs/$blogId';
  static String addBlogComment(int blogId) => 'blogs/comment/$blogId';

  //address
  static String get countries => 'countries';
  static String get cities => 'cities/11'; // Fixed to Egypt (country_id: 11)
  static String citiesByCountry(int countryId) => 'cities/$countryId';
  static String regions(int cityId) => 'regions/$cityId';
  // Categories endpoints
  static String get mainCategories => 'main-categories';
  static String get subCategories => 'sub-categories';

  // Special offers endpoints
  static String get specialOffersProducts => 'special-offer-products';

  // Occasions endpoints
  static String get occasions => 'occasions';

  // Products endpoints
  static String get allProducts => 'get-all-products';
  static String get latestProducts => 'latest-products';
  static String get bestSellerProducts => 'best-seller-products';
  static String get featuredProducts => 'featured-products';

  // Hot deals endpoints
  static String get hotDeals => 'hot_deals';

  // Top products endpoints
  static String get topProducts => 'top_product';

  // Brands endpoints
  static String get brands => 'v2/brands';

  // Shopping/Departments endpoints
  static String get departments => 'departments';
  static String get filters => 'filters';

  // Search and filter products
  static String get searchProducts => 'get-all-products';

  // Product details endpoints
  static String get productDetails => 'spacific-product';
  static String productDetailsById(int productId) =>
      'spacific-product/$productId';

  // Product review endpoints
  static String productReview(int productId) => 'product-review/$productId';

  // Product variants keys endpoints
  static String getProductVariantsKeys(int productId) =>
      'get-product-variants-keys/$productId';

  // Sliders endpoints
  static String get sliders => 'sliders';

  // Ads endpoints
  static String ads({required String position, required String device}) =>
      'ads?position=$position&device=$device';

  // Sub-categories endpoints
  static String subCategoriesLimit({int? limit}) =>
      'sub-categories${limit != null ? '?limit=$limit' : ''}';
  // Wishlist endpoints
  static String get addToWishlist => 'wishlist/add';
  static String removeFromWishlist(int productId) =>
      'wishlist/remove/$productId';
  static String get getWishlist => 'my-wishlist';
  static String get removeAllFromWishlist => 'wishlist/remove-all';

  // Cart endpoints
  static String get addToCart => 'cart/add';
  static String get myCart => 'my-cart';
  static String removeFromCart(int cartItemId) => 'cart/remove/$cartItemId';
  static String get removeAllFromCart => 'cart/remove-all';

  // Bundles endpoints
  static String get bundleCategories => 'bundle-categories';
  static String get bundles => 'bundles';
  static String bundleById(int bundleId) => 'bundles/$bundleId';

  // quote endpoints
  static String get orderPricing => 'order/pricing';

  // Contact Us endpoint
  static String get contactUs => 'contact-us';

  // FAQ endpoint
  static String get faq => 'faq';

  // About Us endpoint
  static String get aboutUs => 'old-about-us';
}
