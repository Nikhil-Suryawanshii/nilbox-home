import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity_wrapper/connectivity_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ready_ecommerce/components/ecommerce/offline.dart';
import 'package:ready_ecommerce/config/app_color.dart';
import 'package:ready_ecommerce/config/app_constants.dart';
import 'package:ready_ecommerce/controllers/common/master_controller.dart';
import 'package:ready_ecommerce/routes.dart';
import 'package:ready_ecommerce/services/common/hive_service_provider.dart';
import 'package:ready_ecommerce/utils/api_client.dart';
import 'package:ready_ecommerce/utils/context_less_navigation.dart';
import 'package:ready_ecommerce/views/common/onboarding/layouts/onboarding_first_screen.dart';

/// Set to `true` to stay on splash while iterating on visuals.
const bool kHoldOnSplashForDesign = false;

class SplashLayout extends ConsumerStatefulWidget {
  const SplashLayout({super.key});

  @override
  ConsumerState<SplashLayout> createState() => _SplashLayoutState();
}

class _SplashLayoutState extends ConsumerState<SplashLayout>
    with TickerProviderStateMixin {
  static const _nilboxOrange = EcommerceAppColor.carrotOrange;
  static const _localLogo = 'assets/splash/nilbox_logo.png';

  StreamSubscription<ConnectivityStatus>? _connectivitySub;
  late final AnimationController _progressController;
  late final AnimationController _successController;

  Timer? _loadingStartTimer;
  Timer? _navigateAfterSuccessTimer;

  bool _showLoading = false;
  bool _showSuccess = false;
  bool _animationReady = false;
  bool _hasNavigated = false;
  bool _initStarted = false;

  List<dynamic>? _authPayload;

  @override
  void initState() {
    super.initState();

    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..addStatusListener(_onProgressStatus);

    _successController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _connectivitySub =
        ConnectivityWrapper.instance.onStatusChange.listen(_onConnectivity);

    // Kick off if already online (listener may not re-emit).
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final connected = await ConnectivityWrapper.instance.isConnected;
      if (connected) _onConnectivity(ConnectivityStatus.CONNECTED);
    });

    _loadingStartTimer = Timer(const Duration(milliseconds: 2500), () {
      if (!mounted || _showLoading) return;
      setState(() => _showLoading = true);
      _progressController.forward(from: 0);
    });
  }

  void _onProgressStatus(AnimationStatus status) {
    if (status != AnimationStatus.completed || !mounted) return;
    setState(() => _showSuccess = true);
    _successController.forward(from: 0).whenComplete(() {
      if (!mounted) return;
      _animationReady = true;
      _navigateAfterSuccessTimer = Timer(const Duration(milliseconds: 450), () {
        _tryNavigate();
      });
    });
  }

  void _onConnectivity(ConnectivityStatus event) {
    if (event != ConnectivityStatus.CONNECTED || _initStarted) return;
    _initStarted = true;
    _bootstrapApp();
  }

  Future<void> _bootstrapApp() async {
    try {
      final response =
          await ref.read(masterControllerProvider.notifier).getMasterData();
      final hive = ref.read(hiveServiceProvider);

      if (response?.data.themeColors.primaryColor != null) {
        await hive.setPrimaryColor(
            color: response!.data.themeColors.primaryColor);
      }
      if (response?.data.appLogo != null) {
        await hive.setAppLogo(logo: response!.data.appLogo);
      }
      if (response?.data.appName != null) {
        await hive.setAppName(name: response!.data.appName);
      }
      if (response?.data.splashLogo != null) {
        await hive.setSplashLogo(splashLogo: response!.data.splashLogo);
      }

      _authPayload = await hive.loadTokenAndUser();
    } catch (_) {
      // Still allow splash to finish; navigation uses whatever auth we have.
      _authPayload ??= await ref.read(hiveServiceProvider).loadTokenAndUser();
    }

    if (!mounted) return;
    _tryNavigate();
  }

  void _tryNavigate() {
    if (kHoldOnSplashForDesign) return;
    if (_hasNavigated || !mounted) return;
    if (!_animationReady || _authPayload == null) return;

    _hasNavigated = true;
    final data = _authPayload!;
    final firstOpen = data[0] == true;
    final token = data[1];
    final user = data[2];

    if (firstOpen && (token == null || user == null)) {
      context.nav.pushNamedAndRemoveUntil(
        Routes.getCoreRouteName(AppConstants.appServiceName),
        (route) => false,
      );
    } else if (token != null && user != null) {
      ref.read(apiClientProvider).updateToken(token: token);
      context.nav.pushNamedAndRemoveUntil(
        Routes.getCoreRouteName(AppConstants.appServiceName),
        (route) => false,
      );
    } else {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              const OnboardingFirst(),
          transitionDuration: const Duration(milliseconds: 600),
          barrierColor: Colors.black.withValues(alpha: 0.5),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final offsetAnimation = animation.drive(
              Tween(begin: const Offset(0.0, 1.0), end: Offset.zero),
            );
            return SlideTransition(position: offsetAnimation, child: child);
          },
        ),
      );
    }
  }

  String _loadingMessage(double progress) {
    if (progress >= 1.0) return 'All Set!';
    if (progress >= 0.75) return 'Just a moment...';
    if (progress >= 0.40) return 'Almost there...';
    return 'Getting things ready...';
  }

  @override
  void dispose() {
    _connectivitySub?.cancel();
    _loadingStartTimer?.cancel();
    _navigateAfterSuccessTimer?.cancel();
    _progressController.removeStatusListener(_onProgressStatus);
    _progressController.dispose();
    _successController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ConnectivityWidgetWrapper(
      offlineWidget: const OfflineScreen(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final w = constraints.maxWidth;
              final h = constraints.maxHeight;
              final productSize = (w * 0.22).clamp(64.0, 110.0);

              return Stack(
                children: [
                  // Products
                  _SplashProduct(
                    asset: 'assets/splash/headphones.png',
                    left: w * 0.08,
                    top: h * 0.28,
                    size: productSize,
                    enterDelay: 1000.ms,
                    floatAmplitude: 7,
                    floatDuration: 2200.ms,
                    rotateBegin: -0.04,
                  ),
                  _SplashProduct(
                    asset: 'assets/splash/shoe.png',
                    right: w * 0.08,
                    top: h * 0.26,
                    size: productSize * 1.05,
                    enterDelay: 1200.ms,
                    floatAmplitude: 5,
                    floatDuration: 2500.ms,
                    rotateBegin: 0.05,
                  ),
                  _SplashProduct(
                    asset: 'assets/splash/smartwatch.png',
                    left: (w - productSize * 0.9) / 2,
                    top: h * 0.38,
                    size: productSize * 0.9,
                    enterDelay: 1400.ms,
                    floatAmplitude: 6,
                    floatDuration: 2300.ms,
                    rotateBegin: -0.02,
                  ),
                  _SplashProduct(
                    asset: 'assets/splash/shopping_bag.png',
                    left: w * 0.10,
                    top: h * 0.48,
                    size: productSize * 0.95,
                    enterDelay: 1600.ms,
                    floatAmplitude: 7,
                    floatDuration: 2600.ms,
                    rotateBegin: 0.03,
                  ),
                  _SplashProduct(
                    asset: 'assets/splash/sunglasses.png',
                    right: w * 0.10,
                    top: h * 0.47,
                    size: productSize * 0.92,
                    enterDelay: 1800.ms,
                    floatAmplitude: 6,
                    floatDuration: 2400.ms,
                    rotateBegin: -0.05,
                  ),
                  _SplashProduct(
                    asset: 'assets/splash/perfume.png',
                    left: (w - productSize * 0.85) / 2,
                    top: h * 0.57,
                    size: productSize * 0.85,
                    enterDelay: 2000.ms,
                    floatAmplitude: 5,
                    floatDuration: 2700.ms,
                    rotateBegin: 0.02,
                  ),
                  _SplashProduct(
                    asset: 'assets/splash/nilbox_box.png',
                    left: (w - productSize * 1.05) / 2,
                    top: h * 0.66,
                    size: productSize * 1.05,
                    enterDelay: 2200.ms,
                    floatAmplitude: 4,
                    floatDuration: 2800.ms,
                    rotateBegin: 0,
                  ),

                  // Logo + tagline
                  Positioned(
                    top: h * 0.06,
                    left: 24,
                    right: 24,
                    child: Column(
                      children: [
                        const _SplashLogo(localAsset: _localLogo)
                            .animate()
                            .fadeIn(duration: 450.ms, curve: Curves.easeOut)
                            .scale(
                              begin: const Offset(0.85, 0.85),
                              end: const Offset(1, 1),
                              duration: 500.ms,
                              curve: Curves.easeOut,
                            ),
                        SizedBox(height: 12.h),
                        Text(
                          'SHOP • DISCOVER • LIVE',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Mulish',
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 2.2,
                            color: Colors.black.withValues(alpha: 0.72),
                          ),
                        )
                            .animate(delay: 500.ms)
                            .fadeIn(duration: 400.ms, curve: Curves.easeOut)
                            .moveY(
                              begin: 12,
                              end: 0,
                              duration: 450.ms,
                              curve: Curves.easeOut,
                            ),
                      ],
                    ),
                  ),

                  // Loading / success
                  Positioned(
                    left: w * 0.18,
                    right: w * 0.18,
                    bottom: h * 0.06,
                    child: AnimatedOpacity(
                      opacity: _showLoading ? 1 : 0,
                      duration: const Duration(milliseconds: 350),
                      child: _showSuccess
                          ? _SplashSuccess(controller: _successController)
                          : AnimatedBuilder(
                              animation: _progressController,
                              builder: (context, _) {
                                final progress = _progressController.value;
                                return _SplashLoading(
                                  progress: progress,
                                  message: _loadingMessage(progress),
                                  accent: _nilboxOrange,
                                );
                              },
                            ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _SplashLogo extends StatelessWidget {
  const _SplashLogo({required this.localAsset});

  final String localAsset;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Hive.box(AppConstants.appSettingsBox).listenable(),
      builder: (context, settingsBox, _) {
        final String? splashLogo = settingsBox.get(AppConstants.splashLogo);
        if (splashLogo != null && splashLogo.isNotEmpty) {
          return CachedNetworkImage(
            imageUrl: splashLogo,
            height: 56.h,
            fit: BoxFit.contain,
            errorWidget: (_, __, ___) => Image.asset(
              localAsset,
              height: 56.h,
              fit: BoxFit.contain,
            ),
          );
        }
        return Image.asset(
          localAsset,
          height: 56.h,
          fit: BoxFit.contain,
        );
      },
    );
  }
}

class _SplashProduct extends StatelessWidget {
  const _SplashProduct({
    required this.asset,
    required this.size,
    required this.enterDelay,
    required this.floatAmplitude,
    required this.floatDuration,
    this.left,
    this.right,
    this.top,
    this.rotateBegin = 0,
  });

  final String asset;
  final double size;
  final Duration enterDelay;
  final double floatAmplitude;
  final Duration floatDuration;
  final double? left;
  final double? right;
  final double? top;
  final double rotateBegin;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: left,
      right: right,
      top: top,
      child: Animate(
        delay: enterDelay + 500.ms,
        onPlay: (controller) => controller.repeat(reverse: true),
        effects: [
          MoveEffect(
            begin: Offset(0, -floatAmplitude),
            end: Offset(0, floatAmplitude),
            duration: floatDuration,
            curve: Curves.easeInOut,
          ),
        ],
        child: Image.asset(
          asset,
          width: size,
          height: size,
          fit: BoxFit.contain,
          filterQuality: FilterQuality.medium,
        )
            .animate(delay: enterDelay)
            .fadeIn(duration: 420.ms, curve: Curves.easeOut)
            .scale(
              begin: const Offset(0.75, 0.75),
              end: const Offset(1, 1),
              duration: 480.ms,
              curve: Curves.easeOutCubic,
            )
            .moveY(begin: 18, end: 0, duration: 480.ms, curve: Curves.easeOut)
            .rotate(
              begin: rotateBegin,
              end: 0,
              duration: 480.ms,
              curve: Curves.easeOut,
            ),
      ),
    );
  }
}

class _SplashLoading extends StatelessWidget {
  const _SplashLoading({
    required this.progress,
    required this.message,
    required this.accent,
  });

  final double progress;
  final String message;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: progress.clamp(0.0, 1.0),
            minHeight: 3.5,
            backgroundColor: Colors.black.withValues(alpha: 0.08),
            valueColor: AlwaysStoppedAnimation<Color>(accent),
          ),
        ),
        SizedBox(height: 12.h),
        Text(
          message,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Mulish',
            fontSize: 13.sp,
            fontWeight: FontWeight.w500,
            color: Colors.black.withValues(alpha: 0.55),
          ),
        ),
      ],
    );
  }
}

class _SplashSuccess extends StatelessWidget {
  const _SplashSuccess({required this.controller});

  final AnimationController controller;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        final curved = CurvedAnimation(
          parent: controller,
          curve: Curves.elasticOut,
        );
        return Opacity(
          opacity: controller.value.clamp(0.0, 1.0),
          child: Transform.scale(
            scale: curved.value.clamp(0.0, 1.2),
            child: child,
          ),
        );
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 44.r,
            height: 44.r,
            decoration: const BoxDecoration(
              color: EcommerceAppColor.carrotOrange,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.check_rounded, color: Colors.white, size: 26.r),
          ),
          SizedBox(height: 10.h),
          Text(
            'All Set!',
            style: TextStyle(
              fontFamily: 'Mulish',
              fontSize: 15.sp,
              fontWeight: FontWeight.w700,
              color: Colors.black.withValues(alpha: 0.85),
            ),
          ),
        ],
      ),
    );
  }
}

Color hexToColor(String hexString) {
  final buffer = StringBuffer();
  if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
  buffer.write(hexString.replaceFirst('#', ''));
  return Color(int.parse(buffer.toString(), radix: 16));
}
