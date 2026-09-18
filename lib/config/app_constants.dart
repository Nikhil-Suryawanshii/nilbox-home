class AppConstants {
// Codecanyon
  static const String baseUrl = 'https://net.nilbox.net/api';
  // static const String baseUrl = 'https://devnilbox.com/api';
  // QA Testing
  //static const String baseUrl = 'https://uat.readyecommerce.app/api';
  // static const String baseUrl = 'http://chat.razinsoft.site/api';
  // Development
  // static const String baseUrl = 'https://dev.readyecommerce.app/api';
  static const String socialLogin = '$baseUrl/social-login';

  static const String settings = '$baseUrl/master';
  static const String loginUrl = '$baseUrl/login';
  static const String registrationUrl = '$baseUrl/registration';
  static const String sendOTP = '$baseUrl/send-otp';
  static const String verifyOtp = '$baseUrl/verify-otp';
  static const String resetPassword = '$baseUrl/reset-password';
  static const String changePassword = '$baseUrl/change-password';
  static const String updateProfile = '$baseUrl/update-profile';
  static const String getDashboardData = '$baseUrl/home';
  static const String getCategories = '$baseUrl/categories';
  static const String getSubCategories = '$baseUrl/sub-categories';
  static const String getShops = '$baseUrl/shops';
  static const String getFollowingShops = '$baseUrl/following-shops';

  static const String getShopDetails = '$baseUrl/shop';
  static const String updateShopFollowUnfollow = '$getShopDetails/follow-toggle';
  static const String getProducts = '$baseUrl/products';
  static const String getShopCategiries = '$baseUrl/shop-categories';
  static const String getReviews = '$baseUrl/reviews';
  static const String getCategoryWiseProducts = '$baseUrl/category-products';
  static const String getProductDetails = '$baseUrl/product-details';
  static const String productFavoriteAddRemoveUrl =
      '$baseUrl/favorite-add-or-remove';
  static const String getFavoriteProducts = '$baseUrl/favorite-products';
  static const String addAddess = '$baseUrl/address/store';
  static const String address = '$baseUrl/address';
  static const String getAddress = '$baseUrl/addresses';
  static const String addToCart = '$baseUrl/cart/store';
  static const String incrementQty = '$baseUrl/cart/increment';
  static const String decrementQty = '$baseUrl/cart/decrement';
  static const String getAllCarts = '$baseUrl/carts';
  static const String getAllGifts = '$baseUrl/gifts';
  static const String addGift = '$baseUrl/gift/store';
  static const String updateGift = '$baseUrl/gift/update';
  static const String removeGift = '$baseUrl/gift/delete';
  static const String buyNow = '$baseUrl/buy-now';
  static const String cartSummery = '$baseUrl/cart/checkout';
  static const String placeOrder = '$baseUrl/place-order';
  static const String placeOrderV1 = '$baseUrl/v1/place-order';
  static const String orderAgain = '$baseUrl/place-order/again';
  static const String buyNowOrderPlace = '$baseUrl/buy-now/place-order';
  static const String getOrders = '$baseUrl/orders';
  static const String getOrderDetails = '$baseUrl/order-details';
  static const String cancelOrder = '$baseUrl/orders/cancel';
  static const String addProductReview = '$baseUrl/product-review';
  static const String getVoucher = '$baseUrl/get-vouchers';
  static const String collectVoucher = '$baseUrl/vouchers-collect';
  static const String applyVoucher = '$baseUrl/apply-voucher';
  static const String ordePayment = '$baseUrl/order-payment';
  static const String blogs = '$baseUrl/blogs';
  static const String blogDetails = '$baseUrl/blog';

  static const String privacyPolicy = '$baseUrl/legal-pages/privacy-policy';
  static const String termsAndConditions =
      '$baseUrl/legal-pages/terms-and-conditions';
  static const String refundPolicy =
      '$baseUrl/legal-pages/return-and-refund-policy';
  static const String support = '$baseUrl/support';
  static const String contactUs = '$baseUrl/contact-us';
  static const String profileinfo = '$baseUrl/profile';

  static const String logout = '$baseUrl/logout';
  static const String flashSales = '$baseUrl/flash-sales';
  static const String flashSaleDetails = '$baseUrl/flash-sale';
  static const String allCountry = '$baseUrl/countries';
  static const String storeMessage = '$baseUrl/store-message';
  static const String getMessage = '$baseUrl/get-message';
  static const String sendMessage = '$baseUrl/send-message';
  static const String deleteChat = '$baseUrl/delete-chat';
  static const String blockSeller = '$baseUrl/block-seller';
  static const String unblockSeller = '$baseUrl/unblock-seller';


  static const String getShopsList = '$baseUrl/get-shops';
  static const String unreadMessage = '$baseUrl/unread-messages';
  static const String returnOrderSubmit = '$baseUrl/return-order';
  static const String returnHistory = '$baseUrl/return-history';
  static const String returnOrdersList = '$baseUrl/return-orders';
  static const String returnOrderDetails = '$baseUrl/return-order-details';
  static String sellerSendOTP = '$baseUrl/seller/send-otp';
  static String sellerVerifyOTP = '$baseUrl/seller/verify-otp';
  static String sellerSignUp = '$baseUrl/seller/registration';
  static String sellerLogin = '$baseUrl/seller/login';
  static String sellerForgotPassword = '$baseUrl/seller/forgot-password';
  static String sellerCheckUserStatus = '$baseUrl/seller/check-user-status';
  static String sellerCheckPhoneAndEmail = '$baseUrl/seller/check-email-phone';
  static String sellerProfileDetails = '$baseUrl/seller/details';
  static String sellerUpdateUserInfo = '$baseUrl/seller/user-update';
  static String sellerUpdateShopInfo = '$baseUrl/seller/shop-update';
  static String sellerUpdateShopSettings = '$baseUrl/seller/shop-setting-update';

  // --- Seller Dashboard & Management Endpoints (NEW) ---
  static String sellerDashboard = '$baseUrl/seller/dashboard';
  static String sellerOrders = '$baseUrl/seller/orders';
  static String sellerUpdateOrderStatus = '$baseUrl/seller/orders/status-update';
  static String sellerGetOrderDetails = '$baseUrl/seller/orders/details';
  static String sellerWalletDetails = '$baseUrl/seller/wallet';
  static String sellerWalletHistory = '$baseUrl/seller/wallet/history';
  static String sellerWithdrawWallet = '$baseUrl/seller/wallet/withdraw';
  static String sellerBanners = '$baseUrl/seller/banners';
  static String sellerUpdateBanner = '$baseUrl/seller/banners/update';
  static String sellerAddNewBanner = '$baseUrl/seller/banners/store';
  static String sellerProductMetaData = '$baseUrl/seller/product/create-data';
  static String sellerAddProduct = '$baseUrl/seller/product/store';
  static String sellerGetProducts = '$baseUrl/seller/products';
  static String sellerReturnOrders = '$baseUrl/seller/return-orders';
  // static String sellerGetProductDetails = '$baseUrl/seller/product';
  // static String sellerUpdateProduct = '$baseUrl/seller/product';
  static String sellerToggleActiveStatus = '$baseUrl/seller/product/status/toogle';
  static String sellerUpdateProduct(int id) => '$baseUrl/seller/product/$id/update';
  static String sellerGetProductDetails(int id) => '$baseUrl/seller/product/$id/show';
  static String sellerUpdateReturnOrderStatus(int id) => '$baseUrl/seller/return-order/$id/status-change';

  // --- Seller Messaging (NEW) ---
  static const String sellerStoreMessage = '$baseUrl/seller/store-message';
  static const String sellerGetMessage = '$baseUrl/seller/get-message';
  static const String sellerSendMessage = '$baseUrl/seller/send-message';
  static const String sellerGetUserList = '$baseUrl/seller/get-users';
  static const String sellerUnreadMessage = '$baseUrl/seller/unread-messages';
  static const String sellerPosts = '$baseUrl/seller/posts';

  // dynamic url based on the service name
  static String getDashboardInfoUrl(String serviceName) =>
      '$baseUrl/api/$serviceName/store/dashoard';

  // hive constants

  // Box Names
  static const String appSettingsBox = 'appSettings';
  static const String authBox = 'laundrySeller_authBox';
  static const String userBox = 'laundrySeller_userBox';
  static const String cartModelBox = 'hive_cart_model_box';
  // static const String sellerAuthBox = 'readySeller_authBox'; // Seller Auth (NEW)
  // static const String sellerUserBox = 'readySeller_userBox'; // Seller Data (NEW)
  static const String sellerAuthBox = 'laundrySeller_authBox'; // Seller Auth (NEW)
  static const String sellerUserBox = 'laundrySeller_userBox'; // Seller Data (NEW)

  // Settings Veriable Names
  static const String firstOpen = 'firstOpen';
  static const String appLocal = 'appLocal';
  static const String isDarkTheme = 'isDarkTheme';
  static const String primaryColor = 'primaryColor';
  static const String appLogo = 'appLogo';
  static const String appName = 'appName';
  static const String splashLogo = 'splashLogo';
  static const String sellerAuthToken = 'seller_token'; // NEW
  static const String phone = 'phone'; // From seller app constants

  // Auth Variable Names
  static const String authToken = 'token';

  // User Variable Names
  static const String userData = 'userData';
  static const String sellerData = 'sellerData'; // NEW
  static const String storeData = 'storeData';
  static const String cartData = 'cartData';
  static const String defaultAddress = 'defaultAddress';

  static String appCurrency = "\$";
  static String appServiceName = 'ecommerce';

  /// Temporary: set to false to restore API-driven home banners.
  static const bool useStaticHomeBanner = true;

  static String pusherApiKey = 'a3cbadc04a202a7746fc'; 
  static String sellerPusherApiKey = '0f2222c2748df3ad45ba'; // NEW
  static String pusherCluster = 'mt1';
  static String sellerPusherCluster = 'ap2'; // NEW
}

enum FileSystem {
  file,
  image,
}
