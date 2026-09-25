import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:connectivity_wrapper/connectivity_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ready_ecommerce/components/ecommerce/offline.dart';
import 'package:ready_ecommerce/config/app_constants.dart';
import 'package:ready_ecommerce/controllers/common/master_controller.dart';
import 'package:ready_ecommerce/routes.dart';
import 'package:ready_ecommerce/services/common/hive_service_provider.dart';
import 'package:ready_ecommerce/utils/api_client.dart';
import 'package:ready_ecommerce/utils/context_less_navigation.dart';
import 'package:ready_ecommerce/views/common/onboarding/layouts/onboarding_first_screen.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

/// Set to `true` to stay on splash while iterating on visuals.
const bool kHoldOnSplashForDesign = false;

class SplashLayout extends ConsumerStatefulWidget {
  const SplashLayout({super.key});

  @override
  ConsumerState<SplashLayout> createState() => _SplashLayoutState();
}

class _SplashLayoutState extends ConsumerState<SplashLayout> {
  StreamSubscription<ConnectivityStatus>? _connectivitySub;
  late VideoPlayerController _videoController;

  bool _animationReady = false;
  bool _hasNavigated = false;
  bool _initStarted = false;

  List<dynamic>? _authPayload;

  @override
  void initState() {
    super.initState();

    _videoController = VideoPlayerController.asset('assets/splash/nilbox.mp4')
      ..initialize().then((_) {
        setState(() {});
        _videoController.setVolume(0.0);
        _videoController.play().then((_) {
          FlutterNativeSplash.remove();
        });
      });

    _videoController.addListener(_onVideoEvent);

    _connectivitySub =
        ConnectivityWrapper.instance.onStatusChange.listen(_onConnectivity);

    // Kick off if already online (listener may not re-emit).
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final connected = await ConnectivityWrapper.instance.isConnected;
      if (connected) _onConnectivity(ConnectivityStatus.CONNECTED);
    });
  }

  void _onVideoEvent() {
    if (!_videoController.value.isInitialized) return;

    if (_videoController.value.position >= _videoController.value.duration) {
      if (!_animationReady) {
        _animationReady = true;
        _tryNavigate();
      }
    }
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
          transitionDuration: Duration.zero,
          reverseTransitionDuration: Duration.zero,
        ),
      );
    }
  }

  @override
  void dispose() {
    _connectivitySub?.cancel();
    _videoController.removeListener(_onVideoEvent);
    _videoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget content = _videoController.value.isInitialized
        ? SizedBox.expand(
            child: FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                width: _videoController.value.size.width,
                height: _videoController.value.size.height,
                child: VideoPlayer(_videoController),
              ),
            ),
          )
        : const SizedBox.expand();

    if (!kIsWeb && Platform.isAndroid) {
      content = SafeArea(
        top: false,
        bottom: true,
        child: content,
      );
    }

    return ConnectivityWidgetWrapper(
      offlineWidget: const OfflineScreen(),
      child: Scaffold(
        backgroundColor: (!kIsWeb && Platform.isAndroid) ? Colors.black : Colors.white,
        body: content,
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
