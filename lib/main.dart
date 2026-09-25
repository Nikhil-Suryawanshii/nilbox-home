// import 'package:connectivity_wrapper/connectivity_wrapper.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_downloader/flutter_downloader.dart';
// import 'package:flutter_localizations/flutter_localizations.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:hive_flutter/hive_flutter.dart';
// import 'package:ready_ecommerce/config/app_color.dart';
// import 'package:ready_ecommerce/config/app_constants.dart';
// import 'package:ready_ecommerce/config/theme.dart';
// import 'package:ready_ecommerce/firebase_options.dart';
// import 'package:ready_ecommerce/generated/l10n.dart';
// import 'package:ready_ecommerce/models/eCommerce/cart/hive_cart_model.dart';
// import 'package:ready_ecommerce/routes.dart';
// import 'package:ready_ecommerce/utils/global_function.dart';
// import 'package:ready_ecommerce/utils/notification_handler.dart';
// import 'package:ready_ecommerce/views/common/splash/layouts/splash_layout.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//   );
//   await setupFlutterNotifications();
//   FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
//   firebaseMessagingForgroundHandler();
//   String? fcmToken = await FirebaseMessaging.instance.getToken();
//   debugPrint("FCM Token: $fcmToken");
//   await FlutterDownloader.initialize(
//     debug: true,
//     ignoreSsl: false,
//   );

//   await Hive.initFlutter();
//   await Hive.openBox(AppConstants.appSettingsBox);
//   await Hive.openBox(AppConstants.userBox);
//   Hive.registerAdapter(HiveCartModelAdapter());

