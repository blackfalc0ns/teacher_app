class ApiEndpoints {
  static const String baseUrl =
      'https://newdashboard.amtalek.com/public/api/v1/mobile';

  // Auth
  static const String login = '/auth/login';
  static const String googleLogin = '/auth/google-login';
  static const String checkGoogleAuth = '/auth/check-google-authentication';
  static const String googleSignUp = '/auth/google-sign-up';
  static const String register = '/auth/register';
  static const String googleRegister = '/auth/google-register';
  static const String checkOtp = '/auth/check-otp';
  static const String logout = '/auth/logout';
  static const String refreshToken = '/auth/refresh';
  static const String resendVerification = '/auth/resend-verification';
  static const String checkOtpForgotPassword = '/auth/check-otp';
  static const String resetPassword = '/auth/reset-password';

  // Agents & Developers
  static const String getAllCompanies = '/get-all-companies';
  static const String getCompanyDetails = '/get-company-details';

  static const String addRateToVendor = '/add-rate-to-vendor';
  static const String addCompanyComments = '/get-company-comments';
  // Properties
  static const String getCompanyProperties = '/get-company-properties';
  // Projects
  static const String getCompanyProjects = '/get-company-projects';
  static const String addCompanyToWishlist = '/add-company-to-wishlist';
  static const String sendLeadToCompany = '/send-lead-to-company';
  static const String sendPropertyLeadToCompany =
      '/send-property-lead-to-company';
  static const String sendProjectLeadToCompany =
      '/send-project-lead-to-company';
  static const String sendPropertyOfferToCompany =
      '/send-property-offer-to-company';
  static const String sendPropertyMessage = '/send-property-message';
  static const String addPropertyToWishlist = '/add-property-to-wishlist';
  static const String addProjectToWishlist = '/add-project-to-wishlist';
  // Regions
  static const String getCompanyProjectsRegions =
      '/get-company-projects-regions';
  // get properties of categories for home page
  static const String getPropertiesCategories =
      '/get-home-property-categories-properties';
  // Profile
  static const String getMyProfile = '/my-profile';
  static const String updateProfile = '/update-profile';
  static const String getMyOffers = '/get-my-offers';
  static const String getMyReceivedOffers = '/get-my-recieved-offers';
  static const String getMyProperties = '/get-my-properties';
  static const String convertOfferToLead = '/convert-offer-to-lead';
  static const String getMyFavouriteProperties = '/get-my-favourite-properties';
  static const String getMyFavouriteProjects = '/get-my-favourite-projects';
  static const String getMyFavouriteVendors = '/get-my-favourite-vendors';
  static const String getMyCurrentPackage = '/my-current-package';

  // Locations
  static const String getCountries = '/country/get-countries';
  static const String getCities = '/city/get-cities';
  static const String getRegions = '/region/get-regions';
  static const String getSubRegions = '/subregion/get-sub-regions';

  // Packages
  static const String getPackages = '/package/get-packages';
  static const String checkoutPackage = '/package-api-checkout';
  static const String checkPromoCode = '/check-promocode-platform';

  // Projects
  static const String getProjectsExtraSections = '/get-projects-extra-sections';
  static const String searchProjects = '/project';
  static const String searchProjectsMap = '/search-projects-map';
  static const String getProjectSearchCriteria = '/project-search-criteria';

  // Project Details
  static String getProjectDetails(int id) => '/project/$id';
  static String getProjectDescription(int id) => '/project/$id/description';
  static String getProjectSliders(int id) => '/project/$id/sliders';
  static String getProjectSpecs(int id) => '/project/$id/specs';
  static String getProjectProperties(int id) => '/project/$id/properties';

  // Property Offers (Featured Properties)
  static const String getPropertyOffers = '/property';

  // Property Details
  static String getPropertyDetails(int id) => '/property/$id';
  static String getPropertySliders(int id) => '/property/$id/sliders';
  static String getPropertyOwner(int id) => '/property/$id/owner';
  static String getPropertySpecs(int id) => '/property/$id/specs';
  static String getPropertyDescriptions(int id) => '/property/$id/descripitons';
  static String getPropertyInputs(int id) => '/property/$id/inputs';
  static String getSimilarProperties(int id) =>
      '/get-similar-properties?property_id=$id';

  // Submit Property Settings
  static const String getPropertyPurposes = '/get-property-settings-puropse';
  static String getPropertyCategories(int purposeId) =>
      '/get-property-settings-category/$purposeId';
  static String getPropertyTypes(int categoryId) =>
      '/get-property-settings-types/$categoryId';
  static String getPropertyInputsInAddProperty(int typeId) =>
      '/get-property-settings-inputs/$typeId';
  static const String getAmenities = '/get-amenties-settings';
  static const String getFinishingTypes = '/get-finishing-settings';
  static const String getCurrencies = '/get-currencies-settings';
  static const String getReceptionTypes = '/get-reciption-types-settings';
  static const String submitProperty = '/submit-property-from-platforms';

  //Addons
  static const String getAddons = '/package/get-addons';
  static const String checkoutAddon = '/addons-api-checkout';

  // Chat
  static const String getChatContacts = '/get-chat-contacts';
  static const String getChatContactContent = '/get-chat-contact-content';
  static const String sendChatMessage = '/send-chat-message';
  static const String convertChatToLead = '/convert-chat-to-lead';
  static const String getTotalNotSeenChats = '/get-total-not-seen-chats';
  static const String seeSpecificGuestChatContent =
      '/see-specific-guest-chat-content';

  // Jobs
  static const String getJobs = '/jobs';
  static const String getJobsWorkPlaces = '/jobs-work-places';
  static const String getJobsCategories = '/jobs-categories';
  static const String getJobsTypes = '/jobs-type';
  static String getJobDetails(int id) => '/jobs/$id';
  static const String getCompanyJobDetails = '/get-company-job-details';
  static const String getCompanyJobList = '/get-company-job-list';
  static const String applyJob = '/apply-job';

  // Property Search
  static const String searchProperties = '/search-properties';
  static const String searchPropertiesMap = '/search-properties-map';
  static const String searchPropertyTypes = '/search-all-mobile-property-types';
  static const String searchPropertyInputs = '/search-mobile-property-inputs';
  static const String searchPropertyCurrencies =
      '/search-mobile-property-currencies';
  static const String searchPropertyPurpose = '/search-mobile-property-purpose';
  static const String searchPropertyFinishing =
      '/search-mobile-property-finishing';
  static const String searchMobileRegions = '/search-mobile-regions';
  static const String searchMobileAmenities = '/search-mobile-aminities';
  static const String searchMobileTags = '/search-mobile-tags';

  //Terms and conditions
  static const String getTermsAndConditions = '/terms-and-conditions';

  // Privacy Policy
  static const String getPrivacyPolicy = '/privacy-policy';

  // FAQ
  static const String getAllFaqs = '/all-faqs';
  static const String getAllPackageFaqs = '/all-package-faqs';

  // News
  static const String getNews = '/news';
  static const String getNewsCategories = '/news-category';
  static const String getNewsByCategory = '/news-category/categroy';
  static const String getNewsDetails = '/news';

  // Invoices
  static const String getPackageInvoices = '/my-packages-invoices';
  static const String getAddonInvoices = '/my-addons-invoices';

  // Project Orientation & Message
  static const String sendProjectOrientation = '/send-project-orientation';
  static const String sendProjectMessage = '/send-project-message';

  // Ads
  static String getAdsByPosition(String position) => '/get-ads-based-on-position/$position';

  // Main Sliders
  static const String mobileMainSliders = '/mobile-main-sliders-api';

  // Notifications
  static const String getMyNotifications = '/get-my-notifications';
  static const String setFcmNotification = '/set-fcm-notification';
  static const String deleteMyNotifications = '/delete-my-notifications';
  static const String seeNotificationDetails = '/see-notification-details';
  static const String myNotificationsNumber = '/my-notifications-number';
}