//   await Hive.openBox<HiveCartModel>(AppConstants.cartModelBox);
//   runApp(const ProviderScope(child: MyApp()));
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   Locale resolveLocal({required String langCode}) {
//     return Locale(langCode);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return ScreenUtilInit(
//       designSize: const Size(390, 844), // XD Design Sizes
//       minTextAdapt: true,
//       splitScreenMode: true,
//       useInheritedMediaQuery: false,
//       builder: (context, child) {
//         return ValueListenableBuilder(
//             valueListenable: Hive.box(AppConstants.appSettingsBox).listenable(),
//             builder: (context, box, _) {
//               final isDark = box.get(AppConstants.isDarkTheme,
//                   defaultValue: false) as bool;
//               final primaryColor = box.get(AppConstants.primaryColor);
//               if (primaryColor != null) {
//                 EcommerceAppColor.primary = hexToColor(primaryColor);
//               }
//               GlobalFunction.changeStatusBarTheme(isDark: isDark);
//               final appLocal = box.get(AppConstants.appLocal);
//               return ConnectivityAppWrapper(
//                 app: MaterialApp(
//                   showPerformanceOverlay: false,
//                   debugShowCheckedModeBanner: false,
//                   title: 'Ready eCommerce',
//                   navigatorKey: GlobalFunction.navigatorKey,
//                   locale: resolveLocal(langCode: appLocal ?? 'en'),
//                   localizationsDelegates: const [
//                     S.delegate,
//                     GlobalMaterialLocalizations.delegate,
//                     GlobalWidgetsLocalizations.delegate,
//                     GlobalCupertinoLocalizations.delegate,
//                   ],
//                   supportedLocales: S.delegate.supportedLocales,
//                   theme: getAppTheme(context: context, isDarkTheme: isDark),
//                   onGenerateRoute: generatedRoutes,
//                   initialRoute: Routes.splash,
//                   builder: (context, child) {
//                     // add safety wrapper
//                     return Column(
//                       children: [
//                         Expanded(
//                           child: child ?? const SplashLayout(),
//                         ),
//                         Container(
//                           color: isDark
//                               ? EcommerceAppColor.black
//                               : EcommerceAppColor.white,
//                           height: MediaQuery.of(context).padding.bottom,
//                         )
//                       ],
//                     );
//                   },
//                 ),
//               );
//             });
//       },
//     );
//   }
// }
///-----------
import 'dart:io';
import 'package:connectivity_wrapper/connectivity_wrapper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ready_ecommerce/config/app_color.dart';
import 'package:ready_ecommerce/config/app_constants.dart';
import 'package:ready_ecommerce/config/theme.dart';
import 'package:ready_ecommerce/firebase_options.dart';
import 'package:ready_ecommerce/generated/l10n.dart';
import 'package:ready_ecommerce/models/eCommerce/cart/hive_cart_model.dart';
import 'package:ready_ecommerce/routes.dart';
import 'package:ready_ecommerce/utils/global_function.dart';
import 'package:ready_ecommerce/utils/notification_handler.dart';
import 'package:ready_ecommerce/views/common/splash/layouts/splash_layout.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   // await Firebase.initializeApp(
//   //   options: DefaultFirebaseOptions.currentPlatform,
//   // );
//   if (!kIsWeb) {
//     await Firebase.initializeApp(
//       options: DefaultFirebaseOptions.currentPlatform,
//     );
//   }
//
//   await setupFlutterNotifications();
//   FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
//   firebaseMessagingForgroundHandler();
//  String? fcmToken;
//   try {
//     fcmToken = await FirebaseMessaging.instance.getToken();
//     debugPrint("FCM Token: $fcmToken");
//   } catch (e) {
//     debugPrint("Error getting FCM token: $e");
//   }
//
//   debugPrint("FCM Token: $fcmToken");
//   await FlutterDownloader.initialize(
//     debug: true,
//     ignoreSsl: false,
//   );
//
//   await Hive.initFlutter();
//   await Hive.openBox(AppConstants.appSettingsBox);
//   await Hive.openBox(AppConstants.userBox);
//   await Hive.openBox(AppConstants.sellerAuthBox);
//   await Hive.openBox(AppConstants.sellerUserBox);
//   Hive.registerAdapter(HiveCartModelAdapter());
//
//   await Hive.openBox<HiveCartModel>(AppConstants.cartModelBox);
//   runApp(const ProviderScope(child: MyApp()));
// }
import 'package:flutter_native_splash/flutter_native_splash.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  /// 🔥 FIREBASE (ONLY MOBILE)
  if (!kIsWeb) {
    try {
      if (Firebase.apps.isEmpty) {
        await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        );
      }

      await setupFlutterNotifications();

      FirebaseMessaging.onBackgroundMessage(
        firebaseMessagingBackgroundHandler,
      );

      firebaseMessagingForgroundHandler();

      try {
        final fcmToken = await FirebaseMessaging.instance.getToken();
        debugPrint("FCM Token: $fcmToken");
      } catch (e) {
        debugPrint("Error getting FCM token: $e");
      }

      await FlutterDownloader.initialize(
        debug: true,
        ignoreSsl: false,
      );
    } catch (e) {
      debugPrint("Mobile startup init error: $e");
    }
  }

  /// 📦 HIVE (WEB + MOBILE SAFE)
  await Hive.initFlutter();
  await Hive.openBox(AppConstants.appSettingsBox);
  await Hive.openBox(AppConstants.userBox);
  await Hive.openBox(AppConstants.sellerAuthBox);
  await Hive.openBox(AppConstants.sellerUserBox);

  Hive.registerAdapter(HiveCartModelAdapter());
  await Hive.openBox<HiveCartModel>(AppConstants.cartModelBox);

  if (!kIsWeb && Platform.isAndroid) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.black,
      systemNavigationBarIconBrightness: Brightness.light, 
    ));
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom]);
  }

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Locale resolveLocal({required String langCode}) {
    return Locale(langCode);
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844), // XD Design Sizes
      minTextAdapt: true,
      splitScreenMode: true,
      useInheritedMediaQuery: false,
      builder: (context, child) {
        return ValueListenableBuilder(
            valueListenable: Hive.box(AppConstants.appSettingsBox).listenable(),
            builder: (context, box, _) {
              final isDark = box.get(AppConstants.isDarkTheme,
                  defaultValue: false) as bool;
              final primaryColor = box.get(AppConstants.primaryColor);
              if (primaryColor != null) {
                EcommerceAppColor.primary = hexToColor(primaryColor);
              }
              GlobalFunction.changeStatusBarTheme(isDark: isDark);
              final appLocal = box.get(AppConstants.appLocal);
              return ConnectivityAppWrapper(
                app: MaterialApp(
                  showPerformanceOverlay: false,
                  debugShowCheckedModeBanner: false,
                  title: 'Ready eCommerce',
                  navigatorKey: GlobalFunction.navigatorKey,
                  locale: resolveLocal(langCode: appLocal ?? 'en'),
                  localizationsDelegates: const [
                    S.delegate,
                    GlobalMaterialLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate,
                    GlobalCupertinoLocalizations.delegate,
                  ],
                  navigatorObservers: [routeObserver],//for product back button to fetch all product on home page
                  supportedLocales: S.delegate.supportedLocales,
                  theme: getAppTheme(context: context, isDarkTheme: isDark),
                  onGenerateRoute: generatedRoutes,
                  initialRoute: Routes.splash,
                  builder: (context, child) {
                    return child ?? const SplashLayout();
                  },
                ),
              );
            });
      },
    );
  }
}

